package poke.sexy;

import MmStringTools.*;
import ReservoirMeter.ReservoirStatus;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import kludge.AssetKludge;
import kludge.FlxFilterFramesKludge;
import kludge.FlxSoundKludge;
import kludge.LateFadingFlxParticle;
import openfl.filters.DropShadowFilter;
import openfl.utils.Object;
import poke.abra.AbraSexyState;
import poke.buiz.BuizelSexyState;
import poke.grim.GrimerSexyState;
import poke.grov.GrovyleSexyState;
import poke.hera.HeraSexyState;
import poke.luca.LucarioSexyState;
import poke.luca.LucarioSexyWindow;
import poke.magn.MagnSexyState;
import poke.rhyd.RhydonSexyState;
import poke.sand.SandslashSexyState;
import poke.sexy.SexyState;
import poke.sexy.WordManager.Qord;
import poke.smea.SmeargleSexyState;

/**
 * Logic for sex sequences.
 *
 * Encompasses graphical elements such as the PokeWindow, sweat, jizz, words
 * and buttons.
 *
 * Also encompasses logic which is common to all sex sequences. The player
 * first talks to the Pokemon, and the Pokemon has some heart reservoirs which
 * are full. The player interacts with the Pokemon and if they do a good job,
 * these hearts might be emitted or doubled or tripled. When the reservoirs are
 * near-empty, the Pokemon has an orgasm and shoots off the remaining hearts.
 * Then they talk to the player again.
 */
class SexyState<T:PokeWindow> extends FlxTransitionableState
{
	public static var RUB_CHECK_FREQUENCY:Float = 0.5;
	private static var _satelliteWidth:Int = 1;

	// toggles to false if the player's in a state where toys should be unresponsive (e.g dialogging)
	public static var canInteractWithToy:Bool = true;

	public static var TOY_BUTTON_POSITIONS:Array<FlxPoint> = [
				FlxPoint.get(5, 5),
				FlxPoint.get(5, 105),
				FlxPoint.get(92, 55),
				FlxPoint.get(5, 205),
				FlxPoint.get(92, 155),
			];
	// when using a sex toy, pokemon get bored very slowly... but how slowly?
	public static var TOY_TIME_DILATION = 0.3;

	private var _dialogger:Dialogger;
	public var _dialogTree:DialogTree;
	public var _armsAndLegsArranger:ArmsAndLegsArranger;

	// minimum cum rate; any less than this and we'll blink it on/off for a dribble effect
	public var minCumRate:Float = 0.16;

	// all traits are 0-9... 23 points to spend
	// volume; how much do they cum
	private static var cumTraits0:Array<Float> = [0.50, 0.60, 0.70, 0.80, 0.90, 1.00, 1.25, 1.50, 1.75, 2.00];
	private var cumTrait0 = 5;
	// force; how hard do they shoot
	private static var cumTraits1:Array<Float> = [0.42, 0.50, 0.60, 0.71, 0.84, 1.00, 1.20, 1.42, 1.69, 2.00];
	private var cumTrait1 = 5;
	// heartbeat; how long do they pause between cums
	private static var cumTraits2:Array<Float> = [0.64, 0.75, 0.86, 0.97, 1.08, 1.20, 1.40, 1.60, 1.80, 2.00];
	private var cumTrait2 = 5;
	// duration; how long is each pulse? little plips or long fwooshes?
	private static var cumTraits3:Array<Float> = [0.10, 0.12, 0.15, 0.18, 0.22, 0.28, 0.38, 0.50, 0.65, 0.90];
	private var cumTrait3 = 5;
	// longevity; how long does the entire sequence last
	private static var cumTraits4:Array<Float> = [0.90, 0.75, 0.60, 0.50, 0.45, 0.40, 0.36, 0.32, 0.28, 0.25];
	private var cumTrait4 = 5;

	/**
	 * 100 = chat message
	 * 200 = massage state/jerking off state
	 * 400 = done ejaculating
	 * 410 = outro message
	 * 420 = super done
	 */
	public var _gameState:Int = 200;
	private var _stateTimer:Float = 0;

	public var sfxEncouragement:Array<FlxSoundAsset> = []; // short sfx which are played when you're doing normal stuff
	public var sfxPleasure:Array<FlxSoundAsset> = []; // medium-length sfx which are played when the pokemon really likes what you're doing
	public var sfxOrgasm:Array<FlxSoundAsset> = []; // long sfx which are played when the pokemon orgasms

	public var _idlePunishmentTimer:Float = 0; // when this counts down to 0, the pokemon will feel bored that you're not doing anything
	public var _idlePunishmentDelay:Float = 1.5;
	private var _rubRewardTimer:Float = 0;
	private var _rubRewardFrequency:Float = 3.1; // the pokemon can emit hearts every 3 seconds or so. this is the exact interval in seconds
	private var _minRubForReward = 3; // the pokemon will only emit hearts if you rub them this many times in one interval
	private var _newHeadTimer:Float = 1.5; // when this counts down to 0, the pokemon will move their head
	public var _headTimerFactor = 1.0; // if this is set to 2.0 or 3.0, the pokemon will only move their head one-half or one-third as often.
	private var _rubCheckTimer:Float = 0; // when this counts down to 0, we will check where the player's mouse is and what they're clicking. (it's expensive to check, we don't want to do it that often)
	private var _clickedDuration:Float = 0;
	private var _clickedSpot:FlxPoint;

	private var _fancyRub:Bool = false;

	/*
	 * When the player clicks something special like an ass or a foot, we use
	 * a special sprite animation which speeds up or slows down based on how
	 * fast they click. There's an animation for the glove, an animation for
	 * the body part they're clicking, and sometimes an animation for a
	 * secondary nearby body part which is affected indirectly.
	 */
	public var _rubHandAnim:FancyAnim; // current glove animation
	public var _rubBodyAnim:FancyAnim; // current body part animation
	public var _rubBodyAnim2:FancyAnim; // current secondary body part animation

	/*
	 * When the player clicks and holds the mouse to pet the pokemon, we enact
	 * a speed limit to help it feel more realistic.
	 *
	 * handDragSpeed is the speed limit in pixels-per-second
	 */
	public var handDragSpeed:Float = 100;

	public var _pokeWindow:T;
	public var _activePokeWindow:PokeWindow; // the currently active window, which might be a toy window
	private var _denDestination:String = null; // in the den, we might transition from sex right back into sex, or back into the store. this keeps track of our next destination

	private var _hud:FlxGroup;
	private var _buttonGroup:FlxGroup = new FlxGroup();
	private var _cameraButtonGroup:FlxGroup = new FlxGroup();
	private var _backSprites:FlxGroup = new FlxGroup();
	private var _frontSprites:FlxTypedGroup<FlxSprite>;

	private var _handTween:FlxTween;
	private var _interactTween:FlxTween;
	private var _toyInteractTween:FlxTween;
	private var _prevHandAnim:String;
	public var _handSprite:FlxSprite;

	/*
	 * These three satellites are tiny sprites which sit in fixed positions
	 * around the mouse cursor as the mouse moves. When we're just petting a
	 * pokemon and showing the generic petting animation, these sprites are
	 * used to determine whether the hand tilts to the left or to the right.
	 */
	private var _nwSatellite:FlxSprite;
	public var _cSatellite:FlxSprite;
	private var _neSatellite:FlxSprite;
	public var _satelliteDistance:FlxPoint = FlxPoint.get(40, 20);

	public var _backButton:FlxButton;

	/*
	 * Pokemon have a finite amount of hearts they can emit during foreplay and
	 * sex. This heartBank field keeps track of how many hearts are left
	 */
	public var _heartBank:HeartBank;
	public var totalHeartsEmitted:Float = 0;

	/*
	 * Pokemon have a finite amount of extra hearts they can emit during sex
	 * toy sequences. This toyBank field keeps track of how many extra hearts
	 * are left
	 */
	public var _toyBank:HeartBank;

	/*
	 * When the Pokemon falls below a certain percent of their foreplay heart
	 * reservoir, they get a boner (or start showing arousal in other ways)
	 */
	public var _bonerThreshold:Float = 0.44;

	/*
	 * When the Pokemon falls below a certain percent of their "dick reservoir"
	 * they have an orgasm
	 */
	public var _cumThreshold:Float = 0.44;

	private var wordManager:WordManager = new WordManager();

	private var _heartGroup:FlxTypedGroup<LateFadingFlxParticle>; // heart graphics
	public var _heartEmitCount:Float = 0; // the total value of hearts emitted this session; used for determining the popularity of Heracross's videos
	private var _heartEmitTimer:Float = 0; // hearts won't be emitted until this counts down to 0
	private var _heartSpriteCount:Float = 0; // how many heart sprites were emitted this session; used for graphical purposes
	private var _rubSfxTimer:Float = 0; // when this counts down to 0, a rubbing sound effect will play
	private var _characterSfxTimer:Float = 0; // a pokemon won't make noise until this counts down to 0
	private var _characterSfxFrequency:Float = 4; // how often a pokemon should make noise, in seconds

	public var specialRubs:Array<String> = []; // "special rubs" the player has performed in the past
	public var specialRub:String = ""; // "special rub" the player is performing right now
	private var rubSoundCount:Int = 0;

	private var dickAngleArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>(); // position and angle for emitting jizz. despite the word "dick" this applies to both male and female characters
	public var _blobbyGroup:BlobbyGroup; // spooge/sweat graphics
	private var _fluidEmitter:FlxEmitter; // emits particles which get rendered into spooge/sweat
	private var _spoogeKludge:FlxSprite; // if we don't include a tiny sprite near the urethra, spooge looks like it's being magically generated near the genitals instead of squirting out of the genitals
	private var _cumShots:Array<Cumshot> = []; // queue of cumshots scheduled in advance during an orgasm, or when precumming
	private var _pentUpCum:Float = 0; // when precumming, emitting 1 particle every second or two won't show anything at all, after being processed by BlobbyGroup. we save up those particles and emit a bunch at once so they're visible
	private var _pentUpCumAccumulating:Bool = false; // true if we're saving up precum; false if we're emitting it

	/*
	 * "shadow glove" covers up cum, so cum doesn't appear in front of our
	 * glove when we're wrist deep in a vagina
	 */
	private var _shadowGlove:BouncySprite;
	public var _shadowGloveBlackGroup:BlackGroup;

	private var _multipleOrgasmDiminishment = 0.9; // for multiple orgasms, the second and third orgasms will be weaker
	private var _isOrgasming:Bool = false;
	public var _remainingOrgasms = 1;

	public var _breathGroup:FlxTypedGroup<BreathParticle>;
	private var breathAngleArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>(); // Position and angle for emitting breath poofs
	private var _breathlessCount:Int = FlxG.random.int(-2, 1); // how many reward cycles have we gone without emitting a breath poof?
	private var _breathTimer:Float = 0; // when this counts down to 0, we'll emit a breath poof

	private var _autoSweatRate:Float = 0;
	private var _autoSweatTimer:Float = FlxG.random.float(0.5, 1);
	private var _sweatTimer:Float = 0;
	private var _sweatCount:Int = 0;

	/**
	 * "dick" is used to ejaculate, and there is some logic for erections
	 * rising/falling. Despite the word "dick", this applies to both male and
	 * female characters
	 */
	private var _dick:BouncySprite;
	private var _head:BouncySprite; // the sprite which exhales poofs of air

	private var encouragementWords:Qord; // phrases the pokemon says when you do something they like
	private var pleasureWords:Qord; // phrases the pokemon says when you do something they REALLY like
	private var almostWords:Qord; // phrases the pokemon says when they're about to have an orgasm
	private var orgasmWords:Qord; // phrases the pokemon says when they have an orgasm
	private var boredWords:Qord; // phrases the pokemon says when bored
	public var superBoredWordCount:Int = 2; // number drawn-out, "super bored" phrases this character has in boredWords

	private var sweatAreas:Array<SweatArea> = []; // area or areas which can emit sweat
	public var _male:Bool = false;

	private var came:Bool = false; // has the pokemon has had at least one orgasm?
	private var _oldCameraPosition:FlxPoint = FlxPoint.get(0, 0);

	private var _otherWindows:Array<PokeWindow> = [];
	private var mouseTiming:Array<Float> = [];
	public var eventStack:EventStack = new EventStack();

	public var _toyButtons:FlxGroup;
	/*
	 * Sex toy buttons have meters on them. This map keeps track of which meter
	 * goes with which button, so we can remove them when removing the button
	 */
	private var buttonToMeterMap:Map<FlxButton, ReservoirMeter> = new Map<FlxButton, ReservoirMeter>();
	private var _toyOffButton:FlxButton;
	public var toyButtonsEnabled:Bool = true;
	public var toyStartWords:Qord;
	public var toyInterruptWords:Qord;
	public var toyGroup:FlxGroup = new FlxGroup();
	public var _heartEmitFudgeFloor = 0.3; // when emitting hearts, a value of 1.0 will consistently emit the biggest hearts possible.

	private var _streamButton:FlxButton;
	private var _streamCloseButton:FlxSprite;
	private var _tablet:Tablet;
	public var popularity:Float = 0; // ranges from -1.0 (very unpopular) to 1.0 (very popular) and affects tablet numbers

	override public function create():Void
	{
		if (PlayerData.cursorSmellTimeRemaining > 0)
		{
			doCursorSmellPenalty();
		}
		var bonusCapacity:Int = computeBonusCapacity();
		_heartBank = new HeartBank(30 + bonusCapacity, foreplayFactor());
		_toyBank = new HeartBank(80 + computeBonusToyCapacity(), toyForeplayFactor());
		if (!_male)
		{
			cumTraits4 = [0.99, 0.95, 0.90, 0.84, 0.77, 0.69, 0.60, 0.50, 0.49, 0.37];
		}

		super.create();
		_pokeWindow.setArousal(0);

		_backSprites = new FlxGroup();
		add(_backSprites);
		_backSprites.add(LevelState.newBackdrop());
		_hud = new FlxGroup();
		add(_hud);
		_frontSprites = new FlxTypedGroup<FlxSprite>();
		add(_frontSprites);

		_hud.add(_pokeWindow);
		_hud.add(_buttonGroup);
		_hud.add(_cameraButtonGroup);

		_backButton = newBackButton(back, _dialogTree);
		_buttonGroup.add(_backButton);

		addCameraButtons();

		_dialogger = new Dialogger();
		_hud.add(_dialogger);

		_handSprite = new FlxSprite(100, 100);
		_frontSprites.add(_handSprite);
		wordManager._handSprite = _handSprite;

		_neSatellite = new FlxSprite();
		_neSatellite.makeGraphic(_satelliteWidth, _satelliteWidth, FlxColor.MAGENTA);
		_neSatellite.visible = false;
		_neSatellite.offset.x = _neSatellite.offset.y = _satelliteWidth;
		_frontSprites.add(_neSatellite);

		_nwSatellite = new FlxSprite();
		_nwSatellite.makeGraphic(_satelliteWidth, _satelliteWidth, FlxColor.CYAN);
		_nwSatellite.visible = false;
		_nwSatellite.offset.x = _nwSatellite.offset.y = _satelliteWidth;
		_frontSprites.add(_nwSatellite);

		_cSatellite = new FlxSprite();
		_cSatellite.makeGraphic(_satelliteWidth, _satelliteWidth, FlxColor.GREEN);
		_cSatellite.visible = false;
		_cSatellite.offset.x = _cSatellite.offset.y = _satelliteWidth;
		_frontSprites.add(_cSatellite);

		_blobbyGroup = new BlobbyGroup(0, _male ? 0xFFFFEE : 0xFFFFDD, 0x20, _male ? 0xAA : 0x55);
		if (!_male)
		{
			_blobbyGroup._shineOpacity = 0xEE;
		}

		_idlePunishmentDelay = _rubRewardFrequency / 2;

		// Create the particle emitter
		_fluidEmitter = new FlxEmitter(0, 0, 410);

		for (i in 0..._fluidEmitter.maxSize)
		{
			var particle:SubframeParticle = new SubframeParticle();
			// these pre-blurred blobs were made by rendering a 3x3 white rectangle, then gaussian blurring it in a 6 pixel radius
			particle.loadGraphic(AssetPaths.fuzzy_circle_6__png);
			particle.exists = false;
			_fluidEmitter.add(particle);
		}

		// turn off emitter rotations?
		_fluidEmitter.angularVelocity.start.set(0);
		_fluidEmitter.acceleration.start.set(new FlxPoint(0, 600 * 2));
		_fluidEmitter.start(false, 1.0, 0x0FFFFFFF);
		_fluidEmitter.emitting = false;
		_spoogeKludge = new FlxSprite();
		_spoogeKludge.loadGraphic(AssetPaths.fuzzy_circle_6__png);
		_blobbyGroup.add(_spoogeKludge);
		_blobbyGroup.add(_fluidEmitter);

		_shadowGlove = new BouncySprite(0, 0, 0, 0, 0, 0);
		_shadowGloveBlackGroup = new BlackGroup();
		_shadowGloveBlackGroup.add(_shadowGlove);

		reinitializeHandSprites();

		add(_blobbyGroup);

		_armsAndLegsArranger = new ArmsAndLegsArranger(_pokeWindow);

		add(wordManager);

		_heartGroup = new FlxTypedGroup<LateFadingFlxParticle>();
		add(_heartGroup);

		_breathGroup = new FlxTypedGroup<BreathParticle>();
		add(_breathGroup);

		// initialize words to non-null value to avoid NPEs for unfinished SexyState subclasses
		orgasmWords = wordManager.newWords();
		pleasureWords = wordManager.newWords();
		encouragementWords = wordManager.newWords();
		boredWords = wordManager.newWords();
		toyInterruptWords = wordManager.newWords();
		toyStartWords = wordManager.newWords();

		AssetKludge.buttonifyAsset(AssetPaths.toy_off_button__png);
		
		_toyOffButton = new FlxButton();
		_toyOffButton.loadGraphic(AssetPaths.toy_off_button__png);

		{
			var toyHandStamp:FlxSprite = new FlxSprite();
			CursorUtils.initializeCustomHandBouncySprite(toyHandStamp, AssetPaths.toy_off_hand__png, 96, 96);
			_toyOffButton.stamp(toyHandStamp, 0, 0);
		}

		prepareBackButton(toyOffButtonEvent, _toyOffButton, _dialogTree);
		_toyOffButton.setPosition(TOY_BUTTON_POSITIONS[0].x, TOY_BUTTON_POSITIONS[0].y);

		_toyButtons = new FlxGroup();
		_backSprites.add(_toyButtons);

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_STREAMING_PACKAGE))
		{
			_streamButton = newBackButton(streamButtonEvent, AssetPaths.tablet_button__png, _dialogTree);
			_streamButton.setPosition(667, 5);
			_backSprites.add(_streamButton);

			_tablet = new Tablet(this);
			_tablet.visible = false;
			_hud.insert(_hud.members.indexOf(_dialogger), _tablet);

			_streamCloseButton = new FlxSprite(734, 116);
			_streamCloseButton.loadGraphic(AssetPaths.tablet_close_button__png, true, 30, 30);
			_streamCloseButton.exists = false;
			_hud.insert(_hud.members.indexOf(_tablet) + 1, _streamCloseButton);
		}

		// launch the dialog
		var tree:Array<Array<Object>> = generateSexyBeforeDialog();

		showEarlyDialog(tree);

		initializeHitBoxes();

		// pre-load any pokemon who enter, so that the game doesn't pause mid-dialog
		if (PlayerData.detailLevel == PlayerData.DetailLevel.VeryLow)
		{
			// don't preload; low memory
		}
		else {
			for (t in tree)
			{
				if (t != null && Std.isOfType(t[0], String) && cast(t[0], String).substring(0, 6) == "%enter")
				{
					PokeWindow.fromString(cast(t[0], String).substring(6, cast(t[0], String).length - 1));
				}
			}
		}
	}

	function doCursorSmellPenalty()
	{
		var reservoir:Int = Reflect.field(PlayerData, _pokeWindow._prefix + "Reservoir");
		var newReservoir:Int = reservoir - cursorSmellPenaltyAmount();
		if (newReservoir < 0)
		{
			_heartEmitCount += newReservoir;
			newReservoir = 0;
		}
		else if (newReservoir > 210)
		{
			newReservoir = 210;
		}
		else
		{
		}
		Reflect.setField(PlayerData, _pokeWindow._prefix + "Reservoir", newReservoir);
	}

	/*
	 * 0-39: power through the smell
	 * 40-59: short break
	 * 60-70: leave
	 */
	function cursorSmellPenaltyAmount():Int
	{
		return 40;
	}

	function showEarlyDialog(tree:Array<Array<Object>>)
	{
		if (_gameState == 200)
		{
			// no dialog in state 200... the pokemon will get bored while you talk
			setState(100);
		}
		_idlePunishmentTimer = -5;
		_pokeWindow.resize(248, 349);
		_backButton.visible = false;
		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();
	}

	function addCameraButtons()
	{
		_cameraButtonGroup.kill();
		_cameraButtonGroup.clear();
		_cameraButtonGroup.revive();
		for (button in _activePokeWindow._cameraButtons)
		{
			var _cameraButton:FlxButton = newButton(button.image, button.x + _pokeWindow.x, button.y + _pokeWindow.y, 28, 28, button.callback);
			_cameraButtonGroup.add(_cameraButton);
		}
	}

	public function prepare(prefix:String):Void
	{
		if (PlayerData.detailLevel == PlayerData.DetailLevel.Low || PlayerData.detailLevel == PlayerData.DetailLevel.VeryLow)
		{
			// clear cached bitmap assets to save memory
			FlxG.bitmap.dumpCache();
		}

		if (PlayerData.level < 3)
		{
			// should only be here on level 3... otherwise pokewindows won't display right
			PlayerData.level = 3;
		}
		Main.overrideFlxGDefaults();
		this._male = Reflect.field(PlayerData, prefix + "Male");
		if (prefix == "luca")
		{
			_pokeWindow = cast(new poke.luca.LucarioSexyWindow(256, 0, 248, 426));
		}
		else {
			_pokeWindow = cast(PokeWindow.fromString(prefix, 256, 0, 248, 426));
		}
		_activePokeWindow = _pokeWindow;
		_dick = _pokeWindow._dick;
		_head = _pokeWindow._head;
	}

	function dialogTreeCallback(Msg:String):String
	{
		if (Msg == "%den-game%" || Msg == "%den-sex%" || Msg == "%den-quit%")
		{
			_denDestination = Msg;
		}
		if (Msg.substring(0, 5) == "%fun-")
		{
			/*
			 * Dialog strings like %fun-nude2% have an effect on a
			 * PokemonWindow instance. PokemonWindow subclasses can override
			 * the doFun method to define special behavior, such as taking off
			 * a Pokemon's hat, having them give a thumbs up or make a silly
			 * face.
			 */
			_pokeWindow.doFun(Msg.substring(5, Msg.length - 1));
		}
		if (Msg.substring(0, 6) == "%enter")
		{
			if (PlayerData.detailLevel == PlayerData.DetailLevel.VeryLow)
			{
				// low memory; don't enter
			}
			else
			{
				var newWindow:PokeWindow;
				if (_otherWindows.length == 0)
				{
					newWindow = PokeWindow.fromString(substringBetween(Msg, "%enter", "%"), 512, 0, 248, 325);
				}
				else
				{
					newWindow = PokeWindow.fromString(substringBetween(Msg, "%enter", "%"), 0, 0, 248, 349);
				}
				newWindow.setNudity(0);
				_hud.insert(0, newWindow);
				_otherWindows.push(newWindow);
			}
		}
		if (Msg.substring(0, 5) == "%exit")
		{
			var window:PokeWindow = _otherWindows.pop();
			_hud.remove(window);
			FlxDestroyUtil.destroy(window);
		}
		if (Msg == "%cursor-normal%")
		{
			PlayerData.cursorType = "default";
			reinitializeHandSprites();
		}
		if (Msg == "")
		{
			// done; remove any remaining hud windows
			while (_otherWindows.length > 0)
			{
				var window:PokeWindow = _otherWindows.pop();
				_hud.remove(window);
				FlxDestroyUtil.destroy(window);
			}
			if (_gameState == 100)
			{
				setState(200);
				// if someone exits without finishing the minigame, we still want to rotate chat.
				// we don't want them to get the same "hey why didn't you do this last time" message
				// again and again
				rotateSexyChat();
			}
			else
			{
				if (PlayerData.playerIsInDen)
				{
					if (_denDestination == "%den-sex%")
					{
						// automatically restart game in den...
						back();
						return null;
					}
				}
				setState(420);
			}
			_pokeWindow.resize(248, 426);
			_backButton.visible = true;
		}
		return null;
	}

	/**
	 * Can be overridden for subclasses who need to do something special when rotating chat
	 *
	 * @param	badThings a list of possible complaints the pokemon has
	 */
	public function rotateSexyChat(?badThings:Array<Int>):Void
	{
		LevelIntroDialog.rotateSexyChat(this, badThings);
	}

	public function reinitializeHandSprites()
	{
		// initialize cursor
		CursorUtils.initializeSystemCursor();

		// initialize hand
		CursorUtils.initializeHandSprite(_handSprite, AssetPaths.hands__png);
		_handSprite.animation.add("default", [0]);
		_handSprite.animation.add("rub-right", [4, 5, 6], 6, true);
		_handSprite.animation.add("rub-center", [8, 9, 10], 6, true);
		_handSprite.animation.add("rub-left", [12, 13, 14], 6, true);
		_handSprite.setSize(3, 3);
		_handSprite.offset.set(69, 87);

		// initialize pokewindow's interact
		_pokeWindow.reinitializeHandSprites();

		// initialize toy window's interact
		if (getToyWindow() != null)
		{
			getToyWindow().reinitializeHandSprites();
		}

		// initialize "shadow hand" for females
		if (PlayerData.cursorType == "none")
		{
			_shadowGlove.makeGraphic(1, 1, FlxColor.TRANSPARENT);
			_shadowGlove.alpha = 0.75;
			_shadowGlove.visible = false;
			_blobbyGroup.remove(_shadowGloveBlackGroup);
		}
		else
		{
			_shadowGlove.loadGraphicFromSprite(_pokeWindow._interact);
			_shadowGlove.alpha = 0.75;
			_shadowGlove.visible = false;
			if (!_male)
			{
				_blobbyGroup.add(_shadowGloveBlackGroup);
			}
		}
	}

	function setState(state:Int)
	{
		_gameState = state;
		_stateTimer = 0;
	}

	override public function destroy():Void
	{
		super.destroy();

		_dialogger = FlxDestroyUtil.destroy(_dialogger);
		_dialogTree = FlxDestroyUtil.destroy(_dialogTree);
		_satelliteDistance = FlxDestroyUtil.put(_satelliteDistance);

		sfxEncouragement = null;
		sfxPleasure = null;
		sfxOrgasm = null;

		_clickedSpot = FlxDestroyUtil.put(_clickedSpot);

		_rubBodyAnim = null;
		_rubBodyAnim2 = null;
		_rubHandAnim = null;

		_pokeWindow = FlxDestroyUtil.destroy(_pokeWindow);
		_hud = FlxDestroyUtil.destroy(_hud);
		_buttonGroup = FlxDestroyUtil.destroy(_buttonGroup);
		_cameraButtonGroup = FlxDestroyUtil.destroy(_cameraButtonGroup);
		_backSprites = FlxDestroyUtil.destroy(_backSprites);
		_frontSprites = FlxDestroyUtil.destroy(_frontSprites);

		_handTween = FlxTweenUtil.destroy(_handTween);
		_interactTween = FlxTweenUtil.destroy(_interactTween);
		_toyInteractTween = FlxTweenUtil.destroy(_toyInteractTween);
		_handSprite = FlxDestroyUtil.destroy(_handSprite);
		_nwSatellite = FlxDestroyUtil.destroy(_nwSatellite);
		_cSatellite = FlxDestroyUtil.destroy(_cSatellite);
		_neSatellite = FlxDestroyUtil.destroy(_neSatellite);
		_backButton = FlxDestroyUtil.destroy(_backButton);

		wordManager = FlxDestroyUtil.destroy(wordManager);
		_heartGroup = FlxDestroyUtil.destroy(_heartGroup);

		_blobbyGroup = FlxDestroyUtil.destroy(_blobbyGroup);
		_fluidEmitter = FlxDestroyUtil.destroy(_fluidEmitter);
		_spoogeKludge = FlxDestroyUtil.destroy(_spoogeKludge);
		_breathGroup = FlxDestroyUtil.destroy(_breathGroup);
		_shadowGlove = FlxDestroyUtil.destroy(_shadowGlove);
		_shadowGloveBlackGroup = FlxDestroyUtil.destroy(_shadowGloveBlackGroup);

		_oldCameraPosition = FlxDestroyUtil.put(_oldCameraPosition);
		_otherWindows = FlxDestroyUtil.destroyArray(_otherWindows);

		eventStack = null;

		_toyButtons = FlxDestroyUtil.destroy(_toyButtons);
		_toyOffButton = FlxDestroyUtil.destroy(_toyOffButton);
		toyGroup = FlxDestroyUtil.destroy(toyGroup);
		_streamButton = FlxDestroyUtil.destroy(_streamButton);
		_streamCloseButton = FlxDestroyUtil.destroy(_streamCloseButton);
		_tablet = FlxDestroyUtil.destroy(_tablet);
	}

	public function moveParticlesWithCamera():Void
	{
		for (particle in _fluidEmitter.members)
		{
			if (particle.alive && particle.exists)
			{
				particle.x -= _activePokeWindow.cameraPosition.x - _oldCameraPosition.x;
				particle.y -= _activePokeWindow.cameraPosition.y - _oldCameraPosition.y;
			}
		}
		for (particle in _breathGroup.members)
		{
			if (particle.alive && particle.exists)
			{
				particle.x -= _activePokeWindow.cameraPosition.x - _oldCameraPosition.x;
				particle.y -= _activePokeWindow.cameraPosition.y - _oldCameraPosition.y;
			}
		}
	}

	public function killParticles():Void
	{
		for (particle in _fluidEmitter.members)
		{
			if (particle.alive && particle.exists)
			{
				particle.kill();
			}
		}
		for (particle in _breathGroup.members)
		{
			if (particle.alive && particle.exists)
			{
				particle.kill();
			}
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		PlayerData.updateTimePlayed();
		if (FlxG.mouse.justPressed && !displayingToyWindow())
		{
			PlayerData.updateCursorVisible();
		}
		_stateTimer += elapsed;
		_characterSfxTimer -= elapsed;
		eventStack.update(elapsed);

		if (!_activePokeWindow.cameraPosition.equals(_oldCameraPosition))
		{
			moveParticlesWithCamera();
			_activePokeWindow.cameraPosition.copyTo(_oldCameraPosition);
		}
		// hide the cum/sweat layer if the character is invisible
		if (_activePokeWindow._partAlpha == 1 && !_blobbyGroup.visible)
		{
			_blobbyGroup.visible = true;
		}
		else if (_activePokeWindow._partAlpha == 0 && _blobbyGroup.visible)
		{
			_blobbyGroup.visible = false;
		}

		if (DialogTree.isDialogging(_dialogTree))
		{
			_buttonGroup.visible = false;
			SexyState.canInteractWithToy = false;
		}
		else {
			_buttonGroup.visible = true;
			SexyState.canInteractWithToy = true;
		}
		if (_gameState == 100 || _gameState == 410 || _dialogger._handledClick)
		{
			_handSprite.setPosition(FlxG.mouse.x, FlxG.mouse.y);
		}
		else {
			if (_activePokeWindow._breakTime > 0)
			{
				// taking a break... don't allow interaction or graphical stuff. just move the mouse
				_handSprite.setPosition(FlxG.mouse.x, FlxG.mouse.y);
				_handSprite.animation.play("default");
			}
			else {
				sexyStuff(elapsed);
				sprayJizz(elapsed);
			}
		}

		emitHearts(elapsed);

		var _handAnim = _activePokeWindow._interact.visible ? _activePokeWindow._interact.animation.name : _handSprite.animation.name;
		if (_prevHandAnim != _handAnim)
		{
			if (_handAnim == "default")
			{
				_handTween = FlxTweenUtil.retween(_handTween, _handSprite, {alpha:PlayerData.cursorMaxAlpha}, 0.6);
				_interactTween = FlxTweenUtil.retween(_interactTween, _activePokeWindow._interact, {alpha:PlayerData.cursorMaxAlpha}, 0.6);
			}
			else
			{
				_handTween = FlxTweenUtil.retween(_handTween, _handSprite, {alpha:PlayerData.cursorMinAlpha}, 0.6);
				_interactTween = FlxTweenUtil.retween(_interactTween, _activePokeWindow._interact, {alpha:PlayerData.cursorMinAlpha}, 0.6);
			}
			_prevHandAnim = _handAnim;
		}

		if (_streamCloseButton != null && _streamCloseButton.exists)
		{
			// visible?
			_streamCloseButton.visible = isPointDistanceToMouseWithin(663, 65, 100) || isPointDistanceToMouseWithin(749, 131, 50);

			// clicked?
			_streamCloseButton.animation.frameIndex = isPointDistanceToMouseWithin(749, 131, 20) ? 1 : 0;
			if (_streamCloseButton.visible && _streamCloseButton.animation.frameIndex == 1 && FlxG.mouse.justPressed)
			{
				hideStreamEvent();
			}
		}
	}

	private function isPointDistanceToMouseWithin(x:Float, y:Float, r:Float)
	{
		var dx:Float = x - FlxG.mouse.x;
		var dy:Float = y - FlxG.mouse.y;

		return dx * dx + dy * dy < r * r;
	}

	public function sexyStuff(elapsed:Float):Void
	{
		if (displayingToyWindow())
		{
			handleToyWindow(elapsed);
		}

		// Maybe play rubby sound?
		_rubSfxTimer += elapsed;
		if (_handSprite.animation.name != null && _handSprite.animation.name.substring(0, 4) == "rub-")
		{
			if (_rubSfxTimer > 0)
			{
				_rubSfxTimer -= 0.4;
				playRubSound();
			}
		}
		else {
			_rubSfxTimer = Math.min(0, _rubSfxTimer);
		}

		if (isEjaculating())
		{
			// we don't want rubRewardTimer to get out of control following a long ejaculation sequence
			_rubRewardTimer = 0;
			// won't get bored while ejaculating, and will wait a little while after we finish
			if (_remainingOrgasms == 0)
			{
				_idlePunishmentTimer = _idlePunishmentDelay - 0.5;
			}
			else
			{
				_idlePunishmentTimer = _rubRewardFrequency * FlxG.random.float( -0.83, -1.20) + _idlePunishmentDelay;
			}
		}

		// Maybe reward/punish hearts?
		handleOrgasmReward(elapsed);
		if (_gameState >= 200 && _gameState <= 400)
		{
			if (_rubRewardTimer < 0)
			{
				_rubRewardTimer = Math.min(0, _rubRewardTimer + elapsed);
			}
			else
			{
				if (displayingToyWindow())
				{
					// toy window visible; boredom is handled differently
				}
				else if (_pokeWindow._breakTime > 0)
				{
					// pokemon is on break; shouldn't get bored
				}
				else
				{
					if (isInteracting())
					{
						_rubRewardTimer += elapsed;
						if (_rubRewardTimer > _rubRewardFrequency / 2)
						{
							if (rubSoundCount < _minRubForReward)
							{
								// they're technically interacting but not doing very much
								if (penetrating())
								{
									// if they're penetrating it's OK to go a little slow
									if (rubSoundCount == 0)
									{
										_rubRewardTimer -= _rubRewardFrequency / 2;
									}
								}
								else
								{
									_idlePunishmentTimer += _rubRewardFrequency / 2;
									_rubRewardTimer -= _rubRewardFrequency / 2;
								}
							}
							else
							{
								// actively rubbing
								_idlePunishmentTimer = 0;
							}
							rubSoundCount = 0;
						}
					}
					else
					{
						// Not interacting
						_rubRewardTimer = 0;
						_idlePunishmentTimer += elapsed;
					}
				}

				if (_idlePunishmentTimer > _idlePunishmentDelay)
				{
					if (_gameState == 200 && came)
					{
						// Player stopped interacting with us after we came
						endSexyStuff();
					}
					else if (!_heartBank.isFull() && !_heartBank.isEmpty())
					{
						if (shouldEndSexyGame())
						{
							// pokemon doesn't get bored, the game is ending right now
						}
						else
						{
							// AFK? Pokemon gets bored
							_idlePunishmentTimer = _rubRewardFrequency * FlxG.random.float( -0.83, -1.20) + _rubRewardFrequency / 2;
							boredStuff();
						}
					}
				}
			}
		}

		if (_gameState >= 400)
		{
			_autoSweatRate -= 0.08 * elapsed;
		}
		_autoSweatRate = FlxMath.bound(_autoSweatRate, 0, 1.0);
		_autoSweatTimer = Math.max(0, _autoSweatTimer - elapsed * _autoSweatRate);
		if (_autoSweatTimer <= 0)
		{
			var sweatCount:Int = FlxG.random.int(2, 4);
			scheduleSweat(sweatCount);
			_autoSweatTimer += FlxG.random.float(0.3, 0.6) * sweatCount;
		}

		_sweatTimer = Math.max(0, _sweatTimer - elapsed);
		if (_sweatTimer <= 0 && _sweatCount > 0)
		{
			if (FlxG.random.float() < 0.1)
			{
				// extra 11% sweatiness; this counteracts the default 10% chance that sweat isn't emitted
			}
			else
			{
				_sweatCount--;
			}
			_sweatTimer += FlxG.random.float(0.2, 0.4);
			emitSweat();
		}

		if (shouldEndSexyGame())
		{
			// the pokemon has ejaculated, and emitted his "happiness remainder" and the player has stopped interacting
			interactOff();
			_clickedSpot = null;
			_handSprite.animation.play("default");
			setState(410);

			_pokeWindow.resize(248, 349);
			_backButton.visible = false;
			if (PlayerData.playerIsInDen)
			{
				PlayerData.denTotalReward += totalHeartsEmitted;
				PlayerData.denSexCount++;
			}
			var tree:Array<Array<Object>> = generateSexyAfterDialog();
			_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
			_dialogTree.go();

			var badThings = new Array<Int>();
			computeChatComplaints(badThings);
			rotateSexyChat(badThings);
		}

		updateHead(elapsed);

		_armsAndLegsArranger.update(elapsed);

		updateHand(elapsed);

		if (_gameState == 200)
		{
			if (!displayingToyWindow() && _rubRewardTimer > _rubRewardFrequency / 2)
			{
				_rubRewardTimer = _rubRewardFrequency * FlxG.random.float( -0.83, -1.20) + _rubRewardFrequency / 2;
				if (specialRub != null)
				{
					specialRubs.push(specialRub);
					specialRubs.splice(0, specialRubs.length - 100);
				}
				handleRubReward();
			}
		}

		if (_breathTimer > 0)
		{
			_breathTimer -= elapsed;
			if (_head != null && _breathTimer <= 0)
			{
				emitBreath();
			}
		}
	}

	function shouldEndSexyGame():Bool
	{
		return _gameState == 400 && _heartBank.isEmpty() && _heartEmitCount <= 0 && (_idlePunishmentTimer > _rubRewardFrequency / 2);
	}

	public function isInteracting():Bool
	{
		return _pokeWindow._interact.visible || (_handSprite.animation.name != null && _handSprite.animation.name.substring(0, 4) == "rub-");
	}

	/**
	 * Can be overridden if there's unusual dialog
	 */
	public function generateSexyBeforeDialog():Array<Array<Object>>
	{
		return LevelIntroDialog.generateSexyBeforeDialog(this);
	}

	/**
	 * Can be overridden if there's unusual dialog
	 */
	public function generateSexyAfterDialog<T:PokeWindow>():Array<Array<Object>>
	{
		return LevelIntroDialog.generateSexyAfterDialog(this);
	}

	function boredStuff():Void
	{
		if (!pastBonerThreshold() || _heartBank._dickHeartReservoir == _heartBank._dickHeartReservoirCapacity)
		{
			var amount = SexyState.roundUpToQuarter(FlxG.random.float(0.03 * _heartBank._foreplayHeartReservoirCapacity, 0.06 * _heartBank._foreplayHeartReservoirCapacity));
			_heartBank._foreplayHeartReservoirCapacity = Math.max(_heartBank._foreplayHeartReservoir, _heartBank._foreplayHeartReservoirCapacity - amount);
		}
		var amount = SexyState.roundUpToQuarter(FlxG.random.float(0.03 * _heartBank._dickHeartReservoirCapacity, 0.06 * _heartBank._dickHeartReservoirCapacity));
		_heartBank._dickHeartReservoirCapacity = Math.max(_heartBank._dickHeartReservoir, _heartBank._dickHeartReservoirCapacity - amount);
		_autoSweatRate = Math.max(0, _autoSweatRate - 0.08);
		if (wordManager.consecutiveWords(boredWords))
		{
			maybeEmitWords(boredWords);
		}
		else {
			maybeEmitWords(boredWords, 0, superBoredWordCount);
		}
	}

	function emitHearts(elapsed:Float):Void
	{
		if (_heartEmitCount > 0)
		{
			_heartEmitTimer -= elapsed;
			if (_heartEmitTimer < 0)
			{
				FlxSoundKludge.play(AssetPaths.heart_blip__mp3, 0.3);
				_heartEmitTimer = Math.max(0, _heartEmitTimer + 0.08);
				var heartParticle:LateFadingFlxParticle = _heartGroup.recycle(LateFadingFlxParticle);
				if (heartParticle.graphic == null)
				{
					heartParticle.loadGraphic(AssetPaths.sexy_hearts__png, true, 40, 40);
					heartParticle.exists = false;
				}

				var _heartEmitX = Math.abs(_heartSpriteCount % 60 - 30) / 30 * (504 - 256) + 256 - 20 - 25;
				heartParticle.reset(_heartEmitX, 75 + (_heartSpriteCount % 2) * 10 - 5);
				heartParticle.alpha = 1;
				heartParticle.velocity.y = -30;
				heartParticle.lifespan = 2.5;
				heartParticle.enableLateFade(5);
				FlxTween.tween(heartParticle, { x : heartParticle.x + 50 }, 2.5, { ease: tripleSineInOut } );
				_heartSpriteCount++;
				var random:Float = Math.ceil(FlxG.random.float(_heartEmitFudgeFloor * _heartEmitCount, 1.0 * _heartEmitCount) * 4) / 4.0;
				if (random >= 4)
				{
					heartParticle.animation.frameIndex = 3;
					_heartEmitCount -= 4;
					totalHeartsEmitted += 4;
				}
				else if (random >= 1)
				{
					heartParticle.animation.frameIndex = 2;
					_heartEmitCount -= 1;
					totalHeartsEmitted += 1;
				}
				else
				{
					heartParticle.animation.frameIndex = 1;
					_heartEmitCount -= 0.25;
					totalHeartsEmitted += 0.25;
				}

				_heartGroup.sort(LevelState.byYNulls);
			}
		}
	}

	public static inline function tripleSineInOut(t:Float):Float
	{
		return -Math.cos(Math.PI * t * 3) / 2 + .5;
	}

	public static function roundUpToQuarter(v:Float):Float
	{
		return Math.ceil(v * 4) / 4.0;
	}

	public static function roundDownToQuarter(v:Float):Float
	{
		return Math.floor(v * 4) / 4.0;
	}

	public static function newBackButton(Callback:Void->Void, asset:FlxGraphicAsset=AssetPaths.back_button__png, ?dialogTree:DialogTree):FlxButton
	{
		AssetKludge.buttonifyAsset(asset);

		var button:FlxButton = new FlxButton();
		button.loadGraphic(asset);
		return prepareBackButton(Callback, button, dialogTree);
	}

	private static function prepareBackButton(Callback:Void->Void, button:FlxButton, ?dialogTree:DialogTree):FlxButton
	{
		button.allowSwiping = false;
		button.setPosition(FlxG.width - button.width - 6, FlxG.height - button.height - 6);
		var filter:DropShadowFilter = new DropShadowFilter(3, 90, 0, ShadowGroup.SHADOW_ALPHA, 0, 0);
		filter.distance = 3;
		var spriteFilter:FlxFilterFramesKludge = FlxFilterFramesKludge.fromFrames(button.frames, 0, 5, [filter]);
		spriteFilter.applyToSprite(button, false, true);

		button.onDown.callback = function()
		{
			if (DialogTree.isDialogging(dialogTree))
			{
				return;
			}
			filter.distance = 0;
			spriteFilter.secretOffset.y = -3;
			spriteFilter.applyToSprite(button, false, true);
		}

		button.onUp.callback = function()
		{
			if (DialogTree.isDialogging(dialogTree))
			{
				return;
			}
			button.onOut.fire();
			if (Callback != null)
			{
				Callback();
			}
		}

		button.onOut.callback = function()
		{
			if (DialogTree.isDialogging(dialogTree))
			{
				return;
			}
			filter.distance = 3;
			spriteFilter.secretOffset.y = 0;
			spriteFilter.applyToSprite(button, false, true);
		}
		return button;
	}

	public function newToyButton(Callback:Void->Void, asset:FlxGraphicAsset, dialogTree:DialogTree):FlxButton
	{
		return newBackButton(new ToyCallback(this, Callback).doCall, asset, dialogTree);
	}

	public static function getSexyState():SexyState<Dynamic>
	{
		if (PlayerData.profIndex == 0)
		{
			return new AbraSexyState();
		}
		else if (PlayerData.profIndex == 1)
		{
			return new BuizelSexyState();
		}
		else if (PlayerData.profIndex == 2)
		{
			return new HeraSexyState();
		}
		else if (PlayerData.profIndex == 3)
		{
			return new GrovyleSexyState();
		}
		else if (PlayerData.profIndex == 4)
		{
			return new SandslashSexyState();
		}
		else if (PlayerData.profIndex == 5)
		{
			return new RhydonSexyState();
		}
		else if (PlayerData.profIndex == 6)
		{
			return new SmeargleSexyState();
		}
		else if (PlayerData.profIndex == 8)
		{
			return new MagnSexyState();
		}
		else if (PlayerData.profIndex == 9)
		{
			return new GrimerSexyState();
		}
		else if (PlayerData.profIndex == 10)
		{
			return new LucarioSexyState();
		}
		else {
			// default to abra
			return new AbraSexyState();
		}
	}

	public function back():Void
	{
		if (PlayerData.pokemonLibido == 1)
		{
			// with cookies maxed out, we feed the dickHeartReservoir back into some bonuses they can actually use...
			var foreplayCapacityPct:Float = _heartBank._foreplayHeartReservoir / _heartBank._foreplayHeartReservoirCapacity;
			if (!Math.isFinite(foreplayCapacityPct))
			{
				foreplayCapacityPct = 0;
			}
			// if they used up 50% of the foreplay capacity, we use up 50% of the dick reservoir...
			var newDickReservoir:Float = _heartBank._dickHeartReservoirCapacity * foreplayCapacityPct;
			if (_heartBank._dickHeartReservoir > newDickReservoir)
			{
				// feed it into critter bonus
				PlayerData.reimburseCritterBonus(Math.floor(_heartBank._dickHeartReservoir - newDickReservoir));
				_heartBank._dickHeartReservoir = newDickReservoir;
			}
		}

		// reduce pokemon's libido
		var bonusCapacity:Int = computeBonusCapacity();
		var bonusToyCapacity:Int = computeBonusToyCapacity();
		var bankCapacityPct:Float = (_heartBank._dickHeartReservoir + _heartBank._foreplayHeartReservoir) / (_heartBank._dickHeartReservoirCapacity + _heartBank._foreplayHeartReservoirCapacity);
		var bankToyCapacityPct:Float = (_toyBank._dickHeartReservoir + _toyBank._foreplayHeartReservoir) / (_toyBank._dickHeartReservoirCapacity + _toyBank._foreplayHeartReservoirCapacity);
		if (!Math.isFinite(bankCapacityPct))
		{
			bankCapacityPct = 0;
		}
		if (!Math.isFinite(bankToyCapacityPct))
		{
			bankToyCapacityPct = 0;
		}
		var bonusReservoirUsed:Int = Math.ceil((1 - bankCapacityPct) * bonusCapacity);
		var bonusToyReservoirUsed:Int = Math.ceil((1 - bankToyCapacityPct) * bonusToyCapacity);
		var reservoir:Int = Reflect.field(PlayerData, _pokeWindow._prefix + "Reservoir");
		var toyReservoir:Int = Reflect.field(PlayerData, _pokeWindow._prefix + "ToyReservoir");
		var newReservoir:Int = Std.int(FlxMath.bound(reservoir - bonusReservoirUsed, 0, reservoir));
		var newToyReservoir:Int = Std.int(FlxMath.bound(toyReservoir - bonusToyReservoirUsed, 0, toyReservoir));
		var bonusDeductionAmount:Int = Math.ceil(newReservoir * (0.5 - bankCapacityPct / 2));
		newReservoir -= bonusDeductionAmount;
		PlayerData.reservoirReward += bonusDeductionAmount;

		Reflect.setField(PlayerData, _pokeWindow._prefix + "Reservoir", newReservoir);
		Reflect.setField(PlayerData, _pokeWindow._prefix + "ToyReservoir", newToyReservoir);
		if (totalHeartsEmitted >= 5)
		{
			PlayerData.addPokeVideo({name:_pokeWindow._name, reward:totalHeartsEmitted, male:_male});
			if (videoWasDirty())
			{
				PlayerData.videoStatus = PlayerData.VideoStatus.Dirty;
			}
			else if (PlayerData.videoStatus == PlayerData.VideoStatus.Empty)
			{
				PlayerData.videoStatus = PlayerData.VideoStatus.Clean;
			}
		}

		var newState:FlxState;
		if (PlayerData.playerIsInDen)
		{
			if (_denDestination == "%den-sex%")
			{
				if (PlayerData.sfw)
				{
					// skip sexystate; sfw mode
					newState = new ShopState(MainMenuState.fadeInFast());
					transOut = MainMenuState.fadeOutSlow();
				}
				else
				{
					// sex
					newState = SexyState.getSexyState();
				}
			}
			else
			{
				// shop
				newState = new ShopState(MainMenuState.fadeInFast());
				transOut = MainMenuState.fadeOutSlow();
			}
		}
		else {
			newState = new MainMenuState(MainMenuState.fadeInFast());
			transOut = MainMenuState.fadeOutSlow();
		}
		FlxG.switchState(newState);
	}

	/**
	 * Heracross has slightly different comments for dirty videos and clean
	 * videos. "Dirty" usually means the pokemon orgasmed, but this can be
	 * overridden for Pokemon where it means something else.
	 *
	 * Technically if you just play with a Rhydon's cock and balls for 45
	 * minutes while he sweats and moans and doesn't orgasm, it's not a
	 * dirty video. Maybe it's just a medical examination...?
	 *
	 * @return true if the video should be treated as "porn" by Heracross
	 */
	function videoWasDirty():Bool
	{
		return came;
	}

	function updateHand(elapsed:Float):Void
	{
		if (displayingToyWindow())
		{
			// window is not being displayed; don't interact
			return;
		}
		if (_fancyRub)
		{
			if (!FlxG.mouse.pressed && _clickedSpot.distanceTo(FlxG.mouse.getWorldPosition()) > 25)
			{
				interactOff();
			}
			else
			{
				_rubBodyAnim.update(elapsed);
				if (_rubBodyAnim2 != null)
				{
					_rubBodyAnim2.update(elapsed);
				}
				_rubHandAnim.update(elapsed);
				if (_rubHandAnim.sfxLength > 0)
				{
					playRubSound();
				}
			}

			checkSpecialRub(null);
		}
		else {
			if (!FlxG.mouse.pressed)
			{
				_clickedDuration = 0;
				_clickedSpot = null;
			}

			if (_clickedSpot == null)
			{
				// did the user just click something interactable?
				if (FlxG.mouse.justPressed)
				{
					_clickedSpot = FlxG.mouse.getWorldPosition();
					_rubCheckTimer = RUB_CHECK_FREQUENCY;
				}
			}

			if (_clickedSpot != null)
			{
				_clickedDuration += elapsed;
				var mousePosition:FlxPoint = FlxG.mouse.getWorldPosition();
				var mouseDist:Float = mousePosition.distanceTo(_clickedSpot);
				if (mouseDist > 1)
				{
					var dx:Float = (mousePosition.x - _clickedSpot.x) * elapsed * handDragSpeed / mouseDist;
					var dy:Float = (mousePosition.y - _clickedSpot.y) * elapsed * handDragSpeed / mouseDist;

					// this limiting logic prevents the clickedSpot from jumping past the mousePosition
					_clickedSpot.x = dx > 0 ? Math.min(mousePosition.x, _clickedSpot.x + dx) : Math.max(mousePosition.x, _clickedSpot.x + dx);
					_clickedSpot.y = dy > 0 ? Math.min(mousePosition.y, _clickedSpot.y + dy) : Math.max(mousePosition.y, _clickedSpot.y + dy);
				}
				_handSprite.setPosition(_clickedSpot.x, _clickedSpot.y);
				_cSatellite.setPosition(_clickedSpot.x, _clickedSpot.y);
				_neSatellite.setPosition(_clickedSpot.x + _satelliteDistance.x, _clickedSpot.y - _satelliteDistance.y);
				_nwSatellite.setPosition(_clickedSpot.x - _satelliteDistance.x, _clickedSpot.y - _satelliteDistance.y);

				var rubCheck:Bool = false;
				_rubCheckTimer += elapsed;
				if (_rubCheckTimer > RUB_CHECK_FREQUENCY || FlxG.mouse.justPressed)
				{
					rubCheck = true;
					_rubCheckTimer -= RUB_CHECK_FREQUENCY;
				}

				if (rubCheck)
				{
					var touchedPart:FlxSprite = getTouchedPart();

					if (touchedPart == null)
					{
						_clickedSpot = null;
					}
					else
					{
						var handledTouch:Bool = touchPart(touchedPart);

						if (!handledTouch)
						{
							playMundaneRubAnim(touchedPart);
						}
					}
					specialRub = "";
					checkSpecialRub(touchedPart);
				}
			}
			else {
				endMundaneRub();
			}
		}
		syncShadowGlove(_shadowGlove, _pokeWindow._interact);
	}

	public function syncShadowGlove(shadowSprite:BouncySprite, sourceSprite:BouncySprite):Void
	{
		if (shadowSprite.visible)
		{
			shadowSprite.synchronize(sourceSprite);
			/*
			 * If the glove is a little transparent, the ShadowGlove is really transparent. We want to see jizz behind the glove.
			 */
			shadowSprite.alpha = Math.pow(sourceSprite.alpha, 2);
			shadowSprite.x = sourceSprite.x + 3;
			shadowSprite.y += 3;
			shadowSprite.animation.frameIndex = sourceSprite.animation.frameIndex;
		}
	}

	function endMundaneRub():Void
	{
		_handSprite.setPosition(FlxG.mouse.x, FlxG.mouse.y);
		_handSprite.animation.play("default");
	}

	function playMundaneRubAnim(touchedPart:FlxSprite):Void
	{
		var touchingNe:Bool = FlxG.pixelPerfectOverlap(_neSatellite, touchedPart, 32);
		var touchingNw:Bool = FlxG.pixelPerfectOverlap(_nwSatellite, touchedPart, 32);
		if (touchingNe && touchingNw)
		{
			_handSprite.animation.play("rub-center");
		}
		else if (touchingNe || !touchingNw && _cSatellite.x < _pokeWindow.x + _pokeWindow.width / 2)
		{
			_handSprite.animation.play("rub-left");
		}
		else {
			_handSprite.animation.play("rub-right");
		}
	}

	/**
	 * Overridden to define certain rubs as "special rubs". These rubs are
	 * given a name like "rub-left-pec" and the player might be rewarded or
	 * penalized for it
	 *
	 * @param	touchedPart sprite which the player is clicking
	 */
	public function checkSpecialRub(touchedPart:FlxSprite):Void
	{
	}

	/**
	 * Overridden to initialize various "hit boxes" -- places the player can
	 * click to trigger an action.
	 *
	 * This is also a good place to initialize words and sweat areas and other
	 * stuff which only needs to be initialized once after the sprites are
	 * loaded
	 *
	 * Subclasses will typically use this method to define "polyArrays",
	 * defining parts of a pokemon like "Abra's forehead" for example. A
	 * Pokemon might move their head, causing their forehead to change
	 * location. So the "polyArray" parameter includes a polygon for every
	 * frame index into the sprite. If the sprite has 60 frames, there will be
	 * 60 different polygonal regions showing where the forehead is in each of
	 * the 60 frames.
	 */
	public function initializeHitBoxes():Void
	{
	}

	/**
	 * Override to handle a touched part in a special way (gripping, probing, whatever)
	 *
	 * @param	touchedPart The part that was touched
	 * @return True if we handled it in a special way
	 */
	public function touchPart(touchedPart:FlxSprite):Bool
	{
		return false;
	}

	/**
	 * Override to handle letting go of a part in a special way
	 *
	 * @param	touchedPart The part that was touched
	 */
	public function untouchPart(touchedPart:FlxSprite):Void
	{
		if (_gameState >= 400 && _dick != null && touchedPart == _dick)
		{
			if (_dick.animation.getByName("finished") != null)
			{
				_dick.animation.play("finished");
				_dick.animation.curAnim.curFrame = _dick.animation.curAnim.numFrames - 1;
			}
		}
	}

	function getTouchedPart():BouncySprite
	{
		var touchedPart:FlxSprite = null;
		var minDist:Float = FlxG.width;
		for (_cameraButton in _activePokeWindow._cameraButtons)
		{
			var dist:Float = FlxPoint.get(_activePokeWindow.x + _cameraButton.x + 14, _activePokeWindow.y + _cameraButton.y + 14).distanceTo(FlxG.mouse.getPosition());
			minDist = Math.min(dist, minDist);
		}
		if (minDist <= 30)
		{
			// clicking camera button?
			return null;
		}
		return cast(_activePokeWindow.getOverlappedPart(_cSatellite), BouncySprite);
	}

	function interactOn(spr:BouncySprite, handAnimName:String, ?bodyAnimName:String):Void
	{
		_fancyRub = true;
		_rubBodyAnim = new FancyAnim(spr, bodyAnimName != null ? bodyAnimName : handAnimName);
		_rubHandAnim = new FancyAnim(_pokeWindow._interact, handAnimName);
		_pokeWindow._interact.visible = true;
		_shadowGlove.visible = true;
		_pokeWindow._interact.synchronize(spr);
		_handSprite.visible = false;
		_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.members.indexOf(spr) + 1);
	}

	function interactOff():Void
	{
		_handSprite.animation.play("default");
		if (!_fancyRub)
		{
			return;
		}
		_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.members.length);
		var oldAnimatedSprite:FlxSprite = _rubBodyAnim._flxSprite;
		if (shouldInteractOff(_rubBodyAnim._flxSprite))
		{
			_rubBodyAnim._flxSprite.animation.play("default");
		}
		if (_rubBodyAnim2 != null)
		{
			if (shouldInteractOff(_rubBodyAnim2._flxSprite))
			{
				_rubBodyAnim2._flxSprite.animation.play("default");
			}
		}
		_pokeWindow._interact.visible = false;
		_shadowGlove.visible = false;
		_handSprite.visible = true;
		_fancyRub = false;
		_rubBodyAnim = null;
		_rubBodyAnim2 = null;
		_rubHandAnim = null;
		untouchPart(oldAnimatedSprite);
	}

	/**
	 * Normally when the player stops touching a sprite, it snaps back to
	 * normal. This can be overridden if it shouldn't snap back to normal
	 * right away
	 *
	 * @param	targetSprite sprite which is being interacted with
	 * @return	true if the sprite should "snap back to normal"
	 */
	function shouldInteractOff(targetSprite:FlxSprite):Bool
	{
		return true;
	}

	public function precum(amount:Float):Void
	{
		if (PlayerData.pokemonLibido == 1)
		{
			// don't emit precum at pokemon libido level 1
			return;
		}

		var tmpAmount:Float = amount + FlxG.random.float( -0.5, 0.5);
		pushCumShot( { force : 0, rate : 0, duration : FlxG.random.float(0, 1.5), arousal:-1 } );
		pushCumShot( { force : 0.15, rate : 0.045 * tmpAmount, duration : 0.1 * tmpAmount, arousal:-1 } );
		pushCumShot( { force : 0.10, rate : 0.035 * tmpAmount, duration : 0.2 * tmpAmount, arousal:-1 } );
		pushCumShot( { force : 0.05, rate : 0.025 * tmpAmount, duration : 0.3 * tmpAmount, arousal:-1 } );
	}

	function pastBonerThreshold():Bool
	{
		return _heartBank.getForeplayPercent() <= _bonerThreshold;
	}

	/**
	 * Determines if the player clicked a certain part of a sprite, e.g a
	 * Pokemon's forehead.
	 *
	 * A Pokemon might move their head, causing their forehead to change
	 * location. So the "polyArray" parameter includes a polygon for every
	 * frame index into the sprite. If the sprite has 60 frames, there will be
	 * 60 different polygonal regions showing where the forehead is in each of
	 * the 60 frames.
	 *
	 * @param	touchedPart body part which is being checked
	 * @param	polyArray polygons which define a specific region of the body
	 *       	part
	 * @param	clickPosition point which was clicked
	 * @return	true if the clicked point is within the specified polygon,
	 *        	relative to the specified body part's location
	 */
	function clickedPolygon(touchedPart:FlxSprite, polyArray:Array<Array<FlxPoint>>, ?clickPosition:FlxPoint = null):Bool
	{
		var poly:Array<FlxPoint> = polyArray[touchedPart.animation.frameIndex];
		var p:FlxPoint;
		if (clickPosition != null)
		{
			p = FlxPoint.get(clickPosition.x - touchedPart.x + touchedPart.offset.x, clickPosition.y - touchedPart.y + touchedPart.offset.y);
		}
		else {
			p = FlxPoint.get(FlxG.mouse.x - touchedPart.x + touchedPart.offset.x, FlxG.mouse.y - touchedPart.y + touchedPart.offset.y);
		}
		var result:Bool = polygonContainsPoint(poly, p);
		p.put();
		return result;
	}

	public static function polygonContainsPoint(poly:Array<FlxPoint>, test:FlxPoint):Bool
	{
		if (poly == null)
		{
			return false;
		}
		var i:Int = 0;
		var j:Int = poly.length - 1;
		var c:Bool = false;
		while (i < poly.length)
		{
			if (((poly[i].y > test.y) != (poly[j].y > test.y)) &&
			(test.x < (poly[j].x - poly[i].x) * (test.y - poly[i].y) / (poly[j].y - poly[i].y) + poly[i].x))
			{
				c = !c;
			}

			j = i++;
		}
		return c;
	}

	/**
	 * Some Pokemon care about how fast/slow you press and release the mouse.
	 * This method can be overridden for the mouse timing to be recorded to
	 * the mouseTiming field.
	 *
	 * @return true if mouse timing should be recorded
	 */
	function shouldRecordMouseTiming():Bool
	{
		return false;
	}

	public static function average(arr:Array<Float>):Float
	{
		var total:Float = 0;
		for (item in arr)
		{
			total += item;
		}
		return total / arr.length;
	}

	/**
	 * Returns true if the mouse was just pressed, and the toy should be receptive to mouse clicks
	 */
	public static function toyMouseJustPressed()
	{
		return FlxG.mouse.justPressed && canInteractWithToy;
	}

	public function playRubSound():Void
	{
		rubSoundCount++;
		if (shouldRecordMouseTiming())
		{
			mouseTiming.push(_rubHandAnim.sfxLength);
		}
		if (_fancyRub)
		{
			if (_rubHandAnim.sfxLength > 0.6)
			{
				SoundStackingFix.play(FlxG.random.getObject([AssetPaths.rub0_slowa__mp3, AssetPaths.rub0_slowb__mp3, AssetPaths.rub0_slowc__mp3]), 0.10);
			}
			else if (_rubHandAnim.sfxLength > 0.25)
			{
				SoundStackingFix.play(FlxG.random.getObject([AssetPaths.rub0_mediuma__mp3, AssetPaths.rub0_mediumb__mp3, AssetPaths.rub0_mediumc__mp3]), 0.10);
			}
			else
			{
				SoundStackingFix.play(FlxG.random.getObject([AssetPaths.rub0_fasta__mp3, AssetPaths.rub0_fastb__mp3, AssetPaths.rub0_fastc__mp3]), 0.10);
			}
		}
		else {
			SoundStackingFix.play(FlxG.random.getObject([AssetPaths.rub0_mediuma__mp3, AssetPaths.rub0_mediumb__mp3, AssetPaths.rub0_mediumc__mp3]), 0.10);
		}
	}

	public function sprayJizz(elapsed:Float)
	{
		/*
		 * Debug keys;
		 *
		 * Z = emit about 10% of the Pokemon's hearts (pressing this 5-6 times will make them orgasm)
		 * shift+Z = trigger a "nice thing" multiplier for the Pokemon
		 * O = trace info on heart reservoirs
		 * P = continuous stream of jizz
		 * X = emit sweat
		 * shift+R = reset the scene from the start
		 */
		#if debug
		if (FlxG.keys.justPressed.Z)
		{
			// avoid triggering boredom
			rubSoundCount = 6;
			if (FlxG.keys.pressed.SHIFT)
			{
				// shift-Z: trigger nice thing
				doNiceThing();
			}
			else
			{
				_newHeadTimer = 0;
				var emitted:Float = 0;
				if (!pastBonerThreshold())
				{
					emitted = Math.min(_heartBank._foreplayHeartReservoir, roundDownToQuarter(0.2 * _heartBank._foreplayHeartReservoirCapacity));
					_heartBank._foreplayHeartReservoir -= emitted;
				}
				else
				{
					emitted = Math.min(_heartBank._dickHeartReservoir, roundDownToQuarter(0.2 * _heartBank._dickHeartReservoirCapacity));
					_heartBank._dickHeartReservoir -= emitted;
				}
				_heartEmitCount += emitted;
			}
		}
		if (FlxG.keys.justPressed.O)
		{
			_heartBank.traceInfo();
		}
		if (FlxG.keys.justPressed.P)
		{
			trace("total hearts: " + totalHeartsEmitted);
			if (_cumShots.length > 0)
			{
				_cumShots.splice(0, _cumShots.length);
			}
			else
			{
				pushCumShot( { force : 1.0, rate : 1.0, duration : 600, arousal:-1 } );
			}
		}
		if (_cumShots.length > 0)
		{
			if (FlxG.keys.justPressed.Q)
			{
				_cumShots[0].force += 0.05;
				trace(_cumShots[0]);
			}
			if (FlxG.keys.justPressed.A)
			{
				_cumShots[0].force -= 0.05;
				trace(_cumShots[0]);
			}
			if (FlxG.keys.justPressed.W)
			{
				_cumShots[0].rate += 0.005;
				trace(_cumShots[0]);
			}
			if (FlxG.keys.justPressed.S)
			{
				_cumShots[0].rate -= 0.005;
				trace(_cumShots[0]);
			}
		}
		if (FlxG.keys.justPressed.P)
		{
			if (_head != null)
			{
				emitBreath();
			}
		}
		if (FlxG.keys.justPressed.X)
		{
			emitSweat();
		}
		if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.R)
		{
			PlayerData.profIndex = PlayerData.PROF_PREFIXES.indexOf(_pokeWindow._prefix);
			var sexyState:SexyState<Dynamic> = SexyState.getSexyState();
			FlxG.switchState(sexyState);
			return;
		}
		#end

		var spoogeEmitter:FlxEmitter = getSpoogeEmitter();
		if (_cumShots.length > 0)
		{
			handleCumShots(elapsed);
		}
		else
		{
			spoogeEmitter.emitting = false;
		}
		_spoogeKludge.visible = spoogeEmitter == _fluidEmitter && spoogeEmitter.emitting;
	}

	function getSpoogeEmitter():FlxEmitter
	{
		return _fluidEmitter;
	}

	function handleCumShots(elapsed:Float):Void
	{
		_cumShots[0].duration -= elapsed;
		if (_cumShots[0].duration <= 0)
		{
			if (_cumShots[0].arousal > -1)
			{
				if (_cumShots.length == 1 || _cumShots[1].arousal == -1)
				{
					_isOrgasming = false;
					if (_remainingOrgasms > 0)
					{
						// just finished ejaculating... but have more to go
						_heartBank._dickHeartReservoirCapacity = Math.max(1, roundDownToQuarter(0.8 * _heartBank._dickHeartReservoir / _cumThreshold));
					}
				}
			}
			_cumShots.splice(0, 1);
		}
		var spoogeEmitter:FlxEmitter = getSpoogeEmitter();
		spoogeEmitter.emitting = _cumShots.length > 0 && _cumShots[0].force > 0;
		if (spoogeEmitter.emitting && _cumShots[0].rate < minCumRate)
		{
			// cumshot rate is too low; how about a slow dribble
			_pentUpCum += _cumShots[0].rate * elapsed * 8;
			if (_pentUpCumAccumulating)
			{
				// start building up cum for a drip...
				spoogeEmitter.emitting = false;
				if (_pentUpCum + _cumShots[0].rate > minCumRate)
				{
					// drip is big enough
					_pentUpCumAccumulating = false;
				}
			}
			else
			{
				// release the drip
				spoogeEmitter.emitting = true;
				_pentUpCum -= elapsed * minCumRate * 8;
				if (_pentUpCum <= 0)
				{
					// drip is empty
					_pentUpCum = 0;
					_pentUpCumAccumulating = true;
				}
			}
		}
		if (spoogeEmitter.emitting)
		{
			var rate:Float = Math.max(_cumShots[0].rate, minCumRate);
			spoogeEmitter.frequency = rate == 0 ? 0x0FFFFFFF : 1 / (200 * rate);
			var spoogeSource:FlxSprite = getSpoogeSource();
			var spoogeAngle:Array<FlxPoint> = getSpoogeAngleArray()[spoogeSource.animation.frameIndex];
			if (spoogeAngle == null)
			{
				spoogeEmitter.emitting = false;
			}
			else
			{
				var dickPoint:FlxPoint = spoogeAngle[0];
				var dickVelocity:FlxPoint = FlxPoint.get();
				dickVelocity.copyFrom(spoogeAngle[1]);
				if (spoogeAngle.length > 2)
				{
					var dickVelocity2:FlxPoint = spoogeAngle[2];
					var ratio:Float = FlxG.random.float();
					dickVelocity.x = dickVelocity.x * ratio + dickVelocity2.x * (1 - ratio);
					dickVelocity.y = dickVelocity.y * ratio + dickVelocity2.y * (1 - ratio);
				}
				var cumSpread:Float = 0.2 + Math.min(0, (_cumShots[0].force - 1) / 2);
				spoogeEmitter.launchMode = FlxEmitterMode.SQUARE;
				spoogeEmitter.x = spoogeSource.x - spoogeSource.offset.x + dickPoint.x + 4;
				spoogeEmitter.y = spoogeSource.y - spoogeSource.offset.y + dickPoint.y + 4;
				spoogeEmitter.velocity.start.min.x = dickVelocity.x * (2 - cumSpread) * _cumShots[0].force + 20 * cumSpread;
				spoogeEmitter.velocity.start.max.x = dickVelocity.x * (2 + cumSpread) * _cumShots[0].force - 20 * cumSpread;
				spoogeEmitter.velocity.start.min.y = dickVelocity.y * (2 - cumSpread * 1.5) * _cumShots[0].force + 20 * cumSpread;
				spoogeEmitter.velocity.start.max.y = dickVelocity.y * (2 + cumSpread * 0.5) * _cumShots[0].force - 20 * cumSpread;

				if (!_male)
				{
					spoogeEmitter.velocity.start.min.x *= 0.16;
					spoogeEmitter.velocity.start.min.y *= 0.16;
					spoogeEmitter.velocity.start.max.x *= 0.16;
					spoogeEmitter.velocity.start.max.y *= 0.16;
				}

				spoogeEmitter.velocity.end.set(spoogeEmitter.velocity.start.min, spoogeEmitter.velocity.start.max);

				_spoogeKludge.x = spoogeEmitter.x;
				_spoogeKludge.y = spoogeEmitter.y;
				dickVelocity.put();
			}
		}
	}

	/**
	 * Can be overridden for Pokemon which need to emit jizz from a different
	 * sprite.
	 *
	 * This usually happens when the Pokemon drastically changes poses to use a
	 * sex toy, and a different dick sprite is temporarily visible. But it
	 * might also happen if Sandslash wants to show off his cool party trick.
	 *
	 * @return sprite which should emit jizz
	 */
	function getSpoogeSource():FlxSprite
	{
		return _dick;
	}

	function getSpoogeAngleArray():Array<Array<FlxPoint>>
	{
		return dickAngleArray;
	}

	public function updateHead(elapsed:Float):Void
	{
		_newHeadTimer -= elapsed;
		if (_newHeadTimer < 0 && canChangeHead())
		{
			if (_gameState == 200)
			{
				if (!pastBonerThreshold())
				{
					_newHeadTimer = FlxG.random.float(3, 5) * _headTimerFactor;
				}
				else
				{
					_newHeadTimer = FlxG.random.float(2, 4) * _headTimerFactor;
				}
			}
			else if (_gameState >= 400)
			{
				_newHeadTimer = FlxG.random.float(5, 8) * _headTimerFactor;
			}
			if (isEjaculating())
			{
				refreshArousalFromCumshots();
			}
			else if (_gameState == 200)
			{
				if (!_isOrgasming && shouldOrgasm())
				{
					generateCumshots();
					refreshArousalFromCumshots();
				}
				else if (_heartBank.getDickPercent() > _cumThreshold)
				{
					var arousal:Int = determineArousal();
					_activePokeWindow.nudgeArousal(arousal);
				}
				else
				{
					// done orgasming, but game hasn't ended yet (player is still interacting w/genitals)
					_activePokeWindow.nudgeArousal(0);
				}
			}
			else if (_gameState >= 400)
			{
				_activePokeWindow.nudgeArousal(0);
			}
		}
	}

	public function refreshArousalFromCumshots():Void
	{
		if (_cumShots.length > 0)
		{
			_activePokeWindow.setArousal(_cumShots[0].arousal);
		}
	}

	/**
	 * Can be overridden if a Pokemon needs to orgasm at an inappropriate time.
	 * (Looking at you, Heracross)
	 *
	 * @return true if the Pokemon should orgasm
	 */
	public function shouldOrgasm():Bool
	{
		return _heartBank.getDickPercent() <= _cumThreshold && _remainingOrgasms > 0;
	}

	/**
	 * Overridden to determine how aroused a Pokemon's expression should be
	 *
	 * 0 = not aroused, 4 = very aroused
	 *
	 * @return pokemon's arousal value
	 */
	public function determineArousal():Int
	{
		return 0;
	}

	/**
	 * Overridden to define times where the Pokemon is doing something where
	 * it would be inappropriate to smile or look away (e.g brushing their
	 * teeth)
	 *
	 * @return true if a pokemon's expression can be changed
	 */
	function canChangeHead():Bool
	{
		return true;
	}

	function emitSweat()
	{
		var skipSweatChance:Float = [1.00, 1.00, 0.80, 0.40, 0.20, 0.10, 0.05, 0.00][PlayerData.pokemonLibido];
		if (Math.isFinite(skipSweatChance) && FlxG.random.float() <= skipSweatChance)
		{
			// don't emit sweat for low/no libido
			return;
		}
		var weights:Array<Float> = [];
		for (sweatArea in sweatAreas)
		{
			weights.push(sweatArea.chance);
		}

		var sweatArea = sweatAreas[FlxG.random.weightedPick(weights)];
		if (sweatArea == null)
		{
			return;
		}

		if (sweatArea.sprite == null)
		{
			return;
		}

		if (!sweatArea.sprite.visible)
		{
			return;
		}

		var sweatArray:Array<FlxPoint> = sweatArea.sweatArrayArray[sweatArea.sprite.animation.frameIndex];
		if (sweatArray == null)
		{
			return;
		}

		var lifespan:Float = FlxG.random.float(3, 6);
		var p:FlxPoint = RandomPolygonPoint.randomPolyPoint(sweatArray);
		p.add(-sweatArea.sprite.offset.x, - sweatArea.sprite.offset.y);
		for (i in 0...6)
		{
			var newParticle:FlxParticle = _fluidEmitter.recycle(FlxParticle);
			newParticle.reset(p.x, p.y);
			newParticle.x += sweatArea.sprite.x;
			newParticle.y += sweatArea.sprite.y;
			newParticle.velocityRange.active = false;
			newParticle.accelerationRange.active = false;
			newParticle.lifespan = lifespan;
			var dx:Float = FlxG.random.float( -7, 7);
			var dy:Float = FlxG.random.float( -7, 7);
			newParticle.x += dx;
			newParticle.y += dy;
			newParticle.velocity.x = FlxG.random.float( -5, 5);
			newParticle.velocity.y = FlxG.random.float( 5, 10);
			newParticle.acceleration.y = 12 + FlxG.random.float( -4, 4);

			newParticle.alpha = 1.0;
			newParticle.alphaRange.set(1.0, 0.5);
		}
	}

	function emitBreath():Void
	{
		if (breathAngleArray[_head.animation.frameIndex] == null)
		{
			return;
		}
		var breathParticle:BreathParticle = _breathGroup.recycle(BreathParticle);
		if (breathParticle.graphic == null)
		{
			breathParticle.loadGraphic(AssetPaths.breath_puffs__png, true, 96, 96);
		}

		var breathPoint:FlxPoint = breathAngleArray[_head.animation.frameIndex][0];
		var breathVelocity:FlxPoint = breathAngleArray[_head.animation.frameIndex][1];
		breathParticle.reset(breathPoint.x, breathPoint.y);
		breathParticle.animation.frameIndex = 0;
		breathParticle.x += _head.x - _head.offset.x + 4;
		breathParticle.y += _head.y - _head.offset.y + 4;
		breathParticle.velocity.set(breathVelocity.x, breathVelocity.y);
		breathParticle.offset.y = 64;
		breathParticle.origin.y = 64;

		var angleRadians:Float = Math.atan2(breathParticle.velocity.x, -breathParticle.velocity.y);
		var angleInt:Int = (Std.int(Math.round(angleRadians * 8 / Math.PI - 0.5)) + 16) % 16;

		breathParticle.angle = Std.int((angleInt + 2) / 4) * 90;
		if (angleInt % 4 == 0 || angleInt % 4 == 3)
		{
			breathParticle.animation.frameIndex = FlxG.random.int(0, 2);
		}
		else {
			breathParticle.animation.frameIndex = FlxG.random.int(3, 5);
		}
		if (angleInt % 4 == 2 || angleInt % 4 == 3)
		{
			breathParticle.flipX = true;
			breathParticle.origin.x = 64;
			breathParticle.offset.x = 64;
		}
		else {
			breathParticle.flipX = false;
			breathParticle.offset.x = 32;
			breathParticle.origin.x = 32;
		}

		breathParticle.alpha = 0.75;

		breathParticle.drag.x = 100;
		breathParticle.drag.y = 100;
		breathParticle.lifespan = 1.2;
	}

	function emitPostOrgasmWords():Void
	{
		var qord:Qord = null;
		if (orgasmWords.timer <= 0 && _cumShots[0].arousal >= 5 && _heartEmitCount + _heartBank._dickHeartReservoir + _heartBank._foreplayHeartReservoir > 20)
		{
			qord = orgasmWords;
			orgasmWords.timer = orgasmWords.frequency;
		}
		else if (pleasureWords.timer <= 0 && _cumShots[0].arousal >= 3)
		{
			qord = pleasureWords;
			pleasureWords.timer = 2.0;
		}
		else if (encouragementWords.timer <= 0)
		{
			qord = encouragementWords;
			encouragementWords.timer = 2.0;
		}
		if (qord != null)
		{
			emitWords(qord);
		}
	}

	function handleOrgasmReward(elapsed:Float):Void
	{
		if (_gameState == 200)
		{
			if (isEjaculating())
			{
				if (_cumShots[0].duration - elapsed <= 0 && _cumShots[0].rate == 0)
				{
					var amount:Float = 0;
					var lucky:Float = lucky(0.6, 1.0, cumTraits4[cumTrait4]);
					lucky /= (_remainingOrgasms + 1);
					amount = roundUpToQuarter(lucky * _heartBank._foreplayHeartReservoir);
					_heartBank._foreplayHeartReservoir -= amount;
					_heartEmitCount += amount;
					amount = roundUpToQuarter(lucky * _heartBank._dickHeartReservoir);
					_heartBank._dickHeartReservoir -= amount;
					_heartEmitCount += amount;

					if (_heartEmitCount > 0)
					{
						if (_characterSfxTimer <= 0)
						{
							if (isEjaculating())
							{
								_characterSfxTimer = 2.0;
							}
							else
							{
								_characterSfxTimer = _characterSfxFrequency;
							}
							if (_cumShots[0].arousal >= 5)
							{
								SoundStackingFix.play(FlxG.random.getObject(sfxOrgasm), 0.4);
							}
							else if (_cumShots[0].arousal >= 3)
							{
								SoundStackingFix.play(FlxG.random.getObject(sfxPleasure), 0.4);
							}
							else
							{
								SoundStackingFix.play(FlxG.random.getObject(sfxEncouragement), 0.4);
							}
						}
						emitPostOrgasmWords();
					}
				}
			}
		}
	}

	function fancyRubbing(Sprite:FlxSprite)
	{
		return _rubBodyAnim != null &&  _rubBodyAnim._flxSprite == Sprite;
	}

	function fancyRubAnimatesSprite(Sprite:FlxSprite)
	{
		return (_rubBodyAnim != null &&  _rubBodyAnim._flxSprite == Sprite) || (_rubBodyAnim2 != null && _rubBodyAnim2._flxSprite == Sprite);
	}

	/**
	 * Pokemon have things they like, and doing them will multiply the amount
	 * of hearts they emit. For example, Abra might only emit 60 hearts, but
	 * if you rub her feet this might increase to 120 hearts. If you recite the
	 * quadratic formula incorrectly and tell her how much smarter she is than
	 * you, this might increase to 180 hearts.
	 *
	 * @param	amount percent the heart reservoir should increase by
	 */
	function doNiceThing(amount:Float = 0):Void
	{
		if (amount == 0)
		{
			/*
			 * Because male Pokemon have external genitals and "more to do"
			 * they usually also have more things they want. Both genders have
			 * the same maximum reward, but most male Pokemon in the game
			 * require more actions to get there
			 */
			amount = _male ? 0.66667 : 1.0000;
		}
		if (!_male && amount > FlxG.random.float())
		{
			_remainingOrgasms += FlxG.random.weightedPick([5, 80, 15]); // 0, 1 or 2
		}
		_heartBank._foreplayHeartReservoir += SexyState.roundUpToQuarter(_heartBank._defaultForeplayHeartReservoir * 0.64 * amount);
		if (_bonerThreshold > 0)
		{
			_heartBank._foreplayHeartReservoirCapacity += SexyState.roundUpToQuarter(_heartBank._defaultForeplayHeartReservoir * 0.64 * amount / _bonerThreshold);
		}
		_heartBank._dickHeartReservoir += SexyState.roundUpToQuarter(_heartBank._defaultDickHeartReservoir * amount);
		_heartBank._dickHeartReservoirCapacity += SexyState.roundUpToQuarter(_heartBank._defaultDickHeartReservoir * amount);
		var emitAmount = SexyState.roundDownToQuarter(_heartBank._defaultForeplayHeartReservoir * 0.36 * amount);
		_heartEmitCount += emitAmount;

		_breathlessCount = 99;

		_autoSweatRate += 0.12 * amount;
	}

	/**
	 * Pokemon have things they dislike, and doing them will diminish the
	 * amount of hearts they emit. For example, Buize might normally emit
	 * 120 hearts, but if you squeeze his inner tube this might decrease to 90
	 * hearts. If you then give a 30 minute monologue on why there are only 150
	 * True Pokemon, he might only feel like emitting 60 hearts today.
	 *
	 * @param	amount percent penalty which should be applied
	 */
	function doMeanThing(amount:Float = 1):Void
	{
		var oldCapacity:Float = 0;
		if (_heartBank._foreplayHeartReservoirCapacity > _heartBank._defaultForeplayHeartReservoir)
		{
			oldCapacity = _heartBank._foreplayHeartReservoirCapacity;
			_heartBank._foreplayHeartReservoirCapacity = Math.max(_heartBank._defaultForeplayHeartReservoir, SexyState.roundUpToQuarter(_heartBank._foreplayHeartReservoirCapacity - _heartBank._defaultForeplayHeartReservoir * 0.8 * amount));
			_heartBank._foreplayHeartReservoir = SexyState.roundDownToQuarter((_heartBank._foreplayHeartReservoirCapacity / oldCapacity) * _heartBank._foreplayHeartReservoir);
		}

		if (_heartBank._dickHeartReservoirCapacity > _heartBank._defaultDickHeartReservoir)
		{
			oldCapacity = _heartBank._dickHeartReservoirCapacity;
			_heartBank._dickHeartReservoirCapacity = Math.max(_heartBank._defaultDickHeartReservoir, SexyState.roundUpToQuarter(_heartBank._dickHeartReservoirCapacity - _heartBank._defaultDickHeartReservoir * amount));
			_heartBank._dickHeartReservoir = SexyState.roundDownToQuarter((_heartBank._dickHeartReservoirCapacity / oldCapacity) * _heartBank._dickHeartReservoir);
		}
		_heartEmitCount -= SexyState.roundUpToQuarter(_heartBank._defaultForeplayHeartReservoir * amount * 0.2);

		_autoSweatRate -= 0.16 * amount;
	}

	private function pushCumShot(cumshot:Cumshot):Void
	{
		if (PlayerData.pokemonLibido == 1)
		{
			// don't push cumshots at libido level 1
			return;
		}
		_cumShots.push(cumshot);
	}

	function generateCumshots():Void
	{
		came = true;
		// ensure the first cumshot makes a sound
		orgasmWords.timer = 0;
		pleasureWords.timer = 0;
		encouragementWords.timer = 0;
		_characterSfxTimer = 0;
		// clear away any precum
		_cumShots.splice(0, _cumShots.length);

		var rawOrgasmPower:Float = (_heartBank._dickHeartReservoir + _heartBank._foreplayHeartReservoir) * 1.2;
		var totalOrgasmPower:Float = rawOrgasmPower;
		if (totalOrgasmPower < 60)
		{
			totalOrgasmPower = (30 + totalOrgasmPower) / 1.5;
		}
		if (PlayerData.playerIsInDen)
		{
			var profIndex = PlayerData.PROF_PREFIXES.indexOf(_pokeWindow._prefix);
			var denSexResilience:Float = PlayerData.DEN_SEX_RESILIENCE[profIndex];
			totalOrgasmPower *= (denSexResilience / (denSexResilience + PlayerData.denSexCount));
		}
		var orgasmPower:Float = totalOrgasmPower;
		if (_remainingOrgasms > 1)
		{
			orgasmPower *= _multipleOrgasmDiminishment / _remainingOrgasms;
		}

		pushCumShot( { force : 0.0, rate : 0.0, duration : 0.1, arousal:5 } );
		while (orgasmPower > (_male ? 4 : 6))
		{
			var cumshotPower:Float = orgasmPower * cumTraits4[cumTrait4] * FlxG.random.float(0.6, 1.0);
			orgasmPower -= cumshotPower;

			var cumQuantity:Float = Math.log(cumshotPower + 8) / Math.log(8) - 1;

			cumQuantity *= 2.1 * cumTraits0[cumTrait0];
			var cumshotFrequency = cumTraits2[cumTrait2];

			var cumshot:Cumshot = { duration:cumshotFrequency * cumTraits3[cumTrait3] * FlxG.random.float(0.9, 1.11), rate:0, force:0, arousal:0 };
			while (cumQuantity > 2)
			{
				var r = FlxG.random.float(0.7, 0.9);
				cumQuantity *= r;
				cumshot.duration /= Math.pow(r, 2);
			}
			if (orgasmPower > 60)
			{
				cumshot.arousal = 5;
			}
			else if (orgasmPower > 30)
			{
				cumshot.arousal = 4;
			}
			else if (orgasmPower > 15)
			{
				cumshot.arousal = 3;
			}
			else if (orgasmPower > 8)
			{
				cumshot.force *= 0.66;
				cumshot.arousal = 2;
				cumshot.duration *= 1.25;
			}
			else
			{
				cumshot.force *= 0.33;
				cumshot.arousal = 1;
				cumshot.duration *= 2;
			}

			var forceRateRatio = FlxG.random.float(0.89, 1.13);

			cumshot.force = Math.max(0.1, cumQuantity * forceRateRatio);
			cumshot.rate = Math.max(0.2, cumQuantity / forceRateRatio);

			pushCumShot(cumshot);

			var cumshotDuration:Float = cumshot.duration;
			while (cumshot.duration > 0.5)
			{
				var newDuration:Float = FlxG.random.float(0.1, 0.15);
				cumshot.duration -= newDuration;
				pushCumShot( { force:Math.max(0.1, _cumShots[_cumShots.length - 1].force * 0.85), rate:Math.max(0.2, _cumShots[_cumShots.length - 1].rate * 0.85), duration:newDuration, arousal:cumshot.arousal } );
			}

			pushCumShot( { force:0, rate:0, duration:Math.max(0.1, cumshotFrequency - Math.max(cumshotDuration, cumshotFrequency * 0.3)), arousal:cumshot.arousal } );
		}

		if (rawOrgasmPower < 36)
		{
			for (cumshot in _cumShots)
			{
				cumshot.force *= Math.pow(rawOrgasmPower / 36, 0.5);
			}
		}

		for (cumshot in _cumShots)
		{
			if (cumshot.force > 0)
			{
				cumshot.force = Math.max(0.1, cumshot.force * cumTraits1[cumTrait1]);
				cumshot.rate = Math.max(0.2, cumshot.rate * cumTraits1[cumTrait1]);
			}
		}

		_remainingOrgasms--;
		_isOrgasming = true;
	}

	function emitCasualEncouragementWords():Void
	{
		if (_heartEmitCount > 0)
		{
			if (encouragementWords.timer < _characterSfxTimer)
			{
				maybeEmitWords(encouragementWords);
			}
		}
	}

	/**
	 * @param	left  Number of leftmost words to omit
	 * @param	right Number of rightmost words to omit
	 */
	function maybeEmitWords(qord:Qord, ?left:Int = 0, ?right:Int = 0):Array<WordParticle>
	{
		if (qord != null && qord.timer <= 0)
		{
			return emitWords(qord, left, right);
		}
		return [];
	}

	/**
	 * @param	left  Number of leftmost words to omit
	 * @param	right Number of rightmost words to omit
	 */
	function emitWords(qord:Qord, ?left:Int = 0, ?right:Int = 0):Array<WordParticle>
	{
		encouragementWords.timer = encouragementWords.frequency;
		boredWords.timer = boredWords.frequency;
		return wordManager.emitWords(qord, left, right);
	}

	/**
	 * Override to define penetrative actions, where it's OK to go slower
	 *
	 * @return true if the current action is penetrative
	 */
	function penetrating():Bool
	{
		return false;
	}

	public function maybeScheduleBreath():Void
	{
		if (++_breathlessCount > 1)
		{
			scheduleBreath();
		}
	}

	public function scheduleBreath():Void
	{
		_breathlessCount = FlxG.random.int(-2, 0);
		_breathTimer = FlxG.random.float(0, 1.5);
	}

	function scheduleSweat(sweatCount:Int):Void
	{
		if (_sweatCount == 0)
		{
			_sweatTimer += FlxG.random.float(0, 1.5);
			_sweatCount = sweatCount;
		}
	}

	/**
	 * After a pokemon ejaculates, there's a tiny bit of hearts left in his heart bank, and we're still in the "jerking off" animation,
	 * so it's awkward to transition directly to the the dialog state. This function handles the "in between" stuff.
	 */
	function endSexyStuff():Void
	{
		setState(400);

		_heartEmitCount += roundUpToQuarter((_heartBank._dickHeartReservoir + _heartBank._foreplayHeartReservoir) / (_remainingOrgasms + 1.0));
		_heartBank._dickHeartReservoir = 0;
		_heartBank._foreplayHeartReservoir = 0;

		maybeEndSexyRubbing();
	}

	function maybeEndSexyRubbing():Void
	{
		if (_male && _dick != null && fancyRubbing(_dick) && _rubHandAnim._flxSprite.animation.name == "jack-off")
		{
			_rubBodyAnim.setAnimName("rub-dick");
			_rubHandAnim.setAnimName("rub-dick");
		}
	}

	function isEjaculating():Bool
	{
		return _cumShots.length > 0 && _cumShots[0].arousal != -1;
	}

	/**
	 * Overridden to append a list of complains the pokemon might have. These
	 * complaints are numeric indexes into the "sexyBeforeBad" field in their
	 * Dialog class.
	 *
	 * @param	complaints complaints array to append to
	 */
	public function computeChatComplaints(complaints:Array<Int>):Void
	{
	}

	function maybePlayPokeSfx(?sfxArray:Array<FlxSoundAsset>):Void
	{
		if (_characterSfxTimer <= 0)
		{
			_characterSfxTimer = _characterSfxFrequency;
			if (sfxArray != null)
			{
				FlxSoundKludge.play(FlxG.random.getObject(sfxArray), 0.4);
			}
			else
			{
				if (!pastBonerThreshold())
				{
					FlxSoundKludge.play(FlxG.random.getObject(sfxEncouragement), 0.4);
				}
				else
				{
					FlxSoundKludge.play(FlxG.random.getObject(sfxPleasure), 0.4);
				}
			}
		}
	}

	function maybeEmitPrecum():Void
	{
		if (PlayerData.pokemonLibido == 1)
		{
			// don't emit precum at libido level 1
			return;
		}
		var precumAmount:Int = computePrecumAmount();
		if (precumAmount > 0)
		{
			precum(precumAmount);

			scheduleSweat(FlxG.random.int(2, 2 + precumAmount));
			if (precumAmount >= 2)
			{
				_autoSweatRate += 0.03 * precumAmount;
			}
		}
	}

	/**
	 * Override to define the amount of precum emitted
	 */
	function computePrecumAmount():Int
	{
		return 0;
	}

	/**
	 * Override to define the amount of precum emitted
	 */
	function handleRubReward():Void
	{
	}

	/**
	 * Override to define how much the character enjoys foreplay
	 *
	 * 0 = they don't enjoy foreplay at all
	 * 1 = they don't enjoy sex at all
	 */
	function foreplayFactor():Float
	{
		return _male ? 0.25 : 0.5;
	}

	/**
	 * Override if the toy uses "foreplay" in some weird way
	 */
	function toyForeplayFactor():Float
	{
		return 0;
	}

	function lucky(Min:Float, Max:Float, Scalar:Float = 1)
	{
		var result:Float = FlxG.random.float(Min * Scalar, Max * Scalar);
		if (PlayerData.pokemonLibido < 4)
		{
			result = Math.min(result, FlxG.random.float(Min * Scalar, Max * Scalar));
		}
		return result;
	}

	function computeBonusCapacity():Int
	{
		var reservoir:Int = Reflect.field(PlayerData, _pokeWindow._prefix + "Reservoir");
		var bonusCapacity:Int = 0;
		if (reservoir >= 210)
		{
			bonusCapacity = 210;
		}
		else if (reservoir >= 90)
		{
			bonusCapacity = 90;
		}
		else if (reservoir >= 30)
		{
			bonusCapacity = 30;
		}
		return bonusCapacity;
	}

	function computeBonusToyCapacity():Int
	{
		var reservoir:Int = Reflect.field(PlayerData, _pokeWindow._prefix + "ToyReservoir");
		var bonusCapacity:Int = 0;
		if (reservoir >= 180)
		{
			bonusCapacity = 180;
		}
		else if (reservoir >= 120)
		{
			bonusCapacity = 120;
		}
		else if (reservoir >= 60)
		{
			bonusCapacity = 60;
		}
		return bonusCapacity;
	}

	public function createToyMeter(toyButton:FlxSprite, pctNerf:Float=1.0):ReservoirMeter
	{
		var reservoir:Int = Reflect.field(PlayerData, _pokeWindow._prefix + "ToyReservoir");
		if (reservoir == -1)
		{
			reservoir = FlxG.random.int(0, 59);
		}
		reservoir = Std.int(reservoir * pctNerf);
		var toyPct:Float = Math.pow(reservoir / 180, 0.5);
		var toyReservoirStatus:ReservoirStatus = ReservoirStatus.Green;
		if (reservoir >= 180)
		{
			toyReservoirStatus = ReservoirStatus.Emergency;
		}
		else if (reservoir >= 120)
		{
			toyReservoirStatus = ReservoirStatus.Red;
		}
		else if (reservoir >= 60)
		{
			toyReservoirStatus = ReservoirStatus.Yellow;
		}
		return new ReservoirMeter(toyButton, toyPct, toyReservoirStatus, 70, 63);
	}

	/**
	 * @param	pctNerf A number from 0.10-0.59 for toys the pokemon doesn't like.
	 */
	public function addToyButton(toyButton:FlxButton, pctNerf:Float=1.0)
	{
		var position:FlxPoint = TOY_BUTTON_POSITIONS[Std.int(_toyButtons.members.length / 2)];
		toyButton.setPosition(position.x, position.y);
		var meter:ReservoirMeter = createToyMeter(toyButton, pctNerf);
		buttonToMeterMap[toyButton] = meter;
		_toyButtons.add(toyButton);
		_toyButtons.add(meter);
	}

	public function removeToyButton(toyButton:FlxButton)
	{
		_toyButtons.remove(toyButton);
		_toyButtons.remove(buttonToMeterMap[toyButton]);
		buttonToMeterMap.remove(toyButton);
	}

	public function isFinishedSexyStuff():Bool
	{
		return _gameState >= 400;
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
			filter.distance = 0;
			spriteFilter.secretOffset.y = -3;
			spriteFilter.applyToSprite(button, false, true);
		}

		button.onUp.callback = function()
		{
			button.onOut.fire();
			if (_buttonGroup.visible)
			{
				Callback();
			}
		}

		button.onOut.callback = function()
		{
			filter.distance = 3;
			spriteFilter.secretOffset.y = 0;
			spriteFilter.applyToSprite(button, false, true);
		}
		return button;
	}

	function specialRubsInARow():Int
	{
		var inARow:Int = 0;
		var i:Int = specialRubs.length - 1;
		while (i >= 0 && specialRubs[i] == specialRub)
		{
			inARow++;
			i--;
		}
		return inARow;
	}

	public function eventShowToyWindow(args:Array<Dynamic>)
	{
		if (_hud.members.indexOf(toyGroup) != -1)
		{
			// already shown?
			return;
		}

		_hud.insert(_hud.members.indexOf(_pokeWindow), toyGroup);
		CursorUtils.useSystemCursor();
		_frontSprites.remove(_handSprite);
		_backSprites.remove(_toyButtons);
		_backSprites.add(_toyOffButton);
		_idlePunishmentTimer = -5;

		var toyWindow:PokeWindow = getToyWindow();
		if (toyWindow != null)
		{
			// toy involves a completely new pokewindow... swap it in
			_activePokeWindow = toyWindow;
			toyWindow.setArousal(_pokeWindow._arousal);
			_hud.remove(_pokeWindow);
			addCameraButtons();

			_dick = toyWindow._dick;
			_head = toyWindow._head;

			// different dick/head, different hitboxes...
			initializeHitBoxes();
			killParticles();
		}
	}

	/*
	 * Can be overridden to return the toy window
	 */
	public function getToyWindow():PokeWindow
	{
		return null;
	}

	public function eventHideToyWindow(args:Array<Dynamic>)
	{
		if (_hud.members.indexOf(toyGroup) == -1)
		{
			// already hidden?
			return;
		}

		var toyWindow:PokeWindow = getToyWindow();
		if (toyWindow != null)
		{
			// toy involves a completely new pokewindow... swap the regular pokewindow back in
			_activePokeWindow = _pokeWindow;
			_hud.insert(_hud.members.indexOf(toyGroup), _pokeWindow);
			_hud.remove(toyGroup);
			_pokeWindow.setArousal(toyWindow._arousal);
			addCameraButtons();

			_dick = _pokeWindow._dick;
			_head = _pokeWindow._head;

			// different dick/head, different hitboxes...
			initializeHitBoxes();
			killParticles();
		}
		else
		{
			_hud.remove(toyGroup);
		}

		_idlePunishmentTimer = -5;
		CursorUtils.initializeSystemCursor();
		_frontSprites.add(_handSprite);
		_backSprites.remove(_toyOffButton);
	}

	public function playButtonClickSound():Void
	{
		SoundStackingFix.play(AssetPaths.click1_00cb__mp3, 0.6);
	}

	public function streamButtonEvent():Void
	{
		playButtonClickSound();
		_tablet.visible = true;
		_backSprites.remove(_streamButton);
		eventStack.addEvent({time:eventStack._time + 2.0, callback:eventEnableStreamCloseButton});
	}

	public function hideStreamEvent():Void
	{
		playButtonClickSound();
		_tablet.exists = false;
		_streamCloseButton.exists = false;
	}

	public function eventEnableStreamCloseButton(args:Dynamic)
	{
		_streamCloseButton.exists = true;
	}

	public function toyOffButtonEvent():Void
	{
		if (!toyButtonsEnabled)
		{
			return;
		}
		if (finalOrgasmLooms())
		{
			// in the middle of the final orgasm; it would be awkward to swap now
			return;
		}
		playButtonClickSound();
		toyButtonsEnabled = false;
		if (shouldEmitToyInterruptWords())
		{
			maybeEmitWords(toyInterruptWords);
		}
		else {
			// already naturally finished using the toy
		}
		var time:Float = eventStack._time;
		if (getToyWindow() != null)
		{
			// need to transition between two pokewindows; we do this by
			// having the go out of frame and come back
			eventStack.addEvent({time:time + 0.8, callback:eventTakeBreak, args:[2.5]});
			time += 0.5;
		}
		eventStack.addEvent({time:time += 0.5, callback:eventHideToyWindow});
		if (getToyWindow() == null)
		{
			// need to reset pokewindow's alpha, just in case player was mousing over it
			FlxTween.tween(_pokeWindow._canvas, {alpha:1.0}, 0.5, {startDelay:time - eventStack._time});
		}
		eventStack.addEvent({time:time += 2.2, callback:eventEnableToyButtons});
	}

	/**
	 * Can be overridden to define when it is/isn't appropriate to comment upon switching toy states
	 */
	public function shouldEmitToyInterruptWords():Bool
	{
		return false;
	}

	/**
	 * @return true if we're in the middle of our last orgasm... or we're about to have our last orgasm.
	 */
	public function finalOrgasmLooms():Bool
	{
		return _gameState == 200 && (_remainingOrgasms == 0 || _remainingOrgasms == 1 && shouldOrgasm());
	}

	public function eventEnableToyButtons(args:Array<Dynamic>):Void
	{
		toyButtonsEnabled = true;
	}

	public function eventTakeBreak(args:Array<Dynamic>):Void
	{
		var breakTime:Float = args[0];
		_pokeWindow.takeBreak(breakTime);
		if (getToyWindow() != null)
		{
			getToyWindow().takeBreak(breakTime);
		}
	}

	public function displayingToyWindow():Bool
	{
		return _hud.members.indexOf(toyGroup) != -1;
	}

	/**
	 * Can be overriden to define all behavior which should happen when the toy window is showing
	 */
	public function handleToyWindow(elapsed:Float):Void
	{
		var toyWindow:PokeWindow = _activePokeWindow;

		// fade out mouse if cursor is nearby...
		var shouldFade:Bool = false;
		if (toyWindow._canvas.overlapsPoint(FlxG.mouse.getPosition()))
		{
			var minDist:Float = FlxG.width;
			for (_cameraButton in toyWindow._cameraButtons)
			{
				var dist:Float = FlxPoint.get(toyWindow.x + _cameraButton.x + 14, toyWindow.y + _cameraButton.y + 14).distanceTo(FlxG.mouse.getPosition());
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
			toyWindow._canvas.alpha = Math.max(0.3, toyWindow._canvas.alpha - 3.0 * elapsed);
		}
		else {
			toyWindow._canvas.alpha = Math.min(1.0, toyWindow._canvas.alpha + 3.0 * elapsed);
		}

		// increment reward/punishment timer...
		if (toyWindow._breakTime > 0)
		{
			// hasn't settled down yet...
		}
		else {
			if (_remainingOrgasms > 0)
			{
				// before the final orgasm, let the player take their time
				_idlePunishmentTimer += elapsed * TOY_TIME_DILATION;
			}
			else {
				_idlePunishmentTimer += elapsed;
			}
			_rubRewardTimer += elapsed;
		}
	}

	public function maybeEmitToyWordsAndStuff()
	{
		_idlePunishmentTimer = 0;
		if (_rubRewardTimer > _rubRewardFrequency / 2)
		{
			_rubRewardTimer = _rubRewardFrequency * FlxG.random.float( -0.83, -1.20) + _rubRewardFrequency / 2;
			emitCasualEncouragementWords();
			if (_heartEmitCount > 0)
			{
				maybePlayPokeSfx();
			}
		}
	}

	public function obliterateCursor()
	{
		_pokeWindow._interact.visible = false;
		_shadowGlove.visible = false;
		FlxG.mouse.useSystemCursor = true;
		PlayerData.cursorType = "none";
		PlayerData.cursorSmellTimeRemaining = 0;
	}
}

class ToyCallback<T:PokeWindow>
{
	var callback:Void->Void;
	var sexyState:SexyState<T>;

	public function new(sexyState:SexyState<T>, callback:Void->Void)
	{
		this.sexyState = sexyState;
		this.callback = callback;
	}

	public function doCall()
	{
		if (sexyState._activePokeWindow._partAlpha == 0)
		{
			// toy buttons don't work if the pokemon is gone
			return;
		}
		if (!sexyState.toyButtonsEnabled)
		{
			return;
		}
		if (sexyState.finalOrgasmLooms())
		{
			// in the middle of the final orgasm; it would be awkward to swap now
			return;
		}
		if (sexyState._gameState != 200)
		{
			// maybe we're in state 400, or something funny. we shouldn't start anal beads after we've orgasmed
			return;
		}
		callback();
	}
}

typedef Cumshot =
{
	force:Float,
	rate:Float,
	duration:Float,
	arousal:Int
}

/**
 * Area which can emit sweat, something like "the top part of the forehead in between the eyes"
 */
typedef SweatArea =
{
	chance:Int, // likelihood of emitting sweat relative to the other SweatAreas
	sprite:FlxSprite, // sprite which emits sweat
	/*
	 * Polygonal region of the FlxSprite which can emit sweat. Includes a
	 * different polygon for every frame, as a Pokemon might move their head
	 * around causing their forehead to change positions
	 */
	sweatArrayArray:Array<Array<FlxPoint>>
}