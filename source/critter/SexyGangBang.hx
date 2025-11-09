package critter;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxDirectionFlags;

/**
 * An animation where a bunch of bugs take turns fucking the same bug
 */
class SexyGangBang extends SexyCritterAnim
{
	private var botCritter:Critter;
	private var topCritters:Array<Critter>;
	private var watchCritters:Array<Critter>;
	public var eventTime:Float = 0.4;
	private var sexyMasturbates:Array<SexyMasturbate> = [];
	private var topEventsMap:Map<Critter, Array<EventStack.Event>> = new Map<Critter, Array<EventStack.Event>>();
	private var botEventsMap:Map<Critter, Array<EventStack.Event>> = new Map<Critter, Array<EventStack.Event>>();

	public function new(topCritters:Array<Critter>, botCritter:Critter, watchCritters:Array<Critter>)
	{
		super();
		this.watchCritters = watchCritters;
		this.topCritters = topCritters;
		this.botCritter = botCritter;
	}

	public function go()
	{
		{
			var jumpTargetAngles:Array<Float> = [60, 120, 180, 240, 300];
			FlxG.random.shuffle(jumpTargetAngles);
			var sexyDoggy0:SexyDoggy = new SexyDoggy(topCritters[0], botCritter);

			var initialWatchers:Array<Critter> = topCritters.slice(1, topCritters.length);
			initialWatchers = initialWatchers.concat(watchCritters);
			for (critter in initialWatchers)
			{
				var jumpSource:FlxPoint = sexyDoggy0.rotateFromJumpTarget(jumpTargetAngles.pop(), 50);
				var sexyMasturbate:SexyMasturbate = new SexyMasturbate(critter, botCritter._bodySprite.x < jumpSource.x ? FlxDirectionFlags.LEFT : FlxDirectionFlags.RIGHT);
				sexyMasturbates.push(sexyMasturbate);
				sexyMasturbate.runToAndMasturbate(jumpSource);
			}
		}

		var sexyRimming0:SexyRimming = new SexyRimming(topCritters[0], botCritter);
		{
			var _eventTime:Float = 0;
			botCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming0.botWaggle});
			botCritter._eventStack.addEvent({time:_eventTime += 0.8, callback:sexyRimming0.botWait});
		}

		for (topCritter in topCritters)
		{
			botCritter._eventStack.addEvent({time:eventTime - 0.1, callback:maybeNextGuysTurn, args:[topCritter]});

			var sexyRimming:SexyRimming = new SexyRimming(topCritter, botCritter, sexyRimming0.facing);
			var sexyDoggy:SexyDoggy = new SexyDoggy(topCritter, botCritter, sexyRimming0.facing);

			var topEvents:Array<EventStack.Event> = [];
			var botEvents:Array<EventStack.Event> = [];

			if (topCritter == topCritters[0])
			{
				topEvents.push({time:eventTime, callback:sexyDoggy.runToJump});
				topEvents.push({time:eventTime += sexyDoggy.getExpectedRunToJumpDuration(), callback:sexyDoggy.jumpIntoPositionAndStartDoggy});
				topEvents.push({time:eventTime += sexyRimming.getExpectedJumpDuration() + 0.2, callback:sexyDoggy.topPenetrate, args:[0.2]});
			}
			else
			{
				topEvents.push({time:eventTime, callback:sexyDoggy.runIntoPositionAndStartDoggy});
				topEvents.push({time:eventTime += 1.5, callback:sexyDoggy.topPenetrate, args:[1.5]});
			}
			botEvents.push({time:eventTime, callback:sexyDoggy.botEyesClosed});
			topEvents.push({time:eventTime += 2.5, callback:sexyDoggy.topHump, args:[1, 3, false]});
			botEvents.push({time:eventTime + 0.66, callback:sexyDoggy.botEyesOpen, args:[1.5]});
			topEvents.push({time:eventTime += FlxG.random.getObject([3, 6]), callback:sexyDoggy.topHump, args:[1, 2, false]});
			topEvents.push({time:eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 4, false]});
			var tenacity:Float = FlxG.random.float(0, 0.9);
			var spankiness:Int = FlxG.random.int( -60, 60);
			while (FlxG.random.float(0, 1) < tenacity && eventTime < 300)
			{
				// go again?
				topEvents.push({time:eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, false]});
				topEvents.push({time:eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[4, 2, false, FlxG.random.bool(30 + spankiness)]});
			}
			topEvents.push({time:eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, true]});
			topEvents.push({time:eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[4, 2, true, FlxG.random.bool(40 + spankiness)]});
			botEvents.push({time:eventTime + 1.66, callback:sexyDoggy.botOrgasm});
			topEvents.push({time:eventTime += 4, callback:(FlxG.random.bool(30) ? sexyDoggy.topOrgasmPullOut : sexyDoggy.topOrgasm)});
			topEvents.push({time:eventTime += 6.5, callback:sexyDoggy.topAlmostDone});
			botEvents.push({time:eventTime += 1.0, callback:sexyDoggy.botLookBack});
			topEvents.push({time:eventTime += 0.5, callback:SexyAnims.eventUnlinkCritters, args:[[topCritter]]});
			botEvents.push({time:eventTime, callback:sexyDoggy.topDone});
			eventTime += 0.4; // next guy's turn?

			topEventsMap[topCritter] = topEvents;
			botEventsMap[topCritter] = botEvents;
		}

		botCritter._eventStack.addEvent({time:eventTime - 0.1, callback:maybeNextGuysTurn, args:[null]});

		// all critters; top, bottom, spectators
		var allCritters:Array<Critter> = [botCritter];
		allCritters = allCritters.concat(topCritters);
		allCritters = allCritters.concat(watchCritters);
		SexyAnims.critterLinks[botCritter] = allCritters;

		{
			for (sexyMasturbate in sexyMasturbates)
			{
				var fuckTime:Float = 999999;
				var cumTime:Float = FlxG.random.float(sexyMasturbate.getExpectedRunDuration() + 0.4, eventTime + 5);
				if (topEventsMap[sexyMasturbate.critter] != null && topEventsMap[sexyMasturbate.critter].length > 0)
				{
					fuckTime = topEventsMap[sexyMasturbate.critter][0].time;
					// schedule a cum event far in the future; this keeps their event stack alive
					cumTime = 999999;
				}
				else
				{
				}
				var tenacity:Float = FlxG.random.float(0, 0.9);
				var eventTime:Float = cumTime - FlxG.random.float(8, 12);
				var timeCap:Float = 16;
				while (FlxG.random.float(0, 1) < tenacity && eventTime > 6)
				{
					if (eventTime > fuckTime - 10)
					{
						// fucking soon; don't add any masturbation events
					}
					else
					{
						if (!sexyMasturbate.critter.isMale() && FlxG.random.bool())
						{
							sexyMasturbate.critter._eventStack.addEvent({time:eventTime, callback:sexyMasturbate.cum});
							sexyMasturbate.critter._eventStack.addEvent({time:eventTime + FlxG.random.float(6, 7), callback:sexyMasturbate.masturbate});
						}
						else
						{
							sexyMasturbate.critter._eventStack.addEvent({time:eventTime, callback:sexyMasturbate.almostCum});
							sexyMasturbate.critter._eventStack.addEvent({time:eventTime + FlxG.random.float(5, 7), callback:sexyMasturbate.masturbate});
						}
					}
					eventTime -= FlxG.random.float(8, timeCap);
					timeCap += 4;
				}
				sexyMasturbate.critter._eventStack.addEvent({time:cumTime, callback:sexyMasturbate.cum});
				// now that i've cum, i shouldn't depend on anybody, and they shouldn't depend on me
				sexyMasturbate.critter._eventStack.addEvent({time:cumTime, callback:SexyAnims.eventUnlinkCritters, args:[[sexyMasturbate.critter]]});
				sexyMasturbate.critter._eventStack.addEvent({time:cumTime, callback:critterDone, args:[sexyMasturbate.critter]});
			}
		}
	}

	public function maybeNextGuysTurn(args:Array<Dynamic>)
	{
		var topCritter:Critter = args[0];
		if (topCritter == null || SexyAnims.critterLinks[botCritter].indexOf(topCritter) == -1)
		{
			// top critter was interrupted, or there aren't any more... animation should end
			botCritter._eventStack.addEvent({time:botCritter._eventStack._time + 0.1, callback:SexyAnims.eventUnlinkCritters, args:[[botCritter]]});
			botCritter._eventStack.addEvent({time:botCritter._eventStack._time + 0.1, callback:botDone});
			return;
		}
		SexyAnims.critterLinks[topCritter] = SexyAnims.critterLinks[botCritter].copy();
		for (event in topEventsMap[topCritter])
		{
			topCritter._eventStack.addEvent(event);
		}
		for (event in botEventsMap[topCritter])
		{
			botCritter._eventStack.addEvent(event);
		}
	}

	public function botDone(args:Array<Dynamic>)
	{
		done(botCritter);
	}

	public function critterDone(args:Array<Dynamic>)
	{
		var critter:Critter = args[0];
		done(args[0]);
	}
}