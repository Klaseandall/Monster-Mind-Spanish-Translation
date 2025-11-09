package minigame.tug;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * Graphics and logic for a tent in the tug-of-war minigame
 */
class Tent implements IFlxDestroyable
{
	public var tentFloorSprite:FlxSprite;
	public var tentFrontSprite:FlxSprite;
	public var tentBackSprite:FlxSprite;
	public var tentWhite:FlxSprite;
	public var tentShadow:FlxSprite;
	private var alphaTween:FlxTween;

	public function new(x:Float, y:Float, colorIndex:Int, flipX:Bool)
	{
		tentFloorSprite = new FlxSprite(x, y);
		tentFloorSprite.loadGraphic(AssetPaths.tent_floor__png, false);
		tentFloorSprite.flipX = flipX;

		tentFrontSprite = new FlxSprite(x, y + 77);
		tentFrontSprite.loadGraphic(AssetPaths.tent_front__png, true, 160, 90);
		tentFrontSprite.animation.frameIndex = colorIndex;
		tentFrontSprite.offset.y = 77;
		tentFrontSprite.height = 10;
		tentFrontSprite.flipX = flipX;

		tentBackSprite = new FlxSprite(x, y + 40);
		tentBackSprite.loadGraphic(AssetPaths.tent_back__png, true, 160, 90);
		tentBackSprite.animation.frameIndex = colorIndex;
		tentBackSprite.offset.y = 40;
		tentBackSprite.height = 10;
		tentBackSprite.flipX = flipX;

		tentWhite = new FlxSprite(x, y);
		tentWhite.loadGraphic(AssetPaths.tent_white__png);
		tentWhite.flipX = flipX;
		tentWhite.alpha = 0;

		tentShadow = new FlxSprite(x, y);
		tentShadow.loadGraphic(AssetPaths.tent_shadow__png, false);
		tentShadow.flipX = flipX;
	}

	public function flash():Void
	{
		tentWhite.alpha = 1;
		alphaTween = FlxTweenUtil.retween(alphaTween, tentWhite, {alpha:0}, 0.4);
	}

	public function destroy():Void
	{
		tentFloorSprite = FlxDestroyUtil.destroy(tentFloorSprite);
		tentFrontSprite = FlxDestroyUtil.destroy(tentFrontSprite);
		tentBackSprite = FlxDestroyUtil.destroy(tentBackSprite);
		tentWhite = FlxDestroyUtil.destroy(tentWhite);
		tentShadow = FlxDestroyUtil.destroy(tentShadow);
		alphaTween = FlxTweenUtil.destroy(alphaTween);
	}
}