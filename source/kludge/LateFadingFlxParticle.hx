package kludge;
import flixel.effects.particles.FlxParticle;

/**
 * An FlxParticle which fades out after some time passes.
 *
 * Older versions of HaxeFlixel would allow you to set the alpha component to
 * an absurd value such as 500%. This had the benefit that if the alpha
 * component decreased linearly, no visible change would occur until the alpha
 * dipped below 100%. This produced an effect where a particle was 100% visible
 * for awhile, and then faded out after a delay.
 *
 * This class was created to recreate this fading behavior in newer HaxeFlixel
 * versions.
 */
class LateFadingFlxParticle extends FlxParticle
{
	private var lateFade:Float = 0;

	override public function update(elapsed:Float):Void
	{
		if (alphaRange.active == false && lateFade * (age / lifespan) > lateFade - 1)
		{
			alphaRange.active = true;
		}

		super.update(elapsed);
	}

	public function enableLateFade(lateFade:Float)
	{
		this.lateFade = lateFade;
		alphaRange.set(lateFade, 0);
		alphaRange.active = false;
	}
}