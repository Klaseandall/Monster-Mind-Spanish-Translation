package;
import flash.errors.SecurityError;
import flash.geom.Point;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.typeLimit.OneOfThree;
import haxe.Constraints.IMap;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

typedef LightsOutTarget = OneOfThree<FlxSprite, FlxGraphicAsset, String>;

/**
 * A class for blackening certain pixels in an image, for a silhouette effect
 */
class LightsOut
{
	private static var UNMAPPED_COLOR:FlxColor = 0xA55FEC35;
	public static var SHADOW_COLOR:FlxColor = 0xFF181823;

	// Issue 1791 - enum types cannot be used as Map keys - haxe #1791
	private var originalDataMap0:Map<FlxSprite,BitmapData> = new Map<FlxSprite,BitmapData>();
	private var originalDataMap1:Map<FlxGraphic,BitmapData> = new Map<FlxGraphic,BitmapData>();
	private var originalDataMap2:Map<BitmapData,BitmapData> = new Map<BitmapData,BitmapData>();
	private var originalDataMap3:Map<String,BitmapData> = new Map<String,BitmapData>();

	public function new()
	{
	}

	private function put(Key:LightsOutTarget, Value:BitmapData)
	{
		if (Std.isOfType(Key, FlxSprite))
		{
			originalDataMap0[cast Key] = Value;
		}
		else if (Std.isOfType(Key, FlxGraphic))
		{
			originalDataMap1[cast Key] = Value;
		}
		else if (Std.isOfType(Key, BitmapData))
		{
			originalDataMap2[cast Key] = Value;
		}
		else if (Std.isOfType(Key, String))
		{
			originalDataMap3[cast Key] = Value;
		}
	}

	private function get(Key:LightsOutTarget):BitmapData
	{
		if (Std.isOfType(Key, FlxSprite))
		{
			return originalDataMap0[cast Key];
		}
		else if (Std.isOfType(Key, FlxGraphic))
		{
			return originalDataMap1[cast Key];
		}
		else if (Std.isOfType(Key, BitmapData))
		{
			return originalDataMap2[cast Key];
		}
		else if (Std.isOfType(Key, String))
		{
			return originalDataMap3[cast Key];
		}
		return null;
	}

	public function lightsOutBody(Item:LightsOutTarget):Void
	{
		if (Std.isOfType(Item, FlxGraphic) || Std.isOfType(Item, BitmapData) || Std.isOfType(Item, String))
		{
			var graphic:FlxGraphic = FlxG.bitmap.add(cast Item, false, null);

			var originalPixels:BitmapData = new BitmapData(graphic.bitmap.width, graphic.bitmap.height, true, 0x00);
			originalPixels.copyPixels(graphic.bitmap, new Rectangle(0, 0, graphic.bitmap.width, graphic.bitmap.height), new Point(0, 0));
			put(Item, originalPixels);

			graphic.bitmap.threshold(originalPixels, new Rectangle(0, 0, graphic.bitmap.width, graphic.bitmap.height), new Point(0, 0), '>', 0x00000000, SHADOW_COLOR, 0xFF000000);
		}
	}

	public function lightsOut(Item:LightsOutTarget, colorMapping:Map<FlxColor, FlxColor>):Void
	{
		if (Std.isOfType(Item, FlxGraphic) || Std.isOfType(Item, BitmapData) || Std.isOfType(Item, String))
		{
			var graphic:FlxGraphic = FlxG.bitmap.add(cast Item, false, null);

			var extraMapping:Map<FlxColor, FlxColor> = new Map<FlxColor, FlxColor>();

			var pixelMap:Map<Int, String> = new Map<Int, String>();
			for (x in 0...graphic.bitmap.width)
			{
				for (y in 0...graphic.bitmap.height)
				{
					var pixelColor:FlxColor = graphic.bitmap.getPixel32(x, y);
					if (!colorMapping.exists(pixelColor) && !extraMapping.exists(pixelColor))
					{
						extraMapping[pixelColor] = UNMAPPED_COLOR;
						for (color in colorMapping.keys())
						{
							if (getDistance(color, pixelColor) < 3)
							{
								extraMapping[pixelColor] = colorMapping[color];
								break;
							}
						}
					}
				}
			}

			var originalPixels:BitmapData = new BitmapData(graphic.bitmap.width, graphic.bitmap.height, true, 0x00);
			originalPixels.copyPixels(graphic.bitmap, new Rectangle(0, 0, graphic.bitmap.width, graphic.bitmap.height), new Point(0, 0));
			put(Item, originalPixels);

			for (sourceColor in colorMapping.keys())
			{
				graphic.bitmap.threshold(originalPixels, new Rectangle(0, 0, graphic.bitmap.width, graphic.bitmap.height), new Point(0, 0), '==', sourceColor, colorMapping[sourceColor]);
			}

			for (sourceColor in extraMapping.keys())
			{
				if (extraMapping[sourceColor] != UNMAPPED_COLOR)
				{
					graphic.bitmap.threshold(originalPixels, new Rectangle(0, 0, graphic.bitmap.width, graphic.bitmap.height), new Point(0, 0), '==', sourceColor, extraMapping[sourceColor]);
				}
			}
		}
	}

	private static function getDistance(color0:FlxColor, color1:FlxColor)
	{
		var dist:Int = 0;
		dist += Std.int(Math.abs(color0.red - color1.red));
		dist += Std.int(Math.abs(color0.green - color1.green));
		dist += Std.int(Math.abs(color0.blue - color1.blue));
		dist += Std.int(Math.abs(color0.alpha - color1.alpha));
		return dist;
	}

	public function lightsOn(Item:LightsOutTarget):Void
	{
		if (Std.isOfType(Item, FlxGraphic) || Std.isOfType(Item, BitmapData) || Std.isOfType(Item, String))
		{
			var originalPixels:BitmapData = get(Item);
			if (originalPixels != null)
			{
				var graphic:FlxGraphic = FlxG.bitmap.add(cast Item, false, null);
				graphic.bitmap.copyPixels(originalPixels, new Rectangle(0, 0, originalPixels.width, originalPixels.height), new Point(0, 0));
			}
		}
	}
}