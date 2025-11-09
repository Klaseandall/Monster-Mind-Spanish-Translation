package;
import flixel.FlxG;
import flixel.math.FlxMath;

/**
 * A collection of utility methods related to sprite animations
 */
class AnimTools
{
	private function new()
	{}

	/**
	 * Creates a "blinky animation" made out of non-blink frames, with blink
	 * frames interspersed every 9-15 frames randomly
	 *
	 * This is used for bugs and for Pokemon
	 *
	 * @param	normalFrames normal frame indices (eyes open)
	 * @param	blinkFrames blink frame indices (eyes closed)
	 * @return an array of frame indices which look like someone blinking
	 */
	public static function blinkyAnimation(normalFrames:Array<Int>, ?blinkFrames:Array<Int>):Array<Int>
	{
		var anim:Array<Int> = [];
		push(anim, FlxG.random.int(9, 15), normalFrames);
		push(anim, 1, blinkFrames);
		push(anim, FlxG.random.int(9, 15), normalFrames);
		push(anim, 1, blinkFrames);
		push(anim, FlxG.random.int(9, 15), normalFrames);
		push(anim, 1, blinkFrames);
		var i:Int = FlxG.random.int(0, anim.length - 1);
		for (j in 0...i)
		{
			anim.insert(0, anim.pop());
		}
		return anim;
	}

	/**
	 * This is identical to the above blinkyAnimation() method, but for
	 * characters which blink less frequently
	 *
	 * @param	normalFrames normal frame indices (eyes open)
	 * @param	blinkFrames blink frame indices (eyes closed)
	 * @return an array of frame indices which look like someone blinking
	 */
	public static function slowBlinkyAnimation(normalFrames:Array<Int>, ?blinkFrames:Array<Int>):Array<Int>
	{
		var anim:Array<Int> = [];
		push(anim, FlxG.random.int(18, 30), normalFrames);
		push(anim, 1, blinkFrames);
		push(anim, FlxG.random.int(18, 30), normalFrames);
		push(anim, 1, blinkFrames);
		push(anim, FlxG.random.int(18, 30), normalFrames);
		push(anim, 1, blinkFrames);
		var i:Int = FlxG.random.int(0, anim.length - 1);
		for (j in 0...i)
		{
			anim.insert(0, anim.pop());
		}
		return anim;
	}

	/**
	 * Appends a random set of frames to an animation. This is intended to be
	 * used with a set of near-identical frames to create a "wiggly" effect
	 *
	 * @param	idleAnim animation frames to append to
	 * @param	howMany how many frames to append
	 * @param	array animation frames which should be appended
	 */
	public static function push(idleAnim:Array<Int>, howMany:Int, array:Array<Int>)
	{
		if (array == null || array.length == 0)
		{
			return;
		}
		var i:Int = 0;
		while (i < howMany)
		{
			idleAnim.push(array[FlxG.random.int(0, array.length - 1)]);
			i++;
		}
	}

	/**
	 * Shifts an animation a random number of frames. When a set of sprites all
	 * share the same animation, this makes it so they won't be 100% perfectly
	 * in sync -- some will start earlier, and some will start later
	 *
	 * @param	idleAnim animation frames to shift
	 */
	public static function shift(idleAnim:Array<Int>)
	{
		var idleAnimFragment:Array<Int> = idleAnim.splice(0, FlxG.random.int(0, idleAnim.length));
		for (i in 0...idleAnimFragment.length)
		{
			idleAnim.push(idleAnimFragment[i]);
		}
	}
}