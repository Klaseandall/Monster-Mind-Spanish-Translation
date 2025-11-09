package puzzle;

import MmStringTools.*;
import critter.Critter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxDestroyUtil;

/**
 * Creates and repositions the bugs, clue boxes and answer boxes for a puzzle.
 *
 * When the player has one of the puzzle keys, they can be prompted to upgrade
 * an easy puzzle into a more difficult one. That's the most complex scenario
 * for ClueFactory, as it involves bugs running offscreen, possibly introducing
 * a new bug color and shifting boxes around.
 *
 * To avoid duplicating logic and code, ClueFactory simply treats the
 * initialization of a new puzzle as "upgrading a null puzzle into an easy
 * puzzle", Even when it's initializing a puzzle for the first time. This is
 * why you see a lot of references to things like "oldColors" and "newColors",
 * "oldCritters" and "newCritters".
 */
class ClueFactory implements IFlxDestroyable
{
	private var _puzzleState:PuzzleState;

	public var _offsetX:Float = 0;
	public var _gridX:Float = 0;
	public var _gridY:Float = 0;
	public var _gridWidth:Float = 0;
	public var _gridHeight:Float = 0;

	private var _oldClueCount:Int = 0;
	private var _oldColorCount:Int = 0;

	private var _newClueCount:Int = 0;
	private var _newPegCount:Int = 0;
	private var _newColorCount:Int = 0;

	private var _markerSprites:Array<FlxSprite> = [];

	public function new(puzzleState:PuzzleState)
	{
		this._puzzleState = puzzleState;
	}

	public function reinitialize()
	{
		cachePuzzleDetails();
		initializeClueCells();
		removeOldClueCritters();
		removeOldMarkers();
		updateCritterColors();
		addNewClueCritters();
		addNewMarkers();
		refreshClueLights();
		refreshColorNames();
	}

	function refreshColorNames():Void
	{
		// restore original color names
		for (i in 0..._oldColorCount)
		{
			Critter.CRITTER_COLORS[i].english = substringBefore(Critter.CRITTER_COLORS[i].englishBackup, "/");
		}
		// determine ambiguous color names
		var colorNames:Map<String, Bool> = new Map<String, Bool>();
		var ambiguousColorNames:Map<String, Bool> = new Map<String, Bool>();
		for (i in 0..._newColorCount)
		{
			var critterColor:CritterColor = Critter.CRITTER_COLORS[i];
			if (colorNames[critterColor.english] == true)
			{
				ambiguousColorNames[critterColor.english] = true;
			}
			else
			{
				colorNames[critterColor.english] = true;
			}
		}
		// alter ambiguous color names to be unambiguous
		for (i in 0..._newColorCount)
		{
			var critterColor:CritterColor = Critter.CRITTER_COLORS[i];
			if (ambiguousColorNames[critterColor.english] == true)
			{
				critterColor.english = substringAfter(critterColor.englishBackup, "/");
			}
		}
	}

	function eventRunOffscreenAndVanish(params:Array<Dynamic>):Void
	{
		runOffscreenAndVanish(params[0]);
	}

	function runOffscreenAndVanish(critter:Critter):Void
	{
		var cell:Cell.ICell = _puzzleState.findCell(critter);
		if (cell != null)
		{
			cell.removeCritter(critter);
			cell.unassignCritter(critter);
		}
		var holopad:Holopad = _puzzleState.findHolopad(critter);
		if (holopad != null)
		{
			holopad.removeCritter(critter);
		}

		var direction:Float = FlxG.random.float(0, 2 * Math.PI);
		var dx:Float = 40 * Math.cos(direction);
		var dy:Float = 40 * Math.sin(direction);
		var x = critter._soulSprite.x;
		var y = critter._soulSprite.y;
		while (x >= -80 && y <= FlxG.width + 80 && y >= -80 && y <= FlxG.height + 80)
		{
			x += dx;
			y += dy;
		}
		critter.uncube(); // shouldn't be cubed, but just in case
		critter.runTo(x, y, critterVanish);
	}

	function critterVanish(critter:Critter):Void
	{
		critter.destroy();
		_puzzleState._clueCritters.remove(critter);
		_puzzleState._critters.remove(critter);
	}

	function eventJumpOutOfCellAndVanish(params:Array<Dynamic>):Void
	{
		jumpOutOfCellAndVanish(params[0]);
	}

	function jumpOutOfCellAndVanish(critter:Critter)
	{
		_puzzleState.jumpOutOfCell(critter, runOffscreenAndVanish);
	}

	function eventCellFlicker(params:Array<Dynamic>)
	{
		var cell:Cell = params[0];
		FlxFlicker.flicker(cell._frontSprite, 0.5, 0.04, false, false);
		FlxFlicker.flicker(cell._sprite, 0.5, 0.04, false, false);
	}

	function eventCellVanish(params:Array<Dynamic>)
	{
		var cell:Cell = params[0];
		_puzzleState._clueCells.remove(cell);
		_puzzleState._allCells.remove(cell);
		cell.destroy();
	}

	function eventOpenCell(params:Array<Dynamic>)
	{
		var cell:Cell = params[0];
		cell.open();
	}

	function eventCellSlideTo(params:Array<Dynamic>)
	{
		var cell:Cell = params[0];
		var destX:Float = params[1];
		var destY:Float = params[2];
		FlxTween.tween(cell._sprite, {x:destX, y:destY}, 0.5, {ease:FlxEase.quadInOut});
		FlxTween.tween(cell._frontSprite, {x:destX, y:destY + 2}, 0.5, {ease:FlxEase.quadInOut});
		if (cell._critter != null)
		{
			var dx:Float = destX - cell._sprite.x;
			var dy:Float = destY - cell._sprite.y;
			FlxTween.tween(cell._critter._targetSprite, {x:cell._critter._targetSprite.x + dx, y:cell._critter._targetSprite.y + dy}, 0.5, {ease:FlxEase.quadInOut});
		}
	}

	function eventCellFlickerIn(params:Array<Dynamic>)
	{
		var cell:Cell = params[0];
		FlxFlicker.flicker(cell._frontSprite, 0.5, 0.04, true);
		FlxFlicker.flicker(cell._sprite, 0.5, 0.04, true);
	}

	function cachePuzzleDetails():Void
	{
		_oldClueCount = _newClueCount;
		_oldColorCount = _newColorCount;

		_newClueCount = _puzzleState._puzzle._clueCount;
		_newPegCount = _puzzleState._puzzle._pegCount;
		_newColorCount = _puzzleState._puzzle._colorCount;

		_offsetX = 512;
		_gridX = _offsetX + 4;
		_gridY = 30 + 43;
		_gridWidth = 51;
		_gridHeight = 267 / Math.max(_newClueCount + (_puzzleState._tutorial == null ? 0 : 0.3), 4);
		if (_newPegCount == 7)
		{
			_gridHeight = 297 / 6;
		}
		if (_newPegCount >= 5)
		{
			_gridWidth = 39;
		}
		if (_newPegCount <= 3)
		{
			_gridX = _offsetX + 208 - _newPegCount * _gridWidth;
		}
		if (_newPegCount == 7)
		{
			// clues take up the top row for 7-peg puzzles
		}
		else {
			_gridY += _gridHeight;
		}
	}

	function refreshClueLights():Void
	{
		for (clueIndex in 0..._oldClueCount)
		{
			_puzzleState._puzzleLightsManager.removeClueLight(clueIndex);
		}
		for (clueIndex in 0..._newClueCount)
		{
			_puzzleState._puzzleLightsManager.addClueLight(clueIndex);
			for (pegIndex in 0..._newPegCount)
			{
				var cellPosition:FlxPoint = getCellPosition(clueIndex, pegIndex);

				if (_puzzleState._puzzle._easy)
				{
					if (pegIndex > 0)
					{
						continue;
					}
					_puzzleState._puzzleLightsManager.growLeftClueLight(clueIndex, pegIndex, FlxRect.get(cellPosition.x + 20, cellPosition.y - 16, 98, 44));
				}
				else
				{
					_puzzleState._puzzleLightsManager.growLeftClueLight(clueIndex, pegIndex, FlxRect.get(cellPosition.x, cellPosition.y, 36, 10));
				}
			}
			for (pegIndex in 0..._newPegCount)
			{
				var markerPosition:FlxPoint = getMarkerPosition(clueIndex, pegIndex);

				_puzzleState._puzzleLightsManager.growRightClueLight(clueIndex, FlxRect.get(markerPosition.x, markerPosition.y, 8, 8));
			}
		}
	}

	function initializeClueCells():Void
	{
		if (_oldClueCount != _newClueCount)
		{
			if (_newClueCount > _oldClueCount)
			{
				var newCells:Array<Cell.ICell> = [];

				// need to place new clue cells
				for (clueIndex in _oldClueCount..._newClueCount)
				{
					for (pegIndex in 0..._newPegCount)
					{
						var cellPosition:FlxPoint = getCellPosition(clueIndex, pegIndex);

						var cell:Cell.ICell;

						if (_puzzleState._puzzle._easy)
						{
							if (pegIndex > 0)
							{
								continue;
							}
							var c = new BigCell(cellPosition.x + 20, cellPosition.y - 16);
							c._clueIndex = clueIndex;
							cell = c;
						}
						else
						{
							var c = new Cell(cellPosition.x, cellPosition.y);
							c._clueIndex = clueIndex;
							c._pegIndex = pegIndex;
							cell = c;
						}

						_puzzleState._midSprites.add(cell.getSprite());
						_puzzleState._midSprites.add(cell.getFrontSprite());
						_puzzleState._clueCells.push(cell);
						_puzzleState._allCells.push(cell);
						newCells.push(cell);
					}
				}
				if (_oldClueCount > 0)
				{
					FlxG.random.shuffle(newCells);
					for (i in 0...newCells.length)
					{
						newCells[i].getFrontSprite().visible = false;
						newCells[i].getSprite().visible = false;
						_puzzleState._eventStack.addEvent({time:0.7 + 0.2 * i, callback:eventCellFlickerIn, args:[newCells[i]]});
					}
				}
			}
		}
	}

	function getCellPosition(clueIndex:Int, pegIndex:Int, ?holder:FlxPoint):FlxPoint
	{
		if (holder == null)
		{
			holder = FlxPoint.get();
		}
		holder.set(_gridX + _gridWidth * pegIndex, _gridY + _gridHeight * clueIndex);

		if (_newPegCount == 7)
		{
			if (clueIndex % 2 == 0)
			{
				holder.x -= 512;
			}
			else
			{
				holder.x += 44;
				holder.y -= _gridHeight;
			}
			if (clueIndex == 0 || clueIndex == 3 || clueIndex == 4)
			{
				holder.x += _gridWidth * 1.5;
			}
			if (pegIndex <= 1)
			{
				holder.x += _gridWidth * 0.5;
			}
			else if (pegIndex >= 2 && pegIndex <= 4)
			{
				holder.y += 30;
				holder.x -= _gridWidth * 2;
			}
			else if (pegIndex >= 5)
			{
				holder.y += 60;
				holder.x -= _gridWidth * 4.5;
			}
		}

		if (_puzzleState._puzzle._easy)
		{
			if (clueIndex % 2 == 0)
			{
				holder.x -= 32;
			}
		}
		return holder;
	}

	function removeOldClueCritters():Void
	{
		if (_puzzleState._puzzle._easy && _puzzleState._clueCritters.length > 0)
		{
			/*
			 * We only ever remove clue critters when upgrading to a harder
			 * puzzle. There's no concept of upgrading a 3-peg puzzle to a
			 * harder version.
			 */
			throw "removeOldClueCritters() does not support easy puzzles";
		}
		var eventTime:Float = 0;
		// remove existing clueCritters...
		for (critter in _puzzleState._clueCritters)
		{
			// old clues are taken away
			var cell:Cell = cast(_puzzleState.findCell(critter));
			if (critter.isCubed())
			{
				// critters in cells uncube, run away and vanish...
				_puzzleState._eventStack.addEvent({time:eventTime, callback:eventJumpOutOfCellAndVanish, args:[critter]});
				_puzzleState._eventStack.addEvent({time:eventTime, callback:eventOpenCell, args:[cell]});
				eventTime += FlxG.random.float(0.02, 0.10);
				var cell:Cell = cast(_puzzleState.findCell(critter));
			}
			else if (critter._runToCallback == _puzzleState.jumpIntoCell)
			{
				critter._runToCallback = jumpOutOfCellAndVanish;
			}
			else
			{
				// clueCritters run away and vanish...
				_puzzleState._eventStack.addEvent({time:eventTime, callback:eventRunOffscreenAndVanish, args:[critter]});
				eventTime += FlxG.random.float(0.02, 0.06);
			}
			if (_oldClueCount != _newClueCount)
			{
				if (cell != null)
				{
					if (cell._clueIndex >= _newClueCount)
					{
						cell._critter = null;
						_puzzleState._eventStack.addEvent({time:eventTime + .1, callback:eventCellFlicker, args:[cell]});
						_puzzleState._eventStack.addEvent({time:eventTime + .6, callback:eventCellVanish, args:[cell]});
					}
					else
					{
						var cellPosition:FlxPoint = getCellPosition(cell._clueIndex, cell._pegIndex);

						_puzzleState._eventStack.addEvent({time:eventTime + .1, callback:eventCellSlideTo, args:[cell, cellPosition.x, cellPosition.y]});
					}
				}
			}
		}
		_puzzleState._clueCritters.splice(0, _puzzleState._clueCritters.length);
	}

	function removeOldMarkers():Void
	{
		_markerSprites = FlxDestroyUtil.destroyArray(_markerSprites);
		_markerSprites = [];
	}

	function addNewClueCritters():Void
	{
		for (cell in _puzzleState._clueCells)
		{
			if (cell.getClueIndex() >= _newClueCount)
			{
				continue;
			}
			var critters:Array<Critter> = [];
			if (_puzzleState._puzzle._easy)
			{
				for (p in 0..._puzzleState._puzzle._pegCount)
				{
					var critter:Critter = new Critter(FlxG.random.float(0, FlxG.width), FlxG.random.float(0, FlxG.height), _puzzleState._backdrop);
					critter.setColor(Critter.CRITTER_COLORS[_puzzleState._puzzle._guesses[cell.getClueIndex()][p]]);
					critters.push(critter);
				}
			}
			else
			{
				var critter:Critter = new Critter(FlxG.random.float(0, FlxG.width), FlxG.random.float(0, FlxG.height), _puzzleState._backdrop);
				critter.setColor(Critter.CRITTER_COLORS[_puzzleState._puzzle._guesses[cell.getClueIndex()][cast(cell, Cell)._pegIndex]]);
				critters.push(critter);
			}
			for (critter in critters)
			{
				if (_newPegCount == 7)
				{
					// 360 degrees; bugs come from everywhere
					if (FlxG.random.bool(0.25))
					{
						critter.setPosition(FlxG.random.bool() ? -40 : FlxG.width + 40, critter._soulSprite.y);
					}
					else
					{
						critter.setPosition(critter._soulSprite.x, FlxG.random.bool() ? -40 : FlxG.height + 40);
					}
				}
				else
				{
					//180 degrees; bugs only come from the right side
					if (FlxG.random.bool())
					{
						critter.setPosition(FlxG.width + 40, critter._soulSprite.y);
					}
					else
					{
						while (critter._soulSprite.x < FlxG.width / 2)
						{
							critter._soulSprite.x += FlxG.width / 2;
						}
						critter.setPosition(critter._soulSprite.x, FlxG.random.bool() ? -40 : FlxG.height + 40);
					}
				}
				critter.neverIdle();
				_puzzleState.addCritter(critter);
				_puzzleState._critters.remove(critter);
				_puzzleState._clueCritters.push(critter);

				cell.assignCritter(critter);
				var distX:Float = FlxG.random.float(40, 60);
				var distY:Float = FlxG.random.float(20, 60);

				var posX:Float = FlxG.random.float(_gridX - _gridWidth * 0.5, _gridX + _gridWidth * _newPegCount + _gridWidth * 0.5);
				var posY:Float = FlxG.random.float(_gridY - _gridHeight * 0.5, _gridY + _gridHeight * _newPegCount + _gridHeight * 0.5);

				if (_newPegCount == 7)
				{
					if (cell.getClueIndex() % 2 == 0)
					{
						posX -= (512 - 44);
					}
				}

				critter.runTo(posX - distX, posY - distY, null);
			}
		}

		FlxG.random.shuffle(_puzzleState._clueCritters);
	}

	function updateCritterColors():Void
	{
		if (_oldColorCount != _newColorCount)
		{
			if (_oldColorCount > _newColorCount)
			{
				// color was removed; remove wrong-color critters
				var colorsToRemove:Array<CritterColor> = [];
				for (i in _newColorCount..._oldColorCount)
				{
					colorsToRemove.push(Critter.CRITTER_COLORS[i]);
				}

				for (_critter in _puzzleState._critters)
				{
					if (colorsToRemove.indexOf(_critter._critterColor) != -1)
					{
						runOffscreenAndVanish(_critter);
					}
				}
			}
			if (_oldColorCount < _newColorCount)
			{
				// color was added; introduce new-color critters
				var colorIndexesToCreate:Array<Int> = [];
				for (i in _oldColorCount..._newColorCount)
				{
					colorIndexesToCreate.push(i);
				}

				var crittersPerColor:Int = 9;
				if (PlayerData.detailLevel == PlayerData.DetailLevel.VeryLow)
				{
					crittersPerColor = 5;
				}
				else if (PlayerData.detailLevel == PlayerData.DetailLevel.Low)
				{
					crittersPerColor = 7;
				}

				var z:Int = 0;
				for (i in 0...crittersPerColor * colorIndexesToCreate.length)
				{
					var colorIndex:Int = colorIndexesToCreate[i % colorIndexesToCreate.length];
					var critter = new Critter((z % FlxG.width) - 10, FlxG.height + 40 + Std.int(z / FlxG.width) * 20, _puzzleState._backdrop);
					critter.setColor(Critter.CRITTER_COLORS[colorIndex]);
					_puzzleState.addCritter(critter);
					z += 44;
				}
				_puzzleState.refillCritters();
			}

			if (_oldColorCount > 0)
			{
				var scoochPercent:Float = _oldColorCount / _newColorCount;

				// scooch existing critters left/right
				for (critter in _puzzleState._critters)
				{
					if (_puzzleState.isInRefillArea(critter))
					{
						critter._targetSprite.x *= scoochPercent;
					}
				}
			}
		}
	}

	function addNewMarkers():Void
	{
		for (clueIndex in 0..._newClueCount)
		{
			var markerInt:Int = _puzzleState._puzzle._markers[clueIndex];
			for (pegIndex in 0..._newPegCount)
			{
				if (markerInt == 0)
				{
					break;
				}
				var markerPosition:FlxPoint = getMarkerPosition(clueIndex, pegIndex);

				var bouncePhase:Float = (((_newPegCount - pegIndex) / 3 + clueIndex) % _newPegCount) * (1.0 / _newPegCount);
				if (_newPegCount == 7)
				{
					if (pegIndex >= 5)
					{
						bouncePhase = (((_newPegCount - (pegIndex - 4.5)) / 3 + clueIndex) % _newPegCount) * (1.0 / _newPegCount);
					}
				}

				var markerSprite = new BouncySprite(markerPosition.x, markerPosition.y, 4, 3, bouncePhase);
				markerSprite.loadGraphic(AssetPaths.markers__png, true, 24, 24);
				if (markerInt >= 10)
				{
					markerSprite.animation.frameIndex = 2;
					markerInt -= 10;
				}
				else if (markerInt >= 1)
				{
					markerSprite.animation.frameIndex = _puzzleState._puzzle._easy ? 3 : 1;
					markerInt -= 1;
				}
				var shadow:Shadow = _puzzleState._shadowGroup.makeShadow(markerSprite, (markerSprite.animation.frameIndex == 2) ? 0.5 : 0.3);
				markerSprite.setSize(8, 8);
				markerSprite.offset.x = 8;
				markerSprite._baseOffsetY = 18;
				_puzzleState._midSprites.add(markerSprite);
				_markerSprites.push(markerSprite);
			}
		}
	}

	function getMarkerPosition(clueIndex:Int, pegIndex:Int, ?holder:FlxPoint):FlxPoint
	{
		if (holder == null)
		{
			holder = FlxPoint.get();
		}
		holder.set(_offsetX + 204 + 9 * pegIndex, _gridY + _gridHeight * clueIndex - 2);

		if (_newPegCount == 7)
		{
			holder.x -= _gridWidth * 2.5;
			holder.y += -9;
			if (clueIndex % 2 == 0)
			{
				holder.x -= 512;
			}
			else
			{
				holder.x += 44;
				holder.y -= _gridHeight;
			}
			if (clueIndex == 0 || clueIndex == 3 || clueIndex == 4)
			{
				holder.x += _gridWidth * 1.5;
			}
			if (pegIndex == 1 || pegIndex == 3)
			{
			}
			else if (pegIndex <= 4)
			{
				holder.y += 9;
			}
			else if (pegIndex >= 5)
			{
				holder.x += 9 * pegIndex;
				holder.y += 9 * 2;
				holder.x -= 18 * 4.5;
			}
		}
		else {
			if (pegIndex % 2 == 1)
			{
				holder.y += 9;
			}
		}

		if (_puzzleState._puzzle._easy)
		{
			if (clueIndex % 2 == 0)
			{
				holder.x -= 32;
			}
		}
		return holder;
	}

	public function destroy():Void
	{
		_puzzleState = null;
		_markerSprites = FlxDestroyUtil.destroyArray(_markerSprites);
	}
}