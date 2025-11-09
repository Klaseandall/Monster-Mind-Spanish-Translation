package;
import flixel.sound.FlxSound;
import flixel.sound.FlxSoundGroup;
import kludge.FlxSoundKludge;

/**
 * When 20 or 30 of something happens in a game (like 20 bugs jumping into clue
 * boxes) it's possible for the same sound to get played over and over, which
 * is OK. But if it's played 2, 3 or 10 times simultaneously it can result in a
 * 1,000% volume sound effect which is irritating.
 *
 * This class prevents sounds from stacking by keeping a list of recently
 * played sounds, and preventing those from playing for 20 milliseconds.
 */
class SoundStackingFix
{
	private static var SOUND_SWALLOW_THRESHOLD_MS:Int = 20;
	private static var lastPlayedMap:Map<String, Float> = new Map<String, Float>();

	private function new()
	{
	}

	public static function play(EmbeddedSound:String, Volume:Float = 1, Looped:Bool = false, ?Group:FlxSoundGroup,
								AutoDestroy:Bool = true, ?OnComplete:Void->Void):FlxSound
	{
		var now:Float = MmTools.time();
		if (lastPlayedMap[EmbeddedSound] > now)
		{
			/*
			 * clock has been messed with; we reset the sfx time to avoid a
			 * scenario where the user sets the clock into the future and back,
			 * and then no sfx ever play again
			 */
			lastPlayedMap[EmbeddedSound] = 0;
		}
		if (lastPlayedMap[EmbeddedSound] >= now - 20)
		{
			// don't play sound; sound played too recently
		}
		else {
			lastPlayedMap[EmbeddedSound] = now;
			return FlxSoundKludge.play(EmbeddedSound, Volume, Looped, Group, AutoDestroy, OnComplete);
		}
		return null;
	}
}