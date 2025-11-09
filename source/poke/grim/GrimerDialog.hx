package poke.grim;

import critter.Critter;
import flixel.FlxG;
import minigame.GameDialog;
import minigame.MinigameState;
import minigame.scale.ScaleGameState;
import minigame.stair.StairGameState;
import openfl.utils.Object;
import puzzle.ClueDialog;
import puzzle.PuzzleState;
import MmStringTools.*;

/**
 * Grimer is canonically female. Abra invited her over to her house a few
 * times, because she feels pity for grimer because Grimer doesn't have many
 * friends. Abra feels empathy for this, because as she feels herself growing
 * more distant from her friends -- she realizes some day she might end up sort
 * of like Grimer. Since then, Grimer has continued inviting herself over. Abra
 * tolerates her coming over, but can't stand the smell. She usually locks
 * herself in her room when she anticipates a visit.
 * 
 * Abra and the crew are sort of Grimer's best friends, but she's not their
 * best friend.
 * 
 * Grimer knows she smells bad so she tries not to come over very often.
 * 
 * If you buy her a gift he'll come over more. You first have to feed her a
 * dildo (the translucent green one) or the anal beads (the small purple ones)
 * and then wait for her to show up again, and she'll be apologetic. She's not
 * always hungry -- her "toy meter" has to be in the yellow zone. This is
 * influenced by incense if you want to make her hungry more often
 * 
 * If she eats an item, she'll reimburse you about 50% more than you paid for
 * the item, so you can earn a little extra money this way. But, if you keep on
 * feeding her, she'll catch on and realize it's not an accident! But she'll
 * still eat~
 * 
 * As far as minigames go, Grimer is pretty good at the stair game, but she'll
 * never pick "1" for the odds and evens game. So you can always go first if
 * you pick 1. She's pretty bad at both of the other minigames. Her goopy hands
 * make it hard for her to manipulate the bugs.
 * 
 * ---
 * 
 * When writing dialog, I think it's good to have an inner voice in your head
 * for each character so that they behave and speak consistently. Grimer's
 * inner voice was Rocky Robinson from The Adventures Of Gumball. (Or Bert from
 * Sesame Street.)
 * 
 * Vocal tics: Gwohohohoho! Gwohh-hohohohoh! Gwohohohorf~
 * Awkward pauses: glarp, barp, glop, blop, gloop, bloop, glurp, blorp, etc...
 * 
 * What does Grimer smell like?
 *  * (is someone cooking soup?)
 *  * (burnt popcorn)
 *  * (someone left a curling iron on?)
 *  * (can someone take out the garbage?)
 *  * (spilled vinegar)
 *  * bad milk or good cheese
 *  - pot smoke
 *  * fresh mulch
 * 
 * Weird body parts?
 *  - globular peptic ventricle
 *  - thiolic artery (ok)
 *  - jejunal bulb (bad)
 *  - mercaptanary polyp (bad)
 *  - orbicular phlegm valve (good)
 *  - pharynic cavity (good)
 *  - salivary lumpus (good)
 *
 * Goo puns:
 *  - (Way to goo)
 *  - (Goo morning, Goo afternoon, Goo evening)
 *  - (Goo job)
 * 
 * Abysmal at puzzles (rank 9)
 */
class GrimerDialog
{
	public static var prefix:String = "grim";

	public static var sexyBeforeChats:Array<Dynamic> = [sexyBefore0, sexyBefore1, sexyBefore2, sexyBefore3];
	public static var sexyAfterChats:Array<Dynamic> = [sexyAfter0, sexyAfter1, sexyAfter2];
	public static var sexyBeforeBad:Array<Dynamic> = [sexyBadPolyp, sexyBadBulb, sexyBadArtery, sexyBadMisc0, sexyBadMisc1, sexyBadNoInteract];
	public static var sexyAfterGood:Array<Dynamic> = [sexyAfterGood0, sexyAfterGood1, sexyAfterGood2];
	public static var fixedChats:Array<Dynamic> = [charmeleon, stinkBuddies];
	public static var randomChats:Array<Array<Dynamic>> = [
				[random00, random01, random02, random03, sorryIAteYourDildo04],
				[random10, random11, random12],
				[random20, random21, random22],
			];

	public static function getUnlockedChats():Map<String, Bool>
	{
		var unlockedChats:Map<String, Bool> = new Map<String, Bool>();
		if (PlayerData.grimMoneyOwed > 0)
		{
			// grimer owes us money; mandatory apology
			for (i in 0...randomChats[0].length)
			{
				unlockedChats["grim.randomChats.0." + i] = false;
			}
			unlockedChats["grim.randomChats.0.4"] = true;
		}
		else {
			// grimer doesn't owe us money; don't apologize
			unlockedChats["grim.randomChats.0.4"] = false;
		}
		if (!PlayerData.grimTouched)
		{
			// only do the first chat...
			for (i in 0...sexyBeforeChats.length)
			{
				unlockedChats["grim.sexyBeforeChats." + i] = false;
			}
			unlockedChats["grim.sexyBeforeChats.0"] = true;
		}
		return unlockedChats;
	}

	public static function sexyBadPolyp(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		tree[0] = ["#grim04#So just really quick, a little crash course in Grimer anatomy... Sorry! Sorry about this. It's just something small..."];
		tree[1] = ["#grim05#...But there's that little dangly thing over by my arm that sorta... hangs down and feels like a wet sack of spaghetti?"];
		tree[2] = ["#grim06#That's my mercaptanary polyp and it's sort of, hrrrmmmm..."];
		tree[3] = ["#grim04#It's sort of like the anatomical equivalent of the errr, sphincteric lung that humans have."];
		tree[4] = [20, 40, 30, 10];

		tree[10] = ["Sphincteric\nlung?"];
		tree[11] = ["#grim02#Yeah! ...Blop! The sphincteric lung, it's that organ that sucks air into your butt when you sneeze? You know which one I'm talking about! Maybe I'm saying it wrong..."];
		tree[12] = [100];

		tree[20] = ["I don't have\none of those..."];
		tree[21] = ["#grim02#You don't!? ...Blop! It's the hrrmmmm... maybe I'm saying it wrong, it's that organ that sucks air into your butt when you sneeze? You know which one I'm talking about!"];
		tree[22] = [100];

		tree[30] = ["Uhh?"];
		tree[31] = ["#grim02#You know, your sphincteric lung! ...Blop! It's that organ that sucks air into your butt when you sneeze? You know which one I'm talking about! Maybe I'm saying it wrong..."];
		tree[32] = [100];

		tree[40] = ["...In\nhumans?"];
		tree[41] = ["#grim02#Yeah, all you humans got one! ...Blop! It's that organ that sucks air into your butt when you sneeze? You know which one I'm talking about! Maybe I'm saying it wrong..."];
		tree[42] = [100];

		tree[100] = ["#grim05#But anyway my mercaptanary polyp isn't particularly sensitive or anything so don't focus on it too much."];
		tree[101] = ["#grim03#Other than that you're doing great! ...I know there's a lot of weird foreign stuff buried in there, so just try to have fun exploring~"];
	}

	public static function sexyBadBulb(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		tree[0] = ["#grim00#Mmm finally! No more puzzles~"];
		tree[1] = ["#grim06#Now, just so you sort of know what you're touching in there... Hrrmmm..."];
		tree[2] = ["#grim05#So there's this little thingy that sticks out a little. Blorp... It probably feels a little like, err... like one of your human nipples?"];
		tree[3] = ["#grim04#It's not a nipple though, it's my jejunal bulb. It feeds peptic mucus into my jejunum so... you poking at it, it's kind of... ..."];
		tree[4] = ["#grim06#...It's kind of like you're picking my nose. ...I mean, I don't hate it? But I don't really enjoy it either."];
		tree[5] = ["#grim05#There's just way better stuff you can be poking, okay?"];
		tree[6] = ["#grim02#Sorry! Sorry for nitpicking. You're doing great! ...I know I'm kind of throwing you in the deep end here."];
	}

	public static function sexyBadArtery(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		tree[0] = ["#grim00#You know the best part about being with a Grimer is well... You don't gotta worry about getting me prepped or anything!"];
		tree[1] = ["#grim06#The worst part though, is that nobody seems to really know what they're doing down there...."];
		tree[2] = ["#grim05#Like there's that thick hardened chunk of fleshy sludge that runs sorta horizontal, and connects with my outer muculoid lining?"];
		tree[3] = ["#grim04#...That's ehh, that's my thiolic artery, and it doesn't really do anything for me when people rub it."];
		tree[4] = ["#grim06#Oh! No, I don't think it's anything YOU did! ...Did you touch that thing before? I don't remember. Sorry! Not you! I'm just..."];
		tree[5] = ["#grim00#It's just... don't worry, you're... you're doing amazing! I love our time together. ...It's kind of why I felt comfortable opening up about that."];
		tree[6] = ["#grim01#... ...And... this clumsy squishy sex is just the icing on my little <name> cake~"];
	}

	public static function sexyBadMisc0(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		if (sexyState.grimerMood1 != 2)
		{
			tree[0] = ["#grim03#Oh! Time for another hands-on lesson on Grimer anatomy, hmm? Groh-hohohohoho~"];
			tree[1] = ["#grim04#You know, SOME Grimers, err... Not me personally! But... sometimes..."];
			tree[2] = ["#grim00#Some Grimers kind of like it when you rub their um... salivary lumpus? It's that, little dangly thing it's errr, well it's sort of hidden..."];
			tree[3] = ["#grim01#Just... Just trust me okay? You find a Grimer's salivary lumpus, give it a couple of good squeezes... You'll have a friend for life~"];
		}
		else
		{
			tree[0] = ["#grim03#Oh! Time for another hands-on lesson on Grimer anatomy, hmm? Groh-hohohohoho~"];
			tree[1] = ["#grim05#Well, if you can somehow manage to find the, errr... the orbicular phlegm valve while you're in there? How do I describe it... Hrrmmm..."];
			tree[2] = ["#grim00#It's sort of this... tomato-sized protrusion around my abdomen area? It's vestigial in nature, but it's got a whole bunch of nerve endings..."];
			tree[3] = ["#grim01#And... oh my goo, if you can give that thing a few good squeezes I'll just become like... putty in your hands~"];
			tree[4] = ["#grim02#Errr, metaphorical putty! ...You know what I meant~"];
		}
	}

	public static function sexyBadMisc1(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		if (sexyState.grimerMood1 != 0)
		{
			tree[0] = ["#grim01#Oh boy! Time to do a little goo spelunking right? HRRrrmmmmm... hrrmmm hrrmmm hrrmmm..."];
			tree[1] = ["#grim00#You know, while you're down there if your fingers happen to brush past my phyrinic cavity... You could do some exploring in that area~"];
			tree[2] = ["#grim04#It's a pretty tight squeeze. My big fat fingers won't fit! But I think yours might be about the right size."];
			tree[3] = ["#grim06#I mean... gloop~ You don't have to do it if you don't want,"];
			tree[4] = ["#grim01#...But that is an especially nice place for fingers to go. Grrr-hrhrhrhrh~"];
		}
		else
		{
			tree[0] = ["#grim01#Oh boy! Time to do a little goo spelunking right? HRRrrmmmmm... hrrmmm hrrmmm hrrmmm..."];
			tree[1] = ["#grim00#Well, if you can somehow manage to find the, errr... the orbicular phlegm valve while you're in there? How do I describe it... Hrrmmm..."];
			tree[2] = ["#grim06#It's sort of this... tomato-sized protrusion around my abdomen area? It's vestigial in nature, but it's got a whole bunch of nerve endings..."];
			tree[3] = ["#grim01#And... oh my goo, if you can give that thing a few good squeezes I'll just become like... putty in your hands~"];
			tree[4] = ["#grim02#Errr, metaphorical putty! ...You know what I meant~"];
		}
	}

	public static function sexyBadNoInteract(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		tree[0] = ["#grim00#Mmm, that was a nice little mud massage you gave me last time! I could go for another one of those today~"];
		tree[1] = ["#grim05#Although ehh, don't be afraid to maybe get your hands a little dirtier, hmmmm???"];
		tree[2] = ["#grim01#There's a lot of fun Grimer stuff under the surface that your hand just sort of brushed past last time you were in there."];
		tree[3] = ["#grim00#...Stuff you can you know... Grab at, or poke at... Grrr-hrhrhrr~"];
		tree[4] = ["#self04#(Hmm? ...Oh, come to think of it, I did feel something strange when my hand was buried deep inside his goop.)"];
		tree[5] = ["#self05#(Maybe I should try clicking underneath the goop where those exclamation points are. ...Maybe there's actually something in there.)"];

		if (!PlayerData.grimMale)
		{
			DialogTree.replace(tree, 5, "inside his", "inside her");
		}
	}

	public static function sexyBefore0(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		var count:Int = PlayerData.recentChatCount("grim.sexyBeforeChats.0");

		if (!PlayerData.grimTouched)
		{
			if (count == 0)
			{
				tree[0] = ["#grim09#So, did you really want to err...? I mean, you don't... ...you don't gotta do anything if it makes you uncomfortable."];
				tree[1] = ["#grim08#There's sort of a saying among us garbage Pokemon, hrrmmm, how does it go..."];
				tree[2] = ["#grim06#Something like, \"You can pull something out of the garbage, but you can't un-throw it away.\" You get it?"];
				tree[3] = ["#grim08#It means... once something's garbage, it's garbage forever. It's a line you can't un-cross, and some Pokemon here are probably going to judge you for it."];
				tree[4] = ["#grim06#... ..."];
				tree[5] = ["#grim05#So... err... yeah!! ...If you don't wanna go through with it, there's your out. No hard feelings, right? We're still friends~"];
			}
			else
			{
				if (count % 3 == 0)
				{
					tree[0] = ["#grim02#Anyway thanks! It was nice seeing you again <name>..."];
					tree[1] = ["#grim06#Maybe someday we can err... ..."];
					tree[2] = ["#grim04#... ...It was just nice getting to hang out with you, okay? Let's do this again soon~"];
				}
				else if (count % 3 == 1)
				{
					tree[0] = ["#grim02#Aww leaving soo soon? Awww no, no, it's okay, I understand."];
					tree[1] = ["#grim03#Better get out of here before someone catches you, right? Gro-hohohohorf~"];
					tree[2] = ["#grim04#Err, take it easy <name>."];
				}
				else
				{
					tree[0] = ["#grim02#Err, wellp! That was fun."];
					tree[1] = ["#grim06#Is that it? Unless you wanted to, well... I mean... ..."];
					tree[2] = ["#grim04#...Well, you take it easy <name>~"];
				}
			}
		}
		else
		{
			tree[0] = ["#grim01#Oh boy! Time to do a little goo spelunking right? HRRrrmmmmm... hrrmmm hrrmmm hrrmmm..."];
			tree[1] = ["#grim00#...Well why don't we see what kind of treasures you turn up this time~"];
		}
	}

	public static function sexyBefore1(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		tree[0] = ["#grim00#Mmmmm finally! No more puzzles. Now it's just just to relaaax..."];
		tree[1] = ["#grim01#...Hey err, why don't you relax over here with me!! ...My goo's all nice and comfy womfy warm. C'monnn~"];
	}

	public static function sexyBefore2(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		tree[0] = ["#grim02#You know the best part about being with a Grimer is well... You don't gotta worry about getting me prepped or anything!"];
		tree[1] = ["#grim03#...'Cause I'm like... REALLY stretchy and everything self lubricates!"];
		tree[2] = ["#grim01#But heyyyyy a little prep work can still be fun now and then.... Hrrrr-hrhrhrhrmmmm! ... ...What are you thinking?"];
	}

	public static function sexyBefore3(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		tree[0] = ["#grim03#Oh! Time for another hands-on lesson on Grimer anatomy, hmm? Groh-hohohohoho~"];
		tree[1] = ["#grim00#Just... reach in there and grab something, and I'll call out what it is! ...Y'know, like a big stinky speak-and-spell~"];
	}

	public static function sexyAfter0(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		tree[0] = ["#grim00#Gwahhhhh.... Wow... Not bad for an amateur~"];
		tree[1] = ["#grim06#You know, don't take this the wrong way, <name>... But I bet you could stick your arms in puddles of stinky goo for money!!"];
		tree[2] = ["#grim02#I mean... I think people would pay you a lot for that! You're REALLY good at it."];
		tree[3] = ["#grim04#... ...But err... anyway, it's been fun! Come grab me if you're free again, okay?"];
	}

	public static function sexyAfter1(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		if (PlayerData.justFinishedMinigame)
		{
			tree[0] = ["#grim08#Mmmmm... wait a minute. No more puzzles... The minigame's over... And we just finished doing our sex..."];
		}
		else
		{
			tree[0] = ["#grim08#Mmmmm... wait a minute. No more puzzles... And we just finished doing our sex..."];
		}
		tree[1] = ["#grim12#Does that mean... are we out of stuff to do!?! Awww! That STINKS!!"];
		tree[2] = ["#grim06#... ...Well err, I guess there's always next time, right? ...But anyway... Hrrmmm..."];
		tree[3] = ["#grim02#...Thanks for setting aside some time to fraternize with a stinky skub like your pal Grimer over here. It means a lot, <name>."];
		tree[4] = ["#grim01#I hope I can see you again soon! Bloop~"];
	}

	public static function sexyAfter2(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		tree[0] = ["#grim00#Ooogh.... yeah... Well, we're going to want to get that off the floor before it leaves a permanent stain."];
		tree[1] = ["#grim06#...I think I saw some white vinegar in the kitchen. ...Glurp? If I can just find a spray bottle... Hrrmmm..."];
		tree[2] = ["%fun-alpha0%"];
		tree[3] = ["#grim02#Hey don't worry about cleanup, I got it! ...It was nice seeing you again, <name>."];
		tree[4] = ["#grim01#This was... This was a really good day for me. You're the best~"];

		tree[10000] = ["%fun-alpha0%"];
	}

	public static function sexyAfterGood0(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		tree[0] = ["#grim01#Gugahh.... That was... Gwah.... Oh my gooness..."];
		tree[1] = ["#grim00#<name>, I don't think you know what you just did. ...But it was disgusting, and I loved it~"];
		tree[2] = ["#grim01#Mmhmhmhmhm... Just, next time, just... JUST like that. That was amazing... Mmmm~"];
	}

	public static function sexyAfterGood1(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		tree[0] = ["#grim01#<name>, that... nngh... You just, grrgh... you really... blrrggl..."];
		tree[1] = ["#grim00#I've seen internet shock sites dedicated to tamer stuff than what you just did. If you had ANY idea where your fingers just were... Oh my goo~"];
		tree[2] = ["#grim01#You know <name>, maybe the less you know the better. ....blrrrrrrphtt~"];
	}

	public static function sexyAfterGood2(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		tree[0] = ["#grim01#Grrrggghghgh.... <name>, you... you just... rrgh... gooness gracious... graagh..."];
		tree[1] = ["#grim00#I think you just bottomed out any purity test you were planning on taking! Do you, err... Do you have ANY idea where your fingers just were? Ehheheh~"];
		tree[2] = ["#grim01#Not that I mind but... graagh! That was SO filthy, I'm blushing just thinking about it... Mmmmnghh..."];
	}

	public static function clueBad(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var clueDialog:ClueDialog = new ClueDialog(tree, puzzleState);
		clueDialog.setGreetings(["#grim05#Yeah, errr... There's something wrong if you look at that <first clue>! It's obvious now, right?",
								 "#grim06#Wait a minute, errr... That <first clue> doesn't work with your answer, does it?",
								 "#grim06#There's a big shiny light on that <first clue>... Does that mean something?",
								]);
		clueDialog.setQuestions(["Huh?", "I don't\nget it", "What?", "...Really?"]);
		if (clueDialog.actualCount > clueDialog.expectedCount)
		{
			clueDialog.pushExplanation("#grim04#So yeah, looking at that <first clue>, your answer's got too many <bugs in the correct position>.");
			clueDialog.pushExplanation("#grim05#The clue's got like, <e hearts> right? So you should only have <e bugs in the correct position>, but you've got <a>.");
			clueDialog.fixExplanation("should only have zero", "shouldn't have any");
			clueDialog.pushExplanation("#grim06#That's uhh. I can't really help you any more than that, this stuff's sorta beyond me. ...But we can go ask Abra for help if you want.");
		}
		else
		{
			clueDialog.pushExplanation("#grim04#So yeah, looking at that <first clue>, your answer needs more <bugs in the correct position>.");
			clueDialog.pushExplanation("#grim05#The clue's got like, <e hearts> right? So you should have <e bugs in the correct position>, but you've only got <a>.");
			clueDialog.fixExplanation("you've only got zero", "you don't have any");
			clueDialog.pushExplanation("#grim06#That's uhh. I can't really help you any more than that, this stuff's sorta beyond me. ...But we can go ask Abra for help if you want.");
		}
	}

	static private function newHelpDialog(tree:Array<Array<Object>>, puzzleState:PuzzleState, minigame:Bool=false):HelpDialog
	{
		var helpDialog:HelpDialog = new HelpDialog(tree, puzzleState);
		helpDialog.greetings = [
			"#grim04#Oh hey <name>! ...Did you need something?",
			"#grim04#What's up! ...Blorp! Did you need my help?",
			"#grim04#Aww hey <name>! ...Anything you need?",
		];

		helpDialog.goodbyes = [
			"#grim08#Oh err, yeah! Going to get some fresh air? I know how it is.",
			"#grim08#Aww really? Don't tell me the smell is getting to you, too!",
			"#grim08#Aww, well maybe we can finish this another time. ...I mean, if you're free...",
		];

		helpDialog.neverminds = [
			"#grim03#Any excuse to talk to your little Grimer pal, is that it? Gwo-hohohorf!",
			"#grim03#Quit getting distracted, this is serious stuff! Gwo-hohohohorf!",
			"#grim03#... ...Barp!",
		];

		helpDialog.hints = [
			"#grim06#A hint? Uhh, don't look at me! I'm awful at this stuff. Let me see if Abra's around.",
			"#grim06#I don't... see... anybody around? But let me see if Abra's in his room, I bet he can help...",
			"#grim06#Err yeah! I'll go bug Abra about getting a hint or two. Be right back..."
		];

		if (!PlayerData.abraMale)
		{
			helpDialog.hints[1] = StringTools.replace(helpDialog.hints[0], "bet he", "bet she");
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
		tree[0] = ["#grim02#Aaaaaa wow! A bonus coin? A bonus cooooooin!!!"];
		tree[1] = ["#grim03#Let's see what sort of fun bonus game we get to play. ...I like never get to play these!"];
	}

	public static function gameDialog(gameStateClass:Class<MinigameState>)
	{
		var manColor:String = Critter.CRITTER_COLORS[0].english;
		var comColor:String = Critter.CRITTER_COLORS[1].english;

		var g:GameDialog = new GameDialog(gameStateClass);

		g.addSkipMinigame(["#grim04#Huh okay! I'm sorta out of practice anyway. Maybe we can play another time!", "#grim01#Besides, this'll give us a little extra time to... Gwohh-hohohohohorf~", "#grim06#You're not going to skip out on THAT, right!? ...That's the most important part!"]);
		g.addSkipMinigame(["#grim04#Aww really? I was sorta looking forward to this one!", "#grim01#Although I was sorta looking forward to other stuff, too... Gwohh-hohohohohorf~", "#grim06#And you CAN'T skip that, can you?? ...Gee I sure hope Abra didn't make a skip button for that part!"]);

		g.addRemoteExplanationHandoff("#grim06#Err, well... I think I kinda know the rules, but not really well enough to explain them. Hrrmmm, where's <leader>...");

		g.addLocalExplanationHandoff("#grim05#Yeah! Can you explain this, <leader>? ...It might help jog my memory too.");

		g.addPostTutorialGameStart("#grim04#Did you get any of that, <name>? Maybe you can just pick it up as we go!");

		g.addIllSitOut("#grim05#Errr, you know, I've actually gotten pretty good at this game! You might have more fun if I sit out.");
		g.addIllSitOut("#grim05#I might let you play without me, if that's okay! ...I'm really good at it, and errr, it might suck out all the fun.");

		g.addFineIllPlay("#grim06#Hrrrmmm... Well okay! Maybe just look at it as a learning experience, okay? ...Don't worry about winning.");
		g.addFineIllPlay("#grim06#Mmmm, well I'll play if you really want me to! I'll try to go a little easy on you.");

		g.addGameAnnouncement("#grim03#Is this <minigame>? Oh neat! I've been meaning to get more practice at this one~");
		g.addGameAnnouncement("#grim03#Hey whoa, it's <minigame>!! ...Did Abra plan this? " + (PlayerData.abraMale ? "He" : "She") + " must have known I'd be playing today~");
		g.addGameAnnouncement("#grim03#<Minigame>? Oh neat, I haven't played this one in awhile! You've played it before, right?");

		if (PlayerData.denGameCount == 0)
		{
			g.addGameStartQuery("#grim05#Hrrmmm well... Is that it? Are you ready to start?");
			g.addGameStartQuery("#grim05#You remember the rules and everything, right?");
		}
		else
		{
			g.addGameStartQuery("#grim05#Hrrmmm well... Are you ready to start?");
			g.addGameStartQuery("#grim02#You're goo-ing down this time, <name>! Gwohh-hohohorf! Ready?");
		}
		g.addGameStartQuery("#grim03#You ready to goo? Err... go? Ready to go? Gwohohorf!");

		g.addRoundStart("#grim05#Time for round <round>! ...You ready?", ["Hmm, one\nsecond", "Alright", "Let's go!"]);
		g.addRoundStart("#grim04#Okay, round <round>, right? Let's go!", ["Oogh...", "Hmm okay", "I'm ready!"]);
		g.addRoundStart("#grim05#I guess that makes this... round <round>?", ["Yep", "Whenever\nyou're ready!", "Uhh..."]);
		g.addRoundStart("#grim04#Alright, let's start the next round!", ["Next\nround!", "Oh, okay", "..."]);

		g.addRoundWin("#grim02#Well what do you know! I didn't think I had that one~", ["Ugh, so\nlucky...", "Heh! You're\nreally good~", "Ack! That\nsurprised me"]);
		g.addRoundWin("#grim03#Score one more for grimer! ...Bloop! How are you holding up, <name>?", ["Ehh, I'll\nshake it off", "Wow, I didn't think\nyou'd be this good", "(sob)"]);
		g.addRoundWin("#grim04#Maybe it's all this brain food I've been eating! You know, calculators, microprocessors...", ["This is\ncrazy...", "Hey, calculators\nare cheating!", "Stop, you're\nmaking me hungry"]);
		if (FlxG.random.bool(40)) g.addRoundWin("#grim02#Sorry <name>! But it's like they say... the stinky wheel gets the grease!", ["You said it was\nthe sneaky wheel!!", "Isn't it the\nsqueaky wheel?", "It's not\nover yet..."]);

		g.addRoundLose("#grim13#Hey <leader>, are you cheating or something? ...You're wearing a choice scarf, aren't you? Take that thing off!", ["Is <leaderhe>\nreally!?|It's just a\nregular scarf~", "Heh! Heh! <leaderHe's>\njust fast...|Heh! Heh! I'm\njust fast...", "Hey! No\nhold items!|I'm not wearing\na scarf..."]);
		g.addRoundLose("#grim12#Hrrrmmm, wait a minute, that doesn't make sense... Can someone double-check that math?", ["I'm confused\ntoo...|What doesn't\nmake sense!?", "Do-over! I\nwant a do-over!|No do-overs,\nGrimer", "It's... REALLY\nsimple math"]);
		g.addRoundLose("#grim06#Ack! Leave some points for the rest of us!", ["C'mon, earn\nyour points!", "This scoreboard\nseems lopsided", "Yeah c'mon,\ngo easy!|Heh aww,\nI'll go easy"]);

		g.addWinning("#grim02#Wow! ...Glurp! ...Look at me, way up in the lead. I'm untouchable!", ["Gwooph", "Hey, I can\ntouch you...!", "Well, you're\na liquid so..."]);
		g.addWinning("#grim06#See <name>, the problem with your strategy is you need to be a little more fluid...", ["Hey, I'm\nplenty fluid", "I've had it with your\nanti-solid propaganda", "You're going\ndown, Grimer"]);
		g.addWinning("#grim03#Griii-mer! Griii-mer! Blorp! Blorp! Blorp! Griii-mer! Griii-mer! Blorp! Blorp! Blorp!", ["...Blorp...", "Can it,\ngoo face", "Hey! How come nobody\ncheers for me"]);
		g.addWinning("#grim03#Gwoh-hohohoh! Okay, I've proved my point. I'll drop it into first gear for a few laps~", ["First gear!? You'll\nblow out your\ntransmission", "How are you\nso good!?", "Wait, isn't first gear\nthe fast one?"]);

		g.addLosing("#grim10#Glrrggh... My brain feels like mush! And not the good kind of mush...", ["There's...\ngood mush?", "Hey, don't\ngive up yet", "We just need\nto practice more|You just need\nto practice more"]);
		g.addLosing("#grim07#I... I think I can still catch up! You're not that far ahead...", ["That gap is\nwidening, though...", "Yeah! We\ncan do it~|Yeah! You\ncan do it~", "Just give\nup already"]);
		g.addLosing("#grim06#Hrrrmmm... This is the part of the movie where the hero turns everything around, with some inspirational music...", ["...You mean a\nfuneral dirge?", "...Hey, I'M\nthe hero!", "I don't think it's\nthat kind of movie"]);
		g.addLosing("#grim08#Aww man! I really thought I'd win this. I'm usually really good when it comes to these games...", ["Hey, you're\ndoing well", "...Really?", "Yeah, <leader>'s\ntoo good...|I usually win,\ndon't feel bad"]);
		g.addLosing("#grim09#Ulggh... This really stinks. And... And not the good kind of stinks.", ["There's a\ngood kind?", "Hmm...|Heh heh~", "We can still\ncatch <leaderhim>|You're not out\nof it yet"]);

		g.addPlayerBeatMe(["#grim08#Aww well, that didn't go quite how I wanted but at least I've got a few new tricks in my arsenal thanks to you~", "#grim06#Hrmmm, wait weren't we forgetting about something? Arsenal... Arsenal... Things in my arsenal...", "#grim01#Oh yeah! Now I remember~"]);
		g.addPlayerBeatMe(["#grim06#Geez, you've been playing these games a LOT, haven't you <name>!? I mean I thought I'd practiced enough but...", "#grim05#...Well hey, good game! I've still got a lot to learn. Maybe next time we'll play something I'm better at~"]);

		if (gameStateClass == ScaleGameState || gameStateClass == StairGameState) g.addBeatPlayer(["#grim02#Didn't think Grimer could win, huh <name>? Thought " + (PlayerData.grimMale ? "his":"her") + " sludgy arms would be too slow and clumsy? ...Well, that's what you get for underestimating me!", "#grim03#...Yeah! Well now maybe next time you'll, err.... estimate me! Gwoh-hohohohorf~", "#grim05#Aww I'm just joking around. You played well. You'll get me back next time~"]);
		if (gameStateClass == StairGameState) g.addBeatPlayer(["#grim02#Didn't think Grimer could win, huh <name>? Thought " + (PlayerData.grimMale ? "his":"her") + " sludgy brain couldn't handle statistics? ...Well, that's what you get for underestimating me!", "#grim03#...Yeah! Well now maybe next time you'll, err.... estimate me! Gwoh-hohohohorf~", "#grim05#Aww I'm just joking around. You played well. You'll get me back next time~"]);
		g.addBeatPlayer(["#grim02#Woooo! Grimer is the wiinnerrrrr! Yeaaaaahhh!! ...Good game! Good game!!", "#grim00#Say, you know what would have made that an even BETTER game...?", "#grim03#If I'd beaten you by even MORE! Gwohhh-hohohoho! ...Hey! Remember the part where I WON!?"]);

		g.addShortWeWereBeaten("#grim05#Glarp! We'll get <leaderhim> next slime, <name>. <leaderHe> didn't win by that mush!");
		g.addShortWeWereBeaten("#grim04#Aww, well that was fun anyways. ...Glorp! I never get to spend enough time with you guys~");

		g.addShortPlayerBeatMe("#grim05#Eesh, you're really good, <name>! ...Beating you at this game is like trying to nail jelly to a tree!");
		g.addShortPlayerBeatMe("#grim02#Ack, that loss really shattered my confidence! ... ...Aaaand it's back! Glop! I want a rematch!");

		g.addStairOddsEvens("#grim06#So we usually throw odds and evens for start player! Is that alright? You can be odds, and I'll be evens.", ["Hmm, so\nI'm odds", "I'm\nready", "Yeah!"]);
		g.addStairOddsEvens("#grim06#You want to do odds and evens to see who goes first? You be odds, and I'll be evens.", ["Hmm, so I want\nthe total to be odd?", "Sure", "Let's go!"]);

		g.addStairPlayerStarts("#grim05#So you get to go first! ...Take your time. Think really, really hard about that \"2\" you're going to roll.", ["Uhh,\nwait...", "I might not\nroll a 2!", "Heh heh,\nwhatever"]);
		g.addStairPlayerStarts("#grim04#Whoops, I should have seen THAT coming! ...I guess you're going first then. Whenever you're ready!", ["Uhh, give me\na second", "Sweet!\nGood start~", "Okay,\nI'm ready"]);

		g.addStairComputerStarts("#grim04#Ahh! So I get to start, huh? Hrrrmmmm... Hrrrmmmm... Okay! I know what I'm throwing. Are you ready?", ["Yep! Ready", "Let me\nthink...", "Hmm okay"]);
		g.addStairComputerStarts("#grim05#So I'm first, right? Hrrrmmmm let me think... You wouldn't throw a zero on the first roll, would you?", ["I'm not\ntelling", "Hmm...", "I might,\nI'm CRAZY"]);

		g.addStairCheat("#grim12#Hey, c'mon! I wasn't born yesterday, we gotta throw them out at the same time. ...That means no peeking!", ["Uhh, sorry", "Hmmm... I guess I\nwas a little late", "What!? I didn't\ndo anything"]);
		g.addStairCheat("#grim06#Errrr, maybe I'll slow down a little. I feel like you sorta missed the buzzer on that one...", ["Did I? Hmm...", "Oh,\nmy bad", "What? Hey,\nc'mon"]);

		g.addStairReady("#grim04#Ready, <name>?", ["Let's\ngo!", "Hmmm...", "Yep!\nI'm ready"]);
		g.addStairReady("#grim05#You know what you're throwing?", ["Oof...", "I think\nso!", "Let's\ndo it"]);
		g.addStairReady("#grim04#Ready?", ["I think\nI'm ready!", "Yup", "Mmm,\nsure..."]);
		g.addStairReady("#grim05#Next roll! Ready?", ["Alright!", "Okay", "Oogh..."]);
		g.addStairReady("#grim06#Are you ready?", ["I think\nso!", "I'm ready", "Umm,\nsure?"]);

		g.addCloseGame("#grim07#Whoa! This is really anybody's game. ...I need to concentrate!", ["What's your move,\nslime boy?", "I've got\nyou now...", "Heh! This\nis fun~"]);
		g.addCloseGame("#grim06#You're kind of hard to read! I wish I could see your face, hrrmmm... Hrrrrmmmm...", ["What about\npalm reading?", "Your face\nis cute~", "You're tough\nto read, too"]);
		g.addCloseGame("#grim04#Boy! ...I still feel like this could go either way. What do you think?", ["I think it's\ngoing my way~", "Looks like it\nmight go your way...", "It's really too\nearly to tell"]);
		g.addCloseGame("#grim01#You're just ONE bad roll away from handing this game over to me on a silver platter! ...No pressure or anything~", ["What? You're\ncrazy", "The same could\nbe said for you", "We'll see,\nwe'll see~"]);

		g.addStairCapturedHuman("#grim01#And another little " + manColor + " guy is consumed by the blob... But in the end, the blob consumes all things! Groh-hohohohohorf~", ["Stop, you're\ncreeping me out", "Stop, you're\nturning me on~", "Stop, just...\njust stop"]);
		g.addStairCapturedHuman("#grim02#...Splat! What was that guy doing on my staircase? Go find your own staircase, little guy!", ["I think it\nwas a girl...?", "Oof, this\nisn't over", "Hey!\n...Rude!"]);
		g.addStairCapturedHuman("#grim03#What, you didn't think I was brave enough to put out a <computerthrow>? Gwoh-hohoho! Serves you right~", ["Oh, screw\nyou Grimer", "Brave enough? Or\nLUCKY enough", "Aww, man..."]);
		g.addStairCapturedHuman("#grim06#Oops! Sorry! I'm... I'm really sorry! ...I wanted to win, but I wasn't trying to be nasty. ...Errk! Sorry!!", ["Wahhh!", "Heh heh it's\nall good~", "...Tsk, you're\nnot sorry"]);

		g.addStairCapturedComputer("#grim11#Grahh! How... How in the WORLD did you see that coming!? I didn't think anybody would throw a <playerthrow>...", ["Well, I\nwould...", "I'm sneaky\nlike that~", "Heh heh\nheh!"]);
		g.addStairCapturedComputer("#grim08#What!? But... But... I was just... Bleaggghhhh...", ["Sorry? I don't\nspeak \"bleaggghhh\"", "Keep it together,\nGrimer", "Oogh, I'm\nsorry"]);
		g.addStairCapturedComputer("#grim06#That was... Wow!! Did you think that through or was that just a guess?", ["I thought\nit through", "Ehh, total\nguess", "Little from column A,\nlittle from column B"]);

		return g;
	}

	public static function charmeleon(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["%fun-charmeleon-instant%"];
			tree[1] = ["#char00#Hello? ...I thought I heard something. Is someone there?"];
			tree[2] = ["%fun-charmeleoff%"];
			tree[3] = ["#grim03#Oh wait, it WORKED? You clicked it! You really clicked it! Gwohhh-hohohohoho!"];
			tree[4] = ["#grim02#Sorry! I'm sorry about my little ruse. I know that was sort of sneaky. But it's like they say, the sneaky wheel gets the grease!"];
			tree[5] = ["#grim04#Plus I mean c'mon, not like anyone's going to click on a... skub like me when there's actual sexy Pokemon around. You get it, don't you?"];
			tree[6] = [20, 30, 40, 50];

			tree[20] = ["I wanted\nCharmeleon!"];
			tree[21] = ["#grim06#Well I mean, err... Yeah! Obviously Charmeleon's here too. Would that help? ...Yeah! I'll go get Charmeleon..."];
			tree[22] = ["%fun-alpha0%"];
			tree[23] = ["#zzzz04#..."];
			tree[24] = ["%fun-alpha1%"];
			tree[25] = [100];

			tree[30] = ["Aww, you're\ncute too"];
			tree[31] = ["#grim01#Guohohoho! Stop it, you're going to make the Charmeleon cutout jealous~"];
			tree[32] = ["#grim06#Speaking of which, hrrmmm...."];
			tree[33] = [100];

			tree[40] = ["Uhhh..."];
			tree[41] = ["#grim06#Well I mean, err... I was just messing with you! Of course Charmeleon's here. I'll go get him..."];
			tree[42] = ["%fun-alpha0%"];
			tree[43] = ["#zzzz04#..."];
			tree[44] = ["%fun-alpha1%"];
			tree[45] = [100];

			tree[50] = ["Hey, you\ntricked me"];
			tree[51] = ["#grim06#Well I mean, err... Yeah! Obviously Charmeleon's here too. Would that help? ...Yeah! I'll go get Charmeleon..."];
			tree[52] = ["%fun-alpha0%"];
			tree[53] = ["#zzzz04#..."];
			tree[54] = ["%fun-alpha1%"];
			tree[55] = [100];

			tree[100] = ["%fun-charmeleon%"];
			tree[101] = ["#char00#Charmeleon! Char! Errr.... Let's start this puzzle or something. Char!"];

			tree[10000] = ["%fun-charmeleon%"];
			tree[10001] = ["%fun-alpha1%"];
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["%fun-charmeleon-instant%"];
			tree[1] = ["#char01#Char! Char! That was like, really clever of you! Now I'm going to take off my, err..."];
			tree[2] = ["%fun-charmeleoff%"];
			tree[3] = ["#grim08#Hey are we really doing this? I can't exactly, you know, take the shirt off of a cardboard cutout..."];
			tree[4] = [20, 30, 40, 50];

			tree[20] = ["C'mon, you're\ndoing great!"];
			tree[21] = ["#grim06#Errr, really? Well okay, maybe if I draw something on the back... Maybe I can get him looking, hrmmm... let me see..."];
			tree[22] = [100];

			tree[30] = ["Just let me\nhave this"];
			tree[31] = ["#grim06#Errr, really? Well, maybe if I draw something on the back, I can get him looking, hrmmm... let me see..."];
			tree[32] = [100];

			tree[40] = ["I'm telling\nAbra..."];
			tree[41] = ["#grim10#Gwaah! I'm sorry!! ...I'll be good! Maybe if I draw something on the back, hrmmm... let me see..."];
			tree[42] = [100];

			tree[50] = ["Oh,\ndon't worry\nabout it"];
			tree[51] = ["#grim06#Errr, just give me a second! I think if I draw something on the back, I can get him looking, hrmmm... let me see..."];
			tree[52] = [100];

			tree[100] = ["%fun-alpha0%"];
			tree[101] = ["#zzzz10#..."];
			tree[102] = ["%fun-alpha1%"];
			tree[103] = ["%fun-charmelesexy%"];
			tree[104] = ["%prompts-dont-cover-7peg-clues%"]; // arrange prompts so they don't cover charmeleon
			tree[105] = ["#char02#Charmeleon! Char! What do you think of my smoooooooooth reptilian abdomen? Pretty sexy right?"];
			tree[106] = [120, 130, 140, 150];

			tree[120] = ["Are those...\nfive-pack abs?"];
			tree[121] = ["%fun-charmeleoff%"];
			tree[122] = ["#grim04#Hey, c'mon! I thought I did pretty good. You sort of put me on the spot there!"];
			tree[123] = ["#grim00#Just look at him... I really captured his Charmeleon-ness! That wry grin, that soft fleshy exterior... Rrrr, I'd like to ooze up on into his..."];
			tree[124] = [200];

			tree[130] = ["Soooo\nsexy~"];
			tree[131] = ["%fun-charmeleoff%"];
			tree[132] = ["#grim01#I know, right!? I bet you wish you could see all my other sexy Charmeleon drawings. ...But those are just for me! Glurp~"];
			tree[133] = ["#grim00#Charmeleon was sorta my first internet crush. That wry grin, that soft fleshy exterior... Rrrr, I'd like to ooze up on into his..."];
			tree[134] = [200];

			tree[140] = ["Reptiles\ndon't have\nnipples..."];
			tree[141] = [121];

			tree[150] = ["Um, well..."];
			tree[151] = [121];

			tree[200] = ["%fun-alpha0%"];
			tree[201] = ["#grim01#... ... ..."];
			tree[202] = ["#grim06#...Okay! Err, don't judge me but... I sort of need some alone time with the Charmeleon cutout. Sorry! I'm sorry!"];
			tree[203] = ["#grim13#You're judging me aren't you? After I asked you so nicely not to! Hrrrrng!"];

			tree[10000] = ["%fun-charmeleoff%"];
			tree[10001] = ["%fun-alpha1%"];
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["#grim04#So your name's... <name>, right?"];
			if (PlayerData.gender == PlayerData.Gender.Boy)
			{
				tree[1] = ["#grim05#<name>... <name>... That sounds kinda like a boy's name. You've got boy genitals?"];
				tree[2] = ["#grim06#I forget, are those err... the pointy kind? Or the mushy kind?"];
			}
			else if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				tree[1] = ["#grim05#<name>... <name>... That sounds kinda like a girl's name. You've got girl genitals?"];
				tree[2] = ["#grim06#I forget, are those err... the pointy kind? Or the mushy kind?"];
			}
			else
			{
				tree[1] = ["#grim05#<name>... <name>... I can't tell. Is that a boy's name or a girl's name?"];
				tree[2] = ["#grim06#Like, as far as your genitals, hrrrmmm... Are they the pointy kind? Or the mushy kind?"];
			}
			tree[3] = [20, 30, 40, 50];

			tree[20] = ["They're the\npointy kind"];
			tree[21] = ["#grim02#The pointy kind!? That's... that's my favorite kind!!"];
			tree[22] = ["#grim01#Always poking around everywhere, and then when they poke in just the right way... Gwohohohohorf~"];
			tree[23] = ["#grim00#...Mine are a little pointy AND a little mushy. It's hrrmmm, kind of a mess down there if you're not used to that sort of thing."];
			tree[24] = ["#grim05#Just... try to keep an open mind, okay! And I'll try not to do anything too gross."];

			tree[30] = ["They're the\nmushy kind"];
			tree[31] = ["#grim02#The mushy kind!? That's... that's my favorite kind!!"];
			tree[32] = ["#grim01#They're always mushing around everywhere, and then when they get smushed in just the right way.... Gwohohohohorf~"];
			tree[33] = [23];

			tree[40] = ["They're...\na little\nof both"];
			tree[41] = ["#grim02#A little of both!? That... that sounds just like mine!!"];
			tree[42] = ["#grim01#Always poking and... mushing around. Squishing and probing and... being smooshed in return~"];
			tree[43] = ["#grim00#Actually come to think of it, it's hrrmmm... kind of a mess down there if you're not used to that sort of thing."];
			tree[44] = [24];

			tree[50] = ["I don't\nwant to\ntell"];
			tree[51] = ["#grim02#So they're... they're the secret kind!? That's... that's my favorite kind!!"];
			tree[52] = ["#grim01#Those genitals that are all mysterious and nebulous... performing nebulous activities and having nebulous activites performed upon them~~"];
			tree[53] = ["#grim00#Actually, my genitals are kind of ill-defined in their own way! It's actually hrrmmm, kind of a mess down there if you're not used to that sort of thing."];
			tree[54] = [24];
		}
	}

	public static function stinkBuddies(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["#grim02#Aww hey! It's my good friend <name>! ...And he even clicked me on purpose this time."];
			tree[1] = ["#grim06#...It's okay if I call you that, right? ...A friend I mean?"];
			tree[2] = [20, 30, 40, 50];

			tree[20] = ["Friends...\nwith benefits!"];
			tree[21] = ["#grim03#Grohohohoh! That's right, you've sort of had your hand down the garbage disposal a few times, haven't you~"];
			tree[22] = [100];

			tree[30] = ["Of course\nwe're friends!"];
			tree[31] = ["#grim03#Grohohoh! Okay, just making sure. Some people are kinda touchy about calling me their friend. ...As if people will judge them or something!"];
			tree[32] = [100];

			tree[40] = ["Uhh, maybe\nkeep it on\nthe D/L..."];
			tree[41] = ["#grim03#Aww c'mon! You don't gotta be so shy about it. What, you think everyone's gonna judge you for having one stinky friend?"];
			tree[42] = [100];

			tree[50] = ["Oops, I thought\nyou were\nCharmeleon\nagain"];
			tree[51] = ["#grim03#Aww c'mon! You don't gotta be so shy about it. What, you think everyone's gonna judge you for having one stinky friend?"];
			tree[52] = [100];

			tree[100] = ["#grim04#Of course it just figures my closest friend in the house would be the one without a nose! Not that I mind or anything."];
			tree[101] = ["#grim05#But like, even Abra you know? ...He invited me to the house a couple weeks ago to introduce me to his friends."];
			tree[102] = ["#grim06#I guess maybe he felt bad for me? Or maybe he's just a friendly guy. I dunno. But lately whenever I come by to visit, he's always holed up in his room."];
			tree[103] = ["#grim08#...Hrrrmph, so I guess he can't put up with the smell either. ...Just like everyone else."];
			tree[104] = ["#grim04#Well, whatever. That just means more privacy for the two of us, right <name>?"];
			tree[105] = ["#grim03#Let's get these stupid puzzles out of the way so we can make the most of it! Gwoh-hohohohorf~"];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 0, "he even", "she even");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 0, "he even", "they even");
			}

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 101, "He invited", "She invited");
				DialogTree.replace(tree, 101, "his friends", "her friends");
				DialogTree.replace(tree, 102, "he felt", "she felt");
				DialogTree.replace(tree, 102, "he's just", "she's just");
				DialogTree.replace(tree, 102, "friendly guy", "friendly girl");
				DialogTree.replace(tree, 102, "he's always", "she's always");
				DialogTree.replace(tree, 102, "his room", "her room");
				DialogTree.replace(tree, 103, "he can't", "she can't");
			}
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["#grov06#That... that stench. Did someone perhaps knock over a bottle of vinegar? Or is there a..."];
			tree[1] = ["%entergrov%"];
			tree[2] = ["#grov08#...Ah yes. Hello... Grimer. One puzzle down already?"];
			tree[3] = ["#grim02#Yeah! <name> got through that one super quick."];
			tree[4] = ["#grov04#Ah, excellent. Yes, he's a sharp one isn't he?"];
			tree[5] = ["#grov03#Hmm, most of us strip in between puzzles but... I suppose you're exempt from Abra's usual \"two articles of clothing\" rule aren't you?"];
			tree[6] = ["#grim03#Oh! Oh!!! I knew about that rule and I actually threw in a shirt and pants just in case! Should I take them out now??"];
			tree[7] = ["#grov06#Take them... \"out\"? ...Surely you mean, take them \"off\"..."];
			tree[8] = ["#grim06#No, no, I stuffed 'em in here for a reason! Just gimme a second to find them okay? Sorry!"];
			tree[9] = ["#grim12#...Now where are they... Hrmmm... Hrrmmmmm... no, not those... Wait, when did I eat THAT!?"];
			tree[10] = ["#grov08#That's, eeuugh... ...That's quite alright, go ahead and keep your shirt... in."];
			tree[11] = ["%exitgrov%"];
			tree[12] = ["#grov10#... ...Now if you'll pardon me, I could use some fresh air..."];
			tree[13] = ["#grim05#Hrrmph! ...People around here sure do love their fresh air."];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 4, "he's a", "she's a");
				DialogTree.replace(tree, 4, "isn't he", "isn't she");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 4, "he's a", "they're a");
				DialogTree.replace(tree, 4, "isn't he", "aren't they");
			}
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["#grim06#Aaaand yep, we're alone again. Hrrmmm. Guess Grovyle's still out enjoying his \"fresh air\"..."];
			tree[1] = ["#grim08#...Hey <name>?"];
			tree[2] = ["#grim09#... ...Do you ever think we could be, y'know, real life friends? Like... if you had to put up with how I smell?"];
			tree[3] = [20, 30, 40, 50];

			tree[20] = ["Yeah! I\nwouldn't mind"];
			tree[21] = ["#grim08#Really? Hrrmmm. I'm not so sure. A lot of guys start out kinda treating me nice, like Abra did. And like you're doing now..."];
			tree[22] = [100];

			tree[30] = ["Hmm, I'm\nnot sure"];
			tree[31] = ["#grim06#Yeah, hrrmmm. I'm not sure either. I know we're friends now, but a lot of my online friendships start out fine until we meet in person."];
			tree[32] = ["#grim08#And even when we meet in person they're nice at first. I mean I don't lie about it, they know what to expect."];
			tree[33] = [100];

			tree[40] = ["Probably\nnot"];
			tree[41] = ["#grim06#Yeah, hrrmmm. That's what I'm worried about. I know we're friends now, but a lot of my online friendships start out fine until we meet in person."];
			tree[42] = ["#grim08#And even when we meet in person they're nice at first. I mean I don't lie about it, they know what to expect."];
			tree[43] = [100];

			tree[50] = ["I bet I\nsmell worse\nthan you do"];
			tree[51] = ["#grim03#Gwohh-hohohohorf! Aww, you're just saying that to be nice."];
			tree[52] = ["#grim04#A lot of guys start out kinda treating me nice like that. You know, sorta like Abra did."];
			tree[53] = [100];

			tree[100] = ["#grim06#...But then they get sick of it when they realize, well, it's kind of an all-the-time thing. The smell I mean."];
			tree[101] = ["#grim09#And most of them can't get used to it. Or they're scared of getting used to it..."];
			tree[102] = ["#grim08#... ..."];
			tree[103] = ["#grim04#Y'know like, they say it works that way when you have pets right? Your house can smell really bad, people walk in and they're like \"Phwooph! ...This is a cat house.\""];
			tree[104] = ["#grim05#But you don't smell it anymore, 'cause you're used to it and it just smells normal to you."];
			tree[105] = ["#grim06#Maybe if you and I ever met in real life, we could like... be roommates? At least until you got used to the smell..."];
			tree[106] = ["#grim03#And then we'd be stink buddies! We'd be stinky together and make new stinky friends."];
			tree[107] = ["#grim06#...Or uhh. Or maybe we could plan out something where you don't adopt this whole lifestyle change of smelling like a dumpster all the time? ...Sorry! I'm sorry!!"];
			tree[108] = ["#grim07#Hrrrrrrrrrmmmmmm! ...I'll think of something!!!"];

			if (!PlayerData.grovMale)
			{
				DialogTree.replace(tree, 0, "enjoying his", "enjoying her");
			}
		}
	}

	public static function random00(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#grim11#Gwahh!!"];
		tree[1] = ["#grim05#Oh, it's you <name>! ...Sorry, I sorta had my back turned. We should really get you a doorbell or something!"];
		tree[2] = ["#grim02#Err, but yeah! I'd be happy to solve some puzzles with you. Is that what we're doing? Yeah, let's go!"];
	}

	public static function random01(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#grim03#Back for more puzzles with your pal Grimer ehhh? ...<name>, I have to say you're a man of questionable taste."];
		tree[1] = ["#grim02#...I guess it only figures you'd be drawn to me, a man of questionable smells! Gwo-hohohohorf."];
		tree[2] = ["#grim01#But we'll have plenty time to smell and taste each other later! ...Let's get you started on a puzzle~"];

		if (PlayerData.gender == PlayerData.Gender.Complicated)
		{
			DialogTree.replace(tree, 0, "a man", "a character");
			DialogTree.replace(tree, 1, "a man", "a character");
		}
		else
		{
			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 0, "a man", "a woman");
			}
			if (!PlayerData.grimMale)
			{
				DialogTree.replace(tree, 1, "a man", "a woman");
			}
		}
	}

	public static function random02(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("grim.randomChats.0.2");

		if (count % 2 == 0)
		{
			tree[0] = ["#grim03#Whoa, that was fast! I like, literally JUST got here. I've sat at traffic lights longer than that!"];
			tree[1] = ["#grim05#I almost feel a little bad for the other guys though! Kinda like I'm cutting in line."];
			tree[2] = ["#grim01#...Maybe I can make 'em a cardboard Grimer cutout, that way you'll click them more often! Gwoh-hohohohorf~"];

			if (!PlayerData.abraMale && !PlayerData.grovMale)
			{
				DialogTree.replace(tree, 1, "other guys", "other girls");
			}
		}
		else
		{
			tree[0] = ["#grim03#Whoa, that was fast! I like, literally JUST got here. I've sat at traffic lights longer than that!"];
			tree[1] = ["#grim00#But really, I'm flattered <name>. I've never had someone this eager to just hang out with me~"];
		}
	}

	public static function random03(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var hours:Int = Date.now().getHours();

		if (hours >= 5 && hours < 9)
		{
			tree[0] = ["#grim02#Goo morning, <name>! Whoa!!! ....What are you doing up this early?"];
			tree[1] = ["#grim03#Maybe... Maybe you're getting in some early Grimer action before your morning shower? Glop! That's pretty smart~"];
		}
		else if (hours >= 9 && hours < 12)
		{
			tree[0] = ["#grim02#Goo morning, <name>! Huh, you must be one of those legendary \"morning people,\" is that it?"];
			tree[1] = ["#grim06#I don't know if I'm a morning person or an evening person... Hrrmmm..."];
			tree[2] = ["#grim03#You tell me what you are first! I'll be whatever you are~"];
		}
		else if (hours >= 12 && hours < 18)
		{
			tree[0] = ["#grim02#Goo afternoon, <name>! How's your day been gooing?"];
			tree[1] = ["#grim06#Hrrmmm... Was that too many goo puns in a row? Sorry! ...I'm sorry. Too much of a goo thing, right?"];
			tree[2] = ["#grim10#Ack! ...That one just slipped out!"];
		}
		else if (hours >= 18 && hours < 23)
		{
			tree[0] = ["#grim04#Goo evening <name>! ...Hrrmmm, have you had your dinner yet?"];
			tree[1] = ["#grim05#I don't usually do a real dinner! I'm more in the, \"lots of small meals\" kinda camp."];
			tree[2] = ["#grim06#Not 'cause I'm trying to lose weight or anything! I'm just no fun when I'm hungry."];
		}
		else
		{
			tree[0] = ["#grim06#Goo evening <name>! ...Hrrmmm, isn't it past your bedtime?"];
			tree[1] = ["#grim00#Not that I mind or anything! But... You're missing out on a lotta fun stuff you can do in bed! ...Blop!"];
			tree[2] = ["#grim01#Heyyyy maybe after these three puzzles, your good buddy Grimer can help tuck you in~"];
		}
	}

	public static function sorryIAteYourDildo04(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("grim.randomChats.0.4");

		if (count == 0)
		{
			tree[0] = ["%disable-skip%"];
			tree[1] = ["#grim11#Oh my god oh my god I am so glad you're here I am SO SORRY!"];
			tree[2] = ["#grim10#I thought that thing you gave me to eat was just something you fished out of a dumpster I didn't know you spent SO MUCH MONEY on it <name>!"];
			tree[3] = ["#grim09#...I ummm, I promise I won't eat anything else unless you say it's really okay! ...Oh and umm, here's " + moneyString(PlayerData.grimMoneyOwed) + "? I hope that's enough to cover it..."];
			tree[4] = ["%grim-reimburse%"];
			tree[5] = ["%enable-skip%"];
			tree[6] = ["#grim08#It took me a lot of puzzles to save up all those gems! ...I'm really, really sorry <name>. I hope you're not mad at me."];
			tree[7] = [20, 50, 40, 30];

			tree[20] = ["Hey, nothing\nto be sorry\nabout"];
			tree[21] = ["#grim04#Phew! ...I'm glad you're so nice about this stuff."];
			tree[22] = ["#grim08#I don't have a lot of close friends, and errr... it's probably because I'm always making dumb mistakes like this. ...But, well..."];
			tree[23] = ["#grim01#...I'm just glad you're so easygoing, <name>. Let's solve some puzzles~"];

			tree[30] = ["Well where's\nmy stuff?"];
			tree[31] = ["#grim09#Ohhhh... By the time I realized what I'd eaten, it was already all digested and icky."];
			tree[32] = ["#grim08#I wanted to fix it, but I don't have a way to un-digest things. My digestive system doesn't work in both directions like yours does!"];
			tree[33] = ["#grim06#...I mean I can still put things in my butt, but it doesn't do anything useful."];
			tree[34] = ["#grim08#Well, I'll just have to try not to make the same mistake again, okay?"];

			tree[40] = ["This isn't\nnearly\nenough\nmoney"];
			tree[41] = ["#grim09#Aww, man... Maybe if I'd solved harder puzzles, or gone through them faster, I could have gotten more money for you..."];
			tree[42] = ["#grim08#... ...Ugh, I'm such a screwup... I'm so, so sorry."];

			tree[50] = ["Just don't\ndo it again"];
			tree[51] = ["%fun-longbreak%"];
			tree[52] = ["#grim06#...Glurp... Yeah, hrrrmmm..."];
			tree[53] = ["#grim05#I'm going to go grab something to eat, <name>. That way I won't be hungry when I'm near all your cool expensive stuff."];
		}
		else if (count == 1)
		{
			var moneyDiscount:String = moneyString(ItemDatabase.roundUpPrice(PlayerData.grimMoneyOwed, -10));

			tree[0] = ["%disable-skip%"];
			tree[1] = ["#grim11#Oh noooo I did it again! I am SO SORRY <name>!! ...I just can't control myself!"];
			tree[2] = ["#grim10#I think I sort of knew I wasn't supposed to eat that thing you gave me. ...But it just looked so delicious the way you were holding it, and I was really hungry... ..."];
			tree[3] = ["#grim09#Ummm well... I solved a bunch more puzzles to get you this " + moneyString(PlayerData.grimMoneyOwed) + ". ...But I really just need to start eating before I come over."];
			tree[4] = ["%grim-reimburse%"];
			tree[5] = ["%enable-skip%"];
			tree[6] = ["#grim06#I just always get in trouble when I'm hungry..."];
			tree[7] = [20, 50, 40, 30];

			tree[20] = ["It's no\nproblem"];
			tree[21] = ["#grim05#Well... I'll still try to be more careful, okay?"];
			tree[22] = ["#grim06#How about if we just try to keep my meals under " + moneyDiscount + "? So I can still eat some of your stuff. ...Maybe just... cheaper stuff!"];
			tree[23] = ["#grim04#Okay, well errrr... let's dive into this next set of puzzles!"];

			tree[30] = ["You worry\ntoo much"];
			tree[31] = [21];

			tree[40] = ["Maybe\nyou should\ngo eat"];
			tree[41] = ["#grim05#Hrrrmmm, yeah! That's probably a good idea."];
			tree[42] = ["%fun-shortbreak%"];
			tree[43] = ["#grim04#I think I smelled something a little rancid coming from the garage. ...I'll be right back!"];

			tree[50] = ["I was an\nidiot to\ntrust you"];
			tree[51] = ["#grim09#Yeah, hrrrrmmm... I don't know what I can do better. ...You probably just shouldn't let me near your stuff anymore."];
			tree[52] = ["#grim05#I'm really sorry, <name>. I'll try to do a better job."];
		}
		else if (count == 2)
		{
			var moneyDiscount:String = moneyString(ItemDatabase.roundUpPrice(PlayerData.grimMoneyOwed, -3));

			tree[0] = ["%disable-skip%"];
			tree[1] = ["#grim04#... ... ...<name>, I don't mind if you want to keep feeding me! ...I just want to make sure I pay my fair share."];
			tree[2] = ["#grim06#That thing you gave me tasted pretty expensive. What was it, around " + moneyDiscount + "? ...Here, I'll give you " + moneyString(PlayerData.grimMoneyOwed) + " just to make sure."];
			tree[3] = ["%grim-reimburse%"];
			tree[4] = ["%enable-skip%"];
			tree[5] = ["#grim02#You're kind of an expensive date! ...Blorp!"];
		}
		else
		{
			var moneyDiscount0:String = moneyString(ItemDatabase.roundUpPrice(PlayerData.grimMoneyOwed, -9));
			var moneyDiscount1:String = moneyString(ItemDatabase.roundUpPrice(PlayerData.grimMoneyOwed, -6));
			var moneyDiscount2:String = moneyString(ItemDatabase.roundUpPrice(PlayerData.grimMoneyOwed, -3));
			var moneyDiscount3:String= moneyString(ItemDatabase.roundUpPrice(PlayerData.grimMoneyOwed, 0));
			tree[0] = ["%disable-skip%"];
			tree[1] = ["#grim04#Ehh, what's the damage this time? Something like " + moneyDiscount1 + "?"];
			tree[2] = [10, 20, 30, 40];

			tree[10] = ["Oh, it\nwas only\n" + moneyDiscount0];
			tree[11] = [31];

			tree[20] = [moneyDiscount1 + "\nsounds\ngood"];
			tree[21] = [31];

			tree[30] = ["Actually\nit was\n" + moneyDiscount2];
			tree[31] = ["#grim06#Hrrrmmm, let's make it " + moneyDiscount3 + " just to be safe. ...I don't wanna look like some kind of freeloader!"];
			tree[32] = ["%grim-reimburse%"];
			tree[33] = ["%enable-skip%"];
			tree[34] = ["#grim05#It's bad enough I'm spending so much time here at Abra's place, gooping up his carpets and stuff. ...The least I can do is try to pay my fair share."];
			tree[35] = ["#grim02#Alright, so what kind of puzzles are we looking at today!"];

			tree[40] = ["Uhh,\nmore like\n" + moneyDiscount3];
			tree[41] = ["%grim-reimburse%"];
			tree[42] = ["%enable-skip%"];
			tree[43] = ["#grim10#Whoa, really!? ...Uhh, that's all my money! I guess I'll be grinding more puzzles after we're done here..."];
			tree[44] = ["#grim06#You need to buy some cheaper stuff, <name>! ...I can't afford these kinds of food bills if we're going to be doing this all the time."];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 34, "his carpets", "her carpets");
			}
		}
	}

	public static function random10(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#grim06#So I sorta get how to tell whether your answer's right or wrong... But I don't get how you do all the stuff that comes before that."];
		tree[1] = ["#grim07#...Err, you know. The part where you slowly figure everything out. That part seems really confusing!"];
	}

	public static function random11(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var totalPuzzlesSolved:Int = PlayerData.getTotalPuzzlesSolved();

		tree[0] = ["#grim04#So hrrmmm... You're rank " + commaSeparatedNumber(totalPuzzlesSolved) + ", right? 'Cause I'm rank 9 and..."];
		tree[1] = ["#grim13#Hey wait, that can't be right! How can you be rank " + commaSeparatedNumber(totalPuzzlesSolved) + " when I'm rank 9!? I don't get how to read this thing."];
		tree[2] = ["#grim06#Maybe this " + commaSeparatedNumber(totalPuzzlesSolved) + " number is just the number of puzzles you've solved? Hrrrmmmmmm..."];
		tree[3] = ["%fun-shortbreak%"];
		tree[4] = ["#grim12#Hey Abra! Where do I find <name>'s rank?"];

		tree[10000] = ["%fun-shortbreak%"];
	}

	public static function random12(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("grim.randomChats.1.2");

		if (count % 3 == 0 && PlayerData.hasMet("sand"))
		{
			tree[0] = ["#sand06#(sniff, sniff) Did someone burn popcorn? Or is it..."];
			tree[1] = ["%entersand%"];
			tree[2] = ["#sand05#...Aww hey Grimer! We were thinkin' of ordering some Effen Pizza. You hungry?"];
			tree[3] = ["#grim06#Hmm I dunno... Pizza boxes?? ...Sorry, I just had cardboard for lunch. I'm sorry! Hrrrmmmm...."];
			tree[4] = ["#grim05#...How about something more styrofoamy or plasticky! Like err... Those Chinese to-go boxes? Or Mediterranean?"];
			tree[5] = ["#sand12#What? Nah, we're not orderin' somewhere else just so you can have... better garbage."];
			tree[6] = ["#sand06#I was askin' more like... how much, or what toppings. Like, what you want ON the pizza."];
			tree[7] = ["#grim06#What I want... on the pizza?"];
			tree[8] = ["#grim02#.. ...Oh err, yeah! Get a lot of those little three-prong pizza thingies. I love those!"];
			tree[9] = ["%exitsand%"];
			tree[10] = ["#sand06#Uhh yeah, got it. Sounds like we're doin' a large specialty meat lovers, with extra three-prong pizza thingies."];
			tree[11] = ["#grim03...Glurp!"];
		}
		else if (count % 3 == 1 && PlayerData.hasMet("buiz"))
		{
			tree[0] = ["#buiz06#Did someone leave a curling iron on? It smells kinda like..."];
			tree[1] = ["%enterbuiz%"];
			tree[2] = ["#buiz03#...Oh, uh... Hey Grimer! Grovyle and I were gonna get pizza. Did you want in?"];
			tree[3] = ["#grim04#Err, yeah! I could eat~"];
			tree[4] = ["#buiz02#Sweet, I was hoping we can split one! 'Cause I didn't want a whole pizza by myself, but Grovyle won't go half-and-half with anything meat. Y'know, for obvious reasons."];
			tree[5] = ["#buiz04#So I was thinkin' like, I'll get my half with sausage and mushroom, and you can get whatever you want on your half?"];
			tree[6] = ["#grim05#Sounds good! I want my half with mmm, cigarette butts and used fly traps."];
			tree[7] = ["#buiz06#What? ...Uhh, I meant like, food stuff. We're just talking about Effen Pizza here, they just have like, the regular pizza toppings..."];
			tree[8] = ["#grim02#No, no, they'll do it if you ask! Just write it in the \"special comments\" section, they'll dig that stuff right out of the garbage for you~"];
			tree[9] = ["#buiz07#I uh... Ugghhh."];
			tree[10] = ["%exitbuiz%"];
			tree[11] = ["#buiz08#N-nevermind. ... ...I don't feel like pizza anymore..."];
			tree[12] = ["#grim05#Aww okay! ...Bye Buizel!"];
			tree[13] = ["#grim06#Geez that guy's always losing his appetite. No wonder he stays so skinny!"];

			if (!PlayerData.buizMale)
			{
				DialogTree.replace(tree, 13, "he stays", "she stays");
			}
		}
		else
		{
			tree[0] = ["#grim10#Oogh! My stomach's killing me..."];
			tree[1] = ["%fun-longbreak%"];
			tree[2] = ["#grim06#...Err, sorry, go ahead and do this one without me! ...Sorry! I'm gonna see if they got anything good in the garbage."];

			tree[10000] = ["%fun-longbreak%"];
		}
	}

	public static function random20(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("grim.randomChats.2.0");

		if (count % 3 == 0 && PlayerData.hasMet("rhyd"))
		{
			tree[0] = ["#RHYD10#(sniff, sniff) Hey, can someone take out the garbage? It smells kinda like uhhh..."];
			tree[1] = ["%enterrhyd%"];
			tree[2] = ["#RHYD06#Oh, it's you. Hey buddy. ...Uhh, you want an Altoid?"];
			tree[3] = ["#grim02#Err, sure! (gulp)"];
			tree[4] = ["%exitrhyd%"];
			tree[5] = ["#RHYD09#(sniff) Hmm. Well it was worth a shot."];
			tree[6] = ["#grim06#...Did he really think one Altoid would make a difference?"];

			if (!PlayerData.rhydMale)
			{
				DialogTree.replace(tree, 6, "Did he", "Did she");
			}
		}
		else if (count % 3 == 1 && PlayerData.hasMet("smea"))
		{
			tree[0] = ["#smea05#(sniff, sniff) Ooooohhh... is someone making soup? It smells kind of-"];
			tree[1] = ["%entersmea%"];
			tree[2] = ["#smea10#-Ohhhh. Hey Grimer. ...Did you want an Altoid?"];
			tree[3] = ["#grim02#Err, okay! (gulp)"];
			tree[4] = ["%exitsmea%"];
			tree[5] = ["#smea12#(sniff) Tsk! ... ...Still stinky."];
			tree[6] = ["#grim06#...Really? ...What did he think would happen?"];

			if (!PlayerData.smeaMale)
			{
				DialogTree.replace(tree, 6, "did he", "did she");
			}
		}
		else
		{
			tree[0] = ["%enterabra%"];
			tree[1] = ["#abra06#(sniff, sniff). Hmm. Hello Grimer. ...Altoid?"];
			tree[2] = ["#grim02#Err, why not! (gulp)"];
			tree[3] = ["%exitabra%"];
			tree[4] = ["#abra09#(sniff) ...Hmph. ... ...I'll be in my room."];
			tree[5] = ["#grim06#Of all people, I thought he'd know better..."];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 5, "thought he'd", "thought she'd");
			}
		}
	}

	public static function random21(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#grim03#This is the last puzzle, isn't it? Whoa! Way to goo~"];
		tree[1] = ["%fun-alpha0%"];
		tree[2] = ["#grim05#I'm err... I'm gonna go see if anyone's in the bathroom! I could use some freshening up. Back in a jiff!"];
		tree[3] = ["%fun-longbreak%"];

		tree[10000] = ["%fun-longbreak%"];
	}

	public static function random22(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#grim04#Wow, goo job! You make this stuff look pretty darn easy."];
		tree[1] = ["#grim01#Mmm one more puzzle and... Maybe you can give me my own little \"goo job\" hrrmm? Gwohohohohorf~"];
	}

	public static function denDialog(sexyState:GrimerSexyState = null, victory:Bool = false):DenDialog
	{
		var denDialog:DenDialog = new DenDialog();

		denDialog.setGameGreeting([
			"#grim02#Hello? Is someone there? ...Oh! OH! <name>! It's you! Wow! Are you just here to say hi? Or can you stay awhile?",
			"#grim03#...I mean we just saw each other out in the living room, but that doesn't mean I don't want to see MORE of you! I could never get too much <name>~",
			"#grim04#So errr what did you want to do? Abra's got <minigame> set up back here, and I guess I could use the practice! If you're up for a few games...",
		]);

		denDialog.setSexGreeting([
			"#grim02#Usually I'd apologize for the lack of ventilation in a place like this but... I guess that doesn't really matter to you, hrrmmm, <name>??",
			"#grim01#Actually I kind of like it better this way! Now I know we're not bothering anybody, we can spend as loooooong as we want~",
			"#grim00#So, what do you think? It's your move~",
		]);

		denDialog.addRepeatSexGreeting([
			"#grim00#Be honest, it feels good doesn't it? Like squeezing a big purple stress ball~",
			"#grim01#...Well, it feels good to me too~",
		]);
		denDialog.addRepeatSexGreeting([
			"#grim02#Gooness gracious, I LOVE this! ...And my poison doesn't affect you either!? ...Blop!",
			"#grim01#This is like, a match made in heaven. Hrrrm-hrhrhrrhr~"
		]);
		denDialog.addRepeatSexGreeting([
			"#grim00#Do you ever watch romantic comedies? Because... hrrmmm...",
			"#grim01#...This is sort like, that part of the romantic comedy where the two people take off their clothes, and then they fuck over and over...",
			"#grim07#Or wait a minute, was that a porno!?!",
		]);
		denDialog.addRepeatSexGreeting([
			"#grim01#... ...Mmmmmmngghhh... This is the best day eveeerrrrrr...",
			"#grim00#Oh wow, you want to go again? ...Gllloooooop... ...I'm literally putty in your hands~",
		]);

		denDialog.setTooManyGames([
			"#grim04#Hrrmmm well, that's enough games for me! ...I'm going to go outside and get some fresh air.",
			"#grim02#...Thanks for the games, <name>! ...Oh, and if you bump into Sandslash, tell " + (PlayerData.sandMale ? "him" : "her") + " I said hi, okay!?"
		]);

		denDialog.setTooMuchSex([
			"#grim01#Grrrggghghgh.... <name>, you... you just... rrgh... gooness gracious... graagh...",
			"#grim00#Okay, fun's fun but I... I need some serious time to reglooperate... I'm not a machine!",
			"#grim06#...I mean, aren't you kind of a machine <name>? ...You should know!",
			"#grim00#Anyway ehh... I'm just gonna float around here for a few minutes... But this, this was a goooo day~",
			"#grim03#Thanks for spending so much time with me today. You're um... I don't know a lot of people like you."
		]);

		denDialog.addReplayMinigame([
			"#grim05#Okay, okay! I'm starting to get it. Did you want to play one more time? ...Barp? Or we could put the game away and do... something else~"
		],[
			"One more\ntime!",
			"#grim03#Gwohohoh! Yeah, okay!! One more, you got it~"
		],[
			"Something\nelse, hmm?",
			"#grim02#Yeah, anything else! Anything you want. ...Hrrrmmmm...",
			"#grim00#Okay, okay, I'll be honest, there's only ONE thing on my mind... Can you guess what it is? Hrrrm-hrhrhrh~",
		],[
			"Actually\nI think I\nshould go",
			"#grim06#Errr, yeah! I should probably get some fresh air myself. ...But this was good practice, right?",
			"#grim04#We'll have a real match next time. ...Goo bye, <name>!",
		]);
		denDialog.addReplayMinigame([
			"#grim05#This game's kind of addicting isn't it? ...But also kind of fun.",
			"#grim06#Did you want to go one more time? ...'Cause there's other stuff we could do back here too!"
		],[
			"Let's go\nagain!",
			"#grim02#Yeah, okay! I was hoping you'd say that. I want to get good enough to beat Abra! ...Like that'll ever happen..."
		],[
			"Other\nstuff?",
			"#grim02#Well yeah other stuff! ...Other sexy stuff! We could do all sorts of sexy stuff, like having sex.",
			"#grim06#Sorry! Did you really not get that? ...Maybe I was too subtle, I'm sorry!",
		],[
			"I think I'll\ncall it a day",
			"#grim02#Call it a day!? Okay, it's a day! ...Now what should we do next?",
			"#grim03#Aww, okay okay, I'll let you go. See you next time, <name>!",
		]);
		denDialog.addReplayMinigame([
			"#grim07#Gwooph, this stuff is really hard! ...My brain is starting to turn to jelly.",
			"#grim06#The ehh, the other kind of jelly! It was already one kind of jelly, but now it's a worse kind of jelly... The bad kind!",
			"#grim12#C'mon, what's so hard to understand about two kinds of jelly!?!"
		],[
			"Maybe if we\nplay again?",
			"#grim07#What!? Noooooo, that will just make it worse! Hrrnnngghhh!"
		],[
			"Uhh, maybe\nwe should\ndo something\ndifferent...",
			"#grim04#Oh! Okay, well that sounds like a good idea.",
			"#grim00#You know, there's other kinds of jelly we haven't even touched on yet. Hrrrmmm-hrhrhrhr~",
		],[
			"I'm leaving,\nthis is\ngetting weird",
			"#grim08#What? Aww c'mon, it was just jelly talk!",
			"#grim12#... ...Okay, okay, whatever, you go do what you need to do. I'll see you around, <name>.",
		]);

		denDialog.addReplaySex([
			"#grim02#Mmmmngh, all this screwing around's making me kind of hungry. I think I'll raid the garbage! ...Did you want anything, <name>?",
			"#grim03#Wait, what am I saying! Of course you don't want garbage, you have no mouth!",
			"#grim05#...Anyway, will you still be here when I get back?"
		],[
			"Sure, I'll\nbe here!",
			"#grim03#Hooraaaaaay!!! Goopy garbage time with " + stretch(PlayerData.name) + "~ ... ...Okay! I'll be right back!",
		],[
			"Oh, I should\nprobably go",
			"#grim02#Aww okay. Well hey, this was fun okay? You go... You go take care of things! And maybe you should wash your hands.",
			"#grim06#Err... hand! At least wash that one hand. Goo bye, <name>!",
		]);
		denDialog.addReplaySex([
			"#grim01#Gwahhhhh.... Wow... That was something... ...Kinda thirsty now, hrrmmm...",
			"#grim06#Kinda thirsty now. I wonder if they have any leftover cooking grease! Did you need anything while I'm up?",
		],[
			"Go ahead,\nI'll wait",
			"#grim05#Okay, sorry, I won't be too long! Either they have it or they don't. Hrrmmmm... ...Hrrrmmmmm....",
		],[
			"Oh, I think\nI'll head out",
			"#grim02#Aww okay. Well hey, this was fun okay? You go... You go take care of things! And maybe you should wash your hands.",
			"#grim06#Err... hand! At least wash that one hand. Goo bye, <name>!",
		]);
		denDialog.addReplaySex([
			"#grim00#Ooogh.... yeah... That was fun but... REALLY messy, we should probably try to get that off the floor...",
			"#grim06#...I think I saw some white vinegar in the kitchen. Sit tight, okay <name>! I'll be right back..."
		],[
			"Okay, I'll\nbe here",
			"#grim02#Okay! Keep an eye on that sludge stain okay? ...Glop!",
			"#grim05#...If it starts gaining sentience or anything, just try to keep it distracted."
		],[
			"I should\ngo...",
			"#grim05#Aww alright. This is probably just more of a one-person job anyways. Glarp.",
			"#grim04#...I mean, if you try to help, you'll probably just make a bigger mess! ...No offense, <name>. See you around~",
		]);

		return denDialog;
	}

	public static function cursorSmell(tree:Array<Array<Object>>, sexyState:GrimerSexyState)
	{
		// should never get invoked
	}

	static public function notHungry(tree:Array<Array<Object>>)
	{
		var which:Int = FlxG.random.int(0, 3);

		if (which == 0)
		{
			tree[0] = ["#grim06#Oof, I can't eat another bite right now! ...Maybe in a few minutes, alright?"];
		}
		else if (which == 1)
		{
			tree[0] = ["#grim07#Glurrgle! ...That looks delicious! I really wish I was hungry..."];
		}
		else if (which == 2)
		{
			tree[0] = ["#grim06#Ehh no thanks, I just had a big meal! Maybe I can have it for dessert later? Hhrrmmmm..."];
		}
		else if (which == 3)
		{
			tree[0] = ["#grim01#How can you think about food at a time like this? C'monnnnn, let's get nasty~"];
		}
	}

	static public function eatGummyDildo(tree:Array<Array<Object>>)
	{
		tree[0] = ["#grim06#Hey whoa! That's some fancy garbage you got there. ...Did you bring that just for me?"];
		tree[1] = ["#grim02#Is that... Is that silicon? Ohhhh man, some silicon would reeeeally hit the spot right now!"];
		tree[2] = [10, 40, 30, 20];

		tree[10] = ["Just for you,\nlittle buddy"];
		tree[11] = ["%eat-gummydildo%"];
		tree[12] = ["#grim03#Glorp!!!"];
		tree[13] = ["#grim01#...Mmmmmm... Wow! Which dumpster did you find this in? -chew- -chew- This is the tastiest garbage I've had in long time..."];
		tree[14] = ["#grim00#The silicon base gives it a rich, smooth texture, and yet there are some... -glurp- hmmm... mild hints of... what is that?"];
		tree[15] = ["#grim01#Is that liquid soap and B.O? Oh <name>, I love liquid soap and B.O! ...How did you know~"];
		tree[16] = ["#grim02#If you find any more garbage like that make sure to send it my way! That really hit the spot."];

		tree[20] = ["Here\nyou go"];
		tree[21] = [11];

		tree[30] = ["Well, you\ncan't keep\nit..."];
		tree[31] = ["#grim09#Aww! ...And now I'm all hungry. ... ...Bloop..."];

		tree[40] = ["Well, it's\na sex toy,\nso..."];
		tree[41] = ["#grim00#Oh, I get it! You want to... put it inside me. Gwohhh-hoho! ... ... ...Well, go right ahead. Be gentle~"];
		tree[42] = [50, 30];

		tree[50] = ["Um...\nokay?"];
		tree[51] = [11];
	}

	static public function eatSmallPurpleBeads(tree:Array<Array<Object>>)
	{
		tree[0] = ["#grim06#Mmmm my stomach's really growling. ...Wait, is that..."];
		tree[1] = ["#grim02#Did you bring me a sexy little appetizer? <name>! ...Really? Are those for me?"];
		tree[2] = [10, 40, 30, 20];

		tree[10] = ["Bon\nappetit"];
		tree[11] = ["%eat-smallpurplebeads%"];
		tree[12] = ["#grim03#Glorp!!!"];
		tree[13] = ["#grim01#-chomp- -chew- Mmmm... These plasticky balls have a really satisfying crunch to them. ...And there's a certain familiar earthy aftertaste..."];
		tree[14] = ["#grim00#Where have I tasted this before! ...Hrrrmmm, hrrrrmmmm... Oh, it'll come to me."];
		tree[15] = ["#grim02#-slorrrrp- Phew! That was a nice little snack."];
		tree[16] = ["#grim03#Where's my main course! ...Is that you, <name>? Gwohhh! Hohohoho~"];

		tree[20] = ["Here, you\ncan have\nthese"];
		tree[21] = [11];

		tree[30] = ["Well\nI'll need\nthem back\nafter..."];
		tree[31] = ["#grim06#Eesh, I don't think you're gonna want 'em back after I'm done with 'em."];
		tree[32] = ["#grim04#...Y'know what <name>, why don't you just hold onto those for now."];

		tree[40] = ["I'm supposed\nto insert\nthese...\nsomewhere"];
		tree[41] = ["#grim00#Ohhhh okay. ...Well, watch your fingers! Gwohh-hohohoho~"];
		tree[42] = [50, 30];

		tree[50] = ["Um... how's\nthis?"];
		tree[51] = [11];
	}

	static public function eatHappyMeal(tree:Array<Array<Object>>)
	{
		var which:Int = FlxG.random.int(0, 59);

		if (which % 3 == 0)
		{
			tree[0] = ["#grim01#Ooh, something smells like... -sniff- -sniff- mmm, weathered plastic parts, with a light dusting of dead skin cells and bodily oils?"];
		}
		else if (which % 3 == 1)
		{
			tree[0] = ["#grim01#Something smells really good... -sniff- -sniff- Is that... an assortment of cheap plastic caked in decades old fast food grease?"];
		}
		else if (which % 3 == 2)
		{
			tree[0] = ["#grim01#-sniff- -sniff- Is someone cooking? ...Wowee, that's some serious vintage garbage! How old is that stuff?"];
		}

		if (which % 6 == 0)
		{
			tree[1] = ["#grim02#Can I try one of those? ...Maybe that red and yellow one on top?"];
		}
		else if (which % 6 == 1)
		{
			tree[1] = ["#grim02#Can I have one? ...Maybe that grimy green one that's sort of buried in the back there?"];
		}
		else if (which % 6 == 2)
		{
			tree[1] = ["#grim02#Can you spare one for your buddy Grimer? ...Maybe that tacky little fake cheeseburger?"];
		}
		else if (which % 6 == 3)
		{
			tree[1] = ["#grim02#Mmmm, that ugly blue alien thing looks pretty tasty. ...Mind if I nibble on that one?"];
		}
		else if (which % 6 == 4)
		{
			tree[1] = ["#grim02#So many to choose from! Give me one of those sun-bleached ones over on the side."];
		}
		else if (which % 6 == 5)
		{
			tree[1] = ["#grim02#They all look so good! Mind if I munch on that little poop-looking guy with the snorkel?"];
		}
		tree[2] = [10, 20, 30];

		tree[10] = ["It's all\nyours"];
		tree[11] = ["%eat-happymeal%"];
		tree[12] = ["#grim03#Glorp!!!"];
		if (which % 4 == 0)
		{
			tree[13] = ["#grim00#Mmmmm... You know, I'm something of a connoisseur when it comes to old plastic toys."];
			tree[14] = ["#grim01#What is this, a 2003? 2004? Mmmm. That's a goooood year~ -glarrgle-"];
		}
		else if (which % 4 == 1)
		{
			tree[13] = ["#grim00#Nnnnghhh... So much for my diet. That's going to go straight to my anterior skornglax."];
			tree[14] = ["#grim06#Say, sex is supposed to burn a lot of calories, right? ...Does that still work if I just sit here and let you do everything?"];
		}
		else if (which % 4 == 2)
		{
			tree[13] = ["#grim00#-crunch- -chew- Nnngh wow! That one was extra musty."];
			tree[14] = ["#grim01#You can tell someone was storing these toys in their basement. It's got that pleasant sort of... mildewy, basementy aftertaste~"];
		}
		else if (which % 4 == 3)
		{
			tree[13] = ["#grim00#-crunch- Whoa! That one had some texture to it. I didn't expect to bite into those jagged metal pieces underneath."];
			tree[14] = ["#grim06#... ...Hrrrmmmm, whatever happened to Kinder eggs? Are those things still around?"];
		}

		tree[20] = ["Here,\nhave two"];
		tree[21] = ["%eat-happymeal%"];
		tree[22] = ["#grim03#Glorp!!! ...Glarp!!!"];
		tree[23] = [13];

		if (which % 5 == 0)
		{
			tree[30] = ["I was\nsaving\nthat one..."];
		}
		else if (which % 5 == 1)
		{
			tree[30] = ["That one's\nworth a lot\nof money..."];
		}
		else if (which % 5 == 2)
		{
			tree[30] = ["I want\nto keep\nthat one..."];
		}
		else if (which % 5 == 3)
		{
			tree[30] = ["I think\nI'll eat\nthat one\nmyself"];
		}
		else if (which % 5 == 4)
		{
			tree[30] = ["I can't\nlet you\neat that\none"];
		}
		tree[31] = ["#grim08#Awww... Now I'm all hungry... ..."];
	}
}