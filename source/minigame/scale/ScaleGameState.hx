package minigame.scale;

import MmStringTools.*;
import critter.Critter;
import critter.CritterHolder;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxDestroyUtil;
import kludge.FlxSoundKludge;
import kludge.LateFadingFlxParticle;
import minigame.scale.ScaleAgent;
import minigame.scale.ScaleScoreboard;
import openfl.utils.Object;

/**
 * The FlxState for the scale minigame.
 *
 * The scale game lasts about 5-10 rounds. During each round, the player races
 * other Pokemon to arrange 3-6 bugs on scales to get the two sides to balance.
 * You're awarded points for 1st, 2nd or 3rd, and the first person to reach
 * 1,000 points is the winner.
 */
class ScaleGameState extends MinigameState
{
	public static var BALANCE_DURATION = 3.6;

	public static var TARGET_SCORE:Int = 1000;

	private var _whumpClouds:FlxEmitter;
	private var _scale:Scale;

	public var _answerOkGroup:FlxTypedGroup<LateFadingFlxParticle>;
	private var _puzzle:ScalePuzzle;
	private var _releaseTimer:Float = 0;
	private var _crucialCritters:Array<Critter> = [];
	private var _lightsManager:LightsManager;

	public var _scalePlayerStatus:ScalePlayerStatus;
	public var _agentSprites:Array<FlxSprite> = [];
	private var _clockToggle:Array<Float> = [];

	private var _canClickCritters:Bool = false;
	private var _scaleScoreboard:ScaleScoreboard;
	private var _speedupTimer:Float = 0;

	private var _countdownSprite:CountdownSprite;
	private var _roundNumber:Int = 0;
	private var _puzzleArea:FlxRect = FlxRect.get(45, 292, 642, 113);

	public function new()
	{
		super();
		description = PlayerData.MINIGAME_DESCRIPTIONS[0];
		duration = 3.0;
		avgReward = 1000;
	}

	override public function create():Void
	{
		super.create();
		Critter.shuffleCritterColors();
		setState(100);

		_lightsManager = new LightsManager();

		for (i in 0...10)
		{
			var critter = new Critter(100 + 40 * i, 550, _backdrop);
			critter.setColor(Critter.CRITTER_COLORS[FlxG.random.int(0, 4)]);
			addCritter(critter);
		}

		_scalePlayerStatus = new ScalePlayerStatus();
		_scalePlayerStatus._doneCallback = playerFinished;

		_scale = new Scale();

		_puzzle = ScalePuzzleDatabase.randomPuzzle();
		preparePuzzleAndCritters();

		_backSprites.add(_scale);
		_whumpClouds = new FlxEmitter(0, 0, 37);
		for (i in 0..._whumpClouds.maxSize)
		{
			var particle:FlxParticle = new FlxParticle();
			particle.loadGraphic(AssetPaths.poofs__png, true, 40, 40);
			particle.flipX = FlxG.random.bool();
			particle.animation.frameIndex = FlxG.random.int(0, particle.animation.numFrames);
			particle.exists = false;
			_whumpClouds.add(particle);
		}
		_whumpClouds.launchMode = FlxEmitterMode.SQUARE;
		_whumpClouds.velocity.start.set(new FlxPoint(-200, -100), new FlxPoint(200, 50));
		_whumpClouds.alpha.start.set(0.5, 1.0);
		_whumpClouds.alpha.end.set(0);
		_whumpClouds.lifespan.set(0.25, 0.5);
		_whumpClouds.start(false, 1.0, 0x0FFFFFFF);
		_whumpClouds.emitting = false;
		_backSprites.add(_whumpClouds);

		_shadowGroup._extraShadows.push(_scale._scaleShadow);

		_hud.add(_lightsManager._spotlights);

		_scaleScoreboard = new ScaleScoreboard(this);
		_hud.add(_scaleScoreboard);
		_scaleScoreboard.exists = false;

		for (i in 0..._scalePlayerStatus._agents.length)
		{
			var agentSprite:FlxSprite = new FlxSprite(2, 2);
			if (i == 0)
			{
				/*
				 * one might expect "unique" to guarantee stamping doesn't gunk up the original sprite;
				 * but other references to empty_chat will have hands stamped on them unless we set a key
				 */
				agentSprite.loadGraphic(_scalePlayerStatus._agents[i]._chatAsset, true, 73, 71, false, "A92CP7AE95");
			}
			else
			{
				agentSprite.loadGraphic(_scalePlayerStatus._agents[i]._chatAsset, true, 73, 71);
			}
			agentSprite.scale.x = 0.55;
			agentSprite.scale.y = 0.55;
			agentSprite.updateHitbox();
			agentSprite.animation.frameIndex = 4;
			if (i == 0)
			{
				agentSprite.animation.frameIndex = 1;
				agentSprite.stamp(_handSprite, -50, -70);
			}
			_hud.add(agentSprite);
			_agentSprites.push(agentSprite);
		}

		updateAgentSpritePositions();

		for (i in 0..._scalePlayerStatus._agents.length)
		{
			_hud.add(new ScaleFrame(_agentSprites[i], _scalePlayerStatus._agents[i]));
		}

		_answerOkGroup = new FlxTypedGroup<LateFadingFlxParticle>();
		_answerOkGroup.maxSize = 1;

		for (i in 0..._answerOkGroup.maxSize)
		{
			var sprite:LateFadingFlxParticle = new LateFadingFlxParticle();
			sprite.loadGraphic(AssetPaths.clue_checkmark__png, true, 64, 64);
			sprite.exists = false;
			_answerOkGroup.add(sprite);
		}
		_countdownSprite = new CountdownSprite();
		_hud.add(_countdownSprite);

		_hud.add(_answerOkGroup);
		_hud.add(_cashWindow);
		_hud.add(_dialogger);
		_hud.add(_helpButton);

		if (PlayerData.minigameCount[0] == 0)
		{
			// start tutorial
			setState(79);
		}
	}

	/**
	 * @return The dialog class which handles when the user clicks the help button
	 */
	override public function getMinigameOpponentDialogClass():Class<Dynamic>
	{
		return _scalePlayerStatus._agents[1]._dialogClass;
	}

	function updateAgentSpritePositions()
	{
		if (_gameState <= 200 || _gameState >= 400)
		{
			var orderedAgents:Array<ScaleAgent> = _scalePlayerStatus._agents.copy();
			orderedAgents.sort(function(a, b)
			{
				if (a._finishedOrder != b._finishedOrder)
					return a._finishedOrder - b._finishedOrder;
				return _scalePlayerStatus._agents.indexOf(a) - _scalePlayerStatus._agents.indexOf(b);
			});
			for (i in 0...orderedAgents.length)
			{
				var agentSprite:FlxSprite = _agentSprites[_scalePlayerStatus._agents.indexOf(orderedAgents[i])];
				agentSprite.x = 3;
				agentSprite.y = 3 + 42 * i;
			}
			for (i in 1..._scalePlayerStatus._agents.length)
			{
				if (_gameState == 190)
				{
					_agentSprites[i].animation.frameIndex = 4;
				}
				else if (_scalePlayerStatus._agents[i]._finishedOrder == 1)
				{
					_agentSprites[i].animation.frameIndex = 2;
				}
				else if (_scalePlayerStatus._agents[i]._finishedOrder < ScaleAgent.UNFINISHED)
				{
					_agentSprites[i].animation.frameIndex = 4;
				}
				else
				{
					_agentSprites[i].animation.frameIndex = 6;
				}
			}
		}
	}

	/**
	 * The game state progresses through several states:
	 *
	 * 79-89: tutorial
	 * 100: pregame
	 * 190: countdown
	 * 200: playing
	 * 300: displaying scoreboard
	 * 400: displaying end-game scoreboard
	 * 500: skip minigame
	 */
	override public function update(elapsed:Float):Void
	{
		if (_gameState == 81 && _eventStack._alive)
		{
			// during tutorials, don't let them dismiss if events are playing
			_dialogger._canDismiss = false;
		}
		else {
			_dialogger._canDismiss = true;
		}

		if (_gameState == 200)
		{
			_scalePlayerStatus.update(elapsed);
		}
		updateClock(elapsed);

		if (_gameState == 190)
		{
			// countdown
			if (!_countdownSprite.exists)
			{
				_countdownSprite.startCount();
				_canClickCritters = false;
			}
			if (_countdownSprite.animation.frameIndex == 3)
			{
				_canClickCritters = true;
				setState(200);
				updateAgentSpritePositions();
				setScaleVisible(true);
			}
		}
		if (_gameState == 200 || _gameState == 82)
		{
			if (_scalePlayerStatus._agents[0].isDone())
			{
				_speedupTimer -= elapsed;
				if (_speedupTimer < 0)
				{
					// player is done; make everyone else finish quickly
					for (i in 0...5)
					{
						_scalePlayerStatus.update(elapsed);
						updateClock(elapsed);
					}
				}
			}

			if (_releaseTimer > 0)
			{
				_releaseTimer -= elapsed;
				if (_releaseTimer <= 0)
				{
					if (_scale.getCritterCount() == _puzzle._totalPegCount)
					{
						// solved
						humanSolvedPuzzle();
						if (_gameState == 82)
						{
							// you don't keep your 200 points
							_scalePlayerStatus._roundScores[0] = 0;

							// progress to the next part of the tutorial
							var tree:Array<Array<Object>> = TutorialDialog.scaleGamePartTwo();
							_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
							_dialogTree.go();
							_eventStack.addEvent({time:_eventStack._time + 0.8, callback:eventSetState, args:[84]});
						}
					}
					else
					{
						// balanced, but didn't use all the critters
						var eventTime:Float = _eventStack._time + 0.1;

						var unusedCritter:Critter = null;
						for (critter in _crucialCritters)
						{
							if (findPad(critter) == null)
							{
								unusedCritter = critter;
							}
						}

						_eventStack.addEvent({time:eventTime, callback:EventStack.eventPlaySound, args:[AssetPaths.clue_bad_00ff__mp3]});
						_eventStack.addEvent({time:eventTime, callback:eventAnswerOk, args:[0, false]});

						if (unusedCritter != null)
						{
							_eventStack.addEvent({time:eventTime, callback:_lightsManager.eventLightsDim});
							_eventStack.addEvent({time:eventTime, callback:eventCreateCritterSpotlight, args:[unusedCritter, "wrongCritter"]});
							_eventStack.addEvent({time:eventTime, callback:_lightsManager.eventSpotlightOn, args:["wrongCritter"]});
							_eventStack.addEvent({time:eventTime + 1.5, callback:_lightsManager.eventLightsOn});
							_eventStack.addEvent({time:eventTime + 2.1, callback:eventDeleteCritterSpotlight, args:["wrongCritter"]});
						}
					}
				}
			}
		}

		super.update(elapsed);

		if (_gameState == 200)
		{
			if (_scalePlayerStatus.isRoundOver())
			{
				var eventTime:Float = _eventStack._time + 0.1;
				if (!_scalePlayerStatus._agents[0].isDone())
				{
					if (_scale.getCritterCount() == _puzzle._totalPegCount && _scale._balance == 0)
					{
						// human solved it at the last second
						humanSolvedPuzzle();
					}
					else
					{
						// human was stumped
						eventTime = spoilAnswer();
					}
				}
				_scalePlayerStatus.finishRound();
				_eventStack.addEvent({time:eventTime + 1.5, callback:eventSetState, args:[300]});
				for (i in 0..._agentSprites.length)
				{
					// did any computer players solve it at the last second too?
					var agent:ScaleAgent = _scalePlayerStatus._agents[i];
					if (!agent.isDone() && agent._time <= _scalePlayerStatus._elapsedPuzzleTime + BALANCE_DURATION)
					{
						if (agent._soundAsset != null)
						{
							FlxSoundKludge.play(agent._soundAsset, 0.4);
						}
						_scalePlayerStatus.playerFinished(i);
					}
				}
			}
		}

		for (critter in _crucialCritters)
		{
			if (_grabbedCritter == critter)
			{
				// don't mess with grabbed critter
				continue;
			}
			if (findPad(critter) != null)
			{
				// critters on pads don't wander home
				continue;
			}
			if (!isInPuzzleArea(critter))
			{
				critter.setIdle();
				critter._eventStack.reset();
				// critter should run back to the puzzle area
				if (critter._soulSprite.x < 390)
				{
					critter.runTo(FlxG.random.float(_puzzleArea.left + 10, 390), FlxG.random.float(_puzzleArea.top + 10, _puzzleArea.bottom - 10));
				}
				else
				{
					critter.runTo(FlxG.random.float(390, _puzzleArea.right - 10), FlxG.random.float(_puzzleArea.top + 10, _puzzleArea.bottom - 10));
				}
			}
		}

		if (_gameState == 300)
		{
			// drop any held critters in between rounds
			maybeReleaseCritter();

			_lightsManager.setLightsDim();
			_scaleScoreboard.exists = true;
			setState(305);

			{
				// scoreboard should appear
				var eventTime:Float = _eventStack._time + 0.1;
				_eventStack.addEvent({time:eventTime += 0.8, callback:_scaleScoreboard.eventShowRoundScores});
				_eventStack.addEvent({time:eventTime, callback:EventStack.eventPlaySound, args:[AssetPaths.beep_0065__mp3]});
				_eventStack.addEvent({time:eventTime += 1.3, callback:_scaleScoreboard.eventShowTotalScores});
				_eventStack.addEvent({time:eventTime, callback:_scaleScoreboard.eventAccumulateTotalScores});
				_eventStack.addEvent({time:eventTime, callback:_lightsManager.eventLightsOn});
				_eventStack.addEvent({time:eventTime += 2.4, callback:eventSetState, args:[310]});
			}

			{
				// critters should get off of scales
				var eventTime:Float = _eventStack._time + 0.1;
				var crittersToJumpOff:Array<Critter> = [];
				for (i in 0...4)
				{
					for (j in 0..._scale._pads[i]._critters.length)
					{
						if (_scale._pads[i]._critters[j].outCold)
						{
							// out cold; can't jump
						}
						else
						{
							crittersToJumpOff.push(_scale._pads[i]._critters[j]);
						}
					}
				}
				FlxG.random.shuffle(crittersToJumpOff);
				for (critter in crittersToJumpOff)
				{
					_eventStack.addEvent({time:eventTime += 0.2, callback:eventCritterJumpOff, args:[critter]});
				}
				_crucialCritters.splice(0, _crucialCritters.length);
			}

			if (!_scalePlayerStatus._agents[0].isDone())
			{
				// human didn't finish; lower the puzzle difficulty
				adjustPuzzleDifficulty();
			}

			if (!_scalePlayerStatus.isGameOver())
			{
				var tree:Array<Array<Object>> = [];
				var agent:ScaleAgent = _scalePlayerStatus._agents[FlxG.random.int(1, _scalePlayerStatus._agents.length - 1)];

				var roundWinningAgent:ScaleAgent = null;
				var gameWinningAgents:Array<ScaleAgent> = [];
				var maxScore:Int = 0;
				for (i in 0..._scalePlayerStatus._agents.length)
				{
					if (_scalePlayerStatus._agents[i]._finishedOrder == 1)
					{
						roundWinningAgent = _scalePlayerStatus._agents[i];
					}
					if (_scalePlayerStatus._totalScores[i] + _scalePlayerStatus._roundScores[i] > maxScore)
					{
						maxScore = _scalePlayerStatus._totalScores[i] + _scalePlayerStatus._roundScores[i];
						gameWinningAgents = [_scalePlayerStatus._agents[i]];
					}
					else if (_scalePlayerStatus._totalScores[i] + _scalePlayerStatus._roundScores[i] == maxScore)
					{
						gameWinningAgents.push(_scalePlayerStatus._agents[i]);
					}
				}
				if (_roundNumber >= 2 && agent._finishedOrder <= 2 && gameWinningAgents.length == 1 && gameWinningAgents[0] == agent && FlxG.random.bool(75))
				{
					// winning...
					agent._gameDialog.popWinning(tree);
				}
				else if (_roundNumber >= 2 && agent._finishedOrder >= 2 && gameWinningAgents.indexOf(agent) == -1 && FlxG.random.bool())
				{
					// losing...
					agent._gameDialog.popLosing(tree, gameWinningAgents[0]._name, gameWinningAgents[0]._gender);
				}
				else if (agent._finishedOrder == 1)
				{
					// finished first
					agent._gameDialog.popRoundWin(tree);
				}
				else if (agent._finishedOrder >= 3)
				{
					if (roundWinningAgent == null)
					{
						// shouldn't happen... but for safety
						agent._gameDialog.popRoundStart(tree, _roundNumber + 1);
					}
					else
					{
						agent._gameDialog.popRoundLose(tree, roundWinningAgent._name, roundWinningAgent._gender);
					}
				}
				else
				{
					agent._gameDialog.popRoundStart(tree, _roundNumber + 1);
				}

				var beforeTree:Array<Array<Object>> = [];
				beforeTree[0] = ["%prompts-y-offset+" + (31 + 21 * _agentSprites.length) + "%"];
				tree = DialogTree.prepend(beforeTree, tree);
				_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
				_dialogTree.go();
			}
		}

		if (_gameState == 310)
		{
			if (!DialogTree.isDialogging(_dialogTree))
			{
				startNewPuzzle();
			}
		}

		if (_gameState == 79 || _gameState == 80)
		{
			// Take the player through the guided tutorial.
			var tree:Array<Array<Object>>;

			if (_gameState == 80)
			{
				/*
				 * The player is asking for the tutorial, even though they've
				 * heard it before. We don't do the intro dialog -- we just
				 * have Buizel start explaining the rules. The handoff is a
				 * little clunky, but there's too many silly edge cases.
				 */
				tree = TutorialDialog.scaleGamePartOneAbruptHandoff();
			}
			else if (_scalePlayerStatus._agents[1]._name == "Buizel")
			{
				// I'm buizel; I can explain this
				tree = TutorialDialog.scaleGamePartOneNoHandoff(this);
			}
			else
			{
				// I'm not buizel. Where's buizel?
				var buizelAgent:ScaleAgent = _scalePlayerStatus._agents.filter(function (a) {return a._name == "Buizel"; })[0];
				var tutorialTree:Array<Array<Object>>;
				tree = [];
				handleGameAnnouncement(tree);
				if (buizelAgent != null)
				{
					// Buizel's in the room with us; he can explain it
					_scalePlayerStatus._agents[1]._gameDialog.popLocalExplanationHandoff(tree, "Buizel", PlayerData.buizMale ? PlayerData.Gender.Boy : PlayerData.Gender.Girl);
					tutorialTree = TutorialDialog.scaleGamePartOneLocalHandoff();
				}
				else
				{
					// Let me get Buizel...
					_scalePlayerStatus._agents[1]._gameDialog.popRemoteExplanationHandoff(tree, "Buizel", PlayerData.buizMale ? PlayerData.Gender.Boy : PlayerData.Gender.Girl);
					tree.push(["#zzzz04#..."]);
					tutorialTree = TutorialDialog.scaleGamePartOneRemoteHandoff();
				}
				tree = DialogTree.prepend(tree, tutorialTree);
			}

			_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
			_dialogTree.go();
			_puzzleArea.set(45, 292, 642, 50);
			setState(81);
		}

		if (_gameState == 81)
		{
			if (!DialogTree.isDialogging(_dialogTree))
			{
				_canClickCritters = true;
				setState(82);
			}
		}
		if (_gameState == 84)
		{
			if (!DialogTree.isDialogging(_dialogTree))
			{
				_canClickCritters = false;
				setState(86);
			}
		}
		if (_gameState == 86 || _gameState == 100)
		{
			_canClickCritters = false;
			var tree:Array<Array<Object>> = [];
			var agent:ScaleAgent = _scalePlayerStatus._agents[1];
			if (_gameState == 86)
			{
				agent._gameDialog.popPostTutorialGameStartQuery(tree, description);
			}
			else
			{
				handleGameAnnouncement(tree);
				agent._gameDialog.popGameStartQuery(tree);
			}
			_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
			_dialogTree.go();

			setState(103);
		}
		if (_gameState == 500)
		{
			var agent:ScaleAgent = _scalePlayerStatus._agents[1];
			var tree:Array<Array<Object>> = agent._gameDialog.popSkipMinigame();
			_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
			_dialogTree.go();
			setState(505);
		}
		if (_gameState == 505)
		{
			if (!DialogTree.isDialogging(_dialogTree))
			{
				if (!PlayerData.playerIsInDen)
				{
					// i award you no points and may god have mercy on your soul
					payMinigameReward(0);
				}
				exitMinigameState();
				return;
			}
		}
		if (_gameState == 103)
		{
			if (!DialogTree.isDialogging(_dialogTree))
			{
				if (_scalePlayerStatus.isMismatched() && _scalePlayerStatus._agents.length > 2)
				{
					var agent:ScaleAgent = _scalePlayerStatus._agents[1];
					var tree:Array<Array<Object>> = agent._gameDialog.popPlayWithoutMe();
					_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
					_dialogTree.go();
				}
				setState(115);
			}
		}
		if (_gameState == 115)
		{
			if (!DialogTree.isDialogging(_dialogTree))
			{
				_scaleScoreboard.init();
				startNewPuzzle();
			}
		}

		if (_gameState == 400)
		{
			if (DialogTree.isDialogging(_dialogTree))
			{
				// still dialogging; don't exit
			}
			else if (_eventStack._alive)
			{
				// still going through events; don't exit
			}
			else if (_cashWindow._currentAmount != PlayerData.cash)
			{
				// still accumulating cash; don't exit
			}
			else
			{
				exitMinigameState();
				return;
			}
		}

		#if debug
		// hit 'I' to make someone do an idle animation
		if (FlxG.keys.justPressed.I)
		{
			var closestCritter:Critter = null;
			for (critter in _critters)
			{
				if (closestCritter == null || closestCritter._bodySprite.getPosition().distanceTo(FlxG.mouse.getPosition()) > critter._bodySprite.getPosition().distanceTo(FlxG.mouse.getPosition()))
				{
					closestCritter = critter;
				}
			}
			if (closestCritter != null)
			{
				closestCritter.playAnim("complex-figure8", true);
			}
		}
		if (FlxG.keys.justPressed.R)
		{
			setState(190);
			startNewPuzzle();
		}
		#end
	}

	public function eventCritterJumpOff(args:Array<Dynamic>):Void
	{
		var critter:Critter = args[0];
		releaseCritter(critter);
		findPad(critter).removeCritter(critter);
		recalculateBalance();
		critter._runToCallback = critterRunOffscreen;
	}

	public function critterRunOffscreen(critter:Critter):Void
	{
		critter.runTo(critter._soulSprite.x + FlxG.random.float(-100, 100), 550);
	}

	override function dialogTreeCallback(Msg:String):String
	{
		super.dialogTreeCallback(Msg);
		if (StringTools.startsWith(Msg, "%set-puzzle-"))
		{
			var puzzleIndex:Int = Std.parseInt(substringBetween(Msg, "%set-puzzle-", "%"));
			var eventTime:Float = _eventStack._time + 0.1;
			_eventStack.addEvent({time:eventTime, callback:eventSetScaleVisible, args:[false]});
			_eventStack.addEvent({time:eventTime, callback:eventSetPuzzle, args:[puzzleIndex]});
			_eventStack.addEvent({time:eventTime+0.6, callback:eventSetScaleVisible, args:[true]});
		}
		if (StringTools.startsWith(Msg, "%move-pegs-"))
		{
			var pegStrings:Array<String> = substringBetween(Msg, "%move-pegs-", "%").split("-");
			var pegTarget:Array<Int> = [0, 0, 0, 0];
			for (i in 0...4)
			{
				pegTarget[i] = Std.parseInt(pegStrings[i]);
			}

			// who's in the wrong place?
			var wrongCritters:Array<Critter> = _crucialCritters.filter(function(s) return findPad(s) == null);
			for (i in 0...4)
			{
				var extraCritterCount:Int = _scale._pads[i]._critters.length - pegTarget[i];
				for (j in 0...extraCritterCount)
				{
					wrongCritters.push(_scale._pads[i]._critters[j]);
				}
			}

			var eventTime:Float = _eventStack._time + 0.1;

			var lights:Array<String> = [];

			// which pads need more critters?
			for (i in 0...4)
			{
				var missingCritterCount:Int = pegTarget[i] - _scale._pads[i]._critters.length;
				for (j in 0...missingCritterCount)
				{
					var critter:Critter = wrongCritters.pop();
					_eventStack.addEvent({time:eventTime, callback:eventMoveCritterToPad, args:[critter, i]});
					_eventStack.addEvent({time:eventTime, callback:EventStack.eventPlaySound, args:[AssetPaths.drop__mp3]});
					eventTime += 0.6;
				}
			}
		}
		if (Msg == "%answer-bad%" || Msg == "%answer-good%")
		{
			var eventTime:Float = _eventStack._time + 3.6;
			var answerGood:Bool = Msg == "%answer-good%";
			_eventStack.addEvent({time:eventTime, callback:EventStack.eventPlaySound, args:[answerGood ? AssetPaths.clue_ok_00fa__mp3 : AssetPaths.clue_bad_00ff__mp3]});
			_eventStack.addEvent({time:eventTime, callback:eventAnswerOk, args:[answerGood ? 1 : 0, answerGood]});

			if (!answerGood)
			{
				var unusedCritter:Critter = null;
				for (critter in _crucialCritters)
				{
					if (findPad(critter) == null)
					{
						unusedCritter = critter;
					}
				}

				if (unusedCritter != null)
				{
					_eventStack.addEvent({time:eventTime, callback:_lightsManager.eventLightsDim});
					_eventStack.addEvent({time:eventTime, callback:eventCreateCritterSpotlight, args:[unusedCritter, "wrongCritter"]});
					_eventStack.addEvent({time:eventTime, callback:_lightsManager.eventSpotlightOn, args:["wrongCritter"]});
					_eventStack.addEvent({time:eventTime + 0.75, callback:_lightsManager.eventLightsOn});
					_eventStack.addEvent({time:eventTime + 1.05, callback:eventDeleteCritterSpotlight, args:["wrongCritter"]});
				}
			}
		}
		if (Msg == "%skip-tutorial%")
		{
			setState(103);
		}
		if (Msg == "%skip-minigame%")
		{
			setState(500);
		}
		if (Msg == "%restart-tutorial%")
		{
			setState(80);
		}
		if (Msg == "%play-without-me%")
		{
			var agentSprite:FlxSprite = _agentSprites[1];
			_hud.remove(agentSprite);
			_agentSprites.remove(agentSprite);
			FlxDestroyUtil.destroy(agentSprite);

			_scalePlayerStatus._roundScores.splice(1, 1);
			_scalePlayerStatus._totalScores.splice(1, 1);
			_scalePlayerStatus._agents.splice(1, 1);
		}
		return null;
	}

	public function eventSetScaleVisible(args:Array<Dynamic>):Void
	{
		setScaleVisible(args[0]);
	}

	public function eventSetPuzzle(args:Array<Dynamic>):Void
	{
		_puzzle = ScalePuzzleDatabase.fixedPuzzle(args[0]);
		preparePuzzleAndCritters();
	}

	public function eventMoveCritterToPad(args:Array<Dynamic>):Void
	{
		var critter:Critter = args[0];
		var padIndex:Int = args[1];
		removeCritterFromHolder(critter);
		placeCritterInHolder(_scale._pads[padIndex], critter);
		var _holderPos:FlxPoint = _scale._pads[padIndex]._sprite.getPosition();
		_holderPos.x += _scale._pads[padIndex]._sprite.width / 2 - critter._targetSprite.width / 2 + 1;
		_holderPos.y += _scale._pads[padIndex]._sprite.height / 2 - critter._targetSprite.height / 2 + 2;
		critter.setPosition(_holderPos.x + FlxG.random.float( -2, 2), _holderPos.y + FlxG.random.float( -2, 2));
		_scale.recalculateBalance();
	}

	public function eventCreateCritterSpotlight(args:Array<Dynamic>):Void
	{
		var critter:Critter = args[0];
		var spotlightName:String = args[1];
		_lightsManager._spotlights.addSpotlight(spotlightName);
		var lightRect:FlxRect = critter._soulSprite.getHitbox();
		lightRect.y -= 25;
		lightRect.height += 25;
		_lightsManager._spotlights.growSpotlight(spotlightName, lightRect);
	}

	public function eventDeleteCritterSpotlight(args:Array<Dynamic>):Void
	{
		var spotlightName:String = args[0];
		_lightsManager._spotlights.removeSpotlight(spotlightName);
	}

	public function isInPuzzleArea(critter:Critter)
	{
		return isCoordInPuzzleArea(critter._soulSprite.x, critter._soulSprite.y) || isCoordInPuzzleArea(critter._targetSprite.x, critter._targetSprite.y);
	}

	function isCoordInPuzzleArea(x:Float, y:Float)
	{
		return FlxMath.pointInFlxRect(x, y, _puzzleArea);
	}

	override public function moveGrabbedCritter(elapsed:Float):Void
	{
		_grabbedCritter.setPosition(_handSprite.x - 18, _handSprite.y + 5);
		if (_grabbedCritter != null && _grabbedCritter._soulSprite.y < 164)
		{
			var z:Float = 164 - _grabbedCritter._soulSprite.y;
			// confine critter to the bottom half of the screen
			_grabbedCritter._soulSprite.y = 164;
			_grabbedCritter._targetSprite.y = _grabbedCritter._soulSprite.y;
			_grabbedCritter._bodySprite.y = _grabbedCritter._soulSprite.y;
			_grabbedCritter.z = z;
		}
		_thumbSprite.setPosition(_handSprite.x, _handSprite.y + 6);

		moveGrabbedCritterButt(elapsed);
	}

	override function handleMousePress():Void
	{
		maybeGrabCritter();
		recalculateBalance();
	}

	private function recalculateBalance()
	{
		var oldBalance:Float = _scale._balance;
		_scale.recalculateBalance();
		if (oldBalance != _scale._balance)
		{
			if (_scale._balance == 0 && _scale.getCritterCount() > 0)
			{
				_releaseTimer = BALANCE_DURATION;
			}
			else
			{
				_releaseTimer = 0;
			}
		}
	}

	override function handleMouseRelease():Void
	{
		maybeReleaseCritter();
		recalculateBalance();
	}

	override public function maybeReleaseCritter():Bool
	{
		var critter:Critter = _grabbedCritter;
		var result:Bool = super.maybeReleaseCritter();
		if (_grabbedCritter == null && critter != null)
		{
			if (findPad(critter) != null)
			{
				critter.z = 0;
				return result;
			}
			releaseCritter(critter);
		}
		return result;
	}

	private function releaseCritter(critter:Critter):Void
	{
		if (critter._soulSprite.y - critter.z < 284)
		{
			var z:Float = (284 - critter._soulSprite.y) + critter.z;
			// confine critter to the bottom half of the screen
			critter._soulSprite.y = 284;
			critter._targetSprite.y = critter._soulSprite.y;
			critter._bodySprite.y = critter._soulSprite.y;
			critter._headSprite.moveHead();

			var dir:Float = 0;
			if (critter._soulSprite.x < 100)
			{
				dir = 1.75 * Math.PI;
			}
			else if (critter._soulSprite.x > FlxG.width - 100)
			{
				dir = 1.25 * Math.PI;
			}
			else
			{
				dir = FlxG.random.float(Math.PI, 2 * Math.PI);
			}
			var delay:Float = Math.sqrt(z) / 13 + 0.05;
			var dist:Float = (delay / 2) * 130;

			critter.dropTo(critter._soulSprite.x + Math.cos(dir) * dist, critter._soulSprite.y - Math.sin(dir) * dist, z);
		}
	}

	public function eventAnswerOk(params:Array<Dynamic>):Void
	{
		var sprite:LateFadingFlxParticle = _answerOkGroup.recycle(LateFadingFlxParticle);
		sprite.reset(0, 0);
		sprite.alpha = 1;
		sprite.lifespan = params[1] ? 1 : 3;
		sprite.x = (3 * 108 + 16) - 32;
		sprite.y = (250 + 22) - 16;
		sprite.animation.frameIndex = params[0] ? 0 : 1;
		sprite.alphaRange.set(1, 0);
		sprite.enableLateFade(2);
		FlxTween.tween(sprite, {y:sprite.y - 32}, params[1] ? 1 : 3, {ease:FlxEase.circOut});
		_answerOkGroup.add(sprite);
	}

	public function startNewPuzzle():Void
	{
		_roundNumber++;
		setScaleVisible(false);
		_puzzleArea.set(45, 292, 642, 113);

		// just in case scores didn't fully accumulate
		for (i in 0..._scalePlayerStatus._totalScores.length)
		{
			_scalePlayerStatus._totalScores[i] += _scalePlayerStatus._roundScores[i];
			_scalePlayerStatus._roundScores[i] = 0;
		}
		_scaleScoreboard.exists = false;
		if (_scalePlayerStatus.isGameOver())
		{
			finalScoreboard = new ScaleFinalScoreboard(this);
			showFinalScoreboard();
			setState(400);

			var bestScore:Int = 0;
			var bestAgent:ScaleAgent = _scalePlayerStatus._agents[0];
			for (i in 0..._agentSprites.length)
			{
				if (_scalePlayerStatus._totalScores[i] > bestScore)
				{
					bestScore = _scalePlayerStatus._totalScores[i];
					bestAgent = _scalePlayerStatus._agents[i];
				}
			}

			var tree:Array<Array<Object>> = [];
			if (PlayerData.playerIsInDen)
			{
				// just practicing
				handleDenGameOver(tree, bestAgent == _scalePlayerStatus._agents[0]);
			}
			else if (bestAgent == _scalePlayerStatus._agents[0])
			{
				// player won
				_scalePlayerStatus._agents[1]._gameDialog.popPlayerBeatMe(tree, finalScoreboard._totalReward);
				for (i in 2..._scalePlayerStatus._agents.length)
				{
					_scalePlayerStatus._agents[i]._gameDialog.popShortPlayerBeatMe(tree, finalScoreboard._totalReward);
				}
			}
			else
			{
				// player lost
				bestAgent._gameDialog.popBeatPlayer(tree, finalScoreboard._totalReward);
				for (i in 1..._scalePlayerStatus._agents.length)
				{
					if (_scalePlayerStatus._agents[i] != bestAgent)
					{
						_scalePlayerStatus._agents[i]._gameDialog.popShortWeWereBeaten(tree, finalScoreboard._totalReward, bestAgent._name, bestAgent._gender);
					}
				}
			}
			_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
			_dialogTree.go();

			updateAgentSpritePositions();
			resetCritters(); // ensure critters left over on scales are removed
			return;
		}
		setState(190);
		updateAgentSpritePositions();

		_releaseTimer = 0;
		var seed:Int = FlxG.random.int(100000, 999999);
		_puzzle = ScalePuzzleDatabase.randomPuzzle();
		preparePuzzleAndCritters();
		_scalePlayerStatus.startRound(_puzzle);
		_canClickCritters = true;

		recalculateBalance();

		_clockToggle.splice(0, _clockToggle.length);
		var j:Float = 0.001;
		while (j < 1)
		{
			_clockToggle.push(j += 1 / 6);
		}
		while (j < 3)
		{
			_clockToggle.push(j += 1 / 4);
		}
		while (j < 6)
		{
			_clockToggle.push(j += 1 / 2);
		}
		while (j < 10)
		{
			_clockToggle.push(j += 1);
		}
	}

	override function findTargetCritterHolder():CritterHolder
	{
		var minDistance:Float = 125;
		var closestCritterHolder:CritterHolder = null;
		var grabbedMidpoint:FlxPoint = _grabbedCritter._bodySprite.getMidpoint();
		grabbedMidpoint.y -= _grabbedCritter.z;
		for (pad in _scale._pads)
		{
			var midPoint:FlxPoint = pad._sprite.getMidpoint();
			var dx:Float = (midPoint.x - grabbedMidpoint.x);
			var dy:Float = (midPoint.y - grabbedMidpoint.y - 6) * 1.6;
			if (dx * dx + dy * dy < minDistance * minDistance)
			{
				minDistance = Math.sqrt(dx * dx + dy * dy);
				closestCritterHolder = pad;
			}
		}
		return closestCritterHolder;
	}

	override function removeCritterFromHolder(critter:Critter):Bool
	{
		for (pad in _scale._pads)
		{
			if (pad.removeCritter(critter))
			{
				return true;
			}
		}
		return true;
	}

	function findPad(critter:Critter):CritterHolder
	{
		for (pad in _scale._pads)
		{
			if (pad._critters.indexOf(critter) != -1)
			{
				return pad;
			}
		}
		return null;
	}

	function updateClock(elapsed:Float):Void
	{
		if (Std.int(_scalePlayerStatus._remainingPuzzleTime) != Std.int(_scalePlayerStatus._remainingPuzzleTime + elapsed) ||
			(_clockToggle.length >= 1 && _scalePlayerStatus._remainingPuzzleTime < _clockToggle[_clockToggle.length - 1]))
		{
			if (_clockToggle.length >= 1 && _scalePlayerStatus._remainingPuzzleTime < _clockToggle[_clockToggle.length - 1])
			{
				_clockToggle.pop();
				SoundStackingFix.play(_clockToggle.length % 2 == 1 ? AssetPaths.beep_0065__wav : AssetPaths.beep_hi_0065__wav);
			}
			_scale.setScaleClockAngle(6 * FlxMath.bound(Std.int(_scalePlayerStatus._remainingPuzzleTime), 0, 30), _clockToggle.length % 2 == 1);
		}
	}

	public function playerFinished()
	{
		updateAgentSpritePositions();
	}

	override function findGrabbedCritter():Critter
	{
		if (!_canClickCritters)
		{
			return null;
		}
		return super.findGrabbedCritter();
	}

	function spoilAnswer():Float
	{
		_releaseTimer = 0;
		_canClickCritters = false;

		// release held critters, so they can be shown in the answer
		maybeReleaseCritter();

		// who's in the wrong place?
		var wrongCritters:Array<Critter> = _crucialCritters.filter(function(s) return findPad(s) == null);
		for (i in 0...4)
		{
			var extraCritterCount:Int = _scale._pads[i]._critters.length - _puzzle._answer[i];
			for (j in 0...extraCritterCount)
			{
				wrongCritters.push(_scale._pads[i]._critters[j]);
			}
		}

		if (wrongCritters.length == 0)
		{
			// was correct all along?
		}

		var eventTime:Float = _eventStack._time + 0.1;
		_eventStack.addEvent({time:eventTime, callback:_lightsManager.eventLightsDim});
		eventTime += 1.0;

		var lights:Array<String> = [];

		// which pads need more critters?
		for (i in 0...4)
		{
			var missingCritterCount:Int = _puzzle._answer[i] - _scale._pads[i]._critters.length;
			for (j in 0...missingCritterCount)
			{
				var critter:Critter = wrongCritters.pop();
				var lightName:String = "wrongCritter" + i;
				_eventStack.addEvent({time:eventTime, callback:eventMoveCritterToPad, args:[critter, i]});
				_eventStack.addEvent({time:eventTime, callback:eventCreateCritterSpotlight, args:[critter, lightName]});
				_eventStack.addEvent({time:eventTime, callback:EventStack.eventPlaySound, args:[AssetPaths.drop__mp3]});
				eventTime += 0.4;
			}
		}
		eventTime += 2.0;
		for (lightName in lights)
		{
			_eventStack.addEvent({time:eventTime, callback:eventDeleteCritterSpotlight, args:[lightName]});
		}
		return eventTime;
	}

	function humanSolvedPuzzle():Void
	{
		_releaseTimer = 0;
		_canClickCritters = false;
		_scalePlayerStatus.playerFinished(0);
		var eventTime:Float = _eventStack._time + 0.1;
		_eventStack.addEvent({time:eventTime, callback:EventStack.eventPlaySound, args:[AssetPaths.clue_ok_00fa__mp3]});
		_eventStack.addEvent({time:eventTime, callback:eventAnswerOk, args:[1, true]});
		_speedupTimer = 1.2;
		adjustPuzzleDifficulty();
	}

	/**
	 * Adjust the puzzle difficulty. If they solved a puzzle in less than 18
	 * seconds, they'll have a harder puzzle. If it took them longer than 18
	 * seconds, they'll have an easier puzzle.
	 */
	function adjustPuzzleDifficulty()
	{
		if (_gameState < 200)
		{
			// we don't want to adjust puzzle difficulty during tutorials.
		}
		else if (_scalePlayerStatus._elapsedPuzzleTime <= 0)
		{
			// times less than 0 mess up our log arithmetic... They shouldn't happen anyway
		}
		else
		{
			var adjustAmount:Float = -Math.log(_scalePlayerStatus._elapsedPuzzleTime / 18) / Math.log(2);
			adjustAmount = FlxMath.bound(adjustAmount, -3, 3);
			PlayerData.scaleGamePuzzleDifficulty = FlxMath.bound(PlayerData.scaleGamePuzzleDifficulty + adjustAmount * 0.13, 0, 1);
		}
	}

	function preparePuzzleAndCritters():Void
	{
		resetCritters();
		for (i in 0..._puzzle._totalPegCount)
		{
			_crucialCritters.push(_critters[i]);
			_critters[i].setPosition(FlxG.random.float(_puzzleArea.left + 10, _puzzleArea.right - 10), FlxG.random.float(FlxG.height + 28, FlxG.height + 58));
		}

		_scale.setPuzzle(_puzzle);
	}

	function resetCritters():Void
	{
		for (pad in _scale._pads)
		{
			pad._critters.splice(0, pad._critters.length);
		}
		_crucialCritters.splice(0, _crucialCritters.length);
		var x:Int = 100;
		for (critter in _critters)
		{
			critter.setPosition(x, 550);
			critter.reset();
			x += 40;
		}
		FlxG.random.shuffle(_critters);
	}

	function setScaleVisible(scaleVisible:Bool):Void
	{
		var oldScaleVisible:Bool = _scale.exists;
		_scale.exists = scaleVisible;
		_scale._scaleShadow.exists = scaleVisible;
		if (scaleVisible && !oldScaleVisible)
		{
			var leftX:Int = _scale._shortScale ? 78 : 24;
			var rightX:Int = _scale._shortScale ? 694 : 748;
			for (i in 0...15)
			{
				_whumpClouds.x = FlxG.random.int(leftX, rightX);
				_whumpClouds.y = FlxG.random.int(277, 297);
				var particle:FlxParticle = _whumpClouds.emitParticle();
				particle.angle = FlxG.random.getObject([0, 90, 180, 270]);
			}
			SoundStackingFix.play(AssetPaths.countdown_go_005c__mp3);
		}
	}

	override public function payMinigameReward(reward:Int)
	{
		super.payMinigameReward(reward);

		if (reward > 0)
		{
			/**
			 * Adjust difficulty for next time. If the player won at least
			 * $1,000, they'll face harder opponents next time. If they won
			 * less than $1,000, they'll face easier opponents next time.
			 */
			var adjustAmount:Float = Math.log(reward / avgReward) / Math.log(2);
			adjustAmount = FlxMath.bound(adjustAmount, -2, 2);
			PlayerData.scaleGameOpponentDifficulty = FlxMath.bound(PlayerData.scaleGameOpponentDifficulty + adjustAmount * 0.21, 0, 1);
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		_whumpClouds = FlxDestroyUtil.destroy(_whumpClouds);
		_scale = FlxDestroyUtil.destroy(_scale);
		_answerOkGroup = FlxDestroyUtil.destroy(_answerOkGroup);
		_puzzle = null;
		_crucialCritters = FlxDestroyUtil.destroyArray(_crucialCritters);
		_lightsManager = FlxDestroyUtil.destroy(_lightsManager);
		_scalePlayerStatus = FlxDestroyUtil.destroy(_scalePlayerStatus);
		_agentSprites = FlxDestroyUtil.destroyArray(_agentSprites);
		_clockToggle = null;
		_scaleScoreboard = FlxDestroyUtil.destroy(_scaleScoreboard);
		_countdownSprite = FlxDestroyUtil.destroy(_countdownSprite);
		_puzzleArea = FlxDestroyUtil.put(_puzzleArea);
	}
}