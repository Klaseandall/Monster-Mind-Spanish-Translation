package critter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxDirectionFlags;

/**
 * An animation where two bugs masturbate with each other
 */
class SexyMutualMasturbate extends SexyCritterAnim
{
	private var critters:Array<Critter>;
	private var sexyMasturbates:Array<SexyMasturbate> = [];

	public function new(critters:Array<Critter>)
	{
		super();
		this.critters = critters;
	}

	public function go(doFinish:Bool = true, movable:Bool = true):Float
	{
		var bigFinish:Bool = FlxG.random.bool(20);
		if (!doFinish)
		{
			// critters aren't cumming; just keep them doing stuff
			bigFinish = false;
		}

		var positions:Array<FlxPoint>;
		var facings:Array<Int>;
		if (FlxG.random.bool())
		{
			positions = [
				FlxPoint.get(critters[0]._soulSprite.x + 0, critters[0]._soulSprite.y + 0),
				FlxPoint.get(critters[0]._soulSprite.x + 40, critters[0]._soulSprite.y + FlxG.random.int(-10, 30)),
				FlxPoint.get(critters[0]._soulSprite.x + -40, critters[0]._soulSprite.y + FlxG.random.int(-10, 30)),
				FlxPoint.get(critters[0]._soulSprite.x + 80, critters[0]._soulSprite.y + FlxG.random.int(-20, 60)),
			];
			facings = [
				FlxDirectionFlags.RIGHT,
				FlxDirectionFlags.LEFT,
				FlxDirectionFlags.RIGHT,
				FlxDirectionFlags.LEFT,
			];
		}
		else {
			positions = [
				FlxPoint.get(critters[0]._soulSprite.x + 0, critters[0]._soulSprite.y + 0),
				FlxPoint.get(critters[0]._soulSprite.x + -40, critters[0]._soulSprite.y + FlxG.random.int(-10, 30)),
				FlxPoint.get(critters[0]._soulSprite.x + 40, critters[0]._soulSprite.y + FlxG.random.int(-10, 30)),
				FlxPoint.get(critters[0]._soulSprite.x + -80, critters[0]._soulSprite.y + FlxG.random.int(-20, 60)),
			];
			facings = [
				FlxDirectionFlags.LEFT,
				FlxDirectionFlags.RIGHT,
				FlxDirectionFlags.LEFT,
				FlxDirectionFlags.RIGHT,
			];
		}

		var bigFinishTime:Float = 99999;
		for (i in 0...critters.length)
		{
			var sexyMasturbate = new SexyMasturbate(critters[i], facings[i]);
			sexyMasturbate.runToAndMasturbate(positions[i]);

			var eventTime:Float = 0;
			eventTime += sexyMasturbate.getExpectedRunDuration();

			if (movable)
			{
				sexyMasturbate.critter._eventStack.addEvent({time:eventTime + 0.3, callback:eventMakeCritterMovable, args:[critters[i]]});
			}

			var tenacity:Float = FlxG.random.float(0, 0.9);
			while (FlxG.random.float(0, 1) < tenacity && eventTime < bigFinishTime - 8)
			{
				eventTime += FlxG.random.float(2, 8);
				if (!sexyMasturbate.critter.isMale() && FlxG.random.bool())
				{
					sexyMasturbate.critter._eventStack.addEvent({time:eventTime, callback:sexyMasturbate.cum});
					sexyMasturbate.critter._eventStack.addEvent({time:eventTime += FlxG.random.float(6, 7), callback:sexyMasturbate.masturbate});
				}
				else
				{
					sexyMasturbate.critter._eventStack.addEvent({time:eventTime, callback:sexyMasturbate.almostCum});
					sexyMasturbate.critter._eventStack.addEvent({time:eventTime += FlxG.random.float(5, 7), callback:sexyMasturbate.masturbate});
				}
			}
			if (doFinish)
			{
				if (bigFinish)
				{
					if (i == 0)
					{
						while (eventTime < 10)
						{
							eventTime += FlxG.random.float(4, 24);
						}
						bigFinishTime = eventTime;
					}
					else
					{
						eventTime = Math.max(bigFinishTime, eventTime) + FlxG.random.float(-1, 1);
					}
				}
				else
				{
					while (eventTime < 10)
					{
						eventTime += FlxG.random.float(4, 24);
					}
				}
				sexyMasturbate.critter._eventStack.addEvent({time:eventTime, callback:sexyMasturbate.cum});
			}
			else
			{
				if (i == 0)
				{
					while (eventTime < 10)
					{
						eventTime += FlxG.random.float(4, 24);
					}
					bigFinishTime = eventTime;
				}
			}
		}
		return bigFinishTime;
	}

	public function eventMakeCritterMovable(args:Array<Dynamic>)
	{
		var critter:Critter = args[0];
		critter.setImmovable(false);
	}
}