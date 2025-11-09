package;
import haxe.Timer;

/**
 * A collection of utility functions for MonsterMind
 */
class MmTools
{
	/**
	 * Returns the system time in milliseconds.
	 *
	 * This is intended as a cross-platform replacement for ActionScript's Date.getTime() method.
	 */
	public static inline function time():Float
	{
		return Timer.stamp() * 1000;
	}
}