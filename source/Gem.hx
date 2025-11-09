package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxDirectionFlags;
import kludge.BetterFlxRandom;

/**
 * Graphics and business logic for the blue gems which pop out of chests during
 * puzzles and minigames
 */
class Gem extends FlxParticle
{
	public var z:Float = 0;
	public var groundZ:Float = 0;
	public var zVelocity:Float = 0;
	public var zAccel:Float = -720;

	public function new()
	{
		super();
		loadGraphic(AssetPaths.gems__png, true, 24, 24);
		setFacingFlip(FlxDirectionFlags.LEFT, false, false);
		setFacingFlip(FlxDirectionFlags.RIGHT, true, false);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		offset.set(12, 6 + z);
		if (z == groundZ && animation.frameIndex < 4)
		{
			animation.frameIndex += 4;
			drag.x = 160;
			drag.y = 160;
		}
		z = Math.max(groundZ, z + zVelocity * elapsed);
		zVelocity = Math.max( -1000, zVelocity + zAccel * elapsed);
	}

	override public function onEmit():Void
	{
		super.onEmit();
		animation.frameIndex = FlxG.random.int(0, 3);
		facing = FlxG.random.getObject([FlxDirectionFlags.LEFT, FlxDirectionFlags.RIGHT]);
	}

	override public function reset(X:Float, Y:Float):Void
	{
		super.reset(X, Y);
		drag.x = 0;
		drag.y = 0;
	}
}