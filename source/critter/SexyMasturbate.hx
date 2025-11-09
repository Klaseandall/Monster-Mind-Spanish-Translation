package critter;
import flixel.FlxG;
import flixel.math.FlxPoint;

/**
 * An animation where a bug masturbates
 */
class SexyMasturbate extends SexyCritterAnim
{
	public var critter:Critter;
	private var facing:Int = 0;

	public function new(critter:Critter, facing:Int)
	{
		super();
		this.critter = critter;
		this.facing = facing;
	}

	/**
	 * Run to a specific place and masturbate. This is used in other more
	 * complex animations, such as if a bug needs to warm up for something. Or
	 * if have a sudden to masturbate at the combination pizza hut/taco bell on
	 * 81st street, I guess. I haven't coded that part yet.
	 *
	 * @param	point the point to run to
	 */
	public function runToAndMasturbate(point:FlxPoint)
	{
		critter.runTo(point.x, point.y, critterMasturbate);
	}

	public function critterMasturbate(critter:Critter)
	{
		masturbate(null);
	}

	public function masturbate(args:Array<Dynamic>)
	{
		critter._bodySprite.facing = facing;

		stopSexyAnim(critter);
		var bodyFrames:Array<Int> = [];
		var headFrames:Array<Int> = [];
		if (critter.isMale())
		{
			AnimTools.push(bodyFrames, FlxG.random.int(30, 60), [32, 33]);
		}
		else
		{
			AnimTools.push(bodyFrames, FlxG.random.int(30, 60), [32, 31]);
		}
		AnimTools.push(headFrames, FlxG.random.int(30, 60), [48, 49]);
		critter._bodySprite.animation.add("sexy-misc", bodyFrames, Critter._FRAME_RATE, true);
		critter._headSprite.animation.add("sexy-misc", headFrames, Critter._FRAME_RATE, true);
		critter._frontBodySprite.animation.add("sexy-misc", [
				2, 2,
											   ], Critter._FRAME_RATE, true);
		critter.playAnim("sexy-misc");
	}

	/**
	 * Almost cum, but stop and regain composure
	 */
	public function almostCum(args:Array<Dynamic>)
	{
		critter._bodySprite.facing = facing;

		stopSexyAnim(critter);
		if (critter.isMale())
		{
			critter._bodySprite.animation.add("sexy-misc", [
												  32, 32, 33, 33, 32, 32,
												  33, 32, 33, 32, 33, 32, // fast...
												  32, 32, 32, 32, 32, 32, // pause...
												  32, 32, 32, 32, 32, 32,

												  33, 33, 33, 32, 32, 32,
												  33, 33, 32, 32, 33, 33,
												  32, 32, 33, 33, 32, 32,
												  33, 33, 32, 32, 33, 33,
												  33, 33, 33, 32, 32, 32,
												  33, 33, 32, 32, 33, 33,
												  32, 32, 33, 33, 32, 32,
												  33, 33, 32, 32, 33, 33,
												  33, 33, 33, 32, 32, 32,
												  33, 33, 32, 32, 33, 33,
												  32, 32, 33, 33, 32, 32,
												  33, 33, 32, 32, 33, 33,
											  ], Critter._FRAME_RATE, true);
		}
		else
		{
			critter._bodySprite.animation.add("sexy-misc", [
												  32, 32, 31, 31, 32, 32,
												  31, 32, 31, 32, 31, 32, // fast...
												  32, 32, 32, 32, 32, 32, // pause...
												  32, 32, 32, 32, 32, 32,

												  31, 31, 31, 32, 32, 32,
												  31, 31, 32, 32, 31, 31,
												  32, 32, 31, 31, 32, 32,
												  31, 31, 32, 32, 31, 31,
												  31, 31, 31, 32, 32, 32,
												  31, 31, 32, 32, 31, 31,
												  32, 32, 31, 31, 32, 32,
												  31, 31, 32, 32, 31, 31,
												  31, 31, 31, 32, 32, 32,
												  31, 31, 32, 32, 31, 31,
												  32, 32, 31, 31, 32, 32,
												  31, 31, 32, 32, 31, 31,
											  ], Critter._FRAME_RATE, true);
		}
		critter._headSprite.animation.add("sexy-misc", [
											  48, 48, 48, 51, 51, 51,
											  51, 50, 51, 51, 50, 51,
											  51, 51, 51, 48, 49, 49,
											  49, 49, 48, 49, 48, 48,

											  48, 48, 49, 48, 49, 49,
											  49, 48, 48, 48, 48, 48,
											  49, 48, 48, 49, 49, 49,
											  49, 49, 48, 49, 48, 48,
											  48, 48, 49, 48, 49, 49,
											  49, 48, 48, 48, 48, 48,
											  49, 48, 48, 49, 49, 49,
											  49, 49, 48, 49, 48, 48,
											  48, 48, 49, 48, 49, 49,
											  49, 48, 48, 48, 48, 48,
											  49, 48, 48, 49, 49, 49,
											  49, 49, 48, 49, 48, 48,
										  ], Critter._FRAME_RATE, true);
		critter._frontBodySprite.animation.add("sexy-misc", [
				2, 2,
											   ], Critter._FRAME_RATE, true);
		critter.playAnim("sexy-misc");
	}

	public function cum(args:Array<Dynamic>)
	{
		stopSexyAnim(critter);
		if (critter.isMale())
		{
			critter._eventStack.addEvent({time:critter._eventStack._time + 4.4, callback:critter.eventJizzStamp, args:[ -28 * (critter._bodySprite.flipX ? -1 : 1), 6]});
			critter._bodySprite.animation.add("sexy-misc", [
												  32, 32, 33, 33, 32, 32,
												  33, 33, 32, 32, 33, 33,
												  32, 33, 32, 33, 32, 33,
												  32, 33, 32, 33, 32, 33,

												  32, 33, 32, 32, 33, 33,
												  32, 32, 32, 32, 32, 32,
												  32, 32, 32, 32, 32, 32,
												  32, 32, 32, 32, 32, 32,
											  ], Critter._FRAME_RATE, false);
			critter._frontBodySprite.animation.add("sexy-misc", [
					2, 2, 2, 2, 2, 2,
					2, 2, 2, 2, 2, 2,
					2, 2, 2, 2, 2, 2,
					2, 2, 2, 2, 2, 2,

					34, 35, 36, 37, 2, 2,
					34, 35, 36, 37, 2, 2,
					2, 2, 2, 2, 2, 2,
					2, 2, 2, 2, 2, 2,
												   ], Critter._FRAME_RATE, false);
		}
		else
		{
			critter._eventStack.addEvent({time:critter._eventStack._time + 4.1, callback:critter.eventJizzStamp, args:[ -6 * (critter._bodySprite.flipX ? -1 : 1), 4]});
			critter._bodySprite.animation.add("sexy-misc", [
												  32, 32, 31, 31, 32, 32,
												  31, 31, 32, 32, 31, 31,
												  32, 31, 32, 31, 32, 31,
												  32, 31, 32, 31, 32, 31,

												  32, 31, 32, 32, 31, 31,
												  32, 32, 32, 32, 32, 32,
												  32, 32, 32, 32, 32, 32,
												  33, 33, 33, 33, 33, 33,
											  ], Critter._FRAME_RATE, false);
			critter._frontBodySprite.animation.add("sexy-misc", [
					2, 2, 2, 2, 2, 2,
					2, 2, 2, 2, 2, 2,
					2, 2, 2, 2, 2, 2,
					2, 2, 2, 2, 2, 2,

					30, 38, 39, 2, 2, 30,
					38, 39, 2, 2, 2, 2,
					2, 2, 2, 2, 2, 2,
					2, 2, 2, 2, 2, 2,
												   ], Critter._FRAME_RATE, false);
		}
		critter._headSprite.animation.add("sexy-misc", [
											  48, 48, 49, 48, 49, 49,
											  49, 48, 48, 49, 49, 48,
											  51, 51, 51, 51, 50, 51,
											  51, 51, 51, 50, 50, 51,

											  51, 51, 51, 51, 50, 51,
											  51, 51, 51, 50, 50, 51,
											  51, 51, 49, 50, 48, 49,
											  48, 48, 49, 48, 49, 49,
										  ], Critter._FRAME_RATE, false);
		critter.playAnim("sexy-misc");
	}

	public function getExpectedRunDuration():Float
	{
		return IdleAnims.getProjectedTime(critter, critter._soulSprite.getPosition(), critter._targetSprite.getPosition());
	}
}