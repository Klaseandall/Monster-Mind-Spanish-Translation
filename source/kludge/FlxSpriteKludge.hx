package kludge;
import flixel.FlxSprite;
import kludge.LateFadingFlxParticle;

/**
 * Various hacky workarounds for bugs and idiosynchracies in HaxeFlixel
 */
class FlxSpriteKludge
{
	/**
	 * Workaround for https://github.com/HaxeFlixel/flixel/issues/2100 -- FlxG.overlap() produces strange results sometimes.
	 *
	 * Additionally, this is a more performant way of checking for collision of two sprites since it does not use a quadtree.
	 */
	public static inline function overlap(s0:FlxSprite, s1:FlxSprite)
	{
		return s0.x <= s1.x + s1.width && s1.x <= s0.x + s0.width && s0.y <= s1.y + s1.height && s1.y <= s0.y + s0.height;
	}

	/**
	 * When recycled, FlxParticles are curved in random directions because... why wouldn't they be!
	 *
	 * https://www.reddit.com/r/haxeflixel/comments/752pqj/unexpected_flxemitter_behavior_when_in_square_mode/
	 */
	public static function unfuckParticle(particle:LateFadingFlxParticle)
	{
		particle.velocityRange.end.set(particle.velocityRange.start.x, particle.velocityRange.start.y);
		particle.accelerationRange.end.set(particle.accelerationRange.start.x, particle.accelerationRange.start.y);
	}
}