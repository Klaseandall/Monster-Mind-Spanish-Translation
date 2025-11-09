package minigame.tug;
import critter.Critter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import minigame.tug.TugGameState.isTugAnim;

/**
 * Graphics and logic for a rope in the tug-of-war minigame
 */
class Rope extends FlxSprite
{
	var mx:Matrix = new Matrix();
	var clip:Rectangle = new Rectangle();
	var bounds:Rectangle;
	var ropePulledGraphic:FlxGraphic = FlxGraphic.fromAssetKey(AssetPaths.rope_pulled__png);
	var ropeDroopGraphic:FlxGraphic = FlxGraphic.fromAssetKey(AssetPaths.rope_droop__png);
	var tugRow:TugRow;

	public function new(tugRow:TugRow)
	{
		super();
		this.tugRow = tugRow;
		bounds = new Rectangle(0, 0, 768, 18);
		offset.y = 3;
		makeGraphic(Std.int(bounds.width), Std.int(bounds.height), FlxColor.TRANSPARENT, true);
	}

	override public function draw():Void
	{
		pixels.fillRect(bounds, FlxColor.TRANSPARENT);

		drawHalf(tugRow.leftCritters, true);
		drawHalf(tugRow.rightCritters, false);

		dirty = true;
		super.draw();
	}

	/**
	 * Each rope includes of four components -- the droopy part on the left,
	 * the taut part connecting the left bug to the chest, the taut part
	 * connecting the right bug to the chest, and the droopy part on the right
	 *
	 * This function draws the left half, or the right half
	 *
	 * @param	critters bugs which are holding their half of the rope
	 * @param	left true for the left half of the rope; false for the right
	 */
	function drawHalf(critters:Array<Critter>, left:Bool)
	{
		var outer:Float = 0;
		var inner:Float = 0;
		var ropeY:Float = 0;
		var graphic:BitmapData = ropeDroopGraphic.bitmap;
		var i:Int = critters.length - 1;

		while (i >= -1)
		{
			mx.identity();
			inner = tugRow.tugChest._chestSprite.x + tugRow.tugChest._chestSprite.width * 0.5 + (left ? -12 : 12);
			while (i >= 0)
			{
				if (isTugAnim(critters[i]))
				{
					inner = critters[i]._bodySprite.x + critters[i]._bodySprite.width * 0.5;
					break;
				}
				i--;
			}
			if (left && graphic == ropeDroopGraphic.bitmap)
			{
				outer = inner - ropeDroopGraphic.width;
			}
			else if (!left && graphic == ropeDroopGraphic.bitmap)
			{
				mx.scale( -1, 1);
				mx.translate(graphic.width, 0);
				outer = 768;
			}
			if (left)
			{
				if (graphic == ropePulledGraphic.bitmap)
				{
					mx.translate(inner - ropePulledGraphic.bitmap.width, ropeY);
				}
				else
				{
					mx.translate(outer, ropeY);
				}
				clip.setTo(outer, 0, inner - outer, bounds.height);
			}
			else
			{
				mx.translate(inner, ropeY);
				clip.setTo(inner, 0, outer - inner, bounds.height);
			}
			pixels.draw(graphic, mx, null, null, clip);

			graphic = ropePulledGraphic.bitmap;
			if (i >= 0)
			{
				if (critters[i]._bodySprite.animation.name == "tug-vgood")
				{
					ropeY = 6;
				}
				else if (critters[i]._bodySprite.animation.name == "tug-good")
				{
					ropeY = 1;
				}
				else if (critters[i]._bodySprite.animation.name == "tug-bad")
				{
					ropeY = 0;
				}
				else if (critters[i]._bodySprite.animation.name == "tug-vbad")
				{
					ropeY = -1;
				}
			}

			outer = inner;
			i--;
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		mx = null;
		clip = null;
		bounds = null;
		ropePulledGraphic = null;
		ropeDroopGraphic = null;
	}
}