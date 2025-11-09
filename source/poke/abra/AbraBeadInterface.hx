package poke.abra;
import openfl.geom.Point;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import openfl.display.BlendMode;
import poke.sexy.SexyState;

/**
 * The simplistic window on the side which lets the player interact with Abra's
 * anal bead sequence
 */
class AbraBeadInterface extends FlxSpriteGroup
{
	private static var INTERACTABLE_PUSH_BEAD_DIST:Float = 0.9;
	private static var MAX_LINE_ANGLE:Float = -1.3192;
	private static var MIN_LINE_ANGLE:Float = -0.7854;
	private static var RELEASE_TIME:Float = 0.5;
	private static var APPEAR_TIME:Float = 0.2;
	private static var BLINK_FREQUENCY:Float = 5;
	private static var SHADOW_COLOR:FlxColor = 0xff3e3e50;
	private static var DIST_BETWEEN_BEADS:Float = 65;
	private static var BEAD_ORIGIN:FlxPoint = FlxPoint.get(310, -95);
	private static var LAX_CONSTANT:Float = 3.6;

	private var _bgSprite:FlxSprite;
	private var _beadSprite:FlxSprite;
	private var _mainBeadSprite:FlxSprite;
	private var _mainBeadHighlightSprite:FlxSprite;
	private var _beadHandleSprite:FlxSprite;
	private var _beadHandleHighlightSprite:FlxSprite;
	private var _purpleCanvas:FlxSprite;
	private var _assMeter:FlxSprite;
	private var _canvas:FlxSprite;

	public var _desiredBeadPosition:Float = 0;
	public var _actualBeadPosition:Float = 0;
	public var _visualActualBeadPosition:Float = 0; // pull distance being displayed; for tweening purposes

	private var _currPoint:FlxPoint = FlxPoint.get();
	public var _pullingBeads:Bool = false; // user is currently dragging to pull beads out

	private var releaseTimer:Float = 0;
	private var appearTimer:Float = 0;
	private var ringBlinkTimer:Float = 0.5;
	private var beadBlinkTimer:Float = 0.5;
	public var interactive:Bool = true;
	public var pushMode:Bool = true;
	public var canEndPushMode:Bool = false;

	public var pulledBeads:Int = 1000;
	public var lineAngle:Float = 0; // number ranging from [-1.0, 1.0] for left/right
	private var pushPath:SegmentedPath;
	private var _meterNeedleHeadTemplate:Array<FlxPoint> = [FlxPoint.get( -4, 0), FlxPoint.get(4, -6), FlxPoint.get(4, 6)];
	private var _meterNeedleHead:Array<FlxPoint> = [FlxPoint.get(), FlxPoint.get(), FlxPoint.get()];
	private var _visualAssMeterAngle:Float = -25;
	private var _pushRingX:Float = 80; // x-offset for the ring which ends "bead pushing mode"

	public function new()
	{
		super();
		_bgSprite = new FlxSprite();
		_bgSprite.loadGraphic(AssetPaths.abrabeads_iface__png, true, 253, 426);
		_beadSprite = new FlxSprite(0, 0);
		_beadSprite.loadGraphic(AssetPaths.abra_bead_shadow__png, true, 50, 50);

		_mainBeadSprite = new FlxSprite(0, 0);
		_mainBeadSprite.loadGraphic(AssetPaths.abra_bead_shadow__png, true, 50, 50);
		_mainBeadSprite.animation.add("default", [0, 0]);
		_mainBeadSprite.animation.add("blink", [1, 1, 2, 3, 4, 5, 5, 0], 20, false);

		_mainBeadHighlightSprite = new FlxSprite(0, 0);
		_mainBeadHighlightSprite.loadGraphic(AssetPaths.abra_bead_shadow__png, true, 50, 50);
		_mainBeadHighlightSprite.animation.frameIndex = 3;

		_beadHandleSprite = new FlxSprite(0, 0);
		_beadHandleSprite.loadGraphic(AssetPaths.abra_bead_shadow_handle__png, true, 50, 50);
		_beadHandleSprite.animation.add("default", [0, 0]);
		_beadHandleSprite.animation.add("blink", [1, 1, 2, 3, 4, 5, 5, 0], 20, false);
		_beadHandleSprite.animation.play("default");

		_beadHandleHighlightSprite = new FlxSprite(0, 0);
		_beadHandleHighlightSprite.loadGraphic(AssetPaths.abra_bead_shadow_handle__png, true, 50, 50);
		_beadHandleHighlightSprite.animation.frameIndex = 3;

		_canvas = new FlxSprite(3, 3);
		_canvas.makeGraphic(253, 426, FlxColor.WHITE, true);
		_purpleCanvas = new FlxSprite();
		_purpleCanvas.makeGraphic(253, 426, FlxColor.TRANSPARENT, true);

		_assMeter = new FlxSprite(0, 0, AssetPaths.abrabeads_assmeter__png);

		pushPath = new SegmentedPath();
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
		_beadHandleSprite.update(elapsed);
		_mainBeadSprite.update(elapsed);
		if (pushMode)
		{
			if (SexyState.toyMouseJustPressed())
			{
				if (isMouseNearPushableBead())
				{
					beadBlinkTimer = BLINK_FREQUENCY;
				}

				if (isMouseNearPushRing() && releaseTimer <= 0)
				{
					releaseTimer = RELEASE_TIME;
				}
			}

			if (_visualActualBeadPosition != _actualBeadPosition)
			{
				var beadVelocity:Float = Math.abs(_visualActualBeadPosition - _actualBeadPosition) > 0.2 ? 12 : 6;
				if (_visualActualBeadPosition < _actualBeadPosition)
				{
					_visualActualBeadPosition = Math.min(_actualBeadPosition, _visualActualBeadPosition + beadVelocity * elapsed);
				}
				else
				{
					_visualActualBeadPosition = Math.max(_actualBeadPosition, _visualActualBeadPosition - beadVelocity * elapsed);
				}
			}

			var assMeterAngle:Float = -25 + 8 * getBeadsPushed();
			assMeterAngle -= Math.max(0, assMeterAngle - 140) * 0.6;
			assMeterAngle -= Math.max(0, assMeterAngle - 200) * 0.4;
			assMeterAngle -= Math.max(0, assMeterAngle - 230) * 0.3;

			if (_visualAssMeterAngle != assMeterAngle)
			{
				var meterNeedleVelocity:Float = Math.abs(_visualAssMeterAngle - assMeterAngle) > 20 ? 27 : 9;
				if (_visualAssMeterAngle < assMeterAngle)
				{
					_visualAssMeterAngle = Math.min(assMeterAngle, _visualAssMeterAngle + meterNeedleVelocity * elapsed);
				}
				else
				{
					_visualAssMeterAngle = Math.max(assMeterAngle, _visualAssMeterAngle - meterNeedleVelocity * elapsed);
				}
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
		else {
			if (releaseTimer > 0)
			{
				releaseTimer -= elapsed;

				if (interactive && releaseTimer <= 0)
				{
					appearTimer = APPEAR_TIME;
					ringBlinkTimer = APPEAR_TIME + 0.5;
				}
			}

			if (appearTimer > 0)
			{
				appearTimer -= elapsed;
			}

			if (interactive && SexyState.toyMouseJustPressed())
			{
				_pullingBeads = false;
				if (releaseTimer > 0)
				{
					// non-interactive; mouse was just released
				}
				else if (isMouseNearPullRing())
				{
					_pullingBeads = true;
				}
			}

			if (interactive && _pullingBeads)
			{
				ringBlinkTimer = BLINK_FREQUENCY;
				var dist:Float = BEAD_ORIGIN.distanceTo(FlxG.mouse.getPosition());

				_desiredBeadPosition = dist / DIST_BETWEEN_BEADS - LAX_CONSTANT;

				if (SexyState.toyMouseJustPressed() && _pullingBeads)
				{
					_visualActualBeadPosition = _desiredBeadPosition;
					_actualBeadPosition = _desiredBeadPosition;
				}

				if (_visualActualBeadPosition != _actualBeadPosition)
				{
					var beadVelocity:Float = Math.abs(_visualActualBeadPosition - _actualBeadPosition) > 0.2 ? 12 : 6;
					if (_visualActualBeadPosition < _actualBeadPosition)
					{
						_visualActualBeadPosition = Math.min(_actualBeadPosition, _visualActualBeadPosition + beadVelocity * elapsed);
					}
					else
					{
						_visualActualBeadPosition = Math.max(_actualBeadPosition, _visualActualBeadPosition - beadVelocity * elapsed);
					}
				}

				_currPoint.x = (FlxG.mouse.x - 3 - BEAD_ORIGIN.x) * ((_visualActualBeadPosition + LAX_CONSTANT) / (_desiredBeadPosition + LAX_CONSTANT)) + BEAD_ORIGIN.x;
				_currPoint.y = (FlxG.mouse.y - 3 - BEAD_ORIGIN.y) * ((_visualActualBeadPosition + LAX_CONSTANT) / (_desiredBeadPosition + LAX_CONSTANT)) + BEAD_ORIGIN.y;
			}
			else {
				if (releaseTimer > 0)
				{
				}
				else {
					_desiredBeadPosition = 0;
					_actualBeadPosition = 0;
					_visualActualBeadPosition = 0;

					_currPoint.x = 222;
					_currPoint.y = 55;
				}
			}
		}

		if (ringBlinkTimer > 0)
		{
			ringBlinkTimer -= elapsed;
			if (ringBlinkTimer <= 0)
			{
				ringBlinkTimer += BLINK_FREQUENCY;
				_beadHandleSprite.animation.play("blink");
			}
		}
	}

	public function justFinishedPushMode():Bool
	{
		return pushMode == true && releaseTimer == RELEASE_TIME;
	}

	override public function draw():Void
	{
		_bgSprite.animation.frameIndex = pushMode ? 1 : 0;
		_canvas.stamp(_bgSprite, 0, 0); // draw bg sprite...

		FlxSpriteUtil.fill(_purpleCanvas, FlxColor.TRANSPARENT);

		if (pushMode)
		{
			// draw string...
			for (i in 1...pushPath.nodes.length)
			{
				if (getBeadsPushed() == 0 && i < 3)
				{
					// first bead; no string
					continue;
				}
				FlxSpriteUtil.drawLine(_purpleCanvas, pushPath.nodes[i - 1].x, pushPath.nodes[i - 1].y, pushPath.nodes[i].x, pushPath.nodes[i].y, {thickness: 8, color: SHADOW_COLOR});
			}

			// draw beads...
			var pathPoint:FlxPoint = FlxPoint.get();
			for (i in 0...6)
			{
				pathPoint = pushPath.getPathPoint((i + INTERACTABLE_PUSH_BEAD_DIST + _visualActualBeadPosition) * DIST_BETWEEN_BEADS, pathPoint);
				_purpleCanvas.stamp(i == 0 ? _mainBeadSprite : _beadSprite, Std.int(pathPoint.x - 25), Std.int(pathPoint.y - 25));
			}

			if (isMouseNearPushableBead() && _visualActualBeadPosition == 0)
			{
				pathPoint = pushPath.getPathPoint((INTERACTABLE_PUSH_BEAD_DIST + _visualActualBeadPosition) * DIST_BETWEEN_BEADS, pathPoint);
				pathPoint = pushPath.getPathPoint((INTERACTABLE_PUSH_BEAD_DIST + _visualActualBeadPosition) * DIST_BETWEEN_BEADS, pathPoint);
				// highlight pushable bead
				_purpleCanvas.stamp(_mainBeadHighlightSprite, Std.int(pathPoint.x - 25), Std.int(pathPoint.y - 25));
			}
			pathPoint.put();

			if (canEndPushMode)
			{
				if (_pushRingX == 80)
				{
					FlxTween.tween(this, {_pushRingX : 0}, 1, {ease:FlxEase.circOut});
				}

				// draw ring...
				_purpleCanvas.stamp(_beadHandleSprite, Std.int(Std.int(174 - 25) + _pushRingX), Std.int(291 - 25));

				// draw string...
				FlxSpriteUtil.drawLine(_purpleCanvas, 174 + 16 + _pushRingX, 291 - 4, 230 + _pushRingX, 280, {thickness: 8, color: SHADOW_COLOR});

				// draw bead...
				_purpleCanvas.stamp(_beadSprite, Std.int(230 - 25 + _pushRingX), 280 - 25);
			}

			if (isMouseNearPushRing() && releaseTimer <= 0)
			{
				// highlight pushable ring
				_purpleCanvas.stamp(_beadHandleHighlightSprite, Std.int(Std.int(174 - 25) + _pushRingX), Std.int(291 - 25));
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
			// draw string...
			FlxSpriteUtil.drawLine(_purpleCanvas, _currPoint.x + 9, _currPoint.y - 16, BEAD_ORIGIN.x, BEAD_ORIGIN.y, {thickness: 8, color: SHADOW_COLOR});

			// draw ring...
			_purpleCanvas.stamp(_beadHandleSprite, Std.int(_currPoint.x - 25), Std.int(_currPoint.y - 25));

			if (isMouseNearPullRing() && !_pullingBeads)
			{
				// highlight pullable ring
				_purpleCanvas.stamp(_beadHandleHighlightSprite, Std.int(_currPoint.x - 25), Std.int(_currPoint.y - 25));
			}

			// draw beads...
			var stringVector:FlxPoint = FlxPoint.get(BEAD_ORIGIN.x - _currPoint.x, BEAD_ORIGIN.y - _currPoint.y);
			if (stringVector.x == 0 && stringVector.y == 0)
			{
				stringVector.x = 1;
				stringVector.y = -2;
			}
			lineAngle = FlxMath.bound(1 - 2 * (MAX_LINE_ANGLE - Math.atan2(stringVector.y, stringVector.x)) / (MAX_LINE_ANGLE - MIN_LINE_ANGLE), -1, 1);
			stringVector.length = DIST_BETWEEN_BEADS;

			{
				var i:Int = 1;
				while (_currPoint.x + i * stringVector.x <= BEAD_ORIGIN.x && _currPoint.y - i * stringVector.y >= BEAD_ORIGIN.y && i < 20)
				{
					_purpleCanvas.stamp(_beadSprite, Std.int(_currPoint.x + i * stringVector.x - 25), Std.int(_currPoint.y + i * stringVector.y - 25));
					i++;
				}
			}

			if (releaseTimer > 0 || !interactive)
			{
				_purpleCanvas.alpha = releaseTimer / RELEASE_TIME;
			}
			else if (appearTimer > 0)
			{
				_purpleCanvas.alpha = (APPEAR_TIME - appearTimer) / APPEAR_TIME;
			}
			else {
				_purpleCanvas.alpha = 1;
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

	public function setInteractive(interactive:Bool)
	{
		if (this.interactive == interactive)
		{
			return;
		}
		this.interactive = interactive;
		if (interactive == false)
		{
			if (releaseTimer <= 0)
			{
				releaseTimer = RELEASE_TIME;
			}
		}
		else
		{
			if (appearTimer <= 0)
			{
				appearTimer = APPEAR_TIME;
			}
		}
	}

	public function isMouseNearPushableBead():Bool
	{
		var clickTarget0:FlxPoint = pushPath.getPathPoint(INTERACTABLE_PUSH_BEAD_DIST * DIST_BETWEEN_BEADS);
		clickTarget0.x += 3;
		clickTarget0.y += 3;
		return FlxG.mouse.getPosition().distanceTo(clickTarget0) <= 25;
	}

	public function isMouseNearPushRing():Bool
	{
		return canEndPushMode && FlxG.mouse.getPosition().distanceTo(FlxPoint.weak(174 + 3 + _pushRingX, 291 + 3)) <= 20;
	}

	public function isMouseNearPullRing()
	{
		return interactive && FlxG.mouse.getPosition().distanceTo(FlxPoint.get(222 + 3 + _pushRingX, 55 + 3)) <= 20;
	}

	public function getBeadsPushed():Int
	{
		return 1000 - pulledBeads;
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
		_canvas = FlxDestroyUtil.destroy(_canvas);
		_currPoint = FlxDestroyUtil.put(_currPoint);
		pushPath = FlxDestroyUtil.destroy(pushPath);
		_meterNeedleHeadTemplate = FlxDestroyUtil.putArray(_meterNeedleHeadTemplate);
		_meterNeedleHead = FlxDestroyUtil.putArray(_meterNeedleHead);
	}
}