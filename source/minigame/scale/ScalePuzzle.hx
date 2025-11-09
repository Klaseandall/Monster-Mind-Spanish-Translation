package minigame.scale;

/**
 * A scale puzzle's data, including how many bugs there are and which bugs are used in the answer
 */
class ScalePuzzle
{
	public var _totalPegCount:Int = 0;
	public var _sum:Int = 0;
	public var _weights:Array<Int>;
	public var _answer:Array<Int>;

	public function new(array:Array<Int>)
	{
		this._totalPegCount = array[0];
		this._sum = array[1];
		this._weights = array.slice(2, 6);
		this._answer = array.slice(6, 10);
	}
}