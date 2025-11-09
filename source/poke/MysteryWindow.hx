package poke;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import openfl.display.BitmapData;

/**
 * A generic window which can have sprites in it, and be moved freely around
 * the screen.
 *
 * In hindsight now that I'm more familiar with Flixel, I think this class is
 * simply a worse version of FlxCamera. There's probably no reason not to use
 * an FlxCamera instead, although you'd have to shift all of the Pokemon
 * sprites around slightly since this class fudges their positions a little.
 */
class MysteryWindow extends FlxSpriteGroup
{
	public var _canvas:FlxSprite;
	public var _bgColor:FlxColor = FlxColor.WHITE;

	public function new(X:Float=0, Y:Float=0, Width:Int = 248, Height:Int = 350)
	{
		super(X, Y);
		_canvas = new FlxSprite(X+3, Y+3);
		_canvas.makeGraphic(Width, Height, FlxColor.WHITE, true);
	}

	public function resize(Width:Int = 248, Height:Int = 350)
	{
		_canvas.makeGraphic(Width, Height, FlxColor.WHITE, true);
	}

	public function moveTo(X:Float, Y:Float)
	{
		super.x = X;
		super.y = Y;
		_canvas.x = X + 3;
		_canvas.y = Y + 3;
	}

	override public function draw():Void
	{
		FlxSpriteUtil.fill(_canvas, _bgColor);
		for (member in members)
		{
			if (member != null && member.visible)
			{
				_canvas.stamp(member, Std.int(member.x - member.offset.x - x), Std.int(member.y - member.offset.y - y));
			}
		}
		FlxSpriteUtil.drawRect(_canvas, 1, 1, _canvas.width - 2, _canvas.height - 2, 0x00000000, { thickness: 2 } );
		_canvas.pixels.setPixel32(0, 0, 0x00000000);
		_canvas.pixels.setPixel32(Std.int(_canvas.width-1), 0, 0x00000000);
		_canvas.pixels.setPixel32(0, Std.int(_canvas.height-1), 0x00000000);
		_canvas.pixels.setPixel32(Std.int(_canvas.width-1), Std.int(_canvas.height-1), 0x00000000);
		_canvas.draw();
	}

	override public function destroy():Void
	{
		super.destroy();
		_canvas = FlxDestroyUtil.destroy(_canvas);
	}
}