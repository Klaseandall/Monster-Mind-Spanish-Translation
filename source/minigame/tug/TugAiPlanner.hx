package minigame.tug;
import flixel.FlxG;
import flixel.util.FlxDestroyUtil;

/**
 * The AI for the tug-of-war game.
 *
 * The AI looks at where the player's bugs are, and tries to come up with a
 * "win plan" -- an arrangement of bugs which will beat the player's bugs. Then
 * it arranges its bugs to match this plan.
 *
 * After awhile, it re-evaluates the board and comes up with a new win plan.
 *
 * Based on the Pokemon's behavior, it might be bad at remembering the hidden
 * bugs, come up with bad plans, or it might be really stubborn about its
 * current win plan and not want to change.
 */
class TugAiPlanner implements IFlxDestroyable
{
	private var tugGameState:TugGameState;
	private var currentWinPlan:Array<ShouldWin>;
	private var winPlans:Array<Array<ShouldWin>> = [];
	private var winPlanRewards:Map<Array<ShouldWin>, Int>;
	private var rowCount:Int = 0;
	private var scoreSum:Int = 0;

	private var memoryDeviancePerRow:Array<Float>;
	private var observationDeviancePerRow:Array<Float>;

	public function new(tugGameState:TugGameState):Void
	{
		this.tugGameState = tugGameState;
	}

	public function startRound():Void
	{
		rowCount = tugGameState.tugRows.length;

		scoreSum = 0;
		for (tugRow in tugGameState.tugRows)
		{
			scoreSum += tugRow.rowReward;
		}

		currentWinPlan = null;
		generateShouldWins();
	}

	public function getMenRequiredToTie(row:Int, tentCritterCount:Int, critterCount:Int):Int
	{
		return tugGameState.tugRows[row].rightCritters.length - getLockedLeftCritters(row)
		+ getRowMiscalculationAmount(row, tentCritterCount, critterCount);
	}

	/**
	 * @return How many extra critters are we imagining on the right side?
	 */
	public function getRowMiscalculationAmount(row:Int, tentCritterCount:Int, critterCount:Int):Int
	{
		return Math.round((tentCritterCount - rowCount) * memoryDeviancePerRow[row] + (critterCount - rowCount) * observationDeviancePerRow[row]);
	}

	private function getLockedLeftCritters(row:Int):Int
	{
		return tugGameState.tugRows[row].leftCritters.length - tugGameState.model.getMovableCritterCount(true, row);
	}

	private function getMenAvailable():Int
	{
		var menAvailable:Int = 0;
		for (row in 0...rowCount)
		{
			menAvailable += tugGameState.model.getMovableCritterCount(true, row);
		}
		return menAvailable;
	}

	/**
	 * Figure out a new set of rows which we can win with our remaining bugs,
	 * which will let us beat our opponent
	 */
	public function computeWinPlan():Void
	{
		var menAvailable:Int = getMenAvailable();
		var tentCritterCount:Int = getTentCritterCount();
		var critterCount:Int = tugGameState._critters.length;

		currentWinPlan = null;
		var bestEfficiency:Float = -99999;

		for (winPlan in winPlans)
		{
			var menRequired:Int = 0;
			for (row in 0...rowCount)
			{
				if (winPlan[row] == Tie)
				{
					menRequired += Std.int(Math.max(0, getMenRequiredToTie(row, tentCritterCount, critterCount)));
				}
				else if (winPlan[row] == Win)
				{
					menRequired += Std.int(Math.max(0, getMenRequiredToTie(row, tentCritterCount, critterCount) + 1));
				}
			}
			var reward:Int = winPlanRewards[winPlan];
			var efficiency:Float = menRequired <= 0 ? 2 * reward : reward / menRequired;
			if (efficiency > bestEfficiency && menRequired <= menAvailable)
			{
				bestEfficiency = efficiency;
				currentWinPlan = winPlan;
			}
		}
	}

	public function getTentCritterCount():Int
	{
		var tentCritterCount:Int = 0;
		for (critter in tugGameState._critters)
		{
			if (tugGameState.model.isInTent(critter))
			{
				tentCritterCount++;
			}
		}
		return tentCritterCount;
	}

	public function computeMenPerRow():Array<Int>
	{
		var menRemaining:Int = getMenAvailable();
		var tentCritterCount:Int = getTentCritterCount();
		var critterCount:Int = tugGameState._critters.length;

		var menPerRow:Array<Int> = [];

		for (row in 0...rowCount)
		{
			// initialize menPerRow with locked bug counts...
			menPerRow[row] = getLockedLeftCritters(row);
		}

		if (currentWinPlan == null)
		{
			// no possible arrangements!? ...arrange men randomly
		}
		else {
			for (row in 0...rowCount)
			{
				if (currentWinPlan[row] == Lose)
				{
					menPerRow[row] += 0;
				}
				else if (currentWinPlan[row] == Tie)
				{
					menPerRow[row] += Std.int(Math.max(0, getMenRequiredToTie(row, tentCritterCount, critterCount)));
				}
				else
				{
					menPerRow[row] += Std.int(Math.max(0, getMenRequiredToTie(row, tentCritterCount, critterCount) + 1));
				}
				menRemaining -= menPerRow[row];
			}
		}

		{
			while (menRemaining > 0)
			{
				var row:Int = 0;
				for (j in 0...20)
				{
					row = FlxG.random.int(0, rowCount - 1);
					if (currentWinPlan == null || currentWinPlan[row] != Lose)
					{
						break;
					}
				}
				menPerRow[row]++;
				menRemaining--;
			}
		}

		return menPerRow;
	}

	/**
	 * Generates a list of "ShouldWins" -- collections of row results. For
	 * example if there are three tents, there are about 20-30 different
	 * outcomes -- you might win two tents and lose the third, or we might
	 * each win one and tie on the third.
	 *
	 * For AI purposes we don't care if the result is favorable; winning one
	 * out of five rows is still a possible plan the AI might pursue, so we
	 * enumerate it here.
	 */
	public function generateShouldWins():Void
	{
		winPlans.splice(0, winPlans.length);
		winPlanRewards = new Map<Array<ShouldWin>, Int>();

		var permCount:Int = Std.int(Math.pow(3, rowCount));
		// iterate from 1; don't include "lose lose lose" case
		for (perm in 1...permCount)
		{
			var winPlan:Array<ShouldWin> = [];
			while (winPlan.length < rowCount)
			{
				winPlan.push(Lose);
			}
			{
				var i:Int = 0;
				var j:Int = perm;
				while (j > 0)
				{
					switch (j % 3)
					{
						case 1: winPlan[i] = Tie;
						case 2: winPlan[i] = Win;
					}
					j = Std.int(j / 3);
					i++;
				}
			}

			addWinPlan(winPlan);
		}

		memoryDeviancePerRow = [];
		for (i in 0...rowCount)
		{
			memoryDeviancePerRow.push(FlxG.random.floatNormal(0, tugGameState.agent.memoryDeviance));
		}

		observationDeviancePerRow = [];
		for (i in 0...rowCount)
		{
			observationDeviancePerRow.push(FlxG.random.floatNormal(0, tugGameState.agent.observationDeviance));
		}
	}

	private function addWinPlan(winPlan:Array<ShouldWin>)
	{
		var reward:Int = 0;
		for (i in 0...rowCount)
		{
			var rowReward = tugGameState.tugRows[i].rowReward;
			if (i == Std.int((rowCount - 1) / 2))
			{
				// highest value row; apply bias
				rowReward += Std.int(tugGameState.tugRows[i].rowReward * (tugGameState.agent.highestRowBias * FlxG.random.float(0.90, 1.11)));
			}
			if (winPlan[i] == Lose)
			{
				reward -= rowReward;
			}
			else if (winPlan[i] == Win)
			{
				reward += rowReward;
			}
		}
		reward += Math.round(FlxG.random.floatNormal(0, tugGameState.agent.mathDeviance * scoreSum));

		winPlans.push(winPlan);
		winPlanRewards[winPlan] = reward;
	}

	public function destroy()
	{
		currentWinPlan = null;
		winPlans = null;
		winPlanRewards = null;
		memoryDeviancePerRow = null;
		observationDeviancePerRow = null;
	}
}

enum ShouldWin
{
	Win;
	Tie;
	Lose;
}