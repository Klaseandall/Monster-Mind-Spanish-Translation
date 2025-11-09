package;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMatrix;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * Utility class for swapping buffers and stamping pixels.
 */
class PixelFilterUtils
{
	private static var index:Int = 0;
	private static var _matrix:FlxMatrix = new FlxMatrix();
	private static var _flashPoint:Point;
	private static var _flashRect:Rectangle;
	private static var _flashRect2:Rectangle;

	public static function swapCameraBuffer(buffer:FlxSprite):Void
	{
		var tmpBuffer:BitmapData = FlxG.camera.buffer;
		FlxG.camera.buffer = buffer.graphic.bitmap;
		buffer.graphic.bitmap = tmpBuffer;
	}

	public static function drawToBuffer(buffer:FlxSprite, group:FlxTypedGroup<Dynamic>)
	{
		var i:Int = 0;
		var item:FlxBasic;
		var spriteItem:FlxSprite;
		var groupItem:FlxTypedGroup<FlxBasic>;
		while (i < group.length)
		{
			item = group.members[i++];
			if (item != null && item.exists && item.visible)
			{
				if (Std.isOfType(item, FlxSprite))
				{
					spriteItem = cast item;
					fastStampToBuffer(buffer, spriteItem);
				}
				else if (Std.isOfType(item, CustomDrawnFlxGroup))
				{
					var customDrawnGroupItem:CustomDrawnFlxGroup = cast item;
					var spriteItem = customDrawnGroupItem.customDrawToBuffer();
					fastStampToBuffer(buffer, spriteItem);
				}
				else if (Std.isOfType(item, FlxTypedGroup))
				{
					groupItem = cast item;
					drawToBuffer(buffer, groupItem);
				}
			}
		}
	}

	/**
	 * Stamps to a buffer, but does not invoke calcFrame(). CalcFrame() is a
	 * performance hog and we might be stamping 300+ sprites per frame
	 */
	public static function fastStampToBuffer(buffer:FlxSprite, brush:FlxSprite)
	{
		var x:Int = Std.int(brush.x - brush.offset.x);
		var y:Int = Std.int(brush.y - brush.offset.y);

		brush.drawFrame();

		if (buffer.graphic == null || brush.graphic == null)
			throw "Cannot stamp to or from a FlxSprite with no graphics.";

		var bitmapData:BitmapData = brush.framePixels;

		if (buffer.isSimpleRenderBlit()) // simple render
		{
			_flashPoint.x = x + buffer.frame.frame.x;
			_flashPoint.y = y + buffer.frame.frame.y;
			_flashRect2.width = bitmapData.width;
			_flashRect2.height = bitmapData.height;
			buffer.graphic.bitmap.copyPixels(bitmapData, _flashRect2, _flashPoint, null, null, true);
			_flashRect2.width = buffer.graphic.bitmap.width;
			_flashRect2.height = buffer.graphic.bitmap.height;
		}
		else // complex render
		{
			_matrix.identity();
			_matrix.translate(-buffer.x, -buffer.y);
			_matrix.translate(-brush.origin.x, -brush.origin.y);
			_matrix.scale(brush.scale.x, brush.scale.y);
			if (brush.angle != 0)
			{
				_matrix.rotate(brush.angle * FlxAngle.TO_RAD);
			}
			_matrix.translate(x + buffer.frame.frame.x + brush.origin.x, y + buffer.frame.frame.y + brush.origin.y);
			var brushBlend:BlendMode = brush.blend;
			buffer.graphic.bitmap.draw(bitmapData, _matrix, null, brushBlend, null, brush.antialiasing);
		}

		// toggle dirty flag, but do not invoke calcFrame...
		buffer.dirty = true;
	}
}