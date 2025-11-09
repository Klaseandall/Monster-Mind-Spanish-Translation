package;
import flixel.math.FlxMath;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import kludge.FlxSoundKludge;

/**
 * Controls the sound effects for the vibrator. The vibrator has several sound
 * effect modes which can be played and looped at different speeds.
 */
class VibeSfx implements IFlxDestroyable
{
	private var MAX_VOLUME:Float = 0.20;
	private var sounds:Array<FlxSoundKludge>;
	public var speed:Int = 0; // [0-5]
	public var mode:VibeMode = Off;

	public function new()
	{
		#if flash
		sounds = [
					 new FlxSoundKludge(AssetPaths.vibe0__wav, 0.300),
					 new FlxSoundKludge(AssetPaths.vibe1__wav, 0.227),
					 new FlxSoundKludge(AssetPaths.vibe2__wav, 0.173),
					 new FlxSoundKludge(AssetPaths.vibe3__wav, 0.132),
					 new FlxSoundKludge(AssetPaths.vibe4__wav, 0.100)
				 ];
		#else
		// non-flash targets do not support seamless looping of wavs, so we use longer samples
		// which will loop less frequently
		sounds = [
			new FlxSoundKludge(AssetPaths.vibe0_long__ogg, 0.300),
			new FlxSoundKludge(AssetPaths.vibe1_long__ogg, 0.227),
			new FlxSoundKludge(AssetPaths.vibe2_long__ogg, 0.173),
			new FlxSoundKludge(AssetPaths.vibe3_long__ogg, 0.132),
			new FlxSoundKludge(AssetPaths.vibe4_long__ogg, 0.100)
		];
		#end
	}

	/**
	 * @return 1.0 = vibrator is on; 0.3 = vibrator is at one third power, 0.0 = vibrator is off
	 */
	public function getVolumePct():Float
	{
		if (speed == 0)
		{
			return 0;
		}
		var totVolume:Float = 0;
		for (sound in sounds)
		{
			totVolume += sound.volume;
		}
		return FlxMath.bound(totVolume / MAX_VOLUME, 0, 1);
	}

	public function setSpeed(speed:Int)
	{
		if (this.speed == speed)
		{
			return;
		}
		this.speed = speed;

		updateSound();
	}

	public function setMode(mode:VibeMode)
	{
		if (this.mode == mode)
		{
			return;
		}
		this.mode = mode;

		updateSound();
	}

	public static var SINE_PERIODS:Array<Float> = [2.19, 1.76, 1.41, 1.13, 0.90];
	public static var WARBLE_PERIODS:Array<Float> = [1.28, 1.09, 0.93, 0.79, 0.67];
	public static var PULSE_PARAMS:Array<Array<Float>> = [
				[0.33, 1.3],
				[0.23, 0.8],
				[0.17, 0.5],
				[0.12, 0.3],
				[0.10, 0.2], // on; off
			];

	public function updateSound():Void
	{
		for (i in 0...sounds.length)
		{
			if (i != speed - 1)
			{
				sounds[i].fadeOut();
			}
		}

		if (speed > 0)
		{
			if (mode == Off)
			{
				sounds[speed - 1].fadeOut();
			}
			else
			{
				if (sounds[speed - 1]._sound == null)
				{
					sounds[speed - 1].fadeIn(MAX_VOLUME);
				}
				if (mode == Sine)
				{
					sounds[speed - 1].sine(SINE_PERIODS[speed - 1]);
				}
				else if (mode == Pulse)
				{
					sounds[speed - 1].pulse(PULSE_PARAMS[speed - 1][0], PULSE_PARAMS[speed - 1][1]);
				}
				else
				{
					sounds[speed - 1].sustained(WARBLE_PERIODS[speed - 1]);
				}
			}
		}
	}

	/**
	 * @return true if the vibrator is on; it might not be vibrating right now, but it's doing something.
	 */
	public function isVibratorOn():Bool
	{
		return mode != VibeSfx.VibeMode.Off && speed > 0;
	}

	/**
	 * @return true if the vibrator is vibrating a significant amount (at least 60% of max) at this exact moment
	 */
	public function isVibrating():Bool
	{
		return isVibratorOn() && getVolumePct() >= 0.6;
	}

	public function destroy():Void
	{
		sounds = FlxDestroyUtil.destroyArray(sounds);
	}
}

enum VibeMode
{
	Off;
	Sustained;
	Sine;
	Pulse;
}