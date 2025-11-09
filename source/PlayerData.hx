package;

import flixel.FlxG;
import flixel.math.FlxMath;
import minigame.scale.ScaleGameState;
import minigame.stair.StairGameState;
import minigame.tug.TugGameState;

/**
 * Stores all data related to the player's session. This includes permanent
 * data like which conversations they've had and how much money they have,
 * but also transient data like how long it's been since they last touched
 * the mouse
 */
class PlayerData
{
	public static inline var CHATLENGTH = 2;
	public static var PROF_PREFIXES = ["abra", "buiz", "hera", "grov", "sand", "rhyd", "smea", "kecl", "magn", "grim", "luca"];
	public static var PROF_NAMES = ["Abra", "Buizel", "Heracross", "Grovyle", "Sandslash", "Rhydon", "Smeargle", "Kecleon", "Magnezone", "Grimer", "Lucario"];
	public static var MINIGAME_CLASSES:Array<Class<Dynamic>> = [ScaleGameState, StairGameState, TugGameState];
	public static var DEN_SEX_RESILIENCE:Array<Float> = [
				1.60, // abra
				1.40, // buiz
				3.00, // hera
				1.90, // grov
				8.00, // sand
				3.40, // rhyd
				1.30, // smea
				2.60, // kecl
				3.60, // magn
				1.80, // grim
				4.00, // luca
			];
	public static var PROF_DIALOG_CLASS:Array<String> = ["poke.abra.AbraDialog", "poke.buiz.BuizelDialog", "poke.hera.HeraDialog", "poke.grov.GrovyleDialog", "poke.sand.SandslashDialog", "poke.rhyd.RhydonDialog", "poke.smea.SmeargleDialog", null, "poke.magn.MagnDialog", "poke.grim.GrimerDialog", "poke.luca.LucarioDialog"];
	public static var MINIGAME_DESCRIPTIONS:Array<String> = ["that bug balancing game", "that stair climbing game", "that tug-of-war game"];
	public static var DEN_MINIGAME_NERF = 0.20; // den minigames are only worth a fraction of the usual amount

	public static var DEN_MAX_REWARD = 600;

	/*
	 * -1: No save slot; needs to be initialized
	 * 0, 1, 2: Save slot #0, #1, #2
	 */
	public static var saveSlot:Int = -1;

	public static var recentPuzzleIndexes:Array<Int> = []; // most recent 50 puzzles; we don't want back-to-back identical puzzles
	public static var difficulty:Difficulty = Easy;
	public static var rewardTime:Float = 0; // after a minute of time, we reward the player in different ways
	public static var justFinishedMinigame:Bool = false; // some dialog changes subtly if the player just finished a minigame

	public static var level:Int = 0;
	public static var cash:Int = 0;
	public static var timePlayed:Float = 0;
	public static var pokeVideos:Array<PokeVideo> = [];
	public static var videoStatus:VideoStatus = Empty; // Do the videos have poke-orgasms, are they clean, or absent?
	public static var videoCount:Int = 0; // How many videos has the player recorded, ever?
	public static var startedTaping:Bool = false;
	public static var startedMagnezone:Bool = false;
	public static var magnButtPlug:Int = 0; // Which phase we're in in the "butt plug" chat sequence
	public static var sandPhone:Int = 0; // Which phase we're in in the "sandslash phone" chat sequence
	public static var keclStoreChat:Int = 0; // Which phase we're in in the "kecleon store" chat sequence
	public static var rhydonCameraUp:Bool = false;
	public static var profIndex:Int = -1; // Which Pokemon is the player playing with? 0=abra, 1=buizel, etc...

	/*
	 * Bugs will bring you presents as you play. Those presents get appended to
	 * this array, sort of like tossing coins in a bag. Periodically those
	 * coins are popped out of the bag and given to the player when they're
	 * stuck on a puzzle.
	 */
	public static var critterBonus:Array<Int> = [];
	public static var reservoirReward:Int = 0;
	public static var minigameReward:Int = 0;
	public static var luckyProfReward:Int = 0;

	public static var minigameQueue:Array<Int> = [];
	public static var scaleGamePuzzleDifficulty:Float = 0.35; // The difficulty of the scale game puzzles. They range from easy 3-bug puzzles to hard 6-bug puzzles
	/*
	 * The difficulty of the scale game opponents. Abra is always abra, but
	 * they won't show up unless you keep winning. Even if you're solving
	 * puzzles with Abra and this minigame comes up, Abra will offer to let you
	 * play a different opponent
	 */
	public static var scaleGameOpponentDifficulty:Float = 0.35;

	public static var denMinigame:Int = -1;
	public static var denVisitCount:Int = 0;

	public static var nextDenProf:Int = -1; // after this set of puzzles, is there a pokemon which will randomly show up in the den? (transient value; not saved)
	public static var denProf:Int = -1; // which pokemon is currently in the den? (transient value; not saved)
	public static var denCost:Int = 120; // transient value; not saved
	public static var denSpoogeCount:Int = 0; // transient value; not saved
	public static var denGameCount:Int = 0; // transient value; not saved
	public static var denSexCount:Int = 0; // transient value; not saved
	public static var denTotalReward:Float = 0; // transient value; not saved
	public static var playerIsInDen:Bool = false; // transient value; not saved

	/**
	 * Male: he/him, boy, penis, etc...
	 * Female: she/her, girl, vagina, etc...
	 * Complicated: they/theirs, someone, genitals, etc...
	 */
	public static var gender:Gender;
	public static var sexualPreference:SexualPreference;
	public static var sexualPreferenceLabel:SexualPreferenceLabel;
	public static var preliminaryName:String; // you can tell Grovyle a name before he asks for your name, and he might reference this later
	public static var name:String;

	public static var cursorType:String;
	public static var cursorFillColor:Int = 0; // internal color
	public static var cursorLineColor:Int = 0; // outline color
	public static var cursorMaxAlpha:Float = 0;
	public static var cursorMinAlpha:Float = 0;
	public static var cursorInsulated:Bool = false;
	public static var cursorSmellTimeRemaining:Float = 0; // number of milliseconds remaining until cursor doesn't smell anymore

	public static var chatHistory:Array<String>;
	public static var chatHistoryTmp:Array<String>;

	public static var abraSexyRecords:Array<Float>;
	public static var abra7PegChats:Array<Int>;
	public static var abraChats:Array<Int>;
	public static var abra7PegSexyBeforeChat:Int = 0;
	public static var abraSexyBeforeChat:Int = 0;
	public static var abraSexyAfterChat:Int = 0;
	public static var abraMale:Bool = false;
	public static inline var abraDefaultMale:Bool = false;
	public static var abraReservoir:Int = 0; // A reservoir of 0-210 libido points, which goes towards giving +30/+90/+210 boosts to the sexy minigames
	public static var abraToyReservoir:Int = 0; // A reservoir of 0-180 libido points, which goes towards giving +60/+120/+180 boosts to the toy minigames
	public static var abraBeadCapacity:Int = 0;
	public static var abraMainScreenTeleport:Bool = false; // Has Abra teleported onto the main screen and made noise?
	/*
	 * 0: hasn't started
	 * 1: has said "here's what to do next"
	 * 2: has said "you're on your way"
	 * 3: progressing down "swap path"
	 * 4: progressing down "don't swap path"
	 * 5: game over; swapped
	 * 6: game over; didn't swap
	 */
	public static var abraStoryInt:Int = 0;
	public static var finalTrial:Bool = false; // is the player currently attempting to swap?
	public static var finalRankHistory:Array<Int> = []; // ranks for final swap attempt

	public static var buizSexyRecords:Array<Float>;
	public static var buizChats:Array<Int>;
	public static var buizSexyBeforeChat: Dynamic;
	public static var buizSexyAfterChat: Dynamic;
	public static var buizMale:Bool = false;
	public static inline var buizDefaultMale:Bool = false;
	public static var buizReservoir:Int = 0;
	public static var buizToyReservoir:Int = 0;

	public static var grovSexyRecords:Array<Float>;
	public static var grovChats:Array<Int>;
	public static var grovSexyBeforeChat: Dynamic;
	public static var grovSexyAfterChat: Dynamic;
	public static var grovMale:Bool = false;
	public static inline var grovDefaultMale:Bool = false;
	public static var grovReservoir:Int = 0;
	public static var grovToyReservoir:Int = 0;

	public static var sandSexyRecords:Array<Float>;
	public static var sandChats:Array<Int>;
	public static var sandSexyBeforeChat: Dynamic;
	public static var sandSexyAfterChat: Dynamic;
	public static var sandMale:Bool = false;
	public static inline var sandDefaultMale:Bool = true;
	public static var sandReservoir:Int = 0;
	public static var sandToyReservoir:Int = 0;

	public static var rhydSexyRecords:Array<Float>;
	public static var rhydChats:Array<Int>;
	public static var rhydSexyBeforeChat: Dynamic;
	public static var rhydSexyAfterChat: Dynamic;
	public static var rhydMale:Bool = false;
	public static inline var rhydDefaultMale:Bool = true;
	public static var rhydReservoir:Int = 0;
	public static var rhydToyReservoir:Int = 0;
	public static var rhydGift:Int = 0; // 0: hasn't purchased gift; 1: gift has been purchased; 2: gift has been received

	public static var smeaSexyRecords:Array<Float>;
	public static var smeaChats:Array<Int>;
	public static var smeaSexyBeforeChat: Dynamic;
	public static var smeaSexyAfterChat: Dynamic;
	public static var smeaMale:Bool = false;
	public static inline var smeaDefaultMale:Bool = true;
	public static var smeaReservoir:Int = 0;
	public static var smeaToyReservoir:Int = 0;
	public static var smeaReservoirBank:Int = 0;
	public static var smeaToyReservoirBank:Int = 0;

	public static var keclMale:Bool = false;
	public static inline var keclDefaultMale:Bool = true;
	public static var keclGift:Int = 0; // 0: hasn't purchased gift; 1: gift has been purchased; 2: gift has been received

	public static var magnSexyRecords:Array<Float>;
	public static var magnChats:Array<Int>;
	public static var magnSexyBeforeChat: Dynamic;
	public static var magnSexyAfterChat: Dynamic;
	public static var magnMale:Bool = false;
	public static inline var magnDefaultMale:Bool = false;
	public static var magnReservoir:Int = 0;
	public static var magnToyReservoir:Int = 0;
	public static var magnGift:Int = 0; // 0: hasn't purchased gift; 1: gift has been purchased; 2: gift has been received

	public static var grimSexyRecords:Array<Float>;
	public static var grimChats:Array<Int>;
	public static var grimSexyBeforeChat: Dynamic;
	public static var grimSexyAfterChat: Dynamic;
	public static var grimMale:Bool = false;
	public static inline var grimDefaultMale:Bool = false;
	public static var grimReservoir:Int = 0;
	public static var grimToyReservoir:Int = 0;
	public static var grimTouched:Bool = false; // has the player touched grimer?

	/*
	 * It's understood that the player undergoes a linear progression of the
	 * game -- meeting more and more pokemon, buying up the store's items, then
	 * buying up some mystery boxes.
	 *
	 * Losing items would have bad implications for save files (passwords
	 * specifically) because we might need to store the state where a player
	 * has bought all the items, and bought 6 mystery boxes, but then had two
	 * of their items eaten -- so their inventory technically isn't full.
	 *
	 * To prevent this, we don't actually remove grimer's eaten items from the
	 * player's inventory -- we just store their eaten item in this
	 * "grimEatenItem" variable. If a player saves and loads their game with a
	 * password after feeding grimer, they'll get their item back. This is
	 * better than the implications of needing to store an extra 3-4 bits of
	 * item information just for some crazy edge case.
	 */
	public static var grimEatenItem:Int = -1; // which item did grimer eat?
	public static var grimMoneyOwed:Int = 0; // grimer ate something expensive; he needs to pay the player

	public static var heraSexyRecords:Array<Float>;
	public static var heraChats:Array<Int>;
	public static var heraSexyBeforeChat: Dynamic;
	public static var heraSexyAfterChat: Dynamic;
	public static var heraMale:Bool = false;
	public static inline var heraDefaultMale:Bool = true;
	public static var heraReservoir:Int = 0;
	public static var heraToyReservoir:Int = 0;

	public static var lucaSexyRecords:Array<Float>;
	public static var lucaChats:Array<Int>;
	public static var lucaSexyBeforeChat: Dynamic;
	public static var lucaSexyAfterChat: Dynamic;
	public static var lucaMale:Bool = false;
	public static inline var lucaDefaultMale:Bool = false;
	public static var lucaReservoir:Int = 0;
	public static var lucaToyReservoir:Int = 0;

	public static var professors:Array<Int>;
	public static var prevProfPrefix:String;
	public static var rankHistory:Array<Int> = [];
	public static var rankHistoryLog:Array<String>; // a human-readable rank history, for debug purposes
	public static var puzzleCount:Array<Int>;
	public static var minigameCount:Array<Int>;
	public static var luckyProfSchedules:Array<Int> = [];

	public static var clickTime:Float = 0;
	public static var rankChance:Bool = false; // has the player had a "rank chance" event before?
	public static var rankDefend:Bool = false; // has the player had a "rank defend" event before?

	public static var pokemonLibido:Int = 4; // [1-7]
	public static var pegActivity:Int = 4; // [1-7]
	public static var promptSilverKey:Prompt = Prompt.AlwaysNo;
	public static var promptGoldKey:Prompt = Prompt.AlwaysNo;
	public static var promptDiamondKey:Prompt = Prompt.AlwaysNo;
	public static var disabledPegColors:Array<String> = [];

	public static var cheatsEnabled:Bool = false;
	public static var profanity:Bool = true;
	/**
	 * If the detail level is lowered, the game tries to conserve memory by
	 * spawning fewer sprites and purging the image cache more frequently
	 */
	public static var detailLevel:DetailLevel = DetailLevel.Max;
	public static var sfw:Bool = false;

	#if reflection
	// Workaround for Haxe #6630; Reflect.field on public static inline return null.
	// https://github.com/HaxeFoundation/haxe/issues/6630
	private static var REFLECTION_WORKAROUND:Map<String, Bool> = [
			"abraDefaultMale" => PlayerData.abraDefaultMale,
			"buizDefaultMale" => PlayerData.buizDefaultMale,
			"grovDefaultMale" => PlayerData.grovDefaultMale,
			"sandDefaultMale" => PlayerData.sandDefaultMale,
			"rhydDefaultMale" => PlayerData.rhydDefaultMale,
			"smeaDefaultMale" => PlayerData.smeaDefaultMale,
			"keclDefaultMale" => PlayerData.keclDefaultMale,
			"magnDefaultMale" => PlayerData.magnDefaultMale,
			"grimDefaultMale" => PlayerData.grimDefaultMale,
			"heraDefaultMale" => PlayerData.heraDefaultMale,
			"lucaDefaultMale" => PlayerData.lucaDefaultMale,
	];
	#end

	public static function isPlayerDoingStuff():Bool
	{
		return clickTime != 0 && (clickTime > MmTools.time() - 180 * 1000);
	}

	public static function updateCursorVisible()
	{
		/*
		 * reinitialize the system cursor; right-clicking in WaterFox makes
		 * the cursor visible, but we want it to stay invisible
		 */
		CursorUtils.initializeSystemCursor();
	}

	/**
	 * As the player plays the game, they're given money in a bunch of ways.
	 *
	 * For every 60 minutes they play, they should get...
	 * 1. About $1,200 in random reward chests which bugs bring during puzzles
	 * 2. About $1,000 from Heracross, for selling porn videos
	 * 3. About $3,600 from solving puzzles, if they're average at them
	 * 4. About $1,200 from minigames
	 *
	 * In total this works out to about $6,000/hr, although it depends on how
	 * skilled they are at the different facets of the game. There's no real
	 * ceiling, and I imagine people could earn $12,000 if they were good at
	 * puzzles and minigames, or $50,000 if they just cheated and used a
	 * solver.
	 *
	 * There is a bare minimum of about $2,000/hr no matter how bad you are,
	 * which is important. You're given money for losing minigames, and you're
	 * given some money even if you're bad at the sex parts. You're given money
	 * for losing minigames. All in all it's not a lot, but it guarantees
	 * people will eventually beat the game even if they're absolutely awful at
	 * it.
	 */
	public static function updateTimePlayed()
	{
		if (FlxG.mouse.justPressed)
		{
			// if someone's AFK for an hour, or skips their clock ahead, we only count 3 minutes of that hour
			var oldTimePlayed = timePlayed;
			var amount:Float = FlxMath.bound((MmTools.time() - clickTime) / 1000, 0, 180);
			timePlayed += amount;
			rewardTime += amount;
			clickTime = MmTools.time();
		}
		if (rewardTime > 60)
		{
			var skipReservoirRewardChance:Null<Float> = [1 => 0.80, 2 => 0.75, 3 => 0.45][pokemonLibido];
			if (skipReservoirRewardChance == null) skipReservoirRewardChance = 0;
			var skipCritterBonusChance:Null<Float> = [7 => 0.70, 6 => 0.50, 5 => 0.30][pokemonLibido];
			if (skipCritterBonusChance == null) skipCritterBonusChance = 0;
			while (rewardTime > 60)
			{
				rewardTime -= 60;
				if (FlxG.random.bool(skipCritterBonusChance))
				{
					// skip; critter bonus is applied to reservoir
					reservoirReward += 20;
				}
				else
				{
					appendCritterBonus(FlxG.random.getObject([5, 10, 20, 50], [.2, .3, .3, .2])); // average 20 per minute
				}

				if (FlxG.random.bool(skipReservoirRewardChance))
				{
					// skip; reservoir reward is applied to critter
					appendCritterBonus(10);
				}
				else
				{
					// average 10 per minute... but, this is multiplied if they're good at sexy minigames, so really 20
					reservoirReward += 10;
				}

				minigameReward += 20;
				luckyProfReward += 1;

				cursorSmellTimeRemaining = Math.max(cursorSmellTimeRemaining - 60, 0);
			}
		}
	}

	/**
	 * Add more money to the random chests which appear during the puzzles.
	 *
	 * @param	amount amount of money to add
	 */
	private static function appendCritterBonus(amount:Int)
	{
		if (critterBonus.length < 50)
		{
			critterBonus.push(amount);
		}
		else
		{
			// critter bonus is getting too long; just increment an existing entry
			critterBonus[FlxG.random.int(0, critterBonus.length - 1)] += amount;
		}
	}

	public static function siphonCritterBonus(percent:Float):Int
	{
		var targetLength:Int = Std.int(critterBonus.length * percent);
		var bonus:Int = 0;
		while (critterBonus.length > targetLength)
		{
			bonus += critterBonus.pop();
		}
		return bonus;
	}

	public static function siphonReservoirReward(percent:Float):Int
	{
		var amount:Int = Std.int(reservoirReward * percent / 5) * 5;
		reservoirReward -= amount;
		return amount;
	}

	/**
	 * Adds another entry to the chatHistoryTmp, which might be stored or discarded later
	 */
	public static function appendChatHistory(str:String)
	{
		if (chatHistoryTmp == null)
		{
			chatHistoryTmp = [];
		}
		chatHistoryTmp.push(str);
	}

	/**
	 * Adds an entry to the chatHistory immediately, replacing any entries already there
	 */
	public static function quickAppendChatHistory(str:String, unique:Bool = true):Void
	{
		if (unique)
		{
			if (chatHistory.indexOf(str) != -1)
			{
				chatHistory.remove(str);
			}
		}
		chatHistory.push(str);
		chatHistory.splice(0, chatHistory.length - 2000);
	}

	/**
	 * Discards the built-up chatHistoryTmp
	 */
	public static function discardChatHistory()
	{
		chatHistoryTmp = null;
	}

	/**
	 * Appends the built-up chatHistoryTmp to the permanent chatHistory
	 */
	public static function storeChatHistory()
	{
		if (chatHistoryTmp != null && chatHistoryTmp.length > 0)
		{
			chatHistory = chatHistory.concat(chatHistoryTmp);
			chatHistory.splice(0, chatHistory.length - 2000);
		}
		chatHistoryTmp = null;
	}

	public static function recentChatTime(string:String):Int
	{
		var index:Int = chatHistory.lastIndexOf(string);
		if (index == -1)
		{
			return 10000;
		}
		else {
			return chatHistory.length - index + 1;
		}
	}

	/**
	 * Adds money to the amount the player receives in periodic random chests.
	 * ...This is a good way to indirectly compensate them for things which
	 * would otherwise drain money from people who are just having fun.
	 *
	 * @param	reward The amount of money to add into chests
	 */
	public static function reimburseCritterBonus(reward:Int)
	{
		while (reward > 60)
		{
			appendCritterBonus(50);
			reward -= 50;
		}
		while (reward > 30)
		{
			appendCritterBonus(20);
			reward -= 20;
		}
		while (reward > 15)
		{
			appendCritterBonus(10);
			reward -= 10;
		}
		while (reward > 2)
		{
			appendCritterBonus(5);
			reward -= 5;
		}
	}

	public static function addPokeVideo(video:PokeVideo):Void
	{
		videoCount++;
		pokeVideos.push(video);
		pokeVideos.splice(0, pokeVideos.length - 100);
	}

	public static function getPokeVideoReward():Int
	{
		var total:Float = 0;
		for (video in pokeVideos)
		{
			total += video.reward;
		}
		return Math.round(total / 5) * 5;
	}

	public static function payVideos():Void
	{
		cash += getPokeVideoReward();
		pokeVideos.splice(0, pokeVideos.length);
		videoStatus = VideoStatus.Empty;
	}

	public static function getDifficultyInt()
	{
		switch (difficulty)
		{
			case Easy: return 0;
			case _3Peg: return 1;
			case _4Peg: return 2;
			case _5Peg: return 3;
			case _7Peg: return 4;
			default: return 0;
		}
	}

	public static function isDefaultMale(prefix:String):Bool
	{
		var isMaleFieldName:String = prefix + "DefaultMale";
		#if reflection
		// Workaround for Haxe #6630; Reflect.field on public static inline return null.
		// https://github.com/HaxeFoundation/haxe/issues/6630
		return REFLECTION_WORKAROUND[isMaleFieldName];
		#else
		return Reflect.field(PlayerData, prefix + "DefaultMale");
		#end
	}

	public static function setSexualPreference(pref:SexualPreference)
	{
		sexualPreference = pref;
		for (prefix in PROF_PREFIXES)
		{
			var male:Bool = false;
			if (pref == SexualPreference.Boys)
			{
				male = true;
			}
			else if (pref == SexualPreference.Girls)
			{
				male = false;
			}
			else
			{
				male = isDefaultMale(prefix);
			}
			Reflect.setField(PlayerData, prefix + "Male", male);
		}
	}

	public static function recentChatCount(chatItem:String)
	{
		return chatHistory.filter(function(s) { return s == chatItem; } ).length;
	}

	/**
	 * Returns true if the player has already bumped into a specific Pokemon.
	 * This avoids a scenario where a player's never played before, and Buizel
	 * just randomly stops by in an anticlimactic way. Those random "bump ins"
	 * will only happen if the player's met that Pokemon before.
	 *
	 * @param	prefix pokemon prefix, "smea" or "hera" for example
	 * @return true if the player has seen the Pokemon before
	 */
	public static function hasMet(prefix:String):Bool
	{
		if (prefix == "grov" || prefix == "abra")
		{
			// we see grovyle/abra during the intro...
			return true;
		}
		if (prefix == PROF_PREFIXES[profIndex])
		{
			// we're currently playing with them -- this is an important loophole for minigames.
			// minigames exclude pokemon you haven't "met", so if you play with someone for the
			// first time and have a minigame, it's important that they're flagged as "met"
			return true;
		}
		if (prefix == "kecl")
		{
			return hasMet("smea");
		}
		for (chatHistoryItem in chatHistory)
		{
			if (chatHistoryItem != null && StringTools.startsWith(chatHistoryItem, prefix))
			{
				return true;
			}
		}
		return false;
	}

	public static function fivePegUnlocked()
	{
		return puzzleCount[2] >= 3;
	}

	/**
	 * Seven-peg puzzles are only accessible if you go through the joke 5-peg
	 * tutorial. Or, if you've solved one before.
	 */
	public static function sevenPegUnlocked()
	{
		return puzzleCount[4] >= 1 || (puzzleCount[3] >= 3 && recentChatTime("tutorial.3.2") < 800);
	}

	public static function getTotalPuzzlesSolved()
	{
		var totalPuzzlesSolved:Int = 0;
		for (p in PlayerData.puzzleCount)
		{
			totalPuzzlesSolved += p;
		}
		return totalPuzzlesSolved;
	}

	/**
	 * After a successful sync, Abra has a few specific conversations with you
	 * next time you play.
	 */
	public static function successfulSync()
	{
		abraChats = [6];
		abraSexyRecords = [99999, 99999];
		abraSexyBeforeChat = 8;
		abraSexyAfterChat = 99;
		if (abraStoryInt == 3 || abraStoryInt == 4)
		{
			abraStoryInt += 2;
		}
		removeFromChatHistory("abra.randomChats.2.3"); // reset birthday chat
	}

	public static function isAbraNice():Bool
	{
		return abraStoryInt == 5 || abraStoryInt == 6;
	}

	public static function removeFromChatHistory(str)
	{
		var i = PlayerData.chatHistory.length - 1;
		while (i >= 0)
		{
			if (PlayerData.chatHistory[i] == str)
			{
				PlayerData.chatHistory.splice(i, 1);
			}
			i--;
		}
	}
}

enum Difficulty
{
	Easy;
	_3Peg;
	_4Peg;
	_5Peg;
	_7Peg;
}

enum Gender
{
	Boy;
	Girl;
	Complicated;
}

enum SexualPreference
{
	Boys; // likes boys
	Girls; // likes girls
	Both; // likes both
	Idiot; // the player just wants to be obnoxious and difficult
}

enum SexualPreferenceLabel
{
	Gay;
	Straight;
	Lesbian;
	Bisexual;
	Complicated;
}

typedef PokeVideo =
{
	name:String,
	reward:Float,
	male:Bool
}

enum VideoStatus
{
	Empty;
	Clean;
	Dirty;
}

enum Prompt
{
	AlwaysYes;
	AlwaysNo;
	Ask;
}

enum DetailLevel
{
	Max;
	Low;
	VeryLow;
}