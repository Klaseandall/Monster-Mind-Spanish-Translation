package poke.sexy;
import flixel.math.FlxMath;

/**
 * During sex scenes, Pokemon have a reservoir of hearts they emit while
 * cuddling, and a reservoir of hearts they emit from sex. HeartBank models
 * these two reservoirs.
 */
class HeartBank
{
	public var _totalReservoirCapacity:Float = 0;
	public var _defaultForeplayHeartReservoir:Float = 0;
	public var _foreplayHeartReservoir:Float = 0;
	public var _foreplayHeartReservoirCapacity:Float = 0;
	public var _defaultDickHeartReservoir:Float = 0;
	public var _dickHeartReservoir:Float = 0;
	public var _dickHeartReservoirCapacity:Float = 0;
	public var _libido:Int = 0;

	public function new(TotalReservoirCapacity:Float, ForeplayPercent:Float):Void
	{
		_totalReservoirCapacity = TotalReservoirCapacity;
		_defaultForeplayHeartReservoir = SexyState.roundUpToQuarter(TotalReservoirCapacity * ForeplayPercent);
		_defaultDickHeartReservoir = TotalReservoirCapacity - _defaultForeplayHeartReservoir;

		_foreplayHeartReservoir = _defaultForeplayHeartReservoir;
		_foreplayHeartReservoirCapacity = _defaultForeplayHeartReservoir;
		_dickHeartReservoir = _defaultDickHeartReservoir;
		_dickHeartReservoirCapacity = _defaultDickHeartReservoir;

		_libido = PlayerData.pokemonLibido;
	}

	public function getForeplayPercent():Float
	{
		var result:Float = _foreplayHeartReservoir / _foreplayHeartReservoirCapacity;
		if (_libido == 7)
		{
			// get aroused faster
			return Math.pow(result, 1.5);
		}
		else if (_libido == 6)
		{
			return Math.pow(result, 1.25);
		}
		else if (_libido == 2)
		{
			return Math.pow(result, 0.5);
		}
		else if (_libido == 1)
		{
			return FlxMath.bound(result, 0.99, 1.00);
		}
		else {
			return result;
		}
	}

	public function getDickPercent()
	{
		var result:Float = _dickHeartReservoir / _dickHeartReservoirCapacity;
		if (_libido == 7)
		{
			// ejaculate sooner
			return Math.pow(result, 1.5);
		}
		else if (_libido == 6)
		{
			return Math.pow(result, 1.25);
		}
		else if (_libido == 2)
		{
			return Math.pow(result, 0.5);
		}
		else if (_libido == 1)
		{
			return FlxMath.bound(result, 0.99, 1.00);
		}
		else
		{
			return result;
		}
	}

	public function traceInfo()
	{
		trace("foreplay: " + _foreplayHeartReservoir + "/" + _foreplayHeartReservoirCapacity + " %" + FlxMath.roundDecimal(100 * _foreplayHeartReservoir / _foreplayHeartReservoirCapacity, 1));
		trace("dick: " + _dickHeartReservoir + "/" + _dickHeartReservoirCapacity + " %" + FlxMath.roundDecimal(100 * _dickHeartReservoir / _dickHeartReservoirCapacity, 1));
		trace("libido: " + PlayerData.pokemonLibido);
	}

	public function isFull():Bool
	{
		return _dickHeartReservoir >= _dickHeartReservoirCapacity && _foreplayHeartReservoir >= _foreplayHeartReservoirCapacity;
	}

	public function isEmpty():Bool
	{
		return _dickHeartReservoir <= 0 && _foreplayHeartReservoir <= 0;
	}
}