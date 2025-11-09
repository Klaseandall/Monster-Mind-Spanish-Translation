package poke.magn;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import kludge.BetterFlxRandom;
import kludge.LateFadingFlxParticle;
import openfl.display.BlendMode;
import openfl.geom.Point;

/**
 * Sprites and animations for Magnezone
 */
class MagnWindow extends PokeWindow
{
	private static var BOUNCE_DURATION:Float = 8.8;

	public static var BUTTON_POSITIONS:Array<Array<Int>> = [
				[86, 173], [104, 172], [122, 172], [140, 171],
				[77, 188], [95, 188], [113, 187], [131, 186],
				[87, 204], [105, 203], [123, 203], [141, 201],
				[79, 219], [97, 219], [115, 218], [133, 218], [151, 216]
			];

	private static var BUTTON_LCR:Array<String> = [
				"left", "center", "right", "right",
				"left", "left", "center", "right",
				"left", "left", "center", "right",
				"left", "left", "left", "center", "right"
			];

	private static var BUTTON_RYG:Array<String> = [
				"red", "red", "yellow", "red",
				"yellow", "yellow", "yellow", "red",
				"yellow", "red", "green", "yellow",
				"green", "green", "green", "green", "yellow"
			];
	
	#if reflection
	// Workaround for Haxe #6630; Reflect.field on public static inline return null.
	// https://github.com/HaxeFoundation/haxe/issues/6630
	private static var REFLECTION_WORKAROUND:Map<String, FlxGraphicAsset> = [
			"magn_button_green_center__png" => AssetPaths.magn_button_green_center__png,
			"magn_button_green_left__png" => AssetPaths.magn_button_green_left__png,
			"magn_button_green_right__png" => AssetPaths.magn_button_green_right__png,
			"magn_button_red_center__png" => AssetPaths.magn_button_red_center__png,
			"magn_button_red_left__png" => AssetPaths.magn_button_red_left__png,
			"magn_button_red_right__png" => AssetPaths.magn_button_red_right__png,
			"magn_button_yellow_center__png" => AssetPaths.magn_button_yellow_center__png,
			"magn_button_yellow_left__png" => AssetPaths.magn_button_yellow_left__png,
			"magn_button_yellow_right__png" => AssetPaths.magn_button_yellow_right__png,
	];
	#end

	private var _frontSprites:Array<FlxSprite> = []; // sprites from front perspective
	private var _backSprites:Array<FlxSprite> = []; // sprites from back perspective

	public var _hatch:BouncySprite;
	public var _tail:BouncySprite;
	public var _leftScrew:BouncySprite;
	public var _rightScrew:BouncySprite;
	public var _antenna:BouncySprite;
	public var _body:BouncySprite;
	public var _leftEye:BouncySprite;
	public var _middleEye:BouncySprite;
	public var _rightEye:BouncySprite;
	public var _arms:BouncySprite;
	public var _hat:BouncySprite;
	public var _badge:BouncySprite;
	public var _cheer:BouncySprite;

	public var _beadsFrontL:BouncySprite;
	public var _beadsFrontC:BouncySprite;
	public var _beadsFrontR:BouncySprite;
	public var _beadsBackL:BouncySprite;
	public var _beadsBackC:BouncySprite;
	public var _beadsBackR:BouncySprite;

	public var _lightningLayer:BouncySprite;
	public var _whiteZapLayer:FlxSprite;
	private var _whiteZapTween:FlxTween;

	private var _lightningLines:Array<LightningLine> = [];

	private var _lightningIndex:Int = 0;
	private var _lightningTimer:Float = 0;
	public var _lightningDirty:Bool = true;
	public var _lightningIntensity:Float = 0;
	public var _lightningIntensityBoost:Float = 0;

	public var _bodyBack:BouncySprite;
	public var _tailBack:BouncySprite;
	public var _hatBack:BouncySprite;
	public var _hatchBack:BouncySprite;
	public var _buttonsBack:BouncySprite;
	public var _leverBack:BouncySprite;
	public var _portsBack:BouncySprite;
	public var _lightningLayerBack:BouncySprite;

	private var _cameraTween:FlxTween;
	public var _hatchOpen:Bool = false;

	public var _buttonDurations:Array<Float> = [
				10, 10, 10, 10,
				10, 10, 10, 10,
				10, 10, 10, 10,
				10, 10, 10, 10, 10
			];

	/*
	 * 0 == off
	 * 1 == on
	 * 2 == blinking
	 */
	public var _untouchedButtonState:Array<Int> = [
				2, 2, 2, 2,
				2, 2, 2, 2,
				2, 2, 2, 2,
				2, 2, 2, 2, 2
			];

	/*
	 * Time until the buttons revert to their natural, untouched state.
	 *
	 * When the player presses a button this is set to a positive number, and
	 * counts down to 0. and when it counts down to zero, the button is reset
	 * to its default state
	 */
	public var _buttonTouched:Array<Float> = [
				0, 0, 0, 0,
				0, 0, 0, 0,
				0, 0, 0, 0,
				0, 0, 0, 0, 0
			];

	public var _buttonPushed:Array<Bool> = [
			false, false, false, false,
			false, false, false, false,
			false, false, false, false,
			false, false, false, false, false
										   ];

	public var _buttonLit:Array<Bool> = [
											false, false, false, false,
											false, false, false, false,
											false, false, false, false,
											false, false, false, false, false
										];

	private var _buttonsDirty = false;
	private var _buttonRefreshTimer:Float = 0;

	public function new(X:Float=0, Y:Float=0, Width:Int=248, Height:Int = 349)
	{
		super(X, Y, Width, Height);
		_bgColor = 0xff65a96b; // green
		_prefix = "magn";
		_name = "Magnezone";
		_victorySound = AssetPaths.magn__mp3;
		_dialogClass = MagnDialog;
		FlxG.random.shuffle(_buttonDurations);

		_cameraButtons.push({x:202, y:3, image:AssetPaths.camera_button_left__png, callback:() -> cameraLeft()});
		_cameraButtons.push({x:234, y:3, image:AssetPaths.camera_button__png, callback:() -> cameraRight()});

		var bgSprite:FlxSprite = new FlxSprite( -188, -54, AssetPaths.magn_bg__png);
		_frontSprites.push(bgSprite);
		add(bgSprite);

		_hatch = new BouncySprite( -188 + 208, -54, 14, BOUNCE_DURATION, 0, _age);
		_hatch.loadGraphic(AssetPaths.magn_hatch__png, true, 208, 266);
		_hatch.animation.add("default", [0]);
		_hatch.animation.add("closed", [0]);
		_hatch.animation.add("open", [1]);
		_frontSprites.push(_hatch);
		addPart(_hatch);

		_tail = new BouncySprite( -188, -54, 14, BOUNCE_DURATION, 0, _age);
		loadWideGraphic(_tail, AssetPaths.magn_tail__png);
		_frontSprites.push(_tail);
		addPart(_tail);

		_leftScrew = new BouncySprite( -188, -54, 10, BOUNCE_DURATION, 0.18, _age);
		_leftScrew.loadGraphic(AssetPaths.magn_left_screw__png, true, 208, 266);
		_leftScrew.animation.add("default", [0]);
		_leftScrew.animation.add("rub-left-screw", [0, 1, 2, 3]);
		_frontSprites.push(_leftScrew);
		addPart(_leftScrew);

		_rightScrew = new BouncySprite( -188 + 208 * 2, -54, 10, BOUNCE_DURATION, 0.18, _age);
		_rightScrew.loadGraphic(AssetPaths.magn_right_screw__png, true, 208, 266);
		_rightScrew.animation.add("default", [0]);
		_rightScrew.animation.add("rub-right-screw", [0, 1, 2, 3]);
		_frontSprites.push(_rightScrew);
		addPart(_rightScrew);

		_antenna = new BouncySprite( -188 + 208, -54, 10, BOUNCE_DURATION, 0.20, _age);
		_antenna.loadGraphic(AssetPaths.magn_antenna__png, true, 208, 266);
		_frontSprites.push(_antenna);
		_antenna.animation.add("default", [0]);
		_antenna.animation.add("rub-antenna", [0]);
		addPart(_antenna);

		_body = new BouncySprite( -188, -54, 12, BOUNCE_DURATION, 0.16, _age);
		loadWideGraphic(_body, AssetPaths.magn_body__png);
		_frontSprites.push(_body);
		addPart(_body);

		_leftEye = new BouncySprite( -188 + 208 * 0, -54, 12, BOUNCE_DURATION, 0.16, _age);
		_leftEye.loadGraphic(AssetPaths.magn_eyes__png, true, 208, 266);
		_leftEye.animation.add("default", blinkyAnimation([0, 3], [6]), 3);
		_leftEye.animation.add("0", blinkyAnimation([0, 3], [6]), 3);
		_leftEye.animation.add("1", blinkyAnimation([12, 15], [6]), 3);
		_leftEye.animation.add("2", blinkyAnimation([18, 21], [6]), 3);
		_leftEye.animation.add("3", blinkyAnimation([24, 27], [6]), 3);
		_leftEye.animation.add("4", blinkyAnimation([30, 33], [6]), 3);
		_leftEye.animation.add("5", blinkyAnimation([36, 39]), 3);
		_leftEye.animation.add("cheer", blinkyAnimation([42, 45]), 3);
		_frontSprites.push(_leftEye);
		_leftEye.animation.play("default");
		addPart(_leftEye);

		_middleEye = new BouncySprite( -188 + 208 * 1, -54, 12, BOUNCE_DURATION, 0.16, _age);
		_middleEye.loadGraphic(AssetPaths.magn_eyes__png, true, 208, 266);
		_middleEye.animation.add("default", blinkyAnimation([1, 4], [7]), 3);
		_middleEye.animation.add("0", blinkyAnimation([1, 4], [7]), 3);
		_middleEye.animation.add("1", blinkyAnimation([13, 16], [7]), 3);
		_middleEye.animation.add("2", blinkyAnimation([19, 22], [7]), 3);
		_middleEye.animation.add("3", blinkyAnimation([25, 28], [7]), 3);
		_middleEye.animation.add("4", blinkyAnimation([31, 34], [7]), 3);
		_middleEye.animation.add("5", blinkyAnimation([37, 40]), 3);
		_middleEye.animation.add("cheer", blinkyAnimation([43, 46]), 3);
		_frontSprites.push(_middleEye);
		_middleEye.animation.play("default");
		addPart(_middleEye);

		_rightEye = new BouncySprite( -188 + 208 * 2, -54, 12, BOUNCE_DURATION, 0.16, _age);
		_rightEye.loadGraphic(AssetPaths.magn_eyes__png, true, 208, 266);
		_rightEye.animation.add("default", blinkyAnimation([2, 5], [8]), 3);
		_rightEye.animation.add("0", blinkyAnimation([2, 5], [8]), 3);
		_rightEye.animation.add("1", blinkyAnimation([14, 17], [8]), 3);
		_rightEye.animation.add("2", blinkyAnimation([20, 23], [8]), 3);
		_rightEye.animation.add("3", blinkyAnimation([26, 29], [8]), 3);
		_rightEye.animation.add("4", blinkyAnimation([32, 35], [8]), 3);
		_rightEye.animation.add("5", blinkyAnimation([38, 41]), 3);
		_rightEye.animation.add("cheer", blinkyAnimation([44, 47]), 3);
		_frontSprites.push(_rightEye);
		_rightEye.animation.play("default");
		addPart(_rightEye);

		_beadsFrontL = new BouncySprite( -188, -54, 12, BOUNCE_DURATION, 0.16, _age);
		_beadsFrontL.loadGraphic(AssetPaths.magnbeads_front_l__png, true, 312, 532);
		_frontSprites.push(_beadsFrontL);
		_beadsFrontL.visible = false;
		addVisualItem(_beadsFrontL);

		_beadsFrontC = new BouncySprite( -188, -54, 12, BOUNCE_DURATION, 0.16, _age);
		loadWideGraphic(_beadsFrontC, AssetPaths.magnbeads_front_c__png);
		_frontSprites.push(_beadsFrontC);
		_beadsFrontC.visible = false;
		addVisualItem(_beadsFrontC);

		_beadsFrontR = new BouncySprite( -188 + 312, -54, 12, BOUNCE_DURATION, 0.16, _age);
		_beadsFrontR.loadGraphic(AssetPaths.magnbeads_front_r__png, true, 312, 532);
		_frontSprites.push(_beadsFrontR);
		_beadsFrontR.visible = false;
		addVisualItem(_beadsFrontR);

		_arms = new BouncySprite( -188, -54, 14, BOUNCE_DURATION, 0.08, _age);
		loadWideGraphic(_arms, AssetPaths.magn_arms__png);
		_arms.animation.add("default", [0]);
		_arms.animation.add("0", [0]);
		_arms.animation.add("1", [1]);
		_arms.animation.add("2", [2]);
		_arms.animation.add("3", [3]);
		_arms.animation.add("4", [4]);
		_arms.animation.add("5", [5]);
		_frontSprites.push(_arms);
		addPart(_arms);

		_hat = new BouncySprite( -188 + 208, -54, 12, BOUNCE_DURATION, 0.16, _age);
		_hat.loadGraphic(AssetPaths.magn_hat__png, true, 208, 266);
		_frontSprites.push(_hat);
		addPart(_hat);

		_badge = new BouncySprite( -188, -54, 12, BOUNCE_DURATION, 0.16, _age);
		loadWideGraphic(_badge, AssetPaths.magn_badge__png);
		_frontSprites.push(_badge);
		addPart(_badge);

		_lightningLayer = new BouncySprite( -188, -54, 12, BOUNCE_DURATION, 0.16, _age);
		if (_interactive)
		{
			_lightningLayer.makeGraphic(624, 532, FlxColor.TRANSPARENT, false, "magnLightningLayer");
			// wipe out any previously cached graphic
			FlxSpriteUtil.fill(_lightningLayer, FlxColor.TRANSPARENT);

			{
				var j0:Float = FlxG.random.float(0, 10000);
				var j1:Float = FlxG.random.float(0, 10000);
				for (k in 0...3)
				{
					{
						var lightningLine = new LightningLine();
						lightningLine.lineWidth = 3;
						lightningLine.pushWave(j0 + k * 1024 / 24, j1 + k * 1024 / 6);
						_lightningLines.push(lightningLine);
					}
					{
						var lightningLine = new LightningLine();
						lightningLine.pushWave(j0 + k * 1024 / 24, j1 + k * 1024 / 6);
						_lightningLines.push(lightningLine);
					}
				}
			}
			_frontSprites.push(_lightningLayer);
			addVisualItem(_lightningLayer);
		}

		_cheer = new BouncySprite( -188, -54, 0, BOUNCE_DURATION, 0, _age);
		_cheer.loadGraphic(AssetPaths.magn_cheer__png, true, 624, 266);
		_cheer.animation.add("default", [0]);
		_cheer.animation.add("cheer", [1, 2, 1, 2, 0], 3, false);
		_frontSprites.push(_cheer);
		addVisualItem(_cheer);

		_bodyBack = new BouncySprite( -188 + 872, -54, 12, BOUNCE_DURATION, 0.16, _age);
		loadWideGraphic(_bodyBack, AssetPaths.magn_body_back__png);
		_backSprites.push(_bodyBack);
		_bodyBack.animation.add("default", [0]);
		_bodyBack.animation.add("rub-antenna-back", [0]);
		addPart(_bodyBack);

		_hatchBack = new BouncySprite( -188 + 872, -54, 12, BOUNCE_DURATION, 0.16, _age);
		_hatchBack.loadGraphic(AssetPaths.magn_hatch_back__png, true, 624, 266);
		_hatchBack.animation.add("default", [0]);
		_hatchBack.animation.add("closed", [0]);
		_hatchBack.animation.add("open", [1]);
		_backSprites.push(_hatchBack);
		addPart(_hatchBack);

		_buttonsBack = new BouncySprite( -188 + 872 + 208, -54, 12, BOUNCE_DURATION, 0.16, _age);
		if (_interactive)
		{
			_buttonsDirty = true;
			_buttonsBack.makeGraphic(208, 266, FlxColor.TRANSPARENT, true);
			_backSprites.push(_buttonsBack);
			_buttonsBack.visible = false;
			addPart(_buttonsBack);
		}

		_leverBack = new BouncySprite( -188 + 872 + 208, -54 + 133, 12, BOUNCE_DURATION, 0.16, _age);
		if (_interactive)
		{
			_leverBack.loadGraphic(MagnResource.lever, true, 208, 266);
			_backSprites.push(_leverBack);
			_leverBack.animation.add("default", [0]);
			if (PlayerData.magnMale)
			{
				_leverBack.animation.add("pull-lever", [0, 1, 2, 3, 4]);
			}
			else
			{
				_leverBack.animation.add("pull-lever", [0, 1, 2, 3]);
			}
			_leverBack.visible = false;
			addPart(_leverBack);
		}

		_portsBack = new BouncySprite( -188 + 872 + 208, -54 + 133, 12, BOUNCE_DURATION, 0.16, _age);
		if (_interactive)
		{
			_portsBack.loadGraphic(AssetPaths.magn_ports__png, true, 208, 266);
			_backSprites.push(_portsBack);
			_portsBack.visible = false;
			_portsBack.animation.add("default", [0]);
			_portsBack.animation.add("rub-small-port", [0]);
			_portsBack.animation.add("rub-small-port1", [0]);
			_portsBack.animation.add("finger-big-port", [0, 1, 2, 2, 2, 2]);
			addPart(_portsBack);
		}

		_beadsBackL = new BouncySprite( -188 + 872, -54, 12, BOUNCE_DURATION, 0.16, _age);
		_beadsBackL.loadGraphic(AssetPaths.magnbeads_back_l__png, true, 312, 532);
		_backSprites.push(_beadsBackL);
		_beadsBackL.visible = false;
		addVisualItem(_beadsBackL);

		_beadsBackC = new BouncySprite( -188 + 872, -54, 12, BOUNCE_DURATION, 0.16, _age);
		loadWideGraphic(_beadsBackC, AssetPaths.magnbeads_back_c__png);
		_backSprites.push(_beadsBackC);
		_beadsBackC.visible = false;
		addVisualItem(_beadsBackC);

		_beadsBackR = new BouncySprite( -188 + 872 + 312, -54, 12, BOUNCE_DURATION, 0.16, _age);
		_beadsBackR.loadGraphic(AssetPaths.magnbeads_back_r__png, true, 312, 532);
		_backSprites.push(_beadsBackR);
		_beadsBackR.visible = false;
		addVisualItem(_beadsBackR);

		_tailBack = new BouncySprite( -188 + 872, -54, 14, BOUNCE_DURATION, 0, _age);
		loadWideGraphic(_tailBack, AssetPaths.magn_tail_back__png);
		_backSprites.push(_tailBack);
		addPart(_tailBack);

		_hatBack = new BouncySprite( -188 + 872 + 208, -54, 12, BOUNCE_DURATION, 0.16, _age);
		_hatBack.loadGraphic(AssetPaths.magn_hat_back__png, true, 208, 266);
		_backSprites.push(_hatBack);
		addPart(_hatBack);

		// lightningLayerBack uses the same sprite graphic as lightningLayerFront
		_lightningLayerBack = new BouncySprite( -188 + 872, -54, 12, BOUNCE_DURATION, 0.16, _age);
		if (_interactive)
		{
			_lightningLayerBack.makeGraphic(624, 532, FlxColor.WHITE, false, "magnLightningLayer");
			_backSprites.push(_lightningLayerBack);
			addVisualItem(_lightningLayerBack);
		}

		_interact = new BouncySprite( -54, -54, 0, 0, 0, 0);
		if (_interactive)
		{
			reinitializeHandSprites();
			add(_interact);
		}

		_whiteZapLayer = new FlxSprite(0, 0);
		if (_interactive)
		{
			_whiteZapLayer.makeGraphic(Std.int(width), Std.int(height), FlxColor.WHITE, false);
			_whiteZapLayer.alpha = 0;
			add(_whiteZapLayer);
		}

		// randomize bead state
		_beadsFrontL.animation.frameIndex = FlxG.random.int(0, 4);
		_beadsBackR.animation.frameIndex = _beadsFrontL.animation.frameIndex;
		_beadsFrontC.animation.frameIndex = FlxG.random.int(0, 4);
		_beadsBackC.animation.frameIndex = _beadsFrontC.animation.frameIndex;
		_beadsFrontR.animation.frameIndex = FlxG.random.int(0, 4);
		_beadsBackL.animation.frameIndex = _beadsFrontR.animation.frameIndex;

		setNudity(PlayerData.level);
	}

	override public function cheerful():Void
	{
		super.cheerful();

		_leftEye.animation.play("cheer");
		_middleEye.animation.play("cheer");
		_rightEye.animation.play("cheer");
		_cheer.animation.play("cheer");
	}

	public function setHatchOpen(hatchOpen:Bool):Void
	{
		if (hatchOpen != this._hatchOpen)
		{
			SoundStackingFix.play(hatchOpen ?
			FlxG.random.getObject([AssetPaths.magn_lever_0063_top_slowa__mp3, AssetPaths.magn_lever_0063_top_slowb__mp3]) :
			FlxG.random.getObject([AssetPaths.magn_lever_0063_bot_slowa__mp3, AssetPaths.magn_lever_0063_bot_slowb__mp3]), 0.8);
		}
		this._hatchOpen = hatchOpen;
		if (_hatchOpen)
		{
			_hatch.animation.play("open");
			_hatchBack.animation.play("open");
			_buttonsBack.visible = true;
			_leverBack.visible = true;
			_portsBack.visible = true;
		}
		else {
			_hatch.animation.play("closed");
			_hatchBack.animation.play("closed");
			_buttonsBack.visible = false;
			_leverBack.visible = false;
			_portsBack.visible = false;
		}
		updateRearBeads();
	}

	override public function arrangeArmsAndLegs()
	{
		playNewAnim(_arms, ["0", "1", "2", "3", "4", "5"]);
	}

	function loadWideGraphic(Sprite:BouncySprite, SimpleGraphic:FlxGraphicAsset)
	{
		Sprite.loadGraphic(SimpleGraphic, true, 624, 532);
	}

	public function cameraLeft(tweenDuration:Float = 0.3):Void
	{
		if (_cameraTween == null || !_cameraTween.active)
		{
			var scrollAmount:Int = -173;
			if (cameraPosition.x < -100 && cameraPosition.x >= -200)
			{
				// scroll from front to back
				scrollAmount = -(263 + 248 + 188);
				if (_backSprites[0].x > _frontSprites[0].x)
				{
					for (backSprite in _backSprites)
					{
						backSprite.x -= 872 * 2;
					}
				}
			}
			else if (cameraPosition.x > 200 || cameraPosition.x < -200)
			{
				// scroll from back to front
				scrollAmount = -(436 + 248 + 15);
				if (_frontSprites[0].x > _backSprites[0].x)
				{
					for (frontSprite in _frontSprites)
					{
						frontSprite.x -= 872 * 2;
					}
				}
			}
			scrollCamera(scrollAmount, tweenDuration);
		}
	}

	public function cameraRight(tweenDuration:Float = 0.3):Void
	{
		if (_cameraTween == null || !_cameraTween.active)
		{
			var scrollAmount:Int = 173;
			if (cameraPosition.x > 100 && cameraPosition.x <= 200)
			{
				// scroll from front to back
				scrollAmount = 263 + 248 + 188;
				if (_backSprites[0].x < _frontSprites[0].x)
				{
					for (backSprite in _backSprites)
					{
						backSprite.x += 872 * 2;
					}
				}
			}
			else if (cameraPosition.x > 200 || cameraPosition.x < -200)
			{
				// scroll from back to front
				scrollAmount = 436 + 248 + 15;
				if (_frontSprites[0].x < _backSprites[0].x)
				{
					for (frontSprite in _frontSprites)
					{
						frontSprite.x += 872 * 2;
					}
				}
			}
			scrollCamera(scrollAmount, tweenDuration);
		}
	}

	function scrollCamera(scrollAmount:Int, tweenDuration:Float = 0.3):Void
	{
		if (_cameraTween == null || !_cameraTween.active)
		{
			if (tweenDuration > 0)
			{
				for (member in _frontSprites)
				{
					FlxTween.tween(member, {x: member.x - scrollAmount}, tweenDuration, {ease:FlxEase.circOut});
				}
				for (member in _backSprites)
				{
					FlxTween.tween(member, {x: member.x - scrollAmount}, tweenDuration, {ease:FlxEase.circOut});
				}
				_cameraTween = FlxTween.tween(cameraPosition, {x: cameraPosition.x + scrollAmount}, tweenDuration, {ease:FlxEase.circOut, onComplete:centerCamera});
			}
			else
			{
				for (member in _frontSprites)
				{
					member.x -= scrollAmount;
				}
				for (member in _backSprites)
				{
					member.x -= scrollAmount;
				}
				cameraPosition.x += scrollAmount;
			}
		}
	}

	public function centerCamera(tween:FlxTween):Void
	{
		if (cameraPosition.x > 1000)
		{
			cameraPosition.x -= 1744;
		}
		else if (cameraPosition.x < -1000)
		{
			cameraPosition.x += 1744;
		}
	}

	override public function setNudity(NudityLevel:Int)
	{
		super.setNudity(NudityLevel);
		if (NudityLevel == 0)
		{
			MagnResource.chat = AssetPaths.magn_chat__png;
			_hatBack.visible = true;
			_hat.visible = true;
			_badge.visible = true;
		}
		if (NudityLevel == 1)
		{
			MagnResource.chat = AssetPaths.magn_chat__png;
			_hatBack.visible = true;
			_hat.visible = true;
			_badge.visible = false;
		}
		if (NudityLevel >= 2)
		{
			MagnResource.chat = AssetPaths.magn_chat_hatless__png;
			_hatBack.visible = false;
			_hat.visible = false;
			_badge.visible = false;
		}
	}

	override public function setArousal(Arousal:Int)
	{
		super.setArousal(Arousal);
		var animNames:Array<String> = ["0"];
		if (_arousal == 1)
		{
			animNames = ["1", "2"];
		}
		else if (_arousal == 2)
		{
			animNames = ["2", "3", "4"];
		}
		else if (_arousal == 3)
		{
			animNames = ["3", "4", "5"];
		}
		else if (_arousal == 4)
		{
			animNames = ["4", "5"];
		}
		else if (_arousal == 5)
		{
			animNames = ["5"];
		}
		if (_leftEye.animation.name != "cheer")
		{
			_leftEye.animation.play(FlxG.random.getObject(animNames));
		}
		if (_middleEye.animation.name != "cheer")
		{
			_middleEye.animation.play(FlxG.random.getObject(animNames));
		}
		if (_rightEye.animation.name != "cheer")
		{
			_rightEye.animation.play(FlxG.random.getObject(animNames));
		}
	}

	public function setEyeHappy(index:Int, happy:Bool)
	{
		var eyeSprite:FlxSprite = [_leftEye, _middleEye, _rightEye][index];
		if ((eyeSprite.animation.name == "cheer") == happy)
		{
			// expression is already what it should be
			return;
		}
		var animNames:Array<String> = ["0"];
		if (happy)
		{
			animNames = ["cheer"];
		}
		else if (_arousal == 1)
		{
			animNames = ["1", "2"];
		}
		else if (_arousal == 2)
		{
			animNames = ["2", "3", "4"];
		}
		else if (_arousal == 3)
		{
			animNames = ["3", "4", "5"];
		}
		else if (_arousal == 4)
		{
			animNames = ["4", "5"];
		}
		else if (_arousal == 5)
		{
			animNames = ["5"];
		}
		eyeSprite.animation.play(FlxG.random.getObject(animNames));
	}

	/*
	 * update rear beads to match the front
	 */
	public function updateRearBeads():Void
	{
		if (!_beadsFrontC.visible)
		{
			// beads are invisible; don't bother updating
			return;
		}
		_beadsBackR.animation.frameIndex = _beadsFrontL.animation.frameIndex;
		_beadsBackL.animation.frameIndex = _beadsFrontR.animation.frameIndex;
		if (!_hatchOpen)
		{
			_beadsBackC.animation.frameIndex = _beadsFrontC.animation.frameIndex;
		}
		else {
			// when the hatch opens, the rear beads use different graphics to go around the hatch
			_beadsBackC.animation.frameIndex = [4, 6, 4, 7, 4][_beadsFrontC.animation.frameIndex];
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (_interactive)
		{
			// crazy interactive lightning/button stuff; only applicable for sexy minigame

			for (i in 0..._buttonTouched.length)
			{
				_buttonTouched[i] -= elapsed;
			}

			_buttonRefreshTimer -= elapsed;
			if (_buttonRefreshTimer <= 0)
			{
				_buttonRefreshTimer = Math.max(0.444, _buttonRefreshTimer + 0.444);
				for (i in 0..._buttonTouched.length)
				{
					if (_buttonTouched[i] <= 0)
					{
						if (_untouchedButtonState[i] == 2)
						{
							_buttonLit[i] = !_buttonLit[i];
						}
						else
						{
							_buttonLit[i] = _untouchedButtonState[i] == 1;
						}
					}
				}
				_buttonsDirty = true;
			}

			_lightningTimer += elapsed;
			while (_lightningTimer > 0.09)
			{
				_lightningTimer -= 0.09;
				_lightningIndex += 3;
				_lightningDirty = true;
			}
			if (_lightningIntensityBoost > 0)
			{
				var boost = Math.min(48 * elapsed, _lightningIntensityBoost);
				_lightningIntensityBoost -= boost;
				_lightningIntensity += boost;
				// hard cap of 60
				_lightningIntensity = Math.min(_lightningIntensity, 60);
			}
			if (_lightningIntensity > 0)
			{
				if (_lightningIntensityBoost == 0)
				{
					_lightningIntensity -= 12 * elapsed;
					if (_lightningIntensity <= 0)
					{
						// clean up after intensity drops to zero
						_lightningDirty = true;
					}
				}
				if (_lightningIntensity > 36)
				{
					// too intense; sharply decrease intensity
					_lightningIntensity -= 12 * elapsed;
				}

				while (_lightningIndex > _lightningLines[0].xs.length * 2)
				{
					_lightningIndex -= _lightningLines[0].xs.length;
				}
				if (_lightningDirty)
				{
					FlxSpriteUtil.fill(_lightningLayer, FlxColor.TRANSPARENT);
					for (i in 0..._lightningLines.length)
					{
						var lightningLine = _lightningLines[i];
						if (lightningLine == null)
						{
							break;
						}
						lightningLine.draw(_lightningLayer, _lightningIndex, Math.round(_lightningIntensity) - 4 * Std.int(i / 2));
					}
					_lightningLayerBack.dirty = true;
					_lightningDirty = false;
				}
			}
		}
	}

	public function getSparkLocation(?index:Int = 0):FlxPoint
	{
		var x:Float = _lightningLines[0].xs[(_lightningIndex + Math.round(_lightningIntensity)) % _lightningLines[0].xs.length];
		var y:Float = _lightningLines[0].ys[(_lightningIndex + Math.round(_lightningIntensity)) % _lightningLines[0].ys.length];
		if (cameraPosition.x > 200)
		{
			x += 872;
		}
		else if (cameraPosition.x < -200)
		{
			x -= 872;
		}
		return FlxPoint.get(x + _lightningLayer.x, y + _lightningLayer.y);
	}

	public function makeAntennaBolt(?index:Int = 0):Void
	{
		makeBolt(100 + _antenna.x - _body.x + FlxG.random.float( -10, 10), 76 + _antenna.y - _body.y + FlxG.random.float( -10, 10), index);
		if (_whiteZapLayer.alpha < 0.3)
		{
			_whiteZapLayer.alpha = 0.3;
			_whiteZapTween = FlxTweenUtil.retween(_whiteZapTween, _whiteZapLayer, {alpha:0}, 0.1);
		}
	}

	public function makeBigAntennaBolt(?index:Int = 0):Void
	{
		makeBigBolt(100 + _antenna.x - _body.x + FlxG.random.float( -10, 10), 76 + _antenna.y - _body.y + FlxG.random.float( -10, 10), index);
		_whiteZapLayer.alpha = 0.9;
		_whiteZapTween = FlxTweenUtil.retween(_whiteZapTween, _whiteZapLayer, {alpha:0}, 0.5);
	}

	public function makeBolt(x:Float = 0, y:Float = 0, ?index:Int = 0):Void
	{
		_lightningLines[index].pushBolt(_lightningIndex + Math.round(_lightningIntensity) - 4 * Std.int(index / 2), x, y);
	}

	public function makeBigBolt(x:Float = 0, y:Float = 0, ?index:Int = 0):Void
	{
		_lightningLines[index].pushBigBolt(_lightningIndex + Math.round(_lightningIntensity) - 4 * Std.int(index / 2), x, y);
	}

	override public function draw():Void
	{
		FlxSpriteUtil.fill(_canvas, _bgColor);

		if (_buttonsDirty)
		{
			FlxSpriteUtil.fill(_buttonsBack, FlxColor.TRANSPARENT);
			var tmpSprite:FlxSprite = new FlxSprite();
			for (i in 0...BUTTON_POSITIONS.length)
			{
				var buttonFieldName:String = "magn_button_" + BUTTON_RYG[i] + "_" + BUTTON_LCR[i] + "__png";
				var buttonGraphic:FlxGraphicAsset;
				#if reflection
				// Workaround for Haxe #6630; Reflect.field on public static inline return null.
				// https://github.com/HaxeFoundation/haxe/issues/6630
				buttonGraphic = REFLECTION_WORKAROUND[buttonFieldName];
				#else
				buttonGraphic = Reflect.field(AssetPaths, buttonFieldName);
				#end
				tmpSprite.loadGraphic(buttonGraphic, true, 24, 24);
				if (_buttonPushed[i] == true)
				{
					tmpSprite.animation.frameIndex += 1;
				}
				if (!_buttonLit[i])
				{
					tmpSprite.animation.frameIndex += 2;
				}
				_buttonsBack.stamp(tmpSprite, BUTTON_POSITIONS[i][0], BUTTON_POSITIONS[i][1]);
			}
			_buttonsDirty = false;
		}

		for (member in members)
		{
			if (member != null && member.visible)
			{
				_canvas.stamp(member, Std.int(member.x - member.offset.x - x), Std.int(member.y - member.offset.y - y));
			}
		}
		{
			// erase corner
			var poly:Array<FlxPoint> = [];
			poly.push(FlxPoint.get(_canvas.width - 44 - 34, 0));
			poly.push(FlxPoint.get(_canvas.width - 44, 34));
			poly.push(FlxPoint.get(_canvas.width, 34));
			poly.push(FlxPoint.get(_canvas.width, 0));
			poly.push(FlxPoint.get(_canvas.width - 44 - 34, 0));
			FlxSpriteUtil.drawPolygon(_canvas, poly, 0xFF80684E, null, {blendMode:BlendMode.ERASE});
			FlxDestroyUtil.putArray(poly);
		}

		#if !flash
		// BlendMode.ERASE is not supported by non-flash targets, so we manually erase the pixels
		// with a threshold() call
		_canvas.pixels.threshold(_canvas.pixels, _canvas.pixels.rect, new Point(0, 0), "==", 0xFF80684E);
		#end

		{
			// draw pentagon around character frame
			var poly:Array<FlxPoint> = [];
			poly.push(FlxPoint.get(1, 1));

			poly.push(FlxPoint.get(_canvas.width - 44 - 34 + 1, 1));
			poly.push(FlxPoint.get(_canvas.width - 44 - 1, 34 - 1));
			poly.push(FlxPoint.get(_canvas.width - 1, 34 - 1));

			poly.push(FlxPoint.get(_canvas.width - 1, _canvas.height - 1));
			poly.push(FlxPoint.get(1, _canvas.height - 1));
			poly.push(FlxPoint.get(1, 1));
			FlxSpriteUtil.drawPolygon(_canvas, poly, FlxColor.TRANSPARENT, { thickness: 2 });
			FlxDestroyUtil.putArray(poly);

			// corner looks skimpy when drawing "pixel style" so fatten it up
			FlxSpriteUtil.drawLine(_canvas, _canvas.width - 44 - 34, 0, _canvas.width - 44 - 2, 34 - 2, {thickness:3, color:FlxColor.BLACK});
		}

		_canvas.pixels.setPixel32(0, 0, 0x00000000);
		_canvas.pixels.setPixel32(0, Std.int(_canvas.height-1), 0x00000000);
		_canvas.pixels.setPixel32(Std.int(_canvas.width-1), Std.int(_canvas.height-1), 0x00000000);
		_canvas.draw();
	}

	public function getClosestPanelButton(x:Int, y:Int)
	{
		var minDist:Float = 12;
		var closestButtonIndex:Int = -1;
		var point0 = FlxPoint.get(x - _buttonsBack.x + _buttonsBack.offset.x - 12, y - _buttonsBack.y + _buttonsBack.offset.y - 12);
		var point1 = FlxPoint.get();
		for (i in 0...BUTTON_POSITIONS.length)
		{
			point1.set(BUTTON_POSITIONS[i][0], BUTTON_POSITIONS[i][1]);
			var dist:Float = point0.distanceTo(point1);
			if (dist < minDist)
			{
				minDist = dist;
				closestButtonIndex = i;
			}
		}
		point0.put();
		point1.put();
		return closestButtonIndex;
	}

	public function pushPanelButton(buttonIndex:Int)
	{
		_buttonTouched[buttonIndex] = _buttonDurations[buttonIndex];
		_buttonPushed[buttonIndex] = true;
		_buttonLit[buttonIndex] = !_buttonLit[buttonIndex];
		_buttonsDirty = true;
	}

	/**
	 * @return 2 if any new buttons were mashed; 1 if any new buttons were released; 0 otherwise
	 */
	public function mashPanelButtons(x:Float, y:Float):Int
	{
		var point0 = FlxPoint.get(x - _buttonsBack.x + _buttonsBack.offset.x - 12, y - _buttonsBack.y + _buttonsBack.offset.y - 12);
		var point1 = FlxPoint.get();
		var result:Int = 0;
		for (i in 0...BUTTON_POSITIONS.length)
		{
			point1.set(BUTTON_POSITIONS[i][0], BUTTON_POSITIONS[i][1]);
			var dist:Float = point0.distanceTo(point1);
			if (dist < 15)
			{
				if (_buttonPushed[i] == false)
				{
					pushPanelButton(i);
					result = Std.int(Math.max(2, result));
				}
				else
				{
					_buttonTouched[i] = _buttonDurations[i];
				}
			}
			else if (dist >= 18)
			{
				if (_buttonPushed[i] == true)
				{
					releasePanelButton(i);
					result = Std.int(Math.max(1, result));
				}
			}
		}
		point0.put();
		point1.put();
		return result;
	}

	public function releasePanelButton(buttonIndex:Int)
	{
		_buttonTouched[buttonIndex] = _buttonDurations[buttonIndex];
		_buttonPushed[buttonIndex] = false;
		_buttonsDirty = true;
	}

	/**
	 * intensity is a number between 8-30 corresponding to how long the electric shock should last
	 */
	public function emitLightning(intensity:Float)
	{
		_lightningIntensityBoost = FlxMath.bound(_lightningIntensityBoost + intensity, 0, 60);
	}

	/**
	 * Trigger some sort of animation or behavior based on a dialog sequence
	 *
	 * @param	str the special dialog which might trigger an animation or behavior
	 */
	override public function doFun(str:String)
	{
		super.doFun(str);
		if (str == "camera-right-fast")
		{
			if (_cameraTween != null && _cameraTween.active)
			{
				// ignore; camera is busy
			}
			else
			{
				cameraRight(0);
			}
		}
		if (str == "open-hatch")
		{
			setHatchOpen(true);
		}
	}

	public function setBeadsVisible(beadsVisible:Bool)
	{
		_beadsFrontC.visible = beadsVisible;
		_beadsFrontL.visible = beadsVisible;
		_beadsFrontR.visible = beadsVisible;
		_beadsBackL.visible = beadsVisible;
		_beadsBackC.visible = beadsVisible;
		_beadsBackR.visible = beadsVisible;
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		CursorUtils.initializeCustomHandBouncySprite(_interact, AssetPaths.magn_interact__png, 208, 266);
		if (PlayerData.magnMale)
		{
			_interact.animation.add("pull-lever", [0, 1, 2, 3, 4]);
		}
		else
		{
			_interact.animation.add("pull-lever", [23, 29, 35, 41]);
		}
		_interact.animation.add("rub-small-port", [9, 6, 7]);
		_interact.animation.add("rub-small-port1", [9, 6, 8]);
		_interact.animation.add("finger-big-port", [12, 13, 14, 15, 16, 17]);
		_interact.animation.add("rub-left-screw", [18, 19, 20, 21]);
		_interact.animation.add("rub-right-screw", [24, 25, 26, 27]);
		_interact.animation.add("rub-antenna", [30, 31, 32, 33]);
		_interact.animation.add("rub-antenna-back", [36, 37, 38, 39, 40]);
		_interact.visible = false;
	}

	override public function destroy():Void
	{
		super.destroy();

		_frontSprites = FlxDestroyUtil.destroyArray(_frontSprites);
		_backSprites = FlxDestroyUtil.destroyArray(_backSprites);
		_hatch = FlxDestroyUtil.destroy(_hatch);
		_tail = FlxDestroyUtil.destroy(_tail);
		_leftScrew = FlxDestroyUtil.destroy(_leftScrew);
		_rightScrew = FlxDestroyUtil.destroy(_rightScrew);
		_antenna = FlxDestroyUtil.destroy(_antenna);
		_body = FlxDestroyUtil.destroy(_body);
		_leftEye = FlxDestroyUtil.destroy(_leftEye);
		_middleEye = FlxDestroyUtil.destroy(_middleEye);
		_rightEye = FlxDestroyUtil.destroy(_rightEye);
		_arms = FlxDestroyUtil.destroy(_arms);
		_hat = FlxDestroyUtil.destroy(_hat);
		_badge = FlxDestroyUtil.destroy(_badge);
		_cheer = FlxDestroyUtil.destroy(_cheer);
		_beadsFrontL = FlxDestroyUtil.destroy(_beadsFrontL);
		_beadsFrontC = FlxDestroyUtil.destroy(_beadsFrontC);
		_beadsFrontR = FlxDestroyUtil.destroy(_beadsFrontR);
		_beadsBackL = FlxDestroyUtil.destroy(_beadsBackL);
		_beadsBackC = FlxDestroyUtil.destroy(_beadsBackC);
		_beadsBackR = FlxDestroyUtil.destroy(_beadsBackR);
		_lightningLayer = FlxDestroyUtil.destroy(_lightningLayer);
		_whiteZapLayer = FlxDestroyUtil.destroy(_whiteZapLayer);
		_whiteZapTween = FlxTweenUtil.destroy(_whiteZapTween);
		_lightningLines = FlxDestroyUtil.destroyArray(_lightningLines);
		_bodyBack = FlxDestroyUtil.destroy(_bodyBack);
		_tailBack = FlxDestroyUtil.destroy(_tailBack);
		_hatBack = FlxDestroyUtil.destroy(_hatBack);
		_hatchBack = FlxDestroyUtil.destroy(_hatchBack);
		_buttonsBack = FlxDestroyUtil.destroy(_buttonsBack);
		_leverBack = FlxDestroyUtil.destroy(_leverBack);
		_portsBack = FlxDestroyUtil.destroy(_portsBack);
		_lightningLayerBack = FlxDestroyUtil.destroy(_lightningLayerBack);
		_cameraTween = FlxTweenUtil.destroy(_cameraTween);
	}

	public static function eventEmitSpark(args:Array<Dynamic>)
	{
		var emitter:FlxTypedEmitter<LateFadingFlxParticle> = args[0];
		var sparkX:Float = args[1];
		var sparkY:Float = args[2];
		MagnWindow.emitSpark(emitter, sparkX, sparkY);
	}

	public static function emitSpark(emitter:FlxTypedEmitter<LateFadingFlxParticle>, x:Float, y:Float)
	{
		emitter.setPosition(x, y);
		emitter.start(true, 0, 1);
		for (i in 0...8)
		{
			var particle:LateFadingFlxParticle = emitter.emitParticle();
			particle.enableLateFade(2);
			if (i % 8 < 4)
			{
				particle.velocity.x *= 0.5;
				particle.velocity.y *= 0.5;
			}
			if (i % 4 < 2)
			{
				particle.velocity.x *= -1;
			}
			if (i % 2 < 1)
			{
				particle.velocity.y *= -1;
			}
		}
		emitter.emitting = false;
	}
}