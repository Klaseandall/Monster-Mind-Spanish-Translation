package credits;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import poke.PokeWindow;
import poke.rhyd.BreathingSprite;

/**
 * When you swap with Abra, Abra comes to visit you as a glove to say hello.
 *
 * GloveWindow is a window used in that scene which resembles an interactive
 * pokemon windows, but it just has a glove in it.
 */
class GloveWindow extends PokeWindow
{
	private var _hand:BreathingSprite;

	public function new(X:Float=0, Y:Float=0, Width:Int=248, Height:Int = 349)
	{
		super(X, Y, Width, Height);

		add(new FlxSprite( -54, -54, AssetPaths.abra_bg__png));

		_hand = new BreathingSprite( -54, -54, 0, 7, 0, 0);
		_hand.loadWindowGraphic(AssetPaths.glove_pokewindow__png, true);
		_hand.pixels.threshold(_hand.pixels, new Rectangle(0, 0, _hand.pixels.width, _hand.pixels.height), new Point(0, 0), '==', 0xffffffff, PlayerData.cursorFillColor);
		_hand.pixels.threshold(_hand.pixels, new Rectangle(0, 0, _hand.pixels.width, _hand.pixels.height), new Point(0, 0), '==', 0xff000000, PlayerData.cursorLineColor);
		_hand.alpha = PlayerData.cursorMaxAlpha;

		_hand.animation.add("default", [0, 1, 2, 3, 4]);
		_hand.animation.play("default");
		addPart(_hand);
	}

	override public function destroy():Void
	{
		super.destroy();

		_hand = FlxDestroyUtil.destroy(_hand);
	}

	/**
	 * Overridden for special "glove shows up" behavior -- most Pokemon are
	 * fully opaque, but the glove has an alpha component
	 *
	 * @param	str the "interesting" part of the dialog string; e.g "nude2"
	 */
	override public function doFun(str:String)
	{
		if (str == "alpha1")
		{
			_partAlpha = 1;
			for (item in _visualItems)
			{
				item.alpha = PlayerData.cursorMaxAlpha;
			}
		}
		else
		{
			super.doFun(str);
		}
	}
}