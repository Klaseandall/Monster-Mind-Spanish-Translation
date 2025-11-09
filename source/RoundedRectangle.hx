package;

import flixel.FlxSprite;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

/**
 * A rectangle with rounded corners. This is used for dialog and chat windows
 */
class RoundedRectangle extends FlxSprite
{
	public var _unique:Bool = false;

	public function relocate(X:Int, Y:Int, Width:Int, Height:Int, FgColor:Int=0xff000000, BgColor:Int=0xffffffff, BorderSize:Int=2):Void
	{
		this.x = X;
		this.y = Y;
		makeGraphic(Width, Height, BgColor, _unique, "rounded-rect-" + StringTools.hex(FgColor, 8) + "-" + StringTools.hex(BgColor, 8) + "-" + Width + "x" + Height + "-" + BorderSize);
		var tempData:BitmapData = get_pixels();
		tempData.fillRect(new Rectangle(0, 0, width, height), FgColor);
		tempData.fillRect(new Rectangle(BorderSize, BorderSize, Width-2*BorderSize, height-2*BorderSize), BgColor);
		tempData.setPixel32(0, 0, 0x00000000);
		tempData.setPixel32(Width-1, 0, 0x00000000);
		tempData.setPixel32(0, Height-1, 0x00000000);
		tempData.setPixel32(Width-1, Height-1, 0x00000000);
		set_pixels(tempData);
	}
}