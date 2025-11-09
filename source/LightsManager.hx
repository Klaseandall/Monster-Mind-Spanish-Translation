package;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * Provides methods for lighting and unlighting different parts of the screen
 */
class LightsManager implements IFlxDestroyable
{
	public var _spotlights:SpotlightGroup;
	private var _spotlightAlphaTween:FlxTween;
	private var _predimmedLightsLevel:Float = 1.0;

	public function new()
	{
		_spotlights = new SpotlightGroup();
		_spotlights.dimLights(0);
	}

	public function setLightsOff()
	{
		setLightsDim(0.7);
	}

	public function setLightsUndim()
	{
		setLightsOn(_predimmedLightsLevel);
	}

	public function setLightsDim(?alpha:Float = 0.35)
	{
		_predimmedLightsLevel = _spotlights.alpha;
		_spotlights.dimLights(alpha);
		if (_spotlightAlphaTween != null)
		{
			_spotlightAlphaTween.cancel();
		}
		_spotlights.refreshSpotlights();
	}

	public function setLightsOn(?alpha:Float = 0)
	{
		if (_spotlightAlphaTween != null)
		{
			_spotlightAlphaTween.cancel();
		}
		_spotlightAlphaTween = FlxTweenUtil.retween(_spotlightAlphaTween, _spotlights, {alpha:alpha}, 0.6, {ease:FlxEase.circOut});
	}

	public function setSpotlightOn(which:String)
	{
		_spotlights.turnOn(which);
	}

	public function setSpotlightOff(which:String)
	{
		_spotlights.turnOff(which);
	}

	public function setSpotlightsOn(which:String)
	{
		_spotlights.turnOnMany(which);
	}

	public function setSpotlightsOff(which:String)
	{
		_spotlights.turnOffMany(which);
	}

	public function eventLightsOff(params:Array<Dynamic>):Void
	{
		setLightsOff();
	}

	public function eventLightsOn(params:Array<Dynamic>):Void
	{
		setLightsOn();
	}

	public function eventLightsDim(params:Array<Dynamic>):Void
	{
		if (params == null)
		{
			setLightsDim();
		}
		else {
			setLightsDim(params[0]);
		}
	}

	public function eventSpotlightOn(params:Array<Dynamic>):Void
	{
		setSpotlightOn(params[0]);
	}

	public function eventSpotlightOff(params:Array<Dynamic>):Void
	{
		setSpotlightOff(params[0]);
	}

	public function destroy():Void
	{
		_spotlights = FlxDestroyUtil.destroy(_spotlights);
		_spotlightAlphaTween = FlxTweenUtil.destroy(_spotlightAlphaTween);
	}
}