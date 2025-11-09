package minigame.stair;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDirectionFlags;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Graphics and logic for each of the two dice in the stair minigame
 * 
 * Yes, I know singular of "dice" is "die". But "die" means a lot of things in
 * the context of video games, while "dice" is unambiguous
 */
class StairDice extends FlxSprite
{
	private static var DICE_SETTLE_ANIMS:Array<Array<Int>> = [
		[7, 2, 0],
		[1, 6, 0],
		[0, 4, 1],
		[3, 0, 1],
		[7, 0, 2],
		[1, 0, 2],
		[0, 5, 3],
		[7, 6, 3],
		[5, 3, 1, 0],
		[4, 7, 2, 0],
		[7, 4, 0, 1],
		[2, 0, 4, 1],
		[1, 0, 7, 2],
		[6, 0, 6, 2],
		[7, 4, 5, 3],
		[4, 1, 4, 3],
		[2, 3, 6, 5, 0],
		[3, 5, 0, 1, 0],
		[5, 2, 1, 6, 1],
		[6, 4, 7, 6, 1],
		[0, 5, 0, 6, 2],
		[5, 2, 1, 0, 2],
		[6, 4, 1, 0, 3],
		[6, 4, 2, 1, 3],
	];
	
	public var z:Float = 0;
	public var zVelocity:Float = 0;
	public var zAccel:Float = -1440;
	
	public var sfxTimer:Float = 0;
	public var rollTimer:Float = 0;
	public var sfxVolume:Float = 0;

	public function new(graphic:FlxGraphicAsset) 
	{
		super();
		loadGraphic(graphic, true, 60, 60);
		width = 38;
		height = 14;
		setFacingFlip(FlxDirectionFlags.LEFT, false, false);
		setFacingFlip(FlxDirectionFlags.RIGHT, true, false);
	}
	
	private function resetSfxTimer() {
		if (FlxG.random.bool()) {
			sfxTimer = Math.min(FlxG.random.float(0.09, 0.12), FlxG.random.float(0.09, 0.12));
		} else {
			sfxTimer = Math.max(FlxG.random.float(0.12, 0.15), FlxG.random.float(0.12, 0.15));
		}
		playDiceSfx(sfxVolume);
		sfxVolume *= FlxG.random.float(0.4, 0.9);
	}
	
	private function playDiceSfx(volume:Float) {
		SoundStackingFix.play(FlxG.random.getObject([
			AssetPaths.stair_dice0_00cf__wav,
			AssetPaths.stair_dice1_00cf__wav,
			AssetPaths.stair_dice2_00cf__wav,
			AssetPaths.stair_dice3_00cf__wav,
			AssetPaths.stair_dice4_00cf__wav,
			AssetPaths.stair_dice5_00cf__wav,
			]), volume);
	}
	
	override public function update(elapsed:Float):Void 
	{
		var oldFrame:Int = animation.curAnim == null ? -1 : animation.curAnim.curFrame;
		super.update(elapsed);
		offset.set(11, 32 + z);
		
		if (z == 0 && drag.x == 0) {
			// just landed
			animation.add("settle", FlxG.random.getObject(DICE_SETTLE_ANIMS), 6, false);
			animation.play("settle");
			drag.set(240, 240);
			
			rollTimer = FlxG.random.float(0.4, 0.6);
			sfxTimer = 0;
			sfxVolume = 1.0;
		}
		if (rollTimer > 0) {
			rollTimer -= FlxG.elapsed;
			sfxTimer -= FlxG.elapsed;
			if (sfxTimer <= 0) {
				resetSfxTimer();
			}
		}
		if (animation.curAnim != null && animation.curAnim.curFrame != oldFrame) {
			// dice just rattled...
			if (animation.curAnim.curFrame == animation.curAnim.numFrames - 1) {
				// cock it so that a flat side is facing the ground
				angle = 0;
			} else {
				// cock it randomly
				angle = FlxG.random.getObject([0, 90, 180, 270]);
			}
			facing = FlxG.random.bool() ? FlxDirectionFlags.LEFT : FlxDirectionFlags.RIGHT;
			//super.update(0);
		}
		if (y < 310) {
			// bounce off of back wall
			y += 2 * (310 - y);
			velocity.y = -velocity.y;
			animation.frameIndex = (animation.frameIndex + FlxG.random.int(0, 3)) % 4;
			facing = FlxG.random.bool() ? FlxDirectionFlags.LEFT : FlxDirectionFlags.RIGHT;
			playDiceSfx(0.6);
		}
		
		z = Math.max(0, z + zVelocity * elapsed);
		zVelocity = Math.max( -1000, zVelocity + zAccel * elapsed );
	}
	
	public function tossDice()
	{
		animation.frameIndex = FlxG.random.int(0, animation.numFrames);
		facing = FlxG.random.bool() ? FlxDirectionFlags.LEFT : FlxDirectionFlags.RIGHT;
		angle = FlxG.random.getObject([0, 90, 180, 270]);
		z = 120;
		zVelocity = FlxG.random.float(120, 180);
		drag.set(0, 0);
		// update offset based on new Z
		update(0);
	}
}