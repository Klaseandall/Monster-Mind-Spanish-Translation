package poke.magn;

import ReservoirMeter.ReservoirStatus;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter.FlxEmitterMode;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import kludge.FlxSoundKludge;
import kludge.FlxSpriteKludge;
import kludge.LateFadingFlxParticle;
import openfl.utils.Object;
import poke.sexy.SexyState;
import poke.sexy.WordManager.Qord;
import poke.sexy.WordParticle;

/**
 * Sex sequence for Magnezone
 * 
 * Magnezone has three "heads". Magnezone likes it if you can make all three of
 * her heads "happy":
 *  1. The left head will either like having its screw stroked, having its body
 *     stroked above the rim, or having its belly/hand stroked.
 *  2. The right head will also like one of those three things, but it will
 *     always be different from the left head.
 *  3. The center head will also like either having its antenna, head or belly
 *     stroked, and it will always be different from the left and right head.
 *     If the left or right head likes having its screw stroked, the center
 *     head will never like having its antenna stroked.
 * You can tell if one of the heads is "happy" because it will have a
 * squinty-eyed expression. Once a head is happy, you can progress to the other
 * heads. But if it takes you too many guesses to please the other heads, then
 * the existing heads might get bored and revert to their non-happy state. So,
 * think it through, and don't waste guesses.
 * 
 * Eventually, Magnezone's rear hatch will open. You can push a panel of
 * buttons, and she has a wide and narrow port to experiment with. One of these
 * three elements requires more focused maintenance.
 * 
 * To tell which of those three items requires maintenance, you can examine her
 * button panel. After deactivating all of the buttons, two specific lights
 * will persistently light up or blink after being turned off. The positions of
 * these buttons changes each time, you cannot memorize it.
 *  1. If Magnezone's small port requires maintenance, then the same two lights
 *     will always revert to being on after they are all turned off.
 *  2. If Magnezone's keyboard panel requires maintenance, then the same two
 *     lights will always revert to blinking after they are all turned off.
 *  3. If Magnezone's larger port requires maintenance, then the same three
 *     lights will be off after they are all turned off. If her large port does
 *     NOT require maintenance, then fingering her large port too much can
 *     result in electrocution, so be careful!
 * 
 * After determining which peripheral requires maintenance, interact with it
 * for about 5 seconds and Magnezone should emit a lot of hearts and say
 * something pleasurable.
 * 
 * Additionally, she likes it if you spend a little time on the other two
 * peripherals as well. Make sure not to rub the big port 3 or more times to
 * avoid electrocution.
 * 
 * Lastly, you can mash her big red button to make her orgasm. If your hand
 * comes in contact with electricity, you can get electrocuted, so be mindful.
 * If you are not comfortable relying on the "rhythm method" you can equip a
 * insulating glove to avoid electruction.
 * 
 * Magnezone doesn't particularly like any sex toy. But you can decorate her
 * with beads to make her a little confused.
 * 
 * Her mood for the beads varies from day-to-day, but she likes certain
 * combinations better than others. She likes symmetrical designs more than
 * asymmetrical ones, so make sure the left and right side match.
 * 
 * One successful pattern involves a vertical spiral going down her center,
 * with the beads hanging down behind her to the left and right.
 */
class MagnSexyState extends SexyState<MagnWindow>
{
	private static var FRONT_RUB_REGIONS:Map<String, Bool> = [
				"left-screw" => true,
				"body-top-left" => true,
				"body-bottom-left" => true,
				"antenna" => true,
				"body-top-middle" => true,
				"body-bottom-middle" => true,
				"right-screw" => true,
				"body-top-right" => true,
				"body-bottom-right" => true];

	private static var ALL_DESIRED_SCREW_RUBS:Array<Array<String>> = [
				["left-screw", "body-top-middle", "body-bottom-right"],
				["left-screw", "body-bottom-middle", "body-top-right"],
				["body-top-left", "antenna", "body-bottom-right"],
				["body-top-left", "body-bottom-middle", "right-screw"],
				["body-bottom-left", "antenna", "body-top-right"],
				["body-bottom-left", "body-top-middle", "right-screw"]];

	private static var BEAD_AESTHETIC_VARIABILITY:Array<Array<Int>> =
		[[4, 1, 2, 0, 2],
		 [3, 0, 1, 3, 0],
		 [5, 0, 3, 2, 0],
		 [4, 2, 1, 5, 3],
		 [4, 3, 4, 4, 2]];

	private static var BEAD_AESTHETICS:Array<Array<Int>> =
		[[5, 5, 1, 5, 0],
		 [1, 3, 2, 2, 0],
		 [1, 4, 3, 1, 1],
		 [1, 3, 4, 4, 3],
		 [2, 4, 5, 2, 0]];

	#if reflection
	// Workaround for Haxe #6630; Reflect.field on public static inline return null.
	// https://github.com/HaxeFoundation/haxe/issues/6630
	private static var REFLECTION_WORKAROUND:Map<String, String> = [
			"magn_lever_0063_bot_fasta__mp3" => AssetPaths.magn_lever_0063_bot_fasta__mp3,
			"magn_lever_0063_bot_fastb__mp3" => AssetPaths.magn_lever_0063_bot_fastb__mp3,
			"magn_lever_0063_bot_meda__mp3" => AssetPaths.magn_lever_0063_bot_meda__mp3,
			"magn_lever_0063_bot_medb__mp3" => AssetPaths.magn_lever_0063_bot_medb__mp3,
			"magn_lever_0063_bot_slowa__mp3" => AssetPaths.magn_lever_0063_bot_slowa__mp3,
			"magn_lever_0063_bot_slowb__mp3" => AssetPaths.magn_lever_0063_bot_slowb__mp3,
			"magn_lever_0063_top_fasta__mp3" => AssetPaths.magn_lever_0063_top_fasta__mp3,
			"magn_lever_0063_top_fastb__mp3" => AssetPaths.magn_lever_0063_top_fastb__mp3,
			"magn_lever_0063_top_meda__mp3" => AssetPaths.magn_lever_0063_top_meda__mp3,
			"magn_lever_0063_top_medb__mp3" => AssetPaths.magn_lever_0063_top_medb__mp3,
			"magn_lever_0063_top_slowa__mp3" => AssetPaths.magn_lever_0063_top_slowa__mp3,
			"magn_lever_0063_top_slowb__mp3" => AssetPaths.magn_lever_0063_top_slowb__mp3,
	];
	#end

	private var _pressedPanelButtonIndexes:Array<Int> = [];
	private var _draggingButtons:Bool = false;

	private var _buttonsBackPolyArray:Array<Array<FlxPoint>>;
	private var _buttonsBackNearbyPolyArray:Array<Array<FlxPoint>>;
	private var _slamHatchPolyArray:Array<Array<FlxPoint>>;
	private var _leverBodyPolyArray:Array<Array<FlxPoint>>;
	private var _smallPortPolyArray:Array<Array<FlxPoint>>;
	private var _bigPortPolyArray:Array<Array<FlxPoint>>;
	private var _rearAntennaPolyArray:Array<Array<FlxPoint>>;
	private var _frontSweatArray:Array<Array<FlxPoint>>; // sweat on the "main head"
	private var _frontSweatArrayLeft:Array<Array<FlxPoint>>; // sweat on the "left head"
	private var _frontSweatArrayRight:Array<Array<FlxPoint>>; // sweat on the "right head"
	private var _rearSweatArrayLeft:Array<Array<FlxPoint>>; // rear sweat, with X coordinates offset for camera left
	private var _rearSweatArrayRight:Array<Array<FlxPoint>>; // rear sweat, with X coordinates offset for camera right

	private var _frontRubRegions:Array<Array<FlxPoint>>; // bottom-left, top-left, bottom-middle, top-middle, bottom-right, top-right
	private var _leftArmPolyArray:Array<Array<FlxPoint>>;

	private var _smallSparkEmitter:FlxTypedEmitter<LateFadingFlxParticle>;
	private var _largeSparkEmitter:FlxTypedEmitter<LateFadingFlxParticle>;
	private var _sparkTimer:Float = Math.min(FlxG.random.float(0, .5), FlxG.random.float(0, 1));
	private var _bigZapTimer:Float = 0;

	private var _buttonClickSpot:FlxPoint;
	private var _recentButtonClickTimer:Float = 0;
	private var _leverTopSfxPlayed:Bool = false;
	private var _leverBotSfxPlayed:Bool = false;
	private var _bigPortTightness:Float = 5;

	private var _hurtHand:FlxSprite;

	private var SHAKE_FPS:Int = 25;
	private var _shakeFrameTimer:Float = 0;
	private var _shakeTimer:Float = 0;
	private var _shakeDuration:Float = 0;
	private var _shakeIntensity:Float = 0;

	private var _countdownTimer:Float = -1;
	private var _countdownWords:Qord;
	private var _eyePokeWords:Qord;
	private var _serviceHatchWords:Qord;
	private var _buttonOnWords:Qord;
	private var _prevCountdownWord:WordParticle;

	private var _desiredScrewRubs:Array<String>; // which parts of his front does he want you to rub today?
	private var _happyScrewRubs:Array<String> = []; // which "nice" parts of his front have you rubbed in the past few seconds?
	private var _sadScrewRubs:Array<String> = []; // which "less nice" parts of his front have you rubbed in the past few seconds?
	private var _happyScrewRubsTimer:Float = 0;

	private var _magnMood0:Int = FlxG.random.int(0, 3); // which screw rub configuration does he like today?
	private var _magnMood1:Int = FlxG.random.int(0, 2); // which panel widget does he want us to play with?

	private var _heartPenalty:Float = 1.0;

	/*
	 * niceThings[0] = made 2 of magnezone's heads smile simultaneously
	 * niceThings[1] = made 3 of magnezone's heads smile simultaneously
	 * niceThings[2] = touch things in magnezone's rear console about 5 times
	 * niceThings[3] = focus on one specific thing in magnezone's rear console
	 */
	private var _niceThings:Array<Bool> = [true, true, true, true];

	/**
	 * meanThings[0] = rub magnezone's eyes
	 * meanThings[1] = get electrocuted by making magnezone orgasm irresponsibly
	 * meanThings[2] = get electrocuted by sticking your finger in an outlet
	 */
	private var _meanThings:Array<Bool> = [true, true, true];
	private var _hatchTimer:Float = 0;
	private var _closedHatchCount:Int = 0;

	private var _untouchedButtonIndex:Float = 0;
	private var _untouchedButtonTimer:Float = 0;
	private var _untouchedButtonStates:Array<Array<Int>>;

	private var _maxCountdown:Int = 7;
	private var _didCountdown:Bool = false;
	private var _serviceHatchMessageTimer:Float = 0;

	private var _toyInterface:MagnBeadInterface;
	private var toyBadWords:Qord;
	private var toyNeutralWords:Qord;
	private var toyGoodWords:Qord;

	private var _purpleAnalBeadButton:FlxButton;
	private var _bigBeadButton:FlxButton;

	override public function create():Void
	{
		prepare("magn");
		super.create();
		_heartBank._libido = Std.int(Math.max(_heartBank._libido, 2)); // magnezone is exempt from the "don't orgasm" rule

		_toyInterface = new MagnBeadInterface();
		_toyInterface.beadOutfitChangeEvent = beadOutfitChangeEvent;
		toyGroup.add(_toyInterface);

		_smallSparkEmitter = new FlxTypedEmitter<LateFadingFlxParticle>(0, 0, 50);
		_smallSparkEmitter.launchMode = FlxEmitterMode.SQUARE;
		_smallSparkEmitter.angularVelocity.set(0);
		_smallSparkEmitter.velocity.set(200, 200);
		_smallSparkEmitter.lifespan.set(0.3);
		for (i in 0..._smallSparkEmitter.maxSize)
		{
			var particle:LateFadingFlxParticle = new LateFadingFlxParticle();
			particle.makeGraphic(3, 3, FlxColor.WHITE);
			particle.offset.x = 1.5;
			particle.offset.y = 1.5;
			particle.exists = false;
			_smallSparkEmitter.add(particle);
		}
		insert(members.indexOf(_breathGroup), _smallSparkEmitter);

		_largeSparkEmitter = new FlxTypedEmitter<LateFadingFlxParticle>(0, 0, 25);
		_largeSparkEmitter.launchMode = FlxEmitterMode.SQUARE;
		_largeSparkEmitter.angularVelocity.set(0);
		_largeSparkEmitter.velocity.set(400, 400);
		_largeSparkEmitter.lifespan.set(0.6);
		for (i in 0..._largeSparkEmitter.maxSize)
		{
			var particle:LateFadingFlxParticle = new LateFadingFlxParticle();
			particle.makeGraphic(6, 6, FlxColor.WHITE);
			particle.offset.x = 2.5;
			particle.offset.y = 2.5;
			particle.exists = false;
			_largeSparkEmitter.add(particle);
		}
		insert(members.indexOf(_breathGroup), _largeSparkEmitter);

		if (PlayerData.magnSexyBeforeChat == 2)
		{
			// don't zap the player this time
			_magnMood1 = 0;
		}

		{
			_untouchedButtonStates = [];
			{
				for (i in 0...20)
				{
					var blinkCount:Int = Std.int(FlxMath.bound(i <= 14 ? i / 2 : 2 * i - 21));
					var onCount:Int = Std.int(FlxMath.bound(i <= 12 ? (i + 3) / 2 : 19 - i, 0, 17));
					var untouchedButtonState:Array<Int> = [];
					while (untouchedButtonState.length < blinkCount)
					{
						untouchedButtonState.push(2);
					}
					while (untouchedButtonState.length < blinkCount + onCount)
					{
						untouchedButtonState.push(1);
					}
					while (untouchedButtonState.length < 17)
					{
						untouchedButtonState.push(0);
					}
					FlxG.random.shuffle(untouchedButtonState);
					_untouchedButtonStates.push(untouchedButtonState);
				}
				var buttonIndexes:Array<Int> = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
				var buttonA:Int = buttonIndexes.splice(FlxG.random.int(0, buttonIndexes.length - 1), 1)[0];
				var buttonB:Int = buttonIndexes.splice(FlxG.random.int(0, buttonIndexes.length - 1), 1)[0];
				var buttonC:Int = buttonIndexes.splice(FlxG.random.int(0, buttonIndexes.length - 1), 1)[0];
				var buttonD:Int = buttonIndexes.splice(FlxG.random.int(0, buttonIndexes.length - 1), 1)[0];
				var stateA:Int = 0;
				var stateB:Int = 0;
				var stateC:Int = 1;
				var stateD:Int = 2;
				_pokeWindow._buttonDurations[buttonA] = 2;
				_pokeWindow._buttonDurations[buttonB] = 2;
				_pokeWindow._buttonDurations[buttonC] = 2;
				_pokeWindow._buttonDurations[buttonD] = 2;
				if (_magnMood1 == 0)
				{
					// three lights off
					stateC = 0;
				}
				else if (_magnMood1 == 1)
				{
					// two lights on
					stateA = 1;
				}
				else {
					// two lights blinking
					stateA = 2;
				}
				for (i in 0...20)
				{
					_untouchedButtonStates[i][buttonA] = stateA;
					_untouchedButtonStates[i][buttonB] = stateB;
					_untouchedButtonStates[i][buttonC] = stateC;
					_untouchedButtonStates[i][buttonD] = stateD;
				}
			}
		}

		_hurtHand = new FlxSprite();
		CursorUtils.initializeHandSprite(_hurtHand, AssetPaths.hand_hurt__png);
		_hurtHand.animation.add("default", [0, 1], 9);
		_hurtHand.animation.play("default");
		_hurtHand.visible = false;
		_hurtHand.offset.x = _handSprite.offset.x;
		_hurtHand.offset.y = _handSprite.offset.y;
		_frontSprites.add(_hurtHand);

		sfxEncouragement = [AssetPaths.magn0__mp3, AssetPaths.magn1__mp3, AssetPaths.magn2__mp3, AssetPaths.magn3__mp3];
		sfxPleasure = [AssetPaths.magn4__mp3, AssetPaths.magn5__mp3, AssetPaths.magn6__mp3];
		sfxOrgasm = [AssetPaths.magn7__mp3, AssetPaths.magn8__mp3, AssetPaths.magn9__mp3];

		popularity = -0.6;
		cumTrait0 = 3;
		cumTrait1 = 7;
		cumTrait2 = 5;
		cumTrait3 = 4;
		cumTrait4 = 4;

		// a little slower; most stuff takes about 1.25x as long for him
		_rubRewardFrequency = 3.4;
		_armsAndLegsArranger.setBounds(10, 15);

		_blobbyGroup._blobColour = 0x222222;
		_blobbyGroup._blobOpacity = 0x55;
		sweatAreas.push({chance:10, sprite:_pokeWindow._body, sweatArrayArray:_frontSweatArrayLeft});
		sweatAreas.push({chance:10, sprite:_pokeWindow._body, sweatArrayArray:_frontSweatArray});
		sweatAreas.push({chance:10, sprite:_pokeWindow._body, sweatArrayArray:_frontSweatArrayRight});
		sweatAreas.push({chance:0, sprite:_pokeWindow._body, sweatArrayArray:_rearSweatArrayLeft});
		sweatAreas.push({chance:0, sprite:_pokeWindow._body, sweatArrayArray:_rearSweatArrayRight});

		// oil blobs appear behind the hand
		remove(_blobbyGroup);
		insert(members.indexOf(_frontSprites), _blobbyGroup);

		_bonerThreshold = 0.8;
		_cumThreshold = 0.49;

		_idlePunishmentTimer += 3;

		refreshUntouchedButtonState(0);

		if (ItemDatabase.playerHasUneatenItem(ItemDatabase.ITEM_SMALL_PURPLE_BEADS))
		{
			_purpleAnalBeadButton = newToyButton(purpleAnalBeadButtonEvent, AssetPaths.smallbeads_purple_button__png, _dialogTree);
			addToyButton(_purpleAnalBeadButton);
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_LARGE_GREY_BEADS))
		{
			_bigBeadButton = newToyButton(bigBeadButtonEvent, AssetPaths.xlbeads_grey_button__png, _dialogTree);
			addToyButton(_bigBeadButton);
		}
	}

	public function bigBeadButtonEvent():Void
	{
		playButtonClickSound();
		removeToyButton(_bigBeadButton);
		var tree:Array<Array<Object>> = [];
		MagnDialog.snarkyBigBeads(tree);
		showEarlyDialog(tree);
	}

	public function purpleAnalBeadButtonEvent():Void
	{
		playButtonClickSound();
		toyButtonsEnabled = false;
		maybeEmitWords(toyStartWords);
		var time:Float = eventStack._time;
		eventStack.addEvent({time:time, callback:eventShowToyWindow});
		eventStack.addEvent({time:time += 1.7, callback:eventEnableToyButtons});
	}

	override public function toyOffButtonEvent():Void
	{
		super.toyOffButtonEvent();
		if (eventStack.isEventScheduled(eventHideToyWindow))
		{
			eventStack.addEvent({time:eventStack._time, callback:eventAwardBeadHearts});
		}
	}

	override public function shouldEmitToyInterruptWords():Bool
	{
		return !_pokeWindow._beadsFrontC.visible;
	}

	override function penetrating():Bool
	{
		return specialRub == "lever"; // you can pull magnezone's lever as slow as you like
	}

	override function foreplayFactor():Float
	{
		return _male ? 0.6 : 0.75;
	}

	override public function eventShowToyWindow(args:Array<Dynamic>)
	{
		super.eventShowToyWindow(args);

		_toyInterface.synchronize(_pokeWindow);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (_pokeWindow._lightningIntensity > 0)
		{
			// lightning is active
			_sparkTimer -= elapsed;
			if (_sparkTimer <= 0)
			{
				smallZap();
			}
		}

		if (_bigZapTimer > 0)
		{
			_bigZapTimer -= elapsed;
		}

		// hide the lightning layer if the character is invisible
		if (_pokeWindow._partAlpha == 1 && !_smallSparkEmitter.visible)
		{
			_smallSparkEmitter.visible = true;
			_largeSparkEmitter.visible = true;
		}
		else if (_pokeWindow._partAlpha == 0 && _smallSparkEmitter.visible)
		{
			_smallSparkEmitter.visible = false;
			_largeSparkEmitter.visible = false;
		}

		for (spark in _smallSparkEmitter.members)
		{
			if (spark.exists)
			{
				spark.visible = FlxSpriteKludge.overlap(_pokeWindow._canvas, spark);
			}
		}

		for (spark in _largeSparkEmitter.members)
		{
			if (spark.exists)
			{
				spark.visible = FlxSpriteKludge.overlap(_pokeWindow._canvas, spark);
			}
		}
	}

	private function bigZapHand(?pct:Float = 1):Void
	{
		var sparkLocation0:FlxPoint = _pokeWindow.getSparkLocation(0);
		var sparkLocation2:FlxPoint = _pokeWindow.getSparkLocation(2);
		_pokeWindow._lightningIntensity += 16 * pct;
		_pokeWindow.makeBigAntennaBolt(0);
		var handX:Float = FlxG.mouse.x - _pokeWindow._body.x + FlxG.random.float( -4, 4);
		if (_pokeWindow.cameraPosition.x > 200)
		{
			handX -= 872;
		}
		else if (_pokeWindow.cameraPosition.x < -200)
		{
			handX += 872;
		}
		_pokeWindow.makeBigBolt(handX, FlxG.mouse.y - _pokeWindow._body.y + FlxG.random.float(-4, 4), 1);
		_pokeWindow._lightningDirty = true;

		MagnWindow.emitSpark(_largeSparkEmitter, FlxG.mouse.x, FlxG.mouse.y);
		MagnWindow.emitSpark(_largeSparkEmitter, sparkLocation0.x, sparkLocation0.y);
		MagnWindow.emitSpark(_largeSparkEmitter, sparkLocation2.x, sparkLocation2.y);

		_shakeDuration = 0.8 * pct;
		_shakeIntensity = 0.02 * pct;
		_shakeTimer = _shakeDuration * pct;
	}

	private function electrocuteHand():Void
	{
		bigZapHand();

		interactOff();

		_handSprite.visible = false;
		obliterateCursor();

		_hurtHand.visible = true;
		_hurtHand.x = _handSprite.x;
		_hurtHand.y = _handSprite.y;
		_hurtHand.velocity.x = 400;
		_hurtHand.velocity.y = -400;
		_hurtHand.acceleration.y = 2600;

		FlxSoundKludge.play(AssetPaths.magn_bigzap_000e__mp3, 0.7);
	}

	override function updateHand(elapsed:Float):Void
	{
		if (_hurtHand.visible)
		{
			// don't update the hand; they're injured
			return;
		}
		super.updateHand(elapsed);
	}

	private function smallZap():Void
	{
		var sparkLocation:FlxPoint = _pokeWindow.getSparkLocation();
		if (FlxG.random.float(8, 30) < _pokeWindow._lightningIntensity)
		{
			_pokeWindow.makeAntennaBolt();
			SoundStackingFix.play(FlxG.random.getObject([AssetPaths.magn_zap__mp3, AssetPaths.magn_zap2__mp3, AssetPaths.magn_zap3__mp3]), FlxG.random.getObject([0.8, 0.9, 1.0]));
		}
		else {
			SoundStackingFix.play(FlxG.random.getObject([AssetPaths.magn_zap_small__mp3, AssetPaths.magn_zap_small2__mp3]), FlxG.random.getObject([0.4, 0.7, 1.0]));
		}
		MagnWindow.emitSpark(_smallSparkEmitter, sparkLocation.x, sparkLocation.y);

		_sparkTimer += Math.min(FlxG.random.float(0, 0.5), FlxG.random.float(0, 1));
	}

	function startCountdown():Void
	{
		_didCountdown = true;
		_countdownTimer = FlxG.random.int(3, _maxCountdown) * 0.7;
		_newHeadTimer = _countdownTimer;
		_maxCountdown = Std.int(Math.max(3, _maxCountdown - 1));
	}

	override public function sexyStuff(elapsed:Float):Void
	{
		super.sexyStuff(elapsed);

		if (_countdownTimer > 0)
		{
			var oldCountdownTimerInt:Int = Std.int(_countdownTimer / 0.7);
			_countdownTimer -= elapsed;
			var countdownTimerInt:Int = Std.int(_countdownTimer / 0.7);
			if (oldCountdownTimerInt != countdownTimerInt)
			{
				if (_prevCountdownWord != null)
				{
					_prevCountdownWord.lifespan = Math.min(_prevCountdownWord.lifespan, _prevCountdownWord.age + 0.3);
				}
				if (countdownTimerInt >= 0 && countdownTimerInt <= 6)
				{
					_prevCountdownWord = emitWords(_countdownWords, 6 - countdownTimerInt, countdownTimerInt)[0];
					_pokeWindow.emitLightning(6);
					SoundStackingFix.play(FlxG.random.getObject([AssetPaths.magn_zap__mp3, AssetPaths.magn_zap2__mp3, AssetPaths.magn_zap3__mp3]), FlxG.random.getObject([0.8, 0.9, 1.0]));
				}
			}
		}

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

		if (_buttonClickSpot != null)
		{
			// pressing panel buttons?
			if (FlxG.mouse.justReleased)
			{
				_draggingButtons = false;
				for (buttonIndex in _pressedPanelButtonIndexes)
				{
					_pokeWindow.releasePanelButton(buttonIndex);
				}
				if (_pressedPanelButtonIndexes.length > 0)
				{
					SoundStackingFix.play(AssetPaths.click1_00cb__mp3, 0.3);
					_recentButtonClickTimer = 1.3;
					rubSoundCount++;
				}
				_pressedPanelButtonIndexes.splice(0, _pressedPanelButtonIndexes.length);
				_buttonClickSpot = null;
				_handSprite.animation.play("default");
			}
			else if (_buttonClickSpot.distanceTo(FlxG.mouse.getWorldPosition()) > 8)
			{
				// dragging hand...
				_draggingButtons = true;
			}
			if (_draggingButtons)
			{
				var buttonWasMashed:Int = _pokeWindow.mashPanelButtons(_clickedSpot.x, _clickedSpot.y);
				if (buttonWasMashed == 2)
				{
					var possibleFrames = [3, 7, 11];
					possibleFrames.remove(_handSprite.animation.frameIndex);
					_handSprite.animation.stop();
					_handSprite.animation.frameIndex = FlxG.random.getObject(possibleFrames);
				}
				if (buttonWasMashed == 2)
				{
					SoundStackingFix.play(AssetPaths.click0_00cb__mp3, 0.6);
					_recentButtonClickTimer = 1.3;
					rubSoundCount++;
				}
				else if (buttonWasMashed == 1)
				{
					SoundStackingFix.play(AssetPaths.click1_00cb__mp3, 0.3);
					_recentButtonClickTimer = 1.3;
					rubSoundCount++;
				}
			}
		}
		if (_fancyRub && _rubHandAnim._flxSprite.animation.name == "pull-lever")
		{
			// did it just reach the first/last frame of the animation? play some special sfx
			if (FlxG.mouse.justPressed)
			{
				_leverBotSfxPlayed = false;
			}
			if (FlxG.mouse.justReleased)
			{
				_leverTopSfxPlayed = false;
			}
			if (!_leverTopSfxPlayed && _rubHandAnim._flxSprite.animation.curAnim.curFrame == 0)
			{
				playLeverSound("top", _rubHandAnim._prevMouseUpTime, 0.4);
				_leverTopSfxPlayed = true;
			}
			else if (!_leverBotSfxPlayed && _rubHandAnim._flxSprite.animation.curAnim.curFrame == _rubHandAnim._flxSprite.animation.curAnim.numFrames - 1)
			{
				playLeverSound("bot", _rubHandAnim._prevMouseDownTime, 0.4);
				_leverBotSfxPlayed = true;
				if (_remainingOrgasms > 0)
				{
					if (_untouchedButtonIndex <= 6)
					{
						_untouchedButtonIndex += 5;
					}
					else
					{
						_untouchedButtonIndex += 5 * Math.pow(0.5, (_untouchedButtonIndex - 6) * 0.25);
					}
				}
			}
		}

		if (_happyScrewRubsTimer > 0 && _happyScrewRubs.length > 0)
		{
			_happyScrewRubsTimer -= elapsed;
			if (_happyScrewRubsTimer <= 0)
			{
				_happyScrewRubs.splice(FlxG.random.int(0, _happyScrewRubs.length - 1), 1);
				_happyScrewRubsTimer += FlxG.random.float(0.7, 2.0);
				updateEyeHappy();
			}
		}

		if (_hatchTimer > 0)
		{
			_hatchTimer -= elapsed;
		}

		refreshUntouchedButtonState(elapsed);
		if (_heartBank.getDickPercent() <= _cumThreshold && _remainingOrgasms > 0 && !_didCountdown)
		{
			startCountdown();
		}
		if (isEjaculating() && _pokeWindow._lightningIntensity > 8 && !_hurtHand.visible)
		{
			var handClose:Bool = FlxG.mouse.pressed && _pokeWindow.getSparkLocation().distanceTo(FlxG.mouse.getPosition()) < 120;
			if (handClose)
			{
				if (PlayerData.cursorInsulated)
				{
					// phew! safe
					if (_bigZapTimer <= 0)
					{
						_bigZapTimer = FlxG.random.float(10, 20);
						bigZapHand(0.5);
						FlxSoundKludge.play(AssetPaths.magn_mediumzap_000e__mp3, 0.7);
					}
				}
				else
				{
					electrocuteHand();
					if (_meanThings[1])
					{
						_meanThings[1] = false;
						// penalty subverts "doMeanThing", because "doMeanThing" penalty doesn't hurt much mid-orgasm
						_heartBank._dickHeartReservoir = SexyState.roundUpToQuarter(_heartBank._dickHeartReservoir * 0.333);
						_heartBank._foreplayHeartReservoir = SexyState.roundUpToQuarter(_heartBank._foreplayHeartReservoir * 0.333);
					}
				}
			}
		}
		if (_pokeWindow._lightningIntensity >= 4 && _idlePunishmentTimer > 0)
		{
			// don't get idle while zapping stuff... don't wanna punish player for keeping his hand safe
			_idlePunishmentTimer = 0;
		}
		if (_serviceHatchMessageTimer > 0)
		{
			_serviceHatchMessageTimer -= elapsed;
			if (_pokeWindow.cameraPosition.x > 200 || _pokeWindow.cameraPosition.x < -200 || !_pokeWindow._hatchOpen)
			{
				_serviceHatchMessageTimer = 0;
			}
			else if (_serviceHatchMessageTimer <= 0)
			{
				maybeEmitWords(_serviceHatchWords);
			}
		}
	}

	override function handleCumShots(elapsed:Float):Void
	{
		_cumShots[0].duration -= elapsed;
		if (_cumShots[0].duration <= 0)
		{
			if (_cumShots[0].arousal > -1)
			{
				if (_cumShots.length == 1 || _cumShots[1].arousal == -1)
				{
					_isOrgasming = false;
					if (_remainingOrgasms > 0)
					{
						// just finished ejaculating... but have more to go
						_heartBank._dickHeartReservoirCapacity = SexyState.roundDownToQuarter(0.8 * _heartBank._dickHeartReservoir / _cumThreshold);
						_didCountdown = false;
					}
				}
			}
			_cumShots.splice(0, 1);
		}
		if (_cumShots.length > 0 && _cumShots[0].force > 0)
		{
			// activate lightning
			var amount:Float = 14 * Math.pow(_cumShots[0].force, 0.7) * Math.pow(_cumShots[0].rate, 0.7) * Math.pow(_cumShots[0].duration, 0.7);
			if (_pokeWindow._lightningIntensity < 4 && amount < 8)
			{
				// bolts smaller than 4 don't even really show up... so, 4 minimum
				amount = (amount + 8) / 2;
			}
			_pokeWindow.emitLightning(amount);
			_cumShots[0].force = 0;
		}
	}

	override public function isInteracting():Bool
	{
		return super.isInteracting() || _recentButtonClickTimer > 0;
	}

	override public function shouldOrgasm():Bool
	{
		return _remainingOrgasms > 0 && _didCountdown;
	}

	override public function checkSpecialRub(touchedPart:FlxSprite):Void
	{
		if (_fancyRub)
		{
			if (_rubHandAnim._flxSprite.animation.name == "finger-big-port")
			{
				specialRub = "big-port";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-small-port" || _rubHandAnim._flxSprite.animation.name == "rub-small-port1")
			{
				specialRub = "small-port";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-antenna" || _rubHandAnim._flxSprite.animation.name == "rub-antenna-back")
			{
				specialRub = "antenna";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-left-screw")
			{
				specialRub = "left-screw";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-right-screw")
			{
				specialRub = "right-screw";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "pull-lever")
			{
				specialRub = "lever";
			}
		}
		else {
			if (_draggingButtons)
			{
				specialRub = "mash-buttons";
			}
			else if (touchedPart == _pokeWindow._body)
			{
				if (clickedPolygon(_pokeWindow._body, [_frontRubRegions[0]]))
				{
					specialRub = "body-bottom-left";
				}
				else if (clickedPolygon(_pokeWindow._body, [_frontRubRegions[1]]))
				{
					specialRub = "body-top-left";
				}
				else if (clickedPolygon(_pokeWindow._body, [_frontRubRegions[2]]))
				{
					specialRub = "body-bottom-middle";
				}
				else if (clickedPolygon(_pokeWindow._body, [_frontRubRegions[3]]))
				{
					specialRub = "body-top-middle";
				}
				else if (clickedPolygon(_pokeWindow._body, [_frontRubRegions[4]]))
				{
					specialRub = "body-bottom-right";
				}
				else if (clickedPolygon(_pokeWindow._body, [_frontRubRegions[5]]))
				{
					specialRub = "body-top-right";
				}
			}
			else if (touchedPart == _pokeWindow._arms)
			{
				if (clickedPolygon(_pokeWindow._arms, _leftArmPolyArray))
				{
					specialRub = "body-bottom-left";
				}
				else
				{
					specialRub = "body-bottom-right";
				}
			}
			else if (touchedPart == _pokeWindow._tail || touchedPart == _pokeWindow._tailBack)
			{
				specialRub = "body-bottom-middle";
			}
			else if (touchedPart == _pokeWindow._leftEye)
			{
				specialRub = "left-eye";
			}
			else if (touchedPart == _pokeWindow._middleEye)
			{
				specialRub = "middle-eye";
			}
			else if (touchedPart == _pokeWindow._rightEye)
			{
				specialRub = "right-eye";
			}
			else if (_recentButtonClickTimer > 0)
			{
				specialRub = "push-buttons";
			}
		}
	}

	override public function touchPart(touchedPart:FlxSprite):Bool
	{
		if (_pokeWindow._hatchOpen)
		{
			if (_draggingButtons)
			{
				if (clickedPolygon(_pokeWindow._bodyBack, _buttonsBackNearbyPolyArray, _clickedSpot))
				{
					return true;
				}
			}
			if (touchedPart == _pokeWindow._buttonsBack || touchedPart == _pokeWindow._bodyBack && clickedPolygon(touchedPart, _buttonsBackPolyArray))
			{
				if (FlxG.mouse.justPressed)
				{
					var buttonIndex:Int = _pokeWindow.getClosestPanelButton(FlxG.mouse.x, FlxG.mouse.y);
					if (buttonIndex == -1)
					{
						// shouldn't happen...
					}
					else
					{
						_pokeWindow.pushPanelButton(buttonIndex);
						SoundStackingFix.play(AssetPaths.click0_00cb__mp3, 0.6);
						_pressedPanelButtonIndexes.push(buttonIndex);
						_buttonClickSpot = FlxG.mouse.getPosition();
					}
				}
				return true;
			}
			if ((touchedPart == _pokeWindow._portsBack || touchedPart == _pokeWindow._bodyBack) && clickedPolygon(_pokeWindow._bodyBack, _smallPortPolyArray))
			{
				interactOn(_pokeWindow._portsBack, "rub-small-port");
				_rubBodyAnim.addAnimName("rub-small-port1");
				_rubHandAnim.addAnimName("rub-small-port1");
				return true;
			}
			if ((touchedPart == _pokeWindow._portsBack || touchedPart == _pokeWindow._bodyBack) && clickedPolygon(_pokeWindow._bodyBack, _bigPortPolyArray))
			{
				interactOn(_pokeWindow._portsBack, "finger-big-port");
				return true;
			}
			if (touchedPart == _pokeWindow._leverBack || touchedPart == _pokeWindow._bodyBack && clickedPolygon(_pokeWindow._bodyBack, _leverBodyPolyArray))
			{
				interactOn(_pokeWindow._leverBack, "pull-lever");
				_leverTopSfxPlayed = true;
				_leverBotSfxPlayed = true;
				_rubBodyAnim.setSpeed(0.65 * 1.0, 0.65 * 1.0);
				_rubHandAnim.setSpeed(0.65 * 1.0, 0.65 * 1.0);
				return true;
			}
		}
		if (FlxG.mouse.justPressed && touchedPart == _pokeWindow._hatchBack && clickedPolygon(_pokeWindow._hatchBack, _slamHatchPolyArray))
		{
			_pokeWindow.setHatchOpen(false);
			_closedHatchCount++;
			_hatchTimer = (_closedHatchCount + 1) * FlxG.random.float(6, 12);
			return true;
		}
		if (touchedPart == _pokeWindow._leftScrew)
		{
			interactOn(_pokeWindow._leftScrew, "rub-left-screw");
			return true;
		}
		if (touchedPart == _pokeWindow._rightScrew)
		{
			interactOn(_pokeWindow._rightScrew, "rub-right-screw");
			return true;
		}
		if (touchedPart == _pokeWindow._antenna)
		{
			interactOn(_pokeWindow._antenna, "rub-antenna");
			return true;
		}
		if (touchedPart == _pokeWindow._bodyBack && clickedPolygon(_pokeWindow._bodyBack, _rearAntennaPolyArray))
		{
			interactOn(_pokeWindow._bodyBack, "rub-antenna-back");
			_pokeWindow._interact.x += 208;
			return true;
		}
		return false;
	}

	override public function playRubSound():Void
	{
		if (_fancyRub && _rubHandAnim._flxSprite.animation.name == "pull-lever")
		{
			rubSoundCount++;
			playLeverSound(FlxG.mouse.pressed ? "top" : "bot", _rubHandAnim.sfxLength, 0.2);
		}
		else {
			super.playRubSound();
		}
	}

	override public function initializeHitBoxes():Void
	{
		_buttonsBackPolyArray = new Array<Array<FlxPoint>>();
		_buttonsBackPolyArray[0] = [new FlxPoint(295, 238), new FlxPoint(302, 218), new FlxPoint(291, 203), new FlxPoint(302, 181), new FlxPoint(369, 179), new FlxPoint(362, 199), new FlxPoint(381, 236)];

		_buttonsBackNearbyPolyArray = new Array<Array<FlxPoint>>();
		_buttonsBackNearbyPolyArray[0] = [new FlxPoint(404, 263), new FlxPoint(417, 206), new FlxPoint(381, 138), new FlxPoint(285, 144), new FlxPoint(248, 202), new FlxPoint(272, 270)];

		_slamHatchPolyArray = new Array<Array<FlxPoint>>();
		_slamHatchPolyArray[1] = [new FlxPoint(186, 138), new FlxPoint(452, 138), new FlxPoint(496, 58), new FlxPoint(127, 53)];

		_leverBodyPolyArray = new Array<Array<FlxPoint>>();
		_leverBodyPolyArray[0] = [new FlxPoint(249, 220), new FlxPoint(247, 184), new FlxPoint(291, 184), new FlxPoint(287, 222)];

		_smallPortPolyArray = new Array<Array<FlxPoint>>();
		_smallPortPolyArray[0] = [new FlxPoint(379, 261), new FlxPoint(372, 238), new FlxPoint(402, 235), new FlxPoint(407, 256)];

		_bigPortPolyArray = new Array<Array<FlxPoint>>();
		_bigPortPolyArray[0] = [new FlxPoint(378, 258), new FlxPoint(372, 239), new FlxPoint(342, 241), new FlxPoint(351, 264)];

		_rearAntennaPolyArray = new Array<Array<FlxPoint>>();
		_rearAntennaPolyArray[0] = [new FlxPoint(299, 126), new FlxPoint(277, 53), new FlxPoint(343, 49), new FlxPoint(321, 126)];

		_leftArmPolyArray = new Array<Array<FlxPoint>>();
		_leftArmPolyArray[0] = [new FlxPoint(310, 62), new FlxPoint(-59, 51), new FlxPoint(-54, 475), new FlxPoint(325, 486)];
		_leftArmPolyArray[1] = [new FlxPoint(310, 62), new FlxPoint(-59, 51), new FlxPoint(-54, 475), new FlxPoint(325, 486)];
		_leftArmPolyArray[2] = [new FlxPoint(310, 62), new FlxPoint(-59, 51), new FlxPoint(-54, 475), new FlxPoint(325, 486)];
		_leftArmPolyArray[3] = [new FlxPoint(310, 62), new FlxPoint(-59, 51), new FlxPoint(-54, 475), new FlxPoint(325, 486)];
		_leftArmPolyArray[4] = [new FlxPoint(310, 62), new FlxPoint(-59, 51), new FlxPoint(-54, 475), new FlxPoint(325, 486)];
		_leftArmPolyArray[5] = [new FlxPoint(310, 62), new FlxPoint(-59, 51), new FlxPoint(-54, 475), new FlxPoint(325, 486)];

		encouragementWords = wordManager.newWords();
		encouragementWords.words.push([ { graphic:AssetPaths.magn_words_small__png, frame:0 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.magn_words_small__png, frame:1 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.magn_words_small__png, frame:2 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.magn_words_small__png, frame:3 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.magn_words_small__png, frame:4 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.magn_words_small__png, frame:5 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.magn_words_small__png, frame:6 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.magn_words_small__png, frame:7 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.magn_words_small__png, frame:8 } ]);

		boredWords = wordManager.newWords(6);
		boredWords.words.push([{ graphic:AssetPaths.magn_words_small__png, frame:9 }]);
		boredWords.words.push([{ graphic:AssetPaths.magn_words_small__png, frame:10 }]);
		boredWords.words.push([{ graphic:AssetPaths.magn_words_small__png, frame:11 }]);
		boredWords.words.push([{ graphic:AssetPaths.magn_words_small__png, frame:12 }]);
		// <press any magnezone to continue>
		boredWords.words.push([
		{ graphic:AssetPaths.magn_words_small__png, frame:13 },
		{ graphic:AssetPaths.magn_words_small__png, frame:15, yOffset:18, delay:0.7 },
		{ graphic:AssetPaths.magn_words_small__png, frame:17, yOffset:30, delay:1.4 }
		]);

		pleasureWords = wordManager.newWords(8);
		pleasureWords.words.push([{ graphic:AssetPaths.magn_words_medium__png, frame:0, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.magn_words_medium__png, frame:1, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.magn_words_medium__png, frame:2, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.magn_words_medium__png, frame:3, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.magn_words_medium__png, frame:4, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.magn_words_medium__png, frame:5, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.magn_words_medium__png, frame:6, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.magn_words_medium__png, frame:7, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.magn_words_medium__png, frame:8, height:48, chunkSize:5 } ]);

		_countdownWords = wordManager.newWords(0);
		_countdownWords.words.push([{ graphic:AssetPaths.magn_words_medium__png, frame:9, height:48, chunkSize:5, delay:-0.3 } ]);
		_countdownWords.words.push([{ graphic:AssetPaths.magn_words_medium__png, frame:10, height:48, chunkSize:5, delay:-0.3 } ]);
		_countdownWords.words.push([{ graphic:AssetPaths.magn_words_medium__png, frame:11, height:48, chunkSize:5, delay:-0.3 } ]);
		_countdownWords.words.push([{ graphic:AssetPaths.magn_words_medium__png, frame:12, height:48, chunkSize:5, delay:-0.3 } ]);
		_countdownWords.words.push([{ graphic:AssetPaths.magn_words_medium__png, frame:13, height:48, chunkSize:5, delay:-0.3 } ]);
		_countdownWords.words.push([{ graphic:AssetPaths.magn_words_medium__png, frame:14, height:48, chunkSize:5, delay:-0.3 } ]);
		_countdownWords.words.push([{ graphic:AssetPaths.magn_words_medium__png, frame:15, height:48, chunkSize:5, delay: -0.3 } ]);

		_eyePokeWords = wordManager.newWords();
		_eyePokeWords.words.push([{ graphic:AssetPaths.magn_words_small__png, frame:9 }]);
		_eyePokeWords.words.push([{ graphic:AssetPaths.magn_words_small__png, frame:19 }]);
		_eyePokeWords.words.push([{ graphic:AssetPaths.magn_words_small__png, frame:21 }]);

		_serviceHatchWords = wordManager.newWords(30);
		_serviceHatchWords.words.push([ // <ERR-005> SERVICE HATCH AJAR
		{ graphic:AssetPaths.magn_words_small__png, frame:14, chunkSize:5 },
		{ graphic:AssetPaths.magn_words_small__png, frame:16, yOffset:16, chunkSize:5, delay:0.8 },
		{ graphic:AssetPaths.magn_words_small__png, frame:18, yOffset:32, chunkSize:5, delay:1.4 }
		]);
		_serviceHatchWords.words.push([ // <ERR-005> INSPECT REAR SERVICE HATCH
		{ graphic:AssetPaths.magn_words_small__png, frame:14, chunkSize:5 },
		{ graphic:AssetPaths.magn_words_small__png, frame:20, yOffset:16, chunkSize:5, delay:0.8 },
		{ graphic:AssetPaths.magn_words_small__png, frame:16, yOffset:32, chunkSize:5, delay:1.8 }
		]);

		_buttonOnWords = wordManager.newWords();
		for (i in 0...80)
		{
			_buttonOnWords.words.push([
			{ graphic:AssetPaths.magn_words_small__png, frame:FlxG.random.getObject([22, 23, 24, 25], [3, 4, 2, 4]), chunkSize:5 },
			{ graphic:AssetPaths.magn_words_small__png, frame:FlxG.random.getObject([26, 27, 28, 29], [2, 4, 3, 4]), yOffset:18, chunkSize:5, delay:0.8 },
			{ graphic:AssetPaths.magn_words_small__png, frame:FlxG.random.getObject([30, 31]), yOffset:36, chunkSize:5, delay:1.6 }
			]);
		}

		orgasmWords = wordManager.newWords();
		orgasmWords.words.push([ { graphic:AssetPaths.magn_words_large__png, frame:0, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.magn_words_large__png, frame:1, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.magn_words_large__png, frame:2, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ // zzt-T! POP ~snzZZzzzzt~
		{ graphic:AssetPaths.magn_words_large__png, frame:3, width:200, height:150, yOffset:-30, chunkSize:15 },
		{ graphic:AssetPaths.magn_words_large__png, frame:5, width:200, height:150, yOffset:-30, chunkSize:7, delay:0.8 }
		]);
		orgasmWords.words.push([ { graphic:AssetPaths.magn_words_large__png, frame:4, width:200, height:150, yOffset: -30, chunkSize:5 } ]);

		_frontSweatArrayLeft = new Array<Array<FlxPoint>>();
		_frontSweatArrayLeft[0] = [new FlxPoint(149, 248), new FlxPoint(62, 265), new FlxPoint(103, 305), new FlxPoint(152, 317)];

		_frontSweatArray = new Array<Array<FlxPoint>>();
		_frontSweatArray[0] = [new FlxPoint(147, 248), new FlxPoint(151, 314), new FlxPoint(255, 355), new FlxPoint(384, 353), new FlxPoint(485, 303), new FlxPoint(475, 247), new FlxPoint(312, 224)];

		_frontSweatArrayRight = new Array<Array<FlxPoint>>();
		_frontSweatArrayRight[0] = [new FlxPoint(473, 239), new FlxPoint(568, 249), new FlxPoint(549, 281), new FlxPoint(491, 313)];

		_rearSweatArrayLeft = new Array<Array<FlxPoint>>();
		_rearSweatArrayLeft[0] = [new FlxPoint(196, 337), new FlxPoint(77, 260), new FlxPoint(556, 254), new FlxPoint(435, 333), new FlxPoint(321, 374)];

		_rearSweatArrayRight = new Array<Array<FlxPoint>>();
		_rearSweatArrayRight[0] = [new FlxPoint(196, 337), new FlxPoint(77, 260), new FlxPoint(556, 254), new FlxPoint(435, 333), new FlxPoint(321, 374)];

		_frontRubRegions = new Array<Array<FlxPoint>>();
		_frontRubRegions[0] = [new FlxPoint(33, 271), new FlxPoint(64, 253), new FlxPoint(107, 240), new FlxPoint(148, 230), new FlxPoint(150, 249), new FlxPoint(153, 383), new FlxPoint(27, 341)];
		_frontRubRegions[1] = [new FlxPoint(33, 271), new FlxPoint(64, 253), new FlxPoint(107, 240), new FlxPoint(148, 230), new FlxPoint(144, 192), new FlxPoint(175, 95), new FlxPoint(30, 122)];
		_frontRubRegions[2] = [new FlxPoint(146, 231), new FlxPoint(240, 217), new FlxPoint(410, 219), new FlxPoint(477, 227), new FlxPoint(472, 247), new FlxPoint(516, 340), new FlxPoint(322, 402), new FlxPoint(143, 353), new FlxPoint(151, 308), new FlxPoint(151, 250)];
		_frontRubRegions[3] = [new FlxPoint(146, 231), new FlxPoint(240, 217), new FlxPoint(410, 219), new FlxPoint(477, 227), new FlxPoint(475, 193), new FlxPoint(435, 88), new FlxPoint(186, 82), new FlxPoint(150, 174), new FlxPoint(143, 207)];
		_frontRubRegions[4] = [new FlxPoint(475, 229), new FlxPoint(520, 228), new FlxPoint(568, 236), new FlxPoint(631, 275), new FlxPoint(624, 405), new FlxPoint(501, 425), new FlxPoint(495, 304), new FlxPoint(473, 241)];
		_frontRubRegions[5] = [new FlxPoint(475, 229), new FlxPoint(520, 228), new FlxPoint(568, 236), new FlxPoint(631, 275), new FlxPoint(648, 97), new FlxPoint(442, 112), new FlxPoint(465, 169), new FlxPoint(476, 197)];

		for (i in 0..._rearSweatArrayLeft[0].length)
		{
			_rearSweatArrayLeft[0][i].x -= 872;
			_rearSweatArrayRight[0][i].x += 872;
		}

		toyStartWords.words.push([ // oh? ...what are you planning to do with those?
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:8},
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:10, yOffset:0, delay:0.5 },
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:12, yOffset:18, delay:1.3 },
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:14, yOffset:38, delay:2.1 },
		]);
		toyStartWords.words.push([ // those beads are decorative, correct? ...what do you intend to decorate?
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:16},
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:18, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:20, yOffset:36, delay:1.6 },
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:22, yOffset:34, delay:2.1 },
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:24, yOffset:56, delay:2.9 },
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:26, yOffset:74, delay:3.7 },
		]);
		toyStartWords.words.push([ // well. those certainly look festive. -fzzl-
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:15},
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:17, yOffset:0, delay:0.5 },
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:19, yOffset:16, delay:1.3 },
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:21, yOffset:34, delay:2.1 },
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:23, yOffset:34, delay:2.6 },
		]);

		toyInterruptWords.words.push([ // oh? ...no <beads> today?
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:0},
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:2, yOffset:0, delay:0.8 },
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:4, yOffset:18, delay:1.4 },
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:6, yOffset:38, delay:2.0 },
		]);
		toyInterruptWords.words.push([ // organics are so fickle. -bzt-
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:1},
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:3, yOffset:22, delay:0.9 },
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:5, yOffset:22, delay:1.8 },
		]);
		toyInterruptWords.words.push([ // -bweeoop- RESUMING TACTILE STIMULATION
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:7},
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:9, yOffset:20, delay:1.0 },
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:11, yOffset:40, delay:1.7 },
		{ graphic:AssetPaths.magnbeads_words_small1__png, frame:13, yOffset:60, delay:2.4 },
		]);

		toyBadWords = wordManager.newWords();
		toyBadWords.words.push([ // hmph. ...you are fortunate <magnezone> does not represent the fashion police.
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:4},
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:6, yOffset:16, delay:0.8 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:8, yOffset:32, delay:1.6 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:10, yOffset:48, delay:2.2 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:12, yOffset:64, delay:3.0 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:14, yOffset:84, delay:3.8 },
		]);
		toyBadWords.words.push([ // ...<magnezone> looks ridiculous.
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:0},
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:2, yOffset:20, delay:1.0 },
		]);
		toyBadWords.words.push([ // this is not a good look for <magnezone>.
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:1},
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:3, yOffset:16, delay:1.0 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:5, yOffset:36, delay:1.8 },
		]);

		toyNeutralWords = wordManager.newWords();
		toyNeutralWords.words.push([ // why did you do that? <magnezone> is confused. -frzzzt-
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:7},
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:9, yOffset:22, delay:0.8 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:8, yOffset:38, delay:1.6 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:11, yOffset:56, delay:2.4 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:13, yOffset:74, delay:3.4 },
		]);
		toyNeutralWords.words.push([ // <magnezone> needs... -bzzz- time to process what just happened.
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:8},
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:16, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:18, yOffset:40, delay:2.1 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:20, yOffset:58, delay:2.9 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:22, yOffset:76, delay:3.5 },
		]);
		toyNeutralWords.words.push([ // -fzzl- ...does <magnezone> look more fashionable now?
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:15},
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:8, yOffset:14, delay:0.8 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:17, yOffset:34, delay:1.6 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:19, yOffset:48, delay:2.4 },
		]);

		toyGoodWords = wordManager.newWords();
		toyGoodWords.words.push([ // oh. -BEEP- you actually made it look somewhat nice.
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:24},
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:26, yOffset:20, delay:1.3 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:28, yOffset:40, delay:2.1 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:30, yOffset:60, delay:2.9 },
		]);
		toyGoodWords.words.push([ // -bwoop- yes, this look suites <magnezone> nicely~
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:21},
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:23, yOffset:22, delay:1.3 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:8, yOffset:38, delay:2.1 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:25, yOffset:58, delay:2.7 },
		]);
		toyGoodWords.words.push([ // thank you. <magnezone> feels <pretty>. -BEEP- -BOOP-
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:27},
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:8, yOffset:16, delay:1.3 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:29, yOffset:38, delay:2.1 },
		{ graphic:AssetPaths.magnbeads_words_small0__png, frame:31, yOffset:58, delay:3.4 },
		]);
	}

	override public function computeChatComplaints(complaints:Array<Int>):Void
	{
		if (_meanThings[0] == false)
		{
			complaints.push(0);
		}
		if (_meanThings[1] == false)
		{
			complaints.push(1);
		}
		if (_meanThings[2] == false)
		{
			complaints.push(2);
		}
	}

	override function generateCumshots():Void
	{
		if (!came)
		{
			_heartBank._dickHeartReservoir = SexyState.roundUpToQuarter(_heartPenalty * _heartBank._dickHeartReservoir);
			_heartBank._foreplayHeartReservoir = SexyState.roundUpToQuarter(_heartPenalty * _heartBank._foreplayHeartReservoir);
		}

		super.generateCumshots();
	}

	override function updateHead(elapsed:Float):Void
	{
		super.updateHead(elapsed);
		if (_gameState >= 400 && _pokeWindow._arousal == 0)
		{
			if (_meanThings[1] == false || _meanThings[2] == false)
			{
				// electrocuted the player... -sad beep-
			}
			else
			{
				// magnezone finishes his session with a permanent slightly-stoned expression
				_pokeWindow.setArousal(1);
			}
		}
	}

	function playLeverSound(topBot:String, sfxLength:Float, volume:Float):Void
	{
		var ab:String = FlxG.random.bool() ? "a" : "b";
		var speed:String;
		if (sfxLength > 0.6)
		{
			speed = "slow";
		}
		else if (sfxLength > 0.25)
		{
			speed = "med";
		}
		else {
			speed = "fast";
		}
		var sfxFieldName:String = "magn_lever_0063_" + topBot + "_" + speed + ab + "__mp3";
		var embeddedSound:String;
		#if reflection
		// Workaround for Haxe #6630; Reflect.field on public static inline return null.
		// https://github.com/HaxeFoundation/haxe/issues/6630
		embeddedSound = REFLECTION_WORKAROUND[sfxFieldName];
		#else
		embeddedSound = Reflect.field(AssetPaths, sfxFieldName);
		#end
		SoundStackingFix.play(embeddedSound, volume);
	}

	function updateBigPortAnimation()
	{
		var tightness0:Int = 3;

		if (_bigPortTightness > 2.4)
		{
			tightness0 = 4;
		}
		else if (_bigPortTightness > 1.1)
		{
			tightness0 = 5;
		}
		else
		{
			tightness0 = 6;
		}

		_pokeWindow._portsBack.animation.add("finger-big-port", [0, 1, 2, 2, 2, 2].slice(0, tightness0));
		_pokeWindow._interact.animation.add("finger-big-port", [12, 13, 14, 15, 16, 17].slice(0, tightness0));
	}

	override public function moveParticlesWithCamera():Void
	{
		super.moveParticlesWithCamera();
		for (particle in _smallSparkEmitter.members)
		{
			if (particle.alive && particle.exists)
			{
				particle.x -= _pokeWindow.cameraPosition.x - _oldCameraPosition.x;
				particle.y -= _pokeWindow.cameraPosition.y - _oldCameraPosition.y;
			}
		}
	}

	override function emitSweat()
	{
		sweatAreas[0].chance = 0;
		sweatAreas[1].chance = 0;
		sweatAreas[2].chance = 0;
		sweatAreas[3].chance = 0;
		sweatAreas[4].chance = 0;
		if (_pokeWindow.cameraPosition.x > 200)
		{
			// right sweat array
			sweatAreas[4].chance = 1;
		}
		else if (_pokeWindow.cameraPosition.x < -200)
		{
			// left sweat array
			sweatAreas[3].chance = 1;
		}
		else
		{
			// center sweat arrays
			sweatAreas[0].chance = 2;
			sweatAreas[1].chance = 9;
			sweatAreas[2].chance = 2;
		}

		super.emitSweat();
	}

	override function computePrecumAmount():Int
	{
		var precumAmount:Int = 0;
		if (FlxG.random.float(1, 16) < _heartEmitCount)
		{
			precumAmount++;
		}
		if (FlxG.random.float(1, 64) < _heartEmitCount + (specialRub == "antenna" ? 64 : 0))
		{
			precumAmount++;
		}
		if (Math.pow(FlxG.random.float(0, 1.0), 1.5) >= _heartBank.getDickPercent())
		{
			precumAmount++;
		}
		if (Math.pow(FlxG.random.float(0, 1.0), 2) >= _heartBank.getForeplayPercent())
		{
			precumAmount++;
		}

		return precumAmount;
	}

	override function pushCumShot(cumshot:Cumshot):Void
	{
		// push, even if pokemon libido is 1...
		_cumShots.push(cumshot);
	}

	override public function precum(amount:Float):Void
	{
		var which:Int = FlxG.random.int(0, 4);

		amount += FlxG.random.float( -0.5, 0.5);

		if (which <= 2)
		{
			// one big spark
			pushCumShot( { force : 0, rate : 0, duration : FlxG.random.float(0, 1.5), arousal:-1 } );
			pushCumShot( { force : 0.4 * Math.pow(amount, 1.42), rate : 1.0, duration : 1.0, arousal: -1 } );
		}
		else if (which == 3)
		{
			// small/big
			pushCumShot( { force : 0, rate : 0, duration : FlxG.random.float(0, 0.5), arousal:-1 } );
			pushCumShot( { force : 0.4 * Math.pow(amount, 1.42), rate : 1.0, duration : 0.3, arousal: -1 } );
			pushCumShot( { force : 0, rate : 0, duration : FlxG.random.float(0.3, 0.7), arousal:-1 } );
			pushCumShot( { force : 0.4 * Math.pow(amount, 1.42), rate : 1.0, duration : 0.7, arousal: -1 } );
		}
		else {
			// big/small
			pushCumShot( { force : 0, rate : 0, duration : FlxG.random.float(0, 0.5), arousal:-1 } );
			pushCumShot( { force : 0.4 * Math.pow(amount, 1.42), rate : 1.0, duration : 0.7, arousal: -1 } );
			pushCumShot( { force : 0, rate : 0, duration : FlxG.random.float(0.3, 0.7), arousal:-1 } );
			pushCumShot( { force : 0.4 * Math.pow(amount, 1.42), rate : 1.0, duration : 0.3, arousal: -1 } );
		}
	}

	override function handleRubReward():Void
	{
		var niceRub:Float = 1.0;
		if (specialRub == "big-port")
		{
			_bigPortTightness *= FlxG.random.float(0.72, 0.82);
			updateBigPortAnimation();
			if (_rubBodyAnim != null)
			{
				_rubBodyAnim.refreshSoon();
			}
			if (_rubHandAnim != null)
			{
				_rubHandAnim.refreshSoon();
			}
		}
		if (FRONT_RUB_REGIONS.exists(specialRub))
		{
			if (_desiredScrewRubs == null)
			{
				// first front rub; establish what magnezone likes and doesn't like
				var possibleScrewRubs:Array<Array<String>> = ALL_DESIRED_SCREW_RUBS.copy();
				var i = possibleScrewRubs.length - 1;
				while (i >= 0)
				{
					if (possibleScrewRubs[i].indexOf(specialRub) != -1)
					{
						possibleScrewRubs.splice(i, 1);
					}
					i--;
				}
				_desiredScrewRubs = possibleScrewRubs[_magnMood0 % possibleScrewRubs.length];
			}
			if (_desiredScrewRubs.indexOf(specialRub) != -1)
			{
				_happyScrewRubsTimer = FlxG.random.float(9, 15);
				niceRub = 1.5;
				if (_happyScrewRubs.indexOf(specialRub) == -1)
				{
					if (_happyScrewRubs.length < 2 ||
							specialRubsInARow() < 2 // need to rub the third one twice
					   )
					{
						_happyScrewRubs.push(specialRub);
						_sadScrewRubs.splice(0, _sadScrewRubs.length);
						niceRub = 2.0;
					}
				}
			}
			else
			{
				niceRub = 0.667;
				if (_sadScrewRubs.indexOf(specialRub) == -1)
				{
					_happyScrewRubsTimer = FlxG.random.float(9, 15);
					niceRub = 0.333;
					_sadScrewRubs.push(specialRub);
					if (_happyScrewRubs.length == 0)
					{
						// zero are smiling... nothing to deactivate, but can still penalize
						if (_sadScrewRubs.length >= 3)
						{
							if (_niceThings[0] || _niceThings[1])
							{
								_heartPenalty *= 0.96;
							}
						}
					}
					else if (_happyScrewRubs.length == 1)
					{
						// one is smiling... two mistakes will deactivate one
						if (_sadScrewRubs.length >= 2)
						{
							if (_niceThings[0] || _niceThings[1])
							{
								_heartPenalty *= 0.96;
							}
							_happyScrewRubs.splice(0, 1);
						}
					}
					else
					{
						// two or more are smiling... any mistake deactivates
						if (_niceThings[0] || _niceThings[1])
						{
							_heartPenalty *= 0.96;
						}
						_happyScrewRubs.splice(FlxG.random.int(0, 1), 1);
					}
				}
			}
		}
		if (specialRub != null && StringTools.endsWith(specialRub, "-eye"))
		{
			niceRub = 0.001;
			if (_happyScrewRubs.length > 0)
			{
				_happyScrewRubs.splice(FlxG.random.int(0, _happyScrewRubs.length - 1), 1);
			}
			if (specialRubsInARow() == 2)
			{
				emitWords(_eyePokeWords);
			}
			var eyeRubCount:Int = specialRubs.filter(function(s) { return StringTools.endsWith(s, "-eye"); } ).length;
			if (eyeRubCount >= 3 && _meanThings[0])
			{
				_meanThings[0] = false;
				doMeanThing();
			}
		}
		if (specialRub == "big-port" || specialRub == "small-port" || specialRub == "mash-buttons")
		{
			var undesiredSqubs:Array<String> = ["big-port", "small-port", "mash-buttons"];
			var desiredSqub:String = undesiredSqubs.splice(_magnMood1, 1)[0];

			var desiredSqubCount:Int = specialRubs.filter(function(s) { return s == desiredSqub; } ).length;
			var undesiredSqubCount0:Int = specialRubs.filter(function(s) { return s == undesiredSqubs[0]; } ).length;
			var undesiredSqubCount1:Int = specialRubs.filter(function(s) { return s == undesiredSqubs[1]; } ).length;
			if (_niceThings[2])
			{
				if ((Math.min(desiredSqubCount, 3) + Math.min(undesiredSqubCount0, 3) + Math.min(undesiredSqubCount1, 3) >= 5))
				{
					_niceThings[2] = false;
					doNiceThing(0.33333);
				}
			}
			if (_niceThings[3])
			{
				if (specialRub == desiredSqub)
				{
					_pokeWindow.emitLightning(FlxG.random.float(3, 6));
				}
				if (specialRub == desiredSqub && desiredSqubCount >= undesiredSqubCount0 + 3 && desiredSqubCount >= undesiredSqubCount1 + 3)
				{
					_niceThings[3] = false;
					emitWords(pleasureWords);
					doNiceThing(0.66667);
				}
				if (specialRub != desiredSqub && (undesiredSqubCount0 >= desiredSqubCount + 3 || undesiredSqubCount1 >= desiredSqubCount + 3))
				{
					_heartPenalty *= 0.94;
				}
			}
		}
		if (_magnMood1 != 0 && specialRub == "big-port")
		{
			// we're not supposed to be rubbing the big port very much
			var bigPortCount:Int = specialRubs.filter(function(s) { return s == "big-port"; } ).length;
			_pokeWindow.emitLightning(Math.min(9 + bigPortCount * 3, 30));
			if (bigPortCount >= 3 && FlxG.random.bool(14))
			{
				if (PlayerData.cursorInsulated)
				{
					// phew! safe
					if (_bigZapTimer <= 0)
					{
						_bigZapTimer = FlxG.random.float(10, 20);
						bigZapHand();
						FlxSoundKludge.play(AssetPaths.magn_mediumzap_000e__mp3, 0.7);
					}
				}
				else
				{
					electrocuteHand();
					_meanThings[2] = false;
					_heartBank._foreplayHeartReservoir = 0;
					_heartBank._dickHeartReservoir = 0;
					_remainingOrgasms = 0;
				}
			}
		}
		if (_niceThings[0] && _happyScrewRubs.length >= 2)
		{
			_niceThings[0] = false;
			doNiceThing(0.33333);
		}
		if (_niceThings[1] && _happyScrewRubs.length >= 3)
		{
			_niceThings[1] = false;
			emitWords(pleasureWords);
			doNiceThing(0.66667);
		}

		if (!_pokeWindow._hatchOpen && _hatchTimer <= 0 && pastBonerThreshold())
		{
			_pokeWindow.setHatchOpen(true);
			_serviceHatchMessageTimer = FlxG.random.float(10, 20);
		}

		updateEyeHappy();
		if (specialRub == "lever")
		{
			{
				// pulling the lever too quickly finishes quicker, but incurs a penalty
				var tooFast:Float = 16;
				while (tooFast <= _untouchedButtonIndex)
				{
					niceRub *= 1.2;
					if (tooFast >= 18)
					{
						_heartPenalty *= 0.96;
					}
					tooFast += 0.6;
					_autoSweatRate += 0.04;
					scheduleSweat(FlxG.random.int(2, 5));
				}
			}

			var lucky:Float = lucky(0.7, 1.43, 0.10 * niceRub);
			var amount:Float = SexyState.roundUpToQuarter(lucky * _heartBank._dickHeartReservoir);
			_heartBank._dickHeartReservoir -= amount;
			amount = SexyState.roundUpToQuarter(_heartPenalty * amount);
			_heartEmitCount += amount;
		}
		else {
			var lucky:Float = lucky(0.7, 1.43, 0.04 * niceRub);
			var amount:Float = SexyState.roundUpToQuarter(lucky * _heartBank._foreplayHeartReservoir);
			_heartBank._foreplayHeartReservoir -= amount;
			amount = SexyState.roundUpToQuarter(_heartPenalty * amount);
			_heartEmitCount += amount;
		}

		if ((specialRub == "mash-buttons" || specialRub == "push-buttons") && FlxG.random.bool(15))
		{
			maybeEmitWords(_buttonOnWords);
		}

		emitCasualEncouragementWords();
		if (_heartEmitCount > 0)
		{
			maybeScheduleBreath();
			maybePlayPokeSfx();
			maybeEmitPrecum();
		}
	}

	override public function determineArousal():Int
	{
		if (_heartBank.getForeplayPercent() + _heartBank.getForeplayPercent() < 0.5)
		{
			return 5;
		}
		else if (_heartBank.getForeplayPercent() + _heartBank.getForeplayPercent() < 1.0)
		{
			return 4;
		}
		else if (_heartBank.getForeplayPercent() + _heartBank.getForeplayPercent() < 1.4)
		{
			return 3;
		}
		else if (_heartBank.getForeplayPercent() + _heartBank.getForeplayPercent() < 1.7)
		{
			return 2;
		}
		else if (_heartBank.getForeplayPercent() + _heartBank.getForeplayPercent() < 1.9 || _remainingOrgasms == 0)
		{
			return 1;
		}
		else {
			return 0;
		}
	}

	function updateEyeHappy():Void
	{
		_pokeWindow.setEyeHappy(0, _happyScrewRubs.indexOf("left-screw") != -1 || _happyScrewRubs.indexOf("body-top-left") != -1 || _happyScrewRubs.indexOf("body-bottom-left") != -1);
		_pokeWindow.setEyeHappy(1, _happyScrewRubs.indexOf("antenna") != -1 || _happyScrewRubs.indexOf("body-top-middle") != -1 || _happyScrewRubs.indexOf("body-bottom-middle") != -1);
		_pokeWindow.setEyeHappy(2, _happyScrewRubs.indexOf("right-screw") != -1 || _happyScrewRubs.indexOf("body-top-right") != -1 || _happyScrewRubs.indexOf("body-bottom-right") != -1);
	}

	function refreshUntouchedButtonState(elapsed:Float):Void
	{
		if (_untouchedButtonIndex > -3)
		{
			_untouchedButtonIndex -= elapsed;
		}
		if (_remainingOrgasms > 0)
		{
			_untouchedButtonIndex = Math.max(_untouchedButtonIndex, 19 * (1 + _bonerThreshold - _heartBank.getDickPercent() - _heartBank.getForeplayPercent()) / (1 + _bonerThreshold - _cumThreshold));
		}
		if (_recentButtonClickTimer > 0)
		{
			_recentButtonClickTimer -= elapsed;
		}
		_untouchedButtonTimer -= elapsed;
		if (_untouchedButtonTimer <= 0)
		{
			_untouchedButtonTimer += FlxG.random.float(1.77776, 2.22222);
			_pokeWindow._untouchedButtonState = _untouchedButtonStates[Std.int(FlxMath.bound(_untouchedButtonIndex, 0, 19))];
		}
	}

	public function playerWasKnockedOut():Bool
	{
		return !_meanThings[1] || !_meanThings[2];
	}

	override function dialogTreeCallback(Msg:String):String
	{
		return super.dialogTreeCallback(Msg);
		if (Msg == "%cursor-normal%")
		{
			_hurtHand.visible = false;
		}
	}

	override function videoWasDirty():Bool
	{
		return false;
	}

	public function beadOutfitChangeEvent(index:Int, direction:Int)
	{
		_idlePunishmentTimer = 0;

		if (index == 0)
		{
			_pokeWindow._beadsFrontL.animation.frameIndex = (_pokeWindow._beadsFrontL.animation.frameIndex + 5 + direction) % 5;
		}
		if (index == 1)
		{
			_pokeWindow._beadsFrontC.animation.frameIndex = (_pokeWindow._beadsFrontC.animation.frameIndex + 6 + direction) % 6;
		}
		if (index == 2)
		{
			_pokeWindow._beadsFrontR.animation.frameIndex = (_pokeWindow._beadsFrontR.animation.frameIndex + 5 + direction) % 5;
		}
		if (!_pokeWindow._beadsFrontC.visible)
		{
			// make everything visible
			if (_pokeWindow._beadsFrontC.animation.frameIndex == 5)
			{
				_pokeWindow._beadsFrontC.animation.frameIndex = 0;
				_pokeWindow._beadsBackC.animation.frameIndex = 0;
			}
			_pokeWindow.setBeadsVisible(true);
		}
		else if (_pokeWindow._beadsFrontC.visible && _pokeWindow._beadsFrontC.animation.frameIndex == 5)
		{
			// make everything invisible
			_pokeWindow._beadsFrontC.visible = false;
			_pokeWindow.setBeadsVisible(false);
		}
		_pokeWindow.updateRearBeads();
	}

	private function eventAwardBeadHearts(args:Array<Dynamic>):Void
	{
		if (!_pokeWindow._beadsFrontC.visible)
		{
			// no hearts; not visible... superclass will emit "toy stop words"
		}
		else {
			var leftIndex:Int = _pokeWindow._beadsFrontL.animation.frameIndex;
			var centerIndex:Int = _pokeWindow._beadsFrontC.animation.frameIndex;
			var rightIndex:Int = _pokeWindow._beadsFrontR.animation.frameIndex;
			var symmetrical:Bool = leftIndex == rightIndex;

			var aesthetics:Float = 0;
			var aestheticsVariability:Float = 0;
			if (!symmetrical)
			{
				aesthetics = [ -3, -2, -1, 1, 3, 5][BEAD_AESTHETICS[(leftIndex + rightIndex) % 5][centerIndex]];
				aestheticsVariability = [2.5, 3.5, 4.5, 5.5, 6.5, 7.5][BEAD_AESTHETIC_VARIABILITY[leftIndex][(centerIndex + rightIndex) % 5]];
			}
			else {
				aesthetics = [ -1, 0, 1, 3, 5, 7][BEAD_AESTHETICS[leftIndex][centerIndex]];
				aestheticsVariability = [0.5, 1.5, 2.5, 3.5, 4.5, 5.5][BEAD_AESTHETIC_VARIABILITY[leftIndex][centerIndex]];
			}

			var resultPct:Float = FlxMath.bound(aesthetics + FlxG.random.float( -aestheticsVariability, aestheticsVariability), 0, 9) * 0.01;
			_heartEmitCount += SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * resultPct);
			_toyBank._dickHeartReservoir = 0;

			if (resultPct <= 0)
			{
				maybeEmitWords(toyBadWords);
			}
			else if (resultPct <= 0.03)
			{
				maybeEmitWords(toyNeutralWords);
			}
			else {
				maybeEmitWords(toyGoodWords);
			}
		}
	}

	override public function createToyMeter(toyButton:FlxSprite, pctNerf:Float=1.0):ReservoirMeter
	{
		return new ReservoirMeter(toyButton, 0, ReservoirStatus.Green, 70, 63);
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		_pokeWindow._portsBack.animation.add("finger-big-port", [0, 1, 2]);
		_pokeWindow._interact.animation.add("finger-big-port", [12, 13, 14]);
	}

	override function cursorSmellPenaltyAmount():Int
	{
		return 0;
	}

	override public function destroy():Void
	{
		super.destroy();

		_pressedPanelButtonIndexes = null;
		_buttonsBackPolyArray = null;
		_buttonsBackNearbyPolyArray = null;
		_slamHatchPolyArray = null;
		_leverBodyPolyArray = null;
		_smallPortPolyArray = null;
		_bigPortPolyArray = null;
		_rearAntennaPolyArray = null;
		_frontSweatArray = null;
		_frontSweatArrayLeft = null;
		_frontSweatArrayRight = null;
		_rearSweatArrayLeft = null;
		_rearSweatArrayRight = null;
		_frontRubRegions = null;
		_leftArmPolyArray = null;
		_smallSparkEmitter = FlxDestroyUtil.destroy(_smallSparkEmitter);
		_largeSparkEmitter = FlxDestroyUtil.destroy(_smallSparkEmitter);
		_buttonClickSpot = FlxDestroyUtil.put(_buttonClickSpot);
		_hurtHand = FlxDestroyUtil.destroy(_hurtHand);
		_countdownWords = null;
		_eyePokeWords = null;
		_serviceHatchWords = null;
		_buttonOnWords = null;
		_prevCountdownWord = FlxDestroyUtil.destroy(_prevCountdownWord);
		_desiredScrewRubs = null;
		_happyScrewRubs = null;
		_sadScrewRubs = null;
		_niceThings = null;
		_meanThings = null;
		_untouchedButtonStates = null;
		_toyInterface = FlxDestroyUtil.destroy(_toyInterface);
		toyBadWords = null;
		toyNeutralWords = null;
		toyGoodWords = null;
		_purpleAnalBeadButton = FlxDestroyUtil.destroy(_purpleAnalBeadButton);
		_bigBeadButton = FlxDestroyUtil.destroy(_bigBeadButton);
	}
}