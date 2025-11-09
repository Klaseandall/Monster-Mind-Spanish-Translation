package poke.kecl;

/**
 * Various asset paths for Kecleon. These paths toggle based on Kecleon's
 * gender
 */
class KecleonResource {
	public static var undies: Dynamic;

	public static function initialize():Void
	{
		undies = PlayerData.keclMale ? AssetPaths.kecleon_boxers__png: AssetPaths.kecleon_panties__png;
	}
}