================================================================================
1. Building Monster Mind

This project is written in HaxeFlixel which takes some work to setup.

1. Install Haxe. I am using 3.4.1, you can find the latest version at https://haxe.org/download/

2. Install HaxeFlixel. Open a command prompt and run the following commands:

   haxelib install lime
   haxelib install openfl
   haxelib install flixel
   haxelib run lime setup flixel
   haxelib run lime setup
   haxelib install flixel-tools
   
   This will retrieve a lot of libraries for openfl, flixel, and other things.
   Here is a list of the libraries I am currently using, alongside their
   versions. You can obtain your own list by running 'haxelib list':

   actuate: 1.8.9 [1.9.0]
   box2d: [1.2.3]
   flixel-addons: 2.9.0 2.10.0 2.11.0 [3.1.1]
   flixel-demos: 2.7.3 2.7.4 2.8.0 [2.9.0]
   flixel-templates: 2.6.5 [2.6.6]
   flixel-tools: 1.4.4 [1.5.1]
   flixel-ui: 2.3.3 2.4.0 [2.5.0]
   flixel: 4.8.1 4.9.0 4.10.0 [5.3.1]
   format: [3.5.0]
   hashlink: git [dev:C:\HaxeToolkit\haxe\lib\hashlink/git/other/haxelib/]
   haxelib: [4.1.0]
   hscript: 2.4.0 [2.5.0]
   hxcpp-debug-server: 1.2.4 [dev:c:\Users\aaron\.vscode\extensions\vshaxe.hxcpp-debugger-1.2.4\hxcpp-debug-server]
   hxcpp: 4.2.1 [4.3.2]
   hxp: [1.2.2]
   layout: [1.2.1]
   lime-samples: [7.0.0]
   lime: 7.8.0 7.9.0 [8.0.1] git
   openfl-samples: [8.7.0]
   openfl: 9.0.2 9.1.0 [9.2.1] git
   systools: [1.1.0]

3. Install an IDE. I am using HaxeDevelop but your IDE shouldn't matter very much.

   With your IDE configured and Flixel installed, you should be able to run a
   simple hello world program like the one here:

   https://haxeflixel.com/documentation/hello-world/

If that all works, you should be able to build the MonsterMind SWF for Flash.

================================================================================
2. Fixing Monster Mind for other platforms

2.1 Windows

Haxe supports many alternate platforms such as HTML5, Windows, Android and iOS.
With the help of one of my fans I have gotten the Windows stuff sort of working,
so you will be able to launch the game in Windows. But, there are many problems.

 - The game takes about 10-20 seconds to transition between screens
 - Spotlights look strange; Windows doesn't seem to support BlendMode.MULTIPLY
   correctly
 - There are many rendering issues related to pixel manipulation. For example,
   jizz is invisible and dialog choices don't invert colors when you select
   them. Flash renders things in memory where I can mess with the Pixels.
   Windows renders things at the hardware level so pixels are often
   inaccessible, and we will need to handle this logic differently.

   WhiteGroup and BlackGroup have been rewritten to be windows-friendly.
   BlobbyGroup has not. There are some "TODO" comments in a few other places
   which I noticed will need to be rewritten.

2.2 Android

Building Haxe for Android is more finicky than the other platforms, as it
requires specific versions of the relevant SDKs and a fix to the build
parameters for hxcpp that cause it not to compile.
  - Follow the Haxe installation instructions from section 1 above. Make sure
   your command line is set somewhere with user privileges before starting,
   and especially not system32. Use 'pushd [DIR]' on Windows or 'cd [DIR]' on
   linux to do so.
  - Install Android SDK.
   Remember the installation directory for later.
  - Install Android NDK (native devkit) version r15c specifically, versions
   past this appear to be incompatible as they don't include a needed
   header file.
   Remember the installation directory for later.
  - Install OpenJDK 11, it's available from adoptopenjdk.net or other websites.
   Remember the installation directory for later.
  - After the steps from section 1, run the command 'lime setup android'
   you will be prompted for the three directories you just installed. Paste
   them as prompted to set up the compile environment.
  - If you try to compile now, you might get an error about for loops and 
   c11 or c99, we need to follow this fix:
   https://github.com/HaxeFoundation/hxcpp/pull/1042/files
  - Navigate to your haxeflixel installation and find these two files:
   ./haxe/lib/hxcpp/[VERSION]/src/hx/libs/regexp/pcre2_sources.xml
   ./haxe/lib/hxcpp/[VERSION]/toolchain/linux-toolchain.xml
  - In pcre2_sources.xml:
   add this as line 6:
   <compilerflag value="-std=c99" unless="MSVC_VER" />
   save the file (this is why we need user privileges)
  - In linux-toolchain.xml:
   remove line 44, it reads:
   <cflag value="-std=gnu99" unless="HXCPP_NO_GNU99" />
   save the file
  - Navigate to the monster mind source using a command line and run
   'lime build android'. It should compile successfully now, assuming there
   isn't anything else wrong.
  

================================================================================
3. Browsing the Source Code

There's too much source code to talk about, but here are a few starting points.

/source/Main.hx -- This is the main entry point to the game, which initializes
  the game's resources and state. This is where you might enable a global cheat
  flag or give the player $10,000,000 or something like that.
/source/MainMenuState.hx -- This is the main menu, where Abra shows up and
  where you navigate to different puzzles, tutorials, and the shop.
/source/puzzle/PuzzleState.hx -- This is the code for the main puzzles. This is
  where you might add a way to skip puzzles or make them easier.
/source/poke/luca/LucarioSexyState.hx -- This is the code for Lucario's sex
  scene. This is where you might make Lucario more sensitive or let her play
  with other toys.
/source/poke/luca/LucarioDialog.hx -- This is all of Lucario's dialog for the
  puzzles, minigames, sex scenes, and everything. This is where you might add
  new dialog sequences or change her personality.
/source/ItemDatabase.hx -- This is the data for all of the items in the game.
  This is where you might make all of the items cheaper or add a new item of
  your own.

I apologize for the syntactic inconsistencies. Haxe seems to encourage lower-case
parameter names and Flixel seems to encourage upper-case parameter names. Flixel
likes prefixing its fields with underscores sometimes but not always. I tried my
best to imitate the style of the code I was touching, but it was really hard to
stay consistent. If you want to fix it you have my blessing

================================================================================
4. Adding your own Pokemon

I think a lot of people will want to add their own Pokemon. Adding your own
Pokemon is hard, but here are the steps involved for those of you who are up to
the task.

4.1 Make the character show up on the main menu.

  Each Pokemon has a specific index in PlayerData.hx; Abra is #0 and Grovyle is
  #3. The basic six pokemon show up on the main menu because they are
  enumerated in LevelIntroDialog.professorPermutations. Other pokemon show up
  because they are appended into PlayerData.luckyProfSchedules (the list of
  super-rare Pokemon friends who show up) by
  PlayerDataNormalizer.normalizeLuckyProfScheduels().

  Don't worry about what the button looks like yet. You can screen-cap it later
  once the art is done.

4.2 Draw the basic non-sexy Pokemon art

4.2.1 Draw the clothed/half-clothed/unclothed art

  For the Pokemon to strip, you'll need to draw all three levels of undress.
  You'll want to create a PokeWindow class which has your art assets as
  FlxSprite objects. Look at something like BuizelWindow as an example.

4.2.2 Animate the Pokemon during the puzzle sequences

  The Pokemon should blink periodically, and cheer when you beat a level.

4.2.3 Draw the dialog faces

  The Pokemon should have at least 14 different facial expressions. It's not
  important which is which, although if you want to be consistent with the
  other Pokemon, I adopted this convention:

  [0]  = horny
  [1]  = very horny
  [2]  = happy
  [3]  = very happy
  [4]  = neutral
  [5]  = neutral
  [6]  = thinking
  [7]  = confused
  [8]  = sad
  [9]  = very sad
  [10] = frightened
  [11] = very frightened
  [12] = angry
  [13] = very angry

4.3 Write the dialog

  Your dialog will go in its own dialog class, similar to BuizelDialog. The field
  names and method names follow a convention, so you will eventually need a
  fixedChats field for story dialog, a randomChats field for non-story dialog, a
  help() method for help dialog, and so on.

4.3.1 First-time dialog

  Your pokemon should have something special they say when they meet the player --
  this will be the first entry in the fixedChats array. For BuizelDialog, this is
  the "goFromThere" method.

4.3.2 Additional one-time dialog

  Your pokemon should have one or two other dialog events which will only happen
  once -- usually pivotal conversations which establish the character.
  Conversations which would be weird if they happened twice. For Buizel, these
  are the "waterShorts", "ruralUpbringing" and "movingAway" methods.

4.3.3 "Filler dialog"

  Your pokemon should have about ten or other trivial conversations --
  conversations which would be fine if they happened multiple times. You can
  have conditional logic so the conversations change if they come up
  repeatedly. For Buizel, these are the "random00", "random01", "random02"...
  methods.

  You can see Buizel's "random13" method has a branch in logic so he'll
  sometimes be interrupted by Rhydon barging down the stairs to pick up a
  pizza. But, most of the time he'll just chill out and give you a compliment.

  One of these conversations should probably reference the Player's rank.

4.3.4 Help dialog

  Your Pokemon needs to respond if the player clicks the help button. Look at
  BuizelDialog's "help" method as a template.

4.3.5 Wrong answer dialog

  Your Pokemon needs to respond if the player messes up a puzzle answer. Look
  at BuizelDialog's "clueBad" method as a template.

4.3.6 Bonus game dialog

  Your Pokemon needs to respond when the player finds a bonus coin. He also
  needs to talk about the game like asking the player if he wants to play, and
  saying things when he starts winning or losing.

  The minigames have their own menu button, so make sure you define a
  minigameHelp() method as well.

4.3.7 2-person dialog

  Usually your Pokemon will talk to the player, but sometimes they'll talk to
  other Pokemon too. Look at BuizelDialog's random12() method for a
  conversation where Rhydon barges in. Notice that the getUnlockedChats()
  defines buiz.randomChats.1.2 as false if Rhydon hasn't been met yet. We don't
  want the player randomly bumping into Rhydon for the first time during one of
  Buizel's puzzles.

  Also, don't forget to make your Pokemon show up during other Pokemon's
  puzzles. Maybe the player will be playing with Magnezone, and your Pokemon
  will randomly show up.

4.3.8 Den dialog

  After playing with your Pokemon, the player can go to the den and play with
  them more. This has special dialog, so make sure you don't forget anything.
  Look at BuizelDialog's denDialog() method as a template:

4.3.8.1 "too many minigames" den dialog
4.3.8.2 "too much sex" den dialog
4.3.8.3 "let's play again" den dialog x 3
4.3.8.4 "let's have sex again" den dialog x 3

4.4 Bonus game behavior

  Your Pokemon will be good or bad at different games. Look at the
  ScaleAgentDatabase.hx, StairAgentDatabase.hx, and TugAgentDatabase.hx and tweak
  some variables to give your Pokemon his own personality. You can make them faster
  or slower, smarter or dumber, more impulsive or more hesitant, things like that.

4.5 Sex scene

  You'll want to extend the SexyState class; use BuizelSexyState as a
  reference. Your new SexyState will use a PokeWindow instance, but do extra
  things with it and manipulate extra sprites, things like that.

4.5.1 Make your pokemon able to shift their arms and legs
4.5.2 Add about 20 different facial expressions

  Pokemon go through 5 different states, from 0 (not aroused) to 4 (fully
  aroused). Make sure your Pokemon has a few different facial expressions for
  each state.

4.5.3 Add Pokemon interactions
4.5.3.1 Rubbing flaccid dick
4.5.3.2 Jerking off your Pokemon
4.5.3.3 Rubbing their balls
4.5.3.4 Fingering their asshole
4.5.3.5 Additional Pokemon interactions x 2

  Some Pokemon let you rub their feet, or squeeze their pecs, or fondle their
  inner tube or rub their head floof. There's no limit really, but it's good
  to have at least six things.

  You may want to use the SexyDebugState to get some of these clicking behaviors
  right. For example, you might only want to trigger the asshole-fingering
  animation if you click inside a certain region on their torso. BuizelSexyState
  defines an "assPolyArray" field for this, with a bunch of coordinates. These
  magic numbers can be spat out by SexyDebugState.

  Change SexyDebugState to extend your newly defined SexyState. The controls are
  described in a class-level comment; you'll want to click, use the bracket keys,
  and hit enter and escape.
  

4.5.4 Make your Pokemon ejaculate

  You'll want to use the SexyDebugState to get the angles on this right. You'll
  want the cum stream to come out from the correct angle and position regardless
  of whether your Pokemon is flaccid or erect, or whether the player is touching
  their cock or not. Use SexyDebugState to cycle through the different cock
  frames, and define a vector for the cum. You can press P to enable/disable the
  cum stream.

  A cum vector can be defined by a triangle, if you want more of a spray effect
  rather than a straight line.

4.5.5 Make your pokemon say things during sex

  Look at how BuizelDialog defines its encouragementWords, pleasureWords,
  boredWords, orgasmWords and warningWords. These are drawn as transparent PNGs.

4.5.6 Make your pokemon able to emit sweat

  Define a few sweatAreas. You can test this functionality in debug mode by
  hitting the "X" key. The polygons can be exported from SexyDebugState.

4.5.7 Make your pokemon able to emit breath

  This works similar to the cum vectors -- just cycle through the facial
  expressions and define a breath vector for each facial expression. Then
  export the vectors to your SexyState. The "P" key will also emit a breath
  poof for testing.

4.5.8 Define your Pokemon's behavior

  Your Pokemon should have things they like and dislike. All of the existing
  Pokemon are a puzzle in themselves. They all have things they like and dislike,
  but they don't like the same thing every time. Sometimes they might want their
  feet rubbed, but sometimes they might get sick of it. Sometimes they're
  especially sensitive and need you to back off, or sometimes they're more
  welcoming. Reading their cues gets you greater rewards.

4.5.8.1 Add rules for emitting hearts

  Most Pokemon have 3 things they will especially like, which multiply the rewards
  for that session, and 2 things they especially hate, which diminish the rewards
  for that session. Buizel hates having his tube rubbed, but loves if you explore
  his body before touching his cock.

  Additionally, Pokemon will have other things they like or dislike in a more
  subtle way. Buizel emits very few hearts when you stick one of your fingers in
  his butt, but a ton of hearts when he loosens up and you get more fingers in
  there. Look at his handleRubReward() method and use it for inspiration.

4.5.8.2 Add visual cues for emitting hearts

  Give the player some clues for what your Pokemon likes and dislikes. This can
  be in the form of words, sound effects, their pose, their facial expression,
  or the amount of sweat and precum they emit.

4.5.9 Define your Pokemon's sound effects

  I got all of my sound effects from Pokemon Fire Red/Leaf Green. I stretched and
  distorted the sounds in Reaper, modifying the pitch, duration and other qualities.
  You'll want about ten; some short, some medium-length, some long.

  You'll also want to make a special chat sound. I just took this from the Pokemon
  cry, and taking a tiny slice out of it.

4.5.10 Add the dialog for before/after sex

  The first entry in the sexyBeforeChats array in your dialog class will be used
  when the player first has sex with your Pokemon. You might want to make it unique.

  The remaining entries in the sexyBeforeChats will define the things your Pokemon
  says before sex, and the entries in sexyAfterChats will define the things your
  Pokemon says after sex.

  You should also define 3-4 things your Pokemon says when the player made mistakes
  last time. Either hints about things the player overlooked, or things the player
  did which the Pokemon didn't like. This is defined by overriding the
  computeChatComplaints() method in your SexyState, so that it returns integer
  indexes into your Dialog.sexyBeforeBad array.

  You should also define 2-3 things your Pokemon says when the player does
  everything right. This goes into your Dialog.sexyAfterGood field.

4.6 Add the main menu button

  You should just be able to screencap your PokeWindow and scale it.

4.7 Create a female version of the character as well

4.7.1 Female dialog faces
4.7.2 Different clothes
4.7.3 Different full-size facial expressions
4.7.4 Female dialog tweaks (he/she, cock/vagina, etc) (also for player's gender)
4.7.5 New female animations
4.7.5.1 Gently rubbing vagina
4.7.5.2 Vigorously rubbing vagina
4.7.5.3 Vagina squishes when fingering ass
4.7.6 Different female ejaculations/reward structure for sex scene

  Since female characters have internal genitals, there's usually a little bit
  less to do, so they only have 2 things they especially like. If you end up
  having 3, just double-check that the math in doNiceThing() works out so both
  genders give comparable rewards when the player plays perfectly

4.7.7 Different main menu buttons
4.7.8 BUOYS/GIRLS code should work, state should save

  With cheats enabled, you should be able to type BUOYS to change the characters
  to boys, GIRLS to change the characters to girls, and your new character's
  gender should persist to the player's save data.

  This infrastructure is already in place, but you want to make sure you're
  setting and storing your various PlayerData and PlayerSave variables appropriately

4.7.9 Gender should toggle in items menu
4.7.10 Lucky item to make your character appear more
4.7.11 Sex toy sequence

  All Pokemon are compatible with 1-2 sex toys. For example, Buizel is compatible
  with the blue dildo and the gummy dildo.

4.7.11.1 Add basic graphics

  Just like when creating your PokeWindow, if your Pokemon is in a new pose,
  you'll want to redraw the character in that new pose and have them blinking
  and moving a little

4.7.11.2 Add interface

  Add a way for the player to interact with the scene; for Buizel this is with
  that window on the left.

4.7.11.3 Add animations
4.7.11.4 Make your Pokemon able to react during the toy scene

  Just like with the main sex scene, you'll want your Pokemon able to emit words,
  precum, sweat, breath poofs, and to change their pose or facial expression.

4.7.11.4 Add rules for emitting hearts
4.7.11.5 Add cues for emitting hearts

  Just like with the main sex scene, you'll want to have special ways your Pokemon
  does and doesn't like to be treated with the sex toy, and you'll want them
  talking, sweating, breathing and emitting precum, and changing their pose to
  hint to the player how they're doing.

4.7.11.6 Sex toy sequence should work for female characters as well

4.8 Destructors

  Make sure you're cleaning up all of your assets in a destroy() method. If
  you're unsure, you can try changing the MemLeakState to load up your SexyState
  or your PokeWindow and see if it starts consuming more and more memory.

4.9 Compress image assets

  I used tinypng.com; a compressed PNG is about 20% the size of a non-compressed
  PNG. This is why the game is 10 MB and not 30 MB, so compress your assets.

================================================================================
5. License

Monster Mind's code and framework are licensed under the MIT licence. Please see the  
LICENSE.md file for more information. tl;dr you can do whatever you want as long as  
you include the original copyright and license notice in any copy of the  
software/source.  

Monster Mind's sounds, music, images, fonts, and everything else are all licensed by  
other companies. Most are from Pokemon games, and a few are from other places. They  
are not mine to give away.

================================================================================
6. In closing

I'm releasing this source code so that others can learn from it, and because I'd
like others to be able to expand the game in ways they see fit. If you can make
this game better or if you have questions about this source code I can be reached
a lot of places:

Discord: argonvile
E-mail: argon.vile@gmail.com
Telegram: https://t.me/ArgonVile
