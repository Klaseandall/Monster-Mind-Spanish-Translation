package poke.buiz;

import MmStringTools.*;
import critter.Critter;
import minigame.GameDialog;
import minigame.MinigameState;
import minigame.scale.ScaleGameState;
import flixel.FlxG;
import minigame.tug.TugGameState;
import poke.magn.MagnDialog;
import openfl.utils.Object;
import PlayerData.hasMet;
import minigame.stair.StairGameState;
import puzzle.ClueDialog;
import puzzle.Puzzle;
import puzzle.PuzzleState;
import puzzle.RankTracker;

/**
 * Buizel is canonically female. Buizel met Abra and Grovyle in college. Buizel
 * went to high school pretty far away, so she didn't have any friends, but
 * Grovyle helped her make friends. After college, they moved into a house
 * where they now live with Sandslash.
 * 
 * Buizel's a lesbian. Growing up in a small town there wasn't much of an LGBT
 * scene so she didn't date much. But, now she's looking to make up for lost
 * time.
 * 
 * Buizel startles easily.
 * 
 * Buizel and Grovyle are two of the few pokemon who wears clothing normally,
 * not just for the sake of the game. ...I guess maybe if you were Sandslash's
 * roommate you'd cover up too... ...
 * 
 * Buizel loves her parents and misses her friends from back home, but she's
 * much happier in the suburbs. She really hopes they'll some day move out
 * where she is so that she can see them again.
 * 
 * As far as minigames go, Buizel is terrible at them, and especially terrible
 * at the stair game. She always forgets about the bonus for rolling double
 * 0s, and ignores her opponent's motives.
 * 
 * ---
 * 
 * When writing dialog, I think it's good to have an inner voice in your head
 * for each character so that they behave and speak consistently. Buizel's
 * inner voice was Coach McGuirk from Home Movies.
 * 
 * Medium-bad at puzzles (Rank 13)
 * 
 * Vocal tics: Bwark! Bweh-heh-heh!
 */
class BuizelDialog
{
	private static var _intA:Int = 0;
	private static var _intB:Int = 0;
	public static var prefix:String = "buiz";
	public static var sexyBeforeChats:Array<Dynamic> = [sexyBefore0, sexyBefore1, sexyBefore2, sexyBefore3];
	public static var sexyAfterChats:Array<Dynamic> = [sexyAfter0, sexyAfter1, sexyAfter2, sexyAfter3];
	public static var sexyBeforeBad:Array<Dynamic> = [sexyBadQuick0, sexyBadQuick1, sexyBadTube, sexyBadForeplay];
	public static var sexyAfterGood:Array<Dynamic> = [sexyAfterGood0, sexyAfterGood1];
	public static var fixedChats:Array<Dynamic> = [goFromThere, waterShorts, ruralUpbringing, movingAway];
	public static var randomChats:Array<Array<Dynamic>> = [
				[random00, random01, random02, random03],
				[random10, random11, random12, random13],
				[random20, random21, random22, random23]];

	public static function getUnlockedChats():Map<String, Bool>
	{
		var unlockedChats:Map<String, Bool> = new Map<String, Bool>();
		unlockedChats["buiz.randomChats.0.2"] = hasMet("sand");
		unlockedChats["buiz.randomChats.1.2"] = hasMet("rhyd");
		unlockedChats["buiz.randomChats.1.4"] = hasMet("luca");
		unlockedChats["buiz.randomChats.2.3"] = hasMet("magn");
		unlockedChats["buiz.sexyBeforeChats.3"] = hasMet("rhyd");
		return unlockedChats;
	}

	public static function clueBad(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var clueDialog:ClueDialog = new ClueDialog(tree, puzzleState);
		clueDialog.setGreetings(["#buiz04#Oh yeah, I'm not sure your answer fits with that <first clue>...",
								 "#buiz04#Hmm wait, does that <first clue> line up? I don't know if that makes sense...",
								 "#buiz04#Huh, if that <first clue>'s right... I'm not sure if it matches your answer, does it?",
								]);
		clueDialog.setQuestions(["Really?", "What?", "Why not?", "It doesn't?"]);
		if (clueDialog.actualCount > clueDialog.expectedCount)
		{
			clueDialog.pushExplanation("#buiz06#So looking at that <first clue>... It's got too many <bugs in the correct position>.");
			clueDialog.pushExplanation("#buiz08#Since it's got <e hearts>, it should only have <e bugs in the correct position>. But it's got, like... <a bugs in the correct position>, if I'm counting right.");
			clueDialog.fixExplanation("should only have zero", "shouldn't have any");
			clueDialog.pushExplanation("#buiz04#Try to change your answer so the <first clue> doesn't have as many <bugs in the correct position>. And uhh, hit that button in the corner if you need anything from me!");
		}
		else
		{
			clueDialog.pushExplanation("#buiz06#So looking at that <first clue>... It needs more <bugs in the correct position>.");
			clueDialog.pushExplanation("#buiz08#Since it's got <e hearts>, it should have <e bugs in the correct position>. But it's only got, like... <a bugs in the correct position>, if I'm counting right.");
			clueDialog.fixExplanation("only got, like... zero", "doesn't have, like... any");
			clueDialog.pushExplanation("#buiz05#Try to change your answer so the <first clue> has more <bugs in the correct position>. And uhh, hit that button in the corner if you need anything from me!");
		}
	}

	static private function newHelpDialog(tree:Array<Array<Object>>, puzzleState:PuzzleState, minigame:Bool=false):HelpDialog
	{
		var helpDialog:HelpDialog = new HelpDialog(tree, puzzleState);
		helpDialog.greetings = [
			"#buiz05#Hey were you lookin' for me? What did you need?",
			"#buiz05#Oh hey, man! Did you need me for anything?",
			"#buiz05#Hey what's up? Were you stuck or something?",
		];

		helpDialog.goodbyes = [
			"#buiz03#Aw man! This was fun, I hope we can do it again!",
			"#buiz03#Uhh well-- it was good seeing you, briefly! Bweh-heh-heh!",
			"#buiz03#Bwark!? What could be more important than your Buizel friend!",
		];

		helpDialog.neverminds = [
			"#buiz04#Oh alright! Yeah let's get back to it.",
			"#buiz04#Ah sorry, probably my fault! Bweh-heh-heh.",
			"#buiz04#So anyways, where were we... Let's see...",
		];

		helpDialog.hints = [
			"#buiz06#Huh yeah, every once in awhile Abra screws up one of these puzzles. I'll go get him.",
			"#buiz06#Yeah, it looks like something's a little messed up with this puzzle. I'll see if Abra can fix it.",
			"#buiz06#Sheesh yeah, what was Abra thinking? This one like, needs at least two more clues to be solvable."
		];

		if (!PlayerData.abraMale)
		{
			helpDialog.hints[0] = StringTools.replace(helpDialog.hints[0], "get him", "get her");
		}
		return helpDialog;
	}

	public static function help(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		return newHelpDialog(tree, puzzleState).help();
	}

	public static function minigameHelp(tree:Array<Array<Object>>, minigameState:MinigameState)
	{
		gameDialog(Type.getClass(minigameState)).help(tree, newHelpDialog(tree, null, true));
	}

	public static function gameDialog(gameStateClass:Class<MinigameState>)
	{
		var manColor:String = Critter.CRITTER_COLORS[0].english;
		var comColor:String = Critter.CRITTER_COLORS[1].english;

		var g:GameDialog = new GameDialog(gameStateClass);

		g.addSkipMinigame(["#buiz06#Uhhh yeah? Well okay sure -- if you're not in the mood for this sorta thing, then like... maybe we can think of something you ARE in the mood for.", "#buiz03#Let's see... Something <name> is in the mood for... Uhhh yeah! I think I've got an idea~"]);
		g.addSkipMinigame(["#buiz04#Not feeling it today huh? Yeah, no problem! There's plenty of other stuff we can do instead.", "#buiz06#Let's see... Other stuff... Other stuff... Uhhh yeah! I think I've got an idea~"]);

		g.addRemoteExplanationHandoff("#buiz06#I don't really remember this one that well. Uhh, lemme see if <leader>'s around, I think <leaderhe> knows how to play.");

		g.addLocalExplanationHandoff("#buiz06#<leader>, can you remind me how the rules work? ...Or maybe you can just like, teach <name> and I'll listen in?");

		g.addPostTutorialGameStart("#buiz04#So uhh does that make sense? You ready to go?");

		g.addIllSitOut("#buiz03#Hey is it okay if you play without me? I'm kind of a beast at this, might not be fun.");
		g.addIllSitOut("#buiz03#Hmm, I'm worried this might be kinda one-sided. You wanna play this one without me?");

		g.addFineIllPlay("#buiz02#Yeah okay. The more the merrier right? Show me what you can do!");
		g.addFineIllPlay("#buiz02#Well okay, bweh-heheheh. I tried to warn you. We'll see how this goes.");

		g.addGameAnnouncement("#buiz04#Oh okay yeah, this is... like... <minigame>. I guess.");
		g.addGameAnnouncement("#buiz04#It looks like this time it's... uhhh... What's it called? <Minigame>.");
		g.addGameAnnouncement("#buiz04#Oh hey it's <minigame>. Yeah, I remember this one.");

		if (PlayerData.denGameCount == 0)
		{
			g.addGameStartQuery("#buiz05#Is that okay? You ready to go?");
			g.addGameStartQuery("#buiz05#That's okay isn't it? Should we start?");
			g.addGameStartQuery("#buiz05#This one's fine isn't it? You ready to start?");
		}
		else
		{
			g.addGameStartQuery("#buiz05#So uhhhh you ready to go <name>?");
			g.addGameStartQuery("#buiz05#Should we start? I'm ready when you are!");
			g.addGameStartQuery("#buiz05#Alright! Game number " + englishNumber(PlayerData.denGameCount + 1) + "! You ready to start?");
		}

		g.addRoundStart("#buiz04#Alright next round! We're starting in 3... 2... 1...", ["Wait, wait!\nSlow down!", "Start!", "I think the game counts\ndown for us..."]);
		g.addRoundStart("#buiz03#Hey so uhh... You ready for round <round>?", ["Yep, let's\ndo this", "Uhh... should\nI be worried?", "..."]);
		g.addRoundStart("#buiz02#Watch out! Round <round>'s when I kick it into high gear.", ["I'll believe it\nwhen I see it", "Oh no! Go\neasy on me!", "Baby I was BORN\nin high gear"]);
		g.addRoundStart("#buiz04#Guess it's time for round <round>!", ["How many more\nrounds is this?", "Time to get\nserious!", "Let's\nstart"]);

		if (gameStateClass == ScaleGameState) g.addRoundWin("#buiz02#Bweh! Heh! See, I told you I can add. Sometimes.", ["What's four plus\nfour again?", "Wow you're so\ngood at this!", "Yeah well... I'm\nmore buoyant!"]);
		g.addRoundWin("#buiz03#Hey man you don't gotta go easy on me! I can handle it.", ["Okay, time to\nget serious!", "Yeah,\nyeah...", "I wasn't\ngoing easy..."]);
		g.addRoundWin("#buiz06#Watch out! I've unleashed the beazt. Unleashed... The buizt? Beast? Ehh whatever, nevermind.", ["Oh is that\nhow it is?", "Uh oh!", "Pipe down,\nwater rat!"]);
		g.addRoundWin("#buiz04#Hey check it out! Buizel got one!", ["Sheesh you're\nquick", "Hmm...", "That's the last one you're\ngetting, you tricky weasel"]);

		g.addRoundLose("#buiz06#Wait, do those numbers really add up? That can't be right...", ["Check your\nmath", "Are you\nserious?", "...Uhh..."]);
		g.addRoundLose("#buiz02#Dang <leader>, your puzzle game is on point! Lightning speed over there~", ["Next round's\nmine, <leader>!|Game recognize\ngame~", "How does\n<leaderhe> do it?|Aww\nshucks~", "<leaderHe> just\ngot lucky...|I just got\nlucky..."]);
		if (gameStateClass == ScaleGameState) g.addRoundLose("#buiz04#Gwuh! That one was kinda confusing.", ["Yeah, these puzzles\nare tricky", "My brain is\nexploding...|I'm on\nfire!", "It seemed\nOK to me"]);
		if (gameStateClass == TugGameState) g.addRoundLose("#buiz04#Gwuh! This is a lot to keep track of.", ["Yeah, all\nthis math...", "I'm on\nfire!", "It seems\nOK to me"]);

		g.addWinning("#buiz02#Here comes the Buizel bus! Toot toot!!", ["I need to get off\nthe Buizel bus...", "Hmm...", "...Buses don't\ntoot..."]);
		if (gameStateClass == ScaleGameState) g.addWinning("#buiz03#When it comes to adding numbers between one and twenty I'm like... A total beast!! Just ask my kindergarten teacher.", ["Your kindergarten\nteacher's an asshole", "Your... your FORMER\nkindergarten teacher?", "I should have paid\nattention in school..."]);
		if (gameStateClass == StairGameState) g.addWinning("#buiz03#When it comes to counting to four I'm like... A total beast!! Just ask my kindergarten teacher.", ["Your kindergarten\nteacher's an asshole", "Your... your FORMER\nkindergarten teacher?", "I should have paid\nattention in school..."]);
		if (gameStateClass == TugGameState) g.addWinning("#buiz03#When it comes to figuring out which number is bigger I'm like... A total beast!! Just ask my kindergarten teacher.", ["Your kindergarten\nteacher's an asshole", "Your... your FORMER\nkindergarten teacher?", "I should have paid\nattention in school..."]);
		g.addWinning("#buiz03#Kickin' it into BUIZEL OVERDRIVE now! VrrrrrrrRRRR!!!", ["Stop it,\nthat's distracting!", "Heh\nwhat!?", "You need to cut back\non your caffeine"]);
		g.addWinning("#buiz02#Heck yeah! Check me out, way out in front. I'm unstoppable!", ["The bigger they are,\nthe harder they fall", "How much do you\npractice this?", "You're not that\nfar ahead"]);

		g.addLosing("#buiz10#Phwooh! Talk about a mental workout...", ["This is baby\nstuff...", "It's tough\nisn't it?", "Feel the\nburn!"]);
		g.addLosing("#buiz07#Hey can we take a break? ...My BRAIN hurts...", ["It's because you've never\nused it before...", "Tough it out,\nit's almost over", "Aww, you\ncan do it"]);
		if (gameStateClass == ScaleGameState || gameStateClass == TugGameState) g.addLosing("#buiz06#Sheesh, <leader>... Can we slow it down a few notches? I'm just here to have fun...", ["Yeah what's\n<leaderhis> hurry?|Aww okay, I'll\ntake it easy", "You can have fun\nAND go fast...", "Pick it up,\n" + (PlayerData.buizMale ? "grandpa" : "grandma")]);
		if (gameStateClass == ScaleGameState) g.addLosing("#buiz01#Check it out <leader>, you're WEIGH in the lead! Bweh-heh-heh!", ["You're making my\nloss more painful|I'm going to beat you even\nharder for that pun", "Ha! Ha!", "Grooannn..."]);
		if (gameStateClass == StairGameState) g.addLosing("#buiz01#Gotta hand it to you <name>, you're always one STEP ahead! Bweh-heh-heh!", ["I'm going to beat you even\nharder for that pun", "Ha! Ha!", "Grooannn..."]);
		if (gameStateClass == TugGameState) g.addLosing("#buiz01#Check out your score <leader>! ...You're really PULLING ahead! Bweh-heh-heh!", ["I'm going to beat you even\nharder for that pun", "Ha! Ha!", "Grooannn..."]);
		if (gameStateClass != ScaleGameState) g.addLosing("#buiz06#You have a really different style of playing, this'll take me some getting used to...", ["The game\nwill be over\nby then", "What? It\nseems simple", "Who have you\nbeen playing\nwith!?"]);

		g.addPlayerBeatMe(["#buiz03#Ehh to be honest, I kinda knew I didn't have a chance against you. But I still had a good time!!", "#buiz02#As long as it's fun for you, well- I have fun losing. Let's play again sometime, <name>~"]);
		if (gameStateClass == ScaleGameState) g.addPlayerBeatMe(["#buiz02#Man, that wasn't even close!! You're WAY too good at this. Bweh-heh-heh!", "#buiz03#Freakin'... Mathematical badass over here. Look at you! Your medal's in the mail, buddy.", "#buiz02#Well... that, and your <money>. Don't spend it all in one place eh!"]);
		if (gameStateClass != ScaleGameState) g.addPlayerBeatMe(["#buiz02#Man, that wasn't even close!! You're WAY too good at this. Bweh-heh-heh!", "#buiz03#Freakin' little... minigame badass over here. Look at you! Your medal's in the mail, buddy.", "#buiz02#Well... that, and your <money>. Don't spend it all in one place eh!"]);

		if (gameStateClass == ScaleGameState) g.addBeatPlayer(["#buiz02#What!? Oh man! I probably did a bad job explaining this game. I'm sorry.", "#buiz04#I mean it feels good to win, but... You know what? We'll try again. I know you can beat me once you know the rules."]);
		if (gameStateClass == ScaleGameState) g.addBeatPlayer(["#buiz00#Wait what? Did I really win? Wait... What? Somebody add the score up again!", "#buiz02#Geez, " + (PlayerData.buizMale ? "Mr." : "Mrs.") + " Four Plus Four Equals Ten pulled out a win. Bweh-heh!", "#buiz04#Even a stopped clock is right twice a day I guess. Anyway, good game!"]);
		if (gameStateClass != ScaleGameState) g.addBeatPlayer(["#buiz00#Wait what? Did I really win? Wait... What? Somebody check the rules! That doesn't sound right...", "#buiz02#Geez, even a stopped Buizel is right twice a day I guess. Bweh-heh!", "#buiz03#Anyway, good game! ...We can have a rematch soon so you can, y'know', put me back in my place or whatever. Pretty sure I just got lucky..."]);
		g.addBeatPlayer(["#buiz02#Bweh! Heheheh! Wow! ...I thought I had you beat but, y'know, I kept kinda expecting you to turn it around in the end.", "#buiz06#Usually when I get my hopes up like that, I'll end up having some crazy streak of bad luck and falling into last place... Bweh.", "#buiz03#But yeah, good game! Hopefully we can play again soon, and you know. Maybe you can like, tie things up. Bweh-heh."]);

		g.addShortWeWereBeaten("#buiz03#Don't sweat it, <leader>'s really good... <leaderHe's> always winning games like this.");
		g.addShortWeWereBeaten("#buiz02#Hey thanks for joining me <name>! You made my Buizel day~");

		g.addShortPlayerBeatMe("#buiz02#Ahh you earned it buddy. Well played! Bwark!");
		g.addShortPlayerBeatMe("#buiz03#Ahhh, I'll get you next time! Bweh-heh-heh. Or not.");

		g.addStairOddsEvens("#buiz06#So let's see, how 'bout we do like, odds and evens to see who goes first. You're odds, I'm evens. 'sthat sound good?", ["So...\nI'm odds?", "Yeah,\nokay!", "Uhh sure,\nwhy not"]);
		g.addStairOddsEvens("#buiz05#Let's do odds and evens to like, see who goes first. Odd number you go first, even number... I go first. Alright?", ["Yeah!\nOkay", "Odd number,\nI go first...", "Simple\nenough"]);

		g.addStairPlayerStarts("#buiz06#Huh, well I guess you'll go first. That's cool, maybe I can see what you do and like, copy it or something. You ready?", ["Alright,\nI'm ready", "Yep!", "Don't copy\nit, you'll\ncapture me!"]);
		g.addStairPlayerStarts("#buiz03#Guess that means you go first. Is that cool? ...You know what you're throwing out on your first turn?", ["Yeah!\nI'm ready", "Yep, let's\nstart", "Sure\nthing"]);

		g.addStairComputerStarts("#buiz06#Whoa! So I guess I get to go first. Cool, cool, now I just gotta figure out what I'm doing for my first move... Hmm... Hmm... You ready?", ["Just throw\nout two,\nalready", "Yeah!", "Yep,\nlet's go"]);
		g.addStairComputerStarts("#buiz03#I'm going first? Yeah alright, that works! ...You weren't just letting me go first, like, 'cause it's bad or something, were you?", ["I'm going to\ncapture you\nso easily", "No, I didn't\nmean to...", "Heh, let's\njust start"]);

		g.addStairCheat("#buiz03#Wait, what!?! ...C'mon, you didn't think I'd see through that? You gotta throw it at the same time as me...", ["Alright,\nI'll try...", "Okay,\non three", "That was\nsort of the\nsame time!"]);
		g.addStairCheat("#buiz08#Uhhh, c'mon man. Cheating kinda ruins this game. You gotta put yours out sooner than that...", ["Why?\nWhy can't\nI wait?", "Ugh, seems\ndumb...", "Oh, okay"]);

		g.addStairReady("#buiz04#Hey, you ready?", ["Yep!\nReady", "I think\nso", "Yeah,\nlet's go"]);
		g.addStairReady("#buiz05#...Ready?", ["Okay", "Yeah,\ndo it!", "On three..."]);
		g.addStairReady("#buiz05#Okay, ready?", ["Sure", "Yeah!", "Hmm, let\nme think..."]);
		g.addStairReady("#buiz06#Hmm... You know what you're throwing?", ["Well,\nmaybe...", "I think\nso!", "Sure, go"]);
		g.addStairReady("#buiz04#Uhh, you ready?", ["On three?", "Let's\ndo this", "Hm..."]);

		g.addCloseGame("#buiz03#Whoa, this game is like... really close! Look at us, we're like... neck-tube and neck-tube, over here.", ["Yeah, you're pretty\ngood at this!", "Can't tell who's\ngonna win...", "Neck-tube!?\nI don't have\na neck-tube"]);
		g.addCloseGame("#buiz06#So I'm starting to figure out why you like, don't always wanna throw out twos on your turn... Hmm...", ["Yeah, it can\nbackfire", "You're just\nfiguring\nthat out!?", "Careful,\ndon't hurt\nyour brain"]);
		g.addCloseGame("#buiz04#It's kinda funny how everybody plays this game a little differently. I'm starting to figure out your strategy...", ["Strategy?\nI just pick\na random\nnumber...", "Yeah, but I'm\nfiguring\nout yours", "Well then,\nI'll change\nmy strategy!"]);
		g.addCloseGame("#buiz06#I guess if I wanna slow you down, I should throw zeroes instead of ones. But you might throw zeroes too... Hmm...", ["Just pick\nalready", "Yeah, throw a\nzero! See where\nthat gets you", "...So you can\nclearly not\nchoose the wine\nin front of you..."]);

		g.addStairCapturedHuman("#buiz02#Bweh! You never thought I'd throw a <computerthrow> I guess, huh? ...I mean it was probably dumb of me.", ["Ugh, you're\nso lucky!", "Nah, it\nmade sense", "Well, but it worked..."]);
		g.addStairCapturedHuman("#buiz03#Bweh-heh, whoa <name>! Look at my little " + comColor + " bugs go. Time to activate the turbo boosters! ZZzzwoooosh!", ["Turbo boosters!?\nMy bugs didn't\nget those...", "Ah geez, it'll\nbe hard to\ncatch up now", "Heh heh,\nyou're such\na jackass"]);
		g.addStairCapturedHuman("#buiz01#Bweheheheh! I was sorta wonderin' if you were a top or a bottom. But yep, definitely a bottom. Look at you down there...", ["Next time,\nit's your turn\non the bottom", "Whoops,\nsecret's out~", "I'm a top!\n...I just suck\nat minigames"]);

		g.addStairCapturedComputer("#buiz15#Wait, what? How'd you know I was gonna do that!? ...I mean, c'mon, I was trying to stay unpredictable...", ["Awww yeah,\nget wrecked...", "I predicted\nyou'd be\nunpredictable~", "Sorry! That\nwas mean~"]);
		g.addStairCapturedComputer("#buiz13#Aww hey wait, do I gotta go ALL the way back to the start? How about I like, just go half-way...", ["Heh! Get\nback there~", "Stop trying\nto change\nthe rules!", "No no,\nc'mon,\nbe fair"]);
		g.addStairCapturedComputer("#buiz09#Bwehhhh! Man, you really can't cut me just a little slack? I was almost there...", ["Sorry,\nbuddy", "Maybe\njust this\nonce...", "Ehh,\nquit your\nwhining~"]);

		return g;
	}

	public static function bonusCoin(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (FlxG.random.bool(30))
		{
			tree[0] = ["#buiz06#What is that? Some kind of... tiny cracker? ...Can I eat it?"];
			tree[1] = ["#buiz13#OWW! This thing's like REALLY hard!"];
			tree[2] = ["#buiz04#Hey wait, oh-kay. Now I remember! This is one of those... bonus game things, isn't it? Awesome! Let's bonus game it up!"];
			tree[3] = ["#buiz08#...although now I'm kinda hungry..."];
		}
		else
		{
			tree[0] = ["#buiz02#Bwark!? Is that... Whoa, you found a bonus coin!"];
			tree[1] = ["#buiz03#Well this is like, your unlucky day. ...You ready to get your butt kicked at a minigame? Bweh! Heheheh."];
			tree[2] = ["#buiz00#Bwehhhhhh, I'm just kidding. I'll probably lose. Let's see which one it is though~"];
		}
	}

	public static function sexyBadForeplay(tree:Array<Array<Object>>, sexyState:BuizelSexyState)
	{
		tree[0] = ["#buiz05#Oh man finally! Is it time? I think it's time! Bwark! Bwark!"];
		tree[1] = ["#buiz06#Although hey if you don't mind, maybe a little more foreplay this time..."];
		tree[2] = ["#buiz01#I mean... My cock's not the only sensitive part of my body you know...!"];
		if (!PlayerData.buizMale)
		{
			DialogTree.replace(tree, 2, "cock", "pussy");
		}
	}

	public static function sexyBadTube(tree:Array<Array<Object>>, sexyState:BuizelSexyState)
	{
		tree[0] = ["#buiz03#So, I don't know what your obsession is with my tube,"];
		tree[1] = ["#buiz06#Maybe you think it's funny? Maybe you think it feels good? I dunno,"];
		tree[2] = ["#buiz12#But c'mon, what the heck. Enough's enough already. Quit rubbing my tube."];
		tree[3] = [10, 20, 30];

		tree[10] = ["But I\nlike it"];
		tree[11] = ["#buiz13#What!! What the heck is wrong with you,"];
		tree[12] = ["#buiz12#It's my tube. It's my personal tube and you're just... just a disrespectful tube rubber."];
		tree[13] = ["#buiz06#Tsk whatever man, rub what you gotta rub, but--"];
		tree[14] = ["#buiz01#Maybe explore some other parts of my body instead. Maybe you'll find something I really like."];

		tree[20] = ["What's the\nbig deal"];
		tree[21] = ["#buiz07#It just doesn't feel like anything man, you may as well be rubbing... my shoe,"];
		tree[22] = ["#buiz06#I'm sensitive like, everywhere on my body except that one part, so you know-"];
		tree[23] = [14];

		tree[30] = ["Okay I'm\nsorry"];
		tree[31] = ["#buiz05#Aww well it's no sweat, you didn't know,"];
		tree[32] = ["#buiz02#Now I feel bad for makin a big deal out of it! Bweh-heh-heh-heh."];
		tree[33] = [14];
	}

	public static function sexyBadQuick1(tree:Array<Array<Object>>, sexyState:BuizelSexyState)
	{
		tree[0] = ["#buiz03#Alright! So I figured out how to deal with my short fuse, really this time! But we both gotta do our part!"];
		tree[1] = ["#buiz06#I'm gonna warn you right before I cum, okay <name>? And you..."];
		tree[2] = ["#buiz08#You gotta just find somethin else to rub for a little while okay? Just-- just don't touch my dick,"];
		if (!PlayerData.buizMale)
		{
			DialogTree.replace(tree, 2, "don't touch my dick", "give my cunt some time to cool down");
		}
		tree[3] = ["#buiz11#I can't really control my body when you're touching me there! ...I can't help it."];
		tree[4] = ["#buiz04#Okay!!! Teamwork! Let's do it!"];
	}

	public static function sexyBadQuick0(tree:Array<Array<Object>>, sexyState:BuizelSexyState)
	{
		tree[0] = ["#buiz04#Oh boy! Is it Buizel time again? ...I love this part!"];
		tree[1] = ["#buiz06#You know, maybe I can last a little longer this time. I'll try to warn you when I'm getting close, alright?"];
		tree[2] = ["#buiz03#And then maybe you can just... give my dick a short break so I don't explode all over you?"];
		if (!PlayerData.buizMale)
		{
			DialogTree.replace(tree, 2, "dick", "pussy");
		}
		tree[3] = ["#buiz13#Alright let's do this!! Grrrrr!! Let's get psyched up! I can do it!"];
	}

	public static function sexyAfterGood0(tree:Array<Array<Object>>, sexyState:BuizelSexyState)
	{
		tree[0] = ["#buiz00#Hah!! Ahhhh.... phwooooooo... <name>... THAT was..."];
		tree[1] = ["#buiz03#That was something else!! You've... you've learned some new moves!!"];
		tree[2] = ["#buiz01#Can you... can you do that for me again next time?? Wow... hahhhh...."];
	}

	public static function sexyAfterGood1(tree:Array<Array<Object>>, sexyState:BuizelSexyState)
	{
		tree[0] = ["#buiz00#Bw-- Bwaaaaarrrkk.... <name>... oh... oh wow...!"];
		tree[1] = ["#buiz03#I didn't even know I had that much stored up! Did you... did you do something different? That was..."];
		tree[2] = ["#buiz01#That was... I mean you're usually good but THAT was... hahhh... bwark~"];
	}

	public static function sexyAfter0(tree:Array<Array<Object>>, sexyState:BuizelSexyState)
	{
		tree[0] = ["#buiz00#Wowww, that was niiiiice. Bwark~"];
		tree[1] = ["#buiz05#Sorry I didn't last longer. You! You were great. I'll work on my uhh-- my stamina, okay?"];
	}

	public static function sexyAfter1(tree:Array<Array<Object>>, sexyState:BuizelSexyState)
	{
		tree[0] = ["#buiz01#Phwooh. Well my Buizel balls are officially empty. And that's something man,"];
		tree[1] = ["#buiz00#It takes a-- takes a special touch to empty these bad boys!"];
		if (!PlayerData.buizMale)
		{
			tree[0] = ["#buiz01#Phwooh. Well my... Buizel area's been officially milked dry. And that's something man,"];
			tree[1] = ["#buiz00#It takes a-- takes a special touch to empty me like that!"];
		}
		tree[2] = ["#buiz05#You're gonna come visit me again, right?"];
	}

	public static function sexyAfter2(tree:Array<Array<Object>>, sexyState:BuizelSexyState)
	{
		var count:Int = PlayerData.recentChatCount("buiz.sexyAfterChats.2");

		tree[0] = ["#buiz09#Ahhhh... wow.... how come it doesn't feel that way when I do it?"];
		if (!PlayerData.buizMale && count % 3 == 0)
		{
			tree[1] = ["#buiz01#Something about those slender little fingers of yours just... ... It gets me moister than an oyster! Bweheheh~"];
		}
		else
		{
			tree[1] = ["#buiz04#I... I promise I'm not usually that quick!"];
		}
	}

	public static function sexyAfter3(tree:Array<Array<Object>>, sexyState:BuizelSexyState)
	{
		tree[0] = ["#buiz00#That was... wow, bwark~"];
		tree[1] = ["#buiz01#I think I'm just gonna... phwoo.... I'm just gonna hang out here for awhile..."];
		tree[2] = ["#buiz04#Why don't you see what the others are up to."];
	}

	public static function sexyBefore0(tree:Array<Array<Object>>, sexyState:BuizelSexyState)
	{
		if (PlayerData.recentChatCount("buiz.sexyBeforeChats.0") == 0)
		{
			tree[0] = ["#buiz06#Wellp, I'm officially outta clothes and you've solved the last of the three puzzles. I guess now we're supposed to, uhh..."];
			tree[1] = ["#buiz02#...Yeah. This still feels kinda weird to me. Bweh-heh-heh~"];
			tree[2] = ["#buiz03#Tell you what, why don't you get me warmed up a little. You know, start me on the bunny slopes or whatever."];
			tree[3] = ["#buiz04#I've got kind of a hair trigger anyway. Trust me... you'll be doin' yourself a favor."];
		}
		else
		{
			tree[0] = ["#buiz01#Oh man! So..."];
			tree[1] = ["#buiz00#So what kind of stuff are you gonna teach me today...?"];
		}
	}

	public static function sexyBefore1(tree:Array<Array<Object>>, sexyState:BuizelSexyState)
	{
		if (PlayerData.justFinishedMinigame)
		{
			tree[0] = ["#buiz04#Phew! those minigames are fun but... y'know, it was sorta hard to concentrate thinking about what was coming afterward..."];
		}
		else
		{
			tree[0] = ["#buiz04#Phew! I thought you'd never get through that last puzzle."];
		}
		tree[1] = ["#buiz01#My body's aching for this... I can't wait to see what you come up with this time~"];
	}

	public static function sexyBefore2(tree:Array<Array<Object>>, sexyState:BuizelSexyState)
	{
		tree[0] = ["#buiz03#So, not to brag but I've been practicing a little, trying to last a little longer,"];
		tree[1] = ["#buiz02#And yesterday I jerked off for like... two minutes! Two minutes in a row!"];
		if (!PlayerData.buizMale)
		{
			tree[1] = ["#buiz02#And yesterday I fingered myself for like... two minutes! Two minutes in a row without finishing!"];
		}
		tree[2] = [10, 20, 30];
		tree[10] = ["That's\nnothing"];
		tree[11] = ["#buiz11#Nothing!? Hey, two minutes is really good for a Buizel!"];
		tree[12] = ["#buiz08#Like, I don't know if Buizels were really meant to last that long. We're really sensitive! But..."];
		tree[13] = ["#buiz05#But I'll do my Buizel best for you!"];
		tree[20] = ["Wow, good\njob"];
		tree[21] = ["#buiz07#It doesn't... It doesn't feel good when I try to hold it in like that though."];
		if (!PlayerData.buizMale)
		{
			DialogTree.replace(tree, 21, "hold it in", "slow down");
		}
		tree[22] = [12];
		tree[30] = ["I don't\nbelieve you"];
		tree[31] = ["#buiz08#Well... I was using my left paw, instead of my right paw..."];
		tree[32] = ["#buiz05#But two minutes is still pretty good for my left paw!!"];
		tree[33] = ["#buiz01#With my right paw it's still more like one minute... I'll practice hard, okay?"];
	}

	public static function sexyBefore3(tree:Array<Array<Object>>, sexyState:BuizelSexyState)
	{
		var count:Int = PlayerData.recentChatCount("buiz.randomChats.1.2");
		if (count % 2 == 0)
		{
			tree[0] = ["#buiz04#Some day, man! I promise you some day I'm gonna last more than like..."];
			tree[1] = ["#buiz06#...thirty seconds with you. Bweh-heh-heh-heh."];
			tree[2] = ["#buiz15#Alright, here we go! I'm gonna go forty seconds this time! Rrrgh! Forty! Thirty-nine! Thirty-eight! Thirty-seven!"];
			tree[3] = ["#buiz04#On second thought that's like... REALLY annoying with the counting. Bweh-heh! Sorry. I'll just do my best~"];
		}
		else
		{
			tree[0] = ["#buiz04#Some day, man! I promise you some day I'm gonna last more than like..."];
			tree[1] = ["%enterrhyd%"];
			tree[2] = ["%fun-alpha0%"];
			tree[3] = ["#RHYD03#HEY BUIZEL!!!!"];
			tree[4] = ["#buiz10#qhqzwxkqvhifukauiarx~"];
			tree[5] = ["%fun-alpha1%"];
			tree[6] = ["#buiz12#C'mon man what's wrong with you! I told you last time!"];
			tree[7] = ["#RHYD04#But I was just wondering if we-"];
			tree[8] = ["%fun-alpha0%"];
			tree[9] = ["#buiz13#Get out of here! Get lost! This is my turn! My turn! I earned this!"];
			tree[10] = ["%exitrhyd%"];
			tree[11] = ["#RHYD04#Roarr?? ...I'll just come back later."];
			tree[12] = ["#buiz11#Don't...! Just, go bug Abra or something."];
			tree[13] = ["%fun-alpha1%"];
			tree[14] = ["#buiz08#Sheesh. Okay. Phwoo."];
			tree[15] = ["#buiz06#Alright, so anyways <name>, where were we...?"];

			tree[10000] = ["%fun-alpha1%"];
		}
	}

	public static function random00(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#buiz04#Well if it isn't my favorite little uhh..."];
		tree[1] = ["#buiz06#My favorite... What are you anyways?"];
		tree[2] = ["#buiz02#Well uhh I'm glad you're back! Let's solve some puzzles."];
	}

	public static function random01(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#buiz05#Heyyyy back for more from your favorite Buizel right?"];
		tree[1] = ["#buiz04#Favorite little... aquatic rodent! Favorite water rat!"];
		tree[2] = ["#buiz12#Favorite ...filthy little water-logged... water rodent piece of shit!!"];
		tree[3] = ["#buiz13#Hey, that's offensive!! Bwark!!!"];
		tree[4] = [10, 20, 30];
		tree[10] = ["But...\nI didn't..."];
		tree[11] = [40];
		tree[20] = ["But it\nwas your..."];
		tree[21] = [40];
		tree[30] = ["But you\nsaid that..."];
		tree[31] = [40];
		tree[40] = ["#buiz02#...Ehhh I forgive you!"];
	}

	public static function random02(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#buiz02#Heck yeah! Time for more puzzles. Bwark!"];
		tree[1] = ["#buiz05#Why don't we-"];
		tree[2] = ["%entersand%"];
		tree[3] = ["#sand14#Hey what's up Buizel. Aw cool, doin' some puzzles eh? Mind if I watch?"];
		tree[4] = ["#buiz10#Oh uhh, I mean. Yeah it's cool if you watch, but... you're kinda blocking the whole... puzzle... part."];
		tree[5] = ["#sand06#Aww my bad."];
		tree[6] = ["%exitsand%"];
		tree[7] = ["#sand05#What if I watch from over here? This cool?"];
		tree[8] = ["#buiz05#I... guess that's fine? Anyway let's... let's start then!"];
	}

	public static function random03(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("buiz.randomChats.0.3");
		if (puzzleState._puzzle._pegCount == 3)
		{
			tree[0] = ["#buiz04#Oh hey <name>! ...Hmm, three peg stuff this time? Should be kinda easy."];
		}
		else if (puzzleState._puzzle._pegCount == 4)
		{
			tree[0] = ["#buiz03#Oh hey <name>! ...Ooh, four peg stuff this time? Might be kinda tricky."];
		}
		else if (puzzleState._puzzle._pegCount == 5)
		{
			tree[0] = ["#buiz06#Oh hey <name>! ...Whoa, five peg stuff this time? You really like to push yourself don't you..."];
		}
		else
		{
			tree[0] = ["#buiz03#Oh hey <name>! ...Huh, what kinda puzzle is this? Might be kinda tricky."];
		}
		if (count % 3 == 1)
		{
			tree[1] = ["#buiz05#But, don't forget if you get a little stuck you can always ask for help with that question mark button in the corner."];
			tree[2] = ["#buiz06#'Course I think uhh, I think Abra kinda sucks away some of your prize money when you do that. Huh. Let's see if we can get through this with no hints, I guess."];
		}
		else
		{
			tree[1] = ["#buiz02#Eh, why don't you show me how it's done. Maybe I'll learn something new."];
		}
	}

	public static function random10(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#buiz05#My Buizel brain can't always handle these tough puzzles!!"];
		tree[1] = ["#buiz02#But... I've still got my Buizel buoyancy. Nobody can beat that!"];
		tree[2] = [10, 20, 30];

		tree[10] = ["I wish I\nwas buoyant\nlike you!"];
		tree[11] = ["#buiz01#P'shaw!"];
		tree[12] = ["#buiz00#...I bet you say that to all the buoys."];
		if (!PlayerData.buizMale)
		{
			tree[12] = ["#buiz00#...I hear that from all the buoys."];
		}

		tree[20] = ["I think\nI'm more\nbuoyant!"];
		tree[21] = ["#buiz11#More... more buoyant!?"];
		tree[22] = ["#buiz13#Pshh I'm not talking to you! You're just a big... Buizel bullier."];
		tree[23] = ["#buiz12#...Says he's more buoyant!!"];

		tree[30] = ["Buizel...\nbuoyancy?\nWhat??"];
		tree[31] = ["#buiz05#You know, buoyancy!! ...means I float better!"];
		tree[32] = ["#buiz03#Kinda like how you... floated through your English classes apparently."];
		tree[33] = ["#buiz02#...Bweh-heh-heh!"];
	}

	public static function random11(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#buiz08#This next puzzle looks pretty hard, man."];
		tree[1] = ["#buiz07#Well I mean they ALL look pretty hard to me, I don't know how you even start these!!"];
		tree[2] = ["#buiz03#You're gonna get me naked right? I'm counting on you!"];
	}

	public static function random12(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#buiz08#This next puzzle looks-"];
		tree[1] = ["%enterrhyd%"];
		tree[2] = ["%fun-alpha0%"];
		tree[3] = ["#RHYD03#HEY BUIZEL!!!!"];
		tree[4] = ["#buiz07#gyabjgnergjsufnrbgag~"];
		tree[5] = ["%fun-alpha1%"];
		tree[6] = ["#buiz13#What's wrong with you!? Sneaking up on people and yelling in their ear!?!"];
		tree[7] = ["#RHYD10#Roar!!! I'm not... I'm not yelling! My voice just has a rich natural timbre."];
		tree[8] = ["#buiz13#Your so-called rich natural timbre registers on the Richter scale!!"];
		tree[9] = ["#buiz12#You can just like... tap me on the shoulder next time! Or whisper quietly!!"];
		tree[10] = ["#RHYD04#Groarr? Oh I get it, like a secret handshake!!"];
		tree[11] = ["#RHYD05#Yeah so, first I'll tap your shoulder. Then I'll whisper a code word like 'bananas' and wink three times."];
		tree[12] = ["#RHYD02#That'll be our code, which means you should come into the other room with me so I can yell in your ear!!!"];
		tree[13] = ["#buiz13#I don't WANT you YELLING IN MY EAR!!!"];
		tree[14] = ["#RHYD12#Don't want me yelling in your ear!?! ...Then what was the point of the code! Groarr!!!"];
		tree[15] = ["#buiz13#Just talk like a normal person!!"];
		tree[16] = ["%exitrhyd%"];
		tree[17] = ["#RHYD05#...This is getting too complicated! I'll just stick with yelling."];
		tree[18] = ["#buiz08#*sigh*"];
		tree[19] = ["%fun-shortbreak%"];
		tree[20] = ["#buiz09#Go ahead and get started without me, I'm going to see if we have any Tylenol."];

		tree[10000] = ["%alpha1%"];
	}

	public static function random13(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("buiz.randomChats.1.3");

		if (PlayerData.hasMet("luca") && PlayerData.hasMet("rhyd") && (count % 3 == 0))
		{
			tree[0] = ["#buiz04#Ehh? One second, I think I heard the door..."];
			tree[1] = ["%fun-alpha0%"];
			tree[2] = ["#buiz05#... ...?"];
			tree[3] = ["#luca02#Helloooooo! I've got your Effen Pizza~"];
			tree[4] = ["#buiz06#Oh! Uhhh yeah, one second. I think those are for Rhydon."];
			tree[5] = ["%fun-alpha1%"];
			tree[6] = ["#buiz15#RHYDOOOOONNN! PIZZAAAA!"];
			tree[7] = ["#RHYD03#Pizza-a-a-a-a-a-a! Don't leeeeave, pizzaaaaaaaa!"];
			tree[8] = ["#zzzz12#-thump- -thump- -THUMP- -THUMP- -THUMP- -THUMP- -thump- -thump-"];
			tree[9] = ["#buiz14#Gugahhhhh! ... ...Earthquake!!!"];
			tree[10] = ["#buiz04#...Uhh anyway, yeah... Second puzzle, right?"];

			tree[10000] = ["%fun-alpha1%"];
		}
		else
		{
			tree[0] = ["#buiz03#Heh, seriously, c'mon! How do you make these look so easy?"];
		}
	}

	public static function random20(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["%fun-nude1%"];
		tree[1] = ["#buiz04#What if like... these swim trunks were part of my body?"];
		tree[2] = ["#buiz02#What if I pulled a Lucario and was all, 'Sorry, this is what you get! This is what I'm like naked! Yep, naked with pants'"];
		tree[3] = ["#buiz05#..."];
		tree[4] = ["%fun-nude2%"];
		tree[5] = ["#buiz00#...Okay okay! I'm sorry, here. Here, you earned it."];
		tree[6] = ["#buiz04#Let's go, one more puzzle. That's not too much, right?"];
		tree[10000] = ["%fun-nude2%"];
	}

	public static function random21(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#buiz00#Ahh there we go,"];

		if (PlayerData.buizMale)
		{
			tree[1] = ["#buiz02#Feels nice to air out the ol' weinermobile. The uhh, mutton pole. The meat magnet."];
			tree[2] = [10, 20, 30];

			tree[10] = ["Weiner-\nmobile?"];
			tree[11] = ["#buiz03#Yeah you know!! The big hot dog truck!"];
			tree[12] = ["#buiz02#Good luck finding a tunnel big enough for this bad boy! Bweh-heheh!"];

			tree[20] = ["Mutton\nPole?"];
			tree[21] = ["#buiz03#Yeah you know, like a big rod of meat!"];
			tree[22] = ["#buiz04#How is that one confusing? You know you want my hard meat rod."];

			tree[30] = ["Meat\nMagnet?"];
			tree[31] = ["#buiz03#Meat magnet!! Like it's... a magnet for your meat! You want meat,"];
			tree[32] = ["#buiz06#If you want meat then you need to find it with my meat magnet!"];
			tree[33] = ["#buiz12#...Well okay maybe I made that one up!"];
		}
		else
		{
			tree[1] = ["#buiz02#Feels nice to air out the ol' fish factory. The uhh, beaver crease. The waffle wobbler."];
			tree[2] = [10, 20, 30];

			tree[10] = ["Fish\nfactory?"];
			tree[11] = ["#buiz03#Yeah you know!! The fish factory!! You get it right?"];
			tree[12] = ["#buiz02#Don't tell me you've never tasted a vagina before?? Bweh-heheh!"];

			tree[20] = ["Beaver\ncrease?"];
			tree[21] = ["#buiz03#Yeah you know, like it's my beaver... and it's also a crease!"];
			tree[22] = ["#buiz04#How is that one confusing? You know you want up in this beaver crease."];

			tree[30] = ["Waffle\nwobbler?"];
			tree[31] = ["#buiz03#Waffle wobbler!! Like it makes things wobble, you know? If you've got a waffle,"];
			tree[32] = ["#buiz06#If you've got a waffle then watch out, or I'll wobble it!"];
			tree[33] = ["#buiz12#...Well okay maybe I made that one up!"];
		}
	}

	public static function random22(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var rank:Int = RankTracker.computeAggregateRank();
		var maxRank:Int = RankTracker.computeMaxRank(puzzleState._puzzle._difficulty);

		tree[0] = ["#buiz06#So does this rank stuff mean anything to you? 'Cause I'm like, rank 13... And it looks like you're, hmm..."];
		if (rank == 0)
		{
			tree[1] = ["#buiz11#Rank zero? What? Does that even sound right? Maybe this thing is broken."];
			tree[2] = ["#buiz04#Or I guess maybe that just means you haven't even done any rank stuff yet? I don't really get any of this stuff."];
			tree[3] = ["#buiz02#I dunno, maybe talk to Abra or something? I'm just here to look cute and do cute Buizel stuff."];
			tree[4] = ["#buiz05#Here here, like check this one out."];
			tree[5] = ["#buiz07#Bwehhhhhhhhh~"];
		}
		else if (rank >= maxRank && rank != 65)
		{
			tree[1] = ["#buiz08#Rank " + englishNumber(rank) + "? So I dunno where I heard this, but I think someone told me you can't get past rank " + englishNumber(maxRank) + " on puzzles like this."];
			tree[2] = ["#buiz06#I mean so like, if rank is somethin' you care about then, I guess, go harder?"];
			tree[3] = ["#buiz02#Whatever it's just a stupid number right? I feel dumb even talking about it. Let's just knock this last puzzle out."];
		}
		else if (rank <= 16)
		{
			var englishRank:String = englishNumber(rank);
			tree[1] = ["#buiz05#Rank " + englishRank + "? Yeah I was rank " + englishRank + " once. I think I sometimes get distracted on these puzzles, and stuff like that'll drop your rank."];
			if (rank >= 13)
			{
				tree[1] = ["#buiz05#Rank " + englishRank + "? Yeah like that's about where I am. I think I sometimes get distracted on these puzzles, and stuff like that'll drop your rank."];
			}
			tree[2] = ["#buiz03#But whatever, there's no shame in being rank " + englishRank + "! Actually you know, I'm throwing a little rank " + (rank > 13 ? "13" : englishRank) + " party after this puzzle..."];
			tree[3] = ["#buiz00#...It's gonna be like... You? And me? And uhh... nobody else I guess. That's cool right? That's enough for a party. Bweh-heh-heh!"];
		}
		else
		{
			tree[1] = ["#buiz05#Rank " + englishNumber(rank) + "? Holy shit like, you actually know what you're doing huh!"];
			tree[2] = ["#buiz04#I mean I should have known, I've been watching you solve these. You always seemed fast but I didn't know you were THAT fast."];
			tree[3] = ["#buiz03#You know like-- promise not to tell anybody I told you this, but I heard Abra's only like rank ten??"];
			tree[4] = ["#buiz01#And I heard that uhhh, he makes us solve these puzzles 'cause he's too stupid to do them? So he wants to figure out how our brains work..."];
			tree[5] = ["#buiz00#Bweh-heh-heh-heh! Okay okay, seriously, he'll probably kick me out of the house if he hears that I told you that."];
			tree[6] = ["#buiz01#Let's um, alright. Bweheheh! Straight face. One more puzzle."];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 4, "he makes", "she makes");
				DialogTree.replace(tree, 4, "he's too", "she's too");
				DialogTree.replace(tree, 4, "he wants", "she wants");
				DialogTree.replace(tree, 5, "he'll probably", "she'll probably");
				DialogTree.replace(tree, 5, "he hears", "she hears");
			}
		}
	}

	public static function random23(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("buiz.randomChats.2.3");
		var puzzleCount:Int = 2 + Std.int(PlayerData.chatHistory.filter(function(s) { return s != null && StringTools.startsWith(s, "buiz"); } ).length * 0.6);
		if (puzzleCount > 10)
		{
			puzzleCount = Puzzle.getSmallestRewardGreaterThan(puzzleCount);
		}
		tree[0] = ["#buiz03#How many puzzles have we solved together now, <name>? ...Somethin' like " + englishNumber(puzzleCount) + "?"];
		if (count % 3 == 1)
		{
			if (puzzleCount < 10)
			{
				tree[1] = ["#buiz01#I mean, but somehow it feels like more than-"];
			}
			else if (puzzleCount < 20)
			{
				tree[1] = ["#buiz01#Well... I'm starting to lose count now, but-"];
			}
			else
			{
				tree[1] = ["#buiz01#Heh! What am I saying. It can't be that high-"];
			}

			tree[2] = ["%entermagn%"];
			tree[3] = ["#magn04#-MAGNE GREETINGS- Hello " + MagnDialog.BUIZ + ". Hello " + MagnDialog.PLAYER + "."];
			tree[4] = ["#buiz08#Oh uhh. Yeah. Hey Magnezone, what's up."];
			tree[5] = ["#magn05#... ..."];
			tree[6] = ["#buiz06#So did you need anything? or..."];
			tree[7] = ["#magn04#" + MagnDialog.MAGN + " is merely conducting routine surveillance. ...Please continue discussion."];
			tree[8] = ["#buiz06#So yeah, like I was saying <name>, It's been uhh..."];
			tree[9] = ["#magn05#... ..."];
			tree[10] = ["#buiz12#Look Magnezone, do you mind giving us a little privacy? We were kind of having a little moment before you barged in here."];
			tree[11] = ["#magn06#Moment? ...What sort of moment?"];
			tree[12] = ["#magn14#... ..." + MagnDialog.MAGN + " was told your sessions with " + MagnDialog.PLAYER + " were purely platonic in nature."];
			tree[13] = ["%fun-alpha0%"];
			tree[14] = ["%exitmagn%"];
			tree[15] = ["#buiz13#Just get out! Get outta here!! What are you doing? Geez!"];
			tree[16] = ["#magn10#^C^C^C^C^C^C^C^C"];
			tree[17] = ["%fun-alpha1%"];
			tree[18] = ["#buiz08#-sigh- Why do we gotta have all this stuff setup in, like, the living room? I wish Abra would move it somewhere private..."];
			tree[10000] = ["%fun-alpha1%"];
		}
		else
		{
			if (puzzleCount < 10)
			{
				tree[1] = ["#buiz01#I mean, but somehow it feels like more than that doesn't it? ...I guess they've just really stuck in my head."];
			}
			else if (puzzleCount < 20)
			{
				tree[1] = ["#buiz01#Well... I'm starting to lose count now, but it's been really fun playing with you. You've made me a very happy Buizel."];
			}
			else
			{
				tree[1] = ["#buiz01#Heh! What am I saying. It can't be that high can it? ...But still, it kinda feels like we're old friends doesn't it?"];
			}
			tree[2] = ["#buiz00#Heh! Listen to me getting all sentimental. Whatever, third puzzle right? Bwark!"];
			tree[3] = ["#buiz05#..."];
			tree[4] = ["#buiz02#Let's just like... knock this one out quick before things get all quiet. ...And weird. Bweh-heh-heh~"];
		}
	}

	public static function goFromThere(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["#buiz10#Oh hey! You're actually REAL!?! ...<name>, right?"];
			tree[1] = ["#buiz03#So yeah, Grovyle told me I might see some sort of like... remote controlled... levitating... glove thing, and that you might respond to <name>..."];
			tree[2] = ["#buiz06#...I was pretty sure he was just screwing with me but, well... *ahem*"];
			tree[3] = ["#buiz04#So I'm guessing you already know how these puzzles go, right? You solve a couple of these, and I guess I'm... supposed to take off all my clothes."];
			tree[4] = ["#buiz06#That's... kinda weird. Tell you what, how about we start with this first puzzle and we'll go from there."];

			if (!PlayerData.grovMale)
			{
				DialogTree.replace(tree, 2, "he was", "she was");
			}
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["%fun-nude0%"];
			tree[1] = ["#buiz04#Okay, okay. Just a shirt, right? I can live without a shirt. Kinda hot in here anyway."];
			tree[2] = ["%fun-nude1%"];
			tree[3] = ["#buiz00#Hey tell you what. How about I solve this next puzzle for a change... and you can take take off YOUR shirt! You know, take turns..."];
			tree[4] = [50, 40, 30, 20];

			tree[20] = ["Sure, sounds\nfair"];
			tree[21] = ["#buiz02#Hey awesome! Didn't think you'd actually go for it. Although, hmm..."];
			tree[22] = ["#buiz06#...Actually since you're not on camera... like... that wouldn't really do anything for me. Huh."];
			tree[23] = ["#buiz04#Nevermind, I didn't really think this through. Let's just keep it how it is."];
			tree[24] = [60];

			tree[30] = ["No, let's keep\nit this way"];
			tree[31] = ["#buiz02#Heh! You're just worried I'll upstage you on these puzzles, aren't you? I mean, I have had some practice."];
			tree[32] = ["#buiz03#But fine, whatever, I'll let you maintain your pride... and your puzzles. I'll go along with the stripping thing."];
			tree[33] = [60];

			tree[40] = ["Ugh you do not want\nto see me shirtless"];
			tree[41] = ["#buiz03#Oh, sorry officer. I didn't realize you were the \"what I want to see\" police."];
			tree[42] = ["#buiz02#What is it, you're a little hairy? ...A little out of shape? It's not like I'm in my bedroom doin' Buizel crunches every day. I'm sure you're fine."];
			tree[43] = [60];

			tree[50] = ["...Wait,\nwhat?"];
			tree[51] = ["#buiz12#I'm just saying, I don't see why I gotta do all the clothes-taking-off stuff? ...Just because I'm the one with the cute fuzzy belly, and like... swimmer's build..."];
			tree[52] = ["#buiz06#Wait, can I say that? \"Swimmer's build?\" Does that count? I mean ALL Buizels swim, I'm probably not even in the top 50%. Seems kinda cheating..."];
			tree[53] = ["#buiz02#Screw it! It counts! I'm changing my online dating profile to add \"swimmer's build\". Bweh-heh-heh~"];
			tree[54] = [60];

			tree[60] = ["#buiz08#So anyway, I guess if you solve this puzzle, I'm supposed to take my shorts off?? Phwooph. Well... uhhh..."];
			tree[61] = ["#buiz07#Can't say I've done anything like THAT before. But uhh, how about you start on this next puzzle and we'll go from there."];

			tree[10000] = ["%fun-nude1%"];
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["%fun-nude1%"];
			tree[1] = ["#buiz09#Ohh boy. Well here we go. I guess everybody gets naked on the internet at some point right? ...I mean you've done it haven't you?"];
			tree[2] = [40, 30, 20, 10];

			tree[10] = ["Yeah! Many\ntimes"];
			tree[11] = ["#buiz04#Wow that often? ...I guess like, it just gets a little easier each time huh? Alright, alright, here goes."];
			tree[12] = [50];

			tree[20] = ["Yeah, once\nor twice..."];
			tree[21] = ["#buiz06#Yeah, I mean-- I guess it's gotta be with someone you really trust. Gotta be safe, right?"];
			tree[22] = ["#buiz04#Well... if Grovyle trusts you, I guess I can trust you too, <name>. Here goes..."];
			tree[23] = [50];

			tree[30] = ["No, I haven't\nhad the chance..."];
			tree[31] = ["#buiz06#Haven't had the chance? Or... haven't had the courage? 'Cause like... Kinda feelin the pressure here..."];
			tree[32] = ["#buiz15#Okay! Okay! Just like a bandaid. One swift motion, I can do this! Bwaaaaaaaaah!!"];
			tree[33] = ["%fun-nude2%"];
			tree[34] = ["#buiz11#..."];
			tree[35] = [52];

			tree[40] = ["No, I'm not\nsome kind of\nweird pervert"];
			tree[41] = ["#buiz13#...HEY!"];
			tree[42] = ["#buiz12#...Weird perverts aren't the ones getting naked. ...That doesn't make me a pervert."];
			tree[43] = ["#buiz13#You know what weird perverts do? They like... Sit at home playing erotic flash games, manipulating other people into stripping for them! Yeah! C'mon."];
			tree[44] = ["#buiz12#Freakin'... Weird pervert pot, calling the weird pervert kettle black..."];
			tree[45] = ["#buiz15#Okay! Okay! Enough stalling. I can do this! ...Just like a bandaid, one swift motion! Bwaaaaaaaaah!!"];
			tree[46] = ["%fun-nude2%"];
			tree[47] = ["#buiz11#..."];
			tree[48] = [52];

			tree[50] = ["%fun-nude2%"];
			tree[51] = ["#buiz01#..."];
			tree[52] = ["#buiz05#...Yeah! Okay, that wasn't so bad."];
			tree[53] = ["#buiz08#Although you know... I guess if you solve THIS puzzle... *ahem*"];
			tree[54] = ["%fun-longbreak%"];
			tree[55] = ["#buiz06#Y'know... I'm gonna go, uhh. Take care of some Buizel stuff, I'll be back in a little while... ..."];

			tree[10000] = ["%fun-nude2%"];
			tree[10001] = ["%fun-longbreak%"];
		}
	}

	public static function waterShorts(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["#buiz05#So be honest, scale of 1-10, how great do these swim shorts look?"];
			tree[1] = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
			tree[10] = ["1"];
			tree[11] = ["#buiz13#A ONE!? C'mon man these are some grade A shorts."];
			tree[12] = ["#buiz12#You're just upset that they're blockin' your view of my meatballs."];
			if (!PlayerData.buizMale)
			{
				DialogTree.replace(tree, 12, "meatballs", "beaver crease");
			}
			tree[13] = [110];

			tree[20] = ["2"];
			tree[21] = ["#buiz13#A TWO!? C'mon man these are some grade A shorts."];
			tree[22] = [12];

			tree[30] = ["3"];
			tree[31] = ["#buiz03#Pshh!! You're just jealous."];
			tree[32] = ["#buiz04#Jealous of my awesome shorts."];
			tree[33] = [110];

			tree[40] = ["4"];
			tree[41] = [31];

			tree[50] = ["5"];
			tree[51] = [31];

			tree[60] = ["6"];
			tree[61] = ["#buiz03#Oh man! If you tried em on you'd give em a ten."];
			tree[62] = ["#buiz06#You'd-- you'd invent a number BIGGER than ten to-- okay, nevermind. Whatever. You get it."];
			tree[63] = [110];

			tree[70] = ["7"];
			tree[71] = [61];

			tree[80] = ["8"];
			tree[81] = [61];

			tree[90] = ["9"];
			tree[91] = ["#buiz00#Well... I mean they're still just shorts! But yes,"];
			tree[92] = ["#buiz01#Yes these are basically the best shorts in existence."];
			tree[93] = [110];

			tree[100] = ["10"];
			tree[101] = [91];

			tree[110] = ["#buiz05#Most Pokemon here had to struggle to meet Abra's dress code but me, this is what I wear every day!"];
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["#buiz05#You might be surprised that I don't swim naked but... you haven't felt these swim shorts!"];
			tree[1] = ["#buiz04#They kinda rub up against stuff when I swim, and... man when I climb out of the water,"];
			tree[2] = ["#buiz00#And the wet shorts are clinging to my fur, it... doesn't leave very much to the imagination."];
			tree[3] = ["#buiz01#..."];
			tree[4] = ["#buiz11#Oh wait, we were about to start a puzzle weren't we? Let's go!"];
			tree[5] = [10, 20];

			tree[10] = ["Yeah,\nlet's start!"];
			tree[20] = ["No, I\nwant to\nhear more!"];
			tree[21] = ["#buiz02#Heh c'mon we can talk more about my wet shorts after this puzzle,"];
			tree[22] = ["#buiz05#I won't forget."];
			tree[23] = ["%push1%"];
		}
		else
		{
			tree[0] = ["#buiz04#So anyway where was I..."];
			tree[1] = [20, 30];
			if (LevelIntroDialog.pushes[1] == 1)
			{
				tree[1].insert(0, 10);
			}

			tree[10] = ["You promised\nyou wouldn't\nforget!"];
			tree[11] = [21];

			tree[20] = ["You were telling\nme about your\nwet shorts"];
			tree[21] = ["#buiz02#Oh yeah!"];
			tree[22] = ["#buiz03#You sure are eager to talk about my shorts. I didn't know you had a water shorts fetish!"];
			tree[23] = [40, 50, 60, 70];

			tree[30] = ["We were about to\nsolve another\npuzzle"];
			tree[31] = ["#buiz02#Oh yeah! One last puzzle, let's do it."];
			tree[32] = ["#buiz06#...Waaaaaaaiiit a minute, I was telling you about my wet swim shorts!"];
			tree[33] = ["#buiz04#Sure are anxious to get back to the puzzles! What, you're not into water shorts?"];
			tree[34] = [40, 50, 60, 70];

			tree[40] = ["They're\ngreat"];
			tree[41] = ["#buiz05#I hope you're not just saying that to impress me. I mean I'm already naked and this is the last puzzle,"];
			tree[42] = ["#buiz00#But, if you REALLY are into water shorts..."];
			tree[43] = ["#buiz01#..."];
			tree[44] = ["#buiz11#Oh man ...You gotta solve this puzzle fast!!"];

			tree[50] = ["They're\nOK"];
			tree[51] = ["#buiz02#Trust me, I know I look great naked..."];
			tree[52] = ["#buiz00#...But some day you'll be begging me to get into a nice wet pair of shorts."];

			tree[60] = ["They're\ncomfy and\neasy to wear"];
			tree[61] = ["#buiz08#...I feel like we should have a battle for some reason!!"];
			tree[62] = ["#buiz10#Augh! Don't make eye contact!"];

			tree[70] = ["They're\ngross"];
			tree[71] = ["#buiz09#Wait, my shorts? My shorts are gross?"];
			tree[72] = ["#buiz08#...But they're so comfy!!"];
			tree[73] = ["#buiz09#...And fun to wear!"];
		}
	}

	public static function ruralUpbringing(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["#buiz05#So um, do gloves date? And get married and stuff?"];
			tree[1] = ["#buiz06#I mean, is there a... Mrs. Glove? Mr. Glove?"];
			tree[2] = [10, 20];

			tree[10] = ["Yes, I'm\nspoken for"];
			tree[11] = ["#buiz03#Oh cool! I'm still single, but you know, it was tough meeting people where I grew up..."];
			tree[12] = [30];

			tree[20] = ["No, I'm\nsingle"];
			tree[21] = ["#buiz03#Heh yeah, I was single for a long time too,"];
			tree[22] = ["#buiz04#It's just so tough to meet people nearby."];
			tree[23] = ["%push1%"];
			tree[24] = [30];

			tree[30] = ["#buiz05#I had hobbies and some great friends in real life, but nobody I was compatible with."];
			tree[31] = ["#buiz08#And I met great guys online I would date, but they were too far away!"];
			if (!PlayerData.buizMale)
			{
				DialogTree.replace(tree, 31, "guys", "girls");
			}
			tree[32] = ["#buiz04#Ehh I'm sure you know how it is. Anyway let's check out this first puzzle."];
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["#buiz08#Anyway yeah, it's a lot easier to meet guys now-- but back in the day? Yeesh."];
			if (!PlayerData.buizMale)
			{
				DialogTree.replace(tree, 0, "guys", "girls");
			}
			tree[1] = ["#buiz09#I mean it especially sucks growing up somewhere more rural."];
			tree[2] = ["#buiz03#They call it the sticks but, damned if I could find two pieces of wood to rub together."];
			if (!PlayerData.buizMale)
			{
				tree[2] = ["#buiz03#They call it the sticks so, I guess all that wood must have scared the lesbians away."];
			}
			tree[3] = ["#buiz02#C'mon it's a dick joke! It's funny."];
			tree[4] = ["#buiz05#Eh whatever! Let's try another puzzle."];
		}
		else
		{
			tree[0] = ["#buiz04#So anyway-- yeah, things got a lot better for me after I moved!"];
			tree[1] = ["#buiz05#Plus sometimes it's just nice to get to move into a new area, meet new people..."];
			if (LevelIntroDialog.pushes[0] == 1)
			{
				tree[1] = ["#buiz05#Maybe things will get better for you if you move too."];
			}
			tree[2] = [10, 20, 30];

			tree[10] = ["I might\nmove some\nday"];
			tree[11] = ["#buiz02#Well that's great! Turn some long-distance relationships into short distance ones."];
			tree[12] = ["#buiz08#And, turn some nearby friends into internet friends... I mean that part's tough sometimes. It's easy to lose touch."];
			tree[13] = ["#buiz05#Hopefully you can keep in contact with the people who matter most."];

			tree[20] = ["I'm happy\nwhere\nI am"];
			tree[21] = ["#buiz04#Well that's cool! As long as you're happy, that's what matters."];
			tree[22] = ["#buiz05#There's a lot of great places to live, and you know, some people think if they move somewhere new they'll be happier."];
			tree[23] = ["#buiz02#But people like you, you probably just... exude happiness no matter where you live. That's even better."];

			tree[30] = ["I'm stuck\nwhere\nI am"];
			tree[31] = ["#buiz09#Aww man, well, I don't know your exact living situation but I'm sorry."];
			tree[32] = ["#buiz08#Sometimes life's just about making the best of a bad situation, and trying to brighten the lives of people around you."];
			tree[33] = ["#buiz03#Maybe by virtue of being your awesome self, and improving your community, you can make your world a better place--"];
			tree[34] = ["#buiz05#So that your kids, or your friends' kids... or your friends' kids' kids' friends' kids can grow up in the kind of place you wish you had lived."];
		}
	}

	public static function movingAway(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["#buiz05#Oh hey <name>! Perfect timing!"];
			tree[1] = ["#buiz02#...Some of my old friends from back home were here visiting but... they just left. I'm yours for the night!"];
			tree[2] = [10, 30, 40, 20];

			tree[10] = ["Oh, from\nbefore you\nmoved?"];
			tree[11] = ["#buiz04#Yeah! Some of my old friends from like way back. Before I left for college."];
			tree[12] = [101];

			tree[20] = ["Oh, from\nbefore you\nmet Grovyle?"];
			tree[21] = [11];

			tree[30] = ["Oh, so I\nget you all\nto myself?"];
			tree[31] = ["#buiz04#Heh yeah! I mean I didn't want to blow them off, since I don't get to see them that often. And you know, we were really close back in high school."];
			tree[32] = [101];

			tree[40] = ["Oh, you\nshould have\nintroduced\nme!"];
			tree[41] = ["#buiz06#Heh well, they may not have been into the whole... naked... internet... disembodied hand... thing."];
			tree[42] = ["#buiz04#Besides, I thought I owed 'em some one on one time since I don't get to see them that often. And you know, we were really close back in high school."];
			tree[43] = [101];

			tree[101] = ["#buiz05#I know we talked briefly about my life growing up, and how the whole gay dating scene didn't really exist out in the country."];
			tree[102] = ["#buiz08#Don't get me wrong, there were a handful of us out there. But growing up LGBT in that kind of area..."];
			tree[103] = ["#buiz09#... ...It's a rough time, you know? You need all the support you can get."];
			tree[104] = ["#buiz06#Back then I didn't wanna cannibalize the short list of gay friends I had just to score a little HGS, if that makes any sense."];
			tree[105] = [140, 115, 130, 120, 110];

			if (PlayerData.buizMale)
			{
				tree[110] = ["Uhh..."];
				tree[111] = ["#buiz03#Oh uhhh HGS! Hot gay sex! ...Sorry, was that a local thing? ...I thought that was like... an everywhere thing. My bad."];
				tree[112] = [200];

				tree[115] = ["Hugs?"];
				tree[116] = ["#buiz03#Bweh! Heh! Yeah, that's it. I missed out on scoring some great hugs. Wow."];
				tree[117] = [142];

				tree[120] = ["HGS?"];
				tree[121] = [111];

				tree[130] = ["...Hot\ngay sex?"];
				tree[131] = ["#buiz03#Yeah exactly! Like you know, sex is sex, but like when you can count your gay friends on two paws..."];
				tree[132] = ["#buiz06#Getting burned by a bad relationship it's like... it's like losing a finger. I dunno, maybe I was just overly pessimistic. Whatever."];
				tree[133] = [200];

				tree[140] = ["...Hide the\nguy-sausage?"];
				tree[141] = ["#buiz02#Hide the... what!? Bweh-heh-heh-heh!! That's not what it means but... I kind of like that one better!"];
				tree[142] = ["#buiz04#But you get the idea. I don't feel like I missed out on much... Skipping a few nights of sex in exchange for some long term friendships, c'mon that's a no-brainer."];
				tree[143] = [201];
			}
			else
			{
				tree[110] = ["Uhh..."];
				tree[111] = ["#buiz03#Oh uhhh HLA! Hot lesbian action! ...Sorry, was that a local thing? ...I thought that was like... an everywhere thing. My bad."];
				tree[112] = [200];

				tree[115] = ["Cheap plane\ntickets?"];
				tree[116] = [111];

				tree[120] = ["HLA?"];
				tree[121] = [111];

				tree[130] = ["...Hot\nlesbian action?"];
				tree[131] = ["#buiz03#Yeah exactly! Like you know, sex is sex, but like when you can count your lesbian friends on two paws..."];
				tree[132] = ["#buiz06#Getting burned by a bad relationship it's like... it's like losing a finger. I dunno, maybe I was just overly pessimistic. Whatever."];
				tree[133] = [200];

				tree[140] = ["...Like, the\nsex position?"];
				tree[141] = [111];
			}

			tree[200] = ["#buiz04#Anyway I don't feel like I missed out on much. Skipping a few nights of sex in exchange for some long term friendships, c'mon that's a no-brainer."];
			tree[201] = ["#buiz00#Even if I fell a little behind on my ehh... gay studies back then... It's nothing I can't make up for by cramming now."];
			tree[202] = ["#buiz02#Bweh! heh! Anyway I'm all yours for the next hour or so, so let's see. What's going on with this first puzzle..."];

			if (!PlayerData.buizMale)
			{
				DialogTree.replace(tree, 101, "whole gay", "whole lesbian");
				DialogTree.replace(tree, 104, "of gay", "of lesbian");
				DialogTree.replace(tree, 104, "little HGS", "little HLA");
				DialogTree.replace(tree, 201, "ehh... gay", "ehh... lesbian");

				tree[4] = [90, 65, 80, 70, 60];
			}
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["#buiz04#Anyway things opened up for me a lot after I got accepted to college. It was a big college, and pretty far away from home."];
			tree[1] = ["#buiz02#And wow... college is crazy for that stuff. I mean, living on campus you're just meeting new people like, 24/7. ...It's where I met Grovyle!"];
			tree[2] = ["#buiz03#From there, Grovyle introduced me to all his other friends, and man. Good times. We were all pretty inseparable for those four years. It was, what, I guess six or seven of us?"];
			tree[3] = ["#buiz05#After our last class got out we'd just crash in someone's room for the afternoon, watch anime, play video games, that sorta stuff..."];
			tree[4] = ["#buiz04#So after graduation though, my folks were kinda expecting me to move back home. At least just for a little while, 'til I got financially stable. So I, well..."];
			tree[5] = ["#buiz06#...Told... them I found a job in the city and needed to move."];
			tree[6] = ["#buiz11#I mean, it wasn't a total lie! I did find a job in the city, it was just like... a few months in the future. I technically hadn't found it yet, but... I sorta knew it was coming!"];
			tree[7] = ["#buiz09#And uhh I like... did really need to move."];
			tree[8] = ["#buiz08#It was just more in a personal kinda way, not necessarily the whole, \"my job depends on it\" kinda way. That was just an easier one to explain to my folks."];
			tree[9] = [40, 30, 20, 10];

			tree[10] = ["Wow. ...Not\ncool, Buizel."];
			tree[11] = [50];

			tree[20] = ["Aww, you\nshould have\ntold the\ntruth."];
			tree[21] = [50];

			tree[30] = ["Well,\nthat's not\ntoo bad\nof a lie."];
			tree[31] = ["#buiz06#Yeah, but still... I know I shouldn't have lied, it's just..."];
			tree[32] = ["#buiz09#I'm totally a creature of habit. If I moved back home, I could sorta tell how things would turn out."];
			tree[33] = [51];

			tree[40] = ["Yeah?\nAnd what\nhappened\nnext?"];
			tree[41] = ["#buiz06#Don't worry, I'll get there. Just, wait, I think I should talk about why I lied first. 'Cause I felt bad about it, I don't usually do that kinda stuff."];
			tree[42] = ["#buiz09#I just knew that... well, I'm totally a creature of habit. If I ended up back home, I could sorta tell how things would turn out."];
			tree[43] = [51];

			tree[50] = ["#buiz09#Okay, I know I shouldn't have lied, it's just... I'm totally a creature of habit. If I moved back home, I could sorta tell how things would turn out."];
			tree[51] = ["#buiz08#I'd settle in, get comfortable living near my folks and with my old friends, and... man, I just knew in my gut it was the wrong place for me."];
			tree[52] = ["#buiz04#But yeah, I mean I'm glad I did what I did. If I hadn't moved in with Abra and Grovyle after college, I mean..."];
			tree[53] = ["#buiz03#Well for one I definitely wouldn't be here solving puzzles. ... ...Oh yeah! Speaking of which,"];
			tree[54] = ["#buiz05#Why don't we get this second puzzle out of the way? We can talk more after."];

			if (!PlayerData.grovMale)
			{
				DialogTree.replace(tree, 2, "all his", "all her");
			}
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["%fun-nude1%"];
			tree[1] = ["#buiz04#Anyway yeah, so I've still got mixed feelings about not moving back. I mean, I had some friends back there I kinda lost touch with."];
			tree[2] = ["#buiz06#But, I don't know if that was totally my fault either. Like, of the eight-or-so close friends I kept up with back in high school, only three of them moved back after college."];
			tree[3] = ["#buiz09#And like even if the four of us stayed friends, I dunno, they were gonna be busy starting new careers so it wasn't like they were gonna be free to hang out all the time."];
			tree[4] = ["#buiz08#Still though, even if leaving made total sense, it still made me feel bad. It felt like, hmm..."];
			tree[5] = ["#buiz09#...It sort of felt like I was abandoning a sinking ship, y'know? But... There were still people on that ship. ... ... -sigh-"];
			tree[6] = ["#buiz04#And I mean I've talked to some of 'em about if they wanted to join me out here. But eh, they don't seem interested."];
			tree[7] = ["#buiz06#...I guess maybe they're too comfortable. Or maybe they feel too guilty about leaving. ...It's probably a lot of things."];
			tree[8] = [60, 50, 20, 30, 40];

			tree[20] = ["(cough)\nShorts\n(cough)"];
			tree[21] = ["#buiz02#Shorts? What? ...Oh! ...Yeah! We're still doing the stripping thing aren't we. Bweh-heh-heh. My bad."];
			tree[22] = ["%fun-nude2%"];
			tree[23] = [100];

			tree[30] = ["Yeah, I'd\nprobably\nfeel too\nguilty"];
			tree[31] = ["#buiz05#Hmm, yeah, that's probably what it is. ...Sorta makes me feel better about not moving back, since I know I'd have gotten stuck there."];
			tree[32] = [100];

			tree[40] = ["Yeah,\nit's easy\nto get\ncomfortable"];
			tree[41] = ["#buiz09#Bweh. Comfortable. Yeah hmm, comfortable..."];
			tree[42] = ["#buiz10#... ...Wait, what are my shorts still doing on!?! You're supposed to remind me of this stuff!"];
			tree[43] = ["%fun-nude2%"];
			tree[44] = ["#buiz05#Okay, okay, well that's better."];
			tree[45] = [100];

			tree[50] = ["Well, it's\nnice you\nstill see\nthem once\nin awhile"];
			tree[51] = ["#buiz05#Yeah! Yeah, it feels good to keep in touch."];
			tree[52] = ["#buiz06#..."];
			tree[53] = [100];

			tree[60] = ["Well,\nit's their\nchoice to\nmake"];
			tree[61] = ["#buiz05#Heh, yeah. I guess you're right, I gotta respect their choice just like they respected mine."];
			tree[62] = [100];

			tree[100] = ["#buiz04#Anyway, sorry, I didn't really have a point with all that. Thanks for listening."];
			tree[101] = ["#buiz03#At least your mouse-clicky finger got some exercise today. Bweh! Heheheh~"];
		}
	}

	public static function denDialog(sexyState:BuizelSexyState = null, victory:Bool = false):DenDialog
	{
		var denDialog:DenDialog = new DenDialog();

		denDialog.setGameGreeting([
			"#buiz04#Oh hey <name>! ...Yeah if you're looking for the TV remote I don't know where it went either. Um. Maybe check the recliner?",
			"#buiz02#Oh wait, you're looking for me? Oh yeah! Sure! We can do stuff! Uhh, I got <minigame> set up if you wanted to do that."
		]);

		denDialog.setSexGreeting([
			"#buiz04#Uhh yeah, okay! A little less weird doing this kinda stuff back here now that we're, y'know. Not in the middle of the whole living room...",
			"#buiz03#Besides, I think I may have finally gotten used to the whole, \"naked on the internet\" thing. Bweh-heheh!",
			"#buiz00#Ahh, I was once so innocent...",
		]);

		denDialog.addRepeatSexGreeting([
			"#buiz01#Ah geez, again? You're kinda... pushing my Buizel meter into the red zone... Bweh-heheh",
			"#buiz06#No, not... I don't mean THAT meter, I mean like... My Buizel meter! It's a different meter.",
			"#buiz15#...You don't get to see my Buizel meter! That one's a secret."
		]);
		denDialog.addRepeatSexGreeting([
			"#buiz02#C'mon, let's go again! That last one didn't count, that was a quick one~"
		]);
		denDialog.addRepeatSexGreeting([
			"#buiz03#Bweh alright, yeah I'm ready. You finally learning how to defuse this little... Buizel bomb without setting it off early?",
			"#buiz00#Yeah, I think you're starting to learn! Just keep an eye on the timer and... don't cut the red wire, right? Simple stuff! Bweh-heh-heh~",
			"#buiz11#Actually wait, don't cut... don't cut any wires! ...If I see you brought cutting pliers, I'm not sticking around, alright?",
		]);
		denDialog.addRepeatSexGreeting([
			"#buiz01#Phwooph... Okay, I think I'm ready, <name>...",
			"#buiz02#Hey don't look at me that way! What, you think I'm the kind of " + (PlayerData.buizMale?"guy":"girl") + " who can go " + englishNumber(PlayerData.denSexCount + 1) + " times in a row, just on a whim? I gotta get mentally prepared!",
		]);

		denDialog.setTooManyGames([
			"#buiz03#Aww okay, sorry I think I gotta call it. Fun or not, I can't stay cooped up inside all day!",
			"#buiz02#But hey... You're a good friend, okay? Not everyone puts up the effort when it comes to initiating stuff like this, so thanks~"
		]);

		if (PlayerData.buizMale)
		{
			denDialog.setTooMuchSex([
				"#buiz01#Phwooh. Well my Buizel balls are officially empty. And that's something man,",
				"#buiz00#It takes a-- takes a special touch to empty these bad boys!",
				"#buiz05#You're gonna come visit me again, right?"
			]);
		}
		else {
			denDialog.setTooMuchSex([
				"#buiz01#Phwooh. Well my... Buizel area's been officially milked dry. And that's something man,",
				"#buiz00#It takes a-- takes a special touch to empty me like that!",
				"#buiz05#You're gonna come visit me again, right?"
			]);
		}

		var bestLo:String = englishNumber(PlayerData.denGameCount + 1);
		var bestHi:String = englishNumber(PlayerData.denGameCount * 2 + 1);
		denDialog.addReplayMinigame([
			"#buiz02#Bweh yeah, okay! Good game, <name>. I'm just glad I was kind of able to keep up with you.",
			"#buiz03#Did you want a rematch? Like, best " + bestLo + " out of " + bestHi + " or something? Or I mean there's other stuff we could do too."
		],[
			"Best " + bestLo + "\nout of " + bestHi + "!",
			"#buiz02#Bweh okay! Get ready for it, I'm bringing my B-game.",
			"#buiz06#That's like your A-game, it's just 'cause my name uhh... Whatever! ... ...You'll get it."
		],[
			"\"Other stuff\"\nsounds nice...",
			"#buiz02#Bweh! Yeah it sounds nice to me too~",
		],[
			"Actually\nI think I\nshould go",
			"#buiz08#Aw bwehhh! Really? ...Feels like you just got here.",
			"#buiz02#But hey... You're a good friend, okay? Not everyone puts up the effort when it comes to initiating stuff like this, so thanks~"
		]);
		denDialog.addReplayMinigame([
			"#buiz06#Okay, okay! Yeah... I think I'm starting to understand how this works.",
			"#buiz04#What do you think are you starting to get it? Did you want to go best " + bestLo + " out of " + bestHi + " or uhh, maybe call it and do something else?"
		],[
			"Best " + bestLo + "\nout of " + bestHi + "!",
			"#buiz02#Bweh-heh-heh yeah okay! It feels kinda nice to settle into the same game so we're not constantly learning something new, right?",
			"#buiz03#Alright, this next one counts... and this next one's for real. Bwark!",
		],[
			"Let's do\nsomething else",
			"#buiz02#Bweh-heh-heh, sure! It... was sorta hard to concentrate anyways, thinking about what was coming afterward..."
		],[
			"I think I'll\ncall it a day",
			"#buiz08#Aw bwehhh! Really? ...Feels like you just got here.",
			"#buiz02#But hey... You're a good friend, okay? Not everyone puts up the effort when it comes to initiating stuff like this, so thanks~"
		]);
		denDialog.addReplayMinigame([
			"#buiz03#Yeah, alright, well played, well played! ...I think the next game'll go differently, trust me.",
			"#buiz04#Or I could just show you, if you wanted to go like... best " + bestLo + " out of " + bestHi + " or something. Or is this enough games?"
		],[
			"Best " + bestLo + "\nout of " + bestHi + "!",
			"#buiz02#Bweh! Yeah alright, I'm for that. Let's see how this next one goes~"
		],[
			"That's enough\ngames, let's do\nsomething new",
			"#buiz02#Yeah alright! Let's make some room. I gotta feeling we'll want a little extra floor space for... something new. Bweh-heh-heh~"
		],[
			"Hmm, I\nshould go",
			"#buiz08#Aw bwehhh! Really? ...Feels like you just got here.",
			"#buiz02#But hey... You're a good friend, okay? Not everyone puts up the effort when it comes to initiating stuff like this, so thanks~"
		]);

		denDialog.addReplaySex([
			"#buiz01#Wowww, that was niiiiiice. Bwark~ I could use a glass of water. ...And... maybe a pregnancy test.",
			"#buiz02#I know, I KNOW. ...But you can never be too sure! Bweh-heh-heh. ...You want anything while I'm up?"
		],[
			"I want... a\nBuizel sandwich!",
			"#buiz03#A Buizel sandwich!?! Open-faced, maybe, I mean, there's only one of you...",
			"#buiz04#Okay okay, just sit tight.",
		],[
			"Ahh, I should\nprobably go",
			"#buiz08#Go? Awww, alright, no sweat. Thanks for uhh...",
			"#buiz04#...You're a good friend, okay? Not everyone puts up the effort when it comes to initiating stuff like this, so just... Thanks~",
		]);
		denDialog.addReplaySex([
			"#buiz04#Hah... Sorry... Am I usually that quick? That felt quick even for me...",
			"#buiz06#I'm gonna grab a little snack. You're sticking around, right?",
		],[
			"Yeah! I'll\nstick around",
			"#buiz02#Bweh! Thank goodness. That woulda been sort of an awkward one to go out on.",
			"#buiz05#I'll be right back after I grab something. Let's make this next one count~",
		],[
			"Oh, I think\nI'll head out",
			"#buiz08#Head out? Awww, alright, no sweat. Thanks for uhh...",
			"#buiz04#...You're a good friend, okay? Not everyone puts up the effort when it comes to initiating stuff like this, so just... Thanks~",
		]);
		denDialog.addReplaySex([
			"#buiz00#That was... wow, bwark~ I think I'm just gonna, phwoo...",
			"#buiz05#Y'know, I should stretch a little... I'm getting a little cramp from being on my butt so long. How about you, are you doing alright?",
			"#buiz03#...Maybe you should stretch too. Carpal tunnel, man! It'll sneak up on you."
		],[
			"Oh, I'm\ngood!",
			"#buiz02#Yeah okay! Of course you are, <name>. I don't think I've ever heard you complain about being tired...",
			"#buiz05#You're not tired are you? Shake your hand twice if you're tired!",
			"#buiz03#... ...Bweh yeah, you don't look that tired.",
		],[
			"Hmm yeah, I\nshould take\na break...",
			"#buiz08#Take a break? Awww, alright, that's probably a good idea. Hey, you're um...",
			"#buiz04#...You're a good friend, okay? Not everyone puts up the effort when it comes to initiating stuff like this, so just... Thanks~",
		]);

		return denDialog;
	}

	public static function cursorSmell(tree:Array<Array<Object>>, sexyState:BuizelSexyState)
	{
		var count:Int = PlayerData.recentChatCount("buiz.cursorSmell");

		if (count == 0)
		{
			tree[0] = ["#buiz00#Oh man! So... (sniff sniff) What are you ehh... (sniff)"];
			tree[1] = ["#buiz07#Ahhh jeez... ...Not... Not Grimer... Oh <name>..."];
			tree[2] = ["#buiz09#I get he's nice and all and you wanna be everyone's friend but... You don't smell the things we smell."];
			tree[3] = ["#buiz10#...It's like, ugghhh.... It smells like the time Spinda got drunk and threw up on the sauna rocks..."];
			tree[4] = ["%fun-shortbreak%"];
			tree[5] = ["#buiz07#Just... Just give me a second, I can power through this. I'll be back in a... -hurrk-"];

			tree[10000] = ["%fun-shortbreak%"];

			if (!PlayerData.grimMale)
			{
				DialogTree.replace(tree, 2, "he's nice", "she's nice");
			}
		}
		else
		{
			tree[0] = ["#buiz00#Oh man! So... (sniff sniff) What are you ehh... (sniff)"];
			tree[1] = ["#buiz11#Really <name>? ...Grimer again? Ulllggghhh... Are you like, mad at me or something?"];
			tree[2] = ["%fun-shortbreak%"];
			tree[3] = ["#buiz07#...Whatever it is, I'm sorry okay? You win. Just... for the love of god... -hurrk- I'll be back in a second..."];

			tree[10000] = ["%fun-shortbreak%"];
		}
	}

	public static function snarkyHugeDildo(tree:Array<Array<Object>>)
	{
		tree[0] = ["#buiz06#Uhhh, no thanks. ...My friends showed me that Mr. Hands video, and... ...yeah."];
		tree[1] = ["#buiz04#... ...I'd like to minimize the risk of dildos being mentioned in my obituary."];
		tree[2] = ["#buiz03#Y'know, just in case my parents read it or whatever."];
	}
}
