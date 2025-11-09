package critter;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import kludge.BetterFlxRandom;
import puzzle.PuzzleState;

/**
 * Complex idle animations for bugs. This includes animations where one bug
 * does a few things in a row, and animations with multiple bugs
 */
class IdleAnims
{
	public function new()
	{
	}

	public static function playComplex(critter:Critter, animName:String)
	{
		var targetSprite:FlxSprite = critter._targetSprite;
		var soulSprite:FlxSprite = critter._soulSprite;
		var bodySprite:CritterBody = critter._bodySprite;
		var eventStack:EventStack = critter._eventStack;

		bodySprite._idleTimer = CritterBody.IDLE_FREQUENCY * FlxG.random.float(0.9, 1.11);
		if (animName == "complex-figure8")
		{
			eventStack.reset();
			var direction:Float = FlxG.random.float(0, 2 * Math.PI);
			var duration:Float = FlxG.random.float(4, 8);
			var granularity:Float = 0.25;
			var time:Float = 0;
			while (time < duration)
			{
				eventStack.addEvent({time:time, callback:critter.eventRunDirRadians, args:[direction]});

				time += granularity;
				if (time < duration / 2)
				{
					direction += (granularity / duration) * 2 * 2 * Math.PI;
				}
				else
				{
					direction -= (granularity / duration) * 2 * 2 * Math.PI;
				}
			}
			eventStack.addEvent({time:time, callback:critter.eventStop});
			return;
		}
		if (animName == "complex-incomplete-figure8")
		{
			eventStack.reset();
			var direction:Float = FlxG.random.float(0, 2 * Math.PI);
			var duration:Float = FlxG.random.float(4, 8);
			var granularity:Float = 0.25;
			var time:Float = 0;
			var f:Float = FlxG.random.float(0.4, 1.0);
			while (time < duration * f)
			{
				eventStack.addEvent({time:time, callback:critter.eventRunDirRadians, args:[direction]});

				time += granularity;
				if (time < duration / 2)
				{
					direction += (granularity / duration) * 2 * 2 * Math.PI;
				}
				else
				{
					direction -= (granularity / duration) * 2 * 2 * Math.PI;
				}
			}
			eventStack.addEvent({time:time, callback:critter.eventStop});
			return;
		}
		if (animName == "complex-chase-tail")
		{
			eventStack.reset();
			var direction:Float = FlxG.random.float(0, 2 * Math.PI);
			var duration:Float = FlxG.random.float(6, 12);
			var granularity:Float = 0.23;
			var time:Float = 0;
			var circleDirection:Float = FlxG.random.float(1.4, 1.8) * FlxG.random.sign();
			while (time < duration)
			{
				eventStack.addEvent({time:time, callback:critter.eventRunDirRadians, args:[direction]});

				time += granularity;
				direction += granularity * circleDirection * Math.PI * FlxG.random.float(0.5, 1.5);
			}
			eventStack.addEvent({time:time, callback:critter.eventStop});
			return;
		}
		if (animName == "complex-amble")
		{
			eventStack.reset();
			var direction:Float = FlxG.random.float(0, 2 * Math.PI);
			var duration:Float = FlxG.random.float(4, 8);
			var granularity:Float = 0.15;
			var time:Float = 0;
			bodySprite._walkSpeed = 85;
			var mystery0:Float = FlxG.random.float(0.5, 1.5);
			var mystery1:Float = FlxG.random.float(0.5, 1.5);
			while (time < duration)
			{
				eventStack.addEvent({time:time, callback:critter.eventRunDirRadians, args:[direction]});

				time += granularity;
				if (time % 2 < mystery1)
				{
					direction += granularity * Math.PI * mystery0;
				}
				else
				{
					direction -= granularity * Math.PI * mystery0;
				}
			}
			eventStack.addEvent({time:time, callback:critter.eventStop});
			return;
		}
		if (animName == "complex-leave-and-return")
		{
			var direction:Float = FlxG.random.float(0, 2 * Math.PI);
			var dx:Float = 40 * Math.cos(direction);
			var dy:Float = 40 * Math.sin(direction);

			targetSprite.x = soulSprite.x;
			targetSprite.y = soulSprite.y;
			while (targetSprite.x >= -80 && targetSprite.y <= FlxG.width + 80 && targetSprite.y >= -80 && targetSprite.y <= FlxG.height + 80)
			{
				targetSprite.x += dx;
				targetSprite.y += dy;
			}
			eventStack.reset();
			var projectedTime:Float = getProjectedTime(critter, targetSprite.getPosition(), soulSprite.getPosition());
			var time:Float = 0;
			eventStack.addEvent({time:0, callback:critter.eventRunTo, args:[targetSprite.x, targetSprite.y]});
			time += projectedTime + 0.5;
			time += FlxG.random.bool() ? FlxG.random.float(10, 20) : FlxG.random.float(40, 80);
			eventStack.addEvent({time:time, callback:critter.eventRunTo, args:[soulSprite.x, soulSprite.y]});
			time += projectedTime + 0.5;
			eventStack.addEvent({time:time, callback:critter.eventStop});
		}
		if (animName == "complex-hop")
		{
			var duration:Float = FlxG.random.float(3, 5);
			eventStack.reset();
			eventStack.addEvent({time:FlxG.random.float(0, 0.6), callback:eventHopContinuously, args:[critter]});
			eventStack.addEvent({time:duration, callback:eventStopHopping, args:[critter]});
		}
	}

	public static function eventHopContinuously(args:Array<Dynamic>)
	{
		var critter:Critter = args[0];
		creventHopContinuously(critter);
	}

	public static function creventHopContinuously(critter:Critter)
	{
		var direction:Float = FlxG.random.float(0, 2 * Math.PI);
		var dist:Float = FlxG.random.float(20, 80);
		var dx:Float = dist * Math.cos(direction);
		var dy:Float = dist * Math.sin(direction);
		critter.jumpTo(critter._soulSprite.x + dx, critter._soulSprite.y + dy, 0, creventHopContinuously);
	}

	public static function eventStopHopping(args:Array<Dynamic>)
	{
		var critter:Critter = args[0];
		critter._runToCallback = creventStopHopping;
	}

	public static function creventStopHopping(critter:Critter)
	{
		critter.playAnim(FlxG.random.getObject(["idle-happy0", "idle-happy1", "idle-happy2"]));
	}

	public static function getProjectedTime(critter:Critter, from:FlxPoint, to:FlxPoint)
	{
		return from.distanceTo(to) / critter._bodySprite._walkSpeed;
	}

	public static function playGlobalAnim(puzzleState:PuzzleState, animName:String)
	{
		puzzleState._globalIdleTimer = LevelState.GLOBAL_IDLE_FREQUENCY * FlxG.random.float(0.9, 1.11);
		if (animName == "global-enter")
		{
			// find an offscreen critter
			var critter:Critter = puzzleState.findExtraCritter();
			if (critter == null)
			{
				// nothing left... unlikely but possible
				return;
			}
			// upper left: [8, 36]
			var x:Float = FlxG.random.float(8, FlxG.width - 48);
			var y:Float = FlxG.random.float(36, FlxG.height - 24);
			critter.runTo(x, y);
		}
		if (animName == "global-leave")
		{
			var critter:Critter = puzzleState.findIdleCritter();
			if (critter == null)
			{
				return;
			}
			var direction:Float = FlxG.random.float(0, 2 * Math.PI);
			var dx:Float = 40 * Math.cos(direction);
			var dy:Float = 40 * Math.sin(direction);

			critter._targetSprite.x = critter._soulSprite.x;
			critter._targetSprite.y = critter._soulSprite.y;
			while (critter._targetSprite.x >= -80 && critter._targetSprite.x <= FlxG.width + 80 && critter._targetSprite.y >= -80 && critter._targetSprite.y <= FlxG.height + 80)
			{
				critter._targetSprite.x += dx;
				critter._targetSprite.y += dy;
			}
			critter.runTo(critter._targetSprite.x, critter._targetSprite.y);
			return;
		}
		if (animName == "global-leave-many")
		{
			var idleCritterCount = puzzleState.getIdleCritterCount();
			var critters:Array<Critter> = puzzleState.findIdleCritters(Math.round(idleCritterCount * FlxG.random.float(0.26, 0.4)));
			FlxG.random.shuffle(critters);
			if (critters.length == 0)
			{
				return;
			}
			var dx:Float = 0;
			var dy:Float = 0;
			for (i in 1...critters.length)
			{
				dx += (critters[0]._soulSprite.x - critters[i]._soulSprite.x);
				dy += (critters[0]._soulSprite.y - critters[i]._soulSprite.y);
			}
			var maxProjectedTime:Float = 0;
			for (i in 1...critters.length)
			{
				maxProjectedTime = Math.max(maxProjectedTime, getProjectedTime(critters[i], critters[i]._soulSprite.getPosition(), critters[0]._soulSprite.getPosition()));
			}
			if (dx == 0 && dy == 0)
			{
				dx = FlxG.random.float(0.1, 1.0) * FlxG.random.sign();
				dy = FlxG.random.float(0.1, 1.0) * FlxG.random.sign();
			}
			var dMagnitude:Float = Math.sqrt(dx * dx + dy * dy);
			dx = 100 / dMagnitude;
			dy = 100 / dMagnitude;
			var offscreenPoint:FlxPoint = critters[0]._soulSprite.getPosition();
			while (offscreenPoint.x >= -80 && offscreenPoint.x <= FlxG.width + 80 && offscreenPoint.y >= -80 && offscreenPoint.y <= FlxG.height + 80)
			{
				offscreenPoint.x += dx;
				offscreenPoint.y += dy;
			}
			var projectedTime1:Float = getProjectedTime(critters[0], critters[0]._soulSprite.getPosition(), offscreenPoint);
			for (i in 1...critters.length)
			{
				critters[i]._eventStack.reset();
				var dest:FlxPoint = critters[0]._soulSprite.getPosition();
				dest.x += FlxG.random.float( -60, 60);
				dest.y += FlxG.random.float( -30, 30);
				var projectedTime0:Float = getProjectedTime(critters[i], critters[i]._soulSprite.getPosition(), dest);
				critters[i]._eventStack.addEvent({time:maxProjectedTime - projectedTime0, callback:critters[i].eventRunTo, args:[dest.x, dest.y]});
			}
			for (i in 0...critters.length)
			{
				critters[i]._eventStack.addEvent({time:maxProjectedTime, callback:critters[i].eventRunTo, args:[offscreenPoint.x + FlxG.random.float( -40, 40), offscreenPoint.y + FlxG.random.float( -20, 20)]});
				critters[i]._eventStack.addEvent({time:maxProjectedTime + projectedTime1, callback:critters[i].eventStop});
			}
		}
		if (animName == "global-enter-many")
		{
			var critters:Array<Critter> = puzzleState.findIdleCritters(FlxG.random.int(1, 3));
			FlxG.random.shuffle(critters);
			var extraCritters:Array<Critter> = puzzleState.findExtraCritters(FlxG.random.int(1, 4));
			critters = critters.concat(extraCritters);
			for (i in 1...critters.length)
			{
				var dest:FlxPoint = critters[0]._soulSprite.getPosition();
				dest.x += FlxG.random.float( -60, 60);
				dest.y += FlxG.random.float( -30, 30);
				var projectedTime0:Float = getProjectedTime(critters[i], critters[i]._soulSprite.getPosition(), dest);
				var start:Float = FlxG.random.float(0, 1);
				critters[i]._eventStack.reset();
				critters[i]._eventStack.addEvent({time:start, callback:critters[i].eventRunTo, args:[dest.x, dest.y]});
				critters[i]._eventStack.addEvent({time:start + projectedTime0, callback:critters[i].eventStop});
			}
		}
	}
}