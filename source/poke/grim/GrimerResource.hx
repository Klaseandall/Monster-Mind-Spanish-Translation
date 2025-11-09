package poke.grim;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Various asset paths for Grimer. These paths toggle based on Grimer's gender
 */
class GrimerResource
{
	public static var chat:FlxGraphicAsset;
	public static var face:FlxGraphicAsset;
	public static var button:FlxGraphicAsset;

	public static function initialize():Void
	{
		chat = PlayerData.grimMale ? AssetPaths.grimer_chat__png : AssetPaths.grimer_chat_f__png;
		face = PlayerData.grimMale ? AssetPaths.grimer_face__png : AssetPaths.grimer_face_f__png;
		button = PlayerData.grimMale ? AssetPaths.menu_grimer__png : AssetPaths.menu_grimer_f__png;
	}
}