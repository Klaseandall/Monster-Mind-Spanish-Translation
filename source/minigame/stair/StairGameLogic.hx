package minigame.stair;
import minigame.stair.StairGameState.StairStatus;

/**
 * Current state and variables for the stair minigame. Keeps track of things
 * like whose turn it is, how many chests each player has delivered, and how
 * many spaces a bug is currently moving.
 */
class StairGameLogic
{
	var stairGameState:StairGameState;

	// 0: human; 1: com
	public var activePlayer:Int = 0;
	var state:Void->Void;
	public var extraTurn:Bool = false;
	public var remainingMoves:Int = 0;
	public var activeStairStatus:StairStatus;
	public var otherStairStatus:StairStatus;
	public var justCaptured:Bool = false;
	/*
	 * 1: first silver chest obtained
	 * 2: first chest turned in
	 * 3: first gold chest obtained
	 */
	private var milestone:Int = 0;
	public var justReachedMilestone:Bool = false;
	public var tutorial:Bool = false;

	public function new(stairGameState:StairGameState)
	{
		this.stairGameState = stairGameState;
		refreshStairStatusHelpers();
	}

	/**
	 * Reset following a tutorial
	 */
	public function reset():Void
	{
		milestone = 0;
		tutorial = false;
		activePlayer = 0;
		refreshStairStatusHelpers();
	}

	function refreshStairStatusHelpers()
	{
		activeStairStatus = [stairGameState.stairStatus0, stairGameState.stairStatus1][activePlayer];
		otherStairStatus = [stairGameState.stairStatus1, stairGameState.stairStatus0][activePlayer];
	}

	public function eventMoveCritterFromRoll(args:Array<Dynamic>)
	{
		roll(stairGameState.stairStatus0.rollAmount + stairGameState.stairStatus1.rollAmount);
	}

	public function roll(rollAmount:Int)
	{
		justCaptured = false;
		justReachedMilestone = false;
		if (rollAmount == 0 || rollAmount == 4)
		{
			extraTurn = true;
		}
		var moveAmount:Int = rollAmount == 0 ? 4 : rollAmount;
		state = characterMovingState;
		if (!activeStairStatus.hasChest() && activeStairStatus.stairIndex + moveAmount >= 8)
		{
			remainingMoves = activeStairStatus.stairIndex + moveAmount - 8;
		}
		stairGameState.changeTargetStair(activeStairStatus, activeStairStatus.hasChest() ? -moveAmount : moveAmount);
		state = characterMovingState;
	}

	public function characterMovingState():Void
	{
		if (activeStairStatus.critter.isStopped())
		{
			if (activeStairStatus.stairIndex == 0 && activeStairStatus.hasChest())
			{
				extraTurn = false;
				stairGameState.deliverChest(activeStairStatus);
				state = waitingForChestDeliveredState;
			}
			else if (activeStairStatus.stairIndex == 5 && !activeStairStatus.hasChest())
			{
				stairGameState.giveChest(activeStairStatus);
				state = waitingForChestGivenState;
			}
			else if (activeStairStatus.stairIndex == 8 && !activeStairStatus.hasChest())
			{
				stairGameState.giveChest(activeStairStatus);
				state = waitingForChestGivenState;
			}
			else
			{
				if (justCaptured)
				{
					state = null;
					stairGameState._eventStack.addEvent({time:stairGameState._eventStack._time + 2.0, callback:eventNextPlayer});
				}
				else
				{
					nextPlayer();
				}
			}
		}
	}

	public function waitingForChestDeliveredState():Void
	{
		if (activeStairStatus.critter._bodySprite.animation.curAnim.name == "idle" && !activeStairStatus.hasChest())
		{
			if (activeStairStatus.chest0.z <= 60 && activeStairStatus.chest1.z <= 60)
			{
				// both chests delivered?
				stairGameState.gameOver();
				state = null;
			}
			else
			{
				if (milestone < 2)
				{
					milestone = 2;
					justReachedMilestone = true;
				}
				nextPlayer();
			}
		}
	}

	public function waitingForChestGivenState():Void
	{
		if (activeStairStatus.critter._bodySprite.animation.curAnim.name == "idle" && activeStairStatus.hasChest())
		{
			if (activeStairStatus.chest1._critter == activeStairStatus.critter)
			{
				if (milestone < 3)
				{
					milestone = 3;
					justReachedMilestone = true;
				}
			}
			else if (activeStairStatus.chest0._critter == activeStairStatus.critter)
			{
				if (milestone < 1)
				{
					milestone = 1;
					justReachedMilestone = true;
				}
			}
			if (remainingMoves == 0)
			{
				nextPlayer();
			}
			else
			{
				stairGameState.changeTargetStair(activeStairStatus, -remainingMoves);
				remainingMoves = 0;
				state = characterMovingState;
			}
		}
	}

	public function update(elapsed:Float)
	{
		if (state != null)
		{
			state();
		}
	}

	public function eventNextPlayer(args:Array<Dynamic>)
	{
		nextPlayer();
	}

	public function nextPlayer():Void
	{
		state = null;
		if (!tutorial && stairGameState._gameState < 200)
		{
			/*
			 * if the player skips rhydon's explanation, it's possible for a
			 * bug to finish his movement during the odds-and-evens sequence.
			 * if this happens, we just disregard the movement and don't change
			 * player or anything.
			 */
			return;
		}
		if (extraTurn)
		{
			extraTurn = false;
			stairGameState.showRollAgain();
		}
		else {
			activePlayer = (activePlayer + 1) % 2;
			refreshStairStatusHelpers();
			stairGameState.showTurnIndicator();
		}
		if (tutorial)
		{
			// don't prompt for roll during tutorial. just notify the tutorial that it can continue
			stairGameState.tutorialFinishedMove();
		}
		else {
			stairGameState.promptRoll0();
		}
	}

	public function setActivePlayer(activePlayer:Int)
	{
		this.activePlayer = activePlayer;
		refreshStairStatusHelpers();
		stairGameState.showTurnIndicator();
	}
}