package poke.abra;
import openfl.utils.Object;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import kludge.FlxSpriteKludge;
import kludge.LateFadingFlxParticle;
import poke.sexy.ArmsAndLegsArranger;
import poke.sexy.BlobbyGroup;
import poke.sexy.FancyAnim;
import poke.sexy.HeartBank;
import poke.sexy.RandomPolygonPoint;
import poke.sexy.SexyState;
import poke.sexy.WordManager.Qord;
import poke.sexy.WordParticle;

/**
 * Sex sequence for Abra
 * 
 * Abra likes having her feet and chest rubbed, or sometimes just two out of
 * the three. That's right, sometimes her left foot is more sore than her right
 * foot, or vice-versa. ...Maybe it's from sitting crosslegged.
 * 
 * Sometimes abra likes anal; you can try clicking her mouth and see if she'll
 * suck on your fingers. If she glances away, she is not interested. If she
 * sucks on your fingers, she's interested in anal and this will make her very
 * happy.
 * 
 * On the days that Abra is not in the mood for anal, she really likes having
 * her shoulders rubbed.
 * 
 * Abra hates having her scalp or belly rubbed. She finds it demeaning.
 * 
 * As you finger her pussy, Abra likes your pace to accelerate as her climax
 * builds. Start slow and gradually ramp up your speed; if you slow down even
 * slightly, she'll tell you to pick up the pace. She is annoyingly picky.
 * 
 * Abra likes the small anal beads, either purple or grey.
 * 
 * Abra doesn't particularly care how many beads you stick in her, or how fast
 * you do it. If you insert a ton of beads, they'll each provide a slightly
 * reduced reward so it balances out the same either way.
 * 
 * Abra can only hold so many. The amount of beads she can hold will increase
 * over time, if you keep playing with her over and over, and keep filling her
 * to capacity.
 * 
 * If you keep increasing her capacity, her belly will eventually distend a
 * ridiculous amount, and she'll complain that it hurts or that she thinks
 * she's going to die. But, she will be OK.
 * 
 * Abra likes when you pull out the beads slowly. You want to pull out each
 * bead half-way until you see a few hearts, and then pull out the bead the
 * rest of the way.
 * 
 * Abra doesn't like when you pull out too few or too many beads. You can tell
 * if you pull out the wrong number, because very few hearts will appear, and
 * they'll be the tiny white hearts. Of course you are not a mind-reader, but
 * there is a pattern:
 *  - If Abra pulls out 4 beads, you should pull out 3 beads.
 *  - If Abra pulls out 3 beads, you should pull out 4 beads.
 *  - If Abra pulls out only 1 bead, you should pull out either 3 or 4 beads,
 *    but not the same number that you removed on your previous turn.
 * If you adhere to this pattern, and don't go too quickly, you'll get a lot of
 * hearts for each bead removed, particularly the final 10. If you've prepped
 * Abra beforehand and gotten her close to the edge, this can even make her cum.
 */
class AbraSexyState extends SexyState<AbraWindow>
{
	public var permaBoner:Bool = false; // if you solve a 7-peg puzzle, abra will start with a boner
	private var ballOpacityTween:FlxTween;

	// areas that animate when you click them
	private var mouthPolyArray:Array<Array<FlxPoint>>;
	private var vagPolyArray:Array<Array<FlxPoint>>;
	private var assPolyArray:Array<Array<FlxPoint>>;
	private var leftLegPolyArray:Array<Array<FlxPoint>>;
	private var rightLegPolyArray:Array<Array<FlxPoint>>;

	// areas that he likes or hates
	private var shoulderPolyArray:Array<Array<FlxPoint>>;
	private var bellyPolyArray:Array<Array<FlxPoint>>;
	private var chestTorsoPolyArray:Array<Array<FlxPoint>>;
	private var chestArmsPolyArray:Array<Array<FlxPoint>>;
	private var scalpPolyArray:Array<Array<FlxPoint>>;

	// abra's mood today
	private var abraMood0:Int = FlxG.random.int(0, 7);
	private var abraMood1:Bool = FlxG.random.bool();
	private var abraMood2:Int = Std.int(Math.min(FlxG.random.int(1, 3), FlxG.random.int(1, 4)));

	/*
	 * niceThings[0] = rub both of abra's feet, and her chest
	 * niceThings[1] = rub abra's shoulders or (maybe) finger her ass
	 * niceThings[2] = (male only) rub abra's balls after he gets a boner
	 */
	private var niceThings:Array<Bool> = [true, true, true];

	/*
	 * meanThings[0] = rub abra's head
	 * meanThings[1] = rub abra's belly
	 */
	private var meanThings:Array<Bool> = [true, true];

	private var patienceCount:Int = 1;
	private var mistakeChain:Int = 0;

	private var tooSlowWords:Qord;
	private var tooFastWords:Qord;

	private var toyTooManyWords:Qord;
	private var toyWayTooManyWords:Qord;
	private var minigasmCounter:Int = 1;

	private var _toyWindow:AbraBeadWindow;
	private var _toyInterface:AbraBeadInterface;
	private var _tugNoise:TugNoise = new TugNoise();

	private var _beadPushRewards:Array<Float> = [];
	private var _beadPullRewards:Array<Float> = [];
	private var _beadNudgeRewards:Array<Float> = [];

	private var _beadPlayerPullTarget:Int = 0; // when should the player stop pulling beads?
	private var _beadPlayerPullStart:Int = 0; // when did the player start pulling beads?
	private var _prevAbraBeadCount:Int = 0;
	private var _totalBeadPenalty:Float = 0;
	private var _vibeButton:FlxButton;

	public var justFinishedGame:Bool = false; // true if the player just swapped with abra

	override public function create():Void
	{
		prepare("abra");
		super.create();

		_toyWindow = new AbraBeadWindow(256, 0, 248, 426);
		_toyInterface = new AbraBeadInterface();
		toyGroup.add(_toyWindow);
		toyGroup.add(_toyInterface);

		_pokeWindow._ass.animation.add("finger-ass", [1, 2]);
		_pokeWindow._interact.animation.add("finger-ass", [16, 17]);
		_dick.animation.add("finger-ass", [1, 2]);

		_pokeWindow.reposition(_pokeWindow._arms, _pokeWindow.members.indexOf(_pokeWindow._legs));
		_pokeWindow._arms.animation.play("0");

		if (PlayerData.abraSexyBeforeChat == 8)
		{
			justFinishedGame = true;
		}
		if (PlayerData.abraSexyBeforeChat == 2)
		{
			// butt talk puts him in a bad butt mood
			abraMood1 = false;
		}
		if (PlayerData.abraSexyBeforeChat == 7)
		{
			// craving anal
			abraMood1 = true;
		}
		if (PlayerData.abraSexyBeforeChat == 3 || PlayerData.abraSexyBeforeChat == 4)
		{
			// foot/chest talk makes him want both feet/chest rubbed
			abraMood0 = 7;
		}
		if (!_male)
		{
			// no "ball rubbing" fetish for girls
			niceThings[2] = false;
		}

		sfxEncouragement = [AssetPaths.abra0__mp3, AssetPaths.abra1__mp3, AssetPaths.abra2__mp3];
		sfxPleasure = [AssetPaths.abra3__mp3, AssetPaths.abra4__mp3, AssetPaths.abra5__mp3, AssetPaths.abra6__mp3];
		sfxOrgasm = [AssetPaths.abra7__mp3, AssetPaths.abra8__mp3, AssetPaths.abra9__mp3];

		popularity = 0.0;
		cumTrait0 = 2;
		cumTrait1 = 3;
		cumTrait2 = 8;
		cumTrait3 = 4;
		cumTrait4 = 6;
		_rubRewardFrequency = 3.1;

		// after solving 7-peg puzzles, abra might have a boner or appear aroused.
		setInactiveDickAnimation();
		_pokeWindow.setArousal(determineArousal());

		if (ItemDatabase.playerHasUneatenItem(ItemDatabase.ITEM_SMALL_PURPLE_BEADS))
		{
			var _purpleAnalBeadButton:FlxButton = newToyButton(purpleAnalBeadButtonEvent, AssetPaths.smallbeads_purple_button__png, _dialogTree);
			addToyButton(_purpleAnalBeadButton);
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_SMALL_GREY_BEADS))
		{
			var _greyAnalBeadButton:FlxButton = newToyButton(greyAnalBeadButtonEvent, AssetPaths.smallbeads_grey_button__png, _dialogTree);
			addToyButton(_greyAnalBeadButton);
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_VIBRATOR))
		{
			_vibeButton = newToyButton(vibeButtonEvent, AssetPaths.vibe_button__png, _dialogTree);
			addToyButton(_vibeButton, 0.59);
		}

		// should abra just shut up about the player's tempo this time?
		if ((abraMood0 + abraMood2 * 2) % 3 == 0)
		{
			// don't complain about going too slowly this time
			tooSlowWords.timer = 900;
		}
		if ((abraMood0 * 3 + abraMood2) % 4 == 0)
		{
			// only complain about going too slowly once, if ever
			tooSlowWords.frequency = 900;
		}
		else if ((abraMood0 * 3 + abraMood2) % 4 == 1)
		{
			// complain a ton
			tooSlowWords.frequency = 4;
		}

		_toyWindow.beadPushCallback = beadPushed;
		_toyWindow.beadPullCallback = beadPulled;
		_toyWindow.beadNudgeCallback = beadNudged;
		for (i in 0...PlayerData.abraBeadCapacity)
		{
			_beadPushRewards.push(0);
		}
		var pushReservoir:Float = _toyBank._foreplayHeartReservoir;
		while (pushReservoir > 0)
		{
			var index:Int = Std.int(Math.min(FlxG.random.int(0, _beadPushRewards.length - 1), FlxG.random.int(0, _beadPushRewards.length - 1)));
			_beadPushRewards[index] += 0.25;
			pushReservoir -= 0.25;
		}
	}

	override function toyForeplayFactor():Float
	{
		// foreplayReservoir: pushing beads; dickReservoir: pulling beads
		return 0.15;
	}

	public function vibeButtonEvent():Void
	{
		playButtonClickSound();
		removeToyButton(_vibeButton);
		var tree:Array<Array<Object>> = [];
		AbraDialog.snarkyVibe(tree);
		showEarlyDialog(tree);
	}

	public function purpleAnalBeadButtonEvent():Void
	{
		playButtonClickSound();
		toyButtonsEnabled = false;
		maybeEmitWords(toyStartWords);
		var time:Float = eventStack._time;
		eventStack.addEvent({time:time += 0.8, callback:eventTakeBreak, args:[2.5]});
		eventStack.addEvent({time:time += 0.5, callback:eventShowToyWindow});
		eventStack.addEvent({time:time += 2.2, callback:eventEnableToyButtons});
	}

	public function greyAnalBeadButtonEvent():Void
	{
		playButtonClickSound();
		_toyWindow.setGreyBeads();
		toyButtonsEnabled = false;
		maybeEmitWords(toyStartWords);
		var time:Float = eventStack._time;
		eventStack.addEvent({time:time += 0.8, callback:eventTakeBreak, args:[2.5]});
		eventStack.addEvent({time:time += 0.5, callback:eventShowToyWindow});
		eventStack.addEvent({time:time += 2.2, callback:eventEnableToyButtons});
	}

	override public function shouldEmitToyInterruptWords()
	{
		return _toyInterface.pushMode || _toyWindow.getNextPulledBeadIndex() >= 0;
	}

	override function pastBonerThreshold():Bool
	{
		return super.pastBonerThreshold() || (PlayerData.pokemonLibido > 1 && permaBoner && !came);
	}

	override public function sexyStuff(elapsed:Float):Void
	{
		super.sexyStuff(elapsed);

		if (pastBonerThreshold() && _gameState == 200)
		{
			if (fancyRubbing(_dick) && _rubBodyAnim._flxSprite.animation.name == "rub-dick" && _rubBodyAnim.nearMinFrame())
			{
				_rubBodyAnim.setAnimName("jack-off");
				_rubHandAnim.setAnimName("jack-off");
			}
		}

		if (fancyRubbing(_pokeWindow._feet) && _armsAndLegsArranger._armsAndLegsTimer < 1.5)
		{
			_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(1.5, 3);
		}

		if (!fancyRubAnimatesSprite(_dick))
		{
			setInactiveDickAnimation();
		}
	}

	override public function getToyWindow():PokeWindow
	{
		return _toyWindow;
	}

	override public function handleToyWindow(elapsed:Float):Void
	{
		super.handleToyWindow(elapsed);
		if (_toyWindow._breakTime > 0)
		{
			// hasn't settled down yet...
			_toyInterface.visible = false;
			return;
		}
		_toyInterface.visible = true;
		if (_toyInterface._pullingBeads && !FlxG.mouse.pressed)
		{
			_toyInterface._pullingBeads = false;
			if (_toyWindow.getIntBeadPosition() > _beadPlayerPullStart)
			{
				_toyInterface.setInteractive(false);
				if (_toyWindow.getIntBeadPosition() >= 1000)
				{
					// no more beads to remove...
				}
				else
				{
					abraPullsBeads();
					relaxPulledAnalBeads();
				}
			}
		}
		else if (_toyInterface.justFinishedPushMode())
		{
			_toyInterface.pushMode = false;

			var pullReservoir:Float = _toyBank._dickHeartReservoir;

			for (i in 0..._beadPushRewards.length)
			{
				pullReservoir += _beadPushRewards[i];
			}
			for (i in 0..._toyInterface.getBeadsPushed())
			{
				_beadNudgeRewards[i] = 0;
				_beadPullRewards[i] = 0;
			}
			var nudgeBank:Float = SexyState.roundDownToQuarter(pullReservoir * 0.3);
			var heartsPerNudge:Float = SexyState.roundDownToQuarter(nudgeBank * 0.7 / _beadNudgeRewards.length);
			pullReservoir -= nudgeBank;
			var heartsPerPull:Float = SexyState.roundDownToQuarter(pullReservoir * 0.7 / _beadPullRewards.length);
			for (i in 0..._beadPullRewards.length)
			{
				_beadNudgeRewards[i] += heartsPerNudge;
				nudgeBank -= heartsPerNudge;
				_beadPullRewards[i] += heartsPerPull;
				pullReservoir -= heartsPerPull;
			}
			while (pullReservoir > 0)
			{
				var index:Int = Std.int(Math.min(FlxG.random.int(0, _beadPullRewards.length - 1), FlxG.random.int(0, _beadPullRewards.length - 1)));
				_beadPullRewards[index] += 0.25;
				pullReservoir -= 0.25;
			}
			while (nudgeBank > 0)
			{
				var index:Int = Std.int(Math.max(FlxG.random.int(0, _beadNudgeRewards.length - 1), FlxG.random.int(0, _beadNudgeRewards.length - 1)));
				_beadNudgeRewards[index] += 0.25;
				nudgeBank -= 0.25;
			}

			// transition to abra's turn
			_beadPlayerPullTarget = _toyWindow.getNextPulledBeadIndex();
			abraPullsBeads();
		}
		if (_toyInterface.pushMode)
		{
			if (_toyInterface.getBeadsPushed() >= 30 && !_toyInterface.canEndPushMode)
			{
				_toyInterface.canEndPushMode = true;
			}
		}
		if (_toyWindow.abrasTurn && _toyInterface.interactive)
		{
			_toyInterface.setInteractive(false);
		}
		else if (!_toyWindow.abrasTurn && !_toyInterface.interactive)
		{
			if (_toyWindow.getIntBeadPosition() >= 1000)
			{
				// no more beads to remove...
			}
			else
			{
				_toyInterface.setInteractive(true);
				_beadPlayerPullStart = _toyWindow.getIntBeadPosition();
			}
		}
		_toyWindow.pushingBeads = _toyInterface.pushMode;
		if (_toyInterface.pushMode && _toyInterface.isMouseNearPushableBead())
		{
			if (_toyWindow._interact.animation.name == "default")
			{
				_toyWindow._interact.animation.play("ready-to-push");
			}
			if (_toyWindow.beadPushAnim == null && FlxG.mouse.pressed)
			{
				_toyWindow.beadPushAnim = new FancyAnim(_toyWindow._interact, "push-bead");
			}
		}
		else {
			if (_toyWindow.beadPushAnim != null)
			{
				_toyWindow.beadPushAnim = null;
			}
			if (_toyWindow._interact.animation.name != "default")
			{
				_toyWindow._interact.animation.play("default");
			}
		}
		if (_toyWindow.abrasTurn)
		{
			if (_toyWindow.slack == 0 && _toyWindow._ass.animation.frameIndex != 0)
			{
				_tugNoise.tugging = true;
			}
		}
		else if (_toyInterface._pullingBeads)
		{
			_toyWindow.tryPullingBeads(elapsed, _toyInterface.pulledBeads + _toyInterface._desiredBeadPosition);
			_toyWindow.lineAngle = _toyInterface.lineAngle;
			if (_toyWindow.beadPosition >= 999 + AbraBeadWindow.BEAD_BP_CENTER)
			{
				// no more beads
				_toyWindow.slack = AbraBeadWindow.MAX_SLACK;
			}
			if (_toyWindow.slack == 0)
			{
				// line is taut; limit the interface's pull distance
				_toyInterface._actualBeadPosition = _toyWindow.beadPosition - _toyInterface.pulledBeads;
			}
			else
			{
				// line is slack; the interface can do whatever it wants
				_toyInterface._actualBeadPosition = _toyInterface._desiredBeadPosition;
			}
			if (_toyWindow.slack == 0 && _toyWindow._ass.animation.frameIndex != 0)
			{
				_tugNoise.tuggingMouse = true;
			}
		}
		else if (_toyWindow.beadPushAnim != null)
		{
			var oldPulledBeads:Int = _toyInterface.pulledBeads;
			_toyInterface.pulledBeads = Std.int(1 + _toyWindow.beadPosition - 0.42);
			_toyInterface._actualBeadPosition = _toyWindow.beadPosition - _toyInterface.pulledBeads;

			if (oldPulledBeads != _toyInterface.pulledBeads)
			{
				// when pushing beads, avoid interface bead getting sucked back out
				_toyInterface._visualActualBeadPosition += 1;
			}
		}
		else {
			relaxPulledAnalBeads();
		}

		_tugNoise.update(elapsed);
		_tugNoise.tugging = false;
		_tugNoise.tuggingMouse = false;
	}

	function abraPullsBeads():Void
	{
		var nextPulledBeadIndex:Int = _toyWindow.getNextPulledBeadIndex();
		var penaltyArray:Array<Float> = [];
		if (_beadPlayerPullTarget != nextPulledBeadIndex)
		{
			// penalty...
			var harshPenaltyCount:Int = nextPulledBeadIndex - 1 - _beadPlayerPullTarget;
			for (i in 0...harshPenaltyCount)
			{
				// pulled way too few...
				penaltyArray.push(0);
			}
			if (_beadPlayerPullTarget < nextPulledBeadIndex)
			{
				// too few...
				penaltyArray.push(0.20);
			}
			penaltyArray.push(0.33);
		}
		var whichBehavior:Int = FlxG.random.int(0, _prevAbraBeadCount == 0 ? 1 : 2);
		var abraBeadCount:Int = 1;
		if (whichBehavior == 0)
		{
			// 3: player should pull four beads
			abraBeadCount = 3;
			_prevAbraBeadCount = 3;
			_toyWindow.abraDesiredBeadPosition = _toyWindow.beadPosition;
			_beadPlayerPullTarget = Std.int(nextPulledBeadIndex - 7);
		}
		else if (whichBehavior == 1)
		{
			// 4: player should pull three beads
			abraBeadCount = 4;
			_prevAbraBeadCount = 4;
			_toyWindow.abraDesiredBeadPosition = _toyWindow.beadPosition;
			_beadPlayerPullTarget = Std.int(nextPulledBeadIndex - 7);
		}
		else {
			// 1: player should pull 3 or 4 beads, but a different number from last time
			abraBeadCount = 1;
			_prevAbraBeadCount = (_prevAbraBeadCount == 3 ? 4 : 3);
			_toyWindow.abraDesiredBeadPosition = _toyWindow.beadPosition;
			_beadPlayerPullTarget = Std.int(nextPulledBeadIndex - (_prevAbraBeadCount == 3 ? 5 : 4));
		}
		for (i in 0...penaltyArray.length)
		{
			var penalty0:Float = SexyState.roundDownToQuarter(_beadPullRewards[nextPulledBeadIndex - i] * (1 - penaltyArray[i]));
			_beadPullRewards[nextPulledBeadIndex - i] -= penalty0;
			_totalBeadPenalty += penalty0;

			var penalty1:Float = SexyState.roundDownToQuarter(_beadNudgeRewards[nextPulledBeadIndex - i] * (1 - penaltyArray[i]));
			_beadNudgeRewards[nextPulledBeadIndex - i] -= penalty1;
			_totalBeadPenalty += penalty1;
		}
		_toyWindow.removeBeads(abraBeadCount);
	}

	public function beadPushed(index:Int, duration:Float, radius:Float):Void
	{
		_toyBank._foreplayHeartReservoir = Math.max(0, SexyState.roundDownToQuarter(_toyBank._foreplayHeartReservoir - _toyBank._foreplayHeartReservoirCapacity / 30));

		_heartEmitCount += _beadPushRewards[index];
		_heartBank._foreplayHeartReservoirCapacity += _beadPushRewards[index];
		_beadPushRewards[index] = 0;

		if (duration >= 0.75 && (_toyWindow.isGreyBeads() && index % 6 == 0 || !_toyWindow.isGreyBeads() && radius >= 15))
		{
			// that was a big one...
			maybeScheduleBreath();
			if (_breathTimer > 0)
			{
				_breathTimer = 0.1;
			}
		}

		if (index > 60)
		{
			// urghh... too many...
			_autoSweatRate += 0.01;
		}
		if (index > 100)
		{
			if (FlxG.random.bool(3))
			{
				maybeEmitWords(toyWayTooManyWords);
			}
		}
		else if (index > 85)
		{
			if (FlxG.random.bool(3))
			{
				maybeEmitWords(toyTooManyWords);
			}
		}
		if (radius >= 12)
		{
			var magicNumber:Float = duration * FlxG.random.float(0, 1);
			if (magicNumber > 0.8)
			{
				var precumAmount:Int = 1;
				if (magicNumber > 1.1)
				{
					precumAmount++;
				}
				if (magicNumber > 1.5)
				{
					precumAmount++;
				}
				precum(precumAmount);
			}
		}
		maybeEmitToyWordsAndStuff();
	}

	public function beadPulled(index:Int, duration:Float, radius:Float):Void
	{
		_toyBank._dickHeartReservoir = Math.max(0, SexyState.roundDownToQuarter(_toyBank._dickHeartReservoir - _toyBank._dickHeartReservoirCapacity / 30));

		if (index <= _beadPlayerPullTarget)
		{
			var penalty:Float = 0.33;
			if (index == _beadPlayerPullTarget)
			{
				penalty = 0.33;
			}
			else if (index == _beadPlayerPullTarget - 1)
			{
				penalty = 0.20;
			}
			else
			{
				penalty = 0.12;
			}

			var penaltyAmount0:Float = SexyState.roundUpToQuarter(_beadPullRewards[index] * (1 - penalty));
			_beadPullRewards[index] -= penaltyAmount0;
			_totalBeadPenalty += penaltyAmount0;

			var penaltyAmount1:Float = SexyState.roundDownToQuarter(_beadNudgeRewards[index - 1] * (1 - penalty));
			_beadNudgeRewards[index - 1] -= penaltyAmount1;
			_totalBeadPenalty += penaltyAmount1;
		}

		_heartEmitCount += _beadPullRewards[index];
		_heartBank._foreplayHeartReservoirCapacity += _beadPullRewards[index];
		_beadPullRewards[index] = 0;
		beadNudged(index, duration, radius); // give nudge reward, if duration is large enough
		if (index > 70)
		{
			_autoSweatRate -= 0.01;
		}
		if (_toyWindow.abrasTurn && _beadNudgeRewards[index] > 0)
		{
			// if abra misses a nudge... just give it to them
			_heartEmitCount += _beadNudgeRewards[index];
			_beadNudgeRewards[index] = 0;
		}
		if (_beadNudgeRewards[index] > 0)
		{
			// player missed a nudge...
			_totalBeadPenalty += _beadNudgeRewards[index];
			_beadNudgeRewards[index] = 0;

			if (index > 70)
			{
				// they're still sick, keep 'em sweating...
			}
			else
			{
				_autoSweatRate *= 0.7;
			}
		}
		else {
			if (radius >= 15)
			{
				maybeScheduleBreath();
				if (_breathTimer > 0)
				{
					_breathTimer = 0.1;
				}
			}
			else {
				_breathlessCount++;
			}
		}
		if (radius >= 10)
		{
			var magicNumber:Float = duration * FlxG.random.float(0, 1);
			if (magicNumber > 0.6)
			{
				var precumAmount:Int = 1;
				if (magicNumber > 1.1)
				{
					precumAmount++;
				}
				if (_heartEmitCount > 1.5)
				{
					precumAmount++;
				}
				if (_heartEmitCount > 3.0)
				{
					precumAmount++;
				}
				precum(precumAmount);
			}
		}

		if (index < 10)
		{
			var penaltyPercent:Float = _totalBeadPenalty / _toyBank._totalReservoirCapacity;
			if (penaltyPercent < 0.04)
			{
				_heartBank._dickHeartReservoirCapacity += _heartEmitCount * 0.6;
			}
			else if (index < 5 && penaltyPercent < 0.08)
			{
				_heartBank._dickHeartReservoirCapacity += _heartEmitCount * 0.6;
			}
		}
		if (index == 0)
		{
			if (finalOrgasmLooms())
			{
			}
			else
			{
				toyButtonsEnabled = false;
				var time:Float = eventStack._time;
				eventStack.addEvent({time:time += 2.8, callback:eventHideToyWindow});
				eventStack.addEvent({time:time += 0.5, callback:eventTakeBreak, args:[2.5]});
				eventStack.addEvent({time:time += 2.2, callback:eventEnableToyButtons});
			}
		}
		maybeEmitToyWordsAndStuff();
	}

	override function generateCumshots():Void
	{
		if (_remainingOrgasms == 1 && _activePokeWindow == _toyWindow)
		{
			// empty the remaining anal bead rewards into the orgasm
			for (i in 0..._toyWindow.getNextPulledBeadIndex() + 1)
			{
				_heartBank._dickHeartReservoir += _beadPullRewards[i];
				_heartBank._dickHeartReservoir += _beadNudgeRewards[i];
				_beadPullRewards[i] = 0;
				_beadNudgeRewards[i] = 0;
			}
		}
		super.generateCumshots();
		// it's OK to go slow after cumming
		patienceCount = 1;
		mouseTiming.insert(0, 1000);
	}

	public function beadNudged(index:Int, duration:Float, radius:Float):Void
	{
		var targetDuration:Float = 0;
		if (radius <= 11)
		{
			targetDuration = 0.24;
		}
		else if (radius <= 13)
		{
			targetDuration = 0.38;
		}
		else if (radius <= 15)
		{
			targetDuration = 0.65;
		}
		else {
			targetDuration = 1.17;
		}
		if (_beadNudgeRewards[index] > 0 && duration >= targetDuration)
		{
			_heartEmitCount += _beadNudgeRewards[index];
			_heartBank._foreplayHeartReservoirCapacity += _beadNudgeRewards[index];
			_beadNudgeRewards[index] = 0;
			if (index > 70)
			{
				// already pretty sweaty
			}
			else if (_autoSweatRate < 0.3)
			{
				_autoSweatRate += 0.02;
			}
			else if (_autoSweatRate < 0.5)
			{
				_autoSweatRate += 0.01;
			}
		}
		_idlePunishmentTimer = 0;
	}

	override public function generateSexyBeforeDialog():Array<Array<Object>>
	{
		if (permaBoner)
		{
			var tree:Array<Array<Object>> = new Array<Array<Object>>();
			var chat:Dynamic;
			if (PlayerData.difficulty == PlayerData.Difficulty._7Peg)
			{
				var sexyBeforeChat:Int = PlayerData.abra7PegSexyBeforeChat % AbraDialog.sexyBefore7Peg.length;
				chat = AbraDialog.sexyBefore7Peg[sexyBeforeChat];
				PlayerData.appendChatHistory("abra.sexy7PegBeforeChat." + sexyBeforeChat);
			}
			else
			{
				chat = AbraDialog.sexyBefore5PegTutorial;
				PlayerData.appendChatHistory("abra.sexyTutorial.0");
			}
			chat(tree, this);
			return tree;
		}
		return super.generateSexyBeforeDialog();
	}

	override function emitBreath():Void
	{
		if (_fancyRub && _rubHandAnim._flxSprite.animation.name == "suck-fingers")
		{
			// don't emit breath when sucking fingers
		}
		else {
			super.emitBreath();
		}
	}

	override public function determineArousal():Int
	{
		var result:Int = 0;
		if (_heartBank.getDickPercent() < 0.77)
		{
			result = 4;
		}
		else if (_heartBank.getDickPercent() < 0.9)
		{
			result = 3;
		}
		else if (super.pastBonerThreshold())
		{
			result = 2;
		}
		else if (_heartBank.getForeplayPercent() < 0.77)
		{
			result = 3;
		}
		else if (_heartBank.getForeplayPercent() < 0.9)
		{
			result = 2;
		}
		else if ((permaBoner && !came) || _heartBank._foreplayHeartReservoir < _heartBank._foreplayHeartReservoirCapacity)
		{
			result = 1;
		}
		else {
			result = 0;
		}
		if (specialRub == "belly" || specialRub == "scalp")
		{
			result = 0;
		}
		return result;
	}

	override public function checkSpecialRub(touchedPart:FlxSprite)
	{
		if (_fancyRub)
		{
			if (_rubHandAnim._flxSprite.animation.name == "rub-balls")
			{
				specialRub = "balls";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-left-foot")
			{
				specialRub = "left-foot";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-right-foot")
			{
				specialRub = "right-foot";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "finger-ass")
			{
				specialRub = "ass";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "suck-fingers")
			{
				specialRub = "mouth";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "jack-off")
			{
				specialRub = "jack-off";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-dick")
			{
				specialRub = "rub-dick";
			}
		}
		else
		{
			if (touchedPart == _head && clickedPolygon(touchedPart, scalpPolyArray))
			{
				specialRub = "scalp";
			}
			else if (touchedPart == _pokeWindow._arms && clickedPolygon(touchedPart, shoulderPolyArray))
			{
				specialRub = "shoulder";
			}
			else if (touchedPart == _pokeWindow._arms && clickedPolygon(touchedPart, chestArmsPolyArray))
			{
				specialRub = "chest";
			}
			else if (touchedPart == _pokeWindow._torso && clickedPolygon(touchedPart, chestTorsoPolyArray))
			{
				specialRub = "chest";
			}
			else if (touchedPart == _pokeWindow._torso && clickedPolygon(touchedPart, bellyPolyArray))
			{
				specialRub = "belly";
			}
		}
	}

	override public function canChangeHead():Bool
	{
		/*
		 * Don't move Abra's head if our fingers are in her mouth
		 */
		return !fancyRubbing(_head);
	}

	override function shouldRecordMouseTiming():Bool
	{
		return _dick.animation.name == "jack-off";
	}

	override public function touchPart(touchedPart:FlxSprite):Bool
	{
		if (FlxG.mouse.justPressed && (touchedPart == _dick || !_male && touchedPart == _pokeWindow._torso && clickedPolygon(touchedPart, vagPolyArray)))
		{
			if (_gameState == 200 && pastBonerThreshold())
			{
				interactOn(_dick, "jack-off");
			}
			else
			{
				interactOn(_dick, "rub-dick");
			}
			if (!_male)
			{
				_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.length - 1);
				_rubBodyAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
				_rubHandAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
			}
			return true;
		}
		if (FlxG.mouse.justPressed && touchedPart == _pokeWindow._balls)
		{
			interactOn(_pokeWindow._balls, "rub-balls");
			_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.members.indexOf(_dick) + 1);
			return true;
		}
		if (FlxG.mouse.justPressed && touchedPart == _head)
		{
			if (clickedPolygon(touchedPart, mouthPolyArray))
			{
				if (abraMood1)
				{
					if (niceThings[1] == false)
					{
						// your fingers have been in his ass (ew)
						_newHeadTimer = 0;
					}
					else
					{
						interactOn(_head, "suck-fingers");
						return true;
					}
				}
				else
				{
					_newHeadTimer = 0;
				}
			}
		}
		if (FlxG.mouse.justPressed && touchedPart == _pokeWindow._torso)
		{
			if (clickedPolygon(touchedPart, assPolyArray))
			{
				interactOn(_pokeWindow._ass, "finger-ass");
				if (!_male)
				{
					// vagina stretches when fingering ass
					_rubBodyAnim2 = new FancyAnim(_dick, "finger-ass");
					_rubBodyAnim2.setSpeed(0.65 * 2.5, 0.65 * 1.5);
				}
				_rubBodyAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
				_rubHandAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
				ballOpacityTween = FlxTweenUtil.retween(ballOpacityTween, _pokeWindow._balls, { alpha:0.65 }, 0.25);
				return true;
			}
		}
		if (touchedPart == _pokeWindow._legs && _clickedDuration > 1.5)
		{
			if (clickedPolygon(touchedPart, leftLegPolyArray))
			{
				// raise left leg
				_pokeWindow._legs.animation.play("raise-left-leg");
				_pokeWindow._feet.animation.play("raise-left-leg");
				_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(4, 6);
			}
			if (clickedPolygon(touchedPart, rightLegPolyArray))
			{
				// raise right leg
				_pokeWindow._legs.animation.play("raise-right-leg");
				_pokeWindow._feet.animation.play("raise-right-leg");
				_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(4, 6);
			}
		}
		if (FlxG.mouse.justPressed && touchedPart == _pokeWindow._feet)
		{
			if (_pokeWindow._feet.animation.name == "raise-left-leg")
			{
				interactOn(_pokeWindow._feet, "rub-left-foot", "raise-left-leg");
			}
			else
			{
				interactOn(_pokeWindow._feet, "rub-right-foot", "raise-right-leg");
			}
			return true;
		}
		return false;
	}

	override public function untouchPart(touchedPart:FlxSprite):Void
	{
		super.untouchPart(touchedPart);
		if (touchedPart == _pokeWindow._ass)
		{
			ballOpacityTween = FlxTweenUtil.retween(ballOpacityTween, _pokeWindow._balls, { alpha:1.0 }, 0.25);
		}
		else if (touchedPart == _head)
		{
			_head.animation.play("1-1");
			_newHeadTimer = FlxG.random.float(1, 2);
		}
		else if (touchedPart == _pokeWindow._feet)
		{
			_pokeWindow._feet.animation.play(_pokeWindow._legs.animation.name);
		}
	}

	override function initializeHitBoxes():Void
	{
		if (_activePokeWindow == _pokeWindow)
		{
			mouthPolyArray = new Array<Array<FlxPoint>>();
			mouthPolyArray[0] = [new FlxPoint(142, 227), new FlxPoint(139, 200), new FlxPoint(172, 184), new FlxPoint(208, 200), new FlxPoint(207, 228)];
			mouthPolyArray[1] = [new FlxPoint(166, 226), new FlxPoint(162, 191), new FlxPoint(183, 161), new FlxPoint(215, 157), new FlxPoint(231, 173), new FlxPoint(228, 219)];
			mouthPolyArray[2] = [new FlxPoint(166, 226), new FlxPoint(162, 191), new FlxPoint(183, 161), new FlxPoint(215, 157), new FlxPoint(231, 173), new FlxPoint(228, 219)];
			mouthPolyArray[8] = [new FlxPoint(76, 166), new FlxPoint(77, 100), new FlxPoint(123, 118), new FlxPoint(138, 141), new FlxPoint(123, 172), new FlxPoint(88, 177)];
			mouthPolyArray[9] = [new FlxPoint(76, 166), new FlxPoint(77, 100), new FlxPoint(123, 118), new FlxPoint(138, 141), new FlxPoint(123, 172), new FlxPoint(88, 177)];
			mouthPolyArray[10] = [new FlxPoint(162, 225), new FlxPoint(154, 203), new FlxPoint(163, 170), new FlxPoint(189, 157), new FlxPoint(219, 185), new FlxPoint(219, 216)];
			mouthPolyArray[11] = [new FlxPoint(162, 225), new FlxPoint(154, 203), new FlxPoint(163, 170), new FlxPoint(189, 157), new FlxPoint(219, 185), new FlxPoint(219, 216)];
			mouthPolyArray[12] = [new FlxPoint(127, 233), new FlxPoint(124, 199), new FlxPoint(147, 184), new FlxPoint(205, 186), new FlxPoint(208, 224)];
			mouthPolyArray[13] = [new FlxPoint(127, 233), new FlxPoint(124, 199), new FlxPoint(147, 184), new FlxPoint(205, 186), new FlxPoint(208, 224)];
			mouthPolyArray[16] = [new FlxPoint(73, 117), new FlxPoint(128, 126), new FlxPoint(138, 168), new FlxPoint(122, 194), new FlxPoint(76, 182)];
			mouthPolyArray[17] = [new FlxPoint(73, 117), new FlxPoint(128, 126), new FlxPoint(138, 168), new FlxPoint(122, 194), new FlxPoint(76, 182)];
			mouthPolyArray[18] = [new FlxPoint(147, 224), new FlxPoint(142, 204), new FlxPoint(183, 183), new FlxPoint(235, 181), new FlxPoint(239, 209), new FlxPoint(197, 229)];
			mouthPolyArray[19] = [new FlxPoint(147, 224), new FlxPoint(142, 204), new FlxPoint(183, 183), new FlxPoint(235, 181), new FlxPoint(239, 209), new FlxPoint(197, 229)];
			mouthPolyArray[20] = [new FlxPoint(124, 212), new FlxPoint(128, 193), new FlxPoint(175, 188), new FlxPoint(221, 196), new FlxPoint(216, 237), new FlxPoint(133, 240)];
			mouthPolyArray[21] = [new FlxPoint(124, 212), new FlxPoint(128, 193), new FlxPoint(175, 188), new FlxPoint(221, 196), new FlxPoint(216, 237), new FlxPoint(133, 240)];
			mouthPolyArray[24] = [new FlxPoint(123, 218), new FlxPoint(161, 172), new FlxPoint(202, 181), new FlxPoint(237, 170), new FlxPoint(250, 217), new FlxPoint(190, 238)];
			mouthPolyArray[25] = [new FlxPoint(123, 218), new FlxPoint(161, 172), new FlxPoint(202, 181), new FlxPoint(237, 170), new FlxPoint(250, 217), new FlxPoint(190, 238)];
			mouthPolyArray[26] = [new FlxPoint(132, 223), new FlxPoint(124, 192), new FlxPoint(148, 176), new FlxPoint(214, 187), new FlxPoint(211, 249), new FlxPoint(143, 250)];
			mouthPolyArray[27] = [new FlxPoint(132, 223), new FlxPoint(124, 192), new FlxPoint(148, 176), new FlxPoint(214, 187), new FlxPoint(211, 249), new FlxPoint(143, 250)];
			mouthPolyArray[28] = [new FlxPoint(115, 211), new FlxPoint(161, 186), new FlxPoint(210, 192), new FlxPoint(216, 234), new FlxPoint(168, 268)];
			mouthPolyArray[29] = [new FlxPoint(115, 211), new FlxPoint(161, 186), new FlxPoint(210, 192), new FlxPoint(216, 234), new FlxPoint(168, 268)];
			mouthPolyArray[32] = [new FlxPoint(132, 223), new FlxPoint(133, 187), new FlxPoint(179, 194), new FlxPoint(213, 161), new FlxPoint(244, 161), new FlxPoint(252, 228)];
			mouthPolyArray[33] = [new FlxPoint(132, 223), new FlxPoint(133, 187), new FlxPoint(179, 194), new FlxPoint(213, 161), new FlxPoint(244, 161), new FlxPoint(252, 228)];
			mouthPolyArray[34] = [new FlxPoint(81, 118), new FlxPoint(106, 127), new FlxPoint(162, 140), new FlxPoint(156, 190), new FlxPoint(77, 169)];
			mouthPolyArray[35] = [new FlxPoint(81, 118), new FlxPoint(106, 127), new FlxPoint(162, 140), new FlxPoint(156, 190), new FlxPoint(77, 169)];
			mouthPolyArray[40] = [new FlxPoint(110, 208), new FlxPoint(156, 174), new FlxPoint(181, 183), new FlxPoint(206, 165), new FlxPoint(237, 174), new FlxPoint(244, 207), new FlxPoint(186, 255)];
			mouthPolyArray[41] = [new FlxPoint(110, 208), new FlxPoint(156, 174), new FlxPoint(181, 183), new FlxPoint(206, 165), new FlxPoint(237, 174), new FlxPoint(244, 207), new FlxPoint(186, 255)];
			mouthPolyArray[42] = [new FlxPoint(111, 193), new FlxPoint(142, 195), new FlxPoint(184, 175), new FlxPoint(226, 210), new FlxPoint(164, 269)];
			mouthPolyArray[43] = [new FlxPoint(111, 193), new FlxPoint(142, 195), new FlxPoint(184, 175), new FlxPoint(226, 210), new FlxPoint(164, 269)];

			scalpPolyArray = new Array<Array<FlxPoint>>();
			scalpPolyArray[0] = [new FlxPoint(70, 135), new FlxPoint(169, 170), new FlxPoint(281, 138), new FlxPoint(286, 66), new FlxPoint(70, 65)];
			scalpPolyArray[1] = [new FlxPoint(101, 144), new FlxPoint(196, 154), new FlxPoint(270, 131), new FlxPoint(285, 58), new FlxPoint(66, 60)];
			scalpPolyArray[2] = [new FlxPoint(98, 149), new FlxPoint(195, 153), new FlxPoint(272, 131), new FlxPoint(295, 57), new FlxPoint(58, 66)];
			scalpPolyArray[8] = [new FlxPoint(112, 108), new FlxPoint(255, 132), new FlxPoint(285, 53), new FlxPoint(106, 53)];
			scalpPolyArray[9] = [new FlxPoint(112, 108), new FlxPoint(255, 132), new FlxPoint(285, 53), new FlxPoint(106, 53)];
			scalpPolyArray[10] = [new FlxPoint(102, 152), new FlxPoint(179, 166), new FlxPoint(258, 121), new FlxPoint(272, 53), new FlxPoint(57, 56)];
			scalpPolyArray[11] = [new FlxPoint(102, 152), new FlxPoint(179, 166), new FlxPoint(258, 121), new FlxPoint(272, 53), new FlxPoint(57, 56)];
			scalpPolyArray[12] = [new FlxPoint(140, 169), new FlxPoint(255, 128), new FlxPoint(267, 54), new FlxPoint(71, 55), new FlxPoint(87, 145)];
			scalpPolyArray[13] = [new FlxPoint(140, 169), new FlxPoint(255, 128), new FlxPoint(267, 54), new FlxPoint(71, 55), new FlxPoint(87, 145)];
			scalpPolyArray[16] = [new FlxPoint(107, 115), new FlxPoint(239, 137), new FlxPoint(280, 53), new FlxPoint(103, 53)];
			scalpPolyArray[17] = [new FlxPoint(107, 115), new FlxPoint(239, 137), new FlxPoint(280, 53), new FlxPoint(103, 53)];
			scalpPolyArray[18] = [new FlxPoint(177, 156), new FlxPoint(264, 122), new FlxPoint(271, 53), new FlxPoint(43, 55), new FlxPoint(85, 158)];
			scalpPolyArray[19] = [new FlxPoint(177, 156), new FlxPoint(264, 122), new FlxPoint(271, 53), new FlxPoint(43, 55), new FlxPoint(85, 158)];
			scalpPolyArray[20] = [new FlxPoint(172, 177), new FlxPoint(263, 139), new FlxPoint(279, 60), new FlxPoint(68, 62), new FlxPoint(82, 145)];
			scalpPolyArray[21] = [new FlxPoint(172, 177), new FlxPoint(263, 139), new FlxPoint(279, 60), new FlxPoint(68, 62), new FlxPoint(82, 145)];
			scalpPolyArray[24] = [new FlxPoint(194, 161), new FlxPoint(263, 137), new FlxPoint(284, 53), new FlxPoint(60, 55), new FlxPoint(103, 142)];
			scalpPolyArray[25] = [new FlxPoint(194, 161), new FlxPoint(263, 137), new FlxPoint(284, 53), new FlxPoint(60, 55), new FlxPoint(103, 142)];
			scalpPolyArray[26] = [new FlxPoint(141, 167), new FlxPoint(251, 125), new FlxPoint(264, 53), new FlxPoint(80, 56), new FlxPoint(83, 139)];
			scalpPolyArray[27] = [new FlxPoint(141, 167), new FlxPoint(251, 125), new FlxPoint(264, 53), new FlxPoint(80, 56), new FlxPoint(83, 139)];
			scalpPolyArray[28] = [new FlxPoint(170, 180), new FlxPoint(257, 144), new FlxPoint(282, 64), new FlxPoint(67, 62), new FlxPoint(76, 143)];
			scalpPolyArray[29] = [new FlxPoint(170, 180), new FlxPoint(257, 144), new FlxPoint(282, 64), new FlxPoint(67, 62), new FlxPoint(76, 143)];
			scalpPolyArray[32] = [new FlxPoint(179, 167), new FlxPoint(255, 126), new FlxPoint(269, 53), new FlxPoint(63, 57), new FlxPoint(80, 146)];
			scalpPolyArray[33] = [new FlxPoint(179, 167), new FlxPoint(255, 126), new FlxPoint(269, 53), new FlxPoint(63, 57), new FlxPoint(80, 146)];
			scalpPolyArray[34] = [new FlxPoint(109, 111), new FlxPoint(247, 136), new FlxPoint(281, 53), new FlxPoint(92, 56)];
			scalpPolyArray[35] = [new FlxPoint(109, 111), new FlxPoint(247, 136), new FlxPoint(281, 53), new FlxPoint(92, 56)];
			scalpPolyArray[37] = [new FlxPoint(193, 161), new FlxPoint(268, 121), new FlxPoint(284, 57), new FlxPoint(56, 56), new FlxPoint(76, 143)];
			scalpPolyArray[38] = [new FlxPoint(193, 161), new FlxPoint(268, 121), new FlxPoint(284, 57), new FlxPoint(56, 56), new FlxPoint(76, 143)];
			scalpPolyArray[39] = [new FlxPoint(193, 161), new FlxPoint(268, 121), new FlxPoint(284, 57), new FlxPoint(56, 56), new FlxPoint(76, 143)];
			scalpPolyArray[40] = [new FlxPoint(178, 160), new FlxPoint(255, 127), new FlxPoint(274, 53), new FlxPoint(60, 59), new FlxPoint(89, 147)];
			scalpPolyArray[41] = [new FlxPoint(178, 160), new FlxPoint(255, 127), new FlxPoint(274, 53), new FlxPoint(60, 59), new FlxPoint(89, 147)];
			scalpPolyArray[42] = [new FlxPoint(142, 173), new FlxPoint(257, 125), new FlxPoint(271, 53), new FlxPoint(65, 55), new FlxPoint(79, 141)];
			scalpPolyArray[43] = [new FlxPoint(142, 173), new FlxPoint(257, 125), new FlxPoint(271, 53), new FlxPoint(65, 55), new FlxPoint(79, 141)];

			vagPolyArray = new Array<Array<FlxPoint>>();
			vagPolyArray[0] = [new FlxPoint(191, 373), new FlxPoint(165, 372), new FlxPoint(162, 347), new FlxPoint(191, 347)];

			assPolyArray = new Array<Array<FlxPoint>>();
			assPolyArray[0] = [new FlxPoint(123, 372), new FlxPoint(124, 406), new FlxPoint(159, 422), new FlxPoint(198, 416), new FlxPoint(226, 385), new FlxPoint(223, 367)];

			leftLegPolyArray = new Array<Array<FlxPoint>>();
			leftLegPolyArray[0] = [new FlxPoint(172, 554), new FlxPoint(-202, 554), new FlxPoint(-202, 304), new FlxPoint(52, 329), new FlxPoint(126, 370), new FlxPoint(169, 449)];
			leftLegPolyArray[1] = [new FlxPoint(172, 554), new FlxPoint(-202, 554), new FlxPoint(-202, 304), new FlxPoint(100, 310), new FlxPoint(143, 353), new FlxPoint(170, 460)];
			leftLegPolyArray[2] = [new FlxPoint(172, 554), new FlxPoint(-202, 554), new FlxPoint(-202, 304), new FlxPoint(65, 314), new FlxPoint(111, 341), new FlxPoint(169, 461)];
			leftLegPolyArray[4] = [new FlxPoint(172, 554), new FlxPoint(-202, 554), new FlxPoint(-202, 304), new FlxPoint(62, 272), new FlxPoint(116, 278), new FlxPoint(145, 335), new FlxPoint(175, 450)];
			leftLegPolyArray[5] = [new FlxPoint(172, 554), new FlxPoint(-202, 554), new FlxPoint(-202, 304), new FlxPoint(67, 301), new FlxPoint(112, 370), new FlxPoint(169, 461)];

			rightLegPolyArray = new Array<Array<FlxPoint>>();
			rightLegPolyArray[0] = [new FlxPoint(172, 554), new FlxPoint(566, 554), new FlxPoint(566, 304), new FlxPoint(330, 357), new FlxPoint(220, 371), new FlxPoint(178, 456)];
			rightLegPolyArray[1] = [new FlxPoint(172, 554), new FlxPoint(566, 554), new FlxPoint(566, 304), new FlxPoint(305, 316), new FlxPoint(250, 364), new FlxPoint(172, 427), new FlxPoint(173, 469)];
			rightLegPolyArray[2] = [new FlxPoint(172, 554), new FlxPoint(566, 554), new FlxPoint(566, 304), new FlxPoint(289, 337), new FlxPoint(240, 378), new FlxPoint(179, 460)];
			rightLegPolyArray[4] = [new FlxPoint(172, 554), new FlxPoint(566, 554), new FlxPoint(566, 304), new FlxPoint(289, 298), new FlxPoint(243, 369), new FlxPoint(179, 463)];
			rightLegPolyArray[5] = [new FlxPoint(172, 554), new FlxPoint(566, 554), new FlxPoint(566, 304), new FlxPoint(294, 274), new FlxPoint(243, 277), new FlxPoint(212, 346), new FlxPoint(172, 459)];

			shoulderPolyArray = new Array<Array<FlxPoint>>();
			shoulderPolyArray[0] = [new FlxPoint(89, 249), new FlxPoint(150, 244), new FlxPoint(157, 207), new FlxPoint(152, 128), new FlxPoint(197, 135), new FlxPoint(201, 238), new FlxPoint(264, 255), new FlxPoint(270, 209), new FlxPoint(258, 113), new FlxPoint(85, 112), new FlxPoint(83, 221)];
			shoulderPolyArray[1] = [new FlxPoint(81, 231), new FlxPoint(149, 258), new FlxPoint(163, 227), new FlxPoint(157, 101), new FlxPoint(194, 103), new FlxPoint(199, 211), new FlxPoint(219, 228), new FlxPoint(268, 208), new FlxPoint(268, 81), new FlxPoint(76, 83)];
			shoulderPolyArray[2] = [new FlxPoint(76, 228), new FlxPoint(119, 262), new FlxPoint(137, 255), new FlxPoint(148, 217), new FlxPoint(147, 116), new FlxPoint(210, 121), new FlxPoint(208, 228), new FlxPoint(224, 257), new FlxPoint(270, 243), new FlxPoint(271, 111), new FlxPoint(84, 105)];
			shoulderPolyArray[4] = [new FlxPoint(79, 244), new FlxPoint(120, 263), new FlxPoint(139, 238), new FlxPoint(141, 123), new FlxPoint(198, 129), new FlxPoint(204, 221), new FlxPoint(219, 258), new FlxPoint(271, 232), new FlxPoint(271, 120), new FlxPoint(78, 112)];
			shoulderPolyArray[5] = [new FlxPoint(74, 221), new FlxPoint(88, 233), new FlxPoint(127, 254), new FlxPoint(150, 214), new FlxPoint(151, 116), new FlxPoint(208, 122), new FlxPoint(209, 227), new FlxPoint(228, 260), new FlxPoint(272, 241), new FlxPoint(265, 120), new FlxPoint(76, 105)];
			shoulderPolyArray[6] = [new FlxPoint(79, 241), new FlxPoint(122, 262), new FlxPoint(143, 233), new FlxPoint(148, 133), new FlxPoint(202, 141), new FlxPoint(200, 218), new FlxPoint(224, 256), new FlxPoint(276, 222), new FlxPoint(275, 135), new FlxPoint(75, 124)];

			bellyPolyArray = new Array<Array<FlxPoint>>();
			bellyPolyArray[0] = [new FlxPoint(116, 280), new FlxPoint(173, 269), new FlxPoint(236, 284), new FlxPoint(215, 336), new FlxPoint(139, 333)];

			chestTorsoPolyArray = new Array<Array<FlxPoint>>();
			chestTorsoPolyArray[0] = [new FlxPoint(117, 282), new FlxPoint(108, 193), new FlxPoint(250, 190), new FlxPoint(236, 282)];

			chestArmsPolyArray = new Array<Array<FlxPoint>>();
			chestArmsPolyArray[0] = [new FlxPoint(149, 229), new FlxPoint(153, 182), new FlxPoint(207, 180), new FlxPoint(204, 223)];
			chestArmsPolyArray[1] = [new FlxPoint(153, 248), new FlxPoint(157, 171), new FlxPoint(201, 168), new FlxPoint(222, 230)];
			chestArmsPolyArray[2] = [new FlxPoint(142, 239), new FlxPoint(144, 183), new FlxPoint(217, 188), new FlxPoint(213, 240)];
			chestArmsPolyArray[4] = [new FlxPoint(137, 241), new FlxPoint(132, 187), new FlxPoint(215, 187), new FlxPoint(209, 237)];
			chestArmsPolyArray[5] = [new FlxPoint(144, 241), new FlxPoint(139, 185), new FlxPoint(220, 187), new FlxPoint(213, 240)];
			chestArmsPolyArray[6] = [new FlxPoint(138, 240), new FlxPoint(131, 186), new FlxPoint(210, 182), new FlxPoint(209, 239)];

			if (_male)
			{
				// cock squirt angle
				dickAngleArray[0] = [new FlxPoint(162, 364), new FlxPoint(-43, 256), new FlxPoint(-73, 249)];
				dickAngleArray[1] = [new FlxPoint(147, 349), new FlxPoint(-234, 113), new FlxPoint(-257, 40)];
				dickAngleArray[2] = [new FlxPoint(157, 312), new FlxPoint(-60, -253), new FlxPoint(-106, -238)];
				dickAngleArray[4] = [new FlxPoint(147, 350), new FlxPoint(-220, 138), new FlxPoint(-254, 54)];
				dickAngleArray[5] = [new FlxPoint(142, 344), new FlxPoint(-259, 16), new FlxPoint(-204, -161)];
				dickAngleArray[6] = [new FlxPoint(139, 343), new FlxPoint(-208, 156), new FlxPoint(-197, -169)];
				dickAngleArray[8] = [new FlxPoint(154, 314), new FlxPoint(-149, -213), new FlxPoint(-91, -243)];
				dickAngleArray[9] = [new FlxPoint(155, 309), new FlxPoint(-98, -241), new FlxPoint(-37, -257)];
				dickAngleArray[10] = [new FlxPoint(154, 305), new FlxPoint(-100, -240), new FlxPoint(-54, -254)];
				dickAngleArray[11] = [new FlxPoint(156, 301), new FlxPoint(-69, -251), new FlxPoint(-16, -260)];
				dickAngleArray[12] = [new FlxPoint(159, 294), new FlxPoint( -37, -257), new FlxPoint(15, -260)];
			}
			else
			{
				// vagina squirt angle
				dickAngleArray[0] = [new FlxPoint(173, 362), new FlxPoint(111, 235), new FlxPoint(-122, 230)];
				dickAngleArray[1] = [new FlxPoint(173, 362), new FlxPoint(111, 235), new FlxPoint(-122, 230)];
				dickAngleArray[2] = [new FlxPoint(173, 362), new FlxPoint(111, 235), new FlxPoint(-122, 230)];
				dickAngleArray[3] = [new FlxPoint(173, 362), new FlxPoint(111, 235), new FlxPoint(-122, 230)];
				dickAngleArray[4] = [new FlxPoint(173, 362), new FlxPoint(111, 235), new FlxPoint(-122, 230)];
				dickAngleArray[5] = [new FlxPoint(173, 362), new FlxPoint(111, 235), new FlxPoint(-122, 230)];
				dickAngleArray[6] = [new FlxPoint(173, 362), new FlxPoint(111, 235), new FlxPoint(-122, 230)];
				dickAngleArray[8] = [new FlxPoint(173, 362), new FlxPoint(111, 235), new FlxPoint(-132, 224)];
				dickAngleArray[9] = [new FlxPoint(173, 362), new FlxPoint(116, 233), new FlxPoint(-147, 214)];
				dickAngleArray[10] = [new FlxPoint(173, 362), new FlxPoint(136, 222), new FlxPoint(-156, 208)];
				dickAngleArray[11] = [new FlxPoint(173, 362), new FlxPoint(168, 198), new FlxPoint(-198, 168)];
				dickAngleArray[12] = [new FlxPoint(173, 362), new FlxPoint(202, 163), new FlxPoint(-212, 150)];
				dickAngleArray[16] = [new FlxPoint(173, 362), new FlxPoint(130, 225), new FlxPoint(-111, 235)];
				dickAngleArray[17] = [new FlxPoint(173, 362), new FlxPoint(161, 204), new FlxPoint(-152, 211)];
				dickAngleArray[18] = [new FlxPoint(173, 362), new FlxPoint(159, 206), new FlxPoint(-173, 194)];
				dickAngleArray[19] = [new FlxPoint(173, 362), new FlxPoint(166, 200), new FlxPoint(-192, 175)];
				dickAngleArray[20] = [new FlxPoint(173, 362), new FlxPoint(197, 170), new FlxPoint(-194, 173)];
				dickAngleArray[21] = [new FlxPoint(173, 362), new FlxPoint(223, 134), new FlxPoint(-231, 119)];
			}

			breathAngleArray[0] = [new FlxPoint(166, 217), new FlxPoint(-6, 80)];
			breathAngleArray[1] = [new FlxPoint(201, 196), new FlxPoint(69, 41)];
			breathAngleArray[2] = [new FlxPoint(201, 196), new FlxPoint(69, 41)];
			breathAngleArray[8] = [new FlxPoint(96, 143), new FlxPoint(-71, -38)];
			breathAngleArray[9] = [new FlxPoint(96, 143), new FlxPoint(-71, -38)];
			breathAngleArray[10] = [new FlxPoint(184, 197), new FlxPoint(33, 73)];
			breathAngleArray[11] = [new FlxPoint(184, 197), new FlxPoint(33, 73)];
			breathAngleArray[12] = [new FlxPoint(158, 209), new FlxPoint(-18, 78)];
			breathAngleArray[13] = [new FlxPoint(158, 209), new FlxPoint(-18, 78)];
			breathAngleArray[16] = [new FlxPoint(96, 146), new FlxPoint(-69, -40)];
			breathAngleArray[17] = [new FlxPoint(96, 146), new FlxPoint(-69, -40)];
			breathAngleArray[18] = [new FlxPoint(185, 202), new FlxPoint(28, 75)];
			breathAngleArray[19] = [new FlxPoint(185, 202), new FlxPoint(28, 75)];
			breathAngleArray[20] = [new FlxPoint(167, 220), new FlxPoint(0, 80)];
			breathAngleArray[21] = [new FlxPoint(167, 220), new FlxPoint(0, 80)];
			breathAngleArray[24] = [new FlxPoint(198, 208), new FlxPoint(55, 58)];
			breathAngleArray[25] = [new FlxPoint(198, 208), new FlxPoint(55, 58)];
			breathAngleArray[26] = [new FlxPoint(164, 213), new FlxPoint(-22, 77)];
			breathAngleArray[26] = [new FlxPoint(149, 217), new FlxPoint(-32, 74)];
			breathAngleArray[27] = [new FlxPoint(149, 217), new FlxPoint(-32, 74)];
			breathAngleArray[28] = [new FlxPoint(169, 227), new FlxPoint(-3, 80)];
			breathAngleArray[29] = [new FlxPoint(169, 227), new FlxPoint(-3, 80)];
			breathAngleArray[32] = [new FlxPoint(188, 208), new FlxPoint(27, 75)];
			breathAngleArray[33] = [new FlxPoint(188, 208), new FlxPoint(27, 75)];
			breathAngleArray[34] = [new FlxPoint(89, 141), new FlxPoint(-73, -34)];
			breathAngleArray[34] = [new FlxPoint(83, 126), new FlxPoint(-67, -43)];
			breathAngleArray[35] = [new FlxPoint(83, 126), new FlxPoint(-67, -43)];
			breathAngleArray[37] = [new FlxPoint(197, 199), new FlxPoint(63, 49)];
			breathAngleArray[37] = [new FlxPoint(207, 198), new FlxPoint(65, 46)];
			breathAngleArray[38] = [new FlxPoint(207, 198), new FlxPoint(65, 46)];
			breathAngleArray[39] = [new FlxPoint(207, 198), new FlxPoint(65, 46)];
			breathAngleArray[40] = [new FlxPoint(188, 206), new FlxPoint(22, 77)];
			breathAngleArray[41] = [new FlxPoint(188, 206), new FlxPoint(22, 77)];
			breathAngleArray[42] = [new FlxPoint(152, 216), new FlxPoint(-41, 69)];
			breathAngleArray[43] = [new FlxPoint(152, 216), new FlxPoint(-41, 69)];

			var torsoSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			torsoSweatArray[0] = [new FlxPoint(161, 325), new FlxPoint(134, 310), new FlxPoint(123, 290), new FlxPoint(124, 239), new FlxPoint(125, 208), new FlxPoint(158, 225), new FlxPoint(186, 225), new FlxPoint(231, 204), new FlxPoint(231, 286), new FlxPoint(199, 322)];

			var headSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			headSweatArray[0] = [new FlxPoint(171, 184), new FlxPoint(113, 142), new FlxPoint(142, 135), new FlxPoint(146, 94), new FlxPoint(197, 92), new FlxPoint(205, 132), new FlxPoint(241, 145)];
			headSweatArray[1] = [new FlxPoint(194, 163), new FlxPoint(158, 143), new FlxPoint(130, 139), new FlxPoint(150, 124), new FlxPoint(155, 88), new FlxPoint(213, 92), new FlxPoint(233, 119), new FlxPoint(242, 139), new FlxPoint(222, 137), new FlxPoint(212, 161)];
			headSweatArray[2] = [new FlxPoint(194, 163), new FlxPoint(158, 143), new FlxPoint(130, 139), new FlxPoint(150, 124), new FlxPoint(155, 88), new FlxPoint(213, 92), new FlxPoint(233, 119), new FlxPoint(242, 139), new FlxPoint(222, 137), new FlxPoint(212, 161)];
			headSweatArray[8] = [new FlxPoint(134, 141), new FlxPoint(132, 119), new FlxPoint(187, 97), new FlxPoint(176, 75), new FlxPoint(152, 70), new FlxPoint(107, 100), new FlxPoint(122, 121), new FlxPoint(121, 175), new FlxPoint(174, 195), new FlxPoint(226, 174), new FlxPoint(234, 147), new FlxPoint(166, 152)];
			headSweatArray[9] = [new FlxPoint(134, 141), new FlxPoint(132, 119), new FlxPoint(187, 97), new FlxPoint(176, 75), new FlxPoint(152, 70), new FlxPoint(107, 100), new FlxPoint(122, 121), new FlxPoint(121, 175), new FlxPoint(174, 195), new FlxPoint(226, 174), new FlxPoint(234, 147), new FlxPoint(166, 152)];
			headSweatArray[10] = [new FlxPoint(179, 165), new FlxPoint(120, 160), new FlxPoint(140, 99), new FlxPoint(198, 89), new FlxPoint(236, 133)];
			headSweatArray[11] = [new FlxPoint(179, 165), new FlxPoint(120, 160), new FlxPoint(140, 99), new FlxPoint(198, 89), new FlxPoint(236, 133)];
			headSweatArray[12] = [new FlxPoint(143, 167), new FlxPoint(122, 149), new FlxPoint(105, 145), new FlxPoint(128, 96), new FlxPoint(183, 81), new FlxPoint(199, 107), new FlxPoint(209, 126), new FlxPoint(251, 140), new FlxPoint(227, 149), new FlxPoint(187, 146), new FlxPoint(158, 173)];
			headSweatArray[13] = [new FlxPoint(143, 167), new FlxPoint(122, 149), new FlxPoint(105, 145), new FlxPoint(128, 96), new FlxPoint(183, 81), new FlxPoint(199, 107), new FlxPoint(209, 126), new FlxPoint(251, 140), new FlxPoint(227, 149), new FlxPoint(187, 146), new FlxPoint(158, 173)];
			headSweatArray[16] = [new FlxPoint(124, 114), new FlxPoint(108, 100), new FlxPoint(128, 78), new FlxPoint(159, 72), new FlxPoint(187, 95), new FlxPoint(154, 108), new FlxPoint(129, 132), new FlxPoint(159, 153), new FlxPoint(237, 147), new FlxPoint(216, 182), new FlxPoint(157, 194), new FlxPoint(116, 167), new FlxPoint(130, 153), new FlxPoint(121, 131)];
			headSweatArray[17] = [new FlxPoint(124, 114), new FlxPoint(108, 100), new FlxPoint(128, 78), new FlxPoint(159, 72), new FlxPoint(187, 95), new FlxPoint(154, 108), new FlxPoint(129, 132), new FlxPoint(159, 153), new FlxPoint(237, 147), new FlxPoint(216, 182), new FlxPoint(157, 194), new FlxPoint(116, 167), new FlxPoint(130, 153), new FlxPoint(121, 131)];
			headSweatArray[18] = [new FlxPoint(177, 161), new FlxPoint(153, 154), new FlxPoint(121, 154), new FlxPoint(128, 121), new FlxPoint(145, 97), new FlxPoint(197, 89), new FlxPoint(218, 109), new FlxPoint(233, 128), new FlxPoint(198, 144), new FlxPoint(190, 159)];
			headSweatArray[19] = [new FlxPoint(177, 161), new FlxPoint(153, 154), new FlxPoint(121, 154), new FlxPoint(128, 121), new FlxPoint(145, 97), new FlxPoint(197, 89), new FlxPoint(218, 109), new FlxPoint(233, 128), new FlxPoint(198, 144), new FlxPoint(190, 159)];
			headSweatArray[20] = [new FlxPoint(169, 182), new FlxPoint(152, 161), new FlxPoint(104, 153), new FlxPoint(111, 139), new FlxPoint(141, 134), new FlxPoint(147, 92), new FlxPoint(196, 95), new FlxPoint(206, 134), new FlxPoint(240, 139), new FlxPoint(239, 151), new FlxPoint(191, 158), new FlxPoint(180, 179)];
			headSweatArray[21] = [new FlxPoint(169, 182), new FlxPoint(152, 161), new FlxPoint(104, 153), new FlxPoint(111, 139), new FlxPoint(141, 134), new FlxPoint(147, 92), new FlxPoint(196, 95), new FlxPoint(206, 134), new FlxPoint(240, 139), new FlxPoint(239, 151), new FlxPoint(191, 158), new FlxPoint(180, 179)];
			headSweatArray[24] = [new FlxPoint(188, 164), new FlxPoint(163, 142), new FlxPoint(123, 147), new FlxPoint(145, 130), new FlxPoint(153, 89), new FlxPoint(213, 93), new FlxPoint(234, 122), new FlxPoint(240, 129), new FlxPoint(221, 135), new FlxPoint(214, 164)];
			headSweatArray[25] = [new FlxPoint(188, 164), new FlxPoint(163, 142), new FlxPoint(123, 147), new FlxPoint(145, 130), new FlxPoint(153, 89), new FlxPoint(213, 93), new FlxPoint(234, 122), new FlxPoint(240, 129), new FlxPoint(221, 135), new FlxPoint(214, 164)];
			headSweatArray[26] = [new FlxPoint(158, 172), new FlxPoint(133, 172), new FlxPoint(128, 153), new FlxPoint(106, 149), new FlxPoint(134, 94), new FlxPoint(181, 83), new FlxPoint(197, 115), new FlxPoint(235, 134), new FlxPoint(176, 155)];
			headSweatArray[27] = [new FlxPoint(158, 172), new FlxPoint(133, 172), new FlxPoint(128, 153), new FlxPoint(106, 149), new FlxPoint(134, 94), new FlxPoint(181, 83), new FlxPoint(197, 115), new FlxPoint(235, 134), new FlxPoint(176, 155)];
			headSweatArray[28] = [new FlxPoint(171, 181), new FlxPoint(143, 158), new FlxPoint(104, 152), new FlxPoint(114, 140), new FlxPoint(141, 135), new FlxPoint(143, 93), new FlxPoint(197, 91), new FlxPoint(204, 131), new FlxPoint(239, 138), new FlxPoint(242, 150), new FlxPoint(195, 157)];
			headSweatArray[29] = [new FlxPoint(171, 181), new FlxPoint(143, 158), new FlxPoint(104, 152), new FlxPoint(114, 140), new FlxPoint(141, 135), new FlxPoint(143, 93), new FlxPoint(197, 91), new FlxPoint(204, 131), new FlxPoint(239, 138), new FlxPoint(242, 150), new FlxPoint(195, 157)];
			headSweatArray[32] = [new FlxPoint(179, 169), new FlxPoint(148, 155), new FlxPoint(117, 154), new FlxPoint(119, 145), new FlxPoint(143, 98), new FlxPoint(198, 92), new FlxPoint(234, 131), new FlxPoint(197, 141)];
			headSweatArray[33] = [new FlxPoint(179, 169), new FlxPoint(148, 155), new FlxPoint(117, 154), new FlxPoint(119, 145), new FlxPoint(143, 98), new FlxPoint(198, 92), new FlxPoint(234, 131), new FlxPoint(197, 141)];
			headSweatArray[34] = [new FlxPoint(169, 151), new FlxPoint(210, 142), new FlxPoint(240, 153), new FlxPoint(214, 186), new FlxPoint(144, 185), new FlxPoint(153, 150), new FlxPoint(142, 141), new FlxPoint(123, 139), new FlxPoint(120, 115), new FlxPoint(107, 104), new FlxPoint(131, 80), new FlxPoint(175, 75), new FlxPoint(188, 100), new FlxPoint(208, 121), new FlxPoint(173, 108), new FlxPoint(133, 117), new FlxPoint(130, 135), new FlxPoint(142, 138)];
			headSweatArray[35] = [new FlxPoint(169, 151), new FlxPoint(210, 142), new FlxPoint(240, 153), new FlxPoint(214, 186), new FlxPoint(144, 185), new FlxPoint(153, 150), new FlxPoint(142, 141), new FlxPoint(123, 139), new FlxPoint(120, 115), new FlxPoint(107, 104), new FlxPoint(131, 80), new FlxPoint(175, 75), new FlxPoint(188, 100), new FlxPoint(208, 121), new FlxPoint(173, 108), new FlxPoint(133, 117), new FlxPoint(130, 135), new FlxPoint(142, 138)];
			headSweatArray[37] = [new FlxPoint(194, 164), new FlxPoint(163, 149), new FlxPoint(118, 144), new FlxPoint(145, 129), new FlxPoint(152, 83), new FlxPoint(214, 90), new FlxPoint(244, 133), new FlxPoint(209, 142)];
			headSweatArray[38] = [new FlxPoint(194, 164), new FlxPoint(163, 149), new FlxPoint(118, 144), new FlxPoint(145, 129), new FlxPoint(152, 83), new FlxPoint(214, 90), new FlxPoint(244, 133), new FlxPoint(209, 142)];
			headSweatArray[39] = [new FlxPoint(194, 164), new FlxPoint(163, 149), new FlxPoint(118, 144), new FlxPoint(145, 129), new FlxPoint(152, 83), new FlxPoint(214, 90), new FlxPoint(244, 133), new FlxPoint(209, 142)];
			headSweatArray[40] = [new FlxPoint(171, 163), new FlxPoint(154, 152), new FlxPoint(119, 152), new FlxPoint(144, 97), new FlxPoint(198, 89), new FlxPoint(233, 128), new FlxPoint(197, 147), new FlxPoint(195, 160)];
			headSweatArray[41] = [new FlxPoint(171, 163), new FlxPoint(154, 152), new FlxPoint(119, 152), new FlxPoint(144, 97), new FlxPoint(198, 89), new FlxPoint(233, 128), new FlxPoint(197, 147), new FlxPoint(195, 160)];
			headSweatArray[42] = [new FlxPoint(157, 176), new FlxPoint(139, 175), new FlxPoint(130, 153), new FlxPoint(104, 149), new FlxPoint(127, 97), new FlxPoint(170, 83), new FlxPoint(201, 110), new FlxPoint(225, 128), new FlxPoint(251, 136), new FlxPoint(238, 168), new FlxPoint(220, 183), new FlxPoint(215, 145), new FlxPoint(171, 151)];
			headSweatArray[43] = [new FlxPoint(157, 176), new FlxPoint(139, 175), new FlxPoint(130, 153), new FlxPoint(104, 149), new FlxPoint(127, 97), new FlxPoint(170, 83), new FlxPoint(201, 110), new FlxPoint(225, 128), new FlxPoint(251, 136), new FlxPoint(238, 168), new FlxPoint(220, 183), new FlxPoint(215, 145), new FlxPoint(171, 151)];

			sweatAreas.splice(0, sweatAreas.length);
			sweatAreas.push({chance:6, sprite:_pokeWindow._head, sweatArrayArray:headSweatArray});
			sweatAreas.push({chance:4, sprite:_pokeWindow._torso, sweatArrayArray:torsoSweatArray});
		}
		else {
			if (_male)
			{
				dickAngleArray[0] = [new FlxPoint(123, 294), new FlxPoint(-41, 257), new FlxPoint(-238, 105)];
				dickAngleArray[1] = [new FlxPoint(107, 266), new FlxPoint(-233, -116), new FlxPoint(-259, -26)];
				dickAngleArray[2] = [new FlxPoint(120, 216), new FlxPoint( -16, -259), new FlxPoint( -44, -256)];
			}
			else {
				dickAngleArray[0] = [new FlxPoint(139, 317), new FlxPoint(212, 151), new FlxPoint(-229, 122)];
				dickAngleArray[1] = [new FlxPoint(137, 316), new FlxPoint(206, 159), new FlxPoint(-243, 91)];
				dickAngleArray[2] = [new FlxPoint(136, 316), new FlxPoint(200, 166), new FlxPoint(-229, 122)];
				dickAngleArray[3] = [new FlxPoint(136, 316), new FlxPoint(214, 148), new FlxPoint(-243, 91)];
				dickAngleArray[4] = [new FlxPoint(135, 317), new FlxPoint(200, 166), new FlxPoint(-239, 102)];
				dickAngleArray[5] = [new FlxPoint(135, 316), new FlxPoint(212, 151), new FlxPoint(-229, 122)];
			}
			breathAngleArray[0] = [new FlxPoint(153, 164), new FlxPoint(-79, -11)];
			breathAngleArray[1] = [new FlxPoint(153, 164), new FlxPoint(-79, -11)];
			breathAngleArray[2] = [new FlxPoint(153, 164), new FlxPoint(-79, -11)];
			breathAngleArray[3] = [new FlxPoint(153, 164), new FlxPoint(-79, -11)];
			breathAngleArray[4] = [new FlxPoint(155, 171), new FlxPoint(-80, 1)];
			breathAngleArray[5] = [new FlxPoint(155, 171), new FlxPoint(-80, 1)];
			breathAngleArray[6] = [new FlxPoint(161, 179), new FlxPoint(-77, 21)];
			breathAngleArray[7] = [new FlxPoint(161, 179), new FlxPoint(-77, 21)];
			breathAngleArray[8] = [new FlxPoint(156, 152), new FlxPoint(-77, -22)];
			breathAngleArray[9] = [new FlxPoint(156, 152), new FlxPoint(-77, -22)];
			breathAngleArray[10] = [new FlxPoint(168, 201), new FlxPoint(-55, 58)];
			breathAngleArray[11] = [new FlxPoint(168, 201), new FlxPoint(-55, 58)];
			breathAngleArray[12] = [new FlxPoint(154, 173), new FlxPoint(-80, 8)];
			breathAngleArray[13] = [new FlxPoint(154, 173), new FlxPoint(-80, 8)];
			breathAngleArray[18] = [new FlxPoint(154, 173), new FlxPoint(-80, 8)];
			breathAngleArray[19] = [new FlxPoint(154, 173), new FlxPoint(-80, 8)];
			breathAngleArray[20] = [new FlxPoint(154, 173), new FlxPoint(-80, 8)];
			breathAngleArray[21] = [new FlxPoint(154, 173), new FlxPoint(-80, 8)];
			breathAngleArray[22] = [new FlxPoint(154, 173), new FlxPoint(-80, 8)];
			breathAngleArray[23] = [new FlxPoint(154, 173), new FlxPoint( -80, 8)];

			var torsoSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			torsoSweatArray[0] = [new FlxPoint(212, 276), new FlxPoint(213, 249), new FlxPoint(230, 205), new FlxPoint(165, 199), new FlxPoint(149, 229), new FlxPoint(133, 262)];
			torsoSweatArray[1] = [new FlxPoint(212, 276), new FlxPoint(213, 249), new FlxPoint(230, 205), new FlxPoint(164, 201), new FlxPoint(141, 244), new FlxPoint(125, 267)];
			torsoSweatArray[2] = [new FlxPoint(212, 276), new FlxPoint(213, 249), new FlxPoint(230, 205), new FlxPoint(164, 201), new FlxPoint(142, 239), new FlxPoint(121, 258), new FlxPoint(111, 279), new FlxPoint(139, 263)];
			torsoSweatArray[3] = [new FlxPoint(212, 276), new FlxPoint(213, 249), new FlxPoint(230, 205), new FlxPoint(164, 201), new FlxPoint(142, 239), new FlxPoint(128, 245), new FlxPoint(108, 276), new FlxPoint(141, 260)];
			torsoSweatArray[4] = [new FlxPoint(212, 276), new FlxPoint(213, 249), new FlxPoint(230, 205), new FlxPoint(164, 201), new FlxPoint(140, 234), new FlxPoint(123, 244), new FlxPoint(102, 274), new FlxPoint(140, 263)];
			torsoSweatArray[5] = [new FlxPoint(212, 276), new FlxPoint(213, 249), new FlxPoint(230, 205), new FlxPoint(164, 201), new FlxPoint(148, 226), new FlxPoint(128, 234), new FlxPoint(109, 247), new FlxPoint(96, 280), new FlxPoint(139, 264)];

			var headSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			headSweatArray[0] = [new FlxPoint(151, 128), new FlxPoint(179, 139), new FlxPoint(209, 142), new FlxPoint(270, 138), new FlxPoint(251, 90), new FlxPoint(212, 79), new FlxPoint(172, 92)];
			headSweatArray[1] = [new FlxPoint(151, 128), new FlxPoint(179, 139), new FlxPoint(209, 142), new FlxPoint(270, 138), new FlxPoint(251, 90), new FlxPoint(212, 79), new FlxPoint(172, 92)];
			headSweatArray[2] = [new FlxPoint(151, 128), new FlxPoint(179, 139), new FlxPoint(209, 142), new FlxPoint(270, 138), new FlxPoint(251, 90), new FlxPoint(212, 79), new FlxPoint(172, 92)];
			headSweatArray[3] = [new FlxPoint(151, 128), new FlxPoint(179, 139), new FlxPoint(209, 142), new FlxPoint(270, 138), new FlxPoint(251, 90), new FlxPoint(212, 79), new FlxPoint(172, 92)];
			headSweatArray[4] = [new FlxPoint(151, 128), new FlxPoint(179, 139), new FlxPoint(209, 142), new FlxPoint(270, 138), new FlxPoint(251, 90), new FlxPoint(212, 79), new FlxPoint(172, 92)];
			headSweatArray[5] = [new FlxPoint(151, 128), new FlxPoint(179, 139), new FlxPoint(209, 142), new FlxPoint(270, 138), new FlxPoint(251, 90), new FlxPoint(212, 79), new FlxPoint(172, 92)];
			headSweatArray[6] = [new FlxPoint(151, 128), new FlxPoint(179, 139), new FlxPoint(209, 142), new FlxPoint(270, 138), new FlxPoint(251, 90), new FlxPoint(212, 79), new FlxPoint(172, 92)];
			headSweatArray[7] = [new FlxPoint(151, 128), new FlxPoint(179, 139), new FlxPoint(209, 142), new FlxPoint(270, 138), new FlxPoint(251, 90), new FlxPoint(212, 79), new FlxPoint(172, 92)];
			headSweatArray[8] = [new FlxPoint(151, 128), new FlxPoint(179, 139), new FlxPoint(209, 142), new FlxPoint(270, 138), new FlxPoint(251, 90), new FlxPoint(212, 79), new FlxPoint(172, 92)];
			headSweatArray[9] = [new FlxPoint(151, 128), new FlxPoint(179, 139), new FlxPoint(209, 142), new FlxPoint(270, 138), new FlxPoint(251, 90), new FlxPoint(212, 79), new FlxPoint(172, 92)];
			headSweatArray[10] = [new FlxPoint(151, 128), new FlxPoint(179, 139), new FlxPoint(209, 142), new FlxPoint(270, 138), new FlxPoint(251, 90), new FlxPoint(212, 79), new FlxPoint(172, 92)];
			headSweatArray[11] = [new FlxPoint(151, 128), new FlxPoint(179, 139), new FlxPoint(209, 142), new FlxPoint(270, 138), new FlxPoint(251, 90), new FlxPoint(212, 79), new FlxPoint(172, 92)];
			headSweatArray[12] = [new FlxPoint(154, 118), new FlxPoint(174, 124), new FlxPoint(221, 125), new FlxPoint(262, 121), new FlxPoint(248, 88), new FlxPoint(204, 78), new FlxPoint(176, 90)];
			headSweatArray[13] = [new FlxPoint(154, 118), new FlxPoint(174, 124), new FlxPoint(221, 125), new FlxPoint(262, 121), new FlxPoint(248, 88), new FlxPoint(204, 78), new FlxPoint(176, 90)];
			headSweatArray[18] = [new FlxPoint(154, 118), new FlxPoint(174, 124), new FlxPoint(221, 125), new FlxPoint(262, 121), new FlxPoint(248, 88), new FlxPoint(204, 78), new FlxPoint(176, 90)];
			headSweatArray[19] = [new FlxPoint(154, 118), new FlxPoint(174, 124), new FlxPoint(221, 125), new FlxPoint(262, 121), new FlxPoint(248, 88), new FlxPoint(204, 78), new FlxPoint(176, 90)];
			headSweatArray[20] = [new FlxPoint(154, 118), new FlxPoint(174, 124), new FlxPoint(221, 125), new FlxPoint(262, 121), new FlxPoint(248, 88), new FlxPoint(204, 78), new FlxPoint(176, 90)];
			headSweatArray[21] = [new FlxPoint(154, 118), new FlxPoint(174, 124), new FlxPoint(221, 125), new FlxPoint(262, 121), new FlxPoint(248, 88), new FlxPoint(204, 78), new FlxPoint(176, 90)];
			headSweatArray[22] = [new FlxPoint(154, 118), new FlxPoint(174, 124), new FlxPoint(221, 125), new FlxPoint(262, 121), new FlxPoint(248, 88), new FlxPoint(204, 78), new FlxPoint(176, 90)];
			headSweatArray[23] = [new FlxPoint(154, 118), new FlxPoint(174, 124), new FlxPoint(221, 125), new FlxPoint(262, 121), new FlxPoint(248, 88), new FlxPoint(204, 78), new FlxPoint(176, 90)];

			sweatAreas.splice(0, sweatAreas.length);
			sweatAreas.push({chance:6, sprite:_toyWindow._head, sweatArrayArray:headSweatArray});
			sweatAreas.push({chance:4, sprite:_toyWindow._body, sweatArrayArray:torsoSweatArray});
		}

		encouragementWords = wordManager.newWords();
		encouragementWords.words.push([ { graphic:AssetPaths.abra_words_small__png, frame:0 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.abra_words_small__png, frame:1 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.abra_words_small__png, frame:2 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.abra_words_small__png, frame:3 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.abra_words_small__png, frame:4 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.abra_words_small__png, frame:5 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.abra_words_small__png, frame:6 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.abra_words_small__png, frame:7 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.abra_words_small__png, frame:8 } ]);

		boredWords = wordManager.newWords(6);
		boredWords.words.push([{ graphic:AssetPaths.abra_words_small__png, frame:15 }]);
		boredWords.words.push([{ graphic:AssetPaths.abra_words_small__png, frame:17 }]);
		boredWords.words.push([{ graphic:AssetPaths.abra_words_small__png, frame:19 }]);
		// what are you doing?
		boredWords.words.push([
		{ graphic:AssetPaths.abra_words_small__png, frame:18 },
		{ graphic:AssetPaths.abra_words_small__png, frame:20, yOffset:16, delay:0.5 }
		]);

		// pick it up a little
		tooSlowWords = wordManager.newWords(18);
		tooSlowWords.words.push([
		{ graphic:AssetPaths.abra_words_small__png, frame:9 },
		{ graphic:AssetPaths.abra_words_small__png, frame:11, yOffset:16, delay:0.5 }
		]);
		// a little faster, c'mon
		tooSlowWords.words.push([
		{ graphic:AssetPaths.abra_words_small__png, frame:10 },
		{ graphic:AssetPaths.abra_words_small__png, frame:12, yOffset:16, delay:0.5 }
		]);
		// a little faster~
		tooSlowWords.words.push([
		{ graphic:AssetPaths.abra_words_small__png, frame:13 }
		]);
		// hey c'mon already!!
		tooSlowWords.words.push([
		{ graphic:AssetPaths.abra_words_small__png, frame:14 },
		{ graphic:AssetPaths.abra_words_small__png, frame:16, yOffset:16, delay:0.5 }
		]);

		// ah!! take it easy
		tooFastWords = wordManager.newWords();
		tooFastWords.words.push([
		{ graphic:AssetPaths.abra_words_small__png, frame:21 },
		{ graphic:AssetPaths.abra_words_small__png, frame:23, yOffset:16, delay:0.5 }
		]);
		// nng- not so fast
		tooFastWords.words.push([
		{ graphic:AssetPaths.abra_words_small__png, frame:22 },
		{ graphic:AssetPaths.abra_words_small__png, frame:24, yOffset:16, delay:0.5 }
		]);
		// s-slow down...
		tooFastWords.words.push([
		{ graphic:AssetPaths.abra_words_small__png, frame:25 },
		{ graphic:AssetPaths.abra_words_small__png, frame:27, yOffset:16, delay:0.5 }
		]);
		// hey! ...you're going to break it!
		tooFastWords.words.push([
		{ graphic:AssetPaths.abra_words_small__png, frame:26 },
		{ graphic:AssetPaths.abra_words_small__png, frame:28, yOffset:19, delay:0.5 },
		{ graphic:AssetPaths.abra_words_small__png, frame:30, yOffset:35, delay:1.0 }
		]);

		toyStartWords.words.push([ // anal beads, hmm? ...that sounds like fun~
		{ graphic:AssetPaths.abrabeads_words_small__png, frame:0 },
		{ graphic:AssetPaths.abrabeads_words_small__png, frame:2, yOffset:16, delay:1.5 },
		{ graphic:AssetPaths.abrabeads_words_small__png, frame:4, yOffset:32, delay:2.1 },
		]);
		toyStartWords.words.push([ // ooh, let me get into a more comfortable position...
		{ graphic:AssetPaths.abrabeads_words_small__png, frame:1 },
		{ graphic:AssetPaths.abrabeads_words_small__png, frame:3, yOffset:21, delay:0.8 },
		{ graphic:AssetPaths.abrabeads_words_small__png, frame:5, yOffset:36, delay:1.6 },
		{ graphic:AssetPaths.abrabeads_words_small__png, frame:7, yOffset:55, delay:2.2 },
		]);
		toyStartWords.words.push([ // mmm... very well. ...just try to be gentle.
		{ graphic:AssetPaths.abrabeads_words_small__png, frame:6 },
		{ graphic:AssetPaths.abrabeads_words_small__png, frame:8, yOffset:22, delay:1.5 },
		{ graphic:AssetPaths.abrabeads_words_small__png, frame:10, yOffset:44, delay:2.0 },
		]);

		toyInterruptWords.words.push([ // oh... finished already?
		{graphic:AssetPaths.abrabeads_words_small__png, frame:9 },
		{graphic:AssetPaths.abrabeads_words_small__png, frame:11, yOffset:25, delay: 0.5 },
		]);
		toyInterruptWords.words.push([ // hmmm? ...is that all?
		{graphic:AssetPaths.abrabeads_words_small__png, frame:12 },
		{graphic:AssetPaths.abrabeads_words_small__png, frame:14, yOffset:22, delay: 0.5 },
		]);
		toyInterruptWords.words.push([ // oh... you're done with the beads?
		{graphic:AssetPaths.abrabeads_words_small__png, frame:13 },
		{graphic:AssetPaths.abrabeads_words_small__png, frame:15, yOffset:16, delay: 0.8 },
		{graphic:AssetPaths.abrabeads_words_small__png, frame:17, yOffset:36, delay: 1.4 },
		]);

		toyTooManyWords = wordManager.newWords(20);
		toyTooManyWords.words.push([ // okay... i think that's plenty
		{graphic:AssetPaths.abrabeads_words_small__png, frame:16 },
		{graphic:AssetPaths.abrabeads_words_small__png, frame:18, yOffset:20, delay: 0.6 },
		]);
		toyTooManyWords.words.push([ // rrrrrgh.... c'mon cut it out
		{graphic:AssetPaths.abrabeads_words_small__png, frame:19 },
		{graphic:AssetPaths.abrabeads_words_small__png, frame:21, yOffset:18, delay: 0.6 },
		]);
		toyTooManyWords.words.push([ // ...a little overboard, don't you think?
		{graphic:AssetPaths.abrabeads_words_small__png, frame:20 },
		{graphic:AssetPaths.abrabeads_words_small__png, frame:22, yOffset:20, delay: 0.6 },
		{graphic:AssetPaths.abrabeads_words_small__png, frame:24, yOffset:40, delay: 1.2 },
		]);

		toyWayTooManyWords = wordManager.newWords(20);
		toyWayTooManyWords.words.push([ // ....so this.... this is how it ends.... gaaah....
		{graphic:AssetPaths.abrabeads_words_small__png, frame:26 },
		{graphic:AssetPaths.abrabeads_words_small__png, frame:28, yOffset:18, delay: 1.8 },
		{graphic:AssetPaths.abrabeads_words_small__png, frame:30, yOffset:38, delay: 2.6 },
		]);
		toyWayTooManyWords.words.push([ // ...i... i don't feel so good....
		{graphic:AssetPaths.abrabeads_words_small__png, frame:23 },
		{graphic:AssetPaths.abrabeads_words_small__png, frame:25, yOffset:0, delay: 1.4 },
		{graphic:AssetPaths.abrabeads_words_small__png, frame:27, yOffset:20, delay: 2.2 },
		]);
		toyWayTooManyWords.words.push([ // no... no more beads... gllgh
		{graphic:AssetPaths.abrabeads_words_small__png, frame:29, chunkSize:3 },
		{graphic:AssetPaths.abrabeads_words_small__png, frame:31, chunkSize:3, yOffset:18, delay: 0.8 },
		]);

		orgasmWords = wordManager.newWords();
		orgasmWords.words.push([ { graphic:AssetPaths.abra_words_large__png, frame:0, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.abra_words_large__png, frame:1, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.abra_words_large__png, frame:2, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.abra_words_large__png, frame:3, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.abra_words_large__png, frame:4, width:200, height:150, yOffset: -30, chunkSize:5 } ]);

		pleasureWords = wordManager.newWords();
		pleasureWords.words.push([ { graphic:AssetPaths.abra_words_medium__png, frame:0, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.abra_words_medium__png, frame:1, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.abra_words_medium__png, frame:2, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.abra_words_medium__png, frame:3, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.abra_words_medium__png, frame:4, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.abra_words_medium__png, frame:5, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.abra_words_medium__png, frame:6, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.abra_words_medium__png, frame:7, height:48, chunkSize:5 } ]);

		almostWords = wordManager.newWords(30);
		almostWords.words.push([
		{ graphic:AssetPaths.abra_words_medium__png, frame:8, height:48, chunkSize:5 },
		{ graphic:AssetPaths.abra_words_medium__png, frame:10, height:48, chunkSize:5, yOffset:20, delay:1.4 }
		]);
		almostWords.words.push([
		{ graphic:AssetPaths.abra_words_medium__png, frame:9, height:48, chunkSize:5 },
		{ graphic:AssetPaths.abra_words_medium__png, frame:11, height:48, chunkSize:5, yOffset:20, delay:1.3 }
		]);
		almostWords.words.push([
		{ graphic:AssetPaths.abra_words_medium__png, frame:12, height:48, chunkSize:5 },
		{ graphic:AssetPaths.abra_words_medium__png, frame:14, height:48, chunkSize:5, yOffset:24, delay:1.2 }
		]);
		almostWords.words.push([
		{ graphic:AssetPaths.abra_words_medium__png, frame:13, height:48, chunkSize:5 },
		{ graphic:AssetPaths.abra_words_medium__png, frame:15, height:48, chunkSize:5, yOffset:24, delay:1.1 },
		{ graphic:AssetPaths.abra_words_medium__png, frame:17, height:48, chunkSize:5, yOffset:48, delay:2.0 }
		]);
	}

	override function penetrating():Bool
	{
		if (specialRubs.indexOf("mouth") >= 0)
		{
			return true;
		}
		if (specialRub == "ass")
		{
			return true;
		}
		if (!_male && specialRub == "jack-off")
		{
			return true;
		}
		if (!_male && specialRub == "rub-dick")
		{
			return true;
		}
		return false;
	}

	override public function computeChatComplaints(complaints:Array<Int>):Void
	{
		if (meanThings[0] == false)
		{
			complaints.push(0);
		}
		if (meanThings[1] == false && abraMood1 == false)
		{
			if (abraMood1)
			{
				complaints.push(1);
			}
			else
			{
				complaints.push(2);
			}
		}
		if (niceThings[0] == true)
		{
			if (specialRubs.indexOf("left-foot") < 0 || specialRubs.indexOf("right-foot") < 0)
			{
				complaints.push(3);
			}
			if (specialRubs.indexOf("chest") < 0)
			{
				complaints.push(4);
			}
		}
		if (niceThings[1] == true)
		{
			if (abraMood1)
			{
				complaints.push(7);
			}
			else
			{
				complaints.push(5);
			}
		}
		if (niceThings[2] == true)
		{
			complaints.push(6);
		}
	}

	override function computePrecumAmount():Int
	{
		var precumAmount:Int = 0;
		if (FlxG.random.float(1, 10) < _heartEmitCount)
		{
			precumAmount++;
		}
		if (FlxG.random.float(1, 30) < _heartEmitCount)
		{
			precumAmount++;
		}
		if (FlxG.random.float(1, 100) < _heartEmitCount + (specialRub == "ass" ? 40 : 0))
		{
			precumAmount++;
		}
		if (FlxG.random.float(0, 1.0) >= _heartBank.getDickPercent())
		{
			precumAmount++;
		}
		return precumAmount;
	}

	override function handleRubReward():Void
	{
		// first time sucking fingers?
		if (specialRubs.indexOf("mouth") == specialRubs.length - 1)
		{
			_pokeWindow._interact.animation.add("finger-ass", [16, 17, 18, 19, 20, 21]);
			_pokeWindow._ass.animation.add("finger-ass", [1, 2, 3, 4, 5, 6]);
			_dick.animation.add("finger-ass", [1, 2, 3, 4, 5, 6]);
		}
		// 2-out-of-3: rubbing each foot, rubbing chest twice
		if (niceThings[0] == true)
		{
			var criteriaCount:Int = 0;
			if (abraMood0 != 0 && specialRubs.indexOf("left-foot") >= 0)
			{
				criteriaCount++;
			}
			if (abraMood0 != 1 && specialRubs.indexOf("right-foot") >= 0)
			{
				criteriaCount++;
			}
			if (abraMood0 != 2 && specialRubs.filter(function(s) { return s == "chest"; } ).length >= 2)
			{
				criteriaCount++;
			}
			if (criteriaCount >= 2)
			{
				niceThings[0] = false;
				doNiceThing();
			}
		}
		// shoulder rubs? or fingering ass?
		if (niceThings[1] == true)
		{
			// ass
			if (abraMood1 && specialRub == "ass" && _pokeWindow._ass.animation.curAnim.numFrames > 2)
			{
				niceThings[1] = false;
				doNiceThing();
			}
			else if (!abraMood1 && specialRubs.filter(function(s) { return s == "shoulder"; } ).length >= abraMood2)
			{
				niceThings[1] = false;
				doNiceThing();
			}
		}
		// rubbing balls after erection
		if (niceThings[2] == true)
		{
			if (specialRub == "balls" && pastBonerThreshold())
			{
				niceThings[2] = false;
				doNiceThing();
			}
		}
		// rubbing head twice consecutively
		if (meanThings[0] == true)
		{
			var lastTwo:Array<String> = specialRubs.slice(-2);
			if (lastTwo.length == 2 && lastTwo[0] == "scalp" && lastTwo[1] == "scalp")
			{
				meanThings[0] = false;
				doMeanThing();
			}
		}
		// rubbing belly twice consecutively
		if (meanThings[1] == true)
		{
			if (abraMood1)
			{
				var lastTwo:Array<String> = specialRubs.slice(-2);
				if (lastTwo.length == 2 && lastTwo[0] == "belly" && lastTwo[1] == "belly")
				{
					meanThings[1] = false;
					doMeanThing();
				}
			}
			else if (specialRub == "ass")
			{
				meanThings[1] = false;
				doMeanThing();
			}
		}

		if (penetrating())
		{
			_rubRewardTimer -= 1;
		}
		_heartEmitTimer = 0;

		var amount:Float = 0;
		if (specialRub == "jack-off")
		{
			var lucky:Float = lucky(0.7, 1.43, 0.1);
			amount = SexyState.roundUpToQuarter(lucky * _heartBank._dickHeartReservoir);
			_heartBank._dickHeartReservoir -= amount;
			_heartEmitCount += amount;

			var tooSlow:Bool = false;
			var tooFast:Bool = false;
			if (mouseTiming.length <= 4)
			{
				if (patienceCount > 0)
				{
					patienceCount--;
				}
				else
				{
					tooSlow = true;
				}
			}
			else
			{
				var oldMean:Float = SexyState.average(mouseTiming.slice(0, 4));
				var newMean:Float = SexyState.average(mouseTiming.slice( -4, mouseTiming.length));
				mouseTiming.splice(0, mouseTiming.length - 4);
				if (newMean < 0.12 && almostWords.timer <= 0)
				{
					tooFast = true;
					mouseTiming.insert(0, 1000);
				}
				if (almostWords.timer > 0)
				{
					oldMean = (oldMean + 0.12) / 2;
				}
				if (!tooFast && newMean > oldMean)
				{
					if (patienceCount > 0)
					{
						patienceCount--;
					}
					else
					{
						tooSlow = true;
					}
				}
			}
			if (tooSlow)
			{
				mistakeChain = Std.int(Math.min( -1, mistakeChain - 1));
				_heartBank._dickHeartReservoirCapacity -= SexyState.roundDownToQuarter(amount * 0.8);
				_heartBank._dickHeartReservoirCapacity = Math.max(_heartBank._dickHeartReservoir, _heartBank._dickHeartReservoirCapacity);
				amount -= SexyState.roundDownToQuarter(amount * Math.max(0.99, Math.abs(mistakeChain * 0.2)));
				_autoSweatRate -= 0.04;
			}
			else if (tooFast)
			{
				mistakeChain = Std.int(Math.max(1, mistakeChain + 1));
				_heartBank._dickHeartReservoir -= SexyState.roundDownToQuarter(amount * (Math.abs(mistakeChain * 0.8)));
				amount -= SexyState.roundDownToQuarter(amount * 0.2);
			}
			else
			{
				mistakeChain = 0;
			}
			if (_remainingOrgasms > 0 && almostWords.timer <= 0 && _heartBank.getDickPercent() < 0.51 && !isEjaculating())
			{
				maybeEmitWords(almostWords);
			}
			else
			{
				if (came)
				{
					// won't complain after ejaculating at least once
				}
				else if (tooSlow)
				{
					if (mistakeChain >= -1)
					{
						maybeEmitWords(tooSlowWords, 0, 2);
					}
					else
					{
						maybeEmitWords(tooSlowWords);
					}
				}
				else if (tooFast)
				{
					if (mistakeChain <= 1)
					{
						maybeEmitWords(tooFastWords, 0, 2);
					}
					else
					{
						maybeEmitWords(tooFastWords);
					}
				}
			}
		}
		else {
			var lucky:Float = lucky(0.7, 1.43, 0.1);
			if (specialRub == "scalp" || specialRub == "belly" || !abraMood1 && specialRub == "ass")
			{
				lucky = 0.01;
			}
			amount = SexyState.roundUpToQuarter(lucky * _heartBank._foreplayHeartReservoir);
			_heartBank._foreplayHeartReservoir -= amount;
			_heartEmitCount += amount;

			if (minigasmCounter < niceThings.filter(function(s) { return s == false; } ).length)
			{
				emitWords(pleasureWords);
				minigasmCounter++;
			}
		}

		emitCasualEncouragementWords();
		if (_heartEmitCount > 0)
		{
			maybeScheduleBreath();
			maybePlayPokeSfx();
			maybeEmitPrecum();
		}
	}

	function setInactiveDickAnimation():Void
	{
		if (_male)
		{
			if (_gameState >= 400)
			{
				if (_dick.animation.name != "finished")
				{
					_dick.animation.add("finished", [1, 1, 1, 1, 0], 1, false);
					_dick.animation.play("finished");
				}
			}
			else if (pastBonerThreshold())
			{
				if (_dick.animation.frameIndex != 2)
				{
					_dick.animation.add("default", [2]);
					_dick.animation.play("default");
				}
			}
			else if (_heartBank.getForeplayPercent() < 0.6)
			{
				if (_dick.animation.frameIndex != 1)
				{
					_dick.animation.add("default", [1]);
					_dick.animation.play("default");
				}
			}
			else
			{
				if (_dick.animation.frameIndex != 0)
				{
					_dick.animation.add("default", [0]);
					_dick.animation.play("default");
				}
			}
		}
		else {
			if (displayingToyWindow())
			{
				// toy window's vagina is animated by AbraBeadWindow... don't mess with it
			}
			else if (_dick.animation.frameIndex != 0)
			{
				_dick.animation.play("default");
			}
		}
	}

	function relaxPulledAnalBeads():Void
	{
		_toyWindow.beadPosition = Std.int(1 + _toyWindow.beadPosition - 0.42);
		_toyInterface.pulledBeads = Std.int(1 + _toyWindow.beadPosition - 0.42);
		_toyInterface._desiredBeadPosition = 0;
		_toyInterface._actualBeadPosition = 0;
		_toyWindow.slack = AbraBeadWindow.MAX_SLACK;
		_toyWindow.lineAngle = 0;
	}

	override public function back():Void
	{
		super.back();

		if (_toyWindow.totalInsertedBeads >= PlayerData.abraBeadCapacity - 2)
		{
			PlayerData.abraBeadCapacity += FlxG.random.int( -1, 1);
			if (PlayerData.abraBeadCapacity < 70)
			{
				PlayerData.abraBeadCapacity += 9;
			}
			else if (PlayerData.abraBeadCapacity < 90)
			{
				PlayerData.abraBeadCapacity += 6;
			}
			else if (PlayerData.abraBeadCapacity < 110)
			{
				PlayerData.abraBeadCapacity += 3;
			}
			else if (PlayerData.abraBeadCapacity < 130)
			{
				PlayerData.abraBeadCapacity += 1;
			}
			else
			{
				PlayerData.abraBeadCapacity -= 1;
			}
		}
	}

	override function cursorSmellPenaltyAmount():Int
	{
		return 20;
	}

	override public function destroy():Void
	{
		super.destroy();

		ballOpacityTween = FlxTweenUtil.destroy(ballOpacityTween);
		mouthPolyArray = null;
		vagPolyArray = null;
		assPolyArray = null;
		leftLegPolyArray = null;
		rightLegPolyArray = null;
		shoulderPolyArray = null;
		bellyPolyArray = null;
		chestTorsoPolyArray = null;
		chestArmsPolyArray = null;
		scalpPolyArray = null;
		niceThings = null;
		meanThings = null;
		_toyWindow = FlxDestroyUtil.destroy(_toyWindow);
		_toyInterface = FlxDestroyUtil.destroy(_toyInterface);
		_tugNoise = FlxDestroyUtil.destroy(_tugNoise);
		_beadPushRewards = null;
		_beadPullRewards = null;
		_beadNudgeRewards = null;
		_vibeButton = FlxDestroyUtil.destroy(_vibeButton);
	}
}