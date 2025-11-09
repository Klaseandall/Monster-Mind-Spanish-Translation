package poke.rhyd;
import flixel.util.FlxDestroyUtil;
import poke.abra.SegmentedPath;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.display.BlendMode;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * Graphics for Rhydon during the anal bead sequence
 */
class RhydonBeadWindow extends PokeWindow
{
	public static var MAX_SLACK:Float = 0.9;
	public static var BEAD_BP_RADIUS:Float = 0.0064;
	public static var BEAD_BP_CENTER:Float = 0.5; // how far do we need to push to be past the midpoint of a bead?
	private static var BOUNCE_DURATION:Float = 9;
	private static var MIN_Y = -35;
	private static var CORNER_SIZE = 46;
	private static var LINE_THICKNESS = 18;
	public static var INITIAL_PULL_PAUSE_DURATION = 1.5;
	private static var SPHINCTER_COORDS = FlxPoint.get(171, 543);
	public var totalBeadCount:Int = 18;

	private var _cameraTween:FlxTween;

	public var _headDown:BouncySprite;
	private var _leftArm0:BouncySprite;
	private var _rightArmDown:BouncySprite;

	public var _headUp:BouncySprite;
	private var _leftArm1:BouncySprite;
	private var _rightArmUp:BouncySprite;
	private var _torsoUp:BouncySprite;

	public var _body:BouncySprite;
	public var _sphincter:BouncySprite;
	public var _sphincterMask:BouncySprite;
	public var _innerSphincterMask:BouncySprite;
	public var _ass:BouncySprite;
	private var _beads:BouncySprite;
	private var _tmpMask:FlxSprite; // a temporary buffer for when we need to mask stuff around the hand, without masking the hand
	private var _tmpBehind:FlxSprite; // a temporary buffer for when we need to draw stuff behind other stuff
	private var _beadBrush:FlxSprite;
	private var _handleBrush:FlxSprite;
	private var beadRadii:Array<Float> = [24, 27, 29, 32, 34, 36];
	private var resistAmounts:Array<Float> = [0.48, 0.54, 0.58, 0.64, 0.68, 0.72];
	public var beadSizes:Array<Int> = [];
	public var slack:Float = MAX_SLACK;
	private var visualSlack:Float = MAX_SLACK; // actual slack being displayed; for tweening purposes
	public var lineAngle:Float = 0; // number ranging from [-1.0, 1.0] for left/right
	private var visualLineAngle:Float = 0; // actual line angle being displayed; for tweening purposes

	public var _beadPosition:Float = 0; // 0: no beads inserted yet; 10: 10 beads inserted
	public var _visualBeadPosition:Float = 0; // actual bead position being displayed; for tweening purposes
	public var _playerInteractingWithHandle:Bool = false; // is the player's hand interacting with the anal bead handle?
	public var _playerHandNearHandle:Bool = false; // is the player's hand just chilling near the next anal bead?
	public var _playerShovingInBead:Bool = false; // is the player's hand pushing in an anal bead?
	public var _playerRestingHandOnSphincter:Bool = false; // is the player's hand pushing in an anal bead?
	public var _playerHandNearBead:Bool = false; // is the player's hand just chilling near the next anal bead?

	public var rhydonsTurn:Bool = false;
	private var rhydonStartBeadPosition:Float = 0;
	private var rhydonDesiredBeadPosition:Float = 0;
	private var rhydonPauseTime:Float = 0;
	public var rhydonBeadsToRemove:Float = 0;

	public var beadPullCallback:Int->Float->Float->Void;
	public var beadNudgeCallback:Int->Float->Float->Void;
	public var beadPushCallback:Int->Float->Float->Void;
	private var resistNudgeDuration:Float = 0;

	public var greyBeads:Bool = false;

	/**
	 * Normalized vectors for anal bead calculations.
	 *
	 * bv[0] = slope of line from center0 to center1
	 * bv[1] = average of bv[0] and bv[2]
	 * bv[2] = slope of line from center1 to center2
	 * bv[3] = average of bv[2] and bv[4]
	 * bv[4] = ...
	 */
	private var bv:Array<FlxPoint> = [];

	public function new(X:Float=0, Y:Float=0, Width:Int=248, Height:Int = 349)
	{
		super(X, Y, Width, Height);
		_cameraButtons.push({x:234, y:3, image:AssetPaths.camera_button__png, callback:() -> toggleCamera()});
		add(new FlxSprite( -54, MIN_Y, AssetPaths.rhydon_bg__png));

		_headDown = new BouncySprite( -54, -54, 4, BOUNCE_DURATION, 0.12, _age);
		loadTallGraphic(_headDown, RhydonResource.beadHead);
		_headDown.animation.add("default", blinkyAnimation([3, 4]), 3);
		_headDown.animation.play("default");
		addPart(_headDown);

		_leftArm0 = new BouncySprite( -54, -54, 2, BOUNCE_DURATION, 0.06, _age);
		loadTallGraphic(_leftArm0, AssetPaths.rhydbeads_left_arm0__png);
		_leftArm0.animation.frameIndex = 1;
		addPart(_leftArm0);

		_rightArmDown = new BouncySprite( -54, -54, 2, BOUNCE_DURATION, 0.06, _age);
		loadTallGraphic(_rightArmDown, AssetPaths.rhydbeads_right_arm__png);
		_rightArmDown.animation.add("default", [0]);
		_rightArmDown.animation.play("default");
		addPart(_rightArmDown);

		_body = new BreathingSprite( -54, -54, 0, BOUNCE_DURATION, 0, _age);
		loadTallGraphic(_body, AssetPaths.rhydbeads_body__png);
		_body.animation.add("down", [0, 1, 2, 3]);
		_body.animation.add("up", [4, 5, 6, 7]);
		_body.animation.play("down");
		addPart(_body);

		_torsoUp = new BouncySprite( -54, -54, 4, BOUNCE_DURATION, -0.06, _age);
		loadTallGraphic(_torsoUp, AssetPaths.rhydbeads_torso__png);
		addPart(_torsoUp);

		_ass = new BouncySprite( -54, -54 + 330, 0, BOUNCE_DURATION, 0, _age);
		_ass.loadGraphic(AssetPaths.rhydbeads_ass__png, true, 356, 330);
		addPart(_ass);

		_dick = new BouncySprite( -54, -54, PlayerData.rhydMale ? 2 : 0, BOUNCE_DURATION, 0.06, _age);
		loadTallGraphic(_dick, RhydonResource.beadDick);
		addPart(_dick);

		_rightArmUp = new BouncySprite( -54, -54, 4, BOUNCE_DURATION, -0.06, _age);
		loadTallGraphic(_rightArmUp, AssetPaths.rhydbeads_right_arm__png);
		_rightArmUp.animation.add("default", [1]);
		_rightArmUp.animation.play("default");
		addPart(_rightArmUp);

		_sphincter = new BouncySprite( -54, -54 + 330, 0, BOUNCE_DURATION, 0, _age);
		_sphincter.loadGraphic(AssetPaths.rhydbeads_sphincter__png, true, 356, 330);
		addPart(_sphincter);

		_beadBrush = new FlxSprite(0, 0);
		_beadBrush.loadGraphic(AssetPaths.anal_bead_xl_glass__png, true, 90, 90);
		_beadBrush.alpha = 0.6;

		_handleBrush = new FlxSprite(0, 0);
		_handleBrush.loadGraphic(AssetPaths.anal_bead_xl_glass_handle__png, true, 90, 90);
		_handleBrush.alpha = 0.6;

		_sphincterMask = new BouncySprite( -54, -54 + 330, 0, BOUNCE_DURATION, 0, _age);
		_sphincterMask.loadGraphic(AssetPaths.rhydbeads_sphincter_mask__png, true, 356, 330);

		_innerSphincterMask = new BouncySprite( -54, -54 + 330, 0, BOUNCE_DURATION, 0, _age);
		_innerSphincterMask.loadGraphic(AssetPaths.rhydbeads_inner_sphincter_mask__png, true, 356, 330);

		_tmpMask = new FlxSprite(0, 0);
		_tmpMask.makeGraphic(356, 660, FlxColor.TRANSPARENT, true);

		_tmpBehind = new FlxSprite(0, 0);
		_tmpBehind.makeGraphic(356, 660, FlxColor.TRANSPARENT, true);

		_beads = new BouncySprite( -54, -54, 0, BOUNCE_DURATION, 0, _age);
		_beads.makeGraphic(356, 660, FlxColor.TRANSPARENT, true);
		addVisualItem(_beads);

		_leftArm1 = new BouncySprite( -54, -54, 4, BOUNCE_DURATION, -0.06, _age);
		loadTallGraphic(_leftArm1, AssetPaths.rhydbeads_left_arm1__png);
		addPart(_leftArm1);

		_headUp = new BouncySprite( -54, -54, 8, BOUNCE_DURATION, -0.12, _age);
		_headUp.loadGraphic(RhydonResource.beadHead, true, 356, 330);
		_headUp.animation.add("default", blinkyAnimation([0, 1], [2]), 3);
		_headUp.animation.play("default");
		addPart(_headUp);

		_interact = new BouncySprite( -54, -54, _body._bounceAmount, _body._bounceDuration, _body._bouncePhase, _age);
		reinitializeHandSprites();

		beadSizes = [5, 5, 4, 4, 3, 3, 3, 3, 2, 2, 2, 2, 1, 1, 1, 1, 0, 0];
		syncCamera();
		setRhydonUp(false);
	}

	public function removeBeads(count:Int)
	{
		this.rhydonsTurn = true;
		rhydonPauseTime = INITIAL_PULL_PAUSE_DURATION;
		rhydonStartBeadPosition = Math.floor(getBeadPositionInt());
		rhydonDesiredBeadPosition = Math.floor(getBeadPositionInt());
		rhydonBeadsToRemove = Math.min(count, getBeadPositionInt());
	}

	public function getBeadPositionInt():Int
	{
		return Math.floor(_beadPosition + 1 - BEAD_BP_CENTER);
	}

	private function isRhydonUp():Bool
	{
		return _head == _headUp;
	}

	public function setRhydonUp(rhydonUp:Bool):Void
	{
		_head = rhydonUp ? _headUp : _headDown;

		_headDown.visible = !rhydonUp;
		_rightArmDown.visible = !rhydonUp;

		_headUp.visible = rhydonUp;
		_rightArmUp.visible = rhydonUp;
		_torsoUp.visible = rhydonUp;

		_body.animation.play(rhydonUp ? "up" : "down");
	}

	public function syncCamera():Void
	{
		if (cameraPosition.y <= 0 != PlayerData.rhydonCameraUp)
		{
			toggleCamera(0);
		}
	}

	function loadTallGraphic(Sprite:BouncySprite, SimpleGraphic:FlxGraphicAsset)
	{
		Sprite.loadGraphic(SimpleGraphic, true, 356, 660);
	}

	override public function resize(Width:Int = 248, Height:Int = 350)
	{
		var oldHeight = _canvas.height;
		super.resize(Width, Height);
		if (cameraPosition.y > 0)
		{
			for (member in members)
			{
				member.y += Height - oldHeight;
			}
			cameraPosition.y -= Height - oldHeight;
		}
	}

	public function toggleCamera(tweenDuration:Float = 0.3):Void
	{
		if (_cameraTween == null || !_cameraTween.active)
		{
			var scrollAmount:Float = _canvas.height - 590;
			if (cameraPosition.y > 0)
			{
				// move camera up
				scrollAmount *= -1;
				PlayerData.rhydonCameraUp = true;
			}
			else
			{
				// move camera down
				PlayerData.rhydonCameraUp = false;
			}
			if (tweenDuration > 0)
			{
				for (member in members)
				{
					FlxTween.tween(member, {y: member.y + scrollAmount}, tweenDuration, {ease:FlxEase.circOut});
				}
				_cameraTween = FlxTween.tween(cameraPosition, {y: cameraPosition.y - scrollAmount}, tweenDuration, {ease:FlxEase.circOut});
			}
			else
			{
				for (member in members)
				{
					member.y += scrollAmount;
				}
				cameraPosition.y -= scrollAmount;
			}
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (rhydonsTurn)
		{
			if (rhydonPauseTime > 0)
			{
				rhydonPauseTime -= elapsed;
			}
			else if (rhydonBeadsToRemove == 0)
			{
				// done removing beads, but still holding them in his hand
				_beadPosition = getBeadPositionInt();
			}
			else
			{
				var rhydonPullSpeed:Float = [1.10, 0.87, 0.70, 0.56, 0.45, 0.36][getBeadSize(getBeadPositionInt() - 1)];

				rhydonDesiredBeadPosition -= elapsed * rhydonPullSpeed;
				var pulledBead:Bool = tryPullingBeads(rhydonDesiredBeadPosition, elapsed);
				if (pulledBead)
				{
					// just pulled one out
					rhydonBeadsToRemove--;
					if (rhydonBeadsToRemove <= 0)
					{
						rhydonPauseTime = 1.05;
						_beadPosition = getBeadPositionInt();

						// move arm for the final bead being pulled
						if (isRhydonUp())
						{
							_leftArm1.animation.frameIndex = Std.int(FlxMath.bound(_leftArm1.animation.frameIndex + 1, 1, 7));
						}
						else
						{
							_leftArm1.animation.frameIndex = Std.int(FlxMath.bound(_leftArm1.animation.frameIndex + 1, 8, 11));
						}
					}
				}
			}
			if (rhydonGrabbingLine())
			{
				slack = 0;
			}
		}

		if (_visualBeadPosition != _beadPosition)
		{
			var beadVelocity:Float = Math.abs(_visualBeadPosition - _beadPosition) > 0.2 ? 9.2 : 4.6;
			if (_visualBeadPosition < _beadPosition)
			{
				_visualBeadPosition = Math.min(_beadPosition, _visualBeadPosition + beadVelocity * elapsed);
			}
			else
			{
				_visualBeadPosition = Math.max(_beadPosition, _visualBeadPosition - beadVelocity * elapsed);
			}
		}

		if (visualLineAngle != lineAngle)
		{
			if (visualLineAngle < lineAngle)
			{
				visualLineAngle = Math.min(lineAngle, visualLineAngle + 18 * elapsed);
			}
			else
			{
				visualLineAngle = Math.max(lineAngle, visualLineAngle - 18 * elapsed);
			}
		}

		if (visualSlack != slack)
		{
			if (visualSlack < slack)
			{
				visualSlack = Math.min(slack, visualSlack + 18 * elapsed);
			}
			else
			{
				visualSlack = Math.max(slack, visualSlack - 18 * elapsed);
			}
		}

		FlxSpriteUtil.fill(_beads, FlxColor.TRANSPARENT);

		var tmpBeadPosition:Float = (_visualBeadPosition + 1000) % 1;
		var tmpBeadIndex:Int = Math.floor(_visualBeadPosition - 2);

		// at _visualBeadPosition=0.5, when the first bead is half-inserted, beadRadius is the radius of bead #0.
		var beadRadius:Float = getBeadRadius(Math.round(_visualBeadPosition - BEAD_BP_CENTER));
		var beadBpRadius:Float = beadRadius * BEAD_BP_RADIUS;
		/*
		 * A perfect ellipse would be "2", but we set this to "1.6" for a slightly pointy ellipse...
		 * This way the sphincter stays slightly narrower than it should, except at max radius
		 */
		var ellipseFudgeFactor:Float = 1.6;
		var sphincterRadius:Float = beadRadius * Math.pow(Math.max(0, 1 - Math.pow(Math.abs(tmpBeadPosition - BEAD_BP_CENTER), ellipseFudgeFactor) / Math.pow(beadBpRadius, ellipseFudgeFactor)), 0.5);

		if (sphincterRadius >= 39)
		{
			_sphincter.animation.frameIndex = 7;
		}
		else if (sphincterRadius >= 36)
		{
			_sphincter.animation.frameIndex = 6;
		}
		else if (sphincterRadius >= 32)
		{
			_sphincter.animation.frameIndex = 5;
		}
		else if (sphincterRadius >= 27)
		{
			_sphincter.animation.frameIndex = 4;
		}
		else if (sphincterRadius >= 21)
		{
			_sphincter.animation.frameIndex = 3;
		}
		else if (sphincterRadius >= 15)
		{
			_sphincter.animation.frameIndex = 2;
		}
		else {
			if (_visualBeadPosition < 0 + BEAD_BP_CENTER)
			{
				// sphincter is closed; beads are completely out
				_sphincter.animation.frameIndex = 0;
			}
			else if (_visualBeadPosition > totalBeadCount + BEAD_BP_CENTER)
			{
				// sphincter is closed; beads are completely in (oops... ... ...why did you insert the handle?)
				_sphincter.animation.frameIndex = 0;
			}
			else {
				// sphincter is still open, because the line has a radius
				_sphincter.animation.frameIndex = 1;
			}
		}
		_ass.animation.frameIndex = _sphincter.animation.frameIndex;

		if (rhydonsTurn)
		{
			if (rhydonPauseTime > 0)
			{
				if (isRhydonUp())
				{
					if (rhydonBeadsToRemove > 0)
					{
						// reach down for the first bead
						_leftArm1.animation.frameIndex = Math.floor(FlxMath.bound(1 + rhydonPauseTime * 12, 1, 7));
					}
					else
					{
						// don't move
					}
					_leftArm0.animation.frameIndex = 0;
				}
				else
				{
					if (rhydonBeadsToRemove > 0)
					{
						// reach down for the next bead
						_leftArm1.animation.frameIndex = Math.floor(FlxMath.bound(8 + rhydonPauseTime * 8, 8, 11));
					}
					else
					{
						_leftArm1.animation.frameIndex = 11;
					}
					_leftArm0.animation.frameIndex = 0;
				}
			}
			else
			{
				if (isRhydonUp())
				{
					var dist:Float = rhydonStartBeadPosition - _beadPosition;
					if (dist >= 2.5 - 0.1)
					{
						_leftArm1.animation.frameIndex = 7;
					}
					else if (dist >= 2.0 - 0.2)
					{
						_leftArm1.animation.frameIndex = 6;
					}
					else if (dist >= 1.6 - 0.3)
					{
						_leftArm1.animation.frameIndex = 5;
					}
					else if (dist >= 1.2 - 0.3)
					{
						_leftArm1.animation.frameIndex = 4;
					}
					else if (dist >= 0.8 - 0.3)
					{
						_leftArm1.animation.frameIndex = 3;
					}
					else if (dist >= 0.4 - 0.3)
					{
						_leftArm1.animation.frameIndex = 2;
					}
					else
					{
						_leftArm1.animation.frameIndex = 1;
					}
					_leftArm0.animation.frameIndex = 0;
				}
				else
				{
					var dist:Float = rhydonStartBeadPosition - _beadPosition;
					if (dist >= 2.5)
					{
						_leftArm1.animation.frameIndex = 11;
						_leftArm0.animation.frameIndex = 2;
					}
					else if (dist >= 1.5)
					{
						_leftArm1.animation.frameIndex = 10;
						_leftArm0.animation.frameIndex = 2;
					}
					else if (dist >= 0.5)
					{
						_leftArm1.animation.frameIndex = 9;
						_leftArm0.animation.frameIndex = 2;
					}
					else
					{
						_leftArm1.animation.frameIndex = 8;
						_leftArm0.animation.frameIndex = 3;
					}
				}
			}
		}
		else {
			_leftArm0.animation.frameIndex = 1;
			_leftArm1.animation.frameIndex = 0;
		}

		var path:SegmentedPath = new SegmentedPath();
		if (rhydonGrabbingLine())
		{
			path.pushNode(182, 471);
			path.pushNode(SPHINCTER_COORDS.x, SPHINCTER_COORDS.y);

			if (isRhydonUp())
			{
				path.pushNode(161, 553);
				if (_leftArm1.animation.frameIndex == 1)
				{
					path.pushNode(140, 530);
				}
				else if (_leftArm1.animation.frameIndex == 2)
				{
					path.pushNode(130, 510);
				}
				else if (_leftArm1.animation.frameIndex == 3)
				{
					path.pushNode(120, 490);
				}
				else if (_leftArm1.animation.frameIndex == 4)
				{
					path.pushNode(100, 470);
				}
				else if (_leftArm1.animation.frameIndex == 5)
				{
					path.pushNode(80, 450);
				}
				else if (_leftArm1.animation.frameIndex == 6)
				{
					path.pushNode(60, 430);
				}
				else
				{
					path.pushNode(40, 410);
				}
				path.pushNode(-80, 540);
			}
			else
			{
				path.pushNode(0, 315);
			}
		}
		else {
			path.pushNode(182, 471);
			path.pushNode(SPHINCTER_COORDS.x, SPHINCTER_COORDS.y);
			var beadVector:FlxPoint = FlxPoint.get( -30, 360);
			beadVector.rotateByRadians( -Math.PI * 0.06 * visualLineAngle);
			beadVector.y *= 0.6;
			path.pushNode(path.nodes[path.nodes.length - 1].x + beadVector.x, path.nodes[path.nodes.length - 1].y + beadVector.y);
		}

		var beadCoords:Array<FlxPoint> = [];
		for (i in 0...12)
		{
			var dist:Float = (i - tmpBeadPosition) * 50;
			if (rhydonGrabbingLine() && !isRhydonUp())
			{
				if (dist > 100)
				{
					dist = dist * 0.71 + 100 * 0.29;
				}
			}
			beadCoords.push(path.getPathPoint(dist));
		}

		for (i in 0...12)
		{
			var dist:Float = Math.max(0, i - tmpBeadPosition - 1.8);
			beadCoords[i].y += visualSlack * Math.pow(dist * 20, 0.6);
		}

		while (bv.length < beadCoords.length * 2 + 1)
		{
			bv.push(FlxPoint.get());
		}

		bv[0] = bv[0].set(beadCoords[0].x - 189, beadCoords[0].y - 421).normalize();
		for (i in 1...beadCoords.length)
		{
			bv[i * 2] = bv[i * 2].set(beadCoords[i].x - beadCoords[i - 1].x, beadCoords[i].y - beadCoords[i - 1].y).normalize();
			bv[i * 2 - 1] = bv[i * 2 - 1].set(bv[i * 2 - 2].x + bv[i * 2].x, bv[i * 2 - 2].y + bv[i * 2].y).normalize();
		}

		for (i in 0...beadCoords.length)
		{
			var magicNumber0:Float = magicNumber(tmpBeadIndex + i);
			var magicNumber1:Float = magicNumber(tmpBeadIndex + i + 1);
			if (rhydonGrabbingLine() && !isRhydonUp())
			{
				if ((i - tmpBeadPosition) * 50 > 100)
				{
					magicNumber0 *= 0.71;
				}
				if ((i + 1 - tmpBeadPosition) * 50 > 100)
				{
					magicNumber1 *= 0.71;
				}
			}

			if (tmpBeadIndex + i < 0)
			{
				// no more beads to pull out
				continue;
			}

			if (tmpBeadIndex + i > totalBeadCount)
			{
				// no more beads to push in
				continue;
			}

			var targetSprite:FlxSprite = _beads;

			if (i == 2 && _playerRestingHandOnSphincter)
			{
				// draw hand shoving against sphincter
				_interact.animation.frameIndex = 7;
				_beads.stamp(_interact, 0, 330);

				// don't mask the hand; just mask the line drawn over the hand, then stamp it on the hand...
				FlxSpriteUtil.fill(_tmpMask, FlxColor.TRANSPARENT);
				targetSprite = _tmpMask;
			}

			_beadBrush.animation.frameIndex = getBeadSize(tmpBeadIndex + i);

			if (i > 0 && i - 1 - tmpBeadPosition >= 1 + BEAD_BP_CENTER && beadCoords[i].y < beadCoords[i - 1].y)
			{
				// this bead is above the previous bead; should be drawn behind
				prepareBehindDraw(targetSprite);
			}
			if (tmpBeadIndex + i == totalBeadCount)
			{
				_handleBrush.animation.frameIndex = rhydonGrabbingLine() ? 1 : 0;
				targetSprite.stamp(_handleBrush, Std.int(beadCoords[i].x - 45), Std.int(beadCoords[i].y - 45));
				if (_playerInteractingWithHandle)
				{
					_interact.animation.frameIndex = 1;
					targetSprite.stamp(_interact, Std.int(beadCoords[i].x - _interact.width / 2), Std.int(beadCoords[i].y - _interact.height / 2));
				}
				else if (_playerHandNearHandle)
				{
					_interact.animation.frameIndex = 3;
					targetSprite.stamp(_interact, Std.int(beadCoords[i].x - _interact.width / 2), Std.int(beadCoords[i].y - _interact.height / 2));
				}

			}
			else
			{
				targetSprite.stamp(_beadBrush, Std.int(beadCoords[i].x - 45), Std.int(beadCoords[i].y - 45));
			}
			if (i > 0 && i - 1 - tmpBeadPosition >= 1 + BEAD_BP_CENTER && beadCoords[i].y < beadCoords[i - 1].y)
			{
				// this bead is above the previous bead; should be drawn behind
				applyBehindDraw(targetSprite);
			}

			if (i == 2 && _playerShovingInBead)
			{
				// draw hand shoving bead in...
				if (getBeadRadius(tmpBeadIndex + i) >= 33)
				{
					_interact.animation.frameIndex = 6;
				}
				else if (getBeadRadius(tmpBeadIndex + i) >= 28)
				{
					_interact.animation.frameIndex = 5;
				}
				else
				{
					_interact.animation.frameIndex = 4;
				}
				targetSprite.stamp(_interact, Std.int(beadCoords[i].x - _interact.width / 2), Std.int(beadCoords[i].y - _interact.height / 2));
			}

			if (i - tmpBeadPosition < 0.7 + BEAD_BP_CENTER)
			{
				applyObjectWithinInnerSphincterMask(targetSprite);
			}
			else if (i - tmpBeadPosition < 1 + BEAD_BP_CENTER)
			{
				applyObjectWithinSphincterMask(targetSprite);
			}

			if (tmpBeadIndex + i + 1 > totalBeadCount || i == beadCoords.length - 1)
			{
				// no line to next bead
			}
			else
			{
				var sourceX:Float = beadCoords[i].x + bv[i * 2 + 1].x * magicNumber0;
				var sourceY:Float = beadCoords[i].y + bv[i * 2 + 1].y * magicNumber0;

				var targetX:Float = beadCoords[i + 1].x - bv[i * 2 + 3].x * magicNumber1;
				var targetY:Float = beadCoords[i + 1].y - bv[i * 2 + 3].y * magicNumber1;

				var sphincterKludge:Bool = i - tmpBeadPosition < 1 + BEAD_BP_CENTER && i + 1 - tmpBeadPosition >= 1 + BEAD_BP_CENTER && _sphincter.animation.frameIndex <= 1;

				if (sphincterKludge)
				{
					// line starts inside sphincter, but ends outside sphincter, and it's closed-ish...
					sourceX = SPHINCTER_COORDS.x;
					sourceY = SPHINCTER_COORDS.y;
				}

				if (i - tmpBeadPosition >= 1 + BEAD_BP_CENTER && targetY < sourceY)
				{
					// this bead is above the previous bead...
					prepareBehindDraw(targetSprite);
				}

				drawBeadLine(targetSprite, sourceX, sourceY, targetX, targetY);

				if (sphincterKludge)
				{
					applyObjectExitingSphincterMask(targetSprite, sourceX, sourceY, targetX, targetY);
				}
				else if (i - tmpBeadPosition < 0.7 + BEAD_BP_CENTER)
				{
					// line starts behind inner sphincter...
					if (i + 1 - tmpBeadPosition < 0.7 + BEAD_BP_CENTER)
					{
						// line ends inside inner sphincter...
						applyObjectWithinInnerSphincterMask(targetSprite);
					}
					else if (i + 1 - tmpBeadPosition < 1 + BEAD_BP_CENTER)
					{
						// line ends inside outer sphincter...
						applyObjectExitingInnerSphincterMask(targetSprite, sourceX, sourceY, targetX, targetY);
						applyObjectWithinSphincterMask(targetSprite);
					}
					else
					{
						// line ends outside outer sphincter...
						applyObjectExitingInnerSphincterMask(targetSprite, sourceX, sourceY, targetX, targetY);
					}
				}
				else if (i - tmpBeadPosition < 1 + BEAD_BP_CENTER)
				{
					// line starts behind outer sphincter...
					if (i + 1 - tmpBeadPosition < 1 + BEAD_BP_CENTER)
					{
						// line ends behind outer sphincter...
						applyObjectWithinSphincterMask(targetSprite);
					}
					else
					{
						// line ends outside outer sphincter...
						applyObjectExitingSphincterMask(targetSprite, sourceX, sourceY, targetX, targetY);
					}
				}
				if (i - tmpBeadPosition >= 1 + BEAD_BP_CENTER && targetY < sourceY)
				{
					// this bead is above the previous bead...
					applyBehindDraw(targetSprite);
				}
			}

			if (targetSprite == _tmpMask)
			{
				// we've masked the line drawn over the hand; now, stamp it on the hand...
				_beads.stamp(_tmpMask);
			}

			if (i == 2 && _playerHandNearBead)
			{
				// draw hand shoving against sphincter
				_interact.animation.frameIndex = 3;
				_beads.stamp(_interact, Std.int(beadCoords[i].x - _interact.width / 2), Std.int(beadCoords[i].y - _interact.height / 2));
			}
		}
	}

	private function prepareBehindDraw(sprite:FlxSprite):Void
	{
		FlxSpriteUtil.fill(_tmpBehind, FlxColor.TRANSPARENT);
		_tmpBehind.stamp(sprite, 0, 0);
		FlxSpriteUtil.fill(sprite, FlxColor.TRANSPARENT);
	}

	private function applyBehindDraw(sprite:FlxSprite):Void
	{
		sprite.stamp(_tmpBehind);
	}

	private function rhydonGrabbingLine():Bool
	{
		return rhydonsTurn && (rhydonPauseTime <= 0 || rhydonBeadsToRemove <= 0);
	}

	private function drawBeadLine(targetSprite:FlxSprite, x0:Float, y0:Float, x1:Float, y1:Float)
	{
		if (FlxMath.vectorLength(x1 - x0, y1 - y0) < 1.0) {
			return;
		}

		var slope:FlxPoint = FlxPoint.get(x1 - x0, y1 - y0);
		slope.length = LINE_THICKNESS / 2;

		if (greyBeads)
		{
			FlxSpriteUtil.beginDraw(0xff4a4a4a, {color:0xff2c2c2c, thickness:3});
			FlxSpriteUtil.flashGfx.moveTo(x0 + slope.y, y0 - slope.x);
			FlxSpriteUtil.flashGfx.lineTo(x1 + slope.y, y1 - slope.x);

			FlxSpriteUtil.flashGfx.curveTo(x1 + slope.x + slope.y, y1 - slope.x + slope.y, x1 + slope.x, y1 + slope.y);
			FlxSpriteUtil.flashGfx.curveTo(x1 - slope.y + slope.x, y1 + slope.x + slope.y, x1 - slope.y, y1 + slope.x);

			FlxSpriteUtil.flashGfx.lineTo(x0 - slope.y, y0 + slope.x);

			FlxSpriteUtil.flashGfx.curveTo(x0 - slope.y - slope.x, y0 + slope.x - slope.y, x0 - slope.x, y0 - slope.y);
			FlxSpriteUtil.flashGfx.curveTo(x0 + slope.y - slope.x, y0 - slope.x - slope.y, x0 + slope.y, y0 - slope.x);

			FlxSpriteUtil.endDraw(targetSprite);

			FlxSpriteUtil.drawLine(targetSprite, x0, y0 - 3, x1, y1 - 3, {color:0xffcbcbcb, thickness:3});
		}
		else
		{
			FlxSpriteUtil.drawLine(targetSprite, x0, y0, x1, y1, {color:0x2effffff, thickness:LINE_THICKNESS});
			FlxSpriteUtil.drawCircle(targetSprite, x0, y0, LINE_THICKNESS / 2, FlxColor.TRANSPARENT, {color:0x99ffffff, thickness:3});
			FlxSpriteUtil.drawCircle(targetSprite, x1, y1, LINE_THICKNESS / 2, FlxColor.TRANSPARENT, {color:0x99ffffff, thickness:3});

			FlxSpriteUtil.drawLine(targetSprite, x0 + slope.y, y0 - slope.x, x1 + slope.y, y1 - slope.x, {color:0x99ffffff, thickness:3});
			FlxSpriteUtil.drawLine(targetSprite, x0 - slope.y, y0 + slope.x, x1 - slope.y, y1 + slope.x, {color:0x99ffffff, thickness:3});
		}
	}

	private function magicNumber(index:Int)
	{
		return getBeadRadius(index) * 0.4;
	}

	private function getBeadRadius(index:Int):Float
	{
		if (index < 0)
		{
			// no more beads to pull
			return 0;
		}
		if (index > totalBeadCount)
		{
			// no more beads to push
			return 0;
		}
		if (index == totalBeadCount)
		{
			// radius of the handle... please don't insert the handle
			return 28;
		}
		return beadRadii[getBeadSize(index)];
	}

	public function getBeadSize(index:Int)
	{
		if (index < 0)
		{
			// no more beads to pull
			return -1;
		}
		if (index > totalBeadCount)
		{
			// no more beads to push
			return -1;
		}
		return beadSizes[index % beadSizes.length];
	}

	public function tryPushingBeads(anchorBeadPosition:Float, desiredBeadPosition:Float, elapsed:Float)
	{
		var tmpBeadIndex:Int = getBeadPositionInt(); // next bead to push
		var beadRadius:Float = getBeadRadius(tmpBeadIndex);
		var resistAmount:Float = resistAmounts[getBeadSize(tmpBeadIndex)];
		var beadBpRadius:Float = beadRadius * BEAD_BP_RADIUS;

		var resistNudge:Bool = false;
		if (beadRadius == 0)
		{
			// no more beads?
		}
		else if (_beadPosition < tmpBeadIndex + BEAD_BP_CENTER && desiredBeadPosition > tmpBeadIndex + BEAD_BP_CENTER - beadBpRadius)
		{
			// trying to nudge beadPosition past a bead...

			if (desiredBeadPosition < tmpBeadIndex + BEAD_BP_CENTER + beadBpRadius / (1 - resistAmount))
			{
				// but didn't nudge it hard enough...

				// resist being nudged
				resistNudge = true;
				resistNudgeDuration += elapsed;
			}
			else
			{
				// nudge successful
				SoundStackingFix.play(FlxG.random.getObject([AssetPaths.bead_pop0_0087__mp3, AssetPaths.bead_pop1_0087__mp3, AssetPaths.bead_pop2_0087__mp3]));
				beadPushCallback(getBeadPositionInt(), resistNudgeDuration, beadRadius);
			}
		}
		if (resistNudge)
		{
			_beadPosition = tmpBeadIndex + Math.min(BEAD_BP_CENTER - 0.00001, (BEAD_BP_CENTER - beadBpRadius) * resistAmount + (desiredBeadPosition - tmpBeadIndex) * (1 - resistAmount));
			beadNudgeCallback(getBeadPositionInt(), resistNudgeDuration, beadRadius);
		}
		else
		{
			_beadPosition = desiredBeadPosition;
			resistNudgeDuration = 0;
		}
		_beadPosition = Math.min(_beadPosition, anchorBeadPosition + 1);
		_beadPosition = Math.min(_beadPosition, totalBeadCount);
	}

	public function tryPullingBeads(desiredBeadPosition:Float, elapsed:Float, ?futile:Bool = false):Bool
	{
		var tmpBeadIndex:Int = getBeadPositionInt() - 1; // next bead to pull out
		var beadRadius:Float = getBeadRadius(tmpBeadIndex);
		var resistAmount:Float = resistAmounts[getBeadSize(tmpBeadIndex)];
		var beadBpRadius:Float = beadRadius * BEAD_BP_RADIUS;

		if (desiredBeadPosition > _beadPosition)
		{
			// can't "push beads"...
			var newBeadPosition:Float = desiredBeadPosition;
			if (_beadPosition <= tmpBeadIndex + 1 - BEAD_BP_CENTER)
			{
				// we've pulled out a bead; can't un-pull it out
				newBeadPosition = _beadPosition;
			}
			else if (newBeadPosition > tmpBeadIndex + 1)
			{
				// we haven't started pulling this bead out; can't go back a bead
				newBeadPosition = tmpBeadIndex + 1;
			}

			slack = FlxMath.bound(desiredBeadPosition - newBeadPosition, 0, MAX_SLACK);
			_beadPosition = newBeadPosition;
			return false;
		}

		var resistNudge:Bool = false;
		var pulledBead:Bool = false;
		if (beadRadius == 0)
		{
			// no more beads?
		}
		else if (_beadPosition > tmpBeadIndex + BEAD_BP_CENTER && desiredBeadPosition < tmpBeadIndex + BEAD_BP_CENTER + beadBpRadius)
		{
			// trying to nudge beadPosition past a bead...

			if (futile)
			{
				// we won't let them...
				resistNudge = true;
				resistNudgeDuration += elapsed;
			}
			else if (desiredBeadPosition > tmpBeadIndex + BEAD_BP_CENTER - beadBpRadius / (1 - resistAmount))
			{
				// but didn't nudge it hard enough...

				// resist being nudged
				resistNudge = true;
				resistNudgeDuration += elapsed;
			}
			else
			{
				pulledBead = true;
				SoundStackingFix.play(FlxG.random.getObject([AssetPaths.bead_pop0_0087__mp3, AssetPaths.bead_pop1_0087__mp3, AssetPaths.bead_pop2_0087__mp3]));
				beadPullCallback(getBeadPositionInt() - 1, resistNudgeDuration, beadRadius);
				desiredBeadPosition = tmpBeadIndex + BEAD_BP_CENTER - 0.00001;
				resistNudgeDuration = 0;
			}
		}
		if (resistNudge)
		{
			if (futile)
			{
				// "pullEffort" is limitless; 0.00 = bead hasn't pierced the sphincter; 3.00 = player has pulled pretty hard
				var pullEffort:Float = Math.max(0, ((tmpBeadIndex + BEAD_BP_CENTER + beadBpRadius) - desiredBeadPosition) / beadBpRadius);

				// "pct" ranges from [0.00 - 1.00]; 0.00 = hasn't started pulling; 1.00 = pulling really hard
				var pct:Float = pullEffort / (pullEffort + 4);

				_beadPosition = tmpBeadIndex + BEAD_BP_CENTER + 0.00001 + beadBpRadius - beadBpRadius * pct;
				beadNudgeCallback(getBeadPositionInt() - 1, resistNudgeDuration, beadRadius);
			}
			else
			{
				_beadPosition = tmpBeadIndex + Math.max(BEAD_BP_CENTER + 0.00001, (BEAD_BP_CENTER + beadBpRadius) * resistAmount + (desiredBeadPosition - tmpBeadIndex) * (1 - resistAmount));
				beadNudgeCallback(getBeadPositionInt() - 1, resistNudgeDuration, beadRadius);
			}
		}
		else {
			_beadPosition = desiredBeadPosition;
			resistNudgeDuration = 0;
		}
		slack = 0;
		return pulledBead;
	}

	/**
	 * Masks an object which is contained entirely within the sphincter, like a
	 * bead which is inside
	 */
	private function applyObjectWithinSphincterMask(targetSprite:FlxSprite)
	{
		_sphincterMask.animation.frameIndex = _sphincter.animation.frameIndex;
		targetSprite.stamp(_sphincterMask, 0, 330);
		targetSprite.graphic.bitmap.threshold(targetSprite.graphic.bitmap, new Rectangle(0, 0, targetSprite.width, targetSprite.height), new Point(0, 0), "==", 0xffff00ff, 0x00000000);
		targetSprite.dirty = true;
	}

	/**
	 * Masks an object which is contained entirely within Rhydon's "inner
	 * sphincter" -- the pink fleshy walls of Rhydon's intestine which occlude
	 * objects.
	 */
	private function applyObjectWithinInnerSphincterMask(targetSprite:FlxSprite)
	{
		_innerSphincterMask.animation.frameIndex = _sphincter.animation.frameIndex;
		targetSprite.stamp(_innerSphincterMask, 0, 330);
		targetSprite.graphic.bitmap.threshold(targetSprite.graphic.bitmap, new Rectangle(0, 0, targetSprite.width, targetSprite.height), new Point(0, 0), "==", 0xffff00ff, 0x00000000);
		targetSprite.dirty = true;
	}

	/**
	 * Masks an object which is contained partially within the sphincter, like
	 * a string which connects an inside bead to an outside bead
	 *
	 * @param	targetSprite sprite to draw onto
	 * @param	x0 x coordinate of the object within the sphincter
	 * @param	y0 y coordinate of the object within the sphincter
	 * @param	x1 x coordinate of the object outside the sphincter
	 * @param	y1 y coordinate of the object outside the sphincter
	 */
	private function applyObjectExitingSphincterMask(targetSprite:FlxSprite, x0:Float, y0:Float, x1:Float, y1:Float)
	{
		var angle:Float = Math.atan2(y1 - y0, x1 - x0);

		if (angle < -0.833 * Math.PI)
		{
			// west mask
			_sphincterMask.animation.frameIndex = _sphincter.animation.frameIndex + 24;
		}
		else if (angle < 0)
		{
			// upward mask
			_sphincterMask.animation.frameIndex = _sphincter.animation.frameIndex + 16;
		}
		else if (angle < 0.833 * Math.PI)
		{
			// downward mask
			_sphincterMask.animation.frameIndex = _sphincter.animation.frameIndex + 8;
		}
		else
		{
			// west mask
			_sphincterMask.animation.frameIndex = _sphincter.animation.frameIndex + 24;
		}

		targetSprite.stamp(_sphincterMask, 0, 330);
		targetSprite.graphic.bitmap.threshold(targetSprite.graphic.bitmap, new Rectangle(0, 0, targetSprite.width, targetSprite.height), new Point(0, 0), "==", 0xffff00ff, 0x00000000);
		targetSprite.dirty = true;
	}

	/**
	 * Masks an object which is contained partially within Rhydon's "inner
	 * sphincter" -- the pink fleshy walls of Rhydon's intestine which occlude
	 * objects. For example, a rope connecting a bead really far inside Rhydon
	 * to a bead that's only slightly inside Rhydon.
	 *
	 * @param	targetSprite sprite to draw onto
	 * @param	x0 x coordinate of the object within the sphincter
	 * @param	y0 y coordinate of the object within the sphincter
	 * @param	x1 x coordinate of the object outside the sphincter
	 * @param	y1 y coordinate of the object outside the sphincter
	 */
	private function applyObjectExitingInnerSphincterMask(targetSprite:FlxSprite, x0:Float, y0:Float, x1:Float, y1:Float)
	{
		var angle:Float = Math.atan2(y1 - y0, x1 - x0);

		if (angle < -0.833 * Math.PI)
		{
			// west mask
			_innerSphincterMask.animation.frameIndex = _sphincter.animation.frameIndex + 24;
		}
		else if (angle < 0)
		{
			// upward mask
			_innerSphincterMask.animation.frameIndex = _sphincter.animation.frameIndex + 16;
		}
		else if (angle < 0.833 * Math.PI)
		{
			// downward mask
			_innerSphincterMask.animation.frameIndex = _sphincter.animation.frameIndex + 8;
		}
		else
		{
			// west mask
			_innerSphincterMask.animation.frameIndex = _sphincter.animation.frameIndex + 24;
		}

		targetSprite.stamp(_innerSphincterMask, 0, 330);
		targetSprite.graphic.bitmap.threshold(targetSprite.graphic.bitmap, new Rectangle(0, 0, targetSprite.width, targetSprite.height), new Point(0, 0), "==", 0xffff00ff, 0x00000000);
		targetSprite.dirty = true;
	}

	override public function draw():Void
	{
		FlxSpriteUtil.fill(_canvas, FlxColor.WHITE);
		for (member in members)
		{
			if (member != null && member.visible)
			{
				_canvas.stamp(member, Std.int(member.x - member.offset.x - x), Std.int(member.y - member.offset.y - y));
			}
		}
		{
			// erase corner
			var poly:Array<FlxPoint> = [];
			poly.push(FlxPoint.get(_canvas.width - CORNER_SIZE, 0));
			poly.push(FlxPoint.get(_canvas.width, CORNER_SIZE));
			poly.push(FlxPoint.get(_canvas.width, 0));
			poly.push(FlxPoint.get(_canvas.width - CORNER_SIZE, 0));
			FlxSpriteUtil.drawPolygon(_canvas, poly, 0xFF80684E, null, {blendMode:BlendMode.ERASE});
			FlxDestroyUtil.putArray(poly);
		}

		#if !flash
		// BlendMode.ERASE is not supported by non-flash targets, so we manually erase the pixels
		// with a threshold() call
		_canvas.pixels.threshold(_canvas.pixels, _canvas.pixels.rect, new Point(0, 0), "==", 0xFF80684E);
		#end

		{
			// draw pentagon around character frame
			var poly:Array<FlxPoint> = [];
			poly.push(FlxPoint.get(1, 1));
			poly.push(FlxPoint.get(_canvas.width - CORNER_SIZE + 1, 1));
			poly.push(FlxPoint.get(_canvas.width - 1, CORNER_SIZE - 1));
			poly.push(FlxPoint.get(_canvas.width - 1, _canvas.height - 1));
			poly.push(FlxPoint.get(1, _canvas.height - 1));
			poly.push(FlxPoint.get(1, 1));
			FlxSpriteUtil.drawPolygon(_canvas, poly, FlxColor.TRANSPARENT, { thickness: 2 });
			FlxDestroyUtil.putArray(poly);

			// corner looks skimpy when drawing "pixel style" so fatten it up
			FlxSpriteUtil.drawLine(_canvas, _canvas.width - CORNER_SIZE, 0, _canvas.width, CORNER_SIZE, {thickness:3, color:FlxColor.BLACK});
		}

		_canvas.pixels.setPixel32(0, 0, 0x00000000);
		_canvas.pixels.setPixel32(0, Std.int(_canvas.height-1), 0x00000000);
		_canvas.pixels.setPixel32(Std.int(_canvas.width-1), Std.int(_canvas.height-1), 0x00000000);
		_canvas.draw();
	}

	public function rhydonDonePullingBeads()
	{
		if (rhydonBeadsToRemove > 0)
		{
			return false;
		}
		if (rhydonPauseTime > 0)
		{
			return false;
		}
		return true;
	}

	public function setGreyBeads()
	{
		greyBeads = true;
		_beadBrush.loadGraphic(AssetPaths.anal_bead_xl_grey__png, true, 90, 90);
		_beadBrush.alpha = 1.0;
		_handleBrush.loadGraphic(AssetPaths.anal_bead_xl_grey_handle__png, true, 90, 90);
		_handleBrush.alpha = 1.0;
		beadSizes = [5, 3, 2, 1, 1, 0, 4, 2, 1, 1, 0, 0, 0, 3, 2, 1, 1, 0, 0, 0, 0];
		beadRadii = [22, 24, 27, 34, 38, 42];
	}

	override public function setArousal(Arousal:Int)
	{
		super.setArousal(Arousal);
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		CursorUtils.initializeCustomHandBouncySprite(_interact, AssetPaths.rhydbeads_interact__png, 356, 330);
		_interact.alpha = PlayerData.cursorMinAlpha;
		_interact.animation.add("default", [0]);
		_interact.animation.add("pull-bead", [1]);
	}

	override public function destroy():Void
	{
		super.destroy();

		_cameraTween = FlxTweenUtil.destroy(_cameraTween);
		_headDown = FlxDestroyUtil.destroy(_headDown);
		_leftArm0 = FlxDestroyUtil.destroy(_leftArm0);
		_rightArmDown = FlxDestroyUtil.destroy(_rightArmDown);
		_headUp = FlxDestroyUtil.destroy(_headUp);
		_leftArm1 = FlxDestroyUtil.destroy(_leftArm1);
		_rightArmUp = FlxDestroyUtil.destroy(_rightArmUp);
		_torsoUp = FlxDestroyUtil.destroy(_torsoUp);
		_body = FlxDestroyUtil.destroy(_body);
		_sphincter = FlxDestroyUtil.destroy(_sphincter);
		_sphincterMask = FlxDestroyUtil.destroy(_sphincterMask);
		_innerSphincterMask = FlxDestroyUtil.destroy(_innerSphincterMask);
		_ass = FlxDestroyUtil.destroy(_ass);
		_beads = FlxDestroyUtil.destroy(_beads);
		_tmpMask = FlxDestroyUtil.destroy(_tmpMask);
		_tmpBehind = FlxDestroyUtil.destroy(_tmpBehind);
		_beadBrush = FlxDestroyUtil.destroy(_beadBrush);
		_handleBrush = FlxDestroyUtil.destroy(_handleBrush);
		beadRadii = null;
		resistAmounts = null;
		beadSizes = null;
		beadPullCallback = null;
		beadNudgeCallback = null;
		beadPushCallback = null;
		bv = FlxDestroyUtil.putArray(bv);
	}
}