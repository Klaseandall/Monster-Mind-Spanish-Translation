package poke.rhyd;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Various asset paths for Rhydon. These paths toggle based on Rhydon's gender
 */
class RhydonResource
{
	public static var head:FlxGraphicAsset;
	public static var shirt:FlxGraphicAsset;
	public static var pants:FlxGraphicAsset;
	public static var dick:FlxGraphicAsset;
	public static var button:FlxGraphicAsset;
	public static var buttonCrotch:FlxGraphicAsset;
	public static var chat:FlxGraphicAsset;
	public static var interact:FlxGraphicAsset;
	public static var torso0:FlxGraphicAsset;

	public static var beadHead:FlxGraphicAsset;
	public static var beadDick:FlxGraphicAsset;

	public static function initialize():Void
	{
		head = PlayerData.rhydMale ? AssetPaths.rhydon_head__png : AssetPaths.rhydon_head_f__png;
		shirt = PlayerData.rhydMale ? AssetPaths.rhydon_shirt__png : AssetPaths.rhydon_shirt_f__png;
		pants = PlayerData.rhydMale ? AssetPaths.rhydon_pants__png : AssetPaths.rhydon_pants_f__png;
		dick = PlayerData.rhydMale ? AssetPaths.rhydon_dick__png : AssetPaths.rhydon_dick_f__png;
		button = PlayerData.rhydMale ? AssetPaths.menu_rhyd_head__png : AssetPaths.menu_rhyd_head_f__png;
		buttonCrotch = PlayerData.rhydMale ? AssetPaths.menu_rhyd_crotch__png : AssetPaths.menu_rhyd_crotch_f__png;
		if (PlayerData.sfw)
		{
			chat = PlayerData.rhydMale ? AssetPaths.rhydon_chat_sfw__png : AssetPaths.rhydon_chat_f_sfw__png;
		}
		else {
			chat = PlayerData.rhydMale ? AssetPaths.rhydon_chat__png : AssetPaths.rhydon_chat_f__png;
		}
		interact = PlayerData.rhydMale ? AssetPaths.rhydon_interact__png : AssetPaths.rhydon_interact_f__png;
		torso0 = PlayerData.rhydMale ? AssetPaths.rhydon_torso0__png : AssetPaths.rhydon_torso0_f__png;

		beadHead = PlayerData.rhydMale ? AssetPaths.rhydbeads_head__png : AssetPaths.rhydbeads_head_f__png;
		beadDick = PlayerData.rhydMale ? AssetPaths.rhydbeads_dick__png : AssetPaths.rhydbeads_dick_f__png;
	}
}