package critter;
import critter.Critter;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxDirectionFlags;

/**
 * An animation where a bug fucks another bug doggy-style
 */
class SexyDoggy extends SexyCritterAnim
{
	public var facing:Int = 0;
	private var topCritter:Critter; // critter doing the fucking
	private var botCritter:Critter; // critter being fucked
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

		jumpTarget = FlxPoint.get(botCritter._targetSprite.x + (facing == FlxDirectionFlags.LEFT ? 10 : -10), botCritter._targetSprite.y - 12);

		var dx:Float = topCritter._bodySprite.x - jumpTarget.x;
		var dy:Float = topCritter._bodySprite.y - jumpTarget.y;
		if (dx == 0 && dy == 0)
		{
			// avoid divide by zero
			dx = 2;
			dy = 1;
		}
		var ex:Float = SexyRimming.JUMP_DIST * dx / Math.sqrt(dx * dx + dy * dy);
		var ey:Float = SexyRimming.JUMP_DIST * dy / Math.sqrt(dx * dx + dy * dy);
		jumpSource = FlxPoint.get(botCritter._targetSprite.x + ex, botCritter._targetSprite.y + ey);
	}

	public function critterStartDoggy(critter:Critter)
	{
		startDoggy(null);
	}

	/*
	 * args[0]: if true, top repositions. otherwise, bottom repositions
	 */
	public function startDoggy(args:Array<Dynamic>)
	{
		topCritter._bodySprite.facing = facing;
		botCritter._bodySprite.facing = facing;

		var topShouldReposition:Bool = args == null ? false : args[0];
		if (topShouldReposition)
		{
			topCritter.setPosition(botCritter._bodySprite.x + (facing == FlxDirectionFlags.LEFT ? 10 : -10), botCritter._bodySprite.y - 12);
		}
		else
		{
			botCritter.setPosition(topCritter._bodySprite.x + (facing == FlxDirectionFlags.LEFT ? -10 : 10), topCritter._bodySprite.y + 12);
		}

		stopSexyAnim(topCritter);
		topCritter.setFrontBodySpriteOffset(13);
		topCritter.setBodySpriteOffset(43);
		topCritter._bodySprite.animation.add("sexy-misc", [
				56, 56, 57, 56, 57, 57,
				57, 56, 56, 56, 57, 56,
				57, 57, 57, 56, 56, 56,
				56, 56, 56, 56, 57, 56,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.add("sexy-misc", [
				81, 81, 81, 81, 81, 80,
				80, 81, 80, 80, 80, 81,
				81, 80, 81, 80, 81, 81,
				81, 81, 80, 80, 81, 80,
											 ], Critter._FRAME_RATE, true);
		topCritter._frontBodySprite.animation.add("sexy-misc", [
					51, 51, 51, 51, 51, 51,
					50, 50, 50, 50, 50, 51,
					51, 51, 50, 50, 51, 50,
					50, 50, 50, 50, 50, 50,
				], Critter._FRAME_RATE, true);
		topCritter.playAnim("sexy-misc");

		stopSexyAnim(botCritter);
		botCritter._bodySprite.animation.add("sexy-misc", [
				53, 52, 52, 52, 53, 53,
				52, 53, 53, 52, 53, 53,
				53, 52, 52, 53, 53, 53,
				53, 53, 52, 52, 52, 52,
											 ], Critter._FRAME_RATE, true);
		botCritter._headSprite.animation.add("sexy-misc", [
				72, 73, 73, 73, 73, 72,
				73, 72, 73, 73, 73, 72,
				72, 73, 73, 72, 73, 72,
				73, 73, 73, 72, 73, 73,
											 ], Critter._FRAME_RATE, true);
		botCritter.playAnim("sexy-misc");
	}

	/**
	 * args[0]: how many seconds it should take
	 */
	public function topPenetrate(args:Array<Dynamic>)
	{
		var bodyAnim:Array<Int> = [];
		var headAnim:Array<Int> = [];
		var frontBodyAnim:Array<Int> = [];
		while (bodyAnim.length < args[0] * 2)
		{
			bodyAnim.push(FlxG.random.getObject([58, 59]));
			headAnim.push(FlxG.random.getObject([84, 85]));
			frontBodyAnim.push(FlxG.random.getObject([50, 51]));
		}
		while (bodyAnim.length < args[0] * 4)
		{
			bodyAnim.push(FlxG.random.getObject([60, 61]));
			headAnim.push(FlxG.random.getObject([84, 85]));
			frontBodyAnim.push(FlxG.random.getObject([50, 51]));
		}
		for (i in 0...60)
		{
			bodyAnim.push(FlxG.random.getObject([62, 63]));
			headAnim.push(FlxG.random.getObject([82, 83]));
			frontBodyAnim.push(FlxG.random.getObject([50, 51]));
		}
		for (i in 0...6)
		{
			// restart the animation, just in case something strange happens
			bodyAnim.push(FlxG.random.getObject([60, 61]));
			headAnim.push(FlxG.random.getObject([84, 85]));
			frontBodyAnim.push(FlxG.random.getObject([50, 51]));
		}

		stopSexyAnim(topCritter);
		topCritter._bodySprite.animation.add("sexy-misc", bodyAnim, Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.add("sexy-misc", headAnim, Critter._FRAME_RATE, true);
		topCritter._frontBodySprite.animation.add("sexy-misc", frontBodyAnim, Critter._FRAME_RATE, true);
		topCritter.playAnim("sexy-misc");
	}

	/**
	 * args[0]: int: how many humps
	 * args[1]: int: how many seconds
	 * args[2]: bool: eyes closed?
	 * args[3]: bool: spanking?
	 */
	public function topHump(args:Array<Dynamic>)
	{
		var humpCount:Int = args[0];
		var humpSeconds:Int = args[1];
		var eyesClosed:Bool = args[2];
		var spanking:Bool = args[3];
		var spankFrame:Int = FlxG.random.int(0, 5);
		var targetFrameCount:Int = 0;

		var bodyAnim:Array<Int> = [];
		var headAnim:Array<Int> = [];
		var frontBodyAnim:Array<Int> = [];

		while (targetFrameCount < 60)
		{
			targetFrameCount += humpSeconds * 6;
		}

		while (bodyAnim.length < targetFrameCount)
		{
			var abc:Float = bodyAnim.length / 3 * (humpCount / humpSeconds) * Math.PI;
			var frame:Int = 0;
			var pow:Float = 1;
			if (Math.sin(abc) < 0)
			{
				// pulling out (gentle)
				pow = 0.5;
			}
			else
			{
				// inserting (forceful)
				pow = 2;
			}
			var def:Float = Math.cos(abc) < 0 ? -Math.pow( -Math.cos(abc), pow) : Math.pow(Math.cos(abc), pow);
			frame = Math.round(def * 1.5 + 1.5);
			if (frame == 0)
			{
				bodyAnim.push(FlxG.random.getObject([56, 57]));
			}
			else if (frame == 1)
			{
				bodyAnim.push(FlxG.random.getObject([58, 59]));
			}
			else if (frame == 2)
			{
				bodyAnim.push(FlxG.random.getObject([60, 61]));
			}
			else
			{
				bodyAnim.push(FlxG.random.getObject([62, 63]));
			}
			headAnim.push(eyesClosed ? FlxG.random.getObject([84, 85]) : FlxG.random.getObject([82, 83]));
			frontBodyAnim.push(FlxG.random.getObject([50, 51]));
		}

		if (spanking)
		{
			// make bottom critter react...
			stopSexyAnim(botCritter);
			botCritter._bodySprite.animation.add("sexy-misc", [
					53, 53, 52, 52, 52, 52,
					52, 53, 53, 52, 53, 53,
					53, 52, 52, 53, 53, 53,
					53, 53, 52, 52, 52, 52,
												 ], Critter._FRAME_RATE, true);
			var botHeadAnim:Array<Int> = [
											 55, 54, 55, 54, 55, 54,
											 54, 54, 55, 55, 55, 54,
											 55, 55, 54, 55, 54, 55,
											 54, 54, 55, 54, 55, 55,
											 55, 54, 55, 54, 55, 54,
											 54, 54, 55, 55, 55, 54,
											 54, 54, 55, 55, 55, 54,
											 55, 55, 54, 55, 54, 55,
											 54, 54, 55, 54, 55, 55,
											 55, 54, 55, 54, 55, 54,
											 55, 54, 55, 54, 55, 54,
											 54, 54, 55, 55, 55, 54,
											 55, 55, 54, 55, 54, 55,
											 54, 54, 55, 54, 55, 55,
											 55, 54, 55, 54, 55, 54,
											 54, 54, 55, 55, 55, 54,
											 54, 54, 55, 55, 55, 54,
											 55, 55, 54, 55, 54, 55,
											 54, 54, 55, 54, 55, 55,
											 55, 54, 55, 54, 55, 54,
										 ];

			// add top critter animation frames
			frontBodyAnim[spankFrame] = 65;
			frontBodyAnim[spankFrame + 1] = 67;
			frontBodyAnim[spankFrame + 2] = 69;
			for (i in spankFrame + 1...spankFrame + 4)
			{
				botHeadAnim[i] = FlxG.random.getObject([62, 63]);
			}
			for (i in spankFrame...spankFrame + 6)
			{
				if (bodyAnim[i] == 56 || bodyAnim[i] == 57)
				{
					bodyAnim[i] = 64;
				}
				else if (bodyAnim[i] == 58 || bodyAnim[i] == 59)
				{
					bodyAnim[i] = 66;
				}
				else if (bodyAnim[i] == 60 || bodyAnim[i] == 61)
				{
					bodyAnim[i] = 68;
				}
				else if (bodyAnim[i] == 62 || bodyAnim[i] == 63)
				{
					bodyAnim[i] = 70;
				}
			}
			for (i in spankFrame + 3...spankFrame + 6)
			{
				frontBodyAnim[i] = FlxG.random.getObject([48, 49]);
			}
			botCritter._headSprite.animation.add("sexy-misc", botHeadAnim, Critter._FRAME_RATE, true);
			botCritter.playAnim("sexy-misc");
		}

		stopSexyAnim(topCritter);
		topCritter._bodySprite.animation.add("sexy-misc", bodyAnim, Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.add("sexy-misc", headAnim, Critter._FRAME_RATE, true);
		topCritter._frontBodySprite.animation.add("sexy-misc", frontBodyAnim, Critter._FRAME_RATE, true);
		topCritter.playAnim("sexy-misc");
	}

	public function botEyesOpen(args:Array<Dynamic>)
	{
		stopSexyAnim(botCritter);
		botCritter._bodySprite.animation.add("sexy-misc", [
				53, 52, 52, 52, 53, 53,
				52, 53, 53, 52, 53, 53,
				53, 52, 52, 53, 53, 53,
				53, 53, 52, 52, 52, 52,
											 ], Critter._FRAME_RATE, true);
		botCritter._headSprite.animation.add("sexy-misc", [
				55, 55, 54, 55, 54, 55,
				54, 54, 55, 54, 55, 55,
				55, 54, 55, 54, 55, 54,
				54, 54, 55, 55, 55, 54,
											 ], Critter._FRAME_RATE, true);
		botCritter.playAnim("sexy-misc");
	}

	public function botLookBack(args:Array<Dynamic>)
	{
		botCritter._bodySprite.facing = facing;
		stopSexyAnim(botCritter);
		botCritter._bodySprite.animation.add("sexy-misc", [
				53, 52, 52, 52, 53, 53,
				52, 53, 53, 52, 53, 53,
				53, 52, 52, 53, 53, 53,
				53, 53, 52, 52, 52, 52,
											 ], Critter._FRAME_RATE, true);
		botCritter._headSprite.animation.add("sexy-misc", [
				72, 73, 73, 73, 73, 72,
				73, 72, 73, 73, 73, 72,
				72, 73, 73, 72, 73, 72,
				73, 73, 73, 72, 73, 73,
											 ], Critter._FRAME_RATE, true);
		botCritter.playAnim("sexy-misc");
	}

	public function botEyesClosed(args:Array<Dynamic>)
	{
		stopSexyAnim(botCritter);
		botCritter._bodySprite.animation.add("sexy-misc", [
				53, 52, 52, 52, 53, 53,
				52, 53, 53, 52, 53, 53,
				53, 52, 52, 53, 53, 53,
				53, 53, 52, 52, 52, 52,
											 ], Critter._FRAME_RATE, true);
		botCritter._headSprite.animation.add("sexy-misc", [
				63, 62, 63, 63, 63, 62,
				63, 63, 63, 62, 63, 63,
				62, 63, 62, 62, 62, 62,
				63, 63, 62, 63, 63, 63,
											 ], Critter._FRAME_RATE, true);
		botCritter.playAnim("sexy-misc");
	}

	public function botOrgasm(args:Array<Dynamic>)
	{
		botCritter.jizzStamp(facing == FlxDirectionFlags.LEFT ? 3 : -3, -3);

		stopSexyAnim(botCritter);
		botCritter._bodySprite.animation.add("sexy-misc", [
				53, 52, 52, 52, 53, 53,
				52, 53, 53, 52, 53, 53,
				53, 52, 52, 53, 53, 53,
				53, 53, 52, 52, 52, 52,
											 ], Critter._FRAME_RATE, true);
		botCritter._headSprite.animation.add("sexy-misc", [
				63, 62, 63, 63, 63, 62,
				63, 63, 63, 62, 63, 63,
				62, 63, 62, 63, 62, 63,
				62, 62, 63, 62, 63, 63,
				63, 62, 55, 54, 55, 54,
				54, 54, 55, 55, 55, 54,
				55, 55, 54, 55, 54, 55,
				54, 54, 55, 54, 55, 55,
				55, 54, 55, 54, 55, 54,
				54, 54, 55, 55, 55, 54,
				54, 54, 55, 55, 55, 54,
				55, 55, 54, 55, 54, 55,
				54, 54, 55, 54, 55, 55,
				55, 54, 55, 54, 55, 54,
				54, 54, 55, 55, 55, 54,
											 ], Critter._FRAME_RATE, true);
		botCritter.playAnim("sexy-misc");
	}

	public function topOrgasm(args:Array<Dynamic>)
	{
		topCritter.jizzStamp(0, 3);

		stopSexyAnim(topCritter);
		topCritter._bodySprite.animation.add("sexy-misc", [
				62, 62, 63, 62, 63, 63,
				63, 62, 62, 62, 63, 62,
				63, 63, 63, 62, 62, 62,
				62, 62, 62, 62, 63, 62,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.add("sexy-misc", [
				84, 84, 84, 85, 85, 85,
				84, 85, 84, 84, 85, 84,
				84, 85, 84, 85, 85, 85,
				84, 84, 85, 85, 84, 85,
				85, 84, 85, 82, 83, 83,
				83, 82, 83, 83, 83, 82,
				82, 83, 83, 82, 83, 82,
				82, 82, 82, 83, 83, 83,
				82, 83, 82, 82, 83, 82,
				82, 83, 82, 83, 83, 83,
				82, 82, 83, 83, 82, 83,
				83, 82, 83, 83, 83, 82,
				83, 82, 83, 82, 83, 83,
				82, 83, 83, 83, 83, 82,
				82, 83, 82, 83, 82, 83,
				83, 82, 83, 83, 83, 83,
				82, 82, 83, 82, 82, 83,
				82, 82, 83, 82, 82, 82,
				83, 83, 83, 83, 82, 83,
				83, 83, 82, 82, 82, 82,
											 ], Critter._FRAME_RATE, true);
		topCritter._frontBodySprite.animation.add("sexy-misc", [
					51, 51, 51, 51, 51, 51,
					50, 50, 50, 50, 50, 51,
					51, 51, 50, 50, 51, 50,
					50, 50, 50, 50, 50, 50,
				], Critter._FRAME_RATE, true);
		topCritter.playAnim("sexy-misc");
	}

	public function topOrgasmPullOut(args:Array<Dynamic>)
	{
		topCritter.jizzStamp(0, 3);

		stopSexyAnim(topCritter);
		topCritter._bodySprite.animation.add("sexy-misc", [
				60, 58, 60, 62, 63, 62,
				62, 62, 63, 62, 63, 63,
				62, 62, 63, 62, 63, 63,
				63, 62, 62, 62, 63, 62,
				63, 63, 63, 62, 62, 62,
				62, 62, 62, 62, 63, 62,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.add("sexy-misc", [
				85, 84, 85, 84, 84, 84,
				84, 85, 84, 84, 85, 84,
				84, 85, 84, 85, 85, 85,
				84, 84, 85, 85, 84, 85,
				85, 84, 85, 85, 85, 85,
				83, 82, 83, 83, 83, 82,
				82, 83, 83, 82, 83, 82,
				82, 82, 82, 83, 83, 83,
				82, 83, 82, 82, 83, 82,
				82, 83, 82, 83, 83, 83,
				82, 82, 83, 83, 82, 83,
				83, 82, 83, 83, 83, 82,
				83, 82, 83, 82, 83, 83,
				82, 83, 83, 83, 83, 82,
				82, 83, 82, 83, 82, 83,
				83, 82, 83, 83, 83, 83,
				82, 82, 83, 82, 82, 83,
				82, 82, 83, 82, 82, 82,
				83, 83, 83, 83, 82, 83,
				83, 83, 82, 82, 82, 82,
											 ], Critter._FRAME_RATE, true);
		topCritter._frontBodySprite.animation.add("sexy-misc", [
					51, 51, 51, 72, 73, 74,
					75, 50, 50, 50, 72, 73,
					74, 75, 50, 50, 51, 50,
					50, 50, 50, 50, 50, 50,
					51, 51, 51, 51, 51, 51,
					50, 50, 50, 50, 50, 51,
					51, 51, 50, 50, 51, 50,
					50, 50, 50, 50, 50, 50,
					51, 51, 51, 51, 51, 51,
					50, 50, 50, 50, 50, 51,
					51, 51, 50, 50, 51, 50,
					50, 50, 50, 50, 50, 50,
					51, 51, 51, 51, 51, 51,
					50, 50, 50, 50, 50, 51,
					51, 51, 50, 50, 51, 50,
					50, 50, 50, 50, 50, 50,
					51, 51, 51, 51, 51, 51,
					50, 50, 50, 50, 50, 51,
					51, 51, 50, 50, 51, 50,
					50, 50, 50, 50, 50, 50,
				], Critter._FRAME_RATE, true);
		topCritter.playAnim("sexy-misc");
	}

	public function topAlmostDone(args:Array<Dynamic>)
	{
		stopSexyAnim(topCritter);
		topCritter._bodySprite.animation.add("sexy-misc", [
				62, 62, 63, 60, 61, 61,
				59, 58, 58, 56, 57, 56,
				56, 56, 57, 56, 57, 57,
				57, 56, 56, 56, 57, 56,
				57, 57, 57, 56, 56, 56,
				56, 56, 56, 56, 57, 56,
				56, 56, 57, 56, 57, 57,
				57, 56, 56, 56, 57, 56,
				57, 57, 57, 56, 56, 56,
				56, 56, 56, 56, 57, 56,
				56, 56, 57, 56, 57, 57,
				57, 56, 56, 56, 57, 56,
				57, 57, 57, 56, 56, 56,
				56, 56, 56, 56, 57, 56,
				56, 56, 57, 56, 57, 57,
				57, 56, 56, 56, 57, 56,
				57, 57, 57, 56, 56, 56,
				59, 58, 60, 51, 62, 62,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.add("sexy-misc", [
				81, 80, 80, 80, 80, 81,
				80, 81, 80, 80, 80, 81,
				81, 80, 80, 81, 80, 81,
				80, 80, 80, 81, 80, 80,
											 ], Critter._FRAME_RATE, true);
		topCritter._frontBodySprite.animation.add("sexy-misc", [
					51, 51, 51, 51, 51, 51,
					50, 50, 50, 50, 50, 51,
					51, 51, 50, 50, 51, 50,
					50, 50, 50, 50, 50, 50,
				], Critter._FRAME_RATE, true);
		topCritter.playAnim("sexy-misc");
	}

	public function topDone(args:Array<Dynamic>)
	{
		done(topCritter);
	}

	public function botDone(args:Array<Dynamic>)
	{
		done(botCritter);
	}

	public function runIntoPositionAndStartDoggy(args:Array<Dynamic>):Void
	{
		topCritter.runTo(jumpTarget.x, jumpTarget.y, critterStartDoggy);
	}

	public function jumpIntoPositionAndStartDoggy(args:Array<Dynamic>):Void
	{
		topCritter.jumpTo(jumpTarget.x, jumpTarget.y, 0, critterStartDoggy);
	}

	public function runToJump(args:Array<Dynamic>):Void
	{
		topCritter.runTo(jumpSource.x, jumpSource.y, SexyAnims.stayImmobile);
	}

	public function getExpectedRunToJumpDuration():Float
	{
		return IdleAnims.getProjectedTime(topCritter, topCritter._targetSprite.getPosition(), jumpSource);
	}

	public function rotateFromJumpTarget(degrees:Float, dist:Float):FlxPoint
	{
		var dx:Float = jumpTarget.x - botCritter._bodySprite.x;
		var dy:Float = jumpTarget.y - botCritter._bodySprite.y;
		if (dx == 0 && dy == 0)
		{
			// avoid divide by zero
			dx = 2;
			dy = 1;
		}
		var angleRadians:Float = Math.atan2(dy, dx);
		angleRadians += degrees * Math.PI / 180;
		var ex:Float = Math.cos(angleRadians) * dist + botCritter._bodySprite.x;
		var ey:Float = Math.sin(angleRadians) * dist + botCritter._bodySprite.y;
		return FlxPoint.get(ex, ey);
	}
}