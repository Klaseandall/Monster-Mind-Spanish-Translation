package poke.sand;

import flixel.math.FlxMath;
import poke.buiz.DildoInterface;
import poke.buiz.DildoInterface.*;

/**
 * The simplistic window on the side which lets the user interact with
 * Sandslash's dildo sequence
 */
class SandslashDildoInterface extends DildoInterface
{
	public function new()
	{
		super(PlayerData.sandMale);
		setBigDildo();
	}

	override public function computeAnim(arrowDist:Float)
	{
		if (arrowDist <= ARROW_INSIDE_THRESHOLD)
		{
			// inside; use the dildo
			dildoSprite.visible = true;
			animName = ass ? "dildo-ass" : "dildo-vag";
			computeAnimPct(ARROW_MIN_THRESHOLD, ARROW_INSIDE_THRESHOLD);
		}
		else if (arrowDist <= ARROW_OUTSIDE_THRESHOLD)
		{
			// slightly closer; finger the vagina
			dildoSprite.visible = false;
			animName = ass ? "finger-ass" : "finger-vag";
			computeAnimPct(ARROW_INSIDE_THRESHOLD, ARROW_OUTSIDE_THRESHOLD);
		}
		else
		{
			// far outside; just rub the vagina
			dildoSprite.visible = false;
			animName = ass ? "rub-ass" : "rub-vag";
			computeAnimPct(ARROW_OUTSIDE_THRESHOLD, ARROW_MAX_THRESHOLD);
		}
	}

	/**
	 * Sandslash gets grumpy if you don't go deep enough. But even Sandslash
	 * has his limits. This method returns the maximum depth which is currently
	 * clickable when using the dildo on Sandslash
	 *
	 * @return the maximum depth which is attainable for sandslash [0, 1.0]
	 */
	public function getMaxAnimPct():Float
	{
		var maxDist:Float = 0;
		if (ass)
		{
			maxDist = assTightness * 40;
		}
		else {
			maxDist = vagTightness * 40;
		}
		return FlxMath.bound((maxDist - ARROW_INSIDE_THRESHOLD) / (ARROW_MIN_THRESHOLD - ARROW_INSIDE_THRESHOLD), 0, 1.0);
	}
}