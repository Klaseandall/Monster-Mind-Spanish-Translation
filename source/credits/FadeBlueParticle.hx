package credits;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxColor;

/**
 * A particle that fades from white to midnight blue. Used in the ending
 * animation
 */
class FadeBlueParticle extends FlxParticle
{
	public function new()
	{
		super();
		setColor(0xffffffff);
	}

	private function setColor(color:FlxColor)
	{
		this.color = color;
		makeGraphic(1, 1, color);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (age > lifespan * 0.3 && age <= lifespan * 0.6 && color != 0xff7fe4ff)
		{
			setColor(0xff7fe4ff);
		}
		else if (age > lifespan * 0.6 && color != 0xff40a4c0)
		{
			setColor(0xff40a4c0);
		}
	}

	override public function reset(X:Float, Y:Float):Void
	{
		super.reset(X, Y);
		setColor(0xffffffff);
	}
}