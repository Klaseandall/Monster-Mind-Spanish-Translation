package demo;
import flash.utils.ByteArray;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import poke.buiz.BuizelSexyState;
import poke.grim.GrimerSexyState;
import poke.grov.GrovyleSexyState;
import poke.hera.HeraSexyState;
import openfl.display.BlendMode;
import openfl.geom.Rectangle;
import poke.luca.LucarioSexyState;
import poke.sand.SandslashSexyState;
import poke.smea.SmeargleSexyState;

/**
 * A demo for creating and exporting coordinates, vectors and polygons for the
 * sex scenes. Change this to extend the Pokemon SexyState of your choice, and
 * use the following keys to print diagnostic information which you can paste
 * back into the SexyState code as necessary
 *
 * SPACE: select a body part
 * [, ] : toggle body part frame
 * shift+[, ] : toggle body part alpha
 * CLICK: draw points to define an area of that body part
 * ENTER: print the corresponding points to output
 * BKSP:  remove a point
 * ESC:   clear points
 *
 * C: show some encouragement text, 'ooh' 'mmm'
 * P: toggle cumshot
 * SPACE: select the penis/head
 * [, ] : toggle penis/head frame
 * CLICK: click the urethra/mouth
 * CLICK: click a point behind the urethra/mouth
 * ENTER: print the corresponding points to output
 * BKSP:  remove a point
 * ESC:   clear points
 */
class SexyDebugState extends SmeargleSexyState
{
	var canvas:BouncySprite;
	var points:Array<FlxPoint>;
	var touchedPart:BouncySprite;
	public static var debug:Bool = false;

	override public function create():Void
	{
		debug = true;

		super.create();

		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;

		canvas = new BouncySprite(0, 0, 0, 0, 0);
		canvas.alpha = 0.7;
		canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(canvas);

		points = [];

		_dialogger.skip();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.mouse.justPressed)
		{
			/*
			 * SexyState explicitly makes the cursor invisible sometimes; but
			 * when debugging, we need to counteract this
			 */
			FlxG.mouse.useSystemCursor = true;
			FlxG.mouse.visible = true;
		}

		_cSatellite.setPosition(FlxG.mouse.x, FlxG.mouse.y);

		if (FlxG.keys.justPressed.ZERO)
		{
			if (touchedPart != null)
			{
				touchedPart.alpha = 0.1;
			}
		}

		if (FlxG.keys.justPressed.FIVE)
		{
			if (touchedPart != null)
			{
				touchedPart.alpha = 0.5;
			}
		}

		if (FlxG.keys.justPressed.ONE)
		{
			if (touchedPart != null)
			{
				touchedPart.alpha = 1.0;
			}
		}

		if (FlxG.keys.justPressed.C)
		{
			emitWords(encouragementWords, 0, 0);
		}

		if (FlxG.mouse.justPressed)
		{
			var minDist:Float = FlxG.width;
			for (_cameraButton in _pokeWindow._cameraButtons)
			{
				var buttonPoint:FlxPoint = FlxPoint.get(_pokeWindow.x + _cameraButton.x + 14, _pokeWindow.y + _cameraButton.y + 14);
				var dist:Float = buttonPoint.distanceTo(FlxG.mouse.getPosition());
				buttonPoint.put();
				minDist = Math.min(dist, minDist);
			}
			if (minDist <= 30)
			{
				// clicking camera button
			}
			else if (touchedPart != null)
			{
				var point:FlxPoint = FlxG.mouse.getScreenPosition();
				point.x += touchedPart.offset.x - touchedPart.x;
				point.y += touchedPart.offset.y - touchedPart.y;
				points.push(point);
			}
		}

		if (FlxG.keys.justPressed.BACKSPACE)
		{
			if (points.length > 0)
			{
				points.pop();
			}
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			touchedPart = getTouchedPart();
			if (touchedPart != null)
			{
				touchedPart.blend = BlendMode.INVERT;
				canvas.synchronize(touchedPart);
				canvas.y = 0;
				canvas.x = 0;
			}
		}

		if (FlxG.keys.justReleased.SPACE)
		{
			if (touchedPart != null)
			{
				touchedPart.blend = BlendMode.NORMAL;
			}
		}

		if (FlxG.keys.justPressed.RBRACKET || FlxG.keys.justPressed.LBRACKET)
		{
			if (touchedPart != null)
			{
				if (FlxG.keys.pressed.SHIFT)
				{
					if (touchedPart.alpha == 1.0)
					{
						touchedPart.alpha = 0.3;
					}
					else
					{
						touchedPart.alpha = 1.0;
					}
				}
				var dir = FlxG.keys.justPressed.RBRACKET ? 1 : touchedPart.frames.numFrames - 1;
				do
				{
					touchedPart.animation.frameIndex = (touchedPart.animation.frameIndex + dir) % touchedPart.frames.numFrames;
					touchedPart.animation.pause();
				}
				while (isBlank(touchedPart));
				trace("Switched to frame index ", touchedPart.animation.frameIndex);
			}
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			if (touchedPart != null)
			{
				if (points.length <= 3 && touchedPart == getSpoogeSource())
				{
					var velocity:Float = 260;
					var output:String = "dickAngleArray";
					output += "[" + touchedPart.animation.frameIndex + "] = [";
					var tmpPoints:Array<FlxPoint> = new Array<FlxPoint>();
					for (point in points)
					{
						tmpPoints.push(new FlxPoint());
					}
					tmpPoints[0].x = points[0].x - 4;
					tmpPoints[0].y = points[0].y - 4;
					for (i in 1...points.length)
					{
						var length = points[0].distanceTo(points[i]);
						tmpPoints[i].x = (points[0].x - points[i].x) * velocity / length;
						tmpPoints[i].y = (points[0].y - points[i].y) * velocity / length;
					}
					for (i in 0...tmpPoints.length)
					{
						var point:FlxPoint = tmpPoints[i];
						output += "new FlxPoint(" + Math.round(point.x) + ", " + Math.round(point.y) + ")";
						if (i != tmpPoints.length - 1)
						{
							output += ", ";
						}
					}
					output += "];";
					trace(output);
					getSpoogeAngleArray()[touchedPart.animation.frameIndex] = tmpPoints;
				}
				else
				{
					if (points.length == 2 && touchedPart == _head)
					{
						var velocity:Float = 80;
						var output:String = "breathAngleArray";
						output += "[" + touchedPart.animation.frameIndex + "] = [";
						var tmpPoints:Array<FlxPoint> = [new FlxPoint(), new FlxPoint()];
						tmpPoints[0].x = points[0].x - 4;
						tmpPoints[0].y = points[0].y - 4;
						var length = points[0].distanceTo(points[1]);
						tmpPoints[1].x = (points[0].x - points[1].x) * velocity / length;
						tmpPoints[1].y = (points[0].y - points[1].y) * velocity / length;
						for (i in 0...tmpPoints.length)
						{
							var point:FlxPoint = tmpPoints[i];
							output += "new FlxPoint(" + Math.round(point.x) + ", " + Math.round(point.y) + ")";
							if (i != tmpPoints.length - 1)
							{
								output += ", ";
							}
						}
						output += "];";
						trace(output);
						breathAngleArray[touchedPart.animation.frameIndex] = tmpPoints;
					}
					if (points.length >= 3)
					{
						var output:String = "";
						output += "mouthPolyArray[" + touchedPart.animation.frameIndex + "] = ";
						output += "[";
						for (i in 0...points.length)
						{
							var point:FlxPoint = points[i];
							output += "new FlxPoint(" + Math.round(point.x) + ", " + Math.round(point.y) + ")";
							if (i != points.length - 1)
							{
								output += ", ";
							}
						}
						output += "];";
						trace(output);
					}
				}
			}
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			points.splice(0, points.length);
		}

		if (FlxG.keys.justPressed.Q)
		{
			trace(_cumShots.length);
		}
	}

	override public function draw():Void
	{
		super.draw();

		FlxSpriteUtil.fill(canvas, FlxColor.TRANSPARENT);

		if (touchedPart != null && points.length >= 1)
		{
			var pointsCopy:Array<FlxPoint> = points.copy();
			for (i in 0...pointsCopy.length)
			{
				pointsCopy[i] = FlxPoint.get(pointsCopy[i].x + touchedPart.x, pointsCopy[i].y + touchedPart.y);
			}
			if (points.length == 1)
			{
				FlxSpriteUtil.drawRect(canvas, pointsCopy[0].x - 1, pointsCopy[0].y - 1, 3, 3, FlxColor.GREEN, null );
			}
			else if (points.length == 2)
			{
				FlxSpriteUtil.drawLine(canvas, pointsCopy[0].x, pointsCopy[0].y, pointsCopy[1].x, pointsCopy[1].y, { color:FlxColor.BLUE, thickness:3 } );
			}
			else if (points.length > 2)
			{
				FlxSpriteUtil.drawPolygon(canvas, pointsCopy, FlxColor.GREEN, null );
			}
			FlxDestroyUtil.putArray(pointsCopy);
		}
	}

	override public function sexyStuff(elapsed:Float):Void
	{
	}

	override public function handleToyWindow(elapsed:Float):Void
	{
	}

	function isBlank(Sprite:FlxSprite):Bool
	{
		Sprite.drawFrame();
		var byteArray:ByteArray = Sprite.framePixels.getPixels(new Rectangle(0, 0, Sprite.width, Sprite.height));
		byteArray.position = 0;
		while (byteArray.bytesAvailable > 0)
		{
			if (byteArray.readUnsignedByte() << 3 > 0)
			{
				return false;
			}
		}
		return true;
	}
}