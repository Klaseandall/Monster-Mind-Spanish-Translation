package puzzle;

import critter.SingleCritterHolder;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * Graphics for the elliptical holographic platforms in the puzzles, which are
 * capable of holding a single bug.
 */
class Holopad extends SingleCritterHolder implements IFlxDestroyable
{
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		_sprite.loadGraphic(AssetPaths.holopad__png, true, 64, 64);
		_sprite.setSize(36, 10);
		_sprite.offset.set(14, 39);
	}
}