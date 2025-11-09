package critter;

import flixel.math.FlxPoint;
import flixel.util.FlxDirectionFlags;

/**
 * An animation where a bug rims/eats out the other bug
 */
class SexyRimming extends SexyCritterAnim
{
	public static var JUMP_DIST:Float = 60;
	private var topCritter:Critter; // the critter doing the rimming
	private var botCritter:Critter; // the critter being rimmed
	public var facing:Int = 0;
	private var jumpTarget:FlxPoint; // if the top were to jump, this is where he'd jump to
	private var jumpSource:FlxPoint; // if the top were to jump, this is where he'd jump from

	public function new(topCritter:Critter, botCritter:Critter, ?facing:Int = 0)
	{
		super();
		this.topCritter = topCritter;
		this.botCritter = botCritter;
		this.facing = facing;
		refresh(null);
	}

	public function refresh(args:Array<Dynamic>)
	{
		if (facing == 0)
		{
			facing = topCritter._bodySprite.x > botCritter._bodySprite.x ? FlxDirectionFlags.LEFT : FlxDirectionFlags.RIGHT;
		}

		jumpTarget = FlxPoint.get(botCritter._targetSprite.x + (facing == FlxDirectionFlags.LEFT ? 18 : -18), botCritter._targetSprite.y - 9);

		var dx:Float = topCritter._bodySprite.x - jumpTarget.x;
		var dy:Float = topCritter._bodySprite.y - jumpTarget.y;
		if (dx == 0 && dy == 0)
		{
			// avoid divide by zero
			dx = 2;
			dy = 1;
		}
		var ex:Float = JUMP_DIST * dx / Math.sqrt(dx * dx + dy * dy);
		var ey:Float = JUMP_DIST * dy / Math.sqrt(dx * dx + dy * dy);
		jumpSource = FlxPoint.get(botCritter._targetSprite.x + ex, botCritter._targetSprite.y + ey);
	}

	public function critterPokeSnout(critter:Critter)
	{
		pokeSnout(null);
	}

	public function pokeSnout(args:Array<Dynamic>)
	{
		topCritter._bodySprite.facing = facing;

		stopSexyAnim(topCritter);
		topCritter._bodySprite.animation.add("sexy-misc", [
				40, 41, 40, 40, 41, 40,
				40, 40, 41, 40, 40, 40,
				40, 40, 40, 40, 41, 41,
				41, 41, 41, 40, 40, 40,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.add("sexy-misc", [
				56, 62, 62, 56, 57, 57,
				57, 63, 56, 63, 63, 56,
				63, 56, 57, 56, 57, 57,
				57, 62, 62, 62, 56, 62,
				63, 57, 57, 57, 62, 62,
				62, 63, 57, 57, 57, 63,
				56, 63, 56, 63, 62, 57,
				62, 57, 63, 57, 56, 57,
											 ], Critter._FRAME_RATE, true);
		topCritter.playAnim("sexy-misc");
	}

	public function botNotice(args:Array<Dynamic>)
	{
		botCritter._bodySprite.facing = facing;

		stopSexyAnim(botCritter);
		botCritter._bodySprite.animation.add("sexy-misc", [
				0, 0
											 ], Critter._FRAME_RATE, true);
		botCritter._headSprite.animation.add("sexy-misc", [
				65, 65, 65, 65, 64, 65,
				64, 65, 65, 65, 64, 64,
				64, 65, 65, 65, 64, 64,
				65, 65, 64, 65, 64, 65,
											 ], Critter._FRAME_RATE, true);
		botCritter._frontBodySprite.animation.add("sexy-misc", [
					45, 45, 2, 2, 2, 2,
				], Critter._FRAME_RATE, false);
		botCritter.playAnim("sexy-misc");
	}

	/**
	 * args[0]: if true, top repositions. otherwise, bottom repositions
	 */
	public function startRim(args:Array<Dynamic>)
	{
		topCritter._bodySprite.facing = facing;
		botCritter._bodySprite.facing = facing;
		var topShouldReposition:Bool = args == null ? false : args[0];
		if (topShouldReposition)
		{
			topCritter.resetFrontBodySprite(); // reset front body sprite, just in case we were standing up or something
			topCritter.setPosition(botCritter._bodySprite.x + (facing == FlxDirectionFlags.LEFT ? 12 : -12), botCritter._bodySprite.y - 6);
		}
		else
		{
			botCritter.setPosition(topCritter._bodySprite.x + (facing == FlxDirectionFlags.LEFT ? -12 : 12), topCritter._bodySprite.y + 6);
		}

		stopSexyAnim(topCritter);
		topCritter.setFrontBodySpriteOffset(7);
		topCritter._bodySprite.animation.add("sexy-misc", [
				43, 42, 42, 43, 42, 43,
				43, 43, 43, 42, 43, 42,
				43, 42, 42, 42, 42, 42,
				43, 43, 43, 42, 42, 43,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.add("sexy-misc", [
				60, 58, 59, 61, 59, 61,
				59, 58, 59, 61, 59, 58,
				59, 58, 60, 58, 59, 59,
				58, 60, 59, 61, 58, 59,
				58, 58, 60, 59, 60, 59,
				61, 58, 61, 58, 61, 58,
				59, 58, 61, 61, 59, 58,
				58, 60, 58, 58, 58, 58,
				61, 59, 59, 61, 61, 61,
				60, 58, 58, 58, 60, 61,
				61, 59, 58, 61, 60, 59,
				61, 58, 61, 60, 59, 60,
				58, 58, 58, 61, 61, 61,
				60, 60, 61, 60, 61, 58,
											 ], Critter._FRAME_RATE, true);
		topCritter._frontBodySprite.animation.add("sexy-misc", [
					44, 44
				], Critter._FRAME_RATE, true);
		topCritter.playAnim("sexy-misc");
	}

	public function critterStartRim(critter:Critter)
	{
		startRim(null);
		botEyesOpen(null);
	}

	public function topEyesOpen(args:Array<Dynamic>)
	{
		stopSexyAnim(topCritter);
		topCritter.setFrontBodySpriteOffset(7);
		topCritter._bodySprite.animation.add("sexy-misc", [
				43, 42, 42, 43, 42, 43,
				43, 43, 43, 42, 43, 42,
				43, 42, 42, 42, 42, 42,
				43, 43, 43, 42, 42, 43,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.add("sexy-misc", [
				60, 58, 59, 61, 59, 61,
				59, 58, 59, 61, 59, 58,
				59, 58, 60, 58, 59, 59,
				58, 60, 59, 61, 58, 59,
				58, 58, 60, 59, 60, 59,
				61, 58, 61, 58, 61, 58,
				59, 58, 61, 61, 59, 58,
				58, 60, 58, 58, 58, 58,
				61, 59, 59, 61, 61, 61,
				60, 58, 58, 58, 60, 61,
				61, 59, 58, 61, 60, 59,
				61, 58, 61, 60, 59, 60,
				58, 58, 58, 61, 61, 61,
				60, 60, 61, 60, 61, 58,
											 ], Critter._FRAME_RATE, true);
		topCritter._frontBodySprite.animation.add("sexy-misc", [
					44, 44
				], Critter._FRAME_RATE, true);
		topCritter.playAnim("sexy-misc");
	}

	public function topEyesClosed(args:Array<Dynamic>)
	{
		stopSexyAnim(topCritter);
		topCritter.setFrontBodySpriteOffset(7);
		topCritter._bodySprite.animation.add("sexy-misc", [
				43, 42, 42, 43, 42, 43,
				43, 43, 43, 42, 43, 42,
				43, 42, 42, 42, 42, 42,
				43, 43, 43, 42, 42, 43,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.add("sexy-misc", [
				67, 69, 69, 66, 69, 66,
				69, 68, 66, 68, 66, 69,
				68, 67, 69, 69, 69, 68,
				66, 68, 66, 68, 66, 67,
				68, 68, 68, 66, 67, 67,
				69, 66, 68, 68, 66, 66,
				66, 68, 67, 68, 69, 67,
				66, 67, 69, 67, 66, 69,
											 ], Critter._FRAME_RATE, true);
		topCritter._frontBodySprite.animation.add("sexy-misc", [
					44, 44
				], Critter._FRAME_RATE, true);
		topCritter.playAnim("sexy-misc");
	}

	public function botEyesOpen(args:Array<Dynamic>)
	{
		stopSexyAnim(botCritter);
		botCritter._bodySprite.animation.add("sexy-misc", [
				47, 47, 47, 46, 46, 46,
				46, 47, 46, 46, 46, 47,
				46, 47, 46, 47, 47, 47,
				47, 47, 47, 47, 47, 46,
											 ], Critter._FRAME_RATE, true);
		botCritter._headSprite.animation.add("sexy-misc", [
				54, 54, 55, 54, 55, 55,
				55, 54, 55, 55, 55, 54,
				54, 54, 55, 55, 55, 54,
				55, 55, 54, 55, 54, 55,
				55, 55, 54, 55, 54, 55,
				55, 55, 54, 54, 54, 54,
				55, 54, 55, 55, 54, 54,
				55, 55, 55, 54, 54, 55,
				54, 55, 54, 55, 54, 55,
				55, 55, 54, 54, 54, 54,
				54, 55, 54, 55, 55, 54,
				54, 55, 54, 54, 55, 55,
				54, 54, 54, 54, 54, 55,
				55, 55, 54, 54, 54, 55,
											 ], Critter._FRAME_RATE, true);
		botCritter.playAnim("sexy-misc");
	}

	public function botEyesClosed(args:Array<Dynamic>)
	{
		stopSexyAnim(botCritter);
		botCritter._bodySprite.animation.add("sexy-misc", [
				47, 47, 47, 46, 46, 46,
				46, 47, 46, 46, 46, 47,
				46, 47, 46, 47, 47, 47,
				47, 47, 47, 47, 47, 46,
											 ], Critter._FRAME_RATE, true);
		botCritter._headSprite.animation.add("sexy-misc", [
				63, 62, 63, 63, 63, 62,
				63, 63, 63, 62, 63, 63,
				62, 63, 62, 62, 62, 62,
				63, 63, 62, 63, 63, 63,
				62, 62, 63, 63, 63, 62,
				63, 62, 63, 62, 63, 63,
				63, 63, 63, 62, 62, 62,
				62, 62, 62, 63, 62, 63,
											 ], Critter._FRAME_RATE, true);
		botCritter.playAnim("sexy-misc");
	}

	public function botOrgasm(args:Array<Dynamic>)
	{
		botCritter.jizzStamp(facing == FlxDirectionFlags.LEFT ? 6 : -6, -3);

		stopSexyAnim(botCritter);
		botCritter._bodySprite.animation.add("sexy-misc", [
				47, 47, 47, 46, 46, 46,
				46, 47, 46, 46, 46, 47,
				46, 47, 46, 47, 47, 47,
				47, 47, 47, 47, 47, 46,
											 ], Critter._FRAME_RATE, true);
		botCritter._headSprite.animation.add("sexy-misc", [
				63, 62, 63, 63, 63, 62,
				63, 63, 63, 62, 63, 63,
				63, 54, 63, 55, 55, 54,
				55, 55, 54, 55, 54, 55,
				54, 54, 55, 54, 55, 55,
				55, 54, 55, 54, 55, 54,
				54, 54, 55, 55, 55, 54,
				55, 55, 54, 55, 54, 55,
				55, 55, 54, 55, 54, 55,
				54, 54, 55, 54, 55, 55,
				55, 54, 55, 54, 55, 54,
				54, 54, 55, 55, 55, 54,
				55, 55, 54, 55, 54, 55,
											 ], Critter._FRAME_RATE, false);
		botCritter.playAnim("sexy-misc");
	}

	public function topStop(args:Array<Dynamic>)
	{
		stopSexyAnim(topCritter);
		topCritter.setFrontBodySpriteOffset(7);
		topCritter._bodySprite.animation.add("sexy-misc", [
				43, 42, 42, 43, 42, 43,
				43, 43, 43, 42, 43, 42,
				43, 42, 42, 42, 42, 42,
				43, 43, 43, 42, 42, 43,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.add("sexy-misc", [
				58, 59, 59, 58, 59, 59,
				58, 58, 58, 58, 58, 58,
				59, 58, 58, 59, 59, 59,
				59, 59, 58, 59, 58, 59,
											 ], Critter._FRAME_RATE, true);
		topCritter._frontBodySprite.animation.add("sexy-misc", [
					44, 44,
				], Critter._FRAME_RATE, true);
		topCritter.playAnim("sexy-misc");
	}

	public function botWaggle(args:Array<Dynamic>)
	{
		botCritter._bodySprite.facing = facing;

		stopSexyAnim(botCritter);
		botCritter._bodySprite.animation.add("sexy-misc", [
				54, 55, 54, 55, 54, 55,
											 ], Critter._FRAME_RATE, true);
		botCritter._headSprite.animation.add("sexy-misc", [
				72, 72, 73, 72, 72, 73,
				72, 72, 72, 73, 72, 73,
				73, 72, 72, 73, 73, 72,
				73, 72, 72, 73, 73, 73,
											 ], Critter._FRAME_RATE, true);
		botCritter.playAnim("sexy-misc");
	}

	public function botWait(args:Array<Dynamic>)
	{
		stopSexyAnim(botCritter);
		botCritter._bodySprite.animation.add("sexy-misc", [
				47, 46, 46, 47, 47, 47,
				46, 46, 47, 46, 46, 46,
				47, 47, 46, 46, 46, 47,
				47, 46, 46, 47, 47, 47,
											 ], Critter._FRAME_RATE, true);
		botCritter._headSprite.animation.add("sexy-misc", [
				73, 72, 72, 73, 73, 72,
				73, 72, 72, 73, 73, 73,
				72, 72, 73, 72, 72, 73,
				72, 72, 72, 73, 72, 73,
											 ], Critter._FRAME_RATE, true);
		botCritter.playAnim("sexy-misc");
	}

	public function topDone(args:Array<Dynamic>)
	{
		done(topCritter);
	}

	public function topDoneForNow(args:Array<Dynamic>)
	{
		stopSexyAnim(topCritter);
		topCritter.runTo(botCritter._bodySprite.x + (facing == FlxDirectionFlags.LEFT ? 24 : -24), botCritter._bodySprite.y + 6, SexyAnims.stayImmobile);
	}

	public function botDoneForNow(args:Array<Dynamic>)
	{
		stopSexyAnim(botCritter);
		botCritter.playAnim("sexy-idle");
	}

	public function botDone(args:Array<Dynamic>)
	{
		done(botCritter);
	}

	public function runIntoPositionAndPokeSnout(args:Array<Dynamic>):Void
	{
		topCritter.runTo(jumpTarget.x, jumpTarget.y, critterPokeSnout);
	}

	public function runIntoPositionAndRim(args:Array<Dynamic>):Void
	{
		topCritter.runTo(jumpTarget.x, jumpTarget.y, critterStartRim);
	}

	public function runToJump(args:Array<Dynamic>):Void
	{
		topCritter.runTo(jumpSource.x, jumpSource.y, SexyAnims.stayImmobile);
	}

	public function jumpIntoPositionAndRim(args:Array<Dynamic>):Void
	{
		topCritter.jumpTo(jumpTarget.x, jumpTarget.y, 0, critterStartRim);
	}

	public function getExpectedJumpDuration():Float
	{
		return JUMP_DIST / topCritter._bodySprite._jumpSpeed;
	}

	public function getExpectedRunDuration():Float
	{
		return IdleAnims.getProjectedTime(topCritter, topCritter._soulSprite.getPosition(), topCritter._targetSprite.getPosition());
	}

	public function getExpectedRunToJumpDuration():Float
	{
		return IdleAnims.getProjectedTime(topCritter, topCritter._targetSprite.getPosition(), jumpSource);
	}
}