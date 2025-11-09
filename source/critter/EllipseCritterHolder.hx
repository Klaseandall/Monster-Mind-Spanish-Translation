package critter;
import critter.Critter;
import flixel.FlxG;

/*
 * A large elliptical container which can hold multiple bugs, such as for easy
 * puzzles or for the scale game
 */
class EllipseCritterHolder extends CritterHolder
{
	public var _leashRadiusX:Float = 0;
	public var _leashRadiusY:Float = 0;
	public var _leashOffsetY:Float = 0;

	public function new(X:Float, Y:Float)
	{
		super(X, Y);
	}

	/**
	 * Constrain a bug into an elliptical shape
	 *
	 * @param	critter The bug to contain
	 * @param	hard true if the bug should be abruptly snapped into place
	 */
	override public function leash(critter:Critter, hard:Bool = false)
	{
		_holderPos = _sprite.getPosition(_holderPos);
		_holderPos.x += _sprite.width / 2 - critter._targetSprite.width / 2 + 1;
		_holderPos.y += _sprite.height / 2 - critter._targetSprite.height / 2 + 2;
		_holderPos.y += _leashOffsetY;
		_critterPos = critter._targetSprite.getPosition(_critterPos);
		var dx = _critterPos.x - _holderPos.x;
		var dy = _critterPos.y - _holderPos.y;
		var dist = Math.sqrt(dx * dx + dy * dy);

		if (dist == 0)
		{
			critter.setPosition(_holderPos.x, _holderPos.y + 1);
			return;
		}

		var radius:Float = Math.sqrt((dx * dx) / (_leashRadiusX * _leashRadiusX) + (dy * dy) / (_leashRadiusY * _leashRadiusY));
		if (radius <= 1)
		{
			// already inside ellipse
			return;
		}
		critter.setIdle();
		critter._eventStack.reset();
		if (hard)
		{
			critter.setPosition(dx / (radius * 1.05) + _holderPos.x, dy / (radius * 1.05) + _holderPos.y);
		}
		else
		{
			critter.runTo((_holderPos.x + _critterPos.x) / 2 + FlxG.random.float(-2, 2), (_holderPos.y + _critterPos.y) / 2 + FlxG.random.float(-2, 2));
		}
	}
}