package;
import critter.Critter;
import critter.EllipseCritterHolder;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * BigCell is a big clue box used for the novice puzzles.
 */
class BigCell extends EllipseCritterHolder implements Cell.ICell
{
	private var critterOffsetsX:Array<Float>;
	private var critterOffsetsY:Array<Float>;

	public var _assignedCritters:Array<Critter> = [];
	public var _frontSprite:FlxSprite;
	public var _clueIndex:Int = 0;

	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		_sprite.loadGraphic(AssetPaths.big_box_back__png, true, 120, 100);
		_sprite.setSize(98, 44);
		_sprite.offset.set(11, 51);
		_sprite.immovable = true;

		_frontSprite = new FlxSprite(X, Y + 32);
		_frontSprite.loadGraphic(AssetPaths.big_box_front__png, true, 120, 100);
		_frontSprite.setSize(_sprite.width, _sprite.height);
		_frontSprite.offset.set(_sprite.offset.x, _sprite.offset.y + 32);
		_frontSprite.immovable = true;

		_leashRadiusX = 28;
		_leashRadiusY = 14;
		_leashOffsetY = -1;

		/*
		 * The bugs in these big boxes are prearranged in one of these
		 * configurations. This ensures they don't overlap each other or the
		 * walls of the cage in an ugly way
		 */
		critterOffsetsX = FlxG.random.getObject([
				[22.1, 4.4, -18.5, -0.6, -12.9, 2.2],
				[8.1, 19.1, -21.6, -14.5, 6.8, 0],
				[24.8, -23.5, -2, 0.5, 3.7, -14],
				[24.9, -25.2, 13.3, 4.7, -3.6, -11.5],
				[ -20.5, 17, -2.6, 4.3, -0.9, -15.4],
				[ -16.3, 27, -11.5, 2.9, -5.4, -14.2],
				[21, -25, 13.5, 4.2, -4.1, -13.5],
				[ -23.6, 23.9, 3.8, -2.6, -3.1, 11.9],
				[23.3, -15.2, 7.8, -10.2, -2.9, 11.6],
				[ -21.3, 19.5, -10.3, -8.9, -5.6, 8.9],
												]);
		critterOffsetsY = critterOffsetsX.splice(3, 3);
	}

	/**
	 * Constrain a bug into the container
	 *
	 * @param	critter The bug to contain
	 * @param	hard true if the bug should be abruptly snapped into place
	 */
	override public function leash(critter:Critter, hard:Bool = false)
	{
		var targetX:Float = getCritterOffsetX(critter) - critter._bodySprite.width / 2 + _sprite.x + _sprite.width / 2;
		var targetY:Float = getCritterOffsetY(critter) - critter._bodySprite.height / 2 + _sprite.y + _sprite.height / 2;
		if (hard)
		{
			critter.setPosition(targetX, targetY);
			critter.setImmovable(true);
		}
		else
		{
			critter.runTo(targetX, targetY);
		}
	}

	public function getCritterOffsetX(critter:Critter):Float
	{
		var index:Int = _assignedCritters.indexOf(critter);
		index = index == -1 ? _critters.indexOf(critter) : index;
		return critterOffsetsX[index];
	}

	public function getCritterOffsetY(critter:Critter):Float
	{
		var index:Int = _assignedCritters.indexOf(critter);
		index = index == -1 ? _critters.indexOf(critter) : index;
		return critterOffsetsY[index];
	}

	override public function destroy():Void
	{
		super.destroy();

		critterOffsetsX = null;
		critterOffsetsY = null;
		_assignedCritters = null;
		_frontSprite = FlxDestroyUtil.destroy(_frontSprite);
	}

	public function open():Void
	{
		SoundStackingFix.play(AssetPaths.box_open_00cb__mp3);
		_sprite.animation.frameIndex = 0;
		_frontSprite.animation.frameIndex = 0;
	}

	public function close():Void
	{
		SoundStackingFix.play(AssetPaths.box_open_00cb__mp3);
		_sprite.animation.frameIndex = 1;
		_frontSprite.animation.frameIndex = 1;
	}

	public function isClosed():Bool
	{
		return _sprite.animation.frameIndex == 1;
	}

	public function getClueIndex():Int
	{
		return _clueIndex;
	}

	public function getFrontSprite():FlxSprite
	{
		return _frontSprite;
	}

	public function assignCritter(critter:Critter):Void
	{
		_assignedCritters.push(critter);
	}

	public function unassignCritter(critter:Critter):Void
	{
		_assignedCritters.remove(critter);
	}

	public function getAssignedCritters():Array<Critter>
	{
		return _assignedCritters;
	}
}