package critter;
import critter.Critter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * An object which contains a set of bugs. This can be a clue box or a platform
 * for one of the minigames
 */
class CritterHolder implements IFlxDestroyable
{
	public var _sprite:FlxSprite;
	public var _critters:Array<Critter> = [];
	private var _holderPos:FlxPoint;
	private var _critterPos:FlxPoint;

	public function new(X:Float, Y:Float)
	{
		_sprite = new FlxSprite(X, Y);
	}

	public function holdCritter(critter:Critter)
	{
		_critters.push(critter);
		leash(critter, true);
	}

	public function leashAll(hard:Bool = false):Void
	{
		for (critter in _critters)
		{
			if (critter.isCubed())
			{
				// don't leash cubed critters
			}
			else
			{
				leash(critter, hard);
			}
		}
	}

	/**
	 * Constrain a bug into an elliptical shape
	 *
	 * @param	critter The bug to contain
	 * @param	hard true if the bug should be abruptly snapped into place.
	 *       	this is only used for subclasses, where the bugs have more
	 *       	freedom
	 */
	public function leash(critter:Critter, hard:Bool = false)
	{
		critter.setPosition(_sprite.x, _sprite.y + 1);
		critter.setImmovable(true);
		return;
	}

	public function removeCritter(critter:Critter):Bool
	{
		if (_critters.indexOf(critter) == -1)
		{
			return false;
		}
		_critters.remove(critter);
		return true;
	}

	public function addCritter(critter:Critter):Bool
	{
		if (_critters.indexOf(critter) != -1)
		{
			return false;
		}
		_critters.push(critter);
		return true;
	}

	public function getCritters():Array<Critter>
	{
		return _critters;
	}

	public function getSprite():FlxSprite
	{
		return _sprite;
	}

	public function destroy()
	{
		_sprite = FlxDestroyUtil.destroy(_sprite);
		_critters = null;
		_holderPos = FlxDestroyUtil.put(_holderPos);
		_critterPos = FlxDestroyUtil.put(_critterPos);
	}
}