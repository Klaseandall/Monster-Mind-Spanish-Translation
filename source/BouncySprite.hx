package;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * A sprite which slowly moves up and down, creating a "breathing effect".
 */
class BouncySprite extends FlxSprite
{
	public var _bouncePhase:Float = 0;
	public var _bounceAmount:Int = 0;
	public var _age:Float = 0;
	public var _bounceDuration:Float = 0;
	public var _baseOffsetY:Float = 0;

	/**
	 * Initializes a new BouncySprite which slowly moves up and down, creating
	 * a "breathing effect".
	 *
	 * @param	X x coordinate
	 * @param	Y y coordinate
	 * @param	BounceAmount number of pixels the sprite should move up and
	 *       	down. For example a value of "4" will cause the sprite to move
	 *       	up by 2 pixels, and down by 2 pixels
	 * @param	BounceDuration duration of a full cycle of bouncing, in
	 *       	seconds. For example a value of "6" will cause the sprite to
	 *       	move up for 3 seconds and down for 3 seconds
	 * @param	BouncePhase delay before this sprite starts bouncing. Useful
	 *       	for synching the bounce before or after other sprites, so that
	 *       	the Pokemon doesn't simply look like they're compressing and
	 *       	expanding
	 * @param	Age how many seconds has this sprite already been bouncing for?
	 *       	Useful when we want to reinitialize a Pokemon without making
	 *       	them snap back to their original position
	 */
	public function new(X:Float, Y:Float, BounceAmount:Int, BounceDuration:Float, BouncePhase:Float, Age:Float=0)
	{
		super(X, Y);
		this._bounceDuration = BounceDuration;
		this._bounceAmount = BounceAmount;
		this._bouncePhase = BouncePhase;
		this._age = Age;
		adjustY();
	}

	public function loadWindowGraphic(SimpleGraphic:Dynamic, Unique:Bool=false)
	{
		loadGraphic(SimpleGraphic, true, 356, 532, Unique);
	}

	/**
	 * Synchronize this sprite with another BouncySprite, so that they're both
	 * bouncing in synch
	 *
	 * @param	Source the sprite to synchronize with
	 */
	public function synchronize(Source:BouncySprite):Void
	{
		_bouncePhase = Source._bouncePhase;
		_bounceAmount = Source._bounceAmount;
		_age = Source._age;
		_bounceDuration = Source._bounceDuration;
		_baseOffsetY = Source._baseOffsetY;
		y = Source.y;
		x = Source.x;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		_age += elapsed;
		adjustY();
	}

	public function setBaseOffsetY(baseOffsetY:Float)
	{
		this._baseOffsetY = baseOffsetY;
		adjustY();
	}

	public function adjustY()
	{
		var fudge:Float = _bounceAmount % 2 == 1 ? 0.5 : 0;
		offset.y = _baseOffsetY + Math.round(fudge + _bounceAmount * Math.sin((_age + _bouncePhase * _bounceDuration) * (2 * Math.PI / Math.max(_bounceDuration, 0.1))) / 2);
	}
}