package poke.sexy;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import flash.display.InterpolationMethod;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import kludge.LateFadingFlxParticle;
import openfl.display.BlendMode;
import openfl.geom.Point;

/**
 * WordParticle represents a single row of text which appears during the sex
 * scenes. For example, the phrase "can you set it on low? ...or maybe off!"
 * might create four WordParticle instances, one above the other.
 */
class WordParticle extends LateFadingFlxParticle
{
	var wordGraphics:FlxSprite = new FlxSprite();
	var textAppearTimer:Float = 0;
	var textAppearX:Int = 0;
	var chunkSize:Int = 0;

	public function new()
	{
		super();
	}

	override public function reset(X:Float, Y:Float):Void
	{
		super.reset(X, Y);
		textAppearTimer = 0;
		textAppearX = 0;
	}

	override public function update(elapsed:Float):Void
	{
		FlxSpriteUtil.fill(this, FlxColor.TRANSPARENT);
		textAppearTimer += elapsed;
		while (textAppearTimer > 0)
		{
			textAppearTimer -= 0.06;
			textAppearX += chunkSize;
		}
		stamp(wordGraphics);
		FlxSpriteUtil.drawRect(this, textAppearX, 0, width, height, 0xFF80684E, null, {blendMode:BlendMode.ERASE});

		#if !flash
		// BlendMode.ERASE is not supported by non-flash targets, so we manually erase the pixels
		// with a threshold() call
		pixels.threshold(pixels, pixels.rect, new Point(0, 0), "==", 0xFF80684E);
		#end

		super.update(elapsed);
	}

	public function loadWordGraphic(Graphic:Dynamic, width:Int, height:Int, frameIndex:Int, chunkSize:Int)
	{
		makeGraphic(width, height, FlxColor.TRANSPARENT, true);
		wordGraphics.loadGraphic(Graphic, true, width, height);
		wordGraphics.animation.frameIndex = frameIndex;
		this.chunkSize = chunkSize;
	}

	public function delay(DelayAmount:Float)
	{
		textAppearTimer = -width * DelayAmount * 0.06 / chunkSize;
	}

	public function interruptWord()
	{
		if (textAppearX == 0)
		{
			exists = false;
		}
		lifespan = age + 2.1;
		enableLateFade(age + 2.1);
	}
}