package poke.sexy;
import flixel.FlxG;

/**
 * During the sexy minigames, Pokemon will periodically alter their pose
 * subtly. This class handles the logic for moving their arms and legs
 * according to a timer.
 */
class ArmsAndLegsArranger
{
	private var _min:Float = 0;
	private var _max:Float = 0;
	public var _armsAndLegsTimer:Float = 0;
	private var _pokeWindow:PokeWindow;

	public function new(pokeWindow:PokeWindow, min:Float = 8, max:Float = 12)
	{
		this._pokeWindow = pokeWindow;
		this._min = min;
		this._max = max;
		_armsAndLegsTimer = FlxG.random.float(8, 12);
	}

	public function update(elapsed:Float):Void
	{
		_armsAndLegsTimer -= elapsed;
		if (_armsAndLegsTimer < 0)
		{
			_pokeWindow.arrangeArmsAndLegs();
			_armsAndLegsTimer += FlxG.random.float(_min, _max);
		}
	}

	public function arrangeNow():Void
	{
		_pokeWindow.arrangeArmsAndLegs();
		_armsAndLegsTimer = FlxG.random.float(_min, _max);
	}

	public function setBounds(min:Float, max:Float):Void
	{
		this._min = min;
		this._max = max;
	}
}