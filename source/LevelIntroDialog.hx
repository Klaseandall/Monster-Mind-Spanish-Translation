package;
import poke.PokeWindow;
import poke.abra.AbraDialog;
import flixel.FlxG;
import flixel.math.FlxMath;
import poke.grov.GrovyleDialog;
import openfl.utils.Object;
import minigame.MinigameState;
import poke.luca.LucarioDialog;
import poke.sexy.SexyState;
import puzzle.Puzzle;
import puzzle.PuzzleState;

/**
 * Utility methods related to the dialog before each puzzle, as well as a few
 * other things that happen at the start and end of each puzzle.
 */
class LevelIntroDialog
{
	private static var FIXED_CHATS:String = "fixedChats";
	private static var RANDOM_CHATS:String = "randomChats";

	/**
	 * List of professor permutations. Not all Pokemon appear on all
	 * difficulties by design
	 *
	 * Sandslash (4) appears on the easiest 2 difficulties
	 * Smeargle (6) appears on the easiest 3 difficulties
	 * Buizel (1) appears in the middle 2 difficulties
	 * Rhydon (5) appears on the hardest 3 difficulties
	 * Abra (0) only appears on the hardest 2 difficulties
	 * Grovyle (3) appears on the easiest and hardest difficulty
	 */
	public static var professorPermutations:Array<Array<Int>> = [
				[6, 4, 1, 5], [4, 1, 5, 3], [6, 4, 0, 5], [3, 5, 6, 0], [3, 6, 0, 5],
				[3, 5, 1, 0], [3, 1, 5, 0], [4, 1, 6, 0], [4, 5, 1, 3], [6, 5, 0, 3],
				[3, 4, 0, 5], [3, 4, 5, 0], [4, 1, 6, 3], [3, 4, 1, 5], [4, 1, 5, 0],
				[4, 5, 1, 0], [4, 1, 0, 3], [3, 4, 1, 0], [6, 4, 1, 0], [4, 6, 5, 3],
				[3, 1, 0, 5], [3, 4, 6, 5], [3, 1, 6, 0], [6, 1, 0, 3], [6, 4, 5, 3],
				[4, 6, 0, 3], [3, 6, 1, 0], [4, 6, 5, 0], [6, 4, 5, 0], [3, 6, 1, 5],
				[3, 6, 5, 0], [6, 5, 1, 0], [4, 6, 1, 0], [4, 6, 1, 3], [4, 6, 0, 5],
				[4, 1, 6, 5], [6, 4, 1, 3], [4, 5, 0, 3], [6, 1, 5, 0], [6, 4, 0, 3],
				[3, 4, 6, 0], [6, 1, 5, 3], [3, 1, 6, 5], [6, 5, 1, 3], [6, 1, 0, 5],
				[4, 1, 0, 5], [4, 5, 6, 3], [4, 6, 1, 5], [4, 5, 6, 0]
			];

	/*
	 * List of professor permutations where the wildcard professor appears in
	 * the easiest 3 difficulties. This is important if a wildcard professor
	 * shows up before the player has unlocked the hardest difficulty
	 *
	 * 99 = Wildcard Professor
	 */
	public static var rareProfessorPermutations4:Array<Array<Int>> = [
				[3, 99, 5, 0], [99, 4, 5, 0], [99, 4, 5, 3], [6, 1, 99, 5], [6, 1, 99, 0],
				[3, 99, 1, 0], [3, 5, 99, 0], [99, 4, 6, 3], [99, 6, 1, 3], [99, 4, 1, 3],
				[6, 1, 99, 3], [4, 6, 99, 0], [4, 6, 99, 5], [3, 99, 6, 5], [3, 6, 99, 5],
				[4, 99, 6, 5], [99, 1, 5, 3], [6, 4, 99, 0], [99, 1, 6, 3], [99, 1, 6, 0],
				[6, 99, 0, 3], [3, 99, 6, 0], [99, 6, 1, 0], [4, 99, 1, 5], [6, 5, 99, 0],
				[99, 5, 1, 3], [4, 1, 99, 0], [99, 6, 5, 3], [99, 4, 6, 0], [99, 5, 6, 3],
				[4, 99, 0, 5], [99, 4, 6, 5], [99, 6, 5, 0], [6, 99, 1, 3], [99, 6, 1, 5],
				[99, 4, 0, 5], [4, 99, 6, 0], [99, 6, 0, 5], [6, 99, 1, 0], [3, 1, 99, 5],
				[3, 4, 99, 5], [99, 1, 0, 3], [4, 1, 99, 3], [99, 5, 1, 0], [3, 1, 99, 0],
				[4, 99, 0, 3], [6, 4, 99, 3], [6, 4, 99, 5], [99, 1, 0, 5], [3, 99, 0, 5],
				[99, 1, 6, 5], [4, 5, 99, 0], [99, 5, 6, 0], [4, 1, 99, 5], [6, 99, 5, 3],
				[4, 99, 6, 3], [3, 4, 99, 0], [6, 99, 1, 5], [3, 99, 1, 5], [4, 6, 99, 3],
				[99, 4, 1, 0], [3, 6, 99, 0], [99, 5, 0, 3], [4, 99, 5, 3], [99, 4, 0, 3],
				[99, 4, 1, 5], [6, 99, 5, 0], [4, 99, 1, 3], [99, 1, 5, 0], [4, 5, 99, 3],
				[4, 99, 5, 0], [6, 99, 0, 5], [4, 99, 1, 0], [6, 5, 99, 3], [99, 6, 0, 3]
			];

	/*
	 * List of professor permutations including a wildcard professor. This is
	 * used when an unusual pokemon like Lucario is visiting
	 *
	 * 99 = Wildcard Professor
	 */
	public static var rareProfessorPermutations5:Array<Array<Int>> = [
				[3, 99, 5, 0], [4, 6, 5, 99], [99, 4, 5, 0], [99, 4, 5, 3], [6, 1, 99, 5],
				[6, 1, 99, 0], [3, 99, 1, 0], [3, 5, 99, 0], [99, 4, 6, 3], [99, 6, 1, 3],
				[4, 1, 6, 99], [99, 4, 1, 3], [6, 1, 99, 3], [4, 6, 99, 0], [4, 6, 99, 5],
				[3, 99, 6, 5], [3, 6, 99, 5], [4, 99, 6, 5], [6, 4, 5, 99], [99, 1, 5, 3],
				[6, 4, 99, 0], [99, 1, 6, 3], [99, 1, 6, 0], [6, 99, 0, 3], [3, 4, 6, 99],
				[3, 5, 1, 99], [3, 99, 6, 0], [99, 6, 1, 0], [4, 99, 1, 5], [6, 5, 99, 0],
				[99, 5, 1, 3], [4, 1, 99, 0], [4, 1, 5, 99], [3, 4, 5, 99], [3, 6, 1, 99],
				[99, 6, 5, 3], [99, 4, 6, 0], [99, 5, 6, 3], [4, 99, 0, 5], [99, 4, 6, 5],
				[4, 5, 1, 99], [3, 1, 5, 99], [3, 5, 6, 99], [3, 4, 0, 99], [99, 6, 5, 0],
				[6, 99, 1, 3], [99, 6, 1, 5], [99, 4, 0, 5], [4, 99, 6, 0], [99, 6, 0, 5],
				[3, 6, 0, 99], [6, 99, 1, 0], [3, 1, 99, 5], [3, 6, 5, 99], [3, 4, 99, 5],
				[99, 1, 0, 3], [4, 1, 99, 3], [99, 5, 1, 0], [3, 1, 99, 0], [4, 99, 0, 3],
				[6, 4, 99, 3], [6, 4, 99, 5], [99, 1, 0, 5], [3, 99, 0, 5], [4, 1, 0, 99],
				[99, 1, 6, 5], [4, 6, 1, 99], [4, 5, 99, 0], [99, 5, 6, 0], [6, 4, 0, 99],
				[4, 1, 99, 5], [3, 4, 1, 99], [6, 1, 0, 99], [6, 99, 5, 3], [6, 4, 1, 99],
				[4, 99, 6, 3], [3, 4, 99, 0], [6, 99, 1, 5], [3, 99, 1, 5], [4, 6, 99, 3],
				[99, 4, 1, 0], [3, 6, 99, 0], [4, 5, 6, 99], [99, 5, 0, 3], [3, 1, 6, 99],
				[4, 99, 5, 3], [6, 5, 0, 99], [99, 4, 0, 3], [99, 4, 1, 5], [4, 5, 0, 99],
				[6, 99, 5, 0], [4, 99, 1, 3], [6, 5, 1, 99], [6, 1, 5, 99], [99, 1, 5, 0],
				[3, 1, 0, 99], [4, 5, 99, 3], [4, 6, 0, 99], [4, 99, 5, 0], [6, 99, 0, 5],
				[4, 99, 1, 0], [3, 5, 0, 99], [6, 5, 99, 3], [99, 6, 0, 3]
			];

	/*
	 * Dialog sequences might occasionally want to remember a choice from a
	 * previous puzzle. The "pushes" field stores this kind of temporary state.
	 */
	public static var pushes:Array<Int> = [0, 0, 0];

	// 120 pseudo-random ints for random chats
	private static var pseudoRandom:Array<Int> = [
				64, 75, 96, 70, 27, 10, 74, 50, 34, 18, 18, 61, 73, 58, 99, 59, 48, 94, 81, 59,
				11, 12, 13, 14, 15, 53, 82, 99, 49, 83, 52, 96, 25, 26, 91, 15, 89, 97, 44, 10,
				86, 31, 23, 60, 92, 96, 91, 23, 53, 83, 87, 17, 99, 83, 67, 82, 79, 11, 77, 78,
				10, 69, 70, 51, 78, 66, 87, 88, 30, 22, 11, 88, 92, 73, 80, 99, 29, 27, 34, 18,
				72, 39, 67, 50, 77, 95, 35, 72, 48, 38, 96, 59, 92, 76, 30, 20, 71, 42, 48, 47,
				41, 26, 17, 89, 97, 22, 75, 40, 45, 96, 89, 84, 72, 62, 11, 54, 31, 18, 64, 77
			];

	public static function generateSexyBeforeDialog<T:PokeWindow>(sexyState:SexyState<T>):Array<Array<Object>>
	{
		var clazz:Dynamic = sexyState._pokeWindow._dialogClass;
		var prefix:String = sexyState._pokeWindow._prefix;
		var sexyBeforeChat:Int = Reflect.field(PlayerData, prefix + "SexyBeforeChat");
		var sexyBeforeBad:Array<Dynamic> = Reflect.field(clazz, "sexyBeforeBad");
		var sexyBeforeChats:Array<Dynamic> = Reflect.field(clazz, "sexyBeforeChats");
		var unlockedChats:Map<String, Bool> = getUnlockedChats(clazz);
		var tree:Array<Array<Object>> = new Array<Array<Object>>();

		if (PlayerData.cursorSmellTimeRemaining > 0 && (!PlayerData.playerIsInDen || PlayerData.denSexCount == 0))
		{
			if (prefix == "magn" || prefix == "grim")
			{
				// magnezone and grimer don't notice...
			}
			else
			{
				PlayerData.appendChatHistory(prefix + ".cursorSmell");
				var cursorSmellFunc:Dynamic = Reflect.field(clazz, "cursorSmell");
				cursorSmellFunc(tree, sexyState);
				return tree;
			}
		}

		if (PlayerData.playerIsInDen)
		{
			var denDialogFunc:Dynamic = Reflect.field(clazz, "denDialog");
			var denDialog:DenDialog = denDialogFunc(sexyState);
			if (PlayerData.denSexCount == 0)
			{
				// first time having sex in den
				denDialog.getSexGreeting(tree);
				return tree;
			}
			else
			{
				// second, third time having sex in den
				denDialog.getRepeatSexGreeting(tree);
				return tree;
			}
		}

		var chat:Dynamic = null;
		if (sexyBeforeChat < sexyBeforeBad.length)
		{
			PlayerData.appendChatHistory(prefix + ".sexyBeforeBad." + sexyBeforeChat);
			chat = sexyBeforeBad[sexyBeforeChat];
		}
		else {
			var chatHistoryStr:String;
			var chats:Array<Dynamic> = sexyBeforeChats.copy();
			{
				/*
				 * We check for conflicts before loading the random chat sequence. We don't want
				 * a chat sequence to randomly involve a pokemon the player hasn't meet yet.
				 */
				var index = chats.length - 1;
				var chatHistoryStr:String;
				do {
					chatHistoryStr = prefix + ".sexyBeforeChats." + index;
					if (isLockedChat(unlockedChats, chatHistoryStr))
					{
						chats.splice(index, 1);
					}
					index--;
				}
				while (index >= 0);
			}
			if (chats.length > 0)
			{
				var index:Int = 0;
				if (sexyBeforeChat == 99)
				{
					// special value; default to the 'intro' sexyBeforeChat
					index = 0;
				}
				else
				{
					index = pseudoRandom[sexyBeforeChat - sexyBeforeBad.length] % chats.length;
				}
				var chatHistoryStr:String = prefix + ".sexyBeforeChats." + sexyBeforeChats.indexOf(chats[index]);
				PlayerData.appendChatHistory(chatHistoryStr);
				chat = chats[index];
			}
		}
		if (chat != null)
		{
			chat(tree, sexyState);
		}
		return tree;
	}

	public static function generateSexyAfterDialog<T:PokeWindow>(sexyState:SexyState<T>):Array<Array<Object>>
	{
		var clazz:Dynamic = sexyState._pokeWindow._dialogClass;
		var prefix:String = sexyState._pokeWindow._prefix;
		var sexyAfterChat:Int = Reflect.field(PlayerData, prefix + "SexyAfterChat");
		var sexyAfterGood:Array<Dynamic> = Reflect.field(clazz, "sexyAfterGood");
		var sexyAfterChats:Array<Dynamic> = Reflect.field(clazz, "sexyAfterChats");
		var sexyRecords:Array<Float> = Reflect.field(PlayerData, prefix + "SexyRecords");
		var unlockedChats:Map<String, Bool> = getUnlockedChats(clazz);
		var tree:Array<Array<Object>> = new Array<Array<Object>>();

		if (PlayerData.playerIsInDen)
		{
			var denDialogFunc:Dynamic = Reflect.field(clazz, "denDialog");
			var denDialog:DenDialog = denDialogFunc(sexyState);
			var exhausted:Bool = false;
			if (PlayerData.denSexCount > 0)
			{
				var profIndex:Int = PlayerData.PROF_PREFIXES.indexOf(sexyState._pokeWindow._prefix);
				var formulaThing:Float = (PlayerData.denSexCount - PlayerData.DEN_SEX_RESILIENCE[profIndex]) / PlayerData.denSexCount;
				var randFloat:Float = FlxG.random.float();
				exhausted = randFloat < formulaThing;
			}
			if (PlayerData.denTotalReward >= PlayerData.DEN_MAX_REWARD || exhausted)
			{
				denDialog.getTooMuchSex(tree);
			}
			else
			{
				denDialog.getReplaySex(tree);
			}
			return tree;
		}

		var chat:Dynamic = null;
		if (sexyState.totalHeartsEmitted > sexyRecords[0] && sexyState.totalHeartsEmitted > sexyRecords[1])
		{
			var index:Int = LevelIntroDialog.pseudoRandom[sexyAfterChat] % sexyAfterGood.length;
			PlayerData.appendChatHistory(prefix + ".sexyAfterGood." + index);
			chat = sexyAfterGood[index];
		}
		else {
			var chatHistoryStr:String;
			var chats:Array<Dynamic> = sexyAfterChats.copy();
			{
				/*
				 * We check for conflicts before loading the random chat sequence. We don't want
				 * a chat sequence to randomly involve a pokemon the player hasn't meet yet.
				 */
				var index = chats.length - 1;
				var chatHistoryStr:String;
				do {
					chatHistoryStr = prefix + ".sexyAfterChats." + index;
					if (isLockedChat(unlockedChats, chatHistoryStr))
					{
						chats.splice(index, 1);
					}
					index--;
				}
				while (index >= 0);
			}
			if (chats.length > 0)
			{
				var index:Int = 0;
				if (sexyAfterChat == 99)
				{
					// special value; default to the 'intro' sexyAfterChat
					index = 0;
				}
				else
				{
					index = pseudoRandom[sexyAfterChat] % chats.length;
				}
				var chatHistoryStr:String = prefix + ".sexyAfterChats." + sexyAfterChats.indexOf(chats[index]);
				PlayerData.appendChatHistory(chatHistoryStr);
				chat = chats[index];
			}
		}
		if (chat != null)
		{
			chat(tree, sexyState);
		}
		Reflect.setField(PlayerData, prefix + "SexyAfterChat", FlxG.random.int(0, 99));
		return tree;
	}

	/**
	 * Return a big number which only changes if the chat is rotated. This number is useful for
	 * generating random events, if we don't want the user to be able to game the random events
	 * by quitting the game.
	 */
	public static function getChatChecksum(puzzleState:PuzzleState, ?seed:Int = 5381):Int
	{
		var clazz:Dynamic = puzzleState._pokeWindow._dialogClass;
		var prefix:String = puzzleState._pokeWindow._prefix;
		var playerChats:Array<Int> = Reflect.field(PlayerData, prefix + "Chats");
		var sum:Int = seed;

		// append a hash which varies based on the pokemon
		for (i in 0...prefix.length)
		{
			sum = sum * 193 + prefix.charCodeAt(i);
		}

		if (playerChats != null)
		{
			// append a hash which varies based on the pokemon's chat
			for (playerChat in playerChats)
			{
				sum = sum * 463 + playerChat;
			}
		}
		return Std.int(Math.abs(sum));
	}

	public static function generateDialog(puzzleState:PuzzleState)
	{
		pushes[PlayerData.level] = 0;
		var clazz:Dynamic = puzzleState._pokeWindow._dialogClass;
		var prefix:String = puzzleState._pokeWindow._prefix;
		var playerChats:Array<Int> = Reflect.field(PlayerData, prefix + "Chats");
		var randomChats:Array<Array<Dynamic>> = Reflect.field(clazz, RANDOM_CHATS);
		var fixedChats:Array<Dynamic> = Reflect.field(clazz, FIXED_CHATS);
		var unlockedChats:Map<String, Bool> = getUnlockedChats(clazz);

		if (PlayerData.difficulty == PlayerData.Difficulty._7Peg)
		{
			playerChats = PlayerData.abra7PegChats;
			randomChats = AbraDialog.random7Peg;
			fixedChats = [];
		}

		var tree:Array<Array<Object>> = new Array<Array<Object>>();
		var chat:Dynamic = null;
		if (fixedChats != null && playerChats[0] < fixedChats.length)
		{
			PlayerData.appendChatHistory(prefix + "." + FIXED_CHATS + "." + playerChats[0]);
			chat = fixedChats[playerChats[0]];
		}
		else if (randomChats != null)
		{
			var index0:Int = Std.int(Math.min(PlayerData.level, 2));
			var chats:Array<Dynamic> = randomChats[index0].copy();
			var chatType:String = PlayerData.difficulty == PlayerData.Difficulty._7Peg ? "random7Peg" : RANDOM_CHATS;
			{
				/*
				 * We check for conflicts before loading the random chat sequence. We don't want
				 * a chat sequence to randomly involve a pokemon the player hasn't meet yet.
				 */
				var index1 = chats.length - 1;
				var chatHistoryStr:String;
				do
				{
					chatHistoryStr = prefix + "." + chatType + "." + index0 + "." + index1;
					if (isLockedChat(unlockedChats, chatHistoryStr))
					{
						chats.splice(index1, 1);
					}
					index1--;
				}
				while (index1 >= 0);
			}
			if (chats.length > 0)
			{
				var index1:Int = pseudoRandom[playerChats[0] - fixedChats.length + PlayerData.level] % chats.length;
				#if hl
				// workaround for Haxe #10628; HashLink throws a runtime error 'Missing argument:
				// 3 expected but 2 passed' if you call 'indexOf' without an explicit cast
				// https://github.com/HaxeFoundation/haxe/issues/10628
				var chatHistoryStr:String = prefix + "." + chatType + "." + index0 + "." + cast(randomChats[index0], Array<Dynamic>).indexOf(chats[index1]);
				#else
				var chatHistoryStr:String = prefix + "." + chatType + "." + index0 + "." + randomChats[index0].indexOf(chats[index1]);
				#end
				PlayerData.appendChatHistory(chatHistoryStr);
				chat = chats[index1];
			}
		}
		if (chat != null)
		{
			chat(tree, puzzleState);
		}
		return tree;
	}

	/**
	 * getUnlockedChats() is a method implemented by each dialog class. It should have a NULL or
	 * TRUE entry if the chat is OK. If the entry is FALSE, then the chat sequence is locked.
	 */
	static private function getUnlockedChats(clazz:Dynamic):Map<String, Bool>
	{
		if (!Reflect.hasField(clazz, "getUnlockedChats"))
		{
			// getUnlockedChats method not defined
			return new Map<String, Bool>();
		}
		return Reflect.callMethod(clazz, Reflect.field(clazz, "getUnlockedChats"), []);
	}

	public static function isFixedChat(puzzleState:PuzzleState):Bool
	{
		var clazz:Dynamic = puzzleState._pokeWindow._dialogClass;
		var prefix:String = puzzleState._pokeWindow._prefix;
		var playerChats:Array<Int> = Reflect.field(PlayerData, prefix + "Chats");
		var fixedChats:Array<Dynamic> = Reflect.field(clazz, FIXED_CHATS);
		return playerChats[0] < fixedChats.length;
	}

	public static function generateBadGuessDialog(puzzleState:PuzzleState):Array<Array<Object>>
	{
		var clazz:Dynamic = puzzleState._pokeWindow._dialogClass;
		var prefix:String = puzzleState._pokeWindow._prefix;
		var clueBad:Dynamic = Reflect.field(clazz, "clueBad");
		var tree:Array<Array<Object>> = new Array<Array<Object>>();
		if (clueBad == null)
		{
			clueBad = GrovyleDialog.clueBad;
		}
		clueBad(tree, puzzleState);
		return tree;
	}

	public static function generateInvalidAnswerDialog(puzzleState:PuzzleState):Array<Array<Object>>
	{
		var clazz:Dynamic = puzzleState._pokeWindow._dialogClass;
		var prefix:String = puzzleState._pokeWindow._prefix;
		var clueBad:Dynamic = Reflect.field(clazz, "invalidAnswer");
		var tree:Array<Array<Object>> = new Array<Array<Object>>();
		if (clueBad == null)
		{
			clueBad = AbraDialog.invalidAnswer;
		}
		clueBad(tree, puzzleState);
		return tree;
	}

	public static function generateHelp(puzzleState:PuzzleState):Array<Array<Object>>
	{
		var clazz:Dynamic = puzzleState._pokeWindow._dialogClass;
		var prefix:String = puzzleState._pokeWindow._prefix;
		var tree:Array<Array<Object>> = new Array<Array<Object>>();

		if (puzzleState._tutorial != null)
		{
			// if it's a tutorial, we append the "restart tutorial" option
			var tutorialHelp:Dynamic = Reflect.field(clazz, "tutorialHelp");
			if (tutorialHelp == null)
			{
				if (puzzleState._pokeWindow._prefix == "abra")
				{
					tutorialHelp = AbraDialog.tutorialHelp;
				}
				else
				{
					tutorialHelp = GrovyleDialog.tutorialHelp;
				}
			}
			tutorialHelp(tree, puzzleState);
		}
		else {
			var help:Dynamic = Reflect.field(clazz, "help");
			if (help == null)
			{
				help = GrovyleDialog.help;
			}
			help(tree, puzzleState);
		}

		return tree;
	}

	public static function generateMinigameHelp(dialogClass:Class<Dynamic>, minigameState:Dynamic):Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = new Array<Array<Object>>();

		var minigameHelp:Dynamic = Reflect.field(dialogClass, "minigameHelp");
		if (minigameHelp == null)
		{
			minigameHelp = GrovyleDialog.minigameHelp;
		}
		minigameHelp(tree, minigameState);

		return tree;
	}

	public static function rotateChat()
	{
		var clazz:Dynamic = Type.resolveClass(PlayerData.PROF_DIALOG_CLASS[PlayerData.profIndex]);
		var prefix:String = PlayerData.PROF_PREFIXES[PlayerData.profIndex];
		var playerChats:Array<Int> = Reflect.field(PlayerData, prefix + "Chats");

		if (prefix == "magn" && PlayerData.magnGift == 1)
		{
			// received gift
			PlayerData.magnGift = 2;
		}
		if (prefix == "smea" && PlayerData.keclGift == 1)
		{
			// received gift
			PlayerData.keclGift = 2;
		}
		if (prefix == "rhyd" && PlayerData.rhydGift == 1)
		{
			// received gift; summon lucario
			PlayerData.rhydGift = 2;
			PlayerData.luckyProfSchedules.remove(PlayerData.PROF_PREFIXES.indexOf("luca"));
			PlayerData.luckyProfSchedules.insert(0, PlayerData.PROF_PREFIXES.indexOf("luca"));
		}

		while (playerChats.length < PlayerData.CHATLENGTH + 1)
		{
			appendToChatHistory(prefix);
		}
		playerChats.splice(0, 1);

		if (prefix == "abra")
		{
			PlayerData.abra7PegChats.splice(0, 1);
			while (PlayerData.abra7PegChats.length < PlayerData.CHATLENGTH)
			{
				PlayerData.abra7PegChats.push(FlxG.random.int(10, 99));
			}
		}
		PlayerData.storeChatHistory();
	}

	public static function appendToChatHistory(prefix:String)
	{
		var clazz:Dynamic = Type.resolveClass(PlayerData.PROF_DIALOG_CLASS[PlayerData.PROF_PREFIXES.indexOf(prefix)]);
		var playerChats:Array<Int> = Reflect.field(PlayerData, prefix + "Chats");
		var fixedChats:Array<Dynamic> = Reflect.field(clazz, FIXED_CHATS);
		var unlockedChats:Map<String, Bool> = getUnlockedChats(clazz);
		if (prefix == "abra" && playerChats.length > 0 && playerChats[playerChats.length - 1] == AbraDialog.FINAL_CHAT_INDEX)
		{
			playerChats.push(AbraDialog.FINAL_CHAT_INDEX);
		}
		else if (playerChats.length > 0 && playerChats[playerChats.length - 1] < fixedChats.length)
		{
			// just had a fixed chat; append a random chat
			playerChats.push(FlxG.random.int(fixedChats.length, 99));
		}
		else
		{
			// append a fixed chat, if possible
			var tmpFixedChats:Array<Dynamic> = fixedChats.copy();
			// the first one is always an intro; never ever repeat it
			tmpFixedChats.splice(0, 1);
			{
				var i:Int = tmpFixedChats.length - 1;
				var chatType:String = FIXED_CHATS;
				while (i >= 0)
				{
					var chatHistoryStr:String = prefix + "." + chatType + "." + fixedChats.indexOf(tmpFixedChats[i]);
					if (PlayerData.recentChatCount(chatHistoryStr) > 0)
					{
						// recently had this chat
						tmpFixedChats.splice(i, 1);
					}
					else if (isLockedChat(unlockedChats, chatHistoryStr))
					{
						// chat is locked
						tmpFixedChats.splice(i, 1);
					}
					else if (playerChats.indexOf(fixedChats.indexOf(tmpFixedChats[i])) != -1)
					{
						// chat is already scheduled
						tmpFixedChats.splice(i, 1);
					}
					i--;
				}
			}

			if (tmpFixedChats.length > 0)
			{
				// there are some tmpFixedChats they haven't seen; append one
				playerChats.push(fixedChats.indexOf(tmpFixedChats[0]));
			}
			else
			{
				// they've seen it all
				playerChats.push(FlxG.random.int(fixedChats.length, 99));
			}
		}
	}

	static private function isLockedChat(unlockedChats:Map<String, Bool>, chatHistoryStr:String)
	{
		return unlockedChats[chatHistoryStr] == false;
	}

	/**
	 * Increases the libido of the professors currently on the main screen,
	 * except for the one who was just chosen
	 */
	public static function increaseProfReservoirs()
	{
		var profPrefixes:Array<String> = new Array<String>();
		for (profIndex in 0...PlayerData.professors.length)
		{
			profPrefixes.push(PlayerData.PROF_PREFIXES[PlayerData.professors[profIndex]]);
		}

		PlayerData.prevProfPrefix = PlayerData.PROF_PREFIXES[PlayerData.profIndex];
		var prevProfIndex:Int = PlayerData.PROF_PREFIXES.indexOf(PlayerData.prevProfPrefix);

		profPrefixes.remove(PlayerData.prevProfPrefix);

		FlxG.random.shuffle(profPrefixes); // shuffle so that the overflow professor will be random
		profPrefixes.sort(function(a, b) return -Reflect.compare(Reflect.field(PlayerData, a + "Reservoir"), Reflect.field(PlayerData, b + "Reservoir")));
		var overflowProf:String = null;
		if (Reflect.field(PlayerData, profPrefixes[0] + "Reservoir") == 210) overflowProf = profPrefixes[0];

		var distributedAmount:Int = Math.ceil(PlayerData.reservoirReward * 0.4);
		var distributedToyAmount:Int = Math.ceil(PlayerData.reservoirReward * 0.4);
		PlayerData.reservoirReward -= distributedAmount;
		/*
		 * We determine an amount of libido points to distribute among the three unpicked
		 * professors. The first professor gets about 60% of the points; the second gets 75% of
		 * whatever's left, and the final professor gets everything left. However, if any professor
		 * maxes out their libido, the spillover goes to the remaining professors.
		 */
		for (i in 0...3)
		{
			var reservoir:Int = Reflect.field(PlayerData, profPrefixes[i] + "Reservoir");
			var amount:Int = Math.ceil(Math.min(distributedAmount * [0.6, 0.75, 1.0][i], 210 - reservoir));
			if (profPrefixes[i] == "smea")
			{
				// reduce libido given to smeargle
				var limit:Int = 0;
				if (reservoir >= 55)
				{
					limit = 2;
				}
				else if (reservoir >= 50)
				{
					limit = 4;
				}
				else if (reservoir >= 40)
				{
					limit = 7;
				}
				else
				{
					limit = 13;
				}
				limit = FlxG.random.int(0, limit);
				var bankAmount:Int = Std.int(FlxMath.bound(amount - limit, 0, 210 - PlayerData.smeaReservoirBank));
				PlayerData.smeaReservoirBank += bankAmount;
				amount -= bankAmount;
				distributedAmount -= bankAmount;
				amount = Std.int(FlxMath.bound(amount, 0, limit));
			}
			Reflect.setField(PlayerData, profPrefixes[i] + "Reservoir", reservoir + amount);
			distributedAmount -= amount;
		}
		/*
		 * For toy libido points, we just split them evenly between the four professors
		 */
		for (profIndex in PlayerData.professors)
		{
			var profPrefix:String = PlayerData.PROF_PREFIXES[profIndex];
			var toyReservoir:Int = Reflect.field(PlayerData, profPrefix + "ToyReservoir");
			var toyAmount:Int = Math.ceil(Math.min(distributedToyAmount * 0.25, toyReservoir == -1 ? 0 : 180 - toyReservoir));
			if (profPrefix == "smea")
			{
				// reduce libido given to smeargle
				var limit:Int = 0;
				if (toyReservoir >= 45)
				{
					limit = 2;
				}
				else if (toyReservoir >= 40)
				{
					limit = 4;
				}
				else if (toyReservoir >= 30)
				{
					limit = 7;
				}
				else
				{
					limit = 13;
				}
				limit = FlxG.random.int(0, limit);
				var toyBankAmount:Int = Std.int(FlxMath.bound(toyAmount - limit, 0, 180 - PlayerData.smeaToyReservoirBank));
				PlayerData.smeaToyReservoirBank += toyBankAmount;
				toyAmount -= toyBankAmount;
			}
			Reflect.setField(PlayerData, profPrefix + "ToyReservoir", toyReservoir + toyAmount);
		}
		if (distributedAmount > 0)
		{
			if (overflowProf == null)
			{
				// reservoir overflow
				Reflect.setField(PlayerData, overflowProf + "Reservoir", 0);
				distributedAmount += 210;
			}
			PlayerData.reimburseCritterBonus(distributedAmount);
		}
	}

	/**
	 * Swaps out the professors on the main screen for a new set
	 *
	 * @param	profPrefixesToAvoid prefixes to avoid, if certain professors
	 *       	shouldn't appear right now
	 * @param	afterPuzzle true if the player just solved a puzzle. If they're
	 *       	deliberately avoiding a certain Pokemon like Grimer, we don't
	 *       	want that pokemon to keep showing up over and over
	 */
	public static function rotateProfessors(profPrefixesToAvoid:Array<String>, afterPuzzle:Bool=true)
	{
		var luckyProf:Int = PlayerData.luckyProfSchedules[0];
		if (afterPuzzle)
		{
			// player just solved a puzzle; did they snub a professor? is a new lucky professor assigned?

			if (luckyProf != -1)
			{
				if (PlayerData.luckyProfSchedules[0] == PlayerData.profIndex)
				{
					// just played with lucky prof
					PlayerData.luckyProfSchedules.remove(luckyProf);
					// insert somewhere in the back half of the schedule
					PlayerData.luckyProfSchedules.insert(FlxG.random.int(Math.ceil(PlayerData.luckyProfSchedules.length * 0.5), PlayerData.luckyProfSchedules.length), luckyProf);
				}
				else
				{
					// snubbed lucky prof
					if (FlxG.random.bool(44))
					{
						PlayerData.luckyProfSchedules.remove(luckyProf);
						// insert somewhere in the back half of the schedule
						PlayerData.luckyProfSchedules.insert(FlxG.random.int(Math.ceil(PlayerData.luckyProfSchedules.length * 0.5), PlayerData.luckyProfSchedules.length), luckyProf);
						// also move some of the -1s, as compensation. we don't want to punish the player too hard
						PlayerData.luckyProfReward += 10;
					}
				}
			}

			while (PlayerData.luckyProfReward >= 5)
			{
				PlayerData.luckyProfReward -= 5;
				PlayerData.luckyProfSchedules.remove( -1);
				// insert in the back of the schedule
				PlayerData.luckyProfSchedules.push( -1);
			}

			// assign den professor
			if (PlayerData.denMinigame != -1)
			{
				if (PlayerData.nextDenProf != -1)
				{
					PlayerData.denProf = PlayerData.nextDenProf;
					PlayerData.nextDenProf = -1;
				}
				else
				{
					PlayerData.denProf = PlayerData.PROF_PREFIXES.indexOf(PlayerData.prevProfPrefix);
				}
				if (PlayerData.prevProfPrefix == "hera")
				{
					PlayerData.denCost = Puzzle.getSmallestRewardGreaterThan(FlxG.random.float(1, 20)); // [5-20]
				}
				else
				{
					PlayerData.denCost = Puzzle.getSmallestRewardGreaterThan(FlxG.random.float(56, 240)); // [60-240]
				}
			}
		}

		// rotate in new professors
		var currentProfPermutations:Array<Array<Int>> = professorPermutations;
		while (PlayerData.luckyProfSchedules[0] == PlayerData.PROF_PREFIXES.indexOf("magn") && !PlayerData.startedMagnezone // Magnezone doesn't show up until we meet him in the shop
				|| PlayerData.luckyProfSchedules[0] == PlayerData.PROF_PREFIXES.indexOf("hera") && (ItemDatabase._playerItemIndexes.length == 0 || !PlayerData.hasMet("kecl")) // Heracross doesn't show up until we purchase an item from the shop, and meet Kecleon (his replacement)
				|| PlayerData.luckyProfSchedules[0] == PlayerData.profIndex // just played with this particular lucky professor
			  )
		{
			var luckyProf = PlayerData.luckyProfSchedules[0];
			PlayerData.luckyProfSchedules.remove(luckyProf);
			// insert somewhere in the back half of the schedule
			PlayerData.luckyProfSchedules.insert(FlxG.random.int(Math.ceil(PlayerData.luckyProfSchedules.length * 0.5), PlayerData.luckyProfSchedules.length), luckyProf);
			// also move some of the -1s, as compensation. we don't want to punish the player too hard
			PlayerData.luckyProfReward += 10;
		}
		if (PlayerData.luckyProfSchedules[0] > -1)
		{
			// lucky professor
			if (LucarioDialog.isLucariosFirstTime())
			{
				// lucario's first time; we leave the regular professors in place
			}
			else if (!PlayerData.fivePegUnlocked())
			{
				currentProfPermutations = rareProfessorPermutations4;
			}
			else
			{
				currentProfPermutations = rareProfessorPermutations5;
			}
		}
		FlxG.random.shuffle(currentProfPermutations);
		{
			var i:Int = 0;
			var done:Bool = false;
			var profIndexesToAvoid:Array<Int> = [];
			for (profPrefixToAvoid in profPrefixesToAvoid)
			{
				profIndexesToAvoid.push(PlayerData.PROF_PREFIXES.indexOf(profPrefixToAvoid));
			}
			do
			{
				done = true;
				if (i >= currentProfPermutations.length - 1)
				{
					break;
				}
				for (profIndexToAvoid in profIndexesToAvoid)
				{
					if (currentProfPermutations[i].indexOf(profIndexToAvoid) != -1)
					{
						done = false;
					}
				}
				if (done == false)
				{
					i++;
				}
			}
			while (!done);
			PlayerData.professors = currentProfPermutations[i].copy();
		}
		if (PlayerData.luckyProfSchedules[0] > -1)
		{
			// lucky professor
			for (i in 0...PlayerData.professors.length)
			{
				if (PlayerData.professors[i] == 99)
				{
					PlayerData.professors[i] = PlayerData.luckyProfSchedules[0];
				}
			}
		}
	}

	public static function rotateSexyChat<T:PokeWindow>(sexyState:SexyState<T>, ?badThings:Array<Int>):Void
	{
		var clazz:Dynamic = sexyState._pokeWindow._dialogClass;
		var prefix:String = sexyState._pokeWindow._prefix;
		var sexyBeforeBad:Array<Dynamic> = Reflect.field(clazz, "sexyBeforeBad");
		if (sexyState.isFinishedSexyStuff())
		{
			var sexyRecords:Array<Float> = Reflect.field(PlayerData, prefix + "SexyRecords");
			sexyRecords.splice(0, 1);
			sexyRecords.push(sexyState.totalHeartsEmitted);
		}
		if (PlayerData.difficulty == PlayerData.Difficulty._7Peg)
		{
			PlayerData.abra7PegSexyBeforeChat = FlxG.random.int(10, 99);
		}
		else {
			var index:Int = FlxG.random.int(0, Std.int(Math.max(3, badThings == null ? 0 : badThings.length)));
			var newChat:Int = 0;
			if (badThings != null && index < badThings.length)
			{
				newChat = badThings[index];
			}
			else {
				newChat = FlxG.random.int(sexyBeforeBad.length, 99);
			}
			Reflect.setField(PlayerData, prefix + "SexyBeforeChat", newChat);
		}
		PlayerData.storeChatHistory();
	}

	public static function generateBonusCoinDialog(puzzleState:PuzzleState)
	{
		var clazz:Dynamic = puzzleState._pokeWindow._dialogClass;
		var prefix:String = puzzleState._pokeWindow._prefix;
		var bonusCoin:Dynamic = Reflect.field(clazz, "bonusCoin");
		if (bonusCoin == null)
		{
			bonusCoin = GrovyleDialog.bonusCoin;
		}
		var tree:Array<Array<Object>> = new Array<Array<Object>>();
		if (puzzleState._pokeWindow._partAlpha == 0)
		{
			// nobody's around; should just yell?
			tree[0] = ["#self00#(Uhhh...? I found this bonus coin... But nobody's around...)"];
			tree[1] = ["#self00#(HEY EVERYONE! HEY I FOUND A BONUS COIN! IS ANYBODY THERE?)"];
			tree[2] = ["#self00#(...)"];
			tree[3] = ["#self00#(...Right... I can't yell... because I have no mouth...)"];
			tree[4] = ["#self00#(Maybe if I pound something really loudly? Where's something that I can pound!)"];
			tree[5] = ["#abra12#Ehh? Hey, stop thinking so loud! I was away doing... Abra stuff."];
			if (puzzleState._pokeWindow._prefix == "abra")
			{
				tree[6] = ["#abra05#Oh! A bonus coin, yes, I understand now. Alright, let's see what kind of bonus game I... hmmm... maybe... "];
				tree[7] = ["#abra03#Oooh! How about THIS one?"];
			}
			else
			{
				tree[6] = ["#abra05#Oh! A bonus coin, yes, I understand now. Hmm, " + puzzleState._pokeWindow._name + " should really be handling this."];
				tree[7] = ["#abra05#...I'll be right back."];
			}
		}
		else
		{
			bonusCoin(tree, puzzleState);
		}
		return tree;
	}

	/**
	 * @return which minigame will happen next
	 */
	public static function peekNextMinigame():MinigameState
	{
		var unlockedMinigames:Array<Int> = [];
		if (PlayerData.hasMet("buiz"))
		{
			// buizel tutorials the scale game
			unlockedMinigames.push(0);
		}
		if (PlayerData.hasMet("rhyd"))
		{
			// rhydon tutorials the stair game
			unlockedMinigames.push(1);
		}
		if (PlayerData.hasMet("smea"))
		{
			// smneargle tutorials the scale game
			unlockedMinigames.push(2);
		}
		if (unlockedMinigames.length == 0)
		{
			return null;
		}

		for (i in 0...10)
		{
			if (PlayerData.minigameQueue.length <= 1)
			{
				/*
				 * We rotate through the minigames equally, by drawing from a
				 * stack of three shuffled cards until the stack is empty.
				 */
				PlayerData.minigameQueue = PlayerData.minigameQueue.concat(FlxG.random.getObject([
					[0, 1, 2],
					[0, 2, 1],
					[1, 0, 2],
					[1, 2, 0],
					[2, 0, 1],
					[2, 1, 0],
				]));
				if (PlayerData.minigameQueue[0] == PlayerData.minigameQueue[1])
				{
					var possibleAppends = [0, 1, 2];
					possibleAppends.remove(PlayerData.minigameQueue[0]);
					PlayerData.minigameQueue.insert(1, FlxG.random.getObject(possibleAppends));
				}
			}

			if (unlockedMinigames.indexOf(PlayerData.minigameQueue[0]) != -1)
			{
				return MinigameState.fromInt(PlayerData.minigameQueue[0]);
			}
			else
			{
				PlayerData.minigameQueue.splice(0, 1);
			}
		}

		// ??? shouldn't happen, but maybe if the player's minigameQueue was modified outside the program
		return null;
	}

	/**
	 * Returns the next minigame, cycling to a new minigame aftewards
	 *
	 * @return the minigame which will happen next
	 */
	public static function popNextMinigame():MinigameState
	{
		var result:MinigameState = peekNextMinigame();
		if (result == null)
		{
			return null;
		}
		PlayerData.minigameQueue.splice(0, 1);
		return result;
	}
}