package poke.grov;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * Various asset paths for Grovyle. These paths toggle based on Grovyle's
 * gender
 */
class GrovyleResource
{
	public static var BODY_PARTS:Array<FlxGraphicAsset> = [
				AssetPaths.grovyle_head0__png,
				AssetPaths.grovyle_arms0__png,
				AssetPaths.grovyle_arms1__png,
				AssetPaths.grovyle_ass__png,
				AssetPaths.grovyle_balls__png,
				AssetPaths.grovyle_boxers__png,
				AssetPaths.grovyle_dick__png,
				AssetPaths.grovyle_dick_f__png,
				AssetPaths.grovyle_feet__png,
				AssetPaths.grovyle_head1__png,
				AssetPaths.grovyle_head1_f__png,
				AssetPaths.grovyle_legs__png,
				AssetPaths.grovyle_panties__png,
				AssetPaths.grovyle_panties_waistband0__png,
				AssetPaths.grovyle_panties_waistband1__png,
				AssetPaths.grovyle_pants__png,
				AssetPaths.grovyle_pants_f__png,
				AssetPaths.grovyle_tail__png,
				AssetPaths.grovyle_torso__png
			];

	/*
	 * Certain parts of Grovyle's sprites (the foreground parts) should turn to
	 * shadow when the lights are out. Other parts (the background) should stay
	 * their original color
	 */
	public static var SHADOW_MAPPING:Map<FlxColor, FlxColor> = [
				0xFF1F1D1D => LightsOut.SHADOW_COLOR,
				0xFF2A4A0F => LightsOut.SHADOW_COLOR,
				0xFF3F3C3B => LightsOut.SHADOW_COLOR,
				0xFF49821B => LightsOut.SHADOW_COLOR,
				0xFF506737 => LightsOut.SHADOW_COLOR,
				0xFF864C4E => LightsOut.SHADOW_COLOR,
				0xFF8BB461 => LightsOut.SHADOW_COLOR,
				0xFF91D5E3 => LightsOut.SHADOW_COLOR,
				0xFFA2DBE7 => LightsOut.SHADOW_COLOR,
				0xFFC0B4B1 => LightsOut.SHADOW_COLOR,
				0xFFC77857 => LightsOut.SHADOW_COLOR,
				0xFFCF4417 => LightsOut.SHADOW_COLOR,
				0xFFF0E010 => LightsOut.SHADOW_COLOR,
				0xFFF38A8E => LightsOut.SHADOW_COLOR,
				0xFFFABEC3 => LightsOut.SHADOW_COLOR,
				0xFFFFFFFF => LightsOut.SHADOW_COLOR
			];

	public static var dick:FlxGraphicAsset;
	public static var head1:FlxGraphicAsset;
	public static var pants:FlxGraphicAsset;
	public static var underwear:FlxGraphicAsset;
	public static var button:FlxGraphicAsset;
	public static var chat:FlxGraphicAsset;
	public static var wordsSmall:FlxGraphicAsset;
	public static var tutorialOnButton:FlxGraphicAsset;
	public static var tutorialButton:FlxGraphicAsset;
	public static var dickVibe:FlxGraphicAsset;

	public static function initialize():Void
	{
		dick = PlayerData.grovMale ? AssetPaths.grovyle_dick__png : AssetPaths.grovyle_dick_f__png;
		dickVibe = PlayerData.grovMale ? AssetPaths.grovyle_dick_vibe__png : AssetPaths.grovyle_dick_vibe_f__png;
		head1 = PlayerData.grovMale ? AssetPaths.grovyle_head1__png : AssetPaths.grovyle_head1_f__png;
		pants = PlayerData.grovMale ? AssetPaths.grovyle_pants__png : AssetPaths.grovyle_pants_f__png;
		underwear = PlayerData.grovMale ? AssetPaths.grovyle_boxers__png : AssetPaths.grovyle_panties__png;
		button = PlayerData.grovMale ? AssetPaths.menu_grovyle__png : AssetPaths.menu_grovyle_f__png;
		chat = PlayerData.grovMale ? AssetPaths.grovyle_chat__png : AssetPaths.grovyle_chat_f__png;
		wordsSmall = PlayerData.grovMale ? AssetPaths.grovyle_words_small__png : AssetPaths.grovyle_words_small_f__png;
		tutorialOnButton = PlayerData.grovMale ? AssetPaths.tutorial_on_button__png : AssetPaths.tutorial_on_button_f__png;
		tutorialButton = PlayerData.grovMale ? AssetPaths.menu_grovyle_tut__png: AssetPaths.menu_grovyle_tut_f__png;
	}

	/**
	 * For the intro, we preinitialize male/female grovyle resources to reduce stutter when toggling gender
	 */
	public static function preinitializeResources():Void
	{
		var oldMale = PlayerData.grovMale;
		for (grovMale in [false, true])
		{
			PlayerData.grovMale = grovMale;
			initialize();
			for (asset in [dick, head1, pants, underwear, button, chat, wordsSmall])
			{
				new FlxSprite().loadGraphic(asset);
			}
		}
		PlayerData.grovMale = oldMale;
	}
}