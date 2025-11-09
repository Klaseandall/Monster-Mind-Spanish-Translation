package poke.buiz;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Various asset paths for Buizel. These paths toggle based on Buizel's gender
 */
class BuizelResource
{
	public static var dick:FlxGraphicAsset;
	public static var shirt0:FlxGraphicAsset;
	public static var chat:FlxGraphicAsset;
	public static var head:FlxGraphicAsset;
	public static var button:FlxGraphicAsset;
	static public var dildoDick:FlxGraphicAsset;

	public static function initialize():Void
	{
		dick = PlayerData.buizMale ? AssetPaths.buizel_dick__png : AssetPaths.buizel_dick_f__png;
		shirt0 = PlayerData.buizMale ? AssetPaths.buizel_shirt0__png : AssetPaths.buizel_shirt0_f__png;
		chat = PlayerData.buizMale ? AssetPaths.buizel_chat__png : AssetPaths.buizel_chat_f__png;
		head = PlayerData.buizMale ? AssetPaths.buizel_head__png : AssetPaths.buizel_head_f__png;
		button = PlayerData.buizMale ? AssetPaths.menu_buizel__png : AssetPaths.menu_buizel_f__png;
		dildoDick = PlayerData.buizMale ? AssetPaths.buizdildo_dick__png : AssetPaths.buizdildo_dick_f__png;
	}
}