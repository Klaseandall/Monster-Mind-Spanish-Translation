package poke.rhyd;

import minigame.tug.TugGameState;
import poke.luca.LucarioResource;
import puzzle.ClueDialog;
import MmStringTools.*;
import critter.Critter;
import minigame.GameDialog;
import minigame.MinigameState;
import minigame.scale.ScaleGameState;
import poke.buiz.BuizelDialog;
import flixel.FlxG;
import openfl.utils.Object;
import PlayerData.hasMet;
import minigame.stair.StairGameState;
import puzzle.PuzzleState;

/**
 * Rhydon is canonically male. He had his comic debut alongside Nidoking back
 * in the Rhydon/Quilava comic.
 * 
 * Rhydon exercises almost every day with his gym partner Nidoking. Rhydon's
 * gay, and Nidoking has a girlfriend, Blaziken. But Nidoking's girlfriend
 * condones Nidoking messing around with Rhydon now and then on the side -- as
 * long as Nidoking saves his ass for her. Nidoking's ass is her territory.
 * 
 * Rhydon hooked up at the gym with Quilava and Sandslash once, but he hasn't
 * been with Quilava again since then, and hasn't used the gym as a hookup area
 * either. Anonymous sex leaves him feeling a little empty and he sort of wants
 * to spend his time with people who will remember his name the next day.
 * 
 * In general Rhydon's not actually a "top" as much as he just hates most guys
 * attitude towards topping him. He hates the whole "making someone your bitch"
 * attitude about gay sex and wants it to be more about love and positivity and
 * feeling good together. That's how it feels when he's with Nidoking and he
 * wishes he could find that with someone else who was single.
 * 
 * Rhydon orders tons of pizza and tips very generously, especially when
 * using a coupon! He understands you're supposed to tip on the pre-coupon
 * amount.
 * 
 * As far as minigames go, Rhydon's abysmal at the two minigames requiring
 * speed, but good at the stair game. However, he almost always goes for the
 * most obvious move, and rarely mixes up his strategy. You can take advantage
 * of him by thinking one step ahead.
 * 
 * ---
 * 
 * When writing dialog, I think it's good to have an inner voice in your head
 * for each character so that they behave and speak consistently. Rhydon's
 * inner voice was Hulk Hogan
 * 
 * Medium-bad at puzzles (rank 16)
 * 
 * Vocal tics: GROARRR!  GREHH! HEH-HEH! UHH... ERR...
 */
class RhydonDialog
{
	public static var prefix:String = "rhyd";
	public static var sexyBeforeChats:Array<Dynamic> = [sexyBefore0, sexyBefore1, sexyBefore2, sexyBefore3, sexyBefore4];
	public static var sexyAfterChats:Array<Dynamic> = [sexyAfter0, sexyAfter1, sexyAfter2];
	public static var sexyBeforeBad:Array<Dynamic> = [sexyBadAchyArms, sexyBadAchyChest, sexyBadAchyLegs, sexyBadTooFast, sexyBadWayTooFast, sexyBadTooMuchTip, sexyBadTooMuchShaft];
	public static var sexyAfterGood:Array<Dynamic> = [sexyAfterGood0, sexyAfterGood1, sexyAfterGood2];
	public static var fixedChats:Array<Dynamic> = [cameraBroken, topBottom, noMoreHookups];
	public static var randomChats:Array<Array<Dynamic>> = [
				[random00, random01, random02, random03, gift04],
				[random10, random11, random12, random13],
				[random20, random21, random22, random23]];

	public static function getUnlockedChats():Map<String, Bool>
	{
		var unlockedChats:Map<String, Bool> = new Map<String, Bool>();
		unlockedChats["rhyd.fixedChats.1"] = hasMet("sand");
		unlockedChats["rhyd.fixedChats.2"] = hasMet("sand");
		unlockedChats["rhyd.randomChats.1.1"] = hasMet("sand");
		unlockedChats["rhyd.randomChats.2.1"] = hasMet("sand");
		unlockedChats["rhyd.randomChats.2.3"] = hasMet("luca");
		unlockedChats["rhyd.randomChats.0.4"] = false;
		if (PlayerData.rhydGift == 1)
		{
			// all chats are locked except gift chat
			for (i in 0...randomChats[0].length)
			{
				unlockedChats["rhyd.randomChats.0." + i] = false;
			}
			unlockedChats["rhyd.randomChats.0.4"] = true;
		}
		return unlockedChats;
	}

	public static function clueBad(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var clueDialog:ClueDialog = new ClueDialog(tree, puzzleState);
		clueDialog.setGreetings(["#RHYD04#Oh yeah, roar! Now that I look at it, that <first clue> doesn't quite line up...",
								 "#RHYD04#Oops, uhh yeah! That <first clue> doesn't fit with your answer...",
								 "#RHYD04#Oh wait, your answer doesn't match with that <first clue>... Roar!!",
								]);
		clueDialog.setQuestions(["Really?", "What?", "Why not?", "It doesn't?"]);
		if (clueDialog.actualCount > clueDialog.expectedCount)
		{
			clueDialog.pushExplanation("#RHYD06#Well uhh, looking at that <first clue>... It's got too many <bugs in the correct position>.");
			clueDialog.pushExplanation("#RHYD08#Since it's got <e hearts>, it should only have <e bugs in the correct position>... But you've got <a bugs in the correct position>!");
			clueDialog.fixExplanation("should only have zero", "shouldn't have any");
			clueDialog.pushExplanation("#RHYD04#Try to fix it so the <first clue>'s only got <e bugs in the correct position>. And remember you can ask for help by hitting that button in the corner! Grr-roar!!");
			clueDialog.fixExplanation("clue's only got zero", "clue doesn't have any");
		}
		else
		{
			clueDialog.pushExplanation("#RHYD06#Well uhh, looking at that <first clue>... It needs more <bugs in the correct position>.");
			clueDialog.pushExplanation("#RHYD09#Since it's got <e hearts>, it should have <e bugs in the correct position>... But you've only got <a bugs in the correct position>!");
			clueDialog.fixExplanation("only got zero", "don't have any");
			clueDialog.pushExplanation("#RHYD04#Try to fix it so the <first clue>'s got more <bugs in the correct position>. And remember you can ask for help by hitting that button in the corner! Grr-roar!!");
		}
	}

	public static function sexyAfterGood0(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		tree[0] = ["#rhyd07#Roarrr... that was... You were really... Gr-roarrrr..."];
		tree[1] = ["#rhyd11#I think... Roar... For the first time in my life... Wroarrrr... I might be out of capital letters... Dub... Double-gro-a-r-r..."];
		tree[2] = ["#rhyd07#...so... embarrassed... don't... tell... Nidoking... grah-h-h-h-h-h...."];
	}

	public static function sexyAfterGood1(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		tree[0] = ["#rhyd07#Grahhh... Hahh... Wow... Can't move... Gr-roarrr... So exhausted..."];
		tree[1] = ["#rhyd11#I think... Roar... I overextended... Wroarrr... My jizz muscle... Dub... Double-gro-a-r-r-r..."];
		tree[2] = ["#rhyd07#Go ahead and... Finish this set without me, alright? I'm... Grah... I'm gonna go lay down for a bit..."];
		tree[3] = ["%fun-alpha0%"];
		tree[10000] = ["%fun-alpha0%"];
	}

	public static function sexyAfterGood2(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		tree[0] = ["#RHYD07#Gr-roarr... That was... Wroarrr... <name>- how did you... Grahhhh..."];
		tree[1] = ["#grov10#Is everybody alright? That was a tremendous earthquake! ...The kitchen's a bit of a mess and--"];
		tree[2] = ["#grov07#--GOOD LORD WHAT HAPPENED IN HERE!?!"];
		tree[3] = ["#RHYD11#D... Double gr-roarrrr... Can't... Can't move... Legs..."];
		tree[4] = ["#grov13#May I ask what possessed you to transform this ENTIRE HALF OF THE LIVING ROOM into a veritable... ...Jackson Pollock painting made of jizz!?!"];
		tree[5] = ["#RHYD11#... ...Can't... Groarrr..."];
		tree[6] = ["#grov12#You know you're going to have to clean all this up don't you! Some of us actually have to live here..."];
		tree[7] = ["#RHYD07#Wrrr-r-roarrrr... ...Wasn't... ... ...Mistake... ...Jizz..."];
	}

	public static function sexyAfter0(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		tree[0] = ["#RHYD06#Pheww... Yeahhhh... You doin' okay? I didn't hurt you or anything did I? Gimme a quick thumbs up if you're okay."];
		tree[1] = ["#RHYD00#Yeah yeah you're doin just fiiiine... Gr-roar~"];
	}

	public static function sexyAfter1(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		tree[0] = ["#RHYD00#Grahhh... Alright... Well I'm gonna go wash all this stink off."];
		tree[1] = ["#RHYD02#I'd offer to let you join me but... I'm not sure if you're waterproof?? Roar!!"];
		tree[2] = ["#RHYD05#Why don't you hang out here just in case. I'm sure some of the other guys are curious what you're up to."];
		if (!PlayerData.grovMale)
		{
			DialogTree.replace(tree, 2, "other guys", "other girls");
		}
	}

	public static function sexyAfter2(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		tree[0] = ["#RHYD00#Rrrrrrrr... Wow... When it comes to this kind of stuff, these muscly calloused nubs of mine are no match for your soft fingers..."];
		tree[1] = ["#RHYD05#But... but your soft fingers are no match when it comes to... wrestling!! Or uhh, cracking open beer cans!"];
		tree[2] = ["#RHYD03#Next time let's do something I can beat you at! Wr-roarrr!"];
	}

	public static function sexyBadAchyArms(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		tree[0] = ["#RHYD10#Roarr... My arms are killing me..."];
		tree[1] = ["#RHYD09#I've got this one muscle knot, somewhere over there in my left arm? Err well, my left, your right. Maybe you can give it a shot?"];
		tree[2] = ["#RHYD04#Don't worry if you can't hunt it down. Either way, free muscle massage right? Greh! Heh-heh."];
	}

	public static function sexyBadAchyChest(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		tree[0] = ["#RHYD10#Roarr... My chest muscles are really sore today, <name>..."];
		tree[1] = ["#RHYD09#I've got this one muscle knot, somewhere over there on my left side? Err well, my left, your right. Maybe you can give it a shot?"];
		tree[2] = ["#RHYD04#Don't worry if you can't hunt it down. Either way, free abdominal massage right? Greh! Heh-heh."];
	}

	public static function sexyBadAchyLegs(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		tree[0] = ["#RHYD10#Roarr... My legs are killing me..."];
		tree[1] = ["#RHYD09#I've got this one muscle knot, somewhere over there in my right leg? Err, well, my right, your left. Maybe you can give it a shot?"];
		tree[2] = ["#RHYD04#Don't worry if you can't hunt it down. Either way, free muscle massage right? Greh! Heh-heh."];
	}

	public static function sexyBadTooFast(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		tree[0] = ["#RHYD05#Well okay okay, the hard part's over!"];
		tree[1] = ["#RHYD01#...And now it's time for the REALLY hard part. If you know what I mean. Greh! Heh!"];
		tree[2] = ["#RHYD06#Although y'know, harder isn't always better. There's somethin' to be said for relaxing, taking it a little slow."];
		tree[3] = ["#RHYD04#Especially when it comes to working my dick, none of this, like, rub-rub-rub-rub-rub-rub nonsense, c'mon. Maybe just, rub. Rub... Rub."];
		tree[4] = ["#RHYD05#Heh not a big deal, was just a little faster than I'm used to last time."];
		tree[5] = ["#RHYD02#...You just don't gotta work so hard, is all I'm getting at! Greh-heh-heh."];

		if (!PlayerData.rhydMale)
		{
			tree[1] = ["#RHYD00#...And now it's time for the, err. The soft part. Greh! Heh!"];
			DialogTree.replace(tree, 2, "Although y'know", "'Cause y'know");
			DialogTree.replace(tree, 3, "dick", "pussy");
		}
	}

	public static function sexyBadWayTooFast(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		if (!PlayerData.rhydonCameraUp)
		{
			tree[0] = ["%fun-camera-slow%"];
		}
		else
		{
			tree[0] = ["%fun-noop%"];
		}
		tree[1] = ["#RHYD06#Err, so before we start..."];
		tree[2] = ["#RHYD04#Us bigger guys, we kinda operate at our own tempo, you know?"];
		tree[3] = ["#RHYD10#Like with little guys, their hearts beat faster, they can probably handle you shaking up their cocks like cans of spraypaint."];
		tree[4] = ["#RHYD05#Just maybe, y'know, take it a little slower this time. If you want. Not a big deal. Greh-heh-heh."];

		if (!PlayerData.rhydMale)
		{
			DialogTree.replace(tree, 2, "guys", "girls");
			DialogTree.replace(tree, 3, "little guys", "smaller girls");
			DialogTree.replace(tree, 3, "shaking up their cocks like cans of spraypaint", "hammering their pussies like a coked-up woodpecker");
		}
	}

	public static function sexyBadTooMuchTip(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		tree[0] = ["#RHYD04#It's important to balance your exercise you know! Like yesterday for me was triceps/delts... And today's brain/cock."];
		tree[1] = ["#RHYD10#Although y'know, last time you kinda just focused all your attention on the one part of my cock!"];
		tree[2] = ["#RHYD05#You gotta get my shaft sometime too. Just like you never skip leg day, well... Roar, You can't skip shaft day, either!"];
		tree[3] = ["#RHYD02#Otherwise your cock's gonna come out like a lollipop, all head and no shaft. Balance! Gr-roarr!"];

		if (!PlayerData.rhydMale)
		{
			DialogTree.replace(tree, 0, "cock", "pussy");
			DialogTree.replace(tree, 1, "cock", "pussy");
			DialogTree.replace(tree, 2, "shaft", "hole");
			DialogTree.replace(tree, 2, "get my hole", "get the actual hole");
			tree[3] = ["#RHYD02#Otherwise your pussy's gonna end up sticking out like a sausage, you'll be one giant clit and no hole. Balance! Gr-roarr!"];
		}
	}
	public static function sexyBadTooMuchShaft(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		tree[0] = ["#RHYD04#It's important to balance your exercise you know! Like yesterday for me was triceps/delts... And today's brain/cock."];
		tree[1] = ["#RHYD10#Although y'know, last time you kinda just focused all your attention on the one part of my cock!"];
		tree[2] = ["#RHYD05#You gotta give the tip some attention too. Just like you never skip leg day, well... Roar, You can't skip cockhead day, either!"];
		tree[3] = ["#RHYD02#Otherwise your cock's gonna come out like a soda can, all shaft and no head. Balance! Gr-roarr!"];

		if (!PlayerData.rhydMale)
		{
			DialogTree.replace(tree, 0, "cock", "pussy");
			DialogTree.replace(tree, 1, "cock", "pussy");
			DialogTree.replace(tree, 2, "the tip", "the clit");
			DialogTree.replace(tree, 2, "cockhead", "clitoris");
			tree[3] = ["#RHYD02#Otherwise your pussy's gonna come out lookin' like a belly-button, just a weird indentation with no clit at the top. Balance! Gr-roarr!"];
		}
	}

	public static function sexyBefore0(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		tree[0] = ["#RHYD04#It's important to balance your exercise you know! Like yesterday for me was triceps/delts... And today's brain/cock."];
		tree[1] = ["#RHYD05#You should never skip cock day!!! Otherwise your cock won't stay in proportion with the rest of your body."];
		tree[2] = ["#RHYD03#Alright, let's do this! Cock day, go!! Wroarrr!!!"];
		if (!PlayerData.rhydMale)
		{
			DialogTree.replace(tree, 0, "cock", "pussy");
			DialogTree.replace(tree, 1, "cock", "pussy");
			DialogTree.replace(tree, 2, "Cock", "Pussy");
		}
	}

	public static function sexyBefore1(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		if (!PlayerData.rhydonCameraUp)
		{
			tree[0] = ["%fun-camera-slow%"];
		}
		else
		{
			tree[0] = ["%fun-noop%"];
		}
		tree[1] = ["#RHYD06#Err, so before we start..."];
		tree[2] = ["%fun-camera-fast%"];
		tree[3] = ["#RHYD04#You remember how the camera button works, right?"];
		tree[4] = ["%fun-camera-fast%"];
		tree[5] = ["#RHYD05#...because this next part might not really work if you don't remember how to move the camera up and down!"];
		tree[6] = ["%fun-camera-fast%"];
		tree[7] = ["%fun-camera-fast%"];
		tree[8] = ["%fun-camera-fast%"];
		tree[9] = ["%fun-camera-fast%"];
		tree[10] = ["#RHYD02#Down! Up! Down! Up! Down! Up! Oop! Sorry. This thing's kinda fun."];
	}

	public static function sexyBefore2(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		tree[0] = ["#RHYD05#Well okay okay, the hard part's over!"];
		tree[1] = ["#RHYD01#...And now it's time for the REALLY hard part. If you know what I mean. Greh! Heh!"];
		tree[2] = ["#RHYD04#Say if you have any questions about the uhh, the 'equipment'. You're talkin' to an expert, you know!"];
		var answers:Array<Object> = [30, 20, 10, 40, 50];
		if (!PlayerData.rhydMale)
		{
			answers[2] = 60;
		}
		answers.splice(FlxG.random.int(0, 3), 1);
		answers.splice(FlxG.random.int(0, 2), 1);
		tree[3] = answers;
		tree[10] = ["What's with\nthese two\nheavy meat\nsacks"];
		tree[11] = ["#RHYD06#Roarr? You mean my... my testicles!?"];
		tree[12] = ["#RHYD00#...You're gonna have to get really familiar with my testicles if you're gonna handle the likes of me! Gr-roarr!!!"];
		tree[13] = ["#RHYD01#Why don't you three take some time and get acquainted. Go on, go ahead and give them a good squeeze~"];

		tree[60] = ["What's with\nthis meaty\npink\nabdominal\nnub"];
		tree[61] = ["#RHYD06#Roarr? You mean my... my clitoris!?"];
		tree[62] = ["#RHYD00#...You're gonna have to get really familiar with my clitoris if you're gonna handle the likes of me! Gr-roarr!!!"];
		tree[63] = ["#RHYD01#Why don't you two take some time and get acquainted. Go on, go ahead and give it a good poke~"];

		tree[20] = ["What's\nthis weird\nexoskeletal\ntit cover"];
		tree[21] = ["#RHYD06#Roarr? You mean my... my central pectoral ridge!?"];
		tree[22] = ["#RHYD00#I know it looks kinda like plating but-- that's all muscle! That's as hard as you want it to be, baby. Gr-roarr!!"];
		tree[23] = ["#RHYD01#Here, why don't you grab a hold of it. Grab it and I'll flex for you~"];

		tree[30] = ["What're\nthese\nsix scary\npointy\nbits\nsticking out"];
		tree[31] = ["#RHYD06#Roarr? You mean my... my hands? My hands and talons!?"];
		tree[32] = ["#RHYD12#They're not that scary! They're not that pointy! We weren't all born with magical... magical sex fingers like the likes of you!"];
		tree[33] = ["#RHYD08#Some of us have to make do with lunky sharp death talons."];
		tree[34] = ["#RHYD04#...It just makes me appreciate my special \"hand time\" a little bit more though!! C'mere, let me see what those soft fingers can do~"];

		tree[40] = ["What's this\nweird\npenis-shaped\npenis"];
		tree[41] = ["#RHYD05#..."];
		tree[42] = ["#RHYD14#Oh, roarr? I have no idea what you're talking about."];
		if (!PlayerData.rhydonCameraUp)
		{
			tree[43] = ["%fun-camera-slow%"];
		}
		else
		{
			tree[43] = ["%fun-noop%"];
		}
		tree[44] = ["#RHYD06#Penis-shaped penis? Are you talking about my elbows? Is it my chin? Is it somewhere up here?"];
		tree[45] = ["#RHYD02#Why don't you show me which part you're asking about. Greh! Heh-heh."];

		tree[50] = ["I know what\nI'm doing"];
		tree[51] = ["#RHYD01#Oh so you're already an expert huh?? Roar! We'll just see about that!"];
		tree[52] = ["#RHYD03#I wanna see you push my body to its limits! Let's do this!! Gr-r-r-roarrrrr!!!"];

		if (!PlayerData.rhydMale)
		{
			tree[1] = ["#RHYD00#...And now it's time for the, err. The soft part. Greh! Heh!"];
			DialogTree.replace(tree, 40, "penis", "vagina");
			DialogTree.replace(tree, 44, "Penis", "Vagina");
			DialogTree.replace(tree, 44, "penis", "vagina");
		}
	}

	public static function sexyBefore3(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		tree[0] = ["#RHYD04#Well that was a great mental workout! Roar!"];
		tree[1] = ["#RHYD02#Let's take five and then hit the showers afterwards... Greh! Heh. Heh."];
	}

	public static function sexyBefore4(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		tree[0] = ["#RHYD05#Phew! That was a good set of mental exercises. One last set left."];
		tree[1] = ["#RHYD00#So err, what kind of set is this gonna be anyways?"];
		tree[2] = [10, 30, 40, 20];

		tree[10] = ["An isolation\nexercise"];
		tree[11] = ["#RHYD12#...An \"isolation exercise\"!?"];
		tree[12] = ["#RHYD13#I know exactly which part you're gonna isolate! ...Lazy perv. Gr-roarrr!!!"];
		tree[13] = ["#RHYD05#Eh whatever, I'm curious to see what you come up with for your so-called \"isolation exercise\"."];
		tree[14] = [50];

		tree[20] = ["A drop set"];
		tree[21] = ["#RHYD06#...A drop set!?"];
		tree[22] = ["#RHYD11#Drop sets are fucking exhausting! A drop set of what exactly!? Are you sure you know what you're doing? Gr-roar!"];
		tree[23] = ["#RHYD10#Well whatever you've got planned... I mean, I'm pretty sure I can handle it."];
		tree[24] = ["#RHYD04#Yeah c'mon, I know I can handle it. I can handle anything you can dish out!"];
		tree[25] = [50];

		tree[30] = ["A cooldown"];
		tree[31] = ["#RHYD02#...Mmmmm, a cooldown. That sounds like just what I need after a workout like this~"];
		tree[32] = ["#RHYD00#Just relax... a little something low energy, a little something to keep my muscles active."];
		tree[33] = ["#RHYD01#Is that what you're gonna do? You're gonna activate my \"muscle\"? Yeah I bet you are! Grehh! Heh-heh!"];
		tree[34] = [50];

		tree[40] = ["I don't know"];
		tree[41] = ["#RHYD04#...So what, you're just gonna improvise somethin'? You don't have any kind of plan?"];
		tree[42] = ["#RHYD06#I mean, you get the best gains by sticking to a solid routine- But there's also a philosophy behind mixing it up once in awhile. It's called muscle confusion, gr-roar!"];
		tree[43] = ["#RHYD00#Is that what you're gonna do? You're gonna confuse my \"muscle\"? Yeah I bet you are! Grehh! Heh-heh!"];
		tree[44] = [50];

		tree[50] = ["#RHYD03#Show me what you got! Wr-r-roarrr!!!"];

		if (!PlayerData.rhydMale)
		{
			DialogTree.replace(tree, 33, "\"muscle\"", "\"muscles\"");
			DialogTree.replace(tree, 43, "\"muscle\"", "\"muscles\"");
		}
	}

	public static function newHelpDialog(tree:Array<Array<Object>>, puzzleState:PuzzleState, minigame:Bool=false)
	{
		var helpDialog:HelpDialog = new HelpDialog(tree, puzzleState);
		helpDialog.greetings = [
								   "#RHYD06#Roar? What's goin' on?",
								   "#RHYD06#Wroar? Did you need somethin'?",
								   "#RHYD06#Roar! I'm here to help! What's up?",
							   ];

		helpDialog.goodbyes = [
								  "#RHYD07#Aww, I can't do these by myself!",
								  "#RHYD07#Aww, don't leave me with the hard stuff!",
								  "#RHYD07#Yeah, this one's too much for me too...",
								  "#RHYD07#Yeah, some of these are really tough... R-roarrr...",
							  ];

		helpDialog.neverminds = [
									"#RHYD03#Back to the puzzle! No pain no gain! Wroarrrrr!",
									"#RHYD03#Back to work! Feel the burn!!! Power through!! Grr-roarrr!!",
									"#RHYD03#C'mon, you got this!! Rroooaarrrrr!!!",
								];

		helpDialog.hints = [
							   "#RHYD13#Yeah, what's with this puzzle anyways? Hey abra! Aaabrraaaaa!!! You made this puzzle too hard!",
							   "#RHYD13#Yeah one sec... Abra!!! Hey Abra, are you around here? This puzzle's freakin' impossible!",
							   "#RHYD03#Sure thing, I'll go search for help with my special emergency roar. Roar!!! Roar!!! Roar!!! Roar!!! Roar!!! Roar!!!"
						   ];

		if (minigame)
		{
			helpDialog.goodbyes = [
									  "#RHYD07#Yeah, this minigame's pretty confusing...",
									  "#RHYD07#Yeah, this is too much for me too...",
									  "#RHYD07#Yeah, this game is really tough... R-roarrr..."
								  ];
			helpDialog.neverminds = [
										"#RHYD03#Back to the minigame! No pain no gain! Wroarrrrr!",
										"#RHYD03#Back to work! Feel the burn!!! Power through!! Grr-roarrr!!",
										"#RHYD03#C'mon, you got this!! Rroooaarrrrr!!!",
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

		g.addSkipMinigame(["#RHYD06#Uhh? Well yeah! We can do something else.", "#RHYD05#Come follow me, let's go get some privacy."]);
		if (PlayerData.playerIsInDen)
		{
			g.addSkipMinigame(["#RHYD12#Hey yeah, why the hell are we letting a stupid coin tell us what to do anyway! Roar!", "#RHYD03#Let's go do something fun!"]);
		}
		else
		{
			g.addSkipMinigame(["#RHYD03#Hey yeah, Let's go do something fun! Roar!"]);
		}

		g.addRemoteExplanationHandoff("#RHYD04#So, the way you play is... Uhhhh... You know, let me go get <leader> for this.");

		g.addLocalExplanationHandoff("#RHYD04#Hey do you remember this one, <leader>?");

		g.addPostTutorialGameStart("#RHYD12#That was a lot of rules! Let's just go already!!");

		g.addIllSitOut("#RHYD05#Hey <name>, why don't you practice without me! I'll take you on after you bulk that brain up a little.");
		g.addIllSitOut("#RHYD05#...This doesn't seem like a fair match to me. <name>, I'll let you get in some practice first.");

		g.addFineIllPlay("#RHYD12#What? Well okay, but don't expect me to take a dive or nothing! I have my Rhydon pride! Roar!!");
		g.addFineIllPlay("#RHYD03#Okay, but watch out! Bigger Pokemon have bigger brains too! That's just science! Gr-roarr!");

		g.addGameAnnouncement("#RHYD06#Wait, which one is this? <Minigame>?");
		if (gameStateClass == StairGameState) g.addGameAnnouncement("#RHYD06#Wait, is this <minigame>? Awesome, I love this one!");
		if (gameStateClass == ScaleGameState) g.addGameAnnouncement("#RHYD06#Is this <minigame>? Ah geez, this one's really tough!");
		if (gameStateClass == ScaleGameState) g.addGameAnnouncement("#RHYD06#Oh man, we're stuck with <minigame>... This one hurts my head!");

		g.addGameStartQuery("#RHYD04#Well let's just get this over with, huh?");
		g.addGameStartQuery("#RHYD04#You ready to go?");
		g.addGameStartQuery("#RHYD04#Are we gonna do this or what?");

		g.addRoundStart("#RHYD03#Man I'm so pumped for this next round!! Let's go!", ["Yeah! I'm\npumped too~", "Let's do\nour best!", "Ehh\nwhatever"]);
		g.addRoundStart("#RHYD03#Hey! ...Who thinks they can pin me!", ["I don't think I'm\nin your weight class", "I bet I can pin\nyou, Rhydon", "Pay attention\nto the game..."]);
		g.addRoundStart("#RHYD03#Round <round> is the special roaring round! Roar! Roar!!", ["Uhh...\nRoar", "Is roaring\noptional?", "Roarr!"]);
		g.addRoundStart("#RHYD06#Wait, is it round <round> already? I didn't hear no bell!!", ["Wait... Like\na boxing match?", "Pay attention,\nRhydon", "What\nbell..."]);
		g.addRoundStart("#RHYD02#These minigames hurt my head... But it's a good kind of hurt! Gr-roar!", ["They're kind\nof easy...", "I'll make you\nfeel better~", "Feel the\nburn!"]);

		g.addRoundWin("#RHYD02#Grrroarr! What, you thought I was some kind of minigame slouch? I know what I'm doing!", ["Geez, brains\nAND brawn", "I can't lose\nto Rhydon...", "Good\njob"]);
		g.addRoundWin("#RHYD03#And the crowd goes wild! Rhy-don! Rhy-don!! Rhy-don!!! Grroarrrrr!", ["Oh my god\nplease stop", "What\ncrowd?", "Ha ha,\nnice work"]);
		g.addRoundWin("#RHYD02#I'm starting to sort of like this game! ...I mean it's alright!", ["It's only because\nyou're good at it", "I knew you'd\ncome around", "I kinda\nhate it"]);
		g.addRoundWin("#RHYD03#Rhydon wins again! Roar! Rhydon is the greatest! Double-groarrr!", ["Ow... My\nears...", "Rhydon, you ARE\nthe greatest", "...Sheesh..."]);

		if (gameStateClass == ScaleGameState && !PlayerData.playerIsInDen)
		{
			// many opponents...
			g.addRoundLose("#RHYD08#Geez, you guys are really good at this. How'd you all get so good?", ["We're just\nsmart", "We're not that\nmuch better", "It's tough\nisn't it"]);
			g.addRoundLose("#RHYD10#Man, I thought I was getting better but you guys are on a different level...", ["You ARE getting\nbetter, cheer up", "Gotta go\nfast", "<leader> is\nway too good|Sorry, it\nfeels unfair"]);
			g.addRoundLose("#RHYD07#... ...What the hell, guys! Seriously!?!", ["Yeah, what the\nhell, <leader>|Heh, sorry\nRhydon", "What?", "C'mon,\nfocus"]);
		}
		else
		{
			// single opponent...
			g.addRoundLose("#RHYD08#Geez, you're really good at this. How'd you get so good!?", ["It just comes\nnaturally", "I'm not that\nmuch better", "It's tough\nisn't it"]);
			g.addRoundLose("#RHYD10#Man, I thought I was getting better but you're on a different level...", ["You ARE getting\nbetter, cheer up", "Gotta go\nfast", "<leader> is\nway too good|Sorry, it\nfeels unfair"]);
			g.addRoundLose("#RHYD07#... ...What the hell, <leader>! Seriously!?!", ["Yeah, what the\nhell, <leader>|Heh, sorry\nRhydon", "What?", "C'mon,\nfocus"]);
		}
		g.addRoundLose("#RHYD06#Aww man! I thought I had that one. What went wrong!", ["<leader>'s\ntoo awesome|I'm too\nawesome", "You were a\nlittle too slow", "Sorry\nRhydon"]);
		g.addRoundLose("#RHYD11#I think I dropped one of the bugs on the floor... Can we have a do-over?", ["You clumsy\noaf!", "No do-overs", "How is that\neven possible?"]);

		if (gameStateClass == ScaleGameState) g.addWinning("#RHYD03#I win again!! As I win at all things!! Grehh-heh-heh-heh!", ["Gah...", "You're way faster\nthan I expected", "You won't be\nwinning for long"]);
		if (gameStateClass != ScaleGameState) g.addWinning("#RHYD03#I win again!! As I win at all things!! Grehh-heh-heh-heh!", ["Gah...", "You're way better\nthan I expected", "You won't be\nwinning for long"]);
		g.addWinning("#RHYD02#Groar! You thought I only cared about muscles, didn't you? Well ...the brain is a muscle too!!", ["Wow, I'm not\neven mad", "You're going\ndown, Rhydon", "The brain is\nnot a muscle..."]);
		if (gameStateClass == ScaleGameState) g.addWinning("#RHYD03#This game has awoken my competitive spirit! Rhydon will crush all of you!! Gr-rroarrr!", ["Ha ha, there's\nno way you'll win", "Take it easy,\nRhydon", "Oh,\ngeez..."]);
		if (gameStateClass != ScaleGameState) g.addWinning("#RHYD03#This game has awoken my competitive spirit! Rhydon will demolish you!! Gr-rroarrr!", ["Ha ha, there's\nno way you'll win", "Take it easy,\nRhydon", "Oh,\ngeez..."]);
		g.addWinning("#RHYD02#Yeah! Nothing can stop my momentum now! ...It's like... Newton's second law of Rhydon motion!", ["A Rhydon in motion...\ntends to stay in motion?", "That's not\nremotely accurate", "Hmmm..."]);

		g.addLosing("#RHYD10#How big is that giant brain of yours, <leader>!? You need to find an opponent in your own weight class...", ["Seriously,\n<leader>...|But you're my\nfavorite opponent!", "Bigger than that walnut\nof yours, that's for sure", "We can do\nit, c'mon!|You can do\nit, Rhydon"]);
		g.addLosing("#RHYD13#This is the round that Rhydon mounts " + (PlayerData.rhydMale ? "his" : "her") + " unprecedented comeback! Gr-roarr!", ["Uhh, good\nluck...", "You can\ndo it!", "<leader> is WAY\ntoo far in the lead...|Ha ha, I'd like\nto see you try..."]);
		if (FlxG.random.bool(50)) g.addLosing("#RHYD12#I'm still in this, don't write me off yet! You should NEVER write me off! ...I'm not a write-off, I'm a write ON!!", ["Groaannnn...", "You're still\nin this!", "\"Write on?\" That\nis such a stretch..."]);
		g.addLosing("#RHYD06#Is there a way I can practice this on my own? ...I want to get good, too!", ["As long as you're\nhaving fun", "I need to\npractice, too...|I practiced\na lot", "Yeah, you\nshould practice!"]);
		g.addLosing("#RHYD07#Groarr... Maybe I should throw in the towel...", ["I'll take\nthat towel~", "Was that\nyour best?", "<leader>'s\nso quick...|Sorry, maybe\nnext game"]);
		if (gameStateClass == ScaleGameState) g.addLosing("#RHYD00#Groar, how am I losing at this stupid weighing game? ...I'm usually so good at weight!", ["Hey, you're doing\na great job", "It's hard with more\nthan one scale!", "Fat does not\nequal smart"]);

		g.addPlayerBeatMe(["#RHYD10#Wellp... Chalk that one up to inexperience! Don't go thinking you're smarter than me just because you beat me once...", "#RHYD05#I'm gonna practice, I'm gonna practice until I'm unstoppable at this game! And...", "#RHYD03#...And we're gonna have a rematch! Wroar! And I'm gonna beat you! Grrroar! And we're gonna have an ultimate puzzle battle for the ages! Double gro-o-arrrr!"]);
		g.addPlayerBeatMe(["#RHYD02#Wow, you are so insanely good at this puzzle stuff. If I'm like, a puzzle middleweight...", "#RHYD03#You're like... Some sorta puzzle ultra-heavyweight! With a blackbelt, and also you have superpowers!", "#RHYD04#I mean, I'll keep playing with you <name>! But wow, I'm gonna have to really up my game if I'm gonna compete with the likes of you! Gr-roarr!"]);

		g.addBeatPlayer(["#RHYD03#Gr-roarrrr!! And the winner of the ultimate challenge is... Rhydonn!! Gr-rroarrrrrrrr!!", "#RHYD02#Sorry <name>! I won, so you gotta hand over your belt.", "#RHYD04#...", "#RHYD06#Wait, there's no belt? ...Then why was I trying so hard!?!"]);
		g.addBeatPlayer(["#RHYD03#Yeah! Rhydon is the winnerr! Grrroarrrrr! Gr-rr-roarrrrrr!! I can't wait to tell, uhh...", "#RHYD04#I can't wait to tell... Uhhh... Who do I know that would actually be interested in this...", "#RHYD06#...", "#RHYD02#Hey <name> I like, totally beat you at a minigame!!"]);

		g.addShortWeWereBeaten("#RHYD04#Good job <leader>, I'll get you next time! Good playing with you, <name>!!");
		g.addShortWeWereBeaten("#RHYD02#Aww, can't win 'em all. I'm glad we got to play together, <name>!");

		g.addShortPlayerBeatMe("#RHYD02#Great fighting!! You were tough, <name>! I've never seen such finger speed before.");
		g.addShortPlayerBeatMe("#RHYD03#Enough of this mental stuff! Next time <name>, it's turkish oil wrestling! Greh-heh-heh!");
		g.addShortPlayerBeatMe("#RHYD05#Amazing as always <name>! It's crazy how good you are at this puzzle stuff.");

		g.addStairOddsEvens("#RHYD05#How 'bout we do odds and evens to see who starts? You're odds, I'm evens. Throw 'em out on three, ready?", ["Sure, sounds\ngood", "Okay,\non three!", "I'm\nodds...?"]);
		g.addStairOddsEvens("#RHYD04#So someone's gotta start... How about we do odds and evens? ...Odds you start, evens I start. Ready?", ["Odds,\nI start...", "Sure, let's\nleave it up\nto chance", "Alright!"]);

		g.addStairPlayerStarts("#RHYD12#Waydigo, <name>. You ruined my odds and evens winning streak! Wr-roar!! ...Anyway, guess that means you go first. You ready?", ["Heh, sorry", "Yeah!\nReady", "That's a\nweird thing to\nkeep track of..."]);
		g.addStairPlayerStarts("#RHYD06#Odd huh? Guess you go first, <name>. Not that it matters a whole lot in this game! ...You ready for your first throw?", ["Hmm yeah,\nI'm ready!", "It seems like\nan advantage...?", "I hope I'm\nnot captured"]);

		g.addStairComputerStarts("#RHYD02#Even huh? Well that's a good omen! I guess I get to go first. Let's see if we can keep up my winning streak! You ready?", ["Sure! I'm ready", "Lucky streak?\nUh oh...", "Wait, have\nyou played\nthis a lot?"]);
		g.addStairComputerStarts("#RHYD02#Guess I'm first! You're gonna have to roll better than that if you wanna beat me. ...You ready?", ["What, you\ndon't think\nI can win?", "Hmm, what\nshould I roll...", "Yep"]);

		g.addStairCheat("#RHYD13#Wr-roar?? You're doing it wrong! ...Do it right!!! Throw your dice out when I throw mine. That was really late!", ["I'll throw\nthem early,\njust in case...", "What? You\nwere way early!", "Oh, okay"]);
		g.addStairCheat("#RHYD12#Are you trying to cheat or something? You gotta throw your dice way earlier than that! No fair looking at my dice before you throw.", ["Hmm, okay...", "Stop counting\nso fast", "But then\nit's all luck!"]);

		g.addStairReady("#RHYD04#You ready, <name>?", ["Okay", "Yeah,\nready!", "Ahh! You're\nso loud..."]);
		g.addStairReady("#RHYD03#Ready? Gr-roar!", ["Whoa! Uh,\nnot yet", "Let's go!", "Let me\nthink..."]);
		g.addStairReady("#RHYD05#Ready <name>?", ["I think?", "Almost,\nhmm...", "Yeah I'm\nready"]);
		g.addStairReady("#RHYD05#On three, okay?", ["Uh, just\none second...", "Okay!", "Sure"]);
		g.addStairReady("#RHYD04#Ready? On three!", ["Yep", "Yeah,\ndo it!", "Uh, just\na minute..."]);

		g.addCloseGame("#RHYD05#Whoa! You're really makin' me work for this one. That's okay! I love a challenge! Grar!", ["\"Grar?\" What\nkind of weak-ass\nroar was that!", "Heh, you thought\nI would\ntake a dive?", "Feel the\nburn~"]);
		g.addCloseGame("#RHYD10#I think I saw those two bugs humping over there! ...Do you think Heracross sells like, tiny squirt bottles or something?", ["Aww, you want\nthem to stop?", "Hey, hands\noff my bugs!", "You were probably\nseeing things..."]);
		g.addCloseGame("#RHYD04#How come you don't throw more zeroes on my turn? Zeroes are really good! ...People don't use their zeroes enough.", ["Well...\nIt's not\nthat simple...", "Ehh? Is this\na trick?", "That's such\na novice\nthing to say!"]);
		g.addCloseGame("#RHYD04#Groar! ...Good ol' two. Nothing's bigger than two! Let's go!", ["Kind of a\nsimplistic\nviewpoint...", "You don't\nALWAYS want to\nthrow a two!", "How have I\nnot crushed\nyou yet?"]);

		g.addStairCapturedHuman("#RHYD03#Wr-r-r-roarrrrr! You're in Rhydon's house now! ...Rhydon takes no prisoners!", ["That was a\nlucky guess...", "...Who would\nkeep prisoners\nin their house?", "Ahh! Take it\neasy on me"]);
		g.addStairCapturedHuman("#RHYD03#And the crowd goes wild! Groarrrrr!! Rhydon, the undisputed champion of... fucking up <name>'s shit! Greh-heh! Heh-heh-heh!", ["...I'd like to\ndispute that", "Hey, watch\nyour language!", "Ahh, just shut\nup already"]);
		g.addStairCapturedHuman("#RHYD03#Ohhhhh and <name>'s down for the count! One! Two! Three! Four! Five! Six! Is this it? Has <name> given up?", ["What, you can't\ncount to seven?", "I'm up,\nI'm up...", "Ahh! ...You're so\ngood at this!"]);

		g.addStairCapturedComputer("#RHYD11#Groar? What happened? I threw out a <computerthrow> like I always do! Why didn't that work? That always works!", ["You can't be\nso predictable,\nRhydon", "Well,\ndoesn't work\nagainst me~", "Heh! Sorry,\nbuddy"]);
		g.addStairCapturedComputer("#RHYD11#Ahh! Get up! Get up little guy!! ...I didn't hear no bell! That's it, one more round! You can do it!! Gr-roarr!", ["Bell?\nWhat bell?", "Better to go\ndown swinging,\nright?", "Sometimes you\njust gotta\nstay down..."]);
		g.addStairCapturedComputer("#RHYD11#Grah! I really didn't think you'd have the guts to throw a <playerthrow>... How'd you know that was gonna work?", ["Good intuition,\nI guess~", "What!? It\nwas obvious...", "It was\npure luck"]);
		g.addStairCapturedComputer("#RHYD07#Can't... Think... Brain no work... I'm so sorry! I've let my little " + comColor + " friends down...", ["Aww, they're in\na better place.\nAt the bottom\nof the stairs~", "Don't give\nup now!", "You did\nyour best..."]);

		return g;
	}

	public static function bonusCoin(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#RHYD05#Whoa! No way! You found a bonus coin!?! What are the odds!"];
		tree[1] = ["#RHYD03#...No seriously, what are the odds? Hey! Hey Abra!!! Abraaaa!! What are the odds of finding a bonus coin?"];
		tree[2] = ["#RHYD04#..."];
		tree[3] = ["#RHYD06#Huh, he didn't hear me! I guess I need to yell louder. Oh uhh, wait! We're supposed to play a bonus game or something, aren't we? Gr-roar!"];

		if (!PlayerData.abraMale)
		{
			DialogTree.replace(tree, 3, "he didn't", "she didn't");
		}
	}

	public static function noMoreHookups(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["%entersand%"];
			tree[1] = ["#sand05#Ayyy what's up Rhydon! A couple of us are goin' down to the gym, you wanna come with?"];
			tree[2] = ["#RHYD05#Nah I'll pass, I'm a little busy here. Besides, I already went earlier today with Nidoking."];
			tree[3] = ["#sand15#Tsk man, what's with you goin' so early anyways?? You know all the fun stuff happens at night~"];
			if (!PlayerData.sandMale)
			{
				DialogTree.replace(tree, 3, "man, what's", "girl, what's");
			}
			tree[4] = ["#RHYD02#Greh! Heh-heh-heh. Yeah don't worry. I know when the fun stuff happens."];
			tree[5] = ["%exitsand%"];
			tree[6] = ["#sand14#Alright whatever, see you later."];
			tree[7] = ["#RHYD04#So err, where were we, <name>..."];
			tree[8] = [20, 30, 40, 50];

			tree[20] = ["You should\ngo"];
			tree[21] = ["#RHYD05#Nah, Sandslash's just going there to hook up. I'd rather be here doing puzzle stuff with you."];
			tree[22] = [60];

			tree[30] = ["Thanks for\nstaying"];
			tree[31] = ["#RHYD05#No problem, Sandslash is just going to the gym to hook up anyways. I'd rather be here doing puzzle stuff with you."];
			tree[32] = [60];

			tree[40] = ["What about\nSandslash?"];
			tree[41] = ["#RHYD05#Heh heh, Sandslash is just going there to hook up. I'd rather be here doing puzzle stuff with you."];
			tree[42] = [60];

			tree[50] = ["\"The fun\nstuff?\""];
			tree[51] = ["#RHYD05#Yeah, the gym is where a lot of Pokemon go to hook up. But it's OK, I'd rather be doing puzzle stuff with you anyways."];
			tree[52] = [60];

			tree[60] = ["#RHYD03#So c'mon, let's puzzle it up!! Roarrrr!! Puzzle time!"];
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["#RHYD04#Yeah I won't lie, I still screw around every once in awhile at the gym but- I know it's not good for me."];
			tree[1] = ["#RHYD05#Worst case scenario is like, I just don't meet anybody or things just fizzle out that night. No big."];
			tree[2] = ["#RHYD12#But the *WORST* worst case scenario is actually meeting someone. 'Cause like, nobody's ever looking for anything long term there,"];
			tree[3] = ["#RHYD06#So on the off chance that I actually meet someone, it's like..."];
			tree[4] = ["#RHYD09#..."];
			tree[5] = ["#rhyd08#...It just kinda sucks to grow attached to a guy and then the next week he's moved onto someone new, you know?"];
			tree[6] = ["#rhyd09#It's the shittiest feeling realizing someone means more to you than you mean to them. I... I never get used to it."];
			tree[7] = ["#rhyd04#So... *cough* YEAH, I'M KIND OF OVER THE GYM SCENE."];
			tree[8] = ["#RHYD05#Nidoking and I still use the gym for actual exercise, though!! He's a good workout partner. He keeps me motivated!"];
			tree[9] = ["#RHYD02#...Just like I keep you motivated for all these awesome puzzles!! I'm kind of your puzzle partner, huh? Roarrr!!"];
			tree[10] = ["#RHYD03#Let's crack out another puzzle! Wroarr! I believe in you!! Grr-roarrrrr!!!"];
			tree[11] = [50, 30, 20, 40];

			tree[20] = ["Thanks\nRhydon!"];
			tree[21] = ["#RHYD02#Grrr-rrroarrrr!!!"];

			tree[30] = ["Yeah,\nroar!!"];
			tree[31] = ["#RHYD02#Grrr-rrroarrrr!!!"];

			tree[40] = ["You'll meet\nsomeone"];
			tree[41] = ["#RHYD10#..."];

			tree[50] = ["It's OK to\nbe sad"];
			tree[51] = ["#RHYD10#..."];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 5, "a guy", "a girl");
				DialogTree.replace(tree, 5, "he's moved", "she's moved");
			}
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["#RHYD04#Anyway yeah, don't worry about me! I've got a bunch of good friends... Especially you, Nidoking, Grovyle and the other guys who live here."];
			if (!PlayerData.sandMale)
			{
				DialogTree.replace(tree, 0, "other guys", "other girls");
			}
			tree[1] = ["#RHYD02#And if I'm ever feeling horny or whatever, I've got a sexual outlet in the gym, plus a couple fuck buddies like Sandslash who are eager to help out."];
			tree[2] = ["#RHYD05#That's about all I need."];
			tree[3] = [30, 10, 40, 20];

			tree[10] = ["Hey I'm a\nfuck buddy\ntoo"];
			tree[11] = ["#RHYD06#Roarrr??? Are you sure? You might be biting off a little more than you can chew!"];
			tree[12] = ["#RHYD00#I'm a *MIGHTY* *DINOSAUR* and I have some *MIGHTY* *DINOSAUR* *NEEDS*!! And you're only like 5% of a person!"];
			tree[13] = ["#RHYD01#Well... Okay! Let's knock out this last puzzle and then... We'll see if you can handle my full Rhydon power!!!"];
			tree[14] = ["#RHYD03#Last puzzle! Wroarrr!! I'm gonna ruin that pretty hand of yours!!! Grr-roarrrrr! You can't handle my maximum Rhydon lust level!! Double grroarrrrrr!!!"];

			tree[20] = ["I'm a\nfriend?\nThat's sweet\nof you!"];
			tree[21] = ["#RHYD02#Roarrr??? Well of course YOU'RE a friend!"];
			tree[22] = ["#RHYD04#...Even if I've only seen you as this disembodied cursor thing, I feel like we have a special connection."];
			tree[23] = ["#RHYD05#In a way I feel closer with you than anyone else, just 'cause we can kinda talk about anything! I don't gotta worry about hurting your feelings, or, you know..."];
			tree[24] = ["#RHYD00#...It's just really nice to have someone who listens sometimes."];
			tree[25] = ["#RHYD06#...Hey!!! We can't close on a mushy note, I still gotta get you pumped up for your last puzzle!!!"];
			tree[26] = ["#RHYD03#Last puzzle! Wroarrr!! Puzzle friendship power!!! Grr-roarrrr!!! Nothing can withstand the power of our ultimate friendship!! Double grrroarrrrrr!!!"];

			tree[30] = ["Sounds like\nyou've got\nit figured\nout"];
			tree[31] = ["#RHYD02#Yeah, what can I say! We can't always plan every detail of our lives. I'm happy right now, and sometimes you gotta go through life one day at a time."];
			tree[32] = ["#RHYD04#The only time I start feeling sad and lonely... is when people start getting on my case about how sad and lonely I must be."];
			tree[33] = ["#RHYD08#It's like... There's no point in just making yourself sad by dwelling on how sad you think you are, right?"];
			tree[34] = ["#RHYD13#What sort of... recursive self-fulfilling bullshit is that!? Roar!"];
			tree[35] = ["#RHYD12#...Hey!!! We can't close on a weird philosophical note, I still have to get you pumped for the last puzzle!!!"];
			tree[36] = [26];

			tree[40] = ["Sounds like\nyou're in\ndenial"];
			tree[41] = ["#rhyd09#..."];
			tree[42] = ["#rhyd08#...Well I mean..."];
			tree[43] = ["#rhyd05#I'm still happy most of the time! Actually, *cough*"];
			tree[44] = ["#RHYD09#Actually, the only time I start feeling sad and lonely... is when people start getting on my case about how sad and lonely I must be."];
			tree[45] = [34];
		}
	}

	public static function cameraBroken(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			if (PlayerData.rhydonCameraUp)
			{
				tree[0] = ["%fun-camera-instant%"];
			}
			else
			{
				tree[0] = ["%fun-noop%"];
			}
			tree[1] = ["#RHYD04#Well I'm pretty sure I'm in the right place... I mean the green screen's here, and the camera's here..."];
			tree[2] = ["#RHYD05#...So where's the guy who's supposed to solve all these puzzles?"];

			tree[3] = [30, 10, 40, 20];

			tree[10] = ["I'm right\nhere"];
			tree[11] = ["#RHYD06#...Huh? Oh is that you?"];
			tree[12] = ["#RHYD04#But am... am I seriously supposed to talk to just a hand? ...Where's the rest of you!!!"];
			tree[13] = ["#RHYD02#You're not going to... I mean you couldn't solve... Well this I gotta see!!!"];

			tree[20] = ["He's not\nhere yet"];
			tree[21] = [11];

			tree[30] = ["Stop\nyelling"];
			tree[31] = [11];

			tree[40] = ["Is your\nshift key\nbroken"];
			tree[41] = ["#RHYD06#Shift key!?! ...Huh? Oh is that you?"];
			tree[42] = [12];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 2, "the guy", "the girl");
				DialogTree.replace(tree, 20, "He's", "She's");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 20, "He's", "They're");
			}
			if (!PlayerData.rhydMale)
			{
				tree[3] = [30, 10, 50, 40, 20];

				tree[50] = ["A female\nRhydon!?!"];
				tree[51] = ["#RHYD13#What, so a woman can't be a 20 stone muscly reptile? Is that what you're saying? Huh?? That's loser talk!!"];
				tree[52] = ["#RHYD03#Losers sit around and complain about deviations from mainstream gender roles!!! Winners go home and fuck the female Rhydon! Grrroarrrr!!"];
				tree[53] = ["#RHYD05#Open your mind a little! I mean, you didn't see me making a big deal out of how you're just a creepy disembodied hand!!"];
				tree[54] = ["#RHYD04#I mean am... am I seriously supposed to talk to just a hand? ...Where's the rest of you!!!"];
				tree[55] = [13];
			}
		}
		else if (PlayerData.level == 1)
		{
			var checksum:Int = LevelIntroDialog.getChatChecksum(puzzleState);

			tree[0] = ["#RHYD12#Why didn't you tell me the camera was zoomed in on my better half last time!"];
			if (!PlayerData.rhydonCameraUp)
			{
				tree[1] = ["%fun-camera-slow%"];
				tree[2] = ["#RHYD05#I guess you probably didn't find that button which moves the camera up and down."];
			}
			else
			{
				tree[1] = ["%fun-noop%"];
				tree[2] = ["#RHYD05#I guess it's good that you found that button which moves the camera up and down."];
			}
			tree[3] = ["#RHYD04#Unless you just like staring at my balls all the time huh?"];
			tree[4] = [30, 10, 40, 20];

			tree[10] = ["Yes, I\nlike it"];
			tree[11] = ["#RHYD06#You're saying you like looking at my balls?? ...More than looking at my face!?"];
			tree[12] = ["#RHYD12#Well thanks for the backhanded compliment!! Grroarrrr!"];
			tree[13] = ["#RHYD10#Err wait, I didn't mean..."];
			tree[14] = ["#RHYD09#I said backhanded because, err you know! It wasn't because you're just a hand or anything."];
			tree[15] = ["#RHYD06#...Seriously, what happened to the rest of you? ...Was there an accident??"];

			tree[20] = ["No, you\nhave a\nnice face"];
			tree[21] = ["#RHYD06#So you're saying that my face looks better than my balls??"];
			tree[22] = [12];

			tree[30] = ["Seriously\nstop yelling"];
			tree[31] = ["#rhyd05#GROARRR!! What, do you want me to whisper? Like this?"];
			tree[32] = ["#rhyd04#...This feels REALLY UNNATURAL! But on the OTHER HAND, I don't want to bother you with my..."];
			tree[33] = ["#rhyd10#Err, wait, I didn't mean..."];
			tree[34] = ["#rhyd09#I said \"on the other hand\" because, err you know! It wasn't because I was wondering about your other hand."];
			tree[35] = ["#rhyd06#...Seriously, what happened to the rest of you? ...Was there an accident??"];

			tree[40] = ["Seriously\nyour shift\nkey"];
			tree[41] = [31];

			if (checksum % 5 <= 1)
			{
				tree[4] = [30, 50, 40, 20];
				tree[50] = ["\"Better\nhalf?\""];
				tree[51] = ["#RHYD06#You're saying that's my better half...?? That you like looking at my balls... more than looking at my face!?"];
				tree[52] = [12];
			}
			if (!PlayerData.rhydMale)
			{
				DialogTree.replace(tree, 0, "balls", "crotch");
				DialogTree.replace(tree, 3, "balls", "crotch");
				DialogTree.replace(tree, 11, "balls", "crotch");
				DialogTree.replace(tree, 51, "balls", "crotch");
				DialogTree.replace(tree, 21, "balls", "crotch");
				DialogTree.replace(tree, 21, "looks better than", "is prettier than");
			}
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["#rhyd05#So this hand accident... Did they err, did they perform surgery to keep just your hand alive? Or did they... *cough* *cough*"];
			tree[1] = ["#RHYD03#Oh that's better, I was saying, is this your original hand? Or did they make you a new different hand?"];
			tree[2] = [30, 70, 50, 90, 10];

			tree[10] = ["It's my\noriginal\nhand"];
			tree[11] = ["#RHYD02#Whoa that's actually kind of awesome!! Your whole body got destroyed but you just kept going huh?? Nothing can stop you!"];
			tree[12] = ["#RHYD05#Like in that terminator movie where the-"];
			tree[13] = ["%enterabra%"];
			tree[14] = ["#abra09#Rhydon. I told you before, that's just a cursor. He's controlling it remotely."];
			tree[15] = ["#RHYD12#Yeah yeah okay, JOKE'S OVER, Wee-ooooo-wee-ooooo-wee-ooooo, the joke police are here."];
			tree[16] = ["#RHYD04#C'mon I was just screwing with him! What do you... do you think I'm slow or something?"];
			tree[17] = ["#abra04#Hmmm well,"];
			tree[18] = ["%exitabra%"];
			tree[19] = ["#abra05#..."];
			tree[20] = ["#RHYD03#Greh-heh. That guy has NO respect for me whatsoever! ...Anyway one last puzzle, right? Puzzle gooooo! Grroaarrrrr!!"];

			tree[30] = ["It's a\nnew hand"];
			tree[31] = [11];

			tree[50] = ["It's just\nmy cursor"];
			tree[51] = ["#RHYD12#Yeah yeah okay, JOKE'S OVER, Wee-ooooo-wee-ooooo-wee-ooooo, the joke police are here."];
			tree[52] = ["#RHYD04#C'mon I was just screwing with you! You thought I was serious about the disembodied hand stuff?? C'mon! Wrroar!"];
			tree[53] = ["#RHYD03#Alright one last puzzle. Puzzle gooooo! Grroarrrr!!"];

			tree[70] = ["Back to the\nyelling?"];
			tree[71] = ["#RHYD04#See <name>, your problem is you see everything as a negative. If you come at this from the glass half empty side of course my voice seems annoying!"];
			tree[72] = ["#RHYD02#But... You gotta channel the positive energy in my yelling! Every capital letter fills you with puzzle-solving power!!"];
			tree[73] = ["#RHYD03#You can do it! Roarrrrrrr!! And you like Rhydon using capital letters! Wroarrrr!! You find it endearing! Double-groarrrrrr!"];

			tree[90] = ["Your shift\nkey, c'mon"];
			tree[91] = [71];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 14, "He's controlling", "She's controlling");
				DialogTree.replace(tree, 16, "with him", "with her");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 14, "He's controlling", "They're controlling");
				DialogTree.replace(tree, 16, "with him", "with them");
			}
			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 20, "That guy", "That girl");
			}
		}
	}

	public static function topBottom(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		// Nidoking is a boy. Blaziken is a girl. Quilava is the player's gender.

		if (PlayerData.level == 0)
		{
			tree[0] = ["%entergrov%"];
			tree[1] = ["#grov06#So Rhydon, I was just curious, ahh... What exactly is the nature of your sexual relationship with Nidoking anyways??"];
			tree[2] = ["#RHYD10#My uhhh..."];
			tree[3] = ["#grov10#...Sorry to be so blunt! I just know he's with Blaziken, and well..."];
			tree[4] = ["#RHYD04#Oh uhhh, yeah no sweat!! My life's an open book. Just caught me off guard is all."];
			tree[5] = ["#RHYD05#Nidoking? So yeah Nidoking's mostly straight, he's seeing Blaziken! They've been seeing each other for a few years now, they've got a good thing going."];

			if (!PlayerData.rhydMale)
			{
				DialogTree.replace(tree, 5, "Nidoking's mostly straight, he's seeing Blaziken", "as far as Nidoking and Blaziken");
			}

			tree[6] = ["#RHYD00#But Nidoking and I have kind of a fuck buddy relationship that goes way back. Blaziken's cool with it, sometimes she watches us!!"];
			tree[7] = ["#RHYD01#Actually she... she reeeeeeeaally likes to watch~"];
			tree[8] = ["#grov03#But aren't you and Nidoking both sort of, err... sexually dominant? ...How's that work?"];
			tree[9] = ["#grov00#...In detail, I mean..."];
			tree[10] = ["#RHYD06#Roarrr?? Well, when we're together Nidoking's the, uhh... he assumes a dominant role..."];
			tree[11] = ["#RHYD03#We're both still tops! I'm like, totally a top!! Groarrrr!!! It's just that he err. That someone has to, well... I mean..."];
			tree[12] = ["#RHYD06#It's different when he does it! I'll have to think about that one."];
			tree[13] = ["#grov05#Ahh, I see."];
			tree[14] = ["%exitgrov%"];
			tree[15] = ["#grov02#Well, I'll let you think."];
			tree[16] = ["#RHYD04#Hmm. What does Nidoking do differently...? Hey, this is a hard question! Roarrrr!! Give me a puzzle to think about it."];
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["#RHYD06#So I think what I really hate about \"being a bottom\" is this whole attitude a lot of tops take,"];
			tree[1] = ["#RHYD12#This whole, \"hold still and let me do my thing,\" \"you're just a worthless bitch\" attitude."];
			tree[2] = ["#RHYD13#This attitude that they're doing everything important and I'm just a... just a living fleshlight unworthy of accepting their cock!!"];
			tree[3] = ["#RHYD12#...I'm getting steamed just talking about it.... Grroarrr! And EVERYONE does it, it wasn't just one bad experience. I'm just sick of being treated that way by everybody."];
			tree[4] = [20, 30, 10, 40];
			tree[10] = ["Like\nBanette?"];
			tree[11] = ["#RHYD13#Gr-roarrr. Yeah exactly, pinning me on my stomach, and going through his whole \"you'll take my dick and like it\" routine."];
			tree[12] = ["#RHYD08#We get along okay now but, we couldn't BE more sexually incompatible. Just thinking back to it creeps me out!!"];
			tree[13] = [50];

			tree[20] = ["Like\nQuilava?"];
			tree[21] = ["#RHYD06#Groar?? Well I felt like he was letting me top but... He did kind of control the situation a bit. I guess maybe Quilava fits a little."];
			tree[22] = ["#RHYD08#I think I was annoyed by Quilava for a different reason than the top thing."];
			tree[23] = [50];

			tree[30] = ["Like\nNidoking?"];
			tree[31] = ["#RHYD06#Roar!? Nidoking doesn't really treat me that way."];
			tree[32] = [50];

			tree[40] = ["Like\nSandslash?"];
			tree[41] = ["#RHYD06#Roar!? What are you talkin' about? Sandslash and I, we get along great."];
			tree[42] = ["#RHYD04#Sandslash treats me with respect, gives me plenty of control when we screw around."];
			tree[43] = [50];

			tree[50] = ["#RHYD05#Anyway, break time's over! Why don't you try this next puzzle."];

			if (!PlayerData.rhydMale)
			{
				DialogTree.replace(tree, 2, "accepting their cock", "being fucked by them");
			}
			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 21, "he was", "she was");
				DialogTree.replace(tree, 21, "He did", "She did");
			}
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["#RHYD04#See, the way I see it sex is a partnership. Maybe not an equal partnership but-- not just a one way thing either!!"];
			tree[1] = ["#RHYD09#I don't just wanna lay there, and I don't want folks belittling my role or emasculating me while we're screwing around..."];
			tree[2] = ["#RHYD00#I think that's why Nidoking and I get along so well, roarrr. I'm not his bitch, we're both just bros and he respects me and cares about me."];
			tree[3] = ["#RHYD01#You and I sort of have the same thing goin' now that I think about it, you're definitely in control during our, uhhh, sessions..."];
			tree[4] = ["#RHYD05#But you always see to my needs and treat my body with respect!! ...I'm not just a toy to you or anything."];
			tree[5] = ["#RHYD06#Speaking of which we're uhh, we're pretty close to that part aren't we?"];
			tree[6] = ["#RHYD14#Wait, is this the last puzzle!?! You need some MOTIVATIONAL RHYDON YELLING don't you!!!"];
			tree[7] = [20, 10, 30];

			tree[10] = ["No\nthanks"];
			tree[11] = [40];

			tree[20] = ["Yes\nplease"];
			tree[21] = [40];

			tree[30] = ["What!?"];
			tree[31] = [40];

			tree[40] = ["#RHYD03#You're super great!! Roarrrr! Puzzle-solving is a partnership too!!! Wrrroarrrrrrr! You're going to fuck me respectfully afterwards!!! Maximum gr-roarrrrrrr!!!"];

			DialogTree.replace(tree, 1, "emasculating me", "dehumanizing me");
			DialogTree.replace(tree, 2, "just bros", "just partners");
		}
	}

	public static function random01(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#RHYD04#Roarr! How's it going! Did you get enough sleep last night?"];
		tree[1] = ["#RHYD03#Is your brain ready for some extreeeeeeme puzzle action!?! Grr-roarrrr!!"];
		tree[2] = ["#RHYD02#Why don't you show me what you got!"];
	}

	public static function random02(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#RHYD02#Alright! Back for another mental workout with your favorite puzzle partner, huh??"];
		tree[1] = ["#RHYD03#One puzzle rep per set! Three puzzle sets total!! Let's push it to the maximum!!! Grrr-roarrrrrr!!!!!"];
	}

	public static function random03(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#RHYD02#Back for more, eh? Must be my natural Rhydon charm!! Greh! Heh! Heh!"];
		tree[1] = ["#RHYD03#Let's knock these puzzles out!! Roar!! These little peg bugs won't know what hit them! Wrrrrroarrr!!!"];
		tree[2] = ["#RHYD10#...They won't know what hit them figuratively, I mean! Double-grrroarrrrr!!!"];
	}

	public static function gift04(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["%fun-alpha0%"];
		tree[1] = ["#luca04#Here's your twelve Effen Pizzas, and with your coupon that's... ^9,600!"];
		tree[2] = ["#RHYD06#No see, uhhhh, I've got this other coupon too! ...I want to use both of 'em together."];
		tree[3] = ["#luca10#Kyehh? Let me see that... ... Ohh yeah, see this here at the bottom? \"Coupon can now be combined with any... other...\""];
		tree[4] = ["#luca11#Wait, \"Can NOW be combined!?\" ...Kkkkkkh well that's a really... BAD typo..."];
		tree[5] = ["#luca10#...Uhhh just out of curiosity, HOW many of those coupons do you have left exactly?"];
		tree[6] = ["#RHYD02#Ohhh don't worry, I've got a whole pile of 'em! You can thank <name> for that. ...I guess we'll be seeing a lot more of each other! Grehh! Heh!"];
		tree[7] = ["#luca09#Kyahhhhhhh... A whole pile of..."];
		tree[8] = ["#luca05#Oh! Wait, is... Is <name> here right now?"];
		tree[9] = ["#RHYD04#Yeah! Sure! ...You wanna stick around?"];
		tree[10] = ["#luca01#Well... If that's alright... ..."];
		tree[11] = ["%fun-alpha1%"];
		tree[12] = ["#RHYD02#Grehh! Heh heh heh! Okay <name>, I guess we got a little audience this time."];
		tree[13] = ["#RHYD03#Why don't you show off what you can do with these puzzles, and I'll show off what I can do with these pizzas! Gr-roarrr!!!"];

		tree[10000] = ["%fun-alpha1%"];
	}

	public static function random00(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var checksum:Int = LevelIntroDialog.getChatChecksum(puzzleState);
		var which:Int = checksum % 3;

		if (PlayerData.rhydonCameraUp)
		{
			// ensure camera points at the ground
			tree[0] = ["%fun-camera-instant%"];
		}
		else
		{
			tree[0] = ["%fun-noop%"];
		}
		tree[1] = ["#RHYD03#Hey!! Why's this thing always pointing at my better half!?"];
		tree[2] = ["%fun-camera-slow%"];
		tree[3] = ["#RHYD14#Alright that's better. So... notice anything different?"];
		tree[4] = [40, 20, 30, 10];

		tree[10] = ["You\nbrushed\nyour\nteeth?"];
		tree[11] = ["#RHYD06#Roar!? Well I always brush my teeth! I'm not a savage!!"];
		tree[12] = [100];

		tree[20] = ["You\npolished\nyour\nhorn?"];
		tree[21] = ["#RHYD06#Roar!? You mean like... playin the ol' skin whistle? ...I do that every day!!"];
		tree[22] = [100];

		tree[30] = ["You\nexfoliated\nyour\npores?"];
		tree[31] = ["#RHYD06#Roar!? No, this is just my natural Rhydon radiance today!"];
		tree[32] = [100];

		tree[40] = ["You look\nthe same"];
		tree[41] = ["#RHYD07#The... The same!?! ...Roarrr..."];
		tree[42] = [100];

		tree[60] = ["You\nbrushed\nyour\nteeth?"];
		tree[61] = ["#RHYD02#Well... kinda! I just finished a whitening treatment!"];
		tree[62] = ["#RHYD14#Don't they look all clean and white? Well I just think it's great!! Roar!"];
		tree[63] = [101];

		tree[70] = ["You\npolished\nyour\nhorn?"];
		tree[71] = ["#RHYD02#Yeah exactly! Doesn't it look extra shiny?"];
		tree[72] = [101];

		tree[80] = ["You\nexfoliated\nyour\npores?"];
		tree[81] = ["#RHYD02#Yeah, I just applied a new cleansing treatment to my T-zone!! Doesn't my complexion look especially Rhydonny today??"];
		tree[82] = [101];

		tree[100] = ["#RHYD10#Well I thought I did something but... now I can't remember...!"];
		tree[101] = ["#RHYD11#This is kinda weird... Uhhh..."];

		if (which == 0)
		{
			tree[4] = [40, 20, 30, 60];
			tree[100] = ["#RHYD02#No, I finished whitening my teeth!! Don't they look all clean and white?"];
			tree[101] = ["#RHYD04#...I thought the brightness of my teeth might inspire you to do an extra good job this time!!"];
			tree[102] = ["#RHYD03#My glorious smile... You're totally inspired by it! I'm beaming all of its brightness directly into your brain!! Roarrrr!!!"];
		}
		else if (which == 1)
		{
			tree[4] = [40, 70, 30, 10];
			tree[100] = ["#RHYD02#No, I just polished my horn!! Doesn't it look extra shiny?"];
			tree[101] = ["#RHYD04#...I thought the brightness of my perfectly gleaming horn might inspire you to do an extra good job this time!!"];
			tree[102] = ["#RHYD03#My shiny horn... You're totally inspired by it! I'm beaming all my horn energy directly into your brain!! Roarrrr!!!"];
		}
		else
		{
			tree[4] = [40, 20, 80, 10];
			tree[100] = ["#RHYD02#No, I just applied a new cleansing treatment for my pores! Doesn't my T-zone look all nice and moisturized??"];
			tree[101] = ["#RHYD04#...Proper hygiene goes hand in hand with good exercise and a healthy mind!! I thought it might inspire you to do an extra good job this time!!"];
			tree[102] = ["#RHYD03#My flawless skin... You're totally inspired by it! You're going to do a great job on this puzzle!! Roarrrr!!!"];
		}

		if (!PlayerData.rhydMale)
		{
			DialogTree.replace(tree, 21, "skin whistle", "silent trombone");
		}
		if (checksum % 7 <= 3)
		{
			tree[4].insert(2, 120);
			tree[120] = ["\"Better\nhalf?\""];
			tree[121] = ["#RHYD06#Roarr? What are you talking about??"];
			tree[122] = [100];
		}
	}

	public static function random10(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#RHYD06#Oh uh... Can you start this one without me? I forgot something!"];
		tree[1] = ["%fun-shortbreak%"];
		tree[2] = ["#RHYD04#I'll be right back!! Gr-roarrrr!"];
	}

	public static function random11(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("rhyd.randomChats.1.1");
		if (count % 3 == 0)
		{
			tree[0] = ["#RHYD04#Oof, my biceps are KILLING me after yesterday's workout!!"];
			tree[1] = [10, 20, 30];

			tree[10] = ["Probably from\ndumbbell curls"];
			tree[11] = ["#RHYD10#Yeah, Nidoking came up with this awful routine of back-to-back dumbbell curls, barbell curls and reverse grip cable curls. No breaks in between!!!"];
			tree[12] = ["#RHYD11#It's funny how getting so strong can make you feel so weak..."];
			tree[13] = ["#RHYD05#I could barely hold my dishes level carrying them to the sink this morning, my arms were shaking so much from muscle fatigue!"];
			tree[14] = ["#RHYD04#I bet your brain starts to feel a little fatigued too, doing so many puzzles back to back! I understand if you need a break too. Roar!"];

			tree[20] = ["Probably from\nthe bench press"];
			tree[21] = ["#RHYD06#Nah, the bench press uses different muscles! Mostly the triceps and pectoral muscles. Those can get sore too!!"];
			tree[22] = ["#RHYD10#And oof when those bigger muscle groups get sore it's soooo much worse! Roar!"];
			tree[23] = ["#RHYD05#My biceps are pretty fatigued but they'll recover in a day or two. I just gotta take a little break."];
			tree[24] = [14];

			tree[30] = ["Probably from\ntaking it up\nthe ass"];
			tree[31] = ["#RHYD05#Yeah, I mean sometimes when you--"];
			tree[32] = ["#RHYD13#Wait WHAT!?! I'll show you up the ass!! Roarr!! WRRROOOOARRRRRR!!!!"];
			tree[33] = ["#RHYD12#That doesn't even make sense!! How would you strain your biceps while taking it up the ass!?"];
			tree[34] = ["#RHYD06#Well maybe if you were like on your stomach, supporting your weight while you--"];
			tree[35] = ["#RHYD00#No, wait, you'd be on your back and... maybe holding some sort of rope, while someone stands in front of you and, hmm maybe if they use their arms to..."];
			tree[36] = ["%fun-longbreak%"];
			tree[37] = ["#RHYD05#Hey! I gotta go send a text. Go ahead and start without me."];
		}
		else if (count % 3 == 1)
		{
			tree[0] = ["#RHYD04#Oof, my quads are KILLING me after yesterday's workout!!"];
			tree[1] = [20, 10, 30];

			tree[10] = ["Probably from\nsquats"];
			tree[11] = ["#RHYD10#Bingo, Nidoking and I did this hellish set... A super set of weighted jump squats, followed by 150 kilogram squats until failure."];
			tree[12] = ["#RHYD02#So the super set sort of wears you down to start with, and then I don't know if you know what \"until failure\" means but it means I can't walk today...!! Greh! Heh!"];
			tree[13] = ["#RHYD05#It hurts like hell but that's how I know I'm getting stronger."];
			tree[14] = ["#RHYD03#I bet sometimes your head hurts doing these puzzles too! But that just means your brain's doin' its job. Don't give up! Roarrr!!"];

			tree[20] = ["Probably from\npull-ups"];
			tree[21] = ["#RHYD05#Nah, pull-ups don't use your quads! Your quadriceps are in your legs, not your arms!"];
			tree[22] = ["#RHYD06#What sort of crazy ass pull-ups are you doing!? Or wait, I know what it is, I bet you're just unfamiliar with gym rat lingo..."];
			tree[23] = ["#RHYD04#Quads! Traps! Delts! Hams! Pecs! It's all just burned into my brain so sometimes I forget it's kind of a second language of its own. Heh!"];
			tree[24] = ["#RHYD05#But yeah, my legs hurt like hell from all the squats I did yesterday. But that's how I know I'm getting stronger."];
			tree[25] = [14];

			tree[30] = ["Probably from\ntaking four\ncocks up\nthe ass"];
			tree[31] = ["#RHYD05#Nah not \"quads\" like four, it's just a muscle in your-"];
			tree[32] = ["#RHYD13#Wait four cocks!?! WHAT!! Roarrr! WRRRROOOOARRRRRRR!!!"];
			tree[33] = ["#RHYD12#And that's completely impossible anyways! Four cocks!? I mean just positionwise, how would you get four cocks that close together!?"];
			tree[34] = ["#RHYD06#I mean MAYBE if two guys were stomach to stomach, alright that's two, and then you'd fit two other guys next to 'em side by side..."];
			tree[35] = ["#RHYD00#But even if you got four guys situated right, it would have to be someone REALLY talented to even fit four cocks up there, hmm... Maybe Sandslash could do it..."];
			tree[36] = ["%fun-longbreak%"];
			tree[37] = ["#RHYD05#Hey! I left my phone in the other room, I'll be right back."];
		}
		else
		{
			tree[0] = ["#RHYD04#Oof, my butt is KILLING me after yesterday's workout!!"];
			tree[1] = [20, 10, 30, 40];

			tree[10] = ["Probably from\nsquats"];
			tree[11] = ["#RHYD06#Uhhh... Yeah! Roar!!! You may be onto something!"];
			tree[12] = ["#RHYD04#I think I probably did a few squats yesterday. And today my butt hurts! That must be it."];
			tree[13] = ["#RHYD00#Hmm I mean, I... I'd definitely remember if I did anything else involving my butt..."];
			tree[14] = ["#RHYD01#And I'd *definitely* remember doing it a second time in the shower later. Nope, nothing comes to mind. Greh! Heh-heh."];
			tree[15] = ["%fun-longbreak%"];
			tree[16] = ["#RHYD14#Hey!! Remembering all this stuff I didn't do yesterday is making it hard to concentrate! I'll be right back~"];

			tree[20] = ["Probably from\npush-ups"];
			tree[21] = ["#RHYD06#Uhhh... Yeah! Roar!!! You may be onto something!"];
			tree[22] = ["#RHYD04#I did a few pushups yesterday... And today my butt hurts! That must be why."];
			tree[23] = [13];

			tree[30] = ["Probably from\ntaking it\nup the ass\nagain"];
			tree[31] = ["#RHYD13#What?? Where did you hear that! Roarrr! Wrrrooooarrrrrr!!!"];
			tree[32] = ["#RHYD12#I don't remember why my butt hurts, but I definitely don't remember taking anything up the ass during my workout yesterday."];
			tree[33] = ["#RHYD13#And I also definitely don't remember taking it up the ass a second time in the shower afterwards. No way!! Grrroaarrrrr!!!"];
			tree[34] = ["#RHYD06#There must be some other reason why my butt hurts that I'm just not remembering right now."];
			tree[35] = ["#RHYD00#..."];
			tree[36] = ["%fun-longbreak%"];
			tree[37] = ["#RHYD12#Hey!! Remembering all this stuff I didn't do yesterday is making it hard to concentrate! I'll be right back!!"];

			tree[40] = ["Probably from\nsucking too\nmany dicks"];
			tree[41] = ["#RHYD05#Nah, you don't really use your glutes for--"];
			tree[42] = ["#RHYD13#Wait a minute, sucking dicks!?! WHAT!! Roarrr! WRRRROARRRRRR!!!"];
			tree[43] = ["#RHYD12#That's stupid! How would you possibly suck so many dicks that your ass hurt!? If anything, your mouth might hurt but... your ass!?!"];
			tree[44] = ["#RHYD06#I mean I guess maybe if you were squatting down while sucking a lot of dicks in a row, and if they made you like... stay in that position,"];
			tree[45] = ["#RHYD00#But I'm not sure how they'd force you to-- well like, maybe if there were some kind of harness, or hmm..."];
			tree[46] = ["#RHYD01#...if your legs were bound in a certain way... And maybe a blindfold, yeah..."];
			tree[47] = ["%fun-longbreak%"];
			tree[48] = ["#RHYD04#Hey!! I gotta go send a text real fast. Go ahead and start without me!"];
		}
	}

	public static function random12(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var checksum:Int = LevelIntroDialog.getChatChecksum(puzzleState);

		if (PlayerData.rhydonCameraUp)
		{
			tree[0] = ["%fun-nude0%"];
			tree[1] = ["#RHYD10#Geez, you finish these things so quick!!"];
			tree[2] = ["#RHYD11#You made me TOTALLY miss my cue for taking off my shirt!!! Errr one second..."];
			tree[3] = ["%fun-nude1%"];
			tree[4] = ["#RHYD02#There, that's better! Okay, I'll pay attention this time!!"];
			tree[5] = ["#RHYD03#I'm going to strip at just the right moment for you... Roarrr!! And maybe you'll slow down just a little!! Grr-rrroarrr!!!"];
			return;
		}

		tree[0] = ["#RHYD10#Hey!! Why are you always pointing this thing at my better half!?! Roarrr!!"];
		tree[1] = ["%fun-camera-slow%"];

		tree[2] = ["#RHYD12#It's getting hard not to take it personally!"];
		tree[3] = [30, 20, 10, 40];

		tree[10] = ["Oh it's\ngetting\nhard\nalright"];
		tree[11] = ["#RHYD10#Well, err... Still!!! ...It's rude!!"];

		tree[20] = ["Take it as a\ncompliment"];
		tree[21] = ["#RHYD10#A compliment!? Well, err... Still!!!"];
		tree[22] = ["#RHYD12#...It's still rude!!"];

		tree[30] = ["Sorry about\nthat"];
		tree[31] = ["#RHYD05#Aww well, I know you didn't mean it."];
		tree[32] = ["#RHYD02#...My face forgives you! Roarr!!"];

		tree[40] = ["Why do you\ncare so\nmuch?"];
		tree[41] = ["#RHYD06#Well, err... It just seems rude!!"];
		tree[42] = ["#RHYD03#Can't you look a guy in the face while you're undressing him? Roarrr!!"];

		if (checksum % 11 <= 1)
		{
			tree[40] = ["\"Better\nhalf?\""];
		}
		else if (checksum % 11 <= 3)
		{
			tree[30] = ["\"Better\nhalf?\""];
		}

		if (!PlayerData.rhydMale)
		{
			DialogTree.replace(tree, 42, "a guy", "a girl");
			DialogTree.replace(tree, 42, "undressing him", "undressing her");
		}
	}

	public static function random13(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("rhyd.randomChats.1.3");
		if (count % 3 == 1)
		{
			tree[0] = ["#RHYD05#Hey <name>! Roar! ...Have you seen any of those puzzle keys that Heracross sells?"];
			tree[1] = [30, 40, 20, 10];

			tree[10] = ["No, I\nhaven't"];
			tree[11] = [41];

			tree[20] = ["Yeah, but\nI haven't\nbought any"];
			tree[21] = ["#RHYD06#Oh you haven't? Well anyway, Heracross told me they unlock like, the hardest, most challenging puzzles... So I tried one out..."];
			tree[22] = [50];

			tree[30] = ["Yeah, I\nbought some"];
			tree[31] = ["#RHYD06#Yeah, I tried some of those keys out myself! Heracross told me they were like, for the ultimate puzzle challenge..."];
			tree[32] = [50];

			tree[40] = ["Wait,\nwhat?"];
			tree[41] = ["#RHYD06#Oh huh you haven't heard of those? Well from what Heracross told me, they unlock like... the hardest, most challenging puzzles..."];
			tree[42] = ["#RHYD05#So I tried one out the other day and... WOW, he wasn't kidding around!"];
			tree[43] = ["#RHYD10#First silver puzzle I tried, I got TOTALLY stuck!!! ...Abra finally bailed me out, giving me a few hints..."];
			tree[44] = [51];

			tree[50] = ["#RHYD10#And wow, he wasn't kidding around! First silver puzzle I tried, I got SO stuck. Abra finally bailed me out, giving me a few hints..."];
			tree[51] = ["#RHYD12#So I got through it... KINDA... But as if it wasn't humiliating enough having to ask for help, it didn't even give me a silver chest!!"];
			tree[52] = ["#RHYD06#Anyway I think you end up payin' for hints one way or another, if you catch my drift."];
			tree[53] = ["#RHYD02#I guess it's best if you can make it through without help."];
			tree[54] = ["#RHYD03#Just giving you a heads up. Let's get to work!"];

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 42, "he wasn't", "she wasn't");
				DialogTree.replace(tree, 50, "he wasn't", "she wasn't");
			}
		}
		else
		{
			tree[0] = ["#RHYD02#Awww yeah! Lettin' those pecs out to breathe."];
			tree[1] = ["#RHYD03#I haven't been workin' on you babies for nothing!!! GROAR!"];
		}
	}

	public static function random20(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#RHYD03#Third puzzle! Yeah!! Nothing gets in your way!!! You're an unstoppable puzzle machine! Grr-roarrrrr!!"];
		tree[1] = ["#RHYD06#Of course if you DO run into a puzzle you can't handle, there's no shame in asking your buddy Rhydon for a little help."];
		tree[2] = ["#RHYD02#Think of me as like... your puzzle spotter! Someone who can carry the weight if it gets too heavy for you!"];
		tree[3] = ["#RHYD03#Now I want to see you push yourself to your maximum puzzle capacity!! Gimme all you got!!! Wrroarrrr!!!"];
	}

	public static function random21(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#RHYD03#Third puzzle! Yeah!! Nothing gets in your way!!! You're an unstoppable-"];
		// guarantee camera moves down
		if (PlayerData.rhydonCameraUp)
		{
			tree[1] = ["%fun-camera-med%"];
		}
		else
		{
			tree[1] = ["%fun-noop%"];
		}
		tree[2] = ["%entersand%"];
		tree[3] = ["#sand01#Hey, what's up, Rhydon's crotch! What's groin on with you?"];
		tree[4] = ["%fun-camera-med%"]; // camera moves up
		tree[5] = ["#RHYD12#Hey!! Cut that out! If you have questions for my crotch, they go through ME first!!"];

		tree[6] = ["%fun-camera-med%"]; // camera moves down
		tree[7] = ["#sand14#But I have some important questions only your crotch can pants-wer. Aww, your nose is running, lemme get that--"];

		tree[8] = ["%fun-camera-med%"]; // camera moves up
		tree[9] = ["#RHYD13#Get your hands away from there! And quit messing with my camera!!"];
		tree[10] = ["#sand03#Ayy I'm just givin' the people what they want! No one gives a shit about your face, all the good stuff's on the bottom."];
		tree[11] = ["#RHYD12#You're crazy! My iconic Rhydon personality is what makes my crotch special! And my personality comes from my face!! ...What do you think <name>?"];
		tree[12] = [80, 20, 60, 40];

		tree[20] = ["The face\nis more\nimportant"];
		tree[21] = ["#RHYD14#There see? My face is the source of my unique Rhydon personality!! If you can't see my face, you-"];
		tree[22] = ["%fun-camera-med%"]; // camera moves down
		tree[23] = ["#sand01#Tsk I think your crotch has plenty of personality. Look I bet I can make it blush..."];
		tree[24] = ["%fun-camera-med%"]; // camera moves up
		tree[25] = ["#RHYD13#Get... get out of here you crazy perv!!"];
		tree[26] = ["%exitsand%"];
		tree[27] = ["#sand03#Ayyy you know you love me~"];
		tree[28] = ["#RHYD12#Well that was fuckin' WEIRD. That guy's ten pounds of horny in a five pound bag."];
		tree[29] = ["#RHYD04#Anyway, one more puzzle right?"];

		tree[40] = ["The crotch\nis more\nimportant"];
		tree[41] = ["#RHYD13#WHAT!? The crotch is NOT more important!! WROARRRRRRR!"];
		tree[42] = ["#sand15#Aw c'mon, all the best stuff is down there."];
		tree[43] = ["%fun-camera-med%"]; // camera moves down
		tree[44] = ["#sand01#See you got the ol' fruit bowl up front, and that thick juicy taint behind it which leads alllllllll the way back to my personal favorite-"];
		tree[45] = ["#RHYD13#HEY!!! Stop pointing! Get your fingers away from there!! Learn some boundaries!!!"];
		tree[46] = ["%exitsand%"];
		tree[47] = ["#sand03#Ayyy you know you love me~"];
		tree[48] = ["%fun-camera-med%"]; // camera moves up
		tree[49] = [28];

		tree[60] = ["They're both\nequally\nimportant"];
		tree[61] = ["#RHYD04#Yeah, groar! ...That's why the webcam's adjustable. Without my face or crotch, it would only be like, half a game!!"];
		tree[62] = ["#sand06#Tsk yeah but nobody would play if your gargantuan cock wasn't a part of it. Your face is just dressing. Your crotch is the, uhh, salad."];
		tree[63] = ["#sand03#Heh, heh-heh-heh, wait a minute. Point the camera at your dick again, I got another question I wanna ask."];
		tree[64] = ["#RHYD13#NO MORE QUESTIONS!! This press conference is OVER!!!"];
		tree[65] = ["%exitsand%"];
		tree[66] = ["#sand12#Awwww I never get all my questions in."];
		tree[67] = [28];

		tree[80] = ["I also have\nsome questions\nfor your\ncrotch"];
		tree[81] = ["#RHYD10#What!!!"];
		tree[82] = ["#sand03#Heh! Heh heh heh. See, he gets it."];
		tree[83] = ["%fun-camera-med%"];
		tree[84] = ["#RHYD12#FINE, you can ask... ONE question."];

		var choices:Array<Object> = [130, 100, 110, 120, 140];
		var checksum:Int = LevelIntroDialog.getChatChecksum(puzzleState);
		choices.splice(checksum % 4, 1);
		choices.splice(checksum % 3, 1);
		tree[85] = choices;

		tree[100] = ["So why the\nlong face?"];
		tree[101] = [150];

		tree[110] = ["Can I feed\nyou a\npeanut?"];
		tree[111] = [150];

		tree[120] = ["Weiner we\ngoing to\nstart this\nlast puzzle?"];
		tree[121] = [150];

		tree[130] = ["Isn't it\nwarm to be\nwearing a\nturtleneck?"];
		tree[131] = [150];

		tree[140] = ["Nevermind I\nwas just\ndicking\naround"];
		tree[141] = [150];

		if (!PlayerData.rhydMale)
		{
			tree[100] = ["Did you lose\na fight? It\nlooks like\nyour one\neye is\ngrotesquely\nswollen\nshut"];
			tree[110] = ["If I yell\nat you\nwill it\nmake an\necho?"];
			tree[120] = ["Can I feed\nyou a\nsausage?"];
			tree[130] = ["Do you do\nmonologues?"];
			tree[140] = ["Nevermind\nI cunt think\nof any"];
		}

		tree[150] = ["#RHYD02#...Greh!! Heh heh heh heh!"];
		tree[151] = ["#sand03#Heh! Heh-heh. See, it's funnier when he does it."];
		tree[152] = ["%fun-camera-med%"];
		tree[153] = ["#RHYD03#Heh heh-- Hey!! No more questions! I'll put you in for a private interview after this next puzzle."];
		tree[154] = ["#sand06#Aww you mean..."];
		tree[155] = ["%exitsand%"];
		tree[156] = ["#sand12#Tsk alright I can take a hint."];

		if (!PlayerData.rhydMale)
		{
			DialogTree.replace(tree, 7, "pants-wer", "a-dress");
			DialogTree.replace(tree, 44, "fruit bowl", "meat muffin");
			DialogTree.replace(tree, 62, "gargantuan cock", "cavernous cunt");
			DialogTree.replace(tree, 63, "at your dick", "at your pussy");
			DialogTree.replace(tree, 64, "NO MORE", "CAVERNOUS CUNT!?! NO MORE");
		}
		if (!PlayerData.sandMale)
		{
			DialogTree.replace(tree, 28, "That guy's", "That girl's");
		}
		if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			DialogTree.replace(tree, 82, "he gets", "she gets");
			DialogTree.replace(tree, 151, "when he", "when she");
		}
		else if (PlayerData.gender == PlayerData.Gender.Complicated)
		{
			DialogTree.replace(tree, 82, "he gets", "they get");
			DialogTree.replace(tree, 82, "when he does", "when they do");
		}
	}

	public static function random22(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("rhyd.randomChats.2.2");
		tree[0] = ["%fun-nude1%"];
		// guarantee camera moves down
		if (PlayerData.rhydonCameraUp)
		{
			tree[2] = ["%fun-camera-slow%"];
		}
		else
		{
			tree[2] = ["%fun-noop%"];
		}
		if (count % 3 == 0)
		{
			tree[1] = ["#RHYD14#Heyyy look at that! I think somebody wants to say hello~"];
			tree[3] = ["#rhyd16#Noooooo, I'm too sleepy! Five more minutes!!"];
			tree[4] = [55, 70, 20, 30];
		}
		else if (count % 3 == 1)
		{
			tree[1] = ["#RHYD14#Awww look at that! I think someone slept in again..."];
			tree[3] = ["#rhyd16#Noooooo! It's too eaaaaarrrrrly"];
			tree[4] = [60, 75, 10, 35];
		}
		else
		{
			tree[1] = ["#RHYD14#Uh oh! I feel something stirring again... Are you awake down there?"];
			tree[3] = ["#rhyd16#Noooooo! I was just having the nicest dream..."];
			tree[4] = [50, 80, 15, 40];
		}

		tree[10] = ["I'll be\ngentle"];
		tree[11] = [100];

		tree[15] = ["Don't be\nafraid"];
		tree[16] = [100];

		tree[20] = ["But your\nfriend is\nhere"];
		tree[21] = [100];

		tree[30] = ["C'mon, time\nto wake up"];
		tree[31] = [100];

		tree[35] = ["Wakey wakey\nlittle guy"];
		tree[36] = [100];

		tree[40] = ["You gotta\nwake up\nsome time"];
		tree[41] = [100];

		tree[50] = ["Fuck yeah,\ntake it off"];
		tree[51] = [100];

		tree[55] = ["Aww yeah,\ntime for the\ngood stuff"];
		tree[56] = [100];

		tree[60] = ["Heck yeah,\nabout time"];
		tree[61] = [100];

		tree[70] = ["What the\nheck!?"];
		tree[71] = [100];

		tree[75] = ["Wait... this\nagain!?"];
		tree[76] = [100];

		tree[80] = ["Ugh...\nseriously!?"];
		tree[81] = [100];

		tree[100] = ["#rhyd17#Oh, alright..."];
		tree[101] = ["%fun-nude2%"];
		tree[102] = ["#rhyd18#*Yawwwwwwn* Up and at 'em! Cock of the morning to you!"];
		tree[103] = ["#rhyd19#Roar! I overslept! I must not have heard my alarm cock."];
		tree[104] = ["%fun-camera-med%"];
		tree[105] = ["#RHYD04#Okay, well why don't you take care of your morning stuff while we knock out this puzzle here."];
		tree[106] = ["%fun-camera-med%"];
		tree[107] = ["#rhyd16#...sleepy..."];
		tree[108] = ["%fun-camera-med%"];
		tree[109] = ["#RHYD00#Don't worry <name>, we've got awhile... That guy takes really long showers. Greh-Heh heh heh!"];
		if (!PlayerData.rhydMale)
		{
			tree[102] = ["#rhyd16#*Yawwwwwwn* Up and at 'em! I have a very pussy schedule today."];
			tree[103] = ["#rhyd17#Roar! I overslept! I must have puss-ed the snooze button too many times."];
			DialogTree.replace(tree, 35, "little guy", "little one");
			DialogTree.replace(tree, 109, "That guy takes", "That girl takes");
		}

		tree[10000] = ["%fun-nude2%"];
	}

	public static function random23(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("rhyd.randomChats.2.3");

		LucarioResource.setHat(true);
		if (PlayerData.rhydGift == 1)
		{
			// receiving gift; having a pizza order wouldn't make sense here
			tree[0] = ["#luca06#Ehhh so Rhydon, you have a little marinara sauce on your ummmm... left... ear thing? Sort of by your cheek..."];
			tree[1] = ["#RHYD05#Where, you mean here?"];
			tree[2] = ["#luca07#Well, you got some of it... And kyehhhh... there's also some on the other side... Sort of next to your ummm..."];
			tree[3] = ["#RHYD02#Over here? Ohhhhh, there it is!"];
			tree[4] = ["#luca08#And there's a liiiiiittle more, dripping down your upper ehhhhh... chest thing."];
			tree[5] = ["#RHYD06#Groarrr? Well... I was trying to eat extra fast so I wouldn't keep <name> waiting... ..."];
			tree[6] = ["%fun-mediumbreak%"];
			tree[7] = ["#RHYD10#I'll be back in a second! I'm gonna go get cleaned up."];

			tree[10000] = ["%fun-mediumbreak%"];
		}
		else if (count % 3 == 1)
		{
			tree[0] = ["%fun-alpha0%"];
			tree[1] = ["#luca06#Hey so uhhhhh... -huff- -huff- Where did you want this pile of pizzas? Should I just drop them in the kitchen? Or..."];
			tree[2] = ["%fun-alpha1%"];
			tree[3] = ["#RHYD04#Ehhh yeah, sure! Actually no wait, bring them in here! I'm kind of in the middle of something and it'll save me a trip."];
			tree[4] = ["#RHYD06#Orrrr actually, errrr...."];
			tree[5] = ["#RHYD05#Maybe if you could just like, roll the slices up one-at-a-time and errrrrr... slide them into my mouth? ...That way I can keep playing!"];
			tree[6] = ["#luca12#Kyahhhhhhhh... No. No, Rhydon."];
			tree[7] = ["#RHYD14#C'monnnnnnnn, I'll tip extra! ...Pleeeeeease?"];
			tree[8] = ["#luca09#Look, I appreciate all the tips you've given me but there is simply no way I am going to stand here..."];
			tree[9] = ["#luca14#... ...Stuffing pizza down your gullet while you... masturbate and play puzzle games."];
			tree[10] = ["%fun-alpha0%"];
			tree[11] = ["#RHYD10#Grehh!?! No, I wasn't... Hey come back! I wasn't masturbating, I just had an itch on my thigh! Waaaaaaaait!"];
			tree[12] = ["#RHYD12#Fine, whatever, I'll just... feed myself. Like a neanderthal! Grr-roarrr! ... ...So much for hospitality."];
			tree[13] = ["%fun-longbreak%"];

			tree[10000] = ["%fun-longbreak%"];
		}
		else
		{
			tree[0] = ["%fun-alpha0%"];
			tree[1] = ["#luca06#Hey so uhhhhh... -huff- -huff- Where did you want this pile of pizzas? Should I just drop them in the kitchen? Or..."];
			tree[2] = ["%fun-alpha1%"];
			tree[3] = ["#RHYD04#Ehhh yeah! Just put 'em anywhere. Thanks!"];
			tree[4] = ["#RHYD02#Okay, <name> -- the longer you spend on this puzzle, the colder my pizza gets. So let's keep things moving! Greh! Heh-heh!"];
		}
	}

	public static function denDialog(sexyState:RhydonSexyState = null, playerVictory:Bool = false):DenDialog
	{
		var denDialog:DenDialog = new DenDialog();

		denDialog.setGameGreeting([
			"#RHYD06#Whoa, <name>!! I thought this area was supposed to be kinda off limits or something... You're not gonna get in trouble, are you?",
			"#RHYD02#Hey don't worry, I won't tell! Groarr! There's a lot of fun stuff back here.",
			"#RHYD04#I got some free weights and kettle bells if you want some exercise. And oh yeah! <Minigame> is already set up if you feel like doin' that.",
		]);

		denDialog.setSexGreeting([
			"#RHYD05#Yeah okay, you remember how this part goes don't you? Just remember to get my entire body alright?",
			"#RHYD12#Abra really needs to get you some bigger equipment though! 'Cause this is kinda like mowing a 30-acre farm with a tiny push mower.",
			"#RHYD06#...I mean bigger jobs warrant bigger tools, right!? That's just common sense! Groar!",
		]);

		denDialog.addRepeatSexGreeting([
			"#RHYD03#You're no match for my Rhydon stamina! Groaarrrrr!! Your little clicky finger's gonna be worn down to a hideous nub by the time you're done with me.",
			"#RHYD02#Although y'know, speaking of hideous nubs... ... ... I got a hideous nub that could use some attention, if you know what I mean! Greh-heh-heh!!",
			"#RHYD06#...",
			"#RHYD00#It's... It's my " + (PlayerData.rhydMale?"penis":"clitoris") + "! You got that, right? Yeah! ...Groar~"
		]);
		denDialog.addRepeatSexGreeting([
			"#RHYD00#Wow, you're really not messing around today! ...No breaks huh? Alright, we go...",
		]);
		denDialog.addRepeatSexGreeting([
			"#RHYD03#Let's go! Right now, Gr-roarrr!! ...No breaks!!! We gotta keep that " + (PlayerData.rhydMale ? "testosterone" : "breastosterone") + " flowing!",
		]);
		denDialog.addRepeatSexGreeting([
			"#RHYD05#Whoa! You're not even a little bit tired? You'd make a pretty good workout buddy, <name>!",
			"#RHYD06#I mean like... if you actually had a body and stuff! ... ...Don't think they'll let you in the gym without a body...",
		]);
		{
			var sexyOutOfLo:String = englishNumber(PlayerData.denSexCount);
			var sexyOutOfHi:String = englishNumber(Std.int(Math.min(3, PlayerData.denSexCount * 2 - 1)));
			if (PlayerData.rhydMale)
			{
				denDialog.addRepeatSexGreeting([
					"#RHYD05#Alright, so if we're sticking to my usual Rhydon regimen, that was part " + sexyOutOfLo + " of our " + sexyOutOfHi + "-part workout. Here's where it gets kinda tricky!",
					"#RHYD04#The next exercise is uhh, one cock push-up. ... ...A cock push-up is where you lift your entire body weight off the floor with only your cock muscles!",
					"#RHYD10#... ...Trust me, one is a lot!!",
				]);
			}
			else {
				denDialog.addRepeatSexGreeting([
					"#RHYD05#Alright, so if we're sticking to my usual Rhydon regimen, that was part " + sexyOutOfLo + " of our " + sexyOutOfHi + "-part workout. Here's where it gets kinda tricky!",
					"#RHYD04#The next exercise is uhh, one puss-up. ... ...A puss-up is where you lift your entire body weight off the floor with only your pussy muscles!",
					"#RHYD10#... ...Trust me, one is a lot!!",
				]);
			}
		}
		if (PlayerData.denSexCount <= 3)
		{
			denDialog.addRepeatSexGreeting([
				"#RHYD00#Alright, c'mon let's go! I haven't even broke a sweat yet!",
				"#RHYD01#I mean yeah, okay... I'm sweating a little! But I mean I haven't broken a REAL sweat! ...Like, a Rhydon sweat! Groarrr~",
			]);
		}
		else {
			denDialog.addRepeatSexGreeting([
				"#RHYD01#Greh! That last one was... pretty intense...",
				"#RHYD00#Is it time for the cooldown part of our workout yet? I'm starting to feel that lactic acid in my " + (PlayerData.rhydMale ? "cock" : "pussy") + " muscles...",
			]);
		}

		denDialog.setTooManyGames([
			"#RHYD02#Thanks, this was fun! But I think I'm gonna go for a little run though, you know, get my blood moving a little.",
			"#RHYD03#What, you thought I got this big sitting on my ass pushing plates all day? G-r-oarrrrrr! It's all about that cardio! ...There's no muscle more important than your heart!",
			"#RHYD06#...You should try to shake those legs out once in awhile too, <name>! Deep vein thrombosis, it's a real thing! Groar! Anyway take it easy~",
		]);

		denDialog.setTooMuchSex([
			"#RHYD07#Gr-groarrr... You win this round, <name>... Wroaarrrrr....",
			"#RHYD09#All the muscles in the world can't... Grah... Keep up with those little clicky fingers of yours... Dub... Double-gro-a-r-r...",
			"%fun-alpha0%",
			"#RHYD07#Don't mind me, I just gotta... lay down for a sec...",
			"#RHYD04#Hey but this was... Don't worry alright? ...All my best workouts end with me vocalizing my pain while laying naked on a couch...",
			"#RHYD00#...This was good. ... ...You did good today. Thanks, <name>. Groar~",
		]);

		var bestLo:String = englishNumber(PlayerData.denGameCount + 1);
		var bestHi:String = englishNumber(PlayerData.denGameCount * 2 + 1);
		denDialog.addReplayMinigame([
			"#RHYD02#Hey that was great! I can really feel it burning in my greh.... my neuro, frontal... medulus! Yeah! Greh-heheheh~",
			"#RHYD04#Did you wanna go again? Or did you wanna try something a little more... y'know... physical!",
		],[
			"Let's go\nagain",
			"#RHYD05#Yeah okay! Gr-roar! Best " + bestLo + " out of " + bestHi + "!",
		],[
			"I could go\nfor something\nphysical",
			"#RHYD03#Now you're talkin'! Greh-heheheh! You might beat me at these rinkydink minigames, but you'll never beat me at somethin' physical!",
			"#RHYD00#Now... " + (PlayerData.rhydMale ? "Beating me off's" : "Pounding me's") + " another story! ...I mean there better be " + (PlayerData.rhydMale ? "some of that" : "some good pounding") +"...",
		],[
			"Actually\nI think I\nshould go",
			"#RHYD05#Yeahhhh okay. I'll see you around <name>! Good hangin' out. Groar!",
		]);
		denDialog.addReplayMinigame([
			"#RHYD06#What am I supposed to do with all these gems anyways? All Heracross sells are little... calculators and pervert shit that's way too small to use.",
			"#RHYD04#Anyway, you up for another one? Or didja wanna try something a little more, err, hands-on?",
		],[
			"I'm up for\nanother",
			"#RHYD02#Ahh yeah, okay! I'll get it set up then.",
		],[
			"Hands on?",
			"#RHYD02#...What, you gonna make me spell it out for you?",
		],[
			"I think I'll\ncall it a day",
			"#RHYD05#Yeahhhh okay. I'll see you around <name>! Good hangin' out. Groar!",
		]);
		denDialog.addReplayMinigame([
			"#RHYD04#Good game, now hit the showers! ...Groar!",
		],[
			"...I thought\nwe were gonna\nplay again!",
			"#RHYD06#Grehhh... Yeah! Yeah, of course! ...That's what I meant to say."
		],[
			"Oh! But we're\nnot dirty?",
			"#RHYD02#Greh-heheheh! Amateur mistake. You go to the showers to get dirty! ...It's like you've never been to a gym before...",
		],[
			"Hmm, I\nshould go",
			"#RHYD06#Gr-roarr? You're leavin' without your shower? ...If you say so...",
		]);

		denDialog.addReplaySex([
			"#RHYD00#Pheww... Yeahhhh... You doin' okay? I think I'll go grab some water.",
			"#RHYD06#You need anything while I'm up? Err, bandages? Splints? ...Solder?",
		],[
			"I'm good!",
			"#RHYD02#Alright, just hang out for a sec! I'll be right back.",
		],[
			"I should\ngo...",
			"#RHYD05#Aww okay, well it was nice hangin' out, <name>! ...Hey!! Don't be a stranger~",
		]);
		denDialog.addReplaySex([
			"#RHYD00#Grehhh... Alright... Well I'm gonna go wash all this stink off.",
			"#RHYD06#Actually, grehh... Whatever! You can't smell it can you? I'm just gonna grab a few napkins...",
		],[
			"Okay! I'll\nwait here",
			"#RHYD02#Don't worry, I'll be quick~",
		],[
			"And on that\nnote, I'm out",
			"#RHYD10#Hey wait, what? I was gonna moisten 'em a little! ...Hey, come back!",
		]);
		denDialog.addReplaySex([
			"#RHYD00#Grah... Wow, that was... Y'know, if I close my eyes it's kinda like... like I can imagine your entire right half is here with me, <name>. Groar~",
			"#RHYD04#Anyway I'm gonna grab some turkey slices out of the fridge! I'll be back in a jiff.",
		],[
			"Alright!\nI'll be here",
			"#RHYD02#Greh-heh, don't worry, I know! That's why I didn't ask~",
		],[
			"I should\ngo...",
			"#RHYD05#Aww okay, well it was nice hangin' out, <name>! ...Hey!! Don't be a stranger~",
		]);

		return denDialog;
	}

	static public function snarkyVibe(tree:Array<Array<Object>>)
	{
		tree[0] = ["#RHYD02#Greh! Heh-heh-heheh! That's a good one, <name>. ...What, did you craigslist this thing off a mosquito?"];
		if (PlayerData.rhydMale)
		{
			tree[1] = ["#RHYD10#...What? ...Oh, you were serious!? ... ...Uhh, I'm no penis-ologist, but I'm pretty sure cutting off the circulation to that area is a bad thing."];
		}
		else
		{
			tree[1] = ["#RHYD10#...What? ...Oh, you were serious!? ... ...Uhh, I don't have a PHD in pussy physics or anything, but I'm pretty sure that's gonna fall right out."];
		}
		tree[2] = ["#RHYD02#Besides look at it, it's so cute! It belongs in some kind of tiny vibrator museum~"];
	}

	public static function cursorSmell(tree:Array<Array<Object>>, sexyState:RhydonSexyState)
	{
		var count:Int = PlayerData.recentChatCount("rhyd.cursorSmell");

		if (count == 0)
		{
			if (PlayerData.playerIsInDen)
			{
				tree[0] = ["#RHYD05#Yeah okay, you remember how this part goes don't you? (sniff) Just remember to ehh, get my entire body alright? (sniff, sniff)"];
			}
			else
			{
				tree[0] = ["#RHYD05#Phew! That was a good set of mental exercises. (sniff) One last ehh, set left. (sniff, sniff)"];
			}
			tree[1] = ["#RHYD06#Geez <name>, you been eating okay? Smells kinda like, uhh..."];
			tree[2] = ["#RHYD10#...It kinda smells like that health shake I made, the time I accidentally put in onion powder instead of whey protein?? Oh man..."];
			tree[3] = ["#RHYD04#Whatever, it's not a big deal! ...You just smell how you smell. That's what I'm always telling people anyway! Grarr!"];
		}
		else
		{
			if (PlayerData.playerIsInDen)
			{
				tree[0] = ["#RHYD05#Yeah okay, you remember how this part goes don't you? (sniff) Just remember to ehh, get my entire body alright? (sniff, sniff)"];
			}
			else
			{
				tree[0] = ["#RHYD05#Phew! That was a good set of mental exercises. (sniff) One last ehh, set left. (sniff, sniff)"];
			}
			tree[1] = ["#RHYD02#Phooph! ...Puttin' in some extra hours at the butt factory today, eh <name>? Greh! Heh! Heh!"];
			tree[2] = ["#RHYD03#Whatever, let's do this!! Time to work that stink off! Gra-a-a-arrrr!!"];
		}
	}
}
