package poke.smea;

/**
 * Various asset paths for Smeargle. These paths toggle based on Smeargle's
 * gender
 */
class SmeargleResource
{
	public static var dick: Dynamic;
	public static var undies: Dynamic;
	public static var dickVibe: Dynamic;

	public static function initialize():Void
	{
		dick = PlayerData.smeaMale ? AssetPaths.smear_dick__png : AssetPaths.smear_dick_f__png;
		undies = PlayerData.smeaMale ? AssetPaths.smear_boxers__png : AssetPaths.smear_panties__png;
		dickVibe = PlayerData.smeaMale ? AssetPaths.smear_dick_vibe__png : AssetPaths.smear_dick_vibe_f__png;
	}
}