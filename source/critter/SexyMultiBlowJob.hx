package critter;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxDirectionFlags;
import poke.sexy.SexyState;

/**
 * An animation where a bug gives oral sex to a whole bunch of bugs in a row
 */
class SexyMultiBlowJob extends SexyCritterAnim
{
	private var watchCritters:Array<Critter>;
	private var topCritters:Array<Critter>;
	private var botCritter:Critter;
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
		var masturbateCritters:Array<Critter> = [];
		masturbateCritters = masturbateCritters.concat(topCritters);
		masturbateCritters = masturbateCritters.concat(watchCritters);
		FlxG.random.shuffle(masturbateCritters);

		var masturbateCritterFacings:Map<Critter, Int> = new Map<Critter, Int>();
		var masturbateCritterPositions:Map<Critter, FlxPoint> = new Map<Critter, FlxPoint>();

		var jumpTargetAngles:Array<Float> = [0, 60, 120, 180, 240, 300];
		FlxG.random.shuffle(jumpTargetAngles);

		var sexyDoggy0:SexyDoggy = new SexyDoggy(topCritters[0], botCritter);
		{
			var initialWatchers:Array<Critter> = topCritters.slice(1, topCritters.length);
			initialWatchers = initialWatchers.concat(watchCritters);

			for (critter in initialWatchers)
			{
				var jumpTargetAngle:Float = jumpTargetAngles.pop();
				masturbateCritterPositions[critter] = sexyDoggy0.rotateFromJumpTarget(jumpTargetAngle, 50);
				masturbateCritterFacings[critter] = botCritter._bodySprite.x < masturbateCritterPositions[critter].x ? FlxDirectionFlags.LEFT : FlxDirectionFlags.RIGHT;
			}

			for (critter in initialWatchers)
			{
				var sexyMasturbate:SexyMasturbate = new SexyMasturbate(critter, masturbateCritterFacings[critter]);
				sexyMasturbates.push(sexyMasturbate);
				sexyMasturbate.runToAndMasturbate(masturbateCritterPositions[critter]);
			}
		}

		for (topCritter in topCritters)
		{
			botCritter._eventStack.addEvent({time:eventTime - 0.1, callback:maybeNextGuysTurn, args:[topCritter]});

			var sexyBlowJob:SexyBlowJob;
			var topEvents:Array<EventStack.Event> = [];
			var botEvents:Array<EventStack.Event> = [];

			if (topCritter == topCritters[0])
			{
				sexyBlowJob = new SexyBlowJob(topCritter, botCritter);
				topEvents.push({time:eventTime, callback:sexyBlowJob.topRunIntoPositionAndSitBack});
				botEvents.push({time:eventTime += sexyBlowJob.getExpectedTopRunDuration() + FlxG.random.float(0, 0.7), callback:sexyBlowJob.botNotice});
				topEvents.push({time:eventTime += FlxG.random.float(1, 3), callback:sexyBlowJob.startBj});
			}
			else
			{
				sexyBlowJob = new SexyBlowJob(topCritter, botCritter, masturbateCritterFacings[topCritter]);
				topEvents.push({time:eventTime, callback:sexyBlowJob.refresh});
				topEvents.push({time:eventTime, callback:sexyBlowJob.topPoint});
				botEvents.push({time:eventTime += FlxG.random.float(0.2, 1.5), callback:sexyBlowJob.botNotice});
				botEvents.push({time:eventTime += FlxG.random.float(1, 3), callback:sexyBlowJob.botRunIntoPositionAndBlow});
				eventTime += 0.5;
			}

			eventTime += FlxG.random.float(4, 12);

			var pausesWithHandOnHead:Bool = false;
			var pausesWithJerkingOff:Bool = false;
			for (i in 0...2)
			{
				if (FlxG.random.bool())
				{
					pausesWithHandOnHead = true;
				}
				else
				{
					pausesWithJerkingOff = true;
				}
			}

			var tenacity:Float = FlxG.random.float(0, 0.9);
			while (FlxG.random.float(0, 1) < tenacity && eventTime < 300)
			{
				if (pausesWithHandOnHead && !pausesWithJerkingOff || (pausesWithHandOnHead && FlxG.random.bool()))
				{
					topEvents.push({time:eventTime += FlxG.random.float(2, 4), callback:sexyBlowJob.topHandOnHead});
					topEvents.push({time:eventTime += FlxG.random.float(0, 2), callback:sexyBlowJob.topEyesClosed});
					topEvents.push({time:eventTime += FlxG.random.float(3, 8), callback:sexyBlowJob.topHandOffHead});
					topEvents.push({time:eventTime, callback:sexyBlowJob.topEyesHalfOpen});
				}
				else
				{
					botEvents.push({time:eventTime += FlxG.random.float(3, 9), callback:sexyBlowJob.botJerkOff});
					botEvents.push({time:eventTime += FlxG.random.float(1.5, 4.5), callback:sexyBlowJob.botBj});
				}
			}

			topEvents.push({time:eventTime += FlxG.random.float(4, 8), callback:sexyBlowJob.topHandOnHead});
			topEvents.push({time:eventTime += FlxG.random.float(0, 3.0), callback:sexyBlowJob.topEyesClosed});
			if (FlxG.random.bool(40))
			{
				// swallow it
				botEvents.push({time:eventTime += FlxG.random.float(0, 2.0), callback:sexyBlowJob.botSwallow});
				botEvents.push({time:eventTime += FlxG.random.float(3, 7), callback:sexyBlowJob.botSitUp});
			}
			else if (FlxG.random.bool(50))
			{
				// squirt
				botEvents.push({time:eventTime += FlxG.random.float(0, 2.0), callback:sexyBlowJob.botSitUp});
				topEvents.push({time:eventTime, callback:sexyBlowJob.topOrgasm});
				topEvents.push({time:eventTime += FlxG.random.float(3, 5), callback:sexyBlowJob.topEyesHalfOpen});
				eventTime += FlxG.random.float(0, 2);
			}
			else
			{
				// squirt, but then swallow
				botEvents.push({time:eventTime += FlxG.random.float(0, 2.0), callback:sexyBlowJob.botSitUp});
				topEvents.push({time:eventTime, callback:sexyBlowJob.topOrgasm});

				botEvents.push({time:eventTime += FlxG.random.float(1, 3), callback:sexyBlowJob.botSwallow});
				if (FlxG.random.bool())
				{
					topEvents.push({time:eventTime += FlxG.random.getObject([0, 1]), callback:sexyBlowJob.topHandOnHeadSwallow});
				}

				topEvents.push({time:eventTime += FlxG.random.float(3, 5), callback:sexyBlowJob.topEyesHalfOpen});
				botEvents.push({time:eventTime += FlxG.random.float(0, 2), callback:sexyBlowJob.botSitUp});
			}
			botEvents.push({time:eventTime, callback:SexyAnims.eventUnlinkCritters, args:[[topCritter]]});
			topEvents.push({time:eventTime += 0.5, callback:sexyBlowJob.topDone});

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
				var blowJobTime:Float = 999999;
				var cumTime:Float = FlxG.random.float(sexyMasturbate.getExpectedRunDuration() + 0.4, eventTime + 5);
				if (topEventsMap[sexyMasturbate.critter] != null && topEventsMap[sexyMasturbate.critter].length > 0)
				{
					blowJobTime = topEventsMap[sexyMasturbate.critter][0].time;
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
					if (eventTime > blowJobTime - 10)
					{
						// blowing soon; don't add any masturbation events
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