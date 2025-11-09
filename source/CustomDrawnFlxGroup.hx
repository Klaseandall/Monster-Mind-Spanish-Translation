import flixel.FlxSprite;

/**
 * An FlxGroup with custom drawing logic.
 *
 * This interface exposes a method so that non-flash targets can render the FlxGroup to a buffer.
 * This is needed for some software-level graphics effects, such as the metaballs provided by
 * BlobbyGroup.
 */
 interface CustomDrawnFlxGroup {
	/**
	 * Renders this FlxGroup to an FlxSprite which is returned.
	 *
	 * The resulting FlxSprite should be cached and reused, so that we do not create a new
	 * FlxSprite and a new graphic every frame.
	 */ 
	public function customDrawToBuffer():FlxSprite;
}