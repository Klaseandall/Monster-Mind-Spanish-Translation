package poke.sand;

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
import poke.smea.SmeargleSexyState;
import puzzle.ClueDialog;
import puzzle.PuzzleState;
import puzzle.RankTracker;

/**
 * Sandslash is canonically male. He made his debut in the Rhydon/Quilava
 * comic. He is a pervert with a heart of gold who always looks out for his
 * friends even when he is not having sex with them. (But he is usually having
 * sex with them.)
 * 
 * Sandslash moved in with Abra and her friends after college. Grovyle, Abra
 * and Buizel already knew each other from college. Abra was looking for
 * someone to fill an empty room, and Sandslash was looking for a cheap place
 * to live. Sandslash and Abra are basically acquaintances who tolerate each
 * other, not close friends.
 * 
 * Most of the time Sandslash is not at Abra's house, he is at the nearby "gym"
 * which is really just a place Pokemon go to hook up.
 * 
 * Sandslash is basically bisexual, although he'd describe himself as
 * "omnisexual." If it moves, he wants to have sex with it.
 * 
 * Sandslash 100% respects rules of fidelity and consent, and wants to ensure
 * sex is a positive force in people's lives. He has occasionally disrupted
 * relationships when other Pokemon were not honest with him -- such as an
 * incident involving his friends Scrafty and Krokorok.
 * 
 * Sandslash will occasionally show up wearing a ball gag. There is a muffled
 * dialog sequence where he explains that Abra's mortgage payments have
 * ballooned drastically since purchasing the house, and Sandslash is unsure
 * whether it is because of a predatory loan or whether that sort of thing is
 * normal.
 * 
 * Sandslash actually enjoys Grimer's smell, it makes him hornier. You will get
 * more money for Sandslash's videos if you play with Grimer before him.
 * 
 * As far as minigames go, Sandslash is abysmal at all of them, they do not
 * interest him. He is highly adaptable at the tug-of-war game and will react
 * quickly if you try to move your guys to counter him. But, he does not count
 * very quickly and sucks at math, so he will usually react in a dumb way.
 * 
 * ---
 * 
 * When writing dialog, I think it's good to have an inner voice in your head
 * for each character so that they behave and speak consistently. Sandslash's
 * inner voice was Craig Robinson
 * 
 * Vocal tics: Heh! Heh. Uhh...
 * 
 * So-so at puzzles (rank 22)
 */
class SandslashDialog
{
	public static var prefix:String = "sand";
	public static var sexyBeforeChats:Array<Dynamic> = [sexyBefore0, sexyBefore1, sexyBefore2, sexyBefore3];
	public static var sexyAfterChats:Array<Dynamic> = [sexyAfter0, sexyAfter1, sexyAfter2, sexyAfter3, sexyAfter4];
	public static var sexyBeforeBad:Array<Dynamic> = [sexyBadSlowStart, sexyBadSpread, sexyBadClosed, sexyBadTaste, sexyBadNonsense, sexyPhone];
	public static var sexyAfterGood:Array<Dynamic> = [sexyAfterGood0, sexyAfterGood1];
	public static var fixedChats:Array<Dynamic> = [needMoreClothes, stealMoney, abraAbsent, onAgain];

	public static var randomChats:Array<Array<Dynamic>> = [
		[random00, random01, random02, random03, randomPhone04],
		[random10, random11, random12, random13],
		[random20, random21, random22, random23]];
	
	public static function getUnlockedChats():Map<String, Bool> {
		var unlockedChats:Map<String, Bool> = new Map<String, Bool>();
		unlockedChats["sand.fixedChats.3"] = hasMet("smea");
		unlockedChats["sand.randomChats.1.3"] = hasMet("smea");
		unlockedChats["sand.randomChats.0.3"] = hasMet("magn");
		unlockedChats["sand.sexyAfterChats.4"] = PlayerData.magnButtPlug > 4;
		if (PlayerData.sandPhone == 5) {
			// player just called sandslash on the phone; enable randomChats.0.4 (the phone greeting dialog)
			unlockedChats["sand.randomChats.0.0"] = false;
			unlockedChats["sand.randomChats.0.1"] = false;
			unlockedChats["sand.randomChats.0.2"] = false;
			unlockedChats["sand.randomChats.0.3"] = false;
			unlockedChats["sand.randomChats.0.4"] = true;
		} else {
			// disable randomChats.0.4 (the phone greeting dialog)
			unlockedChats["sand.randomChats.0.4"] = false;
		}
		return unlockedChats;
	}
	
	public static function clueBad(tree:Array<Array<Object>>, puzzleState:PuzzleState) {
		var clueDialog:ClueDialog = new ClueDialog(tree, puzzleState);
		var pokeWindow:SandslashWindow = cast puzzleState._pokeWindow;
		if (pokeWindow.isGagged()) {
			clueDialog.setGreetings(["#sand16#Whrrmp? Phtrph ffkrrm' rrmb wrph thrp prrzzrl rrmb prr phrm mprmphmmm pr mrr."]);
			clueDialog.pushExplanation("#sand17#C'mrrm yrr knrr whrmp y'rr drrmb, strrp frrprmm rr-rrmb.");
			clueDialog.pushExplanation("#sand16#Rr'm hrrmr rrphr hrrr! Whr rph phrph, rr grrmb pr yrr?");
			clueDialog.pushExplanation("#sand17#Wrll, rrmrr rrgrph trrk-mrkrry... Brr c'mrr!");
		} else {
			clueDialog.setGreetings(["#sand10#Agh! That <first clue>'s wrong! Fix it! Fix it!",
				"#sand10#Ah you're killin' me! Look at the <first clue> " + (PlayerData.gender == PlayerData.Gender.Girl ? "girl" : "man") +"!",
				"#sand10#Fix it! Fix it! It doesn't fit the <first clue>, " + (PlayerData.gender == PlayerData.Gender.Girl ? "girl" : "man") + "! Hurry!",
			]);
			if (clueDialog.actualCount > clueDialog.expectedCount) {
				clueDialog.pushExplanation("#sand06#So alright, if I'm understanding these puzzles right-- <e hearts> means that clue's got <e bugs in the correct position>, right?");
				clueDialog.fixExplanation("clue's got zero", "clue doesn't have any");
				clueDialog.pushExplanation("#sand07#But look at your answer, you've got <a bugs in the correct position>... That's a little more than the <e> you're supposed to have.");
				clueDialog.pushExplanation("#sand02#Like if it were MY puzzle I'd let it slide, but I gotta feeling Abra's gonna be on my ass if it's not exactly <e>.");
				clueDialog.pushExplanation("#sand03#Try to fix your answer, and whack that question mark button in the corner if you need more help, alright? Your little Sandslash buddy's only a click away!");
			} else {
				clueDialog.pushExplanation("#sand06#So alright, if I'm understanding these puzzles right-- <e hearts> means that clue's got <e bugs in the correct position>, right?");
				clueDialog.pushExplanation("#sand07#But look at your answer, you've only got <a bugs in the correct position>... That's a little less than the <e> you're supposed to have.");
				clueDialog.fixExplanation("you've only got zero", "you like... don't have ANY");
				clueDialog.pushExplanation("#sand02#Like if it were MY puzzle I'd let it slide, but I gotta feeling Abra's gonna be on my ass if it's not exactly <e>.");
				clueDialog.pushExplanation("#sand03#Try to fix your answer, and whack that question mark button in the corner if you need more help, alright? Your little Sandslash buddy's only a click away!");
			}
		}
	}		
	
	public static function newHelpDialog(tree:Array<Array<Object>>, puzzleState:PuzzleState, minigame:Bool=false):HelpDialog {
		var helpDialog:HelpDialog = new HelpDialog(tree, puzzleState);
		helpDialog.greetings = [
			"#sand04#Oh hey what's up, you need me?",
			"#sand04#Oh what's up, did you need my help or somethin'?",
			"#sand04#Hey were ya lookin' for me? You need anything?"];
		
		helpDialog.goodbyes = [
			"#sand01#Tsk come back and finish the job next time!",
			"#sand01#Hey where are ya goin'? You fuckin' tease~",
			PlayerData.sandMale ? "#sand12#Aw c'mon, way to leave a guy hangin'!" : "#sand12#Aw c'mon, way to leave a girl hangin'!"
		];
		
		helpDialog.neverminds = [
			"#sand15#C'mon, let's knock out this puzzle or Abra will throw a fit.",
			"#sand15#Hey quit screwin' around! You're getting close, I can feel it.",
			"#sand15#C'mon quit gettin' distracted! I know it's half my fault but still...",
		];
		
		helpDialog.hints = [
			"#sand15#Hey good thinking! Maybe if we act like we're stuck Abra will finish the puzzle for us. HEY ABRA!",
			"#sand15#Yeah I'll go get Abra! It's his fault these puzzles are so impossible in the first place. ABRA! HEY ABRA!",
			"#sand15#Yeah this puzzle's like WAY way too hard! I'll go look for Abra so he can solve it for us. HEY! ABRA!!"
		];
		if (!PlayerData.abraMale) {
			helpDialog.hints[1] = StringTools.replace(helpDialog.hints[1], "his fault", "her fault");
			helpDialog.hints[2] = StringTools.replace(helpDialog.hints[2], "so he", "so she");
		}		
		
		if (minigame) {
			helpDialog.neverminds = [
				"#sand15#C'mon, let's hurry up and get this minigame over with.",
				"#sand15#Hey quit screwin' around! We're just one minigame away from the good part.",
				"#sand15#C'mon quit gettin' distracted! I know it's half my fault but still...",
			];
		}
		return helpDialog;
	}
	
	public static function help(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var helpDialog = newHelpDialog(tree, puzzleState);
		var pokeWindow:SandslashWindow = cast puzzleState._pokeWindow;
		if (pokeWindow._partAlpha == 1 && pokeWindow.isGagged()) {
			helpDialog.greetings = [
				"#sand17#Rr hrr whrr's rrmph, yrr mrrd mrph?"
			];
			helpDialog.goodbyes = [
				"#sand16#Tsk krrm brlk mm frmrph thr jrrb nrrm phrm!",
			];
			helpDialog.neverminds = [
				"#sand16#C'mmb, lrr'ph nrrm mmpphth prrzzrrm rr Rrrbrm rlll thrrr r frmph."
			];
			helpDialog.hints = [
				"#sand16#Hrr grmm thrmfrmm! Mrrbr rrf wrrct lrk wr'rr sprrk Mmbrr wll fmbrsh th prrzzrr frr mph. HYY MMBRR!",
			];
		}
		
		helpDialog.help();

		if (!puzzleState._abraAvailable) {
			var index:Int = DialogTree.getIndex(tree, "%mark-29mjm3kq%") + 1; // don't overwrite the mark
			if (pokeWindow._partAlpha == 0) {
				// sandslash isn't around
				tree[index++] = ["%noop%"];
				tree[index++] = ["#self00#(...Nope, I guess nobody's around...)"];
			} else {
				tree[index++] = ["%fun-alpha1%"];
				if (pokeWindow.isGagged()) {
					tree[index++] = ["#sand16#...Rr hrph mrr rrdrr whr Rr frrmp thrrmp wrrb wrrph."];
				} else {
					tree[index++] = ["#sand07#...I have no idea why I thought that would work."];
				}
			}
			tree[index++] = null;
		}
		
		return tree;
	}
	
	public static function minigameHelp(tree:Array<Array<Object>>, minigameState:MinigameState) {
		gameDialog(Type.getClass(minigameState)).help(tree, newHelpDialog(tree, null, true));
	}
	
	public static function gameDialog(gameStateClass:Class<MinigameState>) {
		var manColor:String = Critter.CRITTER_COLORS[0].english;
		var comColor:String = Critter.CRITTER_COLORS[1].english;
		
		var g:GameDialog = new GameDialog(gameStateClass);
		
		if (PlayerData.playerIsInDen) g.addSkipMinigame(["#sand03#Yeah, fuck this minigame! Let's just go screw around.", "#sand02#I mean like... I don't think we gotta worry about Abra's stupid puzzle rules back here or whatever. Let's just go."]);
		if (!PlayerData.playerIsInDen) g.addSkipMinigame(["#sand03#Yeah, fuck this minigame! Let's just go screw around.", "#sand02#I mean, what was Abra's rule again? It feels like we did enough puzzles. Let's just go."]);
		g.addSkipMinigame(["#sand02#Yeah y'know, I've been working on a better minigame anyway.", "#sand01#The rules are still a little loose but, you know, lemme go show you. Think you'll like this one."]);
		
		g.addRemoteExplanationHandoff("#sand06#I don't remember this one too well, lemme see if <leader>'s around.");
		
		g.addLocalExplanationHandoff("#sand06#Hey can you get <name> up to speed, <leader>?");

		g.addPostTutorialGameStart("#sand07#What the fuck " + (PlayerData.gender == PlayerData.Gender.Girl ? "girl" : "man") + ", who designs these things!? ...I'll pick it up as we go, let's just start.");
		
		g.addIllSitOut("#sand06#Ay <name> how many times have you played this? ...I can dip out, don't wanna make this un-fun or nothin'.");
		g.addIllSitOut("#sand06#Actually <name> I've kinda played this a lot. ...Why don't you all play without me.");
		
		g.addFineIllPlay("#sand01#Heh had a feelin' you'd say that, <name>. What, don't got enough Sandslash in your life? I can fix that~");
		g.addFineIllPlay("#sand15#Yeah yeah, right I just didn't wanna kick your ass too hard. Let's go, fool~");
		
		g.addGameAnnouncement("#sand04#Uhh yeah okay, it's <minigame>?");
		g.addGameAnnouncement("#sand04#Aww yeah yeah, it's <minigame>, okay.");
		g.addGameAnnouncement("#sand04#Is this <minigame>? Alright I see.");
		
		g.addGameStartQuery("#sand05#Think we can just start, right? You ready?");
		g.addGameStartQuery("#sand05#Ayy let's get this shit over with.");
		if (PlayerData.denGameCount == 0) {
			g.addGameStartQuery("#sand05#Whatever, the sooner we start the sooner it's over.");
		} else {
			g.addGameStartQuery("#sand12#Ecccch, I can't believe you're makin' me go through this shit again. Can we start already?");
		}
		
		g.addRoundStart("#sand12#Is it over yet? ...No? What's takin' you guys so long?", ["Sheesh, let\nme enjoy this", "You don't\nhave to play...", "Heh,\nc'mon..."]);
		g.addRoundStart("#sand12#Hurry it up " + (PlayerData.gender == PlayerData.Gender.Girl?"girl":"man") + ", I was supposed to be gettin' my " + (PlayerData.sandMale?"dick wet":"pussy stuffed") + " <round> rounds ago.", ["Doesn't your libido\nhave an \"off\" switch", "Okay\nokay", "...Was I going to\nbe a part of that?"]);
		g.addRoundStart("#sand04#Alright, let's go, round <round>. Who are we waiting on? Everybody ready?", ["Hey don't\nrush me", "Yeah I'm\nready", "Eesh..."]);
		g.addRoundStart("#sand06#Huh... I could probably play this game with one hand couldn't I...", ["I'm one step\nahead of you", "Ew c'mon keep\nit together", "Can't you just\nwait three minutes?"]);
		g.addRoundStart("#sand09#I kinda gotta take a leak... What is this? Round <round>? Ehhh, I can hold it...", ["Just go, we'll\nwait for you", "It'll be\nover quick", "The hell is\nwrong with you"]);
		
		g.addRoundWin("#sand02#Ayyy check that out! Finally found somethin' I'm kinda good at. Heh! Heh.", ["Yeah, but\nI'm better", "Wow, nice\nwork", "...Dang..."]);
		if (gameStateClass == ScaleGameState) g.addRoundWin("#sand04#" + (PlayerData.gender == PlayerData.Gender.Girl ? "Girl" : "Man") + " who the heck made these puzzles? Was that one supposed to be some kinda joke?", ["Yeah, way\ntoo easy", "Geez just\nshut up", "I had trouble\nwith it"]);
		g.addRoundWin("#sand03#That's how it's done " + (PlayerData.gender == PlayerData.Gender.Girl?"girls":"boys") + "! Get on my fuckin' level. Heh! Heh.", ["Wow! You're\ntoo good", "Tsk... More like,\nyour dumbness level", "Whatever"]);
		if (gameStateClass == ScaleGameState) g.addRoundWin("#sand05#Some of these things are like, WAY too easy. I don't even get how you guys were stuck on that so long.", ["Sometimes I just\ndon't see it...", "They're not\nTHAT easy...", "Ughh..."]);
		if (gameStateClass == TugGameState) g.addRoundWin("#sand05#This game seems like, WAY too easy. Am I missin' something?", ["How do you\nkeep track of\nall this...", "It's not\nTHAT easy...", "Ughh..."]);
		
		g.addRoundLose("#sand04#Yeah yeah, <leader>'s great, <leader>'s awesome. Can we move on?", ["All glory\nto <leader>", "Don't be a\nsore loser", "Heh heh\nwhatever"]);
		if (gameStateClass == ScaleGameState) g.addRoundLose("#sand12#Yeah nice, you finished that one sooo damn fast, <leader>. Bet the ladies love you.", ["<leader>\nlikes men!|But I like\nmen!", "Oooh sick\nburn", "Heh\nc'mon"]);
		if (gameStateClass == TugGameState) g.addRoundLose("#sand12#Yeah nice, you got some fast fuckin' fingers don't you <leader>. Bet the ladies love you.", ["<leader>\nlikes men!|But I like\nmen!", "Heh well\nmaybe they do~", "Heh\nc'mon"]);
		g.addRoundLose("#sand05#Geez. Way too fast. WAY too fast. Dunno why I even try.", ["No shame\nin second", "<leader>'s\noutta control!|I'm a\nforce", "Hey, you're\ndoing well"]);
		g.addRoundLose("#sand06#I mean like, I don't even get what I can do better. How do you figure this shit out so friggin' fast?", ["Just gotta\nconcentrate", "Yeah,\nseriously|It's my\nsecret", "I mean,\nwhatever"]);
		
		if (gameStateClass == ScaleGameState || gameStateClass == TugGameState) g.addWinning("#sand03#Awwwww yeah! Check out that scoreboard. Damn I forget, what do I get if I win this?", ["You don't get anything!\nSo let me win!", "Ha, as if\nyou'd win...", "..."]);
		if (gameStateClass == ScaleGameState) g.addWinning("#sand02#C'mon guys, really? I'm not even really trying. How are you all so bad?", ["...", "Just you\nwait...", "Yeah yeah,\nscrew you"]);
		if (gameStateClass != ScaleGameState) g.addWinning("#sand02#C'mon, really? I'm not even really trying. How are you so bad?", ["...", "Just you\nwait...", "Yeah yeah,\nscrew you"]);
		g.addWinning("#sand02#Daaaaaaamn I'm like a fuckin' genius or somethin'. Maybe this game should be called like, Sandslash Monster Mind. ...Nahhh, too many syllables.", ["I'd play Sandslash\nMonster Mind", "I bet your game would\nhave fewer puzzles", "Yeah,\nwhatever"]);
		g.addWinning("#sand03#Ayy this game's actually kinda fun once you get used to it. I mean not as fun as like... Well how much longer we got anyway?", ["Bleah...", "Not as fun as what? Finish\nyour damn sentences", "We just\nstarted"]);
		g.addWinning("#sand01#Ay <name>, if I win this one you gotta go down on me. No more of this hand stuff, I want fuckin' oral this time.", ["I'll get Abra to\nmake me a mouth...", "Sharpie a mouth on the\nside of my hand, I guess?", "Yeah good luck\nwith that"]);
		
		g.addLosing("#sand12#Whatever, this game sucks. Doesn't anybody got like, a Playstation or somethin'?", ["Hey I like\nthis game", "More like...\nGaystation", "But there's no " + (PlayerData.sandMale ? "dick" : "pussy") + "\non Playstation"]);
		g.addLosing("#sand12#Ecccch, this fuckin' game really mulches my grundle. Why the hell are we playing this again?", ["I think\nit's fun", "I'd like to mulch\nyour grundle", "Wait, what the\nheck's a grundle?"]);
		if (gameStateClass == ScaleGameState) g.addLosing("#sand04#Can you hurry up and win, <leader>? I think we all see where this is goin'.", ["Yeah, put us\nout of our misery|I'm going as\nfast as I can", "We can\ncatch up|You can\ncatch up", "Well aren't\nyou a joy"]);
		if (gameStateClass != ScaleGameState) g.addLosing("#sand04#Can you hurry up and win, <leader>? I think we both see where this is goin'.", ["Yeah, put us\nout of our misery|I'm going as\nfast as I can", "We can\ncatch up|You can\ncatch up", "Well aren't\nyou a joy"]);
		g.addLosing("#sand12#" + (PlayerData.gender == PlayerData.Gender.Girl ? "Girl" : "Man") + " I'm so far behind, can I just like... quit or somethin'? I didn't even really wanna play...", ["Don't ruin the\ngame, Sandslash", "It's almost\nover", "You're not that\nfar behind..."]);
		if (gameStateClass == ScaleGameState) g.addLosing("#sand10#I mean, maybe I can still get like 2nd place... Probably not... Damn, you guys are tough.", ["It's still\nanyone's game", "You're pretty\nfar behind", "<leader>'s got\nthis locked up|I'm almost\nthere..."]);
		if (gameStateClass != ScaleGameState) g.addLosing("#sand10#Maybe I can still catch up if I focus 'n shit... But I mean, probably not... Damn, you're really good.", ["It's still\nanyone's game", "You're pretty\nfar behind", "I'm almost\nthere..."]);		

		g.addBeatPlayer(["#sand03#Sandslaaaaaaash! Fuck yeaaaaaaaahhhhh! Unhh. Sandslash!! Gonna! Fuck. Your. Shit. Up! Unh!!", "#sand04#I mean you put up a good fight <name>. Just gotta bring your A-game next time. Sandslash don't fuck around when it comes to competition."]);
		if (PlayerData.PROF_PREFIXES[PlayerData.profIndex] == "sand") {
			g.addPlayerBeatMe(["#sand05#Heh there, you earned <money> and you wasted 5 minutes of precious Sandslash time.", "#sand06#You happy with that little exchange? I mean my usual goin' rate is... uhhh...", "#sand10#Y'know what, nevermind. Let's just get outta here."]);
			g.addPlayerBeatMe(["#sand04#Heh yeah, 'bout figures you'd beat me at this kinda thing.", "#sand01#I mean, while you're spendin' all day thinkin' about puzzles, I'm spendin' all day thinkin' about sex.", "#sand00#Maybe if there was like, a sex puzzle or somethin' we could both do together...", "#sand06#...", "#sand01#Actually, I got kind of an idea. Hey, follow me."]);
			
			g.addBeatPlayer(["#sand03#Awwwwww yeah! Yeah!! Fuck yeah. Nngh! How's it feel. How's it taste! Yeah you like that don't you.", "#sand01#Nngh. Yeah. You like bein' Sandslash's little puzzle bitch. Taste it. Taste that defeat. Nngh. Swallow it all.", "#sand00#C'mere <name>. I earned you, so I'm gonna put you to work~"]);
		} else {
			g.addPlayerBeatMe(["#sand05#Heh there, you earned <money> and you wasted 5 minutes of precious Sandslash time.", "#sand06#You happy with that little exchange? I mean my usual goin' rate is... uhhh...", "#sand10#Y'know what, nevermind."]);
			g.addPlayerBeatMe(["#sand04#Heh yeah, 'bout figures you'd beat me at this kinda thing.", "#sand01#I mean, while you're spendin' all day thinkin' about puzzles, I'm spendin' all day thinkin' about sex.", "#sand00#Maybe if there was like, a sex puzzle or somethin' we could both do together...", "#sand06#...", "#sand01#Actually, I got kind of an idea. Come pay me a visit once you're done with " + PlayerData.PROF_NAMES[PlayerData.profIndex] + " here."]);
			
			g.addBeatPlayer(["#sand03#Awwwwww yeah! Yeah!! Fuck yeah. Nngh! How's it feel. How's it taste! Yeah you like that don't you.", "#sand01#Nngh. Yeah. You like bein' Sandslash's little puzzle bitch. Taste it. Taste that defeat. Nngh. Swallow it all.", "#sand00#Come pay me a visit once you're done with " + PlayerData.PROF_NAMES[PlayerData.profIndex] + ". I earned you, so I'm gonna put you to work~"]);
		}
		
		g.addShortWeWereBeaten("#sand04#Damn <leader>, you take this puzzle shit seriously don't you? Ah whatever. Get you next time.");
		g.addShortWeWereBeaten("#sand05#Ehh don't let it get to you <name>, <money>'s still pretty good isn't it? Seems like you came out a winner.");
		g.addShortWeWereBeaten("#sand05#<nomoney>Geez <leader>, couldn't even let <name> get $10? The hell's wrong with you. Eh, whatever.");
		
		g.addShortPlayerBeatMe("#sand02#Ayy that was pretty good! This puzzle stuff's like in your blood or something.");
		g.addShortPlayerBeatMe("#sand05#Heh congrats " + (PlayerData.gender == PlayerData.Gender.Girl ? "girl" : "man") + ", some day we'll find you some real opponents or something.");
		g.addShortPlayerBeatMe("#sand04#Ayy nice work, I'll get you next time.");
		
		g.addStairOddsEvens("#sand06#Alright how 'bout we do odds and evens to see who starts? Odds, you start, evens, I start... You ready?", ["Sounds\ngood", "Ready!", "So I want it\nto be odd..."]);
		g.addStairOddsEvens("#sand06#Let's throw out odds and evens for start player, alright? I'll be evens, you be odds... Sound good?", ["Let's go", "I'm ready", "Okay, so I'll\nbe odds..."]);
		
		g.addStairPlayerStarts("#sand14#Yeah okay, so you go first. Whatever. You ready to lose? On three, okay?", ["On three...", "Lose?\nWho, me?", "I'm ready\nto lose!"]);
		g.addStairPlayerStarts("#sand14#So you're goin' first. You got your first move decided? I already know what you're doin'...", ["Heh! You THINK\nyou know.", "Okay,\nready!", "I'm that\npredictable?"]);
		
		g.addStairComputerStarts("#sand02#Heh, so I get to go first. You ready for your first roll? I mean we already know I'm putting out two, everybody does that.", ["But, you\nwouldn't tell\nme unless...", "Yep,\nlet's go", "Okay! Ready"]);
		g.addStairComputerStarts("#sand03#So you're lettin' me go first? I mean, that was nice of you. Lemme know when you're ready for your first roll.", ["Bring it!", "Going first\nis actually\nkind of bad...", "I'm ready\nto roll"]);
		
		g.addStairCheat("#sand13#What sorta shady shit was that? You tryin' to cheat or something? ...'Cause I can cheat too.", ["It was an\naccident,\nchill out", "Sorry,\nmy bad", "I was still\nthinking"]);
		g.addStairCheat("#sand12#C'mon, what the fuck was that? How dumb do you think I am? Quit tryin' to cheat.", ["Relax, I was\nbarely late", "Okay,\nokay", "Don't go\nso fast!"]);
		
		g.addStairReady("#sand04#Alright, you ready?", ["Alright", "Let's go", "Yeah,\nsure"]);
		g.addStairReady("#sand05#You ready?", ["On three?", "Hmm,\nyeah", "Okay"]);
		g.addStairReady("#sand04#Ready?", ["Ready!", "Yep", "Let's\ndo it"]);
		g.addStairReady("#sand05#On three?", ["Alright", "Yeah,\non three", "Let's go!"]);
		g.addStairReady("#sand14#C'mon, let's go.", ["Yeah, sure", "Okay,\nready?", "On three!"]);
		
		g.addCloseGame("#sand06#Aww damn, these next couple rolls seem really important. I wonder what you're gonna do...", ["Like I'd\ntell you!", "Are you ready\nto find out?", "You've already\nlost..."]);
		g.addCloseGame("#sand12#Damn, what would Abra do in this position? I feel like he'd have all the probabilities mathed out already...", ["Yeah, but\nthat's boring", "I'd still\nwin", "I've beaten Abra\na few times"]);
		g.addCloseGame("#sand06#Hmm let's see, so I could throw a one... But you don't throw too many zeroes... Damn, this is kind of tough to figure out.", ["It all feels\nkind of random", "Still trying to\nfigure me out!", "Heh, let's\njust go"]);
		g.addCloseGame("#sand04#We should have a rematch some time, this shit's kinda fun.", ["Yeah! I like\nthis game", "Ehh, it's\njust okay", "But we're\nstill gonna\nscrew around,\nright?"]);
		
		g.addStairCapturedHuman("#sand03#Ayyy, mothafuckaaaaaas! Heh heh! Read you like a book! Like a fuckin' book.", ["...You have\nbooks that\ncan fuck?", "Whatever,\nyou got lucky", "Pride goes\nbefore a\nfall..."]);
		g.addStairCapturedHuman("#sand15#Awwww daaaaaamn, did I forget to tell you? ... ...I'm sorta amazing at reading people. Nngh!", ["How'd you\nknow!?", "What,\nwere you\nhustling me?", "Oh\nman..."]);
		g.addStairCapturedHuman("#sand03#Nngh! Yeah! ...Get that weak shit outta here! These are Sandslash stairs. Rest of you fools gotta go.", ["Can I please\nclimb the\nSandslash\nstairs?", "You're too\ngood...", "Yeah yeah,\nshut up"]);
		
		g.addStairCapturedComputer("#sand11#Wait, what? ...What happened to my little " + comColor + " dude? ...Little duuuude!!", ["Did I\ndo that?", "Yeah how's\nthat feel!", "I'll make it up\nto you later~"]);
		g.addStairCapturedComputer("#sand13#Ohhhhhh so that's how it's gonna be, huh? You want things to get nasty, do you? 'Cause I can show you nasty.", ["...That\nwas nasty?", "Nngh, yeah,\nshow me nasty~", "Sandslash, you're\nalready nasty"]);
		g.addStairCapturedComputer("#sand12#Yeah yeahhhh, alright. I probably shoulda seen that one comin'. ...Whatever, this shit's over.", ["Hey c'mon, don't\nquit on me", "Heh yeah,\nit's over...", "You can still\ncome back!"]);
		
		return g;
	}
	
	public static function bonusCoin(tree:Array<Array<Object>>, puzzleState:PuzzleState) {
		tree[0] = ["#sand06#What was that thing? That looks like REAL money! That's not supposed to be in there."];
		tree[1] = ["#sand15#Here, I'll take that off your hands. Yoink!"];
		tree[2] = ["#sand05#..."];
		tree[3] = ["#sand12#Hey wait, this is one of them bonus game coins. Ohhh oh oh oh right. Okay. Now I remember! One sec, I got this."];
	}
	
	public static function random13(tree:Array<Array<Object>>, puzzleState:PuzzleState) {
		var count:Int = PlayerData.recentChatCount("sand.randomChats.1.3");
		
		if (count % 2 == 0) {
			tree[0] = ["%entersmea%"];
			tree[1] = ["#smea05#Hey Sandslash! Abra told me you were a professional artist?"];
			tree[2] = ["#sand03#Heh! Heheheheh. Yeah that's right, I guess you could say I'm an artist."];
			tree[3] = ["#smea02#Oh that's awesome! We should TOTALLY have an art jam sometime. We can like, trade sketchbooks, and I'll-"];
			tree[4] = ["#sand06#Ah I don't got a sketchbook or anythin' like that. I'm not THAT kind of artist."];
			tree[5] = ["#smea04#Oh you don't usually use pencils? What do you work with then, pastels? Acrylics? Oils?"];
			tree[6] = ["#sand03#Heh! Oh that's good. Yeah I guess you could say I work in oils... Heh! Heheheh~"];
			tree[7] = ["#sand04#...But seriously like I don't think an art jam's gonna work out."];
			tree[8] = ["%exitsmea%"];
			tree[9] = ["#smea08#Hmph well okay."];
			tree[10] = ["#sand02#Anyway let's see what we can do about gettin' this bowtie off, mm?"];
		} else if (count % 2 == 1) {
			tree[0] = ["%entersmea%"];
			tree[1] = ["%fun-nude0%"];
			tree[2] = ["#smea04#So you're a professional artist... Doesn't that mean you sell art? I want to see something you painted!"];
			tree[3] = ["#sand06#Mmm like, I don't usually sell individual pieces per se. Lessee, I guess you could say I mostly do commissions. Heh heh. And sometimes I teach classes."];
			tree[4] = ["%fun-nude1%"];
			tree[5] = ["#smea05#Oh wow, you teach!? That's SO cool! Do you mostly do individual or group lessons? I've always wanted to get good enough to where--"];
			tree[6] = ["#smea10#ACK! Pants!!"];
			tree[7] = ["#sand12#Uhh? Aww c'mon, if this kind of nudity bothers you I really don't see how this is gonna work out."];
			tree[8] = ["#smea06#Ohh.... so it's a nudity thing... with oils? Like... nude oil paintings? That's okay. Sometimes I draw stuff like that too..."];
			tree[9] = ["#sand03#Heh! Heheheh. Getting a little warmer. Look, I'll catch up with you later. I got some puzzle stuff to take care of. Ain't that right <name>?"];
			tree[10] = ["%exitsmea%"];
			tree[11] = ["#smea04#Hmph okay, I'll leave you to your puzzling."];
			tree[12] = ["#sand02#Let's move this along, this bowtie's really chafin' my neck."];
			
			tree[10000] = ["%fun-nude1%"];
		}
	}
	
	public static function onAgain(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		// S is Sandslash's gender, and K is your gender.
		if (PlayerData.level == 0) {
			tree[0] = ["#sand08#Ugh sorry. I kinda feel like shit today."];
			tree[1] = ["#sand12#People get so, fuckin'-- like it's somehow MY fault I fuck your on-again-off-again boyfriend on one of the weeks that you're on-again?"];
			tree[2] = ["#sand13#Like I'm supposed to be some fuckin' mind-reader?"];
			tree[3] = ["#sand08#I mean, -sigh- alright get this. There's this guy I sometimes fool around with at the gym, who's in this unstable relationship with this OTHER guy."];
			tree[4] = ["#sand06#And the OTHER guy, doesn't really-- uhh. Hang on, maybe this is easier if we give them names. Let's call them uhh, S and K."];
			tree[5] = [10, 20, 30, 50, 60];
			
			tree[10] = ["Seismitoad\nand\nKangaskhan?"];
			tree[11] = [99];
			
			tree[20] = ["Shelmet\nand\nKarrablast?"];
			tree[21] = [99];
			
			tree[30] = ["Smeargle\nand\nKecleon?"];
			tree[31] = ["#sand10#C'mon, I'm tryin' to keep it a secret. I'm not gonna tell you if you're right or not."];
			tree[32] = ["#sand02#But anyway I said on-again-off-again, how are you reading Smeargle and Kecleon as on-again-off-again?"];
			tree[33] = ["#sand03#Those two are fuckin'... joined at the dick. Heh! Heh."];
			tree[34] = ["#sand05#So for the purposes of the story, I mean, I think it helps to know that S is sorta more sexually reserved. More of the romantic, kisses-and-cuddles type, you know?"];
			tree[35] = ["#sand04#But K, he's more of the any-hole's-a-goal type. Always lookin' to score. So, small wonder things haven't worked out between these two right? Heh! Heh. Anyway,"];
			tree[36] = [40, 43];
			tree[40] = ["..."];
			tree[41] = [102];
			tree[43] = ["Sounds\na lot like\nSmeargle and\nKecleon"];
			tree[44] = ["#sand08#It's not Smeargle and Kecleon. C'mon man, I would never. So anyway,"];
			tree[45] = [102];
			
			tree[50] = ["Scrafty\nand\nKrokorok?"];
			tree[51] = [99];
			
			tree[60] = ["Alright, S\nand K"];
			tree[61] = [100];
			
			tree[99] = ["#sand10#C'mon, I'm tryin' to keep it a secret. I'm not gonna tell you if you're right or not."];
			tree[100] = ["#sand05#So for the purposes of the story, I mean, I think it helps to know that S is sorta more sexually reserved. More of the romantic, kisses-and-cuddles type, you know?"];
			tree[101] = ["#sand04#But K, he's more of the any-hole's-a-goal type. Always lookin' to score. So, small wonder things haven't worked out between these two right? Heh! Heh. Anyway,"];
			tree[102] = ["#sand05#So yeah, S and K go way back, but you never know what's goin on with these two. One week you can't get 'em in the same room, but next week they're totally inseparable."];
			tree[103] = ["#sand02#Week after that they're seein' other people- and then they're back together and won't acknowledge they ever broke up. You get the idea."];
			tree[104] = ["#sand06#So S texts me and tells me I-- no wait, that comes later."];
			tree[105] = ["#sand05#You know what, gimme a sec to get my thoughts together."];
			
			if (!PlayerData.sandMale) {
				// S is a girl...
				DialogTree.replace(tree, 3, "OTHER guy", "OTHER girl");
				DialogTree.replace(tree, 4, "OTHER guy", "OTHER girl");
			}
			if (!PlayerData.keclMale && !PlayerData.smeaMale) {
				DialogTree.replace(tree, 33, "at the dick", "at the vagina");
			}
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				// K is a girl...
				DialogTree.replace(tree, 1, "boyfriend", "girlfriend");
				DialogTree.replace(tree, 3, "There's this guy", "There's this girl");
				DialogTree.replace(tree, 35, "he's more", "she's more");
				DialogTree.replace(tree, 44, "C'mon man", "C'mon girl");
				DialogTree.replace(tree, 100, "he's more", "she's more");
				if (PlayerData.sandMale) {
					// K is a heterosexual girl...
					DialogTree.replace(tree, 35, "any-hole", "any-pole");
					DialogTree.replace(tree, 100, "any-hole", "any-pole");
				}
			}
			if (PlayerData.sandMale && PlayerData.gender == PlayerData.Gender.Girl || 
				!PlayerData.sandMale && PlayerData.gender != PlayerData.Gender.Girl) {
				// with a heterosexual couple there's no gender ambiguity; remove "OTHER"
				DialogTree.replace(tree, 3, "OTHER ", "");
				DialogTree.replace(tree, 4, "OTHER ", "");
			}
		} else if (PlayerData.level == 1) {
			tree[0] = ["#sand04#So anyway yeah, K comes over to the gym lookin' to score. I didn't initiate anything, and everybody knows what goes down at that gym. So, no mystery."];
			tree[1] = ["#sand08#Now yeah, I know S and K have kind of an on-again-off-again thing, but why the hell am I gonna bring that up with K?"];
			tree[2] = ["#sand06#For all I know they just broke up for like the fifteenth time, and the last thing he wants is me killin' his boner by talking about his ex."];
			tree[3] = ["#sand05#So yeah the two of us mess around. Then the next day S is outta control, blowin' up my phone,"];
			tree[4] = ["#sand12#He's textin' me callin' me a... 'ducking slur', callin' me every four-letter word in his phone's autocorrect."];
			tree[5] = ["#sand06#Says I shoulda known better, says I should have asked him first. I dunno. What do you think, man?"];
			tree[6] = [10, 20, 30, 40, 50];
			tree[10] = ["Yes, you\nshould\nhave\nasked K"];
			tree[11] = ["#sand08#Damn, you think so? I dunno. Maybe. I mean if I'd known, I never woulda-"];
			tree[12] = ["#sand09#I wasn't avoiding the question just to keep my conscience clear. It wasn't like that."];
			tree[13] = ["#sand08#I was more worried about killing the mood if they just broke up, y'know? Maybe he's trying to get his mind off of things. I dunno, live and learn I guess."];
			tree[14] = [100];
			
			tree[20] = ["Yes, you\nshould\nhave\ncalled S"];
			tree[21] = ["#sand08#Damn, you think so? I mean what if they'd just broken up, you think that'd be cool? \"Hey, your ex is DTF, you cool if I fuck your ex?\" Man, seems kinda ice cold to me."];
			tree[22] = ["#sand09#Hindsight is 20/20 and all, knowin' what I know now it woulda gone a lot better if I'd called. I dunno, live and learn I guess."];
			tree[23] = [100];
			
			tree[30] = ["No, it's\nK's fault\nfor not\ntelling\nyou"];
			tree[31] = ["#sand05#See that's what I'm sayin', his relationship is his business. It'd be fuckin' rude for me to go around askin' him every 10 seconds, you know,"];
			tree[32] = ["#sand00#\"Oh hey I'm gonna lower my balls into your mouth, is your ex cool with it if I lower my balls into your mouth?\""];
			tree[33] = ["#sand01#\"Oh hey I'm gonna lick this jizz off your snout, is your ex cool with it if I lick this jizz off your snout?\""];
			tree[34] = ["#sand04#I mean I don't see how that shit's on me, I'm not Krokorok's fuckin' babysitter. I dunno, live and learn I guess."];
			tree[35] = [100];
			
			tree[40] = ["No, S\nshould\nexpect\nthis from\nK by now"];
			tree[41] = ["#sand12#I mean that's the truth right? They've been goin' through this shit for years now..."];
			tree[42] = ["#sand13#How is it possible you reunite with someone for like, the fifteenth fuckin' time and you don't expect somethin' like this to happen?"];
			tree[43] = ["#sand12#I mean they gotta be outta their mind if they expect somethin' like this is gonna go smoothly given their history. I dunno, live and learn I guess."];
			tree[44] = [100];
			
			tree[50] = ["It's not\nreally\nyour\nbusiness"];
			tree[51] = [31];
			
			tree[100] = ["#sand02#Thanks man, talking about this makes me feel better. You're a good friend."];
			tree[101] = ["#sand05#Let's knock out another puzzle."];
			
			if (!PlayerData.sandMale) {
				// S is a girl..
				DialogTree.replace(tree, 4, "He's textin'", "She's textin'");
				DialogTree.replace(tree, 4, "his phone", "her phone");
				DialogTree.replace(tree, 5, "asked him", "asked her");
				if (PlayerData.gender != PlayerData.Gender.Girl) {
					// K is a boy...
					DialogTree.replace(tree, 32, "lower my balls into your mouth", "wrap my mouth around your cock");
				} else {
					// K is a girl...
					DialogTree.replace(tree, 32, "lower my balls into your mouth", "wrap my mouth around your cunt");
				}
				DialogTree.replace(tree, 33, "lick this jizz off your snout", "squirt all over your face");
				DialogTree.replace(tree, 33, "gonna", "about to");
			}
			
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				// K is a girl...
				DialogTree.replace(tree, 2, "he wants", "she wants");
				DialogTree.replace(tree, 2, "killin' his boner", "killin' the moment");
				DialogTree.replace(tree, 2, "his ex", "her ex");
				DialogTree.replace(tree, 5, "man?", "girl?");
				DialogTree.replace(tree, 13, "he's trying to get his", "she's trying to get her");
				DialogTree.replace(tree, 21, "Man,", "Tsk,");
				DialogTree.replace(tree, 31, "his relationship is his", "her relationship is her");
				DialogTree.replace(tree, 31, "askin' him", "askin' her");
				DialogTree.replace(tree, 100, "Thanks man", "Thanks girl");
			}
		} else if (PlayerData.level == 2) {
			tree[0] = ["#sand05#So yeah, I mean I was probably gonna call K and apologize. Just as a gesture, you know. But I still don't get it, I don't think they're both bein' completely honest with me."];
			tree[1] = ["#sand06#I think somethin' else is goin' on, what do you think?"];
			tree[2] = [10, 20, 30, 40, 50];
			
			tree[10] = ["S's\nlooking for\nany excuse\nto break\nup with K"];
			tree[11] = ["#sand04#Damn, you think so? So like, S's tired of K and just wants to break it off... but rather than just break up directly, S thinks, \"Eh, he fucked someone else,\""];
			tree[12] = ["#sand05#\"...so I'll just make a big deal out of it this time, that way I can break up with him and look like the good guy,\" somethin' like that?"];
			tree[13] = ["#sand06#..."];
			tree[14] = ["#sand08#I mean seems like an easy out. But I just wonder like, why the fuck would they get back together in the first place?"];
			tree[15] = ["#sand06#If S was so sick of K, it seems like an easy problem to solve, just don't get back together. But I mean, it would explain why S was so pissed at me."];
			tree[16] = ["#sand05#He wasn't really pissed, he was just puttin' on a show. Adds up I guess."];
			tree[17] = [100];
			
			tree[20] = ["K's using\nyou to\nmanipulate\nS into\nhaving\nmore sex"];
			tree[21] = ["#sand04#Damn, you think so? So like, lemme get this straight, S isn't giving him what he wants... So K thinks, \"I'll just go fuck someone else...\""];
			tree[22] = ["#sand05#\"...that way next time I'm feeling horny, Scrafty will know I'm not kidding around and he'll give me what I ask for,\" somethin' like that?"];
			tree[23] = ["#sand06#..."];
			tree[24] = ["#sand05#I dunno man, seems fuckin' immature if you ask me. You really think K'd be that passive aggressive about that shit? Damn."];
			tree[25] = ["#sand06#Why not just talk about it, right? \"Hey, I'm feelin' sexually starved in this relationship, so how can we make this work,\" I dunno, seems easy."];
			tree[26] = ["#sand05#Sounds like the two of them gotta learn to communicate."];
			tree[27] = [100];
			
			tree[30] = ["K's\ntrying to\nsabotage\nthe\nrelationship"];
			tree[31] = ["#sand04#Damn, you think so? So like, K's tired of S and just wants to break it off... but rather than bein' direct, K thinks \"Oh, I'll just cheat on him...\""];
			tree[32] = ["#sand05#\"...that way he'll have to break up with me, and we can both move on,\" somethin' like that?"];
			tree[33] = ["#sand06#..."];
			tree[34] = ["#sand05#I mean why wouldn't he just break up with him directly? I guess maybe he's tried breaking up and it never stuck. Maybe he thought it'd stick this way."];
			tree[35] = ["#sand12#I dunno, ugh. How can you treat another person like that? How can you treat two other people like that. Shit, I hope you're wrong. I kinda like K."];
			tree[36] = [100];
			
			tree[40] = ["S's\nseeking\nattention\nany way\nhe can\nget it"];
			tree[41] = ["#sand04#Damn, you think so? So like S just wants attention, so when K cheats on him he thinks, \"Well I'm not surprised that K's cheating on me,\""];
			tree[42] = ["#sand05#\"...but if I make a big deal out of it, people will think I'm a better person and they'll want to come talk to me,\" somethin' like that?"];
			tree[43] = ["#sand06#..."];
			tree[44] = ["#sand10#I mean I'm not that close with S, but I like to think he'd be better than that. Fuck, I like to think ANYBODY would be better than that."];
			tree[45] = ["#sand09#Does anybody actually live their life that way? Damn, you're gonna give me nightmares! I really hope you're wrong, S seems like a nice guy."];
			tree[46] = [100];
			
			tree[50] = ["I think\nyou should\nstay out\nof it"];
			tree[51] = ["#sand10#..."];
			tree[52] = ["#sand06#Sure man whatever, point taken. Sorry for roping you into this."];
			tree[53] = [100];
			
			tree[100] = ["#sand02#...Alright anyway, one last puzzle right? Let's do it."];
			
			if (!PlayerData.sandMale) {
				// S is a girl...
				DialogTree.replace(tree, 12, "good guy", "better person");
				DialogTree.replace(tree, 16, "He wasn't", "She wasn't");
				DialogTree.replace(tree, 22, "and he'll", "and she'll");
				DialogTree.replace(tree, 31, "cheat on him", "cheat on her");
				DialogTree.replace(tree, 32, "way he'll", "way she'll");
				DialogTree.replace(tree, 34, "with him directly", "with her directly");
				DialogTree.replace(tree, 40, "he can", "she can");
				DialogTree.replace(tree, 41, "cheats on him", "cheats on her");
				DialogTree.replace(tree, 41, "he thinks", "she thinks");
				DialogTree.replace(tree, 44, "think he'd", "think she'd");
				DialogTree.replace(tree, 45, "nice guy", "nice girl");
			}
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				// K is a girl...
				DialogTree.replace(tree, 11, "he fucked", "she fucked");
				DialogTree.replace(tree, 12, "with him", "with her");
				DialogTree.replace(tree, 21, "giving him what he", "giving her what she");
				DialogTree.replace(tree, 24, "I dunno man", "I dunno girl");
				DialogTree.replace(tree, 34, "wouldn't he", "wouldn't she");
				DialogTree.replace(tree, 34, "maybe he's", "maybe she's");
				DialogTree.replace(tree, 34, "Maybe he", "Maybe she");
				DialogTree.replace(tree, 52, "Sure man", "Sure girl");
			}			
		}
	}
	
	public static function stealMoney(tree:Array<Array<Object>>, puzzleState:PuzzleState){
		var amountStr:String = moneyString(puzzleState._lockedPuzzle != null ? puzzleState._lockedPuzzle._reward : puzzleState._puzzle._reward);
		if (PlayerData.level == 0) {
			tree[0] = ["#sand05#Alright time for more puzzles! Then we can... Huh?"];
			tree[1] = ["#sand06#I never noticed these little chests over here. Is this where they..."];
			tree[2] = ["#sand11#...Holy shit there's like " + amountStr + " in this one! You think I can keep this?"];
			tree[3] = [10, 40, 30, 20];
			
			tree[10] = ["I think\nthat's mine"];
			tree[11] = ["#sand03#Nah it's cool, I just need like 5$, you can have the rest."];
			tree[12] = [50];
			
			tree[20] = ["No don't\ntouch it"];
			tree[21] = [11];
			
			tree[30] = ["Yeah sure\nit's yours"];
			tree[31] = ["#sand03#Cool thanks! I just need like 5$, you can have the rest."];
			tree[32] = [50];
			
			tree[40] = ["Maybe, ask\nAbra"];
			tree[41] = [11];
			
			tree[50] = ["%fun-longbreak%"];
			tree[51] = ["#sand02#I'ma go see if Heracross is selling anything for 5$. I'll be back, hold tight a bit."];
			tree[52] = ["%siphon-puzzle-reward-0-5%"];
			
			tree[10000] = ["%siphon-puzzle-reward-0-5%"];
			tree[10001] = ["%fun-longbreak%"];
		} else if (PlayerData.level == 1) {
			tree[0] = ["#sand12#Damnit man, Heracross has this awesome reptile dildo but it's like WAY too expensive. Maybe there's more in these chests..."];
			tree[1] = ["#sand02#Awww damn you got like " + amountStr + " more in here! ...Mind if I borrow this?"];
			tree[2] = [20, 40, 10, 30];
			
			tree[10] = ["No,\nplease"];
			tree[11] = ["#sand15#Nah don't worry, I'll give it back later! It's cool, I got this."];
			tree[12] = [50];
			
			tree[20] = ["Stop stealing\nmy money!!"];
			tree[21] = [11];
			
			tree[30] = ["Yeah okay,\ntake what\nyou want"];
			tree[31] = ["%setvar-1-1%"];
			tree[32] = ["#sand03#Thanks man, you're the best! \"Five finger\" discount amirite? Heh! Heh."];
			tree[33] = [50];
			
			tree[40] = ["Sure, if\nyou buy me\nthat dildo"];
			tree[41] = ["#sand14#Ay what!? C'mon I saw it first. Why you gotta be so greedy!"];
			tree[42] = ["#sand15#Anyway I'll be right back. You're gonna love this thing when you see it~"];
			tree[43] = [50];
			
			tree[50] = ["%siphon-entire-puzzle-reward-0%"];
			tree[51] = ["%fun-alpha0%"];
			
			tree[10000] = ["%siphon-entire-puzzle-reward-0%"];
			tree[10001] = ["%fun-alpha0%"];
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				DialogTree.replace(tree, 0, "Damnit man", "Damnit girl");
				DialogTree.replace(tree, 32, "Thanks man", "Thanks girl");
			}
		} else if (PlayerData.level == 2) {
			tree[0] = ["%enterabra%"];
			tree[1] = ["#abra12#Sandslash has something he wants to say."];
			tree[2] = ["#sand12#...Tsk, I'm sorrrryyyyy."];
			tree[3] = ["#abra06#You're sorry \"what\"?"];
			tree[4] = ["#sand12#Sorry I like, tsk... Like, borrowed your money to buy a dildo or somethin'."];
			tree[5] = ["#abra13#You're sorry you STOLE his money. STOLE."];
			if (PuzzleState.DIALOG_VARS[1] == 1) {
				tree[6] = ["#sand01#Hey <name> said I could take it! It was like... payment for services rendered. C'mon man, after all I do? Heh! Heh. Heh."];
			} else {
				tree[6] = ["#sand01#Hey that wasn't, well like... Wasn't STEALING, was more like payment for services rendered! C'mon man, after all I do? Heh! Heh. Heh."];
			}
			tree[7] = ["%reimburse-0%"];
			tree[8] = ["#sand12#...Okay okay I'll give it back! Tsk, whatever."];
			tree[9] = ["%exitabra%"];
			tree[10] = ["#sand02#I don't need any sorta, expensive dildo anyway. You're the only dildo I need, <name>~"];
			tree[11] = [30, 20, 50, 40];
			
			tree[20] = ["Ummm...\nthanks?"];
			tree[21] = ["#sand01#C'mon one more puzzle. Then I'm gonna take a lot more than your money. Heh! Heh."];
			
			tree[30] = ["That's...\ngross"];
			tree[31] = [21];
			
			tree[40] = ["Damn right\nI am"];
			tree[41] = [21];
			
			tree[50] = ["So now\nyou're gonna\nwant anal\nafter this"];
			tree[51] = ["#sand03#Heh! Heh. Now who's the fuckin' telepath? Abra's got nothin' on you man, nothin'."];
			tree[52] = ["#sand01#Alright alright, one more puzzle. Then I'm gonna take a lot more than your money, if you know what I'm sayin~"];
			
			tree[10000] = ["%reimburse-0%"];
			
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				DialogTree.replace(tree, 5, "his money", "her money");
				DialogTree.replace(tree, 51, "you man", "you girl");
			} else if (PlayerData.gender == PlayerData.Gender.Complicated) {
				DialogTree.replace(tree, 5, "his money", "their money");
			}
			if (!PlayerData.sandMale) {
				DialogTree.replace(tree, 1, "something he", "something she");
			}
			if (!PlayerData.abraMale) {
				DialogTree.replace(tree, 6, "C'mon man", "C'mon girl");
			}
		}
	}
	
	public static function abraAbsent(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0) {
			tree[0] = ["%abra-gone%"];
			tree[1] = ["#sand02#Hey one sec."];
			tree[2] = ["#sand14#ABRA!"];
			tree[3] = ["#sand15#HEY ABRA ARE YOU AROUND HERE?? ABRA!!!"];
			tree[4] = ["#sand03#Heh! Heh. Okay <name>, solve this one without me. I'll be back in a minute."];
			tree[5] = ["%fun-gag%"];
			tree[6] = ["%fun-shortbreak%"];
			tree[10000] = ["%fun-gag%"];
			tree[10001] = ["%fun-shortbreak%"];
		} else if (PlayerData.level == 1) {
			tree[0] = ["%abra-gone%"];
			tree[1] = ["%fun-gag%"];
			tree[2] = ["#sand16#Mm cmwmph m lmph mph mmnm Mbrm'ph bmph stmphpmp dh mthm dmph. Mm nmm mmm, mm pmmbmph phmbm'p mph-"];
			tree[3] = ["#sand17#Bmm hm'ph lphm tmm yrsh mmpm m thrmphy yrr lm mthpm plsh, mmby'ph brmly pmm dmp mmdr prmphmpll..."];
			tree[4] = ["#sand16#Hph mrmphy prm's pry lm tmm, ydmnmm, drr thmph smm nrmphl pm mm?"];
			tree[5] = [10, 20, 30, 40];
			
			tree[10] = ["I don't\nunderstand"];
			tree[11] = ["#sand17#...rrrmph?"];
			tree[12] = ["#sand16#Wrr, rrgrsh drmrr rchrch-kkh."];
			tree[13] = [100];
			
			tree[20] = ["That's no\nbig deal"];
			tree[21] = ["#sand17#Ymm, ymdmm, ymchmm dmm'ph wmmhmm prr gr trmphm drphrmpch rph."];
			tree[22] = ["#sand16#Chmph 'crph hss sphrmphpllgmph drmph mm bmp wmph pkh drphrmpch mph fmpmchrmph srchrmph."];
			tree[23] = [100];
			
			tree[30] = ["He should\nlook into\nthat"];
			tree[31] = ["#sand17#...rrrmph,"];
			tree[32] = ["#sand16#Rssrwrr rrthrmph kmph. Mm hrmphkl rskrphbll rmph."];
			tree[33] = [100];
			
			tree[40] = ["It depends\non the\namortization\nschedule"];
			tree[41] = ["#sand17#...Mmm? Mm mphmll dmph nmpn mm 'rmphrmphchd' mph. Rmphl kll drphrmph krr mm lmmn?"];
			tree[42] = ["#sand16#Mm grmph mm shmph trkthmph mmphl wmph Mbrm phrmph."];
			tree[43] = [100];
			
			tree[100] = ["#sand17#Mmrmph, lrm'ph trm rmb-br prbbl."];
			
			if (!PlayerData.abraMale) {
				DialogTree.replace(tree, 3, "hm'ph", "shhm'ph");
				DialogTree.replace(tree, 3, "mmby'ph", "mmbshy'ph");
				DialogTree.replace(tree, 21, "wmmhmm", "wmmrr");
				DialogTree.replace(tree, 30, "He should", "She should");
			}
		} else if (PlayerData.level == 2) {
			tree[0] = ["%abra-gone%"];
			tree[1] = ["%fun-nude1%"];
			tree[2] = ["%fun-gag-out%"];
			tree[3] = ["#sand01#*sptooey* Yeah sorry, if I knew Abra was gonna be gone this long I woulda seen about gettin' that butt plug set up again. Heh! Heh."];
			tree[4] = [10, 20, 30];
			
			tree[10] = ["No thank\nyou"];
			tree[11] = ["#sand05#Aww c'mon! You got something against butt plugs? I mean it's not like they're-"];
			tree[12] = [50];
			
			tree[20] = ["Maybe next\ntime"];
			tree[21] = ["#sand05#Alright I mean-- we'll see, if it happens it happens. And it's not like it's gonna-"];
			tree[22] = [50];
			
			tree[30] = ["Go and\nget it"];
			tree[31] = ["#sand05#I mean it's a little late for a butt plug don't you think? I mean we're already-"];
			tree[32] = [50];
			
			tree[50] = ["#sand02#Well wait a minute, outta curiosity... Whaddya think a butt plug does exactly?"];
			tree[51] = [60, 70, 80, 90];
			
			tree[60] = ["Keeps the\npoop in"];
			tree[61] = ["#sand10#...The fuck is...? What? It's not like I'm-- I'm not saving it. What the heck?"];
			tree[62] = ["#sand09#Keeps poop in? Who would buy that...! Nah man, nahhhh..."];
			tree[63] = [100];
			
			tree[70] = ["Keeps the\nbutt loose"];
			tree[71] = ["#sand03#Yeah! So you're ready for anything."];
			tree[72] = [101];
			
			tree[80] = ["Keeps the\npenises out"];
			tree[81] = ["#sand05#...Wait, did you think I was tryin' to keep penises out? Nah man, I welcome penises."];
			tree[82] = ["#sand10#Have I been sending you the wrong signals or something? For sure if you know any penises, you send 'em my way."];
			tree[83] = [100];
			
			tree[90] = ["Works like\nan air\nfreshener"];
			tree[91] = ["#sand03#Ha ha, wait, you're thinking like-- one of those plug-in air fresheners? Butt-plug-in air fresheners? Heh! Heh."];
			tree[92] = ["#sand02#Nah man, different kind of plug. Heh! Heh, heh. What the heck man."];
			tree[93] = [100];
			
			tree[100] = ["#sand04#Butt plugs keep your butt loose and ready, you know, so you don't gotta take time preparing for anal. I mean, you always gotta be ready. Just in case, y'know?"];
			tree[101] = ["#sand05#It's like you know, you're chillin' at home, hear a knock on the door. \"Knock knock!\" Who's there? \"Sex.\" Sex who?"];
			tree[102] = ["#sand10#\"Butt sex.\" Aw damn! Wait one second, I gotta clean myself up, I gotta get some lube, I gotta prep myself a little, I gotta, I gotta-"];
			tree[103] = ["#sand09#-SLAM!- Too slow. See ya later, butt sex. No butt sex for me today."];
			tree[104] = ["#sand14#Nah! Not on my watch. Gotta, gotta... always be prepared! It's like the butt plug motto or some shit."];
			tree[105] = ["#sand15#Alright alright, last puzzle, let's do it."];
			
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				DialogTree.replace(tree, 62, " man,", " girl,");
				DialogTree.replace(tree, 80, "penises", "dildos");
				DialogTree.replace(tree, 81, " man,", " girl,");
				DialogTree.replace(tree, 81, "penises", "dildos");
				DialogTree.replace(tree, 82, "penises", "dildos");
				DialogTree.replace(tree, 92, " man,", " girl,");
			}
		}
	}
	
	public static function needMoreClothes(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0) {
			tree[0] = ["%fun-gag%"];
			tree[1] = ["%fun-plug%"];
			tree[2] = ["#sand16#Mrrl-rrph!"];
			tree[3] = ["#sand17#Lrrph gmph sprmffl mrph lph frphh prpphllt-"];
			tree[4] = ["%enterabra%"];
			tree[5] = ["#abra13#No no no no no! What are you doing! I told you TWO articles of clothing! TWO!!!"];
			tree[6] = ["%fun-gag-out%"];
			tree[7] = ["#sand12#*sptooey* Aww are you bein' serious right now? C'mon, who's this hurting? Why can't you just let me-"];
			tree[8] = ["#abra13#A ball gag is NOT an article of clothing! A... a butt plug is NOT an article of clothing!"];
			tree[9] = ["#sand04#Tsk-- right man, just chill out. I'll be back in a minute."];
			tree[10] = ["%fun-normal%"];
			tree[11] = ["%fun-alpha0%"];
			tree[12] = ["#abra05#Sorry to rain on your, hmmm... naked sandslash parade."];
			tree[13] = ["#abra04#But if everyone just strolled out here without any clothes, sporting bondage gear and... sexual paraphernalia then... we wouldn't really get any puzzle solving done!"];
			tree[14] = ["#abra06#And what would this game be like if you removed all of the puzzles?"];
			tree[15] = [20, 30, 40, 50, 60];
			
			tree[20] = ["It would be\nway better"];
			tree[21] = [100];
			tree[30] = ["That would\nbe awesome"];
			tree[31] = [100];
			tree[40] = ["Fuck these\npuzzles"];
			tree[41] = [100];
			tree[50] = ["Are you\nserious"];
			tree[51] = [100];
			tree[60] = ["I would\nenjoy that"];
			tree[61] = [100];
			
			tree[100] = ["#abra12#That was a rhetorical question you nitwit!!"];
			tree[101] = ["#abra08#...You see, in order for-"];
			tree[102] = ["%fun-alpha1%"];
			tree[103] = ["#sand05#Alright, this any better?"];
			tree[104] = ["#abra12#What!! Is that the... are you doing this on purpose!? Don't you own any jeans? Boxer shorts? Footie pajamas? Anything?"];
			tree[105] = ["#sand06#I dunno man, I think I got like-- this same thong in a transparent mesh..."];
			tree[106] = ["#abra09#..."];
			tree[107] = ["#abra08#Just... just start the stupid puzzle..."];
			tree[10000] = ["%fun-normal%"];
			tree[10001] = ["%fun-alpha1%"];
			
			if (!PlayerData.sandMale) {
				DialogTree.replace(tree, 104, "jeans? Boxer shorts? Footie pajamas?", "pants? A skirt or a swimsuit...");
			}
			if (!PlayerData.abraMale) {
				DialogTree.replace(tree, 9, "right man", "right girl");
				DialogTree.replace(tree, 105, "I dunno man", "I dunno girl");
			}
		} else if (PlayerData.level == 1) {
			tree[0] = ["#sand02#Dang you're like, crazy good at these puzzles! Are you-"];
			tree[1] = ["%enterabra%"];
			tree[2] = ["#abra13#What...? What are you doing!! Put your underwear back on!"];
			tree[3] = ["#abra12#I would think YOU of all people would have experience with these types of hentai games!! Underwear comes off last! What's WRONG with you?"];
			tree[4] = ["#sand03#Wrong with me? ...What's wrong with you! I look outstanding in a bowtie."];
			tree[5] = ["#sand05#...Besides that, it feels good letting my dick breathe a little."];
			tree[6] = ["#abra08#*sigh* We're trying to motivate the player here. What's going to motivate the player to solve a second puzzle if you're already naked?"];
			tree[7] = ["#sand06#Well I dunno man! ...Maybe he's complicated. ...Maybe he's like, y'know, really into necks or something."];
			tree[8] = ["#abra09#...You're so, so very naive. I can read the player's thoughts, he's already trying to figure out how to quit the game."];
			tree[9] = ["#sand06#C'mon, what? D'you really think he'd quit?"];
			tree[10] = ["#abra12#\"Really into necks!\" Tsk. Just you wait, he's going to quit any second now."];
			if (!PlayerData.sandMale) {
				DialogTree.replace(tree, 5, "my dick", "my pussy");
			}
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				DialogTree.replace(tree, 7, "he's", "she's");
				DialogTree.replace(tree, 8, "he's", "she's");
				DialogTree.replace(tree, 9, "he'd", "she'd");
				DialogTree.replace(tree, 10, "he's", "she's");
			} else if (PlayerData.gender == PlayerData.Gender.Complicated) {
				DialogTree.replace(tree, 7, "he's", "they're");
				DialogTree.replace(tree, 8, "he's", "they're");
				DialogTree.replace(tree, 9, "he'd", "they'd");
				DialogTree.replace(tree, 10, "he's", "they're");
			}
			if (!PlayerData.abraMale) {
				DialogTree.replace(tree, 7, "I dunno man", "I dunno girl");
			}
		} else if (PlayerData.level == 2) {
			tree[0] = ["%enterabra%"];
			tree[1] = ["#sand03#See, what'd I tell you, Abra! You were all worried about nothing."];
			tree[2] = ["#sand06#Outta curiosity though <name>, what-- so what kept you motivated to solve that last puzzle?"];
			tree[3] = [10, 20, 30, 40, 50];
			
			tree[10] = ["I'm really\ninto necks"];
			tree[11] = ["#abra06#Necks? Really? Hmph you got lucky, Sandslash."];
			tree[12] = ["#abra05#3.2 billion people with internet and we connect with the one guy who's really into necks."];
			tree[13] = [100];
			
			tree[20] = ["I couldn't\nfigure out\nhow to\nquit"];
			tree[21] = ["#abra06#...Are you actually THAT stupid? Did you even try clicking the button in the co-"];
			tree[22] = ["#abra08#I mean... errm..."];
			tree[23] = ["#abra02#Good job! You're still learning, aren't you? There's so many big buttons for you to press."];
			tree[24] = ["#abra04#I'm glad you stayed with us and solved another puzzle! That puzzle was hard, wasn't it? You're so clever at puzzles."];
			tree[25] = [100];
			
			tree[30] = ["I want\nto fool\naround with\nSandslash\nlater"];
			tree[31] = ["#abra08#Hmph well, I suppose the nudity is redundant since the player's still motivated by the sexual contact at the end..."];
			tree[32] = ["#abra12#...But still! No more breaking my rules okay? Three puzzles! Two articles of clothing!"];
			tree[33] = [200];
			
			tree[40] = ["I wanted\nto prove\nAbra wrong"];
			tree[41] = ["#abra04#Wrong!?! ...I wasn't wrong! I... I said those things to manipulate you."];
			tree[42] = ["#abra02#I knew you couldn't bear to quit if doing so would give me the satisfaction of being right. Ee-heh-heh."];
			tree[43] = [200];
			
			tree[50] = ["I\njust like\npuzzles"];
			tree[51] = ["#abra04#Really? You're not motivated by the nudity, the sexual contact? You just like the puzzles?"];
			tree[52] = ["#abra05#..."];
			tree[53] = ["#abra00#...Well, I like puzzles too."];
			tree[54] = [100];
			
			tree[100] = ["#sand12#See man, you don't gotta babysit me... Your dress code, your... weird dick rules, none of this shit matters. He's not leavin' or anything. So -"];
			tree[101] = ["#sand13#So wouldja give us some privacy already? I'm trying' to establish some freakin' ambiance."];
			tree[102] = ["%exitabra%"];
			tree[103] = ["#abra13#...Hmph! Rude!"];
			tree[104] = ["#sand04#So, anyway... ahem-"];
			tree[105] = ["#sand02#You KNOW you gotta solve this third puzzle or I'll never hear the end of it. Heh! Heh."];
			
			tree[200] = ["#sand12#Whatever man, you don't gotta babysit me... Your dress code, your... weird dick rules, none of this shit matters. He's not leavin' or anything. So -"];
			tree[201] = [101];
			
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				DialogTree.replace(tree, 12, "one guy", "one girl");
				DialogTree.replace(tree, 100, "He's not", "She's not");
				DialogTree.replace(tree, 200, "He's not", "She's not");
			} else if (PlayerData.gender == PlayerData.Gender.Complicated) {
				DialogTree.replace(tree, 12, "one guy", "one person");
				DialogTree.replace(tree, 100, "He's not", "They're not");
				DialogTree.replace(tree, 200, "He's not", "They're not");
			}
			if (!PlayerData.sandMale) {
				DialogTree.replace(tree, 100, "weird dick", "weird pussy");
				DialogTree.replace(tree, 200, "weird dick", "weird pussy");
			}
			if (!PlayerData.abraMale) {
				DialogTree.replace(tree, 100, "See man", "See Abra");
				DialogTree.replace(tree, 200, "Whatever man", "Whatever Abra");
			}
		}
	}
	
	public static function random00(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#sand02#Hey one sec."];
		tree[1] = ["#sand14#ABRA!"];
		tree[2] = ["%enterabra%"];
		tree[3] = ["#abra04#...Eh? Did you call for me?"];
		tree[4] = ["#sand06#Oh! Uhh, yeah."];
		var which:Int = LevelIntroDialog.getChatChecksum(puzzleState) % 3;
		if (which == 0) {
			tree[5] = ["#sand05#I'm uhh, taking out the trash. You got anything to take out?"];
			tree[6] = ["#abra02#Oh well yes-- yes I'll go empty my trash."];
			tree[7] = ["%exitabra%"];
			tree[8] = ["#sand06#..."];
			tree[9] = ["#sand04#Alright, so first puzzle. Let's-"];
			tree[10] = ["%enterabra%"];
			tree[11] = ["#abra05#Here you go, here's my trash. Thanks, by the way."];
			tree[12] = ["#sand10#..."];
			tree[13] = ["#sand06#Uhh, nevermind, I don't wanna do that."];
			tree[14] = ["#abra12#..."];
			tree[15] = ["%exitabra%"];
			tree[16] = [100];
		} else if (which == 1) {
			tree[5] = ["#sand05#I'm uhh, placing an order to Effen Pizza. Did you want anything?"];
			tree[6] = ["#abra06#...Pizza?"];
			tree[7] = ["#abra04#...There's leftover pizza in the fridge from yesterday. Why do you want to order more pizza?"];
			tree[8] = ["#sand03#Oh uhhh that's right. Nevermind."];
			tree[9] = ["#abra05#I'm actually about to heat some up for myself, did you want a slice?"];
			tree[10] = ["#sand10#..."];
			tree[11] = ["#sand06#Nnn-I'm uhhh... Nah I'm not hungry."];
			tree[12] = ["%exitabra%"];
			tree[13] = ["#abra12#..."];
			tree[14] = [100];
		} else if (which == 2) {
			tree[5] = ["#sand05#...Just checking."];
			tree[6] = ["#abra12#..."];
			tree[7] = ["#abra13#I know what you're doing. The underwear stays on for the first puzzle."];
			tree[8] = ["%exitabra%"];
			tree[9] = ["#abra12#Even when I'm NOT here."];
			tree[10] = ["#sand02#Heh! Heh, c'mon what makes you think I was-"];
			tree[11] = ["#abra13#I'm telepathic, you idiot."];
			tree[12] = ["#sand10#..."];
			tree[13] = ["#sand12#Tsk, what a killjoy."];
			tree[14] = [100];
		}
		tree[100] = ["#sand04#Alright, so first puzzle. Let's do this."];
	}
	
	public static function random01(tree:Array<Array<Object>>, puzzleState:PuzzleState){
		tree[0] = ["#sand02#Oh hey! Ready for some more puzzles? I know I'm-"];
		tree[1] = ["%enterabra%"];
		tree[2] = ["#abra04#Just a minute, before you get started- rent's up tomorrow. Don't forget."];
		tree[3] = ["#sand05#Yeah man! I'm good for it."];
		tree[4] = ["%exitabra%"];
		tree[5] = ["#sand02#Abra and I-- We don't got steady jobs like some of the others, but we both got our own ways of makin' a quick buck."];
		tree[6] = ["#sand03#Heh! Heh. Heh. Tomorrow's gonna be a good day. Alright, first puzzle. Let's do it."];
		
		if (!PlayerData.abraMale) {
			DialogTree.replace(tree, 3, "Yeah man", "Yeah girl");
		}
	}
	
	public static function random02(tree:Array<Array<Object>>, puzzleState:PuzzleState){
		if (PlayerData.difficulty == PlayerData.Difficulty.Easy || PlayerData.difficulty == PlayerData.Difficulty._3Peg) {
			tree[0] = ["#sand03#Awwwww yeah, let's knock this shit out! Three easy puzzles."];
			tree[1] = ["#sand01#Three easy puzzles between you and you-know-what."];
			tree[2] = ["#sand15#Should be no time at all right? Let's get on with it!"];
		} else {
			tree[0] = ["#sand06#Awwwww man, you don't like to make this easy for yourself do ya?"];
			tree[1] = ["#sand05#Three tough puzzles before you and I can-- you know."];
			tree[2] = ["#sand14#Why'd you hafta pick this difficulty anyway? You tryin' to impress me?"];
			
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				DialogTree.replace(tree, 0, "man,", "girl,");
			}
		}
	}
	
	public static function random03(tree:Array<Array<Object>>, puzzleState:PuzzleState){
		var count:Int = PlayerData.recentChatCount("sand.randomChats.0.3");
		
		if (count % 3 == 1) {
			tree[0] = ["#sand03#Ayyy it's <name>! 'bout time you showed up man, gets boring as fuck out here with-"];
			tree[1] = ["%entermagn%"];
			tree[2] = ["#magn04#-MAGNEZONE LOG- Subject is dressed provocatively. Subject is wearing a bowtie and a pair of thong underwear."];
			tree[3] = ["#sand12#Man! Why's everyone always bustin' in here and killing my vibe."];
			tree[4] = ["#magn14#..."+MagnDialog.MAGN+" is not &lt;killing your vibe&gt;. " + MagnDialog.MAGN + " is accompanying your vibe with a " + MagnDialog.MAGN + " vibe."];
			tree[5] = ["#magn04#-MAGNEZONE LOG- Subject's genitals are clearly discernible. [[file saved: 00515425.jpg]]"];
			tree[6] = ["#sand13#Ayy wait, wait wait wait wait, hold up a second, c'mon! ...C'mon! No cameras!! Cameras cost extra."];
			tree[7] = ["#magn10#...But... -fzzt- But " + MagnDialog.MAGN + " IS a camera."];
			tree[8] = ["#sand12#Yeah yeah that's right, I know what I said. Now pay up or get out."];
			tree[9] = ["#magn15#... ..."];
			tree[10] = ["#magn05#" + MagnDialog.MAGN + " will &lt;pay up&gt;. ... ...Is this payment sufficient? (Y/N)"];
			tree[11] = ["#sand11#...Holy shit that's a ^5,000 note!!"];
			tree[12] = ["#sand06#Okay okay man, you can stay. Damn. Alright. Just like, uhh. Sit in the corner. And like, be quiet or somethin'."];
			tree[13] = ["%exitmagn%"];
			tree[14] = ["#magn06#-ACTIVATING SILENT MODE-"];
			tree[15] = ["#sand01#Uhh damn. Yeah. Okay <name>, let's do it I guess. Let's put on a little show~"];
		} else {
			tree[0] = ["#sand03#Ayyy it's <name>! 'bout time you showed up man, gets boring as fuck out here with nobody to play with."];
			tree[1] = ["#sand02#...How you been? You been lookin' out for yourself? Honing those... puzzling chops? Or whatever it is you do here?"];
			tree[2] = ["#sand15#Right, right, I bet you have. Alright why don't you show me what you got~"];
		}
	}
	
	public static function random10(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("sand.randomChats.1.0");
		
		if (count % 4 == 1) {
			tree[0] = ["#sand04#So hey you got any hobbies? You do anything to get out of the house?"];
			for (i in [10, 30, 50, 70]) {
				tree[i + 1] = ["#sand02#Ah yeah man I hear you! Personally I spend a couple hours a day at the gym."];
				tree[i + 2] = ["#sand05#Exercise gym! Not like, Pokemon gym. Well - alright, Pokemon exercise gym. I think you get me."];
				tree[i + 3] = ["#sand04#Really it's just a cover-- I mean, everyone's just there for casual sex. All the gym equipment just gathers dust."];
				tree[i + 4] = ["#sand03#No lie, I've been to the gym six times this week and feel my bicep? 'slike a... wet sack of spinach. Heh!"];
				
				if (PlayerData.gender == PlayerData.Gender.Girl) {
					DialogTree.replace(tree, i + 1, "yeah man", "yeah girl");
				}
			}
			tree[1] = [10, 30, 50, 70];
			tree[10] = ["I like\nsports"];
			tree[15] = ["#sand02#Screwing around is a fine way to spend an evening though! And I mean it's uhh, kinda like a sport?"];
			tree[16] = ["#sand04#You know, a whole bunch of guys, usually teams of 3 or 4 each trying to score..."];
			tree[17] = ["#sand00#Usually last about 60-90 minutes, couple timeouts, buncha substitutions, uhh..."];
			tree[18] = ["#sand01#And maybe sometimes I get thrown out with a red card? Heh! Heh. C'mon, fuckers need to lighten up."];
			tree[19] = [100];
			tree[30] = ["I like\nexercise"];
			tree[35] = ["#sand02#Screwing around is a fine way to spend an evening though! 'spretty good exercise, but y'know...."];
			tree[36] = ["#sand01#An exercise with a whole lot of reps but just... one really, really long set. Heh! Heh."];
			tree[37] = ["#sand00#Well okay, I can usually go for a second set. On a really good day, maybe a third set after a little break."];
			tree[38] = ["#sand10#Four sets? ...c'mon, can't a guy get a glass of water first?"];
			tree[39] = ["#sand12#I'm not a machine! ... ...Four sets. Hmph."];
			tree[40] = [100];
			tree[50] = ["I like\nhanging out\nwith friends"];
			tree[55] = ["#sand02#Screwing around is a fine way to spend an evening though! Kinda beats just hangin' out, you know."];
			tree[56] = ["#sand04#I mean, you need the right kind of friends. But you tell me what's better--"];
			tree[57] = ["#sand00#Hanging out in the food court with three people? ...Or hanging out in the food court with three people you can bang in the men's room."];
			tree[58] = ["#sand01#Catching a movie with two buds? Or sucking their dicks in a dark movie theater while you're knee-deep in half-eaten popcorn. Heh! Heh."];
			tree[59] = ["#sand03#I mean it's like adding bacon to stuff! Just makes everything unconditionally better. Just too easy."];
			tree[60] = [100];
			tree[70] = ["I mostly\nstay inside"];
			tree[75] = ["#sand02#Screwing around is a fine way to spend an evening though! Don't feel like goin out? Ehh just stay home and fuck."];
			tree[76] = ["#sand04#Gotta meet someone first though-- gotta find that someone. Guess that's where the gym comes in handy."];
			tree[77] = ["#sand06#Well alright, maybe not the gym. I mean let's be real, the kinda guys frequenting a place like that aren't lookin' for anything long term."];
			tree[78] = ["#sand05#And I mean, makes sense to me. Who'd wanna be stuck eatin' like, one flavor of ice cream for the rest of your life?"];
			tree[79] = ["#sand06#Maybe people who don't like ice cream that much, I guess."];
			tree[80] = [100];
			
			tree[100] = ["#sand04#... ...Sorry, went on a tangent there. Let's try another puzzle."];
			
			if (!PlayerData.sandMale) {
				DialogTree.replace(tree, 16, "guys", "girls");
				DialogTree.replace(tree, 38, "can't a guy", "can't a girl");
				DialogTree.replace(tree, 57, "men's room", "ladies room");
				DialogTree.replace(tree, 58, "sucking their dicks", "eating out their pussies");
			}
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				DialogTree.replace(tree, 77, "kinda guys", "kinda girls");
			} else if (PlayerData.gender == PlayerData.Gender.Complicated) {
				DialogTree.replace(tree, 77, "kinda guys", "kinda people");
			}
		} else {
			tree[0] = ["#sand14#Tsk, heck yeah! That first puzzle always feels like such a fuckin' chore, lemme tell you..."];
			tree[1] = ["#sand13#I mean... makin' me wear underwear? This is my fuckin' free time, who's that Abra think he is, anyway..."];
			tree[2] = ["#sand02#Ahh whatever, we're half way there, right? Let's do this~"];
			
			if (!PlayerData.abraMale) {
				DialogTree.replace(tree, 1, "think he", "think she");
			}
		}
	}
	
	public static function randomPhone04(tree:Array<Array<Object>>, puzzleState:PuzzleState){
		var count:Int = PlayerData.recentChatCount("sand.randomChats.0.4");
		
		if (count == 0) {
			tree[0] = ["#sand02#Ayyy what's up, <name>!"];
			tree[1] = ["#sand03#I came as soon as I got your phone call. ...And then I answered the phone! Heh! Heh. heh."];
			tree[2] = ["#sand04#...Nahhh I'm just playin'. But seriously it was cool of you to call me."];
			tree[3] = ["#sand06#I know you usually use that phone in there to call like, all your special buddies over and whatever-"];
			tree[4] = ["#sand09#-and I know you and me, we can hang like, any time. But it meant a lot to me that like... Well you know."];
			tree[5] = ["#sand08#... ..."];
			tree[6] = ["#sand02#Heh! Yeah I know, I know, it's not like I'm trying to kill the mood here or some shit, it was just uhh. Nice to hear from you."];
			tree[7] = ["#sand06#..."];
			tree[8] = ["#sand10#... ...Aww, damn! Suddenly this puzzle seems like uhh REALLY interesting! Like... whoa, we got puzzles and shit! Let's pay attention to this for uhh, for awhile."];
		} else if (count % 3 == 0) {
			tree[0] = ["#sand03#Oh hey sweet, you came! I got your call and wasn't sure if you meant like... \"Right now\" right now."];
			tree[1] = ["#sand02#Anyway, what are we doin' today? The usual? ...The unusual? Little of both?"];
			tree[2] = ["#sand01#Yeahhhhh how 'bout a little of both~"];
		} else if (count % 3 == 1) {
			tree[0] = ["#sand02#Ayy pretty cool right? You called and I came!"];
			tree[1] = ["#sand04#It's like... an actual date or somethin'. Heh! Heh. Look at us bein' all mature about it."];
			tree[2] = ["#sand03#Next thing you're gonna have me like... doin' taxes and recycling cans and shit."];
		} else if (count % 3 == 2) {
			tree[0] = ["#sand02#Heh heyyyyyy man! Another day, another $10,000 phone call from Heracross, am I right?"];
			tree[1] = ["#sand15#Hope I'm worth it and shit! ...Guess I better bring my \"A\" game today. Let's do this~"];
			
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				DialogTree.replace(tree, 0, "heyyyyyy man", "heyyyyyy girl");
			}
		}
	}
	
	public static function random11(tree:Array<Array<Object>>, puzzleState:PuzzleState){
		if (PlayerData.difficulty == PlayerData.Difficulty.Easy || PlayerData.difficulty == PlayerData.Difficulty._3Peg) {
			tree[0] = ["#sand03#Damn! These puzzles usually take me a minute or so, you know, on a good day."];
			tree[1] = ["#sand02#You're doin' a pretty good job keepin' pace. Still though, the faster the better!"];
		} else {
			tree[0] = ["#sand04#Man, why you gotta make this shit so hard on yourself?"];
			tree[1] = ["#sand02#If this was easy difficulty you could be knuckle deep in my ass right now."];
			
			if (!PlayerData.sandMale) {
				DialogTree.replace(tree, 1, "in my ass", "in my pussy");
			}
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				DialogTree.replace(tree, 0, "Man,", "Girl,");
			}
		}
		tree[2] = ["#sand09#I mean I'm doin' my best to stay patient but... c'mon! I'm dyin' over here."];
		tree[3] = ["#sand01#Don't make me wait too much longer, alright?"];
	}
	
	public static function random12(tree:Array<Array<Object>>, puzzleState:PuzzleState){
		tree[0] = ["#sand14#Two more puzzles to go, unless, fuck it..."];
		tree[1] = ["%fun-nude2%"];
		tree[2] = ["#sand01#Let's make it one! You're okay with that right? You won't rat on me will ya?"];
		tree[3] = [10, 20];
		var which:Int = LevelIntroDialog.getChatChecksum(puzzleState) % 2;
		which = 1;
		if (which == 0) {
			tree[3] = [10, 30];
		}
		tree[10] = ["No, that's\ncheating"];
		tree[11] = ["#sand10#What!"];
		tree[12] = ["%fun-nude1%"];
		tree[13] = ["#sand04#Ehhhhh fine, 'sprobably good of you to keep me honest anyway."];
		tree[14] = ["#sand02#Don't wanna get in more trouble with Abra I guess."];
		tree[15] = ["#sand14#Alright, let's do this the hard way then."];
		
		tree[20] = ["Yes, let's\nskip one"];
		tree[23] = ["%skip%"];
		tree[21] = ["#sand14#Heh! Heh. Alright, now we're talkin'! Someone's got their priorities straight."];
		tree[22] = ["#sand15#Let's knock this one out quick before someone catches on."];
		
		tree[30] = ["Yes, let's\nskip one"];
		tree[31] = ["#sand14#Heh! Heh. Alright, now we're talkin'! Someone's got their priorities straight."];
		tree[32] = ["#sand15#Let's knock this one out quick before-"];
		tree[33] = ["%entergrov%"];
		tree[34] = ["#grov10#Ahhhh, pardon me! I do believe you've only solved one puzzle yes?"];
		tree[35] = ["#sand12#Aww grovyle! How'd you even know? You got like- telepathic powers too?"];
		tree[36] = ["#grov04#Well I'm not telepathic but I'm not deaf either...! And you've been narrating your intentions quite vividly."];
		tree[37] = ["%exitgrov%"];
		tree[38] = ["#grov02#Come now, if Abra discovers that I allowed you to cheat then you'll get us both in trouble."];
		tree[39] = ["%fun-nude1%"];
		tree[40] = ["#sand12#Alright alright whatever, let's just do this the hard way then."];
		
		tree[10000] = ["%fun-nude1%"];
	}
	
	public static function random20(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#sand00#So I was at the gym again last night-- you know, doin' my usual Sandslash stuff... Heh! Heh."];
		tree[1] = ["#sand05#This Floatzel guy though-- he's kind of a regular. Never really does anything. Just kinda watches. Guess that's his thing."];
		tree[2] = ["#sand06#So yeah he was watchin' me all last night.... I dunno, you ever heard anything like that? Just watching?"];
		if (PlayerData.recentChatTime("sand.randomChats.2.0") <= 100) {
			tree[1] = ["#sand05#Ran into Floatzel again! I think I've told you about him before. And again he's just watchin all night,"];
			tree[2] = ["#sand05#Touching himself as I'm fuckin' a couple different guys... I dunno, you ever heard anything like that? Just watching?"];
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				DialogTree.replace(tree, 1, "about him", "about her");
				DialogTree.replace(tree, 1, "he's just", "she's just");
				DialogTree.replace(tree, 2, "himself", "herself");
				DialogTree.replace(tree, 2, "guys", "girls");
			}
		}
		tree[3] = [10, 20, 30];
		tree[10] = ["Yes, I wouldn't\nmind watching"];
		tree[11] = ["#sand03#Guess that makes sense-- I mean you're kinda watching me right now, right?"];
		tree[12] = ["#sand02#You wouldn't be here if you didn't like to just watch sometimes. But not me, man--"];
		tree[13] = [40];
		tree[20] = ["Yes, but I'd\nwant to do more\nthan watch"];
		tree[21] = ["#sand02#Yeah exactly! That's all I'm saying. Guy musta fuckin' lost it to be content, just sitting there watching all night."];
		tree[22] = ["#sand15#I wanna get in there! It would drive me crazy to just watch."];
		tree[23] = [40];
		tree[30] = ["No, I haven't\nheard of just\nwatching"];
		tree[31] = [21];
		tree[40] = ["#sand14#I don't wanna sit on the sidelines, I wanna get my claws dirty. Like... really dirty. Heh! Heh."];
		tree[41] = ["#sand02#Anyway 'nuff about me and my dirty dirty claws. Let's see what you can do with this next puzzle."];
		
		if (PlayerData.gender == PlayerData.Gender.Girl) {
			DialogTree.replace(tree, 1, "Floatzel guy", "Floatzel girl");
			DialogTree.replace(tree, 1, "he's kind", "she's kind");
			DialogTree.replace(tree, 1, "his thing", "her thing");
			DialogTree.replace(tree, 2, "he was", "she was");
			DialogTree.replace(tree, 12, "me, man", "me, girl");
			DialogTree.replace(tree, 21, "Guy musta", "Girl musta");
		}		
	}
	
	public static function random21(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#sand02#It's too bad for you man, bein' on the other side of a computer monitor-- you're missin out on all these great sandslash smells."];
		tree[1] = ["#sand05#I was at the gym last night... and this nuzleaf guy, he's uhh, he's a regular there,"];
		tree[2] = ["#sand14#He was ALL up in my smells, man. My neck, my pits..."];
		tree[3] = ["#sand00#I guess it was kind of his thing."];
		tree[4] = ["#sand01#I dunno, maybe if me and you were face to face it would be your thing too. Tsk, I guess we'll never know."];
		
		if (PlayerData.recentChatTime("sand.randomChats.2.1") <= 100) {
			tree[2] = ["#sand03#...Well shit, I've talked about Nuzleaf before. You remember Nuzleaf!"];
			tree[3] = ["#sand00#But yeah that guy's always lickin' and sniffin' at my Sandslash bits... My feet, my nuts, sniffin everything... Guess it's kind of his thing."];
			
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				DialogTree.replace(tree, 3, "that guy's", "that girl's");
				DialogTree.replace(tree, 3, "his thing", "her thing");
			}
			if (!PlayerData.sandMale) {
				DialogTree.replace(tree, 3, "My feet, my nuts", "My pussy, my crack");
			}
		}
		
		tree[5] = [10, 20, 30];
		tree[10] = ["Smells aren't\nreally my\nthing"];
		tree[11] = ["#sand12#Not your thing??"];
		tree[12] = ["#sand14#C'mooonnnnnnn."];
		tree[13] = ["#sand02#...Fine, I'd throw on some Sandslash cologne for you or whatever, cover up my smells but-- trust me you'd be missing out."];
		tree[14] = [40];
		tree[20] = ["Well it\ndepends on\nyour smell"];
		tree[21] = ["#sand03#Heh! Trust me, it'd be love at first smell."];
		tree[22] = [40];
		tree[30] = ["I'd be all\nup in your\nsmells"];
		tree[31] = ["#sand03#Heh! Heh. Yeah that's what I like to hear, a guy who can appreciate some nice smells."];
		tree[32] = ["#sand04#Wish I could like, describe my musk to you. Hm."];
		tree[33] = [40];
		tree[40] = ["#sand06#It's a kinda woodsy scent, like uhh sandalwood on a hot summer day. I dunno. Sorta hard to describe a smell!!"];
		tree[41] = ["#sand05#Hmm... Anyways, see if you can smell your way-- past-- uhhh... sniff out the... solution to..."];
		tree[42] = ["#sand12#Man, fuck segues! Here's a puzzle."];
		
		if (!PlayerData.sandMale) {
			DialogTree.replace(tree, 13, "cologne", "perfume");
		}
		if (PlayerData.gender == PlayerData.Gender.Girl) {
			DialogTree.replace(tree, 0, "you man", "you girl");
			DialogTree.replace(tree, 1, "nuzleaf guy, he's uhh, he's", "nuzleaf girl, she's uhh, she's");
			DialogTree.replace(tree, 2, "He was", "She was");
			DialogTree.replace(tree, 2, ", man.", ", girl.");
			DialogTree.replace(tree, 3, "his thing", "her thing");
			DialogTree.replace(tree, 31, "a guy", "a girl");
			DialogTree.replace(tree, 42, "Man,", "Tsk,");
		}
	}
	
	public static function random22(tree:Array<Array<Object>>, puzzleState:PuzzleState){
		tree[0] = ["#sand01#Awwwww yeah! One last puzzle, just ONE. I can almost... Taste victory. *lick lick*"];
		tree[1] = ["#sand06#Unless... *lick* wait that's... That's not victory. That's... *lick*"];
		tree[2] = ["#sand07#Damn I gotta brush my teeth, be right back."];
		tree[3] = ["%fun-longbreak%"];
		tree[10000] = ["%fun-longbreak%"];
	}
	
	public static function random23(tree:Array<Array<Object>>, puzzleState:PuzzleState){
		var rank:Int = RankTracker.computeAggregateRank();
		var maxRank:Int = RankTracker.computeMaxRank(puzzleState._puzzle._difficulty);
		
		tree[0] = ["#sand05#So how competitive are you about this puzzle stuff? I'm rank 22, you're let's see..."];
		if (rank == 0) {
			tree[1] = ["#sand03#Rank zero!? Is zero even a rank? Damn you gotta work on that shit, rank zero! Heh! Heh. heh."];
			tree[2] = ["#sand02#C'mon I'm sorry, I'm just givin' you a hard time. This rank stuff isn't for everybody."];
			tree[3] = ["#sand04#I get it, you're just here to chill out and grope Sandslashes. Screw this competitive shit, you're a lover not a fighter, right?"];
			tree[4] = ["#sand01#Yeahhh, I get that. Let's knock this last dumb puzzle out of the way~"];
		} else if (rank >= maxRank && rank != 65) {
			tree[1] = ["#sand06#Rank " + englishNumber(rank) + "? So I hope you're not tryin' to increase your rank with these easy puzzles..."];
			tree[2] = ["#sand04#...'Cause you can't really get past rank " + englishNumber(maxRank) + " with puzzles like this one, you gotta move onto some harder shit."];
			tree[3] = ["#sand02#'Course harder puzzles take longer, so you know! It's up to you."];
			tree[4] = ["#sand03#Anyway you're a rank 19 at goin' knuckle deep in Sandslash booty. Heh! Heh. Let's see if you can climb to rank 22 after this~"];
			if (!PlayerData.sandMale) {
				DialogTree.replace(tree, 4, "Sandslash booty", "Sandslash pussy");
			}
		} else if (rank < 22) {
			tree[1] = ["#sand02#Rank " + englishNumber(rank) + "? Not bad, not bad man! You'll get there some day. It's not like I was born a rank 22."];
			tree[2] = ["#sand15#I had to fight for it! Claw my way up. Those puzzles get fuckin' tough but, you know, anybody can do it! Just takes practice."];
			tree[3] = ["#sand14#Let's knock out this last puzzle, alright?"];
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				DialogTree.replace(tree, 1, "bad man", "bad girl");
			}
		} else {
			tree[1] = ["#sand03#Rank " + englishNumber(rank) + "? Daaaamn you been puttin' in work! It's not easy gettin' to rank " + englishNumber(rank) + "."];
			tree[2] = ["#sand02#You tryin' to impress me or something? Don't worry, I'll love you even if you're rank zero."];
			tree[3] = ["#sand00#I ain't takin' this away~"];
		}
	}
	
	public static function sexyBefore0(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		tree[0] = ["#sand05#'Bout time! Enough fuckin' foreplay, I think I'm about to bust."];
		tree[1] = ["#sand01#You gonna... You gonna help out?"];
	}
	
	public static function sexyBefore1(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		if (PlayerData.justFinishedMinigame) {
			tree[0] = ["#sand06#Wellp, I kinda lost track of whether we did enough puzzles but I mean..."];
			tree[1] = ["#sand13#That minigame counted as like, ten puzzles, didn't it!?! I mean that thing took for-fucking-ever..."];
			tree[2] = ["#sand14#'slike... I'm even pent up even by Sandslash standards! You gotta make this one count~"];
		} else {
			tree[0] = ["#sand02#Wellp, you've officially earned me, I'm all yours. What now?"];
			tree[1] = ["#sand00#I mean I got some ideas but..."];
			tree[2] = ["#sand01#...you seem like you probably got some ideas of your own. Heh ! Heh."];
		}
	}
	
	public static function sexyBefore2(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		if (PlayerData.justFinishedMinigame) {
			tree[0] = ["#sand14#There we go, finally. Finally a minigame I'm fuckin' good at. The minigame of making Sandslash bust a nut."];
		} else {
			tree[0] = ["#sand14#There we go, finally. Finally a puzzle I'm fuckin' good at. The puzzle of how to make Sandslash bust a nut."];
		}
		tree[1] = ["#sand01#You need any help with this puzzle?"];
		tree[2] = [20, 10, 40, 30];
		
		tree[10] = ["No, it's\neasy"];
		tree[11] = ["#sand13#Hey who all said I was easy! It was Abra wasn't it?"];
		tree[12] = ["#sand12#Tsk, callin' me easy. I'ma show you who's easy."];
		tree[13] = ["#sand15#I'ma be the... hardest dude you've ever seen! Heh! Heh."];
		
		tree[20] = ["No, I'll\nfinish in\n5 seconds"];
		tree[21] = ["#sand11#Five seconds!? Hey like... take your time, right? C'mon we worked for this!"];
		tree[22] = ["#sand12#Fuckin', sittin' here watchin you solve puzzles feels like forever and you get me off in five seconds. You better not!"];
		
		tree[30] = ["Yes, I\nmight be\nslow"];
		tree[31] = ["#sand00#Slow? Mmmmm, yeah. I like slow. Make the moment last a little, mmmm~"];
		tree[32] = ["#sand12#Now, slow doesn't mean I want like... a 30 minute ear massage or some weird shit though...! Keep it sexy, alright?"];
		tree[33] = ["#sand03#Ahhh you know what you're doin'."];
		
		tree[40] = ["Yes, I\nmight need\nhelp"];
		tree[41] = ["#sand05#You might need help? Like, my help? Tsk man, I'm on break."];
		tree[42] = ["#sand03#I mean c'mon, I just watched you solve all those hard puzzles! Shit's exhausting. I think you can handle this without my help."];
		
		if (!PlayerData.sandMale) {
			DialogTree.replace(tree, 0, "Sandslash bust a nut", "a Sandslash squirt");
			DialogTree.replace(tree, 13, "be the... hardest dude you've ever seen", "make you work EXTRA hard this time");
		}
		if (PlayerData.gender == PlayerData.Gender.Girl) {
			DialogTree.replace(tree, 41, "Tsk man", "Tsk girl");
		}
	}
	
	public static function sexyBefore3(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		if (PlayerData.justFinishedMinigame) {
			tree[0] = ["#sand14#Nice work man. How many puzzles did that minigame count as? Like, a thousand?"];
			tree[1] = ["#sand00#Whatever, it's time to take this shit to the next level."];
		} else {
			tree[0] = ["#sand14#Nice work man. Three puzzles! You know what that means."];
			tree[1] = ["#sand00#Let's take this shit to the next level."];
		}
		
		if (PlayerData.gender == PlayerData.Gender.Girl) {
			DialogTree.replace(tree, 0, "work man.", "work girl.");
		}
	}

	public static function sexyBadSlowStart(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		if (PlayerData.justFinishedMinigame) {
			tree[0] = ["#sand04#Alright! Minigame's finally over, huh? And uhh, you don't gotta be so shy this time."];
		} else {
			tree[0] = ["#sand04#Alright! Three puzzles down. And uhh, you don't gotta be so shy this time."];
		}
		tree[1] = ["#sand02#I mean when we get started-- you know what you gotta do first right?"];
		tree[2] = [20, 40, 10, 30];
		
		tree[10] = ["Rub your\ndick"];
		tree[11] = ["#sand14#Tsk yeah man I dunno why I'm wastin' my time tellin' you this shit! You already know."];
		tree[12] = ["#sand03#I'll shut up and let you do your thing. Heh! Heh."];
		
		tree[20] = ["Rub your\nfeet"];
		tree[21] = ["#sand12#My feet? What? Nawww man,"];
		tree[22] = ["#sand04#Get me hard first! You can fuck around with my feet after."];
		tree[23] = [50];
		
		tree[30] = ["Rub your\nballs"];
		tree[31] = ["#sand12#My balls? What? Nawww man,"];
		tree[32] = ["#sand04#Get me hard first! You can fuck around with my balls after."];
		tree[33] = [50];
		
		tree[40] = ["Finger your\nass"];
		tree[41] = ["#sand12#My ass? What? Nawww man,"];
		tree[42] = ["#sand04#Get me hard first! You can fuck around with my ass after."];
		tree[43] = [50];
		
		tree[50] = ["#sand05#Step one: get my dick good and hard. Step two: all that other shit you like."];
		tree[51] = ["#sand02#And I mean, I love all that other shit too! Don't get me wrong I loved your creativity last time but I was wonderin' like, \"damn when's he finally gonna get to my dick!\""];
		tree[52] = ["#sand03#Heh! Heh. Anyway I'll shut up and let you do your thing."];
		
		if (!PlayerData.sandMale) {
			DialogTree.replace(tree, 10, "dick", "pussy");
			DialogTree.replace(tree, 22, "Get me hard", "Warm my pussy up");
			DialogTree.replace(tree, 30, "balls", "thighs");
			DialogTree.replace(tree, 31, "balls", "thighs");
			DialogTree.replace(tree, 32, "Get me hard", "Warm my pussy up");
			DialogTree.replace(tree, 32, "balls", "thighs");
			DialogTree.replace(tree, 42, "Get me hard", "Warm my pussy up");
			DialogTree.replace(tree, 50, "dick good and hard", "pussy good and wet");
			DialogTree.replace(tree, 51, "dick", "pussy");
		}
		if (PlayerData.gender == PlayerData.Gender.Girl) {
			DialogTree.replace(tree, 11, "yeah man", "yeah girl");
			DialogTree.replace(tree, 21, "Nawww man", "Nawww girl");
			DialogTree.replace(tree, 31, "Nawww man", "Nawww girl");
			DialogTree.replace(tree, 41, "Nawww man", "Nawww girl");
			DialogTree.replace(tree, 51, "when's he", "when's she");
		}
	}

	public static function sexyBadSpread(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		tree[0] = ["#sand00#Heh! Heh, time to get down to business. Mmmm."];
		tree[1] = ["#sand02#Now just curious though, when someone's got their legs spread like this-- what sorta signal do you think this sends?"];
		tree[2] = [10, 20, 30, 40];
		
		tree[10] = ["They want\na massage"];
		tree[11] = ["#sand06#Well nah man-- for me it means I wanna be jerked off! Or fucked or somethin',"];
		tree[12] = ["#sand04#I mean I'm practically begging for it right? Presenting the goods and everything. Point is you don't always gotta mess around with foreplay shit-"];
		tree[13] = [50];
		
		tree[20] = ["They want\nto be\njerked off"];
		tree[21] = ["#sand01#Yeah man! I'm practically begging for it right?"];
		tree[22] = ["#sand04#Or you know, fucked, same difference, point is you don't always gotta mess around with foreplay shit-"];
		tree[23] = [50];
		
		tree[30] = ["They want\nto be\nfucked"];
		tree[31] = ["#sand01#Yeah man! I'm practically begging for it right?"];
		tree[32] = ["#sand04#Or you know, jerked off, same difference, point is you don't always gotta mess around with foreplay shit-"];
		tree[33] = [50];
		
		tree[40] = ["They want\ntheir balls\nrubbed"];
		tree[41] = ["#sand06#Well nah man-- for me it means I wanna be jerked off! Or fucked or somethin',"];
		tree[42] = ["#sand04#I mean I'm practically begging for it right? Presenting the goods and everything. Point is you don't always gotta mess around with foreplay shit-"];
		tree[43] = [50];
		
		tree[50] = ["#sand05#I mean last time was great but I was wonderin' like, \"damn when's he gonna pay more attention to my dick,\" so I spread myself open but I guess you didn't catch the signal."];
		tree[51] = ["#sand02#So yeah, just read my body a little, I don't wanna boss you around or nothin'."];
		tree[52] = ["#sand03#Anyway enough of that I'll shut up and let you do your thing~"];
		
		if (!PlayerData.sandMale) {
			tree[2] = [10, 30, 40];
			DialogTree.replace(tree, 11, "jerked off! Or fucked", "fucked");
			tree[32] = [50];
			DialogTree.replace(tree, 32, "jerked off", "fingered");
			DialogTree.replace(tree, 41, "jerked off! Or fucked", "fucked! Or at least fingered");
			DialogTree.replace(tree, 40, "balls", "feet");
			DialogTree.replace(tree, 50, "my dick", "my pussy");
		}
		if (PlayerData.gender == PlayerData.Gender.Girl) {
			DialogTree.replace(tree, 11, "nah man", "nah girl");
			DialogTree.replace(tree, 21, "Yeah man", "Yeah girl");
			DialogTree.replace(tree, 31, "Yeah man", "Yeah girl");
			DialogTree.replace(tree, 41, "nah man", "nah girl");
			DialogTree.replace(tree, 50, "when's he", "when's she");
		}
	}

	public static function sexyBadClosed(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		tree[0] = ["#sand00#Phooph! Enough fuckin' foreplay, time for the good stuff~"];
		tree[1] = ["#sand04#Although hey, sometimes there's such a thing as TOO much of a good thing, you know what i'm sayin'!"];
		tree[2] = ["#sand02#I mean you really know your way around a cock. But sometimes I actually get a little TOO stimulated, you know?"];
		tree[3] = ["#sand06#So if I kinda close my body up and start lookin' a little tense, it's OK to give my dick a break."];
		tree[4] = ["#sand02#So yeah, just read my body a little, I don't wanna boss you around or nothin'."];
		tree[5] = ["#sand03#Anyway I'll shut up and let you do your thing~"];
		if (!PlayerData.sandMale) {
			DialogTree.replace(tree, 2, "a cock", "a cunt");
			DialogTree.replace(tree, 3, "my dick", "my pussy");
		}
	}
	
	public static function sexyBadTaste(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		tree[0] = ["#sand05#So maybe it's like TMI or somethin' but when I'm with a guy, smell and taste is like half of the experience for me."];
		tree[1] = ["#sand02#It's kinda tough with you bein' on the other side of a computer, but I'd still like it if like-"];
		tree[2] = ["#sand00#Maybe after things get goin' a little and your fingers are good and nasty, maybe you can let me taste myself or somethin. Heh! heh."];
		tree[3] = ["#sand01#I know it's not quite the same as gettin to taste each other, but like-- if I use my imagination maybe it's kinda close."];
		tree[4] = ["#sand03#Just somethin' to think about. I know I'm a little weird."];
		tree[5] = ["#sand02#...That's why you keep comin' back though, right? Heh! Heh~"];
		
		if (PlayerData.gender == PlayerData.Gender.Girl) {
			DialogTree.replace(tree, 0, "a guy", "a girl");
		}		
	}
	
	public static function sexyBadNonsense(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		tree[0] = ["#sand03#Ahh yeah. Finally! Sandslash's gettin' himself some one on one glove time. A little glove love~"];
		tree[1] = ["#sand01#So you know, sometimes while other guys are grabbing at the ol' scrotum pole, they'll like-- rub my body or grab my ass with their other hand..."];
		tree[2] = ["#sand06#But it kinda seems like you only ever do one thing at a time, not that I'm complaining."];
		tree[3] = [30, 10, 20, 40];
		
		tree[10] = ["I've only\ngot one\nhand"];
		tree[11] = [50];
		
		tree[20] = ["Are you\nserious"];
		tree[21] = [50];
		
		tree[30] = ["I can't\ndo that"];
		tree[31] = [50];
		
		tree[40] = ["My other\nhand's busy"];
		tree[41] = [50];
		
		tree[50] = ["#sand10#Oh damn, that's right. Forgot about the one hand thing. Heh! Heh."];
		tree[51] = ["#sand03#Well shit, I gotta get on Abra's ass about makin' you a second glove!"];
		tree[52] = ["#sand02#Until then uhh, nevermind, you're doin' great~"];
		tree[53] = ["#sand06#Just maybe try to work twice as hard with that glove."];
		tree[54] = ["#sand03#Whatever, I'll shut up and let you do your thing."];
		
		if (!PlayerData.sandMale) {
			DialogTree.replace(tree, 0, "himself some", "herself some");
			DialogTree.replace(tree, 1, "grabbing at the ol' scrotum pole", "parting the ol' beef curtains");
		}		
		if (PlayerData.gender == PlayerData.Gender.Girl) {
			DialogTree.replace(tree, 1, "other guys", "other girls");
		}		
	}
	
	public static function sexyPhone(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		var count:Int = PlayerData.recentChatCount("sand.sexyBeforeBad.5");
		
		if (count == 0) {
			tree[0] = ["#sand02#Heh! Heh. You're gettin' pretty good at those. Actually, I got you a little surprise..."];
			tree[1] = ["%add-phone-button%"];
			tree[2] = ["#sand03#...See, check it out -- I got a hold of Heracross's little shop phone!"];
			tree[3] = ["#sand15#Tsk, that asshole thinks I'm not special enough for his phone, but now I figure we can have some fun with him~"];
			tree[4] = [40, 30, 10, 20, 50];
			
			tree[10] = ["Let's text\nKecleon and\nget him to\njoin us"];
			tree[11] = ["#sand12#What, you think this thing sends texts? It's got a fuckin' pull cord."];
			tree[12] = ["#sand04#...I dunno what decade it's from but I got a feeling the typewriter hadn't even been invented yet."];
			tree[13] = ["#sand06#Whatever, I'm sure we'll think of some way to get back at Heracross for uhhh..."];
			tree[14] = ["#sand12#...For leaving my number off of this creepy-ass Victorian Era toy phone."];
			tree[15] = ["#sand06#... ...Wait. Why're we doin' this again?"];
			
			tree[20] = ["Let's check\nit for nudes"];
			tree[21] = ["#sand12#Naww I already checked, he doesn't got any. ...But whatever, I'm sure we'll think of some subtle way to get back at him."];
			tree[22] = ["#sand02#In the meantime, I'll just leave this cute, innocent-looking phone over here alongside all this sexual paraphernalia."];
			
			tree[30] = ["Let's add all\nthe Pokemon\nphone numbers\nwe can think of"];
			tree[31] = ["#sand12#Pshh what, so you can call all them next? ...Like I don't already got enough competition here!"];
			tree[32] = ["#sand05#I was thinkin' something simpler. And also somethin' that's like... way less work than that."];
			tree[33] = ["#sand03#...Whatever, we'll see what comes to me."];
			
			tree[40] = ["Let's put\nthis thing\nall the way\nup your\nbutthole"];
			tree[41] = ["#sand12#C'mon <name> that's like... your fuckin' answer to everything! I was tryin' to come up with something clever."];
			tree[42] = ["#sand06#... ..."];
			tree[43] = ["#sand01#Actually y'know what, I'm sorta liking your idea the more I think about it. Heh! Heh heh."];
			
			tree[50] = ["Aww, that's\nmean"];
			tree[51] = ["#sand04#Don't worry, I was gonna give it back! ...I just wanted to screw around with him a little first. Just something harmless, you know."];
			tree[52] = ["#sand02#...Whatever, we'll think of something~"];
			
			tree[10000] = ["%add-phone-button%"];
			
			if (!PlayerData.heraMale) {
				DialogTree.replace(tree, 3, "that asshole", "that bitch");
				DialogTree.replace(tree, 3, "his phone", "her phone");
				DialogTree.replace(tree, 3, "with him", "with her");
				DialogTree.replace(tree, 21, "he doesn't", "she doesn't");
				DialogTree.replace(tree, 21, "at him", "at her");
				DialogTree.replace(tree, 51, "with him", "with her");
			}
			
			if (!PlayerData.keclMale) {
				DialogTree.replace(tree, 10, "him to", "her to");
			}
		} else if (count % 3 == 1) {
			tree[0] = ["#sand04#That's it for the puzzles, right? Sweet, and I bet you can guess what I'm hidin' back here..."];
			tree[1] = ["%add-phone-button%"];
			tree[2] = ["#sand02#Heh! Heh, yeah -- I swiped this stupid toy phone again. I'm starting to get attached to this old ass-phone."];
			
			tree[10000] = ["%add-phone-button%"];
		} else if (count % 3 == 2) {
			tree[0] = ["%add-phone-button%"];
			tree[1] = ["#sand12#Damn why'd they make all these old phones so hard to program?"];
			tree[2] = ["#sand13#I gotta be like some kinda... nuclear... radiation scientist or some shit. I just wanna add my fuckin' number back onto it and it's all like... Pshh..."];
			tree[3] = ["#sand00#Whatever, I'll mess with it after. It'll be easier once I'm less distracted~"];
			
			tree[10000] = ["%add-phone-button%"];
		} else if (count % 3 == 0) {
			tree[0] = ["#sand06#Heracross is makin' this shit harder for me man, he keeps hiding this thing in different places."];
			tree[1] = ["%add-phone-button%"];
			tree[2] = ["#sand12#It's still worth it to mess with him, though. I dunno where he gets off all, trying to decide which of us are like \"phoneworthy\", fuckin' bullshit."];
			tree[3] = ["#sand05#Anyway where were we~"];
			
			tree[10000] = ["%add-phone-button%"];
			
			if (!PlayerData.heraMale) {
				DialogTree.replace(tree, 0, "he keeps", "she keeps");
				DialogTree.replace(tree, 2, "with him", "with her");
				DialogTree.replace(tree, 2, "where he", "where she");
			}
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				DialogTree.replace(tree, 0, "me man", "me girl");
			}
		}
	}
	
	public static function sexyAfter0(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		tree[0] = ["#sand00#Mmmmmph yeah... that's way better than anything I can do with these pointy claws..."];
		tree[1] = ["#sand02#See you again soon right? Yeahhhh that's right."];
		tree[2] = ["#sand01#I know you can't stay away~"];
	}
	
	public static function sexyAfter1(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		tree[0] = ["#sand00#Phooph, yeah, alright. I'ma need to go to go take a shower..."];
		tree[1] = ["#sand01#Or, y'know. Maybe I can wait and take one in a coupla minutes. Heh! Heh. Mmmmmm..."];
	}	
	
	public static function sexyAfter2(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		tree[0] = ["#sand00#Mmmmyeah... That was niiiiice."];
		tree[1] = ["#sand03#Y'know I kinda feel bad for all the Sandslashes out there who don't have little... hand friends."];
		tree[2] = ["#sand02#You gotta pay me a visit again soon right?"];
		tree[3] = ["#sand01#Yeahhh I know you won't forget~"];
	}
	
	public static function sexyAfter3(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		tree[0] = ["#sand00#Hooph, wow... You got one or two moves I could learn, y'know."];
		tree[1] = ["#sand03#And that's comin' from someone with a pretty... extensive playbook, heh! Where'd you learn that shit? Nnnngh..."];
	}
	
	public static function sexyAfter4(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		tree[0] = ["#sand00#Awww wow... That was great..."];
		if (PlayerData.sandMale && sexyState.cameFromHandjob) {
			tree[1] = ["#sand02#My... my device felt so good in your input port..."];
		} else {
			tree[1] = ["#sand02#Your... your device felt so good in my input port..."];
		}
		tree[2] = ["#sand03#Bahahahahahahaha~"];
	}
	
	public static function sexyAfterGood0(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		tree[0] = ["#sand07#Owoough! That was... THAT was... holy SHIT man!! That was... phew... you've never done THAT before..."];
		tree[1] = ["#sand01#What the hell, I mean you-- you been... hahhh... You been practicin' on other Sandslashes or somethin'...!?"];
		tree[2] = ["#sand07#I've never had anybody who... hah! That was... ooooogh~"];
		if (PlayerData.gender == PlayerData.Gender.Girl) {
			DialogTree.replace(tree, 0, "man!!", "girl!!");
		}
	}
	
	public static function sexyAfterGood1(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		tree[0] = ["#sand07#Qxxlsppd... dngkgg...! I thought I'd seen everything but THAT was.... lnp-- lnnppfzvvfy...!!"];
		tree[1] = ["#sand09#I'ma little too... too out of it for my onomotopoeias to make any sorta fuckin' sense... xkyym... wj- wjkkm..."];
		tree[2] = ["#sand07#I just gotta... lay here for a bit... bynw... try to gather my... mq-- mqqmxrcctmmsss~"];
	}
	
	public static function sexyVeryBad(tree:Array<Array<Object>>, sexyState:SandslashSexyState)
	{
		if (PlayerData.recentChatTime("sand.sexyVeryBad") >= 200) {
			tree[0] = ["#sand01#...ahhhh wow, that was-"];
			tree[1] = ["#sand11#-wait a minute, oh shit!! Oh fuck!!!"];
			tree[2] = ["#sand10#Are you okay <name>? Are you still... fuck!!"];
			tree[3] = ["%fun-alpha0%"];
			tree[4] = ["#sand11#Ay is anybody around!?! Somethin' bad happened- I need some help! Fuck!! Fuckin' fuck."];
		} else {
			tree[0] = ["#sand01#...ahhhh wow, that was-"];
			tree[1] = ["#sand11#-wait a minute, oh shit!! Oh fuck!!! Not again!!"];
			tree[2] = ["#sand10#Are you okay <name>? How does this keep happening... fuck!!"];
			tree[3] = ["%fun-alpha0%"];
			tree[4] = ["#sand11#Ay is anybody around!?! It happened again...! Fuck!! Fuckin' fuck."];
		}
	}
	
	public static function denDialog(sexyState:SandslashSexyState = null, victory:Bool = false):DenDialog
	{
		var denDialog:DenDialog = new DenDialog();

		denDialog.setGameGreeting([
			"#sand02#<name>? Is that really-- awwww damn! Does Abra know you're back here? Fuck yeah, let's do this! Nnnnggh!",
			"#sand01#No puzzles, no bullshit, just <name> and Sandslash paintin' the floor white! 'slike a dream come true~",
			"#sand04#Or uhhh wait, did you come back here to practice <minigame>? 'Cause like, I wouldn't mind playin' a round before we... y'know, play around. Heh! Heh heh~",
		]);

		denDialog.setSexGreeting([
			"#sand02#'skinda nice back here huh? Actually got some fuckin' privacy for once.",
			"#sand06#Don't gotta worry about people bustin' in on us or... Hey wait, what's... is that a camera?",
			"#sand01#Here, turn over so you're facing... Yeah, I think we'll give 'em a better angle this way. Let's give 'em a good look of my bad side~",
		]);

		denDialog.addRepeatSexGreeting([
			"#sand06#Hmm <name>, hey you ever heard of the phrase \"too much of a good thing\"?",
			"#sand01#Yeah me neither. Heh! heh heh heh heh~",
		]);		
		denDialog.addRepeatSexGreeting([
			"#sand03#C'mon, show's not over yet! That was just an intermission. Now's where the real fun starts.",
			"#sand01#Show me what you're really about, <name>. What's the nastiest, filthiest fantasy that's ever been on your mind? ...I can handle it~"
		]);
		denDialog.addRepeatSexGreeting([
			"#sand01#Aww damn. I'm gonna sleep well tonight~",
		]);
		denDialog.addRepeatSexGreeting([
			"#sand02#Yeah alright so we kinda touched a lot of the bases already... What did you wanna do now?",
			"#sand00#I mean I got some ideas but...",
			"#sand01#...you seem like you probably got some ideas of your own. Heh ! Heh.",
		]);
		if (PlayerData.denSexCount >= 2) {
			denDialog.addRepeatSexGreeting([
				"#sand01#Let's go, let's go! " + capitalize(englishNumber(PlayerData.denSexCount)) + " in one day? C'mon, that's some amateur hour shit. Let's crank these out."
			]);
		} else {
			denDialog.addRepeatSexGreeting([
				"#sand01#Nghh, c'mon, let's keep this party goin'~"
			]);
		}
		denDialog.addRepeatSexGreeting([
			"#sand04#Hopefully Abra's not keeping track, 'cause I think this is like... " + englishNumber(3 * PlayerData.denSexCount) + " puzzles we owe " + (PlayerData.abraMale ? "him" : "her") + ". Heh! Heh.",
			"#sand00#Ehhhh whatever. Maybe if we keep goin' " + (PlayerData.abraMale?"he'll":"she'll") + " lose count.",
		]);
		denDialog.addRepeatSexGreeting([
			"#sand02#Ngghh, you sure know how to make a " + (PlayerData.sandMale ? "guy" : "girl") + " feel wanted~",
		]);
		denDialog.addRepeatSexGreeting([
			"#sand05#I know you ain't thinkin you're gonna outlast a Sandslash when it comes to this stuff, are you? 'Cause you're talkin' to the " + (PlayerData.sandMale ? "guy" : "girl") + " who once did back to back sex marathons.",
			"#sand02#You heard of a sex marathon, before, right? Well I mean, it don't take a genius to figure that one out.",
			"#sand03#It's exactly what you're thinkin' it is, only... 26.2 times in a row. Heh! Heh.",
		]);
		if (PlayerData.denVisitCount > 1) {
			denDialog.addRepeatSexGreeting([
				"#sand01#Heh! Heh. What, are you slowin' down? I mean, you already paid for the whole hour. You stop now, 'slike throwin' good money away~",
			]);
		}
		
		denDialog.setTooManyGames([
			"#sand12#Alright, nope. Nope. That's enough. Bored. Booooooring.",
			"#sand04#I'ma go see if " + FlxG.random.getObject(["Scrafty", "Snivy", "Gengar", "Banette", "Nuzleaf", "Marowak", "Quilava"]) + "'s around, that " + (PlayerData.gender == PlayerData.Gender.Girl ? "girl" : "guy") +" actually knows how to party. Later, <name>."
		]);

		denDialog.setTooMuchSex([
			"#sand12#Alright, fine, FIIIIIIIINE. You WIN. I think I'm actually too tired to cum again. ...Hope you're proud.",
			"#sand08#For the record though, only reason you outlasted me is 'cause you're clicky-clickin' on my sensitive bits while yours are a million light years away in another fuckin' universe.",
			"#sand02#You gimme somethin' to click on... We'll see how long you really last. Heh! Heh. Heh."
		]);

		denDialog.addReplayMinigame([
			"#sand01#Heh yeah, alright, alright. That enough foreplay for ya? ...You finally ready to move onto the main event?"
		],[
			"I want a\nrematch!",
			"#sand12#Groaaaaannn..."
		],[
			"Yeah, let's\nmove on",
			"#sand03#Theeeeeerrre we go. Finally you're speakin' my fuckin' language all of a sudden.",
			"#sand02#So how you wanna do this? Tell ya what, for starters why don't we move this game stuff out of the way...",
		],[
			"Actually\nI think I\nshould go",
			"#sand12#What!? Gah, what are you doin' to me over here!?! I got nothin' outta this! Nothin'...",
			"#sand04#I mean fun is fun and all but c'monnnn!!! ...You gotta do me right next time, okay? 'Nuff of this game shit.",
		]);
		denDialog.addReplayMinigame([
			"#sand05#C'mon <name>, when I said I was lookin' to score this ain't exactly what I had in mind..."
		],[
			"One more\ngame!!",
			"#sand12#Aughhhh you're KILLIN' me <name>..."
		],[
			"Yeah, let's\nmove on",
			"#sand03#Theeeeeerrre we go. Finally you're speakin' my fuckin' language all of a sudden.",
			"#sand02#So how you wanna do this? Tell ya what, for starters why don't we move this game stuff out of the way...",
		],[
			"I think I'll\ncall it a day",
			"#sand12#What!? Gah, what are you doin' to me over here!?! I got nothin' outta this! Nothin'...",
			"#sand04#I mean fun is fun and all but c'monnnn!!! ...You gotta do me right next time, okay? 'Nuff of this game shit.",
		]);
		denDialog.addReplayMinigame([
			"#sand04#Yeah alright, well played well played. Good times were had by all. ...Can we move onto the sex part now?",
			"#sand01#'Sjust y'know, these games are kinda... kid's stuff. We're two adults aren't we? Why don't we try somethin' a little more... adult."
		],[
			"But I\nlike games!\nYaaay! More\ngames!!",
			"#sand11#What!? C'monnnnnnn, are you serious?"
		],[
			"I could go for\nsomething adult...",
			"#sand03#Theeeeeerrre we go. Finally you're speakin' my fuckin' language all of a sudden.",
			"#sand02#So how you wanna do this? Tell ya what, for starters why don't we move this game stuff out of the way...",
		],[
			"Hmm, I\nshould go",
			"#sand12#What!? Gah, what are you doin' to me over here!?! I got nothin' outta this! Nothin'...",
			"#sand04#I mean fun is fun and all but c'monnnn!!! ...You gotta do me right next time, okay? 'Nuff of this game shit.",
		]);
		
		denDialog.addReplaySex([
			"#sand00#I'ma go grab a gatorade, " + (PlayerData.gender == PlayerData.Gender.Girl ? "girl" : "man") +". Gotta refill all those electrolytes I fuckin'... sprayed all over the place.",
			"#sand04#How you feel about round " + englishNumber(PlayerData.denSexCount + 1) + "? You ain't tired yet are you?"
		],[
			"Sure, I'm\nup for it!",
			"#sand02#Heh! I'll be back in a sec, you just hold your pretty horses alright?"
		],[
			"Ahh, I'm good\nfor now",
			"#sand02#Heh! Hey no sweat. I'll see you again soon right? Yeahhhh that's right.",
			"#sand01#I know you can't stay away~",
		]);
		denDialog.addReplaySex([
			"#sand00#Phooph, yeah, alright. I'ma need to go take a shower...",
			"#sand05#Actually second thought, I'ma just splash on some water from the sink, I'll be back in just a sec. You ready for round " + englishNumber(PlayerData.denSexCount + 1) + "?",
		],[
			"Yeah! Ready\nas ever",
			"#sand03#Heh! Heh. Damn right you are.",
			"#sand06#Let's see, is this washcloth clean? (sniff, sniff) Hmmmm... Yeah alright yeah, this'll work.",
		],[
			"Oh, I think\nI'll head out",
			"#sand06#Tsk whaaaat? ...You mean you gonna give me a reason to take a real shower? Some friend you are.",
			"#sand02#Nah I'm just givin you a hard time. Thanks for hangin' out with me today.",
		]);
		denDialog.addReplaySex([
			"#sand00#Mmmmyeah... That was niiiiice. Hey my stomach's kinda killin' me, I'ma go grab a snack real quick.",
			"#sand05#You stickin' around for round " + englishNumber(PlayerData.denSexCount + 1) + "? I mean I'm goin' for it regardless but I could use you on my team. Heh! Heh~"
		],[
			"Sure! I'll\nstick around",
			"#sand03#Yeaaaahhhh! Go team. Alright I'll be right back, don't start without me~"
		],[
			"I should\ngo...",
			"#sand02#Aww alright. You gotta pay me a visit again soon though, right?",
			"#sand01#Yeahhh I know you won't forget~",
		]);

		return denDialog;
	}
	
	public static function cursorSmell(tree:Array<Array<Object>>, sexyState:SandslashSexyState) {
		var count:Int = PlayerData.recentChatCount("sand.cursorSmell");
		
		if (count == 0) {
			tree[0] = ["#sand05#'Bout time! Enough fuckin' foreplay, I think I'm about to bust. (sniff, sniff)"];
			tree[1] = ["#sand01#...Aww, man! Is Grimer still here? ...There's a guy who knows how to party, heh heh. Just gotta make sure to stock up on antidote first..."];
			tree[2] = ["%permaboner%"];
			tree[3] = ["#sand00#Nggghh, those fat squishy fingers... Plus there's somethin' so damn hot about just being completely smothered under a guy like that. And the smells are just a bonus..."];
			tree[4] = ["#sand01#Fuck man, why am I doin' so much talking!? This ain't a fuckin' RP! ...Let's get that hand of yours dirty~"];
			
			if (!PlayerData.grimMale) {
				DialogTree.replace(tree, 1, "a guy", "a girl");
				DialogTree.replace(tree, 3, "a guy", "a girl");
			}
		} else {
			tree[0] = ["#sand05#'Bout time! Enough fuckin' foreplay, I think I'm about to bust. (sniff, sniff)"];
			tree[1] = ["#sand01#Nnggggghhh that smell brings back some goooood memories. ...Guess that means you're still screwin' around with Grimer? Niice~"];
			tree[2] = ["#sand00#Gotta hand it to you man, takes a real sexual connoisseur to appreciate what Grimer brings to the table. That's some double-black diamond shit right there."];
			tree[3] = ["%permaboner%"];
			tree[4] = ["#sand01#All that warm, wet, foul-smelling sludge coursing over every inch of my body... Mmmmnnnghhh... Fuck, I'm getting hard just thinkin' about it!"];
			tree[5] = ["#sand15#C'mon, enough talk, let's get to the good stuff! ...I'm dying over here!"];
			
			if (PlayerData.gender == PlayerData.Gender.Girl) {
				DialogTree.replace(tree, 2, "you man", "you girl");
			}
			if (!PlayerData.sandMale) {
				DialogTree.replace(tree, 4, "getting hard", "getting wet");
			}
		}
	}
	
	public static function snarkySmallDildo(tree:Array<Array<Object>>) {
		tree[0] = ["#sand06#Huh? What, I got somethin' in my teeth? -lick lick- ... ...Did I get it?"];
		tree[1] = ["#sand03#Oh, wait... That tiny thing's supposed to be a dildo isn't it. Heh! Heh. Heh. Tsk sorry, my bad."];
		tree[2] = ["#sand05#See, I just got regular Sandslash vision. I'm not equipped with, like, whatever fuckin' laser electron microscope eyes I'd need to identify an object that small."];
		tree[3] = ["#sand01#...Maybe you can come back with somethin' more Sandslash sized. Heh! Heh~"];
	}
}