package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * Utility methods related to the player's cursor
 */
class CursorUtils
{
	public static function initializeSystemCursor()
	{
		if (PlayerData.cursorType == "none")
		{
			FlxG.mouse.useSystemCursor = true;
			FlxG.mouse.visible = true;
		}
		else
		{
			FlxG.mouse.useSystemCursor = false;
			FlxG.mouse.visible = false;
		}
	}

	public static function useSystemCursor()
	{
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;
	}

	public static function initializeHandSprite(spr:FlxSprite, graphic:FlxGraphicAsset)
	{
		initializeCustomHandBouncySprite(spr, graphic, 160, 160);
	}

	public static function initializeHandBouncySprite(spr:FlxSprite, graphic:FlxGraphicAsset)
	{
		initializeCustomHandBouncySprite(spr, graphic, 356, 532);
	}

	public static function initializeTallHandBouncySprite(spr:FlxSprite, graphic:FlxGraphicAsset)
	{
		initializeCustomHandBouncySprite(spr, graphic, 356, 660);
	}

	/**
	 * Initializes a sprite for the player's cursor. This includes drawing the
	 * glove graphics, recoloring them appropriately, and setting the alpha
	 * component.
	 *
	 * @param	spr sprite to initialize
	 * @param	graphic graphic to initialize with
	 * @param	w sprite width
	 * @param	h sprite height
	 */
	public static function initializeCustomHandBouncySprite(spr:FlxSprite, graphic:FlxGraphicAsset, w:Int, h:Int)
	{
		spr.loadGraphic(graphic, true, w, h, true);
		if (PlayerData.cursorType == "none")
		{
			spr.loadGraphic(graphic, true, w, h, true);
			spr.pixels.fillRect(spr.pixels.rect, FlxColor.TRANSPARENT);
		}
		else
		{
			spr.pixels.threshold(spr.pixels, new Rectangle(0, 0, spr.pixels.width, spr.pixels.height), new Point(0, 0), '==', 0xffffffff, PlayerData.cursorFillColor);
			spr.pixels.threshold(spr.pixels, new Rectangle(0, 0, spr.pixels.width, spr.pixels.height), new Point(0, 0), '==', 0xff000000, PlayerData.cursorLineColor);
			spr.alpha = PlayerData.cursorMaxAlpha;
		}
	}
}