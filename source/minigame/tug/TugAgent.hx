package minigame.tug;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import minigame.GameDialog;
import poke.abra.AbraDialog;
import poke.smea.SmeargleDialog;

/**
 * Defines the behavior for an opponent in the tug-of-war minigame
 */
class TugAgent implements IFlxDestroyable
{
	/**
	 * How bad are they at adding row values, to determine if they're winning or not?
	 *
	 * 0.047 = 48% win rate
	 * 0.070 = 45% win rate
	 * 0.110 = 40% win rate
	 * 0.170 = 30% win rate
	 * 0.290 = 15% win rate
	 */
	public var mathDeviance:Float = 0.245;

	/**
	 * How bad are they at remembering where the hidden critters are?
	 *
	 * 0.010 = 48% win rate
	 * 0.015 = 45% win rate
	 * 0.020 = 40% win rate
	 * 0.040 = 30% win rate
	 * 0.100 = 15% win rate
	 */
	public var memoryDeviance:Float = 0.130;

	/**
	 * How bad are they at noticing the bugs in each row... visible or otherwise?
	 *
	 * 0.008 = 48% win rate
	 * 0.012 = 45% win rate
	 * 0.018 = 40% win rate
	 * 0.035 = 30% win rate
	 * 0.090 = 15% win rate
	 */
	public var observationDeviance:Float = 0.090;

	/**
	 * How biased are they towards/away from winning the highest valued row?
	 * 
	 *  2.00 = The AI treats the highest row as though it's worth three times
	 *         as much; they'll blindly go for it even if it means losing
	 *  0.10 = The AI treats the highest row as though it's worth 110% as much;
	 *         they'll just barely, barely favor it
	 * -0.50 = The AI treats the highest row as though it's worth half as much;
	 *         they'll go for the other rows instead
	 */
	public var highestRowBias:Float = 0;

	/**
	 * How frequently do we figure out which rows we want to win?
	 *
	 * 3.0 = crazy good
	 * 60.0 = never
	 */
	public var planDelay:Float = 12.5;

	/**
	 * How frequently do we recount all of the guys, to counter our opponent?
	 *
	 * 0.6 = crazy good
	 * 5.0 = slow
	 */
	public var menPerRowDelay:Float = 1.8;

	/**
	 * Which index in the sprite sheet do they use for their hand graphic
	 */
	public var handFrames:Array<Int> = [0, 1];

	/**
	 * How does the character move their hand? Fast/slow? Precise, reckless?
	 */
	public var mouseSpeed:Float = 60;
	public var mouseJitterPerSecond:Float = 0.9;
	public var mouseDeviance:Float = 0.3;

	public var mathDevianceTrait:Trait;
	public var consecutiveMovements:Array<Int> = [2, 3, 5];
	public var breakDurations:Array<Float> = [2.5, 3.5, 5.5];

	public var chatAsset:String;
	public var thinkyFaces:Array<Int> = [6];
	public var neutralFaces:Array<Int> = [4, 5];
	public var goodFaces:Array<Int> = [2, 3];
	public var badFaces:Array<Int> = [7, 10, 11, 12, 13];
	public var dialogClass:Dynamic;
	public var gameDialog:GameDialog;

	public function setBreaks(consecutiveMovements:Array<Int>, breakDurations:Array<Float>)
	{
		this.consecutiveMovements = consecutiveMovements;
		this.breakDurations = breakDurations;
	}

	public function setMathDeviance(trait:Trait)
	{
		this.mathDevianceTrait = trait;
		switch (trait)
		{
			case Perfect:mathDeviance = 0.000;
			case Great:mathDeviance = 0.080;
			case Good:mathDeviance = 0.205;
			case Bad:mathDeviance = 0.245;
			case Awful:mathDeviance = 0.290;
		}
	}

	public function setMemoryDeviance(trait:Trait)
	{
		switch (trait)
		{
			case Perfect:memoryDeviance = 0.000;
			case Great:memoryDeviance = 0.032;
			case Good:memoryDeviance = 0.090;
			case Bad:memoryDeviance = 0.130;
			case Awful:memoryDeviance = 0.200;
		}
	}

	public function setObservationDeviance(trait:Trait)
	{
		switch (trait)
		{
			case Perfect:observationDeviance = 0.000;
			case Great:observationDeviance = 0.024;
			case Good:observationDeviance = 0.065;
			case Bad:observationDeviance = 0.090;
			case Awful:observationDeviance = 0.130;
		}
	}

	public function setPlanDelay(trait:Trait)
	{
		switch (trait)
		{
			case Perfect:planDelay = 3.5;
			case Great:planDelay = 7.5;
			case Good:planDelay = 12.5;
			case Bad:planDelay = 18.5;
			case Awful:planDelay = 25.5;
		}
	}

	public function setMenPerRowDelay(trait:Trait)
	{
		switch (trait)
		{
			case Perfect:menPerRowDelay = 0.7;
			case Great:menPerRowDelay = 1.3;
			case Good:menPerRowDelay = 1.8;
			case Bad:menPerRowDelay = 2.4;
			case Awful:menPerRowDelay = 3.6;
		}
	}

	public function new(mouseSpeed:Speed, mouseAccuracy:Trait)
	{
		switch (mouseSpeed)
		{
			case Fastest:this.mouseSpeed = 105; this.mouseJitterPerSecond = 1.8;
			case Fast:this.mouseSpeed = 80; this.mouseJitterPerSecond = 1.3;
			case Relaxed:this.mouseSpeed = 60; this.mouseJitterPerSecond = 0.9;
			case Slow:this.mouseSpeed = 45; this.mouseJitterPerSecond = 0.6;
			case Slowest:this.mouseSpeed = 35; this.mouseJitterPerSecond = 0.4;
		}

		switch (mouseAccuracy)
		{
			case Perfect:this.mouseDeviance = 0.1;
			case Great:this.mouseDeviance = 0.2;
			case Good:this.mouseDeviance = 0.3;
			case Bad:this.mouseDeviance = 0.4;
			case Awful:this.mouseDeviance = 0.6;
		}
	}

	public function setDialogClass(dialogClass:Dynamic)
	{
		this.dialogClass = dialogClass;
		var gameDialog:Dynamic = Reflect.field(dialogClass, "gameDialog");
		this.gameDialog = gameDialog(TugGameState);
	}

	public function destroy():Void
	{
		handFrames = null;
		consecutiveMovements = null;
		breakDurations = null;
		chatAsset = null;
		thinkyFaces = null;
		neutralFaces = null;
		goodFaces = null;
		badFaces = null;
		dialogClass = null;
		gameDialog = FlxDestroyUtil.destroy(gameDialog);
	}
}

enum Trait
{
	Perfect;
	Great;
	Good;
	Bad;
	Awful;
}

enum Speed
{
	Fastest;
	Fast;
	Relaxed;
	Slow;
	Slowest;
}