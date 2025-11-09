package poke.buiz;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import kludge.FlxSoundKludge;
import openfl.display.BlendMode;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import poke.sexy.SexyState;

/**
 * The simplistic window on the side which lets the user interact with a
 * Pokemon's dildo sequence
 */
class DildoInterface extends FlxSpriteGroup
{
	private static var DILDO_TARGET:FlxPoint = FlxPoint.get(242, 58);
	private static var ARROW_MASK_COLOR:FlxColor = FlxColor.MAGENTA;
	private static var ARROW_MASK_RADIUS:Int = 100;
	private static var ARROW_MASK_SMALL_RADIUS:Int = 50;

	public static var ARROW_MIN_THRESHOLD:Int = 33;
	public static var ARROW_DEEP_INSIDE_THRESHOLD:Int = 136;
	public static var ARROW_INSIDE_THRESHOLD:Int = 235;
	public static var ARROW_OUTSIDE_THRESHOLD:Int = 328;
	public static var ARROW_MAX_THRESHOLD:Int = 438;

	private var canvas:FlxSprite;
	private var bgSprite:FlxSprite;
	private var fgSprite:FlxSprite;
	private var dildoSprite:FlxSprite;
	private var arrow:FlxSprite;
	private var assButton:FlxSprite;
	private var borderPoly:Array<FlxPoint> = [
				FlxPoint.get(1, 425),
				FlxPoint.get(1, 308),
				FlxPoint.get(92, 130),
				FlxPoint.get(213, 80),
				FlxPoint.get(252, 93),
				FlxPoint.get(252, 425),
				FlxPoint.get(1, 425),
			];
	private var buttonPoly:Array<FlxPoint> = [
				FlxPoint.get(215, 370),
				FlxPoint.get(260, 370),
				FlxPoint.get(260, 435),
				FlxPoint.get(215, 435),
			];
	private var arrowDist:Float = 0;
	private var arrowLength:Float = 1.0;
	private var arrowMask:FlxSprite;
	private var arrowMaskSmall:FlxSprite;
	private var oldMousePos:FlxPoint = FlxPoint.get();
	private var dildoInPct:Float = 0;

	public var animName:String = null;
	public var animPct:Float = 0; // how many frames of the animation should we use? 0.0 = minimum number of frames, 1.0 = maximum number of frames
	public var ass:Bool = true;
	private var arrowVisible:Bool = false;
	public var assTightness:Float = 5;
	public var vagTightness:Float = 0;

	// these three fields decide determine where the dildo graphic is drawn
	public var dildoOffset:FlxPoint = FlxPoint.get( -201, -86);
	public var dildoMinDist:Int = 76;
	public var dildoMaxDist:Int = 236;

	public function setDildoInPct(dildoInPct:Float)
	{
		if (dildoInPct != this.dildoInPct)
		{
			this.dildoInPct = dildoInPct;
			shakeDildo();
		}
	}

	public function new(male:Bool)
	{
		super();

		if (!male)
		{
			ass = false;
		}

		bgSprite = new FlxSprite(0, 0);
		bgSprite.loadGraphic(AssetPaths.buizdildo_iface_bg__png);

		fgSprite = new FlxSprite(0, 0);
		fgSprite.loadGraphic(AssetPaths.buizdildo_iface_fg__png);

		canvas = new FlxSprite(3, 3);
		canvas.makeGraphic(253, 426, FlxColor.WHITE, true);

		arrow = new FlxSprite(0, 0);
		arrow.makeGraphic(253, 426, FlxColor.TRANSPARENT, true);

		assButton = new FlxSprite(0, 0);
		assButton.loadGraphic(AssetPaths.dildo_iface_button__png, true, 18, 36);
		assButton.animation.frameIndex = 0;

		if (male)
		{
			assButton.visible = false;
		}

		dildoSprite = new FlxSprite(0, 0);
		dildoSprite.visible = false;

		arrowMask = new FlxSprite(0, 0);
		arrowMask.makeGraphic(ARROW_MASK_RADIUS * 2 * 7, ARROW_MASK_RADIUS * 2, FlxColor.TRANSPARENT, true);
		arrowMask.loadGraphic(arrowMask.pixels, true, ARROW_MASK_RADIUS * 2, ARROW_MASK_RADIUS * 2);
		for (c in 0...7)
		{
			for (x in 0...ARROW_MASK_RADIUS * 2)
			{
				for (y in 0...ARROW_MASK_RADIUS * 2)
				{
					if (Math.sqrt(Math.pow(x - ARROW_MASK_RADIUS, 2) + Math.pow(y - ARROW_MASK_RADIUS, 2)) < FlxG.random.int(Std.int(ARROW_MASK_RADIUS * 0.3), ARROW_MASK_RADIUS))
					{
						arrowMask.pixels.setPixel32(c * ARROW_MASK_RADIUS * 2 + x, y, ARROW_MASK_COLOR);
					}
				}
			}
		}

		arrowMaskSmall = new FlxSprite(0, 0);
		arrowMaskSmall.makeGraphic(ARROW_MASK_SMALL_RADIUS * 2 * 7, ARROW_MASK_SMALL_RADIUS * 2, FlxColor.TRANSPARENT, true);
		arrowMaskSmall.loadGraphic(arrowMaskSmall.pixels, true, ARROW_MASK_SMALL_RADIUS * 2, ARROW_MASK_SMALL_RADIUS * 2);
		for (c in 0...7)
		{
			for (x in 0...ARROW_MASK_SMALL_RADIUS * 2)
			{
				for (y in 0...ARROW_MASK_SMALL_RADIUS * 2)
				{
					if (Math.sqrt(Math.pow(x - ARROW_MASK_SMALL_RADIUS, 2) + Math.pow(y - ARROW_MASK_SMALL_RADIUS, 2)) < FlxG.random.int(Std.int(ARROW_MASK_SMALL_RADIUS * 0.3), ARROW_MASK_SMALL_RADIUS))
					{
						arrowMaskSmall.pixels.setPixel32(c * ARROW_MASK_SMALL_RADIUS * 2 + x, y, ARROW_MASK_COLOR);
					}
				}
			}
		}

		shakeDildo();
	}

	/**
	 * Based on a Pokemon's pose, the ass might be over the vagina or
	 * vice-versa. This function will set the ass button to be "flipped", where
	 * the ass is on top
	 *
	 * @param	flipped true if the ass part of the button should be on top
	 */
	public function setAssButtonFlipped(flipped:Bool):Void
	{
		assButton.loadGraphic(flipped ? AssetPaths.dildo_iface_button_flip__png : AssetPaths.dildo_iface_button__png, true, 18, 36);
	}

	public function setDildoGraphic(graphic:FlxGraphicAsset):Void
	{
		dildoSprite.loadGraphic(graphic);
	}

	override public function destroy():Void
	{
		super.destroy();

		canvas = FlxDestroyUtil.destroy(canvas);
		bgSprite = FlxDestroyUtil.destroy(bgSprite);
		fgSprite = FlxDestroyUtil.destroy(fgSprite);
		dildoSprite = FlxDestroyUtil.destroy(dildoSprite);
		arrow = FlxDestroyUtil.destroy(arrow);
		assButton = FlxDestroyUtil.destroy(assButton);
		borderPoly = FlxDestroyUtil.putArray(borderPoly);
		buttonPoly = FlxDestroyUtil.putArray(buttonPoly);
		arrowMask = FlxDestroyUtil.destroy(arrowMask);
		arrowMaskSmall = FlxDestroyUtil.destroy(arrowMaskSmall);
		oldMousePos = FlxDestroyUtil.put(oldMousePos);
		dildoOffset = FlxDestroyUtil.put(dildoOffset);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		var offsetMousePosition:FlxPoint = FlxG.mouse.getPosition();
		offsetMousePosition.x -= canvas.x;
		offsetMousePosition.y -= canvas.y;
		if (!SexyState.polygonContainsPoint(borderPoly, offsetMousePosition))
		{
			animName = null;
			dildoSprite.visible = false;
			arrowVisible = false;
		}
		else if (SexyState.polygonContainsPoint(buttonPoly, offsetMousePosition) && assButton.visible)
		{
			animName = null;
			dildoSprite.visible = false;
			arrowVisible = false;

			if (FlxG.mouse.justPressed)
			{
				ass = !ass;
				assButton.animation.frameIndex = ass ? 1 : 0;
				FlxSoundKludge.play(AssetPaths.beep_0065__mp3);
			}
		}
		else {
			arrowVisible = true;

			var mousePos = FlxG.mouse.getPosition();
			if (mousePos.x != oldMousePos.x || mousePos.y != oldMousePos.y)
			{
				updateArrow();
				oldMousePos.set(mousePos.x, mousePos.y);
			}

			if (FlxG.mouse.justPressed)
			{
				computeAnim(arrowDist);
			}
			else {
				if (arrowDist > ARROW_INSIDE_THRESHOLD && animName != null && StringTools.startsWith(animName, "dildo-"))
				{
					animName = null;
					dildoSprite.visible = false;
				}
				if (arrowDist <= ARROW_INSIDE_THRESHOLD && animName != null && (StringTools.startsWith(animName, "finger-") || StringTools.startsWith(animName, "rub-")))
				{
					animName = null;
					dildoSprite.visible = false;
				}
			}
		}

		if (assButton.visible && dildoSprite.visible && ass)
		{
			// are they past the point of no return in the ass?
			if (dildoInPct > 0.5)
			{
				assButton.visible = false;
			}
		}
	}

	/**
	 * Subclassed to compute what the hand/pokemon should be doing, based on
	 * how far in the user has clicked. If the user clicks really deep inside
	 * it'll do something like thrust the dildo really deep into the pokemon.
	 * If the user clicks further outside it'll do something like finger the
	 * pokemon lightly
	 *
	 * @param	arrowDist How far in the user clicked, in pixels
	 */
	public function computeAnim(arrowDist:Float)
	{
	}

	function updateArrow()
	{
		arrowDist = DILDO_TARGET.distanceTo(FlxG.mouse.getPosition());

		if (ass)
		{
			arrowDist = Math.max(arrowDist, assTightness * 40);
		}
		else
		{
			arrowDist = Math.max(arrowDist, vagTightness * 40);
		}

		arrowMask.animation.frameIndex = FlxG.random.int(0, arrowMask.frames.frames.length);

		if (arrowDist <= ARROW_INSIDE_THRESHOLD)
		{
			arrowLength = FlxMath.bound(0.4 + (ARROW_INSIDE_THRESHOLD - arrowDist) * (0.3 / 50), 0, 1.8);
		}
		else
		{
			arrowLength = FlxMath.bound(0.4 + (arrowDist - ARROW_INSIDE_THRESHOLD) * (0.3 / 100), 0, 1.0);
		}
		arrowMask.scale.x = Math.max(arrowLength * 0.65, 0.3);
		arrowMask.scale.y = arrowMask.scale.x;
	}

	private function computeAnimPct(inner:Float, outer:Float):Void
	{
		animPct = FlxMath.bound((arrowDist - outer) / (inner - outer), 0, 1.0);
	}

	private function shakeDildo():Void
	{
		dildoSprite.angle = FlxG.random.float( -1, 1);
		dildoSprite.scale.x = FlxG.random.float(0.49, 0.51);
		dildoSprite.scale.y = FlxG.random.float(0.49, 0.51);
	}

	override public function draw():Void
	{
		canvas.stamp(bgSprite, 0, 0); // draw bg sprite...

		var arrowVector:FlxPoint = FlxPoint.get(220 - DILDO_TARGET.x, 101 - DILDO_TARGET.y);
		arrowVector.length = arrowDist;
		var arrowTip:FlxPoint = FlxPoint.get(DILDO_TARGET.x + arrowVector.x, DILDO_TARGET.y + arrowVector.y);
		var arrowColor:FlxColor = arrowDist <= ARROW_INSIDE_THRESHOLD ? 0xff40a4c0 : 0xff00647f;

		// draw dildo...
		if (dildoSprite.visible)
		{
			var dildoVector:FlxPoint = FlxPoint.get(220 - DILDO_TARGET.x, 101 - DILDO_TARGET.y);
			dildoVector.length = dildoMaxDist * (1 - dildoInPct) + dildoMinDist * dildoInPct;
			var dildoTip:FlxPoint = FlxPoint.get(DILDO_TARGET.x + dildoVector.x, DILDO_TARGET.y + dildoVector.y);
			canvas.stamp(dildoSprite, Std.int(dildoTip.x + dildoOffset.x), Std.int(dildoTip.y + dildoOffset.y));
		}

		canvas.stamp(fgSprite, 0, 0); // draw fg sprite...

		if (arrowVisible)
		{
			arrow.pixels.fillRect(new Rectangle(0, 0, arrow.width, arrow.height), FlxColor.TRANSPARENT);
			// draw arrow shaft...
			{
				var poly:Array<FlxPoint> = [];
				poly.push(FlxPoint.get(arrowTip.x - 14, arrowTip.y + 15));
				poly.push(FlxPoint.get(arrowTip.x - 5, arrowTip.y + 20));
				poly.push(FlxPoint.get(arrowTip.x - 5 * (1 - arrowLength) - 31 * arrowLength, arrowTip.y + 20 * (1 - arrowLength) + 110 * arrowLength));
				poly.push(FlxPoint.get(arrowTip.x - 14 * (1 - arrowLength) - 68 * arrowLength, arrowTip.y + 15 * (1 - arrowLength) + 91 * arrowLength));
				FlxSpriteUtil.drawPolygon(arrow, poly, arrowColor);
				FlxDestroyUtil.putArray(poly);
			}

			// draw fadey area...
			{
				if (arrowMask.scale.x <= 0.60)
				{
					arrowMaskSmall.scale.x = arrowMask.scale.x * 2;
					arrowMaskSmall.scale.y = arrowMask.scale.y * 2;
					arrowMaskSmall.animation.frameIndex = arrowMask.animation.frameIndex;
					arrow.stamp(arrowMaskSmall,
								Std.int(arrowTip.x - 9 * (1 - arrowLength) - 49 * arrowLength - ARROW_MASK_SMALL_RADIUS),
								Std.int(arrowTip.y + 17 * (1 - arrowLength) + 100 * arrowLength - ARROW_MASK_SMALL_RADIUS));
				}
				else
				{
					arrow.stamp(arrowMask,
								Std.int(arrowTip.x - 9 * (1 - arrowLength) - 49 * arrowLength - ARROW_MASK_RADIUS),
								Std.int(arrowTip.y + 17 * (1 - arrowLength) + 100 * arrowLength - ARROW_MASK_RADIUS));
				}
				arrow.pixels.threshold(arrow.pixels, new Rectangle(0, 0, arrow.pixels.width, arrow.pixels.height), new Point(0, 0), "!=", arrowColor);
				arrow.dirty = true;
			}

			// draw arrow head...
			{
				var poly:Array<FlxPoint> = [];
				poly.push(FlxPoint.get(arrowTip.x, arrowTip.y));
				poly.push(FlxPoint.get(arrowTip.x, arrowTip.y + 35));
				poly.push(FlxPoint.get(arrowTip.x - 12, arrowTip.y + 23));
				poly.push(FlxPoint.get(arrowTip.x - 30, arrowTip.y + 21));
				poly.push(FlxPoint.get(arrowTip.x, arrowTip.y));
				FlxSpriteUtil.drawPolygon(arrow, poly, arrowColor);
				FlxDestroyUtil.putArray(poly);
			}
			canvas.stamp(arrow);
		}

		if (assButton.visible)
		{
			canvas.stamp(assButton, 223, 376);
		}

		// erase unused bits...
		{
			var poly:Array<FlxPoint> = [];
			poly.push(FlxPoint.get(0, 0));
			poly.push(FlxPoint.get(253, 0));
			poly.push(FlxPoint.get(253, 93));
			poly.push(FlxPoint.get(213, 80));
			poly.push(FlxPoint.get(92, 130));
			poly.push(FlxPoint.get(0, 308));
			poly.push(FlxPoint.get(0, 0));
			FlxSpriteUtil.drawPolygon(canvas, poly, 0xFF80684E, null, {blendMode:BlendMode.ERASE});
			FlxDestroyUtil.putArray(poly);
		}

		#if !flash
		// BlendMode.ERASE is not supported by non-flash targets, so we manually erase the pixels
		// with a threshold() call
		canvas.pixels.threshold(canvas.pixels, canvas.pixels.rect, new Point(0, 0), "==", 0xFF80684E);
		#end

		// draw border...
		{
			FlxSpriteUtil.drawPolygon(canvas, borderPoly, FlxColor.TRANSPARENT, { thickness: 2, color: FlxColor.BLACK });
		}

		// erase corners...
		canvas.pixels.setPixel32(0, Std.int(canvas.height - 1), 0x00000000);
		canvas.pixels.setPixel32(Std.int(canvas.width-1), Std.int(canvas.height - 1), 0x00000000);
		canvas.draw();
	}

	public function setTightness(assTightness:Float, vagTightness:Float)
	{
		this.assTightness = assTightness;
		this.vagTightness = vagTightness;
		updateArrow();
	}

	public function setBigDildo():Void
	{
		setDildoGraphic(AssetPaths.dildo_iface_dildo_big__png);
		dildoOffset.set( -326, -127);
		dildoMinDist = -15;
		dildoMaxDist = 231;
	}

	public function setLittleDildo():Void
	{
		setDildoGraphic(AssetPaths.dildo_iface_dildo_small__png);
		dildoOffset = FlxPoint.get( -201, -86);
		dildoMinDist = 76;
		dildoMaxDist = 236;
	}

	public function setPhone():Void
	{
		setDildoGraphic(AssetPaths.dildo_iface_phone__png);
		dildoOffset = FlxPoint.get( -270, -108);
		dildoMinDist = 96;
		dildoMaxDist = 236;
	}
}