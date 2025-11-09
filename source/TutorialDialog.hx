package;

import MmStringTools.*;
import critter.Critter;
import flixel.FlxG;
import minigame.MinigameState;
import minigame.MinigameState.denNerf;
import openfl.utils.Object;

/**
 * Dialog for the puzzle tutorials and minigame tutorials.
 */
class TutorialDialog
{
	public static function tutorialNovice(tree:Array<Array<Object>>):Void
	{
		if (PlayerData.level == 0
		|| PlayerData.level >= 3 // player just entered a password; skipped to level 3/4
		   )
		{
			tree[0] = ["#grov05#Nice to meet you! I'm sure you're anxious to get your hands dirty but first, let me explain how these puzzles work."];
			if (PlayerData.name != null)
			{
				// repeating tutorial
				tree[0] = ["#grov05#Ah, hello again! I'm sure you're once again anxious to get your hands dirty but first, let me explain how these puzzles work."];
			}
			tree[1] = ["%enable-skip%"];
			tree[2] = ["%cube-clue-critters%"];
			tree[3] = ["%lights-dim%"];
			tree[4] = ["%light-on-wholeanswer%"];
			tree[5] = ["#grov04#The goal is to drop the correct colored bugs in this box up here! Do that and you complete the puzzle."];
			tree[6] = ["%light-off-wholeanswer%"];
			tree[7] = ["%lights-on-wholeclue%"];
			tree[8] = ["#grov05#Each of these other rows is a clue-- an incorrect guess which most definitely will NOT complete the puzzle."];
			tree[9] = ["%lights-off-wholeclue%"];
			tree[10] = ["%lights-on-rightclue%"];
			tree[11] = ["#grov04#Alongside each guess we show how many bugs in that guess are correct. Each heart indicates one correct bug. The position of the bugs doesn't affect the solution."];
			tree[12] = ["%lights-off-rightclue%"];
			tree[13] = ["%light-on-wholeclue0%"];
			tree[14] = ["#grov05#So for example, looking at this first clue, \"red, red, blue\" has two correct bugs. It's actually only ONE bug away from the correct answer!"];
			tree[15] = ["#grov06#The solution might have a purple and two reds... or a purple, red and a blue... or two blues and a red, for example. Hmm, there are other possibilities too."];
			tree[16] = ["%prompts-y-offset+30%"];

			tree[17] = ["#grov03#But come to think of it, you can deduce something important just from that one clue, can't you?"];
			tree[18] = [40, 50, 30];

			tree[30] = ["The solution\nhas a red"];
			tree[31] = ["#grov02#Yes, spot on! If there were no reds in the solution, it would be impossible for this first clue to yield two hearts."];
			tree[32] = [100];

			tree[40] = ["The solution\nhas a blue"];
			tree[41] = ["#grov15#Err, not necessarily! Something like \"red, red, red\" would still result in two hearts for this first clue, right?"];
			tree[42] = ["#grov06#So just looking at this clue in isolation for a moment, it's certainly possible to get two hearts without having any blues in the solution."];
			tree[43] = ["#grov04#However, the solution definitely has to have a red in it. If the solution had zero reds, it would be impossible for this clue to yield two hearts."];
			tree[44] = [100];

			tree[50] = ["The solution\nhas a purple"];
			tree[51] = ["#grov15#Err, not necessarily! Something like \"red, red, red\" would still result in two hearts for this first clue, right?"];
			tree[52] = ["#grov06#So just looking at this clue in isolation for a moment, it's certainly possible to get two hearts without having any purples in the solution."];
			tree[53] = ["#grov04#However, the solution definitely has to have a red in it. If the solution had zero reds, it would be impossible for this clue to yield two hearts."];
			tree[54] = [100];

			tree[100] = ["%lights-on%"];
			tree[101] = ["#grov05#I'll just grab one of these red bugs. The position doesn't matter, so I can just drop it anywhere I want..."];
			tree[102] = ["%move-peg-from-red-to-answerempty%"];
			tree[103] = ["#grov02#There we are! And the puzzle's already one-third complete."];
			tree[104] = ["#grov04#So, do you think you can handle it from here?"];
			tree[105] = [130, 120, 140];

			tree[120] = ["Yes, it\nseems easy"];
			tree[121] = ["#grov02#Wonderful! I'll just get out of your way then. Fill up the remaining boxes and let's see how you do."];

			tree[130] = ["Maybe, what\ncomes next?"];
			tree[131] = ["%lights-dim%"];
			tree[132] = ["%light-on-wholeclue2%"];
			tree[133] = ["#grov05#Well hmm... Let's look at this third clue next. We know there's a red bug in the solution right? That's why there's one heart here."];
			tree[134] = ["#grov06#But if there were any more reds or purples in the solution... wouldn't that break this third clue? What do you think?"];
			tree[135] = [160, 180, 170];

			tree[140] = ["No, I\nneed help"];
			tree[141] = ["%lights-dim%"];
			tree[142] = ["%light-on-wholeclue2%"];
			tree[143] = ["#grov05#Sure, let's look at this third clue!"];
			tree[144] = ["#grov02#We've already figured out that there's a red bug in the solution right? And aha, that one heart next to the third clue must correspond to the red we've already placed!"];
			tree[145] = ["#grov06#But hmm, if there were any more reds or purples in the solution... wouldn't that break this third clue? What do you think?"];
			tree[146] = [160, 180, 170];

			tree[160] = ["The solution\ncan't have\nany more reds\nor purples"];
			tree[161] = ["%lights-on%"];
			tree[162] = ["#grov02#That's right! The solution can't have any more reds or purples in it. So we've greatly narrowed it down, yes?"];
			tree[163] = ["#grov04#See if you can figure out the answer, and drop the remaining bugs in their corresponding boxes. Good luck!"];

			tree[170] = ["The solution\nmust have\nat least\none more red"];
			tree[171] = ["#grov15#Well hmm... Let's think this through! What if the correct answer had two red bugs in it? Why, the third clue would have two bugs correct, and two hearts."];
			tree[172] = ["#grov04#It would have two hearts because two bugs would match-- the two red bugs. But it only has one heart! So, there must not be two red bugs in the solution."];
			tree[173] = ["#grov05#And actually, you can use the same logic to determine there's no purples either!"];
			tree[174] = ["%lights-on%"];
			tree[175] = ["#grov04#So given that there's no more reds or purples in the solution... that greatly narrows down the choices, yes?"];
			tree[176] = ["#grov02#Give it some thought, see if you can figure out the answer. Fill up the remaining boxes as best you can and let's see how you do!"];

			tree[180] = ["The solution\nmust have\nat least\none purple"];
			tree[181] = ["#grov15#Well hmm... Let's think this through! What if the correct answer had a red and a purple in it? Why, the third clue would have two bugs correct, and two hearts."];
			tree[182] = ["#grov04#It would have two hearts because two bugs would match-- the red bug and the purple bug. But it only has one heart! So, there must not be any purples in the solution."];
			tree[183] = ["#grov05#And actually, you can use the same logic to determine there's no more reds either! Just the one we've already placed."];
			tree[184] = ["%lights-on%"];
			tree[185] = ["#grov04#So given that there's no more reds or purples in the solution... that greatly narrows down the choices, yes?"];
			tree[186] = ["#grov02#Give it some thought, see if you can figure out the answer. Fill up the remaining boxes as best you can and let's see how you do!"];

			tree[200] = ["%mark-startover%"];
			tree[201] = ["#grov05#Ah, sure thing! Let me just reset the puzzle how it was..."];
			tree[202] = ["%reset-puzzle%"];
			tree[203] = ["%lights-dim%"];
			tree[204] = ["%light-on-wholeanswer%"];
			tree[205] = ["#grov04#So the goal is to drop the correct colored bugs in these boxes up here! Do that and you complete the puzzle."];
			tree[206] = [6];

			tree[210] = ["%mark-skipwithpassword%"];
			tree[211] = ["%skip%"];
			tree[212] = ["%skip%"];
			tree[213] = ["%skip%"]; // skip to non-existent level 3/4; this signals certain things to happen when repeating tutorial dialog
			tree[214] = ["#grov04#I'm sure you remember how these puzzles work, so I won't bother explaining them."];
			tree[215] = ["#grov03#...Although if for some reason you require an explanation, you can always summon my assistance with that button in the corner."];
			tree[216] = ["#grov02#It's good to see you again, <name>~"];

			tree[10000] = ["%lights-on%"];
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["%noop%"]; // don't move this bit to the end
			tree[1] = ["%cube-clue-critters%"];
			tree[2] = ["#grov06#Now this one's a substantial step up in difficulty isn't it? So many different clues..."];
			tree[3] = ["%lights-dim%"];
			tree[4] = ["%light-on-wholeclue1%"];
			tree[5] = ["%prompts-y-offset-70%"];
			tree[6] = ["#grov04#Ah, but right away we can figure out something from the second clue, hmm?"];
			tree[7] = [30, 20, 40];

			tree[20] = ["The solution\ncan't have any\nblues or reds"];
			tree[21] = ["%lights-on%"];
			tree[22] = ["#grov02#Right! Now you might be wondering what that signpost with the red \"X\" is there for. That's just a helpful way to take notes for these more complicated puzzles."];
			tree[23] = ["%move-peg-from-blue-to-367x239%"];
			tree[24] = ["%move-peg-from-red-to-397x240%"];
			tree[25] = ["#grov04#There, see? Dropping the blue and red bugs here will help me remember that these colors aren't in the solution."];
			tree[26] = ["#grov05#I think I can tell from your impatient clicking that you're anxious for this tutorial to end so, I'll stop talking for a moment. Hah! Heheheh."];

			tree[30] = ["The solution\nmust have either\na blue or a red"];
			tree[31] = ["#grov06#Well, let's think this through. What if the solution had a blue in it? Why, the second clue would have one heart in it for the matching blue. But it doesn't have any!"];
			tree[32] = ["%lights-on%"];
			tree[33] = ["#grov04#No, the answer certainly can't have any blues in it. Nor can it have any reds, for that matter!"];
			tree[34] = ["#grov05#Now, you might be wondering what that signpost with the red \"X\" is there for. That's just a helpful way to take notes for these more complicated puzzles."];
			tree[35] = [23];

			tree[40] = ["The solution\nmust have both\na blue and a red"];
			tree[41] = [31];

			tree[100] = ["%mark-startover%"];
			tree[101] = ["#grov05#Ah, sure thing! Let me just reset the puzzle how it was..."];
			tree[102] = ["%reset-puzzle%"];
			tree[103] = ["#grov06#So yes, this one's a substantial step up in difficulty isn't it? So many different clues..."];
			tree[104] = [3];

			tree[10000] = ["%lights-on%"];
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["#grov04#I'm fully undressed, but as you can see there's still one final puzzle."];
			tree[1] = ["%cube-clue-critters%"]; // cube clue critters after dialog, to work around a glitch where critters jump into boxes prematurely
			tree[2] = ["%help-button-on%"];
			tree[3] = ["%lights-dim%"];
			tree[4] = ["%add-light-wq4oq24piy-location-730x000x038x034%"];
			tree[5] = ["#grov05#While I won't spoil what happens after this puzzle, I will call your attention to that funny-shaped button in the corner--"];
			tree[6] = ["#grov04#If you ever get completely stuck on a puzzle, you can always ask Abra if he'll give you some kind of hint as a last recourse."];
			tree[7] = ["%remove-light-wq4oq24piy%"];
			tree[8] = ["%lights-on%"];
			tree[9] = ["%help-button-off%"];
			tree[10] = ["#grov06#But for now, why don't we see if we can make do without his help. Hmm, yes, I'm already getting some ideas from that first clue... Hmm, hmm..."];

			tree[50] = ["%mark-startover%"];
			tree[51] = ["%help-button-on%"];
			tree[52] = ["%lights-dim%"];
			tree[53] = ["%add-light-wq4oq24piy-location-730x000x038x034%"];
			tree[54] = ["#grov05#Ah, sure thing! I just wanted to make sure you noticed that funny-shaped button in the corner--"];
			tree[55] = [6];

			tree[10000] = ["%remove-light-wq4oq24piy%"];
			tree[10001] = ["%lights-on%"];
			tree[10002] = ["%help-button-off%"];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 6, "if he'll", "if she'll");
				DialogTree.replace(tree, 10, "without his", "without her");
			}
		}

		tree[300] = ["%mark-rememberme%"];
		tree[301] = ["%disable-skip%"];
		tree[302] = ["#grov10#Ah well, err... Of course I remember! ...I have a remarkable knack for names, you know-- I've literally never forgotten a name."];
		tree[303] = ["#grov06#Yours is right on the top of my tongue... Hmm, hmm... You must be, err..."];
		tree[304] = [310, 315, 330];

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
		tree[331] = ["%enable-skip%"];
		tree[332] = ["#grov03#Ah, of course we haven't! ...Was that some sort of a test? ... ...Did I pass?"];

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
		else {
			tree[415] = ["#grov06#I think I remember that it rhymed with a part of the male anatomy... Jacques? ...Ernesticle? Hmmm, hmmm. It's coming to me..."];
		}
		tree[416] = [310, 315, 330];

		// someone else's name
		tree[420] = ["%mark-ijrtkh6l%"];
		tree[421] = ["%enable-skip%"];
		tree[422] = ["#grov13#You are NOT... That is NOT your name!! No! ...Bad! That's such a... You are the sneakiest little... Grrrggghhh!!!"];
		tree[423] = ["#grov12#I'm not sure if if I even want to play with you anymore, you sneaky little rascal. ...Pretending you're <random-name>... Hmph!"];
		tree[424] = ["#grov06#... ...I'm just going to proceed with the tutorial, and we can pretend this never happened-"];
		tree[425] = ["#grov12#-and perhaps YOU can stop trying to break this cute little game with your unwelcome shenanigans! Hmph! Hmph!!"];
		tree[426] = ["#grov03#Aaaanyways, let's see if we can get back to this puzzle, and forget this ever happened..."];

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
		tree[481] = ["%enable-skip%"];
		tree[482] = ["#grov10#Ah, well perhaps I'll eventually remember you without that eighteen character sequence! ... ...If something else were to jog my memory, hmm."];
		tree[483] = ["#grov04#...Well in the meantime, let's see what we can do with this puzzle~"];

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
		tree[553] = ["%enable-skip%"];
		tree[554] = ["%skip%"];
		tree[555] = ["%skip%"];
		tree[556] = ["%skip%"]; // skip to non-existent level 3; this signals certain things to happen when repeating tutorial dialog
		tree[557] = ["#grov02#Ah yes, <good-name>! Of course! ...I believe Abra unceremoniously stuffed your belongings in a closet somewhere back here..."];
		tree[558] = ["%enterabra%"];
		tree[559] = ["#grov05#Abra! ...Wouldn't you believe it? <good-name>'s returned to play with us!"];
		tree[560] = ["#abra02#Hmm? ...Oh, <good-name>! I hadn't seen you in awhile."];
		tree[561] = ["%exitabra%"];
		tree[562] = ["#abra05#...Give me a moment and I'll get your things back the way you had them, alright?"];
		tree[563] = ["#grov02#Well isn't this exciting! ...It's good to have you back again, <name>~"];

		if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			DialogTree.replace(tree, 326, "that guy! That guy", "that girl! That girl");
		}
	}

	public static function tutorial3Peg(tree:Array<Array<Object>>)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["%cube-clue-critters%"];
			tree[1] = ["#grov05#Hello again! This time, we're going to try out some harder puzzles where the ordering of the bugs affects the solution."];
			tree[2] = ["%lights-dim%"];
			tree[3] = ["%lights-on-rightclue%"];
			tree[4] = ["#grov03#But... We don't expect you to just guess, of course! These white dots and red hearts give you a little extra information, so you can determine logically where each bug goes."];
			tree[5] = ["%lights-off-rightclue%"];
			tree[6] = ["%light-on-wholeclue0%"];
			tree[7] = ["#grov04#A heart next to a clue indicates a bug with the correct color is also in the correct position. So, perhaps the solution has a purple in the center box."];
			tree[8] = ["%light-off-wholeclue0%"];
			tree[9] = ["%light-on-wholeclue2%"];
			tree[10] = ["#grov05#A dot next to a clue indicates a bug has the correct color, but it belongs somewhere different..."];
			tree[11] = ["#grov05#So hmm, perhaps the solution has a brown in the left or center box. Or perhaps both!"];
			tree[12] = ["%light-off-wholeclue2%"];
			tree[13] = ["%light-on-wholeclue1%"];
			tree[14] = ["#grov04#Although looking at the second clue, it appears the solution doesn't have any brown bugs at all! ...Nor does it have any blues or purples."];
			tree[15] = ["#grov06#I'll just drop those bugs by the red \"X\" signpost..."];
			tree[16] = ["%move-peg-from-blue-to-287x209%"];
			tree[17] = ["%move-peg-from-purple-to-347x210%"];
			tree[18] = ["%move-peg-from-brown-to-317x229%"];
			tree[19] = ["%light-off-wholeclue1%"];
			tree[20] = ["%light-on-wholeclue0%"];
			tree[21] = ["#grov02#And, eureka! With no purples or browns, this first clue lets us place our first bug, doesn't it?"];
			tree[22] = ["%prompts-y-offset+50%"];
			tree[23] = ["#grov05#After all, with no blues or purples in the solution, there must be a yellow to produce this heart. Although... Where does the yellow belong?"];
			tree[24] = [30, 40, 50, 60];

			tree[30] = ["The yellow\ngoes in the\nleft box"];
			tree[31] = ["%move-peg-from-yellow-to-answer0%"];
			tree[32] = ["#grov02#Yes, precisely! You catch on quickly, don't you?"];
			tree[33] = [100];

			tree[35] = ["One yellow\ngoes in the\nleft box"];
			tree[36] = [31];

			tree[40] = ["The yellow\ngoes in the\ncenter box"];
			tree[41] = ["#grov06#I suppose it's possible there's a second yellow in the center box... I can't think that far ahead! But, there must be a yellow in the left box."];
			tree[42] = ["%move-peg-from-yellow-to-answer0%"];
			tree[43] = ["#grov05#How can I tell? Well, the first clue's heart indicates that there's a bug in the correct position."];
			tree[44] = ["#grov04#That means the yellow bug must be in the correct position, seeing as there's no purples or blues."];
			tree[45] = [100];

			tree[47] = ["One yellow\ngoes in the\ncenter box"];
			tree[48] = [41];

			tree[50] = ["The yellow\ngoes in the\nright box"];
			tree[51] = ["#grov06#I suppose it's possible there's a second yellow in the right box... I can't think that far ahead! But, there must be a yellow in the left box."];
			tree[52] = ["%move-peg-from-yellow-to-answer0%"];
			tree[53] = ["#grov05#How can I tell? Well, the first clue's heart indicates that there's a bug in the correct position."];
			tree[54] = ["#grov04#That means the yellow bug must be in the correct position, seeing as there's no purples or blues."];
			tree[55] = [100];

			tree[57] = ["One yellow\ngoes in the\nright box"];
			tree[58] = [51];

			tree[60] = ["There's more\nthan one\nyellow"];
			tree[61] = ["%prompts-y-offset+50%"];
			tree[62] = ["#grov04#Er well... Perhaps! But we can at least place ONE of the two yellows in its correct box, can't we?"];
			tree[63] = [35, 47, 57];

			tree[100] = ["%lights-on%"];
			tree[101] = ["#grov05#So, do you think you can handle it from here?"];
			tree[102] = [130, 120, 140];

			tree[120] = ["Yes, it\nseems easy"];
			tree[121] = ["#grov02#Ah I see, I'm just in your way then aren't I? I'll leave you to it!"];

			tree[130] = ["Maybe, what\ncomes next?"];
			tree[131] = ["%lights-dim%"];
			tree[132] = ["%light-on-wholeclue3%"];
			tree[133] = ["#grov04#Well hmm... The fourth clue indicates there must be a red in the solution doesn't it?"];
			tree[134] = ["#grov06#With no browns or blues in the solution, there must be a red to produce this dot. But... Where does the red bug belong?"];
			tree[135] = ["%lights-on%"];
			tree[136] = ["#grov02#..Remember a white dot means the bug is in the wrong position. Give it some thought and see what you come up with! Good luck!"];

			tree[140] = ["No, I\nneed help"];
			tree[141] = ["%lights-dim%"];
			tree[142] = ["%light-on-wholeclue3%"];
			tree[143] = ["#grov04#Sure, let's look at this fourth clue! One of these three bugs is in the solution, since there's one dot here. And with no browns or blues in the solution, it must be the red!"];
			tree[144] = ["#grov05#But... Where does the red bug belong?"];
			tree[145] = [160, 170, 180, 190];

			tree[160] = ["The red\ngoes in the\nleft box"];
			tree[161] = ["#grov10#But, the yellow bug looks so comfortable in the left box! Certainly you're not expecting to cram two bugs in that tiny box?"];
			tree[162] = ["#grov06#The red bug needs to go in one of the two empty boxes. And actually, that dot in the fourth clue indicates the red bug is in the wrong position, doesn't it?"];
			tree[163] = ["#grov05#So unless I'm mistaken, the red bug can't go in the right box either."];
			tree[164] = [200];

			tree[170] = ["The red\ngoes in the\ncenter box"];
			tree[171] = ["%lights-on%"];
			tree[172] = ["%move-peg-from-red-to-answer1%"];
			tree[173] = ["#grov02#Sharp as a tack! There's no other logical place for the red bug, is there?"];
			tree[174] = [201];

			tree[180] = ["The red\ngoes in the\nright box"];
			tree[181] = ["#grov06#Well, that dot in the fourth clue indicates the red bug is in the wrong position, doesn't it?"];
			tree[182] = ["#grov05#If the answer had a red bug in the right box, that fourth clue would have a heart, not a dot. The red bug definitely doesn't go in the right box!"];
			tree[183] = [200];

			tree[190] = ["There's more\nthan one\nred"];
			tree[191] = ["#grov06#Well, that dot in the fourth clue indicates there's no red bug in the rightmost box, doesn't it?"];
			tree[192] = ["#grov05#If there were more than one red bug in the solution, that fourth clue would have a heart, not a dot. There's definitely only one red bug."];
			tree[193] = [200];

			tree[200] = ["%lights-on%"];
			tree[201] = ["#grov04#Anyways go ahead and experiment, see what you can come up with! Don't feel bad if it takes you a few tries, these puzzles take some getting used to. Good luck!"];

			tree[300] = ["%mark-startover%"];
			tree[301] = ["#grov05#Ah, sure thing! Let me just reset the puzzle how it was..."];
			tree[302] = ["%reset-puzzle%"];
			tree[303] = ["%lights-dim%"];
			tree[304] = ["#grov04#So for these harder puzzles, you can't put the bugs in any box you want anymore! The ordering of the bugs matters."];
			tree[305] = [3];

			tree[10000] = ["%lights-on%"];
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["%cube-clue-critters%"];
			tree[1] = ["#grov05#So hmmm... This puzzle looks rather tricky! I don't see any colors we can eliminate right off the bat..."];
			tree[2] = ["%lights-dim%"];
			tree[3] = ["%light-on-wholeclue1%"];
			tree[4] = ["#grov02#A-ha, although looking at the second clue I suppose one thing's certain... The solution has a purple in it!"];
			tree[5] = ["%lights-on%"];
			tree[6] = ["%prompts-dont-cover-clues%"];
			tree[7] = ["#grov04#Although hmmm... where does it belong in the solution?"];
			tree[8] = [20, 30, 40, 50, 60];

			tree[20] = ["The purple\nbelongs in\nthe left\nbox"];
			tree[21] = ["#grov05#Err, well let's see... With the second clue, if a purple were in the left box... I suppose that could mean a second purple could go in the right box..."];
			tree[22] = ["#grov06#Or, perhaps a red would go into the center box instead... Oh, but the red bug can't go in the center box because of the fourth clue... Tricky!"];
			tree[23] = [70];

			tree[30] = ["The purple\nbelongs in\nthe center\nbox"];
			tree[31] = ["#grov05#Err, well the first clue indicates the purple is in the wrong position. So it doesn't belong in the center box but..."];
			tree[32] = ["#grov06#...Hmm, it could really go in either of the two other boxes! It's a coin toss."];
			tree[33] = [70];

			tree[40] = ["The purple\nbelongs in\nthe right\nbox"];
			tree[41] = ["#grov05#Err, well let's see... With the second clue, if a purple were in the right box... I suppose that could mean a second purple could go in the left box..."];
			tree[42] = ["#grov06#Or perhaps a second purple could go in the center box... Oh but it can't go there, because of the first clue... Hmm, tricky!"];
			tree[43] = [70];

			tree[50] = ["I'm not\nsure"];
			tree[51] = ["#grov03#Hah! Heheheheh. To be honest, I'm not sure myself this time. It seems like that purple bug could go in one of two places..."];
			tree[52] = [70];

			tree[60] = ["There's\nmore than\none purple"];
			tree[61] = ["#grov05#Err, well the second clue could have two purples, but it might just have a purple and a red! Doesn't that work too?"];
			tree[62] = ["#grov06#Let's see... The red couldn't go in the middle box... And I suppose if it went in the right box, the second clue would have two hearts, so that's no good..."];
			tree[63] = ["#grov04#I'm not entirely sure if there's two purples yet! I can tell there's one, but I don't know where it goes."];
			tree[64] = [70];

			tree[70] = ["#grov05#Sometimes if I can't figure out where a bug goes in the solution, I'll just drop it by this green signpost."];
			tree[71] = ["%move-peg-from-purple-to-437x229%"];
			tree[72] = ["#grov03#It doesn't do anything meaningful, but it helps me to remember which bugs belong in the solution somewhere."];
			tree[73] = ["%lights-dim%"];
			tree[74] = ["%light-on-wholeclue0%"];
			tree[75] = ["#grov02#Although ooh! Now that we know there's a purple in the solution... We can do something with that first clue, can't we?"];
			tree[76] = ["%lights-on%"];
			tree[77] = ["#grov04#Hmm yes, I think you can take it from here! Let me know if you get stuck."];

			tree[300] = ["%mark-startover%"];
			tree[301] = ["#grov05#Ah, sure thing! Let me just reset the puzzle how it was..."];
			tree[302] = ["%reset-puzzle%"];
			tree[303] = ["#grov04#So, this puzzle looks rather tricky! I don't see any colors we can eliminate right off the bat."];
			tree[304] = [2];

			tree[10000] = ["%lights-on%"];
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["%lights-dim%"];
			tree[1] = ["%add-light-wq4oq24piy-location-664x002x064x030%"];
			tree[2] = ["%undo-buttons-on%"];
			tree[3] = ["#grov04#I think you're getting the hang of these puzzles now! Although, did you notice these undo/redo buttons in the corner?"];
			tree[4] = ["#grov05#They're helpful if you realize you've made a mistake. That way you can go back a few steps and try something different."];
			tree[5] = ["%remove-light-wq4oq24piy%"];
			tree[6] = ["%undo-buttons-off%"];
			tree[7] = ["%lights-on%"];
			tree[8] = ["#grov10#Or alternatively if you're really stuck... And of course I would never do this personally! But..."];
			tree[9] = ["#grov08#You could try GUESSING something, work forward from there, and undo everything if you hit a contradiction."];
			tree[10] = ["#grov14#Of course, I would never resort to something as barbaric as GUESSING my way through a puzzle! ...I mean, guessing!? Pish posh!!"];
			tree[11] = ["#grov03#I mean perhaps sometimes, if it's late... Or if I've had a little to drink..."];
			tree[12] = ["#grov00#I might occasionally be tempted to experiment... Do something irresponsible..."];
			tree[13] = ["#grov01#See where the puzzle takes me..."];
			tree[14] = ["#grov00#......"];
			tree[15] = ["#grov10#Ahh! Anyways, yes. Final puzzle is it? ...You can do it!"];

			tree[300] = ["%mark-startover%"];
			tree[301] = ["%lights-dim%"];
			tree[302] = ["%add-light-wq4oq24piy-location-664x002x064x030%"];
			tree[303] = ["%undo-buttons-on%"];
			tree[304] = ["#grov05#Ah, sure thing! I didn't have anything in particular to say about this puzzle, but wanted to point out these undo/redo buttons in the corner."];
			tree[305] = ["#grov04#They're helpful if you realize you've made a mistake. That way you can go back a few steps and try something different."];
			tree[306] = [5];

			tree[10000] = ["%lights-on%"];
			tree[10001] = ["%remove-light-wq4oq24piy%"];
			tree[10002] = ["%undo-buttons-off%"];
		}
	}

	public static function tutorial4Peg(tree:Array<Array<Object>>)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["%cube-clue-critters%"];
			tree[1] = ["#grov02#Tutorial time again, is it? Very well. Although... I'm sort of running out of things to teach you!"];
			tree[2] = ["%lights-dim%"];
			tree[3] = ["%add-light-7dgnkhnq-location-263x007x242x037%"];
			tree[4] = ["#grov05#Well, these four-peg puzzles do introduce one new tool-- these holopads at the top..."];
			tree[5] = ["%lights-on%"];
			tree[6] = ["#grov04#These holopads are especially useful for puzzles such as this one with a lot of positional clues!"];
			tree[7] = ["%lights-dim%"];
			tree[8] = ["%light-on-wholeclue1%"];
			tree[9] = ["#grov05#For example, this second clue tells us that a blue can't go in the first or third box..."];
			tree[10] = ["#grov03#After all, a blue in the first or third box of the solution would be in the correct position, and this clue would have a heart! Any blues definitely have to go somewhere else."];
			tree[11] = ["%light-off-wholeclue1%"];
			tree[12] = ["%light-on-wholeclue2%"];
			tree[13] = ["#grov06#And this third clue indicates a blue can't go in the fourth box either! Hmm, so if there's a blue... then... Interesting!"];
			tree[14] = ["%light-off-wholeclue2%"];
			tree[15] = ["%light-on-7dgnkhnq%"];
			tree[16] = ["%move-peg-from-blue-to-holopad0%"];
			tree[17] = ["#grov04#Anyways, sometimes to keep clues like this straight in my head, I'll drop a critter on the holopad up here."];
			tree[18] = ["%holopad-state-blue-0100%"];
			tree[19] = ["#grov05#Then, since a blue bug can't go in the first, third or fourth boxes, I'll click these holograms to hide them. See?"];
			tree[20] = ["%lights-on%"];
			tree[21] = ["%remove-light-7dgnkhnq%"];
			tree[22] = ["%label-peg-purple-as-2bdpx6wr%"];
			tree[23] = ["%move-peg-from-2bdpx6wr-to-holopad1%"];
			tree[24] = ["%holopad-state-purple-0010%"];
			tree[25] = ["#grov06#Let's see... Similarly, a purple bug can't go in the first, second or fourth boxes..."];
			tree[26] = ["%move-peg-from-green-to-holopad2%"];
			tree[27] = ["%holopad-state-green-1001%"];
			tree[28] = ["%move-peg-from-brown-to-holopad3%"];
			tree[29] = ["%holopad-state-brown-1101%"];
			tree[30] = ["#grov04#A green bug can't go in the second or third boxes, and a brown bug can't go in the third box..."];
			tree[31] = ["%prompts-y-offset+30%"];
			tree[32] = ["#grov05#A-ha! There we go, there's one bug we can place in the solution for certain. Do you see it?"];
			tree[33] = [50, 70, 90, 110];

			tree[50] = ["A green\nbelongs in\nthe first\nbox"];
			tree[51] = ["#grov06#Hmm, well, that's possible... But a brown might go in the first box instead! All we know about the first box is that it doesn't have a purple or a blue."];
			tree[52] = ["%lights-dim%"];
			tree[53] = ["%add-light-mpjed9p8-location-416x004x030x140%"];
			tree[54] = ["#grov02#However, we know the third box doesn't have a green, a blue or a brown... It must have a purple!"];
			tree[55] = ["%remove-light-mpjed9p8%"];
			tree[56] = ["%lights-on%"];
			tree[57] = [150];

			tree[70] = ["A blue\nbelongs in\nthe second\nbox"];
			tree[71] = ["#grov06#Hmm, well, that's possible... But there might not be any blues in the solution at all! All we know about the second box is that it doesn't have a purple or green."];
			tree[72] = ["%lights-dim%"];
			tree[73] = ["%add-light-mpjed9p8-location-416x004x030x140%"];
			tree[74] = ["#grov02#However, we know the third box doesn't have a green, a blue or a brown... It must have a purple!"];
			tree[75] = ["%remove-light-mpjed9p8%"];
			tree[76] = ["%lights-on%"];
			tree[77] = [150];

			tree[90] = ["A purple\nbelongs in\nthe third\nbox"];
			tree[91] = ["#grov02#Yes, sharp as always! The third box can't have a green, a blue or a brown... It must have a purple."];
			tree[92] = [150];

			tree[110] = ["A blue\nbelongs in\nthe fourth\nbox"];
			tree[111] = ["%lights-dim%"];
			tree[112] = ["%light-on-wholeclue2%"];
			tree[113] = ["#grov06#Hmm, well, the fourth box in the solution can't have a blue! Otherwise, this third clue would have a bug in the correct position, and would have a heart."];
			tree[114] = ["%light-off-wholeclue2%"];
			tree[115] = ["%add-light-mpjed9p8-location-416x004x030x140%"];
			tree[116] = ["#grov02#However, we know the third box doesn't have a green, a blue or a brown... It must have a purple!"];
			tree[117] = ["%remove-light-mpjed9p8%"];
			tree[118] = ["%lights-on%"];
			tree[119] = [150];

			tree[150] = ["%move-peg-from-purple-to-answer2%"];
			tree[151] = ["#grov05#I'll go ahead and drop a purple into the third box in the solution. Oh, but look at this--"];
			tree[152] = ["#grov03#We can also tell this is the ONLY purple! Based on our positional clues, a second purple can't be placed in the first, second or fourth boxes without breaking a clue."];
			tree[153] = ["%move-peg-from-2bdpx6wr-to-287x229%"];
			tree[154] = ["#grov04#I'll just move our holopad purple by this red \"X\", so I'll remember there's no more purples in the solution."];
			tree[155] = ["#grov02#Anyways I'll leave you to finish the puzzle at your own pace. Have fun!"];

			tree[300] = ["%mark-startover%"];
			tree[301] = ["#grov05#Ah, sure thing! Let me just reset the puzzle how it was..."];
			tree[302] = ["%reset-puzzle%"];
			tree[303] = ["%lights-dim%"];
			tree[304] = ["%add-light-7dgnkhnq-location-263x007x242x037%"];
			tree[305] = ["#grov06#So, these four-peg puzzles introduce a new tool-- these holopads at the top..."];
			tree[306] = [5];

			tree[10000] = ["%lights-on%"];
			tree[10001] = ["%remove-light-7dgnkhnq%"];
			tree[10002] = ["%remove-light-mpjed9p8%"];
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["%cube-clue-critters%"];
			tree[1] = ["#grov06#Hmm, let's see. What's the best way to start this puzzle..."];
			tree[2] = ["#grov02#Hmm... Hmm... Ah! We really hit the jackpot with this one."];
			tree[3] = ["%lights-dim%"];
			tree[4] = ["%light-on-wholeclue0%"];
			tree[5] = ["#grov04#Whenever you see clues like this with no hearts, you know those four bugs are each in the wrong position."];
			tree[6] = ["%light-off-wholeclue0%"];
			tree[7] = ["%light-on-clue1peg0%"];
			tree[8] = ["#grov05#So here in clue #2, I know this green bug can't be in the correct position. Otherwise, clue #1 would have a red heart!"];
			tree[9] = ["%cluecloud-clue1peg0-no%"];
			tree[10] = ["#grov06#I'll click this green bug to mark it with an \"X\". That way I can keep track of which bugs are wrong."];
			tree[11] = ["%light-off-clue1peg0%"];
			tree[12] = ["%light-on-clue1peg2%"];
			tree[13] = ["%cluecloud-clue1peg2-no%"];
			tree[14] = ["#grov03#...And, I can tell this blue bug is in the wrong position using the same logic! I'll mark it with an \"X\" as well."];
			tree[15] = ["%light-off-clue1peg2%"];
			tree[16] = ["%light-on-wholeclue1%"];
			tree[17] = ["%prompts-dont-cover-clues%"];
			tree[18] = ["#grov04#Hmm, what do you suppose that implies about these remaining two bugs in the second clue?"];
			tree[19] = [30, 40, 60, 80];

			tree[30] = ["The blue\nand yellow\nare in the\ncorrect\nposition"];
			tree[31] = ["%lights-on%"];
			tree[32] = ["#grov02#Exactly! The blue and yellow bug must be responsible for the two hearts in clue #2, so they must be in the correct position."];
			tree[33] = [100];

			tree[40] = ["The blue\nand yellow\nare in the\nwrong\nposition"];
			tree[41] = ["#grov06#Err, well... Actually it means exactly the opposite! The blue and yellow bugs must be responsible for the two hearts in clue #2."];
			tree[42] = ["%light-on-rightclue0%"];
			tree[43] = ["#grov05#After all, if one of the two other bugs was responsible for a heart in clue #2-- we'd see a heart in clue #1 as well."];
			tree[44] = ["%light-off-rightclue0%"];
			tree[45] = ["%lights-on%"];
			tree[46] = [100];

			tree[60] = ["The green\nand blue\nare in the\ncorrect\nposition"];
			tree[61] = ["%light-on-rightclue0%"];
			tree[62] = ["#grov06#Err, well... Actually if the green or the blue bugs were in the correct position, we'd see a heart in clue #1, instead of two dots!"];
			tree[63] = ["%light-off-rightclue0%"];
			tree[64] = ["#grov04#So actually, what it tells us is that the blue and yellow bugs must be responsible for the two hearts in clue #2. They must be in the correct position."];
			tree[65] = ["#grov05#After all, if one of the two other bugs was responsible for a heart in clue #2-- we'd see a heart in clue #1 as well."];
			tree[66] = ["%lights-on%"];
			tree[67] = [100];

			tree[80] = ["The green\nand blue\nare in the\nwrong\nposition"];
			tree[81] = ["%light-on-rightclue0%"];
			tree[82] = ["#grov06#Err, well... I suppose that's technically correct, given the dots in the first clue. If the green or blue bugs were in the correct position, those would be hearts."];
			tree[83] = ["%light-off-rightclue0%"];
			tree[84] = ["#grov04#But more specifically, it tells us that the blue and yellow bugs must be responsible for the two hearts in clue #2. They must be in the correct position."];
			tree[85] = ["#grov05#After all, if one of the two other bugs was responsible for a heart in clue #2-- we'd see a heart in clue #1 as well."];
			tree[86] = ["%lights-on%"];
			tree[87] = [100];

			tree[100] = ["#grov06#I'll go ahead and drop the blue and yellow bugs into place..."];
			tree[101] = ["%move-peg-from-blue-to-answer1%"];
			tree[102] = ["%move-peg-from-yellow-to-answer3%"];
			tree[103] = ["#grov03#That's a pretty powerful technique isn't it? Why, we're only 30 seconds into the puzzle and it's already half finished."];
			tree[104] = ["#grov05#Hmm... I suppose there's a few different directions you could go from here! I'll leave it up to you."];

			tree[300] = ["%mark-startover%"];
			tree[301] = ["#grov05#Ah, sure thing! Let me just reset the puzzle how it was..."];
			tree[302] = ["%reset-puzzle%"];
			tree[303] = ["%lights-dim%"];
			tree[304] = ["%light-on-wholeclue0%"];
			tree[305] = ["#grov04#Now as I was saying, whenever you see clues like this with no hearts, you know those bugs are all in the wrong position..."];
			tree[306] = [6];

			tree[10000] = ["%lights-on%"];
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["%cube-clue-critters%"];
			tree[1] = ["#grov10#Oof, my goodness! Four clues, and they all have exactly two hits."];
			tree[2] = ["#grov08#Puzzles like this one can feel a bit impenetrable. If you look at each clue individually, there's no bugs which must be present or absent in the solution."];
			tree[3] = ["%lights-dim%"];
			tree[4] = ["%light-on-wholeclue0%"];
			tree[5] = ["%light-on-wholeclue3%"];
			tree[6] = ["%prompts-dont-cover-clues%"];
			tree[7] = ["#grov04#Ahh, but look at this! Based on the first and fourth clue... What can we figure out about the blue bugs in the solution?"];
			tree[8] = [40, 20, 60, 80];

			tree[20] = ["If there's a\nblue bug, it's\nin position\n#3"];
			tree[21] = ["#grov06#Sure, the first clue indicates that any blue bugs must be in position #3. But what about the fourth clue? The fourth clue directly contradicts that!"];
			tree[22] = ["#grov05#It's actually impossible to have any blue bugs in the solution. Why is that?"];
			tree[23] = ["#grov04#Well, it's because a blue bug in position #3 violates the fourth clue, but a blue bug anywhere else violates the first clue."];
			tree[24] = ["%lights-on%"];
			tree[25] = [100];

			tree[40] = ["If there's a\nblue bug, it's\nin position\n#1, #2 or #4"];
			tree[41] = ["#grov06#Sure, the fourth clue indicates that any blue bugs must be in position #1, #2 or #4. But what about the first clue? The first clue directly contradicts that!"];
			tree[42] = ["#grov05#It's actually impossible to have any blue bugs in the solution. Why is that?"];
			tree[43] = ["#grov04#Well, it's because a blue bug in position #3 violates the fourth clue, but a blue bug anywhere else violates the first clue."];
			tree[44] = ["%lights-on%"];
			tree[45] = [100];

			tree[60] = ["There's at\nleast one\nblue bug"];
			tree[61] = ["#grov06#Err, well perhaps! Let's think this through. If there were a blue bug, where would it go?"];
			tree[62] = ["#grov05#...Perhaps it would go in position #1? That way the fourth clue would produce a dot. But then the first clue would produce a dot too, which is no good."];
			tree[63] = ["#grov06#So what if the blue bug were in position #3 instead? The first clue would produce a heart, but the fourth clue would produce a heart as well! That's no good either."];
			tree[64] = ["#grov04#It's actually impossible to have any blue bugs in the solution, without either violating clue #1 or #4."];
			tree[65] = ["%lights-on%"];
			tree[66] = [100];

			tree[80] = ["There are\nzero\nblue bugs"];
			tree[81] = ["%lights-on%"];
			tree[82] = ["#grov02#Spot on! There can't be any blue bugs in the solution, because they'd either violate clue #1 or clue #4."];
			tree[83] = [100];

			tree[100] = ["#grov05#I'll go ahead and drop a blue bug by that red \"X\"..."];
			tree[101] = ["%move-peg-from-blue-to-297x224%"];
			tree[102] = ["%lights-dim%"];
			tree[103] = ["%light-on-wholeclue2%"];
			tree[104] = ["%light-on-wholeclue3%"];
			tree[105] = ["%prompts-y-offset-30%"];
			tree[106] = ["#grov06#Ah! Now that we know there's no blue bugs in the solution, these last few clues are a lot more helpful, aren't they?"];
			tree[107] = [160, 180, 140, 120];

			tree[120] = ["There must\nbe a blue\nin the solution"];
			tree[121] = ["#grov07#Errr!?! But we just figured out there's..."];
			tree[122] = ["#grov10#Wait a moment, are... Are you screwing around with me? You just wanted to see what I'd say, didn't you??"];
			tree[123] = ["#grov12#...To think I'd receive this manner of treatment in my very own tutorial! Harumph."];
			tree[124] = ["%lights-on%"];

			tree[140] = ["There must\nbe a green\nin the solution"];
			tree[141] = [200];

			tree[160] = ["There must\nbe a purple\nin the solution"];
			tree[161] = [200];

			tree[180] = ["There must\nbe a yellow\nin the solution"];
			tree[181] = [200];

			tree[200] = ["%lights-on%"];
			tree[201] = ["#grov02#Yes, yes, the student has become the master! ...I'm just in your way at this point, aren't I?"];
			tree[202] = ["#grov00#Very well, why don't you show me everything you've learned. I'll just be here... Watching..."];

			tree[300] = ["%mark-startover%"];
			tree[301] = ["#grov05#Sure, I think I can do that! Let me just reset things back to how they were..."];
			tree[302] = ["%reset-puzzle%"];
			tree[303] = ["#grov10#So all four of these clues are somewhat useless on their own! With only two markers next to each of them, we can't do very much... logicking."];
			tree[304] = [3];

			tree[10000] = ["%lights-on%"];
		}
	}

	public static function tutorial5Peg(tree:Array<Array<Object>>)
	{
		if (PlayerData.level == 0)
		{
			if (PlayerData.isAbraNice())
			{
				tree[0] = ["%cube-clue-critters%"];
				tree[1] = ["#grov04#Ah hello again, <name>! One last tutorial, is it? Five pegs? Why, it doesn't get any harder than this. I hope you're ready!!"];
				tree[2] = ["#grov05#Now when solving 5-peg puzzles, you'll basically be applying the same concepts you've seen in the other puzzles."];
				tree[3] = ["#grov06#...Like, hmm. Oh! We've seen this before."];
				tree[4] = ["%lights-dim%"];
				tree[5] = ["%light-on-wholeclue0%"];
				tree[6] = ["%prompts-dont-cover-clues%"];
				tree[7] = ["#grov02#I'll bet this first clue already caught your eye, didn't it? ...Why, that's an important one! What can we learn from that?"];
				tree[8] = [30, 20, 10];

				tree[10] = ["There's either\na purple,\ngreen or\nred in the\nsolution"];
				tree[11] = ["#grov03#Errr, well... Actually it means the exact opposite! There can't be a purple, green or red in the solution."];
				tree[12] = ["%light-off-wholeclue0%"];
				tree[13] = ["%light-on-rightclue0%"];
				tree[14] = ["#grov04#...After all, if there were a purple in the solution, we'd see a dot or a heart for this clue."];
				tree[15] = [50];

				tree[20] = ["There are no\npurples,\ngreens or\nreds in the\nsolution"];
				tree[21] = ["#grov03#That's right. ...I imagine these types of simple deductions are second nature by now, hmm? Heh! Heheheh."];
				tree[22] = [50];

				tree[30] = ["There's\na purple,\ngreen, and a\nred in the\nsolution"];
				tree[31] = [11];

				tree[50] = ["%lights-on%"];
				tree[51] = ["%move-peg-from-red-to-297x224%"];
				tree[52] = ["%move-peg-from-green-to-282x234%"];
				tree[53] = ["%move-peg-from-purple-to-312x234%"];
				tree[54] = ["#grov05#Why don't we put a purple, green and red by this red signpost to help us remember."];
				tree[55] = ["#grov06#Wow, so the solution only includes yellows, browns and blues then! ...Hmm, but how many of each... Let's see..."];
				tree[56] = ["%lights-dim%"];
				tree[57] = ["%lights-on-wholeclue3%"];
				tree[58] = ["#grov04#Well there's a lot of places we could start actually. But how about this fourth clue?"];
				tree[59] = ["%prompts-dont-cover-clues%"];
				tree[60] = ["#grov05#This fourth clue tells us a tremendous amount, considering we already know there's no greens or reds... What does it tell us?"];
				tree[61] = [85, 70, 80, 90];

				tree[70] = ["Well,\nthere's a\nbrown in the\nsolution..."];
				tree[71] = ["#grov03#Heh! True, but it tells us a whole lot more than that!"];
				tree[72] = ["#grov05#After all, three bugs in this clue are correct... But we know the red and green are wrong, from earlier."];
				tree[73] = ["#grov04#...That means the two browns and the blue ALL have to be in the solution, doesn't it? ...Goodness!"];
				tree[74] = [150];

				tree[80] = ["Well,\nthere's a\nblue in the\nsolution..."];
				tree[81] = [71];

				tree[85] = ["Well,\nthere's a\nbrown and a\nblue in the\nsolution..."];
				tree[86] = ["#grov03#Heh! True, but it tells us slightly more information than that."];
				tree[87] = [72];

				tree[90] = ["Well,\nthere's two\nbrowns and a\nblue in the\nsolution..."];
				tree[91] = ["#grov02#Spot on! All three of those colors have to be somewhere in the solution, don't they?"];
				tree[92] = ["#grov04#What with the red and green incorrect, those browns and blues are the only bugs left."];
				tree[93] = [150];

				tree[150] = ["%lights-on%"];
				tree[151] = ["%label-peg-brown-as-tkzaz000%"];
				tree[152] = ["%label-peg-brown-as-tkzaz001%"];
				tree[153] = ["%move-peg-from-tkzaz000-to-437x224%"];
				tree[154] = ["%move-peg-from-tkzaz001-to-422x234%"];
				tree[155] = ["%move-peg-from-blue-to-452x234%"];
				tree[156] = ["#grov05#I'll drop those bugs by this signpost so we remember they're in the solution."];
				tree[157] = ["#grov06#Although hmm... there's not much sense in leaving them here, we can place two of them in the solution right away!"];
				tree[158] = ["%prompts-dont-cover-clues%"];
				tree[159] = ["#grov04#Where do you think the two brown bugs belong?"];
				tree[160] = [180, 190, 200, 170];

				tree[170] = ["In the\nfirst and...\nthird spot\nfrom the left?"];
				tree[171] = ["#grov00#Heh! Heheheh. Perhaps I chose a puzzle that was too easy..."];
				tree[172] = ["#grov02#But you're correct of course, the second clue shows the brown bugs can't go anywhere else."];
				tree[173] = [210];

				tree[180] = ["In the\nfirst and...\nfifth spot\nfrom the left?"];
				tree[181] = ["%lights-dim%"];
				tree[182] = ["%lights-on-wholeclue1%"];
				tree[183] = ["#grov06#Now now, that wouldn't exactly coincide with this second clue would it?"];
				tree[184] = ["#grov05#...If there were a brown bug in the fifth spot from the left, this clue would have a bug in the correct position, and a red heart."];
				tree[185] = ["#grov04#But since there are no red hearts, there's only two possible positions for those brown bugs; the first and third spots from the left."];
				tree[186] = [210];

				tree[190] = ["In the\nsecond and...\nfourth spot\nfrom the left?"];
				tree[191] = ["%lights-dim%"];
				tree[192] = ["%lights-on-wholeclue1%"];
				tree[193] = ["#grov06#Now now, that wouldn't exactly coincide with this second clue would it?"];
				tree[194] = ["#grov05#...If there were a brown bug in the second spot from the left, this clue would have a bug in the correct position, and a red heart."];
				tree[195] = [185];

				tree[200] = ["In the\nthird and...\nfifth spot\nfrom the left?"];
				tree[201] = ["%lights-dim%"];
				tree[202] = ["%lights-on-wholeclue1%"];
				tree[203] = ["#grov06#Now now, that wouldn't exactly coincide with this second clue would it?"];
				tree[204] = ["#grov05#...If there were a brown bug in the fifth spot from the left, this clue would have a bug in the correct position, and a red heart."];
				tree[205] = [185];

				tree[210] = ["%lights-on%"];
				tree[211] = ["%move-peg-from-tkzaz000-to-answer0%"];
				tree[212] = ["%move-peg-from-tkzaz001-to-answer2%"];
				tree[213] = ["#grov02#Hopefully that's enough to get you on your way, I think I'll leave you to finish this puzzle at your own pace."];
				tree[214] = ["#grov04#Take your time, and remember your training from the other tutorials."];

				tree[300] = ["%mark-startover%"];
				tree[301] = ["#grov04#Ah, sure thing! Let me just reset the puzzle how it was..."];
				tree[302] = ["%reset-puzzle%"];
				tree[303] = ["#grov05#Anyways as I was saying, when solving 5-peg puzzles, you'll be applying the same concepts you've seen in the other puzzles."];
				tree[304] = [2];

				tree[10000] = ["%lights-on%"];
			}
			else
			{
				tree[0] = ["%cube-clue-critters%"];
				tree[1] = ["%setvar-0-0%"]; // default to regular "start over" state
				tree[2] = ["#grov04#Ah hello again, <name>! One last tutorial, is it? Five pegs? Why, it doesn't get any harder than this. I hope you're ready!!"];
				tree[3] = ["#grov06#Now when solving 5-peg puzzles, you'll basically be applying the same-"];
				tree[4] = ["%enterabra%"];
				tree[5] = ["#abra06#Hmm. This is some pretty advanced stuff, Grovyle!"];
				tree[6] = ["#abra04#Why don't you let me handle this tutorial? I think I can do a better job explaining these harder concepts."];
				tree[7] = ["#grov08#But Abra... You're so dreadful at explaining things! ...Don't you remember back when you used to run all these tutorials?"];
				tree[8] = ["#grov09#...And all those players quit, demoralized and confused? ...And they sent us all those nasty e-mails?"];
				tree[9] = ["#abra12#Yes, yes, I remember. But I'm trying to get better at relating my thoughts to lower life forms."];
				tree[10] = ["#abra09#You know, talking to them at their level. ...At their level of stupidness."];
				tree[11] = ["#grov08#..."];
				tree[12] = ["#abra06#You have no idea how challenging it is for someone of my intelligence! It's like, how should I word this..."];
				tree[13] = ["#abra08#It's like trying to explain discrete math to a chimpanzee."];
				tree[14] = ["#grov09#......"];
				tree[15] = ["#abra09#Well, more like trying to explain discrete math to a snail."];
				tree[16] = ["#abra05#A, hmm... A snail of below-average intelligence. A moronic snail."];
				tree[17] = ["#grov10#This conversation is not... exactly bestowing me with confidence that you're ready to lead the player in a tutorial, Abra!"];
				tree[18] = ["%move-peg-from-red-to-297x224%"];
				tree[19] = ["%move-peg-from-green-to-282x234%"];
				tree[20] = ["%move-peg-from-purple-to-312x234%"];
				tree[21] = ["#abra12#...Is this seriously the puzzle you chose for him? Why, this is insulting! There's no reds, greens OR purples in it?"];
				tree[22] = ["#grov06#Well, err... I've found it's nice to start them with something to boost their confidence before-"];
				tree[23] = ["%tomidabra%"];
				tree[24] = ["%move-peg-from-brown-to-answer0%"];
				tree[25] = ["%move-peg-from-brown-to-answer2%"];
				tree[26] = ["#abra13#And look at these sloppy positional clues! The browns have to go here and here..."];
				tree[27] = ["%move-peg-from-yellow-to-answer4%"];
				tree[28] = ["#abra12#And then there must be a yellow here, and a blue would go-"];
				tree[29] = ["#grov13#Hey! ...Let <name> do that. You're spoiling the puzzle for him!"];
				tree[30] = ["#abra08#..."];
				tree[31] = ["#abra09#I shudder to think of how much <name> could have learned if I'd been mentoring him from the beginning. Let me have a turn with him!"];
				tree[32] = ["#grov08#...But I'm REALLY fond of <name>, and I just know you're going to scare him off!! Can't you just let me handle this one last tutorial?"];
				tree[33] = ["#abra04#Scare him off? ...I like to think I've gotten better at communicating complex concepts while disguising my air of subtle condescension."];
				tree[34] = ["#abra05#...But, let's have <name> chime in here."];
				tree[35] = ["#abra06#<name>, do you think I'm capable of communicating complex concepts while disguising my air of subtle condescension?"];
				tree[36] = ["#abra08#Hmm... That may have been a confusing sentence for a snail of your intelligence..."];
				tree[37] = ["#abra06#Do you think I can... teach... without talking like a big meanie?"];
				tree[38] = [110, 90, 70, 50];

				tree[50] = ["Yes"];
				tree[51] = ["%swapwindow-abra%"];
				tree[52] = ["%setprofindex-0%"];
				tree[53] = ["#abra02#Great! Then let's begin."];
				tree[54] = ["#grov10#Oh!! Goodness..."];
				tree[55] = ["#grov09#<name>, umm, you might not know what you're in for. I'll tell you in advance I don't think you're a moronic snail."];
				tree[56] = ["#grov08#...Maybe you can come visit me afterwards for a confidence boost."];
				tree[57] = ["#grov09#...And a handjob."];
				tree[58] = ["#grov10#...I'll make this up to you, I promise! Please don't quit the game!"];
				tree[59] = ["%move-peg-from-blue-to-answer1%"];
				tree[60] = ["%move-peg-from-yellow-to-answer3%"];
				tree[61] = ["#abra03#Okay okay, shoo! Shoo! It's my turn. ...And let's get this baby stuff out of the way!"];

				tree[70] = ["Maybe?"];
				tree[71] = ["%swapwindow-abra%"];
				tree[72] = ["%setprofindex-0%"];
				tree[73] = ["#abra02#Great! Then let's begin."];
				tree[74] = ["#grov10#Err, I think that was a \"maybe\", Abra."];
				tree[75] = ["#abra05#Oh! Oh, I forgot you're limited to verbal communication with the player, Grovyle."];
				tree[76] = ["#abra04#By probing <name>'s mind I was able to read the intention behind those words. It was an optimistic maybe."];
				tree[77] = ["#grov08#I don't... errm... Well, okay."];
				tree[78] = ["%swapwindow-abra%"];
				tree[79] = ["#abra03#Wheh-heh-heh!"];
				tree[80] = [150];

				tree[90] = ["...No"];
				tree[91] = ["%swapwindow-abra%"];
				tree[92] = ["%setprofindex-0%"];
				tree[93] = ["#abra02#Great! Then let's begin."];
				tree[94] = ["#grov10#Err, I think that was a \"no\", Abra."];
				tree[95] = ["#abra05#Oh! Oh, I forgot you're limited to verbal communication with the player, Grovyle."];
				tree[96] = ["#abra04#By probing <name>'s mind I was able to read the intention behind those words. It was a sarcastic no."];
				tree[97] = [77];

				tree[110] = ["Definitely\nnot"];
				tree[111] = ["%swapwindow-abra%"];
				tree[112] = ["%setprofindex-0%"];
				tree[113] = ["#abra02#Great! Then let's begin."];
				tree[114] = ["#grov10#Err, I think that was an emphatic \"no\", Abra."];
				tree[115] = [95];

				tree[150] = ["%move-peg-from-blue-to-answer1%"];
				tree[151] = ["%move-peg-from-yellow-to-answer3%"];
				tree[152] = ["%setvar-0-1%"]; // switch to "completely start over" state
				tree[153] = ["#abra05#Now let's get this baby stuff out of the way."];

				tree[300] = ["%mark-startovercomplete%"];
				tree[301] = ["#abra11#Ehh? ...Explain what again?"];
				tree[302] = ["#abra08#..."];
				tree[303] = ["%reset-puzzle%"];
				tree[304] = ["%setvar-0-0%"]; // switch to regular "start over" state
				tree[305] = ["%move-peg-from-brown-to-answer0%"];
				tree[306] = ["%move-peg-from-blue-to-answer1%"];
				tree[307] = ["%move-peg-from-brown-to-answer2%"];
				tree[308] = ["%move-peg-from-yellow-to-answer3%"];
				tree[309] = ["%move-peg-from-yellow-to-answer4%"];
				tree[310] = ["%setvar-0-1%"]; // switch to "completely start over" state
				tree[311] = ["#abra09#...Just... Just try not to touch anything this time!"];

				tree[350] = ["%mark-startover%"];
				tree[351] = ["#abra06#Ehh? ...Explain what again?"];
				tree[352] = ["#abra08#..."];
				tree[353] = ["%reset-puzzle%"];
				tree[354] = ["%setvar-0-0%"]; // switch to regular "start over" state
				tree[355] = ["%move-peg-from-brown-to-answer0%"];
				tree[356] = ["%move-peg-from-blue-to-answer1%"];
				tree[357] = ["%move-peg-from-brown-to-answer2%"];
				tree[358] = ["%move-peg-from-yellow-to-answer3%"];
				tree[359] = ["%move-peg-from-yellow-to-answer4%"];
				tree[360] = ["%setvar-0-1%"]; // switch to "completely start over" state
				tree[361] = ["#abra12#...Just... Just stop hitting the skip button! Why do you want a tutorial if you're just going to skip everything?"];

				tree[10000] = ["%swapwindow-abra%"];
				tree[10001] = ["%setprofindex-0%"];
				tree[10002] = ["%exitgrov%"];

				if (PlayerData.gender == PlayerData.Gender.Girl)
				{
					DialogTree.replace(tree, 21, "for him", "for her");
					DialogTree.replace(tree, 29, "for him", "for her");
					DialogTree.replace(tree, 31, "mentoring him", "mentoring her");
					DialogTree.replace(tree, 31, "with him", "with her");
					DialogTree.replace(tree, 32, "scare him", "scare her");
					DialogTree.replace(tree, 33, "Scare him", "Scare her");
				}
				else if (PlayerData.gender == PlayerData.Gender.Complicated)
				{
					DialogTree.replace(tree, 21, "for him", "for them");
					DialogTree.replace(tree, 29, "for him", "for them");
					DialogTree.replace(tree, 31, "mentoring him", "mentoring them");
					DialogTree.replace(tree, 31, "with him", "with them");
					DialogTree.replace(tree, 32, "scare him", "scare them");
					DialogTree.replace(tree, 33, "Scare him", "Scare them");
				}

				if (!PlayerData.grovMale)
				{
					DialogTree.replace(tree, 57, "And a handjob", "And you can finger me a little");
				}
			}
		}
		else if (PlayerData.level == 1)
		{
			if (PlayerData.isAbraNice())
			{
				tree[0] = ["%cube-clue-critters%"];
				tree[1] = ["%setvar-0-0%"]; // switch to regular "start over" state
				tree[2] = ["#grov04#So, you might be surprised to see only four clues for a 5-peg puzzle! But indeed, more pegs doesn't necessarily mean more clues."];
				tree[3] = ["#grov05#It just means we have to make better use of the few clues we were given."];
				tree[4] = ["#grov06#Like hmm, let's start by thinking about the red bugs. Looking at the-"];
				tree[5] = ["%enterabra%"];
				tree[6] = ["#abra06#Hmm. This is some pretty advanced stuff, Grovyle! You've been teaching <name> to solve 5-peg puzzles?"];
				tree[7] = ["#grov02#Why yes, this is actually our second one! ...He just finished the first puzzle a moment ago, almost entirely by himself."];
				tree[8] = ["#abra05#Say, if <name> is ready for 5-peg puzzles, I have a special type of puzzle which might interest him even further..."];
				tree[9] = ["#abra06#Sorry, is that okay? ...I wasn't trying to hijack your tutorial."];
				tree[10] = ["#grov06#Mmmm, well ordinarily I'd be more apprehensive considering your history with these tutorials..."];
				tree[11] = ["#grov03#... ...But, you seem to have turned over a bit of a new leaf as of late. ...Sure, Abra! Take it away."];
				tree[12] = ["%swapwindow-abra%"];
				tree[13] = ["%setprofindex-0%"];
				tree[14] = ["%fun-nude0%"];
				tree[15] = ["#abra03#Wheh-heh-heh! Don't worry <name>, this will be fun~"];
				tree[16] = [150];

				tree[150] = ["%move-peg-from-purple-to-answer1%"];
				tree[151] = ["%move-peg-from-blue-to-answer0%"];
				tree[152] = ["%move-peg-from-blue-to-answer2%"];
				tree[153] = ["%move-peg-from-blue-to-answer3%"];
				tree[154] = ["%move-peg-from-blue-to-answer4%"];
				tree[155] = ["%setvar-0-1%"]; // switch to "completely start over" state
				tree[156] = ["#abra05#Now let's get this baby stuff out of the way."];

				tree[300] = ["%mark-startovercomplete%"];
				tree[301] = ["#abra11#Ehh? ...Explain what again?"];
				tree[302] = ["#abra08#..."];
				tree[303] = ["%reset-puzzle%"];
				tree[304] = ["%setvar-0-0%"]; // switch to regular "start over" state
				tree[305] = ["%move-peg-from-purple-to-answer1%"];
				tree[306] = ["%move-peg-from-blue-to-answer0%"];
				tree[307] = ["%move-peg-from-blue-to-answer2%"];
				tree[308] = ["%move-peg-from-blue-to-answer3%"];
				tree[309] = ["%move-peg-from-blue-to-answer4%"];
				tree[310] = ["%setvar-0-1%"]; // switch to "completely start over" state
				tree[311] = ["#abra09#...Just... Just try not to touch anything this time!"];

				tree[350] = ["%mark-startover%"];
				tree[351] = ["#abra06#Ehh? ...Explain what again?"];
				tree[352] = ["#abra08#..."];
				tree[353] = ["%reset-puzzle%"];
				tree[354] = ["%setvar-0-0%"]; // switch to regular "start over" state
				tree[355] = ["%move-peg-from-purple-to-answer1%"];
				tree[356] = ["%move-peg-from-blue-to-answer0%"];
				tree[357] = ["%move-peg-from-blue-to-answer2%"];
				tree[358] = ["%move-peg-from-blue-to-answer3%"];
				tree[359] = ["%move-peg-from-blue-to-answer4%"];
				tree[360] = ["%setvar-0-1%"]; // switch to "completely start over" state
				tree[361] = ["#abra12#...Just... Just stop hitting the skip button! Why do you want a tutorial if you're just going to skip everything?"];

				tree[10000] = ["%swapwindow-abra%"];
				tree[10001] = ["%setprofindex-0%"];
				tree[10002] = ["%exitgrov%"];

				if (PlayerData.gender == PlayerData.Gender.Girl)
				{
					DialogTree.replace(tree, 7, "He just", "She just");
					DialogTree.replace(tree, 7, "by himself", "by herself");
					DialogTree.replace(tree, 8, "interest him", "interest her");
				}
				else if (PlayerData.gender == PlayerData.Gender.Complicated)
				{
					DialogTree.replace(tree, 7, "He just", "They just");
					DialogTree.replace(tree, 7, "by himself", "by themselves");
					DialogTree.replace(tree, 8, "interest him", "interest them");
				}
			}
			else
			{
				tree[0] = ["%cube-clue-critters%"];
				tree[1] = ["%setvar-0-0%"]; // Default to regular "start over" state
				tree[2] = ["#abra04#So the REAL secret to solving these puzzles quickly is the laughably small solution space."];
				tree[3] = ["#abra05#That is, Grovyle likes to call these \"logic puzzles\" but why use logic at all when you can just brute force it?"];
				tree[4] = ["#abra06#After all, with only five different colored bugs, and five boxes to place them in... That's a rather a small number of possible solutions isn't it?"];
				tree[5] = ["#abra09#..."];
				tree[6] = ["#abra12#That wasn't rhetorical! Isn't it a small number?"];
				tree[7] = [20, 30, 40, 50, 60, 70];

				tree[20] = ["it's um...\nat least 40?"];
				tree[21] = ["#abra08#Well... hmm... yes..."];
				tree[22] = ["#abra05#That's correct, five to the fifth power IS at least 40! Here, imagine your mommy gives you five boxes of cookies."];
				tree[23] = ["#abra04#Each box of cookies has five rows, and each row has five cookies in it. Each cookie has five chocolate chips, and each chocolate chip is five calories."];
				tree[24] = ["#abra02#Count on your fingers. Why, that's 3,125 calories worth of chocolate chips isn't it?"];
				tree[25] = [100];

				tree[30] = ["it's um...\n325?"];
				tree[31] = ["#abra08#Well... hmm... yes..."];
				tree[32] = ["#abra05#Alright, five to the fifth power is... almost 325! Here, imagine your mommy gives you five crates of cookies."];
				tree[33] = [23];

				tree[40] = ["it's um...\n625?"];
				tree[41] = ["#abra08#Well... hmm... yes..."];
				tree[42] = ["#abra05#Alright, five to the fifth power is... almost 625! Here, imagine your mommy gives you five crates of cookies."];
				tree[43] = [23];

				tree[50] = ["it's um...\n1,875?"];
				tree[51] = ["#abra08#Well... hmm... yes..."];
				tree[52] = ["#abra05#Alright, five to the fifth power is... almost 1,875! Here, imagine your mommy gives you five crates of cookies."];
				tree[53] = [23];

				tree[60] = ["it's um...\n3,125?"];
				tree[61] = ["#abra04#Right, now with only 3,125 solutions, you could just run through them in your head. But if that's too much, you can split the problem into two parts."];
				tree[62] = [101];

				tree[70] = ["it's um...\n9,375?"];
				tree[71] = ["#abra08#Well... hmm... yes..."];
				tree[72] = ["#abra05#Alright, five to the fifth power is... well, 9,375 is close! Here, imagine your mommy gives you five crates of cookies."];
				tree[73] = [23];

				tree[100] = ["#abra04#Now with only 3,125 solutions, you could just try them all out in your head. But if that's too much, you can split the problem into two parts."];
				tree[101] = ["#abra05#The first part is just figuring out which five colored bugs are in the solution, and the second part is figuring out which order they're in."];
				tree[102] = ["#abra06#After all, if we only think about which five colors are in the solution, and not which position they're in... there's a trivial number of color combinations, aren't there?"];
				tree[103] = ["#abra08#..."];
				tree[104] = ["#abra13#Again, that's not a rhetorical question! Why don't you ever answer my questions?"];
				tree[105] = [120, 130, 140, 150, 160, 170];

				tree[120] = ["There's\nlike...\n1?"];
				tree[121] = ["#abra09#..."];
				tree[122] = ["#abra05#Well, 1 is... pretty close. Hmm. How can I put this... Let's imagine your daddy gives you money to open a lemonade stand, right?"];
				tree[123] = ["#abra04#So your daddy gives you money corresponding to the k-combination at a given place N in a lexicographic ordering, where k represents the number of lemons..."];
				tree[124] = ["#abra09#...I thought this would be easier to explain. Just..."];
				tree[125] = ["#abra08#-sigh- 126, okay? There's 126 combinations."];
				tree[126] = [200];

				tree[130] = ["There's\nlike...\n126?"];
				tree[131] = ["#abra04#That's right, now 126 is an incredibly trivial number isn't it?"];
				tree[132] = ["#abra02#Why... You can probably count to 126 all by yourself can't you? Well maybe not yet, but some day."];
				tree[133] = [201];

				tree[140] = ["There's\nlike...\n225?"];
				tree[141] = ["#abra09#..."];
				tree[142] = ["#abra05#Well, 225 is... pretty close. Hmm. How can I put this... Let's imagine your daddy gives you money to open a lemonade stand, right?"];
				tree[143] = [123];

				tree[150] = ["There's\nlike...\n324?"];
				tree[151] = ["#abra09#..."];
				tree[152] = ["#abra05#Well, 324 is... pretty close. Hmm. How can I put this... Let's imagine your daddy gives you money to open a lemonade stand, right?"];
				tree[153] = [123];

				tree[160] = ["There's\nlike...\n625?"];
				tree[161] = ["#abra09#..."];
				tree[162] = ["#abra05#Well, 625 is... pretty close. Hmm. How can I put this... Let's imagine your daddy gives you money to open a lemonade stand, right?"];
				tree[163] = [123];

				tree[170] = ["There's\nlike...\n864?"];
				tree[171] = ["#abra09#..."];
				tree[172] = ["#abra05#Well, 864 is... pretty close. Hmm. How can I put this... Let's imagine your daddy gives you money to open a lemonade stand, right?"];
				tree[173] = [123];

				tree[200] = ["#abra05#So, 126 is an incredibly trivial number! Why, you can probably count to 126 all by yourself can't you? Well maybe not yet, but some day."];
				tree[201] = ["#abra06#Grovyle loves wasting his time with little heuristics and mental shortcuts. He'd probably tell you something about, hmm... Clue #3..."];
				tree[202] = ["%lights-dim%"];
				tree[203] = ["%light-on-wholeclue2%"];
				tree[204] = ["#abra05#Yes, he'd tell you how clue #3 indicates there's no yellows, because a single yellow in clue #3 would rule out the possibility of all colors except purple..."];
				tree[205] = ["%lights-on%"];
				tree[206] = ["#abra04#But a solution with four purples and a yellow just doesn't work."];
				tree[207] = ["%move-peg-from-yellow-to-307x221%"];
				tree[208] = ["#abra05#So, he'd say there's no yellows, and drop a bug over here."];
				tree[209] = ["%lights-dim%"];
				tree[210] = ["%light-on-wholeclue1%"];
				tree[211] = ["%light-on-wholeclue2%"];
				tree[212] = ["#abra06#Next hmm... He might tell you how clues #2 and #3 indicate there's no reds, since you'd need three reds to avoid creating any dots..."];
				tree[213] = ["%light-off-wholeclue1%"];
				tree[214] = ["%light-off-wholeclue2%"];
				tree[215] = ["%light-on-wholeclue3%"];
				tree[216] = ["#abra04#But a solution with three reds contradicts clue #4. Yes, that's a very Grovyle approach to these things."];
				tree[217] = ["%lights-on%"];
				tree[218] = ["%move-peg-from-red-to-329x228%"];
				tree[219] = ["#abra05#He'd use a lot of these little logic shortcuts to gradually whittle down possibilities..."];
				tree[220] = ["#abra06#But all these logic shortcuts are pointless when there's only... 126 color combinations!?!"];
				tree[221] = ["#abra02#It's like calculating 2+2 by logically deducing that it can't be 7 or 8. When the answer's that obvious, why bother deducing it?"];
				tree[222] = ["%prompts-dont-cover-clues%"];
				tree[223] = ["#abra04#Why, there's clearly only one color combination which works."];
				tree[224] = [230, 240, 250, 260, 270, 280];

				tree[230] = ["Four blues\nand a...\nbrown?"];
				tree[231] = ["#abra05#Well, I mean..."];
				tree[232] = ["#abra04#..."];
				tree[233] = ["%lights-dim%"];
				tree[234] = ["%light-on-wholeclue3%"];
				tree[235] = ["#abra05#...If there were four blues and a brown, clue #4 wouldn't have three bugs correct. Four blues and a brown is wrong."];
				tree[236] = ["%lights-on%"];
				tree[237] = [300];

				tree[240] = ["Four blues\nand a...\npurple?"];
				tree[241] = ["%move-peg-from-purple-to-answer1%"];
				tree[242] = ["#abra02#Right. And of course, the purple has to go in the second slot or the hearts don't line up..."];
				tree[243] = [302];

				tree[250] = ["Four browns\nand a...\nblue?"];
				tree[251] = ["#abra08#Well, that..."];
				tree[252] = ["#abra09#..."];
				tree[253] = ["#abra12#...That literally violates EVERY clue. Are you... Do you not understand the rules!?!"];
				tree[254] = ["#abra08#-sigh-"];
				tree[255] = [300];

				tree[260] = ["Four browns\nand a...\npurple?"];
				tree[261] = ["#abra05#Well, I mean..."];
				tree[262] = ["#abra04#..."];
				tree[263] = ["%lights-dim%"];
				tree[264] = ["%light-on-wholeclue3%"];
				tree[265] = ["#abra05#...If there were four browns and a purple, clue #4 wouldn't have three bugs correct. Four browns and a purple is wrong."];
				tree[266] = ["%lights-on%"];
				tree[267] = [300];

				tree[270] = ["Four purples\nand a...\nblue?"];
				tree[271] = ["#abra05#Well, I mean..."];
				tree[272] = ["#abra04#..."];
				tree[273] = ["%lights-dim%"];
				tree[274] = ["%light-on-wholeclue3%"];
				tree[275] = ["#abra05#...If there were four purples and a blue, clue #4 wouldn't have three bugs correct. Four purples and a blue is wrong."];
				tree[276] = ["%lights-on%"];
				tree[277] = [300];

				tree[280] = ["Four purples\nand a...\nbrown?"];
				tree[281] = ["#abra05#Well, I mean..."];
				tree[282] = ["#abra04#..."];
				tree[283] = ["%lights-dim%"];
				tree[284] = ["%light-on-wholeclue3%"];
				tree[285] = ["#abra05#...If there were four purples and a brown, clue #4 wouldn't have three bugs correct. Four purples and a brown is wrong."];
				tree[286] = ["%lights-on%"];
				tree[287] = [300];

				tree[300] = ["%move-peg-from-purple-to-answer1%"];
				tree[301] = ["#abra04#There's four blues and a purple. Of course, the purple has to go in the second slot or the hearts don't line up..."];
				tree[302] = ["%move-peg-from-blue-to-answer0%"];
				tree[303] = ["%move-peg-from-blue-to-answer2%"];
				tree[304] = ["%move-peg-from-blue-to-answer3%"];
				tree[305] = ["%move-peg-from-blue-to-answer4%"];
				tree[306] = ["%setvar-0-1%"]; // switch to "completely start over" state
				tree[307] = ["#abra06#And then the rest are all blue. As a matter of fact, you can deduce all of that without the first clue. Isn't that strange?"];
				tree[308] = ["#abra02#The truth is, I always include one extra clue just to make the puzzles easier."];
				tree[309] = ["#abra08#Hmm, maybe I should stop including that extra clue. Are these puzzles too easy? How long did that take you... three minutes?"];
				tree[310] = ["#abra05#Well, let's try something more challenging next. Yes, I think I have something that will work."];

				tree[400] = ["%mark-startovercomplete%"];
				tree[401] = ["%mark-startover%"];
				tree[402] = ["#abra08#Oh... Well... Sure. I guess."];
				tree[403] = ["%reset-puzzle%"];
				tree[404] = ["%setvar-0-0%"]; // switch to regular "start over" state
				tree[405] = ["#abra09#I'll... try to use smaller words this time."];
				tree[406] = [1];

				tree[10000] = ["%lights-on%"];

				if (!PlayerData.grovMale)
				{
					DialogTree.replace(tree, 201, "his time", "her time");
					DialogTree.replace(tree, 201, "He'd probably", "She'd probably");
					DialogTree.replace(tree, 204, "he'd tell", "she'd tell");
					DialogTree.replace(tree, 208, "he'd say", "she'd say");
					DialogTree.replace(tree, 212, "He might", "She might");
					DialogTree.replace(tree, 219, "He'd use", "She'd use");
				}
			}
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["%lights-off%"];
			tree[1] = ["%cube-clue-critters%"];
			tree[2] = ["%setvar-0-0%"]; // default to regular "start over" state
			tree[3] = ["#abra00#So, for those who've mastered 5-peg puzzles, I've been experimenting with something a little more difficult..."];
			tree[4] = ["%lights-on%"];
			tree[5] = ["#abra03#7-peg puzzles! Ee-heheheh! Pretty nifty yes?"];
			tree[6] = [60, 20, 30, 50, 40];

			tree[20] = ["Wow!\nCool!"];
			tree[21] = [100];

			if (PlayerData.abraStoryInt == 5)
			{
				tree[30] = ["I already\ninvented\n7-peg\npuzzles..."];
				tree[31] = [100];
			}
			else
			{
				tree[30] = ["So it's two\nextra pegs?\nThat's a\nlittle trite"];
				tree[31] = [100];
			}

			tree[40] = ["Good god,\nwhat have\nyou done"];
			tree[41] = [100];

			tree[50] = ["Noooooooo-\n-oooooooo-\n-ooooooo"];
			tree[51] = [100];

			tree[60] = ["Hey asshole!\nFive pegs\nwas already\ntoo much!!"];
			tree[61] = [100];

			tree[100] = ["#abra02#Oh, but I haven't even explained how they work yet!"];
			tree[101] = ["#abra04#You see, seven peg puzzles are just like the other puzzles with one extra rule- a bug can never be next to another bug of the same color."];
			tree[102] = ["%label-peg-red-as-6d38q000%"];
			tree[103] = ["%label-peg-red-as-6d38q001%"];
			tree[104] = ["%label-peg-red-as-6d38q002%"];
			tree[105] = ["%move-peg-from-6d38q000-to-answer0%"];
			tree[106] = ["%move-peg-from-6d38q001-to-answer3%"];
			tree[107] = ["#abra05#So for example, these red bugs are next to each other, which isn't allowed. If there's a red in the corner, there can't be a red in the center too."];
			tree[108] = ["%move-peg-from-6d38q001-to-answer4%"];
			tree[109] = ["%move-peg-from-6d38q002-to-answer5%"];
			tree[110] = ["#abra04#At most, there could be three red bugs in the solution... One in each corner."];
			tree[111] = ["%move-peg-from-answer0-to-offscreen%"];
			tree[112] = ["%move-peg-from-answer4-to-offscreen%"];
			tree[113] = ["%move-peg-from-answer5-to-offscreen%"];
			tree[114] = ["%unlabel-pegs%"];
			tree[115] = ["#abra06#These puzzles shouldn't be too tough. ...And if you're struggling, you can still use all of Grovyle's so-called \"shortcuts\" on them. Like, let's see..."];
			tree[116] = ["%lights-dim%"];
			tree[117] = ["%light-on-wholeclue0%"];
			tree[118] = ["%light-on-wholeclue4%"];
			tree[119] = ["%prompts-dont-cover-7peg-clues%"];
			tree[120] = ["#abra05#Oh, I suppose clues #1 and #5 have a lot of hits. We can trivially deduce there's two particular colors in the solution, can't we?"];
			tree[121] = [160, 150, 140, 130];

			tree[130] = ["Green and\nred?"];
			tree[131] = ["%lights-off-wholeclue4%"];
			tree[132] = ["#abra02#Right! ...Because we can't get six hits for clue #1 without a green in the solution,"];
			tree[133] = ["%lights-off-wholeclue0%"];
			tree[134] = ["%lights-on-wholeclue4%"];
			tree[135] = ["#abra04#And we can't get five hits for clue #5 without a red in the solution."];
			tree[136] = ["%lights-on%"];
			tree[137] = ["#abra02#You see? It's the same trick you've used for other puzzles already. Easy! Ee-heh-heh."];
			tree[138] = [200];

			tree[140] = ["Green and\nbrown?"];
			tree[141] = ["%lights-off-wholeclue4%"];
			tree[142] = ["#abra09#Well... We can't get six hits for clue #1 without a green in the solution."];
			tree[143] = ["%lights-off-wholeclue0%"];
			tree[144] = ["%lights-on-wholeclue4%"];
			tree[145] = ["#abra04#And we can't get five hits for clue #5 without a red in the solution."];
			tree[146] = ["%lights-on%"];
			tree[147] = ["#abra05#You see? It's the same trick you've used for other puzzles already, nothing too bad, right?"];
			tree[148] = [200];

			tree[150] = ["Blue and\nred?"];
			tree[151] = [141];

			tree[160] = ["Blue and\npurple?"];
			tree[161] = [141];

			tree[200] = ["%move-peg-from-green-to-427x229%"];
			tree[201] = ["%move-peg-from-red-to-447x249%"];
			tree[202] = ["#abra04#I'll put those bugs by the green checkmark signpost, and... what next? Hmm... Think like Grovyle... Think like Grovyle..."];
			tree[203] = ["%lights-dim%"];
			tree[204] = ["%light-on-wholeclue2%"];
			tree[205] = ["%light-on-wholeclue5%"];
			tree[206] = ["#abra02#Okay, well... Clue #3 shows us several bugs which are in the wrong position for clue #6."];
			tree[207] = ["%lights-off-wholeclue5%"];
			tree[208] = ["%light-on-clue5peg0%"];
			tree[209] = ["%cluecloud-clue5peg0-no%"];
			tree[210] = ["#abra05#So clearly this blue must be in the wrong position, or there'd be a heart in clue #3."];
			tree[211] = ["%light-off-clue5peg0%"];
			tree[212] = ["%light-on-wholeclue5%"];
			tree[213] = ["%cluecloud-clue5peg1-no%"];
			tree[214] = ["%cluecloud-clue5peg4-no%"];
			tree[215] = ["%light-on-wholeclue1%"];
			tree[216] = ["%prompts-dont-cover-7peg-clues%"];
			tree[217] = ["#abra04#And this yellow and brown are wrong too..."];
			tree[218] = ["#abra06#You can tell which two bugs are in the correct position for clue #6 in the bottom-right corner, can't you?"];
			tree[219] = [240, 260, 230, 250];

			tree[230] = ["Blue and\nyellow?"];
			tree[231] = ["%light-off-wholeclue5%"];
			tree[232] = ["%light-on-clue5peg5%"];
			tree[233] = ["%move-peg-from-blue-to-answer5%"];
			tree[234] = ["#abra02#Right, it must be the blue in the bottom-left corner..."];
			tree[235] = [304];

			tree[240] = ["Brown and\nblue?"];
			tree[241] = ["#abra08#Well... There's a brown in the solution, yes. Were you really clever enough to think ahead that far or were you just guessing?"];
			tree[242] = ["#abra09#Mmmm, yes. I see. You were just guessing. Okay."];
			tree[243] = ["#abra04#So, I was trying to explain how we can deduce which two bugs in clue #6 are in the correct position, without guessing."];
			tree[244] = [300];

			tree[250] = ["Brown and\nyellow?"];
			tree[251] = ["#abra08#Well... There's a brown in the solution, yes. Were you really clever enough to think ahead that far or were you just guessing?"];
			tree[252] = [242];

			tree[260] = ["Two\nblues?"];
			tree[261] = ["#abra08#Well... There's two blues in the solution, yes. Were you really clever enough to deduce that or were you just guessing?"];
			tree[262] = [242];

			tree[300] = ["%light-off-wholeclue5%"];
			tree[301] = ["%light-on-clue5peg5%"];
			tree[302] = ["%move-peg-from-blue-to-answer5%"];
			tree[303] = ["#abra05#It must be the blue in the bottom-left corner..."];
			tree[304] = ["%light-off-clue5peg5%"];
			tree[305] = ["%light-on-clue5peg6%"];
			tree[306] = ["%move-peg-from-yellow-to-answer6%"];
			tree[307] = ["#abra04#And, it must be the yellow in the bottom right corner."];
			tree[308] = ["%lights-on%"];
			tree[309] = ["#abra05#No other bugs from clue #6 can be in the correct position without invalidating either clue #2 or clue #3."];
			tree[310] = ["#abra04#Right? Again, nothing new. You've used all of these techniques before. Oooh, but here's something you haven't seen before-"];
			tree[311] = ["%move-peg-from-yellow-to-287x229%"];
			tree[312] = ["#abra02#There's no more yellows in the solution. Do you see why?"];
			tree[313] = ["%lights-dim%"];
			tree[314] = ["%light-on-answer0%"];
			tree[315] = ["%light-on-answer1%"];
			tree[316] = ["%light-on-answer2%"];
			tree[317] = ["%light-on-answer3%"];
			tree[318] = ["%light-on-answer4%"];
			tree[319] = ["#abra05#It's because there's only five places they can go..."];
			tree[320] = ["%light-off-answer1%"];
			tree[321] = ["%light-off-answer2%"];
			tree[322] = ["%light-on-wholeclue3%"];
			tree[323] = ["#abra04#If a yellow was in the left or upper-right corner, it would invalidate clue #4..."];
			tree[324] = ["%light-off-wholeclue3%"];
			tree[325] = ["%light-on-wholeclue1%"];
			tree[326] = ["%light-off-answer0%"];
			tree[327] = ["#abra05#If a yellow was in the upper-left corner, it would invalidate clue #2..."];
			tree[328] = ["%lights-dim%"];
			tree[329] = ["#abra04#And if it were anywhere else, it would be next to the yellow we've already placed!"];
			tree[330] = ["%lights-on%"];
			tree[331] = ["#abra02#Ah, see? You're understanding it now aren't you."];
			tree[332] = ["#abra00#Actually... Wow! Looking at your neural activity, I'm seeing new pathways I've never seen you open before."];
			tree[333] = ["#abra02#It looks like spatial reason's handled over here... And deductive reason's handled in this part of your brain. Yes, I see."];
			tree[334] = ["#abra07#Now that you're using those two regions at the same time, they're communicating in a way that... Wow..."];
			tree[335] = ["#abra00#That's actually, really... Mmm... Mmmmphh..."];
			tree[336] = ["#abra01#..."];
			tree[337] = ["%lights-dim%"];
			tree[338] = ["%light-on-rightclue1%"];
			tree[339] = ["%light-on-rightclue3%"];
			tree[340] = ["#abra00#Umm anyways, see those white dots in clues #2 and #4? Look at them. Yes, really think about what they mean! Mmm, that's it."];
			tree[341] = ["%lights-dim%"];
			tree[342] = ["%light-on-wholeclue1%"];
			tree[343] = ["%light-on-wholeclue3%"];
			tree[344] = ["%prompts-dont-cover-7peg-clues%"];
			tree[345] = ["#abra04#Based on those white dots, how many browns do you think are in the solution?"];
			tree[346] = [350, 375, 390, 395];

			tree[350] = ["Zero\nbrowns?"];
			tree[351] = ["%lights-dim%"];
			tree[352] = ["%lights-on-wholeclue0%"];
			tree[353] = ["%lights-on-wholeclue5%"];
			tree[354] = ["#abra06#Well, there's definitely more than zero browns, look at clues #1 and #6!"];
			tree[355] = ["#abra04#It's impossible to fulfill both of those clues with no browns in the solution."];
			tree[356] = ["%lights-dim%"];
			tree[357] = ["%light-on-answer0%"];
			tree[358] = ["%light-on-answer1%"];
			tree[359] = ["%light-on-answer2%"];
			tree[360] = ["%light-on-answer3%"];
			tree[361] = ["%light-on-answer4%"];
			tree[362] = ["#abra05#But based on clues #2 and #4, there must be fewer than two browns. A second brown would have to contradict one of those two clues."];
			tree[363] = [407];

			tree[375] = ["Zero or one\nbrowns?"];
			tree[376] = ["#abra02#That's... Wow! Did you really figure that out yourself?"];
			tree[377] = ["#abra01#There's so much about your primitive brain that I don't... quite... understand yet."];
			tree[378] = ["#abra00#I didn't think you'd be able to... Oh! Mmmm, wow..."];
			tree[379] = [430];

			tree[390] = ["One or two\nbrowns?"];
			tree[391] = [400];

			tree[395] = ["Two or three\nbrowns?"];
			tree[396] = [400];

			tree[400] = ["%lights-dim%"];
			tree[401] = ["%light-on-answer0%"];
			tree[402] = ["%light-on-answer1%"];
			tree[403] = ["%light-on-answer2%"];
			tree[404] = ["%light-on-answer3%"];
			tree[405] = ["%light-on-answer4%"];
			tree[406] = ["#abra05#Well, if there were two browns, one of them would have to contradict clue #2 or #4."];
			tree[407] = ["%light-off-answer2%"];
			tree[408] = ["%light-on-clue1peg2%"];
			tree[409] = ["#abra04#A brown in the left cell contradicts clue #2..."];
			tree[410] = ["%light-off-answer4%"];
			tree[411] = ["%light-off-clue1peg2%"];
			tree[412] = ["%light-on-clue3peg4%"];
			tree[413] = ["#abra05#Mmm yes, I think you're starting to understand. A brown in the right cell contradicts clue #4, doesn't it?"];
			tree[414] = ["#abra04#If there are two browns which occupy neither the left nor right cell, they would be adjacent. And that's not allowed either."];
			tree[415] = ["%lights-on%"];
			tree[416] = [500];

			tree[430] = ["%lights-dim%"];
			tree[431] = ["%light-on-answer0%"];
			tree[432] = ["%light-on-answer1%"];
			tree[433] = ["%light-on-answer3%"];
			tree[434] = ["%light-on-answer4%"];
			tree[435] = ["%light-on-clue1peg2%"];
			tree[436] = ["#abra04#I guess you noticed that a brown in the left cell contradicts clue #2,"];
			tree[437] = ["%light-off-answer4%"];
			tree[438] = ["%light-off-clue1peg2%"];
			tree[439] = ["%light-on-clue3peg4%"];
			tree[440] = ["#abra05#A brown in the right cell contradicts clue #4,"];
			tree[441] = ["#abra04#And if there are two browns which occupy neither the left nor right cell, they would be adjacent. And that's not allowed either."];
			tree[442] = ["%lights-on%"];
			tree[443] = [500];

			tree[500] = ["#abra00#...Ooogh, there go those neurons of yours again! ...Wow, that cluster is really busy... Mmm... This is very challenging for you isn't it?"];
			tree[501] = ["%lights-dim%"];
			tree[502] = ["%light-on-wholeanswer%"];
			tree[503] = ["%light-on-wholeclue5%"];
			tree[504] = ["%move-peg-from-blue-to-answer1%"];
			tree[505] = ["%move-peg-from-purple-to-answer2%"];
			tree[506] = ["#abra04#So with at most one brown and yellow in the solution, clue #6 lets us place an additional blue and purple..."];
			tree[507] = ["%light-off-wholeclue5%"];
			tree[508] = ["%move-peg-from-green-to-answer3%"];
			tree[509] = ["#abra00#And that means... It means that..."];
			tree[510] = ["%move-peg-from-brown-to-answer0%"];
			tree[511] = ["%move-peg-from-red-to-answer4%"];
			tree[512] = ["%setvar-0-1%"]; // switch to "completely start over" state
			tree[513] = ["#abra01#Gwahhhhhhhhhhh!! Gw-gwahhhh~~"];
			tree[514] = ["#abra00#Ahhh... hah..."];
			tree[515] = ["%lights-on%"];
			tree[516] = ["#abra01#Sorry, I... hahh... phew, little... braingasm..."];
			if (PlayerData.recentChatTime("tutorial.3.2") >= 800 && PlayerData.puzzleCount[4] == 0)
			{
				tree[517] = ["#abra10#...I, um. That was your first 7-peg puzzle wasn't it?"];
				tree[518] = ["#abra04#I... I should have been gentler. I should have tried to make it more special for you."];
				tree[519] = ["#abra00#Maybe... Maybe I can make it up to you? Ee-heheheheh~"];
			}
			else
			{
				tree[517] = ["#abra10#...I, um. I swear I'm not usually like this when I'm with most guys."];
				tree[518] = ["#abra04#Something about your brain is... different. It just... happened so fast..."];
				tree[519] = ["#abra00#Maybe... Maybe I can make it up to you? Ee-heheheheh~"];

				if (PlayerData.gender == PlayerData.Gender.Girl)
				{
					DialogTree.replace(tree, 517, "most guys", "most girls");
				}
				else if (PlayerData.gender == PlayerData.Gender.Complicated)
				{
					DialogTree.replace(tree, 517, "most guys", "most people");
				}
			}

			tree[800] = ["%mark-startovercomplete%"];
			tree[801] = ["#abra02#You want to solve it a second time!?"];
			tree[802] = ["#abra00#Ohhh <name>... Twice in one day... You spoil me~"];
			tree[803] = ["%reset-puzzle%"];
			tree[804] = ["%setvar-0-0%"]; // switch to regular "start over" state
			tree[805] = ["#abra04#Very well. Ahem! So these puzzles add one extra rule- a bug can never be next to another bug of the same color..."];
			tree[806] = [102];

			tree[850] = ["%mark-startover%"];
			tree[851] = ["#abra06#Ehh? Very well... But try not to interrupt this time."];
			tree[852] = ["#abra11#It doesn't feel good to explain something this intense without finishing. ...You're going to give me blue brains!"];
			tree[853] = ["%reset-puzzle%"];
			tree[854] = ["%setvar-0-0%"]; // switch to regular "start over" state
			tree[855] = ["#abra04#Ahem! So these puzzles add one extra rule- a bug can never be next to another bug of the same color..."];
			tree[856] = [102];

			tree[10000] = ["%lights-on%"];
		}
	}

	/**
	 * prefaced with, "can you handle this one Buizel?"
	 */
	public static function scaleGamePartOneLocalHandoff():Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		tree[0] = ["%noop%"];
		tree[1] = ["%set-puzzle-235350%"];
		tree[2] = ["#buiz05#Sure! So for this game, <name>, you just gotta use these bugs to balance the two sides of the scale."];
		return DialogTree.prepend(tree, scaleGamePartOne());
	}

	static private function scaleGamePartOne():Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		tree[0] = ["#buiz06#The bugs all weigh the same, but some of the platforms are further from the center- kinda like uhhh... a messed-up see-saw."];
		tree[1] = ["#buiz04#In other words, just putting two bugs on both side won't work. You gotta get the numbers to match up too."];
		tree[2] = ["%move-pegs-0-2-1-0%"];
		tree[3] = ["#buiz03#Well like, just let me show you 'cause this one looks easy. You put two bugs here, and one over there- because four plus four equals ten."];
		tree[4] = ["#buiz04#Sometimes it takes a little while..."];
		tree[5] = ["#buiz13#...Hey, is this thing broken or something!?"];
		tree[6] = ["%move-pegs-2-0-1-0%"];
		tree[7] = ["%answer-bad%"];
		tree[8] = ["#buiz00#OH! Oops... five and five makes ten! Ha! Ha! ...I can add... Bwark..."];
		tree[9] = ["#buiz06#Huh wait what? Oh okay. I guess you can't leave any bugs behind or it doesn't count?"];
		tree[10] = ["#buiz12#So that means... you have to use, exactly... every single bug? GWAH! That's so annoying."];
		tree[11] = ["%move-pegs-2-1-0-1%"];
		tree[12] = ["%answer-good%"];
		tree[13] = ["#buiz06#Let's see uhhh... I guess four more makes fourteen? Is that it?"];
		tree[14] = ["#buiz02#Okay, there we go. It's usually something easy, so try not to overthink it."];
		tree[15] = ["%set-puzzle-856515%"];
		tree[16] = ["#buiz05#Here you know what, why don't you try one."];
		tree[10000] = ["%skip-tutorial%"];
		return tree;
	}

	public static function scaleGamePartOneAbruptHandoff():Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		tree[0] = ["%noop%"];
		tree[1] = ["%set-puzzle-235350%"];
		tree[2] = ["#buiz05#So for this game <name>, you just gotta use these bugs to balance the two sides of the scale."];
		return DialogTree.prepend(tree, scaleGamePartOne());
	}

	/**
	 * prefaced with, "I'll go get Buizel, he can handle this..."
	 */
	public static function scaleGamePartOneRemoteHandoff():Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		tree[0] = ["%noop%"];
		tree[1] = ["%set-puzzle-235350%"];
		tree[2] = ["#buiz05#What? Oh yeah, this one! So for this game <name>, you just gotta use these bugs to balance the two sides of the scale."];
		return DialogTree.prepend(tree, scaleGamePartOne());
	}

	public static function scaleGamePartOneNoHandoff(minigameState:MinigameState):Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		tree[0] = ["#buiz02#Oh okay, it's " + minigameState.description + "! I can explain this one."];
		tree[1] = ["%set-puzzle-235350%"];
		tree[2] = ["#buiz05#So... You need to use these bugs to balance the two sides of the scale."];
		return DialogTree.prepend(tree, scaleGamePartOne());
	}

	public static function scaleGamePartTwo():Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		tree[0] = ["#buiz02#Hey nice work! Twelve on the left side, and twelve on the right side. See, you get it!"];
		tree[1] = ["#buiz03#Now the catch is, the rest of us will all be racing to complete the same puzzle... so you gotta think fast!"];
		tree[2] = ["#buiz00#Well I mean, you at least gotta think faster than Mr. \"Four Plus Four Equals Ten\" over here... Ha! Ha!"];
		tree[3] = ["#buiz04#Anyway so whoever completes the puzzle the fastest gets " + moneyString(denNerf(200)) + ", and you play until someone reaches " + moneyString(denNerf(1000)) + "! Simple stuff, right?"];
		tree[10000] = ["%skip-tutorial%"];

		if (!PlayerData.buizMale)
		{
			DialogTree.replace(tree, 2, "than Mr.", "than Mrs.");
		}
		return tree;
	}

	public static function scaleGameSummary():Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		tree[0] = ["#buiz05#So for this game, <name>, you just gotta move those bugs onto the platforms to make the scale balance."];
		tree[1] = ["#buiz04#The total numbers on the left need to equal the total numbers on the right. And uhh, you can't have any bugs left over either."];
		tree[2] = ["#buiz03#Whoever completes the puzzle the fastest gets " + moneyString(denNerf(200)) + ", and you keep going until someone reaches " + moneyString(denNerf(1000)) + "! Simple stuff, right?"];
		return tree;
	}

	/**
	 * prefaced with, "I'll go get Rhydon, he can handle this..."
	 */
	public static function stairGamePartOneRemoteHandoff():Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		tree[0] = ["%noop%"];
		tree[1] = ["%move-man-2%"];
		tree[2] = ["%hide-turn-indicator%"];
		tree[3] = ["#RHYD02#What? Oh, this game! Gr-roar! Yeah, I can explain this one."];
		tree[4] = ["#RHYD04#So for this game, we're trying to grab those chests from the top of the stairs. Whoever collects two chests first is the winner."];
		return DialogTree.prepend(tree, stairGamePartOne());
	}

	public static function stairGamePartOneNoHandoff()
	{
		var tree:Array<Array<Object>> = [];
		tree[0] = ["%noop%"];
		tree[1] = ["%move-man-2%"];
		tree[2] = ["#RHYD03#Wait, is this that stair climbing game? Awesome, I love this one!"];
		tree[3] = ["#RHYD04#So for this game, we're trying to grab those chests from the top of the stairs. Whoever collects two chests first is the winner."];
		return DialogTree.prepend(tree, stairGamePartOne());
	}

	public static function stairGamePartOneAbruptHandoff()
	{
		var tree:Array<Array<Object>> = [];
		tree[0] = ["%noop%"];
		tree[1] = ["%move-man-2%"];
		tree[2] = ["#RHYD04#So for this game, we're trying to grab those chests from the top of the stairs. Whoever collects two chests first is the winner."];
		return DialogTree.prepend(tree, stairGamePartOne());
	}

	public static function stairGamePartOne():Array<Array<Object>>
	{
		var manColor:String = Critter.CRITTER_COLORS[0].english;
		var comColor:String = Critter.CRITTER_COLORS[1].english;

		var tree:Array<Array<Object>> = [];

		tree[0] = ["%noop%"];
		tree[1] = ["%wait-for-bugs%"];
		tree[2] = ["#RHYD05#So like, I'll be " + comColor + ", and you be " + manColor + ", okay? We gotta climb up to the top, grab a chest, and get back down without getting captured."];
		tree[3] = ["%roll-com-2%"];
		tree[4] = ["%roll-man-1%"];
		tree[5] = ["%rmov-com-3%"];
		tree[6] = ["#RHYD04#We take turns movin' 1-4 steps, depending on how the dice are rolled."];
		tree[7] = ["%wait-for-bugs%"];
		tree[8] = ["#RHYD05#See how some of the dice have feet on them? If you roll 1, 2 or 3 feet, you move that many steps."];
		tree[9] = ["%roll-com-2%"];
		tree[10] = ["%roll-man-2%"];
		tree[11] = ["%rmov-man-4%"];
		tree[12] = ["%wait-for-bugs%"];
		tree[13] = ["#RHYD04#But if you roll 0 or 4 feet, you get to move four steps AND take an extra turn!"];
		tree[14] = ["%pick-up-dice%"];
		tree[15] = ["%roll-com-1%"];
		tree[16] = ["#RHYD06#But the trick is, we don't roll the dice like normal. We each choose two dice we wanna put out, and the dice are the same on every side."];
		tree[17] = ["%roll-man-2%"];
		tree[18] = ["%rmov-man-3%"];
		tree[19] = ["#RHYD02#So like on your turn, you can just put out two of the feet dice. That way you know you're moving forward at least two steps!"];
		tree[20] = ["#RHYD06#But we both gotta throw our dice at the same time, like rock paper scissors. So, you never know for sure what the best move is..."];
		tree[21] = ["#RHYD03#...That means if you REALLY wanna win, you gotta stay one step ahead of your opponent! Really get in their head! Gr-r-roarr!"];
		tree[22] = ["%pick-up-dice%"];
		tree[23] = ["%wait-for-bugs%"];
		tree[24] = ["#RHYD04#Here let's do a practice round. I'm controlling the " + comColor + " bug and it's my turn. I'm trying to climb up to the top to get a chest."];
		tree[25] = ["#RHYD06#...We're gonna count down from three, okay? And after we count, you need to throw out 0, 1 or 2 dice with feet on them."];
		tree[26] = ["%prompts-y-offset-50%"];
		tree[27] = ["#RHYD05#We gotta do this at the same time, so try not to cheat! Lemme know when you're ready."];
		tree[28] = [45, 35, 40];

		tree[35] = ["Okay,\nI'm ready!"];

		tree[40] = ["On three,\nthen?"];

		tree[45] = ["I think I\nunderstand..."];

		tree[10000] = ["%skip-tutorial%"];
		return tree;
	}

	public static function stairGameRepromptDice(tree:Array<Array<Object>>):Void
	{
		tree[0] = ["#RHYD06#Err, anyways... So you're throwing out 0, 1 or 2 dice with feet on them."];
		tree[1] = ["%prompts-y-offset-50%"];
		tree[2] = ["#RHYD05#We gotta do this at the same time, so try not to cheat! Lemme know when you're ready."];
		tree[3] = [45, 35, 40];

		tree[35] = ["Okay,\nI'm ready!"];

		tree[40] = ["On three,\nthen?"];

		tree[45] = ["I think I\nunderstand..."];

		tree[10000] = ["%skip-tutorial%"];
	}

	public static function stairGamePartTwo(rollAmount:Int):Array<Array<Object>>
	{
		var manColor:String = Critter.CRITTER_COLORS[0].english;
		var comColor:String = Critter.CRITTER_COLORS[1].english;

		var tree:Array<Array<Object>> = [];
		if (rollAmount == 2)
		{
			tree[0] = ["%move-com-2%"];
			tree[1] = ["%wait-for-bugs%"];
			tree[2] = ["#RHYD03#Awesome, you nailed it! Gr-roarr!"];
			tree[3] = [10];
		}
		else if (rollAmount == 0 || rollAmount == 4)
		{
			tree[0] = ["#RHYD03#Awesome, you nailed it! Gr-roarr!"];
			tree[1] = ["#RHYD11#Although uhh... Rolling a " + englishNumber(rollAmount) + " means I'd move four spaces and capture your piece, which would kinda ruin the tutorial... Uhhhh..."];
			tree[2] = ["%move-com-2%"];
			tree[3] = ["%wait-for-bugs%"];
			tree[4] = ["#RHYD04#...Tell you what, I'll go easy on you. Let's just pretend I rolled a two instead."];
			tree[5] = [10];
		}
		else {
			tree[0] = ["#RHYD03#Awesome, you nailed it! Gr-roarr!"];
			tree[1] = ["%move-com-2%"];
			tree[2] = ["%wait-for-bugs%"];
			tree[3] = ["#RHYD10#But I kinda wanna show you something. So I'm gonna cheat and pretend I rolled a two instead..."];
			tree[4] = [10];
		}

		tree[10] = ["%pick-up-dice%"];
		tree[11] = ["#RHYD02#Greh-heh-heh! So you mighta guessed, but that center square is special. It gives you a chest when you land on it, like a little shortcut."];
		tree[12] = ["%prompts-y-offset-50%"];
		tree[13] = ["#RHYD05#...Now it's your turn! Your little " + manColor + " guy already has a chest, so he's on his way back down. You ready?"];
		tree[14] = [25, 20, 30];

		tree[20] = ["Hmm, so if I\nmove two spaces..."];

		tree[25] = ["Alright,\nI'm ready!"];

		tree[30] = ["Yep, seems\nsimple"];

		tree[10000] = ["%skip-tutorial%"];
		return tree;
	}

	public static function stairGamePartThree(rollAmount:Int):Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		if (rollAmount == 2)
		{
			tree[0] = ["%move-man-2%"];
			tree[1] = ["#RHYD10#Whoa! Have you played this before!? Well... Whatever! This doesn't count, it was just for practice!!!"];
			tree[2] = ["%wait-for-bugs%"];
			tree[3] = [10];
		}
		else if (rollAmount == 0 || rollAmount == 4)
		{
			tree[0] = ["#RHYD02#Whoa, awesome! Rolling a " + englishNumber(rollAmount) + " means you'd get to move four spaces AND get a free turn. That's a great roll!"];
			tree[1] = ["#RHYD06#But actually, you can do even better in this position... Hmm..."];
			tree[2] = ["%rmov-man-2%"];
			tree[3] = ["%wait-for-bugs%"];
			tree[4] = ["#RHYD05#Y'know, let's pretend you rolled a two instead so you can see how capturing works."];
			tree[5] = ["#RHYD10#Agh! Sorry little guy! Now I feel kinda bad..."];
			tree[6] = [10];
		}
		else {
			tree[0] = ["#RHYD02#Nice! You've got the timing part down. Now you just gotta learn how to predict your opponent's moves!"];
			tree[1] = ["%rmov-man-2%"];
			tree[2] = ["%wait-for-bugs%"];
			tree[3] = ["#RHYD05#...Let's pretend you figured out what I was gonna do, and ended up moving two spaces instead. I wanna show you how capturing works..."];
			tree[4] = ["#RHYD10#Agh! Sorry little guy! Now I feel kinda bad..."];
			tree[5] = [10];
		}
		tree[10] = ["%pick-up-dice%"];
		tree[11] = ["#RHYD12#But yeah if you get captured, you go back to the bottom, lose your chest, and your opponent gets a free turn. It really sucks! ...Try not to get captured."];
		tree[12] = ["%reset-bugs%"];

		tree[10000] = ["%skip-tutorial%"];
		return tree;
	}

	public static function stairGameReroll(tutorialRerollCount:Int):Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		if (tutorialRerollCount == 0)
		{
			tree[0] = ["#RHYD06#Errr... Let's try that again! You were a little late that time."];
		}
		else if (tutorialRerollCount == 1)
		{
			tree[0] = ["#RHYD06#Let's uhh... Maybe if we try one more time! It doesn't seem like you're getting it. Throw on the count of three, okay?"];
		}
		else if (tutorialRerollCount == 2)
		{
			tree[0] = ["#RHYD10#Uhh... Almost had it! Just a little bit sooner. Don't worry about being too early."];
		}
		else if (tutorialRerollCount > 2)
		{
			tree[0] = ["#RHYD10#Are you trying to cheat on purpose? 'Cause like, this is just the practice game! You should save your cheating for the real thing..."];
		}
		tree[1] = [30, 20, 10];

		tree[10] = [FlxG.random.getObject(["Oh! My\nbad", "Oops,\nsorry!", "Ah, my\nfault"])];

		tree[20] = [FlxG.random.getObject(["This is\nconfusing...", "...Eh?\n...What?", "I don't\nget it..."])];

		tree[30] = [FlxG.random.getObject(["Hmph,\nwhatever", "Ugh, let's\njust go", "..."])];

		tree[10000] = ["%skip-tutorial%"];
		return tree;
	}

	public static function stairGameSummary():Array<Array<Object>>
	{
		var manColor:String = Critter.CRITTER_COLORS[0].english;
		var comColor:String = Critter.CRITTER_COLORS[1].english;

		var tree:Array<Array<Object>> = [];
		tree[0] = ["#RHYD04#So <name>, you gotta got those " + manColor + " bugs up and down the stairs and collect two of those chests. That's how you win, alright?"];
		tree[1] = ["#RHYD05#We each roll two dice, and add all four together to see how far you move. If it's 0 or 4, you move 4 steps and get a bonus turn."];
		tree[2] = ["#RHYD03#Oh yeah, wr-roar! ...You can capture someone's bug if you land on it. And that center platform is a faster way to get a chest. You get it?"];
		return tree;
	}

	public static function tugGamePartOneNoHandoff():Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		tree[0] = ["#smea02#Omigod omigod omigod, it's that tug-of-war game! ...This is like my FAVORITE of all the minigames! Let me explain it."];
		tree[1] = ["%tug-tutorial-setup%"];
		tree[2] = ["#smea05#It's actually pretty simple, you're trying to get as many chests over to your side as you can."];
		return DialogTree.prepend(tree, tugGamePartOne());
	}

	public static function tugGamePartOneRemoteHandoff():Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		tree[0] = ["%noop%"];
		tree[1] = ["%tug-tutorial-setup%"];
		tree[2] = ["#smea05#What? Oh yeah, this game! This one's pretty simple, you're trying to get as many chests over to your side as you can."];
		return DialogTree.prepend(tree, tugGamePartOne());
	}

	public static function tugGamePartOneAbruptHandoff():Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		tree[0] = ["%noop%"];
		tree[1] = ["%tug-tutorial-setup%"];
		tree[2] = ["#smea05#For this game <name>, you're trying to get as many chests over to your side as you can."];
		return DialogTree.prepend(tree, tugGamePartOne());
	}

	static private function tugGamePartOne():Array<Array<Object>>
	{
		var manColor:String = Critter.CRITTER_COLORS[1].english;
		var comColor:String = Critter.CRITTER_COLORS[0].english;

		var tree:Array<Array<Object>> = [];
		tree[0] = ["#smea04#So I'll be " + comColor + ", and you can be " + manColor + ", okay? ...We each have ten bugs on our team, and we can move them wherever we want."];
		tree[1] = ["%tugmove%"];
		tree[2] = ["#smea06#All the bugs are the same, so really it just comes down to numbers! So like, if I did this..."];
		tree[3] = ["#smea03#There! Now I'm going to win the 125$ chest, because I have five bugs to your three."];
		tree[4] = ["%tugleap%"];
		tree[5] = ["#smea05#That's right, five bugs! ...Don't forget we each have one bug in those tents. You can't see them or move them, but they're still hard at work!"];
		tree[6] = ["#smea04#Whoops, well now I actually have THREE bugs in that middle tent. ...I'm still winning five to three, though, so try not to forget!"];
		tree[7] = ["#smea03#Here, why don't you rearrange your bugs and see if you can beat my score? ...Normally we'd both go at the same time but... Well this is just for practice!"];
		tree[10000] = ["%skip-tutorial%"];
		return tree;
	}

	public static function tugGamePartTwo():Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		tree[0] = ["#smea05#Hmm, okay! So we'll move our little bugs around and after 30 seconds, the round ends and we'll see who won each chest."];
		tree[1] = ["#smea03#Whoever gets the most money gets a little bonus too, so hmmm... Check your math! Harf!"];
		tree[2] = ["#smea04#The full game lasts three rounds, but... Let's just see who won this practice, alright?"];
		tree[10000] = ["%skip-tutorial%"];
		return tree;
	}

	/*
	 * result: [-999, -1] = player lost; 0 = player tied; [1, 999] = player won
	 */
	public static function tugGamePartThree(result:Int):Array<Array<Object>>
	{
		var tree:Array<Array<Object>> = [];
		if (result < 0)
		{
			tree[0] = ["#smea04#Aww, well you didn't win. But you know, at least you still get something for losing."];
		}
		else if (result == 0)
		{
			tree[0] = ["#smea04#Huh? ...Well... that was super silly of you. Did you just... totally copy me?"];
			tree[1] = ["#smea10#Wow, you don't even get any money for a tie!? Well... Don't do that in the real game!"];
		}
		else {
			tree[0] = ["#smea02#Ack, good job! ...I didn't think you'd figure that out so quickly. I'll have to watch out for you! Bark~"];
		}
		tree[10000] = ["%skip-tutorial%"];
		return tree;
	}

	public static function tugGameSummary():Array<Array<Object>>
	{
		var manColor:String = Critter.CRITTER_COLORS[1].english;
		var comColor:String = Critter.CRITTER_COLORS[0].english;

		var tree:Array<Array<Object>> = [];
		tree[0] = ["#smea04#So <name>, you're moving those " + manColor + " bugs around to try and outnumber the " + comColor + " bugs in each row."];
		tree[1] = ["#smea06#Whoever has more bugs in each row wins that chest! And whoever gets more money from chests wins the round."];
		tree[2] = ["#smea05#The game lasts three rounds, and whoever has the most money at the end wins! Simple stuff, right?"];
		return tree;
	}
}