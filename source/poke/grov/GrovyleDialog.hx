package poke.grov;

import MmStringTools.*;
import PlayerData.hasMet;
import flixel.FlxG;
import minigame.tug.TugGameState;
import poke.hera.HeraShopDialog;
import kludge.BetterFlxRandom;
import openfl.utils.Object;
import minigame.GameDialog;
import minigame.MinigameState;
import minigame.scale.ScaleGameState;
import minigame.stair.StairGameState;
import puzzle.ClueDialog;
import puzzle.PuzzleState;
import puzzle.RankTracker;

/**
 * Grovyle is canonically female. Grovyle met Abra and Buizel in college, where
 * they were randomly paired as roommates. When Grovyle came to college, she
 * already had several friends from high school. So, she invited Abra into her
 * social circle.
 * 
 * After Grovyle graduated, Abra bought a four-bedroom house which the two of
 * them now share with Buizel and Sandslash.
 * 
 * Grovyle is sort of the social lynchpin of the group. If it wasn't for
 * Grovyle, Abra would have never met Buizel and Sandslash, Kecleon wouldn't
 * have found out about the monster mind experiment to tell Smeargle. Pretty
 * much all of Abra's friends are through Grovyle.
 * 
 * After college, Grovyle could sense Abra was spending more and more time
 * isolated in her room and didn't seem very happy. She tried to reach out to
 * Abra but couldn't get her to open up or even to admit anything was wrong.
 * 
 * Grovyle's polyamorous, meaning she doesn't believe romantic relationships
 * need to be exclusively between two people.
 * 
 * Beyond polyamory, Grovyle in general doesn't like feeling tied down by
 * definitions, labels and commitments. She's technically bisexual but she
 * dislikes that label.
 * 
 * Grovyle loves and excels at puzzles, including Kakuro, Nurikabe, and
 * Heyawake. She also has a good head for games, but tends to crumble under
 * pressure.
 * 
 * Abra used to be responsible for Monster Mind tutorials, but Grovyle does
 * them now because she's more patient with people.
 * 
 * As far as minigames go, Grovyle is abysmal at all of them except for the
 * stair game, at which she's surprisingly confident. Although she adopts a
 * rather naive strategy, going for the most obvious move and often ignoring
 * what a smart opponent would do to counter her.
 * 
 * ---
 * 
 * When writing dialog, I think it's good to have an inner voice in your head
 * for each character so that they behave and speak consistently. Grovyle's
 * inner voice was Stephen Fry.
 * 
 * Vocal tics: Hah! Heheheh. Errr... Errrm...
 * 
 * Exceptional at puzzles (rank 36)
 */
class GrovyleDialog
{
	public static var AWFUL_NAMES:Array<String> = ["beenf", "bilm", "blalp", "blangh", "blemp", "blulg", "blumbo", "brelb", "calk",
			"cank", "chulg", "clempo", "clug", "dildy", "dilfo", "dronky", "drumbo", "dulfy", "dunt", "flant", "flulk",
			"flunto", "frabbo", "fraldy", "frampo", "frent", "frilp", "fruk", "frunk", "glap", "glulg", "goompy",
			"grack", "grambo", "grilb", "grulm", "grunghy", "gruspy", "grust", "gusp", "kralp", "krulf", "krunty",
			"kump", "lung", "mald", "malm", "molky", "mulk", "musp", "peempo", "pheb", "phimpy", "pilb", "plumb",
			"poot", "pugho", "pund", "rilbo", "skindo", "sklong", "sklunt", "skod", "skrem", "skrod", "skrugh",
			"skrust", "skulby", "skusp", "slalpo", "slek", "sloolf", "slutch", "smalf", "smelb", "smotch", "smundo",
			"snendo", "snolp", "snoomp", "snulb", "snulgy", "snungo", "snuspy", "splap", "splob", "splobby", "spluch",
			"spomp", "spruck", "spulg", "spump", "thlag", "thlamp", "thrung", "thrunt", "thub", "tuspo", "wunfy",
			"zitt"];

	public static var prefix:String = "grov";
	public static var sexyBeforeChats:Array<Dynamic> = [sexyBefore0, sexyBefore1, sexyBefore2, sexyBefore3];
	public static var sexyAfterChats:Array<Dynamic> = [sexyAfter0, sexyAfter1, sexyAfter2, sexyAfter3];
	public static var sexyBeforeBad:Array<Dynamic> = [sexyBadStealDick, sexyBadStealBalls, sexyBadStealAss, sexyBadLeftFoot, sexyBadRightFoot, sexyBadHurryDick, sexyBadHurryBalls, sexyBadHurryAss, sexyBadHurryFeet, sexyBadMissedYou];
	public static var sexyAfterGood:Array<Dynamic> = [sexyAfterGood0, sexyAfterGood1];
	public static var fixedChats:Array<Dynamic> = [bisexual, ramen, aboutAbra];
	public static var randomChats:Array<Array<Dynamic>> = [
				[random00, random01, random02, random03, random04],
				[random10, random11, random12, random13],
				[random20, random21, random22, random23]];

	public static function getUnlockedChats():Map<String, Bool>
	{
		var unlockedChats:Map<String, Bool> = new Map<String, Bool>();

		unlockedChats["grov.fixedChats.2"] = !PlayerData.isAbraNice(); // "aboutAbra" chat only works if abra's grumpy

		unlockedChats["grov.randomChats.0.3"] = hasMet("buiz");
		unlockedChats["grov.randomChats.0.4"] = hasMet("smea");
		return unlockedChats;
	}

	public static function clueBad(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var clueDialog:ClueDialog = new ClueDialog(tree, puzzleState);
		clueDialog.setGreetings(["#grov04#Ah yes, that <first clue> makes things tricky. Do you see where you went wrong?",
								 "#grov04#Ah I see what you did, this one's tricky. Do you see what's wrong with that <first clue>?",
								 "#grov04#Oh dear, yes. I didn't notice that <first clue>! Do you see how to fix your answer?",
								]);
		if (clueDialog.actualCount > clueDialog.expectedCount)
		{
			clueDialog.pushExplanation("#grov06#So yes, that <first clue> has <e hearts>, which means when we compare it to your answer, there should be <e bugs in the correct position>, yes?");
			clueDialog.fixExplanation("clue has zero", "clue doesn't have any");
			clueDialog.fixExplanation("should be zero", "shouldn't be any");
			clueDialog.pushExplanation("#grov08#But if we count the number of <bugs in the correct position>, we can see there's actually <a>.");
			clueDialog.pushExplanation("#grov04#In other words you appear to be on the right track, but the correct answer has fewer <bugs in the correct position> when comparing it to the <first clue>.");
			clueDialog.pushExplanation("#grov02#Go ahead, try and fix your answer and if you need more help-- that's what that question mark button in the corner is for. Don't be shy!");
		}
		else
		{
			clueDialog.pushExplanation("#grov06#So yes, that <first clue> has <e hearts>, which means when we compare it to your answer, there should be <e bugs in the correct position>, yes?");
			clueDialog.pushExplanation("#grov08#But if we count the number of <bugs in the correct position>, we can see there's actually <a>.");
			clueDialog.fixExplanation("there's actually zero", "well... there actually aren't any! Goodness.");
			clueDialog.pushExplanation("#grov04#In other words you appear to be on the right track, but the correct answer has more <bugs in the correct position> when comparing it to the <first clue>.");
			clueDialog.pushExplanation("#grov02#Go ahead, try and fix your answer and if you need more help-- that's what that question mark button in the corner is for. Don't be shy!");
		}
	}

	static private function newHelpDialog(tree:Array<Array<Object>>, puzzleState:PuzzleState, minigame:Bool=false):HelpDialog
	{
		var helpDialog:HelpDialog = new HelpDialog(tree, puzzleState);
		helpDialog.greetings = [
			"#grov04#Ah yes, hello! Did you need me for something?",
			"#grov04#Oh, hello! Did you need my help for anything?",
			"#grov04#Hmm yes, were you looking for me? Did you need assistance?"];

		helpDialog.goodbyes = [
			"#grov02#Well then, hope to see you again soon!",
			"#grov02#Come back soon! I do so enjoy a good puzzle.",
			"#grov02#Very well! Until our paths cross again~"
		];

		helpDialog.neverminds = [
			"#grov06#Now about this puzzle... Hmmm...",
			"#grov06#Yes yes, we mustn't get distracted... Hmmm, hmm....",
			"#grov06#Yes, back to the puzzle... Perhaps that third clue...? ...Hmmm...",
		];

		helpDialog.hints = [
			"#grov03#Ah, I'll run and see if Abra feels like dispensing any hints today. One moment...",
			"#grov03#Abra likes dealing with hints personally. I suppose he wants to make sure we're not simply giving out the answers! I'll run and fetch him...",
			"#grov03#I'll just go double-check that Abra's alright with me giving you a small hint. Just a moment..."
		];

		if (!PlayerData.abraMale)
		{
			helpDialog.hints[1] = StringTools.replace(helpDialog.hints[1], "suppose he", "suppose she");
			helpDialog.hints[1] = StringTools.replace(helpDialog.hints[1], "fetch him", "fetch her");
		}

		if (minigame)
		{
			helpDialog.neverminds = [
				"#grov06#Yes yes, we mustn't get distracted... Hmmm, hmm....",
				"#grov06#Yes, back to the minigame... Now where were we? ...Hmmm...",
			];
		}
		return helpDialog;
	}

	public static function help(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var helpDialog = newHelpDialog(tree, puzzleState);
		helpDialog.help();
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
		if (PlayerData.name == null)
		{
			helpDialog.addCustomOption("Grovyle,\nit's me!\nRemember?", "%jumpto-rememberme%");
		}
		helpDialog.addCustomOption("Can you\nexplain\nthat again?", "%jumpto-startover%");
	}

	public static function gameDialog(gameStateClass:Class<MinigameState>)
	{
		var g:GameDialog = new GameDialog(gameStateClass);

		g.addSkipMinigame(["#grov05#Ah! Not feeling it today, are you?", "#grov02#Very well, let's try something else instead~"]);
		g.addSkipMinigame(["#grov04#Ah, very well! These minigames are meant to be a fun little treat... Not a mandatory chore.", "#grov02#Let's find some sort of activity that's more, hmm... <name>-worthy, eh?"]);

		g.addRemoteExplanationHandoff("#grov06#So to play this game, first you... Hmmm... You know what, let me see if I can find <leader>.");

		g.addLocalExplanationHandoff("#grov06#Why don't you explain this one, <leader>?");

		g.addPostTutorialGameStart("#grov03#Does that clear things up? Shall we begin?");

		g.addIllSitOut("#grov06#Can you perhaps play this game in my absence? I, hmm... I just think you'd have more fun playing against opponents of your own skill level.");
		g.addIllSitOut("#grov02#Perhaps I'll just watch this time. We can square off once you get some practice in, <name>.");

		g.addFineIllPlay("#grov10#...Ah! Well... If you insist, but... Well I'll do what I can to keep things fun for you.");
		g.addFineIllPlay("#grov10#Well! Far be it from me to turn down a challenge, but... Well... Good luck! Hmm...");

		g.addGameAnnouncement("#grov04#Mmmm, yes. It's <minigame>.");
		g.addGameAnnouncement("#grov04#Which one is it this time? Ah! <Minigame>.");
		g.addGameAnnouncement("#grov04#So, do you have any strong feelings about <minigame>? It looks like that's what we'll be playing today.");

		g.addGameStartQuery("#grov05#Very well, shall we begin?");
		if (PlayerData.denGameCount == 0)
		{
			g.addGameStartQuery("#grov05#That's alright, isn't it? Shall we begin?");
			g.addGameStartQuery("#grov05#How do you feel about this one? Should we start?");
		}
		else
		{
			g.addGameStartQuery("#grov02#This should go differently now that I've had some practice! Are you ready to begin, <name>?");
			g.addGameStartQuery("#grov05#Here we go! I'm going to seriously focus this time. ...Are you ready?");
			g.addGameStartQuery("#grov04#Ah! It's so nice getting some practice sessions against someone other than, well, Abra. ...I'm rather enjoying this! Should we continue?");
		}

		g.addRoundStart("#grov04#Ah, time for the next round. Whenever you're ready!", ["I'm ready\nnow!", "Let's go,\nGrovyle!", "This is\nso fun~"]);
		g.addRoundStart("#grov04#So unless I lost count... I believe this is round <round>?", ["Ehh,\nwhatever", "That doesn't\nsound right...", "Let's start!"]);
		g.addRoundStart("#grov04#Whenever you're ready for round <round>!", ["Hold on just\na moment", "Don't wait up\non my account", "I was born ready"]);
		g.addRoundStart("#grov04#I suppose we should start round <round>?", ["Ugh...", "Yep, let's\ngo", "Just a\nsecond..."]);

		g.addRoundWin("#grov02#Easy peasy! ...You're doing well too, <name>. You'll get the hang of it.", ["This is\ntricky", "You're really\nfast!", "Gwuph..."]);
		g.addRoundWin("#grov02#Hooray! Everything's coming up Grovyle~", ["I'll get\nyou!", "Ugh,\npainful", "Indeed"]);
		g.addRoundWin("#grov03#Why, would you look at that! Grovyle got one~", ["Good job\nbuddy", "That was\ntough", "My goodness..."]);
		if (PlayerData.grovMale) g.addRoundWin("#grov03#Ahh see, I'm good at pointless logic puzzles AND pointless minigames! A modern day renaissance man~", ["Get a\nlife", "Ha ha ha ha", "Oh, these\naren't pointless"]);
		if (!PlayerData.grovMale) g.addRoundWin("#grov03#Ahh see, I'm good at pointless logic puzzles AND pointless minigames! A modern day renaissance woman~", ["Get a\nlife", "Ha ha ha ha", "Oh, these\naren't pointless"]);

		if (gameStateClass == ScaleGameState) g.addRoundLose("#grov06#Good heavens I'm rubbish at this. How did I overlook that answer...", ["Nobody's\nperfect", "That one was\ntricky", "Aww, cheer\nup buddy"]);
		if (gameStateClass == TugGameState) g.addRoundLose("#grov06#Good heavens I'm rubbish at this. How did I miscount that...", ["Nobody's\nperfect", "It's a lot\nto keep\ntrack of", "Aww, cheer\nup buddy"]);
		if (gameStateClass == ScaleGameState) g.addRoundLose("#grov07#How is everybody else SO quick at this!?! ...Especially you, <leader>...", ["These puzzles are\npretty intuitive", "Wow, you\nreally suck...", "Practice makes\nperfect"]);
		if (gameStateClass == TugGameState) g.addRoundLose("#grov07#How are SO quick at this, <leader>!?! I don't even have time to formulate a strategy...", ["It seems\npretty intuitive", "Wow, you\nreally suck...", "Practice makes\nperfect"]);
		g.addRoundLose("#grov08#<leader>, perhaps you can give me some pointers after this? ...I want to be able to play, too...", ["Yeah,\nme too...|Let's have a private\ntutoring session", "Aw, you're\ndoing great", "You're a\nlost cause"]);
		g.addRoundLose("#grov10#Err wait, is the round over already!? ...Did I win that one?", ["No, you did\nnot win...", "How are you so\nbad at this...", "Ummm..."]);
		g.addRoundLose("#grov07#I'm... I'm so lost... Can we play something different next time?", ["It's tough,\nisn't it", "My\ngoodness...", "Sure, we'll try\nsomething else"]);

		g.addWinning("#grov02#I've got a riddle for you! What's green, has two thumbs, and is in first place?", ["\"This\nguy?\"", "Idiot, you don't\nhave thumbs", "You forgot\n\"horny\""]);
		g.addWinning("#grov02#I'm finally beginning to get a knack for this! Heheheh~", ["Too\ngood!", "How did this\nhappen?", "You just got lucky,\nthat's all"]);
		g.addWinning("#grov02#Is this... Is this a dream? Am I finally going to win a minigame?", ["You deserve\nto win!", "I'm letting\nyou win", "Ughh...."]);
		g.addWinning("#grov06#Oof, this is a bit of a trial by fire for you, isn't it <name>? ...Why, perhaps we're both weak to fire!", ["I'll go get\nsome matches...", "Go easy\non me!", "Ack..."]);
		if (gameStateClass == ScaleGameState || gameStateClass == TugGameState) g.addWinning("#grov02#Can I stay in first place for just one more round? ...Please? Just let me have this!", ["You gotta earn\nfirst place!", "That's not how\nthis works", "One more\nround..."]);
		if (gameStateClass == StairGameState) g.addWinning("#grov02#Hmm, well I have my chest... But where are your chests? Did you leave them somewhere?", ["Tsk, you\npesky weed...", "You're so\ngood at this!", "I was letting\nyou get a\nhead start"]);

		g.addLosing("#grov07#Can we... Go back to logic puzzles next? This is too much for me...", ["This seems\neasier", "We ALWAYS do\nlogic puzzles", "Sure, we'll go back\nto logic puzzles"]);
		g.addLosing("#grov06#-sigh- Well, I'm starting to understand this game, but... I think it's too late for me to catch up.", ["You're pretty\nfar back there", "You could still\ncatch up", "Maybe next\ngame"]);
		g.addLosing("#grov04#Well, win or lose... I'm still having fun playing with you, <name>!", ["It's kind of\none-sided though...", "Yeah! You're fun\nto play with", "Heh, you'll win\nsome day"]);
		if (gameStateClass == ScaleGameState || gameStateClass == StairGameState) g.addLosing("#grov05#Don't mind me, I'm just having fun in the rear...", ["Wish you'd have\nfun in my rear~", "Oh I'm going to have\nfun in your rear later", "Nope, too\neasy"]);
		g.addLosing("#grov03#So <leader>... What's it like up there in first place?", ["Looks\nlonely|Kind of\nlonely", "We can still\ncatch up|What's that? I can't hear you\nall the way back there", "I'm having more fun\nback here with you|It's nice,\nthank you~"]);

		g.addPlayerBeatMe(["#grov03#Some day... Some day I promise you I'll learn to play this game properly. Until that day comes though, well...", "#grov02#...It's still a joy to play it with you, err... improperly. Hah! Heheheheh~", "#grov06#On a more serious note though, we should endeavor to find you a more suitable opponent..."]);
		if (gameStateClass == ScaleGameState) g.addPlayerBeatMe(["#grov01#Goodness! Chalk up another humiliating loss for Grovyle... Hah! Heheheheh~", "#grov03#These fast-paced games are always a bit overwhelming for me, I'm more of a... Tea and chess kind of lizard, if you catch my drift.", "#grov04#Ah well! Good game~"]);
		if (gameStateClass == StairGameState) g.addPlayerBeatMe(["#grov01#Goodness! Chalk up another humiliating loss for Grovyle... Hah! Heheheheh~", "#grov03#I'm usually good at these sorts of slower-paced cerebral games, but you... Well, you're on a bit of another level, <name>.", "#grov04#Ah well! Good game~"]);

		g.addBeatPlayer(["#grov02#Hah! I just knew I'd win some day if I was patient enough...", "#grov00#You played well! We'll have a rematch, alright? See if lightning strikes twice... Hah! Heheheh~"]);
		g.addBeatPlayer(["#grov02#Oh my! I wasn't sure I'd ever actually win something like this...", "#grov03#I hope you're still satisfied with your <money>, that's a bit of a consolation prize, isn't it? I mean, you can't be too disappointed.", "#grov05#Let's play again soon! I'm sure you'll win next time."]);
		g.addBeatPlayer(["#grov02#<nomoney>Oh my! I wasn't sure I'd ever actually win something like this...", "#grov08#I'm sorry you had to walk away without any winnings, too! I hope that wasn't entirely my fault...", "#grov06#Anyways, let's play again soon! I'm sure you'll win next time."]);

		g.addShortWeWereBeaten("#grov06#My goodness, <leader> was out for blood this time! ...<leaderHe> doesn't usually take this game quite so seriously...");
		g.addShortWeWereBeaten("#grov05#Well, it was a pleasure playing with you! We'll get <leaderhim> next time~");

		g.addShortPlayerBeatMe("#grov05#Ahh, well played, well played! We'll have another rematch once I get some practice...");
		g.addShortPlayerBeatMe("#grov04#You've got a real knack for this, <name>! I'll have to practice more...");
		g.addShortPlayerBeatMe("#grov05#Congratulations <name>! I knew you could do it~");

		g.addStairOddsEvens("#grov06#Let's throw odds and evens to see who goes first. You'll go first if it's odd, and I'll go first if it's even. Alright?", ["Yep", "Let's\ndo it", "Okay, so\nI'm odds..."]);
		g.addStairOddsEvens("#grov06#Let's determine the start player with odds and evens. If it's odd you go first, if it's even I go first. Ready?", ["I get it", "Alright", "If it's\nodd, I go\nfirst..."]);

		g.addStairPlayerStarts("#grov02#Ah! So that means you get to start. Ready to throw for your first turn?", ["Hmm,\nsure...", "Ha, I knew\nyou'd pick\nthat!", "I'm ready!"]);
		g.addStairPlayerStarts("#grov02#Oh dear, it's odd! That means you go first. Shall we begin?", ["I guess?", "Okay!", "You're going\ndown, Grovyle"]);

		g.addStairComputerStarts("#grov02#Hah! So I get to go first, do I? Very well, let's see what I can do on my first turn... Are you ready?", ["Yep,\nready!", "Hmph!\nDid you\ncheat?", "I think\nso..."]);
		g.addStairComputerStarts("#grov02#Hah, it's even! That means I get to start. ...Are you ready to throw for my first turn?", ["Yeah!", "I should\nget to\ngo first...", "Sure,\nI'm ready"]);

		g.addStairCheat("#grov03#Well... Let's try that again, but this time throw your dice when I do. Alright?", ["I didn't\nmean to\ndo that...", "Ehh,\nwhatever", "Oops!\nOkay"]);
		g.addStairCheat("#grov06#Let's err, try that again shall we? You need to throw your dice a little earlier...", ["One more\ntime!", "Did I do\nsomething\nwrong?", "Oh,\nI see"]);

		g.addStairReady("#grov04#On three, ready?", ["Hmm,\nsure", "Yep!", "Ready"]);
		g.addStairReady("#grov05#...Ready?", ["Mmm,\nokay", "Yeah!", "I'm\nready"]);
		g.addStairReady("#grov04#Alright, ready?", ["Ready\nwhenever", "Sure", "Let's\ndo it"]);
		g.addStairReady("#grov05#Ready?", ["Sure\nthing", "Let's go!", "Hmm..."]);
		g.addStairReady("#grov04#Ready to throw?", ["Okay!", "Oof, I\nguess...", "I'm ready"]);

		g.addCloseGame("#grov02#Ah, a bit of a close match, isn't it? ...Enjoy it while it lasts! Heheheh~", ["I like\nbeing close~", "Don't under-\n-estimate me", "Good\nmatch!"]);
		g.addCloseGame("#grov06#Hmmm... You're quite good at this! But I believe I might actually win this one...", ["Ooh,\nmaybe...", "Keep dreaming,\nstring bean", "Do you have\nsomething planned?"]);
		g.addCloseGame("#grov06#I see, I see, yes... And the game is underfoot...", ["You're about to\nbe under my foot!", "...What is it\nwith you\nand feet?", "I'd like to be\nunder your foot~"]);
		g.addCloseGame("#grov10#Oh dear! You're really keeping the pressure on, aren't you?", ["It's what\nI do", "Take no\nprisoners!", "Yeah,\nit's a\nclose one"]);

		g.addStairCapturedHuman("#grov03#Err, well come now, you should have known I'd see THAT coming! You need to stay one step ahead...", ["How'd you\nread that!?", "You must\nhave peeked!", "Ugh,\nwow..."]);
		g.addStairCapturedHuman("#grov02#Tsk, of course I could predict you'd throw out a <playerthrow>. That's such a <name> thing to do...", ["I'm coming\nfor you, just\nyou wait...", "Pfft,\nlucky guess", "Whoa!\nYou're good~"]);
		g.addStairCapturedHuman("#grov02#Hah! Heheheh. Grovyle gets another one!", ["I'll get\nyou another...\nboot to\nthe head", "How did\nyou...!?", "Oh\nman..."]);

		g.addStairCapturedComputer("#grov10#Gwahhh! I keep getting caught... I need to keep my moves more secret!", ["I know all\nyour secrets!", "Hey, this\nis fun~", "-evil laugh-"]);
		g.addStairCapturedComputer("#grov11#Wahhhh not again! ...How did you know I'd do that!? I thought I was being so clever throwing out a <computerthrow>!", ["I had a\nfeeling...", "Aww, you're\nstill clever~", "Too obvious,\ntoo obvious"]);
		g.addStairCapturedComputer("#grov09#Ahh back to the start!? I don't want to go all the way back to the start...", ["Get back\nthere, loser!", "Ohhh, I'm\nsorry...", "Better luck\nnext time"]);

		return g;
	}

	public static function bonusCoin(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#grov02#Ah, is that perchance... a bonus coin? Why, that's remarkably lucky!"];
		tree[1] = ["#grov05#Let's see what sort of bonus game we'll be playing today..."];
	}

	public static function sexyBadHurryFeet(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		tree[0] = ["#grov02#Is it the end already? Goodness, and now I suppose you're ready to see my cute little Grovyle toes again."];
		tree[1] = ["#grov05#...And, I know I've got some first-rate feet! But there's no particular need to rush things, is there?"];
		tree[2] = ["#grov03#That is to say, there's plenty of fun stuff to explore above the equator... Before we get to my feet! Such as, err-- well..."];

		appendRubSuggestions(tree, 3, "feet", "rub my feet");
	}

	public static function sexyBadHurryAss(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		if (PlayerData.justFinishedMinigame)
		{
			tree[0] = ["#grov02#Well! Now that that little game's over, the fun bit can begin hmm??"];
			tree[1] = ["#grov05#...And I suppose you're eager to prod those wee fingers up inside my rectal cavity again, aren't you? Hah! Heheheh."];
		}
		else
		{
			tree[0] = ["#grov02#That was quite an impressive feat of puzzle.... puzzlemanship! Yes, and mmm..."];
			tree[1] = ["#grov05#...I know you're eager to prod those wee fingers up inside my rectal cavity again."];
		}
		tree[2] = ["#grov03#But perhaps you could warm me up a bit first! ...That is to say, your hands were a bit chilly when we started last time."];
		tree[3] = ["#grov06#And besides that, there's plenty of fun stuff to explore above the equator. Such as, err-- you know!"];

		appendRubSuggestions(tree, 4, "ass", "finger my ass");
	}

	public static function sexyBadHurryBalls(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		if (!PlayerData.grovMale)
		{
			return sexyBefore0(tree, sexyState);
		}
		tree[0] = ["#grov00#Ah, and there we have it. I'm fully naked, and you, well... I can see you're eager to squeeze my beautiful pink balls again."];
		tree[1] = ["#grov05#But it's not entirely proper to skip STRAIGHT to the balls you know! I don't want to sound too much like a parent, but,"];
		tree[2] = ["#grov04#It's like how you can't enjoy your dessert until you finish your green beans."];
		tree[3] = ["#grov06#Err rather, you can't enjoy my green beans until you, mmmm..."];
		tree[4] = ["#grov02#Well, do your best to keep things above the equator for a moment at least! Resist the call of my magic beans. Hah! Heheheheh."];
	}

	public static function sexyBadHurryDick(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		var badOriginal:String;
		var badOriginalVerb:String;
		if (PlayerData.grovMale)
		{
			badOriginal = "dick";
			badOriginalVerb = "play with my dick";
		}
		else
		{
			badOriginal = "cunt";
			badOriginalVerb = "finger my cunt";
		}
		if (PlayerData.justFinishedMinigame)
		{
			tree[0] = ["#grov04#Ah! I think that's enough fun for now."];
		}
		else
		{
			tree[0] = ["#grov04#Ah! I think that's enough puzzles for now."];
		}
		tree[1] = ["#grov05#Now, I know you're eager to get to my genitals! I'm quite a fan of genitals myself."];
		tree[2] = ["#grov06#But perhaps hmm, build a little suspense first eh?? There's plenty of fun stuff to explore above the equator. Such as, err-- you know!"];

		appendRubSuggestions(tree, 3, badOriginal, badOriginalVerb);
	}

	public static function sexyBadRightFoot(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		tree[0] = ["#grov06#Do you have some kind of... right-foot fetish? Don't get me wrong, I love when my feet get some attention but..."];
		tree[1] = ["#grov10#My left foot has feelings too!"];
		tree[2] = ["#grov08#Why, he kept bothering me with his jealous ravings after our last time together! It was terribly awkward."];
		tree[3] = ["#grov05#Anyways you're doing great! A true master of of the right foot. And of course you're a perfect master of the genitals as well."];
		tree[4] = ["#grov02#You're a... a perfect master of a modern major genital."];
		tree[5] = ["#grov07#Err, nevermind."];
	}

	public static function sexyBadLeftFoot(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		tree[0] = ["#grov06#Do you have some kind of... left-foot fetish? Don't get me wrong, I love when my feet get some attention but..."];
		tree[1] = ["#grov10#Don't forget my right foot this time!"];
		tree[2] = ["#grov08#Why, I kept pacing in circles after our last time together! It was terribly awkward."];
		tree[3] = ["#grov05#Anyways you're doing great! A true master of of the left foot. And of course you're a perfect master of the genitals as well."];
		tree[4] = ["#grov02#You're a... a perfect master of a modern major genital."];
		tree[5] = ["#grov07#Err, nevermind."];
	}

	public static function sexyBadStealAss(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		tree[0] = ["#grov06#So contrary to what you may have seen on the internet, my ass has a maximum occupancy limit of, errr, one."];
		tree[1] = ["#grov03#I know, I know, I'm no fun am I?"];
		tree[2] = ["#grov05#But maybe next time I start fingering myself you can find something else to do, hmm..."];
		tree[3] = ["#grov02#Perhaps rub my dick or something eh?? Come now, you love dicks. Let's do this one together!"];
		if (!PlayerData.grovMale)
		{
			DialogTree.replace(tree, 2, "fingering myself", "fingering my ass");
			DialogTree.replace(tree, 3, "rub my dick", "play with my pussy");
			DialogTree.replace(tree, 3, "you love dicks", "you love pussies");
		}
	}

	public static function sexyBadStealDick(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		if (PlayerData.grovMale)
		{
			tree[0] = ["#grov05#So just to clear something up, if I start jerking myself off, don't feel offended! ...It's just something I do sometimes."];
			tree[1] = ["#grov03#We don't have to have say, a tug-of-war over my dangly bits."];
			tree[2] = ["#grov00#Maybe while I'm jerking myself off, you can hmm... rub my balls or something eh??"];
			tree[3] = ["#grov02#Teamwork!!! Why, I love it."];
		}
		else
		{
			tree[0] = ["#grov05#So just to clear something up, if I start fingering myself, don't feel offended! ...It's just something I do sometimes."];
			tree[1] = ["#grov03#You don't need to try and cram your hand in at the same time as mine, why that's just silly."];
			tree[2] = ["#grov00#Maybe while I'm knuckle deep in my girl bits, you can hmm... finger my ass or something eh??"];
			tree[3] = ["#grov02#Teamwork!!! Why, I love it."];
		}
	}

	public static function sexyBadStealBalls(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		if (!PlayerData.grovMale)
		{
			return sexyBefore1(tree, sexyState);
		}
		tree[0] = ["#grov05#Ah before we start... If I start playing with my balls or something, don't take offense! It doesn't mean you're doing a bad job."];
		tree[1] = ["#grov03#You certainly don't have to, errrr, swat my hand away to keep my balls for yourself."];
		tree[2] = ["#grov00#Maybe while my hands are full of balls you can, hmm... give my ass some attention eh??"];
		tree[3] = ["#grov02#Mmm-yes!! Cooperation and all that. Go, team!!"];
	}

	public static function sexyBadMissedYou(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		tree[0] = ["#grov03#Ahh, my long lost friend, <name>. ...I wonder what accounted for your absence, hmmm?"];
		tree[1] = ["#grov06#Perhaps you got a new computer? Or changed web browsers, or deleted your cookies by mistake? ...No, no, I'm certain it was nothing that mundane."];
		tree[2] = ["#grov02#I'll bet you suffered an untimely death, only to return to life as a zombie in a post-apocalyptic nightmare universe! ...Mmmm, wouldn't be the first time THAT'S happened."];
		tree[3] = ["#grov05#... ..."];
		tree[4] = ["#grov00#Say, you know... When a naked person and a zombie glove from a post-apocalyptic nightmare universe like each other very much... Do you know what happens next?"];
		tree[5] = [10, 20, 40, 30, 50];

		tree[10] = ["Oh, you want\nme to nibble\nyour brains?"];
		tree[11] = ["#grov06#Errrm.... Maybe? ...Is... Is that code for something?"];
		tree[12] = ["#grov10#If I hear anything resembling a circular saw, there's going to be a Grovyle-shaped hole in that wall over there..."];

		tree[20] = ["Oh, you want\nto lock\nyourself in an\nabandoned\nshopping mall?"];
		tree[21] = ["#grov02#Hah! Heheheheh! What, and miss out on all the sexy zombie action?"];
		tree[22] = ["#grov00#I want to be where the action is. Go on, show me your sexy zombie moves~"];

		tree[30] = ["Oh, you want\nto experiment\nwith\nnecrophilia?"];
		tree[31] = ["#grov02#Hah! Heheheheh. Why, it would hardly be my first time~"];
		tree[32] = ["#grov05#... ..."];
		tree[33] = ["#grov06#...No, on second thought, sorry. Think that one went a bit too far."];
		tree[34] = ["#grov10#Just to be clear I, errrmm. ...HAVEN'T... done anything like that with a corpse before. -cough-"];

		tree[40] = ["Oh, you want\nto make a\nhalf-zombie\nhalf-reptile\nhybrid?"];
		tree[41] = ["#grov01#Ooooh! Heheheheh. ...Your place or mine?"];
		tree[42] = ["#grov03#On second thought, let's just stay over here. ...Zombies aren't particularly renowned for their interior decorating skills."];

		tree[50] = ["...No.\nNo, none\nof this.\nJust no."];
		tree[51] = ["#grov02#Hah! Heheheheh. Sorry, sorry. Think I let that one get away from me a bit."];
	}

	public static function sexyAfterGood1(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		tree[0] = ["#grov07#Good... good HEAVENS yes... ... ahhh... You're always good, but that was..."];
		tree[1] = ["#grov01#That was really, REALLY... oohh... Wow.... I, you... ... ahhh... Really..."];
		tree[2] = ["#grov07#I'm just really... err, relax... ... Have to relax... unscramble my brain... my... my goodness...! Hahh!"];
	}

	public static function sexyAfterGood0(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		tree[0] = ["#grov07#Dear... dear GOODNESS that was something! Hahh... ... phew! I... I didn't even know I had that much stored up!"];
		tree[1] = ["#grov01#I mean... phew... there's not even enough space inside me for all that. It's like you've uncovered some sort of err, Tardis Box of jizz."];
		if (!PlayerData.grovMale)
		{
			DialogTree.replace(tree, 1, "jizz", "lady juices");
		}
		tree[2] = ["#grov00#Ahhh! Wow... Alright, I-- I'm going to stop talking before I say something else horridly unsexy."];
		tree[3] = ["#grov01#But can... Can you do that next time? Hahhh.... ... ahh, goodness..."];
	}

	public static function sexyAfter3(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		tree[0] = ["#grov00#Oh my, yes.... It's always a pleasure spending time with you. You really know your, err...."];
		tree[1] = ["#grov01#You're quite good at what you do. Hahh... thank you~"];
	}

	public static function sexyAfter0(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		tree[0] = ["#grov00#Hah... How are you so good at that? Is it... is it those dangly bits on the sides of your hands?"];
		tree[1] = ["#grov06#Thumbs is it? Well that hardly seems fair. Of course you're better at this than I am, you have extra equipment!"];
		tree[2] = ["#grov05#Phew... anyway, come back soon if you could?"];
	}

	public static function sexyAfter1(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		tree[0] = ["#grov01#Phew... th-thank you for that... It's always a time spending pleasure with you. Errr..."];
		tree[1] = ["#grov00#I'm just going to rest over here for a moment... Hah..."];
	}

	public static function sexyAfter2(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		tree[0] = ["#grov01#Goodness, that was... hah... that was something! You've been working on some new moves, have you?"];
		tree[1] = ["#grov04#You know, despite how good you are at solving puzzles... you're better yet at solving Grovyles. Mmmm."];
		tree[2] = ["#grov00#I mean the puzzles are good! But... Hah... Ah... We'll see each other again soon, yes?"];
	}

	public static function sexyBefore3(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		tree[0] = ["#grov06#Is it the end already? Goodness, it only feels like minutes ago that we were solving that first puzzle,"];
		tree[1] = ["#grov08#And now our time together is nearly at a close."];
		tree[2] = ["#grov04#Why don't we form one last memory together before you go?"];
		tree[3] = ["#grov02#Well you know, something I can remember you by until we meet again."];
	}

	public static function sexyBefore2(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		if (PlayerData.justFinishedMinigame)
		{
			tree[0] = ["#grov02#Well! Now that that little game's over, the fun bit can begin hmm??"];
		}
		else
		{
			tree[0] = ["#grov02#That was quite an impressive feat of puzzle.... puzzlemanship! Yes, yes."];
		}
		tree[1] = ["#grov06#I'd say you've earned some sort of reward! Although let's see, hmm. It seems I've run out of clothing to remove..."];
		tree[2] = ["#grov03#Can you think of anything else you'd like for your reward? Why it only seems fair to give you something..."];
	}

	public static function sexyBefore1(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		if (PlayerData.justFinishedMinigame)
		{
			tree[0] = ["#grov04#Ah! I think that's enough fun for now. I'm just going to relax here for a moment."];
		}
		else
		{
			tree[0] = ["#grov04#Ah! I think that's enough puzzles for now. I'm just going to relax here for a moment."];
		}
		tree[1] = ["#grov00#You can join me if you like! I could use the company~"];
	}

	public static function sexyBefore0(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		tree[0] = ["#grov02#Ah, and there we have it. I'm fully naked, and you, well... You're still a glove."];
		tree[1] = ["#grov00#Say, you know... When a naked person and a glove like each other very much... Do you know what happens next?"];
		tree[2] = [10, 20, 30, 40];
		tree[10] = ["Oh, you want\nme to give\nyou a\nhand job?"];
		if (!PlayerData.grovMale)
		{
			tree[10] = ["Oh, you want\nme to finger\nyour pussy?"];
			tree[2] = [10, 30, 40];
		}
		tree[11] = ["#grov01#Hah! Heheheheh. Oh, you see right through me."];
		tree[20] = ["Oh, you want\nme to check\nyour prostate?"];
		tree[21] = ["#grov01#Hah! Heheheheh. I see you have some experience with naked people and gloves! Yes, very good."];
		tree[30] = ["Oh, you want\nto wear me\non your head\nlike a rooster?"];
		tree[31] = ["#grov06#Wait... what? No, that's wrong."];
		tree[32] = ["#grov15#Wearing you on my head like a rooster is wrong."];
		tree[33] = ["#grov07#What sort of naked-person-and-glove web sites have you been visiting!?!"];
		tree[40] = ["Oh, I don't\nknow..."];
		tree[41] = ["#grov02#Well!! Perhaps you can find the answer in some manner of Grovyle textbook."];
		tree[42] = ["#grov01#I wonder if it's hidden somewhere in the back... Yessss..."];
	}

	public static function random00(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("grov.randomChats.0.0");

		tree[0] = ["#grov05#Ready for another grueling puzzle session eh?"];
		if (PlayerData.difficulty == PlayerData.Difficulty.Easy)
		{
			if (count == 0)
			{
				tree[1] = ["#grov04#Don't forget you can summon Abra's help if you get stuck. Best of luck to you!"];
			}
			else
			{
				tree[1] = ["#grov02#Oh come now, these should be no problem for you! You've had plenty of practice."];
			}
		}
		else if (PlayerData.difficulty == PlayerData.Difficulty._3Peg)
		{
			tree[1] = ["#grov04#Hmm this one seems to be a little tricky!"];
			tree[2] = ["#grov02#Let's do our best, shall we."];
		}
		else if (PlayerData.difficulty == PlayerData.Difficulty._4Peg)
		{
			tree[1] = ["#grov06#Phew, this is where the fun really starts isn't it! Let's see here."];
		}
		else if (PlayerData.difficulty == PlayerData.Difficulty._5Peg)
		{
			tree[1] = ["#grov07#Gahh just staring at these five peg puzzles melts my brain a little!"];
			tree[2] = ["#grov02#Okay okay, deep breaths. One clue at a time, we can handle this."];
		}
	}

	public static function random01(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#grov04#Say! What's your favorite part of these puzzles anyways?"];
		tree[1] = [10, 20, 30, 40];

		tree[10] = ["Our\nconversations"];
		tree[11] = ["#grov00#Ah! Our conversations? Ours specifically? Why that's so flattering, thank you so much... And yet..."];
		tree[12] = ["#grov10#It also places a tremendous burden on me to say something interesting! Ummm..."];
		tree[13] = ["#grov03#Life is about the destination... not about the journey."];
		tree[14] = [60, 70, 80];

		tree[20] = ["Solving the\npuzzles"];
		tree[21] = ["#grov02#Ah yes! There's nothing quite like working through a nice puzzle."];
		tree[22] = ["#grov05#Of course, hitting the little button at the end doesn't mean much of anything! It's about figuring it out, those little leaps of logic along the way."];
		tree[23] = ["#grov03#Just like how life is about the destination... not about the journey."];
		tree[24] = [60, 70, 80];

		tree[30] = ["Seeing you\nnaked"];
		tree[31] = ["#grov01#Seeing me... naked? Ah goodness..."];
		tree[32] = ["#grov00#Well, thank you, your um... your hand is very pretty as well."];
		tree[33] = ["#grov03#Of course there's already plenty of naked Pokemon on the internet to look at, I think there's something more to it."];
		tree[34] = ["#grov05#I think you like looking at me naked because you have to work at it a little!!"];
		tree[35] = ["#grov04#Just like how life is about the destination... not about the journey."];
		tree[36] = [60, 70, 80];

		tree[40] = ["The sexy bit\nat the end"];
		tree[41] = ["#grov01#Ah yes... I enjoy that bit too..."];
		tree[42] = ["#grov05#Although you know, I think I enjoy it more because I have to wait for it a little! Watching you solve puzzles, building up to that moment."];
		tree[43] = ["#grov04#Sort of like how life is about the destination... not about the journey."];
		tree[44] = [60, 70, 80];

		tree[60] = ["Let's skip\nto the\ndestination"];
		tree[61] = ["#grov01#(Should I? ...Should I let him skip?)"];
		tree[62] = ["#grov00#Very well I'll let you skip ahead a bit just this once! But please don't let Abra see."];
		tree[63] = ["%skip%"];
		tree[64] = ["%fun-nude1%"];
		tree[65] = ["#grov01#Ah! You won't judge me for this will you? For letting you cheat in my moment of weakness?"];

		tree[70] = ["But I\nenjoy the\njourney"];
		tree[71] = ["#grov02#Ah yes don't get me wrong, the journey is good too."];
		tree[72] = ["#grov01#But I'm still looking forward to some good destination action at the end of these puzzles!"];

		tree[80] = ["I think\nthat's\nbackwards"];
		tree[81] = ["#grov06#...Backwards?"];
		tree[82] = ["#grov03#...Ah well aren't you a clever carrot! Yes, yes, very well, of course I meant it's about the journey and not the destination."];
		tree[83] = ["#grov02#Anyways let's put this newfound cleverness of yours to work on some puzzles."];
	}

	public static function random02(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("grov.randomChats.0.2");

		if (count % 6 == 0 || count % 6 == 1)
		{
			tree[0] = ["#grov02#You're getting the hang of these puzzles by now, yes? Why, it's just like riding a bicycle!"];
			tree[1] = ["#grov04#Only well, the bicycle has " + englishNumber(puzzleState._puzzle._clueCount) + " pedals which are " + englishNumber(puzzleState._puzzle._colorCount) + " different colors..."];
			tree[2] = ["#grov07#And they constantly rearrange so you have to learn the bicycle from scratch each time..."];
			tree[3] = ["#grov05#Ah, but the bicycle has a nice girthy cock built into the seat! So that's nice."];
			if (!PlayerData.grovMale)
			{
				DialogTree.replace(tree, 3, "nice girthy cock", "warm wet cunt");
			}
			tree[4] = ["#grov06#Hmm, I should build myself a bicycle."];
		}
		else if (count % 6 == 2)
		{
			tree[0] = ["#grov05#Ah, <name>! ...It's a pleasure to see you here again. Life's treating you well, I hope?"];
			tree[1] = ["#grov02#You might be interested to hear that I've made a small amount of progress towards my little bicycle project! Hah! Heheheh~"];
			tree[2] = ["#grov00#That is to say, I've spent several hours this week refining the ergonomics of the errr... \"anatomically enhanced\" bicycle seat."];
			tree[3] = ["#grov01#I suppose the next step is to connect it to the rest of the bicycle but I keep getting distracted for some reason. Ah, well..."];
		}
		else if (count % 6 == 3)
		{
			tree[0] = ["#grov05#Oh hello again, <name>! ...I hope you're well today."];
			tree[1] = ["#grov08#I'm ashamed to report that I still haven't made very much progress on my bicycle project."];
			tree[2] = ["#grov06#...Perhaps if I could find some way to quell my more carnal urges, I wouldn't lose focus as frequently. But as it stands, alas... ..."];
			tree[3] = ["#grov02#Say, quelling carnal urges is sort of your specialty isn't it <name>? ...Perhaps we can have a go of it after this next series of puzzles~"];
		}
		else
		{
			tree[0] = ["#grov05#Ah it's my old friend <name>! ...I feel like we've seen quite a lot of each other recently, haven't we? Not that I'm one to complain, of course."];
			tree[1] = ["#grov02#...One shouldn't overlook the health benefits of a daily dose of vitamin <name>~"];
		}
	}

	public static function random03(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("grov.randomChats.0.3");
		tree[0] = ["#grov05#So what would you say is-"];
		tree[1] = ["%enterbuiz%"];
		tree[2] = ["#buiz02#Hey what's up Grovyle!"];
		tree[3] = ["#grov02#Ah! Hello Buizel, we were just getting started on our first puzzle."];
		tree[4] = ["#buiz03#So I was wondering- when you're talking about how you're into all sorts of other puzzles... what kind of puzzles do you mean? Is it something I'd like?"];
		tree[5] = ["#grov03#Oh sure, you well might! I have several books of Japanese pen and paper puzzles. And I have apps for some of them as well."];
		tree[6] = ["#grov04#They're sort of like crosswords but... different!"];
		tree[7] = ["#buiz05#Oh right like Sudoku or something? Sudoku's Japanese right?"];

		tree[30] = ["%exitbuiz%"];
		tree[31] = ["#grov04#You know <name>, if you enjoy puzzles as much as I do you should certainly look up those puzzles I mentioned..."];
		tree[32] = ["#grov03#You may have heard of Kakuro, but Nurikabe and Heyawake are also quite enjoyable."];
		tree[33] = ["#grov05#These peg-placement puzzles are a nice distraction, but they lack the ingenuity of a hand-crafted pencil puzzle."];

		if (count > 0)
		{
			tree[3] = ["#grov02#Ah yes. Hello again, Buizel."];
			tree[4] = ["#buiz06#So uhh, what were names of those Japanese puzzles again?"];
			tree[5] = ["#buiz08#I think you were talkin' about Sudoku or something but I couldn't remember the other ones..."];
			tree[6] = [8];
			tree[7] = null;
		}

		if (count % 3 == 0)
		{
			tree[8] = ["#grov06#Sure, yes, there's nothing wrong with Sudoku... Although there are several puzzles I enjoy more than Sudoku, such as Nurikabe, Kakuro, and Heyawake."];
			tree[9] = ["#grov03#They're all similar in that they involve a grid of-"];
			tree[10] = ["#buiz00#\"Heyawake\"?"];
			tree[11] = ["#grov04#Mmmyes, \"Heyawake\". That one's especially interesting because whereas Sudoku typically has more of-"];
			tree[12] = ["#buiz01#More like \"Hey-asleep\"!! Bweh-heheheheheh."];
			tree[13] = ["#grov04#..."];
			tree[14] = ["#grov03#Mmmm, really? I suppose you're proud of your little... nonsensical ejaculation?"];
			tree[15] = ["#buiz03#... ... ...Wait, WHAT!?"];
			tree[16] = ["#grov10#Your errr... That absurd little quip you made! ...I suppose you're proud of it?"];
			tree[17] = ["#buiz02#Bweheheheheheh!"];
			tree[18] = ["%exitbuiz%"];
			tree[19] = ["#buiz00#Alright alright I'm sorry about my... ejaculation. I'll leave you two alone~"];
			tree[20] = ["#grov03#-sigh-"];
			tree[21] = [31];
		}
		else if (count % 3 == 1)
		{
			tree[8] = ["#grov06#Sure, yes, there's nothing wrong with Sudoku... Although there are several puzzles I enjoy more than Sudoku, such as Nurikabe, Kakuro, and Kurodoko."];
			tree[9] = ["#grov03#They're all similar in that they involve a grid of-"];
			tree[10] = ["#buiz00#\"Kurodoko\"?"];
			tree[11] = ["#grov04#Mmmyes, \"Kurodoko\". You see, in a Kurodoko puzzle, rather than placing numbers-"];
			tree[12] = ["#buiz01#More like \"Kuro-dorko\"!! Bweh-heheheheheh."];
			tree[13] = ["#grov03#..."];
			tree[14] = ["#buiz00#Sorry, sorry. The names are hard to remember and I'll forget them unless I make a funny quip."];
			tree[15] = ["#grov02#Ahh. Very well, if you must."];
			tree[16] = [30];

			DialogTree.replace(tree, 32, "Heyawake", "Kurodoko");
		}
		else if (count % 3 == 2)
		{
			tree[8] = ["#grov06#Sure, yes, there's nothing wrong with Sudoku... Although there are several puzzles I enjoy more than Sudoku, such as Nurikabe, Kakuro, and Hashiwokakero."];
			tree[9] = ["#grov03#They're all similar in that they involve a grid of-"];
			tree[10] = ["#buiz00#\"Hashiwokakero\"?"];
			tree[11] = ["#grov03#*sigh*"];
			tree[12] = ["#buiz01#More like uhhh \"Hashiwooka\"-- wait... \"Hashiwaka-don't-care-oh!\"!! Bweh-heheheheheh."];
			tree[13] = ["#grov03#..."];
			tree[14] = ["#buiz03#Hey c'mon you gave me a hard one that time!"];
			tree[15] = ["#buiz04#Pshhh, whatever."];
			tree[16] = [30];

			DialogTree.replace(tree, 32, "Heyawake", "Hashiwokakero");
		}

		tree[10000] = ["%exitbuiz%"];
	}

	public static function random04(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("grov.randomChats.0.4");
		if (count % 3 == 0)
		{
			tree[0] = ["#grov05#Ah! Fancy seeing-"];
			tree[1] = ["%entersmea%"];
			tree[2] = ["#smea02#Oh hey Grovyle! Ummm just wondering..."];
			tree[3] = ["#smea06#Do you have any advice for these harder puzzles? ...Sometimes I have trouble just getting started..."];
			tree[4] = ["#grov03#Ah sure, I could offer you some tips! ...Perhaps I can give you one of my tutorials later."];
			tree[5] = ["%exitsmea%"];
			tree[6] = ["#smea05#Oh! I forgot you had tutorials for this harder stuff too. Okay! ...I think I saw a button for tutorials on the main menu."];
			tree[7] = ["#grov02#Anyways <name>, let's see what you can do with this first puzzle!"];

			if (PlayerData.difficulty == PlayerData.Difficulty.Easy)
			{
				DialogTree.replace(tree, 3, "harder puzzles", "puzzles");
				DialogTree.replace(tree, 6, "harder stuff too", "stuff");
			}
		}
		else if (count % 3 == 1)
		{
			tree[0] = ["#grov05#Ah! Fancy seeing you again."];
			tree[1] = ["#grov04#Let's see what you can do with this first puzzle!"];
		}
		else if (count % 3 == 2)
		{
			tree[0] = ["#grov05#Ah! Fancy seeing-"];
			tree[1] = ["%entersmea%"];
			tree[2] = ["#smea06#Oh hey Grovyle! Do you have any advice for these harder puzzles? ...Sometimes I have trouble just getting started..."];
			tree[3] = ["#grov06#Ah sure, I... Hmmm, didn't I give you a tutorial on this stuff the other day?"];
			tree[4] = ["#smea09#Yeah, but I kind of forgot most of it..."];
			tree[5] = ["#grov03#Ah, well we can always go through the tutorial a second time! It's the same puzzles, but it never hurts to brush up."];
			tree[6] = ["%exitsmea%"];
			tree[7] = ["#smea05#Oh! I forgot I could repeat the tutorials. Okay! ...I think I remember seeing the button for tutorials on the main menu."];
			tree[8] = ["#grov02#Anyways <name>, let's see what you can do with this first puzzle!"];

			if (PlayerData.difficulty == PlayerData.Difficulty.Easy)
			{
				DialogTree.replace(tree, 2, "harder puzzles", "puzzles");
			}
		}
	}

	public static function random12(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["%fun-nude0%"];
		tree[1] = ["#grov03#Now I've lost track, is this the part where I take off my clothes or the part where you solve a puzzle?"];
		tree[2] = [10, 30, 50, 70];

		tree[10] = ["Take off\nyour clothes"];
		tree[11] = ["#grov04#Ah that's right, I need to take off my clothes and then you can solve another puzzle."];
		tree[12] = ["%fun-nude1%"];
		tree[13] = ["#grov03#Sorry I kind of dozed off during that last one!! Are we sorted now?"];
		tree[14] = [15, 20];

		tree[15] = ["Yes, we're\ngood"];
		tree[16] = ["#grov02#Excellent well then, err, on with it!"];

		tree[20] = ["No,\ntake off\nmore clothes"];
		tree[21] = ["#grov00#Hah! Heheheheh. Why, I believe it's customary to buy me a drink first."];

		tree[30] = ["I solve\na puzzle"];
		tree[31] = ["#grov06#Ah yes. And I remove the rest of my clothes afterward, is it?"];
		tree[32] = ["#grov05#I'll trust your judgment. If there was anyone who'd want to see me with less clothes, certainly it would be you."];

		tree[50] = ["We need to\ndo both"];
		tree[51] = [11];

		tree[70] = ["It's the end\npart where we\nscrew around"];
		tree[71] = ["#grov02#Hah! Heheheh. Alright I'll meet you halfway,"];
		tree[72] = ["#grov04#I'll remove half my clothes now-- and later on,"];
		tree[73] = ["#grov03#Later you can give me half a handjob or whatever suits half your fancy. Does that sound half satisfactory?"];
		if (!PlayerData.grovMale)
		{
			DialogTree.replace(tree, 73, "give me half a handjob", "fingerbang me halfway");
		}
		tree[74] = [80, 85, 90, 95];

		tree[80] = ["Hmph"];
		tree[81] = ["%fun-nude1%"];
		tree[82] = ["#grov02#Heheheh!"];
		tree[85] = ["Whatever"];
		tree[86] = [81];
		tree[90] = ["Fine"];
		tree[91] = [81];
		tree[95] = ["I guess"];
		tree[96] = [81];
		tree[10000] = ["%fun-nude1%"];
	}

	public static function random13(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#grov00#You know, I have this round's reward chest right here if you want me to take a peek for you..."];
		tree[1] = [20, 30, 40];
		tree[20] = ["Just a\nlittle peek!"];
		tree[21] = ["#grov02#Ooh! Let's see..."];
		tree[22] = ["#grov06#..."];
		if (puzzleState._puzzle._easy)
		{
			tree[23] = ["#grov03#..." + moneyString(puzzleState._puzzle._reward) + ". Ah. How am I not surprised..."];
		}
		else if (puzzleState._lockedPuzzle != null && puzzleState._lockedPuzzle != puzzleState._puzzle)
		{
			tree[23] = ["#grov03#..." + moneyString(puzzleState._puzzle._reward) + " or... "
						+ moneyString(puzzleState._lockedPuzzle._reward) + "? Oooh! Let's try for the "
						+ moneyString(puzzleState._lockedPuzzle._reward) + " today. Can we?"];
		}
		else
		{
			tree[23] = ["#grov03#..." + moneyString(puzzleState._puzzle._reward) + "? Ah, well that's a little something to look forward to hmm?"];
		}

		tree[30] = ["No, don't\npeek"];

		tree[40] = ["Whatever you\nfeel like"];
		tree[41] = ["#grov03#Oh you're letting ME decide? Hmmm... Hmmmmmmmm..."];
		if (FlxG.random.bool())
		{
			tree[42] = ["#grov02#I'm feeling naughty today! I want to peek."];
			tree[43] = ["#grov06#..."];
			tree[44] = [23];
		}
		else
		{
			tree[42] = ["#grov02#Oh, we probably shouldn't peek. Let's just be good today."];
			tree[43] = ["#grov00#...We can reward each other for our good behavior later~"];
		}
	}

	public static function random10(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#grov06#Hmm yes I see, so the leftmost peg has to be that color... Hmm, no wait, that's not it..."];
		if (PlayerData.difficulty == PlayerData.Difficulty.Easy)
		{
			DialogTree.replace(tree, 0, "the leftmost", "one");
		}
		tree[1] = ["#grov10#Well come now I can't solve it with you staring at me like that!"];
		tree[2] = ["#grov14#...Let's see how you like it if I stare at you for the entire puzzle! Harumph!"];
	}

	public static function random11(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#grov05#If you're ever feeling flummoxed by these puzzles, perhaps your penis can have a crack at one."];
		tree[1] = ["#grov06#Your brain could handle the first puzzle, and your penis can handle the second puzzle-- you can alternate brain, penis, brain, penis and so forth."];
		tree[2] = ["#grov10#Ah wait but what if your brain gets stuck handling the sexy part at the end!! ...Is that allowed?"];
		if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			DialogTree.replace(tree, 0, "penis", "vagina");
			DialogTree.replace(tree, 1, "penis", "vagina");
		}
		else if (PlayerData.gender == PlayerData.Gender.Complicated)
		{
			DialogTree.replace(tree, 0, "penis", "genitals");
			DialogTree.replace(tree, 1, "penis", "genitals");
		}
	}

	public static function random20(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var timeInMinutes:Float = puzzleState._puzzle._difficulty * RankTracker.RANKS[36] / 60;
		tree[0] = ["#grov06#Ah yes, I remember this next puzzle. This one took me less than a minute."];
		tree[1] = ["#grov05#But of course that's after quite a bit of practice. Let's see how long it takes you."];

		if (timeInMinutes > 12)
		{
			DialogTree.replace(tree, 0, "less than a minute.", "a really long time! Goodness.");
			DialogTree.replace(tree, 1, "But of course", "And");
		}
		else if (timeInMinutes > 4)
		{
			DialogTree.replace(tree, 0, "less than a minute.", "five or ten minutes!");
			DialogTree.replace(tree, 1, "But of course", "And");
		}
		else if (timeInMinutes > 1)
		{
			DialogTree.replace(tree, 0, "less than a minute.", "a few minutes.");
		}
	}

	public static function random21(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#grov05#Ah yes, the final puzzle! And of course we saved the best for last."];
		tree[1] = ["#grov06#Or is it the worst for last? Let's see, this puzzle is..."];
		if (puzzleState._puzzle._puzzlePercentile > 0.5)
		{
			if (PlayerData.difficulty == PlayerData.Difficulty.Easy || PlayerData.difficulty == PlayerData.Difficulty._3Peg)
			{
				tree[2] = ["#grov07#Goodness! This one's actually incredibly difficult, well, for a three peg puzzle!"];
				tree[3] = ["#grov04#I suppose we really did save the worst for last. Sorry about that!"];
			}
			else
			{
				tree[2] = ["#grov07#Goodness! This one's actually incredibly difficult. We really did save the worst for last."];
				tree[3] = ["#grov04#Sorry about that! Knuckle down and do your best."];
			}
		}
		else if (puzzleState._puzzle._puzzlePercentile > 0.30)
		{
			if (PlayerData.difficulty == PlayerData.Difficulty.Easy || PlayerData.difficulty == PlayerData.Difficulty._3Peg)
			{
				tree[2] = ["#grov10#Hmm yes this one's actually a bit tricky, well for a three peg puzzle!"];
				tree[3] = ["#grov04#I suppose we really did save the worst for last. Sorry about that!"];
			}
			else
			{
				tree[2] = ["#grov10#Ah, a rather tricky one! Perhaps we did save the worst for last."];
				tree[3] = ["#grov04#Sorry about that! Knuckle down and do your best."];
			}
		}
		else if (puzzleState._puzzle._puzzlePercentile > 0.15)
		{
			tree[2] = ["#grov03#Ah, well this one's not so bad. I suppose we saved the middle for last?"];
			tree[3] = ["#grov02#Oh, how anticlimactic! Saving the middle for last."];
			tree[4] = ["#grov00#And I was so looking forward to a nice climax. Hah! Heheheh."];
		}
		else
		{
			tree[2] = ["#grov02#Goodness! This one shouldn't take you much time at all. It looks like we did save the best for last."];
			tree[3] = ["#grov05#Well at least try to have fun with it!"];
			tree[4] = ["#grov00#Don't let my floppy grovyle weiner distract you or anything. Hah! Heheheh."];

			if (!PlayerData.grovMale)
			{
				DialogTree.replace(tree, 4, "floppy grovyle weiner", "freshly exposed grovyle genitals");
			}
		}
	}

	public static function random22(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#grov04#Say, how are you holding up? You know, solving three puzzles in a row like this can really drain a lot out of someone!!"];
		tree[1] = ["#grov00#You know what else can drain a lot out of someone..."];

		tree[2] = [10, 20, 30, 50];
		FlxG.random.shuffle(tree[2]);
		tree[2] = tree[2].splice(0, 3);
		tree[2].push(40);
		FlxG.random.shuffle(tree[2]);

		tree[10] = ["30 meters\nof rubber\ntubing"];
		tree[11] = ["#grov10#Rubber tubing!?"];
		tree[12] = ["#grov06#I was thinking something more sexual, but I suppose 30 meters of rubber tubing suits the question in a nonsexual way..."];
		tree[13] = ["#grov08#You weren't thinking for sex right?"];
		tree[14] = ["#grov06#..."];
		tree[15] = ["#grov07#...Please don't use any rubber tubing in the next part of the game!"];

		tree[20] = ["The bilge\nof a\nwaterborne\nvessel"];
		tree[21] = ["#grov14#The bilge!? The bilge of a waterborne vessel!?!"];
		tree[22] = ["#grov13#Not only is that a competely unsexy answer, it also references the absolute unsexiest part of a ship!!"];
		tree[23] = ["#grov12#All that... foul smelling water and collected aquatic waste..."];
		tree[24] = ["#grov06#..."];
		tree[25] = ["#grov07#...Please don't mention bilges during the sexy phase of the game! It will just ruin the mood."];
		tree[26] = ["#grov14#Augh! The bilge..."];

		tree[30] = ["Puncturing\nthe carotid\nartery"];
		tree[31] = ["#grov10#The carotid artery??"];
		tree[32] = ["#grov06#I suppose if it comes to draining the most fluid you can't really beat the carotid artery..."];
		tree[33] = ["#grov11#But those aren't the sexy kinds of fluids to drain!"];
		tree[34] = ["#grov10#I'm counting on you to drain the right fluids in the next part of the game... You do know the difference don't you?"];
		tree[35] = ["#grov08#Only drain the sexy ones!"];
		tree[36] = ["#grov06#..."];
		tree[37] = ["#grov07#...Please don't puncture my carotid artery in the next phase of the game!"];

		tree[40] = ["That sensitive\narea beneath\nthe tip of\nthe penis"];
		if (!PlayerData.grovMale)
		{
			tree[40] = ["Vigorous\nclitoral\nstimulation"];
		}
		tree[41] = ["#grov01#...Ah,"];
		tree[42] = ["#grov00#...I wasn't expecting you to be that specific, but yes, something in that area..."];
		tree[43] = ["#grov01#Oh my..."];
		tree[44] = ["#grov02#Try to knock out this puzzle extra quick, okay! For the both of us, heheheh."];

		tree[50] = ["A hefty\nsack of\nleeches"];
		tree[51] = ["#grov07#Leeches? An entire sack of them!?!"];
		tree[52] = ["#grov06#That's a bit much don't you think? I could likely make do with one leech at a time, that is you know, if they did the job properly."];
		tree[53] = ["#grov05#Why would you bring that up randomly? Is there a leech you're trying to set me up with?"];
		tree[54] = ["#grov06#..."];
		tree[55] = ["#grov00#Does he have a hefty sack?"];
	}

	public static function random23(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var rank:Int = RankTracker.computeAggregateRank();
		var maxRank:Int = RankTracker.computeMaxRank(puzzleState._puzzle._difficulty);

		tree[0] = ["#grov06#So have you fiddled with the ranking system yet? Let see, you're rank... rank " + englishNumber(rank) + "? Ah yes, yes..."];
		if (rank == 0)
		{
			tree[1] = ["#grov02#Why you haven't even dipped your toe in the pool yet! Come now, you should at least TRY the ranking system some time. I rather enjoy it!"];
			tree[2] = ["#grov04#Or I suppose, different strokes for different folks, is it? Heheh. Well, one final puzzle~"];
		}
		else if (rank >= maxRank && rank != 65)
		{
			tree[1] = ["#grov10#Err, I suppose you might be unaware, but you can't progress past rank " + englishNumber(maxRank) + " on this difficulty!"];
			tree[2] = ["#grov04#I enjoy relaxing with these easier puzzles myself, but I know full well I won't be given any rank chances for doing so."];
			tree[3] = ["#grov02#Just thought you might appreciate a heads up. Enjoy your puzzle~"];
		}
		else if (rank <= 36)
		{
			tree[1] = ["#grov02#Ah! That's rather impressive! It takes some practice to make it all the way to rank " + englishNumber(rank) + "."];
			tree[2] = ["#grov04#I think my rank last I checked was... rank 36?? Somewhere around there. I'm sure you'll surpass that some day if you keep plugging away these Grovyles."];
			tree[3] = ["#grov07#Err I mean, if you keep plugging away at these Grovyles! ...I mean puzzles! PUZZLES!! Eh-heheheheh~"];
			tree[4] = ["#grov01#What were we doing? Another puzzle? Errm yes..."];
		}
		else
		{
			tree[1] = ["#grov04#Ah! That's rather impressive. Say, I consider myself to be a bit of a puzzle connoisseur, as it were, and I'm only rank 36!"];
			tree[2] = ["#grov06#Perhaps I should practice a bit more. I bet I can catch up to rank " + englishNumber(rank) + " if I sharpen my skills a bit."];
			tree[3] = ["#grov02#I'll have to study some of your puzzle solving tricks! Go on, show me how a rank " + englishNumber(rank) + " solves a puzzle~"];
		}
	}

	public static function bisexual(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			// so you're a boy... who fancies other boys?
			tree[0] = ["#grov06#So you're "];
			if (PlayerData.gender == PlayerData.Gender.Boy)
			{
				// The explicit 'Std.string()' call is a workaround for Haxe issue #11235; generated .cpp files have conversion errors, "cannot convert from 'String' to 'Float'"
				// https://github.com/HaxeFoundation/haxe/issues/11235
				tree[0][0] = Std.string(tree[0][0]) + "a boy";
			}
			else if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				// The explicit 'Std.string()' call is a workaround for Haxe issue #11235; generated .cpp files have conversion errors, "cannot convert from 'String' to 'Float'"
				// https://github.com/HaxeFoundation/haxe/issues/11235
				tree[0][0] = Std.string(tree[0][0]) + "a girl";
			}
			else
			{
				// The explicit 'Std.string()' call is a workaround for Haxe issue #11235; generated .cpp files have conversion errors, "cannot convert from 'String' to 'Float'"
				// https://github.com/HaxeFoundation/haxe/issues/11235
				tree[0][0] = Std.string(tree[0][0]) + "someone";
			}
			// The explicit 'Std.string()' call is a workaround for Haxe issue #11235; generated .cpp files have conversion errors, "cannot convert from 'String' to 'Float'"
			// https://github.com/HaxeFoundation/haxe/issues/11235
			tree[0][0] = Std.string(tree[0][0]) + "... ";
			if (PlayerData.sexualPreference == PlayerData.SexualPreference.Boys)
			{
				// The explicit 'Std.string()' call is a workaround for Haxe issue #11235; generated .cpp files have conversion errors, "cannot convert from 'String' to 'Float'"
				// https://github.com/HaxeFoundation/haxe/issues/11235
				tree[0][0] = Std.string(tree[0][0]) + "who fancies boys?";
			}
			else if (PlayerData.sexualPreference == PlayerData.SexualPreference.Girls)
			{
				// The explicit 'Std.string()' call is a workaround for Haxe issue #11235; generated .cpp files have conversion errors, "cannot convert from 'String' to 'Float'"
				// https://github.com/HaxeFoundation/haxe/issues/11235
				tree[0][0] = Std.string(tree[0][0]) + "who fancies girls?";
			}
			else
			{
				// The explicit 'Std.string()' call is a workaround for Haxe issue #11235; generated .cpp files have conversion errors, "cannot convert from 'String' to 'Float'"
				// https://github.com/HaxeFoundation/haxe/issues/11235
				tree[0][0] = Std.string(tree[0][0]) + "who's aroused by all sorts of things?";
			}
			DialogTree.replace(tree, 0, "boy... who fancies boys", "boy... who fancies other boys");
			DialogTree.replace(tree, 0, "girl... who fancies girls", "girl... who fancies other girls");

			// ...would that mean you consider yourself gay?
			var guess:String = "bisexual";
			if (PlayerData.gender == PlayerData.Gender.Boy)
			{
				if (PlayerData.sexualPreference == PlayerData.SexualPreference.Boys)
				{
					guess = "gay";
				}
				else if (PlayerData.sexualPreference == PlayerData.SexualPreference.Girls)
				{
					guess = "straight";
				}
			}
			else if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				if (PlayerData.sexualPreference == PlayerData.SexualPreference.Boys)
				{
					guess = "straight";
				}
				else if (PlayerData.sexualPreference == PlayerData.SexualPreference.Girls)
				{
					guess = "a lesbian";
				}
			}
			tree[1] = ["#grov05#...Would that mean you consider yourself " + guess + "?"];
			tree[2] = [20, 40, 60, 80, 100];
			if (PlayerData.gender == PlayerData.Gender.Boy)
			{
				tree[2].remove(40);
			}
			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				tree[2].remove(20);
			}
			if (guess == "gay")
			{
				if (tree[2].remove(20))
				{
					tree[2].insert(0, 10);
				}
			}
			else if (guess == "a lesbian")
			{
				if (tree[2].remove(40))
				{
					tree[2].insert(0, 30);
				}
			}
			else if (guess == "straight")
			{
				if (tree[2].remove(60))
				{
					tree[2].insert(0, 50);
				}
			}
			else if (guess == "bisexual")
			{
				if (tree[2].remove(80))
				{
					tree[2].insert(0, 70);
				}
			}

			tree[10] = ["Yes, I'm\ngay"];
			tree[11] = [21];
			tree[20] = ["Actually,\nI'm gay"];
			tree[21] = ["%labelgay%"];
			tree[22] = ["#grov02#Ah!! So you're gay, are you. Can't blame you there, dicks are pretty great aren't they!"];
			if (PlayerData.grovMale)
			{
				tree[23] = ["#grov04#I'm not actually gay. Well I wouldn't consider myself much of anything really,"];
				tree[24] = [125];
			}
			else
			{
				tree[23] = ["#grov04#Rather splendid of you to experiment with girls, too!"];
				tree[24] = ["#grov03#Of course I know this only half-counts, but still. Cheers for keeping an open mind there."];
				tree[25] = [120];
			}

			tree[30] = ["Yes, I'm\na lesbian"];
			tree[31] = [41];
			tree[40] = ["Actually,\nI'm a\nlesbian"];
			tree[41] = ["%labelles%"];
			tree[42] = ["#grov02#Ah!! So you're a lesbian, are you. Can't blame you there, boobs are pretty fantastic aren't they!"];
			if (PlayerData.grovMale)
			{
				tree[43] = ["#grov04#Rather splendid of you to experiment with boys, too!"];
				tree[44] = ["#grov03#Of course I know this only half-counts, but still. Cheers for keeping an open mind there."];
				tree[45] = [120];
			}
			else
			{
				tree[43] = ["#grov04#I'm not actually a lesbian. Well I wouldn't consider myself much of anything really,"];
				tree[44] = [125];
			}

			tree[50] = ["Yes, I'm\nstraight"];
			tree[51] = [61];
			tree[60] = ["Actually,\nI'm\nstraight"];
			tree[61] = ["%labelstr%"];
			if (PlayerData.gender == PlayerData.Gender.Boy)
			{
				tree[62] = ["#grov02#Ah!! So you're straight, are you. Can't blame you there, boobs are pretty fantastic aren't they!"];
				tree[63] = [64];
			}
			else if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				tree[62] = ["#grov02#Ah!! So you're straight, are you. Can't blame you there, dicks are pretty great aren't they!"];
				tree[63] = [64];
			}
			else
			{
				tree[62] = ["#grov02#Ah!! So you're straight, are you. Can't blame you there, the-- well umm.... the opposite gender is pretty great isn't it!"];
				tree[63] = ["#grov03#Yes, that's right, those opposite gender folks what with their... opposing genitals and all? Whichever those are. Yes, that's it. A-hem."];
			}
			tree[64] = ["#grov04#I'm not actually straight. Well I wouldn't consider myself much of anything really,"];
			tree[65] = [120];

			tree[70] = ["Yes, I'm\nbisexual"];
			tree[71] = [81];

			tree[80] = ["Actually,\nI'm\nbisexual"];
			tree[81] = ["%labelbis%"];
			tree[82] = ["#grov02#Ah!! So you're bisexual, are you."];
			tree[83] = ["#grov04#Makes sense to me, sexuality is an interwoven tapestry of complex thoughts and feelings. Why reject someone simply based on their gender?"];
			tree[84] = ["#grov03#I suppose if labels were absolutely necessary, one might call me 'bisexual' as well."];
			tree[85] = [125];

			tree[100] = ["Actually,\nit's\ncomplicated"];
			tree[101] = ["#grov02#Ah!! So it's complicated, is it."];
			tree[102] = ["%labelcom%"];
			tree[103] = ["#grov04#Makes sense to me, sexuality is a complicated tapestry of thoughts and feelings. Why reject someone simply based on their gender?"];
			tree[104] = ["#grov03#I suppose when labels are absolutely necessary, people resort to labelling you as 'bisexual'. Some might call me 'bisexual' as well."];
			tree[105] = [120];

			// Most recent reference was to the player's gender
			tree[120] = ["#grov06#Personally I'm not much for defining anybody as '" + guess + "'."];
			tree[121] = ["#grov04#I sort of resent how language has eroded something as beautiful as sexuality into this sort of binary \"does he\" \"doesn't he\" nonsense."];
			tree[122] = ["#grov02#Anyways enough of my droning on, let's move onto a puzzle!"];

			// Most recent reference was to Grovyle's gender
			tree[125] = ["#grov06#Personally I'm not much for defining anybody as '" + guess + "'."];
			tree[126] = ["#grov04#I sort of resent how language has eroded something as beautiful as sexuality into this sort of binary \"does he\" \"doesn't he\" nonsense."];
			tree[127] = [122];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 121, "\"does he\" \"doesn't he\"", "\"does she\" \"doesn't she\"");
			}

			if (!PlayerData.grovMale)
			{
				DialogTree.replace(tree, 126, "\"does he\" \"doesn't he\"", "\"does she\" \"doesn't she\"");
			}
		}
		else if (PlayerData.level == 1)
		{
			var ohDidYouHear:String = "\"Oh did you hear? He thought he was bisexual for so long, that poor confused boy.\"";
			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				ohDidYouHear = StringTools.replace(ohDidYouHear, "He thought he", "She thought she");
				ohDidYouHear = StringTools.replace(ohDidYouHear, "confused boy", "confused girl");
			}
			if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				ohDidYouHear = StringTools.replace(ohDidYouHear, "He thought he was", "They thought they were");
				ohDidYouHear = StringTools.replace(ohDidYouHear, "confused boy", "confused fellow");
			}
			if (PlayerData.sexualPreferenceLabel == PlayerData.SexualPreferenceLabel.Gay)
			{
				ohDidYouHear = StringTools.replace(ohDidYouHear, "bisexual", "gay");
			}
			else if (PlayerData.sexualPreferenceLabel == PlayerData.SexualPreferenceLabel.Lesbian)
			{
				ohDidYouHear = StringTools.replace(ohDidYouHear, "bisexual", "a lesbian");
			}
			else if (PlayerData.sexualPreferenceLabel == PlayerData.SexualPreferenceLabel.Straight)
			{
				ohDidYouHear = StringTools.replace(ohDidYouHear, "bisexual", "straight");
			}

			if (PlayerData.sexualPreferenceLabel == PlayerData.SexualPreferenceLabel.Gay)
			{
				tree[0] = ["#grov05#So hypothetical situation, what might you do if one day you did fall in love with a girl?"];
				tree[1] = ["#grov04#Someone who just pushes all your buttons, despite everything you thought you knew about yourself?"];
				tree[2] = ["#grov05#Would you then call yourself bisexual?"];
				tree[10] = ["Yes, I'd\ncall myself\nbisexual"];
				tree[17] = ["No, I'd\nstill call\nmyself\ngay"];
			}
			else if (PlayerData.sexualPreferenceLabel == PlayerData.SexualPreferenceLabel.Lesbian)
			{
				tree[0] = ["#grov05#So hypothetical situation, what might you do if one day you did fall in love with a boy?"];
				tree[1] = ["#grov04#Someone who just pushes all your buttons, despite everything you thought you knew about yourself?"];
				tree[2] = ["#grov05#Would you then call yourself bisexual?"];
				tree[10] = ["Yes, I'd\ncall myself\nbisexual"];
				tree[17] = ["No, I'd\nstill call\nmyself\na lesbian"];
			}
			else if (PlayerData.sexualPreferenceLabel == PlayerData.SexualPreferenceLabel.Straight)
			{
				if (PlayerData.gender == PlayerData.Gender.Boy)
				{
					tree[0] = ["#grov05#So hypothetical situation, what might you do if one day you did fall in love with a boy?"];
				}
				else if (PlayerData.gender == PlayerData.Gender.Girl)
				{
					tree[0] = ["#grov05#So hypothetical situation, what might you do if one day you did fall in love with a girl?"];
				}
				else
				{
					tree[0] = ["#grov05#So hypothetical situation, what might you do if one day you did fall in love with someone of your own gender?"];
				}
				tree[1] = ["#grov04#Someone who just pushes all your buttons, despite everything you thought you knew about yourself?"];
				tree[2] = ["#grov05#Would you then call yourself bisexual?"];
				tree[10] = ["Yes, I'd\ncall myself\nbisexual"];
				tree[17] = ["No, I'd\nstill call\nmyself\nstraight"];
			}
			else
			{
				// bisexual or complicated
				if (PlayerData.gender == PlayerData.Gender.Girl)
				{
					tree[0] = ["#grov04#So hypothetical situation, what might you do if one day you stopped feeling sexually attracted to girls, and only felt attracted to boys?"];
				}
				else if (PlayerData.gender == PlayerData.Gender.Boy)
				{
					tree[0] = ["#grov04#So hypothetical situation, what might you do if one day you stopped feeling sexually attracted to boys, and only felt attracted to girls?"];
				}
				else
				{
					tree[0] = ["#grov05#So hypothetical situation, what might you do if one day you stopped feeling sexually attracted to your own gender?"];
				}
				tree[1] = [2];
				tree[2] = ["#grov05#Would you then call yourself straight?"];
				tree[10] = ["Yes, I'd\ncall myself\nstraight"];
				if (PlayerData.sexualPreferenceLabel == PlayerData.SexualPreferenceLabel.Bisexual)
				{
					tree[17] = ["No, I'd\nstill call\nmyself\nbisexual"];
				}
				else
				{
					tree[17] = ["No, I'd\nstill say it's\ncomplicated"];
				}
			}
			tree[3] = [10, 30, 20, 17, 40];

			// Yes, I'd then call myself gay
			tree[11] = ["#grov02#Well, that's very open-minded of you."];
			tree[12] = ["#grov15#Of course, we don't necessarily live in an open-minded society."];
			tree[13] = ["#grov04#Your family and friends would probably talk about it like you made a mistake. " + ohDidYouHear];
			tree[14] = [50];

			tree[18] = [21];

			tree[20] = ["No, it\ncould\nnever\nhappen"];
			if (PlayerData.sexualPreferenceLabel == PlayerData.SexualPreferenceLabel.Gay)
			{
				tree[21] = ["#grov04#Right, well I understand. You're gay and nothing will ever change that."];
				tree[22] = ["#grov05#You could never meet a girl who would make you think differently."];
			}
			else if (PlayerData.sexualPreferenceLabel == PlayerData.SexualPreferenceLabel.Lesbian)
			{
				tree[21] = ["#grov04#Right, well I understand. You're a lesbian and nothing will ever change that."];
				tree[22] = ["#grov05#You could never meet a boy who would make you think differently."];
			}
			else if (PlayerData.sexualPreferenceLabel == PlayerData.SexualPreferenceLabel.Straight)
			{
				tree[21] = ["#grov04#Right, well I understand. You're straight and nothing will ever change that."];
				if (PlayerData.gender == PlayerData.Gender.Boy)
				{
					tree[22] = ["#grov05#You could never meet a boy who would make you think differently."];
				}
				else if (PlayerData.gender == PlayerData.Gender.Girl)
				{
					tree[22] = ["#grov05#You could never meet a girl who would make you think differently."];
				}
				else
				{
					tree[21] = ["#grov04#Right, well I understand. You're straight and nothing will ever make you think differently."];
					tree[22] = [23];
				}
			}
			else if (PlayerData.sexualPreferenceLabel == PlayerData.SexualPreferenceLabel.Bisexual)
			{
				tree[21] = ["#grov04#Right, well I understand. You're bisexual and nothing will ever make you think differently."];
				tree[22] = [23];
			}
			else
			{
				tree[21] = ["#grov04#Right, well I understand. You're who you are and nothing will ever make you think differently."];
				tree[22] = [23];
			}
			tree[23] = ["#grov15#But well, so what if something ever did make you think differently? Why would that be such a bad thing?"];
			tree[24] = [50];

			tree[30] = ["No, I'd\nkeep it\na secret"];
			tree[31] = ["#grov08#Ah, well that's unfortunate, but I can completely understand feeling a need to keep such things secret."];
			tree[32] = ["#grov14#If you told the truth, your family and friends would probably talk about it like you made a mistake."];
			tree[33] = ["#grov04#" + ohDidYouHear];
			tree[34] = [50];

			tree[40] = ["Let's\nchange the\nsubject"];
			tree[41] = ["#grov10#Ah! I'm sorry, I didn't mean to offend you."];
			tree[42] = ["#grov06#I appreciate how this can be a sensitive topic. Let's just solve another puzzle."];

			tree[50] = ["#grov06#That's the problem I have with labels really."];
			tree[51] = ["#grov15#By pigeonholing ourselves into convenient little compartments, we end up robbing ourselves of life experiences for fear of being judged."];
			tree[52] = ["#grov05#Hmm wait, this is a puzzle game right? Okay, okay let's solve another puzzle."];
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["#grov05#So I'm curious-- how do you personally feel about words like 'gay' and 'bisexual'?"];
			tree[1] = ["#grov03#I understand it may be difficult to answer honestly given how passionate I seem about the subject but... Well, I'll try not to take it personally."];
			tree[2] = [10, 20, 30];

			tree[10] = ["They're\nhelpful"];
			tree[11] = ["#grov02#Well, I suppose I do have to concede that they're occasionally helpful."];
			tree[12] = ["#grov06#I just wish words like that didn't wield so much power over people's behavior. <sigh>"];
			tree[13] = ["#grov08#It pains me to imagine all the people out there who are less happy than they could be. ...Simply because they're nervous about using one word instead of another word."];
			tree[14] = ["#grov04#Ahh well, anyways. ...One last puzzle."];

			tree[20] = ["They're\npointless"];
			tree[21] = ["#grov02#Precisely, they're completely and utterly pointless."];
			tree[22] = ["#grov00#Say! I hope you're not just saying that to get into my pants."];
			tree[23] = ["#grov10#Well, into my underwear I mean. Errr, into my-- Say!! Where did all my clothes go?"];

			tree[30] = ["I don't\ncare"];
			tree[31] = ["#grov02#Hah! Heheheheheh. Well fair enough-"];
			tree[32] = ["#grov05#I appreciate you listening to my little rant even if this sort of thing doesn't mean as much to you as it does to me."];
			tree[33] = ["#grov04#Alright, one last puzzle."];
		}
	}

	public static function ramen(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["#grov04#You know, 200 years ago we didn't call people \"gay\" or \"lesbian\". Because back then \"gay\" wasn't something you were-- it was something you did."];
			tree[1] = ["#grov06#Sort of how, well, we have words for ramen, for eating ramen. If someone eats a lot of ramen, we might say, \"why that fellow eats a lot of ramen.\""];
			tree[2] = ["#grov03#But we wouldn't label him as a ramenite. We'd never seek to categorize our friends by whether they're ramenites or nonramenites."];
			tree[3] = ["#grov02#Heh! Perhaps I'm being confusing. Let me think about how to best explain myself while you work on this puzzle."];
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["#grov05#So out of curiosity, how much ramen do you eat?"];
			tree[1] = [10, 20, 30, 40];

			tree[10] = ["I eat tons\nof ramen"];
			tree[11] = ["#grov02#Ah! So you're a ramenite are you? Hah! Heheh- well no, okay, I'm just teasing."];
			tree[12] = ["#grov03#Can you imagine though? Having to come out of the ramen closet at a young age?"];
			tree[13] = ["#grov15#\"Mom, dad, you may want to be seated. There's something you need to know about me and soup.\""];
			tree[14] = [50];

			tree[20] = ["I eat ramen\nsometimes"];
			tree[21] = ["#grov02#Ah! So you're... bi-ramen. Hah! Heheh- well no, okay I'm just teasing."];
			tree[22] = ["#grov03#Can you imagine though? Having to come out of the ramen closet at a young age?"];
			tree[23] = ["#grov15#\"Mom, dad, you may want to be seated. There's something you need to know about me and soup.\""];
			tree[24] = [50];

			tree[30] = ["I never\neat ramen"];
			tree[31] = ["#grov02#Ah! A non-ramenite. Hah! Heheh- well, no, okay I'm just teasing."];
			tree[32] = ["#grov03#Can you imagine though? If you tried ramen one time and your friends all made a big deal out of it?"];
			tree[33] = ["#grov10#\"Oh!! I thought he was non-ramenite! He tried ramen? This changes everything!\""];
			tree[34] = [50];

			tree[40] = ["It's\ncomplicated"];
			tree[41] = ["#grov10#Ah! I'm sorry, I didn't mean to offend you. I was merely trying to make-"];
			tree[42] = ["#grov07#Wait a minute... Ramen? Complicated!?!"];
			tree[43] = ["#grov03#Alright, alright, very funny."];
			tree[44] = ["#grov04#It seems you're one step ahead of my silly ramen analogy so I won't belabor the point. Let's just try this next puzzle."];

			tree[50] = ["#grov05#Anyways I think it's the same with having sex with boys, girls, both or whichever your preference."];
			tree[51] = ["#grov04#It's just something you do, and maybe something you do all the time or decide to stop doing..."];
			tree[52] = ["#grov05#...and things would be simpler if we stopped trying to label people for it."];
			tree[53] = ["#grov02#Anyways thanks for letting me go on about this. It's just something I had to get off my chest. Let's try this next puzzle."];
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["#grov06#I have to admit though, for all my frustration with labels, \"gay\" is a rather convenient word."];
			tree[1] = ["#grov04#For example, the sentence \"he's gay\". Six letters! Straight and to the point. Well, figuratively speaking."];
			tree[2] = ["#grov05#I don't know how that sentence translates if \"gay\" ceases to be an adjective, and starts being a verb."];
			tree[3] = ["#grov06#What would you say then, instead of \"he's gay\"?"];
			tree[4] = [10, 20, 30, 40];

			tree[10] = ["He\ngays"];
			tree[11] = ["#grov02#\"He gays?\" Hah! Heheheh. Why I love it, it's even simpler."];
			tree[12] = ["#grov03#\"Do you gay?\" \"Why yes, I've been known to gay.\""];
			tree[13] = ["#grov02#\"I'm so sore, I was up all night gaying.\" \"Good heavens, you gayed all over my face.\""];
			tree[14] = ["#grov00#Very well, let's finish this last puzzle so you can gay me."];

			tree[20] = ["He gets\ngay"];
			tree[21] = ["#grov03#\"He gets gay?\" Why that's a little syntactically clunky."];
			tree[22] = ["#grov04#\"Do you get gay?\" \"Why yes, I've been know to get gay.\""];
			tree[23] = ["#grov02#\"I'm so sore, I was up all night... getting gay.\" \"Good heavens, you got gay all over my face.\""];
			tree[24] = ["#grov00#Very well, let's finish this last puzzle so you can... get gay me."];

			tree[30] = ["He does\ngay"];
			tree[31] = ["#grov03#\"He does gay?\" Why that sounds like how a neanderthal might say it."];
			tree[32] = ["#grov14#\"You do gay?\" \"Yes, me do gay.\" \"Me sore, me up all night doing gay.\""];
			tree[33] = ["#grov00#Very well, let's finish this last puzzle so you can... do gay me."];

			tree[40] = ["He fucks\nmen"];
			tree[41] = ["#grov02#Hah! Heheheh. Well, I understand your point. Why do we need a special word for it?"];
			tree[42] = ["#grov03#But you can at least appreciate that it makes communication more efficient, if you need your gay in a hurry. Perhaps in a drive-through or something."];
			tree[43] = ["#grov04#Anyways, one last puzzle. Let's do this!"];

			for (chatIndex in [14, 24, 33])
			{
				if (PlayerData.gender == PlayerData.Gender.Boy)
				{
					if (!PlayerData.grovMale)
					{
						DialogTree.replace(tree, chatIndex, "gay me", "straight me");
					}
				}
				else if (PlayerData.gender == PlayerData.Gender.Girl)
				{
					if (PlayerData.grovMale)
					{
						DialogTree.replace(tree, chatIndex, "gay me", "straight me");
					}
					else
					{
						DialogTree.replace(tree, chatIndex, "gay me", "lesbian me");
					}
				}
				else
				{
					if (!PlayerData.grovMale)
					{
						DialogTree.replace(tree, chatIndex, "gay me", "lesbian me");
					}
				}
			}
		}
	}

	public static function aboutAbra(tree:Array<Array<Object>>, puzzleState:PuzzleState)
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
			tree[0] = ["#grov04#Just curious <name>, what do you think about Abra? You know, first impressions and all that..."];
			tree[1] = [30, 10, 20, 40];

			tree[10] = ["Oh! He\nseems\nnice"];
			tree[11] = ["#grov10#Ah, wow. Nice? You think he's nice? I'm not sure whether that says more about you or him. But, hmm..."];
			tree[12] = ["#grov06#...I've found Abra's been a bit more... snippy with people as of late. Sort of pushing them away. It's a bit of a recent thing, and I'm not sure what to make of it."];
			tree[13] = [50];

			tree[20] = ["Eh, he\nseems\nfine"];
			tree[21] = ["#grov03#Ah, fair enough. ...To me, he seems to be losing his patience with people more, as of late. Perhaps you haven't borne the brunt of it."];
			tree[22] = ["#grov06#...It's a bit of a recent thing, and... I'm not sure exactly what's changed with him? But, Abra wasn't always like this."];
			tree[23] = [50];

			tree[30] = ["Hmm, he\nseems\nannoyed\nwith me"];
			tree[31] = ["#grov06#Ah, sure. He seems to be going through a... bit of a rough patch recently. I'm not sure what it is, but he wasn't always like this."];
			tree[32] = [50];

			tree[40] = ["Ugh, he\nseems\nlike a\ndick"];
			tree[41] = ["#grov06#Ah... a fair assessment. But I assure you, that's not who he is. Or... it's not who he was, anyways..."];
			tree[42] = [50];

			tree[50] = ["#grov05#The two of us go as far back as college, you know. He was my randomly assigned roommate for freshman year and... Well, he didn't have many friends there."];
			tree[51] = ["#grov04#But I welcomed him into my \"circle\" if you will, and he got on just great with everyone. He was a bit of a different Pokemon back then. More socially active, more personable."];
			tree[52] = ["#grov03#I remember he used to constantly wear headphones in the room for listening to music. But... headphones aren't exactly the best social lubricant, hmm?"];
			tree[53] = ["#grov04#So after a bit of coaxing I got him to play his music on speakers instead."];
			tree[54] = ["#grov06#It was this rather... repetitive electronic music which to be honest, I found to be mind-numbingly boring at first listen."];
			tree[55] = ["#grov05#Over time however, it did grow on me. ...It's nice to have something in the background that's not so distracting, particularly for reading or studying."];
			tree[56] = ["#grov02#As for myself, I helped Abra appreciate pop music non-ironically. Hah! Heheheheh. I'm not sure if he's any better for it, but..."];
			tree[57] = ["#grov03#...Well, I can't say I at least didn't leave my mark on him."];
			tree[58] = ["#grov04#Well alright, that's enough of that. Let's try this first puzzle, shall we?"];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 10, "Oh! He", "Oh! She");
				DialogTree.replace(tree, 11, "think he's", "think she's");
				DialogTree.replace(tree, 11, "or him", "or her");
				DialogTree.replace(tree, 20, "Eh, he", "Eh, she");
				DialogTree.replace(tree, 21, "me, he", "me, she");
				DialogTree.replace(tree, 21, "losing his", "losing her");
				DialogTree.replace(tree, 22, "with him", "with her");
				DialogTree.replace(tree, 30, "Hmm, he", "Hmm, she");
				DialogTree.replace(tree, 31, "sure. He", "sure. She");
				DialogTree.replace(tree, 31, "but he", "but she");
				DialogTree.replace(tree, 40, "Ugh, he", "Ugh, she");
				DialogTree.replace(tree, 41, "yes. He", "yes. She");
				DialogTree.replace(tree, 41, "who he", "who she");

				DialogTree.replace(tree, 50, "know. He", "know. She");
				DialogTree.replace(tree, 50, "Well, he", "Well, she");
				DialogTree.replace(tree, 51, "welcomed him", "welcomed her");
				DialogTree.replace(tree, 51, "and he", "and she");
				DialogTree.replace(tree, 51, "everyone. He", "everyone. She");
				DialogTree.replace(tree, 52, "remember he", "remember she");
				DialogTree.replace(tree, 53, "got him", "got her");
				DialogTree.replace(tree, 53, "play his", "play her");
				DialogTree.replace(tree, 56, "if he's", "if she's");
				DialogTree.replace(tree, 57, "on him", "on her");
			}
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["#grov08#So yes, Abra can be a bit insufferable at times but... I'm thinking it's some sort of passing phase."];
			tree[1] = ["#grov06#He didn't used to lash out or diminish people's intelligence the way he does now. The way he acts now is almost like, hmm..."];
			tree[2] = ["#grov08#I'm not sure if you've ever known someone overly clingy, of whom you're not particularly fond... And perhaps you realize well,"];
			tree[3] = ["#grov06#...While you could confront the person directly, that might be awkward. But perhaps if you're just a bit rude to them, or make them feel ignored..."];
			tree[4] = ["#grov08#Perhaps they'll just think you're unpleasant, or perhaps get the hint and leave you alone? ...Does that sound at all familiar?"];
			tree[5] = [40, 20, 30, 50];

			tree[20] = ["Heh, I do\nthat all\nthe time"];
			tree[21] = ["#grov02#Ah yes, it's all too easy isn't it? ...Not that I'd actually condone that sort of abhorrent behavior, but, well. We all do it."];
			tree[22] = [100];

			tree[30] = ["Oh,\nI do that\noccasionally"];
			tree[31] = ["#grov02#Ah yes, it's all too easy isn't it? ...Not that I'd actually condone that sort of abhorrent behavior, but, well. We all do it."];
			tree[32] = [100];

			tree[40] = ["I haven't\ndone that\nin forever"];
			tree[41] = ["#grov05#Mmm, yes. It's a miserable way to be treated, isn't it? So it sounds like you're familiar with the type of behavior to which I'm referring."];
			tree[42] = [100];

			tree[50] = ["I could\nnever do\nthat to\nsomeone"];
			tree[51] = ["#grov05#Mmm, yes. It's a miserable way to be treated, isn't it? ...It at least sounds like you've perhaps been exposed to that type of behavior before."];
			tree[52] = [100];

			tree[100] = ["#grov06#So yes to me, that sort of casual rudeness somewhat reminds me of Abra's abrasive behavior, where--"];
			tree[101] = ["#grov02#...Hah! \"Abra's... abrasive.\" Well, that's cute."];
			tree[102] = ["#grov04#But as I was saying, it reminds me of Abra's err... contemptuous attitude, where... Well, contemptuous is too strong a word..."];
			tree[103] = ["#grov06#Abra's... Hmm..."];
			tree[104] = ["#grov10#... ...Well now I've gone and lost my train of thought."];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 1, "He didn't", "She didn't");
				DialogTree.replace(tree, 1, "way he", "way she");
				DialogTree.replace(tree, 1, "way he", "way she");
			}
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["#grov04#So anyways if Abra seems hostile or impatient towards you... try not to take it personally."];
			tree[1] = ["#grov05#I think Abra actually really, really likes you, <name>. But... at some point he started treating everyone this way."];
			tree[2] = ["#grov08#Like... any time we tried to spend time with him, it felt like we were imposing."];
			tree[3] = ["#grov09#Or any time we made an effort to engage him socially, or have a real conversation it was like..."];
			tree[4] = ["#grov06#It was like he didn't care, as though he's given up on us or something."];
			tree[5] = [30, 10, 20, 40];

			tree[10] = ["As though\nhe's given\nup on me?"];
			tree[11] = [50];

			tree[20] = ["As though\nhe's given\nup on his\nfriends?"];
			tree[21] = [50];

			tree[30] = ["As though\nhe's given\nup on\neveryone in\nthe world?"];
			tree[31] = ["#grov05#Precisely. You, me, everyone. I've tried reaching out to him, but... I don't know. I don't know what to tell him."];
			tree[32] = [51];

			tree[40] = ["As though\nhe's given\nup on life?"];
			tree[41] = ["#grov10#Oh, I wouldn't go that far. He seems, hmm, happy enough as long as we're not disturbing him."];
			tree[42] = ["#grov06#It's just, I've tried reaching out to him and the more of an effort I put forward, the more it feels like he's pushing me away."];
			tree[43] = ["#grov08#But he doesn't seem suicidal, no. Just... constantly frustrated by everyone. Everyone in the entire universe."];
			tree[44] = [52];

			tree[50] = ["#grov09#I mean he's given up on US us. You, me, everyone. I've tried reaching out to him, but... I don't know. I don't know what to tell him."];
			tree[51] = ["#grov08#The more of an effort I put forward, the more it feels like he's pushing me away."];
			tree[52] = ["#grov06#I don't know what he needs. ...Maybe a new career or... new friends? Maybe just spending more time outside his room. I don't know."];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 1, "point he", "point she");
				DialogTree.replace(tree, 2, "with him", "with her");
				DialogTree.replace(tree, 3, "engage him", "engage her");
				DialogTree.replace(tree, 4, "like he", "like she");
				DialogTree.replace(tree, 4, "though he's", "though she's");
				DialogTree.replace(tree, 10, "though\nhe's", "though\nshe's");
				DialogTree.replace(tree, 20, "though\nhe's", "though\nshe's");
				DialogTree.replace(tree, 20, "his\nfriends", "her\nfriends");
				DialogTree.replace(tree, 30, "though\nhe's", "though\nshe's");
				DialogTree.replace(tree, 31, "to him", "to her");
				DialogTree.replace(tree, 31, "tell him", "tell her");
				DialogTree.replace(tree, 40, "though\nhe's", "though\nshe's");
				DialogTree.replace(tree, 41, "far. He", "far. She");
				DialogTree.replace(tree, 41, "disturbing him", "disturbing her");
				DialogTree.replace(tree, 42, "to him", "to her");
				DialogTree.replace(tree, 42, "like he's", "like she's");
				DialogTree.replace(tree, 43, "But he", "But she");
				DialogTree.replace(tree, 50, "mean he's", "mean she's");
				DialogTree.replace(tree, 50, "to him", "to her");
				DialogTree.replace(tree, 50, "tell him", "tell her");
				DialogTree.replace(tree, 51, "like he's", "like she's");
				DialogTree.replace(tree, 52, "what he", "what she");
				DialogTree.replace(tree, 52, "outside his", "outside her");
			}
		}
	}

	static private function appendRubSuggestions(tree:Array<Array<Object>>, branchIndex:Int, badOriginal:String, badOriginalVerb):Void
	{
		tree[branchIndex] = [50, 100, 150, 200];
		tree[branchIndex][0] = FlxG.random.getObject([50, 60, 70]);
		tree[branchIndex][1] = FlxG.random.getObject([100, 110, 120]);
		tree[branchIndex][2] = FlxG.random.getObject([150, 160, 170, 180]);
		tree[branchIndex][3] = FlxG.random.getObject([200, 210, 220]);

		var good0:String = "neck";
		var good1:String = "belly";

		if (tree[branchIndex][0] == 50)
		{
			good0 = "neck";
		}
		if (tree[branchIndex][0] == 60)
		{
			good0 = "shoulders";
		}
		if (tree[branchIndex][0] == 70)
		{
			good0 = "chest";
		}

		if (tree[branchIndex][1] == 100)
		{
			good1 = "belly";
		}
		if (tree[branchIndex][1] == 110)
		{
			good1 = "legs";
		}
		if (tree[branchIndex][1] == 120)
		{
			good1 = "head";
		}

		FlxG.random.shuffle(tree[branchIndex]);

		tree[50] = ["Like your\nneck?"];
		tree[51] = ["#grov00#Mmmm yes, precisely, I love having my neck rubbed! Let's give Grovyle some extra neck rubs today."];
		tree[52] = ["#grov04#My " + badOriginal + " will still be ready for you afterwards~"];

		tree[60] = ["Like your\nshoulders?"];
		tree[61] = ["#grov00#Ooohh <name>, I love a good shoulder massage! Let's spend some extra time relaxing Grovyle's sore shoulders today."];
		tree[62] = ["#grov04#My " + badOriginal + " will still be ready for you afterwards~"];

		tree[70] = ["Like your\nchest?"];
		tree[71] = ["#grov00#Ooohhh yes, I love when people rub my chest. And mmmm.... you can gradually work your hands down..."];
		tree[72] = ["#grov01#Sliding them down my chest, past my belly and hips, to my " + badOriginal + "..."];
		tree[73] = ["#grov00#Oh look at me, I'm like a teacher giving away all the answers before the test starts. I'll let you do your thing~"];

		tree[100] = ["Like your\nbelly?"];
		tree[101] = ["#grov05#Oohh yes! Nothing beats a good belly rub. Now you're thinking."];
		tree[102] = ["#grov00#Let's give Grovyle's belly some extra attention today, hmmm?"];
		tree[103] = ["#grov04#My " + badOriginal + " will still be ready for you afterwards~"];

		tree[110] = ["Like your\nlegs?"];
		tree[111] = ["#grov03#Err, well... Technically below the equator but, why not! Go ahead and rub my legs if you like."];
		tree[112] = ["#grov00#That or my " + good0 + ", whatever suits your fancy. The important thing is to take your time,"];
		tree[113] = ["#grov04#My " + badOriginal + " will still be ready for you afterwards~"];

		tree[120] = ["Like your\nhead?"];
		tree[121] = ["#grov03#My... head? Well sure, you can caress my cheek lovingly, graze your hand against my beak... Rub my little scalp leaf..."];
		tree[122] = ["#grov00#That could be quite romantic if you use the right kind of touch. That sounds quite nice, why don't we try something that today, hmm?"];
		tree[123] = ["#grov04#My " + badOriginal + " will still be ready for you afterwards~"];

		tree[150] = ["Like your\nfeet?"];
		tree[151] = ["#grov15#Feet are... errr... Feet are well within the southern hemisphere."];
		tree[152] = ["#grov04#I know many people would consider a nice footrub to fall within the realm of foreplay but, well,"];
		tree[153] = ["#grov01#Well, my feet are really sensitive."];
		tree[154] = ["#grov05#Maybe start by rubbing my " + good0 + ", or my " + good1 + "... My feet will still be ready for you afterwards~"];

		tree[160] = ["Like your\nballs?"];
		tree[161] = ["#grov15#Balls are... errr... well below the equator I'm afraid,"];
		tree[162] = ["#grov04#I'm not asking you to ignore my balls entirely, just perhaps make yourself acquainted first!"];
		tree[163] = ["#grov05#Start by rubbing my " + good0 + ", or my " + good1 + "... My balls will still be ready for you afterwards~"];
		if (!PlayerData.grovMale)
		{
			DialogTree.replace(tree, 160, "balls", "clitoris");
			DialogTree.replace(tree, 161, "Balls are", "The clitoris falls");
			DialogTree.replace(tree, 162, "balls", "clitoris");
			DialogTree.replace(tree, 163, "balls", "clitoris");
		}

		tree[170] = ["Like your\ndick?"];
		tree[171] = ["#grov14#<name>, my dick is, errr... What exactly did you think I meant by 'below the equator'?"];
		tree[172] = ["#grov04#Now I'm not asking you to ignore my dick entirely, just perhaps make yourself acquainted first!"];
		tree[173] = ["#grov05#Start by rubbing my " + good0 + ", or my " + good1 + "... My dick's not going anywhere~"];
		if (!PlayerData.grovMale)
		{
			DialogTree.replace(tree, 170, "dick", "pussy");
			DialogTree.replace(tree, 171, "dick", "pussy");
			DialogTree.replace(tree, 172, "dick", "pussy");
			DialogTree.replace(tree, 173, "dick", "pussy");
		}

		tree[180] = ["Like your\nass?"];
		tree[181] = ["#grov14#My ass is, errr... What exactly did you think I meant by 'below the equator'?"];
		tree[182] = ["#grov04#Now I'm not asking you to ignore my buttocks entirely, just perhaps make yourself acquainted first!"];
		tree[183] = ["#grov05#Start by rubbing my " + good0 + ", or my " + good1 + "... My butt will still be there later~"];

		tree[200] = ["Like the\nSvalbard\narchipelago?"];
		tree[201] = ["#grov10#..."];
		tree[202] = ["#grov14#Yes, that's EXACTLY what I meant. Go explore the Svalbard archipelago, then come back and " + badOriginalVerb + " afterwards."];
		tree[203] = ["#grov13#...Because when I'm thinking foreplay, that's exactly what I'm envisioning-- a multi-night excursion around the arctic."];
		tree[204] = ["#grov07#Goodness, you're impossible sometimes."];
		tree[205] = ["#grov05#I was thinking more, errr-- start by rubbing my " + good0 + " or my " + good1 + "... Then you can " + badOriginalVerb + "... and afterwards,"];
		tree[206] = ["#grov02#Afterwards perhaps you can explore the Svalbard Archipelago if it intrigues you so much, eh?"];

		tree[210] = ["Like the\nMarianas\nTrench?"];
		tree[211] = ["#grov10#..."];
		tree[212] = ["#grov13#Ah of course, OF COURSE that's what I meant. Go explore the Marianas Trench, then come back and " + badOriginalVerb + " afterwards."];
		tree[213] = ["#grov06#Unless, wait, is that a euphamism for the buttocks? Did you mean you wanted to, explore inside my--"];
		if (!PlayerData.grovMale)
		{
			DialogTree.replace(tree, 213, "buttocks", "pussy");
		}
		tree[214] = ["#grov13#WELL THAT'S ALSO A NONSTARTER, my Marianas Trench is very sensitive! The LEAST you can do is warm me up first!!"];
		tree[215] = ["#grov15#You know, rub my " + good0 + " or my " + good1 + "..."];
		tree[216] = ["#grov04#My, err, my Marianas Trench will still be ready for you afterwards~"];
		tree[217] = ["#grov07#(...Goodness, do we really have to call it that?!)"];

		tree[220] = ["Like the\nGreat Barrier\nReef?"];
		tree[221] = ["#grov10#..."];
		tree[222] = ["#grov13#I said ABOVE the equator! ABOVE!!"];
		tree[223] = ["#grov12#The Great Barrier Reef lies somewhere off the coast of Australia. I mean look at me, I'm from Hoenn and even I know that much! ...I shouldn't even know what Australia is!"];
		tree[224] = ["#grov06#A-hem anyway, I was thinking more, errr-- start by rubbing my " + good0 + " or my " + good1 + "... Then you can " + badOriginalVerb + "... and afterwards,"];
		tree[225] = ["#grov03#Afterwards perhaps you can explore the Great Barrier Reef if it intrigues you so much, eh?"];
		tree[226] = ["#grov02#...In the SOUTHERN hemisphere."];
	}

	public static function firstRankChanceOther(tree:Array<Array<Object>>)
	{
		tree[0] = ["%entergrov%"];
		tree[1] = ["#grov04#Ah, <name>! Sorry to interrupt-- but this is your first \"Rank Chance\" isn't it?"];
		var englishRank:String = englishNumber(RankTracker.computeAggregateRank());
		tree[2] = ["#grov05#If you accept this rank chance, your rank will increase or decrease depending on how quickly you solve this puzzle! If you decline, you'll just stay at rank " + englishRank + "."];
		tree[3] = ["#grov02#Rank is just a number! It doesn't actually affect anything. It's simply up to you whether or not you feel like being evaluated right now."];
		tree[4] = ["#grov04#Anyways I'll leave you to it!"];
		tree[5] = ["%exitgrov%"];
		tree[10000] = ["%exitgrov%"];
	}

	public static function firstRankChanceGrovyle(tree:Array<Array<Object>>)
	{
		tree[0] = ["#grov04#Ah! This is your first \"Rank Chance\" isn't it?"];
		var englishRank:String = englishNumber(RankTracker.computeAggregateRank());
		tree[1] = ["#grov05#If you accept this rank chance, your rank will increase or decrease depending on how quickly you solve this puzzle! If you decline, you'll just stay at rank " + englishRank + "."];
		tree[2] = ["#grov02#Rank is just a number! It doesn't actually affect anything. It's simply up to you whether or not you feel like being evaluated right now."];
		tree[3] = ["#grov03#Err, so anyways..."];
	}

	public static function firstRankDefendOther(tree:Array<Array<Object>>)
	{
		tree[0] = ["%entergrov%"];
		tree[1] = ["#grov04#Oh, pardon me <name>! Sorry again to interrupt-- but this is your first time defending your rank, isn't it?"];
		var englishRank:String = englishNumber(RankTracker.computeAggregateRank());
		tree[2] = ["#grov10#So, your rank can't increase, no matter how quickly you solve this puzzle. And your rank might even drop if you're too slow!"];
		tree[3] = ["#grov06#However if you decline, you'll be asked to defend your rank again later. You need to successfully defend your rank or you'll be stuck at rank " + englishRank + " indefinitely..."];
		tree[4] = ["#grov03#Anyways I'll leave you to it!"];
		tree[5] = ["%exitgrov%"];
		tree[10000] = ["%exitgrov%"];
	}

	public static function firstRankDefendGrovyle(tree:Array<Array<Object>>)
	{
		tree[0] = ["#grov04#Oh! This is your first time defending your rank, isn't it?"];
		tree[1] = ["#grov10#So, your rank can't increase, no matter how quickly you solve this puzzle. And your rank might even drop if you're too slow!"];
		var englishRank:String = englishNumber(RankTracker.computeAggregateRank());
		tree[2] = ["#grov06#However if you decline, you'll be asked to defend your rank again later. You need to successfully defend your rank or you'll be stuck at rank " + englishRank + " indefinitely..."];
		tree[3] = ["#grov03#Err, so anyways,"];
	}

	public static function checkPassword(dialogTree:DialogTree, dialogger:Dialogger, text:String):Void
	{
		var password:Password = new Password(dialogger.getReplacedText("<good-name>"), text);
		var mark:String = null;
		if (text == null || text.length == 0)
		{
			// empty password
			mark = mark != null ? mark : "%mark-664xvle5%";
		}
		if (text.length < 18)
		{
			// short password
			mark = mark != null ? mark : "%mark-k9hftkyn%";
		}
		if (!password.isValid())
		{
			// invalid password
			if (FlxG.random.bool(20))
			{
				// playful... wrong name
				mark = mark != null ? mark : "%mark-wab1rky5%";
				var randomNames:Array<String> = [
					"Gabriel", "Joe", "Ethan", "Madison", "Alice",
					"Nicholas", "Martha", "Frank", "Dylan", "Ann",
					"Shirley", "Henry", "Joan", "Vincent", "Mary",
					"Susan", "Brian", "Kathleen", "Sharon", "Noah",
					"Johnny", "Laura", "Jordan", "Lori", "Christina",
					"Gerald", "Jane", "Katherine", "Keith", "Justin",
					"Kelly", "Margaret", "James", "Eugene", "Abigail",
					"Helen", "Michelle", "Timothy", "Samuel", "Robert",
					"Ruth", "Ryan", "Marie", "Joshua", "Louis",
					"Diana", "Adam", "Andrew", "Deborah", "Carolyn"
				];
				randomNames.remove(dialogger.getReplacedText("<good-name>"));
				dialogger.setReplacedText("<random-name>", FlxG.random.getObject(randomNames));
			}
			else
			{
				mark = mark != null ? mark : "%mark-wab1rky6%";
			}
		}

		// valid password
		mark = mark != null ? mark : "%mark-10xom4oy%";

		dialogger.setReplacedText("<password>", text);
		dialogTree.jumpTo(mark);
		dialogTree.go();
	}

	public static function boyOrGirlIntro(tree:Array<Array<Object>>)
	{
		tree[0] = ["%disable-skip%"];
		tree[1] = ["%intro-lights-off%"];
		tree[2] = ["#grov04#Hello! Before we get started, I should ask... Are you a boy or a girl?"];
		tree[3] = [10, 20, 30, 40];

		tree[10] = ["I'm a\nboy"];
		tree[11] = ["%gender-boy%"];
		tree[12] = [100];

		tree[20] = ["I'm a\ngirl"];
		tree[21] = ["%gender-girl%"];
		tree[22] = [100];

		tree[30] = ["I'm not\nsure"];
		tree[31] = ["%gender-complicated%"];
		tree[32] = ["#grov10#Ah, you're not... you're not sure whether you're a boy or a girl?"];
		tree[33] = ["#grov02#...Err, well, I suppose I'll give you a moment to check. Go on, take a good look down there."];
		tree[34] = [50, 60, 70, 80];

		tree[40] = ["It's\ncomplicated"];
		tree[41] = ["%gender-complicated%"];
		tree[42] = ["#grov06#Ah, I understand. Gender can be a complicated issue sometimes. Come to think of it, I'm struggling to remember... Am I a boy or a girl!?!"];
		tree[43] = [110, 120, 130, 140];

		tree[50] = ["Okay I'm a\nboy"];
		tree[51] = ["%gender-boy%"];
		tree[52] = [100];

		tree[60] = ["Okay I'm a\ngirl"];
		tree[61] = ["%gender-girl%"];
		tree[62] = [100];

		tree[70] = ["Okay I'm still\nnot sure"];
		tree[71] = ["%gender-complicated%"];
		tree[72] = ["#grov10#Ah, so you didn't find any, um... that is to say... err... well then. Did you look in the right place!?"];
		tree[73] = ["#grov06#Although come to think of it, I'm struggling to remember... Am I a boy or a girl!?!"];
		tree[74] = [110, 120, 130, 140];

		tree[80] = ["Okay it's\ncomplicated"];
		tree[81] = ["%gender-complicated%"];
		tree[82] = ["#grov11#Com... Complicated!?! Dear goodness, what on earth did you FIND???"];
		tree[83] = ["#grov10#Nevermind, nevermind, I'd rather not know. Gender can be a complicated issue sometimes."];
		tree[84] = ["#grov06#Come to think of it, I'm struggling to remember... Am I a boy or a girl!?!"];
		tree[85] = [110, 120, 130, 140];

		tree[100] = ["#grov06#Ah, splendid! Although come to think of it, I'm struggling to remember.... Am I a boy or a girl!?!"];
		tree[101] = [110, 120, 130, 140];

		tree[110] = ["I hope you're\na boy"];
		tree[111] = ["%sexualpref-boys%"];
		tree[112] = [200];

		tree[120] = ["I hope you're\na girl"];
		tree[121] = ["%sexualpref-girls%"];
		tree[122] = [200];

		tree[130] = ["I don't mind\neither way"];
		tree[131] = ["%sexualpref-both%"];
		tree[132] = [200];

		tree[140] = ["I hope you're\ncomplicated"];
		tree[141] = ["%sexualpref-idiot%"];
		tree[142] = ["#grov02#Well... I assure you I'm not complicated in that regard! My genitals are most definitely that of a girl... or maybe a boy!!"];
		tree[143] = ["#grov03#That is, it's slipped my mind at the moment but I'm quite certain I have ONE of those two, err, pieces of equipment... down there..."];
		tree[144] = [150, 160, 170, 180];

		var randomStuff:Array<String> = ["a\ntrampoline", "a\ndishwasher", "a\ncalculator", "a\nsaxophone", "a\nplunger", "a\nchainsaw", "a\nrabid wombat", "an\nextra kidney"];
		FlxG.random.shuffle(randomStuff);

		tree[150] = ["You have a\npenis\ndown there"];
		tree[151] = [111];

		tree[160] = ["You have a\nvagina\ndown there"];
		tree[161] = [121];

		tree[170] = ["I don't mind\neither way"];
		tree[171] = [131];

		tree[180] = ["You have " + randomStuff[0] + "\ndown there"];
		tree[181] = ["%sexualpref-idiot%"];
		tree[182] = [200];

		tree[200] = ["%sexualsummary0%"];
		tree[201] = ["%sexualsummary1%"];
		tree[202] = [210, 220, 230, 240];

		tree[210] = ["Yes, that's\nright"];
		tree[211] = ["#grov02#Excellent! Now let's see if I can get these lights on..."];
		tree[212] = ["%intro-lights-on%"];
		tree[213] = ["%enable-skip%"];

		tree[220] = ["Hmm... that's\nnot right"];
		tree[221] = ["#grov04#Oops very well, let's go through this again! ...So first off, are you a boy or a girl?"];
		tree[222] = [10, 20, 30, 40];

		tree[230] = ["Do you\nremember\nwho I am?"];
		tree[231] = [300];

		tree[240] = ["We've\nactually\nmet before..."];
		tree[241] = [300];

		tree[300] = ["#grov10#Ah well, err... Of course I remember! ...I have a remarkable knack for names, you know-- I've literally never forgotten a name."];
		tree[301] = ["#grov06#Yours is right on the top of my tongue... Hmm, hmm... You must be, err..."];
		tree[302] = [310, 315, 330];

		tree[310] = ["My name\nis..."];
		tree[311] = ["%prompt-name%"];

		tree[315] = ["Do you\nwant me to\ntell you?"];
		tree[316] = ["#grov10#No, no, I remember! I really do. It's just difficult without your face. But your name is definitely mmmm... Let me think... ..."];
		tree[317] = [310, 320, 330];

		tree[320] = ["I can't\nbelieve you\nforgot my\nname, Grovyle"];
		tree[321] = ["#grov11#Ack! ...No, why, how rude would that be if you remembered my name... but I forgot yours? Of course I remember!"];
		tree[322] = ["#grov06#It definitely starts with... a letter N... or perhaps an A, was it? Am I getting warmer or colder?"];
		tree[323] = [310, 325, 330];

		tree[325] = ["You really\nforgot"];
		tree[326] = ["#grov03#Ahh I had you going! Of course I remembered YOUR name. You're umm... that guy! That guy with the really memorable name."];
		tree[327] = ["#grov06#That name with all the letters in it... Some pointy letters, and some round ones... All those letters! ... ...Ack, I'll be so embarrassed when I finally remember..."];
		tree[328] = [310, 315, 330];

		tree[330] = ["Nevermind,\nwe actually\nhaven't met"];
		tree[331] = ["#grov03#Ah, of course we haven't! ...Was that some sort of a test? ... ...Did I pass?"];
		tree[332] = ["#grov02#Anyways, let's see about getting these lights on..."];
		tree[333] = ["%intro-lights-on%"];
		tree[334] = ["%enable-skip%"];

		// no name
		tree[400] = ["%mark-cdjv0kpk%"];
		tree[401] = ["#grov05#Err? Why it sounded like you were about to say something... Not that I need any help! Your name is definitely, err..."];
		tree[402] = [310, 315, 330];

		// invalid name
		tree[410] = ["%mark-5w2p2vmw%"];
		tree[411] = ["%mark-zs7y5218%"];
		tree[412] = ["%mark-agdjhera%"];
		tree[413] = ["%mark-7hoh545f%"];
		tree[414] = ["#grov04#No, no... THAT definitely wasn't it, I would have never remembered a name like that. Your name was something much more memorable."];
		if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			tree[415] = ["#grov06#I think I remember that it rhymed with a part of the male anatomy... Nicole? ...Doloreskin? Hmmm, hmmm. It's coming to me..."];
		}
		else
		{
			tree[415] = ["#grov06#I think I remember that it rhymed with a part of the male anatomy... Jacques? ...Ernesticle? Hmmm, hmmm. It's coming to me..."];
		}
		tree[416] = [310, 315, 330];

		// someone else's name
		tree[420] = ["%mark-ijrtkh6l%"];
		tree[421] = ["#grov13#You are NOT... That is NOT your name!! No! ...Bad! That's such a... You are the sneakiest little... Grrrggghhh!!!"];
		tree[422] = ["#grov12#I'm not sure if if I even want to play with you anymore, you sneaky little rascal. ...Pretending you're <random-name>... Hmph!"];
		tree[423] = ["#grov06#... ...I'm just going to proceed with the tutorial, and we can pretend this never happened-"];
		tree[424] = ["#grov12#-and perhaps YOU can stop trying to break this cute little game with your unwelcome shenanigans! Hmph! Hmph!!"];
		tree[425] = ["#grov03#Aaaanyways, let's see if we can get these lights on and put this whole incident behind us..."];
		tree[426] = ["%intro-lights-on%"];
		tree[427] = ["%enable-skip%"];

		// good name
		tree[450] = ["%mark-79gi267d%"];
		tree[451] = ["#grov06#<good-name>? <good-name>... Err... ... ...Hmmmmm..."];
		tree[452] = ["#grov08#Very well, you've caught me. ...I've COMPLETELY forgotten your name. Dreadfully sorry about this, this almost never happens!"];
		tree[453] = ["#grov05#But errm, I have a remarkable knack for sequences of eighteen alphanumeric characters! ...I never forget a sequence of eighteen alphanumeric characters."];
		tree[454] = ["#grov04#I don't suppose you have something like that? ...Something reminiscent of a password perhaps? I'm quite certain that will serve to jog my memory."];
		tree[455] = [460, 470, 480];

		tree[460] = ["My password\nis..."];
		tree[461] = ["%prompt-password%"];

		tree[465] = ["Oh, I think\nI typed my\npassword\nwrong"];
		tree[466] = ["%prompt-password%"];

		tree[470] = ["Actually,\nI think I\ntyped my\nname wrong"];
		tree[471] = ["%prompt-name%"];

		tree[480] = ["I don't have\nanything\nlike that"];
		tree[481] = ["#grov02#Ah, well that's fine. We can do this the old-fashioned way! Let me see about getting these lights on..."];
		tree[482] = ["%intro-lights-on%"];
		tree[483] = ["%enable-skip%"];

		tree[485] = ["Nevermind,\nlet's just do\nthe tutorial"];
		tree[486] = [481];

		tree[500] = ["%mark-664xvle5%"]; // empty password
		tree[501] = ["#grov08#Coming up empty, hmm? ...Well that's a bit of a disappointment."];
		tree[502] = ["#grov04#If you could just remember that eighteen character sequence, I'm certain it would jog my memory. ...I never forget a sequence of eighteen alphanumeric characters!"];
		tree[503] = [460, 470, 480];

		tree[510] = ["%mark-k9hftkyn%"]; // short password
		tree[511] = ["#grov06#Errm, perhaps my kindergarten counting skills have grown rusty from disuse, but I don't think that was eighteen characters."];
		tree[512] = ["#grov04#I'm going to need all eighteen characters in your password to help distinguish you from all the other <good-name>s! ...Do you have that written down somewhere?"];
		tree[513] = [460, 470, 480];

		tree[520] = ["%mark-wab1rky5%"]; // someone else's password
		tree[521] = ["#grov02#Ah yes, <random-name>! Of course! ...I believe Abra unceremoniously stuffed your belongings in a closet somewhere back here..."];
		tree[522] = ["#grov06#But... Why did you change your name from <random-name> to <good-name>? Unless.... Hmmm..."];
		tree[523] = ["#grov12#Say! You're not actually <random-name> at all, are you? Hmph!!"];
		tree[524] = ["#grov13#Where did you find their eighteen character sequence, hmmmm? Did you randomly guess it, or were you snooping through their things? Hmph! Hmph I say."];
		tree[525] = ["#grov14#...I need YOUR personal eighteen character sequence, <good-name>. Not <random-name>'s."];
		tree[526] = [460, 470, 480];

		tree[530] = ["%mark-wab1rky6%"]; // invalid password
		tree[531] = ["#grov06#Hmm. <password>.... <password>... No, that's not ringing any bells."];
		tree[532] = ["#grov04#You're <good-name>, and your password is <password>? ...Are you certain you typed all of that correctly?"];
		tree[533] = ["#grov05#Or hmmm, sometimes if a 5 has too much to drink, it can start looking like an S... Perhaps something like that?"];
		tree[534] = [465, 470, 485];

		tree[550] = ["%mark-10xom4oy%"]; // valid password
		tree[551] = ["%set-name%"];
		tree[552] = ["%set-password%"];
		tree[553] = ["#grov02#Ah yes, <good-name>! Of course! ...I believe Abra unceremoniously stuffed your belongings in a closet somewhere back here..."];
		tree[554] = ["%intro-lights-on%"];
		tree[555] = ["%enterabra%"];
		tree[556] = ["#grov05#Abra! ...Wouldn't you believe it? <good-name>'s returned to play with us!"];
		tree[557] = ["#abra02#Hmm? ...Oh, <good-name>! I hadn't seen you in awhile."];
		tree[558] = ["%exitabra%"];
		tree[559] = ["#abra05#...Give me a moment and I'll get your things back the way you had them, alright?"];
		tree[560] = ["%enable-skip%"];
		tree[561] = ["%jumpto-skipwithpassword%"];

		tree[10000] = ["%intro-lights-on%"];
		tree[10001] = ["%enable-skip%"];

		if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			DialogTree.replace(tree, 326, "that guy! That guy", "that girl! That girl");
		}
	}

	public static function sexualSummary(Msg:String):String
	{
		var prefix0:String = "#grov04#";
		var str0:String = "Yes, yes, very good-- so you're a boy... and you're hoping that I'm a boy.";
		var prefix1:String = "#grov05#";
		var str1:String = "You're... You're a boy who prefers the company of boys! Is that correct?";

		if (PlayerData.gender == PlayerData.Gender.Boy)
		{
			// default is fine
		}
		else if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			str0 = StringTools.replace(str0, "you're a boy", "you're a girl");
			str1 = StringTools.replace(str1, "You're a boy", "You're a girl");
		}
		else {
			str0 = StringTools.replace(str0, "you're a boy", "you're maybe a boy or a girl");
			str1 = StringTools.replace(str1, "You're a boy", "You're a boy or girl");
		}

		if (PlayerData.sexualPreference == PlayerData.SexualPreference.Boys)
		{
			// default is fine
		}
		else if (PlayerData.sexualPreference == PlayerData.SexualPreference.Girls)
		{
			str0 = StringTools.replace(str0, "I'm a boy", "I'm a girl");
			str1 = StringTools.replace(str1, "of boys", "of girls");
		}
		else if (PlayerData.sexualPreference == PlayerData.SexualPreference.Both)
		{
			str0 = StringTools.replace(str0, "you're hoping that I'm a boy", "you don't care whether I'm a boy or a girl");
			str1 = StringTools.replace(str1, "of boys", "of boys and girls");
		}
		else if (PlayerData.sexualPreference == PlayerData.SexualPreference.Idiot)
		{
			str0 = StringTools.replace(str0, "you're hoping that I'm a boy", "you're an asshat");
			str1 = StringTools.replace(str1, "who prefers the company of boys", "who prefers to act like a total asshat");
			prefix0 = "#grov12#";
			prefix1 = "#grov13#";
		}

		if (PlayerData.gender == PlayerData.Gender.Boy && PlayerData.sexualPreference == PlayerData.SexualPreference.Boys)
		{
			str1 = StringTools.replace(str1, "of boys", "of other boys");
		}
		else if (PlayerData.gender == PlayerData.Gender.Girl && PlayerData.sexualPreference == PlayerData.SexualPreference.Girls)
		{
			str1 = StringTools.replace(str1, "of girls", "of other girls");
		}
		else if (PlayerData.gender == PlayerData.Gender.Complicated && PlayerData.sexualPreference == PlayerData.SexualPreference.Both)
		{
			str1 = StringTools.replace(str1, "You're... You're", "Goodness, you're...");
			str1 = StringTools.replace(str1, "correct?", "correct!?");
			prefix0 = "#grov03#";
			prefix1 = "#grov06#";
		}

		if (str0.length + str1.length > 180)
		{
			// too big for one message
			if (Msg == "%sexualsummary0%")
			{
				return prefix0 + str0;
			}
			else
			{
				return prefix1 + str1;
			}
		}
		else {
			if (Msg == "%sexualsummary0%")
			{
				return null;
			}
			else {
				return prefix1 + str0 + " " + str1;
			}
		}
	}

	public static function abraIntro(tree:Array<Array<Object>>)
	{
		tree[0] = ["%fun-nude0%"];
		tree[1] = ["#grov04#So for each puzzle you solve, I'll-"];
		tree[2] = ["%enterabra%"];
		tree[3] = ["#abra04#Ah, who are you talking to? A new subject?"];
		tree[4] = ["#grov08#Err, well... he's a new friend Abra! ...Please don't call my friends subjects!"];
		tree[5] = ["#abra05#Let's see, I'm reading his neural activity as... average? Average-ish. Hm. Can I have a crack at him? How'd he do on the first puzzle?"];
		tree[6] = ["#grov05#Oh he caught on quite quickly! Though it's only been one puzzle, he seems sharp and--"];
		tree[7] = ["#grov10#--well actually, can't you leave us for a moment? I sort of like this person, and I don't want you scaring him away with your... incessant probing and snarky comments."];
		tree[8] = ["#abra12#..."];
		tree[9] = ["%exitabra%"];
		tree[10] = ["#abra04#Hmph. Well, whenever he's ready."];
		tree[11] = [40, 50, 70, 60, 30];

		tree[30] = ["I wouldn't\nmind some\n\"incessant\nprobing\""];
		tree[31] = ["#grov10#Ah! No, that's not--"];
		tree[32] = ["#grov06#I didn't mean the fun kind of probing. Rather, he's always... evaluating people, scanning their thoughts."];
		tree[33] = ["#grov01#..."];
		tree[34] = ["#grov00#...So you're into... \"probing\", are you?"];
		tree[35] = ["#grov04#Err, well, I suppose that brings me to my next topic... For each puzzle you solve, I'll remove an article of clothing..."];
		tree[36] = [101];

		tree[40] = ["...I'm only\naverage\n-ish?"];
		tree[41] = ["#grov06#Ah don't, don't mind him. Abra's incredibly bright, but also a little bit hmm... How can I put this..."];
		tree[42] = ["#grov02#...Well he's also a little bit of a total cock. There's a reason I was keeping the two of you separated for the moment!"];
		tree[43] = [100];

		tree[50] = ["...I seem\nsharp?"];
		tree[51] = ["#grov01#Ah well, I um..."];
		tree[52] = ["#grov00#It's just, usually when I go through these introductory puzzles I have to do a lot of explaining, a lot of backtracking..."];
		tree[53] = ["#grov01#But you just sort of seem to \"get it\"! ...It's nice for a change..."];
		tree[54] = [100];

		tree[60] = ["But I'm\nready\nnow!"];
		tree[61] = ["#grov10#Ah don't... Just give me two more puzzles with you first! I'm worried Abra might scare you away."];
		tree[62] = ["#grov06#He's incredibly bright, but also a little bit, hmm... How can I put this..."];
		tree[63] = [42];

		tree[70] = ["...You\nkind of\nlike me?"];
		tree[71] = [51];

		tree[100] = ["#grov04#Err, so anyways... Yes, for each puzzle you solve, I'll remove an article of clothing..."];
		tree[101] = ["%fun-nude1%"];
		tree[102] = ["#grov02#There we are! ...I'm not wearing much, so hopefully we can stretch out these next few puzzles a bit, yes? Hah! Heheheh."];

		if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			DialogTree.replace(tree, 4, "he's a new", "she's a new");
			DialogTree.replace(tree, 5, "his neural", "her neural");
			DialogTree.replace(tree, 5, "crack at him", "crack at her");
			DialogTree.replace(tree, 5, "How'd he do", "How'd she do");
			DialogTree.replace(tree, 6, "he caught on", "she caught on");
			DialogTree.replace(tree, 6, "he seems sharp", "she seems sharp");
			DialogTree.replace(tree, 7, "scaring him", "scaring her");
			DialogTree.replace(tree, 10, "whenever he's", "whenever she's");
		}
		else if (PlayerData.gender == PlayerData.Gender.Complicated)
		{
			DialogTree.replace(tree, 4, "he's a new", "they're a new");
			DialogTree.replace(tree, 5, "his neural", "their neural");
			DialogTree.replace(tree, 5, "crack at him", "crack at them");
			DialogTree.replace(tree, 5, "How'd he do", "how'd they do");
			DialogTree.replace(tree, 6, "he caught on", "they caught on");
			DialogTree.replace(tree, 6, "he seems sharp", "they seem sharp");
			DialogTree.replace(tree, 7, "scaring him", "scaring them");
			DialogTree.replace(tree, 10, "whenever he's", "whenever they're");
		}
		if (!PlayerData.abraMale)
		{
			DialogTree.replace(tree, 32, "he's always", "she's always");
			DialogTree.replace(tree, 41, "don't mind him", "don't mind her");
			DialogTree.replace(tree, 42, "he's also", "she's also");
			DialogTree.replace(tree, 42, "total cock", "complete clamdangle");
			DialogTree.replace(tree, 42, "from him", "from her");
			DialogTree.replace(tree, 62, "He's incredibly", "She's incredibly");
		}

		tree[10000] = ["%fun-nude1%"];
	}

	public static function nameIntro(puzzleState:PuzzleState, tree:Array<Array<Object>>)
	{
		var awfulName:String = capitalizeWords(FlxG.random.getObject(AWFUL_NAMES));

		tree[0] = ["%fun-nude1%"];
		tree[1] = ["%set-name-" + awfulName + "%"];
		tree[2] = ["%disable-skip%"];
		if (PlayerData.preliminaryName == null)
		{
			tree[3] = ["#grov02#Goodness! You're on a roll now."];
			tree[4] = ["#grov03#Although err... Perhaps before I get FULLY naked I could... get your first name? It's sort of a rule I have..."];
			tree[5] = [20, 25, 10];
		}
		else
		{
			puzzleState._dialogger.setReplacedText("<good-name>", PlayerData.preliminaryName);
			tree[3] = ["#grov02#Goodness! You're on a roll now."];
			tree[4] = [201];
		}

		tree[10] = ["My name\nis..."];
		tree[11] = ["%prompt-name%"];

		tree[20] = ["Don't worry\nabout my name"];
		tree[21] = ["#grov04#Why, it's no trouble! I've actually got a remarkable talent for intuiting names. Let me guess.... Your name is... " + awfulName+  "! " + awfulName + " is it?"];
		tree[22] = [40, 30, 60, 50];

		tree[25] = ["No, I don't\nwant to\ntell"];
		tree[26] = ["#grov04#Ah, well you don't have to TELL me, per se! I've actually got a remarkable talent for intuiting names."];
		tree[27] = ["#grov06#Let me guess.... Your name is... " + awfulName+  "! " + awfulName + " is it?"];
		tree[28] = [40, 30, 60, 50];

		tree[30] = ["No, my\nname is..."];
		tree[31] = ["%prompt-name%"];

		tree[40] = ["Yes, my\nname is\n" + awfulName];
		tree[41] = ["%mark-sovcssrd%"];
		tree[42] = ["#grov02#Ah-ha, I KNEW you struck me as a " + awfulName + "! See, Abra's not the only one capable of reading people's minds. Hah! Heheheh."];
		tree[43] = ["#grov03#So that's one question dealt with, but it raises one further question..."];
		tree[44] = [501];

		tree[50] = ["Isn't " + awfulName + "\na girl's\nname?"];
		tree[51] = ["#grov10#Ahh, well, " + awfulName + " can be a boy's name or a girl's name! It sort of depends."];
		tree[52] = ["#grov08#...Are you telling me your name isn't " + awfulName + "? ...I was so sure! You have some very " + awfulName + "-like qualities about you, you know."];
		tree[53] = [60, 70, 80];

		tree[60] = ["No, " + awfulName + "\nis wrong"];
		tree[61] = ["#grov14#Hmph! Well then, why don't you tell me what's right!"];
		tree[62] = ["%prompt-name%"];

		tree[70] = ["Actually,\nmy name\nIS " + awfulName];
		tree[71] = [41];

		tree[80] = ["No, my\nname is..."];
		tree[81] = ["%prompt-name%"];

		// good name
		tree[200] = ["%mark-79gi267d%"];
		tree[201] = ["#grov05#So your name is \"<good-name>\"? Did I get that right?"];
		tree[202] = [220, 210];

		tree[210] = ["Yes, that's\nright"];
		tree[211] = ["%set-name%"];
		tree[212] = [500];

		tree[220] = ["No, my\nname is..."];
		tree[221] = ["%prompt-name%"];

		// two or more periods
		tree[240] = ["%mark-zs7y5218%"];
		tree[241] = ["#grov08#Really? \"<bad-name>\" is your FIRST name? What sort of mother would name her child \"<bad-name>\"!?"];
		tree[242] = ["#grov10#...Why, I hesitate to even ask about your last name, it's probably got six emojis and a Batman symbol..."];
		tree[243] = ["#grov03#I think I'll just call you <good-name> for short. How do you feel about <good-name>?"];
		tree[244] = [250, 260, 275];

		tree[250] = ["Yes, <good-name>\nis fine"];
		tree[251] = ["%set-name%"];
		tree[252] = [500];

		tree[260] = ["No, but you\ncan call me..."];
		tree[261] = ["%prompt-name%"];

		tree[270] = ["I insist\nyou call me\n<bad-name>!"];
		tree[271] = ["#grov13#I'm not calling you <bad-name>! ...That's NOT a name! I mean, the least you could do is shorten it up a little."];
		tree[272] = ["%prompt-name%"];

		tree[275] = ["I insist\nyou call me\n<bad-name>!"];
		tree[276] = ["#grov13#I'm not calling you <bad-name>! ...That's NOT a name! I mean, the least you could do is trim out some of the punctuation."];
		tree[277] = ["%prompt-name%"];

		tree[280] = ["I insist\nyou call me\n<bad-name>!"];
		tree[281] = ["#grov13#I'm not calling you <bad-name>! ...That's NOT a name! I mean, you could at least give me a few extra letters to work with."];
		tree[282] = ["%prompt-name%"];

		// no name entered
		tree[300] = ["%mark-cdjv0kpk%"];
		tree[301] = ["#grov02#I think I'll just call you " + awfulName + ". " + awfulName + " is a fine name!"];
		tree[302] = [40, 30, 60, 50];

		// too short
		tree[330] = ["%mark-5w2p2vmw%"];
		tree[331] = ["#grov04#Oh sorry, I didn't mean to interrupt! ...I'll wait for you to finish."];
		tree[332] = ["#grov10#...Wait, is that it? <bad-name> is your entire first name!?!"];
		tree[333] = ["#grov03#That's awfully short. How about if I call you... <good-name>! At least I can pronounce <good-name>."];
		tree[334] = [250, 260, 280];

		// too long; multiple words
		tree[360] = ["%mark-agdjhera%"];
		tree[361] = ["%max-name-length-12%"];
		tree[362] = ["#grov10#Err, I only asked for your first name! Is <bad-name> really your first name? It seems awfully formal..."];
		tree[363] = ["#grov06#\"How are you feeling, <bad-name>?\" \"Let's get back to puzzle-solving, <bad-name>\"... Come now, I can't be expected to say that WHOLE thing every time!"];
		tree[364] = ["#grov05#How about if I just call you <good-name> for short?"];
		tree[365] = [250, 260, 270];

		// too long; one word
		tree[390] = ["%mark-7hoh545f%"];
		tree[391] = ["%name-max-length-12%"];
		tree[392] = ["#grov02#Ah, Gesundheit!"];
		tree[393] = ["#grov10#Hold on a moment, <bad-name> is your first name? Your REAL first name? ...I just assumed it was a silly noise you were making."];
		tree[394] = ["#grov05#...How about if I just call you <good-name> for short?"];
		tree[395] = [250, 260, 270];

		// good name
		tree[500] = ["#grov02#Well met, <name>! So that's one question dealt with, but it raises one further question..."];
		tree[501] = ["%enable-skip%"];
		tree[502] = ["%fun-nude2%"];
		tree[503] = ["#grov00#...Where did Grovyle's boxer shorts go!?! Dear goodness he was wearing them just a moment ago and... why they've suddenly vanished!"];
		tree[504] = ["#grov03#Tsk, how is it that undergarments just seem to spontaneously disappear around here??"];
		tree[505] = ["#grov07#Are we in proximity of some sort of boxer shorts Bermuda Triangle? ...Could our house be possessed by a perverted boxer shorts ghost!?"];
		tree[506] = ["#grov03#Errm, but anyways..."];

		tree[10000] = ["%enable-skip%"];
		tree[10001] = ["%fun-nude2%"];
		if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			DialogTree.replace(tree, 50, "a girl's", "a boy's");
		}

		if (!PlayerData.grovMale)
		{
			DialogTree.replace(tree, 503, "goodness he", "goodness she");
			DialogTree.replace(tree, 503, "boxer shorts", "panties");
			DialogTree.replace(tree, 505, "boxer shorts", "panty");
			DialogTree.replace(tree, 505, "panty Bermuda Triangle", "Bermuda Triangle of panties");
		}
	}

	private static function getPeriodCount(s:String)
	{
		var periodCount:Int = 0;
		for (i in 0...s.length)
		{
			if (s.charAt(i) == ".")
			{
				periodCount++;
			}
		}
		return periodCount;
	}

	private static function getLetterCount(s:String)
	{
		var letterCount:Int = 0;
		for (i in 0...s.length)
		{
			if (MmStringTools.isLetter(s.charAt(i)))
			{
				letterCount++;
			}
		}
		return letterCount;
	}

	public static function fixName(dialogTree:DialogTree, dialogger:Dialogger, text:String):Void
	{
		var badName = capitalizeWords(text);
		var goodName = capitalizeWords(text);

		var mark:String = null;
		if (PlayerData.name == null)
		{
			/*
			 * PlayerData.name is only null if the player is entering their
			 * name for a password. ...In this scenario, we're not given a
			 * substitute name
			 */
			if (goodName == null || goodName == "")
			{
				// no name entered
				mark = mark != null ? mark : "%mark-cdjv0kpk%";

				// set goodName just to avoid NPEs
				goodName = "GRACK";
			}
		}
		else {
			if (goodName == PlayerData.name)
			{
				// player entered 'GRACK' as their real name
				mark = mark != null ? mark : "%mark-sovcssrd%";
			}
			if (getLetterCount(goodName) == 0)
			{
				// no name entered
				mark = mark != null ? mark : "%mark-cdjv0kpk%";
				goodName = PlayerData.name;
			}
		}

		if (getPeriodCount(goodName) >= 2)
		{
			// two or more periods
			mark = mark != null ? mark : "%mark-zs7y5218%";
			goodName = StringTools.replace(goodName, ".", "");
			goodName = StringTools.replace(goodName, "  ", " ");
			goodName = StringTools.trim(goodName);
			goodName = capitalizeWords(goodName);
		}
		if (goodName.length > 12 && goodName.indexOf(" ") >= 0)
		{
			// too long; multiple words
			mark = mark != null ? mark : "%mark-agdjhera%";
			var words:Array<String> = goodName.split(" ");
			words.sort(function(a, b) return b.length - a.length);
			goodName = words[0];
		}
		if (goodName.length > 12)
		{
			// too long; one giant word
			mark = mark != null ? mark : "%mark-7hoh545f%";
			goodName = shortenName(goodName);
		}
		if (goodName.length <= 1)
		{
			// too short
			mark = mark != null ? mark : "%mark-5w2p2vmw%";
			if (goodName == "" || goodName == "." || goodName == " ")
			{
				goodName = capitalizeWords(FlxG.random.getObject(GrovyleDialog.AWFUL_NAMES));
			}
			else if (goodName == "A" || goodName == "E" || goodName == "I" || goodName == "O" || goodName == "U")
			{
				var badSuffixes:Array<String> = ["lfy", "mpy", "lbo", "spy", "bbo", "bby", "nfy", "tch", "ndo", "lky"];
				goodName = capitalizeWords(goodName + FlxG.random.getObject(badSuffixes));
			}
			else
			{
				var badSuffixes:Array<String> = ["obby", "utch", "ulm", "unt", "endo", "ulb", "undo", "amp", "usp", "ulfy",
												 "angh", "alk", "unghy", "ilbo", "alm", "unty", "ap", "umb", "elb", "ulg"];
				goodName = capitalizeWords(goodName + FlxG.random.getObject(badSuffixes));
			}
		}
		if (dialogger.getReplacedText("<random-name>") != null && dialogger.getReplacedText("<random-name>") == goodName)
		{
			// someone else's password
			mark = mark != null ? mark : "%mark-ijrtkh6l%";
		}
		if (mark == null)
		{
			mark = "%mark-79gi267d%";
			PlayerData.preliminaryName = goodName;
		}

		dialogger.setReplacedText("<bad-name>", badName);
		dialogger.setReplacedText("<good-name>", goodName);
		dialogTree.jumpTo(mark);
		dialogTree.go();
	}

	public static function shortenName(text:String):String
	{
		text = text.toUpperCase();
		var defaultName:String = StringTools.trim(capitalizeWords(text.substring(0, 5)));
		if (text.indexOf(" ") != -1 || text.indexOf(".") != -1)
		{
			return defaultName;
		}

		var firstConsonantIndex:Int = 1;
		while (firstConsonantIndex < text.length)
		{
			if (isConsonant(text.charAt(firstConsonantIndex)))
			{
				break;
			}
			firstConsonantIndex++;
		}
		if (firstConsonantIndex > 7)
		{
			return defaultName;
		}
		var firstVowelIndex:Int = firstConsonantIndex;
		while (firstVowelIndex < text.length)
		{
			if (isVowel(text.charAt(firstVowelIndex)))
			{
				break;
			}
			firstVowelIndex++;
		}
		if (firstVowelIndex > 8)
		{
			return defaultName;
		}

		text = text.substring(0, firstVowelIndex + 2);
		var endChar:String = text.charAt(text.length - 1);
		if ("BDFGLMNPRSTVZ".indexOf(endChar) != -1)
		{
			// bby, ddy, ffy, ggy, lly, mmy, nny, ppy, rry, ssy, tty, vvy, zzy
			text = text + endChar + "Y";
		}
		else if ("CJKQWX".indexOf(endChar) != -1)
		{
			text = text + endChar;
		}
		else if ("AEIOUY".indexOf(endChar) != -1)
		{
			var suffixes:String = "BDGKLMNPRTX";
			text = text + suffixes.charAt(FlxG.random.int(0, suffixes.length - 1));
		}

		return capitalizeWords(text);
	}

	public static function snarkyBeads(tree:Array<Array<Object>>)
	{
		if (PlayerData.recentChatCount("grovSnarkyBeads") == 0)
		{
			tree[0] = ["#grov10#Err, could we perhaps take a rain check on the anal beads?"];
			tree[1] = ["#grov06#...After a few bad experiences with toys like that, I've decided I don't care for anything that can potentially..."];
			tree[2] = ["#grov07#pinch..."];
			tree[3] = ["#grov06#down there. A-hem."];
			tree[4] = ["#grov05#... ...I don't need to go into... further detail, do I? Hah! Heheheheh. But yes, sorry, they're not for me."];
		}
		else
		{
			tree[0] = ["#grov10#Errrrr, sorry! ...I'm just, well, still not particularly enthused about that particular toy."];
			tree[1] = ["#grov06#Not after the... err..."];
			tree[2] = ["#grov07#pinching..."];
			tree[3] = ["#grov06#incident. A-hem."];
			tree[4] = ["#grov05#But you know! I'm open to just about anything else. Verrry open... Hah! Heheheh~"];
		}
		PlayerData.quickAppendChatHistory("grovSnarkyBeads");
	}

	public static function denDialog(sexyState:GrovyleSexyState = null, playerVictory:Bool = false):DenDialog
	{
		var denDialog:DenDialog = new DenDialog();

		denDialog.setGameGreeting([
			"#grov02#Ah, <name>! Came back here to pay your old friend Grovyle a visit, did you? ...I take it you're not bored with me yet?",
			"#grov03#To be honest I was hoping Sandslash or Buizel would find their way back here, so I could perhaps win a few minigames... but well... Heh! Heheheh.",
			"#grov00#No no! It's fine, we can play too- I don't mind losing. I'll be a good sport. ...And maybe we can have some fun after."
		]);

		denDialog.setSexGreeting([
			"#grov00#Well then! I suppose it's time to move onto an activity where I can sort of handle myself.",
			"#grov02#Or technically speaking... an activity where you can sort of handle myself? Heh! Heheheheh~",
			"#grov03#Anyway regardless... A-hem...",
		]);

		if (PlayerData.denSexCount >= 3)
		{
			denDialog.addRepeatSexGreeting([
				"#grov01#Well I'd say we're off to a rather... pleasant start, wouldn't you say?",
				"#grov00#We, errrr... We may have already broken my usual record for most times in one day. But well, no reason we can't break it a little further, hmmmm?",
			]);
		}
		else {
			denDialog.addRepeatSexGreeting([
				"#grov01#Well I'd say we're off to a rather... pleasant start, wouldn't you say?",
				"#grov00#How many more do you think you have in you? I think my record is... Somewhere around three or four. ...In a row, that is.",
				"#grov03#But you know, let's not force it. We'll see how this one goes and if we both have a bit more steam, perhaps we can go once more. ...Does that sound amicable?",
			]);
		}
		denDialog.addRepeatSexGreeting([
			"#grov01#Hah... You have... NO idea... how good that felt just now. Goodness...",
			"#grov00#...If you can just do that same thing again... Perhaps spend a little bit longer on the toes... Mmmmmyesss..."
		]);
		denDialog.addRepeatSexGreeting([
			"#grov01#Goodness! Someone's rather disciplined about eating their vegetables~",
			"#grov00#Perhaps we could throw on... a little vegetable oil? And well,",
			"#grov06#I suppose after that sets in... A dash of thousand island dressing could be nice? If you're in the mood for, errr...",
			"#grov07#...Gahh alright, the metaphor stopped being sexy. That one was my fault.",
		]);
		denDialog.addRepeatSexGreeting([
			"#grov01#Ahh, developing a bit of a green thumb, aren't we?",
			"#grov00#Well don't stop now, I think you're truly getting the hang of this. Mmmm, yes....",
		]);

		if (playerVictory)
		{
			denDialog.setTooManyGames([
				"#grov01#Well, I believe that's enough humiliation for one day. Heh! Heheheheh~",
				"#grov03#Perhaps I should practice a little more on my own before we continue. I'm not sure I'm ready to embarrass myself in front of other people.",
				"#grov02#But well, check in on me again in a few days. Good playing with you, <name>.",
			]);
		}
		else {
			denDialog.setTooManyGames([
				"#grov02#Ah, you know... Why don't we stop now. It would feel good to go out on a win for a change. Heh! Heheheheh~",
				"#grov03#Anyway it was good playing with you, <name>. Thanks for the practice~",
			]);
		}

		denDialog.setTooMuchSex([
			"#grov07#Good... good HEAVENS yes... ... ahhh... You're always good, but that was...",
			"#grov01#That was really, REALLY... oohh... Wow.... I, you... ... ahhh... Really...",
			"#grov00#<name>, I think I have to... take a break for a bit. This was quite a... quite a day. Thanks for making it special.",
			"#grov01#I err... ... You mean quite a lot to me. Thanks for everything.",
		]);

		denDialog.addReplayMinigame([
			"#grov06#Mmm, yes, I think I'm starting to understand where I usually go wrong...",
			"#grov02#...You're supposed to end up with a HIGHER score is it? Heh! Heheheheheh~",
			"#grov05#Well, did you want to give this another shot? Or, there are other activities we could partake in...",
		],[
			"Let's go\nagain",
			"#grov02#Very well! I won't go so easy on you this time. I've figured out your secret~",
		],[
			"Mmm! Let's try\nsome other\nactivities",
			"#grov00#Ah, other activites is it? ...Other activities. Other ac-tiv-i-ties. Hm. Hmm!",
			"#grov03#Why <name>, I don't know what activities you could possibly be hinting at. It appears my common sense is being overpowered by my complete and utter lack of clothing...",
		],[
			"Actually\nI think I\nshould go",
			"#grov10#Ahh is that... Yes very well, I understand. Busy day for you! I'll leave you to it.",
			"#grov04#Thanks for the game~",
		]);
		denDialog.addReplayMinigame([
			"#grov06#Say, were you trying to copy my moves? Your strategy seems to be markedly similar to mine... Perhaps just a smidge " + (playerVictory ? "better" : "worse") + "...",
			"#grov00#Well regardless, I'd be willing to go one more round if you're up for it. Unless there's something else back here that's caught your attention...",
		],[
			"One more\nround!",
			"#grov02#Ah! Very well. ...This time I'll hide my pieces so you can't see what I'm doing! Unless that counts as cheating...",
		],[
			"Now that you\nmention it...",
			"#grov03#Ah, something's caught your eye has it? Well what is it? Go on, say it! ...I want you to say it out loud, <name>... ...",
			"#grov00#...Heh! Heheheheh. Oh, I'm sorry, I'm only teasing. Come over here, come to Grovyle~",
		],[
			"I think I'll\ncall it a day",
			"#grov10#Ahh is that... Yes very well, I understand. Busy day for you! I'll leave you to it.",
			"#grov04#Thanks for the game~",
		]);
		denDialog.addReplayMinigame([
			"#grov03#Ah, very well. Once again, the better player has won. And the worse player... is left to ruminate on their embarrassing defeat. -sigh-",
			"#grov00#I'd say this calls for a rematch! Unless there was something else you wanted to do? Or... someone else...",
		],[
			"I want a\nrematch!",
			"#grov02#Yes, yes! Everyone deserves to win at least one game, don't they? Well, we'll see...",
		],[
			"I don't want\nsomeone else!\nI want to do\na Grovyle!",
			"#grov01#Heh! Heheheheh. Come now <name>.... ... You're absolutely shameless!",
			"#grov00#But, very well. How could I rebuff your affection when you've laid out your intentions in such a... poetic manner?",
		],[
			"Hmm, I\nshould go",
			"#grov10#Ahh is that... Yes very well, I understand. Busy day for you! I'll leave you to it.",
			"#grov04#Thanks for the game~",
		]);

		denDialog.addReplaySex([
			"#grov00#Hah... Well that was a remarkable display of... " + (PlayerData.grovMale ? "jackoffsmanship" : "penetrationmanship") + "...",
			"#grov03#Don't give me that look! That's a word. That's totally a word! I'm getting a dictionary.",
			"#grov02#And if you're not here when I get back, I'm chalking that up to your... coitaldepaturitude.",
		],[
			"I'll be\nhere!",
			"#grov03#Ahhh splendid. ...And I'll return in a few minutes to tell you how wrong you were.",
		],[
			"Yeah, my\ncoitaldeparturitude\nis pretty high\nright now, sorry",
			"#grov10#Well that's hardly fair, I invented that word just a moment ago and already you're using it against me! Hardly sporting...",
			"#grov05#Anyways, I suppose I'll see you around, <name>. Say hello to Heracross for me~",
		]);
		if (PlayerData.denSexCount <= 2)
		{
			denDialog.addReplaySex([
				"#grov01#Phew... th-thank you for that... Although I'm feeling inexplicably dehydrated all of a sudden...",
				"#grov03#Now I wonder why that might be? Where could my bodily fluids have vanished to? And what's that wet spot over there? Mysteries for the ages... Did you want anything while I'm up?",
			],[
				"Get me\na water!",
				"#grov02#Heh! Heheheh. Get yourself a water! You should know very well I'm incapable of getting you anything to actually eat or drink...",
				"#grov03#I thought perhaps you'd take the opportunity to ask for a limerick, or a silly quip. Anyways, I'll be right back.",
			],[
				"Oh, I think\nI'll head out",
				"#grov05#Ahh very well, I suppose I'll see you around, <name>. Say hello to Heracross for me~",
			]);
		}
		else {
			denDialog.addReplaySex([
				"#grov01#Phew... th-thank you for that... Although I'm feeling inexplicably dehydrated all of a sudden...",
				"#grov03#Now I wonder why that might be? Where could my bodily fluids have vanished to? And what's that wet spot over there? Mysteries for the ages... Did you want anything while I'm up?",
			],[
				"Get me\na limerick!\nOr a silly\nquip!",
				"#grov06#Ah, very well! Err, there once was a man from nantucket! Whose errr... whose...",
				"#grov10#Say, just how old are you anyways!? Perhaps this isn't the type of limerick I should tell over the internet. I wouldn't want you geting in trouble with your mommy and/or daddy.",
				"#grov02#Regardless, I'll be right back. Don't take my spot~",
			],[
				"Oh, I think\nI'll head out",
				"#grov05#Ahh very well, I suppose I'll see you around, <name>. Say hello to Heracross for me~",
			]);
		}
		if (PlayerData.denSexCount <= 3)
		{
			denDialog.addReplaySex([
				"#grov00#Goodness, that was... hah... that was something! You've learned some new moves have you? ...Although I'll err, I'll be right back if you don't mind.",
				FlxG.random.getObject([
				"#grov04#I have a sudden craving for baklava, which we inexplicably have two pounds of left over in our fridge from a few nights ago. Don't ask!",
				"#grov04#I have a sudden craving for kazandibi, which we inexplicably have two pounds of left over in our fridge from a few nights ago. Don't ask!",
				"#grov04#I have a sudden craving for panna cotta, which we inexplicably have a dozen helpings of left over in our fridge from a few nights ago. Don't ask!",
				"#grov04#I have a sudden craving for creme brulee, which we inexplicably have a dozen helpings of left over in our fridge from a few nights ago. Don't ask!",
			])
			],[
				"Aww, get\nme some!",
				"#grov03#Oh why I'll... get you some hugs and kisses! Isn't that just as good? Heh! Heheheheh~",
				"#grov05#But I'll be back in just a moment. You sit tight!"
			],[
				"I should\ngo...",
				"#grov05#Ahhhh very well, at least I'll have my dessert to keep me company. Good seeing you, <name>. Say hello to Heracross for me~",
			]);
		}
		else {
			denDialog.addReplaySex([
				"#grov00#Goodness, that was... hah... that was something! You've learned some new moves have you? ...Although I'll err, I'll be right back...",
				"#grov03#Yes, yes, I'm raiding the fridge for a second time! ...Someone else will eat it if I don't...",
			],[
				"How do\nyou stay\nso thin!?",
				"#grov06#Oh you know! Proper portion control, plus I have my methods of burning calories...",
				"#grov02#You sit tight, my little calorie burner! I'll be back in a just a moment~",
			],[
				"I should\ngo...",
				"#grov05#Ahhhh very well, at least I'll have my dessert to keep me company. Good seeing you, <name>. Say hello to Heracross for me~",
			]);
		}

		return denDialog;
	}

	public static function cursorSmell(tree:Array<Array<Object>>, sexyState:GrovyleSexyState)
	{
		var count:Int = PlayerData.recentChatCount("grov.cursorSmell");

		if (count == 0)
		{
			if (PlayerData.playerIsInDen)
			{
				tree[0] = ["#grov00#Well then! (sniff) I suppose it's time to move onto an activity where I, err... (sniff, sniff)"];
			}
			else
			{
				tree[0] = ["#grov04#Ah! I think that's enough fun for now. (sniff) I'm just going to, err... relax here for a moment. (sniff, sniff)"];
			}
			tree[1] = ["#grov06#Errrr you know, we don't HAVE to have sex if you don't want to, <name>... There are odor things-- err, other things we can do instead."];
			tree[2] = ["#grov08#... ..."];
			tree[3] = ["#grov07#...Look, I stink it's-- I think it's quite nice what you're doing for Grimer. You're um, you're a good person."];
			tree[4] = ["#grov06#But well, sometimes bad smells happen to good people."];
			tree[5] = ["#grov03#While it's a bit of a turnoff for me personally, I'll power through it if I musk-- err, if I must."];
		}
		else
		{
			if (PlayerData.playerIsInDen)
			{
				tree[0] = ["#grov00#Well then! (sniff) I suppose it's time to move onto an activity where I, err... (sniff, sniff)"];
			}
			else
			{
				tree[0] = ["#grov04#Ah! I think that's enough fun for now. (sniff) I'm just going to, err... relax here for a moment. (sniff, sniff)"];
			}
			tree[1] = ["#grov07#Euuughhh. My nose is begging me not to go through with this, <name> ...But... I suppose I'll leave that decision up to you."];
			tree[2] = ["#grov06#...Perhaps if I just close my eyes, I can pretend we're copulating on a durian farm..."];
		}
	}
}