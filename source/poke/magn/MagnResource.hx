package poke.magn;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Various asset paths for Magnezone. These paths toggle based on Magnezone's
 * gender
 */
class MagnResource
{
	public static var chat:FlxGraphicAsset;
	public static var lever:FlxGraphicAsset;

	public static function initialize():Void
	{
		chat = AssetPaths.magn_chat__png;
		lever = PlayerData.magnMale ? AssetPaths.magn_lever__png : AssetPaths.magn_lever_f__png;
	}
}