package poke.sand;

/**
 * Various asset paths for Sandslash. These paths toggle based on Sandslash's
 * gender
 */
class SandslashResource
{
	public static var button: Dynamic;
	public static var bg: Dynamic;
	public static var bowtie: Dynamic;
	public static var dick: Dynamic;
	public static var head1: Dynamic;
	public static var undies: Dynamic;
	public static var chat: Dynamic;
	public static var wordsSmall: Dynamic;

	public static var shopBody: Dynamic;
	public static var shopHead: Dynamic;
	public static var dildoHead1: Dynamic;
	static public var dildoDick: Dynamic;

	public static function initialize():Void
	{
		button = PlayerData.sandMale ? AssetPaths.menu_sand__png : AssetPaths.menu_sand_f__png;
		bg = PlayerData.sandMale ? AssetPaths.sand_bg__png : AssetPaths.sand_bg_f__png;
		bowtie = PlayerData.sandMale ? AssetPaths.sand_bowtie__png : AssetPaths.sand_bowtie_f__png;
		dick = PlayerData.sandMale ? AssetPaths.sand_dick__png : AssetPaths.sand_dick_f__png;
		head1 = PlayerData.sandMale ? AssetPaths.sand_head1__png : AssetPaths.sand_head1_f__png;
		undies = PlayerData.sandMale ? AssetPaths.sand_undies__png : AssetPaths.sand_undies_f__png;
		chat = PlayerData.sandMale ? AssetPaths.sand_chat__png : AssetPaths.sand_chat_f__png;
		wordsSmall = PlayerData.sandMale ? AssetPaths.sand_words_small__png : AssetPaths.sand_words_small_f__png;
		shopBody = PlayerData.sandMale ? AssetPaths.shop_sand_body__png : AssetPaths.shop_sand_body_f__png;
		shopHead = PlayerData.sandMale ? AssetPaths.shop_sand_head__png : AssetPaths.shop_sand_head_f__png;

		dildoHead1 = PlayerData.sandMale ? AssetPaths.sanddildo_head1__png : AssetPaths.sanddildo_head1_f__png;
		dildoDick = PlayerData.sandMale ? AssetPaths.sanddildo_dick__png : AssetPaths.sanddildo_dick_f__png;
	}
}