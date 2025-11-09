package critter;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxDirectionFlags;

/**
 * An animation where a bug blows the other one
 */
class SexyBlowJob extends SexyCritterAnim
{
	private var topCritter:Critter; // the critter doing the rimming
	private var botCritter:Critter; // the critter being rimmed
	public var facing:Int = 0; // is the critter receiving the blowjob facing right or left?
	private var jumpTarget:FlxPoint; // where the bottom needs to be, to blow the top
	private var isTopHandOnHead:Bool = false;

	/**
	 * @param	topCritter receives the blowjob
	 * @param	botCritter give the blowjob
	 * @param	facing the direction the topCritter is facing
	 */
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
		facing = topCritter._bodySprite.x > botCritter._bodySprite.x ? FlxDirectionFlags.LEFT : FlxDirectionFlags.RIGHT;

		jumpTarget = FlxPoint.get(topCritter._targetSprite.x + (facing == FlxDirectionFlags.LEFT ? -19 : 19), topCritter._targetSprite.y + 14);
	}

	public function botSitUp(args:Array<Dynamic>)
	{
		if (isTopHandOnHead)
		{
			topHandOffHead(null);
		}
		stopSexyAnim(botCritter);
		botCritter._headSprite.animation.add("sexy-misc", [
				118, 119, 118, 119, 118, 119,
				118, 118, 118, 118, 118, 119,
				119, 119, 119, 118, 118, 118,
				119, 119, 119, 119, 118, 119,
				118, 118, 119, 119, 119, 118,
				118, 119, 118, 119, 119, 119,
											 ], Critter._FRAME_RATE, true);
		botCritter._bodySprite.animation.add("sexy-misc", [
				108, 107, 107, 107, 108, 108,
				107, 108, 107, 108, 108, 108,
				108, 107, 107, 108, 108, 108,
				107, 108, 108, 107, 108, 107,
				108, 108, 108, 107, 108, 107,
				107, 107, 107, 107, 107, 108,
											 ], Critter._FRAME_RATE, true);
		botCritter.playAnim("sexy-misc");
	}

	public function topHandOnHead(args:Array<Dynamic>)
	{
		botCritter._headSprite.animation.add("sexy-misc", [
				117, 117, 114, 117, 116, 114,
				115, 115, 116, 115, 116, 116,
				114, 117, 117, 114, 116, 116,
				117, 115, 116, 114, 115, 115,
				117, 114, 117, 117, 114, 116,
				114, 114, 114, 115, 116, 116,
											 ], Critter._FRAME_RATE, true);
		botCritter._headSprite.animation.play("sexy-misc");

		topCritter.setFrontBodySpriteOffset(15);
		topCritter._frontBodySprite.animation.add("sexy-misc", [
					100, 100,  99, 100, 100,  99,
					99,  99, 100,  99, 100, 100,
					99, 100, 100,  99, 100, 100,
					100,  99, 100,  99,  99,  99,
					100,  99, 100, 100,  99, 100,
					99,  99,  99,  99, 100, 100,
				], Critter._FRAME_RATE, true);
		topCritter._frontBodySprite.visible = true;
		topCritter._frontBodySprite.animation.play("sexy-misc");
		isTopHandOnHead = true;
	}

	public function topHandPatsHead(args:Array<Dynamic>)
	{
		topCritter.setFrontBodySpriteOffset(15);
		topCritter._frontBodySprite.animation.add("sexy-misc", [
					100, 100,  99,  99, 100, 100,
					99,  99, 100, 100,  99,  99,
				], Critter._FRAME_RATE, false);
		topCritter._frontBodySprite.visible = true;
		topCritter._frontBodySprite.animation.play("sexy-misc");
		isTopHandOnHead = true;
	}

	public function topHandOnHeadSwallow(args:Array<Dynamic>)
	{
		stopSexyAnim(botCritter);
		botCritter._headSprite.animation.add("sexy-misc", [
				115, 115, 115, 114, 115, 114,
				114, 115, 114, 114, 114, 114,
				114, 115, 114, 114, 115, 114,
				114, 115, 114, 114, 115, 115,
											 ], Critter._FRAME_RATE, true);
		botCritter._bodySprite.animation.add("sexy-misc", [
				104, 105, 104, 105, 105, 104,
				104, 104, 105, 104, 106, 105,
				105, 106, 104, 105, 105, 106,
				106, 104, 104, 105, 104, 105,
				106, 105, 106, 106, 106, 106,
				106, 106, 104, 104, 105, 105,
											 ], Critter._FRAME_RATE, true);
		botCritter.playAnim("sexy-misc");

		topCritter.setFrontBodySpriteOffset(15);
		topCritter._frontBodySprite.animation.add("sexy-misc", [
					99, 99, 99, 99, 99, 99,
				], Critter._FRAME_RATE, true);
		topCritter._frontBodySprite.animation.play("sexy-misc");
		isTopHandOnHead = true;
	}

	public function topHandOffHead(args:Array<Dynamic>)
	{
		topCritter._frontBodySprite.visible = false;
		isTopHandOnHead = false;
	}

	public function topEyesClosed(args:Array<Dynamic>)
	{
		topCritter._headSprite.animation.add("sexy-misc", [
				51, 51, 50, 51, 51, 50,
				50, 51, 51, 51, 50, 50,
				51, 50, 50, 51, 50, 50,
				50, 51, 51, 50, 51, 51,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.play("sexy-misc");
	}

	public function topEyesHalfOpen(args:Array<Dynamic>)
	{
		topCritter._headSprite.animation.add("sexy-misc", [
				49, 48, 48, 49, 48, 48,
				48, 49, 49, 48, 49, 49,
				48, 49, 49, 49, 48, 48,
				49, 49, 48, 49, 49, 49,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.play("sexy-misc");
	}

	public function topEyesOpen(args:Array<Dynamic>)
	{
		topCritter._headSprite.animation.add("sexy-misc", [
				52, 51, 51, 52, 51, 51,
				51, 52, 52, 51, 52, 52,
				51, 52, 52, 52, 51, 51,
				52, 52, 51, 52, 52, 52,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.play("sexy-misc");
	}

	public function botSwallow(args:Array<Dynamic>)
	{
		stopSexyAnim(botCritter);
		botCritter._headSprite.animation.add("sexy-misc", [
				115, 115, 115, 114, 115, 114,
				114, 115, 114, 114, 114, 114,
				114, 115, 114, 114, 115, 114,
				114, 115, 114, 114, 115, 115,
											 ], Critter._FRAME_RATE, true);
		botCritter._bodySprite.animation.add("sexy-misc", [
				104, 105, 104, 105, 105, 104,
				104, 104, 105, 104, 106, 105,
				105, 106, 104, 105, 105, 106,
				106, 104, 104, 105, 104, 105,
				106, 105, 106, 106, 106, 106,
				106, 106, 104, 104, 105, 105,
											 ], Critter._FRAME_RATE, true);
		botCritter.playAnim("sexy-misc");

		if (isTopHandOnHead)
		{
			topCritter.setFrontBodySpriteOffset(15);
			topCritter._frontBodySprite.animation.add("sexy-misc", [
						99, 99, 99, 99, 99, 99,
					], Critter._FRAME_RATE, true);
			topCritter._frontBodySprite.animation.play("sexy-misc");
		}
	}

	public function topJerkSelf(args:Array<Dynamic>)
	{
		stopSexyAnim(topCritter);
		topCritter._bodySprite.facing = facing;
		topCritter._headSprite.animation.add("sexy-misc", [
				48, 49, 49, 48, 48, 49,
				48, 48, 49, 48, 48, 48,
				48, 49, 49, 48, 48, 49,
				49, 48, 49, 49, 49, 49,
				48, 49, 49, 49, 48, 48,
											 ], Critter._FRAME_RATE, true);
		if (topCritter.isMale())
		{
			topCritter._bodySprite.animation.add("sexy-misc", [
					32, 32, 32, 33, 33, 33,
					32, 32, 32, 33, 33, 33,
					32, 32, 32, 33, 33, 33,
					32, 32, 32, 33, 33, 33,
					32, 32, 33, 33, 32, 32,
												 ], Critter._FRAME_RATE, true);
		}
		else
		{
			topCritter._bodySprite.animation.add("sexy-misc", [
					32, 32, 32, 31, 31, 31,
					32, 32, 32, 31, 31, 31,
					32, 32, 32, 31, 31, 31,
					32, 32, 32, 31, 31, 31,
					32, 32, 31, 31, 32, 32,
												 ], Critter._FRAME_RATE, false);
		}
		topCritter.playAnim("sexy-misc");
	}

	public function topPoint(args:Array<Dynamic>)
	{
		stopSexyAnim(topCritter);
		topCritter._bodySprite.facing = facing;
		topCritter._bodySprite.animation.add("sexy-misc", [
				98, 97, 98, 97, 96, 98,
				97, 98, 96, 98, 97, 98,
				97, 98, 96, 97, 97, 96,
				97, 98, 96, 98, 98, 96,
				97, 98, 96, 97, 98, 98,
				96, 97, 97, 97, 96, 98,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.add("sexy-misc", [
				53, 53, 52, 53, 53, 52,
				52, 53, 53, 53, 52, 52,
				53, 52, 52, 53, 52, 52,
				52, 53, 53, 52, 53, 53,
				52, 53, 53, 53, 52, 52,
				53, 53, 52, 53, 53, 53,
											 ], Critter._FRAME_RATE, true);
		topCritter._frontBodySprite.animation.add("sexy-misc", [
					111, 111, 110, 110, 111, 110,
					111, 110, 111, 111, 110, 110,
					2, 2, 2, 2, 2, 2,
				], Critter._FRAME_RATE, false);
		topCritter.playAnim("sexy-misc");
	}

	public function topPointEyesHalfOpen(args:Array<Dynamic>)
	{
		stopSexyAnim(topCritter);
		topCritter._bodySprite.facing = facing;
		topCritter._bodySprite.animation.add("sexy-misc", [
				98, 97, 98, 97, 96, 98,
				97, 98, 96, 98, 97, 98,
				97, 98, 96, 97, 97, 96,
				97, 98, 96, 98, 98, 96,
				97, 98, 96, 97, 98, 98,
				96, 97, 97, 97, 96, 98,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.add("sexy-misc", [
				49, 48, 48, 49, 48, 48,
				48, 49, 49, 48, 49, 49,
				48, 49, 49, 49, 48, 48,
				49, 49, 48, 49, 49, 49,
				48, 49, 49, 48, 49, 49,
											 ], Critter._FRAME_RATE, true);
		topCritter._frontBodySprite.animation.add("sexy-misc", [
					111, 111, 110, 110, 111, 110,
					111, 110, 111, 111, 110, 110,
					2, 2, 2, 2, 2, 2,
				], Critter._FRAME_RATE, false);
		topCritter.playAnim("sexy-misc");
	}

	/**
	 * Bottom critter takes a break and jerks top off for a little while
	 */
	public function botJerkOff(args:Array<Dynamic>)
	{
		stopSexyAnim(botCritter);
		if (topCritter.isMale())
		{
			botCritter._bodySprite.animation.add("sexy-misc", [
					114, 114, 112, 114, 114, 112,
					112, 114, 112, 114, 112, 114,
					112, 114, 114, 114, 112, 114,
					112, 112, 112, 112, 114, 114,
					114, 112, 114, 114, 114, 114,
					112, 114, 114, 114, 114, 112,
												 ], Critter._FRAME_RATE, true);
		}
		else
		{
			botCritter._bodySprite.animation.add("sexy-misc", [
					113, 113, 112, 113, 113, 112,
					112, 113, 112, 113, 112, 113,
					112, 113, 113, 113, 112, 113,
					112, 112, 112, 112, 113, 113,
					113, 112, 113, 113, 113, 113,
					112, 113, 113, 113, 113, 112,
												 ], Critter._FRAME_RATE, true);
		}
		botCritter._headSprite.animation.add("sexy-misc", [
				118, 118, 118, 118, 118, 119,
				119, 119, 119, 118, 118, 118,
				119, 119, 119, 119, 118, 119,
				118, 118, 119, 119, 119, 118,
				118, 119, 118, 119, 119, 119,
				118, 119, 118, 119, 118, 119,
											 ], Critter._FRAME_RATE, true);
		botCritter.playAnim("sexy-misc");
	}

	public function botBj(args:Array<Dynamic>)
	{
		stopSexyAnim(botCritter);
		botCritter._bodySprite.animation.add("sexy-misc", [
				104, 105, 104, 105, 105, 104,
				104, 104, 105, 104, 106, 105,
				105, 106, 104, 105, 105, 106,
				106, 104, 104, 105, 104, 105,
				106, 105, 106, 106, 106, 106,
				106, 106, 104, 104, 105, 105,
											 ], Critter._FRAME_RATE, true);
		botCritter._headSprite.animation.add("sexy-misc", [
				114, 114, 115, 116, 114, 116,
				117, 116, 114, 115, 114, 115,
				117, 114, 114, 115, 115, 114,
				116, 116, 114, 114, 116, 116,
				114, 116, 116, 114, 117, 116,
				114, 116, 114, 115, 115, 117,
											 ], Critter._FRAME_RATE, true);
		botCritter.playAnim("sexy-misc");

		if (isTopHandOnHead)
		{
			topCritter.setFrontBodySpriteOffset(15);
			topCritter._frontBodySprite.animation.add("sexy-misc", [
						99,  99,  99, 100,  99, 100,
						100, 100,  99,  99,  99,  99,
						100,  99,  99,  99,  99,  99,
						100, 100,  99,  99, 100, 100,
						99, 100, 100,  99, 100, 100,
						99, 100,  99,  99,  99, 100,
					], Critter._FRAME_RATE, true);
			topCritter._frontBodySprite.animation.play("sexy-misc");
		}
	}

	public function topOrgasm(args:Array<Dynamic>)
	{
		stopSexyAnim(topCritter);
		topCritter.setFrontBodySpriteOffset(4);
		topHandOffHead(null);
		topCritter._bodySprite.animation.add("sexy-misc", [
				96, 97, 98, 98, 98, 96,
				96, 97, 98, 96, 98, 96,
				96, 97, 98, 97, 98, 96,
				97, 98, 97, 96, 97, 98,
				98, 98, 97, 98, 97, 98,
				98, 96, 98, 97, 96, 98,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.add("sexy-misc", [
				51, 51, 50, 51, 51, 50,
				50, 51, 51, 51, 50, 50,
				51, 50, 50, 51, 50, 50,
				50, 51, 51, 50, 51, 51,
											 ], Critter._FRAME_RATE, true);
		if (topCritter.isMale())
		{
			topCritter._frontBodySprite.animation.add("sexy-misc", [
						34, 35, 36, 37, 2, 2,
						34, 35, 36, 37, 2, 2,
						2, 2, 2, 2, 2, 2,
					], Critter._FRAME_RATE, false);
		}
		else
		{
			topCritter._frontBodySprite.animation.add("sexy-misc", [
						30, 38, 39, 2, 2, 30,
						38, 39, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
					], Critter._FRAME_RATE, false);
		}
		topCritter.playAnim("sexy-misc");

		if (topCritter.isMale())
		{
			topCritter._eventStack.addEvent({time:topCritter._eventStack._time + 0.4, callback:topCritter.eventJizzStamp, args:[ 28 * (topCritter._bodySprite.facing == FlxDirectionFlags.LEFT ? -1 : 1), 6]});
		}
		else
		{
			topCritter._eventStack.addEvent({time:topCritter._eventStack._time + 0.1, callback:topCritter.eventJizzStamp, args:[ 6 * (topCritter._bodySprite.facing == FlxDirectionFlags.LEFT ? -1 : 1), 4]});
		}
	}

	public function topSitBack(args:Array<Dynamic>)
	{
		topCritter._bodySprite.facing = facing;

		stopSexyAnim(topCritter);
		topCritter.setFrontBodySpriteOffset(15);
		topCritter._bodySprite.animation.add("sexy-misc", [
				96, 97, 98, 98, 98, 96,
				96, 97, 98, 96, 98, 96,
				96, 97, 98, 97, 98, 96,
				97, 98, 97, 97, 96, 98,
				98, 98, 97, 98, 97, 98,
				97, 98, 96, 98, 96, 98,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.add("sexy-misc", [
				48, 49, 49, 48, 48, 49,
				48, 48, 49, 48, 48, 48,
				48, 49, 49, 48, 48, 49,
				49, 48, 49, 49, 49, 49,
				48, 49, 49, 49, 48, 48,
											 ], Critter._FRAME_RATE, true);
		topCritter.playAnim("sexy-misc");
	}

	public function startBj(args:Array<Dynamic>)
	{
		topCritter._bodySprite.facing = facing;
		botCritter._bodySprite.facing = (facing == FlxDirectionFlags.LEFT ? FlxDirectionFlags.RIGHT : FlxDirectionFlags.LEFT);

		botCritter.setPosition(topCritter._bodySprite.x + (facing == FlxDirectionFlags.LEFT ? -19 : 19), topCritter._targetSprite.y + 14);

		botBj(null);
		topSitBack(null);
	}

	public function critterStartBj(critter:Critter)
	{
		startBj(null);
	}

	public function critterStartJerk(critter:Critter)
	{
		topCritter._bodySprite.facing = facing;
		botCritter._bodySprite.facing = (facing == FlxDirectionFlags.LEFT ? FlxDirectionFlags.RIGHT : FlxDirectionFlags.LEFT);

		stopSexyAnim(botCritter);
		if (topCritter.isMale())
		{
			botCritter._bodySprite.animation.add("sexy-misc", [
					114, 114, 112, 114, 114, 112,
					112, 114, 112, 114, 112, 114,
					112, 114, 114, 114, 112, 114,
					112, 112, 112, 112, 114, 114,
					114, 112, 114, 114, 114, 114,
					112, 114, 114, 114, 114, 112,
												 ], Critter._FRAME_RATE, true);
		}
		else
		{
			botCritter._bodySprite.animation.add("sexy-misc", [
					113, 113, 112, 113, 113, 112,
					112, 113, 112, 113, 112, 113,
					112, 113, 113, 113, 112, 113,
					112, 112, 112, 112, 113, 113,
					113, 112, 113, 113, 113, 113,
					112, 113, 113, 113, 113, 112,
												 ], Critter._FRAME_RATE, true);
		}
		botCritter._headSprite.animation.add("sexy-misc", [
				118, 118, 118, 118, 118, 119,
				119, 119, 119, 118, 118, 118,
				119, 119, 119, 119, 118, 119,
				118, 118, 119, 119, 119, 118,
				118, 119, 118, 119, 119, 119,
				118, 119, 118, 119, 118, 119,
											 ], Critter._FRAME_RATE, true);
		botCritter.playAnim("sexy-misc");

		stopSexyAnim(topCritter);
		topCritter.setFrontBodySpriteOffset(15);
		topCritter._bodySprite.animation.add("sexy-misc", [
				96, 97, 98, 98, 98, 96,
				96, 97, 98, 96, 98, 96,
				96, 97, 98, 97, 98, 96,
				97, 98, 97, 97, 96, 98,
				98, 98, 97, 98, 97, 98,
				97, 98, 96, 98, 96, 98,
											 ], Critter._FRAME_RATE, true);
		topCritter._headSprite.animation.add("sexy-misc", [
				48, 49, 49, 48, 48, 49,
				48, 48, 49, 48, 48, 48,
				48, 49, 49, 48, 48, 49,
				49, 48, 49, 49, 49, 49,
				48, 49, 49, 49, 48, 48,
											 ], Critter._FRAME_RATE, true);
		topCritter.playAnim("sexy-misc");
	}

	public function botRunIntoPositionAndBlow(args:Array<Dynamic>):Void
	{
		botCritter.runTo(jumpTarget.x, jumpTarget.y, critterStartBj);
	}

	public function getExpectedTopRunDuration():Float
	{
		return IdleAnims.getProjectedTime(topCritter, topCritter._soulSprite.getPosition(), botCritter._targetSprite.getPosition());
	}

	public function getExpectedBotRunDuration():Float
	{
		return IdleAnims.getProjectedTime(botCritter, botCritter._soulSprite.getPosition(), topCritter._targetSprite.getPosition());
	}

	public function topDone(args:Array<Dynamic>)
	{
		done(topCritter);
	}

	public function botDone(args:Array<Dynamic>)
	{
		done(botCritter);
	}

	public function topDoneForNow(args:Array<Dynamic>)
	{
		stopSexyAnim(topCritter);
		topCritter.playAnim("sexy-idle");
	}

	public function botDoneForNow(args:Array<Dynamic>)
	{
		stopSexyAnim(botCritter);
		botCritter.playAnim("sexy-idle");
	}

	public function botRunIntoPositionAndJerk(args:Array<Dynamic>):Void
	{
		botCritter.runTo(jumpTarget.x, jumpTarget.y, critterStartJerk);
	}

	public function critterTopSitBack(critter:Critter):Void
	{
		topSitBack(null);
	}

	public function topRunIntoPositionAndSitBack(args:Array<Dynamic>)
	{
		var otherTarget:FlxPoint = FlxPoint.get(botCritter._targetSprite.x - (facing == FlxDirectionFlags.LEFT ? -19 : 19), botCritter._targetSprite.y - 14);
		topCritter.runTo(otherTarget.x, otherTarget.y, critterTopSitBack);
	}

	public function botNotice(args:Array<Dynamic>)
	{
		botCritter._bodySprite.facing = topCritter._bodySprite.x > botCritter._bodySprite.x ? FlxDirectionFlags.LEFT : FlxDirectionFlags.RIGHT;

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

	public function botDoneForNowRunAway(args:Array<Dynamic>)
	{
		stopSexyAnim(botCritter);
		botCritter.runTo(botCritter._soulSprite.x + (facing == FlxDirectionFlags.RIGHT ? 1 : -1) * 40, botCritter._soulSprite.y + 5);
	}

	public function botDoneForNowRunToSwap(args:Array<Dynamic>)
	{
		stopSexyAnim(botCritter);
		botCritter.runTo(botCritter._soulSprite.x + (facing == FlxDirectionFlags.RIGHT ? 19 : -19), botCritter._soulSprite.y - 14);
	}

	public function botReturnAndBj(args:Array<Dynamic>)
	{
		refresh(null);
		botCritter.runTo(jumpTarget.x, jumpTarget.y, critterStartBj);
	}

	public function botDoneRunAway(args:Array<Dynamic>)
	{
		done(botCritter);
		botCritter.runTo(botCritter._soulSprite.x + (facing == FlxDirectionFlags.RIGHT ? 1 : -1) * FlxG.random.float(20, 60), botCritter._soulSprite.y + FlxG.random.float(-10, 10));
	}

	public function botDoneRunFarAway(args:Array<Dynamic>)
	{
		done(botCritter);
		botCritter.runTo(botCritter._soulSprite.x + (facing == FlxDirectionFlags.RIGHT ? 1 : -1) * FlxG.random.float(80, 140), botCritter._soulSprite.y + FlxG.random.float(-10, 10));
	}

	public function topDoneRunFarAway(args:Array<Dynamic>)
	{
		done(topCritter);
		topCritter.runTo(topCritter._soulSprite.x + (facing == FlxDirectionFlags.RIGHT ? -1 : 1) * FlxG.random.float(80, 140), topCritter._soulSprite.y + FlxG.random.float(-10, 10));
	}
}