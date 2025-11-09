package minigame.tug;
import critter.Critter;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import minigame.tug.TugGameState.isLeftTeam;

/**
 * Stores information on which positions on the rope are occupied/empty, and
 * which critters are grabbing the rope
 */
class TugModel implements IFlxDestroyable
{
	/**
	 * which positions on the rope are claimed by critters?
	 * leftMatrix[3][0] = innermost position in 3rd row
	 */
	private var leftMatrix:Array<Array<Critter>> = [];
	private var rightMatrix:Array<Array<Critter>> = [];
	/**
	 * tent[14] = is critter #14 in a tent?
	 */
	private var tent:Array<Bool> = [];
	/**
	 * critterColumns[14] = which position has critter #14 claimed?
	 */
	private var critterColumns:Array<Int> = [];
	/**
	 * critterRows[14] = which row is critter #14 in?
	 */
	private var critterRows:Array<Int> = [];
	/**
	 * leaptCritters[14] = is critter #14 scheduled to leap into the tent any second now?
	 */
	private var leaptCritters:Array<Bool> = [];

	public function new() {}

	/**
	 * Assign a critter to a particular row. He'll occupy the innermost space he can.
	 *
	 * @return The column the critter was assigned to
	 */
	public function assignToRow(critter:Critter, row:Int):Int
	{
		var mat:Array<Array<Critter>> = isLeftTeam(critter) ? leftMatrix : rightMatrix;
		var matRow:Array<Critter> = mat[row];
		var targetCol:Int = getTargetCol(critter, row);

		matRow[targetCol] = critter;
		critterColumns[critter.myId] = targetCol;
		critterRows[critter.myId] = row;

		return targetCol;
	}

	public function getTargetCol(critter:Critter, row:Int):Int
	{
		var mat:Array<Array<Critter>> = isLeftTeam(critter) ? leftMatrix : rightMatrix;
		var matRow:Array<Critter> = mat[row];
		for (i in 0...matRow.length)
		{
			if (matRow[i] == null)
			{
				return i;
			}
		}
		return matRow.length;
	}

	public function setInTent(critter:Critter, inTent:Bool)
	{
		tent[critter.myId] = inTent;
		if (inTent)
		{
			var row:Int = getCritterRow(critter);
			if (row != -1)
			{
				var mat:Array<Array<Critter>> = isLeftTeam(critter) ? leftMatrix : rightMatrix;
				var matRow:Array<Critter> = mat[row];
				var sourceCol:Int = critterColumns[critter.myId];
				matRow[sourceCol] = null;
			}
			critterColumns[critter.myId] = -1;
		}
	}

	public function unassignFromRow(critter:Critter)
	{
		var row:Int = getCritterRow(critter);
		var mat:Array<Array<Critter>> = isLeftTeam(critter) ? leftMatrix : rightMatrix;
		var matRow:Array<Critter> = mat[row];
		var sourceCol:Int = critterColumns[critter.myId];

		if (row != -1)
		{
			if (matRow[sourceCol] == critter)
			{
				matRow[sourceCol] = null;
			}
			critterColumns[critter.myId] = -1;
			critterRows[critter.myId] = -1;
		}
	}

	public function getCritterRow(critter:Critter)
	{
		return critterRows[critter.myId];
	}

	public function isInTent(critter:Critter)
	{
		return tent[critter.myId];
	}

	public function traceInfo()
	{
		for (row in 0...leftMatrix.length)
		{
			var s:String = "row #" + row + " ";
			s += "left: ";
			for (i in 0...leftMatrix[row].length)
			{
				s += (leftMatrix[row][i] == null ? "null" : Std.string(leftMatrix[row][i].myId)) + " ";
			}
			s += "right: ";
			for (i in 0...rightMatrix[row].length)
			{
				s += (rightMatrix[row][i] == null ? "null" : Std.string(rightMatrix[row][i].myId)) + " ";
			}
			trace(s);
		}
		for (i in 0...critterColumns.length)
		{
			if (critterColumns[i] != -1)
			{
				trace("critterColumns #" + i + "=" + critterColumns[i]);
			}
		}
	}

	public function getCritterColumn(critter:Critter)
	{
		return critterColumns[critter.myId];
	}

	public function getCritterAt(leftTeam:Bool, row:Int, col:Int):Critter
	{
		var mat:Array<Array<Critter>> = leftTeam ? leftMatrix : rightMatrix;
		return mat[row][col];
	}

	public function isLeapt(critter:Critter):Bool
	{
		return leaptCritters[critter.myId] == true;
	}

	public function setLeapt(critter:Critter, leapt:Bool)
	{
		leaptCritters[critter.myId] = leapt;
	}

	public function reset(rowCount:Int)
	{
		leftMatrix.splice(0, leftMatrix.length);
		rightMatrix.splice(0, rightMatrix.length);
		for (i in 0...rowCount)
		{
			leftMatrix[i] = [];
			rightMatrix[i] = [];
		}
		tent.splice(0, tent.length);
		critterColumns.splice(0, critterColumns.length);
		critterRows.splice(0, critterRows.length);
		leaptCritters.splice(0, leaptCritters.length);
	}

	public function getMovableCritterCount(leftTeam:Bool, row:Int)
	{
		var count:Int = 0;
		var mat:Array<Array<Critter>> = leftTeam ? leftMatrix : rightMatrix;
		for (col in 0...mat[row].length)
		{
			count += mat[row][col] == null ? 0 : 1;
		}
		return count;
	}

	public function getAlliedColumnCount(leftTeam:Bool, row:Int)
	{
		var mat:Array<Array<Critter>> = leftTeam ? leftMatrix : rightMatrix;
		return mat[row].length;
	}

	public function destroy():Void
	{
		leftMatrix = null;
		rightMatrix = null;
		tent = null;
		critterColumns = null;
		critterRows = null;
		leaptCritters = null;
	}
}