package poke.sexy;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;

/**
 * Calculates a random point in a polygon. This is used during sex scenes when
 * we might need to spawn a bead of sweat in an arbitrary position on someone's
 * torso, or display a little spark in an arbitrary position around their
 * vagina
 */
class RandomPolygonPoint
{
	public static function randomPolyPoint(poly:Array<FlxPoint>):FlxPoint
	{
		var triangles:Array<Array<FlxPoint>> = PolygonDecomposer.decomposeTriangles(poly);

		// Calculate area of each triangle in this polygon
		var areas:Array<Float> = new Array<Float>();
		var totalArea:Float = 0;
		for (i in 0...triangles.length)
		{
			areas[i] = area(triangles[i][0], triangles[i][1], triangles[i][2]);
			totalArea += areas[i];
		}

		// Choose a random triangle, weighted by area
		var whichTriangle:Int = 0;
		var pick:Float = FlxG.random.float(0, totalArea);
		while (pick > areas[whichTriangle])
		{
			pick -= areas[whichTriangle];
			whichTriangle++;
		}

		var p0:FlxPoint = triangles[whichTriangle][0];
		var p1:FlxPoint = triangles[whichTriangle][1];
		var p2:FlxPoint = triangles[whichTriangle][2];

		// Choose a random point within that triangle
		var r1:Float = FlxG.random.float();
		var r2:Float = FlxG.random.float();

		var result:FlxPoint = new FlxPoint();
		result.x += (1 - Math.sqrt(r1)) * p0.x;
		result.y += (1 - Math.sqrt(r1)) * p0.y;

		result.x += Math.sqrt(r1) * (1 - r2) * p1.x;
		result.y += Math.sqrt(r1) * (1 - r2) * p1.y;

		result.x += r2 * Math.sqrt(r1) * p2.x;
		result.y += r2 * Math.sqrt(r1) * p2.y;
		return result;
	}

	/**
	 * Calculate the area of a triangle defined by the specified three points
	 *
	 * @param	p0 The first point
	 * @param	p1 The second point
	 * @param	p2 The third point
	 * @return The area of a triangle defined by those three points
	 */
	public static function area(p0:FlxPoint, p1:FlxPoint, p2:FlxPoint):Float
	{
		// Heron's formula
		var a:Float = p0.distanceTo(p1);
		var b:Float = p1.distanceTo(p2);
		var c:Float = p2.distanceTo(p0);
		var s:Float = (a + b + c) / 2;
		return Math.sqrt(s * (s - a) * (s - b) * (s - c));
	}
}
