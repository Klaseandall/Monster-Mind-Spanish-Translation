package critter;

import critter.Critter;
import flixel.FlxSprite;

/**
 * An object which contains zero or one bugs. This can be a holopad or a clue
 * cell, for example.
 */
class SingleCritterHolder extends CritterHolder
{
	public var _critter(get, set):Critter;

	public function new(X:Float, Y:Float)
	{
		super(X, Y);
	}

	override public function holdCritter(critter:Critter)
	{
		if (_critter == null)
		{
			_critters.splice(0, _critters.length);
			super.holdCritter(critter);
		}
	}

	function get__critter()
	{
		return _critters[0];
	}

	function set__critter(critter:Critter):Critter
	{
		removeCritter(_critter);
		if (critter != null)
		{
			addCritter(critter);
		}
		return critter;
	}
}