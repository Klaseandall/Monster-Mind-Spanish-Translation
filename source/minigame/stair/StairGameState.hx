package minigame.stair;

import minigame.MinigameState.denNerf;
import MmStringTools.*;
import critter.Critter;
import critter.CritterBody;
import critter.SexyAnims;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import kludge.BetterFlxRandom;
import kludge.FlxSpriteKludge;
import kludge.LateFadingFlxParticle;
import openfl.utils.Object;
import poke.rhyd.RhydonResource;
import minigame.MinigameState;
import minigame.stair.StairGameState.StairStatus;

/**
 * The FlxState for the stair climbing minigame.
 *
 * The stair minigame lasts about 20 turns. Each player tries to get their bug
 * up and down the stairs before their opponent. The bugs move 1, 2, 3 or 4
 * spaces each turn with a sort of rock-paper-scissors mechanism where you need
 * to outguess your opponent.
 */
class StairGameState extends MinigameState
{
	public var stairStatus0:StairStatus;
	public var stairStatus1:StairStatus;
	private var extraCritters:Array<Critter> = [];
	public var puzzleArea:FlxRect = FlxRect.get(0, 0, 160, 300);
	private var leds:FlxSprite;

	private var confettiParticles:FlxEmitter;
	private var glowyLights:FlxSprite;
	private var darkness:FlxSprite;
	private var darknessTween:FlxTween;
	public var poofParticles:FlxEmitter;
	// 0: default; 1: emitting gems from stairs; 2: emitting gems from trophy
	private var gemMode:Int = 0;

	public var stairGameLogic:StairGameLogic;

	private var buttonGroup:WhiteGroup;
	public var rollHandler:Array<Dynamic>->Void;

	public var turnIndicator:BouncySprite;
	public var agent:StairAgent;

	public var stateFunction:Float->Void;
	public var stateFunctionTime:Float = 0;
	// if the user clicks the "help" button, we restore them to their previous state afterwards
	public var interruptedStateFunction:Float->Void;
	// if the player is more than 0.5s late, the computer will flagrantly cheat once
	public var computerCheatsOnce:Bool = false;

	// the place you'd jump up from to get to the next stair
	private var stairBot:Array<FlxPoint> = [
			FlxPoint.get(206, 251),
			FlxPoint.get(275, 253 + 15 * 1),
			FlxPoint.get(359, 251 + 15 * 2),
			FlxPoint.get(457, 244 + 15 * 3),
			FlxPoint.get(539, 215 + 15 * 4),
			FlxPoint.get(610, 182 + 15 * 5),
			FlxPoint.get(630, 133 + 15 * 6),
			FlxPoint.get(631, 101 + 15 * 7),
			FlxPoint.get(632,  63 + 15 * 8),
										   ];

	// the place you'd jump down from to get to the previous stair
	private var stairTop:Array<FlxPoint> = [
			FlxPoint.get(170, 220),
			FlxPoint.get(247, 225 + 15 * 1),
			FlxPoint.get(319, 230 + 15 * 2),
			FlxPoint.get(400, 225 + 15 * 3),
			FlxPoint.get(483, 207 + 15 * 4),
			FlxPoint.get(561, 179 + 15 * 5),
			FlxPoint.get(610, 141 + 15 * 6),
			FlxPoint.get(621, 104 + 15 * 7),
			FlxPoint.get(622,  64 + 15 * 8),
										   ];

	// the out-of-the-way area you go if someone's trying to get by
	private var stairSafe:Array<FlxPoint> = [
			FlxPoint.get(234, 279),
			FlxPoint.get(304, 271 + 15 * 1),
			FlxPoint.get(393, 266 + 15 * 2),
			FlxPoint.get(488, 259 + 15 * 3),
			FlxPoint.get(579, 219 + 15 * 4),
			FlxPoint.get(653, 178 + 15 * 5),
			FlxPoint.get(662, 148 + 15 * 6),
			FlxPoint.get(670, 97 + 15 * 7),
			FlxPoint.get(650, 48 + 15 * 8),
											];

	public var bottomSafe:FlxRect = FlxRect.get(75, 300, 100, 100);
	private var acceptingInput:Bool = true;

	private var opponentFrame:RoundedRectangle;
	private var opponentChatFace:FlxSprite;
	private var playerFrame:RoundedRectangle;
	private var playerChatFace:FlxSprite;

	private var countdownSeconds:Float = 0.77;
	private var countdownSprite:FlxSprite;
	private var aiTossTiming:Float = -1; // -1: just toss when the player does
	private var playerTossTiming:Float = 0;
	private var firstTurn:Bool = true;
	private var tutorialBugsMoving:Bool = false;
	private var tutorialRerollCount:Int = 0;

	private var button0:FlxButton;
	private var button1:FlxButton;
	private var button2:FlxButton;

	// if something important happens while we're in the help dialog, we queue it up and call it once the dialog closes
	private var queuedCall:Void->Void = null;
	// if the user clicks the help button after the computer rolls, that's cheaty. if they do it too much, the computer will cheat
	private var helpButtonCheatCount:Int = 0;

	public function new()
	{
		super();
		description = PlayerData.MINIGAME_DESCRIPTIONS[1];
		duration = 3.0;
		avgReward = 1000;
	}

	override public function create():Void
	{
		super.create();
		Critter.shuffleCritterColors();
		if (Critter.CRITTER_COLORS[0].english == Critter.CRITTER_COLORS[1].english)
		{
			// disambiguate critter color names for tutorial
			Critter.CRITTER_COLORS[0].english = substringAfter(Critter.CRITTER_COLORS[0].englishBackup, "/");
			Critter.CRITTER_COLORS[1].english = substringAfter(Critter.CRITTER_COLORS[1].englishBackup, "/");
		}

		_backSprites.add(new FlxSprite(188, -5, AssetPaths.stairs__png));
		var stairShadow:FlxSprite = new FlxSprite(188, -5, AssetPaths.stair_shadow__png);
		_shadowGroup._extraShadows.push(stairShadow);

		turnIndicator = new BouncySprite(0, 0, 6, 2.5, 0);
		turnIndicator.loadGraphic(AssetPaths.stair_turn_indicator__png, true, 60, 36);
		turnIndicator.animation.add("default", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], 6);
		turnIndicator.animation.add("reveal", [3, 2, 0], 6, false);
		turnIndicator.animation.add("hide", [2, 3, 8], 6, false);
		turnIndicator.animation.add("roll-again", [6, 6, 7, 7, 6, 6, 7, 7, 6, 6, 7, 7,
		6, 6, 7, 7, 6, 6, 7, 7, 6, 6, 7, 7,
		6, 6, 7, 7, 6, 6, 5, 4, 3, 2, 0, 0], 12, false);
		turnIndicator.animation.add("invisible", [8], 6, false);
		turnIndicator.offset.x = 11;
		turnIndicator._baseOffsetY = 60;
		turnIndicator.animation.play("invisible");
		_midSprites.add(turnIndicator);

		leds = new FlxSprite(368, 0);
		leds.loadGraphic(AssetPaths.stair_leds__png, true, 400, 300);
		leds.animation.add("blink-lo", [0, 2], 3);
		leds.animation.add("blink-hi", [1, 3], 3);
		leds.visible = false;
		_backSprites.add(leds);

		confettiParticles = new FlxEmitter(0, 0, 12);
		confettiParticles.launchMode = FlxEmitterMode.SQUARE;
		confettiParticles.velocity.start.set(FlxPoint.get(-30, -20), FlxPoint.get(30, 0));
		confettiParticles.velocity.end.set(FlxPoint.get(0, 20));
		confettiParticles.acceleration.start.set(FlxPoint.get(0, 60));
		confettiParticles.acceleration.end.set(FlxPoint.get(0, 60));
		confettiParticles.alpha.start.set(1.0);
		confettiParticles.alpha.end.set(0);
		confettiParticles.lifespan.set(3, 3);
		insert(members.indexOf(_midSprites) + 1, confettiParticles);

		for (i in 0...confettiParticles.maxSize)
		{
			var particle:LateFadingFlxParticle = new LateFadingFlxParticle();
			var frames:Array<Int> = [0, 1, 2, 3, 4, 5];
			FlxG.random.shuffle(frames);
			particle.loadGraphic(AssetPaths.stair_confetti__png, true, 20, 20);
			particle.animation.add("default", frames, 6);
			particle.animation.play("default");
			particle.maxVelocity.y = 20;
			particle.flipX = FlxG.random.bool();
			particle.exists = false;
			confettiParticles.add(particle);
		}

		poofParticles = new FlxEmitter(0, 0, 23);
		insert(members.indexOf(_midSprites) + 1, poofParticles);

		poofParticles.angularVelocity.set(0);
		poofParticles.launchMode = FlxEmitterMode.CIRCLE;
		poofParticles.speed.set(30, 60, 0, 0);
		poofParticles.acceleration.set(0);
		poofParticles.alpha.start.set(0.5, 1.0);
		poofParticles.alpha.end.set(0);
		poofParticles.lifespan.set(0.25, 0.5);

		for (i in 0...poofParticles.maxSize)
		{
			var particle:FlxParticle = new MinRadiusParticle(7);
			particle.loadGraphic(AssetPaths.poofs_tiny__png, true, 20, 20);
			particle.flipX = FlxG.random.bool();
			particle.animation.frameIndex = FlxG.random.int(0, particle.animation.numFrames);
			particle.exists = false;
			poofParticles.add(particle);
		}

		stairStatus0 = new StairStatus(this, 0);
		addCritter(stairStatus0.critter);

		stairStatus1 = new StairStatus(this, 1);
		addCritter(stairStatus1.critter);

		for (i in 0...8)
		{
			var critter:Critter = new Critter(FlxG.random.float(puzzleArea.left, puzzleArea.right), FlxG.random.float(puzzleArea.top, puzzleArea.bottom), _backdrop);
			critter.setColor(Critter.CRITTER_COLORS[i % 2]);
			extraCritters.push(critter);
			addCritter(critter);
		}

		darkness = new FlxSprite();
		darkness.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK, true);
		darkness.alpha = 0;
		_hud.add(darkness);

		buttonGroup = new WhiteGroup();

		button0 = new FlxButton(0, 0);
		button0.loadGraphic(AssetPaths.stair_choice0__png, true, 768, 118);
		button0.onDown.callback = button0Down;
		buttonGroup.add(button0);

		button1 = new FlxButton(0, 118);
		button1.loadGraphic(AssetPaths.stair_choice1__png, true, 768, 118);
		button1.onDown.callback = button1Down;
		buttonGroup.add(button1);

		button2 = new FlxButton(0, 236);
		button2.loadGraphic(AssetPaths.stair_choice2__png, true, 768, 118);
		button2.onDown.callback = button2Down;
		buttonGroup.add(button2);
		buttonGroup.visible = false;

		_hud.add(buttonGroup);

		agent = StairAgentDatabase.getAgent();

		opponentFrame = new RoundedRectangle();
		opponentFrame.relocate(3, FlxG.height - 78, 77, 75, 0xff000000, 0xeeffffff);
		_hud.add(opponentFrame);

		opponentChatFace = new FlxSprite(opponentFrame.x + 2, opponentFrame.y + 2);
		opponentChatFace.loadGraphic(agent.chatAsset, true, 73, 71);
		opponentChatFace.animation.frameIndex = 4;
		_hud.add(opponentChatFace);

		playerFrame = new RoundedRectangle();
		playerFrame.relocate(FlxG.width - 81, FlxG.height - 78, 77, 75, 0xff000000, 0xeeffffff);
		_hud.add(playerFrame);

		playerChatFace = new FlxSprite(playerFrame.x + 2, playerFrame.y + 2);
		/*
		 * one might expect "unique" to guarantee stamping doesn't gunk up the original sprite;
		 * but other references to empty_chat will have hands stamped on them unless we set a key
		 */
		playerChatFace.loadGraphic(AssetPaths.empty_chat__png, true, 73, 71, false, "3RCU5TZ48D");
		playerChatFace.stamp(_handSprite, -50, -70);
		_hud.add(playerChatFace);
		_hud.add(_cashWindow);
		_hud.add(_dialogger);

		glowyLights = new FlxSprite();
		glowyLights.loadGraphic(AssetPaths.stair_colored_spotlights__png, true, 400, 300);
		glowyLights.visible = false;
		glowyLights.animation.add("blink-lo", [0, 2, 4, 6, 8, 10], 3);
		glowyLights.animation.add("blink-hi", [1, 3, 5, 7, 9, 11], 3);

		countdownSprite = new FlxSprite(334, 136);
		countdownSprite.loadGraphic(AssetPaths.countdown__png, true, 100, 100);
		_hud.add(countdownSprite);
		countdownSprite.exists = false;
		countdownSprite.visible = false;

		stairGameLogic = new StairGameLogic(this);

		_hud.add(_helpButton);

		if (PlayerData.minigameCount[1] == 0)
		{
			// start tutorial
			var tree:Array<Array<Object>> = [];
			if (agent.chatAsset == RhydonResource.chat)
			{
				// I'm Rhydon; I can explain this
				tree = TutorialDialog.stairGamePartOneNoHandoff();
			}
			else
			{
				var tutorialTree:Array<Array<Object>>;
				// Let me get Rhydon
				agent.gameDialog.popRemoteExplanationHandoff(tree, "Rhydon", PlayerData.rhydMale ? PlayerData.Gender.Boy : PlayerData.Gender.Girl);
				tree.push(["#zzzz04#..."]);
				tutorialTree = TutorialDialog.stairGamePartOneRemoteHandoff();
				tree = DialogTree.prepend(tree, tutorialTree);
			}
			launchTutorial(tree);
		}
		else {
			setState(100);
		}
	}

	override public function addCritter(critter:Critter, pushToCritterList:Bool = true)
	{
		super.addCritter(critter, pushToCritterList);
		critter.canDie = false;
	}

	override public function getMinigameOpponentDialogClass():Class<Dynamic>
	{
		return agent.dialogClass;
	}

	private function launchTutorial(tree:Array<Array<Object>>)
	{
		stairGameLogic.tutorial = true;
		opponentChatFace.loadGraphic(RhydonResource.chat, true, 73, 71);
		opponentChatFace.animation.frameIndex = 4;
		setStateFunction(waitForTutorialPartOneToEnd);
		setState(70);
		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();
	}

	public function waitForTutorialPartOneToEnd(elapsed:Float):Void
	{
		if (!DialogTree.isDialogging(_dialogTree))
		{
			setState(75);
			setStateFunction(null);
			rollHandler = tutorialPartOneRoll;
			promptRoll1();
		}
	}

	public function tutorialPartOneRoll(args:Array<Dynamic>)
	{
		if (DialogTree.isDialogging(_dialogTree))
		{
			queuedCall = tutorialPartTwo;
			return;
		}
		tutorialPartTwo();
	}

	public function tutorialPartTwo():Void
	{
		var tree:Array<Array<Object>> = TutorialDialog.stairGamePartTwo(stairStatus0.rollAmount + stairStatus1.rollAmount);
		setState(80);
		rollHandler = tutorialPartTwoRoll;
		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();
		setStateFunction(waitForTutorialPartTwoToEnd);
	}

	public function waitForTutorialPartTwoToEnd(elapsed:Float):Void
	{
		if (!DialogTree.isDialogging(_dialogTree))
		{
			setState(85);
			setStateFunction(null);
			rollHandler = tutorialPartTwoRoll;
			promptRoll1();
		}
	}

	public function tutorialPartTwoRoll(args:Array<Dynamic>)
	{
		if (DialogTree.isDialogging(_dialogTree))
		{
			queuedCall = tutorialPartThree;
			return;
		}
		tutorialPartThree();
	}

	public function tutorialPartThree():Void
	{
		var tree:Array<Array<Object>> = TutorialDialog.stairGamePartThree(stairStatus0.rollAmount + stairStatus1.rollAmount);
		setState(90);
		setStateFunction(null);
		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();
	}

	private function resetTutorialStuff()
	{
		_eventStack.reset();
		resetStairStatus(stairStatus0);
		resetStairStatus(stairStatus1);
		hideTurnIndicator();
		stairGameLogic.reset();
		countdownSeconds = 0.77;
		opponentChatFace.loadGraphic(agent.chatAsset, true, 73, 71);
	}

	override public function dialogTreeCallback(msg:String):String
	{
		super.dialogTreeCallback(msg);
		if (msg == "%skip-tutorial%")
		{
			setState(150);
			setStateFunction(waitForGameStartState);
			resetTutorialStuff();
		}
		if (msg == "%skip-minigame%")
		{
			setState(500);
		}
		if (msg == "%restart-tutorial%")
		{
			var tree:Array<Array<Object>> = TutorialDialog.stairGamePartOneAbruptHandoff();
			launchTutorial(tree);
		}
		if (msg == "%hide-turn-indicator%")
		{
			turnIndicator.animation.play("invisible");
		}
		if (msg == "%reset-bugs%")
		{
			resetTutorialStuff();
		}
		if (StringTools.startsWith(msg, "%roll-"))
		{
			var manOrCom:String = msg.substr(6, 3);
			var roll:Int = Std.parseInt(msg.substr(10, 1));
			if (manOrCom == "man")
			{
				stairStatus0.rollDice(roll);
			}
			else if (manOrCom == "com")
			{
				stairStatus1.rollDice(roll);
			}
		}
		if (msg == "%pick-up-dice%")
		{
			stairStatus0.unrollDice();
			stairStatus1.unrollDice();
		}
		if (msg == "%wait-for-bugs%")
		{
			if (tutorialBugsMoving)
			{
				_dialogger._canDismiss = false;
			}
		}
		if (StringTools.startsWith(msg, "%move-") || StringTools.startsWith(msg, "%rmov-"))
		{
			tutorialBugsMoving = true;
			if (StringTools.startsWith(msg, "%move-"))
			{
				tutorialMove(msg);
			}
			if (StringTools.startsWith(msg, "%rmov-"))
			{
				_eventStack.addEvent({time:_eventStack._time + 1.7, callback:tutorialMoveEvent, args:[msg]});
			}
		}
		return null;
	}

	public function tutorialFinishedMove()
	{
		// player can't dismiss dialog until the bugs finish moving
		tutorialBugsMoving = false;
		_dialogger._canDismiss = true;
	}

	public function tutorialMoveEvent(args:Dynamic)
	{
		var msg:String = args[0];
		tutorialMove(msg);
	}

	public function tutorialMove(msg:String)
	{
		var manOrCom:String = msg.substr(6, 3);
		var dist:Int = Std.parseInt(msg.substr(10, 1));
		if (manOrCom == "man")
		{
			if (stairGameLogic.activePlayer != 0)
			{
				stairGameLogic.setActivePlayer(0);
			}
			hideTurnIndicator();
			stairGameLogic.roll(dist);
		}
		else if (manOrCom == "com")
		{
			if (stairGameLogic.activePlayer != 1)
			{
				stairGameLogic.setActivePlayer(1);
			}
			hideTurnIndicator();
			stairGameLogic.roll(dist);
		}
	}

	/**
	 * Calculate the AI's move.
	 *
	 * This is very similar to a bimatrix game which can be solved perfectly.
	 * But that's no fun, so each AI opponent also has slight weaknesses and
	 * preferences
	 *
	 * @return The number of movement dice the AI will throw (0, 1 or 2)
	 */
	public function getAiTossAmount():Int
	{
		if (rollHandler == eventAdjustStartPlayerFromRoll)
		{
			if (computerCheatsOnce)
			{
				computerCheatsOnce = false;
				return stairStatus0.rollAmount == 1 ? 1 : FlxG.random.getObject([0, 2]);
			}
			return FlxG.random.getObject([0, 1, 2], agent.oddsEvens);
		}
		var rewardMatrix:Array<Array<Float>> = [
				[7, 1, 2],
				[1, 2, 3],
				[2, 3, 7],
											   ];

		var stairStatus:StairStatus = stairGameLogic.activeStairStatus;
		var otherStairStatus:StairStatus = getOtherStairStatus(stairStatus.critter);

		// is the active player really close to the bottom?
		if (stairStatus.hasChest() && stairStatus.stairIndex <= 6)
		{
			var maxMove:Int = stairStatus.stairIndex;
			for (i in 0...3)
			{
				for (j in 0...3)
				{
					if (rewardMatrix[i][j] >= maxMove)
					{
						rewardMatrix[i][j] += 50;
					}
				}
			}
		}

		// can the active player hit the shortcut?
		if (!stairStatus.hasChest() && stairStatus.stairIndex >= 1 && stairStatus.stairIndex <= 4)
		{
			tweakRewardMatrix(rewardMatrix, 5 - stairStatus.stairIndex, 6);
		}

		// can the active player capture the opponent?
		if (otherStairStatus.stairIndex > 0)
		{
			var captureIncentive:Int = otherStairStatus.hasChest() ? 16 - otherStairStatus.stairIndex : otherStairStatus.stairIndex;
			captureIncentive += 3; // you also get a bonus turn...
			// where will I be if I move one square...
			for (roll in 1...5)
			{
				if (destinationSquare(stairStatus, roll) == otherStairStatus.stairIndex)
				{
					tweakRewardMatrix(rewardMatrix, roll, captureIncentive);
				}
			}
		}

		/*
		 * Add tiny variance to the reward matrix; otherwise in a trivial case (such as when a critter is one square from the goal)
		 * it will always roll 0, which is optimal but still a bit robotic
		 */
		for (i in 0...3)
		{
			for (j in 0...3)
			{
				rewardMatrix[i][j] += FlxG.random.float(0, agent.fuzzFactor);
			}
		}

		var strategy:Array<Float> = [];
		if (computerCheatsOnce)
		{
			computerCheatsOnce = false;
			var humanRoll:Int = stairStatus0.rollAmount;
			strategy = [0, 0, 0];

			var bestMove = 0;
			if (stairGameLogic.activePlayer == 0)
			{
				// it's the human's turn; minimize the score
				for (i in 1...3)
				{
					if (rewardMatrix[humanRoll][i] < rewardMatrix[humanRoll][bestMove])
					{
						bestMove = i;
					}
				}
			}
			else
			{
				// it's the computer's turn; maximize the score
				for (i in 1...3)
				{
					if (rewardMatrix[i][humanRoll] > rewardMatrix[bestMove][humanRoll])
					{
						bestMove = i;
					}
				}
			}

			strategy[bestMove] = 1.0;
		}
		else {
			rewardMatrix[0][0] *= agent.diminishedZeroZero;

			var smartStrategy:Array<Float>;
			var dumbStrategy:Array<Float>;

			if (stairGameLogic.activePlayer == 0)
			{
				// it's the human's turn; minimize the score
				smartStrategy = MatrixSolver.getStrategyP1(rewardMatrix);
				dumbStrategy = MatrixSolver.getDumbStrategyP1(rewardMatrix);
			}
			else {
				// it's the computer's turn; maximize the score
				smartStrategy = MatrixSolver.getStrategyP2(rewardMatrix);
				dumbStrategy = MatrixSolver.getDumbStrategyP2(rewardMatrix);
			}
			for (i in 0...smartStrategy.length)
			{
				strategy[i] = smartStrategy[i] * (1 - agent.dumbness) + dumbStrategy[i] * agent.dumbness;
			}

			var maxIndex0:Int = 0;
			{
				var max:Float = strategy[0];
				for (i in 1...strategy.length)
				{
					if (strategy[i] > max)
					{
						max = strategy[i];
						maxIndex0 = i;
					}
				}
			}
			strategy[maxIndex0] *= agent.bias0;

			var maxIndex1:Int = 0;
			{
				var max:Float = strategy[0];
				for (i in 1...strategy.length)
				{
					if (i != maxIndex0 && strategy[i] > max)
					{
						max = strategy[i];
						maxIndex1 = i;
					}
				}
			}
			strategy[maxIndex1] *= agent.bias1;
			MatrixSolver.normalizeStrategy(strategy);
		}

		var result:Int = FlxG.random.getObject([0, 1, 2], strategy);
		return result;
	}

	private static function destinationSquare(stairStatus:StairStatus, roll:Int)
	{
		var target:Int = stairStatus.stairIndex + (stairStatus.hasChest() ? -1 * roll : 1 * roll);
		return target > 8 ? 16 - target : target;
	}

	private static function tweakRewardMatrix(rewardMatrix:Array<Array<Float>>, roll:Int, amount:Int)
	{
		for (i in 0...3)
		{
			var j = roll - i;
			if (j >= 0 && j <= 2)
			{
				rewardMatrix[i][j] += amount;
			}
		}
		if (roll == 4)
		{
			rewardMatrix[0][0] += amount;
		}
	}

	public function handlePlayerToss(playerTossAmount:Int):Void
	{
		buttonGroup.visible = false;
		stairStatus0.rollDice(playerTossAmount);
		playerTossTiming = stateFunctionTime;

		if (aiTossTiming == -1)
		{
			var delay:Float = FlxG.random.float(0.1, 0.25);
			if (computerCheatsOnce)
			{
				// flagrantly cheat
				delay += 0.75;
			}
			_eventStack.addEvent({time:_eventStack._time + delay, callback:eventHandleAiToss});
		}
	}

	public function eventHandleAiToss(args:Array<Dynamic>)
	{
		handleAiToss();
	}

	public function showRollAgain()
	{
		turnIndicator.animation.play("roll-again");
		emitPoofParticles(turnIndicator.x - turnIndicator.offset.x + 32, turnIndicator.y - turnIndicator.offset.y + 14);
		_eventStack.addEvent({time:_eventStack._time + 3.0, callback:eventPlayTurnIndicatorAnim, args:["default"]});
		SoundStackingFix.play(AssetPaths.roll_again_00cc__mp3);
	}

	public function showTurnIndicator()
	{
		turnIndicator.animation.play("reveal");
		_eventStack.addEvent({time:_eventStack._time + 1.0, callback:eventPlayTurnIndicatorAnim, args:["default"]});
	}

	public function eventHideTurnIndicator(args:Array<Dynamic>)
	{
		hideTurnIndicator();
	}

	public function hideTurnIndicator()
	{
		if (_eventStack.isEventScheduled(eventPlayTurnIndicatorAnim))
		{
			_eventStack.removeEvent(eventPlayTurnIndicatorAnim);
		}
		if (turnIndicator.animation.name == "invisible")
		{
			// already hidden...
		}
		else
		{
			turnIndicator.animation.play("hide");
		}
	}

	public function eventPlayTurnIndicatorAnim(args:Array<Dynamic>)
	{
		var animName:String = args[0];
		turnIndicator.animation.play(animName);
	}

	public function promptRoll0():Void
	{
		if (DialogTree.isDialogging(_dialogTree))
		{
			// currently dialogging; queue this up and we'll do it later
			queuedCall = promptRoll0;
			return;
		}

		var tree:Array<Array<Object>> = [];
		if (_gameState < 150)
		{
			// still in tutorial; user clicked help button, so now they're being reprompted
			TutorialDialog.stairGameRepromptDice(tree);
		}
		else if (rollHandler == eventAdjustStartPlayerFromRoll)
		{
			agent.gameDialog.popStairOddsEvens(tree);
		}
		else if (firstTurn)
		{
			firstTurn = false;
			if (stairGameLogic.activePlayer == 0)
			{
				agent.gameDialog.popStairPlayerStarts(tree);
			}
			else
			{
				agent.gameDialog.popStairComputerStarts(tree);
			}
		}
		else if (stairGameLogic.justCaptured && stairGameLogic.activePlayer == 0)
		{
			agent.gameDialog.popStairCapturedComputer(tree, stairStatus0.rollAmount, stairStatus1.rollAmount);
		}
		else if (stairGameLogic.justCaptured && stairGameLogic.activePlayer == 1)
		{
			agent.gameDialog.popStairCapturedHuman(tree, stairStatus0.rollAmount, stairStatus1.rollAmount);
		}
		else if (stairGameLogic.justReachedMilestone)
		{
			var activeScore:Int = stairGameLogic.activeStairStatus.getScore();
			var otherScore:Int = stairGameLogic.otherStairStatus.getScore();
			/*
			 * players will average 2.7 squares per turn... if the current player is ahead by a
			 * little, or the player who just went is ahead by a lot, we comment on it
			 */
			if (activeScore > otherScore - 1.4 + 2.7 || otherScore > activeScore + 1.4 + 2.7)
			{
				if (stairStatus0.getScore() > stairStatus1.getScore())
				{
					agent.gameDialog.popLosing(tree, PlayerData.name, PlayerData.gender);
				}
				else
				{
					agent.gameDialog.popWinning(tree);
				}
			}
			else
			{
				agent.gameDialog.popCloseGame(tree);
			}
		}
		else {
			agent.gameDialog.popStairReady(tree);
		}
		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();
		setStateFunction(waitForReadyPromptState);
	}

	public function setStateFunction(stateFunction:Float->Void)
	{
		this.stateFunction = stateFunction;
		this.stateFunctionTime = 0;
	}

	public function waitForGameStartState(elapsed:Float):Void
	{
		if (!DialogTree.isDialogging(_dialogTree))
		{
			setStateFunction(null);
			rollHandler = eventAdjustStartPlayerFromRoll;
			promptRoll0();
		}
	}

	public function waitForReadyPromptState(elapsed:Float):Void
	{
		if (!DialogTree.isDialogging(_dialogTree))
		{
			promptRoll1();
		}
	}

	public function doCountdownState(elapsed:Float):Void
	{
		var oldIndex:Int = countdownSprite.animation.frameIndex;
		countdownSprite.animation.frameIndex = Std.int(FlxMath.bound(stateFunctionTime / countdownSeconds, 0, 3));
		countdownSprite.visible = true;
		if (countdownSprite.animation.frameIndex == 3 && countdownSprite.exists)
		{
			countdownSprite.exists = false;
			countdownSprite.visible = false;
		}
		else if (oldIndex != countdownSprite.animation.frameIndex)
		{
			FlxTween.tween(countdownSprite.scale, {x:1.33, y:0.75}, 0.1, {ease:FlxEase.cubeInOut});
			FlxTween.tween(countdownSprite.scale, {x:0.75, y:1.33}, 0.1, {ease:FlxEase.cubeInOut, startDelay:0.1});
			FlxTween.tween(countdownSprite.scale, {x:1, y:1}, 0.1, {ease:FlxEase.cubeInOut, startDelay:0.2});
			if (countdownSprite.animation.frameIndex < 3)
			{
				SoundStackingFix.play(AssetPaths.countdown_00c6__mp3);
			}
			if (countdownSprite.animation.frameIndex >= 1)
			{
				acceptingInput = true;
			}
		}

		if (aiTossTiming >= 0)
		{
			// ordinary timing
			if (stateFunctionTime > aiTossTiming && stateFunctionTime - elapsed <= aiTossTiming)
			{
				handleAiToss();
			}
		}
		else if (aiTossTiming == -1)
		{
			// wait for human; they cheated?
		}

		if (stairStatus0.isDiceRolled() && stairStatus1.isDiceRolled())
		{
			countdownSprite.exists = false;
			countdownSprite.visible = false;

			var playerLate:Bool = playerTossTiming >= countdownSeconds * 3 + 0.440;
			if (playerLate)
			{
				// reset the countdown timer; player was too late
				countdownSeconds = 0.90;
			}
			else
			{
				// shorten the countdown timer a little
				countdownSeconds = FlxMath.bound(countdownSeconds * 0.94, 0.44, 1.00);
			}

			if (playerLate && aiTossTiming >= 0)
			{
				_eventStack.addEvent({time:_eventStack._time + 1.7, callback:eventReroll});
			}
			else
			{
				_eventStack.addEvent({time:_eventStack._time + 1.7, callback:rollHandler});
				if (turnIndicator.animation.name == "hide" || turnIndicator.animation.name == "invisible")
				{
					// don't hide turn indicator; already hidden
				}
				else
				{
					_eventStack.addEvent({time:_eventStack._time + 0.5, callback:eventHideTurnIndicator});
				}
			}
			setStateFunction(null);
		}
	}

	public function eventReroll(args:Array<Dynamic>):Void
	{
		// computer player picks up dice...
		stairStatus1.unrollDice();

		var tree:Array<Array<Object>>;
		if (_gameState < 150)
		{
			// reroll during tutorial... don't punish it
			setStateFunction(null);
			tree = TutorialDialog.stairGameReroll(tutorialRerollCount++);
			if (_gameState == 75)
			{
				setState(72);
			}
			else if (_gameState == 85)
			{
				setState(82);
			}
		}
		else {
			computerCheatsOnce = true;
			tree = [];
			agent.gameDialog.popStairCheat(tree);
			setStateFunction(waitForReadyPromptState);
		}

		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();
	}

	public function handleAiToss():Void
	{
		stairStatus1.rollDice(getAiTossAmount());
		opponentChatFace.animation.frameIndex = FlxG.random.getObject(agent.neutralFaces);
	}

	public function promptRoll1():Void
	{
		stairStatus0.unrollDice();
		stairStatus1.unrollDice();

		opponentChatFace.animation.frameIndex = FlxG.random.getObject(agent.thinkyFaces);
		buttonGroup.visible = true;
		buttonGroup._whiteness = 1.0;
		FlxTween.tween(buttonGroup, {_whiteness:0.0}, 1.0);

		acceptingInput = false;
		countdownSprite.exists = true;
		countdownSprite.visible = false;
		countdownSprite.animation.frameIndex = 3;
		if (countdownSeconds > 0.77 && _gameState >= 150)
		{
			// oops! busted for cheating. let's have the AI just wait for the player
			aiTossTiming = -1;
		}
		else {
			aiTossTiming = countdownSeconds * 3 + FlxG.random.float( -0.500, 0.100);
		}
		setStateFunction(doCountdownState);
	}

	public function eventAdjustStartPlayerFromRoll(args:Array<Dynamic>):Void
	{
		setState(200);
		if ((stairStatus0.rollAmount + stairStatus1.rollAmount) % 2 == 1)
		{
			// player won odds/evens; set active player to 0 (player)
			stairGameLogic.setActivePlayer(0);
		}
		else {
			// player won odds/evens; set active player to 0 (player)
			stairGameLogic.setActivePlayer(1);
		}
		rollHandler = stairGameLogic.eventMoveCritterFromRoll;
		promptRoll0();
	}

	public function button0Down():Void
	{
		if (buttonGroup.visible && acceptingInput)
		{
			if (FlxG.mouse.y < _helpButton.y + _helpButton.height && FlxG.mouse.x > _helpButton.x)
			{
				// mouse is over help button
			}
			else
			{
				handlePlayerToss(0);
			}
		}
	}

	public function button1Down():Void
	{
		if (buttonGroup.visible && acceptingInput)
		{
			handlePlayerToss(1);
		}
	}

	public function button2Down():Void
	{
		if (buttonGroup.visible && acceptingInput)
		{
			handlePlayerToss(2);
		}
	}

	override public function clickHelp():Void
	{
		super.clickHelp();
		if (stateFunction == doCountdownState)
		{
			countdownSprite.visible = false;
			buttonGroup.visible = false;
		}
		interruptedStateFunction = stateFunction;
		setStateFunction(waitForHelpDismissedState);
	}

	public function waitForHelpDismissedState(elapsed:Float)
	{
		if (!DialogTree.isDialogging(_dialogTree))
		{
			if (interruptedStateFunction == doCountdownState)
			{
				if (helpButtonCheatCount > 0)
				{
					// once is an accident, but 2-3 times means they're trying to cheat
					computerCheatsOnce = true;
					countdownSeconds = 0.90;
				}
				helpButtonCheatCount++;
				promptRoll0();
			}
			interruptedStateFunction = null;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		stairGameLogic.update(elapsed);
		if (stateFunction != null)
		{
			stateFunctionTime += elapsed;
			stateFunction(elapsed);
		}

		if (DialogTree.isDialogging(_dialogTree))
		{
			playerFrame.visible = false;
			playerChatFace.visible = false;
		}
		else {
			playerFrame.visible = true;
			playerChatFace.visible = true;
		}

		if (stairGameLogic.activePlayer == 0)
		{
			turnIndicator.x = stairStatus0.critter._headSprite.x;
			turnIndicator.y = stairStatus0.critter._headSprite.y;
			turnIndicator.setBaseOffsetY(60 + stairStatus0.critter.z);
		}
		else {
			turnIndicator.x = stairStatus1.critter._headSprite.x;
			turnIndicator.y = stairStatus1.critter._headSprite.y;
			turnIndicator.setBaseOffsetY(60 + stairStatus1.critter.z);
		}

		for (critter in extraCritters)
		{
			if (!isInPuzzleArea(critter))
			{
				critter.setIdle();
				critter._eventStack.reset();
				if (SexyAnims.isLinked(critter))
				{
					SexyAnims.unlinkCritterAndMakeGroupIdle(critter);
				}
				// critter should run back to the puzzle area
				critter.runTo(FlxG.random.float(puzzleArea.left + 10, puzzleArea.right - 10), FlxG.random.float(puzzleArea.top + 10, puzzleArea.bottom - 10));
			}
		}

		if (darkness.alpha > 0)
		{
			glowyLights.update(elapsed);
			if (glowyLights.animation.name != null)
			{
				FlxSpriteUtil.fill(darkness, FlxColor.BLACK);
				darkness.stamp(glowyLights, 368, 0);
			}
		}

		updateSexyTimer(elapsed);

		if (button0.visible && button0.animation.frameIndex == 1 && FlxG.mouse.y < _helpButton.y + _helpButton.height && FlxG.mouse.x > _helpButton.x)
        {
            // user is mousing over the help button, but it also intersects button0's rectangle... un-highlight button0
            button0.status = 1; // RELEASED
            button0.animation.frameIndex = 0;
        }

		// if the critters are both on stair 1-8 together... and they're colliding...
		if (FlxSpriteKludge.overlap(stairStatus0.critter._targetSprite, stairStatus1.critter._targetSprite) &&
				stairStatus0.stairIndex == stairStatus1.stairIndex &&
				stairStatus0.stairIndex > 0)
		{
			if (shouldCapture(stairStatus0, stairStatus1))
			{
				// we're capturing; other critter stays put
			}
			else
			{
				// the other critter gets out of the way
				moveOutOfWay(getOtherStairStatus(stairGameLogic.activeStairStatus.critter).critter, null);
			}
		}

		if ((_gameState == 72 || _gameState == 82) && !DialogTree.isDialogging(_dialogTree))
		{
			if (_gameState == 72)
			{
				setState(75);
			}
			else if (_gameState == 82)
			{
				setState(85);
			}
			setStateFunction(null);
			promptRoll1();
		}

		if (_gameState == 90 && !DialogTree.isDialogging(_dialogTree))
		{
			setState(95);
		}

		if (_gameState == 95 || _gameState == 100)
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
			setStateFunction(waitForGameStartState);
			_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
			_dialogTree.go();
			setState(150);
		}

		if (_gameState == 500)
		{
			var tree:Array<Array<Object>> = agent.gameDialog.popSkipMinigame();
			_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
			_dialogTree.go();
			setStateFunction(null);
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

		if (queuedCall != null && !DialogTree.isDialogging(_dialogTree))
		{
			queuedCall();
			queuedCall = null;
		}
	}

	public function deliverChest(stairStatus:StairStatus)
	{
		stairStatus.deliveredChestCount++;

		var time:Float = _eventStack._time;
		_eventStack.addEvent({time:time, callback:eventConfetti, args:[stairStatus]});
		_eventStack.addEvent({time:time += 0.1, callback:eventCritterImmovable, args:[stairStatus, true]});
		_eventStack.addEvent({time:time += 0.1, callback:eventPlayAnim, args:[stairStatus, "look-up"]});
		_eventStack.addEvent({time:time += 1.3, callback:eventPlayAnim, args:[stairStatus, FlxG.random.getObject(["idle-happy0", "idle-happy1", "idle-happy2"])]});
		_eventStack.addEvent({time:time += 0.5, callback:eventChestToTrophy, args:[stairStatus]});
		_eventStack.addEvent({time:time += 0.1, callback:eventCritterImmovable, args:[stairStatus, false]});
		_eventStack.addEvent({time:time += 0.2, callback:eventOpenDeliveredChest, args:[stairStatus, stairStatus.getCarriedChest()]});

		if (stairStatus == stairStatus1)
		{
			opponentChatFace.animation.frameIndex = FlxG.random.getObject(agent.goodFaces);
		}
	}

	function eventCritterImmovable(args:Array<Dynamic>)
	{
		var stairStatus:StairStatus = args[0];
		var immovable:Bool = args[1];
		stairStatus.critter.setImmovable(immovable);
	}

	public function giveChest(stairStatus:StairStatus)
	{
		var time:Float = _eventStack._time;
		_eventStack.addEvent({time:time, callback:eventBlinkOn, args:[stairStatus]});
		_eventStack.addEvent({time:time += 1.0, callback:eventPlayAnim, args:[stairStatus, FlxG.random.getObject(["idle-happy0", "idle-happy1", "idle-happy2"])]});
		_eventStack.addEvent({time:time += 0.5, callback:eventChestToCritter, args:[stairStatus]});
		_eventStack.addEvent({time:time += 1.5, callback:eventBlinkOff, args:[stairStatus]});

		if (stairStatus == stairStatus1)
		{
			opponentChatFace.animation.frameIndex = FlxG.random.getObject(agent.goodFaces);
		}
	}

	public function eventChestToTrophy(args:Array<Dynamic>)
	{
		var stairStatus:StairStatus = args[0];
		var chest:Chest = stairStatus.getCarriedChest();
		chest._critter = null;

		// emit poof particles at old location...
		emitPoofParticlesFromChest(stairStatus.chest0._chestSprite);
		chest._chestSprite.animation.frameIndex -= chest._chestSprite.animation.frameIndex % 8;
		if (chest == stairStatus.chest0)
		{
			chest._chestSprite.setPosition(stairStatus.trophyPlatform.x + 8, stairStatus.trophyPlatform.y + 31);
		}
		else
		{
			chest._chestSprite.setPosition(stairStatus.trophyPlatform.x + 28, stairStatus.trophyPlatform.y + 21);
		}
		chest.z = 15;
		chest.shadow.groundZ = 15;
		// emit poof particles at new location, too...
		emitPoofParticlesFromChest(chest._chestSprite);
		SoundStackingFix.play(AssetPaths.chest_to_platform_0063_0093__mp3);
	}

	public function eventChestToCritter(args:Array<Dynamic>)
	{
		var stairStatus:StairStatus = args[0];
		var chest:Chest;
		if (stairStatus.chest0.z > 60)
		{
			chest = stairStatus.chest0;
		}
		else
		{
			chest = stairStatus.chest1;
		}
		chest._critter = stairStatus.critter;
		stairStatus.critter;

		// emit poof particles at old location...
		emitPoofParticlesFromChest(chest._chestSprite);
		chest.update(0);
		// emit poof particles at new location, too...
		emitPoofParticlesFromChest(chest._chestSprite);
		SoundStackingFix.play(AssetPaths.chest_to_critter_0076_0093__mp3);
	}

	public function eventPlayAnim(args:Array<Dynamic>)
	{
		var stairStatus:StairStatus = args[0];
		var animName:String = args[1];
		stairStatus.critter.playAnim(animName);
	}

	public function eventBlinkOff(args:Array<Dynamic>)
	{
		leds.visible = false;
		glowyLights.animation.stop();
		FlxTweenUtil.retween(darknessTween, darkness, {alpha:0}, 1.5);
	}

	public function eventBlinkOn(args:Array<Dynamic>)
	{
		var stairStatus:StairStatus = args[0];
		leds.visible = true;
		FlxTweenUtil.retween(darknessTween, darkness, {alpha:0.4}, 0.1);
		SoundStackingFix.play(AssetPaths.chest_fanfare_00c3__mp3);
		if (stairStatus.stairIndex <= 6)
		{
			// light up lower platform
			leds.animation.play("blink-lo");
			glowyLights.animation.play("blink-lo");
		}
		else
		{
			// light up upper platform
			leds.animation.play("blink-hi");
			glowyLights.animation.play("blink-hi");
		}
	}

	public function eventConfetti(args:Array<Dynamic>)
	{
		var stairStatus:StairStatus = args[0];
		confettiParticles.setPosition(stairStatus.critter._soulSprite.x + stairStatus.critter._soulSprite.width / 2, stairStatus.critter._soulSprite.y - stairStatus.critter.z - 40);
		SoundStackingFix.play(AssetPaths.confetti_0029__mp3);
		for (i in 0...10)
		{
			confettiParticles.start(true, 0, 1);
			var particle:LateFadingFlxParticle = cast(confettiParticles.emitParticle(), LateFadingFlxParticle);
			particle.setPosition(particle.x + FlxG.random.float( -10, 10), particle.y + FlxG.random.float( -10, 10));
			particle.velocity.x += -45 + 10 * i;
			particle.enableLateFade(3);
			particle.drag.set(40, 40);
			particle.angle = FlxG.random.getObject([0, 90, 180, 270]);
			FlxSpriteKludge.unfuckParticle(particle);
			confettiParticles.emitting = false;
		}
	}

	public function isInPuzzleArea(critter:Critter)
	{
		return isCoordInPuzzleArea(critter._soulSprite.x, critter._soulSprite.y) || isCoordInPuzzleArea(critter._targetSprite.x, critter._targetSprite.y);
	}

	function isCoordInPuzzleArea(x:Float, y:Float)
	{
		return FlxMath.pointInFlxRect(x, y, puzzleArea);
	}

	public function changeTargetStair(stairStatus:StairStatus, dir:Int)
	{
		stairStatus.targetStairIndex = Std.int(FlxMath.bound(stairStatus.targetStairIndex + dir, 0, 8));

		if (stairStatus.stairIndex < stairStatus.targetStairIndex && stairStatus.critter._runToCallback == null)
		{
			goUpStair(stairStatus);
		}
		else if (stairStatus.stairIndex > stairStatus.targetStairIndex && stairStatus.critter._runToCallback == null)
		{
			goDownStair(stairStatus);
		}
	}

	function goUpStair(stairStatus:StairStatus)
	{
		runToStairBottom(stairStatus.critter);
	}

	function goDownStair(stairStatus:StairStatus)
	{
		runToStairTop(stairStatus.critter);
	}

	private function getStairStatus(critter:Critter):StairStatus
	{
		return critter == stairStatus0.critter ? stairStatus0 : stairStatus1;
	}

	private function getOtherStairStatus(critter:Critter):StairStatus
	{
		return critter == stairStatus0.critter ? stairStatus1 : stairStatus0;
	}

	public function moveOutOfWay(critter:Critter, runToCallback:Critter->Void)
	{
		var stairStatus:StairStatus = getStairStatus(critter);
		critter.runTo(stairSafe[stairStatus.stairIndex].x - critter._targetSprite.width / 2, stairSafe[stairStatus.stairIndex].y - critter._targetSprite.height / 2, runToCallback);
	}

	public function hopDown(critter:Critter)
	{
		var stairStatus:StairStatus = getStairStatus(critter);
		var otherStairStatus:StairStatus = getOtherStairStatus(critter);
		stairStatus.stairIndex--;
		if (stairStatus.stairIndex == 0)
		{
			critter.permanentlyImmovable = false;
		}

		if (shouldCapture(stairStatus, otherStairStatus))
		{
			moveOutOfWay(otherStairStatus.critter, null);
			critter.jumpTo(stairSafe[stairStatus.stairIndex].x - critter._targetSprite.width / 2, stairSafe[stairStatus.stairIndex].y - critter._targetSprite.height / 2, stairStatus.stairIndex * 15, knockAway);
		}
		else
		{
			var runToCallback:Critter->Void = null;
			if (stairStatus.targetStairIndex < stairStatus.stairIndex)
			{
				runToCallback = runToStairTop;
			}
			else if (stairStatus.stairIndex == 0)
			{
				runToCallback = runOutOfWay;
			}
			critter.jumpTo(stairBot[stairStatus.stairIndex].x - critter._targetSprite.width / 2, stairBot[stairStatus.stairIndex].y - critter._targetSprite.height / 2, stairStatus.stairIndex * 15, runToCallback);
		}
	}

	public function runOutOfWay(critter:Critter)
	{
		critter.runTo(FlxG.random.float(bottomSafe.left, bottomSafe.right), FlxG.random.float(bottomSafe.top, bottomSafe.bottom));
	}

	/**
	 * Reset the stair status following the tutorial.
	 */
	public function resetStairStatus(stairStatus:StairStatus)
	{
		stairStatus.captureBonus = 0;
		stairStatus.deliveredChestCount = 0;
		stairStatus.unrollDice();

		stairStatus.critter.stop();
		stairStatus.critter._runToCallback = null;
		stairStatus.critter._eventStack.reset();

		if (stairStatus.stairIndex > 0)
		{
			stairStatus.critter.runTo(stairSafe[stairStatus.stairIndex].x - stairStatus.critter._targetSprite.width / 2, stairSafe[stairStatus.stairIndex].y - stairStatus.critter._targetSprite.height / 2, eventHopOff);
		}

		stairStatus.targetStairIndex = 0;

		if (stairStatus.chest0._critter == stairStatus.critter)
		{
			SoundStackingFix.play(AssetPaths.chest_to_platform_0063_0093__mp3);
			emitPoofParticlesFromChest(stairStatus.chest0._chestSprite);
			stairStatus.chest0.destroy();
			stairStatus.makeChest0();
			stairStatus.chest0.update(0);
			emitPoofParticlesFromChest(stairStatus.chest0._chestSprite);
		}
	}

	public function eventHopOff(critter:Critter)
	{
		var stairStatus:StairStatus = getStairStatus(critter);
		stairStatus.stairIndex = 0;
		stairStatus.targetStairIndex = 0;
		critter.jumpTo(critter._soulSprite.x + 50, critter._soulSprite.y + 50, 0);
		swapCritter(stairStatus);
	}

	public function knockAway(critter:Critter)
	{
		stairGameLogic.extraTurn = true;
		stairGameLogic.justCaptured = true;

		var stairStatus = getStairStatus(critter);
		var otherStairStatus = getOtherStairStatus(critter);
		otherStairStatus.targetStairIndex = 0;
		otherStairStatus.stairIndex = 0;
		otherStairStatus.critter.jumpTo(otherStairStatus.critter._soulSprite.x + 50, otherStairStatus.critter._soulSprite.y + 50, 0);
		otherStairStatus.critter.updateMovingPrefix("tumble");
		critter.runTo(stairBot[stairStatus.stairIndex].x - critter._targetSprite.width / 2, stairBot[stairStatus.stairIndex].y - critter._targetSprite.height / 2);
		SoundStackingFix.play(AssetPaths.swipe_0057__mp3);

		if (critter == stairStatus0.critter)
		{
			opponentChatFace.animation.frameIndex = FlxG.random.getObject(agent.badFaces);
		}
		else
		{
			opponentChatFace.animation.frameIndex = FlxG.random.getObject(agent.goodFaces);
		}

		if (otherStairStatus.hasChest())
		{
			var chest:Chest = otherStairStatus.getCarriedChest();
			stairStatus.captureBonus += chest._reward;
			chest._critter = null;
			chest._chestSprite.setPosition(stairSafe[stairStatus.stairIndex].x - critter._targetSprite.width / 2, stairSafe[stairStatus.stairIndex].y - critter._targetSprite.height / 2);

			var targetZ:Float = otherStairStatus.chest0.z - 17;
			var impact:Float = 80;
			var delay:Float = 80 / otherStairStatus.critter._bodySprite._jumpSpeed;
			var height:Float = 80 * 80 / 100;
			FlxTween.tween(chest, { z : otherStairStatus.chest0.z / 2 + targetZ / 2 + height}, delay / 2, { ease:FlxEase.quadOut });
			FlxTween.tween(chest, { z : targetZ }, delay / 2, { startDelay:delay / 2, ease:FlxEase.quadIn });

			_eventStack.addEvent({time:_eventStack._time + delay, callback:eventOpenDroppedChest, args:[otherStairStatus, chest == otherStairStatus.chest0 ? 0 : 1]});
			_eventStack.addEvent({time:_eventStack._time + delay + 0.6, callback:makeNewChest, args:[otherStairStatus, chest == otherStairStatus.chest0 ? 0 : 1]});
		}

		// swap with a different critter
		swapCritter(otherStairStatus);
	}

	private function swapCritter(stairStatus:StairStatus):Void
	{
		{
			stairStatus.critter._eventStack.addEvent({time:stairStatus.critter._eventStack._time + 3.5, callback:eventRunTowardEverybody, args:[stairStatus.critter]});
		}
		var newCritter:Critter = findIdleCritter(stairStatus.critter.getColorIndex());
		if (newCritter == null)
		{
			// couldn't find an idle critter... everyone's busy?
			for (critter in extraCritters)
			{
				if (critter.getColorIndex() == stairStatus.critter.getColorIndex() && !critter.outCold)
				{
					critter.setIdle();
					critter._eventStack.reset();
					if (SexyAnims.isLinked(critter))
					{
						SexyAnims.unlinkCritterAndMakeGroupIdle(critter);
					}
					newCritter = critter;
					break;
				}
			}
		}
		if (newCritter == null)
		{
			// couldn't find ANY critter... everyone's out cold!? just continue with the same critter
		}
		else {
			extraCritters.remove(newCritter);
			newCritter.idleMove = false;
			newCritter.runTo(FlxG.random.float(bottomSafe.left, bottomSafe.right), FlxG.random.float(bottomSafe.top, bottomSafe.bottom));

			stairStatus.critter = newCritter;
		}
	}

	public function eventRunTowardEverybody(args:Array<Dynamic>):Void
	{
		var critter:Critter = args[0];
		runTowardEverybody(critter);
	}

	public function runTowardEverybody(critter:Critter)
	{
		// final stop; then stop running
		if (critter == stairStatus0.critter || critter == stairStatus1.critter)
		{
			// go sit next to the puzzle; we couldn't find anybody to swap with
			critter.runTo(FlxG.random.float(bottomSafe.left, bottomSafe.right), FlxG.random.float(bottomSafe.top, bottomSafe.bottom));
			critter._eventStack.reset();
		}
		else
		{
			// rejoin everybody; this critter no longer participates in the game
			critter.runTo(FlxG.random.float(puzzleArea.left, puzzleArea.right), FlxG.random.float(puzzleArea.top * 0.5 + puzzleArea.bottom * 0.5, puzzleArea.bottom), rejoinCritters);
			critter._eventStack.reset();
		}

		// run to the left and upward, without cutting across the giant structure
		if (critter._soulSprite.x >= 260) critter.insertWaypoint(160, 296);
		if (critter._soulSprite.x >= 390) critter.insertWaypoint(270, 337);
		if (critter._soulSprite.x >= 500) critter.insertWaypoint(400, 357);
		if (critter._soulSprite.x >= 590) critter.insertWaypoint(510, 364);
		if (critter._soulSprite.x >= 660) critter.insertWaypoint(600, 360);
	}

	public function rejoinCritters(critter:Critter)
	{
		extraCritters.push(critter);
		critter.idleMove = true;
		critter.permanentlyImmovable = false;
		critter.setImmovable(false);
	}

	public function eventOpenDroppedChest(args:Array<Dynamic>):Void
	{
		var stairStatus:StairStatus = args[0];
		var chestIndex:Int = args[1];
		var chest:Chest = chestIndex == 0 ? stairStatus.chest0 : stairStatus.chest1;
		chest.pay(_hud);
		emitGemsInMode(chest, 1);
	}

	public function emitGemsInMode(chest:Chest, gemMode:Int)
	{
		this.gemMode = gemMode;
		emitGems(chest);
		this.gemMode = 0;
	}

	public function eventOpenDeliveredChest(args:Array<Dynamic>):Void
	{
		var stairStatus:StairStatus = args[0];
		var chest:Chest = args[1];
		chest.destroyAfterPay = false;
		chest.pay(_hud);
		emitGemsInMode(chest, 2);
	}

	public function makeNewChest(args:Array<Dynamic>):Void
	{
		var stairStatus:StairStatus = args[0];
		var chestIndex:Int = args[1];

		var chest:Chest;
		if (chestIndex == 0)
		{
			chest = stairStatus.makeChest0();
		}
		else {
			chest = stairStatus.makeChest1();
		}
		chest.update(0);
		emitPoofParticlesFromChest(chest._chestSprite);
		SoundStackingFix.play(AssetPaths.chest_to_platform_0063_0093__mp3);
	}

	public function runToStairTop(critter:Critter)
	{
		var stairStatus:StairStatus = getStairStatus(critter);
		var runToCallback:Critter->Void = null;
		if (stairStatus.targetStairIndex < stairStatus.stairIndex)
		{
			runToCallback = hopDown;
		}
		critter.runTo(stairTop[stairStatus.stairIndex].x - critter._targetSprite.width / 2, stairTop[stairStatus.stairIndex].y - critter._targetSprite.height / 2, runToCallback);
	}

	public function hopUp(critter:Critter)
	{
		var stairStatus:StairStatus = getStairStatus(critter);
		var otherStairStatus:StairStatus = getOtherStairStatus(critter);
		stairStatus.stairIndex++;

		if (shouldCapture(stairStatus, otherStairStatus))
		{
			moveOutOfWay(otherStairStatus.critter, null);
			critter.jumpTo(stairSafe[stairStatus.stairIndex].x - critter._targetSprite.width / 2, stairSafe[stairStatus.stairIndex].y - critter._targetSprite.height / 2, stairStatus.stairIndex * 15, knockAway);
		}
		else
		{
			critter.jumpTo(stairTop[stairStatus.stairIndex].x - critter._targetSprite.width / 2, stairTop[stairStatus.stairIndex].y - critter._targetSprite.height / 2, stairStatus.stairIndex * 15, runToStairBottom);
		}
	}

	public function shouldCapture(stairStatus:StairStatus, otherStairStatus:StairStatus, ?stairOffset:Int = 0):Bool
	{
		return otherStairStatus.stairIndex != 0
		&& stairStatus.stairIndex + stairOffset == otherStairStatus.stairIndex
		&& stairStatus.targetStairIndex == otherStairStatus.targetStairIndex
		&& stairGameLogic.remainingMoves == 0;
	}

	public function runToStairBottom(critter:Critter)
	{
		var stairStatus:StairStatus = getStairStatus(critter);
		var otherStairStatus:StairStatus = getOtherStairStatus(critter);

		if (stairStatus.stairIndex == 0)
		{
			critter.permanentlyImmovable = true;
		}

		if (shouldCapture(stairStatus, otherStairStatus, 1))
		{
			critter.runTo(stairSafe[stairStatus.stairIndex].x - critter._targetSprite.width / 2, stairSafe[stairStatus.stairIndex].y - critter._targetSprite.height / 2, hopUp);
		}
		else
		{
			var runToCallback:Critter->Void = null;
			if (stairStatus.targetStairIndex > stairStatus.stairIndex)
			{
				runToCallback = hopUp;
			}
			critter.runTo(stairBot[stairStatus.stairIndex].x - critter._targetSprite.width / 2, stairBot[stairStatus.stairIndex].y - critter._targetSprite.height / 2, runToCallback);
		}
	}

	function emitPoofParticlesFromChest(chestSprite:FlxSprite):Void
	{
		emitPoofParticles(chestSprite.x - chestSprite.offset.x + chestSprite.width / 2 - 10 + 24, chestSprite.y - chestSprite.offset.y + chestSprite.height / 2 - 10 + 46);
	}

	function emitPoofParticles(x:Float, y:Float)
	{
		poofParticles.setPosition(x, y);
		poofParticles.start(true, 0, 1);
		poofParticles.emitParticle();
		poofParticles.emitParticle();
		poofParticles.emitParticle();
		poofParticles.emitParticle();
		poofParticles.emitting = false;
	}

	override public function emitGem(x:Float, y:Float, z:Float):Gem
	{
		var gem:Gem = super.emitGem(x, y, z);
		if (gemMode == 1)
		{
			if (gem.velocity.y <= 8)
			{
				gem.groundZ = z;
			}
		}
		else if (gemMode == 2)
		{
			if (gem.velocity.x + gem.velocity.y * 2 <= 60)
			{
				gem.groundZ = z;
			}
		}
		return gem;
	}

	public function gameOver()
	{
		if (DialogTree.isDialogging(_dialogTree))
		{
			queuedCall = gameOver;
			return;
		}

		setState(400);

		finalScoreboard = new StairFinalScoreboard(this);
		showFinalScoreboard();

		var tree:Array<Array<Object>> = [];
		if (PlayerData.playerIsInDen)
		{
			handleDenGameOver(tree, stairStatus0.deliveredChestCount == 2);
		}
		else if (stairStatus0.deliveredChestCount == 2)
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

		setStateFunction(waitForGameOverState);

		playerChatFace.visible = false;
		playerFrame.visible = false;
		opponentChatFace.visible = false;
		opponentFrame.visible = false;
	}

	public function waitForGameOverState(elapsed:Float )
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
			setStateFunction(null);
			exitMinigameState();
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		stairStatus0 = FlxDestroyUtil.destroy(stairStatus0);
		stairStatus1 = FlxDestroyUtil.destroy(stairStatus1);
		extraCritters = FlxDestroyUtil.destroyArray(extraCritters);
		puzzleArea = FlxDestroyUtil.put(puzzleArea);
		leds = FlxDestroyUtil.destroy(leds);
		confettiParticles = FlxDestroyUtil.destroy(confettiParticles);
		glowyLights = FlxDestroyUtil.destroy(glowyLights);
		darkness = FlxDestroyUtil.destroy(darkness);
		darknessTween = FlxTweenUtil.destroy(darknessTween);
		poofParticles = FlxDestroyUtil.destroy(poofParticles);
		stairGameLogic = null;
		buttonGroup = FlxDestroyUtil.destroy(buttonGroup);
		rollHandler = null;
		turnIndicator = FlxDestroyUtil.destroy(turnIndicator);
		agent = null;
		stateFunction = null;
		interruptedStateFunction = null;
		stairBot = FlxDestroyUtil.putArray(stairBot);
		stairTop = FlxDestroyUtil.putArray(stairTop);
		stairSafe = FlxDestroyUtil.putArray(stairSafe);
		bottomSafe = FlxDestroyUtil.put(bottomSafe);
		opponentFrame = FlxDestroyUtil.destroy(opponentFrame);
		opponentChatFace = FlxDestroyUtil.destroy(opponentChatFace);
		playerFrame = FlxDestroyUtil.destroy(playerFrame);
		playerChatFace = FlxDestroyUtil.destroy(playerChatFace);
		countdownSprite = FlxDestroyUtil.destroy(countdownSprite);
		button0 = FlxDestroyUtil.destroy(button0);
		button1 = FlxDestroyUtil.destroy(button1);
		button2 = FlxDestroyUtil.destroy(button2);
		queuedCall = null;
	}
}

class StairStatus implements IFlxDestroyable
{
	// player 0 (human) is on the right; player 1 (computer) is on the left
	public static var trophyPlatformPositions:Array<FlxPoint> = [FlxPoint.get(697, 310), FlxPoint.get(0, 320)];
	public static var chest0Positions:Array<FlxPoint> = [FlxPoint.get(547, 45 + 15 * 9), FlxPoint.get(575, 16 + 15 * 9)];
	public static var chest1Positions:Array<FlxPoint> = [FlxPoint.get(522, 34 + 15 * 9), FlxPoint.get(552, 11 + 15 * 9)];
	public static var dicePositions:Array<FlxPoint> = [FlxPoint.get(668, 462), FlxPoint.get(60, 462)];

	var playerIndex:Int = 0;
	var state:StairGameState;
	public var critter:Critter;
	public var stairIndex:Int = 0;
	public var targetStairIndex:Int = 0;
	public var chest0:Chest;
	public var chest1:Chest;
	public var trophyPlatform:FlxSprite;
	public var dice0Blank:StairDice;
	public var dice1Blank:StairDice;
	public var dice0Foot:StairDice;
	public var dice1Foot:StairDice;

	public var captureBonus:Int = 0;
	public var rollAmount:Int = 0;
	public var deliveredChestCount:Int = 0;

	public function new(state:StairGameState, playerIndex:Int)
	{
		this.state = state;
		this.playerIndex = playerIndex;
		critter = new Critter(FlxG.random.float(state.bottomSafe.left, state.bottomSafe.right), FlxG.random.float(state.bottomSafe.top, state.bottomSafe.bottom), state._backdrop);
		critter.setColor(Critter.CRITTER_COLORS[playerIndex]);
		critter.idleMove = false;

		makeChest0();
		makeChest1();

		trophyPlatform = new FlxSprite(trophyPlatformPositions[playerIndex].x, trophyPlatformPositions[playerIndex].y);
		Critter.loadPaletteShiftedGraphic(trophyPlatform, Critter.CRITTER_COLORS[playerIndex], AssetPaths.stair_trophy_platform__png);
		state._backSprites.add(trophyPlatform);
		var trophyShadow:FlxSprite = new FlxSprite(trophyPlatformPositions[playerIndex].x, trophyPlatformPositions[playerIndex].y, AssetPaths.stair_trophy_platform_shadow__png);
		state._shadowGroup._extraShadows.push(trophyShadow);

		dice0Blank = makeDice(AssetPaths.stair_dice_blank0__png);
		dice1Blank = makeDice(AssetPaths.stair_dice_blank1__png);
		dice0Foot = makeDice(AssetPaths.stair_dice_foot0__png);
		dice1Foot = makeDice(AssetPaths.stair_dice_foot1__png);
	}

	public function makeChest0():Chest
	{
		chest0 = state.addChest();
		chest0.increasePlayerCash = false;
		chest0.shadow = state._shadowGroup.makeShadow(chest0._chestSprite);
		chest0.shadow.groundZ = 9 * 15;
		chest0.setReward(denNerf(250));
		chest0.z = 15 * 9;
		chest0._chestSprite.setPosition(chest0Positions[playerIndex].x, chest0Positions[playerIndex].y);
		return chest0;
	}

	public function makeChest1():Chest
	{
		chest1 = state.addChest();
		chest1.increasePlayerCash = false;
		chest1.shadow = state._shadowGroup.makeShadow(chest1._chestSprite);
		chest1.shadow.groundZ = 9 * 15;
		chest1.setReward(denNerf(500));
		chest1.z = 15 * 9;
		chest1._chestSprite.setPosition(chest1Positions[playerIndex].x, chest1Positions[playerIndex].y);
		return chest1;
	}

	public function unrollDice()
	{
		dice0Blank.visible = false;
		dice1Blank.visible = false;
		dice0Foot.visible = false;
		dice1Foot.visible = false;
	}

	public function isDiceRolled():Bool
	{
		var diceRolledCount:Int = 0;
		diceRolledCount += dice0Blank.visible ? 1 : 0;
		diceRolledCount += dice1Blank.visible ? 1 : 0;
		diceRolledCount += dice0Foot.visible ? 1 : 0;
		diceRolledCount += dice1Foot.visible ? 1 : 0;
		return diceRolledCount == 2;
	}

	public function rollDice(rollAmount:Int)
	{
		this.rollAmount = rollAmount;
		var dice0:StairDice = rollAmount == 0 ? dice0Blank : dice0Foot;
		var dice1:StairDice = rollAmount == 0 ? dice1Blank : dice1Foot;
		if (rollAmount == 1)
		{
			if (FlxG.random.bool())
			{
				dice0 = dice0Blank;
			}
			else
			{
				dice1 = dice1Blank;
			}
		}

		// ensure a maximum two dice are visible at a time; just in case
		dice0Blank.visible = false;
		dice1Blank.visible = false;
		dice0Foot.visible = false;
		dice1Foot.visible = false;

		for (dice in [dice0, dice1])
		{
			dice.visible = true;
			dice.setPosition(dicePositions[playerIndex].x, dicePositions[playerIndex].y);
			dice.velocity.x = FlxG.random.float( 250, 170);
			if (playerIndex == 0)
			{
				// roll left
				dice.velocity.x *= -1;
			}
			dice.velocity.y = FlxG.random.float( -300, -200);
			dice.exists = false;
			// set exists to false so it won't move or anything until it's "tossed"
			state._eventStack.addEvent({time:state._eventStack._time + FlxG.random.float(0, 0.2), callback:eventTossOneDice, args:[dice]});
		}
		if (state.stairGameLogic.tutorial)
		{
			dice0.velocity.y = FlxG.random.float(-260, -240);
			dice1.velocity.y = FlxG.random.float(-260, -240);
		}
		// ensure dice paths don't cross
		if (dice1.velocity.x > dice0.velocity.x)
		{
			dice1.x = dice0.x + 40;
		}
		else
		{
			dice0.x = dice1.x + 40;
		}
	}

	public function eventTossOneDice(args:Array<Dynamic>)
	{
		var dice:StairDice = args[0];
		dice.exists = true;
		dice.tossDice();
		if (state.stairGameLogic.tutorial)
		{
			dice.z = 100;
			dice.zVelocity = 150;
		}
		dice.y += dice.z;
	}

	public function hasChest()
	{
		return getCarriedChest() != null;
	}

	public function getCarriedChest()
	{
		if (chest0._critter == critter)
		{
			return chest0;
		}
		if (chest1._critter == critter)
		{
			return chest1;
		}
		return null;
	}

	public function getScore()
	{
		var score:Int = 0;
		if (deliveredChestCount == 2)
		{
			score += 32;
		}
		else if (deliveredChestCount == 1)
		{
			score += 16;
		}
		else if (deliveredChestCount == 0)
		{
			score += 0;
		}
		if (getCarriedChest() != null)
		{
			score += (16 - stairIndex);
		}
		else
		{
			score += stairIndex;
		}
		return score;
	}

	function makeDice(graphic:FlxGraphicAsset):StairDice
	{
		var dice:StairDice = new StairDice(graphic);
		dice.exists = false;
		state._midSprites.add(dice);
		state._shadowGroup.makeShadow(dice);
		return dice;
	}

	public function destroy()
	{
		critter = FlxDestroyUtil.destroy(critter);
		chest0 = FlxDestroyUtil.destroy(chest0);
		chest1 = FlxDestroyUtil.destroy(chest1);
		trophyPlatform = FlxDestroyUtil.destroy(trophyPlatform);
		dice0Blank = FlxDestroyUtil.destroy(dice0Blank);
		dice1Blank = FlxDestroyUtil.destroy(dice1Blank);
		dice0Foot = FlxDestroyUtil.destroy(dice0Foot);
		dice1Foot = FlxDestroyUtil.destroy(dice1Foot);
	}
}