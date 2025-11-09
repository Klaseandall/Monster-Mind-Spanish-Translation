package;

import MmStringTools.*;
import critter.Critter;
import critter.Critter.CritterColor;
import flixel.FlxG;
import kludge.BetterFlxRandom;
import openfl.utils.Object;
import poke.abra.AbraWindow;
import puzzle.PuzzleState;

/**
 * Pokemon have about 4 things they say when you click the help button, like
 * "What do you need?", "Let me ask Abra for a hint," and "See you later!"
 *
 * This class acts as a data model for all the phrases a particular Pokemon
 * says when you press the help button.
 */
class HelpDialog
{
	private var tree:Array<Array<Object>>;
	public var greetings:Array<Object>;
	public var goodbyes:Array<Object>;
	public var neverminds:Array<Object>;
	public var hints:Array<Object>;
	public var abraIntro:Array<Object> = ["#abra04#What's that? ...Oh, I see.", "#abra04#Hmm? Were you looking for me?", "#abra04#It's not too difficult is it? Oh, I understand."];
	public var counter:Int = 20;
	private var hintCounter:Int = 160;
	private var puzzleState:PuzzleState;

	public function new(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		this.tree = tree;
		this.puzzleState = puzzleState;
	}

	public function help():Void
	{
		var endIndex:Int = 10000;
		while (tree[endIndex] != null)
		{
			endIndex++;
		}

		if (puzzleState._pokeWindow._partAlpha == 0)
		{
			// pokemon's not around; they shouldn't talk
			greetings = [
				"#self00#(Hmmm. Nobody's around. Should I ask anyways?)",
				"#self00#(Where did they go? I wonder if they'll hear me.)",
				"#self00#(I don't see anyone to talk to, but I guess I'll try anyway.)",
			];

			goodbyes = [
				"#self00#(This isn't very much fun by myself.)",
				"#self00#(This is kind of boring without any Pokemon around.)",
				"#self00#(I'll go see if someone else is around.)",
			];

			neverminds = [
				"#self00#(...I guess I'll need to do this one on my own.)",
				"#self00#(...Being alone should make it easier to focus, but it's actually distracting me somehow.)",
				"#self00#(...When are they coming back? I guess I may as well solve this puzzle first.)",
			];

			hints = [
				"#self00#(I wonder if I can summon Abra's help through sheer force of will.)",
				"#self00#(Abra's telepathic... I wonder if " + (PlayerData.abraMale ? "he":"she") + " realizes I'm struggling with this puzzle?)",
				"#self00#(I'll just think about hints as hard as I can... Hints... Hints... Hints...)",
			];
		}
		if (puzzleState._askedHintCount > 0)
		{
			// we've asked for a hint already, skip the part where we run and get him
			skipGettingAbra();
		}

		tree[0] = [FlxG.random.getObject(greetings)];
		tree[1] = [100, 120, 140];
		tree[100] = [FlxG.random.getObject(["I think\nI'm done\nfor now", "I'm gonna\ncall it\nquits", "Sorry, I'm\ngonna take\noff"])];
		tree[101] = ["%disable-skip%"];
		tree[102] = ["%quit-soon%"];
		tree[103] = [FlxG.random.getObject(goodbyes)];
		tree[104] = ["%quit%"];
		tree[120] = [FlxG.random.getObject(["Nevermind", "Oops,\nsorry", "It's\nnothing"])];
		tree[121] = [FlxG.random.getObject(neverminds)];
		tree[140] = [FlxG.random.getObject(["Can you\ngive me\na hint?", "I could\nuse a hint", "I'm stuck,\ncan I have\na hint?"])];
		tree[141] = ["%fun-alpha0%"];
		tree[142] = [FlxG.random.getObject(hints)];
		tree[143] = [FlxG.random.getObject(["#zzzz04#...", "#zzzz05#...", "#zzzz00#..."])];
		tree[144] = ["%mark-29mjm3kq%"];
		tree[145] = [FlxG.random.getObject(abraIntro)];
		tree[146] = ["%hint-asked%"];
		tree[147] = ["%fun-alpha1%"];

		if (puzzleState._dispensedHintCount < puzzleState._allowedHintCount)
		{
			tree[148] = [FlxG.random.getObject([
				"#abra05#Mmm. I can sense you're really struggling with this one. Very well, I'll answer ONE question, so choose carefully.",
				"#abra05#Oh, this puzzle! I remember this one. Where are you stuck? What kind of information would help you the most right now?",
				"#abra05#Hmm yes, I can sense your frustration building. Sorry, these puzzles are supposed to be fun. What kind of help do you need?"
			])];
			tree[149] = [];
		}
		else {
			tree[145] = ["%noop%"];
			var timeTaken:Float = puzzleState._hintElapsedTime;
			var timeTakenStr:String;
			var timeRemainingStr:String;
			if (puzzleState._mainRewardCritter._rewardTimer <= 0)
			{
				timeTakenStr = null;
				timeRemainingStr = "a few minutes";
			}
			else {
				var timeRemaining:Float = Math.max(puzzleState._mainRewardCritter._rewardTimer, 60);
				timeTakenStr = DialogTree.durationToString(timeTaken);
				timeRemainingStr = DialogTree.durationToString(timeRemaining);
			}
			if (puzzleState._allowedHintCount == 0)
			{
				if (PlayerData.isAbraNice())
				{
					if (timeTakenStr == null)
					{
						tree[148] = ["#abra10#Ehhhh!? ...You're already asking for a hint? ...You haven't even been trying!"];
					}
					else
					{
						tree[148] = ["#abra10#Ehhhh!? ...You're already asking for a hint? ...It's only been like " + timeTakenStr + "..."];
					}
					tree[149] = ["#abra06#I can't just give you the answers right away, <name>. ...But if you're still stuck in " + timeRemainingStr + ", come ask me again, hmm?"];
					tree[150] = null;
				}
				else if (PlayerData.finalTrial)
				{
					tree[148] = ["#abra08#... ... -sigh- Do you really need a hint? ...This whole idea might be hopeless then. I don't know what I was thinking..."];
					tree[149] = ["#abra09#If you're still stuck in " + timeRemainingStr + ", ask me again, alright? ...But... I don't really see the point..."];
					tree[150] = null;
				}
				else
				{
					if (timeTakenStr == null)
					{
						tree[148] = ["#abra13#You're asking for a hint already? You should at least try solving the puzzle by yourself."];
					}
					else
					{
						tree[148] = ["#abra13#You're asking for a hint already? It's only been like " + timeTakenStr + "! You should at least try solving the puzzle by yourself."];
					}
					tree[149] = ["#abra12#Why don't you ask me again in " + timeRemainingStr + ". That'll give me time to decide if you're deserving of a hint."];
					tree[150] = null;
				}
			}
			else {
				if (PlayerData.isAbraNice())
				{
					if (timeTakenStr == null)
					{
						tree[148] = ["#abra10#Ehhhh!? ...You're already asking for another hint? ...You haven't even tried anything since I gave you that last hint..."];
					}
					else
					{
						tree[148] = ["#abra10#Ehhhh!? ...You're already asking for another hint? ...But it's only been like " + timeTakenStr + " since I gave you that last hint..."];
					}
					tree[149] = ["#abra06#Why don't you give it your best shot, and if you're still stuck in " + timeRemainingStr + "... I suppose you can come ask me for another hint. Is that fair?"];
					tree[150] = null;
				}
				else if (PlayerData.finalTrial)
				{
					tree[148] = ["#abra08#... ...-sigh- Well, the puzzle's already ruined, but... I still think it would be good practice if you can avoid using any more hints."];
					tree[149] = ["#abra09#...Why don't you think about it for " + timeRemainingStr + ". ...And I guess if you're still stuck, I can give you another hint."];
					tree[150] = null;
				}
				else {
					if (timeTakenStr == null)
					{
						tree[148] = ["#abra13#You're already asking for another hint? ...You haven't even tried anything since I gave you that last hint!"];
					}
					else {
						tree[148] = ["#abra13#You're already asking for another hint? ...It's only been like " + timeTakenStr + " since I gave you that last hint!"];
					}
					tree[149] = ["#abra12#-sigh- How about this, give it your best shot and if you're still stuck in " + timeRemainingStr + "... I suppose I'll see if you're deserving of another hint."];
					tree[150] = null;
				}
			}
		}

		if (puzzleState._dispensedHintCount == 0)
		{
			tree[300] = [FlxG.random.getObject([
				"#abra04#Give it some thought, experiment a little. If you're still stuck in a few minutes, maybe I can give you a bigger hint.",
				"#abra04#See what you can figure out using that information. If you're still stuck, come ask me again in a few minutes and I'll give you a bigger hint.",
				"#abra04#I know these puzzles can be tricky at first. You'll get there. If you still find yourself stuck in a few minutes, come ask for more help."
			])];
		}
		else {
			tree[300] = [FlxG.random.getObject([
				"#abra02#That's a pretty big hint, isn't it? I think you should be able to solve it on your own now. Good luck!",
				"#abra02#You should be able to get a lot from that hint! Take a look at the clues, and think about what I told you. You can do it!",
				"#abra02#Hmm, I feel like I sort of gave away the entire answer. Oh well, At the very least, you shouldn't be stuck anymore..."
			])];
		}

		tree[endIndex++] = ["%lights-on%"]; // some clues dim the lights
		tree[endIndex] = ["%fun-alpha1%"];

		if (puzzleState._dispensedHintCount < puzzleState._allowedHintCount)
		{
			addHints();
		}

		if (PlayerData.name == null)
		{
			// can't quit until we have your name
			tree[1].remove(100);
		}
		if (puzzleState._pokeWindow._partAlpha == 0)
		{
			// don't accidentally make the pokemon visible again
			tree[120] = [FlxG.random.getObject(["Hello?", "Is anybody\nthere?", "Ummm...?"])];
			tree[141] = ["%noop%"];
			tree[143] = ["#self00#..."];
			tree[147] = ["%noop%"];
			tree[endIndex] = ["%noop%"];
		}
	}

	private function addHints()
	{
		var hints:Array<Hint> = [];
		var critterColorsPresent:Array<CritterColor> = [];
		{
			var colorsPresent:Map<Int, Int>  = new Map<Int, Int>();
			for (c in puzzleState._puzzle._answer)
			{
				colorsPresent[c] = c;
			}
			for (color in colorsPresent.keys())
			{
				critterColorsPresent.push(Critter.CRITTER_COLORS[color]);
			}
		}
		if (puzzleState._dispensedHintCount == 0)
		{
			// small hint
			for (colorIndex in 0...puzzleState._puzzle._colorCount)
			{
				hints.push(new ColorExistsHint(Critter.CRITTER_COLORS[colorIndex], puzzleState._puzzle._answer.indexOf(colorIndex) != -1));
			}
			hints.push(new HowManyColorsHint(Lambda.count(critterColorsPresent)));

			if (!puzzleState._puzzle._easy)
			{
				for (i in 0...puzzleState._puzzle._clueCount)
				{
					if (puzzleState._puzzle._markers[i] % 10 > 0)
					{
						var clueAnalysis:ClueAnalysis = new ClueAnalysis(puzzleState._puzzle._guesses[i], puzzleState._puzzle._answer);
						// there are some markers in the wrong position
						hints.push(new WhichColorsInWrongPosition(i, clueAnalysis.wrongPosition));
					}
				}
			}
		}
		else if (puzzleState._dispensedHintCount == 1 || puzzleState._puzzle._easy)
		{
			// medium hint
			for (colorIndex in 0...puzzleState._puzzle._colorCount)
			{
				if (puzzleState._puzzle._answer.indexOf(colorIndex) != -1)
				{
					hints.push(new HowManyOfAColorHint(Critter.CRITTER_COLORS[colorIndex], Lambda.count(puzzleState._puzzle._answer, function(a) return a == colorIndex)));
				}
			}
			hints.push(new WhichColorsPresentHint(critterColorsPresent, puzzleState._puzzle._colorCount));
			var critterColorsAbsent:Array<CritterColor> = Critter.CRITTER_COLORS.slice(0, puzzleState._puzzle._colorCount);
			for (color in critterColorsPresent)
			{
				critterColorsAbsent.remove(color);
			}
			hints.push(new WhichColorsAbsentHint(critterColorsAbsent, puzzleState._puzzle._colorCount));

			{
				var maxColorCount:Int = 0;
				var colorCount:Map<CritterColor, Int> = new Map<CritterColor, Int>();
				for (color in puzzleState._puzzle._answer)
				{
					if (colorCount[Critter.CRITTER_COLORS[color]] == null)
					{
						colorCount[Critter.CRITTER_COLORS[color]] = 1;
					}
					else
					{
						colorCount[Critter.CRITTER_COLORS[color]]++;
					}
					maxColorCount = Std.int(Math.max(maxColorCount, colorCount[Critter.CRITTER_COLORS[color]]));
				}
				var mostColors:Array<CritterColor> = [];
				for (color in colorCount.keys())
				{
					if (colorCount[color] == maxColorCount)
					{
						mostColors.push(color);
					}
				}
				hints.push(new WhichColorIsThereMostOfHint(mostColors));
			}
		}
		else
		{
			// big hint
			for (i in 0...puzzleState._puzzle._clueCount)
			{
				if (puzzleState._puzzle._markers[i] >= 10)
				{
					// there are some markers in the right position
					var clueAnalysis:ClueAnalysis = new ClueAnalysis(puzzleState._puzzle._guesses[i], puzzleState._puzzle._answer);
					hints.push(new WhichColorsInRightPosition(i, clueAnalysis.rightPosition));
				}
			}

			for (color in critterColorsPresent)
			{
				var colorIndexes:Array<Int> = [];
				for (i in 0...puzzleState._puzzle._pegCount)
				{
					if (Critter.CRITTER_COLORS[puzzleState._puzzle._answer[i]] == color)
					{
						colorIndexes.push(i);
					}
				}
				hints.push(new WhereIsColorHint(color, colorIndexes, puzzleState._puzzle._pegCount));
			}

			for (i in 0...puzzleState._puzzle._pegCount)
			{
				hints.push(new WhichColorIsHereHint(i, Critter.CRITTER_COLORS[puzzleState._puzzle._answer[i]], puzzleState._puzzle._pegCount));
			}
		}
		hints.push(new NonsenseHint(puzzleState._puzzle._puzzleIndex));
		FlxG.random.shuffle(hints);
		for (i in 0...Std.int(Math.min(4, hints.length)))
		{
			addHint(hints[i]);
		}
	}

	public function removeExitOption()
	{
		var branch:Array<Int> = cast tree[1];
		branch.remove(100);
	}

	public function addCustomOption(choice:String, result:String)
	{
		var branch:Array<Int> = cast tree[1];
		branch.push(counter);
		tree[counter] = [choice];
		tree[counter + 1] = [result];
		counter += 5;
	}

	public function addHint(hint:Hint)
	{
		var branch:Array<Int> = cast tree[149];
		branch.push(hintCounter);
		var tmp:Int = hintCounter; // 160
		hintCounter = hint.writeHint(tree, hintCounter);
		DialogTree.shift(tree, tmp + 1, hintCounter, 1);
		hintCounter++;
		tree[tmp + 1] = ["%hint-given%"];
		tree[hintCounter++] = [300];

		hintCounter += 2;
	}

	public function skipGettingAbra()
	{
		hints = [146];
	}
}

class Hint
{
	public function writeHint(tree:Array<Array<Object>>, hintCounter:Int):Int
	{
		return hintCounter;
	};
}

class ColorExistsHint extends Hint
{
	private var critterColor:CritterColor;
	private var exists:Bool = false;

	public function new(critterColor:CritterColor, exists:Bool)
	{
		this.critterColor = critterColor;
		this.exists = exists;
	}

	override public function writeHint(tree:Array<Array<Object>>, hintCounter:Int):Int
	{
		tree[hintCounter++] = ["Are there\nany " + critterColor.english + "s\nin the\nanswer?"];
		if (exists)
		{
			tree[hintCounter++] = ["#abra06#Hmm? Well yes, of course there are some " + critterColor.english + " bugs in the answer. ...I don't think I should say how many, it would give away too much."];
		}
		else {
			tree[hintCounter++] = ["#abra06#Hmm? Well no, of course there aren't any " + critterColor.english + " bugs in the answer. ...Does that help any?"];
		}
		return hintCounter;
	}
}

class HowManyColorsHint extends Hint
{
	private var howMany:Int = 0;

	public function new(howMany:Int)
	{
		this.howMany = howMany;
	}

	override public function writeHint(tree:Array<Array<Object>>, hintCounter:Int):Int
	{
		tree[hintCounter++] = ["How many\ndifferent\ncolors are\nin the\nanswer?"];
		if (howMany == 1)
		{
			tree[hintCounter++] = ["#abra06#Hmm, there is only one color in the answer. I don't think I should say which one, it would give away too much."];
		}
		else {
			tree[hintCounter++] = ["#abra06#Hmm, there are " + englishNumber(howMany) + " different colors in the answer. I don't think I should say which ones, it would give away too much."];
		}
		return hintCounter;
	}
}

class HowManyOfAColorHint extends Hint
{
	private var critterColor:CritterColor;
	private var howMany:Int = 0;

	public function new(critterColor:CritterColor, howMany:Int)
	{
		this.critterColor = critterColor;
		this.howMany = howMany;
	}

	override public function writeHint(tree:Array<Array<Object>>, hintCounter:Int):Int
	{
		tree[hintCounter++] = ["How many\n" + critterColor.english + "s are\nin the\nanswer?"];
		if (howMany == 0)
		{
			tree[hintCounter++] = ["#abra06#Hmm, there actually aren't any " + critterColor.english +" bugs in the answer."];
		}
		else if (howMany == 1)
		{
			tree[hintCounter++] = ["#abra06#Hmm, there is only " + englishNumber(howMany) + " " + critterColor.english + " bug in the answer."];
		}
		else {
			tree[hintCounter++] = ["#abra06#Hmm, there are exactly " + englishNumber(howMany) + " " + critterColor.english +" bugs in the answer."];
		}
		return hintCounter;
	}
}

class WhichColorsPresentHint extends Hint
{
	private var critterColors:Array<CritterColor>;
	private var maxColors:Int = 0;

	public function new(critterColors:Array<CritterColor>, maxColors:Int)
	{
		this.critterColors = critterColors;
		this.maxColors = maxColors;
	}

	override public function writeHint(tree:Array<Array<Object>>, hintCounter:Int):Int
	{
		tree[hintCounter++] = ["Which colors\nare in\nthe answer?"];
		if (critterColors.length == 1)
		{
			tree[hintCounter++] = ["#abra06#Hmm, the answer has quite a few " + critterColors[0].english + "s in it. Surprisingly, that's the only color in the answer."];
		}
		else if (critterColors.length >= 2 && critterColors.length < maxColors)
		{
			var tmp:StringBuf = new StringBuf();
			for (i in 0...critterColors.length - 2)
			{
				tmp.add(critterColors[i].english + "s, ");
			}
			tmp.add(critterColors[critterColors.length - 2].english + "s and " + critterColors[critterColors.length - 1].english + "s");
			tree[hintCounter++] = ["#abra06#Hmm, the answer has some " + tmp.toString() + " in it. Those are the only colors in the answer."];
		}
		else if (critterColors.length == maxColors)
		{
			tree[hintCounter++] = ["#abra06#Hmm that's interesting, the answer actually has every single color in it."];
		}
		else {
			// No colors are present in the solution?
			tree[hintCounter++] = ["#abra07#Err.... Just a moment, I need to go lay down."];
			tree[hintCounter++] = null;
		}
		return hintCounter;
	}
}

class WhichColorsAbsentHint extends Hint
{
	private var critterColors:Array<CritterColor>;
	private var maxColors:Int = 0;

	public function new(critterColors:Array<CritterColor>, maxColors:Int)
	{
		this.critterColors = critterColors;
		this.maxColors = maxColors;
	}

	override public function writeHint(tree:Array<Array<Object>>, hintCounter:Int):Int
	{
		tree[hintCounter++] = ["Which colors\naren't in\nthe answer?"];
		if (critterColors.length == 0)
		{
			tree[hintCounter++] = ["#abra06#Hmm, the answer actually has every single color in it. Isn't that interesting?"];
		}
		else if (critterColors.length == 1)
		{
			tree[hintCounter++] = ["#abra06#Hmm, the answer doesn't have any " + critterColors[0].english + "s in it. All other colors are present in the answer."];
		}
		else if (critterColors.length >= 2 && critterColors.length < maxColors)
		{
			var tmp:StringBuf = new StringBuf();
			for (i in 0...critterColors.length - 2)
			{
				tmp.add(critterColors[i].english + "s, ");
			}
			tmp.add(critterColors[critterColors.length - 2].english + "s or " + critterColors[critterColors.length - 1].english + "s");
			tree[hintCounter++] = ["#abra06#Hmm, the answer doesn't have any " + tmp.toString() + " in it."];
		}
		else {
			// All colors are absent from the solution?
			tree[hintCounter++] = ["#abra07#Err.... Just a moment, I need to go lay down."];
			tree[hintCounter++] = null;
		}
		return hintCounter;
	}
}

class NonsenseHint extends Hint
{
	private var key:Int = 0;

	public function new(key:Int)
	{
		this.key = key;
	}

	override public function writeHint(tree:Array<Array<Object>>, hintCounter:Int):Int
	{
		var which:Int = Std.int(Math.min(FlxG.random.int(0, 4), FlxG.random.int(0, 5))); // number 0-4, but lower numbers are more likely
		if (which == 0)
		{
			tree[hintCounter++] = ["If the answer\nwere an ice\ncream flavor,\nwhich ice\ncream flavor\nwould it be?"];
			var flavors = ["peaches 'n cream", "oreo cheesecake", "salted caramel", "chocolate peppermint", "mocha almond fudge"];
			tree[hintCounter++] = ["#abra06#Hmm, if the answer were an ice cream flavor, it would definitely be " + flavors[key % flavors.length] + "."];
		}
		else if (which == 1)
		{
			tree[hintCounter++] = ["If the answer\nwere a pizza,\nwhat kind of\npizza would\nit be?"];
			var flavors = ["Honolulu Hawaiian", "pepperoni", "buffalo chicken pizza", "veggie lover's pizza", "sausage and green peppers", "extra cheese. Maybe with a stuffed crust"];
			tree[hintCounter++] = ["#abra06#Hmm, if the answer were a pizza? ...Definitely " + flavors[key % flavors.length] + "."];
		}
		else if (which == 2)
		{
			tree[hintCounter++] = ["If the answer were\na post-impressionist\npainting, which\npost-impressionist\npainting would\nit be?"];
			var paintings = ["Salvador Dali's Persistence of Memory", "Rene Magritte's Son Of Man", "Piet Mondrian's Tableau No. IV", "Pablo Picasso's Weeping Woman", "Georges Seurat's Sunday Afternoon on the Island of La Grande Jatte"];
			var dumbPaintings = ["the one by the ocean with the melty clocks", "the one with the posh-looking fellow and the apple", "the one with the straight lines and fancy colored squares", "the one with the girl with the sideways nose", "the one at the picnic with all of those tiny dots"];
			var painting:String = paintings[key % paintings.length];
			var dumbPainting:String = dumbPaintings[key % dumbPaintings.length];
			tree[hintCounter++] = ["#abra06#Hmm, if the answer were a post-impressionist painting, it would definitely be " + painting + "."];
			tree[hintCounter++] = ["#abra05#"+painting+"? Ring any bells?"];
			tree[hintCounter++] = ["#abra08#Oh right, sorry. It's " + dumbPaintings[key % dumbPaintings.length] + ". -cough-"];
		}
		else if (which == 3)
		{
			tree[hintCounter++] = ["If the answer\nhad to get rid\nof a dead body,\nwhat would\nit do?"];
			var deadBody = ["cut it into smaller pieces with a bone saw, and bury it ten feet deep in the woods, using a combination of dish soap and vinegar to cover up the smell",
			"dissolve it in a concentrated bath of hydroflouric acid, disposing of the remaining insoluble calcium shell in a landfill",
			"gain after-hours access to a steel mill and incinerate the body in a blast furnace",
			"cut the corpse into six pieces, tie it all together, and feed them to a bunch of pigs. He'd need about sixteen pigs to finish a body in one sitting"];
			tree[hintCounter++] = ["#abra11#Hmm... If the answer had to get rid of a dead body? Well, I suppose, hmmm..."];
			tree[hintCounter++] = ["#abra08#I imagine it would " + deadBody[key % deadBody.length] + "."];
			tree[hintCounter++] = ["#abra09#..."];
			tree[hintCounter++] = ["#abra10#Please don't ask me for any more hints."];
			tree[hintCounter++] = null;
		}
		else {
			tree[hintCounter++] = ["If the answer\ncould go back\nin time and\nmake one change\nin human history,\nwhat would it be?"];
			var humanHistory = ["prevent the burning of the libraries of alexandria",
			"educate scientists in the middle ages on the topics of penicillin, antiseptics and the basics of modern medicine",
			"have Trotsky take power in the Soviet Union instead of Stalin",
			"prevent Constantine from making Christianity the official religion of the Roman Empire"];
			tree[hintCounter++] = ["#abra04#Hmm, if the answer could travel back in time, it would " + humanHistory[key % humanHistory.length] + "."];
			if (key % humanHistory.length >= 2)
			{
				tree[hintCounter++] = ["#abra05#Now... That's not any sort of personal political statement, that's just what the answer would do. When you figure out the answer, you'll know what I mean."];
			}
		}
		return hintCounter;
	}
}

class WhichColorsInWrongPosition extends Hint
{
	var clueIndex:Int = 0;
	var wrongPosition:Array<CritterColor>;

	public function new(clueIndex:Int, wrongPosition:Array<CritterColor>)
	{
		this.clueIndex = clueIndex;
		this.wrongPosition = wrongPosition;
	}

	override public function writeHint(tree:Array<Array<Object>>, hintCounter:Int):Int
	{
		tree[hintCounter++] = ["Which bugs\nare in the\nwrong\nposition for\nclue #" + (clueIndex + 1) + "?"];
		tree[hintCounter++] = ["%lights-dim%"];
		tree[hintCounter++] = ["%lights-on-wholeclue" + clueIndex + "%"];
		if (wrongPosition.length == 1)
		{
			tree[hintCounter++] = ["#abra05#Hmm, there's a " + wrongPosition[0].english + " bug which is in the wrong position for clue #" + (clueIndex + 1) + "."];
		}
		else if (wrongPosition.length >= 2)
		{
			var map:Map<String, Int> = new Map<String, Int>();
			for (color in wrongPosition)
			{
				if (map[color.english] == null)
				{
					map[color.english] = 1;
				}
				else
				{
					map[color.english]++;
				}
			}
			var wrongBugStrings:Array<String> = [];
			for (color in map.keys())
			{
				wrongBugStrings.push(englishNumber(map[color]) + " " + color + " bug" + (map[color] == 1 ? "" : "s"));
			}
			var wrongBugBuf:StringBuf = new StringBuf();
			if (wrongBugStrings.length == 1)
			{
				wrongBugBuf.add(wrongBugStrings[0]);
			}
			else
			{
				for (i in 0...wrongBugStrings.length - 2)
				{
					wrongBugBuf.add(wrongBugStrings[i] + ", ");
				}
				wrongBugBuf.add(wrongBugStrings[wrongBugStrings.length - 2] + " and " + wrongBugStrings[wrongBugStrings.length - 1]);
			}
			tree[hintCounter++] = ["#abra05#Hmm, there's " + wrongBugBuf + " which are in the wrong position for clue #" + (clueIndex + 1) + "."];
		}
		else {
			// Nothing's in the right position?
			tree[hintCounter++] = ["#abra07#Err.... Just a moment, I need to go lay down."];
			tree[hintCounter++] = null;
		}
		tree[hintCounter++] = ["%lights-on%"];
		return hintCounter;
	}
}

class WhichColorsInRightPosition extends Hint
{
	var clueIndex:Int = 0;
	var rightPosition:Array<CritterColor>;

	public function new(clueIndex:Int, rightPosition:Array<CritterColor>)
	{
		this.clueIndex = clueIndex;
		this.rightPosition = rightPosition;
	}

	override public function writeHint(tree:Array<Array<Object>>, hintCounter:Int):Int
	{
		tree[hintCounter++] = ["Which bugs\nare in the\ncorrect\nposition for\nclue #" + (clueIndex + 1) + "?"];
		tree[hintCounter++] = ["%lights-dim%"];
		tree[hintCounter++] = ["%lights-on-wholeclue" + clueIndex + "%"];
		if (rightPosition.length == 1)
		{
			tree[hintCounter++] = ["#abra05#Hmm, there's a " + rightPosition[0].english + " bug which is in the correct position for clue #" + (clueIndex + 1) + "."];
		}
		else if (rightPosition.length >= 2)
		{
			var map:Map<String, Int> = new Map<String, Int>();
			for (color in rightPosition)
			{
				if (map[color.english] == null)
				{
					map[color.english] = 1;
				}
				else
				{
					map[color.english]++;
				}
			}
			var rightBugStrings:Array<String> = [];
			for (color in map.keys())
			{
				rightBugStrings.push(englishNumber(map[color]) + " " + color + " bug" + (map[color] == 1 ? "" : "s"));
			}
			var rightBugBuf:StringBuf = new StringBuf();
			if (rightBugStrings.length == 1)
			{
				rightBugBuf.add(rightBugStrings[0]);
			}
			else
			{
				for (i in 0...rightBugStrings.length - 2)
				{
					rightBugBuf.add(rightBugStrings[i] + ", ");
				}
				rightBugBuf.add(rightBugStrings[rightBugStrings.length - 2] + " and " + rightBugStrings[rightBugStrings.length - 1]);
			}
			tree[hintCounter++] = ["#abra05#Hmm, there's " + rightBugBuf + " which are in the correct position for clue #" + (clueIndex + 1) + "."];
		}
		else {
			// Nothing's in the right position?
			tree[hintCounter++] = ["#abra07#Err.... Just a moment, I need to go lay down."];
			tree[hintCounter++] = null;
		}
		tree[hintCounter++] = ["%lights-on%"];
		return hintCounter;
	}
}

class ClueAnalysis
{
	public var rightPosition:Array<CritterColor> = [];
	public var wrongPosition:Array<CritterColor> = [];

	public function new(clue:Array<Int>, answer:Array<Int>)
	{
		var answerTmp:Array<Int> = answer.copy();
		var clueTmp:Array<Int> = clue.copy();
		{
			var p:Int = 0;
			while (p < clueTmp.length)
			{
				if (clueTmp[p] == answerTmp[p])
				{
					rightPosition.push(Critter.CRITTER_COLORS[clueTmp[p]]);
					clueTmp.splice(p, 1);
					answerTmp.splice(p, 1);
				}
				else
				{
					p++;
				}
			}
		}
		{
			var p:Int = 0;
			while (p < clueTmp.length)
			{
				var c:Int = answerTmp.indexOf(clueTmp[p]);
				if (c != -1)
				{
					wrongPosition.push(Critter.CRITTER_COLORS[clueTmp[p]]);
					clueTmp.splice(p, 1);
					answerTmp.splice(c, 1);
				}
				else
				{
					p++;
				}
			}
		}
		rightPosition.sort(function(a, b) return Critter.CRITTER_COLORS.indexOf(a) - Critter.CRITTER_COLORS.indexOf(b));
		wrongPosition.sort(function(a, b) return Critter.CRITTER_COLORS.indexOf(a) - Critter.CRITTER_COLORS.indexOf(b));
	}
}

class WhichColorIsThereMostOfHint extends Hint
{
	var mostColors:Array<CritterColor>;

	public function new(mostColors:Array<CritterColor>)
	{
		this.mostColors = mostColors;
	}

	override public function writeHint(tree:Array<Array<Object>>, hintCounter:Int):Int
	{
		tree[hintCounter++] = ["In the\nanswer,\nwhich color\nis there\nmost of?"];
		if (mostColors.length == 1)
		{
			tree[hintCounter++] = ["#abra05#Hmm, there's more " + mostColors[0].english + " bugs in the answer than anything else."];
		}
		else if (mostColors.length >= 2)
		{
			var tmp:StringBuf = new StringBuf();
			for (i in 0...mostColors.length - 2)
			{
				tmp.add(mostColors[i].english + "s, ");
			}
			tmp.add(mostColors[mostColors.length - 2].english + "s and " + mostColors[mostColors.length - 1].english + "s");
			tree[hintCounter++] = ["#abra06#Hmm, it's actually tied. There's an equal number of " + tmp.toString() + " in the answer."];
		}
		else {
			// There's the most of nothing??
			tree[hintCounter++] = ["#abra07#Err.... Just a moment, I need to go lay down."];
			tree[hintCounter++] = null;
		}
		return hintCounter;
	}
}

class WhereIsColorHint extends Hint
{
	private var indexNames:Array<String>;
	private var color:CritterColor;
	private var indexes:Array<Int>;

	public function new(color:CritterColor, indexes:Array<Int>, pegCount:Int)
	{
		this.indexes = indexes;
		this.color = color;
		if (pegCount == 3)
		{
			indexNames == ["left", "middle", "right"];
		}
		else if (pegCount == 4)
		{
			indexNames = ["leftmost", "second-from-the-left", "second-from-the-right", "rightmost"];
		}
		else if (pegCount == 5)
		{
			indexNames = ["leftmost", "second-from-the-left", "centermost", "second-from-the-right", "rightmost"];
		}
		else
		{
			indexNames = ["upper-left", "upper-right", "left", "center", "right", "lower-left", "lower-right"];
		}
	}

	override public function writeHint(tree:Array<Array<Object>>, hintCounter:Int):Int
	{
		tree[hintCounter++] = ["Which bugs\nin the answer\nare " + color.english + "?"];
		if (indexes.length == 1)
		{
			tree[hintCounter++] = ["#abra05#Hmm, so the " + indexNames[indexes[0]] + " bug is the only " + color.english + " one."];
		}
		else if (indexes.length >= 2)
		{
			var tmp:StringBuf = new StringBuf();
			for (i in 0...indexes.length - 2)
			{
				tmp.add(indexNames[indexes[i]] + ", ");
			}
			tmp.add(indexNames[indexes[indexes.length - 2]]  + " and " + indexNames[indexes[indexes.length - 1]]);
			tree[hintCounter++] = ["#abra05#Hmm the " + tmp + " bugs are " + (indexes.length == 2 ? "both" : "all") + " " + color.english + "."];
		}
		else {
			// There are no bugs of this color. This isn't a valuable hint, we shouldn't give it here
			tree[hintCounter++] = ["#abra07#Err.... Just a moment, I need to go lay down."];
			tree[hintCounter++] = null;
		}
		return hintCounter;
	}
}

class WhichColorIsHereHint extends Hint
{
	private var indexNames0:Array<String>;
	private var indexNames1:Array<String>;
	private var indexNames2:Array<String>;
	private var index:Int = 0;
	private var color:CritterColor;

	public function new(index:Int, color:CritterColor, pegCount:Int)
	{
		this.color = color;
		this.index = index;
		if (pegCount == 3)
		{
			indexNames0 = ["on the left", "in the middle", "on the right"];
			indexNames1 = ["left bug", "center bug", "right bug"];
			indexNames2 = ["left bug", "center bug", "right bug"];
		}
		else if (pegCount == 4)
		{
			indexNames0 = ["on the far\nleft", "second from\nthe left", "second from\nthe right", "on the far\nright"];
			indexNames1 = ["leftmost bug", "bug second-from-the-left", "bug second-from-the-right", "rightmost bug"];
			indexNames2 = ["leftmost bug", "particular bug", "particular bug", "rightmost bug"];
		}
		else if (pegCount == 5)
		{
			indexNames0 = ["on the far\nleft", "second from\nthe left", "in the very\nmiddle", "second from\nthe right", "on the right"];
			indexNames1 = ["leftmost bug", "bug second-from-the-left", "bug directly in the center", "bug second-from-the-right", "rightmost bug"];
			indexNames2 = ["leftmost bug", "particular bug", "centermost bug", "particular bug", "rightmost bug"];
		}
		else
		{
			indexNames0 = ["in the\nupper-left", "in the\nupper-right", "on the\nleft", "in the\ncenter", "on the\nright", "in the\nlower-left", "in the\nlower-right"];
			indexNames1 = ["upper-left bug", "upper-right bug", "left bug", "center bug", "right bug", "lower-left bug", "lower-right bug"];
			indexNames2 = ["particular bug", "particular bug", "particular bug", "particular bug", "particular bug", "particular bug", "particular bug"];
		}
	}

	override public function writeHint(tree:Array<Array<Object>>, hintCounter:Int):Int
	{
		tree[hintCounter++] = ["What color\nis the bug\n" + indexNames0[index] + "?"];
		tree[hintCounter++] = ["#abra05#Hmm, so you're asking about the " + indexNames1[index] + "? ...That " + indexNames2[index] + " is " + color.english + "."];
		return hintCounter;
	}
}