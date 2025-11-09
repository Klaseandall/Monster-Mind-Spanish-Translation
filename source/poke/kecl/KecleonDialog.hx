package poke.kecl;

import MmStringTools.*;
import critter.Critter;
import minigame.tug.TugGameState;
import openfl.utils.Object;
import minigame.GameDialog;
import minigame.MinigameState;
import minigame.scale.ScaleGameState;
import poke.smea.SmeargleDialog;
import minigame.stair.StairGameState;
import ItemDatabase.MysteryBoxShopItem;

/**
 * Kecleon's inner voice is Gazlowe.
 * OK at puzzles (rank 20)
 * vocal tics: kecl! keck! kekekeke
 *
 * Terms of endearment: cuddlepuppy ..."painty-poo" "smoochy-pumpkin" "shmoopsy-pie" "flimpsy-doodle"
 */
class KecleonDialog
{
	public static function gameDialog(gameStateClass:Class<MinigameState>):GameDialog
	{
		var manColor:String = Critter.CRITTER_COLORS[0].english;
		var comColor:String = Critter.CRITTER_COLORS[1].english;

		var g:GameDialog = new GameDialog(gameStateClass);

		g.addSkipMinigame(["#kecl08#Ehh?? Aww c'mon, you never let me do any fun stuff with you.", "#kecl09#...The one time I get to host a minigame and <name> doesn't even wanna play with me..."]);
		g.addSkipMinigame(["#kecl08#Aww really? ...I guess I shoulda got one of the other " + (PlayerData.smeaMale ? "guys" : "girls") + " instead. I don't know why I thought I could handle this stuff on my own.", "#kecl09#I guess I was just thinkin' y'know like... Maybe you and me got to know each other a little better... Awww forget it."]);

		g.addRemoteExplanationHandoff("#kecl04#Y'know what, lemme grab <leader> real quick. Someone's gotta explain this and I don't do talkin' good like <leaderhe> does.");

		g.addLocalExplanationHandoff("#kecl04#Hmm, think you can you explain this one <leader>? I don't do talkin' good like you.");

		g.addPostTutorialGameStart("#kecl05#I, err... uhh... Clear as mud, right? Should we just try it out?");

		g.addIllSitOut("#kecl00#Ehh why don't you kids play without me. I kinda got cold feet. Plus i'm TOTALLY AWESOME AT THIS.");

		g.addFineIllPlay("#kecl03#Keck-kekekeke. Yeah okay whatever, as long as you don't mind havin' your ass handed to you.");

		g.addGameAnnouncement("#kecl06#Oh yeah, this one's uhhh... <minigame>. I think I remember how this one goes.");

		g.addGameStartQuery("#kecl04#You ready to start? Or ehh...");

		g.addRoundStart("#kecl04#Ayy you ready to start this thing or what?", ["Hmm, I\nguess", "Yep, let's\ngo!", "Ready as I'll\never be..."]);
		g.addRoundStart("#kecl05#Alright, round <round>! Here we go!", ["Gwooph...", "You guys\nare good...", "I'm gonna\nstomp you!"]);
		g.addRoundStart("#kecl04#Round <round>, let's do this thing!", ["Can't we take\na break?", "Uhh,\nokay", "Yeah, let's\ndo this!"]);
		g.addRoundStart("#kecl05#Brace yourself, we're about to start round <round>!", ["Okay, I'm...\nbraced?", "Go for\nit", "Ready when\nyou are"]);

		g.addRoundWin("#kecl00#Keck-kekekeke! Piece of cake.", ["I'll get\nyou yet...", "Hmmm, let's\ntry again...", "You're too\nfast!"]);
		if (gameStateClass == ScaleGameState) g.addRoundWin("#kecl03#Ayyyy there we go! I knew it was something simple.", ["Hmm, I\nsee...", "Let's go\nagain!", "Wait, can we go through\nthat tutorial again!?"]);
		if (gameStateClass == TugGameState) g.addRoundWin("#kecl03#Ayyyy there we go! That wasn't so bad.", ["Hmm, I\nsee...", "Let's go\nagain!", "Wait, can we go through\nthat tutorial again!?"]);
		if (gameStateClass == ScaleGameState) g.addRoundWin("#kecl02#Ehh, I probably shoulda finished one faster! That seemed pretty easy.", ["Uhh...\nHmmm...", "Yeah, why did that\ntake me so long?", "Hey, that one\nwas tricky"]);
		if (gameStateClass == TugGameState) g.addRoundWin("#kecl06#Ehh wait, did I do that right? I didn't cheat or nothin'? ...That seemed pretty easy...", ["Uhh...\nHmmm...", "Yeah, why did I\nlet you do that?", "Hey, that\nwas tricky"]);
		if (gameStateClass == ScaleGameState) g.addRoundWin("#kecl06#Where'd uhh... Where d'ya think Abra got all these weird medical scales? I hope he didn't end up on some sorta list...", ["You know,\nactually...", "Uhh?", "What sort of list? This\nsubtext is lost on me"]);

		if (gameStateClass == ScaleGameState) g.addRoundLose("#kecl12#Gah! I'd be better at this if those danged numbers didn't have to match.", ["That's sort of\nthe point", "It's tough\nisn't it", "You're doing\nfine"]);
		if (gameStateClass == ScaleGameState) g.addRoundLose("#kecl13#Ay, c'mon <leader>! Give the rest of us a chance.", ["Yeah, give us\na chance|You just gotta\nbe faster", "We'll get <leaderhim>|Maybe next\nround", "It's kind of\nunfair, huh?|Aww hey you're\nstill in this"]);
		if (gameStateClass == ScaleGameState) g.addRoundLose("#kecl12#C'moonnn, what the heck was that!? I hadn't even looked at the numbers yet!", ["Kind of\nridiculous|I'm just\nthat good", "We can\ndo it|Sorry, I'll\ngo slower", "I'm not playing with\n<leaderhim> next time|It's just\naddition..."]);
		if (gameStateClass == TugGameState) g.addRoundLose("#kecl12#C'moonnn, what the heck was that!? It ain't fair when ya move everything around so fast!", ["That was\nfast to you?", "Sorry, I'll\ngo slower", "It's a legitimate\nstrategy..."]);
		if (gameStateClass == ScaleGameState) g.addRoundLose("#kecl13#Ayy that's bullshit, one of my bugs was fatter than all the others!!", ["Ohhh, bad\nluck...", "That doesn't\nsound right...", "Really? You got\na fat one?"]);
		g.addRoundLose("#kecl07#Yeesh <leader> how'd you get so good at this!?", ["<leaderHe's>\nunbeatable!|It seems\nkinda easy...", "We need to find\n<leaderhis> weakness|I've played stuff\nlike this before", "Maybe if we\ntie <leaderhim> up...|You're cute when\nyou're upset~"]);
		g.addRoundLose("#kecl12#Eeghhh whatever, <leader>. This game is dumb, and you're dumb for bein' good at it.", ["Jealous\nmuch?", "We're only a few\nseconds behind <leaderhim>|You're only a\nfew seconds behind me", "Hey c'mon!\nPlay nice~"]);

		if (gameStateClass == ScaleGameState || gameStateClass == TugGameState) g.addWinning("#kecl00#Ehh what's this scoreboard mean? What's this big number next to my name? I don't understand...", ["Ha ha,\nyou ass", "You know exactly\nwhat it means", "..."]);
		if (gameStateClass == StairGameState) g.addWinning("#kecl00#Ehh what's this weird chest thing? How come you don't got one? I don't understand...", ["Ha ha,\nyou ass", "You know exactly\nwhat it is", "..."]);
		g.addWinning("#kecl03#Keck-kekekeke! So waddaya say, can I join your puzzle team now?", ["You'll never\njoin! Never!", "If you win...\nTHEN you can join", "Hey this\nisn't over!"]);
		if (gameStateClass == ScaleGameState) g.addWinning("#kecl02#Ayy this is pretty fun! Are you havin' trouble? You just gotta put the bugs on the thingies!", ["Ughhhh...", "Tsk don't\npatronize me", "The bugs... On the\nthingies... Hmm..."]);
		if (gameStateClass == StairGameState || gameStateClass == TugGameState) g.addWinning("#kecl02#Ayy this is pretty fun! Are you havin' trouble? You just gotta move the bugs over to the thingies!", ["Ughhhh...", "Tsk don't\npatronize me", "The bugs... Over to\nthe thingies...\nHmm..."]);

		if (gameStateClass == ScaleGameState) g.addLosing("#kecl08#C'mon how'm I supposed to catch you if you keep movin' further ahead!?!", ["Yeah,\nhmmm...|I don't make\nit easy, do I?", "How does <leaderhe>\nkeep doing that!?|Sorry, I'll\ngo slower", "Just gotta\nbe faster...|Channel your\ninner calculator"]);
		if (gameStateClass == TugGameState) g.addLosing("#kecl08#C'mon how'm I supposed to catch you if you keep movin' further ahead!?!", ["Yeah,\nhmmm...|I don't make\nit easy, do I?", "How does <leaderhe>\nkeep doing that!?|Sorry, I'll\ngo slower", "Just gotta\nbe faster...|My spirit animal\nis an abacus"]);
		if (gameStateClass == StairGameState) g.addLosing("#kecl08#C'mon how'm I supposed to catch you if you keep movin' further ahead!?!", ["I don't make\nit easy, do I?", "Sorry, I'll\ngo slower", "Channel your\nlatent psychic\nabilities..."]);
		g.addLosing("#kecl09#Ugh I'm garbage. Total garbage! Avert your eyes, don't stare at the garbage lizard.", ["Ha ha c'mon\nyou're not garbage", "It's just\na game", "Hey you're\ndoing great"]);
		if (gameStateClass == ScaleGameState || gameStateClass == TugGameState) g.addLosing("#kecl10#Hey, hey, waitaminnit! What am I doin' all the way back there? Is someone screwin' with my score?", ["Seems about right...\nYou're doing terrible", "What a lazy\nexcuse!", "It's a\nconspiracy"]);
		if (gameStateClass == StairGameState) g.addLosing("#kecl10#Hey, hey, waitaminnit! What am I doin' all the way back there? Are the " + comColor + " ones slower or somethin?", ["Seems about right...\nYou're doing terrible", "What a lazy\nexcuse!", "It's a\nconspiracy"]);

		g.addPlayerBeatMe(["#kecl13#Aww what! How could I lose! I played perfectly. Perfectly I tell you! Grahh...", "#kecl12#Next time we're playin' something I can win at! ...Like hide-and-go-seek in the dark!"]);
		g.addPlayerBeatMe(["#kecl13#Ayyy waitaminnit! I didn't know that rule! What? What's going on? It's over?", "#kecl12#Grahh, whatever! Nobody ever tells me all the rules. I don't understand what I'm doin' here...", "#kecl07#'slike, I'm not even one of the main characters or nothin'. Who the heck put me in charge of a frickin' minigame!?"]);

		g.addBeatPlayer(["#kecl00#Whoa! Smeargle NEVER lets me win at these things! Keck-kekekekeke~", "#kecl03#Thanks buddy! This was nice for the ol' self-esteem. Next time I'll let you win, okay <name>?"]);
		g.addBeatPlayer(["#kecl00#Whoa! Kecleon won? Who saw that comin'?", "#kecl02#You know who saw it coming? ME! Because I'mmmm GREAT. Keck-kekekekeke~", "#kecl05#Ehhh I'm just bein' hard on you! Let me enjoy this for once. You always win at this stuff~"]);

		g.addShortWeWereBeaten("#kecl04#Ayy this was fun! Thanks for playin' with me, <name>.");
		g.addShortWeWereBeaten("#kecl04#Ayy don't sweat it, I didn't win either! ...As long as we both had fun, right?");

		g.addShortPlayerBeatMe("#kecl04#Ayy this was fun! Thanks for playin' with me, <name>.");
		g.addShortPlayerBeatMe("#kecl02#You killed it, <name>! Geez, I'm startin' to understand what Abra sees in that little melon of yours...");

		g.addStairOddsEvens("#kecl05#Alright so, you wanna do odds and evens to see who goes first? You can be odds, I'll be evens. Ready?", ["Hmm, yeah\nsure...", "Alright", "Let's\ndo it!"]);
		g.addStairOddsEvens("#kecl04#Let's pick the start player with odds and evens. You're odds, I'm evens. Okay?", ["Uhh yeah,\nokay", "Sure thing", "Okay,\nlet's go!"]);

		g.addStairPlayerStarts("#kecl05#Odd. Ugh, typical. Guess you're goin' first.... You ready to start this thing, or what?", ["Yeah,\nokay!", "...What?", "Yep, let's\nstart"]);
		g.addStairPlayerStarts("#kecl04#It's odd? Yeah, okay, serves me right I guess. That means you get to throw first. You ready?", ["Hmm,\nsure...", "Yep", "Yeah! I'm ready."]);

		g.addStairComputerStarts("#kecl03#Even? Nice! I get to go first, for what it's worth, eh? ...Anyway, you ready to start this thing?", ["Sure", "Yeah,\nlet's start\nthis... thing", "Mmm, okay!"]);
		g.addStairComputerStarts("#kecl03#Evens, is it? Guess it's my turn to start! ...Ehh, gimme a second to think of my first move... Two's a typical starting thing, right?", ["Heh! Throw\nwhatever\nyou want", "Unless\nyou think I'm\ngonna throw\na zero...", "Nahh, try\nthrowing\na one"]);

		g.addStairCheat("#kecl12#Ayyy not so fast! You thought I didn't see that little, slow rolling thing you did? C'mahhhhn! You gotta roll at the same time as me.", ["Hmph,\nwhatever", "Oh, okay", "Was I actually\nlate? It\nseemed fine"]);
		g.addStairCheat("#kecl13#Ayy c'mon, what are you tryin' to pull here! You gotta roll faster than that. No cheating!", ["Okay, I'll try\nto go faster", "You're counting\ntoo fast!", "Cheating?\nMe?"]);

		g.addStairReady("#kecl04#Ready, <name>?", ["Yep!\nReady", "Okay", "Hmm, let me\nthink..."]);
		g.addStairReady("#kecl05#You ready?", ["Uh, hmm...", "Let's go!", "Yeah, okay"]);
		g.addStairReady("#kecl05#Ayy, you ready?", ["Yeah!", "Sure,\nI'm ready", "Just a\nsecond..."]);
		g.addStairReady("#kecl04#Alright. You got a plan?", ["Piece\nof cake", "Hmm, I\nthink so...", "Yep! Got\na plan"]);
		g.addStairReady("#kecl06#Uhh, let's see. You ready?", ["On three,\nokay?", "Sure", "Ready!"]);

		g.addCloseGame("#kecl06#Hmm, it's a little quiet. Maybe I can turn on a little music or somethin'...", ["Why doesn't\nthis game have\nany music?", "I sort of\nlike the\nquiet~", "I've already\ngot some\nmusic on"]);
		g.addCloseGame("#kecl05#You play a lot of games like this? You seem to have a good handle on, y'know, the whole \"wine in front of me\" thing.", ["It's nothing\ntoo hard", "Yeah! I\nlove games\nlike this", "My friends\ndon't play a lot\nof games..."]);
		g.addCloseGame("#kecl04#I'm not used to this game bein' so close! Usually someone gets a quick capture or somethin', and it sorta snowballs...", ["Oh, there's\nnothing wrong\nwith a little\nsnowballing~", "You've been\nlucky so far...", "Yeah, I'm not\na fan of the\nsnowballing"]);
		g.addCloseGame("#kecl06#Geez <name>, who'da thought we'd be so evenly matched at this kinda stuff? Smeargle usually kinda mops the floor with me.", ["Heh, I was going\neasy on you...", "Reptiles make\nterrible mops", "How is Smeargle\nso good at\nthese games!?"]);
		{
			var pronoun:String = "their";
			if (PlayerData.gender == PlayerData.Gender.Boy)
			{
				pronoun = "his";
			}
			else if (PlayerData.gender == PlayerData.Gender.Boy)
			{
				pronoun = "her";
			}
			g.addCloseGame("#smea02#You can do it, squabbykins! ...Kick <name> right in " + pronoun + " smelly tuckus!!", ["Tsk, so\nrude!", "Hey! My tuckus\nisn't smelly...", "You're next,\nSmeargle!"]);
		}

		{
			var king:String = PlayerData.keclMale ? "king" : "queen";
			g.addStairCapturedHuman("#kecl03#Bow, <name>! Bow down before the reptile " + king + " of minigames. Swear your allegiance and maybe I'll go easy on you. Kecl! Kekekekeke~", ["Yes, your\nmajesty", "You really\nlet this go\nto your head...", "You? You're the\nreptile " + king + " of\ndoo-doo mountain"]);
		}
		g.addStairCapturedHuman("#kecl00#Keck! Kekekekekeke. I never get tired of watchin' your bugs splat when they get knocked off the stairs. ...Brings warmth to my cold reptilian heart.", ["That's\nso evil!", "Heh, it\nis kind\nof funny...", "It would be\nfunnier if he\nwas " + comColor]);
		g.addStairCapturedHuman("#kecl02#Sorry <name>! What can I say. Sucks to suck, don't it? Kecl! Keck-kekekekek~", ["You know,\nsucking\nisn't so bad~", "Ugh, why'd\nI do that...", "Heh, just a\nlittle bad luck,\nI'll recover"]);

		g.addStairCapturedComputer("#kecl12#Yeah, okay. There I am. All the way back at the bottom. Good job. Bet you feel real proud of that one, <name>.", ["Why did\nyou throw\nout <computerthrow>?", "Hey, don't get\ndiscouraged...", "It does feel\nkinda good~"]);
		g.addStairCapturedComputer("#kecl13#Gahhh, c'mon! <Playerthrow>? What planet are you from where puttin' out <playerthrow> seemed like a remotely sensible idea?", ["Planet earth?\n...Wait, what planet\nare you from?", "I dunno, made\nsense to me", "Heh, sucks\nto suck,\ndon't it~"]);
		g.addStairCapturedComputer("#kecl13#Whoa, easy <name>! We're all friends here. You don't gotta go beating up on all my... " + comColor + " little bug dudes.", ["Actually,\nI kind of do", "Die, you\nreptilian\nmenace!", "Heh aww,\nI'll go easy"]);

		return g;
	}

	public static function shopIntro0(tree:Array<Array<Object>>)
	{
		tree[0] = ["#kecl02#How's it goin' <name>! I'm runnin' the store again today while Heracross is out doin' ehh... stuff."];
		tree[1] = ["#kecl06#...Y'know... bug stuff I guess? I dunno. Maybe the guy just needs a break."];
		if (!PlayerData.heraMale)
		{
			DialogTree.replace(tree, 1, "the guy", "the girl");
		}
	}

	public static function shopIntro1(tree:Array<Array<Object>>)
	{
		tree[0] = ["#kecl07#Ah it's about time a freakin' customer showed up! ...I was gettin' bored out of my mind over here."];
		tree[1] = ["#kecl05#I dunno how Heracross stays cooped up in this store all day. I need... I need social engagement. So how's your day been?"];
	}

	public static function shopIntro2(tree:Array<Array<Object>>)
	{
		tree[0] = ["#kecl04#Surprise! It's your old pal Kecleon runnin' the store today. ...See anything ya like?"];
		tree[1] = ["#kecl13#...Don't look at me that way, I'm not for sale! I meant the merchandise, ya weird perv."];
	}

	public static function shopIntro3(tree:Array<Array<Object>>)
	{
		tree[0] = ["#kecl03#Oh hey there <name>! You thinking about purchasin' something today, or you just wanna browse?"];
		tree[1] = ["#kecl05#Ayy no worries, browsing's always free! ... ... ...ya cheapskate."];
	}

	public static function shopIntro4(tree:Array<Array<Object>>)
	{
		tree[0] = ["#kecl04#Ay how's it goin' <name>! If you were looking for Heracross, he just stepped out for a moment."];
		tree[1] = ["#kecl05#But y'know, ask me anything! Anything about anything. I know this here merchandise inside and out! Well... except maybe that thing."];
		if (!PlayerData.heraMale)
		{
			DialogTree.replace(tree, 0, "he just", "she just");
		}
	}

	public static function shopIntro5(tree:Array<Array<Object>>)
	{
		tree[0] = ["#kecl04#Oh what's up <name>? ...What were you lookin' to purchase? We got a little bit of everything here... as per the usual."];
		tree[1] = ["#kecl03#Maybe one of these things? ...Maybe that thing over there? ... ...Just lookit all these things!"];
	}

	public static function firstTimeInShop(tree:Array<Array<Object>>)
	{
		tree[0] = ["#kecl02#Oh it's you <name>! ...Don't worry, Heracross'll be back soon."];
		tree[1] = ["#kecl05#He just had to step out, let his wings breathe or somethin'. So I'm keepin' an eye on the store in the meantime."];
		tree[2] = ["#kecl04#I can handle the register too! ...So if you see anything you like, you know, feel free to ask me whatever~"];
		tree[3] = [10, 30, 40, 20];

		tree[10] = ["What about my\nvideo money?"];
		tree[11] = ["#kecl06#Video money? ...Nahh, I don't know nothin' about that, sorry."];
		tree[12] = ["#kecl04#Guess Heracross only filled me in on like fifty percent of his shady dealings-on."];
		tree[13] = ["#kecl06#He did ehh, give me a laundry list of things to say and not say in front of Magnezone though. You ain't seen that nosy robot around have ya?"];
		tree[14] = [50];

		tree[20] = ["Can you\ngive me a\ndiscount?"];
		tree[21] = ["#kecl06#Discount eh? Ahhh I get it! Yeah, yeah, I mean ordinarily I'd be amicable to that kind of... shady arrangement."];
		tree[22] = ["#kecl04#I mean screw a discount, I could just turn my back for 30 seconds, and what happens happens!"];
		tree[23] = ["#kecl00#After all, what kinda friend would I be if I didn't facilitate your involvement in the robbery of a store? Keck! Kekekeke~"];
		tree[24] = ["#kecl06#But ehhh... on the OTHER hand, seein' as Heracross is givin' me a cut off the top for everything I sell..."];
		tree[25] = ["#kecl03#... ...Well I may actually need to ask you to pay a little MORE money than you're used to-- if that's alright. 'snothing personal!"];
		tree[26] = [50];

		tree[30] = ["Yay! More\nKecleon"];
		tree[31] = ["#kecl00#Ayyy lookit my little fan club over here! Keck-kekekeke~"];
		tree[32] = ["#kecl06#Yeah sorry we can't hang out more! The kinda stuff you and Smeargle do looks pretty tempting. I'd love to get in on some of that action, but ehhh...."];
		tree[33] = ["#kecl08#I mean even if Smeargle agreed to it, I dunno. He's got kind of a self-esteem thing..."];
		tree[34] = ["#kecl04#...I think it'd drive him a little nuts on the inside. Keck~"];
		tree[35] = [50];

		tree[40] = ["Sure,\nsounds good"];
		tree[41] = [50];

		tree[50] = ["#kecl05#Anyway so yeah, look around, ask some questions! Buy somethin'! I'm here to help~"];

		if (!PlayerData.heraMale)
		{
			DialogTree.replace(tree, 1, "He just", "She just");
			DialogTree.replace(tree, 1, "let his", "let her");
			DialogTree.replace(tree, 12, "of his", "of her");
			DialogTree.replace(tree, 13, "He did", "She did");
		}
		if (!PlayerData.smeaMale)
		{
			DialogTree.replace(tree, 33, "He's got", "She's got");
			DialogTree.replace(tree, 34, "drive him", "drive her");
		}
	}

	public static function receivedGift(tree:Array<Array<Object>>)
	{
		tree[0] = ["#kecl03#Holy smokes <name>! ...How are you so frickin' nice!? Are you kiddin' me?"];
		tree[1] = ["#kecl02#I got your present, it was all gift wrapped and set out for me on my usual spot. It's perfect, oh my god! I like, I didn't even know this thing existed."];
		tree[2] = ["#kecl05#And I mean even if I DID know it existed wouldn'ta had the smarts to set it up, but this thing's just like, out of the box ready to go..."];
		tree[3] = ["#kecl03#...And it's like, it's got SO many games! They're listed out all here in this note, all these old favorites I get to teach Smeargle..."];
		tree[4] = ["#kecl07#I mean, can you believe he's never heard of Super Bomberman? C'mon, what kinda deprived childhood you gotta lead to never play frickin' Bomberman!!"];
		tree[5] = ["#kecl05#...Anyway, thanks again <name>! ...You're like, the best! The best! Aaaaaahh! I can't wait to get home and play! I owe you big time."];
		tree[6] = ["#kecl06#..."];
		tree[7] = ["#kecl04#Tell ya what, don't tell Heracross I did this but ehh..."];
		tree[8] = ["#kecl02#...Just for today only, just like, take anythin' you want in the shop, alright? Anything at all, it's all yours!"];
		tree[9] = ["#kecl13#I mean, y'know... in exchange for money of course. ... ...What, I ain't runnin' a charity here!"];

		if (!PlayerData.smeaMale)
		{
			DialogTree.replace(tree, 4, "believe he's", "believe she's");
		}
	}

	public static function mysteryBox(tree:Array<Array<Object>>, shopItem:MysteryBoxShopItem)
	{
		var boxCount:Int = ItemDatabase.getPurchasedMysteryBoxCount();

		if (boxCount % 5 == 0)
		{
			tree[0] = ["#kecl06#Ehhh, that's just some empty box what ain't got nothing in it. ...You don't wanna buy that thing."];
			tree[1] = ["#kecl05#I'ma try and get on Heracross's case to get some actual merchandise in this store! ... ...You with me or what?"];
		}
		else if (boxCount % 5 == 1)
		{
			tree[0] = ["#kecl12#This here's a, ehh... Wait, what the heck's goin' on here anyway?"];
			tree[1] = ["#kecl13#There's not even any merchandise in this frickin' thing! ...What the heck's it doin' out here with a " + moneyString(shopItem.getPrice()) + " price tag?"];
		}
		else if (boxCount % 5 == 2)
		{
			tree[0] = ["#kecl05#Ooooooh! This here's a ehhh.... Three dimensional... rectangle of intrigue! Yeahhhh! It's got all sorts of, ehhhhh... ..."];
			tree[1] = ["#kecl08#Ahhh who'm I kidding, I can't sell this junk."];
		}
		else if (boxCount % 5 == 3)
		{
			tree[0] = ["#kecl04#Whaaaaaat, seriously? ...What the heck's a guy like you gonna do with a " + moneyString(shopItem.getPrice()) + " box?"];
			tree[1] = ["#kecl08#Look <name>, I'ma level with you. ...You're gettin' gouged over here. ... ...You really gotta find a new box guy."];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 0, "guy like", "girl like");
			}
		}
		else if (boxCount % 5 == 4)
		{
			tree[0] = ["#kecl13#What? Nahhh I ain't sellin' you this crap. How many of these stupid boxes have you bought anyway!?!"];
			tree[1] = ["#kecl12#Seriously, I dunno how Heracross sleeps at night."];
		}
	}

	public static function phoneCall(tree:Array<Array<Object>>, shopItem:ItemDatabase.TelephoneShopItem)
	{
		var checksum:Int = Std.int(Math.abs(PlayerData.abraSexyBeforeChat + PlayerData.buizSexyBeforeChat + PlayerData.rhydSexyBeforeChat + PlayerData.sandSexyBeforeChat + PlayerData.smeaSexyBeforeChat + PlayerData.grovSexyBeforeChat));

		if (checksum % 5 == 0)
		{
			tree[0] = ["#kecl06#Ehhh, what's that thing? ...You want me to ehh, push some of these buttons for you or somethin?"];
			tree[1] = ["#kecl13#Nahhh, nah nah nah! I've seen Hellraiser, I know better than to go messin' with your... weird ass kooky button boxes."];
			tree[2] = ["#kecl12#I'll leave it to you and Heracross to fight off the hordes of ehhh, cenobites or whatever the heck you got cooped up in there."];
		}
		else if (checksum % 5 == 1)
		{
			tree[0] = ["#kecl06#...What is this, some kinda kid's toy? Lemme see this. What am I, supposed to push this? Or... ..."];
			tree[1] = ["#kecl11#D'ahh, what the! ...I actually got a dial tone! What is this creepy thing? I ain't touchin' it anymore."];
		}
		else if (checksum % 5 == 2)
		{
			tree[0] = ["#kecl06#What is this dumb thing anyway? Looks sorta like Heracross but it's ehhhh so boxy!"];
			tree[1] = ["#kecl10#It's like some sorta weird... Heracross... boxy... weird box fetish thing!"];
			tree[2] = ["#kecl12#Eesh, I think I liked it better when he was just sellin' mystery boxes! Not this creepy garage sale crap."];

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 2, "he was", "she was");
			}
		}
		else if (checksum % 5 == 3)
		{
			tree[0] = ["#kecl08#Ayyy, you actually want that thing? You can have it. Yeesh."];
			tree[1] = ["#kecl06#Actually on second thought maybe I should keep an eye on it. I don't want it goin' all Chucky and, comin' to life, murderin' all the pokemon here."];
			tree[2] = ["#kecl10#I mean, look at those eyes! There's somethin' ain't right with that thing... ..."];
		}
		else if (checksum % 5 == 4)
		{
			tree[0] = ["#kecl06#...Well that's like, the creepiest frickin' phone ever, I guess. Is this thing actually for sale?"];
			tree[1] = ["#kecl07#And I mean who even uses a land line anymore? What decade is this?"];
			tree[2] = ["#kecl12#I gotta get on Heracross's case about some of this merchandise. What the hell's wrong with that guy..."];

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 2, "that guy", "that girl");
			}
		}
	}
}