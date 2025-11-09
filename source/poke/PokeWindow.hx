package poke;

import MmStringTools.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxDestroyUtil;
import kludge.FlxSoundKludge;
import kludge.FlxSpriteKludge;

/**
 * Parent class which handles all logic common to pokemon windows -- keeping
 * track of all of their body parts, changing their expression, storing their
 * head/genitals, leaving or taking breaks during dialog sequences
 */
class PokeWindow extends MysteryWindow
{
	// Pokemon body parts, arms, legs, etc
	public var _parts:Array<FlxSprite> = [];

	// Pokemon visual items, arms, legs, blush, etc
	public var _visualItems:Array<FlxSprite> = [];

	// The glove, if it needs to grab/probe something
	public var _interact:BouncySprite = new BouncySprite(0, 0, 0, 0, 0);
	public var _age:Float = 0;
	public var _victorySound:Dynamic = AssetPaths.abra__mp3;
	public var _dialogClass:Dynamic = poke.abra.AbraWindow;
	public var _arousal = 0;
	public var _prefix = "abra";
	public var _name = "Abra";
	public var nudity:Int = 0;
	public var _partAlpha:Float = 1;

	public var _breakTime:Float = -1;
	public var _cameraButtons:Array<CameraButton> = [];
	public var cameraPosition:FlxPoint = FlxPoint.get(0, 0);
	public var _interactive:Bool = false;
	public var _dick:BouncySprite; // dick/vagina, the body part which directs cum. <null> if this character has no genitals/doesn't emit cum
	public var _head:BouncySprite; // head, the body part which exhibits facial expressions. <null> if this character doesn't have traditional facial expressions

	public function new(X:Float = 0, Y:Float = 0, Width:Int = 248, Height:Int = 349)
	{
		super(X, Y, Width, Height);
		_interactive = PlayerData.level >= 3;
	}

	/**
	 * Adds a body part; something the player can interact with
	 */
	function addPart(part:FlxSprite)
	{
		add(part);
		_parts.push(part);
		_visualItems.push(part);
	}

	/**
	 * Adds a visual item; something visible which the player can't interact with
	 */
	function addVisualItem(item:FlxSprite)
	{
		add(item);
		_visualItems.push(item);
	}

	function removePart(part:FlxSprite)
	{
		remove(part);
		_parts.remove(part);
		_visualItems.remove(part);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		_age += elapsed;
		if (_breakTime > 0)
		{
			_breakTime -= elapsed;
			if (_breakTime <= 0)
			{
				doFun("alpha1");
			}
		}
	}

	override public function get_width():Float
	{
		return _canvas.width;
	}

	public function setNudity(NudityLevel:Int)
	{
		this.nudity = NudityLevel;
	}

	/**
	 * Override to provide a victory pose when solving a puzzle
	 */
	public function cheerful():Void
	{
		FlxSoundKludge.play(_victorySound, 0.4);
		if (_breakTime > 0)
		{
			_breakTime = FlxG.random.float(0.5, 2);
		}
	}

	/**
	 * Override to ambiently arrange arms and legs, during sexy scenes
	 */
	public function arrangeArmsAndLegs():Void
	{
	}

	/**
	 * Override to define how to reload gender sprites. I think only Grovyle has to do this, when her gender changes during the intro
	 */
	public function refreshGender():Void
	{
	}

	public function reposition(part:FlxSprite, index:Int):Void
	{
		moveItemInArray(members, part, index);

		// reposition part in visual item array (for consistency)
		if (_visualItems.indexOf(part) != -1)
		{
			var targetIndex = _visualItems.length - 1;
			for (i in 0..._visualItems.length)
			{
				if (members.indexOf(_visualItems[i]) > index)
				{
					targetIndex = i;
					break;
				}
			}
			moveItemInArray(_visualItems, part, targetIndex);
		}

		// reposition part in parts array (for proper click detection)
		if (_parts.indexOf(part) != -1)
		{
			var targetIndex = _parts.length - 1;
			for (i in 0..._parts.length)
			{
				if (members.indexOf(_parts[i]) > index)
				{
					targetIndex = i;
					break;
				}
			}
			moveItemInArray(_parts, part, targetIndex);
		}
	}

	private static function moveItemInArray<T>(array:Array<T>, obj:T, index:Int)
	{
		var targetIndex = index;
		if (targetIndex > array.indexOf(obj))
		{
			// removing this item from the list changes the target index...
			targetIndex--;
		}
		array.remove(obj);
		array.insert(targetIndex, obj);
	}

	public function setArousal(Arousal:Int)
	{
		this._arousal = Arousal;
	}

	public function nudgeArousal(Arousal:Int)
	{
		if (Arousal > _arousal)
		{
			setArousal(Std.int(Math.min(_arousal + 1, Arousal)));
		}
		else
		{
			setArousal(Std.int(Math.max(_arousal - 1, Arousal)));
		}
	}

	public function playNewAnim(spr:FlxSprite, array:Array<String>)
	{
		array.remove(spr.animation.name);
		if (array.length > 0)
		{
			spr.animation.play(FlxG.random.getObject(array));
		}
	}

	public function blinkyAnimation(normalFrames:Array<Int>, ?blinkFrames:Array<Int>):Array<Int>
	{
		return AnimTools.blinkyAnimation(normalFrames, blinkFrames);
	}

	public function slowBlinkyAnimation(normalFrames:Array<Int>, ?blinkFrames:Array<Int>):Array<Int>
	{
		return AnimTools.slowBlinkyAnimation(normalFrames, blinkFrames);
	}

	/*
	 * Dialog strings like %fun-nude2% have an effect on a PokemonWindow
	 * instance. PokemonWindow subclasses can override the doFun method to
	 * define special behavior, such as taking off a Pokemon's hat, having
	 * them give a thumbs up or make a silly face. A few global strings include
	 * things for making the Pokemon leave or take off their clothes.
	 *
	 * @param	str the "interesting" part of the dialog string; e.g "nude2"
	 */
	public function doFun(str:String)
	{
		if (str == "alpha0")
		{
			_partAlpha = 0;
			for (item in _visualItems)
			{
				item.alpha = 0;
			}
		}
		if (str == "alpha1")
		{
			_partAlpha = 1;
			for (item in _visualItems)
			{
				if (item == _interact)
				{
					item.alpha = PlayerData.cursorMaxAlpha;
				}
				else
				{
					item.alpha = 1;
				}
			}
		}
		if (str == "shortbreak")
		{
			takeBreak(FlxG.random.float(15, 30));
		}
		if (str == "mediumbreak")
		{
			takeBreak(FlxG.random.float(40, 80));
		}
		if (str == "longbreak")
		{
			takeBreak(FlxG.random.float(80, 160));
		}
		if (StringTools.startsWith(str, "nude"))
		{
			setNudity(Std.parseInt(substringAfter(str, "nude")));
		}
	}

	public function takeBreak(breakTime:Float):Void
	{
		_partAlpha = 0;
		for (item in _visualItems)
		{
			item.alpha = 0;
		}
		this._breakTime = breakTime;
	}

	public static function fromInt(i:Int, X:Float = 0, Y:Float = 0, Width:Int = 248, Height:Int = 349):PokeWindow
	{
		if (i == 0)
		{
			return new poke.abra.AbraWindow(X, Y, Width, Height);
		}
		else if (i == 1)
		{
			return new poke.buiz.BuizelWindow(X, Y, Width, Height);
		}
		else if (i == 2)
		{
			return new poke.hera.HeraWindow(X, Y, Width, Height);
		}
		else if (i == 3)
		{
			return new poke.grov.GrovyleWindow(X, Y, Width, Height);
		}
		else if (i == 4)
		{
			return new poke.sand.SandslashWindow(X, Y, Width, Height);
		}
		else if (i == 5)
		{
			return new poke.rhyd.RhydonWindow(X, Y, Width, Height);
		}
		else if (i == 6)
		{
			return new poke.smea.SmeargleWindow(X, Y, Width, Height);
		}
		else if (i == 7)
		{
			return new poke.kecl.KecleonWindow(X, Y, Width, Height);
		}
		else if (i == 8)
		{
			return new poke.magn.MagnWindow(X, Y, Width, Height);
		}
		else if (i == 9)
		{
			return new poke.grim.GrimerWindow(X, Y, Width, Height);
		}
		else if (i == 10)
		{
			return new poke.luca.LucarioWindow(X, Y, Width, Height);
		}
		else {
			// default to abra... just to avoid crashing
			return new poke.abra.AbraWindow(X, Y, Width, Height);
		}
	}

	public static function fromString(s:String, X:Float = 0, Y:Float = 0, Width:Int = 248, Height:Int = 349):PokeWindow
	{
		return fromInt(PlayerData.PROF_PREFIXES.indexOf(s), X, Y, Width, Height);
	}

	/**
	 * Returns the topmost overlapped by the specified flxSprite
	 */
	public function getOverlappedPart(flxSprite:FlxSprite):FlxSprite
	{
		var overlappedPart:FlxSprite = null;
		if (FlxSpriteKludge.overlap(flxSprite, _canvas))
		{
			var i:Int = _parts.length - 1;
			while (i >= 0)
			{
				var part:FlxSprite = _parts[i];
				i--;
				if (part.visible && FlxG.pixelPerfectOverlap(flxSprite, part, 32))
				{
					return part;
				}
			}
		}
		return null;
	}

	public function reinitializeHandSprites()
	{
	}

	public function shiftVisualItems(y:Float)
	{
		for (item in _visualItems)
		{
			item.y += y;
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		_parts = FlxDestroyUtil.destroyArray(_parts);
		_visualItems = FlxDestroyUtil.destroyArray(_visualItems);
		_victorySound = null;
		_dialogClass = null;
		_prefix = null;
		_name = null;
		_interact = FlxDestroyUtil.destroy(_interact);
		_dick = FlxDestroyUtil.destroy(_dick);
		_head = FlxDestroyUtil.destroy(_head);
		_cameraButtons = null;
		cameraPosition = FlxDestroyUtil.put(cameraPosition);
	}
}

/**
 * A button the player can click to move the camera
 */
typedef CameraButton =
{
	x:Int,
	y:Int,
	image:FlxGraphicAsset,
	callback:Void->Void,
}