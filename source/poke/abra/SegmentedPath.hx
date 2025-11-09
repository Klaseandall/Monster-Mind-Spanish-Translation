package poke.abra;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * SegmentedPath represents a connected series of line segments. This is used
 * for rendering anal beads
 */
class SegmentedPath implements IFlxDestroyable
{
	public var nodes:Array<FlxPoint> = [];
	private var _point:FlxPoint = FlxPoint.get();

	public function new() {}

	public function pushNode(x:Float, y:Float):Void
	{
		nodes.push(FlxPoint.get(x, y));
	}

	public function getPathPoint(dist:Float, ?target:FlxPoint):FlxPoint
	{
		if (target == null)
		{
			target = FlxPoint.get();
		}
		var nodeIndex:Int = 0;
		var distTmp:Float = dist;

		for (nodeIndex in 1...nodes.length)
		{
			var dx:Float = nodes[nodeIndex].x - nodes[nodeIndex - 1].x;
			var dy:Float = nodes[nodeIndex].y - nodes[nodeIndex - 1].y;
			var segmentDistance:Float = Math.sqrt(dx * dx + dy * dy);
			if (distTmp <= segmentDistance)
			{
				var vector:FlxPoint = _point.set(dx, dy).normalize();
				return target.set(nodes[nodeIndex - 1].x + distTmp * vector.x, nodes[nodeIndex - 1].y + distTmp * vector.y);
			}
			distTmp -= segmentDistance;
		}
		return target.copyFrom(nodes[nodes.length - 1]);
	}

	public function destroy()
	{
		nodes = null;
		_point = FlxDestroyUtil.destroy(_point);
	}
}