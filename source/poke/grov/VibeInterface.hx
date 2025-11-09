package poke.grov;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter.FlxEmitterMode;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import kludge.FlxSoundKludge;
import kludge.LateFadingFlxParticle;
import openfl.display.BlendMode;
import openfl.geom.Point;
import poke.magn.MagnWindow;
import poke.sexy.RandomPolygonPoint;
import poke.sexy.SexyState;

/**
 * The window on the left side which lets the player press buttons on the
 * vibrator
 *
 * This handles both the default vibrator and the electric vibrator
 */
class VibeInterface extends FlxSpriteGroup
{
	static var BUTTON_POSITIONS:Array<FlxPoint> = [
				FlxPoint.get(61, 133), FlxPoint.get(107, 135),
				FlxPoint.get(45, 172), FlxPoint.get(62, 195),
				FlxPoint.get(92, 194), FlxPoint.get(118, 176)
			];

	static var ELECTRIC_BUTTON_POSITIONS:Array<FlxPoint> = [
				FlxPoint.get(68, 108), FlxPoint.get(126, 116),
				FlxPoint.get(61, 142), FlxPoint.get(58, 181),
				FlxPoint.get(127, 188), FlxPoint.get(130, 150),
				FlxPoint.get(94, 153)
			];

	private var canvas:FlxSprite;
	private var bgSprite:FlxSprite;
	private var bodySprite:FlxSprite;
	private var buttonsSprite:FlxSprite;
	private var elecSprite:FlxSprite;
	private var vibe:Vibe;
	private var electric:Bool = false;

	public var buttonDuration:Float = 0;
	/*
	 * If lightningButtonDuration is greater than 0, the lightning button was
	 * just released after being held for this many seconds
	 */
	public var lightningButtonDuration:Float = 0;

	public var smallSparkEmitter:FlxTypedEmitter<LateFadingFlxParticle>;
	public var largeSparkEmitter:FlxTypedEmitter<LateFadingFlxParticle>;
	private var elecSound:FlxSound;

	public function new(vibe:Vibe)
	{
		super();
		this.vibe = vibe;
		bgSprite = new FlxSprite(0, -150);
		bgSprite.loadGraphic(AssetPaths.vibe_iface_bg__png, true, 253, 426);
		add(bgSprite);

		bodySprite = new BouncySprite(50, -31, 3, 5.5, 0);
		bodySprite.loadGraphic(AssetPaths.vibe_remote__png);
		add(bodySprite);

		buttonsSprite = new BouncySprite(50, -31, 3, 5.5, 0);
		buttonsSprite.loadGraphic(AssetPaths.vibe_remote_buttons__png, true, 180, 240);
		add(buttonsSprite);

		elecSprite = new BouncySprite(50, -31, 3, 5.5, 0);
		elecSprite.loadGraphic(AssetPaths.elecvibe_remote_charged__png);
		elecSprite.visible = false;
		elecSprite.alpha = 0;
		add(elecSprite);

		canvas = new FlxSprite(3, 123);
		canvas.makeGraphic(254, 250, FlxColor.TRANSPARENT, true);
	}

	public function setElectric(electric:Bool)
	{
		this.electric = electric;
		elecSprite.visible = electric;
		if (electric)
		{
			bgSprite.loadGraphic(AssetPaths.elecvibe_iface_bg__png, true, 253, 426);
			bodySprite.loadGraphic(AssetPaths.elecvibe_remote__png);
			buttonsSprite.loadGraphic(AssetPaths.elecvibe_remote_buttons__png, true, 180, 240);

			if (smallSparkEmitter == null)
			{
				// initialize spark emitters

				smallSparkEmitter = new FlxTypedEmitter<LateFadingFlxParticle>(0, 0, 24);
				smallSparkEmitter.launchMode = FlxEmitterMode.SQUARE;
				smallSparkEmitter.angularVelocity.set(0);
				smallSparkEmitter.velocity.set(200, 200);
				smallSparkEmitter.lifespan.set(0.3);
				for (i in 0...smallSparkEmitter.maxSize)
				{
					var particle:LateFadingFlxParticle = new LateFadingFlxParticle();
					particle.makeGraphic(3, 3, FlxColor.WHITE);
					particle.offset.x = 1.5;
					particle.offset.y = 1.5;
					particle.exists = false;
					smallSparkEmitter.add(particle);
				}

				largeSparkEmitter = new FlxTypedEmitter<LateFadingFlxParticle>(0, 0, 24);
				largeSparkEmitter.launchMode = FlxEmitterMode.SQUARE;
				largeSparkEmitter.angularVelocity.set(0);
				largeSparkEmitter.velocity.set(400, 400);
				largeSparkEmitter.lifespan.set(0.6);
				for (i in 0...largeSparkEmitter.maxSize)
				{
					var particle:LateFadingFlxParticle = new LateFadingFlxParticle();
					particle.makeGraphic(6, 6, FlxColor.WHITE);
					particle.offset.x = 2.5;
					particle.offset.y = 2.5;
					particle.exists = false;
					largeSparkEmitter.add(particle);
				}
			}
		}
	}

	/**
	 * Invoked when the lightning button is released
	 */
	public function doLightning(sexyState:SexyState<Dynamic>, electricPolyArray:Array<Array<FlxPoint>>):Void
	{
		var remainingIntensity:Float = lightningButtonDuration;
		remainingIntensity = FlxMath.bound(remainingIntensity, 0, 30);
		var eventTime:Float = sexyState.eventStack._time;

		var sparkChance:Int = 20;
		while (remainingIntensity > 0.2)
		{
			if (eventTime == sexyState.eventStack._time || FlxG.random.bool(sparkChance))
			{
				var sparkPoint:FlxPoint = RandomPolygonPoint.randomPolyPoint(electricPolyArray[sexyState._pokeWindow._dick.animation.frameIndex]);
				if (sparkPoint != null && remainingIntensity > 1)
				{
					sexyState.eventStack.addEvent({time:eventTime, callback:MagnWindow.eventEmitSpark, args:[largeSparkEmitter, sexyState._pokeWindow._dick.x + sparkPoint.x, sexyState._pokeWindow._dick.y + sparkPoint.y]});
				}
				else
				{
					sexyState.eventStack.addEvent({time:eventTime, callback:MagnWindow.eventEmitSpark, args:[smallSparkEmitter, sexyState._pokeWindow._dick.x + sparkPoint.x, sexyState._pokeWindow._dick.y + sparkPoint.y]});
				}
				sparkChance = 0;
			}
			else
			{
				if (remainingIntensity > 1)
				{
					sparkChance += 15;
				}
				else
				{
					sparkChance += 5;
				}
			}

			if (remainingIntensity > 1)
			{
				var sfxVolume:Float = 0;
				if (remainingIntensity > 4)
				{
					sfxVolume = FlxG.random.float(0.9, 1.0);
				}
				else if (remainingIntensity > 2)
				{
					sfxVolume = FlxG.random.float(0.8, 1.0);
				}
				else
				{
					sfxVolume = FlxG.random.float(0.6, 1.0);
				}
				sexyState.eventStack.addEvent({time:eventTime, callback:EventStack.eventPlaySound, args: [FlxG.random.getObject([AssetPaths.magn_zap__mp3, AssetPaths.magn_zap2__mp3, AssetPaths.magn_zap3__mp3]), sfxVolume]});
			}
			else
			{
				sexyState.eventStack.addEvent({time:eventTime, callback:EventStack.eventPlaySound, args: [FlxG.random.getObject([AssetPaths.magn_zap_small__mp3, AssetPaths.magn_zap_small2__mp3]), remainingIntensity]});
			}

			remainingIntensity = remainingIntensity * 0.8 - 0.04;
			eventTime += FlxG.random.float(0.01, 0.15);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (SexyState.toyMouseJustPressed())
		{
			var relativeMousePosition:FlxPoint = FlxPoint.get(FlxG.mouse.x - (buttonsSprite.x - buttonsSprite.offset.x) - canvas.x, FlxG.mouse.y - (buttonsSprite.y - buttonsSprite.offset.y) - canvas.y);

			var closestButtonIndex = -1;
			var closestButtonDist:Float = 23;
			var buttonPositions:Array<FlxPoint> = electric ? ELECTRIC_BUTTON_POSITIONS : BUTTON_POSITIONS;
			for (buttonIndex in 0...buttonPositions.length)
			{
				var buttonDist:Float = buttonPositions[buttonIndex].distanceTo(relativeMousePosition);
				if (electric)
				{
					if (buttonIndex >= 2 && buttonDist > 19)
					{
						// too far; buttons 0-1 are small
						continue;
					}
				}
				else
				{
					if (buttonIndex >= 2 && buttonDist > 19)
					{
						// too far; buttons 2-5 are small
						continue;
					}
				}
				if (buttonDist < closestButtonDist)
				{
					closestButtonDist = buttonDist;
					closestButtonIndex = buttonIndex;
				}
			}

			buttonsSprite.animation.frameIndex = closestButtonIndex + 1;
			if (closestButtonIndex >= 0)
			{
				SoundStackingFix.play(AssetPaths.click0_00cb__mp3, 1.0);
			}
			if (closestButtonIndex >= 0)
			{
				if (closestButtonIndex == 0)
				{
					if (vibe.vibeSfx.speed > 0)
					{
						vibe.vibeSfx.setSpeed(vibe.vibeSfx.speed - 1);
					}
				}
				if (closestButtonIndex == 1)
				{
					if (vibe.vibeSfx.speed < 5)
					{
						vibe.vibeSfx.setSpeed(vibe.vibeSfx.speed + 1);
					}
				}
				if (closestButtonIndex == 2)
				{
					vibe.vibeSfx.setMode(VibeSfx.VibeMode.Sine);
					if (vibe.vibeSfx.speed == 0)
					{
						vibe.vibeSfx.setSpeed(1);
					}
				}
				if (closestButtonIndex == 3)
				{
					vibe.vibeSfx.setMode(VibeSfx.VibeMode.Off);
					if (vibe.vibeSfx.speed == 0)
					{
						vibe.vibeSfx.setSpeed(1);
					}
				}
				if (closestButtonIndex == 4)
				{
					vibe.vibeSfx.setMode(VibeSfx.VibeMode.Sustained);
					if (vibe.vibeSfx.speed == 0)
					{
						vibe.vibeSfx.setSpeed(1);
					}
				}
				if (closestButtonIndex == 5)
				{
					vibe.vibeSfx.setMode(VibeSfx.VibeMode.Pulse);
					if (vibe.vibeSfx.speed == 0)
					{
						vibe.vibeSfx.setSpeed(1);
					}
				}
				if (closestButtonIndex == 6)
				{
					elecSound = SoundStackingFix.play(AssetPaths.elecvibe_charge__mp3, 0.3);
				}
			}
		}

		// reset lightningButtonDuration; it's only set briefly
		lightningButtonDuration = 0;

		if (buttonsSprite.animation.frameIndex != 0)
		{
			buttonDuration += elapsed;
		}
		else {
			buttonDuration = 0;
		}

		if (electric && buttonsSprite.animation.frameIndex == 7)
		{
			elecSprite.alpha = FlxMath.bound(buttonDuration / 1.6, 0, 1);
		}

		if (FlxG.mouse.justReleased)
		{
			if (electric && buttonsSprite.animation.frameIndex == 7)
			{
				// released lightning button
				lightningButtonDuration = buttonDuration;
				if (elecSound != null)
				{
					elecSound.stop();
					elecSprite.alpha = 0;
				}
			}
			if (buttonsSprite.animation.frameIndex != 0)
			{
				SoundStackingFix.play(AssetPaths.click1_00cb__mp3, 0.5);
			}
			buttonsSprite.animation.frameIndex = 0;
		}
	}

	override public function draw():Void
	{
		for (member in members)
		{
			if (member != null && member.visible)
			{
				canvas.stamp(member, Std.int(member.x - member.offset.x - x), Std.int(member.y - member.offset.y - y));
			}
		}

		// erase unused bits...
		{
			// bottom section...
			var poly:Array<FlxPoint> = [];
			poly.push(FlxPoint.get(0, 250));
			poly.push(FlxPoint.get(254, 250));
			poly.push(FlxPoint.get(254, 188 - 1));
			poly.push(FlxPoint.get(49, 250 - 1));
			poly.push(FlxPoint.get(0, 200 - 1));
			FlxSpriteUtil.drawPolygon(canvas, poly, 0xFF80684E, null, {blendMode:BlendMode.ERASE});
			FlxDestroyUtil.putArray(poly);
		}
		{
			// top section...
			var poly:Array<FlxPoint> = [];
			poly.push(FlxPoint.get(0, 0));
			poly.push(FlxPoint.get(254, 0));
			poly.push(FlxPoint.get(254, 42 + 1));
			poly.push(FlxPoint.get(200, 0 + 1));
			poly.push(FlxPoint.get(0, 100 + 1));
			FlxSpriteUtil.drawPolygon(canvas, poly, 0xFF80684E, null, {blendMode:BlendMode.ERASE});
			FlxDestroyUtil.putArray(poly);
		}

		#if !flash
		// BlendMode.ERASE is not supported by non-flash targets, so we manually erase the pixels
		// with a threshold() call
		canvas.pixels.threshold(canvas.pixels, canvas.pixels.rect, new Point(0, 0), "==", 0xFF80684E);
		#end

		// draw border...
		{
			var poly:Array<FlxPoint> = [];
			poly.push(FlxPoint.get(254 - 1, 42));
			poly.push(FlxPoint.get(254 - 1, 188 - 1));
			poly.push(FlxPoint.get(49, 250 - 1));
			poly.push(FlxPoint.get(1, 200 - 1));
			poly.push(FlxPoint.get(1, 100 + 1));
			poly.push(FlxPoint.get(1 + 200, 1));
			poly.push(FlxPoint.get(254 - 1, 42));
			FlxSpriteUtil.drawPolygon(canvas, poly, FlxColor.TRANSPARENT, { thickness: 2, color: FlxColor.BLACK });
			FlxDestroyUtil.putArray(poly);
		}

		canvas.draw();
	}

	public static function vibeString(mode:VibeSfx.VibeMode, speed:Int):String
	{
		return Std.string(mode) + Std.string(speed);
	}

	override public function destroy():Void
	{
		super.destroy();

		canvas = FlxDestroyUtil.destroy(canvas);
		bgSprite = FlxDestroyUtil.destroy(bgSprite);
		bodySprite = FlxDestroyUtil.destroy(bodySprite);
		buttonsSprite = FlxDestroyUtil.destroy(buttonsSprite);
		elecSprite = FlxDestroyUtil.destroy(elecSprite);
		smallSparkEmitter = FlxDestroyUtil.destroy(smallSparkEmitter);
		largeSparkEmitter = FlxDestroyUtil.destroy(largeSparkEmitter);
		elecSound = FlxDestroyUtil.destroy(elecSound);
	}
}