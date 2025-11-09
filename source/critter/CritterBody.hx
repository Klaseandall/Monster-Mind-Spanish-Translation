package critter;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDirectionFlags;
import kludge.BetterFlxRandom;

/**
 * A bug is made of a head and body sprite which animate separately.
 * CritterBody encompasses the sprites and logic for a bug's body.
 */
class CritterBody extends FlxSprite
{
	public static var DEFAULT_WALK_SPEED:Float = 130;
	public static var DEFAULT_JUMP_SPEED:Float = 130;
	public static var IDLE_FREQUENCY:Float = 100;
	private var _critter:Critter;
	public var _idleTimer:Float = FlxG.random.float(0, IDLE_FREQUENCY);
	public var _walkSpeed:Float = DEFAULT_WALK_SPEED;
	public var _jumpSpeed:Float = DEFAULT_JUMP_SPEED;
	public var movingPrefix:String = "run";
	// "true" when we start moving; "false" once we reach our destination
	public var moving:Bool = false;

	public function new(critter:Critter)
	{
		super();
		this._critter = critter;
		setFacingFlip(FlxDirectionFlags.LEFT, false, false);
		setFacingFlip(FlxDirectionFlags.RIGHT, true, false);
		facing = FlxG.random.getObject([FlxDirectionFlags.LEFT, FlxDirectionFlags.RIGHT]);
	}

	override public function update(elapsed:Float):Void
	{
		offset.set(14, _critter._bodySpriteOffset + _critter.z);
		if (_critter.shadow != null)
		{
			_critter.shadow.groundZ = _critter.groundZ;
		}

		var oldFrame:Int = animation.curAnim == null ? -1 : animation.curAnim.curFrame;

		super.update(elapsed);
		_critter._eventStack.update(elapsed);

		var dirVector:FlxPoint = FlxPoint.get(_critter._targetSprite.x - _critter._soulSprite.x, _critter._targetSprite.y - _critter._soulSprite.y);

		// seemingly redundant check, but it avoids a bug if elapsed is 0
		var moveSpeed:Float = _critter.isMidAir() ? _jumpSpeed : _walkSpeed;
		if (dirVector.length == 0 || dirVector.length < moveSpeed * elapsed)
		{
			dirVector.set(0, 0);
			_critter._soulSprite.x = _critter._targetSprite.x;
			_critter._soulSprite.y = _critter._targetSprite.y;
		}
		else {
			dirVector.length = moveSpeed;
			moving = true;
		}
		_critter._soulSprite.velocity.x = dirVector.x;
		_critter._soulSprite.velocity.y = dirVector.y;

		if (animation.name == "idle" && !_critter._eventStack._alive && isOnScreen() && Critter.IDLE_ENABLED)
		{
			_idleTimer -= elapsed;
			if (_idleTimer <= 0)
			{
				var map:Map<String,Float> = new Map<String,Float>();
				map["idle-itch0"] = 1;
				map["idle-itch1"] = 1;
				map["idle-shake"] = 1;
				map["idle-wobble"] = 1;

				map["idle-happy0"] = 0.1;
				map["idle-happy1"] = 0.1;
				map["idle-happy2"] = 0.1;

				map["idle-veryhappy0"] = 0.1;
				map["idle-veryhappy1"] = 0.1;
				map["idle-veryhappy2"] = 0.1;

				// disabling pokemon libido also disables sexy animations
				var sexyAnimationConstant:Float = [0, 0, 0.2, 0.4, 1.0, 2.3, 5.2, 12.0][PlayerData.pokemonLibido];
				if (PlayerData.sfw)
				{
					// sfw mode; disable sexy animations
					sexyAnimationConstant = 0;
				}
				map["sexy-jackoff"] = 0.05 * sexyAnimationConstant;
				map["sexy-jackoff-short"] = 0.03 * sexyAnimationConstant;
				map["sexy-jackoff-long"] = 0.02 * sexyAnimationConstant;
				map["sexy-jackoff-dry"] = 0.01 * sexyAnimationConstant;

				// "complex" animations move a critter around; they're not suitable if they're in a box
				var annoyingAnimationConstant:Float = [0, 0, 0.25, 0.5, 1.0, 1.95, 3.10, 4.5][PlayerData.pegActivity];
				if (_critter._targetSprite.immovable || _critter.idleMove == false)
				{
					annoyingAnimationConstant = 0;
				}
				map["complex-figure8"] = 0.35 * annoyingAnimationConstant;
				map["complex-incomplete-figure8"] = 0.35 * annoyingAnimationConstant;
				map["complex-amble"] = 0.35 * annoyingAnimationConstant;
				map["complex-chase-tail"] = 0.35 * annoyingAnimationConstant;
				map["complex-leave-and-return"] = 0.35 * annoyingAnimationConstant;
				map["complex-hop"] = 0.08 * annoyingAnimationConstant;

				map["idle-sleep"] = 0.2;
				map["idle-nap"] = 0.2;
				if (PlayerData.pegActivity == 7)
				{
					map["idle-sleep"] = 0.0002;
					map["idle-nap"] = 0.0002;
					map["idle-jittery0"] = 1.3;
					map["idle-jittery1"] = 2.7;
					map["idle-vomit"] = 0.5;
				} if (PlayerData.pegActivity == 6)
				{
					map["idle-sleep"] = 0.002;
					map["idle-nap"] = 0.002;
					map["idle-jittery0"] = 1.2;
					map["idle-jittery1"] = 1.3;
					map["idle-vomit"] = 0.1;
				}
				else if (PlayerData.pegActivity == 5)
				{
					map["idle-sleep"] = 0.02;
					map["idle-nap"] = 0.02;
					map["idle-jittery0"] = 1;
					map["idle-jittery1"] = 0.5;
				}
				else if (PlayerData.pegActivity == 4)
				{
					// default
				}
				else if (PlayerData.pegActivity == 3)
				{
					map["idle-sleep"] = 0.5;
					map["idle-nap"] = 0.5;
					map["idle-yawn0"] = 1.3;
					map["idle-yawn1"] = 0.7;
				}
				else if (PlayerData.pegActivity == 2)
				{
					map["idle-sleep"] = 1;
					map["idle-nap"] = 1;
					map["idle-yawn0"] = 1.5;
					map["idle-yawn1"] = 1.5;
					if (PlayerData.isPlayerDoingStuff())
					{
						/*
						 * Bugs will start passing out -- but, only if the
						 * player's actually using the mouse. Without this
						 * check, the game got sort of depressing if the player
						 * stepped away for a 30 minute break
						 */
						map["idle-outcold0"] = 0.3;
					}
				}
				else if (PlayerData.pegActivity == 1)
				{
					map["idle-sleep"] = 2;
					map["idle-nap"] = 2;
					map["idle-yawn0"] = 3.4;
					map["idle-yawn1"] = 1.6;
					if (PlayerData.isPlayerDoingStuff())
					{
						map["idle-outcold0"] = 1.5;
					}
				}

				_critter.playAnim(BetterFlxRandom.getObjectWithMap(map), true);
			}
		}

		if (animation.finished)
		{
			if (animation.name.substr(0, 5) == "sexy-")
			{
				_critter.setImmovable(_critter.wasImmovableBeforeSexyAnim);
			}
			if (animation.name.substr(0, 5) == "grab-")
			{
				animation.play("grab");
			}
			else
			{
				animation.play("idle");
				_critter._headSprite.animation.play("idle");
				_critter.resetFrontBodySprite();
			}
		}

		if (animation.name == "cube" || animation.name == "grab")
		{
			// don't run if we're immobile
		}
		else if (_critter.outCold && !_critter.isMidAir())
		{
			// don't run if we're out cold... unless we're airborne, maybe someone's tossing a corpse
		}
		else {
			// maybe we should run?
			if (animation.curAnim != null && (animation.curAnim.curFrame != oldFrame || animation.curAnim.numFrames == 1 || _critter.isMidAir()))
			{
				// update graphics...
				var oldPosition:FlxPoint = getPosition();
				setPosition(_critter._soulSprite.x, _critter._soulSprite.y);
				var movementDir:FlxPoint;
				if (_critter.isMidAir())
				{
					movementDir = FlxPoint.get(_critter._targetSprite.x - oldPosition.x, _critter._targetSprite.y - oldPosition.y);
				}
				else
				{
					movementDir = FlxPoint.get(x - oldPosition.x, y - oldPosition.y);
				}
				if (movementDir.length > 1)
				{
					// moving; assign moving animation
					if (!_critter.outCold)
					{
						assignMovingAnim(0, 0, movementDir.x, movementDir.y, null);
					}
				}
				else
				{
					// sitting still; assign idle animation
					if (animation.name.substr(0, 4) == "run-" || animation.name.substr(0, 5) == "jump-" || animation.name.substr(0, 7) == "tumble-")
					{
						// should become idle
						animation.play("idle");
						_critter._headSprite.animation.play("idle");
					}
				}
				// did we reach our destination?
				if (!moving)
				{
					// well; we already reached our destination before
				}
				else if (getPosition().distanceTo(_critter._targetSprite.getPosition()) >= 1)
				{
					// no; we're still too far away
				}
				else if (animation.name.substr(0, 4) == "run-" || animation.name.substr(0, 5) == "jump-" || animation.name.substr(0, 7) == "tumble-"
						 || animation.name.substr(0, 7) == "idle")
				{
					moving = false;
					_critter.reachedDestination();

					if (!exists) return; // reaching a destination can kill us; return to avoid NPEs
				}
			}
		}

		if (animation.name == "grab")
		{
			facing = FlxDirectionFlags.LEFT;
		}

		_critter._headSprite.moveHead();
		_critter._frontBodySprite.x = x;
		_critter._frontBodySprite.y = y + _critter._frontBodySpriteOffset;
		_critter._frontBodySprite.offset.y = _critter._bodySpriteOffset + _critter._frontBodySpriteOffset + _critter.z;
	}

	public function assignMovingAnim(oldX:Float, oldY:Float, newX:Float, newY:Float, prefix:String):Void
	{
		if (prefix != null)
		{
			this.movingPrefix = prefix;
		}
		// should run
		var dir:String;
		if (newY >= oldY)
		{
			if (newX == 0 || Math.abs((newY - oldY) / (newX - oldX)) > 2)
			{
				dir = "s";
			}
			else
			{
				dir = "sw";
			}
		}
		else {
			if (newX == 0 || Math.abs((newY - oldY) / (newX - oldX)) > 2)
			{
				dir = "n";
			}
			else {
				dir = "nw";
			}
		}
		var animName:String = movingPrefix + "-" + dir;
		animation.play(animName, animName != animation.name);
		_critter._headSprite.animation.play(animName);
		_critter.resetFrontBodySprite();

		if (newX > oldX)
		{
			facing = FlxDirectionFlags.RIGHT;
		}
		else if (newX < oldX)
		{
			facing = FlxDirectionFlags.LEFT;
		}
		_critter._headSprite.facing = facing;
	}

	override public function destroy():Void
	{
		super.destroy();

		_critter = null;
		movingPrefix = null;
	}
}