package puzzle;

import Cell.ICell;
import MmStringTools.*;
import TextEntryGroup.KeyConfig;
import credits.CreditsState;
import credits.EndingAnim;
import credits.FakeCrash;
import critter.Critter;
import critter.CritterHolder;
import critter.IdleAnims;
import critter.RewardCritter;
import critter.SexyAnims;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.TransitionData;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import kludge.BetterFlxRandom;
import kludge.FlxSoundKludge;
import kludge.FlxSpriteKludge;
import kludge.LateFadingFlxParticle;
import minigame.MinigameState;
import openfl.utils.Object;
import poke.Password;
import poke.PokeWindow;
import poke.abra.AbraDialog;
import poke.abra.AbraResource;
import poke.abra.AbraSexyState;
import poke.abra.AbraWindow;
import poke.grov.GrovyleDialog;
import poke.grov.GrovyleResource;
import poke.grov.GrovyleWindow;
import poke.sexy.SexyState;
import puzzle.RankTracker;
import puzzle.RankTracker.RankChance;

/**
 * PuzzleState encompasses the logic for a puzzle levels -- initializing the
 * puzzle, putting the right number of bugs in the right places, adding your
 * pokemon partner, checking whether you've solved it, and deciding what
 * happens after you solve it.
 */
class PuzzleState extends LevelState
{
	public static var DIALOG_VARS:Map<Int, Int> = new Map<Int, Int>(); // dynamic variables which are occasionally needed during conversations
	private static var _MAX_UNDO:Int = 1000;

	public var _clueCells:Array<Cell.ICell>;
	private var _answerCells:Array<Cell.ICell>;
	public var _allCells:Array<Cell.ICell>;
	private var _holopads:Array<Holopad>;
	private var _holograms:Array<Hologram>;
	// for 7-peg puzzles, we remember the holopad state even when bugs are removed
	private var _sevenPegHolopadState:Map<Int, Array<Bool>> = new Map<Int, Array<Bool>>();
	public var _clueClouds:Map<Cell.ICell,BouncySprite>;
	public var _cloudParticles:FlxEmitter;
	public var _clueOkGroup:FlxTypedGroup<LateFadingFlxParticle>;
	public var _previousOk:LateFadingFlxParticle;

	public var _puzzleLightsManager:PuzzleLightsManager;
	public var _clueCritters:Array<Critter>;
	public var _clueBlockers:Array<FlxSprite>; // bugs can't idly hang out on top of clues. clueBlockers are invisible sprites used to gently shove them out of the way
	public var _mainRewardCritter:RewardCritter; // bug who runs out periodically to bring you a chest
	public var _rewardCritters:Array<RewardCritter> = []; // bugs who run out to bring you tons of chests, in the case of a minigame

	private var _payedAllChests:Bool = false; // did the player finish receiving money from all of the end-game chests?
	private var _needToCube:Bool = false; // do we still need to lock all of the bugs into their clue boxes?
	private var handlingGuess:Bool = false; // are we currently going through the various steps of handling a player's guess?

	private var _buttonGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	private var _undoButton:FlxButton;
	private var _redoButton:FlxButton;

	public var _puzzle:Puzzle;
	private var _clueFactory:ClueFactory;

	private var _undoOperations:Array<UndoOperation>;
	private var _undoIndex:Int = 0;

	private var _endTimer:Float = -1;

	/*
	 * During tutorials, some bugs are given labels so that we can remember,
	 * "You're the specific purple bug I moved onto this holopad, and now I'll
	 * move you into the solution box."
	 *
	 * labelledCritters keeps track of the critters which we gave labels to
	 */
	private var labelledCritters:Map<String, Critter> = new Map<String, Critter>();

	private var _textWindowGroup:TextEntryGroup;
	private var _textMaxLength:Null<Int>;

	public var _tutorial:Dynamic = null;
	public var _tutorialTime:Float = 0;

	public var _askedHintCount:Int = 0;
	public var _allowedHintCount:Int = 0; // you get one extra hint every time the random reward chest shows up
	public var _dispensedHintCount:Int = 0;
	public var _abraAvailable:Bool = true; // if Abra's mad at us because of ending stuff, we can't ask for hints. (Even from other Pokemon.)
	public var _abraWasMad:Bool = false; // if we're playing "with" Abra, but Abra's shunning us -- then we skip any minigames or events which would force Abra to be present
	public var _hintElapsedTime:Float = 0; // how long has it been since we asked for a hint?

	private var _rankWindowGroup:WhiteGroup;
	private var _rankBrainSync:BrainSyncPanel;
	private var _rankWindowSprite:FlxSprite;
	private var _rankLeftButtonCover:FlxSprite;
	private var _rankRightButtonCover:FlxSprite;
	private var _rankLabel:FlxText;
	private var _rankParticle:FlxText;
	private var _rankTextColor:FlxColor;
	private var _rankBorderColor:FlxColor;
	private var _rankChestGroup:WhiteGroup;
	private var _lockPrompt:PlayerData.Prompt = PlayerData.Prompt.AlwaysNo;

	private var _releaseTimer:Float = 0;

	private var _coinSprite:FlxSprite;

	private var _rankHistoryBackup:Array<Int>; // during final trial, if the player's not rank-eligible we just restore their rank history after a trial
	private var _rankTracker:RankTracker;
	private var _rankChance:RankTracker.RankChance;
	public var _minigameChance:Bool = false; // are we playing a minigame when the puzzle is done?

	private var _otherWindows:Array<PokeWindow> = [];
	private var helpfulDialog:Bool = false;

	private var _critterRefillTimer:Float = FlxG.random.float(3, 5); // when this counts down to zero, new bugs will run onscreen if there are any spots open
	private var _critterRefillQueued:Bool = false;

	private var _lightsOut:LightsOut;

	public var _lockedPuzzle:Puzzle; // a more difficult puzzle the player can opt into
	private var _justMadeMistake:Bool = false; // if the player just made an incorrect guess, we wait for them to change their answer before we register a new answer
	private var _siphonPuzzleReward:Int = -1; // weird sandslash-specific thing where he steals your money

	public function new(?TransIn:TransitionData, ?TransOut:TransitionData)
	{
		super(TransIn, TransOut);
	}

	override public function create():Void
	{
		super.create();
		// initialize mousePressedPosition to avoid possible NPE if mouse starts out pressed
		_mousePressedPosition = FlxG.mouse.getWorldPosition();
		SexyAnims.initialize();

		_cloudParticles = new FlxEmitter(0, 0, 12);
		add(_cloudParticles);

		_clueCritters = [];
		_clueCells = [];
		_answerCells = [];
		_allCells = [];
		_undoOperations = [];
		_holopads = [];
		_holograms = [];
		_clueClouds = new Map<Cell.ICell, BouncySprite>();
		setState(80);

		if (PlayerData.name == null)
		{
			// intro stuff
			_tutorial = TutorialDialog.tutorialNovice;
		}
		var seed:Null<Int> = null;
		if (_tutorial != null)
		{
			// don't use unlocked colors for tutorials
			Critter.initialize(Critter.LOAD_BASIC_ONLY);
		}
		if (_tutorial == TutorialDialog.tutorialNovice)
		{
			if (PlayerData.level == 0)
			{
				seed = 277926;
			}
			else if (PlayerData.level == 1)
			{
				seed = 711487;
			}
			else
			{
				seed = 611886;
			}
			_puzzle = PuzzleDatabase.fixedEasy3Peg(seed);
		}
		else if (_tutorial == TutorialDialog.tutorial3Peg)
		{
			if (PlayerData.level == 0)
			{
				seed = 594454;
			}
			else if (PlayerData.level == 1)
			{
				seed = 837376;
			}
			else
			{
				seed = 165766;
			}
			_puzzle = PuzzleDatabase.fixed3Peg(seed);
		}
		else if (_tutorial == TutorialDialog.tutorial4Peg)
		{
			if (PlayerData.level == 0)
			{
				seed = 184969;
			}
			else if (PlayerData.level == 1)
			{
				seed = 204876;
			}
			else
			{
				seed = 650424;
			}
			_puzzle = PuzzleDatabase.fixed4Peg(seed);
		}
		else if (_tutorial == TutorialDialog.tutorial5Peg)
		{
			if (PlayerData.level == 0)
			{
				seed = 358849;
				_puzzle = PuzzleDatabase.fixed5Peg(seed);
			}
			else if (PlayerData.level == 1)
			{
				seed = 374602;
				_puzzle = PuzzleDatabase.fixed5Peg(seed);
			}
			else
			{
				seed = 677671;
				_puzzle = PuzzleDatabase.fixed7Peg(seed);
			}
		}
		else {
			if (PlayerData.difficulty == Easy)
			{
				_puzzle = PuzzleDatabase.randomEasy3Peg();
			}
			else if (PlayerData.difficulty == _3Peg)
			{
				_puzzle = PlayerData.finalTrial ? PuzzleDatabase.random3PegFinal() : PuzzleDatabase.random3Peg();
			}
			else if (PlayerData.difficulty == _4Peg)
			{
				_puzzle = PlayerData.finalTrial ? PuzzleDatabase.random4PegFinal() : PuzzleDatabase.random4Peg();
			}
			else if (PlayerData.difficulty == _5Peg)
			{
				_puzzle = PlayerData.finalTrial ? PuzzleDatabase.random5PegFinal() : PuzzleDatabase.random5Peg();
			}
			else if (PlayerData.difficulty == _7Peg)
			{
				_puzzle = PuzzleDatabase.random7Peg();
			}
		}
		Critter.shuffleCritterColors(seed);

		_clueFactory = new ClueFactory(this);

		_puzzleLightsManager = new PuzzleLightsManager(this);

		/*
		 * 0123 45 678
		 * OOOOxOOxOOOx
		 */
		var challengeInt:Int = 0;
		if (_tutorial != null)
		{
			// no challenges during tutorials
		}
		else if (PlayerData.finalTrial)
		{
			// no challenges during final trial
		}
		else if (PlayerData.difficulty == PlayerData.Difficulty._4Peg)
		{
			challengeInt = (PlayerData.level + LevelIntroDialog.getChatChecksum(this, 3539)) % 5;
		}
		else if (PlayerData.difficulty == PlayerData.Difficulty._5Peg || PlayerData.difficulty == PlayerData.Difficulty._7Peg)
		{
			challengeInt = (PlayerData.level + LevelIntroDialog.getChatChecksum(this, 3539)) % 8;
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_GOLD_PUZZLE_KEY) && challengeInt >= 4 && challengeInt <= 5)
		{
			if (PlayerData.difficulty == PlayerData.Difficulty._4Peg)
			{
				// silver challenge
				_lockedPuzzle = PuzzleDatabase.random4PegSilver();
			}
			else if (PlayerData.difficulty == PlayerData.Difficulty._5Peg)
			{
				// gold challenge
				_lockedPuzzle = PuzzleDatabase.random5PegGold();
			}
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_DIAMOND_PUZZLE_KEY) && challengeInt >= 6)
		{
			if (PlayerData.difficulty == PlayerData.Difficulty._5Peg)
			{
				// diamond challenge
				_lockedPuzzle = PuzzleDatabase.random5PegDiamond();
			}
			else if (PlayerData.difficulty == PlayerData.Difficulty._7Peg)
			{
				// multi-diamond challenge
				_lockedPuzzle = PuzzleDatabase.random7PegMultiDiamond();
			}
		}

		if (_lockedPuzzle != null)
		{
			if (_lockedPuzzle._reward >= 1000)
			{
				_lockPrompt = PlayerData.promptDiamondKey;
				if (PlayerData.difficulty == PlayerData.Difficulty._7Peg && _lockPrompt == PlayerData.Prompt.AlwaysYes)
				{
					// don't auto-accept 7-peg multi-diamond puzzles
					_lockPrompt = PlayerData.Prompt.Ask;
				}
			}
			else if (_lockedPuzzle._reward >= 500)
			{
				_lockPrompt = PlayerData.promptGoldKey;
			}
			else if (_lockedPuzzle._reward >= 200)
			{
				_lockPrompt = PlayerData.promptSilverKey;
			}
			if (_lockPrompt == PlayerData.Prompt.AlwaysNo)
			{
				_lockedPuzzle = null;
			}
			if (_lockPrompt == PlayerData.Prompt.AlwaysYes)
			{
				_puzzle = _lockedPuzzle;
			}
		}

		_clueFactory.reinitialize();

		if (_puzzle._pegCount == 4 || _puzzle._pegCount == 5)
		{
			createHolopad(256 + 4, 30);
		}

		if (_puzzle._pegCount == 7)
		{
			createHolopad(256 + 4 - _clueFactory._gridWidth / 2, 90);
			createHolopad(512 - 8 - _clueFactory._gridWidth / 2, 90);
		}

		// add empty solution cells
		_puzzleLightsManager._spotlights.addSpotlight("wholeanswer");
		for (i in 0..._puzzle._pegCount)
		{
			var cellX:Float = _clueFactory._gridX + _clueFactory._gridWidth * i;
			var cellY:Float = 30 + 43;

			if (_puzzle._pegCount == 7)
			{
				cellX -= 256 - 66;
				cellY -= 30;
				if (i <= 1)
				{
					cellX += _clueFactory._gridWidth * 0.5;
				}
				else if (i >= 2 && i <= 4)
				{
					cellY += 30;
					cellX -= _clueFactory._gridWidth * 2;
				}
				else if (i >= 5)
				{
					cellY += 60;
					cellX -= _clueFactory._gridWidth * 4.5;
				}
			}

			var cell:Cell.ICell;
			if (_puzzle._easy)
			{
				if (i > 0)
				{
					continue;
				}
				cell = new BigCell(cellX + 20, cellY - 16);
			}
			else
			{
				cell = new Cell(cellX, cellY);
			}

			_midSprites.add(cell.getSprite());
			_midSprites.add(cell.getFrontSprite());
			_answerCells.push(cell);
			_allCells.push(cell);
			var rect:FlxRect = FlxRect.get(cell.getSprite().x, cell.getSprite().y - 18, cell.getSprite().width, cell.getSprite().height + 20);
			_puzzleLightsManager._spotlights.growSpotlight("wholeanswer", rect);
			_puzzleLightsManager._spotlights.addSpotlight("answer" + i);
			_puzzleLightsManager._spotlights.growSpotlight("answer" + i, rect);
		}

		// shuffle the clue cells so that critters jump out in a random order
		FlxG.random.shuffle(_clueCells);
		FlxG.random.shuffle(_allCells);

		initializeBlockers();
		_mainRewardCritter = new RewardCritter(this);
		_rewardCritters.push(_mainRewardCritter);
		addCritter(_mainRewardCritter, false);
		var sign0 = new FlxSprite(256 + (_clueFactory._gridX - 256) * 0.25 - 17, 216);
		if (_puzzle._easy)
		{
			sign0.x = 256 + (_clueFactory._gridX - 256) * 0.5 - 17;
		}
		sign0.loadGraphic(AssetPaths.signs__png, true, 34, 45);
		sign0.height = 11;
		sign0.offset.y = 45 - 11;
		sign0.width = 24;
		sign0.offset.x = 5;
		sign0.animation.frameIndex = 1;
		sign0.immovable = true;
		_shadowGroup.makeShadow(sign0);
		_midSprites.add(sign0);

		if (!_puzzle._easy)
		{
			var sign1 = new FlxSprite(256 + (_clueFactory._gridX - 256) * 0.75 - 17, 216);
			sign1.loadGraphic(AssetPaths.signs__png, true, 34, 45);
			sign1.height = 11;
			sign1.offset.y = 45 - 11;
			sign1.width = 24;
			sign1.offset.x = 5;
			sign1.immovable = true;
			_shadowGroup.makeShadow(sign1);
			_midSprites.add(sign1);
		}

		if (_puzzle._easy)
		{
			helpfulDialog = PlayerData.puzzleCount[0] + PlayerData.puzzleCount[1] + PlayerData.puzzleCount[2] + PlayerData.puzzleCount[3] < 10;
		}
		else {
			helpfulDialog = PlayerData.puzzleCount[1] + PlayerData.puzzleCount[2] + PlayerData.puzzleCount[3] < 10;
		}

		_pokeWindow = PokeWindow.fromInt(PlayerData.profIndex);
		if (_puzzle._pegCount == 7)
		{
			// don't add 7-peg pokewindow
		}
		else {
			if (!PlayerData.sfw)
			{
				_hud.add(_pokeWindow);
			}
		}
		_hud.add(_puzzleLightsManager._spotlights);
		_hud.add(_buttonGroup);

		_clueOkGroup = new FlxTypedGroup<LateFadingFlxParticle>();
		_clueOkGroup.maxSize = _puzzle._clueCount;
		for (i in 0..._clueOkGroup.maxSize)
		{
			var sprite:LateFadingFlxParticle = new LateFadingFlxParticle();
			sprite.loadGraphic(AssetPaths.clue_checkmark__png, true, 64, 64);
			sprite.exists = false;
			_clueOkGroup.add(sprite);
		}
		_hud.add(_clueOkGroup);

		_undoButton = newButton(AssetPaths.undo_button__png, FlxG.width - 103, 3, 28, 28, clickUndo);
		_redoButton = newButton(AssetPaths.redo_button__png, FlxG.width - 68, 3, 28, 28, clickRedo);
		if (!_puzzle._easy)
		{
			_buttonGroup.add(_undoButton);
			_buttonGroup.add(_redoButton);
		}
		_buttonGroup.add(_helpButton);
		if (!PlayerData.sfw)
		{
			addCameraButtons();
		}

		if (LevelIntroDialog.getChatChecksum(this, 4763) % 3 == PlayerData.level
		|| PlayerData.level == 2 && PlayerData.minigameReward >= 2500)   // guaranteed minigame if the player has 2500 in their minigame bank; it should really happen before then, but you never know
		{
			// minigame?
			if (PlayerData.level < 2 && LevelIntroDialog.isFixedChat(this))
			{
				// don't have minigame; it would interrupt the conversation they were having...
			}
			else if (PlayerData.finalTrial)
			{
				// don't have minigame during final trial
			}
			else
			{
				var minigameState:MinigameState = LevelIntroDialog.peekNextMinigame();
				if (minigameState == null)
				{
					// don't have minigame; haven't unlocked any characters who handle explanations...
				}
				else if (LevelIntroDialog.getChatChecksum(this, 6233) % minigameState.avgReward < PlayerData.minigameReward)
				{
					// 10 = 1% chance... 500 = 50% chance... 1000 = 100% chance...
					_minigameChance = true;
				}
			}
		}

		if (PlayerData.finalTrial)
		{
			var botCutoffRank:Int = BrainSyncPanel.getLowestTargetIq();
			var topCutoffRank:Int = BrainSyncPanel.getHighestTargetIq();
			var botTargetRank = Math.ceil(botCutoffRank * 5 / 8);
			var topTargetRank = Math.ceil(topCutoffRank * 5 / 8);

			var puzzleDifficulty:Int = _puzzle._difficulty;
			if (!RankTracker.computeRankChance(puzzleDifficulty).eligible)
			{
				/*
				 * Player isn't eligible for a rank up; we'll still run the
				 * regular rank chance logic, but we'll restore their
				 * original rank history after the puzzle
				 */
				_rankHistoryBackup = PlayerData.rankHistory.copy();
			}
			_rankChance = {eligible:true};
			_rankChance.rankUpTime = RankTracker.computeSlowestRankTime(topTargetRank, puzzleDifficulty);
			if (_rankChance.rankUpTime < RankTracker.FINAL_MIN_TIME)
			{
				_rankChance.rankUpTime = null;
			}
			_rankChance.rankDownTime = RankTracker.computeFastestRankTime(botTargetRank - 1, puzzleDifficulty);
			if (_rankChance.rankDownTime < RankTracker.FINAL_MIN_TIME)
			{
				_rankChance.rankDownTime = null;
			}
		}
		if (LevelIntroDialog.getChatChecksum(this, 6232) % 2 + 1 == PlayerData.level)
		{
			// rank chance?
			if (_minigameChance)
			{
				// don't have rank chance, minigame is more fun...
			}
			else if (PlayerData.finalTrial)
			{
				// don't have regular rank chance during final trial
			}
			else
			{
				var puzzleDifficulty:Int = _lockedPuzzle != null ? _lockedPuzzle._difficulty : _puzzle._difficulty;
				_rankChance = RankTracker.computeRankChance(puzzleDifficulty);
				if (RankTracker.isStaleRankChance(_rankChance))
				{
					RankTracker.increaseRankVolatility(puzzleDifficulty);
					_rankChance = RankTracker.computeRankChance(puzzleDifficulty);
				}
			}
		}

		var tree:Array<Array<Object>>;

		if (_tutorial != null)
		{
			// add a few critters that are visible during dialog
			for (i in 0..._puzzle._colorCount + 1)
			{
				var critter = findExtraCritter(i % _puzzle._colorCount);
				if (critter != null)
				{
					critter.runTo(FlxG.random.float(248, 496), 320 + FlxG.random.float( -20, 20));
				}
			}

			Critter.IDLE_ENABLED = false;

			tree = [];
			PlayerData.appendChatHistory("tutorial." + PlayerData.getDifficultyInt() + "." + PlayerData.level);
			_tutorial(tree);
			_rankChance = null;
			_minigameChance = false;
			helpfulDialog = true;
			if (PlayerData.name == null)
			{
				if (PlayerData.level == 0)
				{
					var beforeTree:Array<Array<Object>> = new Array<Array<Object>>();
					GrovyleResource.preinitializeResources();
					GrovyleDialog.boyOrGirlIntro(beforeTree);
					tree = DialogTree.prepend(beforeTree, tree);
				}
				else if (PlayerData.level == 1)
				{
					var beforeTree:Array<Array<Object>> = new Array<Array<Object>>();
					GrovyleDialog.abraIntro(beforeTree);
					tree = DialogTree.prepend(beforeTree, tree);
				}
				else if (PlayerData.level == 2)
				{
					var beforeTree:Array<Array<Object>> = new Array<Array<Object>>();
					GrovyleDialog.nameIntro(this, beforeTree);
					tree = DialogTree.prepend(beforeTree, tree);
				}
			}
			if (PlayerData.cursorType == "none")
			{
				tree = prependRestoreHandDialog(tree);
			}
		}
		else {
			tree = LevelIntroDialog.generateDialog(this);
			if (PlayerData.cursorType == "none")
			{
				tree = prependRestoreHandDialog(tree);
			}
			else if (!PlayerData.rankChance && _rankChance != null && _rankChance.eligible && _rankChance.rankUpTime != null)
			{
				if (PlayerData.finalTrial)
				{
					// grovyle shouldn't interrupt final trial
				}
				else
				{
					// first time doing a "Rank Chance?"
					PlayerData.rankChance = true;

					var beforeTree:Array<Array<Object>> = new Array<Array<Object>>();
					if (Std.isOfType(_pokeWindow, GrovyleWindow))
					{
						GrovyleDialog.firstRankChanceGrovyle(beforeTree);
					}
					else
					{
						GrovyleDialog.firstRankChanceOther(beforeTree);
					}
					tree = DialogTree.prepend(beforeTree, tree);
				}
			}
			else if (!PlayerData.rankDefend && _rankChance != null && _rankChance.eligible && _rankChance.rankUpTime == null)
			{
				if (PlayerData.finalTrial)
				{
					// grovyle shouldn't interrupt final trial
				}
				else
				{
					// first time doing a "Defend Rank"?
					PlayerData.rankDefend = true;

					// don't do a challenge puzzle alongside their first defend rank; it might not be a defend rank then!
					_lockedPuzzle = null;

					var beforeTree:Array<Array<Object>> = new Array<Array<Object>>();
					if (Std.isOfType(_pokeWindow, GrovyleWindow))
					{
						GrovyleDialog.firstRankDefendGrovyle(beforeTree);
					}
					else
					{
						GrovyleDialog.firstRankDefendOther(beforeTree);
					}
					tree = DialogTree.prepend(beforeTree, tree);
				}
			}
		}

		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();

		// pre-load any pokemon who enter, so that the game doesn't pause mid-dialog
		{
			var pokeLimit:Int = 4;
			if (PlayerData.detailLevel == PlayerData.DetailLevel.VeryLow)
			{
				pokeLimit = 0;
			}
			else if (PlayerData.detailLevel == PlayerData.DetailLevel.Low)
			{
				pokeLimit = 1;
			}
			var pokeCount:Int = 0;
			for (t in tree)
			{
				if (t != null && Std.isOfType(t[0], String) && cast(t[0], String).substring(0, 6) == "%enter")
				{
					pokeCount++;
					if (pokeCount > pokeLimit)
					{
						// don't cache pokemon; low memory
						break;
					}
					if (PlayerData.sfw)
					{
						// don't cache pokemon; not being displayed
						break;
					}
					PokeWindow.fromString(cast(t[0], String).substring(6, cast(t[0], String).length - 1));
				}
			}
		}

		_hud.add(_cashWindow);
		_hud.add(_dialogger);

		_cloudParticles.angularVelocity.set(0);
		_cloudParticles.launchMode = FlxEmitterMode.CIRCLE;
		_cloudParticles.speed.set(30, 60, 0, 0);
		_cloudParticles.acceleration.set(0);
		_cloudParticles.alpha.set(0.88, 0.88, 0, 0);
		_cloudParticles.lifespan.set(0.6);

		if (PlayerData.abraStoryInt == 4 && _pokeWindow._prefix == "abra" && !PlayerData.finalTrial)
		{
			_abraWasMad = true;
			_abraAvailable = false;
		}

		for (i in 0..._cloudParticles.maxSize)
		{
			var particle:FlxParticle = new MinRadiusParticle(7);
			particle.makeGraphic(3, 3, 0xFFFFFFFF);
			particle.exists = false;
			_cloudParticles.add(particle);
		}
	}

	function prependRestoreHandDialog(tree:Array<Array<Object>>)
	{
		var beforeTree:Array<Array<Object>> = new Array<Array<Object>>();
		if (PlayerData.abraStoryInt == 4 && !PlayerData.finalTrial)
		{
			// they've pissed abra off; abra doesn't show up to return their glove
			AbraDialog.restoreHandNone(beforeTree);
		}
		else if (Std.isOfType(_pokeWindow, AbraWindow))
		{
			AbraDialog.restoreHandAbra(beforeTree);
		}
		else
		{
			AbraDialog.restoreHandOther(beforeTree);
		}
		return DialogTree.prepend(beforeTree, tree);
	}

	function passwordEntryCallback(text:String):Void
	{
		_hud.remove(_textWindowGroup);
		_textWindowGroup = null;
		GrovyleDialog.checkPassword(_dialogTree, _dialogger, text);
		_puzzleLightsManager.setLightsUndim();
		_dialogger.unpause();
	}

	function nameEntryCallback(text:String):Void
	{
		_hud.remove(_textWindowGroup);
		_textWindowGroup = null;
		GrovyleDialog.fixName(_dialogTree, _dialogger, text);
		_puzzleLightsManager.setLightsUndim();
		_dialogger.unpause();
	}

	function ipEntryCallback(text:String):Void
	{
		_hud.remove(_textWindowGroup);
		_textWindowGroup = null;
		AbraDialog.fixIp(_dialogTree, _dialogger, text);
		_puzzleLightsManager.setLightsUndim();
		_dialogger.unpause();
	}

	function findWindow(prof:String):PokeWindow
	{
		if (_pokeWindow._prefix == prof)
		{
			return _pokeWindow;
		}
		for (window in _otherWindows)
		{
			if (window._prefix == prof)
			{
				return window;
			}
		}
		return null;
	}

	override function dialogTreeCallback(Msg:String):String
	{
		super.dialogTreeCallback(Msg);
		if (StringTools.startsWith(Msg, "%proxy"))
		{
			var window:PokeWindow = findWindow(substringBetween(Msg, "%proxy", "%"));
			if (window != null)
			{
				window.doFun(substringBetween(Msg, "%fun-", "%"));
			}
		}
		if (StringTools.startsWith(Msg, "%fun-"))
		{
			_pokeWindow.doFun(substringBetween(Msg, "%fun-", "%"));
		}
		if (Msg == "%prompt-password%")
		{
			_textWindowGroup = new TextEntryGroup(passwordEntryCallback, KeyConfig.Password);
			_textWindowGroup.setMaxLength(20);
			showTextWindowGroup();
		}
		if (Msg == "%prompt-name%")
		{
			_textWindowGroup = new TextEntryGroup(nameEntryCallback, KeyConfig.Name);
			if (_textMaxLength != null)
			{
				_textWindowGroup.setMaxLength(_textMaxLength);
			}
			showTextWindowGroup();
		}
		if (Msg == "%prompt-ip%")
		{
			_textWindowGroup = new TextEntryGroup(ipEntryCallback, KeyConfig.Ip);
			_textWindowGroup.setMaxLength(15);
			showTextWindowGroup();
		}
		if (StringTools.startsWith(Msg, "%name-max-length-"))
		{
			_textMaxLength = Std.parseInt(substringBetween(Msg, "%name-max-length-", "%"));
		}
		if (Msg == "%reset-puzzle%")
		{
			Critter.IDLE_ENABLED = false;
			// remove critters from solution cells, "main area"
			for (critter in _critters)
			{
				if (critter == null || critter.isCubed() || critter._soulSprite.y >= 245)
				{
					continue;
				}
				if (critter._targetSprite.immovable)
				{
					// being held?
					var success:Bool = removeCritterFromHolder(critter);
					if (!success)
					{
						continue;
					}
				}

				var toX:Int = FlxG.random.int(0, FlxG.width) - 10;
				var toY:Int = FlxG.random.int(FlxG.height, Std.int(1.5 * FlxG.height)) + 40;
				critter.setPosition(toX, toY);
			}
			for (cell in _clueCells)
			{
				if (Std.isOfType(cell, Cell))
				{
					setClueCloud(cast(cell), CloudState.Maybe, true);
				}
			}
			_undoOperations.splice(0, _undoOperations.length);
		}
		if (Msg == "%crashsoon%")
		{
			_eventStack.addEvent({time:_eventStack._time + 4.8, callback:eventCrash});
		}
		if (StringTools.startsWith(Msg, "%setabrastory-"))
		{
			PlayerData.abraStoryInt = Std.parseInt(substringBetween(Msg, "-", "%"));
			// if the player pisses off abra, they can't ask for hints
			_abraAvailable = true;
			if (PlayerData.abraStoryInt == 4 && _pokeWindow._prefix == "abra" && !PlayerData.finalTrial)
			{
				_abraAvailable = false;
			}
		}
		if (Msg == "%hiderankwindow%")
		{
			setState(100);
		}
		if (Msg == "%showrankwindow%")
		{
			setState(90);
		}
		if (StringTools.startsWith(Msg, "%setvar-"))
		{
			var index0:Int = Msg.indexOf("-");
			var index1:Int = Msg.indexOf("-", index0 + 1);
			var str0:String = Msg.substring(index0 + 1, index1);
			var str1:String = Msg.substring(index1 + 1, Msg.length - 1);
			DIALOG_VARS[Std.parseInt(str0)] = Std.parseInt(str1);
		}
		if (Msg == "%set-name%")
		{
			PlayerData.name = _dialogger.getReplacedText("<good-name>");
			_dialogger.setReplacedText("<name>", PlayerData.name);
		}
		if (StringTools.startsWith(Msg, "%set-name-"))
		{
			PlayerData.name = substringBetween(Msg, "%set-name-", "%");
			_dialogger.setReplacedText("<name>", PlayerData.name);
		}
		if (Msg == "%set-password%")
		{
			var password:Password = new Password(_dialogger.getReplacedText("<good-name>"), _dialogger.getReplacedText("<password>"));
			if (!password.isValid())
			{
				throw "Invalid password: (<" + _dialogger.getReplacedText("<good-name>") + ">,<" + _dialogger.getReplacedText("<password>") + ">)";
			}
			password.applyToPlayerData();
			_cashWindow._currentAmount = PlayerData.cash;
		}
		if (Msg == "%cube-clue-critters%")
		{
			_eventStack.addEvent({time:_eventStack._time, callback:eventHoldAndCubeClueCritters});
		}
		if (Msg == "%intro-lights-off%")
		{
			_lightsOut = new LightsOut();
			_puzzleLightsManager.setLightsOff();
			for (bodyPart in GrovyleResource.BODY_PARTS)
			{
				_lightsOut.lightsOutBody(bodyPart);
			}
			_lightsOut.lightsOut(AssetPaths.grovyle_chat__png, GrovyleResource.SHADOW_MAPPING);
			_lightsOut.lightsOut(AssetPaths.grovyle_chat_f__png, GrovyleResource.SHADOW_MAPPING);
		}
		if (Msg == "%intro-lights-on%")
		{
			introLightsOn();
		}
		if (StringTools.startsWith(Msg, "%label-peg-"))
		{
			var colorStr:String = substringBetween(Msg, "-peg-", "-as-");
			var labelStr:String = substringBetween(Msg, "-as-", "%");
			var colorIndex:Int = Critter.getColorIndexFromString(colorStr);
			var critter:Critter = findExtraCritter(colorIndex);
			if (critter == null)
			{
				critter = findIdleCritter(colorIndex);
			}
			if (critter != null)
			{
				labelledCritters[labelStr] = critter;
			}
		}
		if (Msg == "%unlabel-pegs%")
		{
			unlabelAllCritters();
		}
		if (StringTools.startsWith(Msg, "%move-peg-"))
		{
			var fromStr:String = substringBetween(Msg, "-from-", "-to-");
			var toStr:String = substringBetween(Msg, "-to-", "%");
			var colorIndex:Int = Critter.getColorIndexFromString(fromStr);
			var critter:Critter;
			if (labelledCritters.exists(fromStr))
			{
				critter = labelledCritters.get(fromStr);
			}
			else if (StringTools.startsWith(fromStr, "answer"))
			{
				var i:Int = Std.parseInt(fromStr.substr(6, fromStr.length - 6));
				if (_puzzle._easy)
				{
					critter = _answerCells[0].getCritters()[i];
				}
				else
				{
					critter = _answerCells[i].getCritters()[0];
				}
			}
			else
			{
				critter = findExtraCritter(colorIndex);
				if (critter == null)
				{
					critter = findIdleCritter(colorIndex);
				}
			}
			if (critter == null)
			{
				/*
				 * couldn't find idle critter; this likely ruins the tutorial
				 * but should never happen
				 */
			}
			else
			{
				removeCritterFromHolder(critter);
				SoundStackingFix.play(AssetPaths.drop__mp3);
				if (toStr == "answerempty")
				{
					if (_puzzle._easy)
					{
						if (_answerCells[0].getCritters().length < _puzzle._pegCount)
						{
							placeCritterInHolder(cast(_answerCells[0]), critter);
						}
					}
					else
					{
						for (i in 0..._answerCells.length)
						{
							if (_answerCells[i].getCritters().length == 0)
							{
								placeCritterInHolder(cast(_answerCells[i]), critter);
								break;
							}
						}
					}
				}
				else if (StringTools.startsWith(toStr, "answer"))
				{
					var i:Int = Std.parseInt(toStr.substr(6, toStr.length - 6));
					if (_puzzle._easy)
					{
						throw toStr + " is not supported for easy puzzles";
					}
					else
					{
						if (_answerCells[i].getCritters().length == 0)
						{
							placeCritterInHolder(cast(_answerCells[i]), critter);
						}
					}
				}
				else if (StringTools.startsWith(toStr, "holopad"))
				{
					var i:Int = Std.parseInt(toStr.substr(7, toStr.length - 7));
					if (_holopads[i]._critter == null)
					{
						placeCritterInHolopad(_holopads[i], critter);
					}
				}
				else if (toStr == "offscreen")
				{
					critter.setPosition(critter._soulSprite.x, 500 + FlxG.random.float( -12, 12));
				}
				else
				{
					var toX:Null<Int> = Std.parseInt(toStr.substring(0, 3));
					var toY:Null<Int> = Std.parseInt(toStr.substring(4, 7));
					if (toX != null && toY != null)
					{
						critter.setPosition(toX, toY);
					}
				}
			}
		}
		if (StringTools.startsWith(Msg, "%holopad-state-"))
		{
			var paramStr:String = substringAfter(Msg, "%holopad-state-");
			var colorStr:String = substringBefore(paramStr, "-");
			var stateStr:String = substringAfter(paramStr, "-");
			var state:Array<Bool> = [];
			for (i in 0...stateStr.length)
			{
				state.push(stateStr.charAt(i) == '1' ? true : false);
			}
			var colorIndex:Int = Critter.getColorIndexFromString(colorStr);
			setHolopadState(colorIndex, state);
		}
		if (StringTools.startsWith(Msg, "%cluecloud-"))
		{
			var paramStr:String = substringBetween(Msg, "%cluecloud-", "-");
			var clueIndex:Int = Std.parseInt(substringBetween(paramStr, "clue", "peg"));
			var pegIndex:Int = Std.parseInt(substringAfter(paramStr, "peg"));
			var cloudState:CloudState = CloudState.Maybe;
			if (StringTools.endsWith(Msg, "-yes%"))
			{
				cloudState = CloudState.Yes;
			}
			else if (StringTools.endsWith(Msg, "-no%"))
			{
				cloudState = CloudState.No;
			}
			setClueCloud(cast(getCell(clueIndex, pegIndex)), cloudState);
		}
		if (StringTools.startsWith(Msg, "%add-light-"))
		{
			var lightName:String = substringBetween(Msg, "%add-light-", "-location-");
			var lightDimensions:String = substringBetween(Msg, "-location-", "%");
			var x:Int = Std.parseInt(lightDimensions.substr(0, 3));
			var y:Int = Std.parseInt(lightDimensions.substr(4, 7));
			var w:Int = Std.parseInt(lightDimensions.substr(8, 11));
			var h:Int = Std.parseInt(lightDimensions.substr(12, 15));
			_puzzleLightsManager._spotlights.addSpotlight(lightName);
			_puzzleLightsManager._spotlights.growSpotlight(lightName, FlxRect.get(x, y, w, h));
		}
		if (StringTools.startsWith(Msg, "%remove-light-"))
		{
			var lightName:String = substringBetween(Msg, "%remove-light-", "%");
			_puzzleLightsManager._spotlights.removeSpotlight(lightName);
		}
		if (Msg == "%abra-gone%")
		{
			_abraAvailable = false;
		}
		if (Msg == "%lights-on%")
		{
			_puzzleLightsManager.setLightsOn();
		}
		if (Msg == "%lights-dim%")
		{
			_puzzleLightsManager.setLightsDim();
		}
		if (Msg == "%lights-off%")
		{
			_puzzleLightsManager.setLightsOff();
		}
		if (Msg == "%help-button-on%")
		{
			_helpButton.alpha = 0.99;
		}
		if (Msg == "%help-button-off%")
		{
			_helpButton.alpha = LevelState.BUTTON_OFF_ALPHA;
		}
		if (Msg == "%undo-buttons-on%")
		{
			_undoButton.alpha = 0.99;
			_redoButton.alpha = 0.99;
		}
		if (Msg == "%undo-buttons-off%")
		{
			_undoButton.alpha = LevelState.BUTTON_OFF_ALPHA;
			_redoButton.alpha = LevelState.BUTTON_OFF_ALPHA;
		}
		if (StringTools.startsWith(Msg, "%siphon-puzzle-reward-"))
		{
			var suffix:String = substringBetween(Msg, "reward-", "%");
			var index:Int = Std.parseInt(substringBefore(suffix, "-"));
			var amount:Int = Std.parseInt(substringAfter(suffix, "-"));

			_puzzle._reward -= amount;
			if (_lockedPuzzle != null)
			{
				_lockedPuzzle._reward -= amount;
			}
			DIALOG_VARS[index] += amount;
		}
		if (StringTools.startsWith(Msg, "%siphon-entire-puzzle-reward-"))
		{
			_siphonPuzzleReward = Std.parseInt(substringBetween(Msg, "reward-", "%"));
		}
		if (StringTools.startsWith(Msg, "%reimburse-"))
		{
			var reimburseIndex:Int = Std.parseInt(substringBetween(Msg, "reimburse-", "%"));
			if (DIALOG_VARS[reimburseIndex] > 0)
			{
				_cashWindow.show();
				PlayerData.cash += DIALOG_VARS[reimburseIndex];
				DIALOG_VARS[reimburseIndex] = 0;
			}
		}
		if (StringTools.startsWith(Msg, "%lights-on-"))
		{
			_puzzleLightsManager.setSpotlightsOn(substringBetween(Msg, "%lights-on-", "%"));
		}
		if (StringTools.startsWith(Msg, "%lights-off-"))
		{
			_puzzleLightsManager.setSpotlightsOff(substringBetween(Msg, "%lights-off-", "%"));
		}
		if (StringTools.startsWith(Msg, "%light-on-"))
		{
			_puzzleLightsManager.setSpotlightOn(substringBetween(Msg, "%light-on-", "%"));
		}
		if (StringTools.startsWith(Msg, "%light-off-"))
		{
			_puzzleLightsManager.setSpotlightOff(substringBetween(Msg, "%light-off-", "%"));
		}
		if (Msg == "%hint-asked%")
		{
			_askedHintCount++;
			_hintElapsedTime = 0;
		}
		if (Msg == "%hint-given%")
		{
			_dispensedHintCount++;
			_hintElapsedTime = 0;
			if (_rankTracker != null)
			{
				_rankTracker.penalize();
			}
		}
		if (Msg == "%cursor-normal%")
		{
			PlayerData.cursorType = "default";
			CursorUtils.initializeHandSprite(_handSprite, AssetPaths.hands__png);
			_handSprite.setSize(12, 11);
			_handSprite.offset.set(65, 83);
			CursorUtils.initializeHandSprite(_thumbSprite, AssetPaths.thumbs__png);
			_thumbSprite.setSize(12, 1);
			_thumbSprite.offset.set(65, 93);
			CursorUtils.initializeSystemCursor();
		}
		if (StringTools.startsWith(Msg, "%nextden-"))
		{
			var prefix:String = substringBetween(Msg, "%nextden-", "%");
			PlayerData.nextDenProf = PlayerData.PROF_PREFIXES.indexOf(prefix);
		}
		if (StringTools.startsWith(Msg, "%enter"))
		{
			var prefix:String = substringBetween(Msg, "%enter", "%");
			if (prefix == _pokeWindow._prefix)
			{
				_hud.insert(0, _pokeWindow);
				_pokeWindow._partAlpha = 1;
			}
			else
			{
				var windowLimit:Int = 2;
				if (PlayerData.detailLevel == PlayerData.DetailLevel.VeryLow)
				{
					windowLimit = 0;
				}
				else if (PlayerData.detailLevel == PlayerData.DetailLevel.Low)
				{
					windowLimit = 1;
				}

				if (_otherWindows.length >= windowLimit)
				{
					// too many windows... don't enter
				}
				else if (PlayerData.sfw)
				{
					// sfw; don't show pokewindows
				}
				else
				{
					var newWindow:PokeWindow;
					if (_otherWindows.length == 0)
					{
						newWindow = PokeWindow.fromString(prefix, 514, 0, 248, 325);
					}
					else
					{
						newWindow = PokeWindow.fromString(prefix, 257, 0, 248, 349);
					}
					newWindow.setNudity(0);
					_hud.insert(0, newWindow);
					_otherWindows.push(newWindow);
				}
			}
		}
		if (StringTools.startsWith(Msg, "%tomid"))
		{
			var prof:String = substringBetween(Msg, "%tomid", "%");
			var window:PokeWindow = findWindow(prof);
			if (window != null)
			{
				window.moveTo(257, 0);
				window.resize(248, 349);
			}
		}
		if (StringTools.startsWith(Msg, "%swapwindow-"))
		{
			removeCameraButtons();
			for (window in _otherWindows)
			{
				_hud.remove(window);
				FlxDestroyUtil.destroy(window);
			}
			_hud.remove(_pokeWindow);
			FlxDestroyUtil.destroy(_pokeWindow);

			_pokeWindow = PokeWindow.fromString(substringBetween(Msg, "%swapwindow-", "%"));
			if (!PlayerData.sfw)
			{
				_hud.insert(0, _pokeWindow);
				addCameraButtons();
			}
		}
		if (StringTools.startsWith(Msg, "%exit"))
		{
			var prof:String = substringBetween(Msg, "%exit", "%");
			var window:PokeWindow = findWindow(prof);
			if (window != null)
			{
				_hud.remove(window);
				if (window == _pokeWindow)
				{
					if (_puzzle._pegCount == 7)
					{
						// abra exits 7-peg puzzles for visibility reasons, but he's still watching.
					}
					else
					{
						window._partAlpha = 0;
					}
					removeCameraButtons();
					// don't destroy original pokeWindow -- too many NPEs to avoid
				}
				else
				{
					_otherWindows.remove(window);
					FlxDestroyUtil.destroy(window);
				}
			}
		}
		if (Msg.substring(0, 5) == "%skip")
		{
			PlayerData.level++;
		}
		if (Msg.substring(0, 5) == "%push")
		{
			LevelIntroDialog.pushes[PlayerData.level] = Std.parseInt(substringBetween(Msg, "%push", "%"));
		}
		if (Msg == "%quit-soon%")
		{
			if (_rankWindowGroup != null && _gameState >= 90 && _gameState < 100)
			{
				// we were displaying some kind of rank window stuff; remove it so the user doesn't accidentally click it while he's quitting
				setState(100);
				_hud.remove(_rankWindowGroup);
				_rankWindowGroup = FlxDestroyUtil.destroy(_rankWindowGroup);
			}
		}
		if (Msg.substring(0, 6) == "%label")
		{
			if (substringBetween(Msg, "%label", "%") == "gay")
			{
				PlayerData.sexualPreferenceLabel = PlayerData.SexualPreferenceLabel.Gay;
			}
			else if (substringBetween(Msg, "%label", "%") == "les")
			{
				PlayerData.sexualPreferenceLabel = PlayerData.SexualPreferenceLabel.Lesbian;
			}
			else if (substringBetween(Msg, "%label", "%") == "str")
			{
				PlayerData.sexualPreferenceLabel = PlayerData.SexualPreferenceLabel.Straight;
			}
			else if (substringBetween(Msg, "%label", "%") == "bis")
			{
				PlayerData.sexualPreferenceLabel = PlayerData.SexualPreferenceLabel.Bisexual;
			}
			else if (substringBetween(Msg, "%label", "%") == "com")
			{
				PlayerData.sexualPreferenceLabel = PlayerData.SexualPreferenceLabel.Complicated;
			}
		}
		if (StringTools.startsWith(Msg, "%gender-"))
		{
			if (substringBetween(Msg, "%gender-", "%") == "boy")
			{
				PlayerData.gender = PlayerData.Gender.Boy;
			}
			else if (substringBetween(Msg, "%gender-", "%") == "girl")
			{
				PlayerData.gender = PlayerData.Gender.Girl;
			}
			else
			{
				PlayerData.gender = PlayerData.Gender.Complicated;
			}
		}
		if (StringTools.startsWith(Msg, "%sexualpref-"))
		{
			if (substringBetween(Msg, "%sexualpref-", "%") == "boys")
			{
				PlayerData.setSexualPreference(PlayerData.SexualPreference.Boys);
			}
			else if (substringBetween(Msg, "%sexualpref-", "%") == "girls")
			{
				PlayerData.setSexualPreference(PlayerData.SexualPreference.Girls);
			}
			else if (substringBetween(Msg, "%sexualpref-", "%") == "both")
			{
				PlayerData.setSexualPreference(PlayerData.SexualPreference.Both);
			}
			else
			{
				/**
				 * Grovyle asks you whether she has a penis or a vagina down
				 * there. One of the replies is something like "You have a
				 * dishwasher down there," in which case you're labelled as an
				 * idiot.
				 *
				 * ...Bisexual people are not idiots. Transgender people are
				 * not idiots. That's not what this is.
				 */
				PlayerData.setSexualPreference(PlayerData.SexualPreference.Idiot);
			}
		}
		if (StringTools.startsWith(Msg, "%sexualsummary"))
		{
			return GrovyleDialog.sexualSummary(Msg);
		}
		if (Msg == "%pay-1000%")
		{
			/*
			 * Lucario asks the player for $1,000 randomly. The player's
			 * allowed to pay, but the money comes back to them later in random
			 * chests. Karma!
			 */
			var amount:Int = Std.int(FlxMath.bound(1000, 0, PlayerData.cash));
			if (amount > 0)
			{
				_cashWindow.show();
				FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3, 0.7);
				PlayerData.cash -= amount;
				PlayerData.reimburseCritterBonus(amount);
			}
		}
		if (Msg == "%grim-reimburse%")
		{
			PlayerData.cash += PlayerData.grimMoneyOwed;
			PlayerData.grimMoneyOwed = 0;
		}
		if (Msg == "")
		{
			// done; remove any remaining hud windows
			while (_otherWindows.length > 0)
			{
				var window:PokeWindow = _otherWindows.pop();
				_hud.remove(window);
				FlxDestroyUtil.destroy(window);
			}
			unlabelAllCritters();
			// when replaying tutorials, gamestate might be 200 with cells full
			if (_gameState == 200)
			{
				if (cellsFull() && !DialogTree.isDialogging(_dialogTree) && !_justMadeMistake)
				{
					handleGuess();
				}
			}
			else if (_gameState == 400)
			{
				// cycle minigame
				var minigameState:MinigameState = LevelIntroDialog.popNextMinigame();
				ItemDatabase._solvedPuzzle = true;
				FlxG.switchState(minigameState);
			}
			else if (_gameState == 500)
			{
				setState(505);
			}
		}
		return null;
	}

	function addCameraButtons()
	{
		for (button in _pokeWindow._cameraButtons)
		{
			var _cameraButton:FlxButton = newButton(button.image, button.x + _pokeWindow.x, button.y + _pokeWindow.y, 28, 28, button.callback);
			_buttonGroup.add(_cameraButton);
		}
	}

	function removeCameraButtons()
	{
		for (button in _buttonGroup.members)
		{
			if (button == _undoButton || button == _redoButton || button == _helpButton)
			{
				// not a camera button...
				continue;
			}
			// camera button, probably?
			_buttonGroup.remove(button);
			FlxDestroyUtil.destroy(button);
		}
	}

	private function showTextWindowGroup()
	{
		// move spotlights/pokewindow to back...
		_hud.remove(_puzzleLightsManager._spotlights);
		if (_hud.members.indexOf(_pokeWindow) != -1)
		{
			_hud.remove(_pokeWindow);
			_hud.add(_pokeWindow);
		}
		_hud.add(_puzzleLightsManager._spotlights);

		_hud.add(_textWindowGroup);
		_dialogger.pause();
		_puzzleLightsManager.setLightsDim();
	}

	function introLightsOn():Void
	{
		GrovyleResource.initialize();
		AbraResource.initialize();
		_pokeWindow.refreshGender();
		_puzzleLightsManager.setLightsOn();
		if (_lightsOut == null)
		{
			return;
		}
		for (bodyPart in GrovyleResource.BODY_PARTS)
		{
			_lightsOut.lightsOn(bodyPart);
		}
		_lightsOut.lightsOn(AssetPaths.grovyle_chat__png);
		_lightsOut.lightsOn(AssetPaths.grovyle_chat_f__png);
		for (part in _pokeWindow._parts)
		{
			// force repaint, since pixels changed
			part.dirty = true;
		}
	}

	override function quit()
	{
		_mainRewardCritter.reimburseChestReward();
		if (_rankHistoryBackup != null)
		{
			PlayerData.rankHistory = _rankHistoryBackup;
		}
		super.quit();
	}

	function createHolopad(X:Float, Y:Float)
	{
		var holopad:Holopad = new Holopad(X, Y);
		_backSprites.add(holopad._sprite);
		_holopads.push(holopad);

		for (i in 0..._puzzle._pegCount)
		{
			var sprite = new FlxSprite(X + _clueFactory._gridWidth * (i + 1), Y);
			sprite.loadGraphic(AssetPaths.holopad__png, true, 64, 64);
			sprite.animation.frameIndex = 1;
			sprite.setSize(36, 10);
			sprite.offset.set(14, 39);
			_backSprites.add(sprite);

			if (_puzzle._pegCount == 7)
			{
				if (i <= 1)
				{
					sprite.x -= _clueFactory._gridWidth * 1.5;
					sprite.y += 30;
				}
				else if (i >= 2 && i <= 4)
				{
					sprite.x -= _clueFactory._gridWidth * 4;
					sprite.y += 60;
				}
				else if (i >= 5)
				{
					sprite.x -= _clueFactory._gridWidth * 6.5;
					sprite.y += 90;
				}
			}
		}

		for (i in 0..._puzzle._pegCount)
		{
			var hologram:Hologram = new Hologram(holopad, i, X + _clueFactory._gridWidth * (i + 1), Y);
			_midSprites.add(hologram);
			_holograms.push(hologram);

			if (_puzzle._pegCount == 7)
			{
				if (i <= 1)
				{
					hologram.x -= _clueFactory._gridWidth * 1.5;
					hologram.y += 30;
				}
				else if (i >= 2 && i <= 4)
				{
					hologram.x -= _clueFactory._gridWidth * 4;
					hologram.y += 60;
				}
				else if (i >= 5)
				{
					hologram.x -= _clueFactory._gridWidth * 6.5;
					hologram.y += 90;
				}
			}
		}
	}

	public function clickUndo():Void
	{
		if (_undoIndex > 0)
		{
			if (_undoOperations[_undoIndex - 1].oldCloudState != null)
			{
				// toggling cloud
			}
			else
			{
				SoundStackingFix.play(AssetPaths.drop__mp3);
			}
		}
		undo();
	}

	public function undo():Void
	{
		if (_undoIndex <= 0)
		{
			return;
		}

		_undoIndex--;
		if (_undoOperations[_undoIndex].critter != null)
		{
			var critter:Critter = _undoOperations[_undoIndex].critter;
			if (_undoOperations[_undoIndex].oldX != null && _undoOperations[_undoIndex].oldY != null)
			{
				critter.setPosition(_undoOperations[_undoIndex].oldX, _undoOperations[_undoIndex].oldY);
				if (SexyAnims.isLinked(critter))
				{
					SexyAnims.unlinkCritterAndMakeGroupIdle(critter);
				}
				critter.setIdle();
			}
		}
		if (_undoOperations[_undoIndex].oldCloudState != null)
		{
			// only toggle cloud
			setClueCloud(cast(_undoOperations[_undoIndex].oldCritterHolder), _undoOperations[_undoIndex].oldCloudState);
		}
		else {
			if (_undoOperations[_undoIndex].newCritterHolder != null)
			{
				_undoOperations[_undoIndex].newCritterHolder.removeCritter(_undoOperations[_undoIndex].critter);
				_undoOperations[_undoIndex].critter.setImmovable(false);
			}
			if (_undoOperations[_undoIndex].oldCritterHolder != null)
			{
				_undoOperations[_undoIndex].oldCritterHolder.holdCritter(_undoOperations[_undoIndex].critter);
			}
			if (_undoOperations[_undoIndex].oldHolopadState != null)
			{
				setHolopadState(_undoOperations[_undoIndex].critter.getColorIndex(), _undoOperations[_undoIndex].oldHolopadState);
			}
		}
	}

	public function clickRedo():Void
	{
		if (_undoIndex < _undoOperations.length)
		{
			if (_undoOperations[_undoIndex].newCloudState != null)
			{
				// toggling cloud
			}
			else
			{
				SoundStackingFix.play(AssetPaths.drop__mp3);
			}
		}
		redo();
	}

	override public function clickHelp():Void
	{
		var tree:Array<Array<Object>> = LevelIntroDialog.generateHelp(this);
		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();
	}

	public function redo():Void
	{
		if (_undoIndex >= _undoOperations.length)
		{
			return;
		}

		if (_undoOperations[_undoIndex].critter != null)
		{
			var critter:Critter = _undoOperations[_undoIndex].critter;
			critter.setImmovable(false);
			if (_undoOperations[_undoIndex].newX != null && _undoOperations[_undoIndex].newY != null)
			{
				critter.setPosition(_undoOperations[_undoIndex].newX, _undoOperations[_undoIndex].newY);
				if (SexyAnims.isLinked(critter))
				{
					SexyAnims.unlinkCritterAndMakeGroupIdle(critter);
				}
				critter.setIdle();
			}
		}
		if (_undoOperations[_undoIndex].newCloudState != null)
		{
			// only toggle cloud
			setClueCloud(cast(_undoOperations[_undoIndex].newCritterHolder), _undoOperations[_undoIndex].newCloudState);
		}
		else {
			if (_undoOperations[_undoIndex].oldCritterHolder != null)
			{
				_undoOperations[_undoIndex].critter.setImmovable(false);
				_undoOperations[_undoIndex].oldCritterHolder.removeCritter(_undoOperations[_undoIndex].critter);
			}
			if (_undoOperations[_undoIndex].newCritterHolder != null)
			{
				_undoOperations[_undoIndex].newCritterHolder.holdCritter(_undoOperations[_undoIndex].critter);
			}
			if (_undoOperations[_undoIndex].newHolopadState != null)
			{
				setHolopadState(_undoOperations[_undoIndex].critter.getColorIndex(), _undoOperations[_undoIndex].newHolopadState);
			}
		}
		_undoIndex++;
	}

	override public function destroy():Void
	{
		super.destroy();

		_clueCells = FlxDestroyUtil.destroyArray(_clueCells);
		_answerCells = FlxDestroyUtil.destroyArray(_answerCells);
		_allCells = FlxDestroyUtil.destroyArray(_allCells);
		_holopads = FlxDestroyUtil.destroyArray(_holopads);
		_holograms = FlxDestroyUtil.destroyArray(_holograms);
		_sevenPegHolopadState = null;
		_clueCells = FlxDestroyUtil.destroyArray(_clueCells);
		_answerCells = FlxDestroyUtil.destroyArray(_answerCells);
		_allCells = FlxDestroyUtil.destroyArray(_allCells);
		_holopads = FlxDestroyUtil.destroyArray(_holopads);
		_holograms = FlxDestroyUtil.destroyArray(_holograms);
		_clueClouds = null;
		_cloudParticles = FlxDestroyUtil.destroy(_cloudParticles);
		_clueOkGroup = FlxDestroyUtil.destroy(_clueOkGroup);
		_previousOk = FlxDestroyUtil.destroy(_previousOk);
		_puzzleLightsManager = FlxDestroyUtil.destroy(_puzzleLightsManager);
		_clueCritters = FlxDestroyUtil.destroyArray(_clueCritters);
		_clueBlockers = FlxDestroyUtil.destroyArray(_clueBlockers);
		_mainRewardCritter = FlxDestroyUtil.destroy(_mainRewardCritter);
		_rewardCritters = FlxDestroyUtil.destroyArray(_rewardCritters);
		_buttonGroup = FlxDestroyUtil.destroy(_buttonGroup);
		_undoButton = FlxDestroyUtil.destroy(_undoButton);
		_redoButton = FlxDestroyUtil.destroy(_redoButton);
		_puzzle = FlxDestroyUtil.destroy(_puzzle);
		_clueFactory = FlxDestroyUtil.destroy(_clueFactory);
		_undoOperations = null;
		labelledCritters = null;
		_textWindowGroup = FlxDestroyUtil.destroy(_textWindowGroup);
		_textMaxLength = null;
		_tutorial = null;
		_rankWindowGroup = FlxDestroyUtil.destroy(_rankWindowGroup);
		_rankBrainSync = FlxDestroyUtil.destroy(_rankBrainSync);
		_rankWindowSprite = FlxDestroyUtil.destroy(_rankWindowSprite);
		_rankLeftButtonCover = FlxDestroyUtil.destroy(_rankLeftButtonCover);
		_rankRightButtonCover = FlxDestroyUtil.destroy(_rankRightButtonCover);
		_rankLabel = FlxDestroyUtil.destroy(_rankLabel);
		_rankParticle = FlxDestroyUtil.destroy(_rankParticle);
		_rankChestGroup = FlxDestroyUtil.destroy(_rankChestGroup);
		_coinSprite = FlxDestroyUtil.destroy(_coinSprite);
		_rankTracker = null;
		_otherWindows = FlxDestroyUtil.destroyArray(_otherWindows);
		_lightsOut = null;
		_lockedPuzzle = FlxDestroyUtil.destroy(_lockedPuzzle);
	}

	public function getCell(clueIndex:Int, ?pegIndex:Int = 0):Cell.ICell
	{
		if (_puzzle._easy)
		{
			for (clueCell in _clueCells)
			{
				var cell:BigCell = cast(clueCell);
				if (cell.getClueIndex() == clueIndex)
				{
					return cell;
				}
			}
		}
		else {
			for (clueCell in _clueCells)
			{
				var cell:Cell = cast(clueCell);
				if (cell.getClueIndex() == clueIndex && cell._pegIndex == pegIndex)
				{
					return cell;
				}
			}
		}
		return null;
	}

	public function eventUncube(params:Array<Dynamic>):Void
	{
		var cell:Cell.ICell = params[0];
		for (critter in cell.getCritters())
		{
			uncubeCritter(critter);
		}
	}

	public function eventCube(params:Array<Dynamic>):Void
	{
		var cell:Cell.ICell = params[0];
		for (critter in cell.getCritters())
		{
			cubeCritter(critter);
		}
	}

	public function eventCheer(params:Array<Dynamic>):Void
	{
		if (_hud.members.indexOf(_pokeWindow) == -1 && _puzzle._pegCount <= 5)
		{
			// pokewindow is closed...
		}
		else if (_pokeWindow._partAlpha == 0 && _pokeWindow._breakTime <= 0)
		{
			// pokemon is away...
		}
		else {
			_pokeWindow.cheerful();
		}
	}

	public function eventClueOk(params:Array<Dynamic>):Void
	{
		var sprite:LateFadingFlxParticle = _clueOkGroup.recycle(LateFadingFlxParticle);
		sprite.reset(0, 0);
		sprite.alpha = 1;
		sprite.lifespan = params[1] ? 1 : 3;
		var clueBounds:FlxRect;
		if (params[0] == -1)
		{
			clueBounds = _puzzleLightsManager._spotlights.getBounds("wholeanswer");
		}
		else {
			clueBounds = _puzzleLightsManager._spotlights.getBounds("wholeclue" + params[0]);
		}
		sprite.x = FlxG.random.float(clueBounds.left + 32, clueBounds.right - 32) - 32;
		sprite.y = clueBounds.y + clueBounds.height / 2 - 16;
		sprite.animation.frameIndex = params[1] ? 0 : 1;
		sprite.alphaRange.set(1, 0);
		sprite.enableLateFade(3);
		FlxTween.tween(sprite, {y:sprite.y - 32}, params[1] ? 1 : 3, {ease:FlxEase.circOut});
		_clueOkGroup.add(sprite);
		_previousOk = sprite;
	}

	public function eventClueSurpriseWrong(params:Array<Dynamic>):Void
	{
		if (_previousOk != null)
		{
			_previousOk.animation.frameIndex = 1;
			_previousOk.lifespan = 3;
		}
	}

	public function eventClueBadDialog(params:Array<Dynamic>):Void
	{
		var tree:Array<Array<Object>> = LevelIntroDialog.generateBadGuessDialog(this);
		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();
	}

	public function eventInvalidAnswerDialog(params:Array<Dynamic>):Void
	{
		var tree:Array<Array<Object>> = LevelIntroDialog.generateInvalidAnswerDialog(this);
		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();
	}

	/**
	 * 80 = challenge window
	 * 90 = rank window
	 * 100 = intro dialog
	 * 150 = wait for critters to cube
	 * 160 = intro
	 * 200 = playing
	 * 300 = clear
	 * 350 = rank result/minigame transition
	 * 400 = minigame transition
	 * 500 = very final end-of-game chat...
	 */
	override public function update(elapsed:Float):Void
	{
		if (_mainRewardCritter._rewardTimer > 0)
		{
			_tutorialTime += elapsed;
			_hintElapsedTime += elapsed;
		}

		if (_puzzle._easy)
		{
			for (cell in _allCells)
			{
				if (Std.isOfType(cell, BigCell))
				{
					cast(cell, BigCell).leashAll(true);
				}
			}
		}

		super.update(elapsed);

		if (_gameState == 85)
		{
			_dialogger._clickEnabled = true;
			_rankWindowSprite.loadGraphic(AssetPaths.title_screen_blip__png, true, 768, 432);
			_rankWindowSprite.setPosition(20, 60 - 50);
			_rankWindowSprite.animation.add("play", [1, 0, 0], 30, false);
			_rankWindowSprite.animation.play("play");
			_rankLeftButtonCover = FlxDestroyUtil.destroy(_rankLeftButtonCover);
			_rankRightButtonCover = FlxDestroyUtil.destroy(_rankRightButtonCover);
			_rankChestGroup = FlxDestroyUtil.destroy(_rankChestGroup);
			setState(86);
		}

		if (_gameState == 86)
		{
			if (_rankWindowSprite != null && _rankWindowSprite.animation != null && _rankWindowSprite.animation.finished)
			{
				_hud.remove(_rankWindowGroup);
				_rankWindowGroup = FlxDestroyUtil.destroy(_rankWindowGroup);
				if (!PlayerData.finalTrial && (_rankChance == null || !_rankChance.eligible))
				{
					// skip rank chance; change states now
					setState(90);
				}
				else
				{
					// rank chance prompt follows; have a short delay before changing state
					_eventStack.addEvent({time:_eventStack._time + 0.5, callback:eventSetState, args:[90]});
				}
			}
		}

		if (_gameState == 80)
		{
			if (_lockedPuzzle == null)
			{
				setState(90);
			}
			else
			{
				if (_stateTime > 0.2 && _rankWindowGroup == null)
				{
					_rankWindowGroup = new WhiteGroup();
					_rankWindowSprite = new FlxSprite();
					_rankWindowSprite.loadGraphic(AssetPaths.title_screen_blip__png, true, 768, 432);
					_rankWindowSprite.setPosition(20, 60 - 50);
					_rankWindowSprite.animation.add("play", [0, 1, 1], 30, false);
					_rankWindowSprite.animation.play("play");
					_rankWindowGroup.add(_rankWindowSprite);
					_hud.insert(0, _rankWindowGroup);
				}
				if (_stateTime > 0.2 && _stateTime - elapsed <= 0.2 && elapsed > 0)
				{
					_rankWindowSprite.loadGraphic(_lockPrompt == PlayerData.Prompt.Ask ? AssetPaths.challenge_bg__png : AssetPaths.challenge_auto_bg__png, true, 200, 160);
					_rankWindowSprite.setPosition(FlxG.width / 2 - _rankWindowSprite.width / 2, FlxG.height / 2 - _rankWindowSprite.height / 2 - 50);
					_rankWindowSprite.animation.add("glisten", AnimTools.blinkyAnimation([0, 1]), 6, false);
					_rankWindowSprite.animation.play("glisten");

					if (_lockPrompt == PlayerData.Prompt.Ask)
					{
						_rankLeftButtonCover = new FlxSprite();
						_rankLeftButtonCover.loadGraphic(AssetPaths.rank_left_button_cover__png);
						_rankLeftButtonCover.setPosition(_rankWindowSprite.x, _rankWindowSprite.y);
						_rankLeftButtonCover.alpha = 0.7;
						_rankWindowGroup.add(_rankLeftButtonCover);

						_rankRightButtonCover = new FlxSprite();
						_rankRightButtonCover.loadGraphic(AssetPaths.rank_right_button_cover__png);
						_rankRightButtonCover.setPosition(_rankWindowSprite.x, _rankWindowSprite.y);
						_rankRightButtonCover.alpha = 0.7;
						_rankWindowGroup.add(_rankRightButtonCover);
					}

					_rankWindowGroup.addTeleparticles(_rankWindowSprite.x + _rankWindowSprite.width * 0.3, _rankWindowSprite.y + _rankWindowSprite.height * 0.1, _rankWindowSprite.x + _rankWindowSprite.width * 0.7, _rankWindowSprite.y + _rankWindowSprite.height * 0.9, 10);

					FlxTween.tween(_rankWindowGroup, { _whiteness:0 }, 0.1);
				}
				if (_stateTime > 0.7 && _stateTime - elapsed <= 0.7 && elapsed > 0)
				{
					_rankChestGroup = new WhiteGroup();
					_rankWindowGroup.add(_rankChestGroup);

					var chestSprite:FlxSprite = new FlxSprite();
					if (_lockedPuzzle._reward >= 1000)
					{
						chestSprite.loadGraphic(AssetPaths.challenge_diamond_chest__png);
					}
					else if (_lockedPuzzle._reward >= 500)
					{
						chestSprite.loadGraphic(AssetPaths.challenge_gold_chest__png);
					}
					else
					{
						chestSprite.loadGraphic(AssetPaths.challenge_silver_chest__png);
					}
					chestSprite.setPosition(FlxG.width / 2 - _rankWindowSprite.width / 2, FlxG.height / 2 - _rankWindowSprite.height / 2 - 50);
					_rankChestGroup.add(chestSprite);
					if (_lockedPuzzle._reward >= 2500)
					{
						// multi-diamond
						chestSprite.x -= 5;
						var multiplierSprite:FlxSprite = new FlxSprite(chestSprite.x + 110, chestSprite.y + 85);
						multiplierSprite.loadGraphic(AssetPaths.challenge_diamond_multiplier__png, true, 32, 32);
						var chestCount:Int = Std.int(FlxMath.bound((_lockedPuzzle._reward - 500) / 1000, 1, 7));
						multiplierSprite.animation.frameIndex = Std.int(FlxMath.bound(chestCount - 2, 0, 5));
						_rankChestGroup.add(multiplierSprite);
					}

					_rankWindowGroup.addTeleparticles(chestSprite.x + chestSprite.width * 0.3, chestSprite.y + chestSprite.height * 0.5, chestSprite.x + chestSprite.width * 0.7, chestSprite.y + chestSprite.height * 0.8, 10);
					FlxTween.tween(_rankChestGroup, { _whiteness:0 }, 0.5);
				}
				if (_stateTime > 1.7 && _lockPrompt == PlayerData.Prompt.AlwaysYes)
				{
					setState(85);
				}
				if ((_rankLeftButtonCover != null || _rankRightButtonCover != null) && _rankWindowGroup.visible)
				{
					_dialogger._clickEnabled = true;
					if (_rankLeftButtonCover != null)
					{
						if (FlxG.mouse.getPosition().distanceTo(FlxPoint.weak(316, 210)) < 25)
						{
							_rankLeftButtonCover.alpha = 0;
							_dialogger._clickEnabled = false;
							if (FlxG.mouse.justPressed)
							{
								// user accepts the challenge
								_puzzle = _lockedPuzzle;
								setState(85);
								_clueFactory.reinitialize();
								initializeBlockers();
							}
						}
						else
						{
							_rankLeftButtonCover.alpha = 0.7;
						}
					}
					if (_rankRightButtonCover != null)
					{
						if (FlxG.mouse.getPosition().distanceTo(FlxPoint.weak(455, 210)) < 25)
						{
							_rankRightButtonCover.alpha = 0;
							_dialogger._clickEnabled = false;
							if (FlxG.mouse.justPressed)
							{
								// user declines the challenge; also declines any corresponding rank chance
								setState(85);
								_rankChance = null;
							}
						}
						else
						{
							_rankRightButtonCover.alpha = 0.7;
						}
					}
				}
			}
		}

		if (_gameState == 95)
		{
			_dialogger._clickEnabled = true;
			_rankWindowSprite.loadGraphic(AssetPaths.title_screen_blip__png, true, 768, 432);
			_rankWindowSprite.setPosition(20, 60 - 50);
			_rankWindowSprite.animation.add("play", [1, 0, 0], 30, false);
			_rankWindowSprite.animation.play("play");
			_rankLeftButtonCover = FlxDestroyUtil.destroy(_rankLeftButtonCover);
			_rankRightButtonCover = FlxDestroyUtil.destroy(_rankRightButtonCover);
			_rankBrainSync = FlxDestroyUtil.destroy(_rankBrainSync);
			setState(96);
		}

		if (_gameState == 96 && _rankWindowSprite.animation.finished)
		{
			_hud.remove(_rankWindowGroup);
			_rankWindowGroup = FlxDestroyUtil.destroy(_rankWindowGroup);
			setState(100);
		}

		if (_gameState == 90)
		{
			if (!PlayerData.finalTrial && (_rankChance == null || !_rankChance.eligible))
			{
				setState(100);
			}
			else
			{
				if (_stateTime > 0.2 && _rankWindowGroup == null)
				{
					_rankWindowGroup = new WhiteGroup();
					_rankWindowSprite = new FlxSprite();
					_rankWindowSprite.loadGraphic(AssetPaths.title_screen_blip__png, true, 768, 432);
					_rankWindowSprite.setPosition(20, 60 - 50);
					_rankWindowSprite.animation.add("play", [0, 1, 1], 30, false);
					_rankWindowSprite.animation.play("play");
					_rankWindowGroup.add(_rankWindowSprite);
					_hud.insert(0, _rankWindowGroup);
				}
				if (_stateTime > 0.2 && _rankLeftButtonCover == null && _rankWindowSprite != null && _rankWindowSprite.animation.finished)
				{
					if (PlayerData.finalTrial)
					{
						_rankBrainSync = BrainSyncPanel.newInstance(this);
						_rankWindowGroup.insert(0, _rankBrainSync);
					}

					var rankGraphic:Dynamic;
					if (PlayerData.finalTrial)
					{
						rankGraphic = AssetPaths.sync_chance__png;
					}
					else if (_rankChance.rankUpTime == null)
					{
						rankGraphic = AssetPaths.rank_defend__png;
					}
					else
					{
						rankGraphic = AssetPaths.rank_chance__png;
					}
					_rankWindowSprite.loadGraphic(rankGraphic, true, 200, 150);
					_rankWindowSprite.setPosition(FlxG.width / 2 - _rankWindowSprite.width / 2, FlxG.height / 2 - _rankWindowSprite.height / 2 - 50);
					_rankWindowSprite.animation.add("glisten", AnimTools.blinkyAnimation([0, 1]), 6, false);
					_rankWindowSprite.animation.play("glisten");

					_rankLeftButtonCover = new FlxSprite();
					_rankLeftButtonCover.loadGraphic(AssetPaths.rank_left_button_cover__png);
					_rankLeftButtonCover.setPosition(_rankWindowSprite.x, _rankWindowSprite.y);
					_rankLeftButtonCover.alpha = 0.7;
					_rankWindowGroup.add(_rankLeftButtonCover);
					if (PlayerData.finalTrial)
					{
						// can't refuse final trial; don't add "no" option
					}
					else
					{
						_rankRightButtonCover = new FlxSprite();
						_rankRightButtonCover.loadGraphic(AssetPaths.rank_right_button_cover__png);
						_rankRightButtonCover.setPosition(_rankWindowSprite.x, _rankWindowSprite.y);
						_rankRightButtonCover.alpha = 0.7;
						_rankWindowGroup.add(_rankRightButtonCover);
					}
					if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_CALCULATOR))
					{
						_rankWindowGroup.add(new FlxSprite(_rankWindowSprite.x, _rankWindowSprite.y, AssetPaths.rank_details__png));
						{
							var rankUpRank:Int = RankTracker.computeRankUpRank();
							var upString:String = "--:--";
							if (_rankChance.rankUpTime != null)
							{
								var upTime:Int = _rankChance.rankUpTime;
								upString = "";
								upString = upTime % 60 + upString;
								if (upString.length < 2)
								{
									upString = "0" + upString;
								}
								upTime = Std.int(upTime / 60);
								upString = Math.min(99, upTime) + ":" + upString;
							}
							var text:FlxText = new FlxText(FlxG.width / 2 - 50, FlxG.height / 2 - 50 + 18 + 20, 100, upString, 20);
							text.alignment = CENTER;
							text.font = AssetPaths.hardpixel__otf;
							text.color = OptionsMenuState.WHITE_BLUE;
							text.setBorderStyle(OUTLINE, OptionsMenuState.DARK_BLUE, 2);
							_rankWindowGroup.add(text);
						}
						{
							var rankDownRank:Int = RankTracker.computeRankDownRank();
							var downString:String = "--:--";
							if (_rankChance.rankDownTime != null)
							{
								downString = "";
								var downTime:Int = _rankChance.rankDownTime;
								downString = downTime % 60 + downString;
								if (downString.length < 2)
								{
									downString = "0" + downString;
								}
								downTime = Std.int(downTime / 60);
								downString = Math.min(99, downTime) + ":" + downString;
							}
							var text:FlxText = new FlxText(FlxG.width / 2 - 50, FlxG.height / 2 - 50 + 18 + 20 + 20, 100, downString, 20);
							text.alignment = CENTER;
							text.font = AssetPaths.hardpixel__otf;
							text.color = OptionsMenuState.WHITE_BLUE;
							text.setBorderStyle(OUTLINE, OptionsMenuState.DARK_BLUE, 2);
							_rankWindowGroup.add(text);
						}
						_rankWindowGroup.add(new FlxSprite(_rankWindowSprite.x + 56, _rankWindowSprite.y + 116, AssetPaths.rank_check_x__png));
					}

					var text:FlxText = new FlxText(FlxG.width / 2 - 50, FlxG.height / 2 - 50 + 18, 100, "RANK " + RankTracker.computeAggregateRank(), 20);
					text.alignment = CENTER;
					text.font = AssetPaths.hardpixel__otf;
					text.color = OptionsMenuState.WHITE_BLUE;
					text.setBorderStyle(OUTLINE, OptionsMenuState.DARK_BLUE, 2);
					_rankWindowGroup.add(text);

					_rankWindowGroup.addTeleparticles(_rankWindowSprite.x + _rankWindowSprite.width * 0.3, _rankWindowSprite.y + _rankWindowSprite.height * 0.1, _rankWindowSprite.x + _rankWindowSprite.width * 0.7, _rankWindowSprite.y + _rankWindowSprite.height * 0.9, 10);

					FlxTween.tween(_rankWindowGroup, { _whiteness:0 }, 0.1);
				}
				if ((_rankRightButtonCover != null || _rankLeftButtonCover != null) && _rankWindowGroup.visible)
				{
					// on mobile, the button hitboxes were offset from the graphics, now their 
					// positions are based on the rank sprite location instead of hardcoded values
					var _rankBtnYPos = _rankWindowSprite.y + 115;
					var _rankYesXPos = _rankWindowSprite.x + 31;
					var _rankNoXPos = _rankWindowSprite.x + 171;
					_dialogger._clickEnabled = true;
					if (_rankLeftButtonCover != null)
					{
						if (FlxG.mouse.getPosition().distanceTo(FlxPoint.weak(_rankYesXPos, _rankBtnYPos)) < 25)
						{
							_rankLeftButtonCover.alpha = 0;
							_dialogger._clickEnabled = false;
							if (FlxG.mouse.justPressed)
							{
								// user agrees to be ranked
								_rankTracker = new RankTracker(this);
								setState(95);
							}
						}
						else
						{
							_rankLeftButtonCover.alpha = 0.7;
						}
					}
					if (_rankRightButtonCover != null)
					{
						if (FlxG.mouse.getPosition().distanceTo(FlxPoint.weak(_rankNoXPos, _rankBtnYPos)) < 25)
						{
							_rankRightButtonCover.alpha = 0;
							_dialogger._clickEnabled = false;
							if (FlxG.mouse.justPressed)
							{
								// user doesn't agree to be ranked
								setState(95);
							}
						}
						else
						{
							_rankRightButtonCover.alpha = 0.7;
						}
					}
				}
			}
		}

		if (_gameState <= 100)
		{
			if (_rankWindowGroup != null)
			{
				if (_dialogger.isPrompting())
				{
					_rankWindowGroup.visible = false;
					_dialogger._clickEnabled = true;
				}
				else
				{
					_rankWindowGroup.visible = true;
				}
			}
		}

		if (_gameState == 100 && !DialogTree.isDialogging(_dialogTree))
		{
			if (_textWindowGroup != null && _textWindowGroup.visible)
			{
				// don't transition state if we're prompting user for a name/ip
			}
			else
			{
				setState(150);
				_eventStack.addEvent({time:_eventStack._time, callback:eventHoldAndCubeClueCritters});
			}
		}

		if (_gameState == 150)
		{
			// wait for all critters to be cubed; then start timer and puzzle
			var anyUncubed = anyClueCrittersUncubed();
			if (!anyUncubed)
			{
				setState(160);
				if (_rankTracker != null)
				{
					_rankTracker.start();
				}
				_hintElapsedTime = 0;

				_eventStack.addEvent({time:_eventStack._time + 0.2, callback:eventAddRankWindowBlip});
				_eventStack.addEvent({time:_eventStack._time + 0.3, callback:eventAddRankWindowGraphics});
				_eventStack.addEvent({time:_eventStack._time + 1.5, callback:eventRemoveRankWindowGraphics});
				_eventStack.addEvent({time:_eventStack._time + 1.6, callback:eventRemoveRankWindowBlip});
				Critter.IDLE_ENABLED = true;
			}
		}

		if (DialogTree.isDialogging(_dialogTree) || _gameState >= 300 || _gameState < 200 || _eventStack._alive)
		{
			for (member in _buttonGroup.members)
			{
				if (member != null && member.alpha == 1.0)
				{
					member.alpha = LevelState.BUTTON_OFF_ALPHA;
				}
			}
		}
		else {
			for (member in _buttonGroup.members)
			{
				if (member != null && member.alpha == LevelState.BUTTON_OFF_ALPHA)
				{
					member.alpha = 1.0;
				}
			}
		}

		if (Critter.IDLE_ENABLED)
		{
			_globalIdleTimer -= elapsed;
			if (_globalIdleTimer <= 0)
			{
				var annoyingAnimationConstant:Float = [0, 0, 0.25, 0.5, 1.0, 1.95, 3.10, 4.5][PlayerData.pegActivity];

				var map:Map<String,Float> = new Map<String,Float>();
				map["global-enter"] = 1 * annoyingAnimationConstant;
				map["global-leave"] = 1 * annoyingAnimationConstant;
				map["global-leave-many"] = 0.2 * annoyingAnimationConstant;
				map["global-enter-many"] = 0.2 * annoyingAnimationConstant;
				map["global-noop"] = 1; // avoid edge case where everything has a 0% chance
				IdleAnims.playGlobalAnim(this, BetterFlxRandom.getObjectWithMap(map));
			}

			updateSexyTimer(elapsed);
		}

		if (PlayerData.cheatsEnabled)
		{
			// hit '$' to spawn the reward critter, which also lets you ask for another hint
			if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.FOUR)
			{
				if (_mainRewardCritter._rewardTimer > 0)
				{
					FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3);
					_mainRewardCritter.immediatelySpawnIdleReward();
				}
			}
			// hit '%' to skip to the main menu, populating name and stuff
			if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.FIVE && PlayerData.name == null)
			{
				PlayerData.name = "Mr. Handerson"; // ...my name is neo!!!
				PlayerData.gender = PlayerData.Gender.Boy;
				PlayerData.setSexualPreference(PlayerData.SexualPreference.Boys);
				introLightsOn();
				FlxG.switchState(new MainMenuState());
			}
		}
		#if debug
		// hit 'I' to make someone do an idle animation; shift 'I' for a global idle animation; control 'I' for some debug information
		if (FlxG.keys.justPressed.I)
		{
			if (FlxG.keys.pressed.SHIFT)
			{
				//SexyAnims.playGlobalAnim(this, "global-sexy-doggy-gangbang");
				_globalSexyTimer = 0;
				//_globalIdleTimer = 0;
			}
			else
			{
				var closestCritter:Critter = null;
				for (critter in _critters)
				{
					if (closestCritter == null || closestCritter._bodySprite.getPosition().distanceTo(FlxG.mouse.getPosition()) > critter._bodySprite.getPosition().distanceTo(FlxG.mouse.getPosition()))
					{
						closestCritter = critter;
					}
				}
				if (FlxG.keys.pressed.CONTROL)
				{
					if (closestCritter != null)
					{
						trace("critter " + closestCritter.myId + ": " + closestCritter._lastSexyAnim);
					}
				}
				else
				{
					if (closestCritter != null)
					{
						closestCritter.playAnim("idle-outcold0", true);
						//closestCritter._bodySprite._idleTimer = 0;
					}
				}
			}
		}
		else if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.R)
		{
			var playState:PuzzleState = new PuzzleState();
			playState._tutorial = _tutorial;
			FlxG.switchState(playState);
			return;
		}
		#end

		if (_gameState == 200)
		{
			if (_critterRefillTimer >= 0)
			{
				_critterRefillTimer -= elapsed;
				if (_critterRefillTimer < 0)
				{
					refillCritters();
				}
			}
			else
			{
				// on cooldown
				_critterRefillTimer -= elapsed;
				if (_critterRefillTimer < -1.5)
				{
					if (_critterRefillQueued)
					{
						_critterRefillTimer = 0;
						_critterRefillQueued = false;
					}
					else
					{
						_critterRefillTimer = FlxG.random.float(3, 5);
					}
				}
			}
		}

		if (_dialogTree == null || !DialogTree.isDialogging(_dialogTree))
		{
			for (critter in _rewardCritters)
			{
				critter.update(elapsed);
			}
		}

		if (_rankTracker != null)
		{
			_rankTracker.update(elapsed);
		}

		if (_gameState == 300)
		{
			_releaseTimer -= elapsed;
			if (_releaseTimer <= 0)
			{
				_releaseTimer += 0.05;
				var foundCell:Cell.ICell = null;
				for (cell in _allCells)
				{
					if (cell.getCritters().length > 0)
					{
						foundCell = cell;
						break;
					}
				}
				if (foundCell == null)
				{
					setState(305);
				}
				else
				{
					var critter:Critter = FlxG.random.getObject(foundCell.getCritters());
					jumpOutOfCell(critter, runFromCell);
				}
			}
		}

		if (_gameState == 305 && allChestsFinishedPaying())
		{
			setState(310);
		}

		if (_gameState == 310)
		{
			if (_stateTime > 0.8 || _minigameChance)
			{
				setState(350);
			}
		}

		if (_gameState == 350 && _minigameChance)
		{
			var tree:Array<Array<Object>> = LevelIntroDialog.generateBonusCoinDialog(this);
			_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
			_dialogTree.go();
			setState(400);
		}

		if (_gameState == 350 && _rankTracker == null)
		{
			switchState();
		}

		if (_gameState == 350 && _rankTracker != null)
		{
			if (_rankWindowGroup == null)
			{
				_rankWindowGroup = new WhiteGroup();
				_rankWindowSprite = new FlxSprite();
				_rankWindowSprite.loadGraphic(AssetPaths.title_screen_blip__png, true, 768, 432);
				_rankWindowSprite.setPosition(20, 60 - 50);
				_rankWindowSprite.animation.add("play", [0, 1, 1], 30, false);
				_rankWindowSprite.animation.play("play");
				_rankWindowGroup.add(_rankWindowSprite);
				_hud.insert(0, _rankWindowGroup);
			}

			if (_rankWindowSprite != null && _rankWindowSprite.animation.finished)
			{
				var newRank:Int = RankTracker.computeAggregateRank();

				if (PlayerData.finalTrial)
				{
					_rankBrainSync = BrainSyncPanel.newInstance(this);
					_rankWindowGroup.insert(0, _rankBrainSync);
				}

				if (newRank > _rankTracker._oldRank || newRank == _rankTracker._oldRank && _rankChance.rankUpTime == null)
				{
					_rankWindowSprite.loadGraphic(AssetPaths.rank_nice__png, true, 200, 150);
					_rankWindowSprite.setPosition(FlxG.width / 2 - _rankWindowSprite.width / 2, FlxG.height / 2 - _rankWindowSprite.height / 2 - 50);
					var glistenAnim:Array<Int> = [];
					AnimTools.push(glistenAnim, 16, [0, 1]);
					_rankWindowSprite.animation.add("glisten", glistenAnim, 6, false);
					_rankWindowSprite.animation.play("glisten");
					_rankTextColor = OptionsMenuState.WHITE_BLUE;
					_rankBorderColor = OptionsMenuState.DARK_BLUE;
				}
				if (newRank == _rankTracker._oldRank && _rankChance.rankUpTime != null)
				{
					_rankWindowSprite.loadGraphic(AssetPaths.rank_just_ok__png, true, 200, 150);
					_rankWindowSprite.setPosition(FlxG.width / 2 - _rankWindowSprite.width / 2, FlxG.height / 2 - _rankWindowSprite.height / 2 - 50);

					_rankTextColor = 0xFFB4F2FF;
					_rankBorderColor = OptionsMenuState.DARK_BLUE;
				}
				if (newRank < _rankTracker._oldRank)
				{
					_rankWindowSprite.loadGraphic(AssetPaths.rank_oh_no__png, true, 200, 150);
					_rankWindowSprite.setPosition(FlxG.width / 2 - _rankWindowSprite.width / 2, FlxG.height / 2 - _rankWindowSprite.height / 2 - 50);
					_rankTextColor = OptionsMenuState.MEDIUM_BLUE;
					_rankBorderColor = OptionsMenuState.LIGHT_BLUE;
				}

				_rankWindowGroup.addTeleparticles(_rankWindowSprite.x + _rankWindowSprite.width * 0.3, _rankWindowSprite.y + _rankWindowSprite.height * 0.1, _rankWindowSprite.x + _rankWindowSprite.width * 0.7, _rankWindowSprite.y + _rankWindowSprite.height * 0.9, 10);

				FlxTween.tween(_rankWindowGroup, { _whiteness:0 }, 0.1);

				setState(355);
			}
		}

		if (_gameState == 355 && _rankLabel == null && _stateTime > 1.2)
		{
			_rankLabel = new FlxText(FlxG.width / 2 - 50, FlxG.height / 2 - 50 + 23, 100, "RANK " + _rankTracker._oldRank, 20);
			_rankLabel.alignment = CENTER;
			_rankLabel.font = AssetPaths.hardpixel__otf;
			_rankLabel.color = _rankTextColor;
			_rankLabel.setBorderStyle(OUTLINE, _rankBorderColor, 2);
			_rankWindowGroup.add(_rankLabel);
			FlxSoundKludge.play(AssetPaths.beep_0065__mp3);
		}

		if (_gameState == 355 && _rankParticle == null && _stateTime > 2.4)
		{
			var oldRank:Int = _rankTracker._oldRank;
			var newRank:Int = RankTracker.computeAggregateRank();

			playAdjustRankAnim(oldRank, newRank);
		}

		if (_gameState == 355)
		{
			if (PlayerData.finalTrial && PlayerData.level < 2)
			{
				// first two final trial levels; let the player watch the brain screensaver
				if (_stateTime > 7.3)
				{
					switchState();
				}
			}
			else if (PlayerData.finalTrial && PlayerData.level == 2)
			{
				if (_stateTime > 3.4)
				{
					var tree:Array<Array<Object>>;
					if (_rankBrainSync.isSuccessfulSync())
					{
						tree = AbraDialog.finalTrialSuccess();
					}
					else
					{
						tree = AbraDialog.finalTrialFailure();
					}

					_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
					_dialogTree.go();
					setState(500);
				}
			}
			else
			{
				if (_stateTime > 4.8)
				{
					switchState();
				}
			}
		}

		if (_gameState == 505)
		{
			if (_stateTime > 0.8)
			{
				if (_rankBrainSync.getPlayerRank() >= _rankBrainSync.getAbraRank())
				{
					// success;
					setState(510);
				}
				else
				{
					// failure; decrease rank...
					var oldRank:Int = RankTracker.computeAggregateRank();
					PlayerData.finalRankHistory = [];
					var newRank:Int = RankTracker.computeAggregateRank();
					if (oldRank == newRank)
					{
						// their rank didn't change; don't wait for any animation
						switchState();
						setState(510);
					}
					else
					{
						playAdjustRankAnim(oldRank, newRank);
						_rankBrainSync.refreshRankData(this);
						setState(510);
					}
				}
			}
		}

		if (_gameState == 510)
		{
			if (_rankBrainSync.isSuccessfulSync())
			{
				if (_stateTime > 1.0)
				{
					switchState();
				}
			}
			else
			{
				if (_stateTime > 3.0)
				{
					// failure; return to main menu
					switchState();
				}
			}
		}

		for (_otherWindow in _otherWindows)
		{
			if (_otherWindow != null && _otherWindow.exists && _otherWindow.alive)
			{
				if (FlxSpriteKludge.overlap(_handSprite, _otherWindow._canvas))
				{
					_otherWindow._canvas.alpha = Math.max(0.3, _otherWindow._canvas.alpha - 3.0 * elapsed);
				}
				else
				{
					_otherWindow._canvas.alpha = Math.min(1.0, _otherWindow._canvas.alpha + 3.0 * elapsed);
				}
			}
		}
	}

	function eventAddRankWindowBlip(args:Array<Dynamic>)
	{
		_rankWindowGroup = new WhiteGroup();
		_rankWindowSprite = new FlxSprite();
		_rankWindowSprite.loadGraphic(AssetPaths.title_screen_blip__png, true, 768, 432);
		_rankWindowSprite.setPosition(20, 60);
		_rankWindowSprite.animation.add("play", [0, 1, 1], 30, false);
		_rankWindowSprite.animation.play("play");
		_rankWindowGroup.add(_rankWindowSprite);
		_hud.insert(0, _rankWindowGroup);
	}

	function eventAddRankWindowGraphics(args:Array<Dynamic>)
	{
		_rankWindowSprite.loadGraphic(AssetPaths.splash_start__png, true, 150, 118);
		_rankWindowSprite.setPosition(FlxG.width / 2 - _rankWindowSprite.width / 2, FlxG.height / 2 - _rankWindowSprite.height / 2);
		var glistenAnim:Array<Int> = [];
		AnimTools.push(glistenAnim, 16, [0, 1]);
		_rankWindowSprite.animation.add("glisten", glistenAnim, 6, false);
		_rankWindowSprite.animation.play("glisten");
		_rankWindowGroup.addTeleparticles(_rankWindowSprite.x + _rankWindowSprite.width * 0.3, _rankWindowSprite.y + _rankWindowSprite.height * 0.1, _rankWindowSprite.x + _rankWindowSprite.width * 0.7, _rankWindowSprite.y + _rankWindowSprite.height * 0.9, 20);

		FlxTween.tween(_rankWindowGroup, { _whiteness:0 }, 0.2);

		FlxSoundKludge.play(AssetPaths.countdown_go_005c__mp3);
	}

	function eventRemoveRankWindowGraphics(args:Array<Dynamic>)
	{
		_rankWindowSprite.loadGraphic(AssetPaths.title_screen_blip__png, true, 768, 432);
		_rankWindowSprite.setPosition(20, 60);
		_rankWindowSprite.animation.add("play", [1, 0, 0], 30, false);
		_rankWindowSprite.animation.play("play");
	}

	function eventRemoveRankWindowBlip(args:Array<Dynamic>)
	{
		_hud.remove(_rankWindowGroup);
		_rankWindowGroup = FlxDestroyUtil.destroy(_rankWindowGroup);
		setState(200);

		if (cellsFull() && !DialogTree.isDialogging(_dialogTree))
		{
			handleGuess();
		}
	}

	function playAdjustRankAnim(oldRank:Int, newRank:Int)
	{
		var particleText:String;
		var sound:Dynamic;
		if (newRank > oldRank)
		{
			particleText = "+" + (newRank - oldRank);
			sound = AssetPaths.rank_up_00C4__mp3;
		}
		else if (newRank == oldRank && _rankChance.rankUpTime == null)
		{
			particleText = "DEF!";
			sound = AssetPaths.rank_defend_0022__mp3;
		}
		else if (newRank < oldRank)
		{
			particleText = "-" + (oldRank - newRank);
			sound = AssetPaths.rank_down_00C5__mp3;
		}
		else
		{
			particleText = "+0";
			sound = AssetPaths.rank_same_00C6__mp3;
		}
		_rankParticle = new FlxText(FlxG.width / 2 - 25 + 40, FlxG.height / 2 - 50 + 23, 50, particleText, 20);
		_rankParticle.moves = true;
		_rankParticle.alignment = CENTER;
		_rankParticle.font = AssetPaths.hardpixel__otf;
		_rankParticle.color = _rankTextColor;
		_rankParticle.setBorderStyle(OUTLINE, _rankBorderColor, 2);
		FlxTween.tween(_rankParticle, {y:_rankParticle.y - 30, alpha:0}, 1.2, {ease:FlxEase.circOut});
		_rankWindowGroup.add(_rankParticle);

		_rankLabel.text = "RANK " + newRank;
		FlxSoundKludge.play(sound);
	}

	/**
	 * We don't want the bugs sitting in the clue boxes, because it looks
	 * glitchy and weird. So they politely step aside as long as they're
	 * not doing anything important.
	 *
	 * These "blockers" are objects which nudge the bugs off of certain
	 * important places.
	 */
	function initializeBlockers()
	{
		_clueBlockers = [];
		_blockers.clear();

		// add a blocker for each clue
		for (i in 0..._puzzle._clueCount)
		{
			var rect:FlxRect = _puzzleLightsManager._spotlights.getBounds("leftclue" + i);
			var sprite:FlxSprite = new FlxSprite(rect.x, rect.y);
			sprite.makeGraphic(Std.int(rect.width), Std.int(rect.height), 0xff880088);
			sprite.immovable = true;
			sprite.visible = false;
			_clueBlockers.push(sprite);
		}

		// add a blocker for the answer
		{
			var rect:FlxRect = _puzzleLightsManager._spotlights.getBounds("wholeanswer");
			var sprite:FlxSprite = new FlxSprite(rect.x, rect.y);
			sprite.makeGraphic(Std.int(rect.width), Std.int(rect.height), 0xff880088);
			sprite.immovable = true;
			sprite.visible = false;
			_clueBlockers.push(sprite);
		}

		// add a blocker for the undo/redo buttons
		if (!_puzzle._easy)
		{
			var sprite:FlxSprite = new FlxSprite(665, 12);
			sprite.makeGraphic(64, 36, 0xff880088);
			sprite.immovable = true;
			sprite.visible = false;
			_clueBlockers.push(sprite);
		}

		for (clueBlocker in _clueBlockers)
		{
			_blockers.add(clueBlocker);
		}

		// update positions so that overlap() works properly
		for (clueBlocker in _clueBlockers)
		{
			clueBlocker.last.set(clueBlocker.x, clueBlocker.y);
		}
		for (targetSprite in _targetSprites)
		{
			targetSprite.last.set(targetSprite.x, targetSprite.y);
		}

		FlxG.overlap(_targetSprites, _blockers, avoidBlockers);
	}

	function destroyBlockers()
	{
		_clueBlockers = [];
		_blockers.clear();
	}

	/**
	 * We move left/right to avoid stepping on clues. Since clues are close
	 * together vertically, we'll end up in an infinite loop otherwise.
	 */
	public function avoidBlockers(Sprite0:FlxSprite, Sprite1:FlxSprite):Void
	{
		if (Sprite0.immovable && Sprite1.immovable)
		{
			return;
		}
		if (!FlxSpriteKludge.overlap(Sprite0, Sprite1))
		{
			// we get some false positives for sprites that overlap more than one blocker
			return;
		}
		var tmp:Float = Sprite0.x;
		if (Sprite0.x + Sprite0.width / 2 < FlxG.width / 2)
		{
			Sprite0.x = Sprite1.x + Sprite1.width + FlxG.random.float(10, 50);
		}
		else {
			Sprite0.x = Sprite1.x - Sprite0.width - FlxG.random.float(10, 50);
		}
	}

	function allChestsFinishedPaying():Bool
	{
		if (_cashWindow._currentAmount != PlayerData.cash)
		{
			return false;
		}
		for (chest in _chests)
		{
			if (!chest._payed)
			{
				return false;
			}
			if (chest._paySprite != null)
			{
				return false;
			}
		}
		return true;
	}

	public function jumpOutOfCell(critter:Critter, runToCallback:Critter->Void)
	{
		var foundCell:Cell.ICell = findCell(critter);
		if (foundCell != null)
		{
			foundCell.removeCritter(critter);
		}
		if (_clueClouds[foundCell] != null)
		{
			setClueCloud(cast(foundCell), CloudState.Maybe, true);
		}
		if (critter.isCubed())
		{
			uncubeCritter(critter);
		}
		var distX:Float = FlxG.random.float(40, 60);
		var distY:Float = FlxG.random.float(20, 60);
		critter.jumpTo(critter._soulSprite.x - distX, critter._soulSprite.y + distY - 1, 0, runToCallback);
		critter.setImmovable(false);
	}

	public function isInRefillArea(critter:Critter)
	{
		return isCoordInRefillArea(critter._soulSprite.x, critter._soulSprite.y) || isCoordInRefillArea(critter._targetSprite.x, critter._targetSprite.y);
	}

	public function isCoordInRefillArea(x:Float, y:Float)
	{
		return x >= -5 && x <= 737 && y >= 375 && y <= 425;
	}

	public function isInPuzzleArea(critter:Critter)
	{
		return isCoordInPuzzleArea(critter._soulSprite.x, critter._soulSprite.y) || isCoordInRefillArea(critter._targetSprite.x, critter._targetSprite.y);
	}

	public function isCoordInPuzzleArea(x:Float, y:Float)
	{
		return x >= -5 && x <= 737 && y >= 20 && y <= 425;
	}

	function switchState()
	{
		var incrementPuzzleCount:Bool = true;
		PlayerData.level++;
		if (_tutorial != null)
		{
			// don't count tutorials in puzzle count...
			incrementPuzzleCount = false;
			if (_puzzle._easy)
			{
				// except for easy puzzles; those count
				incrementPuzzleCount = true;
			}
		}
		if (incrementPuzzleCount)
		{
			PlayerData.puzzleCount[PlayerData.getDifficultyInt()]++;
		}
		if (PlayerData.level > 2 || PlayerData.difficulty == PlayerData.Difficulty._7Peg)
		{
			ItemDatabase._solvedPuzzle = true;
			if (PlayerData.finalTrial)
			{
				LevelIntroDialog.increaseProfReservoirs();
				LevelIntroDialog.rotateProfessors([PlayerData.prevProfPrefix]);
				LevelIntroDialog.rotateChat();
				if (_rankBrainSync.isSuccessfulSync())
				{
					PlayerData.successfulSync();
					if (PlayerData.abraStoryInt == 6)
					{
						FlxG.switchState(new CreditsState());
					}
					else
					{
						FlxG.switchState(EndingAnim.newInstance());
					}
				}
				else
				{
					FlxG.switchState(new MainMenuState());
				}
			}
			else if (_abraWasMad || PlayerData.abraStoryInt == 4 && _pokeWindow._prefix == "abra" && !PlayerData.finalTrial)
			{
				// abra's mad; or, was mad when we started the puzzle and needs time to cool off
				LevelIntroDialog.increaseProfReservoirs();
				LevelIntroDialog.rotateProfessors([PlayerData.prevProfPrefix]);
				LevelIntroDialog.rotateChat();
				FlxG.switchState(new MainMenuState());
			}
			else if (_tutorial != null)
			{
				var sexyState:SexyState<Dynamic> = null;
				if (PlayerData.sfw)
				{
					// skip sexystate; sfw mode
				}
				else
				{
					sexyState = SexyState.getSexyState();
					// don't rotate dialog; we were doing a tutorial
					if (Std.isOfType(sexyState, AbraSexyState))
					{
						if (PlayerData.pokemonLibido == 1)
						{
							// no boner when libido's zeroed out
						}
						else
						{
							cast(sexyState, AbraSexyState).permaBoner = true;
						}
					}
				}

				// we still rotate professors; we don't want to get Grovyle again after a tutorial
				LevelIntroDialog.increaseProfReservoirs();
				LevelIntroDialog.rotateProfessors([PlayerData.prevProfPrefix]);

				if (sexyState == null)
				{
					// skip sexystate; sfw mode
					transOut = MainMenuState.fadeOutSlow();
					FlxG.switchState(new MainMenuState(MainMenuState.fadeInFast()));
				}
				else
				{
					FlxG.switchState(sexyState);
				}
			}
			else
			{
				if (PlayerData.sfw)
				{
					// skip sexystate; sfw mode
					transOut = MainMenuState.fadeOutSlow();
					LevelIntroDialog.increaseProfReservoirs();
					LevelIntroDialog.rotateProfessors([PlayerData.prevProfPrefix]);
					LevelIntroDialog.rotateChat();
					FlxG.switchState(new MainMenuState(MainMenuState.fadeInFast()));
				}
				else
				{
					var sexyState:SexyState<Dynamic> = initializeSexyState();
					FlxG.switchState(sexyState);
				}
			}
		}
		else
		{
			var puzzleState:PuzzleState = new PuzzleState();
			puzzleState._tutorial = _tutorial;
			FlxG.switchState(puzzleState);
		}
	}

	function getHolopadState(colorIndex:Int):Array<Bool>
	{
		var holopadState:Array<Bool> = [];
		while (holopadState.length < _puzzle._pegCount)
		{
			holopadState.push(true);
		}
		var matchingHolopad:Holopad = null;
		for (holopad in _holopads)
		{
			if (holopad._critter != null && holopad._critter.getColorIndex() == colorIndex)
			{
				matchingHolopad = holopad;
				break;
			}
		}
		if (matchingHolopad == null)
		{
			if (_puzzle._pegCount == 7 && _sevenPegHolopadState[colorIndex] != null)
			{
				return _sevenPegHolopadState[colorIndex];
			}
			return holopadState;
		}
		var i:Int = 0;
		for (hologram in _holograms)
		{
			if (hologram._holopad == matchingHolopad)
			{
				holopadState[i++] = hologram.visible;
			}
		}
		return holopadState;
	}

	function setHolopadState(colorIndex:Int, state:Array<Bool>):Void
	{
		for (holopad in _holopads)
		{
			if (holopad._critter != null && holopad._critter.getColorIndex() == colorIndex)
			{
				var i:Int = 0;
				for (hologram in _holograms)
				{
					if (hologram._holopad == holopad)
					{
						hologram.visible = state[i++];
					}
				}
			}
		}
		if (_puzzle._pegCount == 7)
		{
			_sevenPegHolopadState[colorIndex] = state;
		}
	}

	/**
	 * Find an offscreen critter; used for refilling critters at the bottom of the screen, and for some idle animations
	 */
	public function findExtraCritter(?colorIndex:Int):Critter
	{
		var start:Int = FlxG.random.int(0, _critters.length - 1);

		for (i in 0..._critters.length)
		{
			var j = (i + start) % _critters.length;
			if (!_critters[j]._targetSprite.isOnScreen() && StringTools.startsWith(_critters[j]._bodySprite.animation.name, "idle"))
			{
				if (colorIndex != null && _critters[j].getColorIndex() != colorIndex)
				{
					continue;
				}
				var isLabelled:Bool = false;
				for (key in labelledCritters.keys())
				{
					if (labelledCritters[key] == _critters[j])
					{
						isLabelled = true;
						break;
					}
				}
				if (isLabelled)
				{
					continue;
				}
				// offscreen critters might be out cold, so reset them
				_critters[j].reset();
				return _critters[j];
			}
		}
		// couldn't find an offscreen critter; how about critters who are barely-onscreen?
		for (i in 0..._critters.length)
		{
			var j = (i + start) % _critters.length;
			if (!isInPuzzleArea(_critters[j]) && StringTools.startsWith(_critters[j]._bodySprite.animation.name, "idle"))
			{
				if (colorIndex != null && _critters[j].getColorIndex() != colorIndex)
				{
					continue;
				}
				var isLabelled:Bool = false;
				for (key in labelledCritters.keys())
				{
					if (labelledCritters[key] == _critters[j])
					{
						isLabelled = true;
						break;
					}
				}
				if (isLabelled)
				{
					continue;
				}
				// offscreen critters might be out cold, so reset them
				_critters[j].reset();
				return _critters[j];
			}
		}
		return null;
	}

	public function findExtraCritters(count:Int):Array<Critter>
	{
		var start:Int = FlxG.random.int(0, _critters.length - 1);
		var result:Array<Critter> = [];

		for (i in 0..._critters.length)
		{
			var j = (i + start) % _critters.length;
			if (!_critters[j]._targetSprite.isOnScreen() && _critters[j]._bodySprite.animation.name == "idle")
			{
				result.push(_critters[j]);
				if (result.length >= count)
				{
					return result;
				}
			}
		}
		return result;
	}

	override function findTargetCritterHolder():CritterHolder
	{
		var minDistance:Float = _puzzle._easy ? 60 : 36;
		var closestCritterHolder:CritterHolder = null;
		var grabbedMidpoint:FlxPoint = _grabbedCritter._bodySprite.getMidpoint();
		for (cell in _answerCells)
		{
			var distance:Float = cell.getSprite().getMidpoint().distanceTo(grabbedMidpoint);
			if (_puzzle._easy)
			{
				if (distance < minDistance && cell.getCritters().length < _puzzle._pegCount )
				{
					minDistance = distance;
					closestCritterHolder = cast(cell);
				}
			}
			else
			{
				if (distance < minDistance && cell.getCritters().length == 0)
				{
					minDistance = distance;
					closestCritterHolder = cast(cell);
				}
			}
		}
		for (holopad in _holopads)
		{
			var distance:Float = holopad._sprite.getMidpoint().distanceTo(grabbedMidpoint);
			if (distance < minDistance && holopad._critter == null)
			{
				minDistance = distance;
				closestCritterHolder = holopad;
			}
		}
		return closestCritterHolder;
	}

	override function findGrabbedCritter():Critter
	{
		var critter:Critter = super.findGrabbedCritter();
		if (_textWindowGroup != null && _textWindowGroup.visible)
		{
			// don't let user grab critters if we're prompting for their name
			return null;
		}
		if (handlingGuess)
		{
			// don't let user grab critters if we're handling a guess
			return null;
		}
		if (_gameState < 300)
		{
			// don't let user grab critters from clue cells until puzzle is solved
			for (clueCell in _clueCells)
			{
				if (clueCell.getAssignedCritters().indexOf(critter) != -1)
				{
					critter = null;
					break;
				}
			}
		}
		if (critter == null)
		{
			// are they trying to grab a reward critter?
			var offsetPoint:FlxPoint = new FlxPoint(_clickedMidpoint.x, _clickedMidpoint.y);
			offsetPoint.y += 10;
			var minDistance:Float = 25 + 1;
			var closestCritter:Critter = null;
			for (rewardCritter in _rewardCritters)
			{
				if (getCarriedChest(rewardCritter) != null)
				{
					continue;
				}
				var distance:Float = rewardCritter._bodySprite.getMidpoint().distanceTo(offsetPoint);
				if (distance < minDistance)
				{
					minDistance = distance;
					closestCritter = rewardCritter;
				}
			}
			if (closestCritter != null)
			{
				// swap places; the rewardCritter blinks offscreen, and the player picks up this random critter
				critter = findExtraCritter(closestCritter.getColorIndex());
				if (critter == null && _critters.length < 80)
				{
					// couldn't find an extra critter... just make a new critter to swap with
					critter = new Critter(FlxG.random.float(0, FlxG.width), FlxG.random.float(0, FlxG.height), _backdrop);
					critter.setColor(closestCritter._critterColor);
					addCritter(critter);
				}
				if (critter != null)
				{
					critter.setPosition(closestCritter._bodySprite.x, closestCritter._bodySprite.y);
					var x:Float = FlxG.random.int( -40 + 100, FlxG.width - 100);
					var y:Float = FlxG.random.bool() ? FlxG.height + 100 : -70;
					closestCritter.setPosition(x, y);
				}
			}
		}
		if (critter != null)
		{
			_undoOperations[_undoIndex] = { critter: critter, oldX: critter._bodySprite.x, oldY: critter._bodySprite.y };
		}
		return critter;
	}

	function findClickedHologram():Hologram
	{
		var offsetPoint:FlxPoint = new FlxPoint(_clickedMidpoint.x, _clickedMidpoint.y);
		offsetPoint.y += 10;
		var clickedHologram:Hologram = null;
		var minDistance:Float = 25;
		for (hologram in _holograms)
		{
			if (hologram._holopad._critter == null)
			{
				// ignore clicks corresponding to empty holopads
				continue;
			}
			var distance:Float = hologram.getMidpoint().distanceTo(offsetPoint);
			if (distance < minDistance)
			{
				clickedHologram = hologram;
				minDistance = distance;
			}
		}
		return clickedHologram;
	}

	function findClickedClueCell():Cell.ICell
	{
		var offsetPoint:FlxPoint = new FlxPoint(_clickedMidpoint.x, _clickedMidpoint.y);
		offsetPoint.y += 7;
		var clickedCell:Cell.ICell = null;
		var minDistance:Float = 25;
		for (clueCell in _clueCells)
		{
			var distance:Float = clueCell.getSprite().getMidpoint().distanceTo(offsetPoint);
			if (distance < minDistance)
			{
				clickedCell = clueCell;
				minDistance = distance;
			}
		}
		return clickedCell;
	}

	function resetHandlingGuess(args:Array<Dynamic>)
	{
		this.handlingGuess = false;
	}

	function handleGuess():Void
	{
		handlingGuess = true;
		var eventTime:Float = _eventStack._time + 0.3;
		var mistake:Mistake = computeMistake();
		if (PlayerData.cheatsEnabled && FlxG.keys.pressed.SHIFT)
		{
			// cheat
		}
		else if (mistake != null && mistake.clueIndex == -1)
		{
			// bogus answer; don't even check clues
			_eventStack.addEvent({time:eventTime + 0.07, callback:eventClueOk, args:[mistake.clueIndex, false]});
			_eventStack.addEvent({time:eventTime + 0.07, callback:EventStack.eventPlaySound, args:[AssetPaths.clue_bad_00ff__mp3]});
			if (helpfulDialog)
			{
				eventTime += 1.5;
				_eventStack.addEvent({time:eventTime, callback:eventInvalidAnswerDialog});
			}
			else
			{
				helpfulDialog = true;
			}
			_eventStack.addEvent({time:eventTime, callback:resetHandlingGuess});
			_justMadeMistake = true;
			return;
		}
		_eventStack.addEvent({time:eventTime, callback:_puzzleLightsManager.eventLightsOff});
		_eventStack.addEvent({time:eventTime, callback:_puzzleLightsManager.eventSpotlightOn, args:["wholeanswer"]});
		{
			var tmpTime:Float = eventTime;
			for (answerCell in _answerCells)
			{
				_eventStack.addEvent({time:tmpTime + FlxG.random.float(-0.05, 0.05), callback:eventCube, args:[answerCell]});
				tmpTime += _puzzle._easy ? 0.17 : 0.17 / (_puzzle._pegCount - 1);
			}
		}
		if (mistake == null
				// cheat
				|| PlayerData.cheatsEnabled && FlxG.keys.pressed.SHIFT)
		{

			// Change away from state 200, so reward critter knows not to spawn
			setState(205);

			if (mistake != null && PlayerData.cheatsEnabled && FlxG.keys.pressed.SHIFT)
			{
				if (_rankTracker != null)
				{
					_rankTracker.penalize();
				}
			}
			eventTime += 0.7;
			for (i in 0..._puzzle._clueCount)
			{
				_eventStack.addEvent({time:eventTime, callback:_puzzleLightsManager.eventSpotlightOn, args:["wholeclue" + i]});
				_eventStack.addEvent({time:eventTime + 0.07, callback:eventClueOk, args:[i, true]});
				_eventStack.addEvent({time:eventTime + 0.07, callback:EventStack.eventPlaySound, args:[AssetPaths.clue_ok_00fa__mp3]});
				for (j in 0..._puzzle._pegCount)
				{
					if (_puzzle._easy && j > 0)
					{
						break;
					}
					_eventStack.addEvent({time:eventTime, callback:eventUncube, args:[getCell(i, j)]});
					eventTime += _puzzle._easy ? 0.17 : 0.17 / (_puzzle._pegCount - 1);
				}
				eventTime += 0.21;
			}
			_eventStack.addEvent({time:eventTime, callback:resetHandlingGuess});
			_eventStack.addEvent({time:eventTime, callback:_puzzleLightsManager.eventLightsOn});
			{
				var tmpTime:Float = eventTime;
				for (p in 0..._puzzle._pegCount)
				{
					if (_puzzle._easy && p > 0)
					{
						break;
					}
					_eventStack.addEvent({time:tmpTime, callback:eventUncube, args:[_answerCells[p]]});
					tmpTime += _puzzle._easy ? 0.17 : 0.17 / (_puzzle._pegCount - 1);
				}
			}
			eventTime += 0.21;
			_eventStack.addEvent({time:eventTime, callback:eventSetState, args:[300]});
			_eventStack.addEvent({time:eventTime, callback:eventCheer});

			_mainRewardCritter.reimburseChestReward();
			var _finalChest:Chest = getCarriedChest(_mainRewardCritter);
			if (_finalChest == null)
			{
				_finalChest = addChest();
				_finalChest._critter = _mainRewardCritter;
			}

			_finalChest.setReward(_puzzle._reward);

			if (_siphonPuzzleReward >= 0)
			{
				// sandslash raided your chest
				DIALOG_VARS[_siphonPuzzleReward] = _finalChest._reward;
				_finalChest.setReward(0);
			}

			if (_abraWasMad || PlayerData.abraStoryInt == 4 && _pokeWindow._prefix == "abra" && !PlayerData.finalTrial)
			{
				// skip minigame chance; abra's mad
				_minigameChance = false;
			}
			if (_minigameChance)
			{
				var minChest:Int = 0;
				if (_finalChest._reward >= 1000)
				{
					minChest = 1000;
				}
				else if (_finalChest._reward >= 500)
				{
					minChest = 500;
				}
				else if (_finalChest._reward >= 200)
				{
					minChest = 200;
				}
				else
				{
					minChest = 100;
				}
				// maybe siphon player's other bonuses for a comedically huge end-of-level reward...
				var siphonedCritterBonus:Int = PlayerData.siphonCritterBonus(FlxG.random.getObject([0.0, 0.0, 0.1, 0.3, 0.6, 1.0]));
				var siphonedReservoirReward:Int = PlayerData.siphonReservoirReward(FlxG.random.getObject([0.0, 0.0, 0.0, 0.1, 0.3, 0.6]));

				if (siphonedCritterBonus + siphonedReservoirReward + _finalChest._reward >= 200)
				{
					// it worked; give them a big payout (or, at least an extra chest)
					_finalChest._reward += siphonedCritterBonus;
					_finalChest._reward += siphonedReservoirReward;
					splitLargeReward(minChest);
					var coinChest:Chest = addEndGameChest();
					coinChest.setReward(minChest);
					coinChest._minigameCoin = true;
				}
				else
				{
					// they didn't have very much; just give them the lucky coin, and reimburse them for the contents of the chest
					PlayerData.reimburseCritterBonus(siphonedCritterBonus + _finalChest._reward);
					PlayerData.reservoirReward += siphonedReservoirReward;
					_finalChest._minigameCoin = true;
				}
			}

			if (_finalChest._reward >= 2500)
			{
				splitLargeReward(1000);
			}

			// randomize the opening order of chests
			FlxG.random.shuffle(_chests);

			/**
			 * the end animation can potentially need a lot of gems. we add extra gems to the gem pool,
			 * removing the offscreen critters to compensate for the extra CPU load
			 */
			var extraCritter:Critter;
			do
			{
				extraCritter = findExtraCritter();
				if (extraCritter != null)
				{
					removeCritter(extraCritter);
					FlxDestroyUtil.destroy(extraCritter);
					var gemsPerCritter:Int = 4;
					if (PlayerData.detailLevel == PlayerData.DetailLevel.VeryLow)
					{
						gemsPerCritter = 2;
					}
					else if (PlayerData.detailLevel == PlayerData.DetailLevel.Low)
					{
						gemsPerCritter = 3;
					}
					for (i in 0...gemsPerCritter)
					{
						_gems.push(new Gem());
					}
				}
			}
			while (extraCritter != null);

			destroyBlockers();

			if ((_tutorial != null) && ((_tutorialTime - 10) * 0.7) < _finalChest._reward ||
					_dispensedHintCount > 0)
			{
				// completed tutorial too fast, or asked for hints -- in these scenarios, we cap the rewards at $42 per minute
				var rewardCap:Int = Puzzle.getSmallestRewardGreaterThan((_tutorialTime - 10) * 0.7);
				if (_finalChest._reward > rewardCap)
				{
					_finalChest.setReward(rewardCap);
				}
			}
			_mainRewardCritter.comeToCenter();
			if (_rankTracker != null)
			{
				if (PlayerData.finalTrial)
				{
					var secondsTaken:Float = _rankTracker.getSecondsTaken(RankTracker.FINAL_MIN_TIME);
					var bandTime:Float = Std.int(secondsTaken) / _puzzle._difficulty;
					PlayerData.finalRankHistory.push(RankTracker.computeRank(bandTime));
				}
				_rankTracker.stop();
				if (_rankHistoryBackup != null)
				{
					PlayerData.rankHistory = _rankHistoryBackup;
				}
			}
			return;
		}
		if (mistake.clueIndex >= 0 && mistake.clueIndex < _puzzle._clueCount)
		{
			eventTime += 0.7;
			for (i in 0...mistake.clueIndex)
			{
				_eventStack.addEvent({time:eventTime, callback:_puzzleLightsManager.eventSpotlightOn, args:["wholeclue" + i]});
				_eventStack.addEvent({time:eventTime + 0.07, callback:EventStack.eventPlaySound, args:[AssetPaths.clue_ok_00fa__mp3]});
				_eventStack.addEvent({time:eventTime + 0.07, callback:eventClueOk, args:[i, true]});
				for (j in 0..._puzzle._pegCount)
				{
					if (_puzzle._easy && j > 0)
					{
						break;
					}
					_eventStack.addEvent({time:eventTime, callback:eventUncube, args:[getCell(i, j)]});
					eventTime += _puzzle._easy ? 0.17 : 0.17 / (_puzzle._pegCount - 1);
				}
				eventTime += 0.21;
			}
			if (_puzzle._easy || FlxG.random.bool(85))
			{
				// straightforward "wrong"
				_eventStack.addEvent({time:eventTime, callback:_puzzleLightsManager.eventSpotlightOn, args:["wholeclue" + mistake.clueIndex]});
				_eventStack.addEvent({time:eventTime + 0.07, callback:EventStack.eventPlaySound, args:[AssetPaths.clue_bad_00ff__mp3]});
				_eventStack.addEvent({time:eventTime + 0.07, callback:eventClueOk, args:[mistake.clueIndex, false]});
				for (i in 0...mistake.clueIndex)
				{
					_eventStack.addEvent({time:eventTime + 0.07, callback:_puzzleLightsManager.eventSpotlightOff, args:["wholeclue" + i]});
				}
				eventTime += 0.07;
				{
					var tmpTime:Float = eventTime;
					for (cell in _clueCells)
					{
						if (cell.getClueIndex() < mistake.clueIndex)
						{
							_eventStack.addEvent({time:tmpTime + FlxG.random.float(-0.05, 0.05), callback:eventCube, args:[cell]});
							tmpTime += 0.05;
						}
					}
				}
			}
			else
			{
				/*
				 * jackass "wrong"... we pretend the answer might be right, but
				 * then change it to an "X" at the last moment
				 */
				_mainRewardCritter.immediatelySpawnIdleReward();
				_eventStack.addEvent({time:eventTime, callback:_puzzleLightsManager.eventSpotlightOn, args:["wholeclue" + mistake.clueIndex]});
				_eventStack.addEvent({time:eventTime + 0.07, callback:EventStack.eventPlaySound, args:[AssetPaths.clue_fake_ok_00fc__mp3]});
				_eventStack.addEvent({time:eventTime + 0.07, callback:eventClueOk, args:[mistake.clueIndex, true]});
				for (j in 0..._puzzle._pegCount - 1)
				{
					if (_puzzle._easy && j > 0)
					{
						break;
					}
					_eventStack.addEvent({time:eventTime, callback:eventUncube, args:[getCell(mistake.clueIndex, j)]});
					eventTime += _puzzle._easy ? 0.17 : 0.17 / (_puzzle._pegCount - 1);
				}
				_eventStack.addEvent({time:eventTime, callback:eventClueSurpriseWrong});
				for (i in 0...mistake.clueIndex)
				{
					_eventStack.addEvent({time:eventTime + 0.07, callback:_puzzleLightsManager.eventSpotlightOff, args:["wholeclue" + i]});
				}
				eventTime += 0.07;
				{
					var tmpTime:Float = eventTime;
					for (clueCell in _clueCells)
					{
						var cell:Cell = cast(clueCell);
						if (cell.getClueIndex() < mistake.clueIndex || (cell.getClueIndex() == mistake.clueIndex && cell._pegIndex < _puzzle._pegCount - 1))
						{
							_eventStack.addEvent({time:tmpTime + FlxG.random.float(-0.05, 0.05), callback:eventCube, args:[cell]});
							tmpTime += 0.05;
						}
					}
				}
			}
			eventTime += 2.0;
			{
				var tmpTime:Float = eventTime;
				for (p in 0..._puzzle._pegCount)
				{
					if (_puzzle._easy && p > 0)
					{
						break;
					}
					_eventStack.addEvent({time:tmpTime, callback:eventUncube, args:[_answerCells[p]]});
					tmpTime += _puzzle._easy ? 0.17 : 0.17 / (_puzzle._pegCount - 1);
				}
			}
			_eventStack.addEvent({time:eventTime, callback:resetHandlingGuess});
			if (helpfulDialog)
			{
				_eventStack.addEvent({time:eventTime, callback:eventClueBadDialog});
			}
			else
			{
				_eventStack.addEvent({time:eventTime, callback:_puzzleLightsManager.eventLightsOn});
				helpfulDialog = true;
			}
			_justMadeMistake = true;
			return;
		}
	}

	override function handleMouseRelease():Void
	{
		maybeReleaseCritter();
	}

	override public function maybeReleaseCritter():Bool
	{
		if (_grabbedCritter != null)
		{
			// user dropped a critter
			if (_mousePressedPosition.distanceTo(FlxG.mouse.getWorldPosition()) >= 8 || _mousePressedDuration > 0.50 || _clickGrabbed)
			{
				SoundStackingFix.play(AssetPaths.drop__mp3);
				var targetCritterHolder:CritterHolder = cast(findTargetCritterHolder());

				if (Std.isOfType(targetCritterHolder, Cell) || Std.isOfType(_undoOperations[_undoIndex].oldCritterHolder, Cell))
				{
					// We messed with the solution; reset the "just made mistake" flag
					_justMadeMistake = false;
				}

				if (targetCritterHolder != null)
				{
					if (Std.isOfType(targetCritterHolder, Holopad))
					{
						var holopad:Holopad = cast(targetCritterHolder, Holopad);
						var holopadState:Array<Bool> = getHolopadState(_grabbedCritter.getColorIndex());
						_undoOperations[_undoIndex].newHolopadState = holopadState;
						placeCritterInHolopad(holopad, _grabbedCritter);
					}
					else
					{
						placeCritterInHolder(targetCritterHolder, _grabbedCritter);
					}
				}
				else
				{
					_grabbedCritter._targetSprite.y += 10;
					_grabbedCritter._soulSprite.y += 10;
					_grabbedCritter._bodySprite.y += 10;

					for (cell in _allCells)
					{
						if (_grabbedCritter._targetSprite.overlaps(cell.getSprite()))
						{
							critterCollide(_grabbedCritter._targetSprite, cell.getSprite());
						}
					}
				}

				_undoOperations[_undoIndex].newCritterHolder = targetCritterHolder;
				_undoOperations[_undoIndex].newX = _grabbedCritter._bodySprite.x;
				_undoOperations[_undoIndex].newY = _grabbedCritter._bodySprite.y;

				if (isCoordInRefillArea(_undoOperations[_undoIndex].oldX, _undoOperations[_undoIndex].oldY)
						&& !isCoordInRefillArea(_undoOperations[_undoIndex].newX, _undoOperations[_undoIndex].newY))
				{
					// we moved a critter out of the bottom area... if we undo, the replacement critter stays on screen,
					// and the critter we grabbed is sent offscreen.
					_undoOperations[_undoIndex].oldY = 500 + FlxG.random.float( -12, 12);

					if (_critterRefillTimer > 0)
					{
						_critterRefillTimer = FlxG.random.float(0.25, 0.75);
					}
					else
					{
						_critterRefillQueued = true;
					}
				}

				finishAppendingUndoOperation();

				if (!_puzzle._easy && targetCritterHolder != null && (_undoIndex - 1) < _undoOperations.length
						&& targetCritterHolder == _undoOperations[_undoIndex - 1].oldCritterHolder)
				{
					// we're dropping a critter back into the same container.
					// undoing the previous operation instead of repeating it keeps us from resetting holopads
					undo();
					_undoOperations.splice(_undoIndex, _undoOperations.length);
				}

				handleUngrab();
				_clickGrabbed = false;
			}
			else
			{
				_clickGrabbed = true;
			}
			return true;
		}
		return false;
	}

	override function handleCritterOverlap(elapsed:Float)
	{
		FlxG.overlap(_targetSprites, _targetSprites, critterCollide);
		FlxG.overlap(_targetSprites, _blockers, avoidBlockers);
	}

	function finishAppendingUndoOperation()
	{
		_undoIndex++;
		_undoOperations.splice(_undoIndex, _undoOperations.length);
		if (_undoIndex > _MAX_UNDO)
		{
			_undoIndex--;
			_undoOperations.splice(0, 1);
		}
	}

	override function placeCritterInHolder(holder:CritterHolder, critter:Critter)
	{
		super.placeCritterInHolder(holder, critter);
		if (_gameState == 200)
		{
			if (cellsFull() && !DialogTree.isDialogging(_dialogTree))
			{
				handleGuess();
			}
		}
	}

	function placeCritterInHolopad(holopad:Holopad, critter:Critter)
	{
		var holopadState:Array<Bool> = getHolopadState(critter.getColorIndex());
		holopad.holdCritter(critter);
		// make holograms visible,
		var i:Int = 0;
		for (hologram in _holograms)
		{
			if (hologram._holopad == holopad)
			{
				hologram.visible = holopadState[i++];
			}
		}
		// and create a new holopad?
		if (holopad == _holopads[_holopads.length - 1] && _holopads.length < _puzzle._pegCount + 1)
		{
			if (_puzzle._pegCount == 7)
			{
				// don't create additional holopads for 7-peg puzzles
			}
			else
			{
				createHolopad(holopad._sprite.x, holopad._sprite.y + 24);
			}
		}
	}

	override function handleMousePress():Void
	{
		var chest:Chest = findClickedChest();
		if (chest != null)
		{
			if (chest._critter != null)
			{
				var rewardCritter:RewardCritter = cast(chest._critter, RewardCritter);
				rewardCritter.dropChest(chest);
				return;
			}
			payChest(chest);
			return;
		}
		var didGrabCritter:Bool = maybeGrabCritter();
		if (didGrabCritter)
		{
			if (SexyAnims.isLinked(_grabbedCritter))
			{
				SexyAnims.unlinkCritterAndMakeGroupIdle(_grabbedCritter);
				// unlinking a critter resets their grab animation; reapply grab animation
				_grabbedCritter.grab();
			}
			return;
		}
		var hologram:Hologram = findClickedHologram();
		if (hologram != null && hologram._holopad._critter != null)
		{
			// toggle holograms
			_undoOperations[_undoIndex] = {critter: hologram._holopad._critter};
			_undoOperations[_undoIndex].oldHolopadState = getHolopadState(hologram._holopad._critter.getColorIndex());
			for (otherHologram in _holograms)
			{
				if (otherHologram._holopad._critter != null && otherHologram._holopad._critter.getColorIndex() == hologram._holopad._critter.getColorIndex() && otherHologram._pegIndex == hologram._pegIndex)
				{
					otherHologram.visible = !otherHologram.visible;

					if (_puzzle._pegCount == 7)
					{
						// 7-peg puzzles cache the holopad state; update the cache
						_sevenPegHolopadState[hologram._holopad._critter.getColorIndex()] = getHolopadState(hologram._holopad._critter.getColorIndex());
					}
				}
			}
			_undoOperations[_undoIndex].newHolopadState = getHolopadState(hologram._holopad._critter.getColorIndex());
			finishAppendingUndoOperation();
		}
		if (!_puzzle._easy)
		{
			var cell:Cell = cast(findClickedClueCell());
			if (cell != null && cell._critter != null && cell.isClosed())
			{
				// toggle clue cloud
				var clueCloud:BouncySprite = _clueClouds[cell];
				if (_undoOperations[_undoIndex - 1] != null && _undoOperations[_undoIndex - 1].oldCloudState != null && _undoOperations[_undoIndex - 1].oldCritterHolder == cell)
				{
					_undoIndex--;
				}
				else
				{
					_undoOperations[_undoIndex] = {oldCritterHolder:cell, newCritterHolder:cell};
				}
				var currCloudState:CloudState;
				var newCloudState:CloudState;
				if (clueCloud == null)
				{
					currCloudState = CloudState.Maybe;
					newCloudState = CloudState.No;
				}
				else if (clueCloud.animation != null && clueCloud.animation.name == "no")
				{
					currCloudState = CloudState.No;
					newCloudState = CloudState.Yes;
				}
				else
				{
					currCloudState = CloudState.Yes;
					newCloudState = CloudState.Maybe;
				}
				setClueCloud(cell, newCloudState);

				if (_undoOperations[_undoIndex].oldCloudState == null)
				{
					_undoOperations[_undoIndex].oldCloudState = currCloudState;
				}
				_undoOperations[_undoIndex].newCloudState = newCloudState;

				if (_undoOperations[_undoIndex].oldCritterHolder == cell && _undoOperations[_undoIndex].oldCloudState == _undoOperations[_undoIndex].newCloudState)
				{
					_undoOperations.splice(_undoIndex, _undoOperations.length);
				}
				else
				{
					finishAppendingUndoOperation();
				}
			}
		}
	}

	function setClueCloud(cell:Cell, cloudState:CloudState, mute:Bool = false):Void
	{
		var clueCloud:BouncySprite = _clueClouds[cell];
		if (cloudState == CloudState.Maybe)
		{
			if (clueCloud != null)
			{
				emitCloudParticles(clueCloud);
				if (!mute)
				{
					SoundStackingFix.play(AssetPaths.cloud_onoff_0093__mp3, 0.7);
				}

				_midSprites.remove(clueCloud);
				FlxDestroyUtil.destroy(clueCloud);
				_clueClouds[cell] = null;
			}
		}
		else {
			if (clueCloud == null)
			{
				clueCloud = new BouncySprite(cell._frontSprite.x + 16, cell._frontSprite.y + 2, 4, 3, FlxG.random.float(0, 1));
				clueCloud.alpha = 0.88;
				clueCloud.setBaseOffsetY(21);
				clueCloud.loadGraphic(AssetPaths.clue_cloud__png, true, 18, 18);
				clueCloud.animation.add("yes", [4, 5, 6, 7], 3);
				clueCloud.animation.add("no", [0, 1, 2, 3], 3);
				_midSprites.add(clueCloud);
				_clueClouds[cell] = clueCloud;

				emitCloudParticles(clueCloud);
				if (!mute)
				{
					SoundStackingFix.play(AssetPaths.cloud_onoff_0093__mp3, 0.7);
				}
			}
			else {
				if (!mute)
				{
					SoundStackingFix.play(AssetPaths.cloud_modify_0088__mp3, 0.7);
				}
			}
			if (cloudState == CloudState.Yes)
			{
				clueCloud.animation.play("yes");
			}
			else if (cloudState == CloudState.No)
			{
				clueCloud.animation.play("no");
			}
		}
	}

	function emitCloudParticles(clueCloud:FlxSprite):Void
	{
		_cloudParticles.x = clueCloud.x - clueCloud.offset.x + clueCloud.width / 2;
		_cloudParticles.y = clueCloud.y - clueCloud.offset.y + clueCloud.height / 2;

		_cloudParticles.start(true, 0, 1);
		_cloudParticles.emitParticle();
		_cloudParticles.emitParticle();
		_cloudParticles.emitParticle();
		_cloudParticles.emitParticle();
		_cloudParticles.emitting = false;
	}

	override function removeCritterFromHolder(critter:Critter):Bool
	{
		var cell:Cell.ICell = findCell(critter);
		if (cell != null)
		{
			if (_undoOperations[_undoIndex] != null)
			{
				_undoOperations[_undoIndex].oldCritterHolder = cast(cell);
			}
			critter.setImmovable(false);
			cell.removeCritter(critter);
			return true;
		}
		for (holopad in _holopads)
		{
			if (holopad._critter == critter)
			{
				if (_undoOperations[_undoIndex] != null)
				{
					_undoOperations[_undoIndex].oldHolopadState = getHolopadState(critter.getColorIndex());
					_undoOperations[_undoIndex].oldCritterHolder = holopad;
				}
				holopad._critter.setImmovable(false);
				holopad._critter = null;
				return true;
			}
		}
		return true;
	}

	public function maybePayAllChests()
	{
		if (_payedAllChests)
		{
			return;
		}
		for (chest in _chests)
		{
			if (chest._critter != null)
			{
				// can't pay all chests until they're dropped
				return;
			}
		}
		_payedAllChests = true;
		var eventTime:Float = _eventStack._time;
		for (chest in _chests)
		{
			if (chest == null || chest._payed)
			{
				continue;
			}
			_eventStack.addEvent({time:eventTime, callback:eventOpenChest, args:[chest]});
			eventTime += 0.42;
		}
	}

	public function eventOpenChest(params:Array<Dynamic>):Void
	{
		payChest(params[0]);
	}

	public function payChest(chest:Chest)
	{
		_cashWindow.show();
		chest.pay(_hud);
		if (chest._minigameCoin)
		{
			if (chest._paySprite == null)
			{
				/*
				 * Chest has already been destroyed? I've never seen this
				 * behavior, but it could account for crashes people are seeing
				 */
			}
			else
			{
				// lucky coin
				emitCloudParticles(chest._paySprite);
			}
		}
		else
		{
			emitGems(chest);
		}
	}

	public function getCarriedChest(critter:Critter):Chest
	{
		for (chest in _chests)
		{
			if (chest._critter == critter)
			{
				return chest;
			}
		}
		return null;
	}

	function findClickedChest():Chest
	{
		var chestClickPoint:FlxPoint = new FlxPoint(_clickedMidpoint.x, _clickedMidpoint.y);
		chestClickPoint.y += 5;
		var critterClickPoint:FlxPoint = new FlxPoint(chestClickPoint.x, chestClickPoint.y + 5);
		var clickedChest:Chest = null;
		var minDistance:Float = 30;
		for (chest in _chests)
		{
			if (chest._chestSprite == null)
			{
				continue;
			}
			if (chest._payed)
			{
				// can't reactivate clicked chests
				continue;
			}
			var distance:Float = 0;
			if (chest._critter != null)
			{
				distance = chest._chestSprite.getMidpoint().distanceTo(critterClickPoint);
			}
			else
			{
				distance = chest._chestSprite.getMidpoint().distanceTo(chestClickPoint);
			}
			if (distance < minDistance)
			{
				clickedChest = chest;
				minDistance = distance;
			}
		}
		return clickedChest;
	}

	function runFromCell(critter:Critter):Void
	{
		critter.runTo(FlxG.random.float(0, FlxG.width - 36), FlxG.random.float(0, FlxG.height - 10));
	}

	public function jumpIntoCell(critter:Critter):Void
	{
		var foundCell:Cell.ICell = findCell(critter);
		if (foundCell != null)
		{
			if (Std.isOfType(foundCell, BigCell))
			{
				var bigCell:BigCell = cast(foundCell);
				var index:Int = bigCell._assignedCritters.indexOf(critter);
				critter.jumpTo(bigCell.getSprite().x - critter._soulSprite.width / 2 + bigCell.getSprite().width / 2 + bigCell.getCritterOffsetX(critter), bigCell.getSprite().y - critter._soulSprite.height / 2 + bigCell.getSprite().height / 2 + bigCell.getCritterOffsetY(critter), 0, holdCritter);
			}
			else
			{
				critter.jumpTo(foundCell.getSprite().x, foundCell.getSprite().y - 1, 0, holdCritter);
			}
		}
	}

	public function findCell(critter:Critter):Cell.ICell
	{
		for (cell in _allCells)
		{
			if (cell.getCritters().indexOf(critter) != -1 || cell.getAssignedCritters().indexOf(critter) != -1)
			{
				return cell;
			}
		}
		return null;
	}

	public function findHolopad(critter:Critter):Holopad
	{
		for (holopad in _holopads)
		{
			if (holopad._critter == critter)
			{
				return holopad;
			}
		}
		return null;
	}

	function holdCritter(critter:Critter):Void
	{
		var cell:Cell.ICell = findCell(critter);
		cast(cell, CritterHolder).holdCritter(critter);
	}

	function uncubeCritter(critter:Critter):Void
	{
		var cell:Cell.ICell = findCell(critter);
		_critters.push(critter);
		critter.uncube();
		if (cell != null && cell.isClosed())
		{
			// when processing events, it's possible for a critter to be unassigned a cell before he's officially uncubed
			cell.open();
			if (Std.isOfType(cell, Cell))
			{
				critter.setPosition(cell.getSprite().x, cell.getSprite().y + 1);
			}
		}
		// add critter sprites
		_targetSprites.add(critter._targetSprite);
		_midInvisSprites.add(critter._soulSprite);
		_midSprites.add(critter._bodySprite);
		_midSprites.add(critter._frontBodySprite);
	}

	public function cubeCritter(critter:Critter):Void
	{
		var foundCell:Cell.ICell = findCell(critter);
		_critters.remove(critter);
		critter.cube();
		if (Std.isOfType(foundCell, Cell))
		{
			// move critter's head behind the glass
			critter.setPosition(foundCell.getSprite().x, foundCell.getSprite().y - 1);
		}
		else {
			cast(foundCell, BigCell).leashAll(true);
		}
		// remove unnecessary critter sprites, to save CPU cycles
		_targetSprites.remove(critter._targetSprite);
		_midInvisSprites.remove(critter._soulSprite);
		_midSprites.remove(critter._bodySprite);
		_midSprites.remove(critter._frontBodySprite);
		foundCell.addCritter(critter);
		foundCell.close();
	}

	private function cellsFull():Bool
	{
		var crittersPerCell:Int = _puzzle._easy ? _puzzle._pegCount : 1;
		for (cell in _answerCells)
		{
			if (cell.getCritters().length < crittersPerCell)
			{
				return false;
			}
		}
		return true;
	}

	function eventHoldAndCubeClueCritters(args:Array<Dynamic>):Void
	{
		if (anyClueCrittersUnheld())
		{
			_needToCube = true;
			holdClueCritters();
			_eventStack.addEvent({time:_eventStack._time + 0.2, callback:eventHoldAndCubeClueCritters});
			return;
		}
		if (_needToCube)
		{
			_needToCube = false;
			var anyUncubed = anyClueCrittersUncubed();
			if (anyUncubed)
			{
				var eventTime:Float = _eventStack._time + 0.1;
				for (clueCell in _clueCells)
				{
					_eventStack.addEvent({time:eventTime + FlxG.random.float(-0.05, 0.05), callback:eventCube, args:[clueCell]});
					eventTime += _puzzle._easy ? 0.05 : 0.05 / (_puzzle._pegCount - 1);
				}
				_eventStack.addEvent({time:eventTime + 0.3, callback:eventHoldAndCubeClueCritters});
			}
			return;
		}
		if (anyClueCrittersUncubed())
		{
			for (cell in _clueCells)
			{
				for (critter in cell.getCritters())
				{
					cubeCritter(critter);
				}
			}
			_eventStack.addEvent({time:_eventStack._time + 0.3, callback:eventHoldAndCubeClueCritters});
			return;
		}
		// all critters held and cubed
	}

	function holdClueCritters():Void
	{
		for (cell in _clueCells)
		{
			for (critter in cell.getAssignedCritters())
			{
				var distX:Float = FlxG.random.float(40, 60);
				var distY:Float = FlxG.random.float(20, 60);

				// jump from one of four possible directions; whichever's closest
				var dx:Float = critter._bodySprite.x + critter._bodySprite.width / 2 - cell.getSprite().x - cell.getSprite().width / 2;
				var dy:Float = critter._bodySprite.y + critter._bodySprite.height / 2 - cell.getSprite().y - cell.getSprite().height / 2;
				if (dx < 0)
				{
					distX *= -1;
				}
				if (dy < 0)
				{
					distY *= -1;
				}

				if (critter._runToCallback == holdCritter || critter._runToCallback == jumpIntoCell || cell.getCritters().indexOf(critter) != -1)
				{
					// running toward a cell, jumping into cell, or already in a cell; don't mess with him
				}
				else
				{
					var runToX:Float = 0;
					var runToY:Float = 0;
					if (Std.isOfType(cell, BigCell))
					{
						runToX = cell.getSprite().x - critter._soulSprite.width / 2 + cell.getSprite().width / 2 + distX;
						runToY = cell.getSprite().y - critter._soulSprite.height / 2 + cell.getSprite().height / 2 + distY - 1;
					}
					else
					{
						runToX = cell.getSprite().x + distX;
						runToY = cell.getSprite().y + distY - 1;
					}
					critter.runTo(runToX, runToY, jumpIntoCell);
				}
			}
		}
	}

	function anyClueCrittersUnheld():Bool
	{
		var crittersPerCell:Int = _puzzle._easy ? _puzzle._pegCount : 1;
		for (clueCell in _clueCells)
		{
			if (clueCell.getCritters().length < crittersPerCell)
			{
				return true;
			}
		}
		return false;
	}

	function anyClueCrittersUncubed():Bool
	{
		var crittersPerCell:Int = _puzzle._easy ? _puzzle._pegCount : 1;
		for (clueCell in _clueCells)
		{
			for (critter in clueCell.getAssignedCritters())
			{
				if (!critter.isCubed())
				{
					return true;
				}
			}
		}
		return false;
	}

	public function refillCritters():Void
	{
		var colors:Array<Int> = [];
		for (i in 0..._puzzle._colorCount)
		{
			colors[i] = 0;
		}
		for (critter in _critters)
		{
			if (isInRefillArea(critter))
			{
				colors[critter.getColorIndex()]++;
			}
		}
		for (colorIndex in 0..._puzzle._colorCount)
		{
			for (i in colors[colorIndex]...3)
			{
				var extraCritter:Critter = findExtraCritter(colorIndex);
				if (extraCritter != null)
				{
					var x:Float = (colorIndex * 2 + FlxG.random.float(0.25, 1.75)) * FlxG.width / (_puzzle._colorCount * 2) - 18;
					var y:Float = 400 + FlxG.random.float( -20, 20);
					extraCritter.runTo(x, y);
				}
			}
		}
	}

	public function getPlayerGuess():Array<Int>
	{
		var playerGuess:Array<Int> = [];
		if (_puzzle._easy)
		{
			if (_answerCells[0].getCritters().length < _puzzle._pegCount)
			{
				throw "answer is incomplete";
			}
			for (i in 0..._puzzle._pegCount)
			{
				playerGuess.push(_answerCells[0].getCritters()[i].getColorIndex());
			}
		}
		else {
			for (p in 0..._puzzle._pegCount)
			{
				if (_answerCells[p].getCritters().length == 0)
				{
					throw "answer is incomplete";
				}
				playerGuess.push(_answerCells[p].getCritters()[0].getColorIndex());
			}
		}
		return playerGuess;
	}

	/**
	 * Three outcomes:
	 *
	 * clueIndex == 0-6: answer is incorrect; clue #0-6 is responsible
	 * clueIndex == -1: answer is invalid; violates adjacency rule
	 * null: answer is correct; no mistake
	 */
	public function computeMistake():Mistake
	{
		var playerGuess:Array<Int> = getPlayerGuess();
		if (_puzzle._pegCount == 7)
		{
			var brokeAdjacencyRule = false;
			// adjacency rule
			if (playerGuess[3] == playerGuess[0] ||
			playerGuess[3] == playerGuess[1] ||
			playerGuess[3] == playerGuess[2] ||
			playerGuess[3] == playerGuess[4] ||
			playerGuess[3] == playerGuess[5] ||
			playerGuess[3] == playerGuess[6])
			{
				brokeAdjacencyRule = true;
			}
			if (playerGuess[0] == playerGuess[1] || playerGuess[0] == playerGuess[2])
			{
				brokeAdjacencyRule = true;
			}
			if (playerGuess[4] == playerGuess[1] || playerGuess[4] == playerGuess[6])
			{
				brokeAdjacencyRule = true;
			}
			if (playerGuess[5] == playerGuess[2] || playerGuess[5] == playerGuess[6])
			{
				brokeAdjacencyRule = true;
			}
			if (brokeAdjacencyRule)
			{
				return {clueIndex: -1};
			}
		}
		for (c in 0..._puzzle._clueCount)
		{
			var actualMarkers:Int = 0;
			var playerGuessTmp:Array<Int> = playerGuess.copy();
			var clueGuessTmp:Array<Int> = _puzzle._guesses[c].copy();
			if (!_puzzle._easy)
			{
				// check for exact hits (+10)
				var p:Int = 0;
				while (p < playerGuessTmp.length)
				{
					if (playerGuessTmp[p] == clueGuessTmp[p])
					{
						playerGuessTmp.splice(p, 1);
						clueGuessTmp.splice(p, 1);
						actualMarkers += 10;
					}
					else
					{
						p++;
					}
				}
			}
			{
				var p:Int = 0;
				while (p < playerGuessTmp.length)
				{
					// check for near miss (+1)
					var c:Int = clueGuessTmp.indexOf(playerGuessTmp[p]);
					if (c != -1)
					{
						playerGuessTmp.splice(p, 1);
						clueGuessTmp.splice(c, 1);
						actualMarkers++;
					}
					else
					{
						p++;
					}
				}
			}
			if (actualMarkers != _puzzle._markers[c])
			{
				return {clueIndex: c, expectedMarkers:_puzzle._markers[c], actualMarkers:actualMarkers};
			}
		}
		return null;
	}

	private function addEndGameChest():Chest
	{
		var oldCritter:Critter = findExtraCritter();
		if (oldCritter != null)
		{
			// we remove an old critter for each critter we add, to maintain steady performance
			removeCritter(oldCritter);
			FlxDestroyUtil.destroy(oldCritter);
		}

		var newCritter:RewardCritter = new RewardCritter(this);
		newCritter._rewardTimer = 1000000000;
		addCritter(newCritter, false);
		_rewardCritters.push(newCritter);
		var extraChest:Chest = addChest();
		extraChest._critter = newCritter;
		newCritter.comeToCenter();
		return extraChest;
	}

	/**
	 * 7-peg puzzles can produce large rewards; these are split into multiple chests
	 */
	function splitLargeReward(minReward:Int):Void
	{
		var _finalChest:Chest = getCarriedChest(_mainRewardCritter);
		var newChests:Array<Chest> = [];
		while (_finalChest._reward >= minReward * 2.5 && newChests.length < 7)
		{
			var extraChest:Chest = addEndGameChest();
			extraChest.setReward(minReward);
			_finalChest._reward -= minReward;
			newChests.push(extraChest);
		}
		if (newChests.length == 0)
		{
			// nothing to split
			return;
		}
		var deductions:Array<Float> = [];
		if (minReward >= 1000)
		{
			deductions = [50, 100, 200];
		}
		else if (minReward >= 500)
		{
			deductions = [25, 50, 100];
		}
		else if (minReward >= 200)
		{
			deductions = [10, 25, 50];
		}
		else {
			deductions = [5, 10, 25];
		}
		var toChest:Chest;
		do {
			// move some money from the primary reward chest to a random secondary reward chest.
			// if the secondary reward chest is still smaller, then we continue the process with other random chests.
			toChest = newChests[FlxG.random.int(0, newChests.length - 1)];
			var deductionAmount:Int = Std.int(FlxMath.bound(FlxG.random.getObject(deductions), 0, _finalChest._reward - minReward));
			_finalChest._reward -= deductionAmount;
			toChest._reward += deductionAmount;
		}
		while (_finalChest._reward >= toChest._reward);
	}

	function unlabelAllCritters():Void
	{
		for (critter in labelledCritters.keys())
		{
			labelledCritters.remove(critter);
		}
	}

	public static function initializeSexyState():SexyState<Dynamic>
	{
		var sexyState:SexyState<Dynamic> = SexyState.getSexyState();
		if (PlayerData.difficulty == PlayerData.Difficulty._7Peg)
		{
			if (Std.isOfType(sexyState, AbraSexyState))
			{
				if (PlayerData.pokemonLibido == 1)
				{
					// no boner when libido's zeroed out
				}
				else
				{
					cast(sexyState, AbraSexyState).permaBoner = true;
				}
				var bonusHorniness:Int = 210 - PlayerData.abraReservoir;
				PlayerData.abraReservoir += bonusHorniness;
				PlayerData.reimburseCritterBonus(210 - bonusHorniness);
			}
		}
		LevelIntroDialog.rotateChat();
		LevelIntroDialog.increaseProfReservoirs();
		LevelIntroDialog.rotateProfessors([PlayerData.prevProfPrefix]);
		return sexyState;
	}

	public function isRankChance():Bool
	{
		return _rankChance != null && _rankChance.eligible;
	}

	public function addAllowedHint():Void
	{
		_allowedHintCount++;
		if (PlayerData.finalTrial && PlayerData.level == 2 && Std.isOfType(_pokeWindow, AbraWindow))
		{
			cast(_pokeWindow, AbraWindow).setPassedOut();
		}
	}

	public function eventCrash(args:Array<Dynamic>):Void
	{
		LevelIntroDialog.increaseProfReservoirs();
		LevelIntroDialog.rotateProfessors([PlayerData.prevProfPrefix]);
		LevelIntroDialog.rotateChat();
		FlxG.switchState(FakeCrash.newInstance());
	}
}

typedef UndoOperation =
{
	?oldX:Float,
	?oldY:Float,
	?oldCritterHolder:CritterHolder,
	?newX:Float,
	?newY:Float,
	?newCritterHolder:CritterHolder,
	?critter:Critter,
	?oldHolopadState:Array<Bool>,
	?newHolopadState:Array<Bool>,
	?oldCloudState:CloudState,
	?newCloudState:CloudState
}

enum CloudState
{
	Yes;
	No;
	Maybe;
}

typedef Mistake =
{
	clueIndex:Int,
	?expectedMarkers:Int,
	?actualMarkers:Int
}