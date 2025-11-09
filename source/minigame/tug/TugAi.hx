package minigame.tug;
import critter.Critter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * The AI for the tug-of-war minigame.
 *
 * TugAiPlanner comes up with the actual strategy for the AI to follow. This
 * class mostly handles moving the hand around in an organic way, picking up
 * and dropping bugs, and pausing to think.
 */
class TugAi implements IFlxDestroyable
{
	private var alphaTween:FlxTween;
	private var tugGameState:TugGameState;
	private var currState:Float->Void;
	private var handSprite:FlxSprite;
	private var handDirection:FlxPoint = FlxPoint.get(0, 0);

	private var fromRow:Int = -1;
	private var movedCritter:Critter = null;
	private var toRow:Int = -1;
	private var toPoint:FlxPoint = FlxPoint.get();

	// radians per second
	private var offsetAngleRadians:Float = 0;

	private var planner:TugAiPlanner;
	private var menPerRow:Array<Int> = [];

	private var planTimer:Float = 0;
	private var menPerRowTimer:Float = 0;
	private var doSomethingDelay:Float = 0.1;
	private var doSomethingTimer:Float = 0;

	private var prevToRow:Int = -1;
	private var prevFromRow:Int = -1;
	private var mouseSpeed:Float = 50;

	private var breakCounter:Int = 0;

	private var consecutiveMovements:Array<Int> = [];
	private var breakDurations:Array<Float> = [];

	private var idleTimer:Float = 5;
	private var thinkingFace:Bool = false;

	private var recalculateMistakeTimer:Float = 0;
	public var agent:TugAgent;

	public function new(tugGameState:TugGameState, agent:TugAgent=null)
	{
		this.tugGameState = tugGameState;
		if (agent == null)
		{
			agent = tugGameState.agent;
		}
		this.agent = agent;

		handSprite = new FlxSprite(100, 100);
		handSprite.loadGraphic(AssetPaths.tug_gloves__png, true, 320, 320);
		handSprite.animation.frameIndex = agent.handFrames[0];
		handSprite.alpha = 0;

		handSprite.setSize(10, 10);
		handSprite.offset.set(155, 155);
		tugGameState._hud.add(handSprite);
		currState = waiting;

		planner = new TugAiPlanner(tugGameState);
		recalculateMistakeTimer = FlxG.random.float(4, 12);
	}

	public function doTutorialDrop():Void
	{
		startRound();
		tugGameState._eventStack.addEvent({time:tugGameState._eventStack._time + 0.5, callback:eventTutorialDrop});
		tugGameState._eventStack.addEvent({time:tugGameState._eventStack._time + 2.5, callback:eventStopTutorialAi});
	}

	function eventTutorialDrop(args:Array<Dynamic>)
	{
		menPerRow = [2, 5, 3];
		doSomethingTimer = 0;
		breakCounter = 99;
	}

	function eventStopTutorialAi(args:Array<Dynamic>)
	{
		menPerRow = [];
		stopRound();
	}

	public function startRound():Void
	{
		planner.startRound();
		handSprite.animation.frameIndex = agent.handFrames[0];

		planner.computeWinPlan();
		menPerRow = planner.computeMenPerRow();
		planTimer = agent.planDelay * FlxG.random.float(0.5, 1.5);
		menPerRowTimer = agent.menPerRowDelay * FlxG.random.float(0.5, 1.5);

		alphaTween = FlxTweenUtil.retween(alphaTween, handSprite, {alpha:0.3}, 0.5);
	}

	private function selectRandomInt(ints:Array<Int>):Int
	{
		return ints.length == 0 ? -1 : FlxG.random.getObject(ints);
	}

	public function waiting(elapsed:Float)
	{
		idleTimer -= elapsed;
		if (idleTimer <= 0)
		{
			toPoint.x = FlxG.random.float(50, FlxG.width / 2 - 150);
			toPoint.y = FlxG.random.float(50, FlxG.height - 50);
			idleTimer = FlxG.random.float(0.5, 2.0);
			currState = moveIdle;
		}

		doSomethingTimer -= elapsed;
		if (doSomethingTimer <= 0)
		{
			doSomethingTimer = Math.max(0, doSomethingTimer + doSomethingDelay);

			breakCounter--;
			if (breakCounter <= 0)
			{
				resetBreakCounter();

				if (breakDurations.length == 0)
				{
					breakDurations = breakDurations.concat(agent.breakDurations);
					breakDurations = breakDurations.concat(agent.breakDurations);
					FlxG.random.shuffle(breakDurations);
				}
				doSomethingTimer += breakDurations.pop() * FlxG.random.float(0.8, 1.2);
			}

			if (tugGameState.decideMatchTimer > 0)
			{
				// don't try to move critters at last second
				return;
			}

			var fromRows:Array<Int> = [];
			var toRows:Array<Int> = [];
			for (row in 0...tugGameState.tugRows.length)
			{
				if (tugGameState.tugRows[row].leftCritters.length > menPerRow[row])
				{
					fromRows.push(row);
				}
				if (tugGameState.tugRows[row].leftCritters.length < menPerRow[row])
				{
					toRows.push(row);
				}
			}
			fromRow = selectRandomInt(fromRows);
			toRow = selectRandomInt(toRows);

			if (fromRow == -1 || toRow == -1 || fromRow == toRow)
			{
				// couldn't decide on anything to move... this counts as our break
				if (thinkingFace)
				{
					thinkingFace = false;
					tugGameState.opponentChatFace.animation.frameIndex = FlxG.random.getObject(agent.neutralFaces);
				}
				resetBreakCounter();
				return;
			}

			if (tugGameState.tugRows[fromRow].isRowDecided() || tugGameState.tugRows[toRow].isRowDecided())
			{
				// rows have been decided already...
				return;
			}

			determineMovedCritter();

			if (movedCritter != null)
			{
				if (!thinkingFace)
				{
					thinkingFace = true;
					tugGameState.opponentChatFace.animation.frameIndex = FlxG.random.getObject(agent.thinkyFaces);
				}
				idleTimer = FlxG.random.float(4, 8);
				currState = moveToGrab;
			}
		}
	}

	function resetBreakCounter()
	{
		if (consecutiveMovements.length == 0)
		{
			consecutiveMovements = consecutiveMovements.concat(agent.consecutiveMovements);
			consecutiveMovements = consecutiveMovements.concat(agent.consecutiveMovements);
			FlxG.random.shuffle(consecutiveMovements);
		}
		breakCounter = consecutiveMovements.pop() + FlxG.random.getObject([ -1, 0, 1], [1, 3, 1]);
	}

	private function determineMovedCritter():Void
	{
		var crittersToMove:Array<Critter> = tugGameState.tugRows[fromRow].leftCritters.copy();
		FlxG.random.shuffle(crittersToMove);

		movedCritter = null;
		for (critter in crittersToMove)
		{
			if (tugGameState.model.getCritterColumn(critter) != -1)
			{
				movedCritter = critter;
				break;
			}
		}

		if (movedCritter != null)
		{
			toPoint.x = movedCritter._bodySprite.x + movedCritter._bodySprite.width / 2 - handSprite.width / 2;
			toPoint.y = movedCritter._bodySprite.y + movedCritter._bodySprite.height / 2 - handSprite.height / 2;
			mouseSpeed = agent.mouseSpeed * FlxG.random.float(0.8, 1.2);
		}
	}

	public function moveToGrab(elapsed:Float)
	{
		if (tugGameState.model.getCritterColumn(movedCritter) == -1)
		{
			determineMovedCritter();
			if (movedCritter == null)
			{
				// can't find anybody to move!?
				currState = waiting;
				return;
			}
		}

		var reachedDest:Bool = moveHand(elapsed);

		if (reachedDest)
		{
			toPoint.x = movedCritter._bodySprite.x + movedCritter._bodySprite.width / 2 - handSprite.width / 2;
			toPoint.y = movedCritter._bodySprite.y + movedCritter._bodySprite.height / 2 - handSprite.height / 2;
			mouseSpeed = agent.mouseSpeed * FlxG.random.float(0.8, 1.2);

			if (!moveHand(0))
			{
				// critter moved! we're not there yet
			}
			else
			{
				if (!tugGameState.canGrab(movedCritter))
				{
					// oops, can't grab critter... did it jump into a tent?
					movedCritter = null;
					currState = waiting;
					return;
				}

				movedCritter.grab();
				handSprite.animation.frameIndex = agent.handFrames[1];

				tugGameState.unassignFromRow(movedCritter, true);
				toPoint = getCritterTargetLocation();
				currState = moveToDrop;
			}
		}
	}

	public function moveIdle(elapsed:Float)
	{
		idleTimer -= elapsed;
		if (moveHand(elapsed * 0.4) // move hand slower than normal...
				|| idleTimer <= 0)
		{
			idleTimer = FlxG.random.float(4, 8);
			currState = waiting;
		}
	}

	private function getCritterTargetLocation():FlxPoint
	{
		var toCol:Int = tugGameState.model.getTargetCol(movedCritter, toRow);
		var point:FlxPoint = tugGameState.getCritterTargetLocation(movedCritter, toRow, toCol);
		point.x += movedCritter._bodySprite.width / 2;
		point.y += movedCritter._bodySprite.height / 2;
		return point;
	}

	public function moveToDrop(elapsed:Float)
	{
		if (tugGameState.tugRows[toRow].isRowDecided())
		{
			// row's been decided already... put him somewhere else!
			var toRows:Array<Int> = [];
			for (row in 0...tugGameState.tugRows.length)
			{
				if (!tugGameState.tugRows[row].isRowDecided())
				{
					toRows.push(row);
				}
			}
			if (toRows.length == 0)
			{
				// can't find any place for him... just drop him
				currState = waiting;
				return;
			}
			toRow = FlxG.random.getObject(toRows);
			toPoint = getCritterTargetLocation();
		}

		var reachedDest:Bool = moveHand(elapsed);
		movedCritter.setPosition(handSprite.x - 18, handSprite.y + 5);

		if (reachedDest)
		{
			handSprite.animation.frameIndex = agent.handFrames[0];
			tugGameState.assignToRow(movedCritter, toRow);
			SoundStackingFix.play(AssetPaths.drop__mp3);
			currState = waiting;

			prevToRow = toRow;
			prevFromRow = fromRow;
		}
	}

	private function moveHand(elapsed:Float):Bool
	{
		handDirection.x = toPoint.x - handSprite.x;
		handDirection.y = toPoint.y - handSprite.y;

		var dist:Float = handDirection.length;

		handDirection.rotateByRadians(agent.mouseDeviance * 0.5 * Math.PI * Math.sin(offsetAngleRadians));
		handDirection.length = mouseSpeed * elapsed * FlxMath.bound(Math.sqrt(dist), 2, 15);

		handSprite.x += handDirection.x;
		handSprite.y += handDirection.y;

		return dist < 5;
	}

	public function update(elapsed:Float)
	{
		if (!tugGameState.grabEnabled)
		{
			// can't grab; don't bother thinking
			return;
		}

		offsetAngleRadians += agent.mouseJitterPerSecond * 2 * Math.PI * elapsed;
		if (offsetAngleRadians > 2 * Math.PI)
		{
			offsetAngleRadians -= 2 * Math.PI;
		}

		if (tugGameState.tutorial)
		{
			// don't think during tutorial
		}
		else
		{
			planTimer -= elapsed;
			if (planTimer <= 0)
			{
				planTimer = Math.max(0, planTimer + agent.planDelay * FlxG.random.float(0.5, 1.5));
				planner.computeWinPlan();
				menPerRowTimer = 0; // force menPerRow calculation
			}

			menPerRowTimer -= elapsed;
			if (menPerRowTimer <= 0)
			{
				menPerRowTimer = Math.max(0, menPerRowTimer + agent.menPerRowDelay * FlxG.random.float(0.5, 1.5));
				menPerRow = planner.computeMenPerRow();
			}

			recalculateMistakeTimer -= elapsed;
			if (recalculateMistakeTimer <= 0)
			{
				recalculateMistakeTimer += 8;
				planner.generateShouldWins();
			}
		}

		currState(elapsed);
	}

	public function stopRound()
	{
		alphaTween = FlxTweenUtil.retween(alphaTween, handSprite, {alpha:0.0}, 0.5);
		if (movedCritter != null && movedCritter._bodySprite.animation.name == "grab")
		{
			movedCritter.setIdle();
		}
	}

	public function destroy():Void
	{
		alphaTween = FlxTweenUtil.destroy(alphaTween);
		currState = null;
		handSprite = FlxDestroyUtil.destroy(handSprite);
		handDirection = FlxDestroyUtil.put(handDirection);
		toPoint = FlxDestroyUtil.put(toPoint);
		planner = FlxDestroyUtil.destroy(planner);
		menPerRow = null;
		consecutiveMovements = null;
		breakDurations = null;
	}
}