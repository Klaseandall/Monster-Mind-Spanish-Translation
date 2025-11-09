package;
import critter.Critter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDirectionFlags;
import kludge.BetterFlxRandom;
import kludge.LateFadingFlxParticle;

/**
 * Graphics and logic for the chests which appear during puzzles and minigames
 */
class Chest implements IFlxDestroyable
{
	public var _chestSprite:FlxSprite;
	public var _paySprite:FlxSprite;
	public var _payGroup:FlxGroup;
	public var _critter:Critter;
	public var _reward:Int = 200;
	public var _payed:Bool = false;
	public var _minigameCoin:Bool = false;
	public var z:Float = 0;
	public var shadow:Shadow;
	// 0:Wood; 1:Silver; 2:Gold; 3:Diamond
	public var chestType:Int = 0;
	public var destroyAfterPay:Bool = true;
	public var increasePlayerCash:Bool = true;

	public function new(X:Float=0, Y:Float=0)
	{
		_chestSprite = new FlxSprite(X, Y);
		_chestSprite.loadGraphic(AssetPaths.chests__png, true, 64, 64);
		_chestSprite.setSize(36, 10);
		_chestSprite.offset.set(14, 39);
		_chestSprite.setFacingFlip(FlxDirectionFlags.LEFT, false, false);
		_chestSprite.setFacingFlip(FlxDirectionFlags.RIGHT, true, false);
		_chestSprite.facing = FlxG.random.getObject([FlxDirectionFlags.LEFT, FlxDirectionFlags.RIGHT]);
	}

	public function setReward(Reward:Int, ?UpdateChestType:Bool=true):Void
	{
		this._reward = Reward;
		if (UpdateChestType)
		{
			chestType = 0;
			if (_reward >= 200)
			{
				chestType = 1;
			}
			if (_reward >= 500)
			{
				chestType = 2;
			}
			if (_reward >= 1000)
			{
				chestType = 3;
			}
		}
	}

	public function pay(PayGroup:FlxGroup)
	{
		if (_payed)
		{
			return;
		}
		if (_chestSprite == null)
		{
			/*
			 * I've added a check to short-circuit the pay logic if this chest
			 * was already destroyed.
			 *
			 * I've never seen this behavior myself, but it could account for
			 * crashes people were seeing when the game was first released.
			 */
			return;
		}
		_payed = true;
		this._payGroup = PayGroup;
		_chestSprite.animation.frameIndex += 4;
		if (_minigameCoin)
		{
			SoundStackingFix.play(AssetPaths.chest_open_00cb__mp3, 0.5);
			SoundStackingFix.play(AssetPaths.minigame_coin_005f__mp3);
			_paySprite = new FlxSprite(_chestSprite.x + _chestSprite.width / 2, _chestSprite.y + _chestSprite.height / 2 - 8);
			_paySprite.loadGraphic(AssetPaths.minigame_coin__png, true, 13, 24);
			_paySprite.x -= _paySprite.width / 2;
			_paySprite.y -= _paySprite.height / 2;
			_paySprite.animation.add("play", [0, 1, 2, 3], 6);
			_paySprite.animation.play("play");
			FlxTween.tween(_paySprite, { y:_paySprite.y - 49 }, 1.6, { ease:FlxEase.circOut, onComplete:finishPay });
		}
		else
		{
			SoundStackingFix.play(AssetPaths.chest_open_00cb__mp3);
			var text:FlxText = new FlxText(_chestSprite.x - 18, _chestSprite.y - 21, 36 + 36, Std.string(_reward), 16);
			_paySprite = text;
			text.alignment = "center";
			FlxTween.tween(_paySprite, { y:_paySprite.y - 29 }, 0.8, { ease:FlxEase.circOut, onComplete:finishPay });
		}
		PayGroup.add(_paySprite);
	}

	public function update(elapsed:Float):Void
	{
		if (_chestSprite == null)
		{
			return;
		}
		if (_critter != null)
		{
			if (_critter._bodySprite.animation.name == "run-sw" || _critter._bodySprite.animation.name == "jump-sw")
			{
				_chestSprite.animation.frameIndex = 0;
			}
			else if (_critter._bodySprite.animation.name == "run-nw" || _critter._bodySprite.animation.name == "jump-nw")
			{
				_chestSprite.animation.frameIndex = 1;
			}
			else if (_critter._bodySprite.animation.name == "run-n" || _critter._bodySprite.animation.name == "jump-n")
			{
				_chestSprite.animation.frameIndex = 3;
			}
			else
			{
				// idle? facing forward?
				_chestSprite.animation.frameIndex = 2;
			}
			_chestSprite.facing = _critter._bodySprite.facing;
			_chestSprite.x = _critter._bodySprite.x;
			_chestSprite.y = _critter._bodySprite.y + 1;
			z = _critter.z + 17;
			if (shadow != null) shadow.groundZ = _critter.groundZ;
		}
		_chestSprite.animation.frameIndex = _chestSprite.animation.frameIndex % 8 + chestType * 8;
		_chestSprite.offset.y = 39 + z;
	}

	public function finishPay(_):Void
	{
		FlxTween.tween(_paySprite, { alpha:0 }, 0.2, { onComplete:finishPay2 });
	}

	public function finishPay2(_):Void
	{
		_paySprite = FlxDestroyUtil.destroy(_paySprite);
		if (!_minigameCoin)
		{
			if (increasePlayerCash)
			{
				PlayerData.cash += _reward;
			}
		}
		if (destroyAfterPay)
		{
			FlxFlicker.flicker(_chestSprite, 0.5, 0.04, false, false, finishPay3);
		}
	}

	public function finishPay3(_):Void
	{
		_chestSprite = FlxDestroyUtil.destroy(_chestSprite);
	}

	public function destroy()
	{
		_chestSprite = FlxDestroyUtil.destroy(_chestSprite);
		_paySprite = FlxDestroyUtil.destroy(_paySprite);
	}

	public function dropChest()
	{
		if (_critter != null)
		{
			_critter = null;
			z -= 17;
		}
	}
}