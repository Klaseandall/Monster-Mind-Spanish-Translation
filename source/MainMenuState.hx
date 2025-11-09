package;

import demo.SexyDebugState;
import ReservoirMeter.ReservoirStatus;
import credits.CreditsState;
import credits.EndingAnim;
import credits.FakeCrash;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import kludge.FlxSoundKludge;
import kludge.FlxSpriteKludge;
import minigame.MinigameState;
import minigame.scale.ScaleGameState;
import minigame.stair.StairGameState;
import minigame.tug.TugGameState;
import openfl.utils.Object;
import poke.abra.AbraDialog;
import poke.abra.AbraResource;
import poke.abra.AbraSexyState;
import poke.buiz.BuizelResource;
import poke.grim.GrimerResource;
import poke.grov.GrovyleResource;
import poke.hera.HeraResource;
import poke.luca.LucarioDialog;
import poke.luca.LucarioResource;
import poke.rhyd.RhydonResource;
import poke.sand.SandslashResource;
import poke.sexy.SexyState;
import puzzle.PuzzleState;
import puzzle.RankHistoryState;
import puzzle.RankTracker;

/**
 * The main screen where Abra teleports in and you pick your puzzle difficulty
 */
class MainMenuState extends FlxTransitionableState
{
	private static var TUTORIAL_BUTTON_ID = 975482;

	private var _handSprite:FlxSprite;
	private var _abraGroup:WhiteGroup;
	private var _abraBlackGroup:BlackGroup;
	private var _abraBrain:BouncySprite;
	private var _abra0:BouncySprite;
	private var _buttons:FlxTypedGroup<FlxSprite>;
	private var _optionsButton:FlxButton;
	private var _itemsButton:FlxButton;
	private var _mobileTestButton:FlxButton;
	private var _creditsButton:FlxButton;
	private var _blip:FlxSprite;
	private var _time:Float = 0;
	private var _state:Dynamic;
	private var _rotateProfsCheat:Bool = false;
	private var _minigameCheat:MinigameState = null;
	private var _tutorialMode:Bool = false;
	private var _abraBlackTween:FlxTween;

	private var fivePegUnlocked:Bool = false;
	private var sevenPegUnlocked:Bool = false;

	private var _dialogTree:DialogTree;
	private var _dialogger:Dialogger;
	private var lightsManager:LightsManager;
	private var tutorialToggleButton:BouncySprite;

	public function new(?TransIn:TransitionData, ?TransOut:TransitionData)
	{
		super(TransIn, TransOut);
	}

	override public function create():Void
	{
		super.create();
		bgColor = FlxColor.BLACK;

		/*
		 * clear cached bitmap assets to avoid running out of memory
		 */
		FlxG.bitmap.dumpCache();

		Main.overrideFlxGDefaults();

		// Reset "per-puzzle" type variables
		PlayerData.profIndex = -1; // clear profIndex, to avoid hasMet() goofups
		PlayerData.level = 0;
		PlayerData.finalRankHistory = [];
		PlayerData.justFinishedMinigame = false;
		PlayerData.finalTrial = false;

		if (PlayerData.name == null)
		{
			if (PlayerData.puzzleCount[0] <= 2)
			{
				PlayerData.level = PlayerData.puzzleCount[0];
			}
			PlayerData.profIndex = PlayerData.PROF_NAMES.indexOf("Grovyle");
			PlayerData.difficulty = PlayerData.Difficulty.Easy;
			PlayerSave.clearTransientData();
			FlxG.switchState(new PuzzleState());
			return;
		}

		fivePegUnlocked = PlayerData.fivePegUnlocked();
		sevenPegUnlocked = PlayerData.sevenPegUnlocked();
		if (PlayerData.abraChats[0] == 6)
		{
			// just beat the game; don't allow 7-peg puzzles until the epilogue is over
			sevenPegUnlocked = false;
		}

		add(new FlxSprite(0, 0, AssetPaths.title_screen_bg__png));

		_abraGroup = new WhiteGroup();
		add(_abraGroup);

		_abraBlackGroup = new BlackGroup();
		_abraBlackGroup.visible = false;
		add(_abraBlackGroup);

		_abraBrain = new BouncySprite(0, 0, 10, 4, 0);
		_abraBrain.loadGraphic(AssetPaths.title_screen_abra_brain__png);
		_abraBrain.alpha = 0;
		_abraBrain.visible = false;
		add(_abraBrain);

		var sevenPegText:FlxText = new FlxText(325, 60, 100, "7 Pegs", 20);
		sevenPegText.alignment = CENTER;
		sevenPegText.font = AssetPaths.hardpixel__otf;
		sevenPegText.color = OptionsMenuState.WHITE_BLUE;
		sevenPegText.setBorderStyle(OUTLINE, OptionsMenuState.DARK_BLUE, 2);
		_abraBrain.stamp(sevenPegText, 325, 60);

		var mind:BouncySprite = new BouncySprite(0, 0, 10, 4, 0);
		mind.loadGraphic(AssetPaths.title_screen_mind__png);
		add(mind);

		_buttons = new FlxTypedGroup<FlxSprite>();
		add(_buttons);

		_optionsButton = SexyState.newBackButton(options, AssetPaths.options_button__png);
		_optionsButton.x -= 12;
		_optionsButton.y = 6;
		add(_optionsButton);

		_itemsButton = SexyState.newBackButton(items, AssetPaths.items_button__png);
		_itemsButton.x -= 6;
		_itemsButton.y = 32;
		add(_itemsButton);

		#if debug
		_mobileTestButton = SexyState.newBackButton(testBtn, AssetPaths.tablet_button__png, _dialogTree);
		_mobileTestButton.x -= 15;
		_mobileTestButton.y = 75;
		add(_mobileTestButton);
		#end

		if (PlayerData.abraStoryInt == 5 || PlayerData.abraStoryInt == 6)
		{
			_creditsButton = SexyState.newBackButton(credits, AssetPaths.credits_button__png);
			_creditsButton.x = 12;
			_creditsButton.y = 6;
			add(_creditsButton);
		}

		lightsManager = new LightsManager();
		add(lightsManager._spotlights);

		_dialogger = new Dialogger();
		add(_dialogger);

		updateAbraStory();

		ItemDatabase.refillShop(); // refill the shop just in case kecleon leaves/shows up
		initializeButtons();

		lightsManager._spotlights.addSpotlight("tutorial");
		lightsManager._spotlights.growSpotlight("tutorial", tutorialToggleButton.getHitbox());

		_handSprite = new FlxSprite(100, 100);
		CursorUtils.initializeHandSprite(_handSprite, AssetPaths.hands__png);
		_handSprite.setSize(3, 3);
		_handSprite.offset.set(69, 87);

		add(_handSprite);

		if (!PlayerData.abraMainScreenTeleport)
		{
			PlayerData.abraMainScreenTeleport = true;
			_state = state0;
		}
		else {
			_abraGroup._whiteness = 0;
			addAbraSprites();
		}

		if (PlayerData.abraStoryInt == 4)
		{
			// abra is missing
			_abraGroup.visible = false;
			_abraBlackGroup.visible = false;
			_abraBrain.visible = false;
			_state = null;
			sevenPegUnlocked = false;
		}

		add(new CheatCodes(cheatCodeCallback));
	}

	/**
	 * Abra's story proceeds based on the player's money, items, rank, and how
	 * many Pokemon they've met.
	 *
	 * This method checks if it's time for Abra to tell the player something
	 * new on the title screen, like "Hey you're doing great keep it up" or
	 * "Come play some puzzles with me if you get a chance, I need to ask you
	 * something"
	 */
	private function updateAbraStory()
	{
		var totalCharactersMet = getTotalCharactersMet();
		var totalWealth = getTotalWealth();
		var rank = RankTracker.computeAggregateRank();
		if (PlayerData.abraStoryInt <= 2)
		{
			if (totalCharactersMet >= 10 && totalWealth + 600 * rank >= 48000)
			{
				setAbraStory(3);
				return;
			}
		}
		if (PlayerData.abraStoryInt <= 1)
		{
			if (totalCharactersMet >= 9 && totalWealth + 600 * rank >= 20000)
			{
				setAbraStory(2);
				return;
			}
		}
		if (PlayerData.abraStoryInt <= 0)
		{
			setAbraStory(1);
			return;
		}
	}

	/**
	 * Launches some Abra dialog. This occurs three times at the start, middle
	 * and end of the game to progress the overarching story.
	 *
	 * 1 = Tutorial dialog
	 * 2 = Mid-point dialog
	 * 3 = End dialog
	 *
	 * @param	abraStoryInt new story value
	 */
	public function setAbraStory(abraStoryInt:Int)
	{
		PlayerData.abraStoryInt = abraStoryInt;
		var abraDialogFunction:Array<Array<Object>>->Void = null;
		switch (abraStoryInt)
		{
			case 1: abraDialogFunction = AbraDialog.tutorialNotice;
			case 2: abraDialogFunction = AbraDialog.halfwayNotice;
			case 3: abraDialogFunction = AbraDialog.storyNotice;
				PlayerData.abraChats = [2, 3, 4, 5];
		}
		if (abraDialogFunction != null)
		{
			var tree:Array<Array<Object>> = new Array<Array<Object>>();
			abraDialogFunction(tree);
			_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
			_dialogTree.go();
		}
	}

	/**
	 * @return number of Pokemon the player has met, out of the main ten
	 */
	public function getTotalCharactersMet():Int
	{
		var totalCharactersMet:Int = 0;
		for (prefix in ["abra", "buiz", "hera", "grov", "sand", "rhyd", "smea", "magn", "grim", "luca"])
		{
			if (PlayerData.hasMet(prefix))
			{
				totalCharactersMet++;
			}
		}
		return totalCharactersMet;
	}

	/**
	 * @return player's estimated wealth (items + money)
	 */
	public static function getTotalWealth():Int
	{
		var totalWealth:Int = PlayerData.cash;
		for (playerItemIndex in ItemDatabase._playerItemIndexes)
		{
			totalWealth += ItemDatabase._itemTypes[playerItemIndex].basePrice;
		}
		if (ItemDatabase.getPurchasedMysteryBoxCount() > 0)
		{
			// player pays about $33,500 for each mystery box they open
			totalWealth += 33500 * ItemDatabase.getPurchasedMysteryBoxCount();
		}
		return totalWealth;
	}

	public static inline function fadeInFast():TransitionData
	{
		return new TransitionData(TransitionType.FADE, FlxColor.BLACK, 0.3);
	}

	public static inline function fadeOutSlow():TransitionData
	{
		return new TransitionData(TransitionType.FADE, FlxColor.BLACK, 1.2);
	}

	public function dialogTreeCallback(line:String):String
	{
		if (line == "%lights-tutorial%")
		{
			lightsManager.setLightsDim(0.6);
			lightsManager.setSpotlightOn("tutorial");
		}
		if (line == "%lights-on%")
		{
			lightsManager.setLightsOn();
		}
		if (line == "%credits%")
		{
			transOut = fadeInFast();
			var creditsState:CreditsState = new CreditsState(fadeInFast());
			creditsState.backToMainMenu = true;
			FlxG.switchState(creditsState);
		}
		// screenshot feature tests for mobile platform
		if (line == "%crashsoon%")
		{
			FlxG.switchState(FakeCrash.newInstance());
		}
		if (line == "%tablet%")
		{
			if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_STREAMING_PACKAGE)) {

			} else {
				ItemDatabase._playerItemIndexes.push(ItemDatabase.ITEM_STREAMING_PACKAGE);
			}
		}
		if (line == "%zoom%")
		{
			FlxG.switchState(EndingAnim.newInstance());
		}
		return null;
	}

	private function options():Void
	{
		if (DialogTree.isDialogging(_dialogTree))
		{
			return;
		}
		FlxG.switchState(new OptionsMenuState());
	}

	private function items():Void
	{
		if (DialogTree.isDialogging(_dialogTree))
		{
			return;
		}
		FlxG.switchState(new ItemsMenuState());
	}

	private function testBtn():Void
	{
		if (DialogTree.isDialogging(_dialogTree))
		{
			return;
		}
		var tree:Array<Array<Object>> = new Array<Array<Object>>();
		tree[0] = ["#self00#(Test which screenshot issue?)"];
		tree[1] = [10, 20, 30, 40];

		tree[10] = ["Test Credits"];
		tree[11] = ["%zoom%"];

		tree[20] = ["Test Crash"];
		tree[21] = ["%crashsoon%"];

		tree[30] = ["Give Tablet"];
		tree[31] = ["%tablet%"];

		tree[40] = ["No"];

		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();
	}

	private function credits():Void
	{
		if (DialogTree.isDialogging(_dialogTree))
		{
			return;
		}
		var tree:Array<Array<Object>> = new Array<Array<Object>>();
		tree[0] = ["#self00#(Hmm, do I want to watch the credits again?)"];
		tree[1] = [10, 20];

		tree[10] = ["Yes"];
		tree[11] = ["%credits%"];

		tree[20] = ["No"];

		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();
	}

	public function cheatCodeCallback(Code:String)
	{
		var fiveCode:String = Code.substring(Code.length - 5, Code.length);
		#if debug
		if (fiveCode == "CHEAT")
		{
			PlayerData.cheatsEnabled = !PlayerData.cheatsEnabled;
			if (PlayerData.cheatsEnabled)
			{
				FlxSoundKludge.play(AssetPaths.rank_up_00C4__mp3);
			}
			else
			{
				FlxSoundKludge.play(AssetPaths.rank_down_00C5__mp3);
			}
		}
		#end
		if (PlayerData.cheatsEnabled)
		{
			/*
			 * Cheats in the form 'PPLSS'
			 *
			 *   PP: A 2-character pokemon prefix, such as 'ab' for abra or 'bu' for buizel
			 *   L: The desired level; level 0-2 correspond to the sequential puzzles, and level 3
			 *     is the sex scene
			 *   SS: A 2-digit chat index; low values like 00 or 01 are fixed chats which happen
			 *     once. High values like 78 or 81 are random chats which happen frequently.
			 *
			 * GR200: Skip to Grovyle's third puzzle, and use their first fixed chat sequence
			 * SM399: Skip to Smeargle's sex scene, use their current dialog
			 */
			if (fiveCode.substring(0, 2) == "AB"
					|| fiveCode.substring(0, 2) == "BU"
					|| fiveCode.substring(0, 2) == "CH"
					|| fiveCode.substring(0, 2) == "GR"
					|| fiveCode.substring(0, 2) == "SA"
					|| fiveCode.substring(0, 2) == "RH"
					|| fiveCode.substring(0, 2) == "SM"
					|| fiveCode.substring(0, 2) == "MA"
					|| fiveCode.substring(0, 2) == "HE"
					|| fiveCode.substring(0, 2) == "LU"
					|| fiveCode.substring(0, 2) == "ZZ")
			{
				var level:Null<Int> = Std.parseInt(fiveCode.substring(2, 3));
				var scenario:Null<Int> = Std.parseInt(fiveCode.substring(3, 5));
				if (scenario != null && level != null)
				{
					if (fiveCode.substring(0, 2) != "ZZ")
					{
						var prefix:String = "abra";
						if (fiveCode.substring(0, 2) == "AB")
						{
							prefix = "abra";
						}
						else if (fiveCode.substring(0, 2) == "BU")
						{
							prefix = "buiz";
						}
						else if (fiveCode.substring(0, 2) == "CH")
						{
							prefix = "grim";
						}
						else if (fiveCode.substring(0, 2) == "GR")
						{
							prefix = "grov";
						}
						else if (fiveCode.substring(0, 2) == "SA")
						{
							prefix = "sand";
						}
						else if (fiveCode.substring(0, 2) == "RH")
						{
							prefix = "rhyd";
						}
						else if (fiveCode.substring(0, 2) == "SM")
						{
							prefix = "smea";
						}
						else if (fiveCode.substring(0, 2) == "MA")
						{
							prefix = "magn";
						}
						else if (fiveCode.substring(0, 2) == "HE")
						{
							prefix = "hera";
						}
						else if (fiveCode.substring(0, 2) == "LU")
						{
							prefix = "luca";
						}
						var profIndex = PlayerData.PROF_PREFIXES.indexOf(prefix);
						if (prefix == "luca" && scenario == 0)
						{
							PlayerData.luckyProfSchedules.remove(PlayerData.PROF_PREFIXES.indexOf("luca"));
							PlayerData.luckyProfSchedules.insert(0, PlayerData.PROF_PREFIXES.indexOf("luca"));
							LevelIntroDialog.rotateProfessors([], false);
							initializeButtons();
						}
						else
						{
							PlayerData.professors = [profIndex, profIndex, profIndex, profIndex];
						}
						if (scenario != 99)
						{
							if (level <= 2)
							{
								var chats:Dynamic = Reflect.field(PlayerData, prefix + "Chats");
								if (chats.length > PlayerData.CHATLENGTH)
								{
									chats[0] = scenario;
								}
								else
								{
									chats.insert(0, scenario);
								}
							}
							else
							{
								Reflect.setField(PlayerData, prefix + "SexyBeforeChat", scenario);
							}
							if (prefix == "abra")
							{
								if (level == 0)
								{
									if (PlayerData.abra7PegChats.length > PlayerData.CHATLENGTH)
									{
										PlayerData.abra7PegChats[0] = scenario;
									}
									else
									{
										PlayerData.abra7PegChats.insert(0, scenario);
									}
								}
								else
								{
									PlayerData.abra7PegSexyBeforeChat = scenario;
								}
							}
						}
						if (prefix == "hera")
						{
							// get kecleon out here
							ItemDatabase._solvedPuzzle = true;
							ItemDatabase.refillShop();
							PlayerData.professors = [profIndex, profIndex, profIndex, profIndex];
						}
						initializeButtons();
					}
					FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3);
					if (level != 9)
					{
						PlayerData.level = level;
					}
				}
			}
			if (fiveCode.substring(0, 3) == "END")
			{
				var scenario:Null<Int> = Std.parseInt(fiveCode.substring(3, 5));
				/*
				 * END00...03: reset everything to before the ending, try abra's various main menu conversations
				 * END10...16: "swap ending" progression
				 * END17: "swap ending" final animation
				 * END18: "swap ending" credits
				 * END19: "swap ending" epilogue
				 * END20...27: "don't swap ending" progression
				 * END28: "don't swap ending" credits
				 * END29: "don't swap ending" epilogue
				 */
				if (scenario != null)
				{
					if (scenario >= 0 && scenario <= 3)
					{
						// reset everything to before the ending; try abra's various main menu conversations
						setFinalTrialCount(0);
						setAbraStory(scenario);
						if (scenario < 3
								&& PlayerData.abraChats.length > 0
								&& PlayerData.abraChats[0] >= 2
								&& PlayerData.abraChats[0] <= 5)
						{
							// Remove any ending dialog that's queued up
							PlayerData.abraChats = [69];
							PlayerData.abraSexyBeforeChat = 69;
						}
						if (scenario == 3)
						{
							PlayerData.professors[2] = PlayerData.PROF_PREFIXES.indexOf("abra");
							PlayerData.professors[3] = PlayerData.PROF_PREFIXES.indexOf("abra");
							initializeButtons();
							PlayerData.abraChats = [2, 3, 4, 5];
							PlayerData.abraSexyBeforeChat = 69;
						}
						FlxSoundKludge.play(AssetPaths.abra1__mp3, 0.4);
					}
					else if (scenario >= 10 && scenario <= 19)
					{
						// "swap" ending
						PlayerData.abraStoryInt = 3;
						if (scenario == 17)
						{
							PlayerData.successfulSync();
							FlxG.switchState(EndingAnim.newInstance());
						}
						else if (scenario == 18)
						{
							PlayerData.successfulSync();
							FlxG.switchState(new CreditsState());
						}
						else
						{
							if (scenario == 19)
							{
								PlayerData.successfulSync();
							}
							else
							{
								PlayerData.abraChats = [3, 4, 5];
								PlayerData.abraChats.splice(0, Std.int(FlxMath.bound(scenario - 10, 0, 2)));
								PlayerData.abraSexyBeforeChat = 69;
								setFinalTrialCount(Std.int(FlxMath.bound(scenario - 12, 0, 99)));
							}
							PlayerData.professors[2] = PlayerData.PROF_PREFIXES.indexOf("abra");
							PlayerData.professors[3] = PlayerData.PROF_PREFIXES.indexOf("abra");
							initializeButtons();
							FlxSoundKludge.play(AssetPaths.abra3__mp3, 0.4);
						}
					}
					else if (scenario >= 20 && scenario <= 29)
					{
						// "don't swap" ending
						PlayerData.abraStoryInt = 4;
						if (scenario == 28)
						{
							PlayerData.successfulSync();
							FlxG.switchState(new CreditsState());
						}
						else
						{
							if (scenario == 29)
							{
								PlayerData.successfulSync();
							}
							else
							{
								PlayerData.abraChats = [3, 4, 5];
								PlayerData.abraChats.splice(0, Std.int(FlxMath.bound(scenario - 20, 0, 2)));
								PlayerData.abraSexyBeforeChat = 69;
								setFinalTrialCount(Std.int(FlxMath.bound(scenario - 22, 0, 99)));
							}
							PlayerData.professors[2] = PlayerData.PROF_PREFIXES.indexOf("abra");
							PlayerData.professors[3] = PlayerData.PROF_PREFIXES.indexOf("abra");
							initializeButtons();
							FlxSoundKludge.play(AssetPaths.abra2__mp3, 0.4);
						}
					}
				}
			}
			if (fiveCode == "INTR0" || fiveCode == "INTR1" || fiveCode == "INTR2")
			{
				FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3, 0.7);
				PlayerData.name = null;
				PlayerData.preliminaryName = null;
				PlayerData.puzzleCount[0] = Std.parseInt(fiveCode.substring(4, 5));
				FlxG.switchState(new MainMenuState());
			}
			if (fiveCode == "ITEMS")
			{
				FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3, 0.7);
				while (ItemDatabase._shopItems.length > 0)
				{
					var itemIndex:Int = ItemDatabase._shopItems.splice(0, 1)[0]._itemIndex;
					if (itemIndex >= 0)
					{
						ItemDatabase._playerItemIndexes.push(itemIndex);
					}
				}
				while (ItemDatabase._warehouseItemIndexes.length > 0)
				{
					var itemIndex:Int = ItemDatabase._warehouseItemIndexes.splice(0, 1)[0];
					ItemDatabase._playerItemIndexes.push(itemIndex);
				}
				// open enough mystery boxes to grant elekid vibrator
				ItemDatabase._mysteryBoxStatus = Std.int(Math.max(ItemDatabase._mysteryBoxStatus, 25));
				for (itemType in ItemDatabase._itemTypes)
				{
					if (!ItemDatabase.playerHasItem(itemType.index))
					{
						ItemDatabase._playerItemIndexes.push(itemType.index);
					}
				}
			}
			if (fiveCode == "SMELL")
			{
				FlxSoundKludge.play(AssetPaths.grim5__mp3, 0.7);
				PlayerData.cursorSmellTimeRemaining = 15 * 60;
			}
			if (fiveCode == "HAND0" || fiveCode == "HAND1")
			{
				PlayerData.cursorType = (fiveCode == "HAND0") ? "none" : "default";
				PlayerData.cursorSmellTimeRemaining = 0;
				CursorUtils.initializeSystemCursor();
				CursorUtils.initializeHandSprite(_handSprite, AssetPaths.hands__png);
				_handSprite.setSize(3, 3);
				_handSprite.offset.set(69, 87);
				FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3);
			}
			if (fiveCode.substring(0, 3) == "CHT")
			{
				var howMany:Null<Int> = Std.parseInt(fiveCode.substring(3, 5));
				if (howMany != null)
				{
					for (i in 0...howMany)
					{
						PlayerData.appendChatHistory("tfyazeckoj");
					}
					PlayerData.storeChatHistory();
					FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3);
				}
			}
			if (fiveCode == "BUOYS" || fiveCode == "GIRLS")
			{
				FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3, 0.7);
				var male = fiveCode == "BUOYS";
				for (prefix in PlayerData.PROF_PREFIXES)
				{
					Reflect.setField(PlayerData, prefix + "Male", male);
				}
				Main.overrideFlxGDefaults();
				initializeButtons();
				if (_abra0 != null)
				{
					_abra0.loadGraphic(AbraResource.titleScreen);
				}
			}
			if (fiveCode == "MONEY")
			{
				FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3, 0.7);
				PlayerData.cash += 10000;
			}
			if (fiveCode == "HORN0")
			{
				FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3, 0.7);
				for (profIndex in 0...PlayerData.professors.length)
				{
					var fieldName:String = PlayerData.PROF_PREFIXES[PlayerData.professors[profIndex]] + "Reservoir";
					Reflect.setField(PlayerData, fieldName, 0);
				}
				PlayerData.smeaReservoirBank = 0;
				initializeButtons();
			}
			if (fiveCode == "3WHPR")
			{
				FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3, 0.7);
				PlayerSave.nukeData();
				FlxG.switchState(new MainMenuState());
			}
			var sixCode:String = Code.substring(Code.length - 6, Code.length);
			if (StringTools.startsWith(sixCode, "WAIT"))
			{
				var howManyMinutes:Null<Int> = Std.parseInt(sixCode.substring(4, 6));
				if (howManyMinutes != null)
				{
					FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3, 0.7);
					PlayerData.rewardTime += 60 * howManyMinutes;
					if (ItemDatabase._prevRefillTime != 0)
					{
						ItemDatabase._prevRefillTime = ItemDatabase._prevRefillTime - 1000 * 60 * howManyMinutes;
					}
					PlayerData.updateTimePlayed();
				}
			}
			if (fiveCode == "SCALE")
			{
				FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3, 0.7);
				PlayerData.minigameReward = Std.int(Math.max(PlayerData.minigameReward, 500));
				_minigameCheat = new ScaleGameState();
			}
			if (fiveCode == "TUGOW")
			{
				FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3, 0.7);
				PlayerData.minigameReward = Std.int(Math.max(PlayerData.minigameReward, 500));
				_minigameCheat = new TugGameState();
			}
			if (fiveCode == "STAIR")
			{
				FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3, 0.7);
				PlayerData.minigameReward = Std.int(Math.max(PlayerData.minigameReward, 500));
				_minigameCheat = new StairGameState();
			}
			if (fiveCode == "CYCLE")
			{
				FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3, 0.7);
				_rotateProfsCheat = true;
			}
			if (fiveCode == "YRANK")
			{
				FlxG.switchState(new RankHistoryState());
			}
			if (fiveCode == "UNEAT")
			{
				PlayerData.grimEatenItem = -1;
				PlayerData.grimMoneyOwed = 0;
				FlxSoundKludge.play(AssetPaths.grim0__mp3);
			}
		}
	}

	private function setFinalTrialCount(count:Int):Void
	{
		PlayerData.removeFromChatHistory("abra.fixedChats." + AbraDialog.FINAL_CHAT_INDEX);
		for (i in 0...count * 3)
		{
			PlayerData.quickAppendChatHistory("abra.fixedChats." + AbraDialog.FINAL_CHAT_INDEX, false);
		}
	}

	private function state0(elapsed:Float):Void
	{
		if (_time > 0.3)
		{
			_blip = new FlxSprite(0, 0);
			_blip.loadGraphic(AssetPaths.title_screen_blip__png, true, 768, 432);
			_blip.animation.add("play", [0, 1, 2, 2], 30, false);
			_blip.animation.play("play");
			var abraGroup:FlxGroup = _abraGroup.visible ? _abraGroup : _abraBlackGroup;
			abraGroup.add(_blip);

			_state = state1;
		}
	}

	private function state1(elapsed:Float):Void
	{
		if (_blip.animation.curAnim == null || _blip.animation.curAnim.curFrame == 3)
		{
			_blip = FlxDestroyUtil.destroy(_blip);
			var abraGroup:FlxGroup = addAbraSprites();
			FlxSoundKludge.play(AssetPaths.abra0__mp3, 0.4);
			FlxSoundKludge.play(AssetPaths.countdown_go_005c__mp3);

			if (Std.isOfType(abraGroup, WhiteGroup))
			{
				cast(abraGroup, WhiteGroup).addTeleparticles(319, 34, 319 + 97, 34 + 268, 20);
			}

			_state = state2;
		}
	}

	private function addAbraSprites():FlxGroup
	{
		var abraGroup:FlxGroup = _abraGroup.visible ? _abraGroup : _abraBlackGroup;
		_abra0 = new BouncySprite(0, 0, 10, 7, 0);
		_abra0.loadGraphic(AbraResource.titleScreen, true, 768, 432);
		_abra0.animation.add("play", [0, 1], 3);
		_abra0.animation.play("play");
		abraGroup.add(_abra0);
		_abraBrain.synchronize(_abra0);
		_abraBrain.alpha = 1.0;
		FlxTween.tween(_abraBrain, {alpha:0.77}, 1.7, {type:FlxTweenType.PINGPONG, ease:FlxEase.sineInOut});
		var abra1:BouncySprite = new BouncySprite(0, 0, 10, 7, 0.8);
		abra1.loadGraphic(AssetPaths.title_screen_abra1__png);
		abraGroup.add(abra1);
		var abra2:BouncySprite = new BouncySprite(0, 0, 10, 7, 0);
		abra2.loadGraphic(AssetPaths.title_screen_abra2__png);
		abraGroup.add(abra2);
		return abraGroup;
	}

	private function state2(elapsed:Float):Void
	{
		_abraGroup._whiteness = Math.max(0, _abraGroup._whiteness - 5 * elapsed);
		if (_abraGroup._whiteness == 0)
		{
			_state = null;
		}
	}

	private function getAnyBouncyButton():BouncySprite
	{
		for (member in _buttons.members)
		{
			if (member.alive && Std.isOfType(member, BouncySprite))
			{
				return cast(member, BouncySprite);
			}
		}
		return null;
	}

	function initializeButtons():Void
	{
		var age:Float = 0;
		var anyBouncyButton:BouncySprite = getAnyBouncyButton();
		if (anyBouncyButton != null)
		{
			age = anyBouncyButton._age;
		}
		_buttons.kill();
		_buttons.clear();
		_buttons.revive();
		var desc:Array<String> = ["Novice", "3 Pegs", "4 Pegs", "5 Pegs", "Shop"];
		for (i in 0...5)
		{
			var button:BouncySprite = new BouncySprite(0, 0, 8, 3.5, i * 0.2, age);
			var graphic:FlxGraphicAsset = AbraResource.button; // default to abra; just to avoid crashing
			if (i == 3 && !fivePegUnlocked)
			{
				continue;
			}
			if (i == 4)
			{
				if (ItemDatabase.isKecleonPresent())
				{
					graphic = AssetPaths.menu_kecl__png;
				}
				else
				{
					graphic = HeraResource.shopButton;
				}
				button.loadGraphic(graphic, false, 0, 0, true);
			}
			else
			{
				if (_tutorialMode)
				{
					graphic = GrovyleResource.tutorialButton;
					button.loadGraphic(graphic, false, 0, 0, true);
				}
				else
				{
					if (PlayerData.professors[i] == 0)
					{
						graphic = AbraResource.button;
					}
					else if (PlayerData.professors[i] == 1)
					{
						graphic = BuizelResource.button;
					}
					else if (PlayerData.professors[i] == 2)
					{
						graphic = HeraResource.button;
					}
					else if (PlayerData.professors[i] == 3)
					{
						graphic = GrovyleResource.button;
					}
					else if (PlayerData.professors[i] == 4)
					{
						graphic = SandslashResource.button;
					}
					else if (PlayerData.professors[i] == 5)
					{
						if (PlayerData.rhydonCameraUp)
						{
							graphic = RhydonResource.button;
						}
						else
						{
							graphic = RhydonResource.buttonCrotch;
						}
					}
					else if (PlayerData.professors[i] == 6)
					{
						graphic = AssetPaths.menu_smear__png;
					}
					else if (PlayerData.professors[i] == 8)
					{
						graphic = AssetPaths.menu_magn__png;
					}
					else if (PlayerData.professors[i] == 9)
					{
						graphic = GrimerResource.button;
					}
					else if (PlayerData.professors[i] == 10)
					{
						graphic = LucarioResource.button;
					}
					button.loadGraphic(graphic, true, 118, 173, true);
					if (!PlayerData.hasMet(PlayerData.PROF_PREFIXES[PlayerData.professors[i]]))
					{
						button.animation.frameIndex = 1;
					}
				}
			}
			{
				var text:FlxText = new FlxText(0, 0, button.width, desc[i], 20);
				text.alignment = "center";
				text.font = AssetPaths.hardpixel__otf;
				button.stamp(text);
			}
			button.ID = i;
			if (fivePegUnlocked)
			{
				button.x = FlxG.width * 0.1 + FlxG.width * 0.2 * i - button.width / 2;
			}
			else
			{
				button.x = FlxG.width * 0.17 + FlxG.width * 0.22 * i - button.width / 2;
				if (i == 4)
				{
					button.x -= FlxG.width * 0.22;
				}
			}
			button.y = FlxG.height - button.height - 10;
			_buttons.add(button);

			if (i == 4 && ItemDatabase._newItems)
			{
				var newItems:FlxSprite = new BouncySprite(button.x, button.y, button._bounceAmount, button._bounceDuration, button._bouncePhase, button._age);
				newItems.loadGraphic(AssetPaths.shop_new__png, true, 118, 207);
				newItems.animation.add("default", AnimTools.blinkyAnimation([0, 1, 2]), 3);
				newItems.animation.play("default");
				_buttons.add(newItems);
			}

			if (i < PlayerData.professors.length)
			{
				var prefix:String = PlayerData.PROF_PREFIXES[PlayerData.professors[i]];
				if (_tutorialMode)
				{
					prefix = "grov";
				}
				var reservoir:Int = Reflect.field(PlayerData, prefix + "Reservoir");
				var diminishmentFactor:Float = 0.5; // 1.0 = linear, 2.0 = emptier, 0.5 = fuller
				if (prefix == "sand")
				{
					diminishmentFactor = 0.2;
				}
				else if (prefix == "smea")
				{
					diminishmentFactor = 1.2;
				}
				var percent:Float = Math.pow(reservoir / 210, diminishmentFactor);
				var reservoirStatus:ReservoirStatus = ReservoirStatus.Green;
				if (reservoir >= 210)
				{
					reservoirStatus = ReservoirStatus.Emergency;
				}
				else if (reservoir >= 90)
				{
					reservoirStatus = ReservoirStatus.Red;
				}
				else if (reservoir >= 30)
				{
					reservoirStatus = ReservoirStatus.Yellow;
				}
				if (prefix == "smea")
				{
					if (reservoir < 60)
					{
						reservoirStatus = ReservoirStatus.Green;
					}
					else if (reservoir < 120)
					{
						reservoirStatus = ReservoirStatus.Yellow;
					}
				}
				if (prefix == "magn")
				{
					percent = 0;
					reservoirStatus = ReservoirStatus.Green;
				}
				_buttons.add(new ReservoirMeter(button, percent, reservoirStatus));
			}
		}
		{
			tutorialToggleButton = new BouncySprite(0, 0, 8, 3.5, getAnyBouncyButton()._bouncePhase - 0.2, age);
			if (_tutorialMode)
			{
				tutorialToggleButton.loadGraphic(AbraResource.tutorialOffButton);
			}
			else {
				tutorialToggleButton.loadGraphic(GrovyleResource.tutorialOnButton);
			}
			tutorialToggleButton.ID = TUTORIAL_BUTTON_ID;
			tutorialToggleButton.x = _buttons.getFirstAlive().x;
			tutorialToggleButton.y = _buttons.getFirstAlive().y - tutorialToggleButton.height - 14;
			_buttons.add(tutorialToggleButton);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		PlayerData.updateTimePlayed();
		if (FlxG.mouse.justPressed)
		{
			PlayerData.updateCursorVisible();
		}
		_time += elapsed;

		if (PlayerData.name == null)
		{
			// redirecting to intro...
			return;
		}

		#if debug

		if (FlxG.keys.justPressed.F5) {
			FlxG.switchState(new SexyDebugState());
		}

		#end

		_handSprite.setPosition(FlxG.mouse.x - _handSprite.width / 2, FlxG.mouse.y - _handSprite.height / 2);

		if (sevenPegUnlocked)
		{
			var brainDist:Float = FlxMath.vectorLength(FlxG.mouse.x - 372, FlxG.mouse.y - 81 + _abraBrain.offset.y);
			if (brainDist < 50 && _abraGroup.visible)
			{
				for (member in _abraGroup.members)
				{
					_abraBlackGroup.add(member);
				}
				_abraGroup.clear();
				_abraBlackGroup.visible = true;
				_abraBrain.visible = true;
				_abraGroup.visible = false;
				_abraBlackGroup._blackness = 0;
				FlxTweenUtil.retween(_abraBlackTween, _abraBlackGroup, {_blackness:0.9}, 0.5, {ease:FlxEase.circOut});
			}
			else if (brainDist > 60 && !_abraGroup.visible)
			{
				for (member in _abraBlackGroup.members)
				{
					_abraGroup.add(member);
				}
				_abraBlackGroup.clear();
				_abraGroup.visible = true;
				_abraBlackGroup.visible = false;
				_abraBrain.visible = false;
			}
			if (FlxG.mouse.justPressed && !_dialogger._handledClick && _abraBlackGroup.visible)
			{
				// switch to 7-peg state
				PlayerData.difficulty = PlayerData.Difficulty._7Peg;
				PlayerData.profIndex = PlayerData.PROF_NAMES.indexOf("Abra");
				if (PlayerData.level >= 1)
				{
					var sexyState:AbraSexyState = new AbraSexyState();
					cast(sexyState, AbraSexyState).permaBoner = true;
					FlxG.switchState(sexyState);
				}
				else
				{
					FlxG.switchState(new PuzzleState());
				}
			}
		}

		if (FlxG.mouse.justPressed && !_dialogger._handledClick)
		{
			var clickedButton:FlxSprite = null;
			for (button in _buttons.members)
			{
				if (FlxSpriteKludge.overlap(_handSprite, button) && button.visible)
				{
					clickedButton = button;
					break;
				}
			}
			if (clickedButton != null)
			{
				if (clickedButton.ID >= 0 && clickedButton.ID <= 3)
				{
					PlayerData.difficulty = [PlayerData.Difficulty.Easy, PlayerData.Difficulty._3Peg, PlayerData.Difficulty._4Peg, PlayerData.Difficulty._5Peg][clickedButton.ID];

					if (LucarioDialog.isLucariosFirstTime() && PlayerData.hasMet(LucarioDialog.getLucarioReplacementProfPrefix()))
					{
						PlayerData.profIndex = PlayerData.PROF_PREFIXES.indexOf("luca");
					}
					else
					{
						PlayerData.profIndex = PlayerData.professors[PlayerData.difficulty.getIndex()];
					}

					if (_rotateProfsCheat)
					{
						// don't start level; just rotate the professors
						LevelIntroDialog.increaseProfReservoirs();
						LevelIntroDialog.rotateProfessors([PlayerData.prevProfPrefix]);
						ItemDatabase._solvedPuzzle = true;
						ItemDatabase.refillShop();
						initializeButtons();
						_rotateProfsCheat = false;
						FlxSoundKludge.play(AssetPaths.beep_0065__mp3);
					}
					else if (_tutorialMode)
					{
						// start tutorial
						PlayerData.profIndex = PlayerData.PROF_NAMES.indexOf("Grovyle");
						var puzzleState:PuzzleState = new PuzzleState();
						if (clickedButton.ID == 0)
						{
							puzzleState._tutorial = TutorialDialog.tutorialNovice;
						}
						else if (clickedButton.ID == 1)
						{
							puzzleState._tutorial = TutorialDialog.tutorial3Peg;
						}
						else if (clickedButton.ID == 2)
						{
							puzzleState._tutorial = TutorialDialog.tutorial4Peg;
						}
						else
						{
							puzzleState._tutorial = TutorialDialog.tutorial5Peg;
							if (PlayerData.isAbraNice())
							{
								if (PlayerData.level > 1)
								{
									PlayerData.profIndex = PlayerData.PROF_NAMES.indexOf("Abra");
								}
							}
							else
							{
								if (PlayerData.level > 0)
								{
									PlayerData.profIndex = PlayerData.PROF_NAMES.indexOf("Abra");
								}
							}
						}
						FlxG.switchState(puzzleState);
					}
					else
					{
						if (_minigameCheat != null)
						{
							// start minigame
							FlxG.switchState(_minigameCheat);
						}
						else if (PlayerData.level >= 3)
						{
							// start sexystate?
							if (PlayerData.sfw)
							{
								// skip sexystate; sfw mode
								transOut = MainMenuState.fadeOutSlow();
								FlxG.switchState(new MainMenuState(MainMenuState.fadeInFast()));
							}
							else
							{
								// start sexystate
								FlxG.switchState(SexyState.getSexyState());
							}
						}
						else
						{
							// start regular level
							PlayerData.finalTrial = isFinalTrial(PlayerData.profIndex);
							FlxG.switchState(new PuzzleState());
						}
					}
				}
				else if (clickedButton.ID == 4)
				{
					FlxG.switchState(new ShopState());
					return;
				}
				else if (clickedButton.ID == TUTORIAL_BUTTON_ID)
				{
					FlxSoundKludge.play(AssetPaths.beep_0065__mp3);
					_tutorialMode = !_tutorialMode;
					initializeButtons();
				}
			}
		}

		if (_state != null)
		{
			_state(elapsed);
		}
	}

	private function isFinalTrial(profIndex:Int=-1)
	{
		if (profIndex != -1 && profIndex != PlayerData.PROF_NAMES.indexOf("Abra"))
		{
			return false;
		}
		return PlayerData.abraChats.length >= 1 && PlayerData.abraChats[0] == AbraDialog.FINAL_CHAT_INDEX;
	}

	override public function destroy():Void
	{
		super.destroy();

		_handSprite = FlxDestroyUtil.destroy(_handSprite);
		_abraGroup = FlxDestroyUtil.destroy(_abraGroup);
		_abraBlackGroup = FlxDestroyUtil.destroy(_abraBlackGroup);
		_abraBrain = FlxDestroyUtil.destroy(_abraBrain);
		_abra0 = FlxDestroyUtil.destroy(_abra0);
		_buttons = FlxDestroyUtil.destroy(_buttons);
		_optionsButton = FlxDestroyUtil.destroy(_optionsButton);
		_itemsButton = FlxDestroyUtil.destroy(_itemsButton);
		_creditsButton = FlxDestroyUtil.destroy(_creditsButton);
		_blip = FlxDestroyUtil.destroy(_blip);
		_state = null;
		_minigameCheat = null;
		_abraBlackTween = FlxTweenUtil.destroy(_abraBlackTween);
		_dialogTree = FlxDestroyUtil.destroy(_dialogTree);
		_dialogger = FlxDestroyUtil.destroy(_dialogger);
		lightsManager = FlxDestroyUtil.destroy(lightsManager);
		tutorialToggleButton = FlxDestroyUtil.destroy(tutorialToggleButton);
	}
}