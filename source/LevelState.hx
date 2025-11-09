package;

import MmStringTools.*;
import critter.Critter;
import critter.CritterBody;
import critter.CritterHolder;
import critter.SexyAnims;
import critter.SingleCritterHolder;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSort;
import kludge.BetterFlxRandom;
import kludge.AssetKludge;
import kludge.FlxFilterFramesKludge;
import kludge.FlxSpriteKludge;
import openfl.filters.DropShadowFilter;
import poke.PokeWindow;

/**
 * LevelState encompasses the logic common to puzzles and minigames -- things
 * like how the bugs move, picking up and dropping them, drawing shadows, and
 * pressing "escape" to bring up help.
 */
class LevelState extends FlxTransitionableState
{
	public static var GLOBAL_IDLE_FREQUENCY:Float = 100; // frequency of global idle events
	public static var GLOBAL_SEXY_FREQUENCY:Float = 313; // frequency of global sexy events
	public static var BUTTON_OFF_ALPHA:Float = 0.30;

	public var _gameState:Int = 80;
	public var _stateTime:Float = 0;

	public var _handSprite:FlxSprite;
	public var _thumbSprite:FlxSprite;
	public var _clickedMidpoint:FlxPoint;
	private var _mousePressedPosition:FlxPoint;
	private var _mousePressedDuration:Float = 0;
	private var _clickGrabbed:Bool = false;

	public var _cursorSprites:FlxTypedGroup<FlxSprite>;
	public var _hud:FlxGroup;
	public var _midInvisSprites:FlxTypedGroup<FlxSprite>;
	public var _midSprites:FlxTypedGroup<FlxSprite>; // mid sprites which need to be sorted for the purposes of rendering
	public var _targetSprites:FlxTypedGroup<FlxSprite>; // critter target sprites, they have their own group for hit detection
	public var _blockers:FlxGroup; // blockers, they stop critters from stepping on important things
	public var _backSprites:FlxGroup;
	public var _shadowGroup:ShadowGroup;
	public var _backdrop:FlxSprite;

	public var _critters:Array<Critter>;
	public var _grabbedCritter:Critter;

	private var _dialogTree:DialogTree;
	public var _dialogger:Dialogger;
	public var _eventStack:EventStack = new EventStack();

	public var _pokeWindow:PokeWindow;
	public var _cashWindow:CashWindow;

	/*
	 * Over time, the bugs will do idle things like bouncing around, or sexy
	 * things like giving each other blowjobs. These timers count down to
	 * trigger those events.
	 */
	public var _globalIdleTimer:Float = 0;
	public var _globalSexyTimer:Float = 0;

	public var _chests:Array<Chest>;
	private var _gemIndex:Int = 0;
	public var _gems:Array<Gem> = [];
	private var _helpButton:FlxButton;

	/*
	 * When a bug is grabbed, their head goes ahead of your glove but their
	 * butt goes behind your glove. Their butt also has some momentum which
	 * needs to be tracked
	 */
	private var _grabbedCritterButtSprite:FlxSprite;
	private var _grabbedCritterButtVector:FlxPoint;

	public function new(?TransIn:TransitionData, ?TransOut:TransitionData)
	{
		super(TransIn, TransOut);
	}

	override public function create():Void
	{
		if (PlayerData.detailLevel == PlayerData.DetailLevel.Low || PlayerData.detailLevel == PlayerData.DetailLevel.VeryLow)
		{
			// clear cached bitmap assets to save memory
			FlxG.bitmap.dumpCache();
		}

		super.create();
		Main.overrideFlxGDefaults();
		Critter.initialize();

		_backSprites = new FlxGroup();
		_shadowGroup = new ShadowGroup();
		_targetSprites = new FlxTypedGroup<FlxSprite>();
		_blockers = new FlxGroup();
		_midInvisSprites = new FlxTypedGroup<FlxSprite>();
		_midSprites = new FlxTypedGroup<FlxSprite>();
		_hud = new FlxGroup();
		_cursorSprites = new FlxTypedGroup<FlxSprite>();

		_critters = [];
		_chests = [];

		add(_backSprites);
		/*
		 * shadowGroup.active is false so that it can be updated explicitly.
		 * That way we can ensure the shadows are moved after the sprites move.
		 */
		_shadowGroup.active = false;
		add(_shadowGroup);
		add(_targetSprites);
		add(_blockers);
		add(_midInvisSprites);
		add(_midSprites);
		add(_hud);
		add(_cursorSprites);

		_backdrop = newBackdrop();
		_backSprites.add(_backdrop);

		_pokeWindow = PokeWindow.fromInt(PlayerData.profIndex);

		_handSprite = new FlxSprite(100, 100);
		CursorUtils.initializeHandSprite(_handSprite, AssetPaths.hands__png);
		_handSprite.setSize(12, 11);
		_handSprite.offset.set(65, 83);
		_cursorSprites.add(_handSprite);

		for (i in 0...50)
		{
			_gems.push(new Gem());
		}

		_thumbSprite = new FlxSprite(100, 110);
		CursorUtils.initializeHandSprite(_thumbSprite, AssetPaths.thumbs__png);
		_thumbSprite.setSize(12, 1);
		_thumbSprite.offset.set(65, 93);
		_cursorSprites.add(_thumbSprite);

		_grabbedCritterButtSprite = new FlxSprite();
		_grabbedCritterButtVector = FlxPoint.get();

		_dialogger = new Dialogger();
		_cashWindow = new CashWindow();

		_globalIdleTimer = FlxG.random.float(0, GLOBAL_IDLE_FREQUENCY);
		_globalSexyTimer = FlxG.random.float(0, GLOBAL_SEXY_FREQUENCY);

		if (PlayerData.profIndex == -1)
		{
			// should actually be initialized by MainMenuState
			PlayerData.profIndex = PlayerData.professors[PlayerData.difficulty.getIndex()];
		}

		_helpButton = newButton(AssetPaths.help_button__png, FlxG.width - 33, 3, 28, 28, clickHelp);
	}

	override public function destroy():Void
	{
		super.destroy();

		_handSprite = FlxDestroyUtil.destroy(_handSprite);
		_thumbSprite = FlxDestroyUtil.destroy(_thumbSprite);
		_clickedMidpoint = FlxDestroyUtil.put(_clickedMidpoint);
		_cursorSprites = FlxDestroyUtil.destroy(_cursorSprites);
		_hud = FlxDestroyUtil.destroy(_hud);
		_midInvisSprites = FlxDestroyUtil.destroy(_midInvisSprites);
		_midSprites = FlxDestroyUtil.destroy(_midSprites);
		_targetSprites = FlxDestroyUtil.destroy(_targetSprites);
		_blockers = FlxDestroyUtil.destroy(_blockers);
		_backSprites = FlxDestroyUtil.destroy(_backSprites);
		_shadowGroup = FlxDestroyUtil.destroy(_shadowGroup);
		_backdrop = FlxDestroyUtil.destroy(_backdrop);
		_critters = FlxDestroyUtil.destroyArray(_critters);
		_grabbedCritter = FlxDestroyUtil.destroy(_grabbedCritter);
		_dialogTree = FlxDestroyUtil.destroy(_dialogTree);
		_dialogger = FlxDestroyUtil.destroy(_dialogger);
		_eventStack = null;
		_pokeWindow = FlxDestroyUtil.destroy(_pokeWindow);
		_cashWindow = FlxDestroyUtil.destroy(_cashWindow);
		_chests = FlxDestroyUtil.destroyArray(_chests);
		_gems = null;
		_helpButton = FlxDestroyUtil.destroy(_helpButton);
		_grabbedCritterButtSprite = FlxDestroyUtil.destroy(_grabbedCritterButtSprite);
		_grabbedCritterButtVector = FlxDestroyUtil.put(_grabbedCritterButtVector);
	}

	public static function newBackdrop():FlxSprite
	{
		var bgSprite:FlxSprite = new FlxSprite(0, 0);
		var stageWidth = 768;
		var stageHeight = 432;
		bgSprite.makeGraphic(stageWidth, stageHeight, 0x00000000, true);
		var bgAsset:FlxGraphicAsset = AssetPaths.bg0_tile__png;
		if (PlayerData.profIndex == 0)
		{
			bgAsset = AssetPaths.bg0_tile__png;
		}
		else if (PlayerData.profIndex == 1)
		{
			bgAsset = AssetPaths.bg1_tile__png;
		}
		else if (PlayerData.profIndex == 2)
		{
			bgAsset = AssetPaths.bg3_tile__png; // heracross
		}
		else if (PlayerData.profIndex == 3)
		{
			bgAsset = AssetPaths.bg3_tile__png;
		}
		else if (PlayerData.profIndex == 4)
		{
			bgAsset = AssetPaths.bg4_tile__png;
		}
		else if (PlayerData.profIndex == 5)
		{
			bgAsset = AssetPaths.bg5_tile__png;
		}
		else if (PlayerData.profIndex == 6)
		{
			bgAsset = AssetPaths.bg6_tile__png;
		}
		else if (PlayerData.profIndex == 8)
		{
			bgAsset = AssetPaths.bg4_tile__png; // magnezone
		}
		else if (PlayerData.profIndex == 9)
		{
			bgAsset = AssetPaths.bg0_tile__png; // grimer
		}
		else if (PlayerData.profIndex == 10)
		{
			bgAsset = AssetPaths.bg5_tile__png; // lucario
		}
		var bgStamp:FlxSprite = new FlxSprite(0, 0, bgAsset);
		var x:Int = 0;
		var y:Int = 0;
		do {
			x = 0;
			do {
				bgSprite.stamp(bgStamp, x, y);
				x += Std.int(bgStamp.width);
			}
			while (x < stageWidth);
			y += Std.int(bgStamp.height);
		}
		while (y < stageHeight);
		return bgSprite;
	}

	public function moveGrabbedCritter(elapsed:Float):Void
	{
		_grabbedCritter.setPosition(_handSprite.x - 18, _handSprite.y + 5);
		_thumbSprite.setPosition(_handSprite.x, _handSprite.y + 6);

		moveGrabbedCritterButt(elapsed);
	}

	public function moveGrabbedCritterButt(elapsed:Float):Void
	{
		_grabbedCritterButtVector.set(_grabbedCritter._soulSprite.x - _grabbedCritterButtSprite.x, _grabbedCritter._soulSprite.y - _grabbedCritterButtSprite.y);
		if (_grabbedCritterButtVector.length != 0)
		{
			if (_grabbedCritterButtVector.length < 90)
			{
				if (_grabbedCritterButtVector.length > 150 * elapsed)
				{
					_grabbedCritterButtVector.length = 150 * elapsed;
				}
			}
			else
			{
				if (_grabbedCritterButtVector.length > 900 * elapsed)
				{
					_grabbedCritterButtVector.length = 900 * elapsed;
				}
			}
			_grabbedCritterButtSprite.x += _grabbedCritterButtVector.x;
			_grabbedCritterButtSprite.y += _grabbedCritterButtVector.y;

			if (_grabbedCritterButtSprite.x > _grabbedCritter._soulSprite.x + 60)
			{
				_grabbedCritter._bodySprite.animation.play("grab-w2");
			}
			else if (_grabbedCritterButtSprite.x > _grabbedCritter._soulSprite.x + 15)
			{
				if (_grabbedCritter._bodySprite.animation.name == "grab-w2")
				{
				}
				else
				{
					_grabbedCritter._bodySprite.animation.play("grab-w1");
				}
			}
			else if (_grabbedCritterButtSprite.x < _grabbedCritter._soulSprite.x - 60)
			{
				_grabbedCritter._bodySprite.animation.play("grab-e2");
			}
			else if (_grabbedCritterButtSprite.x < _grabbedCritter._soulSprite.x - 15)
			{
				if (_grabbedCritter._bodySprite.animation.name == "grab-e2")
				{
				}
				else
				{
					_grabbedCritter._bodySprite.animation.play("grab-e1");
				}
			}
		}
		if (_grabbedCritter._bodySprite.animation.name.substring(0, 5) == "grab-"
				&& _grabbedCritter._bodySprite.animation.curAnim.curFrame == _grabbedCritter._bodySprite.animation.curAnim.numFrames - 1)
		{
			// rest
			_grabbedCritterButtSprite.setPosition(_grabbedCritter._soulSprite.x, _grabbedCritter._soulSprite.y);
		}
	}

	override public function update(elapsed:Float):Void
	{
		PlayerData.updateTimePlayed();
		if (FlxG.mouse.justPressed)
		{
			PlayerData.updateCursorVisible();
		}
		_stateTime += elapsed;
		_handSprite.setPosition(FlxG.mouse.x - _handSprite.width / 2, FlxG.mouse.y - _handSprite.height / 2);

		_eventStack.update(elapsed);

		if (_grabbedCritter != null)
		{
			// currently dragging a critter around
			moveGrabbedCritter(elapsed);
		}
		else {
			_thumbSprite.setPosition(_handSprite.x, _handSprite.y + 10);
		}

		if (FlxG.mouse.justPressed)
		{
			_clickedMidpoint = _handSprite.getMidpoint();
		}

		handleClick(elapsed);

		super.update(elapsed);

		handleCritterOverlap(elapsed);

		var shouldFade:Bool = false;
		if (FlxSpriteKludge.overlap(_handSprite, _pokeWindow._canvas))
		{
			var minDist:Float = FlxG.width;
			for (_cameraButton in _pokeWindow._cameraButtons)
			{
				var dist:Float = FlxPoint.get(_pokeWindow.x + _cameraButton.x + 14, _pokeWindow.y + _cameraButton.y + 14).distanceTo(FlxG.mouse.getPosition());
				minDist = Math.min(dist, minDist);
			}
			if (minDist <= 30)
			{
				// too close to a camera button; don't fade out
				shouldFade = false;
			}
			else
			{
				shouldFade = true;
			}
		}

		if (shouldFade)
		{
			_pokeWindow._canvas.alpha = Math.max(0.3, _pokeWindow._canvas.alpha - 3.0 * elapsed);
		}
		else {
			_pokeWindow._canvas.alpha = Math.min(1.0, _pokeWindow._canvas.alpha + 3.0 * elapsed);
		}

		for (sprite in _midInvisSprites)
		{
			if (sprite == null || !sprite.exists || !sprite.alive)
			{
				continue;
			}
			if (sprite.visible && sprite.isOnScreen())
			{
				_midInvisSprites.remove(sprite);
				_midSprites.add(sprite);
			}
		}
		for (sprite in _midSprites)
		{
			if (sprite == null || !sprite.exists || !sprite.alive)
			{
				continue;
			}
			if (!sprite.visible || !sprite.isOnScreen())
			{
				_midSprites.remove(sprite);
				_midInvisSprites.add(sprite);
			}
		}

		for (chest in _chests)
		{
			chest.update(elapsed);
		}

		_midSprites.sort(byYNulls);

		_cursorSprites.sort(byYNulls);

		if (DialogTree.isDialogging(_dialogTree))
		{
			_cashWindow.setShopText(true);
		}
		else {
			_cashWindow.setShopText(false);
		}

		_shadowGroup.update(elapsed);

		if (_helpButton.alpha >= 1.0 && FlxG.keys.justPressed.ESCAPE)
		{
			clickHelp();
		}
	}
	

	/**
	 * A sorting function which sorts FlxObjects by their y values.
	 * 
	 * FlxSort.byY does the same thing, but throws if given null objects
	 */
	public static inline function byYNulls(Order:Int, Obj1:FlxObject, Obj2:FlxObject):Int
	{
		return FlxSort.byValues(Order, Obj1 == null ? -10000 : Obj1.y, Obj2 == null ? -10000 : Obj2.y);
	}	

	function handleCritterOverlap(elapsed:Float)
	{
		FlxG.overlap(_targetSprites, _targetSprites, critterCollide);
		FlxG.overlap(_targetSprites, _blockers, critterCollide);
	}

	/**
	 * Subclasses can override this to define what happens when the user clicks
	 * the "help" button.
	 */
	public function clickHelp():Void
	{
	}

	public function addCritter(critter:Critter, pushToCritterList:Bool = true)
	{
		_targetSprites.add(critter._targetSprite);
		_midInvisSprites.add(critter._soulSprite);
		_midInvisSprites.add(critter._bodySprite);
		_midInvisSprites.add(critter._headSprite);
		_midInvisSprites.add(critter._frontBodySprite);
		var shadow:Shadow = _shadowGroup.makeShadow(critter._bodySprite);
		critter.shadow = shadow;
		if (pushToCritterList)
		{
			_critters.push(critter);
		}
	}

	function removeCritter(critter:Critter):Void
	{
		_targetSprites.remove(critter._targetSprite, true);
		_midInvisSprites.remove(critter._soulSprite, true);
		_midInvisSprites.remove(critter._bodySprite, true);
		_midInvisSprites.remove(critter._headSprite, true);
		_midInvisSprites.remove(critter._frontBodySprite, true);
		_midSprites.remove(critter._bodySprite, true);
		_midSprites.remove(critter._headSprite, true);
		_midSprites.remove(critter._frontBodySprite, true);
		_critters.remove(critter);
	}

	function findClosestCritter(point:FlxPoint, distanceThreshold:Float=25):Critter
	{
		var minDistance:Float = distanceThreshold + 1;
		var closestCritter:Critter = null;
		for (critter in _critters)
		{
			var distance:Float = critter._bodySprite.getMidpoint().distanceTo(point);
			if (distance < minDistance)
			{
				minDistance = distance;
				closestCritter = critter;
			}
		}
		return minDistance < distanceThreshold ? closestCritter : null;
	}

	public function findGrabbedCritter():Critter
	{
		var offsetPoint:FlxPoint = FlxPoint.get(_clickedMidpoint.x, _clickedMidpoint.y);
		offsetPoint.y += 10;
		var critter:Critter = findClosestCritter(offsetPoint);
		if (critter == null || critter.isCubed())
		{
			return null;
		}
		return critter;
	}

	/**
	 * Checks whether a recent mouse click should cause a bug-grabbing event,
	 * and grabs the appropriate bug.
	 *
	 * @return true if a bug was grabbed
	 */
	public function maybeGrabCritter():Bool
	{
		if (_grabbedCritter != null)
		{
			return true;
		}
		_grabbedCritter = findGrabbedCritter();
		if (_grabbedCritter != null)
		{
			var success:Bool = removeCritterFromHolder(_grabbedCritter);
			if (!success)
			{
				_grabbedCritter = null;
				return true;
			}
			_targetSprites.remove(_grabbedCritter._targetSprite, true);
			_midInvisSprites.remove(_grabbedCritter._soulSprite, true);
			_midSprites.remove(_grabbedCritter._bodySprite, true);
			_midSprites.remove(_grabbedCritter._headSprite, true);
			_midSprites.remove(_grabbedCritter._frontBodySprite, true);
			_cursorSprites.add(_grabbedCritter._targetSprite);
			_cursorSprites.add(_grabbedCritter._soulSprite);
			_cursorSprites.add(_grabbedCritter._bodySprite);
			_cursorSprites.add(_grabbedCritter._headSprite);
			_cursorSprites.add(_grabbedCritter._frontBodySprite);
			_handSprite.animation.frameIndex = 1;
			_thumbSprite.animation.frameIndex = 1;

			_grabbedCritter.grab();
			_thumbSprite.offset.y = _handSprite.offset.y + 6;
			_grabbedCritterButtSprite.setPosition(_grabbedCritter._soulSprite.x, _grabbedCritter._soulSprite.y);
			return true;
		}
		return false;
	}

	/**
	 * Checks whether a recent mouse release should cause a bug-releasing
	 * event, and releases the appropriate bug.
	 *
	 * @return true if a bug was released
	 */
	public function maybeReleaseCritter():Bool
	{
		if (_grabbedCritter == null)
		{
			return false;
		}
		// user dropped a critter
		if (_mousePressedPosition.distanceTo(FlxG.mouse.getWorldPosition()) >= 8 || _mousePressedDuration > 0.50 || _clickGrabbed)
		{
			SoundStackingFix.play(AssetPaths.drop__mp3);
			_grabbedCritter._targetSprite.y += 10;
			_grabbedCritter._soulSprite.y += 10;
			_grabbedCritter._bodySprite.y += 10;
			var targetCritterHolder:CritterHolder = findTargetCritterHolder();
			if (targetCritterHolder != null)
			{
				placeCritterInHolder(targetCritterHolder, _grabbedCritter);
			}

			handleUngrab();
			_clickGrabbed = false;
		}
		else {
			_clickGrabbed = true;
		}
		return true;
	}

	public function handleUngrab():Void
	{
		_cursorSprites.remove(_grabbedCritter._targetSprite, true);
		_cursorSprites.remove(_grabbedCritter._soulSprite, true);
		_cursorSprites.remove(_grabbedCritter._bodySprite, true);
		_cursorSprites.remove(_grabbedCritter._headSprite, true);
		_cursorSprites.remove(_grabbedCritter._frontBodySprite, true);
		_targetSprites.add(_grabbedCritter._targetSprite);
		_midInvisSprites.add(_grabbedCritter._soulSprite);
		_midSprites.add(_grabbedCritter._bodySprite);
		_midSprites.add(_grabbedCritter._headSprite);
		_midSprites.add(_grabbedCritter._frontBodySprite);

		_grabbedCritter.ungrab();

		if (!_grabbedCritter._targetSprite.immovable)
		{
			// maybe critter should tumble a little?
			_grabbedCritterButtVector.set(_grabbedCritter._bodySprite.x - _grabbedCritterButtSprite.x, _grabbedCritter._bodySprite.y - _grabbedCritterButtSprite.y);
			if (_grabbedCritterButtVector.length >= 180)
			{
				// reign it in a little
				_grabbedCritterButtVector.length = 180 + (_grabbedCritterButtVector.length - 180) * 0.5;

				// tumble
				_grabbedCritter.z = 20;
				_grabbedCritter._bodySprite._jumpSpeed = 2 * (_grabbedCritterButtVector.length - (_grabbedCritterButtVector.length - 180) * 0.5);
				_grabbedCritter.jumpTo(_grabbedCritter._soulSprite.x + _grabbedCritterButtVector.x, _grabbedCritter._soulSprite.y + _grabbedCritterButtVector.y, 0);
				_grabbedCritter.updateMovingPrefix("tumble");
			}
			else if (_grabbedCritterButtVector.length >= 90)
			{
				// jump
				_grabbedCritter.z = 20;
				_grabbedCritter._bodySprite._jumpSpeed = Math.max(CritterBody.DEFAULT_JUMP_SPEED, _grabbedCritterButtVector.length);
				_grabbedCritter.jumpTo(_grabbedCritter._soulSprite.x + _grabbedCritterButtVector.x * 0.5, _grabbedCritter._soulSprite.y + _grabbedCritterButtVector.y * 0.5, 0);
			}
			else if (_grabbedCritterButtVector.length >= 30)
			{
				// walk
				_grabbedCritter.runTo(_grabbedCritter._soulSprite.x + _grabbedCritterButtVector.x * 0.3, _grabbedCritter._soulSprite.y + _grabbedCritterButtVector.y * 0.3);
			}
		}

		_grabbedCritter = null;
		_handSprite.animation.frameIndex = 0;
		_thumbSprite.animation.frameIndex = 0;
		_thumbSprite.offset.y = _handSprite.offset.y + 10;
		_thumbSprite.y = _handSprite.y + 10;
	}

	function removeCritterFromHolder(critter:Critter):Bool
	{
		return true;
	}

	function handleClick(elapsed:Float):Void
	{
		if (_dialogTree == null || !DialogTree.isDialogging(_dialogTree))
		{
			if (FlxG.mouse.justReleased)
			{
				handleMouseRelease();
			}
			else if (FlxG.mouse.justPressed && !_dialogger._handledClick)
			{
				handleMousePress();
			}
			if (FlxG.mouse.justPressed)
			{
				_mousePressedPosition = FlxG.mouse.getWorldPosition();
			}
			if (FlxG.mouse.pressed)
			{
				_mousePressedDuration += elapsed;
			}
			else
			{
				_mousePressedDuration = 0;
			}
		}
	}

	/**
	 * Overridden by subclasses to define mouse press behavior
	 */
	function handleMousePress():Void
	{
	}

	/**
	 * Overridden by subclasses to define mouse release behavior
	 */
	function handleMouseRelease():Void
	{
	}

	function placeCritterInHolder(holder:CritterHolder, critter:Critter)
	{
		holder.holdCritter(critter);
		if (critter.outCold && Std.isOfType(holder, SingleCritterHolder))
		{
			critter.playAnim("idle-outcold0");
		}
	}

	/**
	 * Overridden by subclasses to define logic for finding a "critter holder"
	 * -- something which a critter can be dropped onto. This could be a small
	 * or large box for the puzzles, or a platform for the minigames
	 */
	function findTargetCritterHolder():CritterHolder
	{
		return null;
	}

	public function critterCollide(Sprite0:FlxSprite, Sprite1:FlxSprite):Void
	{
		if (Sprite0.immovable && Sprite1.immovable)
		{
			// two immobile sprites touching... maybe two critters having sex
			return;
		}

		var dx:Float = Sprite1.x + Sprite1.width / 2 - (Sprite0.x + Sprite0.width / 2);
		var dy:Float = Sprite1.y + Sprite1.height / 2 - (Sprite0.y + Sprite0.height / 2);

		if (dy == 0 && dx == 0)
		{
			dx = 1;
		}

		var separateX:Float = dx > 0 ? (Sprite0.x + Sprite0.width + 0.5 - Sprite1.x) : -(Sprite1.x + Sprite1.width + 0.5 - Sprite0.x);
		var separateY:Float = dy > 0 ? (Sprite0.y + Sprite0.height + 0.5 - Sprite1.y) : -(Sprite1.y + Sprite1.height + 0.5 - Sprite0.y);

		if (dx == 0 || Math.abs(dy / dx) > Sprite0.height / Sprite0.width)
		{
			// move vertically
			separateX *= 0.33;
		}
		else {
			separateY *= 0.33;
		}

		if (Sprite0.immovable && !Sprite1.immovable)
		{
			Sprite1.x += separateX;
			Sprite1.y += separateY;
		}
		else if (Sprite1.immovable && !Sprite0.immovable)
		{
			Sprite0.x -= separateX;
			Sprite0.y -= separateY;
		}
		else if (!Sprite0.immovable && !Sprite1.immovable)
		{
			Sprite1.x += separateX / 2;
			Sprite1.y += separateY / 2;
			Sprite0.x -= separateX / 2;
			Sprite0.y -= separateY / 2;
		}
	}

	function setState(state:Int)
	{
		_gameState = state;
		_stateTime = 0;
	}

	public function eventSetState(params:Array<Dynamic>):Void
	{
		setState(params[0]);
	}

	public function quit()
	{
		PlayerData.discardChatHistory();
		if (PlayerData.playerIsInDen)
		{
			FlxG.switchState(new ShopState());
		}
		else
		{
			FlxG.switchState(new MainMenuState());
		}
	}

	public function dialogTreeCallback(Msg:String):String
	{
		if (Msg == "%quit%")
		{
			quit();
		}
		if (StringTools.startsWith(Msg, "%setprofindex-"))
		{
			var index:Int = Std.parseInt(substringBetween(Msg, "%setprofindex-", "%"));
			PlayerData.profIndex = index;
		}
		return null;
	}

	function newButton(Graphic:Dynamic, X:Float, Y:Float, Width:Int, Height:Int, Callback:Void->Void):FlxButton
	{
		AssetKludge.buttonifyAsset(Graphic);

		var button:FlxButton = new FlxButton(X, Y);
		button.loadGraphic(Graphic, true, Width, Height);
		button.animation.frameIndex = 1;
		button.allowSwiping = false;
		var filter:DropShadowFilter = new DropShadowFilter(3, 90, 0, ShadowGroup.SHADOW_ALPHA, 0, 0);
		filter.distance = 3;
		var spriteFilter:FlxFilterFramesKludge = FlxFilterFramesKludge.fromFrames(button.frames, 0, 5, [filter]);
		spriteFilter.applyToSprite(button, false, true);

		button.onDown.callback = function()
		{
			if (_grabbedCritter == null)
			{
				filter.distance = 0;
				spriteFilter.secretOffset.y = -3;
				spriteFilter.applyToSprite(button, false, true);
			}
		}

		button.onUp.callback = function()
		{
			if (_grabbedCritter == null)
			{
				button.onOut.fire();
				if (button.alpha == 1.0)
				{
					Callback();
				}
			}
		}

		button.onOut.callback = function()
		{
			if (_grabbedCritter == null)
			{
				filter.distance = 3;
				spriteFilter.secretOffset.y = 0;
				spriteFilter.applyToSprite(button, false, true);
			}
		}
		return button;
	}

	/**
	 * Finds a group of idle bugs.
	 *
	 * @param	count the number of critters to return
	 */
	public function findIdleCritters(count:Int):Array<Critter>
	{
		var start:Int = FlxG.random.int(0, _critters.length - 1);
		var result:Array<Critter> = [];

		for (i in 0..._critters.length)
		{
			var j = (i + start) % _critters.length;
			var critter:Critter = _critters[j];
			if (!critter._targetSprite.isOnScreen())
			{
				continue;
			}
			if (critter._targetSprite.immovable || !critter.idleMove)
			{
				// don't return critters which are contained somewhere
				continue;
			}
			if (critter.isIdle())
			{
				result.push(critter);
			}
		}
		FlxG.random.shuffle(result);
		result.splice(count, result.length - count);
		return result;
	}

	public function getIdleCritterCount():Int
	{
		var count:Int = 0;
		for (critter in _critters)
		{
			if (critter._targetSprite.isOnScreen() && critter._bodySprite.animation.name == "idle")
			{
				if (critter._targetSprite.immovable || !critter.idleMove)
				{
					continue;
				}
				count++;
			}
		}
		return count;
	}

	public function findIdleCritter(?colorIndex:Int):Critter
	{
		var start:Int = FlxG.random.int(0, _critters.length - 1);

		for (i in 0..._critters.length)
		{
			var j = (i + start) % _critters.length;
			var critter:Critter = _critters[j];
			if (colorIndex != null && critter.getColorIndex() != colorIndex)
			{
				continue;
			}
			if (!critter._targetSprite.isOnScreen())
			{
				continue;
			}
			if (critter._targetSprite.immovable || !critter.idleMove)
			{
				continue;
			}
			if (critter.isIdle())
			{
				return critter;
			}
		}
		return null;
	}

	public function updateSexyTimer(elapsed:Float):Void
	{
		if (PlayerData.sfw)
		{
			// sfw mode; no sexy animations
		}
		else if (PlayerData.pokemonLibido == 1)
		{
			// disabling pokemon libido also disables sexy animations
		}
		else {
			_globalSexyTimer -= elapsed;
		}
		if (_globalSexyTimer <= 0)
		{
			var annoyingAnimationConstant:Float = [0, 0, 0.25, 0.5, 1.0, 1.95, 3.10, 4.5][PlayerData.pegActivity];

			var map:Map<String,Float> = new Map<String,Float>();
			map["global-sexy-rimming-into-doggy"] = 1 * annoyingAnimationConstant;
			map["global-sexy-rimming-take-turns-and-doggy"] = 1 * annoyingAnimationConstant;
			map["global-sexy-doggy-then-rim"] = 1 * annoyingAnimationConstant;

			map["global-sexy-doggy"] = 1 * annoyingAnimationConstant;
			map["global-sexy-doggy-blitz"] = 1 * annoyingAnimationConstant;
			map["global-sexy-doggy-spank"] = 1 * annoyingAnimationConstant;
			map["global-sexy-doggy-gangbang"] = 1 * annoyingAnimationConstant;

			map["global-sexy-rimming"] = 1 * annoyingAnimationConstant;
			map["global-sexy-rimming-take-turns"] = 1 * annoyingAnimationConstant;
			map["global-sexy-rimming-waggle"] = 1 * annoyingAnimationConstant;
			map["global-sexy-rimming-race"] = 1 * annoyingAnimationConstant;

			map["global-sexy-mutual-masturbate"] = 1 * annoyingAnimationConstant;
			map["global-sexy-mutual-masturbate-then-blowjob"] = 1 * annoyingAnimationConstant;
			map["global-sexy-blowjob"] = 2 * annoyingAnimationConstant;
			map["global-sexy-blowjob-and-jerk"] = 0.5 * annoyingAnimationConstant;
			map["global-sexy-blowjob-and-watersports"] = 1 * annoyingAnimationConstant;
			map["global-sexy-trade-blowjobs"] = 1 * annoyingAnimationConstant;
			map["global-sexy-multi-blowjob"] = 1 * annoyingAnimationConstant;

			map["global-sexy-blowjob-then-doggy"] = 1 * annoyingAnimationConstant;
			map["global-sexy-doggy-then-blowjob"] = 1 * annoyingAnimationConstant;

			// by default, the "sexy noop" will happen 30% of the time...
			map["global-sexy-noop"] = [5.8, 5.8, 3.2, 1.8, 1.0, 0.6, 0.3, 0.2][PlayerData.pokemonLibido] * (11 * 0.429);

			var sexyAnimName:String = BetterFlxRandom.getObjectWithMap(map);
			SexyAnims.playGlobalAnim(this, sexyAnimName);
		}
	}

	public function addChest():Chest
	{
		var chest:Chest = null;
		for (i in 0..._chests.length)
		{
			if (_chests[i] == null || _chests[i]._chestSprite == null)
			{
				// chest has been recycled
				chest = new Chest();
				_chests[i] = chest;
				break;
			}
		}
		if (chest == null)
		{
			chest = new Chest();
			_chests.push(chest);
		}
		_midSprites.add(chest._chestSprite);
		return chest;
	}

	public function emitGems(chest:Chest)
	{
		var gemCount:Int = 0;
		if (PlayerData.detailLevel == PlayerData.DetailLevel.VeryLow)
		{
			// up to 15 gems from a chest
			gemCount += Std.int(Math.min(5, Math.ceil(chest._reward / 30)));
			gemCount += Std.int(Math.min(5, Math.ceil(chest._reward / 75)));
			gemCount += Std.int(Math.min(5, Math.floor(chest._reward / 180)));
		}
		else if (PlayerData.detailLevel == PlayerData.DetailLevel.Low)
		{
			// up to 25 gems from a chest
			gemCount += Std.int(Math.min(8, Math.ceil(chest._reward / 25)));
			gemCount += Std.int(Math.min(6, Math.ceil(chest._reward / 100)));
			gemCount += Std.int(Math.min(6, Math.floor(chest._reward / 200)));
			gemCount += Std.int(Math.min(5, Math.floor(chest._reward / 400)));
		}
		else
		{
			// up to 35 gems from a chest
			gemCount += Std.int(Math.min(12, Math.ceil(chest._reward / 20)));
			gemCount += Std.int(Math.min(8, Math.ceil(chest._reward / 80)));
			gemCount += Std.int(Math.min(8, Math.floor(chest._reward / 160)));
			gemCount += Std.int(Math.min(7, Math.floor(chest._reward / 320)));
		}

		if (chest._chestSprite == null)
		{
			/*
			 * Chest has already been destroyed? I've never seen this
			 * behavior, but it could account for crashes people are seeing
			 */
		}
		else
		{
			for (i in 0...gemCount)
			{
				emitGem(chest._chestSprite.x + chest._chestSprite.width / 2 + FlxG.random.float( -10, 10), chest._chestSprite.y + chest._chestSprite.height / 2 + FlxG.random.float( -3, 3), chest.z);
			}
		}
	}

	public function emitGem(x:Float, y:Float, z:Float):Gem
	{
		var gem:Gem = _gems[_gemIndex++% _gems.length];
		gem.reset(x, y);
		gem.velocity.x = FlxG.random.float( -100, 100);
		gem.velocity.y = FlxG.random.float( -36, 36);
		gem.z = z + 20;
		gem.groundZ = 0;
		gem.zVelocity = FlxG.random.float(80, 120);
		gem.lifespan = FlxG.random.float(2, 3);
		gem.onEmit();
		_midSprites.remove(gem);
		_midSprites.add(gem);
		return gem;
	}

	public function eventShowCashWindow(args:Dynamic):Void
	{
		_cashWindow.show();
	}
}