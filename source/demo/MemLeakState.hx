package demo;
import critter.Critter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxDestroyUtil;
import minigame.scale.ScaleGameState;
import minigame.stair.StairGameState;
import minigame.tug.TugGameState;
import openfl.system.System;
import poke.abra.AbraBeadWindow;
import poke.abra.AbraSexyState;
import poke.abra.AbraWindow;
import poke.buiz.BuizelSexyState;
import poke.grim.GrimerSexyState;
import poke.grov.GrovyleSexyState;
import poke.hera.HeraSexyState;
import poke.kecl.KecleonWindow;
import poke.magn.MagnSexyState;
import poke.rhyd.RhydonBeadWindow;
import poke.rhyd.RhydonSexyState;
import poke.sand.SandslashResource;
import poke.sand.SandslashSexyState;
import poke.sand.SandslashWindow;
import poke.sexy.WordManager;
import poke.smea.SmeargleSexyState;
import puzzle.PuzzleState;

/**
 * A demo which initializes a given FlxState over and over and checks for
 * memory leaks. This is useful for figuring out if you're not destroying
 * objects correctly, which was an issue in earlier versions of the game.
 */
class MemLeakState extends FlxState
{
	private var checking:Dynamic = null;
	private var trialCount:Int = 0;
	private var totalMemoryConsumed:Float = 0;
	private var startMemoryConsumed:Float = 0;
	private var trialLabel:FlxText = new FlxText(0, 0, 0, null, 16);
	private var avgMemoryLabel:FlxText = new FlxText(0, 20, 0, null, 16);
	private var finalMemoryLabel:FlxText = new FlxText(0, 40, 0, null, 16);
	private var eventStack:EventStack = new EventStack();

	override public function create():Void
	{
		Main.overrideFlxGDefaults();
		Critter.initialize();

		add(trialLabel);
		add(avgMemoryLabel);
		add(finalMemoryLabel);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		eventStack.update(elapsed);

		if (checking != null)
		{
			var oldMemory = System.totalMemory;
			doIt(checking);
			var memoryConsumed = System.totalMemory - oldMemory;
			totalMemoryConsumed += memoryConsumed;
			trialCount++;

			trialLabel.text = "Trials: " + trialCount;
			avgMemoryLabel.text = "Avg memory: " + MmStringTools.commaSeparatedNumber(Std.int(totalMemoryConsumed / trialCount));
		}
		finalMemoryLabel.text = "Final memory consumed: " + MmStringTools.commaSeparatedNumber(Std.int((System.totalMemory - startMemoryConsumed) / trialCount));

		var clazzUnderTest = OptionsMenuState;

		if (FlxG.keys.justPressed.O)
		{
			doIt(clazzUnderTest);
			trialCount = 1;
			totalMemoryConsumed = 0;
		}
		if (FlxG.keys.justPressed.P)
		{
			startCheck(clazzUnderTest);
		}
	}

	private function startCheck(clazz:Dynamic)
	{
		eventStack.reset();
		var time:Float = eventStack._time;

		// execute once, so we ignore one-time memory stuff
		startMemoryConsumed = System.totalMemory;
		trialCount = 0;
		totalMemoryConsumed = 0;
		checking = clazz;

		// run for awhile, then fire off garbage collection and end trails...
		eventStack.addEvent({time:time+=5.0, callback:finishTrials });
	}

	public function finishTrials(args:Array<Dynamic>)
	{
		checking = null;
	}

	private function doIt(clazz:Dynamic)
	{
		var c = Type.createInstance(clazz, []);
		if (Std.isOfType(c, FlxState))
		{
			var flxState:FlxState = cast(c, FlxState);
			flxState.create();
		}
		c = FlxDestroyUtil.destroy(c);
	}
}