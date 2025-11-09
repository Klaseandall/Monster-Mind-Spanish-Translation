package poke.hera;

import MmStringTools.*;
import PlayerData.hasMet;
import critter.Critter;
import flixel.FlxG;
import minigame.tug.TugGameState;
import poke.magn.MagnDialog;
import openfl.utils.Object;
import minigame.GameDialog;
import minigame.MinigameState;
import minigame.scale.ScaleGameState;
import minigame.stair.StairGameState;
import puzzle.ClueDialog;
import puzzle.PuzzleState;
import puzzle.RankTracker;

/**
 * Heracross is canonically male. Heracross runs a shop in Abra's basement.
 * 
 * Heracross gouges the player for money so that the player will stick around
 * to solve more puzzles, and buy more items from the shop. He knows if the
 * player buys every last item, he will have no reason to keep playing the game.
 * 
 * Heracross is single and he is sometimes nervous about where his life is
 * headed if he continues being single as he grows older. But he tries not to
 * obsess over it.
 * 
 * Heracross has a tendency to develop a crush on anybody who shoots him the
 * slightest glimmer of attention, including the player.
 * 
 * After playing a minigame, Heracross will let people into his backroom where
 * they can practice that minigame with the last Pokemon they played with. He
 * will usually charge about $200, but if you want to play with Heracross, he
 * will charge you almost nothing.
 * 
 * Heracross wanted to be a part of the puzzle-solving stuff to spend more time
 * with the player, but Abra required him to get familiar with the puzzles
 * first. Heracross studied the puzzles extensively, and is now incredibly
 * skilled at them. With a whopping rank of 42, he is the most talented puzzle
 * solver than Abra himself.
 * 
 * Heracross was responsible for installing cameras throughout Abra's house
 * (with Abra's blessing.)
 * 
 * As far as the shop goes, Heracross's prices fluctuate. Each item has a base
 * price, so some items such as the insulated gloves are naturally very cheap
 * (about $150) and others such as the big red dildo are very expensive (about
 * $6,000).
 * 
 * As the player solves puzzles, additional items will become available in the
 * shop. He will only ever sell five items at once, because that is all that
 * can fit on his table.
 * 
 * If his shop is ever full, he will put two of them on "sale" -- one for very
 * very expensive, and one for very very cheap. If the player does not purchase
 * the items, they will go back into his stockroom.
 * 
 * As far as minigames go, Heracross practiced the minigames extensively,
 * particularly the scale game as he could practice it alone. With the scale
 * game in particular, it takes him a moment to parse the numbers but after
 * that initial delay he is incredibly fast at coming up with a solution. He is
 * awful at the stair game, it is possible his empathy with the bugs prevents
 * him from playing optimally... ...
 * 
 * ---
 * 
 * When writing dialog, I think it's good to have an inner voice in your head
 * for each character so that they behave and speak consistently. Heracross's
 * inner voice was a combination of Magic Man from Adventure Time, and Butters
 * from South Park.
 * 
 * Vocal tics:
 *  - Wowee! Gosh! Gweh-heh-heh! Yay! Yippee! Heracroosss!
 *  - Gwuhh... Err... Ehh...
 *  - Hey! Gwehhh! Gwehhh...
 *  - Oh my days! Oh my word! Oh my goodness gracious! Oh my land! What in the f-... funny business!?
 *  - Uses your name a lot
 * 
 * Exceptional at puzzles (rank 42)
 */
class HeraDialog
{
	public static var prefix:String = "hera";
	public static var sexyBeforeChats:Array<Dynamic> = [sexyBefore0, sexyBefore1, sexyBefore2, sexyBefore3, sexyBefore4];
	public static var sexyAfterChats:Array<Dynamic> = [sexyAfter0, sexyAfter1, sexyAfter2];
	public static var sexyBeforeBad:Array<Dynamic> = [sexyBadPremature0, sexyBadPremature1, sexyBadPremature2];
	public static var sexyAfterGood:Array<Dynamic> = [sexyAfterGood0, sexyAfterGood1];
	public static var fixedChats:Array<Dynamic> = [finallyMeet, agingAlone];
	public static var randomChats:Array<Array<Dynamic>> = [
				[random00, random01, random02, random03],
				[random10, random11, random12, random13],
				[random20, random21, random22, random23]
			];

	public static function getUnlockedChats():Map<String, Bool>
	{
		var unlockedChats:Map<String, Bool> = new Map<String, Bool>();
		unlockedChats["hera.randomChats.2.3"] = hasMet("grim") && hasMet("sand");
		return unlockedChats;
	}

	public static function clueBad(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var swears:Array<String> = [
									   "Aww clodknobbers!",
									   "Ohh fiddle faddle!",
									   "Aww dishwashers!",
									   "Aww seabiscuit!",
									   "Aww fish whiskers!",
									   "Ohh space needles!",
									   "Ohh scrodwaddle!",
								   ];
		var swear:String = FlxG.random.getObject(swears);

		var clueDialog:ClueDialog = new ClueDialog(tree, puzzleState);
		clueDialog.setGreetings([
									"#hera09#Oh, Abra explained this to me! You've got a small mistake in the <first clue>, don't you?",
									"#hera09#Oh no! You made a teeny-tiny mistake with the <first clue>! Do you see it?",
									"#hera09#Ack! I see it now, that <first clue> doesn't really fit your answer. Do you get what's wrong?",
								]);
		if (clueDialog.actualCount > clueDialog.expectedCount)
		{
			if (clueDialog.expectedCount == 0)
			{
				clueDialog.pushExplanation("#hera04#" + swear + " So that <first clue> has <e hearts> next to it. None at all, right? So if you look at your answer...");
			}
			else
			{
				clueDialog.pushExplanation("#hera04#" + swear + " So that <first clue> has <e hearts> next to it. Just <e>, right? So if you look at your answer...");
			}
			clueDialog.pushExplanation("#hera06#Your answer should likewise have <e> <bugs in the correct position>... But you've got a whopping <a>! Aaaagh! That's way too much!");
			clueDialog.pushExplanation("#hera05#It's okay, we can fix it! We just have to mess with your answer until there's <e bugs in the correct position>. Hmm! Tricky right?");
		}
		else
		{
			clueDialog.pushExplanation("#hera04#"+swear+" So that <first clue> has <e hearts> next to it. A whopping <e>, right? So if you look at your answer...");
			clueDialog.pushExplanation("#hera06#Your answer should likewise have <e bugs in the correct position>... But you've got a mere <a>! Aaagh! That's not even close too enough!");
			clueDialog.pushExplanation("#hera05#It's okay, we can fix it! We just have to mess with your answer until there's <e bugs in the correct position>. Hmm! Tricky right?");
		}
	}

	static private function newHelpDialog(tree:Array<Array<Object>>, puzzleState:PuzzleState, minigame:Bool=false):HelpDialog
	{
		var helpDialog:HelpDialog = new HelpDialog(tree, puzzleState);
		helpDialog.greetings = [
			"#hera04#Oh hello <name>! ...Did you need some help?",
			"#hera04#Aww are you having some kind of trouble?",
			"#hera04#Oh! What can I do? Did you need something?",
			"#hera04#Hello <name>! Was there something you needed?",
		];

		helpDialog.goodbyes = [
			"#hera08#Ohhhhhh! ...Okay ...I hope I get to see you again soon!",
			"#hera08#Ohhhh toaster strudels! ...I knew it was too good to be true...",
			"#hera08#Aww zagnut! ...I was really looking forward to our time together, too...",
			"#hera08#" + stretch(PlayerData.name) + "! ...You're breaking my heart a little! You won't forget about me will you?",
		];

		helpDialog.neverminds = [
			"#hera05#Hmmm? Oh, okay! Now where were we...",
			"#hera02#Gweheheheh! Any excuse to talk to your little bug buddy, is that it?",
			"#hera05#Gweh! ...We all have those days. Now let's see...",
			"#hera06#Gweh? ...Oh, okay! Ehh, yeah!",
		];

		helpDialog.hints = [
			"#hera05#Ehh? Oh, sure! Let me run and get Abra. I'll be right back! ...Don't go anywhere!!",
			"#hera05#Oh, okay you need a hint? Okay! Okay! Abra told me I shouldn't help you directly, so... Let's see... Where's Abra...",
			"#hera05#Ohhh a hint? A hint! I know how to get a hint! ...Wait right there, okay? I'll be so fast!",
		];

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

	public static function gameDialog(gameStateClass:Class<MinigameState>):GameDialog
	{
		var manColor:String = Critter.CRITTER_COLORS[0].english;
		var comColor:String = Critter.CRITTER_COLORS[1].english;

		var g:GameDialog = new GameDialog(gameStateClass);

		g.addSkipMinigame(["#hera08#Aww shucksaroo! I was looking forward to a little game with my <name> friend.", "#hera01#Hmm well you know... There's more than one way to whet my <name>-tite. Gweh-heh-heh!"]);
		g.addSkipMinigame(["#hera09#Aww really? It's such a nifty little game!", "#hera05#And I was gonna let you win, and you were gonna be all happy and then... Well, can you guess what I was going to do next?", "#hera01#...Maybe I'll just show you! Gweh-heh-heh~"]);

		g.addRemoteExplanationHandoff("#hera04#I've only played this one a few times. Let me see if <leader> wants to explain this one for us!");

		g.addLocalExplanationHandoff("#hera04#You've played this one a few times, haven't you <leader>? ...Can you go over the rules for us again?");

		g.addPostTutorialGameStart("#hera06#Well! Does that make sense to you? Are you ready to start?");

		g.addIllSitOut("#hera06#Oooh, on second thought I'm not sure if you're ready for the full Heracross experience yet. Why don't you play without me.");
		g.addIllSitOut("#hera06#Well hold on a moment, how familiar ARE you with this game? ...Maybe you should get in some practice first.");

		g.addFineIllPlay("#hera02#Gweh-heh-heh! You'll have second thoughts NEXT time. It's time to teach you a lesson~");
		g.addFineIllPlay("#hera02#What, you thought I was bluffing? I'm a total whiz at these sorts of puzzles. I hope you brought your A-brain!");

		g.addGameAnnouncement("#hera02#Oooh fun! It's <minigame>, I haven't seen this one very much.");
		g.addGameAnnouncement("#hera03#Oh, I think I heard about this one! It's <minigame>, isn't it?");

		g.addGameStartQuery("#hera04#Are you ready to start?");
		g.addGameStartQuery("#hera04#Let's start! You remember the rules, right?");
		if (PlayerData.denGameCount == 0)
		{
			g.addGameStartQuery("#hera04#Here we go! Are you ready?");
		}
		else {
			g.addGameStartQuery("#hera04#Ooooh a remaaaaatch! I'll spend all day playing games with you, " + stretch(PlayerData.name) + "~. Are you ready?");
		}

		g.addRoundStart("#hera04#Are you ready?", ["No, I'm like not ready\nat ALL, please don't start", "Yep", "Mmmm... sure"]);
		g.addRoundStart("#hera02#Round <round>! You ready to lose? Heracrooooossss!!", ["Don't under-\nestimate me!", "Are you ready to...\nshut up? Hmph!", "Heh heh!\nLet's go"]);
		g.addRoundStart("#hera05#I guess it's time for round <round>!", ["Go go go!", "Just a\nmoment...", "Sure, I'm\nready"]);
		g.addRoundStart("#hera05#Time for round <round>! This is all just math. Math is easy isn't it?", ["Sure! Math\nis easy", "I have a tough\ntime with math", "This is more than\njust math!"]);

		g.addRoundWin("#hera02#Gweh-heh-heh-heh! Don't look so surprised... I AM part lightning bug, you know!", ["...Next round!\nNext round!", "You big\nliar!", "Where's my fly\nswatter..."]);
		g.addRoundWin("#hera03#I don't know why I'm trying so hard! All these gems are going in my pocket one way or the other...", ["I'm boycotting your\nstore after this!", "Those gems are mine,\nyou annoying bug!", "I just need\nto add faster..."]);
		g.addRoundWin("#hera03#Too fast! Too fast. Gweh-heh-heh-heh! Who is this bug? Who invited him to our game?", ["You're getting\ncocky, Heracross!", "I can be\nfast too!", "Sheesh..."]);
		if (gameStateClass != StairGameState) g.addRoundWin("#hera03#...And that was even with one hand behind my back! Gweh-heh-heh-heh!!", ["Hey, I don't even\nhave two hands!", "...And I\nstill lost?", "Bleah,\nscrew this"]);

		if (gameStateClass == ScaleGameState) g.addRoundLose("#hera10#Gwuh? You finished that one so fast, <leader>!! Had you seen that one before?", ["Don't be a\npoor sport", "<leaderHe's> a fierce\ncompetitor, huh?|Keep practicing,\nlittle buddy", "Yeah, something's\nfishy...|It seemed\nfamiliar..."]);
		if (gameStateClass == TugGameState) g.addRoundLose("#hera10#Gwuh? You move everything so fast, <leader>!! ...How many times have you played this!?", ["Don't be a\npoor sport", "<leaderHe's> a fierce\ncompetitor, huh?|Keep practicing,\nlittle buddy", "Way too\nmuch...|Oh, a couple\nof times..."]);
		g.addRoundLose("#hera12#Hey <leader>, I LIKE this game! ...You're not even letting me play!", ["Yeah, slow down\n<leader>! Let us play|Hey don't hate\nthe player", "Speed is the\nname of the game|Heh heh c'mon,\nkeep up", "Ugh, gotta\ngo faster...|Alright, I'll go\neasy on you"]);
		g.addRoundLose("#hera07#Good gravy! Is THAT how you're supposed to play this game?", ["Let's just do\nwhat <leaderhe's> doing|Now you\nknow", "If you can't keep\nup, don't step up", "Oougghh...|Heh heh!"]);

		g.addLosing("#hera06#Tsk, you're not winning by THAT much, <leader>. I usually win by WAY more than that~", ["Do you want us to\nlose by even more!?|Oh you want me\nto win by more?", "<leaderHe's> really good, isn't <leaderhe>...|I was going\neasy on you...", "Ha ha, I\nbet you do"]);
		if (gameStateClass == ScaleGameState) g.addLosing("#hera11#Are you playing fair, <leader>? ...You're not using a calculator or something are you?", ["Heh heh, I\nbet <leaderhe> is|Oops,\nbusted", "How would a calculator\neven help!?|Bitch, I AM a\ncalculator", "<leaderHe's> not\nplaying fair...|Heh, I'm\nplaying fair"]);
		g.addLosing("#hera09#Aww stinkbugs! I really thought I might win this time...", ["Wasn't stinkbugs your\nnickname in high school?", "We'll never\nbeat <leaderhim>...|You'll never\nbeat me", "Aww, you're\npretty close"]);
		if (gameStateClass == ScaleGameState) g.addLosing("#hera12#These puzzles are too easy! If we had nine or ten bugs... THEN I'd show you how it's done!", ["If they're too easy,\nsolve them faster", "Don't give\nAbra ideas!!", "These are already\nhard enough..."]);
		if (gameStateClass == ScaleGameState) g.addLosing("#hera11#I thought these bugs were my friends... Why aren't they whispering me the answers?", ["Really? ...They're\nwhispering to me", "Stop trying\nto cheat!", "Aww, you're MY bug\nfriend, Heracross~"]);
		if (gameStateClass != ScaleGameState) g.addLosing("#hera11#I thought these bugs were my friends... Why aren't they helping me win?", ["Really? ...They're\nhelping me win", "Stop trying\nto cheat!", "Aww, you're MY bug\nfriend, Heracross~"]);
		g.addLosing("#hera12#Tsk, I think I've decided I'm morally opposed to this game. We shouldn't be using bugs as toys!", ["Aww, I thought\nyou might like\nbeing my toy~", "...Not\njust 'cause\nyou're losing?", "Heh,\ndon't be a\npoor sport"]);

		if (gameStateClass == ScaleGameState || gameStateClass == TugGameState) g.addWinning("#hera03#Ohhh you sweet little thing! You thought you had a chance~", ["How are you\nso fast!?", "I do have a chance,\nyou arrogant insect", "This is the\nworst..."]);
		if (gameStateClass != ScaleGameState) g.addWinning("#hera03#Ohhh you sweet little thing! You thought you had a chance~", ["How are you\nso good!?", "I do have a chance,\nyou arrogant insect", "This is the\nworst..."]);
		if (gameStateClass == ScaleGameState) g.addWinning("#hera06#If you need help <name>, I sometimes sell calculators at my store...", ["I don't need a\ncalculator to beat you", "I should really\nbuy one...", "Wait... are you\nusing a calculator!?"]);
		if (gameStateClass == TugGameState) g.addWinning("#hera06#Did you add wrong, <name>? ...You know, I sometimes sell calculators at my store...", ["I don't need a\ncalculator to beat you", "I should really\nbuy one...", "Wait... are you\nusing a calculator!?"]);
		if (gameStateClass == StairGameState || gameStateClass == TugGameState) g.addWinning("#hera06#If you run out of bugs <name>, I sometimes sell bugs at my store...", ["There's no\nway I'll\nrun out!", "I should really\nbuy one...", "Wait... are you\nusing extra bugs!?"]);
		g.addWinning("#hera02#All aboard the Heracross express! Now arriving at its final destination... First place! ...Heracroooossssss!!!", ["Heh heh you're\nso weird", "...Which is it!? \"All aboard\"\nor \"Now arriving\"!?", "Geez just\nshut up"]);
		g.addWinning("#hera06#If I win enough of these games, I can close my store forever! That's right, eliminate the middle man. That's just smart business!", ["Hey don't close your\nstore, that's not fair!", "You'll\nnever win!", "Gwoof..."]);

		g.addPlayerBeatMe(["#hera03#Wowee! You're a fierce little competitor aren't you? Here's your <money>!", "#hera05#I'll be right back! I'm going to go raise all my prices by, oh, about <money> or so. Gweh-heh-heh!", "#hera02#...Just kidding! ...Kind of!"]);
		{
			var playerDescriptor:String;
			if (PlayerData.gender == PlayerData.Gender.Boy)
			{
				playerDescriptor = "big tough little... puzzle man";
			}
			else if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				playerDescriptor = "ferocious little... puzzle lady";
			}
			else {
				playerDescriptor = "big tough little... puzzle person";
			}
			g.addPlayerBeatMe(["#hera03#Whoopsie-doodle! Oh well, can't win 'em all.", "#hera01#Well you're a " + playerDescriptor + ", aren't you! I forgot what it was like to lose~"]);
		}

		var sexy:String = "sexy";
		if (PlayerData.videoStatus == PlayerData.VideoStatus.Clean || PlayerData.pokemonLibido == 1)
		{
			sexy = "cute";
		}
		g.addBeatPlayer(["#hera02#Gweh-heh-heh! It's about time I won one!", "#hera01#Hey don't feel bad. You put up a good fight! Tell you what... Go record a " + sexy + " video for me, and I'll give you a consolation prize~"]);
		g.addBeatPlayer(["#hera02#Yay! Heracroooossss!!! ...Hey you put up a good fight though! Three or four more games, I'll bet you'll be at my level.", "#hera05#This game just takes a little getting used to. You did good!"]);

		g.addShortWeWereBeaten("#hera04#...I've got some great new merchandise you can spend those <money> on, you know~");
		g.addShortWeWereBeaten("#hera06#<nomoney>Aww don't worry about coming out empty-handed! ...Go record a " + sexy + " video for me, and I'll give you a consolation prize~");
		g.addShortWeWereBeaten("#hera04#Hey you did good, <name>! I guess now we know <leader>'s hidden talent don't we?");

		g.addShortPlayerBeatMe("#hera05#If you're looking for a place to spend that <money>.... I DO have a shop! Gweh-heh-heh!");
		g.addShortPlayerBeatMe("#hera03#Hey you did good, <name>! ...Don't let it go to your head! Gweh-heh-heh!");

		g.addStairOddsEvens("#hera05#Let's play a quick game of odds and evens! I'm evens and you're odds. The winner gets to go first, does that sound fair?", ["Yeah,\nlet's go", "Hmm,\nalright!", "I'm odds?"]);
		g.addStairOddsEvens("#hera04#Let's throw odds and evens to see who goes first! You're odds and I'm evens. You ready?", ["Okay,\nlet's go", "So, I\nwant it to\nbe odd?", "Yep!"]);

		g.addStairPlayerStarts("#hera06#Tsk, I lost!? Well going second is no fun. Maybe you can just let me go first anyways? You know, as a friend!", ["I'm just\ngoing to take\nmy turn...", "You cheaty\ninsect!", "Hmm, how\nabout no"]);
		g.addStairPlayerStarts("#hera03#Okey doke, so you get to start. Are you ready for your first roll? I'm not trying to rush you...", ["Yeah,\nI'm ready!", "Yep", "No problem,\nlet's go"]);

		g.addStairComputerStarts("#hera02#Oh, looks like I'll be going first! ...Are you ready? I guess you're rolling for defense!", ["Alright", "Defense?\nYou mean... to\nslow you down?", "I'm ready!"]);
		g.addStairComputerStarts("#hera03#Well, I guess I'll be rolling first! Thank my lucky stars. Are you ready to begin?", ["Hmm,\nsure...", "Yeah!\nLet's start", "Yep"]);

		g.addStairCheat("#hera06#You DO know that's not allowed, don't you? Or were you just testing me? ...You need to throw out your dice sooner than that!", ["Oh, well,\nI was just...", "What? Why isn't\nit allowed?", "Sorry about\nthat!"]);
		g.addStairCheat("#hera06#Tsk, your ruse lacks subtlety! If you're going to try to pull one over on me, you can't wait like five whole seconds before putting your dice out...", ["That wasn't\nfive seconds!", "Okay, I'll\ngo quicker...", "Hmph,\nwhatever"]);

		g.addStairReady("#hera04#Are you ready?", ["I'm\nready", "Yep!", "Think\nso..."]);
		g.addStairReady("#hera05#Next round! Ready?", ["Uh, yeah", "Sure\nthing!", "Yep,\nlet's go..."]);
		g.addStairReady("#hera04#Time to roll!", ["Yeah!\nLet's go", "Let's roll\nthen!", "Okay"]);
		g.addStairReady("#hera05#Ready?", ["Yep", "Okay!", "Hmm..."]);
		g.addStairReady("#hera04#...Ready to roll?", ["Ready\nto roll!", "On three?", "Yeah"]);

		// These "close game" lines include duplicates of some early "win round/lose round" lines; be wary if the third minigame uses both sets of lines
		g.addCloseGame("#hera03#Goodness! We've got a real nail-biter here, don't we? Let me just peek at your dice for a minute.", ["Hey! Keep\nyour eyes on\nyour side", "Hmm, what\nto do...", "How is that\ngoing to help?"]);
		g.addCloseGame("#hera03#I don't know why I'm trying so hard! All these gems are going in my pocket one way or the other...", ["I'm boycotting your\nstore after this!", "Those gems are mine,\nyou annoying bug!", "Hmm, what should\nI roll next...?"]);
		g.addCloseGame("#hera06#Those chests are so tiny! ...Can't I just pick them up with my claws? Why are we making the bugs do all the work?", ["Well,\nthis way's\nmore fun...", "...Do you think\nanybody would\ntell on us?", "Hey, that's\ncheating!"]);
		g.addCloseGame("#hera08#...This minigame seems so violent compared to the others! Can't we just have like, a hugging contest?",
		[PlayerData.heraMale ? "The guy with an\nexoskeleton\nthinks he'll\nwin a hugging\ncontest?" : "The girl with an\nexoskeleton\nthinks she'll\nwin a hugging\ncontest!?",
		"Yay! A\ngame which\neverybody wins!",
		"I can't hug\nwith just one\ndisembodied\nhand..."]);

		g.addStairCapturedHuman("#hera08#Oh! That little " + manColor + " bug is saying something... He's saying... Why <name>? Why are you so awful at this?", ["He didn't\nsay that!", "Lies! Lies\nand slander", "Heh, oh,\nbe quiet..."]);
		g.addStairCapturedHuman("#hera08#Aww, that poor little " + manColor + " bug trusted you, <name>! And you had to put out a silly number like <playerthrow>. ...How do you sleep at night?", ["I feel\nso guilty!", "...It seemed like\na good move?", "It's not\nover 'til\nit's over"]);
		g.addStairCapturedHuman("#hera02#I'll give that brave little " + manColor + " bug a 9.8 for distance! ...But I'm deducting two points for form.", ["C'mon, he\ndid a flip!", "Ha ha ha...\nKer-splat!", "Stop picking\non my bugs!"]);

		g.addStairCapturedComputer("#hera11#Gwehhh! Why are you so cruel to all my little bug friends? ...They just want to play!", ["That's not\ngoing to work\non me...", "Tell 'em to\nstay off my\nstaircase!", "Aww, I'm sorry\nlittle guy"]);
		g.addStairCapturedComputer("#hera12#Hey! ...You keep up that sort of behavior, and you're going to have to sit in the naughty corner~", ["What? What\ndid I do?", "Oooh! Maybe\nwe can be\nnaughty together\nin that corner~", "Aww, I'm just\ntrying to win"]);
		g.addStairCapturedComputer("#hera12#Can I take that move back? That one die just sort of fell out of my claw! I didn't mean to put out <computerthrow>...", ["Heh heh!\nYeah right", "No takebacks!\nC'mon, own\nyour mistakes", "Hmm... You\nwouldn't lie about\nthat, would you?"]);

		return g;
	}

	public static function bonusCoin(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#hera02#Wow! Really? A bonus coin? Eeeeeeeee!! This is my lucky day!!"];
		tree[1] = ["#hera04#I mean, of course it's your lucky day too! ...But... I mean, it's... I get to... ..."];
		tree[2] = ["#hera03#Yayyyy! Let's see what game we get to play together~"];
	}

	public static function finallyMeet(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["#hera03#Oh! <name>? ...You came? You actually came! I'm so happy I might cry~"];
			tree[1] = ["#hera04#Are you... are you surprised? ...Did you know it was me?"];
			tree[2] = [10, 40, 20, 30];

			tree[10] = ["Who are\nyou again?"];
			tree[11] = ["#hera07#... ...Who... Who AM I? WHO AM I!?! ... ...<name>!!!"];
			tree[12] = ["#hera08#..."];
			tree[13] = ["#hera06#Oh, I see what you're doing. ...That's a dangerous game you're playing! What would you do if I took you seriously?"];
			tree[14] = [50];

			tree[20] = ["I figured it\nout when I\nsaw Kecleon\nat the store"];
			tree[21] = ["#hera08#Hmph, I see! Well that sort of sucks the wind out of my surprisey sails~"];
			tree[22] = ["#hera06#Just... just pretend you're surprised anyways! It'll make for a better story later."];
			tree[23] = [50];

			tree[30] = ["The Heracross\nsilhouette\nwas a giveaway"];
			tree[31] = [21];

			tree[40] = ["Heracross?\nWhat are you\ndoing here!"];
			tree[41] = ["#hera03#I know, right? It took a little doing but... I talked Abra into letting me step away from the store so we can spend some time together!"];
			tree[42] = [50];

			tree[50] = ["#hera02#Gah, this is so exciting! ...Go ahead, show me your puzzle-solving technique! I want to see what you can do~"];
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["%fun-nude0%"];
			tree[1] = ["#hera04#So I knew I needed to wear two different things, and I thought about maybe a necktie or button shirt but finally settled on these four-leaf clover boxer shorts!"];
			tree[2] = ["%fun-nude1%"];
			tree[3] = ["#hera02#See? Aren't they adorable?"];
			tree[4] = ["#hera05#...I've been wearing them every day hoping they'd bring me good luck! ...I guess they finally worked~"];
			tree[5] = [30, 40, 20, 10];

			tree[10] = ["You've been\nwearing\nthe same\nunderwear\nevery day?"];
			tree[11] = ["#hera10#...Well, it sounds a little weird and gross when you say it that way!"];
			tree[12] = ["#hera06#I've been wearing the same underwear but... not in a weird and gross way! Just in a fun, casual, anything goes kind of way!"];
			tree[13] = ["#hera05#Just you know, \"Oh there's Heracross! And he's wearing the same lucky underwear for the second week in a row. That's neat!\""];
			tree[14] = ["#hera04#..."];
			tree[15] = ["#hera08#Okay okay, I'll take them off! They are starting to smell a little underweary."];
			tree[16] = ["#hera11#Ahh! Cheese and crackers, I'm trapped in this underwear until you solve this puzzle..."];
			tree[17] = [50];

			tree[20] = ["I can\nkind of\nsee your..."];
			tree[21] = ["#hera01#Ohh I see! Taking a little peek, hmm? Doing a little window shopping?"];
			tree[22] = ["#hera04#...Well! ...I can give you more than a peek! Let me just take these things off and I'll give you a real eyeful..."];
			tree[23] = [16];

			tree[30] = ["You'll have\neven better\nluck if\nyou take\nthem off~"];
			tree[31] = ["#hera01#Aww, <name>! ...You don't have to flirt with me, I'm already smitten with you! We can just skip ahead to the part where we, you know..."];
			tree[32] = ["#hera11#Oh wait, except for these puzzles! ...I knew I was forgetting something."];
			tree[33] = [50];

			tree[40] = ["Aww,\nthey're\nso cute!"];
			tree[41] = ["#hera01#Gweh! Heh-heh-heh! I bought them just so that I could show them off for you but..."];
			tree[42] = ["#hera00#...Now that you're here, all I can really think about is taking them off! ...Mmmmm... <name>..."];
			tree[43] = ["#hera11#Gah, wait a minute!... I'm trapped in my cute underwear until you solve this puzzle! Hmm... hmmm..."];
			tree[44] = [50];

			tree[50] = ["#hera04#Well, you know what to do!"];

			tree[10000] = ["%fun-nude1%"];

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 1, "necktie", "swimsuit");
				DialogTree.replace(tree, 1, "button shirt", "oversized t-shirt");
				DialogTree.replace(tree, 1, "boxer shorts", "panties");
			}
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["#hera05#I'm sure to you it looks like I just showed up randomly! ...But a lot of effort went into this you know."];
			tree[1] = ["#hera04#I had to go out and buy a whole new wardrobe, just so I'd meet Abra's dress code? ...And... I memorized all the rules to these puzzles and minigames..."];
			tree[2] = ["#hera06#...And I had to convince Kecleon to cover for me at the store! I couldn't just leave it empty."];
			tree[3] = ["#hera05#... ...Oh! And I haven't touched myself since, hmm, well... ummm...."];
			tree[4] = ["#hera04#... ... ..."];
			tree[5] = ["#hera11#I just wanted to make sure I'd be ready for you, <name>! Gwehhh! I'm getting jitterbugs~"];
		}
	}

	public static function agingAlone(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["#hera03#Ah! <name>! ...Hello! Hello again! Yay! <name> came! <name> came to visit meeee~"];
			tree[1] = ["#hera06#... ...So, just out of curiosity <name>... Are you single? Not... for personal reasons! Just... Just wondering..."];
			tree[2] = [10, 20, 30, 40];

			tree[10] = ["Yeah, I'm\nsingle"];
			tree[11] = ["#hera04#Yeah, okay! Still looking huh? Hmm..."];
			tree[12] = ["#hera05#Realistically speaking though, where do you see yourself in twenty years? You know, as far as relationshippy family stuff?"];
			tree[13] = ["#hera06#You think you'll settle down? Or you think you'll stay single?"];
			tree[14] = [65, 60, 50, 55];

			tree[20] = ["Actually, I'm\ndating\nsomeone"];
			tree[21] = ["#hera02#Oh that's great! I kind of had a feeling someone like you would have been snatched up already."];
			tree[22] = ["#hera05#...So, how serious is it? Like, realistically speaking, where do you see yourself in 20 years? You know, as far as relationshippy family stuff?"];
			tree[23] = ["#hera06#You think you'll settle down? Or you think you'll sort of keep dating different people?"];
			tree[24] = [65, 75, 50, 55];

			tree[30] = ["Actually, I'm\nengaged"];
			tree[31] = [41];

			tree[40] = ["Actually, I'm\nmarried"];
			tree[41] = ["#hera02#Aww well that's great! ...I think everybody should find somebody. You're very lucky~"];
			tree[42] = [100];

			tree[50] = ["It's safe\nto assume\nI'll be single"];
			tree[51] = ["#hera04#Heh! Yeah, I'm kind of in the same boat you are! I'm single, and I don't mind being single. So I don't really think about the future too much--"];
			tree[52] = [101];

			tree[55] = ["Oh, I'm not\nthinking\nabout that"];
			tree[56] = ["#hera05#Oh sure, well that's just fine! I wasn't trying to put you on the spot or anything. ... ...I hope I didn't overstep any boundaries."];
			tree[57] = [100];

			tree[60] = ["With any\nluck I'll\nbe seeing\nsomeone"];
			tree[61] = [66];

			tree[65] = ["With any\nluck I'll\nbe married"];
			tree[66] = ["#hera04#Yeah! I bet it'll happen. You seem like a, uhh... hmmm..."];
			tree[67] = ["#hera07#Wait, what the heck am I basing this on!? Well, errr..."];
			tree[68] = ["#hera06#I don't know. I've got a hunch you'll meet someone. Your hand looks, well. It looks hand-tacular! That's a fiiine looking hand. Someone will want that hand some day!"];
			tree[69] = [100];

			tree[75] = ["It's safe\nto assume\nI'll still\nbe dating"];
			tree[76] = ["#hera04#Heh! Yeah, I'm kind of in the same boat you are! I go on dates sometimes, but I'm not tied down to anybody right now."];
			tree[77] = ["#hera06#...I sort of like things this way! And I'm content as far as relationships go, so I don't think about the future too much."];
			tree[78] = [102];

			tree[100] = ["#hera04#I'm single myself! And I'm satisfied for now--"];
			tree[101] = ["#hera05#--Well you know! I'm happy working to work. The money is good, and I have a few hobbies that keep me busy, and I'm close with my friends."];
			tree[102] = ["#hera04#Anyways I didn't mean to distract you from your puzzles! Why don't you get started on this first one. It'll give me some time to assemble my thoughts."];
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["#hera04#So like I was saying, I'm happy being single! But... I just worry about where it'll put me, well, in the future if that makes sense."];
			tree[1] = ["#hera06#Long term! Like maybe twenty years from now... Like... Okay, sort of a sloppy segue, forgive me."];
			tree[2] = ["#hera08#But... One of my friends, his dad passed away about four years ago."];
			tree[3] = ["#hera09#His parents were around retirement age, and it was just a sudden thing. His dad was healthy, taught yoga, exercised all the time, it just came from out of nowhere!"];
			tree[4] = ["#hera08#...And... when the news hit, my gut reaction was how tragic it was for my friend and his family, for them to lose someone so close to them."];
			tree[5] = ["#hera09#But... then I realized, it's especially tragic for his mother isn't it? The two of them were going to retire soon, they'd finally get to travel, grow old together..."];
			tree[6] = ["#hera11#...and to suddenly have that taken away..."];
			tree[7] = ["#hera08#... ...I couldn't get that out of my head. It seemed so unfair. But then over time, it got me thinking about other people, too..."];
			tree[8] = ["#hera10#Like, about people who never got married in the first place? ...Of course it's not the same, I'm not trying to trivialize the death of a family member. But..."];
			tree[9] = ["#hera06#You know, people who just enter middle age and their senior years without seeing anybody? And it feels like it would be a similar stiuation..."];
			tree[10] = ["#hera09#Growing old alone in a big empty house, gradually drifting away from their ever shrinking social circles...."];
			tree[11] = ["#hera08#...-sigh- it just makes me worry about where my life is headed, if that makes any sense. ...Sorry for rambling..."];
			tree[12] = [20, 50, 40, 30, 60];

			tree[20] = ["You'll\nmeet\nsomeone"];
			tree[21] = ["#hera04#Yeah! That's a good attitude to have. I bet I will someday~"];
			tree[22] = ["#hera06#Just gotta keep looking right? Chin up, and all that stuff! ...It has to happen some day! Gweh-heh-heh~"];
			tree[23] = [100];

			tree[30] = ["You'll\nalways\nhave me"];
			tree[31] = ["#hera07#I'm going to... to have you, <name>? In twenty years? Twenty YEARS?"];
			tree[32] = ["#hera06#Twenty years is a LONG time, <name>. I don't think Flash will be a thing in 20 years! ...Abra's going to have to update his software..."];
			tree[33] = ["#hera09#I mean at some point long before then, you'll get bored of these puzzles, and bored of us, and one day you'll just stop logging in..."];
			tree[34] = [100];

			tree[40] = ["You'll\nalways\nhave\nfamily"];
			tree[41] = ["#hera04#Gweh! Yeah, that's true. You're never truly alone as long as you have family I guess."];
			tree[42] = ["#hera06#And I mean, no matter how bad things get I'm sure I'll have a handful of friends around! ...Even if most of them move on with their lives."];
			tree[43] = [100];

			tree[50] = ["You'll\nalways\nhave\nfriends"];
			tree[51] = ["#hera04#Gweh! Yeah, that's true. No matter how bad things get, I'm sure I'll have a handful of friends around!"];
			tree[52] = ["#hera06#Even years down the road, when most of them have kids or move away, there'll be... Well, there'll always be a few left."];
			tree[53] = [100];

			tree[60] = ["You'll\nalways\nhave the\ninternet"];
			tree[61] = ["#hera04#Gweh! I... I guess? I guess you're never really alone if you have the internet. There's always internet friends."];
			tree[62] = ["#hera06#I mean... A chat window is a servicable substitute for face-to-face conversation, isn't it? It's basically the same thing... you can even voice chat!"];
			tree[63] = ["#hera05#All that's missing is the physical contact. But who needs hugs when you have, umm memes! And cat videos and stuff. That's just as good..."];
			tree[64] = [100];

			tree[100] = ["#hera08#...Hmm... ..."];
			tree[101] = ["%fun-shortbreak%"];
			tree[102] = ["#hera09#...Sorry, I'll be back in a second."];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 32, "update his", "update her");
			}
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["#hera08#...Sorry, I didn't mean to kill the mood, <name>! ...Every once in awhile my brain just gets hung up on these big picture questions."];
			tree[1] = ["#hera06#It's not like I ever actually accomplish anything thinking about that stuff, either!"];
			tree[2] = ["#hera02#...Usually the answer I come up with is, well, just don't think about it!"];
			tree[3] = ["#hera04#I was happy ten years ago, and I'm happy today. So I'll probably be happy ten years from now, won't I?"];
			tree[4] = ["#hera05#And if for some reason I'm not, you know, it's something I can figure out then."];
			tree[5] = [40, 30, 10, 20];

			tree[10] = ["Yeah!\nYou'll figure\nit out"];
			tree[11] = ["#hera02#Heh, yeah! I know I will. ...You're a real glass-half-full kind of guy aren't you? I need more guys like you in my life."];
			tree[12] = [50];

			tree[20] = ["Yeah!\nHappiness\nis out there\nif you look\nfor it"];
			tree[21] = ["#hera02#Heh, yeah! I know I'll find it. ...You're a real glass-half-full kind of guy aren't you? I need more guys like you in my life."];
			tree[22] = [50];

			tree[30] = ["Well,\nyou'll probably\nbe fine"];
			tree[31] = ["#hera02#Heh, yeah! I probably will. ...You have an unflappable kind of personality don't you? I need more guys like you in my life."];
			tree[32] = [50];

			tree[40] = ["..."];
			tree[41] = ["#hera02#Heh, sorry! I wasn't trying to fish for anything there."];
			tree[42] = ["#hera04#...You're a real down-to-earth kind of guy aren't you? I need more guys like you in my life."];
			tree[43] = [50];

			tree[50] = ["#hera00#Thanks for... Well, thanks for being a good listener, <name>."];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 11, "kind of guy", "kind of girl");
				DialogTree.replace(tree, 11, "more guys", "more girls");
				DialogTree.replace(tree, 21, "kind of guy", "kind of girl");
				DialogTree.replace(tree, 21, "more guys", "more girls");
				DialogTree.replace(tree, 31, "more guys", "more girls");
				DialogTree.replace(tree, 42, "kind of guy", "kind of girl");
				DialogTree.replace(tree, 42, "more guys", "more girls");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 11, "kind of guy", "kind of person");
				DialogTree.replace(tree, 11, "more guys", "more people");
				DialogTree.replace(tree, 21, "kind of guy", "kind of person");
				DialogTree.replace(tree, 21, "more guys", "more people");
				DialogTree.replace(tree, 31, "more guys", "more people");
				DialogTree.replace(tree, 42, "kind of guy", "kind of person");
				DialogTree.replace(tree, 42, "more guys", "more people");
			}
		}
	}

	public static function random00(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("hera.randomChats.0.0");

		if (count % 3 == 0)
		{
			tree[0] = ["%fun-alpha0%"];
			tree[1] = ["%fun-nude2%"];
			tree[2] = ["#hera03#<name>? <name> is that you? Oh my word!"];
			tree[3] = ["%fun-alpha1%"];
			tree[4] = ["#hera11#<name>! Gwehhh!!! ...I'm here! Heracross is here! When did you... Ah!!!"];
			tree[5] = ["%fun-alpha0%"];
			tree[6] = ["%fun-nude0%"];
			tree[7] = ["#hera10#I'm... please don't leave! Gwehh..."];
			tree[8] = ["#hera11#Ack, fragnazzle! ...Stupid underwear! Why do you have so many holes?"];
			tree[9] = ["%fun-alpha1%"];
			tree[10] = ["#hera03#Gweh! I'm here! ...<name>! Hello! -pant- -pant- ...Hello!"];
			tree[11] = ["#hera07#Give me... Gweh... Give me a minute to catch my breath... -pant- -pant-"];

			tree[10000] = ["%fun-shortbreak%"];
			tree[10001] = ["%fun-nude0%"];
		}
		else
		{
			tree[0] = ["%fun-alpha0%"];
			tree[1] = ["%fun-nude2%"];
			tree[2] = ["#hera10#<name>? Is that you, <name>?"];
			tree[3] = ["%fun-alpha1%"];
			tree[4] = ["#hera11#Ack! Not again! I thought the computer usually made a noise when you... Gwehhh!!! I'm so so sorry!"];
			tree[5] = ["%fun-alpha0%"];
			tree[6] = ["%fun-nude0%"];
			tree[7] = ["#hera10#I'm... please don't leave! Gwehh..."];
			tree[8] = ["#hera11#Ack, what in the...! ...Why doesn't this belt buckle buckle!? This is the... stupidest..."];
			tree[9] = ["%fun-alpha1%"];
			tree[10] = ["#hera03#... ...Gweh! I'm here! ...<name>! Hello! -pant- -pant- ...Hello!"];
			tree[11] = ["#hera07#Give me... Gweh... Give me a minute to catch my breath... -pant- -pant-"];

			tree[10000] = ["%fun-shortbreak%"];
			tree[10001] = ["%fun-nude0%"];
		}
	}

	public static function random01(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#hera03#Gweh! <name>? You came! You came again! I thought... I thought maybe you'd think, since you see me in the store all time..."];
		tree[1] = ["#hera02#...I thought you'd be sick of me! But... you really came! Yeaaayyyyy!!"];
		tree[2] = ["#hera03#Oh right, puzzles! Puzzles! ... ...We can do this! Eeeeeee~"];
	}

	public static function random02(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#hera02#Oh! <name>? ...Wow! No getting around it this time, you picked me on purpose!"];
		tree[1] = ["#hera00#~Thaaaaat meeeeans you liiike meee~"];
		tree[2] = ["#hera03#Gweheheheh! Okay, let's get this first puzzle out of the way so I can get out of these pants!"];
		if (!PlayerData.heraMale)
		{
			DialogTree.replace(tree, 2, "these pants", "this dress");
		}
	}

	public static function random03(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var hours:Int = Date.now().getHours();

		var hour0:Int = (hours % 12);
		hour0 = (hour0 == 0 ? 12 : hour0);

		var hour1:Int = ((hours + 1) % 12);
		hour1 = (hour1 == 0 ? 12 : hour1);

		tree[0] = ["#hera01#Well well, if it isn't <name>! What an unexpected surprise~"];
		tree[1] = ["#hera02#...Actually, I've been trying to synchronize my work breaks with your schedule. Gweh-heheh! I kinda had a feeling you might show up sometime around " + englishNumber(hour0) + " or " + englishNumber(hour1) + "."];
		tree[2] = ["#hera10#Not... Not in a spooky stalker kind of way! More just in a... \"when people like to play computer games\" kind of way! ...Gweh!"];
		tree[3] = ["#hera11#... ...I'm not one of those... creepy crawler bugs! You know that, right?"];
	}

	public static function random10(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var index:Int = PlayerData.recentChatCount("hera.randomChats.1.0");
		if (index % 4 == 0 && hasMet("magn"))
		{
			tree[0] = ["#hera04#Oh look, here comes Magnezone..."];
			tree[1] = ["%entermagn%"];
			tree[2] = ["#hera03#Magnezone! Look, Magnezone! <name>'s here! ...I'm playing with " + stretch(PlayerData.name) + "~"];
			tree[3] = ["#magn04#..."];
			tree[4] = ["#magn05#... ..." + MagnDialog.HERA + ", your reproductive unit is visible."];
			tree[5] = ["#hera02#Well it umm... Yeah! It is! Gweh! Heh! Heh!"];
			if (PlayerData.heraMale)
			{
				tree[6] = ["#magn06#..."];
				tree[7] = ["%fun-fixboxers%"];
				tree[8] = ["#hera10#Do you need me to, ohhh... ... ...Is this better?"];
				tree[9] = ["%exitmagn%"];
				tree[10] = ["#magn14#-bweeoop-"];
				tree[11] = ["#hera12#Phooey! What a killjoy..."];
			}
			else
			{
				tree[6] = ["#magn05#..."];
				tree[7] = ["#magn10#" + MagnDialog.HERA + " why would you... -fzzt- Do you... require assistance? (Y/N)"];
				tree[8] = ["#hera04#Errr, I think I'm good, thanks..."];
				tree[9] = ["#magn04#... ... ..."];
				tree[10] = ["%exitmagn%"];
				tree[11] = ["#magn14#-bweeoop-"];
				tree[12] = ["#hera06#Phooey! That mechanical lunkhead sure knows how to kill a ladyboner."];
			}
		}
		else if (index % 4 == 1 && hasMet("rhyd"))
		{
			tree[0] = ["#hera04#Oh wow, is that Rhydon?"];
			tree[1] = ["%enterrhyd%"];
			tree[2] = ["#hera03#Hey Rhydon! Look, it's <name>! <name>'s here!"];
			tree[3] = ["#RHYD02#Whoa, <name>'s here! Hey <name>! ...Roar!"];
			tree[4] = ["#hera02#I know, right? Yayyyy! " + stretch(PlayerData.name) + "~"];
			tree[5] = ["#RHYD03#Gro-o-oaarrrrrrrr!!! <name>! We gotta hang out later when you're done with Heracross. ...I'm gonna go tell the other guys!"];
			tree[6] = ["%exitrhyd%"];
			tree[7] = ["#RHYD02#Hey guys! <name>'s around! Wrroooaa-a-a-arrrrrr! But like, I got next! Who wants to go after me?"];
			tree[8] = ["#hera04#..."];
			tree[9] = ["#hera01#... ...Gweheheheh! Yay~"];

			if (!PlayerData.rhydMale)
			{
				DialogTree.replace(tree, 5, "other guys", "other girls");
				DialogTree.replace(tree, 7, "Hey guys", "Hey everyone");
			}
		}
		else if (index % 4 == 2 && hasMet("buiz"))
		{
			tree[0] = ["#hera04#Oh I think that's Buizel! Let's say hello~"];
			tree[1] = ["%enterbuiz%"];
			tree[2] = ["#hera03#Hey Buizel! Look, it's <name>! <name>'s here to play with meeeeeee~"];
			tree[3] = ["#buiz02#Oh hey what's up <name>! What's up Heracross."];
			tree[4] = ["#buiz03#Your uh, your thingy's showing. Is that like on purpose? Or..."];
			tree[5] = ["#hera04#My... thingy? Oh sure! Gweh-heheheh~"];
			tree[6] = ["%exitbuiz%"];
			tree[7] = ["#buiz02#... ...Anyway, take it easy! Hit me up if you wanna hang out later, <name>. I'll be in my room~"];
			tree[8] = ["#hera08#..."];
			tree[9] = ["#hera11#... ...I wish I had a room..."];

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 4, "thingy", "you-know-what");
				DialogTree.replace(tree, 5, "thingy", "you-know-what");
			}
		}
		else
		{
			tree[0] = ["#hera04#Oh look, here comes Abra..."];
			tree[1] = ["%enterabra%"];
			tree[2] = ["#hera03#Abra! Abra, look! Look! It's " + stretch(PlayerData.name) + "! I'm finally getting to play with <name>~"];
			tree[3] = ["#abra04#Hmm. So you are."];
			tree[4] = ["#hera05#..."];
			tree[5] = ["#hera03#Abra you're my frieeeeeennnnnddd~"];
			tree[6] = ["%exitabra%"];
			tree[7] = ["#abra05#Uh, I was really just trying to get to the kitchen..."];
			tree[8] = ["#hera04#..."];
			tree[9] = ["#hera01#... ...Gweheheheheheh~"];
		}
	}

	public static function random11(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var index:Int = PlayerData.recentChatCount("hera.randomChats.1.1");

		if (index % 2 == 0)
		{
			tree[0] = ["#hera05#We insects get a bad reputation sometimes! You know, eating people's food... spreading diseases... going places we don't belong..."];
			tree[1] = ["#hera11#Obviously I'm one of the good ones! But sometimes the little creepy crawly kinds of insects can even get on my nerves a little. Gweh!"];
			tree[2] = ["#hera06#...What sort of bugs get on your nerves, <name>?"];

			var options:Array<Object> = [10, 20, 30, 40, 50];
			FlxG.random.shuffle(options);
			options.splice(0, 2);
			options.push(60);

			tree[3] = options;

			tree[10] = ["Mosquitos"];
			tree[11] = ["#hera02#Oh, we have mosquitos here in our universe too!"];
			tree[12] = ["#hera03#Of course, their wimpy proboscises can't puncture my rigid exoskeleton. So those bugs don't bug me! ...But, other Pokemon complain about them all the time."];
			tree[13] = ["#hera10#I don't think they mind having their blood sucked, as much as they mind being exposed to itchy mosquito saliva! Ack!"];
			tree[14] = ["#hera00#...Don't worry <name>! I'll never expose you to my saliva unless you ask first~"];

			tree[20] = ["Spiders"];
			tree[21] = ["#hera10#Oh, we have spiders here in our universe too! ...You don't like spiders?"];
			tree[22] = ["#hera04#...They make such pretty webs! And how could you not be turned on by so many sexy little legs~"];
			tree[23] = ["#hera06#Their legs are actually powered by hydraulic movement! Did you know that? They shoot little... bug liquid into their legs to walk around... Gweh-heheheh!"];
			tree[24] = ["#hera00#...Don't worry <name>, I'll never shoot my bug liquid at you unless you ask first~"];

			tree[30] = ["Ticks"];
			tree[31] = ["#hera02#Ah! Ticks! ...We have ticks in our universe too."];
			tree[32] = ["#hera03#Of course, their puny mandibles can't puncture my rigid exoskeleton. So those bugs don't bug me! ...But, other Pokemon complain about them all the time."];
			tree[33] = ["#hera06#...I don't think their little bites hurt, but they can spread all sorts of icky diseases."];
			tree[34] = ["#hera09#And after they bite, they can stay attached for up to ten days while they drain your fluid! Hmph! How presumptuous."];
			tree[35] = ["#hera01#...Don't worry <name>! I don't get attached that easily. And... it won't take me ten days to drain your fluid~"];

			tree[40] = ["Dung\nbeetles"];
			tree[41] = ["#hera07#...Dung ...DUNG BEETLES!? What the heck is a dung beetle? I've never heard of anything like that..."];
			tree[42] = ["#hera11#Unless... unless you're talking about that one website? Ewwww! ...<name>!!!"];
			tree[43] = ["#hera09#<name>, don't pay attention to that web site! Not all beetles are into that sort of thing!"];
			tree[44] = ["#hera11#I... I like regular stuff!! Gwehhhhhh!!!"];

			tree[50] = ["Ants"];
			tree[51] = ["#hera10#...Ants? Aww we have ants in our universe too! ...You don't like ants?"];
			tree[52] = ["#hera04#They're so hardworking! They're like nature's little garbagemen!"];
			tree[53] = ["#hera08#I guess, maybe they can be annoying sometimes... Well, if they come into your house without your permission..."];
			tree[54] = ["#hera06#Oh! Or if you leave a lot of sweets lying around where ants can find them."];
			tree[55] = ["#hera01#...Don't worry <name>! I'll always ask permission before touching any of your sweets~"];

			tree[60] = ["Oh, I like\nthem all"];
			tree[61] = ["#hera05#Ohhhh don't worry <name>! You won't hurt my feelings. You don't have to like EVERY bug..."];
			tree[62] = ["#hera01#... ...I just need you to like one particular bug! ...I need you to like him an awful lot! Gweh-heheheheh~"];

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 62, "like him", "like her");
			}
		}
		else
		{
			tree[0] = ["#hera04#Hmmm I hope I'm staying on your good bug list, <name>! I'm doing my very best to be a good bug~"];
			tree[1] = [20, 30, 10, 40];

			tree[10] = ["You're the\nbest bug,\nHeracross~"];
			tree[11] = ["#hera02#The... The best bug!?! " + stretch(PlayerData.name) + "!!"];
			tree[12] = ["#hera01#Well you... you're my favorite hand! You're my favorite little hand man~"];
			tree[13] = ["#hera00#... ...Gweheheheheh! ...Favorite bug~"];

			tree[20] = ["Yeah! You're\nin my top ten\nsexy bugs~"];
			tree[21] = ["#hera00#Top... Top ten sexy bugs!?! Aww <name>!"];
			tree[22] = ["#hera03#Wait, who are the nine other sexy bugs? ...Are they single? I want phone numbers!!"];
			tree[23] = ["#hera11#... ...<name>! Don't hold out on meeeeeeee~"];

			tree[30] = ["Ohh, you\nshouldn't try\nso hard"];
			tree[31] = ["#hera11#I shouldn't? But... But trying hard is what I do! How can I... Gwehhh!"];
			tree[32] = ["#hera10#... ...Okay, I'll do it for you <name>! I'll... I'll get better at not trying so hard!"];

			tree[40] = ["Stop hiking\nyour prices,\nyou pesky\nbeetle"];
			tree[41] = ["#hera11#But... But... If you buy all the cool stuff, then you won't want to play with me anymore!"];
			tree[42] = ["#hera10#...You've already bought too many items as it is! If you buy too many more... ...There'll be nothing left to buy! And... And..."];
			tree[43] = ["%fun-longbreak%"];
			tree[44] = ["#hera11#Gwehh! I have to go raise my prices a little! I'm sorry! I'm sorry <name>! ...I'm doing this for our love!"];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 12, "favorite hand", "favorite glove");
				DialogTree.replace(tree, 12, "hand man", "glove girl");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 12, "favorite hand", "favorite glove");
				DialogTree.replace(tree, 12, "hand man", "glove guy");
			}
		}
	}

	public static function random12(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.difficulty == PlayerData.Difficulty.Easy || PlayerData.difficulty == PlayerData.Difficulty._3Peg)
		{
			tree[0] = ["#hera04#Oh! So how do you like these three-peg puzzles, <name>? They seem like a good balance! ...A little bit of challenge, without being TOO mentally exhausting."];
			tree[1] = ["#hera06#Of course if you want the big bucks, maybe you should step up to something harder! Those 4-peg puzzles will nab you like 100$ or more in one punch!"];
			tree[2] = [10];
		}
		else if (PlayerData.difficulty == PlayerData.Difficulty._4Peg)
		{
			tree[0] = ["#hera04#Oh! So how do you like these four-peg puzzles, <name>?"];
			tree[1] = ["#hera06#They seem pretty tricky but... I guess if you want the big bucks, these'll nab you a modest 100$ or more in one punch!"];
			tree[2] = [10];
		}
		else if (PlayerData.difficulty == PlayerData.Difficulty._5Peg)
		{
			tree[0] = ["#hera04#Oh! So how do you like these five-peg puzzles, <name>?"];
			tree[1] = ["#hera06#They're a little tough but... you get used to them after awhile, don't you? And they'll nab you a whopping $500 or more in one punch!"];
			tree[2] = [10];
		}
		else
		{
			// shouldn't reach here
		}

		tree[10] = ["#hera02#...That's a pretty sweet deal! That's a lot of Heracross dollars... for Heracross! Gweh-heheheh!"];
		tree[11] = ["#hera05#You... You ARE giving your Heracross dollars to Heracross, right? I've got some pretty nifty stuff in stock!"];
	}

	public static function random13(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("hera.randomChats.1.3");

		if (count % 3 == 1 && hasMet("sand"))
		{
			tree[0] = ["%entersand%"];
			tree[1] = ["#sand05#Ay Heracross! I've been lookin' for you."];
			tree[2] = ["#hera04#Oh?"];
			tree[3] = ["#sand12#Yeah, man! I went by your store to return somethin', but that idiot Kecleon's fuckin' useless..."];
			tree[4] = ["#hera06#Ehh? ...We don't usually do returns... What were you trying to return?"];
			tree[5] = ["#sand04#Oh, you know... (whisper, whisper)"];
			tree[6] = ["#hera07#WHAT!? Euughhh! We DEFINITELY don't take returns on THOSE!"];
			tree[7] = ["#hera14#How would you like it if you bought one of THOSE, and someone else had used it already!?"];
			tree[8] = ["#sand01#Mmmm I dunno man, depends on who I guess. ... ...Might make me want it more~"];
			tree[9] = ["#hera11#Gwehh! Sandslash, No! Gwehhhhh!! You're awful! Get out of here!"];
			tree[10] = ["%exitsand%"];
			tree[11] = ["#sand12#Tsk whatever, I'ma go talk to Kecleon again."];
			tree[12] = ["#hera10#No, don't...! Where are you going? Don't... Augh!"];
			tree[13] = ["%fun-longbreak%"];
			tree[14] = ["#hera11#I'll be right back <name>! KECLEON! WE DON'T TAKE RETURNS! KEEECLEEOOOONNNNN!"];

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 3, "Yeah, man", "Yeah, girl");
				DialogTree.replace(tree, 8, "I dunno man", "I dunno girl");
			}
		}
		else
		{
			var timeInMinutes:Float = puzzleState._puzzle._difficulty * RankTracker.RANKS[42] / 60;

			tree[0] = ["#hera04#Hmm, let's see. Oh! I've already done this puzzle before..."];
			tree[1] = ["#hera05#I think it took me about " + DialogTree.durationToString(timeInMinutes * 60) + ". I know that seems fast but, I've practiced these puzzles a lot! Like, a lot a lot!!"];
			tree[2] = ["#hera10#It's just... I wanted to make a good impression on Abra so he'd let us play together! ...But well, maybe I overdid it a teensy bit..."];
			tree[3] = ["#hera06#So... don't worry if these puzzles take you a little longer than " + DialogTree.durationToString(timeInMinutes * 60) + "! ...I think that's probably normal..."];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 2, "so he'd", "so she'd");
			}
		}
	}

	public static function random20(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("hera.randomChats.2.0");

		if (count % 3 == 1)
		{
			tree[0] = ["#hera10#" + stretch(PlayerData.name) + ", that was so faaaaast! ...I hope you're not just rushing through these puzzles for my sake."];
			tree[1] = ["#hera05#I'm having fun just watching you play! I'm not in a hurry to finish. ...We have all day to play together!"];
			tree[2] = ["#hera02#It's okay to relax sometimes, you know. ...Stop and smell the roads less travelled! Gweh-heh-heh-heh~"];
		}
		else
		{
			tree[0] = ["#hera02#Oh! Oh <name>! It's only one more puzzle until we... dot dot dot...! Eeeeee!"];
			tree[1] = ["#hera03#Aren't you excited? The anticipation's a little too much for me!"];
			tree[2] = ["#hera08#Did I remember everything? Oh no! I think I... well I took a little shower... and I washed behind my antenna... And I... Umm... ... ..."];
			tree[3] = ["%fun-shortbreak%"];
			tree[4] = ["#hera11#Gwehh! I'm going to go floss my mandibles really quick!"];
		}
	}

	public static function random21(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#hera02#Yayyy! You did it! Goodbye boxer shorts!"];
		tree[1] = ["#hera06#Wait, that's okay isn't it? You didn't want me wearing them anymore did you?"];
		tree[2] = [40, 30, 20, 10];

		tree[10] = ["Promise\nyou'll never\nput them\nback on"];
		tree[11] = ["#hera10#...But ...But it's Abra's rules! That sort of talk is going to get me in trouble!"];
		tree[12] = ["#hera08#I couldn't forgive myself if he pulled us apart just because I got too relaxed about some annoying rules."];
		tree[13] = ["#hera04#... ...Anyways, It's okay! You're getting really fast at these puzzles. I barely get to keep my clothes on at all! You're so smart~"];

		tree[20] = ["Nope! Goodbye\nboxer shorts"];
		tree[21] = ["#hera02#Gweh-heheheh! Well, they're pretty cute as far as underwear goes."];
		tree[22] = ["#hera04#But... They're still another annoying obstacle between your hand and my... ...my buggy bits! The boxer shorts have to go!"];
		tree[23] = ["#hera03#This... This puzzle has to go too! Why is it still here? Goodbye! Goodbye puzzle!"];

		tree[30] = ["Well, maybe for\none more puzzle"];
		tree[31] = ["#hera10#You... you want me to put my boxer shorts back on!?! What!? I'm not going to do that! ...<name>!!!"];
		tree[32] = ["#hera12#...Why are you so weird? Haven't you played a stripping game before?"];
		tree[33] = ["#hera15#I want to keep my clothes off! I want to win! Competitive stripppiiiiiing!"];

		tree[40] = ["Put all\nyour clothes\nback on! And\nalso a hat!"];
		tree[41] = ["#hera14#Oh great! Not only do you NOT want to see me naked... you want to see me more dressed than I've ever been!!"];
		tree[42] = ["#hera13#And besides, it should be obvious a hat won't fit over my STUPID HORN!!"];
		tree[43] = ["#hera10#Gweh! I mean..."];
		tree[44] = ["#hera06#I mean, a hat won't fit over my... Lovely horn! My beautiful horn!"];
		tree[45] = ["%fun-shortbreak%"];
		tree[46] = ["#hera11#Aw sweetie, let's not fight! I didn't mean what I said~"];

		if (!PlayerData.abraMale)
		{
			DialogTree.replace(tree, 12, "if he", "if she");
		}
		if (!PlayerData.heraMale)
		{
			DialogTree.replace(tree, 0, "boxer shorts", "panties");
			DialogTree.replace(tree, 20, "boxer shorts", "panties");
			DialogTree.replace(tree, 22, "boxer shorts", "panties");
			DialogTree.replace(tree, 31, "boxer shorts", "panties");
		}
	}

	public static function random22(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var index:Int = PlayerData.recentChatCount("hera.randomChats.2.2");

		tree[0] = ["#hera04#Are we through with puzzles yet? I'm feeling pretty naked!"];
		tree[1] = ["#hera05#Maybe we can take a break after this puzzle and you can check me for nakedness!"];

		if (index % 3 == 0)
		{
			tree[2] = ["#hera02#You should be really thorough! Make sure I didn't you know, sneak a sock somewhere silly. Gweh-heheheh!"];
		}
		else if (index % 3 == 1)
		{
			tree[2] = ["#hera02#You should be really thorough! Make sure I don't have you know, the world's tiniest top hat hidden behind my horn. Gweh-heheheh!"];
		}
		else if (index % 3 == 2)
		{
			tree[2] = ["#hera02#You should be really thorough! Make sure I'm not concealing you know, a teeny tiny heracross anklet. Gweh-heheheh!"];
		}
	}

	public static function random23(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("hera.randomChats.2.3");

		if (count % 3 == 0)
		{
			tree[0] = ["#hera04#Are we through with puzzles yet? I'm feeling pretty, (sniff, sniff) feeling pretty ehh...."];
			tree[1] = ["#hera07#It smells a little bit like... (sniff) is... is someone mulching the living room?"];
			tree[2] = ["%entergrim%"];
			tree[3] = ["#grim06#Hey Heracross! Sandslash and I were wondering if you had any, err... antidote? ...In your store?"];
			tree[4] = ["#hera04#Antidote? Ehhh, no, I don't stock antidote."];
			tree[5] = ["#grim12#What!? ...What kind of Pokemart doesn't stock antidote!?"];
			tree[6] = ["#hera06#It's not a Pokemart, it's just a store which... Wait, why do you two want antidote anyway?"];
			tree[7] = ["#grim10#D-don't worry about it! C'mon Sandslash, sounds like we're driving."];
			tree[8] = ["#sand01#Awww c'monnnn do we really have to? It's not like it's gonna--"];
			tree[9] = ["%exitgrim%"];
			tree[10] = ["#grim00#--Trust me buddy, this is NOT something you want to try without antidote..."];
			tree[11] = ["#hera06#... ... ..."];
		}
		else if (count % 3 == 1)
		{
			tree[0] = ["#hera04#Are we through with puzzles yet? I'm feeling--"];
			tree[1] = ["%entersand%"];
			tree[2] = ["#sand05#Yo Heracross! ...Any chance I can keep this box of antidote in, uhhh... like... your storage area?"];
			tree[3] = ["#hera06#Gweh? Antidote? I don't really... Why can't you keep it with your stuff?"];
			tree[4] = ["#sand13#Tsk, and just how the fuck am I supposed to score with a big fuckin' box of antidote in my bedroom? ...That's not a hard dot to connect."];
			tree[5] = ["#sand06#Can't I just keep it back where you got all those other boxes? It's just one more box, man! C'mon, don't be selfish."];
			tree[6] = ["#hera14#...No. ... ...Thank you for your interest in my storage area."];
			tree[7] = ["%exitsand%"];
			tree[8] = ["#sand12#Whatever, I'll figure somethin' out. Thanks for nothing."];
			tree[9] = ["#hera06#Sheesh! Anyway, ehhhh... Where were we?"];

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 5, "box, man", "box, girl");
			}
		}
		else
		{
			tree[0] = ["#hera04#Are we through with puzzles yet? I'm feeling pretty, (sniff, sniff) feeling pretty ehh...."];
			tree[1] = ["#hera07#Smells like... (sniff) ...bad milk... or good cheese..."];
			tree[2] = ["%entergrim%"];
			tree[3] = ["#grim00#Hey Heracross! Do you have the key to your storage area?"];
			tree[4] = ["#hera04#No, but Kecleon has the--"];
			tree[5] = ["#hera10#--Wait, way do you need the key!?"];
			tree[6] = ["%exitgrim%"];
			tree[7] = ["#grim13#Errr, one second! ...WHAT'S THAT, SANDSLASH?"];
			tree[8] = ["#sand16#...hr drffn'p mrr m krr'prm brf rr sprrch rrmm..."];
			tree[9] = ["#grim12#SPEAK UP! HE DOESN'T KNOW WHAT?"];
			tree[10] = ["#sand17#...krrkrm! gr trrktrr krrkrrm..."];
			tree[11] = ["%entergrim%"];
			tree[12] = ["#grim10#Oh uhh... nevermind, Heracross! I think we're, errr... Bye!"];
			tree[13] = ["%exitgrim%"];
			tree[14] = ["#hera12#...Ugh, sounds like I'm doing inventory tonight..."];

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 9, "UP! HE", "UP! SHE");
			}
		}
	}

	public static function sexyBefore0(tree:Array<Array<Object>>, sexyState:HeraSexyState)
	{
		var count:Int = PlayerData.recentChatCount("hera.sexyBeforeChats.0");
		if (count == 0)
		{
			tree[0] = ["#hera10#Gweehhhh! " + stretch(PlayerData.name) + "! Gweeeeeeeehhhh!!"];
			tree[1] = ["#hera11#I... I can't believe this is finally happening! I'm so... I'm so nervous! Gweh!"];
			tree[2] = ["#hera05#Is there anything you need me to do? Anything that would, ehh, help in some way?"];
			tree[3] = [40, 10, 20, 30];
		}
		else
		{
			tree[0] = ["#hera10#Gweehhhh! " + stretch(PlayerData.name) + "! Gweeeeeeeehhhh!!"];
			tree[1] = ["#hera11#I... I'm still so nervous! I know we've done this before but... still! Gweh!"];
			tree[2] = ["#hera05#Isn't there anything you I can do? Anything that would, ehh, make this better for you?"];
			tree[3] = [40, 10, 20, 30];
		}

		tree[10] = ["Just... stop\ntalking so\nI can click\nthings"];
		tree[11] = ["#hera10#Stop talking!? But... But how am I supposed to let you know how much I... ...How much I like you!"];
		tree[12] = ["#hera06#Let's work out a secret blinking code, okay? One short blink means, \"You're really special to me!\" Two long blinks means, \"That feels good, keep doing that!\""];
		tree[13] = ["#hera11#One really long blink means, umm... \"Help! Some troublemaker superglued my eyelids together!\" Agh!"];
		tree[14] = [50];

		tree[20] = ["Just... try\nto relax"];
		tree[21] = ["#hera07#Try to relax? ...I thought I WAS relaxed! I'm not relaxed!?"];
		tree[22] = ["#hera11#...Now you're making me self-conscious about how bad I am at relaxing! Agh!"];
		tree[23] = [50];

		tree[30] = ["Just... let\nme experiment\na little"];
		tree[31] = ["#hera10#Experiment? Experiment a little!? I don't want to be a test subject! Agh!"];
		tree[32] = ["#hera11#...All those questions, and... cold stethoscopes and... and needles!? <name> I can't deal with needles! ...I'm going to cry if you test me with a needle!"];
		tree[33] = [50];

		tree[40] = ["I don't know!\nI'm nervous too"];
		tree[41] = ["#hera07#Oh no! <name>, you can't be nervous! ...I'm the nervous one! You're supposed to be my rock!"];
		tree[42] = ["#hera11#We can't just be... two nervous people together without any rocks. That doesn't work! What if someone attacks us with scissors!? Aaagh!"];
		tree[43] = [50];

		tree[50] = ["#hera10#Okay! Okay! I can relax. ...Deep breaths! Phwooohh! ...phwoooooooohhh."];
		tree[51] = ["#hera08#... ...Okay. I think... I think I'm ready. Just... You try to relax too, okay?"];
	}

	public static function sexyBefore1(tree:Array<Array<Object>>, sexyState:HeraSexyState)
	{
		var count:Int = PlayerData.recentChatCount("hera.sexyBeforeChats.1");
		if (PlayerData.justFinishedMinigame)
		{
			tree[0] = ["#hera03#Oh my goodness gracious! Was that it? Was that really it for that minigame? That time just flew by didn't it~"];
		}
		else
		{
			tree[0] = ["#hera03#Oh my goodness gracious! Was that it? Was that really the last puzzle? ...I think you're getting better at these, <name>!"];
		}
		if (count % 3 == 0)
		{
			tree[1] = ["#hera01#Was there anything... interesting you wanted to try today? ...I'll try anything once!"];
		}
		else if (count % 3 == 1)
		{
			tree[1] = ["#hera06#Was there anything ehh... unusual you wanted to try today? ...I'll try anything once!"];
		}
		else if (count % 3 == 2)
		{
			tree[1] = ["#hera00#Was there anything maybe... a little new that you wanted to try today? ...I'll try anything once!"];
		}
	}

	public static function sexyBefore2(tree:Array<Array<Object>>, sexyState:HeraSexyState)
	{
		tree[0] = ["#hera10#Erk! Even though we've done this a couple times now, I still get nervous when I'm naked and alone with you, <name>..."];
		tree[1] = ["#hera11#...Gweh! Stupid nerves! ...Stop being so nervous!"];
	}

	public static function sexyBefore3(tree:Array<Array<Object>>, sexyState:HeraSexyState)
	{
		var count:Int = PlayerData.recentChatCount("hera.sexyBeforeChats.3");
		if (count % 4 == 0)
		{
			if (count == 0)
			{
				tree[0] = ["#hera06#So <name>.... What's the most times you've ever, umm... you know..."];
				tree[1] = ["#hera04#What's the most times you've ever pleasured yourself in one day?"];
				tree[2] = [40, 30, 20, 10, 50];
			}
			else
			{
				tree[0] = ["#hera06#So <name>.... Have you broken your, umm... you know..."];
				tree[1] = ["#hera04#Have you set a new masturbation record yet? ...What's the most times you've done it in one day?"];
				tree[2] = [40, 30, 20, 10, 50];
			}

			tree[10] = ["Less than\n100"];
			tree[11] = ["#hera10#You've never masturbated more than 100 times in one day? ...Gosh!"];
			tree[12] = ["#hera05#You might not believe this but, my record is less than 100 too! Wow! We're like... masturbation-mates!"];
			tree[13] = ["#hera02#We should start a club for people who never masturbate more than 100 times in a day. ...There must be others like us out there!"];
			tree[14] = ["#hera03#We can organize club meetings where we umm... get together in a room, and masturbate fewer than 100 times!"];
			tree[15] = ["#hera01#Oh! Maybe we can hold our first meeting right now! ...What do you think, are you up for it?"];

			tree[20] = ["Between\n100 and\n5,000"];
			tree[21] = ["#hera07#...Between 100 and 5,000!? How the f... ...How in the funny business did you manage that one!?"];
			tree[22] = ["#hera10#Was it... was it a leap day? This sounds an awful lot like a riddle... Oh! Wait, I know! ...Were you north of the Arctic Circle?"];
			tree[23] = ["#hera11#...<name>, I don't understand! Did you go all the way to the Arctic Circle just to set a masturbation record? You're so weird!!"];

			tree[30] = ["Between\n5,000 and\n100,000"];
			tree[31] = ["#hera07#...Between 5,000 and 100,000!? In one DAY!? ONE DAY!? When the he... When in the habenero peppers did you find time for that much masturbation!?!"];
			tree[32] = ["#hera10#Had you already finished school? ...Were you... Were you unemployed at the time? Or on an extended sabbatical?"];
			tree[33] = ["#hera11#...<name>, I don't understand! Did you take a sabbatical from work just so you could sit at home and masturbate all day!? You're so weird!!"];

			tree[40] = ["More than\n100,000"];
			tree[41] = ["#hera07#...More than 100,000 times!? ... ..."];
			tree[42] = ["#hera11#... ... ... <name>, I don't think I've masturbated that many times in my whole life! Although well,"];
			tree[43] = ["#hera09#I guess beetles have sort of a below-average lifespan. You're human aren't you? But even then, that's an awful lot. Or are you... are you a different species entirely!?"];
			tree[44] = ["#hera10#...<name>, did your species evolve to have absurdly long lifespans just so you could sit around setting masturbation records!?! ...That's so weird!!"];

			tree[50] = ["..."];
			tree[51] = ["#hera11#... ...Umm... Nevermind! Forget I asked..."];
		}
		else
		{
			tree[0] = ["#hera04#<name>, I still haven't masturbated more than a hundred times in one day!"];
			tree[1] = ["#hera06#I don't know if I ever will... Even like... three feels like too much! But maybe with your help, well..."];
			tree[2] = ["#hera02#Maybe you can help me break five some day. C'mon! Let's set a new record~"];
		}
	}

	public static function sexyBefore4(tree:Array<Array<Object>>, sexyState:HeraSexyState)
	{
		tree[0] = ["#hera01#Okey dokey! Well, the cameras are rolling, so... let's put on a good show mmm?"];
		tree[1] = ["#hera02#This one's going directly to the internet when we're done! One million likes! 1,000,000$!! Let's make lots of moneyyyy~"];
	}

	public static function sexyAfter0(tree:Array<Array<Object>>, sexyState:HeraSexyState)
	{
		if (sexyState.didReallyPrematurelyEjaculate)
		{
			tree[0] = ["#hera11#Aaggh! This is so frustrating! This happens whenever I get nervous..."];
			tree[1] = ["#hera09#It's just... I don't get to spend time with you that often, and I think I built it up too much in my head, and... ohhh..."];
			tree[2] = ["#hera08#<name>, I want a do-over! Next time I won't be so nervous! ...I promise!"];
		}
		else
		{
			tree[0] = ["#hera04#Hahh... Oh, <name>... That was... That was great! But..."];
			tree[1] = ["#hera06#Well, I guess I should get back to the store. ...Ugh! Bummeroo~"];
			if (PlayerData.heraMale)
			{
				tree[2] = ["#hera02#My dick's going to feel a little chilly without a nice <name> hand wrapped around it! Gweh-heheheh~"];
			}
			else
			{
				tree[2] = ["#hera02#My pussy's going to feel a little empty without some nice <name> fingers stuffed inside it! Gweh-heheheh~"];
			}
		}
	}

	public static function sexyAfter1(tree:Array<Array<Object>>, sexyState:HeraSexyState)
	{
		if (sexyState.didReallyPrematurelyEjaculate)
		{
			tree[0] = ["#hera10#Oh... <name>! I'm so sorry! I think... I think I did it again..."];
			tree[1] = ["#hera11#That was my fault wasn't it? Did... did you do anything wrong? Why did it happen so quickly!? Gwehh! Gwehhhh...."];
		}
		else
		{
			tree[0] = ["#hera01#Oh my land! Those were some fancy little techniques. Who's been teaching you all of their weiner secrets?"];
			tree[1] = ["#hera00#You're like some kind of weiner whisperer! But well... ...not the gross kind. Gweh-heheh!"];

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 0, "their weiner", "their pussy");
				DialogTree.replace(tree, 1, "of weiner", "of pussy");
			}
		}
	}

	public static function sexyAfter2(tree:Array<Array<Object>>, sexyState:HeraSexyState)
	{
		if (sexyState.didReallyPrematurelyEjaculate)
		{
			tree[0] = ["#hera09#I'm sorry <name>! ...I always finish before you! I just... I can't stop it, once it..."];
			tree[1] = ["#hera00#Well, once you start rubbing me that way, and... and everything feels so sensitive... It's just... Gweh!!"];
			tree[2] = ["#hera04#...But I still had a good time! I hope it wasn't too disappointing for you... ...I'll... I'll see you again soon, right?"];
		}
		else
		{
			tree[0] = ["#hera06#Ahhh. Well... Break time's over, <name>. Fun's fun but I need to keep an eye on my little store!"];
			tree[1] = ["#hera04#...Sorry! I wish I could just lounge around naked getting my dick stroked all day..."];
			tree[2] = ["#hera02#... ...Maybe when I retire! Gweh~"];

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 1, "getting my dick stroked", "getting fingered");
			}
		}
	}

	public static function sexyAfterGood0(tree:Array<Array<Object>>, sexyState:HeraSexyState)
	{
		if (sexyState.didReallyPrematurelyEjaculate)
		{
			tree[0] = ["#hera11#Gweh! I just can't catch a break..."];
			tree[1] = ["#hera09#...I'm finally lucky enough to get some alone time with <name>, and I can't even last two minutes..."];
			tree[2] = ["#hera08#<name>, give me another chance okay? I just need some time to recharge! ...I'll last longer next time!!"];
		}
		else
		{
			tree[0] = ["#hera07#Gw-gwehh... Hahhh... Oh... Oh my g-... GOODNESS, that was..."];
			tree[1] = ["#hera00#<name>, what was the... Where did you... Where did you LEARN that!?"];
			tree[2] = ["#hera07#I just... gahh... Maybe Kecleon can hold the store for five more minutes... Just need to... catch my breath... Gweh... Hah..."];
		}
	}

	public static function sexyAfterGood1(tree:Array<Array<Object>>, sexyState:HeraSexyState)
	{
		if (sexyState.didReallyPrematurelyEjaculate)
		{
			tree[0] = ["#hera08#" + stretch(PlayerData.name) + " I'm so sorrrrryyyyyyyy! Gweh!"];
			tree[1] = ["#hera11#You deserve someone better... someone who can last more than thirty seconds. I'm... I'm so bad at this stuff!"];
			tree[2] = ["#hera09#Maybe if I had more practice... I'm going to go practice, okay? Maybe there's some way to make myself less sensitive..."];
		}
		else
		{
			tree[0] = ["#hera07#Gwah... That was... Oough... That was insane..."];
			tree[1] = ["#hera10#I'm... I'm so DEHYDRATED! Did you... Gah! Did you SEE that? That's... That's biologically impossible...! Gweh!"];
			tree[2] = ["#hera11#It's like, THREE TIMES my bodily supply of water just... gah... shot out my weiner in a matter of SECONDS! I don't even... Hah... Agh..."];
			tree[3] = ["%fun-longbreak%"];
			tree[4] = ["#hera07#You don't... Hahh... You're not fazed by this!? Does this seem NORMAL to you!? I... I'll be back in a minute... Need some water... Sheesh mcgleesh..."];

			tree[10000] = ["%fun-longbreak%"];

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 2, "my weiner", "my pussy");
			}
		}
	}

	public static function sexyBadPremature0(tree:Array<Array<Object>>, sexyState:HeraSexyState)
	{
		tree[0] = ["#hera06#I'm sorry about last time! ...Don't worry, that won't happen again. We're just... We're learning each other's bodies, right? It's all normal!"];
		tree[1] = ["#hera09#Well, maybe we're not learning each other's bodies, it's more like..."];
		tree[2] = ["#hera08#...You're learning my body, and I'm... I'm just learning how stupid my body is at everything. Gweh!"];
		tree[3] = ["#hera04#I'll... I'll try to last a little longer though! And maybe you can try to be..."];
		tree[4] = ["#hera01#Maybe you can be a little less <name>-y? Agh! I just can't help myself around you~"];
	}

	public static function sexyBadPremature1(tree:Array<Array<Object>>, sexyState:HeraSexyState)
	{
		tree[0] = ["#hera08#Ohhhhh " + stretch(PlayerData.name) + " why can't I last longer? I'm so sorry!"];
		tree[1] = ["#hera11#I'll try to distract myself this time! When things get sexy, I'll keep my eyes closed and... I won't think about sex at all!"];
		tree[2] = ["#hera09#Even if the sex is really sexy! I'll.... I'll try really hard <name>! Maybe you can try to make the sex a little less sexy, too..."];
	}

	public static function sexyBadPremature2(tree:Array<Array<Object>>, sexyState:HeraSexyState)
	{
		tree[0] = ["#hera01#Ahh! That felt like it took forever! But... I'm all yours now~"];
		tree[1] = ["#hera04#I hope I can last longer than last time! I just... isn't there something less sexy you can wear, instead of that glove?"];
		tree[2] = ["#hera06#Like maybe a goofy finger puppet, or a gross dessicated halloween costume hand?"];
		tree[3] = ["#hera11#...Why does your glove have to be so sexy!? I could last longer if you weren't so... so <name>-y! Gwehh!"];
	}

	public static function snarkyBeads(tree:Array<Array<Object>>)
	{
		tree[0] = ["#hera09#Anal beads? ...Ohh... ...you're still holding onto those? Ecchh~"];
		tree[1] = ["#hera11#...Can't we just do something else?"];
	}

	public static function denDialog(sexyState:HeraSexyState = null, victory:Bool = false):DenDialog
	{
		var denDialog:DenDialog = new DenDialog();

		denDialog.setGameGreeting([
			"#hera08#Ah <name>! I'm sorry! I'm sorry you had to pay " + moneyString(PlayerData.denCost) + " to hang out with me today. But I'll make it up to you!",
			"#hera05#We can play... we can play as many games of <minigame> as you want! And... I'll try to let you win! ...Even though I'm sort of great at it!"
		]);

		if (PlayerData.pokemonLibido == 1)
		{
			denDialog.setSexGreeting([
				"#hera02#Okay, remember... This one's going up on the internet! So make me look good!",
				"#hera05#... ...I forget, did I ever give you my pokevideos.com account name? Hmm...",
				"#hera00#...Oh, maybe I'll tell you some other time... ...",
			]);
		}
		else {
			denDialog.setSexGreeting([
				"#hera02#Okay, remember... This one's going up on the internet! So make me look good!",
				"#hera05#... ...I forget, did I ever give you my pokepornlive.com account name? Hmm...",
				"#hera00#...Oh, maybe I'll tell you some other time... ...",
			]);
		}

		if (PlayerData.denSexCount >= 2)
		{
			denDialog.addRepeatSexGreeting([
				"#hera00#If you want to look these videos up later, they'll be online under \"Megahorn69\". But, give it a few minutes! Sometimes the web site is a little slow to upload.",
				"#hera11#Gah! And don't tell anybody else my username. It's kind of a secret!",
			]);
		}
		else {
			denDialog.addRepeatSexGreeting([
				"#hera04#If you want to look these videos up later, give it a few minutes! Sometimes they don't show up right when I upload them.",
				"#hera11#Gah! And if you DO happen to find them, try to keep my my username a secret, okay? ...Nobody else here really knows I'm on that site!",
			]);
		}
		denDialog.addRepeatSexGreeting([
			"#hera00#Hah... Hehh... Wow...",
			"#hera01#<name>, why can't we do this every day?",
		]);
		denDialog.addRepeatSexGreeting([
			"#hera01#Hmm shopkeeping's nice, but I could get used to thiiisss... ...Is there some kind of job where all you do is have sex all day?",
			"#hera11#Well I mean... not THAT job!"
		]);
		denDialog.addRepeatSexGreeting([
			"#hera05#Gweh! ...My nerves are finally starting to calm down! ...Did you notice? Don't I seem a little different...",
			"#hera04#I mean, I feel different! Feel my face. Doesn't that feel cooler to you?"
		]);
		if (PlayerData.recentChatTime("hera.sexyBeforeChats.3") <= 800)
		{
			if (PlayerData.denSexCount <= 20)
			{
				denDialog.addRepeatSexGreeting([
					"#hera04#<name>, I've still never masturbated more than a hundred times in one day.",
					"#hera05#But this counts, doesn't it? I mean, it's with a hand! ...Someone else's hand... I say it counts!",
					"#hera01#Anyway we're up to how many? " + englishNumber(PlayerData.denSexCount) + "? ...Well I guess we have a ways to go. Gweheheh~",
				]);
			}
			else if (PlayerData.denSexCount >= 20 && PlayerData.denSexCount < 100)
			{
				denDialog.addRepeatSexGreeting([
												   "#hera04#<name>, I've still never masturbated more than a hundred times in one day.",
												   "#hera05#But this counts, doesn't it? I mean, it's with a hand! ...Someone else's hand... I say it counts!",
												   "#hera01#Anyway we're up to how many? " + englishNumber(PlayerData.denSexCount) + "? ...",
												   "#hera07#... ...Wait, are you actually going to try and break 100!?! ..." + stretch(PlayerData.name) + " that's so weeeeird~",
											   ]);
			}
			else
			{
				// the mechanics of the game should forbid breaking 100... but just in case...
				denDialog.addRepeatSexGreeting([
												   "#hera07#I... I can't believe we actually did this " + englishNumber(PlayerData.denSexCount) + " times in one day...",
												   "#hera04#I'd like to thank the Academy... And Abra for letting me slack off at work... Kecleon, for covering my shift all those times...",
												   "#hera00#Oh and um, of course I couldn't have done this without you, <name>~ ... ...",
												   "#hera00#Now can we do something else? My " + (PlayerData.heraMale ? "thingy" : "you-know-what") +" is sort of starting to chafe!",
											   ]);
			}
		}
		else {
			denDialog.addRepeatSexGreeting([
				"#hera01#<name>, I've still never orgasmed more than a hundred times in one day, you know...",
				"#hera10#...Wait, did we talk about that? The one hundred thing? ...Did I have that conversation with someone else?",
				"#hera11#Gweehh! ...Awkwaaard!!!",
			]);
		}

		denDialog.setTooManyGames([
			"#hera10#Gweh! I just remembered I was expecting a package today!",
			"#hera04#Sorry, I should probably go check if it's waiting on the front step. ...I can't always hear the doorbell down here.",
			"#hera03#Thanks for playing with me so much <name>! ...You really know how to make a bug feel special~",
		]);

		denDialog.setTooMuchSex([
			"#hera06#Is that... Is that it? Am I empty? I think... (jiggle, jiggle) ...Gwehhhhhh... ...",
			"#hera04#...Sorry <name> I think I might literally have NOTHING left. We'll have to postpone our little Heracross video series until next week.",
			"#hera02#Gweh-heheheh! Hey, sometimes shooting these projects takes months. It's a marathon, not a sprint! I'll see you next time, <name>~",
		]);

		denDialog.addReplayMinigame([
			"#hera03#I love playing these little games Abra came up with! ...But I especially love playing them with you, <name>. You're such a fun opponent!",
			"#hera04#Did you have time to play more today? Or... There's other stuff we could do back here toooooo~",
		],[
			"Let's practice\nmore",
			"#hera02#Yeah! Let's get you super prepared for the real thing~",
		],[
			"Other stuff?\nHmmmmm...",
			"#hera06#Oh you know, nothing in particular! Just whatever springs to mind.",
			"#hera02#Ooh! I know! I know! Something just sprang to MY mind!"
		],[
			"Actually\nI think I\nshould go",
			"#hera08#Aww gweh! Okay. Only so many hours in a day I guess~",
			"#hera05#Well thanks for paying old Heracross a visit. I had fun today! See you around, <name>~",
		]);
		denDialog.addReplayMinigame([
			"#hera06#You think you're getting the hang of it? You ready for me to turn my little Heracross dial up to eleven? Gweh-heheheh~",
			"#hera01#Or you know... There's always other Heracross dials you could play with~",
		],[
			"You're going down\nthis time!",
			"#hera02#Gweheheheh! That's what you think!",
			"#hera10#Wait, you did mean, \"going down\" gamewise right? Because obviously I can't...",
			"#hera04#...Yeah, okay! Let's play~",
		],[
			"Ooh! What kind\nof dials~",
			"#hera02#Oooooh! You don't knowwwwww? ...Sounds like it's time to do a little show-and-tell. Gweheheheheh~",
		],[
			"I think I'll\ncall it a day",
			"#hera08#Call it a daaaayyyyy? Aww, gweh! Gwehhh....",
			"#hera05#Well thanks for paying old Heracross a visit. I had fun today! See you around, <name>~",
		]);
		denDialog.addReplayMinigame([
			"#hera04#Well that was fun! You're turning into a... fierce little minigame monster aren't you? Roar!",
			"#hera05#Did you want a rematch? Or... does the monster need a break?",
		],[
			"I want a\nrematch!",
			"#hera06#Oh sounds fun! Although you know... I can be kind of a monster too!",
			"#hera15#...Heracross, mega-evolution! Roar!! ROARRRRRRRR!!!!",
			"#hera02#Gweheheheh! I'm really going to bring the heat this time. I hope you're ready!!",
		],[
			"Roar! Monster\nneed break!",
			"#hera02#Gweheheheh! Come on, you're not the bad grammar monster!",
			"#hera03#Okay okay, why you scooch on over here and show me some of the minigame monster's moves~",
		],[
			"Hmm, I\nshould go",
			"#hera11#Gweh! I hate it when the monster potion wears off too quickly.",
			"#hera05#Oh well, thanks for paying old Heracross a visit. I had fun today! See you around, <name>~",
		]);

		denDialog.addReplaySex([
			"#hera04#Hahh... Oh, <name>... That was... That was great! But...",
			"#hera06#Well, I guess I should get back to the store. ...Ugh! Bummeroo~",
			"#hera05#...",
			"#hera03#Gwehh you know what, screw the store! Let's go again~",
		],[
			"Yeah! Let's\ngo again",
			"#hera02#Gweheheh! Okay, I'll just... I'll just be one second, I want to make sure nobody's stealing anything...",
		],[
			"Maybe you should\ngo back...",
			"#hera09#Well fiiiiine, I guess that's the respooooonsible thing to do... Gwehhhhh...",
			"#hera11#<name>, I hate it when you're right! But well,",
			"#hera00#Thanks for hanging out with me today. ...I don't take enough breaks and, well... Just thanks~",
		]);
		denDialog.addReplaySex([
			"#hera01#Sweet silk pajamas! Those were some fancy little techniques. ...Mmmm... Say, I'm going to go grab a glass of water and check on the store,",
			"#hera00#It should just be like, two minutes! Is that okay? Can you wait two minutes?",
		],[
			"Yeah! I'll\nbe here~",
			"#hera02#Gweh! Yay! ...I was worried you'd leave. Okay! I'll be back in just ONE second!",
			"#hera10#...One figurative second! A hundred and twenty real seconds! Maybe a little more! ...And... And these seconds don't count!",
		],[
			"I should\nprobably go...",
			"#hera08#Awwww cocoa puffs. I understaaand...",
			"#hera05#Well this was still nice, <name>. ...I don't take enough breaks and, well... Just thanks~",
		]);
		denDialog.addReplaySex([
			"#hera06#Ahhh. Well... Break time's over, <name>. Fun's fun but I need to keep an eye on my little store!",
			"#hera11#...Actually... Gweh! I can probably... Yeah! Okay,",
			"#hera10#Just give me a second, I'm going to grab a little snack and take a quick peek and I'll be right back after! Can you wait for me?",
		],[
			"I can\nwait!",
			"#hera03#Yayyyy! Really? Okay, I'll just be a second! I... I just need to check on a few things!",
		],[
			"Oh, I think\nI'll head out...",
			"#hera08#Awwww cocoa puffs. I understaaand...",
			"#hera05#Well this was still nice, <name>. ...I don't take enough breaks and, well... Just thanks~",
		]);

		return denDialog;
	}

	public static function cursorSmell(tree:Array<Array<Object>>, sexyState:HeraSexyState)
	{
		var count:Int = PlayerData.recentChatCount("hera.cursorSmell");

		if (count == 0)
		{
			tree[0] = ["#hera10#Okey dokey! Well, the cameras are rolling, so... (sniff) so, let's put on a good, ehhhh (sniff, sniff)..."];
			tree[1] = ["#hera09#Wait, <name>, is that you!? (sniff) Is that me or is that you!? (sniff, sniff)"];
			tree[2] = ["#hera11#Because one of us smells like... Ecchhh! It smells like that time I poured that rotten kimchi down the garbage disposal... It's... It's so gross!"];
			tree[3] = ["#hera10#... ...Is this maybe... Is this what Grimer's insides smell like? ...Agh! ..." + stretch(PlayerData.name) + "!!!"];
		}
		else
		{
			tree[0] = ["#hera10#Okey dokey! (sniff) Well, the cameras are rolling, so let's... ... (sniff, sniff)..."];
			tree[1] = ["#hera11#Aaagh! Not Grimer again! ...Can't you space us out a little?"];
			tree[2] = ["#hera09#Like maybeeeeeee... Grimer can be your 6:00 a.m appointment... And you and I can get together at 8:00 p.m? ... ...After you've had a hundred bubble baths?"];
			tree[3] = ["#hera11#Gweeehhhh! " + stretch(PlayerData.name) + "!!! It smells so baaaaaaaaaaad..."];
		}
	}
}