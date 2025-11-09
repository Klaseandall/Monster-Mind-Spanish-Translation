package puzzle;
import flixel.FlxG;
import flixel.effects.particles.FlxParticle;

/**
 * A particle which starts out invisible, fades to opaque, and fades back out.
 * This creates sort of a firefly effect.
 */
class GlowyParticle extends FlxParticle
{
	public var glowApex:Float = 0.5;

	override public function onEmit():Void
	{
		super.onEmit();
		alphaRange.active = false;
		alpha = 0;
		glowApex = FlxG.random.float(0.05, 0.95);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (age < glowApex * lifespan)
		{
			alpha = age / (glowApex * lifespan);
		}
		else if (age < lifespan)
		{
			alpha = (lifespan - age) / (lifespan - (glowApex * lifespan));
		}
		else {
			alpha = 0;
		}
	}
}