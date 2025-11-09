package poke.grov;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * Defines vibrator behavior -- things like which graphics and sound effects
 * are active, and the shadow/blur effects
 */
class Vibe implements IFlxDestroyable
{
	public var vibeInteract:BouncySprite;
	public var vibeRemote:BouncySprite;
	public var dickVibe:BouncySprite; // dick with vibrator
	public var dickVibeBlur:BouncySprite;
	public var dick:BouncySprite;
	public var shadowVibe:BouncySprite;

	public var vibeSpeed:Float = 4.0;
	public var vibeTimer:Float = 0;
	/*
	 * Which vibrator frames correspond to which dick frames?
	 */
	public var dickFrameToVibeFrameMap:Map<Int, Array<Int>> = new Map<Int, Array<Int>>();
	public var vibeSfx:VibeSfx = new VibeSfx();
	private var vibeSpeeds:Array<Float> = [5.0, 6.7, 9, 12.3, 17];
	private var electric:Bool = false;

	public function new(dick:BouncySprite, X:Float, Y:Float)
	{
		this.dick = dick;
		this.dickVibe = new BouncySprite(X, Y, dick._bounceAmount, dick._bounceDuration, dick._bouncePhase, dick._age);
		dickVibe.visible = false;

		this.dickVibeBlur = new BouncySprite(X, Y, dick._bounceAmount, dick._bounceDuration, dick._bouncePhase, dick._age);
		dickVibeBlur.alpha = 0.5;
		dickVibeBlur.visible = false;

		this.vibeRemote = new BouncySprite(X, Y, dick._bounceAmount, dick._bounceDuration, dick._bouncePhase, dick._age);
		vibeRemote.loadWindowGraphic(AssetPaths.vibe_pokewindow__png);
		vibeRemote.visible = false;

		this.vibeInteract = new BouncySprite(X, Y, dick._bounceAmount, dick._bounceDuration, dick._bouncePhase, dick._age);

		this.shadowVibe = new BouncySprite(0, 0, 0, 0, 0, 0);
	}

	public function setElectric(electric:Bool)
	{
		this.electric = electric;
		if (electric)
		{
			vibeRemote.loadWindowGraphic(AssetPaths.elecvibe_pokewindow__png);
		}
		reinitializeHandSprites();
	}

	public function reinitializeHandSprites()
	{
		CursorUtils.initializeHandBouncySprite(vibeInteract, electric ? AssetPaths.elecvibe_interact__png : AssetPaths.vibe_interact__png);
		vibeInteract.visible = false;
	}

	public function loadDickGraphic(graphic:FlxGraphicAsset)
	{
		dickVibe.loadWindowGraphic(graphic);
		dickVibe.animation.frameIndex = 0;

		dickVibeBlur.loadWindowGraphic(graphic);
		dickVibeBlur.animation.frameIndex = 0;
	}

	public function setVisible(visible:Bool)
	{
		if (visible == true)
		{
			dickVibe.visible = true;
			dickVibeBlur.visible = true;
			vibeRemote.visible = true;
			vibeInteract.visible = true;

			var vibeFrames:Array<Int> = dickFrameToVibeFrameMap[dick.animation.frameIndex];
			if (vibeFrames != null)
			{
				dickVibe.animation.frameIndex = vibeFrames[0];
				dickVibeBlur.animation.frameIndex = vibeFrames[0];
			}
		}
		else
		{
			dickVibe.visible = false;
			dickVibeBlur.visible = false;
			vibeRemote.visible = false;
			vibeInteract.visible = false;
		}
	}

	public function update(elapsed:Float)
	{
		var vibeFrames:Array<Int> = dickFrameToVibeFrameMap[dick.animation.frameIndex];
		if (vibeSfx.speed == 0)
		{
			vibeSpeed = 0;
		}
		else
		{
			var calc:Float = vibeSpeeds[vibeSfx.speed - 1] * vibeSfx.getVolumePct();
			if (calc < 1.5)
			{
				vibeSpeed = 0;
			}
			else
			{
				vibeSpeed = FlxMath.bound(calc, 3, 60);
				vibeTimer = Math.min(vibeTimer, 1 / vibeSpeed);
			}
		}

		if (dickVibe.visible && vibeFrames != null)
		{
			dickVibeBlur.visible = vibeSpeed >= 8;
			if (vibeSpeed <= 2)
			{
				dickVibeBlur.animation.frameIndex = vibeFrames[0];
				dickVibe.animation.frameIndex = vibeFrames[0];
			}
			else
			{
				vibeTimer -= elapsed;
				if (vibeTimer <= 0)
				{
					vibeTimer = Math.max(0, vibeTimer + 1 / vibeSpeed);
					var vibeFramesTmp:Array<Int> = vibeFrames.slice(1);
					vibeFramesTmp.remove(dickVibe.animation.frameIndex);
					dickVibeBlur.animation.frameIndex = dickVibe.animation.frameIndex;
					dickVibe.animation.frameIndex = FlxG.random.getObject(vibeFramesTmp);
				}
			}
		}
	}

	public function destroy():Void
	{
		vibeInteract = FlxDestroyUtil.destroy(vibeInteract);
		vibeRemote = FlxDestroyUtil.destroy(vibeRemote);
		dickVibe = FlxDestroyUtil.destroy(dickVibe);
		dickVibeBlur = FlxDestroyUtil.destroy(dickVibeBlur);
		shadowVibe = FlxDestroyUtil.destroy(shadowVibe);
		dickFrameToVibeFrameMap = null;
		vibeSfx = FlxDestroyUtil.destroy(vibeSfx);
		vibeSpeeds = null;
	}

	/**
	 * Loads the "shadow vibe" which creates the illusion that female cum is
	 * leaking from the outside of the vagina
	 */
	public function loadShadow(blackGroup:BlackGroup, shadowAsset:FlxGraphicAsset):Void
	{
		if (blackGroup.members.indexOf(shadowVibe) == -1)
		{
			shadowVibe.loadGraphic(shadowAsset);
			blackGroup.add(shadowVibe);
			shadowVibe.synchronize(dickVibe);
			shadowVibe.x = dickVibe.x + 3;
			shadowVibe.y += 3;
		}
	}

	public function unloadShadow(blackGroup:BlackGroup):Void
	{
		if (blackGroup.members.indexOf(shadowVibe) != -1)
		{
			blackGroup.remove(shadowVibe);
		}
	}
}