package minigame.tug;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * The shadow which appears below ropes in the tug-of-war game
 */
class RopeShadow extends FlxSprite
{
	public var rope:Rope;

	public function new(rope:Rope)
	{
		super();
		this.rope = rope;
		makeGraphic(Std.int(rope.width), 3, FlxColor.BLACK);
		update(0); // set initial position, visible
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		visible = rope.visible;
		x = rope.x;
		y = rope.y + 13;
	}
}