package;
import flixel.FlxG;
import flixel.effects.particles.FlxParticle;

/**
 * When particles which move especially fast relative to the frame rate, for
 * example 30 pixels per frame, this results in particles being grouped
 * together at 30 pixel intervals, resulting in an unpleasant bunching effect
 *
 * SubframeParticle is an FlxParticle which, when emitted, will behave as
 * though it was emitted a fraction of a frame earlier to counteract this
 * bunching effect.
 */
class SubframeParticle extends FlxParticle
{
	override public function onEmit():Void
	{
		var subFrame:Float = Math.random();
		x -= velocity.x * FlxG.elapsed * subFrame;
		y -= velocity.y * FlxG.elapsed * subFrame;
	}
}