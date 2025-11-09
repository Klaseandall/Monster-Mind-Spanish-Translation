package poke.magn;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxSpriteUtil.LineStyle;

/**
 * LightningLine is a long zigzag line which looks like a lightning bolt. It
 * isn't a Flixel sprite, and doesn't have any logic for updating or drawing
 * itself. It just maintains the data model and logic for drawing individual
 * line segments.
 */
class LightningLine implements IFlxDestroyable
{
	public var xs:Array<Float> = [];
	public var ys:Array<Float> = [];

	/*
	 * List of bolts which are zapping the hand, or the antenna. "Big bolts" have a null index 0.
	 */
	public var bolts:Array<Array<FlxPoint>> = [];
	public var lineWidth:Float = 1;

	public function new()
	{
	}

	/**
	 * Add another point to the lightning line; if this isn't the first point,
	 * it also results in a new line segment being created to connect that
	 * point
	 *
	 * @param	x x coordinate of the new point
	 * @param	y y coordinate of the new point
	 */
	public function push(x:Float, y:Float)
	{
		xs.push(x + FlxG.random.float(-26, 26));
		ys.push(y + FlxG.random.float(-26, 26));
	}

	/**
	 * Pushes a big zigzag sine wave shape, which appears that it wraps around
	 * Magnezone.
	 *
	 * @param	j0 magic number which controls the initial X position of the
	 *       	wave
	 * @param	j1 magic number which controls the initial Y position of the
	 *       	wave
	 */
	public function pushWave(j0:Float, j1:Float)
	{
		var k0:Float = 0;
		while (k0 < 512 * 4)
		{
			var lx:Float = 58 + Math.abs(512 - (j0 + k0) % (512 * 2));
			var a1:Float = Math.sin((k0 + j1) * Math.PI / (1024 / 3));
			var b1:Float = a1 > 0 ? 96 : 128;
			var ly:Float = 249 + a1 * Math.sqrt(b1 * b1 * (1 - (lx - 314) * (lx - 314) / (256 * 256)));
			if (!Math.isFinite(ly))
			{
				ly = 249;
			}
			push(lx, ly);
			k0 += 13;
		}
	}

	public function pushBigBolt(lightningIndex:Int, x1:Float, y1:Float)
	{
		pushBolt(lightningIndex, x1, y1);
		var ll:Int = lightningIndex % xs.length;
		bolts[ll].insert(0, null);
	}

	public function pushBolt(lightningIndex:Int, x1:Float, y1:Float)
	{
		var ll:Int = lightningIndex % xs.length;
		if (bolts[ll] != null && bolts[ll][0] == null)
		{
			// big bolts can't be overridden
			return;
		}
		var x0:Float = xs[ll];
		var y0:Float = ys[ll];
		var p0:FlxPoint = FlxPoint.get(x0, y0);
		var p1:FlxPoint = FlxPoint.get(x1, y1);

		bolts[ll] = [];
		bolts[ll].push(p0);
		var dist = p0.distanceTo(p1);
		var d = FlxG.random.float(0, 20);
		while (d < dist)
		{
			var dd:Float = ((dist - d) / dist);
			var x:Float = x0 * Math.pow(dd, 0.5) + x1 * (1 - Math.pow(dd, 0.5));
			var y:Float = y0 * dd + y1 * (1 - dd);
			bolts[ll].push(FlxPoint.get(x + FlxG.random.float( -26, 26), y + FlxG.random.float( -26, 26)));
			bolts[ll].push(FlxPoint.get(x, y));
			d += 20;
		}
		bolts[ll].push(p1);
	}

	public function draw(lightningLayer:BouncySprite, lightningIndex:Int, lightningIntensity:Int)
	{
		var liveBolts:Map<Int, Bool> = new Map<Int, Bool>();
		var j:Float = 0.25;
		for (i in lightningIndex + 1...lightningIndex + lightningIntensity + 1)
		{
			var currWidth:Float = lineWidth * (j / lightningIntensity);
			var currWidthInt:Float = Math.ceil(currWidth);
			var lineStyle:LineStyle = {thickness:3, color:FlxColor.WHITE};
			if (currWidth >= 0.65)
			{
				lineStyle.thickness = currWidthInt;
			}
			else
			{
				lineStyle.thickness = 1;
				lineStyle.color.alphaFloat = currWidth / 0.65;
			}
			FlxSpriteUtil.drawLine(lightningLayer, xs[(i - 1) % xs.length], ys[(i - 1) % xs.length], xs[i % xs.length], ys[i % xs.length], lineStyle);
			if (bolts[i % xs.length] != null)
			{
				var bolt:Array<FlxPoint> = bolts[i % xs.length];
				liveBolts[i % xs.length] = true;
				var bigBolt:Bool = false;
				var jj:Int = 1;
				if (bolt[0] == null)
				{
					bigBolt = true;
					lineStyle.thickness += 4;
					jj = 2;
				}
				FlxSpriteUtil.beginDraw(FlxColor.TRANSPARENT, lineStyle);
				FlxSpriteUtil.flashGfx.moveTo(bolt[jj - 1].x, bolt[jj - 1].y);
				while (jj < bolt.length)
				{
					FlxSpriteUtil.flashGfx.lineTo(bolt[jj].x, bolt[jj].y);
					jj++;
				}
				FlxSpriteUtil.endDraw(lightningLayer);
				if (bigBolt)
				{
					bigBolt = false;
					lineStyle.thickness -= 2;
				}
			}
			j++;
		}
		for (i in lightningIndex + lightningIntensity + 1...lightningIndex + lightningIntensity + 5)
		{
			if (bolts[i % xs.length] != null)
			{
				liveBolts[i % xs.length] = true;
			}
		}
		for (i in 0...bolts.length)
		{
			if (bolts[i] != null && !liveBolts.exists(i))
			{
				bolts[i] = null;
			}
		}
	}

	public function destroy()
	{
		xs = null;
		ys = null;
		if (bolts != null)
		{
			for (i in 0...bolts.length)
			{
				bolts[i] = FlxDestroyUtil.putArray(bolts[i]);
			}
		}
		bolts = null;
	}
}