package demo;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * A debug tool for masking different parts of an image, such as for deciding
 * which parts of Grovyle's sprites should be in shadow during the intro.
 *
 * A -> flag a color for masking
 * B -> flag a color for masking
 * SPACE -> print all masked colors
 */
class ColoringDebugState extends FlxState
{
	var oldMousePosition:FlxPoint;
	var newMousePosition:FlxPoint;
	var sprite:FlxSprite;
	var spritePoint:FlxPoint;
	var overlaySprite:FlxSprite;

	var cursorSprite:FlxSprite;
	var colorMapping:Map<FlxColor, String> = new Map<FlxColor, String>();

	var FIDELITY:Int = 2;

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();
		sprite = new FlxSprite(0, 0);
		sprite.loadGraphic(AssetPaths.critter_heads_0__png);
		sprite.scale.x = FIDELITY;
		sprite.scale.y = FIDELITY;
		sprite.updateHitbox();
		add(sprite);
		sprite.screenCenter();
		spritePoint = sprite.getPosition();
		sprite.x = Math.round(spritePoint.x / FIDELITY) * FIDELITY;
		sprite.y = Math.round(spritePoint.y / FIDELITY) * FIDELITY;

		overlaySprite = new FlxSprite(0, 0);
		overlaySprite.makeGraphic(sprite.pixels.width, sprite.pixels.height, FlxColor.TRANSPARENT, true);
		overlaySprite.scale.x = FIDELITY;
		overlaySprite.scale.y = FIDELITY;
		overlaySprite.updateHitbox();
		add(overlaySprite);

		cursorSprite = new FlxSprite(0, 0);
		cursorSprite.loadGraphic(new BitmapData(6 * FIDELITY, FIDELITY), true, FIDELITY, FIDELITY, true);
		FlxSpriteUtil.drawRect(cursorSprite, 0 * FIDELITY, 0, FIDELITY, FIDELITY, FlxColor.RED);
		FlxSpriteUtil.drawRect(cursorSprite, 1 * FIDELITY, 0, FIDELITY, FIDELITY, FlxColor.ORANGE);
		FlxSpriteUtil.drawRect(cursorSprite, 2 * FIDELITY, 0, FIDELITY, FIDELITY, FlxColor.YELLOW);
		FlxSpriteUtil.drawRect(cursorSprite, 3 * FIDELITY, 0, FIDELITY, FIDELITY, FlxColor.GREEN);
		FlxSpriteUtil.drawRect(cursorSprite, 4 * FIDELITY, 0, FIDELITY, FIDELITY, FlxColor.BLUE);
		FlxSpriteUtil.drawRect(cursorSprite, 5 * FIDELITY, 0, FIDELITY, FIDELITY, FlxColor.PURPLE);
		cursorSprite.animation.add("default", [0, 1, 2, 3, 4, 5], 30);
		cursorSprite.animation.play("default");
		add(cursorSprite);

		oldMousePosition = FlxG.mouse.getPosition();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		newMousePosition = FlxG.mouse.getPosition(newMousePosition);

		cursorSprite.setPosition(Math.round((newMousePosition.x - FIDELITY * 0.5) / FIDELITY) * FIDELITY, Math.round((newMousePosition.y - FIDELITY * 0.5) / FIDELITY) * FIDELITY);

		if (FlxG.mouse.pressed)
		{
			spritePoint.add(newMousePosition.x, newMousePosition.y);
			spritePoint.subtract(oldMousePosition.x, oldMousePosition.y);
			sprite.x = Math.round(spritePoint.x / FIDELITY) * FIDELITY;
			sprite.y = Math.round(spritePoint.y / FIDELITY) * FIDELITY;
		}
		if (FlxG.keys.justPressed.A || FlxG.keys.justPressed.B || FlxG.keys.justPressed.C || FlxG.keys.justPressed.D || FlxG.keys.justPressed.E || FlxG.keys.justPressed.F)
		{
			var pixelPoint:FlxPoint = FlxPoint.get(cursorSprite.x, cursorSprite.y);
			pixelPoint.subtract(sprite.x, sprite.y);
			pixelPoint.x /= FIDELITY;
			pixelPoint.y /= FIDELITY;

			var sourceColor:FlxColor = sprite.pixels.getPixel32(Std.int(pixelPoint.x), Std.int(pixelPoint.y));
			pixelPoint.put();
			var targetColor:FlxColor;
			if (FlxG.keys.justPressed.A)
			{
				targetColor = 0xffadd8e6; // light blue
				colorMapping[sourceColor] = "0xAAAAAAAA";
				trace("A: " + StringTools.hex(sourceColor));
			}
			else if (FlxG.keys.justPressed.B)
			{
				targetColor = 0xff191970; // midnight blue
				colorMapping[sourceColor] = "0xBBBBBBBB";
				trace("B: " + StringTools.hex(sourceColor));
			}
			else if (FlxG.keys.justPressed.B)
			{
				targetColor = 0xffe6add8; // light red
				colorMapping[sourceColor] = "0xCCCCCCCC";
				trace("C: " + StringTools.hex(sourceColor));
			}
			else if (FlxG.keys.justPressed.B)
			{
				targetColor = 0xff701919; // midnight red
				colorMapping[sourceColor] = "0xDDDDDDDD";
				trace("D: " + StringTools.hex(sourceColor));
			}
			else if (FlxG.keys.justPressed.B)
			{
				targetColor = 0xffd8e6ad; // light green
				colorMapping[sourceColor] = "0xEEEEEEEE";
				trace("E: " + StringTools.hex(sourceColor));
			}
			else
			{
				targetColor = 0xff197019; // midnight green
				colorMapping[sourceColor] = "0xFFFFFFFF";
				trace("F: " + StringTools.hex(sourceColor));
			}
			overlaySprite.pixels.threshold(sprite.pixels, new Rectangle(0, 0, sprite.width, sprite.height), new Point(0, 0), '==', sourceColor, targetColor);
			overlaySprite.dirty = true;
		}
		if (FlxG.keys.justPressed.SPACE)
		{
			for (key in colorMapping.keys())
			{
				trace("colorMapping[0x" + StringTools.hex(key) + "] = " + colorMapping[key] + ";");
			}
		}

		overlaySprite.x = sprite.x;
		overlaySprite.y = sprite.y;

		oldMousePosition.copyFrom(newMousePosition);
	}
}