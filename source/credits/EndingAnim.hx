package credits;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import kludge.FlxSoundKludge;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * If the player swaps with abra, there's an animation of the camera zooming
 * out from their desk to their house to their neighborhood to earth and to
 * space and then zooming off into space.
 *
 * This class is responsible for that animation.
 */
class EndingAnim extends FlxState
{
	static var DESK_TIMING:Array<Float> = [
			0.80, // starts zooming out
			5.00, // fully zoomed out
			4.00, // starts rising
										  ];

	static var ZWOOSH_TIMING:Array<Float> = [
			3.35, // appears...
			3.45, // off to the right of the screen...
			4.00, // starts changing from < shape to = shape
			4.08, // finished changing to = shape
			4.35, // starts changing from = shape to > shape
			4.43, // finished changing to > shape
			5.45, // abra's appears...
			5.55, // off to the left edge of the screen...
			8.90, // to credits
											];

	var wispSfxTimer:Float = 0;
	var stateFunction:Float->Void;
	var stateTime:Float = 0;

	// sprites used while rising from desk
	var screenshot:FlxSprite;
	var desk:FlxSprite;
	var hand:FlxSprite;
	var ceiling:FlxSprite;

	// sprites used while zooming out in earth
	var cloud0:FlxSprite;
	var cloud1:FlxSprite;
	var cloud2:FlxSprite;

	var terrain0:FlxSprite;
	var terrain1:FlxSprite;
	var terrain2:FlxSprite;
	var terrain3:FlxSprite;
	var terrain4:FlxSprite;

	var stars0:FlxSprite;

	var wisp:FlxEmitter;
	var wispLine:WispLine;
	var abraWispLine:WispLine;
	var wispLayer:FlxSprite;
	var wispSfxVolume:Float = 0;
	var wispSfx:FlxSound;

	// sprites used during flyby
	var stars1:FlxSprite;

	public function new(screenshot:FlxSprite = null)
	{
		super();
		this.screenshot = screenshot;
	}

	private function addZoomySprite(graphic:FlxGraphicAsset):FlxSprite
	{
		var s:FlxSprite = new FlxSprite(0, 0);
		s.x = 384 / 2;
		s.y = 216 / 2;
		s.width = 0;
		s.height = 0;
		s.loadGraphic(graphic, true, 384, 216);
		return s;
	}

	override public function create():Void
	{
		Main.overrideFlxGDefaults();
		super.create();

		if (screenshot == null)
		{
			screenshot = new FlxSprite();
			screenshot.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		}
		else {
			var maskSprite:FlxSprite = new FlxSprite(0, 0);
			maskSprite.loadGraphic(AssetPaths.screenshot_mask__png);
			screenshot.stamp(maskSprite);
		}

		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;

		wisp = new FlxEmitter(0, 0, 30);
		wisp.launchMode = FlxEmitterMode.CIRCLE;
		wisp.acceleration.set(0);
		wisp.alpha.set(1.0, 1.0, 0, 0);
		wisp.lifespan.set(1.2);

		for (i in 0...wisp.maxSize)
		{
			var particle:FlxParticle = new FadeBlueParticle();
			particle.exists = false;
			wisp.add(particle);
		}

		wispLine = new WispLine();
		abraWispLine = new WispLine();

		wispLayer = new FlxSprite();
		wispLayer.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);

		initDeskZoomOut();
		setStateFunction(deskZoomOut);
	}

	private function setStateFunction(stateFunction:Float->Void)
	{
		this.stateFunction = stateFunction;
		this.stateTime = 0;

		/*
		 * invoke it once to assign things like scale, opacity... otherwise we
		 * might have one strange frame where everything's the wrong scale
		 */
		stateFunction(0);
	}

	private function initDeskZoomOut():Void
	{
		clear();

		desk = new FlxSprite(0, 0);
		desk.loadGraphic(AssetPaths.desk__png);
		desk.x = 0;
		desk.y = -desk.height + FlxG.height;
		desk.origin.x = 306;
		desk.origin.y = 1102;
		desk.scale.x = 2.33;
		desk.scale.y = 2.13;
		add(desk);

		screenshot.x = 0;
		screenshot.y = 0;
		screenshot.origin.x = 306;
		screenshot.origin.y = 34;
		screenshot.scale.x = 1.00;
		screenshot.scale.y = 1.00;
		add(screenshot);

		hand = new FlxSprite(0, 0);
		hand.loadGraphic(AssetPaths.desk_hand__png, true, 120, 120);
		hand.x = 574;
		hand.y = 312;
		hand.origin.x = desk.origin.x - 574;
		hand.origin.y = desk.origin.y - 1068 - 312;
		hand.scale.x = 2.33;
		hand.scale.y = 2.13;
		hand.animation.frameIndex = 0;
		add(hand);

		wisp.alpha.set(0.0, 0.0, 0.0, 0.0);
		wisp.start(false, 0.05);
		add(wisp);

		// wisp size...
		wisp.scale.set(60);
		wisp.speed.set(60, 120, 0, 0);

		ceiling = new FlxSprite(0, 0);
		ceiling.makeGraphic(1, 1, 0xff96896f);
		ceiling.origin.set(0, 0);
		ceiling.scale.x = FlxG.width;
		ceiling.scale.y = FlxG.height * 2;
		ceiling.y = -FlxG.height * 4;
		add(ceiling);
	}

	public function deskZoomOut(elapsed:Float)
	{
		if (stateTime <= DESK_TIMING[0])
		{
		}
		else if (stateTime > DESK_TIMING[0] && stateTime <= DESK_TIMING[1])
		{
			var f0 = FlxMath.bound((DESK_TIMING[1] - stateTime) / (DESK_TIMING[1] - DESK_TIMING[0]), 0, 1.0);
			f0 = Math.pow(f0, 2.2);
			var f1 = 1.0 - f0;

			desk.scale.x = 2.33 * f0 + 1.0 * f1;
			desk.scale.y = 2.13 * f0 + 1.0 * f1;
			hand.scale.x = 2.33 * f0 + 1.0 * f1;
			hand.scale.y = 2.13 * f0 + 1.0 * f1;
			screenshot.scale.x = 1.00 * f0 + 0.429 * f1;
			screenshot.scale.y = 1.00 * f0 + 0.469 * f1;
		}

		{
			var f0 = FlxMath.bound((3.5 - stateTime) / (3.5 - 1.5), 0, 1.0);
			var f1 = 1.0 - f0;

			var wispAlpha:Float = f0 * 0.0 + f1 * 1.0;
			wisp.alpha.set(wispAlpha, wispAlpha, 0.0, 0.0);

			var wispSize:Float = 500 * f0 + 60 * f1;
			wisp.scale.set(wispSize);
			wisp.speed.set(wispSize, wispSize * 2, 0, 0);

			if (wispAlpha == 0)
			{
				wispSfxVolume = 0;
			}
			else
			{
				wispSfxVolume = FlxMath.bound(wispAlpha, 0.2, 1.0);
			}
		}

		if (wispSfxVolume > 0)
		{
			wispSfxTimer -= elapsed;
			if (wispSfxTimer <= 0)
			{
				wispSfx = SoundStackingFix.play(AssetPaths.soul_sparkle_00ec__mp3, wispSfxVolume * FlxG.random.float(0.8, 1.0));
				wispSfxTimer += FlxG.random.float(1.5, 1.7);
			}
		}

		if (stateTime >= DESK_TIMING[2] + 0.8)
		{
			hand.animation.frameIndex = 1;
		}

		var risingVelocity:Float = FlxMath.bound((stateTime - DESK_TIMING[2]) * 20, 0, 1000) * elapsed;
		desk.y += risingVelocity;
		screenshot.y += risingVelocity;
		hand.y += risingVelocity;
		ceiling.y += risingVelocity * 1.6;

		// wisp position...
		wisp.x = 768 / 2 + Math.sin(stateTime * 2.1) * 60 + Math.sin(stateTime * 5.4 + 0.13) * 60;
		wisp.y = 432 / 2 + Math.cos(stateTime * 2.1) * 60 + Math.cos(stateTime * 5.4 + 0.13) * 60;

		if (desk.y > -150)
		{
			initEarthZoomOut();
			setStateFunction(earthZoomOut);
		}
	}

	private function initEarthZoomOut():Void
	{
		clear();

		stars0 = addZoomySprite(AssetPaths.stars__png);
		stars0.scale.x = 3;
		stars0.scale.y = 3;
		add(stars0);

		terrain3 = addZoomySprite(AssetPaths.zoom_out__png);
		terrain3.animation.frameIndex = 3;
		add(terrain3);

		terrain2 = addZoomySprite(AssetPaths.zoom_out__png);
		terrain2.animation.frameIndex = 2;
		add(terrain2);

		terrain1 = addZoomySprite(AssetPaths.zoom_out__png);
		terrain1.animation.frameIndex = 1;
		add(terrain1);

		terrain0 = addZoomySprite(AssetPaths.zoom_out__png);
		terrain0.animation.frameIndex = 0;
		add(terrain0);

		terrain4 = addZoomySprite(AssetPaths.zoom_out__png);
		terrain4.animation.frameIndex = 4;
		add(terrain4);

		cloud0 = addZoomySprite(AssetPaths.zoom_out_clouds__png);
		cloud0.animation.frameIndex = 0;
		add(cloud0);

		cloud1 = addZoomySprite(AssetPaths.zoom_out_clouds__png);
		cloud1.animation.frameIndex = 1;
		add(cloud1);

		cloud2 = addZoomySprite(AssetPaths.zoom_out_clouds__png);
		cloud2.animation.frameIndex = 2;
		add(cloud2);

		for (i in 0...wisp.length)
		{
			if (wisp.members[i] != null)
			{
				wisp.members[i].kill();
			}
		}
		add(wisp);
		wisp.alpha.set(0, 0, 0, 0);
		wisp.speed.set(60, 120, 0, 0);
		wisp.start(false, 0.05);

		add(wispLayer);
	}

	public function earthZoomOut(elapsed:Float):Void
	{
		var a:Float = stateTime * 7 - 20;

		if (wisp.alpha.start.min < 1.0)
		{
			wisp.alpha.set(wisp.alpha.start.min + elapsed * 2, wisp.alpha.start.min + elapsed * 2, 0.0, 0.0);
		}

		if (wispSfxVolume > 0)
		{
			wispSfxTimer -= elapsed;
			if (wispSfxTimer <= 0)
			{
				wispSfx = SoundStackingFix.play(AssetPaths.soul_sparkle_00ec__mp3, wispSfxVolume * FlxG.random.float(0.8, 1.0));
				wispSfxTimer += FlxG.random.float(1.5, 1.7);
			}
		}

		var zoomFactor:Float = 0;
		if (a < 58)
		{
			zoomFactor = a;
		}
		else {
			zoomFactor = 58 + (a - 58) * 0.3;
		}
		zoomFactor = FlxMath.bound(zoomFactor, -20, 63);

		var moveFactor:Float = 0;
		moveFactor = FlxMath.bound(a - 53, 0, 30) * 20;

		terrain4.scale.x = 2000 * Math.pow(0.9, zoomFactor);
		terrain4.scale.y = 16000 * Math.pow(0.9, zoomFactor) * Math.pow(0.95, Math.max(0, zoomFactor - 20));
		terrain4.alpha = FlxMath.bound((a - 15) / 63, 0, 0.6);

		terrain3.scale.x = 2000 * Math.pow(0.9, zoomFactor);
		terrain3.scale.y = 16000 * Math.pow(0.9, zoomFactor) * Math.pow(0.95, Math.max(0, zoomFactor - 20));

		terrain2.scale.x = 200 * Math.pow(0.9, zoomFactor);
		terrain2.scale.y = 400 * Math.pow(0.9, zoomFactor) * Math.pow(0.95, Math.max(0, zoomFactor - 20));

		terrain1.scale.x = 20 * Math.pow(0.9, zoomFactor);
		terrain1.scale.y = 20 * Math.pow(0.9, zoomFactor) * Math.pow(0.95, Math.max(0, zoomFactor - 20));

		cloud0.scale.x = 80 * Math.pow(0.9, zoomFactor);
		cloud0.scale.y = 80 * Math.pow(0.9, zoomFactor) * Math.pow(0.95, Math.max(0, zoomFactor - 20));
		cloud0.alpha = FlxMath.bound((a - 20) / 20, 0, 1.0);

		cloud1.scale.x = 800 * Math.pow(0.9, zoomFactor);
		cloud1.scale.y = 800 * Math.pow(0.9, zoomFactor) * Math.pow(0.95, Math.max(0, zoomFactor - 20));
		cloud1.alpha = FlxMath.bound((a - 35) / 20, 0, 1.0);

		cloud2.scale.x = 1600 * Math.pow(0.9, zoomFactor);
		cloud2.scale.y = 12800 * Math.pow(0.9, zoomFactor) * Math.pow(0.95, Math.max(0, zoomFactor - 20));
		cloud2.alpha = FlxMath.bound((a - 50) / 20, 0, 1.0);

		terrain0.scale.x = 2 * Math.pow(0.9, zoomFactor);
		terrain0.scale.y = 2 * Math.pow(0.9, zoomFactor) * Math.pow(0.95, Math.max(0, zoomFactor - 20));

		cloud0.y = (216 / 2) + moveFactor;
		cloud0.x = 4 * a;

		cloud1.y = (216 / 2) + moveFactor;
		cloud1.x = -2 * a;

		cloud2.y = (216 / 2) + moveFactor;
		cloud2.x = 2 * a;

		terrain0.y = (216 / 2) + moveFactor;
		terrain1.y = (216 / 2) + moveFactor;
		terrain2.y = (216 / 2) + moveFactor;
		terrain3.y = (216 / 2) + moveFactor;
		terrain4.y = (216 / 2) + moveFactor;

		stars0.y = (216 / 2) - 100 + moveFactor * 0.3;

		// wisp size...
		var wispSize = FlxMath.bound(60 * Math.pow(0.97, a), 8, 60);
		wisp.scale.set(wispSize);
		wisp.speed.set(wispSize, 2 * wispSize, 0, 0);

		// wisp position...
		wisp.x = 768 / 2 + Math.sin(a * 0.3) * wispSize + Math.sin((a + 0.17) * 0.77) * wispSize;
		wisp.y = 432 / 2 + Math.cos(a * 0.3) * wispSize + Math.cos((a + 0.17) * 0.77) * wispSize;

		if (a <= 92)
		{
			wispSfxVolume = FlxMath.bound(wispSize / 60, 0.2, 1.0);
		}

		if (a > 92 && wisp.emitting)
		{
			wisp.emitting = false;
			wispLine.set(wisp.x, wisp.y, 8, wisp.x + 200, wisp.y - 105, 0);
			wispLine.age = 0;
			wispSfxVolume = 0;
			FlxSoundKludge.play(AssetPaths.soul_zoom_00b9__mp3, 0.7);
		}

		if (a > 92)
		{
			FlxSpriteUtil.fill(wispLayer, FlxColor.TRANSPARENT);
			wispLine.update(elapsed);
			wispLine.draw(wispLayer);

			if (wispSfx != null)
			{
				wispSfx.volume -= elapsed;
			}
		}

		if (a > 102)
		{
			initFlyBy();
			setStateFunction(flyBy);
		}
	}

	private function initFlyBy():Void
	{
		clear();

		stars1 = new FlxSprite(0, 0);
		stars1.x = 384 / 2;
		stars1.y = 216 / 2;
		stars1.width = 0;
		stars1.height = 0;
		stars1.loadGraphic(AssetPaths.stars_flyby__png);
		stars1.scale.x = 2;
		stars1.scale.y = 2;
		add(stars1);

		FlxSpriteUtil.fill(wispLayer, FlxColor.TRANSPARENT);
		add(wispLayer);
		wispLine.age = 10000;
		abraWispLine.age = 10000;
	}

	public function flyBy(elapsed:Float):Void
	{
		if (stateTime >= ZWOOSH_TIMING[0] && stateTime - elapsed < ZWOOSH_TIMING[0])
		{
			wispSfx = SoundStackingFix.play(AssetPaths.soul_sparkle_00ec__mp3, 0.5);
		}
		if (stateTime >= ZWOOSH_TIMING[1] && stateTime - elapsed < ZWOOSH_TIMING[1])
		{
			FlxSoundKludge.play(AssetPaths.soul_zwoosh_00c2__mp3, 1.0);
		}
		if (stateTime <= ZWOOSH_TIMING[0])
		{
			stars1.x -= elapsed * 3;
		}
		else if (stateTime > ZWOOSH_TIMING[0])
		{
			if (stateTime >= ZWOOSH_TIMING[2] && stateTime <= ZWOOSH_TIMING[5])
			{
				stars1.x -= elapsed * 4000;
			}
			if (stateTime > ZWOOSH_TIMING[0] && stateTime <= ZWOOSH_TIMING[2])
			{
				var f0 = FlxMath.bound((ZWOOSH_TIMING[1] - stateTime) / (ZWOOSH_TIMING[1] - ZWOOSH_TIMING[0]), 0, 1.0);
				var f1 = 1.0 - f0;
				wispLine.set(246, 228, 0, f0 * 246 + f1 * 800, 229, f0 * 0 + f1 * 30);
				wispLine.age = 0;
			}
			else if (stateTime > ZWOOSH_TIMING[2] && stateTime <= ZWOOSH_TIMING[3])
			{
				var f0 = FlxMath.bound((ZWOOSH_TIMING[3] - stateTime) / (ZWOOSH_TIMING[3] - ZWOOSH_TIMING[2]), 0, 1.0);
				var f1 = 1.0 - f0;
				wispLine.set(f0 * 246 + f1 * -50, 228, f0 * 0 + f1 * 30, 800, 229, 30);
				wispLine.age = 0;
			}
			else if (stateTime > ZWOOSH_TIMING[3])
			{
				var f0 = FlxMath.bound((ZWOOSH_TIMING[5] - stateTime) / (ZWOOSH_TIMING[5] - ZWOOSH_TIMING[4]), 0, 1.0);
				var f1 = 1.0 - f0;
				wispLine.set( -50, 228, 30, f0 * 800 + f1 * 500, 229, f0 * 30 + f1 * 0);

				if (wispSfx != null) wispSfx.volume -= 0.2 * elapsed;
			}
			if (stateTime > ZWOOSH_TIMING[6])
			{
				if (stateTime - elapsed <= ZWOOSH_TIMING[6])
				{
					FlxSoundKludge.play(AssetPaths.soul_zwoosh_00c2__mp3, 0.5);
				}

				var f0 = FlxMath.bound((ZWOOSH_TIMING[7] - stateTime) / (ZWOOSH_TIMING[7] - ZWOOSH_TIMING[6]), 0, 1.0);
				var f1 = 1.0 - f0;
				abraWispLine.set( 500 * f0 - 50 * f1, 231 * f0 + 260 * f1, 0 * f0 + 30 * f1, 500, 231, 0);
				if (stateTime <= ZWOOSH_TIMING[7])
				{
					abraWispLine.age = 0;
				}
			}
			FlxSpriteUtil.fill(wispLayer, FlxColor.TRANSPARENT);
			wispLine.update(elapsed);
			abraWispLine.update(elapsed);
			wispLine.draw(wispLayer);
			abraWispLine.draw(wispLayer);
		}
		if (stateTime >= ZWOOSH_TIMING[8])
		{
			FlxG.switchState(new CreditsState());
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		stateTime += elapsed;

		stateFunction(elapsed);
	}

	override public function destroy():Void
	{
		super.destroy();

		stateFunction = null;
		screenshot = FlxDestroyUtil.destroy(screenshot);
		desk = FlxDestroyUtil.destroy(desk);
		hand = FlxDestroyUtil.destroy(hand);
		ceiling = FlxDestroyUtil.destroy(ceiling);

		cloud0 = FlxDestroyUtil.destroy(cloud0);
		cloud1 = FlxDestroyUtil.destroy(cloud1);
		cloud2 = FlxDestroyUtil.destroy(cloud2);

		terrain0 = FlxDestroyUtil.destroy(terrain0);
		terrain1 = FlxDestroyUtil.destroy(terrain1);
		terrain2 = FlxDestroyUtil.destroy(terrain2);
		terrain3 = FlxDestroyUtil.destroy(terrain3);
		terrain4 = FlxDestroyUtil.destroy(terrain4);

		stars0 = FlxDestroyUtil.destroy(stars0);

		wisp = FlxDestroyUtil.destroy(wisp);
		wispLine = FlxDestroyUtil.destroy(wispLine);
		abraWispLine = FlxDestroyUtil.destroy(abraWispLine);
		wispLayer = FlxDestroyUtil.destroy(wispLayer);
		wispSfx = FlxDestroyUtil.destroy(wispSfx);

		stars1 = FlxDestroyUtil.destroy(stars1);
	}

	public static function newInstance():EndingAnim
	{
		var screenshot = Screenshot.get();
		return new EndingAnim(screenshot);
	}
}