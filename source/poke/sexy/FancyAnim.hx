package poke.sexy;
import flixel.FlxG;
import flixel.FlxSprite;
import poke.sexy.FancyAnim;

/**
 * A FancyAnim is an animation which has variable speed based on how fast the
 * player presses the mouse.
 *
 * The animation's current frame goes forward and backward with a sine wave
 * pattern. If the player releases the mouse quickly, the "up part" of the wave
 * will have a shorter period and steepen. If the player presses the mouse
 * quickly, the "down part" of the wave will have a shorter period and steepen.
 * The animation will pause just after the sine wave's highest or lowest point,
 * until another mouse event is triggered.
 */
class FancyAnim
{
	public static var DEFAULT_MOUSE_TIME:Float = 0.65;

	public var _flxSprite:FlxSprite;

	public var _forwardSpeedLimit:Float = 0;
	public var _backwardSpeedLimit:Float = 0;

	public var _prevMouseDownTime:Float = DEFAULT_MOUSE_TIME;
	public var _prevMouseUpTime:Float = DEFAULT_MOUSE_TIME;

	private var _mouseDownTime:Float = DEFAULT_MOUSE_TIME;
	private var _mouseUpTime:Float = DEFAULT_MOUSE_TIME;

	private var _curRadians:Float = 0;
	private var _targetRadians:Float = 0;
	private var _rate:Float = 0;

	private var prevFrame:Float = 0;
	private var _weirdFraction:Float = 0;

	public var sfxLength:Float = 0;
	public var mouseDownSfx:Bool = false; // just played mouseDown sfx
	public var mouseUpSfx:Bool = false; // just played mouseUp sfx

	/**
	 * We usually just play sound effects on frame #0. forceSfx is a kludge to ensure we don't miss
	 * a sound effect for animations that surprisingly start or transition on frame #1.
	 */
	private var forceSfx:Bool = false;
	private var needsRefresh:Bool = false;

	private var animNames:Array<String>;

	private var maxQueuedClicks:Int = 100;
	private var ignoredEvent:Bool = false;
	public var enabled:Bool = true;

	public function new(flxSprite:FlxSprite, animName:String)
	{
		this._flxSprite = flxSprite;
		setAnimName(animName);
		_curRadians = _weirdFraction;
		_targetRadians = _curRadians;
		forceSfx = true;

		update(-1);
	}

	public function setMaxQueuedClicks(maxQueuedClicks:Int):Void
	{
		this.maxQueuedClicks = maxQueuedClicks;
	}

	public function setSpeedLimit(forwardSpeedLimit:Float, backwardSpeedLimit:Float):Void
	{
		this._forwardSpeedLimit = forwardSpeedLimit;
		this._backwardSpeedLimit = backwardSpeedLimit;
	}

	public function setSpeed(click:Float, release:Float):Void
	{
		_prevMouseDownTime = click;
		_prevMouseUpTime = release;
		if (FlxG.mouse.pressed)
		{
			_rate = (_targetRadians - _curRadians) / (_prevMouseDownTime * 1.2);
		}
		else {
			_rate = (_targetRadians - _curRadians) / (_prevMouseUpTime * 1.2);
		}
	}

	public function refreshSoon()
	{
		needsRefresh = true;
	}

	public function setAnimName(animName:String)
	{
		animNames = [animName];
		refresh();
	}

	public function addAnimName(animName:String)
	{
		animNames.push(animName);
	}

	public function update(elapsed:Float):Void
	{
		mouseDownSfx = false;
		mouseUpSfx = false;
		if (!enabled)
		{
			return;
		}
		sfxLength = 0;
		if (FlxG.mouse.justPressed || FlxG.mouse.pressed && elapsed == -1)
		{
			if (_targetRadians + Math.PI > _curRadians + maxQueuedClicks * 2 * Math.PI)
			{
				// ignore event; too many clicks queued
				ignoredEvent = true;
			}
			else
			{
				_targetRadians = _targetRadians + Math.PI;
				_rate = (_targetRadians - _curRadians) / (_prevMouseDownTime * 1.2);

				_prevMouseUpTime = _mouseUpTime;
				_mouseDownTime = 0;
			}
		}
		if (FlxG.mouse.justReleased || !FlxG.mouse.pressed && elapsed == -1)
		{
			if (ignoredEvent)
			{
				// ignore event; too many clicks queued
				ignoredEvent = false;
			}
			else
			{
				_targetRadians = _targetRadians + Math.PI;
				_rate = (_targetRadians - _curRadians) / (_prevMouseUpTime * 1.2);

				_prevMouseDownTime = _mouseDownTime;
				_mouseUpTime = 0;
			}
		}
		elapsed = Math.max(0, elapsed);

		if (FlxG.mouse.pressed)
		{
			_mouseDownTime += elapsed;
		}
		else {
			_mouseUpTime += elapsed;
		}
		if (_forwardSpeedLimit > 0 || _backwardSpeedLimit > 0)
		{
			// enforce speed limit...
			var tmpRate:Float = _rate;
			var movingForward:Bool = isMovingForward();
			if (movingForward)
			{
				if (_forwardSpeedLimit > 0 && tmpRate > (Math.PI * 2) / (_forwardSpeedLimit * 1.2))
				{
					tmpRate = (Math.PI * 2) / (_forwardSpeedLimit * 1.2);
				}
			}
			else
			{
				if (_backwardSpeedLimit > 0 && tmpRate > (Math.PI * 2) / (_backwardSpeedLimit * 1.2))
				{
					tmpRate = (Math.PI * 2) / (_backwardSpeedLimit * 1.2);
				}
			}
			var oldRadians:Float = _curRadians;
			_curRadians = Math.min(_curRadians + tmpRate * elapsed, _targetRadians);
			if (isMovingForward() != movingForward)
			{
				// changed from forward to backward... make sure they don't skirt past an oppressive speed limit
				_curRadians = (Math.ceil(oldRadians / Math.PI - 0.5) + 0.5) * Math.PI + 0.00001;
			}
		}
		else {
			_curRadians = Math.min(_curRadians + _rate * elapsed, _targetRadians);
		}

		if (needsRefresh && (nearMinFrame() || nearMaxFrame()))
		{
			refresh();
			needsRefresh = false;
		}

		if (animNames.length > 1)
		{
			if (_flxSprite.animation.name != animNames[computeAnimIndex()])
			{
				refresh();
				forceSfx = true;
			}
		}
		var curFrame:Int = computeCurFrame();

		if (curFrame != _flxSprite.animation.curAnim.curFrame)
		{
			if (_flxSprite.animation.curAnim.curFrame == 0 || forceSfx)
			{
				sfxLength = _prevMouseDownTime;
				forceSfx = false;
				mouseDownSfx = true;
			}
			else if (_flxSprite.animation.curAnim.curFrame == _flxSprite.animation.curAnim.numFrames - 1)
			{
				sfxLength = _prevMouseUpTime;
				mouseUpSfx = true;
			}
		}
		_flxSprite.animation.curAnim.curFrame = curFrame;
	}

	public inline function nearMinFrame():Bool
	{
		return Math.sin(_curRadians) < -0.95;
	}

	public function nearMaxFrame():Bool
	{
		return Math.sin(_curRadians) > 0.95;
	}

	public function synchronize(fancyAnim:FancyAnim)
	{
		this._prevMouseDownTime = fancyAnim._prevMouseDownTime;
		this._prevMouseUpTime = fancyAnim._prevMouseUpTime;

		this._mouseDownTime = fancyAnim._mouseDownTime;
		this._mouseUpTime = fancyAnim._mouseUpTime;

		this._curRadians = fancyAnim._curRadians;
		this._targetRadians = fancyAnim._targetRadians;
		this._rate = fancyAnim._rate;

		this.prevFrame = fancyAnim.prevFrame;
		this._weirdFraction = fancyAnim._weirdFraction;

		refresh();
	}

	public function refresh():Void
	{
		_targetRadians -= _weirdFraction;
		_flxSprite.animation.play(animNames[computeAnimIndex()]);
		_flxSprite.animation.pause();
		_flxSprite.animation.curAnim.curFrame = computeCurFrame();
		_weirdFraction = -Math.asin((_flxSprite.animation.curAnim.numFrames - 1) / (_flxSprite.animation.curAnim.numFrames)) - 0.01;
		_targetRadians += _weirdFraction;
	}

	function computeCurFrame():Int
	{
		return Math.round(getUnroundedCurFrame());
	}

	public function getUnroundedCurFrame():Float
	{
		return Math.sin(_curRadians) * ((_flxSprite.animation.curAnim.numFrames - 1.01) / 2) + (_flxSprite.animation.curAnim.numFrames - 1) / 2;
	}

	public function isMovingForward():Bool
	{
		return Math.cos(_curRadians) > 0;
	}

	function computeAnimIndex():Int
	{
		return Std.int((_curRadians - _weirdFraction) / (2 * Math.PI)) % animNames.length;
	}
}