package;

import critter.Critter;
import critter.SingleCritterHolder;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.util.FlxDestroyUtil;

/**
 * A clue cell capable of holding a single bug, for use in puzzles.
 */
class Cell extends SingleCritterHolder implements ICell
{
	public var _frontSprite:FlxSprite;
	public var _clueIndex:Int = 0;
	public var _pegIndex:Int = 0;
	private var _assignedCritters:Array<Critter> = [];

	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		_sprite.loadGraphic(AssetPaths.box_back__png, true, 64, 64);
		_sprite.setSize(36, 10);
		_sprite.offset.set(14, 39);
		_sprite.immovable = true;

		_frontSprite = new FlxSprite(X, Y+2);
		_frontSprite.loadGraphic(AssetPaths.box_front__png, true, 64, 64);
		_frontSprite.setSize(_sprite.width, _sprite.height);
		_frontSprite.offset.set(_sprite.offset.x, _sprite.offset.y + 2);
		_frontSprite.immovable = true;
	}

	override public function destroy():Void
	{
		super.destroy();
		_frontSprite = FlxDestroyUtil.destroy(_frontSprite);
		_assignedCritters = null;
	}

	public function traceInfo(prefix:String):Void
	{
		trace(prefix + ": box # " + _clueIndex + "," + _pegIndex + " = " + (_critter == null ? null : _critter.myId));
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

interface ICell extends IFlxDestroyable
{
	public function getCritters():Array<Critter>;
	public function open():Void;
	public function close():Void;
	public function isClosed():Bool;
	public function addCritter(critter:Critter):Bool;
	public function removeCritter(critter:Critter):Bool;
	public function getSprite():FlxSprite;
	public function getFrontSprite():FlxSprite;
	public function getClueIndex():Int;
	public function assignCritter(critter:Critter):Void;
	public function unassignCritter(critter:Critter):Void;
	public function getAssignedCritters():Array<Critter>;
}