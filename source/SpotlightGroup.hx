package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import openfl.display.BlendMode;

/**
 * A sprite which makes the screen darker, except for a few elliptical holes.
 *
 * This is useful for lighting up certain parts of the screen when trying to
 * explain puzzles.
 */
class SpotlightGroup extends FlxSprite
{
	private var buffer:FlxRect = FlxRect.get(-18, -14, 36, 28);
	private var spotlights:Map<String, Spotlight> = new Map<String, Spotlight>();
	private var spotlightsDirty:Bool = false;

	public function new()
	{
		super(0, 0);
		makeGraphic(FlxG.width, FlxG.height, 0xFF000022, true);
		blend = BlendMode.MULTIPLY;
	}

	public function addSpotlight(key:String):Void
	{
		spotlights[key] = {on:true};
		spotlightsDirty = true;
	}

	public function removeSpotlight(key:String):Void
	{
		if (spotlights[key] != null && spotlights[key].on)
		{
			spotlightsDirty = true;
		}
		spotlights.remove(key);
	}

	public function growSpotlight(key:String, bounds:FlxRect)
	{
		if (spotlights[key].rect == null)
		{
			spotlights[key].rect = new FlxRect();
			spotlights[key].rect.copyFrom(bounds);
		}
		else
		{
			spotlights[key].rect.union(bounds);
		}
		spotlightsDirty = true;
	}

	public function refreshSpotlights():Void
	{
		FlxSpriteUtil.fill(this, 0xFF000022);
		for (spotlight in spotlights)
		{
			if (spotlight.on && spotlight.rect != null)
			{
				FlxSpriteUtil.drawEllipse(this, spotlight.rect.x - 18, spotlight.rect.y - 14, spotlight.rect.width + 36, spotlight.rect.height + 28, FlxColor.WHITE);
			}
		}
		spotlightsDirty = false;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (spotlightsDirty)
		{
			refreshSpotlights();
		}
	}

	public function turnOn(which:String)
	{
		if (spotlights[which] == null)
		{
			throw "invalid light \"" + which + "\"";
		}
		spotlights[which].on = true;
		spotlightsDirty = true;
	}

	public function turnOff(which:String)
	{
		if (spotlights[which] == null)
		{
			throw "invalid light \"" + which + "\"";
		}
		spotlights[which].on = false;
		spotlightsDirty = true;
	}

	public function turnOnMany(which:String)
	{
		for (key in spotlights.keys())
		{
			if (StringTools.startsWith(key, which))
			{
				turnOn(key);
			}
		}
	}

	public function turnOffMany(which:String)
	{
		for (key in spotlights.keys())
		{
			if (StringTools.startsWith(key, which))
			{
				turnOff(key);
			}
		}
	}

	public function getBounds(which:String)
	{
		return spotlights[which].rect;
	}

	public function dimLights(alpha:Float)
	{
		for (key in spotlights.keys())
		{
			turnOff(key);
		}
		this.alpha = alpha;
	}

	public function traceInfo()
	{
		for (key in spotlights.keys())
		{
			var str:String = key + " (" + (spotlights[key].on ? "on" : "off") +"): ";
			if (spotlights[key].rect == null)
			{
				str += "null";
			}
			else
			{
				str += spotlights[key].rect.toString();
			}
			trace(str);
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		buffer = FlxDestroyUtil.put(buffer);
		spotlights = null;
	}
}

typedef Spotlight =
{
	?rect:FlxRect,
	on:Bool
}