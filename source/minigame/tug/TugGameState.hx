package minigame.tug;

import flixel.util.FlxDestroyUtil;
import minigame.MinigameState.denNerf;
import critter.Critter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter.FlxEmitterMode;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDirectionFlags;
import kludge.LateFadingFlxParticle;
import minigame.FinalScoreboard;
import minigame.MinigameState;
import minigame.scale.CountdownSprite;
import minigame.tug.TugAgent.Trait;
import minigame.tug.TugModel;
import minigame.tug.TugRow;
import openfl.utils.Object;
import poke.smea.SmeargleResource;

/**
 * The FlxState for the tug-of-war minigame.
 *
 * The tug-of-war minigame lasts 3 rounds. Each round, you and your opponent
 * race to simultaneously arrange your bugs in a way that earns you more chests
 * than your opponents. You earn the amount of money in your chests, plus a
 * bonus if you outscore your opponent.
 *
 * Strategically you want to win a few tug-of-wars by a little, and lose one by
 * a lot, but your opponents are clever and will try to do the same thing to
 * you. The player who can react the fastest and think a step ahead will win
 * the game.
 */
class TugGameState extends MinigameState
{
	public static var RANDOM_TUG_FREQUENCY:Float = 0.5;
	public static var CRITTER_HORIZONTAL_SPACING:Float = 48;

	private var rowResultGroup:FlxGroup;

	public var tugRows:Array<TugRow> = [];

	public var round:Int = 0;
	private var roundDurations:Array<Array<Int>> = [[6, 20], [8, 28], [10, 36]];
	private var roundCritterCounts:Array<Int> = [10, 14, 18];
	private var roundRowRewards:Array<Array<Int>> = [[100, 125, 50], [135, 175, 150, 100], [100, 185, 225, 145, 50]];
	private var roundBonus:Array<Int> = [50, 100, 150];

	public var model:TugModel = new TugModel();
	public var finalCritter:Critter; // last critter who remains outside of tent

	private var randomTugTimer:Float = 0;
	public var decideMatchTimer:Float = 0;
	private var smallSparkEmitter:FlxTypedEmitter<LateFadingFlxParticle>;

	// the winner has some effects applied to certain numbers so we need to store them
	private var leftBigShadows:Array<FlxSprite> = [];
	private var rightBigShadows:Array<FlxSprite> = [];
	private var leftBigNums:Array<FlxSprite> = [];
	private var rightBigNums:Array<FlxSprite> = [];
	public var tentColors:Array<Int> = [];
	public var grabEnabled:Bool = false;
	private var countdownSprite:CountdownSprite;

	public var tugScoreboard:TugScoreboard;
	private var ai:TugAi;
	private var tutorialAi:TugAi;
	public var agent:TugAgent;

	private var opponentFrame:RoundedRectangle;
	public var opponentChatFace:FlxSprite;

	public var tutorial:Bool = false;
	private var tutorialMovedAnything:Bool = false;
	private var tutorialIdleTime:Float = 0;

	public function new()
	{
		super();
		description = PlayerData.MINIGAME_DESCRIPTIONS[2];
		duration = 3.0;
		// scores range from 400-2,200
		avgReward = 1300;
	}

	public static function isLeftTeam(critter:Critter):Bool
	{
		return critter._critterColor == Critter.CRITTER_COLORS[0];
	}

	override public function create():Void
	{
		super.create();
		Critter.shuffleCritterColors();

		if (PlayerData.playerIsInDen)
		{
			for (round in 0...3)
			{
				for (row in 0...roundRowRewards[round].length)
				{
					roundRowRewards[round][row] = denNerf(roundRowRewards[round][row]);
				}
			}
			for (round in 0...3)
			{
				roundBonus[round] = denNerf(roundBonus[round]);
			}
		}

		agent = TugAgentDatabase.getAgent();

		opponentFrame = new RoundedRectangle();
		opponentFrame.relocate(3, FlxG.height - 78, 77, 75, 0xff000000, 0xeeffffff);
		_hud.add(opponentFrame);

		opponentChatFace = new FlxSprite(opponentFrame.x + 2, opponentFrame.y + 2);
		opponentChatFace.loadGraphic(agent.chatAsset, true, 73, 71);
		setChatFace(FlxG.random.getObject(agent.neutralFaces));
		_hud.add(opponentChatFace);

		rowResultGroup = new FlxGroup();
		_hud.add(rowResultGroup);

		smallSparkEmitter = new FlxTypedEmitter<LateFadingFlxParticle>(0, 0, 50);
		smallSparkEmitter.launchMode = FlxEmitterMode.SQUARE;
		smallSparkEmitter.angularVelocity.set(0);
		smallSparkEmitter.velocity.set(400, 400);
		smallSparkEmitter.lifespan.set(0.6);
		for (i in 0...smallSparkEmitter.maxSize)
		{
			var particle:LateFadingFlxParticle = new LateFadingFlxParticle();
			particle.makeGraphic(6, 6, FlxColor.WHITE);
			particle.offset.x = 2.5;
			particle.offset.y = 2.5;
			particle.exists = false;
			smallSparkEmitter.add(particle);
		}
		_hud.add(smallSparkEmitter);

		countdownSprite = new CountdownSprite();
		_hud.add(countdownSprite);

		ai = new TugAi(this);
		tutorialAi = new TugAi(this, TugAgentDatabase.getTutorialAgent());

		tugScoreboard = new TugScoreboard(this);
		tugScoreboard.exists = false;
		_hud.add(tugScoreboard);

		_hud.add(_cashWindow);
		_hud.add(_dialogger);
		_hud.add(_helpButton);

		prepareRound();
		for (critter in _critters)
		{
			runHome(critter);
		}

		if (PlayerData.minigameCount[2] == 0)
		{
			// start tutorial
			var tree:Array<Array<Object>> = [];
			if (agent.chatAsset == AssetPaths.smear_chat__png)
			{
				// I'm Smeargle; I can explain this
				tree = TutorialDialog.tugGamePartOneNoHandoff();
			}
			else
			{
				var tutorialTree:Array<Array<Object>>;
				// Let me get Rhydon
				agent.gameDialog.popRemoteExplanationHandoff(tree, "Smeargle", PlayerData.smeaMale ? PlayerData.Gender.Boy : PlayerData.Gender.Girl);
				tree.push(["#zzzz04#..."]);
				tutorialTree = TutorialDialog.tugGamePartOneRemoteHandoff();
				tree = DialogTree.prepend(tree, tutorialTree);
			}
			launchTutorial(tree);
		}
		else {
			setState(100);
		}
	}

	/**
	 * @return The dialog class which handles when the user clicks the help button
	 */
	override public function getMinigameOpponentDialogClass():Class<Dynamic>
	{
		return agent.dialogClass;
	}

	private function prepareRound():Void
	{
		rowResultGroup.kill();
		rowResultGroup.clear();
		rowResultGroup.revive();
		tugScoreboard.exists = false;
		_eventStack.reset();

		grabEnabled = false;
		randomTugTimer = 0;
		decideMatchTimer = 0;

		var rowRewards:Array<Int> = roundRowRewards[round];
		var critterCount:Int = roundCritterCounts[round];
		model.reset(rowRewards.length);

		// initialize tent colors
		if (tentColors.length != rowRewards.length)
		{
			tentColors = [];
			var tentColorsTemp:Array<Int> = [0, 1, 2, 3];
			FlxG.random.shuffle(tentColorsTemp);
			while (tentColors.length < rowRewards.length)
			{
				// avoid having two adjacent tents of the same color
				var tentColor:Int = tentColorsTemp.pop();
				tentColors.push(tentColor);
				tentColorsTemp.insert(FlxG.random.int(0, 2), tentColor);
			}
		}

		// remove old stuff...
		_chests.splice(0, _chests.length);
		for (tugRow in tugRows)
		{
			tugRow.destroy();
		}
		tugRows.splice(0, tugRows.length);

		for (i in 0...rowRewards.length)
		{
			tugRows.push(new TugRow(this, i, rowRewards.length, rowRewards[i]));
		}

		// create critters
		while (_critters.length < critterCount * 2)
		{
			var critterY:Float = 0;

			// create critter sprite
			var critter:Critter = new Critter(0, 0, _backdrop);
			critter.setColor(Critter.CRITTER_COLORS[_critters.length % 2]);
			critter.canDie = false;
			addCritter(critter);

			var critterX:Float = -critter._bodySprite.width + (isLeftTeam(critter) ? FlxG.random.float( -20, -120) : FlxG.random.float(788, 888));
			var critterY:Float = FlxG.random.float(0, FlxG.height);
			critter.setPosition(critterX, critterY);
		}
	}

	public function moveCrittersIntoPosition(tutorial:Bool = false)
	{
		this.tutorial = tutorial;
		var rowIndex:Int = 0;
		for (i in 0..._critters.length)
		{
			var critter:Critter = _critters[i];
			critter.idleMove = false;
			critter.permanentlyImmovable = true;
			critter._targetSprite.immovable = true;

			var unoccupiedRow:Int = -1;
			for (tugRow in tugRows)
			{
				if (tugRow.getAlliedRowCritters(critter).length == 0)
				{
					unoccupiedRow = tugRow.row;
					break;
				}
			}

			if (unoccupiedRow >= 0)
			{
				rowIndex = unoccupiedRow;
			}
			else if (i % 2 == 0)
			{
				if (tutorial)
				{
					rowIndex = Std.int(i / 2) % tugRows.length;
				}
				else
				{
					rowIndex = FlxG.random.int(0, tugRows.length - 1);
					if (FlxG.random.bool(70))
					{
						// bias initial critter placement towards higher-valued rows
						var rowIndex2:Int = FlxG.random.int(0, tugRows.length - 1);
						if (tugRows[rowIndex2].rowReward > tugRows[rowIndex].rowReward)
						{
							rowIndex = rowIndex2;
						}
					}
				}
			}

			var oldPos:FlxPoint = critter._bodySprite.getPosition();
			assignToRow(critter, rowIndex);
			var newPos:FlxPoint = critter._bodySprite.getPosition();
			critter.setPosition(oldPos.x, oldPos.y);
			critter.setIdle();
			critter._eventStack.reset();

			critter.runTo(newPos.x, newPos.y, eventInitialGrabRope);
			if (unoccupiedRow >= 0)
			{
				if (!critter._bodySprite.moving)
				{
					// already there...
				}
				else
				{
					critter.insertWaypoint(newPos.x + (isLeftTeam(critter) ? -100 : 100), newPos.y + FlxG.random.float( -5, 5));
				}
			}
		}
	}

	private function setGrabEnabled(grabEnabled:Bool)
	{
		this.grabEnabled = grabEnabled;
	}

	public function addRope(rope:Rope)
	{
		_midSprites.add(rope);
		_shadowGroup._extraShadows.push(new RopeShadow(rope));
	}

	public function removeRope(rope:Rope)
	{
		_midSprites.remove(rope);
		for (shadow in _shadowGroup._extraShadows)
		{
			if (Std.isOfType(shadow, RopeShadow) && cast(shadow, RopeShadow).rope == rope)
			{
				_shadowGroup._extraShadows.remove(shadow);
			}
		}
	}

	function emitSmallSpark(x:Float, y:Float):Void
	{
		smallSparkEmitter.setPosition(x, y);
		smallSparkEmitter.start(true, 0, 1);
		for (i in 0...8)
		{
			var particle:LateFadingFlxParticle = smallSparkEmitter.emitParticle();
			particle.enableLateFade(2);
			if (i % 8 < 4)
			{
				particle.velocity.x *= 0.5;
				particle.velocity.y *= 0.5;
			}
			if (i % 4 < 2)
			{
				particle.velocity.x *= -1;
			}
			if (i % 2 < 1)
			{
				particle.velocity.y *= -1;
			}
		}
		smallSparkEmitter.emitting = false;
	}

	function eventDecideRow(args:Array<Dynamic>)
	{
		var row = args[0];
		var time = args[1];
		tugRows[row].decideRowSoon(time);
	}

	function eventDecideMatchSoon(args:Array<Dynamic>)
	{
		decideMatchTimer = 0.5;
	}

	/**
	 * Returns an array of floats corresponding to the times that critters get
	 * locked. The first half of the array corresponds to the left player, and
	 * the right half of the array corresponds to the right player.
	 *
	 * 1. All tug times should be a few milliseconds apart, so that we aren't
	 * in the position where we need to hard tug in two different
	 * directions simultaneously
	 *
	 * 2. Whoever gets the first bug locked (which is bad) should have the last
	 * bug locked (which is good)
	 *
	 * 3. The first 2-3 bugs should alternate; a player shouldn't have 2-3 bugs
	 * left at the end, when the other player is finished. That's too much of
	 * an advantage.
	 */
	function computeTugTimes():Array<Float>
	{
		var movableCritterCount:Int = Std.int(_critters.length / 2) - tugRows.length;
		var tempTugTimes:Array<Float> = [];
		var tugTime:Float = roundDurations[round][1];
		while (tugTime > roundDurations[round][0])
		{
			tempTugTimes.push(tugTime);
			tugTime -= FlxG.random.float(0.4, 0.6);
		}
		FlxG.random.shuffle(tempTugTimes);
		tempTugTimes = tempTugTimes.splice(0, movableCritterCount * 2);
		tempTugTimes.sort(function(a, b) return a < b ? -1 : 1);
		tempTugTimes[tempTugTimes.length - 1] = tempTugTimes[tempTugTimes.length - 2] + 3; // last bug is always on a 3-second delay
		var oddTugTimes:Array<Float> = [];
		if (movableCritterCount % 2 == 1)
		{
			// pick two "middlish" tug times, and store them for later...
			oddTugTimes.push(tempTugTimes.splice(Std.int(tempTugTimes.length / 2) - 1, 1)[0]);
			oddTugTimes.push(tempTugTimes.splice(Std.int(tempTugTimes.length / 2) - 1, 1)[0]);
			FlxG.random.shuffle(oddTugTimes);
		}

		var tugTimes:Array<Float> = [];
		while (tempTugTimes.length > 0)
		{
			var time0:Float = tempTugTimes.pop();
			var time1:Float = tempTugTimes.pop();
			if (FlxG.random.bool())
			{
				var tmp:Float = time0;
				time0 = time1;
				time1 = tmp;
			}
			tugTimes.push(time0);
			tugTimes.insert(0, time1);
		}

		if (oddTugTimes.length >= 2)
		{
			// take the two "middlish" tug times, and assign them to each team
			tugTimes.insert(0, oddTugTimes[0]);
			tugTimes.push(oddTugTimes[1]);
		}
		return tugTimes;
	}

	override public function dialogTreeCallback(msg:String):String
	{
		super.dialogTreeCallback(msg);
		if (msg == "%skip-minigame%")
		{
			setState(500);
		}
		if (msg == "%skip-tutorial%")
		{
			_eventStack.reset();
			tutorialAi.stopRound();
			for (critter in _critters)
			{
				critter.setIdle();
				critter._eventStack.reset();
			}

			setState(105);
		}
		if (msg == "%restart-tutorial%")
		{
			var tree:Array<Array<Object>> = TutorialDialog.tugGamePartOneAbruptHandoff();
			launchTutorial(tree);
		}
		if (msg == "%tug-tutorial-setup%")
		{
			moveCrittersIntoPosition(true);
			grabEnabled = true;
			// can't dismiss until everyone's in place
			_dialogger._canDismiss = false;
		}
		if (StringTools.startsWith(msg, "%tugmove%"))
		{
			tutorialAi.doTutorialDrop();
		}
		if (StringTools.startsWith(msg, "%tugleap%"))
		{
			_eventStack.addEvent({time:_eventStack._time + 0.3, callback:eventHardTug, args:[model.getCritterAt(true, 1, 0)]});
			_eventStack.addEvent({time:_eventStack._time + 0.6, callback:eventHardTug, args:[model.getCritterAt(true, 1, 1)]});
		}
		return null;
	}

	function launchTutorial(tree:Array<Array<Object>>)
	{
		// rearrange bugs in 3-2-2 setup
		prepareRound();

		opponentChatFace.loadGraphic(tutorialAi.agent.chatAsset, true, 73, 71);
		setChatFace(FlxG.random.getObject(tutorialAi.agent.neutralFaces));
		setState(70);
		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (_gameState == 95 || _gameState == 100)
		{
			if (!DialogTree.isDialogging(_dialogTree))
			{
				var tree:Array<Array<Object>> = [];
				if (_gameState == 95)
				{
					agent.gameDialog.popPostTutorialGameStartQuery(tree, description);
				}
				else
				{
					handleGameAnnouncement(tree);
					agent.gameDialog.popGameStartQuery(tree);
				}
				_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
				_dialogTree.go();

				setState(105);
			}
		}

		if (_gameState == 105)
		{
			if (!DialogTree.isDialogging(_dialogTree))
			{
				prepareRound();
				moveCrittersIntoPosition();

				// reset the chat face; it might have been changed to smeargle for the tutorial
				opponentChatFace.loadGraphic(agent.chatAsset, true, 73, 71);
				setChatFace(FlxG.random.getObject(agent.neutralFaces));

				setState(200);
			}
		}

		if (DialogTree.isDialogging(_dialogTree) && _grabbedCritter != null)
		{
			// don't grab while dialog is going on
			handleUngrab();
		}

		if (_gameState == 70)
		{
			if (!DialogTree.isDialogging(_dialogTree))
			{
				tutorialMovedAnything = false;
				tutorialIdleTime = 0;
				setState(75);
			}
		}

		if (_gameState == 75)
		{
			tutorialIdleTime += elapsed;
			if (!tutorialMovedAnything)
			{
			}
			else if (_stateTime < 7.5)
			{
			}
			else if (_grabbedCritter != null)
			{
			}
			else if (tutorialIdleTime < 3.0)
			{
			}
			else
			{
				// done moving critters around; transition to next tutorial section
				var tree:Array<Array<Object>> = TutorialDialog.tugGamePartTwo();
				_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
				_dialogTree.go();
				setState(80);
			}
		}

		if (_gameState == 80)
		{
			if (!DialogTree.isDialogging(_dialogTree))
			{
				setState(85);
			}
		}

		if (_gameState == 85)
		{
			_eventStack.removeEvent(eventHardTug);
			_eventStack.removeEvent(eventDecideRow);
			_eventStack.removeEvent(eventDecideMatchSoon);
			for (i in 0...tugRows.length)
			{
				_eventStack.addEvent({time:_eventStack._time + 0.3 * i, callback:eventDecideRow, args:[i, 0.3 * (i + 1)]});
			}
			_eventStack.addEvent({time:_eventStack._time, callback:eventDecideMatchSoon});
			setState(90);
		}

		if (_gameState == 200 || _gameState < 100)
		{
			if (tutorial)
			{
				tutorialAi.update(elapsed);
			}
			else
			{
				ai.update(elapsed);
			}

			randomTugTimer -= elapsed;
			if (randomTugTimer <= 0)
			{
				randomTugTimer += (RANDOM_TUG_FREQUENCY * FlxG.random.float(0, 2)) / tugRows.length;
				var moveRow:Int = FlxG.random.int(0, tugRows.length - 1);

				// are there any critters tugging on the left/right side?
				var leftCritterTugging:Bool = false;
				var rightCritterTugging:Bool = false;
				for (critter in tugRows[moveRow].rowCritters)
				{
					if (isTugAnim(critter))
					{
						if (isLeftTeam(critter))
						{
							leftCritterTugging = true;
						}
						else
						{
							rightCritterTugging = true;
						}
					}
				}

				if (Math.abs(tugRows[moveRow].tugVelocity) > 15)
				{
					// being yanked; let it get yanked
				}
				else if (tugRows[moveRow].isRowDecided())
				{
					// row has been decided; don't move it
				}
				else
				{
					var randomTugDirection:Float = FlxG.random.float();
					randomTugDirection += 0.13 * (tugRows[moveRow].rightCritters.length - tugRows[moveRow].leftCritters.length);

					if (!grabEnabled)
					{
						// don't mess with the velocity until the round officially starts
					}
					else if (randomTugDirection < 0.2)
					{
						tugRows[moveRow].tugVelocity = -8;
					}
					else if (randomTugDirection < 0.4)
					{
						tugRows[moveRow].tugVelocity = -5;
					}
					else if (randomTugDirection < 0.5)
					{
						tugRows[moveRow].tugVelocity = -3;
					}
					else if (randomTugDirection < 0.6)
					{
						tugRows[moveRow].tugVelocity = 3;
					}
					else if (randomTugDirection < 0.8)
					{
						tugRows[moveRow].tugVelocity = 5;
					}
					else
					{
						tugRows[moveRow].tugVelocity = 8;
					}

					// if there are no critters tugging, don't move the chest in their direction
					if (!leftCritterTugging)
					{
						tugRows[moveRow].tugVelocity = Math.min(0, tugRows[moveRow].tugVelocity);
					}
					if (!rightCritterTugging)
					{
						tugRows[moveRow].tugVelocity = Math.max(0, tugRows[moveRow].tugVelocity);
					}
				}

				var stopRow:Int = FlxG.random.int(0, tugRows.length - 1);
				if (Math.abs(tugRows[stopRow].tugVelocity) > 15)
				{
					// being yanked; don't stop
				}
				else if (tugRows[stopRow].isRowDecided())
				{
					// row has been decided; don't stop
				}
				else if (stopRow == moveRow)
				{
					// just started being moved; don't stop
				}
				else
				{
					tugRows[stopRow].tugVelocity = 0;
				}
			}

			for (row in 0...tugRows.length)
			{
				tugRows[row].update(elapsed);
			}

			if (decideMatchTimer > 0)
			{
				decideMatchTimer -= elapsed;
				if (decideMatchTimer <= 0)
				{
					var matchDecided:Bool = true;
					for (tugRow in tugRows)
					{
						if (!tugRow.isRowDecided())
						{
							matchDecided = false;
							break;
						}
					}
					if (matchDecided)
					{
						if (tutorial)
						{
							tutorialAi.stopRound();
						}
						else
						{
							ai.stopRound();
						}

						var eventTime:Float = _eventStack._time + 2.5;
						var minReactionTime:Float = eventTime + tugRows.length * 0.3;
						var maxReactionTime:Float = eventTime + tugRows.length * 0.6 + 1.2;
						for (row in 0...tugRows.length)
						{
							_eventStack.addEvent({time:eventTime, callback:eventShowRowResult, args:[row]});
							eventTime += 0.6;
						}

						var reactionDelay:Float = maxReactionTime;
						if (agent.mathDevianceTrait == Trait.Perfect)
						{
							reactionDelay = minReactionTime + FlxG.random.float(-0.3, 0.3);
						}
						else if (agent.mathDevianceTrait == Trait.Great)
						{
							reactionDelay = minReactionTime * 0.25 + maxReactionTime * 0.75 + FlxG.random.float(-0.3, 0.3);
						}
						else if (agent.mathDevianceTrait == Trait.Good)
						{
							reactionDelay = minReactionTime * 0.5 + maxReactionTime * 0.5 + FlxG.random.float(-0.3, 0.3);
						}
						else if (agent.mathDevianceTrait == Trait.Bad)
						{
							reactionDelay = minReactionTime * 0.75 + maxReactionTime * 0.25 + FlxG.random.float(-0.3, 0.3);
						}
						else if (agent.mathDevianceTrait == Trait.Awful)
						{
							reactionDelay = maxReactionTime + FlxG.random.float(-0.3, 0.3);
						}

						_eventStack.addEvent({time:reactionDelay, callback:eventOpponentReact});
						_eventStack.addEvent({time:eventTime + 0.6, callback:eventStarburst});
					}
					else
					{
						decideMatchTimer = 0.5;
					}
				}
			}

			if (tugScoreboard.exists && tugScoreboard.finishedTimer > 1.3 && !DialogTree.isDialogging(_dialogTree))
			{
				tugScoreboard.exists = false;
				if (round >= 2)
				{
					gameOver();
				}
				else if (round < 2)
				{
					round++;
					prepareRound();
					moveCrittersIntoPosition();
				}
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
			}
		}

		if (_gameState == 500)
		{
			var tree:Array<Array<Object>> = agent.gameDialog.popSkipMinigame();
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
	}

	function eventTutorialPartThree(args:Array<Dynamic>)
	{
		var comScore:Int = args[0];
		var manScore:Int = args[1];

		var tree:Array<Array<Object>> = TutorialDialog.tugGamePartThree(manScore - comScore);
		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();
		setState(95);
	}

	function gameOver()
	{
		setState(400);

		finalScoreboard = new TugFinalScoreboard(this);
		showFinalScoreboard();

		var tree:Array<Array<Object>> = [];
		if (PlayerData.playerIsInDen)
		{
			handleDenGameOver(tree, tugScoreboard.manTotalScore >= tugScoreboard.comTotalScore);
		}
		else if (tugScoreboard.manTotalScore >= tugScoreboard.comTotalScore)
		{
			// player won
			agent.gameDialog.popPlayerBeatMe(tree, finalScoreboard._totalReward);
		}
		else
		{
			// player lost
			agent.gameDialog.popBeatPlayer(tree, finalScoreboard._totalReward);
		}
		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();

		opponentChatFace.visible = false;
		opponentFrame.visible = false;
	}

	function eventShowRowResult(args:Array<Dynamic>)
	{
		var row:Int = args[0];
		var leftBig:Bool = tugRows[row].rowDecided == LeftWins;
		var rightBig:Bool = tugRows[row].rowDecided == RightWins;

		var leftShadow:FlxSprite = new FlxSprite(235, tugRows[row].y - 70);
		leftShadow.loadGraphic(AssetPaths.tentnum_shadow__png, true, 80, 100);
		leftShadow.animation.frameIndex = FlxG.random.int(0, leftShadow.animation.numFrames - 1);
		rowResultGroup.add(leftShadow);

		var leftNum:FlxSprite = new FlxSprite(235, tugRows[row].y - 70);
		leftNum.loadGraphic(leftBig ? AssetPaths.tentnum_big__png : AssetPaths.tentnum_small__png, true, 80, 100);
		leftNum.animation.frameIndex = (tugRows[row].rowDecidedLeft <= 9 ? tugRows[row].rowDecidedLeft : 0);
		rowResultGroup.add(leftNum);

		if (leftBig)
		{
			leftBigShadows.push(leftShadow);
			leftBigNums.push(leftNum);
		}

		var rightShadow:FlxSprite = new FlxSprite(460, tugRows[row].y - 70);
		rightShadow.loadGraphic(AssetPaths.tentnum_shadow__png, true, 80, 100);
		rightShadow.animation.frameIndex = FlxG.random.int(0, rightShadow.animation.numFrames - 1);
		rowResultGroup.add(rightShadow);

		var rightNum:FlxSprite = new FlxSprite(460, tugRows[row].y - 70);
		rightNum.loadGraphic(rightBig ? AssetPaths.tentnum_big__png : AssetPaths.tentnum_small__png, true, 80, 100);
		rightNum.animation.frameIndex = (tugRows[row].rowDecidedRight <= 9 ? tugRows[row].rowDecidedRight : 0);
		rowResultGroup.add(rightNum);

		if (rightBig)
		{
			rightBigShadows.push(rightShadow);
			rightBigNums.push(rightNum);
		}

		SoundStackingFix.play(AssetPaths.beep_0065__mp3);
	}

	function eventOpponentReact(args:Array<Dynamic>)
	{
		var leftSum:Int = 0;
		var rightSum:Int = 0;
		for (tugRow in tugRows)
		{
			if (tugRow.rowDecided == LeftWins)
			{
				leftSum += tugRow.rowReward;
			}
			else if (tugRow.rowDecided == RightWins)
			{
				rightSum += tugRow.rowReward;
			}
		}

		var agent:TugAgent = tutorial ? tutorialAi.agent : this.agent;
		if (leftSum > rightSum)
		{
			setChatFace(FlxG.random.getObject(agent.goodFaces));
		}
		else if (leftSum == rightSum)
		{
			setChatFace(FlxG.random.getObject(agent.thinkyFaces));
		}
		else if (leftSum < rightSum)
		{
			setChatFace(FlxG.random.getObject(agent.badFaces));
		}
	}

	public function setChatFace(frameIndex:Int)
	{
		opponentChatFace.animation.frameIndex = frameIndex;
		if (tugScoreboard != null)
		{
			tugScoreboard.comPortrait.animation.frameIndex = frameIndex;
		}
	}

	function eventStarburst(args:Array<Dynamic>)
	{
		var leftSum:Int = 0;
		var rightSum:Int = 0;
		for (tugRow in tugRows)
		{
			if (tugRow.rowDecided == LeftWins)
			{
				leftSum += tugRow.rowReward;
			}
			else if (tugRow.rowDecided == RightWins)
			{
				rightSum += tugRow.rowReward;
			}
		}
		var bigShadows:Array<FlxSprite> = [];
		var bigNums:Array<FlxSprite> = [];
		if (leftSum > rightSum) { bigShadows = leftBigShadows; bigNums = leftBigNums; }
		if (rightSum > leftSum) { bigShadows = rightBigShadows; bigNums = rightBigNums; }
		for (bigShadow in bigShadows)
		{
			bigShadow.loadGraphic(AssetPaths.tentnum_starburst__png, true, 80, 100);
			bigShadow.animation.add("default", AnimTools.blinkyAnimation(FlxG.random.getObject([[0, 1, 2], [3, 4, 5], [6, 7, 8]])), 3);
			bigShadow.animation.play("default");

			emitSmallSpark(bigShadow.x + 40 + FlxG.random.float( -15, 15), bigShadow.y + 75 + FlxG.random.float( -10, 10));
		}
		for (bigNum in bigNums)
		{
			FlxTween.tween(bigNum.scale, {x:1.33, y:1.33}, 0.2, {ease:FlxEase.cubeInOut});
			FlxTween.tween(bigNum.scale, {x:1, y:1}, 0.4, {ease:FlxEase.cubeInOut, startDelay:0.2});
		}
		if (bigShadows.length > 0)
		{
			SoundStackingFix.play(AssetPaths.confetti_0029__mp3);
		}

		var winningCritters:Array<Critter> = [];

		for (critter in _critters)
		{
			if (isLeftTeam(critter) ? (leftSum > rightSum) : (rightSum > leftSum))
			{
				_eventStack.addEvent({time:_eventStack._time + FlxG.random.float(0, 1), callback:eventHappy, args:[critter, true]});
				_eventStack.addEvent({time:_eventStack._time + FlxG.random.float(1, 3), callback:eventHappy, args:[critter, true]});
				_eventStack.addEvent({time:_eventStack._time + FlxG.random.float(3, 5), callback:eventHappy, args:[critter, false]});
			}
		}

		if (_gameState < 100)
		{
			// tutorial; don't show scoreboard
			_eventStack.addEvent({time:_eventStack._time + 2.0, callback:eventTutorialPartThree, args:[leftSum, rightSum]});
		}
		else
		{
			showScoreboardSoon(leftSum, rightSum);
		}
	}

	private function showScoreboardSoon(leftScore:Int, rightScore:Int)
	{
		_eventStack.addEvent({time:_eventStack._time + 4.0, callback:eventAppendScores, args:[round * 2, MmStringTools.commaSeparatedNumber(leftScore), MmStringTools.commaSeparatedNumber(rightScore)]});
		var bonusScores:Array<Dynamic> = [round * 2 + 1, "-", "-"];
		if (leftScore > rightScore)
		{
			bonusScores[1] = Std.string(roundBonus[round]);
		}
		if (rightScore > leftScore)
		{
			bonusScores[2] = Std.string(roundBonus[round]);
		}
		_eventStack.addEvent({time:_eventStack._time + 4.6, callback:eventAppendScores, args:bonusScores});
		_eventStack.addEvent({time:_eventStack._time + 5.6, callback:eventAccumulateScores});

		_eventStack.addEvent({time:_eventStack._time + 3.0, callback:eventShowScoreboard, args:[leftScore + Std.parseInt(bonusScores[1]), rightScore + Std.parseInt(bonusScores[2])]});
	}

	function eventShowScoreboard(args:Array<Dynamic>)
	{
		var comRoundScore:Int = args[0];
		var manRoundScore:Int = args[1];
		tugScoreboard.show();
		maybeReleaseCritter();

		var tree:Array<Array<Object>> = [];
		if (round == 0)
		{
			_dialogger._promptsTransparent = true;
			if (comRoundScore > manRoundScore)
			{
				agent.gameDialog.popRoundWin(tree);
			}
			else if (comRoundScore > manRoundScore)
			{
				agent.gameDialog.popRoundStart(tree, round + 2);
			}
			else
			{
				agent.gameDialog.popRoundLose(tree, PlayerData.name, PlayerData.gender);
			}
		}
		else if (round == 1)
		{
			_dialogger._promptsTransparent = true;
			if (tugScoreboard.comTotalScore + comRoundScore > tugScoreboard.manTotalScore + manRoundScore)
			{
				agent.gameDialog.popWinning(tree);
			}
			else if (tugScoreboard.comTotalScore + comRoundScore == tugScoreboard.manTotalScore + manRoundScore)
			{
				agent.gameDialog.popRoundStart(tree, round + 2);
			}
			else
			{
				agent.gameDialog.popLosing(tree, PlayerData.name, PlayerData.gender);
			}
		}

		_eventStack.addEvent({time:_eventStack._time + 2.0, callback:eventDialog, args:[tree]});
	}

	public function eventDialog(args:Array<Dynamic>)
	{
		var tree:Array<Array<Object>> = args[0];
		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();
	}

	function eventAppendScores(args:Array<Dynamic>)
	{
		var scoreIndex:Int = args[0];
		var comScoreString:String = args[1];
		var manScoreString:String = args[2];
		tugScoreboard.appendScores(scoreIndex, comScoreString, manScoreString);
	}

	function eventAccumulateScores(args:Array<Dynamic>)
	{
		tugScoreboard.accumulateScores();

	}

	function eventHappy(args:Array<Dynamic>)
	{
		var critter:Critter = args[0];
		var canHop:Bool = args[1];
		if (critter.isIdle())
		{
			if (canHop)
			{
				critter.playAnim(FlxG.random.getObject(["complex-hop", "idle-veryhappy0", "idle-veryhappy1", "idle-veryhappy2"], [2, 1, 1, 1]));
			}
			else
			{
				critter.playAnim(FlxG.random.getObject(["idle-veryhappy0", "idle-veryhappy1", "idle-veryhappy2"]));
			}
		}
	}

	function eventHardTug(args:Array<Dynamic>)
	{
		var critter:Critter = args[0];

		if (critter._bodySprite.animation.name == "grab")
		{
			// find a random critter instead
			var choices:Array<Critter> = [];
			for (row in 0...tugRows.length)
			{
				for (c in 0...tugRows[row].rightCritters.length)
				{
					if (!model.isInTent(tugRows[row].rightCritters[c]))
					{
						choices.push(tugRows[row].rightCritters[c]);
					}
				}
			}

			if (choices.length == 0)
			{
				// try again in 0.5s...
				_eventStack.addEvent({time:_eventStack._time + 0.5, callback:eventHardTug, args:[critter]});
				return;
			}

			var newCritter:Critter = FlxG.random.getObject(choices);
			hijackHardTugEvent(newCritter, critter);
			critter = newCritter;
		}

		// determine critter row
		var critterRow:Int = model.getCritterRow(critter);

		// determine tugged critter in that row
		var tuggedCritter:Critter = null;
		if (critterRow == -1)
		{
			// critter isn't assigned to a row...? Shouldn't happen...
			return;
		}

		var alliedRowCritters:Array<Critter> = tugRows[critterRow].getAlliedRowCritters(critter);
		for (i in 1...alliedRowCritters.length)
		{
			var potentialTuggedCritter = alliedRowCritters[i];
			if (model.isInTent(potentialTuggedCritter))
			{
				// can't tug critter; he's already in tent
			}
			else if (!isTugAnim(potentialTuggedCritter))
			{
				// can't tug critter; he's not pulling the rope
			}
			else if (model.isLeapt(potentialTuggedCritter))
			{
				// can't tug critter; he's already leapt
			}
			else
			{
				tuggedCritter = potentialTuggedCritter;
				break;
			}
		}

		if (tuggedCritter == null)
		{
			// no target... maybe critters haven't made it to the rope yet, or something like that
			// try again in 0.5s...
			_eventStack.addEvent({time:_eventStack._time + 0.5, callback:eventHardTug, args:[critter]});
			return;
		}

		hijackHardTugEvent(tuggedCritter, critter);

		var hardTugDir:Int = isLeftTeam(tuggedCritter) ? 1 : -1;
		tugRows[critterRow].tugVelocity = hardTugDir * 60;

		_eventStack.addEvent({time:_eventStack._time + 0.25, callback:eventStopRow, args:[critterRow]});
		_eventStack.addEvent({time:_eventStack._time + 0.15, callback:eventLeapFromRope, args:[tuggedCritter, true]});
		model.setLeapt(tuggedCritter, true);
	}

	function hijackHardTugEvent(changeFrom:Critter, changeTo:Critter)
	{
		// copy our original critter into their event args, so that we'll be tugged again later
		for (event in _eventStack._events)
		{
			if (event.callback == eventHardTug && event.args[0] == changeFrom)
			{
				event.args[0] = changeTo;
			}
		}
	}

	public function eventLeapFromRope(args:Array<Dynamic>)
	{
		var tuggedCritter:Critter = args[0];
		var runIntoTent:Bool = args[1];
		var hardTugDir:Int = isLeftTeam(tuggedCritter) ? 1 : -1;

		// innermost critter leaps forward...
		tuggedCritter._bodySprite._jumpSpeed = 300;
		tuggedCritter.jumpTo(tuggedCritter._bodySprite.x + 100 * hardTugDir, tuggedCritter._bodySprite.y + 5, 0, runIntoTent ? eventRunIntoTent : null);
		if (FlxG.random.bool(13) || !runIntoTent)
		{
			tuggedCritter.updateMovingPrefix("tumble");
		}

		if (runIntoTent)
		{
			model.setInTent(tuggedCritter, true);
		}

		fillGaps(isLeftTeam(tuggedCritter), model.getCritterRow(tuggedCritter));
	}

	function eventGrabRope(critter:Critter)
	{
		var row:Int = model.getCritterRow(critter);
		unassignFromRow(critter, false);
		assignToRow(critter, row);
	}

	function eventInitialGrabRope(critter:Critter)
	{
		var row:Int = model.getCritterRow(critter);
		var col:Int = model.getCritterColumn(critter);

		if (col <= 3)
		{
			critter.playAnim(FlxG.random.getObject(["tug-good", "tug-bad"]));
			critter._bodySprite.facing = isLeftTeam(critter) ? FlxDirectionFlags.RIGHT : FlxDirectionFlags.LEFT;
		}

		if (model.isInTent(critter))
		{
			var tent:Tent = isLeftTeam(critter) ? tugRows[row].leftTent : tugRows[row].rightTent;
			tent.flash();
			SoundStackingFix.play(AssetPaths.drop__mp3);
		}

		// maybe start round; enable grabbing, etc?
		var allCrittersGrabbed:Bool = true;
		for (critter in _critters)
		{
			if (!isTugAnim(critter) && model.getCritterColumn(critter) <= 3)
			{
				allCrittersGrabbed = false;
				break;
			}
		}
		if (allCrittersGrabbed)
		{
			if (tutorial)
			{
				// don't launch countdown or AI during tutorial; just enable grabbing
				setGrabEnabled(true);
				_dialogger._canDismiss = true;
			}
			else
			{
				countdownSprite.startCount();
				ai.startRound();
				_eventStack.addEvent({time:_eventStack._time + CountdownSprite.COUNTDOWN_SECONDS * 3, callback:eventStartRound});
			}
		}
	}

	public function eventStartRound(args:Array<Dynamic>)
	{
		SoundStackingFix.play(AssetPaths.countdown_go_005c__mp3);
		setGrabEnabled(true);

		var tugTimes:Array<Float> = computeTugTimes();

		// schedule round end
		var maxTugTime:Float = 0;
		for (tugTime in tugTimes)
		{
			maxTugTime = Math.max(maxTugTime, tugTime);
		}
		var eventTime:Float = _eventStack._time + maxTugTime;
		var rowIndexes:Array<Int> = [];
		for (i in 0...tugRows.length)
		{
			rowIndexes.push(i);
		}
		FlxG.random.shuffle(rowIndexes);
		for (i in 0...rowIndexes.length)
		{
			_eventStack.addEvent({time:_eventStack._time + maxTugTime + 0.3 * i, callback:eventDecideRow, args:[rowIndexes[i], 5.0]});
		}
		_eventStack.addEvent({time:_eventStack._time + maxTugTime, callback:eventDecideMatchSoon});

		for (critter in _critters)
		{
			if (!model.isInTent(critter))
			{
				// non-tent critters are assigned a random "tug time" when they're tugged into tents
				var tugTime:Float = isLeftTeam(critter) ? tugTimes.pop() : tugTimes.splice(0, 1)[0];
				if (tugTime == maxTugTime)
				{
					// final critter doesn't get sucked into tent
					finalCritter = critter;
				}
				else
				{
					_eventStack.addEvent({time:_eventStack._time + tugTime, callback:eventHardTug, args:[critter]});
				}
			}
		}
	}

	public function eventRunIntoTent(critter:Critter)
	{
		var tumbleType:Int = 0;
		if (critter._bodySprite.movingPrefix == "tumble")
		{
			tumbleType = FlxG.random.getObject([1, 2, 3], [5, 3, 1]);
		}

		var critterRow:Int = model.getCritterRow(critter);
		var alliedTent:Tent = isLeftTeam(critter) ? tugRows[critterRow].leftTent : tugRows[critterRow].rightTent;
		alliedTent.flash();

		if (tumbleType == 2)
		{
			// hard splat
			_eventStack.addEvent({time:_eventStack._time + 1.0, callback:eventRecoverFromTumbleAndRunIntoTent, args:[critter]});
			return;
		}

		var alliedRowCritters:Array<Critter> = tugRows[critterRow].getAlliedRowCritters(critter);
		critter.runTo(alliedRowCritters[0]._bodySprite.x, alliedRowCritters[0]._bodySprite.y, eventContinueTuggingInTent);
		if (tumbleType == 3)
		{
			// tumble into tent
			critter.updateMovingPrefix("tumble");
		}
	}

	function eventRecoverFromTumbleAndRunIntoTent(args:Array<Dynamic>)
	{
		var critter:Critter = args[0];
		var critterRow:Int = model.getCritterRow(critter);
		var alliedRowCritters:Array<Critter> = isLeftTeam(critter) ? tugRows[critterRow].leftCritters : tugRows[critterRow].rightCritters;

		critter.runTo(alliedRowCritters[0]._bodySprite.x, alliedRowCritters[0]._bodySprite.y, eventContinueTuggingInTent);
	}

	function eventContinueTuggingInTent(critter:Critter)
	{
		var critterRow:Int = model.getCritterRow(critter);
		var alliedRowCritters:Array<Critter> = isLeftTeam(critter) ? tugRows[critterRow].leftCritters : tugRows[critterRow].rightCritters;

		// adopt tugging pose
		critter._bodySprite.facing = isLeftTeam(critter) ? FlxDirectionFlags.RIGHT : FlxDirectionFlags.LEFT; // might have gotten turned around
		critter.playAnim(FlxG.random.getObject(["tug-good", "tug-bad"]));
	}

	public static function isTugAnim(critter:Critter)
	{
		return critter._bodySprite.animation.name != null && StringTools.startsWith(critter._bodySprite.animation.name, "tug-");
	}

	function eventStopRow(args:Array<Dynamic>)
	{
		var rowIndex:Int = args[0];
		if (tugRows[rowIndex].isRowDecided())
		{
			// row has been decided; don't stop
			return;
		}
		tugRows[rowIndex].tugVelocity = 0;
	}

	override function handleMousePress():Void
	{
		maybeGrabCritter();
	}

	public function unassignFromRow(critter:Critter, shouldFillGaps:Bool)
	{
		var row:Int = model.getCritterRow(critter);
		if (row == -1)
		{
			// critter is not assigned to a row
			return;
		}

		// is a critter available to run in and replace this grabbed critter?
		var col:Int = model.getCritterColumn(critter);

		model.unassignFromRow(critter);
		model.setLeapt(critter, false);
		model.setInTent(critter, false);

		tugRows[row].getAlliedRowCritters(critter).remove(critter);
		tugRows[row].rowCritters.remove(critter);

		if (shouldFillGaps)
		{
			fillGaps(isLeftTeam(critter), row);
		}
	}

	/**
	 * shift idle critters into empty gaps
	 */
	private function fillGaps(leftTeam:Bool, row:Int)
	{
		var colCount:Int = model.getAlliedColumnCount(leftTeam, row);
		for (col in 4...colCount)
		{
			var critter:Critter = model.getCritterAt(leftTeam, row, col);
			if (critter != null)
			{
				model.unassignFromRow(critter);
				model.assignToRow(critter, row);
				var targetLocation:FlxPoint = getCritterTargetLocation(critter, row, model.getCritterColumn(critter));
				critter.runTo(targetLocation.x, targetLocation.y, eventGrabRope);
			}
		}
	}

	override function handleMouseRelease():Void
	{
		maybeReleaseCritter();
	}

	override public function handleUngrab():Void
	{
		_cursorSprites.remove(_grabbedCritter._targetSprite, true);
		_cursorSprites.remove(_grabbedCritter._soulSprite, true);
		_cursorSprites.remove(_grabbedCritter._bodySprite, true);
		_cursorSprites.remove(_grabbedCritter._headSprite, true);
		_cursorSprites.remove(_grabbedCritter._frontBodySprite, true);
		_targetSprites.add(_grabbedCritter._targetSprite);
		_midInvisSprites.add(_grabbedCritter._soulSprite);
		_midSprites.add(_grabbedCritter._bodySprite);
		_midSprites.add(_grabbedCritter._headSprite);
		_midSprites.add(_grabbedCritter._frontBodySprite);

		_grabbedCritter.ungrab();

		// which row is closest?
		var closestRow:Int = 0;
		var closestRowDist:Float = Math.abs(tugRows[closestRow].y - _grabbedCritter._bodySprite.y);
		for (row in 1...tugRows.length)
		{
			var rowDist:Float = Math.abs(tugRows[row].y - _grabbedCritter._bodySprite.y);
			if (rowDist < closestRowDist)
			{
				closestRow = row;
				closestRowDist = rowDist;
			}
		}

		if (!tugRows[closestRow].isRowDecided())
		{
			assignToRow(_grabbedCritter, closestRow);
		}

		_grabbedCritter = null;
		_handSprite.animation.frameIndex = 0;
		_thumbSprite.animation.frameIndex = 0;
		_thumbSprite.offset.y = _handSprite.offset.y + 10;
		_thumbSprite.y = _handSprite.y + 10;

		if (_gameState == 75)
		{
			tutorialMovedAnything = true;
			tutorialIdleTime = 0;
		}
	}

	public function getCritterTargetLocation(critter:Critter, row:Int, col:Int):FlxPoint
	{
		var isAnchorCritter:Bool = tugRows[row].getAlliedRowCritters(critter).length == 0;
		var alliedRowCritters:Array<Critter> = tugRows[row].getAlliedRowCritters(critter);
		var targetPos:FlxPoint = FlxPoint.get(FlxG.width / 2, tugRows[row].y);
		// place critter at appropriate X/Y screen position
		if (isAnchorCritter)
		{
			if (isLeftTeam(critter))
			{
				targetPos.x += -127;
			}
			else
			{
				targetPos.x += 90;
			}
		}
		else if (col > 3)
		{
			if (isLeftTeam(critter))
			{
				targetPos.x += -214 + FlxG.random.float(-2, 2) - CRITTER_HORIZONTAL_SPACING * (col - 3.5);
			}
			else
			{
				targetPos.x += 177 + FlxG.random.float(-2, 2) + CRITTER_HORIZONTAL_SPACING * (col - 3.5);
			}
			targetPos.y -= 20;
		}
		else {
			if (isLeftTeam(critter))
			{
				targetPos.x += -214 + FlxG.random.float(-2, 2) - CRITTER_HORIZONTAL_SPACING * col + tugRows[row].tugPosition;
			}
			else {
				targetPos.x += 177 + FlxG.random.float(-2, 2) + CRITTER_HORIZONTAL_SPACING * col + tugRows[row].tugPosition;
			}
		}
		return targetPos;
	}

	public function assignToRow(critter:Critter, row:Int, col:Int = -1)
	{
		var isAnchorCritter:Bool = tugRows[row].getAlliedRowCritters(critter).length == 0;
		var targetPos:FlxPoint = getCritterTargetLocation(critter, row, model.getTargetCol(critter, row));
		var alliedRowCritters:Array<Critter> = tugRows[row].getAlliedRowCritters(critter);

		// which critter am i neighboring?
		if (col == -1)
		{
			col = model.assignToRow(critter, row);
		}
		var outerCritter:Critter = null;
		for (outerCol in col + 1...4)
		{
			outerCritter = model.getCritterAt(isLeftTeam(critter), row, outerCol);
			if (outerCritter != null)
			{
				break;
			}
		}

		// place critter at appropriate X/Y screen position
		if (isAnchorCritter)
		{
			model.setInTent(critter, true);
		}
		else if (col > 3)
		{
			critter.setIdle();
		}
		else
		{
			critter.playAnim(FlxG.random.getObject(["tug-good", "tug-bad"]));
			critter._bodySprite.facing = isLeftTeam(critter) ? FlxDirectionFlags.RIGHT : FlxDirectionFlags.LEFT;
		}
		critter.setPosition(targetPos.x, targetPos.y);

		// assign to leftCritters/rightCritters/rowCritters
		var alliedRowIndex:Int = alliedRowCritters.length;
		for (i in 0...alliedRowCritters.length)
		{
			if (alliedRowCritters[i] == outerCritter)
			{
				alliedRowIndex = i;
			}
		}
		alliedRowCritters.insert(alliedRowIndex, critter);
		tugRows[row].rowCritters.push(critter);
	}

	override public function findGrabbedCritter():Critter
	{
		if (grabEnabled == false)
		{
			return null;
		}
		var critter:Critter = super.findGrabbedCritter();
		if (critter != null)
		{
			unassignFromRow(critter, true);
		}
		return critter;
	}

	public function canGrab(critter:Critter):Bool
	{
		if (_gameState >= 80 && _gameState < 100)
		{
			// can't grab during the latter half of the tutorial
			return false;
		}
		var rowIndex:Int = model.getCritterRow(critter);
		if (rowIndex != -1 && tugRows[rowIndex].isRowDecided())
		{
			// can't grab critter; row has been decided
			return false;
		}
		if (model.isInTent(critter))
		{
			// can't grab critter; it's in the tent
			return false;
		}
		if (model.isLeapt(critter))
		{
			// can't grab critter; it's JUST about to get yanked away
			return false;
		}
		return true;
	}

	public function runHome(critter:Critter)
	{
		if (isLeftTeam(critter))
		{
			critter.runTo(FlxG.random.float(20, 140), FlxG.random.float(26, 406));
			if (critter._bodySprite.x > 180)
			{
				critter.insertWaypoint(FlxG.random.float(100, 160), critter._bodySprite.y);
			}
		}
		else
		{
			critter.runTo(FlxG.random.float(590, 670), FlxG.random.float(26, 406));
			if (critter._bodySprite.x < 550)
			{
				critter.insertWaypoint(FlxG.random.float(570, 630), critter._bodySprite.y);
			}
		}
	}

	override function findClosestCritter(point:FlxPoint, distanceThreshold:Float=40):Critter
	{
		var minDistance:Float = distanceThreshold + 1;
		var closestCritter:Critter = null;
		var closestRow:Int = -1;
		for (critter in _critters)
		{
			if (isLeftTeam(critter))
			{
				// can't grab critter; it's on the left side
				continue;
			}
			var distance:Float = critter._bodySprite.getMidpoint().distanceTo(point);
			if (distance < minDistance)
			{
				if (!canGrab(critter))
				{
					// if we can't grab the critter, we might try to grab another critter in the same row...
					var row:Int = model.getCritterRow(critter);
					if (row != -1)
					{
						closestRow = row;
					}
					continue;
				}
				minDistance = distance;
				closestCritter = critter;
			}
		}

		if ((minDistance >= distanceThreshold || closestCritter == null) && closestRow != -1)
		{
			/*
			 * If they clicked an un-grabbable critter, we grab one in the same
			 * row. A critter is ungrabbable if it's about to jump into the
			 * tent, and it feels like a missed click. This way, most of the
			 * time when that happens the game will still do something that's
			 * less frustrating.
			 */
			var rightCritters = tugRows[closestRow].rightCritters;
			for (critter in rightCritters)
			{
				if (canGrab(critter))
				{
					closestCritter = critter;
					minDistance = 0;
					break;
				}
			}
		}

		return minDistance < distanceThreshold ? closestCritter : null;
	}

	override public function destroy():Void
	{
		super.destroy();

		rowResultGroup = FlxDestroyUtil.destroy(rowResultGroup);
		tugRows = FlxDestroyUtil.destroyArray(tugRows);
		roundDurations = null;
		roundBonus = null;
		model = FlxDestroyUtil.destroy(model);
		finalCritter = FlxDestroyUtil.destroy(finalCritter);
		smallSparkEmitter = FlxDestroyUtil.destroy(smallSparkEmitter);
		leftBigShadows = FlxDestroyUtil.destroyArray(leftBigShadows);
		rightBigShadows = FlxDestroyUtil.destroyArray(rightBigShadows);
		leftBigNums = FlxDestroyUtil.destroyArray(leftBigNums);
		rightBigNums = FlxDestroyUtil.destroyArray(rightBigNums);
		tentColors = null;
		countdownSprite = FlxDestroyUtil.destroy(countdownSprite);
		tugScoreboard = FlxDestroyUtil.destroy(tugScoreboard);
		ai = FlxDestroyUtil.destroy(ai);
		tutorialAi = FlxDestroyUtil.destroy(tutorialAi);
		agent = FlxDestroyUtil.destroy(agent);
		opponentFrame = FlxDestroyUtil.destroy(opponentFrame);
		opponentChatFace = FlxDestroyUtil.destroy(opponentChatFace);
	}
}