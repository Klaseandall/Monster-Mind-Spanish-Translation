package poke.sexy;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;

/**
 * Breaks a complex polygon into triangles using "ear cropping"
 */
class PolygonDecomposer
{
	public static function decomposeTriangles(poly:Array<FlxPoint>):Array<Array<FlxPoint>>
	{
		var triangles:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();

		var tmpPoly:Array<FlxPoint> = poly.copy();
		makeClockwise(tmpPoly);
		var earIndex:Int = -1;
		while ((earIndex = findEar(tmpPoly)) != -1)
		{
			triangles.push(triangle(tmpPoly, earIndex));
			tmpPoly.splice(earIndex, 1);
		}
		return triangles;
	}

	public static function findEar(tmpPoly:Array<FlxPoint>):Int
	{
		var i:Int = 0;
		while (i < tmpPoly.length && tmpPoly.length >= 3)
		{
			if (isEar(tmpPoly, i))
			{
				return i;
			}
			i++;
		}
		return -1;
	}

	public static function triangle(tmpPoly:Array<FlxPoint>, i:Int):Array<FlxPoint>
	{
		var t:Array<FlxPoint> = new Array<FlxPoint>();
		t[0] = tmpPoly[(i + tmpPoly.length - 1) % tmpPoly.length];
		t[1] = tmpPoly[i];
		t[2] = tmpPoly[(i + 1) % tmpPoly.length];
		return t;
	}

	private static function isEar(tmpPoly:Array<FlxPoint>, i:Int):Bool
	{
		var t:Array<FlxPoint> = triangle(tmpPoly, i);

		if ((t[1].x - t[0].x) * (t[2].y - t[1].y) - (t[2].x - t[1].x) * (t[1].y - t[0].y) > 0)
		{
			// not an ear; convex
			return false;
		}

		for (j in i + 2 ... i + tmpPoly.length - 1)
		{
			var q:FlxPoint = tmpPoly[j % tmpPoly.length];
			if (pointInTriangle(t[0], t[1], t[2], q))
			{
				// not an ear; can't remove this point
				return false;
			}
		}
		return true;
	}

	public static function makeClockwise(tmpPoly:Array<FlxPoint>):Void
	{
		var sum:Float = 0;
		for (i in 0 ... tmpPoly.length)
		{
			var p0:FlxPoint = tmpPoly[i];
			var p1:FlxPoint = tmpPoly[(i + 1) % tmpPoly.length];
			sum += (p1.x - p0.x) * (p1.y + p0.y);
		}
		if (sum < 0)
		{
			tmpPoly.reverse();
		}
	}

	public static function pointInTriangle(p0:FlxPoint, p1:FlxPoint, p2:FlxPoint, q:FlxPoint):Bool
	{
		var v0:FlxPoint = new FlxPoint(q.x - p0.x, q.y - p0.y);
		var v1:FlxPoint = new FlxPoint(p1.x - p0.x, p1.y - p0.y);
		var v2:FlxPoint = new FlxPoint(p2.x - p0.x, p2.y - p0.y);

		var u:Float = dot(v1, v1) * dot(v0, v2) - dot(v1, v2) * dot(v0, v1);
		var v:Float = dot(v2, v2) * dot(v0, v1) - dot(v1, v2) * dot(v0, v2);
		var w:Float = dot(v2, v2) * dot(v1, v1) - dot(v1, v2) * dot(v1, v2);

		return u > 0 && v > 0 && u + v < w;
	}

	private static function dot(v1:FlxPoint, v2:FlxPoint):Float
	{
		return FlxMath.dotProduct(v1.x, v1.y, v2.x, v2.y);
	}
}