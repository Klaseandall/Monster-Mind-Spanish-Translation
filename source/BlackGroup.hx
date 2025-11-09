package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.display.BitmapData;
import openfl.geom.ColorTransform;

/**
 * An FlxGroup extension which renders all of its children, but masks them to
 * be black. Useful for shadowy effects, or covering things up
 */
class BlackGroup extends FlxGroup implements CustomDrawnFlxGroup
{
	// Buffer which this group is rendered to, prior to rendering it to the camera
	private var _groupBuffer:FlxSprite;
	public var _blackness:Float = 1.0;

	public function new()
	{
		super();
		_groupBuffer = new FlxSprite(0, 0, new BitmapData(FlxG.camera.width, FlxG.camera.height, true, 0x00));
	}

	private function _clearCameraBuffer():Void
	{
		FlxG.camera.fill(FlxColor.TRANSPARENT, false);
	}

	override public function draw():Void
	{
		customDrawToBuffer().draw();
	}

	public function customDrawToBuffer():FlxSprite
	{
		FlxSpriteUtil.fill(_groupBuffer, FlxColor.TRANSPARENT);

		#if flash
		PixelFilterUtils.swapCameraBuffer(_groupBuffer);
		super.draw();
		PixelFilterUtils.swapCameraBuffer(_groupBuffer);
		#else
		PixelFilterUtils.drawToBuffer(_groupBuffer, this);
		#end

		_groupBuffer.graphic.bitmap.colorTransform(_groupBuffer.graphic.bitmap.rect, new ColorTransform(1 - _blackness, 1 - _blackness, 1 - _blackness));
		_groupBuffer.dirty = true;

		return _groupBuffer;
	}
}