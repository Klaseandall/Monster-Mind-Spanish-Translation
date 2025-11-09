package;
import flixel.FlxBasic;
import flixel.FlxG;

/**
 * When testing the game we let players type things like "MONEY" to get money,
 * or "ZXC" to cycle through items in the shop. These cheat codes are disabled
 * for the release build.
 *
 * This class handles the logic for accumulating the player's keypresses into
 * a string, and invoking a callback so we can check which cheat codes the
 * player has typed.
 */
class CheatCodes extends FlxBasic
{
	public var callback:Dynamic;
	private static var codeChars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	private var code:String = "          ";

	public function new(Callback:Dynamic)
	{
		super();
		this.callback = Callback;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		var codeKeyPressed:Bool = false;
		var justPressed:Int = FlxG.keys.firstJustPressed();
		if (justPressed != -1)
		{
			var justPressedChar = String.fromCharCode(justPressed);
			if (codeChars.indexOf(justPressedChar) >= 0)
			{
				code = code.substring(1) + justPressedChar;
				codeKeyPressed = true;
			}
		}
		if (codeKeyPressed)
		{
			callback(code);
		}
	}
}