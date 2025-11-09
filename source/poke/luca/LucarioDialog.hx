package poke.luca;

import MmStringTools.*;
import critter.Critter;
import flixel.FlxG;
import minigame.GameDialog;
import minigame.MinigameState;
import minigame.scale.ScaleGameState;
import minigame.stair.StairGameState;
import minigame.tug.TugGameState;
import puzzle.ClueDialog;
import puzzle.PuzzleState;
import openfl.utils.Object;
import puzzle.RankTracker;

/**
 * Lucario is canonically female. She delivers pizza for a living.
 * 
 * When she had a delivery to Abra's house, Abra offered to pay her to do a set
 * of puzzles for Monster Mind, and Lucario accepted.
 * 
 * When Lucario first showed up, Abra rushed through an explanation of how the
 * puzzles work, how Pokemon do not appear as their canonical genders, and how
 * Lucario needs to address people by a certain set of pronouns as denoted on a
 * nearby board. But, this all kind of went over Lucario's head, which is why
 * she sometimes uses the wrong genders or gets confused about who's supposed
 * to be a boy and who's supposed to be a girl.
 * 
 * Lucario has been in a few other flash games before Monster Mind.
 * 
 * Lucario went to college for two years, at which point she had to declare a
 * major. She dropped out because she didn't really know what she wanted to
 * study, or what kind of career she wanted. Her father is pressuring her to go
 * back to school and get a degree so that she can get a "real job" but she's
 * nervous about making the wrong choice. She's not particularly passionate
 * about anything, although she sort of likes working with animals. (Yes, there
 * are apparently animals in their universe.)
 * 
 * Lucario gets along well with her coworkers, and enjoys her job most days.
 * 
 * Lucario usually comes by the house when there is a pizza delivery. The
 * pizzas are usually ordered by Rhydon, and you can gift him some pizza
 * coupons to make her come by more often. ...As you grow closer to her, there
 * are occasionally times when she'll visit even though nobody ordered pizza.
 * 
 * As Lucario settled in, Abra also tried to explain some of the minigames.
 * But, it was too much to take in, so Lucario calls a lot of them by the wrong
 * names.
 * 
 * In general, Lucario is not very good at the minigames. She is methodical but
 * slow at the scale game, she likes to think things through and not take
 * shortcuts. For the stair climbing game, she tries to avoid the best move
 * because it would be too obvious -- even when it's optimal.
 * 
 * ---
 * 
 * When writing dialog, I think it's good to have an inner voice in your head
 * for each character so that they behave and speak consistently. Lucario's
 * inner voice was Jennifer Aniston's characters from Office Space and Friends.
 * 
 * Vocal tics:
 *  - Reeeeeeeeeally, helloooooooo (lots of sustained vowels for emphasis)
 *  - Kyehh! Kkkh! Kahh!
 *  - Kyehh? Kweh? Kyah?
 *  - Kyeheheheheh! Kyahahahahaha!
 */
class LucarioDialog
{
	public static var prefix:String = "luca";
	public static var sexyBeforeChats:Array<Dynamic> = [sexyBefore0, sexyBefore1, sexyBefore2, sexyBefore3];
	public static var sexyAfterChats:Array<Dynamic> = [sexyAfter0, sexyAfter1, sexyAfter2, sexyAfter3];
	public static var sexyBeforeBad:Array<Dynamic> = [];
	public static var sexyAfterGood:Array<Dynamic> = [sexyAfterGood0, sexyAfterGood1];
	public static var fixedChats:Array<Dynamic> = [firstTime, genderCorkboard, newJob];
	public static var randomChats:Array<Array<Dynamic>> = [
				[random00, random01, random02, random03],
				[random10, random11, random12],
				[random20, random21, random22]
			];

	public static function getUnlockedChats():Map<String, Bool>
	{
		var unlockedChats:Map<String, Bool> = new Map<String, Bool>();
		if (!PlayerData.hasMet("rhyd"))
		{
			// chat #1 requires rhydon, and all other chats are dependent on chat #1
			for (i in 1...fixedChats.length)
			{
				unlockedChats.set("luca.fixedChats." + i, false);
			}
			unlockedChats.set("luca.randomChats.0.1", false);
		}
		if (RankTracker.computeAggregateRank() < 5)
		{
			// rank chat only makes sense if you're rank 5 or higher
			unlockedChats.set("luca.randomChats.1.2", false);
		}
		return unlockedChats;
	}

	public static function clueBad(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var clueDialog:ClueDialog = new ClueDialog(tree, puzzleState);

		clueDialog.setGreetings(["#luca04#Ehhhh yeah, okay. I think I remember how this stuff works. ...It looks like that <first clue> has some kind of a problem...",
								 "#luca04#Ohhhh sure, I think I see it. The problem has something to do with the <first clue>, doesn't it?",
								 "#luca04#Sooooo isn't that <first clue> wrong? ...I don't understand this puzzle stuff as well as you, but it looks wrong to me...",
								]);

		if (clueDialog.actualCount > clueDialog.expectedCount)
		{
			clueDialog.pushExplanation("#luca10#So, right. If we assume your answer's correct... then that <first clue> has <a bugs in the correct position>, right?");
			clueDialog.fixExplanation("clue has zero", "clue doesn't have any");
			clueDialog.pushExplanation("#luca06#...But that doesn't make any sense, because it's only got <e hearts> next to it. ...But for your answer to be right, it would need to have <a>.");
			clueDialog.fixExplanation("it's only got zero", "it doesn't have any");
			clueDialog.pushExplanation("#luca05#Do you get what I'm saying? I think we need an answer that only has <e bugs in the correct position> when we compare it to the <first clue>.");
			clueDialog.fixExplanation("only has zero", "doesn't have any");
			clueDialog.pushExplanation("#luca04#Well, that's how I'd go about fixing it anyway. ...And I guess we can always use that button in the corner to ask for hints if we're really stuck.");
		}
		else
		{
			clueDialog.pushExplanation("#luca10#So, right. If we assume your answer's correct... then that <first clue> has <a bugs in the correct position>, right?");
			clueDialog.pushExplanation("#luca06#...But that doesn't make any sense, because it's got <e hearts> next to it. ...But for your answer to be right, it would only need to have <a>.");
			clueDialog.fixExplanation("would only need zero", "wouldn't need any at all");
			clueDialog.pushExplanation("#luca05#Do you get what I'm saying? I think we need an answer that has <e bugs in the correct position> when we compare it to the <first clue>.");
			clueDialog.pushExplanation("#luca04#Well, that's how I'd go about fixing it anyway. ...And I guess we can always use that button in the corner to ask for hints if we're really stuck.");
		}
	}

	static private function newHelpDialog(tree:Array<Array<Object>>, puzzleState:PuzzleState, minigame:Bool=false):HelpDialog
	{
		var helpDialog:HelpDialog = new HelpDialog(tree, puzzleState);
		helpDialog.greetings = [
			"#luca04#Hi <name>! ...Did you need me for something?",
			"#luca04#Heyyyyy <name>! ...Just stopping by the say hi?",
			"#luca04#Don't worry, I'm still here! ...Did you need anything?",
		];

		helpDialog.goodbyes = [
			"#luca10#Oh, okay! ...I guess I should probably be getting back to the store anyways. See you!",
			"#luca10#Ohhhhh didn't have time to finish today? Well... maybe next time!",
			"#luca02#Awwww well it was still good seeing you! ...We'll have to hang out again, okay?",
		];

		if (minigame)
		{
			helpDialog.neverminds = [
				"#luca02#What, am I too distracting? ...Would it help if I put a paper bag over my head? Kyeheheheh~",
				"#luca02#C'monnnnnn, you know we can't actually do anything until we finish this minigame...",
				"#luca10#Oh ummmmmm... Okay! Sorry, I thought you wanted my attention for something...",
				"#luca10#Oops! Ummm, sorry! I'm still getting the hang of how this thing works...",
			];
		}
		else {
			helpDialog.neverminds = [
				"#luca02#What, am I too distracting? ...Would it help if I put a paper bag over my head? Kyeheheheh~",
				"#luca02#C'monnnnnn, you know we can't actually do anything until you knock these puzzles out...",
				"#luca10#Oh ummmmmm... Okay! Sorry, I thought you wanted my attention for something...",
				"#luca10#Oops! Ummm, sorry! I'm still getting the hang of how this thing works...",
			];
		}

		helpDialog.hints = [
			"#luca07#What, you want MY help!? Oooooooh, now you're really screwed. Well, let me see if Abra's here...",
			"#luca07#Yeah there's something weird going on with this puzzle! Where's Abra... ... I think his bedroom's upstairs somewhere...",
			"#luca07#Kyahhhhhh, you're really going to make me drag Abra into this? Aww geez... Hold oooonnnnnn... ...",
		];

		if (!PlayerData.abraMale)
		{
			helpDialog.hints[1] = StringTools.replace(helpDialog.hints[0], "think his", "think her");
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

	public static function bonusCoin(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#luca02#Wowwwww a bonus coin!? You found a bonus coin!!!"];
		tree[1] = ["#luca07#...Waaaaaaait, what's a bonus coin do again?"];
	}

	public static function gameDialog(gameStateClass:Class<MinigameState>)
	{
		var manColor:String = Critter.CRITTER_COLORS[0].english;
		var comColor:String = Critter.CRITTER_COLORS[1].english;

		var g:GameDialog = new GameDialog(gameStateClass);

		g.addSkipMinigame(["#luca04#Yeah sure! Abra didn't really do great job explaining these minigames anyways. I'd probably just mess it all up...", "#luca00#But mmmmmm there's ooooone thing we can do that I'm pretty sure I won't mess up... ... Kyeheheheheh~"]);
		g.addSkipMinigame(["#luca06#Yeah, I think you'd have a better time doing these minigames with someone who sort of knows how to play... ...", "#luca00#Here, let's get this thing out of the way so we can have some fun~"]);

		g.addRemoteExplanationHandoff("#luca06#Ehhh yeah, nobody ever really told me anything about this game. Lemme see if <leader>'s around...");

		g.addLocalExplanationHandoff("#luca06#Soooooo, how does this game work, <leader>? I'm sure you've played this before...");

		g.addPostTutorialGameStart("#luca04#Hmmmmmmm okay! ...I think that's starting to make some sense to me. ...Should we start?");

		g.addIllSitOut("#luca07#Kyehhh you know this will sound weird? ...But I was actually practicing this one alone and, I think I might have gotten too good. Maybe you can play without me??");
		g.addIllSitOut("#luca07#Kyehhhhhh this is a LOT like this one game I saw on a Korean game show. I sort of already know all the strategies... Is it okay if I sit this one out??");

		g.addFineIllPlay("#luca03#Yeahhh okay! I should have known you wouldn't let me get off that easy. Kyahahahahaha~");
		g.addFineIllPlay("#luca02#Ooookay, okay, I'll try to go easy on you. Just don't say I didn't warn you!");

		var gameNames:Array<String> = [
										  "Nightmare solitaire",
										  "Escape the prison",
										  "Math battle",
									  ];
		
		/*
		 * Lucario is new here, she doesn't know the proper names for most of
		 * the games
		 */
		if (gameStateClass == ScaleGameState)
		{
			gameNames = [
							"Nightmare solitaire",
							"Pick a number",
							"All your friends are fat",
							"Anorexia encourager",
							"Who's the fattest",
						];
		}
		else if (gameStateClass == StairGameState)
		{
			gameNames = [
							"Escape the prison",
							"Rock, paper, scissors, double scissors",
							"Trample your friends",
							"Life alert bracelet commercial",
							"Staircase race",
						];
		}
		else if (gameStateClass == TugGameState)
		{
			gameNames = [
							"Math battle",
							"Dodgeball duel",
							"Let's all eat the rope",
							"Rope eating contest",
							"Segregation simulator",
						];
		}
		g.addGameAnnouncement("#luca07#Ohhh it's my favorite! I love playing, umm... " + FlxG.random.getObject(gameNames) + "!");
		g.addGameAnnouncement("#luca06#Suuuuure, this game! This one's called... ...Ummm... " + FlxG.random.getObject(gameNames) + "!");
		g.addGameAnnouncement("#luca07#Yeahhhhhhh I know this game! It's time to plaaaaaaay, umm... ... " + FlxG.random.getObject(gameNames) + "!");
		g.addGameAnnouncement("#luca06#Ohhhhh sure, this game! I think Abra called it something like... ... " + FlxG.random.getObject(gameNames) + "!");
		g.addGameAnnouncement("#luca07#Ohhhhh yeah, okay! I definitely had this minigame explained to me. It's called, umm... " + FlxG.random.getObject(gameNames) + "!");

		if (PlayerData.denGameCount == 0)
		{
			g.addGameStartQuery("#luca05#Is that all I needed to say? ...Can we play now?");
			g.addGameStartQuery("#luca05#Have you done this one before? Can we start?");
			g.addGameStartQuery("#luca10#Welllll... as long as you know it! Should we just go?");
		}
		else
		{
			g.addGameStartQuery("#luca05#Are you ready for a rematch?");
			g.addGameStartQuery("#luca04#Okay I think we already know the rules! Should we just start?");
			g.addGameStartQuery("#luca02#I've got your number this time, <name>! ...Are you ready?");
			g.addGameStartQuery("#luca03#Woo, round " + englishNumber(PlayerData.denGameCount + 1) + "!!! This is so exciting~ ...Should we just go?");
		}

		g.addRoundStart("#luca06#Okay! Next round, I guess. ... ...How many rounds are in this game?", ["Like three\nor so", "Until someone gets\nenough points", "I don't\nknow"]);
		g.addRoundStart("#luca05#Alright, soooooo unless I lost count, this is round... <round>? Are you ready?", ["I'm always\nready", "...", "Yeah!\nLet's play"]);
		g.addRoundStart("#luca04#Okay! Round <round>. I'm finally starting to get the hang of this!", ["You're really\ngood!", "Hmm, if you\nsay so", "Yeesh, let's\njust start"]);
		g.addRoundStart("#luca05#I guess that makes it roouuuuund... <round>?", ["Yep, whenever\nyou're ready", "Time to\nget serious", "Let's\nstart"]);

		g.addRoundWin("#luca02#Heheyyyyyyyy! Wow! ...This is a lot easier than you make it look~", ["Well I WAS going easy\non you, but now...", "Yeah, it's\nnot too bad", "Oof, wow,\nwell done"]);
		g.addRoundWin("#luca02#Oh wait! Did I win one? Alriiight! ...Winning's good, right?", ["Whoa, I didn't\nexpect that", "Ugh...", "Umm, no,\nwinning's bad"]);
		g.addRoundWin("#luca03#Yayyyyyy! ...Finally, one of these I might actually win~", ["Well, it's not over\n'til it's over", "Wow, how the hell\nis this happening", "That was seriously\nimpressive"]);
		g.addRoundWin("#luca03#Ooooohhhh! I really pulled that one out of my, ummm... out of my secret winning place! Kyeheheheheh~", ["Can I see your\nsecret winning place~", "That's gross,\nLucario", "How am I so\nbad at this"]);

		g.addRoundLose("#luca07#Awwwww really? I thought I had that one... <name>, how are you so darn good at this?", ["It was\nclose", "<leaderHe's> just on a\ndifferent level|I'm just on a\ndifferent level", "You'll figure it\nout some day"]);
		g.addRoundLose("#luca07#Whoaaaaa! Waaaaaait where did THAT come from? Does that really work!?!", ["Yeah, add\nit up", "You think\n<leaderhe> cheated?|It's not like I\nneed to cheat...", "...Uhh..."]);
		g.addRoundLose("#luca10#Wait, slow down! ...The calculator app on my phone just froze!", ["Eesh, you couldn't beat\n<leaderhim> with a calculator!?|You'll never beat me\nwith a calculator", "No wonder\nyou lost!", "Put that thing\naway and focus"]);
		g.addRoundLose("#luca08#Geeeeeeeez, this is going to take a looooooooot of practice...", ["Don't get\ndiscouraged", "Hey, as long as\nwe're having fun~", "Yeah, a whole\nlot of practice..."]);

		g.addWinning("#luca02#Oh wowwwwww! I might actually win this one hmmmmm? ...That's okay, you can win the next one~", ["Oof yeah, I'm\npretty far behind", "Oh, I'll just\nwin this one~", "I almost\nnever win..."]);
		g.addWinning("#luca03#Heyyyyyy, I can give you some pointers if you want. ... ...Here's pointer #1: Don't suck! Kyeheheheheheh~", ["Everyone's good\nat this but me...", "...HEY!", "Winning's\nchanged you"]);
		g.addWinning("#luca02#...This game's reeeeeeeeeeeally intuitive to me for some reason. I don't know what it is!", ["Is it because...\nyou're a butt?", "It's not intuitive\nfor me...", "Time to turn\nthings around"]);
		g.addWinning("#luca03#Ohhhhhh don't worry about it <name>, it's just a game! ... ...A game I'm mercilessly kicking your ass at! Kyahahahahaha~", ["Oh my god Lucario,\njust shut up", "I'll get you\nnext time", "It's not\nover yet"]);

		g.addLosing("#luca07#Kyahhhhh how the heck am I supposed to catch up from something like this? ... ...This seems kind of unfair...", ["Suck it,\nloser!", "Oh, you can\nstill catch up", "Heh, maybe\nnext time"]);
		if (gameStateClass == ScaleGameState || gameStateClass == TugGameState) g.addLosing("#luca06#Wait, why do I have so few points? ...I thought I got more points that round...", ["Don't worry, it's\nconfusing at first", "Umm,\nwhat?", "Well, I think the\nscoreboard's accurate"]);
		if (gameStateClass == StairGameState) g.addLosing("#luca06#Wait, why did your bug move so many steps? ...I thought I threw out the right number...", ["Don't worry, it's\nconfusing at first", "Umm,\nwhat?", "Maybe you can ask\nRhydon about it"]);
		g.addLosing("#luca12#Kkkkkkh, <leader>, you are so annoying... ... Can't you let me win for once?", ["You wouldn't\nreally enjoy that", "Aww, we'll have\na rematch", "Keep practicing,\nyou'll get there"]);
		g.addLosing("#luca02#Ehhhh, I don't really care about winning or not. I'm just having fun playing with you, <name>~", ["Aww,\nLucario~", "I like playing\nwith you too", "Still, it would\nbe nice to win...|Now I\nfeel bad"]);

		if (gameStateClass == ScaleGameState) g.addPlayerBeatMe(["#luca04#Ehhh, I'm almost kind of glad I lost. ... ...I mean it would be silly if I won a game that I'd barely even played before.", "#luca02#Next time though, we're going to have a real competition, okay! ...I'll see if Abra can write down some of those puzzles for me to practice~"]);
		if (gameStateClass != ScaleGameState) g.addPlayerBeatMe(["#luca04#Ehhh, I'm almost kind of glad I lost. ... ...I mean it would be silly if I won a game that I'd barely even played before.", "#luca02#Next time though, we're going to have a real competition, okay! ...Don't think that same strategy's going to work against me twice~"]);
		g.addPlayerBeatMe(["#luca02#Kyeheheheh okaaaaaaay, you win, you wiiiiiiin. Good job~", "#luca03#You've gotta admit I put up a good fight though! ...Well, okay, I put up A fight. ... ...Okay, not really. Kyeheheheh~"]);

		if (gameStateClass == ScaleGameState) g.addBeatPlayer(["#luca02#Heheyyyyyyyyy! I knew I could do it. That game's basically just... math, and being one step ahead of your opponent.", "#luca05#And if there's two things it's good at, it's math, and being one step ahead of <name>.", "#luca00#Whaaaat, you don't think I know what you want to do next? Kyahahahaha, you're so predictable~"]);
		if (gameStateClass != ScaleGameState) g.addBeatPlayer(["#luca02#Heheyyyyyyyyy! I knew I could do it. That game's basically just... math, and knowing what's going on in your opponent's head.", "#luca05#And if there's two things it's good at, it's math, and knowing what's in <name>'s head.", "#luca00#Why? What's... what's going on in your head right now? ... ...Ohhh <name>, you're so bad~"]);
		g.addBeatPlayer(["#luca02#Yayyyyyyyy, I won! ...Is that okay? I hope you're not mad at me for taking all your money~", "#luca03#...I guess my competitive spirit just got the best of me. ... ...And it doesn't help that this game is actually kind of fun~", "#luca02#Sooooooo, what are we doing next?"]);
		g.addBeatPlayer(["#luca02#Well heyyyyy that was actually kind of fun!", "#luca03#...Well, hopefully it was still fun for you to lose. Because it was reeeeeeeeeally fun for me to win! Kyeheheheheh~", "#luca02#Sorry, sorry, I know. ...We'll have a rematch soon. Maybe I'll let you get the next one~"]);

		g.addShortWeWereBeaten("#luca08#Oof, WOW! ...Maybe you should practice a few games against <leader>, because you're sure as heck not going to learn that kind of stuff playing against me.");
		g.addShortWeWereBeaten("#luca12#Well okay, <leader>, if that's how it's going to be! Just going to... come in here, and beat us at our fun little game? I see how it is.");

		g.addShortPlayerBeatMe("#luca04#Ohhhhhhhh well. Some day I'll have to finally sit down and learn all these silly little rules! Good game, <name>~");
		g.addShortPlayerBeatMe("#luca02#Kyehhhhh well. As long as you had a good time. It was fun playing with you, <name>~");

		g.addStairOddsEvens("#luca05#Sooooooooo, why don't we do odds and evens to see who goes first? You can be odds, okay?", ["Okay, sounds\nsimple", "Yep, I\nget it", "So I want it\nto be odd?"]);
		g.addStairOddsEvens("#luca05#So somebody needs to go first... Why don't we do odds and evens? Odd number you first, even number I go first. Sound good?", ["Alright", "Let's do\nthis!", "Odd number,\nI go first..."]);

		g.addStairPlayerStarts("#luca10#Awwww okay, I guess that means you're first! So I want to throw out... low numbers, right? I think I get it. Ready to go?", ["Piece\nof cake!", "Heh heh,\nnot too low...", "Sure,\nlet's go"]);
		g.addStairPlayerStarts("#luca10#Ohhhhhh shoot! So you get to start? Well... at least that'll make it easier to capture you! Kyeheheheheh.", ["You'll never\ncapture me~", "Wait, maybe I should\nhave gone second...", "That's what\nyou think!"]);

		g.addStairComputerStarts("#luca03#Kyahahahaha! I kneewwwwww you'd pick that. You're so predictable, <name>. ... ...Ready for my first turn?", ["Tsk, I'm not\npredictable!", "Sure, go\nfor it", "Did you cheat! There's\nno way you knew..."]);
		g.addStairComputerStarts("#luca03#Alriiiiight! So that means I get to go first? Let's go, this should be easy~", ["Okay,\nI'm ready", PlayerData.gender == PlayerData.Gender.Boy ? "Ohh, I can make\nit pretty hard..." : "We'll see how\neasy it is...", "Tsk, I should\nhave known"]);

		g.addStairCheat("#luca12#Uhhhhhh, I'm not quite sure how this game works but I'm pretty sure you can't do THAT. ...C'mon, we gotta go at the same time!!! You ready?", ["Oh okay,\nI'm sorry", "I'm\nready", "Wow, you're\nso picky"]);
		g.addStairCheat("#luca13#Okaaaaay there slowpoke. Well that one doesn't count! You gotta throw it on three this time. Ready??", ["Why does it\nmatter...", "Hey! That was\na good throw", "Oh okay,\non three"]);

		g.addStairReady("#luca05#Ready?", ["Yeah!\nReady", "Sure,\nlet's go", "Okay"]);
		g.addStairReady("#luca04#...Ready to throw?", ["Okay! I think I\nknow what to pick", "Hmm,\nsure...", "You're\ngoing down"]);
		g.addStairReady("#luca05#Alright, ready?", ["Yeah I'm\nready!", "Hmm let me think\nfor a second...", "Okay,\ngo"]);
		g.addStairReady("#luca04#Ready when you are!", ["Wait, this one's\ncomplicated", "I'm\nready", "Um,\nokay"]);
		g.addStairReady("#luca06#Hmmmm, are you ready?", ["Yeah,\nsure", "Let's\ngo!", "Let me\nthink..."]);

		g.addCloseGame("#luca02#Heyyyyy, c'mon I'm actually doing pretty good this time! See? I'm kind of up where you are!", ["Yeah, but your position\nis really bad...", "Yeah, I don't\nknow what to do!", "Ha! Ha! That's\nwhat you think"]);
		g.addCloseGame("#luca06#Kyehhhh, I feel like any little mistake is going to reeeeeeeally cost me right now...", ["Gotta be\ncareful...", "What am I\ngoing to do!", "Don't get\ntilted!"]);
		g.addCloseGame("#luca07#Hmmm, I can't decide if I should play it safe or do something reeeeeeeally risky...", ["Play it\nsafe!", "Take a\nrisk!", "I'm not going to\ntell you what to do..."]);
		g.addCloseGame("#luca06#So if you throw that, I can throw this... But if you DON'T throw that, hmmm... Kyehhh, this is really hard!", ["Oh, just pick\nrandomly", "You'll never guess\nwhat I'm doing", "Yeah, but that\nmakes it fun~"]);

		g.addStairCapturedHuman("#luca03#Kyahahahaha! I knew it! I KNEW it! ...I knew you wouldn't be able to resist throwing a <playerthrow>, <name>.", ["Hey, I thought\n<playerthrow> was clever", "Ugh, why would you\nput out <computerthrow>", "It's just\nrandom..."]);
		g.addStairCapturedHuman("#luca02#Kyeheheheheyyyyyyyyyy, don't feel bad. It's just one little mistake, you can still win~", ["Not unless you\nreally mess up", "Wow, I need to pay\nmore attention", "-sigh-"]);
		g.addStairCapturedHuman("#luca02#Ohhhh " + stretch(PlayerData.name) + "... You know you can't go throwing out <playerthrow> every turn, some day you'll get caught!", ["Ugh...", "It could\nhave worked!", "You just made\na lucky guess"]);

		g.addStairCapturedComputer("#luca11#Kyahhhh! My little " + comColor + " guy! ...What happened to him, is he okay?", ["I think he'll\nbe okay", "He'll never walk again.\nOh wait, there he goes.", "Ha ha,\nrelax"]);
		g.addStairCapturedComputer("#luca10#Wait what does that mean? ...Why isn't he on the stairs anymore? That's not faaaaaairrrrr...", ["You're letting\nyour team down", "Them's the\nbreaks, kid", "Aww, it's\nokay"]);
		g.addStairCapturedComputer("#luca09#Ohhhhh, I should have knowwwwwwwn... <computerthrow>... Kyehhhhhhh, I'm so dumb sometimes.", ["Heh, that's a\nbeginner mistake", "It's like something\nI would do...", "Relax, it's\njust a game"]);

		return g;
	}

	private static function fillInReplacementTree(tree:Array<Array<Object>>)
	{
		var prefix = getLucarioReplacementProfPrefix();
		var name:String = getLucarioReplacementName();

		tree[0] = ["%disable-skip%"];
		tree[1] = ["%swapwindow-" + prefix + "%"];
		tree[3] = ["#abra05#It's right over here, okay? ...And you can see what you look like on that screen there-- so try to keep yourself in frame."];
		tree[4] = ["%swapwindow-luca%"];
		tree[5] = ["%enter" + prefix + "%"];
		tree[6] = ["%enable-skip%"];
		tree[7] = [15];

		tree[61] = ["#abra06#Oh ehhhh, slight change of plans " + name + "-- Lucario's going to fill in for you here. ...Somehow I thought <name> would be okay with that."];
		tree[62] = ["#luca10#Wait no, I'm... I'm sorry! Were you in the middle of something? I can come back when you're finished!"];
		tree[63] = ["%exit" + prefix + "%"];
		tree[65] = ["#luca14#Kyahhh well, okay, as long as I'm not interrupting! Nice to meet you, <name>~"];
		tree[66] = ["#luca04#Um soooo, Abra explained all this puzzle stuff REALLY quickly, but I'm still sort of lost... maybe I'll understand it better once you show me?"];
		tree[67] = ["#luca03#Okay, let's go!"];
	}

	public static function sexyBefore0(tree:Array<Array<Object>>, sexyState:LucarioSexyState)
	{
		var count:Int = PlayerData.recentChatCount("luca.sexyBeforeChats.0");

		if (count == 0)
		{
			tree[0] = ["#luca10#So I'm sort of new to this whoooooole... \"disembodied robot hand\" thing. Ummm... ..."];
			tree[1] = ["#luca04#Is... Is that thing soft? Or is it... -poke- -poke- ...Oh! ...Okay. It's a lot softer than it looks."];
			tree[2] = ["#luca05#...Well, go ahead! It's alright. I'll get used to it~"];
		}
		else
		{
			tree[0] = ["#luca02#Mmmmm so what's next, " + stretch(PlayerData.name) + "? ...You ready to do some pizza \"topping\"? Kyeheheheheh~"];
			tree[1] = []; // assigned later

			tree[10] = ["I'm more\ncomfortable\npizza\nbottoming"];
			tree[11] = ["#luca06#Waaaait, you want me to top YOU!? ... ...Kyeh, well okaaaaay, I can try it..."];
			tree[12] = ["#luca12#-poke- Yeah, -poke- Nggh, you like that don't you...."];
			tree[13] = ["#luca13#-poke- -poke- Yeah? Ohhh, you want me to poke you harder? -poke- You think you can take this? -poke- -poke- -poke-"];
			tree[14] = ["#luca10#... ..."];
			tree[15] = ["#luca09#Kyahhh, this isn't really doing anything for me. ...I think you should take over."];

			tree[20] = ["Yeah let's\ndo this"];
			tree[21] = ["#luca00#Mmmm, how many \"toppings\" do you usually like? Because I could go for the works today~"];

			tree[30] = ["Ugh I just\nlost my\nappetite"];
			tree[31] = ["#luca03#Kyeheheh, sorry! I was trying to set the mood. It seemed like the kind of thing someone would say in a cheesy porno... ..."];
			tree[32] = ["#luca05#Okay, okay! Take two."];

			tree[40] = ["Hope you're\nin the\nmood for\nsausage"];
			tree[41] = ["#luca00#Ooohhh I'm aallllways in the mood for a nice fat sausage!"];
			tree[42] = ["#luca06#Or kyahhhh, five little sausages I guess. ...Wait... ...What exactly did you have in mind?"];

			tree[50] = ["What do\nyou think\nabout\npineapples"];
			tree[51] = ["#luca06#Pineapples!? ...Pineapples just sound dangerous. Unless you... umm..."];
			tree[52] = ["#luca00#...Oh! Ohhhh right. PIIIIINE-apples... I think I get it. Kyahaha~"];
			tree[53] = ["#luca01#Ooooookay, well then why don't we try some pineapples together~"];

			tree[60] = ["How do you\nfeel about\npepperoni"];
			tree[61] = ["#luca01#Ooooohhh yeah, that sounds good. Do you have a big, meaty pepperoni for me?"];
			if (PlayerData.lucaMale)
			{
				tree[62] = ["#luca06#...Kyahh well... I guess you don't reeeeeeeally. Hmmmmmm..."];
				tree[63] = ["#luca00#Well, how about if we just just share myyyyy pepperoni~"];
			}
			else
			{
				tree[62] = ["#luca06#...Kyahh well... I guess you don't reeeeeeeally. Hmmmmmm..."];
				tree[63] = ["#luca00#Well it sounds like we need to find a pepperoni substitute~"];
			}

			tree[70] = ["I could go\nfor some\ndipping\nsauce"];
			tree[71] = ["#luca01#Oh yeahhhhhh? I think I know where you can find some extra dipping saaaaaauce..."];
			tree[72] = ["#luca00#...Just be careful with it, okay? ...Try not to spill any on the carpet. Kyahahahaha~"];

			tree[80] = ["Or maybe\nsomething\nhand tossed"];
			tree[81] = ["#luca01#Oh yeaaaaaahhh? I think I like the sound of that. ...You... you want to \"toss\" something with your hand?"];
			tree[82] = ["#luca00#Well don't let me hold you up, get to tossing! Kyahahaha~"];

			tree[90] = ["How\nabout a\ntossed\nsalad\ninstead"];
			tree[91] = ["#luca01#Mmmmmm a tossed salad? That sounds reeeeeeally nice~"];
			tree[92] = ["#luca06#Nowwwwww, I'm not sure how exactly you're gonna manage that one, <name>. ...This is going to take some ingenuity on your end."];
			tree[93] = ["#luca02#Why don't you show me what you're thinking~"];

			/*
			 * 10, 20 are always in the result; 10 is always first.
			 */
			var choices:Array<Object> = [30, 50, 70, 80, 90];
			if (PlayerData.gender != PlayerData.Gender.Girl)
			{
				choices.push(40);
				choices.push(60);
			}
			FlxG.random.shuffle(choices);
			choices = choices.splice(0, 2);
			choices.push(20);
			FlxG.random.shuffle(choices);
			choices.insert(0, 10);
			tree[1] = choices;
		}
	}

	public static function sexyBefore1(tree:Array<Array<Object>>, sexyState:LucarioSexyState)
	{
		tree[0] = ["#luca04#Mmmmmmmm well this has been nice hasn't it?"];
		tree[1] = ["#luca02#Now remember, if you're satisfied with the service I provide, it's customary to leave a nice tip~"];
		if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			tree[2] = [60, 70, 40, 50];
		}
		else
		{
			tree[2] = [20, 30, 40, 10];
		}

		tree[10] = ["Well\nwhat if\nI stiff\nyou?"];
		tree[11] = ["#luca01#Mmmmmmm~ I wouldn't mind being... stiffed. As long as it was you doing the stiffing, <name>... Kyeheheheh~"];

		tree[20] = ["I think\nyou'll\nwant this\ntip in\nadvance"];
		tree[21] = ["#luca00#Kyeheheheheh~ ... ...Okaaaaay, but try not to be stingy. A good tip makes alllllll the difference~"];

		tree[30] = ["You'll be\nreally\nhappy\nwith my\ntip"];
		tree[31] = ["#luca00#Ooooh, well I'll give you my best service as looooooong as you keep those tips coming. Kyeheheheheh~"];

		tree[40] = ["Okay, I'll\npay you\nafter"];
		tree[41] = ["#luca12#Kkkh, PAY me!?! ...No <name>, that's not what I was... -sigh- ... ...You don't have to pay me for sex."];
		tree[42] = ["#luca13#...Why does everyone always try to pay me!?!"];

		tree[50] = ["Well what\nif I want\nto do the...\nservicing"];
		tree[51] = ["#luca01#Oooooh, well you can do all the servicing you want..."];
		tree[52] = ["#luca00#...And kyahhhhh, if you can make me \"reach my destination\" in 30 minutes, your next pizza's on me~"];

		tree[60] = ["That depends\non whether\nyou can...\nsatisfy me"];
		tree[61] = ["#luca00#Oooooh don't you worry, customer satisfaction is alllllllways at the top of my list!"];
		tree[62] = ["#luca01#Just let me know if there's aaaaanything I can do to better meet your needs~"];

		tree[70] = ["What\nsort of...\nservices\ndo you\nmean?"];
		tree[71] = ["#luca00#What kind of services? Ooooooh, well the only limit is your imagination~"];
		tree[72] = ["#luca06#Although I gueeeesssss I'm also limited your lack of a torso, head and genitals. Your lack of everything, really."];
		tree[73] = ["#luca03#...Hmmm. I guess we're pretty darn limited. So hopefully you've got a reeeeeeally good imagination! Kyahahahaha~"];
	}

	public static function sexyBefore2(tree:Array<Array<Object>>, sexyState:LucarioSexyState)
	{
		if (PlayerData.justFinishedMinigame)
		{
			tree[0] = ["#luca07#Kyahhh, that stupid minigame was making my head spin. ...I'm going to need to take a break from my break now..."];
			tree[1] = ["#luca00#Oh wait, does that minigame mean we don't have to do any more puzzles? Niiiiiice~"];
			tree[2] = ["#luca01#Mmmmmmmm, well why don't we just relax for a bit then..."];
		}
		else
		{
			tree[0] = ["#luca07#Kyahhh, all these puzzles are making my head spin. ...I'm going to need to take a break from my break soon..."];
			tree[1] = ["#luca00#Oh wait, that was the last puzzle wasn't it? Niiiiiice~"];
			tree[2] = ["#luca01#Mmmmmmmm, well why don't we just relax for a bit then..."];
		}
	}

	public static function sexyBefore3(tree:Array<Array<Object>>, sexyState:LucarioSexyState)
	{
		var count:Int = PlayerData.recentChatCount("luca.sexyBeforeChats.3");

		if (PlayerData.lucaMale)
		{
			if (PlayerData.justFinishedMinigame)
			{
				tree[0] = ["#luca02#Alriiight! ...So that counts as doing all of our puzzles, right? We can finally mess around without getting yelled at?"];
			}
			else
			{
				tree[0] = ["#luca02#Alriiight! ...So that was the last puzzle, right? We can finally mess around without getting yelled at?"];
			}
			if (count % 3 == 0)
			{
				tree[1] = ["#luca00#I've been sooooooo pent-up lately. It feels like I've got a seeeerious case of blue balls! I thought about asking if, ummm..."];
				tree[2] = ["#luca06#... ..."];
				tree[3] = ["#luca12#I mean, well yes okay I KNOW my balls are already blue but..."];
				tree[4] = ["#luca13#...Well, you know what I meant!"];
			}
			else
			{
				tree[1] = ["#luca00#Call me crazy but... I think I'm starting to get sort of a logic puzzle fetish... ... Kyeheheheh..."];
				tree[2] = ["#luca05#It's probably just some dumb Pavlovian response from getting my dick played with alongside all of these brainteasers."];
				tree[3] = ["#luca06#Huh, you don't... you don't think Abra planned this, do you?"];
			}
		}
		else
		{
			if (PlayerData.justFinishedMinigame)
			{
				tree[0] = ["#luca02#Alriiight! ...So that counts as doing all of our puzzles, right? We can finally mess around without getting yelled at?"];
			}
			else
			{
				tree[0] = ["#luca02#Alriiight! ...So that was the last puzzle, right? We can finally mess around without getting yelled at?"];
			}
			if (count % 3 == 2)
			{
				tree[1] = ["#luca00#Call me crazy but... I think I'm starting to get sort of a logic puzzle fetish... ... Kyeheheheh..."];
				tree[2] = ["#luca05#It's probably just some dumb Pavlovian response from getting my pussy pounded after we do these brainteasers."];
				tree[3] = ["#luca06#Huh, you don't... you don't think Abra planned for this to happen, do you?"];
			}
			else
			{
				tree[0] = ["#luca02#-sniff- -sniff- Mmmm, I can still smell the pizza from all the way in here."];
				tree[1] = ["#luca04#You knowwwwww, it's a shame you'll never get to try one of our legendary Effen Pizza pies. ...We have some reeeeeeally delicious pies~"];
				tree[2] = [40, 10, 30, 20];

				tree[10] = ["I wish\nI could\neat your\npie"];
				tree[11] = ["#luca01#Kkkh, I reeeeeally wish there was some way I could serve it to you. Kyahhhhh..."];
				tree[12] = ["#luca00#...Well at least this way you can poke around without getting your fingers all greasy."];

				tree[20] = ["It's\nprobably\nsimilar\nto the\npies we\nhave here"];
				tree[21] = ["#luca05#Oooh, I don't know about that. You've never had any pies like our pies."];
				tree[22] = ["#luca00#The dough goes into the oven so fresh and moist, but it comes out all soft and warm..."];
				tree[23] = ["#luca01#It smells so good you just want to get your mouth RIGHT in there and... just... make things really messy~"];
				tree[24] = ["#luca02#And if I really don't care about making a mess, sometimes I'll just drown the whole thing in garlic sauce!"];
				tree[25] = ["#luca07#...Umm, sorry I lost my train of thought..."];

				tree[30] = ["What's\nyour pie\ntaste\nlike?"];
				tree[31] = ["#luca05#Oooh trust me, you've never had any pies like our pies."];
				tree[32] = [22];

				tree[40] = ["But isn't\nit like\n14 inches\nwide?"];
				tree[41] = ["#luca12#What!? What are you implying!?! ...It's just a normal-sized pie, I mean... ...I haven't measured or anything..."];
				tree[42] = ["#luca13#...Besides, it's not really meant for just one person! You're supposed to share it with one or two other people."];
			}
		}
	}

	public static function sexyAfter0(tree:Array<Array<Object>>, sexyState:LucarioSexyState)
	{
		tree[0] = ["#luca00#Oooh... I thought I was pretty good with my hands, but you showed me a few new tricks there~"];
		tree[1] = ["#luca02#We'll have to do this again soon, okay? Thanks for having me over, <name>~"];
	}

	public static function sexyAfter1(tree:Array<Array<Object>>, sexyState:LucarioSexyState)
	{
		tree[0] = ["#luca00#Oohhh, wow... ...Now this isn't why I got into the pizza delivery business but, it suuuuure is a nice perk~"];
		if (PlayerData.hasMet("rhyd"))
		{
			tree[1] = ["#luca08#I umm, I guess I should probably gooooo. ...But I'll see you the next time Rhydon gets hungry."];
			tree[2] = ["%fun-alpha0%"];
			tree[3] = ["#luca02#Which should be what, ten minutes from now? Kyeheheheh~ ... ...See you later, <name>!"];
		}
		else
		{
			tree[1] = ["#luca08#I umm, I guess I should probably gooooo. ...But I'll see you the next time someone orders some pizza, right?"];
			tree[2] = ["%fun-alpha0%"];
			tree[3] = ["#luca02#...Well, see you later <name>!"];
		}

		tree[10000] = ["%fun-alpha0%"];
	}

	public static function sexyAfter2(tree:Array<Array<Object>>, sexyState:LucarioSexyState)
	{
		tree[0] = ["#luca06#Kyahhh... Is there a bathroom here? I reeeeeeeeally have to wash my hands before I go back to work..."];
		tree[1] = ["#luca04#Well, I'll look for one on my way out. ...This was nice though, <name>. It doesn't feel like I get to see you all that often."];
		tree[2] = ["#luca02#...You need to order more pizza so I can see you more! Kyaha~"];
	}

	public static function sexyAfter3(tree:Array<Array<Object>>, sexyState:LucarioSexyState)
	{
		tree[0] = ["#luca00#Nnghhh... No matter how much I practice by myself, it alllllways feels so much better when you do it~"];
		tree[1] = ["#luca04#Well umm, it was good getting to see you again <name>! Hope we can do this again soon~"];
	}

	public static function sexyAfterGood0(tree:Array<Array<Object>>, sexyState:LucarioSexyState)
	{
		tree[0] = ["#luca00#Kyehhh... that was... ...ohhh... so- something else, you... nghh..."];
		tree[1] = ["#luca01#Was... was that really just one hand? Kyehh~ I... I blacked out for a little there but... ooohhh..."];
		tree[2] = ["#luca00#...I could swear I felt... a few extra fingers? --kyaaahhh, maybe... maybe a tentacle... nghhh..."];
		tree[3] = ["#luca09#We're... we're gonna do that again some time, right? ...nghhh! ...Just, just like that... kyahhhhhh~"];
	}

	public static function sexyAfterGood1(tree:Array<Array<Object>>, sexyState:LucarioSexyState)
	{
		tree[0] = ["#luca01#Nggghhh... That was so... kyehhh-- can't feel... can't move my legs... mmmmfff..."];
		tree[1] = ["#luca00#Oooohhh, I... I have to... kya-ahhh~~ Have to go back to work, but... can't..."];
		tree[2] = ["#luca09#Is it-- kyahhhhh... Is it okay if I just lay here for awhile? Just until, oohhh... Just until my legs work again... Hahhhhhhhh~"];
	}

	public static function firstTime(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			// which professor are we replacing?
			var prefix = getLucarioReplacementProfPrefix();

			if (prefix == "smea")
			{
				fillInReplacementTree(tree);
				tree[2] = ["#smea03#Oh hi <name>! ...Somehow I KNEW you were going to show up the instant, umm..."];
				tree[60] = ["#smea10#Umm... I thought it was my turn, am I in your way or something?"];
				tree[64] = ["#smea02#Oh, no no, it's okay! I mean <name> and I see each other all the time anyway. ...You two have fun!"];
			}
			else if (prefix == "grov")
			{
				fillInReplacementTree(tree);
				tree[2] = ["#grov02#You're getting the hang of these puzzles by now, yes? Why, it's... errrm..."];
				tree[60] = ["#grov06#Ah, can I help you? ...I feel like I'm perhaps in your way... ..."];
				tree[64] = ["#grov02#Ahhh sure, think nothing of it! ...<name> and I see each other plenty. ...You two enjoy yourselves!"];
			}
			else if (prefix == "buiz")
			{
				fillInReplacementTree(tree);
				tree[2] = ["#buiz05#Heyyyy back for more from your favorite Buizel right? Your uhhh..."];
				tree[60] = ["#buiz06#Uhh so what's going on? ...Do you need me here for this?"];
				tree[64] = ["#buiz02#Yeah yeah okay, I figured it was something like that. Hey don't worry! I'll see you around, <name>~"];
			}
			else if (prefix == "rhyd")
			{
				fillInReplacementTree(tree);
				tree[2] = ["#RHYD02#Alright! Back for another mental workout with your favorite... Your favorite, err..."];
				tree[60] = ["#RHYD06#Hey uhh what exactly's going on here? I'm feeling like sort of a third wheel or something."];
				tree[64] = ["#RHYD02#Hey don't worry about it! ...Those pizzas are kind of calling my name anyways. Grehhh! Heh-heh-heh!"];
			}
			else if (prefix == "sand")
			{
				fillInReplacementTree(tree);
				tree[2] = ["#sand02#Oh hey! Ready for some more puzzles? I know I'm uhhh..."];
				tree[60] = ["#sand00#Ayyy what's this, we doin' like uhhh, a little menage a trois bonus round? 'Cause I can dig it, although <name> might kinda have his hands full..."];
				tree[64] = ["#sand01#Heh! Yeah, yeah, I see how it is. Just uhh, stick around after you two are done, okay Lucario? ...I'll be by to bring you some dessert~"];

				if (PlayerData.gender == PlayerData.Gender.Girl)
				{
					DialogTree.replace(tree, 60, "have his", "have her");
				}
				else if (PlayerData.gender == PlayerData.Gender.Complicated)
				{
					DialogTree.replace(tree, 60, "have his", "have their");
				}
			}
			else
			{
				tree[0] = ["%swapwindow-luca%"];
				tree[1] = ["%fun-alpha0%"];
				tree[2] = ["#abra05#It's right over here, okay? ...And you can see what you look like on that screen there-- so try to keep yourself in frame."];
				tree[3] = ["%fun-alpha1%"];
				tree[4] = [15];

				tree[60] = ["#abra06#Oh ehhhh, slight change of plans <name>-- Lucario's going to fill in for me here. ...Somehow I thought you'd be okay with that."];
				tree[61] = ["#abra03#...You owe me big time! Eh-heheheheh~"];
				tree[62] = ["#luca14#Ah, yes! Nice to meet you, <name>~"];
				tree[63] = ["#luca04#So, Abra explained all this puzzle stuff REALLY quickly, but I'm still sort of lost... maybe I'll understand it better once you show me?"];
				tree[64] = ["#luca03#Okay, let's go!"];

				tree[10000] = ["%fun-alpha1%"];
			}

			tree[15] = ["#luca05#In frame. Got it. Wait, is that the..."];
			tree[16] = ["#luca03#Kyahhh! It's so cute! ...Aww and loooooook it's even got a little avatar face!"];
			tree[17] = ["#luca06#...Usually they just film me and add in the game part later. ...Wait, does that mean he can hear me?"];
			tree[18] = [20, 25, 30];

			tree[20] = ["I can\nhear you"];
			tree[21] = [50];

			tree[25] = ["Hello\nLucario!"];
			tree[26] = [50];

			tree[30] = ["Aww yeah,\njackpot"];
			tree[31] = [50];

			tree[50] = ["#luca02#Ahhh! You must be umm... <name>? Sorry! This is all sort of new to me."];
			tree[51] = [60];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 17, "he can", "she can");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 17, "he can", "they can");
			}
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["%fun-nude0%"];
			tree[1] = ["%fun-nohat%"];
			tree[2] = ["#luca02#Mmm okay, and off... comes... the hat. Kyeheheheh! How do my ears look? ... ...You can be honest..."];
			tree[3] = ["%fun-alpha0%"];
			tree[4] = ["#abra08#No, no, come here. Take off your hat AND your shirt... ...AND your undershirt..."];
			tree[5] = ["#abra13#Okay, why are you wearing so many clothes!!"];
			tree[6] = ["#abra12#Well, just take off HALF your clothes now, and half after the next puzzle. ...You can figure out the details yourself."];
			tree[7] = ["#luca07#Kwehhh? Soooo, lemme get this straight. I'll be completely naked after just TWO of these puzzles? ...I mean, other hentai games at least try to drag it out a little..."];
			tree[8] = ["%fun-nude1%"];
			tree[9] = ["%fun-alpha1%"];
			tree[10] = ["#abra10#Wh... wait, OTHER hentai games?"];
			tree[11] = ["#luca08#Well... Well you didn't think... I mean obviously I've... Oh, umm..."];
			tree[12] = ["#luca04#Ohhhh sweetie, of course. Of COURSE you're my first hentai game! ...And it's normal to finish so quickly!"];
			tree[13] = ["#luca02#Really, I'm um... It's flattering. ...It just means you like me a lot~"];
			tree[14] = ["#abra12#Don't patronize me."];

			tree[10000] = ["%fun-alpha1%"];
			tree[10001] = ["%fun-nude1%"];
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["#luca02#And off go the pants! Woooo!"];
			tree[1] = ["#luca06#So ummm <name>, what's like, what's your whole deal anyway? Are you another Pokemoooon? Or... maybe you're a human? Or something else?"];
			tree[2] = ["#luca04#..."];
			tree[3] = ["#luca10#Umm, hello? Are you um... Wait, can he hear me?"];
			tree[4] = ["%enterabra%"];
			tree[5] = ["#abra04#Oh here, sometimes you have to press this when you ask a question..."];
			tree[6] = [15, 25, 20, 30];

			tree[15] = ["I'm a\npokemon"];
			tree[16] = [50];

			tree[20] = ["I'm a\nhuman"];
			tree[21] = [50];

			tree[25] = ["I'm something\ndifferent"];
			tree[26] = [50];

			tree[30] = ["I'd rather\nnot say"];
			tree[31] = [50];

			tree[50] = ["#luca07#Wait, well... Wait then why did it work last time? I didn't press a button then..."];
			tree[51] = ["#abra08#-sigh- So, the question-and-answer stuff is handled by a short-term memory recurrent neural network, but it's not perfect."];
			tree[52] = ["#abra05#...So if you don't see your question pop up for some reason, just hit this button."];
			tree[53] = ["#luca06#Kyehhh, okay. ... ...Soooooo <name>, how old are you anyway?"];
			tree[54] = ["#abra12#Idiot, don't ask THAT! You're going to break it!"];
			tree[55] = ["#luca10#Ehh?"];
			tree[56] = ["#abra06#Like... simple questions! Multiple choice!! So you might ask ehhhh... \"<name>, were you born in an even or an odd year?\""];
			tree[57] = [70, 65, 80, 75];

			tree[65] = ["I was\nborn in an\neven year"];
			tree[66] = [90];

			tree[70] = ["I was\nborn in an\nodd year"];
			tree[71] = [90];

			tree[75] = ["That\nquestion is\nreally dumb"];
			tree[76] = [100];

			tree[80] = ["Wait...\nwhat?"];
			tree[81] = [100];

			tree[90] = ["#luca07#Okaaay well sure, but that sort of defeats the purpose. I mean I was trying to start a conversation, and I can't really--"];
			tree[91] = ["#abra09#--well, -sigh- that was just an example, okay!?"];
			tree[92] = ["#luca06#But couldn't you have just given like, a range of ages, or-"];
			tree[93] = ["#abra12#--will you just...! Hmph. Nevermind. I suppose the concept of an \"example\" is too complex for your tiny shrivelled ant scrotum of a brain."];
			tree[94] = ["%exitabra%"];
			tree[95] = ["#abra13#...Just make your own stupid game if you think you can do better."];
			tree[96] = [110];

			tree[100] = ["#abra09#Tsk, look it's just an example, okay!? I was just showing how..."];
			tree[101] = [92];

			tree[110] = ["#luca06#... ...Umm, okay. Bye... ..."];
			tree[111] = ["#luca10#... ..."];
			tree[112] = ["#luca08#Eesh sooooo... ...Am I like, getting on her nerves, or is she just like that all the time?"];
			tree[113] = [140, 130, 120, 150];

			tree[120] = ["He's not\nusually\nthis bad"];
			tree[121] = ["#luca04#Hmm okay. I must have just caught her at a bad time."];
			tree[122] = [200];

			tree[130] = ["He's like\nthis all\nthe time"];
			tree[131] = ["#luca04#Hmm okay, yeah. So she's one of thoooose types. ...Oh well, I've seen worse."];
			tree[132] = [200];

			tree[140] = ["He's\nusually\nworse"];
			tree[141] = [131];

			tree[150] = ["...Abra's\na boy"];
			tree[151] = ["#luca04#Oh. Ohhhhhhh right, I think I remember her saying something like that! ...Uhh so, umm..."];
			tree[152] = [200];

			tree[200] = ["#luca05#Anyway, one last puzzle, right? ...Before the other stuff?"];
			tree[201] = ["#luca02#...Don't worry, Abra already warned me about what's coming up. Most of the other games skip right to the sex stuff, so it was kind of nice, ummm..."];
			tree[202] = ["#luca01#It was nice getting to meet you, <name>. ...You've been really patient with me~"];
			tree[203] = [220, 230, 240, 250];

			tree[220] = ["It was nice\nmeeting\nyou too"];
			tree[221] = ["#luca03#Kyeheheheh~ Well... You know, you guys order a lot of pizza, right?  ...Maybe if I pull some strings, I can handle your deliveries personally from now on."];
			tree[222] = ["#luca00#You know, that way we can maybe see each other more often. ...But anyway umm... so one last puzzle?"];
			tree[223] = [310, 315, 320, 325];

			tree[230] = ["I hope you\nvisit again\nsoon"];
			tree[231] = [221];

			tree[240] = ["How many\ngames have\nyou been\nin anyway?"];
			tree[241] = ["#luca08#Ohh, just... I don't like to talk about my other games. I think it's sort of tacky, but..."];
			tree[242] = ["#luca10#Well they're usually just these simple little point-and-click undressing ones, or they'll have a few animations in a gallery..."];
			tree[243] = ["#luca05#...But, this is the first one I've seen that's a real actual game! I think I'll have to come back to this one a few times~"];
			tree[244] = [300];

			tree[250] = ["When I\nlook into\nyour eyes\nI see the\nfaces of our\nchildren"];
			tree[251] = ["#luca11#Wh... wait, whaaat!?!"];
			tree[252] = ["#luca09#S-sorry, umm I... I think I must have pressed the wrong button!? This is all sort of new to me... Ummm... Ummmmmm..."];
			tree[253] = [300];

			tree[300] = ["#luca07#So ummm... so one last puzzle?"];
			tree[301] = [310, 315, 320, 325];

			tree[310] = ["Yes,\none last\npuzzle"];
			tree[311] = [330];

			tree[315] = ["Umm..."];
			tree[316] = [330];

			tree[320] = ["Well,\nyeah"];
			tree[321] = [330];

			tree[325] = ["Why are\nyou asking\nme?"];
			tree[326] = [330];

			tree[330] = ["#luca06#Oh! ...Oh I'm sorry, I guess the way I phrased that made this dumb computer thingy think I was asking a question? Kkkh, it's so picky!"];
			tree[331] = ["#luca04#Ummm... let me try that again..."];
			tree[332] = ["#luca15#One last puzzle! ...Over!!"];

			if (!PlayerData.abraMale)
			{
				tree[113] = [140, 130, 120];
				tree[120] = ["She's not\nusually\nthis bad"];
				tree[130] = ["She's like\nthis all\nthe time"];
				tree[140] = ["She's\nusually\nworse"];
			}
			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 3, "can he", "can she");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 3, "can he", "can they");
			}
		}
	}

	public static function genderCorkboard(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["%fun-alpha0%"];
			tree[1] = ["#luca06#Oh! I just thought umm... You're kind of blocking the door... Wait, can't I come in? I was just here to see <name>..."];

			if (PlayerData.abraStoryInt == 5)
			{
				tree[2] = ["#abra08#Ehhhh, sorry, it's just I think this game was balanced around nine specific characters, and ummmmmm... I just think Abra would have wanted it this way."];
				tree[3] = ["#abra06#I mean... I think I'd have wanted it this way. ...I think I... Ehhh..."];
				tree[4] = ["#abra11#Right, I want it this way. Obviously I know what I want! Eh-heheheheh. Ehhhhhh..."];
				tree[5] = [10];
			}
			else
			{
				tree[2] = ["#abra05#Ehhhh, I don't think that will be necessary. ...You've made your token appearance, so we won't be requiring your services anymore."];
				tree[3] = ["#luca13#\"Requiring my services!?\" Hey I'm not some sort of a... Kkkhh... That's a very rude implication!"];
				tree[4] = ["#abra06#It's just, well... I needed to be able to truthfully advertise that a Lucario was in my game, so that the popularity would spike."];
				if (PlayerData.isAbraNice())
				{
					tree[5] = ["#abra05#But now that word's spread, I think we're good! Sorry, it's nothing personal~"];
				}
				else
				{
					tree[5] = ["#abra02#But now that word's spread, I think we're good! Bye bye now~"];
				}
				tree[6] = [10];
			}

			tree[10] = ["#luca10#Wh- well... I mean I brought you guys a bunch of free pizza if that changes anything!"];
			tree[11] = ["#RHYD03#Free pizzas!?! I heard that!! Gr-roarrrrrr!!!"];
			tree[12] = ["#abra10#Hey, wait just a second you big dope! If we accept the pizzas then that means I have to... OWWWW, hey!!! Don't push!"];
			tree[13] = ["#RHYD04#Nope. Nope. Don't care. Free pizzas."];
			tree[14] = ["#luca02#..."];
			tree[15] = ["#abra09#... ..."];
			tree[16] = ["#abra13#Tsk, fine. Just this once, okay?"];
			tree[17] = ["%fun-alpha1%"];
			tree[18] = ["#luca03#Yay! Kyeheheheheheh! ...Hi <name>!"];
			tree[19] = ["#luca14#I'm sorry I took so long. ...Thanks for being patient~"];

			tree[10000] = ["%fun-alpha1%"];
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["%entergrov%"];
			tree[1] = ["#grov05#Ahh, Lucario! Why, I wasn't expecting to see you here today~"];
			tree[2] = ["#luca12#Kkkkh, yeah, yeah, I get it. What, am I in your spot or something? I'm guessing you want me to leave, too, is that it? I swear, you guys used to be nice..."];
			tree[3] = ["#grov10#What? ...No, no, nothing like that! I was just... attempting to be cordial? ...Err, oh and thanks for the free pizza!"];
			tree[4] = ["#grov09#Is... everything alright? ...You seem a tad tense."];
			tree[5] = ["#luca08#Kyahh... Sorry, it's just..."];
			tree[6] = ["#luca09#...Two customers stiffed me in a row, and... then I thought I could sneak over here in between deliveries... But Abra wouldn't let me in the front door, and..."];
			if (PlayerData.abraMale)
			{
				tree[7] = ["#grov03#Ahhh Abra. Yes. ...The source of many a sour mood. Try not to let him get to you."];
				tree[8] = ["#luca06#Yeah okay can we talk about that? So what is her problem? Is she usually like this with new people or does she just have a hair up her butt?"];
				tree[9] = ["#grov06#Well ehhhh... Remember, Abra's a boy."];
				tree[10] = ["#luca02#Kyeheheheheh! Yeah, okay. Abra's a boy. ... ...Come on, that's mean."];
				tree[11] = ["#grov10#D'ehh, well... Should we perhaps discuss this in private?"];
				tree[12] = ["%fun-longbreak%"];
				tree[13] = ["%exitgrov%"];
				tree[14] = ["#luca07#Kyehh, wait, I'm sorry. Were you being serious? Or... (whisper, whisper)"];
				tree[15] = ["#grov06#(whisper, whisper)"];
			}
			else
			{
				tree[7] = ["#grov03#Ahhh Abra. Yes. ...The source of many a sour mood. Try not to let her get to you."];
				tree[8] = ["#luca06#Yeah okay can we talk about that? So what is his problem? Is he usually like this with new people or does he just have a hair up his butt?"];
				tree[9] = ["#grov06#Well ehhhh... Remember, Abra's a girl."];
				tree[10] = ["#luca02#Kyeheheheheh! Yeah, okay."];
				tree[11] = ["#luca07#...Well wait, do you mean in real life? Because I thought she told me that I was supposed to ummmmm..."];
				tree[12] = ["#grov06#Perhaps we should discuss this in private?"];
				tree[13] = ["%fun-longbreak%"];
				tree[14] = ["%exitgrov%"];
				tree[15] = ["#luca10#Kyehh, right, right, I'm sorry. I just thought that we were supposed to... (whisper, whisper)"];
				tree[16] = ["#grov05#(whisper, whisper)"];
			}
			tree[10000] = ["%fun-longbreak%"];
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["#luca02#Oh wow so now I FINALLY understand all that stuff Abra was trying to tell me on the first day!"];
			tree[1] = ["#luca10#You know, he seems like a smart guy but he's reeeeeeeeeeally bad at explaining things..."];
			tree[2] = [40, 30, 20, 10];

			tree[10] = ["That's why\nGrovyle does\nthe tutorials"];
			tree[11] = ["#luca07#Oh my gooood, can you imagine trying to learn this kind of a game from Abra!? I think I'd pull my fur out!"];
			tree[12] = [50];

			tree[20] = ["He has\na way with\nwords"];
			tree[21] = ["#luca03#Kkkkkhh, yeah that's a generous way of putting it. And Hannibal Lecter knew his way around a kitchen! Kyeheheheh~"];
			tree[22] = [50];

			tree[30] = ["You get\nused to\nhim"];
			tree[31] = ["#luca07#Kkkkhh, I mean really? How do you even go about trying to friends with someone like that, I think I'd pull my fur out!"];
			tree[32] = [50];

			tree[40] = ["He's not\nthat smart"];
			tree[41] = ["#luca07#Right? I mean this is just basic social interaction, I think most people figure this out when they're teenagers."];
			tree[42] = [50];

			tree[50] = ["#luca04#I just can't even believe he still has roommates. I mean if I were-"];
			tree[51] = ["#luca00#-Oh wait wait wait, here comes Rhydon. ...Hey Rhyyyyyyydonnnnnnnn~"];
			tree[52] = ["%enterrhyd%"];
			tree[53] = ["#RHYD06#Grehh?"];
			tree[54] = ["#luca02#...Rhydon, you're a " + (PlayerData.rhydMale ? "boooooooyyyyyyyyyy~" : "giiiiiiiirrrrrrrrl~")];
			tree[55] = ["#RHYD02#Uhh... Yep! Last I checked! Greh! Heheheheh."];
			tree[56] = ["#luca03#This is so coooooooool! Kyahhahahahahahaha~"];
			tree[57] = ["#RHYD06#... ..."];
			tree[58] = ["%exitrhyd%"];
			tree[59] = ["#RHYD10#...Bye!"];
			tree[60] = ["#luca00#\"Last I checked.\" Heheheh! Oh, Rhydon..."];
			tree[61] = ["#luca05#So aaaaaaaanywaaaaaaays, where were we?"];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 1, "he seems", "she seems");
				DialogTree.replace(tree, 1, "smart guy", "smart girl");
				DialogTree.replace(tree, 1, "but he's", "but she's");
				DialogTree.replace(tree, 20, "He has", "She has");
				DialogTree.replace(tree, 30, "to\nhim", "to\nher");
				DialogTree.replace(tree, 40, "He's not", "She's not");
				DialogTree.replace(tree, 50, "believe he", "believe she");
			}
		}
	}

	public static function newJob(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["%fun-alpha0%"];
			tree[1] = ["#luca02#Heyyyyy, it's me again! ...I brought pizzaaaaaaaaas~"];
			tree[2] = ["#abra06#Fine, fine, you can come in. ...How about ehhhh ^2,000, is that fair?"];
			tree[3] = ["#luca03#Don't worry about it, the pizzas are on the house! My way of saying thank you~"];
			tree[4] = ["#abra05#Ah, you misunderstood. I meant ^2,000 for you. ^2,000 for you to come in."];
			tree[5] = ["#luca11#Wh-what!? No! That's... kkkkh! Are you serious!?!"];
			tree[6] = ["#abra06#It's just that you usually come in here, stay for a long time... You drink all of our sodas..."];
			tree[7] = ["#luca07#I had ONE! One soda last time! ...And I didn't even ask for it, Grovyle just brought it to me!!"];
			if (PlayerData.isAbraNice())
			{
				tree[8] = ["#abra04#...And also you're always shedding everywhere, and Kecleon's allergic... And you ate all that birthday cake..."];
				tree[9] = ["#luca13#What! You're just, kyahhh Kecleon is not ALLERGIC, his BOYFRIEND IS A DOG. And that was YOUR BIRTHDAY! You invited me!"];
				tree[10] = ["#luca10#..."];
				tree[11] = ["#luca07#Wait a minute..."];
				tree[12] = ["#abra03#Eh-heheheheheh!"];
				tree[13] = ["%fun-alpha1%"];
				tree[14] = ["#luca12#You're a jerk, Abra."];
				tree[15] = ["#abra02#Sorry, sorry. What! I can't have some fun sometimes~"];
				tree[16] = [24];
			}
			else
			{
				tree[8] = ["#abra04#...And also you're always shedding everywhere, and it seems like Kecleon's allergic. So I'll have to vacuum..."];
				tree[9] = ["#luca13#What! You're just, kyahhh Kecleon is not ALLERGIC, his BOYFRIEND IS A DOG."];
				tree[10] = [20];
			}

			tree[20] = ["#luca12#Kkkkh fine, you know what? Here, you can... You can take your stupid ^2,000..."];
			tree[21] = ["%fun-alpha1%"];
			tree[22] = ["#luca13#But just know that you're just... you're mean! You're a mean abra who's mean."];
			tree[23] = ["#abra02#Ee-heheheh. Pleasure doing business~"];
			tree[24] = ["#luca06#..."];
			tree[25] = ["#luca10#Let's see, is this thing already on?"];
			if (PlayerData.isAbraNice())
			{
				tree[26] = ["#luca05#Ohh hello <name>! ...You wouldn't believe what I had to go through to get in here, Abra's trying to charge me money now..."];
			}
			else
			{
				tree[26] = ["#luca05#Ohh hello <name>! ...You wouldn't believe what I had to go through to get in here, Abra's charging me money now..."];
			}
			tree[27] = [70, 40, 50, 60];

			tree[40] = ["I can give\nyou $2,000\nif that helps"];
			tree[41] = ["#luca03#Awwwww that's really sweet of you! ...But I think he wants reeeeeal money."];
			tree[42] = [100];

			tree[50] = ["That's not\nvery nice"];
			tree[51] = ["#luca06#Yeah, but I sort of understand. ...It's his house, I'm a guest, and it's probably annoying that I keep showing up unannounced."];
			tree[52] = [100];

			tree[60] = ["I am so\nfed up with\nthat guy"];
			tree[61] = [51];

			tree[70] = ["Well... I'll\ntry to make\nit worth it"];
			tree[71] = ["#luca04#Ohhh don't stress over it! It's not like any of this is your fault."];
			tree[72] = [100];

			tree[100] = ["#luca10#I don't suppose you know anybody who will pay ^2,000 for two lukewarm supreme pizzas?"];
			tree[101] = ["#luca07#We had a customer who refused to take them because they had the wrong color olives... ...I mean, what sort of pizza place carries green olives anyway!? Kkkhh..."];
			tree[102] = ["#luca14#... ...This has not been a good day. But at least you're here now~"];

			tree[10000] = ["%fun-alpha1%"];

			if (!PlayerData.keclMale)
			{
				DialogTree.replace(tree, 9, "ALLERGIC, his", "ALLERGIC, her");
			}
			if (!PlayerData.smeaMale)
			{
				DialogTree.replace(tree, 9, "BOYFRIEND IS", "GIRLFRIEND IS");
			}
			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 60, "that guy", "that girl");
				DialogTree.replace(tree, 41, "he wants", "she wants");
				DialogTree.replace(tree, 51, "his house", "her house");
			}
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["#luca12#Kyahhhh this is turning into another one of those days. I reeeeeeeeeeeally need to find a new joooooob..."];
			tree[1] = ["#luca04#Don't get me wrong, the pizza delivery thing definitely has its perks!"];
			tree[2] = ["#luca05#We get to listen to whatever music we want, and the money's pretty good. I can earn ^15,000 in tips on a good day."];
			tree[3] = ["#luca02#...Plus, the employees are fun to work with... actually my best friend is a cook! And my boss is nice too,"];
			tree[4] = ["#luca04#He always has my back when it comes to annoying corporate stuff. Like they tried this stupid \"total time accountability\" thing..."];
			tree[5] = ["#luca06#So they'd dock us a half hour's pay if we weren't in the store the MINUTE our shift started. Which is the stupidest thing ever, kkkkhhh..."];
			tree[6] = ["#luca03#...But I gave my boss my password, and now he just clocks me in when the store opens so I always get my full paycheck! Kyahahahah~"];
			tree[7] = ["#luca05#... ..."];
			tree[8] = ["#luca08#... -sigh- I guess my problem is that it's comfortable working there, but it FEELS like I should be doing something else, you know?"];
			tree[9] = [20, 25, 35, 30];

			tree[20] = ["Well what\nwould you\nrather be\ndoing?"];
			tree[21] = ["#luca06#Kkkh, I don't know, just something that pays better. ...Maybe something in veterinary medicine..."];
			tree[22] = [51];

			tree[25] = ["Are you\nin school?"];
			tree[26] = ["#luca04#I was in school. I'm taking a break from that stuff right now, I don't really know what I want to do."];
			tree[27] = [50];

			tree[30] = ["Have you\nlooked for\nother jobs?"];
			tree[31] = ["#luca06#Yeah, but they all want at least a Bachelor's degree which means going back to school."];
			tree[32] = ["#luca05#And if I go back to school, I'd need to figure out what I want to go to school for. Maybe something like veterinary medicine..."];
			tree[33] = [51];

			tree[35] = ["Something\nin an\noffice?"];
			tree[36] = [21];

			tree[50] = ["#luca05#Just something that pays better... Maybe something in veterinary medicine..."];
			tree[51] = ["#luca07#I mean, I've always been really good with animals, so it at least SEEMS like something I'd be good at."];
			tree[52] = [80, 75, 70, 85];

			tree[70] = ["That's an\nexpensive\ndegree"];
			tree[71] = ["#luca06#It is? Kyehhhh well I don't know. Maybe I'd go back for something else then. It's just, well..."];
			tree[72] = [100];

			tree[75] = ["That's like\neight years\nof school"];
			tree[76] = [71];

			tree[80] = ["Maybe\nyou should\nconsider\nsomething\neasier"];
			tree[81] = [86];

			tree[85] = ["You could\nstudy while\nworking\npart time"];
			tree[86] = ["#luca06#Kyehhhh, you're starting to sound like my father. It's just, well..."];
			tree[87] = [100];

			tree[100] = ["#luca10#You know what, if we get into this right now it's going to be this whole big thing."];
			tree[101] = ["#luca04#...Why don't you get through this puzzle first, hmmm? We can talk about this after."];
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["%fun-nude1%"];
			tree[1] = ["#luca04#So yeah, obviously I've thought about going back to school. I went to college for two years for general education stuff, right after high school..."];
			tree[2] = ["#luca05#...But after your sophomore year-- that's when they force you to pick a major, and I just didn't know what I wanted to do yet."];
			tree[3] = ["#luca10#So I took a semester off to save up some extra money... And then I took a second semester, and a third, and I guess it's been about ehhh... five years now?"];
			tree[4] = ["#luca05#... ...So I've thought about going back, but it's pretty expensive."];
			tree[5] = ["#luca06#Paying that kind of money for two more years of school feels like a lifetime commitment, and I'm not really sure if I'm ready for that yet, you know?"];
			tree[6] = ["#luca08#I feel like if I'm going to invest that much money into something, I need to be reeeeeeeally passionate about it. ...And I've just never felt that way about anything."];
			tree[7] = ["#luca02#When I was a kid I wasn't thinking, \"I want to be a doctor\" or \"I want to be an astronaut.\" ...I was thinking about the big house I'd live in and all the friends I'd have."];
			tree[8] = ["#luca06#...Why can't there just be a rewarding, well-paying job for people who don't care what they're doing?"];
			tree[9] = ["#luca07#... ...I mean, kkkhhh... When did you know what YOU wanted to do?"];
			tree[10] = [25, 40, 35, 20, 30];

			tree[20] = ["When\nI was\nreally\nyoung"];
			tree[21] = ["#luca12#Kyahh, well that's really lucky. I wish it could magically just be that simple for everybody..."];
			tree[22] = [50];

			tree[25] = ["When\nI started\nthinking\nabout\ncollege"];
			tree[26] = [21];

			tree[30] = ["After I\ngraduated"];
			tree[31] = ["#luca12#Kyahh, well at least now you know. ...It would be nice if we were just preprogrammed with jobs as infants..."];
			tree[32] = [50];

			tree[35] = ["I'm still\nnot doing\nwhat I\nwant\nto do"];
			tree[36] = ["#luca09#Kyahh that sucks, but at least you know, right? ...I wish it could magically just be that simple for everybody..."];
			tree[37] = [50];

			tree[40] = ["I still\ndon't know\nwhat I\nwant\nto do"];
			tree[41] = ["#luca09#Kyahh, see? You know what it's like. ...Why can't we just be preprogrammed with jobs when we're infants..."];
			tree[42] = [50];

			tree[50] = ["#luca10#Like that one Philip K. Dick story? The one where it's the future, and everyone's problems are solved but they're all really sad."];
			tree[51] = ["#luca04#Kyehhh whatever, it's okay. I think I'll keep delivering pizzas for awhile. It feels like it's just... the safest out of a lot of crappy options."];
			tree[52] = ["#luca03#Or maybe if I build up enough of an audience here, I can always have a future in stripping. Kyahahahahahaha~"];
			tree[53] = ["%fun-nude2%"];
			tree[54] = ["#luca05#Oh! that's right, I almost forgot about my pants~"];
			if (PlayerData.cash >= 1000)
			{
				tree[55] = [85, 75, 80, 70];
			}
			else
			{
				tree[55] = [75, 80, 70];
			}

			tree[70] = ["You're\nnot going\nto start\ncharging\nme, are\nyou?"];
			tree[71] = ["#luca00#Iiiiii dunno! Maybe I shoooooould..."];
			tree[72] = ["#luca02#Not too much at first! Just y'know, a couple extra bucks to help compensate for Abra's little cover charge..."];
			tree[73] = [100];

			tree[75] = ["Actually,\nyou could\nmake serious\nmoney\nstripping"];
			tree[76] = [87];

			tree[80] = ["You could\nstart a\nnaked pizza\ndelivery\nbusiness"];
			tree[81] = ["#luca03#Kyeheheheheh! Sure, if nothing else, at least I wouldn't have to wear a hat anymore~"];
			tree[82] = [100];

			tree[85] = ["(Give $1,000)"];
			tree[86] = ["%pay-1000%"];
			tree[87] = ["#luca02#Kkkkh, yeah, thanks. ...That's just the encouragement I needed~"];
			tree[88] = [100];

			tree[100] = ["#luca04#Well anyway, I know it probably doesn't look like this accomplished much but... Thanks, it felt good getting all of this off my chest."];
			tree[101] = ["#luca00#...You're... You're really nice to talk to, <name>. Human or Pokemon or... whatever you are. You're just, ummm..."];
			tree[102] = ["#luca01#Well, thanks~"];

			tree[10000] = ["%fun-nude2%"];
		}
	}

	public static function random00(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("luca.randomChats.0.0");

		if (count % 3 == 0)
		{
			tree[0] = ["#luca03#Oh! <name>! Hooray! ...I mean, I was worried I might not catch you in time..."];
			tree[1] = ["#luca04#My manager usually gets sort of suspicious if a delivery run longer than, you know 20 minutes or so, but ohhh... ...I'll just say I had to get gas."];
			tree[2] = ["#luca02#So what's new with you? How are the puzzles going?"];
			tree[3] = [25, 20, 15, 10];

			tree[10] = ["Oh you\nknow, the\nusual grind"];
			tree[11] = ["#luca06#Ohh I know how THAT is... ...Well, hmmm... It's just... sorry to rush you, it's just I'm kind of tight on tiiiiime... What should I doooo..."];
			tree[12] = [31];

			tree[15] = ["They've\nbeen\npretty fun"];
			tree[16] = ["#luca05#Ohh yeah, they LOOK pretty fun! Even if I don't quite understand them yet..."];
			tree[17] = [30];

			tree[20] = ["Some of them\nhave been\nreally hard"];
			tree[21] = ["#luca05#Ohh yeah, they LOOK pretty hard! I mean, I don't really understand them yet..."];
			tree[22] = [30];

			tree[25] = ["The last few\nhave been\npretty easy"];
			tree[26] = ["#luca10#Whoa really!? Well... good for you! Really sounds like you're starting to get the hang of them."];
			tree[27] = [30];

			tree[30] = ["#luca06#...It's just that they ummm, hmmm... It's just... sorry to rush you, it's just I'm kind of tight on tiiiiime... What should I doooo..."];
			tree[31] = ["#luca05#Why don't you just ummmm, try to solve this one extra quick okay!!"];
		}
		else
		{
			tree[0] = ["#luca03#Oh! <name>! Hooray! ...I mean, I was worried I might not catch you in time..."];
			tree[1] = ["#luca07#My manager's starting to catch onto me, though. Kkkkh, I should have mixed up my excuses a little more."];
			tree[2] = ["#luca06#I guess it seemed suspicious when I filled up on gas four times in a row at your house, when there's no gas station anywhere nearby..."];
			tree[3] = ["#luca02#...Soooooo, we might actually have to make this one reeeeeally fast, okay? Do you think you can do that for me?"];
			tree[4] = ["#luca01#Oh, sorry! You look great by the way~"];
		}
	}

	public static function random01(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("luca.randomChats.0.1");

		if (count == 0)
		{
			tree[0] = ["%fun-alpha0%"];
			tree[1] = ["#luca03#Just siiiiiiign here. Thanks!"];
			tree[2] = ["#RHYD04#Errr, did you want to come in? I think it's your turn... ..."];
			tree[3] = ["#luca11#Wait... my turn? You mean it's my turn right now!? Kyehhh!"];
			tree[4] = ["%fun-alpha1%"];
			tree[5] = ["#luca09#-pant- -pant- <name>, that was so fast! ...How did you even know I was coming!?"];
			tree[6] = [35, 20, 30, 25];

			tree[20] = ["I don't\nknow, the\nbutton just\nshowed up"];
			tree[21] = ["#luca02#Yeahhhhhh okay! \"The button of destiny,\" ooooooooooo. ...Well that's only a little creepy~"];
			tree[22] = [50];

			tree[25] = ["It was just\nrandom,\nI guess"];
			tree[26] = ["#luca02#Huhhh just a weird coincidence? That it just happened to show up the instant I pulled up in my car? ...Well that's only a little creepy~"];
			tree[27] = [50];

			tree[30] = ["This is\nweird"];
			tree[31] = ["#luca02#Yeahhhhhhh okay, as long as we're on the same page. Maybe it's what all these cameras are for? ...Well that's only a little creepy."];
			tree[32] = [50];

			tree[35] = ["Maybe\nAbra can\ntell you"];
			tree[36] = ["#luca02#Kyahhhh, I don't know... Maybe it's what all these cameras are for? ...Well that's only a little creepy."];
			tree[37] = [50];

			tree[50] = ["%fun-shortbreak%"];
			tree[51] = ["#luca05#Umm, just let me go drop some stuff in my car, okay!"];

			tree[10000] = ["%fun-shortbreak%"];
		}
		else
		{
			tree[0] = ["%fun-alpha0%"];
			tree[1] = ["#luca06#If I can just get you to sign the receipt... Is it my turn again?"];
			tree[2] = ["#RHYD02#Grehh! Heh-heh-heh. Yeah, you're up again."];
			tree[3] = ["#luca09#-huff- -huff- This is so weeeeeeeird, how does it know!?"];
			tree[4] = ["%fun-alpha1%"];
			tree[5] = ["#luca07#I'm here! -pant- I'm here! -pant- -pant- ...Sorry <name>, this will never stop being weird for me."];
			tree[6] = ["#luca06#...I guess I should probably just ask Abra how it works, but I have this sneaky feeling the truth is even creepier than my imagination..."];
		}
	}

	public static function random02(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#luca02#Heyyyyy <name>! How's your day been going?"];
		tree[1] = ["#luca03#...It's a pretty slow day back at the store and we're overstaffed, so I can take allllllll the time I want today~"];
		tree[2] = ["#luca05#Like, they'll text me if things pick up. ...The other guys will be happy to pick up the extra tips, and it's not like I really need the money~"];
		tree[3] = ["#luca04#So ummm what's been going on with you? More puzzles and stuff?"];
		tree[4] = ["#luca02#That sounds like fun. I could use a good puzzle or two~"];
	}

	public static function random03(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#luca02#" + MmStringTools.stretch(PlayerData.name) + "! Just the person I was hoping to see~"];
		tree[1] = ["#luca04#...You would not belieeeeeeeeve the day I've had. I could really use a puzzle or two right now."];
		tree[2] = ["#luca05#Should we just get started? This looks like a good one to start with..."];
	}

	public static function random10(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("luca.randomChats.1.0");

		if (count % 3 == 0)
		{
			tree[0] = ["#luca02#Ahh! That's better. ...The first thing I always do when I get off work is take off that stupid hat."];
			tree[1] = ["#luca05#...I mean, I should really just take it off when I come over here! It's just force of habit I guess. ...And maybe I'm a little worried my boss will see me."];
			tree[2] = [10, 15, 25, 30];

			tree[10] = ["You look\ncute with\nit on"];
			tree[11] = ["#luca06#...Really? Because I think I look like a big dork..."];
			tree[12] = ["#luca10#Unless that's your type or something, is that it? You're into geeky guys?"];
			tree[13] = ["#luca03#'Cause if that's your thing, you should see the aprons they make us wear when we're running the store! Kyeheheheh! Maybe I'll bring one next time~"];

			tree[15] = ["It's a\nreally\ndorky hat"];
			tree[16] = ["#luca03#Kyahahahah! I know, right? I think a part of why they make us wear them is just so it's impossible to flirt with customers."];
			tree[17] = ["#luca14#...Not that it did a lot of good, seeing as we're... Kyeh! Heh."];
			tree[18] = ["#luca00#I mean, not that we're flirting, but it's just, ummm... We're not NOT flirting, right?"];
			tree[19] = ["#luca09#Is it... it's not just me? ... ...Kkkkh, okay! ... ...Sorry!! I made it weird..."];
			tree[20] = ["#luca07#Ummm, right!! Puzzle number two."];

			tree[25] = ["Is it a\nhealth code\nthing?"];
			tree[26] = ["#luca06#Kkkh no, it's just a dumb corporate policy thing they push down on the franchises."];
			tree[27] = ["#luca12#...And every few weeks they'll do a secret shopper thing, and if we're not wearing the stupid hat, it becomes this big thing. Kyahh...."];
			tree[28] = ["#luca04#You know what, I don't want to think about that now. Let's do more puzzle stuff."];

			tree[30] = ["Whatever's\nmore\ncomfortable"];
			tree[31] = ["#luca06#Kyahh, well yeah I hate having my ears all cooped up in that thing."];
			tree[32] = ["#luca12#If I'm ever caught without it though, kkkkkh... It's just easier to leave it on sometimes so I don't forget."];
			tree[33] = ["#luca04#You know what, I don't want to think about that now. Let's do more puzzle stuff."];

			if (!PlayerData.lucaMale)
			{
				DialogTree.replace(tree, 12, "geeky guys", "geeky girls");
			}
		}
		else
		{
			tree[0] = ["%fun-hat%"];
			tree[1] = ["#luca06#Kyahh! I keep forgetting to take this stupid hat off when I come here..."];
			tree[2] = ["%fun-nohat%"];
			tree[3] = ["#luca12#That thing was NOT designed with Lucario ears taken into consideration."];

			tree[10000] = ["%fun-nohat%"];
		}
	}

	public static function random11(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("luca.randomChats.1.1");

		if (count % 4 == 0)
		{
			tree[0] = ["#luca04#So I'm a little confused about the whole situation here. There always seems to be an awful lot of people around..."];
			tree[1] = ["#luca06#...Does everyone, like... live here together?"];
			tree[2] = [30, 25, 20, 15, 10];

			tree[10] = ["I think\nonly Abra\nlives here"];
			tree[11] = ["#luca10#Oh, wow! This place seems REALLY big for one person but... I guess if he likes to have a lot of people over."];
			tree[12] = ["#luca07#...But wait, don't YOU live here?"];
			tree[13] = [80, 90, 70, 60];

			tree[15] = ["I think\nonly Abra\nand Grovyle\nlive here"];
			tree[16] = ["#luca10#Oh, okay! That makes more sense. ...I thought everyone lived here and was like, wouldn't that get crowded?"];
			tree[17] = [50];

			tree[20] = ["I think\nlike...\nfour of\nthem\nlive here"];
			tree[21] = [16];

			tree[25] = ["I think\nlike...\nsix or\nseven of\nthem\nlive here"];
			tree[26] = [31];

			tree[30] = ["I think\nthey all\nlive here"];
			tree[31] = ["#luca10#Wow! This place is big but it's not like, THAT big. ...I mean, how many bedrooms are there? Doesn't it get crowded?"];
			tree[32] = [50];

			tree[50] = ["#luca07#Wait, do YOU live here?"];
			tree[51] = [80, 90, 70, 60];

			tree[60] = ["Yes, I\nlive here"];
			tree[61] = ["#luca06#Wait like... you actually have a bed here? ...Or do you just mean your little charging station?"];
			tree[62] = ["#luca09#I think I'm even more confused now than I was before."];
			tree[63] = ["#luca10#... ..."];
			tree[64] = [95];

			tree[70] = ["I guess I\ntechnically\nlive here"];
			tree[71] = [61];

			tree[80] = ["No, I live\nfar away"];
			tree[81] = [91];

			tree[90] = ["No, I live\nin another\nuniverse"];
			tree[91] = ["#luca06#Oh... Wait, really!? ...That's kyehhhh, a little weird..."];
			tree[92] = ["#luca10#...Well maybe not TOO weird given everything else that goes on around here, but still."];
			tree[93] = ["#luca05#Actually... I guess what would be REALLY weird is if you used this clumsy glove thing when you lived just around the corner."];
			tree[94] = ["#luca02#So yeah, nevermind, that all seems pretty normal I guess. Kyeheheh..."];
			tree[95] = ["#luca04#Anyway ehhh, what's going on with this puzzle? Hmmmm, hmmmm..."];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 11, "if he", "if she");
			}
		}
		else
		{
			tree[0] = ["#luca04#I still can't get over how big this place is!"];
			tree[1] = ["#luca10#...Kyehhh, I wonder what Abra does for a living... ..."];
		}
	}

	public static function random12(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var rank:Int = RankTracker.computeAggregateRank();
		var count:Int = PlayerData.recentChatCount("luca.randomChats.1.2");

		if (count == 0)
		{
			tree[0] = ["#luca06#So what are all these little numbers on the screen? Minigame count " + commaSeparatedNumber(PlayerData.minigameCount[0]) + ", " + commaSeparatedNumber(PlayerData.minigameCount[1]) + ", " + commaSeparatedNumber(PlayerData.minigameCount[2]) + ", rank #" + rank + ", ummm, a bunch of other stuff..."];
			tree[1] = ["#luca10#Oh I get it, so I'm guessing like Abra's ranked #1... Wait, are there really that many people who play this game?"];
			if (PlayerData.gender == PlayerData.Gender.Boy)
			{
				tree[2] = [15, 20, 10, 30, 25];
			}
			else
			{
				tree[2] = [15, 20, 10, 25];
			}

			tree[10] = ["No, I'm\nthe only one\nplaying"];
			tree[11] = [50];

			tree[15] = ["No, higher\nranks are\nbetter"];
			tree[16] = [50];

			tree[20] = ["No, Abra's\nlike rank\n1,000,000"];
			tree[21] = ["#luca06#Oh, so higher is a good thing? Sorry, I'm still just trying to get a grip on how all this puzzle stuff works."];
			tree[22] = [51];

			tree[25] = ["I don't\nknow"];
			tree[26] = [50];

			tree[30] = ["No, that\nnumber\ncorresponds\nto penis\nlength"];
			tree[31] = ["#luca00#Kkkkh, you don't have a peeeeeeniiiiiis, you're just..."];
			tree[32] = ["#luca10#Oh, oh wait. You mean like, your actual physical body. Wowwwwww! A penis length of " + rank + "? ...Reeeaally? Okaaaaaay..."];
			tree[33] = ["#luca05#Sorry, I'm still just trying to get a grip on how all this puzzle stuff works."];
			tree[34] = [51];

			tree[50] = ["#luca05#Oh alright. Sorry, I'm still just trying to get a grip on how all this puzzle stuff works."];
			tree[51] = ["#luca04#I figure you know, I watch you solve soooooooo many of these puzzles, I should at least try to kind of understand what's going on!"];
			tree[52] = ["#luca02#Okay you can go ahead and start, I'm going to reeeeeeeeally pay attention this time!"];

			if (PlayerData.isAbraNice())
			{
				// we find out during the ending that Abra's rank 100
				DialogTree.replace(tree, 20, "1,000,000", "100");
			}
		}
		else
		{
			tree[0] = ["#luca02#Oh hey, the little screen says you're rank " + rank + " now... Good job! That's a little better than it was last time, right?"];
			tree[1] = [10, 120, 15, 125];

			tree[10] = ["Yeah!\nI've gotten\nbetter"];
			tree[11] = ["#luca00#Oooooh good job! We'll have to find a way to celebrate after this."];
			tree[12] = ["#luca01#You know, maybe do something speciaaaaaaaal... I can think of a few thiiiiiings~"];

			tree[15] = ["Actually\nit's the\nsame"];
			tree[16] = ["#luca10#Ohhhh okay I must have been misremembering. Well that's okay!"];
			tree[17] = ["#luca04#I think if I were doing these puzzles I probably wouldn't pay very much attention to my rank either."];
			tree[18] = ["%fun-nude2%"];
			tree[19] = ["#luca03#I'd be paying too much attention to my seeexy naked Lucaaaaarioooooooooo! Kyehehehehehehehe~"];
			tree[20] = ["#luca00#What, should I not do that?"];
			tree[21] = [40, 45, 55, 50];

			tree[40] = ["No,\nthat's\ngood,\nkeep it\noff"];
			tree[41] = ["%skip%"];
			tree[42] = ["#luca02#Kyeheheheh! Seeeeeeeeeee? Rank? ...What rank?"];
			tree[43] = ["#luca03#Okay okay, I'm sorry to distract you from your puzzle stuff. ...I'll let you get started~"];

			tree[45] = ["No,\nAbra\nwouldn't\nlike it"];
			tree[46] = ["%fun-nude1%"];
			tree[47] = ["#luca06#Ohhhhhhhh yeahhhh, you're probably right. ...I keep forgetting about all these cameras and stuff too, he'd definitely find out if we cheated."];
			tree[48] = ["#luca04#Okay okay, we'll try playing by the rules this time. Let's go ahead and get started~"];

			tree[50] = ["No,\nI don't\nwant to\nmiss any\ntime with\nyou~"];
			tree[51] = ["%fun-nude1%"];
			tree[52] = ["#luca08#Well... I wouldn't want to rush through things with you either, <name>! It's just that it's sometimes hard to keep my hormones bottled in..."];
			tree[53] = ["#luca05#I guess I can be patient for now... ... Just try not to take too long okaaaaaaaay~"];

			tree[55] = ["Yes!\nI mean...\nNo!"];
			tree[56] = ["%fun-nude1%"];
			tree[57] = ["#luca10#No? No I shouldn't... not... not take my pants off? Wait, so that's... shouldn't not, not not... Ummmmm..."];
			tree[58] = ["%fun-nude2%"];
			tree[59] = ["%skip%"];
			tree[60] = ["#luca02#I'm just going to interpret that as a vote for nudity. Woo!"];
			tree[61] = ["#luca03#...If I'm wrong, we can just play the Lucario-putting-his-pants-on bonus round later. Kyahahahahah~"];

			tree[120] = ["Actually\nit's a little\nworse"];
			tree[121] = ["#luca04#Awwwwww well whatever! I think if I were doing these puzzles I probably wouldn't pay very much attention to my rank."];
			tree[122] = [18];

			tree[125] = ["Hmm,\nI don't\nremember"];
			tree[126] = ["#luca04#Ohhh okay. I think if I were doing these puzzles I probably wouldn't pay very much attention to my rank either."];
			tree[127] = [18];

			if (!PlayerData.lucaMale)
			{
				DialogTree.replace(tree, 61, "putting-his", "putting-her");
			}
			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 47, "he'd definitely", "she'd definitely");
			}
		}
	}

	public static function random20(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#luca00#Let's see... Hat, check... Shirt, check... Pants, underwear, check, check... Yep! You've officially beaten the Lucario game~"];
		tree[1] = [20, 40, 10, 30];

		tree[10] = ["Where's\nmy prize?"];
		tree[11] = ["#luca06#Umm hellooooooo? Your prize is sitting right here!!! Unless what, a naked Lucario prize isn't enough for you all of a sudden? Kkkkhh..."];
		tree[12] = ["#luca05#Well not to spoil it too too much but... you know, this is one of those prizes that comes with bonus prizes."];
		tree[13] = ["#luca00#... ...What? ...Don't look at me, you'll have to solve this last puzzle to find out what they are~"];

		tree[20] = ["You're\nso cute"];
		tree[21] = ["#luca01#Stop iiiiiiitttt... That's so embarrassing!"];
		tree[22] = ["#luca06#How would you like it if I talked about how cute YOU were all the time? Hmmmmmm???"];
		tree[23] = ["#luca12#... ...Well, kkkh, whatever!! It's kind of hard for me to explain. ... ...And also, thank you."];

		tree[30] = ["I'd like\nto report\na health code\nviolation"];
		tree[31] = ["#luca01#Kkkkkh, hey c'mon, I'm on break! That means you can... violate whatever you want to violate."];
		tree[32] = ["#luca00#...Not so fast though, I think we still have one last puzzle to solve before we can do that stuff."];
		tree[33] = ["#luca02#So, why don't we just try to keep it in our pants for one more puzzle..."];
		tree[34] = ["%fun-shortbreak%"];
		tree[35] = ["#luca10#...Oh! Shoot! My cell phone's in my pants."];

		tree[40] = ["Well, I\nhaven't\nbeaten it\nyet..."];
		tree[41] = ["#luca12#Wait, really? You mean we can't just do stuff now? Kyahhhhh..."];
		tree[42] = ["%fun-shortbreak%"];
		tree[43] = ["#luca10#Well in that case go ahead and start this last puzzle without me. ...I'm going to go wash up!"];
	}

	public static function random21(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("luca.randomChats.2.1");

		if (count % 4 == 0)
		{
			tree[0] = ["#luca02#And therrrrrre go the pants~"];
			tree[1] = ["#luca01#Kyeheheheheheh! It's always a little weird being naked in someone else's house. It almost feels like..."];
			tree[2] = ["#luca10#...Kyahhhh? I think I just heard that little camera move. Is that thing watching us?"];
			tree[3] = ["%fun-alpha0%"];
			tree[4] = ["#luca06#What is... What's the deal with all these cameras anyways? Did Abra put these in?"];
			tree[5] = [15, 20, 35, 30, 25];

			tree[15] = ["I think\nthey came\nwith the\nhouse"];
			if (count > 0)
			{
				tree[16] = ["#luca07#Okaaaaaay... So why the heck does Heracross care if they're working or not? That doesn't really add up."];
			}
			else
			{
				tree[16] = ["#luca07#Okaaaaaay... So you think there's just like some random person watching us? That doesn't bother you?"];
			}
			tree[17] = [50];

			tree[20] = ["I think\nthey're for\nAbra"];
			if (count > 0)
			{
				tree[21] = ["#luca07#Yeahhhhhh but didn't we see Heracross messing with these? What, do you think he's like Abra's maintenance person or something?"];
			}
			else
			{
				tree[21] = ["#luca07#Yeahhhhhh okay, I guess that makes sense. ...Probably for some stuff related to the game. Like, maybe other people are playing?"];
			}
			tree[22] = [50];

			tree[25] = ["I think\nthey're for\nHeracross"];
			tree[26] = ["#luca08#Ohhhhhhhhh you think Heracross put them in? ...But isn't this Abra's house? That doesn't make a lot of sense."];
			tree[27] = ["#luca07#I meeeeeeeean, would you let someone else install cameras all over the inside of your house?"];
			tree[28] = [50];

			tree[30] = ["I don't\nknow"];
			tree[31] = ["#luca07#Yeah kyehhhhhhhhh, I don't know what all these different cameras are for but I'm getting kind of a \"Saw\" vibe off of them... -shudders-"];
			tree[32] = [50];

			tree[35] = ["I didn't\nrealize\nthere were\nother\ncameras"];
			tree[36] = ["#luca07#Oh right, I guess you can't exactly look around. ...Well, there are cameras like... All over this house."];
			tree[37] = ["#luca06#I wouldn't usually care except, well, I'm naked, and we're about to do some pretty private stuff."];
			tree[38] = [50];

			tree[50] = ["%fun-alpha1%"];
			tree[51] = ["#luca04#Well the battery's out, so now we don't need to worry about it."];
			tree[52] = ["#luca10#...I don't know how the other Pokemon all deal with this stuff buzzing around their heads! It's like they're living in a weird science experiment..."];

			tree[10000] = ["%fun-alpha1%"];
		}
		else if (count % 4 == 1)
		{
			tree[0] = ["#luca06#Soooooooo have you had any other visitors? Seems like sort of the ehhh... Seems like, kyehhhh..."];
			tree[1] = ["%enterhera%"];
			tree[2] = ["#luca12#Heracross, do you mind? We're sort of in the middle of a whole thing here."];
			tree[3] = ["%proxyhera%fun-alpha0%"];
			tree[4] = ["#hera06#I'll just be a second! I just need to replace a battery in the ehhh.... smoke detector..."];
			tree[5] = ["#luca07#... ..."];
			tree[6] = ["#luca06#Sooooooooo I guess I'm just supposed to pretend that's not like, clearly a video camera?"];
			tree[7] = ["#luca10#I've seen those kinds of cameras before, I know what th-"];
			tree[8] = ["#hera02#-Bebebebebebeeeeeeeep! ...Oh! Oh no! I set the smoke detector off. ...Well, at least that means it's working now!"];
			tree[9] = ["%proxyhera%fun-alpha1%"];
			tree[10] = ["#luca12#Kkkkkkkkkh, look, I know you're filming me for the game sooooooooo... Can't you just be up front about it? You don't have to lie to me..."];
			tree[11] = ["#hera03#I don't know what you mean! Gweh-heheheheh. ...Oh, and if you end up doing any fun stuff later, remember to open your body towards the smoke detector."];
			tree[12] = ["%exithera%"];
			tree[13] = ["#hera02#...You know, for smoke safety!"];
			tree[14] = ["#luca06#... ... ..."];
			tree[15] = ["#luca12#Nevermind <name>, I think I understand why you don't get too many other visitors here."];
		}
		else
		{
			tree[0] = ["#luca12#Kyahhhhh, that annoying little camera's doing its thing again..."];
			tree[1] = ["#luca06#...Oh well, I guess I'll just try to ignore it. If Heracross catches me taking out more of his batteries, I'll probably wake up in some creepy sex dungeon..."];

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 1, "his batteries", "her batteries");
			}
		}
	}

	public static function random22(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("luca.randomChats.2.2");

		if (count % 3 == 0)
		{
			tree[0] = ["#luca06#So have you had any other visitors lately, or am I the only one? Because it seems like I always see the same five or six people here..."];
			tree[1] = ["#luca04#...Except every once in a looooooong while, there'll be an odd one or two I don't recognize."];
			tree[2] = [10];

			tree[10] = ["Hmm,\njust the\nusual"];
			tree[11] = [100];

			tree[15] = ["There are\na whole\nbunch\nI don't\nrecognize"];
			tree[16] = ["#luca10#Oh really? I guess maybe it's just because I always come around the same time, so I see the same people."];
			tree[17] = [102];

			tree[20] = ["Not really,\nunless\nyou count\nSmeargle\nand Kecleon"];
			tree[21] = ["#luca06#Nooooooooo, I see them all the time. I was already counting them."];
			tree[22] = ["#luca10#But isn't that kind of weird? I mean... I'd think if Abra wanted his game to be really popular he'd invite all the Pokemon he could find."];
			tree[23] = [101];

			tree[25] = ["I saw\nRhydon,\nbut he's\nusually\nhere"];
			tree[26] = ["#luca06#Nooooooooo, I see him all the time. I was already counting him."];
			tree[27] = [22];

			tree[30] = ["Magnezone\nwas here\nearlier"];
			tree[31] = ["#luca07#Hmmmm yeaaaaaah, okay. Well I guess that's something."];
			tree[32] = [22];

			tree[35] = ["Grimer\nwas here\nearlier"];
			tree[36] = [31];

			tree[40] = ["I don't\nknow, I\nhaven't\nbeen here\nvery long"];
			tree[41] = [16];

			if (PlayerData.hasMet("smea")) { tree[2].push(20); }
			if (PlayerData.hasMet("rhyd")) { tree[2].push(25); }
			if (PlayerData.hasMet("magn")) { tree[2].push(30); }
			if (PlayerData.hasMet("grim")) { tree[2].push(35); }
			if (tree[2].length == 1) { tree[2].push(15); tree[2].push(40);  }

			tree[100] = ["#luca10#Hmm, yeah. Isn't that kind of weird? I mean... I'd think if Abra wanted his game to be really popular he'd invite all the pokemon he could find."];
			tree[101] = ["#luca06#I mean, unless I guess there's some reason he wants to keep this whole game thing kind of secret."];
			tree[102] = ["#luca04#Oh well, I just thought it was kind of weird~"];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 22, "his game", "her game");
				DialogTree.replace(tree, 22, "he'd invite", "she'd invite");
				DialogTree.replace(tree, 22, "he could", "she could");
				DialogTree.replace(tree, 100, "his game", "her game");
				DialogTree.replace(tree, 100, "he'd invite", "she'd invite");
				DialogTree.replace(tree, 100, "he could", "she could");
				DialogTree.replace(tree, 101, "he wants", "she wants");
			}
			if (!PlayerData.rhydMale)
			{
				DialogTree.replace(tree, 25, "but he's", "but she's");
				DialogTree.replace(tree, 26, "see him", "see her");
				DialogTree.replace(tree, 27, "counting him", "counting her");
			}
		}
		else
		{
			tree[0] = ["#luca04#Soooooooo have you had any other visitors? Seems like sort of the same faces I usually see..."];
			tree[1] = ["#luca02#...Sorry, you don't need to answer that. I'm just being nosy!"];
		}
	}

	/**
	 * For Lucario's first time, the main screen just looks like regular non-lucario professors...
	 */
	public static function isLucariosFirstTime():Bool
	{
		if (PlayerData.luckyProfSchedules[0] != PlayerData.PROF_PREFIXES.indexOf("luca"))
		{
			// not lucario...
			return false;
		}
		if (PlayerData.lucaChats[0] != 0)
		{
			// not first time...
			return false;
		}
		return true;
	}

	public static function getLucarioReplacementProfPrefix():String
	{
		var professorInt:Int = PlayerData.professors[PlayerData.getDifficultyInt()];
		return PlayerData.PROF_PREFIXES[professorInt];
	}

	public static function getLucarioReplacementName():String
	{
		var professorInt:Int = PlayerData.professors[PlayerData.getDifficultyInt()];
		return PlayerData.PROF_NAMES[professorInt];
	}

	public static function denDialog(sexyState:LucarioSexyState = null, victory:Bool = false):DenDialog
	{
		var denDialog:DenDialog = new DenDialog();

		denDialog.setGameGreeting([
			"#luca03#Oh, <name>! ...Yeahhhhh, I know I said I was going back to work but... Well, I didn't do that. Kyeheheheheh~",
			"#luca02#Hey! This means we can do more stuff, riiiiiiight? Umm, so Abra's got <minigame> set up. I guess now's as good a time as any!"
		]);

		denDialog.setSexGreeting([
			"#luca04#Well, kyahhhh... As long as I'm going to be late getting back to the store, I may as well be reeeeeeeeeeally late.",
			"#luca02#I mean what's the worst they can do right? It's not like they're going to fire me, just because I, hmmmm... ... ...",
			"#luca10#... ...",
			"#luca07#Wellllllll maybe we should make this one a little quick.",
		]);

		denDialog.addRepeatSexGreeting([
			"#luca02#Oh wowww what is this, some kind of Lucario holiday? Kyahahaha~",
			"#luca00#I better mark my calendar so I don't miss the next one! I just... kyehhh... you spoil me sometimes, <name>~",
		]);
		if (PlayerData.gender == PlayerData.Gender.Complicated)
		{
			denDialog.addRepeatSexGreeting([
				"#luca07#Waaaaaaaait a minute, I know what you're doing... I saw a movie like this once.",
				"#luca06#It was a movie where this one person invited this " + (PlayerData.lucaMale ? "guy" : "girl") + " to their place, and they had sex over and over...",
				"#luca05#Hmmm nevermind, I think that was just a porno movie.",
			]);
		}
		else if (PlayerData.gender == PlayerData.Gender.Boy)
		{
			denDialog.addRepeatSexGreeting([
				"#luca07#Waaaaaaaait a minute, I know what you're doing... I saw a movie like this once.",
				"#luca06#It was a movie where this one guy invited this " + (PlayerData.lucaMale ? "other guy" : "girl") + " over to his place, and they had sex over and over...",
				"#luca05#Hmmm nevermind, I think that was just a porno movie.",
			]);
		}
		else if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			denDialog.addRepeatSexGreeting([
				"#luca07#Waaaaaaaait a minute, I know what you're doing... I saw a movie like this once.",
				"#luca06#It was a movie where this one girl invited this " + (PlayerData.lucaMale ? "guy" : "other girl") + " over to her place, and they had sex over and over...",
				"#luca05#Hmmm nevermind, I think that was just a porno movie.",
			]);
		}
		denDialog.addRepeatSexGreeting([
			"#luca02#Kyahh? Really? Ready to go again?",
			"#luca00#Well alllllllllright! If you say so, let's do it~",
		]);
		denDialog.addRepeatSexGreeting([
			"#luca01#Ohhhhh my goood... I feel like... kyehhhhh... ...",
			"#luca00#You know how sometimes you have like, a shampoo bottle... and it feels like it's almost totally empty, and you can't get any more out...",
			"#luca06#But then when you turn it upside-down it's like... Oh! There's still a little left at the bottom.",
			"#luca10#... ...",
			"#luca07#I'm not saying you HAAAAAVE to, it's just an idea!!!",
		]);
		denDialog.addRepeatSexGreeting([
			"#luca03#Kyeheheheheh! Best day ever? Or... bestest day ever?",
			"#luca00#<name>, you have noooooooo idea how happy I am right now... ...Why can't we do this, like, every day!?",
		]);

		denDialog.setTooManyGames([
			"#luca02#Ooookay, okay, that's enough for me. I reeeeeally gotta get back to work before they bring Abra up on kidnapping charges or something. Kyeheheh~",
			"#luca07#...Although hmmmm, you know it wouldn't be the worrrrrrrst thing if Abra were to disappear for ohhhh, maybe five to ten years?",
			"#luca09#Wait, no, nevermind. That's... That's not a productive line of discussion. Forget I said anything.",
			"#luca05#...But anyway, thanks for playing with me today, <name>. ...I think I'm finally starting to get the hang of this game!",
		]);
		denDialog.setTooManyGames([
			"#luca07#Phew, this was fun but I think I need to take a break for awhile.",
			"#luca06#I don't know how you do this stuff all day! ...It feels like my brain was turning to pudding after just two games.",
			"#luca04#Well, we'll have a rematch soon okay? ...Thanks for playing with me today! It's nice to do stuff other than, well... ...",
			"#luca01#...It's just nice to do stuff~",
		]);

		denDialog.setTooMuchSex([
			"#luca01#Kyahhh... Wow... Well, I think that's it for me today...",
			"#luca00#For the first time in... I think my entire life... I've just had too much sex in one day. I can't... I can't keep up anymore.",
			"#luca02#...Can I ummmm, take a rain check maybe? I liked all this attention today, though! I'll be back again soon~",
		]);
		denDialog.setTooMuchSex([
			"#luca01#Kyehhhhhhh, I think... I think I'm done. Oohhh, just... wow...",
			"#luca02#How do you keep going for so long? You're like... you're like a little... little sex machine or something!",
			"#luca10#But I mean, you're not... you're not actually just a machine right? You seem pretty ummm... you don't seem like a machine.",
			"#luca05#Kyahhh, whatever. You're fun either way. ...I'll be back after I recharge my lucario batteries, <name>~",
		]);

		denDialog.addReplayMinigame([
			"#luca05#Is thaaaaaaaaaaat how you're supposed to do it! ...I think I'm starting to understand.",
			"#luca04#Maybe just... ten more games, and I'll be as good as you are! ...Or maybe twenty. Orrrrrrr, did you want to do something else?",
		],[
			"Ten more\ngames!",
			"#luca03#Kyahaha! Okay. Best out of ummm... what is that, best of nineteen!? I can math~",
		],[
			"Maybe\nsomething\nelse",
			"#luca00#Something else, hmmm? Kyehhhhhh... whatever could you have in mind?",
			"#luca01#...Because I know a good cooperative game for two players! I wonder if that's what you're thinking of... Kyahahaha~",
		],[
			"I need\nto go,\nactually",
			"#luca08#Yeahhhhhhh you and me both! I don't know what I was thinking, staying here so late...",
			"#luca05#I'll see you around, <name>! ...It was good getting to spend some extra time with you today~",
		]);
		denDialog.addReplayMinigame([
			"#luca02#Well that was fuuuuuun! ...World championships, here we come! Kyeheheheh~",
			"#luca00#Sooooo are we done here? 'Cause I can play again, although I'm starting to get in the mood for mmmmm... Maybe something a little more physical...",
		],[
			"Let's play\nagain!",
			"#luca00#Kyahaha, okay okay. I'll be a good sport. Although I'm starting to think you just keep me around so you can beat me at these silly games...",
			"#luca00#...You know I, like, never get to practice these, right!?",
		],[
			"More\nphysical?",
			"#luca01#You knowwwwwwwwwww! I mean we're back here, we're all alooooooooone...",
			"#luca00#Whaaaat, do I really have to spell it out? Kyahaha~",
		],[
			"I have\nto go",
			"#luca08#Yeahhhhhhh you and me both! I don't know what I was thinking, staying here so late...",
			"#luca05#I'll see you around, <name>! ...It was good getting to spend some extra time with you today~",
		]);
		denDialog.addReplayMinigame([
			"#luca04#Kyahhh! Well plaaaaaaaaayed. Wow! I don't know how you're so good at this. How much have you been practicing!?!",
			"#luca10#Should we try again? I wouldn't mind a rematch now that I'm starting to understand the rules. Or we couuuuuld, you know...",
		],[
			"Rematch!",
			"#luca03#Kyeheheh I was hoping you'd say that! ... ...Okay, this one's for real!"
		],[
			"We could...\nwhat?",
			"#luca14#Ohhh you knowwwwwww! You could help me with my, ummmm... some " + (PlayerData.lucaMale?"boy":"girl") + " stuff I have to take care of...",
			"#luca00#You know what, why don't you come over here and I'll show you. It's a lot easier to explain if we're both sitting on the floor~",
		],[
			"Actually\nI should\nrun",
			"#luca08#Yeahhhhhhh you and me both! I don't know what I was thinking, staying here so late...",
			"#luca05#I'll see you around, <name>! ...It was good getting to spend some extra time with you today~",
		]);

		denDialog.addReplaySex([
			"#luca10#Waaaaait, wasn't today a work day? I feel like I'm forgetting something... ...",
			"#luca03#...Ehh, whatever! I'm going to go get something to drink. ...You still have time for more, right?",
		],[
			"I always\nhave time\nfor you,\nLucario~",
			"#luca00#Kyahahahaha! Awwwwww, <name>. That's such a cheesy thing to say~",
			"#luca02#...Wellllll, keep my seat warm while I run and get some water, okay! ...I'll be right back.",
		],[
			"Actually,\nI should\ngo",
			"#luca05#Oh yeah! Ummm... me too! I was just... ... nevermind!",
			"#luca04#Thanks for keeping me company for so long! You're a good friend, <name>. ...I hope we can do this again soon~",
		]);
		denDialog.addReplaySex([
			"#luca00#Ngggghhhh, so gooooooood... I never want to leave this roooooom...",
			"#luca09#Although hmmmm, I kiiiiiiinda gotta use the bathroom... Are you, umm... You're going to stick around, right?",
		],[
			"I'll stick\naround!",
			"#luca02#Yesssss! Well I'll be back in, ummmm... How long does it take me to pee!?! I don't know! ...Maybe you can time me.",
			"#luca10#...No, nevermind, that's... that's kind of weird. Do NOT time me while I pee!",
			"#luca04#I'll umm, I'll just be back in a little bit, okay?",
		],[
			"I should\nhead out",
			"#luca08#Oh yeah! Ummm... me too! I was just... ... nevermind!",
			"#luca04#Thanks for keeping me company for so long! You're a good friend, <name>. ...I hope we can do this again soon~",
		]);
		denDialog.addReplaySex([
			"#luca14#That was fun but... ooogh, reeeeally messy. I'm deeeeeefinitely going to need to take a shower before I go back.",
			"#luca06#...All these cameras kiiiiind of creep me out. ...Do you think there are any showers here that don't have cameras pointed in them? Kyehh...",
			"#luca05#It would suck if I needed to go home to shower. ...Can you wait a few minutes while I snoop around?",
		],[
			"Yeah! I\ncan wait",
			"#luca02#Oh good! I wasn't trying to make things weird. I just don't like these cameras looking at me while I'm... you know... ...",
			"#luca04#Well, I'll be back in a minute okay! ...Just wait there!",
		],[
			"I should\ngo...",
			"#luca08#Oh yeah! Ummm... me too! I was just, ummm... ...it's probably better if I just go home.",
			"#luca04#Thanks for keeping me company for so long! You're a good friend, <name>. ...I hope we can do this again soon~",
		]);

		return denDialog;
	}

	public static function cursorSmell(tree:Array<Array<Object>>, sexyState:LucarioSexyState)
	{
		var count:Int = PlayerData.recentChatCount("luca.cursorSmell");

		if (count == 0)
		{
			tree[0] = ["#luca02#Mmmmm so what's next, " + stretch(PlayerData.name) + "? -sniff- ...You ready to do some, ehhh... -sniff -sniff-"];
			tree[1] = ["#luca09#...Wait, something reeeeeally stinks... -sniff- ...Ulkkkkhhh, is that... -sniff- -sniff- Is that coming from you!?!"];
			tree[2] = ["#luca07#What did you do!?! It's... -hurk- Oh my god. It's... -gag- it's even worse than that time I had to clean the grease trap..."];
			tree[3] = ["%fun-mediumbreak%"];
			tree[4] = ["#luca09#I... I think I might throw up. ...I'm just... ...going to step outside for a minute to collect myself."];
			tree[5] = ["#luca08#... ...I'll be back but... if there's anything, ANYTHING you can do about that smell I'd reeeeeeally appreciate it... Ulkkkhhh..."];

			tree[10000] = ["%fun-mediumbreak%"];
		}
		else
		{
			tree[0] = ["#luca04#Mmmmmmmm well this has been nice hasn't it?"];
			tree[1] = ["#luca02#Now remember, if you're ehhh... -sniff- Kyehhh, that... that couldn't be... -sniff- -sniff-"];
			tree[2] = ["#luca02#Oh god, it IS! -sniff- Ulkkkkkkkh, I think it's even WORSE this time. " + stretch(PlayerData.name) + "!!!"];
			tree[3] = ["#luca02#What... I mean, what's causing that horrible odor? Is it something you're doing!? Something you're not doing!?"];
			tree[5] = ["#luca02#Whatever it is that you need to do or not do... you need to do or not do it because this is unbearable. -hurk-"];
			tree[4] = ["%fun-mediumbreak%"];
			tree[6] = ["#luca02#...I'll... I'll be right back..."];

			tree[10000] = ["%fun-mediumbreak%"];
		}
	}
}