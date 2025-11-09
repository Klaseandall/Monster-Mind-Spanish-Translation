package poke.smea;

import MmStringTools.*;
import PlayerData.hasMet;
import critter.Critter;
import flixel.FlxG;
import kludge.BetterFlxRandom;
import minigame.scale.ScaleGameState;
import minigame.tug.TugGameState;
import openfl.utils.Object;
import minigame.GameDialog;
import minigame.MinigameState;
import poke.sexy.SexyState;
import puzzle.ClueDialog;
import puzzle.PuzzleState;
import puzzle.RankTracker;

/**
 * Smeargle is canonically male. Smeargle and Kecleon first had their debut in
 * a picture series from 2010. Kecleon and a few of his friends had sex with
 * Smeargle in a sort of impersonal way. But then Kecleon sort of fell in love
 * with him and they have been a couple ever since.
 * 
 * Smeargle is asexual. He enjoys occasional sexual acts but doesn't have
 * sexual feelings towards anybody in particular. But, he loves kissing and
 * cuddling and being romantic with Kecleon.
 * 
 * Smeargle doesn't usually orgasm when he and Kecleon have sex; he just
 * focuses on getting Kecleon off.
 * 
 * Smeargle doesn't really know Abra personally. Kecleon heard about Abra's
 * puzzle-and-sex thing from Grovyle, and encouraged Smeargle to try it out. He
 * thinks the anonymous one-way nature of the sexual experience might help
 * Smeargle become more comfortable with his own body, or that Smeargle might
 * enjoy sex more if he's not obsessing over the best way to reciprocate
 * 
 * Smeargle feels lonely having to sit separately from Kecleon for the duration
 * of the puzzles. He wears a kecleon-colored sweater as a way of staying
 * close to him when they are separated.
 * 
 * Smeargle is abysmal at the puzzles. He is smart, but he finds these kinds of
 * static puzzles boring to think about.
 * 
 * Out of all the Pokemon in the game, Smeargle finds Grimer's smell the most
 * offensive and won't even play with you if you've been with Grimer recently.
 * You need to wait about 15 minutes first.
 * 
 * As far as minigames go, Smeargle adopts a playfully competitive attitude
 * towards these games, but this can be grating because he's actually quite
 * good at them, particularly the scale game. At the stair game, you can almost
 * always go first if you throw a "1" against him.
 * 
 * ---
 * 
 * When writing dialog, I think it's good to have an inner voice in your head
 * for each character so that they behave and speak consistently. Smeargle's
 * inner voice was Pam from The Office.
 * 
 * Vocal tics:
 *  - Ha ha! "super" instead of "really" Harf? ...Thpt? Bleb? Mlem? Arf?
 *  - Thinks he's "helping you solve". Everything's "we"
 * 
 * Abysmal at puzzles (rank 8)
 */
class SmeargleDialog
{
	public static var prefix:String = "smea";
	public static var sexyBeforeChats:Array<Dynamic> = [sexyBefore0, sexyBefore1, sexyBefore2, sexyBefore3, sexyBefore4];
	public static var sexyAfterChats:Array<Dynamic> = [sexyAfter0, sexyAfter1, sexyAfter2];
	public static var sexyBeforeBad:Array<Dynamic> = [badRubBelly, badRubHat, badShouldntRubDick, badShouldntRubTongue, badDislikedHandsDown, badDislikedHandsUp];
	public static var sexyAfterGood:Array<Dynamic> = [sexyAfterGood0, sexyAfterGood1];
	public static var fixedChats:Array<Dynamic> = [kecleonIntro, lowLibido];

	public static var randomChats:Array<Array<Dynamic>> = [
				[random00, random01, random02, random03, gift04],
				[random10, random11, random12, random13, random14],
				[random20, random21, random22, random23, random24]];

	public static function getUnlockedChats():Map<String, Bool>
	{
		var unlockedChats:Map<String, Bool> = new Map<String, Bool>();
		unlockedChats["smea.randomChats.2.2"] = hasMet("rhyd");
		unlockedChats["smea.randomChats.2.3"] = hasMet("hera");
		unlockedChats["smea.randomChats.0.4"] = false;
		unlockedChats["smea.randomChats.1.4"] = hasMet("grim");

		if (PlayerData.keclGift == 1)
		{
			// all chats are locked except gift chat
			for (i in 0...randomChats[0].length)
			{
				unlockedChats["smea.randomChats.0." + i] = false;
			}
			unlockedChats["smea.randomChats.0.4"] = true;
		}
		return unlockedChats;
	}

	public static function clueBad(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var clueDialog:ClueDialog = new ClueDialog(tree, puzzleState);
		clueDialog.setGreetings(["#smea08#I don't get it, why didn't it work? ...Oh, maybe something's wrong with the <first clue>?",
								 "#smea08#Wait, that wasn't the answer? ...Oh, huh, I guess the <first clue>'s broken or something?",
								 "#smea08#I don't really... What? Why did the <first clue> light up? What was that red X? I don't get it...",
								]);
		if (clueDialog.actualCount > clueDialog.expectedCount)
		{
			if (clueDialog.expectedCount == 0)
			{
				clueDialog.pushExplanation("#smea06#Okay wait... Since there's no <hearts> on that clue, that means we shouldn't have any <bugs in the correct position>? I think Abra told me something like that.");
			}
			else
			{
				clueDialog.pushExplanation("#smea06#Okay wait... I think <e hearts> means there's supposed to be... <e bugs in the correct position>? I think Abra told me something like that.");
			}
			clueDialog.pushExplanation("#smea04#So for that <first clue>.... Why isn't it working? I mean we have <a bugs in the correct position>, and we're supposed to have-- Ohhhh, okay, I get it now.");
			clueDialog.pushExplanation("#smea10#We need to make it so our answer doesn't have as many <bugs in the correct position> for that clue. ...Wow that actually seems, like, really hard!!");
			if (clueDialog.expectedCount == 0)
			{
				clueDialog.fixExplanation("doesn't have as many", "doesn't have any");
			}
			clueDialog.pushExplanation("#smea08#...You know, if we're totally stuck, we can always ask Abra for help using that question mark button in the corner. Hmmm...");
		}
		else
		{
			clueDialog.pushExplanation("#smea06#Okay wait... I think <e hearts> means there's supposed to be... <e bugs in the correct position>? I think Abra told me something like that.");
			clueDialog.pushExplanation("#smea04#So for that <first clue>.... Why isn't it working? I mean we have <a bugs in the correct position>, and we're supposed to have-- Ohhhh, okay, I get it now.");
			clueDialog.fixExplanation("we have zero", "we don't have any");
			clueDialog.pushExplanation("#smea10#We need to make it so our answer has more <bugs in the correct position> for that clue. ...Wow that actually seems, like, super hard!!");
			clueDialog.pushExplanation("#smea08#...You know, if we're totally stuck, we can always ask Abra for help using that question mark button in the corner. Hmmm...");
		}
	}

	public static function newHelpDialog(tree:Array<Array<Object>>, puzzleState:PuzzleState, minigame:Bool=false)
	{
		var helpDialog:HelpDialog = new HelpDialog(tree, puzzleState);
		helpDialog.greetings = [
								   "#smea05#Oh hi! Did you need anything from me?",
								   "#smea05#Hello there! Did you need me to help with something?",
								   "#smea05#Oh hello! What's going on? Did you figure something out?"];

		helpDialog.goodbyes = [
								  "#smea10#Yeah we should ask Abra if " + (PlayerData.abraMale?"he":"she") + " has some easier puzzles!",
								  "#smea10#Right!? This is WAY too much! I mean is there an easier difficulty we can go to or something?",
								  "#smea10#Yeah I'm totally stuck!! ...Maybe we bit off too much this time.",
							  ];

		helpDialog.neverminds = [
									"#smea04#Oh okay, back to the puzzle I guess? Hmmmm... Hmmmmmmm....",
									"#smea04#Wait, why does that second clue have... Oh, no, I guess that's right. Hmm...",
									"#smea04#Don't worry, I'll let you know if I figure anything out! Hmm. Hmmmm...",
								];

		helpDialog.hints = [
							   "#smea02#Good thinking, it's been awhile since we asked for a hint! I'll go get Abra.",
							   "#smea02#Yeah this puzzle's WAY harder than normal. Abra'll definitely help us this time! I'll go get " + (PlayerData.abraMale ? "him" : "her") + ".",
							   "#smea06#Hmm do you think it's too soon to ask for a hint? ...I'll go ask anyways. I'll be right back.",
							   "#smea06#Hmm has it really been long enough? Abra gets grumpy about hints sometimes. I'll go check what kind of mood " + (PlayerData.abraMale ? "he" : "she") + "'s in.",
						   ];

		if (minigame)
		{
			helpDialog.goodbyes = [
									  "#smea10#Leaving in such a hurry? Aww okay! See you later I guess!!",
									  "#smea10#But... But we didn't finish our game!"
								  ];
			helpDialog.neverminds = [
										"#smea04#Oh okay... Well, back to the game!",
										"#smea04#Hey don't get distracted! We're in the middle of a game here!"
									];
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

		g.addSkipMinigame(["#smea10#Oh! Not feeling like a game today? Is something wrong?", "#smea04#Well that's okay! As long as I'm spending time with my little <name> buddy... I don't really care what we're doing.", "#smea02#We can do whatever you want to do!"]);
		g.addSkipMinigame(["#smea05#Well sure, that's okay! We don't have to play games all the time. I understand if your brain needs a break every once in awhile.", "#smea03#Yeah! Let's do that. Let's take a break."]);

		g.addRemoteExplanationHandoff("#smea04#Let me get <leader>, <leaderhe> can explain this better than I can.");

		g.addLocalExplanationHandoff("#smea04#Hmm, can you explain this one, <leader>?");

		g.addPostTutorialGameStart("#smea04#Hmm sooooo... did you get all that? Should we go ahead and start?");

		g.addIllSitOut("#smea05#I almost ALWAYS win this game. Actually... Did you want to play without me? You might have more fun that way.");
		g.addIllSitOut("#smea05#I practice this game ALL the time. Actually... This might be kind of unfair, did you want me to drop out?");
		g.addIllSitOut("#smea05#Maybe I'll just watch this time, <name>. I've got hooked on this minigame, and well, I've gotten in a TON of practice.");

		g.addFineIllPlay("#smea02#Yesssss!! I've been WAITING for someone to play against other than Abra... I can't wait to show you!");
		g.addFineIllPlay("#smea02#Oh sure, nobody thinks the DOG is going to win... Anybody want to place some money on it? Any takers?");
		g.addFineIllPlay("#smea02#Sure, sure, show me what you got! Harf! I've got a can of whoop-ass with <name>'s name on it!");

		g.addGameAnnouncement("#smea05#Oh this is <minigame>! This one's pretty neat.");
		g.addGameAnnouncement("#smea05#Neat, it's <minigame>! You remember this one, don't you?");
		g.addGameAnnouncement("#smea05#Oh fun, it looks like we're playing <minigame>!");

		g.addGameStartQuery("#smea04#Are you ready to get started?");
		g.addGameStartQuery("#smea04#...Should we just dive right in?");
		if (PlayerData.denGameCount == 0)
		{
			g.addGameStartQuery("#smea04#You remember how this one works, right?");
		}
		else
		{
			g.addGameStartQuery("#smea03#Oooooh you think I'm going to go easy on you? I hope you brought your A-game! Harf?");
		}

		g.addRoundStart("#smea05#I'm ready for the next round! How about you?", ["Sure, I'm\nready", "I gotta use the\nrestroom first", "No\nproblem"]);
		g.addRoundStart("#smea04#Let's start round <round>!", ["Uhh...", "Yeah! I'm\nready", "You're going\ndown!"]);
		g.addRoundStart("#smea05#Okay! Ready for round <round>?", ["Yeah, let's\ngo", "Hmm, I\nguess...", "Ready when\nyou are"]);
		g.addRoundStart("#smea04#Alright, time for round <round>!", ["Sure, sounds\ngood", "Let's go!", "Oof..."]);

		if (gameStateClass == ScaleGameState) g.addRoundWin("#smea02#C'mon, what took you all so long!", ["Hey, that\nwas tough", "You got lucky", "You're really\ngood at this"]);
		if (gameStateClass == TugGameState) g.addRoundWin("#smea02#C'mon, why are you moving so slow!", ["Hey, this\nis tough", "You got lucky", "You're really\ngood at this"]);
		if (gameStateClass == ScaleGameState) g.addRoundWin("#smea03#Gosh, that one was like SUPER easy!!", ["It didn't seem\nthat easy", "I'll win the\nnext one", "Hmph"]);
		if (gameStateClass == TugGameState) g.addRoundWin("#smea03#Ha ha, wow!! ...Maybe you should play against Kecleon instead!", ["What, is\nKecleon worse?", "Hey that's\nnot nice...", "Hmph"]);
		if (gameStateClass == ScaleGameState)
		{
			if (PlayerData.gender == PlayerData.Gender.Boy)
			{
				g.addRoundWin("#smea02#Don't they have any harder ones?", ["Hey, these are\nhard enough", "I'll get you,\nSmeargle", "Hmph I've got a\nharder one for you"]);
			}
			else
			{
				g.addRoundWin("#smea02#Don't they have any harder ones?", ["Hey, these are\nhard enough", "I'll get you,\nSmeargle", "Let's go,\nc'mon"]);
			}
		}
		if (gameStateClass == TugGameState)
		{
			if (PlayerData.gender == PlayerData.Gender.Boy)
			{
				g.addRoundWin("#smea02#Can't we make this harder somehow? Like with more chests or bugs or something?", ["Hey, this is\nhard enough", "I'll get you,\nSmeargle", "Hmph I've got\nsomething harder\nfor you"]);
			}
			else
			{
				g.addRoundWin("#smea02#Can't we make this harder somehow? Like with more chests or bugs or something?", ["Hey, this is\nhard enough", "I'll get you,\nSmeargle", "Let's go,\nc'mon"]);
			}
		}
		g.addRoundWin("#smea03#Harf! That's the way it's done!", ["Good job", "I'll get\nyou yet", "Teach me your\nways, sensei!"]);

		if (gameStateClass == ScaleGameState) g.addRoundLose("#smea12#Hmph, I don't know what that one took me so long! It seems so obvious now...", ["You're doing\ngood", "You gotta up your\ngame, Smeargle", "Let's try\nagain"]);
		if (gameStateClass == TugGameState) g.addRoundLose("#smea12#Hmph, I don't know how I miscounted that! I need to pay more attention...", ["You're doing\ngood", "You gotta up your\ngame, Smeargle", "Let's try\nagain"]);
		if (gameStateClass == ScaleGameState && PlayerData.pegActivity >= 4) g.addRoundLose("#smea13#No fair, my bugs wouldn't sit still!!", ["Hey I'm using\nthe same bugs", "Excuses,\nexcuses", "Hmm sorry\nabout that"]);
		g.addRoundLose("#smea07#Wow <leader>, you're like... REALLY good at this!", ["What's <leaderhis>\nsecret?|Aww you're\ngood too!", "Ehh <leaderhe's> not\nthat fast|There's still room\nfor improvement...", "We'll do better\nthis round|You'll get there\nsome day!"]);
		g.addRoundLose("#smea10#<leader>, do you think you can like... maybe give me a head start or something?", ["Yeah, it's kind\nof unfair...|Hmmm,\nokay...", "How is <leaderhe>\nso good!?|I'm not usually\nthis fast", "C'mon, don't\ngive up yet"]);

		g.addWinning("#smea02#Sorry! ...I should have warned you, I'm kind of awesome at this.", ["Gwuuhh...", "Oh wow, a\nchallenge!", "How is this\npossible!?"]);
		g.addWinning("#smea03#Don't feel bad <name>! I've had like, TONS of practice.", ["Sheesh! I\ncan't compete", "Ugh this\nsucks", "It's not\nover yet!"]);
		g.addWinning("#smea04#This is like sooooooooo much easier than those logic puzzles...", ["Not for me\nit isn't!", "Yeah but I've had practice\nat those logic puzzles", "Hmmmm...."]);
		g.addWinning("#smea02#Ha! Ha! Maybe you should be MY puzzle sidekick, <name>!", ["Ugh\nwhatever", "I'll never be\na sidekick!", "Hmph, I concede... You're\nway better at this"]);

		g.addLosing("#smea07#Gwuhhh! This is like... the ONE thing I'm usually kind of good at!", ["You're really good!\n<leaderHe's> just better|You're really good!\nMaybe this round...", "Heh heh,\nawww...", "Hey don't be so\nhard on yourself"]);
		g.addLosing("#smea13#Rrrrr! I can still catch up, I just gotta focus...", ["Yeah! <leaderHe's> not\nthat far ahead|Yeah! I'm not\nthat far ahead", "Ough, it's a long\nshot... But maybe|That'll be\npretty tough", "Maybe next\ntime...|Pshh are you\nkidding me!?"]);
		g.addLosing("#smea07#...I'm still in this! I'm still in this!", ["We're so close!\nWe can do it|Heh! Heh! Keep\ntelling yourself that", "Aww relax, it's\njust a game", "Good luck\nlittle buddy~"]);
		g.addLosing("#smea08#Wow... I really need to practice more...", ["Promise you won't\nleave me for <leader>!|Hey you're doing\nreally well", "Practice makes\nperfect", "Don't\nsweat it"]);

		g.addPlayerBeatMe(["#smea09#Awww... Well congratulations <name>! ...I hope I at least put up a good fight.", "#smea04#I love playing with you, even if I'm not quite at your level yet. I'll practice more and... we'll have a rematch soon, right?"]);
		g.addPlayerBeatMe(["#smea15#Awww nutbunnies!... I was THIS close!!", "#smea05#Well I hope we can play again soon! Win or lose, I just sort of like playing with you, you know?", "#smea00#...It's just nice to play!"]);

		g.addBeatPlayer(["#smea02#Yes! YES! In your face! Yesss!! SMEAR-GLE! SMEARRR-GLE!! SMEARR-GLE!! UNH! UNH!", "#smea11#I mean... Oh! Oh, I'm sorry!", "#smea10#It's just... It's just good to win sometimes...", "#smea03#...Umm... Good game! Ha! Ha!"]);
		g.addBeatPlayer(["#smea03#Oh wait a minute... Did I win!? Really? Well hooray!", "#smea01#I guess every dog has " + (PlayerData.smeaMale ? "his" : "her") + " day, huh? Harf! Harf!! We'll have a rematch soon~"]);

		g.addShortWeWereBeaten("#smea05#Rarf, tough match right? We'll get <leaderhim> next time!");
		g.addShortWeWereBeaten("#smea02#Hey I hope you had fun! Bark! I always enjoy this game, even when I don't win.");

		g.addShortPlayerBeatMe("#smea03#Arf, good game! I'm gonna practice... You won't beat me so easily next time!");
		g.addShortPlayerBeatMe("#smea10#Grrarf!? ...<name>, you're supposed to let me win! I'm so cute when I win!");

		g.addStairOddsEvens("#smea06#So who goes first... Hmm... How about we throw odds and evens for it? You can be odds, and I'll be evens! Ready?", ["Sure", "I never\nget to\nbe evens...", "Let's go!"]);
		g.addStairOddsEvens("#smea06#How about we do odds and evens to see who goes first? You can be odds, and I'll be evens... Alright?", ["Okay!", "Sounds\ngood", "So I'm\nodds..."]);

		g.addStairPlayerStarts("#smea03#Well... That's okay! You can go first. I usually let Kecleon go first too, just to make things fair. Are you ready?", ["Yeah,\nlet's go!", "I bet you let\nKecleon finish\nfirst, too~", "Alright"]);
		g.addStairPlayerStarts("#smea03#Looks like you're up first, <name>! Let's get this show on the road. Do you know what you're throwing first?", ["Two,\nright?", "Maybe I'll\nthrow a zero...", "I'm not\ntelling you!"]);

		g.addStairComputerStarts("#smea05#Oh! So I get to go first? ...I never figured out whether that's actually good in this game. Let's start!", ["Okay,\nI'm ready!", "It makes\nit easy to\ncapture you", "It gives you a\nnice head start"]);
		g.addStairComputerStarts("#smea05#Looks like I'm up first? ...Alright! I just need to make sure not to get captured... Hmm, hmm, what should I throw...", ["Let's\nstart", "On three,\nokay?", "Throw out a\none, and\nI'll give\nyou a hug!"]);

		g.addStairCheat("#smea06#Umm... Did you see what I put out, before you threw your dice out? That seemed kind of close. ...Why don't we do that over again just to make sure.", ["Oh, I'll be\nmore careful", "Aww, why\nwould I cheat!", "...You\ncheater!"]);
		g.addStairCheat("#smea10#Was I counting too fast for you, <name>? I can go slower if that helps. ...It felt like you kind of missed the countdown...", ["Sure, go a\nlittle slower...", "Was I\nlate?", "Fine, fine,\nI'll go faster..."]);

		g.addStairReady("#smea04#...Ready?", ["Alright", "Ready!", "Uhh, yeah..."]);
		g.addStairReady("#smea05#I'm ready! Are you?", ["Hmm,\nsure...", "Yep! Ready", "Give me\na sec"]);
		g.addStairReady("#smea04#Ready?", ["Yep!", "I think\nso...", "Ugh,\nI guess"]);
		g.addStairReady("#smea05#On three, okay?", ["Yeah!\nLet's go", "Oof...", "Sounds good"]);
		g.addStairReady("#smea04#Hmm, are you ready?", ["Just\ngo...", "Ready!", "Hmm,\nyeah"]);

		g.addCloseGame("#smea10#Wow! I'm not used to these games being this close. I'm usually like, super far ahead by now...", ["This seems\neasy!", "I'm no\npushover~", "They usually\nlet you win?"]);
		g.addCloseGame("#smea06#Hmm, you've been pretty predictable so far! Maybe I should try something a little risky...", ["...But things\nare going\nso well!", "I wouldn't\ndo it...", "Do it!\nLive life\non the edge"]);
		g.addCloseGame("#kecl00#You're doin' great, sugar pumpkin! ...Knock 'em dead!", ["Hey, you\nstay out\nof this!", "That's it! Distract " + (PlayerData.smeaMale ? "him" : "her"), "Don't get your\nhopes up..."]);
		g.addCloseGame("#smea06#Hmm, if I throw that, then you'll throw this... But maybe... Hmm, hmm...", ["It's just\nrandom...", "You'll never\noutguess me!", "Don't\noverthink it"]);

		g.addStairCapturedHuman("#smea02#Harf! Hwarf! Kecleon falls for that same trick all the time... You really didn't think I was going to put out a <computerthrow>, did you?", ["Hmm, I should\nhave thought\nthat over", "Gah! What\nnow?", "Well, you\ntook a\nhuge risk..."]);
		g.addStairCapturedHuman("#smea08#Maybe next game, I can be " + manColor + "? ...I feel super bad for the " + manColor + " ones.", ["Stop\ncapturing\nthem then!", "Ugh, I\ndon't need\nyour pity", "How'd\nyou guess\nthat!?"]);
		g.addStairCapturedHuman("#smea02#I can't believe you'd put out a <playerthrow> in that position, <name>! ...What did you think I was going to do?", ["Well,\nit seems\nobvious now...", "C'mon, I\ncouldn't\nhave known!", "You threw\nout <computerthrow>?\nReally?"]);

		g.addStairCapturedComputer("#smea11#Ack! ...My little " + comColor + " friend! ...Do you think " + (PlayerData.gender == PlayerData.Gender.Boy ? "he'll" : "she'll") + " be okay?", ["That was\nyour fault!", (PlayerData.gender == PlayerData.Gender.Boy ? "He'll" : "She'll") +"\nsurvive", "Heh! Heh.\nI thought it\nwas funny~"]);
		g.addStairCapturedComputer("#smea11#Oh no! ...I think I'm running out of " + comColor + " bugs... What happens if I run out?", ["I don't\nthink you can\nrun out", "You lose,\nI guess?", "I'll win\nbefore that\nhappens..."]);
		g.addStairCapturedComputer("#smea11#What? Augh! I really didn't think you'd throw out <playerthrow>... What made you do that!?", ["I thought\nit would fake\nyou out", "It was\nthe obvious\nmove...", "Because\nI've figured\nyou out!"]);

		return g;
	}

	public static function bonusCoin(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#smea02#Whoa! A bonus coin!? Wow that's like... super duper lucky!"];
		tree[1] = ["#smea03#Here, I've got the perfect bonus game for you. You'll like this one! ...Well, I mean, I like this one!"];
	}

	public static function kecleonIntro(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["#smea05#Oh hi, it's you! You're <name> right? I don't think we've met. I'm Smeargle!"];
			tree[1] = ["#smea04#So I don't know if Abra told you, but the two of us- we get to solve these puzzles together. And if we do a good job, I take off my clothes!"];
			tree[2] = ["#smea06#So first off, hmm... You see all those red and white things next to the boxes? That means the answer must have a lot of red and white bugs!"];
			tree[3] = ["#smea02#That's a good start. Just go ahead and drop a handful of the red and white ones in the answer! It doesn't matter where."];
			tree[4] = ["#kecl06#I uhh, I don't think you got that quite right. No offense <name> but you might be better off solving this one on your own."];
			tree[5] = ["#smea12#Oh sorry, I'm not sure if I introduced you to my VERY RUDE BOYFRIEND, Kecleon. Kecleon, this is <name>."];
			tree[6] = [25, 30, 15, 20];

			tree[15] = ["Hello\nKecleon!"];
			tree[16] = [50];

			tree[20] = ["Your\nboyfriend?"];
			tree[21] = [50];

			tree[25] = ["Can we\nstill...?"];
			tree[26] = [50];

			tree[30] = ["Won't this\nbe weird?"];
			tree[31] = [50];

			tree[50] = ["#kecl02#Hey ahhhh-- don't worry! Don't worry about me, you two kids have fun."];
			tree[51] = ["#kecl00#I'll just be lurking over here -- you know, like a pervert would do. Keck! Kekekekek."];
			tree[52] = ["#kecl05#Really though I wouldn't take Smeargle too seriously, he doesn't err uh-- He's still gettin' this puzzle stuff figured out."];
			tree[53] = ["#kecl04#I don't think you're gonna see a whole lot of those red or white bugs here."];
			tree[54] = ["#smea06#There are TOO a lot of red and white bugs! And see that third clue? It's got... Oh wait, oh okay I see what you mean. Hmmmm..."];
			tree[55] = ["#smea04#You know, maybe I'll just watch you solve this first one. I'll join in on the second puzzle once I get the swing of things."];

			if (!PlayerData.keclMale)
			{
				DialogTree.replace(tree, 5, "RUDE BOYFRIEND", "RUDE GIRLFRIEND");
				DialogTree.replace(tree, 20, "boyfriend?", "girlfriend?");
				DialogTree.replace(tree, 52, "he doesn't", "she doesn't");
				DialogTree.replace(tree, 52, "He's still", "She's still");
			}

			if (puzzleState._puzzle._easy)
			{
				DialogTree.replace(tree, 2, "red and white", "white");
				DialogTree.replace(tree, 3, "red and white", "white");
				DialogTree.replace(tree, 53, "red or white", "white");
				DialogTree.replace(tree, 54, "red and white", "white");
			}
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["%fun-nude0%"];
			tree[1] = ["#kecl05#So ehhhh I notice this nice gentleman solved a puzzle, and yet you still got all your clothes on there."];
			tree[2] = ["#smea10#Just give me a moment! These... sleeves are super awkward..."];
			tree[3] = ["%fun-nude1%"];
			tree[4] = ["#smea04#Anyways speaking of clothes Kecleon, what are you doing naked? You should put some pants on so you can be on camera too!"];
			tree[5] = ["#kecl10#Ayyy are you crazy? I'm not puttin' my picture out there on the internet! In a game like this??"];
			tree[6] = ["#smea10#What!?"];
			tree[7] = ["#kecl08#I mean one second I'm slouching in a position that just MAYBE, just maybe exemplifies my, my more err... gutly qualities,"];
			tree[8] = ["#kecl13#and next second WHAM! They've made me into some kinda... portly lizard meme. You know how they are!"];
			tree[9] = ["#smea11#They what? Portly lizard meme!?! Ohhhh... now I don't know if I should be doing this either!"];
			tree[10] = ["#kecl06#I err, uhh... But I mean you, you're skinny, you got your looks! It's different for someone like me."];
			tree[11] = ["#smea09#..."];
			tree[12] = ["#kecl06#They're... I mean they're not like that with everyone! It's just..."];
			tree[13] = ["#smea09#......"];
			tree[14] = ["#kecl12#*sigh* Fine, fine, I'll go get some friggin' clothes on..."];
			tree[15] = ["#smea08#Hmmm..."];
			tree[16] = ["#smea10#Well gosh, now he has me all distracted thinking about being on camera!! ...I don't know if I'll be very much help on this next puzzle."];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 1, "nice gentleman", "nice lady");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 1, "this nice gentleman", "our guest of honor");
			}
			if (!PlayerData.keclMale)
			{
				DialogTree.replace(tree, 16, "he has me", "she has me");
			}

			tree[10000] = ["%fun-nude1%"];
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["%fun-nude1%"];
			tree[1] = ["%enterkecl%"];
			tree[2] = ["%fun-alpha0%"];
			tree[3] = ["#kecl12#There, you happy? You got my flabby butt in front of a camera."];
			tree[4] = ["%proxykecl%fun-alpha0%"];
			tree[5] = ["#smea00#Mmmmm... I LIKE your flabby butt *smooch* *slrp*"];
			tree[6] = ["#kecl13#AYY get over there!!! ...You got a job to do!"];
			tree[7] = ["%proxykecl%fun-alpha1%"];
			tree[8] = ["#smea05#Oh! RIGHT! So I take off my underwear and... Just get on camera? Just like this?"];
			tree[9] = ["%fun-alpha1%"];
			tree[10] = ["%fun-nude2%"];
			tree[11] = ["#smea10#I'm nervous! It's just one person right? This isn't going out to anybody else? ...You're not recording are you?"];
			tree[12] = [30, 60, 40, 20];
			if (PlayerData.startedTaping)
			{
				tree[12] = [30, 60, 50, 40, 20];
			}

			tree[20] = ["It's\njust me"];
			tree[21] = [31];

			tree[30] = ["I'm not\nrecording"];
			tree[31] = ["#smea06#Hmm... Okay as long as you promise!"];
			tree[32] = ["%exitkecl%"];
			tree[33] = ["#smea04#It's okay if it's just between us, but it would be weird if someone else was watching."];
			tree[34] = ["#smea03#...Other than Kecleon, I mean."];
			tree[35] = ["#kecl00#Kecl~"];
			tree[36] = [100];

			tree[40] = ["I'm only\nrecording\nKecleon"];
			tree[41] = ["%exitkecl%"];
			tree[42] = ["#kecl11#AAHHHH!!! Hide your face! He's with the four chans!!!"];
			tree[43] = ["#smea04#Umm.... Kecleon? ...Wait, what did he say?? Is he coming back? Hmm..."];
			tree[44] = [100];

			tree[50] = ["Heracross\nmight be\nrecording"];
			tree[51] = ["#smea04#Oh that's okay, Heracross told me he's DEFINITELY not recording anything, and DEFINITELY not uploading it anywhere for lots and lots of money."];
			tree[52] = ["%exitkecl%"];
			tree[53] = ["#smea06#...He was weirdly specific about that last part!"];
			tree[54] = [100];

			tree[60] = ["I'm recording\nEVERYTHING"];
			tree[61] = ["%exitkecl%"];
			tree[62] = ["#kecl11#AAHHHH!!! Hide your face! He's with the four chans!!!"];
			tree[63] = ["#smea04#Umm.... Kecleon? ...Wait, what did you say?? Is he coming back? Hmm..."];
			tree[64] = [100];

			tree[100] = ["#smea05#Anyway since you took care of the first two puzzles, why don't I finish this last one on my own?"];
			tree[101] = ["#smea06#But hmm... You can WATCH me. And give me hints."];
			tree[102] = ["#smea04#And also if I'm going too slow feel free to step in."];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 42, "He's with", "She's with");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 42, "He's with", "They're with");
			}

			if (!PlayerData.keclMale)
			{
				DialogTree.replace(tree, 43, "he say", "she say");
				DialogTree.replace(tree, 43, "he coming", "she coming");
			}

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 51, "me he's", "me she's");
				DialogTree.replace(tree, 51, "he's DEFINITELY", "she's DEFINITELY");
				DialogTree.replace(tree, 53, "...He was", "...She was");
			}

			tree[10000] = ["%fun-alpha1%"];
			tree[10001] = ["%fun-nude2%"];
		}
	}

	public static function lowLibido(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["#smea04#So by the way- just in case you noticed how I don't always, well, get a boner when we're messing around..."];
			tree[1] = ["#smea05#It doesn't mean I'm not enjoying myself! It's just that I don't really..."];
			tree[2] = ["#smea06#...I just don't think I get horny the same way other guys do. It's sort of why Kecleon asked me to try this game in the first place!"];
			tree[3] = ["%enterkecl%"];
			tree[4] = ["#kecl10#Hey, hey, waitaminnit! You're makin' it sound like I brought you here, you know, to FIX you or somethin'."];
			tree[5] = ["#kecl06#But it's more like, you never got to play the field the same way I did. And one thing about being in a purely monogamous relationship is like, you're only ever with one guy."];
			tree[6] = ["#smea04#...?"];
			tree[7] = ["#kecl08#So it's like, what if I was just always goin' too fast, or not fast enough, or not gettin' you ready properly?"];
			tree[8] = ["#kecl05#I mean it COULD be you just don't enjoy sex the same way other guys do, but maybe it's just somethin' I'm doin' wrong. ...I just want you to be happy, that sorta thing."];
			tree[9] = ["#smea02#Aww of course I'm happy! I think we just show it in different ways."];
			tree[10] = ["#kecl02#Yeah there see! If you're happy I'm happy. I'm not tryin' to change you into some kinda full throttle sex machine."];
			tree[11] = ["#kecl00#I love my little cuddlepuppy~"];
			tree[12] = ["%fun-alpha0%"];
			tree[13] = ["#smea14#Cuddle... Cuddlepuppy!?"];
			tree[14] = ["%proxykecl%fun-alpha0%"];
			tree[15] = ["#kecl02#Ack! ...Down! Down, Cuddlepuppy!"];
			tree[16] = ["%exitkecl%"];
			tree[17] = ["#smea00#But I'm your cuddlepuppy~~ *kiss* *slrp*"];
			tree[18] = ["#self00#..."];
			tree[19] = ["#self00#(...Maybe I should just get started.)"];
			tree[20] = ["%fun-shortbreak%"];

			tree[10000] = ["%fun-shortbreak%"];

			if (!PlayerData.smeaMale)
			{
				DialogTree.replace(tree, 0, "get a boner", "get sexually excited");
				DialogTree.replace(tree, 2, "other guys", "other girls");
				DialogTree.replace(tree, 8, "other guys", "other girls");
			}
			if (!PlayerData.keclMale)
			{
				DialogTree.replace(tree, 5, "one guy", "one girl");
			}
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["#smea05#So, I think being super into cuddling is OK right?"];
			tree[1] = ["%enterkecl%"];
			tree[2] = ["#kecl05#...?"];
			tree[3] = ["#smea04#I mean, it's OK to be in love with someone but- like- to not want to have sex with them. Isn't that normal for some people?"];
			tree[4] = [30, 50, 20, 40, 10];

			tree[10] = ["Sure,\nthat's\nnormal"];
			tree[11] = ["%setvar-0-4%"];
			tree[12] = ["#kecl04#Yeah, we know a few other couples where one of the partners is way more into sex than the other one. I don't think it's anything too unusual."];
			tree[13] = ["#kecl05#And I don't mind it this way either, I mean... We're still sexually active!"];
			tree[14] = ["#kecl06#It's just sometimes I wish Smeargle could see me the same way I see him."];
			tree[15] = ["#smea01#Well... maybe I don't get horny the same way other guys do... But still, I feel things for you I've never felt for anybody else!"];
			tree[16] = [101];

			tree[20] = ["Well,\nmaybe you\nhave a low\nsex drive"];
			tree[21] = ["%setvar-0-2%"];
			tree[22] = ["#kecl05#Yeah, that's all I think it is!"];
			tree[23] = ["#kecl04#That's one reason I thought it might be good to bring you to a place like this. Maybe something would get flipped on for you or something."];
			tree[24] = ["#smea01#Well... maybe I don't get horny the same way other guys do... But I still find you attractive, and my heart still races when you hold my hand..."];
			tree[25] = [101];

			tree[30] = ["Well,\nmaybe you\ndon't like\nKecleon\nthat way"];
			tree[31] = ["%setvar-0-0%"];
			tree[32] = ["#kecl06#Ohhh I see, like... Like I'm just a really close friend or somethin'?"];
			tree[33] = ["#smea13#What! ...Don't be silly, I definitely see Kecleon as WAY more than a friend."];
			tree[34] = ["#smea01#I mean maybe I don't get horny the same way other guys do... But I still find him attractive, and my heart still races when he holds my hand..."];
			tree[35] = ["#kecl00#Kecl~"];
			tree[36] = [101];

			tree[40] = ["Well, maybe\nyou're\nstraight"];
			tree[41] = ["%setvar-0-3%"];
			tree[42] = ["#smea06#Hmm... maybe? ...But I've never felt sexually attracted to a girl at all."];
			tree[43] = ["#smea04#Maybe it would be different if I got to know one up close... But I really don't think so."];
			tree[44] = ["#smea02#Like my straight friends talk about hitting a certain age and just being like, WHAM titties! WHAM look at that girl's ass! Like they just knew."];
			tree[45] = ["#smea06#They started seeing girls differently, something in their body just \"clicked on\". ...Nothing like that ever happened for me though, like for boys OR for girls."];
			tree[46] = ["#kecl06#Hmm... For boys either, huh..."];
			tree[47] = [100];

			tree[50] = ["Well, maybe\nyou're\nasexual"];
			tree[51] = ["%setvar-0-1%"];
			tree[52] = ["#kecl06#Asexual? Like not sexually attracted to anybody at all? ...Do you think that's what it is?"];
			tree[53] = ["#smea06#Hmm... maybe? It does feel kind of like something never \"clicked on\" for me the way it did for other people when they hit a certain age."];
			tree[54] = ["#smea05#Like I'd fall in love with people sometimes, but it was never a sex thing. It was always just how much I liked them and wanted to spend time with them."];
			tree[55] = ["#smea04#And I'd get horny sometimes, but it was never about other people. Just sort of, vague feelings of sexual arousal. It's hard to describe."];
			tree[56] = ["#smea06#I guess, sort of like how a straight guy might feel if he were born on a deserted island with no girls on it."];
			tree[57] = ["#kecl02#Well, maybe you just hadn't met the right guy yet!"];
			tree[58] = [100];

			tree[100] = ["#smea01#But one thing's for sure, I feel things for Kecleon I've never felt for anyone else!"];
			tree[101] = ["#smea00#I see those cheeks and that cute little lizard face..."];
			tree[102] = ["#kecl00#Aww! ...Sugarbear..."];
			tree[103] = ["%fun-alpha0%"];
			tree[104] = ["#smea02#And... I wanna kiss it! *kiss* *smooch* Oh no! There's a surplus at the kiss factory! *lick* *slrp* *kiss*"];
			tree[105] = ["%proxykecl%fun-alpha0%"];
			tree[106] = ["#kecl03#WAAUGH!! Kiss factory!? Cut it out, you're... You're gettin' your dog slobber all over me!! ...Aagh!"];
			tree[107] = ["#smea00#*lick* You can't shut down *slrp* the kiss factory *kiss* without oversight from *smooch* the kiss commissioner! *lick* *slrp*"];
			tree[108] = ["#kecl00#Kekekekek! Just a second, lemme get-"];
			tree[109] = ["%exitkecl%"];
			tree[110] = ["%exitsmea%"];
			tree[111] = ["#self00#..."];
			tree[112] = ["#self00#(...They turned off the camera?)"];

			tree[10000] = ["%exitsmea%"];

			if (!PlayerData.smeaMale)
			{
				DialogTree.replace(tree, 14, "see him", "see her");
				DialogTree.replace(tree, 15, "other guys", "other girls");
				DialogTree.replace(tree, 24, "other guys", "other girls");
				DialogTree.replace(tree, 34, "other guys", "other girls");
				DialogTree.replace(tree, 56, "straight guy", "straight woman");
				DialogTree.replace(tree, 56, "if he", "if she");
				DialogTree.replace(tree, 56, "no girls", "no guys");
			}
			if (!PlayerData.keclMale)
			{
				DialogTree.replace(tree, 34, "find him", "find her");
				DialogTree.replace(tree, 34, "when he", "when she");
				DialogTree.replace(tree, 42, "to a girl", "to a boy");
				DialogTree.replace(tree, 44, " WHAM titties!", "");
				DialogTree.replace(tree, 44, "girl's ass", "guy's ass");
				DialogTree.replace(tree, 45, "seeing girls", "seeing guys");
				DialogTree.replace(tree, 46, "For boys", "For girls");
				DialogTree.replace(tree, 57, "right guy", "right girl");
			}

			if (PlayerData.smeaMale && !PlayerData.keclMale)
			{
				DialogTree.replace(tree, 40, "straight", "gay");
				DialogTree.replace(tree, 44, "Like my straight friends", "My friends who are gay");
				DialogTree.replace(tree, 56, "a straight", "a typical");
			}
			else if (!PlayerData.smeaMale && PlayerData.keclMale)
			{
				DialogTree.replace(tree, 40, "straight", "a lesbian");
				DialogTree.replace(tree, 44, "Like my straight friends", "My friends who are lesbians");
				DialogTree.replace(tree, 56, "a straight", "a typical");
			}
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["#smea04#...Kecleon's umm, taking a shower."];
			tree[1] = ["#smea05#Don't worry, I didn't... Uhh, I'm still ready for doing stuff later!"];
			tree[2] = ["#smea02#I'm ready for puzzles and... Whatever comes after puzzles! Harf!!"];
			tree[3] = [40, 20, 30, 10];

			tree[10] = ["He's rinsing\noff your\ndog slobber?"];
			tree[11] = ["#smea00#Ha ha! Oh we did a little more than slobber on each other."];
			tree[12] = ["#smea03#He's rinsing off some of his... Kecleon stuff. But I didn't orgasm or anything, so if you want to try something later, I'm still totally ready."];
			tree[13] = [50];

			tree[20] = ["You had\nsex?"];
			tree[21] = ["#smea00#Yeah! Well Kecleon did umm... Kecleon did most of the sexing. So he's rinsing off some of his... Kecleon stuff."];
			tree[22] = ["#smea03#But I didn't orgasm or anything, so if you want to try something again later, I'm still totally ready."];
			tree[23] = [50];

			tree[30] = ["You didn't\norgasm?"];
			tree[31] = ["#smea04#Hmm, well actually I pretty much never get off when Kecleon and I do stuff together."];
			tree[32] = [53];

			tree[40] = ["Don't worry\nabout me!"];
			tree[41] = ["#smea04#Oh it's OK! I didn't go out of my way or anything. I pretty much never orgasm anyways."];
			tree[42] = [53];

			tree[50] = ["#smea02#Yep! Super ready."];
			tree[51] = ["#smea05#..."];
			tree[52] = ["#smea04#Actually, I pretty much never get off when Kecleon and I do stuff together."];
			tree[53] = ["#smea08#Kecleon used to be more self-conscious about it, at first he thought I wasn't enjoying sex because I didn't orgasm!"];

			tree[54] = ["#smea06#...And he worked REALLY hard at it sometimes! We experimented a lot, trying all sorts of different things."];
			tree[55] = ["#smea01#Different things which we definitely enjoyed... Mmmmmm... And we still do a lot of our favorite ones. But none of them make me orgasm for whatever reason."];
			tree[56] = ["#smea04#Really the only thing which works consistently is... and this will sound sort of weird--"];
			tree[57] = ["#smea06#...But if we're doing something like watching TV, where we're both distracted... and I'm jerking off for awhile..."];
			tree[58] = ["#smea10#...And he's not doing ANYTHING with my dick at all, and the stars align perfectly? THEN I can orgasm with him sometimes. But only sometimes!"];
			tree[59] = ["#smea06#So hmm. But yeah, we still have sex! And I still enjoy sex. And we still love each other. I sort of wish I could cum for him easier."];

			tree[60] = [120, 140, 110, 130, 100];
			for (i in 0...5)
			{
				if (PuzzleState.DIALOG_VARS[0] == i)
				{
					tree[60][i] = cast(tree[60][i], Int) + 50;
				}
			}

			tree[100] = ["All of\nthat sounds\nnormal"];
			tree[101] = ["#smea05#Oh, well that's good! Still if there were some way I could just fix it, hmm. I don't know."];
			tree[102] = [200];

			tree[110] = ["Maybe you\nhave a low\nsex drive"];
			tree[111] = ["#smea05#Yeah, it's probably something simple like that. I think that's a good guess."];
			tree[112] = [200];

			tree[120] = ["Maybe you\ndon't like\nKecleon\nthat way"];
			tree[121] = ["#smea10#But... But I love him SO much! Every time I'm around him I just get these feelings, you know?"];
			tree[122] = ["#smea08#...They're not sexual feelings, and maybe they don't even have a sexual component to them. But, there's definitely something."];
			tree[123] = ["#smea12#If it's not love, then... Well, I might as well call it love because it's the closest I've ever felt to anybody."];
			tree[124] = [200];

			tree[130] = ["Maybe\nyou're\nstraight"];
			tree[131] = ["#smea08#I don't know, I've never felt the same way about a girl that I felt about Kecleon!"];
			tree[132] = ["#smea04#Even if it's not in a sexual way, I still think Kecleon and I share a special bond."];
			tree[133] = ["#smea08#I don't know if I could bond that way with a girl, it's sort of hard to imagine. It would have to be a super special kind of girl."];
			tree[134] = ["#smea09#...I guess technically you could be right though."];
			tree[135] = ["#smea06#..."];
			tree[136] = [200];

			tree[140] = ["Maybe\nyou're\nasexual"];
			tree[141] = ["#smea08#I mean, I'll have to do more reading. I guess that sounds like it might describe my feelings towards sex. But... does it matter?"];
			tree[142] = ["#smea05#I'm just not sure putting a word like that on it means anything. I still love Kecleon, and I still want us to be together..."];
			tree[143] = ["#smea06#And maybe if I'm technically asexual and he's technically gay, maybe that's not supposed to work out. But, it works for us."];
			tree[144] = ["#smea02#We're happy, even if maybe the sex is a little clumsy and one-sided. He handles the sex and I handle the kisses, right? Fifty fifty!"];
			tree[145] = [200];

			tree[150] = ["I still\nthink all\nof that\nsounds\nnormal"];
			tree[151] = [101];

			tree[160] = ["I still\nthink you\nmight have\na low sex\ndrive"];
			tree[161] = ["#smea05#Hmm, yeah! I think you're probably right, it's probably something simple like that."];
			tree[162] = [200];

			tree[170] = ["I still\nthink you\nmight not\nlike\nKecleon\nthat way"];
			tree[171] = [121];

			tree[180] = ["I still\nthink you\nmight be\nstraight"];
			tree[181] = [131];

			tree[190] = ["I still\nthink you\nmight be\nasexual"];
			tree[191] = [141];

			tree[200] = ["#smea03#Anyways don't worry about it! I just brought all this stuff up so that YOU wouldn't feel like you were doing something wrong."];
			tree[201] = ["#smea04#Let's get this last puzzle out of the way! I sort of abandoned you on the last puzzle, but I'm going to give you SO much help this time."];
			tree[202] = ["#smea06#..."];
			tree[203] = ["#smea05#Ooh I know! Let's just try a rainbow and see if that works."];

			if (!PlayerData.keclMale)
			{
				DialogTree.replace(tree, 10, "He's rinsing", "She's rinsing");
				DialogTree.replace(tree, 12, "He's rinsing", "She's rinsing");
				DialogTree.replace(tree, 12, "of his...", "of her...");
				DialogTree.replace(tree, 21, "he's rinsing", "she's rinsing");
				DialogTree.replace(tree, 21, "of his...", "of her...");
				DialogTree.replace(tree, 53, "he thought", "she thought");
				DialogTree.replace(tree, 54, "he worked", "she worked");
				DialogTree.replace(tree, 58, "he's not", "she's not");
				DialogTree.replace(tree, 58, "with him", "with her");
				DialogTree.replace(tree, 59, "for him", "for her");
				DialogTree.replace(tree, 121, "love him", "love her");
				DialogTree.replace(tree, 121, "around him", "around her");
				DialogTree.replace(tree, 131, "a girl", "a boy");
				DialogTree.replace(tree, 133, "a girl", "a boy");
				DialogTree.replace(tree, 133, "of girl", "of boy");
				DialogTree.replace(tree, 143, "and he's", "and she's");
				DialogTree.replace(tree, 144, "He handles", "She handles");
			}
			if (!PlayerData.smeaMale)
			{
				DialogTree.replace(tree, 57, "jerking off", "fingering myself");
				DialogTree.replace(tree, 58, "my dick", "my pussy");
			}
			if (PlayerData.smeaMale && !PlayerData.keclMale)
			{
				DialogTree.replace(tree, 130, "straight", "gay");
				DialogTree.replace(tree, 180, "straight", "gay");
				DialogTree.replace(tree, 143, "gay", "straight");
			}
			else if (!PlayerData.smeaMale && PlayerData.keclMale)
			{
				DialogTree.replace(tree, 130, "straight", "lesbian");
				DialogTree.replace(tree, 180, "straight", "lesbian");
				DialogTree.replace(tree, 143, "gay", "straight");
			}
			else if (!PlayerData.smeaMale && !PlayerData.keclMale)
			{
				DialogTree.replace(tree, 143, "gay", "a lesbian");
			}
		}
	}

	public static function random00(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#smea03#Oh hi <name>! ...Somehow I KNEW you were going to show up the instant Kecleon stepped away!"];
		tree[1] = ["#smea05#He was just getting some food, I'll go grab him."];
		tree[2] = ["%fun-longbreak%"];
		tree[10000] = ["%fun-longbreak%"];

		if (!PlayerData.keclMale)
		{
			DialogTree.replace(tree, 1, "He was", "She was");
			DialogTree.replace(tree, 1, "grab him", "grab her");
		}
	}

	public static function random01(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("smea.randomChats.0.3");
		if (count % 6 == 0)
		{
			tree[0] = ["#smea02#Hello again! Back for more from your favorite... puzzle puppy hmm??"];
			tree[1] = ["%enterkecl%"];
			tree[2] = ["#kecl03#Ayy, and don't forget about me, your ehh favorite puzzle LIZARD!!"];
			tree[3] = ["#kecl06#Well I mean... Puzzle reptile!! ...Puzzle solving uhhh... chameleon!"];
			tree[4] = ["#smea10#..."];
			tree[5] = ["#kecl12#Well c'mon don't judge me, yours was easy! You start with a 'P'."];
			tree[6] = ["%exitkecl%"];
			tree[7] = ["#kecl13#Just gimme a sec! ...I'll come up with somethin' good."];
		}
		else if (count % 6 == 1)
		{
			tree[0] = ["#smea02#Hello again! Back for more from your favorite... puzzle puppy hmm??"];
			tree[1] = ["%enterkecl%"];
			tree[2] = ["#kecl03#Ayy, and don't forget about me, your ehh favorite puzzle REPTILE!!!!"];
			tree[3] = ["#kecl06#Well I mean... Puzzle chameleon!! ...Mental uhhh... Iguana?"];
			tree[4] = ["#smea10#...Logic Lizard?"];
			tree[5] = ["#kecl13#Logic lizard!? Gahhh... how did I miss that!? It was right freakin' there!"];
			tree[6] = ["#kecl12#Okay okay, that's fine. I'm the Logic Lizard. But still, woulda been kinda nice if I coulda thought of my own name."];
			tree[7] = ["#kecl06#I guess words just aren't in my blood or somethin'. I'm not, you know, the... you know. Grammar Iguana. Uhh, the wordplay... Reptile."];
			tree[8] = ["#smea04#...Language Lizard?"];
			tree[9] = ["%exitkecl%"];
			tree[10] = ["#kecl13#Daahhhh whatever!"];
		}
		else if (count % 6 == 2)
		{
			tree[0] = ["#smea02#Hello again! Back for more from your favorite... puzzle puppy hmm??"];
			tree[1] = ["%enterkecl%"];
			tree[2] = ["#kecl03#Ayy, and don't forget about me, the logic lizard!!"];
			tree[3] = ["#smea04#Hey <name>, you need a cool puzzle name too! Kecleon, why don't you come up with a good name for <name>."];
			tree[4] = ["#kecl10#Ehh? What!? Why me!"];
			tree[5] = ["#smea03#Well you know! I thought of both of OUR names. It's your turn now! You can do it! There's a really easy one!"];
			tree[6] = ["#kecl06#...Ahh geez. Okay. Gimme... Gimme a minute. I'll get this... You're like, the... The puzzle hand. The uhh, glove of... glove of cleverness."];
			tree[7] = ["#kecl02#The cleverness glove! Hey, there we go, I did it! How's that? That's good, right? Cleverness glove? Has a certain ehhh.... ring!"];
			tree[8] = ["#smea10#..."];
			tree[9] = ["%exitkecl%"];
			tree[10] = ["#kecl13#Dahhhh c'mon! Gimme a hint!"];
		}
		else if (count % 6 >= 3)
		{
			tree[0] = ["#smea02#Hello again! Back for more from your favorite... puzzle puppy hmm??"];
			tree[1] = ["%enterkecl%"];
			tree[2] = ["#kecl03#Ayy, and don't forget about me, the logic lizard!!"];
			tree[3] = ["#smea05#...And..."];
			tree[4] = [FlxG.random.getObject([
												 "#kecl06#And uhh, our good friend <name>! The uhh... hand of... uhhh...",
												 "#kecl06#And uhh, our good friend <name>! The uhh, glove of... uhhh... Somethin' starting with G...",
												 "#kecl06#And uhh, our good friend <name>! The uhh... puzzle-solving, uhh...",
												 "#kecl06#And uhh, our good friend <name>! Somethin' with... knuckle... uhh, finger...",
											 ])];
			tree[5] = ["#smea10#..."];
			tree[6] = ["%exitkecl%"];
			tree[7] = ["#kecl13#Dahhhh why you gotta torture me like this!"];
		}
	}

	public static function random02(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["%enterkecl%"];
		tree[1] = ["%fun-alpha0%"];
		tree[2] = ["#kecl05#Ayyy back for more eh? Hey Smeargle c'mere we got a guest!"];
		tree[3] = ["%fun-alpha1%"];
		tree[4] = ["#smea02#Oh hey <name>! I was wondering when you'd show up again. Let's see what we can do with this first puzzle!"];
		tree[5] = ["%exitkecl%"];
		tree[6] = ["#smea06#...Hmmm... Hmm, yes I see... Oh! Hmmmm..."];
		tree[7] = ["#smea10#Sorry! ...I'm just pretending, I have no idea."];

		tree[10000] = ["%fun-alpha1%"];
	}

	public static function random03(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("smea.randomChats.0.3");
		tree[0] = ["#smea03#Hi <name>! Ready for more puzzles?? ...Let's try using more hints this time. Harf!"];
		if (count % 3 == 0)
		{
			tree[1] = ["#smea04#Because, I don't understand why you don't use more hints! ...Abra will practically TELL you the answer if you keep asking for hints."];
			tree[2] = ["%enterkecl%"];
			tree[3] = ["#kecl06#Well, yeah but he also gives you like barely any prize money if you abuse hints, Smeargle..."];
			tree[4] = ["#smea10#Wait, what!? He takes away your money?"];
			tree[5] = ["#kecl04#Nah well, he doesn't take anything away so to speak. He just gives ya less."];
			tree[6] = ["%fun-shortbreak%"];
			tree[7] = ["#smea12#...Well that's not fair! ...I'm going to go tell Abra that's not fair. He didn't tell me he was taking my money..."];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 3, "but he", "but she");
				DialogTree.replace(tree, 4, "what!? He", "what!? She");
				DialogTree.replace(tree, 5, "well, he", "well, she");
				DialogTree.replace(tree, 5, "speak. He", "speak. She");
				DialogTree.replace(tree, 7, "fair. He", "fair. She");
				DialogTree.replace(tree, 7, "me he", "me she");
			}
		}
		else
		{
			tree[1] = ["%enterkecl%"];
			tree[2] = ["#kecl06#...Didn't we go over this before? <name> doesn't wanna use hints 'cause they kinda cost money."];
			tree[3] = ["#smea08#But like... These puzzles are WAY too hard without hints!"];
			tree[4] = ["%exitkecl%"];
			tree[5] = ["#smea10#...I'm pretty sure you're supposed to use SOME hints, <name>..."];
		}
	}

	public static function gift04(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["%enterkecl%"];
		tree[1] = ["#kecl03#Holy smokes <name>! ...How are you so frickin' nice!? Are you kiddin' me?"];
		tree[2] = ["#kecl02#I got your present, it was all gift wrapped and set out for me on my usual spot. It's perfect, oh my god! I like, I didn't even know this thing existed."];
		tree[3] = ["#kecl05#And I mean even if I DID know it existed wouldn'ta had the smarts to set it up, but this thing's just like, out of the box ready to go..."];
		tree[4] = ["#kecl03#...And it's like, it's got SO many games! They're listed out all here in this note, all these old favorites I get to teach Smeargle..."];
		tree[5] = ["#kecl07#I mean, can you believe he's never heard of Super Bomberman? C'mon Smeargle, what kinda deprived childhood did you lead to never play frickin' Bomberman!!"];
		tree[6] = ["#smea04#Well, I never got any console game stuff until after college! ...It just seemed like everything I really wanted to play was on computers anyways."];
		tree[7] = ["#kecl06#Nahh computers... Nah, console gaming's just a way different experience! 'Slike, ehhh, y'know..."];
		tree[8] = ["#kecl04#Sittin' shoulder-to-shoulder with your buddies, crowded around a TV, inventin' new curse words to yell at each other, it's a more intimate thing!"];
		tree[9] = ["#smea06#Mmm, that sounds fun! ...Newer consoles never have a lot of stuff we can play together. Everything's online now!"];
		tree[10] = ["#smea05#...But this sounds different, it sounds really neat~"];
		tree[11] = ["%exitkecl%"];
		tree[12] = ["#kecl03#...Thanks again <name>! ...You're like, the best! The best! Aaaaaahh! I can't wait to get home and play!"];
		tree[13] = ["#smea02#Ha! Ha. He's so cute when he gets excited like this~"];
		tree[14] = ["#smea05#But umm... anyways, yeah! It's nice to see you again, <name>! And that was a really nice gesture~"];
		tree[15] = ["#smea04#...So, should we get started with some puzzles?"];

		if (!PlayerData.smeaMale)
		{
			DialogTree.replace(tree, 5, "believe he's", "believe she's");
		}
	}

	static private function getPopularColor(puzzleState:PuzzleState)
	{
		var countMap:Map<Int, Int> = new Map<Int, Int>();
		var maxColorIndex:Int = 0;
		for (color in 0...puzzleState._puzzle._colorCount)
		{
			countMap[color] = 0;
		}
		for (guess in puzzleState._puzzle._guesses)
		{
			for (peg in guess)
			{
				countMap[peg]++;
				if (countMap[peg] > countMap[maxColorIndex])
				{
					maxColorIndex = peg;
				}
			}
		}
		return Critter.CRITTER_COLORS[maxColorIndex].english;
	}

	public static function random10(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var popularColor:String = getPopularColor(puzzleState);
		tree[0] = ["#smea05#Ooh another puzzle, let's see... Oh, there's definitely a " + popularColor + " in the answer this time!"];
		tree[1] = ["#kecl06#Ehh, just a little tip Smeargle..."];
		tree[2] = ["#kecl05#You might have an easier time giving <name> some actual HELPFUL advice if you waited for the bugs to jump in their little boxes there!"];
		tree[3] = ["#smea04#Ehh? But it doesn't even matter which boxes they jump into..."];
		tree[4] = ["#smea02#There's SO many " + popularColor + " bugs out there, at least one of them has to be correct. I'm super sure!"];
	}

	public static function random11(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#smea06#Hmm! Hmm yes, yes. Very interesting."];
		tree[1] = ["#smea05#Do you like that? Those are my thinking sounds."];
	}

	public static function random12(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var popularColor:String = getPopularColor(puzzleState);
		tree[0] = ["#kecl06#Hey wait, uhh, haven't we seen this one before?"];
		tree[1] = ["#smea04#No, this one's different! I don't think they'd give us the same one twice. ...I think I'd remember seeing this many " + popularColor + "s in one puzzle."];
	}

	public static function random13(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var time:Float = RankTracker.RANKS[8] * puzzleState._puzzle._difficulty;
		time = Math.max(time, 100);
		var timeStr:String = DialogTree.durationToString(time);
		var count:Int = PlayerData.recentChatCount("smea.randomChats.1.3");
		if (count % 2 == 0)
		{
			tree[0] = ["#smea04#Are you supposed to solve these puzzles this fast?"];
			tree[1] = ["#smea12#I mean they usually take me about " + timeStr + ", I think maybe you're not solving them right."];
		}
		else if (count % 2 == 1)
		{
			tree[0] = ["#smea04#Hmm, I sort of think of myself as like, a puzzle connoisseur."];
			tree[1] = ["#smea12#Just like how a wine connoisseur wouldn't chug a glass of wine, I think I like taking my time with these puzzles a little more! It's not always a race, right?"];
			if (puzzleState.isRankChance())
			{
				tree[2] = ["#kecl06#Err, well this one's a rank chance. So it's EXACTLY a race."];
				tree[3] = ["#smea13#Oh, just... nevermind!!"];
			}
			else
			{
				tree[2] = ["#kecl06#Err, well except for those rank chances. Then it's EXACTLY a race."];
				tree[3] = ["#smea10#Well, I guess sometimes when you get those rank chances it's a race but..."];
				tree[4] = ["#smea13#Oh, just... nevermind!!"];
			}
		}
	}

	public static function random14(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["%nextden-grim%"];
		tree[1] = ["%enterkecl%"];
		tree[2] = ["#kecl06#Hey wait, uhh, haven't we seen this one before?"];
		tree[3] = ["#smea06#No, this one's different! I don't think they'd give us... (sniff) give us the, ummm... (sniff, sniff)"];
		tree[4] = ["%fun-alpha0%"];
		tree[5] = ["#smea12#Oh, Kecleon! ...Seriously!"];
		tree[6] = ["#kecl04#What!? C'mon, waddaya lookin' at me for!"];
		tree[7] = ["%entergrim%"];
		tree[8] = ["#grim04#Hey guys! How's it gooing?"];
		tree[9] = ["#kecl12#Ehh... It was goo-ing fine 'til you up and drove Smeargle away."];
		tree[10] = ["#grim10#Oh uhh... sorry! I'm sorry. I was just wondering about that back room behind Heracross's store..."];
		tree[11] = ["#grim06#Is that like... for anybody? Can anybody go back there?"];
		tree[12] = ["#kecl05#Ehh? Yeah, go nuts! ...Matter of fact, I encourage it. It'll gimme some time to throw down some Febreze or somethin' out here, get some of your stank out..."];
		tree[13] = ["#grim02#Yeah! Good thinking!! Well, if anybody's looking for me, you can tell them I'll be cooped up in that little room, okay?"];
		tree[14] = ["#kecl12#... ...I absolutely guarantee you, you will have that small, modestly ventilated room all to your stinky self."];
		tree[15] = ["%exitgrim%"];
		tree[16] = ["#grim03#...Gloop!"];
		tree[17] = ["%exitkecl%"];
		tree[18] = ["#kecl06#Now let's see. Where do they keep the Febreze..."];
		tree[19] = ["%fun-longbreak%"];

		tree[10000] = ["%fun-longbreak%"];
	}

	public static function random20(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var suggestion0:String = "";
		var suggestion1:String = "";
		for (i in 0...10)
		{
			var cute0:String = FlxG.random.getObject(["pomeranian", "poopy|poop", "fetal|fetus", "lint", "squish", "cricket"]);
			var cute1:String = FlxG.random.getObject(["fluff", "cuddle", "baby", "poof", "fuzz", "foofy|foof"]);

			var food0:String = FlxG.random.getObject(["quiche", "meatball", "loaf", "donut", "pineapple", "burrito"]);
			var food1:String = FlxG.random.getObject(["pickle", "pie", "sugar|cake", "pudding", "pumpkin", "peanut"]);

			if (FlxG.random.bool())
			{
				suggestion0 = beforePipe(cute0) + " " + afterPipe(food0);
			}
			else
			{
				suggestion0 = beforePipe(food0) + " " + afterPipe(cute0);
			}

			if (FlxG.random.bool())
			{
				suggestion1 = beforePipe(cute1) + " " + afterPipe(food1);
			}
			else
			{
				suggestion1 = beforePipe(food1) + " " + afterPipe(cute1);
			}
		}
		tree[0] = ["%enterkecl%"];
		tree[1] = ["#kecl02#Hey ahhh, if you don't need Smeargle's help I can maybe keep him distracted for a little. Check this out."];
		tree[2] = [10, 20, 30];

		tree[10] = ["No, don't\ndo it"];
		tree[11] = [50];

		tree[20] = ["Yes, thank\nyou"];
		tree[21] = [50];

		tree[30] = ["What do\nyou mean?"];
		tree[31] = [50];

		tree[50] = ["#kecl03#Ayy! Ayyy Smeargle! How's my little, err, " + suggestion0 + "? You ready for another puzzle?"];
		tree[51] = ["#smea04#..." + cap(suggestion0) + "? ...Kecleon, you're just being weird."];
		tree[52] = ["#kecl06#Ehh? I don't get it. Usually the guy goes nuts for me when I mix, y'know, a cute word and a food word."];
		tree[53] = ["#kecl04#Smeargle, you're truly an enigma."];
		tree[54] = ["#smea12#Hmph! I can tell when you're just trying to manipulate me. The yellow loopies around your eyes get all scroogly."];
		tree[55] = ["#kecl08#Aww I didn't mean it, " + suggestion1 + ". How can I make it up to you?"];
		tree[56] = ["%fun-alpha0%"];
		tree[57] = ["#smea14#..." + cap(suggestion1.substr(0, suggestion1.indexOf(" "))) + "... " + cap(suggestion1) + "!?!?!"];
		tree[58] = ["%proxykecl%fun-alpha0%"];
		tree[59] = ["#kecl00#Keck! Kekekekeke~ C'mere, you!"];

		if (!PlayerData.smeaMale)
		{
			DialogTree.replace(tree, 1, "keep him", "keep her");
			DialogTree.replace(tree, 52, "the guy", "the girl");
		}

		tree[10000] = ["%fun-longbreak%"];
	}

	public static function random21(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["%fun-nude1%"];
		tree[1] = ["#smea10#Hmm? OH! Right!!"];
		tree[2] = ["%fun-nude2%"];
		tree[3] = ["#smea03#Ahem, so you solved another puzzle. We! WE! Solved another puzzle. Remember that part where I helped?"];
		tree[4] = ["#smea05#You were like REALLY really stuck and I came up with that great idea."];
		tree[5] = ["#smea02#...I didn't say it out loud because I thought you were already doing such a good job!"];
	}

	public static function random22(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = [FlxG.random.getObject(["#smea03#Yeahhhh! We did it! We're like, an unstoppable puzzle team, you and me.",
										  "#smea03#Woooooo! We did it! Nobody can stop our unstoppable puzzle team. Smeargle and <name>!",
										  "#smea03#Hooray! Another puzzle down! Nobody stops the unstoppable puzzle duo!"])];
		if (PlayerData.recentChatCount("smea.randomChats.2.2") % 2 == 0)
		{
			tree[1] = ["%enterkecl%"];
			tree[2] = ["#kecl02#C'mon, be real... <name> here did all the work. If you're gonna steal his credit then I want some credit too!"];
			tree[3] = ["#smea04#Sure, that's fine with me! What do you think <name>?"];
			tree[4] = [20, 40, 10, 30];

			tree[10] = ["Sure, Kecleon\nhelped too"];
			tree[11] = ["#kecl03#Yeah that's right! You couldn'ta gotten through that last one without your little lizard buddy."];
			tree[12] = ["#kecl05#So ehh, where's my cut?"];
			tree[13] = ["#smea12#Tsk, don't be so greedy! We're not in this for the money."];
			tree[14] = [50];

			tree[20] = ["No, it was\njust us two"];
			tree[21] = ["#kecl13#What!!! Ehh c'mon, I did as much as Smeargle here! Gimme a break."];
			tree[22] = ["#smea12#Sorry Kecleon. Maybe you're just not puzzley enough for our puzzle team yet!"];
			tree[23] = [50];

			tree[30] = ["No, I did\neverything"];
			tree[31] = ["#smea05#Well! You moved all the bugs around, but we all know I helped too."];
			tree[32] = ["#kecl06#Err, I'm pretty sure he said-"];
			tree[33] = ["#smea12#Hmph, I HELPED! ...We're a team! You just didn't understand what he meant."];
			tree[34] = [50];

			tree[40] = ["I don't\ncare"];
			tree[41] = ["#smea05#Well if <name> doesn't care, then I say, yes! Welcome to the team!"];
			tree[42] = ["#kecl05#Ayy, great! ...So ehh, where's my cut?"];
			tree[43] = ["#smea06#Your... cut?"];
			tree[44] = ["#kecl03#Yeah, my cut for that puzzle I helped solve! ...I ain't workin' for free!"];
			tree[45] = ["#smea12#Tsk, don't be so greedy! We're not in this for the money."];
			tree[46] = [50];

			tree[50] = ["%exitkecl%"];
			tree[51] = ["#smea02#Okay, one last puzzle! Unstoppable puzzle team force, gooooooo!!"];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 2, "his credit", "her credit");
				DialogTree.replace(tree, 32, "he said", "she said");
				DialogTree.replace(tree, 33, "he meant", "she meant");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 2, "his credit", "their credit");
				DialogTree.replace(tree, 32, "he said", "they said");
				DialogTree.replace(tree, 33, "he meant", "she meant");
			}
		}
		else
		{
			tree[1] = ["#smea06#Wait, does anybody else hear that... faint rumbling sound?"];
			tree[2] = ["%enterkecl%"];
			tree[3] = ["#kecl07#Oh god, cover your ears..."];
			tree[4] = ["%enterrhyd%"];
			tree[5] = ["#RHYD03#Groarrr! What's up <name>! ...Whoa, you're with uhh two Pokemon at once? What, you got some weird three-way thing going?"];
			tree[6] = ["#kecl06#Three-way? Nahh, <name>'s just like, a tenth of a person at most. It's really just a 2.1-way if that."];
			tree[7] = ["%exitrhyd%"];
			tree[8] = ["#RHYD12#Well, whatever. Just try to keep the noise down! I can hear you guys all the way in my room with the door shut."];
			tree[9] = ["#kecl10#Um, oh... Okay? ...Sorry?"];
			tree[10] = ["#smea10#Wait, what just happened...? Did he come over here... for a noise complaint?"];
			tree[11] = ["#kecl06#We got a noise complaint... from Rhydon?"];

			if (!PlayerData.rhydMale)
			{
				DialogTree.replace(tree, 10, "he come", "she come");
			}
		}
	}

	static private function random23(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("smea.randomChats.2.3") % 4;

		if (count % 4 == 0)
		{
			tree[0] = ["%enterkecl%"];
			tree[1] = ["#kecl00#Ooh! Lookin' good, Smeargle."];
			tree[2] = ["#kecl01#Say, why don'tcha turn around! Give 'em a-"];
			tree[3] = ["%enterhera%"];
			tree[4] = ["#hera03#Oh hey <name>! Hi! So you're playing with... Oowaaaahhhh! What do we have here?"];
			tree[5] = ["#hera05#Are you guys doing a little two-for-one dealy? Wait, Kecleon, why aren't you naked?"];
			tree[6] = ["#kecl06#Ayyy y'know, I'm one of them... non-participant types! ...I'm just here to watch."];
			tree[7] = ["#hera06#Come to think of it, I always see Smeargle playing with <name>, but I've never seen you get a turn. ...That's kind of unfair, isn't it?"];
			tree[8] = ["#smea09#Unfair? ... ...Ohhhhhh.... Oh no, I never thought of it that way..."];
			tree[9] = ["#kecl06#What? Ehhh c'mon, you crazy? This ain't unfair, this is exactly how I wanted it. You... You take your turn with <name>. See Heracross,"];
			tree[10] = ["#kecl04#I'm a little ehh, more well-travelled compared to Smeargle here."];
			tree[11] = ["#kecl05#Little more adventurous, little more experienced when it comes to the sex stuff."];
			tree[12] = ["#kecl04#So to me, if Smeargle messes around a little, doesn't bother me in the slightest. ...The kid's just playin' catchup, y'know?"];
			tree[13] = ["#smea08#... ..."];
			tree[14] = ["#kecl05#Other way around though's a different story. Smeargle ain't so secure about that stuff, so I figure, I start messin' around with strangers, gettin' my rocks off,"];
			tree[15] = ["#kecl06#...I ain't no fortune teller but I think it'd rouse all sorts of ehh... general icky feelings comin' from his side of things. ... ...'Sjust my guess."];
			tree[16] = ["#smea03#Kecleon, if you want a turn you can take a turn! ...I'm like, totally okay with it."];
			tree[17] = ["#kecl03#Tsk nahhh, to heck with that! I like our little cooperative puzzle team here. ... ...Why spoil a good thing?"];
			tree[18] = ["#kecl02#Anyway, that answer your question Heracross?"];
			tree[19] = ["%exithera%"];
			tree[20] = ["#hera04#...Yeah, I think I see how it is! You kids have fun~"];
			tree[21] = ["%exitkecl%"];
			tree[22] = ["#smea01#I am going to have SO MUCH FUN! I am going to put on the best sexy show for you, Kecleon!"];
			tree[23] = ["#smea05#...Oh! After we finish this one puzzle. Are you ready, <name>? Goooooo puzzle team!"];

			if (!PlayerData.smeaMale)
			{
				DialogTree.replace(tree, 15, "from his", "from her");
			}
		}
		else if (count % 4 == 1)
		{
			tree[0] = ["%enterkecl%"];
			tree[1] = ["#kecl00#Ooh! Lookin' good, Smeargle."];
			tree[2] = ["#kecl01#Say, why don'tcha-"];
			tree[3] = ["%enterhera%"];
			tree[4] = ["#hera03#Oh hey <name>! Hi! ... ...Playing with Smeargle and Kecleon again?"];
			tree[5] = ["#hera02#Well, that sounds like fun on a bun! Is there room for one extra hot dog in this fun-bun?"];
			tree[6] = ["#kecl06#Eghhh, sorry Heracross. I think you'd be kind of a... fourth wheel, if you catch my drift."];
			tree[7] = ["#hera04#What!? Cars have four wheels... ...Everything has four wheels! Four wheels is an ordinary amount of wheels."];
			tree[8] = ["#kecl12#D'ehh, okay Mr. Pedantic over there, you'd be more like a, uhhhh... A fourth ninja turt--- no wait, a ehhh... fourth musketeer."];
			tree[9] = ["#hera05#...Oooooh! Fourth Musketeer? You mean D'artagnan?"];
			tree[10] = ["%exitkecl%"];
			tree[11] = ["#kecl13#Gah, just get... Get outta here! C'mon! You're intrudin' on all our sexy times."];
			tree[12] = ["%exithera%"];
			tree[13] = ["#hera11#Gwehhhhh!"];
			tree[14] = ["#kecl05#Pesky bee! ...Alright anyway, so where were we..."];
			tree[15] = ["#smea06#...Mmmmm... ...I kind of forget. <name>, do you remember what we were going to do next?"];

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 5, "hot dog in", "patty on");
				DialogTree.replace(tree, 8, "Mr. Pedantic", "Princess Pedantic");
			}
		}
		else
		{
			tree[0] = ["%enterkecl%"];
			tree[1] = ["#kecl00#Ooh! Lookin' good, Smeargle."];
			tree[2] = ["#kecl01#Say, why don'tcha turn around! Give e'm a good look of that little puppy keester of yours~"];
			tree[3] = ["#smea10#...What? ...No! That's a little too much, Kecleon."];
			tree[4] = ["#smea08#Can't I keep my backside a secret? ...<name>'s already seen my entire frontside. There's a lot of very private stuff up there!"];
			tree[5] = ["%exitkecl%"];
			tree[6] = ["#kecl12#Ehhhh fine, fine, fair enough. You're the boss."];
			tree[7] = ["#smea05#Hmmmm yeah! I think I'll keep it a secret for now. ... ...Let's do this final puzzle together, <name>!"];
			tree[8] = ["#smea06#..."];
			tree[9] = ["#smea04#... ...Don't worry, it's just a normal butt! You're not missing much."];
		}
	}

	static private function random24(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("smea.randomChats.2.4") % 3;

		if (count % 3 == 0)
		{
			tree[0] = ["#smea02#Not to toot your horn, <name>, but I think you rocked the heck out of that last puzzle! Harf!"];
			tree[1] = ["%enterkecl%"];
			tree[2] = ["#kecl05#Wait. You're tootin' <name>'s horn!? You can't like... toot someone else's horn. That's not a thing."];
			tree[3] = ["#kecl06#Like, you can toot your OWN horn. I've heard of that one. ...But you can't just like, go around tootin' random horns..."];
			tree[4] = ["%fun-alpha0%"];
			tree[5] = ["#smea13#...Don't YOU tell me what I can toot!"];
			tree[6] = ["#kecl11#Gah! Get away from me!"];
			tree[7] = ["%proxykecl%fun-alpha0%"];
			tree[8] = ["#smea13#Maybe I'll toot you! Toot! Toot!"];
			tree[9] = ["#kecl13#Stop it! Aaaaaaaagh!! Bad! ...Bad dog!!!"];
			tree[10] = ["%fun-alpha1%"];
			tree[11] = ["%proxykecl%fun-alpha1%"];
			tree[12] = ["#smea12#Hmph. Telling me what to toot..."];
			tree[13] = ["%exitkecl%"];
			tree[14] = ["#smea04#Anyways, how many more puzzles do we have, like ten more? That sounds about right! Then we can do the sex stuff after."];

			tree[10000] = ["%fun-alpha1%"];
		}
		else if (count % 3 == 1)
		{
			tree[0] = ["#smea03#I'm officially tooting your horn again, <name>. Toot! Good job! Toot! Toot!"];
			tree[1] = ["%enterkecl%"];
			tree[2] = ["#kecl09#Eeeeegh. It doesn't even make any sense..."];
			tree[3] = ["#smea13#... ...!"];
			tree[4] = ["%exitkecl%"];
			tree[5] = ["#kecl10#Okay okay! Eesh! Sorry! ...I forgot we had the freakin' toot police over here."];
			tree[6] = ["#smea02#Ha! Ha ha ha. Okay, okay. I think just five more puzzles and I'll be ready! That's okay, right?"];
		}
		else
		{
			tree[0] = ["#smea05#That was some fancy puzzle solving, <name>!"];
			tree[1] = ["#smea02#I'm going to give you my highest rating. Three toots! Toot! Toot! Toot!"];
			tree[2] = ["%enterkecl%"];
			tree[3] = ["#kecl13#Three toots!? ...Bah, lookit this guy just givin' away toots now!"];
			tree[4] = ["#kecl12#I remember when toots used to mean somethin'..."];
			tree[5] = ["#smea00#I remember yourrrrrr first toot~"];
			tree[6] = ["#kecl02#...Ehhh!?! Don't you look at me that way!"];
			tree[7] = ["#smea01#... ... ..."];
			tree[8] = ["#kecl00#Stop iiiiiit!! You're makin' me nervous~"];
			tree[9] = ["%exitkecl%"];
			tree[10] = ["#smea02#Ha! Ha ha ha. Okay, okay. I think just twenty more puzzles should do it."];
			tree[11] = ["#smea03#Twenty more puzzles, and if we run out of time that's okay! ...We can just have sex another time. Harf~"];

			if (!PlayerData.smeaMale)
			{
				DialogTree.replace(tree, 3, "this guy", "this girl");
			}
		}
	}

	static private function cap(str:String):String
	{
		return str.substr(0, 1).toUpperCase() + str.substr(1, str.length).toLowerCase();
	}

	public static function sexyBefore0(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		tree[0] = ["#smea03#So I don't know if Abra told you, but I think after I take all my clothes off... I'm supposed to put them back on so we can solve more puzzles!"];
		tree[1] = ["#smea06#...At least that's what I THINK he said. I don't remember if something was supposed to happen in between."];
		if (!PlayerData.abraMale)
		{
			DialogTree.replace(tree, 1, "he said", "she said");
		}
	}

	public static function sexyBefore1(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		tree[0] = ["#smea04#So just because I'm naked doesn't mean we have to do naked stuff!"];
		tree[1] = ["#smea05#...We can just do, you know, fun puppy stuff!!"];
		var count:Int = PlayerData.recentChatCount("smea.randomChats.2.0");
		if (count % 3 == 0)
		{
			tree[2] = ["#kecl00#Aww! I wanna do fun puppy stuff too!!"];
			tree[3] = ["#smea12#Hey fair's fair! <name> earned his fun puppy time by using his brains to solve all those puzzles. When's the last time you solved a puzzle to play with me? Hmm?"];
			tree[4] = ["#kecl06#Well, errr... I uh, solved the puzzle of uhh..."];
			tree[5] = ["#kecl04#...Like how about when we got that new bottle of lube and the stuff wouldn't come out?"];
			tree[6] = ["#smea04#You mean... You're talking about that paper thing they put on the top? I think anybody could have-"];
			tree[7] = ["#kecl09#..."];
			tree[8] = ["#smea10#...Okay, good job Kecleon. You're smart too."];
			tree[9] = ["#kecl00#Kecl~"];
			tree[10] = ["#smea05#Anyway <name>, did you have anything planned? Maybe like, an all-over puppy massage this time."];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 3, "his fun", "her fun");
				DialogTree.replace(tree, 3, "his brains", "her brains");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 3, "his fun", "their fun");
				DialogTree.replace(tree, 3, "his brains", "their brains");
			}
		}
		else
		{
			tree[2] = ["#kecl00#Aww! I wanna do fun puppy stuff too!! ...With my little smush gr-"];
			tree[3] = ["#smea13#-Hey, cut that out! What's <name> going to do if you hypnotize me with your... adorable terms of endearment?"];
			tree[4] = ["#kecl06#...Oh yeah! I guess that would be kind of weird if you hopped off camera in the middle of this part."];
			tree[5] = ["#kecl03#Alright, you two have your fun. Put on a good show for me, will ya? Keck-kekekek."];
		}
	}

	public static function sexyBefore2(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		tree[0] = ["#smea04#So now that we... Oh! I mean now that we're..."];
		tree[1] = ["#smea07#...Sorry <name>, I know he's off-camera but Kecleon's touching himself and it's VERY DISTRACTING."];
		tree[2] = ["#kecl01#Hey it ain't my fault! My hands are just doing what err uh, what comes naturally."];
		tree[3] = ["#kecl00#It's like they say... Idle hands are the devil's playthings. Anyway maybe y'know, maybe I'd be less distracting if I joined the two of you eh?"];
		tree[4] = [60, 10, 40, 30, 20, 50];
		tree[4].splice(FlxG.random.int(0, tree[4].length - 1), 1);
		tree[4].splice(FlxG.random.int(0, tree[4].length - 1), 1);

		tree[10] = ["It's like\nthey say,\ntoo many\ncooks spoil\nthe broth"];
		tree[11] = ["#kecl06#Err, oh I get it! You're saying if we REALLY wanna treat Smeargle nice, we gotta work together. You know, so we can spoil him!"];
		tree[12] = ["#smea06#I think <name>'s saying you'll only get in the way if you try to help! Isn't that right, <name>?"];
		tree[13] = [100, 110, 120, 130];

		tree[20] = ["It's like\nthey say,\nabsence\nmakes the\nheart grow\nfonder"];
		tree[21] = ["#kecl06#Err, oh I get it! You're warning me that I should hurry up and join you guys, before my heart gets all clogged up with fondness."];
		tree[22] = ["#smea06#I think <name>'s saying you'll love me more if you stay over there by yourself for a few minutes! Isn't that right, <name>?"];
		tree[23] = [100, 110, 120, 130];

		tree[30] = ["It's like\nthey say,\nmany hands\nmake light\nwork"];
		tree[31] = ["#kecl06#Err, oh I get it! You're saying it's only half as much effort for the both of us if we tag-team Smeargle here."];
		tree[32] = ["#smea10#I think <name>'s saying if the two of us are on camera together, the lights might stop working! Isn't that right, <name>?"];
		tree[33] = [100, 110, 120, 130];

		tree[40] = ["It's like\nthey say,\nif you can't\nbeat 'em,\njoin em"];
		tree[41] = ["#kecl06#Err, oh I get it! You're saying I can't compete with the sexy show you two are about to put on, so I should join in."];
		tree[42] = ["#smea10#I think <name>'s warning you that he'll beat you if you join us! Isn't that right, <name>?"];
		tree[43] = [100, 110, 120, 140];

		tree[50] = ["It's like\nthey say,\nthe squeaky\nwheel gets\nthe grease"];
		tree[51] = ["#kecl01#Err, oh I get it! You're saying Smeargle's got a squeaky wheel, and the two of us should grease 'em up."];
		tree[52] = ["#smea12#I think <name>'s calling YOU squeaky... Because you're being like, wheely annoying right now! Isn't that right, <name>?"];
		tree[53] = [100, 110, 120, 130];

		tree[60] = ["It's like\nthey say,\nmighty oaks\nfrom acorns\ngrow"];
		tree[61] = ["#kecl06#Err, oh I get it! You're saying it was a good thing I asked, 'cause now we're gonna have this monumental 3-way kinda thing."];
		tree[62] = ["#smea06#I think <name>'s explaining how something that seems innocuous at the time might cause problems later! Isn't that right, <name>?"];
		tree[63] = [130, 120, 100, 110];

		tree[100] = ["You're right,\nSmeargle"];
		tree[101] = [150];

		tree[110] = ["Kecleon was\nright"];
		tree[111] = [150];

		tree[120] = ["You're both\nway off"];
		tree[121] = [150];

		tree[130] = ["...Ehh?"];
		tree[131] = [150];

		tree[140] = ["Holy shit\nno why\nwould you\neven think\nthat oh my\ngod what"];
		tree[141] = [150];

		tree[150] = ["#kecl03#Keck-kekekeke. I was just messing with you, <name>, you can have him to yourself this time."];
		tree[151] = ["#kecl04#Besides, the camera kinda hates me anyway. Somehow these overhead lights always catch the wrong side of my gross lizard pores."];

		if (!PlayerData.smeaMale)
		{
			DialogTree.replace(tree, 11, "spoil him", "spoil her");
			DialogTree.replace(tree, 42, "he'll beat", "she'll beat");
			DialogTree.replace(tree, 51, "grease 'em", "grease 'er");
			DialogTree.replace(tree, 150, "have him", "have her");
		}
		if (!PlayerData.keclMale)
		{
			DialogTree.replace(tree, 1, "know he's", "know she's");
			DialogTree.replace(tree, 1, "touching himself", "touching herself");
		}
	}

	public static function sexyBefore3(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		if (PlayerData.justFinishedMinigame)
		{
			tree[0] = ["#smea05#So I know I'm kinda talented at those minigames... But I'm SUPER talented at being cute and naked!"];
		}
		else
		{
			tree[0] = ["#smea05#So I know I kind of dropped the ball on the puzzle stuff... But I'm SUPER talented at being cute and naked!"];
		}

		var count:Int = PlayerData.recentChatCount("smea.sexyBeforeChats.3");
		if (count % 3 == 0)
		{
			tree[1] = ["#smea02#See, we both have our little niche!"];
		}
		else if (count % 3 == 1)
		{
			tree[1] = ["#smea06#Unless... Wow, I wonder if you're more talented at being cute and naked too!?"];
			tree[2] = ["#smea10#No, no! Don't tell me. Just let me have this."];
		}
		else
		{
			tree[1] = ["#kecl02#Hey I'm super talented at being cute and naked too! Here, check this out..."];
			tree[2] = ["#smea10#...What are you doing!? Put that thing away!"];
		}
	}

	public static function sexyBefore4(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		if (PlayerData.justFinishedMinigame)
		{
			tree[0] = ["#smea04#So now that we finished that minigame... I'm all yours, right?"];
		}
		else
		{
			tree[0] = ["#smea04#So now that we got through all those puzzles... I'm all yours, right?"];
		}
		tree[1] = ["#smea02#At least, like, yours to borrow for a few minutes! Just think of it as some kind of a little... dog library. Harf!"];
	}

	public static function badRubBelly(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		tree[0] = ["#kecl06#Ay Smeargle! You doing okay? You're looking a little... shmoompy. Is something on your-- Ohhhh nevermind, I get it."];
		tree[1] = ["#smea12#Hmph! I'm not looking shmoompy! ...What are you getting? There's nothing to get."];
		tree[2] = ["#kecl04#You're all shmoompy on account of <name> here didn't rub your belly last time. And you're anxious about maybe missing out on your belly rubs again."];
		tree[3] = ["#smea10#N... No, that's not it! He doesn't have to rub my belly EVERY time..."];
		tree[4] = ["#smea08#..."];
		tree[5] = ["#smea04#Don't listen to him, <name>, you don't have to rub my belly if you don't want to. Kecleon's just being weird!"];

		if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			DialogTree.replace(tree, 3, "He doesn't", "She doesn't");
		}
		else if (PlayerData.gender == PlayerData.Gender.Complicated)
		{
			DialogTree.replace(tree, 3, "He doesn't", "They don't");
		}

		if (!PlayerData.keclMale)
		{
			DialogTree.replace(tree, 5, "to him", "to her");
		}
	}

	public static function badRubHat(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		tree[0] = ["#kecl06#Ay Smeargle! You doing okay? You're looking a little... deshmoofed. Did you maybe forget to-- Ohhhh nevermind, I get it."];
		tree[1] = ["#smea12#Hmph! What are you talking about! I'm perfectly... shmoofed."];
		tree[2] = ["#kecl05#It's just when you go too long without getting your head scritched, you lose some of your shmoofiness. When's the last time your head was scritched?"];
		tree[3] = ["#smea10#Tsk! ...It's not like... It's not like I keep a head scritch calendar. I don't remember when my head was scritched last!"];
		tree[4] = ["#smea08#..."];
		tree[5] = ["#smea04#Don't listen to him, <name>, my head's perfectly scritched. We can do whatever you want to do! Kecleon's just being weird."];

		if (!PlayerData.keclMale)
		{
			DialogTree.replace(tree, 5, "to him", "to her");
		}
	}

	public static function badShouldntRubDick(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		if (PlayerData.justFinishedMinigame)
		{
			tree[0] = ["#smea05#Alright! Well that little minigame's over. I guess that means you've totally earned your private puppy time, right?"];
		}
		else
		{
			tree[0] = ["#smea05#Alright! Three puzzles down. I guess that means you've totally earned your private puppy time, right?"];
		}
		tree[1] = ["#smea02#Let's do it! Bark! Let's put on a good show for Kecleon this time. Let's make him like, TOTALLY jealous. Ha! Ha!"];
		tree[2] = ["#kecl02#Keck-keke! What's there to be jealous of? What with you freezin' up like a scarecrow every time <name> over there touches your dick. Loosen up a little!"];
		tree[3] = ["#smea10#...Well, hey! ...It's... It's just a little weird sometimes, I guess it catches me off guard! I mean everything's so quiet and there's just this floating hand..."];
		tree[4] = ["#smea06#Sort of like, when you see your doctor... and he's not telling you what he's about to do? And you're all on guard like, what's he's holding? Where is that going? Will it hurt?"];
		tree[5] = ["#smea04#..."];
		tree[6] = ["#smea03#I don't know! You can touch my dick, <name>! It's fine. It doesn't bother me. I'll try to loosen up. ...Sorry! Harf!"];

		if (!PlayerData.keclMale)
		{
			DialogTree.replace(tree, 1, "make him", "make her");
		}
		if (!PlayerData.smeaMale)
		{
			DialogTree.replace(tree, 2, "your dick", "your pussy");
			DialogTree.replace(tree, 6, "my dick", "my pussy");
		}
	}

	public static function badShouldntRubTongue(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		if (PlayerData.justFinishedMinigame)
		{
			tree[0] = ["#smea04#So now that we got through that minigame... I'm all yours, right?"];
		}
		else
		{
			tree[0] = ["#smea04#So now that we got through all those puzzles... I'm all yours, right?"];
		}
		tree[1] = ["#smea02#At least, like, yours to borrow for a few minutes! Just think of it as some kind of a little... dog library. Harf!"];
		tree[2] = ["#smea06#Although, what's with you and like... tongues? Is it like... some kind of weird tongue fetish? Or are you just um, hmm..."];
		tree[3] = ["#smea04#..."];
		tree[4] = ["#smea10#You know what, nevermind. I'm not even going to ask."];
	}

	public static function badDislikedHandsDown(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		tree[0] = ["#kecl06#Ay Smeargle! You doing okay? You're looking a little... flompy. Are you worried about-- Ohhhh nevermind, I get it."];
		tree[1] = ["#kecl05#You're worried <name>'s gonna dive into your more sensitive bits without warming you up first."];
		tree[2] = ["#smea12#Hmph! ...<name> can do what he wants, I'm not... I'm not worried! ...I'm just worried about you being a big mood killer."];
		tree[3] = ["#kecl03#See, I can tell Smeargle's worried 'cause he's got both his hands there playing goalkeeper for his crotch! Keck-kekekek."];
		tree[4] = ["#kecl04#Like, he loves when I rub his feet but sometimes I gotta warm him up first with some scritches and floppy ear rubs. Just thought you could use the heads up, <name>."];
		tree[5] = ["#smea13#Tsk! That's..."];
		tree[6] = ["#smea04#Don't listen to him, <name>. You rub what you want to rub. ...I love when people rub my feet~"];

		if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			DialogTree.replace(tree, 2, "he wants", "she wants");
		}
		else if (PlayerData.gender == PlayerData.Gender.Complicated)
		{
			DialogTree.replace(tree, 2, "he wants", "they want");
		}
		if (!PlayerData.smeaMale)
		{
			DialogTree.replace(tree, 3, "he's got", "she's got");
			DialogTree.replace(tree, 3, "his hands", "her hands");
			DialogTree.replace(tree, 3, "his crotch", "her crotch");
			DialogTree.replace(tree, 4, "he loves", "she loves");
			DialogTree.replace(tree, 4, "his feet", "her feet");
			DialogTree.replace(tree, 4, "him up", "her up");
		}
		if (!PlayerData.keclMale)
		{
			DialogTree.replace(tree, 6, "to him", "to her");
		}
	}

	public static function badDislikedHandsUp(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		tree[0] = ["#kecl06#Ay Smeargle! You doing okay? You're looking a little... blurgish. Are you anxious about-- Ohhhh nevermind, I get it."];
		tree[1] = ["#kecl04#You're eager to get your feet rubbed and you're hoping <name> doesn't waste any time getting there."];
		tree[2] = ["#smea12#Hmph! ...<name> can rub what he wants, I'm just... I'm just eager in general! ....And I like more things than just my footpaws, you know!"];
		tree[3] = ["#kecl03#See, I can tell Smeargle's eager 'cause he's got his one hand hovering awkwardly, like he's trying to keep it out of your way! Keck-kekekek."];
		tree[4] = ["#kecl05#Like, he loves when I warm him up by scritching his ears and stuff... But sometimes,"];
		tree[5] = ["#kecl00#Sometimes when he's all excited like this I just gotta give him the good stuff right away. Just thought you could use the heads up, <name>."];
		tree[6] = ["#smea13#Tsk! You're so..."];
		tree[7] = ["#smea04#Don't listen to him, <name>. You rub what you want to rub. ...You don't have to go straight for my feet~"];

		if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			DialogTree.replace(tree, 2, "he wants", "she wants");
		}
		else if (PlayerData.gender == PlayerData.Gender.Complicated)
		{
			DialogTree.replace(tree, 2, "he wants", "they want");
		}
		if (!PlayerData.smeaMale)
		{
			DialogTree.replace(tree, 3, "he's got", "she's got");
			DialogTree.replace(tree, 3, "his one", "her one");
			DialogTree.replace(tree, 3, "he's trying", "she's trying");
			DialogTree.replace(tree, 4, "he loves", "she loves");
			DialogTree.replace(tree, 4, "him up", "her up");
			DialogTree.replace(tree, 4, "his ears", "her ears");
			DialogTree.replace(tree, 5, "he's all", "she's all");
			DialogTree.replace(tree, 5, "him the", "her the");
		}
		if (!PlayerData.keclMale)
		{
			DialogTree.replace(tree, 7, "to him", "to her");
		}
	}

	public static function sexyAfter0(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		if (sexyState.dirtyDirtyOrgasm && sexyState.canEjaculate)
		{
			tree[0] = ["#smea00#Harf... Wow... That's SO rare that someone actually makes me orgasm like that..."];
			tree[1] = ["#smea01#Let's do this again soon, okay?"];
		}
		else if (sexyState.dirtyDirtyOrgasm)
		{
			tree[0] = ["#smea00#Harf... Wow... Everything still feels all tingly~"];
			tree[1] = ["#smea01#Let's do this again soon, okay? Harf~"];
		}
		else
		{
			tree[0] = ["#smea00#Nnngg... My head still feels all tingly~"];
			tree[1] = ["#smea01#Let's do this again soon, okay?"];
		}
	}

	public static function sexyAfter1(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		var count:Int = PlayerData.recentChatCount("smea.sexyBeforeBad.3") + PlayerData.recentChatCount("smea.sexyBeforeChats.4");
		if (count % 3 == 0)
		{
			tree[0] = ["#smea05#Mmm... I guess that's it for our fun little break. Onto the next puzzle!"];
			tree[1] = ["#kecl05#Well hey now, <name>'s not yours to keep all to yourself. You have to share him with the other Pokemon! Let one of them have a turn, too."];
			tree[2] = ["#smea09#Aww, phooey! Sharing's super hard, Kecleon. I don't know how you put up with this."];
			tree[3] = ["#kecl06#Well it's a little different sharing you I guess. I mean I got you alllll to myself the other twenty-three hours and fifty-five minutes of the day..."];
			tree[4] = ["#kecl02#So, it doesn't really hurt so bad to let my little flimpsy-doodle run off by himself for a few minutes."];
			tree[5] = ["%fun-alpha0%"];
			tree[6] = ["#smea14#...Flimpsy-doodle!?!"];
			tree[7] = ["#kecl00#Keck-kekekeke! C'mere you~"];
			tree[10000] = ["%fun-alpha0%"];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 1, "him with", "her with");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 1, "him with", "them with");
			}
			if (!PlayerData.smeaMale)
			{
				DialogTree.replace(tree, 4, "himself for", "herself for");
			}
		}
		else
		{
			tree[0] = ["#smea02#Mmm... I guess that's it for our fun little break. Onto the next puzzle!"];
			tree[1] = ["#kecl05#Well hey now, <name>'s not yours to keep all to yourself. You have to share him with the other Pokemon! Let one of them have a turn, too."];
			tree[2] = ["#smea04#Aww, phooey! Well, I want you back when they're done with you, <name>. They can only have you to borrow for a few minutes!"];
			tree[3] = ["#smea02#You know... sort of like a little hand library! ...Harf!"];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 1, "him with", "her with");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 1, "him with", "them with");
			}
		}
	}

	public static function sexyAfter2(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		if (sexyState.dirtyDirtyOrgasm)
		{
			tree[0] = ["#smea00#Phwoof... Harf! You're, you're really good with your hands. I don't usually enjoy that kind of stuff, but you sort of made it work~"];
			tree[1] = ["#kecl02#Yeah you two were great! Y'know come to think of it, I should go see if I can bug Heracross about nabbing that recording."];
			tree[2] = ["#smea10#But... But Heracross doesn't keep any recordings of me! Don't you remember?"];
			tree[3] = ["#kecl00#...Oh uhh, that's right. Keck-kekekeke. Anyway, I'm gonna go uhh, go bug Heracross about something completely different."];
			tree[4] = ["#kecl05#Don't follow me."];
			tree[5] = ["#smea04#...Well okay, but don't leave me here for too long!"];
			tree[6] = ["#smea03#That goes double for you, <name>. Harf!"];
		}
		else
		{
			tree[0] = ["#smea00#Phwoof... Harf! You really have a knack for petting... That was just like, the exact way I like to be pet~"];
			tree[1] = ["#kecl02#Yeah you two were great! Y'know come to think of it, I should go see if I can bug Heracross about nabbing that recording."];
			tree[2] = ["#smea10#But... But Heracross doesn't keep any recordings of me! Don't you remember?"];
			tree[3] = ["#kecl00#...Oh uhh, that's right. Keck-kekekeke. Anyway, I'm gonna go uhh, go bug Heracross about something completely different."];
			tree[4] = ["#kecl05#Don't follow me."];
			tree[5] = ["#smea04#...Well okay, but don't leave me here for too long!"];
			tree[6] = ["#smea03#That goes double for you, <name>. Harf!"];
		}
	}

	public static function sexyAfterGood1(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		if (sexyState.dirtyDirtyOrgasm && sexyState.canEjaculate)
		{
			tree[0] = ["#kecl01#Holy... Smokes... That was SO hot, you two. Smeargle! When's the last time you shot a load like that!?! That was like... a porn star quality cumshot right there."];
			tree[1] = ["#smea15#...Hah ...Hahh ...Phwooph ...Ahhhh ...So... So messy..."];
			tree[2] = ["#kecl00#Yeah I know whatcha mean, I made a bit of a mess over here myself. I'm gonna go grab a few paper towels."];
			tree[3] = ["#smea15#...Mmmmngh... Ngghhh... Hahh... Need to... Need to just rest... Rest for..."];
			tree[4] = ["#kecl06#On second thought, maybe a mop..."];
			tree[5] = ["#smea01#...Don't ...Mmmffff.... We can just... Haff... Harrffff..."];
			tree[6] = ["#kecl12#You know what, screw it I'll just flip this cushion over to the other side. What am I, the fuckin' housekeeper?"];
			tree[7] = ["#smea00#...Mnffh ...Hahh..."];
			tree[8] = ["#kecl11#Oh god, the other side's worse! THE OTHER SIDE'S WORSE!!"];
			if (!PlayerData.smeaMale)
			{
				DialogTree.replace(tree, 0, "shot a load", "squirted");
				DialogTree.replace(tree, 0, "That was like... a porn star quality cumshot", "Those were like... some porn star quality cumshots");
			}
		}
		else if (sexyState.dirtyDirtyOrgasm)
		{
			tree[0] = ["#kecl01#Holy... Smokes... That was SO hot, you two. Smeargle! Wow! You got really into it that time, I really thought you might actually cum..."];
			tree[1] = ["#smea15#...Hah ...Hahh ...Phwooph ...Ahhhh ...So... So good..."];
			tree[2] = ["#kecl00#Yeah I mean I gotta confess I made a bit of a mess over here. I'm gonna go grab a few paper towels."];
			tree[3] = ["#smea15#...Mmmmngh... Ngghhh... Hahh... Need to... Need to just rest... Rest for..."];
			tree[4] = ["#kecl06#On second thought, maybe a mop..."];
			tree[5] = ["#smea01#...Don't ...Mmmffff.... We can just... Haff... Harrffff..."];
			tree[6] = ["#kecl12#You know what, screw it I'll just flip this cushion over to the other side. What am I, the fuckin' housekeeper?"];
			tree[7] = ["#smea00#...Mnffh ...Hahh..."];
			tree[8] = ["#kecl11#Oh god, the other side's worse! THE OTHER SIDE'S WORSE!!"];
		}
		else
		{
			tree[0] = ["#kecl08#Ay! Smeargle!"];
			tree[1] = ["#smea15#...Gllg..."];
			tree[2] = ["#kecl08#Smeargle are you feeling okay? Your eyes look all... swibbly..."];
			tree[3] = ["#smea00#...Nghh... Haafff... Glrrgl..."];
			tree[4] = ["#kecl12#Hmph well, I hope you're happy with yourself, <name>. You scrambled his brain all up what with your overly affectionate petting."];
			tree[5] = ["%fun-alpha0%"];
			tree[6] = ["#kecl08#C'mon smeargle, let's go get you a glass of water or something."];
			tree[7] = ["#smea00#...Glrrb ...Glrrrbbll..."];
			tree[10000] = ["%fun-alpha0%"];

			if (!PlayerData.smeaMale)
			{
				DialogTree.replace(tree, 4, "his brain", "her brain");
			}
		}
	}

	public static function sexyAfterGood0(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		if (sexyState.dirtyDirtyOrgasm && sexyState.canEjaculate)
		{
			tree[0] = ["#kecl07#I'm... I'm not really sure what I just witnessed over here..."];
			tree[1] = ["#kecl06#I mean, did that... You... You fuckin' shot a load bigger than anything I've ever seen before."];
			tree[2] = ["#smea15#Gwaaaaahhh... Yeah usually, my body just kinda... Hahh... I don't know, something was just... Haarrrfff~"];
			tree[3] = ["#kecl01#I mean is it... Do you wanna go another round? Do you think it's..."];
			tree[4] = ["#smea00#Oooghh..."];
			tree[5] = ["#smea01#My dick's... soooo so sensitive right now. Hahh... Just, gwoof.... Maybe another time... Harf~"];
			tree[6] = ["#kecl00#Aww, alright. But you and me, we got some experimenting to do. Keck-kekekekeke~"];

			if (!PlayerData.smeaMale)
			{
				DialogTree.replace(tree, 1, "shot a load bigger", "squirted more than");
				DialogTree.replace(tree, 5, "My dick", "My pussy");
			}
		}
		else if (sexyState.dirtyDirtyOrgasm)
		{
			tree[0] = ["#kecl10#I'm... I'm not really sure what I just witnessed over here..."];
			tree[1] = ["#kecl06#I mean, did that... Did you orgasm? Did that feel good or not? It looked kinda weird..."];
			tree[2] = ["#smea15#Gwaaaaahhh... Yeah kinda like... Hahh... Maybe not a full orgasm but, something super intense... Haarrrfff~"];
			tree[3] = ["#kecl06#Do you want me to see if I can like, finish you off or-"];
			tree[4] = ["#smea13#No! My dick is..."];
			tree[5] = ["#smea00#My dick's... soooo so sensitive right now. Hahh... Just, gwoof.... Give me a few minutes... Harf~"];
			tree[6] = ["#kecl10#O- Okay?"];

			if (!PlayerData.smeaMale)
			{
				DialogTree.replace(tree, 4, "dick is", "pussy is");
				DialogTree.replace(tree, 5, "My dick", "My pussy");
			}
		}
		else
		{
			tree[0] = ["#kecl10#I'm... I'm not really sure what I just witnessed over here..."];
			tree[1] = ["#kecl06#What was that, did you just like-- orgasm from head scritches or something?"];
			tree[2] = ["#smea15#Gwaaaaahhh... I don't think... Hahh... Maybe not an orgasm, I don't... It just felt... Reeeeeeeally good... Haarrrfff~"];
			tree[3] = ["#kecl06#Can... Can I try? Maybe if i-"];
			tree[4] = ["#smea13#No! My head is..."];
			tree[5] = ["#smea00#My head's... soooo so sensitive right now. Hahh... Just, gwoof.... Give me a few minutes... Harf~"];
			tree[6] = ["#kecl10#O- Okay?"];
		}
	}

	public static function snarkyBeads(tree:Array<Array<Object>>)
	{
		if (PlayerData.recentChatCount("smeaSnarkyBeads") == 0)
		{
			tree[0] = ["#smea05#Oooh are those Bocce balls? I'm so good at Bocce! Are you playing too, Kecleon?"];
			tree[1] = ["%enterkecl%"];
			tree[2] = ["#kecl06#Ayy uhhh Smeargle, those ain't Bocce balls. Those look more like ehh... yeesh."];
			tree[3] = ["#kecl08#Y'know on second thought, you probably don't wanna know what those are."];
			tree[4] = ["#smea02#I know what they are! ...They're your one-way ticket to loser central! C'mon, I'll let you throw the first ball!"];
			tree[5] = ["#kecl07#Trust me Smeargle, you don't want none of this. You're still on the bunny slopes and this is like, some double black diamond stuff right here."];
			tree[6] = ["#smea03#Oh so what, they're some sort of weird sex thing?? Just tell me! I've been around. I can handle it!"];
			tree[7] = ["#kecl05#(whisper, whisper)"];
			tree[8] = ["#smea07#What!? They're for WHAT!? Ew! EWWW! And... OWW! ..What? What the heck!?! There's... There's no way! That's... they're TOTALLY too big for that!"];
			tree[9] = ["#smea13#Wait a minute... You're just making that up so you don't lose at Bocce! Hmph! Let's go <name>, you two can be on a team."];
			tree[10] = ["#kecl06#... ...Tell ya what, you REALLY wanna know what these are, how 'bout later you and me can... We'll go online, I'll show you some pictures,"];
			tree[11] = ["#kecl04#Maybe order somethin' small off the internet and you and me can mess around, you know. Get some practice in first. Build up to the big stuff. That sound good?"];
			tree[12] = ["#smea08#Wait, what? Hmm... Maybe?"];
			tree[13] = ["%exitkecl%"];
			tree[14] = ["#smea10#<name>, what did you get me into!?"];
		}
		else
		{
			tree[0] = ["#smea12#Eww! I'm not playing Bocce with Kecleon! ...His version of Bocce is super gross and weird."];
			tree[1] = ["%enterkecl%"];
			tree[2] = ["#kecl00#Keck! Kekekeke. Ayy I was the one tryin' to talk you out of it, but you kept insisting..."];
			tree[3] = ["#smea04#Tsk well, whatever! I'm STILL going to get better than you eventually. I just need some time to practice by myself..."];
			tree[4] = ["%exitkecl%"];
			tree[5] = ["#kecl06#By yourself? Aww c'mon that's no fun~"];

			if (!PlayerData.keclMale)
			{
				DialogTree.replace(tree, 0, "...His version", "...Her version");
			}
		}
		PlayerData.quickAppendChatHistory("smeaSnarkyBeads");
	}

	public static function denDialog(sexyState:SmeargleSexyState = null, victory:Bool = false):DenDialog
	{
		var denDialog:DenDialog = new DenDialog();

		denDialog.setGameGreeting([
			"#smea05#Oh, <name>! What are you doing back here? Kecleon and I were practicing <minigame> but, well... I think " + (PlayerData.keclMale ? "he" : "she") + " could use a little break.",
			"#kecl13#Damn right I could use a break! I'm here playin' against the freakin'... Garry Kasparov of stupid minigames. Why you gotta take these things so serious!",
			"#smea03#Ha! Ha ha ha. I love you too, honey~",
		]);

		denDialog.setSexGreeting([
			"#smea04#You didn't come back here just to give me puppy cuddles did you?",
			"#smea02#...Because if you did, that's totally okay! I'm like, super in the mood for puppy cuddles right now~",
		]);

		denDialog.addRepeatSexGreeting([
			"#smea02#More... more fun puppy rubs with <name>? Really? Aaaaa! I'm so lucky~",
			"#smea00#Make sure to get my tummy this time!"
		]);
		denDialog.addRepeatSexGreeting([
			"#smea05#I hope Kecleon's not feeling left out! Kecleon, are you doing okay?",
			"#kecl00#Ya kiddin' me? Don't slow down on my account! ...I want you to push this puppy to " + (PlayerData.smeaMale ? "his" : "her") + " limits~",
		]);
		denDialog.addRepeatSexGreeting([
			"#smea01#Ah... Everything still feels all tingly from last time~",
		]);
		denDialog.addRepeatSexGreeting([
			"#smea04#Okay, I'm back! ...Are you really going to do this again? You're not tired?",
		]);

		denDialog.setTooManyGames([
			"#kecl12#Ahhh, I think I see how you're doin' it! Lemme have a turn against Smeargle. I think I can actually beat 'em this time.",
			"#smea04#Oh sure! Is that okay <name>? You and I played a lot! I think we should let Kecleon have a turn.",
			"#kecl03#Sorry to steal my " + (PlayerData.smeaMale ? "boyfriend" : "girlfriend") + " away from ya! ...You can have my sloppy seconds later. Keck-kekekek~",
		]);

		denDialog.setTooMuchSex([
			"#kecl05#Sheesh, I'm starvin' over here! I'ma go grab a bite to eat. You two kids have fun without me~",
			"#smea04#Oh okay, wait! I'll join you. ...Is that okay <name>? We've been at this awhile!",
			"#smea05#...I'll be back after we finish eating! It might be a little while though. Why don't you go see what the other Pokemon are up to!",
			"#smea00#Thanks for all the attention today~",
		]);

		denDialog.addReplayMinigame([
			"#smea03#I really enjoy this game! Win or lose, I always feel like I learn a little bit every time I play. Harf!",
			"#smea06#...Did you want to go one more round? Or, we could always do something else..."
		],[
			"One more\nround!",
			"#smea02#Yessssss! I was hoping you'd say that~"
		],[
			"Something...\nlike what?",
			"#kecl03#Ayyy I got some ideas for what you could do next. Keck-kekekekeke~",
			"#smea04#Ohh, be quiet Kecleon! We're not going to do THAT...",
			"#smea06#Well I mean, I guess we CAN do that, if you want...",
		],[
			"Actually\nI think I\nshould go",
			"#smea05#Oh that's fine! Thanks for playing with me <name>! We'll have to do it again soon~",
			"#kecl12#Wait, what? You mean you two aren't even gonna DO anything? G'ahhh, what was I waitin' here for!",
		]);
		denDialog.addReplayMinigame([
			"#smea03#Oof! You're a fierce little competitor, <name>. Did you want to play again?",
			"#smea05#We don't have to play again, you know! There's always other stuff we could do back here."
		],[
			"Let's play\nagain",
			"#smea02#Yay!"
		],[
			"I want to do\nsomething else",
			"#smea06#Something else, hmm? Hmm! Hmm..."
		],[
			"I think I'll\ncall it a day",
			"#smea04#Yeah okay! ...Well it was nice hanging out. See you later!",
			"#kecl04#Later, <name>!"
		]);
		denDialog.addReplayMinigame([
			"#smea03#See, Kecleon? That's what the game is SUPPOSED to look like!",
			"#kecl06#Ehhh, whatever! Like, that's ONE way to play it.",
			"#smea04#You want to go one more time? I think Kecleon can learn a lot more from watching us than from trying to play..."
		],[
			"Yeah! One\nmore time",
			"#smea02#Pay attention this time, Kecleon!",
			"#kecl05#Yeaaaahhhhh alright, I'm watchin', I'm watchin'...",
		],[
			"Actually, maybe\nwe can try\nsomething\ndifferent?",
			"#smea04#\"Something different\" hmm? ...How suspiciously vague!",
			"#smea02#Okay okay, whatever! I'll TRY to act surprised.",
		],[
			"Hmm, I\nshould go",
			"#smea05#Oops! Did I run out of <name> minutes?? ...Ha! Ha!",
			"#smea02#Let's play again soon, okay?",
		]);

		if (sexyState != null && (sexyState.dirtyDirtyOrgasm))
		{
			denDialog.addReplaySex([
				"#smea00#Harf... Wow... Everything still feels all tingly~",
				"#smea04#I'm going to go get some orange juice! I'll be right back, okay? ...Did you want to keep going?"
			],[
				"Sure, I'm\nup for it!",
				"#smea02#Yay! I'll be back in like ONE minute! Just sit tight okay?"
			],[
				"Ahh, I'm good\nfor now",
				"#kecl05#Aww well thanks for the show! You did good tonight~",
				"#smea05#Ha! Ha! Yeah, this was nice. See you around, <name>~",
			]);
			denDialog.addReplaySex([
				"#kecl01#Nnngh, that was a good one. Lookit " + (PlayerData.smeaMale?"'em":"'er") + " though, I think " + (PlayerData.smeaMale?"he's":"she's") + " still got some puppy energy left in " + (PlayerData.smeaMale?"'em":"'er") + "! Whaddaya say Smeargle, you up for another round?",
				"#smea00#Hahh... Phew... I just need to use the restroom really quick, but I can go again! ...What do you think, <name>, you're not tired are you?"
			],[
				"Yeah! I'm\nnot tired~",
				"#smea05#Okay! I'll be right back...",
			],[
				"Oh, I think\nI'll head out",
				"#kecl12#What! Ahhhh c'mon. Ya quitters! Just when it was gettin' good...",
				"#smea02#Ha! Ha! Don't worry about it. We'll wrap this up another time, won't we <name>?",
			]);
			denDialog.addReplaySex([
				"#smea00#Phwoof... Harf! You're, you're really good with your hands. ...I'm going to go grab a little snack...",
				"#kecl06#Hey waitaminnit, where you think you're goin'!",
				"#kecl05#Ahh whatever. You're stickin' around though, right <name>?",
			],[
				"Yeah!\nI'll stay",
				"#kecl03#That's what I wanted to hear! Hopefully Smeargle's just makin' somethin' quick."
			],[
				"I should\ngo...",
				"#kecl04#Keck! Keck. Yeah alright, well thanks for payin' us a visit back here. See ya around."
			]);
		}
		else {
			denDialog.addReplaySex([
				"#smea00#Harf... Wow... My head still feels all tingly~",
				"#smea04#I'm going to go get some orange juice! I'll be right back, okay? ...Did you want to keep going?"
			],[
				"Sure, I'm\nup for it!",
				"#smea02#Yay! I'll be back in like ONE minute! Just sit tight okay?"
			],[
				"Ahh, I'm good\nfor now",
				"#kecl05#Aww well thanks for the show! You did good tonight~",
				"#smea05#Ha! Ha! Yeah, this was nice. See you around, <name>~",
			]);
			denDialog.addReplaySex([
				"#kecl00#Aww, lookit " + (PlayerData.smeaMale?"'em":"'er") + "! I think " + (PlayerData.smeaMale?"he's":"she's") + " still got some puppy energy left in " + (PlayerData.smeaMale?"'em":"'er") + ". Whaddaya say Smeargle, you up for another round?",
				"#smea00#Hahh... I just need to use the restroom really quick, but I can go again! ...What do you think, <name>, you're not tired are you?"
			],[
				"Yeah! I'm\nnot tired~",
				"#smea05#Okay! I'll be right back...",
			],[
				"Oh, I think\nI'll head out",
				"#kecl12#What! Ahhhh c'mon. Ya quitters! Just when it was gettin' good...",
				"#smea02#Ha! Ha! Don't worry about it. We'll wrap this up another time, won't we <name>?",
			]);
			denDialog.addReplaySex([
				"#smea00#Phwoof... Harf! You really have a knack for petting. ...I'm going to go grab a little snack...",
				"#kecl06#Hey waitaminnit, where you think you're goin'!",
				"#kecl05#Ahh whatever. You're stickin' around though, right <name>?",
			],[
				"Yeah!\nI'll stay",
				"#kecl03#That's what I wanted to hear! Hopefully Smeargle's just makin' somethin' quick."
			],[
				"I should\ngo...",
				"#kecl04#Keck! Keck. Yeah alright, well thanks for payin' us a visit back here. See ya around."
			]);
		}

		return denDialog;
	}

	public static function cursorSmell(tree:Array<Array<Object>>, sexyState:SmeargleSexyState)
	{
		var count:Int = PlayerData.recentChatCount("smea.cursorSmell");

		if (count == 0)
		{
			tree[0] = ["#smea10#So now that we... (sniff) Oh! Oh no. WHAT!? (sniff, sniff)"];
			tree[1] = ["%fun-alpha0%"];
			tree[2] = ["#smea11#What is that... What is that SMELL!? -cough- Aaaagh, it smells like someone microwaved a zoo!!! -cough- -horrk-"];
			tree[3] = ["#smea07#Oh my GOD <name>, what did you DO!?! That is SO GROSS!!!"];
			tree[4] = ["#kecl10#Shmoopsy-pie? ...Where you goin'!"];
			tree[5] = ["#self05#(...)"];
			tree[6] = ["#self04#(...Hello? ... ...Kecleon? ... ... ...Anybody?)"];

			tree[10000] = ["%fun-alpha0%"];
		}
		else
		{
			tree[0] = ["#smea10#So now that we... (sniff) Oh! Oh no. WHAT!? (sniff, sniff) There's that SMELL again!"];
			tree[1] = ["%fun-alpha0%"];
			tree[2] = ["#smea11#Oh my god... -hurrk- It smells worse than that time Spinda got drunk and peed on the electric stove!!! -cough- -hurrk-"];
			tree[3] = ["#smea07#<name>, what... What did you do!?! -cough- Why do you keep DOING it!? EWWWW!!!"];
			tree[4] = ["#kecl08#Sugar pie? ...You gonna be okay?"];
			tree[5] = ["#kecl06#...Ehh, yeah, sorry 'bout that. Turns out Smeargle's got a weird thing about smells. I think maybe it's a dog thing?"];
			tree[6] = ["#kecl05#So ehhh. ... ...What's new, <name>? How 'bout this weather, eh?"];

			tree[10000] = ["%fun-alpha0%"];
		}
	}

	static public function snarkyHugeDildo(tree:Array<Array<Object>>)
	{
		tree[0] = ["#smea10#Oh, wow! Kecleon, isn't that umm... Isn't that the dildo we saw in the news?"];
		tree[1] = ["#kecl13#<name>, what the heck do you think you're doin'!? ...Put that thing away before you scare the kid."];
	}

	static public function unwantedElectricVibe(tree:Array<Array<Object>>)
	{
		var count:Int = PlayerData.recentChatCount("smea.unwantedElectricVibe");

		if (count == 0)
		{
			tree[0] = ["#smea11#Oww! ... ...That egg thingy zapped me!!"];
			tree[1] = ["#kecl06#Ehhh? What happened? ...Did <name> do somethin' wrong?"];
			tree[2] = ["#smea04#Well... I don't think the toy has some sort of \"puppy electrocution\" button. ...It's probably just broken or something."];
			tree[3] = ["#smea05#Let's just stick to regular puppy stuff today, okay? I don't really like those toys anyways~"];
		}
		else if (count % 3 == 0)
		{
			tree[0] = ["#smea11#Oww! ... ...That egg thingy zapped me again!!"];
			tree[1] = ["#kecl06#Ehhh? What happened? ...Did <name> do somethin' wrong?"];
			tree[2] = ["#smea04#Well... I don't think the toy has some sort of \"puppy electrocution\" button. ...It's probably still broken."];
			tree[3] = ["#smea05#Let's just stick to regular puppy stuff today, okay? I don't really like those toys anyways~"];
		}
		else if (count % 3 == 1)
		{
			tree[0] = ["#smea07#Yeowww!!!"];
			tree[1] = ["#smea13#Did you do that on purpose <name>!? ...That's like... really annoying!!"];
			tree[2] = ["#kecl05#Ahhh I'm sure his finger just slipped or somethin'. Isn't that right <name>?"];
			tree[3] = [20, 40, 10, 30];

			tree[10] = ["I'm still\ntrying to\nfigure this\nthing out"];
			tree[11] = ["#smea04#Well can't you test it out on someone else? I don't like being your laboratory rat!"];
			tree[12] = ["#kecl00#Wouldn't it be more like ehh... ... a laboratory retriever? Keck-kekekek~"];
			tree[13] = ["#smea12#..."];
			tree[14] = ["#kecl06#Yeesh! Tough audience."];

			tree[20] = ["Oops!\nSorry,\nSmeargle"];
			tree[21] = ["#smea04#Hmph! I'm not going to forgive you so easily."];
			tree[22] = ["#smea02#You owe me like... twenty puppy pets!"];

			tree[30] = ["I didn't\npress\nanything"];
			tree[31] = ["#smea05#Well... don't worry about it. Let's just put that thing away for now! It seems kind of dangerous."];

			tree[40] = ["I thought\nit might\nfeel good\nthis time"];
			tree[41] = ["#smea04#...Well it doesn't feel good. It feels bad. Stop doing that!"];
			tree[42] = ["#smea05#I thought you already figured out what feels good! I like things being rubbed, or stroked, or patted."];
			tree[43] = ["#smea03#Why are you trying to make it into something complicated? This is simple stuff! Harf!"];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 2, "his finger", "her finger");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 2, "his finger", "their finger");
			}
		}
		else if (count % 3 == 2)
		{
			tree[0] = ["#smea13#OW! Hey!!!"];
			tree[1] = ["#smea12#...Is that the stupid Elekid toy again? Ugh. I thought we were done with that thing..."];
			tree[2] = ["#smea04#Doesn't it at least have a mode where it like... doesn't zap me ever? Can't you just leave it on that mode next time?"];
		}
	}
}