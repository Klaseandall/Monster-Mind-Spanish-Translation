package minigame.scale;
import flixel.util.FlxDestroyUtil;
import minigame.scale.ScalePuzzle;
import critter.CritterHolder;
import critter.EllipseCritterHolder;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.geom.Rectangle;

/**
 * Graphics for the scale part of the scale minigame.
 * 
 * Handles drawing the different parts of the scale, drawing the clock and
 * bouncing the two halves of the scale up and down
 */
class Scale extends FlxGroup
{
	private static var MOVEMENT_RANGE:Int = 23;
	
	private var _puzzle:ScalePuzzle;
	public var _posts:Array<FlxSprite> = [];
	public var _joints:Array<FlxSprite> = [];
	public var _pads:Array<CritterHolder> = [];
	public var _notes:Array<FlxSprite> = [];
	public var _scaleBody:FlxSprite;
	public var _scaleCenter:FlxSprite;
	public var _scaleNeedle:FlxSprite;
	public var _scaleClockBg:FlxSprite;
	public var _scaleClockHand:FlxSprite;
	
	/*
	 * The balance of the scale is simulated with an invisible bouncing sprite.
	 * If the scale is unbalanced heavily to the right, the sprite will be
	 * accelerated to a higher point, such as (0, 250). If the scale is
	 * balanced slightly to the left, the sprite would instead be accelerated
	 * towards a lower point, such as (0, 75). The position of this sprite
	 * decides how we draw the scale.
	 */
	public var _balanceSprite:FlxSprite;
	public var _balance:Float = 0;
	
	public var _leftBalanceOffset:Float = 0;
	public var _rightBalanceOffset:Float = 0;
	public var _leftJoist:FlxSprite;
	public var _rightJoist:FlxSprite;
	public var _centerJoist:FlxSprite;
	public var _scaleShadow:FlxSprite;
	
	private var _leftRange:Float = -1;
	private var _rightRange:Float = 1;
	public var _shortScale:Bool = false;

	public function new() {
		super();
		_scaleBody = new FlxSprite(21, 231);
		add(_scaleBody);
		_scaleCenter = new FlxSprite(0, 104, AssetPaths.scale_center__png);
		_scaleShadow = new FlxSprite(21, 231);
		add(_scaleCenter);
		_scaleClockBg = new FlxSprite(0, 254, AssetPaths.scale_clock_bg__png);
		add(_scaleClockBg);
		_scaleClockHand = new FlxSprite(0, 254);
		_scaleClockHand.makeGraphic(27, 23, FlxColor.TRANSPARENT, true);
		add(_scaleClockHand);
		setScaleClockAngle(0, false);
		_leftJoist = new FlxSprite(0, 183);
		add(_leftJoist);
		_rightJoist = new FlxSprite(0, 183);
		add(_rightJoist);
		_centerJoist = new FlxSprite(0, 183);
		add(_centerJoist);
		_scaleNeedle = new FlxSprite(341, 104, AssetPaths.scale_needle__png);
		_scaleNeedle.origin.y += 5;
		add(_scaleNeedle);
		
		for (i in 0...4) {
			var post:FlxSprite = new FlxSprite(0, 179, AssetPaths.scale_post__png);
			add(post);
			_posts.push(post);
		}
		for (i in 0...4) {
			var jointAsset:String = (i == 0 || i == 3) ? AssetPaths.scale_joint_end__png : AssetPaths.scale_joint_mid__png;
			var joint:FlxSprite = new FlxSprite(0, 179, jointAsset);
			joint.flipX = i >= 2;
			add(joint);
			_joints.push(joint);
		}
		for (j in 0...7) {
			if (j % 2 == 1) {
				continue;
			}
			var padY:Int = 170;
			var pad:EllipseCritterHolder = new EllipseCritterHolder(0, padY);
			pad._sprite.loadGraphic(AssetPaths.scale_platform__png);
			pad._sprite.height = 45;
			pad._sprite.offset.y = 6;
			pad._leashRadiusX = 45;
			pad._leashRadiusY = 22;
			pad._leashOffsetY = -12;
			_pads.push(pad);
			add(pad._sprite);
		}
		
		for (i in 0...4) {
			var note:FlxSprite = new FlxSprite(0, 197);
			note.makeGraphic(40, 40, FlxColor.TRANSPARENT, true);
			add(note);
			_notes.push(note);
		}
		
		_balanceSprite = new FlxSprite(200, 100);
		_balanceSprite.makeGraphic(6, 6, FlxColor.RED);
		_balanceSprite.offset.x = 3;
		_balanceSprite.offset.y = 3;
		_balanceSprite.elasticity = 0.5;
		_balanceSprite.visible = false;
		add(_balanceSprite);
	}
	
	override public function update(elapsed:Float):Void {
		for (holder in _pads) {
			holder.leashAll();
		}
		
		super.update(elapsed);
		
		updateSpritesForBalance(elapsed);
	}
	
	public function recalculateBalance():Void {
		if (_puzzle == null) {
			return;
		}
		_balance = _pads[2]._critters.length * _puzzle._weights[2] + _pads[3]._critters.length * _puzzle._weights[3] - _pads[0]._critters.length * _puzzle._weights[0] - _pads[1]._critters.length * _puzzle._weights[1];
	}
	
	public function getCritterCount():Int {
		return _pads[0]._critters.length + _pads[1]._critters.length + _pads[2]._critters.length + _pads[3]._critters.length;
	}
	
	/**
	 * Reshapes the scale according to the specified puzzle
	 */
	public function setPuzzle(puzzle:ScalePuzzle) {
		this._puzzle = puzzle;
		
		_balanceSprite.y = 100;
		_balanceSprite.acceleration.y = 0;
		_balanceSprite.velocity.y = 0;
		updateSpritesForBalance(0);
		
		for (i in 0...4) {
			_notes[i].pixels.fillRect(_notes[i].pixels.rect, FlxColor.TRANSPARENT);
			var noteSprite:FlxSprite = new FlxSprite(0, 0);
			noteSprite.loadGraphic(AssetPaths.scale_note_small__png, true, 40, 30);
			noteSprite.animation.frameIndex = FlxG.random.int(0, noteSprite.animation.numFrames - 1);
			noteSprite.flipX = FlxG.random.bool();
			_notes[i].stamp(noteSprite, 0, 6);
			var text:FlxText = new FlxText(0, 0, 40, Std.string(_puzzle._weights[i]), 22);
			text.alignment = "center";
			text.color = ItemsMenuState.DARK_BLUE;
			text.font = AssetPaths.just_sayin__otf;
			_notes[i].stamp(text, 0, 7);
			var tape:FlxSprite = new FlxSprite(0, 0);
			tape.loadGraphic(AssetPaths.scale_tape__png, true, 20, 20);
			tape.animation.frameIndex = FlxG.random.int(0, noteSprite.animation.numFrames - 1);
			tape.flipX = FlxG.random.bool();
			tape.alpha = 0.4;
			_notes[i].stamp(tape, 10, 0);
		}
		
		var sortedWeights:Array<Int> = _puzzle._weights.copy();
		sortedWeights.sort(function(a, b) return a - b);
		
		var padPositionIndexes:Array<Float> = [];
		var centerPostPosition:Float = 0;
		var padMin:Float = 7;
		var padMax:Float = 0;
		for (i in 0...4) {
			var weightSize:Int = sortedWeights.indexOf(_puzzle._weights[i]);
			if (i < 2) {
				padPositionIndexes.push(3 - weightSize);
			} else {
				padPositionIndexes.push(4 + weightSize);
			}
			if (weightSize == 0) {
				if (i < 2) {
					centerPostPosition = 3.8;
				} else {
					centerPostPosition = 3.2;
				}
			}
			padMin = Math.min(padMin, padPositionIndexes[padPositionIndexes.length - 1]);
			padMax = Math.max(padMin, padPositionIndexes[padPositionIndexes.length - 1]);
		}
		_shortScale = padMax - padMin < 6 ;
		_scaleBody.loadGraphic(_shortScale ? AssetPaths.scale_short__png : AssetPaths.scale__png);
		var shiftAmount:Float = 3 - 0.5 * padMax - 0.5 * padMin;
		for (i in 0...4) {
			padPositionIndexes[i] += shiftAmount;
		}
		centerPostPosition += shiftAmount;
		for (i in 0...4) {
			_pads[i]._sprite.x = padPositionIndexes[i] * 108 + 16;
			_joints[i].x = padPositionIndexes[i] * 108 + 45;
			_posts[i].x = padPositionIndexes[i] * 108 + 45;
			_notes[i].x = padPositionIndexes[i] * 108 + 41 + FlxG.random.float( -10, 10);
			_notes[i].y = 197;
		}
		_scaleCenter.x = centerPostPosition * 108 + 17;
		_scaleNeedle.x = centerPostPosition * 108 + 17;
		_scaleClockBg.x = centerPostPosition * 108 + 48;
		_scaleClockHand.x = centerPostPosition * 108 + 48;
		{
			makeJoistGraphic(_leftJoist, Std.int(_pads[1]._sprite.x - _pads[0]._sprite.x));
			_leftJoist.x = _pads[0]._sprite.x + 45;
			makeJoistGraphic(_centerJoist, Std.int(_pads[2]._sprite.x - _pads[1]._sprite.x));
			_centerJoist.x = _pads[1]._sprite.x + 45;
			_centerJoist.origin.x = (_scaleCenter.x + _scaleCenter.width / 2) - _centerJoist.x;
			makeJoistGraphic(_rightJoist, Std.int(_pads[3]._sprite.x - _pads[2]._sprite.x));
			_rightJoist.x = _pads[2]._sprite.x + 45;
		}
		{
			// what's the range of motion for the two sets of platforms?
			var center1:Float = _scaleCenter.x + _scaleCenter.width / 2;
			var dist0:Float = center1 - (_pads[1]._sprite.x + _pads[1]._sprite.width / 2);
			var dist1:Float = (_pads[2]._sprite.x + _pads[2]._sprite.width / 2) - center1;
			if (dist1 > dist0) {
				// right side will be moving more
				_rightRange = MOVEMENT_RANGE;
				_leftRange = -MOVEMENT_RANGE * (dist0 / dist1);
			} else {
				// left side will be moving more
				_leftRange = -MOVEMENT_RANGE;
				_rightRange = MOVEMENT_RANGE * (dist1 / dist0);
			}
		}
		
		// reshape shadow, and clear away the notch at the bottom of the shadow for the center
		_scaleShadow.loadGraphic(padMax - padMin >= 6 ? AssetPaths.scale_shadow__png : AssetPaths.scale_shadow_short__png, false, 730, 68, true);
		_scaleShadow.pixels.fillRect(new Rectangle(Std.int(_scaleCenter.x) - _scaleShadow.x, 56, 89, 1), FlxColor.TRANSPARENT);
		_scaleShadow.pixels.fillRect(new Rectangle(Std.int(_scaleCenter.x) - _scaleShadow.x + 1, 56, 87, 2), FlxColor.TRANSPARENT);
		_scaleShadow.pixels.fillRect(new Rectangle(Std.int(_scaleCenter.x) - _scaleShadow.x + 2, 56, 85, 3), FlxColor.TRANSPARENT);
		_scaleShadow.pixels.fillRect(new Rectangle(Std.int(_scaleCenter.x) - _scaleShadow.x + 3, 56, 83, 4), FlxColor.TRANSPARENT);
	}
	
	function makeJoistGraphic(sprite:FlxSprite, width:Int) {
		var joistTemplate:FlxSprite = new FlxSprite(0, 0, AssetPaths.scale_horizontal_joist__png);
		joistTemplate.flipX = FlxG.random.bool();
		sprite.makeGraphic(width, 38, FlxColor.TRANSPARENT, true);
		sprite.stamp(joistTemplate, FlxG.random.int(Std.int(width - joistTemplate.width), 0), 0);
	}
	
	function updateSpritesForBalance(elapsed:Float):Void 
	{
		var balanceSpriteTargetY:Float = _balance * 7 + 100;
		if (_balance < 0) {
			balanceSpriteTargetY -= 21;
		} else if (_balance > 0) {
			balanceSpriteTargetY += 21;
		}
		if (Math.abs(_balanceSprite.y - balanceSpriteTargetY) < 5) {
			_balanceSprite.acceleration.y = 0;
		} else if (_balanceSprite.y < balanceSpriteTargetY) {
			_balanceSprite.acceleration.y = _balanceSprite.y >= 400 ? 0 : 400;
		} else {
			_balanceSprite.acceleration.y = _balanceSprite.y <= 0 ? 0 : -400;
		}
		if (_balanceSprite.velocity.y > 0) {
			_balanceSprite.velocity.y = Math.max(0, _balanceSprite.velocity.y - 100 * elapsed);
		} else if (_balanceSprite.velocity.y < 0) {
			_balanceSprite.velocity.y = Math.min(0, _balanceSprite.velocity.y + 100 * elapsed);
		}
		if (_balanceSprite.y < 0) {
			_balanceSprite.y = 0;
			_balanceSprite.velocity.y = Math.max(0, Math.abs(_balanceSprite.velocity.y) * _balanceSprite.elasticity - 3);
		} else if (_balanceSprite.y > 200) {
			_balanceSprite.y = 200;
			_balanceSprite.velocity.y = -Math.max(0, Math.abs(_balanceSprite.velocity.y) * _balanceSprite.elasticity - 3);
		}
		
		var newLeftBalanceOffset:Float = _leftRange * (FlxMath.bound(_balanceSprite.y, 1, 199) - 100) / 100;
		var newRightBalanceOffset:Float = _rightRange * (FlxMath.bound(_balanceSprite.y, 1, 199) - 100) / 100;
		
		if (Std.int(newLeftBalanceOffset) != Std.int(_leftBalanceOffset) || Std.int(newRightBalanceOffset) != Std.int(_rightBalanceOffset)) {
			for (i in 0...4) {
				var offsetDiff:Int = i < 2 ? (Std.int(newLeftBalanceOffset) - Std.int(_leftBalanceOffset)) : (Std.int(newRightBalanceOffset) - Std.int(_rightBalanceOffset));
				_pads[i]._sprite.y += offsetDiff;
				for (critter in _pads[i]._critters) {
					critter.movePosition(0, offsetDiff);
				}
				_notes[i].y += offsetDiff;
				_joints[i].y += offsetDiff;
			}
			_leftJoist.y += (Std.int(newLeftBalanceOffset) - Std.int(_leftBalanceOffset));
			_rightJoist.y += (Std.int(newRightBalanceOffset) - Std.int(_rightBalanceOffset));
			_centerJoist.angle = FlxAngle.asDegrees(Math.atan2(_rightJoist.y - _leftJoist.y, _rightJoist.x - (_leftJoist.x + _leftJoist.width)));
			_scaleNeedle.angle = _centerJoist.angle;
		}
		_leftBalanceOffset = newLeftBalanceOffset;		
		_rightBalanceOffset = newRightBalanceOffset;
	}
	
	public function setScaleClockAngle(angle:Float, flash:Bool):Void {
		var angleRadians:Float = Math.PI / 2 - FlxAngle.asRadians(angle);
		_scaleClockHand.pixels.fillRect(new Rectangle(0, 0, _scaleClockHand.width, _scaleClockHand.height), FlxColor.TRANSPARENT);
		var originX:Int = 13;
		var originY:Int = 11;
		if (angle <= 90) {
			originY += 1;
		}
		FlxSpriteUtil.drawLine(_scaleClockHand, originX, originY, originX + Math.cos(angleRadians) * 7, originY - Math.sin(angleRadians) * 7, { color:0xff694c28, thickness: 2 });
		FlxSpriteUtil.drawLine(_scaleClockHand, originX, originY, originX + Math.cos(angleRadians) * 8, originY - Math.sin(angleRadians) * 8, { color:0xff694c28, thickness: 1 });
		if (flash) {
			var flashSprite:FlxSprite = new FlxSprite(0, 0, AssetPaths.scale_clock_bg_flash__png);
			flashSprite.alpha = 0.5;
			_scaleClockHand.stamp(flashSprite);
		}
	}
	
	override public function destroy():Void {
		super.destroy();
		
		_posts = FlxDestroyUtil.destroyArray(_posts);
		_joints = FlxDestroyUtil.destroyArray(_joints);
		_pads = FlxDestroyUtil.destroyArray(_pads);
		_notes = FlxDestroyUtil.destroyArray(_notes);
		_scaleBody = FlxDestroyUtil.destroy(_scaleBody);
		_scaleCenter = FlxDestroyUtil.destroy(_scaleCenter);
		_scaleNeedle = FlxDestroyUtil.destroy(_scaleNeedle);
		_scaleClockBg = FlxDestroyUtil.destroy(_scaleClockBg);
		_scaleClockHand = FlxDestroyUtil.destroy(_scaleClockHand);
		_balanceSprite = FlxDestroyUtil.destroy(_balanceSprite);
		_leftJoist = FlxDestroyUtil.destroy(_leftJoist);
		_rightJoist = FlxDestroyUtil.destroy(_rightJoist);
		_centerJoist = FlxDestroyUtil.destroy(_centerJoist);
		_scaleShadow = FlxDestroyUtil.destroy(_scaleShadow);
	}
}