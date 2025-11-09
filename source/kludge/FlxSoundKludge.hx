package kludge;
import flash.media.SoundTransform;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.sound.FlxSoundGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxDestroyUtil;
import openfl.Assets;
import openfl.events.Event;
import openfl.media.Sound;
import openfl.media.SoundChannel;

/**
 * Workaround for seamless sound looping in Flash.
 *
 * The built in FlxSound class can not loop sound seamlessly, it has a
 * noticable pause on each loop. We can work around this for Flash with a
 * custom class, although there is still an unavoidable pause for HTML5 and
 * Windows targets.
 */
class FlxSoundKludge implements IFlxDestroyable
{
	public var soundAsset:String;
	public var _sound:Sound;
	public var _channel:SoundChannel;
	public var _transform:SoundTransform = new SoundTransform();
	public var fadeSeconds:Float = 0;

	/**
	 * Internal tracker for volume.
	 */
	private var _volume:Float = 0;

	/**
	 * Set volume to a value between 0 and 1 to change how this sound is.
	 */
	public var volume(get, set):Float;
	private var _volumeTween:FlxTween;
	private var _volumeWarbleTween0:FlxTween;
	private var maxVolume:Float = 0;
	private var pulseOnDuration:Float = 0;

	public function new(soundAsset:String, fadeSeconds:Float)
	{
		this.soundAsset = soundAsset;
		this.fadeSeconds = fadeSeconds;
	}

	private function playLooped()
	{
		if (_sound == null)
		{
			_sound = Assets.getSound(soundAsset, true);
		}
		if (_channel == null)
		{
			_channel = _sound.play(0, 9999999);
		}
	}

	public function fadeIn(maxVolume:Float)
	{
		cancelVibeTweens();

		this.maxVolume = maxVolume;

		if (_sound == null)
		{
			// sound wasn't playing; create new sound object
			playLooped();
			set_volume(0);
		}

		_volumeTween = FlxTweenUtil.retween(_volumeTween, this, {volume:maxVolume}, fadeSeconds);
	}

	/**
	 * @param period How many seconds it takes to warble
	 */
	public function sustained(period:Float)
	{
		cancelVibeTweens();

		_volumeTween = FlxTweenUtil.retween(_volumeTween, this, {volume:maxVolume}, fadeSeconds);
		_volumeWarbleTween0 = FlxTweenUtil.retween(_volumeWarbleTween0, this, {volume:maxVolume * 0.85}, period, {startDelay:fadeSeconds, type:FlxTweenType.PINGPONG});
	}

	/**
	 * @param period How many seconds it takes for a full cycle
	 */
	public function sine(period:Float)
	{
		cancelVibeTweens();

		_volumeTween = FlxTweenUtil.retween(_volumeTween, this, {volume:maxVolume * 0.15}, fadeSeconds);
		_volumeWarbleTween0 = FlxTweenUtil.retween(_volumeWarbleTween0, this, {volume:maxVolume}, period, {startDelay:fadeSeconds, type:FlxTweenType.PINGPONG, ease:FlxEase.sineInOut});
	}

	/**
	 * @param	on How long the sound is at maximum volume
	 * @param	off How long the sound is at minimum volume
	 */
	public function pulse(on:Float, off:Float)
	{
		cancelVibeTweens();
		this.pulseOnDuration = on;

		_volumeTween = FlxTweenUtil.retween(_volumeTween, this, {volume:maxVolume}, fadeSeconds, {type:FlxTweenType.LOOPING, loopDelay:on + off + fadeSeconds, onStart:schedulePulseOff});
	}

	private function schedulePulseOff(tween:FlxTween)
	{
		_volumeWarbleTween0 = FlxTweenUtil.retween(_volumeWarbleTween0, this, {volume:0}, fadeSeconds, {startDelay:pulseOnDuration + fadeSeconds});
	}

	private function cancelVibeTweens()
	{
		if (_volumeWarbleTween0 != null)
		{
			_volumeWarbleTween0.cancel();
			_volumeWarbleTween0 = null;
		}
	}

	public function fadeOut()
	{
		cancelVibeTweens();
		if (_volumeTween != null)
		{
			_volumeTween = FlxTweenUtil.retween(_volumeTween, this, {volume:0}, fadeSeconds, {onComplete:stopCallback});
		}
	}

	private function stopCallback(tween:FlxTween)
	{
		stop();
	}

	private function stop()
	{
		if (_channel != null)
		{
			_channel.stop();
			_channel = null;
		}
		if (_sound != null)
		{
			_sound = null;
		}
		if (_transform != null)
		{
			_transform = null;
			_transform = new SoundTransform();
		}
	}

	private inline function get_volume():Float
	{
		return _volume;
	}

	private function set_volume(Volume:Float):Float
	{
		_volume = FlxMath.bound(Volume, 0, 1);
		updateTransform();
		return Volume;
	}

	/**
	 * Call after adjusting the volume to update the sound channel's settings.
	 */
	private function updateTransform():Void
	{
		_transform.volume =
		#if FLX_SOUND_SYSTEM
		(FlxG.sound.muted ? 0 : 1) * FlxG.sound.volume *
		#end
		_volume;

		if (_channel != null)
			_channel.soundTransform = _transform;
	}

	public function destroy()
	{
		_transform = null;

		if (_channel != null)
		{
			_channel.stop();
			_channel = null;
		}

		if (_sound != null)
		{
			_sound = null;
		}

		_volumeTween = FlxTweenUtil.destroy(_volumeTween);
		_volumeWarbleTween0 = FlxTweenUtil.destroy(_volumeWarbleTween0);
	}

	/**
	 * Plays a sound using FlxG.sound.play, but changes MP3 references to OGG as necessary
	 */
	public static function play(EmbeddedSound:String, Volume:Float = 1, Looped:Bool = false, ?Group:FlxSoundGroup,
								AutoDestroy:Bool = true, ?OnComplete:Void->Void):FlxSound
	{
		return FlxG.sound.play(fixPath(EmbeddedSound), Volume, Looped, Group, AutoDestroy, OnComplete);
	}

	/**
	 * Changes an MP3 path to an OGG path for non-flash platforms
	 */
	public static function fixPath(sfxPath:Dynamic)
	{
		#if !flash
		return StringTools.replace(sfxPath, ".mp3", ".ogg");
		#else
		return sfxPath;
		#end
	}
}