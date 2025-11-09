package poke.abra;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;

/**
 * This class controls the periodic tugging noise that occurs when using anal
 * beads
 */
class TugNoise implements IFlxDestroyable
{
	private var _tugNoiseTimer:Float = 0;
	private var _tugNoiseSine:Float = 0;
	public var tugging:Bool = false;
	public var tuggingMouse:Bool = false; // Is the player tugging a taut rope? This field needs to be updated from the outside
	private var oldMousePosition:FlxPoint = FlxPoint.get();

	public function new()
	{
	}

	public function update(elapsed:Float)
	{
		_tugNoiseSine += elapsed;
		_tugNoiseTimer -= elapsed;

		if (_tugNoiseTimer <= 0)
		{
			var tug:Bool = false;
			if (tugging)
			{
				tug = true;
			}
			if (tuggingMouse && FlxG.mouse.getPosition().distanceTo(oldMousePosition) > 5)
			{
				FlxG.mouse.getPosition(oldMousePosition);
				tug = true;
			}
			if (tug)
			{
				SoundStackingFix.play(FlxG.random.getObject([AssetPaths.stretch0_00a3__wav, AssetPaths.stretch1_00a3__wav, AssetPaths.stretch2_00a3__wav]), Math.sin(_tugNoiseSine * Math.PI) * 0.2 + 0.5);
				_tugNoiseTimer = 0.08;
				if (tugging)
				{
					_tugNoiseTimer *= FlxG.random.float(1, 2);
				}
			}
		}
	}

	public function destroy()
	{
		oldMousePosition = FlxDestroyUtil.put(oldMousePosition);
	}
}