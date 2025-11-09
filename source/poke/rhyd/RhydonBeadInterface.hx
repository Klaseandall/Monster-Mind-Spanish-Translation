package poke.rhyd;
import flixel.util.FlxDestroyUtil;
import poke.abra.SegmentedPath;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.display.BlendMode;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import poke.sexy.SexyState;

/**
 * The simplistic window on the side which lets the player interact with
 * Rhydon's anal bead sequence
 */
class RhydonBeadInterface extends FlxSpriteGroup
{
	private static var INTERACTABLE_PUSH_BEAD_DIST:Float = 1.9;
	private static var MAX_LINE_ANGLE:Float = -1.3192;
	private static var MIN_LINE_ANGLE:Float = -0.7854;
	private static var SHADOW_COLOR:FlxColor = 0xff503e49;
	private static var DIST_BETWEEN_BEADS:Float = 85;
	private static var BLINK_FREQUENCY:Float = 5;
	private static var BEAD_ORIGIN:FlxPoint = FlxPoint.get(310, -95);
	private static var HANDLE_ORIGIN:FlxPoint = FlxPoint.get(212, 55);
	private static var LAX_CONSTANT:Float = 2.4; // how far do i have to pull, before it starts counting?
	public var totalBeadCount:Int = 18;

	private var _bgSprite:FlxSprite;
	private var _beadSprite:FlxSprite;
	private var _mainBeadSprite:FlxSprite;
	private var _mainBeadHighlightSprite:FlxSprite;
	private var _beadHandleSprite:FlxSprite;
	private var _beadHandleHighlightSprite:FlxSprite;
	private var _purpleCanvas:FlxSprite;

	private var _assMeter:FlxSprite;
	private var _meterNeedleHeadTemplate:Array<FlxPoint> = [FlxPoint.get( -4, 0), FlxPoint.get(4, -6), FlxPoint.get(4, 6)];
	private var _meterNeedleHead:Array<FlxPoint> = [FlxPoint.get(), FlxPoint.get(), FlxPoint.get()];
	private var _visualAssMeterAngle:Float = -25;
	private var _currPoint:FlxPoint = FlxPoint.get();

	private var _canvas:FlxSprite;

	public var pushMode:Bool = true;

	private var pushPath:SegmentedPath;

	public var _anchorBeadPosition:Int = 0; // how many beads were inside before the player started pushing/pulling
	public var _desiredBeadPosition:Float = 0; // the position the player is trying to push/pull to
	public var _actualBeadPosition:Float = 0;
	public var _visualActualBeadPosition:Float = 0;

	public var lineAngle:Float = 0; // number ranging from [-1.0, 1.0] for left/right
	public var handleBlinkTimer:Float = 0.8;
	private var beadBlinkTimer:Float = 0.8;
	public var _interacting:Bool = false;
	public var _interactiveTimer:Float = 1.0; // [0.00-1.00) : not interactive [1.00-?.??]: interactive
	private var pointTween:FlxTween = null;
	private var interactiveTween:FlxTween = null;

	public function new()
	{
		super();
		_bgSprite = new FlxSprite();
		_bgSprite.loadGraphic(AssetPaths.rhydbeads_iface__png, true, 253, 426);

		_beadSprite = new FlxSprite(0, 0);
		_beadSprite.loadGraphic(AssetPaths.rhydon_bead_shadow__png, true, 80, 80);

		_mainBeadSprite = new FlxSprite(0, 0);
		_mainBeadSprite.loadGraphic(AssetPaths.rhydon_bead_shadow__png, true, 80, 80);
		_mainBeadSprite.animation.add("default", [0, 0]);
		_mainBeadSprite.animation.add("blink", [1, 1, 2, 3, 4, 5, 6, 7, 7, 0], 20, false);

		_mainBeadHighlightSprite = new FlxSprite(0, 0);
		_mainBeadHighlightSprite.loadGraphic(AssetPaths.rhydon_bead_shadow__png, true, 80, 80);
		_mainBeadHighlightSprite.animation.frameIndex = 4;

		_beadHandleSprite = new FlxSprite(0, 0);
		_beadHandleSprite.loadGraphic(AssetPaths.rhydon_bead_shadow_handle__png, true, 80, 80);
		_beadHandleSprite.animation.add("default", [0, 0]);
		_beadHandleSprite.animation.add("blink", [1, 1, 2, 3, 4, 5, 6, 7, 7, 0], 20, false);
		_beadHandleSprite.animation.play("default");

		_beadHandleHighlightSprite = new FlxSprite(0, 0);
		_beadHandleHighlightSprite.loadGraphic(AssetPaths.rhydon_bead_shadow_handle__png, true, 80, 80);
		_beadHandleHighlightSprite.animation.frameIndex = 4;

		_canvas = new FlxSprite(3, 3);
		_canvas.makeGraphic(253, 426, FlxColor.WHITE, true);

		_purpleCanvas = new FlxSprite();
		_purpleCanvas.makeGraphic(253, 426, FlxColor.TRANSPARENT, true);

		_assMeter = new FlxSprite(0, 0, AssetPaths.rhydbeads_assmeter__png);

		pushPath = new SegmentedPath();
		pushPath.pushNode(191, 19);
		pushPath.pushNode(191, 109);
		pushPath.pushNode(182, 128);
		pushPath.pushNode(171, 152);
		pushPath.pushNode(149, 178);
		pushPath.pushNode(129, 194);
		pushPath.pushNode(103, 211);
		pushPath.pushNode(71, 225);
		pushPath.pushNode(41, 232);
		pushPath.pushNode(15, 236);
		pushPath.pushNode(-100, 236);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		_mainBeadSprite.update(elapsed);
		_beadHandleSprite.update(elapsed);

		if (pushMode)
		{
			if (!isInteractive())
			{
				_interacting = false;
			}
			else
			{
				if (SexyState.toyMouseJustPressed())
				{
					_interacting = false;
					if (isMouseNearPushableBead() && moreBeadsToPush())
					{
						_interacting = true;
					}
				}
				if (_interacting && !FlxG.mouse.pressed)
				{
					_interacting = false;
					beadBlinkTimer = 0.8;
				}

				if (_interacting)
				{
					beadBlinkTimer = BLINK_FREQUENCY;
					if (_actualBeadPosition >= totalBeadCount)
					{
						// pushed final bead
					}
					else if (_actualBeadPosition >= _anchorBeadPosition + 1)
					{
						// already pushed in the bead...
						_desiredBeadPosition = _anchorBeadPosition + 1;
					}
					else
					{
						var beadVel:Float = Math.min(4, 0.6 * Math.pow(1.2, _anchorBeadPosition));
						_desiredBeadPosition += beadVel * elapsed;
					}
				}
				else
				{
					_desiredBeadPosition = _anchorBeadPosition;
				}

				if (beadBlinkTimer > 0)
				{
					beadBlinkTimer -= elapsed;
					if (beadBlinkTimer <= 0)
					{
						beadBlinkTimer += BLINK_FREQUENCY;
						_mainBeadSprite.animation.play("blink");
					}
				}
			}

			var assMeterAngle:Float = -25 + 23 * FlxMath.bound(Math.floor(_visualActualBeadPosition + 1 - RhydonBeadWindow.BEAD_BP_CENTER), 0, totalBeadCount);
			assMeterAngle -= Math.max(0, assMeterAngle - 70) * 0.4;
			assMeterAngle -= Math.max(0, assMeterAngle - 115) * 0.3;
			assMeterAngle -= Math.max(0, assMeterAngle - 160) * 0.2;
			if (totalBeadCount >= 20)
			{
				assMeterAngle -= Math.max(0, assMeterAngle - 185) * 0.6;
			}

			if (_visualAssMeterAngle != assMeterAngle)
			{
				var meterNeedleVelocity:Float = Math.abs(_visualAssMeterAngle - assMeterAngle) > 10 ? 27 : 9;
				if (_visualAssMeterAngle < assMeterAngle)
				{
					_visualAssMeterAngle = Math.min(assMeterAngle, _visualAssMeterAngle + meterNeedleVelocity * elapsed);
				}
				else
				{
					_visualAssMeterAngle = Math.max(assMeterAngle, _visualAssMeterAngle - meterNeedleVelocity * elapsed);
				}
			}
		}
		else {
			if (!isInteractive())
			{
				_interacting = false;
			}
			else {
				if (SexyState.toyMouseJustPressed())
				{
					_interacting = false;
					if (isMouseNearPullRing())
					{
						_interacting = true;
					}
				}
				if (_interacting && !FlxG.mouse.pressed)
				{
					_interacting = false;
					handleBlinkTimer = 0.8;
				}

				if (_interacting)
				{
					handleBlinkTimer = BLINK_FREQUENCY;
					var dist:Float = BEAD_ORIGIN.distanceTo(FlxG.mouse.getPosition());

					_desiredBeadPosition = _anchorBeadPosition - dist / DIST_BETWEEN_BEADS + LAX_CONSTANT;

					if (SexyState.toyMouseJustPressed() && _interacting)
					{
						_visualActualBeadPosition = _desiredBeadPosition;
						_actualBeadPosition = _desiredBeadPosition;
					}

					_currPoint.x = (FlxG.mouse.x - 3 - BEAD_ORIGIN.x) * ((_anchorBeadPosition - _visualActualBeadPosition + LAX_CONSTANT) / (_anchorBeadPosition - _desiredBeadPosition + LAX_CONSTANT)) + BEAD_ORIGIN.x;
					_currPoint.y = (FlxG.mouse.y - 3 - BEAD_ORIGIN.y) * ((_anchorBeadPosition - _visualActualBeadPosition + LAX_CONSTANT) / (_anchorBeadPosition - _desiredBeadPosition + LAX_CONSTANT)) + BEAD_ORIGIN.y;
				}
				else {
					_currPoint.x = HANDLE_ORIGIN.x;
					_currPoint.y = HANDLE_ORIGIN.y;
				}

				if (handleBlinkTimer > 0)
				{
					handleBlinkTimer -= elapsed;
					if (handleBlinkTimer <= 0)
					{
						handleBlinkTimer += BLINK_FREQUENCY;
						_beadHandleSprite.animation.play("blink");
					}
				}
			}
		}

		if (_visualActualBeadPosition != _actualBeadPosition)
		{
			var beadVelocity:Float = Math.abs(_visualActualBeadPosition - _actualBeadPosition) > 0.2 ? 9.2 : 4.6;
			if (_visualActualBeadPosition < _actualBeadPosition)
			{
				_visualActualBeadPosition = Math.min(_actualBeadPosition, _visualActualBeadPosition + beadVelocity * elapsed);
			}
			else
			{
				_visualActualBeadPosition = Math.max(_actualBeadPosition, _visualActualBeadPosition - beadVelocity * elapsed);
			}
		}
	}

	override public function draw():Void
	{
		_bgSprite.animation.frameIndex = pushMode ? 1 : 0;
		_canvas.stamp(_bgSprite, 0, 0); // draw bg sprite...

		FlxSpriteUtil.fill(_purpleCanvas, FlxColor.TRANSPARENT);

		if (pushMode)
		{
			var tmpBeadPosition:Float = (_visualActualBeadPosition + 1000) % 1;
			var tmpBeadIndex:Int = Math.floor(_visualActualBeadPosition);

			// draw beads...
			var pathPoint0:FlxPoint = FlxPoint.get();
			var pathPoint1:FlxPoint = FlxPoint.get();
			for (i in 0...6)
			{
				if (tmpBeadIndex + i - 1 < 0)
				{
					// no more beads to pull out
					continue;
				}

				if (tmpBeadIndex + i - 1 > totalBeadCount)
				{
					// no more beads to push in
					continue;
				}

				pathPoint0 = pushPath.getPathPoint((i + INTERACTABLE_PUSH_BEAD_DIST - 1 - tmpBeadPosition) * DIST_BETWEEN_BEADS, pathPoint0);

				if (tmpBeadIndex + i - 1 == totalBeadCount)
				{
					_purpleCanvas.stamp(_beadHandleSprite, Std.int(pathPoint0.x - 40), Std.int(pathPoint0.y - 40));
				}
				else
				{
					if (i == 1)
					{
						// we draw the "main bead sprite" later, so that it doesn't get covered by strings
					}
					else
					{
						_purpleCanvas.stamp(_beadSprite, Std.int(pathPoint0.x - 40), Std.int(pathPoint0.y - 40));
					}
				}

				if (tmpBeadIndex + i > totalBeadCount || i == 6 - 1)
				{
					// no line to next bead
					continue;
				}

				pathPoint1 = pushPath.getPathPoint((i + 0.8 + INTERACTABLE_PUSH_BEAD_DIST - 1 - tmpBeadPosition) * DIST_BETWEEN_BEADS, pathPoint1);
				// draw line to next bead
				FlxSpriteUtil.drawLine(_purpleCanvas, pathPoint0.x, pathPoint0.y, pathPoint1.x, pathPoint1.y, {thickness: 15, color: SHADOW_COLOR});
			}
			{
				if (tmpBeadIndex < 0)
				{
					// no more beads to pull out
				}
				else if (tmpBeadIndex >= totalBeadCount)
				{
					// no more beads to push in
				}
				else
				{
					pathPoint0 = pushPath.getPathPoint((INTERACTABLE_PUSH_BEAD_DIST - tmpBeadPosition) * DIST_BETWEEN_BEADS, pathPoint0);
					if (isMouseNearPushableBead() && moreBeadsToPush() && tmpBeadPosition == 0 && !_interacting && isInteractive())
					{
						// highlight pushable bead
						_purpleCanvas.stamp(_mainBeadHighlightSprite, Std.int(pathPoint0.x - 40), Std.int(pathPoint0.y - 40));
					}
					else
					{
						_purpleCanvas.stamp(_mainBeadSprite, Std.int(pathPoint0.x - 40), Std.int(pathPoint0.y - 40));
					}
				}
			}

			// draw ass meter...
			_purpleCanvas.stamp(_assMeter, Std.int(201 - _assMeter.width / 2), Std.int(69 - _assMeter.height / 2));
			var _meterNeedleEnd:FlxPoint = FlxPoint.get( -25, 0);
			_meterNeedleEnd.pivotDegrees(FlxPoint.weak(0, 0), _visualAssMeterAngle);
			FlxSpriteUtil.drawLine(_purpleCanvas, 201, 69, 201 + _meterNeedleEnd.x, 69 + _meterNeedleEnd.y, {thickness: 4, color: SHADOW_COLOR});
			for (i in 0..._meterNeedleHead.length)
			{
				_meterNeedleHead[i].set(_meterNeedleHeadTemplate[i].x, _meterNeedleHeadTemplate[i].y).pivotDegrees(FlxPoint.weak(0, 0), _visualAssMeterAngle);
				_meterNeedleHead[i].set(_meterNeedleHead[i].x + 201 + _meterNeedleEnd.x, _meterNeedleHead[i].y + 69 + _meterNeedleEnd.y);
			}
			FlxSpriteUtil.drawPolygon(_purpleCanvas, _meterNeedleHead, SHADOW_COLOR, {thickness:2, color: SHADOW_COLOR});
		}
		else {
			var stringVector:FlxPoint;
			if (isInteractive())
			{
				stringVector = FlxPoint.get(BEAD_ORIGIN.x - _currPoint.x, BEAD_ORIGIN.y - _currPoint.y);
				if (stringVector.x == 0 && stringVector.y == 0)
				{
					stringVector.x = 1;
					stringVector.y = -2;
				}
				stringVector.length = DIST_BETWEEN_BEADS;
				lineAngle = FlxMath.bound(1 - 2 * (MAX_LINE_ANGLE - Math.atan2(stringVector.y, stringVector.x)) / (MAX_LINE_ANGLE - MIN_LINE_ANGLE), -1, 1);
			}
			else {
				stringVector = FlxPoint.get(BEAD_ORIGIN.x - HANDLE_ORIGIN.x, BEAD_ORIGIN.y - HANDLE_ORIGIN.y);
				stringVector.length = DIST_BETWEEN_BEADS;
				lineAngle = 0;
			}

			var tmpBeadIndex:Int = Math.floor(_visualActualBeadPosition);

			// draw line to first bead...
			FlxSpriteUtil.drawLine(_purpleCanvas,
			_currPoint.x + 14, _currPoint.y - 21,
			Std.int(_currPoint.x + 1 * stringVector.x), Std.int(_currPoint.y + 1 * stringVector.y),
			{thickness: 15, color: SHADOW_COLOR});

			for (i in 1...totalBeadCount + 1)
			{
				// draw bead...
				_purpleCanvas.stamp(_beadSprite, Std.int(_currPoint.x + i * stringVector.x - 40), Std.int(_currPoint.y + i * stringVector.y - 40));

				if (i + 1 > totalBeadCount)
				{
					// no line to next bead
					continue;
				}

				// draw line to next bead...
				FlxSpriteUtil.drawLine(_purpleCanvas,
									   Std.int(_currPoint.x + i * stringVector.x), Std.int(_currPoint.y + i * stringVector.y),
									   Std.int(_currPoint.x + (i + 1) * stringVector.x), Std.int(_currPoint.y + (i + 1) * stringVector.y),
				{thickness: 15, color: SHADOW_COLOR});

				if (_currPoint.x > 253 + 50 || _currPoint.y < -50)
				{
					// beads went offscreen; interrupt the loop
					break;
				}
			}

			// draw ring...
			_purpleCanvas.stamp(_beadHandleSprite, Std.int(_currPoint.x - 40), Std.int(_currPoint.y - 40));

			if (isMouseNearPullRing() && !_interacting && isInteractive())
			{
				// highlight pullable ring
				_purpleCanvas.stamp(_beadHandleHighlightSprite, Std.int(_currPoint.x - 40), Std.int(_currPoint.y - 40));
			}
		}

		_canvas.stamp(_purpleCanvas, 0, 0);

		// erase unused bits...
		{
			var poly:Array<FlxPoint> = [];
			poly.push(FlxPoint.get(253, 426));
			poly.push(FlxPoint.get(253, 188));
			poly.push(FlxPoint.get(171, 426));
			FlxSpriteUtil.drawPolygon(_canvas, poly, 0xFF80684E, null, {blendMode:BlendMode.ERASE});
			FlxDestroyUtil.putArray(poly);
		}
		{
			var poly:Array<FlxPoint> = [];
			poly.push(FlxPoint.get(0, 0));
			poly.push(FlxPoint.get(153, 0));
			poly.push(FlxPoint.get(0, 269));
			FlxSpriteUtil.drawPolygon(_canvas, poly, 0xFF80684E, null, {blendMode:BlendMode.ERASE});
			FlxDestroyUtil.putArray(poly);
		}

		#if !flash
		// BlendMode.ERASE is not supported by non-flash targets, so we manually erase the pixels
		// with a threshold() call
		_canvas.pixels.threshold(_canvas.pixels, _canvas.pixels.rect, new Point(0, 0), "==", 0xFF80684E);
		#end

		// draw border...
		{
			var poly:Array<FlxPoint> = [];
			poly.push(FlxPoint.get(153, 1));
			poly.push(FlxPoint.get(252, 1));
			poly.push(FlxPoint.get(252, 188));
			poly.push(FlxPoint.get(171, 425));
			poly.push(FlxPoint.get(1, 425));
			poly.push(FlxPoint.get(1, 269));
			poly.push(FlxPoint.get(153, 1));
			FlxSpriteUtil.drawPolygon(_canvas, poly, FlxColor.TRANSPARENT, { thickness: 2, color: FlxColor.BLACK });
			FlxDestroyUtil.putArray(poly);
		}

		// erase corners...
		_canvas.pixels.setPixel32(0, Std.int(_canvas.height - 1), 0x00000000);
		_canvas.pixels.setPixel32(Std.int(_canvas.width-1), 0, 0x00000000);
		_canvas.draw();
	}

	public function isMouseNearPushableBead():Bool
	{
		var clickTarget0:FlxPoint = pushPath.getPathPoint(INTERACTABLE_PUSH_BEAD_DIST * DIST_BETWEEN_BEADS);
		clickTarget0.x += 3;
		clickTarget0.y += 3;
		return FlxG.mouse.getPosition().distanceTo(clickTarget0) <= 50;
	}

	public function isMouseNearPullRing()
	{
		return FlxG.mouse.getPosition().distanceTo(FlxPoint.get(HANDLE_ORIGIN.x + 3, HANDLE_ORIGIN.y + 3)) <= 50;
	}

	public function moreBeadsToPush()
	{
		return _actualBeadPosition < totalBeadCount;
	}

	public function setInteractive(interactive:Bool, duration:Float)
	{
		if (duration == 0)
		{
			_interactiveTimer = interactive ? 1.0 : 0.0;
		}
		else
		{
			if (!interactive)
			{
				pointTween = FlxTweenUtil.retween(pointTween, _currPoint, {x:60, y:-120}, duration, {ease:FlxEase.circOut});
			}
			else
			{
				pointTween = FlxTweenUtil.retween(pointTween, _currPoint, {x:HANDLE_ORIGIN.x, y:HANDLE_ORIGIN.y}, duration, {ease:FlxEase.circOut});
			}
			interactiveTween = FlxTweenUtil.retween(interactiveTween, this, {_interactiveTimer:interactive ? 1.0 : 0.0}, duration);
		}
		if (interactive)
		{
			handleBlinkTimer = duration + 0.8;
			beadBlinkTimer = duration + 0.8;
		}
	}

	public function isInteractive():Bool
	{
		return _interactiveTimer >= 1.0;
	}

	override public function destroy():Void
	{
		super.destroy();

		_bgSprite = FlxDestroyUtil.destroy(_bgSprite);
		_beadSprite = FlxDestroyUtil.destroy(_beadSprite);
		_mainBeadSprite = FlxDestroyUtil.destroy(_mainBeadSprite);
		_mainBeadHighlightSprite = FlxDestroyUtil.destroy(_mainBeadHighlightSprite);
		_beadHandleSprite = FlxDestroyUtil.destroy(_beadHandleSprite);
		_beadHandleHighlightSprite = FlxDestroyUtil.destroy(_beadHandleHighlightSprite);
		_purpleCanvas = FlxDestroyUtil.destroy(_purpleCanvas);
		_assMeter = FlxDestroyUtil.destroy(_assMeter);
		_meterNeedleHeadTemplate = FlxDestroyUtil.putArray(_meterNeedleHeadTemplate);
		_meterNeedleHead = FlxDestroyUtil.putArray(_meterNeedleHead);
		_currPoint = FlxDestroyUtil.put(_currPoint);
		_canvas = FlxDestroyUtil.destroy(_canvas);
		pushPath = FlxDestroyUtil.destroy(pushPath);
		pointTween = FlxTweenUtil.destroy(pointTween);
		interactiveTween = FlxTweenUtil.destroy(interactiveTween);
	}
}