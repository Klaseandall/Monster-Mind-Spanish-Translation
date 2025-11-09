package poke.abra;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Various asset paths for Abra. These paths toggle based on Abra's gender
 */
class AbraResource
{
	public static var titleScreen:FlxGraphicAsset;
	public static var undies:FlxGraphicAsset;
	public static var head:FlxGraphicAsset;
	public static var chat:FlxGraphicAsset;
	public static var dick:FlxGraphicAsset;
	public static var pants:FlxGraphicAsset;
	public static var button:FlxGraphicAsset;
	public static var tutorialOffButton:FlxGraphicAsset;

	public static var shopHead:FlxGraphicAsset;
	public static var shopPants:FlxGraphicAsset;

	public static var beadsDick:FlxGraphicAsset;
	public static var beadsHead:FlxGraphicAsset;

	public static function initialize():Void
	{
		titleScreen = PlayerData.abraMale ? AssetPaths.title_screen_abra0__png : AssetPaths.title_screen_abra0_f__png;
		undies = PlayerData.abraMale ? AssetPaths.abra_undies__png : AssetPaths.abra_panties__png;
		head = PlayerData.abraMale ? AssetPaths.abra_head__png : AssetPaths.abra_head_f__png;
		if (PlayerData.abraStoryInt == 5 || PlayerData.abraStoryInt == 6)
		{
			chat = PlayerData.abraMale ? AssetPaths.abra_chat_happy__png : AssetPaths.abra_chat_happy_f__png;
		}
		else {
			chat = PlayerData.abraMale ? AssetPaths.abra_chat__png : AssetPaths.abra_chat_f__png;
		}
		dick = PlayerData.abraMale ? AssetPaths.abra_dick__png : AssetPaths.abra_dick_f__png;
		pants = PlayerData.abraMale ? AssetPaths.abra_pants__png : AssetPaths.abra_pants_f__png;
		button = PlayerData.abraMale ? AssetPaths.menu_abra__png : AssetPaths.menu_abra_f__png;
		tutorialOffButton = PlayerData.abraMale ? AssetPaths.tutorial_off_button__png : AssetPaths.tutorial_off_button_f__png;

		shopHead = PlayerData.abraMale ? AssetPaths.shop_abra_head__png : AssetPaths.shop_abra_head_f__png;
		shopPants = PlayerData.abraMale ? AssetPaths.shop_abra_pants__png : AssetPaths.shop_abra_pants_f__png;

		beadsDick = PlayerData.abraMale ? AssetPaths.abrabeads_dick__png : AssetPaths.abrabeads_dick_f__png;
		beadsHead = PlayerData.abraMale ? AssetPaths.abrabeads_head__png : AssetPaths.abrabeads_head_f__png;
	}
}