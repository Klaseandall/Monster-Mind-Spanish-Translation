package poke.hera;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Various asset paths for Heracross. These paths toggle based on Heracross's
 * gender
 */
class HeraResource
{
	public static var chat:FlxGraphicAsset;
	public static var shop:FlxGraphicAsset;
	public static var shopButton:FlxGraphicAsset;
	public static var dick:FlxGraphicAsset;
	public static var dickVibe:FlxGraphicAsset;
	public static var head:FlxGraphicAsset;
	public static var legs:FlxGraphicAsset;
	public static var torso0:FlxGraphicAsset;
	public static var button:FlxGraphicAsset;
	
	public static function initialize():Void {
		chat = PlayerData.heraMale ? AssetPaths.hera_chat__png : AssetPaths.hera_chat_f__png;
		shop = PlayerData.heraMale ? AssetPaths.shop_hera0__png : AssetPaths.shop_hera0_f__png;
		shopButton = PlayerData.heraMale ? AssetPaths.menu_shop__png: AssetPaths.menu_shop_f__png;
		dick = PlayerData.heraMale ? AssetPaths.hera_dick__png : AssetPaths.hera_dick_f__png;
		dickVibe = PlayerData.heraMale ? AssetPaths.hera_dick_vibe__png : AssetPaths.hera_dick_vibe_f__png;
		head = PlayerData.heraMale ? AssetPaths.hera_head__png : AssetPaths.hera_head_f__png;
		legs = PlayerData.heraMale ? AssetPaths.hera_legs__png : AssetPaths.hera_legs_f__png;
		torso0 = PlayerData.heraMale ? AssetPaths.hera_torso0__png : AssetPaths.hera_torso0_f__png;
		button = PlayerData.heraMale ? AssetPaths.menu_hera__png : AssetPaths.menu_hera_f__png;
	}
}