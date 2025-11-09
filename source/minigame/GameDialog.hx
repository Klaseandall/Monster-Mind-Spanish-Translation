package minigame;

import MmStringTools.*;
import PlayerData.Gender;
import flixel.FlxG;
import flixel.util.FlxDestroyUtil;
import kludge.BetterFlxRandom;
import minigame.scale.ScaleGameState;
import minigame.tug.TugGameState;
import openfl.utils.Object;
import minigame.stair.StairGameState;

/**
 * Pokemon have about 20 things they say during the minigames, like "Augh I
 * lost the game!" or "Wow, you just made a really good move..." or "It's time
 * for round 4!"
 *
 * This class acts as a data model for all the phrases a particular Pokemon
 * says during a minigame
 *
 * The dialog supports replaceable entities like <round>, <leader> and pronouns like <leaderHe> <leadershe>
 *
 * Losing dialog supports <money> for dialog referencing winnings, and <nomoney> as a flag if the player won 0$.
 */
class GameDialog implements IFlxDestroyable
{
	private var roundStarts:Array<GameDialogLine> = [];
	private var defaultRoundStarts:Array<GameDialogLine> = [];
	private var winnings:Array<GameDialogLine> = [];
	private var losings:Array<GameDialogLine> = [];

	private var roundWins:Array<GameDialogLine> = [];
	private var roundLoses:Array<GameDialogLine> = [];

	private var stairReadies:Array<GameDialogLine> = [];
	private var defaultStairReady:GameDialogLine = new GameDialogLine("#zzzz05#Ready?", ["Sure\nthing", "Let's go!", "Hmm..."]);
	private var stairPlayerStarts:Array<GameDialogLine> = [];
	private var defaultPlayerStarts:GameDialogLine = new GameDialogLine("#zzzz02#Oh, so you get to go first. Are you ready?", ["Hmm,\nsure...", "Ha, I knew\nyou'd pick\nthat!", "I'm ready!"]);
	private var stairComputerStarts:Array<GameDialogLine> = [];
	private var defaultComputerStarts:GameDialogLine = new GameDialogLine("#zzzz02#Oh, so I get to go first! Are you ready?", ["Yep,\nready!", "Hmph!\nDid you\ncheat?", "I think\nso..."]);
	private var stairOddsEvens:Array<GameDialogLine> = [];
	private var defaultOddsEvens:GameDialogLine = new GameDialogLine("#zzzz06#Let's throw odds and evens to see who goes first. You'll go first if it's odd, and I'll go first if it's even. Alright?", ["Yep", "Let's\ndo it", "Okay, so\nI'm odds..."]);
	private var stairCheats:Array<GameDialogLine> = [];
	private var defaultStairCheat:GameDialogLine = new GameDialogLine("#zzzz05#You need to throw your dice sooner! Let's try again.", ["I didn't\nmean to\ndo that...", "Ehh,\nwhatever", "Oops!\nOkay"]);
	private var stairCapturedComputers:Array<GameDialogLine> = [];
	private var defaultStairCapturedComputer:GameDialogLine = new GameDialogLine("#zzzz10#Ahh! You caught me!", ["Heh!\nHeh heh", "Oops,\nsorry...", "You're not\nvery good"]);
	private var stairCapturedHumans:Array<GameDialogLine> = [];
	private var defaultStairCapturedHuman:GameDialogLine = new GameDialogLine("#zzzz02#Hah! I caught you!", ["Nice\njob!", "Ugh, so\nlucky...", "I'll get\nyou yet"]);
	private var closeGames:Array<GameDialogLine> = [];
	private var defaultCloseGame:GameDialogLine = new GameDialogLine("#zzzz04#Wow! Close game.", ["Yeah!", "I'll still\nwin...", "This is\nfun~"]);

	private var gameStartQueries:Array<String> = [];
	private var playerBeatMes:Array<Array<String>> = [];
	private var beatPlayers:Array<Array<String>> = [];
	private var shortPlayerBeatMes:Array<String> = [];
	private var shortWeWereBeatens:Array<String> = [];
	private var postTutorialGameStarts:Array<String> = [];
	private var gameAnnouncements:Array<String> = [];
	private var remoteExplanationHandoffs:Array<String> = [];
	private var localExplanationHandoffs:Array<String> = [];
	private var skipMinigames:Array<Array<String>> = [];
	private var illSitOuts:Array<String> = [];
	private var fineIllPlays:Array<String> = [];

	private var gameStateClass:Class<MinigameState> = null;

	public function new(gameStateClass:Class<MinigameState>)
	{
		this.gameStateClass = gameStateClass;
	}

	public function help(tree:Array<Array<Object>>, helpDialog:HelpDialog)
	{
		tree[0] = [FlxG.random.getObject(helpDialog.greetings)];
		tree[1] = [100, 120, 140, 160];
		tree[100] = [FlxG.random.getObject(["I think\nI'm done\nfor now", "I'm gonna\ncall it\nquits", "Sorry, I'm\ngonna take\noff"])];
		tree[101] = ["%disable-skip%"];
		tree[102] = [FlxG.random.getObject(helpDialog.goodbyes)];
		tree[103] = ["%quit%"];

		tree[120] = [FlxG.random.getObject(["Nevermind", "Oops,\nsorry", "It's\nnothing"])];
		tree[121] = [FlxG.random.getObject(helpDialog.neverminds)];

		tree[140] = [FlxG.random.getObject(["Can I skip\nthis minigame?", "Is there\na way\nto skip\nover this?", "Can we do\nsomething else?"])];

		tree[160] = [FlxG.random.getObject(["Can you\nexplain this\nagain?", "Can you\nremind me\nhow to play?", "How does\nthis game\nwork?"])];

		var skipMinigame:Array<String> = FlxG.random.getObject(skipMinigames);
		tree[141] = ["%disable-skip%"];
		tree[142] = ["%skip-minigame%"];

		var tutorialTree:Array<Array<Object>> = [];
		if (gameStateClass == ScaleGameState)
		{
			tutorialTree = TutorialDialog.scaleGameSummary();
		}
		else if (gameStateClass == StairGameState)
		{
			tutorialTree = TutorialDialog.stairGameSummary();
		}
		else if (gameStateClass == TugGameState)
		{
			tutorialTree = TutorialDialog.tugGameSummary();
		}
		for (i in 0...tutorialTree.length)
		{
			tree[161 + i] = tutorialTree[i];
		}
	}

	public function addRoundWin(dialog:String, choices:Array<String>)
	{
		roundWins.push(new GameDialogLine(dialog, choices));
	}

	public function popRoundWin(tree:Array<Array<Object>>)
	{
		popRoundStartLine(tree, roundWins);
	}

	/**
	 * Supports <leader> <leaderhe> for round winner
	 */
	public function addRoundLose(dialog:String, choices:Array<String>)
	{
		roundLoses.push(new GameDialogLine(dialog, choices));
	}

	public function popRoundLose(tree:Array<Array<Object>>, ?leader:String, ?leaderGender:PlayerData.Gender)
	{
		var roundLose:GameDialogLine = popRoundStartLine(tree, roundLoses);
		roundLose.filterLeader(tree, leader, leaderGender);
	}

	public function addStairPlayerStarts(dialog:String, choices:Array<String>)
	{
		pushRandom(stairPlayerStarts, new GameDialogLine(dialog, choices));
	}

	public function popStairPlayerStarts(tree:Array<Array<Object>>)
	{
		var stairPlayerStarts:GameDialogLine = popAndCycle(this.stairPlayerStarts, defaultPlayerStarts);
		stairPlayerStarts.generateDialog(tree);
	}

	/**
	 * Supports <playerthrow>, <computerthrow>, <Playerthrow>, <Computerthrow>
	 */
	public function addStairCapturedHuman(dialog:String, choices:Array<String>)
	{
		pushRandom(stairCapturedHumans, new GameDialogLine(dialog, choices));
	}

	public function popStairCapturedHuman(tree:Array<Array<Object>>, playerThrow:Int, computerThrow:Int)
	{
		var stairCapturedHuman:GameDialogLine = popAndCycle(this.stairCapturedHumans, defaultStairCapturedHuman);
		stairCapturedHuman.generateDialog(tree);
		stairCapturedHuman.filterStairThrow(tree, playerThrow, computerThrow);
	}

	/**
	 * Supports <playerthrow>, <computerthrow>, <Playerthrow>, <Computerthrow>
	 */
	public function addStairCapturedComputer(dialog:String, choices:Array<String>)
	{
		pushRandom(stairCapturedComputers, new GameDialogLine(dialog, choices));
	}

	public function popStairCapturedComputer(tree:Array<Array<Object>>, playerThrow:Int, computerThrow:Int)
	{
		var stairCapturedComputer:GameDialogLine = popAndCycle(this.stairCapturedComputers, defaultStairCapturedComputer);
		stairCapturedComputer.generateDialog(tree);
		stairCapturedComputer.filterStairThrow(tree, playerThrow, computerThrow);
	}

	public function addStairComputerStarts(dialog:String, choices:Array<String>)
	{
		pushRandom(stairComputerStarts, new GameDialogLine(dialog, choices));
	}

	public function popStairComputerStarts(tree:Array<Array<Object>>)
	{
		var stairComputerStarts:GameDialogLine = popAndCycle(this.stairComputerStarts, defaultComputerStarts);
		stairComputerStarts.generateDialog(tree);
	}

	public function addStairOddsEvens(dialog:String, choices:Array<String>)
	{
		pushRandom(stairOddsEvens, new GameDialogLine(dialog, choices));
	}

	public function popStairOddsEvens(tree:Array<Array<Object>>)
	{
		var stairOddsEvens:GameDialogLine = popAndCycle(this.stairOddsEvens, defaultOddsEvens);
		stairOddsEvens.generateDialog(tree);
	}

	public function addCloseGame(dialog:String, choices:Array<String>)
	{
		pushRandom(closeGames, new GameDialogLine(dialog, choices));
	}

	public function popCloseGame(tree:Array<Array<Object>>)
	{
		var closeGame:GameDialogLine = popAndCycle(closeGames, defaultCloseGame);
		closeGame.generateDialog(tree);
	}

	public function addStairReady(dialog:String, choices:Array<String>)
	{
		pushRandom(stairReadies, new GameDialogLine(dialog, choices));
	}

	public function popStairReady(tree:Array<Array<Object>>)
	{
		var stairReady:GameDialogLine = popAndCycle(stairReadies, defaultStairReady);
		stairReady.generateDialog(tree, [["%prompts-y-offset-50%"]]);
	}

	public function addStairCheat(dialog:String, choices:Array<String>)
	{
		pushRandom(stairCheats, new GameDialogLine(dialog, choices));
	}

	public function popStairCheat(tree:Array<Array<Object>>)
	{
		var stairCheat:GameDialogLine = popAndCycle(stairCheats, defaultStairCheat);
		stairCheat.generateDialog(tree, [["%prompts-y-offset-50%"]]);
	}

	/**
	 * Pushes an item into a random position in the array
	 */
	private static function pushRandom<T>(objects:Array<T>, obj:T)
	{
		objects.insert(FlxG.random.int(0, objects.length), obj);
	}

	/**
	 * Pop an item from somewhere near the front of the array, and stick it on the back. This is a simple way to avoid generating the same dialog twice in a row.
	 */
	private static function popAndCycle<T>(objects:Array<T>, defaultAnswer:T):T
	{
		var obj:T;
		if (objects == null || objects.length <= 1)
		{
			obj = objects[0];
		}
		else {
			obj = FlxG.random.getObject(objects.slice(0, objects.length - 1));
		}
		if (obj == null)
		{
			return defaultAnswer;
		}
		objects.remove(obj);
		objects.push(obj);
		return obj;
	}

	/**
	 * Supports <round> for round number.
	 *
	 * However, the first "round" message shouldn't have any <round> variables.
	 * This is our safety choice if for some reason we can't pick the choice we
	 * wanted.
	 */
	public function addRoundStart(dialog:String, choices:Array<String>)
	{
		roundStarts.push(new GameDialogLine(dialog, choices));
		defaultRoundStarts.push(new GameDialogLine(dialog, choices));
	}

	public function popRoundStart(tree:Array<Array<Object>>, roundNum:Int)
	{
		var roundStart:GameDialogLine = popRoundStartLine(tree, roundStarts);
		roundStart.filterRound(tree, roundNum);
	}

	public function addWinning(dialog:String, choices:Array<String>)
	{
		winnings.push(new GameDialogLine(dialog, choices));
	}

	public function popWinning(tree:Array<Array<Object>>)
	{
		popRoundStartLine(tree, winnings);
	}

	/**
	 * Supports <leader>, <leaderhe> for overall leader
	 */
	public function addLosing(dialog:String, choices:Array<String>)
	{
		losings.push(new GameDialogLine(dialog, choices));
	}

	public function popLosing(tree:Array<Array<Object>>, leader:String, leaderGender:Gender)
	{
		var losing:GameDialogLine = popRoundStartLine(tree, losings);
		losing.filterLeader(tree, leader, leaderGender);
	}

	/**
	 * Supports <Minigame>, <minigame> for minigame name
	 */
	public function addGameAnnouncement(line:String)
	{
		gameAnnouncements.push(line);
	}

	public function popGameAnnouncement(tree:Array<Array<Object>>, desc:String)
	{
		var line:String = FlxG.random.getObject(gameAnnouncements);
		line = StringTools.replace(line, "<minigame>", desc);
		line = StringTools.replace(line, "<Minigame>", capitalize(desc));
		tree.push([line]);
	}

	public function addGameStartQuery(line:String)
	{
		gameStartQueries.push(line);
	}

	public function popGameStartQuery(tree:Array<Array<Object>>)
	{
		var line:String = FlxG.random.getObject(gameStartQueries);
		var i:Int = tree.length;
		tree[i] = [line];
		tree[i + 1] = [i + 3, i + 6, i + 9, i + 12];
		tree[i + 3] = ["Yeah!"];
		tree[i + 6] = ["Hmm, I\nguess..."];
		tree[i + 9] = ["Can you go\nover the\nrules again?"];
		tree[i + 10] = ["%restart-tutorial%"];
		tree[i + 12] = [FlxG.random.getObject(["No, I'll pass\nthis time", "No thanks,\nI'd rather not", "No, I don't\nreally\nwant to"])];
		tree[i + 13] = ["%skip-minigame%"];
	}

	/**
	 * Supports <money> for the amount of money the player won
	 */
	public function addPlayerBeatMe(lines:Array<String>)
	{
		playerBeatMes.push(lines);
	}

	public function popPlayerBeatMe(tree:Array<Array<Object>>, rewardMoney:Int)
	{
		var lines:Array<String>;
		do
		{
			lines = playerBeatMes.splice(FlxG.random.int(0, playerBeatMes.length - 1), 1)[0];
		}
		while (rewardMoneyMismatch(lines, rewardMoney));

		for (line in lines)
		{
			line = StringTools.replace(line, "<money>", commaSeparatedNumber(rewardMoney) + "$");
			line = StringTools.replace(line, "<nomoney>", "");
			tree.push([line]);
		}
		return tree;
	}

	/**
	 * Supports <money> <nomoney> for the amount of player the player won
	 */
	public function addBeatPlayer(lines:Array<String>)
	{
		beatPlayers.push(lines);
	}

	public function popBeatPlayer(tree:Array<Array<Object>>, rewardMoney:Int)
	{
		var lines:Array<String>;
		do
		{
			lines = beatPlayers.splice(FlxG.random.int(0, beatPlayers.length - 1), 1)[0];
		}
		while (rewardMoneyMismatch(lines, rewardMoney));

		for (line in lines)
		{
			line = StringTools.replace(line, "<money>", commaSeparatedNumber(rewardMoney) + "$");
			line = StringTools.replace(line, "<nomoney>", "");
			tree.push([line]);
		}
		return tree;
	}

	/**
	 * Supports <money> for the amount of money the player won
	 */
	public function addShortPlayerBeatMe(line:String)
	{
		shortPlayerBeatMes.push(line);
	}

	public function popShortPlayerBeatMe(tree:Array<Array<Object>>, rewardMoney:Int)
	{
		var line:String;
		do
		{
			line = shortPlayerBeatMes.splice(FlxG.random.int(0, shortPlayerBeatMes.length - 1), 1)[0];
		}
		while (rewardMoneyMismatch(line, rewardMoney));

		line = StringTools.replace(line, "<money>", commaSeparatedNumber(rewardMoney) + "$");
		line = StringTools.replace(line, "<nomoney>", "");
		tree.push([line]);
		return tree;
	}

	/**
	 * Supports <money> <nomoney> for the player's winnings, and <leader> <leaderhe> for the winner
	 */
	public function addShortWeWereBeaten(line:String)
	{
		shortWeWereBeatens.push(line);
	}

	public function popShortWeWereBeaten(tree:Array<Array<Object>>, rewardMoney:Int, leader:String, leaderGender:PlayerData.Gender)
	{
		var line:String;
		do
		{
			line = shortWeWereBeatens.splice(FlxG.random.int(0, shortWeWereBeatens.length - 1), 1)[0];
		}
		while (rewardMoneyMismatch(line, rewardMoney));

		line = StringTools.replace(line, "<money>", commaSeparatedNumber(rewardMoney) + "$");
		line = StringTools.replace(line, "<nomoney>", "");
		line = replaceLeader(line, leader, leaderGender);
		tree.push([line]);
		return tree;
	}

	private function rewardMoneyMismatch(arg:Dynamic, rewardMoney:Int):Bool
	{
		if (Std.isOfType(arg, Array))
		{
			var lines:Array<String> = cast(arg);
			for (line in lines)
			{
				if (rewardMoneyMismatch(line, rewardMoney))
				{
					return true;
				}
			}
		}
		else if (Std.isOfType(arg, String))
		{
			var line:String = cast(arg);
			if (rewardMoney <= 0 && line.indexOf("<money>") != -1)
			{
				return true;
			}
			else if (rewardMoney > 0 && line.indexOf("<nomoney>") != -1)
			{
				return true;
			}
		}
		return false;
	}

	public static function replaceLeader(line:String, leader:String, leaderGender:Gender):String
	{
		line = StringTools.replace(line, "<leader>", leader);
		if (leaderGender != null)
		{
			if (leaderGender == PlayerData.Gender.Boy)
			{
				line = StringTools.replace(line, "<leaderHe>", "He");
				line = StringTools.replace(line, "<leaderhe>", "he");
				line = StringTools.replace(line, "<leaderHe's>", "He's");
				line = StringTools.replace(line, "<leaderhe's>", "he's");
				line = StringTools.replace(line, "<leaderHe'd>", "He'd");
				line = StringTools.replace(line, "<leaderhe'd>", "he'd");
				line = StringTools.replace(line, "<leaderHim>", "Him");
				line = StringTools.replace(line, "<leaderhim>", "him");
				line = StringTools.replace(line, "<leaderHis>", "His");
				line = StringTools.replace(line, "<leaderhis>", "his");
			}
			else if (leaderGender == PlayerData.Gender.Girl)
			{
				line = StringTools.replace(line, "<leaderHe>", "She");
				line = StringTools.replace(line, "<leaderhe>", "she");
				line = StringTools.replace(line, "<leaderHe's>", "She's");
				line = StringTools.replace(line, "<leaderhe's>", "she's");
				line = StringTools.replace(line, "<leaderHe'd>", "She'd");
				line = StringTools.replace(line, "<leaderhe'd>", "she'd");
				line = StringTools.replace(line, "<leaderHim>", "Her");
				line = StringTools.replace(line, "<leaderhim>", "her");
				line = StringTools.replace(line, "<leaderHis>", "Her");
				line = StringTools.replace(line, "<leaderhis>", "her");
			}
			else
			{
				line = StringTools.replace(line, "<leaderHe>", "They");
				line = StringTools.replace(line, "<leaderhe>", "they");
				line = StringTools.replace(line, "<leaderHe's>", "They're");
				line = StringTools.replace(line, "<leaderhe's>", "they're");
				line = StringTools.replace(line, "<leaderHe'd>", "They'd");
				line = StringTools.replace(line, "<leaderhe'd>", "they'd");
				line = StringTools.replace(line, "<leaderHim>", "Them");
				line = StringTools.replace(line, "<leaderhim>", "them");
				line = StringTools.replace(line, "<leaderHis>", "Their");
				line = StringTools.replace(line, "<leaderhis>", "their");
			}
		}
		return line;
	}

	public function addSkipMinigame(lines:Array<String>)
	{
		this.skipMinigames.push(lines);
	}

	public function popSkipMinigame():Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		var lines:Array<String> = FlxG.random.getObject(skipMinigames);
		for (line in lines)
		{
			tree.push([line]);
		}
		return tree;
	}

	public function addPostTutorialGameStart(line:String)
	{
		this.postTutorialGameStarts.push(line);
	}

	public function popPostTutorialGameStartQuery(tree:Array<Array<Object>>, desc:String)
	{
		var line:String = FlxG.random.getObject(postTutorialGameStarts);
		var i:Int = 0;
		line = StringTools.replace(line, "<minigame>", desc);
		line = StringTools.replace(line, "<Minigame>", capitalize(desc));
		tree[i] = [line];
		i++;
		tree[i] = [i + 10, i + 20, i + 30, i + 40];
		tree[i + 10] = ["Yeah!"];
		tree[i + 20] = ["Hmm, I\nguess..."];
		tree[i + 30] = ["Can you go\nover that\none more time?"];
		tree[i + 31] = ["%restart-tutorial%"];
		tree[i + 40] = [FlxG.random.getObject(["No, I'll pass\nthis time", "No thanks,\nI'd rather not", "No, I don't\nreally\nwant to"])];
		tree[i + 41] = ["%skip-minigame%"];
	}

	/**
	 * Supports <leader> <leaderhe> for the person who's giving the tutorial
	 */
	public function addRemoteExplanationHandoff(line:String)
	{
		this.remoteExplanationHandoffs.push(line);
	}

	public function popRemoteExplanationHandoff(tree:Array<Array<Object>>, leader:String, leaderGender:Gender)
	{
		var line:String = FlxG.random.getObject(remoteExplanationHandoffs);
		line = replaceLeader(line, leader, leaderGender);
		tree.push([line]);
	}

	/**
	 * Supports <leader> <leaderhe> for the person who's giving the tutorial
	 */
	public function addLocalExplanationHandoff(line:String)
	{
		this.localExplanationHandoffs.push(line);
	}

	public function popLocalExplanationHandoff(tree:Array<Array<Object>>, leader:String, leaderGender:Gender)
	{
		var line:String = FlxG.random.getObject(localExplanationHandoffs);
		line = replaceLeader(line, leader, leaderGender);
		tree.push([line]);
	}

	public function addIllSitOut(line:String)
	{
		illSitOuts.push(line);
	}

	public function addFineIllPlay(line:String)
	{
		fineIllPlays.push(line);
	}

	public function popPlayWithoutMe():Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		tree[0] = [FlxG.random.getObject(cast(illSitOuts))];
		tree[1] = [10, 30, 20];

		tree[10] = [FlxG.random.getObject(["Aw, well\nokay", "Hmm, if you\ninsist", "Well, that\nseems fair"])];
		tree[11] = [31];

		tree[20] = [FlxG.random.getObject(["Hey, don't be\nlike that!", "Aww, don't\nsit out!", "C'mon, play\nwith us!"])];
		tree[21] = [FlxG.random.getObject(cast(fineIllPlays))];

		tree[30] = [FlxG.random.getObject(["Huh?\nWhatever", "I don't\ncare", "Yeah, see\nyou later"])];
		tree[31] = ["%play-without-me%"];
		return tree;
	}

	private function popRoundStartLine(tree:Array<Array<Object>>, lines:Array<GameDialogLine>):GameDialogLine
	{
		var line:GameDialogLine;
		line = lines.splice(FlxG.random.int(0, lines.length - 1), 1)[0];
		if (line == null)
		{
			line = defaultRoundStarts[0];
		}
		line.generateDialog(tree);
		return line;
	}

	public function destroy()
	{
		roundStarts = null;
		defaultRoundStarts = null;
		winnings = null;
		losings = null;
		roundWins = null;
		roundLoses = null;
		stairReadies = null;
		defaultStairReady = null;
		stairPlayerStarts = null;
		defaultPlayerStarts = null;
		stairComputerStarts = null;
		defaultComputerStarts = null;
		stairOddsEvens = null;
		defaultOddsEvens = null;
		stairCheats = null;
		defaultStairCheat = null;
		stairCapturedComputers = null;
		defaultStairCapturedComputer = null;
		stairCapturedHumans = null;
		defaultStairCapturedHuman = null;
		closeGames = null;
		defaultCloseGame = null;
		gameStartQueries = null;
		playerBeatMes = null;
		beatPlayers = null;
		shortPlayerBeatMes = null;
		shortWeWereBeatens = null;
		postTutorialGameStarts = null;
		gameAnnouncements = null;
		remoteExplanationHandoffs = null;
		localExplanationHandoffs = null;
		skipMinigames = null;
		illSitOuts = null;
		fineIllPlays = null;
		gameStateClass = null;
	}
}

class GameDialogLine
{
	private static var DIALOG_SPACING:Int = 3;

	public var _dialog:String;
	public var _choices:Array<String>;

	public function new(dialog:String, choices:Array<String>)
	{
		this._dialog = dialog;
		this._choices = choices;
	}

	public function generateDialog(tree:Array<Array<Object>>, ?prepend:Array<Array<Object>> = null)
	{
		var lineIndex:Int = 0;
		if (prepend != null)
		{
			for (i in 0...prepend.length)
			{
				tree[i] = prepend[i];
			}
			lineIndex = prepend.length;
		}
		tree[lineIndex++] = [_dialog];
		var choiceInts:Array<Object> = [];
		for (i in 0..._choices.length)
		{
			var choice:String = _choices[i];
			var line:Int = lineIndex + (i + 1) * DIALOG_SPACING;
			tree[line] = [choice];
			choiceInts.push(line);
		}
		tree[lineIndex++] = choiceInts;
	}

	public function filterRound(tree:Array<Array<Object>>, roundNum:Int)
	{
		var lineIndex:Int = 0;
		while (lineIndex < tree.length)
		{
			DialogTree.replace(tree, lineIndex, "<round>", englishNumber(roundNum));
			lineIndex++;
		}
	}

	public function filterStairThrow(tree:Array<Array<Object>>, playerThrow:Int, computerThrow:Int)
	{
		var lineIndex:Int = 0;
		while (lineIndex < tree.length)
		{
			DialogTree.replace(tree, lineIndex, "<playerthrow>", englishNumber(playerThrow));
			DialogTree.replace(tree, lineIndex, "<Playerthrow>", capitalize(englishNumber(playerThrow)));
			DialogTree.replace(tree, lineIndex, "<computerthrow>", englishNumber(computerThrow));
			DialogTree.replace(tree, lineIndex, "<Computerthrow>", capitalize(englishNumber(computerThrow)));
			lineIndex++;
		}
	}

	public function filterLeader(tree:Array<Array<Object>>, ?leader:String, ?leaderGender:PlayerData.Gender)
	{
		var lineIndex:Int = 0;
		while (lineIndex < tree.length)
		{
			if (tree[lineIndex] != null && Std.isOfType(tree[lineIndex][0], String))
			{
				var line:String = tree[lineIndex][0];
				if (line.indexOf("|") != -1)
				{
					if (leader == PlayerData.name)
					{
						line = substringAfter(line, "|");
					}
					else
					{
						line = substringBefore(line, "|");
					}
				}
				line = GameDialog.replaceLeader(line, leader, leaderGender);
				tree[lineIndex][0] = line;
			}
			lineIndex++;
		}
	}

	public function toString():String
	{
		return "\"" + _dialog + "\"";
	}
}