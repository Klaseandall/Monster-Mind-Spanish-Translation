package;
import flixel.tweens.FlxTween;
import flixel.util.FlxDestroyUtil;

/**
 * Utility classes for working with FlxTwen objects
 */
class FlxTweenUtil
{
	/**
	 * You sometimes see artifacts when rapidly tweening back and forth. This "retween" method helps to avoid that.
	 */
	public static function retween(Tween:FlxTween, Object:Dynamic, Values:Dynamic, Duration:Float = 1, ?Options:TweenOptions):FlxTween
	{
		if (Tween != null)
		{
			Tween.cancel();
		}
		return FlxTween.tween(Object, Values, Duration, Options);
	}

	public static function cancel(Tween:FlxTween)
	{
		if (isActive(Tween))
		{
			Tween.cancel();
		}
	}

	public static function isActive(Tween:FlxTween)
	{
		return Tween != null && Tween.active;
	}

	/**
	 * FlxDestroyUtil.destroy() will simply call FlxTween.destroy(), which will
	 * not cancel the tween. This means the tween will continue run, despite
	 * being destroyed, and cause a NullPointerException.
	 *
	 * FlxTweenUtil.destroy() cancels a tween, and then destroys it.
	 */
	static public function destroy<T:FlxTween>(alphaTween:Null<FlxTween>):T
	{
		cancel(alphaTween);
		return FlxDestroyUtil.destroy(alphaTween);
	}
}