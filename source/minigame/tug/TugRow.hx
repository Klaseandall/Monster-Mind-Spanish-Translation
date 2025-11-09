package minigame.tug;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import minigame.tug.TugGameState.isTugAnim;
import minigame.tug.TugGameState.isLeftTeam;
import critter.Critter;
import flixel.FlxG;

/**
 * Graphics and logic for a row in the tug-of-war minigame. This includes both
 * tents, bugs on both teams, rope and sign in that row, as well as state
 * information about whether the row's winner has been decided or not
 */
class TugRow implements IFlxDestroyable
{
	private var tugGameState:TugGameState;
	public var y:Float = 0;
	public var rowReward:Int = 0;

	public var row:Int = 0;

	// how far left/right are the different rows? are they moving?
	public var rowDecided:RowResult = Undecided;
	public var rowDecidedLeft:Int = 0;
	public var rowDecidedRight:Int = 0;
	public var tugPosition:Float = 0; // 0: center
	public var tugVelocity:Float = 0;
	public var oldTugVelocity:Float = 0;

	public var decideRowTimer:Float = -1;

	// which objects/sprites make up the row
	public var leftCritters:Array<Critter> = []; // leftCritters[0] = innermost critter in left tent
	public var rightCritters:Array<Critter> = [];
	public var rowCritters:Array<Critter> = []; // rowCritters is the union of leftCritters and rightCritters
	public var tugChest:Chest;
	public var chestTargetX:Float = 0;

	public var rope:Rope;

	public var leftTent:Tent;
	public var rightTent:Tent;
	public var sign:FlxSprite;

	public function new(tugGameState:TugGameState, row:Int, rowCount:Int, rowReward:Int)
	{
		this.rowReward = rowReward;
		this.tugGameState = tugGameState;
		this.row = row;

		y = (FlxG.height / (rowCount + 1.3)) * (0.8 + row);

		// create chest
		tugChest = tugGameState.addChest();
		tugChest._chestSprite.animation.frameIndex = 2;
		tugChest._chestSprite.x = FlxG.width / 2 - 18;
		tugChest._chestSprite.y = y;

		tugChest.destroyAfterPay = false;
		tugChest.increasePlayerCash = false;
		tugChest.setReward(rowReward);
		tugGameState._shadowGroup.makeShadow(tugChest._chestSprite);

		rope = new Rope(this);
		rope.x = 0;
		rope.y = y - 1;
		tugGameState.addRope(rope);

		createSign();

		leftTent = addTent(true);
		rightTent = addTent(false);
	}

	public function destroy():Void
	{
		if (tugGameState != null)
		{
			if (tugGameState._chests != null)
			{
				tugGameState._chests.remove(tugChest);
			}
			if (tugGameState._shadowGroup != null)
			{
				tugGameState._shadowGroup._extraShadows.remove(leftTent.tentShadow);
				tugGameState._shadowGroup._extraShadows.remove(rightTent.tentShadow);
			}
			if (tugGameState._midSprites != null)
			{
				tugGameState.removeRope(rope);
			}
		}

		FlxDestroyUtil.destroy(tugChest);
		FlxDestroyUtil.destroy(rope);
		FlxDestroyUtil.destroy(leftTent);
		FlxDestroyUtil.destroy(rightTent);
		FlxDestroyUtil.destroy(sign);
	}

	private function createSign():Void
	{
		sign = new FlxSprite();
		sign.y = y - 12;
		sign.makeGraphic(50, 50, FlxColor.TRANSPARENT, true);
		sign.offset.y = 38;
		sign.height = 11;

		// stamp appropriate sign graphic
		var signStamp:FlxSprite = new FlxSprite();
		signStamp.loadGraphic(AssetPaths.tug_signs__png, true, 50, 50);
		if (rowReward >= 200)
		{
			signStamp.animation.frameIndex = 3;
			sign.width = 48;
			sign.offset.x = 1;
		}
		else if (rowReward >= 120)
		{
			signStamp.animation.frameIndex = 2;
			sign.width = 42;
			sign.offset.x = 4;
		}
		else if (rowReward >= 35)
		{
			signStamp.animation.frameIndex = 1;
			sign.width = 36;
			sign.offset.x = 7;
		}
		else {
			signStamp.animation.frameIndex = 0;
			sign.width = 30;
			sign.offset.x = 10;
		}
		sign.x = FlxG.width / 2 - sign.width / 2 + (row % 2 == 0 ? 16 : -16);
		sign.stamp(signStamp, 0, 0);

		// stamp appropriate sign text
		var text:FlxText = new FlxText(0, 0, sign.width, Std.string(rowReward));
		text.alignment = "center";
		if (signStamp.animation.frameIndex == 3)
		{
			// big sign
			text.setFormat(AssetPaths.just_sayin__otf, 22);
			text.color = 0xfffaf7f0;
			text.y = 7;
		}
		else if (signStamp.animation.frameIndex == 2)
		{
			// medium sign
			text.setFormat(AssetPaths.just_sayin__otf, 19);
			text.color = 0xffd85e5a;
			text.y = 14;
		}
		else if (signStamp.animation.frameIndex == 1)
		{
			// small sign
			text.setFormat(AssetPaths.just_sayin__otf, 16);
			text.color = 0xff7171a8;
			text.y = 20;
		}
		else if (signStamp.animation.frameIndex == 0)
		{
			// tiny sign
			text.setFormat(AssetPaths.just_sayin__otf, 13);
			text.color = 0xff7171a8;
			text.y = 26;
		}

		sign.stamp(text, Std.int(sign.offset.x), Std.int(text.y));
		tugGameState._midSprites.add(sign);
		tugGameState._shadowGroup.makeShadow(sign);
	}

	public function update(elapsed:Float):Void
	{
		if (decideRowTimer >= 0)
		{
			decideRowTimer -= elapsed;

			// are the critters all in position for the row to be decided?
			var allDone:Bool = true;
			for (critter in rowCritters)
			{
				if (!isTugAnim(critter))
				{
					if (critter != tugGameState.finalCritter)
					{
						allDone = false;
					}
				}
			}

			if (allDone)
			{
				decideRowTimer = 0;
			}

			if (decideRowTimer <= 0 && !isRowDecided())
			{
				decideRowTimer = -1;
				rowDecidedLeft = leftCritters.length;
				rowDecidedRight = rightCritters.length;
				if (rowDecidedLeft > rowDecidedRight)
				{
					// left critters win
					rowDecided = LeftWins;
					tugVelocity = -120;
				}
				else if (rowDecidedRight > rowDecidedLeft)
				{
					// right critters win
					rowDecided = RightWins;
					tugVelocity = 120;
				}
				else
				{
					// tie
					rowDecided = Tie;
					tugVelocity = 0;
				}

				if (rowDecided == LeftWins || rowDecided == RightWins)
				{
					var winningCritters:Array<Critter> = rowDecided == LeftWins ? leftCritters : rightCritters;
					var losingCritters:Array<Critter> = rowDecided == LeftWins ? rightCritters : leftCritters;

					for (critter in winningCritters)
					{
						if (isTugAnim(critter))
						{
							critter.playAnim("tug-good");
						}
					}
					for (critter in losingCritters)
					{
						if (isTugAnim(critter))
						{
							critter.playAnim("tug-vbad");
							if (!tugGameState.model.isInTent(critter))
							{
								tugGameState._eventStack.addEvent({time:tugGameState._eventStack._time + 0.5, callback:tugGameState.eventLeapFromRope, args:[critter, false]});
							}
						}
						else
						{
							tugGameState.eventRunIntoTent(critter);
						}
					}
					chestTargetX = (rowDecided == LeftWins ? 170 : 562) + FlxG.random.float( -15, 15);
				}
				else if (rowDecided == Tie)
				{
					for (critters in [leftCritters, rightCritters])
					{
						var eventTime:Float = tugGameState._eventStack._time + 3 + FlxG.random.float(0, 0.5);
						var i:Int = critters.length - 1;
						while (i >= 0)
						{
							tugGameState._eventStack.addEvent({time:eventTime, callback:eventUnassignAndRunHome, args:[critters[i]]});
							eventTime += FlxG.random.float(0.3, 0.8);
							i--;
						}
					}
				}
			}
		}

		if (rowDecided == LeftWins || rowDecided == RightWins)
		{
			// row has been decided, and not as a tie; don't manipulate it
		}
		else {
			if (tugPosition >= 35 && tugVelocity > 0 || tugPosition <= -35 && tugVelocity < 0)
			{
				// can't tug past 35, unless it's a strong tug
				if (Math.abs(tugVelocity) > 15)
				{
					// strong tug
				}
				else
				{
					tugVelocity = 0;
				}
			}

			// if we're past 35, we need to reset chest closer to center...
			if (tugPosition >= 35 && tugVelocity >= 0 && tugVelocity <= 15)
			{
				tugVelocity = FlxG.random.getObject([ -3, -5, -8]);
			}
			else if (tugPosition <= -35 && tugVelocity <= 0 && tugVelocity >= -15)
			{
				tugVelocity = FlxG.random.getObject([3, 5, 8]);
			}

			if (tugPosition >= 50 && tugVelocity > 0 || tugPosition <= -50 && tugVelocity < 0)
			{
				// can't tug past 50, no matter what
				tugVelocity = 0;
			}
		}

		tugPosition += tugVelocity * elapsed;

		if (rowDecided == LeftWins || rowDecided == RightWins)
		{
			var winningCritters:Array<Critter> = rowDecided == LeftWins ? leftCritters : rightCritters;
			var losingCritters:Array<Critter> = rowDecided == LeftWins ? rightCritters : leftCritters;

			var outermostTentedIndex:Int = -1;
			for (i in 0...winningCritters.length)
			{
				if (tugGameState.model.isInTent(winningCritters[i]))
				{
					outermostTentedIndex = i;
				}
			}

			if (outermostTentedIndex != -1)
			{
				if (outermostTentedIndex == winningCritters.length - 1 || Math.abs(winningCritters[outermostTentedIndex + 1]._bodySprite.x - winningCritters[outermostTentedIndex]._bodySprite.x) > TugGameState.CRITTER_HORIZONTAL_SPACING)
				{
					// remove them from the tent...
					tugGameState.model.setInTent(winningCritters[outermostTentedIndex], false);
				}
			}
			else
			{
				// all winning critters out of tent; pull the chest
				tugChest._chestSprite.x += tugVelocity * elapsed;

				var innermostTentedIndex:Int = -1;
				for (i in 0...losingCritters.length)
				{
					if (tugGameState.model.isInTent(losingCritters[i]))
					{
						innermostTentedIndex = i;
						break;
					}
				}

				if (innermostTentedIndex != -1)
				{
					if (innermostTentedIndex == 0 || Math.abs(losingCritters[innermostTentedIndex - 1]._bodySprite.x - losingCritters[innermostTentedIndex]._bodySprite.x) > TugGameState.CRITTER_HORIZONTAL_SPACING)
					{
						// remove them from the tent
						tugGameState.model.setInTent(losingCritters[innermostTentedIndex], false);
					}
				}

				if ((rowDecided == LeftWins && tugChest._chestSprite.x < 170 || rowDecided == RightWins && tugChest._chestSprite.x > 562) && tugVelocity != 0)
				{
					tugVelocity = 0;

					for (critters in [leftCritters, rightCritters])
					{
						var eventTime:Float = tugGameState._eventStack._time + FlxG.random.float(0, 0.3);
						var i:Int = critters.length - 1;
						while (i >= 0)
						{
							tugGameState._eventStack.addEvent({time:eventTime, callback:eventUnassignAndRunHome, args:[critters[i]]});
							eventTime += FlxG.random.float(0, 0.3);
							i--;
						}
					}

					tugGameState._eventStack.addEvent({time:tugGameState._eventStack._time + 1.2, callback:eventOpenChest});
				}
			}

			for (j in 0...rowCritters.length)
			{
				var critter:Critter = rowCritters[j];
				if (tugGameState.model.isInTent(critter))
				{
					// don't update position; critter is in tent
				}
				else if (!TugGameState.isTugAnim(critter))
				{
					// don't update position; critter isn't tugging
				}
				else
				{
					critter.setPosition(critter._bodySprite.x + tugVelocity * elapsed, critter._bodySprite.y);
				}
			}
		}
		else {
			for (j in 0...rowCritters.length)
			{
				var critter:Critter = rowCritters[j];
				if (tugGameState.model.isInTent(critter))
				{
					// don't update position; critter is in tent
				}
				else if (!TugGameState.isTugAnim(critter))
				{
					// don't update position; critter isn't tugging
				}
				else
				{
					critter.setPosition(critter._bodySprite.x + tugVelocity * elapsed, critter._bodySprite.y);
				}
			}
			tugChest._chestSprite.x += tugVelocity * elapsed;
		}

		if (isRowDecided())
		{
			// row has been decided; don't re-pose critters
		}
		else {
			if (oldTugVelocity < 0 && tugVelocity >= 0
			|| oldTugVelocity == 0 && tugVelocity != 0
			|| oldTugVelocity > 0 && tugVelocity <= 0)
			{
				if (Math.abs(tugVelocity) > 15)
				{
					// hard tug; critters should change pose immediately
					for (critter in rowCritters)
					{
						updateTugPose(critter);
					}
				}
				else
				{
					// critters should change pose soon
					for (critter in rowCritters)
					{
						tugGameState._eventStack.addEvent({time:tugGameState._eventStack._time + FlxG.random.float(0, 0.5), callback:eventUpdateTugPose, args:[critter]});
					}
				}
			}
		}

		oldTugVelocity = tugVelocity;
	}

	function eventOpenChest(args:Array<Dynamic>)
	{
		tugChest.pay(tugGameState._hud);
		tugGameState.emitGems(tugChest);
	}

	function eventUnassignAndRunHome(args:Array<Dynamic>)
	{
		var critter:Critter = args[0];
		tugGameState.unassignFromRow(critter, false);
		critter.permanentlyImmovable = false;
		tugGameState.runHome(critter);
	}

	function eventUpdateTugPose(args:Array<Dynamic>)
	{
		var critter:Critter = args[0];
		updateTugPose(critter);
	}

	function updateTugPose(critter:Critter):Void
	{
		if (!isTugAnim(critter))
		{
			// critter isn't tugging; don't change his pose
			return;
		}
		if (tugGameState.model.isInTent(critter))
		{
			// critter is in a tent; don't worry about pose
			return;
		}
		if (isRowDecided())
		{
			// row has been decided; we'll explicitly set the poses elsewhere
			return;
		}

		// >0: critter is winning tug. <0: critter is losing tug
		var goodVelocity:Float = isLeftTeam(critter) ? -tugVelocity : tugVelocity;

		if (goodVelocity > 15 && getAlliedRowCritters(critter).indexOf(critter) != 0)
		{
			critter.playAnim("tug-vgood");
		}
		else if (goodVelocity > 0)
		{
			critter.playAnim("tug-good");
		}
		else if (goodVelocity == 0)
		{
			critter.playAnim(FlxG.random.getObject(["tug-good", "tug-bad"]));
		}
		else if (goodVelocity >= -15)
		{
			critter.playAnim("tug-bad");
		}
		else {
			critter.playAnim("tug-vbad");
		}
	}

	public inline function getAlliedRowCritters(critter:Critter):Array<Critter>
	{
		return isLeftTeam(critter) ? leftCritters : rightCritters;
	}

	public function decideRowSoon(maxTime:Float)
	{
		decideRowTimer = maxTime;
	}

	public function isRowDecided()
	{
		return rowDecided != Undecided;
	}

	private function addTent(leftTeam:Bool)
	{
		var tentX:Float = leftTeam ? 200 : 408;
		var tentY:Float = this.y - 50;
		var colorIndex:Int = tugGameState.tentColors[row];
		var flipX:Bool = !leftTeam;

		var tent:Tent = new Tent(tentX, tentY, colorIndex, flipX);
		tugGameState._backSprites.add(tent.tentFloorSprite);
		tugGameState._midSprites.add(tent.tentFrontSprite);
		tugGameState._midSprites.add(tent.tentBackSprite);
		tugGameState._shadowGroup._extraShadows.push(tent.tentShadow);
		tugGameState._hud.add(tent.tentWhite);
		return tent;
	}
}

enum RowResult
{
	LeftWins;
	RightWins;
	Tie;
	Undecided;
}