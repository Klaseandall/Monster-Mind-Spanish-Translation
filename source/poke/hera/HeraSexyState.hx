package poke.hera;
import flixel.util.FlxDestroyUtil;
import kludge.FlxSoundKludge;
import poke.grov.Vibe;
import poke.grov.VibeInterface.vibeString;
import poke.grov.VibeInterface;
import poke.magn.MagnDialog;
import openfl.utils.Object;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import poke.sexy.SexyState;
import poke.sexy.WordManager.Qord;
import poke.sexy.WordManager.Word;
import poke.sexy.WordParticle;

/**
 * Sex sequence for Heracross
 * 
 * Heracross has a hair trigger, and will cum eventually even if you are simply
 * rubbing his elbow or shoulders or anywhere at all. The real puzzle with him
 * is figuring out how to prevent him from cumming.
 * 
 * As you rub his exterior, you'll typically see a few white hearts pop up. But
 * over time, you'll start seeing pink hearts, which means his climax is
 * starting to build, and he'll cum soon.
 * 
 * To prevent Heracross from climaxing, you should rub one his two antennae
 * when you start seeing pink hearts. This will confuse him and stop him from
 * climaxing. But, each antenna can only be rubbed once for this effect.
 * 
 * You can also prevent him from climaxing by not touching him for a few
 * seconds, but he doesn't like this very much.
 * 
 * He has two especially sensitive spots on his shell, which change each time.
 * As you rub your hand, you will see 1, 2, or 3 white hearts show up, and it
 * is sort of a "hot and cold" game. When you see 3 white hearts, if you
 * continue rubbing the same spot, this will make Heracross very happy. You'll
 * see a ton of hearts appear and he'll say something silly.
 * 
 * Heracross likes the venonat vibrator, but it eventually makes him cum
 * prematurely unless you use it in the exact right way -- almost like a secret
 * code.
 * 
 * You should always keep the vibrator on the lowest two settings.
 * 
 * If you set it to the wrong setting, Heracross will blush and his orgasm will
 * follow a few seconds later.
 * 
 * The correct settings are:
 *  1. The slowest oscillating setting (the leftmost button)
 *  2. The slowest sustained setting (the middle button)
 *  3. The second-slowest pulse setting (the right button)
 *  4. The slowest pulse setting
 *  5. The second-slowest oscillating setting (getting this far will make
 *     Heracross very happy)
 *  6. The second-slowest sustained setting (getting this far will make
 *     Heracross ejaculate, but he can ejaculate again)
 * To ensure you only press the correct settings, it's recommended you use the
 * on/off vibrator button (second from the left)
 * 
 * If the sequence is followed correctly, Heracross will ejaculate. But, this
 * is only his first orgasm, and he can have a second orgasm later while you
 * are playing with him -- either with the vibrator, or after switching back to
 * your glove.
 */
class HeraSexyState extends SexyState<HeraWindow>
{
	// areas that you can click
	private var leftAntennaPolyArray:Array<Array<FlxPoint>>;
	private var rightAntennaPolyArray:Array<Array<FlxPoint>>;
	private var hornPolyArray:Array<Array<FlxPoint>>;
	private var vagPolyArray:Array<Array<FlxPoint>>;
	private var electricPolyArray:Array<Array<FlxPoint>>;

	private var torsoSweatArray:Array<Array<FlxPoint>>;
	private var headSweatArray:Array<Array<FlxPoint>>;

	private var specialSpots:Array<String> = ["left-torso0", "right-torso0", "left-torso1", "right-torso1", "left-leg", "right-leg", "left-shoulder", "right-shoulder", "balls"];
	private var verySpecialSpots:Array<String> = [];

	private var heraMood0:Int = FlxG.random.int(0, 9);
	private var heraMood1:Float = FlxG.random.float(0.01, 1.00);

	private var hitTheSpotTriggers:Array<Int> = [];
	private var hitTheSpotTrigger:Int = 9999; // when this reaches 0, heracross likes where you're rubbing
	private var prematureEjaculationTriggers:Array<Int> = [];
	private var prematureEjaculationTrigger:Int = 9999; // when this reaches 0, heracross starts building to a premature ejaculation

	private var turnsUntilPrematureEjaculation:Int = 9999;

	/*
	 * niceThings[0] = find one sensitive part of heracross's shell
	 * niceThings[1] = find another sensitive part of heracross's shell
	 * niceThings[2] = play with heracross's erection
	 */
	private var niceThings:Array<Bool> = [true, true, true];

	/*
	 * meanThings[0] = leave heracross alone because you don't want him to cum yet
	 * meanThings[1] = leave heracross alone a second time
	 */
	private var meanThings:Array<Bool> = [true, true];

	private var bonusCapacityIndex:Int = 0; // Number from 0-3, depending on Heracross's bonus capacity
	private var blushTimer:Float = 0;

	private var sillyPleasureWords:Qord;
	private var babbleWords:Qord;
	private var badAntennaWords:Qord;
	private var toyAlmostWords:Qord;

	private var babbleWordParticles:Array<WordParticle>;
	private var antennaHeartTimer:Float = 0;
	public var didKindaPrematurelyEjaculate:Bool = false; // ejaculated when he was emitting a few extra hearts
	public var didReallyPrematurelyEjaculate:Bool = false; // ejaculated when he was emitting a TON of extra hearts, or didn't even have a boner

	private var _beadButton:FlxButton;
	private var _bigBeadButton:FlxButton;
	private var _vibeButton:FlxButton;
	private var _elecvibeButton:FlxButton;
	private var _toyInterface:VibeInterface;

	private var dickVibeAngleArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
	private var microTurnsUntilPrematureEjaculation:Float = 99999;
	private var vibeRewardFrequency:Float = 1.6;
	private var vibeRewardTimer:Float = 0;
	private var vibeReservoir:Float = 0;
	private var consecutiveVibeCount:Int = 0;
	private var lastFewVibeSettings:Array<String> = [];
	private var lastVibeSetting:String = null;
	private var addToyHeartsToOrgasm:Bool = false; // successfully found the target vibe setting
	private var acceptableVibesPerPhase:Array<Array<String>> = [
				["Pulse1", "Sine1", "Sine2"],
				["Sine1", "Sustained1", "Pulse2"],
				["Pulse2", "Sustained2"],
				["Pulse1"],
				["Sustained1", "Sine2"],
				["Sustained2"],
			];

	override public function create():Void
	{
		prepare("hera");

		// Shift heracross down so he's framed in the window better
		_pokeWindow.shiftVisualItems(40);

		super.create();

		_toyInterface = new VibeInterface(_pokeWindow._vibe);
		toyGroup.add(_toyInterface);

		sfxEncouragement = [AssetPaths.hera0__mp3, AssetPaths.hera1__mp3, AssetPaths.hera2__mp3, AssetPaths.hera3__mp3];
		sfxPleasure = [AssetPaths.hera4__mp3, AssetPaths.hera5__mp3, AssetPaths.hera6__mp3];
		sfxOrgasm = [AssetPaths.hera7__mp3, AssetPaths.hera8__mp3, AssetPaths.hera9__mp3];

		popularity = -0.2;
		cumTrait0 = 9;
		cumTrait1 = 1;
		cumTrait2 = 8;
		cumTrait3 = 2;
		cumTrait4 = 3;

		sweatAreas.push({chance:3, sprite:_head, sweatArrayArray:headSweatArray});
		sweatAreas.push({chance:7, sprite:_pokeWindow._torso1, sweatArrayArray:torsoSweatArray});

		if (computeBonusCapacity() <= 0)
		{
			bonusCapacityIndex = 0;
		}
		else if (computeBonusCapacity() <= 30)
		{
			bonusCapacityIndex = 1;
		}
		else if (computeBonusCapacity() <= 90)
		{
			bonusCapacityIndex = 2;
		}
		else {
			bonusCapacityIndex = 3;
		}

		{
			hitTheSpotTriggers.push(heraMood0 + 6);
			hitTheSpotTriggers.push((15 - hitTheSpotTriggers[0]) + 6);
		}
		{
			var maxTrigger:Int = [17, 13, 9, 5][bonusCapacityIndex];

			if (PlayerData.pokemonLibido == 1)
			{
				// zero libido; no risk of premature ejaculation
			}
			else {
				prematureEjaculationTriggers.push(Math.ceil(heraMood1 * maxTrigger));
				prematureEjaculationTriggers.push(maxTrigger + 1 - prematureEjaculationTriggers[0]);
			}
		}

		resetHitTheSpotTrigger();
		resetPrematureEjaculationTrigger();

		if (ItemDatabase.playerHasUneatenItem(ItemDatabase.ITEM_SMALL_PURPLE_BEADS))
		{
			_beadButton = newToyButton(beadButtonEvent, AssetPaths.smallbeads_purple_button__png, _dialogTree);
			addToyButton(_beadButton, 0.36);
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_VIBRATOR))
		{
			_vibeButton = newToyButton(vibeButtonEvent, AssetPaths.vibe_button__png, _dialogTree);
			addToyButton(_vibeButton);
		}

		if (ItemDatabase.getPurchasedMysteryBoxCount() >= 8)
		{
			_elecvibeButton = newToyButton(elecvibeButtonEvent, AssetPaths.elecvibe_button__png, _dialogTree);
			addToyButton(_elecvibeButton);
		}
	}

	public function beadButtonEvent():Void
	{
		playButtonClickSound();
		removeToyButton(_beadButton);
		var tree:Array<Array<Object>> = [];
		HeraDialog.snarkyBeads(tree);
		showEarlyDialog(tree);
	}

	public function vibeButtonEvent():Void
	{
		playButtonClickSound();
		toyButtonsEnabled = false;
		maybeEmitWords(toyStartWords);
		var time:Float = eventStack._time;
		eventStack.addEvent({time:time, callback:eventShowToyWindow});
		eventStack.addEvent({time:time += 1.7, callback:eventEnableToyButtons});
	}

	public function elecvibeButtonEvent():Void
	{
		_toyInterface.setElectric(true);
		_pokeWindow._vibe.setElectric(true);
		insert(members.indexOf(_breathGroup), _toyInterface.smallSparkEmitter);
		insert(members.indexOf(_breathGroup), _toyInterface.largeSparkEmitter);

		vibeButtonEvent();
	}

	override public function shouldEmitToyInterruptWords():Bool
	{
		return turnsUntilPrematureEjaculation >= 1000 && addToyHeartsToOrgasm == false && came == false;
	}

	override function toyForeplayFactor():Float
	{
		/*
		 * 60% of the toy hearts are available for doing random stuff. the
		 * other 40% are only available if you hit the right spot
		 */
		return 0.6;
	}

	override public function handleToyWindow(elapsed:Float):Void
	{
		super.handleToyWindow(elapsed);

		if (_toyInterface.lightningButtonDuration > 0)
		{
			_toyInterface.doLightning(this, electricPolyArray);
		}

		if (_gameState != 200)
		{
			// no rewards after done orgasming
			return;
		}

		if (isEjaculating())
		{
			// no rewards while ejaculating
			return;
		}

		if (_remainingOrgasms == 0)
		{
			// no rewards after ejaculating
			return;
		}

		if (_toyInterface.lightningButtonDuration > 0 )
		{
			var percent:Float = 0;
			var precumAmount:Int = 0;
			if (_toyInterface.lightningButtonDuration < 0.1)
			{
				percent = 0.02;
			}
			else if (_toyInterface.lightningButtonDuration < 0.3)
			{
				percent = 0.03;
				precumAmount = 1;
			}
			else if (_toyInterface.lightningButtonDuration < 0.6)
			{
				percent = 0.05;
				precumAmount = 1;
			}
			else if (_toyInterface.lightningButtonDuration < 1.0)
			{
				percent = 0.10;
				precumAmount = 2;
			}
			else if (_toyInterface.lightningButtonDuration < 1.5)
			{
				percent = 0.20;
				precumAmount = 2;
			}
			else if (_toyInterface.lightningButtonDuration < 2.0)
			{
				percent = 0.30;
				precumAmount = 3;
			}
			else if (_toyInterface.lightningButtonDuration < 3.0)
			{
				percent = 0.50;
				precumAmount = 3;
			}
			else
			{
				percent = 1.00;
				precumAmount = 3;
			}

			if (percent > 0)
			{
				var amount:Float = Math.ceil(percent * (_heartBank._dickHeartReservoir - 0.5 * (_heartBank._dickHeartReservoirCapacity * _cumThreshold - 1)));
				amount = Math.max(amount, 1);
				amount = Math.min(amount, _heartBank._dickHeartReservoir);
				_heartBank._dickHeartReservoir -= amount;
				_heartEmitCount += Math.min(amount, Math.ceil(amount * 0.4));
			}

			if (precumAmount > 0)
			{
				precum(precumAmount);
			}

			if (shouldOrgasm())
			{
				_newHeadTimer = 0; // make sure they orgasm before their reservoir is empty
				consecutiveVibeCount = 0; // reset consecutiveVibeCount in case they multiple orgasm; start fresh
			}
			else if (_heartEmitCount <= 0)
			{
				// vibrator activity was eaten by penalty
			}
			else
			{
				_characterSfxTimer -= 2.8;
				maybePlayPokeSfx();
				maybeEmitWords(encouragementWords);
			}
		}

		if (!_pokeWindow._vibe.vibeSfx.isVibratorOn())
		{
			lastFewVibeSettings.splice(0, lastFewVibeSettings.length);
			consecutiveVibeCount = 0;
			return;
		}

		// accumulate rewards in vibeReservoir...
		vibeRewardTimer += elapsed;
		_idlePunishmentTimer = 0; // pokemon doesn't get bored if the vibrator's on

		if (vibeRewardTimer >= vibeRewardFrequency)
		{
			// When the vibrator's on, we accumulate 1-3% hearts in the reservoir...
			vibeRewardTimer -= vibeRewardFrequency;

			var foreplayPct:Float = [0.010, 0.015, 0.020, 0.025, 0.03][_pokeWindow._vibe.vibeSfx.speed - 1];

			var amount:Float = SexyState.roundUpToQuarter(_toyBank._foreplayHeartReservoirCapacity * foreplayPct);
			if (!pastBonerThreshold() && _heartBank._foreplayHeartReservoirCapacity < 1000)
			{
				// bump up foreplay heart capacity, to give a boner faster
				_heartBank._foreplayHeartReservoirCapacity += 3 * amount;
			}
			if (amount > 0 && _toyBank._foreplayHeartReservoir > 0 )
			{
				// first, try to get these hearts from the toy bank...
				var deductionAmount:Float = Math.min(amount, _toyBank._foreplayHeartReservoir);
				amount -= deductionAmount;
				_toyBank._foreplayHeartReservoir -= deductionAmount;
				vibeReservoir += deductionAmount;
			}
			if (amount > 0 && !pastBonerThreshold() && _heartBank._foreplayHeartReservoir > 0)
			{
				// if the toy bank's empty, get them from the foreplay heart reservoir...
				var deductionAmount:Float = Math.min(amount, _heartBank._foreplayHeartReservoir);
				amount -= deductionAmount;
				_heartBank._foreplayHeartReservoir -= deductionAmount;
				vibeReservoir += deductionAmount;
			}
			if (amount > 0 && pastBonerThreshold() && _heartBank._dickHeartReservoir > 0)
			{
				// if the toy bank's empty, get them from the dick heart reservoir...
				var deductionAmount:Float = Math.min(amount, _heartBank._dickHeartReservoir);
				amount -= deductionAmount;
				_heartBank._dickHeartReservoir -= deductionAmount;
				vibeReservoir += deductionAmount;
			}

			// if turnsUntilPrematureEjaculation <= 3, start ejaculating...
			var percent:Float = 0;
			if (microTurnsUntilPrematureEjaculation <= 0)
			{
				percent = 0.187;
			}
			else if (microTurnsUntilPrematureEjaculation <= 5)
			{
				percent = 0.073;
			}
			else if (microTurnsUntilPrematureEjaculation <= 10)
			{
				percent = 0.031;
			}
			else if (microTurnsUntilPrematureEjaculation <= 15)
			{
				percent = 0.007;
			}
			if (percent > 0)
			{
				var amount:Float = Math.ceil(percent * (_heartBank._dickHeartReservoir - (_heartBank._dickHeartReservoirCapacity * _cumThreshold - 1)));
				amount = Math.max(amount, 1);
				amount = Math.min(amount, _heartBank._dickHeartReservoir);
				_heartBank._dickHeartReservoir -= amount;
				_heartEmitCount += Math.min(amount, Math.ceil(amount * 0.4));
			}
		}

		turnsUntilPrematureEjaculation = Std.int(microTurnsUntilPrematureEjaculation / 5);

		if (turnsUntilPrematureEjaculation < 1000)
		{
			_autoSweatRate = FlxMath.bound(_autoSweatRate + 0.03, 0, 1);

			if (FlxG.random.float(0, Math.pow(FlxMath.bound(turnsUntilPrematureEjaculation, 0, 10), 2)) <= 4)
			{
				blushTimer = FlxG.random.float(12, 15);
				_pokeWindow._armsUpTimer = FlxG.random.float(6, 9);
				_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(1.5, 3);
			}
		}

		if (vibeReservoir > 0 && _pokeWindow._vibe.vibeSfx.isVibrating())
		{
			// did they mess up?
			var vs:String = vibeString(_pokeWindow._vibe.vibeSfx.mode, _pokeWindow._vibe.vibeSfx.speed);
			var acceptable:Bool = true;
			if (vs != lastVibeSetting && acceptableVibesPerPhase.length > 0)
			{
				var acceptableVibes:Array<String> = acceptableVibesPerPhase.splice(0, 1)[0];
				if (acceptableVibes.indexOf(vs) == -1)
				{
					// bad vibe...
					acceptable = false;
				}
				else
				{
					// good vibe
					for (i in 0...acceptableVibesPerPhase.length)
					{
						acceptableVibesPerPhase[i].remove(vs);
					}

					if (_remainingOrgasms > 0)
					{
						if (acceptableVibesPerPhase.length == 1)
						{
							maybeEmitWords(toyAlmostWords);
							blushTimer = FlxG.random.float(12, 15);

							var rewardAmount:Float = SexyState.roundUpToQuarter(lucky(0.10, 0.15) * _toyBank._dickHeartReservoir);
							_toyBank._dickHeartReservoir -= rewardAmount;
							_heartEmitCount += rewardAmount;
						}
					}
				}
			}
			if (acceptable)
			{
				// they did OK; don't accelerate the vibe count
			}
			else
			{
				if (microTurnsUntilPrematureEjaculation >= 10000)
				{
					// start the ejaculation timer...
					microTurnsUntilPrematureEjaculation = [9, 7, 5, 3][bonusCapacityIndex] * 5;
					// skip straight to the "struggling" face
					_pokeWindow._arousal = 4;
					_newHeadTimer = Math.min(_newHeadTimer, FlxG.random.float(0.4, 0.8));
				}
			}

			lastVibeSetting = vibeString(_pokeWindow._vibe.vibeSfx.mode, _pokeWindow._vibe.vibeSfx.speed);
		}

		if (!addToyHeartsToOrgasm && acceptableVibesPerPhase.length == 0 && microTurnsUntilPrematureEjaculation >= 10000 && consecutiveVibeCount == 1)
		{
			var rewardAmount:Float = SexyState.roundUpToQuarter(lucky(0.25, 0.35) * _toyBank._dickHeartReservoir);
			_toyBank._dickHeartReservoir -= rewardAmount;
			_heartEmitCount += rewardAmount;

			// dump remaining toy "reward hearts" into toy "automatic hearts"
			_toyBank._foreplayHeartReservoir += _toyBank._dickHeartReservoir;
			// increase capacity too, since vibrator throughput scales on capacity
			_toyBank._foreplayHeartReservoirCapacity += SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * 0.6);
			_toyBank._dickHeartReservoir = 0;

			_remainingOrgasms++;
			if (!_male)
			{
				_remainingOrgasms++;
			}
			generateCumshots();
			refreshArousalFromCumshots();
			_newHeadTimer = FlxG.random.float(2, 4) * _headTimerFactor;

			addToyHeartsToOrgasm = true;

			// won't prematurely ejaculate anymore
			microTurnsUntilPrematureEjaculation = 99999;
			turnsUntilPrematureEjaculation = 9999;
			prematureEjaculationTriggers.splice(0, prematureEjaculationTriggers.length);
		}

		if (vibeReservoir > 0 && _pokeWindow._vibe.vibeSfx.isVibrating())
		{
			// convert vibeReservoir to hearts
			_heartEmitCount += vibeReservoir;

			matchVibeHearts();
			maybeAccelerateVibeReward();

			microTurnsUntilPrematureEjaculation -= 1;

			maybeEmitPrecum();

			if (_remainingOrgasms > 0)
			{
				if (microTurnsUntilPrematureEjaculation <= 5)
				{
					maybeEmitWords(almostWords);
				}
				else if (_heartBank.getDickPercent() * 0.63 < _cumThreshold)
				{
					maybeEmitWords(almostWords);
				}
			}

			maybeEmitToyWordsAndStuff();

			if (shouldOrgasm())
			{
				_newHeadTimer = 0; // make sure they orgasm before their reservoir is empty
				consecutiveVibeCount = 0; // reset consecutiveVibeCount in case they multiple orgasm; start fresh
			}
			vibeReservoir = 0;
		}
	}

	/**
	 * If 5 hearts were in the vibe reservoir, we might also "match" 2.5
	 * hearts from the heartbank. This makes it so Heracross will eventually cum
	 * from just using the vibrator.
	 */
	function matchVibeHearts()
	{
		var heartMatchPct:Float = 0;
		if (_toyBank.getForeplayPercent() <= 0 )
		{
			heartMatchPct = 0.50;
		}
		else if (_toyBank.getForeplayPercent() <= 0.25)
		{
			heartMatchPct = 0.43;
		}
		else if (_toyBank.getForeplayPercent() <= 0.50)
		{
			heartMatchPct = 0.36;
		}
		else if (_toyBank.getForeplayPercent() <= 0.75)
		{
			heartMatchPct = 0.30;
		}
		if (consecutiveVibeCount == 0)
		{
			heartMatchPct *= 0.0;
		}
		else if (consecutiveVibeCount == 1)
		{
			heartMatchPct *= 0.5;
		}
		else
		{
			heartMatchPct *= 1.0;
		}
		if (heartMatchPct > 0)
		{
			if (!pastBonerThreshold())
			{
				var deductionAmount:Float = Math.min(SexyState.roundUpToQuarter(vibeReservoir * heartMatchPct), _heartBank._foreplayHeartReservoir);
				_heartBank._foreplayHeartReservoir -= deductionAmount;
				_heartEmitCount += deductionAmount;
			}
			else
			{
				var deductionAmount:Float = Math.min(SexyState.roundUpToQuarter(vibeReservoir * heartMatchPct), _heartBank._dickHeartReservoir);
				_heartBank._dickHeartReservoir -= deductionAmount;
				_heartEmitCount += deductionAmount;
			}
		}
	}

	/**
	 * If the player's lingering on the same spot for multiple time, the
	 * vibrator becomes more effective...
	 */
	function maybeAccelerateVibeReward()
	{
		lastFewVibeSettings.push(vibeString(_pokeWindow._vibe.vibeSfx.mode, _pokeWindow._vibe.vibeSfx.speed));
		lastFewVibeSettings.splice(0, lastFewVibeSettings.length - 5);

		// reduce the timer lower than 1.8s, if the player is lingering on the current setting...
		if (lastFewVibeSettings.length >= 2 && lastFewVibeSettings[lastFewVibeSettings.length - 1] == lastFewVibeSettings[lastFewVibeSettings.length - 2])
		{
			consecutiveVibeCount++;
		}
		else
		{
			consecutiveVibeCount = 0;
		}

		vibeRewardFrequency = FlxMath.bound(11 / (7 + 5 * consecutiveVibeCount), 0.2, 1.6);
	}

	function resetPrematureEjaculationTrigger()
	{
		_autoSweatRate = FlxMath.bound(_autoSweatRate - 0.3, 0, 1);

		blushTimer = Math.min(blushTimer, FlxG.random.float(0, 2));
		if (_pokeWindow._arms0.animation.name == "face-0" || _pokeWindow._arms0.animation.name == "face-1")
		{
			_armsAndLegsArranger._armsAndLegsTimer = Math.min(_armsAndLegsArranger._armsAndLegsTimer, FlxG.random.float(0, 3));
		}
		_pokeWindow._armsUpTimer = 0;

		if (prematureEjaculationTriggers.length == 0)
		{
			prematureEjaculationTrigger = 9999;
		}
		else
		{
			prematureEjaculationTrigger = prematureEjaculationTriggers.pop();
		}
		turnsUntilPrematureEjaculation = 9999;
	}

	function resetHitTheSpotTrigger()
	{
		if (verySpecialSpots.length >= 2)
		{
			hitTheSpotTrigger = 9999;
		}
		else if (hitTheSpotTriggers.length == 0)
		{
			hitTheSpotTrigger = FlxG.random.int(6, 15);
		}
		else
		{
			hitTheSpotTrigger = hitTheSpotTriggers.pop();
		}
	}

	override function shouldEndSexyGame():Bool
	{
		return _gameState == 400
		&& (_heartBank.isEmpty()
		// if they came prematurely, don't wait for the foreplay reservoir to empty
		|| _heartBank._dickHeartReservoir == 0 && didKindaPrematurelyEjaculate)
		&& _heartEmitCount <= 0
		&& (_idlePunishmentTimer > _rubRewardFrequency / 2);
	}

	override public function sexyStuff(elapsed:Float):Void
	{
		super.sexyStuff(elapsed);

		if (blushTimer > 0)
		{
			blushTimer -= elapsed;
			_pokeWindow._blush.visible = true;
		}
		else {
			_pokeWindow._blush.visible = false;
		}

		if (pastBonerThreshold() && _gameState == 200)
		{
			if (fancyRubbing(_dick) && _rubBodyAnim._flxSprite.animation.name == "rub-dick" && _rubBodyAnim.nearMinFrame())
			{
				_rubBodyAnim.setAnimName("jack-off");
				_rubHandAnim.setAnimName("jack-off");
			}
		}

		if (!fancyRubAnimatesSprite(_dick))
		{
			setInactiveDickAnimation();
		}

		if (_gameState >= 400)
		{
			_autoSweatRate = FlxMath.bound(_autoSweatRate - 0.1 * elapsed, 0, 1.0);

			if (_gameState == 400)
			{
				// superclass increments rubrewardtimer in state 400...
			}
			else
			{
				// can keep rubbing Heracross after the game is over
				if (isInteracting())
				{
					_rubRewardTimer += elapsed;
				}
				else
				{
					_rubRewardTimer = 0;
				}
			}

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

		if ((specialRub == "left-antenna" || specialRub == "right-antenna")
				&& (_head.animation.name == "right-eye-swirl" || _head.animation.name == "left-eye-swirl"))
		{
			antennaHeartTimer -= elapsed;
			if (antennaHeartTimer < 0)
			{
				// don't get a boner from antenna rubs
				_heartBank._foreplayHeartReservoirCapacity = Math.max(_heartBank._foreplayHeartReservoirCapacity - 0.5, _heartBank._foreplayHeartReservoir);

				// the fewer hearts are left, the slower they come out...
				var maxTimer:Float = 0;
				if (_heartBank._foreplayHeartReservoir < 2)
				{
					maxTimer = 8;
					interruptBabbleWords();
				}
				else if (_heartBank._foreplayHeartReservoir < 4)
				{
					maxTimer = 5;
					interruptBabbleWords();
				}
				else if (_heartBank._foreplayHeartReservoir < 6)
				{
					maxTimer = 3;
				}
				else if (_heartBank._foreplayHeartReservoir < 8)
				{
					maxTimer = 2;
				}
				else if (_heartBank._foreplayHeartReservoir < 12)
				{
					maxTimer = 1.3;
				}
				else if (_heartBank._foreplayHeartReservoir < 16)
				{
					maxTimer = 0.8;
				}
				else
				{
					maxTimer = 0.5;
				}

				if (maxTimer < 8)
				{
					_heartEmitCount += 0.25;
					_heartBank._foreplayHeartReservoir -= 0.25;
				}

				antennaHeartTimer += maxTimer * Math.pow(FlxG.random.float(0, 1), 1.3);
			}
		}
	}

	override function handleCumShots(elapsed:Float):Void
	{
		super.handleCumShots(elapsed);

		var spoogeEmitter:FlxEmitter = getSpoogeEmitter();
		if (spoogeEmitter.emitting && _male && _dick != null && dickAngleArray[_dick.animation.frameIndex] != null)
		{
			// male heracross cums straight at the viewer; lower cum velocity for illusion of depth
			var velocityNerf:Float = 0.7;

			spoogeEmitter.velocity.start.min.x *= velocityNerf;
			spoogeEmitter.velocity.start.max.x *= velocityNerf;
			spoogeEmitter.velocity.start.min.y *= velocityNerf;
			spoogeEmitter.velocity.start.max.y *= velocityNerf;
			spoogeEmitter.velocity.end.set(spoogeEmitter.velocity.start.min, spoogeEmitter.velocity.start.max);
		}
	}

	override public function touchPart(touchedPart:FlxSprite):Bool
	{
		if (FlxG.mouse.justPressed && (touchedPart == _dick || !_male && touchedPart == _pokeWindow._torso0 && clickedPolygon(touchedPart, vagPolyArray)))
		{
			if (_gameState == 200 && pastBonerThreshold())
			{
				interactOn(_dick, "jack-off");
			}
			else
			{
				interactOn(_dick, "rub-dick");
			}
			return true;
		}
		if (FlxG.mouse.justPressed && touchedPart == _head)
		{
			if (clickedPolygon(touchedPart, leftAntennaPolyArray))
			{
				interactOn(_head, "rub-left-antenna");
				_rubBodyAnim.enabled = false;
				_head.animation.play("rub-left-antenna");
				_pokeWindow.updateBlush();
				return true;
			}
			else if (clickedPolygon(touchedPart, rightAntennaPolyArray))
			{
				interactOn(_head, "rub-right-antenna");
				_rubBodyAnim.enabled = false;
				_head.animation.play("rub-right-antenna");
				_pokeWindow.updateBlush();
				return true;
			}
			else if (clickedPolygon(touchedPart, hornPolyArray))
			{
				interactOn(_head, "rub-horn");
				_rubBodyAnim.enabled = false;
				if (_pokeWindow._arousal <= 1)
				{
					_head.animation.play("rub-horn");
				}
				else
				{
					_head.animation.play("rub-horn2");
				}
				_pokeWindow.updateBlush();
				return true;
			}
		}
		if (FlxG.mouse.justPressed && touchedPart == _pokeWindow._balls)
		{
			interactOn(_pokeWindow._balls, "rub-balls");
			return true;
		}
		return false;
	}

	override function boredStuff():Void
	{
		super.boredStuff();

		if (turnsUntilPrematureEjaculation < 1000 && wordManager.wordsInARow(boredWords) == 2)
		{
			resetPrematureEjaculationTrigger();
			if (meanThings[0])
			{
				meanThings[0] = false;
				doMeanThing(1.0);
			}
			else if (meanThings[1])
			{
				meanThings[1] = false;
				doMeanThing(0.7);
			}
			else
			{
				doMeanThing(0.4);
			}
		}
	}

	override public function untouchPart(touchedPart:FlxSprite):Void
	{
		super.untouchPart(touchedPart);
		if (touchedPart == _head)
		{
			if (_head.animation.name == "right-eye-swirl" || _head.animation.name == "left-eye-swirl")
			{
				_newHeadTimer = FlxG.random.float(1.2, 2.4);
				interruptBabbleWords();
			}
			else
			{
				_newHeadTimer = FlxG.random.float(0.4, 0.8);
			}
		}
	}

	function interruptBabbleWords()
	{
		if (babbleWordParticles != null)
		{
			wordManager.interruptWords(babbleWordParticles);
			babbleWordParticles = null;
		}
	}

	override function shouldInteractOff(targetSprite:FlxSprite)
	{
		if (targetSprite == _head)
		{
			// don't immediately snap the head back to normal; give it a little time
			return false;
		}
		return true;
	}

	override public function initializeHitBoxes():Void
	{
		leftAntennaPolyArray = [];
		leftAntennaPolyArray[0] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(135, 85), new FlxPoint(111, 111)];
		leftAntennaPolyArray[1] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(135, 85), new FlxPoint(111, 111)];
		leftAntennaPolyArray[2] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(135, 85), new FlxPoint(111, 111)];
		leftAntennaPolyArray[3] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(130, 74), new FlxPoint(106, 111)];
		leftAntennaPolyArray[4] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(130, 74), new FlxPoint(106, 111)];
		leftAntennaPolyArray[6] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(130, 74), new FlxPoint(106, 111)];
		leftAntennaPolyArray[7] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(130, 74), new FlxPoint(106, 111)];
		leftAntennaPolyArray[8] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(130, 74), new FlxPoint(106, 111)];
		leftAntennaPolyArray[9] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(131, 88), new FlxPoint(114, 110)];
		leftAntennaPolyArray[10] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(131, 88), new FlxPoint(114, 110)];
		leftAntennaPolyArray[11] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(131, 88), new FlxPoint(114, 110)];
		leftAntennaPolyArray[12] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(135, 85), new FlxPoint(123, 102)];
		leftAntennaPolyArray[13] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(135, 85), new FlxPoint(123, 102)];
		leftAntennaPolyArray[14] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(135, 85), new FlxPoint(123, 102)];
		leftAntennaPolyArray[15] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(132, 89), new FlxPoint(116, 106)];
		leftAntennaPolyArray[16] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(132, 89), new FlxPoint(116, 106)];
		leftAntennaPolyArray[17] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(132, 89), new FlxPoint(116, 106)];
		leftAntennaPolyArray[18] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(128, 84), new FlxPoint(114, 102)];
		leftAntennaPolyArray[19] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(128, 84), new FlxPoint(114, 102)];
		leftAntennaPolyArray[20] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(128, 84), new FlxPoint(114, 102)];
		leftAntennaPolyArray[21] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(131, 85), new FlxPoint(115, 102)];
		leftAntennaPolyArray[22] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(131, 85), new FlxPoint(115, 102)];
		leftAntennaPolyArray[23] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(131, 85), new FlxPoint(115, 102)];
		leftAntennaPolyArray[24] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(137, 91), new FlxPoint(124, 105)];
		leftAntennaPolyArray[25] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(137, 91), new FlxPoint(124, 105)];
		leftAntennaPolyArray[26] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(137, 91), new FlxPoint(124, 105)];
		leftAntennaPolyArray[27] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(132, 85), new FlxPoint(118, 102)];
		leftAntennaPolyArray[28] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(132, 85), new FlxPoint(118, 102)];
		leftAntennaPolyArray[29] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(132, 85), new FlxPoint(118, 102)];
		leftAntennaPolyArray[30] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(136, 43), new FlxPoint(131, 78), new FlxPoint(115, 96)];
		leftAntennaPolyArray[31] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(136, 43), new FlxPoint(131, 78), new FlxPoint(115, 96)];
		leftAntennaPolyArray[32] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(136, 43), new FlxPoint(131, 78), new FlxPoint(115, 96)];
		leftAntennaPolyArray[33] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(130, 86), new FlxPoint(116, 103)];
		leftAntennaPolyArray[34] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(130, 86), new FlxPoint(116, 103)];
		leftAntennaPolyArray[35] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(130, 86), new FlxPoint(116, 103)];
		leftAntennaPolyArray[36] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(127, 86), new FlxPoint(113, 102)];
		leftAntennaPolyArray[37] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(127, 86), new FlxPoint(113, 102)];
		leftAntennaPolyArray[39] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(125, 92), new FlxPoint(112, 105)];
		leftAntennaPolyArray[40] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(125, 92), new FlxPoint(112, 105)];
		leftAntennaPolyArray[42] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(130, 90), new FlxPoint(118, 105)];
		leftAntennaPolyArray[43] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(130, 90), new FlxPoint(118, 105)];
		leftAntennaPolyArray[45] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(131, 88), new FlxPoint(114, 110)];
		leftAntennaPolyArray[46] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(131, 88), new FlxPoint(114, 110)];
		leftAntennaPolyArray[47] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(131, 88), new FlxPoint(114, 110)];
		leftAntennaPolyArray[48] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(123, 82), new FlxPoint(110, 99)];
		leftAntennaPolyArray[49] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(123, 82), new FlxPoint(110, 99)];
		leftAntennaPolyArray[50] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(123, 82), new FlxPoint(110, 99)];
		leftAntennaPolyArray[51] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(149, 80), new FlxPoint(129, 96)];
		leftAntennaPolyArray[52] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(149, 80), new FlxPoint(129, 96)];
		leftAntennaPolyArray[53] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(149, 80), new FlxPoint(129, 96)];
		leftAntennaPolyArray[54] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(131, 86), new FlxPoint(115, 101)];
		leftAntennaPolyArray[55] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(131, 86), new FlxPoint(115, 101)];
		leftAntennaPolyArray[56] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(131, 86), new FlxPoint(115, 101)];
		leftAntennaPolyArray[57] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(131, 88), new FlxPoint(114, 110)];
		leftAntennaPolyArray[58] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(131, 88), new FlxPoint(114, 110)];
		leftAntennaPolyArray[59] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(131, 88), new FlxPoint(114, 110)];
		leftAntennaPolyArray[60] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(135, 45), new FlxPoint(130, 76), new FlxPoint(115, 94)];
		leftAntennaPolyArray[61] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(135, 45), new FlxPoint(130, 76), new FlxPoint(115, 94)];
		leftAntennaPolyArray[63] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(136, 89), new FlxPoint(123, 107)];
		leftAntennaPolyArray[64] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(136, 89), new FlxPoint(123, 107)];
		leftAntennaPolyArray[66] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(135, 86), new FlxPoint(120, 103)];
		leftAntennaPolyArray[67] = [new FlxPoint(56, 98), new FlxPoint(57, 21), new FlxPoint(132, 22), new FlxPoint(135, 86), new FlxPoint(120, 103)];

		rightAntennaPolyArray = [];
		rightAntennaPolyArray[0] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(232, 91), new FlxPoint(248, 104)];
		rightAntennaPolyArray[1] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(232, 91), new FlxPoint(248, 104)];
		rightAntennaPolyArray[2] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(232, 91), new FlxPoint(248, 104)];
		rightAntennaPolyArray[3] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(229, 85), new FlxPoint(246, 102)];
		rightAntennaPolyArray[4] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(229, 85), new FlxPoint(246, 102)];
		rightAntennaPolyArray[6] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(229, 85), new FlxPoint(246, 102)];
		rightAntennaPolyArray[7] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(229, 85), new FlxPoint(246, 102)];
		rightAntennaPolyArray[8] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(229, 85), new FlxPoint(246, 102)];
		rightAntennaPolyArray[9] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(229, 85), new FlxPoint(243, 103)];
		rightAntennaPolyArray[10] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(229, 85), new FlxPoint(243, 103)];
		rightAntennaPolyArray[11] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(229, 85), new FlxPoint(243, 103)];
		rightAntennaPolyArray[12] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(234, 92), new FlxPoint(249, 109)];
		rightAntennaPolyArray[13] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(234, 92), new FlxPoint(249, 109)];
		rightAntennaPolyArray[14] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(234, 92), new FlxPoint(249, 109)];
		rightAntennaPolyArray[15] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(235, 87), new FlxPoint(247, 103)];
		rightAntennaPolyArray[16] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(235, 87), new FlxPoint(247, 103)];
		rightAntennaPolyArray[17] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(235, 87), new FlxPoint(247, 103)];
		rightAntennaPolyArray[18] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(235, 85), new FlxPoint(248, 100)];
		rightAntennaPolyArray[19] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(235, 85), new FlxPoint(248, 100)];
		rightAntennaPolyArray[20] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(235, 85), new FlxPoint(248, 100)];
		rightAntennaPolyArray[21] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(238, 85), new FlxPoint(249, 99)];
		rightAntennaPolyArray[22] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(238, 85), new FlxPoint(249, 99)];
		rightAntennaPolyArray[23] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(238, 85), new FlxPoint(249, 99)];
		rightAntennaPolyArray[24] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(241, 88), new FlxPoint(251, 104)];
		rightAntennaPolyArray[25] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(241, 88), new FlxPoint(251, 104)];
		rightAntennaPolyArray[26] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(241, 88), new FlxPoint(251, 104)];
		rightAntennaPolyArray[27] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(241, 79), new FlxPoint(256, 99)];
		rightAntennaPolyArray[28] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(241, 79), new FlxPoint(256, 99)];
		rightAntennaPolyArray[29] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(241, 79), new FlxPoint(256, 99)];
		rightAntennaPolyArray[30] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(218, 77), new FlxPoint(230, 95)];
		rightAntennaPolyArray[31] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(218, 77), new FlxPoint(230, 95)];
		rightAntennaPolyArray[32] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(218, 77), new FlxPoint(230, 95)];
		rightAntennaPolyArray[33] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(239, 83), new FlxPoint(249, 102)];
		rightAntennaPolyArray[34] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(239, 83), new FlxPoint(249, 102)];
		rightAntennaPolyArray[35] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(239, 83), new FlxPoint(249, 102)];
		rightAntennaPolyArray[36] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(234, 85), new FlxPoint(246, 101)];
		rightAntennaPolyArray[37] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(234, 85), new FlxPoint(246, 101)];
		rightAntennaPolyArray[39] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(228, 92), new FlxPoint(242, 104)];
		rightAntennaPolyArray[40] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(228, 92), new FlxPoint(242, 104)];
		rightAntennaPolyArray[42] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(236, 89), new FlxPoint(246, 103)];
		rightAntennaPolyArray[43] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(236, 89), new FlxPoint(246, 103)];
		rightAntennaPolyArray[45] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(229, 85), new FlxPoint(243, 103)];
		rightAntennaPolyArray[46] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(229, 85), new FlxPoint(243, 103)];
		rightAntennaPolyArray[47] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(229, 85), new FlxPoint(243, 103)];
		rightAntennaPolyArray[48] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(233, 82), new FlxPoint(241, 99)];
		rightAntennaPolyArray[49] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(233, 82), new FlxPoint(241, 99)];
		rightAntennaPolyArray[50] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(233, 82), new FlxPoint(241, 99)];
		rightAntennaPolyArray[51] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(229, 18), new FlxPoint(235, 75), new FlxPoint(252, 93)];
		rightAntennaPolyArray[52] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(229, 18), new FlxPoint(235, 75), new FlxPoint(252, 93)];
		rightAntennaPolyArray[53] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(229, 18), new FlxPoint(235, 75), new FlxPoint(252, 93)];
		rightAntennaPolyArray[54] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(229, 18), new FlxPoint(238, 85), new FlxPoint(251, 102)];
		rightAntennaPolyArray[55] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(229, 18), new FlxPoint(238, 85), new FlxPoint(251, 102)];
		rightAntennaPolyArray[56] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(229, 18), new FlxPoint(238, 85), new FlxPoint(251, 102)];
		rightAntennaPolyArray[57] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(229, 85), new FlxPoint(243, 103)];
		rightAntennaPolyArray[58] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(229, 85), new FlxPoint(243, 103)];
		rightAntennaPolyArray[59] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(216, 21), new FlxPoint(229, 85), new FlxPoint(243, 103)];
		rightAntennaPolyArray[60] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(229, 18), new FlxPoint(219, 72), new FlxPoint(231, 96)];
		rightAntennaPolyArray[61] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(229, 18), new FlxPoint(219, 72), new FlxPoint(231, 96)];
		rightAntennaPolyArray[63] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(229, 18), new FlxPoint(239, 84), new FlxPoint(250, 104)];
		rightAntennaPolyArray[64] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(229, 18), new FlxPoint(239, 84), new FlxPoint(250, 104)];
		rightAntennaPolyArray[66] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(229, 18), new FlxPoint(235, 92), new FlxPoint(246, 106)];
		rightAntennaPolyArray[67] = [new FlxPoint(303, 113), new FlxPoint(303, 17), new FlxPoint(229, 18), new FlxPoint(235, 92), new FlxPoint(246, 106)];

		hornPolyArray = [];
		hornPolyArray[0] = [new FlxPoint(151, 94), new FlxPoint(141, 10), new FlxPoint(225, 10), new FlxPoint(210, 93)];
		hornPolyArray[1] = [new FlxPoint(151, 94), new FlxPoint(141, 10), new FlxPoint(225, 10), new FlxPoint(210, 93)];
		hornPolyArray[2] = [new FlxPoint(151, 94), new FlxPoint(141, 10), new FlxPoint(225, 10), new FlxPoint(210, 93)];
		hornPolyArray[3] = [new FlxPoint(149, 92), new FlxPoint(143, 10), new FlxPoint(223, 10), new FlxPoint(207, 89)];
		hornPolyArray[4] = [new FlxPoint(149, 92), new FlxPoint(143, 10), new FlxPoint(223, 10), new FlxPoint(207, 89)];
		hornPolyArray[6] = [new FlxPoint(149, 91), new FlxPoint(147, 10), new FlxPoint(209, 10), new FlxPoint(210, 90)];
		hornPolyArray[7] = [new FlxPoint(149, 91), new FlxPoint(147, 10), new FlxPoint(209, 10), new FlxPoint(210, 90)];
		hornPolyArray[8] = [new FlxPoint(149, 91), new FlxPoint(147, 10), new FlxPoint(209, 10), new FlxPoint(210, 90)];
		hornPolyArray[9] = [new FlxPoint(150, 94), new FlxPoint(145, 10), new FlxPoint(206, 10), new FlxPoint(210, 89)];
		hornPolyArray[10] = [new FlxPoint(150, 94), new FlxPoint(145, 10), new FlxPoint(206, 10), new FlxPoint(210, 89)];
		hornPolyArray[11] = [new FlxPoint(150, 94), new FlxPoint(145, 10), new FlxPoint(206, 10), new FlxPoint(210, 89)];
		hornPolyArray[12] = [new FlxPoint(155, 87), new FlxPoint(160, 10), new FlxPoint(220, 10), new FlxPoint(215, 94)];
		hornPolyArray[13] = [new FlxPoint(155, 87), new FlxPoint(160, 10), new FlxPoint(220, 10), new FlxPoint(215, 94)];
		hornPolyArray[14] = [new FlxPoint(155, 87), new FlxPoint(160, 10), new FlxPoint(220, 10), new FlxPoint(215, 94)];
		hornPolyArray[15] = [new FlxPoint(156, 93), new FlxPoint(153, 10), new FlxPoint(217, 10), new FlxPoint(213, 93)];
		hornPolyArray[16] = [new FlxPoint(156, 93), new FlxPoint(153, 10), new FlxPoint(217, 10), new FlxPoint(213, 93)];
		hornPolyArray[17] = [new FlxPoint(156, 93), new FlxPoint(153, 10), new FlxPoint(217, 10), new FlxPoint(213, 93)];
		hornPolyArray[18] = [new FlxPoint(151, 89), new FlxPoint(149, 10), new FlxPoint(215, 10), new FlxPoint(214, 86)];
		hornPolyArray[19] = [new FlxPoint(151, 89), new FlxPoint(149, 10), new FlxPoint(215, 10), new FlxPoint(214, 86)];
		hornPolyArray[20] = [new FlxPoint(151, 89), new FlxPoint(149, 10), new FlxPoint(215, 10), new FlxPoint(214, 86)];
		hornPolyArray[21] = [new FlxPoint(151, 86), new FlxPoint(150, 10), new FlxPoint(221, 10), new FlxPoint(215, 88)];
		hornPolyArray[22] = [new FlxPoint(151, 86), new FlxPoint(150, 10), new FlxPoint(221, 10), new FlxPoint(215, 88)];
		hornPolyArray[23] = [new FlxPoint(151, 86), new FlxPoint(150, 10), new FlxPoint(221, 10), new FlxPoint(215, 88)];
		hornPolyArray[24] = [new FlxPoint(162, 93), new FlxPoint(150, 10), new FlxPoint(220, 10), new FlxPoint(221, 95)];
		hornPolyArray[25] = [new FlxPoint(162, 93), new FlxPoint(150, 10), new FlxPoint(220, 10), new FlxPoint(221, 95)];
		hornPolyArray[26] = [new FlxPoint(162, 93), new FlxPoint(150, 10), new FlxPoint(220, 10), new FlxPoint(221, 95)];
		hornPolyArray[27] = [new FlxPoint(157, 87), new FlxPoint(152, 10), new FlxPoint(216, 10), new FlxPoint(215, 89)];
		hornPolyArray[28] = [new FlxPoint(157, 87), new FlxPoint(152, 10), new FlxPoint(216, 10), new FlxPoint(215, 89)];
		hornPolyArray[29] = [new FlxPoint(157, 87), new FlxPoint(152, 10), new FlxPoint(216, 10), new FlxPoint(215, 89)];
		hornPolyArray[30] = [new FlxPoint(133, 90), new FlxPoint(138, 10), new FlxPoint(195, 10), new FlxPoint(191, 83)];
		hornPolyArray[31] = [new FlxPoint(133, 90), new FlxPoint(138, 10), new FlxPoint(195, 10), new FlxPoint(191, 83)];
		hornPolyArray[32] = [new FlxPoint(133, 90), new FlxPoint(138, 10), new FlxPoint(195, 10), new FlxPoint(191, 83)];
		hornPolyArray[33] = [new FlxPoint(152, 85), new FlxPoint(150, 10), new FlxPoint(222, 10), new FlxPoint(214, 86)];
		hornPolyArray[34] = [new FlxPoint(152, 85), new FlxPoint(150, 10), new FlxPoint(222, 10), new FlxPoint(214, 86)];
		hornPolyArray[35] = [new FlxPoint(152, 85), new FlxPoint(150, 10), new FlxPoint(222, 10), new FlxPoint(214, 86)];
		hornPolyArray[36] = [new FlxPoint(150, 86), new FlxPoint(148, 10), new FlxPoint(218, 10), new FlxPoint(213, 86)];
		hornPolyArray[37] = [new FlxPoint(150, 86), new FlxPoint(148, 10), new FlxPoint(218, 10), new FlxPoint(213, 86)];
		hornPolyArray[39] = [new FlxPoint(143, 94), new FlxPoint(144, 10), new FlxPoint(218, 10), new FlxPoint(204, 93)];
		hornPolyArray[40] = [new FlxPoint(143, 94), new FlxPoint(144, 10), new FlxPoint(218, 10), new FlxPoint(204, 93)];
		hornPolyArray[42] = [new FlxPoint(153, 91), new FlxPoint(150, 10), new FlxPoint(219, 10), new FlxPoint(209, 93)];
		hornPolyArray[43] = [new FlxPoint(153, 91), new FlxPoint(150, 10), new FlxPoint(219, 10), new FlxPoint(209, 93)];
		hornPolyArray[45] = [new FlxPoint(151, 94), new FlxPoint(137, 10), new FlxPoint(217, 10), new FlxPoint(209, 88)];
		hornPolyArray[46] = [new FlxPoint(151, 94), new FlxPoint(137, 10), new FlxPoint(217, 10), new FlxPoint(209, 88)];
		hornPolyArray[47] = [new FlxPoint(151, 94), new FlxPoint(137, 10), new FlxPoint(217, 10), new FlxPoint(209, 88)];
		hornPolyArray[48] = [new FlxPoint(149, 89), new FlxPoint(143, 10), new FlxPoint(221, 10), new FlxPoint(208, 88)];
		hornPolyArray[49] = [new FlxPoint(149, 89), new FlxPoint(143, 10), new FlxPoint(221, 10), new FlxPoint(208, 88)];
		hornPolyArray[50] = [new FlxPoint(149, 89), new FlxPoint(143, 10), new FlxPoint(221, 10), new FlxPoint(208, 88)];
		hornPolyArray[51] = [new FlxPoint(172, 83), new FlxPoint(158, 10), new FlxPoint(230, 10), new FlxPoint(232, 90)];
		hornPolyArray[52] = [new FlxPoint(172, 83), new FlxPoint(158, 10), new FlxPoint(230, 10), new FlxPoint(232, 90)];
		hornPolyArray[53] = [new FlxPoint(172, 83), new FlxPoint(158, 10), new FlxPoint(230, 10), new FlxPoint(232, 90)];
		hornPolyArray[54] = [new FlxPoint(152, 87), new FlxPoint(147, 10), new FlxPoint(225, 10), new FlxPoint(214, 87)];
		hornPolyArray[55] = [new FlxPoint(152, 87), new FlxPoint(147, 10), new FlxPoint(225, 10), new FlxPoint(214, 87)];
		hornPolyArray[56] = [new FlxPoint(152, 87), new FlxPoint(147, 10), new FlxPoint(225, 10), new FlxPoint(214, 87)];
		hornPolyArray[57] = [new FlxPoint(150, 93), new FlxPoint(137, 10), new FlxPoint(215, 10), new FlxPoint(208, 88)];
		hornPolyArray[58] = [new FlxPoint(150, 93), new FlxPoint(137, 10), new FlxPoint(215, 10), new FlxPoint(208, 88)];
		hornPolyArray[59] = [new FlxPoint(150, 93), new FlxPoint(137, 10), new FlxPoint(215, 10), new FlxPoint(208, 88)];
		hornPolyArray[60] = [new FlxPoint(133, 90), new FlxPoint(134, 10), new FlxPoint(204, 10), new FlxPoint(191, 83)];
		hornPolyArray[61] = [new FlxPoint(133, 90), new FlxPoint(134, 10), new FlxPoint(204, 10), new FlxPoint(191, 83)];
		hornPolyArray[63] = [new FlxPoint(163, 92), new FlxPoint(148, 10), new FlxPoint(220, 10), new FlxPoint(222, 96)];
		hornPolyArray[64] = [new FlxPoint(163, 92), new FlxPoint(148, 10), new FlxPoint(220, 10), new FlxPoint(222, 96)];
		hornPolyArray[66] = [new FlxPoint(156, 87), new FlxPoint(154, 10), new FlxPoint(229, 10), new FlxPoint(214, 93)];
		hornPolyArray[67] = [new FlxPoint(156, 87), new FlxPoint(154, 10), new FlxPoint(229, 10), new FlxPoint(214, 93)];

		vagPolyArray = [];
		vagPolyArray[0] = [new FlxPoint(147, 427), new FlxPoint(165, 363), new FlxPoint(203, 364), new FlxPoint(220, 427)];

		if (_male)
		{
			dickAngleArray[0] = [new FlxPoint(182, 405), new FlxPoint(63, 252), new FlxPoint(-43, 256)];
			dickAngleArray[1] = [new FlxPoint(190, 383), new FlxPoint(259, -24), new FlxPoint(116, 233)];
			dickAngleArray[2] = [new FlxPoint(179, 372), new FlxPoint(255, -51), new FlxPoint(-255, -51)];
			dickAngleArray[3] = [new FlxPoint(178, 334), new FlxPoint(82, -247), new FlxPoint(-122, -229)];
			dickAngleArray[4] = [new FlxPoint(180, 388), new FlxPoint(216, 144), new FlxPoint(-203, 162)];
			dickAngleArray[5] = [new FlxPoint(180, 386), new FlxPoint(233, 116), new FlxPoint(-200, 166)];
			dickAngleArray[6] = [new FlxPoint(180, 386), new FlxPoint(233, 116), new FlxPoint(-200, 166)];
			dickAngleArray[7] = [new FlxPoint(180, 386), new FlxPoint(233, 116), new FlxPoint(-200, 166)];
			dickAngleArray[8] = [new FlxPoint(180, 386), new FlxPoint(233, 116), new FlxPoint(-200, 166)];
			dickAngleArray[9] = [new FlxPoint(178, 338), new FlxPoint(71, -250), new FlxPoint(-116, -233)];
			dickAngleArray[10] = [new FlxPoint(178, 337), new FlxPoint(76, -249), new FlxPoint(-93, -243)];
			dickAngleArray[11] = [new FlxPoint(178, 336), new FlxPoint(76, -249), new FlxPoint(-93, -243)];
			dickAngleArray[12] = [new FlxPoint(178, 332), new FlxPoint(93, -243), new FlxPoint(-109, -236)];
			dickAngleArray[13] = [new FlxPoint(178, 331), new FlxPoint(93, -243), new FlxPoint(-102, -239)];
			dickAngleArray[14] = [new FlxPoint(178, 329), new FlxPoint(82, -247), new FlxPoint(-109, -236)];
			dickAngleArray[15] = [new FlxPoint(178, 326), new FlxPoint(194, -173), new FlxPoint( -203, -162)];

			dickVibeAngleArray[0] = [new FlxPoint(181, 406), new FlxPoint(108, 237), new FlxPoint(-102, 239)];
			dickVibeAngleArray[1] = [new FlxPoint(181, 406), new FlxPoint(203, 162), new FlxPoint(-201, 165)];
			dickVibeAngleArray[2] = [new FlxPoint(181, 406), new FlxPoint(119, 231), new FlxPoint(-255, 52)];
			dickVibeAngleArray[3] = [new FlxPoint(181, 406), new FlxPoint(260, 10), new FlxPoint(-139, 220)];
			dickVibeAngleArray[4] = [new FlxPoint(181, 404), new FlxPoint(229, 123), new FlxPoint(-205, 160)];
			dickVibeAngleArray[5] = [new FlxPoint(179, 371), new FlxPoint(256, -48), new FlxPoint(-255, -49)];
			dickVibeAngleArray[6] = [new FlxPoint(179, 371), new FlxPoint(247, -82), new FlxPoint(-246, -85)];
			dickVibeAngleArray[7] = [new FlxPoint(179, 371), new FlxPoint(247, -82), new FlxPoint(-246, -85)];
			dickVibeAngleArray[8] = [new FlxPoint(179, 371), new FlxPoint(247, -82), new FlxPoint(-246, -85)];
			dickVibeAngleArray[9] = [new FlxPoint(179, 371), new FlxPoint(247, -82), new FlxPoint(-246, -85)];
			dickVibeAngleArray[10] = [new FlxPoint(178, 336), new FlxPoint(37, -257), new FlxPoint(-54, -254)];
			dickVibeAngleArray[11] = [new FlxPoint(178, 336), new FlxPoint(140, -219), new FlxPoint(-156, -208)];
			dickVibeAngleArray[12] = [new FlxPoint(178, 336), new FlxPoint(-19, -259), new FlxPoint(-254, -54)];
			dickVibeAngleArray[13] = [new FlxPoint(181, 336), new FlxPoint(198, -169), new FlxPoint(-20, -259)];
			dickVibeAngleArray[14] = [new FlxPoint(178, 332), new FlxPoint(175, -192), new FlxPoint( -188, -180)];

			electricPolyArray = new Array<Array<FlxPoint>>();
			electricPolyArray[0] = [new FlxPoint(152, 359), new FlxPoint(148, 386), new FlxPoint(222, 388), new FlxPoint(218, 360)];
			electricPolyArray[1] = [new FlxPoint(152, 359), new FlxPoint(148, 386), new FlxPoint(222, 388), new FlxPoint(218, 360)];
			electricPolyArray[2] = [new FlxPoint(152, 359), new FlxPoint(148, 386), new FlxPoint(222, 388), new FlxPoint(218, 360)];
			electricPolyArray[3] = [new FlxPoint(152, 359), new FlxPoint(148, 386), new FlxPoint(222, 388), new FlxPoint(218, 360)];
			electricPolyArray[4] = [new FlxPoint(152, 359), new FlxPoint(148, 386), new FlxPoint(222, 388), new FlxPoint(218, 360)];
			electricPolyArray[5] = [new FlxPoint(150, 354), new FlxPoint(142, 369), new FlxPoint(148, 386), new FlxPoint(214, 386), new FlxPoint(222, 369), new FlxPoint(214, 351)];
			electricPolyArray[6] = [new FlxPoint(150, 354), new FlxPoint(142, 369), new FlxPoint(148, 386), new FlxPoint(214, 386), new FlxPoint(222, 369), new FlxPoint(214, 351)];
			electricPolyArray[7] = [new FlxPoint(150, 354), new FlxPoint(142, 369), new FlxPoint(148, 386), new FlxPoint(214, 386), new FlxPoint(222, 369), new FlxPoint(214, 351)];
			electricPolyArray[8] = [new FlxPoint(150, 354), new FlxPoint(142, 369), new FlxPoint(148, 386), new FlxPoint(214, 386), new FlxPoint(222, 369), new FlxPoint(214, 351)];
			electricPolyArray[9] = [new FlxPoint(150, 354), new FlxPoint(142, 369), new FlxPoint(148, 386), new FlxPoint(214, 386), new FlxPoint(222, 369), new FlxPoint(214, 351)];
			electricPolyArray[10] = [new FlxPoint(150, 335), new FlxPoint(136, 347), new FlxPoint(146, 372), new FlxPoint(220, 370), new FlxPoint(228, 348), new FlxPoint(212, 334)];
			electricPolyArray[11] = [new FlxPoint(150, 335), new FlxPoint(136, 347), new FlxPoint(146, 372), new FlxPoint(220, 370), new FlxPoint(228, 348), new FlxPoint(212, 334)];
			electricPolyArray[12] = [new FlxPoint(150, 335), new FlxPoint(136, 347), new FlxPoint(146, 372), new FlxPoint(220, 370), new FlxPoint(228, 348), new FlxPoint(212, 334)];
			electricPolyArray[13] = [new FlxPoint(150, 335), new FlxPoint(136, 347), new FlxPoint(146, 372), new FlxPoint(220, 370), new FlxPoint(228, 348), new FlxPoint(212, 334)];
			electricPolyArray[14] = [new FlxPoint(150, 335), new FlxPoint(136, 347), new FlxPoint(146, 372), new FlxPoint(220, 370), new FlxPoint(228, 348), new FlxPoint(212, 334)];
		}
		else {
			dickAngleArray[0] = [new FlxPoint(178, 392), new FlxPoint(136, 221), new FlxPoint(-136, 221)];
			dickAngleArray[1] = [new FlxPoint(178, 392), new FlxPoint(136, 221), new FlxPoint(-136, 221)];
			dickAngleArray[2] = [new FlxPoint(178, 392), new FlxPoint(176, 192), new FlxPoint(-129, 226)];
			dickAngleArray[3] = [new FlxPoint(178, 392), new FlxPoint(196, 170), new FlxPoint(-162, 203)];
			dickAngleArray[4] = [new FlxPoint(179, 391), new FlxPoint(225, 131), new FlxPoint(-219, 140)];
			dickAngleArray[5] = [new FlxPoint(178, 393), new FlxPoint(136, 221), new FlxPoint(-136, 221)];
			dickAngleArray[6] = [new FlxPoint(178, 393), new FlxPoint(184, 184), new FlxPoint(-184, 184)];
			dickAngleArray[7] = [new FlxPoint(178, 393), new FlxPoint(201, 165), new FlxPoint(-201, 165)];
			dickAngleArray[8] = [new FlxPoint(178, 393), new FlxPoint(233, 116), new FlxPoint(-225, 130)];
			dickAngleArray[9] = [new FlxPoint(178, 393), new FlxPoint(237, 106), new FlxPoint( -233, 116)];

			dickVibeAngleArray[0] = [new FlxPoint(178, 391), new FlxPoint(142, 218), new FlxPoint(-142, 218)];
			dickVibeAngleArray[1] = [new FlxPoint(178, 391), new FlxPoint(225, 131), new FlxPoint(-260, 7)];
			dickVibeAngleArray[2] = [new FlxPoint(178, 391), new FlxPoint(225, 131), new FlxPoint(-236, 109)];
			dickVibeAngleArray[3] = [new FlxPoint(178, 391), new FlxPoint(225, 131), new FlxPoint(-236, 109)];
			dickVibeAngleArray[4] = [new FlxPoint(178, 391), new FlxPoint(225, 131), new FlxPoint(-236, 109)];
			dickVibeAngleArray[5] = [new FlxPoint(178, 391), new FlxPoint(259, 24), new FlxPoint( -226, 128)];

			electricPolyArray = new Array<Array<FlxPoint>>();
			electricPolyArray[0] = [new FlxPoint(170, 387), new FlxPoint(172, 405), new FlxPoint(196, 406), new FlxPoint(194, 386)];
			electricPolyArray[1] = [new FlxPoint(170, 387), new FlxPoint(172, 405), new FlxPoint(196, 406), new FlxPoint(194, 386)];
			electricPolyArray[2] = [new FlxPoint(170, 387), new FlxPoint(172, 405), new FlxPoint(196, 406), new FlxPoint(194, 386)];
			electricPolyArray[3] = [new FlxPoint(170, 387), new FlxPoint(172, 405), new FlxPoint(196, 406), new FlxPoint(194, 386)];
			electricPolyArray[4] = [new FlxPoint(170, 387), new FlxPoint(172, 405), new FlxPoint(196, 406), new FlxPoint(194, 386)];
			electricPolyArray[5] = [new FlxPoint(170, 387), new FlxPoint(172, 405), new FlxPoint(196, 406), new FlxPoint(194, 386)];
		}

		headSweatArray = [];
		headSweatArray[0] = [new FlxPoint(152, 91), new FlxPoint(124, 82), new FlxPoint(162, 59), new FlxPoint(210, 59), new FlxPoint(244, 82), new FlxPoint(207, 97), new FlxPoint(202, 122), new FlxPoint(163, 120)];
		headSweatArray[1] = [new FlxPoint(152, 91), new FlxPoint(124, 82), new FlxPoint(162, 59), new FlxPoint(210, 59), new FlxPoint(244, 82), new FlxPoint(207, 97), new FlxPoint(202, 122), new FlxPoint(163, 120)];
		headSweatArray[2] = [new FlxPoint(152, 91), new FlxPoint(124, 82), new FlxPoint(162, 59), new FlxPoint(210, 59), new FlxPoint(244, 82), new FlxPoint(207, 97), new FlxPoint(202, 122), new FlxPoint(163, 120)];
		headSweatArray[3] = [new FlxPoint(148, 94), new FlxPoint(119, 80), new FlxPoint(156, 55), new FlxPoint(208, 57), new FlxPoint(240, 78), new FlxPoint(202, 97), new FlxPoint(196, 122), new FlxPoint(155, 124)];
		headSweatArray[4] = [new FlxPoint(148, 94), new FlxPoint(119, 80), new FlxPoint(156, 55), new FlxPoint(208, 57), new FlxPoint(240, 78), new FlxPoint(202, 97), new FlxPoint(196, 122), new FlxPoint(155, 124)];
		headSweatArray[6] = [new FlxPoint(148, 94), new FlxPoint(119, 80), new FlxPoint(156, 55), new FlxPoint(208, 57), new FlxPoint(240, 78), new FlxPoint(202, 97), new FlxPoint(196, 122), new FlxPoint(155, 124)];
		headSweatArray[7] = [new FlxPoint(148, 94), new FlxPoint(119, 80), new FlxPoint(156, 55), new FlxPoint(208, 57), new FlxPoint(240, 78), new FlxPoint(202, 97), new FlxPoint(196, 122), new FlxPoint(155, 124)];
		headSweatArray[8] = [new FlxPoint(148, 94), new FlxPoint(119, 80), new FlxPoint(156, 55), new FlxPoint(208, 57), new FlxPoint(240, 78), new FlxPoint(202, 97), new FlxPoint(196, 122), new FlxPoint(155, 124)];
		headSweatArray[9] = [new FlxPoint(152, 95), new FlxPoint(118, 82), new FlxPoint(154, 61), new FlxPoint(202, 58), new FlxPoint(240, 77), new FlxPoint(207, 92), new FlxPoint(199, 117), new FlxPoint(162, 121)];
		headSweatArray[10] = [new FlxPoint(152, 95), new FlxPoint(118, 82), new FlxPoint(154, 61), new FlxPoint(202, 58), new FlxPoint(240, 77), new FlxPoint(207, 92), new FlxPoint(199, 117), new FlxPoint(162, 121)];
		headSweatArray[11] = [new FlxPoint(152, 95), new FlxPoint(118, 82), new FlxPoint(154, 61), new FlxPoint(202, 58), new FlxPoint(240, 77), new FlxPoint(207, 92), new FlxPoint(199, 117), new FlxPoint(162, 121)];
		headSweatArray[12] = [new FlxPoint(157, 89), new FlxPoint(126, 75), new FlxPoint(163, 55), new FlxPoint(211, 60), new FlxPoint(243, 81), new FlxPoint(211, 98), new FlxPoint(204, 127), new FlxPoint(163, 122)];
		headSweatArray[13] = [new FlxPoint(157, 89), new FlxPoint(126, 75), new FlxPoint(163, 55), new FlxPoint(211, 60), new FlxPoint(243, 81), new FlxPoint(211, 98), new FlxPoint(204, 127), new FlxPoint(163, 122)];
		headSweatArray[14] = [new FlxPoint(157, 89), new FlxPoint(126, 75), new FlxPoint(163, 55), new FlxPoint(211, 60), new FlxPoint(243, 81), new FlxPoint(211, 98), new FlxPoint(204, 127), new FlxPoint(163, 122)];
		headSweatArray[15] = [new FlxPoint(158, 90), new FlxPoint(123, 80), new FlxPoint(162, 57), new FlxPoint(205, 59), new FlxPoint(243, 81), new FlxPoint(208, 96), new FlxPoint(205, 120), new FlxPoint(163, 120)];
		headSweatArray[16] = [new FlxPoint(158, 90), new FlxPoint(123, 80), new FlxPoint(162, 57), new FlxPoint(205, 59), new FlxPoint(243, 81), new FlxPoint(208, 96), new FlxPoint(205, 120), new FlxPoint(163, 120)];
		headSweatArray[17] = [new FlxPoint(158, 90), new FlxPoint(123, 80), new FlxPoint(162, 57), new FlxPoint(205, 59), new FlxPoint(243, 81), new FlxPoint(208, 96), new FlxPoint(205, 120), new FlxPoint(163, 120)];
		headSweatArray[18] = [new FlxPoint(151, 86), new FlxPoint(124, 76), new FlxPoint(156, 55), new FlxPoint(207, 59), new FlxPoint(240, 77), new FlxPoint(206, 93), new FlxPoint(199, 113), new FlxPoint(165, 113)];
		headSweatArray[19] = [new FlxPoint(151, 86), new FlxPoint(124, 76), new FlxPoint(156, 55), new FlxPoint(207, 59), new FlxPoint(240, 77), new FlxPoint(206, 93), new FlxPoint(199, 113), new FlxPoint(165, 113)];
		headSweatArray[20] = [new FlxPoint(151, 86), new FlxPoint(124, 76), new FlxPoint(156, 55), new FlxPoint(207, 59), new FlxPoint(240, 77), new FlxPoint(206, 93), new FlxPoint(199, 113), new FlxPoint(165, 113)];
		headSweatArray[21] = [new FlxPoint(158, 91), new FlxPoint(126, 76), new FlxPoint(159, 56), new FlxPoint(212, 59), new FlxPoint(243, 81), new FlxPoint(207, 93), new FlxPoint(202, 118), new FlxPoint(164, 117)];
		headSweatArray[22] = [new FlxPoint(158, 91), new FlxPoint(126, 76), new FlxPoint(159, 56), new FlxPoint(212, 59), new FlxPoint(243, 81), new FlxPoint(207, 93), new FlxPoint(202, 118), new FlxPoint(164, 117)];
		headSweatArray[23] = [new FlxPoint(158, 91), new FlxPoint(126, 76), new FlxPoint(159, 56), new FlxPoint(212, 59), new FlxPoint(243, 81), new FlxPoint(207, 93), new FlxPoint(202, 118), new FlxPoint(164, 117)];
		headSweatArray[24] = [new FlxPoint(163, 93), new FlxPoint(128, 76), new FlxPoint(164, 59), new FlxPoint(218, 64), new FlxPoint(243, 84), new FlxPoint(219, 100), new FlxPoint(215, 121), new FlxPoint(170, 123)];
		headSweatArray[25] = [new FlxPoint(163, 93), new FlxPoint(128, 76), new FlxPoint(164, 59), new FlxPoint(218, 64), new FlxPoint(243, 84), new FlxPoint(219, 100), new FlxPoint(215, 121), new FlxPoint(170, 123)];
		headSweatArray[26] = [new FlxPoint(163, 93), new FlxPoint(128, 76), new FlxPoint(164, 59), new FlxPoint(218, 64), new FlxPoint(243, 84), new FlxPoint(219, 100), new FlxPoint(215, 121), new FlxPoint(170, 123)];
		headSweatArray[27] = [new FlxPoint(158, 87), new FlxPoint(127, 74), new FlxPoint(162, 51), new FlxPoint(209, 57), new FlxPoint(244, 80), new FlxPoint(215, 97), new FlxPoint(214, 117), new FlxPoint(168, 116)];
		headSweatArray[28] = [new FlxPoint(158, 87), new FlxPoint(127, 74), new FlxPoint(162, 51), new FlxPoint(209, 57), new FlxPoint(244, 80), new FlxPoint(215, 97), new FlxPoint(214, 117), new FlxPoint(168, 116)];
		headSweatArray[29] = [new FlxPoint(158, 87), new FlxPoint(127, 74), new FlxPoint(162, 51), new FlxPoint(209, 57), new FlxPoint(244, 80), new FlxPoint(215, 97), new FlxPoint(214, 117), new FlxPoint(168, 116)];
		headSweatArray[30] = [new FlxPoint(133, 93), new FlxPoint(121, 82), new FlxPoint(138, 65), new FlxPoint(196, 57), new FlxPoint(220, 79), new FlxPoint(184, 98), new FlxPoint(180, 115), new FlxPoint(136, 114)];
		headSweatArray[31] = [new FlxPoint(133, 93), new FlxPoint(121, 82), new FlxPoint(138, 65), new FlxPoint(196, 57), new FlxPoint(220, 79), new FlxPoint(184, 98), new FlxPoint(180, 115), new FlxPoint(136, 114)];
		headSweatArray[32] = [new FlxPoint(133, 93), new FlxPoint(121, 82), new FlxPoint(138, 65), new FlxPoint(196, 57), new FlxPoint(220, 79), new FlxPoint(184, 98), new FlxPoint(180, 115), new FlxPoint(136, 114)];
		headSweatArray[33] = [new FlxPoint(156, 85), new FlxPoint(122, 77), new FlxPoint(159, 57), new FlxPoint(208, 55), new FlxPoint(244, 81), new FlxPoint(207, 90), new FlxPoint(199, 110), new FlxPoint(166, 114)];
		headSweatArray[34] = [new FlxPoint(156, 85), new FlxPoint(122, 77), new FlxPoint(159, 57), new FlxPoint(208, 55), new FlxPoint(244, 81), new FlxPoint(207, 90), new FlxPoint(199, 110), new FlxPoint(166, 114)];
		headSweatArray[35] = [new FlxPoint(156, 85), new FlxPoint(122, 77), new FlxPoint(159, 57), new FlxPoint(208, 55), new FlxPoint(244, 81), new FlxPoint(207, 90), new FlxPoint(199, 110), new FlxPoint(166, 114)];
		headSweatArray[36] = [new FlxPoint(152, 84), new FlxPoint(123, 76), new FlxPoint(157, 57), new FlxPoint(207, 57), new FlxPoint(241, 79), new FlxPoint(206, 91), new FlxPoint(201, 111), new FlxPoint(164, 113)];
		headSweatArray[37] = [new FlxPoint(152, 84), new FlxPoint(123, 76), new FlxPoint(157, 57), new FlxPoint(207, 57), new FlxPoint(241, 79), new FlxPoint(206, 91), new FlxPoint(201, 111), new FlxPoint(164, 113)];
		headSweatArray[39] = [new FlxPoint(143, 96), new FlxPoint(121, 83), new FlxPoint(148, 63), new FlxPoint(202, 59), new FlxPoint(234, 84), new FlxPoint(201, 99), new FlxPoint(196, 124), new FlxPoint(152, 121)];
		headSweatArray[40] = [new FlxPoint(143, 96), new FlxPoint(121, 83), new FlxPoint(148, 63), new FlxPoint(202, 59), new FlxPoint(234, 84), new FlxPoint(201, 99), new FlxPoint(196, 124), new FlxPoint(152, 121)];
		headSweatArray[42] = [new FlxPoint(158, 91), new FlxPoint(122, 81), new FlxPoint(158, 58), new FlxPoint(208, 60), new FlxPoint(241, 79), new FlxPoint(205, 96), new FlxPoint(201, 121), new FlxPoint(161, 119)];
		headSweatArray[43] = [new FlxPoint(158, 91), new FlxPoint(122, 81), new FlxPoint(158, 58), new FlxPoint(208, 60), new FlxPoint(241, 79), new FlxPoint(205, 96), new FlxPoint(201, 121), new FlxPoint(161, 119)];
		headSweatArray[45] = [new FlxPoint(150, 93), new FlxPoint(120, 83), new FlxPoint(152, 59), new FlxPoint(202, 59), new FlxPoint(238, 78), new FlxPoint(205, 97), new FlxPoint(202, 121), new FlxPoint(162, 124)];
		headSweatArray[46] = [new FlxPoint(150, 93), new FlxPoint(120, 83), new FlxPoint(152, 59), new FlxPoint(202, 59), new FlxPoint(238, 78), new FlxPoint(205, 97), new FlxPoint(202, 121), new FlxPoint(162, 124)];
		headSweatArray[47] = [new FlxPoint(150, 93), new FlxPoint(120, 83), new FlxPoint(152, 59), new FlxPoint(202, 59), new FlxPoint(238, 78), new FlxPoint(205, 97), new FlxPoint(202, 121), new FlxPoint(162, 124)];
		headSweatArray[48] = [new FlxPoint(150, 90), new FlxPoint(121, 78), new FlxPoint(155, 53), new FlxPoint(205, 56), new FlxPoint(239, 77), new FlxPoint(202, 94), new FlxPoint(197, 120), new FlxPoint(152, 117)];
		headSweatArray[49] = [new FlxPoint(150, 90), new FlxPoint(121, 78), new FlxPoint(155, 53), new FlxPoint(205, 56), new FlxPoint(239, 77), new FlxPoint(202, 94), new FlxPoint(197, 120), new FlxPoint(152, 117)];
		headSweatArray[50] = [new FlxPoint(150, 90), new FlxPoint(121, 78), new FlxPoint(155, 53), new FlxPoint(205, 56), new FlxPoint(239, 77), new FlxPoint(202, 94), new FlxPoint(197, 120), new FlxPoint(152, 117)];
		headSweatArray[51] = [new FlxPoint(178, 87), new FlxPoint(135, 67), new FlxPoint(174, 56), new FlxPoint(228, 70), new FlxPoint(251, 91), new FlxPoint(230, 94), new FlxPoint(231, 121), new FlxPoint(185, 119)];
		headSweatArray[52] = [new FlxPoint(178, 87), new FlxPoint(135, 67), new FlxPoint(174, 56), new FlxPoint(228, 70), new FlxPoint(251, 91), new FlxPoint(230, 94), new FlxPoint(231, 121), new FlxPoint(185, 119)];
		headSweatArray[53] = [new FlxPoint(178, 87), new FlxPoint(135, 67), new FlxPoint(174, 56), new FlxPoint(228, 70), new FlxPoint(251, 91), new FlxPoint(230, 94), new FlxPoint(231, 121), new FlxPoint(185, 119)];
		headSweatArray[54] = [new FlxPoint(160, 90), new FlxPoint(121, 77), new FlxPoint(159, 56), new FlxPoint(211, 58), new FlxPoint(244, 79), new FlxPoint(207, 93), new FlxPoint(201, 116), new FlxPoint(166, 120)];
		headSweatArray[55] = [new FlxPoint(160, 90), new FlxPoint(121, 77), new FlxPoint(159, 56), new FlxPoint(211, 58), new FlxPoint(244, 79), new FlxPoint(207, 93), new FlxPoint(201, 116), new FlxPoint(166, 120)];
		headSweatArray[56] = [new FlxPoint(160, 90), new FlxPoint(121, 77), new FlxPoint(159, 56), new FlxPoint(211, 58), new FlxPoint(244, 79), new FlxPoint(207, 93), new FlxPoint(201, 116), new FlxPoint(166, 120)];
		headSweatArray[57] = [new FlxPoint(152, 96), new FlxPoint(117, 82), new FlxPoint(154, 58), new FlxPoint(202, 56), new FlxPoint(242, 76), new FlxPoint(204, 94), new FlxPoint(201, 121), new FlxPoint(162, 121)];
		headSweatArray[58] = [new FlxPoint(152, 96), new FlxPoint(117, 82), new FlxPoint(154, 58), new FlxPoint(202, 56), new FlxPoint(242, 76), new FlxPoint(204, 94), new FlxPoint(201, 121), new FlxPoint(162, 121)];
		headSweatArray[59] = [new FlxPoint(152, 96), new FlxPoint(117, 82), new FlxPoint(154, 58), new FlxPoint(202, 56), new FlxPoint(242, 76), new FlxPoint(204, 94), new FlxPoint(201, 121), new FlxPoint(162, 121)];
		headSweatArray[60] = [new FlxPoint(132, 92), new FlxPoint(122, 81), new FlxPoint(136, 66), new FlxPoint(190, 55), new FlxPoint(222, 80), new FlxPoint(185, 92), new FlxPoint(180, 119), new FlxPoint(135, 122)];
		headSweatArray[61] = [new FlxPoint(132, 92), new FlxPoint(122, 81), new FlxPoint(136, 66), new FlxPoint(190, 55), new FlxPoint(222, 80), new FlxPoint(185, 92), new FlxPoint(180, 119), new FlxPoint(135, 122)];
		headSweatArray[63] = [new FlxPoint(166, 97), new FlxPoint(127, 79), new FlxPoint(163, 58), new FlxPoint(218, 61), new FlxPoint(243, 79), new FlxPoint(219, 102), new FlxPoint(217, 127), new FlxPoint(168, 130)];
		headSweatArray[64] = [new FlxPoint(166, 97), new FlxPoint(127, 79), new FlxPoint(163, 58), new FlxPoint(218, 61), new FlxPoint(243, 79), new FlxPoint(219, 102), new FlxPoint(217, 127), new FlxPoint(168, 130)];
		headSweatArray[66] = [new FlxPoint(160, 94), new FlxPoint(124, 75), new FlxPoint(165, 54), new FlxPoint(212, 60), new FlxPoint(243, 82), new FlxPoint(210, 101), new FlxPoint(204, 124), new FlxPoint(163, 121)];
		headSweatArray[67] = [new FlxPoint(160, 94), new FlxPoint(124, 75), new FlxPoint(165, 54), new FlxPoint(212, 60), new FlxPoint(243, 82), new FlxPoint(210, 101), new FlxPoint(204, 124), new FlxPoint(163, 121)];

		torsoSweatArray = [];
		torsoSweatArray[0] = [new FlxPoint(135, 323), new FlxPoint(127, 173), new FlxPoint(243, 173), new FlxPoint(241, 324)];

		breathAngleArray[0] = [new FlxPoint(176, 159), new FlxPoint(0, 80)];
		breathAngleArray[1] = [new FlxPoint(176, 159), new FlxPoint(0, 80)];
		breathAngleArray[2] = [new FlxPoint(176, 159), new FlxPoint(0, 80)];
		breathAngleArray[3] = [new FlxPoint(142, 156), new FlxPoint(-78, 16)];
		breathAngleArray[4] = [new FlxPoint(142, 156), new FlxPoint(-78, 16)];
		breathAngleArray[6] = [new FlxPoint(152, 146), new FlxPoint(-79, 14)];
		breathAngleArray[6] = [new FlxPoint(138, 154), new FlxPoint(-77, 21)];
		breathAngleArray[7] = [new FlxPoint(138, 154), new FlxPoint(-77, 21)];
		breathAngleArray[8] = [new FlxPoint(138, 154), new FlxPoint(-77, 21)];
		breathAngleArray[9] = [new FlxPoint(197, 158), new FlxPoint(75, 27)];
		breathAngleArray[10] = [new FlxPoint(197, 158), new FlxPoint(75, 27)];
		breathAngleArray[11] = [new FlxPoint(197, 158), new FlxPoint(75, 27)];
		breathAngleArray[12] = [new FlxPoint(161, 166), new FlxPoint(-29, 75)];
		breathAngleArray[13] = [new FlxPoint(161, 166), new FlxPoint(-29, 75)];
		breathAngleArray[14] = [new FlxPoint(161, 166), new FlxPoint(-29, 75)];
		breathAngleArray[15] = [new FlxPoint(190, 169), new FlxPoint(35, 72)];
		breathAngleArray[16] = [new FlxPoint(190, 169), new FlxPoint(35, 72)];
		breathAngleArray[17] = [new FlxPoint(190, 169), new FlxPoint(35, 72)];
		breathAngleArray[18] = [new FlxPoint(165, 156), new FlxPoint(-48, 64)];
		breathAngleArray[19] = [new FlxPoint(165, 156), new FlxPoint(-48, 64)];
		breathAngleArray[20] = [new FlxPoint(165, 156), new FlxPoint(-48, 64)];
		breathAngleArray[21] = [new FlxPoint(181, 158), new FlxPoint(7, 80)];
		breathAngleArray[22] = [new FlxPoint(181, 158), new FlxPoint(7, 80)];
		breathAngleArray[23] = [new FlxPoint(181, 158), new FlxPoint(7, 80)];
		breathAngleArray[24] = [new FlxPoint(224, 163), new FlxPoint(75, 27)];
		breathAngleArray[25] = [new FlxPoint(224, 163), new FlxPoint(75, 27)];
		breathAngleArray[26] = [new FlxPoint(224, 163), new FlxPoint(75, 27)];
		breathAngleArray[27] = [new FlxPoint(196, 158), new FlxPoint(34, 72)];
		breathAngleArray[28] = [new FlxPoint(196, 158), new FlxPoint(34, 72)];
		breathAngleArray[29] = [new FlxPoint(196, 158), new FlxPoint(34, 72)];
		breathAngleArray[30] = [new FlxPoint(114, 143), new FlxPoint(-79, -11)];
		breathAngleArray[31] = [new FlxPoint(114, 143), new FlxPoint(-79, -11)];
		breathAngleArray[32] = [new FlxPoint(114, 143), new FlxPoint(-79, -11)];
		breathAngleArray[33] = [new FlxPoint(182, 154), new FlxPoint(16, 78)];
		breathAngleArray[34] = [new FlxPoint(182, 154), new FlxPoint(16, 78)];
		breathAngleArray[35] = [new FlxPoint(182, 154), new FlxPoint(16, 78)];
		breathAngleArray[36] = [new FlxPoint(169, 151), new FlxPoint(-5, 80)];
		breathAngleArray[37] = [new FlxPoint(169, 151), new FlxPoint(-5, 80)];
		breathAngleArray[39] = [new FlxPoint(141, 159), new FlxPoint(-69, 40)];
		breathAngleArray[40] = [new FlxPoint(141, 159), new FlxPoint(-69, 40)];
		breathAngleArray[42] = [new FlxPoint(176, 150), new FlxPoint(2, 80)];
		breathAngleArray[43] = [new FlxPoint(176, 150), new FlxPoint(2, 80)];
		breathAngleArray[45] = [new FlxPoint(196, 160), new FlxPoint(54, 59)];
		breathAngleArray[46] = [new FlxPoint(196, 160), new FlxPoint(54, 59)];
		breathAngleArray[47] = [new FlxPoint(196, 160), new FlxPoint(54, 59)];
		breathAngleArray[48] = [new FlxPoint(165, 160), new FlxPoint(-6, 80)];
		breathAngleArray[49] = [new FlxPoint(165, 160), new FlxPoint(-6, 80)];
		breathAngleArray[50] = [new FlxPoint(165, 160), new FlxPoint(-6, 80)];
		breathAngleArray[51] = [new FlxPoint(244, 153), new FlxPoint(76, 24)];
		breathAngleArray[52] = [new FlxPoint(244, 153), new FlxPoint(76, 24)];
		breathAngleArray[53] = [new FlxPoint(244, 153), new FlxPoint(76, 24)];
		breathAngleArray[54] = [new FlxPoint(177, 153), new FlxPoint(-5, 80)];
		breathAngleArray[55] = [new FlxPoint(177, 153), new FlxPoint(-5, 80)];
		breathAngleArray[56] = [new FlxPoint(177, 153), new FlxPoint(-5, 80)];
		breathAngleArray[57] = [new FlxPoint(190, 168), new FlxPoint(28, 75)];
		breathAngleArray[58] = [new FlxPoint(190, 168), new FlxPoint(28, 75)];
		breathAngleArray[59] = [new FlxPoint(190, 168), new FlxPoint(28, 75)];
		breathAngleArray[60] = [new FlxPoint(119, 144), new FlxPoint(-80, -5)];
		breathAngleArray[61] = [new FlxPoint(119, 144), new FlxPoint(-80, -5)];
		breathAngleArray[63] = [new FlxPoint(222, 155), new FlxPoint(80, 3)];
		breathAngleArray[64] = [new FlxPoint(222, 155), new FlxPoint(80, 3)];
		breathAngleArray[66] = [new FlxPoint(166, 171), new FlxPoint(-14, 79)];
		breathAngleArray[67] = [new FlxPoint(166, 171), new FlxPoint( -14, 79)];

		encouragementWords = wordManager.newWords();
		encouragementWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:0 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:1 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:2 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:3 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:4 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:5 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:6 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:7 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:8 } ]);

		orgasmWords = wordManager.newWords();
		orgasmWords.words.push([ { graphic:AssetPaths.hera_words_large__png, frame:0, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.hera_words_large__png, frame:1, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.hera_words_large__png, frame:2, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.hera_words_large__png, frame:4, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ // sp-spock's beaAAAHHH!! AH!
		{ graphic:AssetPaths.hera_words_large__png, frame:3, width:200, height:150, yOffset:0, chunkSize:5 },
		{ graphic:AssetPaths.hera_words_large__png, frame:5, width:200, height:150, yOffset:0, chunkSize:5, delay:0.5 }
		]);

		pleasureWords = wordManager.newWords();
		pleasureWords.words.push([{ graphic:AssetPaths.hera_words_medium0__png, frame:0, height:48, chunkSize:5 }]);
		pleasureWords.words.push([{ graphic:AssetPaths.hera_words_medium0__png, frame:4, height:48, chunkSize:5 }]);
		pleasureWords.words.push([{ graphic:AssetPaths.hera_words_medium0__png, frame:5, height:48, chunkSize:5 }]);
		pleasureWords.words.push([{ graphic:AssetPaths.hera_words_medium0__png, frame:8, height:48, chunkSize:5 }]);
		pleasureWords.words.push([{ graphic:AssetPaths.hera_words_medium0__png, frame:11, height:48, chunkSize:5 }]);
		pleasureWords.words.push([{ graphic:AssetPaths.hera_words_medium0__png, frame:15, height:48, chunkSize:5 }]);
		pleasureWords.words.push([{ graphic:AssetPaths.hera_words_medium0__png, frame:16, height:48, chunkSize:5 }]);
		pleasureWords.words.push([{ graphic:AssetPaths.hera_words_medium0__png, frame:17, height:48, chunkSize:5 }]);
		pleasureWords.words.push([{ graphic:AssetPaths.hera_words_medium1__png, frame:15, height:48, chunkSize:5 }]);
		pleasureWords.words.push([{ graphic:AssetPaths.hera_words_medium1__png, frame:17, height:48, chunkSize:5 }]);

		sillyPleasureWords = wordManager.newWords();
		// gwehHH!! ...g-grapefruits!
		sillyPleasureWords.words.push([ { graphic:AssetPaths.hera_words_medium0__png, frame:0, height:48, chunkSize:5 },
		{ graphic:AssetPaths.hera_words_medium0__png, frame:2, height:48, chunkSize:5, yOffset:32, delay:1.2 }
									  ]);
		// ahHH! He- -HELICOPTERS!
		sillyPleasureWords.words.push([ { graphic:AssetPaths.hera_words_medium0__png, frame:1, height:48, chunkSize:5 },
		{ graphic:AssetPaths.hera_words_medium0__png, frame:3, height:48, chunkSize:5, yOffset:26, delay:1.2 }
									  ]);
		// nghhHhh! ...lunchboxes!
		sillyPleasureWords.words.push([ { graphic:AssetPaths.hera_words_medium0__png, frame:4, height:48, chunkSize:5 },
		{ graphic:AssetPaths.hera_words_medium0__png, frame:6, height:48, chunkSize:5, yOffset:30, delay:1.0 }
									  ]);
		// gwehHH! ..crispy whispers!
		sillyPleasureWords.words.push([ { graphic:AssetPaths.hera_words_medium0__png, frame:5, height:48, chunkSize:5 },
		{ graphic:AssetPaths.hera_words_medium0__png, frame:7, height:48, chunkSize:5, yOffset:27, delay:1.0 },
		{ graphic:AssetPaths.hera_words_medium0__png, frame:9, height:48, chunkSize:5, yOffset:45, delay:1.3 }
									  ]);
		// Hahhh..... ...HAILSTORMS!!
		sillyPleasureWords.words.push([ { graphic:AssetPaths.hera_words_medium0__png, frame:8, height:48, chunkSize:5 },
		{ graphic:AssetPaths.hera_words_medium0__png, frame:10, height:48, chunkSize:5, yOffset:28, delay:0.8 }
									  ]);
		// ohhHHHh! Odin's raven!
		sillyPleasureWords.words.push([ { graphic:AssetPaths.hera_words_medium0__png, frame:11, height:48, chunkSize:5 },
		{ graphic:AssetPaths.hera_words_medium0__png, frame:13, height:48, chunkSize:5, yOffset:28, delay:1.2 }
									  ]);
		// G-gahh! sh- -SHOELACES!
		sillyPleasureWords.words.push([ { graphic:AssetPaths.hera_words_medium0__png, frame:12, height:48, chunkSize:5 },
		{ graphic:AssetPaths.hera_words_medium0__png, frame:14, height:48, chunkSize:5, yOffset:28, delay:1.2 }
									  ]);
		// ~Ooughh! Sweet... summer SAUSAGES!!
		sillyPleasureWords.words.push([ { graphic:AssetPaths.hera_words_medium1__png, frame:0, width:256, height:48, chunkSize:5, delay:-0.3 },
		{ graphic:AssetPaths.hera_words_medium1__png, frame:1, width:256, height:48, chunkSize:5, yOffset:28, delay:0.4 },
		{ graphic:AssetPaths.hera_words_medium1__png, frame:2, width:256, height:48, chunkSize:5, yOffset:56, delay:0.9 },
									  ]);
		// MmmmmMARShmallows!!
		sillyPleasureWords.words.push([ { graphic:AssetPaths.hera_words_medium1__png, frame:3, width:256, height:48, chunkSize:5 } ]);

		almostWords = wordManager.newWords(30);
		// oh gosh, i... ...i might be...
		almostWords.words.push([
		{ graphic:AssetPaths.hera_words_medium1__png, frame:8, height:48, chunkSize:5 },
		{ graphic:AssetPaths.hera_words_medium1__png, frame:10, height:48, chunkSize:5, yOffset:28, delay:1.2 }
		]);
		// mmmMmyeah, that's... i think i'm...
		almostWords.words.push([
		{ graphic:AssetPaths.hera_words_medium1__png, frame:9, height:48, chunkSize:5 },
		{ graphic:AssetPaths.hera_words_medium1__png, frame:11, height:48, chunkSize:5, yOffset:26, delay:0.9 },
		{ graphic:AssetPaths.hera_words_medium1__png, frame:13, height:48, chunkSize:5, yOffset:52, delay:1.9 }
		]);
		// Ooough, i'm soo close... i might....
		almostWords.words.push([
		{ graphic:AssetPaths.hera_words_medium1__png, frame:12, height:48, chunkSize:5 },
		{ graphic:AssetPaths.hera_words_medium1__png, frame:14, height:48, chunkSize:5, yOffset:22, delay:0.9 },
		{ graphic:AssetPaths.hera_words_medium1__png, frame:16, height:48, chunkSize:5, yOffset:48, delay:2.2 }
		]);

		boredWords = wordManager.newWords();
		boredWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:9 } ]);
		boredWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:10 } ]);
		boredWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:11 } ]);
		// what are you... ...umm?
		boredWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:12},
		{ graphic:AssetPaths.hera_words_small__png, frame:14, yOffset:20, delay:0.7 }
							  ]);
		// don't forget about meeeee! ...gweh!
		boredWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:13},
		{ graphic:AssetPaths.hera_words_small__png, frame:15, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.hera_words_small__png, frame:17, yOffset:42, delay:2.0 }
							  ]);

		// can you set it on "low"? ...or maybe "off"!
		toyStartWords.words.push([ { graphic:AssetPaths.hera_vibe_words_small__png, frame:0 },
		{ graphic:AssetPaths.hera_vibe_words_small__png, frame:2, yOffset:23, delay:0.8 },
		{ graphic:AssetPaths.hera_vibe_words_small__png, frame:4, yOffset:44, delay:2.1 },
		{ graphic:AssetPaths.hera_vibe_words_small__png, frame:6, yOffset:65, delay:2.6 },
								 ]);
		// gwehh! that's not faaairrrrr~
		toyStartWords.words.push([ { graphic:AssetPaths.hera_vibe_words_small__png, frame:1 },
		{ graphic:AssetPaths.hera_vibe_words_small__png, frame:3, yOffset:20, delay:0.8 },
								 ]);
		// but i already.... ...oh, okaaayyyy
		toyStartWords.words.push([ { graphic:AssetPaths.hera_vibe_words_small__png, frame:5 },
		{ graphic:AssetPaths.hera_vibe_words_small__png, frame:7, yOffset:22, delay:1.2 },
		{ graphic:AssetPaths.hera_vibe_words_small__png, frame:9, yOffset:42, delay:2.4 },
								 ]);

		// phew! did i do a good job?
		toyInterruptWords.words.push([ { graphic:AssetPaths.hera_vibe_words_small__png, frame:8 },
		{ graphic:AssetPaths.hera_vibe_words_small__png, frame:10, yOffset:20, delay:0.8 },
									 ]);
		// oh! that wasn't so bad~
		toyInterruptWords.words.push([ { graphic:AssetPaths.hera_vibe_words_small__png, frame:11 },
		{ graphic:AssetPaths.hera_vibe_words_small__png, frame:13, yOffset:20, delay:0.7 },
									 ]);
		// i made it? ...oh it's a miracle!!
		toyInterruptWords.words.push([ { graphic:AssetPaths.hera_vibe_words_small__png, frame:12 },
		{ graphic:AssetPaths.hera_vibe_words_small__png, frame:14, yOffset:18, delay:0.9 },
									 ]);

		toyAlmostWords = wordManager.newWords(30);
		// ...HOT HAM SANDWICHES! that's.... ....oooough~
		toyAlmostWords.words.push([ { graphic:AssetPaths.hera_vibe_words_medium__png, frame:0, width:256, height:48, chunkSize:8 },
		{ graphic:AssetPaths.hera_vibe_words_medium__png, frame:1, width:256, height:48, chunkSize:8, yOffset:34, delay:1.3 },
		{ graphic:AssetPaths.hera_vibe_words_medium__png, frame:2, width:256, height:48, chunkSize:8, yOffset:34, delay:1.6 },
								  ]);
		// ...HOLY HAMBURGERS!! y- you really... gwahh~
		toyAlmostWords.words.push([ { graphic:AssetPaths.hera_vibe_words_medium__png, frame:3, width:256, height:48, chunkSize:8 },
		{ graphic:AssetPaths.hera_vibe_words_medium__png, frame:4, width:256, height:48, chunkSize:8, yOffset:40, delay:1.3 },
		{ graphic:AssetPaths.hera_vibe_words_medium__png, frame:5, width:256, height:48, chunkSize:8, yOffset:40, delay:1.6 },
								  ]);
		// ...OHH TALCUM POWDER! you surrre... -phwooph-
		toyAlmostWords.words.push([ { graphic:AssetPaths.hera_vibe_words_medium__png, frame:6, width:256, height:48, chunkSize:8 },
		{ graphic:AssetPaths.hera_vibe_words_medium__png, frame:7, width:256, height:48, chunkSize:8, yOffset:40, delay:1.3 },
		{ graphic:AssetPaths.hera_vibe_words_medium__png, frame:8, width:256, height:48, chunkSize:8, yOffset:36, delay:1.6 },
								  ]);

		babbleWords = wordManager.newWords();
		// bllll bbl...
		for (i in 0...8)
		{
			var words:Array<Word> = [];
			for (j in 0...50)
			{
				words.push({ graphic:AssetPaths.hera_words_small__png, frame:16 + 2 * (i + j) % 8, chunkSize:5, yOffset:j * 20, delay: j * 0.75});
			}
			babbleWords.words.push(words);
		}

		badAntennaWords = wordManager.newWords(10);
		// ...ack! quit it!
		badAntennaWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:19},
		{ graphic:AssetPaths.hera_words_small__png, frame:21, yOffset:20, delay:1.1 },
								   ]);
		// ...agh!
		badAntennaWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:23 } ]);
		// -gllkh! cut that out!
		badAntennaWords.words.push([ { graphic:AssetPaths.hera_words_small__png, frame:25},
		{ graphic:AssetPaths.hera_words_small__png, frame:27, yOffset:20, delay:1.3 },
								   ]);
	}

	override function penetrating():Bool
	{
		if (!_male && specialRub == "jack-off")
		{
			return true;
		}
		if (!_male && specialRub == "rub-dick")
		{
			return true;
		}
		return false;
	}

	function setInactiveDickAnimation():Void
	{
		if (_male)
		{
			if (_gameState >= 400)
			{
				if (_dick.animation.name == "default")
				{
					// he's already soft
				}
				else if (_dick.animation.name != "finished")
				{
					_dick.animation.add("finished", [2, 2, 2, 2, 0], 1, false);
					_dick.animation.play("finished");
				}
			}
			else if (pastBonerThreshold())
			{
				if (_dick.animation.name != "boner2")
				{
					_dick.animation.play("boner2");
				}
			}
			else if (_heartBank.getForeplayPercent() < 0.6)
			{
				if (_dick.animation.name != "boner1")
				{
					_dick.animation.play("boner1");
				}
			}
			else
			{
				if (_dick.animation.name != "default")
				{
					_dick.animation.play("default");
				}
			}
		}
		else {
			if (_dick.animation.frameIndex != 0)
			{
				_dick.animation.play("default");
			}
		}
	}

	override public function checkSpecialRub(touchedPart:FlxSprite)
	{
		if (_fancyRub)
		{
			if (_rubHandAnim._flxSprite.animation.name == "rub-left-antenna")
			{
				specialRub = "left-antenna";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-right-antenna")
			{
				specialRub = "right-antenna";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-dick")
			{
				specialRub = "rub-dick";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "jack-off")
			{
				specialRub = "jack-off";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-horn")
			{
				specialRub = "horn";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-balls")
			{
				specialRub = "balls";
			}
		}
		else
		{
			var leftSideRub:Bool = touchedPart == null ? false : (FlxG.mouse.x - touchedPart.x + touchedPart.offset.x <= 185);
			if (touchedPart == _pokeWindow._torso0)
			{
				specialRub = leftSideRub ? "left-torso0" : "right-torso0";
			}
			else if (touchedPart == _pokeWindow._torso1)
			{
				specialRub = leftSideRub ? "left-torso1" : "right-torso1";
			}
			else if (touchedPart == _pokeWindow._legs)
			{
				specialRub = leftSideRub ? "left-leg" : "right-leg";
			}
			else if (touchedPart == _pokeWindow._arms1)
			{
				specialRub = leftSideRub ? "left-shoulder" : "right-shoulder";
			}
			else if (touchedPart == _head)
			{
				specialRub = "head";
			}
		}
	}

	override function canChangeHead():Bool
	{
		return !fancyRubbing(_pokeWindow._head);
	}

	override function foreplayFactor():Float
	{
		var bonusCapacity:Int = computeBonusCapacity();
		var foreplayAmount:Int = PlayerData.pokemonLibido == 1 ? 20 : 10;
		return foreplayAmount / (bonusCapacity + 30);
	}

	override function generateCumshots():Void
	{
		if (!came && turnsUntilPrematureEjaculation < 1000)
		{
			if (turnsUntilPrematureEjaculation <= 3 || !pastBonerThreshold())
			{
				// REALLY premature; make sure to complain
				didReallyPrematurelyEjaculate = true;
			}
			didKindaPrematurelyEjaculate = true;
			var prematurePenalty:Float = FlxMath.bound(1 - Math.pow(0.8, specialRub.length * 0.3), 0.1, 1.0);
			_heartBank._dickHeartReservoir = SexyState.roundUpToQuarter(prematurePenalty * _heartBank._dickHeartReservoir);
			_heartBank._foreplayHeartReservoir = SexyState.roundUpToQuarter(prematurePenalty * _heartBank._foreplayHeartReservoir);
			// also lower capacity, so that heracross doesn't get a sudden boner
			_heartBank._foreplayHeartReservoirCapacity = SexyState.roundUpToQuarter(prematurePenalty * _heartBank._foreplayHeartReservoirCapacity);
		}

		if (addToyHeartsToOrgasm && _remainingOrgasms == 1)
		{
			_heartBank._dickHeartReservoir += _toyBank._dickHeartReservoir;
			_heartBank._dickHeartReservoir += _toyBank._foreplayHeartReservoir;

			_toyBank._dickHeartReservoir = 0;
			_toyBank._foreplayHeartReservoir = 0;
		}

		turnsUntilPrematureEjaculation = 9999;
		prematureEjaculationTrigger = 9999;
		prematureEjaculationTriggers.splice(0, prematureEjaculationTriggers.length);

		super.generateCumshots();
	}

	override public function computeChatComplaints(complaints:Array<Int>):Void
	{
		if (didReallyPrematurelyEjaculate)
		{
			complaints.push(0);
			complaints.push(1);
			complaints.push(2);
		}
		else if (didKindaPrematurelyEjaculate)
		{
			complaints.push(FlxG.random.getObject([0, 1, 2]));
		}
	}

	override function computePrecumAmount():Int
	{
		var precumAmount:Int = 0;
		if (displayingToyWindow())
		{
			if (FlxG.random.float(0, Math.max(1, turnsUntilPrematureEjaculation)) < 1)
			{
				precumAmount++;
			}
			if (turnsUntilPrematureEjaculation < 1000 || FlxG.random.float(0, Math.max(1, prematureEjaculationTrigger)) < 1)
			{
				precumAmount++;
			}
			if (FlxG.random.float(1, 15) < _heartEmitCount)
			{
				precumAmount++;
			}
			if (FlxG.random.float(0, consecutiveVibeCount) >= 2.5)
			{
				precumAmount++;
			}
			return precumAmount;
		}
		if (FlxG.random.float(0, Math.max(1, turnsUntilPrematureEjaculation)) < 1)
		{
			precumAmount++;
		}
		if (turnsUntilPrematureEjaculation < 1000 || FlxG.random.float(0, Math.max(1, prematureEjaculationTrigger)) < 1)
		{
			precumAmount++;
		}
		if (FlxG.random.float(1, 15) < _heartEmitCount)
		{
			precumAmount++;
		}
		if (FlxG.random.float(1, 45) < _heartEmitCount)
		{
			precumAmount++;
		}
		if (specialRub == "left-antenna" || specialRub == "right-antenna")
		{
			precumAmount = 0;
		}
		if (_gameState >= 400)
		{
			precumAmount = 0;
		}
		return precumAmount;
	}

	override function getSpoogeSource():FlxSprite
	{
		return displayingToyWindow() ? _pokeWindow._vibe.dickVibe : _dick;
	}

	override function getSpoogeAngleArray():Array<Array<FlxPoint>>
	{
		return displayingToyWindow() ? dickVibeAngleArray : dickAngleArray;
	}

	override function handleRubReward():Void
	{
		if (specialRub == "left-antenna")
		{
			if (specialRubs.indexOf("left-antenna") == specialRubs.length - 1)
			{
				_head.animation.play("right-eye-swirl");
				babbleWordParticles = emitWords(babbleWords);
			}
			else if (_head.animation.name == "right-eye-swirl")
			{
				// still talking; delay word timers
				encouragementWords.timer = encouragementWords.frequency;
				boredWords.timer = boredWords.frequency;
			}
			else
			{
				maybeEmitWords(badAntennaWords);
			}
		}
		else if (specialRub == "right-antenna")
		{
			if (specialRubs.indexOf("right-antenna") == specialRubs.length - 1)
			{
				_head.animation.play("left-eye-swirl");
				babbleWordParticles = emitWords(babbleWords);
			}
			else if (_head.animation.name == "left-eye-swirl")
			{
				// still talking; delay word timers
				encouragementWords.timer = encouragementWords.frequency;
				boredWords.timer = boredWords.frequency;
			}
			else
			{
				maybeEmitWords(badAntennaWords);
			}
		}

		var specialSpotIndex:Int = specialSpots.indexOf(specialRub);
		var verySpecialSpotIndex:Int = verySpecialSpots.indexOf(specialRub);
		if (specialRub == "left-antenna" || specialRub == "right-antenna")
		{
			if (specialRubs.indexOf(specialRub) < specialRubs.length - 1)
			{
				// they've rubbed that particular antenna before...
			}
			else
			{
				if (turnsUntilPrematureEjaculation >= 1000)
				{
					// not in the process of prematurely ejaculating
					prematureEjaculationTrigger += 3;
				}
				else
				{
					resetPrematureEjaculationTrigger();
				}
			}
		}
		else if (specialRub == "horn")
		{
			if (specialRubs.indexOf("left-antenna") == -1 && specialRubs.indexOf("right-antenna") == -1)
			{
				// they've never rubbed our antenna; rubbing our horn feels nice
				hitTheSpotTrigger -= 4;
			}
			else
			{
				// they've rubbed our antenna before; rubbing our horn sets us off
				prematureEjaculationTrigger -= 4;
			}
			var amount:Float = FlxG.random.getObject([0.25, 0.5]);
			amount = Math.min(amount, _heartBank._foreplayHeartReservoir);
			_heartBank._foreplayHeartReservoir -= amount;
			_heartEmitCount += amount;
		}
		else if (specialRub == "rub-dick" || specialRub == "jack-off")
		{
			if (niceThings[2] && !came && specialRubs.indexOf("jack-off") != -1)
			{
				niceThings[2] = false;
				doNiceThing(0.66667);
				maybeEmitWords(sillyPleasureWords);
			}

			if (specialRubs.indexOf(specialRub) < specialRubs.length - 1)
			{
				// they've rubbed our dick before
				hitTheSpotTrigger = Std.int(Math.max(hitTheSpotTrigger - 1, 1));
				prematureEjaculationTrigger -= 4;
			}
			else
			{
				// it's a new rub
				hitTheSpotTrigger = Std.int(Math.max(hitTheSpotTrigger - 4, 1));
				prematureEjaculationTrigger -= 4;
			}
			if (specialRub == "rub-dick")
			{
				var amount:Float = FlxG.random.getObject([0.25, 0.5]);
				amount = Math.min(amount, _heartBank._foreplayHeartReservoir);
				_heartBank._foreplayHeartReservoir -= amount;
				_heartEmitCount += amount;

				// increase dick heart capacity, so that he gets hard quickly
				_heartBank._foreplayHeartReservoirCapacity += SexyState.roundUpToQuarter(_heartBank._foreplayHeartReservoirCapacity * 0.18);
				_heartBank._foreplayHeartReservoirCapacity = FlxMath.bound(_heartBank._foreplayHeartReservoirCapacity, 0, 1000);
			}
			else if (specialRub == "jack-off")
			{
				var lucky:Float = lucky(0.7, 1.43, 0.08);
				var amount = SexyState.roundUpToQuarter(lucky * _heartBank._dickHeartReservoir);
				_heartBank._dickHeartReservoir -= amount;
				_heartEmitCount += amount;
			}
		}
		else if (verySpecialSpots.indexOf(specialRub) != -1)
		{
			// just rubbing a nice spot again...
			var lucky:Float = lucky(0.7, 1.43, 0.12);
			if (_gameState > 200)
			{
				// game is over; can't hit new special spots
			}
			else if (niceThings[0] && verySpecialSpotIndex == 0 && specialRubsInARow() >= 2)
			{
				niceThings[0] = false;
				justHitTheSpot();
				lucky *= 2;
			}
			else if (niceThings[1] && verySpecialSpotIndex == 1 && specialRubsInARow() >= 2)
			{
				niceThings[1] = false;
				justHitTheSpot();
				lucky *= 2;
			}
			var amount:Float = 0;
			if (verySpecialSpotIndex == 0 && niceThings[0] || verySpecialSpotIndex == 1 && niceThings[1])
			{
				// just brushing past an undiscovered sensitive spot...?
				amount = 0.75;
			}
			else
			{
				// revisiting an already-established sensitive spot
				amount = SexyState.roundUpToQuarter(lucky * (_heartBank._foreplayHeartReservoir - 5));
			}
			amount = Math.max(amount, 0);
			_heartBank._foreplayHeartReservoir -= amount;
			_heartEmitCount += amount;
		}
		else if (specialSpotIndex != -1)
		{
			var amount:Float = 0.25;
			// they rubbed a sensitive area...
			if (specialRubsInARow() > 1)
			{
				// it was someplace they just rubbed
				hitTheSpotTrigger = Std.int(Math.max(hitTheSpotTrigger - 1, 1));
				prematureEjaculationTrigger -= 3;
			}
			else
			{
				amount += 0.25;
				if (specialRubs.indexOf(specialRub) < specialRubs.length - 1)
				{
					// it was someplace they rubbed in the past
					hitTheSpotTrigger -= 3;
					prematureEjaculationTrigger -= 3;
				}
				else
				{
					// it's a new rub
					hitTheSpotTrigger -= 3;
					prematureEjaculationTrigger -= 1;
				}
				if (hitTheSpotTrigger <= 0 && verySpecialSpots[0] != specialRub)
				{
					amount += 0.25;
					hitTheSpotTrigger = 9999;
					verySpecialSpots.push(specialRub);
					prematureEjaculationTrigger = Std.int(Math.max(prematureEjaculationTrigger, 3));
				}
			}
			amount = Math.min(amount, _heartBank._foreplayHeartReservoir);
			_heartBank._foreplayHeartReservoir -= amount;
			_heartEmitCount += amount;
		}
		else {
			// they just rubbed somewhere weird...
			var amount:Float = FlxG.random.getObject([0.25, 0.5]);
			amount = Math.min(amount, _heartBank._foreplayHeartReservoir);
			_heartBank._foreplayHeartReservoir -= amount;
			_heartEmitCount += amount;
		}

		if (_gameState > 200)
		{
			// premature ejaculation logic doesn't apply after game is over
		}
		else {
			if (turnsUntilPrematureEjaculation < 1000)
			{
				var percent:Float = 0.067;
				if (turnsUntilPrematureEjaculation == 3)
				{
					percent = 0.100;
				}
				else if (turnsUntilPrematureEjaculation == 2)
				{
					percent = 0.222;
				}
				else if (turnsUntilPrematureEjaculation == 1)
				{
					percent = 0.429;
				}
				else if (turnsUntilPrematureEjaculation <= 0)
				{
					percent = 1.000;
					// make sure he ejaculates before another rubreward
					_newHeadTimer = Math.min(_newHeadTimer, FlxG.random.float(0, _rubRewardFrequency));
				}
				var amount:Float = Math.ceil(percent * (_heartBank._dickHeartReservoir - (_heartBank._dickHeartReservoirCapacity * _cumThreshold - 1)));
				amount = Math.max(amount, 1);
				amount = Math.min(amount, _heartBank._dickHeartReservoirCapacity);
				_heartBank._dickHeartReservoir -= amount;
				_heartEmitCount += Math.min(amount, Math.ceil(amount * 0.4));

				if (FlxG.random.float(0, Math.pow(FlxMath.bound(turnsUntilPrematureEjaculation, 0, 10), 2)) <= 4)
				{
					blushTimer = FlxG.random.float(12, 15);
					_pokeWindow._armsUpTimer = FlxG.random.float(6, 9);
					_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(1.5, 3);
				}

				turnsUntilPrematureEjaculation--;
			}

			if (prematureEjaculationTrigger <= 0 && turnsUntilPrematureEjaculation >= 1000)
			{
				_autoSweatRate = FlxMath.bound(_autoSweatRate + 0.3, 0, 1);
				for (i in 0...3)
				{
					emitSweat();
				}

				turnsUntilPrematureEjaculation = [9, 7, 5, 3][bonusCapacityIndex];
				var amount:Float = 1;
				amount = Math.min(amount, _heartBank._dickHeartReservoirCapacity);
				_heartBank._dickHeartReservoir -= amount;
				_heartEmitCount += amount;

				// temporarily force big hearts
				_heartEmitFudgeFloor = 1.0;
				eventStack.addEvent({time:eventStack._time + 1.0, callback:eventSetHeartEmitFudgeFloor, args:[0.3]});
			}
		}

		if (!isEjaculating() && _gameState == 200)
		{
			if (_remainingOrgasms > 0)
			{
				// emit "almost" words?
				if (turnsUntilPrematureEjaculation <= 1)
				{
					maybeEmitWords(almostWords);
				}
				else if (_heartBank.getDickPercent() * 0.86 < _cumThreshold)
				{
					maybeEmitWords(almostWords);
				}
			}
		}

		if (hitTheSpotTrigger >= 1000)
		{
			hitTheSpotTrigger = 9999;
		}
		if (prematureEjaculationTrigger >= 1000)
		{
			prematureEjaculationTrigger = 9999;
		}

		emitCasualEncouragementWords();
		if (_heartEmitCount > 0)
		{
			maybeScheduleBreath();
			maybePlayPokeSfx();
			maybeEmitPrecum();
		}
	}

	function eventSetHeartEmitFudgeFloor(args:Dynamic)
	{
		_heartEmitFudgeFloor = args[0];
	}

	function justHitTheSpot():Void
	{
		doNiceThing(0.66667);
		maybeEmitWords(sillyPleasureWords);
		maybePlayPokeSfx(sfxPleasure);
		_pokeWindow.setArousal(3);
		_newHeadTimer = _newHeadTimer = FlxG.random.float(3, 5) * _headTimerFactor;
		var transferAmount:Float = SexyState.roundUpToQuarter(_heartBank._defaultDickHeartReservoir * 0.4);
		_heartBank._dickHeartReservoir -= transferAmount;
		_heartBank._dickHeartReservoirCapacity -= transferAmount;
		_heartBank._foreplayHeartReservoir += transferAmount;
		_heartBank._foreplayHeartReservoirCapacity += SexyState.roundUpToQuarter(transferAmount / _bonerThreshold);
		resetHitTheSpotTrigger();
	}

	override public function determineArousal():Int
	{
		if (displayingToyWindow() && microTurnsUntilPrematureEjaculation < 10000 && _pokeWindow._vibe.vibeSfx.mode != VibeSfx.VibeMode.Off)
		{
			// oof, coming soon
			return 4;
		}
		if (_heartBank.getDickPercent() < 0.77)
		{
			return 4;
		}
		else if (_heartBank.getDickPercent() < 0.9)
		{
			return _pokeWindow._vibe.vibeSfx.isVibratorOn() ? FlxG.random.getObject([2, 3]) : FlxG.random.getObject([2, 3]);
		}
		else if (_heartBank.getForeplayPercent() < _bonerThreshold)
		{
			return _pokeWindow._vibe.vibeSfx.isVibratorOn() ? FlxG.random.getObject([2, 3]) : 2;
		}
		else if (_heartBank._foreplayHeartReservoir < _heartBank._foreplayHeartReservoirCapacity)
		{
			return _pokeWindow._vibe.vibeSfx.isVibratorOn() ? 2 : 1;
		}
		else {
			return _pokeWindow._vibe.vibeSfx.isVibratorOn() ? 1 : 0;
		}
	}

	override function handleOrgasmReward(elapsed:Float):Void
	{
		var tmpForeplayHeartReservoir:Float = 0;
		if (didKindaPrematurelyEjaculate)
		{
			// premature orgasm doesn't deplete foreplay heart reservoir
			tmpForeplayHeartReservoir = _heartBank._foreplayHeartReservoir;
			_heartBank._foreplayHeartReservoir = 0;
		}
		super.handleOrgasmReward(elapsed);
		if (didKindaPrematurelyEjaculate)
		{
			_heartBank._foreplayHeartReservoir = tmpForeplayHeartReservoir;
		}
	}

	override function endSexyStuff():Void
	{
		var tmpForeplayHeartReservoir:Float = 0;
		if (didKindaPrematurelyEjaculate)
		{
			// premature orgasm doesn't deplete foreplay heart reservoir
			tmpForeplayHeartReservoir = _heartBank._foreplayHeartReservoir;
			_heartBank._foreplayHeartReservoir = 0;
		}
		super.endSexyStuff();
		if (didKindaPrematurelyEjaculate)
		{
			_heartBank._foreplayHeartReservoir = tmpForeplayHeartReservoir;
		}

		// restore default sfx frequency
		_characterSfxFrequency = 4.0;
		pleasureWords.frequency = 4.0;
		encouragementWords.frequency = 4.0;
	}

	override public function eventShowToyWindow(args:Array<Dynamic>)
	{
		super.eventShowToyWindow(args);

		_pokeWindow.setVibe(true);
		if (!_male)
		{
			_pokeWindow._vibe.loadShadow(_shadowGloveBlackGroup, AssetPaths.hera_dick_vibe_shadow_f__png);
		}
	}

	override public function eventHideToyWindow(args:Array<Dynamic>)
	{
		super.eventHideToyWindow(args);

		_pokeWindow.setVibe(false);
		if (!_male)
		{
			_pokeWindow._vibe.unloadShadow(_shadowGloveBlackGroup);
		}
	}

	override public function back():Void
	{
		// if the foreplayHeartReservoir is empty (or half empty), empty the
		// dick heart reservoir too -- that way the toy meter won't stay full.
		_toyBank._dickHeartReservoir = Math.min(_toyBank._dickHeartReservoir, SexyState.roundDownToQuarter(_toyBank._defaultDickHeartReservoir * _toyBank.getForeplayPercent()));

		super.back();
	}

	override function cursorSmellPenaltyAmount():Int
	{
		return 35;
	}

	override public function destroy():Void
	{
		super.destroy();

		leftAntennaPolyArray = null;
		rightAntennaPolyArray = null;
		hornPolyArray = null;
		vagPolyArray = null;
		electricPolyArray = null;
		torsoSweatArray = null;
		headSweatArray = null;
		specialSpots = null;
		verySpecialSpots = null;
		hitTheSpotTriggers = null;
		prematureEjaculationTriggers = null;
		niceThings = null;
		meanThings = null;
		sillyPleasureWords = null;
		babbleWords = null;
		badAntennaWords = null;
		toyAlmostWords = null;
		babbleWordParticles = null;
		_beadButton = FlxDestroyUtil.destroy(_beadButton);
		_bigBeadButton = FlxDestroyUtil.destroy(_bigBeadButton);
		_vibeButton = FlxDestroyUtil.destroy(_vibeButton);
		_elecvibeButton = FlxDestroyUtil.destroy(_elecvibeButton);
		_toyInterface = FlxDestroyUtil.destroy(_toyInterface);
		dickVibeAngleArray = null;
		lastFewVibeSettings = null;
		acceptableVibesPerPhase = null;
	}
}