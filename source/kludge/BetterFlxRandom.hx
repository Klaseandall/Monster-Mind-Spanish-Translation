package kludge;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;

/**
 * This works around some FlxRandom issues in 4.1.1. Some of these remain in
 * 4.2.0 but should be fixed in an upcoming HaxeFlixel release.
 */
class BetterFlxRandom
{
	/**
	 * Internal shared helper variable. Used by getObject().
	 */
	private static var _arrayFloatHelper:Array<Float> = null;

	/**
	 * FlxG.random.shuffle doesn't work for enum arrays.
	 */
	public static function shuffle<T>(arr:Array<T>):Array<T>
	{
		if (arr != null)
		{
			for (i in 0...arr.length)
			{
				var j = FlxG.random.int(0, arr.length - 1);
				var tmp = arr[i];
				arr[i] = arr[j];
				arr[j] = tmp;
			}
		}
		return arr;
	}

	/**
	 * FlxG.random.getObject() doesn't work. It always returns items from the
	 * start of the array regardless of StartIndex.
	 *
	 * WARNING: This implementation does not support WeightsArray.
	 *
	 * https://github.com/HaxeFlixel/flixel/issues/2009
	 */
	@:generic
	public static function getObject<T>(Objects:Array<T>, ?WeightsArray:Array<Float>, StartIndex:Int = 0, ?EndIndex:Null<Int>):T
	{
		var selected:Null<T> = null;

		if (Objects.length != 0)
		{
			if (EndIndex == null)
			{
				EndIndex = Objects.length - 1;
			}
			selected = Objects[FlxG.random.int(StartIndex, EndIndex)];
		}

		return selected;
	}

	/**
	 * Same functionality as getObject(Objects, WeightsArray) but using a map
	 */
	public static function getObjectWithMap<T>(map:Map<T, Float>)
	{
		var objects:Array<T> = [];
		var weights:Array<Float> = [];
		for (key in map.keys())
		{
			objects.push(key);
			weights.push(map[key]);
		}
		return FlxG.random.getObject(objects, weights);
	}
}