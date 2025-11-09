package demo;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * Demo for when I need to create MonsterMind-style text in teasers
 */
class TeaserTextState extends FlxState
{
	var textY:Int = 0;

	override public function create():Void
	{
		super.create();
		bgColor = FlxColor.WHITE;

		/*
		addText("monster mind 1.07\nis out today");

		addText("it has a lot of\ncool changes");

		addText("mystery boxes are\na little better");

		addText("there are some\nsexy new items");

		addText("and i've improved\nsome of the old ones");

		addText("there are 26 new\npokemon to meet");

		addText("minigames are now\nmore challenging");

		addText("sandslash is still\nsandslash (sorry)");
		*/

		addText("2019.04.01\n(april fools)");
	}

	function addText(s:String):Void
	{
		var text:FlxText = new FlxText(0, textY, 0, s, 20);
		text.color = FlxColor.BLACK;
		text.font = AssetPaths.hardpixel__otf;
		add(text);
		textY += 50;
	}
}