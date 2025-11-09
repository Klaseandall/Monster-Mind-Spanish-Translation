package;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxMath;

/**
 * A particle which spawns a specified distance from an object. This is
 * sometimes desirable to give a "poof effect" instead of a "spark effect".
 */
class MinRadiusParticle extends FlxParticle
{
	private var _radius:Float = 0;

	public function new(radius:Float)
	{
		super();
		this._radius = radius;
	}

	override public function onEmit():Void
	{
		if (velocity.x != 0 || velocity.y != 0)
		{
			var vdx:Float = velocity.x;
			var vdy:Float = velocity.y;
			var a:Float = Math.sqrt((_radius * _radius) / (vdx * vdx + vdy * vdy));
			x += vdx * a;
			y += vdy * a;
		}
	}
}