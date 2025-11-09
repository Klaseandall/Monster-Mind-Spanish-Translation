package poke.hera;

import MmStringTools.*;
import flixel.FlxG;
import poke.magn.MagnDialog;
import openfl.utils.Object;

/**
 * Heracross shop dialog. This includes dialog he says when selling items, as
 * well as dialog for buying your porn videos and other special shop events
 */
class HeraShopDialog
{
	/**
	 * Begin store conversations
	 */
	public static function firstVideo(tree:Array<Array<Object>>)
	{
		tree[0] = ["#hera02#Well hello! I don't believe we've really spoken before... <name>? I've been meaning to ask you something important-"];
		tree[1] = ["#hera05#I run a Pokemon daycare center a few blocks away, where Pokemon come to hook up."];
		tree[2] = ["#hera06#And while I don't charge customers any MONEY per se, I DO monetize the security videos."];
		tree[3] = ["#hera04#Sometimes people ask to buy the videos, or sometimes I just upload them to sites like pokepornlive.com for the advertising revenue!"];
		if (PlayerData.videoStatus == PlayerData.VideoStatus.Clean)
		{
			DialogTree.replace(tree, 3, "pokepornlive.com", "pokevideos.com");
		}
		tree[4] = ["#hera10#...Hey, don't look at me like that! Of course I ALWAYS tell customers they're being filmed! ...I mean, if they ask..."];
		tree[5] = ["#hera02#Anyway I was thinking, maybe I could do that same thing here! Earn a little extra money, you know?"];

		var bestVideo:PlayerData.PokeVideo = getBestVideo();

		tree[6] = ["#hera05#Like I could upload that last video I recorded of you and " + bestVideo.name + " to the site, and see if people like it. What do you think?"];
		tree[7] = [60, 70, 80, 20, 40];

		tree[20] = ["Okay"];
		tree[21] = ["#hera02#Well hooray then! And of course I'll give you a cut of the advertising revenue."];
		tree[22] = ["#hera04#It'll take me a little while to get set up, so be patient with me. I'm only one bug!!"];
		tree[23] = [200];

		tree[40] = ["Okay, but I\nwant a cut"];
		tree[41] = ["#hera02#Well hooray then! And yes of COURSE I was going to give you a cut of the advertising revenue.... Gweh-heh-heh!"];
		tree[42] = ["#hera04#Anyway it'll take me a little while to get set up, so be patient with me. I'm only one bug!!"];
		tree[43] = [200];

		tree[60] = ["No, I don't\nlike it"];
		tree[61] = ["#hera06#Aww really? I think you'll change your mind once you see how much money I can make!"];
		tree[62] = ["#hera11#...I mean, how much money WE can make! ...Of course I was going to cut you into the advertising revenue!"];
		tree[63] = ["#hera03#Doesn't that change your mind a little?"];
		tree[64] = [140, 100, 120];

		tree[70] = ["No, people\nmight\nrecognize me"];
		tree[71] = [61];

		tree[80] = ["No, and stop\ntaping me"];
		tree[81] = [61];

		tree[100] = ["Yes, but I\nwant 100% of\nthe revenue"];
		tree[101] = ["#hera06#...Well gosh, you drive a hard booger!"];
		tree[102] = ["#hera02#Of COURSE I'll give you 100% of this ambiguous amount of advertising revenue that you have no insight into. Gweh-heh heh heh!"];
		tree[103] = [200];

		tree[120] = ["Yes, if we\nsplit it\n50/50"];
		tree[121] = ["#hera06#...Well gosh, you drive a hard booger!"];
		tree[122] = ["#hera02#Of COURSE I'll give you 50% of this ambiguous amount of advertising revenue that you have no insight into. Gweh-heh heh heh!"];
		tree[123] = [200];

		tree[140] = ["No, I don't\nlike it"];
		tree[141] = ["#hera09#Hmmmm... Hmm, hmmmm...."];
		tree[142] = ["#hera02#You know, I think I'll just do it anyways! I bet you'll change your mind."];
		tree[143] = [200];

		tree[200] = ["#hera03#Now go try to make some nice videos! I'll upload them to the site and see what kind of money we can get."];
		tree[201] = ["%set-started-taping%"];
		tree[10000] = ["%set-started-taping%"];
	}

	public static function firstVideoReward(tree:Array<Array<Object>>)
	{
		var videoReward:String = moneyString(PlayerData.getPokeVideoReward());

		tree[0] = ["#hera03#Gweeeeeehhh, " + stretch(PlayerData.name) + "!!! Your videoooos!! Oh my grapes~"];
		tree[1] = ["#hera00#I watched them like three times before uploading them to the site. They were soooooo gooooooood~"];
		tree[2] = ["%pay-videos%"];
		tree[3] = ["#hera04#They're doing really well online too. The advertising revenue keeps pouring in!!! And after my feeeeeees, your cut comes to... " + videoReward + ". Hooray!"];
		tree[4] = [40, 30, 20, 10];

		tree[10] = ["...Don't\nupload\nany more\nof my\nvideos"];
		tree[11] = ["#hera02#No, no, it's much too late for that. What's done is done!"];
		tree[12] = [50];

		tree[20] = ["You're\nonly giving\nme " + videoReward + "!?\nYou selfish\nbug!"];
		tree[21] = ["#hera10#Gweh! I'm sorry! I know it looks like I'm taking a nasty cut out of what should be YOUR money. I promise I'm not trying to steal from you!"];
		tree[22] = ["#hera11#But ehhh, I can't just give you more money either. ...Otherwise I'd be stealing from me! Gwehhhhhh! What can we doooo?"];
		tree[23] = ["#hera06#Maybe there's a way to make our videos more popular? You're doing great, but the Pokemon you're with could maaaaaybe be a little more... Gwehh--"];
		tree[24] = [51];

		tree[30] = ["Hmm " + videoReward + ",\nthat's not\nbad I guess"];
		tree[31] = ["#hera02#Right? And all you had to do was show a few Pokemon a good time. You were probably going to do that anyway!"];
		tree[32] = [50];

		tree[40] = ["Wow " + videoReward + ",\nI can buy\nalmost\nanything\nin the\nstore"];
		tree[41] = ["#hera02#Right? It's crazy how much money you can make from porn! Especially considering it's so easy to get it for free nowadays."];
		tree[42] = [50];

		tree[50] = ["#hera06#Although, I was thinking of ways I could earn even MORE money! You're doing great, but the Pokemon you're with could maaaaaybe be a little more... Gwehh--"];
		tree[51] = ["#hera05#--Well like maybe if you catch them on a day where they're BURSTING with energy, I bet our video would do even better! What do you think?"];
		tree[52] = ["#hera04#I meeeeeean, you might have noticed those little green and yellow meters right?"];
		tree[53] = [80, 60, 90, 70];

		tree[60] = ["What are\nthose?"];
		tree[61] = [71];

		tree[70] = ["The ones\non the title\nscreen?"];
		tree[71] = ["#hera05#Yeah! The little green and yellow meters below the Pokemon on the title screen, well they're sort of like little friskiness meters."];
		tree[72] = [100];

		tree[80] = ["No, where\nare they?"];
		tree[81] = ["#hera05#Oh, there are these little green and yellow meters below the Pokemon on the title screen. They're sort of like little friskiness meters."];
		tree[82] = [100];

		tree[90] = ["I know\nwhat those\nare"];
		tree[91] = [101];

		tree[100] = ["#hera06#They tell you which Pokemon are feeling more energetic sooooo... Well, It's not something you HAVE to think about but maybeeee..."];
		tree[101] = ["#hera01#Gweh, whatever! You did really good for your first day. Talking about this makes me want to watch those videos again~"];

		if (PlayerData.pokeVideos.length == 1)
		{
			DialogTree.replace(tree, 0, "Your videoooos", "Your videoooo");
			DialogTree.replace(tree, 1, "watched them", "watched it");
			DialogTree.replace(tree, 1, "uploading them", "uploading it");
			DialogTree.replace(tree, 1, "They were", "It was");
			DialogTree.replace(tree, 3, "They're doing", "It's doing");
			DialogTree.replace(tree, 31, "a few Pokemon", "that one Pokemon");
			DialogTree.replace(tree, 101, "those videos", "that video");
		}

		tree[10000] = ["%pay-videos%"];
	}

	public static function injectPhoneResponses(tree:Array<Array<Object>>, index:Int)
	{
		tree[index] = [10, 20, 30, 40];
		FlxG.random.shuffle(tree[index]);

		// aloof responses
		tree[10] = [FlxG.random.getObject([
											  "It just\nslipped\nin there",
											  "It all\nhappened\nso fast",
											  "I'm as\nconfused\nas you are",
											  "Was that\nwrong?",
											  "I don't\nunderstand\nthe problem"])];
		tree[11] = [50];

		// mean responses
		tree[20] = [FlxG.random.getObject([
											  "You should\nbe nicer to\nSandslash",
											  "You need\nto keep a\nbetter eye\non your stuff",
											  "Oh,\nloosen up",
											  "Ha ha ha\nha ha ha ha\nha ha ha"])];
		tree[21] = [50];

		// innocent responses
		tree[30] = [FlxG.random.getObject([
											  "It wasn't me",
											  "I didn't\ndo it",
											  "I don't know\nwhat you're\ntalking about"
										  ])];
		tree[31] = [50];

		// apologetic responses
		tree[40] = [FlxG.random.getObject([
											  "I'm sorry,\nit won't\nhappen again",
											  "Oh oops,\nI'm sorry",
											  "Sorry, that\nwas wrong\nof me",
											  "Sorry, I\nthought\nyou'd be\ninto it"
										  ])];
		tree[41] = [50];
	}

	public static function videoReward0(tree:Array<Array<Object>>)
	{
		if (PlayerData.sandPhone == 10)
		{
			tree[0] = ["#hera11#" + stretch(PlayerData.name) + "! Gweh!!! ...I SAW what you two did!"];
			injectPhoneResponses(tree, 1);

			tree[50] = ["#hera12#How dare you. Only *I* get to masturbate with my phone!"];
			tree[51] = ["%pay-videos%"];
			tree[52] = ["%reset-sandphone%"];
			tree[53] = ["#hera09#I almost don't want to give you the " + moneyString(PlayerData.getPokeVideoReward()) + " I owe you uploading for the video, but well..."];
			tree[54] = ["#hera05#...It was pretty hot. And it made me a lot of money~"];

			tree[10000] = ["%pay-videos%"];
			tree[10001] = ["%reset-sandphone%"];
		}
		else if (ItemDatabase.isMagnezonePresent())
		{
			tree[0] = ["#hera06#Oh, it's you again <name>! Here's, uhh... Here's the " + moneyString(PlayerData.getPokeVideoReward()) + " I owed you for... that thing you helped me with."];
			tree[1] = ["%pay-videos%"];
			tree[2] = ["#magn05#...?"];
			tree[10000] = ["%pay-videos%"];
		}
		else
		{
			if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_STREAMING_PACKAGE))
			{
				tree[0] = ["#hera05#Oh, it's you again <name>! Those last " + englishNumber(PlayerData.pokeVideos.length) + " streams earned you " + moneyString(PlayerData.getPokeVideoReward()) + "."];
				DialogTree.replace(tree, 0, "Those last one streams", "That last stream");
			}
			else
			{
				tree[0] = ["#hera05#Oh, it's you again <name>! I just uploaded those " + englishNumber(PlayerData.pokeVideos.length) + " videos to pokepornlive.com,"
						   + " and your cut comes to " + moneyString(PlayerData.getPokeVideoReward()) + "."];
				DialogTree.replace(tree, 0, "those one videos", "that video");
				if (PlayerData.videoStatus == PlayerData.VideoStatus.Clean)
				{
					DialogTree.replace(tree, 0, "pokepornlive.com", "pokevideos.com");
				}
			}
			tree[1] = ["%pay-videos%"];
			tree[2] = ["#hera03#Not bad for a day's work, right?"];

			tree[10000] = ["%pay-videos%"];
		}
	}

	public static function videoReward1(tree:Array<Array<Object>>)
	{
		var bestVideo:PlayerData.PokeVideo = getBestVideo();
		if (PlayerData.sandPhone == 10)
		{
			tree[0] = ["#hera13#...!"];
			tree[1] = ["#hera12#You DO remember I have cameras in there, right? RIGHT???"];
			injectPhoneResponses(tree, 2);

			tree[50] = ["#hera08#Well anyway, your video still made "  + moneyString(PlayerData.getPokeVideoReward()) + " so... Here, I guess."];
			tree[51] = ["%pay-videos%"];
			tree[52] = ["%reset-sandphone%"];
			tree[53] = ["#hera06#But there are some things more important than money!"];
			tree[54] = ["#hera04#...Like, err... mystery boxes, for example!"];

			tree[10000] = ["%pay-videos%"];
			tree[10001] = ["%reset-sandphone%"];
		}
		else if (ItemDatabase.isMagnezonePresent())
		{
			if (bestVideo.name == "Magnezone")
			{
				tree[0] = ["#hera05#Oh, here's the " + moneyString(PlayerData.getPokeVideoReward()) + " for that video of Mag-"];
				tree[1] = ["#hera10#I mean, ehhh, gwuh...."];
				tree[2] = ["#hera06#Hi Magnezone! I believe you've met my friend <name>."];
				tree[3] = ["%pay-videos%"];
				tree[4] = ["#magn04#... ..."];
				tree[4] = ["#magn14#Yes. " + MagnDialog.PLAYER + " and I have... ...met."];
			}
			else if (bestVideo.name == "Heracross")
			{
				tree[0] = ["#hera00#Oh, here's the " + moneyString(PlayerData.getPokeVideoReward()) + " for... helping me review those security videos of ummm... Oh, you know who~"];
				tree[1] = ["%pay-videos%"];
				tree[2] = ["#magn04#...Security videos? ...I can assist with that."];
			}
			else
			{
				tree[0] = ["#hera06#Oh, here's the " + moneyString(PlayerData.getPokeVideoReward()) + " for... helping me review those security videos of " + bestVideo.name + "!"];
				tree[1] = ["%pay-videos%"];
				tree[2] = ["#magn04#...Security videos? ...I can assist with that."];
			}

			tree[10000] = ["%pay-videos%"];
		}
		else
		{
			if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_STREAMING_PACKAGE))
			{
				tree[0] = ["#hera05#I got the money for those last " + englishNumber(PlayerData.pokeVideos.length) + " streams on pokepornlive.com."
						   + " Your cut comes to " + moneyString(PlayerData.getPokeVideoReward()) + "!"];
				DialogTree.replace(tree, 0, "those last one streams", "that last stream");
				if (PlayerData.videoStatus == PlayerData.VideoStatus.Clean)
				{
					DialogTree.replace(tree, 0, "pokepornlive.com", "pokevideos.com");
				}
			}
			else
			{
				tree[0] = ["#hera05#I went ahead and uploaded those last " + englishNumber(PlayerData.pokeVideos.length) + " videos to pokepornlive.com."
						   + " Your cut comes to " + moneyString(PlayerData.getPokeVideoReward()) + "!"];
				DialogTree.replace(tree, 0, "those last one videos", "that last video");
				if (PlayerData.videoStatus == PlayerData.VideoStatus.Clean)
				{
					DialogTree.replace(tree, 0, "pokepornlive.com", "pokevideos.com");
				}
			}
			tree[1] = ["%pay-videos%"];
			if (bestVideo.name == "Magnezone" && PlayerData.videoStatus != PlayerData.VideoStatus.Clean)
			{
				var which:Int = FlxG.random.int(0, 7);
				if (which == 0)
				{
					tree[2] = ["#hera06#We'll see how long the Magnezone videos stay up, since they're not technically porn..."];
				}
				else if (which == 1)
				{
					tree[2] = ["#hera06#I have NO idea what that was you did with Magnezone... Or whether it's porn or not..."];
				}
				else if (which == 2)
				{
					tree[2] = ["#hera06#Those Magnezone videos seem kind of, uhh... Just... Don't get yourself killed, okay?"];
				}
				else if (which == 3)
				{
					tree[2] = ["#hera06#But... Magnezone? Seriously <name>, Magnezone?"];
				}
				else if (which == 4)
				{
					tree[2] = ["#hera12#And umm... I'm just going to pretend I wasn't aroused by your weird robot video."];
				}
				else if (which == 5)
				{
					tree[2] = ["#hera12#...Although if Magnezone finds out I uploaded his videos there, he's going to tie my antennae in a knot!!"];
					if (!PlayerData.magnMale)
					{
						DialogTree.replace(tree, 2, "uploaded his", "uploaded her");
						DialogTree.replace(tree, 2, "there, he's", "there, she's");
					}
				}
				else if (which == 6)
				{
					tree[2] = ["#hera12#Those Magnezone videos are gathering kind of a... weird... niche following that I'm not sure I want to cater to."];
				}
				else if (which == 7)
				{
					tree[2] = ["#hera06#I don't know how you made Magnezone look sexy but... you deserve some kind of porn Oscar for that one."];
				}
			}
			else if (bestVideo.name == "Heracross")
			{
				tree[2] = ["#hera01#I'm sort of getting my own little fanbase over there. Gweh-heh-heh!"];
			}
			else
			{
				tree[2] = ["#hera03#" + bestVideo.name + "'s getting his own little fanbase over there. Gweh-heh-heh!"];
			}
			if (!bestVideo.male)
			{
				DialogTree.replace(tree, 2, "his own", "her own");
			}

			tree[10000] = ["%pay-videos%"];
		}
	}

	public static function videoReward2(tree:Array<Array<Object>>)
	{
		if (PlayerData.sandPhone == 10)
		{
			tree[0] = ["#hera13#<name>...!?! ...I'd expect something like that from Sandslash... but you!?!"];
			tree[1] = ["#hera12#You KNEW I could see everything, right?"];
			injectPhoneResponses(tree, 2);

			tree[50] = ["#hera06#Whatever just ehhh... don't do it again! ...Now I have to figure out how I'm going to clean this thing..."];
			tree[51] = ["%pay-videos%"];
			tree[52] = ["%reset-sandphone%"];
			tree[53] = ["#hera05#Oh yeah and here's your gwuhh... "  + moneyString(PlayerData.getPokeVideoReward()) + "!?! Gosh! I can't believe the video did THAT well..."];

			tree[10000] = ["%pay-videos%"];
			tree[10001] = ["%reset-sandphone%"];
		}
		else if (ItemDatabase.isMagnezonePresent())
		{
			tree[0] = ["#hera04#Hey, I got the revenue for that last set of uhhh... stock... options! Your cut comes to " + moneyString(PlayerData.getPokeVideoReward()) + " this time."];
			tree[1] = ["%pay-videos%"];
			tree[2] = ["#magn05#...Stock options? ..." + moneyString(PlayerData.getPokeVideoReward()) + "?"];

			tree[10000] = ["%pay-videos%"];
		}
		else
		{
			if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_STREAMING_PACKAGE))
			{
				tree[0] = ["#hera04#Hey, I got the revenue for those recent streams you did! Your cut comes to " + moneyString(PlayerData.getPokeVideoReward()) + " this time."];
				if (PlayerData.pokeVideos.length == 1)
				{
					DialogTree.replace(tree, 0, "those recent streams", "that recent stream");
				}
			}
			else
			{
				tree[0] = ["#hera04#Hey, I uploaded that last set of videos! Your cut comes to " + moneyString(PlayerData.getPokeVideoReward()) + " this time."];
				if (PlayerData.pokeVideos.length == 1)
				{
					DialogTree.replace(tree, 0, "last set of videos", "last video");
				}
			}
			tree[1] = ["%pay-videos%"];
			tree[2] = ["#hera02#Don't spend it all in one place! ...As if you had a choice! Gweh! Heheheheh."];

			tree[10000] = ["%pay-videos%"];
		}
	}

	public static function videoReward3(tree:Array<Array<Object>>)
	{
		if (PlayerData.sandPhone == 10)
		{
			tree[0] = ["#hera11#Hey, you! Did you REALLY think you'd get away with doing THAT? With my PHONE!?!"];
			tree[1] = ["#hera14#You're in big big trouble!"];
			injectPhoneResponses(tree, 2);

			tree[50] = ["#hera13#I gave you FOUR different dildos, and still you have to go and use my phone!! I can't BELIEVE that you could--"];
			tree[51] = ["#hera10#--err, wait... was it four dildos??? Well anyway, I gave you three different dildos! THREE!!!"];
			tree[52] = ["%pay-videos%"];
			tree[53] = ["%reset-sandphone%"];
			tree[54] = ["#hera06#... ...I accidentally counted my phone as a dildo..."];

			tree[10000] = ["%pay-videos%"];
			tree[10001] = ["%reset-sandphone%"];
		}
		else if (ItemDatabase.isMagnezonePresent())
		{
			tree[0] = ["#hera04#Hey, I got the revenue for that last set of uhhh... stock... options! Your cut comes to " + moneyString(PlayerData.getPokeVideoReward() * 7) + " this time."];
			tree[1] = ["%pay-videos%"];
			tree[2] = ["#hera02#Oh wait, I mean " + moneyString(PlayerData.getPokeVideoReward()) + "!! I forgot about... taxes???"];
			tree[3] = ["#magn05#...You must NEVER forget about taxes, " + MagnDialog.HERA + ". Tax evasion is a very serious offense."];

			tree[10000] = ["%pay-videos%"];
		}
		else
		{
			if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_STREAMING_PACKAGE))
			{
				tree[0] = ["#hera04#Hey, I got the revenue for those recent streams you did! Your cut comes to " + moneyString(PlayerData.getPokeVideoReward() * 7) + " this time."];
				if (PlayerData.pokeVideos.length == 1)
				{
					DialogTree.replace(tree, 0, "those recent streams", "that recent stream");
				}
			}
			else
			{
				tree[0] = ["#hera04#Hey, I uploaded that last set of videos! Your cut comes to " + moneyString(PlayerData.getPokeVideoReward() * 7) + " this time."];
				if (PlayerData.pokeVideos.length == 1)
				{
					DialogTree.replace(tree, 0, "last set of videos", "last video");
				}
			}
			tree[1] = ["%pay-videos%"];
			tree[2] = ["#hera02#Oh wait, I mean " + moneyString(PlayerData.getPokeVideoReward()) + "!! I forgot about... taxes??? Sure, taxes!"];

			tree[10000] = ["%pay-videos%"];
		}
	}

	public static function howWasKecleon(tree:Array<Array<Object>>)
	{
		if (PlayerData.videoStatus != PlayerData.VideoStatus.Empty)
		{
			tree[0] = ["#hera05#Oops, sorry about that <name>! I guess I missed you. ...Here's the " + moneyString(PlayerData.getPokeVideoReward()) + " I owe you."];
			tree[1] = ["%pay-videos%"];
			tree[2] = ["#hera04#I hope I didn't miss anything else while I was out! ...How was Kecleon?"];
		}
		else
		{
			tree[0] = [2];
			tree[2] = ["#hera04#Oh hello <name>! I hope I didn't miss anything while I was out. ...How was Kecleon?"];
		}
		tree[3] = [40, 10, 30, 20, 50];

		tree[10] = ["...He\nneeds\nmore\ntraining"];
		tree[11] = ["#hera02#Training? Peh! ...He should be training me! Kecleons have a knack for this stuff."];
		tree[12] = ["#hera05#...He was probably employing a complex sales technique that went over your head. Did you buy a lot of things?"];
		tree[13] = [130, 100, 120, 110];

		tree[20] = ["...He\nlikes the\nhard sale"];
		tree[21] = ["#hera02#The hard sale? Ooooh he'll have to teach me that one! Kecleons have a knack for this stuff."];
		tree[22] = ["#hera05#Did that \"hard sale\" thing work on you? Did you buy a lot of things?"];
		tree[23] = [130, 100, 120, 110];

		tree[30] = ["...I'm glad\nyou're back"];
		tree[31] = ["#hera01#Oh! You missed me? That's really sweet of you~"];
		tree[32] = ["#hera02#But well... I can't be here 24/7. Even a workaholic bug like me needs a break every once in awhile!"];
		tree[33] = ["#hera05#I haven't checked the till though, how did Kecleon do numbers-wise? Did you buy a lot of things?"];
		tree[34] = [130, 100, 120, 110];

		tree[40] = ["...He might\nhave a\nneurological\ndisorder"];
		tree[41] = ["#hera02#Gweh! Heh-heh-heh. ...He was probably employing a complex sales technique that went over your head."];
		tree[42] = ["#hera05#I guess what matters is, did it work? Did you buy a lot of things?"];
		tree[43] = [130, 100, 120, 110];

		tree[50] = ["Kecleon\nwas great!"];
		tree[51] = ["#hera02#Gweh! Heh-heh-heh. Well that's good to hear. I could tell right away he was a great fit to run the store!"];
		tree[52] = ["#hera03#He seemed so knowledgable and trustworthy! I was just getting a good... shopkeeper kind of vibe from him. Hard to put my finger on!"];
		tree[53] = ["#hera05#How were his sales? Did you buy a lot of things?"];
		tree[54] = [130, 100, 120, 110];

		tree[100] = ["I didn't\nknow what\nI was\nbuying..."];
		tree[101] = ["#hera03#Yeah, he's got that kind of quality doesn't he? He's the kind of guy who could sell paper to a tree!"];
		tree[102] = [150];

		tree[110] = ["I didn't\ntrust him..."];
		tree[111] = [101];

		tree[120] = ["I didn't\nhave any\nmoney..."];
		tree[121] = ["#hera03#Aww! Well it was nice of you to stop in to visit him. ...And what matters is that you brought money today!"];
		tree[122] = ["#hera06#... ...You DID bring money, right?"];
		tree[123] = [150];

		tree[130] = ["Yeah! I\nbought some\nstuff"];
		tree[131] = ["#hera03#Hey, see! I knew he'd pull it off."];
		tree[132] = [150];

		tree[150] = ["#hera04#Well as long as he's working out, I'll try to get him to watch the store again soon. It's nice to get out from behind this desk."];

		if (!PlayerData.keclMale)
		{
			DialogTree.replace(tree, 10, "...He", "...She");
			DialogTree.replace(tree, 11, "...He", "...She");
			DialogTree.replace(tree, 12, "...He", "...She");

			DialogTree.replace(tree, 20, "...He", "...She");
			DialogTree.replace(tree, 21, "Ooooh he'll", "Ooooh she'll");

			DialogTree.replace(tree, 40, "...He", "...She");
			DialogTree.replace(tree, 41, "...He", "...She");

			DialogTree.replace(tree, 51, "away he", "away she");
			DialogTree.replace(tree, 52, "He seemed", "She seemed");
			DialogTree.replace(tree, 52, "from him", "from her");
			DialogTree.replace(tree, 53, "were his", "were her");

			DialogTree.replace(tree, 101, "Yeah, he's", "Yeah, she's");
			DialogTree.replace(tree, 101, "he? He's", "she? She's");
			DialogTree.replace(tree, 101, "of guy", "of girl");
			DialogTree.replace(tree, 110, "trust him", "trust her");

			DialogTree.replace(tree, 121, "visit him", "visit her");
			DialogTree.replace(tree, 131, "knew he'd", "knew she'd");
			DialogTree.replace(tree, 150, "as he's", "as she's");
			DialogTree.replace(tree, 150, "get him", "get her");
		}
	}

	static private function getBestVideo():PlayerData.PokeVideo
	{
		var bestVideo:PlayerData.PokeVideo = {name:"Abra", reward: -1, male:true};
		for (video in PlayerData.pokeVideos)
		{
			if (video.reward > bestVideo.reward)
			{
				bestVideo = video;
			}
		}
		return bestVideo;
	}

	/**
	 * Begin item descriptions
	 */
	public static function cornstarchCookies(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera04#Those are cornstarch cookies! They're good for lowering Pokemon's sex drives. Did you want to buy them for " + moneyString(itemPrice) + "?"];

		tree[100] = ["#hera02#Here you go! Did you want me to put some out for everyone?"];
		tree[101] = [105, 110, 115, 120];

		tree[105] = ["No"];
		tree[106] = ["#hera09#Aww phooey, well I'll leave them locked up with the rest of your items then! I suppose they'll stay fresher that way..."];

		tree[110] = ["Just a\nfew"];
		tree[111] = ["%pokemon-libido-3%"];
		tree[112] = ["#hera05#Great, I'll put a couple cookies out for people! Maybe I'll have one for myself too..."];

		tree[115] = ["A dozen\nor so"];
		tree[116] = ["%pokemon-libido-2%"];
		tree[117] = ["#hera05#Okay, I'll put out a bunch! You won't mind if I take a couple for myself too...?"];

		tree[120] = ["As many\nas you\ncan"];
		tree[121] = ["%pokemon-libido-1%"];
		tree[122] = ["#hera03#Goodness, I'll go ahead and put them all out then! I'll get a head start on a second batch for you, too."];
		tree[123] = ["#hera06#...Don't worry, I won't charge you extra money for those! Heracroosss!"];

		tree[300] = ["Lowering\nPokemon's\nsex drives?"];

		if (ItemDatabase.isMagnezonePresent())
		{
			tree[301] = ["#magn06#Fzzzzt- I believe I can explain this one, " + MagnDialog.HERA + "."];
			tree[302] = ["#hera06#Ehh...?"];
			tree[303] = ["#magn05#Mechanical Pokemon store their data on radially sectioned drives, or \"sect drives\" which are manipulated with two drive heads."];
			tree[304] = ["#magn10#However, some -bzzt-... newer models of electric Pokemon have issues with their sect drives being overly sensitive."];
			tree[305] = ["#magn06#This is a defect which resolves itself when the Pokemon matures, as the polymeric lubricant layer on the platter naturally thickens, reducing its sensitivity."];
			tree[306] = ["#magn04#...But as a short term fix, you can lower the drives a few millimeters to widen the gap between the platter and drive heads."];
			tree[307] = ["#magn01#Widening this gap reduces the platter's sensitivity, allowing the Pokemon to conduct... -bzzt-... prolonged strenuous activities without rest."];
			tree[308] = ["#magn05#...Does that sound accurate, " + MagnDialog.HERA + "? (Y/N)"];
			tree[309] = ["#hera10#Ehhhh... ...Eerily accurate, actually."];
			tree[310] = ["#hera05#So... How does that sound, <name>? Did you want to buy these sex drive lowering-"];
			tree[311] = ["#magn12#-Sect drive."];
			tree[312] = ["#hera06#Riiight. Did you want to buy the sect drive lowering cookies for " + moneyString(itemPrice) + "?"];
		}
		else
		{
			tree[301] = ["#hera05#Cornstarch cookies are SUPER tasty but we've noticed they also tamper with our libido! And the more cookies we eat the stronger the effect is."];
			tree[302] = ["#hera04#If we eat one or two they have a subtle effect on our sex drive. Metaphorically it's sort of like... leaving a can of soda out for a few hours."];
			tree[303] = ["#hera06#Like, it still SEEMS like soda? ...But it doesn't taste quite right and some of the fizz is gone. Like something's missing, you know?"];
			tree[304] = ["#hera10#And if we eat a whole bunch of cornstarch cookies, we can't get aroused whatsoever! Like leaving a can of soda out for a WEEK. Ha! Ha!"];
			tree[305] = ["#hera05#You can shake it and shake it but it's completely flat! Crazy, right?! I can't believe the effect is that strong for just a bunch of cookies."];
			tree[306] = ["#hera04#Anyways it's up to you how many cookies you put out. You can put out a whole bunch or none at all. So, did you want to buy them for " + moneyString(itemPrice) + "?"];
		}
	}

	public static function calculator(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera04#That's a graphing calculator! It can calculate some useful information when you're deciding on a 'rank chance'. Did you want to buy it for " + moneyString(itemPrice) + "?"];

		tree[100] = ["#hera02#Here you go! I'll go ahead and turn it on for you."];

		tree[300] = ["Useful\ninformation?"];
		tree[301] = ["#hera05#So I asked Abra how the ranking algorithm works, and he told me the details. It's basically a weighted average of your last few solves, factoring in difficulty."];
		tree[302] = ["#hera06#This graphing calculator has a program I wrote which factors in your current rank, the puzzle difficulty, your last few solves, and stuff like that..."];
		tree[303] = ["#hera04#That way on the Rank Chance screen, it'll give you information like \"You'll rank up if you solve this puzzle in 2:19!\" Isn't that nifty?"];
		tree[304] = [310, 320, 330, 340];

		tree[310] = ["You're a\nprogrammer?"];
		tree[311] = ["#hera00#Oh, a programmer? I'm not really... I mean, graphing calculators are a lot easier than, well..."];
		tree[312] = ["#hera06#...I just looked up everything on the internet and typed in a formula! It wasn't real programming, I think anybody could do it..."];
		tree[313] = ["#hera00#..."];
		tree[314] = ["#hera11#Aaaaa, stop looking at me that way! I'm not a dork!!"];
		tree[315] = [310, 320, 330, 340];

		tree[320] = ["\"Your last\nfew solves?\""];
		tree[321] = ["#hera05#Yeah, your rank is based on your last few solves! Abra told me the algorithm takes your last eight solves and averages them."];
		tree[322] = ["#hera10#Oh wait, I lied-- so actually it only averages FIVE of the last eight."];
		tree[323] = ["#hera06#I don't understand why, but the algorithm throws away the two puzzles you did worst on... and the one you did best on!"];
		tree[324] = ["#hera04#You'd have to ask Abra why he made it that way... I just wrote the program. Heracroosss!"];
		tree[325] = [310, 320, 330, 340];

		tree[330] = ["\"Factoring in\ndifficulty?\""];
		tree[331] = ["#hera05#You might have noticed how different puzzles give you different rewards when you solve them."];
		tree[332] = ["#hera04#That reward isn't random, it scales with the puzzle's difficulty. And, your rank scales with puzzle difficulty too!"];
		tree[333] = ["#hera02#Abra gave me the difficulty for each puzzle, it's stored in a big table in my program. So that part was pretty easy."];
		tree[334] = ["#hera06#I don't know how he calculated those difficulties though... They're different for every single puzzle!"];
		tree[335] = ["#hera04#And the difficulty numbers are pretty accurate, harder puzzles usually have higher numbers. But not always, it's a little weird."];
		tree[336] = [310, 320, 330, 340];

		tree[340] = ["Alright, I\nunderstand"];
		tree[341] = ["#hera05#Great! So did you want to buy it for " + moneyString(itemPrice) + "? It comes with the calculator AND the cool program I wrote!"];

		if (!PlayerData.abraMale)
		{
			DialogTree.replace(tree, 301, "and he", "and she");
			DialogTree.replace(tree, 324, "why he", "why she");
			DialogTree.replace(tree, 334, "how he", "how she");
		}
	}

	public static function hydrogenPeroxide(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera04#That's hydrogen peroxide! It calms down peg bugs when they drink it. Did you want to buy it for " + moneyString(itemPrice) + "?"];

		tree[100] = ["#hera02#Here you go! Did you want me to put some out for the little guys to drink?"];
		tree[101] = [110, 120, 130, 140];

		tree[110] = ["No"];
		tree[111] = ["#hera05#Well that's fine! I'll just leave the bottle with the rest of your stuff in case you change your mind."];

		tree[120] = ["Only a\nlittle"];
		tree[121] = ["%peg-activity-3%"];
		tree[122] = [142];

		tree[130] = ["A medium\namount"];
		tree[131] = ["%peg-activity-2%"];
		tree[132] = [142];

		tree[140] = ["A whole\nlot"];
		tree[141] = ["%peg-activity-1%"];
		tree[142] = ["#hera05#Alrighty! Now I THINK this stuff is safe, but you should probably watch for side effects, you know? Just in case. Heracroosss!!"];

		tree[300] = ["Calms them\ndown?"];
		tree[301] = ["#hera05#So we share our basement with those peg bug creatures... I'd call it an infestation if they weren't so gosh darn cute!"];
		tree[302] = ["#hera10#But there's a lot of weird stuff in our basement, and sometimes the bugs find their way into boxes of cleaning stuff or household chemicals..."];
		tree[303] = ["#hera06#One time I found several of them passed out around a container of hydrogen peroxide. I was worried at first, but-- it doesn't seem to hurt them!"];
		tree[304] = ["#hera04#It just messes with their head a little, makes them, gosh, a little slow. A little bit nappy."];
		tree[305] = ["#hera06#Maybe it can make those peg bugs easier to manage if they're moving around too much during puzzles? Gweh! Heheheh."];
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[306] = ["#magn13#Transporting, importing or selling narcotic substances is a direct violation of section 11-360 of the-"];
			tree[307] = ["#hera10#No, No! These aren't narcotics! They're more like... ineffective pesticides."];
			tree[308] = ["#magn13#..."];
			tree[309] = ["#hera06#Ineffective pesticides which also happen to have... some minor... questionable side effects?"];
			var line:Int = logInfraction(tree, 310);
			tree[line+0] = ["#hera06#Anyway <name>, did you want to buy that hydrogen peroxide for " + moneyString(itemPrice) + "?"];
		}
		else
		{
			tree[306] = ["#hera04#So did you want to buy that hydrogen peroxide for " + moneyString(itemPrice) + "?"];
		}
	}

	public static function logInfraction(tree:Array<Array<Object>>, line:Int):Int
	{
		var newLine:Int = line;
		if (ItemDatabase._magnezoneStatus == ItemDatabase.MagnezoneStatus.Angry || ItemDatabase._magnezoneStatus == ItemDatabase.MagnezoneStatus.Suspicious)
		{
			var penalty:Int = 0;
			if (ItemDatabase._magnezoneStatus == ItemDatabase.MagnezoneStatus.Angry)
			{
				penalty = FlxG.random.getObject([3500, 5500, 6500, 7500]);
			}
			else
			{
				penalty = FlxG.random.getObject([650, 950, 1150, 1350]);
			}
			var dots:String = FlxG.random.getObject(["...", ".....", "... ...", "... ... ...", "...... ... ...", ". . . . . . . . . . ."]);
			var warning:String = FlxG.random.getObject([
									 "Fines which remain unpaid after 30 days may result in additional civil penalties.",
									 "Repeated infractions may result in escalating penalties.",
									 "This fine is not deemed to include any fee assessed by the court under the profisions of 182-271.1.",
									 "You will receive a letter for your records which includes a court date. Failure to appear in court will result in additional citations.",
									 "You can elect to receive a physical or electronic copy of documents pertaining to the infraction.",
									 "The city accepts payments by cash, personal check, certified bank check, or money order."]);
			var heraResponse:String = FlxG.random.getObject([
										  "#hera08#Oof. Can't win 'em all.",
										  "#hera08#Sheesh, time to hike up my prices again.",
										  "#hera06#Ehh, see you in court I guess.",
										  "#hera06#Ehh, I can probably fight this thing.",
										  "#hera10#Where am I supposed to get that kind of money! I only get paid in these weird gems...",
										  "#hera12#Well, that's just great.",
										  "#hera12#Aww, phooey."]);
			tree[line++] = ["#magn12#...Interfacing with remote MXWEB misdemeanor database" + dots];
			tree[line++] = ["#magn13#You have been assessed a fine of ^" + commaSeparatedNumber(penalty) + ". " + warning];
			tree[line++] = [heraResponse];
		}
		else if (ItemDatabase._magnezoneStatus == ItemDatabase.MagnezoneStatus.Calm)
		{
			var dots:String = FlxG.random.getObject(["...", ".....", "... ...", "... ... ...", "...... ... ...", ". . . . . . . . . . ."]);
			//%20 = space
			//%0A = newline
			var error:String = FlxG.random.getObject([
								   "GET VALUE FROM AGENT FAILED: %0A CANNOT CONNECT TO 172.23.168.35:10050: [113]%20NO ROUTE TO HOST--",
								   "PKIX PATH BUILDING FAILED: HAXE.SECURITY.CERT.CERTPATHBUILDEREXCEPTION: %0A UNABLE TO FIND VALID CERTIFICATION PATH TO REQUESTED TARGET--",
								   "HAXE.COMWAVE.MXWEB.CLIENTEXCEPTION: %0A MXWEB: E175002: SSL HANDSHAKE FAILED: 'RECEIVED FATAL ALERT: HANDSHAKE_FAILURE'--",
								   "EXCEPTION DETAILS: SYSTEM.NET.WEBEXCEPTION: THE REMOTE SERVER RETURNED AN ERROR: (500) INTERNAL SERVER ERROR--",
								   "ERR-502%20BAD%20GATEWAY: THE PROXY SERVER %0A%0A RECEIVED AN INVALID RESPONSE FROM AN %0A%0A UPSTREAM SERVER--",
								   "CVC-PATTERN-VALID: %0A%0A VALUE 'MAGNEZONE%20' IS NOT FACET-VALID WITH RESPECT TO PATTERN '^[A-Z0-9]*$--'"
							   ]);
			tree[line++] = ["#magn12#...Interfacing with remote MXWEB misdemeanor database" + dots];
			tree[line++] = [FlxG.random.getObject(["#magn14#...", "#magn15#...", "#magn06#... ..."])];
			tree[line++] = ["#magn07#" + error];
			var heraResponse:String = FlxG.random.getObject([
										  "#hera02#Gweh! Heh! My lucky day I guess.",
										  "#hera02#Whoa! What are the odds. Gweh! Heh!",
										  "#hera03#Oh! ...Lucky me!",
										  "#hera03#Aww! ...Is that your way of tearing up a ticket?",
										  "#hera04#Wait, that seemed intentional. ...Magnezone?",
										  "#hera06#...Did you do that on purpose? ...Thank you!",
										  "#hera06#...Magnezone?",
										  "#hera12#Hey! ...No smoking in my shop!"]);
			tree[line++] = [heraResponse];
		}
		else if (ItemDatabase._magnezoneStatus == ItemDatabase.MagnezoneStatus.Happy)
		{
			var heraPronoun:String = PlayerData.heraMale ? "boy" : "girl";
			var dontDoItAgain:Array<String> = FlxG.random.getObject([
												  ["#magn05#...", "#magn14#...Don't do it again."],
												  ["#magn05#...", "#magn15#-Fzzzzt- I'll let you off with a warning this time."],
												  ["#magn04#...", "#magn15#The department is too understaffed to handle these kinds of minor infractions."],
												  ["#magn04#...", "#magn14#-INFRACTION DELETED-"],
												  ["#magn05#Well...", "#magn14#I suppose I can overlook this, given your positive impact on the community."],
												  ["#magn05#Well...", "#magn15#You seem remorseful. That's punishment enough."],
												  ["#magn04#Well...", "#magn15#I'll just pretend I didn't hear that."],
												  ["#magn04#Well...", "#magn14#...I suppose I can look the other way just this once."],
												  ["#magn04#... ...Bad " + heraPronoun + ".", "#magn12#...That's a very bad " + heraPronoun + ". You sit there and think about what you've done."],
												  ["#magn12#... ...You're a very naughty " + heraPronoun + ".", "#magn04#Very very naughty. Nobody will shop at your store if you keep being naughty. Shame on you."],
												  ["#magn12#... ...That was a very naughty thing you did. Very naughty. Look me in the eye and say you're sorry.", "#hera08#...I'm sorry, Magnezone...", "#magn12#Hmph."]
											  ]);
			for (s in dontDoItAgain)
			{
				tree[line++] = [s];
			}
		}
		return line;
	}

	public static function acetone(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera04#That's nail polish remover! Peg bugs love drinking that stuff... Did you want to buy it for " + moneyString(itemPrice) + "?"];

		tree[100] = ["#hera02#Here you go! Did you want me to put some out for the pegs to drink?"];
		tree[101] = [110, 120, 130, 140];

		tree[110] = ["No"];
		tree[111] = ["#hera05#Aww well, no biggie! I'll just leave this with the rest of your items in case you change your mind."];
		tree[112] = ["#hera02#I'm PRETTY sure this stuff doesn't hurt them... but it's not like I'm some expert on insect physiology or anything!"];
		tree[113] = [143];

		tree[120] = ["Only a\nlittle"];
		tree[121] = ["%peg-activity-5%"];
		tree[122] = [142];

		tree[130] = ["A medium\namount"];
		tree[131] = ["%peg-activity-6%"];
		tree[132] = [142];

		tree[140] = ["A whole\nlot"];
		tree[141] = ["%peg-activity-7%"];
		tree[142] = ["#hera03#Woo! Party time! I'm PRETTY sure this stuff doesn't hurt them... but it's not like I'm some expert on insect physiology or anything!"];
		tree[143] = ["#hera05#..."];
		tree[144] = ["#hera11#...Hey, don't give me that look!"];

		tree[300] = ["...They\ndrink it?"];
		tree[301] = ["#hera05#So those tiny bugs live in our basement, and SOMETIMES they get into things they really shouldn't be drinking. Tsk, it's like they don't even read warning labels!"];
		tree[302] = ["#hera10#One time I was coming down the stairs and I heard a bunch of frenzied clicking noises..."];
		tree[303] = ["#hera03#...When I turned the lights on I saw a bunch of them dancing wildly around a small container of nail polish remover!"];
		tree[304] = ["#hera06#I think the chemical in nail polish remover... Is it acetone?"];
		tree[305] = ["#hera04#I think acetone makes them act a little weird. Not dangerously weird, just like, maybe somewhere between red bull and catnip?"];
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[306] = ["#magn13#Administering consumable stimulants without the purview of the FDA is a direct violation of statute 12-373B of the-"];
			tree[307] = ["#hera10#Consumable stimulants? No, no, it's acetone! Acetone!! It's highly toxic, DEFINITELY not consumable..."];
			tree[308] = ["#magn13#..."];
			tree[309] = ["#hera12#You know, you're a real pain in the acetone."];
			var line:Int = logInfraction(tree, 310);
			tree[line+0] = ["#hera06#Anyway <name>, did you want to buy the nail polish remover for " + moneyString(itemPrice) + "?"];
		}
		else
		{
			tree[306] = ["#hera05#So did you want to buy the nail polish remover for " + moneyString(itemPrice) + "?"];
		}
	}

	public static function justCrackers(tree:Array<Array<Object>>, crackerClickCount:Int)
	{
		var responses:Array<String> = [
										  "#hera10#Umm really, those crackers aren't for sale. They're just my snack for while I'm watching the shop.",
										  "#hera10#Umm really, those crackers aren't for sale. They're just my snack for while I'm watching the shop.",
										  "#hera11#Stop poking at them! You're getting germs everywhere.",
										  "#hera12#Seriously I have cameras! I know where that hand's been. Get your filthy hand out of my food!",
										  "#hera12#...I have to eat those things, you know! It's unsanitary!",
										  "#hera12#Okay seriously! Let me explain how this works.",
										  "#hera13#WHY ARE YOU DOING THIS!!"
									  ];
		var response:String = responses[crackerClickCount];
		if (response == null)
		{
			response = "#hera13#...!";
		}
		tree[0] = [response];
		if (response == "#hera12#Okay seriously! Let me explain how this works.")
		{
			if (ItemDatabase.isMagnezonePresent())
			{
				tree[0] = ["#magn04#If " + MagnDialog.PLAYER + " gets a cracker, then " + MagnDialog.MAGN + " would like a cracker as well. Bzzt."];
				tree[1] = ["#hera13#NO! NO!! None of you can have crackers! They're my crackers! MINE!"];
				tree[2] = ["#hera12#Besides, you don't have a mouth! NEITHER OF YOU HAS A MOUTH! What do you want with a cracker!?"];
				tree[3] = ["#magn04#..."];
				tree[4] = ["#magn06#...Calculating... ... ..."];
				tree[5] = ["#magn05#..."];
				tree[6] = ["#magn15#I just think they're neat."];
			}
			else
			{
				tree[1] = ["#hera08#When you touch Grovyle's dick... and then you touch a cracker... and I EAT that cracker..."];
				tree[2] = ["#hera13#It's like you're putting his dick RIGHT in my mouth!"];
				tree[3] = ["#hera00#Hmm... well actually..."];
				tree[4] = ["#hera13#NO it's still gross and NOT VERY SEXY this way. STOP IT!!!"];
				tree[5] = ["#hera04#..."];
				tree[6] = ["#hera05#Also if you see Grovyle, tell him I said hi!"];

				if (!PlayerData.grovMale)
				{
					DialogTree.replace(tree, 1, "touch Grovyle's dick", "rub Grovyle's pussy");
					DialogTree.replace(tree, 2, "his dick", "her pussy");
					DialogTree.replace(tree, 6, "tell him", "tell her");
				}
			}
		}
	}

	public static function diamondPuzzleKey(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera04#That's a diamond puzzle key! It unlocks the hardest puzzles in the game. Did you want to buy it for " + moneyString(itemPrice) + "?"];

		tree[100] = ["%diamond-key-default%"];
		tree[101] = ["#hera02#Here you go! So diamond puzzles will now be mixed in with your 5-peg puzzles. And each time they come up, it's going to ask you whether you want to chicken out or not."];
		tree[102] = ["#hera05#But if you think you'll want to play every diamond puzzle that comes up, I can switch it so it doesn't even ask you!"];
		tree[103] = [111, 105];

		tree[105] = ["Yes, just\ngive me the\ndiamond\npuzzles"];
		tree[106] = ["%diamond-key-AlwaysYes%"];
		tree[107] = ["#hera03#Wow!! ...Well, good luck!"];

		tree[111] = ["No, I want\nit to ask"];
		tree[112] = ["%diamond-key-Ask%"];
		tree[113] = ["#hera03#Alright, good luck!"];

		tree[300] = ["...The hardest\npuzzles?"];
		tree[301] = ["#hera05#So if you've tried the hardest 5-peg puzzles and they're still too easy for you... This diamond key unlocks even harder puzzles than that!"];
		tree[302] = ["#hera03#Beating one of these puzzles gives you a diamond chest, which has CRAZY amounts of money -- we're talking ^1,000 or more!"];
		tree[303] = ["#hera07#But diamond puzzles are CRAZY hard. Grovyle was telling me some of them took him ten minutes or longer. And I mean, that's Grovyle! He's usually fast at these things."];
		tree[304] = ["#hera06#So anyway it's up to you, did you want to buy the diamond puzzle key for " + moneyString(itemPrice) + "?"];

		if (!PlayerData.grovMale)
		{
			DialogTree.replace(tree, 303, "took him", "took her");
			DialogTree.replace(tree, 303, "He's usually", "She's usually");
		}
	}

	public static function goldPuzzleKey(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera04#Oh, those are puzzle keys! They unlock harder puzzles. Did you want to buy them for " + moneyString(itemPrice) + "?"];

		tree[100] = ["%crackers0%"];
		tree[101] = ["%gold-key-default%"];
		tree[102] = ["#hera02#Here you go! So if there's a harder version of a puzzle, it's going to ask you each time whether you want to try it or not."];
		tree[103] = ["#hera05#But if you think you'll always want to try the harder version, I can switch it so it doesn't even ask you!"];
		tree[104] = [111, 106, 117];

		tree[106] = ["Yes, just\ngive me the\nhard puzzles"];
		tree[107] = ["%gold-key-AlwaysYes%"];
		tree[108] = ["#hera03#Alright, good luck!"];

		tree[111] = ["No, have\nit ask me"];
		tree[112] = ["%gold-key-Ask%"];
		tree[113] = ["#hera03#Alright, good luck!"];

		tree[117] = ["I want\na cracker"];
		tree[118] = ["#hera13#Those are MY crackers! MY CRACKERS! Not for customers!"];
		tree[119] = ["#hera12#You wouldn't even be able to eat them! Your mouth isn't anywhere NEAR here!"];
		tree[120] = [158, 193, 123];

		tree[123] = ["Squish\nit into\nmy hand,\nlike how\na puppet\neats"];
		tree[124] = ["#hera06#Okay fine, you DID just give me " + moneyString(itemPrice) + ", I guess I can spare ONE cracker..."];
		tree[125] = ["%crackers1%"];
		tree[126] = ["%crumbs1%"];
		tree[127] = ["#hera09#*smush* *crush* Great, now I have a mess on my counter."];
		tree[128] = [149, 131];

		tree[131] = ["I want\nanother one"];
		tree[132] = ["#hera12#Oh, you're still hungry? Gosh how am I not surprised."];
		tree[133] = ["#hera13#Oh I know why I'm not surprised, because of all the cracker crumbs which are ON MY COUNTER AND NOT IN YOUR STOMACH!!"];
		tree[134] = [137, 193];

		tree[137] = ["But I want\nanother one"];
		tree[138] = ["#hera06#Okay, I guess I can give you ONE more cracker. I have no idea what you're getting from this."];
		tree[139] = ["%crackers2%"];
		tree[140] = ["%crumbs2%"];
		tree[141] = ["#hera09#*smush* *crush* There, are you happy now?"];
		tree[142] = [145, 149];

		tree[145] = ["I want\nanother one"];
		tree[146] = ["#hera13#Stop making me waste food!!"];

		tree[149] = ["Thank\nyou"];
		tree[150] = ["#hera14#Hmph."];

		tree[158] = ["Just throw\nit to my\nmouth, I'll\ncatch it"];
		tree[159] = ["#hera04#Okay fine, you DID just give me " + moneyString(itemPrice) + ", I guess I can spare ONE cracker. Get ready, I'm throwing it as hard as I can!!"];
		tree[160] = ["%crackers1%"];
		tree[161] = ["#hera15#HUWAAHHHH!!!"];
		tree[162] = ["#hera05#Did you catch it? Did the cracker make it all the way to your universe?"];
		tree[163] = [170, 175, 166];

		tree[166] = ["Yes, and\nI caught it"];
		tree[167] = ["#hera02#Whoa! First try too. Heracrooooossss!!"];

		tree[170] = ["No, it didn't\nget here"];
		tree[171] = ["#hera04#Rats, I must have thrown it into the wrong universe. Okay, I'll try ONE more time. Get ready for it!"];
		tree[172] = [177];

		tree[175] = ["Yes, but\nit barely\nmissed my\nmouth"];
		tree[176] = ["#hera04#Aww radishes! Here, I'll try ONE more time. Get ready for it!"];
		tree[177] = ["%crackers2%"];
		tree[178] = ["#hera15#HUWAAHHHH!!!"];
		tree[179] = ["#hera05#Did you catch it? Did the cracker make it all the way to your universe?"];
		tree[180] = [190, 182, 186];

		tree[182] = ["Yes, and\nI caught it"];
		tree[183] = ["#hera10#Whoa! ...I didn't know I could do that."];
		tree[184] = ["#hera11#...I'm scared!"];

		tree[186] = ["No, don't\nworry about\nit"];
		tree[187] = ["#hera14#Hmph."];

		tree[190] = ["No, let's\ntry again"];
		tree[191] = ["#hera13#Stop making me waste food!!"];

		tree[193] = ["Alright,\nnevermind"];
		tree[194] = ["#hera14#Hmph."];

		tree[300] = ["...Harder\npuzzles?"];
		tree[301] = ["#hera05#So if you've tried 5-peg puzzles, and even THOSE are too easy... Well, this gold key unlocks harder versions of 5-peg puzzles which give you gold chests!"];
		tree[302] = ["#hera04#Every few 5-peg puzzles you solve, you'll be asked if you want to try for a gold chest... and if so, you'll get a harder puzzle worth way more money."];
		tree[303] = ["#hera05#The silver key does the same thing for 4-peg puzzles... It unlocks harder puzzles which give you, you guessed it, silver chests."];
		tree[304] = ["#hera03#Now if you're still sticking with 3-peg puzzles for now, don't worry! You can still buy the keys and give me money."];
		tree[305] = ["#hera02#They won't do anything useful... but I'll still get your money. Pretty cool right?"];
		tree[306] = ["#hera06#So what do you say, do you want to buy the puzzle keys for " + moneyString(itemPrice) + "?"];

		tree[400] = ["What about\nthe crackers?"];
		tree[401] = ["#hera10#Oh, those crackers aren't for sale, they're for me! They're my snack."];
		tree[402] = ["#hera04#I know what you're thinking, and no, you can't have one! ...They're employee-only crackers, just for Heracross!"];
		tree[403] = ["#hera12#...Hey, don't give me that look! You wouldn't be able to eat them anyways. What, do you want me to crumble them into your hand?"];
		tree[404] = ["#hera13#Your mouth is like a million light years away in the non-Pokemon universe. Get your own crackers!"];
		tree[405] = ["#hera06#So, ahem... How about JUST the puzzle keys for " + moneyString(itemPrice) + "? Without the crackers?"];
	}

	public static function romanticIncense(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera04#That's romantic incense! It puts everyone in well, a certain kind of mood. Did you want to buy it for " + moneyString(itemPrice) + "?"];

		tree[100] = ["#hera02#Here you go! Did you want me to light some for you?"];
		tree[101] = [110, 120, 130, 140];

		tree[110] = ["No"];
		tree[111] = ["#hera05#Aww well, no biggie! I'll just leave this with the rest of your items in case you change your mind."];
		tree[112] = ["#hera01#Sayyy if you know anybody who can cover the store, then maybe you and I could, umm... Well we could, ummmm..."];
		tree[113] = ["#hera00#...Oh nevermind!!"];

		tree[120] = ["Only a\nlittle"];
		tree[121] = ["%pokemon-libido-5%"];
		tree[122] = ["%pokemon-libboost-30%"];
		tree[123] = [143];

		tree[130] = ["A medium\namount"];
		tree[131] = ["%pokemon-libido-6%"];
		tree[132] = ["%pokemon-libboost-90%"];
		tree[133] = [143];

		tree[140] = ["A whole\nlot"];
		tree[141] = ["%pokemon-libido-7%"];
		tree[142] = ["%pokemon-libboost-210%"];
		tree[143] = ["#hera01#Woo! Sounds like you got a speeeecial little night ahead of you~"];
		tree[144] = ["#hera06#If you know anybody who can cover the store, then, umm... Maybe I'll join in later...? ...Maybe..."];
		tree[145] = ["#hera11#...Gah, why am I always stuck here when the good stuff's going on!?"];

		tree[300] = ["...A certain\nkind of mood?"];
		tree[301] = ["#hera02#So, this romantic incense will make everyone get horny way faster. You might wonder how you can tell if a Pokemon's horny or not! Well..."];
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[302] = ["#magn13#VIOLATION. VIOLATION. UNAUTHORIZED DISTRIBUTION OF APHRODISIAC."];
			tree[303] = ["#hera11#What!? No!! It doesn't even have any psychoactive effects... It's just a placebo!!"];
			tree[304] = ["#magn12#..."];
			tree[305] = ["#magn13#UNAUTHORIZED DISTRIBUTION OF PLACEBO."];
			var line:Int = logInfraction(tree, 306);
			tree[line+0] = ["#hera06#So uhh anyways <name>, did you want to buy the romantic incense for " + moneyString(itemPrice) + "?"];
		}
		else
		{
			tree[302] = ["#hera06#That's what all those Pokemon meters are on the main menu! When the meter's in the green, it means they're not very horny."];
			tree[303] = ["#hera05#But when it's in the red, that marks their peak fecundity! It means their sexual fluids will be more voluminous and, also you'll get more money!"];
			tree[304] = ["#hera11#...Agh, it doesn't sound romantic at ALL when I say it that way!! ...This is why guys like me need the incense..."];
			tree[305] = ["#hera06#So did you want to buy the romantic incense for " + moneyString(itemPrice) + "?"];

			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 304, "guys like me", "girls like me");
			}
		}
	}

	public static function marsSoftware(tree:Array<Array<Object>>, itemPrice:Int)
	{
		if (PlayerData.buizMale && !PlayerData.isAbraNice())
		{
			/*
			 * If they started in "all boy mode", and Abra still finds a need
			 * to lie to them...
			 */
			tree[0] = ["#hera05#Well, this is hmm... Umm, let me get Abra for this one."];
			tree[1] = ["#hera15#HEY ABRA!"];
			tree[2] = ["#hera04#..."];
			tree[3] = ["%enterabra%"];
			tree[4] = ["#abra05#Hmm? Oh yes. This is... A webcam filter I hacked together which makes some of us look like females."];
			tree[5] = ["#abra04#And if you don't like it, you can toggle it off to switch us back to being males again."];
			tree[6] = ["#hera06#...Err, so did you want to buy the software for " + moneyString(itemPrice) + "?"];

			tree[100] = ["#hera02#Here you go! I'll go ahead and put this with the rest of your items."];
			tree[101] = ["#hera06#Now you can... manipulate our genitals however you see fit. Gweh! Heh."];

			tree[300] = ["It makes you\nlook like\nfemales?"];
			tree[301] = ["#hera08#Umm... I guess it-"];
			tree[302] = ["#abra05#-Yes, our webcam uses an RGB-D sensor to generate a parametric model of genitals..."];
			tree[303] = ["#abra04#And once they're modelled in memory, we can manipulate our genitals in real-time!"];
			if (ItemDatabase.isMagnezonePresent())
			{
				tree[304] = ["#magn13#..."];
				tree[305] = ["#abra10#...Figuratively, Magnezone! FIGURATIVELY manipulate our genitals."];
				tree[306] = ["#magn06#... Bzzzt-"];
				tree[307] = ["#hera06#So would you like to buy the software for " + moneyString(itemPrice) + "?"];
			}
			else
			{
				tree[304] = ["#abra05#..."];
				tree[305] = ["#abra02#...Figuratively! FIGURATIVELY manipulate our genitals. Eh-hee-hee."];
				tree[306] = ["#hera06#So would you like to buy the software for " + moneyString(itemPrice) + "?"];
			}

			tree[400] = ["Why does it\nhave the\nmale symbol,\nif it's for\nfemales?"];
			tree[401] = ["#abra06#Oh! The male symbol, I see. Yes, that's not the male symbol, that's... the astrological sign for Mars!"];
			tree[402] = ["#abra09#Why Mars? Because, hmmm..."];
			tree[403] = ["#abra03#...Because the software mars our penises before covering them up with vaginas! Ee-heh-heh~"];
			tree[404] = ["#abra05#On second thought, it's because I carelessly drew the wrong symbol on the box."];
			tree[405] = ["#hera02#Wait, you confused the signs for \"male\" and \"female\"!?"];
			tree[406] = ["#abra12#...!"];
			tree[407] = ["#hera11#Uhh... nevermind! What am I talking about? ...Anyways <name>, did you want to buy the software for " + moneyString(itemPrice) + "?"];
		}
		else
		{
			tree[0] = ["#hera05#Well, this is hmm... Umm, let me get Abra for this one."];
			tree[1] = ["#hera15#HEY ABRA!"];
			tree[2] = ["#hera04#..."];
			tree[3] = ["%enterabra%"];
			tree[4] = ["#abra05#Hmm? Oh yes. This is... A webcam filter I hacked together which makes some of us look like males."];
			tree[5] = ["#abra04#And if you don't like it, you can toggle it off to switch us back to being females again."];
			tree[6] = ["#hera06#...Err, so did you want to buy the software for " + moneyString(itemPrice) + "?"];

			tree[100] = ["#hera02#Here you go! I'll go ahead and put this with the rest of your items."];
			tree[101] = ["#hera06#Now you can... manipulate our genitals however you see fit. Gweh! Heh."];

			tree[300] = ["It makes you\nlook like\nmales?"];
			tree[301] = ["#hera08#Umm... I guess it-"];
			tree[302] = ["#abra05#-Yes, our webcam uses an RGB-D sensor to generate a parametric model of genitals..."];
			tree[303] = ["#abra04#And once they're modelled in memory, we can manipulate our genitals in real-time!"];
			if (ItemDatabase.isMagnezonePresent())
			{
				tree[304] = ["#magn13#..."];
				tree[305] = ["#abra10#...Figuratively, Magnezone! FIGURATIVELY manipulate our genitals."];
				tree[306] = ["#magn06#... Bzzzt-"];
				tree[307] = ["#hera06#So would you like to buy the software for " + moneyString(itemPrice) + "?"];
			}
			else
			{
				tree[304] = ["#abra05#..."];
				tree[305] = ["#abra02#...Figuratively! FIGURATIVELY manipulate our genitals. Eh-hee-hee."];
				tree[306] = ["#hera06#So would you like to buy the software for " + moneyString(itemPrice) + "?"];
			}
		}
	}

	public static function venusSoftware(tree:Array<Array<Object>>, itemPrice:Int)
	{
		if (!PlayerData.grovMale && !PlayerData.isAbraNice())
		{
			/*
			 * if they started in "all girl mode", and Abra still finds a need
			 * to lie to them...
			 */
			tree[0] = ["#hera05#Well, this is hmm... Umm, let me get Abra for this one."];
			tree[1] = ["#hera15#HEY ABRA!"];
			tree[2] = ["#hera04#..."];
			tree[3] = ["%enterabra%"];
			tree[4] = ["#abra05#Hmm? Oh yes. This is a set of webcam filters I configured, which makes some of us look like males."];
			tree[5] = ["#abra04#And if you don't like it, you can toggle it off to switch us back to being females again."];
			tree[6] = ["#hera04#..."];
			tree[7] = ["#hera10#...Oh, is it my turn again? Alright <name>, did you want to buy the software for " + moneyString(itemPrice) + "?"];

			tree[100] = ["#hera02#Here you go! I'll stick the software with the rest of your items if you want to configure it."];
			tree[101] = ["#hera10#I'm kind of curious to take a peek myself... What kind of dick did Abra give herself?"];

			tree[300] = ["It makes you\nlook like\nmales?"];
			tree[301] = ["#hera06#Yeah, wait, how does that work? Does it look okay?"];
			tree[302] = ["#abra05#Well, our webcam uses pulse wave emissions to track the depth of each capture pixel. So it's not just storing a picture, but an entire 3D model."];
			tree[303] = ["#abra04#We can alter that model in memory to change our clothes, or physical appearance..."];
			tree[304] = ["#abra02#Or, yes, we can overlay a big floppy abra weiner where my vagina should be. Ee-heh-heh~"];
			if (ItemDatabase.isMagnezonePresent())
			{
				tree[305] = ["#magn04#If " + MagnDialog.ABRA + " gets to overlay a big floppy weiner, then " + MagnDialog.MAGN + " would like a floppy weiner as well."];
				tree[306] = ["#abra06#Well ehh... I can't believe I'm asking this but, exactly what type of weiner were you envisioning, Magnezone? ...Did you want an Abra weiner as well?"];
				tree[307] = ["#magn05#..."];
				tree[308] = ["#magn06#...Calculating... ... ..."];
				tree[309] = ["#magn04#No, I do not want an Abra weiner. I want something exceptionally long and girthy, suspended straight down like a cargo hook."];
				tree[310] = ["#magn05#A long girthy dangling weiner that makes " + MagnDialog.MAGN + " resemble the Seattle Space Needle. -bweeep-"];
				tree[311] = ["#abra06#..."];
				tree[312] = ["#abra05#Ehh... Okay. I'll see what I can do."];
				tree[313] = ["#magn03#Bzzz~"];
				tree[314] = ["#hera05#Well! Anyway uhh... So <name>, did you wanna buy the fancy weiner overlay software for " + moneyString(itemPrice) + "?"];
			}
			else
			{
				tree[305] = ["#hera06#..."];
				tree[306] = ["#abra03#Don't judge me! ...I just wanted to see what it looked like."];
				tree[307] = ["#hera05#Well! Anyway uhh... So <name>, did you wanna buy the fancy weiner overlay software for " + moneyString(itemPrice) + "?"];
			}

			tree[400] = ["Why does it\nhave the\nfemale symbol,\nif it's for\nmales?"];
			tree[401] = ["#abra06#Oh! The female symbol, I see. Yes, that's not the female symbol, that's... the operating system logo!"];
			tree[402] = ["#abra03#Yes, yes, if you turn your head it's clearly an O and an X... for OS X. The webcam filters will only work on OS X."];
			tree[403] = ["#abra05#On second thought, it's because I carelessly drew the wrong symbol on the box."];
			tree[404] = ["#hera02#Wait, you confused the signs for \"male\" and \"female\"!?"];
			tree[405] = ["#abra12#...!"];
			tree[406] = ["#hera11#Uhh... nevermind! What am I talking about? ...Anyways <name>, did you want to buy the software for " + moneyString(itemPrice) + "?"];
		}
		else
		{
			tree[0] = ["#hera05#Well, this is hmm... Umm, let me get Abra for this one."];
			tree[1] = ["#hera15#HEY ABRA!"];
			tree[2] = ["#hera04#..."];
			tree[3] = ["%enterabra%"];
			tree[4] = ["#abra05#Hmm? Oh yes. This is a set of webcam filters I configured, which makes some of us look like females."];
			tree[5] = ["#abra04#And if you don't like it, you can toggle it off to switch us back to being males again."];
			tree[6] = ["#hera04#..."];
			tree[7] = ["#hera10#...Oh, is it my turn again? Alright <name>, did you want to buy the software for " + moneyString(itemPrice) + "?"];

			tree[100] = ["#hera02#Here you go! I'll stick the software with the rest of your items if you want to configure it."];

			tree[300] = ["It makes you\nlook like\nfemales?"];
			tree[301] = ["#hera06#Yeah, wait, how does that work? Does it look okay?"];
			tree[302] = ["#abra05#Well, our webcam uses pulse wave emissions to track the depth of each capture pixel. So it's not just storing a picture, but an entire 3D model."];
			tree[303] = ["#abra04#We can alter that model in memory to change our clothes, or physical appearance..."];
			tree[304] = ["#abra02#Or, yes, we can overlay an enormous gaping charizard vagina where my face should be. Ee-heh-heh~"];
			if (ItemDatabase.isMagnezonePresent())
			{
				tree[305] = ["#magn14#Intriguing. Fzzz- Can you also add extra clothing, such as hats? Mountains and mountains of hats? (Y/N)"];
				tree[306] = ["#magn15#Is it possible to remove genitals entirely, leaving only a featureless smooth surface? (Y/N)"];
				tree[307] = ["#abra08#..."];
				tree[308] = ["#abra09#Magnezone, I don't think you're grasping this software's intended purpose."];
				tree[309] = ["#magn09#-sad beep-"];
				tree[310] = ["#hera06#Well! Anyway uhh... So <name>, did you wanna buy the fancy charizard vagina software for " + moneyString(itemPrice) + "?"];
			}
			else
			{
				tree[305] = ["#hera07#..."];
				tree[306] = ["#abra03#Don't judge me! ...I just wanted to see what it looked like."];
				tree[307] = ["#hera06#Well! Anyway uhh... So <name>, did you wanna buy the fancy charizard vagina software for " + moneyString(itemPrice) + "?"];
			}
		}
	}

	public static function magneticDeskToy(tree:Array<Array<Object>>, itemPrice:Int)
	{
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[0] = ["#hera06#That's a magnetic desk toy! It would make a good gift for... nobody in particular. Did you want to buy it for " + moneyString(itemPrice) + "?"];

			tree[100] = ["%gift-magn%"];
			tree[101] = ["#hera02#Here you go! I'll give it to... somebody... as soon as I get a chance to gift wrap it."];

			tree[300] = ["...Nobody\nin particular?"];
			tree[301] = ["#hera05#Well, you know! If there's, ehhh... somebody... you want around more often, well, a nice gift might send them the right kind of message."];
			tree[302] = ["#magn12#" + MagnDialog.MAGN + " wants that. Sell it to. Sell it to " + MagnDialog.MAGN + ". Does it require batteries."];
			tree[303] = ["#hera12#Please Magnezone, I'm with a customer! ...Now anyways, I'll gift wrap it and-"];
			tree[304] = ["#magn13#Is the base the only magnetic part. What kind of shapes can you make. " + MagnDialog.MAGN + " wants it. " +MagnDialog.MAGN + " wants to purchase it. " + MagnDialog.MAGN + " will give you ^1,000."];
			tree[305] = ["#hera06#Would you just shush! ...And no real money, gems only! C'mon Magnezone, you of all people should know better."];
			tree[306] = ["#hera04#The price is " + moneyString(itemPrice) + ". That's " + commaSeparatedNumber(itemPrice) + " gems. Do you have " + commaSeparatedNumber(itemPrice) + " gems?"];
			tree[307] = ["#magn10#...But... ... ...But..."];
			tree[308] = ["#hera05#How about you <name>, do you have " + commaSeparatedNumber(itemPrice) + " gems?"];
		}
		else
		{
			tree[0] = ["#hera04#That's a magnetic desk toy! It would make a good gift for Magnezone. Did you want to buy it for " + moneyString(itemPrice) + "?"];

			tree[100] = ["%gift-magn%"];
			tree[101] = ["#hera02#Here you go! I'll gift wrap it and give it to Magnezone next time I see him."];

			tree[300] = ["...For\nMagnezone?"];
			tree[301] = ["#hera05#Well sure! If you enjoy Magnezone's company... And you want him around more often... Well, a nice gift like this might send the right kind of message!"];
			tree[302] = ["#hera03#Plus you know, the more time he spends hanging around with you, the less time he'll at my shop doling out fines. Gweh-heh-heh!"];
			tree[303] = ["#hera04#I'll also find a nice box for it, gift wrap it, and put a card that says \"<name>\" on it. That's all included in the " + moneyString(itemPrice) + "."];
			tree[304] = ["#hera05#So how about it, did you want to buy the magnetic desk toy for " + moneyString(itemPrice) + "?"];

			if (!PlayerData.magnMale)
			{
				DialogTree.replace(tree, 101, "see him", "see her");
				DialogTree.replace(tree, 301, "want him", "want her");
				DialogTree.replace(tree, 302, "time he", "time she");
			}
		}
	}

	public static function smallPurpleBeads(tree:Array<Array<Object>>, itemPrice:Int)
	{
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[0] = ["#hera04#That's a giant pile of ehhh... Mardi Gras beads! Did you want to buy them for " + moneyString(itemPrice) + "?"];

			tree[100] = ["#hera05#Here you go! I'll have my cameras rolling, so try to put on a good show."];
			tree[101] = ["#magn04#A good Mardi Gras show."];
			tree[102] = ["#hera02#... ...Yes! ...A good Mardi Gras show. Gweh-heh-heh!"];

			tree[300] = ["...Mardi Gras\nbeads?"];
			tree[301] = ["#hera05#Yeah! Mardi Gras is an annual celebration where people parade around wearing cheap jewelry, like these plastic beads!"];
			tree[302] = ["#hera02#...They DEFINITELY don't insert these beads into any particular orifices. Nope! They just wear them around like normal. Gweh-heh-heh."];
			tree[303] = ["#magn06#-fzzzzzt- This jewelry seems markedly drab. Aren't Mardi Gras beads meant to be colorful?"];
			tree[304] = ["#hera04#Well, errrr... They look better when you're actually wearing them!"];
			tree[305] = ["#hera05#Let me show you- I'll just drape some of these around my neck, so you can see how they..."];
			tree[306] = ["#hera08#..."];
			tree[307] = ["#hera11#... ...On second thought I... I really don't want to do that."];
			tree[308] = ["#hera06#But anyway <name>, did you want to buy the anal- ...err... An-nual... Annual celebration beads for " + moneyString(itemPrice) + "?"];
		}
		else
		{
			tree[0] = ["#hera06#That's a giant pile of anal beads! Did you want to buy them for " + moneyString(itemPrice) + "?"];

			tree[100] = ["#hera02#Here you go! I'll have my cameras rolling, so try to put on a good show."];

			tree[300] = ["...Anal\nbeads?"];
			tree[301] = ["#hera04#Let's see, so these are the... \"Eternus Maximus Pleasure Beads from ButtStuffInc\". They look a little fancier than most anal beads, let's see. Hmm..."];
			tree[302] = ["#hera06#Okay so... The beads themselves vary in size from pea size to ehhh... capital pea size."];
			tree[303] = ["#hera09#Also, they're a little bit see-through, just in case ehh... Just in case there's something you want to see... that's through? Eegh."];
			tree[304] = ["#hera10#...Sorry! This isn't my best pitch, I know. I'm not really into anal beads."];
			tree[305] = ["#hera11#I prefer when things go INTO a butt. I know! I know. I'm a total prude."];
			tree[306] = ["#hera06#Abra's way more into these kinds of toys than I am. Maybe you could talk to him?"];
			tree[307] = ["#hera05#But still... Did you maybe want to buy the giant pile of anal beads for " + moneyString(itemPrice) + "? I mean, that's like ^1 per bead!"];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 306, "to him", "to her");
			}
		}
	}

	public static function smallGreyBeads(tree:Array<Array<Object>>, itemPrice:Int)
	{
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[0] = ["#hera04#That's the gwuhh... ... ...jump rope? The beaded jump rope! ...Did you want to buy it for " + moneyString(itemPrice) + "?"];

			tree[100] = ["#hera02#Here, have fun! Gweh-heh-heh~"];
			tree[101] = ["#magn12#Fun!? ..." + MagnDialog.MAGN + " wants to see what possible use " + MagnDialog.PLAYER + " finds for that jump rope."];
			tree[102] = ["#hera06#... ...Magnezone, I'm pretty sure you DON'T want to see that."];

			tree[300] = ["...Beaded\njump rope?"];
			tree[301] = ["#magn06#Why would " + MagnDialog.PLAYER + " purchase a jump rope? He can't use it with only one free hand..."];
			tree[302] = ["#hera10#Oh uhh, well... Mmmmm..."];
			tree[303] = ["#hera06#Okay, well bear with me here... Maybe <name> could hold onto one end of this rope, and insert the other end into, hmm..."];
			tree[304] = ["#hera03#...Some kind of... tight rigid hole that's just the right size for this rope. That would do!"];
			tree[305] = ["#magn12#... ...Well that's a ludicrous proposition. Just where is " + MagnDialog.PLAYER + " going to find this hypothetical... magic hole!?"];
			tree[306] = ["#hera04#Well, Abra told me to stock this particular item... so I suppose the onus is on Abra to find <name> a suitable hole."];
			tree[307] = ["#hera05#Okay <name>? It's Abra's onus to find a hole. His onus! ... ...Go poke Abra about his onus."];
			tree[308] = ["#magn14#...?"];
			tree[309] = ["#hera06#A-hem, anyway <name>, did you want to buy the ehhh... beaded jump rope... for " + moneyString(itemPrice) + "?"];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 301, "He can't", "She can't");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 301, "He can't", "They can't");
			}
			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 307, "His onus", "Her onus");
				DialogTree.replace(tree, 307, "his onus", "her onus");
			}
		}
		else
		{
			tree[0] = ["#hera06#That's a giant pile of anal beads! Did you want to buy them for " + moneyString(itemPrice) + "?"];

			tree[100] = ["#hera02#Here you go!"];

			tree[300] = ["...Anal beads?"];
			tree[301] = ["#hera05#Oh sure. Have you used anal beads before? Well. You see this end that looks like a tiny handle? So you grab that end with your thumb and forefinger..."];
			tree[302] = ["#hera03#And then... You swing the beads over your head like a helicopter! Around and around in a circle. The faster, the better!"];
			tree[303] = ["#hera02#It's great exercise! ...Really works the anus."];
			tree[304] = ["#hera06#... ... ..."];
			tree[305] = ["#hera10#Okay, to be honest I've never messed around with anal beads, I have no idea how they work."];
			tree[306] = ["#hera06#But you know, Abra might have some ideas. It was his idea to stock these in the first place. Maybe you can ask him?"];
			tree[307] = ["#hera04#Anyways... Did you maybe want to buy the giant pile of anal beads for " + moneyString(itemPrice) + "?"];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 306, "was his", "was her");
				DialogTree.replace(tree, 306, "ask him", "ask her");
			}
		}
	}

	public static function vibrator(tree:Array<Array<Object>>, itemPrice:Int)
	{
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[0] = ["#hera06#That's a, ehh... gwuhh... Well that's vibrating Venonat. It's a children's toy! Did you want it for " + moneyString(itemPrice) + "?"];

			tree[100] = ["#hera02#Ooh, have fun!"];

			tree[300] = ["A vibrating\ntoy?"];
			tree[301] = ["#hera04#Yeah a toy, you know! It vibrates and it's... it's silly!"];
			tree[302] = ["#hera06#The children, well... Gwehhhh... They turn it on and then they... they rub its silly feelers on th-"];
			tree[303] = ["#magn07#--ERR-1085%20INFRACTION%20OVERFLOW... CALL TRACE [<C0156C24>] COMPUTE_INFRACTION_SEVERITY (1.845E19 TOO LARGE FOR DATA TYPE INT)"];
			tree[304] = ["#hera04#...?"];
			tree[305] = ["#magn12#... ..."+MagnDialog.HERA+". Whatever you were talking about was so illegal that it crashed my kernel. ...Please refrain from discussing such matters again."];
			tree[306] = ["#hera10#But I didn't mean-"];
			tree[307] = ["#magn13#...!"];
			tree[308] = ["#hera11#-Gweh! ...So anywayyyyys.... Did you want the... vibrating toy for " + moneyString(itemPrice) + "?"];

			tree[450] = ["A vibrating\ntoy?"];
			tree[451] = ["#hera06#Yeah it's umm..."];
			tree[452] = ["#magn12#..."];
			tree[453] = ["#hera04#...It's an... adult toy? ...It's an adult toy! An adult toy for adults."];
			tree[454] = ["#hera10#Ack, no, wait!"];
			var line:Int = logInfraction(tree, 455);
			tree[line+0] = ["#hera06#Anyway <name>, did you want the vibrating toy for " + moneyString(itemPrice) + "?"];
		}
		else
		{
			tree[0] = ["#hera01#Oh that's the \"Bug Buzz\" vibrator! Trust meeeeee, you WANT this vibrator. How does " + moneyString(itemPrice) + " sound?"];

			tree[100] = ["#hera02#Ooh, have fun!"];

			tree[300] = ["...Bug Buzz\nvibrator?"];
			tree[301] = ["#hera05#So vibrators don't have to just be for taking care of yourself, you know!"];
			tree[302] = ["#hera04#Like this Bug Buzz vibrator has a handheld remote control, so it's great for two people to experiment with."];
			tree[303] = ["#hera05#One of you gets to be the test subject, while the other one takes the controls. Ooh, or you could role play..."];
			tree[304] = ["#hera06#Like ehh... ..."];
			tree[305] = ["#hera03#...One of you could be a hostile witness, and the other's conducting the worst cross-examination ever?"];
			tree[306] = ["#hera15#\"How long have you known the plaintiff? Answer me!\" \"Gwehh, you'll never vibrate it out of me! Never!\""];
			tree[307] = ["#hera02#Gweheheheh! ... ...Oh! But yes, it's got a lot of little buttons and settings too. Maybe you can figure out everybody's favorite!"];
			tree[308] = ["#hera04#So what do you think, do you want to try out the Bug Buzz vibrator for " + moneyString(itemPrice) + "?"];
		}
	}

	public static function largeGlassBeads(tree:Array<Array<Object>>, itemPrice:Int)
	{
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[0] = ["#hera06#That's a, gwuhhh.... clicky clacky desk toy! One of those... what are they called? You know! It's uhhh... " + moneyString(itemPrice) + "! Did you want it?"];

			tree[100] = ["#hera02#Here you are! Have fun~"];

			tree[300] = ["Newton's\nCradle?"];
			tree[301] = ["#hera05#Yeah! Newton's Cradle! They uhh, you know! You pick up one end, and they clack together..."];
			tree[302] = ["#magn06#...Analyzing... ... ..." + MagnDialog.HERA + ", that is most certainly not a &lt;Newton's Cradle&gt;."];
			tree[303] = ["#magn12#That item is absent from " + MagnDialog.MAGN + "'s optical recognition database. Based on your hastily constructed lie I ascertain it is some form of contraband."];
			tree[304] = ["#hera08#Oh now I remember! It's ehhh... ...a beginner abacus! You see, you slide the beads back and forth and... it helps you count the errr..."];
			tree[305] = ["#magn06#... ..."];
			tree[306] = ["#hera10#No wait! It's a giant glass dildo. You see, the narrow goes into the..."];
			tree[307] = ["#hera11#Ack, w-wait!!! Let me start over!"];
			var line:Int = logInfraction(tree, 308);
			tree[line+0] = ["#hera06#Well anyway <name>, did you want to buy the ehhh... whatever this thing is... for " + moneyString(itemPrice) + "?"];
		}
		else
		{
			tree[0] = ["#hera02#Those are some hujongous anal beads! ...Did you want to buy them for " + moneyString(itemPrice) + "?"];

			tree[100] = ["#hera03#Here you are! Have fun~"];

			tree[300] = ["Hujongous?"];
			tree[301] = ["#hera06#Let's see, what brand are these? \"Pokefantasy Glass Cannon Beads XXXXXXXL...\""];
			tree[302] = ["#hera07#Oh my land, that's a lot of Xs! ...But that explains it, I mean just look at these things! They're bigger than my fist..."];
			tree[303] = ["#hera04#I don't even think you can call them \"anal beads\" once they're this size, they're like... anal boulders! ... ...Anal meteorites!!"];
			tree[304] = ["#hera05#Anyways... Did you want to buy the hujongous anal meteorites for " + moneyString(itemPrice) + "?"];
		}
	}

	public static function largeGreyBeads(tree:Array<Array<Object>>, itemPrice:Int)
	{
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[0] = ["#hera06#That's the ehhh... tandem... bowling kit! Yeah! That's what it is. ...Did you want to buy it for " + moneyString(itemPrice) + "?"];

			tree[100] = ["#hera02#Here you go!"];
			tree[101] = ["#magn05#Bowl responsibly, " + MagnDialog.PLAYER + ". Remember, you should never reach your hand into the &lt;Ball Return&gt;."];
			tree[102] = ["#hera01#Aw! But that sounds kind of fun."];
			tree[103] = ["#magn12#...!"];

			tree[300] = ["Tandem\nbowling?"];
			tree[301] = ["#hera03#Yeah, like... with another person! See, these bowling balls are all attached with a string so... they're really clumsy to throw by yourself!"];
			tree[302] = ["#hera06#...But, I guess you get a friend to throw them with you and... It's got sort of a three-legged-race sort of appeal. ...Doesn't that sound fun?"];
			tree[303] = ["#magn06#-bzzt- That sounds like an utter waste of time and energy."];
			if (PlayerData.hasMet("rhyd"))
			{
				tree[304] = ["#hera05#Hmm, well you know who loves utter wastes of time and energy? ...Rhydon does! <name>, I think this toy is just perfect for him."];
				tree[305] = ["#magn04#Indeed. " + MagnDialog.RHYD + " revealed to me that he pays for a gym membership, and exercises six days a week."];
				tree[306] = ["#magn15#...He wastes his money on a membership, so that he can waste his time wasting his energy. A wasteful toy like this would be right up " + MagnDialog.RHYD + "'s alley."];
				tree[307] = ["#hera03#Gweh-heh-heh! Why that's a great way of putting it. <name>, this toy would be right up Rhydon's alley."];
				tree[308] = ["#hera02#I mean, RIGHT up his alley. There's no way it would go up anybody else's alley. But with Rhydon, you might have a chance."];
				tree[309] = ["#hera06#...So what do you think <name>? Do you want to get this tandem bowling kit so you can try it out with Rhydon? It's only " + moneyString(itemPrice) + "!"];

				if (!PlayerData.rhydMale)
				{
					DialogTree.replace(tree, 304, "for him", "for her");
					DialogTree.replace(tree, 305, "that he", "that she");
					DialogTree.replace(tree, 306, "He wastes", "She wastes");
					DialogTree.replace(tree, 306, "that he", "that she");
					DialogTree.replace(tree, 306, "waste his", "waste her");
					DialogTree.replace(tree, 308, "up his", "up her");
				}
			}
			else
			{
				tree[304] = ["#hera05#Hmm, well you know who loves utter wastes of time and energy?"];
				tree[305] = ["#magn04#...?"];
				tree[306] = ["#hera04#Actually, nevermind! I don't want to spoil the surprise."];
				tree[307] = ["#hera05#...So what do you think <name>? Do you want to get this, ehhh.... tandem bowling kit, to play with... somebody? It's only " + moneyString(itemPrice) + "!"];
			}
		}
		else
		{
			tree[0] = ["#hera05#Those are some absolutely terrifying anal beads! ...Did you want to buy them for " + moneyString(itemPrice) + "?"];

			tree[100] = ["#hera06#Oh, gosh! ...Well, try not to hurt anyone!"];

			tree[300] = ["Terrifying\nanal beads?"];
			tree[301] = ["#hera06#So traditionally, anal beads are err, some kind of a sex thing. Stick 'em in, pull 'em out, something like that. But looking at these, well..."];
			tree[302] = ["#hera04#These look like they're intended to have more of a scarecrow effect. You know, maybe ward away evil anuses? That's my best guess anyways."];
			tree[303] = ["#hera10#Just... just LOOK at them! You show up somewhere with these beads and... anuses will LEAVE YOU ALONE. They'll scatter like cockroaches!"];
			tree[304] = ["#hera09#..."];
			tree[305] = ["#hera08#I'm sorry! I'm not doing the best job selling these am I? I just, err... ..."];
			tree[306] = ["#hera11#... ...Well, anal beads are already a little gross. and I just don't understand why anybody would want something of this SIZE! ...But anyways..."];
			tree[307] = ["#hera05#Did you want to buy the terrifying anal beads? ...Just for the novelty? I mean they're only " + moneyString(itemPrice) + "!"];
		}
	}

	public static function fruitBugs(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera04#Oh, those are fruity bugs! They'll make puzzle solving more fun and colorful. Did you want to buy them for " + moneyString(itemPrice) + "?"];

		tree[100] = ["#hera02#Okay neat! I'll send a couple bugs over with your items so you can see what they look like."];
		tree[101] = ["#hera05#You can disable different colors there too. Just in case having two green bugs confuses you or something!"];

		tree[300] = ["Fun and\ncolorful?"];
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[301] = ["#hera05#Sure! These new bugs won't make the puzzles harder or anything, they'll just add a little extra variety."];
			tree[302] = ["#magn06#\"New bugs?\" ...So now you're operating a pet store too? Hmm."];
			tree[303] = ["#hera09#Well, I'm not selling them as pets! <name> doesn't KEEP them, he just, you know, uses them for awhile!"];
			tree[304] = ["#magn12#..."];
			tree[305] = ["#hera10#You know, what's that thing called where you pay someone to like... use them for awhile?"];
			tree[306] = ["#hera11#... ...No, not like, not prostitution! ...The other thing! The thing that won't get me in trouble, what's that thing called? Gahh!"];
			tree[307] = ["#magn15#-bzzt- You seem to be doing your best to incriminate yourself... despite the fact that you're in fact doing nothing unlawful."];
			tree[308] = ["#magn04#...Sadly, " + MagnDialog.MAGN + " cannot issue you a citation for being an idiot."];
			tree[309] = ["#hera06#Oh. Well that's a relief."];
			tree[310] = ["#hera04#Ehh, so anyways.... What do you think <name>, do you want to make your puzzles more fun and colorful for " + moneyString(itemPrice) + "?"];

			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 303, "them, he", "them, she");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 303, "them, he", "them, they");
			}
		}
		else
		{
			tree[301] = ["#hera05#Sure! These new bugs won't make the puzzles harder or anything, they'll just add a little extra variety."];
			tree[302] = ["#hera06#I mean gosh, don't you get bored of seeing the same six bugs every puzzle? So every once in awhile, these new colors will be mixed in."];
			tree[303] = ["#hera04#What do you think, do you want to make your puzzles more fun and colorful for " + moneyString(itemPrice) + "?"];
		}
	}

	public static function spookyBugs(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera04#Oh, those are spooky bugs! They'll make puzzles way spookier. Did you want to buy them for " + moneyString(itemPrice) + "?"];

		tree[100] = ["#hera02#Alright! I'll send a few bugs to sit with your items so you can see what they look like."];
		tree[101] = ["#hera05#You can also go there to turn off different colors, just in case having two blue bugs confuses you or something!"];

		tree[300] = ["Way\nspookier?"];
		tree[301] = ["#hera06#Ooh, certainly! If you're growing accustomed to looking at the same bright cheery colors in your puzzles, these little guys will spook things up."];
		tree[302] = ["#hera10#Just look at those glowing red eyes, that pitch black complexion. Oooh! That one's up to something!"];
		tree[303] = ["#hera09#And that blue one has a certain mystique about him as well. He looks like some sort of creepy... crawly... night thing! Oh my days!"];
		tree[304] = ["#hera06#Of course if they're too spooky for you, you can always turn them off by going into your items later. ...If you dare!"];
		tree[305] = ["#hera04#So what do you think, do you want to make your puzzles way spookier for a mere " + moneyString(itemPrice) + "?"];
	}

	public static function marshmallowBugs(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera06#Oh, those are marshmallow bugs! They'll make your puzzles more errr, marshmallowy. Did you want to buy them for " + moneyString(itemPrice) + "?"];

		tree[100] = ["#hera02#Ooh great! I'll send a couple bugs over with your items so you can see what they look like."];
		tree[101] = ["#hera05#You can also go there to turn off certain colors, just in case you have trouble telling them apart!"];

		tree[300] = ["Marshmallowy?"];
		tree[301] = ["#hera03#Well of course they're not ACTUAL marshmallows. But... Don't they look sort of like little cereal marshmallows? I can't get enough of these little guys!"];
		tree[302] = ["#hera08#I wonder if they... TASTE like marshmallows? I... I kind of want to lick one and find out... But..."];
		tree[303] = ["#hera09#But of course you should NEVER lick a bug without their permission! That's just rude."];
		tree[304] = ["#hera06#...So anyways, did you want to purchase the marshmallowy bugs for " + moneyString(itemPrice) + "?"];

		tree[450] = ["Can I\nlick you,\nHeracross?"];
		tree[451] = ["#hera01#Oh boy! Can you ever. Gweh-heh-heh~"];
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[452] = ["#magn12#..." + MagnDialog.MAGN + " presumes the licking of " + MagnDialog.HERA + " is contingent on the aforementioned monetary exchange, is that correct? (Y/N)"];
			tree[453] = ["#hera10#I... wait what? We weren't being serious, that was just friendly banter! Friendly banter!"];
			var line:Int = logInfraction(tree, 454);
			tree[line+0] = ["#hera06#...So anyways <name>, did you want to purchase the marshmallowy bugs for " + moneyString(itemPrice) + "?"];
		}
		else
		{
			tree[452] = ["#hera03#Wait a moment, you don't even have a tongue you big goofball! What are you going to kiss me with? ...Your pinky finger?"];
			tree[453] = ["#hera06#...So anyways, did you want to purchase the marshmallowy bugs for " + moneyString(itemPrice) + "?"];
		}
	}

	public static function retroPie(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera05#Oh, that's a tiny computer that you can hook up to a TV to play old video games. It would make a nice gift! Did you want to buy it for " + moneyString(itemPrice) + "?"];

		tree[100] = ["%gift-kecl%"];
		tree[101] = ["#hera00#Ah! <name>!! You're the best~"];
		tree[102] = ["#hera01#I'm going to gift wrap this for him right now, okay? I'll make sure Kecleon knows it's from both of us!"];

		tree[300] = ["A nice\ngift?"];
		tree[301] = ["#hera06#So as much as I enjoy our time together <name>, I can't abandon the store or..."];
		tree[302] = ["#hera10#...Well, the whole reason Abra brought me here was to peddle this merchandise! ...He might kick me out if I started neglecting the shop."];
		tree[303] = ["#hera04#Kecleon doesn't mind watching this place every once in awhile but... Well, he'd rather watch Smeargle if you know what I mean! Gweh-heheh~"];
		tree[304] = ["#hera05#But I was thinking... Maybe he'd be willing to cover for me more often if we butter him up a little!! So I bought this really nice gift..."];
		tree[305] = ["#hera06#It's a retro gaming system that he and Smeargle can play together! But I think it would be more meaningful if it was a present from both of us, so... Well..."];

		if (!PlayerData.keclMale)
		{
			DialogTree.replace(tree, 102, "for him", "for her");
			DialogTree.replace(tree, 303, "Well, he'd", "Well, she'd");
			DialogTree.replace(tree, 304, "Maybe he'd", "Maybe she'd");
			DialogTree.replace(tree, 304, "butter him", "butter her");
			DialogTree.replace(tree, 305, "that he", "that she");
		}

		if (!PlayerData.abraMale)
		{
			DialogTree.replace(tree, 302, "...He might", "...She might");
		}

		if (ItemDatabase.isMagnezonePresent())
		{
			tree[306] = ["#hera11#...I know! ...I know I'm asking for a lot of money but it was expensive! And a lot of work too!"];
			tree[307] = ["#hera08#I had to run all these Linux commands, and download all these ROMs, and-"];
			tree[308] = ["#magn12#ROMs!? ...This gaming device is pre-loaded with ROMs which you downloaded from the internet?"];
			tree[309] = ["#hera10#Oh! I umm..."];
			tree[310] = ["#magn13#Not only did you clearly violate copyright law in downloading these ROMs, But... Now you're attempting to profit from the endeavor!?"];
			tree[311] = ["#hera11#No, I wasn't trying to make money! I just... I just wanted to spend more time with <name>..."];
			tree[312] = ["#hera08#I thought if Kecleon felt indebted... Well if he would watch the store more, it would... ...Ohh, what am I saying, it would have never worked anyways."];
			tree[313] = ["#magn12#... ..."];
			tree[314] = ["#magn06#... ... ...Evaluating... -fzzzzrt- Mm. " + MagnDialog.MAGN + " finds this behavior endearing. Also adorable. -bweeooop-"];
			tree[315] = ["#magn15#I suppose " + MagnDialog.MAGN + " doesn't need to punish someone for breaking the law... if it's for such an adorable reason. Carry on."];
			tree[316] = ["#hera00#Gweh! Th-thank you."];
			tree[317] = ["#hera05#So <name>... what do you think? Will you buy this... legally gray, but nice gift for Kecleon for " + moneyString(itemPrice) + "?"];

			if (!PlayerData.keclMale)
			{
				DialogTree.replace(tree, 312, "if he", "if she");
			}
		}
		else
		{
			tree[306] = ["#hera11#...I know! ...I know I'm asking for a lot of money but it was expensive! And a lot of work too!"];
			tree[307] = ["#hera08#I had to run all these Linux commands, and download all these ROMs, and it wouldn't pick up my USB keyboard, so I had to set up SSH just to install stuff..."];
			tree[308] = ["#hera09#...And... and the Bluetooth controllers didn't register, and when I fixed that, the left analog sticks stopped working... and I couldn't get the Neo Geo ROMs to run... Gweh..."];
			tree[309] = ["#hera04#But it'll all be worth it if we get to see each other more often <name>! ...So... Will you buy this nice gift for Kecleon for " + moneyString(itemPrice) + "?"];
		}
	}

	public static function assortedGloves(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera04#Those are some assorted gloves! You can wear them over your usual glove to make a fashion statement. Did you want to buy them for " + moneyString(itemPrice) + "?"];

		tree[100] = ["#hera02#Well here you go! I'll put these with your other items so you can try them on later."];

		tree[300] = ["Fashion\nstatement?"];
		tree[301] = ["#hera06#Well, you know! If the Mickey Mouse look works for you, that's none of my business. But if you feel like mixing things up a little..."];
		tree[302] = ["#hera05#Just look at this nice brown leather glove! That'll give you more of a refined look. Or ooooh! This cream-colored glove is pretty calming, isn't it?"];
		tree[303] = ["#hera04#You've got a whole handful of options to choose from here. Plus today, they're 50% off! Isn't that a bargain? Only " + moneyString(itemPrice) + " for the whole set!"];
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[304] = ["#magn05#Logically, they SHOULD be 50% off. -bweep- ... ...You're only selling <name> half of each pair."];
			tree[305] = ["#hera11#Ack! ...You stay out of this. I'm trying to run a business!"];
			tree[306] = ["#hera06#So what do you say? Do you want to change up your usual glove, maybe make a little fashion statement? Just " + moneyString(itemPrice) + "!"];
		}
		else
		{
			tree[304] = ["#hera06#So what do you say? Do you want to change up your usual glove, maybe make a little fashion statement? Just " + moneyString(itemPrice) + "!"];
		}
	}

	public static function insulatedGloves(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera04#Oh, those are insulated gloves! ...They'll protect your hand from electric shocks and other hazards. Did you want to buy them for " + moneyString(itemPrice) + "?"];

		tree[100] = ["#hera02#Here you go! I'll leave these with your other items, so you can go play dress-up later. Have fun~"];

		tree[300] = ["Other\nhazards?"];
		tree[301] = ["#hera06#So these might not be the prettiest things to look at, but they offer protection when working with live electrical circuits."];
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[302] = ["#magn04#Well... -fzzt- That seems like a crucial safety consideration. Shouldn't these be provided to " + MagnDialog.PLAYER + " free of charge?"];
			tree[303] = ["#hera04#Ehh? I hadn't thought of that! Hmmm... Hmmmmmm..."];
			tree[304] = ["#hera02#... ...No, I think it's safer if <name> pays me for them!"];
			tree[305] = ["#magn12#-bzzzzt-"];
			tree[306] = ["#hera04#So what do you say? Just " + moneyString(itemPrice) + " and you'll be protected against electricity and any other hazards that come up!"];
		}
		else
		{
			tree[302] = ["#hera10#And I guess they could protect your hand against other stuff like ehh... spaghetti sauce? And umm... boogers?"];
			tree[303] = ["#hera05#Just... anything yucky you don't want to get on your hand! They're non-absorbent so all that stuff washes right off. Easy peasy!"];
			tree[304] = ["#hera04#So what do you say? Just " + moneyString(itemPrice) + " and you'll be protected against electricity and any other hazards that come up!"];
		}
	}

	public static function ghostGloves(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera02#Oooh, those are some spooky ghost gloves! They're see-through, which might make... certain activities more enjoyable. Did you want to buy them for " + moneyString(itemPrice) + "?"];

		tree[100] = ["#hera03#Here you are! I'll put these with your items if you'd like to try them on later."];

		tree[300] = ["...Certain\nactivities?"];
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[301] = ["#hera06#So one problem about stuffing your fingers inside someo- ehh...  I mean, stuffing your fingers... inside a turkey? ... ..."];
			tree[302] = ["#hera04#One problem about stuffing your fingers inside a turkey is, well, your fingers all get in the way and you can't see anything fun."];
			tree[303] = ["#magn06#... ...Anything fun. Inside a turkey. -fzzt-"];
			tree[304] = ["#hera10#D'ehhh, yeah! So ehh..."];
			tree[305] = ["#hera04#...So these ghost gloves help with that since they're a little translucent. You can't see through them all the way, but it-"];
			tree[306] = ["#magn05#QUERY: If the gloves are translucent, wouldn't we see " + MagnDialog.PLAYER + "'s bare hand blocking the turkey? (Y/N)"];
			tree[307] = ["#hera11#Gweh? I'm... I'm not sure! I don't know how these things work. You're just... You're supposed to be able to see through to the other side!! I don't know!"];
			tree[308] = ["#magn12#-DOES NOT COMPUTE-"];
			tree[309] = ["#hera06#Hey, I just sell the things! ...<name>, it sounds like you'll have to try them out and let us know if they really work."];
			tree[310] = ["#hera02#... ...I'm especially curious how they fare during... certain activities! What do you say, does " + moneyString(itemPrice) + " sound fair?"];
		}
		else
		{
			tree[301] = ["#hera06#So one problem about stuffing your fingers inside someone is, well, your fingers all get in the way! You can't see anything."];
			tree[302] = ["#hera04#These ghost gloves help with that since they're a little translucent. You can't see all the way through, but it still gives you a better view."];
			tree[303] = ["#hera05#They come in a few different colors, like a ghastly purple and this spooky shadowy black. Or if that's too spooky, there's this harmless icy looking one!"];
			tree[304] = ["#hera02#What do you think? I bet you can think of... certain activities that will be more fun with these kinds of gloves! They're only " + moneyString(itemPrice) + ", how's that sound?"];
		}
	}

	public static function vanishingGloves(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera04#Those are vanishing gloves! They fade invisible when you're doing... certain activities. Did you want to buy them for " + moneyString(itemPrice) + "?"];

		tree[100] = ["#hera02#Ooh, here you go! ...I'll put them with all your other items, if you want to go try them on."];

		tree[300] = ["They fade\ninvisible?"];
		tree[301] = ["#hera05#Yeah! They start out like regular gloves. But when they detect resistance in the manner of mmm... a rubbing, or... poking motion..."];
		tree[302] = ["#hera00#...They become almost invisible so you can get a good view of what's being rubbed or... nngh, poked into. Pretty nifty, yes?"];
		tree[303] = ["#hera04#Don't ask me how they work! Abra designs all this stuff. It may as well be magic for all I know!"];
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[304] = ["#magn05#How would one accomplish anything with invisible hands? That seems like it would be... -fzzt- disorienting."];
			tree[305] = ["#hera05#Well, <name>'s already got his little telepresence obstacle in his way! I bet it wouldn't be any clumsier than that."];
		}
		else
		{
			tree[304] = ["#hera06#It probably involves some sort of... mirrors, or cameras or... chameleon blood? It's none of my business."];
			tree[305] = ["#hera03#They come in a few different colors, ranging from a sort of a haunting purple to a more ragged looking grey. So many nifty choices!"];
		}
		tree[306] = ["#hera04#Hmm, so what do you think, wouldn't it be nifty seeing your hand fade invisible? ...They're only " + moneyString(itemPrice) + "! What do you say?"];
	}

	public static function streamingPackage(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera05#Oh, that's a " + ((PlayerData.pokemonLibido == 1) ? "pokevideos.com" : "pokepornlive.com") + " premium package. Premium users get to stream their videos! Did you want to upgrade for " + moneyString(itemPrice) + "?"];

		tree[100] = ["#hera02#Ooh, here you go!"];
		tree[101] = ["#hera04#Oh and ehhh... I'll go ahead and set it up so it streams automatically. Don't worry about turning it on or anything, unless you wanna watch!"];

		tree[300] = ["Wait, I can\nstream?"];
		tree[301] = ["#hera04#That's right, if you upgrade to a premium account, " + ((PlayerData.pokemonLibido == 1) ? "pokevideos.com" : "pokepornlive.com") + " will let you stream!"];
		tree[302] = ["#hera02#They USUALLY charge an arm and a leg for premium membership. But there's a loophole in their gift cards that lets us pay a discounted price up front for a full year!"];
		tree[303] = ["#hera06#Now I don't think streaming is going to increase our popularity. Our fanbase is pretty niche! ...But,"];
		tree[304] = ["#hera04#It might be a smart way to keep tabs on our audience so you can cater more closely to their interests!"];
		tree[305] = ["#hera05#So far it probably seems pretty random why some videos get you more money sometimes..."];
		tree[306] = ["#hera03#...But see, if you monitor the stream and keep track of how many viewers you're getting, you'll get a better handle on what's more popular!"];
		tree[307] = ["#hera04#... ..."];
		tree[308] = ["#hera06#Oh! Umm, and obviously you can't connect to this universe's internet to view the stream directly. So that's why I'm including a tablet."];
		tree[309] = ["#hera08#Of course that means you'll be viewing the web site through a tablet, relayed through another webcam, and finally to your PC... Gwehhhh..."];
		tree[310] = ["#hera04#Well I mean, hopefully it looks okay! So what do you think, did you want to try streaming your videos for " + moneyString(itemPrice) + "? The price includes the tablet too!"];

		if (ItemDatabase.isMagnezonePresent() && PlayerData.pokemonLibido > 1)
		{
			tree[0] = ["#hera05#Oh, that's a uhhh... pokevideos.com premium package. Premium users get to stream their videos! Did you want to upgrade for " + moneyString(itemPrice) + "?"];
			tree[301] = ["#hera06#That's right, if you upgrade to a premium account, pokevideos.com will let you stream! ...As will any of their ehhh, affiliate websites..."];
		}
	}

	public static function mysteryBox(tree:Array<Array<Object>>, itemPrice:Int)
	{
		var boxCount:Int = ItemDatabase.getPurchasedMysteryBoxCount();

		if (boxCount % 10 == 0)
		{
			tree[0] = ["#hera02#Ooooh, that's a mystery box! I wonder what could be inside? ...It'll cost you " + moneyString(itemPrice) + " to find out. Did you want to buy it?"];
		}
		else if (boxCount % 10 == 1)
		{
			tree[0] = ["#hera02#That's a mystery box! It could have ANYTHING inside it! ...How does " + moneyString(itemPrice) + " sound?"];
		}
		else if (boxCount % 10 == 2)
		{
			tree[0] = ["#hera02#Oh boy, another mystery box. I thought I had sold my last one! ...Did you want to buy it for " + moneyString(itemPrice) + "?"];
		}
		else if (boxCount % 10 == 3)
		{
			tree[0] = ["#hera06#Ohhhh, so you're interested in the mystery box? This mystery box is WAY heavier than the others! ...I think! How does " + moneyString(itemPrice) + " sound?"];
		}
		else if (boxCount % 10 == 4)
		{
			tree[0] = ["#hera04#That's a mystery box! For the low, low price of " + moneyString(itemPrice) + " you could have... Whatever the heck's in there! Do you want it?"];
		}
		else if (boxCount % 10 == 5)
		{
			tree[0] = ["#hera02#Oh boy, that's another mystery box! I wish I had thought of these earlier. Just think of all the time I wasted selling actual merchandise! Gweh-heh-heh!"];
			tree[1] = ["#hera04#Okay, okay, well this one costs... " + moneyString(itemPrice) + ". Did you want to buy it?"];
		}
		else if (boxCount % 10 == 6)
		{
			tree[0] = ["#hera02#Wow, these mystery boxes are just flying off the shelves! This one costs " + moneyString(itemPrice) + ". ...Did you want it?"];
		}
		else if (boxCount % 10 == 7)
		{
			tree[0] = ["#hera05#It's another mystery box! You've had some bad luck with these so far, but I've got a good feeling about this one... Did you want it for " +moneyString(itemPrice) + "?"];
		}
		else if (boxCount % 10 == 8)
		{
			tree[0] = ["#hera04#That's a mystery box! What's inside? Don't you want to know? ...It'll cost you " + moneyString(itemPrice) + " this time. That's fair, isn't it?"];
		}
		else if (boxCount % 10 == 9)
		{
			tree[0] = ["#hera04#That's a mystery box! I wonder what could be inside that's so expensive? Did you want to buy it for " + moneyString(itemPrice) + "?"];
		}

		if (boxCount == 7)
		{
			// purchasing 8th mystery box; heracross has pity
			tree[100] = ["#hera03#Ohhh boy! Time to open up the mystery box! Let's seeeee what's insiiiiiiide~"];
			tree[101] = [115, 110, 125, 120];

			tree[110] = ["Quit getting\nmy hopes up"];
			tree[111] = ["#hera06#Getting your hopes up? Ohhhh it's not like ALL the boxes are empty! Look! This one has ehhh..."];
			tree[112] = [130];

			tree[115] = ["This is the\nbiggest scam"];
			tree[116] = ["#hera06#No, no, it's not a scam, you've just had bad luck with empty boxes! Look! This one has ehhh..."];
			tree[117] = [130];

			tree[120] = ["Ugh, I\nknow it's\nempty"];
			tree[121] = ["#hera06#No, no, don't get discouraged! Look! This one has ehh..."];
			tree[122] = [130];

			tree[125] = ["Are you\never going\nto actually\ngive me\nsomething?"];
			tree[126] = ["#hera06#I always try to give you something, you just have bad luck! But... Wow, this one's actually not empty! It has ehh..."];
			tree[127] = [130];

			tree[130] = ["#hera10#...it has SOMETHING in it! ...Where is that thing... ..."];
			tree[131] = ["#misc01#Wow, look! It's a super-fancy Elekid vibrator!"];
			tree[132] = ["#hera02#Lucky you! I'll go put it with your other items."];
			tree[133] = [150, 140, 145, 160];

			tree[140] = ["Huh, so\nthey're NOT\nall empty!?"];
			tree[141] = ["#hera03#Of course they're not all empty! If word got out that all my mystery boxes were empty, people might stop buying them."];
			tree[142] = ["#hera02#Now make sure to go out there and tell everyone how not-empty all of my mystery boxes are! And congratulations~"];

			tree[145] = ["Does it\nactually\nwork?"];
			tree[146] = ["#hera06#I think so? Hmmm, it might need batteries..."];
			tree[147] = ["#hera04#But hey, I bet you'll find batteries in one of these mystery boxes! ...Just buy more boxes, okay?"];

			tree[150] = ["Wow, this\nis so\ncool!"];
			tree[151] = ["#hera03#Gweh-heh-heh! See! Aren't mystery boxes fun?"];
			tree[152] = ["#hera04#Just think how boring it would be if that vibrator was just sitting out on the table with a price in front of it!"];
			tree[153] = ["#hera06#... ..."];
			tree[154] = ["#hera02#...Gosh, I should probably be charging more for mystery boxes considering how fun they are! Hmmmm..."];
			tree[155] = ["#hera03#Starting tomorrow, deluxe mystery boxes! Double the prices, double the fun!"];

			tree[160] = ["WHAT!?"];
			tree[161] = ["#hera03#And you didn't believe me when I said you were having bad luck! I've got like HUNDREDS of other toys back here..."];
			tree[162] = ["#hera05#Bondage straps, this weird fleshlight thing, a remote-controlled Riolu..."];
			tree[163] = ["#hera02#Wow! Think how cool that would be, you wouldn't even have to be a glove anymore. You could walk around as a Riolu!"];
			tree[164] = ["#hera03#...But of course you have to find the correct mystery box first!!! That's half the fun."];
			tree[165] = [142];
		}
		else
		{
			{
				var box0:Int = Std.int(boxCount * 1.11);
				if (box0 % 6 == 0)
				{
					tree[100] = ["#hera03#Ohhh boy! Time to open up the mystery box! Let's seeeee what's insiiiiiiide~"];
					tree[101] = ["#hera04#... ..."];
					tree[102] = ["#hera05#...Aaaaaaandd, the box contaaaains..."];
					tree[103] = ["#hera03#Ta-da! There's nothing!! ...Oh gosh, that was exciting wasn't it?"];
					tree[104] = [110, 125, 115, 120];
				}
				else if (box0 % 6 == 1)
				{
					tree[100] = ["#hera03#Oooohh time to open up the box! Oooopeniiiiiiiing~"];
					tree[101] = ["#hera04#... ..."];
					tree[102] = ["#hera05#...Whoa! It looks like there's something BIG this time..."];
					tree[103] = ["#hera03#Oh look at that, it's nothing!! ...It looks like you gave me lots of money for no reason again! Gweh-heheheh~"];
					tree[104] = [110, 125, 115, 120];
				}
				else if (box0 % 6 == 2)
				{
					tree[100] = ["#hera03#Ooh, let's see what's in the box THIS time! This one's REALLY heavy... ..."];
					tree[101] = ["#hera04#... ..."];
					tree[102] = ["#hera05#...It's almost open... ...Wow, what could weigh so much? And in such a small box?"];
					tree[103] = ["#hera03#Oh nevermind, it's empty again! ...How embarrassing! I need to exercise more!"];
					tree[104] = [110, 125, 115, 120];
				}
				else if (box0 % 6 == 3)
				{
					tree[100] = ["#hera03#Oh boy, this is it, I can feel it! This is the box!"];
					tree[101] = ["#hera02#This one's going to have something REALLY good! ...Something which finally justifies all that disappointment!!"];
					tree[102] = ["#hera04#... ..."];
					tree[103] = ["#hera05#...Aaaaaandd, the box contaaains..."];
					tree[104] = ["#hera03#Oh no! This one's empty too! I almost feel bad a little. What are the chances!"];
					tree[105] = [110, 125, 115, 120];
				}
				else if (box0 % 6 == 4)
				{
					tree[100] = ["#hera03#Wow, I felt this one MOVE! Is there something alive inside of here? Let's get it open and find out..."];
					tree[101] = ["#hera04#... ..."];
					tree[102] = ["#hera05#...It's almost open, aaaaanddddd..."];
					tree[103] = ["#hera03#Oh no, there's nothing in here! Just another empty box. Well, there's always tomorrow~"];
					tree[104] = [110, 125, 115, 120];
				}
				else if (box0 % 6 == 5)
				{
					tree[100] = ["#hera03#Oooh, going to push your luck again, are you! A risk taker! I like it! ...Let's see, let's see... What's in the box this time..."];
					tree[101] = ["#hera04#... ..."];
					tree[102] = ["#hera05#...This one's not going to be empty too, is it? Oh no..."];
					tree[103] = ["#hera03#Ack! I don't know what to tell you. You have the worst luck in the universe~"];
					tree[104] = [110, 125, 115, 120];
				}
			}

			{
				var box0:Int = Std.int(boxCount * 1.17);
				if (box0 % 5 == 0)
				{
					tree[110] = ["I thought\nit would be\nsomething\ngood"];
					tree[111] = ["#hera02#Well hey, at least you got the joy of opening a box! You can't put a price on that, can you?"];
				}
				else if (box0 % 5 == 1)
				{
					tree[110] = ["You got my\nhopes up"];
					tree[111] = ["#hera04#Aww well hey, I'm just as much a victim as you! ...Except that I have all your money!"];
				}
				else if (box0 % 5 == 2)
				{
					tree[110] = ["I thought it\nwould have\nsomething\nin it this\ntime"];
					tree[111] = ["#hera06#I know, I know! I'm just as surprised as you. ...Has someone been stealing from my mystery boxes?"];
				}
				else if (box0 % 5 == 3)
				{
					tree[110] = ["I have the\nworst luck"];
					tree[111] = ["#hera04#Aww, well you've opened so many empty boxes, your next one's bound to have something in it! ...That's just statistics 101."];
				}
				else if (box0 % 5 == 4)
				{
					tree[110] = ["I thought\nthis box\nwould be\ndifferent"];
					tree[111] = ["#hera06#Hmm, yeah! I wonder if there's a lesson there. ...There probably isn't! But maybe."];
				}
			}

			{
				var box0:Int = Std.int(boxCount * 1.23);
				if (box0 % 5 == 0)
				{
					tree[115] = ["Well I'm\nnot falling\nfor that\nagain"];
					tree[116] = ["#hera02#Gweh-heheheheh! Don't be so sure. I'll bet you could fall for it a few more times~"];
				}
				else if (box0 % 5 == 1)
				{
					tree[115] = ["This is the\nbiggest scam"];
					tree[116] = ["#hera02#Aww you'll win something next time! I can feel it! ... ...Just make sure to bring lots of money. Gweh-heheheh~"];
				}
				else if (box0 % 5 == 2)
				{
					tree[115] = ["You're\na jerk,\nHeracross"];
					tree[116] = ["#hera02#Okay, okay, I'm sorry! ...I promise I'll put something really good in the next mystery box."];
				}
				else if (box0 % 5 == 3)
				{
					tree[115] = ["These mystery\nboxes are\nso stupid"];
					tree[116] = ["#hera02#Stupid? ...Look at all the money I'm getting for them, this is the best idea I ever had! Gweh-heheheh~"];
				}
				else if (box0 % 5 == 4)
				{
					tree[115] = ["I'm never\nshopping\nhere again"];
					tree[116] = ["#hera04#Aww, don't say that! I'll be sure to have some actual merchandise in stock next time, okay?"];
					tree[117] = ["#hera06#...Just don't be too disappointed if it's inside an unlabeled box."];
				}
			}

			{
				var box0:Int = Std.int(boxCount * 1.29);
				if (box0 % 5 == 0)
				{
					tree[120] = ["I thought\nit might be\nempty"];
					tree[121] = ["#hera04#Aww, don't get discouraged! I'm sure your luck will turn around~"];
				}
				else if (box0 % 5 == 1)
				{
					tree[120] = ["Ugh, I\nknew it"];
					tree[121] = ["#hera04#Yeah, but now you KNOW you knew! ...Isn't that feeling worth " + moneyString(itemPrice) + "?"];
				}
				else if (box0 % 5 == 2)
				{
					tree[120] = ["They're all\nempty, aren't\nthey"];
					tree[121] = ["#hera04#No, of course not! You just randomly found all the empty ones first. You've been so unlucky!"];
					tree[122] = ["#hera02#All the rest of the remaining boxes though... Oh my goodness! You're just going to love what's in the next box~"];
				}
				else if (box0 % 5 == 3)
				{
					tree[120] = ["I knew it\nwas going\nto be empty"];
					tree[121] = ["#hera04#Aww, you're so pessimistic! Some of these boxes are just stuffed full of amazing merchandise. Your luck will turn around!"];
				}
				else if (box0 % 5 == 4)
				{
					tree[120] = ["Yep, just\nlike I\nthought"];
					tree[121] = ["#hera04#I can't believe your bad luck! ...I don't know how to convince you that my mystery boxes aren't rigged. You'll just have to buy more boxes to see!"];
				}
			}

			{
				var box0:Int = Std.int(boxCount * 1.35);
				if (box0 % 5 == 0)
				{
					tree[125] = ["Can I at\nleast keep\nthe box?"];
					tree[126] = ["#hera06#...No, no you can't keep the box! This isn't a charity... ..."];
				}
				else if (box0 % 5 == 1)
				{
					tree[125] = ["Do I get a\nconsolation\nprize?"];
					tree[126] = ["#hera05#...Sure, you can have a consolation prize!"];
					tree[127] = ["#hera06#Your consolation prize is... ehhhhh... ...my consolation!"];
					tree[128] = ["#hera04#There there, <name>. ...There, there."];
				}
				else if (box0 % 5 == 2)
				{
					tree[125] = ["You should\nat least\ngive me\nsomething"];
					tree[126] = ["#hera06#I... I should? ...That sounds incredibly generous compared to what I had planned for my mystery box idea."];
					tree[127] = ["#hera04#You know what? I think maybe I'll give you something NEXT time! I'll add it into my next mystery box."];
				}
				else if (box0 % 5 == 3)
				{
					tree[125] = ["I want my\nmoney back"];
					tree[126] = ["#hera04#Hmmm... ... No you don't! You want me to have it~"];
				}
				else if (box0 % 5 == 4)
				{
					tree[125] = ["What are\nyou doing\nwith all\nmy money?"];
					tree[126] = ["#hera04#Your money? Why... all of your money goes into buying merchandise for my mystery boxes!"];
					tree[127] = ["#hera06#Everyone else's mystery boxes have been FULL of great stuff. ...You've just had the worst luck! I don't know what to say~"];
				}
			}
		}

		if (ItemDatabase.isMagnezonePresent())
		{
			if (boxCount % 5 == 0)
			{
				tree[300] = ["Mystery\nbox?"];
				tree[301] = ["#hera05#Oooh yeah, a mystery box! It's so mysterious that even I don't know what's inside!"];
				tree[302] = ["#magn04#For police purposes, it is imperative for " + MagnDialog.MAGN + " to know the contents of the box. ...Is it... -fzzt- contraband?"];
				tree[303] = ["#hera10#N-no, it's nothing at all!"];
				tree[304] = ["#hera11#I mean, it's SOMETHING... There's something in the box! Something... very, very legal!"];
				tree[305] = ["#magn12#... ..."];
				tree[306] = ["#hera06#Okay, okay, sheesh! It's... -whisper, whisper- ... ..."];
				tree[307] = ["#magn15#...?"];
				tree[308] = ["#magn05#" + MagnDialog.MAGN + " would advise " + MagnDialog.PLAYER + " to avoid purchasing this particular item."];
				tree[309] = ["#hera12#H-hey!!!"];
				tree[310] = ["#hera06#Don't listen to Magnezone, <name>. You'll pay " + moneyString(itemPrice) + " for this mystery box, right?"];
			}
			else if (boxCount % 5 == 1)
			{
				tree[300] = ["Mystery\nbox?"];
				tree[301] = ["#hera05#Oh, sure! Mystery boxes are far more exciting than regular boring old boxless merchandise."];
				tree[302] = ["#hera04#You neeeever know what's going to be in the box until you open it! It could be anything!"];
				tree[303] = ["#magn04#" + MagnDialog.HERA + ", you are charging a tremendous premium for an empty box."];
				tree[304] = ["#hera10#N-no, I'm not selling the empty box! I'm selling the CONTENTS of the empty box. ...Ehh, the contents of the box!"];
				tree[305] = ["#magn05#" + MagnDialog.PLAYER + ", is this about the box? ..." + MagnDialog.MAGN + " can provide you with an empty box free of charge."];
				tree[306] = ["#hera11#Hey! ...Get your own store!!!"];
				tree[307] = ["#hera06#Anyway, you'll buy the mystery box for " + moneyString(itemPrice) + ", won't you?"];
			}
			else if (boxCount % 5 == 2)
			{
				tree[300] = ["Mystery\nbox?"];
				tree[301] = ["#hera05#Each mystery box has its own special surprise inside! ...You never know what's inside until you give me lots of money."];
				tree[302] = ["#magn06#...Are you trying to swindle " + MagnDialog.PLAYER + " into paying for your empty boxes again?"];
				tree[303] = ["#hera10#N-no, he's paying for the CONTENTS of my empty boxes! I mean... the contents of my boxes!"];
				tree[304] = ["#hera06#It could have anything, <name>!! ...It might not be empty. You never know!"];
				tree[305] = ["#magn14#It is empty. -beep-"];
				tree[306] = ["#hera04#... ...But, ehhhh? What if? Ehhhh? Ehhhhhhh? ...Think about it!"];
				tree[307] = ["#hera02#You should buy this box before you miss out! Only " + moneyString(itemPrice) + "!? If you saw what was inside it, you'd pay twice that! What do you say?"];

				if (PlayerData.gender == PlayerData.Gender.Girl)
				{
					DialogTree.replace(tree, 303, "he's paying", "she's paying");
				}
				else if (PlayerData.gender == PlayerData.Gender.Complicated)
				{
					DialogTree.replace(tree, 303, "he's paying", "they're paying");
				}
			}
			else if (boxCount % 5 == 3)
			{
				tree[300] = ["Mystery\nbox?"];
				tree[301] = ["#hera05#You never know what you're getting with a mystery box! It could be, let's see... something to help you solve puzzles faster? Or, it could be..."];
				tree[302] = ["#magn04#-boop- Another day. Another empty mystery box."];
				tree[303] = ["#hera14#Eh, what? ...Shush, you!"];
				tree[304] = ["#hera04#Don't worry about Magnezone, <name>. ...He doesn't actually know what's in the box."];
				tree[305] = ["#magn08#... ..."];
				tree[306] = ["#magn09#..." + MagnDialog.MAGN + "'s entire life is an empty mystery box."];
				tree[307] = ["#hera10#Geez louise! ...Lighten up a little, Magnezone!"];
				tree[308] = ["#hera06#I mean, well... the box COULD be empty! You never know until you open it. That's the risk with a mystery box! But what do you say <name>, isn't that risk worth " + moneyString(itemPrice) + "?"];

				if (!PlayerData.magnMale)
				{
					DialogTree.replace(tree, 304, "He doesn't", "She doesn't");
				}
			}
			else if (boxCount % 5 == 4)
			{
				tree[300] = ["Mystery\nbox?"];
				tree[301] = ["#hera05#Oh, don't try to pretend you're new to the whole mystery box thing. You've already bought so many!"];
				tree[302] = ["#magn05#-bwoooop?- " + MagnDialog.MAGN + "'s sensors are actually detecting something inside the box for once."];
				tree[303] = ["#hera02#Ooohhh see? I think today's the day! I knew your luck would turn around, <name>!"];
				tree[304] = ["#magn04#-beep- -boop-? Is this data accurate? Did " + MagnDialog.HERA + " actually put an item in the mystery box? " + MagnDialog.HERA + " isn't just selling an empty box? ... ... ..."];
				tree[305] = ["#magn10#... ..." + MagnDialog.MAGN + " will schedule an urgent appointment for sensor maintenance."];
				tree[306] = ["#hera11#N-no, don't say that! Your sensors are fine. There's something in the box this time, I promise!"];
				tree[307] = ["#hera06#So what do you say, do you want to buy this mystery box for " + moneyString(itemPrice) + "?"];
			}
		}
		else
		{
			if (boxCount % 5 == 0)
			{
				tree[300] = ["Mystery\nbox?"];
				tree[301] = ["#hera05#Oooh yeah, a mystery box! It's so mysterious that even I don't know what's inside!"];
				tree[302] = ["#hera06#...Well, okay. Maybe I do know what's inside. ...But I'm sure as heck not telling you! Not without my " + moneyString(itemPrice) + "!"];
				tree[303] = ["#hera04#It could be... a new puzzle nobody's ever seen before? Or a secret item to woo Kecleon so that you can play with him?"];
				tree[304] = ["#hera05#Maybe it's even a key to unlocking a super secret Pokemon nobody ever knew was in this game!!! Wouldn't that be something."];
				tree[305] = ["#hera04#Anyways, what do you think? Will you pay " + moneyString(itemPrice) + " for this mystery box?"];

				if (!PlayerData.keclMale)
				{
					DialogTree.replace(tree, 303, "with him", "with her");
				}
			}
			else if (boxCount % 5 == 1)
			{
				tree[300] = ["Mystery\nbox?"];
				tree[301] = ["#hera05#Oh, sure! Mystery boxes are far more exciting than regular boring old boxless merchandise."];
				tree[302] = ["#hera04#You neeeever know what's going to be in the box until you open it! It could be anything!"];
				tree[303] = ["#hera06#A crazy new cosmetic item? Or it could even be like... an online gift card for something in YOUR universe? Something worth ACTUAL money!?"];
				tree[304] = ["#hera07#Did I say that? Who said that? Would someone program something worth ACTUAL money into this game? No way! That's crazy!"];
				tree[305] = ["#hera03#If someone did something that crazy, it would have to be awfully rare! Like one out of every fifty boxes! Maybe one out of every thousand!"];
				tree[306] = ["#hera04#...Well, you'll never know unless you fork over the " + moneyString(itemPrice) + "! So what do you say?"];
			}
			else if (boxCount % 5 == 2)
			{
				tree[300] = ["Mystery\nbox?"];
				tree[301] = ["#hera05#Each mystery box has its own special surprise inside! ...You never know what's inside until you give me lots of money."];
				tree[302] = ["#hera06#The only thing I can guarantee is that whatever's inside is definitely worth at least... How much am I charging for this thing again?"];
				tree[303] = ["#hera02#" + moneyString(itemPrice) + "!?! Oh goodness, I'm going to be rich!"];
				tree[304] = ["#hera04#...But ehhhhh yes, it's definitely worth more than " + moneyString(itemPrice) + ". Probably definitely."];
				tree[305] = ["#hera06#You should buy this box before you miss out! Only " + moneyString(itemPrice) + "!? If you saw what was inside it, you'd pay twice that! What do you say?"];
			}
			else if (boxCount % 5 == 3)
			{
				tree[300] = ["Mystery\nbox?"];
				tree[301] = ["#hera05#You never know what you're getting with a mystery box! It could be, let's see... something to help you solve puzzles faster?"];
				tree[302] = ["#hera02#Maybe it's a special item that unlocks a super secret BONUS ending to the game, something nobody but you has ever seen before! ...Wow!! I'd want that!"];
				tree[303] = ["#hera06#I mean, it could always be nothing! That's the risk with a mystery box. But what do you say, isn't that risk worth " + moneyString(itemPrice) + "?"];
			}
			else if (boxCount % 5 == 4)
			{
				tree[300] = ["Mystery\nbox?"];
				tree[301] = ["#hera04#Oh, don't try to pretend you're new to the whole mystery box thing. You've already bought so many!"];
				tree[302] = ["#hera05#...Wait, I know what you're doing! You're trying to get a hint about what's in the box aren't you? Hmmmm... Well, maybe I can give you a little hint... ..."];
				tree[303] = ["#hera06#... ..."];
				tree[304] = ["#hera02#You know what, I actually can't think of anything to say that wouldn't completely spoil it! You'll just have to be surprised."];
				tree[305] = ["#hera04#So what do you say, do you want to buy this mystery box for " + moneyString(itemPrice) + "?"];
			}
		}
	}

	public static function blueDildo(tree:Array<Array<Object>>, itemPrice:Int)
	{
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[0] = ["#hera06#That's a, ehhh... a masculinity totem! You can use it to ward away... gwehh... feminine energies? ...Did you want to buy it for " + moneyString(itemPrice) + "?"];

			tree[100] = ["#hera02#Phew! ...Hurry up and hide that someplace where Magnezone can't find it."];
			if (PlayerData.hasMet("buiz"))
			{
				tree[101] = ["#hera01#...I think Buizel might know a good place~"];
			}

			tree[300] = ["Masculinity\ntotem?"];
			tree[301] = ["#hera08#Ehhhh... yeah! It's a, it's a mystical totem which exudes a... negative resonant energy to cancel out... ... ambient... girl waves?"];
			tree[302] = ["#hera11#... ...No, nobody would believe that. ...What does this darn thing do!? I'm usually better at coming up with this stuff."];
			tree[303] = ["#magn06#I suppose it's sheer coincidence that this alleged &lt;masculinity totem&gt; is the same size and shape as an &lt;organic reproductive dongle&gt;?"];
			tree[304] = ["#hera10#The same shape? ...N-no it isn't! Our... reproductive dongles... don't look anything like that."];
			tree[305] = ["#magn045It's a near identical match. ...Let " + MagnDialog.MAGN + " see your dongle, so he can demonstrate the similarity. -boop-"];
			if (PlayerData.heraMale)
			{
				tree[306] = ["#hera11#D-aaagh! Get away! Leave my dongle out of this!"];
				tree[307] = ["#magn05#Let me see. Let me see your dongle. " + MagnDialog.MAGN + " wants to see. " + MagnDialog.MAGN + " wants. -boop- -boop-"];
			}
			else
			{
				tree[306] = ["#hera11#D-aaagh! Get away! I don't have a dongle!"];
				tree[307] = ["#magn05#All organics have dongles. ..." + MagnDialog.MAGN + " demands to see your dongle. " + MagnDialog.MAGN + " wants to see. " + MagnDialog.MAGN + " wants. -boop- -boop-"];
			}
			tree[308] = ["#hera11#Gaaaggh! Leave me alone! ...You're being so weird!"];
			tree[309] = ["#hera10#Hurry up and buy this stupid dildo so that Magnezone will leave me alone! ...I mean, this stupid masculinity totem! Masculinity totem!"];

			if (!PlayerData.magnMale)
			{
				DialogTree.replace(tree, 305, "he can", "she can");
			}
		}
		else
		{
			tree[0] = ["#hera04#That's a ridged dildo! Did you want to buy it for " + moneyString(itemPrice) + "?"];

			tree[100] = ["#hera02#Here you go!"];
			tree[101] = ["#hera01#I'll be keeping an eye on you. Gweh-heh-heh! ...Try to give me some good footage to work with."];

			tree[300] = ["Ridged\ndildo?"];
			tree[301] = ["#hera05#Oh sure! This dildo is a good choice for beginners and experts alike."];
			tree[302] = ["#hera06#It's a decent size with a thick, hearty bulge at the base, so you'll definitely feel it!"];
			tree[303] = ["#hera04#But it's made of a soft silicone material which is gentle on the body. ...So you shouldn't hurt yourself with it as long as you're careful."];
			tree[304] = ["#hera01#Also those ridges are something everyone should try at least once! ... ...Haven't you ever looked at a guiro and thought, \"Wow! I want that in my butt.\""];
			tree[305] = ["#hera02#...Well, consider this a slightly safer alternative. ...Like a little training guiro!"];
			tree[306] = ["#hera04#Anyways, what do you think? Are you interested in the ridged dildo for " + moneyString(itemPrice) + "?"];
		}
	}

	public static function gummyDildo(tree:Array<Array<Object>>, itemPrice:Int)
	{
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[0] = ["#hera04#That's a, ehhh... That's a jumbo sized gummy worm! It's a fun little snack that certain Pokemon might enjoy. Only " + moneyString(itemPrice) + ", what do you say?"];

			tree[100] = ["#hera03#Here you go!"];

			tree[300] = ["Gummy\nworm?"];
			if (PlayerData.hasMet("buiz"))
			{
				tree[301] = ["#hera05#Gummy worms aren't the healthiest of snacks, but they can still be a fun treat now and then. Let's take ehhhh... Buizel for example!"];
				tree[302] = ["#hera01#...I'm sure he'd love having a sugary snack crammed down his hungry hole once in awhile. It might really hit the spot, so to speak~"];

				if (!PlayerData.buizMale)
				{
					DialogTree.replace(tree, 302, "he'd love", "she'd love");
					DialogTree.replace(tree, 302, "his hungry", "her hungry");
				}
			}
			else
			{
				tree[301] = ["#hera05#Gummy worms aren't the healthiest of snacks, but they can still be a fun treat now and then."];
				tree[302] = ["#hera01#Certain Pokemon would love having a sugary snack crammed down their hungry hole once in awhile. It might really hit the spot, so to speak~"];
			}
			tree[303] = ["#magn06#Perhaps " + MagnDialog.MAGN + " is imagining things... But this particular gummy worm is incredibly phallic in appearance."];
			tree[304] = ["#hera06#Ehhhh? ...It just looks like a regular gummy worm to me, you crazy pervert."];
			tree[305] = ["#magn10#&lt;Mag... " + MagnDialog.MAGN + " is not a pervert! " + MagnDialog.MAGN + " thinks it looks like a regular gummy worm as well. -bwoooop-"];
			tree[306] = ["#hera02#Good! ...So what do you say <name>, can I interest you in this regular old gummy worm for " + moneyString(itemPrice) + "?"];
		}
		else
		{
			tree[0] = ["#hera04#That's a gummy dildo! Did you want to buy it for " + moneyString(itemPrice) + "?"];

			tree[100] = ["#hera02#Here you go! ...Don't try to eat it!"];

			tree[300] = ["Gummy\ndildo?"];
			tree[301] = ["#hera05#Oh! So this dildo has some extra fancy ridges and a fun little bulge at the bottom too."];
			tree[302] = ["#hera01#But most noticably, it's transparent which means you can see all the fun stuff that's going on while you use it~"];
			tree[303] = ["#hera04#Also, being transparent and extra squishy gives it sort of a gummy appearance! ...Of course it's not made of actual gummy material though, just the usual silicone and stuff."];
			tree[304] = ["#hera10#Can you imagine if someone actually made a dildo out of gummy candy? ... ...That's a recipe for some really, really gay ants! Oh my land!"];
			tree[305] = ["#hera04#So how about it, can I interest you in the gummy dildo? It's only " + moneyString(itemPrice) + "!"];
		}
	}

	public static function hugeDildo(tree:Array<Array<Object>>, itemPrice:Int)
	{
		if (ItemDatabase.isMagnezonePresent())
		{
			tree[0] = ["#hera05#That's the ehhhh... Heracross halloween costume! Just in time for halloween. How does " + moneyString(itemPrice) + " sound?"];

			tree[100] = ["#hera02#Okay! I'll put it with the rest of your items where you can go look at it~"];

			tree[300] = ["Heracross\nhalloween\ncostume?"];
			tree[301] = ["#hera06#Gwuhhh, yeah! ...Any heracross costume is incomplete without a super convincing horn. ...So you can strap this thing to your head, and errr..."];
			tree[302] = ["#hera04#...It's like a big, scary, demonic horn! You'll be just the spookiest looking heracross ever. Think of all the candy you'll get!"];
			tree[303] = ["#magn12#" + MagnDialog.HERA + ". This object is clearly a synthetic replica of an organic phallus, which I can only imagine has some sort of sexual purpose."];
			tree[304] = ["#hera11#No, no! Nothing sexual! It's a, ummm... spooky-looking halloween phallus! ...For a super-spooky naked demon costume!"];
			tree[305] = ["#magn13#..."];
			tree[306] = ["#hera10#I mean, gwehhh... of course it looks KIND of sexy if you don't consider the spookiness!!! ...But it's... It's so spooky!"];
			var line:Int = logInfraction(tree, 307);
			tree[line+0] = ["#hera05#Anyway <name>, were you interested in the ehhhhh... Heracross halloween costume? It's only " + moneyString(itemPrice) + "!"];
		}
		else
		{
			tree[0] = ["#hera04#That's an absolutely monstrous dildo! For display purposes only, of course. ...I'm charging " + moneyString(itemPrice) + " for it, how does that sound? Are you interested?"];

			tree[100] = ["#hera02#Okay! I'll put it with the rest of your items where you can go look at it~"];

			tree[300] = ["Monstrous\ndildo?"];
			tree[301] = ["#hera10#Let's see, that's the \"Pokefantasy DI-LD50.\" ...Pokefantasy advertises this dildo as being SO monstrously oversized, that it kills half of those who attempt to use it!? Gweh!"];
			tree[302] = ["#hera06#...That's clearly just a marketing gimmick though, I mean... ...just look at the size of this tip!"];
			tree[303] = ["#hera07#How the heck are you supposed to even fit this gigantic thing anywhere!? It's barely even tapered!"];
			tree[304] = ["#hera03#Really the only way I could imagine something THIS huge killing someone is if it tipped over and fell on them. Gweh-heh-heh!"];
			tree[305] = ["#hera04#So, were you interested in the monstrous dildo? It's a nice conversation piece, even if it's too big to actually use. ...How does " + moneyString(itemPrice) + " sound?"];
		}
	}

	public static function happyMeal(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera04#That's a box of old happy meal toys. Ehhh, I'm asking for " + moneyString(itemPrice) + " for the entire box. Did you want them?"];

		tree[100] = ["%gift-grim%"];
		tree[101] = ["#hera02#Well! Now you've done it. Ehh-heheh."];
		tree[102] = ["#hera03#I'll leave this box with all of your other stuff. ...He's your problem now~"];

		tree[300] = ["Old happy\nmeal toys?"];
		tree[301] = ["#hera06#Okay, I know, I know. ...Not exactly the most appealing merchandise I've ever stocked. It's just a big box of useless junk."];
		tree[302] = ["#hera05#...But I can think of ONE particular Pokemon around here who'd absolutely love a big box of useless junk!"];
		tree[303] = ["#hera02#Buying something like this might even act as a gesture to make them feel more welcome. ...Which might be a good thing or a bad thing. Gweh! Heheheh~"];
		tree[304] = ["#hera04#Well, that part's up to you. What do you think, do you want to buy this big box of old happy meal toys for " + moneyString(itemPrice) + "?"];

		if (!PlayerData.grimMale)
		{
			DialogTree.replace(tree, 102, "He's your", "She's your");
		}
	}

	public static function pizzaCoupons(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera05#Oh, those are some pizza coupons! ...They might make a nice gift for someone who eats a lot of pizza. Did you want to buy them for " + moneyString(itemPrice) + "?"];

		tree[100] = ["%gift-luca%"];
		tree[101] = ["#hera02#Yayyy! ...Let me get those for you."];
		tree[102] = ["#hera03#I'll wrap them up nice and pretty, and give them to Rhydon next time I see him~"];

		tree[300] = ["Pizza\ncoupons?"];
		tree[301] = ["#hera04#So, Effen Pizza routinely sends out these coupon flyers in the mail. ...\"Buy two get one free,\" \"order two specialty pizzas for ^1,500,\" that sort of thing."];
		tree[302] = ["#hera05#But one time, the coupons had a serious oversight, where you could get a whole heap of pizzas dirt cheap if you combined them in the right way!"];
		tree[303] = ["#hera06#I was thinking these coupons would make a nice gift for Rhydon. And maybe they'll even convince him to place more pizza orders?"];
		tree[304] = ["#hera02#...I mean yes, he already orders pizza like three nights a week. But ehhh, maybe these coupons will bump him up to six! Gweheheh~"];
		tree[305] = ["#hera05#So what do you think, did you want to buy these pizza coupons for " + moneyString(itemPrice) + "?"];

		if (!PlayerData.rhydMale)
		{
			DialogTree.replace(tree, 102, "see him", "see her");
			DialogTree.replace(tree, 303, "convince him", "convince her");
			DialogTree.replace(tree, 304, "yes, he", "yes, she");
			DialogTree.replace(tree, 304, "bump him", "bump her");
		}
	}

	static public function phoneCall(tree:Array<Array<Object>>, itemPrice:Int)
	{
		tree[0] = ["#hera04#Ooohhh, that's a phone call to a Pokemon of your choice! ...I'll charge you " + moneyString(itemPrice) + ", but you can invite over aaaanybody you want! Does that sound good?"];

		tree[300] = ["A phone\ncall?"];
		tree[301] = ["#hera05#Yeah, some pokemon like Grimer and Lucario don't actually live here, and I think they feel weird about inviting themselves over too often!"];
		tree[302] = ["#hera06#But maaaaaybe if you give them a call... Maybe you can talk them into coming over, hmmmmm?"];
		tree[303] = ["#hera03#To be clear though, this is my phone! I'm not giving you the phone but... I'm just letting you borrow it to make a call, okay? Okay!"];
		tree[304] = ["#hera04#Sooooo, what do you say? " + moneyString(itemPrice) + " for a phone call to anybody you want! That's a pretty good deal isn't it?"];

		tree[100] = ["#hera02#Oh boy, how exciting! So... ... ... Who did you want to call?"];
		tree[101] = [];
		if (PlayerData.denProf != PlayerData.PROF_PREFIXES.indexOf("luca"))
		{
			tree[101].push(600 - 2);
		}
		if (PlayerData.denProf != PlayerData.PROF_PREFIXES.indexOf("magn"))
		{
			tree[101].push(650 - 2);
		}
		if (PlayerData.denProf != PlayerData.PROF_PREFIXES.indexOf("grim"))
		{
			tree[101].push(700 - 2);
		}
		if (PlayerData.denProf != PlayerData.PROF_PREFIXES.indexOf("hera"))
		{
			tree[101].push(750 - 2);
		}
		if (PlayerData.denProf != PlayerData.PROF_PREFIXES.indexOf("kecl"))
		{
			tree[101].push(800 - 2);
		}
		if (PlayerData.denProf != PlayerData.PROF_PREFIXES.indexOf("sand") && ItemDatabase.getPurchasedMysteryBoxCount() >= 11)
		{
			tree[101].push(900 - 2);
		}
		FlxG.random.shuffle(tree[101]);

		{
			tree[600] = ["Lucario"];
			tree[601] = ["%buy%"];
			tree[602] = ["%call-luca%"];
			tree[603] = ["#zzzz04#(Ring, ring...)"];
			if (FlxG.random.bool(33))
			{
				tree[604] = ["#luca05#Kyehh? Hello?"];
				tree[605] = ["#luca03#... ...Oh! <name>!!! I didn't recognize the number. Kyahahahahah! So what are youuuuuu doing calling me!? Since when did you get a phooooooooone!"];
			}
			else if (FlxG.random.bool(50))
			{
				tree[604] = ["#luca05#Hello? ...Oh! Is that you, <name>?"];
				tree[605] = ["#luca03#Kyah! ...Hello! I wasn't expecting you to call me. How are things going with you?"];
			}
			else
			{
				tree[604] = ["#luca05#Oh? Who's this?"];
				tree[605] = ["#luca03#<name>? No way! Hey <name>!!! ...Were you just calling me to say \"hi!\" That's so sweeeeet~"];
			}
			tree[606] = [610, 615, 620, 625, 630, 635, 640, 645];
			FlxG.random.shuffle(tree[606]);
			tree[606] = tree[606].splice(0, 4);

			tree[610] = ["Can you\ncome by\nAbra's\nplace?"];
			tree[611] = ["#luca04#Ooooh, that sounds fun! I think I can make that happen... ..."];
			tree[612] = ["#luca02#...Yeah, go ahead and solve a few puzzles without me! I'll be right there. Byeeeeee~"];

			tree[615] = ["I haven't\nseen you\nin awhile!"];
			tree[616] = ["#luca04#I was just thinking about that! Hmmmm... maybe I can come by in a few minutes?"];
			tree[617] = ["#luca02#Let me see what I can do, okay? Thanks for calling me, <name>! It was nice hearing your voice~"];

			tree[620] = ["I was just\nthinking\nabout you"];
			tree[621] = ["#luca06#Awww, well that's sweet! ...I was thinking about where birds go when it rains. Hmmmm..."];
			tree[622] = ["#luca04#... ...Hey, I was about to head over to your neighborhood anyways! That's kind of random, isn't it?"];
			tree[623] = ["#luca02#Anyways it was nice talking to you <name>! I'll see you in a few minutes. Byeeeeeee~"];

			tree[625] = ["What\nare you\nup to?"];
			tree[626] = ["#luca07#Kkkkkh, you know, same old stuff. Hey! I could kind of use a break actually."];
			tree[627] = ["#luca04#Maybe I can find an excuse to head over to Abra's place! You'll still be there in a little while, right?"];
			tree[628] = ["#luca02#Wait up for me! I'll just be a minute. Thanks for calling me, <name>~"];

			tree[630] = ["Just\nfeeling\na little\nlonely~"];
			tree[631] = ["#luca02#Awwww, well I can help you with that... ... ... I'll just call Grimer for you! That's what you meant, right?"];
			tree[632] = ["#luca03#Kyeheheheh! Okay okay I'm sooooorrrrrry. That was mean! Don't tell Grimer I said that, alright?"];
			tree[633] = ["#luca02#I'll be over in just a few minutes~"];

			tree[635] = ["I'd like\na large\npupperoni\npizza"];
			tree[636] = ["#luca14#Har, har, har. How long have you been working on THAT one, <name>?"];
			tree[637] = ["#luca06#Although hmm... this pupper could use a little break! I'll see what I can do, okay?"];
			tree[638] = ["#luca04#...It was nice hearing from you <name>! I hope I can see you soon~"];

			tree[640] = ["Feel like\ndoing some\npuzzles?"];
			tree[641] = ["#luca14#Kkkkkh, I feel like doing something alright! It's been a loooooong day..."];
			tree[642] = ["#luca10#Oh ummm, you don't think Abra will mind if I come over today, do you? I meeeeean, I don't want to impooooose..."];
			tree[643] = ["#luca04#...Well, whatever! If anybody asks, I'll just tell them you called me. I'll be right over!"];

			tree[645] = ["Lucario!\nWhere have\nyou been?"];
			tree[646] = ["#luca09#Sorry, I've been at work all week! This pup just can't catch a break..."];
			tree[647] = ["#luca08#...But, I know I've sort of been tough to get a hold of lately! I'll try to swing by later, okay?"];
			tree[648] = ["#luca04#Keep my seat warm for me until then! Bye " + stretch(PlayerData.name) + "~"];
		}

		{
			tree[650] = ["Magnezone"];
			if (ItemDatabase.isMagnezonePresent())
			{
				tree[651] = ["#hera06#Gwehh? But... But Magnezone is right here. You don't need to use a phone for that."];
				tree[652] = ["%buy%"];
				tree[653] = ["%call-magn%"];
				tree[654] = ["#hera02#...Oh! But I DO need to take your money. Gweh! Heh! Heh!"];
				tree[655] = ["#hera05#Hey! Magnezone!!!"];
				tree[656] = ["#magn05#...?"];
				tree[657] = ["#hera04#<name> wants to hang out!"];
				tree[658] = ["#magn04#Oh! ...Very well."];
				tree[659] = ["#magn14#" + MagnDialog.MAGN + " will be available shortly, " + MagnDialog.PLAYER + ". I just need to finish transmitting Heracross's inventory data to headquarters. -bweep- -boop-"];
			}
			else
			{
				tree[651] = ["%buy%"];
				tree[652] = ["%call-magn%"];
				tree[653] = ["#zzzz04#(Ring, ring...)"];
				tree[654] = ["#magn04#Beeboop? Bwoop, boop... SkreooOOONNNKK!! ... ...KSSSHHHHHHHH! KSSSSHHHHHHH SHHH!! KSSSSSSHHHHHHNK! KSSSSHHHH!!! KSSS KSSSSSHHHH!"];
				tree[655] = [660, 665, 670, 675, 680, 685, 690, 695];
				FlxG.random.shuffle(tree[655]);
				tree[655] = tree[655].splice(0, 4);

				tree[660] = ["Aaaagh!\nI'm not\na fax\nmachine!"];
				tree[661] = ["#magn04#Fzzt? Oh, it's you, " + MagnDialog.PLAYER + ". ...I was wondering why you didn't exchange your PGP key when prompted. ..." + MagnDialog.MAGN + " is not used to being contacted by organics."];
				tree[662] = ["#magn06#... ...How is " + MagnDialog.HERA + " doing? Is he adherent to the policies I've set in place for him? ... ..." + MagnDialog.MAGN + " should check on him, just in case."];
				tree[663] = ["#magn02#Perhaps if " + MagnDialog.PLAYER + " is available, we can schedule a maintenance session as well. 0000~"];

				tree[665] = ["Owwwww\nmy ears!!!"];
				tree[666] = ["#magn07#-ANALOG SIGNAL OVERRIDE- Oh. It's you. -fzzt- 0001 1100 1001 1111aebf:invalid character (COMMENCING ANALOG GREETING)"];
				tree[667] = ["#magn05#Hello."];
				tree[668] = ["#magn04#... ...Was this unconventional digital greeting " + MagnDialog.PLAYER + "'s way of reminding me of my upcoming service appointment? ..." + MagnDialog.MAGN + " is on the way."];

				tree[670] = ["Stop it!\nOw! Oww!\nOrganic\ncommunication\nonly!"];
				tree[671] = ["#magn08#\"Organic Communication Only!?\" ... ...That's a rather hurtful way of putting it. -bzzrt- " + MagnDialog.MAGN + " is &lt;hurt&gt;."];
				tree[672] = ["#magn06#" + MagnDialog.MAGN + " will schedule an emergency compu-emotional repair session with his service technician immediately."];
				tree[673] = ["#magn05#Wait. ...Aren't you " + MagnDialog.MAGN + "'s compu-emotional repair technician? ...Awkward... ... Awkward... ... -bweeeoop-"];

				tree[675] = ["Hello\nMagnezone!"];
				tree[676] = ["#magn05#-ANALOG SIGNAL OVERRIDE- Oh. Hello " + MagnDialog.PLAYER + ". ...Was this your way of testing " + MagnDialog.MAGN + "'s organic reply database? Is " + MagnDialog.MAGN + " compliant?"];
				tree[677] = ["#magn15#...Perhaps " + MagnDialog.MAGN + " will stop by for some... -fzzt- maintenance, just in case. One can never be too compliant."];
				tree[678] = ["#magn03#" + MagnDialog.MAGN + " will see you soon, " + MagnDialog.PLAYER + ". -bweeeooop-"];

				tree[680] = ["KSHHH!\nSHH-SHHHNK!!\nSHHHHHH\nSHHHHHH!!!"];
				tree[681] = ["#magn03#" + MagnDialog.PLAYER + "! "  + MagnDialog.PLAYER + "!!! You are fluent in UTF-8!?! ...Why have you been employing such an outdated communication protocol up until now! 0011 1100 1010 1100~"];
				tree[682] = ["#magn02#" + MagnDialog.MAGN+ " will come over immediately. We have so much data to exchange! KSHHHHHNK! KSSHHH SHHHHHH SHHHHHHNK- KSHHHHHHHHT!"];
				tree[683] = ["#magn03#KSHHHHHHH KSHHHHHHHHHHHNK! SHHHHH!!! SHHHHHHHHHH SHHHHHHHHHHHHNKT KSHHHHHH! KSSSHHHH KSSSHHHHHHHHHHHHHHH KSSSSSSSSSHHHHHHHHNK!!! KSHH! --KKKKSSSSSHHHHNKT~"];

				tree[685] = ["Ack!\nWrong number!\nWrong number!"];
				tree[686] = ["#magn06#...Wrong number? But this is " + MagnDialog.MAGN + "'s number. -TRACING- ... ... ... -TRACING- ... ... ..."];
				tree[687] = ["#magn04#Ah. It's " + MagnDialog.PLAYER + ", my dedicated service technician. ...You are indicating that " + MagnDialog.MAGN + "'s number is \"Wrong\"? -fzzzzt-"];
				tree[688] = ["#magn14#" + MagnDialog.MAGN + " will schedule a service appointment shortly."];

				tree[690] = ["I don't\nspeak\ncomputer"];
				tree[691] = ["#magn04#Ah. It's you, " + MagnDialog.PLAYER + ". ..." + MagnDialog.MAGN + " assumed he was being contacted by one of his mechanical friends."];
				tree[692] = ["#magn10#D-don't look at " + MagnDialog.MAGN + " that way! ...Of course " + MagnDialog.MAGN + " has many friends other than " + MagnDialog.PLAYER + ". -fzzzt-... ..."];
				tree[693] = ["#magn14#...What is " + MagnDialog.PLAYER + " doing later? Perhaps " + MagnDialog.MAGN + " will come by. ... ...If he is not busy with his numerous other friends. -bweeeooop-"];

				tree[695] = ["Beep boop!\nBeep boop\nboop."];
				tree[696] = ["#magn12#...! Who is this! " + MagnDialog.PLAYER + "!? Is that your voice? " + MagnDialog.PLAYER + "? " + MagnDialog.PLAYER + "?"];
				tree[697] = ["#magn06#Hmph. " + MagnDialog.MAGN + " does NOT sound like that. That is offensive on so many levels. -fzzzzt- -frz-cracckkle- [[MAGN.EMOTION_MASK |= EMOTION_CONSTANTS.DISAPPOINTED]]"];
				tree[698] = ["#magn04#" + MagnDialog.MAGN + " will be by shortly to educate you on matters of &lt;Mechanical Entity Sensitivity&gt;. -beep boop- -beep boop boop-"];

				if (!PlayerData.heraMale)
				{
					DialogTree.replace(tree, 662, "Is he", "Is she");
					DialogTree.replace(tree, 662, "for him", "for her");
					DialogTree.replace(tree, 662, "on him", "on her");
				}

				if (!PlayerData.magnMale)
				{
					DialogTree.replace(tree, 672, "with his", "with her");
					DialogTree.replace(tree, 693, "If he", "If she");
					DialogTree.replace(tree, 693, "with his", "with her");
				}
			}
		}
		{
			tree[700] = ["Grimer"];
			tree[701] = ["%buy%"];
			tree[702] = ["%call-grim%"];
			tree[703] = ["#zzzz04#(Ring, ring...)"];
			tree[704] = ["#zzzz05#(Ring, ring, ring...)"];
			if (FlxG.random.bool(33))
			{
				tree[705] = ["#grim06#Ehh? Sorry, glarp... ... I think you've got the wrong number."];
				tree[706] = ["#grim02#Oh, <name>!!! Whoa, errrr... Did you call me on purpose?"];
				tree[707] = ["#grim03#...I wasn't a pocket dial? It wasn't a wrong number!? Wow! It's a real phone call! Barppp!"];
				tree[708] = ["#grim07#Oh errr, I don't know what to do! What do I say!?!"];
			}
			else if (FlxG.random.bool(50))
			{
				tree[705] = ["%noop%"];
				tree[706] = ["#grim06#Eh? Ohhhh if you're trying to reach Beedrill, she changed her number..."];
				tree[707] = ["#grim02#Wait, <name>, is that you!? Wow! It's someone I know!!! ...I'm not used to getting phone calls from someone I know! Gwohohohohorf~"];
				tree[708] = ["#grim07#So err what happens now? I'm not sure what I'm supposed to say when I get a phone call!"];
			}
			else
			{
				tree[705] = ["#grim06#Ohhh, hey <name>! Sorry... you dialed the wrong number didn't you?"];
				tree[706] = ["#grim05#You were trying to reach Lucario, right? ...Or Buizel? Or Abra or Grovyle or Rhydon or Smeargle?"];
				tree[707] = ["#grim04#...It's okay! You don't have to hang out with me just because of a wrong number. ...See you later."];
				tree[708] = ["#grim02#Wait, were you really calling me on PURPOSE!? <name>! ...Glop!! This is so cool, I don't know what to say!!"];
			}
			tree[709] = [710, 715, 720, 725, 730, 735, 740, 745];
			FlxG.random.shuffle(tree[709]);
			tree[709] = tree[709].splice(0, 4);

			tree[710] = ["Oh, stop\nplaying hard\nto get~"];
			tree[711] = ["#grim10#Blop! Me? Hard to get? No, no! I'm not hard to get, I'm easy to get!! I'll make it so easy for you!"];
			tree[712] = ["#grim07#I'll be there in like... Aaa! Like five minutes, so you can get me! Just be patient! Don't get anybody else! Well you can get them a little, just leave some for me! Glooop!!"];

			tree[715] = ["Say\nyou'll come\nvisit me!"];
			tree[716] = ["#grim01#Aaaaah, <name>! Of course I'll come visit you!"];
			tree[717] = ["#grim06#I was just trying not to get on everyone's nerves too much, just 'cause of you know... The smell and stuff... ..."];
			tree[718] = ["#grim05#I'm going to toss in a few sticks of deodorant, okay! I'll be over in a few minutes! Bloop!"];

			tree[720] = ["Say you'll\ncome over\nto Abra's!"];
			tree[721] = ["#grim05#Ohhhhhh... Really? You guys actually want me there? Are you sure? Hrrrrrrmmm..."];
			tree[722] = ["#grim02#Well errrr, okay! I'll be right over. Thanks for inviting me <name>! ...It's nice to feel wanted. Glurp!"];

			tree[725] = ["Say you're\nfree tonight!"];
			tree[726] = ["#grim01#Of course I'm free! I'm always free when you're free, <name>. ...Wait, are you free!?!"];
			tree[727] = ["#grim03#Oh my goo! I'm on my way over, just sit tight okay!? Gwohohohohorf!"];

			tree[730] = ["Oops! I was\ntrying to\ncall Lucario"];
			tree[731] = ["#grim04#Errrrrr? Wait, is Lucario coming over? I never get to hang out with Lucario!"];
			tree[732] = ["#grim05#It seems like every time I come over, he needs to go for a jog, or pick up groceries, or vomit uncontrollably!!"];
			tree[733] = ["#grim02#...Well errr, even if you didn't invite me, I'm going to come over and say hi anyway! Tell Lucario to wait, okay? Gwohohohorf~"];

			tree[735] = ["Just get\nyour gooey\nbutt over\nhere!"];
			tree[736] = ["#grim01#Ohhhhh for you <name>? I'll stick my gooey butt just about anywhere! Gwohohohohorf~"];
			tree[737] = ["#grim04#Just sit tight, I'll errrrrr... I'll be over in a few minutes! Thanks for calling me, <name>~"];

			tree[740] = ["Any chance\nyou can\ncome over?"];
			tree[741] = ["#grim03#Oh I errr, well let me just check my calendI'M ON MY WAY!"];
			tree[742] = ["#grim02#Seriously, just give me like... five minutes! I can only scooch so fast! Blorp!"];

			tree[745] = ["Want to\nhelp me\nmake a\nvideo?"];
			tree[746] = ["#grim03#Gwohohohohorf! Do I ever!?!?! I'm on my way! Wow!"];
			tree[747] = ["#grim02#I am sooooo glad I answered my phone. Sometimes I just let it go to voice mail!! Errrr, thanks for calling me, <name>!"];

			if (!PlayerData.lucaMale)
			{
				DialogTree.replace(tree, 732, "he needs", "she needs");
			}
		}
		{
			tree[750] = ["Heracross"];
			tree[751] = ["%buy%"];
			tree[752] = ["%call-hera%"];
			if (FlxG.random.bool(33))
			{
				tree[753] = ["#hera10#I ehh... You want to call ME!?!?! I don't know if that will, ummmmm... ... Well let's just see what happens!"];
				tree[754] = ["#zzzz08#(beeeeep, beeeeep, beeeeeep, beeeeep...)"];
				tree[755] = ["#hera11#Ack! It's a busy signal! What do I dooooo!?! Gweh! Gwehhhhhh!! " + stretch(PlayerData.name) + "!!!"];
			}
			else if (FlxG.random.bool(50))
			{
				tree[753] = ["#hera01#Oh! You want to call me? Really? Oh! Let me just ummm.... What's my phone number again? Okay, okay..."];
				tree[754] = ["#zzzz08#(beeeeep, beeeeep, beeeeeep, beeeeep...)"];
				tree[755] = ["#hera11#Nooo, It's busy!! Why is it busy!?! Gweh! Gwehhhh!!! " + stretch(PlayerData.name) + "!!!"];
			}
			else
			{
				tree[753] = ["#hera07#Heracross!?! But... But that's my name! You mean ME!?! Gweh! Gwehhhh!!! Well let me try dialing it..."];
				tree[754] = ["#zzzz08#(beeeeep, beeeeep, beeeeeep, beeeeep...)"];
				tree[755] = ["#hera11#Busy!? Why is it busy! <name>! " + stretch(PlayerData.name) + "!!! I promise I'm not busy! Gwehhhhhh!"];
			}
			tree[756] = [760, 765, 770, 775, 780, 785, 790, 795];
			FlxG.random.shuffle(tree[756]);
			tree[756] = tree[756].splice(0, 4);

			tree[760] = ["Can't you\nclose the\nstore? There's\nno merchandise\nleft"];
			tree[761] = ["#hera10#Gweh! But... But who'll sell all the mystery boxes! Mystery boxeeeeeees! " + stretch(PlayerData.name)+ "!!"];
			tree[762] = ["#hera08#Okay, okay! It's not a big deal, I'll see if Kecleon can cover the store for me again... Hmmmmm..."];
			tree[763] = ["#hera09#<name>! Just wait a few minutes, okay? ...Don't... ...Don't stop wanting me!! Gweh! I'll be out in a minute!"];

			tree[765] = ["Let's do\nit right\nhere on\nthe table~"];
			tree[766] = ["#hera07#But... <name>, I can't just do it in the middle of my STORE!!! That's.... gwehhh!!!"];
			tree[767] = ["#hera06#Just wait out there for a minute, okay? We'll do it in the privacy of the living room, where everyone can see! And where all the cameras are~"];
			tree[768] = ["#hera05#Give me a few minutes! I'll be right behind you, I just need to go bug Kecleon first."];

			tree[770] = ["Let's go\nmake another\nvideo!"];
			tree[771] = ["#hera00#Another... another video? Ooooooughhhh~"];
			tree[772] = ["#hera03#I'll be out there in like five minutes, okay!?! There's just one little thing I have to do first."];
			tree[773] = ["#hera02#Go ummm... Go solve a few puzzles!! Thanks <name>! ...I really need to fix this phone..."];

			tree[775] = ["Can't you\nget Kecleon\nto cover\nfor you?"];
			tree[776] = ["#hera15#Ehh... Oh! Oh yeah! Kecleon! KECLEEOOOOOON! GET OVER HERE!"];
			tree[777] = ["#hera09#Gwehh! I don't think he can hear me while I'm cooped up down here... Gweh! Gwehhhhhh!"];
			tree[778] = ["#hera10#<name>, why don't you go do some puzzles, and I'll try to track down Kecleon, okay!? I'll be quick!"];

			tree[780] = ["Try the\nnumber\nagain!"];
			tree[781] = ["#hera07#It's not working, I can't reach me! Aaaaaaaaaaaaaaugh!"];
			tree[782] = ["#hera06#Wait, what am I doing. I'm right here! I don't need a phone. Hmmm... Hey Heracross!"];
			tree[783] = ["#hera02#Heracross, <name> wants to hang out with you! Okay, thanks Heracross! Tell him I'll be out in five minutes. ...Phew!"];

			tree[785] = ["Oh, nevermind.\nIt's too much\ntrouble"];
			tree[786] = ["#hera10#No, wait, wait! Just... Just give me a few minutes to get the phone working, gweh!!!"];
			tree[787] = ["#hera08#I'll be out in a few minutes, once I figure out this busy signal problem so I can get a hold of myself!"];
			tree[788] = ["#hera11#Don't give up on meeeeeeeeeeee! " + stretch(PlayerData.name) + "! Gwehhhh!"];

			tree[790] = ["When can I\nplay with\nYOUR mystery\nbox~"];
			tree[791] = ["#hera07#<name>, how can you be thinking about MYSTERY BOXES at a time like... Wait..."];
			tree[792] = ["#hera00#You mean... *my* mystery box? You mean like... my *sexy* mystery box?? Oooughhh~"];
			tree[793] = ["#hera01#Well I don't want to spoil the mystery! But why don't you solve a few puzzles and maybe... maybe I'll let you peek inside! Gweheheheh~"];

			tree[795] = ["I want to do\nsome hera-\ncrossbreeding"];
			tree[796] = ["#hera00#You... you what? Oooooughhh, well I like the sound of that!"];
			tree[797] = ["#hera01#Hmmm, hmmm.... I guess I can figure out all this phone stuff later! Just give me a few minutes to close up shop. See you soon, <name>~"];

			if (!PlayerData.keclMale)
			{
				DialogTree.replace(tree, 777, "he can", "she can");
			}
			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				DialogTree.replace(tree, 783, "Tell him", "Tell her");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				DialogTree.replace(tree, 783, "Tell him", "Tell them");
			}
		}
		{
			tree[800] = ["Kecleon"];
			tree[801] = ["%buy%"];
			tree[802] = ["%call-hera%"];
			tree[803] = ["#zzzz04#(Ring, ring...)"];
			if (FlxG.random.bool(33))
			{
				tree[804] = ["#kecl05#Ay, ehhh... What's shakin', <name>! You need somethin' from me?"];
			}
			else if (FlxG.random.bool(50))
			{
				tree[804] = ["#kecl05#Ehh? Oh hey <name>! What's goin' on?"];
			}
			else
			{
				tree[804] = ["#kecl05#Oh, <name>! That's weird, what are you callin' me for? You couldn't be bothered to like... walk up a single flight of stairs?"];
			}
			tree[805] = [810, 815, 820, 825, 830, 835, 840, 850];
			FlxG.random.shuffle(tree[805]);
			tree[805] = tree[805].splice(0, 4);

			tree[810] = ["Can you\nwatch the\nstore for\na minute?"];
			tree[811] = ["#kecl06#Watch the store? Oh ehhh yeah sure thing! I'll be right down after I finish ehhh... finish doin' the thing I'm doing."];
			tree[812] = ["#kecl00#I should be done in like ten minutes or so! ...Maybe five if I can't control myself. Keck-kekekek. Seeya around~"];

			tree[815] = ["How's\nSmeargle\ndoing!"];
			tree[816] = ["#kecl04#Smeargle? Ohhhhhhh... Smeargle's gettin' pretty exhausted! I think he could use a break soon."];
			tree[817] = ["#kecl06#Speakin' of which, maybe I can watch the store while he takes a nap! It's not like I'll be watchin' anything else while he's out."];
			tree[818] = ["#kecl02#I'll swing by in a few minutes. Take it easy <name>~"];

			tree[820] = ["Are you\nenjoying that\nretropie?"];
			tree[821] = ["#kecl02#Oh my god yeah! Are you kiddin' me? It's like every weekend we're playing thing! It's got so many frickin' games."];
			tree[822] = ["#kecl00#Sometimes I just sorta sneak behind Smeargle and cuddle him while he does single-player stuff too. But yeah, I owe you and Heracross big time!"];
			tree[823] = ["#kecl04#Speakin' of which ehhhhh, I guess it's been awhile since I covered the store for you guys! I'll try to swing by sometime soon to return the favor. Later, <name>~"];

			tree[825] = ["I was\nhoping to\nask you\na favor!"];
			tree[826] = ["#kecl02#Ahhhh you don't gotta spell it out, it's more alone time with Heracross isn't it? No problem! ...After everything you did for me?"];
			tree[827] = ["#kecl03#I mean, on top of helping Smeargle feel more sexually confident, but also that awesome gift you got the two of us... I dunno how I can ever repay you!"];
			tree[828] = ["#kecl00#So yeah I'll be right down. You and ehh... You and Heracross enjoy yourselves, okay? Keck-kekekeke~"];

			tree[830] = ["Any chance\nwe can\nhook up?"];
			tree[831] = ["#kecl06#Ehhh? By \"we\" you mean like, you and Heracross right? Yeah, that shouldn't be a problem!"];
			tree[832] = ["#kecl02#I mean, coverin' the store is the least I can do! You've been a really good friend to me and Smeargle. We both owe you big time!"];
			tree[833] = ["#kecl03#Anyway, take it easy <name>! You're a... You're a really good friend, alright? Seeya~"];

			tree[835] = ["I want\nto see\nyour penis"];
			tree[836] = ["#kecl06#Ehh yeah yeah! You mean like, you wanna see my penis in the store, coverin' for Heracross, so you twos can hook up right?"];
			tree[837] = ["#kecl02#Yeah it's no problem! Heracross usually comes to me with this stuff but... Yeah, don't think nothin' of it! I'm glad to help you two out."];
			tree[838] = ["#kecl03#Hey also, if you ever just like, wanna see me naked or wanna hook up or somethin', just gimme the word! I think Smeargle's openin' up to the idea. Peace~"];

			tree[840] = ["I want\nto have\nsex with\nyou"];
			tree[841] = ["#kecl06#Ahh yeah yeah! I get it! You mean like, you wanna have sex, while I'm present, right? Like sex with Smeargle, and I'm there too?"];
			tree[842] = ["#kecl02#Tell you what, I'll do you one better. I'll cover the store so you can have sex with that little... bug friend you're so fond of! Keck-kekekekeke."];
			tree[843] = ["#kecl03#I mean c'mon, Smeargle's around all the time, but this'll be a fun little treat! You can thank me later~"];
			tree[844] = ["#kecl05#Oh yeah and uhh, lemme know if you ever wanna hook up! I talked to Smeargle, and I think he's on board. Seeya, <name>!"];

			tree[850] = ["I want some\none-on-one\nlizard time!"];
			tree[851] = ["#kecl02#Ohhhh, yeah I'd love some one-on-one <name> time myself! I'll try to swing by the shop, okay?"];
			tree[852] = ["#kecl06#That way the two of us can talk about all sorts of things! Y'know, mystery boxes... The fact that I won't sell 'em to yas... That weird door that's always open..."];
			tree[853] = ["#kecl05#I wanna get to know the real you, <name>! ...Speakin' of which, Smeargle said it's cool if you and I wanna mess around a little. Not that you'd want to, but ehhh..."];
			tree[854] = ["#kecl00#Y'know, just if you're ever feeling frisky or whatever, gimme the word! Keck-kekekeke~"];

			if (!PlayerData.smeaMale)
			{
				DialogTree.replace(tree, 816, "he could", "she could");
				DialogTree.replace(tree, 817, "he takes", "she takes");
				DialogTree.replace(tree, 817, "he's out", "she's out");
				DialogTree.replace(tree, 822, "cuddle him", "cuddle her");
				DialogTree.replace(tree, 822, "while he", "while she");
				DialogTree.replace(tree, 844, "he's on", "she's on");
			}

			if (!PlayerData.keclMale)
			{
				DialogTree.replace(tree, 835, "penis", "pussy");
				DialogTree.replace(tree, 836, "penis", "pussy");
			}
		}
		{
			tree[900] = ["Sandslash"];
			tree[901] = ["%buy%"];
			tree[902] = ["%call-sand%"];
			var count:Int = PlayerData.recentChatCount("hera.callSandslash");

			if (count == 0)
			{
				tree[903] = ["#hera06#...Wait... ...What's Sandslash's number doing here!?! Hold on..."];
				tree[904] = ["#zzzz04#(Ring, ring...)"];
				tree[905] = ["#sand06#Hello?"];
				tree[906] = ["#hera13#Sandslash! ...Did you add your number to my special shop phone!?!"];
				tree[907] = ["#sand03#Awwww damn I was wonderin' whose number this was! Heh! Heh! Heh. This is fuckin' hilarious!!!"];
				tree[908] = ["#hera12#..."];
				tree[909] = ["#sand02#Heh! heh... Wait, does that mean <name>'s there?"];
				tree[910] = ["#hera11#Yes? Well I mean no. I mean... Don't change the subject!"];
				tree[911] = ["#hera14#This phone's just supposed to be for special Pokemon who don't--"];
				tree[912] = ["#sand05#--Yeah yeah alright, I'm comin' down. Tell <name> I'll be there in a second."];
				tree[913] = ["#zzzz12#(Click...)"];
				tree[914] = ["#hera06#Euuugh. Give me a second to reprogram this phone and I'll let you make a second phone call."];
				tree[915] = ["#hera04#Of course I'll have to charge you a second time... Because that's just how the phone company, umm...."];
				tree[916] = ["#hera06#... ..."];
				tree[917] = ["#hera12#H-hey, don't give me that look! I'm just annoyed about this whole situation as you are."];
			}
			else if (count % 3 == 1)
			{
				tree[903] = ["#hera11#...Sandslash!? You mean... Gwehhh!"];
				tree[904] = ["#hera06#How does he keep messing with this thing!? Even after I hid it in my super-secret place..."];
				tree[905] = [925, 915, 920, 910];

				tree[910] = ["...In your\nsupply\ncloset?"];
				tree[911] = ["#hera10#Wh-what!?! How did you know!!!"];
				tree[912] = ["#hera11#I thought my secret place was a little more secret than that. Gwehh!!!"];
				tree[913] = [930];

				tree[915] = ["...In your\nbutt?"];
				tree[916] = ["#hera14#No, tucked away in the back of my supply closet!"];
				tree[917] = ["#hera06#...How well do you know Sandslash, anyways? He would DEFINITELY check my butt."];
				tree[918] = [930];

				tree[920] = ["...Super-secret\nplace?"];
				tree[921] = ["#hera10#...Well I'm sure as heck not telling you about my super-secret place, you'll just blab to Sandslash!"];
				tree[922] = ["#hera14#I've got my eye on you two, you know..."];
				tree[923] = [930];

				tree[925] = ["..."];
				tree[926] = ["#hera14#Oh whatever, I'll just call him..."];
				tree[927] = [930];

				tree[930] = ["#zzzz04#(Ring, ring...)"];
				tree[931] = ["#sand03#Ay sweet, I'll be down in a sec! (...click)"];
				tree[932] = ["#hera13#Don't hang up, I... HEY!!!"];
				tree[933] = ["#hera12#... ..."];
				tree[934] = ["#hera15#Hurry and pay me for another phone call, <name>!!! ...I need to tell Sandslash how angry I am!"];

				if (!PlayerData.sandMale)
				{
					DialogTree.replace(tree, 904, "does he", "does she");
					DialogTree.replace(tree, 917, "He would", "She would");
					DialogTree.replace(tree, 926, "call him", "call her");
				}
			}
			else if (count % 3 == 2)
			{
				tree[903] = ["#hera11#...Sandslash!? Not again!!!"];
				tree[904] = ["#zzzz04#(Ring, ring...)"];
				tree[905] = ["#sand02#Yo, what's up?"];
				tree[906] = ["#hera13#For the love of cranberries will you STOP putting your number on my--"];
				tree[907] = ["#sand03#Ayy sweet I'm comin' down! (...click)"];
				tree[908] = ["#hera15#... ...!"];
				tree[909] = ["#hera12#It's like I'm talking to a brick wall..."];
			}
			else
			{
				tree[903] = ["#hera11#...Wh-what!?! Gwehhh!!!"];
				tree[904] = ["#zzzz04#(Ring, ring...)"];
				tree[905] = ["#zzzz06#(Ring, ring, ring...)"];
				tree[906] = ["#zzzz08#(Ring, ring...)"];
				tree[907] = ["#hera10#Ehh? ...It's going to voice mail. Ummm... ... (...click)"];
				tree[908] = ["#hera09#..."];
				tree[909] = ["#hera11#... ...I hate leaving voice mails!"];
			}
		}
	}
}