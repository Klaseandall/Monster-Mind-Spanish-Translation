package poke.luca;

import poke.buiz.DildoInterface;
import poke.buiz.DildoInterface.*;

/**
 * The simplistic window on the side which lets the user interact with
 * Lucario's dildo sequence
 */
class LucarioDildoInterface extends DildoInterface
{
	public function new()
	{
		super(PlayerData.lucaMale);
		setLittleDildo();
		setAssButtonFlipped(true);
	}

	override public function computeAnim(arrowDist:Float)
	{
		if (arrowDist <= ARROW_DEEP_INSIDE_THRESHOLD)
		{
			// far inside; push the dildo the rest of the way
			dildoSprite.visible = true;
			animName = ass ? "dildo-ass1" : "dildo-vag1";
			computeAnimPct(ARROW_MIN_THRESHOLD, ARROW_DEEP_INSIDE_THRESHOLD);
		}
		else if (arrowDist <= ARROW_INSIDE_THRESHOLD)
		{
			// inside; use the dildo
			dildoSprite.visible = true;
			animName = ass ? "dildo-ass0" : "dildo-vag0";
			computeAnimPct(ARROW_DEEP_INSIDE_THRESHOLD, ARROW_INSIDE_THRESHOLD);
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
}