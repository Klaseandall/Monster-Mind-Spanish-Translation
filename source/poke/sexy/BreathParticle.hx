package poke.sexy;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxSpriteUtil;

/**
 * BreathParticle provides logic for a particle to flicker as it dies out.
 */
class BreathParticle extends FlxParticle
{
	override public function reset(X:Float, Y:Float):Void
	{
		super.reset(X, Y);
		FlxSpriteUtil.stopFlickering(this);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (lifespan - age <= 0.4 && !FlxSpriteUtil.isFlickering(this))
		{
			FlxSpriteUtil.flicker(this, 0.4);
		}
	}
}