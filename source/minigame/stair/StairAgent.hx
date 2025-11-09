package minigame.stair;
import poke.abra.AbraDialog;
import minigame.GameDialog;

/**
 * Defines the behavior for an opponent in the stair climbing minigame
 */
class StairAgent
{
	// [0.0-1.0] How often does this agent throw a zero, in the hopes their opponent will throw a zero as well?
	public var diminishedZeroZero:Float = 1.0;

	// [0.0-1.0] How much does this agent ignore their opponent's likely decisions?
	public var dumbness:Float = 0;

	// [0.0-5.0] How much does this agent like picking the best option?
	public var bias0:Float = 1.0;

	// [0.0-5.0] How much does this agent like picking the second best option?
	public var bias1:Float = 1.0;

	// [0.0-14.0] How often do this agent's decisions get clouded by randomness?
	public var fuzzFactor:Float = 0.01;

	public var oddsEvens:Array<Float> = [0.25, 0.5, 0.25];
	public var chatAsset:String;

	public var thinkyFaces:Array<Int> = [6];
	public var neutralFaces:Array<Int> = [4, 5];
	public var goodFaces:Array<Int> = [2, 3];
	public var badFaces:Array<Int> = [7, 10, 11, 12, 13];
	public var gameDialog:GameDialog;
	public var dialogClass:Dynamic;

	public function new()
	{
	}

	public function setDialogClass(dialogClass:Dynamic)
	{
		this.dialogClass = dialogClass;
		var gameDialog:Dynamic = Reflect.field(dialogClass, "gameDialog");
		this.gameDialog = gameDialog(StairGameState);
	}
}