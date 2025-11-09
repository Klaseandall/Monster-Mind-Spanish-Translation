package puzzle;

import puzzle.RankTracker.RankChance;

/**
 * Utility methods for evaluating a player's rank based on a single puzzle, and aggregating their rank over time.
 *
 * Rank is a number from 0-65. Higher ranks correlate to faster play.
 *   Rank 3  = Worst; solving the easiest 3-peg puzzles in about 3 minutes
 *   Rank 10 = Medium-Bad
 *   Rank 20 = Average
 *   Rank 30 = Good
 *   Rank 40 = Phenomenal
 *   Rank 50 = Best; solving a typical 5-peg puzzle in about 3 minutes
 *
 * Rank is aggregated by taking the most recent 8 solves, dropping the best one and the worst two, and averaging the remaining five.
 *   [31,15,44,45,45,46,27,41] -> [XX,XX,31,41,44,45,45,XX] -> Rank 42
 */
class RankTracker
{
	/**
	 * Maximum time for ranking, in seconds. We never want to tell the player, "You can rank up if you solve this puzzle in 2 days, 6 hours and 20 seconds!"
	 */
	public static var MAX_TIME:Int = 59 * 60 + 59;

	/**
	 * Minimum estimated time, in seconds, for a puzzle to be eligible for ranking. If a puzzle is too easy for you, then you can't increase your rank with it.
	 */
	public static inline var MIN_TIME:Int = 45;
	public static inline var FINAL_MIN_TIME:Int = 25;

	/**
	 * Array of qualifying "bandTimes" for each rank. RANKS[8] = bandTime necessary to reach rank 8.
	 */
	public static var RANKS:Array<Float> =
	{
		var tmpRanks:Array<Float> = [1.5];
		// ranks 1-5: beginner ranks
		for (rank in 0...5)
		{
			tmpRanks.insert(0, tmpRanks[0] / 0.65);
		}
		// rank 0: minimum rank
		tmpRanks.insert(0, 1000000000);
		// ranks 7-65: regular ranks
		while (tmpRanks.length < 66)
		{
			tmpRanks.push(tmpRanks[tmpRanks.length - 1] * 0.95);
		}
		tmpRanks;
	}

	private var _puzzleState:PuzzleState;
	private var _rankStart:Float = MmTools.time();
	private var _rankTimer:Float = 0;
	private var _now:Float = MmTools.time();
	public var _oldRank:Int = 0;
	private var _rankChance:RankChance;

	public function new(puzzleState:PuzzleState)
	{
		this._puzzleState = puzzleState;
		_oldRank = computeAggregateRank();

		var puzzleDifficulty:Int = _puzzleState._puzzle._difficulty;
		// We append a '0' to their rank, and flush the save. This way a player can't savescum their way to a high rank
		appendRankToHistory(0);
		PlayerSave.flush();
		appendRankHistoryLog();
	}

	public static function appendRankHistoryLog()
	{
		var str:String = DateTools.format(Date.now(), "%m-%d %H:%M " + computeAggregateRank() + " " + PlayerData.rankHistory);
		PlayerData.rankHistoryLog.push(str);
		PlayerData.rankHistoryLog.splice(0, PlayerData.rankHistoryLog.length - 100);
	}

	public static function computeAggregateRank(?rankHistory:Array<Int>):Int
	{
		if (rankHistory == null)
		{
			rankHistory = PlayerData.rankHistory;
		}
		var manipulatedRanks:Array<Int> = rankHistory.copy();
		sort(manipulatedRanks);
		var total:Int = sumMiddle(manipulatedRanks);
		if (PlayerData.finalRankHistory != null)
		{
			// during final trial, we artificially inflate the rank further
			for (finalRankItem in PlayerData.finalRankHistory)
			{
				total += finalRankItem;
			}
		}
		return Std.int(Math.ceil(total / 5));
	}

	private static function sumMiddle(manipulatedRanks:Array<Int>)
	{
		var total:Int = 0;
		for (rank in manipulatedRanks.slice(2, manipulatedRanks.length - 1))
		{
			total += rank;
		}
		return total;
	}

	/**
	 * @param	bandTime The ratio of actual to expected time spent on a puzzle. If you spend 10 minutes to solve a 5-minute puzzle, the bandTime is 2.
	 */
	public static function computeRank(bandTime:Float)
	{
		var rank:Int = 0;
		while (rank < RANKS.length - 1 && RANKS[rank + 1] >= bandTime)
		{
			rank++;
		}
		return rank;
	}

	/**
	 * @return The slowest someone can solve the specified puzzle while still getting the indicated rank
	 */
	public static function computeSlowestRankTime(rank:Int, puzzleDifficulty):Int
	{
		rank = Std.int(Math.max(rank, 0));
		rank = Std.int(Math.min(rank, 65));

		var time:Int = Std.int(Math.floor(RANKS[rank] * puzzleDifficulty));
		return Std.int(Math.min(RankTracker.MAX_TIME, time));
	}

	/**
	 * @return The fastest someone can solve the specified puzzle while still getting the indicated rank
	 */
	public static function computeFastestRankTime(rank:Int, puzzleDifficulty:Float):Int
	{
		rank = Std.int(Math.max(rank, 0));
		rank = Std.int(Math.min(rank, 64));

		var time:Int = Std.int(Math.ceil(RANKS[rank + 1] * puzzleDifficulty));
		return Std.int(Math.min(RankTracker.MAX_TIME, time));
	}

	public static function computeRankUpRank(?rankHistory:Array<Int>):Int
	{
		if (rankHistory == null)
		{
			rankHistory = PlayerData.rankHistory;
		}
		var manipulatedRanks:Array<Int> = rankHistory.copy();
		var oldRank:Int = computeAggregateRank(rankHistory);
		manipulatedRanks.splice(0, 1);
		sort(manipulatedRanks);
		var max:Int = manipulatedRanks[manipulatedRanks.length - 1];
		var i:Int = oldRank * 5 + 1 - sumMiddle(manipulatedRanks);
		return i > max ? -1 : i;
	}

	public static function computeRankDownRank(?rankHistory:Array<Int>):Int
	{
		if (rankHistory == null)
		{
			rankHistory = PlayerData.rankHistory;
		}
		var manipulatedRanks:Array<Int> = rankHistory.copy();
		var oldRank:Int = computeAggregateRank(rankHistory);
		manipulatedRanks.splice(0, 1);
		sort(manipulatedRanks);
		var min:Int = manipulatedRanks[1];
		var i:Int = (oldRank - 1) * 5 - sumMiddle(manipulatedRanks);
		return i < min ? -1 : i;
	}

	public static function computeMaxRank(puzzleDifficulty:Int):Int
	{
		var i = 65;
		while (i > 0)
		{
			if (RANKS[i] * puzzleDifficulty >= MIN_TIME)
			{
				return i;
			}
			i--;
		}
		return 0;
	}

	public static function computeRankChance(puzzleDifficulty:Int):RankChance
	{
		var manipulatedRanks:Array<Int> = PlayerData.rankHistory.copy();
		sort(manipulatedRanks);

		var rankChance:RankChance = {eligible:false};
		if (computeSlowestRankTime(manipulatedRanks[2] + 1, puzzleDifficulty) < MIN_TIME)
		{
		}
		else {
			rankChance.eligible = true;
			var rankUpRank:Int = computeRankUpRank(PlayerData.rankHistory);
			if (rankUpRank != -1)
			{
				var targetTime:Int = computeSlowestRankTime(rankUpRank, puzzleDifficulty);
				if (targetTime < MIN_TIME)
				{
					// can't rank up; puzzle is too easy
				}
				else
				{
					rankChance.rankUpTime = targetTime;
				}
			}
			var rankDownRank:Int = computeRankDownRank(PlayerData.rankHistory);
			if (rankDownRank != -1)
			{
				var targetTime:Int = computeFastestRankTime(rankDownRank + 1, puzzleDifficulty);
				if (targetTime < MIN_TIME)
				{
					// can't rank down; puzzle is too easy. so, we don't let them rank up either.
					rankChance.eligible = false;
					rankChance.rankUpTime = null;
				}
				else
				{
					rankChance.rankDownTime = targetTime;
				}
			}
			else if (rankChance.rankUpTime == null)
			{
				// their rank can't change. we report this as a very easy "defend rank", and try to increase their rank history volatility
				rankChance.rankDownTime = MAX_TIME;
			}
		}
		return rankChance;
	}

	public static function appendRankToHistory(level:Null<Int>)
	{
		PlayerData.rankHistory.splice(0, 1);
		PlayerData.rankHistory.push(level);
	}

	/**
	 * It's possible for someone to do only easy puzzles, which always give you rank 9 if you complete them under 45 seconds.
	 * So, if they did this for a long time, their ranks would look like "9, 9, 9, 9, 9, 9, 9, 9...."
	 *
	 * This would be discouraging when they eventually move to harder puzzles, and they can't rank up immediately.
	 * So, if someone's rank history gets to where it's this consistent, then we'll append extreme ranks like 65
	 * and 0 so that their rank remains volatile.
	 */
	public static function increaseRankVolatility(puzzleDifficulty:Int)
	{
		if (isStaleRankChance(computeRankChance(puzzleDifficulty)))
		{
			appendRankToHistory(65);
		}
		if (isStaleRankChance(computeRankChance(puzzleDifficulty)))
		{
			appendRankToHistory(0);
		}
		if (isStaleRankChance(computeRankChance(puzzleDifficulty)))
		{
			appendRankToHistory(0);
		}
		appendRankHistoryLog();
	}

	public static function isStaleRankChance(rankChance:RankChance)
	{
		return rankChance.eligible && rankChance.rankUpTime == null && rankChance.rankDownTime == RankTracker.MAX_TIME;
	}

	private static function sort(arr:Array<Dynamic>)
	{
		arr.sort(function(a:Dynamic, b:Dynamic)
		{
			if (a < b)
			{
				return -1;
			}
			else if (a > b)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		});
	}

	public function update(elapsed:Float)
	{
		var newNow:Float = MmTools.time();
		if (newNow < _now)
		{
			_rankStart -= (_now - newNow);
		}
		_now = newNow;
	}

	public function start()
	{
		_rankStart = MmTools.time();
		_rankTimer = 0;
	}

	public function getSecondsTaken(minTime:Float = MIN_TIME):Float
	{
		var secondsTaken:Float = Math.max((_now - _rankStart) / 1000, _rankTimer);
		return Math.max(secondsTaken, minTime);
	}

	public function stop():Void
	{
		var secondsTaken = getSecondsTaken();
		var puzzleDifficulty:Int = _puzzleState._puzzle._difficulty;
		var bandTime:Float = Std.int(secondsTaken) / puzzleDifficulty;
		PlayerData.rankHistory[7] = computeRank(bandTime);
		appendRankHistoryLog();
	}

	public function penalize():Void
	{
		_rankTimer = 24 * 60 * 60; // twenty-four hours
	}
}

typedef RankChance =
{
	eligible:Bool,
	?rankUpTime:Int,
	?rankDownTime:Int
}