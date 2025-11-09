package poke.magn;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import openfl.display.BlendMode;
import openfl.geom.Point;
import poke.sexy.SexyState;

/**
 * The simplistic window on the side which lets the player control Magnezone's
 * anal bead dressup game
 */
class MagnBeadInterface extends FlxSpriteGroup
{
	static var BUTTON_POSITIONS:Array<FlxPoint> = [
				FlxPoint.get(20, 53), FlxPoint.get(42, 57),
				FlxPoint.get(212, 33), FlxPoint.get(235, 37),
				FlxPoint.get(111, 214), FlxPoint.get(136, 216)
			];
	var arrowSprite:FlxSprite;
	var canvas:FlxSprite;
	var fgSprite:BouncySprite;
	public var beadOutfitChangeEvent:Int->Int->Void;

	public function new()
	{
		super();
		var bgSprite = new FlxSprite(-3, 2);
		bgSprite.loadGraphic(AssetPaths.magnbeads_iface__png);
		add(bgSprite);

		fgSprite = new BouncySprite( -3, 2, 4, 5, 0);
		fgSprite.loadGraphic(AssetPaths.magnbeads_shadow__png, true, 258, 243);
		fgSprite.animation.add("default", AnimTools.blinkyAnimation([0, 1, 2]), 3);
		fgSprite.animation.play("default");
		add(fgSprite);

		arrowSprite = new FlxSprite(-3, 2);
		arrowSprite.loadGraphic(AssetPaths.magnbeads_arrows__png, true, 258, 243);
		add(arrowSprite);

		canvas = new FlxSprite(3, 123);
		canvas.makeGraphic(254, 243, FlxColor.TRANSPARENT, true);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		var closestButtonIndex = -1;
		var closestButtonDist:Float = 18;
		var relativeMousePosition:FlxPoint = FlxPoint.get(FlxG.mouse.x - canvas.x, FlxG.mouse.y - canvas.y);
		for (buttonIndex in 0...6)
		{
			var buttonDist:Float = BUTTON_POSITIONS[buttonIndex].distanceTo(relativeMousePosition);
			if (buttonDist < closestButtonDist)
			{
				closestButtonDist = buttonDist;
				closestButtonIndex = buttonIndex;
			}
		}
		if (FlxG.mouse.pressed)
		{
			arrowSprite.animation.frameIndex = 0;
			if (SexyState.toyMouseJustPressed() && closestButtonIndex >= 0)
			{
				if (closestButtonIndex == 0)
				{
					beadOutfitChangeEvent(0, -1);
				}
				else if (closestButtonIndex == 1)
				{
					beadOutfitChangeEvent(0, 1);
				}
				else if (closestButtonIndex == 2)
				{
					beadOutfitChangeEvent(2, -1);
				}
				else if (closestButtonIndex == 3)
				{
					beadOutfitChangeEvent(2, 1);
				}
				else if (closestButtonIndex == 4)
				{
					beadOutfitChangeEvent(1, -1);
				}
				else if (closestButtonIndex == 5)
				{
					beadOutfitChangeEvent(1, 1);
				}
			}
		}
		else {
			arrowSprite.animation.frameIndex = closestButtonIndex + 1;
		}
	}

	public function synchronize(magnWindow:MagnWindow):Void
	{
		fgSprite._age = magnWindow._body._age;
		fgSprite._bounceDuration = magnWindow._body._bounceDuration;
		fgSprite._bouncePhase = magnWindow._body._bouncePhase;
	}

	override public function draw():Void
	{
		for (member in members)
		{
			if (member != null && member.visible)
			{
				canvas.stamp(member, Std.int(member.x - member.offset.x - x), Std.int(member.y - member.offset.y - y));
			}
		}

		// erase unused bits...
		{
			var poly:Array<FlxPoint> = [];
			poly.push(FlxPoint.get(254, 243));
			poly.push(FlxPoint.get(254 - 60 - 1, 243));
			poly.push(FlxPoint.get(254, 243 - 32 - 1));
			FlxSpriteUtil.drawPolygon(canvas, poly, 0xFF80684E, null, {blendMode:BlendMode.ERASE});
			FlxDestroyUtil.putArray(poly);
		}
		{
			var poly:Array<FlxPoint> = [];
			poly.push(FlxPoint.get(0, 0));
			poly.push(FlxPoint.get(2 + 60, 0));
			poly.push(FlxPoint.get(0, 32 + 2));
			FlxSpriteUtil.drawPolygon(canvas, poly, 0xFF80684E, null, {blendMode:BlendMode.ERASE});
			FlxDestroyUtil.putArray(poly);
		}

		#if !flash
		// BlendMode.ERASE is not supported by non-flash targets, so we manually erase the pixels
		// with a threshold() call
		canvas.pixels.threshold(canvas.pixels, canvas.pixels.rect, new Point(0, 0), "==", 0xFF80684E);
		#end

		// draw border...
		{
			var poly:Array<FlxPoint> = [];
			poly.push(FlxPoint.get(1 + 60, 1));
			poly.push(FlxPoint.get(254 - 1, 1));
			poly.push(FlxPoint.get(254 - 1, 243 - 32));
			poly.push(FlxPoint.get(254 - 60, 243 - 1));
			poly.push(FlxPoint.get(1, 243 - 1));
			poly.push(FlxPoint.get(1, 1 + 32));
			poly.push(FlxPoint.get(1 + 60, 1));
			FlxSpriteUtil.drawPolygon(canvas, poly, FlxColor.TRANSPARENT, { thickness: 2, color: FlxColor.BLACK });
			FlxDestroyUtil.putArray(poly);
		}

		// erase corners...
		canvas.pixels.setPixel32(Std.int(canvas.width - 1), 0, 0x00000000);
		canvas.pixels.setPixel32(0, Std.int(canvas.height - 1), 0x00000000);
		canvas.draw();
	}

	override public function destroy():Void
	{
		super.destroy();

		arrowSprite = FlxDestroyUtil.destroy(arrowSprite);
		canvas = FlxDestroyUtil.destroy(canvas);
		fgSprite = FlxDestroyUtil.destroy(fgSprite);
		beadOutfitChangeEvent = null;
	}
}