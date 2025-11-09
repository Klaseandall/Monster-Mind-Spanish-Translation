package credits;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.util.FlxSpriteUtil;

/**
 * During the credits when an object zips through space or zips into abra,
 * there is a fadey line with a fat end and a skinny end. WispLine
 * encompasses logic for drawing and fading those lines
 */
class WispLine implements IFlxDestroyable
{
	var x0:Float = 0;
	var y0:Float = 0;
	var w0:Float = 0;
	var x1:Float = 0;
	var y1:Float = 0;
	var w1:Float = 0;
	var vertices:Array<FlxPoint> = [FlxPoint.get(), FlxPoint.get(), FlxPoint.get(), FlxPoint.get(), FlxPoint.get(), FlxPoint.get()];
	public var color:FlxColor = 0xffffffff;
	public var age:Float = 0;
	public var lifespan:Float = 1.2;

	public function new()
	{
	}

	public function update(elapsed:Float)
	{
		age += elapsed;

		if (age <= lifespan * 0.3)
		{
			color = 0xffffffff;
		}
		else if (age > lifespan * 0.3 && age <= lifespan * 0.6)
		{
			color = 0xff7fe4ff;
		}
		else if (age > lifespan * 0.6)
		{
			color = 0xff40a4c0;
		}
		color.alphaFloat = FlxMath.bound((lifespan - age) / lifespan, 0, 1);
	}

	public function set(x0:Float, y0:Float, w0:Float, x1:Float, y1:Float, w1:Float)
	{
		this.x0 = x0;
		this.y0 = y0;
		this.w0 = w0;
		this.x1 = x1;
		this.y1 = y1;
		this.w1 = w1;

		var d:FlxPoint = FlxPoint.get();
		d.set(x1 - x0, y1 - y0);
		d.length = 1;

		vertices[0].set(x0 + w0 * 0.5 * d.y, y0 - w0 * 0.5 * d.x);
		vertices[1].set(x1 + w1 * 0.5 * d.y, y1 - w1 * 0.5 * d.x);
		vertices[2].set(x1 + w1 * 0.5 * d.y, y1 + w1 * 0.5 * d.x);
		vertices[3].set(x1 - w1 * 0.5 * d.y, y1 + w1 * 0.5 * d.x);
		vertices[4].set(x0 - w0 * 0.5 * d.y, y0 + w0 * 0.5 * d.x);
		vertices[5].set(x0 + w0 * 0.5 * d.y, y0 + w0 * 0.5 * d.x);

		d.put();
	}

	public function draw(sprite:FlxSprite)
	{
		FlxSpriteUtil.drawPolygon(sprite, vertices, color);
	}

	public function destroy():Void
	{
		vertices = FlxDestroyUtil.putArray(vertices);
	}
}