package minigame.scale;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * Countdown graphics used for minigames.
 * 
 * This does the "3... 2... 1... go!" thing you see at the start of the scale
 * game.
 */
class CountdownSprite extends FlxSprite
{
	public static var COUNTDOWN_SECONDS:Float = 0.77;
	var countdownTime:Float = 0;
	
	public function new() 
	{
		super(334, 136);
		loadGraphic(AssetPaths.countdown__png, true, 100, 100);
		exists = false;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		countdownTime += elapsed;
		
		var oldIndex:Int = animation.frameIndex;
		animation.frameIndex = Std.int(FlxMath.bound(countdownTime / COUNTDOWN_SECONDS, 0, 3));
		if (oldIndex != animation.frameIndex) {
			squishEffect();
		}
		
		if (countdownTime >= COUNTDOWN_SECONDS * 4.5) {
			exists = false;
		}
	}
	
	function squishEffect() 
	{
		FlxTween.tween(scale, {x:1.33, y:0.75}, 0.1, {ease:FlxEase.cubeInOut});
		FlxTween.tween(scale, {x:0.75, y:1.33}, 0.1, {ease:FlxEase.cubeInOut, startDelay:0.1});
		FlxTween.tween(scale, {x:1, y:1}, 0.1, {ease:FlxEase.cubeInOut, startDelay:0.2});
		if (animation.frameIndex < 3) {
			SoundStackingFix.play(AssetPaths.countdown_00c6__mp3);
		}
		if (animation.frameIndex == 3) {
			FlxFlicker.flicker(this, 0.5, 0.04, false, false);
		}		
	}
	
	public function startCount():Void {
		countdownTime = 0;
		exists = true;
		visible = true;
		animation.frameIndex = 0;
		squishEffect();
	}
}