package minigame.scale;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * Defines the behavior for an opponent in the scale minigame
 */
class ScaleAgent implements IFlxDestroyable
{
	public static var UNFINISHED:Int = 1000;

	// reflexes; how long you stare at a puzzle before you understand it
	private static var REFLEXES:Array<Float> = [10.115, 5.871, 3.386, 2.218, 1.440, 1.200, 1.000, 0.909, 0.826, 0.751];

	// cleverness; after you understand a puzzle, how long does it take you to find an answer
	private static var CLEVERNESS:Array<Float> = [2.822, 1.872, 1.440, 1.100, 0.833, 0.688, 0.568, 0.516, 0.469, 0.426];

	// reliability; how consistent are you at finding an answer
	private static var RELIABILITY:Array<Float> = [0.992, 1.282, 1.667, 2.182, 2.880, 3.456, 4.147, 4.562, 5.018, 5.520];

	// physical; how quickly can you hit the keys on the keyboard and click the mouse
	private static var PHYSICAL:Array<Float> = [4.180, 3.234, 2.488, 1.584, 1.200, 1.000, 0.833, 0.757, 0.688, 0.625];

	private var _reflexes:Int = 0;
	private var _cleverness:Int = 0;
	private var _reliability:Int = 0;
	private var _physical:Int = 0;
	public var _time:Float = 1000000;
	public var _finishedOrder:Int = UNFINISHED;
	public var _soundAsset:String;
	public var _chatAsset:String;
	public var _dialogClass:Dynamic;
	public var _name:String;
	public var _gender:PlayerData.Gender;
	public var _gameDialog:GameDialog;
	public var _mercy:Float = 0;

	public function new(reflexes:Int=0, cleverness:Int=0, reliability:Int=0, physical:Int=0)
	{
		this._reflexes = reflexes;
		this._cleverness = cleverness;
		this._reliability = reliability;
		this._physical = physical;
	}

	public function setDialogClass(dialogClass:Dynamic)
	{
		this._dialogClass = dialogClass;
		var gameDialog:Dynamic = Reflect.field(_dialogClass, "gameDialog");
		this._gameDialog = gameDialog(ScaleGameState);
	}

	/**
	 * Computes the amount of time it takes a Pokemon to solve a given scale
	 * puzzle.
	 *
	 * I originally had a rudimentary AI where they'd experiment with different
	 * solutions and actually move bugs around -- but, it was less performant
	 * and less predictable.
	 *
	 * From a black-box perspective there's not much difference between an
	 * algorithm spitting out a number like "8.6 seconds" and an algorithm
	 * simulating an AI for 8.6 seconds. Although, I'll admit the former does
	 * feel a little icky.
	 *
	 * @param	difficulty scale puzzle's difficulty (3, 4, 5 or 6 bugs)
	 * @param	puzzleSolution sum on both sides of the scale; the AI is slower
	 *       	at solving puzzles with bigger numbers
	 */
	public function computeTime(difficulty:Int, puzzleSolution:Int)
	{
		var cMin:Float = 0;
		var cMax:Float = 0;

		if (difficulty == 3)
		{
			cMin = 0.5;
			cMax = 0.4;
		}
		else if (difficulty == 4)
		{
			cMin = 1.0;
			cMax = 0.6;
		}
		else if (difficulty == 5)
		{
			cMin = 3.3;
			cMax = 1.5;
		}
		else if (difficulty == 6)
		{
			cMin = 4.7;
			cMax = 3.0;
		}
		else
		{
			cMin = 54;
			cMax = 24;
		}

		var clev = CLEVERNESS[Std.int(FlxMath.bound(_cleverness - _mercy * 0.25 + 0.80, 0, 9))];
		var refl = REFLEXES[Std.int(FlxMath.bound(_reflexes - _mercy * 0.25 + 0.60, 0, 9))];
		var reli = RELIABILITY[Std.int(FlxMath.bound(_reliability - _mercy * 0.25 + 0.40, 0, 9))];
		var phys = PHYSICAL[Std.int(FlxMath.bound(_physical - _mercy * 0.25 + 0.20, 0, 9))];

		var randBetween:Float = puzzleSolution * (clev * 0.3 + 0.7) * cMax * (refl * FlxG.random.float(0.8, 1.2));
		var d:Float = FlxG.random.float(0, 2);
		while (d < reli)
		{
			var a:Float = (refl * FlxG.random.float(0.8, 1.2) * 0.7 + 0.3) * cMin;
			var b:Float = puzzleSolution * clev * cMax;
			randBetween = Math.min(randBetween, FlxG.random.float(a, b));

			var e:Float = 2 / (reli * 0.7 + 0.6);
			cMin += FlxG.random.float(0, e);
			d += FlxG.random.float(0, 2);
		}
		// it takes about 1 second to move a peg to a scale platform
		var taskLength:Float = (0.95 * difficulty) * FlxG.random.float(0.8, 1.2);
		randBetween += taskLength * phys * 0.5;
		if (_reflexes == 9 && _cleverness == 9 && _reliability == 9)
		{
			// someone this clever just solves stuff instantly
			randBetween = 0;
		}
		randBetween = Math.max(randBetween, taskLength);
		_time = randBetween + ScaleGameState.BALANCE_DURATION;
	}

	public function isDone()
	{
		return _finishedOrder != UNFINISHED;
	}

	public function destroy():Void
	{
		_soundAsset = null;
		_chatAsset = null;
		_dialogClass = null;
		_name = null;
		_gameDialog = FlxDestroyUtil.destroy(_gameDialog);
	}
}