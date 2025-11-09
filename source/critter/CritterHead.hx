package critter;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRandom;
import flixel.util.FlxDirectionFlags;

/**
 * A bug is made of a head and body sprite which animate separately.
 * CritterHead encompasses the sprites and logic for a bug's head.
 */
class CritterHead extends FlxSprite
{
	// frames where the head goes behind the body
	private static var aboveFrames:Array<Bool> = [
				// 0...7
				false, false, false, false, false, false, false, false,
				false, false, false, false, false, false, false, false,
				false, false, false, false, true, false, false, false,
				true, false, false, false, false, false, false, false,
				false, false, false, false, false, true, true, true,
				// 40...47
				false, false, false, false, false, false, false, false,
				false, false, false, false, false, false, false, false,
				false, false, false, false, false, false, false, false,
				false, false, false, false, false, false, false, false,
				false, false, false, false, false, false, false, false,
				// 80...87
				false, false, false, false, false, false, false, false,
				false, false, false, false, false, false, false, false,
				false, false, false, false, false, false, false, false,
				false, false, false, false, false, false, false, false,
				false, false, true, true, true, true, true, true,
				// 120...127
				true, true, false, false, false, false, false, false,
				false, false, false, false, false, false, false, false,
			];

	private var _blinkFrames:Map<Int, Int>;
	private var _critter:Critter;
	private var _blinkElapsed:Float = 0;

	public function new(critter:Critter)
	{
		super(critter._bodySprite.x, critter._bodySprite.y);
		this._critter = critter;
		this._blinkElapsed = FlxG.random.float(2, 5);
		_blinkFrames = new Map<Int, Int>();
		setFacingFlip(FlxDirectionFlags.LEFT, false, false);
		setFacingFlip(FlxDirectionFlags.RIGHT, true, false);
	}

	public function moveHead():Void
	{
		x = _critter._bodySprite.x;
		if (aboveFrames[animation.frameIndex])
		{
			y = _critter._bodySprite.y - 2;
			offset.set(14, _critter._bodySpriteOffset - 2 + _critter.z);
		}
		else {
			y = _critter._bodySprite.y + 2;
			offset.set(14, _critter._bodySpriteOffset + 2 + _critter.z);
		}
		facing = _critter._bodySprite.facing;
	}

	override public function update(elapsed:Float):Void
	{
		if (_critter.isCubed())
		{
			moveHead();
		}

		var oldFrameIndex:Int = animation.frameIndex;

		super.update(elapsed);

		if (_blinkFrames.exists(animation.frameIndex))
		{
			_blinkElapsed -= elapsed;
			if (_blinkElapsed <= 0 && oldFrameIndex != animation.frameIndex)
			{
				animation.frameIndex = _blinkFrames.get(animation.frameIndex);
				_blinkElapsed = FlxG.random.float(2, 5);
			}
		}
	}

	override public function destroy():Void
	{
		super.destroy();
		_blinkFrames = null;
		_critter = null;
	}

	public function addBlinkableFrame(Frame:Int, BlinkFrame:Int)
	{
		_blinkFrames.set(Frame, BlinkFrame);
	}
}