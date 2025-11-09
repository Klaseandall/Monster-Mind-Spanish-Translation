package poke.luca;

import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Various asset paths for Lucario. These paths toggle based on Lucario's
 * gender
 */
class LucarioResource
{
	public static var chat:FlxGraphicAsset;
	public static var button:FlxGraphicAsset;
	public static var pants:FlxGraphicAsset;
	public static var head:FlxGraphicAsset;
	public static var sexyHead:FlxGraphicAsset;
	public static var dick:FlxGraphicAsset;
	public static var sexyDick:FlxGraphicAsset;
	public static var dildoHead:FlxGraphicAsset;
	static public var dildoDick:FlxGraphicAsset;

	static public function setHat(hat:Bool)
	{
		if (PlayerData.lucaMale)
		{
			LucarioResource.chat = hat ? AssetPaths.luca_chat_hat__png : AssetPaths.luca_chat__png;
		}
		else
		{
			LucarioResource.chat = hat ? AssetPaths.luca_chat_hat_f__png : AssetPaths.luca_chat_f__png;
		}
	}

	public static function initialize():Void
	{
		button = PlayerData.lucaMale ? AssetPaths.menu_luca__png : AssetPaths.menu_luca_f__png;
		chat = AssetPaths.luca_chat_hat__png;
		pants = PlayerData.lucaMale ? AssetPaths.luca_pants__png : AssetPaths.luca_pants_f__png;
		head = PlayerData.lucaMale ? AssetPaths.luca_head__png : AssetPaths.luca_head_f__png;
		sexyHead = PlayerData.lucaMale ? AssetPaths.lucasexy_head__png : AssetPaths.lucasexy_head_f__png;
		dick = PlayerData.lucaMale ? AssetPaths.luca_dick__png : AssetPaths.luca_dick_f__png;
		sexyDick = PlayerData.lucaMale ? AssetPaths.lucasexy_dick__png : AssetPaths.lucasexy_dick_f__png;
		dildoHead = PlayerData.lucaMale ? AssetPaths.lucadildo_head__png : AssetPaths.lucadildo_head_f__png;
		dildoDick = PlayerData.lucaMale ? AssetPaths.lucadildo_dick__png : AssetPaths.lucadildo_dick_f__png;
	}
}