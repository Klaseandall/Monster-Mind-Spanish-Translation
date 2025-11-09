package demo;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

/**
 * Demo for experimenting with the keyboard
 */
class TextEntryDemo extends FlxState
{
	override public function create():Void
	{
		super.create();
		var bgSprite:FlxSprite = new FlxSprite(0, 0);
		bgSprite.makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
		add(bgSprite);

		add(new TextEntryGroup(null, TextEntryGroup.KeyConfig.Password));
	}
}