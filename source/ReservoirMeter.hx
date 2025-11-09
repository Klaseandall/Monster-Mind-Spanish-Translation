package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;

/**
 * Long graphical meters filled with red, yellow and green liquid which
 * represent a pokemon's libido
 */
class ReservoirMeter extends FlxSprite
{
	private static var NORMAL_FRAME_COUNT:Int = 10;
	private static var EMERGENCY_FRAME_COUNT:Int = 8;

	private var mainColor:FlxColor;
	private var shadowColor:FlxColor;
	private var parentSprite:FlxSprite;
	private var yOffset:Int = 0;

	public function new(ParentSprite:FlxSprite, percent:Float, reservoirStatus:ReservoirStatus, ?yOffset:Int = 158, ?width:Int = 94)
	{
		super();
		this.parentSprite = ParentSprite;
		this.yOffset = yOffset;

		var frameCount:Int = reservoirStatus == ReservoirStatus.Emergency ? EMERGENCY_FRAME_COUNT : NORMAL_FRAME_COUNT;
		makeGraphic(width, 10 * frameCount, FlxColor.TRANSPARENT, true);
		loadGraphic(pixels, true, width, 10, false);

		updatePosition();

		// create animation
		var animationFrames:Array<Int> = [];
		for (i in 0...frameCount)
		{
			animationFrames.push(i);
		}
		animation.add("default", animationFrames, 6, true);
		animation.play("default");

		mainColor = [Green => 0xFF6ACA52, Yellow => 0xFFE6D329, Red => 0xFFE65540, Emergency => 0xFFE65540][reservoirStatus];
		shadowColor = [Green => 0xFF47A631, Yellow => 0xFFC0B00B, Red => 0xFFC4321B, Emergency => 0xFFC4321B][reservoirStatus];

		var targetX:Int = 0;
		if (percent <= 0.0)
		{
			targetX = 0;
		}
		else if (percent >= 1.0)
		{
			targetX = width - 1;
		}
		else
		{
			targetX = Math.round(2 + (width - 8) * percent);
		}

		for (frameIndex in 0...frameCount + 1)
		{
			{
				// fill transparent background
				var points:Array<FlxPoint> = [];
				points.push(FlxPoint.get(2, frameIndex * 10 + 0));
				points.push(FlxPoint.get(width - 3, frameIndex * 10 + 0));
				points.push(FlxPoint.get(width - 1, frameIndex * 10 + 3));
				points.push(FlxPoint.get(width - 1, frameIndex * 10 + 6));
				points.push(FlxPoint.get(width - 3, frameIndex * 10 + 9));
				points.push(FlxPoint.get(2, frameIndex * 10 + 9));
				points.push(FlxPoint.get(0, frameIndex * 10 + 6));
				points.push(FlxPoint.get(0, frameIndex * 10 + 3));
				points.push(FlxPoint.get(2, frameIndex * 10 + 0));
				FlxSpriteUtil.drawPolygon(this, points, 0x22FFFFFF);
				FlxDestroyUtil.putArray(points);
			}

			if (targetX > 0)
			{
				{
					// draw main bar
					var points:Array<FlxPoint> = [];
					points.push(FlxPoint.get(2, frameIndex * 10 + 0));
					if (targetX < width - 1)
					{
						points.push(FlxPoint.get(targetX, frameIndex * 10 + 0));
						points.push(FlxPoint.get(targetX, frameIndex * 10 + 9));
					}
					else
					{
						points.push(FlxPoint.get(width - 3, frameIndex * 10 + 0));
						points.push(FlxPoint.get(width - 1, frameIndex * 10 + 3));
						points.push(FlxPoint.get(width - 1, frameIndex * 10 + 6));
						points.push(FlxPoint.get(width - 3, frameIndex * 10 + 9));
					}
					points.push(FlxPoint.get(2, frameIndex * 10 + 9));
					points.push(FlxPoint.get(0, frameIndex * 10 + 6));
					points.push(FlxPoint.get(0, frameIndex * 10 + 3));
					points.push(FlxPoint.get(2, frameIndex * 10 + 0));
					FlxSpriteUtil.drawPolygon(this, points, mainColor);
					FlxDestroyUtil.putArray(points);
				}
				{
					// draw shadow
					var points:Array<FlxPoint> = [];
					points.push(FlxPoint.get(0.67, frameIndex * 10 + 7));
					if (targetX < width - 1)
					{
						points.push(FlxPoint.get(targetX, frameIndex * 10 + 7));
						points.push(FlxPoint.get(targetX, frameIndex * 10 + 9));
					}
					else
					{
						points.push(FlxPoint.get(width - 1.67, frameIndex * 10 + 7));
						points.push(FlxPoint.get(width - 3, frameIndex * 10 + 9));
					}
					points.push(FlxPoint.get(2, frameIndex * 10 + 9));
					points.push(FlxPoint.get(0.67, frameIndex * 10 + 7));
					FlxSpriteUtil.drawPolygon(this, points, shadowColor);
					FlxDestroyUtil.putArray(points);
				}
				// draw animated bits
				if (targetX < width - 1)
				{
					var yStart:Int = FlxG.random.int(0, 9);
					var yEnd:Int = yStart + FlxG.random.int(3, 6);

					if (yEnd <= 9)
					{
						drawMeniscus(frameIndex, targetX, yStart, yEnd);
					}
					else
					{
						drawMeniscus(frameIndex, targetX, 0, yEnd - 10);
						drawMeniscus(frameIndex, targetX, yStart, 9);
					}

					var spootCount:Int = FlxG.random.weightedPick([4, 2, 1]);
					for (i in 0...spootCount)
					{
						var spootSize:Int = FlxG.random.int(1, 2);
						var spootX:Int = targetX + FlxG.random.int(0, spootSize == 1 ? 3 : 2);
						var spootY:Int = FlxG.random.int(0, spootSize == 1 ? 9 : 8);
						var spootColor:FlxColor = spootY < 7 ? mainColor : shadowColor;
						FlxSpriteUtil.drawRect(this, spootX, frameIndex * 10 + spootY, spootSize, spootSize, spootColor);
					}
				}
			}

			{
				// draw shiny bits
				FlxSpriteUtil.drawLine(this, 4, frameIndex * 10 + 3, 5, frameIndex * 10 + 3, {color:FlxColor.WHITE, thickness:2});
				FlxSpriteUtil.drawLine(this, 6, frameIndex * 10 + 3, Std.int(width * 0.181), frameIndex * 10 + 3, {color:FlxColor.WHITE, thickness:2});
				FlxSpriteUtil.drawLine(this, Std.int(width * 0.181), frameIndex * 10 + 2, Std.int(width * 0.373), frameIndex * 10 + 2, {color:FlxColor.WHITE, thickness:1});
				FlxSpriteUtil.drawLine(this, Std.int(width * 0.383), frameIndex * 10 + 2, Std.int(width * 0.405), frameIndex * 10 + 2, {color:FlxColor.WHITE, thickness:1});
				FlxSpriteUtil.drawLine(this, width - 4, frameIndex * 10 + 7, width - 3, frameIndex * 10 + 7, {color:FlxColor.WHITE, thickness:1});
				FlxSpriteUtil.drawLine(this, Std.int(width * 0.830), frameIndex * 10 + 7, width - 5, frameIndex * 10 + 7, {color:FlxColor.WHITE, thickness:1});
			}

			if (reservoirStatus == ReservoirStatus.Emergency)
			{
				// blinking foreground
				var points:Array<FlxPoint> = [];
				points.push(FlxPoint.get(2, frameIndex * 10 + 0));
				points.push(FlxPoint.get(width - 3, frameIndex * 10 + 0));
				points.push(FlxPoint.get(width - 1, frameIndex * 10 + 3));
				points.push(FlxPoint.get(width - 1, frameIndex * 10 + 6));
				points.push(FlxPoint.get(width - 3, frameIndex * 10 + 9));
				points.push(FlxPoint.get(2, frameIndex * 10 + 9));
				points.push(FlxPoint.get(0, frameIndex * 10 + 6));
				points.push(FlxPoint.get(0, frameIndex * 10 + 3));
				points.push(FlxPoint.get(2, frameIndex * 10 + 0));
				var alpha:Float = Math.sin(frameIndex * Math.PI / frameCount);
				alpha = Math.pow(alpha * alpha, 1.6);
				var alphaColor:Int = Math.round(alpha * 0xBB) << 24 | 0x00FFFFFF;
				FlxSpriteUtil.drawPolygon(this, points, alphaColor);
				FlxDestroyUtil.putArray(points);
			}

			{
				// draw outline
				var lineStyle:LineStyle = { color:FlxColor.BLACK, thickness: 1 };
				var drawStyle:DrawStyle = { smoothing:false };
				var points:Array<FlxPoint> = [];
				points.push(FlxPoint.get(2, frameIndex * 10 + 0));
				points.push(FlxPoint.get(width - 3, frameIndex * 10 + 0));
				points.push(FlxPoint.get(width - 1, frameIndex * 10 + 3));
				points.push(FlxPoint.get(width - 1, frameIndex * 10 + 6));
				points.push(FlxPoint.get(width - 3, frameIndex * 10 + 9));
				points.push(FlxPoint.get(2, frameIndex * 10 + 9));
				points.push(FlxPoint.get(0, frameIndex * 10 + 6));
				points.push(FlxPoint.get(0, frameIndex * 10 + 3));
				points.push(FlxPoint.get(2, frameIndex * 10 + 0));
				FlxSpriteUtil.drawPolygon(this, points, FlxColor.TRANSPARENT, lineStyle, drawStyle);
				FlxDestroyUtil.putArray(points);
			}
		}
	}

	function updatePosition()
	{
		this.x = parentSprite.x + (parentSprite.width - width) / 2;
		this.y = parentSprite.y + yOffset;
		this.offset.x = parentSprite.offset.x;
		this.offset.y = parentSprite.offset.y;
		this.visible = parentSprite.visible;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		updatePosition();
	}

	function drawMeniscus(frameIndex:Int, x:Float, minY:Float, maxY:Float)
	{
		if (minY < 7 && maxY < 7)
		{
			FlxSpriteUtil.drawLine(this, x, frameIndex * 10 + minY, x, frameIndex * 10 + maxY, {color:mainColor, thickness:1});
		}
		else if (minY >= 7 && maxY >= 7)
		{
			FlxSpriteUtil.drawLine(this, x, frameIndex * 10 + minY, x, frameIndex * 10 + maxY, {color:shadowColor, thickness:1});
		}
		else
		{
			FlxSpriteUtil.drawLine(this, x, frameIndex * 10 + minY, x, frameIndex * 10 + 7, {color:mainColor, thickness:1});
			FlxSpriteUtil.drawLine(this, x, frameIndex * 10 + 7, x, frameIndex * 10 + maxY, {color:shadowColor, thickness:1});
		}
	}
}

enum ReservoirStatus
{
	Green;
	Yellow;
	Red;
	Emergency;
}