package;

import MmStringTools.*;
import openfl.utils.Object;

/**
 * Pokemon have about 10-15 things they need to say while they're in the den,
 * such as "Here I am, let's play a game!" or "Really? You want to have sex
 * again!?" or "I'll see you next time, I'm exhausted!"
 *
 * This class acts as a data model for all the phrases a particular Pokemon
 * says in the den.
 */
class DenDialog
{
	private var replayMinigames:Array<DenReplayMinigame> = [];
	private var replaySexes:Array<DenReplaySex> = [];
	private var repeatSexGreetings:Array<Array<String>> = [];
	private var tooManyGames:Array<String> = [];
	private var tooMuchSex:Array<String> = [];
	private var gameGreeting:Array<String> = [];
	private var sexGreeting:Array<String> = [];

	public function new()
	{
	}

	public function addReplayMinigame(preliminaryLines:Array<String>, gameLines:Array<String>, sexLines:Array<String>, quitLines:Array<String>):Void
	{
		replayMinigames.push(new DenReplayMinigame(preliminaryLines, gameLines, sexLines, quitLines));
	}

	public function addReplaySex(preliminaryLines:Array<String>, sexLines:Array<String>, quitLines:Array<String>):Void
	{
		replaySexes.push(new DenReplaySex(preliminaryLines, sexLines, quitLines));
	}

	public function setGameGreeting(gameGreeting:Array<String>)
	{
		this.gameGreeting = gameGreeting;
	}

	public function setSexGreeting(sexGreeting:Array<String>)
	{
		this.sexGreeting = sexGreeting;
	}

	public function setTooManyGames(tooManyGames:Array<String>)
	{
		this.tooManyGames = tooManyGames;
	}

	public function setTooMuchSex(tooMuchSex:Array<String>)
	{
		this.tooMuchSex = tooMuchSex;
	}

	public function addRepeatSexGreeting(repeatSexGreeting:Array<String>)
	{
		repeatSexGreetings.push(repeatSexGreeting);
	}

	public function getRepeatSexGreeting(tree:Array<Array<Object>>)
	{
		var count:Int = getTotalMinigames() + PlayerData.denSexCount;

		var repeatSexGreeting:Array<String> = repeatSexGreetings[count % repeatSexGreetings.length];

		var nextLine:Int = 0;
		for (i in 0...repeatSexGreeting.length)
		{
			tree[nextLine++] = [repeatSexGreeting[i]];
		}

		/*
		 * ensure the player starts with a normal cursor, just in case it was
		 * zapped/lost/etc. This should be handled by accompanying dialog, but
		 * the user might skip it.
		 */
		tree[nextLine++] = ["%cursor-normal%"];
		tree[10000] = ["%cursor-normal%"];
	}

	public function getReplayMinigame(tree:Array<Array<Object>>)
	{
		var count:Int = getTotalMinigames();

		var replayMinigame:DenReplayMinigame = replayMinigames[count % replayMinigames.length];

		var nextLine:Int = 0;
		for (i in 0...replayMinigame.preliminaryLines.length)
		{
			tree[nextLine++] = [replayMinigame.preliminaryLines[i]];
		}
		tree[nextLine++] = [20, 40, 60];

		nextLine = 20;
		tree[nextLine++] = [replayMinigame.gameLines[0]];
		tree[nextLine++] = ["%den-game%"];
		for (i in 1...replayMinigame.gameLines.length)
		{
			tree[nextLine++] = [replayMinigame.gameLines[i]];
		}

		nextLine = 40;
		tree[nextLine++] = [replayMinigame.sexLines[0]];
		tree[nextLine++] = ["%den-sex%"];
		for (i in 1...replayMinigame.sexLines.length)
		{
			tree[nextLine++] = [replayMinigame.sexLines[i]];
		}

		nextLine = 60;
		tree[nextLine++] = [replayMinigame.quitLines[0]];
		tree[nextLine++] = ["%den-quit%"];
		for (i in 1...replayMinigame.quitLines.length)
		{
			tree[nextLine++] = [replayMinigame.quitLines[i]];
		}
	}

	public function getReplaySex(tree:Array<Array<Object>>)
	{
		var count:Int = getTotalMinigames() + PlayerData.denSexCount;

		var replaySex:DenReplaySex = replaySexes[count % replaySexes.length];

		var nextLine:Int = 0;
		if (replaySex.preliminaryLines.length == 1)
		{
			tree[nextLine++] = ["%fun-longbreak%"];
			tree[nextLine++] = [replaySex.preliminaryLines[0]];
		}
		else
		{
			tree[nextLine++] = [replaySex.preliminaryLines[0]];
			tree[nextLine++] = ["%fun-longbreak%"];
		}
		for (i in 1...replaySex.preliminaryLines.length)
		{
			tree[nextLine++] = [replaySex.preliminaryLines[i]];
		}
		tree[nextLine++] = [20, 40];
		nextLine = 20;
		tree[nextLine++] = [replaySex.sexLines[0]];
		tree[nextLine++] = ["%den-sex%"];
		for (i in 1...replaySex.sexLines.length)
		{
			tree[nextLine++] = [replaySex.sexLines[i]];
		}
		nextLine = 40;
		tree[nextLine++] = [replaySex.quitLines[0]];
		tree[nextLine++] = ["%den-quit%"];
		for (i in 1...replaySex.quitLines.length)
		{
			tree[nextLine++] = [replaySex.quitLines[i]];
		}
	}

	public static function getTotalMinigames():Int
	{
		var total:Int = 0;
		for (i in 0...PlayerData.minigameCount.length)
		{
			total += PlayerData.minigameCount[i];
		}
		return total;
	}

	public function getTooManyGames(tree:Array<Array<Object>>)
	{
		var nextLine:Int = 0;
		for (i in 0...tooManyGames.length)
		{
			tree[nextLine++] = [tooManyGames[i]];
		}
	}

	public function getTooMuchSex(tree:Array<Array<Object>>)
	{
		var nextLine:Int = 0;
		for (i in 0...tooMuchSex.length)
		{
			tree[nextLine++] = [tooMuchSex[i]];
		}
	}

	public function getGameGreeting(tree:Array<Array<Object>>, desc:String)
	{
		var nextLine:Int = 0;
		for (i in 0...gameGreeting.length)
		{
			var line:String = gameGreeting[i];
			line = StringTools.replace(line, "<minigame>", desc);
			line = StringTools.replace(line, "<Minigame>", capitalize(desc));
			tree[nextLine++] = [line];
		}
	}

	public function getSexGreeting(tree:Array<Array<Object>>)
	{
		var nextLine:Int = 0;
		for (i in 0...sexGreeting.length)
		{
			tree[nextLine++] = [sexGreeting[i]];
		}
	}
}

class DenReplayMinigame
{
	public var preliminaryLines:Array<String>;
	public var gameLines:Array<String>;
	public var sexLines:Array<String>;
	public var quitLines:Array<String>;

	public function new(preliminaryLines:Array<String>, gameLines:Array<String>, sexLines:Array<String>, quitLines:Array<String>):Void
	{
		this.preliminaryLines = preliminaryLines;
		this.gameLines = gameLines;
		this.sexLines = sexLines;
		this.quitLines = quitLines;
	}
}

class DenReplaySex
{
	public var preliminaryLines:Array<String>;
	public var sexLines:Array<String>;
	public var quitLines:Array<String>;

	public function new(preliminaryLines:Array<String>, sexLines:Array<String>, quitLines:Array<String>):Void
	{
		this.preliminaryLines = preliminaryLines;
		this.sexLines = sexLines;
		this.quitLines = quitLines;
	}
}