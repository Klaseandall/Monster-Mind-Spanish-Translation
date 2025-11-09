package critter;
import critter.Critter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.util.FlxDestroyUtil;
import kludge.BetterFlxRandom;
import puzzle.PuzzleState;

/**
 * The bug which runs out during a puzzle and gives the player a random chest.
 *
 * This controls logic to decide when he should run out, where he should run
 * to, and logic for carrying/dropping a chest.
 */
class RewardCritter extends Critter
{
	private var _puzzleState:PuzzleState;
	public var _rewardTimer:Float = 0;
	private var _antsyTimer:Float = FlxG.random.float(2, 6);
	private var _timeBetweenRewards = 150;
	private var _triedToPayAllChests:Bool = false;

	public function new(puzzleState:PuzzleState)
	{
		super(FlxG.random.int( -40 + 100, FlxG.width - 100), -70, puzzleState._backdrop);
		this._puzzleState = puzzleState;
		setColor(Critter.CRITTER_COLORS[FlxG.random.int(0, _puzzleState._puzzle._colorCount - 1)]);
		// if he idles, he can do crazy things like die and stay offscreen forever
		neverIdle();
		_rewardTimer = [
						   PlayerData.Difficulty.Easy => 45,
						   PlayerData.Difficulty._3Peg => 75,
						   PlayerData.Difficulty._4Peg => 105,
						   PlayerData.Difficulty._5Peg => 135,
						   PlayerData.Difficulty._7Peg => 165
					   ][PlayerData.difficulty];
	}

	public function update(elapsed:Float)
	{
		if (_targetSprite.y > -70 && _targetSprite.y < FlxG.height + 100 && _puzzleState.getCarriedChest(this) == null)
		{
			goAway();
		}
		if (_puzzleState._gameState == 200 && FlxMath.distanceBetween(_soulSprite, _targetSprite) < 1 && _puzzleState.getCarriedChest(this) == null)
		{
			_rewardTimer -= elapsed;
			if (_rewardTimer < 0)
			{
				_puzzleState.addAllowedHint();
				var rewardQuantity:Int = FlxG.random.getObject([0, 1, 2], [4, 2, 1]); // 0: one 1: half 2: all

				var carriedChest:Chest = _puzzleState.addChest();
				if (rewardQuantity == 0)
				{
					carriedChest.setReward(popReward(1));
				}
				else if (rewardQuantity == 1)
				{
					carriedChest.setReward(popReward(Std.int(Math.ceil(PlayerData.critterBonus.length / 2))));
				}
				else
				{
					carriedChest.setReward(popReward(PlayerData.critterBonus.length));
				}
				carriedChest._critter = this;
				// update position and animation frame to match critter
				carriedChest.update(elapsed);
			}
		}
		if (_puzzleState._gameState == 200 && FlxMath.distanceBetween(_soulSprite, _targetSprite) < 1 && _puzzleState.getCarriedChest(this) != null)
		{
			if (_rewardTimer < 0)
			{
				_antsyTimer -= elapsed;
				if (_antsyTimer < 0)
				{
					comeToCenter();
					_antsyTimer = FlxG.random.float(2, 6);
				}
			}
		}
		if (_puzzleState._gameState >= 300 && FlxMath.distanceBetween(_soulSprite, _targetSprite) < 1)
		{
			var runningOnscreen:Bool = _targetSprite.y >= 0 && _targetSprite.y < FlxG.height;
			if (runningOnscreen)
			{
				// reached the "dropping off a chest" spot
				var carriedChest:Chest = _puzzleState.getCarriedChest(this);
				if (carriedChest != null)
				{
					dropChest(carriedChest);
					goAway();
				}
			}
			else
			{
				if (!_triedToPayAllChests)
				{
					_triedToPayAllChests = true;
					_puzzleState.maybePayAllChests();
				}
			}
		}
	}

	/**
	 * Remove some $$$ from the player's critterBonus, so they can be put in a chest
	 */
	function popReward(count:Int)
	{
		var sum = 0;
		for (i in 0...count)
		{
			if (PlayerData.critterBonus.length > 0)
			{
				sum += PlayerData.critterBonus.splice(FlxG.random.int(0, PlayerData.critterBonus.length - 1), 1)[0];
			}
		}
		sum = Std.int(Math.max(sum, 5));
		// more than 1,000 at once is silly, and makes the money counter go nuts
		if (sum > 1000)
		{
			PlayerData.reimburseCritterBonus(sum - 1000);
			sum = 1000;
		}
		return sum;
	}

	public function comeToCenter():Void
	{
		if (!_bodySprite.isOnScreen())
		{
			changeColor();
		}
		_rewardTimer = Math.min(_rewardTimer, 0);
		_antsyTimer = Math.min(_antsyTimer, 0);
		runTo(FlxG.random.int(256 + 4, 512 - 4 - 40), FlxG.random.int(30 + 24 + 24 * _puzzleState._puzzle._pegCount, 380 - 16));
	}

	public function immediatelySpawnIdleReward():Void
	{
		_rewardTimer = Math.min(_rewardTimer, 0);
		_antsyTimer = Math.min(_antsyTimer, 0);
	}

	public function goAway():Void
	{
		if (_rewardTimer < 0)
		{
			_rewardTimer = 150;
		}
		var y:Float = 0;
		if (_targetSprite.y > FlxG.height / 2 || _puzzleState._gameState == 300)
		{
			y = FlxG.height + 100;
		}
		else {
			y = -70;
		}
		runTo(FlxG.random.int( -40 + 100, FlxG.width - 100), y);
	}

	/**
	 * If you thought it was a whole bunch of bugs taking turns bringing you
	 * chests, surprise! It's just a very talented chameleon bug
	 *
	 * You should think yourself lucky Abra never included these chameleon bugs
	 * in puzzles...
	 */
	private function changeColor():Void
	{
		setColor(Critter.CRITTER_COLORS[FlxG.random.int(0, _puzzleState._puzzle._colorCount - 1)]);
	}

	public function dropChest(chest:Chest):Void
	{
		chest.dropChest();
		_puzzleState._shadowGroup.makeShadow(chest._chestSprite);
	}

	/**
	 * Reimburse the player for a chest they didn't open
	 */
	public function reimburseChestReward():Void
	{
		var chest:Chest = _puzzleState.getCarriedChest(this);
		if (_puzzleState._gameState == 200 && chest != null)
		{
			PlayerData.reimburseCritterBonus(chest._reward);
		}
	}
}