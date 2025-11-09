package critter;

/**
 * A parent class for sexy animations between bugs.
 */
class SexyCritterAnim
{
	public function new()
	{
	}

	public function stopSexyAnim(critter:Critter)
	{
		critter.playAnim("idle");
		critter._bodySprite.animation.remove("sexy-misc");
		critter._headSprite.animation.remove("sexy-misc");
		critter._frontBodySprite.animation.remove("sexy-misc");
	}

	public function done(critter:Critter)
	{
		stopSexyAnim(critter);
		critter.setIdle();
		critter.setImmovable(false);
	}

	public function eventStopSexyAnim(args:Array<Dynamic>)
	{
		var critter:Critter = args[0];
		stopSexyAnim(critter);
	}
}