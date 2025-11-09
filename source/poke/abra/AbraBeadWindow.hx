package poke.abra;
import flash.geom.Point;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.FlxAccelerometer;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import openfl.geom.Rectangle;
import poke.sexy.FancyAnim;

/**
 * Graphics for Abra during the anal bead sequence
 */
class AbraBeadWindow extends PokeWindow
{
	public static var MAX_SLACK:Float = 0.9;
	public static var BEAD_BP_CENTER:Float = 0.42;
	public static var BEAD_BP_RADIUS:Float = 0.012;
	private var lineColor:FlxColor = 0xff5a3685;

	private var _arms0:BouncySprite;
	private var _legs0:BouncySprite;
	public var _body:BouncySprite;
	public var _ass:BouncySprite;
	private var _assMask:BouncySprite;
	private var _arms1:BouncySprite;
	private var _arms2:BouncySprite;
	public var _arms3:BouncySprite;
	public var _fingers:BouncySprite;
	private var _legs1:BouncySprite;
	private var _legs2:BouncySprite;
	private var _beads:BouncySprite;
	private var _beadBrush:FlxSprite;

	public var beadPosition:Float = 1000;
	public var visualBeadPosition:Float = 1000; // actual bead position being displayed; for tweening purposes
	public var beadSizes:Array<Int> = [];
	public var slack:Float = MAX_SLACK;
	private var visualSlack:Float = MAX_SLACK; // actual slack being displayed; for tweening purposes
	public var lineAngle:Float = 0; // number ranging from [-1.0, 1.0] for left/right
	private var visualLineAngle:Float = 0; // actual line angle being displayed; for tweening purposes

	public var abraBeadsToRemove:Int = 0;
	public var abraBeadCount:Int = 0;
	public var abraDesiredBeadPosition:Float = 1000;
	public var abraPauseTime:Float = 0;
	public var abraTransitionTime:Float = 0;

	public var abrasTurn:Bool = false;

	public var beadPushAnim:FancyAnim;
	public var pushingBeads:Bool = false;
	public var totalInsertedBeads = 0;

	public var beadPullCallback:Int->Float->Float->Void;
	public var beadNudgeCallback:Int->Float->Float->Void;
	public var beadPushCallback:Int->Float->Float->Void;
	private var resistNudgeDuration:Float = 0;

	private var greyBeads:Bool = false;
	private var beadRadii:Array<Float> = [8, 9, 10, 12, 14, 16];
	private var resistAmounts:Array<Float> = [0.44, 0.5, 0.55, 0.62, 0.70, 0.78];
	private var beadStringThickness:Float = 5;

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
		add(new FlxSprite( -54, -54, AssetPaths.abra_bg__png));

		_arms0 = new BouncySprite( -54, -54, 2, 7, 0.2, _age);
		_arms0.loadWindowGraphic(AssetPaths.abrabeads_arms0__png);
		addPart(_arms0);

		_legs0 = new BouncySprite( -54, -54, 0, 7, 0, _age);
		_legs0.loadWindowGraphic(AssetPaths.abrabeads_legs0__png);
		addPart(_legs0);

		_body = new BouncySprite( -54, -54, 0, 7, 0, _age);
		_body.loadWindowGraphic(AssetPaths.abrabeads_body__png);
		addPart(_body);

		_head = new BouncySprite( -54, -54, 4, 7, 0, _age);
		_head.loadGraphic(AbraResource.beadsHead, true, 356, 266);
		_head.animation.add("default", blinkyAnimation([0, 1]), 3);
		_head.animation.add("0", blinkyAnimation([0, 1]), 3);
		_head.animation.add("1", blinkyAnimation([2, 3]), 3);
		_head.animation.add("2", blinkyAnimation([4, 5]), 3);
		_head.animation.add("3", blinkyAnimation([6, 7]), 3);
		_head.animation.add("4", blinkyAnimation([8, 9]), 3);
		_head.animation.add("5", blinkyAnimation([10, 11]), 3);
		_head.animation.add("sick0", blinkyAnimation([12, 13]), 3);
		_head.animation.add("sick1", blinkyAnimation([18, 19], [20]), 3);
		_head.animation.add("sick2", blinkyAnimation([21, 22], [23]), 3);
		addPart(_head);

		_ass = new BouncySprite( -54, -54, 0, 7, 0, _age);
		_ass.loadWindowGraphic(AssetPaths.abrabeads_ass__png);
		addPart(_ass);

		_assMask = new BouncySprite( -54, -54, 0, 7, 0, _age);
		_assMask.loadWindowGraphic(AssetPaths.abrabeads_ass_mask__png);

		_arms1 = new BouncySprite( -54, -54, 2, 7, 0.2, _age);
		_arms1.loadWindowGraphic(AssetPaths.abrabeads_arms1__png);
		addPart(_arms1);

		_arms2 = new BouncySprite( -54, -54, 2, 7, 0.1, _age);
		_arms2.loadWindowGraphic(AssetPaths.abrabeads_arms2__png);
		addPart(_arms2);

		_dick = new BouncySprite( -54, -54, 0, 7, 0, _age);
		_dick.loadWindowGraphic(AbraResource.beadsDick);
		addPart(_dick);

		_arms3 = new BouncySprite( -54, -54, 2, 7, 0.1, _age);
		_arms3.loadWindowGraphic(AssetPaths.abrabeads_arms3__png);

		_fingers = new BouncySprite( -54, -54, 2, 7, 0.1, _age);
		_fingers.loadWindowGraphic(AssetPaths.abrabeads_fingers__png);

		_legs1 = new BouncySprite( -54, -54, 0, 7, 0, _age);
		_legs1.loadWindowGraphic(AssetPaths.abrabeads_legs1__png);
		addPart(_legs1);

		_legs2 = new BouncySprite( -54, -54, 0, 7, 0, _age);
		_legs2.loadWindowGraphic(AssetPaths.abrabeads_legs2__png);
		addPart(_legs2);

		_beads = new BouncySprite( -54, -54, 0, 7, 0, _age);
		_beads.makeGraphic(356, 532, FlxColor.TRANSPARENT, true);
		addVisualItem(_beads);

		_beadBrush = new FlxSprite(0, 0);
		_beadBrush.loadGraphic(AssetPaths.anal_bead_purple__png, true, 48, 48);

		_interact = new BouncySprite( -54, -54, _body._bounceAmount, _body._bounceDuration, _body._bouncePhase, _age);
		reinitializeHandSprites();

		var beadBag:Array<Int> = [];
		for (i in 0...100)
		{
			if (beadBag.length == 0)
			{
				beadBag = beadBag.concat([0, 1, 2, 2, 3, 3, 4, 4, 5, 5]);
				FlxG.random.shuffle(beadBag);
			}
			beadSizes.push(beadBag.pop());
		}
	}

	/**
	 * Swaps the translucent purple beads out for the grey beads
	 */
	public function setGreyBeads():Void
	{
		greyBeads = true;
		beadSizes.splice(0, beadSizes.length);
		for (i in 0...100)
		{
			beadSizes.push(Std.int(FlxMath.bound(Math.pow(i + 1, 0.55) - 1, 0, 5)));
		}
		_beadBrush.loadGraphic(AssetPaths.anal_bead_grey__png, true, 48, 48);
		beadRadii = [10, 11, 12, 13, 13, 14];
		resistAmounts = [0.55, 0.58, 0.61, 0.64, 0.67, 0.70];
		beadStringThickness = 9;
		lineColor = 0xff2c2c2c;
	}

	public function isGreyBeads():Bool
	{
		return greyBeads;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (abrasTurn)
		{
			if (abraTransitionTime >= 0)
			{
				abraTransitionTime -= elapsed;
				_arms3.animation.frameIndex = 0;
			}
			else if (abraPauseTime <= 0)
			{
				var beadRadius:Float = getBeadRadius(Std.int(beadPosition));
				var beadBpRadius:Float = beadRadius * BEAD_BP_RADIUS;

				var abraPullSpeed:Float = 0;
				if (beadPosition > Std.int(beadPosition) + BEAD_BP_CENTER - beadBpRadius)
				{
					// take it slow
					abraPullSpeed = [1.30, 1.17, 0.98, 0.78, 0.65, 0.46][getBeadSize(Std.int(beadPosition))];
				}
				else
				{
					abraPullSpeed = 1.30;
				}

				abraDesiredBeadPosition += elapsed * abraPullSpeed;
				if (beadPosition % 1 < 0.15)
				{
					_arms3.animation.frameIndex = 1;
				}
				else if (beadPosition % 1 < 0.3)
				{
					_arms3.animation.frameIndex = 2;
				}
				else
				{
					_arms3.animation.frameIndex = 3;
				}
				tryPullingBeads(elapsed, abraDesiredBeadPosition);
				if (abraBeadCount + BEAD_BP_CENTER < beadPosition)
				{
					// just pulled one out
					abraPauseTime = 0.55;
					abraBeadCount++;
					abraBeadsToRemove--;
					if (abraBeadsToRemove <= 0)
					{
						abraPauseTime += 0.5;
					}
				}
			}
			else
			{
				if (abraDesiredBeadPosition != abraBeadCount)
				{
					if (abraDesiredBeadPosition < abraBeadCount)
					{
						abraDesiredBeadPosition = Math.min(abraBeadCount, abraDesiredBeadPosition + 6 * elapsed);
					}
					else
					{
						abraDesiredBeadPosition = Math.max(abraBeadCount, abraDesiredBeadPosition - 6 * elapsed);
					}
				}
				tryPullingBeads(elapsed, abraDesiredBeadPosition);
				abraPauseTime -= elapsed;
				if (abraBeadsToRemove <= 0)
				{
					if (abraPauseTime <= 0)
					{
						abrasTurn = false;
					}
				}
				else if (abraPauseTime <= 0.15)
				{
					_arms3.animation.frameIndex = 0;
				}
				else if (abraPauseTime < 0.3)
				{
					_arms3.animation.frameIndex = 1;
				}
				else if (abraPauseTime < 0.45)
				{
					_arms3.animation.frameIndex = 2;
				}
			}

			_fingers.animation.frameIndex = _arms3.animation.frameIndex;
		}

		if (displayingAbraBeadHand())
		{
			_arms2.animation.frameIndex = 1;
		}
		else {
			_arms2.animation.frameIndex = 0;
		}

		if (beadPushAnim != null)
		{
			var beadCount:Int = getCurrentInsertedBeadCount();
			var tmpBeadPosition:Float = beadPosition - 0.0001;
			var speed:Float = 0;
			var tmpBeadCountRatio:Float = beadCount / PlayerData.abraBeadCapacity;
			if (getBeadRadius(Std.int(tmpBeadPosition)) >= 15)
			{
				speed += 0.6;
			}
			while (tmpBeadCountRatio > 0.7 && speed < 3.8)
			{
				tmpBeadCountRatio -= (1 - tmpBeadCountRatio) * 0.08;
				speed += 0.1;
			}
			if (speed > 0)
			{
				beadPushAnim.setMaxQueuedClicks(2);
			}
			else if (speed > 0.6)
			{
				beadPushAnim.setMaxQueuedClicks(1);
			}

			beadPushAnim.setSpeedLimit(speed, 0.0);
			beadPushAnim.update(elapsed);
			if (beadPushAnim.isMovingForward() || beadCount > PlayerData.abraBeadCapacity)
			{
				var fraction:Float = (beadPushAnim.getUnroundedCurFrame() + 0.5) % 1;
				if (_interact.animation.frameIndex == 2)
				{
					beadPosition = Std.int(tmpBeadPosition) + 0.72 - fraction * 0.1;
				}
				else if (_interact.animation.frameIndex == 3)
				{
					beadPosition = Std.int(tmpBeadPosition) + 0.62 - fraction * 0.1;
				}
				else if (_interact.animation.frameIndex == 4)
				{
					beadPosition = Std.int(tmpBeadPosition) + 0.52 - fraction * 0.1;
				}
			}
			if (beadCount > PlayerData.abraBeadCapacity)
			{
				// can't advance any further
			}
			else if ((_interact.animation.frameIndex == 5 || !beadPushAnim.isMovingForward()) && beadPosition > Std.int(beadPosition))
			{
				beadPushCallback(totalInsertedBeads, Math.max(beadPushAnim._prevMouseDownTime, speed), getBeadRadius(Std.int(tmpBeadPosition)));
				beadPosition = Std.int(beadPosition);
				totalInsertedBeads++;
				SoundStackingFix.play(FlxG.random.getObject([AssetPaths.bead_pop0_0087__mp3, AssetPaths.bead_pop1_0087__mp3, AssetPaths.bead_pop2_0087__mp3]));
			}
		}

		if (visualBeadPosition != beadPosition)
		{
			var beadVelocity:Float = Math.abs(visualBeadPosition - beadPosition) > 0.2 ? 12 : 6;
			if (visualBeadPosition < beadPosition)
			{
				visualBeadPosition = Math.min(beadPosition, visualBeadPosition + beadVelocity * elapsed);
			}
			else
			{
				visualBeadPosition = Math.max(beadPosition, visualBeadPosition - beadVelocity * elapsed);
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

		var tmpBeadPosition:Float = visualBeadPosition % 1;
		var tmpBeadIndex:Int = Std.int(visualBeadPosition);

		FlxSpriteUtil.fill(_beads, FlxColor.TRANSPARENT);

		var beadCoords:Array<FlxPoint> = [];
		var path:SegmentedPath = new SegmentedPath();

		if (displayingAbraBeadHand())
		{
			path.pushNode(160, 332);
			path.pushNode(143, 345);
			path.pushNode(105 + 3 * _arms3.animation.frameIndex, 263 - 9 * _arms3.animation.frameIndex);
			path.pushNode(77, 264 - 9 * _arms3.animation.frameIndex);
			path.pushNode(57, 299 - 9 * _arms3.animation.frameIndex);
			path.pushNode(57, 903);
		}
		else {
			path.pushNode(160, 332);
			path.pushNode(143, 345);

			var beadVector:FlxPoint = FlxPoint.get( -300, 420);
			beadVector.rotateByRadians(-Math.PI * 0.06 * visualLineAngle);
			beadVector.y *= 0.6;

			path.pushNode(path.nodes[path.nodes.length - 1].x + beadVector.x, path.nodes[path.nodes.length - 1].y + beadVector.y);

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

			if (visualSlack > 0)
			{
				for (i in 2...path.nodes.length)
				{
					path.nodes[i].y += visualSlack * 2 * Math.pow(150 - path.nodes[i].x, 0.6);
					path.nodes[i].x += visualSlack * 0.7 * Math.pow(150 - path.nodes[i].x, 0.6);
				}
			}
		}

		for (i in 0...(displayingAbraBeadHand() ? 12 : 6))
		{
			beadCoords.push(path.getPathPoint((i + tmpBeadPosition) * 39));
		}

		var beadRadius:Float = getBeadRadius(tmpBeadIndex);

		var beadBpRadius:Float = beadRadius * BEAD_BP_RADIUS;
		/*
		 * A perfect ellipse would be "2", but we set this to "1.6" for a slightly pointy ellipse...
		 * This way the sphincter stays slightly narrower than it should, except at max radius
		 */
		var ellipseFudgeFactor:Float = 1.6;
		var sphincterRadius:Float = beadRadius * Math.pow(Math.max(0, 1 - Math.pow(Math.abs(tmpBeadPosition - BEAD_BP_CENTER), ellipseFudgeFactor) / Math.pow(beadBpRadius, ellipseFudgeFactor)), 0.5);

		if (sphincterRadius >= 15)
		{
			_ass.animation.frameIndex = 5;
		}
		else if (sphincterRadius >= 12.5)
		{
			_ass.animation.frameIndex = 4;
		}
		else if (sphincterRadius >= 10)
		{
			_ass.animation.frameIndex = 3;
		}
		else if (sphincterRadius >= 7.5)
		{
			_ass.animation.frameIndex = 2;
		}
		else if (sphincterRadius >= 5)
		{
			_ass.animation.frameIndex = 1;
		}
		else {
			_ass.animation.frameIndex = 0;
		}

		while (bv.length < beadCoords.length * 2 + 1)
		{
			bv.push(FlxPoint.get());
		}

		bv[0].set(beadCoords[0].x - 175, beadCoords[0].y - 319);
		bv[0].normalize();
		for (i in 1...beadCoords.length)
		{
			bv[i * 2].set(beadCoords[i].x - beadCoords[i - 1].x, beadCoords[i].y - beadCoords[i - 1].y).normalize();
			bv[i * 2 - 1].set(bv[i * 2 - 2].x + bv[i * 2].x, bv[i * 2 - 2].y + bv[i * 2].y).normalize();
		}

		if (displayingAbraBeadHand())
		{
			if (tmpBeadPosition < BEAD_BP_CENTER)
			{
				bv[1] = FlxPoint.get( -0.812, 0.583).rotateByDegrees([0, 10, 30, 50, 70, 90][_ass.animation.frameIndex]);
			}
			else
			{
				bv[1] = FlxPoint.get(-0.519, -0.857);
			}
			bv[3].pivotDegrees(FlxPoint.weak(0, 0), 10);
		}

		if (_ass.animation.frameIndex == 0 && tmpBeadPosition < BEAD_BP_CENTER)
		{
			// don't draw line to first bead
		}
		else if (visualBeadPosition >= 999 + BEAD_BP_CENTER)
		{
			// no more beads; don't draw line
		}
		else {
			var magicNumber:Float = magicNumber(tmpBeadIndex);
			if (_ass.animation.frameIndex == 0)
			{
				// line from sphincter to first bead...
				drawBeadLine(145, 343, beadCoords[0].x - bv[1].x * magicNumber, beadCoords[0].y - bv[1].y * magicNumber);
			}
			else {
				// line from guts to first bead...
				drawBeadLine(175, 319, beadCoords[0].x - bv[1].x * magicNumber, beadCoords[0].y - bv[1].y * magicNumber);
			}
		}

		for (i in 0...beadCoords.length - 1)
		{
			var beadSize:Int = getBeadSize(tmpBeadIndex - i);
			var magicNumber0:Float = magicNumber(tmpBeadIndex - i);
			var magicNumber1:Float = magicNumber(tmpBeadIndex - i - 1);
			if (i == 0 && _ass.animation.frameIndex == 0 && tmpBeadPosition < BEAD_BP_CENTER)
			{
				// don't draw very much...

				// line from sphincter to second bead...
				if (tmpBeadIndex >= 1000)
				{
					// final bead; don't draw line
				}
				else
				{
					drawBeadLine(145, 343, beadCoords[i + 1].x - bv[i * 2 + 3].x * magicNumber1, beadCoords[i + 1].y - bv[i * 2 + 3].y * magicNumber1);
					applyObjectExitingSphincterMask(145, 343, beadCoords[i + 1].x - bv[i * 2 + 3].x * magicNumber1, beadCoords[i + 1].y - bv[i * 2 + 3].y * magicNumber1);
				}
			}
			else
			{
				// line within bead...
				drawBeadLine(beadCoords[i].x - bv[i * 2 + 1].x * magicNumber0, beadCoords[i].y - bv[i * 2 + 1].y * magicNumber0, beadCoords[i].x + bv[i * 2 + 1].x * magicNumber0, beadCoords[i].y + bv[i * 2 + 1].y * magicNumber0);

				if (tmpBeadIndex - i >= 1000)
				{
					// no more beads
				}
				else
				{
					_beadBrush.animation.frameIndex = beadSize;
					if (i == 0)
					{
						if (tmpBeadPosition < BEAD_BP_CENTER)
						{
							_beads.stamp(_beadBrush, Std.int(beadCoords[i].x - 24), Std.int(beadCoords[i].y - 24));
							applyObjectWithinSphincterMask();
						}
						else
						{
							applyObjectExitingSphincterMask(175, 319, beadCoords[i + 1].x - bv[i * 2 + 3].x * magicNumber1, beadCoords[i + 1].y - bv[i * 2 + 3].y * magicNumber1);
							_beads.stamp(_beadBrush, Std.int(beadCoords[i].x - 24), Std.int(beadCoords[i].y - 24));
						}
					}
					else
					{
						_beads.stamp(_beadBrush, Std.int(beadCoords[i].x - 24), Std.int(beadCoords[i].y - 24));
					}

					// line from to next bead...
					drawBeadLine(beadCoords[i].x + bv[i * 2 + 1].x * magicNumber0, beadCoords[i].y + bv[i * 2 + 1].y * magicNumber0, beadCoords[i + 1].x - bv[i * 2 + 3].x * magicNumber1, beadCoords[i + 1].y - bv[i * 2 + 3].y * magicNumber1);
				}
			}

			if (i == 0 && displayingAbraBeadHand())
			{
				_beads.stamp(_arms3, Std.int(_arms2.x - _beads.x - _arms2.offset.x), Std.int(_arms2.y - _beads.y - _arms2.offset.y));
			}
		}
		if (displayingAbraBeadHand())
		{
			_beads.stamp(_fingers, Std.int(_arms2.x - _beads.x - _arms2.offset.x), Std.int(_arms2.y - _beads.y - _arms2.offset.y));
		}
		_beads.stamp(_beadBrush, Std.int(beadCoords[beadCoords.length - 1].x - 24), Std.int(beadCoords[beadCoords.length - 1].y - 24));

		if (pushingBeads)
		{
			_beads.stamp(_interact, 0, 0);
		}
	}

	private function displayingAbraBeadHand():Bool
	{
		return abrasTurn && abraTransitionTime < 0.5;
	}

	/**
	 * This method tries pushing/pulling the beads according to the player's
	 * mouse, restricting the results if their desired position is impossible
	 *
	 * @param	elapsed number of milliseconds currently elapsing
	 * @param	desiredBeadPosition position the player is trying to push/pull to
	 */
	public function tryPullingBeads(elapsed:Float, desiredBeadPosition:Float)
	{
		var tmpBeadIndex:Int = Std.int(beadPosition);
		var beadRadius:Float = getBeadRadius(tmpBeadIndex);
		var resistAmount:Float = resistAmounts[getBeadSize(tmpBeadIndex)];
		var beadBpRadius:Float = beadRadius * BEAD_BP_RADIUS;

		if (desiredBeadPosition < beadPosition)
		{
			// can't "push beads"...
			var newBeadPosition:Float = desiredBeadPosition;
			if (beadPosition >= tmpBeadIndex + BEAD_BP_CENTER)
			{
				// we've pulled out a bead; can't un-pull it out
				newBeadPosition = beadPosition;
			}
			else if (newBeadPosition < tmpBeadIndex)
			{
				// we haven't started pulling this bead out; can't go back a bead
				newBeadPosition = tmpBeadIndex;
			}

			slack = FlxMath.bound(newBeadPosition - desiredBeadPosition, 0, MAX_SLACK);
			beadPosition = newBeadPosition;
			return;
		}

		var resistNudge:Bool = false;
		if (beadRadius == 0)
		{
			// no more beads?
		}
		else if (beadPosition < tmpBeadIndex + BEAD_BP_CENTER && desiredBeadPosition > tmpBeadIndex + BEAD_BP_CENTER - beadBpRadius)
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
				SoundStackingFix.play(FlxG.random.getObject([AssetPaths.bead_pop0_0087__mp3, AssetPaths.bead_pop1_0087__mp3, AssetPaths.bead_pop2_0087__mp3]));
				beadPullCallback(Std.int(999 - tmpBeadIndex), resistNudgeDuration, beadRadius);
			}
		}
		if (resistNudge)
		{
			beadPosition = tmpBeadIndex + Math.min(BEAD_BP_CENTER - 0.00001, (BEAD_BP_CENTER - beadBpRadius) * resistAmount + (desiredBeadPosition - tmpBeadIndex) * (1 - resistAmount));
			beadNudgeCallback(Std.int(999 - tmpBeadIndex), resistNudgeDuration, beadRadius);
		}
		else
		{
			resistNudgeDuration = 0;
			beadPosition = desiredBeadPosition;
		}
		slack = 0;
	}

	public function removeBeads(count:Int)
	{
		this.abrasTurn = true;
		this.abraTransitionTime = 1.0;
		this.abraPauseTime = 0;
		this.abraBeadsToRemove = Std.int(Math.min(count, 1000 - Std.int(beadPosition)));
		this.abraBeadCount = getIntBeadPosition();
	}

	public function getIntBeadPosition():Int
	{
		return Std.int(beadPosition + 1 - BEAD_BP_CENTER);
	}

	public function getNextPulledBeadIndex():Int
	{
		return 999 - getIntBeadPosition();
	}

	private function getBeadSize(index:Int)
	{
		if (index >= 1000)
		{
			// no more beads
			return -1;
		}
		return beadSizes[(10000 - index) % beadSizes.length];
	}

	private function getBeadRadius(index:Int):Float
	{
		if (index >= 1000)
		{
			// no more beads
			return 0;
		}
		return beadRadii[getBeadSize(index)];
	}

	private function magicNumber(index:Int)
	{
		return getBeadRadius(index) * 0.7;
	}

	/**
	 * Masks an object which is contained entirely within the sphincter, like a
	 * bead which is inside
	 */
	private function applyObjectWithinSphincterMask()
	{
		_assMask.animation.frameIndex = _ass.animation.frameIndex;
		_beads.stamp(_assMask, 0, 0);
		_beads.graphic.bitmap.threshold(_beads.graphic.bitmap, new Rectangle(0, 0, _beads.width, _beads.height), new Point(0, 0), "==", 0xffff00ff, 0x00000000);
		_beads.dirty = true;
	}

	/**
	 * Masks an object which is contained partially within the sphincter, like
	 * a string which connects an inside bead to an outside bead
	 *
	 * @param	x0 x coordinate of the object within the sphincter
	 * @param	y0 y coordinate of the object within the sphincter
	 * @param	x1 x coordinate of the object outside the sphincter
	 * @param	y1 y coordinate of the object outside the sphincter
	 */
	private function applyObjectExitingSphincterMask(x0:Float, y0:Float, x1:Float, y1:Float)
	{
		if (_ass.animation.frameIndex == 0)
		{
			var angle:Float = Math.atan2(y1 - y0, x1 - x0);

			if (angle < -0.833 * Math.PI)
			{
				// w mask...
				_assMask.animation.frameIndex = 12;
			}
			else if (angle < 0)
			{
				// nw mask...
				_assMask.animation.frameIndex = 13;
			}
			else if (angle < 0.833 * Math.PI)
			{
				// sw mask...
				_assMask.animation.frameIndex = 6;
			}
			else
			{
				// w mask...
				_assMask.animation.frameIndex = 12;
			}
		}
		else
		{
			_assMask.animation.frameIndex = _ass.animation.frameIndex + 6;
		}
		_beads.stamp(_assMask, 0, 0);
		_beads.graphic.bitmap.threshold(_beads.graphic.bitmap, new Rectangle(0, 0, _beads.width, _beads.height), new Point(0, 0), "==", 0xffff00ff, 0x00000000);
		_beads.dirty = true;
	}

	public function getCurrentInsertedBeadCount():Int
	{
		return 1000 - Std.int(beadPosition);
	}

	override public function setArousal(Arousal:Int)
	{
		super.setArousal(Arousal);

		var beadCount:Int = getCurrentInsertedBeadCount();
		if (beadCount > 115)
		{
			playNewAnim(_head, ["sick2"]);
			_body.animation.frameIndex = 5;
		}
		else if (beadCount > 100)
		{
			playNewAnim(_head, ["sick1"]);
			_body.animation.frameIndex = 4;
		}
		else if (beadCount > 85)
		{
			playNewAnim(_head, ["sick0"]);
			_body.animation.frameIndex = 3;
		}
		else
		{
			if (_arousal == 0)
			{
				playNewAnim(_head, ["0"]);
			}
			else if (_arousal == 1)
			{
				playNewAnim(_head, ["1"]);
			}
			else if (_arousal == 2)
			{
				playNewAnim(_head, ["2"]);
			}
			else if (_arousal == 3)
			{
				playNewAnim(_head, ["3"]);
			}
			else if (_arousal == 4)
			{
				playNewAnim(_head, ["4"]);
			}
			else if (_arousal == 5)
			{
				playNewAnim(_head, ["5"]);
			}
			if (beadCount > 65)
			{
				_body.animation.frameIndex = 2;
			}
			else if (beadCount > 45)
			{
				_body.animation.frameIndex = 1;
			}
			else
			{
				_body.animation.frameIndex = 0;
			}
		}
		if (!PlayerData.abraMale)
		{
			_dick.animation.frameIndex = _body.animation.frameIndex;
		}
	}

	private function drawBeadLine(x0:Float, y0:Float, x1:Float, y1:Float):Void
	{
		if (FlxMath.vectorLength(x1 - x0, y1 - y0) < 1.0) {
			return;
		}

		FlxSpriteUtil.drawLine(_beads, x0, y0, x1, y1, {color:lineColor, thickness:beadStringThickness});
		if (greyBeads)
		{
			FlxSpriteUtil.drawLine(_beads, x0, y0 - 2, x1, y1 - 2, {color:0xff4a4a4a, thickness:2});
		}
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		CursorUtils.initializeHandBouncySprite(_interact, AssetPaths.abrabeads_interact__png);
		_interact.alpha = PlayerData.cursorMinAlpha;
		_interact.animation.add("default", [0]);
		_interact.animation.add("ready-to-push", [1]);
		_interact.animation.add("push-bead", [1, 2, 3, 4, 5]);
	}

	override public function destroy():Void
	{
		super.destroy();

		_arms0 = FlxDestroyUtil.destroy(_arms0);
		_legs0 = FlxDestroyUtil.destroy(_legs0);
		_body = FlxDestroyUtil.destroy(_body);
		_ass = FlxDestroyUtil.destroy(_ass);
		_assMask = FlxDestroyUtil.destroy(_assMask);
		_arms1 = FlxDestroyUtil.destroy(_arms1);
		_arms2 = FlxDestroyUtil.destroy(_arms2);
		_arms3 = FlxDestroyUtil.destroy(_arms3);
		_fingers = FlxDestroyUtil.destroy(_fingers);
		_legs1 = FlxDestroyUtil.destroy(_legs1);
		_legs2 = FlxDestroyUtil.destroy(_legs2);
		_beads = FlxDestroyUtil.destroy(_beads);
		_beadBrush = FlxDestroyUtil.destroy(_beadBrush);

		beadSizes = null;
		beadPushAnim = null;
		beadPullCallback = null;
		beadNudgeCallback = null;
		beadPushCallback = null;
		beadPushCallback = null;
		beadRadii = null;
		resistAmounts = null;
		bv = null;
	}
}