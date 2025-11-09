package;
import flash.geom.ColorTransform;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import openfl.display.BitmapData;

/**
 * A group of shadows which track different objects around on the screen
 */
class ShadowGroup extends FlxTypedGroup<Shadow> implements CustomDrawnFlxGroup
{
	// Buffer which this group is rendered to, prior to rendering it to the camera
	private var _groupBuffer:FlxSprite;

	public static var SHADOW_ALPHA:Float = 0.25;
	// extra custom-shaped shadow object; such as the scale's shadow
	public var _extraShadows:Array<FlxSprite> = [];

	public function new():Void
	{
		super();
		_groupBuffer = new FlxSprite(0, 0, new BitmapData(FlxG.camera.width, FlxG.camera.height, true, 0x00));
	}

	public function makeShadow(parent:FlxSprite, scale:Float = 1):Shadow
	{
		var shadow:Shadow = recycle(Shadow);
		shadow.reset(parent.x, parent.y);
		shadow.scale.x = scale;
		shadow.scale.y = scale;
		shadow.exists = true;
		shadow.setParent(parent);
		shadow.update(0); // update initial position
		return shadow;
	}

	public function killShadow(parent:FlxSprite)
	{
		for (member in members)
		{
			if (member.hasParent(parent))
			{
				member.kill();
			}
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		for (extraShadow in _extraShadows)
		{
			extraShadow.update(elapsed);
		}
	}

	override public function draw():Void
	{
		customDrawToBuffer().draw();
	}

	public function customDrawToBuffer():FlxSprite
	{
		// clear the groupBuffer
		FlxSpriteUtil.fill(_groupBuffer, FlxColor.TRANSPARENT);

		#if flash
		PixelFilterUtils.swapCameraBuffer(_groupBuffer);
		super.draw();
		PixelFilterUtils.swapCameraBuffer(_groupBuffer);
		#else
		PixelFilterUtils.drawToBuffer(_groupBuffer, this);
		#end

		// render contents to groupBuffer
		for (extraShadow in _extraShadows)
		{
			if (extraShadow != null && extraShadow.exists && extraShadow.visible)
			{
				PixelFilterUtils.fastStampToBuffer(_groupBuffer, extraShadow);
			}
		}
		_groupBuffer.graphic.bitmap.colorTransform(_groupBuffer.graphic.bitmap.rect, new ColorTransform(1, 1, 1, SHADOW_ALPHA));
		_groupBuffer.dirty = true;

		return _groupBuffer;
	}

	override public function destroy():Void
	{
		super.destroy();

		_groupBuffer = FlxDestroyUtil.destroy(_groupBuffer);
		_extraShadows = FlxDestroyUtil.destroyArray(_extraShadows);
	}
}
