package poke.rhyd;

import openfl.utils.Object;
import poke.abra.TugNoise;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup;
import flixel.input.FlxAccelerometer;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import poke.sexy.SexyState;
import poke.sexy.WordManager.Qord;
import poke.sexy.WordParticle;

/**
 * Sex sequence for Rhydon
 * 
 * Rhydon always has one sore area of his body; either his arms, chest, or
 * legs. Furthermore, he always has one especially sore spot within that area,
 * like his left ankle might be especially sore.
 * 
 * Locating the sore spot involves a little "hot and cold" game. When you're
 * close to the sore area, he'll sort of crouch down as his legs buckle. Also,
 * you can count the number of hearts being emitted, which will increase as
 * you're getting warmer.
 * 
 * Once you locate the sore spot, rubbing it 2-3 times consecutively will cause
 * Rhydon to moan in pleasure and emit a lot of hearts.
 * 
 * After rubbing the sore spot, make sure to rub the other sensitive areas in
 * that muscle group. If his elbow was especially sore, rub both of his arms
 * extensively. If his thigh was especially sore, rub both of his legs
 * extensively.
 * 
 * Rhydon loves having his cock head and shaft played with. Since your hand is
 * small, you can't rub both simultaneously, but make sure you don't focus too
 * much on one or the other.
 * 
 * After you give his erect cock some attention, he likes when you pet his
 * face. Plus it's adorable!
 * 
 * Rhydon hates when you rub his cock too fast, so adopt a slow and deliberate
 * pace -- clicking every second or two is plenty.
 * 
 * Rhydon likes the giant anal beads, either the grey or glass ones.
 * 
 * If you count the number of beads inserted, it should be something like 21,
 * and Rhydon will go first. You and Rhydon will take turns pulling out 1-3
 * beads. If you can pull out the final enormous bead, instead of letting
 * Rhydon do it, this will make Rhydon very happy.
 * 
 * This "pulling out anal beads game" will technically always end with Rhydon
 * pulling out the last bead, if he plays perfectly. But he always makes a
 * mistake. Keep count of how many beads are left, and try to make it so there
 * are 4, 8, 12, or 16 beads remaining when it's his turn.
 * 
 * Make sure to pull out the beads very, very slowly. When the beads are
 * half-way out, Rhydon will emit a few hearts. Then you can pull out the bead
 * the rest of the way.
 * 
 * If you watch your pace, and pull out the last bead without Rhydon's help,
 * you can get Rhydon to cum just from using the anal beads.
 */
class RhydonSexyState extends SexyState<RhydonWindow>
{
	// places to emit sweat
	private var torsoKnotArray:Array<Array<FlxPoint>>;
	private var legKnotArray:Array<Array<FlxPoint>>;
	private var armKnotArray:Array<Array<FlxPoint>>;

	private var rubHeadWords:Qord;
	private var niceSlowWords:Qord;
	private var tooFastWords:Qord;

	private var rhydonMood0:Int = FlxG.random.int(0, 17);
	private var rhydonMood1:Int = FlxG.random.int(6, 12);
	private var rhydonMood2:Int = FlxG.random.int(0, 2);

	private var _neededKnotRubCount:Int = 2;
	private var _knotPart:FlxSprite;
	private var _knotIndex:Int = 0;
	private var _secondaryKnotIndexes:Array<Int>;
	private var _knotBank:Float = 0;
	private var dickTiming:Array<Int> = [];
	private var _dickRubSoundCount:Int = 0;
	private var _vagTightness:Float = 5;

	private var _recentDists:Array<Float> = [0, 1000000, 1000000];

	/*
	 * niceThings[0] = find Rhydon's muscle knot
	 * niceThings[1] = pet rhydon's head after playing with his erection
	 */
	private var niceThings:Array<Bool> = [true, true];

	/**
	 * meanThings[0] = jack off Rhydon RIDICULOUSLY fast
	 * meanThings[1] = focus too much on one part of Rhydon's cock
	 */
	private var meanThings:Array<Bool> = [true, true];

	private var dickheadPolyArray:Array<Array<FlxPoint>>;
	private var vagPolyArray:Array<Array<FlxPoint>>;
	private var _splatEmitter:FlxEmitter = new FlxEmitter(0, 0, 105);
	private var _ignoreSplatCount:Int = 5;

	private var SHAKE_FPS:Int = 25;
	private var _shakeFrameTimer:Float = 0;
	private var _shakeTimer:Float = 0;
	private var _shakeDuration:Float = 0;
	private var _shakeIntensity:Float = 0;

	private var _forceMood:Int = -1;
	private var _forceMoodTimer:Float = 0;

	// rhydon only reports boredom if he gets bored twice in succession
	private var _rhydonBoredTimer:Float = 0;
	private var _orgasmPenalty:Float = 0;
	private var _dickheadCount:Int = 0;
	private var _dickshaftCount:Int = 0;

	private var _beadPushRewards:Array<Float> = [];
	private var _beadPullRewards:Array<Float> = [];
	private var _beadNudgeRewards:Array<Float> = [];
	private var _beadNudgePushCount:Array<Int> = [];
	private var _beadNudgePullCount:Array<Int> = [];
	private var _finalBeadBonus:Float = 0;

	private var _toyWindow:RhydonBeadWindow;
	private var _toyInterface:RhydonBeadInterface;
	private var _tugNoise:TugNoise = new TugNoise();
	private var _futileBeadTugTime:Float = 0;

	// for male rhydon, anal beads use a special emitter, so that jizz goes behind the dick
	private var _beadSpoogeEmitter:FlxEmitter = new FlxEmitter(0, 0, 410);
	private var _beadShadowDick:BouncySprite;
	// anal beads draw a special dick mask over jizz, so that jizz goes behind the dick
	private var _beadDickMask:BlackGroup;
	private var _totalBeadPenalty:Float = 0;
	// rhydon will make a suboptimal move during his first three turns
	private var _rhydonNimError:Int = FlxG.random.int(0, 2);
	private var _beadNudgeStreak:Int = 0;
	private var _vibeButton:FlxButton;

	override public function create():Void
	{
		prepare("rhyd");
		super.create();

		_toyWindow = new RhydonBeadWindow(256, 0, 248, 426);
		toyGroup.add(_toyWindow);

		_toyInterface = new RhydonBeadInterface();
		toyGroup.add(_toyInterface);

		// load bigger blob graphics than normal
		for (particle in _fluidEmitter.members)
		{
			// these pre-blurred blobs were made by rendering a 4x5 white rectangle at 93% opacity, then gaussian blurring it in a 9 pixel radius
			particle.loadGraphic(FlxG.random.bool() ? AssetPaths.fuzzy_circle_9a__png : AssetPaths.fuzzy_circle_9b__png);
			particle.flipX = FlxG.random.bool();
		}
		if (_male)
		{
			for (i in 0..._splatEmitter.maxSize)
			{
				var particle:FlxParticle = new FlxParticle();
				particle.loadGraphic(AssetPaths.sexy_splat_blur__png, true, 80, 80);
				particle.flipX = FlxG.random.bool();
				particle.animation.frameIndex = FlxG.random.int(0, particle.animation.numFrames);
				particle.exists = false;
				_splatEmitter.add(particle);
			}
			_splatEmitter.angularVelocity.start.set(0);
			_splatEmitter.launchMode = FlxEmitterMode.SQUARE;
			_splatEmitter.velocity.start.set(new FlxPoint(-6, 20), new FlxPoint(6, 25));
			_splatEmitter.velocity.end.set(_splatEmitter.velocity.start.min, _splatEmitter.velocity.start.max);
			_splatEmitter.acceleration.start.set(new FlxPoint(0, 6), new FlxPoint(0, 12));
			_splatEmitter.acceleration.end.set(_splatEmitter.acceleration.start.min, _splatEmitter.acceleration.start.max);
			_splatEmitter.alpha.start.set(0.5, 1.0);
			_splatEmitter.alpha.end.set(0);
			_splatEmitter.lifespan.set(3, 6);
			_splatEmitter.start(false, 1.0, 0x0FFFFFFF);
			_splatEmitter.emitting = false;
			_blobbyGroup.add(_splatEmitter);
		}

		_spoogeKludge.loadGraphic(AssetPaths.fuzzy_circle_9a__png);

		_pokeWindow.arrangeArmsAndLegs();

		sfxEncouragement = [AssetPaths.rhyd0__mp3, AssetPaths.rhyd1__mp3, AssetPaths.rhyd2__mp3];
		sfxPleasure = [AssetPaths.rhyd3__mp3, AssetPaths.rhyd4__mp3, AssetPaths.rhyd5__mp3, AssetPaths.rhyd6__mp3];
		sfxOrgasm = [AssetPaths.rhyd7__mp3, AssetPaths.rhyd8__mp3, AssetPaths.rhyd9__mp3];

		popularity = 0.0;
		cumTrait0 = 4;
		cumTrait1 = 6;
		cumTrait2 = 5;
		cumTrait3 = 7;
		cumTrait4 = 2;

		// a little slower; most stuff takes about 1.5x as long for him
		_rubRewardFrequency = 3.7;
		_characterSfxFrequency = 5.9;
		_minRubForReward = 2;

		_bonerThreshold = 0.64;

		_armsAndLegsArranger.setBounds(12, 18);

		if (PlayerData.rhydSexyBeforeChat == 0)
		{
			// cramp in his left (your right) arm...
			rhydonMood0 = FlxG.random.int(15, 17);
		}
		else if (PlayerData.rhydSexyBeforeChat == 1)
		{
			// cramp in his left (your right) chest...
			rhydonMood0 = FlxG.random.int(9, 11);
		}
		else if (PlayerData.rhydSexyBeforeChat == 2)
		{
			// cramp in his right (your left) leg...
			rhydonMood0 = FlxG.random.int(0, 2);
		}

		if (rhydonMood0 <= 5)
		{
			_knotPart = _pokeWindow._torso0;
		}
		else if (rhydonMood0 <= 11)
		{
			_knotPart = _pokeWindow._torso1;
		}
		else {
			_knotPart = _pokeWindow._arms0;
		}
		_knotIndex = rhydonMood0 % 6;
		_secondaryKnotIndexes = [_knotIndex];

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_LARGE_GLASS_BEADS))
		{
			var _glassAnalBeadButton:FlxButton = newToyButton(glassAnalBeadButtonEvent, AssetPaths.xlbeads_glass_button__png, _dialogTree);
			addToyButton(_glassAnalBeadButton);
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_LARGE_GREY_BEADS))
		{
			var _greyAnalBeadButton:FlxButton = newToyButton(greyAnalBeadButtonEvent, AssetPaths.xlbeads_grey_button__png, _dialogTree);
			addToyButton(_greyAnalBeadButton);
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_VIBRATOR))
		{
			_vibeButton = newToyButton(vibeButtonEvent, AssetPaths.vibe_button__png, _dialogTree);
			addToyButton(_vibeButton, 0.25);
		}

		_toyWindow.beadPushCallback = beadPushed;
		_toyWindow.beadPullCallback = beadPulled;
		_toyWindow.beadNudgeCallback = beadNudged;

		if (_male)
		{
			_beadSpoogeEmitter = new FlxEmitter(0, 0, 410);
		}
		_beadShadowDick = new BouncySprite(0, 0, 0, 0, 0, 0);
	}

	public function vibeButtonEvent():Void
	{
		playButtonClickSound();
		removeToyButton(_vibeButton);
		var tree:Array<Array<Object>> = [];
		RhydonDialog.snarkyVibe(tree);
		showEarlyDialog(tree);
	}

	public function glassAnalBeadButtonEvent():Void
	{
		playButtonClickSound();
		toyButtonsEnabled = false;
		_toyInterface.setInteractive(false, 0);
		maybeEmitWords(toyStartWords);
		var time:Float = eventStack._time;
		eventStack.addEvent({time:time += 0.8, callback:eventTakeBreak, args:[2.5]});
		eventStack.addEvent({time:time + 2.5, callback:eventEnableToyWindow});
		eventStack.addEvent({time:time += 0.5, callback:eventShowToyWindow});
		eventStack.addEvent({time:time += 2.2, callback:eventEnableToyButtons});
	}

	public function greyAnalBeadButtonEvent():Void
	{
		playButtonClickSound();
		toyButtonsEnabled = false;
		_toyInterface.setInteractive(false, 0);
		_toyWindow.setGreyBeads();
		_toyWindow.totalBeadCount = 21;
		_toyInterface.totalBeadCount = 21;
		maybeEmitWords(toyStartWords);
		var time:Float = eventStack._time;
		eventStack.addEvent({time:time += 0.8, callback:eventTakeBreak, args:[2.5]});
		eventStack.addEvent({time:time + 2.5, callback:eventEnableToyWindow});
		eventStack.addEvent({time:time += 0.5, callback:eventShowToyWindow});
		eventStack.addEvent({time:time += 2.2, callback:eventEnableToyButtons});
	}

	override public function getToyWindow():PokeWindow
	{
		return _toyWindow;
	}

	override public function handleToyWindow(elapsed:Float):Void
	{
		super.handleToyWindow(elapsed);

		if (_male && _beadShadowDick.visible)
		{
			_beadShadowDick.synchronize(_toyWindow._dick);
			_beadShadowDick.x = _toyWindow._dick.x + 3;
			_beadShadowDick.y += 3;
			_beadShadowDick.animation.frameIndex = _toyWindow._dick.animation.frameIndex;
		}

		if (_remainingOrgasms > 0)
		{
			// counteract rhydonBoredTimer, so that rhydon will eventually get bored
			_rhydonBoredTimer = Math.min(6, _rhydonBoredTimer + elapsed * (1 - SexyState.TOY_TIME_DILATION));
		}

		if (_male)
		{
			// jizz splats on belly/head?
			for (spoogeParticle in _beadSpoogeEmitter.members)
			{
				if (spoogeParticle.alive && spoogeParticle.exists
				&& spoogeParticle.velocity.y > 0
				&& spoogeParticle.acceleration.y > 500
				&& spoogeParticle.age > 0.6
				   )
				{
					if (spoogeParticle.y + _toyWindow.cameraPosition.y > 220)
					{
						// splats on belly/head
						spoogeParticle.acceleration.y = 0;
						spoogeParticle.accelerationRange.start.set(0, 0);
						spoogeParticle.accelerationRange.end.set(0, 0);
						spoogeParticle.velocity.y *= 0.1;
						spoogeParticle.velocity.x *= 2.0;
					}
					else
					{
						// past his head?
						spoogeParticle.kill();
					}
				}
				if (spoogeParticle.alive && spoogeParticle.exists
						&& spoogeParticle.y + _toyWindow.cameraPosition.y > 420)
				{
					// oops, jizz is sliding down past his balls... this starts to look weird
					spoogeParticle.kill();
				}
			}
		}

		_toyWindow._playerInteractingWithHandle = false;
		_toyWindow._playerShovingInBead = false;
		_toyWindow._playerRestingHandOnSphincter = false;
		_toyWindow._playerHandNearBead = false;
		_toyWindow._playerHandNearHandle = false;

		if (_toyInterface.pushMode)
		{
			// update bead position...
			if (_toyInterface._interacting)
			{
				_toyWindow.tryPushingBeads(_toyInterface._anchorBeadPosition, _toyInterface._desiredBeadPosition, elapsed);
			}
			else
			{
				_toyInterface._anchorBeadPosition = _toyWindow.getBeadPositionInt();
				_toyWindow._beadPosition = _toyInterface._anchorBeadPosition;
			}

			// update hand status...
			if (_toyInterface._interacting)
			{
				if (_toyWindow._beadPosition < _toyInterface._anchorBeadPosition + RhydonBeadWindow.BEAD_BP_CENTER)
				{
					_toyWindow._playerShovingInBead = true;
				}
				else
				{
					_toyWindow._playerRestingHandOnSphincter = true;
				}
			}
			else if (_toyInterface.isMouseNearPushableBead() && _toyInterface.isInteractive())
			{
				_toyWindow._playerHandNearBead = true;
			}

			if (!_toyInterface._interacting && _toyInterface._actualBeadPosition >= _toyInterface.totalBeadCount)
			{
				if (eventStack.isEventScheduled(eventEndPushMode))
				{
					// don't schedule it again
				}
				else
				{
					// pushed final bead... rhydon's turn
					eventStack.addEvent({time:eventStack._time + 0.4, callback:eventEndPushMode});
				}
			}

			// play sfx...
			if (_toyInterface._interacting && _toyWindow._ass.animation.frameIndex > 1)
			{
				_tugNoise.tugging = true;
			}

			// when pushing, everything's always at max slack
			_toyWindow.slack = RhydonBeadWindow.MAX_SLACK;
			_toyWindow.lineAngle = 0;
			_toyInterface._actualBeadPosition = _toyWindow._beadPosition;
		}
		else {
			if (_toyWindow.rhydonsTurn)
			{
				if (_toyWindow.rhydonDonePullingBeads())
				{
					_toyWindow.setRhydonUp(false);
					_toyWindow.rhydonsTurn = false;

					if (_toyWindow.getBeadPositionInt() <= 0)
					{
						// no beads left...
					}
					else
					{
						_toyInterface._anchorBeadPosition = _toyWindow.getBeadPositionInt();
						_toyInterface._desiredBeadPosition = _toyInterface._anchorBeadPosition;
						_toyInterface.setInteractive(true, 0.5);
					}
				}

				if (_toyInterface.isInteractive())
				{
					// update bead position
					if (_toyInterface._interacting)
					{
						// okay, you can screw around, but you can't pull any beads
						_toyWindow.tryPullingBeads(_toyInterface._desiredBeadPosition, elapsed, true);
						_toyWindow.lineAngle = _toyInterface.lineAngle;
						if (_toyWindow.slack == 0)
						{
							// line is taut; limit the interface's pull distance
							_toyInterface._actualBeadPosition = _toyWindow._beadPosition;
						}
						else
						{
							// line is slack; the interface can do whatever it wants
							_toyInterface._actualBeadPosition = _toyInterface._desiredBeadPosition;
						}
					}
					else
					{
						relaxPulledAnalBeads();
					}

					// update hand status...
					if (_toyInterface._interacting)
					{
						_toyWindow._playerInteractingWithHandle = true;
					}
					else if (_toyInterface.isMouseNearPullRing() && _toyInterface.isInteractive())
					{
						_toyWindow._playerHandNearHandle = true;
					}

				}

				// play sfx...
				if (_toyInterface.isInteractive())
				{
					if (_toyInterface._interacting && _toyWindow.slack == 0 && _toyWindow._ass.animation.frameIndex > 1)
					{
						_tugNoise.tuggingMouse = true;
					}
				}
				else
				{
					if (_toyWindow.slack == 0 && _toyWindow._ass.animation.frameIndex > 1)
					{
						_tugNoise.tugging = true;
					}
				}
			}
			else {
				var transitionToRhydonsTurn:Bool = false;
				if (!_toyInterface._interacting && _toyInterface._actualBeadPosition < _toyInterface._anchorBeadPosition - 1 + RhydonBeadWindow.BEAD_BP_CENTER)
				{
					transitionToRhydonsTurn = true;
					// don't blink handle... they shouldn't really be tempted to grab it
					_toyInterface.handleBlinkTimer = 5.0;
				}
				else if (_toyInterface._actualBeadPosition < _toyInterface._anchorBeadPosition - 3 + RhydonBeadWindow.BEAD_BP_CENTER)
				{
					// they've pulled out three beads...
					if (_toyWindow.getBeadPositionInt() <= 0)
					{
						// no beads left...
					}
					else
					{
						if (_toyWindow._sphincter.animation.frameIndex <= 1)
						{
							// well, we're just holding it i guess
						}
						else
						{
							_futileBeadTugTime += elapsed;
							if (_futileBeadTugTime > 3)
							{
								transitionToRhydonsTurn = true;

								// that's really annoying
								var penalty:Float = SexyState.roundUpToQuarter(_beadPullRewards[_toyWindow.getBeadPositionInt() - 1] * 0.9);
								_heartEmitCount -= penalty;
								_totalBeadPenalty += penalty;
							}
						}
					}
				}

				if (transitionToRhydonsTurn)
				{
					// released cord, after pulling one or more beads... rhydon's turn
					_futileBeadTugTime = 0;
					if (_toyWindow.getBeadPositionInt() <= 0)
					{
						// no beads left...
						if (_toyInterface.isInteractive())
						{
							_toyInterface.setInteractive(false, 2.0);
						}
					}
					else
					{
						rhydonPullsBeads();
					}
				}

				// update bead position
				if (_toyInterface._interacting)
				{
					if (_toyInterface._actualBeadPosition < _toyInterface._anchorBeadPosition - 3 + RhydonBeadWindow.BEAD_BP_CENTER)
					{
						// player already pulled three beads... don't let them pull any more
						_toyWindow.tryPullingBeads(_toyInterface._desiredBeadPosition, elapsed, true);
					}
					else
					{
						_toyWindow.tryPullingBeads(_toyInterface._desiredBeadPosition, elapsed);
					}

					_toyWindow.lineAngle = _toyInterface.lineAngle;
					if (_toyWindow.slack == 0)
					{
						// line is taut; limit the interface's pull distance
						_toyInterface._actualBeadPosition = _toyWindow._beadPosition;
					}
					else
					{
						// line is slack; the interface can do whatever it wants
						_toyInterface._actualBeadPosition = _toyInterface._desiredBeadPosition;
					}
				}
				else {
					relaxPulledAnalBeads();
				}

				// update hand status...
				if (_toyInterface._interacting)
				{
					_toyWindow._playerInteractingWithHandle = true;
				}
				else if (_toyInterface.isMouseNearPullRing() && _toyInterface.isInteractive())
				{
					_toyWindow._playerHandNearHandle = true;
				}

				// play sfx...
				if (_toyInterface._interacting && _toyWindow._ass.animation.frameIndex > 1 && _toyWindow.slack == 0)
				{
					_tugNoise.tuggingMouse = true;
				}
			}
		}
		_tugNoise.update(elapsed);
		_tugNoise.tugging = false;
		_tugNoise.tuggingMouse = false;
	}

	public function beadPushed(index:Int, duration:Float, radius:Float):Void
	{
		_toyBank._dickHeartReservoir = Math.max(0, SexyState.roundDownToQuarter(_toyBank._dickHeartReservoir - _toyBank._dickHeartReservoirCapacity / 36));

		_heartEmitCount += _beadPushRewards[index];
		_heartBank._foreplayHeartReservoirCapacity += _beadPushRewards[index];
		_beadPushRewards[index] = 0;

		maybeEmitToyWordsAndStuff();
	}

	public function beadPulled(index:Int, duration:Float, radius:Float):Void
	{
		_toyBank._dickHeartReservoir = Math.max(0, SexyState.roundDownToQuarter(_toyBank._dickHeartReservoir - _toyBank._dickHeartReservoirCapacity / 36));

		_heartEmitCount += _beadPullRewards[index];
		_heartBank._foreplayHeartReservoirCapacity += _beadPullRewards[index];
		if (index == 0)
		{
			if (_toyWindow.rhydonsTurn)
			{
				// player missed final bead...
				_totalBeadPenalty += _finalBeadBonus;
			}
			else
			{
				maybeEmitWords(pleasureWords);
				_heartEmitCount += _finalBeadBonus;
				_heartBank._dickHeartReservoirCapacity += _finalBeadBonus;
				_finalBeadBonus = 0;
			}
		}
		_beadPullRewards[index] = 0;
		beadNudged(index, duration, radius); // give nudge reward, if duration is large enough
		if (_toyWindow.rhydonsTurn && _beadNudgeRewards[index] > 0)
		{
			// if rhydon misses a nudge... just give it to them
			_heartEmitCount += _beadNudgeRewards[index];
			_beadNudgeRewards[index] = 0;
		}

		if (!_toyWindow.rhydonsTurn)
		{
			if (_beadNudgeRewards[index] > 0)
			{
				// player missed a nudge...
				_totalBeadPenalty += _beadNudgeRewards[index];
				_beadNudgeStreak = 0;
				_breathlessCount = 0;
			}
			else
			{
				_beadNudgeStreak++;
				if (_beadNudgeStreak > 2)
				{
					_autoSweatRate += 0.02;
				}
				if (_beadNudgeStreak % 3 == 0)
				{
					maybeScheduleBreath();
					if (_breathTimer > 0)
					{
						_breathTimer = 0.1;
					}
				}
			}
		}
		else {
			if (index == 0)
			{
				// last bead
				emitBreath();
			}
		}

		maybeEmitToyWordsAndStuff();

		if (index <= 0)
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
	}

	/**
	 * For the anal beads, Rhydon emits more hearts if you "nudge" the beads by
	 * pulling them out slowly.
	 *
	 * @param	index bead index which is being nudged
	 * @param	duration the duration of the nudge
	 * @param	radius radius of the bead being nudged
	 */
	public function beadNudged(index:Int, duration:Float, radius:Float):Void
	{
		var targetDuration:Float = 0;

		if (radius <= 20)
		{
			targetDuration = 0.32;
		}
		else if (radius <= 25)
		{
			targetDuration = 0.51;
		}
		else if (radius <= 30)
		{
			targetDuration = 0.82;
		}
		else if (radius <= 35)
		{
			targetDuration = 1.31;
		}
		else if (radius <= 40)
		{
			targetDuration = 2.09;
		}
		else {
			targetDuration = 3.35;
		}

		if (_toyInterface.pushMode)
		{
			// push nudge...
			if (_beadNudgePushCount[index] < 3 && duration > (_beadNudgePushCount[index] + 1) * targetDuration * 0.33)
			{
				var reward:Float = SexyState.roundUpToQuarter(_beadPushRewards[index] * [0.1, 0.22, 0.43][_beadNudgePushCount[index]]);
				_heartEmitCount += reward;
				_beadPushRewards[index] -= reward;
				_beadNudgePushCount[index]++;
				_heartBank._foreplayHeartReservoirCapacity += reward;
			}
		}
		else {
			// pull nudge...
			if (_beadNudgePullCount[index] < 3 && duration > (_beadNudgePullCount[index] + 1) * targetDuration * 0.33)
			{
				var reward:Float = SexyState.roundUpToQuarter(_beadNudgeRewards[index] * [0.17, 0.40, 1.00][_beadNudgePullCount[index]]);
				_heartEmitCount += reward;
				_beadNudgeRewards[index] -= reward;
				_beadNudgePullCount[index]++;
				_heartBank._foreplayHeartReservoirCapacity += reward;
			}
		}

		_idlePunishmentTimer = 0;
	}

	function setPushMode(pushMode:Bool)
	{
		if (_toyInterface.pushMode == pushMode)
		{
			return;
		}
		_toyInterface.pushMode = pushMode;
		_toyInterface._anchorBeadPosition = _toyWindow.getBeadPositionInt();
		_toyInterface._desiredBeadPosition = _toyInterface._anchorBeadPosition;
	}

	function rhydonPullsBeads():Void
	{
		eventStack.addEvent({time:eventStack._time + RhydonBeadWindow.INITIAL_PULL_PAUSE_DURATION, callback:eventYankBeadsAway});
		if (_toyWindow.getBeadPositionInt() >= _toyWindow.totalBeadCount - 3)
		{
			_toyWindow.setRhydonUp(true);
		}

		var howMany:Int = _toyWindow.getBeadPositionInt() % 4;
		if (_rhydonNimError-- == 0)
		{
			howMany = FlxG.random.getObject(
				[[1, 2, 3], // should pull out a random number of beads? should never happen
			[2, 3], // should pull out 1 bead; pull out 2 or 3 instead
			[1, 3], // should pull out 2 beads; pull out 1 or 3 instead
			[1, 2], //should pull out 3 beads; pull out 1 or 2 instead
				][howMany]);
		}
		if (howMany == 0)
		{
			// can't win with perfect play; pull out a random amount
			howMany = FlxG.random.int(1, 3);
		}

		_toyWindow.removeBeads(howMany);
	}

	function eventYankBeadsAway(params:Array<Dynamic>)
	{
		_toyInterface.setInteractive(false, 0.5);
	}

	function eventEndPushMode(params:Array<Dynamic>)
	{
		setPushMode(false);
		rhydonPullsBeads();
	}

	function relaxPulledAnalBeads()
	{
		_toyInterface._anchorBeadPosition = _toyWindow.getBeadPositionInt();
		_toyWindow._beadPosition = _toyInterface._anchorBeadPosition;
		_toyInterface._desiredBeadPosition = _toyInterface._anchorBeadPosition;
		_toyInterface._actualBeadPosition = _toyInterface._anchorBeadPosition;
		_toyWindow.slack = RhydonBeadWindow.MAX_SLACK;
	}

	override public function shouldEmitToyInterruptWords()
	{
		return _toyInterface.pushMode || _toyWindow._beadPosition > 0;
	}

	override function foreplayFactor():Float
	{
		return 0.5;
	}

	private function emitSplat(x:Float, y:Float)
	{
		_splatEmitter.emitParticle();
		_splatEmitter.x = x + FlxG.random.int(-48, 48);
		_splatEmitter.y = y + FlxG.random.int(-48, 48);
	}

	override public function sexyStuff(elapsed:Float):Void
	{
		_forceMoodTimer += elapsed;
		_rhydonBoredTimer -= elapsed;

		super.sexyStuff(elapsed);

		if (_shakeTimer > 0)
		{
			_shakeTimer -= elapsed;
			_shakeFrameTimer += elapsed;
			var intensity = _shakeIntensity * Math.pow(_shakeTimer / _shakeDuration, 2.5);
			FlxG.camera.x = intensity / 2 * FlxG.width * Math.sin(_shakeTimer * Math.PI * (SHAKE_FPS + 0.0651444));

			if (_shakeTimer <= 0)
			{
				FlxG.camera.setPosition(0, 0);
			}
		}

		if (_male && _activePokeWindow == _pokeWindow)
		{
			// jizz splats on camera?
			for (spoogeParticle in _fluidEmitter.members)
			{
				if (spoogeParticle.alive && spoogeParticle.exists && spoogeParticle.age > 0.85 && spoogeParticle.acceleration.y > 500)
				{
					_ignoreSplatCount++;
					if (_ignoreSplatCount >= 4)
					{
						emitSplat(spoogeParticle.x, spoogeParticle.y);
						_ignoreSplatCount = 0;
					}
					spoogeParticle.kill();
				}
			}
		}

		if (pastBonerThreshold() && _gameState == 200 && _male)
		{
			// switch to boner-oriented animations
			if (fancyRubbing(_dick) && _rubBodyAnim.nearMinFrame())
			{
				if (_rubBodyAnim._flxSprite.animation.name == "rub-foreskin" || _rubBodyAnim._flxSprite.animation.name == "rub-foreskin1")
				{
					_rubBodyAnim.setAnimName("jack-foreskin");
					_rubHandAnim.setAnimName("jack-foreskin");
				}
				else if (_rubBodyAnim._flxSprite.animation.name == "rub-dick")
				{
					_rubBodyAnim.setAnimName("jack-off");
					_rubHandAnim.setAnimName("jack-off");
				}
			}
		}

		if (!fancyRubAnimatesSprite(_dick))
		{
			setInactiveDickAnimation();
		}
	}

	override function emitWords(qord:Qord, ?left:Int = 0, ?right:Int = 0):Array<WordParticle>
	{
		var wordParticles:Array<WordParticle> = super.emitWords(qord, left, right);
		if (qord == orgasmWords)
		{
			var orgasmSize:Float = _heartEmitCount + _heartBank._dickHeartReservoir + _heartBank._foreplayHeartReservoir;
			if (orgasmSize > 20)
			{
				// maximum shake amount
				_shakeDuration = 4.5;
				_shakeIntensity = 0.08;

				// diminish shaking if we're below 330 orgasm power
				var target:Float = 330;
				while (orgasmSize < target)
				{
					target /= 1.35;
					_shakeDuration *= 0.9;
					_shakeIntensity *= 0.85;
				}
				_shakeTimer = _shakeDuration;
			}
		}
		return wordParticles;
	}

	override public function moveParticlesWithCamera():Void
	{
		super.moveParticlesWithCamera();
		for (particle in _splatEmitter.members)
		{
			if (particle.alive && particle.exists)
			{
				particle.x -= _activePokeWindow.cameraPosition.x - _oldCameraPosition.x;
				particle.y -= _activePokeWindow.cameraPosition.y - _oldCameraPosition.y;
			}
		}
		if (_beadSpoogeEmitter != null)
		{
			for (particle in _beadSpoogeEmitter.members)
			{
				if (particle.alive && particle.exists)
				{
					particle.x -= _activePokeWindow.cameraPosition.x - _oldCameraPosition.x;
					particle.y -= _activePokeWindow.cameraPosition.y - _oldCameraPosition.y;
				}
			}
		}
	}

	override public function killParticles():Void
	{
		super.killParticles();
		for (particle in _splatEmitter.members)
		{
			if (particle.alive && particle.exists)
			{
				particle.x -= _pokeWindow.cameraPosition.x - _oldCameraPosition.x;
				particle.y -= _pokeWindow.cameraPosition.y - _oldCameraPosition.y;
			}
		}
		if (_beadSpoogeEmitter != null)
		{
			for (particle in _beadSpoogeEmitter.members)
			{
				if (particle.alive && particle.exists)
				{
					particle.kill();
				}
			}
		}
	}

	override public function playRubSound():Void
	{
		super.playRubSound();
		if (_dick.animation.name == "jack-off" || _dick.animation.name == "jack-foreskin" || _dick.animation.name == "rub-dick" || _dick.animation.name == "rub-foreskin" || _dick.animation.name == "rub-foreskin1")
		{
			_dickRubSoundCount++;
		}
	}

	override function boredStuff():Void
	{
		if (_rhydonBoredTimer > 0)
		{
			super.boredStuff();
		}
		_rhydonBoredTimer = 6;
		_dickRubSoundCount = 0;
	}

	override public function untouchPart(touchedPart:FlxSprite):Void
	{
		super.untouchPart(touchedPart);
		_dickRubSoundCount = 0;
	}

	override public function touchPart(touchedPart:FlxSprite):Bool
	{
		if (_male)
		{
			// male interactions
			if (FlxG.mouse.justPressed && touchedPart == _dick)
			{
				if (_gameState == 200 && pastBonerThreshold())
				{
					if (clickedPolygon(touchedPart, dickheadPolyArray))
					{
						interactOn(_dick, "jack-foreskin");
					}
					else
					{
						interactOn(_dick, "jack-off");
					}
				}
				else
				{
					if (clickedPolygon(touchedPart, dickheadPolyArray))
					{
						interactOn(_dick, "rub-foreskin");
						_rubBodyAnim.addAnimName("rub-foreskin1");
						_rubHandAnim.addAnimName("rub-foreskin1");
					}
					else
					{
						interactOn(_dick, "rub-dick");
					}
				}
				return true;
			}
			if (FlxG.mouse.justPressed && touchedPart == _pokeWindow._balls)
			{
				interactOn(_pokeWindow._balls, "rub-balls");
				return true;
			}
		}
		else {
			// female interactions
			if (FlxG.mouse.justPressed)
			{
				if ((touchedPart == _dick || touchedPart == _pokeWindow._torso0) && (clickedPolygon(touchedPart, dickheadPolyArray)))
				{
					if (_gameState == 200 && pastBonerThreshold())
					{
						interactOn(_dick, "jack-foreskin");
						_rubBodyAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
						_rubHandAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
					}
					else
					{
						interactOn(_dick, "rub-foreskin");
					}
					return true;
				}
				if ((touchedPart == _dick || touchedPart == _pokeWindow._tail) && clickedPolygon(touchedPart, vagPolyArray))
				{
					if (_gameState == 200 && pastBonerThreshold())
					{
						interactOn(_dick, "jack-off");
						_rubBodyAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
						_rubHandAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
					}
					else
					{
						interactOn(_dick, "rub-dick");
						_rubBodyAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
						_rubHandAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
					}
					return true;
				}
			}
		}
		return false;
	}

	override function initializeHitBoxes():Void
	{
		if (_activePokeWindow == _pokeWindow)
		{
			dickheadPolyArray = new Array<Array<FlxPoint>>();
			if (PlayerData.rhydMale)
			{
				dickheadPolyArray[0] = [new FlxPoint(114, 595), new FlxPoint(130, 542), new FlxPoint(152, 520), new FlxPoint(181, 527), new FlxPoint(199, 554), new FlxPoint(194, 574), new FlxPoint(187, 625)];
				dickheadPolyArray[1] = [new FlxPoint(105, 613), new FlxPoint(120, 526), new FlxPoint(134, 503), new FlxPoint(163, 493), new FlxPoint(190, 503), new FlxPoint(202, 535), new FlxPoint(192, 620)];
				dickheadPolyArray[2] = [new FlxPoint(123, 330), new FlxPoint(132, 430), new FlxPoint(146, 451), new FlxPoint(175, 455), new FlxPoint(207, 442), new FlxPoint(213, 414), new FlxPoint(220, 324)];
			}
			else
			{
				dickheadPolyArray[0] = [new FlxPoint(151, 480), new FlxPoint(213, 481), new FlxPoint(211, 432), new FlxPoint(153, 434)];
				dickheadPolyArray[1] = [new FlxPoint(151, 480), new FlxPoint(213, 481), new FlxPoint(211, 432), new FlxPoint(153, 434)];
				dickheadPolyArray[2] = [new FlxPoint(151, 480), new FlxPoint(213, 481), new FlxPoint(211, 432), new FlxPoint(153, 434)];
			}

			vagPolyArray = new Array<Array<FlxPoint>>();
			vagPolyArray[0] = [new FlxPoint(151, 480), new FlxPoint(213, 481), new FlxPoint(213, 538), new FlxPoint(149, 536)];
			vagPolyArray[1] = [new FlxPoint(151, 480), new FlxPoint(213, 481), new FlxPoint(213, 538), new FlxPoint(149, 536)];
			vagPolyArray[2] = [new FlxPoint(151, 480), new FlxPoint(213, 481), new FlxPoint(213, 538), new FlxPoint(149, 536)];

			if (_male)
			{
				dickAngleArray[0] = [new FlxPoint(155, 579), new FlxPoint(-19, 259), new FlxPoint(-215, 146)];
				dickAngleArray[1] = [new FlxPoint(151, 547), new FlxPoint(194, 173), new FlxPoint(-219, 140)];
				dickAngleArray[2] = [new FlxPoint(164, 421), new FlxPoint(153, -210), new FlxPoint(-207, -157)];
				dickAngleArray[3] = [new FlxPoint(151, 559), new FlxPoint(85, 246), new FlxPoint(-149, 213)];
				dickAngleArray[4] = [new FlxPoint(150, 559), new FlxPoint(85, 246), new FlxPoint(-149, 213)];
				dickAngleArray[5] = [new FlxPoint(152, 561), new FlxPoint(85, 246), new FlxPoint(-149, 213)];
				dickAngleArray[6] = [new FlxPoint(152, 559), new FlxPoint(85, 246), new FlxPoint(-149, 213)];
				dickAngleArray[7] = [new FlxPoint(152, 561), new FlxPoint(85, 246), new FlxPoint(-149, 213)];
				dickAngleArray[8] = [new FlxPoint(152, 560), new FlxPoint(85, 246), new FlxPoint(-149, 213)];
				dickAngleArray[9] = [new FlxPoint(152, 560), new FlxPoint(85, 246), new FlxPoint(-149, 213)];
				dickAngleArray[10] = [new FlxPoint(152, 560), new FlxPoint(85, 246), new FlxPoint(-149, 213)];
				dickAngleArray[11] = [new FlxPoint(151, 563), new FlxPoint(85, 246), new FlxPoint(-149, 213)];
				dickAngleArray[12] = [new FlxPoint(151, 563), new FlxPoint(85, 246), new FlxPoint(-149, 213)];
				dickAngleArray[13] = [new FlxPoint(151, 563), new FlxPoint(85, 246), new FlxPoint(-149, 213)];
				dickAngleArray[14] = [new FlxPoint(151, 563), new FlxPoint(85, 246), new FlxPoint(-149, 213)];
				dickAngleArray[15] = [new FlxPoint(151, 563), new FlxPoint(85, 246), new FlxPoint(-149, 213)];
				dickAngleArray[16] = [new FlxPoint(151, 563), new FlxPoint(85, 246), new FlxPoint(-149, 213)];
				dickAngleArray[17] = [new FlxPoint(151, 563), new FlxPoint(85, 246), new FlxPoint( -149, 213)];
				dickAngleArray[18] = [new FlxPoint(164, 420), new FlxPoint(87, -245), new FlxPoint(-174, -193)];
				dickAngleArray[19] = [new FlxPoint(164, 420), new FlxPoint(99, -240), new FlxPoint(-152, -211)];
				dickAngleArray[20] = [new FlxPoint(164, 420), new FlxPoint(97, -241), new FlxPoint(-170, -197)];
				dickAngleArray[21] = [new FlxPoint(163, 421), new FlxPoint(114, -234), new FlxPoint(-182, -186)];
				dickAngleArray[22] = [new FlxPoint(163, 421), new FlxPoint(104, -238), new FlxPoint(-165, -201)];
				dickAngleArray[23] = [new FlxPoint(165, 422), new FlxPoint(99, -240), new FlxPoint(-182, -186)];
				dickAngleArray[24] = [new FlxPoint(166, 422), new FlxPoint(114, -233), new FlxPoint(-175, -193)];
				dickAngleArray[25] = [new FlxPoint(166, 422), new FlxPoint(92, -243), new FlxPoint(-184, -184)];
				dickAngleArray[26] = [new FlxPoint(166, 422), new FlxPoint(124, -228), new FlxPoint(-171, -196)];
				dickAngleArray[27] = [new FlxPoint(165, 422), new FlxPoint(92, -243), new FlxPoint( -190, -177)];
			}
			else
			{
				dickAngleArray[0] = [new FlxPoint(176, 484), new FlxPoint(179, 189), new FlxPoint(-184, 184)];
				dickAngleArray[1] = [new FlxPoint(177, 486), new FlxPoint(170, 197), new FlxPoint(-184, 184)];
				dickAngleArray[2] = [new FlxPoint(177, 486), new FlxPoint(167, 199), new FlxPoint(-188, 180)];
				dickAngleArray[3] = [new FlxPoint(180, 483), new FlxPoint(226, 128), new FlxPoint(-108, 237)];
				dickAngleArray[4] = [new FlxPoint(180, 483), new FlxPoint(204, 161), new FlxPoint(-184, 184)];
				dickAngleArray[5] = [new FlxPoint(177, 482), new FlxPoint(196, 171), new FlxPoint(-197, 169)];
				dickAngleArray[6] = [new FlxPoint(177, 483), new FlxPoint(165, 201), new FlxPoint(-240, 99)];
				dickAngleArray[7] = [new FlxPoint(176, 483), new FlxPoint(163, 202), new FlxPoint(-247, 80)];
				dickAngleArray[8] = [new FlxPoint(180, 482), new FlxPoint(195, 172), new FlxPoint(-188, 180)];
				dickAngleArray[9] = [new FlxPoint(180, 482), new FlxPoint(206, 159), new FlxPoint(-211, 152)];
				dickAngleArray[10] = [new FlxPoint(179, 482), new FlxPoint(215, 146), new FlxPoint(-216, 144)];
				dickAngleArray[11] = [new FlxPoint(179, 480), new FlxPoint(222, 135), new FlxPoint(-222, 135)];
				dickAngleArray[12] = [new FlxPoint(177, 480), new FlxPoint(231, 120), new FlxPoint(-242, 96)];
				dickAngleArray[13] = [new FlxPoint(183, 481), new FlxPoint(227, 127), new FlxPoint(-204, 161)];
				dickAngleArray[14] = [new FlxPoint(181, 479), new FlxPoint(224, 131), new FlxPoint(-217, 143)];
				dickAngleArray[15] = [new FlxPoint(180, 479), new FlxPoint(217, 143), new FlxPoint(-222, 136)];
				dickAngleArray[16] = [new FlxPoint(180, 480), new FlxPoint(226, 128), new FlxPoint(-227, 127)];
				dickAngleArray[17] = [new FlxPoint(182, 482), new FlxPoint(214, 148), new FlxPoint(-222, 135)];
				dickAngleArray[18] = [new FlxPoint(181, 482), new FlxPoint(204, 161), new FlxPoint(-228, 125)];
				dickAngleArray[19] = [new FlxPoint(179, 483), new FlxPoint(180, 188), new FlxPoint(-171, 196)];
				dickAngleArray[20] = [new FlxPoint(179, 483), new FlxPoint(188, 180), new FlxPoint(-188, 180)];
				dickAngleArray[21] = [new FlxPoint(179, 484), new FlxPoint(188, 180), new FlxPoint(-191, 176)];
				dickAngleArray[22] = [new FlxPoint(178, 485), new FlxPoint(203, 162), new FlxPoint(-205, 160)];
				dickAngleArray[23] = [new FlxPoint(179, 484), new FlxPoint(216, 145), new FlxPoint(-219, 140)];
				dickAngleArray[24] = [new FlxPoint(178, 484), new FlxPoint(220, 138), new FlxPoint(-223, 134)];
				dickAngleArray[25] = [new FlxPoint(180, 483), new FlxPoint(220, 138), new FlxPoint(-222, 135)];
				dickAngleArray[26] = [new FlxPoint(179, 485), new FlxPoint(239, 102), new FlxPoint(-235, 110)];
				dickAngleArray[27] = [new FlxPoint(179, 485), new FlxPoint(229, 123), new FlxPoint(-224, 131)];
			}

			var headSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			headSweatArray[0] = [new FlxPoint(122, 100), new FlxPoint(148, 76), new FlxPoint(208, 74), new FlxPoint(248, 108), new FlxPoint(209, 96), new FlxPoint(202, 117), new FlxPoint(150, 121), new FlxPoint(147, 100)];
			headSweatArray[1] = [new FlxPoint(122, 100), new FlxPoint(148, 76), new FlxPoint(208, 74), new FlxPoint(248, 108), new FlxPoint(209, 96), new FlxPoint(202, 117), new FlxPoint(150, 121), new FlxPoint(147, 100)];
			headSweatArray[2] = [new FlxPoint(122, 100), new FlxPoint(148, 76), new FlxPoint(208, 74), new FlxPoint(248, 108), new FlxPoint(209, 96), new FlxPoint(202, 117), new FlxPoint(150, 121), new FlxPoint(147, 100)];
			headSweatArray[3] = [new FlxPoint(114, 120), new FlxPoint(135, 82), new FlxPoint(186, 78), new FlxPoint(223, 94), new FlxPoint(179, 97), new FlxPoint(174, 118), new FlxPoint(118, 133)];
			headSweatArray[4] = [new FlxPoint(114, 120), new FlxPoint(135, 82), new FlxPoint(186, 78), new FlxPoint(223, 94), new FlxPoint(179, 97), new FlxPoint(174, 118), new FlxPoint(118, 133)];
			headSweatArray[6] = [new FlxPoint(114, 120), new FlxPoint(135, 82), new FlxPoint(186, 78), new FlxPoint(223, 94), new FlxPoint(179, 97), new FlxPoint(174, 118), new FlxPoint(118, 133)];
			headSweatArray[7] = [new FlxPoint(114, 120), new FlxPoint(135, 82), new FlxPoint(186, 78), new FlxPoint(223, 94), new FlxPoint(179, 97), new FlxPoint(174, 118), new FlxPoint(118, 133)];
			headSweatArray[8] = [new FlxPoint(114, 120), new FlxPoint(135, 82), new FlxPoint(186, 78), new FlxPoint(223, 94), new FlxPoint(179, 97), new FlxPoint(174, 118), new FlxPoint(118, 133)];
			headSweatArray[9] = [new FlxPoint(123, 94), new FlxPoint(157, 70), new FlxPoint(213, 76), new FlxPoint(247, 113), new FlxPoint(207, 98), new FlxPoint(202, 126), new FlxPoint(146, 116), new FlxPoint(150, 96)];
			headSweatArray[10] = [new FlxPoint(123, 94), new FlxPoint(157, 70), new FlxPoint(213, 76), new FlxPoint(247, 113), new FlxPoint(207, 98), new FlxPoint(202, 126), new FlxPoint(146, 116), new FlxPoint(150, 96)];
			headSweatArray[11] = [new FlxPoint(123, 94), new FlxPoint(157, 70), new FlxPoint(213, 76), new FlxPoint(247, 113), new FlxPoint(207, 98), new FlxPoint(202, 126), new FlxPoint(146, 116), new FlxPoint(150, 96)];
			headSweatArray[12] = [new FlxPoint(156, 132), new FlxPoint(144, 105), new FlxPoint(122, 99), new FlxPoint(152, 76), new FlxPoint(214, 77), new FlxPoint(245, 107), new FlxPoint(211, 105), new FlxPoint(204, 132)];
			headSweatArray[13] = [new FlxPoint(156, 132), new FlxPoint(144, 105), new FlxPoint(122, 99), new FlxPoint(152, 76), new FlxPoint(214, 77), new FlxPoint(245, 107), new FlxPoint(211, 105), new FlxPoint(204, 132)];
			headSweatArray[14] = [new FlxPoint(156, 132), new FlxPoint(144, 105), new FlxPoint(122, 99), new FlxPoint(152, 76), new FlxPoint(214, 77), new FlxPoint(245, 107), new FlxPoint(211, 105), new FlxPoint(204, 132)];
			headSweatArray[18] = [new FlxPoint(132, 90), new FlxPoint(170, 72), new FlxPoint(226, 85), new FlxPoint(250, 114), new FlxPoint(223, 106), new FlxPoint(220, 120), new FlxPoint(167, 113), new FlxPoint(164, 90)];
			headSweatArray[19] = [new FlxPoint(132, 90), new FlxPoint(170, 72), new FlxPoint(226, 85), new FlxPoint(250, 114), new FlxPoint(223, 106), new FlxPoint(220, 120), new FlxPoint(167, 113), new FlxPoint(164, 90)];
			headSweatArray[20] = [new FlxPoint(132, 90), new FlxPoint(170, 72), new FlxPoint(226, 85), new FlxPoint(250, 114), new FlxPoint(223, 106), new FlxPoint(220, 120), new FlxPoint(167, 113), new FlxPoint(164, 90)];
			headSweatArray[21] = [new FlxPoint(124, 91), new FlxPoint(159, 70), new FlxPoint(198, 69), new FlxPoint(234, 93), new FlxPoint(202, 90), new FlxPoint(199, 103), new FlxPoint(150, 106), new FlxPoint(148, 89)];
			headSweatArray[22] = [new FlxPoint(124, 91), new FlxPoint(159, 70), new FlxPoint(198, 69), new FlxPoint(234, 93), new FlxPoint(202, 90), new FlxPoint(199, 103), new FlxPoint(150, 106), new FlxPoint(148, 89)];
			headSweatArray[23] = [new FlxPoint(124, 91), new FlxPoint(159, 70), new FlxPoint(198, 69), new FlxPoint(234, 93), new FlxPoint(202, 90), new FlxPoint(199, 103), new FlxPoint(150, 106), new FlxPoint(148, 89)];
			headSweatArray[24] = [new FlxPoint(124, 101), new FlxPoint(146, 75), new FlxPoint(202, 68), new FlxPoint(238, 94), new FlxPoint(209, 93), new FlxPoint(211, 107), new FlxPoint(156, 114), new FlxPoint(150, 98)];
			headSweatArray[25] = [new FlxPoint(124, 101), new FlxPoint(146, 75), new FlxPoint(202, 68), new FlxPoint(238, 94), new FlxPoint(209, 93), new FlxPoint(211, 107), new FlxPoint(156, 114), new FlxPoint(150, 98)];
			headSweatArray[26] = [new FlxPoint(124, 101), new FlxPoint(146, 75), new FlxPoint(202, 68), new FlxPoint(238, 94), new FlxPoint(209, 93), new FlxPoint(211, 107), new FlxPoint(156, 114), new FlxPoint(150, 98)];
			headSweatArray[27] = [new FlxPoint(113, 110), new FlxPoint(141, 77), new FlxPoint(193, 66), new FlxPoint(235, 98), new FlxPoint(187, 90), new FlxPoint(185, 112), new FlxPoint(134, 123), new FlxPoint(136, 101)];
			headSweatArray[28] = [new FlxPoint(113, 110), new FlxPoint(141, 77), new FlxPoint(193, 66), new FlxPoint(235, 98), new FlxPoint(187, 90), new FlxPoint(185, 112), new FlxPoint(134, 123), new FlxPoint(136, 101)];
			headSweatArray[29] = [new FlxPoint(113, 110), new FlxPoint(141, 77), new FlxPoint(193, 66), new FlxPoint(235, 98), new FlxPoint(187, 90), new FlxPoint(185, 112), new FlxPoint(134, 123), new FlxPoint(136, 101)];
			headSweatArray[30] = [new FlxPoint(116, 110), new FlxPoint(146, 77), new FlxPoint(213, 77), new FlxPoint(247, 115), new FlxPoint(211, 105), new FlxPoint(206, 127), new FlxPoint(156, 126), new FlxPoint(152, 102)];
			headSweatArray[31] = [new FlxPoint(116, 110), new FlxPoint(146, 77), new FlxPoint(213, 77), new FlxPoint(247, 115), new FlxPoint(211, 105), new FlxPoint(206, 127), new FlxPoint(156, 126), new FlxPoint(152, 102)];
			headSweatArray[32] = [new FlxPoint(116, 110), new FlxPoint(146, 77), new FlxPoint(213, 77), new FlxPoint(247, 115), new FlxPoint(211, 105), new FlxPoint(206, 127), new FlxPoint(156, 126), new FlxPoint(152, 102)];
			headSweatArray[33] = [new FlxPoint(117, 106), new FlxPoint(155, 73), new FlxPoint(206, 74), new FlxPoint(248, 109), new FlxPoint(216, 96), new FlxPoint(208, 110), new FlxPoint(156, 114), new FlxPoint(154, 98)];
			headSweatArray[34] = [new FlxPoint(117, 106), new FlxPoint(155, 73), new FlxPoint(206, 74), new FlxPoint(248, 109), new FlxPoint(216, 96), new FlxPoint(208, 110), new FlxPoint(156, 114), new FlxPoint(154, 98)];
			headSweatArray[35] = [new FlxPoint(117, 106), new FlxPoint(155, 73), new FlxPoint(206, 74), new FlxPoint(248, 109), new FlxPoint(216, 96), new FlxPoint(208, 110), new FlxPoint(156, 114), new FlxPoint(154, 98)];
			headSweatArray[36] = [new FlxPoint(117, 106), new FlxPoint(155, 73), new FlxPoint(206, 74), new FlxPoint(248, 109), new FlxPoint(216, 96), new FlxPoint(208, 110), new FlxPoint(156, 114), new FlxPoint(154, 98)];
			headSweatArray[37] = [new FlxPoint(117, 106), new FlxPoint(155, 73), new FlxPoint(206, 74), new FlxPoint(248, 109), new FlxPoint(216, 96), new FlxPoint(208, 110), new FlxPoint(156, 114), new FlxPoint(154, 98)];
			headSweatArray[39] = [new FlxPoint(111, 114), new FlxPoint(134, 83), new FlxPoint(192, 73), new FlxPoint(244, 104), new FlxPoint(192, 91), new FlxPoint(192, 108), new FlxPoint(148, 119), new FlxPoint(139, 104)];
			headSweatArray[40] = [new FlxPoint(111, 114), new FlxPoint(134, 83), new FlxPoint(192, 73), new FlxPoint(244, 104), new FlxPoint(192, 91), new FlxPoint(192, 108), new FlxPoint(148, 119), new FlxPoint(139, 104)];
			headSweatArray[42] = [new FlxPoint(117, 109), new FlxPoint(166, 66), new FlxPoint(226, 77), new FlxPoint(253, 122), new FlxPoint(228, 105), new FlxPoint(223, 120), new FlxPoint(181, 112), new FlxPoint(174, 91)];
			headSweatArray[43] = [new FlxPoint(117, 109), new FlxPoint(166, 66), new FlxPoint(226, 77), new FlxPoint(253, 122), new FlxPoint(228, 105), new FlxPoint(223, 120), new FlxPoint(181, 112), new FlxPoint(174, 91)];
			headSweatArray[45] = [new FlxPoint(116, 106), new FlxPoint(154, 72), new FlxPoint(203, 68), new FlxPoint(248, 114), new FlxPoint(205, 105), new FlxPoint(205, 130), new FlxPoint(154, 132), new FlxPoint(150, 111)];
			headSweatArray[46] = [new FlxPoint(116, 106), new FlxPoint(154, 72), new FlxPoint(203, 68), new FlxPoint(248, 114), new FlxPoint(205, 105), new FlxPoint(205, 130), new FlxPoint(154, 132), new FlxPoint(150, 111)];
			headSweatArray[47] = [new FlxPoint(116, 106), new FlxPoint(154, 72), new FlxPoint(203, 68), new FlxPoint(248, 114), new FlxPoint(205, 105), new FlxPoint(205, 130), new FlxPoint(154, 132), new FlxPoint(150, 111)];
			headSweatArray[48] = [new FlxPoint(125, 95), new FlxPoint(164, 71), new FlxPoint(224, 83), new FlxPoint(255, 123), new FlxPoint(226, 105), new FlxPoint(214, 124), new FlxPoint(167, 116), new FlxPoint(165, 97)];
			headSweatArray[49] = [new FlxPoint(125, 95), new FlxPoint(164, 71), new FlxPoint(224, 83), new FlxPoint(255, 123), new FlxPoint(226, 105), new FlxPoint(214, 124), new FlxPoint(167, 116), new FlxPoint(165, 97)];
			headSweatArray[50] = [new FlxPoint(125, 95), new FlxPoint(164, 71), new FlxPoint(224, 83), new FlxPoint(255, 123), new FlxPoint(226, 105), new FlxPoint(214, 124), new FlxPoint(167, 116), new FlxPoint(165, 97)];
			headSweatArray[51] = [new FlxPoint(118, 107), new FlxPoint(150, 73), new FlxPoint(216, 79), new FlxPoint(248, 117), new FlxPoint(216, 97), new FlxPoint(203, 114), new FlxPoint(163, 115), new FlxPoint(158, 97)];
			headSweatArray[52] = [new FlxPoint(118, 107), new FlxPoint(150, 73), new FlxPoint(216, 79), new FlxPoint(248, 117), new FlxPoint(216, 97), new FlxPoint(203, 114), new FlxPoint(163, 115), new FlxPoint(158, 97)];
			headSweatArray[53] = [new FlxPoint(118, 107), new FlxPoint(150, 73), new FlxPoint(216, 79), new FlxPoint(248, 117), new FlxPoint(216, 97), new FlxPoint(203, 114), new FlxPoint(163, 115), new FlxPoint(158, 97)];
			headSweatArray[54] = [new FlxPoint(120, 103), new FlxPoint(156, 74), new FlxPoint(208, 72), new FlxPoint(239, 101), new FlxPoint(204, 93), new FlxPoint(198, 106), new FlxPoint(155, 105), new FlxPoint(153, 95)];
			headSweatArray[55] = [new FlxPoint(120, 103), new FlxPoint(156, 74), new FlxPoint(208, 72), new FlxPoint(239, 101), new FlxPoint(204, 93), new FlxPoint(198, 106), new FlxPoint(155, 105), new FlxPoint(153, 95)];
			headSweatArray[57] = [new FlxPoint(122, 99), new FlxPoint(155, 73), new FlxPoint(206, 74), new FlxPoint(247, 108), new FlxPoint(208, 94), new FlxPoint(202, 112), new FlxPoint(155, 112), new FlxPoint(150, 99)];
			headSweatArray[58] = [new FlxPoint(122, 99), new FlxPoint(155, 73), new FlxPoint(206, 74), new FlxPoint(247, 108), new FlxPoint(208, 94), new FlxPoint(202, 112), new FlxPoint(155, 112), new FlxPoint(150, 99)];
			headSweatArray[60] = [new FlxPoint(115, 104), new FlxPoint(137, 73), new FlxPoint(193, 64), new FlxPoint(234, 96), new FlxPoint(184, 92), new FlxPoint(177, 110), new FlxPoint(137, 121), new FlxPoint(131, 104)];
			headSweatArray[61] = [new FlxPoint(115, 104), new FlxPoint(137, 73), new FlxPoint(193, 64), new FlxPoint(234, 96), new FlxPoint(184, 92), new FlxPoint(177, 110), new FlxPoint(137, 121), new FlxPoint(131, 104)];

			var torsoSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			torsoSweatArray[0] = [new FlxPoint(106, 456), new FlxPoint(79, 372), new FlxPoint(91, 278), new FlxPoint(125, 179), new FlxPoint(181, 163), new FlxPoint(243, 175), new FlxPoint(278, 277), new FlxPoint(290, 376), new FlxPoint(255, 464), new FlxPoint(202, 441), new FlxPoint(153, 436)];

			sweatAreas.splice(0, sweatAreas.length);
			sweatAreas.push({chance:4, sprite:_pokeWindow._head, sweatArrayArray:headSweatArray});
			sweatAreas.push({chance:6, sprite:_pokeWindow._torso4, sweatArrayArray:torsoSweatArray});

			breathAngleArray[0] = [new FlxPoint(172, 110), new FlxPoint(0, -80)];
			breathAngleArray[1] = [new FlxPoint(172, 110), new FlxPoint(0, -80)];
			breathAngleArray[2] = [new FlxPoint(172, 110), new FlxPoint(0, -80)];
			breathAngleArray[3] = [new FlxPoint(127, 128), new FlxPoint(-62, -50)];
			breathAngleArray[4] = [new FlxPoint(127, 128), new FlxPoint(-62, -50)];
			breathAngleArray[6] = [new FlxPoint(127, 128), new FlxPoint(-62, -50)];
			breathAngleArray[7] = [new FlxPoint(127, 128), new FlxPoint(-62, -50)];
			breathAngleArray[8] = [new FlxPoint(127, 128), new FlxPoint(-62, -50)];
			breathAngleArray[9] = [new FlxPoint(173, 112), new FlxPoint(17, -78)];
			breathAngleArray[10] = [new FlxPoint(173, 112), new FlxPoint(17, -78)];
			breathAngleArray[11] = [new FlxPoint(173, 112), new FlxPoint(17, -78)];
			breathAngleArray[12] = [new FlxPoint(174, 129), new FlxPoint(2, -80)];
			breathAngleArray[13] = [new FlxPoint(174, 129), new FlxPoint(2, -80)];
			breathAngleArray[14] = [new FlxPoint(174, 129), new FlxPoint(2, -80)];
			breathAngleArray[18] = [new FlxPoint(196, 109), new FlxPoint(33, -73)];
			breathAngleArray[19] = [new FlxPoint(196, 109), new FlxPoint(33, -73)];
			breathAngleArray[20] = [new FlxPoint(196, 109), new FlxPoint(33, -73)];
			breathAngleArray[21] = [new FlxPoint(167, 98), new FlxPoint(-15, -79)];
			breathAngleArray[22] = [new FlxPoint(167, 98), new FlxPoint(-15, -79)];
			breathAngleArray[23] = [new FlxPoint(167, 98), new FlxPoint(-15, -79)];
			breathAngleArray[24] = [new FlxPoint(182, 108), new FlxPoint(10, -79)];
			breathAngleArray[25] = [new FlxPoint(182, 108), new FlxPoint(10, -79)];
			breathAngleArray[26] = [new FlxPoint(182, 108), new FlxPoint(10, -79)];
			breathAngleArray[27] = [new FlxPoint(140, 109), new FlxPoint(-45, -66)];
			breathAngleArray[28] = [new FlxPoint(140, 109), new FlxPoint(-45, -66)];
			breathAngleArray[29] = [new FlxPoint(140, 109), new FlxPoint(-45, -66)];
			breathAngleArray[30] = [new FlxPoint(178, 130), new FlxPoint(7, -80)];
			breathAngleArray[31] = [new FlxPoint(178, 130), new FlxPoint(7, -80)];
			breathAngleArray[32] = [new FlxPoint(178, 130), new FlxPoint(7, -80)];
			breathAngleArray[33] = [new FlxPoint(186, 110), new FlxPoint(25, -76)];
			breathAngleArray[34] = [new FlxPoint(186, 110), new FlxPoint(25, -76)];
			breathAngleArray[35] = [new FlxPoint(186, 110), new FlxPoint(25, -76)];
			breathAngleArray[36] = [new FlxPoint(168, 107), new FlxPoint(-12, -79)];
			breathAngleArray[37] = [new FlxPoint(168, 107), new FlxPoint(-12, -79)];
			breathAngleArray[39] = [new FlxPoint(168, 107), new FlxPoint(-12, -79)];
			breathAngleArray[40] = [new FlxPoint(168, 107), new FlxPoint(-12, -79)];
			breathAngleArray[42] = [new FlxPoint(216, 114), new FlxPoint(48, -64)];
			breathAngleArray[43] = [new FlxPoint(216, 114), new FlxPoint(48, -64)];
			breathAngleArray[45] = [new FlxPoint(176, 136), new FlxPoint(-5, -80)];
			breathAngleArray[46] = [new FlxPoint(176, 136), new FlxPoint(-5, -80)];
			breathAngleArray[47] = [new FlxPoint(176, 136), new FlxPoint(-5, -80)];
			breathAngleArray[48] = [new FlxPoint(198, 117), new FlxPoint(32, -73)];
			breathAngleArray[49] = [new FlxPoint(198, 117), new FlxPoint(32, -73)];
			breathAngleArray[50] = [new FlxPoint(198, 117), new FlxPoint(32, -73)];
			breathAngleArray[51] = [new FlxPoint(188, 104), new FlxPoint(15, -79)];
			breathAngleArray[52] = [new FlxPoint(188, 104), new FlxPoint(15, -79)];
			breathAngleArray[53] = [new FlxPoint(188, 104), new FlxPoint(15, -79)];
			breathAngleArray[54] = [new FlxPoint(173, 98), new FlxPoint(-6, -80)];
			breathAngleArray[55] = [new FlxPoint(173, 98), new FlxPoint(-6, -80)];
			breathAngleArray[57] = [new FlxPoint(173, 98), new FlxPoint(-6, -80)];
			breathAngleArray[57] = [new FlxPoint(171, 111), new FlxPoint(-8, -80)];
			breathAngleArray[58] = [new FlxPoint(171, 111), new FlxPoint(-8, -80)];
			breathAngleArray[60] = [new FlxPoint(145, 111), new FlxPoint(-41, -69)];
			breathAngleArray[61] = [new FlxPoint(145, 111), new FlxPoint( -41, -69)];

			armKnotArray = new Array<Array<FlxPoint>>();
			armKnotArray[0] = [new FlxPoint(91, 348), new FlxPoint(77, 265), new FlxPoint(102, 192), new FlxPoint(259, 188), new FlxPoint(295, 236), new FlxPoint(283, 300)];
			armKnotArray[1] = [new FlxPoint(60, 112), new FlxPoint(61, 165), new FlxPoint(96, 207), new FlxPoint(274, 190), new FlxPoint(301, 146), new FlxPoint(300, 94)];
			armKnotArray[2] = [new FlxPoint(91, 351), new FlxPoint(86, 272), new FlxPoint(106, 194), new FlxPoint(264, 197), new FlxPoint(293, 275), new FlxPoint(285, 356)];
			armKnotArray[3] = [new FlxPoint(85, 313), new FlxPoint(73, 244), new FlxPoint(106, 192), new FlxPoint(267, 196), new FlxPoint(292, 274), new FlxPoint(275, 346)];
			armKnotArray[4] = [new FlxPoint(91, 292), new FlxPoint(68, 228), new FlxPoint(105, 192), new FlxPoint(255, 189), new FlxPoint(295, 240), new FlxPoint(277, 304)];

			legKnotArray = new Array<Array<FlxPoint>>();
			legKnotArray[0] = [new FlxPoint(85, 535), new FlxPoint(77, 476), new FlxPoint(83, 424), new FlxPoint(290, 429), new FlxPoint(293, 491), new FlxPoint(284, 543)];
			legKnotArray[1] = [new FlxPoint(86, 524), new FlxPoint(78, 474), new FlxPoint(83, 426), new FlxPoint(287, 427), new FlxPoint(290, 486), new FlxPoint(281, 533)];
			legKnotArray[2] = [new FlxPoint(81, 531), new FlxPoint(75, 480), new FlxPoint(78, 429), new FlxPoint(287, 431), new FlxPoint(290, 483), new FlxPoint(285, 544)];

			torsoKnotArray = new Array<Array<FlxPoint>>();
			torsoKnotArray[0] = [new FlxPoint(145, 416), new FlxPoint(150, 299), new FlxPoint(149, 196), new FlxPoint(221, 205), new FlxPoint(226, 300), new FlxPoint(229, 413)];
		}
		else {
			// anal bead window
			if (_male)
			{
				dickAngleArray[0] = [new FlxPoint(160, 345), new FlxPoint(87, -245), new FlxPoint(-65, -252)];
				dickAngleArray[1] = [new FlxPoint(155, 323), new FlxPoint(37, -257), new FlxPoint(-45, -256)];
				dickAngleArray[2] = [new FlxPoint(160, 304), new FlxPoint(28, -259), new FlxPoint(5, -260)];
			}
			else {
				dickAngleArray[0] = [new FlxPoint(153, 458), new FlxPoint(245, 87), new FlxPoint(-223, 134)];
			}

			breathAngleArray[0] = [new FlxPoint(176, 279), new FlxPoint(62, 50)];
			breathAngleArray[1] = [new FlxPoint(176, 279), new FlxPoint(62, 50)];
			breathAngleArray[2] = [new FlxPoint(176, 279), new FlxPoint(62, 50)];
			breathAngleArray[3] = [new FlxPoint(181, 257), new FlxPoint(-13, -79)];
			breathAngleArray[4] = [new FlxPoint(181, 257), new FlxPoint( -13, -79)];

			var headSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			headSweatArray[0] = [new FlxPoint(117, 232), new FlxPoint(74, 225), new FlxPoint(72, 190), new FlxPoint(94, 155), new FlxPoint(152, 147), new FlxPoint(178, 170), new FlxPoint(182, 178), new FlxPoint(161, 216)];
			headSweatArray[1] = [new FlxPoint(117, 232), new FlxPoint(74, 225), new FlxPoint(72, 190), new FlxPoint(94, 155), new FlxPoint(152, 147), new FlxPoint(178, 170), new FlxPoint(182, 178), new FlxPoint(161, 216)];
			headSweatArray[2] = [new FlxPoint(117, 232), new FlxPoint(74, 225), new FlxPoint(72, 190), new FlxPoint(94, 155), new FlxPoint(152, 147), new FlxPoint(178, 170), new FlxPoint(182, 178), new FlxPoint(161, 216)];

			var bodySweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			bodySweatArray[0] = [new FlxPoint(54, 402), new FlxPoint(72, 445), new FlxPoint(156, 453), new FlxPoint(249, 432), new FlxPoint(282, 404), new FlxPoint(304, 358), new FlxPoint(303, 328), new FlxPoint(247, 284), new FlxPoint(182, 275), new FlxPoint(123, 299), new FlxPoint(81, 340)];
			bodySweatArray[1] = [new FlxPoint(54, 402), new FlxPoint(72, 445), new FlxPoint(156, 453), new FlxPoint(249, 432), new FlxPoint(282, 404), new FlxPoint(304, 358), new FlxPoint(303, 328), new FlxPoint(280, 300), new FlxPoint(212, 274), new FlxPoint(134, 288), new FlxPoint(94, 319), new FlxPoint(70, 361)];
			bodySweatArray[2] = [new FlxPoint(54, 402), new FlxPoint(72, 445), new FlxPoint(156, 453), new FlxPoint(249, 432), new FlxPoint(282, 404), new FlxPoint(304, 358), new FlxPoint(303, 328), new FlxPoint(284, 299), new FlxPoint(224, 273), new FlxPoint(149, 275), new FlxPoint(101, 309), new FlxPoint(73, 351)];
			bodySweatArray[3] = [new FlxPoint(54, 402), new FlxPoint(72, 445), new FlxPoint(156, 453), new FlxPoint(249, 432), new FlxPoint(282, 404), new FlxPoint(304, 358), new FlxPoint(303, 328), new FlxPoint(282, 297), new FlxPoint(229, 272), new FlxPoint(152, 273), new FlxPoint(101, 308), new FlxPoint(69, 352)];
			bodySweatArray[4] = [new FlxPoint(54, 402), new FlxPoint(72, 445), new FlxPoint(156, 453), new FlxPoint(249, 432), new FlxPoint(282, 404), new FlxPoint(266, 310), new FlxPoint(226, 253), new FlxPoint(189, 237), new FlxPoint(122, 242), new FlxPoint(85, 265), new FlxPoint(62, 324)];
			bodySweatArray[5] = [new FlxPoint(54, 402), new FlxPoint(72, 445), new FlxPoint(156, 453), new FlxPoint(249, 432), new FlxPoint(282, 404), new FlxPoint(266, 310), new FlxPoint(226, 253), new FlxPoint(179, 231), new FlxPoint(135, 233), new FlxPoint(84, 261), new FlxPoint(61, 312)];
			bodySweatArray[6] = [new FlxPoint(54, 402), new FlxPoint(72, 445), new FlxPoint(156, 453), new FlxPoint(249, 432), new FlxPoint(282, 404), new FlxPoint(266, 310), new FlxPoint(226, 253), new FlxPoint(193, 234), new FlxPoint(147, 233), new FlxPoint(88, 258), new FlxPoint(67, 298)];
			bodySweatArray[7] = [new FlxPoint(54, 402), new FlxPoint(72, 445), new FlxPoint(156, 453), new FlxPoint(249, 432), new FlxPoint(282, 404), new FlxPoint(266, 310), new FlxPoint(228, 249), new FlxPoint(177, 226), new FlxPoint(112, 234), new FlxPoint(74, 274), new FlxPoint(65, 309)];

			sweatAreas.splice(0, sweatAreas.length);
			sweatAreas.push({chance:4, sprite:_toyWindow._headUp, sweatArrayArray:headSweatArray});
			sweatAreas.push({chance:6, sprite:_toyWindow._body, sweatArrayArray:bodySweatArray});
		}

		encouragementWords = wordManager.newWords();
		encouragementWords.words.push([ { graphic:AssetPaths.rhydon_words_small__png, frame:0 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.rhydon_words_small__png, frame:1 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.rhydon_words_small__png, frame:2 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.rhydon_words_small__png, frame:3 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.rhydon_words_small__png, frame:4 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.rhydon_words_small__png, frame:5 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.rhydon_words_small__png, frame:6 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.rhydon_words_small__png, frame:7 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.rhydon_words_small__png, frame:8 } ]);

		boredWords = wordManager.newWords(8);
		boredWords.words.push([{ graphic:AssetPaths.rhydon_words_small__png, frame:9 }]);
		boredWords.words.push([{ graphic:AssetPaths.rhydon_words_small__png, frame:10 }]);
		// roar? you there?
		boredWords.words.push([
		{ graphic:AssetPaths.rhydon_words_small__png, frame:11 },
		{ graphic:AssetPaths.rhydon_words_small__png, frame:13, yOffset:24, delay:0.7 }
		]);

		pleasureWords = wordManager.newWords(10);
		pleasureWords.words.push([{ graphic:AssetPaths.rhydon_words_medium0__png, frame:0, width:256, height:48, chunkSize:8 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.rhydon_words_medium0__png, frame:1, width:256, height:48, chunkSize:8 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.rhydon_words_medium0__png, frame:2, width:256, height:48, chunkSize:8 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.rhydon_words_medium0__png, frame:3, width:256, height:48, chunkSize:8 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.rhydon_words_medium0__png, frame:4, width:256, height:48, chunkSize:8 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.rhydon_words_medium0__png, frame:5, width:256, height:48, chunkSize:8 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.rhydon_words_medium0__png, frame:6, width:256, height:48, chunkSize:8 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.rhydon_words_medium0__png, frame:7, width:256, height:48, chunkSize:8 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.rhydon_words_medium0__png, frame:8, width:256, height:48, chunkSize:8 } ]);

		almostWords = wordManager.newWords(40);
		// ...wrraarrrr.... here it... c-comes...
		almostWords.words.push([
		{ graphic:AssetPaths.rhydon_words_medium1__png, frame:0, width:256, height:48, chunkSize:8 },
		{ graphic:AssetPaths.rhydon_words_medium1__png, frame:1, width:256, height:48, chunkSize:8, yOffset:36, delay:1.0 },
		{ graphic:AssetPaths.rhydon_words_medium1__png, frame:2, width:256, height:48, chunkSize:8, yOffset:68, delay:2.0 }
		]);
		// -nngghhhhhh!!! i'm gonna... go-gonna...!
		almostWords.words.push([
		{ graphic:AssetPaths.rhydon_words_medium1__png, frame:3, width:256, height:48, chunkSize:15 },
		{ graphic:AssetPaths.rhydon_words_medium1__png, frame:4, width:256, height:48, chunkSize:8, yOffset:30, delay:0.7 },
		{ graphic:AssetPaths.rhydon_words_medium1__png, frame:5, width:256, height:48, chunkSize:8, yOffset:58, delay:1.4 }
		]);
		// rrrrrrrrrrr.... ....alllmossst....
		almostWords.words.push([
		{ graphic:AssetPaths.rhydon_words_medium1__png, frame:6, width:256, height:48, chunkSize:5 },
		{ graphic:AssetPaths.rhydon_words_medium1__png, frame:7, width:256, height:48, chunkSize:5, yOffset:32, delay:0.8 }
		]);

		orgasmWords = wordManager.newWords();
		orgasmWords.words.push([ { graphic:AssetPaths.rhydon_words_large__png, frame:0, width:400, height:300, yOffset:-60, chunkSize:10 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.rhydon_words_large__png, frame:1, width:400, height:300, yOffset:-60, chunkSize:10 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.rhydon_words_large__png, frame:2, width:400, height:300, yOffset:-60, chunkSize:10 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.rhydon_words_large__png, frame:3, width:400, height:300, yOffset:-60, chunkSize:10 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.rhydon_words_large__png, frame:4, width:400, height:300, yOffset: -60, chunkSize:10 } ]);

		rubHeadWords = wordManager.newWords();
		// wow, you really know how to.... roar~
		rubHeadWords.words.push([
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:0, chunkSize:8 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:2, chunkSize:8, yOffset:22, delay:0.8 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:4, chunkSize:8, yOffset:40, delay:1.6 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:6, chunkSize:8, yOffset:62, delay:2.4 },
		]);
		if (PlayerData.gender != PlayerData.Gender.Girl)
		{
			// that's... that's not bad for a little guy... wroar~
			rubHeadWords.words.push([
			{ graphic:AssetPaths.rhydon_words_small1__png, frame:1, chunkSize:8 },
			{ graphic:AssetPaths.rhydon_words_small1__png, frame:3, chunkSize:8, yOffset:22, delay:0.8 },
			{ graphic:AssetPaths.rhydon_words_small1__png, frame:5, chunkSize:8, yOffset:44, delay:1.6 },
			{ graphic:AssetPaths.rhydon_words_small1__png, frame:7, chunkSize:8, yOffset:66, delay:2.4 },
			{ graphic:AssetPaths.rhydon_words_small1__png, frame:9, chunkSize:8, yOffset:88, delay:3.7 },
			]);
		}
		// thanks, i... i really needed this ....groar~
		rubHeadWords.words.push([
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:8, chunkSize:8 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:10, chunkSize:8, yOffset:22, delay:0.8 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:12, chunkSize:8, yOffset:44, delay:1.6 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:14, chunkSize:8, yOffset:66, delay:2.9 },
		]);
		// awww, it's nice to be with someone gentle for once... gr-roar!
		rubHeadWords.words.push([
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:11, chunkSize:13 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:13, chunkSize:13, yOffset:22, delay:0.7 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:15, chunkSize:13, yOffset:44, delay:1.4 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:17, chunkSize:13, yOffset:66, delay:2.1 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:19, chunkSize:13, yOffset:88, delay:2.8 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:21, chunkSize:13, yOffset:110, delay:3.5 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:23, chunkSize:13, yOffset:132, delay:4.7 },
		]);
		// your hand, it's... it's just so soft on my skin... wroar~
		rubHeadWords.words.push([
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:16, chunkSize:8 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:18, chunkSize:8, yOffset:22, delay:0.8 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:20, chunkSize:8, yOffset:44, delay:1.6 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:22, chunkSize:8, yOffset:66, delay:2.4 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:24, chunkSize:8, yOffset:88, delay:3.7 },
		]);
		// awww hey buddy. you're doin' great. gr-roar~
		rubHeadWords.words.push([
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:25, chunkSize:8 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:27, chunkSize:8, yOffset:24, delay:0.8 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:29, chunkSize:8, yOffset:48, delay:1.6 },
		{ graphic:AssetPaths.rhydon_words_small1__png, frame:31, chunkSize:8, yOffset:72, delay:2.9 },
		]);

		tooFastWords = wordManager.newWords(30);
		tooFastWords.words.push([{ graphic:AssetPaths.rhydon_words_medium2__png, frame:6, width:256, height:48, chunkSize:13 } ]);
		tooFastWords.words.push([{ graphic:AssetPaths.rhydon_words_medium2__png, frame:7, width:256, height:48, chunkSize:13 } ]);
		tooFastWords.words.push([{ graphic:AssetPaths.rhydon_words_medium2__png, frame:8, width:256, height:48, chunkSize:13 } ]);

		niceSlowWords = wordManager.newWords(60);
		// yeahhhh that's it. nice and slow...
		niceSlowWords.words.push([
		{ graphic:AssetPaths.rhydon_words_medium2__png, frame:0, width:256, height:48, chunkSize:8 },
		{ graphic:AssetPaths.rhydon_words_medium2__png, frame:1, width:256, height:48, chunkSize:8, yOffset:32, delay:1.4 },
		]);
		// just how i like it... ...rrrrrrrr...
		niceSlowWords.words.push([
		{ graphic:AssetPaths.rhydon_words_medium2__png, frame:2, width:256, height:48, chunkSize:8 },
		{ graphic:AssetPaths.rhydon_words_medium2__png, frame:3, width:256, height:48, chunkSize:8, yOffset:32, delay:1.4 },
		]);
		// that's perrrrfect. keep it slow~
		niceSlowWords.words.push([
		{ graphic:AssetPaths.rhydon_words_medium2__png, frame:4, width:256, height:48, chunkSize:8 },
		{ graphic:AssetPaths.rhydon_words_medium2__png, frame:5, width:256, height:48, chunkSize:8, yOffset:32, delay:1.4 },
		]);

		toyStartWords.words.push([ // whoa, take it easy with those! ...don't blow out my o-ring
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:0, chunkSize:13},
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:2, chunkSize:13, yOffset:21, delay:0.8 },
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:4, chunkSize:13, yOffset:38, delay:1.6 },
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:6, chunkSize:13, yOffset:38, delay:2.4 },
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:8, chunkSize:13, yOffset:57, delay:3.2 },
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:10, chunkSize:13, yOffset:78, delay:4.0 }
		]);
		toyStartWords.words.push([ // bringing out the big guns, eh? ...i can handle it!! gr-roarr!
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:1, chunkSize:13},
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:3, chunkSize:13, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:5, chunkSize:13, yOffset:37, delay:1.6 },
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:7, chunkSize:13, yOffset:37, delay:2.4 },
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:9, chunkSize:13, yOffset:57, delay:3.2 },
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:11, chunkSize:13, yOffset:79, delay:4.0 }
		]);
		toyStartWords.words.push([ // geez those things are fuckin' huge! where'd you get 'em? ...the huge things store?
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:12, chunkSize:13},
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:14, chunkSize:13, yOffset:19, delay:0.8 },
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:16, chunkSize:13, yOffset:38, delay:1.6 },
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:18, chunkSize:13, yOffset:61, delay:2.9 },
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:20, chunkSize:13, yOffset:82, delay:3.7 },
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:22, chunkSize:13, yOffset:82, delay:4.2 },
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:24, chunkSize:13, yOffset:101, delay:5.0 },
		{ graphic:AssetPaths.rhydbeads_words_small0__png, frame:26, chunkSize:13, yOffset:120, delay:5.8 }
		]);

		toyInterruptWords.words.push([ // maybe you can exchange those for some smaller ones.... gr... roarrr....
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:0, chunkSize:13},
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:2, chunkSize:13, yOffset:21, delay:0.8 },
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:4, chunkSize:13, yOffset:43, delay:1.6 },
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:6, chunkSize:13, yOffset:63, delay:2.4 },
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:8, chunkSize:13, yOffset:83, delay:3.2 },
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:10, chunkSize:13, yOffset:107, delay:4.5 },
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:12, chunkSize:13, yOffset:107, delay:5.0 }
		]);
		toyInterruptWords.words.push([ // ...hey-- you can't quit in the middle of a set!! wroar!!
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:1, chunkSize:13},
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:3, chunkSize:13, yOffset:0, delay:0.5 },
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:5, chunkSize:13, yOffset:20, delay:1.3 },
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:7, chunkSize:13, yOffset:42, delay:2.1 },
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:9, chunkSize:13, yOffset:60, delay:2.9 },
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:11, chunkSize:13, yOffset:80, delay:3.7 },
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:13, chunkSize:13, yOffset:102, delay:5.0 }
		]);
		toyInterruptWords.words.push([ // roar? ...you change your mind or somethin'?
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:14, chunkSize:13},
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:16, chunkSize:13, yOffset:0, delay:1.0 },
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:18, chunkSize:13, yOffset:24, delay:1.8 },
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:20, chunkSize:13, yOffset:46, delay:2.6 },
		{ graphic:AssetPaths.rhydbeads_words_small1__png, frame:22, chunkSize:13, yOffset:68, delay:3.4 }
		]);
	}

	override function penetrating():Bool
	{
		/*
		 * For female rhydon, all of these interactions involve her vagina so
		 * she's patient if you want to take your time. (The names are
		 * misleading)
		 */
		if (!_male && specialRub == "jack-off")
		{
			return true;
		}
		if (!_male && specialRub == "jack-foreskin")
		{
			return true;
		}
		if (!_male && specialRub == "rub-dick")
		{
			return true;
		}
		return false;
	}

	override public function determineArousal():Int
	{
		if (_forceMoodTimer < 0 && _forceMood >= 0)
		{
			return _forceMood;
		}
		if (_heartBank.getDickPercent() < 0.77)
		{
			return 4;
		}
		else if (_heartBank.getDickPercent() < 0.9)
		{
			return 3;
		}
		else if (pastBonerThreshold())
		{
			return 2;
		}
		else if (_heartBank.getForeplayPercent() < 0.77)
		{
			return 3;
		}
		else if (_heartBank.getForeplayPercent() < 0.9)
		{
			return 2;
		}
		else if (_heartBank._foreplayHeartReservoir < _heartBank._foreplayHeartReservoirCapacity)
		{
			return 1;
		}
		else {
			return 0;
		}
	}

	override public function checkSpecialRub(touchedPart:FlxSprite)
	{
		if (_fancyRub)
		{
			if (_rubHandAnim._flxSprite.animation.name == "rub-dick")
			{
				specialRub = "rub-dick";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-foreskin" || _rubHandAnim._flxSprite.animation.name == "rub-foreskin1")
			{
				specialRub = "rub-foreskin";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "jack-off")
			{
				specialRub = "jack-off";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "jack-foreskin")
			{
				specialRub = "jack-foreskin";
			}
		}
		else
		{
			if (touchedPart == _head)
			{
				specialRub = "head";
			}
		}
	}

	override public function computeChatComplaints(complaints:Array<Int>):Void
	{
		if (niceThings[0] == true)
		{
			complaints.push(FlxG.random.int(0, 2));
		}
		if (_orgasmPenalty <= 0.85)
		{
			complaints.push(3);
		}
		if (meanThings[0] == false)
		{
			complaints.push(4);
			complaints.push(4);
		}
		if (meanThings[1] == false)
		{
			if (_dickheadCount >= _dickshaftCount)
			{
				complaints.push(5);
			}
			else
			{
				complaints.push(6);
			}
		}
	}

	override function generateCumshots():Void
	{
		if (_neededKnotRubCount <= 0)
		{
			_heartBank._dickHeartReservoir += _knotBank;
			_knotBank = 0;
		}

		if (meanThings[1])
		{
			_dickheadCount = specialRubs.filter(function(s) { return s == "rub-foreskin" || s == "jack-foreskin"; } ).length;
			_dickshaftCount = specialRubs.filter(function(s) { return s == "rub-dick" || s == "jack-off"; } ).length;
			if (_dickheadCount >= _dickshaftCount * 4 || _dickshaftCount >= _dickheadCount * 4)
			{
				doMeanThing();
				meanThings[1] = false;
			}
		}

		if (!came)
		{
			// calculate orgasm penalties
			var medianTiming:Int = 3;
			var dickTimingTmp:Array<Int> = dickTiming.copy();
			dickTimingTmp.sort(function(a, b) return a < b ? -1 : 1);
			if (dickTimingTmp.length > 1)
			{
				medianTiming = dickTimingTmp[Std.int(dickTiming.length / 2)];
			}
			medianTiming -= rhydonMood2;
			_orgasmPenalty = 1.0;
			for (i in 3...medianTiming)
			{
				_orgasmPenalty *= 0.93;
			}
			_heartBank._dickHeartReservoir = SexyState.roundUpToQuarter(_orgasmPenalty * _heartBank._dickHeartReservoir);
			_heartBank._foreplayHeartReservoir = SexyState.roundUpToQuarter(_orgasmPenalty * _heartBank._foreplayHeartReservoir);
		}

		super.generateCumshots();
	}

	override function computePrecumAmount():Int
	{
		var precumAmount:Int = 0;
		if (FlxG.random.float(1, 10) < _heartEmitCount)
		{
			precumAmount++;
		}
		var bonus:Float = 0;
		if (dickTiming.length > 0)
		{
			if (dickTiming[dickTiming.length - 1] <= 3)
			{
				bonus = 1.0;
			}
			else if (dickTiming[dickTiming.length - 1] <= 4)
			{
				bonus = 0.5;
			}
			else if (dickTiming[dickTiming.length - 1] <= 5)
			{
				bonus = 0.25;
			}
			else if (dickTiming[dickTiming.length - 1] <= 6)
			{
				bonus = 0.125;
			}
		}
		if (FlxG.random.float(1, 60) < _heartEmitCount + bonus * 30)
		{
			precumAmount++;
		}
		if (FlxG.random.float(1, 100) < _heartEmitCount + ((specialRub == "rub-foreskin" || specialRub == "rub-foreskin1" || specialRub == "jack-foreskin") ? 40 : 0))
		{
			precumAmount++;
		}
		if (FlxG.random.float(0, 1.0) >= _heartBank.getDickPercent() - bonus * 0.3)
		{
			precumAmount++;
		}
		return precumAmount;
	}

	override function maybeEndSexyRubbing():Void
	{
		if (!_male)
		{
			// don't mess with vaginal animations for female; it's too jarring
		}
		else {
			super.maybeEndSexyRubbing();
			if (fancyRubbing(_dick) && _rubHandAnim._flxSprite.animation.name == "jack-foreskin")
			{
				_rubBodyAnim.setAnimName("rub-foreskin");
				_rubHandAnim.setAnimName("rub-foreskin");
				_rubBodyAnim.addAnimName("rub-foreskin1");
				_rubHandAnim.addAnimName("rub-foreskin1");
			}
		}
	}

	override function handleRubReward():Void
	{
		var spriteToKnotArrayMap:Map<FlxSprite, Array<Array<FlxPoint>>> = [_pokeWindow._arms0 => armKnotArray, _pokeWindow._torso0 => legKnotArray, _pokeWindow._torso1 => torsoKnotArray];

		if (!_male && (specialRub == "jack-off" || specialRub == "jack-foreskin"))
		{
			if (specialRub == "jack-off" || specialRub == "jack-foreskin" && _vagTightness > 3.4)
			{
				_vagTightness *= FlxG.random.float(0.72, 0.82);
			}

			var tightness0 = 3;
			var tightness1 = 4;
			if (_vagTightness > 3.9)
			{
				tightness0 = 3;
				tightness1 = 4;
			}
			else if (_vagTightness > 3.4)
			{
				tightness0 = 4;
				tightness1 = 5;
			}
			else if (_vagTightness > 2.4)
			{
				tightness0 = 5;
				tightness1 = 5;
			}
			else if (_vagTightness > 1.6)
			{
				tightness0 = 6;
				tightness1 = 5;
			}
			else if (_vagTightness > 1.0)
			{
				tightness0 = 7;
				tightness1 = 5;
			}
			else
			{
				tightness0 = 8;
				tightness1 = 5;
			}

			_dick.animation.add("jack-off", [19, 20, 21, 22, 23, 24, 25, 26, 27].slice(0, tightness0));
			_pokeWindow._interact.animation.add("jack-off", [16, 17, 18, 19, 20, 21, 22, 23, 24].slice(0, tightness0));
			_dick.animation.add("jack-foreskin", [8, 9, 10, 11, 12].slice(0, tightness1));
			_pokeWindow._interact.animation.add("jack-foreskin", [5, 6, 7, 8, 9].slice(0, tightness1));
			if (_rubBodyAnim != null)
			{
				_rubBodyAnim.refreshSoon();
			}
			if (_rubHandAnim != null)
			{
				_rubHandAnim.refreshSoon();
			}
		}

		if (specialRub == "jack-off" || specialRub == "jack-foreskin" || specialRub == "rub-dick" || specialRub == "rub-foreskin")
		{
			dickTiming.push(_dickRubSoundCount);

			if (dickTiming.length > 2)
			{
				if (dickTiming[dickTiming.length - 1] + dickTiming[dickTiming.length - 2] <= 8)
				{
					maybeEmitWords(niceSlowWords);
				}
			}
			if (_dickRubSoundCount >= rhydonMood1)
			{
				// too fast; emit some hearts prematurely, and push extra instances to skew the median
				dickTiming.push(_dickRubSoundCount);
				var lucky:Float = 0.05;
				for (i in (rhydonMood1 - 1)...Std.int(Math.min(17, _dickRubSoundCount)))
				{
					lucky *= 1.07;
				}
				for (i in 17...Std.int(Math.min(50, _dickRubSoundCount)))
				{
					lucky *= 1.03;
				}
				for (i in 50..._dickRubSoundCount)
				{
					lucky *= 1.01;
				}
				var amount:Float = 0;
				if (pastBonerThreshold())
				{
					amount += SexyState.roundUpToQuarter(lucky * _heartBank._dickHeartReservoir);
					_heartBank._dickHeartReservoir -= amount;
				}
				else
				{
					amount += SexyState.roundUpToQuarter(lucky * _heartBank._foreplayHeartReservoir);
					_heartBank._foreplayHeartReservoir -= amount;
				}
				_heartEmitCount += SexyState.roundDownToQuarter(0.6 * amount);
			}
			else
			{
				if (_autoSweatRate < 0.5)
				{
					_autoSweatRate += 0.02;
				}
				if (_dickRubSoundCount <= 5 && _autoSweatRate < 1.0)
				{
					_autoSweatRate += 0.02;
				}
				if (_dickRubSoundCount <= 3 && _autoSweatRate < 1.0)
				{
					_autoSweatRate += 0.04;
				}
			}
			if (_dickRubSoundCount >= 13)
			{
				// WAY too fast; push another extra instance to skew the median, and don't warn about impending orgasms
				dickTiming.push(_dickRubSoundCount);
				if (almostWords.timer <= 0)
				{
					maybeEmitWords(tooFastWords);
					if (meanThings[0])
					{
						doMeanThing();
						meanThings[0] = false;
					}
				}
				if (pastBonerThreshold())
				{
					almostWords.timer = almostWords.frequency;
				}
			}

			dickTiming.splice(0, dickTiming.length - 50);
		}

		if (specialRub == "jack-off" || specialRub == "jack-foreskin")
		{
			var lucky:Float = lucky(0.85, 1.18, 0.13);
			var amount = SexyState.roundUpToQuarter(lucky * _heartBank._dickHeartReservoir);
			if (_neededKnotRubCount > 0)
			{
				var deductionAmount = SexyState.roundDownToQuarter(amount * 0.6);
				amount -= deductionAmount;
				_heartBank._dickHeartReservoir -= deductionAmount;
				_knotBank += deductionAmount;
			}
			_heartBank._dickHeartReservoir -= amount;
			_heartEmitCount += amount;

			if (_remainingOrgasms > 0 && almostWords.timer <= 0 && _heartBank.getDickPercent() < 0.55 && !isEjaculating())
			{
				emitWords(almostWords);
			}
		}
		else {
			var luckyScalar = 0.06;
			if (specialRub == "rub-dick")
			{
				luckyScalar = 0.08;
			}
			else if (specialRub == "rub-foreskin")
			{
				luckyScalar = 0.10;
			}
			else {
				if (niceThings[0])
				{
					// player hasn't found the knot yet...
					if (!_fancyRub)
					{
						var clickPosition:FlxPoint = FlxG.mouse.getScreenPosition();
						clickPosition.x -= _knotPart.x;
						clickPosition.y -= _knotPart.y;
						clickPosition.x += _knotPart.offset.x;
						clickPosition.y += _knotPart.offset.y;
						var knotArray:Array<FlxPoint> = spriteToKnotArrayMap[_knotPart][_knotPart.animation.frameIndex];
						var dist:Float = clickPosition.distanceTo(spriteToKnotArrayMap[_knotPart][_knotPart.animation.frameIndex][_knotIndex]);

						var newRecord:Bool = true;
						for (recentDist in _recentDists)
						{
							if (recentDist < dist)
							{
								newRecord = false;
							}
						}
						_breathlessCount = -3;
						if (newRecord)
						{
							scheduleBreath();
						}
						_recentDists.push(dist);
						_recentDists.splice(0, _recentDists.length - 3);

						if (dist < 80)
						{
							_pokeWindow.forceTorsoSoon(0, FlxG.random.float(0, _rubRewardFrequency / 2));
						}
						else if (dist < 120)
						{
							_pokeWindow.forceTorsoSoon(1, FlxG.random.float(0, _rubRewardFrequency / 2));
						}
						else
						{
							_pokeWindow.forceTorsoSoon(2, FlxG.random.float(0, _rubRewardFrequency / 2));
						}

						if (dist < 40)
						{
							luckyScalar = 0.160;
							_neededKnotRubCount--;
						}
						else if (dist < 70)
						{
							luckyScalar = 0.096;
							_neededKnotRubCount = 2;
						}
						else if (dist < 120)
						{
							luckyScalar = 0.058;
							_neededKnotRubCount = 2;
						}
						else if (dist < 200)
						{
							luckyScalar = 0.035;
							_neededKnotRubCount = 2;
						}
						else
						{
							luckyScalar = 0.001;
							_neededKnotRubCount = 2;
						}
						if (_neededKnotRubCount <= 0)
						{
							maybeEmitWords(pleasureWords);
							doNiceThing(0.66667);
							niceThings[0] = false;
						}
					}
				}
				else {
					luckyScalar = 0.04;

					// player found the knot; now they're looking for extra credit
					var closestDist:Float = 1000000;
					var closestKnotPart:FlxSprite = _pokeWindow._arms0;
					var closestKnotIndex:Int = 0;

					for (tempKnotPart in [_pokeWindow._arms0, _pokeWindow._torso0, _pokeWindow._torso1])
					{
						var clickPosition:FlxPoint = FlxG.mouse.getScreenPosition();
						clickPosition.x -= tempKnotPart.x;
						clickPosition.y -= tempKnotPart.y;
						clickPosition.x += tempKnotPart.offset.x;
						clickPosition.y += tempKnotPart.offset.y;

						var knotArray:Array<FlxPoint> = spriteToKnotArrayMap[tempKnotPart][tempKnotPart.animation.frameIndex];
						for (knotIndex in 0...knotArray.length)
						{
							var dist:Float = clickPosition.distanceTo(knotArray[knotIndex]);
							if (dist < closestDist)
							{
								closestDist = dist;
								closestKnotPart = tempKnotPart;
								closestKnotIndex = knotIndex;
							}
						}
					}

					if (closestKnotPart == _knotPart)
					{
						if (_secondaryKnotIndexes.indexOf(closestKnotIndex) == -1)
						{
							maybeEmitWords(pleasureWords);
							_secondaryKnotIndexes.push(closestKnotIndex);
							if (_secondaryKnotIndexes.length <= 3)
							{
								// secondaryKnotIndexes is prepopulated with the knot location - #2 and #3 give us a bonus
								doNiceThing(0.33333);
								_autoSweatRate += 0.05;
							}
							else
							{
								// #4, #5 and #6 have minor perks
								luckyScalar += 0.06;
								_autoSweatRate += 0.05;
							}
						}
						luckyScalar += 0.01 * _secondaryKnotIndexes.length;
					}
				}
			}
			if (niceThings[1])
			{
				if (specialRub == "head" && (specialRubs.indexOf("jack-foreskin") != -1 || specialRubs.indexOf("jack-off") != -1))
				{
					_forceMoodTimer = -6;
					_forceMood = 2;
					_newHeadTimer = Math.min(FlxG.random.float(1), _newHeadTimer);
					emitWords(rubHeadWords);
					doNiceThing(0.66667);
					niceThings[1] = false;
				}
			}
			var lucky:Float = lucky(0.85, 1.18, luckyScalar);
			var amount:Float = SexyState.roundUpToQuarter(lucky * _heartBank._foreplayHeartReservoir);
			if (_neededKnotRubCount > 0 && (specialRub == "rub-dick" || specialRub == "rub-foreskin"))
			{
				var deductionAmount = SexyState.roundDownToQuarter(amount * 0.6);
				amount -= deductionAmount;
				_heartBank._foreplayHeartReservoir -= deductionAmount;
				_knotBank += deductionAmount;
			}
			else if (!_fancyRub && _neededKnotRubCount > 0)
			{
				amount += SexyState.roundUpToQuarter(lucky * _knotBank);
			}

			_heartBank._foreplayHeartReservoir -= amount;
			_heartEmitCount += amount;
		}

		emitCasualEncouragementWords();
		if (_heartEmitCount > 0)
		{
			maybeScheduleBreath();
			maybePlayPokeSfx();
			maybeEmitPrecum();
		}

		_dickRubSoundCount = 0;
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
			else if (_heartBank.getForeplayPercent() < 0.8)
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
	}

	override public function eventShowToyWindow(args:Array<Dynamic>)
	{
		super.eventShowToyWindow(args);

		/*
		 * Stop original fluid emitter, to avoid an edge case. The edge case is
		 * that if Rhydon is ejaculating when we switch to the anal beads, jizz
		 * will keep appearing out of nowhere until they switch back
		 */
		_fluidEmitter.emitting = false;

		_toyWindow.syncCamera();

		// add extra graphical stuff...
		if (_male && _blobbyGroup.members.indexOf(_beadSpoogeEmitter) == -1)
		{
			for (i in _beadSpoogeEmitter.members.length..._beadSpoogeEmitter.maxSize)
			{
				var particle:SubframeParticle = new SubframeParticle();
				if (FlxG.random.bool())
				{
					particle.makeGraphic(5, 4, 0xEEFFFFFF);
				}
				else
				{
					particle.makeGraphic(4, 5, 0xEEFFFFFF);
				}
				particle.exists = false;
				_beadSpoogeEmitter.add(particle);
			}

			_beadSpoogeEmitter.angularVelocity.start.set(0);
			_beadSpoogeEmitter.acceleration.start.set(new FlxPoint(0, 600 * 2));
			_beadSpoogeEmitter.start(false, 1.0, 0x0FFFFFFF);
			_beadSpoogeEmitter.emitting = false;
			_blobbyGroup.insert(0, _beadSpoogeEmitter);

			_beadShadowDick.loadGraphicFromSprite(_toyWindow._dick);
			_beadShadowDick.alpha = 1.00;

			_beadDickMask = new BlackGroup();
			_beadDickMask.add(_beadShadowDick);
			_blobbyGroup.insert(1, _beadDickMask);
		}

		// populate reward banks...
		_beadPushRewards.splice(0, _beadPullRewards.length);
		_beadPullRewards.splice(0, _beadPullRewards.length);
		_beadNudgeRewards.splice(0, _beadPullRewards.length);
		for (i in 0..._toyWindow.totalBeadCount)
		{
			_beadPushRewards.push(0);
			_beadPullRewards.push(0);
			_beadNudgeRewards.push(0);
			_beadNudgePushCount.push(0);
			_beadNudgePullCount.push(0);
		}

		var beadPushBank:Float = 0;
		var beadNudgeBank:Float = 0;
		var beadPullBank:Float = 0;

		if (_toyWindow.greyBeads)
		{
			beadPushBank = SexyState.roundUpToQuarter(_toyBank._totalReservoirCapacity * 0.10);
			beadNudgeBank = SexyState.roundUpToQuarter(_toyBank._totalReservoirCapacity * 0.25);
			beadPullBank = SexyState.roundUpToQuarter(_toyBank._totalReservoirCapacity * 0.15);
		}
		else
		{
			beadPushBank = SexyState.roundUpToQuarter(_toyBank._totalReservoirCapacity * 0.20);
			beadNudgeBank = SexyState.roundUpToQuarter(_toyBank._totalReservoirCapacity * 0.30);
			beadPullBank = SexyState.roundUpToQuarter(_toyBank._totalReservoirCapacity * 0.20);
		}

		_finalBeadBonus = _toyBank._totalReservoirCapacity - beadPushBank - beadNudgeBank - beadPullBank;

		if (_toyWindow.greyBeads)
		{
			// pushing/pulling the first bead yields a lot of hearts, no matter what
			var hugeBeadPullBonus:Float = SexyState.roundDownToQuarter(_finalBeadBonus * 0.3);
			var hugeBeadPushBonus:Float = SexyState.roundDownToQuarter(_finalBeadBonus * 0.1);

			_beadPullRewards[0] += hugeBeadPullBonus;
			_finalBeadBonus -= hugeBeadPullBonus;

			_beadPushRewards[0] += hugeBeadPushBonus;
			_finalBeadBonus -= hugeBeadPushBonus;
		}

		// populate push bank
		while (beadPushBank > 0)
		{
			var bigIndex:Int = FlxG.random.int(0, _beadPushRewards.length - 1);
			var littleIndex:Int = FlxG.random.int(0, _beadPushRewards.length - 1);
			if (_toyWindow.getBeadSize(littleIndex) >= _toyWindow.getBeadSize(bigIndex))
			{
				var tmp:Int = littleIndex;
				littleIndex = bigIndex;
				bigIndex = tmp;
			}
			_beadPushRewards[bigIndex] += Math.min(0.5, beadPushBank);
			beadPushBank -= Math.min(0.5, beadPushBank);
			if (FlxG.random.bool())
			{
				_beadPushRewards[littleIndex] += Math.min(0.25, beadPushBank);
				beadPushBank -= Math.min(0.25, beadPushBank);
			}
		}

		// populate nudge bank
		var heartsPerNudge:Float = SexyState.roundDownToQuarter(beadNudgeBank * 0.5 / _beadNudgeRewards.length);
		for (i in 0..._beadNudgeRewards.length)
		{
			_beadNudgeRewards[i] += heartsPerNudge;
			beadNudgeBank -= heartsPerNudge;
		}
		while (beadNudgeBank > 0)
		{
			var bigIndex:Int = FlxG.random.int(0, _beadNudgeRewards.length - 1);
			var littleIndex:Int = FlxG.random.int(0, _beadNudgeRewards.length - 1);

			if (_toyWindow.getBeadSize(littleIndex) >= _toyWindow.getBeadSize(bigIndex))
			{
				var tmp:Int = littleIndex;
				littleIndex = bigIndex;
				bigIndex = tmp;
			}

			_beadNudgeRewards[bigIndex] += 0.25;
			beadNudgeBank -= 0.25;
		}

		// populate pull bank
		var heartsPerPull:Float = SexyState.roundDownToQuarter(beadPullBank * 0.5 / _beadPullRewards.length);
		for (i in 0..._beadPullRewards.length)
		{
			_beadPullRewards[i] += heartsPerPull;
			beadPullBank -= heartsPerPull;
		}
		while (beadPullBank > 0)
		{
			var bigIndex:Int = FlxG.random.int(0, _beadPullRewards.length - 1);
			var littleIndex:Int = FlxG.random.int(0, _beadPullRewards.length - 1);

			if (_toyWindow.getBeadSize(littleIndex) >= _toyWindow.getBeadSize(bigIndex))
			{
				var tmp:Int = littleIndex;
				littleIndex = bigIndex;
				bigIndex = tmp;
			}

			_beadPullRewards[bigIndex] += 0.25;
			beadPullBank -= 0.25;
		}
	}

	public function eventEnableToyWindow(args:Array<Dynamic>)
	{
		_toyInterface.setInteractive(true, 0);
	}

	override public function eventHideToyWindow(args:Array<Dynamic>)
	{
		super.eventHideToyWindow(args);
		// remove extra graphical stuff...
		_pokeWindow.syncCamera();
		_blobbyGroup.remove(_beadDickMask);
		_beadDickMask = FlxDestroyUtil.destroy(_beadDickMask);
		_blobbyGroup.remove(_beadSpoogeEmitter);
		_beadSpoogeEmitter = FlxDestroyUtil.destroy(_beadSpoogeEmitter);
	}

	override function getSpoogeEmitter():FlxEmitter
	{
		return _activePokeWindow == _toyWindow && _male ? _beadSpoogeEmitter : super.getSpoogeEmitter();
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		if (!_male)
		{
			_dick.animation.add("jack-off", [19, 20, 21]);
			_pokeWindow._interact.animation.add("jack-off", [16, 17, 18]);
			_dick.animation.add("jack-foreskin", [8, 9, 10, 11]);
			_pokeWindow._interact.animation.add("jack-foreskin", [5, 6, 7, 8]);
		}
	}

	override function cursorSmellPenaltyAmount():Int
	{
		return 10;
	}

	override public function destroy():Void
	{
		super.destroy();

		torsoKnotArray = null;
		legKnotArray = null;
		armKnotArray = null;
		rubHeadWords = null;
		niceSlowWords = null;
		tooFastWords = null;
		_knotPart = FlxDestroyUtil.destroy(_knotPart);
		_secondaryKnotIndexes = null;
		dickTiming = null;
		_recentDists = null;
		niceThings = null;
		meanThings = null;
		dickheadPolyArray = null;
		vagPolyArray = null;
		_splatEmitter = FlxDestroyUtil.destroy(_splatEmitter);
		_beadPushRewards = null;
		_beadPullRewards = null;
		_beadNudgeRewards = null;
		_beadNudgePushCount = null;
		_beadNudgePullCount = null;
		_toyWindow = FlxDestroyUtil.destroy(_toyWindow);
		_toyInterface = FlxDestroyUtil.destroy(_toyInterface);
		_tugNoise = FlxDestroyUtil.destroy(_tugNoise);
		_beadSpoogeEmitter = FlxDestroyUtil.destroy(_beadSpoogeEmitter);
		_beadShadowDick = FlxDestroyUtil.destroy(_beadShadowDick);
		_beadDickMask = FlxDestroyUtil.destroy(_beadDickMask);
		_vibeButton = FlxDestroyUtil.destroy(_vibeButton);
	}
}