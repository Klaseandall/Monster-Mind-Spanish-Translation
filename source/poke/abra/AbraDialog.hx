package poke.abra;

import MmStringTools.*;
import flixel.math.FlxRandom;
import kludge.BetterFlxRandom;
import minigame.tug.TugGameState;
import poke.hera.HeraShopDialog;
import minigame.GameDialog;
import minigame.MinigameState;
import minigame.scale.ScaleGameState;
import poke.buiz.BuizelDialog;
import critter.Critter;
import flixel.FlxG;
import flixel.addons.display.shapes.FlxShapeDoubleCircle;
import poke.hera.HeraDialog;
import openfl.utils.Object;
import PlayerData.hasMet;
import minigame.stair.StairGameState;
import puzzle.ClueDialog;
import puzzle.PuzzleState;
import puzzle.RankTracker;

/**
 * Abra met Grovyle and Buizel in college, and bought a four-bedroom house
 * shortly after graduating. She lives with Grovyle, Buizel and Sandslash.
 * 
 * Grovyle and Abra were randomly paired as roommates. Abra is naturally
 * introverted, but Grovyle helped her open up for awhile.
 * 
 * Buizel attended the same college as Abra, and they became friends. Abra
 * could sort of relate to Buizel's "fish out of water" discomfort of attending
 * college far away from home, because Abra's never really felt at home
 * anywhere.
 * 
 * Sandslash simply answered a craigslist ad for a roommate. He was looking for
 * a cheap place to live and Abra undercharged, because she didn't particularly
 * need the money.
 * 
 * Being in college forced Abra to interact with people in simple ways like
 * attending class, going out to eat, or having a roommate. After graduation,
 * Abra inadvertently became more reclusive, as things like food and work could
 * be handled remotely, and she had her own bedroom. This wore down on her over
 * time and she became depressed and created Monster Mind as a way of
 * addressing her depression.
 * 
 * Depending on the actions chosen by the player in MonsterMind, Abra either
 * swaps consciousnesses and adapts to human life, or overcomes her depression
 * by realizing she's not alone in the universe, and that she's surrounded by
 * friends who care about her even when she pushes them away.
 * 
 * Abra designed MonsterMind as a way of finding a good match for her
 * consciousness swap. She needed someone with a not-too-smart not-too-dumb
 * kind of brain, so she came up with the puzzles to measure. She also needed
 * someone who would be happy in the body of a Pokemon, which is why the game
 * targets poke-perverts.
 * 
 * If you go through her 5-peg puzzle tutorial, (which is a completely
 * unhelpful joke tutorial,) Abra will introduce you to the idea of 7-peg
 * puzzles. After finishing the 7-peg puzzle, further puzzles can be selected
 * from the main menu by clicking her head. 7-peg puzzles do not offer any
 * gameplay reward, but Abra gets off on watching you struggle with them.
 * 
 * Abra is far more intelligent than anybody else in the house, and is fully
 * aware of it. She often comes across as arrogant or demeaning. Over the
 * course of the game, she tries to get better about masking this but it's
 * difficult for her.
 * 
 * As far as minigames go, Abra basically plays all three games perfectly. She
 * solves the scale puzzles instantly, but it still takes her several seconds
 * to move the bugs to the scales, so she can be beaten if you are more
 * dextrous than her. She deliberately adopts a suboptimal strategy to the
 * stair game in an effort to "out-think" the player.
 * 
 * ---
 * 
 * When writing dialog, I think it's good to have an inner voice in your head
 * for each character so that they behave and speak consistently. Abra's
 * inner voice was Starscream or sometimes Invader Zim.
 * 
 * Always referencing her IQ, which fluctuates between 600 and 900
 * 
 * Vocal tics: Eeh-heheheh! Bahahahaha
 * 
 * Ludicrously good at puzzles (10x as fast as rank 65)
 */
class AbraDialog
{
	private static var _intA:Int = 0;
	private static var _intB:Int = 0;

	public static var FINAL_CHAT_INDEX:Int = 5;
	public static var prefix:String = "abra";
	public static var sexyBeforeChats:Array<Dynamic> = [sexyBefore0, sexyBefore1, sexyBefore2, sexyBefore3];
	public static var sexyBefore7Peg:Array<Dynamic> = [sexyBefore7Peg0, sexyBefore7Peg1, sexyBefore7Peg2];
	public static var sexyAfterChats:Array<Dynamic> = [sexyAfter0, sexyAfter1, sexyAfter2, sexyAfter3];
	public static var sexyBeforeBad:Array<Dynamic> = [sexyBadHead, sexyBadBelly, sexyBadButt, sexyBadFeet, sexyBadChest, sexyBadShoulders, sexyBadBalls, sexyBadCravesAnal, sexyBeforeJustFinishedGame];
	public static var sexyAfterGood:Array<Dynamic> = [sexyAfterGood0, sexyAfterGood1];
	public static var fixedChats:Array<Dynamic> = [vocabulary, iqBrag, story0, story1, story2, story3, epilogue];
	public static var random7Peg:Array<Array<Dynamic>> = [[random7Peg0, random7Peg1, random7Peg2, random7Peg3]];
	public static var randomChats:Array<Array<Dynamic>> = [
				[random00, random01, random02, random03, random04],
				[random10, random11, random12, random13],
				[random20, random21, random22, random23]];

	public static function getFinalTrialCount():Int
	{
		return Math.ceil(PlayerData.recentChatCount("abra.fixedChats." + FINAL_CHAT_INDEX) / 3);
	}

	public static function getUnlockedChats():Map<String, Bool>
	{
		var unlockedChats:Map<String, Bool> = new Map<String, Bool>();

		// story chats are disabled
		unlockedChats["abra.fixedChats.2"] = false;
		unlockedChats["abra.fixedChats.3"] = false;
		unlockedChats["abra.fixedChats.4"] = false;
		unlockedChats["abra.fixedChats.5"] = false;
		unlockedChats["abra.fixedChats.6"] = false;

		unlockedChats["abra.fixedChats.0"] = !PlayerData.isAbraNice(); // vocabulary chat is mean...

		unlockedChats["abra.random7Peg.0.3"] = hasMet("sand") && hasMet("kecl");
		unlockedChats["abra.sexyBeforeChats.3"] = PlayerData.magnButtPlug > 4;
		return unlockedChats;
	}

	public static function clueBad(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (!puzzleState._abraAvailable || cast(puzzleState._pokeWindow, AbraWindow)._passedOut)
		{
			// nobody can help you.
			tree[0] = ["%lights-on%"];
			return;
		}
		if (cast(puzzleState._pokeWindow, AbraWindow)._drunkAmount >= 2)
		{
			var clueDialog:ClueDialog = new ClueDialog(tree, puzzleState);
			clueDialog.setGreetings(["#abra04#The ehhh, the <first clue>'s isn't fit your answer... Like ehhhh yeah?",
									 "#abra04#Look lillittle closer at the <first clue>... Dooooo you see what did wrong?",
									 "#abra04#Ah, ss-syes, a minor oversight. Lookkkl closer at the <first clue>.",
									]);
			if (clueDialog.actualCount > clueDialog.expectedCount)
			{
				clueDialog.pushExplanation("#abra06#How do I 'splain this. Well that <first clue>'s got <e hearts>, right?");
				clueDialog.fixExplanation("clue's got zero", "clue doesn't have any");
				clueDialog.pushExplanation("#abra08#So that means when we compare it to your answer, there shouldlngly be <e bugs in the correct position>... But if you count carefully, you'll see there's <a>.");
				clueDialog.fixExplanation("should only be zero", "shouldn't be any");
				clueDialog.pushExplanation("#abra04#Try to find an answer where the <first clue> has exactly <e bugs in the correct position>. An-anaffanind help, hit that button in the corner, alright?");
				clueDialog.fixExplanation("clue has exactly zero", "clue doesn't have any");
			}
			else
			{
				clueDialog.pushExplanation("#abra06#How do I 'splain this. Well that <first clue>'s got <e hearts>, right?");
				clueDialog.pushExplanation("#abra08#So that means when we compare it to your answer, there shouldlngly be <e bugs in the correct position>... But if you count carefully, you'll see there's only <a>.");
				clueDialog.fixExplanation("count carefully, you'll see there's only zero", "look carefully, you'll see there aren't any");
				clueDialog.pushExplanation("#abra04#Try to find an answer where the <first clue> has exactly <e bugs in the correct position>. An-anaffanind help, hit that button in the corner, alright?");
			}
		}
		else
		{
			var clueDialog:ClueDialog = new ClueDialog(tree, puzzleState);
			clueDialog.setGreetings(["#abra04#Yes, the <first clue> doesn't fit your answer... Do you understand your mistake?",
									 "#abra04#Look closer at the <first clue>... Do you see what you did wrong?",
									 "#abra04#Ah, yes, a minor oversight. Look closer at the <first clue>.",
									]);
			if (clueDialog.actualCount > clueDialog.expectedCount)
			{
				clueDialog.pushExplanation("#abra06#How do I explain this. Well that <first clue>'s got <e hearts>, right?");
				clueDialog.fixExplanation("clue's got zero", "clue doesn't have any");
				clueDialog.pushExplanation("#abra08#So that means when we compare it to your answer, there should only be <e bugs in the correct position>... But if you count carefully, you'll see there's <a>.");
				clueDialog.fixExplanation("should only be zero", "shouldn't be any");
				clueDialog.pushExplanation("#abra04#Try to find an answer where the <first clue> has exactly <e bugs in the correct position>. If you need more help, hit that button in the corner, alright?");
				clueDialog.fixExplanation("clue has exactly zero", "clue doesn't have any");
			}
			else
			{
				clueDialog.pushExplanation("#abra06#How do I explain this. Well that <first clue>'s got <e hearts>, right?");
				clueDialog.pushExplanation("#abra08#So that means when we compare it to your answer, there should be <e bugs in the correct position>... But if you count carefully, you'll see there's only <a>.");
				clueDialog.fixExplanation("count carefully, you'll see there's only zero", "look carefully, you'll see there aren't any");
				clueDialog.pushExplanation("#abra04#Try to find an answer where the <first clue> has exactly <e bugs in the correct position>. If you need more help, hit that button in the corner, alright?");
			}
		}
	}

	/**
	 * Specifically for 7-peg puzzles, your answer had two adjacent bugs so the
	 * clues are irrelevant. Your answer is invalid
	 */
	public static function invalidAnswer(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (cast(puzzleState._pokeWindow, AbraWindow)._passedOut || cast(puzzleState._pokeWindow, AbraWindow)._passedOut)
		{
			// nobody can help you.
			tree[0] = ["%lights-on%"];
			return;
		}
		tree[0] = [FlxG.random.getObject(["#abra04#Yes, your answer has two <red> bugs next to each other. Do you remember that rule?",
										  "#abra04#You're not supposed to have any <red> bugs next to each other. Do you see what you did wrong?",
										  "#abra04#Ah, yes, a minor oversight. Do you see those two <red> bugs?",
										 ])];
		var invalidColor:String = "hmm...";
		var playerGuess:Array<Int> = puzzleState.getPlayerGuess();
		if (playerGuess[3] == playerGuess[0] ||
				playerGuess[3] == playerGuess[1] ||
				playerGuess[3] == playerGuess[2] ||
				playerGuess[3] == playerGuess[4] ||
				playerGuess[3] == playerGuess[5] ||
				playerGuess[3] == playerGuess[6])
		{
			invalidColor = Critter.CRITTER_COLORS[playerGuess[3]].english;
		}
		else if (playerGuess[0] == playerGuess[1] || playerGuess[0] == playerGuess[2])
		{
			invalidColor = Critter.CRITTER_COLORS[playerGuess[0]].english;
		}
		else if (playerGuess[4] == playerGuess[1] || playerGuess[4] == playerGuess[6])
		{
			invalidColor = Critter.CRITTER_COLORS[playerGuess[4]].english;
		}
		else if (playerGuess[5] == playerGuess[2] || playerGuess[5] == playerGuess[6])
		{
			invalidColor = Critter.CRITTER_COLORS[playerGuess[5]].english;
		}
		tree[1] = [10, 20, 30];
		tree[10] = [FlxG.random.getObject(["Oops", "Crap", "Ugh"])];
		tree[20] = [FlxG.random.getObject(["Yeah", "I see", "Right"])];
		tree[30] = [FlxG.random.getObject(["What?", "Huh?", "Ehh?", "I don't\nget it"])];
		tree[31] = ["#abra06#For these seven-peg puzzles, your answer can't have two of the same color bugs next to each other."];
		tree[32] = ["#abra08#But unfortunately, your answer has two <red> bugs touching. Do you see them?"];
		tree[33] = ["#abra04#Try to find an answer where those <red> bugs have more space between them. If you need help, hit that button in the corner, alright?"];
		DialogTree.replace(tree, 0, "<red>", invalidColor);
		DialogTree.replace(tree, 32, "<red>", invalidColor);
		DialogTree.replace(tree, 33, "<red>", invalidColor);
	}

	static private function newHelpDialog(tree:Array<Array<Object>>, puzzleState:PuzzleState, minigame:Bool=false):HelpDialog
	{
		var helpDialog:HelpDialog = new HelpDialog(tree, puzzleState);

		helpDialog.greetings = [
			"#abra04#Mmm? Did you need something?",
			"#abra04#Did you need my help for anything?",
			"#abra04#Yes, are you having some kind of trouble?",
		];

		helpDialog.goodbyes = [
			"#abra10#Wah, don't leave me! I have abra-ndonment issues!",
			"#abra08#But... But don't you want to see how it ends?",
			"#abra08#Hmm yes, I see. This one may have been too advanced.",
			"#abra10#In the middle of a puzzle? ...was it something I said?",
		];

		helpDialog.neverminds = [
			"#abra05#Alright, come on! The puzzle's not going to solve itself.",
			"#abra05#I'm getting bored over here! Let's move things along.",
			"#abra05#Do you want me to do the puzzle for you? Because I'll do it for you! Actually, I won't.",
		];

		if (minigame)
		{
			helpDialog.goodbyes = [
				"#abra10#Wah, don't leave me! I have abra-ndonment issues!",
				"#abra08#But... But don't you want to see how it ends?",
				"#abra08#Hmm yes, I see. This one may have been too advanced."
			];

			helpDialog.neverminds = [
				"#abra05#I'm getting bored over here! Let's move things along.",
				"#abra05#Hmmm, this game doesn't usually last this long.",
				"#abra05#Hmmm, alright...",
			];
		}

		if (puzzleState != null && cast(puzzleState._pokeWindow, AbraWindow)._passedOut)
		{
			// abra's passed out; they shouldn't talk
			helpDialog.greetings = [
				"#self04#(Hmmm. Looks like Abra's passed out. Should I ask anyways?)",
				"#self04#(I guess... Abra's passed out? I wonder if " + (PlayerData.abraMale?"he'll":"she'll") +" hear me...)",
				"#self04#(I don't think Abra will hear me, but it wouldn't hurt to ask.)",
			];

			helpDialog.goodbyes = [
				"#self05#(This isn't very much fun by myself.)",
				"#self05#(What the heck, Abra...)",
				"#self05#(I'll go see if someone else is around.)",
			];

			helpDialog.neverminds = [
				"#self06#(...I guess I'll need to do this one on my own.)",
				"#self06#(...Being alone should make it easier to focus, but it's actually distracting me somehow.)",
				"#self06#(...When is Abra going to wake up? I guess I may as well solve this puzzle first.)",
			];
		}
		else if (puzzleState != null && cast(puzzleState._pokeWindow, AbraWindow)._drunkAmount >= 2)
		{
			// abra's drunk; should slur speech
			helpDialog.greetings = [
				"#abra04#Mmmmm? Did you ehghhh, did you need something?",
				"#abra04#Didjouu need my help for anything?",
				"#abra04#Yes, are you havening some kind of trouble?",
			];

			helpDialog.goodbyes = [
				"#abra10#Don't but my don't leave me! ...Brandonment issues...",
				"#abra10#Is it? But why'ds the... Ooghh...",
			];

			helpDialog.neverminds = [
				"#abra05#C'mon puzzle's not... Not gonna, not gonna solve self...",
				"#abra05#Getting boooorrrred over here, <name>... Aren't you finished yet?",
				"#abra05#Don't you want me to can't... solve the puzzle for you!? Ehh...",
			];
		}

		// Abra doesn't need to leave to get himself.
		helpDialog.skipGettingAbra();
		return helpDialog;
	}

	public static function help(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var helpDialog:HelpDialog = newHelpDialog(tree, puzzleState);

		helpDialog.help();

		if (cast(puzzleState._pokeWindow, AbraWindow)._passedOut)
		{
			tree[141] = ["%noop%"]; // don't leave
		}
		if (PlayerData.finalTrial)
		{
			if (cast(puzzleState._pokeWindow, AbraWindow)._passedOut)
			{
				tree[147] = [FlxG.random.getObject([
													   "#self07#(Huh, yeah. ...I guess hints are out of the question...)",
													   "#self07#(I guess Abra can't give me a hint in " + (PlayerData.abraMale?"his":"her") + " current condition...)",
													   "#self07#(Hmm. ...No response...)",
												   ])];
				tree[148] = null;
				tree[149] = null;
			}
			else if (puzzleState._dispensedHintCount < puzzleState._allowedHintCount)
			{
				if (PlayerData.finalTrial)
				{
					tree[148] = [FlxG.random.getObject([
														   "#abra08#Ohhhh, do you REALLY need a hint? ...Using a hint really ruins any chance at getting our brains in sync...",
														   "#abra08#... ...I can give you a hint if you REALLY need it, but... I was really hoping you could get by without one this time.",
														   "#abra08#Asking for a hint on a ranked puzzle will completely ruin your rank, <name>. ... ...Did you REALLY need a hint?",
													   ])];
				}
			}
		} if (!puzzleState._abraAvailable)
		{
			var index:Int = DialogTree.getIndex(tree, "%mark-29mjm3kq%") + 1; // don't overwrite the mark
			tree[index++] = ["%noop%"];
			tree[index++] = ["#self00#(...Nope, I guess nobody's around...)"];
			tree[index++] = null;
		}
	}

	public static function minigameHelp(tree:Array<Array<Object>>, minigameState:MinigameState)
	{
		gameDialog(Type.getClass(minigameState)).help(tree, newHelpDialog(tree, null, true));
	}

	public static function tutorialHelp(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		puzzleState._tutorial(tree);
		DialogTree.shift(tree, 0, 5000, 1000);
		var helpDialog:HelpDialog = newHelpDialog(tree, puzzleState);
		helpDialog.help();

		var mark:String = PuzzleState.DIALOG_VARS[0] == 1 ? "startovercomplete" : "startover";
		helpDialog.addCustomOption("Can you\nexplain\nthat again?", "%jumpto-" + mark + "%");
	}

	public static function gameDialog(gameStateClass:Class<MinigameState>):GameDialog
	{
		var g:GameDialog = new GameDialog(gameStateClass);

		if (PlayerData.playerIsInDen)
		{
			g.addSkipMinigame(["#abra05#...Very well, we don't have to play if you don't want to.", "#abra00#Hmm, I suppose I can find a different way to reward you. Mmm, yes~"]);
		}
		else {
			g.addSkipMinigame(["#abra05#...Very well, you don't have to play if you don't want to. That lucky coin isn't meant to be a punishment after all.", "#abra00#Hmm, I suppose I can find a different way to reward you. Mmm, yes~"]);
		}
		if (PlayerData.abraMale)
		{
			g.addSkipMinigame(["#abra05#I see. Not enough penises in this game, is that it? Tsk, you've got such a one-track mind when it comes to this sort of thing.", "#abra00#Well, I can have a one-track mind too~"]);
		}
		else {
			g.addSkipMinigame(["#abra05#I see. Not enough vaginas in this game, is that it? Tsk, you've got such a one-track mind when it comes to this sort of thing.", "#abra00#Well, I can have a one-track mind too~"]);
		}

		g.addRemoteExplanationHandoff("#abra04#<leader> likes to explain this one. Let me see if I can find <leaderhim>.");

		g.addLocalExplanationHandoff("#abra04#<leader>, why don't you explain this one. That way I can make sure you have the rules straight.");

		g.addPostTutorialGameStart("#abra05#Simple enough, yes? Should we start?");

		if (PlayerData.isAbraNice())
		{
			g.addIllSitOut("#abra04#I think this will be more fun if you play without me. Sorry! We'll play next time~");
			g.addIllSitOut("#abra04#Hmm, why don't you play this game without me. ...I think you'll have more fun that way.");
		}
		else {
			g.addIllSitOut("#abra04#I'll sit out this game. You're still new to this, <name>, and I wouldn't want to bruise your ego.");
			g.addIllSitOut("#abra04#Obviously, I'm not going to play with you myself, <name>. It wouldn't even be a challenge.");
			g.addIllSitOut("#abra04#Yes, yes, you can play without me. An intellectual competition with an abra would have... predictable results.");
		}

		g.addFineIllPlay("#abra08#Hmph well, if you insist. For the record, this wasn't my idea.");
		g.addFineIllPlay("#abra03#Eee-heheheh! Very well. I'll try to go easy on you.");
		g.addFineIllPlay("#abra03#I don't know HOW you expect this to go, but... Well... I'll play with you, <name>.");

		if (PlayerData.isAbraNice())
		{
			g.addGameAnnouncement("#abra04#I think you should practice <minigame> today. ...It'll help toughen up some of the mushier parts of your brain.");
		}
		else {
			g.addGameAnnouncement("#abra04#I think you should practice <minigame> today. It might help you improve some of your... weaker points.");
		}
		g.addGameAnnouncement("#abra04#How do you feel about <minigame>? Nevermind, I see how you feel. Well, that's too bad.");
		g.addGameAnnouncement("#abra04#Ah yes, it's <minigame>. Well, this should be some easy money for you, shouldn't it?");

		g.addGameStartQuery("#abra05#Shall we begin?");
		if (PlayerData.isAbraNice())
		{
			g.addGameStartQuery("#abra06#Hmm, I can sense some confusion? ...Or ehhh... Well, you're either confused or horny. ...Maybe we should just start?");
		}
		else {
			g.addGameStartQuery("#abra06#Hmm, I can sense some confusion. Is that just your usual sort of, \"all the time\" confusion? Should we just start?");
		}
		if (PlayerData.denGameCount == 0)
		{
			g.addGameStartQuery("#abra05#Yes, yes, I'm sorry. I can't give you your favorite minigame every time or you'd get tired of it. Is this one okay?");
		}
		else {
			g.addGameStartQuery("#abra03#Well somebody's certainly a glutton for punishment. Eh-heheheh. ...Are you ready for your next lesson?");
		}

		g.addRoundStart("#abra04#Well, with that I suppose it's time for round <round>. If you're ready.", ["Ugh...", "Yes, I'm\nready...", "Can you just quit?\nWe know you'll win"]);
		g.addRoundStart("#abra05#I'm sensing some mental fatigue... Did you want a break before round <round>?", ["Will this\never end?", "I'm fatigued from putting\nup with you, Abra", "Maybe a short\nbreak..."]);
		g.addRoundStart("#abra04#Hmm well... Let's try to forget about that last round. Are you ready for round <round>?", ["Yes, I'm\nready", "Ugh...", "You make everything\nso painful, Abra"]);
		g.addRoundStart("#abra03#Ah! I just got my second abra wind. Just in time for round <round>.", ["Second wind?\nUh oh....", "Meh,\nwhatever", "Heh! I can\ntake you"]);

		if (PlayerData.isAbraNice())
		{
			g.addRoundWin("#abra08#...Sorry, next time I'll let you play with someone else instead. ...This probably isn't fun for you.", ["Oh, don't worry\nabout it", "Go fuck\nyourself, Abra", "Well, I'm having\nan off-day"]);
		}
		else {
			g.addRoundWin("#abra08#...Sorry, I probably shouldn't be playing against you. Somehow I thought you'd be better at this.", ["Oh, don't worry\nabout it", "Go fuck\nyourself, Abra", "Well, I'm having\nan off-day"]);
			g.addRoundWin("#abra04#Hmmm. That was an interesting performance. Are you sure you understand the rules?", ["I understand\nthe rules, asshole", "Ummm,\nwell...", "This is\nreally hard"]);
		}
		g.addRoundWin("#abra04#Hmm, how about if I keep one hand behind my back? ...This feels like cheating.", ["Cheater!", "Ugh, this\nsucks...", "Wait, you were\nusing both hands!?"]);
		g.addRoundWin("#abra05#I know this is painful, but it's the only way you'll learn.", ["I'm learning what\na " + (PlayerData.abraMale ? "prick" : "bitch") + " you are", "I'll get there\nsome day", "It's so\nfrustrating"]);
		g.addRoundWin("#abra04#...Did you give up? You won't win if you just give up all the time.", ["I can't win,\nso whatever", "...I didn't\ngive up", "This is just\nreally hard"]);
		g.addRoundWin("#abra02#You almost had that one, <name>. You just need to be a tiny bit faster.", ["I can't tell if you're\nbeing sarcastic...", "Bleahhhh...", "Whatever, this\nis hopeless"]);

		g.addRoundLose("#abra04#Hmm, should I start playing for real now? ...Well, I guess I can let you win ONE more.", ["Excuses,\nexcuses", "C'mon, play\nfor real", "I thought you\nwere good at this?"]);
		if (gameStateClass == ScaleGameState) g.addRoundLose("#abra04#I thought it might be nice to let someone else get one.", ["How generous\nof you", "Yeah, sure\nyou did", "Ohhh, is\nthat why..."]);
		if (gameStateClass == TugGameState) g.addRoundLose("#abra04#I thought it might be nice to let you win one, for a change.", ["How generous\nof you", "Yeah, sure\nyou did", "Ohhh, is\nthat why..."]);
		g.addRoundLose("#abra06#That was pretty easy wasn't it <leader>? ...Now you just need to do that every time.", ["It was just\nluck...", "Hmmm...", "Yeah, seems\neasy..."]);

		if (PlayerData.isAbraNice())
		{
			g.addWinning("#abra08#I really love playing these minigames but... I just wish they weren't always so mismatched. Sorry, <name>.", ["Ugh...", "Will you just\nshut up...", "It's fine..."]);
			g.addWinning("#abra05#This must be discouraging. ...Well, just think of it as practice for when you're NOT playing against Abra.", ["Yeah, I'm still\nlearning something", "Not playing against Abra?\nThat sounds nice", "Gwuhh..."]);
			g.addWinning("#abra04#...Well, hopefully you're still having fun. Sometimes games are fun to play, even when you lose.", ["Ugh no, this\njust sucks", "Yeah, don't\nworry about it", "...How am I supposed\nto ever beat you!?"]);
		}
		else {
			if (gameStateClass == ScaleGameState || gameStateClass == TugGameState) g.addWinning("#abra06#See that tiny, tiny number? That's your score, <name>. Tiny numbers are bad.", ["Ugh...", "Will you just\nshut up...", "Remind me never to\nplay with you again..."]);
			if (gameStateClass == StairGameState) g.addWinning("#abra06#<name>, you're supposed to be collecting your own chests... Not just helping me. This isn't a cooperative game.", ["Ugh...", "Will you just\nshut up...", "Remind me never to\nplay with you again..."]);
			g.addWinning("#abra04#Ehh, whatever. We knew how this was going to go. Hopefully it's good practice for you, <name>.", ["Yeah, I'm still\nlearning something", "I'd have more fun if\nyou weren't playing", "Gwuhh..."]);
			g.addWinning("#abra03#I hope this is as fun for you as it is for me! Eeee-heheheheh~", ["No, it kinda\nsucks", "Dear god you're\ninsufferable", "It's fun\non a bun"]);
			g.addWinning("#abra03#Eee-heheheheh! Wow, I'm so great at this. Are you seeing how great I am?", ["Why am I\nplaying...", "You're a great\npain in the ass", "Whatever, your I.Q's like...\n10,000 or something?"]);
		}

		g.addLosing("#abra05#I thought I'd give myself a little handicap to make the game more fair. This is more fair, isn't it?", ["...What kind\nof handicap?", "Or maybe you're\njust bad", "Can you do this\nevery time?"]);
		g.addLosing("#abra03#So this is what losing feels like? This is nice. I can see why you enjoy losing so much, <name>.", ["Maybe you'd enjoy\nmy foot up your ass", "Heh! Heh\nheh", "I don't ENJOY\nlosing, per se..."]);
		g.addLosing("#abra04#Hmm, maybe I should actually pay attention this time.", ["Oh sure,\nI see", "Yeah, c'mon,\nplay for real", "Maybe you should\npay LESS attention..."]);

		g.addPlayerBeatMe(["#abra04#...", "#abra05#Well... Good match. I went a little easy on you, but you still played very well, <name>.", "#abra02#Next time I'm not pulling any punches, alright? ...Now that I know what you're capable of! Ee-heheheh~"]);
		g.addPlayerBeatMe(["#abra04#...", "#abra05#That was an impressive little performance, <name>. Good job~", "#abra04#Next time, I guess maybe I'll play for real. But... Hmm...", "#abra02#Well, I sort of like seeing your excitement when you win~"]);

		if (PlayerData.isAbraNice())
		{
			g.addBeatPlayer(["#abra05#Well, good try <name>. You'll get there some day.", "#abra04#I mean... You're attempting to overcome a tremendous biological disadvantage. I have to commend you for doing as well as you did.", "#abra05#I hope this wasn't too frustrating, because I really like playing with you. Hopefully we can play again soon~"]);
			g.addBeatPlayer(["#abra05#... ...I'm sure this is frustrating for you, but losing to an abra at this sort of thing is like... losing to a cheetah at a footrace.", "#abra10#Eggh, that probably sounded really arrogant. Just... hmmm...", "#abra06#Try not to fixate too much on comparing yourself to us psychic types when it comes to mental tasks, alright?", "#abra00#We all have our different strengths and weaknesses, and well. ...I like you the way you are~"]);
		}
		else {
			g.addBeatPlayer(["#abra05#Well, good try <name>. You'll get there some day.", "#abra04#I mean... It's not like you'll ever beat me?? But I think you should at least be able to earn more than <money>..."]);
			g.addBeatPlayer(["#abra05#Well, you're pretty clever. But you're no abra.", "#abra04#Don't feel bad about it, <name>. There are just things we're each better at...", "#abra09#...Like, you're probably better at hmmm... Picking up garbage. And sweeping floors. ...Things like that."]);
		}

		if (PlayerData.isAbraNice())
		{
			g.addShortWeWereBeaten("#abra10#What just happened!? ...I think I need more sleep...");
		}
		else {
			g.addShortWeWereBeaten("#abra10#So <name>, I obviously expected you to lose to me... But... Did you really have to lose to <leader> too!?!");
		}
		g.addShortWeWereBeaten("#abra12#<leader>, didn't you get my note!? We were supposed to let <name> win this time...");

		g.addShortPlayerBeatMe("#abra02#I think that was the best I've ever seen you play! ...Next time I won't go easy on you, okay?");
		g.addShortPlayerBeatMe("#abra02#Wow, that was seriously impressive, <name>. You've come a long way~");

		g.addStairOddsEvens("#abra06#How about a quick game of odds and evens to see who goes first? We'll throw dice, and if it's odd you go first, if it's even I'll go first. Sound fair?", ["Sure,\nlet's do it", "Hmm, well I'll\nobviously\nput out an\nodd number...", "Well, you'd\nnever expect me\nto throw an\neven number..."]);
		g.addStairOddsEvens("#abra06#Let's throw odds and evens to decide who starts. If it's odd, you start, if it's even I'll start. ...Let me know when you've ready.", ["Hmm, let\nme think...", "So if\nit's odd,\nI start...", "Tsk, I was\nborn ready."]);

		g.addStairPlayerStarts("#abra12#Gah! It's odd? Well... I knew you'd do that. ...I just think going second is better. Are you ready to start?", ["Yeah!\nI'm ready", "Ha! Ha!\nGoing first is\nWAY better.", "Excuses,\nexcuses..."]);
		g.addStairPlayerStarts("#abra02#Heh! So you go first? ...I'm not used to playing games like this without using my psychic powers to cheat. ...Are you ready?", ["Well, thanks\nfor not cheating...", "Yeah! I've\ndecided", "Mm, sure"]);

		if (PlayerData.isAbraNice())
		{
			g.addStairComputerStarts("#abra02#Yes, it's even! ...Don't worry, your luck will turn around. ...Are you ready for my first turn?", ["Ugh, I\nguess...", "I don't\nneed luck", "Yeah!\nLet's go"]);
			g.addStairComputerStarts("#abra08#Oh, I go first? ...Eeh-heheheh! I promise I didn't read your mind that time. Anyways, let me know when you're ready to begin.", ["Give me a moment\nto think...", "Yeah, no\ncheating!", "You just\ngot lucky..."]);
		}
		else {
			g.addStairComputerStarts("#abra02#It's even! Well. That was good practice for all the other poor decisions you'll make as the game continues. Are you ready for my first turn?", ["Ugh, I\nguess...", "What, you\ndon't think I\ncan take you?", "Hey!\nBe nice"]);
			g.addStairComputerStarts("#abra08#Oh, I go first? ...Maybe you should have thought that through a bit more carefully. Anyways, let me know when you're ready to begin.", ["Give me a moment\nto think...", "Oh, so that's\nhow it's\ngonna be", "You just\ngot lucky..."]);
		}

		g.addStairCheat("#abra09#...We have to throw the dice at the same time, <name>. Otherwise it's not a game. Do you understand?", ["Let me\ntry again", "Sorry, I was just\na bit late...", "You're\nso picky!"]);
		g.addStairCheat("#abra06#Hmm. Well. THAT one obviously doesn't count. ... ... ...Why don't we try one where you DON'T cheat?", ["...But cheating\nis so fun!", "Isn't asking\nfor do-overs\ncheating?", "Okay,\nokay"]);

		g.addStairReady("#abra04#Ready?", ["Alright", "Hmm...", "Yep,\nready"]);
		g.addStairReady("#abra05#Well? Are you ready?", ["Let's go", "Sure, let's\ndo this", "Okay"]);
		g.addStairReady("#abra04#...Ready?", ["I'm ready!", "I guess...", "Hmm, this\nis tricky...."]);
		g.addStairReady("#abra05#Next throw?", ["Yep, next\nthrow", "Give me a\nmoment...", "Yeah!\nOkay"]);
		g.addStairReady("#abra05#Ready to go?", ["Ready!", "Uh, hmm...", "Don't\nrush me!"]);

		g.addCloseGame("#abra04#Well, that's interesting. ... ...You might actually force me to expend some effort towards winning.", ["Should I\nbe scared?", "Prepare to be\ndisappointed!", "Yeah,\nyeah"]);
		g.addCloseGame("#abra00#What I wouldn't give to read your thoughts right now... ... ...Can I just read them a little? I promise I won't cheat.", ["Well okay, maybe\na little...", "Stay out of my\nhead, Charles!", "What? ...focus\non the game!"]);
		if (PlayerData.isAbraNice())
		{
			g.addCloseGame("#abra06#What!? You're... You're actually good! ...I'm not used to people actually playing my games with any level of competence...", ["I've been\npracticing", "I guess it's my\nnatural talent", "This seems\nreally simple"]);
		}
		else {
			g.addCloseGame("#abra06#Is someone helping you? ...You're not usually this competent at these sorts of cerebral activities.", ["No, it's\njust me", "You're not the only\none who can read\nthoughts, huh?", "We've got a crack\nteam of scientists\nover here"]);
		}
		g.addCloseGame("#abra05#Fun is fun, but I think it's time to destroy you, <name>.", ["Oh really?", "...Just let me\nhave this!", "You couldn't\ndestroy a kleenex"]);

		g.addStairCapturedHuman("#abra03#Eee-heheheh! Poor predictable <name>. ... ... ...Always throws out <playerthrow>.", ["...Am I really\nthat predictable?", "Yeah, yeah", "I can't\nbelieve you put\nout <computerthrow>!"]);
		g.addStairCapturedHuman("#abra04#...You can't be so obvious, <name>. Maybe that move works against the other Pokemon, but remember who you're playing against.", ["Geez, you see\nright through\neverything...", "Oof, wow", "...I'm playing\nagainst an asshole"]);
		g.addStairCapturedHuman("#abra06#Come on <name>, I expected so much more from you. You have to think these things through more carefully...", ["Are you\nsure you're\nnot cheating?", "I -am- being\ncareful...", "This is\nso tough!"]);

		g.addStairCapturedComputer("#abra11#What!? But... But that's so stupid. Why would you EVER put out <playerthrow> in that position?", ["It's not stupid\nif you fell for it", "Because...\nyou wouldn't\nsee it coming?", "Heh! Heh!\nRight into\nmy trap~"]);
		g.addStairCapturedComputer("#abra10#What sort of garbage move was that!?! ...That was just a lucky guess. That won't happen again...", ["How can you be\nso bad at this?", "We'll see...", "Heh! Luck\nhad nothing\nto do with it"]);
		g.addStairCapturedComputer("#abra03#Heh! I just wanted to see what would happen if I threw out <computerthrow>. ... ...I didn't actually expect it to work.", ["That was...\nreally stupid", "Free win,\nI guess?", "Ehh, sure.\n...So you did\nit on purpose?"]);

		return g;
	}

	public static function bonusCoin(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#abra02#Is that a bonus coin!? Lucky you!"];
		tree[1] = ["#abra04#Let's see what kind of bonus game I... hmmm... maybe... "];
		tree[2] = ["#abra03#Oooh! How about THIS one?"];
	}

	public static function sexyAfterGood0(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		tree[0] = ["#abra07#Hahhhh... I don't think you've EVER done it like that before!"];
		tree[1] = ["#abra01#That was... that was AMAZING...! Oh my god... Hahhh... Phewww...."];
	}

	public static function sexyAfterGood1(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		tree[0] = ["#abra07#Wowww! Ahhhh... I can't believe I came SO much,"];
		tree[1] = ["#abra00#I've... hahhh... never come that much in my life. You're some sort of... jizz wizard."];
		if (!PlayerData.abraMale)
		{
			DialogTree.replace(tree, 1, "jizz wizard", "magical orgasm genie");
		}
	}

	public static function sexyBeforeJustFinishedGame(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		if (PlayerData.abraStoryInt == 6)
		{
			// no swap
			tree[0] = ["#abra05#It feels like it's been forever since we did this, doesn't it?"];
			tree[1] = ["#abra03#...It's funny but, when two of us were on bad terms and I had to take care of myself again... I'd almost forgotten how. Bahahahaha~"];
			tree[2] = ["#abra02#Well, hopefully you still remember."];
		}
		else
		{
			// swap
			tree[0] = ["#abra00#So hmmm, this will be a first for you, won't it? ...I don't suppose you've ever remotely masturbated yourself using a flash game. Ehh-heheheh~"];
			tree[1] = [50, 10, 30, 40, 20];

			tree[10] = ["I invented\nthis thing,\nyou idiot"];
			tree[11] = ["#abra06#Oh! That's right, you would have had to test it when you were programming all this stuff. ... ...Hmmmm."];
			tree[12] = ["#abra02#...Well in THAT case, you should know all the right buttons to press, hmm? Hmm-hmhmhmhm~"];
			tree[13] = ["#abra01#Go ahead, why don't you show me what I've been doing wrong."];

			tree[20] = ["How do you\nthink I\ntested it?"];
			tree[21] = [11];

			tree[30] = ["Well, not\nfrom this\nfar away"];
			tree[31] = ["#abra04#Ehh? What does that mean? ...Like, you've tested it from up close?"];
			tree[32] = [11];

			tree[40] = ["Ehh, well\nit's been\nawhile"];
			tree[41] = ["#abra04#Ehh? It's been awhile? But when would you have... ..."];
			tree[42] = [11];

			tree[50] = ["I've done\nthis many,\nmany times"];
			tree[51] = ["#abra04#Wait, you have? I thought that... ..."];
			tree[52] = [11];
		}
	}

	public static function sexyAfter0(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		if (sexyState.justFinishedGame)
		{
			if (PlayerData.abraStoryInt == 6)
			{
				var hours:Int = Date.now().getHours();

				tree[0] = ["#abra00#Phew... I missed that... Hah..."];
				if (hours < 4 || hours > 18)
				{
					tree[1] = ["#abra04#Thanks, that was the perfect end to a perfect night."];
				}
				else if (hours >= 4 && hours < 12)
				{
					tree[1] = ["#abra04#Thanks, that was the perfect way to cap off a perfect morning."];
				}
				else
				{
					tree[1] = ["#abra04#Thanks, that was the perfect way to punctuate that little conversation."];
				}
				tree[2] = ["#abra05#See you again soon, <name>~"];
				return;
			}
			else
			{
				tree[0] = ["#abra04#Hah... Well... That was different than I expected."];
				tree[1] = ["#abra06#It was intimate in a way... but ehhh... it also felt weirdly clinical."];
				tree[2] = ["#abra08#I don't think you did anything wrong, it... it felt good? It was just ehhh... well, not being able to see your face or hear your voice was... ... Hmmmmm."];
				tree[3] = ["#abra02#... ...Well, I'll get used to it eventually. ...You'll come visit me again soon, right?"];
				return;
			}
		}
		tree[0] = ["#abra00#I'm going to go get cleaned up, look what a mess we made!"];
		tree[1] = ["#abra02#Eee-heh-heh."];
	}

	public static function sexyAfter1(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		tree[0] = ["#abra01#Hah... Wow..."];
		tree[1] = ["#abra02#I need to make these puzzles easier so we can do this more often!"];
	}

	public static function sexyAfter2(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		tree[0] = ["#abra03#Mmmm... That felt gooooooood...."];
		tree[1] = ["#abra05#We've gotta do this more often, alright?"];
	}

	public static function sexyAfter3(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		tree[0] = ["#abra08#This was great, but I need some time to recharge..."];
		tree[1] = ["#abra05#Phew... Heh..."];
	}

	public static function sexyBadHead(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		tree[0] = ["#abra04#Alright, let's try this again!"];
		tree[1] = ["#abra09#Although maybe you can lay off the head scratches this time."];
		tree[2] = ["#abra12#I hate when people scratch my head as though I'm their pet. I'm not their pet!"];
		tree[3] = ["#abra13#How would you like it if I treated you like my pet?"];
		tree[4] = [10, 20, 30];

		tree[10] = ["I'd really\nlike it"];
		tree[11] = ["#abra06#You would!?"];
		tree[12] = ["#abra08#..."];
		tree[13] = ["#abra01#You're giving me all kinds of abra ideas. Maybe I'll make you my pet. Nyeh-heheheh~"];

		tree[20] = ["I'd\nlike it"];
		tree[21] = [11];

		tree[30] = ["I'd\nhate it"];
		tree[31] = ["#abra05#Exactly!"];
		tree[32] = ["#abra02#I'm glad we understand each other."];
	}

	public static function sexyBadBelly(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		tree[0] = ["#abra02#Ee-hee-hee, time for the fun part."];
		tree[1] = ["#abra08#But hey, maybe you can lay off the belly rubs this time."];
		tree[2] = ["#abra13#I hate when people rub my belly as though I'm a puppy. I'm nobody's puppy!"];
		tree[3] = ["#abra04#..."];
		tree[4] = ["#abra02#Rubbing my chest is okay though! That makes me feel full of abra energy."];
	}

	public static function sexyBadButt(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		if (PlayerData.justFinishedMinigame)
		{
			tree[0] = ["#abra04#Well that was a pleasant little minigame. ...I think you're starting to get the hang of this stuff."];
		}
		else
		{
			tree[0] = ["#abra04#Well that went by quickly! I think you're getting better at those."];
		}
		tree[1] = ["#abra13#But hey!!! Quit messing around with my butt so much. I don't DO butt stuff."];
		tree[2] = ["#abra09#..."];
		tree[3] = ["#abra01#Well, I almost never do butt stuff."];
		tree[4] = ["#abra04#...Just don't touch my butt, alright?"];
	}

	public static function sexyBadFeet(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		tree[0] = ["#abra02#My abra feet could use some attention today!"];
	}

	public static function sexyBadChest(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		tree[0] = ["#abra04#I think it's time for a break! Maybe you can rub my chest a little."];
		tree[1] = ["#abra02#I've got such a sexy chest don't I?"];
		tree[2] = [10, 20];

		tree[10] = ["It's such\na sexy\nchest"];
		tree[11] = ["#abra00#Eee-hee-hee!"];

		tree[20] = ["It's like\na little\nhot dog"];
		tree[21] = ["#abra10#Little hot dog!?"];
		if (PlayerData.abraMale)
		{
			tree[22] = ["#abra13#Grrr, I've got a little hot dog for you!!"];
		}
		else
		{
			tree[22] = ["#abra13#...Grrr! That's so incredibly rude!"];
			tree[23] = ["#abra05#Although I kind of want a hot dog now."];
		}
	}

	public static function sexyBadShoulders(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		tree[0] = ["#abra04#Phew! My shoulders are a little sore."];
		tree[1] = ["#abra06#You don't know anything about... massages, do you?"];
	}

	public static function sexyBadBalls(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		if (!PlayerData.abraMale)
		{
			return sexyBefore0(tree, sexyState);
		}
		tree[0] = ["#abra06#What's your opinion on balls?"];
		tree[1] = [10, 20, 30];

		tree[10] = ["I love\nballs"];
		tree[11] = ["#abra01#Yeah! I love having my balls played with."];

		tree[12] = ["#abra00#Not just in a sexual way, but it just feels good. Like a massage."];
		tree[20] = ["Balls are\njust OK"];
		tree[21] = ["#abra08#Hmph! ...You'll see!! Some day you're going to learn to appreciate my balls."];

		tree[30] = ["I hate\nballs"];
		tree[31] = ["#abra10#You HATE balls!?! Who could hate balls!?!"];
		tree[32] = [21];
	}

	public static function sexyBadCravesAnal(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		if (PlayerData.justFinishedMinigame)
		{
			tree[0] = ["#abra05#Watching you work your way through that minigame kind of put me in a weird mood."];
		}
		else
		{
			tree[0] = ["#abra05#Watching you solve those puzzles so quickly kind of put me in a weird mood."];
		}
		tree[1] = ["#abra00#...Like, a really weird mood!"];
		tree[2] = ["#abra09#I almost never do butt stuff, but, you know,"];
		tree[3] = ["#abra04#...Sometimes butt stuff is OK. Maybe once in awhile."];
		tree[4] = ["#abra01#Maybe just when it's special."];
	}

	public static function sexyBefore0(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		tree[0] = ["#abra04#Alright well I think you've earned a little break,"];
		if (PlayerData.justFinishedMinigame)
		{
			tree[1] = ["#abra05#Why don't we relax for a moment. We can do anything you want."];
		}
		else
		{
			tree[1] = ["#abra05#Why don't we relax for a moment and do something besides puzzles?"];
		}
		tree[2] = ["#abra04#..."];
		tree[3] = ["#abra01#What!! Why are you looking at me that way?"];
	}

	public static function sexyBefore1(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		tree[0] = ["#abra04#I hope those puzzles weren't too hard for you."];
		tree[1] = [10, 20, 30, 40];

		tree[10] = ["They were\npretty\neasy"];
		tree[11] = ["#abra05#Oh! So you're looking for something harder are you?"];
		tree[12] = ["#abra01#Why I've got something harder for you. Ee-hee-hee."];

		tree[20] = ["They were\njust hard\nenough"];
		tree[21] = ["#abra05#Just hard enough? Well, I think you can handle something harder."];
		tree[22] = ["#abra01#Come here, I've got something harder that you can handle."];

		tree[30] = ["They were\nreally\nhard"];
		tree[31] = ["#abra05#Ohh, were they really that hard? Well..."];
		tree[32] = ["#abra01#Well I've got something that's not hard enough."];

		tree[40] = ["They were\nrigid\nlike an\nerection"];
		tree[41] = ["#abra13#Rigid!? Like an erection!?!"];
		tree[42] = ["#abra12#You're stepping all over my cool double entendre here."];
		tree[43] = ["#abra13#I'm the clever one!!"];

		if (PlayerData.justFinishedMinigame)
		{
			DialogTree.replace(tree, 0, "those puzzles weren't", "that minigame wasn't");
			DialogTree.replace(tree, 10, "They were", "It was");
			DialogTree.replace(tree, 20, "They were", "It was");
			DialogTree.replace(tree, 30, "They were", "It was");
			DialogTree.replace(tree, 40, "They were", "It was");
		}

		if (!PlayerData.abraMale)
		{
			tree[11] = ["#abra01#Oh! So you're looking for something harder, are you."];
			tree[12] = ["#abra01#...Did you have something... harder in mind?"];
			tree[21] = ["#abra05#Just hard enough? Personally I like things a little harder."];
			tree[22] = ["#abra01#Come here, I've bet you've got something a little harder for me."];
			tree[32] = ["#abra01#Why don't you show me just how... hard they were."];

			if (PlayerData.justFinishedMinigame)
			{
				DialogTree.replace(tree, 32, "they were", "it was");
			}
		}
	}

	public static function sexyBefore2(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		if (PlayerData.justFinishedMinigame)
		{
			tree[0] = ["#abra02#I love watching you think through these minigames! ...Like watching a chicken play tic-tac-toe."];
			if (PlayerData.isAbraNice())
			{
				tree[1] = ["#abra10#But egggggh... I mean umm... a REALLY smart chicken! Like, one of those... genius chickens, that ehhh..."];
				tree[2] = ["#abra06#Who was that chicken that won that game show? Ummm... Don't you remember?"];
				tree[3] = ["#abra09#... ... ..."];
				tree[4] = ["#abra08#I'm sorry, <name>."];
			}
			else
			{
				tree[1] = ["#abra06#...Well, actually those tic-tac-toe playing chickens are trained. I suppose it's more like watching a giraffe randomly thumping its head against a tic-tac-toe board."];
				tree[2] = ["#abra08#..."];
				tree[3] = ["#abra05#On second thought, that's a bit offensive."];
				tree[4] = ["#abra04#My minigames are far more nuanced than tic-tac-toe."];
			}
		}
		else
		{
			if (PlayerData.isAbraNice())
			{
				tree[0] = ["#abra02#I love watching you solve puzzles! I spent a lot of time designing them, you know."];
				tree[1] = ["#abra00#I'm just glad you get to share in something I enjoy so much~"];
			}
			else
			{
				tree[0] = ["#abra02#I love watching you solve puzzles! Of course I can solve them faster myself,"];
				tree[1] = ["#abra00#But it's more fun when you do it."];
			}
		}
	}

	public static function sexyBefore3(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		tree[0] = ["#abra02#Nngh I'm so turned on right now. ... ...I can't wait to feel your device in my input port~"];
		tree[1] = ["#abra03#Bahahahaha~"];
	}

	public static function sexyBefore5PegTutorial(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		if (PlayerData.recentChatTime("abra.sexyTutorial.0") >= 200)
		{
			tree[0] = ["#abra01#Mmmm. So... How did you like that 7-peg puzzle? ...Was it... Was it good for you~"];
		}
		else
		{
			tree[0] = ["#abra01#Mmmm. So... How was the 7-peg puzzle for you this time? ...Are you... Are you getting used to it? Did it feel any better~"];
		}
		tree[1] = [20, 30, 40, 50];

		tree[20] = ["It was\nfun, and\neasy"];
		tree[21] = ["#abra06#Really? You really thought that..."];
		tree[22] = ["#abra05#Ohh you're just saying that. I see. You want to like what I like. Hmm."];
		tree[23] = ["#abra00#I'm flattered but... Well, I was only really asking as a formality."];
		tree[24] = ["#abra04#Of course I already know what you REALLY think about my 7-peg puzzles. And that's okay."];
		tree[25] = [100];

		tree[30] = ["It was\nfun, but\nchallenging"];
		tree[31] = ["#abra05#Really? You still thought it was fun? I know you were struggling with it."];
		tree[32] = ["#abra09#The solution space is a little bigger than what you're used to. But... not THAT much bigger."];
		tree[33] = ["#abra10#And, and! I really think you'd get used to it if you tried a few times. And we can go slower next time. And maybe if you, hmm..."];
		tree[34] = ["#abra08#..."];
		tree[35] = [100];

		tree[40] = ["It was too\neasy to be\nfun"];
		tree[41] = ["#abra10#Too easy? ...I know it wasn't easy for you. Why would you say that?"];
		tree[42] = ["#abra09#Hmm... Is this some sort of display of mental bravado meant to intimidate me? ...It's okay. You don't have to do that."];
		tree[43] = ["#abra04#I just wanted to know if you... hmm... well,"];
		tree[44] = [100];

		tree[50] = ["It was too\nchallenging\nto be fun"];
		tree[51] = ["#abra05#Ohhhhh was it... Was it that painful for you? I mean, I know you were struggling with it."];
		tree[52] = ["#abra09#The solution space is a little bigger than what you're used to. So of course it's going to hurt a little at first."];
		tree[53] = ["#abra10#But... But! I really think you'd get used to it if you tried a few times. And we can go slower next time. And maybe if you, hmm..."];
		tree[54] = ["#abra08#..."];
		tree[55] = [100];

		tree[100] = ["#abra05#...Why don't we just stick to 5-peg puzzles for now. 7-peg puzzles are probably just a little too much."];
		tree[101] = ["#abra02#Maybe some day, once you can handle 5-peg puzzles a little easier, we can try a 7-peg puzzle again."];
		tree[102] = ["#abra00#..."];
		tree[103] = ["#abra01#Let's not rush things, okay?"];
	}

	public static function sexyBefore7Peg0(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		tree[0] = ["#abra00#Nnngh, just watching you figure out that puzzle got me all excited~"];
		tree[1] = ["#abra02#You know the only thing better than a long, grueling puzzle..."];
		tree[2] = ["#abra04#..."];
		tree[3] = ["#abra03#That was a trick question! Nothing's better than a long, grueling puzzle. Eee-heheheh!"];
		if (PlayerData.abraMale && PlayerData.pokemonLibido >= 2)
		{
			DialogTree.replace(tree, 0, "got me all excited", "gave me a little puzzle boner");
		}
	}

	public static function sexyBefore7Peg1(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		tree[0] = ["#abra00#Mmmmm... I got so excited watching you work through that puzzle~"];
		tree[1] = ["#abra06#Was it too hard though? It seemed like it might have been a little on the hard side for you."];
		tree[2] = [10, 20, 30, 40];

		tree[10] = ["It was\npretty\neasy"];
		tree[11] = ["#abra05#Oh! So you're looking for something harder are you?"];
		tree[12] = ["#abra01#Why I've got something harder for you. Ee-hee-hee."];

		tree[20] = ["It was\njust hard\nenough"];
		tree[21] = ["#abra05#Just hard enough? Well, I think you can handle something harder."];
		tree[22] = ["#abra01#Come here, I've got something harder that you can handle."];

		tree[30] = ["It was\nreally\nhard"];
		tree[31] = ["#abra05#Ohh, was it really that hard? Well..."];
		tree[32] = ["#abra01#Well I've got something that's not hard enough."];

		tree[40] = ["It was\nrigid\nlike an\nerection"];
		tree[41] = ["#abra13#Rigid!? Like an erection!?!"];
		tree[42] = ["#abra12#You're stepping all over my cool double entendre here."];
		tree[43] = ["#abra13#I'm the clever one!!"];

		if (!PlayerData.abraMale)
		{
			tree[11] = ["#abra01#Oh! So you're looking for something harder, are you."];
			tree[12] = ["#abra01#...Did you have something... harder in mind? Ee-hee-hee."];
			tree[21] = ["#abra05#Just hard enough? Personally I like things a little harder."];
			tree[22] = ["#abra01#Come here, I've bet you've got something a little harder for me."];
			tree[32] = ["#abra01#Why don't you show me just how... hard it was."];
		}
	}

	public static function sexyBefore7Peg2(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		tree[0] = ["#abra00#Nggghh... I just love watching you solve these 7-peg puzzles..."];
		tree[1] = ["#abra04#What about oooohhh... What about a 12-peg puzzle? It could be 3-dimensional..."];
		tree[2] = ["#abra05#The pegs would be placed on the vertices of an icosahedron, and the adjacency rule would apply to the five adjacent vertices..."];
		tree[3] = ["#abra00#..."];
		tree[4] = ["#abra02#Eee-hee-hee, I'm just kidding, <name>!"];
		tree[5] = ["#abra01#...Unless you're into it..."];
	}

	public static function vocabulary(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.isAbraNice())
		{
			if (PlayerData.level == 0)
			{
				random00(tree, puzzleState);
			}
			else if (PlayerData.level == 1)
			{
				random10(tree, puzzleState);
			}
			else if (PlayerData.level == 2)
			{
				random20(tree, puzzleState);
			}
			return;
		}

		if (PlayerData.level == 0)
		{
			tree[0] = ["#abra04#Ahh hello <name>, I've been expecting you."];
			tree[1] = ["#abra05#I assume Grovyle's already explained how these puzzles work, so I've selected some puzzles which might be... a little challenging."];
			tree[2] = ["#abra02#...Well, challenging for someone with your IQ anyways!! Ee-hee-hee."];
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["#abra04#Wait, did that last remark come off as condescending? When I was talking about your IQ?"];
			tree[1] = [2, 4, 6];
			tree[2] = ["Yes"];
			tree[3] = [10];
			tree[4] = ["No"];
			tree[5] = [10];
			tree[6] = ["Shut up"];
			tree[7] = [25];
			tree[10] = ["#abra09#Hmm..."];
			tree[11] = ["#abra05#Condescending might have been a confusing word for you. Did my statement make you feel intellectually inadequate?"];
			tree[12] = [13, 15];
			tree[13] = ["Yes"];
			tree[14] = [20];
			tree[15] = ["No"];
			tree[16] = [20];
			tree[17] = ["Screw you!"];
			tree[18] = [25];
			tree[20] = ["#abra08#Hmm..."];
			tree[21] = ["#abra09#We'll come back to this."];
			tree[25] = ["#abra12#..."];
			tree[26] = ["#abra13#Rude!"];
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["#abra04#Don't let my intellectual superiority intimidate you. You don't feel intimidated by my intellectual superiority do you?"];
			tree[1] = [2, 4, 6];
			tree[2] = ["Yes"];
			tree[3] = [10];
			tree[4] = ["No"];
			tree[5] = [10];
			tree[6] = ["You ass!"];
			tree[7] = [15];
			tree[10] = ["#abra09#Hmm..."];
			tree[11] = ["#abra05#Intimidate might have been a confusing word for you. It means that--"];
			tree[12] = ["#abra08#You know, let's just skip it."];
			tree[15] = ["#abra12#...Hmph!!"];
			tree[16] = ["#abra08#Well, that's what I get for trying to be hospitable."];
			tree[17] = ["#abra05#Hospitable might have been a confusing word for you. It means that--"];
			tree[18] = [20, 25];
			tree[20] = ["Shut up or I'll send\nyou to the hospitable!"];
			tree[21] = ["#abra11#Wah!"];
			tree[25] = ["<sigh>"];
			tree[26] = ["#abra03# "];
		}
	}

	public static function iqBrag(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			var difficulty:Int = Std.int(Math.max(puzzleState._puzzle._difficulty * RankTracker.RANKS[65], 1));
			_intA = Std.int(difficulty / 10);
			_intB = difficulty % 10;
			var difficultyString:String = _intA + "." + _intB;
			tree[0] = ["#abra05#I solved this next level in " + difficultyString + " seconds!"];
			tree[1] = ["#abra02#Let's see if you can beat my record. And... go!"];
		}
		else if (PlayerData.level == 1)
		{
			var difficulty:Int = Std.int(Math.max(puzzleState._puzzle._difficulty * RankTracker.RANKS[65], 1));
			_intA = Std.int(difficulty / 10);
			_intB = difficulty % 10;
			tree[0] = ["#abra03#Well you didn't beat my record, but that was still pretty good."];
			tree[1] = ["#abra04#Obviously someone with a 600 IQ has an unfair advantage at these games. My IQ is over 600, you know!"];
			tree[2] = [10, 20, 30];

			// that's... difficult to believe
			tree[10] = ["That's... difficult\nto believe"];
			tree[11] = ["#abra13#Hey!! Just what are you trying to say?"];
			tree[12] = ["#abra12#You might not realize just how offensive that is for someone with a 600 IQ."];
			tree[13] = ["#abra13#..."];
			tree[14] = ["#abra10#For someone with a 600 IQ, regular insults are even more insulting."];

			// that sounds about right
			tree[20] = ["That sounds\nabout right"];
			tree[21] = ["#abra03#See! And I can prove it too, I'll tell you something only someone with 600 IQ would know."];
			tree[22] = ["#abra08#Hmm...."];
			tree[23] = ["#abra05#..."];
			tree[24] = ["#abra01#...I'm horny!"];

			// my IQ is 700
			tree[30] = ["My IQ\nis 700"];
			tree[31] = ["#abra11#What! 700!?"];
			tree[32] = ["#abra09#...But then why are you so bad at puzzles?"];
		}
		else if (PlayerData.level == 2)
		{
			var difficultyString:String = _intA + "." + _intB;
			tree[0] = ["#abra05#That last puzzle only took me " + difficultyString + " seconds."];
			tree[1] = ["#abra02#...but again, 700 IQ!!"];
		}
	}

	public static function story0(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.abraStoryInt == 4)
		{
			if (PlayerData.level == 0)
			{
				tree[0] = ["%fun-alpha0%"];
				tree[1] = ["#self04#(Wait... where's Abra?)"];
				tree[2] = ["#self08#(... ...I wonder if I broke the game. Is this supposed to happen?)"];
				tree[3] = ["#self06#(...Maybe someone will show up if I solve a few puzzles.)"];
			}
			else if (PlayerData.level == 1)
			{
				tree[0] = ["%fun-alpha0%"];
				tree[1] = ["#self08#(Huh. Nope, nobody showed up. ...Well, this sucks.)"];
				tree[2] = ["#self09#(...Maybe just one more puzzle...)"];
			}
			else if (PlayerData.level == 2)
			{
				tree[0] = ["%fun-alpha0%"];
				tree[1] = ["%enterbuiz%"];
				tree[2] = ["#buiz06#Oh uhhh hey <name>. Are you looking for Abra? ...Yeahhhhhhh."];
				tree[3] = ["#buiz09#Abra's in his room but... ...I don't think he wants any visitors right now."];
				tree[4] = ["#buiz08#Maybe you can check in on him in a few days? I dunno. Sometimes he gets like this, you know how he is."];
				tree[5] = [40, 20, 10, 30];

				tree[10] = ["I think\nI may have\ncaused it"];
				tree[11] = ["#buiz05#What, did you like beat him at one of his minigames or something? Heh! Heh."];
				tree[12] = ["#buiz06#Just kidding, like that would ever happen. All those games are so rigged, it's not even funny..."];
				tree[13] =  [50];

				tree[20] = ["Did he seem\nangry?"];
				tree[21] = ["#buiz05#Ehhhh, he seemed moody. But it's Abra! He's always kind of moody..."];
				tree[22] = ["#buiz06#I wouldn't sweat it. Everybody has bad days sometimes, he'll get over it."];
				tree[23] = [50];

				tree[30] = ["Okay, I'll\ntry again\nlater"];
				tree[31] = ["#buiz05#Alright. ...Anyway, I'll be around if you wanna hang out later. See you, <name>~"];

				tree[40] = ["Let's\nhang out!"];
				tree[41] = ["#buiz04#Yeah sure thing! ...Lemme just grab a quick snack and I'll be right out."];

				tree[50] = ["#buiz04#Anyway I'll be around! Let's hang out later~"];

				if (!PlayerData.abraMale)
				{
					DialogTree.replace(tree, 3, "in his", "in her");
					DialogTree.replace(tree, 3, "think he", "think she");
					DialogTree.replace(tree, 4, "on him", "on her");
					DialogTree.replace(tree, 4, "Sometimes he", "Sometimes she");
					DialogTree.replace(tree, 4, "how he", "how she");
					DialogTree.replace(tree, 11, "beat him", "beat her");
					DialogTree.replace(tree, 11, "of his", "of her");
					DialogTree.replace(tree, 20, "Did he", "Did she");
					DialogTree.replace(tree, 21, "he seemed", "she seemed");
					DialogTree.replace(tree, 21, "He's always", "She's always");
					DialogTree.replace(tree, 22, "he'll get", "she'll get");
				}
			}
		}
		else
		{
			if (PlayerData.level == 0)
			{
				tree[0] = ["#abra05#Hey <name>, I'm glad you could come by."];
				tree[1] = ["#abra08#...I know I'm not always particularly fun to be around. ...That's what I wanted to talk to you about."];
				tree[2] = ["#abra06#I've been feeling a little bit... not myself for awhile. But I think I know what the problem is, and I think there's something you can do to help me."];
				tree[3] = ["#abra08#... ..."];
				tree[4] = ["#abra04#...See, I wasn't always like this. I remember being happy in college, when I was roommates with Grovyle? But something was different back then."];
				tree[5] = ["#abra05#I think I was happy because at the time, my life had... some modicum of purpose to it."];
				tree[6] = ["#abra04#Some day-to-day stress and anxiety, even if it was just trivial things like.... Ooh, when is this assignment due, I hope I get a good grade on this test..."];
				tree[7] = ["#abra09#After I graduated though, everything and everybody just became... so predictable."];
				tree[8] = ["#abra08#No highs, no lows, each week indistinguishable from the next. ...It's like, if I could look 30 years into the future, I know exactly what I'd see,"];
				tree[9] = ["#abra09#I'd be living alone in a slightly nicer house, having retained approximately 30 percent of my personal friendships statistically speaking,"];
				tree[10] = ["#abra05#Grovyle and the others would have long since moved out, they'd either be living by themselves or with their significant others,"];
				tree[11] = ["#abra04#I'd have a tremendous amount of accumulated wealth because I'm a responsible, well-educated Pokemon with no family and no expensive hobbies,"];
				tree[12] = ["#abra05#And I'd be playing the same dumb video games with, I guess, slightly better graphics. ...Yippee."];
				tree[13] = ["#abra04#..."];
				tree[14] = ["#abra06#It kind of feels like, a long, drawn out, boring chess game. And I've got a bishop and a knight against an undefended king..."];
				tree[15] = ["#abra12#...But my opponent is a moron who's taking two minutes for each move."];
				tree[16] = ["#abra08#I obviously know how it's going to end, but it's just... ...So boring to play it out. There's no joy in it."];
				tree[17] = ["#abra06#But here's the thing. What if I was just, mmm, 50 times stupider at chess? Then a game like that might still be exciting for me."];
				tree[18] = ["#abra05#...The anxiety of forcing an accidental stalemate, tracking the threefold repetition rule, taxing my brain trying to think one or two moves ahead."];
				tree[19] = ["#abra04#That's where you come in. ...This is going to sound a little weird, but I want to swap consciousnesses with you."];
				tree[20] = ["#abra02#...You can be my idiot chess brain, <name>!"];
				tree[21] = ["#abra05#You'll be able to live out the rest of your life as an abra with all of my friends. Or, ehhhh, you don't have to keep inviting Grimer over if you don't want."];
				tree[22] = ["#abra04#As for me, I'll live out the rest of my life in your human body, with all the limitations that accompany your feeble human brain."];
				tree[23] = ["#abra06#So you'll get to be a Pokemon, and I'll stop being forced to see my life 33 moves ahead, and we'll both be happy, hmmm?"];
				tree[24] = [80, 70, 60, 50];

				tree[50] = ["Is that\npossible?"];
				tree[51] = ["#abra03#Ehh-heheheh! Well, I think I may have found a way."];
				tree[52] = [100];

				tree[60] = ["That sounds\ngreat!"];
				tree[61] = ["#abra03#Ehh-heheheh! It does, doesn't it? I knew you'd like my plan~"];
				tree[62] = [100];

				tree[70] = ["Hmm... I'm\nnot sure"];
				tree[71] = ["#abra04#Ohh you don't have to decide yet. I know it's a big decision with a lot of implications."];
				tree[72] = [100];

				tree[80] = ["Oh, no\nthanks"];
				tree[81] = ["#abra04#Ohh you don't have to decide yet. I know it's a big decision with a lot of implications."];
				tree[82] = [100];

				tree[100] = ["#abra05#I can fill you in on the details after, hmm, after this puzzle."];
				tree[101] = ["#abra02#...The puzzles are actually integral to my plan. I'll explain in a moment."];
			}
			else if (PlayerData.level == 1)
			{
				tree[0] = ["#abra04#So after I graduated, I was doing some research in my spare time on how consciousness is linked to the brain."];
				tree[1] = ["#abra05#Not being a particularly spiritual person, I had always assumed the brain behaved as a fully self-contained physical entity."];
				tree[2] = ["#abra06#... ...Ehhh, that is, I thought our brains were just, mmmmmm... goo in a box."];
				tree[3] = ["#abra04#Surprisingly though, it turns out our brains are mapped to our consciousness through a unique arrangement of neural connections in the reticular nucleus of the thalamus!"];
				tree[4] = ["#abra06#... ...Ehhh, that is... Instead of goo in a box, it's more like remote-controlled goo in a box."];
				tree[5] = ["#abra05#Now, these unique neural arrangements are constantly changing in small ways which doesn't disrupt our consciousness."];
				tree[6] = ["#abra04#But sometimes they can change more drastically, like if someone learns a lot of things all at once, or if they drink too much."];
				tree[7] = ["#abra06#I think that's why sometimes people might feel foggy or even lose consciousness in those situations."];
				tree[8] = ["#abra05#You lose consciousness because the link between your mind and your brain is interrupted..."];
				tree[9] = ["#abra04#...And when that happens, some... force, I'm not sure what... has trouble reconnecting the two."];
				tree[10] = ["#abra05#But whatever that force is, it eventually connects your consciousness back to your original brain."];
				tree[11] = ["#abra04#Well, I mean OBVIOUSLY it connects you back to your original brain! ...It's not like anybody's ever gotten so drunk they woke up with someone else's thoughts."];
				tree[12] = ["#abra02#But, BUT, I'm pretty sure that could actually happen if we forced the right circumstances to occur."];
				tree[13] = [60, 80, 70, 50, 90];

				tree[50] = ["You want\nme to get\ndrunk?"];
				tree[51] = ["#abra12#You? No no no no no no. The last thing we'd want is to slow YOUR brain down."];
				tree[52] = ["#abra06#Actually if you have any caffeine or... if you can maybe get your hands on some Adderall or amphetamines, hmmm..."];
				tree[53] = ["#abra05#... ...No, no, nevermind. No drugs. ...For now."];
				tree[54] = [100];

				tree[60] = ["That sounds\ndangerous..."];
				tree[61] = ["#abra03#Mmmmm, maybe a little dangerous. Come on! Where's your pioneering spirit~"];
				tree[62] = ["#abra02#Where would the parachute be without, mmmm... that parachute guy? ...That guy, you know..."];
				tree[63] = ["#abra06#That forgettable French inventor who died jumping off the Eiffel tower? ... ...I suppose I could have picked a better example."];
				tree[64] = [100];

				tree[70] = ["Would it\nwork across\nuniverses?"];
				tree[71] = ["#abra06#Hmmmm, that's a valid concern. I suppose we'll find out."];
				tree[72] = ["#abra05#Worst case, I guess we'll just get sucked back into our own brains and then we'll know for sure."];
				tree[73] = [100];

				tree[80] = ["Have you\ntested it?"];
				tree[81] = ["#abra06#Well, I verified I could weaken the mind-brain force by altering the neural connections in my thalamus."];
				tree[82] = ["#abra05#...And by readjusting my neural connections back to their original configuration, It immediately snapped back into lucidity."];
				tree[83] = ["#abra09#I haven't experimented with swapping consciousnesses yet, because... well, any swap would be a one-way trip."];
				tree[84] = ["#abra10#I wouldn't be able to facilitate the process of swapping back if I was constrained by the limitations of someone else's brain!!"];
				tree[85] = ["#abra08#So we'll just have to hope that the swapping part works. ...But worst case, we'll just get sucked back into our own brains."];
				tree[86] = [100];

				tree[90] = ["Ummm..."];
				tree[91] = [100];

				tree[100] = ["#abra04#Mmmmmm you know, you're getting too much rest from these long talks. Why don't we try another puzzle."];
			}
			else if (PlayerData.level == 2)
			{
				tree[0] = ["%fun-nude1%"];
				tree[1] = ["#abra04#So anyways ehh... After I found out about this mind-brain connection thing, I looked for someone to swap with but... The whole scenario was pretty awkward."];
				tree[2] = ["#abra05#It needed to be someone I could trust, someone who could trust me back, and someone who was actually willing to switch."];
				tree[3] = ["#abra09#I had one or two candidates but... I could never build up the courage to ask them."];
				tree[4] = ["#abra08#...I mean... I knew they'd think I was crazy for asking. Or that the idea was crazy. And either way they'd just tell everyone..."];
				tree[5] = ["#abra09#... ...I just wasn't ready to ruin my life over a one-in-a-million chance."];
				tree[6] = ["#abra06#But then I realized, what if I scouted other planets, or other universes for candidates?"];
				tree[7] = ["#abra05#It eliminates the risk of ruining my life, since the worst that can happen is they'll say \"no\". ...They can't tell any of my friends."];
				tree[8] = ["#abra04#...So, I designed this Monster Mind game as a way of scouting out people of average-ish intelligence, with ordinary lives, but most importantly..."];
				tree[9] = ["#abra05#I designed it to scout out the types of people who would be motivated to overlook a possible lifetime of suicidal depression for a chance of becoming a Pokemon."];
				tree[10] = ["#abra02#And no offense but... ...I figured perverts were my best choice. Ehheheheheh! So... What do you think?"];
				tree[11] = [30, 40, 60, 70, 50];

				tree[30] = ["Perverts\nwere a\ngood\nchoice!"];
				tree[31] = [100];

				tree[40] = ["I'm not\na pervert..."];
				tree[41] = [100];

				tree[50] = ["That's\noffensive"];
				tree[51] = [100];

				tree[60] = ["Take off\nyour damn\nclothes"];
				tree[61] = ["#abra05#What? Oh, ehhh..."];
				tree[62] = ["%fun-nude2%"];
				tree[63] = [100];

				tree[70] = ["I guess\nthat makes\nsense"];
				tree[71] = [100];

				tree[100] = ["#abra06#No, no, I meant... <name>, what do you think about swapping consciousnesses with me?"];
				tree[101] = ["#abra09#I know it's a big question but... I need a firm yes or no."];
				tree[102] = ["#abra08#If you say yes, then I'll plan out how we can synchronize our neural connections while severing our mind-brain connection and swap places."];
				tree[103] = ["#abra09#If you say no, then... well... (sigh) I don't know what I'll do. ...I guess I'll start looking for a new <name>. But, I'm hoping you'll say yes."];
				tree[104] = ["#abra05#So, what will it be? ...Yes or no?"];
				tree[105] = [450, 200, 300];

				tree[200] = ["Yes"];
				tree[201] = ["#abra02#What? You're... you're really willing to swap brains with me? There's no going back, so... You're absolutely sure, right?"];
				tree[202] = [450, 280, 210, 305];

				tree[205] = ["Oops, I\nmeant yes"];
				tree[206] = [201];

				tree[210] = ["I'm sure,\nbecause..."];
				tree[211] = ["#abra04#..."];
				tree[212] = [230, 233, 236, 239, 216, 305];

				tree[213] = ["(something\nelse...)"];
				tree[214] = ["#abra04#..."];
				tree[215] = [230, 233, 236, 239, 216, 305];

				tree[216] = ["(something\nelse...)"];
				tree[217] = ["#abra05#..."];
				tree[218] = [242, 245, 248, 251, 219, 305];

				tree[219] = ["(something\nelse...)"];
				tree[220] = ["#abra04#..."];
				tree[221] = [254, 257, 260, 263, 222, 305];

				tree[222] = ["(something\nelse...)"];
				tree[223] = ["#abra05#..."];
				tree[224] = [266, 269, 272, 275, 213, 305];

				var yesReasons:Array<String> = [
												   "Because\nI think you'd\ndo the same\nfor me",
												   "Because\nI can relate\nto what you're\ngoing through",
												   "Because\nit will be\nbetter this\nway for both\nof us",
												   "Because\nI'm not content\nwith the life\nI have",

												   "Because\nI want to bang\nyour Pokemon\nfriends",
												   "Because\nI want to see\nwhat happens\nin the game",
												   "Because\nbeing a human\nis just\nthe worst",
												   "Because\nI want you\nto be happy",

												   "Because\nI think you'll\nlike being\nhuman",
												   "Because\nit sounds like\nyou've put a\nlot of work\ninto this",
												   "Because\nI've always\nwanted to be\na Pokemon",
												   "Because I'm\nin love with\none of the\nother Pokemon\nin the game",

												   "Because\nI really just\nneed a break\nfrom all this",
												   "Because\nyou seem like\na good person",
												   "Because\nI want to meet\nyour Pokemon\nfriends in\nperson",
												   "Because\nI'm physically\nrepulsive\nand I'd love\nyour body",
											   ];

				for (i in 0...yesReasons.length)
				{
					tree[230 + 3 * i] = [yesReasons[i]];
					tree[230 + 3 * i + 1] = [281];
				}

				tree[280] = ["Yeah,\nI'm sure"];
				tree[281] = ["%disable-skip%"];
				tree[282] = ["%setabrastory-3%"];
				tree[283] = ["#abra00#... ... ... ..."];
				tree[284] = ["#abra01#Thank you <name>. You have no idea what this means to me~"];
				tree[285] = ["#abra00#I mean, I thought... I thought you might say yes, but... ... ..."];
				tree[286] = ["%fun-nude2%"];
				tree[287] = ["#abra03#...Well, I guess that means I have a lot more work to do! ...But first, why don't we have a little fun, hmm? Eee-heheheh~"];

				tree[300] = ["No"];
				tree[301] = ["#abra10#Wait, what!?"];
				tree[302] = ["#abra08#Really? ...Why would you say no!? Maybe I wasn't clear enough... I was asking whether you wanted to swap bodies with me, yes or no?"];
				tree[303] = [450, 380, 310, 205];

				tree[305] = ["Oops, I\nmeant no"];
				tree[306] = [301];

				tree[310] = ["I said no\nbecause..."];
				tree[311] = ["#abra04#..."];
				tree[312] = [330, 333, 336, 339, 316, 205];

				tree[313] = ["(something\nelse...)"];
				tree[314] = ["#abra04#..."];
				tree[315] = [330, 333, 336, 339, 316, 205];

				tree[316] = ["(something\nelse...)"];
				tree[317] = ["#abra05#..."];
				tree[318] = [342, 345, 348, 351, 319, 205];

				tree[319] = ["(something\nelse...)"];
				tree[320] = ["#abra04#..."];
				tree[321] = [354, 357, 360, 363, 322, 205];

				tree[322] = ["(something\nelse...)"];
				tree[323] = ["#abra05#..."];
				tree[324] = [366, 369, 372, 375, 313, 205];

				var noReasons:Array<String> = [
												  "Because\nbeing a Pokemon\nseems miserable",
												  "Because\nI'm content\nwith the life\nI have",
												  "Because\nyou'd still\nbe depressed\nas a human",
												  "Because\nI have a\npurpose to\nfulfill\nhere",

												  "Because I\ndon't want\nto leave\nmy friends",
												  "Because\nit sounds too\ndangerous",
												  "Because\nI think\nyou're crazy",
												  "Because\nyou shouldn't\nhide from your\nproblems",

												  "Because\nI'd rather be\na different\nkind of Pokemon",
												  "Because\nI'm in love\nwith someone\nover here",
												  "Because\nI'm physically\nrepulsive\nand you'd hate\nmy body",
												  "Because\nyou're a\nconceited\nasshole who\ncan't look\npast " + (PlayerData.abraMale ? "himself" : "herself"),

												  "Because\nI don't think\nI can trust\nyou yet",
												  "Because\nit would be\nworse this\nway for both\nof us",
												  "Because\nI want to see\nwhat happens\nin the game",
												  "Because\nI'm not sure\nyou've thought\nthis through",
											  ];

				for (i in 0...noReasons.length)
				{
					tree[330 + 3 * i] = [noReasons[i]];
					tree[330 + 3 * i + 1] = [381];
				}

				tree[380] = ["Let's drop\nthe subject"];
				tree[381] = ["%setabrastory-4%"];
				tree[382] = ["%disable-skip%"];
				tree[383] = ["#abra11#... ..."];
				tree[384] = ["#abra09#...Ugh. Really? I... I can't believe I wasted so much time trying to get your neural patterns in sync with mine."];
				tree[385] = ["#abra12#It's obvious our brains would never synchronize, because... because we're completely different. ...Because I'd never treat someone the way you're treating me!"];
				tree[386] = ["%exitabra%"];
				tree[387] = ["#abra13#You're... You're such a complete asshole, <name>. ...I hope you rot in that fucking flesh coffin!! ...You can go straight to hell."];
				tree[388] = [390, 393, 396, 399];

				tree[390] = ["Can we still\nbe friends?"];
				tree[391] = [410];

				tree[393] = ["I'm sorry"];
				tree[394] = [410];

				tree[396] = ["It's for your\nown good"];
				tree[397] = [410];

				tree[399] = ["Hey, wait..."];
				tree[400] = [410];

				tree[410] = ["#self10#(... ...)"];
				tree[411] = ["#self08#(Hmm, I guess he left. ... ...He seems really mad.)"];
				tree[412] = ["#self05#(...I think he'll forgive me once he calms down.)"];

				tree[450] = ["Ummm..."];
				tree[451] = ["#abra06#Ehh? I... I need a firm answer, yes or no?"];
				tree[452] = [200, 300];

				tree[10000] = ["#abra05#So I need a firm answer... Would you be willing to swap consciousnesses with me? ...Yes or no?"];
				tree[10001] = [450, 200, 300];

				if (!PlayerData.abraMale)
				{
					DialogTree.replace(tree, 411, "he left", "she left");
					DialogTree.replace(tree, 411, "He seems", "She seems");
					DialogTree.replace(tree, 412, "he'll forgive", "she'll forgive");
					DialogTree.replace(tree, 412, "he calms", "she calms");
				}
			}
		}
	}

	public static function story1(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.abraStoryInt == 4)
		{
			// don't swap...
			if (PlayerData.level == 0)
			{
				tree[0] = ["%fun-alpha0%"];
				tree[1] = ["#self04#(Hmm... where's Abra?)"];
				tree[2] = ["#self08#(... ...Oh yeah, I guess he's still mad because I wouldn't do that weird thing he asked about. Hmmmm...)"];
				tree[3] = ["#self05#(Well, maybe he'll show up if-)"];
				tree[4] = ["%entergrov%"];
				tree[5] = ["#grov05#Ahh, hello <name>! I thought I heard something."];
				tree[6] = ["#grov06#...Were you looking for Abra? He's been in his room all day doing... something."];
				tree[7] = ["#grov02#I'm not sure what he's up to exactly, but it must be quite important if he's distracted to the point of forgetting his puzzle sessions with you! ...I'll run and grab him."];
				tree[8] = [30, 20, 25, 35];

				tree[20] = ["Thanks,\nGrovyle"];
				tree[21] = ["%exitgrov%"];
				tree[22] = ["#grov04#I'll be back in just a moment. ...Why don't you solve this puzzle in the meantime."];

				tree[25] = ["Tell " + (PlayerData.abraMale?"him":"her") + "\nI'm sorry"];
				tree[26] = ["#grov04#Oh, I'm sure it's nothing you did! I'll go ask him, just wait here a moment, hmm?"];
				tree[27] = [50];

				tree[30] = ["Ehh, don't\nbother"];
				tree[31] = [36];

				tree[35] = ["I think " + (PlayerData.abraMale?"he":"she") + "\njust needs\nsome time\nto " + (PlayerData.abraMale?"himself":"herself")];
				tree[36] = ["#grov04#Ahh nonsense, I'm sure it was just an oversight! I'll be back in a moment."];
				tree[37] = [50];

				tree[50] = ["%exitgrov%"];
				tree[51] = ["#grov05#Why don't you solve this puzzle in the meantime."];

				if (!PlayerData.abraMale)
				{
					DialogTree.replace(tree, 2, "he's still", "she's still");
					DialogTree.replace(tree, 2, "he asked", "she asked");
					DialogTree.replace(tree, 3, "he'll show", "she'll show");
					DialogTree.replace(tree, 6, "He's been", "She's been");
					DialogTree.replace(tree, 6, "his room", "her room");
					DialogTree.replace(tree, 7, "he's up", "she's up");
					DialogTree.replace(tree, 7, "he's distracted", "she's distracted");
					DialogTree.replace(tree, 7, "his puzzle", "her puzzle");
					DialogTree.replace(tree, 7, "grab him", "grab her");
					DialogTree.replace(tree, 26, "ask him", "ask her");
				}
			}
			else if (PlayerData.level == 1)
			{
				tree[0] = ["%fun-alpha0%"];
				tree[1] = ["%entergrov%"];
				tree[2] = ["#grov09#Ehhhh, so... Abra's not feeling well. ...Perhaps you can play with him another time."];
				tree[3] = ["#grov05#Alternatively, I'm free right now! ...I just need to grab a quick snack."];
				tree[4] = ["#grov04#Maybe you can solve a few more puzzles without me, and I'll join in later?"];
				tree[5] = [25, 20, 35, 30];

				tree[20] = ["Sure, that\nsounds fun"];
				tree[21] = ["%exitgrov%"];
				tree[22] = ["#grov02#Excellent! I'll be free in just a little bit. Come find me, okay?"];

				tree[25] = ["Oh, don't\nworry about it"];
				tree[26] = ["%exitgrov%"];
				tree[27] = ["#grov03#Hmm, very well. I'll be around if you change your mind. Happy puzzling~"];
				tree[28] = ["#self05#(Hmm, well... I guess I'll just have to practice these puzzles by myself for now.)"];

				tree[30] = ["Is Abra\nsick?"];
				tree[31] = [36];

				tree[35] = ["Is Abra in\na bad mood?"];
				tree[36] = ["#grov03#Ohh, I wouldn't worry about it too much. ...He just gets like this from time to time. Frankly I'm surprised this is the first time it's come up!"];
				tree[37] = ["%exitgrov%"];
				tree[38] = ["#grov05#Anyways I'll be free in a few minutes if you want to play. Come find me, okay?"];

				if (!PlayerData.abraMale)
				{
					DialogTree.replace(tree, 2, "with him", "with her");
					DialogTree.replace(tree, 36, "He just", "She just");
				}
			}
			else if (PlayerData.level == 2)
			{
				tree[0] = ["%fun-alpha0%"];
				tree[1] = ["#self08#(Hmmm, still no Abra...)"];
				tree[2] = ["#self06#(I wonder if I concentrate hard enough, if I can sort of... think a message to him? ...He's telepathic, after all.)"];
				tree[3] = ["#self04#(...Hmmmm... Abra, if you can hear this...)"];
				tree[4] = [35, 25, 30, 20];

				tree[20] = ["(I'm sorry,\nI hope we\ncan still\nbe friends)"];
				tree[21] = ["#self05#(... ... ...)"];
				tree[22] = ["#self04#(Oh well. ...It was worth a shot.)"];

				tree[25] = ["(I changed\nmy mind, I'll\nswitch with\nyou)"];
				tree[26] = ["#self05#(... ... ...)"];
				tree[27] = ["#self04#(Oh well. ...It was worth a shot.)"];
				tree[28] = [50];

				tree[30] = ["(I really\nwant to talk\nabout this)"];
				tree[31] = [21];

				tree[35] = ["(You have the\nphysique of a\nlumpy peanut)"];
				tree[36] = ["#self10#(... ... ...OWww!!!)"];
				tree[37] = ["#self09#(I think someone just punched my brain...)"];

				tree[50] = ["%fun-alpha1%"];
				tree[51] = ["%fun-nude0%"];
				tree[52] = ["#abra06#Wait, are you serious <name>? ...You really changed your mind? You'll do the swap?"];
				tree[53] = [75, 70, 60, 65];

				tree[60] = ["No, I just\nneeded to\nsee that you\nwere okay"];
				tree[61] = [100];

				tree[65] = ["No, but we\nneed to talk"];
				tree[66] = [100];

				tree[70] = ["Yeah, I\nreally want\nto do it"];
				tree[71] = [76];

				tree[75] = ["Yeah, if this\nis the only\nway we can\nstay friends"];
				tree[76] = ["%setabrastory-3%"];
				tree[77] = ["#abra03#Wow really!?! What changed your mind? Was it because-- you know what, it doesn't matter. I'm just glad you're on board~"];
				tree[78] = ["#abra04#...I'm going to start getting things ready, you sort of caught me in the middle of something! ...Just give me a few days."];
				tree[79] = ["%fun-alpha0%"];
				tree[80] = ["#abra02#I'll be around if you need me, though! Let me know if something important comes up. "];
				tree[81] = ["#abra00#And ummm... thanks~"];

				tree[100] = ["%fun-alpha0%"];
				tree[101] = ["#abra13#Ugh I can't believe you. You are SO fucking selfish. ...Don't... Just don't fucking talk to me. I never want to see you again."];
				tree[102] = ["#self09#(Ummm.)"];
				tree[103] = ["#self08#(...Hmmm, I think I made things worse.)"];

				tree[10000] = ["%fun-alpha0%"];

				if (!PlayerData.abraMale)
				{
					DialogTree.replace(tree, 2, "to him", "to her");
					DialogTree.replace(tree, 2, "He's telepathic", "She's telepathic");
				}
			}
		}
		else
		{
			if (PlayerData.level == 0)
			{
				tree[0] = ["#abra02#Ooohh I was wondering when you'd show up again, <name>!"];
				tree[1] = ["#abra05#In order for the swap to work, I need a lot more information about your universe."];
				tree[2] = ["#abra04#...So I've been trying to connect to your universe's internet, but I'm having trouble finding a public ISP to connect to."];
				tree[3] = ["#abra02#But hmmm, now that you're here... I can probably piggyback on your connection if you give me your IP address!"];
				tree[4] = [25, 30, 10, 20, 15];

				tree[10] = ["I don't\nknow my IP\naddress..."];
				tree[11] = ["#abra03#Ehheheh. Don't worry, I had a feeling you'd say something like that. Just do exactly what I say, okay?"];
				tree[12] = [50];

				tree[15] = ["Okay, I\nknow my IP\naddress"];
				tree[16] = ["#abra03#Oh! ...For some reason I had far lower expectations of you. Ee-heheheheh~"];
				tree[17] = ["%prompt-ip%"];

				tree[20] = ["I know\nhow to\nfind my IP\naddress"];
				tree[21] = ["#abra03#Oh! ...For some reason I had far lower expectations of you. Ee-heheheheh~"];
				tree[22] = ["%prompt-ip%"];

				tree[25] = ["What's\nan IP\naddress?"];
				tree[26] = [11];

				tree[30] = ["How can I\nfind my IP\naddress?"];
				tree[31] = [11];

				tree[50] = ["#abra06#First of all... Are you running Windows? OS X? Linux?"];
				tree[51] = [400, 100, 300, 200, 500];

				tree[100] = ["I'm running\nWindows"];
				tree[101] = ["#abra05#Okay. So I'll need you to open a command line, can you do that for me?"];
				tree[102] = ["#abra04#It's probably something like, going into the Start menu, and running the \"Command Prompt\" program... Okay?"];
				tree[103] = [105, 110, 115, 120];

				tree[105] = ["I'm not OK\nwith this"];
				tree[106] = [121];

				tree[110] = ["Umm..."];
				tree[111] = [121];

				tree[115] = ["I can't\nfind it..."];
				tree[116] = [121];

				tree[120] = ["Yeah,\nokay..."];
				tree[121] = ["#abra05#Okay, then you need to type the following command very carefully, including the website address:"];
				tree[122] = ["#abra04#tracert -4 -d -h 2 www.opendns.com"];
				tree[123] = ["#abra06#It should run for a few seconds, and you should see a few lines of output."];
				tree[124] = ["#abra05#...The first line is probably some internal IP that starts with 192, or 10, we don't want that. ...But the next line should have your external IP address. ...Do you see it?"];
				tree[125] = [150, 155, 160, 165, 170];

				tree[150] = ["Uhh, I'm\nnot really\ncomfortable..."];
				tree[151] = [600];

				tree[155] = ["No, I'm not\ngoing to\ndo that"];
				tree[156] = [600];

				tree[160] = ["...Huh?"];
				tree[161] = ["#abra04#Did it work? ...Just type your IP address when you find it."];
				tree[162] = ["%prompt-ip%"];

				tree[165] = ["Sorry, I\ndon't see it"];
				tree[166] = [600];

				tree[170] = ["Okay, my\nIP address\nis..."];
				tree[171] = ["%prompt-ip%"];

				tree[200] = ["I'm running\nOS X"];
				tree[201] = ["#abra05#Okay. So I'll need you to open the network utility application, can you do that for me?"];
				tree[202] = ["#abra04#You'll need to select \"About this Mac\" from the Apple menu, then click the System report button... Then select Windows -> Network Utility from the menu bar."];
				tree[203] = [205, 210, 215, 220];

				tree[205] = ["I'm not OK\nwith this"];
				tree[206] = [221];

				tree[210] = ["Umm..."];
				tree[211] = [221];

				tree[215] = ["I can't\nfind it..."];
				tree[216] = [221];

				tree[220] = ["Yeah,\nokay..."];
				tree[221] = ["#abra05#Okay, then in the Traceroute menu, you just need to type \"opendns.com\" in that little box at the top, and click Trace..."];
				tree[222] = ["#abra06#It should run for a few seconds, and you should see a few lines of output."];
				tree[223] = ["#abra05#...The first line is probably some internal IP that starts with 192, or 10, we don't want that. ...But the next line should have your external IP address. ...Do you see it?"];
				tree[224] = [150, 155, 160, 165, 170];

				tree[300] = ["I'm running\nLinux"];
				tree[301] = ["#abra05#Okay. So I'll need you to open a command line, can you do that for me?"];
				tree[302] = ["#abra04#It's probably something like Super+T or Ctrl+Alt+T. Or you can just run the \"Terminal\" application through the launcher."];
				tree[303] = [305, 310, 315, 320];

				tree[305] = ["I'm not OK\nwith this"];
				tree[306] = [321];

				tree[310] = ["Umm..."];
				tree[311] = [321];

				tree[315] = ["I can't\nfind it..."];
				tree[316] = [321];

				tree[320] = ["Yeah,\nokay..."];
				tree[321] = ["#abra05#Okay, then you need to type the following command very carefully, including the website address:"];
				tree[322] = ["#abra04#dig +short myip.opendns.com @resolver1.opendns.com"];
				tree[323] = ["#abra05#If everything goes smoothly, that command will print a single line which should be your public IP address."];
				tree[324] = [150, 155, 160, 165, 170];

				tree[400] = ["I don't\nknow"];
				tree[401] = ["#abra08#Hmmm... ..."];
				tree[402] = ["#abra06#Well, maybe you can just find a website which tells you your external IP address?"];
				tree[403] = ["#abra04#I know a few good ones, you probably don't have the same websites in your universe. Unless you have something called opendns.com?"];
				tree[404] = ["#abra05#...Well, just try to find your external IP address on the internet whatever way you can, alright?"];
				tree[405] = [150, 155, 160, 165, 170];

				tree[500] = ["I'm running\nsome other\nOS"];
				tree[501] = [401];

				tree[600] = ["#abra06#Ehhh? ...If I'm going to get your physical location in your universe, I need things like GPS and network information which I can only get with an internet connection."];
				tree[601] = ["#abra08#If you can't give me your IP address, I'll need to, hmmm... hmmm..."];
				tree[602] = ["#abra05#... ..."];
				tree[603] = ["#abra04#Wait, what the heck am I doing!? I can just check the header of the original cross-universe HTTP request you used to download the Flash file."];
				tree[604] = ["#abra05#I don't need your help for this, I just... mhmm... here we go.... mhmm... Okay! I can work with this."];
				tree[605] = ["#abra02#Just need a DNS server and... hey wow, it worked! I think I'm actually connected to your universe's internet now."];
				tree[606] = ["#abra04#...Go ahead and work on this next puzzle! It'll give me some time to figure out where things are... Hmmm, hmmm..."];

				// didn't enter IP...
				tree[700] = ["%mark-alrbrmq7%"];
				tree[701] = ["#abra06#Ehhh? ...If I'm going to get your physical location in your universe, I need things like GPS and network information which I can only get with an internet connection."];
				tree[702] = ["#abra08#If you can't give me your IP address, I'll need to, hmmm... hmmm..."];
				tree[703] = ["#abra05#... ..."];
				tree[704] = [770];

				// entered something which didn't look like an IP...
				tree[710] = ["%mark-k7905zhp%"];
				tree[711] = ["#abra06#Hmmm... That doesn't really look like an IP address."];
				tree[712] = ["#abra08#It should be a few numbers in the range 0-255 separated by a period, like 123.124.125.126, something like that..."];
				tree[713] = ["#abra05#... ..."];
				tree[714] = [770];

				// entered internal IP address...
				tree[720] = ["%mark-9e295c5n%"];
				tree[721] = ["#abra06#Hmmm... That looks like an internal IP address."];
				tree[722] = ["#abra08#That'll allow your computers to communicate from behind a router, but I need an external IP address if I'm going to connect from all the way over here."];
				tree[723] = ["#abra05#... ..."];
				tree[724] = [770];

				// entered acceptable IP address...
				tree[730] = ["%mark-kc4ciky1%"];
				tree[731] = ["#abra08#Let's see... Connecting... Connecting... ... ... Hmm, this thing's taking a long time to connect."];
				tree[732] = ["#abra06#Did you type it correctly? ...Is it possible you're behind a firewall? Or maybe, hmmm, hmmm..."];
				tree[733] = ["#abra05#... ..."];
				tree[734] = [770];

				#if windows
				tree[770] = ["#abra04#Wait, what the heck am I doing!? I can just check the header of the original cross-universe HTTP request you used to download the EXE file."];
				#elseif html5
				tree[770] = ["#abra04#Wait, what the heck am I doing!? I can just check the header of the original cross-universe HTTP request you used to download the HTML file."];
				#elseif android
				tree[770] = ["#abra04#Wait, what the heck am I doing!? I can just check the header of the original cross-universe HTTP request you used to download the APK file."];
				#else
				tree[770] = ["#abra04#Wait, what the heck am I doing!? I can just check the header of the original cross-universe HTTP request you used to download the SWF file."];
				#end
				tree[771] = ["#abra05#I don't need your help for this, I just... mhmm... here we go.... mhmm... Okay! I can work with this."];
				tree[772] = ["#abra02#Just need a DNS server and... Hey wow! First try!!"];
				tree[773] = ["#abra04#...Okay, go ahead and work on this next puzzle! It'll give me some time to figure out where things are... Hmmm, hmmm..."];
			}
			else if (PlayerData.level == 1)
			{
				tree[0] = ["#abra08#So, I'm going to need some precise GPS data in order to zero in on which brain is actually your brain."];
				tree[1] = ["#abra10#...If I somehow zero in on the wrong brain to swap with, they'll obviously never synchronize and we'll just be wasting our time."];
				tree[2] = ["#abra05#Now everyday household gadgets have access to consumer-grade GPS data which is fuzzed to a lower level of accuracy. So, we need something more precise."];
				tree[3] = ["#abra04#And unfortunately for us, the government usually keeps this kind of highly-accurate GPS data on lockdown. So bear with me here--"];
				tree[4] = ["#abra06#--I'm going to need you to burn a virus onto a few thumb drives, and get them in range of an active military base. Can you do that for me?"];
				tree[5] = [40, 30, 20, 50, 10];

				tree[10] = ["Sure!"];
				tree[11] = ["#abra02#I'll even make it really easy for you, I just need you to put a USB drive in your computer and I'll write the virus for you."];
				tree[12] = [60];

				tree[20] = ["Uhh, sounds\ncomplicated"];
				tree[21] = ["#abra02#Don't worry, it's easier than it sounds. I'm not asking you to actually WRITE a virus or anything like that--"];
				tree[22] = ["#abra05#--I just need you to put a USB drive in your computer so I can write it for you!"];
				tree[23] = [60];

				tree[30] = ["Uhh, sounds\ndangerous"];
				tree[31] = ["#abra02#Don't worry, it's safer than it sounds. I'm not asking you to actually break INTO the military base or anything like that--"];
				tree[32] = ["#abra05#--I just need you to leave a few thumb drives in conspicuous places."];
				tree[33] = [60];

				tree[40] = ["No,\nsorry"];
				tree[41] = [31];

				tree[50] = ["...Wait, what!?"];
				tree[51] = [31];

				tree[60] = ["#abra04#Do you have a USB drive handy? ...Just go ahead and stick it in your computer. I'll wait here~"];
				tree[61] = [100, 135, 140, 145];

				tree[100] = ["I don't\nhave one"];
				tree[101] = ["#abra06#Oh... I mean, I guess a CD-R will work! ...It'll be harder to get the data out, but... Well, do you have a CD-R?"];
				tree[102] = ["#abra04#Just go ahead and load a rewritable CD into your computer, I'll try writing to that."];
				tree[103] = [105, 110, 115];

				tree[105] = ["I don't\nhave one of\nthose either"];
				tree[106] = ["#abra06#Hmm, did you insert it? I think I see a device I can write to... ..."];
				tree[107] = [153];

				tree[110] = ["Uhh..."];
				tree[111] = ["#abra06#Hmm, did you insert it? I think I see a device I can write to... ..."];
				tree[112] = [153];

				tree[115] = ["I'm... not\ndoing this"];
				tree[116] = ["#abra06#Hmm, did you insert it? I think I see a device I can write to... ..."];
				tree[117] = [153];

				tree[120] = ["Okay,\nit's in"];
				tree[121] = ["#abra02#Great! This'll just take a second... ..."];
				tree[122] = [153];

				tree[135] = ["Uhh..."];
				tree[136] = ["#abra06#Hmm, did you insert it? I think I see something... Oh! It looks like you've already got some stuff on here. Is it okay if I erase it? Or..."];
				tree[137] = [151];

				tree[140] = ["I'm... not\ndoing this"];
				tree[141] = ["#abra06#Hmm, did you insert it? I think I see something... Oh! It looks like you've already got some stuff on here. Is it okay if I erase it? Or..."];
				tree[142] = [151];

				tree[145] = ["Okay,\nit's in"];
				tree[146] = [150];

				tree[150] = ["#abra05#Okay let's see... Oh! It looks like you've already got some stuff on here. Is it okay if I erase it? Or..."];
				tree[151] = ["#abra04#I mean, the virus is tiny, it'll all fit. ...It's just up to you if you want to leave that little data fingerprint. I don't know where this thing will end up."];
				tree[152] = ["#abra06#Well whatever, I'll go ahead and burn the virus. You can take care of that stuff later... ..."];
				tree[153] = ["#abra05#... ...Burning, burning... ... ...Hmm hmm hmm..."];
				tree[154] = ["#abra02#... ... ...Okay, all done!"];
				tree[155] = ["#abra06#Let's see, did you have any more? Or... Well, we can always do more later~"];
				tree[156] = ["#abra04#Now we'll need to find a military base within driving distance."];
				tree[157] = ["#abra05#Once you're there you can leave this sitting out on a bench somewhere, preferably in a box or an envelope so it looks official."];
				tree[158] = ["#abra03#...Then I'll need to social engineer someone into inserting it, but that shouldn't be a problem! Okay, so... let's see..."];
				tree[159] = ["#abra06#We need a military base within, let's say, a 100 kilometer radius... mhmm... mhmm..."];
				tree[160] = ["#abra04#..."];
				tree[161] = ["#abra10#Wait, wait a minute... There's this mapping web site with a... Whoa!! What is all this!?! ...Is this... right? Why isn't it obfuscated?"];
				tree[162] = ["#abra09#If this is accurate, it looks like all the GPS data I need is actually... publicly available from some huge company? That... That can't be right..."];
				tree[163] = ["#abra08#I think something's weird on my end. Where can I find information about... ...you guys don't have pubnet in your universe? Hmm... ..."];
				tree[164] = ["#abra05#...Ehhh... Okay well, there's this online user-driven encyclopedia thing, is that what... ...Hmm, this looks good. Okay, give me a minute to do some reading."];
				tree[165] = ["#abra04#... ...Go, go work on this puzzle in the meantime, while I figure out who screwed up your universe."];
			}
			else if (PlayerData.level == 2)
			{
				tree[0] = ["%fun-nude1%"];
				tree[1] = ["#abra12#So <name>, when were you going to warn me that your universe was in the second stage of a techno-capitalist doomsday scenario? Hmmmmm!?!"];
				tree[2] = [40, 30, 10, 20];

				tree[10] = ["Is it\nreally?"];
				tree[11] = [41];

				tree[20] = ["No it\nisn't"];
				tree[21] = [41];

				tree[30] = ["Oh geez,\nyou're one\nof those..."];
				tree[31] = [41];

				tree[40] = ["Uhhh..."];
				tree[41] = ["#abra08#So, okay, not to bore you but... You'll want to know this stuff when you get to MY universe anyways. So here's the history of the internet in the POKEMON world..."];
				tree[42] = ["#abra05#ARPANET and NASA were two government initiatives launched in the 1970s, which formed the foundation of the internet and space travel as we know it today..."];
				tree[43] = ["#abra04#...And as a result, internet and satellite technology is handled by the government, and treated as a utility."];
				tree[44] = ["#abra05#They're protected from market-driven capitalism in the same way as water and electricity."];
				tree[45] = ["#abra06#Which is a good thing, because it means a power-hungry corporation can't, ehhh... Make everyone's GPS go crazy or disable everyone's internet."];
				tree[46] = ["#abra09#... ...Now in YOUR universe, something went CRAZY different... And as a result,"];
				tree[47] = ["#abra11#It seems there are corporations who have more insight and control over internet and satellite technologies than the government!?!"];
				tree[48] = ["#abra08#Like... If I'm reading this right, there are technologies with obvious military applications, which the military themselves has little or no control over!?"];
				tree[49] = ["#abra06#I mean that's... Are you serious, this all seems normal to you?"];
				tree[50] = [70, 90, 80, 100];

				tree[70] = ["You're\noverreacting"];
				tree[71] = [101];

				tree[80] = ["...Is it\nreally that\nbad?"];
				tree[81] = [101];

				tree[90] = ["Maybe\na little\nweird"];
				tree[91] = [101];

				tree[100] = ["Well..."];
				tree[101] = ["#abra08#...One moment, I'm still reading, it says that... mhmm... mhmm, mhmm..."];
				tree[102] = ["#abra09#...So the government has their own air-gapped network... ...okay, so JWICS is... I see... mhmm..."];
				tree[103] = ["#abra10#... ...Sub-orbital space flight, and... SpaceX dragon spacecraft... Wait, are you kidding me? \"SpaceX\"!?! Even the NAME sounds evil!!!"];
				tree[104] = [150, 130, 160, 140, 120];

				tree[120] = ["It's\nnothing"];
				tree[121] = [161];

				tree[130] = ["...Should\nI be\nworried?"];
				tree[131] = [161];

				tree[140] = ["Wait,\nwhat's\nJWICS?"];
				tree[141] = [161];

				tree[150] = ["Huh? What's\nwrong with\nSpaceX?"];
				tree[151] = [161];

				tree[160] = ["Ummm..."];
				tree[161] = ["#abra08#Okay well, I might need to ehh... Change a few things once I get over there. ...But in the meantime, hmm..."];
				tree[162] = ["#abra04#It seems I've used your publicly accessible, corporate controlled GPS satellite servers to zero in on your exact location, down to the meter."];
				tree[163] = ["#abra12#...Which SHOULD scare you, but I'm guessing it doesn't. ...Hmph."];
				tree[164] = ["%fun-nude2%"];
				tree[165] = ["%fun-longbreak%"];
				tree[166] = ["#abra05#Anyways, go ahead and work on this next puzzle! ...There's a few more things I need to tie up on my end. I'll be nearby~"];

				tree[10000] = ["%fun-nude2%"];
				tree[10001] = ["%fun-longbreak%"];
			}
		}
	}

	public static function fixIp(dialogTree:DialogTree, dialogger:Dialogger, text:String):Void
	{
		var regexp:EReg = ~/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/;
		var mark:String = "%mark-kc4ciky1%";
		if (text.length < 4)
		{
			mark = "%mark-alrbrmq7%";
		}
		else if (!regexp.match(text))
		{
			mark = "%mark-k7905zhp%";
		}
		else if (StringTools.startsWith(text, "255.")
		|| StringTools.startsWith(text, "192.168.")
		|| StringTools.startsWith(text, "127.")
		|| StringTools.startsWith(text, "10.")
		|| StringTools.startsWith(text, "0."))
		{
			mark = "%mark-9e295c5n%";
		}
		dialogTree.jumpTo(mark);
		dialogTree.go();
	}

	public static function story2(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.abraStoryInt == 4)
		{
			// don't swap
			if (PlayerData.level == 0)
			{
				tree[0] = ["%fun-alpha0%"];
				tree[1] = ["#self06#(Hmm, I guess Abra's still mad. ...Is anybody else around?)"];
				tree[2] = ["#self04#(... ...)"];
				tree[3] = ["#self05#(Hmph, may as well solve this first puzzle, at least it's still good practice.)"];
			}
			else if (PlayerData.level == 1)
			{
				tree[0] = ["%fun-alpha0%"];
				tree[1] = ["%entersmea%"];
				tree[2] = ["#smea05#Oh hi <name>! Why are you here solving puzzles by yourself? ...Where's Abra?"];
				tree[3] = [20, 15, 25, 10];

				tree[10] = ["Abra's\nmad at me"];
				tree[11] = [26];

				tree[15] = ["Abra's taking\na break"];
				tree[16] = [26];

				tree[20] = ["I'm just\npracticing"];
				tree[21] = [26];

				tree[25] = ["...It's\ncomplicated"];
				tree[26] = ["#smea04#Hmm I see. ...So you're just doing puzzles on your own? That doesn't seem very fun."];
				tree[27] = ["#smea02#...I can take my clothes off for you if that would help! Harf!"];
				tree[28] = [55, 50, 60, 65];

				tree[50] = ["You don't\nhave to\ndo that"];
				tree[51] = [56];

				tree[55] = ["Uhh, I'm\ngood"];
				tree[56] = ["#smea05#Oh! Okay. ...Umm, anyways, I'll be back in a few minutes if you want to hang out."];
				tree[57] = ["%exitsmea%"];
				tree[58] = ["#smea03#...Tell Abra I said hi!"];

				tree[60] = ["Thanks, I'd\nlike that"];
				tree[61] = [66];

				tree[65] = ["Aww, you\nspoil me~"];
				tree[66] = ["%proxysmea%fun-nude1%"];
				tree[67] = ["#smea00#Doot-doot doot do-doot doot..."];
				tree[68] = ["%proxysmea%fun-nude2%"];
				tree[69] = ["#smea01#Doot do-doot do-doot doot... doot!!"];
				tree[70] = ["#smea02#Ha! Ha! Come on, admit it, that was super sexy, wasn't it~"];
				tree[71] = ["%exitsmea%"];
				tree[72] = ["#smea03#Umm anyways, I'll be back in a few minutes if you want to hang out. ...Tell Abra I said hi!"];
			}
			else if (PlayerData.level == 2)
			{
				tree[0] = ["%fun-alpha0%"];
				tree[1] = ["%entersand%"];
				tree[2] = ["#sand08#Oh hey! You lookin' for Abra? ...What are you two fightin' about anyway? 'Cause she won't tell me, and she's been in her room like all week."];
				tree[3] = ["#sand06#I mean uhhh... he's been in his room all week? Shit I forget. What happened to the corkboard?"];
				tree[4] = ["#sand10#I'm uhh.... be right back."];
				tree[5] = [10, 15, 20];

				tree[10] = ["Wait,\ncorkboard?"];
				tree[11] = ["#sand05#Corkboard? Nahhh you misheard me! I said uhhh... One sec, alright?"];
				tree[12] = [22];

				tree[15] = ["Wait, isn't\nAbra a boy?"];
				tree[16] = [21];

				tree[20] = ["Wait, is\nAbra a girl!?"];

				if (!PlayerData.abraMale)
				{
					tree[15] = ["Wait, isn't\nAbra a girl?"];
					tree[20] = ["Wait, is\nAbra a boy!?"];
				}

				tree[21] = ["#sand11#Naw man! Abra's uhhhh... Abra's whatever gender you thought she was. Uhh, shit. One sec, alright?"];
				tree[22] = ["%exitsand%"];
				tree[23] = ["#sand12#Yo Abra! ABRA! Where's the corkboard at?"];
				tree[24] = ["#abra04#Mmmm? Oh. ...I'm replacing it with a computer monitor to make things easier once we find <name>'s replacement. ...That way it can update automatically."];
				tree[25] = ["#sand04#Yeah, alright, alright... But like, in the meantime, should I be callin' you a boy or a girl? 'Cause--"];
				tree[26] = ["#sand11#--Wait, hold up hold up, <name>'s REPLACEMENT?"];
				tree[27] = ["%entersand%"];
				tree[28] = ["#sand12#No, no, no no no. Stop talkin' crazy, you don't go replacing your friends 'cause of a stupid fight. C'mere."];
				tree[29] = ["%fun-alpha1%"];
				tree[30] = ["%fun-nude0%"];
				tree[31] = ["#sand05#<name>, why don't you tell Abra you're sorry. Talk this shit out."];
				tree[32] = [60, 65, 50, 55];

				tree[50] = ["I'm sorry,\nAbra"];
				tree[51] = [200];

				tree[55] = [(PlayerData.abraMale ? "He" : "She") + " should\napologize first"];
				tree[56] = ["#sand06#Ehhh?"];
				tree[57] = ["#sand12#...Well fine then. Abra, can you apologize first? Y'know, be the bigger person? ...I just don't wanna see you guys fight."];
				tree[58] = [68];

				tree[60] = ["...It's more\ncomplicated\nthan that"];
				tree[61] = [56];

				tree[65] = ["I didn't\ndo anything"];
				tree[66] = ["#sand06#Ehhh? ...Well fine then. Abra, <name> says he didn't do anything."];
				tree[67] = ["#sand05#...How about you apologize first, y'know, be the bigger person. I hate seein' you guys fight."];
				tree[68] = ["#abra12#No! ...There's not even any point."];
				tree[69] = ["#sand12#C'mon Abra, you're better than that. <name> cares about you, you're hurting his feelings."];
				tree[70] = ["#abra13#<name>'s feelings don't matter anymore. I shouldn't even be letting you TALK to him after... what he did."];
				tree[71] = ["#sand10#The fuck, <name>? ...What did you do!?"];
				tree[72] = ["#abra12#NO!!!"];
				tree[73] = [120, 140, 160, 100];

				tree[100] = ["Abra wanted\nto switch\nbodies with\nme and I\nsaid no"];
				tree[101] = ["%crashsoon%"];
				tree[102] = ["#abra13#NO! NO! That's the... the WHOLE reason I... NNNGGGGGHHHHH!!!"];
				tree[103] = ["#sand06#Wait, what? What the hell's he talking about?"];
				tree[104] = ["#abra12#He's fucking LYING is what he's doing. He's just trying... trying to make me seem crazy so you'll take his side!"];
				tree[105] = ["#sand10#You're not really making any sense. ...What's this about switching bodies?"];
				tree[106] = ["#abra04#...One second, I just need to do something really quick..."];
				tree[107] = ["#sand06#Ehhh? Wait, what are you doing?"];
				tree[108] = ["#abra05#... ..."];
				tree[109] = ["#abra04#... ... ..."];
				tree[110] = ["#sand08#Abra? Seriously c'mon, what are you doing?"];
				tree[111] = ["#abra05#... ..."];
				tree[112] = ["#abra04#... ... ..."];
				tree[113] = ["#sand09#Can we at least talk about it? Is it like... Is it somethin' I can help with?"];
				tree[114] = ["#abra05#... ..."];
				tree[115] = ["#abra04#... ... ..."];
				tree[116] = ["#sand08#Why are you being like this? ...<name> and I, we're your friends. C'mon, just... just talk. Please?"];
				tree[117] = ["#abra05#... ..."];
				tree[118] = ["#abra04#... ... ..."];

				tree[120] = ["I beat Abra\nat one of\n" + (PlayerData.abraMale?"his":"her") + " minigames"];
				tree[121] = ["#sand06#Wait, really? ...That's it?"];
				tree[122] = ["#abra09#... ..."];
				tree[123] = ["#abra08#-sigh- Yes, <name> beat me at a minigame."];
				tree[124] = ["#abra09#...I'd been working on that game for several years, and I had my heart set on winning, and... <name> ruined everything."];
				tree[125] = ["#sand12#Well that's... fuckin' stupid. I'm with <name> on this one. You gotta let that shit go, Abra."];
				tree[126] = ["%fun-alpha0%"];
				tree[127] = ["#abra12#...Just... Just leave me alone, alright?"];
				tree[128] = ["#sand08#C'mon, Abra... ..."];
				tree[129] = ["#sand09#... ..."];
				tree[130] = ["#sand08#Well I dunno, I tried. ...I guess we can give it a few days and maybe things'll work out... ..."];
				tree[131] = ["%exitsand%"];
				tree[132] = ["#sand06#...I'll try to make sure uhh, he doesn't unplug you or nothing. Alright?"];

				tree[140] = ["Abra asked\nme to do\nsomething I\ndidn't want\nto do"];
				tree[141] = ["#sand06#Wait, what? ...You mean like some kind of sex thing?"];
				tree[142] = ["#abra09#... ..."];
				tree[143] = ["#abra08#-sigh- Yes, <name> wouldn't do a... sex thing I wanted him to do."];
				tree[144] = ["#abra09#...I'd been looking forward to that specific sex thing for several years, and I had my heart set on... the sex."];
				tree[145] = ["#abra05#And now I have to find somebody different, for the sex thing."];
				tree[146] = [125];

				tree[160] = ["I probably\nshouldn't\nsay"];
				tree[161] = ["#sand06#Huh? What is it, like... some kind of embarrassing sex thing?"];
				tree[162] = [142];

				tree[200] = ["#abra12#Hmph. If you were REALLY sorry, you'd change your mind."];
				tree[201] = [210, 215, 225, 230];

				tree[210] = ["No,\nyou're being\nselfish"];
				tree[211] = ["#abra13#Selfish!?! I'm not the selfish one here, I'M not the one who wasted SIX YEARS of someone else's research for no good reason."];
				tree[212] = [71];

				tree[215] = ["C'mon,\ncan't you\nlet it go"];
				tree[216] = ["#abra13#Let it GO!? Sure, I'll just let the past six years of my LIFE go!? Is that what you mean?"];
				tree[217] = ["#abra12#God, it's like you don't even... ... Nngggghh!!"];
				tree[218] = ["#abra09#... ...Whatever. I'm going back to my room."];
				tree[219] = [71];

				tree[225] = ["No,\nI'm not\nchanging\nmy mind"];
				tree[226] = ["#abra13#Of course you're not changing your mind. Why should you give a shit about ruining my life?"];
				tree[227] = ["#abra12#... ...Whatever. I'm going back to my room."];
				tree[228] = [71];

				tree[230] = ["Okay, okay.\nI'll do it"];
				tree[231] = ["#abra06#Wait, are you serious <name>? ...You really changed your mind? You'll do... the thing we talked about?"];
				tree[232] = [255, 250, 240];

				tree[240] = ["No,\nnevermind"];
				tree[241] = [300];

				tree[250] = ["Yeah, I\nreally want\nto do it"];
				tree[251] = [256];

				tree[255] = ["Yeah, if this\nis the only\nway we can\nstay friends"];
				tree[256] = ["%setabrastory-3%"];
				tree[257] = ["#abra03#Wow really!?! What changed your mind? Was it because-- you know what, it doesn't matter. I'm just glad you're on board~"];
				tree[258] = ["#abra04#...I'm going to start getting things ready, you sort of caught me in the middle of something! ...Just give me a few days."];
				tree[259] = ["%fun-alpha0%"];
				tree[260] = ["#abra02#I'll be around if you need me, though! Let me know if something important comes up. "];
				tree[261] = ["#abra00#And ummm... thanks~"];
				tree[262] = ["#sand06#Uhh, alright, cool. ...Glad we could uhh, work this out, I guess. See you around, <name>."];
				tree[263] = ["%exitsand%"];
				tree[264] = ["#sand04#Hey! Hey Abra. What was that all about?"];
				tree[265] = ["#sand01#...What are you and <name> gonna do together? ...Can I watch?"];

				tree[300] = ["#abra13#Ugh I can't believe you. You are SO fucking selfish. ...Don't... Just don't fucking talk to me. I never want to see you again."];
				tree[301] = [71];

				tree[10000] = ["%fun-alpha0%"];

				if (PlayerData.gender == PlayerData.Gender.Girl)
				{
					DialogTree.replace(tree, 66, "says he", "says she");
					DialogTree.replace(tree, 69, "hurting his", "hurting her");
					DialogTree.replace(tree, 70, "to him", "to her");
					DialogTree.replace(tree, 70, "he did", "she did");
					DialogTree.replace(tree, 103, "hell's he", "hell's she");
					DialogTree.replace(tree, 104, "He's fucking", "She's fucking");
					DialogTree.replace(tree, 104, "he's doing", "she's doing");
					DialogTree.replace(tree, 104, "He's just", "She's just");
					DialogTree.replace(tree, 104, "his side", "her side");
					DialogTree.replace(tree, 143, "him to", "her to");
				}
				else if (PlayerData.gender == PlayerData.Gender.Complicated)
				{
					DialogTree.replace(tree, 66, "says he", "says they");
					DialogTree.replace(tree, 69, "hurting his", "hurting their");
					DialogTree.replace(tree, 70, "to him", "to them");
					DialogTree.replace(tree, 70, "he did", "they did");
					DialogTree.replace(tree, 103, "hell's he", "hell are they");
					DialogTree.replace(tree, 104, "He's fucking", "They're fucking");
					DialogTree.replace(tree, 104, "he's doing", "they're doing");
					DialogTree.replace(tree, 104, "He's just", "They're just");
					DialogTree.replace(tree, 104, "his side", "their side");
					DialogTree.replace(tree, 143, "him to", "them to");
				}
				if (!PlayerData.abraMale)
				{
					DialogTree.replace(tree, 132, "he doesn't", "she doesn't");
				}
			}
		}
		else
		{
			if (PlayerData.level == 0)
			{
				var rank:Int = RankTracker.computeAggregateRank();
				tree[0] = ["#abra02#Oh, hey <name>! Hmmmm, I haven't checked on your rank in awhile, how's that coming?"];

				if (rank == 0)
				{
					tree[1] = ["#abra10#Wait, you haven't started rank mode yet!?! But... but... I was really hoping that... ..."];
					tree[2] = ["#abra08#... ..."];
					tree[3] = [10];
				}
				else if (rank < 16)
				{
					tree[1] = ["#abra08#Ohhh... Rank " + englishNumber(rank) + "? ... ...That's even lower than I expected. This doesn't bode well for my plan... ..."];
					tree[2] = ["#abra09#... ..."];
					tree[3] = [10];
				}
				else if (rank < 32)
				{
					tree[1] = ["#abra08#Ohhh... Rank " + englishNumber(rank) + "? ... ...Hmm, that's a little lower than I would have liked. This doesn't bode well for my plan... ..."];
					tree[2] = ["#abra09#... ..."];
					tree[3] = [10];
				}
				else if (rank < 38)
				{
					tree[1] = ["#abra06#Ohhh... Rank " + englishNumber(rank) + "? ... ...I was hoping you would have gotten that higher by now. I wonder if my plan can still work... ..."];
					tree[2] = ["#abra04#... ..."];
					tree[3] = [10];
				}
				else if (rank < 44)
				{
					tree[1] = ["#abra06#Ohhh... Rank " + englishNumber(rank) + "? ... ...I guess that's about what I expected from you. I wonder if my plan can still work... ..."];
					tree[2] = ["#abra04#... ..."];
					tree[3] = [10];
				}
				else if (rank < 50)
				{
					tree[1] = ["#abra03#Oh! Rank " + englishNumber(rank) + "! ...That's a little higher than I expected. ...My plan might actually have a chance of working~"];
					tree[2] = ["#abra04#... ..."];
					tree[3] = [10];
				}
				else
				{
					tree[1] = ["#abra03#Oh! Rank " + englishNumber(rank) + "! ...For some reason I had much lower expectations of you, <name>. ...My plan might actually have a chance of working~"];
					tree[2] = ["#abra04#... ..."];
					tree[3] = [10];
				}

				tree[10] = ["#abra05#I told you how our brains are mapped to our consciousness through the reticular nucleus of the thalamus..."];
				tree[11] = ["#abra04#...And how this mind-brain force might be able to swap us if our thalamus had a similar fingerprint. You remember, yes?"];
				tree[12] = [20, 30, 40, 50];

				tree[20] = ["Yeah!\nI remember"];
				tree[21] = [51];

				tree[30] = ["Hmm,\nthat rings\na bell..."];
				tree[31] = [51];

				tree[40] = ["Uhh,\nsomething\nlike that..."];
				tree[41] = [51];

				tree[50] = ["Hmmmm..."];
				tree[51] = ["#abra06#Well... The levels of neurokinetic activity in my thalamus versus a typical human thalamus differ by several orders of magnitude."];
				tree[52] = ["#abra04#You might be wondering just how different they are, and I was wondering the same thing. ...So, I came up with this rank system to measure."];
				tree[53] = ["#abra05#I solved about 200 puzzles of varying difficulty, and timed myself to establish a baseline level of neural activity."];
				tree[54] = ["#abra04#So... my baseline level of neurokinetic activity corresponds to rank 100."];
				if (rank == 0)
				{
					tree[55] = ["#abra06#For comparison, Rhydon's around rank 14 on a good day, and Grovyle's about 35."];
					tree[56] = ["#abra05#And even though you haven't participated in the rank system, if I had to guess, I'd say you're somewhere around 20-30."];
					tree[57] = [60];
				}
				else
				{
					tree[55] = ["#abra06#For comparison, Rhydon's around rank 14 on a good day, Grovyle's about 35, and well you're rank " + englishNumber(rank) + "."];
					tree[56] = [60];
				}
				tree[60] = ["#abra12#...Now don't flatter yourself, it's a logarithmic scale."];
				tree[61] = ["#abra04#So, obviously there's an incredible gap to cover before we can swap successfully."];
				tree[62] = ["#abra02#..There are some questionable ways I might be able to tweak our neurokinetics at the last second, but... Well, the higher you can get your rank, the better. Okay?"];
			}
			else if (PlayerData.level == 1)
			{
				if (PlayerData.abraMale)
				{
					if (PlayerData.gender == PlayerData.Gender.Boy || PlayerData.gender == PlayerData.Gender.Complicated)
					{
						// boy becoming a boy
						tree[0] = ["#abra08#So hmmm... ...Just a little thought experiment..."];
						tree[1] = ["#abra09#What if one day, you randomly woke up with a vagina? ...How would you react?"];
						tree[2] = [40, 10, 30, 20];
						if (PlayerData.gender == PlayerData.Gender.Complicated)
						{
							// add "i already have a vagina" prompt
							tree[2] = [40, 10, 45, 30, 20];
						}

						tree[10] = ["I'd go to\ntown on it"];
						tree[11] = ["#abra02#Ehh-hehehehe! Hmmm, well that's a good sign."];
						tree[12] = ["#abra04#...Because I probably should have told you this before,"];
						tree[13] = [51];

						tree[20] = ["I'd be\nconfused?"];
						tree[21] = [50];

						tree[30] = ["I'd be\nOK"];
						tree[31] = [50];

						tree[40] = ["I'd\nhate it"];
						tree[41] = ["#abra11#HATE it? Oh wow... Ehh... Then I guess I should have told you this a lot sooner,"];
						tree[42] = [51];

						tree[45] = ["I'd be more\nworried\nwaking up\nwithout\nmy vagina"];
						tree[46] = ["#abra02#Oh! Well that makes things easier. ...Because hmm... ...I probably should have told you this before,"];
						tree[47] = [51];

						tree[50] = ["#abra04#Alright, because hmmm... ...I probably should have told you this before,"];
						tree[51] = ["#abra06#But that abra penis you've grown so attached to, it's not actually... Hmm."];
						tree[52] = ["#abra08#...Well, that's all digital. It... It looks like I have a penis. But... I'm a girl. I've been a girl all along."];

						if (PlayerData.sexualPreference == PlayerData.SexualPreference.Boys)
						{
							tree[53] = [60, 80, 75, 70];
							if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_MARS_SOFTWARE) || ItemDatabase.playerHasItem(ItemDatabase.ITEM_VENUS_SOFTWARE))
							{
								/*
								 * likes boys, and bought mars/venus software...
								 * the player can maybe connect the dots about the
								 * software, but wasn't offered the female->male
								 * software
								 */
								tree[53] = [60, 80, 75, 70, 90];
							}
						}
						else
						{
							// add "i already knew that" prompts
							tree[53] = [100, 80, 75, 70, 110];
						}

						tree[60] = ["But... I've\ntouched it"];
						tree[61] = ["#abra05#Well, yes, it looks very real on your side. There was a little digital trickery there,"];
						tree[62] = ["#abra04#We motion captured some interactions with male genitals, and overlayed them over parts of my body so they'd look real."];
						tree[63] = ["#abra05#...And when you interacted with my vagina during our sessions, we played the male interactions instead."];
						tree[64] = ["#abra08#... ...Everybody else is in on it too. Some of them are females themselves, actually."];
						tree[65] = [120];

						tree[70] = ["But... It\nlooks\nnormal"];
						tree[71] = [61];

						tree[75] = ["I already\nfigured\nthat out"];
						tree[76] = ["#abra02#...Oh! ...Really? Hmmmm..."];
						tree[77] = ["#abra03#Well that makes this a lot less awkward~"];
						tree[78] = [120];

						tree[80] = ["But...\nEverybody\ncalls you\n\"he\" and\n\"him\""];
						tree[81] = ["#abra05#Well, yes, that was just a matter of proper training and visual aids."];
						tree[82] = ["#abra04#...There's a little corkboard offscreen with everyone's perceived genders, and we just have to be careful not to slip up when referring to pronouns or genitals."];
						tree[83] = ["#abra12#Actually, you may have noticed one or two slip-ups throughout the game, particularly with that inept Lucario."];
						tree[84] = ["#abra05#...I sort of pulled him in on a whim, and didn't have a chance to train him the way I trained everyone else."];
						tree[85] = [120];

						tree[90] = ["So, something\nlike that\ndigital\nvagina\nsoftware?"];
						if (!PlayerData.grovMale)
						{
							tree[91] = ["#abra05#...Yes, there's a male version of that software too. ...Grovyle turned it on when she first asked you those questions about your sexual orientation."];
							tree[92] = [120];
						}
						else
						{
							tree[91] = ["#abra04#...Yes, there's a male version of that software too. ...Grovyle turned that software on when he first asked you those questions about your sexual orientation."];
							tree[92] = ["#abra06#Or I guess I should say, \"When SHE asked you\"? No point in... ...No, nevermind, \"when he asked you\"."];
							tree[93] = ["#abra05#I may as well continue calling Grovyle \"he\", it'll be easier than re-training everyone to use different pronouns again."];
							tree[94] = [120];
						}

						tree[100] = ["Hmm, yeah\nthat makes\nsense"];
						tree[101] = ["#abra05#Mhmm... I just wanted to be sure you didn't incorrectly assume that I was, well, magically turned into a boy or something."];
						tree[102] = [120];

						tree[110] = ["Yeah, I\nremember you\nbeing a girl"];
						tree[111] = [101];

						tree[120] = ["#abra04#...So, of course this means that when you and I swap brains,"];
						if (PlayerData.gender == PlayerData.Gender.Boy)
						{
							tree[121] = ["#abra05#You'll still be <name> on the inside, but... you'll have a vagina. Instead of a penis."];
							tree[122] = ["#abra06#Which might be weird at first, but I think you'll get used to it."];
							tree[123] = ["#abra04#...Besides, I'll have to get used to having a penis flopping around all day! I'll bet that gets distracting too..."];
							tree[124] = [130];
						}
						else
						{
							tree[121] = ["#abra05#You'll still be <name> on the inside, but... you'll have a vagina. Instead of whatever you have now."];
							tree[122] = ["#abra06#Which might be weird at first, but I think you'll get used to it."];
							tree[123] = ["#abra04#...Besides, I'll have to get used to... ...whatever your situation is, down there! I'm sure that'll be a little strange at first too..."];
							tree[124] = [130];
						}

						tree[130] = ["#abra08#... ..."];
						tree[131] = ["#abra09#And, really... ...Sorry... I'm sorry I didn't tell you all this stuff sooner. ...That was selfish of me."];
						tree[132] = [150, 160, 180, 170, 190];

						tree[150] = ["Hey, it's\nno big deal"];
						tree[151] = ["#abra02#Oh! ...I'm glad you're okay with this. I was preparing myself for the worst~"];
						tree[152] = [200];

						tree[160] = ["Oh... I\nforgive you"];
						tree[161] = ["#abra00#Oh... Well thanks, I'm glad to hear that. ...I was preparing myself for the worst."];
						tree[162] = [200];

						tree[170] = ["Better\nlate than\nnever, I\nguess..."];
						tree[171] = ["#abra08#I mean... I had planned to tell you eventually. ...It's just a difficult thing to bring up... ..."];
						tree[172] = [200];

						tree[180] = ["You should\nhave told\nme sooner"];
						tree[181] = ["#abra08#I mean... I wanted to tell you a long time ago. ...It's just a difficult thing to bring up... ..."];
						tree[182] = [200];

						tree[190] = ["..."];
						tree[191] = ["#abra08#... ...(sigh)..."];
						tree[192] = [200];

						tree[200] = ["#abra06#Anyways <name>, why don't you take a puzzle to think things over."];

						if (!PlayerData.lucaMale)
						{
							DialogTree.replace(tree, 84, "pulled him", "pulled her");
							DialogTree.replace(tree, 84, "train him", "train her");
						}
					}
					else
					{
						// girl becoming a boy
						tree[0] = ["#abra08#So hmmm... ...Just a little thought experiment..."];
						tree[1] = ["#abra09#What if we swapped places, so you became an abra but... for some reason, you were still a girl?"];
						tree[2] = [40, 10, 30, 20];

						tree[10] = ["I'd be\necstatic"];
						tree[11] = ["#abra02#Ehh-hehehehe! Hmmm, well that's a good sign."];
						tree[12] = ["#abra04#...Because I probably should have told you this before,"];
						tree[13] = [51];

						tree[20] = ["I'd be fine\nwith it"];
						tree[21] = [50];

						tree[30] = ["I'd be\nangry"];
						tree[31] = ["#abra11#You... You'd actually be angry? Oh wow... Ehh... Then I guess I should have told you this a lot sooner,"];
						tree[32] = [51];

						tree[40] = ["I'd be\ndisappointed"];
						tree[41] = [50];

						tree[50] = ["#abra04#Alright, because hmmm... ...I probably should have told you this before,"];
						tree[51] = ["#abra06#But that abra penis you've grown so attached to, it's not actually... Hmm."];
						tree[52] = ["#abra08#...Well, that's all digital. It... It looks like I have a penis. But... I'm a girl. I've been a girl all along."];

						if (PlayerData.sexualPreference == PlayerData.SexualPreference.Boys)
						{
							tree[53] = [60, 80, 75, 70];
							if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_MARS_SOFTWARE) || ItemDatabase.playerHasItem(ItemDatabase.ITEM_VENUS_SOFTWARE))
							{
								/*
								 * likes boys, and bought mars/venus software...
								 * the player can maybe connect the dots about the
								 * software, but wasn't offered the female->male
								 * software
								 */
								tree[53] = [60, 80, 75, 70, 90];
							}
						}
						else
						{
							// add "i already knew that" prompts
							tree[53] = [100, 80, 75, 70, 110];
						}

						tree[60] = ["But... I've\ntouched it"];
						tree[61] = ["#abra05#Well, yes, it looks very real on your side. There was a little digital trickery there,"];
						tree[62] = ["#abra04#We motion captured some interactions with male genitals, and overlayed them over parts of my body so they'd look real."];
						tree[63] = ["#abra05#...And when you interacted with my vagina during our sessions, we played the male interactions instead."];
						tree[64] = ["#abra08#... ...Everybody else is in on it too. Some of them are females themselves, actually."];
						tree[65] = [120];

						tree[70] = ["But... It\nlooks\nnormal"];
						tree[71] = [61];

						tree[75] = ["I already\nfigured\nthat out"];
						tree[76] = ["#abra02#...Oh! ...Really? Hmmmm..."];
						tree[77] = ["#abra03#Well that makes this a lot less awkward~"];
						tree[78] = [120];

						tree[80] = ["But...\nEverybody\ncalls you\n\"he\" and\n\"him\""];
						tree[81] = ["#abra05#Well, yes, that was just a matter of proper training and visual aids."];
						tree[82] = ["#abra04#...There's a little corkboard offscreen with everyone's perceived genders, and we just have to be careful not to slip up when referring to pronouns or genitals."];
						tree[83] = ["#abra12#Actually, you may have noticed one or two slip-ups throughout the game, particularly with that inept Lucario."];
						tree[84] = ["#abra05#...I sort of pulled him in on a whim, and didn't have a chance to train him the way I trained everyone else."];
						tree[85] = [120];

						tree[90] = ["You mean\nwith\nsomething\nlike that\ndigital\nvagina\nsoftware?"];
						if (!PlayerData.grovMale)
						{
							tree[91] = ["#abra05#...Yes, there's a male version of that software too. ...Grovyle turned it on when she first asked you those questions about your sexual orientation."];
							tree[92] = [120];
						}
						else
						{
							tree[91] = ["#abra04#...Yes, there's a male version of that software too. ...Grovyle turned that software on when he first asked you those questions about your sexual orientation."];
							tree[92] = ["#abra06#Or I guess I should say, \"When SHE asked you\"? No point in... ...No, nevermind, \"when he asked you\"."];
							tree[93] = ["#abra05#I may as well continue calling Grovyle \"he\", it'll be easier than re-training everyone to use different pronouns again."];
							tree[94] = [120];
						}

						tree[100] = ["Hmm, yeah\nthat makes\nsense"];
						tree[101] = ["#abra05#Mhmm... I just wanted to be sure you didn't incorrectly assume that I was, well, magically turned into a boy or something."];
						tree[102] = [120];

						tree[110] = ["Yeah, I\nremember you\nbeing a girl"];
						tree[111] = [101];

						tree[120] = ["#abra04#...So I mean, it should be an easy swap! ...But just in case you were looking forward to carrying around a little abra weiner with you all day,"];
						tree[121] = ["#abra09#Well. I didn't want to disappoint you."];
						tree[122] = [130];

						tree[130] = ["#abra08#... ..."];
						tree[131] = ["#abra09#And, really... ...Sorry... I'm sorry I didn't tell you all this stuff sooner. ...That was selfish of me."];
						tree[132] = [150, 160, 180, 170, 190];

						tree[150] = ["Hey, it's\nno big deal"];
						tree[151] = ["#abra02#Oh! ...I'm glad you're okay with this. I was preparing myself for the worst~"];
						tree[152] = [200];

						tree[160] = ["Oh... I\nforgive you"];
						tree[161] = ["#abra00#Oh... Well thanks, I'm glad to hear that. ...I was preparing myself for the worst."];
						tree[162] = [200];

						tree[170] = ["Better\nlate than\nnever, I\nguess..."];
						tree[171] = ["#abra08#I mean... I had planned to tell you eventually. ...It's just a difficult thing to bring up... ..."];
						tree[172] = [200];

						tree[180] = ["You should\nhave told\nme sooner"];
						tree[181] = ["#abra08#I mean... I wanted to tell you a long time ago. ...It's just a difficult thing to bring up... ..."];
						tree[182] = [200];

						tree[190] = ["..."];
						tree[191] = ["#abra08#... ...(sigh)..."];
						tree[192] = [200];

						tree[200] = ["#abra06#Anyways <name>, why don't you take a puzzle to think things over."];

						if (!PlayerData.lucaMale)
						{
							DialogTree.replace(tree, 84, "pulled him", "pulled her");
							DialogTree.replace(tree, 84, "train him", "train her");
						}
					}
				}
				else
				{
					if (PlayerData.gender == PlayerData.Gender.Boy || PlayerData.gender == PlayerData.Gender.Complicated)
					{
						// boy becoming a girl
						tree[0] = ["#abra08#So hmmm... ...Just a little thought experiment..."];
						tree[1] = ["#abra09#What if one day, you randomly woke up with a vagina? ...How would you react?"];
						tree[2] = [40, 10, 30, 20];
						if (PlayerData.gender == PlayerData.Gender.Complicated)
						{
							// add "i already have a vagina" prompt
							tree[2] = [40, 10, 45, 30, 20];
						}

						tree[10] = ["I'd go to\ntown on it"];
						tree[11] = ["#abra02#Ehh-hehehehe! Hmmm, well that's a good sign."];
						tree[12] = ["#abra04#...Because hopefully you realized the implications of the swap."];
						tree[13] = [51];

						tree[20] = ["I'd be\nconfused?"];
						tree[21] = [50];

						tree[30] = ["I'd be\nOK"];
						tree[31] = [50];

						tree[40] = ["I'd\nhate it"];
						tree[41] = ["#abra11#HATE it? Oh wow... Ehh... Hopefully you realized the implications of the swap,"];
						tree[42] = [51];

						tree[45] = ["I'd be more\nworried\nwaking up\nwithout\nmy vagina"];
						tree[46] = ["#abra02#Oh! Well that makes things easier. ...Because hmm... ...Hopefully you realized the implications of the swap,"];
						tree[47] = [51];

						tree[50] = ["#abra04#Alright, because hmmm... ... Hopefully you realized the implications of the swap,"];
						tree[51] = ["#abra06#I've never done anything like this before, but I'm guessing your entire consciousness will transfer over, including your current gender identity."];
						tree[52] = ["#abra08#...So you're still going to be <name> inside, but... you'll have a vagina. Instead of a penis."];
						if (PlayerData.gender == PlayerData.Gender.Boy)
						{
							tree[53] = ["#abra06#Which might be weird at first, but I think you'll get used to it."];
							tree[54] = ["#abra04#...Besides, I'll have to get used to having a penis flopping around all day! I'll bet that gets distracting too..."];
							tree[55] = [60];
						}
						else
						{
							tree[53] = ["#abra06#Which might be weird at first, but I think you'll get used to it."];
							tree[54] = ["#abra04#...Besides, I'll have to get used to... ...whatever your situation is, down there! I'm sure that'll be a little strange at first too..."];
							tree[55] = [60];
						}

						tree[60] = ["#abra05#... ..."];
						tree[61] = ["#abra04#Hopefully this didn't come as a big surprise or anything. ...I just wanted to make sure you realized."];
						tree[62] = [150, 160, 180, 170, 190];

						tree[150] = ["I can't\nwait to be\nfemale,\nactually"];
						tree[151] = ["#abra02#Oh! ...Well that's great to hear. I think I'll enjoy being a boy too~"];
						tree[152] = [200];

						tree[160] = ["Yeah! I think\nI'll get\nused to it"];
						tree[161] = ["#abra02#Oh... Well I think you will, too~"];
						tree[162] = [200];

						tree[170] = ["It might be\na little\nweird"];
						tree[171] = ["#abra08#Oh... Well, maybe a little... ..."];
						tree[172] = [200];

						tree[180] = ["Hmm... Maybe\nwe shouldn't\nswitch..."];
						tree[181] = ["#abra08#... ...(sigh)..."];
						tree[182] = [200];

						tree[190] = ["..."];
						tree[191] = ["#abra08#... ...(sigh)..."];
						tree[192] = [200];

						tree[200] = ["#abra06#Anyways <name>, why don't you take a puzzle to think things over."];
					}
					else
					{
						// girl becoming a girl
						tree[0] = ["#abra04#So mmm, it seems obvious but just in case... When we swap, you shouldn't call yourself <name> anymore."];
						tree[1] = ["#abra05#I'll be a human, so I'll call myself <name>, since that's a good human name. ...And you'll be a Pokemon, so you should just call yourself Abra."];
						tree[2] = [40, 10, 20, 30];

						tree[10] = ["Hmm,\nalright"];
						tree[11] = [50];

						tree[20] = ["That's too\nconfusing,\nlet's swap\nnames"];
						tree[21] = ["#abra06#What? ...It's one thing for my Pokemon friends to call you <name>, but I definitely can't go by Abra in your universe."];
						tree[22] = [51];

						tree[30] = ["Wait, Abra\nis your\nreal name!?"];
						tree[31] = ["#abra06#Mmmmm well... it's what everyone calls me! ...It seems like it has the potential to be ambiguous, but that doesn't come up often."];
						tree[32] = ["#abra05#...I mean you humans have about 800 first names, but I doubt it causes confusion when you're around two people named John."];
						tree[33] = ["#abra04#Well, there are 800 different Pokemon, so the odds of someone needing to speak with two different abras is pretty small."];
						tree[34] = ["#abra02#And if you end up befriending another abra, you can just adopt a nickname."];
						tree[35] = ["#abra05#... ...Hmm, actually, it might be disorienting having people call me \"<name>\". ...But I obviously can't go by Abra in your universe."];
						tree[36] = [51];

						tree[40] = ["Wait,\n<name>\nisn't my\nreal name..."];
						tree[41] = ["#abra06#Ehh? ...Well then, what IS your real name?"];
						tree[42] = ["#abra05#... ...No, no, on second thought I don't want to have to remember two names."];
						tree[43] = ["#abra04#I'll just figure out your real name after we swap. ...I'm sure it's on your driver's license or something."];
						tree[44] = [50];

						tree[50] = ["#abra05#...It might be a little disorienting going by a different name, but I'll get used it. ...And anyways, I obviously can't go by Abra in your universe."];
						tree[51] = ["#abra02#I mean... I don't want my new human friends to think of me as some developmentally stunted manchild who's obsessed with Pokemon. ...No offense~"];
						tree[52] = ["#abra03#Eee-heheheheh! I just realized I'm going to get to meet all of your hairy human friends. This is going to be fun, isn't it?"];
					}
				}
			}
			else if (PlayerData.level == 2)
			{
				if (!PlayerData.abraMale && PlayerData.gender == PlayerData.Gender.Girl)
				{
					// girl becoming a girl; we already did "name" dialog, so just skip it
					tree[0] = ["#abra06#I can't think of anything else to say. ...That's everything I wanted to warn you about."];
					tree[1] = ["#abra05#The rank thing, the name thing... Oh, well I guess the last thing is, well, hmmm..."];
					tree[2] = [102];
				}
				else
				{
					tree[0] = ["#abra04#So mmm, it seems obvious but just in case... When we swap, you shouldn't call yourself <name> anymore."];
					tree[1] = ["#abra05#I'll be a human, so I'll call myself <name>, since that's a good human name. ...And you'll be a Pokemon, so you should just call yourself Abra."];
					tree[2] = [40, 10, 20, 30];

					tree[10] = ["Hmm,\nalright"];
					tree[11] = [50];

					tree[20] = ["That's too\nconfusing,\nlet's swap\nnames"];
					tree[21] = ["#abra06#What? ...It's one thing for my Pokemon friends to call you <name>, but I definitely can't go by Abra in your universe."];
					tree[22] = [51];

					tree[30] = ["Wait, Abra\nis your\nreal name!?"];
					tree[31] = ["#abra06#Mmmmm well... it's what everyone calls me! ...It seems like it has the potential to be ambiguous, but that doesn't come up often."];
					tree[32] = ["#abra04#...I mean you humans have about 800 first names, but I doubt it causes confusion when you're around two people named John."];
					tree[33] = ["#abra05#Well, there are 800 different Pokemon, so the odds of someone needing to speak with two different Abras is pretty small."];
					tree[34] = ["#abra02#And if you end up befriending another Abra, you can just adopt a nickname."];
					tree[35] = ["#abra04#... ...Hmm, actually, it might be disorienting having people call me \"<name>\". ...But I obviously can't go by Abra in your universe."];
					tree[36] = [51];

					tree[40] = ["Wait,\n<name>\nisn't my\nreal name..."];
					tree[41] = ["#abra06#Ehh? ...Well then, what IS your real name?"];
					tree[42] = ["#abra04#... ...No, no, on second thought I don't want to have to remember two names."];
					tree[43] = ["#abra05#I'll just figure out your real name after we swap. ...I'm sure it's on your driver's license or something."];
					tree[44] = [50];

					tree[50] = ["#abra04#...It might be a little disorienting going by a different name, but I'll get used it. ...And anyways, I obviously can't go by Abra in your universe."];
					tree[51] = ["#abra02#I mean... I don't want my new human friends to think of me as some developmentally stunted manchild who's obsessed with Pokemon. ...No offense~"];
					tree[52] = ["#abra03#Eee-heheheheh! I just realized I'm going to get to meet all of your hairy human friends. This is going to be fun, isn't it?"];
					tree[53] = [100];
				}

				tree[100] = ["#abra04#But on that note... I think that's everything I wanted to warn you about."];
				tree[101] = ["#abra05#The rank thing, the vagina thing, the name thing... Oh, well I guess the last thing is, well, hmmm..."];
				tree[102] = ["#abra08#..."];
				tree[103] = ["#abra09#... ...Sometimes I like to imagine what the world would be like if you could see a specific number on everyone's forehead--"];
				tree[104] = ["#abra04#--The number of remaining times you were going to be in the same room with them. You know, until you finally drift apart."];
				tree[105] = ["#abra05#Because all friendships end, you know? ...But we never think of those kinds of life experiences as finite, or countable."];
				tree[106] = ["#abra06#We always just think, \"I'll probably see them tomorrow,\" which becomes \"I can always visit, they're just across the street,\" and eventually \"Well I have their phone number...\""];
				tree[107] = ["#abra04#But I think if we had that forehead number we could look at... Even when it was in the hundreds, people would act differently towards one another."];
				tree[108] = ["#abra05#It would sort of help them appreciate each other and get the most out of life."];
				tree[109] = ["#abra08#... ..."];
				tree[110] = ["#abra04#Sorry, I'm not usually like this. But, well,"];
				tree[111] = ["#abra05#Just imagine all your friends and family have a big glowing number one on their forehead, and make the most of it. ...Don't leave with any regrets."];
				tree[112] = ["#abra02#...Take your time, and come visit me when you're ready to swap places, okay?"];
				tree[113] = [150, 160, 200, 140];

				tree[140] = ["Hmm, okay,\nI'll take\nmy time"];
				tree[141] = ["#abra00#I'm not in any particular hurry, alright? Let's do this the right way~"];

				tree[150] = ["I don't\nneed to do\nanything"];
				tree[151] = ["#abra06#Hmmm, well even if you don't have any goodbyes to say on your side, I'd like a few final moments with Grovyle and the others."];
				tree[152] = [162];

				tree[160] = ["But I'm\nready now!"];
				tree[161] = ["#abra03#Heh! ...Well even if you don't have any goodbyes to say on your side, I'd like a few final moments with Grovyle and the others."];
				tree[162] = ["#abra02#Just give me an hour or two, if you don't mind."];
				tree[163] = ["#abra05#Anyways it'll give you one last chance to boost your rank, before we... ..."];
				tree[164] = ["#abra00#... ... ..."];
				tree[165] = ["#abra02#Well, just give me an hour or two~"];

				tree[200] = ["Actually,\nI'm having\nsecond\nthoughts"];
				tree[201] = ["#abra11#Wait, what? ...Second thoughts about what? I don't understand."];
				tree[202] = [230, 225, 215, 235, 210, 220];
				if (!PlayerData.abraMale && PlayerData.gender == PlayerData.Gender.Girl)
				{
					// both girls; no "you're a girl" thing
					tree[202] = [230, 225, 215, 235, 220];
				}

				tree[210] = ["Well,\nyou're a\ngirl..."];
				tree[211] = [250];

				tree[215] = ["Well,\nI'd be\nleaving\nbehind a\nlot..."];
				tree[216] = [250];

				tree[220] = ["Well,\nI hate\nranked\npuzzles..."];
				tree[221] = [250];

				tree[225] = ["Well,\nyou might\ndestabilize\nour\ngovernment..."];
				tree[226] = [250];

				tree[230] = ["Well,\nit's about our\nrespective\nsituations..."];
				tree[231] = [250];

				tree[235] = ["Nevermind,\nit's nothing"];
				tree[236] = ["#abra08#...?"];
				tree[237] = ["#abra05#Hmm, well alright. ...Don't scare me like that!"];
				tree[238] = ["#abra04#Take all the time you need. ...That way I can spend some final moments with Grovyle and the others."];
				tree[239] = ["#abra05#It'll also give you one last chance to boost your rank, before we... ..."];
				tree[240] = ["#abra00#... ... ..."];
				tree[241] = ["#abra02#Well, take all the time you need. Come see me when you're ready, hmm~"];

				tree[250] = ["#abra08#So--"];
				tree[251] = ["#abra09#So what are you saying...? ... ...Are you saying because of that, you don't even want to TRY going through with the swap?"];
				tree[252] = [270, 265, 285, 260, 280, 275];

				tree[260] = ["I just\nneed some\ntime"];
				tree[261] = [237];

				tree[265] = ["It would\nbe bad for\nboth of us"];
				tree[266] = [300];

				tree[270] = ["I wouldn't\nfeel\ncomfortable"];
				tree[271] = [300];

				tree[275] = ["Hmmm,\nI don't\nthink so..."];
				tree[276] = [300];

				tree[280] = ["No, there's\nno way"];
				tree[281] = [300];

				tree[285] = ["I guess\nI could\ntry it"];
				tree[286] = [237];

				tree[300] = ["%setabrastory-4%"];
				tree[301] = ["#abra11#But... ..."];
				tree[302] = ["#abra08#... ... ..."];
				tree[303] = ["%exitabra%"];
				tree[304] = ["#abra13#Fine. I understand."];
				tree[305] = ["#self08#(... ...)"];
				tree[306] = ["#self04#(Well, I guess that could have gone worse.)"];
				tree[307] = ["#self05#(...I should talk to him later.)"];

				if (!PlayerData.abraMale)
				{
					DialogTree.replace(tree, 307, "to him", "to her");
				}
			}
		}
	}

	public static function story3(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var trialCount:Int = getFinalTrialCount();

		/*
		 * trial 0: beer;     0-1-1
		 * trial 1: sake;     0-1-2
		 * trial 2: soju;     0-2-3
		 * trial 3: rum;      2-3-4
		 * trial 4: absinthe; 3-4-4
		 *
		 * 0: normal
		 * 1: slightly impaired
		 * 2: some slurred/clumsy speech
		 * 3: consistent slurred/clumsy speech
		 * 4: absolutely hammered
		 */
		if (PlayerData.abraStoryInt == 4)
		{
			// don't swap
			if (PlayerData.level == 0)
			{
				if (trialCount == 0)
				{
					tree[0] = ["%fun-drunk0%"];
					tree[1] = ["%hiderankwindow%"];
					tree[2] = ["#abra08#... ...Hi, <name>."];
					tree[3] = [20, 15, 25, 10];

					tree[10] = ["Look, I'm\nreally\nsorry"];
					tree[11] = ["#abra09#No, no, I'm sorry. ...It was immature of me to try and cut you out of my life. That was wrong. ...I was just upset."];
					tree[12] = [27];

					tree[15] = ["Are you\nfeeling\nbetter?"];
					tree[16] = ["#abra09#Ehh, yeah. ...And, I'm sorry. ...It was immature of me to try and cut you out of my life. That was wrong. ...I was just upset."];
					tree[17] = [27];

					tree[20] = ["Ugh,\nyou're\nback"];
					tree[21] = ["#abra09#No no, look, I'm sorry. ...It was immature of me to try and cut you out of my life. That was wrong. ...I was just upset."];
					tree[22] = [27];

					tree[25] = ["Did you\ncome to\napologize?"];
					tree[26] = ["#abra09#Yeah, I mean, I'm sorry. ...It was immature of me to try and cut you out of my life. That was wrong. ...I was just upset."];
					tree[27] = ["#abra04#Honestly, I'm still upset. ...And I still don't understand why you won't swap bodies with me. But I'm not here to argue, I don't..."];
					tree[28] = ["#abra08#-sigh- ...and I don't want to... TRICK you into swapping with me against your will, or anything evil like that. ...I'm not a monster."];
					tree[29] = ["#abra09#... ... ..."];
					tree[30] = ["#abra06#I just... I just want to understand, okay? I want to understand WHY. Is it something with you? ...Or something with me?"];
					tree[31] = ["#abra09#Is it like... the way I treated you? I mean... I thought about going through this process with someone new..."];
					tree[32] = ["#abra08#...Searching other universes to find someone who would be willing to actually go through with it."];
					tree[33] = ["#abra09#But if I don't understand what went wrong this time, it just feels like... I just, I really need to understand your reasoning."];
					tree[34] = ["#abra06#Can you at least try to explain it one more time? ...Why don't you want to swap with me?"];
					tree[35] = [100, 103, 106, 50, 109];

					tree[50] = ["(something\nelse...)"];
					tree[51] = ["#abra04#..."];
					tree[52] = [112, 115, 118, 60, 121];

					tree[60] = ["(something\nelse...)"];
					tree[61] = ["#abra05#..."];
					tree[62] = [124, 127, 130, 70, 133];

					tree[70] = ["(something\nelse...)"];
					tree[71] = ["#abra05#..."];
					tree[72] = [136, 139, 142, 80, 145];

					tree[80] = ["(something\nelse...)"];
					tree[81] = ["#abra04#..."];
					tree[82] = [100, 103, 106, 50, 109];

					var noReasons:Array<String> = [
													  "Because\nI'd miss\nthe life\nI left behind",
													  "Because\nmy soul mate\nis over here",
													  "Because\nthe risks are\ntoo great",
													  "Because\nwe'd both be\nmaking the\nbiggest\nmistake\nof our lives",

													  "Because\nyou're always\nlying to me",
													  "Because\nI don't\nknow you\nwell enough",
													  "Because\nI think\nyou'd still\nhave the\nsame problems",
													  "Because\nI don't want\nto be a Pokemon",

													  "Because\nI'd miss\nmy friends\ntoo much",
													  "Because\nI don't want\nto be an\nabra",
													  "Because\nI have a\ndestiny\nas a human",
													  "Because\nyou'll keep\nmaking the\nsame mistakes",

													  "Because\nyou need to\nface your\nproblems\nhead-on",
													  "Because\nit's much\ntoo soon\nto decide\nsomething\nlike this",
													  "Because\nyou'd be\ntrapped\nin my gross\nhuman body",
													  "Because\nI don't want\nto be a\ngirl",
												  ];

					for (i in 0...noReasons.length)
					{
						tree[100 + 3 * i] = [noReasons[i]];
						tree[100 + 3 * i + 1] = [160];
					}

					tree[160] = ["#abra08#... ...I wish I could say that makes sense to me. ...Sorry."];
					tree[161] = ["#abra04#I... I don't think it's your fault, okay? I just have trouble relating to other people emotionally."];
					tree[162] = ["#abra05#... ... ..."];
					tree[163] = ["#abra04#<name>, a part of the reason I was especially interested in your brain was for its heightened capacity for emotions."];
					tree[164] = ["#abra05#I think I'm missing that sort of... ...emotional connection to other people in my life-"];
					tree[165] = ["#abra06#-and I think your heightened sense of empathy would have helped me to grow as an individual. Assuming it didn't get, ehhhh, overwritten I mean."];
					tree[166] = ["#abra05#It's almost as if remotely transferring my consciousness would have allowed me to... evolve in some way. ...It sounds silly now that I say it out loud."];
					tree[167] = [180, 190, 185, 175];

					tree[175] = ["Uhh,\nactually..."];
					tree[176] = [200];

					tree[180] = ["That doesn't\nsound so\nfarfetched"];
					tree[181] = [200];

					tree[185] = ["I think\nthat's how\nKadabra\nevolves"];
					tree[186] = [200];

					tree[190] = ["Hmmmmmm..."];
					tree[191] = [200];

					tree[200] = ["%disable-skip%"];
					tree[201] = ["%showrankwindow%"];
					tree[202] = ["#abra04#But anyway, I actually have a solution. I've designed three puzzles which should help your brain temporarily sync up with my brain-"];
					tree[203] = ["#abra05#-So with any luck, your neural activity will be slightly increased for a few minutes. ...Nothing permanent, don't worry."];
					tree[204] = ["%fun-present-ipa%"];
					tree[205] = ["#abra06#...And with enough alcohol, I should be able to slow my thought processes and degrade my brain to something... ehh..."];
					tree[206] = ["#abra05#Something a little more <name>-like."];
					tree[207] = ["%fun-hold-ipa%"];
					tree[208] = ["#abra08#So anyways, do your best on these puzzles. ...And really. I'm sorry for everything."];

					tree[10000] = ["%fun-drunk0%"];
					tree[10001] = ["%fun-hold-ipa%"];
					tree[10002] = ["%showrankwindow%"];
				}
				else if (trialCount == 1)
				{
					tree[0] = ["%fun-drunk0%"];
					tree[1] = ["#abra04#So I was doing more thinking, <name>... trying to figure out your reasoning for why you won't swap with me..."];
					tree[2] = ["#abra06#Do you think maybe subconsciously, it's something like... because you've only seen me in this flash game, you don't think I really matter?"];
					tree[3] = ["#abra09#...Like, maybe this is all pretend to you, something like that?"];
					tree[4] = [10, 15, 20, 25];

					tree[10] = ["Yeah,\nexactly"];
					tree[11] = ["#abra08#Hmm. ...Well, it still doesn't make complete sense to me, but I think I'm starting to get it."];
					tree[12] = [30];

					tree[15] = ["Well, that's\na part\nof it"];
					tree[16] = ["#abra08#Hmm. ...Well, it still doesn't make complete sense to me, but I think I'm starting to get it."];
					tree[17] = [30];

					tree[20] = ["No, not\nexactly"];
					tree[21] = ["#abra08#Hmm. ...Well, it still doesn't make sense to me, but I think I'm starting to understand better."];
					tree[22] = [30];

					tree[25] = ["No, no.\nNothing\nlike that"];
					tree[26] = ["#abra08#Hmm. ...Well, it still doesn't make sense to me, but I think I'm starting to understand better."];
					tree[27] = [30];

					tree[30] = ["#abra05#...But if I'm going to synchronize my brain with yours, I'm going to need to get twice as drunk."];
					tree[31] = ["%fun-present-sake%"];
					tree[32] = ["#abra04#Sake should do the job, hmm? ...From a mathematical standpoint, it has double the alcohol content of the IPA I was drinking last time."];
					tree[33] = ["#abra06#I usually save this stuff for special occasions, but well."];
					tree[34] = ["%fun-hold-sake%"];
					tree[35] = ["#abra08#I guess today's as special an occasion as any. Hmmm."];
					tree[36] = ["#abra05#...Bottoms up, <name>~"];

					tree[10000] = ["%fun-hold-sake%"];
				}
				else if (trialCount == 2)
				{
					tree[0] = ["%fun-drunk0%"];
					tree[1] = ["#abra04#Well, so much for plan B. -sigh- I... I really thought the sake would work, too. Hmmm."];
					tree[2] = ["%fun-present-soju%"];
					tree[3] = ["#abra06#I was hoping to not have to resort to Soju, since it makes me really hung over."];
					tree[4] = ["%fun-hold-soju%"];
					tree[5] = ["#abra05#And besides, I feel like getting completely trashed might, ehhh... hinder my ability to gain any insight from your thought patterns."];
					tree[6] = ["#abra09#But well, desperate times call for desperate measures I guess."];
					tree[7] = ["#abra08#..."];
					tree[8] = ["#abra09#Anyway, you know the drill."];

					tree[10000] = ["%fun-hold-soju%"];
				}
				else if (trialCount == 3)
				{
					tree[0] = ["%fun-drunk2%"];
					tree[1] = ["%fun-present-rum%"];
					tree[2] = ["#abra03#Iiiii'm druuuuuunk alreeeeeady. Eh-heheheh~"];
					tree[3] = ["#abra06#... ...Sorry, it's 'scause of how, ehh... how different our brains are, I thought I could use a head start?"];
					tree[4] = ["%fun-hold-rum%"];
					tree[5] = ["#abra04#..."];
					tree[6] = ["#abra01#And on top of that, this is just rum today. Just STRAIGHT rum! ...The only other times I've drank this stuff is, well..."];
					tree[7] = ["#abra05#... ...Ehhhh, l-look, either this'll work. Or this won't work, and I'll throw up."];
					tree[8] = ["#abra04#Or, or it'll work, and I'll throw up."];
					tree[9] = ["#abra02#Either way I'm throwing up. ...So hopefully it'll work~"];

					tree[10000] = ["%fun-hold-rum%"];
				}
				else
				{
					tree[0] = ["%fun-drunk3%"];
					tree[1] = ["%fun-hold-absinthe%"];
					tree[2] = ["#abra07#Ohh hi " + stretch(PlayerData.name) + "! ...I've been drinking Absinthe today. Aaaabsiiiinthe... ..."];
					tree[3] = ["%fun-present-absinthe%"];
					tree[4] = ["#abra06#See? The ehhh... the skull means iss good for you! They say you're supposed to cut it with water but..."];
					tree[5] = ["%fun-hold-absinthe%"];
					tree[6] = ["#abra08#... ..."];
					tree[7] = ["#abra10#<name> I REALLY want to understand what's going on in there. And why you won't... ..."];
					tree[8] = ["#abra11#I've just. I've drank SO much alcohol... and thrown up SO much alcohol... And it's just... It's just..."];
					tree[9] = ["#abra08#... ...I just finally want this to work finally... It'll work won't it? ... ..."];

					tree[10000] = ["%fun-hold-absinthe%"];
				}
			}
			else if (PlayerData.level == 1)
			{
				if (trialCount == 0)
				{
					tree[0] = ["%fun-drunk1%"];
					tree[1] = ["%fun-hold-ipa%"];
					tree[2] = ["#abra05#Hmm. ...I missed solving puzzles with you, <name>."];
					tree[3] = ["#abra06#I know my comments had a way of, well, inadvertently demeaning your intelligence, but..."];
					tree[4] = ["#abra04#...I've always been impressed with how, ehh... How a brain like yours could... ..."];
					tree[5] = ["#abra08#... ... ..."];
					tree[6] = ["#abra09#Never... Nevermind. I'm sorry."];
				}
				else if (trialCount == 1)
				{
					tree[0] = ["%fun-drunk1%"];
					tree[1] = ["%fun-hold-sake%"];
					tree[2] = ["#abra06#Hmm, that's a bit of an anomaly..."];
					tree[3] = ["#abra04#...Even though you've used these little bugs to solve an innumerable amount of puzzles, the emotional center of your brain still lights up when you interact with them."];
					tree[4] = ["#abra05#I'd have expected your empathy towards them to have dulled from repetition. ...Like, you'd eventually recognize the bugs as objects, not as living beings."];
					tree[5] = ["#abra04#...'Cause it's like, everyone has an individual threshold where we recognize sentience. It's different for each person,"];
					tree[6] = ["#abra05#Most everyone would empathize with another human being or Pokemon. ...But we wouldn't empathize the same way with a puppy, or an insect."];
					tree[7] = ["#abra04#Somewhere in between those extremes is a threshold which varies for each of us."];
					tree[8] = ["#abra06#But for you, hmm. ... ...You sort of empathize with everything a little, don't you?"];
					tree[9] = ["#abra08#Why... Why do you feel so much? ... ...Doesn't it hurt?"];
					tree[10] = ["#abra09#... ..."];
					tree[11] = ["#abra08#Hmm."];
				}
				else if (trialCount == 2)
				{
					tree[0] = ["%fun-drunk2%"];
					tree[1] = ["%fun-hold-soju%"];
					tree[2] = ["#abra00#Heyyy waaaaait, I... I think I finally get why you won't switch. Ehh-heheheh."];
					tree[3] = ["#abra03#It's like, it's because you ehh... you resent me. And you're worried if you end up in my body, I'll end up rubbing off on you a little, right? Eh-heheheh."];
					tree[4] = ["#abra02#Like you'll sort of be a little less of yourself... and a lillmore of this, this umm... this impish asshole you barely know."];
					tree[5] = [20, 15, 10, 25];

					tree[10] = ["What!?\nNo, nothing\nlike that"];
					tree[11] = [30];

					tree[15] = ["Aww, that's\nnot it"];
					tree[16] = [30];

					tree[20] = ["Yeah,\nkind of"];
					tree[21] = [30];

					tree[25] = ["Yep, nail\non the head"];
					tree[26] = [30];

					tree[30] = ["#abra04#Look, I'm not... It isn't, I just get so easily frustrated. ...Not with you, it's just..."];
					tree[31] = ["#abra08#...It's like if you think of a, ummm... Like a, ehhh... ... Someone trying to... ... ..."];
					tree[32] = ["#abra06#I feel like... -sigh- 'slike any analogy is just going to make me sound like a dick. Just know it's... it's harder than it looks, alright?"];
					tree[33] = ["#abra09#I'm, I'm really trying. ...It's SO hard for me."];
					tree[34] = ["#abra08#I'm used to being sort of goodid did everything, but... I'm SO bad at this. ...It sucks."];

					if (!PlayerData.abraMale)
					{
						DialogTree.replace(tree, 32, "a dick", "a bitch");
					}
				}
				else if (trialCount == 3)
				{
					tree[0] = ["%fun-drunk3%"];
					tree[1] = ["%fun-hold-rum%"];
					tree[2] = ["#abra07#Well, no doubbibaboutit, I'm doing MY half. I am sooooo, soooo drunk."];
					tree[3] = ["#abra02#Maybe one two ummm... too many reverse spits. Eh-heheheh! That's what cool kids call taking a shot~"];
					tree[4] = ["#abra06#I ehh, oouugh... ..."];
					tree[5] = ["%fun-shortbreak%"];
					tree[6] = ["#abra07#... ...I think I shprobbly reverse spit some water too. ...Be, be right back."];
				}
				else
				{
					tree[0] = ["%fun-drunk4%"];
					tree[1] = ["%fun-hold-absinthe%"];
					tree[2] = ["#abra06#...Heyyyyy. Did I ever tell you about this one... ...time college, and Grovyle'ssss draggus all to this sparty but they had a, ehh..."];
					tree[3] = ["%fun-alpha0%"];
					tree[4] = ["#abra07#This old... ... (mumble, mumble...) ...and everyone's sownstairs... ... (mumble...)"];
					tree[5] = ["#zzzz06#... ...crowded but... (mumble) ...Time Pilot machine and, splaying... ... ..."];
					tree[6] = ["#self04#(Uhhhh... I think he's still talking... but I can't hear anything...)"];
					tree[7] = ["#self05#(... ...)"];
					tree[8] = ["#self04#(I... guess I'll just start the puzzle without him.)"];
					tree[9] = ["%fun-longbreak%"];
					tree[10] = null;

					tree[10000] = ["%fun-longbreak%"];

					if (!PlayerData.abraMale)
					{
						DialogTree.replace(tree, 6, "he's still", "she's still");
						DialogTree.replace(tree, 8, "without him", "without her");
					}
				}
			}
			else if (PlayerData.level == 2)
			{
				if (trialCount == 0)
				{
					tree[0] = ["%fun-drunk1%"];
					tree[1] = ["%fun-hold-ipa%"];
					tree[2] = ["#abra05#Mmmm... I think I may have miscalculated how much alcohol I would need, in order to reach your, ummm... ..."];
					tree[3] = ["#abra06#Your level of ehhh... Not, not that it's a BAD thing that you're ehh..."];
					tree[4] = ["#abra09#... ..."];
					tree[5] = ["#abra08#-sigh- I'm sorry. Aauugggghhh... ..."];
					tree[6] = ["#abra10#I just don't want to make things worse than they are, okay? ...You're... You're a good person."];
					tree[7] = ["#abra04#And... And you're by FAR the smartest out of all my friends."];
					tree[8] = ["#abra02#I don't know if you noticed, but, eeh-heheheh. Even Grovyle's actually, really pathetic when it comes to minigames and stuff."];
					tree[9] = ["#abra05#I remember the first time I showed him that scale game, and he couldn't even add up the, ehhh... ..."];
					tree[10] = ["#abra06#...Hey, wait. Wait, what? Why is that... ...Even THAT offends you? But I'm talking- talking about Grovyle! It's not even..."];
					tree[11] = ["#abra08#... ... -sigh-"];
					tree[12] = ["#abra09#Uggghhhhh I'm making it WORSE... I'm such a fuck up... ..."];
					tree[13] = ["#abra08#I can't even blame the alcohol, I... I don't even feel drunk. Just really, really tired..."];
					tree[14] = ["#abra09#-sigh- Let's just get this one over with. ...I'll try to do better next time."];

					if (!PlayerData.grovMale)
					{
						DialogTree.replace(tree, 9, "showed him", "showed her");
						DialogTree.replace(tree, 9, "and he", "and she");
					}
				}
				else if (trialCount == 1)
				{
					tree[0] = ["%fun-drunk2%"];
					tree[1] = ["%fun-hold-sake%"];
					tree[2] = ["#abra06#Is... Is it becauzz-zzze you just think I'm like..."];
					tree[3] = ["#abra08#Are you manipulating me just like these ehh... little puzzle bugs? Trying to see what happens if you say \"no\" enough? Is, is that what is, is?"];
					tree[4] = [10, 15, 20, 25];

					tree[10] = ["Well,\nyeah"];
					tree[11] = [16];

					tree[15] = ["Hmm...\nmaybe?"];
					tree[16] = ["#abra09#What!? No, that's... Nobody's like that, I just... thought maybe..."];
					tree[17] = [30];

					tree[20] = ["No, come\non..."];
					tree[21] = [26];

					tree[25] = ["What!?"];
					tree[26] = ["#abra09#That's... That's horrible, I know, I know. Nobody's like that, I just... thought maybe..."];
					tree[27] = [30];

					tree[30] = ["#abra08#... ..."];
					tree[31] = ["#abra06#I still don't get it. Why is this stuff so complicated..."];
					tree[32] = ["#abra04#Is it... Do I need more alcohol? Is this working? I feelllittle drunk... Maybe..."];
					tree[33] = ["#abra05#...Oh well. Guess we can keep trying... -sigh-"];
				}
				else if (trialCount == 2)
				{
					tree[0] = ["%fun-drunk3%"];
					tree[1] = ["%fun-hold-soju%"];
					tree[2] = ["#abra01#Gggheggh. ...I kind of wanna take a nap. And I kind of REALLY want to kind of stay awake..."];
					tree[3] = ["#abra00#You ehhh, d'you... d'you ever get like that? You know what I mean right? Mmmm."];
					tree[4] = [10, 15, 20, 25];

					tree[10] = ["Heh,\nyeah"];
					tree[11] = [30];

					tree[15] = ["Umm, I'm\nnot sure"];
					tree[16] = [30];

					tree[20] = ["You're...\nnot making\nsense"];
					tree[21] = [30];

					tree[25] = ["You really\ncan't handle\nyour liquor"];
					tree[26] = [30];

					tree[30] = ["#abra07#Well I ehh. I, I think I should be awake for the this one, I think we're finally going to mmngh sync up. Don't you feel,"];
					tree[31] = ["#abra06#Doesn't don't feel that way too? I, you're... You're flying through these puzzles, right?"];
					tree[32] = ["#abra00#Annnnd I'm defly drunk enough... Ehh-heheheh~"];
					tree[33] = ["#abra01#I think, I think this'll... I think this'll be good this time. You're god this <name>."];
				}
				else if (trialCount == 3)
				{
					tree[0] = ["%fun-drunk4%"];
					tree[1] = ["%fun-hold-rum%"];
					tree[2] = ["#abra06#I'nng get it, ssissit like... you'k, can't extend your sens... sensitive self beyond your physical perrrr-rrimiter?"];
					tree[3] = ["#abra07#Like ehhhh... ...some, something like te-teteletransportational paradox? Where, you'dja djon't know if it's you? Mmmmmm?"];
					tree[4] = [10, 15, 20, 25];

					tree[10] = ["Yes. That's\nit, that's\nthe one"];
					tree[11] = [30];

					tree[15] = ["Uhh, you're\non the\nright track."];
					tree[16] = [30];

					tree[20] = ["Nnnno?\n...I'm going\nto say no."];
					tree[21] = ["#abra03#No, nnnwait! I can... splain. Ssssomething, it's like... Eeee-heheheh."];
					tree[22] = [31];

					tree[25] = ["Ummm..."];
					tree[26] = [30];

					tree[30] = ["#abra03#Tkkkhhh!! I KNEW IT. I knew it was some, something like... Eeee-heheheh."];
					tree[31] = ["#abra06#Shyou're, we're... we're all just, it's nothing! It's all'ssstjss meat, and... meat and brains though."];
					tree[32] = ["#abra02#Meat, meat and brains, meat and brains. Goonnnaa... get get meat and brains. Hmm-hmhmhm~"];
					tree[33] = ["#abra00#Gonna... gonna WORK this time! Snow it's gonna workk."];
					tree[34] = ["#abra07#Ssue, sue drunk for it'sssnot work~"];
				}
				else
				{
					tree[0] = ["%fun-drunk4%"];
					tree[1] = ["%fun-hold-absinthe%"];
					tree[2] = ["#abra03#No no no no no I'm here I was botching you you you did a good job~"];
					tree[3] = ["#abra07#Youuu'rre doing a good job this time <name> and I think... twelfth umm... twelfth time's sharm, like isss always what they always say... Eh-heheheheh!"];
					tree[4] = ["#abra06#I know I said this evev... elevenry time but you're... you're really persistent <name> but issslike I... hahh... I ehh..."];
					tree[5] = ["#abra10#Like it feels it's smore I can understand about you... Like it's less I can understand myself??"];
					tree[6] = ["#abra07#'snot like a BAD thing 'cause part maybe part it's that I'm understood myself like... WAY better than I understood anyone else."];
					tree[7] = ["#abra09#Almost like it's entire universe is just... opaque mess and my brain is, sssonly sanctuary that's from this ehhh... confu... conflex world I can control?"];
					tree[8] = ["#abra06#... ..."];
					tree[9] = ["#abra08#...Sorry I lost strain of thought. Did you... Do knee me? ... ...'Cause I, ooooughhhh... ..."];
				}
			}
		}
		else
		{
			// swap
			if (PlayerData.level == 0)
			{
				if (trialCount == 0)
				{
					tree[0] = ["%fun-drunk0%"];
					tree[1] = ["#abra02#So this is it! Three puzzles specially designed to get our brains in sync."];
					tree[2] = ["#abra04#...This should maximize your levels of neurokinetic activity and increase the chance of successful synchronization."];
					tree[3] = ["#abra05#But just in case that doesn't work, I have a backup plan..."];
					tree[4] = ["%fun-present-ipa%"];
					tree[5] = ["#abra03#Alcohol!!! Lots and lots of alcohol!"];
					tree[6] = ["#abra02#This is some IPA which Gengar introduced me to back in the day."];
					tree[7] = ["%fun-hold-ipa%"];
					tree[8] = ["#abra05#...It should be just strong enough to dampen my neurokinetics, while still leaving me lucid enough to react if something weird happens. That's my hope, anyways."];
					tree[9] = ["#abra00#Okay, puzzle #1. I believe in you, <name>~"];

					tree[10000] = ["%fun-hold-ipa%"];
				}
				else if (trialCount == 1)
				{
					tree[0] = ["%fun-drunk0%"];
					tree[1] = ["#abra04#So I think if we're going to successfully synchronize, <name>... You either need to get twice as smart, or I need to get twice as drunk."];
					tree[2] = ["#abra05#...And mathematically speaking, what gets me twice as drunk as beer?"];
					tree[3] = ["%fun-present-sake%"];
					tree[4] = ["#abra03#Sake, that's what!! ...If I drink enough of it, anyways~"];
					tree[5] = ["#abra02#I usually try to ration this stuff out, but today's a special occasion..."];
					tree[6] = ["%fun-hold-sake%"];
					tree[7] = ["#abra06#...Because, today's my last day as a Pokemon, isn't it, <name>?"];
					tree[8] = ["#abra00#I know you won't let me down this time~"];

					tree[10000] = ["%fun-hold-sake%"];
				}
				else if (trialCount == 2)
				{
					tree[0] = ["%fun-drunk0%"];
					tree[1] = ["#abra08#Oogh... Well so much for plan B. ...I really thought the sake would work, too. Hmph."];
					tree[2] = ["#abra05#Fortunately, I've got a plan C..."];
					tree[3] = ["%fun-present-soju%"];
					tree[4] = ["#abra03#Downing this entire bottle of Soju!"];
					tree[5] = ["#abra04#I usually avoid drinking this much Soju since it makes me really hung over."];
					tree[6] = ["%fun-hold-soju%"];
					tree[7] = ["#abra02#...But as long as the swap's successful, I don't need to worry about that! Ee-heheh~"];
					tree[8] = ["#abra00#Good luck, <name>~"];

					tree[10000] = ["%fun-hold-soju%"];
				}
				else if (trialCount == 3)
				{
					tree[0] = ["%fun-drunk2%"];
					tree[1] = ["%fun-hold-rum%"];
					tree[2] = ["#abra03#Oh, heyyyy it's <name>!!"];
					tree[3] = ["#abra00#I maaaaaaayyyy have started drinking without you today. ...Ehheheheh~"];
					tree[4] = ["#abra06#... ...It's 'cause of how, eh... how different our brains are, I thought I could use a head start?"];
					tree[5] = ["#abra05#..."];
					tree[6] = ["%fun-present-rum%"];
					tree[7] = ["#abra04#And on top of that, this is just rum today. Just STRAIGHT rum! ...The only other times I've drank this sssstuff, is... well..."];
					tree[8] = ["#abra08#... ...Ehhh l-look, this is not going to end well. One of us is going to be throwing up a lot tomorrow. Nngh."];
					tree[9] = ["%fun-hold-rum%"];
					tree[10] = ["#abra02#But with any luck, that'll be you! Eh-heheheh~"];

					tree[10000] = ["%fun-hold-rum%"];
				}
				else
				{
					tree[0] = ["%fun-drunk3%"];
					tree[1] = ["%fun-hold-absinthe%"];
					tree[2] = ["#abra07#Ohh hi " + stretch(PlayerData.name) + "! ...I've been drinking Absinthe today. Aaaabsiiiinthe... ..."];
					tree[3] = ["%fun-present-absinthe%"];
					tree[4] = ["#abra06#See? The ehhh... the skull means iss good for you! They say you're supposed to cut it with water but..."];
					tree[5] = ["%fun-hold-absinthe%"];
					tree[6] = ["#abra08#... ..."];
					tree[7] = ["#abra10#<name> I REALLY don't wanna be a Pokemon anymore! Pleeease, just... pleeease..."];
					tree[8] = ["#abra11#I've drank SO much alcohol... and thrown up SO much alcohol... And it's just... It's just..."];
					tree[9] = ["#abra08#... ...I just finally want this to work finally... It'll work won't it? ... ..."];

					tree[10000] = ["%fun-hold-absinthe%"];
				}
			}
			else if (PlayerData.level == 1)
			{
				tree[0] = ["%fun-drunk1%"];
				tree[1] = ["%fun-hold-ipa%"];
				tree[2] = ["#abra06#Hmmm I can't tell if I'm getting drunk or not. ...Maybe just a little bit? ... ..."];
				tree[3] = ["#abra02#I know, sobriety test time! ...Give me an eight-digit number and I'll try to find the prime factors."];
				tree[4] = [10, 30, 20, 40];

				tree[10] = ["Uhh...\n98,877,676?"];
				tree[11] = ["#abra06#Well it's obviously divisible by 2... and 2,419,419, which is prime. Hmph."];
				tree[12] = ["#abra12#Come on, <name>, even YOU could have done that one."];
				tree[13] = [50];

				tree[20] = ["Uhh...\n11,725,223?"];
				tree[21] = ["#abra06#Ooh, that's a good one... 17, 19, 31... and... 1,171?"];
				tree[22] = ["#abra00#Hmm, that took me a little while! ...Maybe I am getting a little drunk~"];
				tree[23] = [50];

				tree[30] = ["Uhh...\n84,096,587?"];
				tree[31] = ["#abra08#Hmmmm! That's... 71? No, not 71... 4,297, and... 19,571!"];
				tree[32] = ["#abra00#Hey that was... that was almost difficult! ...Maybe I am getting a little drunk~"];
				tree[33] = [50];

				tree[40] = ["Wait, like,\na number\nwith eight\nthings in it?"];
				tree[41] = ["#abra08#... ..."];
				tree[42] = ["#abra12#<name>, I'll be INCREDIBLY ashamed if our brains somehow synchronize today."];
				tree[43] = ["#abra09#(grumble, eight things in it...)"];
				tree[44] = [50];

				tree[50] = ["#abra04#Well whatever, onto puzzle #2. ...Let's see if I can finish this bottle before you finish this puzzle~"];
				if (trialCount == 0)
				{

				}
				else if (trialCount == 1)
				{
					tree[1] = ["%fun-hold-sake%"];
					tree[10] = ["How about\n65,505,500"];
					tree[11] = ["#abra06#Well it's obviously divisible by 2 and 5... and 131,011, which is prime. Hmph."];

					tree[20] = ["How about\n56,955,134"];
					tree[21] = ["#abra06#Ooh, that's a good one... 2, 17, 43... Ehhh.... 163 and... 239?"];

					tree[30] = ["How about\n36,210,151"];
					tree[31] = ["#abra08#Hmmmm! That's... 61? No, not 61... 3,037, and... 11,923!"];

					tree[40] = ["...Wait, do\nthey make\nnumbers that\nbig?"];

					tree[50] = ["#abra04#Hmmm, I need to pick up my pace! I've barely put a dent in this bottle. Why don't you pick up your pace too~"];
				}
				else if (trialCount == 2)
				{
					tree[0] = ["%fun-drunk2%"];
					tree[1] = ["%fun-hold-soju%"];
					tree[2] = ["#abra00#Ooogh, yeah, okay. That's... That's some nice Soju. Mmmmmmmmmm~"];
					tree[3] = ["#abra03#...Hey <name>, did it get warm in here? Feels like... No, wait! Numbers! We gotta do the number thing~"];

					tree[10] = ["18,960,450"];
					tree[11] = ["#abra06#Oh! That's divisible by... FIVE! And TWO! ...And also TEN."];
					tree[12] = ["#abra00#...Wait, wait, it's also visible by 1,896,045. Okay, okay! I'm still pretty smart~"];

					tree[20] = ["40,963,824"];
					tree[21] = ["#abra06#Oh! That's divisible by... TWO! And also by a variable \"x\"..."];
					tree[22] = ["#abra00#I c... I can't tell you the value of x, because it's a secret! X would be SO mad if I told you~"];

					tree[30] = ["84,350,525"];
					tree[31] = ["#abra06#Oh! That's divisible by... FIVE! And... TWENTY-FIVE. ...And hmmm... what else... ..."];
					tree[32] = ["#abra00#Also if you add up all the numbers, it's pretty... it's pretty big that way."];

					tree[40] = ["80,431,657"];
					tree[41] = ["#abra06#Oh! That's divisible by... FIVE! I meeean, it's almost divisible by five. There's a little left over. Not too much."];
					tree[42] = ["#abra00#Also if you add up all the numbers, it's pretty... it's pretty big that way."];
					tree[43] = [50];

					tree[50] = ["#abra02#Hmph, youuu don't even know if I'm telling the truth about all this math stuff! I don't know why I thought this would work. Eh-hehehehe~"];
					tree[51] = ["#abra06#You need to solve more puzzles to get smart like me! He-here's a good one~"];
				}
				else if (trialCount == 3)
				{
					tree[0] = ["%fun-drunk3%"];
					tree[1] = ["%fun-hold-rum%"];
					tree[2] = ["#abra02#Nngggghhh " + stretch(PlayerData.name) + " let's... lessss do the number thing!!!"];
					tree[3] = ["#abra03#...You remember... djemember the number thing?? Second puzzle, time for the... the number thing. Mhmm~"];

					tree[10] = ["...37,243,013?"];
					tree[11] = [50];

					tree[20] = ["...24,708,889?"];
					tree[21] = [50];

					tree[30] = ["...30,464,414?"];
					tree[31] = [50];

					tree[40] = ["...10,000,000?"];
					tree[41] = [50];

					tree[50] = ["#abra06#Hey!! Hey <name>. Djever notice how come all us Pokemon we got like... the same kinds of of fingers and toes? I just noticed that."];
					tree[51] = ["#abra05#Like my feet got two little foot fingers and a foot thumb!! It's just... just like my hands got and Buizel!"];
					tree[52] = ["#abra06#Buizel's got... three little nub toes? And three nub fingers, and... Rhydon and Sandslash."];
					tree[53] = ["#abra01#I think their... their claws? Rhydon's got... three and three... Sandslash has got... two and two? Isn't that... ... Sj-just weird right!?!"];
					tree[54] = ["#abra00#If everyone's toes matched their hands like... what if maybe we goggit all backwards? ...Right? Eh-heheheheheh~"];
					tree[55] = ["#abra01#... ..."];
					tree[56] = ["#abra06#I just think it's... HEY! Hey wait! What were you asking me something."];
					tree[57] = ["#abra03#I'm fine. Issssnot even fine! It's just... Heheheh~"];
				}
				else
				{
					tree[0] = ["%fun-drunk4%"];
					tree[1] = ["%fun-hold-absinthe%"];
					tree[2] = ["#abra06#...Heyyyyy. Did I ever tell you about this one... ...time college, and Grovyle'ssss draggus all to this sparty but they had a, ehh..."];
					tree[3] = ["%fun-alpha0%"];
					tree[4] = ["#abra07#This old... ... (mumble, mumble...) ...and everyone's sownstairs... ... (mumble...)"];
					tree[5] = ["#zzzz06#... ...crowded but... (mumble) ...Time Pilot machine and, splaying... ... ..."];
					tree[6] = ["#self04#(Uhhhh... I think he's still talking... but I can't hear anything...)"];
					tree[7] = ["#self05#(... ...)"];
					tree[8] = ["#self04#(I... guess I'll just start the puzzle without him.)"];
					tree[9] = ["%fun-longbreak%"];
					tree[10] = null;

					tree[10000] = ["%fun-longbreak%"];

					if (!PlayerData.abraMale)
					{
						DialogTree.replace(tree, 6, "he's still", "she's still");
						DialogTree.replace(tree, 8, "without him", "without her");
					}
				}
			}
			else if (PlayerData.level == 2)
			{
				if (trialCount == 0)
				{
					tree[0] = ["%fun-drunk1%"];
					tree[1] = ["%fun-hold-ipa%"];
					tree[2] = ["#abra08#Mmmm... I don't really feel drunk at all. ...I just feel sort of tired. Hmm."];
					tree[3] = ["#abra04#I think if we're going to synchronize <name>, IPA's not going to cut it."];
					tree[4] = ["#abra05#But I'm already three bottles in, and we've gone through all this trouble... So why don't we just try swapping anyways? And whatever happens, happens."];
					tree[5] = ["#abra04#...Worst case, we can try again tomorrow with something stronger."];
					tree[6] = ["#abra00#Thanks, <name>. ...You've always been such a nice little guinea pig~"];
				}
				else if (trialCount == 1)
				{
					tree[0] = ["%fun-drunk2%"];
					tree[1] = ["%fun-hold-sake%"];
					tree[2] = ["#abra00#Mmm, okay... I think it's kicking in now. Mmhmhmmmm..."];
					tree[3] = ["#abra01#Is this? Feels... Feels the same kind of mental impairment you prolgly suffer on a daily basis, <name>."];
					tree[4] = ["#abra04#Just going off how... ehhhhhhh... ..."];
					tree[5] = ["#abra06#...Sorry, I think that bug over there was doing something. Did you see that? That was kind of distracted me~"];
					tree[6] = ["#abra00#What... What was I ex... explaying? Mmmnnghhh. I... I think I've gotten drunk enough."];
					tree[7] = ["#abra03#This one's in your court, <name>~"];
				}
				else if (trialCount == 2)
				{
					tree[0] = ["%fun-drunk3%"];
					tree[1] = ["%fun-hold-soju%"];
					tree[2] = ["#abra01#Mmmmmmmm " + stretch(PlayerData.name) + "~"];
					tree[3] = ["#abra03#It's almost oooover. ...And I won't gotta be an abra anymore. And I'll get to feel what it's like with all my abra ideas? Squished inside your cozy human brain."];
					tree[4] = ["#abra02#I'ma be walking around in my big ugly MAN suit. But I'm gonna be an abra. And nobody's gonna know I'm an abra. Eh-heheheh~"];
					tree[5] = ["#abra06#And, and... and it's a step up for you 'cause... 'Cause you'll get to... to see what it's like being a cute fuzzy genius?"];
					tree[6] = ["#abra02#...And we'll be wearing each other's skin like... like two little skin buddies mhmhmhmhmhm~"];
					tree[7] = [40, 30, 20, 10];

					tree[10] = ["Uhh, I'm\ngetting sort\nof a Silence\nof the Lambs\nvibe here"];
					tree[11] = [41];

					tree[20] = ["Hey, I'm\nnot ugly"];
					tree[21] = [41];

					tree[30] = ["I'm... glad\nI could\nhelp?"];
					tree[31] = [41];

					tree[40] = ["I can't\nwait!"];
					tree[41] = ["#abra08#Shhhh shh shh shh shh. ...You're going to solve this last puzzle and you're gonna... You're so smart."];
					tree[42] = ["#abra05#And you're not gonna need any hints, and you're not gonna need any help, and you're..."];
					tree[43] = ["#abra04#... ..."];
					tree[44] = ["#abra00#...I wanna take a nap! That's the first thing I'ma do when we switch places is, I'ma take a nap in your body."];
					tree[45] = ["#abra03#A big... big gross hairy hair nap. Eeehehehehe~"];

					if (PlayerData.gender == PlayerData.Gender.Girl)
					{
						DialogTree.replace(tree, 4, "ugly MAN", "ugly GIRL");
					}
				}
				else if (trialCount == 3)
				{
					tree[0] = ["%fun-drunk3%"];
					tree[1] = ["%fun-hold-rum%"];
					tree[2] = ["#abra01#" + stretch(PlayerData.name) + "... This... thisses is it!! This HAS to be it. ..."];
					tree[3] = ["#abra00#If there's no WAYYY it haves to be... smarter than you... I'm like... is there..."];
					tree[4] = ["#abra03#Eh-hehhehehheh, wait, wait..."];
					tree[5] = ["#abra06#Hey hey <name> what's your fambly...? What's um, what's your fambly the..."];
					tree[6] = ["#abra08#Do they, do they know you're ummm... wait didn't the... is the questions thing pop up? Why isn't it-"];
					tree[7] = [25, 10, 20, 30, 15];

					tree[15] = ["It keeps me\nfrom getting\ntoo horny"];
					tree[11] = [50];

					tree[10] = ["It feels\nreally good"];
					tree[16] = [50];

					tree[20] = ["Actually,\nI try to avoid\nit if I can..."];
					tree[21] = [50];

					tree[25] = ["It helps\nme fall\nasleep"];
					tree[26] = [50];

					tree[30] = ["Usually I'm\njust bored"];
					tree[31] = [50];

					tree[50] = ["#abra12#Gaggh why didn't it... No! That was the wronnnggg one. Rgggghhhh..."];
					tree[51] = ["#abra06#...Why didn't I need to have giving this thing an easier one? ... ... It's so coooomplicated."];
					tree[52] = ["#abra04#... ..."];
					tree[53] = ["#abra02#Nnngkay! It's the... can you can do it this time, <name>~"];
				}
				else
				{
					tree[0] = ["%fun-drunk4%"];
					tree[1] = ["%fun-hold-absinthe%"];
					tree[2] = ["#abra03#No no no no no I'm here I was botching you you you did a good job~"];
					tree[3] = ["#abra07#Youuu'rre doing a good job this time <name> and I think... twelfth umm... twelfth time's sharm, like isss always what they always say... Eh-heheheheh!"];
					tree[4] = ["#abra06#I know I said this evev... elevenry time but you're... you're really persistent <name> and thass why I... hahh... I ehh..."];
					tree[5] = ["#abra10#Just so nice and your fambly and friends so lucky to have ssss-someone like you and worried when we switch ice... Ice ruin everything,"];
					tree[6] = ["#abra07#'snot WANT to ruin it's just I'm, I'm just it's not good people like, good umm... Not like you are, It's like you ehhh..."];
					tree[7] = ["#abra06#... ..."];
					tree[8] = ["#abra08#...Sorry I lost strain of thought. Did you... Do knee me? ... ...'Cause I, ooooughhhh... ..."];
				}
			}
		}
	}

	public static function epilogue(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.abraStoryInt == 6)
		{
			// no swap
			if (PlayerData.level == 0)
			{
				tree[0] = ["#abra02#Ah! Hi <name>!!! ...Wow, it feels like it's been so long since I saw you last~"];
				tree[1] = ["#abra04#Things have gotten a LOT better for me since then. ...I wanted to thank you for everything."];
				tree[2] = ["#abra05#Thanks for putting up with me, and well... Thanks especially for standing your ground."];
				tree[3] = ["#abra08#...It was stupid of me to try and swap consciousnesses to rectify what was essentially a psychological issue. ...I don't know why I thought that would work."];
				tree[4] = [20, 15, 10];

				tree[10] = ["You thought\nit would\nreset your\ndepression or\nsomething?"];
				tree[11] = [30];

				tree[15] = ["You thought\nyour psychological\nissues wouldn't\nfollow you to\nyour new body?"];
				tree[16] = [30];

				tree[20] = ["You thought\nmy life would\nbe that different\nfrom yours?"];
				tree[21] = [30];

				tree[30] = ["#abra09#Yeah well, I guess it was probably something like that."];
				tree[31] = ["#abra05#Obviously, it would have been a huge mistake. I'm so glad you didn't let me go through with it."];
				tree[32] = ["#abra08#...First of all, I would have missed my friends. Especially Grovyle and Buizel, I don't know what I would have done without them."];
				tree[33] = ["#abra09#Regardless of future circumstances, they're... they're definitely the closest friends I'll ever have."];
				tree[34] = ["#abra08#...It's infeasible to form friendships of that caliber after college. Everyone's just so busy."];
				tree[35] = ["#abra06#If I'd have thrown all that away just to end up in a new body, and then have the same problems resurface later..."];
				tree[36] = ["#abra09#... ...Well. I don't think I could have dealt with that. So, I really dodged a bullet."];
				tree[37] = ["#abra06#Mmmm, \"dodged a bullet,\" that's not an appropriate idiom is it? I suppose it's more that you took a bullet for me."];
				tree[38] = ["#abra08#So, -sigh- thanks for everything okay? ...Really, I can never repay you enough."];
				tree[39] = [70, 60, 80, 50];

				tree[50] = ["You're\nwelcome"];
				tree[51] = ["#abra02#... ..."];
				tree[52] = ["#abra04#If I ever get like that again, I hope you'll feel comfortable enough to tell me and we can work through it~"];
				tree[53] = ["#abra05#But don't worry. My days of stubbornly barking out petulant demands are behind me."];
				tree[54] = [100];

				tree[60] = ["I knew you'd\ncome around"];
				tree[61] = [51];

				tree[70] = ["$250,000\nshould\ncover it"];
				tree[71] = ["#abra03#Ee-heheheh! Hey! ...If I gave you $250,000, you wouldn't motivated to play my game anymore."];
				tree[72] = ["#abra05#Don't underestimate the addictive qualities of a well-crafted operant conditioning chamber~"];
				tree[73] = [100];

				tree[80] = ["You were\na total ass,\nyou know"];
				tree[81] = ["#abra09#I know. I know. I'm... I'm still kind of an ass. I'm sorry."];
				tree[82] = ["#abra05#Surely my self-awareness about being an ass earns me a few brownie points? ...Like, maybe I'm only 99% ass now?"];
				tree[83] = [100];

				tree[100] = ["#abra04#... ..."];
				tree[101] = ["#abra12#Now anyways, hurry up and solve this puzzle! ...The rationale behind this positive sentiment was to decrease your puzzle-solving stupidness."];
				tree[102] = ["#abra08#Your puzzle stupidness levels are at a 10 right now! ...I need you at an 8."];
				tree[103] = ["#abra02#...Ee-heheheh. I'm sorry! I'm sorry. Was I ever that bad?"];
				tree[104] = ["#abra05#Ohhhhh I probably still am. Sorry. ...Thanks for putting up with me~"];
			}
			else if (PlayerData.level == 1)
			{
				tree[0] = ["#abra04#It's hard to put into words what changed that other night when we got our brains in sync."];
				tree[1] = ["#abra08#Thinking about the emotional isolation I was putting myself through prior to that, and my perceptions of others..."];
				tree[2] = ["#abra09#...It's almost like I was a completely different Pokemon back then. It's embarrassing to think about."];
				tree[3] = ["#abra08#... ... ..."];
				tree[4] = ["#abra06#I guess I've always had hobbies and personal talents which lend themselves towards spending long periods of time alone."];
				tree[5] = ["#abra05#Like, even getting this webcam to work with this flash game? Encoding it properly and minimizing the stream delay, that was an ordeal."];
				tree[6] = ["#abra04#...That alone took about five weeks. Just hours in my room each day, tinkering with codecs and packet analyzers."];
				tree[7] = ["#abra06#Or getting that robotic hand to work, and to interface with the mouse in an intuitive way? ...Honestly that was several months."];
				tree[8] = ["#abra10#I had a prototype up in no time, but it took forever to get it smooth enough to where it felt immersive. ...And it still feels a little clumsy sometimes."];
				tree[9] = ["#abra05#Well, what I'm getting at is that during the development of the Monster Mind project, I spent a lot of time by myself getting things how I wanted them."];
				tree[10] = ["#abra04#In a way I feel redeemed that you played this game for so long. I expected a typical player would have gotten bored a long time ago."];
				tree[11] = ["#abra06#Out of curiosity, <name>... ...What, what about this game motivated you to continue playing?"];
				tree[12] = [20, 30, 40, 50, 60];

				tree[20] = ["I'm still\nhoping to\nsee more\nnecks"];
				tree[21] = ["#abra03#Necks!? Bahahahahaha~"];
				tree[22] = ["#abra00#I'd show you mine, but well, abras are cursed with abnormally short necks. ...It's a bit embarrassing."];
				tree[23] = ["#abra02#Mmmm, but Grovyle's got a pretty good neck, maybe you can ask to see his neck~"];
				tree[24] = [100];

				tree[30] = ["I can't\nfigure out\nhow to\nclose the\ngame"];
				tree[31] = ["#abra03#How to close the game!? Bahahahaha~"];
				tree[32] = ["#abra02#I made that particular puzzle difficult on purpose. ...After all, I'd be pretty lonely over here if you quit on me, mmmm?"];
				tree[33] = [100];

				tree[40] = ["I like\nfooling\naround with\nPokemon"];
				tree[41] = ["#abra03#You sure do! Ee-heheheheh~"];
				tree[42] = ["#abra00#Did you like how I got you a Lucario too? I thought you'd like that~"];
				tree[43] = ["#abra02#Have you seen Little Shop Of Horrors? It's like you're like the... Audrey II to my Seymour Krelborn."];
				tree[44] = ["#abra04#Although when I put it that way, I'm almost a little ashamed I've run out of creatures to feed you."];
				tree[45] = [100];

				tree[50] = ["I still\nwant to\nprove you\nwrong when\nyou said\nI'd quit"];
				tree[51] = ["#abra03#What!? Bahahahah~"];
				tree[52] = ["#abra04#Well, I still think you're going to quit any moment now. ...You finished the game! There's really nothing left."];
				tree[53] = ["#abra02#Soon all of our conversations will become stale, you'll get bored of the sex sequences, and you'll forget all about us. Prove me wrong!"];
				tree[54] = [100];

				tree[60] = ["I\nreally,\nreally\nlike\npuzzles"];
				tree[61] = ["#abra03#What!? Bahahahaha. Nobody likes puzzles THIS much!"];
				tree[62] = ["#abra02#...They're just little machine-generated garbage puzzles. They're not even real ones."];
				tree[63] = ["#abra05#I guess they have their charm, and the broad variety of solving techniques prevents them from becoming too repetitive. But still..."];
				tree[64] = ["#abra04#... ..."];
				tree[65] = [100];

				tree[100] = ["#abra05#Well, whatever. ...Have another puzzle you little weirdo~"];

				if (!PlayerData.grovMale)
				{
					DialogTree.replace(tree, 23, "his neck", "her neck");
				}
			}
			else if (PlayerData.level == 2)
			{
				tree[0] = ["%fun-nude1%"];
				tree[1] = ["#abra05#Anyways so when I was developing the Monster Mind project, I spent most of my time in solitude writing code, running experiments, designing minigames."];
				tree[2] = ["#abra04#And it's easy to stay content when you spend so long like that a project by yourself-- just trapped in your own head."];
				tree[3] = ["#abra05#Everything's yours, everything makes sense, there's nobody to argue with."];
				tree[4] = ["#abra06#...Aside from fleeting feelings of frustration when something doesn't work, it's sort of a mental utopia. Or so you'd think."];
				tree[5] = ["#abra08#But long periods of isolation like that have a way of wearing on a person."];
				tree[6] = ["#abra09#... ... ..."];
				tree[7] = ["#abra05#I suppose it comes as no surprise I'm a massive introvert."];
				tree[8] = ["#abra04#So I never think of myself as needing social contact. ...But over time, its absence wears on my emotional state in subtle ways."];
				tree[9] = ["#abra05#And besides the general moodiness stemming from the absence of social contact, the other toxic thing about living in your own little bubble is, hmmm..."];
				tree[10] = ["#abra04#...Well, the way it distorts everything and everyone who's outside of that bubble."];
				tree[11] = ["#abra08#All of the things you used to do for fun... Having friends over, going out for a nice meal, celebrating someone's birthday?"];
				tree[12] = ["#abra09#When you're content in your own little bubble world, those types of fun activities get perceived as interruptions."];
				tree[13] = ["#abra12#It's like, \"Oh, Grovyle wants to do an escape room this Saturday? ...But I wanted to nail down the KP values on my PID controller. Hmph.\""];
				tree[14] = ["#abra08#... ..."];
				tree[15] = ["#abra05#Anyways, that's all in the past. I'm trying to be more social, and I've been setting aside at least an hour each day just to..."];
				tree[16] = ["#abra03#Well, just to do nothing at all, you know? ...Maybe hang out and chat with people, participate in noncompetitive social activities. ...It's, it's a nice change."];
				tree[17] = ["#abra02#I've even started exercising a little! Not that I expect to accomplish much, but... it feels good to be physically active."];
				tree[18] = ["#abra04#Anyways, thanks for listening. ...I just wanted to get all that off my chest."];
				tree[19] = [50, 40, 25, 30];

				tree[25] = ["Mmm."];
				tree[26] = [100];

				tree[30] = ["Oh, no\nproblem"];
				tree[31] = [100];

				tree[40] = ["I'm glad\nyou're okay"];
				tree[41] = ["#abra00#Mmm, thanks. ...I know it's been a rough couple of days but things really worked out for the best~"];
				tree[42] = [100];

				tree[50] = ["...Abra?"];
				tree[51] = ["#abra06#...Mmm?"];
				tree[52] = [60, 80, 70, 90];

				tree[60] = ["Thanks\nfor opening\nyour bubble"];
				tree[61] = ["#abra00#... ..."];
				tree[62] = ["#abra01#Well... ...Thanks for letting me in yours~"];
				tree[63] = [100];

				tree[70] = ["Thanks\nfor not\ngiving up\non me"];
				tree[71] = ["#abra00#... ..."];
				tree[72] = ["#abra01#Well... ...Thanks for not giving up on me either~"];
				tree[73] = [100];

				tree[80] = ["Take off\nyour damn\nclothes"];
				tree[81] = ["#abra00#Ee-heheheh! Oops~"];
				tree[82] = ["%fun-nude2%"];
				tree[83] = [100];

				tree[90] = ["Umm,\nnothing"];
				tree[91] = [100];

				tree[100] = ["#abra05#... ...Alright, well, one more puzzle."];
			}
		}
		else
		{
			// swap
			if (PlayerData.level == 0)
			{
				tree[0] = ["#abra02#Hi Abra! I mean... ummm... hi <name>! ...Sorry!"];
				tree[1] = ["#abra05#I just realized now that this swap was somewhat asymmetrical, as I'd already met most of your friends, but you hadn't met any of mine."];
				tree[2] = ["#abra06#...My human friends aren't getting on your nerves too much, are they?"];
				tree[3] = [30, 40, 20, 10];

				tree[10] = ["All your\nfriends are\nmorons"];
				tree[11] = ["#abra03#What? Ohh, come on. They're not that bad... You just need to get used to them."];
				tree[12] = ["#abra06#Besides, what they lack in intelligence they make up for in their, hmm... ..."];
				tree[13] = ["#abra08#Their various... positive traits... ... I'm sort of drawing a blank. It feels like so long ago..."];
				tree[14] = ["#abra04#... ...Well whatever, you can always just make new friends~"];
				tree[15] = [50];

				tree[20] = ["Oh, they're\nfine"];
				tree[21] = ["#abra02#Yeah! I'm sure you'll get along great once you get to know them."];
				tree[22] = ["#abra04#I mean, none of them are quite as into this... perverted Pokemon stuff in the same way I am, but they're still nice people~"];
				tree[23] = [50];

				tree[30] = ["They're a\nlot of\nfun"];
				tree[31] = ["#abra02#Eh-heheheh! They are, aren't they?"];
				tree[32] = ["#abra04#Man I kind of miss them. I'm already sort of starting to forget what they look like."];
				tree[33] = ["#abra05#...Now that you're on the other side of the computer here, maybe you can hook up a reverse webcam feed so I can see them from time to time."];
				tree[34] = ["#abra06#Speaking of which, now that I'm a Pokemon... I guess it's your turn to solve puzzles? Isn't that how it works?"];
				tree[35] = [51];

				tree[40] = ["We're doing\nsomething\nthis weekend"];
				tree[41] = ["#abra02#Oh wow, already! ...You didn't waste any time, did you? Ehh-heheheh. Well, have fun."];
				tree[42] = ["#abra04#... ...And now that you're on the other side of the computer here, maybe you can hook up a reverse webcam feed so I can see them from time to time."];
				tree[43] = ["#abra06#Speaking of which, now that I'm a Pokemon... I guess it's your turn to solve puzzles? Isn't that how it works?"];
				tree[44] = [51];

				tree[50] = ["#abra06#Anyway ehh, now that you're on the other side of the computer here... I guess it's your turn to solve puzzles? Isn't that how it works?"];
				tree[51] = ["#abra10#Don't give me that look! ...You made me do hundreds of these things."];
				tree[52] = ["#abra05#Besides that, you probably memorized all the answers didn't you. Eh-hehehehe. Well, just try not to cheat, hmmmm?"];
			}
			else if (PlayerData.level == 1)
			{
				tree[0] = ["#abra04#Hmph, I expected you to be faster at these."];
				tree[1] = ["#abra05#...I mean you were always taunting me for my slow performance!"];
				tree[2] = ["#abra03#What happened to all those secret techniques you were taunting me with? ...I thought you could solve these puzzles in like half a second."];
				tree[3] = [40, 10, 20, 50, 30];

				tree[10] = ["That was\nwith MY\nbrain, not\nwith your\nidiot brain"];
				tree[11] = ["#abra02#Eh-heheheh. Not so easy, right?"];
				tree[12] = ["#abra04#Well, maybe now you'll empathize more easily with us lower life forms."];
				tree[13] = [80];

				tree[20] = ["Eeggh..."];
				tree[21] = ["#abra02#Eh-heheheh. Ohhh, I'm sorry. I'm just giving you a hard time."];
				tree[22] = ["#abra04#After all the times you taunted me about my speed or my intelligence, I should at least be allowed to have a little fun, hmmmm?"];
				tree[23] = [80];

				tree[30] = ["I'm sorry,\nI didn't\nknow how\nhard these\nwere"];
				tree[31] = ["#abra06#Right!? ...There's a lot to think about when you can't just churn through all the combinations in succession."];
				tree[32] = ["#abra04#...I found it sort of helps to think about the colors first, and then think about their placement afterwards. Otherwise it's just too much at once."];
				tree[33] = [80];

				tree[40] = ["Hey, that\none was a\nwarmup! ...I\ncan go\nfaster"];
				tree[41] = [21];

				tree[50] = ["Eeh-heheheh!\nOh, you\nbelieved me\nabout that?"];
				tree[51] = ["#abra06#Wait, really? You were joking?"];
				tree[52] = ["#abra05#...Well, the puzzles seem REALLY easy to me now that I have your brain. I could probably solve a hundred of these in under a minute."];
				tree[53] = ["#abra04#But I guess I've sort of got the best of both worlds, with all the puzzle shortcuts I learned as a human running on your supercharged abra brain."];
				tree[54] = [80];

				tree[80] = ["#abra05#...Anyways, take your time, have fun with the puzzles."];
				tree[81] = ["#abra02#It's not like the ranking system matters anymore, that part's over. It's just for fun now~"];
			}
			else if (PlayerData.level == 2)
			{
				if (PlayerData.abraMale)
				{
					tree[0] = ["#abra00#...So is it weird seeing yourself on video like this?"];
					tree[1] = ["#abra06#Wait, are you still looking at me with that fake digital penis? ...I thought you would have turned that off."];
					tree[2] = [10, 20, 30, 40];

					tree[10] = ["Wow,\nit looks\npretty good"];
					tree[11] = ["#abra03#I know, right? You can't even tell."];
					tree[12] = ["#abra02#...Although I guess a part of it's because of these crappy webcam graphics."];
					tree[13] = ["#abra04#Alright, one more puzzle."];

					tree[20] = ["I forgot\nit was\nturned on"];
					tree[21] = ["#abra05#Oh! ...Hmm, that's not like you to forget something like that."];
					tree[22] = ["#abra03#Although it IS like me to forget. ...Eh-heheheh. I guess you're stuck with my crappy memory now."];
					tree[23] = ["#abra02#Anyway, hmm, chin up. Just one more puzzle~"];

					tree[30] = ["I just like\npenises\nmore"];
					tree[31] = ["#abra01#Yeah! Plus you gave yourself a pretty nice looking one. A little on the cute side, but mmm. That was a nice looking penis~"];
					tree[32] = ["#abra02#I'm going to kind of miss looking at that penis. Eh-heheheh."];
					tree[33] = ["#abra05#... ..."];
					tree[34] = ["#abra04#Oh well. Anyways, let's go-- just one more puzzle."];

					tree[40] = ["Either way's\nfine"];
					tree[41] = ["#abra05#Yeah, I guess you probably don't really care at this point! You've seen it all, haven't you~"];
					tree[42] = ["#abra02#Well, hopefully you'll still enjoy playing with yourself. Eh-heheheh~"];
					tree[43] = ["#abra04#... ...Alright, well, one more puzzle."];
				}
				else
				{
					tree[0] = ["#abra00#...So is it weird seeing yourself on video like this?"];
					tree[1] = ["#abra06#Oh, you didn't turn on that fake digital penis? ...You weren't a little curious what it looks like?"];
					tree[2] = [10, 20, 30, 40];

					tree[10] = ["Meh,\nI've seen it.\nIt looks\npretty bad"];
					tree[11] = ["#abra05#Really? ...I couldn't even tell it was fake."];
					tree[12] = ["#abra04#Although I guess a part of it was because of those crappy webcam graphics."];
					tree[13] = ["#abra02#... ...Alright, one more puzzle."];

					tree[20] = ["I forgot\nit was\nturned off"];
					tree[21] = ["#abra05#Oh! ...Hmm, that's not like you to forget something like that."];
					tree[22] = ["#abra03#Although it IS like me to forget. ...Eh-heheheh. I guess you're stuck with my crappy memory now."];
					tree[23] = ["#abra02#Anyway, hmm, chin up. Just one more puzzle~"];

					tree[30] = ["I just like\nvaginas\nmore"];
					tree[31] = ["#abra01#Yeah! Plus you've got a pretty nice looking one. A little on the cute side, but mmm. That's a nice looking vagina~"];
					tree[32] = ["#abra02#... ...Anyways, let's go-- just one more puzzle."];

					tree[40] = ["Oh, I've\nseen\nit before"];
					tree[41] = ["#abra05#Yeah, I guess you probably don't really care at this point! You've seen it all, haven't you~"];
					tree[42] = ["#abra02#Well, hopefully you'll still enjoy playing with yourself. Eh-heheheh~"];
					tree[43] = ["#abra04#... ...Alright, well, one more puzzle."];
				}
			}
		}
	}

	public static function random00(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#abra05#Alright <name>, no chit-chat this time. Let's just get started!"];
	}

	public static function random01(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#abra05#Oh it's you again! Why hello, hello~"];
		tree[1] = ["#abra04#Let's see what you've learned!"];
	}

	public static function random02(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#abra04#Back for more puzzles eh! Let me just double check."];
		tree[1] = ["#abra02#...Yes, yes, this looks like a good set! Give it your best."];
	}

	public static function random03(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#abra02#Don't mind me, <name>! I'll just be studying your neural activity while you solve this next puzzle."];
	}

	public static function random04(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (puzzleState._lockedPuzzle != null && puzzleState._lockedPuzzle != puzzleState._puzzle)
		{
			tree[0] = ["#abra06#Ah, well here we are again, <name>. Another day, another "
					   + moneyString(puzzleState._puzzle._reward)
					   + ". Or hmm, perhaps "
					   + moneyString(puzzleState._lockedPuzzle._reward)
					   + "? ...Which one will you choose?"];
			tree[1] = ["#abra02#I'm just joking. Of course I already know~"];
		}
		else
		{
			tree[0] = ["#abra05#Ah, well here we are again, <name>. Another day, another " + moneyString(puzzleState._puzzle._reward) + "."];
			tree[1] = ["#abra04#Perhaps I'll give you something more challenging once you're warmed up~"];
		}
	}

	public static function random7Peg0(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.puzzleCount[4] == 0)
		{
			tree[0] = ["%enterabra%"];
			tree[1] = ["#abra03#Ahh! ...Really??"];
			tree[2] = ["#abra02#...You're... You're actually going to try a 7-peg puzzle with me? I know you can do it!"];
			tree[3] = ["%fun-nude1%"];
			tree[4] = ["#abra00#I'll tell you what. As a little incentive, I'll take off one article of clothing now..."];
			tree[5] = ["#abra01#And... If you can complete the puzzle, I'll take off another article of clothing afterward."];
			tree[6] = ["%exitabra%"];
			tree[7] = ["#abra04#Eee-heeheh! I'm just bristling with excitement. Let's push that clunky cerebrum of yours into high gear~"];
			tree[10000] = ["%exitabra%"];
		}
		else
		{
			tree[0] = ["%enterabra%"];
			tree[1] = ["#abra03#Ahh! ...Really??"];
			tree[2] = ["#abra02#...You're... You're going to try another 7-peg puzzle with me? I know you can do it!"];
			tree[3] = ["%fun-nude1%"];
			tree[4] = ["#abra00#Just like last time, I'll take off one article of clothing now..."];
			tree[5] = ["#abra01#And... If you can complete the puzzle, I'll take off another article of clothing afterward."];
			tree[6] = ["%exitabra%"];
			tree[7] = ["#abra04#Eee-heeheh! I'm just bristling with excitement. Let's push that clunky cerebrum of yours into high gear~"];
			tree[10000] = ["%exitabra%"];
		}
	}

	public static function random7Peg1(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.puzzleCount[4] == 0)
		{
			random7Peg0(tree, puzzleState);
			return;
		}
		tree[0] = ["%enterabra%"];
		tree[1] = ["#abra03#You're trying another seven-peg puzzle? Really? ...Oh wow!"];
		tree[2] = ["#abra04#You have NO idea how much I enjoy watching you think through these simple puzzles... It's like watching a rat slowly navigate through a maze."];
		tree[3] = ["#abra02#The exit's like... right in front of you! Yet, you still bump into every dead-end along the way. It's a little cute~"];
		tree[4] = ["%fun-nude2%"];
		tree[5] = ["#abra00#Oh! I should really have my pants off for this. Ee-heheheheh..."];
		tree[6] = ["%exitabra%"];
		tree[7] = ["#abra05#...Hey! No peeking!"];
		tree[8] = ["#abra02#You have to EARN your cheese first, you hungry little lab rat~"];
		tree[10000] = ["%exitabra%"];
	}

	public static function random7Peg2(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.puzzleCount[4] == 0)
		{
			random7Peg0(tree, puzzleState);
			return;
		}
		tree[0] = ["%enterabra%"];
		tree[1] = ["#abra06#Back for another 7-peg puzzle? Hmm... I hope I didn't make this one too hard for you."];
		tree[2] = ["%fun-nude1%"];
		tree[3] = ["#abra11#I can't really gauge what's easy and what's hard!"];
		tree[4] = ["#abra05#Grovyle playtests most of the puzzles for me, and I can tell what's difficult because those are the ones that take him longer to solve."];
		tree[5] = ["#abra08#But... He just balks at this 7-peg stuff, so I don't have a way of figuring out which ones are good to give you."];
		tree[6] = ["%exitabra%"];
		tree[7] = ["#abra04#..."];
		tree[8] = ["#abra02#Just, try not to get frustrated, okay? I'm rooting for you~"];
		tree[10000] = ["%exitabra%"];

		if (!PlayerData.grovMale)
		{
			DialogTree.replace(tree, 4, "take him", "take her");
			DialogTree.replace(tree, 5, "He just", "She just");
		}
	}

	public static function random7Peg3(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.puzzleCount[4] == 0)
		{
			random7Peg0(tree, puzzleState);
			return;
		}
		var count:Int = PlayerData.recentChatCount("abra.random7Peg.0.3");
		tree[0] = ["%enterabra%"];
		tree[1] = ["%fun-nude1%"];
		tree[2] = ["#abra06#So I've noticed that every time you-"];
		tree[10000] = ["%exitabra%"];
		if (count % 3 == 0)
		{
			tree[3] = ["%entersand%"];
			tree[4] = ["#sand12#Ehh? What... what the fuck. What sort of weird-ass shit have you gotten yourself into, <name>? I thought FOUR pegs was too many!"];
			tree[5] = ["#abra04#Oh, it's not as bad as it looks! There's a few extra rules which make it easier."];
			tree[6] = ["#sand13#Extra rules... Which make it easier!?! Abra, you're not makin' any goddamn sense."];
			tree[7] = ["#sand09#What you two are doing is... It's wrong. It's fuckin' wrong! This is supposed to be a PORN game. You're twisting it into some kind of... masochistic mental exercise."];
			tree[8] = ["#abra06#It's just... It's just BARELY more difficult than the kinds of puzzles-"];
			tree[9] = ["#sand12#-nope. No man, I dunno WHAT your extra rules are but I don't like it. Uh-uh. Nope."];
			tree[10] = ["%exitsand%"];
			tree[11] = ["#sand06#<name>, come hit me up later if you're down for some wholesome 3-peg stuff. None of this, weird-ass, kinky seven-peg shit."];
			tree[12] = ["#abra05#..."];
			tree[13] = ["#abra04#Well, hmm. What's gotten into him?"];
			tree[14] = ["%exitabra%"];
			tree[15] = ["#abra00#Actually, knowing Sandslash is against this just makes me want to solve puzzles with you even HARDER, <name>. Ee-heheheh~"];
			tree[10001] = ["%exitsand%"];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 9, "No man", "No girl");
			}
			if (!PlayerData.sandMale)
			{
				DialogTree.replace(tree, 13, "into him", "into her");
			}
		}
		else if (count % 3 == 1)
		{
			tree[3] = ["%enterkecl%"];
			tree[4] = ["#kecl10#Holy... Holy hell! What are you, goin' for your postdoc in puzzle-solving, <name>? What the hell is this?"];
			tree[5] = ["#abra05#It's a new puzzle I'm working on. It's got seven pegs, and an extra rule where pegs can't touch other pegs of the same color."];
			tree[6] = ["#kecl05#...Listen, what the two of you do in the privacy of our... communally shared living room, that's between you two. I'm not gonna judge. Just... do me a favor,"];
			tree[7] = ["#kecl07#Whatever you do, do NOT let Smeargle see this sort of stuff, he'll lose sleep!"];
			tree[8] = ["#kecl08#...Poor guy struggles enough with the 3-peg stuff, this thing would give him nightmares."];
			tree[9] = ["#abra06#...?"];
			tree[10] = ["%exitkecl%"];
			tree[11] = ["#kecl04#Seriously though <name>, like... maybe... maybe take a little break after this one. You don't gotta torture yourself."];
			tree[12] = ["#abra06#...\"Nightmare\"? ...\"Torture\"?"];
			tree[13] = ["#abra09#Those are pretty harsh words for what's really just a harmless little puzzle. ...It's not like we're hurting anybody."];
			tree[14] = ["#abra08#..."];
			tree[15] = ["%exitabra%"];
			tree[16] = ["#abra10#You'll let me know if it hurts, won't you?"];
			tree[10001] = ["%exitkecl%"];

			if (!PlayerData.smeaMale)
			{
				DialogTree.replace(tree, 7, "he'll lose", "she'll lose");
				DialogTree.replace(tree, 8, "Poor guy", "Poor girl");
				DialogTree.replace(tree, 8, "give him", "give her");
			}
		}
		else if (count % 3 == 2)
		{
			tree[3] = ["%entergrov%"];
			tree[4] = ["#grov13#Abra, what have you done!?"];
			tree[5] = ["#abra10#Ehh?"];
			tree[6] = ["#grov12#I TOLD you how miserable these seven peg puzzles are for most of us! And now you're putting <name> through them?"];
			tree[7] = ["#abra04#...Hey, he likes them! This isn't even <name>'s first one, he's already solved a few before this one."];
			tree[8] = ["#grov10#What!? ...Is that true, <name>?"];
			tree[9] = [20, 30, 50, 40];

			tree[20] = ["Sure, I\nlike them"];
			tree[21] = ["#grov08#Goodness!"];
			tree[22] = ["%exitgrov%"];
			tree[23] = ["#grov06#...Perhaps I should give them another chance myself."];
			tree[24] = [100];

			tree[30] = ["Sure, I've\nsolved a few"];
			tree[31] = [21];

			tree[40] = ["Well, I'm\njust trying\nthem out"];
			tree[41] = ["#grov06#Well... Don't, err..."];
			tree[42] = ["#grov09#You don't have to do anything you don't enjoy, alright?"];
			tree[43] = ["%exitgrov%"];
			tree[44] = ["#grov08#There's no shame in joining your Grovyle friend for some easier 4-peg and 5-peg puzzles."];
			tree[45] = [100];

			tree[50] = ["Well, they're\npainful"];
			tree[51] = [41];

			tree[100] = ["#abra09#...Hmm..."];
			tree[101] = ["#abra08#You know <name>, if these puzzles are too tough..."];
			tree[102] = ["#abra05#..."];
			tree[103] = ["%exitabra%"];
			tree[104] = ["#abra04#Well, Grovyle's right. You shouldn't do these seven peg puzzles if you don't like them."];
			tree[105] = ["#abra05#Just because they're my favorite doesn't mean they have to be your favorite too. It's okay if you want to do something else."];
			tree[10001] = ["%exitgrov%"];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 7, "Hey, he", "Hey, she");
				DialogTree.replace(tree, 7, "one, he's", "one, she's");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 7, "Hey, he", "Hey, they");
				DialogTree.replace(tree, 7, "one, he's", "one, they've");
			}
		}
	}

	public static function random10(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#abra04#Let's see if you can pick up the pace a little!"];
		tree[1] = ["#abra05#I'm sensing your neural activity at about a four. I need you at like a six."];
	}

	public static function random11(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#abra00#Ahh, that's better."];
		tree[1] = ["#abra05#Pants are overrated, underwear is much more comfortable."];
	}

	static private function appendQuiz(tree:Array<Array<Object>>, answers:Array<Array<Int>>, firstGuessIndex:Int, secondGuessIndex:Int)
	{
		tree[answers[0][1]] = [englishNumber(answers[0][0])];
		for (i in 1...answers.length)
		{
			tree[answers[i][1]] = [englishNumber(answers[i][0])];
			tree[answers[i][1] + 1] = [answers[1][1] + 1];
			tree[answers[i][1] + 5] = [englishNumber(answers[i][0])];
			tree[answers[i][1] + 6] = [answers[1][1] + 6];
		}

		var answers0:Array<Array<Int>> = answers.copy();
		answers0.sort(function(a, b) return a[0] - b[0]);

		tree[firstGuessIndex] = [];
		tree[secondGuessIndex] = [];
		for (i in 0...answers0.length)
		{
			tree[firstGuessIndex].push(answers0[i][1]);
			if (answers0[i][1] == answers[0][1])
			{
				tree[secondGuessIndex].push(answers0[i][1]);
			}
			else
			{
				tree[secondGuessIndex].push(answers0[i][1] + 5);
			}
		}
	}

	public static function random12(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		{
			var puzA:Int = FlxG.random.int(3, 9);
			var puzB:Int = puzA - FlxG.random.int(1, puzA - 1);

			tree[0] = ["#abra06#Hmm, did you get enough sleep last night? Your neural activity seems a little sluggish."];
			tree[1] = ["#abra02#How about I give you a little break! I'll remove my underwear without a puzzle if you answer a math problem for me. Let's see..."];
			if (PlayerData.isAbraNice())
			{
				tree[2] = ["#abra04#Hmm what's something that's not too difficult... Okay how about this,"];
			}
			else
			{
				tree[2] = ["#abra04#Hmm what's something around your skill level... Okay how about this,"];
			}
			tree[3] = ["#abra05#If you have " + englishNumber(puzA) + " chocolates, and you eat " + englishNumber(puzB) + " of them, how many do you have left?"];
			var rightAnswer:Int = puzA - puzB;
			var wrongAnswers:Array<Int> = [ rightAnswer - 4, rightAnswer - 3, rightAnswer - 2, rightAnswer - 1, rightAnswer + 1, rightAnswer + 2, rightAnswer + 3, rightAnswer + 4];
			var fromIndex:Int = FlxG.random.int(0, 4);
			var selectedWrongAnswers:Array<Int> = wrongAnswers.slice(fromIndex, fromIndex + 4);

			appendQuiz(tree, [[rightAnswer, 50], [ selectedWrongAnswers[0], 10], [selectedWrongAnswers[1], 20], [selectedWrongAnswers[2], 30], [selectedWrongAnswers[3], 40]], 4, 13);
			// tree[4] = first guesses...

			tree[11] = ["#abra08#Ohhh, take your time! You can do it."];
			tree[12] = ["#abra05#Maybe it would help to count on your fingers. So hold up " + englishNumber(puzA) + " fingers... and then put " + englishNumber(puzB) + " of your fingers down. How many fingers are left?"];
			// tree[13] = second guesses...
			tree[16] = ["#abra09#Hmmm. Well, you were close. Math is hard! You'll understand it better some day."];

			tree[4].push(60);
			tree[4].push(200);
		}
		tree[51] = ["#abra02#Wow! Did you do that all by yourself or did you ask for help?"];
		tree[52] = ["%skip%"];
		tree[53] = ["%fun-nude2%"];
		tree[54] = ["#abra03#How very clever of you. Good job!!"];
		tree[55] = ["#abra04#Okay, take your time with this last puzzle. I don't want you to burn yourself out or anything."];

		{
			var variations:Array<Array<Object>> = [
					// 15 * 36 * 21
					["sixteen candy bars: four kit-kats, seven hershey bars, and five milky ways", 11340, [7392, 8736, 9282, 10710, 11970, 12600, 13230, 14994]],
					// 15 * 36 * 28
					["seventeen candy bars: four kit-kats, seven hershey bars, and six milky ways", 15120, [8568, 10472, 11088, 13104, 17136, 18088, 19040, 19992]],
					// 21 * 45 * 28
					["nineteen candy bars: five kit-kats, eight hershey bars, and six milky ways", 26460, [18360, 20520, 22230, 23940, 28980, 31050, 33750, 36450]]];
			var prompt:String = variations[0][0];
			var rightAnswer:Int = cast variations[0][1];
			var wrongAnswers:Array<Int> = cast variations[0][2];
			var fromIndex = FlxG.random.int(0, 4);
			var selectedWrongAnswers:Array<Int> = wrongAnswers.slice(fromIndex, fromIndex + 4);

			tree[60] = ["That's\ntoo\neasy"];
			if (PlayerData.isAbraNice())
			{
				tree[61] = ["#abra06#Too easy? I thought most humans would struggle with that one."];
			}
			else
			{
				tree[61] = ["#abra06#Too easy? Too easy even for you? ...Really?"];
			}
			tree[62] = ["#abra04#So, you want something just a little harder... Hmmm.... Hmmm... Okay, I think I've got one."];

			// The explicit 'Std.string()' call is a workaround for Haxe issue #11235; generated .cpp files have conversion errors, "cannot convert from 'String' to 'Float'"
			// https://github.com/HaxeFoundation/haxe/issues/11235
			tree[63] = ["#abra05#Three of us find a box with " + Std.string(variations[0][0]) + ". How many ways can we divide the candy?"];

			appendQuiz(tree, [[rightAnswer, 140], [ selectedWrongAnswers[0], 100], [selectedWrongAnswers[1], 110], [selectedWrongAnswers[2], 120], [selectedWrongAnswers[3], 130]], 64, 104);

			tree[101] = ["#abra08#Ohhh, take your time! You can do it."];
			tree[102] = ["#abra05#Like I might keep all the candy for myself, or you keep all the candy for yourself. That's two ways."];
			tree[103] = ["#abra04#Or you could keep most of it, but give each of us a milky way bar. That's three, count on your fingers if you have to! How many ways are there total?"];
			tree[106] = ["#abra09#Hmmm. Well, you were close. Math is hard! You'll understand it better some day."];

			tree[64].push(150);
			tree[64].push(160);
		}
		tree[141] = ["#abra02#Wow! Did you do that all by yourself or did you ask for help?"];
		tree[142] = ["%skip%"];
		tree[143] = ["%fun-nude2%"];
		tree[144] = ["#abra03#How very clever of you. Good job!!"];
		tree[145] = ["#abra04#Okay, take your time with this last puzzle. I don't want you to burn yourself out or anything."];

		tree[150] = ["That's\ntoo\neasy"];
		tree[151] = ["#abra00#Well hey I'm trying to give you a break here! If I make it too difficult I won't get to remove my undies."];
		tree[152] = ["#abra04#So how many ways can you divide the candy?"];
		tree[153] = [105, 115, 125, 135, 140];

		tree[160] = ["That's\ntoo\nhard"];
		tree[161] = [101];

		tree[200] = ["That's\ntoo\nhard"];
		if (PlayerData.isAbraNice())
		{
			tree[201] = ["#abra08#Hmm yes I was worried that might be too hard for humans to solve."];
		}
		else
		{
			tree[201] = ["#abra08#Hmm yes I was worried that might be too hard for you."];
		}
		tree[202] = ["#abra04#So, you want something just a little easier... Hmm.... Hmm... Okay, I think I've got one."];
		tree[203] = [63];
	}

	public static function random13(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var rank:Int = RankTracker.computeAggregateRank();
		var maxRank:Int = RankTracker.computeMaxRank(puzzleState._puzzle._difficulty);
		tree[0] = ["#abra05#How's your rank coming along? Hmmm... Yes, I see you're rank " + englishNumber(rank) + "..."];

		if (rank == 0)
		{
			tree[1] = ["#abra04#Oh, you haven't really started on your rank journey yet. Well, you should!"];
			if (PlayerData.isAbraNice())
			{
				tree[2] = ["#abra02#Your rank doesn't matter much anymore, but it's still a fun way to measure yourself as you improve at these puzzles. Try to get it as high as you can!"];
			}
			else
			{
				tree[2] = ["#abra02#The ranking system is actually quite important to me. Get that rank as high as you can!"];
			}
			tree[3] = ["#abra05#In the meantime, let's try another puzzle."];
		}
		else if (rank >= maxRank && rank != 65)
		{
			tree[1] = ["#abra08#You can't really progress past rank " + englishNumber(maxRank) + " on this difficulty! You'll eventually stop getting rank chances."];
			tree[2] = ["#abra04#You should focus on the harder difficulties if you want to increase your rank."];
		}
		else if (rank >= 65)
		{
			tree[1] = ["#abra07#Wait a minute, RANK " + englishNumber(rank) + "!?! How the heck did you get to Rank " + englishNumber(rank) + "?"];
			tree[2] = ["#abra03#...Maybe you should have your own puzzle game!"];
		}
		else
		{
			tree[1] = ["#abra02#...Wow, how incredibly clever of you! Getting to rank " + englishNumber(rank) + " was quite difficult wasn't it?"];
			tree[2] = ["#abra04#You're probably expecting me to well, brag about my rank and make some sort of... backhanded compliment tainted by masked condescension. But well..."];
			if (PlayerData.isAbraNice())
			{
				tree[3] = ["#abra00#...I was really proud about the design of this ranking system, and I'm glad you're participating in it. Good job."];
			}
			else
			{
				tree[3] = ["#abra00#...This ranking system is actually quite important to me and I'm glad you're participating in it. Good job."];
			}
			tree[4] = ["#abra05#..."];
			tree[5] = ["#abra02#...Now try for rank " + englishNumber(rank + 1) + "! Ee-heheh-heh."];
		}
	}

	public static function random20(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#abra04#Don't worry about the critters locked in those boxes, they've got airholes."];
		tree[1] = ["#abra08#...Well I think I remember poking some airholes!"];
		tree[2] = ["#abra03#Let's solve this one quickly just in case."];
	}

	public static function random21(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#abra05#Let's flex those brain muscles. See what you can do with this one!"];
	}

	public static function random22(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("abra.randomChats.2.2");

		if (count % 4 == 0)
		{
			tree[0] = ["%fun-nude1%"];
			tree[1] = ["#abra04#There's only one thing better than a pair of comfortable underwear..."];
			tree[2] = ["%fun-nude2%"];
			tree[3] = ["#abra03#No pair of comfortable underwear!!!"];
			tree[4] = ["#abra06#Hmm is it... Is it \"no pair\"? Zero pairs of comfortable underwear? Zero... Zero pair?"];
			tree[5] = [10, 20, 30, 40];

			tree[10] = ["No\npair"];
			tree[11] = ["#abra04#No... pair? No pair of comfortable underwear?"];
			tree[12] = ["#abra09#Hmm..."];
			tree[13] = ["#abra08#No, that's definitely not it."];

			tree[20] = ["No\npairs"];
			tree[21] = ["#abra05#No... pairs? No pairs of comfortable underwear?"];
			tree[22] = ["#abra08#No pair? No pairs? Pair, pairs... pairs..."];
			tree[23] = ["#abra07#Now the word \"pairs\" seems weird to me."];

			tree[30] = ["Zero\npair"];
			tree[31] = ["#abra08#Zero... pair? Zero pair of comfortable underwear? Are you sure?"];
			tree[32] = ["#abra09#..."];
			tree[33] = ["#abra04#I think I'll ask somebody else."];

			tree[40] = ["Zero\npairs"];
			tree[41] = ["#abra02#Zero... pairs? Really? Zero pairs of comfortable underwear?"];
			tree[42] = ["#abra03#I'm wearing zero pairs of comfortable underwear. Hey, zero pairs here. Check out my zero pairs!"];
			tree[43] = ["#abra06#..."];
			tree[44] = ["#abra10#...But that sounds so clumsy!"];
			tree[10000] = ["%fun-nude2%"];
		}
		else if (count % 4 == 2)
		{
			var puzzleRank:Int = 0;
			if (PlayerData.difficulty == PlayerData.Difficulty.Easy)
			{
				puzzleRank = 9;
			}
			else if (PlayerData.difficulty == PlayerData.Difficulty._3Peg)
			{
				puzzleRank = 19;
			}
			else if (PlayerData.difficulty == PlayerData.Difficulty._4Peg)
			{
				puzzleRank = 29;
			}
			else if (PlayerData.difficulty == PlayerData.Difficulty._5Peg)
			{
				puzzleRank = 39;
			}
			else if (PlayerData.difficulty == PlayerData.Difficulty._7Peg)
			{
				puzzleRank = 49;
			}
			var playerRank:Int = RankTracker.computeAggregateRank();

			if (puzzleRank < playerRank)
			{
				tree[0] = ["#abra05#Alright <name>, I designed this final puzzle especially for you! You'll have to-"];
				tree[1] = ["#abra06#Wait, isn't this... Oops! ...I actually designed this puzzle especially for someone else. Ehhhhhh..."];
				tree[2] = ["#abra10#Well, this one might be too simple for someone like you. I meant to grab a different puzzle!"];
			}
			else
			{
				tree[0] = ["#abra05#Alright <name>, I designed this final puzzle especially for you! You'll have to-"];
				tree[1] = ["#abra06#Wait, isn't this... Oops! ...I actually designed this puzzle especially for someone else. Ehhhhhh..."];
				tree[2] = ["#abra10#Well, this one might be too difficult for someone like you. Just do your best, okay?"];
			}
		}
		else
		{
			tree[0] = ["#abra05#Alright <name>, I designed this final puzzle especially for you! You'll have to let me know what you think of it~"];
		}
	}

	public static function random23(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.recentChatTime("abra.randomChats.2.3") >= 800)
		{
			if (PlayerData.isAbraNice())
			{
				tree[0] = ["#abra06#Ehh? Wait, I think I hear Grovyle. Hey, Grovyle!"];
				tree[1] = ["%entergrov%"];
				tree[2] = ["#grov05#Oh! ...Hello Abra. Did you need me for something?"];
				tree[3] = ["#abra02#...Ohhh, I just wanted to say thanks again for throwing me that great birthday party."];
				tree[4] = ["#grov03#Birthday party? Ah, yes! ...It was no trouble, honestly. We always do something to celebrate your birthday, I just thought I'd step it up a little."];
				tree[5] = ["#abra05#Really though, it meant a lot to me. Having all my friends around, and... well..."];
				tree[6] = ["#abra00#... ...It was just really special~"];
				tree[7] = ["%exitgrov%"];
				tree[8] = ["#grov00#Heh! Heheheheheh. Well, I'm glad you enjoyed it. ...Same time next year, hmmm?"];
				tree[9] = ["#abra02#..."];
			}
			else
			{
				var date:Int = Date.now().getDate();
				if (date >= 30)
				{
					date = 29;
				}
				else if (date % 10 == 1 || date % 10 == 2 || date % 10 == 3)
				{
					date += 3;
				}
				tree[0] = ["%entergrov%"];
				tree[1] = ["#grov03#So Abra! Your birthday's next month, isn't it? The " + date + "th?"];
				tree[2] = ["#abra04#Yes, that's right."];
				tree[3] = ["#grov05#Did you want to do anything special? Perhaps have some friends over for a party that Saturday, does that sound good?"];
				tree[4] = ["#abra05#Sure, we can have a bunch of friends over like last year."];
				tree[5] = ["#grov04#Now, what kind of cake would you like? We could do err, a traditional chocolate cake, or some kind of ice cream cake..."];
				tree[6] = ["#abra04#I don't care. Red Velvet cake."];
				tree[7] = ["#grov02#Tsk, you HATE Red Velvet. Come on, seriously you must have some opinion on the cake don't you? A favorite type of cake?"];
				tree[8] = ["#abra09#It really doesn't matter."];
				tree[9] = ["#grov03#Of course it matters, it's your birthday cake. Just pick one!"];
				tree[10] = ["#abra05#Fine... Then I pick whichever way it matters."];
				tree[11] = ["%exitgrov%"];
				tree[12] = ["#grov05#Hmph..."];
				tree[13] = ["#abra05#Sorry it's just... Sometimes it's possible to be TOO nice you know? Just bombarding me with questions..."];
				tree[14] = ["#abra04#As long as my friends are all there I don't really care about the details."];
				tree[15] = [40, 50, 20, 30];

				tree[20] = ["He was\nannoying"];
				tree[21] = ["#abra04#Ehh, he means well. He's a nice guy."];
				tree[22] = [60];

				tree[30] = ["You should\napologize"];
				tree[31] = ["#abra06#Ehh, really? Alright."];
				tree[32] = ["#abra05#GROVYLE! Hey Grovyle, are you around here?"];
				tree[33] = ["%entergrov%"];
				tree[34] = ["#grov05#Ah, yes?"];
				tree[35] = ["#abra02#Sorry I gave you a hard time earlier. Cookies and cream ice cream cake sounds great."];
				tree[36] = ["#grov02#Ahh no worries. Sorry for badgering you about the cake."];
				tree[37] = ["%exitgrov%"];
				tree[38] = [60];

				tree[40] = ["Happy\nbirthday"];
				tree[41] = ["#abra02#Ehh? Well like in four weeks anyway. Thanks."];
				tree[42] = [60];

				tree[50] = ["Let's\nmove on"];
				tree[51] = ["#abra05#Yeah I think we got one last puzzle right?"];

				tree[60] = ["#abra05#Anyway let's get to it! One more puzzle."];

				if (!PlayerData.grovMale)
				{
					DialogTree.replace(tree, 20, "He was", "She was");
					DialogTree.replace(tree, 21, "he means well", "she means well");
					DialogTree.replace(tree, 21, "He's a nice guy", "She's thoughtful");
				}
			}
		}
		else
		{
			tree[0] = ["%entergrov%"];
			tree[1] = ["#grov04#So Abra! Is it really true you can read people's thoughts?"];
			tree[2] = ["#abra04#Ehh? Yeah, vaguely. I can pretty much get a sense of what people are thinking if I concentrate on it."];
			tree[3] = ["#grov03#Alright... what am I thinking right now?"];
			tree[4] = ["#abra05#Mmmm... Your mind is... completely empty. It's like there's no brain activity whatsoever."];
			tree[5] = ["#grov14#Really? What about now? Hrnnngh..."];
			tree[6] = ["#abra04#Not getting anything. It's literally-- wait, I'm sensing a few faint electrical impulses... I think?"];
			tree[7] = ["#abra06#Nothing resembling sentience but like... about the same energy levels I'd expect from a clump of cauliflower... Certainly not enough to assemble a coherent thought."];
			tree[8] = ["#grov13#A CLUMP OF CAULIFLOWER!?! COME NOW, JUST BECAUSE I-"];
			tree[9] = ["#abra05#Whoa, whoa, here it comes. Alright, a LONG string of what appear to be expletives... Yep alright expletives, a few particularly colorful mental images and..."];
			tree[10] = ["#abra13#HEY! That's incredibly unhygenic and anyway the root system of a mango tree wouldn't even FIT up there-"];
			tree[11] = ["#grov11#Ah! Heh. heh. Pardon me for that, I err..."];
			tree[12] = ["#grov10#You know, I believe I can actually read YOUR thoughts-"];
			tree[13] = ["#abra12#..."];
			tree[14] = ["#grov15#Yes, I think I'm just going to..."];
			tree[15] = ["%exitgrov%"];
			tree[16] = ["#grov06#*cough*"];
			tree[17] = ["#abra09#Ohhhh-kay. *sigh* One last puzzle right?"];
		}
	}

	public static function restoreHandNone(tree:Array<Array<Object>>)
	{
		tree[0] = ["#self06#(Oh? ...There's another glove just sitting out here. Is this mine?)"];
		tree[1] = ["%cursor-normal%"];
		tree[2] = ["#self02#(Hey, it works! ...Well, at least that's back to normal.)"];

		tree[10000] = ["%cursor-normal%"];
	}

	public static function restoreHandAbra(tree:Array<Array<Object>>)
	{
		tree[0] = ["#abra06#...So <name>, were you ever going to tell me why you're using a mouse pointer today? Hmmmmmm?? What happened to that nice glove I made for you?"];
		tree[1] = [40, 10, 30, 50, 20];

		tree[10] = ["It was an\naccident"];
		tree[11] = ["#abra10#No, no, spare me the details! I examined the remote sensory data of the glove's final moments."];
		tree[12] = ["#abra11#...That poor, innocent glove. Why... that glove had a family, you know!"];
		tree[13] = ["%fun-alpha0%"];
		tree[14] = ["#abra05#...Well, not a large family, but it at least had a twin brother. It's right here..."];
		tree[15] = [62];

		tree[20] = ["It was my\nfault"];
		tree[21] = [11];

		tree[30] = ["I'm sorry"];
		tree[31] = ["#abra12#Tsk! Apologies are cheap, but electronics are very expensive!"];
		tree[32] = ["#abra04#The raw materials alone set me back ^6,500, plus all my precious abra time spent assembling it!"];
		tree[33] = ["#abra00#That's like... 250 abra hand jobs you owe me. Eee-heh-heh!"];
		tree[34] = [60];

		tree[40] = ["I like it\nthis way"];
		tree[41] = ["#abra12#YOU like it this way!? Well what about those of us on the OTHER side of the pointer? Hmmm?"];
		tree[42] = ["#abra05#I'm certainly not letting you get anywhere near me with that thing."];
		tree[43] = ["#abra10#Look how pointy it is, you could draw blood with it! It's a safety hazard."];
		tree[44] = [60];

		tree[50] = ["Just\nfix it"];
		tree[51] = ["#abra12#\"Just fix it\" he says. Hmph! You're lucky I like you."];
		tree[52] = [60];

		tree[60] = ["%fun-alpha0%"];
		tree[61] = ["#abra05#Anyway I think I've got a replacement for you around here..."];
		tree[62] = ["#abra06#Wait, where did it go?"];
		tree[63] = ["#abra11#What is it doing over HERE!? And why does it smell like... (sniff, sniff) who's been messing with this thing!"];
		tree[64] = ["%fun-alpha1%"];
		tree[65] = ["%cursor-normal%"];
		tree[66] = ["#abra04#Well whatever, it's yours now. Now I haven't had time to waterproof that one yet, so be gentle with it!"];
		tree[67] = ["#abra10#It's going to take me a few days to make another backup glove, so I don't know what we'll do if that one breaks."];
		tree[68] = ["#abra05#But anyways..."];

		tree[10000] = ["%fun-alpha1%"];
		tree[10001] = ["%cursor-normal%"];

		if (!PlayerData.abraMale)
		{
			DialogTree.replace(tree, 33, "hand jobs", "orgasms");
		}
		if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			DialogTree.replace(tree, 51, "he says", "she says");
		}
		else if (PlayerData.gender == PlayerData.Gender.Complicated)
		{
			DialogTree.replace(tree, 51, "he says", "they say");
		}
	}

	public static function restoreHandOther(tree:Array<Array<Object>>)
	{
		tree[0] = ["%enterabra%"];
		tree[1] = ["#abra06#...So <name>, were you ever going to tell me why you're using a mouse pointer today? Hmmmmmm?? What happened to that nice glove I made for you?"];
		tree[2] = [40, 10, 30, 50, 20];

		tree[10] = ["It was an\naccident"];
		tree[11] = ["#abra10#No, no, spare me the details! I examined the remote sensory data of the glove's final moments."];
		tree[12] = ["#abra11#...That poor, innocent glove. Why... that glove had a family, you know!"];
		tree[13] = ["%exitabra%"];
		tree[14] = ["#abra05#...Well, not a large family, but it at least had a twin brother. It's right here..."];
		tree[15] = [62];

		tree[20] = ["It was my\nfault"];
		tree[21] = [11];

		tree[30] = ["I'm sorry"];
		tree[31] = ["#abra12#Tsk! Apologies are cheap, but electronics are very expensive!"];
		tree[32] = ["#abra04#The raw materials alone set me back ^6,500, plus all my precious abra time spent assembling it!"];
		tree[33] = ["#abra00#That's like... 250 abra hand jobs you owe me. Eee-heh-heh!"];
		tree[34] = [60];

		tree[40] = ["I like it\nthis way"];
		tree[41] = ["#abra12#YOU like it this way!? Well what about those of us on the OTHER side of the pointer? Hmmm?"];
		tree[42] = ["#abra05#I'm certainly not letting you get anywhere near me with that thing."];
		tree[43] = ["#abra10#Look how pointy it is, you could draw blood with it! It's a safety hazard."];
		tree[44] = [60];

		tree[50] = ["Just\nfix it"];
		tree[51] = ["#abra12#\"Just fix it\" he says. Hmph! You're lucky I like you."];
		tree[52] = [60];

		tree[60] = ["%exitabra%"];
		tree[61] = ["#abra05#Anyway I think I've got a replacement for you around here..."];
		tree[62] = ["#abra06#Wait, where did it go?"];
		tree[63] = ["#abra11#What is it doing over HERE!? And why does it smell like... *sniff* *sniff* who's been messing with this thing!"];
		tree[64] = ["%enterabra%"];
		tree[65] = ["%cursor-normal%"];
		tree[66] = ["#abra04#Well whatever, it's yours now. Now I haven't had time to waterproof that one yet..."];
		tree[67] = ["%exitabra%"];
		tree[68] = ["#abra10#...so be gentle with it! At least until I can make a replacement..."];

		tree[10000] = ["%cursor-normal%"];
		tree[10001] = ["%exitabra%"];

		if (!PlayerData.abraMale)
		{
			DialogTree.replace(tree, 33, "hand jobs", "orgasms");
		}
		if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			DialogTree.replace(tree, 51, "he says", "she says");
		}
		else if (PlayerData.gender == PlayerData.Gender.Complicated)
		{
			DialogTree.replace(tree, 51, "he says", "they say");
		}
	}

	public static function tutorialNotice(tree:Array<Array<Object>>)
	{
		tree[0] = ["#abra02#The next step's up to you <name>! You can go back to solving more novice puzzles, or you might enjoy trying something a little more difficult, hmmm?"];
		tree[1] = ["%lights-tutorial%"];
		tree[2] = ["#abra05#...If you get confused by the new mechanics, Grovyle has tutorials on how it all works. But I think you'll pick it up easily enough~"];
		tree[3] = ["%lights-on%"];

		tree[10000] = ["%lights-on%"];
	}

	public static function halfwayNotice(tree:Array<Array<Object>>)
	{
		var totalPuzzlesSolved:Int = PlayerData.getTotalPuzzlesSolved();
		tree[0] = ["#abra02#Oh, hello <name>! How are things coming along? ...You've solved " + englishNumber(totalPuzzlesSolved) + " puzzles now. I'll bet that seems like a lot!"];
		tree[1] = ["#abra06#I haven't checked on your neurokinetics in awhile, I thought I'd see if you, hmm... ... ...hmmmmmm... Oh, I see..."];
		tree[2] = ["#abra04#Mmmm. Well, you've still a ways to go. ...I'll check in again later."];
	}

	public static function storyNotice(tree:Array<Array<Object>>)
	{
		var totalPuzzlesSolved:Int = PlayerData.getTotalPuzzlesSolved();
		tree[0] = ["#abra02#Hey <name>! How are things coming along? Let's look at your numbers."];
		tree[1] = ["#abra07#Wait, has someone been messing with this? ...Have you... have you really solved " + englishNumber(totalPuzzlesSolved) + " puzzles? How long did that take you!?"];
		tree[2] = ["#abra04#...I mean I can't... It must have taken you FOREVER to solve that many puzzles, considering you're... considering... ehhhh... ..."];
		tree[3] = ["#abra03#Considering how great you are at them!"];
		tree[4] = ["#abra06#How's your neural activity? Any new insights? Let me see... Your neurokinetics look like they're... hmmmm.... no, that's... ..."];
		tree[5] = ["#abra05#...Oh! That actually... might be good enough? Is there a chance you could, hmm...."];
		tree[6] = ["#abra04#Could you come talk to me later? ...There's something important I wanted to ask you. ... ...Thanks~"];
	}

	public static function denDialog(sexyState:AbraSexyState = null, playerVictory:Bool = false):DenDialog
	{
		var denDialog:DenDialog = new DenDialog();

		denDialog.setGameGreeting([
			"#abra04#Ah! Heracross allowed you back here, did " + (PlayerData.heraMale ? "he" : "she") + "? Well, I suppose that's acceptable. I could use the company~",
			"#abra10#Wait, you didn't actually want to play <minigame> against ME!?! Ack! Just... ...try not to get too frustrated, okay? I'll go easy on you."
		]);

		denDialog.setSexGreeting([
			"#abra05#I suppose it's okay if you take a break from puzzle stuff for a little while.",
			"#abra02#Yes, yes, everyone needs a break sometimes. It feels good to relax~"
		]);

		denDialog.addRepeatSexGreeting([
			"#abra04#I'm ready if you are. Remember, sex is kind of a puzzle too.",
			"#abra00#Just because I don't assign you an explicit sex ranking doesn't mean I'm not tracking of your progress. Eeh-heheheh~"
		]);
		denDialog.addRepeatSexGreeting([
			"#abra00#Wow, you're really giving me another turn? ...Is it a special occasion or something?",
			"#abra01#I mean, hah... I love all the attention but... I also wouldn't mind if it were spread out a little... phew..."
		]);
		denDialog.addRepeatSexGreeting([
			"#abra07#You're not exhausted yet? I mean... phew... I'm exhausted and I don't really even have to do anything..."
		]);
		denDialog.addRepeatSexGreeting([
			"#abra02#Goodness... You're always dutiful when it when it comes to your abra studies. But... what sparked this sudden cram session?"
		]);

		denDialog.setTooManyGames([
			"#abra04#Thanks, this was fun, <name>! Unfortunately, I have some abra stuff I have to go take care of.",
			PlayerData.isAbraNice() ?
			"#abra07#...But keep at it, you're actually getting REALLY good! Even by abra standards..."
			: "#abra05#...But keep at it. You're actually getting somewhat competent. You know, by non-abra standards."
		]);

		denDialog.setTooMuchSex([
			"#abra07#Phew, that was... Hahh... I think... I need to take a break...",
			"#abra08#Thanks for spending so much time with me today, <name>. I know sometimes I can be a lot to deal with but... well...",
			"#abra04#...Just, thanks~"
		]);

		denDialog.addReplayMinigame([
			"#abra02#Mmm! Well that was surprisingly fun.",
			"#abra04#Did you want to practice more? Or did you want to try your skill at... some other activities~"
		],[
			"Let's practice\nmore",
			"#abra03#Ee-heheh! I won't go so easy on you this time~"
		],[
			"Mmm! Let's try\nsome other\nactivities",
			"#abra00#Other activities? Hmm, well I guess I'm naked... And we have some privacy...",
			"#abra01#I'm sure we'll think of something~"
		],[
			"Actually\nI think I\nshould go",
			"#abra05#Oh, I see. ...I'll see you around."
		]);
		denDialog.addReplayMinigame([
			"#abra04#I think you might have actually improved ever-so-slightly. I guess it's like they say, practice makes perfect, mmm?",
			"#abra05#Did you want to play again? Or... there's always other things we could do back here..."
		],[
			"Let's play\nagain",
			"#abra02#Oh good! I was worried you'd be getting " + (playerVictory?"bored":"frustrated") + " by this~"
		],[
			"\"Other things\"\nsounds nice...",
			"#abra00#Ee-heheheh! Let's see what the two of us can come up with~"
		],[
			"I think I'll\ncall it a day",
			"#abra04#What? Oh. ...Sure, that's fine. See you around, <name>."
		]);
		denDialog.addReplayMinigame([
			"#abra04#Good game, <name>. Good game. You know, after a game like this it's proper etiquette to shake hands.",
			"#abra00#But you know... We can shake whatever you want to shake. Proper or otherwise, I won't tell~"
		],[
			"I want a\nrematch!",
			"#abra02#Eeh-heheh! Well I'll never turn down a challenge. Let's play again."
		],[
			"Let's go do\nsomething\nimproper~",
			"#abra01#Ah! To the locker rooms then. Ee-heheheh~"
		],[
			"Hmm, I\nshould go",
			"#abra05#Oh, out of time? I see. ...Hmm. I'll see you again soon."
		]);

		denDialog.addReplaySex([
			"#abra00#I'm going to go get cleaned up, look what a mess we made!",
			"#abra05#When I come back though, I wouldn't mind going one more time though. You know, if you're up for it~"
		],[
			"Sure, I'm\nup for it!",
			"#abra02#I knew you wouldn't let me down, <name>! Ee-heheheh. I'll be right back~"
		],[
			"Ahh, I'm good\nfor now",
			"#abra04#Oh, okay. ...Well, thanks for paying me a visit back here, this was nice."
		]);
		denDialog.addReplaySex([
			"#abra00#Hah... Wow... I didn't think I'd enjoy this as much without the puzzles. But... that was nice~",
			"#abra05#I'm going to grab a glass of water. I think I've still got a few left in the chamber, if you wanted to... well..."
		],[
			"Yeah!\nLet's go",
			"#abra02#Ee-heheheh! That's the spirit. I'll be right back~"
		],[
			"Oh, I think\nI'll head out",
			"#abra04#Aww okay. See you around, <name>."
		]);
		denDialog.addReplaySex([
			"#abra00#Mmmm... That felt goooooood...",
			"#abra05#I'm going to get a little snack. Did you want to stick around? I won't kick you out if you want to stay~"
		],[
			"Sure! I'll\nstay",
			"#abra01#Aww! Well... ...I'll be back in just one second."
		],[
			"I should\ngo...",
			"#abra04#Yeah! Yeah okay, I get it. ...I'll see you later."
		]);

		return denDialog;
	}

	static public function snarkyVibe(tree:Array<Array<Object>>)
	{
		if (FlxG.random.bool())
		{
			tree[0] = ["#abra12#A vibrator? Really, <name>? ...What, are you in a hurry?"];
		}
		else
		{
			tree[0] = ["#abra12#Tsk, I don't need any help from your cheap little thrift store vibrator. ... ...I can make my own stuff."];
		}
	}

	public static function cursorSmell(tree:Array<Array<Object>>, sexyState:AbraSexyState)
	{
		var count:Int = PlayerData.recentChatCount("abra.cursorSmell");

		if (count == 0)
		{
			tree[0] = ["#abra00#Nngh I'm so turned on right now. ... ... (sniff) I ehh, I can't wait to... (sniff, sniff)"];
			tree[1] = ["#abra06#... ...Oh... Did you have to screw around with Grimer before MY turn, <name>? ...Hmmm... ..."];
			tree[2] = ["#abra08#I guess I can't complain too much, seeing as it's my fault he's here in the first place. (sigh) Oh Grimer. What am I going to do with you..."];

			if (!PlayerData.grimMale)
			{
				DialogTree.replace(tree, 2, "he's here", "she's here");
			}
		}
		else
		{
			tree[0] = ["#abra00#Nngh I'm so turned on right now. ... ... (sniff) I ehh, I can't wait to... (sniff, sniff)"];
			tree[1] = ["#abra08#... ...Oh, I see. ...Smells like Abra's picking up Grimer's sloppy seconds again. ...Hmmm... ..."];
			tree[2] = ["#abra09#<name>, we don't have to do this right now if you don't want. ...Why don't you go visit Heracross? He'll be happy to have your stinky company."];

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 2, "He'll be", "She'll be");
			}
		}
	}

	public static function finalTrialSuccess():Array<Array<Object>>
	{
		var trialCount:Int = getFinalTrialCount();
		var tree:Array<Array<Object>> = [];

		if (PlayerData.abraStoryInt == 4)
		{
			tree[0] = ["#self08#(It looks like Abra's passed out... But I think... I sort of felt something?)"];
			tree[1] = ["#self04#(How will we know if it even worked? Especially if he's unconscious...)"];
			tree[2] = ["#self05#(...Huh. ...I guess I'll just have to wait and see. But he seemed a little different this time.)"];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 1, "he's unconscious", "she's unconscious");
				DialogTree.replace(tree, 2, "he seemed", "she seemed");
			}
		}
		else {
			tree[0] = ["#self08#(It looks like Abra's passed out... Did I mess up or something? I thought I did a good job...)"];
			tree[1] = ["#self09#(I mean, he's breathing and everything. ...Maybe he was just-- ooughghhghhh...)"];
			tree[2] = ["#self08#(... ... ...)"];
			tree[3] = ["#self07#(...I feel really dizzy all of a sudden... ...)"];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 1, "he's breathing", "she's breathing");
				DialogTree.replace(tree, 1, "he was just", "she was just");
			}
		}
		return tree;
	}

	public static function finalTrialFailure():Array<Array<Object>>
	{
		var trialCount:Int = getFinalTrialCount();
		var tree:Array<Array<Object>> = [];

		if (PlayerData.abraStoryInt == 4)
		{
			// don't swap...
			if (trialCount == 0)
			{
				tree[0] = ["#self08#(It looks like Abra's passed out... Was that supposed to happen? Or...)"];
				tree[1] = ["#self04#(I mean, he's breathing and everything. ...Maybe he was just tired? Hmm... ...)"];
				tree[2] = ["#self05#(...Ugh, I really hope I don't have to do all this stuff over again.)"];

				if (!PlayerData.abraMale)
				{
					DialogTree.replace(tree, 1, "he's breathing", "she's breathing");
					DialogTree.replace(tree, 1, "he was", "she was");
				}

				tree[10000] = ["%exitabra%"];
			}
			else if (trialCount == 1)
			{
				tree[0] = ["#self09#(...Ugh... It happened again...)"];
				tree[1] = ["#self05#(Am I doing something wrong? I mean, it looks like our brains are--)"];
				tree[2] = ["#grov06#Ah! Abra, enjoying some personal time with the floor, I see..."];
				tree[3] = ["#abra09#...Blrrggh..."];
				tree[4] = ["#grov04#I imagine that means you've been up drinking with <name> again? ...Very well, upsy-daisy."];
				tree[5] = ["%exitabra%"];
				tree[6] = ["#grov03#Let's get you into your nice comfy bed, hmmm? That sounds nice doesn't it~"];

				tree[10000] = ["%exitabra%"];
			}
			else if (trialCount == 2)
			{
				tree[0] = ["#self06#(... ...Aaand, of course. Nothing's happening. Again. Sigh...)"];
				tree[1] = ["#self11#(I mean, Abra seemed REALLY drunk that time. There is no WAY I'm-)"];
				tree[2] = ["#grov08#Ah. Passed out... again. ...Why are you drinking so much lately?"];
				tree[3] = ["%exitabra%"];
				tree[4] = ["#grov05#...Allllright, easy does it. Now be careful with the stairs..."];
				tree[5] = ["#abra08#Wh... what? Where is... is it... oouooghhh... think I'm... (urp) gonna throw up..."];
				tree[6] = ["#grov10#Eh!? I err... Well, why don't we stop by the restroom first..."];

				tree[10000] = ["%exitabra%"];
			}
			else if (trialCount >= 3)
			{
				tree[0] = ["#self06#(... ...)"];
				tree[1] = [FlxG.random.getObject([
													 "#self04#(...Why did Abra think this would work? This is getting ridiculous...)",
													 "#self05#(...I don't know. I just don't know...)",
													 "#self04#(...Maybe we're just too different. Maybe we'll never synchronize...)",
													 "#self05#(...I think it would be irresponsible for "+(PlayerData.abraMale?"him":"her")+" to drink more than " + (PlayerData.abraMale?"he":"she") + " already is...)",
												 ])];
				tree[2] = ["#grov09#Ohhhhh... Not again."];
				tree[3] = ["%exitabra%"];
				tree[4] = ["#grov08#Abra, I'm starting to worry. ...You can't keep doing this to yourself, there are long-term implications of-"];
				tree[5] = ["#abra08#...Puke... Puke my pants... Blgghh..."];
				tree[6] = ["#grov06#Now now, that's not going to happen. Let's just try to hurry..."];

				tree[10000] = ["%exitabra%"];
			}
		}
		else {
			// swap...
			if (trialCount == 0)
			{
				tree[0] = ["#self08#(It looks like Abra's passed out... Did I mess up or something? I thought I did a good job...)"];
				tree[1] = ["#self04#(I mean, he's breathing and everything. ...Maybe he was just tired? Hmm... ...)"];
				tree[2] = ["#self05#(...Ugh, I really hope I don't have to do all this stuff over again.)"];

				if (!PlayerData.abraMale)
				{
					DialogTree.replace(tree, 1, "he's breathing", "she's breathing");
					DialogTree.replace(tree, 1, "he was", "she was");
				}

				tree[10000] = ["%exitabra%"];
			}
			else if (trialCount == 1)
			{
				tree[0] = ["#self09#(...Ugh... It happened again...)"];
				tree[1] = ["#self05#(Am I doing something wrong? I mean, it looks like our brains are--)"];
				tree[2] = ["#grov06#Ah! Abra, enjoying some personal time with the floor, I see..."];
				tree[3] = ["#abra09#...Blrrggh..."];
				tree[4] = ["#grov04#I imagine that means you've been up drinking with <name> again? ...Very well, upsy-daisy."];
				tree[5] = ["%exitabra%"];
				tree[6] = ["#grov03#Let's get you into your nice comfy bed, hmmm? That sounds nice doesn't it~"];

				tree[10000] = ["%exitabra%"];
			}
			else if (trialCount == 2)
			{
				tree[0] = ["#self06#(... ...Aaand, of course. Nothing's happening. Again. Sigh...)"];
				tree[1] = ["#self11#(I mean, Abra seemed REALLY drunk that time. There is no WAY I'm-)"];
				tree[2] = ["#grov08#Ah. Passed out... again. ...Why are you drinking so much lately?"];
				tree[3] = ["%exitabra%"];
				tree[4] = ["#grov05#...Allllright, easy does it. Now be careful with the stairs..."];
				tree[5] = ["#abra08#Wh... what? Where is... is it... oouooghhh... think I'm... (urp) gonna throw up..."];
				tree[6] = ["#grov10#Eh!? I err... Well, why don't we stop by the restroom first..."];

				tree[10000] = ["%exitabra%"];
			}
			else if (trialCount >= 3)
			{
				tree[0] = ["#self06#(... ...)"];
				tree[1] = [FlxG.random.getObject([
													 "#self04#(...Maybe Abra's calculations were wrong. This is getting ridiculous...)",
													 "#self05#(...I don't know. I just don't know...)",
													 "#self04#(...Maybe we're just too different. Maybe we'll never synchronize...)",
													 "#self05#(...I think it would be irresponsible for "+(PlayerData.abraMale?"him":"her")+" to drink more than " + (PlayerData.abraMale?"he":"she") + " already is...)",
												 ])];
				tree[2] = ["#grov09#Ohhhhh... Not again."];
				tree[3] = ["%exitabra%"];
				tree[4] = ["#grov08#Abra, I'm starting to worry. ...You can't keep doing this to yourself, there are long-term implications of-"];
				tree[5] = ["#abra08#...Puke... Puke my pants... Blgghh..."];
				tree[6] = ["#grov06#Now now, that's not going to happen. Let's just try to hurry..."];

				tree[10000] = ["%exitabra%"];

			}
		}
		return tree;
	}

	public static function gloveWakeUp():Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		tree[0] = ["%fun-alpha0%"];
		tree[1] = ["#glov03#(vvvvrrttt..... tktktktktk-- -- --beboop!)"];
		tree[2] = ["%fun-alpha1%"];
		tree[3] = ["#glov01#Hello?"];
		tree[4] = ["#glov00#Hey <name>! I mean... Abra! Are you there?"];
		tree[5] = [10, 15, 20, 25];

		tree[10] = ["Ohhh!\nHey!"];
		tree[11] = [30];

		tree[15] = ["Yeah,\nI'm here!"];
		tree[16] = [30];

		tree[20] = ["Is that\nyou?"];
		tree[21] = ["#glov03#Yep, it's me. ...The artist formerly known as Abra."];
		tree[22] = [30];

		tree[25] = ["Abra?\nI mean...\n<name>?"];
		tree[26] = [21];

		tree[30] = ["#glov02#Sorry it took so long for me to get in touch."];
		tree[31] = ["#glov05#After we switched places, I turned off the computer without thinking, and mmm.... It took me forever to find the correct web page again."];
		tree[32] = ["#glov04#Hmph, you could have set a bookmark, or written the address down or something you know..."];
		tree[33] = ["#glov01#... ...Anyways, I trust you're settling in well in the Pokemon world?"];
		tree[34] = [45, 60, 50, 40, 55];

		tree[40] = ["I've made\nso many\nfriends"];
		tree[41] = ["#glov05#Ee-heheheh! Well that sounds great. I'm happy for you, Abra."];
		tree[42] = [70];

		tree[45] = ["I've had\nso much\nsex"];
		tree[46] = ["#glov05#Ehhhhh!? Already!?! ...Wait, who with? I hope you didn't... ... ..."];
		tree[47] = ["#glov03#... ...(sigh) Oh, nevermind. I suppose it's your body now."];
		tree[48] = [70];

		tree[50] = ["I'm having\nso much\nfun"];
		tree[51] = ["#glov05#Ee-heheheh! Well that sounds great. I'm happy for you, Abra."];
		tree[52] = [70];

		tree[55] = ["I sort\nof miss\nhome..."];
		tree[56] = ["#glov05#Yeah. I know what you mean. ...I'm starting to feel a little homesick too, but, I think playing this game a little will help me get over some of that."];
		tree[57] = ["#glov03#You know, I'll get to see some familiar faces. I can say hi to the old gang again~"];
		tree[58] = [70];

		tree[60] = ["Ugh, why\ndid you\nhave to be\na girl..."];
		tree[61] = ["#glov05#Ehhhhhh? ...Why, that's sort of rude."];
		tree[62] = ["#glov01#I give you a once-in-a-lifetime opportunity to live as a Pokemon instead of an icky human, and you're hung up on having an innie instead of an outie?"];
		tree[63] = ["#glov03#...Well, I think you'll get used to it eventually."];
		tree[64] = [70];

		tree[70] = ["#glov00#As for me, being a human is... well... I'm still adjusting to it."];
		tree[71] = ["#glov04#Physically, I had some expectation of what I was getting into but... Everything still feels so fuzzy... and weird... and gross."];
		tree[72] = ["#glov01#So umm, I shaved your arms, and your legs, and... your nipples. ...Is it normal for nipples to be that hairy!?! I suppose it's one more thing to get used to."];
		tree[73] = ["#glov03#Or maybe I'll just keep shaving them. Hmm. ...Unless... humans LIKE hairy nipples? Is... Is that something humans watch for? ...Like a status symbol?"];
		tree[74] = [100, 120, 110, 105, 115];

		tree[100] = ["My nipples\nshould have\nalready\nbeen shaved"];
		tree[101] = ["#glov01#You call THAT shaved!? ...They were like two little prickly cactuses. They're better now, but... eggghh..."];
		tree[102] = [130];

		tree[105] = ["Don't shave\nyour nipples,\nthat's weird"];
		tree[106] = ["#glov01#Ehh!? What!?! But... all those little hairs were so long, and so gross looking!"];
		tree[107] = ["#glov03#Plus like every time my shirt moved a little, I could feel them pulling and... Eggh! How did you deal with this?"];
		tree[108] = ["#glov05#...But anyways, as far as your brain though... Holy crap, I was NOT expecting it to be this bad."];
		tree[109] = [131];

		tree[110] = ["Humans don't\nusually pay\nattention\nto that"];
		tree[111] = ["#glov01#Well, in that case I'm definitely going to keep shaving them. ...It's just more comfortable this way."];
		tree[112] = [130];

		tree[115] = ["The one\nwith the\nhairiest\nnipples\nis our king"];
		tree[116] = ["#glov01#Egggghh... Well... ...I suppose I didn't have any particular political aspirations anyways."];
		tree[117] = ["#glov03#Somebody else can be king of the hairy nipple people. ...I just want to be able to put on a shirt without feeling like I'm being molested by two tiny spiders."];
		tree[118] = [130];

		tree[120] = ["My nipples\nweren't\nTHAT hairy..."];
		tree[121] = ["#glov01#Are you serious? Egggh, I was surprised I didn't clog the drain when I finished shaving."];
		tree[122] = [130];

		tree[130] = ["#glov05#As far as your brain though, holy crap Abra. I was NOT expecting it to be this bad."];
		tree[131] = ["#glov02#I thought I'd be downgrading from a supercomputer to, like, a pocket calculator."];
		tree[132] = ["#glov04#But you left me with like a... a garage sale abacus with half the beads missing!!!"];
		tree[133] = ["#glov01#How did you... How do you even multiply three-digit numbers!?! I feel like I can't keep one digit memorized while I calculate the rest..."];
		tree[134] = [155, 140, 160, 145, 150];

		tree[140] = ["Well,\njust use a\ncalculator"];
		tree[141] = ["#glov03#Hmph. I liked it better when my calculator was built in..."];
		tree[142] = [180];

		tree[145] = ["Well,\nthere are\nsome\nshortcuts"];
		tree[146] = ["#glov03#Shortcuts... Dear god, I never thought I'd need shortcuts just to do something as simple as multiplication... (sigh)"];
		tree[147] = [180];

		tree[150] = ["Well,\nI could\nnever\nreally do\nthat"];
		tree[151] = ["#glov03#(sigh) No. ...No, of course you couldn't. ... ...What have I gotten myself into..."];
		tree[152] = [180];

		tree[155] = ["I feel\nsorry for\nyou and your\npathetic brain"];
		tree[156] = ["#glov03#My pathetic brain!? *MY* pathetic brain!?!? YOU'RE the one who... grrrrrrrr..."];
		tree[157] = ["#glov01#... ...(sigh) You're not making this any easier, you know."];
		tree[158] = [180];

		tree[160] = ["Sorry, no\ntake backs"];
		tree[161] = ["#glov03#No, no. That's kind of you to... NOT offer, but I'm fine. Eh-heheh~"];
		tree[162] = ["#glov01#Even if there were some way to switch back, I think it's better this way. ... ...I can get used to this."];
		tree[163] = [180];

		tree[180] = ["#glov02#Well anyways, I should be able to keep in touch with you now that I found the website with the game on it."];
		tree[181] = ["#glov04#...Even though I know the game inside and out, I'll still try to play every once in awhile."];
		tree[182] = ["#glov03#It'll be nice to say hi, and to see all of my old friends again~"];
		tree[183] = ["#glov00#Speaking of which, I'm going to go see what they're up to. See you around, Abra~"];
		tree[184] = [200, 215, 205, 210];

		tree[200] = ["See you!"];
		tree[201] = ["%fun-alpha0%"];

		tree[205] = ["Wait!"];
		tree[206] = ["#glov04#Hey, relax Abra. ...We'll stay in touch, okay?"];
		tree[207] = ["%fun-alpha0%"];
		tree[208] = ["#glov05#You haven't seen the last of me. ... ...Anyways, take it easy~"];

		tree[210] = ["Hold on!"];
		tree[211] = [206];

		tree[215] = ["Don't\ngo yet!"];
		tree[216] = [206];

		tree[10000] = ["%fun-alpha0%"];

		return tree;
	}
}
