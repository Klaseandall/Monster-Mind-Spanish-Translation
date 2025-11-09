package poke.rhyd;

/**
 * BreathingSprite is for large sprites which want to animate like
 * a BouncySprite. If the sprite is told to play an animation, this class will
 * instead oscillate through its animation frames like a sine wave.
 */
class BreathingSprite extends BouncySprite
{
	override public function adjustY()
	{
		if (animation.curAnim != null && !animation.curAnim.paused)
		{
			var frameCount:Int = animation.curAnim.frames.length;
			var pseudoOffsetY:Int = Math.round((frameCount - 1) / 2 + (frameCount - 1) * Math.sin((_age + _bouncePhase * _bounceDuration) * (2 * Math.PI / Math.max(_bounceDuration, 0.1))) / 2);
			animation.curAnim.curFrame = pseudoOffsetY;
		}
	}
}