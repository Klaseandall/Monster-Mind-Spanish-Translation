package kludge;
import flixel.FlxSprite;

/**
 * Workaround for asset-related glitches in Flixel
 */
class AssetKludge
{
	/**
	 * Between Flixel 3.3.12 and 4.1.1, Flixel made it so that you can't apply drop shadows to
	 * buttons unless you jump through this very silly hoop first
	 * 
	 * http://forum.haxeflixel.com/topic/179/i-don-t-understand-the-change-from-flxspritefilter-to-flxfilterframes
	 */
	public static function buttonifyAsset<T>(asset:Dynamic):Void {
		new FlxSprite(0, 0, asset);
	}
}