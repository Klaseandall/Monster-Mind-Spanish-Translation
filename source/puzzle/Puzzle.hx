package puzzle;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * ...
 * @author
 */
class Puzzle implements IFlxDestroyable
{
	/*
	 * The random generator to use for puzzle randomization. Can be overwritten
	 * for seeded puzzles.
	 */
	public static var PUZZLE_RANDOM:FlxRandom = FlxG.random;
	public static var REWARDS:Array<Int> = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 70, 80, 90, 100, 115, 135, 150, 175, 200, 230, 270, 300, 350, 400, 450, 500, 575, 675, 750, 875, 1000, 1150, 1350, 1500, 1750, 2000, 2300, 2700, 3000, 3500, 4000, 4500, 5000, 5750, 6750, 7500, 8750, 10000, 11500, 13500, 15000, 17500, 20000, 23000, 27000, 30000, 35000, 40000, 45000, 50000, 57500, 67500, 75000, 87500, 100000];

	public var _reward:Int = 0;
	public var _pegCount:Int = 0;
	public var _colorCount:Int = 0;
	public var _clueCount:Int = 0;
	public var _difficulty:Int = 0;
	public var _answer:Array<Int>;
	public var _guesses:Array<Array<Int>> = [];
	public var _markers:Array<Int> = [];
	public var _puzzleIndex:Int = 0;
	public var _puzzlePercentile:Float = 0; // on a scale of 0-1, how hard is it
	public var _easy:Bool = false;

	/**
	 * Initializes a puzzle from an input array. The input array contains the
	 * definition for a single puzzle.
	 *
	 * For example, [341, 5, 3042, 2121, 1, 1343, 11, 4342, 21, 2424, 2]:
	 *
	 * [
	 *  341,  // Difficulty 341.
	 *  5,    // 5 colors.
	 *  3042, // The solution is 3-0-4-2. Each number is a different color, so this might be blue-red-green-yellow.
	 *  2121, // The first guess is 2-1-2-1...
	 *  1,    // The first guess has one bug in the wrong position
	 *  1343, // The second guess is 1-3-4-3...
	 *  11,   // The second guess has one bug in the right position, and one bug in the wrong position.
	 *  4342, // The third guess is 4-3-4-2...
	 *  21,   // The third guess has two bugs in the right position, and one bug in the wrong position.
	 *  2424, // The fourth guess is 2-4-2-4...
	 *  2     // The fourth guess has two bugs in the wrong position
	 * ]
	 *
	 * @param	pegCount number of pegs in each clue (3, 4, 5 or 7)
	 * @param	array input array which defines the puzzle
	 */
	public function new(pegCount:Int, array:Array<Int>)
	{
		this._pegCount = pegCount;
		this._difficulty = array[0];
		this._colorCount = array[1];
		this._clueCount = Std.int((array.length - 3) / 2);

		this._answer = intToArray(array[2]);
		var index:Int = 3;
		while (index < array.length)
		{
			_guesses.push(intToArray(array[index]));
			_markers.push(array[index+1]);
			index += 2;
		}

		/*
		 * Easy(36).....................$25
		 *
		 * 3-Peg(79)....................$50
		 *
		 * 4-Peg(206)...................$135
		 *  Hard(289 * 1.25)............$230
		 *
		 * 5-Peg(587)...................$400
		 *  Hard(789 * 1.25)............$575
		 *    NM(1404 * 1.25 * 1.25)....$1350
		 *
		 * 7-peg(3505 * 1.25 * 1.25)....$3500
		 */
		_reward = getSmallestRewardGreaterThan(_difficulty * 0.6);
	}

	public static function getSmallestRewardGreaterThan(i:Float)
	{
		for (possibleReward in REWARDS)
		{
			if (possibleReward >= i)
			{
				return possibleReward;
			}
		}
		return REWARDS[REWARDS.length - 1];
	}

	/**
	 * Rearranges a puzzle's peg positions, colors, and the order of guesses.
	 */
	public function randomize()
	{
		// shuffle the order of guesses
		{
			var i = _clueCount - 1;
			while (0 < i)
			{
				var j = PUZZLE_RANDOM.int(0, i - 1);
				swap(_guesses, i, j);
				swap(_markers, i, j);
				i--;
			}
		}

		// shuffle the colors
		var newColors:Map<Int, Int> = randomMapping(_colorCount);
		for (guess in 0..._guesses.length)
		{
			for (i in 0..._pegCount)
			{
				_guesses[guess][i] = newColors.get(_guesses[guess][i]);
			}
		}
		for (i in 0..._pegCount)
		{
			_answer[i] = newColors.get(_answer[i]);
		}

		// shuffle the positions
		var newPositions:Map<Int, Int>;
		if (_pegCount == 7)
		{
			/*
			 * 7-peg puzzles can't be shuffled traditionally without breaking
			 * the "neighbor" rule. But, we can still rotate and flip them
			 * safely
			 */
			newPositions = [0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6];
			var rotateCount:Int = PUZZLE_RANDOM.int(0, 5);
			var flip:Bool = PUZZLE_RANDOM.bool();
			for (i in 0...rotateCount)
			{
				var tmp:Map<Int, Int> = new Map<Int, Int>();
				tmp[0] = newPositions[2];
				tmp[1] = newPositions[0];
				tmp[2] = newPositions[5];
				tmp[3] = newPositions[3];
				tmp[4] = newPositions[1];
				tmp[5] = newPositions[6];
				tmp[6] = newPositions[4];
				newPositions = tmp;
			}
			if (flip)
			{
				var tmp:Map<Int, Int> = new Map<Int, Int>();
				tmp[0] = newPositions[1];
				tmp[1] = newPositions[0];
				tmp[2] = newPositions[4];
				tmp[3] = newPositions[3];
				tmp[4] = newPositions[2];
				tmp[5] = newPositions[6];
				tmp[6] = newPositions[5];
				newPositions = tmp;
			}
		}
		else
		{
			newPositions = randomMapping(_pegCount);
		}

		for (guess in 0..._guesses.length)
		{
			var oldGuess:Array<Int> = _guesses[guess];
			var newGuess:Array<Int> = [];
			for (i in 0..._pegCount)
			{
				newGuess[i] = oldGuess[newPositions.get(i)];
			}
			_guesses[guess] = newGuess;
		}
		var oldAnswer:Array<Int> = _answer;
		var newAnswer:Array<Int> = [];
		for (i in 0..._pegCount)
		{
			newAnswer[i] = oldAnswer[newPositions.get(i)];
		}
		_answer = newAnswer;
	}

	/**
	 * Provides a mapping to shuffle a set of indexes. For example, for an
	 * input of "5", this method might return the following map:
	 *
	 * [
	 *   1 => 2,
	 *   2 => 4,
	 *   3 => 1,
	 *   4 => 5,
	 *   5 => 3
	 * ]
	 *
	 * @param	K number of indexes to shuffle
	 * @return	a mapping of input indexes to output indexes
	 */
	private function randomMapping(K:Int):Map<Int, Int>
	{
		var remaining:Array<Int> = [];
		for (i in 0...K)
		{
			remaining.push(i);
		}
		var newColors:Map<Int, Int> = new Map<Int, Int>();
		for (i in 0...K)
		{
			var j:Int = PUZZLE_RANDOM.int(0, remaining.length - 1);
			newColors.set(i, remaining[j]);
			remaining.splice(j, 1);
		}
		return newColors;
	}

	private function intToArray(J:Int)
	{
		var array:Array<Int> = [];
		for (i in 0..._pegCount)
		{
			array.push(J % 10);
			J = Std.int(J / 10);
		}
		return array;
	}

	static private function swap<T>(a:Array<T>, i:Int, j:Int)
	{
		var t = a[i];
		a[i] = a[j];
		a[j] = t;
	}

	/**
	 * Shuffles the input array.
	 *
	 * We use a custom Fisher-Yates implementation to guarantee the
	 * implementation is consistent across versions.
	 *
	 * A different implementation would invalidate seeded puzzles
	 *
	 * @param a array to shuffle
	 */
	public static function shuffle<T>(a:Array<T>)
	{
		var i = a.length;
		while (0 < i)
		{
			var j = PUZZLE_RANDOM.int(0, i - 1);
			var t = a[--i];
			a[i] = a[j];
			a[j] = t;
		}
		return a;
	}

	public function destroy()
	{
		_answer = null;
		_guesses = null;
		_markers = null;
	}
}