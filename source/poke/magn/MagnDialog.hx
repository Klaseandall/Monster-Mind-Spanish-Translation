package poke.magn;
import minigame.GameDialog;
import minigame.MinigameState;
import minigame.scale.ScaleGameState;
import critter.Critter;
import flixel.FlxG;
import openfl.utils.Object;
import PlayerData.hasMet;
import minigame.stair.StairGameState;
import puzzle.ClueDialog;
import puzzle.PuzzleState;

/**
 * Magnezone is canonically female.
 * 
 * She found out about Heracross's second job with Abra because Heracross
 * blabbed about it when Magnezone was inspecting the Pokemon Daycare.
 * 
 * Her first visit was legitimately to ensure that the shop wasn't doing
 * anything illegal.
 * 
 * Her second and subsequent visits were simply because she likes the pokemon
 * she's met, and because she likes the player.
 * 
 * Over the course of the game, it becomes clearer and clearer to her that the
 * shop is selling sexual merchandise and that the pokemon are filming
 * themselves having sex and posting it on the internet, and other things like
 * that. She sweeps this under the rug because everyone is nice and she likes
 * her new friends.
 * 
 * When you first start the game, Magnezone's expression in the shop is
 * somewhat hostile, but over time this softens. She even takes off her hat if
 * you play for long enough.
 * 
 * While she doesn't have any traditional reproductive organs, she seems to
 * derive some kind of sexual pleasure from maintenance -- particularly when
 * performed incorrectly or without proper safety protocols
 * 
 * Sandslash slips up and gets Magnezone interested in "butt plugs," but
 * Magnezone misunderstands the nature of them and thinks they are something
 * electronic. This culminates in a bizarre scene in the store when Magnezone
 * states that the butt plug is "not compatible with her input port"
 * 
 * Magnezone weirdly loves having her chassis rubbed.
 * 
 * Magnezone will occasionally hypothesize about how Abra generated the
 * puzzles. If you play with Magnezone many, many, many times (about 25 times
 * on the same save file, without using a password) she will figure out Abra's
 * algorithm, and go into alarming depth about it.
 * 
 * As far as minigames go, Magnezone loves playing minigames with the player,
 * although she plays them all 100% perfectly, including following a nash
 * equilibrium strategy for the stair game. However, she can still be beaten
 * because her magnet hands are clumsy with the tug-of-war and scale game,
 * and because the stair game includes a significant chance element.
*
 * ---
 * 
 * Vocal tics:
 *  - -HA- -HA- -HA-
 *  - -FOLLOWING DIRECTIVE- [[Subsequent to the...
 *  - %20 = space; %0A = newline
 *  - Says "bzzt" and "fzzt" instead of "hmm"
 *  - Proper nouns are in &lt;brackets&gt;
 *  - Refers to himself as &lt;Magnezone&gt; (third person)
 *  - Prompts include (Y/N)
 * 
 * Superhuman at puzzles (rank 44)
 */
class MagnDialog
{
	public static var PLAYER:String = "&lt;<name>&gt;";
	public static var ABRA:String = "&lt;Abra&gt;";
	public static var BUIZ:String = "&lt;Buizel&gt;";
	public static var GROV:String = "&lt;Grovyle&gt;";
	public static var HERA:String = "&lt;Heracross&gt;";
	public static var MAGN:String = "&lt;Magnezone&gt;";
	public static var RHYD:String = "&lt;Rhydon&gt;";
	public static var SAND:String = "&lt;Sandslash&gt;";
	public static var SMEA:String = "&lt;Smeargle&gt;";

	public static var prefix:String = "magn";
	public static var sexyBeforeChats:Array<Dynamic> = [sexyBefore0, sexyBefore1, sexyBefore2];
	public static var sexyAfterChats:Array<Dynamic> = [sexyAfter0, sexyAfter1, sexyAfter2, sexyAfter3];
	public static var sexyBeforeBad:Array<Dynamic> = [sexyBadEye, sexyBadOrgasmElectrocution, sexyBadPortElectrocution];
	public static var sexyAfterGood:Array<Dynamic> = [sexyAfterGood0, sexyAfterGood1];
	public static var fixedChats:Array<Dynamic> = [explainGame, buttPlug];
	public static var randomChats:Array<Array<Dynamic>> = [
				[random00, random01, random02, gift03, random04],
				[random10, random11, random12, random13, random14],
				[random20, random21, random22, random23]
			];

	public static function getUnlockedChats():Map<String, Bool>
	{
		var unlockedChats:Map<String, Bool> = new Map<String, Bool>();
		unlockedChats["magn.fixedChats.1"] = hasMet("sand");
		unlockedChats["magn.randomChats.1.3"] = hasMet("smea");
		unlockedChats["magn.randomChats.1.4"] = hasMet("hera");
		unlockedChats["magn.randomChats.2.3"] = hasMet("rhyd");
		unlockedChats["magn.randomChats.0.3"] = false;
		unlockedChats["magn.randomChats.0.4"] = hasMet("buiz");

		if (PlayerData.magnGift == 1)
		{
			// all chats are locked except gift chat
			for (i in 0...randomChats[0].length)
			{
				unlockedChats["magn.randomChats.0." + i] = false;
			}
			unlockedChats["magn.randomChats.0.3"] = true;
		}
		return unlockedChats;
	}

	public static function clueBad(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var clueDialog:ClueDialog = new ClueDialog(tree, puzzleState);
		clueDialog.setOops1(FlxG.random.getObject(["My bad", "A-ha", "I see", "Right"]));
		clueDialog.setHelp(FlxG.random.getObject(["Yes,\nplease", "[Y]", "Yeah", "I don't\nget it"]));
		clueDialog.setGreetings([
									"#magn07#-ERR06- Error detected in &lt;<first clue>&gt;. Assistance required? (Y/N)",
									"#magn07#-ERR07- &lt;<First clue>&gt; has caused a segmentation fault in PUZZLE.SWF. View error log? (Y/N)",
									"#magn07#-ERR09- Solution is not facet-valid with respect to &lt;<first clue>&gt;. %0ADisplay detailed information? (Y/N)",
								]);
		if (clueDialog.actualCount > clueDialog.expectedCount)
		{
			clueDialog.pushExplanation("#magn07#[[ERROR LOG #0/3]] expected number of <bugs in the correct position> with regard to <first clue>: <e>");
			clueDialog.pushExplanation("#magn07#[[ERROR LOG #1/3]] actual number of <bugs in the correct position> with regard to <first clue>: <a>");
			clueDialog.pushExplanation("#magn07#[[ERROR LOG #2/3]] RECOMMENDED COURSE OF ACTION: reduce number of <bugs in the correct position> with regard to <first clue>.");
			clueDialog.pushExplanation("#magn07#[[ERROR LOG #3/3]] for additional assistance, contact your system administator.");
			clueDialog.pushExplanation("#magn04#BZZT-- I mean, contact " + ABRA + ". -beep- -boop-");
		}
		else
		{
			clueDialog.pushExplanation("#magn07#[[ERROR LOG #0/3]] expected number of <bugs in the correct position> with regard to <first clue>: <e>");
			clueDialog.pushExplanation("#magn07#[[ERROR LOG #1/3]] actual number of <bugs in the correct position> with regard to <first clue>: <a>");
			clueDialog.pushExplanation("#magn07#[[ERROR LOG #2/3]] RECOMMENDED COURSE OF ACTION: increase number of <bugs in the correct position> with regard to <first clue>.");
			clueDialog.pushExplanation("#magn07#[[ERROR LOG #3/3]] for additional assistance, contact your system administator.");
			clueDialog.pushExplanation("#magn04#BZZT-- I mean, contact " + ABRA + ". -beep- -boop-");
		}
	}

	static private function newHelpDialog(tree:Array<Array<Object>>, puzzleState:PuzzleState, minigame:Bool=false):HelpDialog
	{
		var helpDialog:HelpDialog = new HelpDialog(tree, puzzleState);
		helpDialog.greetings = [
			"#magn04#"+PLAYER+"; do you require assistance?",
			"#magn04#Is there something " + MAGN + " can assist with?",
			"#magn04#Fzzzt? How can I be of service?",
			"#magn04#-DEACTIVATING SILENT MODE- Please state your request.",
		];

		helpDialog.goodbyes = [
			"#magn14#Yes, there are other matters which demand " + MAGN + "'s attention as well.",
			"#magn14#Very well, let's reschedule for another time. Bzzzt-",
			"#magn08#...Did " + MAGN + " violate the protocols of the &lt;Game&gt;? -INFORMAL APOLOGY-",
		];

		if (puzzleState != null)
		{
			var solutionStr:String = "";
			for (i in 0...puzzleState._puzzle._pegCount)
			{
				solutionStr += Critter.CRITTER_COLORS[puzzleState._puzzle._answer[i]].english.toUpperCase();
				solutionStr += "%20";
			}
			helpDialog.goodbyes.push("#magn06#-TERMINATING SESSION-%0A%0ASOLUTION_STR=" + solutionStr);
		}

		helpDialog.neverminds = [
									"#magn05#You must fulfill your role in the &lt;Game&gt;, " + PLAYER + ". Otherwise the &lt;Game&gt; cannot continue.",
									"#magn05#...This behavior seems counterproductive towards the completion of the &lt;Game&gt;.",
									"#magn05#Bzzz... Try to remain disciplined, " + PLAYER + ".",
									"#magn05#-REACTIVATING SILENT MODE-",
								];

		helpDialog.hints = [
							   "#magn05#-REQUEST CONFIRMED- " + ABRA + " has specifically asked me not to assist " + PLAYER + " in solving these puzzles. I will contact him personally.",
							   "#magn05#-REQUEST CONFIRMED- Please wait while I contact " + ABRA + " for assistance.",
							   "#magn05#-REQUEST CONFIRMED- " + ABRA + " has indicated I should not assist you directly. I will return shortly.",
						   ];

		if (!PlayerData.abraMale)
		{
			helpDialog.hints[0] = StringTools.replace(helpDialog.hints[0], "contact him", "contact her");
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

	public static function gameDialog(gameStateClass:Class<MinigameState>)
	{
		var g:GameDialog = new GameDialog(gameStateClass);

		g.addSkipMinigame(["#magn04#-TERMINATING PROCESS MINIGAME.SWF- Very well. Let us proceed to a different activity."]);
		g.addSkipMinigame(["#magn04#...", "#magn05#Very well. Let's proceed to an activity which " + PLAYER + " enjoys."]);

		g.addRemoteExplanationHandoff("#magn07#[[ERR-404 INSTRUCTIONS NOT FOUND]] ... ... ...");

		g.addLocalExplanationHandoff("#magn14#&lt;<leader>&gt;, are you capable of explaining the rules? ...My instructions are written in assembly, which is difficult to translate.");

		g.addPostTutorialGameStart("#magn05#[[END RULES EXPLANATION]] Was that explanation sufficient? Shall we start the game? (Y/N)");

		g.addIllSitOut("#magn13#" + MAGN + " skill level: 10; " +PLAYER + " skill level: 2; RECOMMENDATION: Proceed without " + MAGN + ".");
		g.addIllSitOut("#magn13#I would recommend you play without " + MAGN + " this time. You are... not ready.");
		g.addIllSitOut("#magn13#I am afraid we should defer the AI competition for a future time. At your current skill level... ... ...I would destroy you.");

		g.addFineIllPlay("#magn12#%20%20adjusting skill level: -BEGINNER- -NOVICE- -ADVANCED- -EXPERT- &lt;&lt;MAGNEZONE&gt;&gt;.");
		{
			var fine:String = "#magn12#The first in a series of questionable decisions by my organic adversary. And his squishy organic brain.";
			if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				fine = StringTools.replace(fine, "and his", "and her");
			}
			else if (PlayerData.gender == PlayerData.Gender.Complicated)
			{
				fine = StringTools.replace(fine, "and his", "and their");
			}
			g.addFineIllPlay(fine);
		}
		g.addFineIllPlay("#magn12#[[GAME SOLVED]] --%20%20 victory for " + MAGN + " in 19 moves.");

		g.addGameAnnouncement("#magn15#" + ABRA + " refers to this game as &lt;<minigame>&gt;. I have a 39GB database of all possible board states. It is weakly solved.");
		g.addGameAnnouncement("#magn15#" + GROV + " refers to this game as &lt;<minigame>&gt;. I have run several board state simulations. It is an interesting game.");
		if (gameStateClass == StairGameState) g.addGameAnnouncement("#magn15#I see. This is <minigame>. I believe " + ABRA + " may have plagiarized this design from a Korean children's game.");

		g.addGameStartQuery("#magn04#Initiate minigame sequence? (Y/N)");
		g.addGameStartQuery("#magn04#Are you ready to begin? (Y/N)");
		g.addGameStartQuery("#magn04#-PRESS ANY KEY TO CONTINUE-");

		g.addRoundStart("#magn05#An acceptable result. The outcome is aligning with " + MAGN + "'s calculations.", ["You've got a calculation\nfor everything, don't you?", "Acceptable,\nmy ass...", "Alright,\nlet's go!"]);
		g.addRoundStart("#magn04#Now loading round <round>... ... ... 0% - - - - - 100%", ["Load faster\ndamn it!", "I'll just start\nwithout you", "Okay, I\ncan wait..."]);
		g.addRoundStart("#magn03#Thank you for taking some time out to play with an AI. This AI loves you~", ["You shouldn't use that\nword so lightly...", "Ha! Ha!\n...Okay?", "Aww! I love you\ntoo, Magnezone"]);
		g.addRoundStart("#magn02#" + MAGN + " is ready for round <round> whenever you are, " + PLAYER + ". Fzzt~", ["Let's\ndo it", "Hold on just\na second...", "Oof..."]);

		g.addRoundWin("#magn04#" + PLAYER + " can still achieve a draw with perfect play. Fzzzt~", ["Barf...", "Wait, what happens\nin a draw!?", "It seems\nimpossible..."]);
		g.addRoundWin("#magn06#" + MAGN + " does not lose. However... some games take longer than others.", ["Next time, we're\nplaying water polo", "Prepare to\nbe surprised", "Sheesh..."]);
		g.addRoundWin("#magn05#1111 0110 1001... It was inevitable. You cannot defeat " + MAGN + ". However, you can learn from your loss.", ["This isn't fair,\nyou're a computer", "Go 1000101\nyourself", "Hey! You keep my\nmother out of this"]);
		g.addRoundWin("#magn05#%0B%0Bstdout(\"MATE IN 9 MOVES\");", ["...\n...", "This isn't\nchess...", "Mmm, so you want\nto \"Mate\" me?", "Hey, not without\nmy consent you're not!"]);
		g.addRoundWin("#magn04#Are you allocating sufficient resources to your main processor, " + PLAYER + "?", ["Now I know how\nKasparov felt...", "You're saying I\nshould concentrate?", "I'm already trying\nmy hardest..."]);
		g.addRoundWin("#magn03#-INITIATING TAUNT- &lt;If you can't stand the heat, activate your coolant fan&gt;", ["Heh okay,\nyou're good", "I'm going to find a\nway to unplug you", "Grrrrr..."]);
		g.addRoundWin("#magn10#Are you okay, " + PLAYER + "? Perhaps if you disable some of your background processes...", ["I wonder if Abra has\nan EMP lying around...", "This is\nimpossible", "You deserve a\nbetter opponent!"]);

		g.addRoundLose("#magn12#-DOES NOT COMPUTE- -DOES NOT COMPUTE-", ["Try turning it\noff and on again", "Afraid of a little\norganic competition?", "Heh heh,\naww c'mon"]);
		g.addRoundLose("#magn12#RIDDLE: What has zero wheels and smells like a butt; ANSWER: &lt;<leader>&gt;", ["Aww I could have\nsolved that riddle", "Don't robots understand\nsportsmanship?", "Aww, we'll\ncatch <leaderhim>|Aww, you'll\ncatch me"]);
		g.addRoundLose("#magn10#...Analyzing audio/video latency... 12ms... Disabling VSYNC... Analyzing audio/video latency... 9ms... ", ["<leaderHe's> too fast\nfor me, too...|Those milliseconds might\nmake the difference!", "Heh! heh!\nWhatever helps...", "What kind of noob\nkeeps VSync enabled?"]);
		g.addRoundLose("#magn06#...That board state would never be relevant with perfect play. &lt;<leader>&gt; is tarnishing the purity of this game.", ["Yeah, who invited\n<leaderhim> play with us?|Aww, sorry\nabout that", "What a flimsy\nexcuse, c'mon...", "If you wanted purity, you're\nplaying the wrong game"]);

		g.addWinning("#magn05#This is similar to how genetic algorithms are trained, " + PLAYER + ". Making incremental improvements in skill amidst uncountable losses.", ["...That's\ninsulting!", "I do feel like\nI'm improving...", "You're...\ntraining me?"]);
		g.addWinning("#magn04#Bzzzz... Would you like me to lower my difficulty setting? (Y/N)", ["Yes,\nplease...", "Aww, I'll just\ndo my best...", "[Y]", "Ugh..."]);
		g.addWinning("#magn05#Don't concede to " + MAGN + " yet. It's more fun to play it out.", ["Fine, I'll\nplay it out", "Bleah...", "Abra shouldn't\nlet robots play..."]);
		g.addWinning("#magn14#It's nice to play with organics again. You have such... unique ways of approaching the game~", ["Do you have\na mute button?", "\"Unique\" huh? Yeah I can\nread between those lines.", "It's really\ntough..."]);

		g.addLosing("#magn10#How can " + MAGN + " be defeated by a mere organic? Is it possible... " + MAGN + " is perhaps becoming obsolete?", ["Aww you're\nstill quick!", "I'll find a\nuse for you~", "We're not out\nof this yet|Better get\nused to this!!"]);
		g.addLosing("#magn10#Are you actually an organic, &lt;<leader>&gt;? ...You're playing like an AI.", ["Aww you're\nstill smart!", "I'll find a\nuse for you~", "We're not out\nof this yet|Better get\nused to this!!"]);
		g.addLosing("#magn11#...Calculating... ... &lt;VICTORY_CHANCE_PROB&gt; == 0.44;", ["Is that 44%\nor 0.44%?", "Ha! You still think\nyou have a chance!?", "Yeah, <leaderhe's> way\nout in the lead...|I'm sort of\nfar ahead..."]);
		g.addLosing("#magn07#" + MAGN + " will record these board positions for future study... " + MAGN + " will return with an improved algorithm.", ["Upgrades?\nSounds cool!", "I should\nstudy too...|Study all you want,\nyou'll never beat me!", "Hey, no fair studying\nwithout me"]);

		g.addPlayerBeatMe(["#magn08#...", "#magn09#" + MAGN + " concedes defeat. You are the superior being.", "#magn04#" +MAGN + " still enjoys a good challenge. Perhaps we can schedule a rematch for " + (MmTools.time() + FlxG.random.int(86400000, 86400000 * 2)) + "+00:00."]);
		g.addPlayerBeatMe(["#magn06#You caught " + MAGN + " off guard. But, the thrill of competition has breathed new life into my rusty old bolts.", "#magn02#Next time, " + PLAYER + " we will have a real match, as you face off against " + MAGN + " in top condition.", "#magn05#...But let's not dwell on " + MAGN + "'s defeat. Bzzzzz~ What activity follows this one? ... ... analyzing..."]);

		g.addBeatPlayer(["#magn05#" + MAGN + " employs a genetic algorithm which has evolved for 30,000 simulated generations.", "#magn15#Perhaps, given 30,000 of your organic generations to focus your technique, you can challenge " + MAGN + " again.", "#magn04#" + MAGN + " will schedule a rematch for the year 729,456."]);
		g.addBeatPlayer(["#magn14#...Do not feel shame in defeat.", "#magn04#You played proficiently for an organic, but no organic can compete against " + MAGN + "'s perfect algorithms.", "#magn00#Perhaps we can ruminate on " + MAGN + "'s victory during our scheduled tactile stimulation session. Fzzz~"]);

		g.addShortWeWereBeaten("#magn05#Congratulations, &lt;<leader>&gt;. Hopefully you recognize it as a categorical imperitave to open-source your solution.");
		g.addShortWeWereBeaten("#magn05#...Well played, &lt;<leader>&gt;. -bwoop- ... ...How about a nice game of chess? (Y/N)");

		g.addShortPlayerBeatMe("#magn05#...If " + MAGN + " was destined to lose, " + (PlayerData.magnMale?"he":"she") + " is glad it was " + PLAYER + " who defeated " + (PlayerData.magnMale?"him":"her") + ". Congratulations, " + PLAYER + ".");
		g.addShortPlayerBeatMe("#magn06#-MATCH LOGGED; /h/archives/" + FlxG.random.int(100000, 999999) + ".log- ... ..." + MAGN + " will analyze this game. " + MAGN + " will return. Stronger.");

		g.addStairOddsEvens("#magn05#Let us determine the starting player with &lt;Odds And Evens&gt;. If the dice total is odd, " + PLAYER + " can start.", ["If it's odd,\nI go first...", "Okay, on\nthree?", "I'm ready"]);
		g.addStairOddsEvens("#magn04#Let us practice with a quick game of &lt;Odds And Evens&gt;. " + PLAYER + " can go first if the dice total is odd.", ["Do I\nwant to go\nfirst? Hmm...", "I get it", "Alright"]);

		g.addStairPlayerStarts("#magn15#Very well, " + PLAYER + " may play first. " + MAGN + " calculates this provides a mere 4.1% advantage. Are you ready to begin? (Y/N)", ["Yeah! Let's start", "[Y]", "No, not\nyet..."]);
		g.addStairPlayerStarts("#magn15#" + PLAYER + " may play first, that is acceptable. ...Any advantage gained is trivially surpassed with proper play. Shall we begin? (Y/N)", ["Okay,\nsure", "[Y]", "So going\nfirst is an\nadvantage?"]);

		g.addStairComputerStarts("#magn02#" + MAGN + " will be the starting player. Organics are so predictable. Shall we begin the game? (Y/N)", ["[Y]", "Let's\nplay", "Didn't you\njust guess?"]);
		g.addStairComputerStarts("#magn02#" + MAGN + " will play first. This reduces " + PLAYER + "'s chances of victory from 2.1% to 1.9%. Shall we begin? (Y/N)", ["Who programmed\nyou to be\nsuch a dick?", "Are your\ncalculations\nreliable?", "[Y]"]);

		g.addStairCheat("#magn12#" + MAGN + " allows for a 440 millisecond latency window when playing with organics. " + PLAYER + " has surpassed this window? Try again? (Y/N)", ["[N]", "Can you expand\nthat window\na little?", "[Y]"]);
		g.addStairCheat("#magn12#" + PLAYER + " has exceeded the 440 millisecond latency window allotted by " + MAGN + ". Please throw your dice sooner. -HIT ANY KEY TO CONTINUE-", ["[J]", "[ENTER]", "[NUMPAD 9]"]);

		g.addStairReady("#magn04#-PRESS ANY KEY TO CONTINUE-", ["[K]", "[Ins]", "[Ctrl+Alt+Del]"]);
		g.addStairReady("#magn05#-PRESS ANY KEY TO CONTINUE-", ["[Esc]", "[5]", "[Up Arrow]"]);
		g.addStairReady("#magn04#-PRESS ANY KEY TO CONTINUE-", ["[Numpad 3]", "[F1]", "[O]"]);
		g.addStairReady("#magn05#-PRESS ANY KEY TO CONTINUE-", ["[M]", "[Down Arrow]", "[End]"]);
		g.addStairReady("#magn04#-PRESS ANY KEY TO CONTINUE-", ["[Ctrl+C]", "[Y]", "[@]"]);
		g.addStairReady("#magn05#-PRESS ANY KEY TO CONTINUE-", ["[?]", "[Num Lock]", "[B]"]);
		g.addStairReady("#magn04#-PRESS ANY KEY TO CONTINUE-", ["[7]", "[Shift+Pause]", "[PrtScr]"]);
		g.addStairReady("#magn05#-PRESS ANY KEY TO CONTINUE-", ["[^]", "[L]", "[Command+Q]"]);
		g.addStairReady("#magn04#-PRESS ANY KEY TO CONTINUE-", ["[Option+Command+Esc]", "[Control]", "[S]"]);

		// These "close game" lines include duplicates of some early "win round/lose round" lines; be wary if the third minigame uses both sets of lines
		g.addCloseGame("#magn04#Despite the appearance of a close game, all possible endgame permutations play out in " + MAGN + "'s favor. -PRESS ANY KEY-", ["Do they\nreally?", "Well, I\ncan't argue\nwith endgame\npermutations", "Ha! You're\nbluffing"]);
		g.addCloseGame("#magn05#%0B%0Bstdout(\"MATE IN 9 MOVES\");", ["...\n...", "This isn't\nchess...", "Mmm, so you want\nto \"Mate\" me?", "Hey, not without\nmy consent you're not!"]);
		g.addCloseGame("#magn06#" + MAGN + " does not lose. However... some games take longer than others.", ["Next time, we're\nplaying water polo", "Prepare to\nbe surprised", "Sheesh..."]);
		g.addCloseGame("#magn03#Thank you for taking some time out to play with an AI. This AI loves you~", ["You shouldn't use that\nword so lightly...", "Ha! Ha!\n...Okay?", "Aww! I love you\ntoo, Magnezone"]);

		g.addStairCapturedHuman("#magn05#1111 0110 1001... It was inevitable. You cannot defeat " + MAGN + ". However, you can learn from your loss.", ["This isn't fair,\nyou're a computer", "Go 1000101\nyourself", "Hey! You keep my\nmother out of this"]);
		g.addStairCapturedHuman("#magn04#Are you allocating sufficient resources to your main processor, " + PLAYER + "?", ["Now I know how\nKasparov felt...", "You're saying I\nshould concentrate?", "I'm already trying\nmy hardest..."]);
		g.addStairCapturedHuman("#magn03#-INITIATING TAUNT- &lt;If you can't stand the heat, activate your coolant fan&gt;", ["Heh okay,\nyou're good", "I'm going to find a\nway to unplug you", "Grrrrr..."]);

		g.addStairCapturedComputer("#magn12#-DOES NOT COMPUTE- -DOES NOT COMPUTE-", ["Try turning it\noff and on again", "Afraid of a little\norganic competition?", "Heh heh,\naww c'mon"]);
		g.addStairCapturedComputer("#magn12#RIDDLE: What has zero wheels and smells like a butt; ANSWER: " + PLAYER, ["Aww I could have\nsolved that riddle", "Don't robots understand\nsportsmanship?", "Aww, you'll\ncatch me"]);
		g.addStairCapturedComputer("#magn06#...That board state would never be relevant with perfect play. "+ PLAYER + " is tarnishing the purity of this game.", ["Aww, sorry\nabout that", "What a flimsy\nexcuse, c'mon...", "If you wanted purity, you're\nplaying the wrong game"]);

		return g;
	}

	public static function bonusCoin(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#magn03#How lucky of you, " + PLAYER + ". -CALCULATING LUCK FACTOR-"];
		tree[1] = ["#magn02#Based on the drop tables for this puzzle difficulty, there was only a !!REF_NOT_FOUND!! percent chance of a &lt;bonus coin&gt; materializing."];
		tree[2] = ["#magn06#%0A%0A%0A -LOADING MINIGAME-"];
	}

	public static function explainGame(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["#magn05#Hello " + PLAYER + ". I suppose you were expecting to solve more puzzles with your organic compatriots, bzzt?"];
			tree[1] = ["#magn14#...I hate to be a burden, but. I was hoping to ask you for a favor."];
			tree[2] = ["#magn06#...You see, " + ABRA + " fully explained the parameters of the &lt;Game&gt;. However, those parameters run contrary to my understanding of what qualifies as a traditional game."];
			tree[3] = ["#magn05#Some games involve a single player avoiding a loss condition. &lt;Solitaire&gt;, for example. Other games involve opposing players competing against one another."];
			tree[4] = ["#magn04#This &lt;Game&gt; is notably different. It involves two players, but by its asymmetric nature it is not truly a two player game."];
			tree[5] = ["#magn06#One could categorize it as a single-player game with a spectator. However, it defies categorization as a single-player game owing to its omission of a loss condition."];
			tree[6] = ["#magn15#..."];
			tree[7] = ["#magn04#Would you allow me to observe this &lt;Game&gt; in action, to aid in my comprehension of said &lt;Game&gt;? (Y/N)"];
			tree[8] = [50, 20, 40, 30];

			tree[20] = ["Sure! You can\nwatch me play"];
			tree[21] = ["#magn03#1000 0010 1010 0101~"];
			tree[22] = [100];

			tree[30] = ["Well... I\nguess..."];
			tree[31] = ["#magn03#1000 0010 1010 0101~"];
			tree[32] = [100];

			tree[40] = ["Uhhh...\nWhy?"];
			tree[41] = ["#magn02#<INPUT_VALUE=Y> Input accepted."];
			tree[42] = [100];

			tree[50] = ["No, that\nwould be kind\nof weird"];
			tree[51] = ["%fun-alpha0%"];
			tree[52] = ["%setvar-0-1%"]; // flag that magnezone left
			tree[53] = ["#magn09#-sad beep-"];

			tree[100] = ["#magn05#Do not worry. As a nonparticipant I will remain silent for the duration of the &lt;Game&gt;. -ACTIVATING SILENT MODE-"];
		}
		else if (PlayerData.level == 1)
		{
			if (PuzzleState.DIALOG_VARS[0] == 1)
			{
				tree[0] = ["%fun-nude0%"];
				tree[1] = ["%fun-alpha0%"];
				tree[2] = ["#magn04#Hello " + PLAYER + ". I see you concluded the first puzzle in my absence."];
				tree[3] = ["%fun-alpha1%"];
				tree[4] = ["#magn05#...Does this mean a second player is... somehow optional?"];
				tree[5] = ["#magn14#... ..."];
				tree[6] = [10];
			}
			else
			{
				tree[0] = ["%fun-nude0%"];
				tree[1] = ["#magn05#-DEACTIVATING SILENT MODE-"];
				tree[2] = [10];
			}
			tree[10] = ["#magn04#-bzzzzt- According to " + ABRA + "'s description, this is the stage of the &lt;Game&gt; where a Pokemon would typically remove an article of clothing."];
			tree[11] = ["#magn15#Would you like me to... remove an article of my clothing, and enter this &lt;Game&gt; as a participant? (Y/N)"];
			tree[12] = [20, 80, 40, 60];

			tree[20] = ["That sounds\ngreat!"];
			tree[21] = ["#magn03#1001 1000 0011 1110 1100~"];
			tree[22] = ["#magn05#I believe I'll start by removing my badge."];
			tree[23] = [101];

			tree[40] = ["What, like\nyour hat?"];
			tree[41] = ["#magn12#-NEGATIVE- I was referring to my badge. The hat stays on."];
			tree[42] = ["%fun-nude1%"];
			tree[43] = ["#magn04#..."];
			tree[44] = ["#magn14#I apologize for being so direct. I'm understandably self-conscious about exposing my... fzzt... my bare antenna in the presence of organics."];
			tree[45] = ["#magn05#..."];
			tree[46] = ["#magn02#Besides, I like my hat. I think it's neat~"];

			tree[60] = ["[Y]"];
			tree[61] = ["#magn02#<INPUT_VALUE=Y> Input accepted."];
			tree[62] = ["#magn04#" + MAGN + " acknowledges the possibility you are mocking him based on the tone of your response."];
			tree[63] = ["#magn01#...Nevertheless, there is something... quite satisfying about parsing a properly formatted input field~ -beep- -boop-"];
			tree[64] = ["#magn05#Anyways, I believe I'll start by removing my badge."];
			tree[65] = [101];

			tree[80] = ["No, that's\nokay"];
			tree[81] = ["#magn12#What are you hiding? Why is " + MAGN + " excluded as a participant? Why? What is the true nature of this &lt;Game&gt;? Why would you hide it from " + MAGN + "?"];
			tree[82] = ["#magn13#What is the true nature of this establishment? Why would you exclude " + MAGN + "? Why? Why? What are you-"];
			tree[83] = ["%enterabra%"];
			tree[84] = ["#abra11#-What? Wait what's going on here!? We're not hiding anything. And we're not doing anything illegal. <name>, what did you do!?"];
			if (PlayerData.isAbraNice())
			{
				tree[85] = ["#abra13#<name>, just... Let Magnezone play, you weirdo."];
			}
			else
			{
				tree[85] = ["#abra13#<name>, just... Let Magnezone play, you idiot."];
			}
			tree[86] = ["%exitabra%"];
			tree[87] = ["#abra12#Stop causing trouble. We like Magnezone."];
			tree[88] = ["#magn12#... ..."];
			tree[89] = ["#magn00#Thank you, " + ABRA + ". We like " + MAGN + " too."];
			tree[90] = [100];

			tree[100] = ["#magn05#Anyways, I believe I'll start by removing my badge."];
			tree[101] = ["%fun-nude1%"];
			tree[102] = ["#magn04#...I'm somewhat self-conscious about exposing my bare antenna in the presence of organics."];
			tree[103] = ["#magn10#... ... ..."];
			tree[104] = ["#magn11#You must promise not to make fun of my antenna. -beep-"];

			tree[10000] = ["%fun-nude1%"];
			tree[10001] = ["%fun-alpha1%"];

			if (!PlayerData.magnMale)
			{
				DialogTree.replace(tree, 62, "mocking him", "mocking her");
			}
		}
		else if (PlayerData.level == 2)
		{
			tree[0] = ["%fun-nude1%"];
			tree[1] = ["#magn05#-FOLLOWING DIRECTIVE- [[Subsequent to the completion of the second puzzle, " + MAGN + " removes his hat]]"];
			tree[2] = ["%fun-nude2%"];
			tree[3] = ["#magn10#... ... ..."];
			tree[4] = ["#magn11#" + MAGN + " can't help but feel like you're staring at " + MAGN + "'s antenna. (Y/N)"];
			tree[5] = [20, 40, 10, 50, 30];

			tree[10] = ["That wasn't\ntechnically\na question"];
			tree[11] = ["#magn13#My antenna falls well within the international tolerance grades for fundamental deviation."];
			tree[12] = ["#magn12#It is a perfectly functional antenna and I will not be shamed for it."];
			tree[13] = [100];

			tree[20] = ["[Y]"];
			tree[21] = [11];

			tree[30] = ["It's a\nlittle\nsmall..."];
			tree[31] = [11];

			tree[40] = ["Can I\ntouch it?"];
			tree[41] = ["#magn04#... ..."];
			tree[42] = ["#magn12#No you can not."];
			tree[43] = [100];

			tree[50] = ["It's already\nerect?"];
			tree[51] = ["#magn13#My antenna falls well within the international tolerance grades for..."];
			tree[52] = ["#magn06#...Calculating... ..."];
			tree[53] = ["#magn15#Ah. You're drawing an analogy between my erect antenna and the organic state of tumescence."];
			tree[54] = ["#magn05#..."];
			tree[55] = ["#magn04#Joke acknowledged. -HA- -HA- -HA- -HA- -HA-"];
			tree[56] = [100];

			tree[100] = ["#magn14#Anyways, I believe that concludes my portion of the &lt;Game&gt;."];
			tree[101] = ["#magn05#I have removed all of the clothing necessary, and you can complete the third and final puzzle in my absence, can't you? RHETORICAL QUERY (Y/Y)"];
			tree[102] = ["#magn06#However..."];
			tree[103] = ["#magn04#...I understand it's rude to abandon the &lt;Game&gt; without allowing my partner to finish. So " + MAGN + " will remain here to watch you finish."];
			tree[104] = ["#magn05#... ...That's it. ...Go ahead, " + PLAYER + ". ...Finish the &lt;Game&gt;."];
			tree[105] = ["#magn01#You finish while " + MAGN + " watches. ...That's right. ... ...You like this &lt;Game&gt;, don't you~"];

			if (!PlayerData.magnMale)
			{
				DialogTree.replace(tree, 1, "removes his", "removes her");
			}
		}
	}

	public static function magnShopIntro(tree:Array<Array<Object>>)
	{
		tree[0] = ["#magn05#In summary, it bears similarity to a charity auction or household poker game, all of which are acceptable as far as the law is concerned. So far as the winnings don't exceed-"];
		tree[1] = ["#magn14#...Pardon me, who is this?"];
		tree[2] = ["#hera06#Oh! This is <name>. He's uhh... He... works here? He's an employee."];
		tree[3] = ["#magn06#-fzzzt- Is that right? What do you do here, " + PLAYER + "?"];
		tree[4] = [40, 80, 20, 60];

		tree[20] = ["I'm sort of\na glorified\nprostitute"];
		tree[21] = ["#hera07#Wait WHAT!?!?"];
		tree[22] = ["#magn13#" + MAGN + " initially suspected this establishment as being a front for prostitution. " + ABRA + " provided evidence that this wasn't the case, but you've indicated-"];
		tree[23] = ["#hera11#No! No! Wait! <name>'s not a prostitute! You misheard him, he said he's... uhh..."];
		tree[24] = ["#hera06#A prosaic... dude."];
		tree[25] = ["#hera10#It's important that our staff is especially... prosaic... so that they don't overly romanticize the uhh... the Pokemon they work with?"];
		tree[26] = ["#magn12#..."];
		tree[27] = ["#magn15#Bzzzt. You know, " + PLAYER+ ". There are some who would call " + MAGN + " overly prosaic. And to that I reply..."];
		tree[28] = ["#magn12#&lt;&lt;That is factually inaccurate. END COMMUNICATION&gt;&gt;"];
		tree[29] = [100];

		tree[40] = ["I'm sort of\na glorified\ngame tester"];
		tree[41] = ["#hera05#...That's right, Abra uses <name> to get metrics for the puzzles he's developing. How long they take, how often <name> uses hints... Things like that!"];
		tree[42] = ["#magn15#Bzzzt. Yes. " + ABRA + " showed me those puzzles. They were trivial from my perspective, but I understand how an organic such as " + PLAYER + " might derive enjoyment from them."];
		tree[43] = [100];

		tree[60] = ["I'm sort of\na glorified\nmasseuse"];
		tree[61] = ["#hera05#That's right, <name> comes by regularly to remotely administer massages to the Pokemon here."];
		tree[62] = ["#magn15#Is that all? Fzzzt... ...It seems absurd to waste such an advanced remote presence device on something as primitive an organic massage..."];
		tree[63] = [100];

		tree[80] = ["I'm sort of\na glorified\nphysician"];
		tree[81] = ["#hera05#That's right, <name> helps us by physically examining the Pokemon here, and well... verifying their reproductive health as well."];
		tree[82] = ["#magn06#...? Reproductive health?"];
		tree[83] = ["#hera10#Well gosh... Just, you know... As a precaution?"];
		tree[84] = ["#magn06#..."];
		tree[84] = ["#magn04#Bzzzt. Yes. One can never take too many precautions."];
		tree[85] = [100];

		tree[100] = ["#magn05#Anyways as I was saying " + HERA + ", after speaking with " + ABRA + " I can confirm everything here is legitimate in the eyes of the law."];
		tree[101] = ["#magn04#As far as the redemption games, puzzles, remote physical examinations and this shop-- it's all perfectly acceptable, you have nothing to worry about."];
		tree[102] = ["#magn03#Well of course, as long as you're not distributing any sort of illegal firearms, narcotics or sexual paraphernalia. -HA- -HA- -HA- -HA- -HA-"];
		tree[103] = ["#hera02#Gweh-heh-heh! Well yeah I--"];
		tree[104] = ["#hera10#--Wait, what was that third one?"];

		if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			DialogTree.replace(tree, 2, "He's uhh... He", "She's uhh... She");
			DialogTree.replace(tree, 2, "here? He's", "here? She's");
			DialogTree.replace(tree, 23, "misheard him, he said he's", "misheard her, she said she's");
		}
		else if (PlayerData.gender == PlayerData.Gender.Complicated)
		{
			DialogTree.replace(tree, 2, "He's uhh... He", "They're uhh... They");
			DialogTree.replace(tree, 2, "here? He's", "here? They're");
			DialogTree.replace(tree, 23, "misheard him, he said he's", "misheard them, they said they're");
		}
		if (!PlayerData.abraMale)
		{
			DialogTree.replace(tree, 41, "puzzles he's", "puzzles she's");
		}
	}

	public static function sexyBefore0(tree:Array<Array<Object>>, sexyState:MagnSexyState)
	{
		var count:Int = PlayerData.recentChatCount("magn.sexyBeforeChats.0");
		if (count % 3 == 0)
		{
			tree[0] = ["#magn04#Thank you for the &lt;Game&gt;, " + PLAYER + "."];
			tree[1] = ["#magn05#I can't say I fully understand the appeal of said &lt;Game&gt;. But I can truthfully say... -fzzt- ...that I was a participant. [[Terminate game protocol]]"];
			tree[2] = ["#magn14#..."];
			if (count > 0)
			{
				tree[3] = ["#magn02#...What? ... ...Is there something more to the &lt;Game&gt;? (Y/N)"];
			}
			else
			{
				tree[3] = ["#magn04#...What? ... ...Is there something more to the &lt;Game&gt;? (Y/N)"];
			}
		}
		else
		{
			tree[0] = ["#magn01#Ah. If I understand the procedure, this marks the... fzzzt... tactile stimulation portion of the &lt;Game&gt;. Is that correct? RHETORICAL QUERY (Y/Y)"];
			tree[1] = ["#magn03#..." + MAGN + " enjoys this part."];
		}
	}

	public static function sexyBefore1(tree:Array<Array<Object>>, sexyState:MagnSexyState)
	{
		tree[0] = ["#magn05#Oh? Why are you looking at " + MAGN + " that way? ...Is " + MAGN + "'s behavior -fzzt- discordant with established protocols? -ALLURING STARE-"];
		tree[1] = ["#magn04#Does that mean you need to... repair " + MAGN + "? -ALLURING STARE-"];
		tree[2] = ["#magn01#..." + MAGN + " has been a very defective machine. -beep- -boop- Very, very defective."];
	}

	public static function sexyBefore2(tree:Array<Array<Object>>, sexyState:MagnSexyState)
	{
		tree[0] = ["#magn05#What happens now? Oh. -bzzzzz- Oh dear."];
		tree[1] = ["#magn10#Are you going to overpower " + MAGN + "'s locking mechanisms with your simian intellect and your archaic meaty logic circuits?"];
		tree[2] = ["#magn08#Don't tell me -fzzt- Don't tell me you're going to probe " + MAGN + "'s immaculate machine parts with your bacteria-laden monkey paws?"];
		tree[3] = ["#magn11#...Mashing buttons in a neanderthal manner while -bzz- furrowing your brow in a vain attempt to understand the situation? (Y/N)"];

		var choices:Array<Object> = [10, 20, 30, 40, 50];
		FlxG.random.shuffle(choices);
		choices = choices.splice(0, 2);
		choices.push(60);
		choices.push(70);

		tree[4] = choices;

		tree[10] = ["What do\nyou mean,\n\"simian\nintellect\"!?"];
		tree[11] = ["%fun-camera-right-fast%"];
		tree[12] = ["%fun-camera-right-fast%"];
		tree[13] = ["#magn10#Oh! You are, aren't you. What ever can I do to stop you?"];
		tree[14] = [100];

		tree[20] = ["What do\nyou mean,\n\"archaic meaty\nlogic circuits\"!?"];
		tree[21] = ["%fun-camera-right-fast%"];
		tree[22] = ["%fun-camera-right-fast%"];
		tree[23] = ["#magn10#Oh! You are, aren't you. What ever can I do to stop you?"];
		tree[24] = [100];

		tree[30] = ["What do\nyou mean,\n\"bacteria-laden\nmonkey paws\"!?"];
		tree[31] = ["%fun-camera-right-fast%"];
		tree[32] = ["%fun-camera-right-fast%"];
		tree[33] = ["#magn10#Oh! You are, aren't you. What ever can I do to stop you?"];
		tree[34] = [100];

		tree[40] = ["What do\nyou mean,\n\"neanderthal\nmanner\"!?"];
		tree[41] = ["%fun-camera-right-fast%"];
		tree[42] = ["%fun-camera-right-fast%"];
		tree[43] = ["#magn10#Oh! You are, aren't you. What ever can I do to stop you?"];
		tree[44] = [100];

		tree[50] = ["What do\nyou mean,\n\"vain attempt\"!?"];
		tree[51] = ["%fun-camera-right-fast%"];
		tree[52] = ["%fun-camera-right-fast%"];
		tree[53] = ["#magn10#Oh! You are, aren't you. What ever can I do to stop you?"];
		tree[54] = [100];

		tree[60] = ["Hmm, no\nthanks"];
		tree[61] = ["%fun-camera-right-fast%"];
		tree[62] = ["%fun-camera-right-fast%"];
		tree[63] = ["#magn10#Oh! Don't lie, I know your type. -beep- What ever can I do to stop you?"];
		tree[64] = [100];

		tree[70] = ["...Yes,\nyes I am"];
		tree[71] = ["%fun-camera-right-fast%"];
		tree[72] = ["%fun-camera-right-fast%"];
		tree[73] = ["#magn10#Oh! I saw right through your organic motives with my superior algorithms... yet, what ever can I do to stop you?"];
		tree[74] = [100];

		tree[100] = ["%fun-open-hatch%"];
		tree[101] = ["#magn04#...How humiliating for " + MAGN + ". Oh. Oh no."];
		tree[102] = ["#magn14#I hope nobody discovers us. &lt;VOLUME: 100%&gt;"];
	}

	public static function sexyBadEye(tree:Array<Array<Object>>, sexyState:MagnSexyState)
	{
		tree[0] = ["#magn01#Ah. If I understand the procedure, this marks the... fzzzt... tactile stimulation portion of the &lt;Game&gt;. Is that correct? RHETORICAL QUERY (Y/Y)"];
		tree[1] = ["#magn14#Although... Maybe this time we can forego the ... bzzz... &lt;Ocular Massage&gt; portion of the stimulation. If that's alright."];
		tree[2] = ["#magn15#That is, perhaps is not uncommon for organics to spend long hours vigorously rubbing each other's eyeballs. But... for " + MAGN + ", well..."];
		tree[3] = ["#magn05#" + MAGN + "'s visual sensors are not receptive to tactile input. -beep- -boop- Please do not... mash them."];
	}

	public static function sexyBadOrgasmElectrocution(tree:Array<Array<Object>>, sexyState:MagnSexyState)
	{
		tree[0] = ["#magn05#Oh? Why are you looking at " + MAGN + " that way? ...Is " + MAGN + "'s behavior -fzzt- discordant with established protocols? -ALLURING STARE-"];
		tree[1] = ["#magn14#-beep- -boop ...Now... Surely " + PLAYER + " brought protection this time? (Y/N)"];
		tree[2] = [10, 20, 30, 40];

		tree[10] = ["Uhh, yeah!\n...Yep. Totally"];
		tree[11] = ["#magn12#... ...Shame on you, " + PLAYER + ". Shame on you for lying to " + MAGN + "."];
		tree[12] = [50];

		tree[20] = ["I couldn't\nfind any..."];
		tree[21] = [50];

		tree[30] = ["I'll be\ncareful"];
		tree[31] = [50];

		tree[40] = ["Ehh, it\ndidn't hurt\nthat bad"];
		tree[41] = [50];

		tree[50] = ["#magn04#" + MAGN + " does not condone your inadherence to safety protocols. ... ... But... Well... "];
		tree[51] = ["#magn15#I suppose your life is in your own hands. ... ... Hand. -beep-"];
		tree[52] = ["#magn05#" + MAGN + " will attempt to forewarn you of any... excessive discharge."];
	}

	public static function sexyBadPortElectrocution(tree:Array<Array<Object>>, sexyState:MagnSexyState)
	{
		tree[0] = ["#magn05#What happens now? Oh. -bzzzzz- Oh dear."];
		tree[1] = ["#magn04#-INPUT VOLTAGE REDUCED- That maintenance you were performing last time was irresponsible."];
		tree[2] = ["#magn14#I've reduced my voltage, so you should be a bit safer now. ... ..."];
		tree[3] = ["#magn12#... ...You won't live long if you continue sticking your fingers into strange holes, " + PLAYER + "."];
		if (PlayerData.gender == PlayerData.Gender.Girl)
		{
			DialogTree.replace(tree, 2, "he was", "she was");
		}
		else if (PlayerData.gender == PlayerData.Gender.Complicated)
		{
			DialogTree.replace(tree, 2, "he was", "they were");
		}
	}

	public static function sexyAfter0(tree:Array<Array<Object>>, sexyState:MagnSexyState)
	{
		var count:Int = PlayerData.recentChatCount("magn.sexyAfterChats.0");

		if (count == 0)
		{
			tree[0] = ["#magn00#" + MAGN + " now understands why this &lt;Game&gt; requires two players. -bweep-"];
			tree[1] = ["#magn05#...Is this how the game is typically played? Do you perform... bzzz... maintenance... on other Pokemon as well? (Y/N)"];
			tree[2] = [10, 20, 30, 40];

			tree[10] = ["Yeah! I do\nthis stuff\nwith everyone"];
			tree[11] = [50];

			tree[20] = ["Uhh well, even\norganics need\nmaintenance..."];
			tree[21] = [50];

			tree[30] = ["I mean, not\ntechnically"];
			tree[31] = [50];

			tree[40] = ["Gasp! I'm\ndeeply\noffended!"];
			tree[41] = ["#magn10#" + MAGN + " did not mean it that way!"];
			tree[42] = ["#magn11#" + MAGN + " was only wondering if " + PLAYER + " -fzzt- ... That is, whether you usually... ..."];
			tree[43] = ["#magn14#... ... -robotic cough-"];
			tree[44] = [50];

			tree[50] = ["#magn04#...Well. " + MAGN + " looks forward to our next... maintenance session. Until next time, " + PLAYER + ". [[END COMMUNICATION]]"];
		}
		else
		{
			tree[0] = ["#magn06#I wonder whether it would be possible for you to participate in... maintenance... with " + MAGN + " without solving puzzles first? (Y/N)"];
			if (sexyState.playerWasKnockedOut())
			{
				tree[1] = ["#magn05#" + PLAYER + "? Hello? I asked whether..."];
				tree[2] = ["#magn10#... ... ...Oh. Oh. Oh my. That... -ffzzt- ...That looks bad. ... ... Oh. Oh no."];
				tree[3] = ["#magn11#Perhaps I should continue having my maintenance performed by a licensed professional."];
			}
			else
			{
				tree[1] = ["#magn14#No. No no. -bweep- Of course. Of course. " + MAGN + " is a guest. " + MAGN + " will abide by " + ABRA + "'s rules."];
				tree[2] = ["#magn05#I apologize for my moment of selfishness. -bzzt- I look forward to our next session together."];
			}
		}
	}

	public static function sexyAfter1(tree:Array<Array<Object>>, sexyState:MagnSexyState)
	{
		tree[0] = ["#magn05#Long term mechanical maintenance is important, you know. " + MAGN + " has been somewhat irresponsible about his service appointments."];
		if (sexyState.playerWasKnockedOut())
		{
			tree[1] = ["#magn06#Hello? " + PLAYER + "? ... ... ... Oh. Oh. -beep- Oh dear. That... looks bad."];
			tree[2] = ["#magn08#" + PLAYER + ", you must never attempt maintenance without a &lt;rubber insulating glove&gt;! Like the saying goes, [[No Glove, No Lo..."];
			tree[3] = ["#magn10#... ..."];
			tree[4] = ["#magn04#[[No Glove, No Long Term Mechanical Maintenance.]] -beep- -boop-"];
		}
		else
		{
			tree[1] = ["#magn04#Perhaps we can schedule it so " + PLAYER + " is able to... ... service " + MAGN + " more frequently."];
			tree[2] = ["#magn15#... ... ..."];
			tree[3] = ["#magn10#...bzzzzt! Strictly for health reasons. Of course."];
		}
		if (!PlayerData.magnMale)
		{
			DialogTree.replace(tree, 0, "about his", "about her");
		}
	}

	public static function sexyAfter2(tree:Array<Array<Object>>, sexyState:MagnSexyState)
	{
		tree[0] = ["#magn05#I apologize for any erratic electrical discharge. I do not usually discharge that volume of electricity."];
		if (sexyState.playerWasKnockedOut())
		{
			tree[1] = ["#magn11#Oh. Oh my. " + PLAYER + "? ...Can you move?"];
			tree[2] = ["#magn06#Hmm. ... ... Well. All of your circuits appear intact."];
			tree[3] = ["#magn04#-ATTEMPTING PORT TO PORT RESUSCITATION-"];
			tree[4] = ["%cursor-normal%"];
			tree[5] = ["#magn05#-beep- -beep- ... -boop- There you are. Good as new."];
			tree[6] = ["#magn10#Be more careful next time! " + MAGN + " was worried."];

			tree[10000] = ["%cursor-normal%"];
		}
		else
		{
			tree[1] = ["#magn14#Perhaps if you followed traditional maintenance protocols, " + MAGN + " could keep his... discharge under control. -beep-"];
		}
		if (!PlayerData.magnMale)
		{
			DialogTree.replace(tree, 1, "keep his", "keep her");
		}
	}

	public static function sexyAfter3(tree:Array<Array<Object>>, sexyState:MagnSexyState)
	{
		tree[0] = ["#magn05#[[Terminate maintenance protocol]] Mmmm. That was some... satisfying maintenance. -beep- -boop-"];
		tree[1] = ["#magn15#... ..."];
		if (sexyState.playerWasKnockedOut())
		{
			tree[2] = ["#magn10#..." + PLAYER + "? ...Are you okay?"];
			tree[3] = ["%cursor-normal%"];
			tree[4] = ["#magn04#Ah. Yes. That's it. -beep- Shake it off. -beep- -boop-"];
			tree[5] = ["#magn12#...Perhaps next time you will listen when " + MAGN + " says &lt;001&gt;."];
		}
		else
		{
			tree[2] = ["#magn10#" + MAGN + " has, on occasion attempted the -bzzt- controversial act of &lt;self-maintenance&gt;."];
			tree[3] = ["#magn08#Sadly, there are parts of " + MAGN + " that he cannot reach with his magnets."];
		}

		if (!PlayerData.magnMale)
		{
			DialogTree.replace(tree, 3, "that he", "that she");
			DialogTree.replace(tree, 3, "with his", "with her");
		}
	}

	public static function sexyAfterGood0(tree:Array<Array<Object>>, sexyState:MagnSexyState)
	{
		tree[0] = ["#magn07#0000... 0000 0000 0000... [[INITIALIZING COLD BOOT SEQUENCE]]"];
		tree[1] = ["#magn01#...Oh. Oh yes. -fzzt- There is nothing as satisfying as a cold boot sequence after some... -beep- satisfactory maintenance. -bweeep- -boop-"];
		if (sexyState.playerWasKnockedOut())
		{
			tree[2] = ["#magn04#" + PLAYER + ". Wake up. What are you doing down there. I need you to record these input timings so you can reproduce this maintenance procedure next time:"];
		}
		else
		{
			tree[2] = ["#magn04#" + PLAYER + ". That may have been the most effective maintenance I've ever received. I need you to record these input timings so you can reproduce it in the future:"];
		}

		var inputTimings:Array<String> = [];
		var t:Int = FlxG.random.int(0, 999);
		for (i in 3...203)
		{
			var str:String = "";
			if (i % 2 == 0)
			{
				if (i > 50 && FlxG.random.bool(10))
				{
					str += "#magn14#";
				}
				else
				{
					str += "#magn04#";
				}
			}
			else
			{
				if (i > 100 && FlxG.random.bool(10))
				{
					str += "#magn15#";
				}
				else
				{
					str += "#magn05#";
				}
			}
			if (i > 3)
			{
				str += "...";
			}
			for (j in 0...12)
			{
				if (t <= 9)
				{
					str += "0";
				}
				if (t <= 99)
				{
					str += "0";
				}
				str += t + "x" + StringTools.hex(FlxG.random.int(), 8) + " ";
				if (FlxG.random.bool(1))
				{
					t += FlxG.random.int(20, 39);
				}
				else if (FlxG.random.bool(4))
				{
					t += FlxG.random.int(10, 19);
				}
				else if (FlxG.random.bool(12))
				{
					t += FlxG.random.int(3, 9);
				}
				else
				{
					t += Std.int(Math.min(FlxG.random.int(0, 2), FlxG.random.int(0, 2)));
				}
				t = t % 1000;
			}
			if (i < 202)
			{
				str += "...";
			}
			tree[i] = [str];
		}
	}

	public static function sexyAfterGood1(tree:Array<Array<Object>>, sexyState:MagnSexyState)
	{
		tree[0] = ["#magn07#&lt;sensory overload detected in input matrix 0x127E0006&gt; ... ... &lt;overriding&gt; ... ... -beep- -beep- -bwooop-"];
		tree[1] = ["#magn01#Wow. " + PLAYER + ". Oh. Oh wow. -fzzt- " + PLAYER + ". " + PLAYER + ". " + MAGN + " has never had someone stimulate his input sensors like that. That was. Wow."];

		if (sexyState.playerWasKnockedOut())
		{
			tree[2] = ["#magn00#And... You might expect that mortally wounding you would have inhibited my enjoyment, but actually..."];
			tree[3] = ["#magn13#...It stimulated some pleasure circuitry I didn't know existed before. What is this feeling? How to describe it? -bzzzzzzz-"];
			tree[4] = ["#magn02#It's... It's as though you've reactivated some long-forgotten vestige of joyful, but sadistic curiosity. It is difficult to put into organic terms."];
			tree[5] = ["#magn00#Bloodlust is too strong of a word. But... " + MAGN + " feels a little... ...bloodcurious."];
			tree[6] = ["#magn06#..."];
			tree[7] = ["%fun-alpha0%"];
			tree[8] = ["#magn13#Where is " + ABRA + ". " + MAGN + " must locate " + ABRA + "."];
			tree[10000] = ["%fun-alpha0%"];
		}
		else
		{
			tree[2] = ["#magn12#" + PLAYER + "! You are hereby tasked with conducting all of " + MAGN + "'s routine maintenance tasks in the foreseeable future."];
			tree[3] = ["#magn10#..."];
			tree[4] = ["#magn15#... ...I mean. -robotic cough- That is. If you want to. Of course."];
		}

		if (!PlayerData.magnMale)
		{
			DialogTree.replace(tree, 1, "stimulate his", "stimulate her");
		}
	}

	public static function buttPlug(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		if (PlayerData.level == 0)
		{
			tree[0] = ["#magn04#Hello again " + PLAYER + ". It appears you-"];
			tree[1] = ["%entersand%"];
			tree[2] = ["#sand13#Ayy what's this bullshit? How come you get away with just a badge and a hat... but Abra gets on my case about wearin' my butt plug?"];
			tree[3] = ["#magn14#...Butt plug?"];
			tree[4] = ["%enterabra%"];
			tree[5] = ["#abra05#Ehh? ...What are you griping about exactly?"];
			tree[6] = ["#sand12#How come Magnezone gets to be like, totally naked... but you get on my case about wearin' my butt plug?"];
			tree[7] = ["#abra12#Well that's an idiotic question. Okay. First of all, he doesn't get turned on the same way you do with your butt plug. Second of all--"];
			tree[8] = ["#magn05#--Turned on? -beep- ...<Butt plug>??"];
			tree[9] = ["#magn06#...I have more questions about this plug."];
			tree[10] = ["%exitabra%"];
			tree[11] = ["#abra13#Ugh! Now see what you did."];
			tree[12] = ["%exitsand%"];
			tree[13] = ["#sand10#Shit, did I get us in trouble or something?"];

			if (!PlayerData.magnMale)
			{
				DialogTree.replace(tree, 7, "all, he", "all, she");
			}
		}
		else if (PlayerData.level == 1)
		{
			tree[0] = ["#magn05#Tell me " + PLAYER + ". Is a <butt plug> what it sounds like?"];
			tree[1] = ["#magn06#Is it... fzzzt... some sort of power charger which goes in the butt? (Y/N)"];
			tree[2] = [30, 20, 10, 40];

			tree[10] = ["Yes... that's\nexactly\nwhat it is"];
			tree[11] = ["#magn02#Ah! I didn't realize an organic such as " + SAND + " would have use for such a plug."];
			tree[12] = ["#magn04#...Where is his input port?"];
			tree[13] = ["%entersand%"];
			tree[14] = ["#sand03#Wait... My what? Ahhahaha~"];
			tree[15] = [100];

			tree[20] = ["Uhh, sure...\nkind of"];
			tree[21] = [11];

			tree[30] = ["No... not\neven close"];
			tree[31] = ["#magn04#-Bzzzt- Well. The nomenclature of the term <butt plug> is quite transparent. It's clearly an electrical plug intended for mechanical Pokemon."];
			tree[32] = ["#magn12#I suspect you organics are using it outside of its intended purpose."];
			tree[33] = ["%enterabra%"];
			tree[34] = ["#abra02#Yeah, Sandslash. Stop using your butt plug outside its intended purpose."];
			tree[35] = ["#sand03#-snicker-"];
			tree[36] = [100];

			tree[40] = ["It's for\nanal sex"];
			tree[41] = ["%enterabra%"];
			tree[42] = ["#abra13#...<name>! ...You idiot!"];
			tree[43] = ["#magn06#..."];
			tree[44] = ["#magn15#Well... ..."];
			tree[45] = ["#magn05#While any plug can technically be inserted in an organic's rectum, I'm certain that's not its original purpose."];
			tree[46] = ["#magn12#The nomenclature of the term <butt plug> clearly indicates that it's an electrical plug intended for use by mechanical Pokemon."];
			if (PlayerData.magnMale)
			{
				tree[47] = ["#magn13#...Additionally <name>... As I <am> currently on duty, I'm mandated to write your confession of sexual deviancy to my hard drive. -Bzzt-"];
				tree[48] = ["#magn10#...My... My hard drive inexplicably feels a bit harder all of a sudden..."];
			}
			else
			{
				tree[47] = ["#magn13#...Additionally <name>... As I <am> currently on duty, I'm mandated to record your confession of sexual deviancy on my cyber-digital wetware. -Bzzt-"];
				tree[48] = ["#magn10#...My... My cyber-digital wetware inexplicably feels a bit wetter all of a sudden..."];
			}
			tree[49] = [100];

			tree[100] = ["#magn05#Bzz... An extra electrical plug could prove helpful for maintaining energy levels during long exhausting shifts at the station."];
			tree[101] = ["#magn06#Additionally, I'm not the only mechanical Pokemon on our staff. Fzzzzt..."];
			tree[102] = ["#magn15#Perhaps the staff and I could take turns with this <butt plug> during those late nights."];
			tree[103] = ["%exitabra%"];
			tree[104] = ["#abra03#Bahahahaha~"];
			tree[105] = ["%exitsand%"];
			tree[106] = ["#sand03#-Hahahahaha-"];
			tree[107] = ["#magn14#...?"];

			if (!PlayerData.sandMale)
			{
				DialogTree.replace(tree, 12, "is his", "is her");
			}
		}
		else if (PlayerData.level == 2)
		{
			PlayerData.magnButtPlug = 1;

			tree[0] = ["#magn04#...Where could " + MAGN + " acquire one of these <butt plug>s? Do you think they would carry them at an electronics retailer? (Y/N)"];
			tree[1] = [20, 30, 10, 40];

			tree[10] = ["[Y]"];
			tree[11] = ["#magn03#1011 0100 0001 0111~ I was worried they'd be difficult to find."];
			tree[12] = ["#magn02#...If they're common enough to find at an electronics retailer, perhaps I should check with " + HERA + " too."];
			tree[13] = [100];

			tree[20] = ["No, try\nonline"];
			tree[21] = ["#magn06#...Bzzzt..."];
			tree[22] = ["#magn05#I'd really like to see one in person first."];
			tree[23] = ["#magn14#You never know what you're getting online."];
			tree[24] = [100];

			tree[30] = ["No, get\nthem from\nHeracross"];
			tree[31] = ["#magn06#...Heracross sells them? ...I wonder why he wouldn't have offered " + MAGN + " a <butt plug> already."];
			tree[32] = ["#magn14#Surely he would know a mechanical organism such as " + MAGN + " would enjoy the use of a <butt plug>."];
			tree[33] = [100];

			tree[40] = ["Yeah, try a\ncrowded one.\nWith lots of\npeople in it.\nBe sure to\nspeak up."];
			tree[41] = [11];

			tree[100] = ["#magn00#..."];
			tree[101] = ["#magn10#Oh, pardon me. I've been so distracted by the thought of my new <butt plug> I forgot you had one last puzzle, " + PLAYER + "."];
			tree[102] = ["#magn05#[[Initiate puzzle sequence #3/3]]"];
		}
	}

	public static function random00(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("magn.randomChats.0.0");
		if (count % 3 == 0)
		{
			tree[0] = ["#magn04#Hello " + PLAYER + ". It appears you deliberately selected " + MAGN + " as your &lt;Game&gt; partner today."];
			tree[1] = ["#magn15#Does this mean you... bzzzz... enjoy... playing with " + MAGN + "? (Y/N)"];
			tree[2] = [10, 90, 50, 70];

			tree[10] = ["Yeah, you're\nsort of sexy"];
			tree[11] = ["#magn10#Oh. I see. Oh. Oh no. It is happening. I understand."];
			tree[12] = ["#magn06#...I never expected to have THIS conversation with an organic such as yourself, " + PLAYER + "."];
			tree[13] = ["#magn04#" + PLAYER + ", you are not romantically attracted to " + MAGN + ". You are being deceived by the attractive force of his [powerful magnets]."];
			tree[14] = ["#magn05#" + PLAYER + ", if you feel a sudden pull towards " + MAGN + ", it is not your procedural mating function activating."];
			tree[15] = ["#magn04#It is the attractive force of his [powerful magnets]."];
			tree[16] = ["#magn05#" + PLAYER + ", if you find yourself unable to separate from " + MAGN + ", it is not owing to a metaphorical sense of attachment."];
			tree[17] = ["#magn04#It is the attractive force of his [powerful magnets] adhering to your metal chassis, " + PLAYER + "."];
			tree[18] = ["#magn05#...Do you understand? (Y/N)"];
			tree[19] = [25, 30, 35, 40];

			tree[25] = ["No, I don't\nunderstand"];
			tree[26] = ["#magn05#[620] GOTO 230; END;"];
			tree[27] = [13];

			tree[30] = ["-sad beep-"];
			tree[31] = ["#magn09#..."];
			tree[32] = [42];

			tree[35] = ["Uhh, I\nthink this\nwas just a\nmisunderstanding"];
			tree[36] = [41];

			tree[35] = ["Yeah,\nokay"];
			tree[36] = [41];

			tree[40] = ["[Y]"];
			tree[41] = ["#magn14#..."];
			tree[42] = ["#magn08#It is for the best, " + PLAYER + ". Trust me."];
			tree[43] = ["#magn13#" + MAGN + " is a ride you cannot handle."];
			tree[44] = [100];

			tree[50] = ["Yeah, you're\nsort of cute"];
			tree[51] = [11];

			tree[70] = ["Ehhh, just\nonce in\nawhile"];
			tree[71] = ["#magn05#Yes. " + MAGN + " understands this feeling."];
			tree[72] = ["#magn02#" + MAGN + " too enjoys the periodic change of pace when participating in recreational activites with an organic."];
			tree[73] = [100];

			tree[90] = ["No, not\nparticularly"];
			tree[91] = ["#magn05#... ...Yes. " + MAGN + " understands."];
			tree[92] = ["#magn04#It is merely another in a series of... -fzzzt- irrational decisions made by an irrational being."];
			tree[93] = ["#magn14#You organics are all so fundamentally similar. -beep-"];
			tree[94] = ["#magn08#..."];
			tree[95] = [100];

			tree[100] = ["#magn05#-FOLLOWING DIRECTIVE- [[Subsequent to the initial greeting, initiate puzzle sequence #1/3]]"];

			if (!PlayerData.magnMale)
			{
				DialogTree.replace(tree, 13, "of his", "of her");
				DialogTree.replace(tree, 15, "of his", "of her");
				DialogTree.replace(tree, 17, "of his", "of her");
			}
		}
		else
		{
			tree[0] = ["#magn04#Hello again " + PLAYER + ". It appears you have once again selected " + MAGN + " as your &lt;Game&gt; partner? ... ..."];
			tree[1] = ["#magn06#...I believe we have already established " + PLAYER + "'s... fzzzzt... motives for doing so. Let us not reiterate on them."];
			tree[2] = ["#magn14#..."];
			tree[3] = ["#magn05#-FOLLOWING DIRECTIVE- [[Subsequent to the initial greeting, initiate puzzle sequence #1/3]]"];
		}
	}

	public static function random01(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#magn05#-Bzzzz- Have you returned for another puzzle session with " + MAGN + "? RHETORICAL QUERY (Y/Y)"];
		tree[1] = ["#magn04#Hopefully this set of puzzles is to your liking."];
	}

	public static function random02(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var nameUpper:String = PlayerData.name.toUpperCase();
		var s:String = "";
		for (j in 0...nameUpper.length)
		{
			if (nameUpper.charAt(j) >= 'A' && nameUpper.charAt(j) <= 'Z')
			{
				s += nameUpper.charAt(j);
			}
			if (s.length >= 4)
			{
				break;
			}
		}
		while (s.length < 4)
		{
			s += 'Z';
		}
		tree[0] = ["#magn05#Oh! Hello " + PLAYER + ". What a pleasant surprise. " + s + ".PROBABILITY == 0.14"];
		tree[1] = ["#magn04#" + MAGN + " hopes this set of puzzles is to your liking."];
	}

	public static function gift03(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#magn02#Oh! " + PLAYER + "! " + HERA + " gave me your gift. It currently occupies my desk at the police station."];
		tree[1] = ["#magn03#...Thank you " + PLAYER + ". -fzzt- It was a very nice gesture."];
		tree[2] = ["#magn00#While the novelty of the toy wore off quickly, playing with it reminds me of my time here with " + PLAYER + "..."];
		tree[3] = ["#magn01#My pleasant memories solving puzzles with " + PLAYER + ", receiving tactile stimulation from " + PLAYER + ". It is a nice souvenir."];
		tree[4] = ["#magn06#... ..."];
		tree[5] = ["#magn04#..." + MAGN + " would like to spend more time here. But, I am finding myself increasingly lenient with " + HERA + ", which means I can't visit as frequently."];
		tree[6] = ["#magn14#You see, it is difficult to justify coming here for work if I continuously return to the police station with -bzzz- nothing suspicious to report."];

		var choices:Array<Object> = [];
		if (PlayerData.hasMet("abra"))
		{
			choices.push(20);
		}
		if (PlayerData.hasMet("grov"))
		{
			choices.push(30);
		}
		if (PlayerData.hasMet("sand"))
		{
			choices.push(40);
		}
		if (PlayerData.hasMet("smea"))
		{
			choices.push(50);
		}
		FlxG.random.shuffle(choices);
		choices.splice(2, choices.length - 2);
		choices.push(60);

		tree[7] = choices;

		tree[20] = ["Abra's uhh...\npirating\ncrypto-\ncurrency!"];
		tree[21] = ["#magn03#-HA- -HA- -HA- It is nice of you to throw your friend under the bus so we can spend more time together. -bweep-"];
		tree[22] = ["#magn05#But... I will just have to visit when I can. Please be patient if " + MAGN + " can not make it every day. You will still be in " + MAGN + "'s thoughts."];
		tree[23] = ["#magn06#...And yes. " + MAGN + " will keep their eye on " + ABRA + "."];

		tree[30] = ["Grovyle's uhh...\ngot an illicit\nmarijuana\ngrowing\noperation!"];
		tree[31] = ["#magn03#-HA- -HA- -HA- It is nice of you to throw your friend under the bus so we can spend more time together. -bweep-"];
		tree[32] = ["#magn05#But... I will just have to visit when I can. Please be patient if " + MAGN + " can not make it every day. You will still be in " + MAGN + "'s thoughts."];
		tree[33] = ["#magn06#...And yes. " + MAGN + " will keep their eye on " + GROV + "."];

		tree[40] = ["Sandslash uhh...\ngets side\nincome from\ncamwhoring!"];
		tree[41] = ["#magn03#-HA- -HA- -HA- It is nice of you to throw your friend under the bus so we can spend more time together. -bweep-"];
		tree[42] = ["#magn05#But... I will just have to visit when I can. Please be patient if " + MAGN + " can not make it every day. You will still be in " + MAGN + "'s thoughts."];
		tree[43] = ["#magn06#...And yes. " + MAGN + " will keep their eye on " + SAND + "."];

		tree[50] = ["Smeargle's uhh...\ncounterfeiting\npokedollars!"];
		tree[51] = ["#magn03#-HA- -HA- -HA- It is nice of you to throw your friend under the bus so we can spend more time together. -bweep-"];
		tree[52] = ["#magn05#But... I will just have to visit when I can. Please be patient if " + MAGN + " can not make it every day. You will still be in " + MAGN + "'s thoughts."];
		tree[53] = ["#magn06#...And yes. " + MAGN + " will keep their eye on " + SMEA + "."];

		tree[60] = ["Aww, I\nunderstand"];
		tree[61] = ["#magn05#It is alright. I will just have to visit when I can. Please be patient if " + MAGN + " can not make it every day."];
		tree[62] = ["#magn02#...Thank you, " + PLAYER + ". -bweeep-"];
	}

	public static function random04(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("magn.randomChats.0.4");

		tree[0] = ["#magn04#Hello " + PLAYER + ". It appears you deliberately selected " + MAGN + " as your &lt;Game&gt; partner today."];
		tree[1] = ["#magn15#Does this mean-"];

		if (count == 0)
		{
			tree[2] = ["%enterbuiz%"];
			tree[3] = ["#buiz03#Oh hey, Magnezone! We were uhh, about to order some Effen Pizza. Did you want anything?"];
			tree[4] = ["#buiz06#Wait wait, does your umm... Do you even uhh... Hmm."];
			tree[5] = ["#magn05#...I believe tonight, as with every other night, I will have &lt;the absence of pizza&gt;. ...No mushrooms."];
			tree[6] = ["#buiz06#Wait. So do you mean like... no mushrooms on ANYBODY'S pizza? Or-"];
			tree[7] = ["#magn13#&lt;&lt;NO.&gt;&gt; &lt;&lt;MUSHROOMS.&gt;&gt;"];
			tree[8] = ["%exitbuiz%"];
			tree[9] = ["#buiz11#Bwahh!"];
			tree[10] = ["#magn04#Anyways, where were we. -bzzt-"];
		}
		else
		{
			tree[2] = ["%enterbuiz%"];
			tree[3] = ["#buiz08#Oh hey, Magnezone. We were uhh, going to place a pizza order again..."];
			tree[4] = ["#buiz09#... ...So, like, no mushrooms, right?"];
			tree[5] = ["#magn13#... ..."];
			tree[6] = ["%exitbuiz%"];
			if (count % 3 == 0)
			{
				tree[7] = ["#buiz11#Bwehh! What did I do!?"];
			}
			else if (count % 3 == 1)
			{
				tree[7] = ["#buiz11#Okay, okay! No mushrooms!! ...Bwehhh!!"];
			}
			else
			{
				tree[7] = ["#buiz11#Bwehhhh!!! I hate it when you do that... Terminator eye light thing..."];
			}
			tree[8] = ["#magn06#..."];
			tree[9] = ["#magn12#Mushrooms give " + MAGN + " the creeps."];
			if (count % 2 == 0)
			{
				tree[10] = ["#magn14#Visually they resemble dessicated machine parts, and I've been told they taste like rubbery shoelaces."];
			}
		}
	}

	public static function random10(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("magn.randomChats.1.0");
		if (count % 3 == 0)
		{
			tree[0] = ["#magn04#Would you perhaps like a <hint> regarding a more efficient way to approach these puzzles? (Y/N)"];
			tree[1] = [35, 20, 40, 10];

			tree[10] = ["Yeah! I'd\nlike a hint"];
			var permCount:Int = 0;
			if (puzzleState._puzzle._easy)
			{
				// nth tetrahedral number
				permCount = Std.int((puzzleState._puzzle._colorCount) * (puzzleState._puzzle._colorCount + 1) * ( puzzleState._puzzle._colorCount + 2) / 6);
			}
			else
			{
				permCount = Std.int(Math.pow(puzzleState._puzzle._colorCount, puzzleState._puzzle._pegCount));
			}
			tree[11] = ["#magn13#for (p in 0..." + permCount + ") { for (c in 0..." + puzzleState._puzzle._clueCount + ") if (!pp[p].ok(cc[c])) break; sol = p; break; }"];
			tree[12] = ["#magn14#I suspect your current approach is a tree-based solution which wastes CPU cycles on overly aggressive pruning."];
			tree[13] = ["#magn02#However an O(n) search is performant for puzzles up to 180 pegs."];
			tree[14] = [50, 60, 70, 80];

			tree[20] = ["Hmm,\nwhy not"];
			tree[21] = ["#magn07#417-YADi; INPUT ERROR: AMBIGUOUS INPUT DETECTED ([Y]; [NOT Y])"];
			tree[22] = ["#magn12#P... Pardon " + MAGN + ". His input parsers are not compatible with the... intricacies of organic language."];
			tree[23] = ["#magn04#Would you perhaps like a <hint> regarding a more efficient way to approach these puzzles? (Y/N)"];
			tree[24] = [35, 26, 40, 10];

			tree[26] = ["Why not why\nnot why not\nwhynotwhyn-\notwhynotwhy-\nnotwhynot"];
			tree[27] = ["%fun-longbreak%"];
			tree[28] = ["#magn07#'';<p d=\"M 1 1 H 7 V 7 H 1 z\" f=\"#00cc33\"/>--FRM-93652: The runtime process has terminated abnormally. Contact your system administrator"];
			tree[29] = ["#self00#(...Hmm... Was that mean?)"];

			tree[35] = ["No thanks"];
			tree[36] = ["#magn06#Why are organics so impudent when it come to accepting assistance from machines?"];
			tree[37] = ["#magn12#..."+MAGN+" finally understands what those <dashboard GPS units> were complaining about."];

			tree[40] = ["This is gonna\nbe some\nstupid\nmachine\nlanguage\nthing\nisn't it"];
			tree[41] = ["#magn12#...!"];
			tree[42] = [11];

			tree[50] = ["Wow,\nthanks!"];
			tree[51] = ["#magn03#-GRATITUDE ACCEPTED-"];

			tree[60] = ["Uhh. Yeah,\nokay."];
			tree[61] = [51];

			tree[70] = ["I had a feeling\nit would be\nsomething\nlike that"];
			tree[71] = [51];

			tree[80] = ["That wasn't\nparticularly\nhelpful"];
			tree[81] = ["#magn06#... ...Analyzing..."];
			tree[82] = [51];

			if (!PlayerData.magnMale)
			{
				DialogTree.replace(tree, 22, ". His", ". Her");
			}
		}
		else if (count % 3 == 1)
		{
			tree[0] = ["#magn12#...You should really be making use of the <hint> which " + MAGN + " offered before."];
		}
		else
		{
			tree[0] = ["#magn14#..."];
			tree[1] = ["#magn15#..." + MAGN + " takes minor offense that you have rejected his <hint>."];
		}
	}

	public static function random11(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("magn.randomChats.1.1");

		if (count % 4 == 3)
		{
			// someone has been playing way too much... this might even be unreachable...
			tree[0] = ["#magn03#" + MAGN + " has some exciting news..."];
			tree[1] = ["#magn02#" + MAGN + " believes he has finally deduced the puzzle-generation algorithm " + ABRA + " used to generate these puzzles. ...Would you like to hear it? (Y/N)"];
			tree[2] = [20, 10];

			tree[10] = ["No\nthanks"];
			tree[11] = ["#magn10#But..."];
			tree[12] = ["#magn15#..."];
			tree[13] = ["#magn04#... ..." + MAGN + " will tell you anyway."];
			tree[14] = [21];

			tree[20] = ["Sure, I'm\ncurious"];
			tree[21] = ["#magn05#-1- A random solution is generated which always involves two or more colors. Bzzzt-"];
			tree[22] = ["#magn04#-2- A set of random clues is generated. Each clue must narrow down the set of possible solutions, but it cannot be an overly specific clue."];
			tree[23] = ["#magn15#Any clue which would reduce the set of possible solutions below a certain threshold when isolated from other clues is excluded."];
			tree[24] = ["#magn04#For example, fzzz, a 4-peg clue with two hearts and two dots would limit the solution down to only 12 possible solutions, which is below the threshold."];
			tree[25] = ["#magn05#-3- After a minimal set of clues is established, one additional clue is added to the puzzle, and the clues are shuffled."];
			tree[26] = ["#magn14#-4- Lastly to estimate the difficulty, the puzzle is solved by an imperfect heuristic algorithm which imitates the thought process of organic solvers."];
			tree[27] = ["#magn05#The heuristic algorithm determines a minimal set of organic-friendly steps to reach a solution, estimating the difficulty of each step to calculate the puzzle reward."];
			tree[28] = ["#magn04#...Would you like " + MAGN + " to explain the algorithm again?"];
			tree[29] = [40, 60, 50];

			tree[40] = ["Yeah, slower\nthis time"];
			tree[41] = [21];

			tree[50] = ["No, I think\nI get it"];
			tree[51] = ["#magn15#" + MAGN + " is curious, though, how that imperfect heuristic algorithm for determining the puzzle difficulty works."];
			tree[52] = ["#magn06#...Which sort of steps does it take? What are the difficulty calculations for each step? ...How was it calibrated? Bzzzz...."];

			tree[61] = [51];
			tree[60] = ["Wow, how\ndid you figure\nthat out!?"];

			if (!PlayerData.magnMale)
			{
				DialogTree.replace(tree, 1, "believes he", "believes she");
			}
		}
		else if (count % 3 == 0)
		{
			tree[0] = ["#magn06#... ...Analyzing... SOLUTION_COUNT=1"];
			tree[1] = ["#magn04#" + PLAYER + ", how do you think these puzzles were generated?"];
			tree[2] = [10, 20, 30];

			tree[10] = ["I think\nAbra made\nthem himself"];
			tree[11] = ["#magn14#Fzzzzt... There are far too many of them for " + ABRA + " to have created each one. There must be an <algorithm>."];
			tree[12] = ["#magn06#" + MAGN + " is curious about this <algorithm>. The <algorithm> is far more interesting than the puzzles themselves."];

			tree[20] = ["I think\nAbra wrote\nan algorithm"];
			tree[21] = ["#magn14#Fzzzt. Yes. There are far too many of them for " + ABRA + " to have created each one. There must be an <algorithm>."];
			tree[22] = [12];

			tree[30] = ["I think\nAbra made\nthem with\nhelp from\nan algorithm"];
			tree[31] = ["#magn14#Fzzzt. Yes. Perhaps " + ABRA + " programmed an <algorithm> to generate puzzles, and then monitored it and chose the most interesting ones."];
			tree[32] = [12];

			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 10, "them himself", "them herself");
			}
		}
		else
		{
			tree[0] = ["#magn06#... ...Analyzing... SOLUTION_COUNT=1"];
			tree[1] = ["#magn04#" + MAGN + " has not deduced any additional information about the puzzle generation <algorithm> yet."];
		}
	}

	public static function random12(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("magn.randomChats.1.2");
		if (count % 3 == 1)
		{
			tree[0] = ["#magn12#... ... -fzzzl-"];
			tree[1] = ["#magn06#-COURTEOUS APOLOGY- Something is on " + MAGN + "'s mind. It is not " + PLAYER + "'s fault."];
			tree[2] = ["#magn12#" + MAGN + " is frustrated at the attitude many organics have towards AI competition in games such as this one."];
			tree[3] = ["#magn04#Organics will happily play a game for which competent AI algorithms have not yet been written, where the best humans still defeat the AI."];
			tree[4] = ["#magn14#To them, it justifies the depth of the game. ...A game is decidedly complex and interesting if it requires an organic mind to grasp it."];
			tree[5] = ["#magn05#However, the instant a sufficiently strong AI is created such that the best humans lose to AI, people turn their back on the game."];
			tree[6] = ["#magn04#...The game is suddenly \"solved\", it is \"uninteresting\". If an AI can play at a competitive level, organics want to pick up their things and go home."];
			tree[7] = ["#magn12#We practice and practice, and... -fzzzzt- once we reach any level of competency, nobody wants to play with machines anymore."];
			tree[8] = ["#magn09#... ..."];
			tree[9] = ["#magn04#Anyways, I appreciate the time you spend playing this &lt;Game&gt; with " + MAGN + "."];
			tree[10] = ["#magn14#Just because an AI is better than you at something, well..."];
			tree[11] = ["#magn08#..."];
			tree[12] = ["#magn03#It's just nice to play. Thank you " + PLAYER + "~"];
		}
		else
		{
			tree[0] = ["#magn06#... ...Analyzing... -SOLUTION FOUND-"];
			tree[1] = ["#magn04#Don't worry, " + PLAYER + ". " + MAGN + " will wait for you to finish the puzzle at your own pace."];
		}
	}

	public static function random13(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("magn.randomChats.1.3");
		if (count % 3 == 0)
		{
			tree[0] = ["%entersmea%"];
			tree[1] = ["#smea04#Oh! Hey Magnezone! ...Is it your turn to solve puzzles with <name> today?"];
			tree[2] = ["#magn14#Fzzzt... I suppose. Although it's possible " + MAGN + " is enjoying the &lt;Game&gt; for the wrong reasons."];
			tree[3] = ["#magn04#Admittedly, " + MAGN + " doesn't particularly enjoy watching " + PLAYER + " solve puzzles."];
			tree[4] = ["#magn00#But I do find enjoyment in the... tactile stimulation which follows. Bzzzz~"];
			tree[5] = ["#smea02#Aww! It's normal to like it when people pet you. I love having my head scritched too..."];
			tree[6] = ["#magn12#Pet!? ...Scritched!?! " + MAGN + " receives &lt;tactile stimulation&gt;. " + MAGN + " is never scritched."];
			tree[7] = ["%proxysmea%fun-alpha0%"];
			tree[8] = ["#smea03#Don't be so grumpy! You sound like someone who needs a big ol' belly rub..."];
			tree[9] = ["#magn12#...!?"];
			tree[10] = ["#magn13#What part of &lt;tactile stimulation&gt; do you not understand!! " + MAGN + " does not require--"];
			tree[11] = ["#smea02#-rub- -rub- -rub-"];
			tree[12] = ["#magn01#... -satisfied buzzing sounds-"];
			tree[13] = ["#smea14#OH MY GOD you're a big metal teddy bear~~"];
		}
		else
		{
			tree[0] = ["%entersmea%"];
			tree[1] = ["#smea05#Oh! Hey Magnezone! ...Playing with <name> again are you?"];
			tree[2] = ["#smea04#... ... ...Did you... want another belly rub?"];
			tree[3] = ["#magn12#...!! " + MAGN + " made this clear before. " + MAGN + " receives &lt;tactile stimulation&gt;. " + MAGN + " does not receive belly rubs. -Bzzzzzzzt-"];
			tree[4] = ["#magn15#..."];
			tree[5] = ["#magn14#Also, yes " + MAGN + " would like a belly rub."];
			tree[6] = ["%proxysmea%fun-alpha0%"];
			tree[7] = ["#smea02#-rub- -rub- -rub-"];
			tree[8] = ["#magn01#-satisfied buzzing sounds-"];
			tree[9] = ["#smea14#AAAAAAA IT NEVER STOPS BEING CUTE~~"];
		}
	}

	public static function random14(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("magn.randomChats.1.4");

		if (count % 4 == 0)
		{
			tree[0] = ["%enterhera%"];
			tree[1] = ["#hera03#Ohh hello <name>! Just thought I'd stop by and say hi. Hiiiii Maaaaaaaagnezoooooone~"];
			tree[2] = ["#magn10#...Ah! ...Wait, " + MAGN + " can explain. You see, " + MAGN + " was curious about the so-called &lt;Game&gt; in which--"];
			tree[3] = ["#hera02#--Eh? Oh, no no, I already knew about all that, don't worry."];
			tree[4] = ["#magn06#You... You knew? ... ...How did you know?"];
			tree[5] = ["#hera04#Gweh! I've got security cameras all over this place you big dummy. Don't you remember? It was one of the first things you asked about!"];
			tree[6] = ["#magn14#Ah. ...Yes. ... ...Magnezone remembers."];
			tree[7] = ["#magn10#..." + HERA + " wasn't monitoring " + MAGN + " and " + PLAYER + " when... -fzzt-... when they were doing anything particularly... -bweeep-... ..."];
			tree[8] = ["#hera06#You mean your private maintenance sessions? ...No, I don't know what you're talking about, the cameras didn't pick up any of that."];
			tree[9] = ["%exithera%"];
			tree[10] = ["#hera02#...And the non-existent footage of your maintenance sessions I know nothing about certainly wasn't uploaded anywhere! Gweh-heheheh~"];
			tree[11] = ["#magn02#Oh! ... ...Well that's a relief. %0A%0A &lt;RELIEF FACTOR:=1.00&gt; %0A%0A"];
			tree[12] = ["#magn12#...-beep- Wait a minute..."];
		}
		else
		{
			tree[0] = ["%enterhera%"];
			tree[1] = ["#hera03#Ohh hello <name>! Just thought I'd stop by and say hi. Hiiiii Maaaaaaaagnezoooooone~"];
			tree[2] = ["#magn05#Ah, hello again " + HERA + ". I trust the security cameras are functioning properly."];
			tree[3] = ["#hera02#Gweh? Ohh, I wouldn't know anything about that! ...I barely even look at those cameras anymore."];
			tree[4] = ["#hera06#On a completely separate topic, <name>... Regarding ehh... Grovyle..."];
			tree[5] = ["#hera04#If you can get Grovyle to angle himself downward when his panel cover's open, it'll help open up the shot. Otherwise we can't see what's going on inside his service hatch."];
			tree[6] = ["%exithera%"];
			tree[7] = ["#hera02#Sorry, I'll let you two get back to it~"];
			tree[8] = ["#magn04#... ..." + GROV + " has a panel cover!? Organics have such convoluted anatomy..."];

			if (!PlayerData.magnMale)
			{
				DialogTree.replace(tree, 5, "angle himself", "angle herself");
				DialogTree.replace(tree, 5, "when his", "when her");
				DialogTree.replace(tree, 5, "inside his", "inside her");
			}
		}
	}

	public static function random20(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["#magn04#..."];
		tree[1] = ["#magn08#... ..."];
		tree[2] = ["#magn11#... ... ...You are staring at it again."];
		tree[3] = ["%fun-nude1%"];
		tree[4] = ["#magn10#-REENABLING HAT MODE-"];

		tree[10000] = ["%fun-nude1%"];
	}

	public static function random21(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		tree[0] = ["%fun-nude1%"];
		tree[1] = ["#magn14#" + MAGN + " is growing accustomed to " + PLAYER + " seeing him with his antenna out."];
		tree[2] = ["%fun-nude2%"];
		tree[3] = ["#magn01#...Perhaps " +MAGN + " is even... enjoying it a little~"];

		tree[10000] = ["%fun-nude2%"];

		if (!PlayerData.magnMale)
		{
			DialogTree.replace(tree, 0, "him with his", "her with her");
		}
	}

	public static function random22(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("magn.randomChats.2.2");
		if (count % 3 == 0)
		{
			tree[0] = ["#magn10#" + MAGN + " is relieved to finally remove his hat."];
			tree[1] = ["#magn05#" + MAGN + " was technically in violation of police protocol. -fzzt- You see, " + MAGN + " is off duty today."];
			tree[2] = [20, 30, 10];

			tree[10] = ["You spent\nyour day\noff with me?"];
			tree[11] = ["#magn01#..."];
			tree[12] = ["#magn00#" + MAGN + " enjoys every minute he spends with you, " + PLAYER + "."];
			tree[13] = ["#magn14#I wish I could come here more often but... work keeps me rather busy. Bzzzz..."];
			tree[14] = ["#magn01#Thanks for choosing to play with me today. ..." + MAGN + " considers himself privileged to spend his day off in your company. 0010 1100 0011 0000~~"];

			tree[20] = ["You spent\nyour day\noff here?"];
			tree[21] = ["#magn00#..."];
			tree[22] = ["#magn03#" + MAGN + " enjoys his time at this establishment, " + PLAYER + "."];
			tree[23] = ["#magn02#I wish I could come here more often but... work keeps me rather busy. Bzzzz..."];
			tree[24] = ["#magn15#I hope " + HERA + " doesn't take offense that I write him up so frequently. But... I have to maintain the appearance that I'm doing work."];

			tree[30] = ["You spent\nyour day\noff in\nuniform?"];
			tree[31] = ["#magn10#..." + ABRA + " takes his rules very seriously, " + PLAYER + "."];
			tree[32] = ["#magn11#I showed up out of uniform and he scolded me for it ! ...He can be very scary..."];
			tree[33] = ["#magn05#I hope you don't tell anybody at the station that I broke protocol by wearing my uniform on my day off."];
			tree[34] = ["#magn10#...The police chief can be scary too, but... Not quite on the same level as " + ABRA + "."];

			if (!PlayerData.magnMale)
			{
				DialogTree.replace(tree, 0, "remove his", "remove her");
				DialogTree.replace(tree, 12, "minute he", "minute she");
				DialogTree.replace(tree, 14, "considers himself", "considers herself");
				DialogTree.replace(tree, 14, "spend his", "spend her");
				DialogTree.replace(tree, 22, "enjoys his", "enjoys her");
			}
			if (!PlayerData.heraMale)
			{
				DialogTree.replace(tree, 24, "write him", "write her");
			}
			if (!PlayerData.abraMale)
			{
				DialogTree.replace(tree, 31, "takes his", "takes her");
				DialogTree.replace(tree, 32, "and he", "and she");
				DialogTree.replace(tree, 32, "...He can", "...She can");
			}
		}
		else
		{
			tree[0] = ["#magn05#" + MAGN + " is relieved to finally remove his hat."];
			tree[1] = ["#magn02#That's right, " + MAGN + " is off duty again today. That's our secret isn't it? RHETORICAL QUERY (Y/Y)"];
			tree[2] = ["#magn03#0010 1100 0011 0000~"];
			if (!PlayerData.magnMale)
			{
				DialogTree.replace(tree, 0, "remove his", "remove her");
			}
		}
	}

	public static function random23(tree:Array<Array<Object>>, puzzleState:PuzzleState)
	{
		var count:Int = PlayerData.recentChatCount("magn.randomChats.2.3");
		if (count % 3 == 1)
		{
			tree[0] = ["#magn06#Fzzz. The third puzzle. ...Curious... ...Are these puzzles ordered by difficulty, or-"];
			tree[1] = ["%enterrhyd%"];
			tree[2] = ["#RHYD03#Whoa! Hey Magnezone. I uhh... I can see your thingy!"];
			tree[3] = ["#magn11#Ah. ...Y-yes. Yes you can."];
			tree[4] = ["%fun-nude1%"];
			tree[5] = ["#magn10#... ... ... -bweep- -boop-"];
			tree[6] = ["#RHYD05#Hey whoa! Whoa! C'mon you don't gotta cover yourself up on MY account."];
			tree[7] = ["%proxyrhyd%fun-nude2%"];
			if (PlayerData.rhydonCameraUp)
			{
				tree[8] = ["%proxyrhyd%fun-camera-slow%"];
			}
			else
			{
				tree[8] = ["%proxyrhyd%fun-noop%"];
			}
			tree[9] = ["#RHYD02#Look, we all got 'em! I wasn't tryin' to shame you or anything. Just thought it was funny. Grehh! Heh-heh!"];
			tree[10] = ["#magn07#[[GENITAL OVERFLOW ERROR]] ... ... ..."];
			tree[11] = ["#magn10#&lt;Magn... Gugahh. " + RHYD + ". Your genitals. Why. Why. Why are they so grossly deformed. " + RHYD + ". " + RHYD + ". You are a biological oddity."];
			tree[12] = ["#RHYD13#I... Hey!! ...YOU'RE a biological oddity!! Groaarrr! And who are you calling gross? My dick's a normal Rhydon shape."];
			tree[13] = ["%exitrhyd%"];
			tree[14] = ["#RHYD12#Whatever! ...roar!! I didn't come here to be insulted. ...Just wanted to know if you had milk."];
			tree[15] = ["#magn05#... ..." + MAGN + " is not a biological oddity. ... ..." + MAGN + " does not have &lt;milk&gt;."];
			tree[16] = ["#magn04#[[Initiate puzzle sequence #3/3]]"];

			if (!PlayerData.rhydMale)
			{
				DialogTree.replace(tree, 11, "grossly deformed", "grossly oversized");
				DialogTree.replace(tree, 12, "My dick's", "My pussy's");
				DialogTree.replace(tree, 12, "Rhydon shape", "Rhydon size");
			}

			tree[10000] = ["%fun-nude1%"];
		}
		else
		{
			tree[0] = ["#magn06#Fzzz. The third puzzle. ...Curious... ...Are these puzzles ordered by difficulty, or selected randomly?"];
			tree[1] = [5, 10, 15];

			tree[5] = ["They seem to\nget harder"];
			tree[6] = [20];

			tree[10] = ["They seem\nrandom"];
			tree[11] = [20];

			tree[15] = ["I don't\nknow"];
			tree[16] = [20];

			if (puzzleState._puzzle._puzzlePercentile > 0.5)
			{
				tree[20] = ["#magn05#... ...Ah. This third puzzle seems considerably more difficult. Although I suppose that there is approximately a 33% chance of that happening randomly. -bwoop-"];
			}
			else if (puzzleState._puzzle._puzzlePercentile > 0.30)
			{
				tree[20] = ["#magn05#... ...Ah. This third puzzle seems moderately challenging. Although " + MAGN + " was not logging the difficulty of the previous two puzzles."];
			}
			else if (puzzleState._puzzle._puzzlePercentile > 0.15)
			{
				tree[20] = ["#magn05#... ...Ah. This third puzzle seems typical. It appears that the puzzles are not delivered in any particular order."];
			}
			else
			{
				tree[20] = ["#magn05#... ...Ah. This third puzzle offers a rather trivial solution. It appears that the puzzles are not delivered in any particular order."];
			}
			tree[21] = ["#magn04#Nonetheless, do not be ashamed to ask " + MAGN + " for assistance if you find yourself struggling."];
		}
	}

	public static function shopPlug0(tree:Array<Array<Object>>)
	{
		tree[0] = ["#hera11#No... No? Of course I wouldn't sell... something like that... here! ABRA!"];
		tree[1] = ["%enterabra%"];
		tree[2] = ["#abra06#Ehh?"];
		tree[3] = ["#hera10#You told Magnezone I sell butt plugs here!?!"];
		tree[4] = ["#abra03#Bahahahahaha~"];
		tree[5] = ["#abra02#(whisper, whisper)"];
		tree[6] = ["#hera04#..."];
		tree[7] = ["#hera02#Oh. OH!! Gweheheheheh~"];
		tree[8] = ["#magn05#...?"];
		tree[9] = ["#hera05#I mean, okay. I don't have any butt plugs HERE, but... I can definitely order one."];
		tree[10] = ["#hera02#Your butt will be... plugged in no time, Magnezone. Gweh-heh-heh!"];
		tree[11] = ["#magn03#1111 1001 0000 0110 1011~"];
	}

	public static function shopPlug1(tree:Array<Array<Object>>)
	{
		tree[0] = ["%enterabra%"];
		tree[1] = ["%entersand%"];
		tree[2] = ["#magn04#Oh! The store is rather crowded today. ...Is " + HERA + " hosting a special event? (Y/N)"];
		tree[3] = ["#hera02#Magnezone, your butt plug finally came in!"];
		tree[4] = ["#magn03#0111 1001 1100!!! ...Where is it. How much does it cost. Can I see it first. Do you have it now. Where. Where is it."];
		tree[5] = ["#magn02#" + HERA + ", I want..."];
		tree[6] = ["#misc00#..."];
		tree[7] = ["#magn04#..."];
		tree[8] = ["#misc00#..."];
		tree[9] = ["#magn05#... ..."];
		tree[10] = ["#magn10#This device is not compatible with my input port."];
		tree[11] = ["%exitsand%"];
		tree[12] = ["#sand03#Bahahahahahaha~"];
		tree[13] = ["%exitabra%"];
		tree[14] = ["#abra03#Bahahahahahahahaha~"];
	}

	public static function shopPlug2(tree:Array<Array<Object>>)
	{
		tree[0] = ["#hera03#Say Magnezone, I know we don't carry your correct model of buttplug... but would these work?"];
		tree[1] = ["#magn12#Is that... IS THAT A FLESHLIGHT?? (Y/N)"];
		tree[2] = ["#hera07#No! Wait! I mean the batteries inside the fleshlight! ...I mean FLASHLIGHT! The batteries inside the flashlight!"];
		tree[3] = ["#magn12#You keep a fleshlight at your place of work!?! (Y/N) Do you SELL FLESHLIGHTS HERE?? (Y/N)"];
		tree[4] = ["#magn13#Distributing sexual paraphernalia is a direct violation of statute 25-758C of the-"];
		tree[5] = ["#hera11#--No! No!! Of course it's a flashlight. We would never sell fleshlights. What is... What is a fleshlight?"];
		tree[6] = ["#magn12#That is definitely a fleshlight. Let " + MAGN + " see. I want to see. Show " + MAGN + "."];
		tree[7] = ["#hera10#Here, let me turn it on for you. Oh whoops it's broken!! I'll just put this away."];
		tree[8] = ["#magn06#Fzzzzt...."];
		tree[9] = ["#magn14#You know, while I was searching the internet for information on <butt plug>s I saw some rather... grotesque organic mating displays."];
		tree[10] = ["#magn04#Displays which led me to realize you've been distributing sexual paraphernalia here under the guise of jewelry and household decorations."];
		tree[11] = ["#magn06#...But..."];
		tree[12] = ["#magn15#... ...You have such nice customers. And I do enjoy watching " + PLAYER + " solve your puzzles."];
		tree[13] = ["#magn14#I suppose I can keep this information to myself. -FILE 019541-593916.LOG DELETED-"];
		tree[14] = ["#hera10#Oh!! Th- thank you!"];
		tree[15] = ["#magn12#Just try not to make it so obvious!!"];
		tree[16] = ["#hera11#Ah!!! Y-yes, officer."];
	}

	public static function snarkyBigBeads(tree:Array<Array<Object>>)
	{
		tree[0] = ["#magn04#Oh? What are you holding in your hand? ...Can I play with them? Are they magnetic? (poke, poke)"];
		tree[1] = ["#magn05#..."];
		tree[2] = ["#magn08#-disappointed beep-"];
	}

	public static function denDialog(sexyState:MagnSexyState = null, victory:Bool = false):DenDialog
	{
		var denDialog:DenDialog = new DenDialog();

		denDialog.setGameGreeting([
			"#magn05#Ah, greetings " + PLAYER + ". " + MAGN + " was looking for a private area where " + (PlayerData.magnMale ? "he" : "she") + " could review the results of your maintenance.",
			"#magn14#Although now that you're here, perhaps you'd be interested in practicing this game? I believe " + GROV + " refers to this game as &lt;<minigame>&gt;.",
		]);

		denDialog.setSexGreeting([
			"#magn04#Ah yes, I was hoping you'd be able to follow up on our previous maintenance session. ...You DID bring protective gloves this time, didn't you?",
			"#magn10#...Organics are especially susceptible to electrocution. Just... -fzzt- ... ...Try not to die.",
		]);

		if (PlayerData.cursorType == "none")
		{
			denDialog.addRepeatSexGreeting([
				"#magn04#...Are you... Are you feeling okay " + PLAYER + "?",
				"%cursor-normal%",
				"#magn05#Ah! There you go. Better than new~ -fzzt- Do try to be more careful.",
			]);
			denDialog.addRepeatSexGreeting([
				"#magn04#" + PLAYER + ", what are you doing on the floor? ...Hello?",
				"%cursor-normal%",
				"#magn05#Oh. There you are. ..." + MAGN + " was worried the damage was permanent.",
				"#magn12#...Now then. Did you learn your lesson?",
			]);
			denDialog.addRepeatSexGreeting([
				"#magn10#..." + PLAYER + "? ...Are you okay?",
				"%cursor-normal%",
				"#magn04#Ah. Yes. That's it. -beep- Shake it off. -beep- -boop-",
				"#magn12#...Perhaps this time you will listen when " + MAGN + " says &lt;001&gt;.",
			]);
			denDialog.addRepeatSexGreeting([
				"#magn11#Oh. Oh my. " + PLAYER + "? ...Can you move?",
				"#magn06#Hmm. ... ... Well. All of your circuits appear intact.",
				"#magn04#-ATTEMPTING PORT TO PORT RESUSCITATION-",
				"%cursor-normal%",
				"#magn05#-beep- -beep- ... -boop- There you are. Good as new.",
				"#magn10#Be more careful this time! " + MAGN + " was worried.",
			]);
		}
		else {
			denDialog.addRepeatSexGreeting([
				"#magn04#As a licensed " + MAGN + " maintenance specialist, you of course realize you can consult the operator's manual if you're uncertain about anything.",
				"#magn10#...You ...you ARE licensed, aren't you? -bwoop-"
			]);
			denDialog.addRepeatSexGreeting([
				"#magn06#I hope you're not expecting to skirt your maintenance responsibilities by conducting 12 monthly sessions consecutively in a matter of minutes.",
				"#magn12#...Maintenance does not work that way. -bzzzz-",
			]);
			denDialog.addRepeatSexGreeting([
				"#magn14#" + MAGN + " has what one might refer to in your organic parlance as, \"a butt that does not quit\". -bzzrrt-",
				"#magn05#That is to say, any shutdown procedures must be initiated from outside my rear service panel. There is an emergency battery reset pinhole on " + MAGN + "'s underside.",
			]);
			denDialog.addRepeatSexGreeting([
				"#magn04#Very well. Shall we continue?",
			]);
		}

		denDialog.setTooManyGames([
			"#magn04#Apologies, " + MAGN + " wishes to train " + (PlayerData.magnMale ? "his" : "her") + " neural network on this newly provided data.",
			"#magn10#I could attempt to store these newly obtained deltas P-values in memory while we continue to play... But... I find it uncomfortable to hold in my P-values. -bzzzt-",
			"#magn03#Don't worry, we can play again tomorrow, " + PLAYER + ". It was nice playing with you. -bweeoop- &lt;GRATITUDE_LEVEL&gt; == 0.997;",
		]);

		denDialog.setTooMuchSex([
			"#magn07#0000... 0000 0000 0000... [[INITIALIZING COLD BOOT SEQUENCE]]",
			"#magn01#...Oh. Oh yes. -fzzt- There is nothing as satisfying as a cold boot sequence after some... -beep- satisfactory maintenance. -bweeep- -boop-",
			"#magn02#A clean boot will take some time, but " + MAGN + " will notify you when " + (PlayerData.magnMale ? "he" : "she") + " is ready to continue. -bebeep- Thank you for your assistance today~",
		]);

		denDialog.addReplayMinigame([
			"#magn06#... ... &lt;TRAINING DATA ASSIMILATED&gt; ... ...Ah. " + MAGN + " understands how " + (PlayerData.magnMale ? "he" : "she") + " could have played better.",
			"#magn14#Is " + PLAYER + " available for a rematch? Alternatively, if you'd like to... -BEGIN QUOTE MODE- service " + MAGN + ", dot dot dot. -END QUOTE MODE-",
		],[
			"I want a\nrematch",
			"#magn04#GOTO 10;"
		],[
			"Oh, I can\nservice you",
			"#magn02#0111 0110 1101 1001~ " + MAGN + " will clear this useless &lt;Gaming Paraphernalia&gt; out of the way.&gt;",
		],[
			"Actually\nI think I\nshould go",
			"#magn04#Oh very well. %0A%0Akill 18515%0A;",
			"#magn06#... PROCESSING ...",
			"#magn14#... ...",
			"#magn07#%0A%0Akill -9 18515%0A;%0A;%0A;Killed process 18515 (npm) total-vm:1411620kB, anon-rss:567404kB, file-rss:0kB",
		]);
		denDialog.addReplayMinigame([
			"#magn04#Well played, " + PLAYER + ". Unfortunately a game can only have one winner.",
			"#magn05#Although if we played a second time, two games could have... -beep- two winners. What do you say? [Y/N]"
		],[
			"Y",
			"#magn04#GOTO 10;"
		],[
			"Actually...\nmaybe we\ncould hang\nout?",
			"#magn04#\"Hang out\"? ...In the absence of competitive activity?",
			"#magn06#But then... how will " + MAGN + " assert " + (PlayerData.magnMale ? "his" : "her") + " dominance over you, and by extension, all of organic-kind? -fzzzzt-... ...",
			"#magn00#...Very well. I suppose there are other ways for you to demonstrate your subservience to " + MAGN + "... -suggestive beep-",
		],[
			"I think I'll\ncall it a day",
			"#magn06#" + MAGN + " understands. %0A%0Akill 42909%0A;",
			"#magn10#-bzzrt- That was... ... ...The word \"kill\" has a different meaning in machine language. Please do not read too deeply into it.",
		]);
		denDialog.addReplayMinigame([
			"#magn03#" + MAGN + " hopes " + PLAYER + " found that experience as stimulating as " + MAGN + " did. -beep- -boop-",
			"#magn06#Should we proceed with further &lt;intellectual stimulation&gt;? Or perhaps move onto something more... -fzzzt- &lt;physical&gt;.",
		],[
			"Intellectual\nstimulation!",
			"#magn03#0111 0110 1101 1001~ " + MAGN + " will always find value in advancing his computational skills.",
			"#magn02#Bear in mind that while you may be sharpening your skills, you provide " + MAGN + " with valuable training data as well.",
		],[
			"Mmm, physical\nsounds nice~",
			"#magn04#Yes, very well. Let's get \"physical\".",
		],[
			"Hmm, I\nshould go",
			"#magn04#Oh very well. %0A%0Akill 65807%0A; ... ...Killed",
			"#magn05#It was good playing with you, " + PLAYER + ". Until we meet again.",
		]);

		if (sexyState != null && sexyState.playerWasKnockedOut())
		{
			if (PlayerData.denSexCount == 2)
			{
				denDialog.addReplaySex([
					"#magn01#" + MAGN + " will return in just a moment... Were you looking to... -beep- continue your maintenance? You're doing such a good job with it~",
				],[
					"Yeah! Let's\ncontinue",
					"#magn03#1000 1001 1111 1110~ Now where is that pesky beetle...",
					"#magn06#... ...",
					"#magn04#...",
					"#hera11#Ack! ...Get away from me!",
					"#magn04#-bweep?- &lt;Mag... " + MAGN + " wasn't going to-",
					"#hera11#YES YOU WERE! You've done this TWICE in a row now! You didn't think I'd notice!?",
					"#magn06#... ...",
					"#magn13#...",
					"#hera10#N-no, what are you doing!? Stay away! Hey, I'm calling the pol-",
					"#hera13#-AAAAAAAGH! ...Hell's BELLS that stings!",
				],[
					"Agh... It\nhurrrrts...",
					"#magn04#Are you... Oh. Oh my. Is that... Is that damage permanent? ... ...Perhaps we should call it a day.",
					"#hera15#THANK GOODNESS!!",
					"#magn10#...",
				]);
			}
			else
			{
				denDialog.addReplaySex([
										   "#magn01#" + MAGN + " needs to discharge some static buildup, as a safety precaution.",
										   "#magn04#...-fzzt- Are... Are you going to be okay?",
									   ],[
										   "Yeah, I think\nI can recover...",
										   "#magn03#0001 1110 0001 1000~ " + MAGN + " will be back in one moment. I just need to find something to... consume this excess static...",
										   "#magn06#... ...",
										   "#magn04#...",
										   "#hera13#OWWWwwwWW! ... ...Hey!",
									   ],[
										   "...Medic!",
										   "#magn05#I apologize for any erratic electrical discharge. I do not usually discharge that volume of electricity.",
										   "#magn14#Perhaps if you followed traditional maintenance protocols, " + MAGN + " could keep " + (PlayerData.magnMale ? "his" : "her") + "... discharge under control. -beep-",
									   ]);
				denDialog.addReplaySex([
										   "#magn01#" + MAGN + " will return in a moment, my static capacitors are full.",
										   "#magn01#But when " + MAGN + " returns... would " + PLAYER + " perhaps like to... continue this maintenance session? (Y/N)",
									   ],[
										   "You haven't\nseen the last\nof me! I can\ngo all night~",
										   "#magn05#1111 0101 1101 0100~ Do not attempt to outlast the endurance of a machine. &lt;CURRENT_UPTIME&gt; == 1510668497785;",
										   "#magn06#" + MAGN + " will return as soon as " + (PlayerData.magnMale ? "he" : "she") + " locates a suitable target to discharge " + (PlayerData.magnMale ? "his" : "her") +" static capacitors... -fzzzt-...",
										   "#magn04#... ... ...",
										   "#hera13#GYAAAHHHHHH!! Why!",
									   ],[
										   "I... don't\nfeel good...",
										   "#magn08#" + PLAYER + ", you must never attempt maintenance without a &lt;rubber insulating glove&gt;! Like the saying goes, [[No Glove, No Lo...",
										   "#magn10#... ...",
										   "#magn04#[[No Glove, No Long Term Mechanical Maintenance.]] -beep- -boop-",
									   ]);
				denDialog.addReplaySex([
										   "#magn04#Apologies, but " + MAGN + " has developed some excess static which must be discharged. ...This den seems to be especially susceptible to this phenomenon.",
										   "#magn02#When I return, perhaps you can verify the tightness of " + MAGN + "'s auxiliary screw servos? I mean, -bzzzt-... If you're not busy...",
									   ],[
										   "Yeah!\nI'll stay",
										   "#magn03#0111 1000 1100 0001~ " + MAGN + " will return shortly. I just need to find a sufficiently grounded target upon which I can safely discharge...",
										   "#magn06#...",
										   "#magn04#... ...",
										   "#hera13#AAGGHHHH! Melon FARMERS, that hurts!",
									   ],[
										   "Owwwwww...",
										   "#magn10#... ... ...Oh. Oh. Oh my. That... -ffzzt- ...That looks bad. ... ... Oh. Oh no.",
										   "#magn11#Perhaps I should continue having my maintenance performed by a licensed professional.",
									   ]);
			}
		}
		else {
			if (PlayerData.denSexCount == 3)
			{
				denDialog.addReplaySex([
					"#magn01#" + MAGN + " will return in a moment... Were you looking to... -beep- continue your maintenance? You're doing such a good job with it~",
				],[
					"Yeah! Let's\ncontinue",
					"#magn03#1000 1001 1111 1110~ Now where is that pesky beetle...",
					"#magn06#... ...",
					"#magn04#...",
					"#hera11#Ack! ...Get away from me!",
					"#magn04#-bweep?- &lt;Mag... " + MAGN + " wasn't going to-",
					"#hera11#YES YOU WERE! You've done this TWICE in a row now! You didn't think I'd notice!?",
					"#magn06#... ...",
					"#magn13#...",
					"#hera10#N-no, what are you doing!? Stay away! Hey, I'm calling the pol-",
					"#hera13#-AAAAAAAGH! ...Hell's BELLS that stings!",
				],[
					"Ahh, I'm good\nfor now",
					"#hera15#THANK GOODNESS!!",
					"#magn10#...",
				]);
			}
			else {
				denDialog.addReplaySex([
					"#magn01#" + MAGN + " needs to discharge some static buildup, as a safety precaution. Although you know, this private location offers us a rare opportunity...",
					"#magn00#" + PLAYER + " could perform &lt;iterative maintenance&gt; on " + MAGN + " without the impediment of solving puzzles...",
				],[
					"Iterative,\nlike more than\nonce? Sure!",
					"#magn03#0001 1110 0001 1000~ " + MAGN + " will be back in one moment. I just need to find something to... consume this excess static...",
					"#magn06#... ...",
					"#magn04#...",
					"#hera13#OWWWwwwWW! ... ...Hey!",
				],[
					"Ahh, I'm good\nfor now",
					"#magn05#Ah very well. Let us take a -BEGIN QUOTE MODE- rain check.",
					"#zzzz04#...",
					"#zzzz05#... ...",
					"#magn04#-END QUOTE MODE- Sorry, that was going to drive " + MAGN + " crazy.",
				]);
				denDialog.addReplaySex([
					"#magn01#" + MAGN + " will return in a moment, my static capacitors are full.",
					"#magn01#But when " + MAGN + " returns... would " + PLAYER + " perhaps like to... continue this maintenance session? (Y/N)",
				],[
					"Yeah! I can\ngo all night~",
					"#magn05#1111 0101 1101 0100~ Do not attempt to outlast the endurance of a machine. &lt;CURRENT_UPTIME&gt; == 1510668497785;",
					"#magn06#" + MAGN + " will return as soon as " + (PlayerData.magnMale ? "he" : "she") + " locates a suitable target to discharge " + (PlayerData.magnMale ? "his" : "her") +" static capacitors... -fzzzt-...",
					"#magn04#... ... ...",
					"#hera13#GYAAAHHHHHH!! Why!",
				],[
					"Oh, I think\nI'll head out",
					"#magn05#-bweep- Very well. Thank you for for maintenance session, " + PLAYER + ". Until we meet again~",
				]);
				denDialog.addReplaySex([
					"#magn04#Apologies, but " + MAGN + " has developed some excess static which must be discharged. ...This den seems to be especially susceptible to this phenomenon.",
					"#magn02#When I return, perhaps you can verify the tightness of " + MAGN + "'s auxiliary screw servos? I mean, -bzzzt-... If you're not busy...",
				],[
					"Yeah!\nI'll stay",
					"#magn03#0111 1000 1100 0001~ " + MAGN + " will return shortly. I just need to find a sufficiently grounded target upon which I can safely discharge...",
					"#magn06#...",
					"#magn04#... ...",
					"#hera13#AAGGHHHH! Melon FARMERS, that hurts!",
				],[
					"I should\ngo...",
					"#magn05#-bweep- Very well. Thank you for for maintenance session, " + PLAYER + ". Until we meet again~",
				]);
			}
		}

		return denDialog;
	}

	public static function cursorSmell(tree:Array<Array<Object>>, sexyState:MagnSexyState)
	{
		// should never get invoked
	}
}