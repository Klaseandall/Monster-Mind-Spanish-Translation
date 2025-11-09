package puzzle;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter.FlxEmitterMode;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.util.FlxDestroyUtil;
import poke.abra.AbraDialog;
import puzzle.BrainSyncPanel;

/**
 * BrainSyncPanel is a panel which shows human brain activity alongside Abra's
 * brain activity. It's used during the end-game "sync chances".
 */
class BrainSyncPanel extends FlxGroup
{
	/**
	 * Abra's "rank" decreases as they drink more. During the first sync chance
	 * they'll drink beer, and their rank drops from [100] to [60-80]. During the
	 * final sync chance they'll drink absinthe, and their rank drops from [50] to [0-30].
	 * 
	 * 0: before first puzzle
	 * 1: before second puzzle
	 * 2: before third puzzle
	 * 3: highest possible rank after third puzzle
	 * 4: lowest possible rank after third puzzle
	 */
	private static var ABRA_RANKS:Array<Array<Int>> = [
				[100, 85, 80, 80, 60], // beer; 0-1-1
				[100, 85, 70, 65, 45], // sake; 0-1-2
				[100, 70, 55, 50, 30], // soju; 0-2-3
				[75, 60, 45, 40, 20], // rum; 2-3-4
				[50, 40, 30, 30, 0], // absinthe; 3-4-4
			];

	private var playerRank:Int = 0;
	private var abraRank:Int = 0;
	public var leftHemisphere:LeftBrainHemisphere;
	public var rightHemisphere:RightBrainHemisphere;

	public function new(x:Float, y:Float)
	{
		super();

		var brainBg:FlxSprite = new FlxSprite(x, y, AssetPaths.brain_bg__png);
		add(brainBg);

		leftHemisphere = new LeftBrainHemisphere(x, y, new FlxRect(136 - 85, 38, 85, 110), AssetPaths.brain_clip_man__png);
		add(leftHemisphere.blobbyGroup);

		rightHemisphere = new RightBrainHemisphere(x, y, new FlxRect(136, 38, 85, 110), AssetPaths.brain_clip_abra__png, leftHemisphere);
		add(rightHemisphere.blobbyGroup);

		// prepopulate with some particles
		for (i in 0...30)
		{
			update(0.1);
		}
	}

	public function setLeftActivityPct(pct:Float)
	{
		leftHemisphere.activityPct = pct;
	}

	public function setRightActivityPct(pct:Float)
	{
		rightHemisphere.activityPct = pct;
	}

	public function setSyncPct(pct:Float)
	{
		rightHemisphere.syncPct = pct;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		leftHemisphere.update(elapsed);

		rightHemisphere.update(elapsed);
	}

	override public function destroy():Void
	{
		super.destroy();

		leftHemisphere = FlxDestroyUtil.destroy(leftHemisphere);
		rightHemisphere = FlxDestroyUtil.destroy(rightHemisphere);
	}

	public static function getLowestTargetIq():Int
	{
		var finalTrialCount:Int = Std.int(FlxMath.bound(AbraDialog.getFinalTrialCount(), 0, 4));

		return ABRA_RANKS[finalTrialCount][4];
	}

	public static function getHighestTargetIq():Int
	{
		var finalTrialCount:Int = Std.int(FlxMath.bound(AbraDialog.getFinalTrialCount(), 0, 4));

		return ABRA_RANKS[finalTrialCount][3];
	}

	public static function newInstance(puzzleState:PuzzleState):BrainSyncPanel
	{
		var panel:BrainSyncPanel = new BrainSyncPanel(248, -24);
		panel.refreshRankData(puzzleState);
		return panel;
	}

	public function refreshRankData(puzzleState:PuzzleState)
	{
		setPlayerRank(RankTracker.computeAggregateRank());

		var finalTrialCount:Int = Std.int(FlxMath.bound(AbraDialog.getFinalTrialCount(), 0, 4));
		var abraRank:Int = 0;
		if (puzzleState._gameState >= 300)
		{
			// after puzzle solved
			if (PlayerData.level == 2)
			{
				abraRank = FlxG.random.int(ABRA_RANKS[finalTrialCount][4], ABRA_RANKS[finalTrialCount][3]);
			}
			else
			{
				abraRank = ABRA_RANKS[finalTrialCount][PlayerData.level + 1];
			}
		}
		else
		{
			// before puzzle started
			abraRank = ABRA_RANKS[finalTrialCount][PlayerData.level];
		}
		setAbraRank(abraRank);
	}

	public function setPlayerRank(playerRank:Int)
	{
		this.playerRank = RankTracker.computeAggregateRank();
		setLeftActivityPct(FlxMath.bound(playerRank / 100, 0, 1.0));
		setSyncPct(FlxMath.bound(1.0 - (abraRank - playerRank) / 60, 0, 1.0));
	}

	public function setAbraRank(abraRank:Int)
	{
		this.abraRank = abraRank;
		setRightActivityPct(FlxMath.bound(Math.max(abraRank, playerRank) / 100, 0, 1.0));
		setSyncPct(FlxMath.bound(1.0 - (Math.max(abraRank, playerRank) - playerRank) / 60, 0, 1.0));
	}

	public function getPlayerRank():Int
	{
		return playerRank;
	}

	public function getAbraRank():Int
	{
		return abraRank;
	}

	public function isSuccessfulSync():Bool
	{
		return playerRank >= abraRank;
	}
}

class BrainHemisphere implements IFlxDestroyable
{
	private var x:Float = 0;
	private var y:Float = 0;
	public var activityPct:Float = 0;
	public var emitter:FlxTypedEmitter<GlowyParticle>;
	private var emitTimer:Float = 0;
	private var emitFrequency:Float = 1.6;
	public var blobbyGroup:BrainBlobbyGroup;
	private var glowyBounds:FlxRect;

	public function new(x:Float, y:Float, glowyBounds:FlxRect, clipGraphicAsset:String)
	{
		this.x = x;
		this.y = y;
		this.glowyBounds = glowyBounds;
		blobbyGroup = new BrainBlobbyGroup(x, y, FlxGraphic.fromAssetKey(clipGraphicAsset));
		emitter = new FlxTypedEmitter<GlowyParticle>(0, 0, 100);
		for (i in 0...emitter.maxSize)
		{
			var particle:GlowyParticle = new GlowyParticle();
			// these preblurred blobs were made by rendering a 5x5 white rectangle at 100% opacity, then gaussian blurring it in a 25 pixel radius
			particle.loadGraphic(AssetPaths.fuzzy_circle_25__png);
			particle.exists = false;
			emitter.add(particle);
		}

		emitter.angularVelocity.set(0);
		emitter.launchMode = FlxEmitterMode.CIRCLE;
		emitter.speed.set(5, 10, 0, 0);
		emitter.acceleration.set(0);
		emitter.lifespan.set(7.2);

		blobbyGroup.add(emitter);
	}

	public function destroy():Void
	{
		emitter = FlxDestroyUtil.destroy(emitter);
		blobbyGroup = FlxDestroyUtil.destroy(blobbyGroup);
	}

	public function update(elapsed:Float):Void
	{
		emitTimer -= elapsed;
		while (emitTimer <= 0)
		{
			emitTimer += emitFrequency;

			var baseX:Float = x + FlxG.random.float(glowyBounds.left, glowyBounds.right);
			var baseY:Float = y + FlxG.random.float(glowyBounds.top, glowyBounds.bottom);

			emitter.start(true, 0, 1);
			for (i in 0...5)
			{
				emitter.x = baseX + FlxG.random.float(-12, 12);
				emitter.y = baseY + FlxG.random.float(-12, 12);
				var particle:GlowyParticle = emitter.emitParticle();
				onEmit(particle);
			}
			emitter.emitting = false;
		}

		blobbyGroup._blobThreshold = Math.round(expScale(activityPct, 16, 4));
		blobbyGroup._shineThreshold = Math.round(expScale(activityPct, 64, 16));
		emitter.lifespan.set(expScale(activityPct, 7.2, 0.6));
		emitFrequency = expScale(activityPct, 1.6, 0.05);

		if (emitTimer > emitFrequency * 2)
		{
			emitTimer = emitFrequency * 2;
		}
	}

	public function onEmit(glowyParticle:GlowyParticle)
	{
	}

	/**
	 * Scales a number exponentially between min and max
	 *
	 * @param pct
	 *   0.0: return min
	 *   1.0: return max
	 */
	private static function expScale(pct:Float, min:Float, max:Float)
	{
		return min * Math.pow(max / min, FlxMath.bound(pct, 0, 1.0));
	}
}

/**
 * LeftBrainHemisphere displays the human half of the brain
 */
class LeftBrainHemisphere extends BrainHemisphere
{
	public var sourceParticles:Array<GlowyParticle> = [];

	override public function onEmit(glowyParticle:GlowyParticle)
	{
		super.onEmit(glowyParticle);

		sourceParticles.push(glowyParticle);
		sourceParticles.splice(0, sourceParticles.length - 25);
	}

	public function popParticle():GlowyParticle
	{
		return sourceParticles.pop();
	}

	override public function destroy():Void
	{
		super.destroy();
		sourceParticles = FlxDestroyUtil.destroyArray(sourceParticles);
	}
}

/**
 * RightBrainHemisphere displays the Abra half of the brain
 */
class RightBrainHemisphere extends BrainHemisphere
{
	public var sourceParticles:Array<GlowyParticle>;
	public var syncPct:Float = 0.5;
	private var leftHemisphere:LeftBrainHemisphere;

	private var syncTimer:Float = 0;
	private var syncFrequency:Float = 0.8;

	public function new(x:Float, y:Float, glowyBounds:FlxRect, clipGraphicAsset:String, leftHemisphere:LeftBrainHemisphere)
	{
		super(x, y, glowyBounds, clipGraphicAsset);
		this.leftHemisphere = leftHemisphere;
	}

	override public function onEmit(glowyParticle:GlowyParticle)
	{
		super.onEmit(glowyParticle);
		if (leftHemisphere.sourceParticles.length > 0 && FlxG.random.float() < syncPct)
		{
			// synchronize our particles with the left particles
			var sourceParticle:GlowyParticle = leftHemisphere.sourceParticles.pop();
			glowyParticle.glowApex = sourceParticle.glowApex;
			glowyParticle.x = (x + 136) + ((x + 136) - sourceParticle.x);
			glowyParticle.y = sourceParticle.y;
			glowyParticle.velocity.x = -sourceParticle.velocity.x;
			glowyParticle.velocity.y = sourceParticle.velocity.y;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		syncTimer -= elapsed;
		while (syncTimer <= 0)
		{
			syncTimer += syncFrequency;
			if (Math.abs(emitTimer - leftHemisphere.emitTimer) > 0.01)
			{
				// synchronize our timer with the left timer
				emitTimer = (1 - 0.5 * syncPct) * emitTimer + (0.5 * syncPct) * leftHemisphere.emitTimer;
			}
			else
			{
				emitTimer = leftHemisphere.emitTimer;
			}
		}
	}

	override public function destroy():Void
	{
		super.destroy();
		sourceParticles = FlxDestroyUtil.destroyArray(sourceParticles);
	}
}