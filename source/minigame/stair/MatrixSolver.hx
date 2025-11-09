package minigame.stair;

/**
 * A solver for bimatrix games
 *
 * This is used for calculating the AI's move in the stair climbing minigame.
 */
class MatrixSolver
{
	private static var EPSILON:Float = .000000000001;
	private var rowHeaders:Array<Int>;
	private var colHeaders:Array<Int>;
	private var m:Array<Array<Float>>;

	private function new()
	{
	}

	private function storeMatrix(input:Array<Array<Float>>):Void
	{
		m = new Array<Array<Float>>();
		for (row in 0...input.length)
		{
			// deep copy of input matrixes...
			m.push(input[row].copy());
		}

		// pad right/bottom of matrix with zeroes
		m.push([]);
		for (row in 0...m.length)
		{
			while (m[row].length < input[0].length + 1)
			{
				m[row].push(0);
			}
		}

		rowHeaders = [];
		while (rowHeaders.length < m.length)
		{
			rowHeaders.push(0);
		}
		colHeaders = [];
		while (colHeaders.length < m[0].length)
		{
			colHeaders.push(0);
		}

		for (row in 0...m.length)
		{
			rowHeaders[row] = row + 1;
			m[row][m[0].length - 1] = 1;
		}
		for (col in 0...m[0].length)
		{
			colHeaders[col] = -col - 1;
			m[m.length - 1][col] = -1;
		}
		m[m.length - 1][m[0].length - 1] = 0;
	}

	public function makePositive():Void
	{
		var minValue:Float = m[0][0];
		for (row in 0...m.length - 1)
		{
			for (col in 0...m[0].length - 1)
			{
				minValue = Math.min(minValue, m[row][col]);
			}
		}
		for (row in 0...m.length - 1)
		{
			for (col in 0...m[0].length - 1)
			{
				m[row][col] = m[row][col] - minValue + 1;
			}
		}
	}

	public function solve():Void
	{
		var pivotRow:Int = -1;
		var pivotCol:Int = 0;
		while (pivotCol != -1)
		{
			var r:Float = 0;

			// find pivot row
			for (row in 0...m.length - 1)
			{
				var t1:Float = m[row][pivotCol];
				if (t1 > EPSILON)   // to avoid rounding error
				{
					var t2:Float = m[row][m[0].length - 1];
					if (t2 <= 0)
					{
						pivotRow = row;
						break;
					}
					else if (t1 / t2 > r)
					{
						pivotRow = row;
						r = t1 / t2;
					}
				}
			}
			var d:Float = m[pivotRow][pivotCol];

			// begin pivot on (pivotRow, pivotCol)
			for (col in 0...m[0].length)
			{
				// pivot row
				if (col != pivotCol)
				{
					m[pivotRow][col] = m[pivotRow][col] / d;
				}
			}
			for (row in 0...m.length)
			{
				// pivot main part
				if (row != pivotRow)
				{
					for (col in 0...m[0].length)
					{
						if (col != pivotCol)
						{
							m[row][col] = m[row][col] - m[row][pivotCol] * m[pivotRow][col];
						}
					}
				}
			}
			for (row in 0...m.length)
			{
				// pivot col
				if (row != pivotRow)
				{
					m[row][pivotCol] = -m[row][pivotCol] / d;
				}
			}
			m[pivotRow][pivotCol] = 1 / d;
			var t1:Int = rowHeaders[pivotRow];
			rowHeaders[pivotRow] = colHeaders[pivotCol];
			colHeaders[pivotCol] = t1;
			// end pivot

			pivotCol = -1;
			for (col in 0...m.length - 1)
			{
				// find pivot col
				if (m[m.length - 1][col] < 0)
				{
					pivotCol = col;
					break;
				}
			}
		}
	}

	/**
	 * Returns a strategy for P1 which maximizes P1's score, assuming P2 plays
	 * optimally
	 *
	 * @param	mat matrix to solve
	 * @return	array of probabilities for an optimal strategy
	 */
	public static function getStrategyP1(mat:Array<Array<Float>>):Array<Float>
	{
		var solver:MatrixSolver = new MatrixSolver();
		solver.doSolve(mat);
		var y:Array<Float> = [];
		while (y.length < solver.m[0].length - 1)
		{
			y.push(0);
		}
		for (row in 0...solver.m.length - 1)
		{
			if (solver.rowHeaders[row] < 0)
			{
				y[-solver.rowHeaders[row] - 1] = solver.m[row][solver.m[0].length - 1] / solver.m[solver.m.length - 1][solver.m[0].length - 1];
			}
		}
		return y;
	}

	/**
	 * Returns a strategy for P2 which minimizes P1's score, assuming P1 plays
	 * optimally
	 *
	 * @param	mat matrix to solve
	 * @return	array of probabilities for an optimal P2 strategy
	 */
	public static function getStrategyP2(mat:Array<Array<Float>>):Array<Float>
	{
		var solver:MatrixSolver = new MatrixSolver();
		solver.doSolve(mat);
		var x:Array<Float> = [];
		while (x.length < solver.m.length - 1)
		{
			x.push(0);
		}
		for (col in 0...solver.m[0].length-1)
		{
			if (solver.colHeaders[col] > 0)
			{
				x[solver.colHeaders[col] - 1] = solver.m[solver.m.length - 1][col] / solver.m[solver.m.length - 1][solver.m[0].length - 1];
			}
		}
		return x;
	}

	/**
	 * Returns a strategy for P1 which naively maximizes P1's score, with the
	 * assumption that P2 will behave randomly
	 *
	 * @param	rewardMatrix matrix to solve
	 * @return	array of probabilities for a naive P1 strategy
	 */
	public static function getDumbStrategyP1(rewardMatrix:Array<Array<Float>>):Array<Float>
	{
		var result:Array<Float> = [];
		for (row in 0...rewardMatrix.length)
		{
			result.push(0);
			for (col in 0...rewardMatrix[row].length)
			{
				result[row] += rewardMatrix[row][col];
			}
		}
		// narrow the choices down to the 1 or 2 smallest columns...
		var max:Float = result[0];
		for (i in 1...result.length)
		{
			max = Math.max(max, result[i]);
		}
		for (i in 0...result.length)
		{
			result[i] = max - result[i];
		}
		return normalizeStrategy(result);
	}

	/**
	 * Returns a strategy for P2 which naively minimizes P1's score, with the
	 * assumption that P1 will behave randomly
	 * 
	 * @param	rewardMatrix matrix to solve
	 * @return	array of probabilities for a naive P2 strategy
	 */
	public static function getDumbStrategyP2(rewardMatrix:Array<Array<Float>>):Array<Float>
	{
		var result:Array<Float> = [];
		for (col in 0...rewardMatrix[0].length)
		{
			result.push(0);
			for (row in 0...rewardMatrix.length)
			{
				result[col] += rewardMatrix[row][col];
			}
		}
		// narrow the choices down to the 1 or 2 largest rows...
		var max:Float = result[0];
		var min:Float = result[0];
		for (i in 1...result.length)
		{
			max = Math.max(max, result[i]);
			min = Math.min(min, result[i]);
		}
		if (max != min)
		{
			for (i in 0...result.length)
			{
				result[i] -= min;
			}
		}
		return normalizeStrategy(result);
	}

	/**
	 * Strategies are defined as an array of probabilities like
	 * [0.21, 0.29, 0.50], although while performing calculations they might
	 * temporarily be something absurd like [1.19, 1.64, 2.83].
	 * 
	 * This method normalizes a probability array so that all of the
	 * probabilities add up to 1.00
	 * 
	 * @param	result probability array which is modified inline
	 * @return	scaled probability array which adds up to 1.0
	 */
	public static function normalizeStrategy(result:Array<Float>):Array<Float>
	{
		var total:Float = 0;
		for (i in 0...result.length)
		{
			total += result[i];
		}
		if (total == 0)
		{
			// avoid divide by zero
			return result;
		}
		for (i in 0...result.length)
		{
			result[i] /= total;
		}
		return result;
	}

	private function doSolve(mat:Array<Array<Float>>):Void
	{
		storeMatrix(mat);
		makePositive();
		solve();
	}
}