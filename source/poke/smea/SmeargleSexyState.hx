package poke.smea;

import ReservoirMeter.ReservoirStatus;
import flixel.util.FlxDestroyUtil;
import poke.abra.AbraSexyState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import openfl.utils.Object;
import poke.grov.VibeInterface;
import poke.sexy.ArmsAndLegsArranger;
import poke.sexy.SexyState;
import poke.sexy.WordManager.Qord;
import poke.grov.VibeInterface.vibeString;

/**
 * Sex sequence for Smeargle
 * 
 * Smeargle isn't usually interested in having sex. If his "horniness meter" is
 * yellow or higher then he'll be interested in sex, but otherwise he won't.
 * His horniness meter will usually only rise into the yellow if you play with
 * him correctly.
 * 
 * To make smeargle happy when he's not interested in sex, you need to rapidly
 * rub his hat. When you rub it fast enough for the first time he should moan.
 * If you keep rubbing it, he'll eventually have something sort of resembling
 * an orgasm.
 * 
 * When both of smeargle's hands are covering his crotch area, he wants you to
 * rub anything above his belly. (His belly is fine too.)
 * 
 * When one of smeargle's hands is away from his crotch, he wants you to rub
 * anything below his belly. (His belly is fine too.)
 * 
 * When smeargle's really enjoying himself, he'll start moving his arms
 * unpredictably, or covering his face with his hands things like that. You
 * don't have to worry about what you're rubbing when he does that, he's
 * enjoying himself.
 * 
 * Smeargle has about a dozen areas he likes having rubbed, including his
 * arms, chest, belly, neck, head, ears, hat, calves, thighs and feet. He is
 * sensitive everywhere! If you rub 7 different things he likes, (and the
 * position of his arms is correct,) then you'll make him very happy.
 * 
 * If you rub one of Smeargle's sensitive areas 3 times in a row, (such as
 * rubbing his neck 3 times when his arms are covering his crotch,) then
 * you'll also make him very happy.
 * 
 * Smeargle dislikes having his tongue pulled. Yes it's cute, but don't do it.
 * 
 * Smeargle likes the Venonat Vibrator sometimes, but only when the meter is
 * yellow or higher. If he's not in the mood, you shouldn't use it.
 * 
 * There is a specific setting he likes, but this changes each time so you need
 * to explore. He especially likes if you can find the perfect vibrator setting
 * within 30 seconds of turning the toy on.
 * 
 * The specific setting involves both a speed (1-5) and a mode (oscillating,
 * sustained, pulse). When you get the speed or mode correct, Smeargle will
 * precum and sweat. He will never precum otherwise, so you can use this to
 * deduce his favorite speed and mode.
 * 
 * Additionally, the first time you get the speed or mode correct, Smeargle
 * will blush. But he will only blush every once in awhile, so this is a slow
 * deduction method.
 * 
 * When you get both the speed and mode correct for a few seconds, Smeargle
 * will moan and emit a ridiculous amount of precum. This will increase the
 * power of his orgasm later. (Or you can just let him orgasm with the
 * vibrator, by leaving it on even longer.)
 */
class SmeargleSexyState extends SexyState<SmeargleWindow>
{
	private var _vagTightness:Float = 5;
	private var torsoSweatArray:Array<Array<FlxPoint>>;
	private var headSweatArray:Array<Array<FlxPoint>>;

	private var tonguePolyArray:Array<Array<FlxPoint>>;
	private var leftFootPolyArray:Array<Array<FlxPoint>>;
	private var rightFootPolyArray:Array<Array<FlxPoint>>;
	private var hatPolyArray:Array<Array<FlxPoint>>;
	private var leftHatPolyArray:Array<Array<FlxPoint>>;
	private var leftArmPolyArray:Array<Array<FlxPoint>>;
	private var leftEarPolyArray:Array<Array<FlxPoint>>;
	private var rightEarPolyArray:Array<Array<FlxPoint>>;
	private var leftLegPolyArray:Array<Array<FlxPoint>>;
	private var vagPolyArray:Array<Array<FlxPoint>>;
	private var electricPolyArray:Array<Array<FlxPoint>>;

	private var tongueWords:Qord;
	private var fasterHatWords:Qord;
	private var bellyRubWords:Qord;
	private var earRubWords:Qord;
	private var thighRubWords:Qord;
	private var toyStopWords:Qord;

	private var niceRubs:Array<Array<String>> = [
				["left-arm", "right-arm", "chest", "belly", "neck", "head", "left-ear", "right-ear", "hat"],
				["belly", "left-foreleg", "left-thigh", "left-foot", "right-foreleg", "right-thigh", "right-foot"]
			];
	private var dislikedRubs:Array<String> = ["left-arm", "right-arm", "chest", "belly", "neck", "head", "left-ear", "right-ear", "hat", "left-foreleg", "left-thigh", "left-foot", "right-foreleg", "right-thigh", "right-foot", "balls", "tongue", "rub-dick", "jack-off"];
	private var niceRubsIndex:Int = 0;
	private var niceRubsCountdown:Int = 3;
	private var niceRubsCountdowns:Array<Int> = [2, 3, 4];
	private var niceRubsCountdownsIndex:Int = 0;
	private var uniqueLikedRubCount:Int = 0;
	private var uniqueDislikedRubCount:Int = 0;
	private var dislikedRubCombo:Int = 0;
	private var dislikedPenalty:Float = 0.1;
	private var heartBankruptcy:Float = 0; // number of hearts owed at the end

	/*
	 * niceThings[0] = rub seven of Smeargle's favorite places
	 * niceThings[1] = rub one of Smeargle's favorite places three times in a row
	 * niceThings[2] = rub Smeargle's hat quickly
	 */
	private var niceThings:Array<Bool> = [true, true, true];

	/*
	 * meanThings[0] = rub three of Smeargle's unfavorite places
	 * meanThings[1] = rub one of Smeargle's unfavorite places twice in a row
	 */
	private var meanThings:Array<Bool> = [true, true];

	private var smeargleMood0:Int = FlxG.random.int(0, 11); // what order does smeargle like being petted in?
	private var smeargleMood1:Int = 0; // is smeargle horny?
	private var smeargleMood2:Int = FlxG.random.int(0, 3); // what kind of hint (3 == fast hat hint, 4 == body hint, 5 == both hint)
	private var blushTimer:Float = 0;
	public var hatgasm:Bool = false;
	public var dirtyDirtyOrgasm:Bool = false; // two kinds of orgasms; hatgasms and the other kind
	public var canEjaculate:Bool = false;
	private var dislikedHandsDown:Bool = false; // smeargle disliked something you did when his hands were down
	private var dislikedHandsUp:Bool = false; // smeargle disliked something you did when his hands were up

	private var xlDildoButton:FlxButton;
	private var _largeGreyBeadButton:FlxButton;
	private var _vibeButton:FlxButton;
	private var _elecvibeButton:FlxButton;
	private var _toyInterface:VibeInterface;

	private var perfectVibe:String;
	private var goodVibes:Array<String> = [];
	private var dickVibeAngleArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
	private var unguessedVibeSettings:Map<String, Bool> = new Map<String, Bool>();
	private var lastFewVibeSettings:Array<String> = [];
	private var vibeRewardFrequency:Float = 1.8;
	private var vibeRewardTimer:Float = 0;
	private var vibeReservoir:Float = 0;
	private var consecutiveVibeCount:Int = 0;
	private var vibeGettingCloser:Bool = false; // just made a new guess which had something in common with the good vibe setting
	private var addToyHeartsToOrgasm:Bool = false; // successfully found the target vibe setting
	private var vibeChecked:Bool = false;
	private var vibeCheckTimer:Float = 0;

	private var perfectVibeChoices:Array<Array<Dynamic>> = [
				[VibeSfx.VibeMode.Sustained, 1],
				[VibeSfx.VibeMode.Sustained, 2],
				[VibeSfx.VibeMode.Sustained, 3],
				[VibeSfx.VibeMode.Sustained, 4],
				[VibeSfx.VibeMode.Sustained, 5],
				[VibeSfx.VibeMode.Pulse, 1],
				[VibeSfx.VibeMode.Pulse, 2],
				[VibeSfx.VibeMode.Pulse, 3],
				[VibeSfx.VibeMode.Pulse, 4],
				[VibeSfx.VibeMode.Pulse, 5],
				[VibeSfx.VibeMode.Sine, 1],
				[VibeSfx.VibeMode.Sine, 2],
				[VibeSfx.VibeMode.Sine, 3],
				[VibeSfx.VibeMode.Sine, 4],
				[VibeSfx.VibeMode.Sine, 5],
			];

	override public function create():Void
	{
		prepare("smea");

		// Shift Smeargle down so he's framed in the window better
		_pokeWindow.shiftVisualItems(20);

		super.create();

		_toyInterface = new VibeInterface(_pokeWindow._vibe);
		toyGroup.add(_toyInterface);

		_headTimerFactor = 1.5;

		if (PlayerData.smeaReservoir >= 60)
		{
			// being horny puts smeargle in a horny mood
			smeargleMood1 = 1;
		}
		if (PlayerData.smeaSexyBeforeChat == 1)
		{
			// talking about hat rubs makes smeargle start with his arms down
			smeargleMood0 = smeargleMood0 % 6;
		}
		if (PlayerData.smeaSexyBeforeChat == 2 && smeargleMood1 == 1)
		{
			// talking about dick rubs makes smeargle start with his arms up
			smeargleMood0 = smeargleMood0 % 6 + 6;
		}
		if (PlayerData.smeaSexyBeforeChat == 4)
		{
			// talking about "he hates these things when his arms are down" makes smeargle start with his arms down
			smeargleMood0 = smeargleMood0 % 6;
		}
		if (PlayerData.smeaSexyBeforeChat == 5)
		{
			// talking about "he hates these things when his arms are up" makes smeargle start with his arms up
			smeargleMood0 = smeargleMood0 % 6 + 6;
		}

		niceRubsCountdowns = [[2, 3, 4], [4, 3, 2], [2, 2, 5]][smeargleMood0 % 3];
		niceRubsCountdownsIndex = Std.int((smeargleMood0 % 6) / 3);
		niceRubsCountdown = niceRubsCountdowns[niceRubsCountdownsIndex] - 1;
		niceRubsIndex = Std.int(smeargleMood0 / 6);
		_pokeWindow._comfort = niceRubsIndex;
		_armsAndLegsArranger = new ArmsAndLegsArranger(_pokeWindow, 12, 18);
		_pokeWindow.arrangeArmsAndLegs();

		if (smeargleMood1 == 1)
		{
			niceRubs[1].push("rub-dick");
			niceRubs[1].push("jack-off");
			niceRubs[1].push("balls");
		}

		if (smeargleMood2 == 5)
		{
			// only one hint...
			fasterHatWords.frequency = 1000000;
			bellyRubWords.frequency = 1000000;
			earRubWords.frequency = 1000000;
			thighRubWords.frequency = 1000000;
		}

		sfxEncouragement = [AssetPaths.smea0__mp3, AssetPaths.smea1__mp3, AssetPaths.smea2__mp3, AssetPaths.smea3__mp3];
		sfxPleasure = [AssetPaths.smea4__mp3, AssetPaths.smea5__mp3, AssetPaths.smea6__mp3];
		sfxOrgasm = [AssetPaths.smea7__mp3, AssetPaths.smea8__mp3, AssetPaths.smea9__mp3];

		popularity = -0.1;
		cumTrait0 = 7;
		cumTrait1 = 2;
		cumTrait2 = 6;
		cumTrait3 = 1;
		cumTrait4 = 7;

		sweatAreas.push({chance:3, sprite:_head, sweatArrayArray:headSweatArray});
		sweatAreas.push({chance:7, sprite:_pokeWindow._torso0, sweatArrayArray:torsoSweatArray});

		_bonerThreshold = 0.66;
		_cumThreshold = 0.35;

		for (perfectVibeChoice in perfectVibeChoices)
		{
			unguessedVibeSettings[vibeString(perfectVibeChoice[0], perfectVibeChoice[1])] = true;
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_LARGE_GREY_BEADS))
		{
			_largeGreyBeadButton = newToyButton(largeGreyBeadButtonEvent, AssetPaths.xlbeads_grey_button__png, _dialogTree);
			addToyButton(_largeGreyBeadButton, 0.31);
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_VIBRATOR))
		{
			_vibeButton = newToyButton(vibeButtonEvent, AssetPaths.vibe_button__png, _dialogTree);
			addToyButton(_vibeButton);
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_HUGE_DILDO))
		{
			xlDildoButton = newToyButton(xlDildoButtonEvent, AssetPaths.dildo_xl_button__png, _dialogTree);
			addToyButton(xlDildoButton, 0.31);
		}

		if (ItemDatabase.getPurchasedMysteryBoxCount() >= 8)
		{
			_elecvibeButton = newToyButton(elecvibeButtonEvent, AssetPaths.elecvibe_button__png, _dialogTree);
			addToyButton(_elecvibeButton);
		}
	}

	public function xlDildoButtonEvent():Void
	{
		playButtonClickSound();
		removeToyButton(xlDildoButton);
		var tree:Array<Array<Object>> = [];
		SmeargleDialog.snarkyHugeDildo(tree);
		showEarlyDialog(tree);
	}

	public function largeGreyBeadButtonEvent():Void
	{
		playButtonClickSound();
		removeToyButton(_largeGreyBeadButton);
		var tree:Array<Array<Object>> = [];
		SmeargleDialog.snarkyBeads(tree);
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

	override public function toyOffButtonEvent():Void
	{
		super.toyOffButtonEvent();
		if (!shouldEmitToyInterruptWords() && _remainingOrgasms > 0)
		{
			emitWords(toyStopWords);
		}
	}

	override public function shouldEmitToyInterruptWords():Bool
	{
		return _toyBank.getForeplayPercent() == 1.0 && _toyBank.getDickPercent() == 1.0;
	}

	override function toyForeplayFactor():Float
	{
		/*
		 * 30% of the toy hearts are available for doing random stuff. the
		 * other 70% are only available if you hit the right spot
		 */
		return 0.3;
	}

	override public function handleToyWindow(elapsed:Float):Void
	{
		super.handleToyWindow(elapsed);

		if (_toyInterface.lightningButtonDuration > 0)
		{
			_toyInterface.doLightning(this, electricPolyArray);
		}

		if (_toyInterface.lightningButtonDuration > 1)
		{
			// reduce Smeargle's toy meter for next time
			_toyBank._dickHeartReservoir = SexyState.roundDownToQuarter(_toyBank._dickHeartReservoir * 0.4);
			_toyBank._foreplayHeartReservoir = SexyState.roundDownToQuarter(_toyBank._foreplayHeartReservoir * 0.4);
			doMeanThing();

			var tree:Array<Array<Object>> = [];
			SmeargleDialog.unwantedElectricVibe(tree);
			PlayerData.appendChatHistory("smea.unwantedElectricVibe");
			showEarlyDialog(tree);

			// turn off the toy, but don't emit any words
			super.toyOffButtonEvent();
		}

		vibeGettingCloser = false;

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

		if (!_pokeWindow._vibe.vibeSfx.isVibratorOn())
		{
			lastFewVibeSettings.splice(0, lastFewVibeSettings.length);
			consecutiveVibeCount = 0;
			vibeChecked = false;

			if (!came && smeargleMood1 == 0)
			{
				if (_pokeWindow._uncomfortable == true)
				{
					setUncomfortable(false);
				}
			}

			return;
		}

		// accumulate rewards in vibeReservoir...
		vibeRewardTimer += elapsed;
		_idlePunishmentTimer = 0; // pokemon doesn't get bored if the vibrator's on

		if (lastFewVibeSettings.length > 0)
		{
			vibeCheckTimer += elapsed;
		}

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
				vibeReservoir += deductionAmount * (smeargleMood1 == 0 ? 0.5 : 1.0);
			}
			if (amount > 0 && !pastBonerThreshold() && _heartBank._foreplayHeartReservoir > 0)
			{
				// if the toy bank's empty, get them from the foreplay heart reservoir...
				var deductionAmount:Float = Math.min(amount, _heartBank._foreplayHeartReservoir);
				amount -= deductionAmount;
				_heartBank._foreplayHeartReservoir -= deductionAmount;
				vibeReservoir += deductionAmount * (smeargleMood1 == 0 ? 0.5 : 1.0);
			}
			if (amount > 0 && pastBonerThreshold() && _heartBank._dickHeartReservoir > 0)
			{
				// if the toy bank's empty, get them from the dick heart reservoir...
				var deductionAmount:Float = Math.min(amount, _heartBank._dickHeartReservoir);
				amount -= deductionAmount;
				_heartBank._dickHeartReservoir -= deductionAmount;
				vibeReservoir += deductionAmount * (smeargleMood1 == 0 ? 0.5 : 1.0);
			}
		}

		if (vibeReservoir > 0 && _pokeWindow._vibe.vibeSfx.isVibrating())
		{
			// emit hearts from vibe reservoir
			_heartEmitCount += vibeReservoir;

			if (!came && smeargleMood1 == 0)
			{
				if (_pokeWindow._vibe.vibeSfx.isVibratorOn())
				{
					if (_pokeWindow._uncomfortable == false)
					{
						setUncomfortable(true);
					}
				}
			}

			// normal vibrator activity
			matchVibeHearts();
			maybeAccelerateVibeReward();
			checkPerfectVibeSpot();

			maybeEmitPrecum();

			if (_remainingOrgasms > 0)
			{
				if (_heartBank.getDickPercent() < 0.5 && almostWords.timer <= 0)
				{
					blushTimer = FlxMath.bound(blushTimer + 12, 0, 18);
					// warn them ahead of time...
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
	 * hearts from the heartbank. This makes it so Smeargle will eventually cum
	 * from just using the vibrator.
	 */
	function matchVibeHearts()
	{
		var heartMatchPct:Float = 0;
		if (_toyBank.getForeplayPercent() <= 0 )
		{
			heartMatchPct = 0.20;
		}
		else if (_toyBank.getForeplayPercent() <= 0.25)
		{
			heartMatchPct = 0.16;
		}
		else if (_toyBank.getForeplayPercent() <= 0.50)
		{
			heartMatchPct = 0.13;
		}
		else if (_toyBank.getForeplayPercent() <= 0.75)
		{
			heartMatchPct = 0.10;
		}
		if (heartMatchPct > 0)
		{
			if (!pastBonerThreshold())
			{
				var deductionAmount:Float = Math.min(SexyState.roundUpToQuarter(vibeReservoir * heartMatchPct), _heartBank._foreplayHeartReservoir);
				_heartBank._foreplayHeartReservoir -= deductionAmount;
				_heartEmitCount += SexyState.roundUpToQuarter(deductionAmount * (smeargleMood1 == 0 ? 0.5 : 1.0));
			}
			else
			{
				var deductionAmount:Float = Math.min(SexyState.roundUpToQuarter(vibeReservoir * heartMatchPct), _heartBank._dickHeartReservoir);
				_heartBank._dickHeartReservoir -= deductionAmount;
				_heartEmitCount += SexyState.roundUpToQuarter(deductionAmount * (smeargleMood1 == 0 ? 0.5 : 1.0));
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
			vibeChecked = false;
		}

		var accelFactor:Float = 2.4;
		switch (_pokeWindow._vibe.vibeSfx.speed)
		{
			case 1: accelFactor = 0.8;
			case 2: accelFactor = 1.0;
			case 3: accelFactor = 1.4;
			case 4: accelFactor = 1.8;
			case 5: accelFactor = 2.4;
		}
		var minFrequency:Float = 0.30;
		switch (_pokeWindow._vibe.vibeSfx.speed)
		{
			case 1: minFrequency = 1.00;
			case 2: minFrequency = 0.74;
			case 3: minFrequency = 0.55;
			case 4: minFrequency = 0.41;
			case 5: minFrequency = 0.30;
		}
		vibeRewardFrequency = FlxMath.bound(10 / (6 + accelFactor * consecutiveVibeCount), minFrequency, 1.6);
	}

	/**
	 * Check whether the player is getting closer to the perfect vibe spot...
	 */
	function checkPerfectVibeSpot()
	{
		var isBlushGuess:Bool = consecutiveVibeCount == 1 && vibeCheckTimer >= 10.0;
		var isGuessGuess:Bool = FlxG.random.int(0, 3) < consecutiveVibeCount;
		if ((isBlushGuess || isGuessGuess) && vibeChecked == false && perfectVibeChoices.length > 0)
		{
			// did they find the magic spot?
			if (isGuessGuess)
			{
				vibeChecked = true;
				perfectVibeChoices = perfectVibeChoices.filter(function(choice) {return choice[0] != _pokeWindow._vibe.vibeSfx.mode || choice[1] != _pokeWindow._vibe.vibeSfx.speed; });
				if (perfectVibeChoices.length == 0)
				{
					if (vibeCheckTimer < 30)
					{
						// no penalty
					}
					else
					{
						_toyBank._dickHeartReservoir = SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * Math.pow(0.7, (vibeCheckTimer - 30) * 0.15));
					}

					// yes; found the magic spot
					var rewardAmount:Float = SexyState.roundUpToQuarter(lucky(0.25, 0.35) * _toyBank._dickHeartReservoir);
					_toyBank._dickHeartReservoir -= rewardAmount;
					_heartEmitCount += rewardAmount;

					// dump remaining toy "reward hearts" into toy "automatic hearts"
					_toyBank._foreplayHeartReservoir += _toyBank._dickHeartReservoir;
					// increase capacity too, since vibrator throughput scales on capacity
					_toyBank._foreplayHeartReservoirCapacity += SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * 0.2);
					_toyBank._dickHeartReservoir = 0;

					maybeEmitWords(pleasureWords);
					maybePlayPokeSfx();

					precum(FlxMath.bound(10 * Math.pow(0.7, FlxMath.bound(vibeCheckTimer - 20, 0, 9999) * 0.10), 1, 10)); // silly amount of precum

					addToyHeartsToOrgasm = true;
				}
			}

			if (perfectVibeChoices.length > 0)
			{
				// no; give them a hint
				var possibleVibeChoice:Array<Dynamic> = FlxG.random.getObject(perfectVibeChoices);
				// do they have the mode or speed correct?
				if (possibleVibeChoice[0] == _pokeWindow._vibe.vibeSfx.mode || possibleVibeChoice[1]  == _pokeWindow._vibe.vibeSfx.speed)
				{
					vibeGettingCloser = true;
					if (isBlushGuess)
					{
						blushTimer = FlxMath.bound(blushTimer + 12, 0, 18);
					}
					perfectVibeChoices = perfectVibeChoices.filter(function(choice) {return choice[0] == _pokeWindow._vibe.vibeSfx.mode || choice[1] == _pokeWindow._vibe.vibeSfx.speed; });

					if (unguessedVibeSettings[vibeString(_pokeWindow._vibe.vibeSfx.mode, _pokeWindow._vibe.vibeSfx.speed)] == true)
					{
						unguessedVibeSettings[vibeString(_pokeWindow._vibe.vibeSfx.mode, _pokeWindow._vibe.vibeSfx.speed)] = false;
						var rewardAmount:Float = SexyState.roundUpToQuarter(lucky(0.04, 0.08) * _toyBank._dickHeartReservoir);
						_toyBank._dickHeartReservoir -= rewardAmount;
						_heartEmitCount += rewardAmount;
					}
				}
				else
				{
					if (isBlushGuess)
					{
						blushTimer = 0;
					}
					perfectVibeChoices = perfectVibeChoices.filter(function(choice) {return choice[0] != _pokeWindow._vibe.vibeSfx.mode && choice[1] != _pokeWindow._vibe.vibeSfx.speed; });
				}
			}
		}
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
			blushTimer = 0;
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

		if (niceRubsIndex == 0)
		{
			// should rub top part of body
			_pokeWindow._comfort = 0;
		}
		else {
			if (_pokeWindow._arousal >= 4)
			{
				_pokeWindow._comfort = 3;
			}
			else if (_pokeWindow._arousal >= 3)
			{
				_pokeWindow._comfort = 2;
			}
			else {
				_pokeWindow._comfort = 1;
			}
		}

		if (!fancyRubAnimatesSprite(_dick))
		{
			setInactiveDickAnimation();
		}
	}

	private function setUncomfortable(uncomfortable:Bool):Void
	{
		_pokeWindow._uncomfortable = uncomfortable;
		if (uncomfortable)
		{
			_pokeWindow._arousal = 0;
			if (_armsAndLegsArranger._armsAndLegsTimer > 1)
			{
				_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(0, 1);
			}
			if (_newHeadTimer > 2)
			{
				_newHeadTimer = FlxG.random.float(1, 2);
			}
		}
		else {
			if (_armsAndLegsArranger._armsAndLegsTimer > 2)
			{
				_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(1, 2);
			}
			if (_newHeadTimer > 2)
			{
				_newHeadTimer = FlxG.random.float(1, 2);
			}
		}
	}

	override function shouldRecordMouseTiming():Bool
	{
		return _rubHandAnim != null;
	}

	override public function touchPart(touchedPart:FlxSprite):Bool
	{
		mouseTiming = [];
		if (FlxG.mouse.justPressed && touchedPart == _dick || (!_male && (touchedPart == _pokeWindow._torso0 || touchedPart == _pokeWindow._legs0) && clickedPolygon(_pokeWindow._torso0, vagPolyArray)))
		{
			if (_gameState == 200 && pastBonerThreshold())
			{
				interactOn(_dick, "jack-off");
			}
			else
			{
				interactOn(_dick, "rub-dick");
			}
			if (!came && _pokeWindow._comfort <= 1 && smeargleMood1 == 0)
			{
				setUncomfortable(true);
			}
			return true;
		}
		if (FlxG.mouse.justPressed && touchedPart == _pokeWindow._balls)
		{
			interactOn(_pokeWindow._balls, "rub-balls");
			_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.members.indexOf(_pokeWindow._dick) + 1);
			if (_pokeWindow._comfort <= 1 && smeargleMood1 == 0)
			{
				setUncomfortable(true);
			}
			return true;
		}
		if (FlxG.mouse.justPressed && touchedPart == _head)
		{
			if (clickedPolygon(touchedPart, tonguePolyArray))
			{
				interactOn(_pokeWindow._tongue, "pull-tongue");
				_pokeWindow._tongue.visible = true;
				_head.animation.play("tongue-s");
				_pokeWindow.updateBlush();
				return true;
			}
		}
		if (touchedPart == _pokeWindow._legs1 && _clickedDuration > 0.4)
		{
			if (clickedPolygon(touchedPart, leftFootPolyArray))
			{
				// raise left leg
				_pokeWindow.playNewAnim(_pokeWindow._legs0, ["4-0", "4-1"]);
				_pokeWindow.avoidWonkyArmLegCombo();
				_pokeWindow.syncArmsAndLegs();
				_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(4, 6);
			}
			if (clickedPolygon(touchedPart, rightFootPolyArray))
			{
				// raise right leg
				_pokeWindow.playNewAnim(_pokeWindow._legs0, ["4-2", "4-3"]);
				_pokeWindow.avoidWonkyArmLegCombo();
				_pokeWindow.syncArmsAndLegs();
				_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(4, 6);
			}
		}
		if (touchedPart == _pokeWindow._legs2)
		{
			if (_pokeWindow._legs2.animation.name == "4-0" || _pokeWindow._legs2.animation.name == "4-1")
			{
				interactOn(_pokeWindow._legs2, "rub-left-foot0");
				_rubBodyAnim.addAnimName("rub-left-foot2");
				_rubHandAnim.addAnimName("rub-left-foot2");
				_rubBodyAnim.addAnimName("rub-left-foot1");
				_rubHandAnim.addAnimName("rub-left-foot1");
				_rubBodyAnim.addAnimName("rub-left-foot2");
				_rubHandAnim.addAnimName("rub-left-foot2");
				_rubBodyAnim.addAnimName("rub-left-foot0");
				_rubHandAnim.addAnimName("rub-left-foot0");
				_rubBodyAnim.addAnimName("rub-left-foot1");
				_rubHandAnim.addAnimName("rub-left-foot1");
				return true;
			}
			if (_pokeWindow._legs2.animation.name == "4-2" || _pokeWindow._legs2.animation.name == "4-3")
			{
				interactOn(_pokeWindow._legs2, "rub-right-foot0");
				_rubBodyAnim.addAnimName("rub-right-foot2");
				_rubHandAnim.addAnimName("rub-right-foot2");
				_rubBodyAnim.addAnimName("rub-right-foot1");
				_rubHandAnim.addAnimName("rub-right-foot1");
				_rubBodyAnim.addAnimName("rub-right-foot2");
				_rubHandAnim.addAnimName("rub-right-foot2");
				_rubBodyAnim.addAnimName("rub-right-foot0");
				_rubHandAnim.addAnimName("rub-right-foot0");
				_rubBodyAnim.addAnimName("rub-right-foot1");
				_rubHandAnim.addAnimName("rub-right-foot1");
				return true;
			}
		}
		if (touchedPart == _head)
		{
			if (clickedPolygon(touchedPart, hatPolyArray))
			{
				if (clickedPolygon(touchedPart, leftHatPolyArray))
				{
					interactOn(_pokeWindow._hat, "scritchhat-c");
				}
				else
				{
					interactOn(_pokeWindow._hat, "palmhat-c");
				}
				_pokeWindow.setArousal(_pokeWindow._arousal);
				_newHeadTimer = FlxG.random.float(2, 4) * _headTimerFactor;
				_pokeWindow.updateBlush();
				_pokeWindow._hat.visible = true;
				return true;
			}
		}
		return false;
	}

	override public function untouchPart(touchedPart:FlxSprite):Void
	{
		super.untouchPart(touchedPart);
		if (_pokeWindow._uncomfortable)
		{
			setUncomfortable(false);
		}
		if (touchedPart == _pokeWindow._tongue)
		{
			_pokeWindow._tongue.visible = false;
			_head.animation.play("0-s");
			_pokeWindow.updateBlush();
			_newHeadTimer = FlxG.random.float(0.1, 0.5);
		}
		else if (touchedPart == _pokeWindow._hat)
		{
			_pokeWindow._hat.visible = false;
			if (_pokeWindow._arousal >= 3)
			{
				_head.animation.play("4-c");
			}
			else if (_pokeWindow._arousal >= 2)
			{
				_head.animation.play("2-c");
			}
			else
			{
				_head.animation.play("1-c");
			}
			_pokeWindow.updateBlush();
		}
		else if (touchedPart == _pokeWindow._legs2)
		{
			_pokeWindow._legs2.animation.play(_pokeWindow._legs0.animation.name);
			_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(1, 2);
		}
	}

	override public function initializeHitBoxes():Void
	{
		tonguePolyArray = new Array<Array<FlxPoint>>();
		tonguePolyArray[0] = [new FlxPoint(170, 230), new FlxPoint(163, 194), new FlxPoint(200, 192), new FlxPoint(210, 229)];
		tonguePolyArray[1] = [new FlxPoint(170, 230), new FlxPoint(163, 194), new FlxPoint(200, 192), new FlxPoint(210, 229)];
		tonguePolyArray[2] = [new FlxPoint(170, 230), new FlxPoint(163, 194), new FlxPoint(200, 192), new FlxPoint(210, 229)];
		tonguePolyArray[3] = [new FlxPoint(164, 229), new FlxPoint(172, 196), new FlxPoint(209, 204), new FlxPoint(198, 247)];
		tonguePolyArray[4] = [new FlxPoint(164, 229), new FlxPoint(172, 196), new FlxPoint(209, 204), new FlxPoint(198, 247)];
		tonguePolyArray[5] = [new FlxPoint(164, 229), new FlxPoint(172, 196), new FlxPoint(209, 204), new FlxPoint(198, 247)];
		tonguePolyArray[6] = [new FlxPoint(156, 240), new FlxPoint(144, 206), new FlxPoint(185, 206), new FlxPoint(199, 247)];
		tonguePolyArray[7] = [new FlxPoint(156, 240), new FlxPoint(144, 206), new FlxPoint(185, 206), new FlxPoint(199, 247)];
		tonguePolyArray[8] = [new FlxPoint(156, 240), new FlxPoint(144, 206), new FlxPoint(185, 206), new FlxPoint(199, 247)];
		tonguePolyArray[12] = [new FlxPoint(203, 240), new FlxPoint(197, 194), new FlxPoint(238, 189), new FlxPoint(249, 242)];
		tonguePolyArray[13] = [new FlxPoint(203, 240), new FlxPoint(197, 194), new FlxPoint(238, 189), new FlxPoint(249, 242)];
		tonguePolyArray[14] = [new FlxPoint(203, 240), new FlxPoint(197, 194), new FlxPoint(238, 189), new FlxPoint(249, 242)];
		tonguePolyArray[15] = [new FlxPoint(231, 234), new FlxPoint(223, 184), new FlxPoint(259, 178), new FlxPoint(282, 232)];
		tonguePolyArray[16] = [new FlxPoint(231, 234), new FlxPoint(223, 184), new FlxPoint(259, 178), new FlxPoint(282, 232)];
		tonguePolyArray[17] = [new FlxPoint(231, 234), new FlxPoint(223, 184), new FlxPoint(259, 178), new FlxPoint(282, 232)];
		tonguePolyArray[18] = [new FlxPoint(165, 236), new FlxPoint(168, 187), new FlxPoint(200, 184), new FlxPoint(213, 236)];
		tonguePolyArray[19] = [new FlxPoint(165, 236), new FlxPoint(168, 187), new FlxPoint(200, 184), new FlxPoint(213, 236)];
		tonguePolyArray[20] = [new FlxPoint(165, 236), new FlxPoint(168, 187), new FlxPoint(200, 184), new FlxPoint(213, 236)];
		tonguePolyArray[21] = [new FlxPoint(165, 236), new FlxPoint(168, 187), new FlxPoint(200, 184), new FlxPoint(213, 236)];
		tonguePolyArray[22] = [new FlxPoint(165, 236), new FlxPoint(168, 187), new FlxPoint(200, 184), new FlxPoint(213, 236)];
		tonguePolyArray[23] = [new FlxPoint(165, 236), new FlxPoint(168, 187), new FlxPoint(200, 184), new FlxPoint(213, 236)];
		tonguePolyArray[50] = [new FlxPoint(170, 230), new FlxPoint(163, 194), new FlxPoint(200, 192), new FlxPoint(210, 229)];
		tonguePolyArray[53] = [new FlxPoint(170, 230), new FlxPoint(163, 194), new FlxPoint(200, 192), new FlxPoint(210, 229)];
		tonguePolyArray[56] = [new FlxPoint(170, 230), new FlxPoint(163, 194), new FlxPoint(200, 192), new FlxPoint(210, 229)];

		leftFootPolyArray = new Array<Array<FlxPoint>>();
		leftFootPolyArray[0] = [new FlxPoint(114, 449), new FlxPoint(113, 376), new FlxPoint(192, 366), new FlxPoint(190, 454)];
		leftFootPolyArray[1] = [new FlxPoint(60, 381), new FlxPoint(159, 381), new FlxPoint(165, 458), new FlxPoint(60, 458)];
		leftFootPolyArray[2] = [new FlxPoint(113, 374), new FlxPoint(178, 349), new FlxPoint(203, 436), new FlxPoint(136, 448)];
		leftFootPolyArray[3] = [new FlxPoint(133, 456), new FlxPoint(134, 360), new FlxPoint(196, 368), new FlxPoint(199, 454)];
		leftFootPolyArray[4] = [new FlxPoint(41, 396), new FlxPoint(148, 367), new FlxPoint(169, 442), new FlxPoint(60, 465)];
		leftFootPolyArray[5] = [new FlxPoint(10, 406), new FlxPoint(128, 411), new FlxPoint(124, 464), new FlxPoint(10, 465)];
		leftFootPolyArray[6] = [new FlxPoint(10, 406), new FlxPoint(128, 411), new FlxPoint(124, 464), new FlxPoint(10, 465)];
		leftFootPolyArray[10] = [new FlxPoint(30, 403), new FlxPoint(122, 415), new FlxPoint(120, 465), new FlxPoint(30, 465)];
		leftFootPolyArray[11] = [new FlxPoint(35, 405), new FlxPoint(141, 372), new FlxPoint(162, 440), new FlxPoint(64, 460)];

		rightFootPolyArray = new Array<Array<FlxPoint>>();
		rightFootPolyArray[0] = [new FlxPoint(189, 446), new FlxPoint(195, 348), new FlxPoint(278, 357), new FlxPoint(267, 455)];
		rightFootPolyArray[1] = [new FlxPoint(215, 387), new FlxPoint(331, 388), new FlxPoint(334, 465), new FlxPoint(224, 464)];
		rightFootPolyArray[2] = [new FlxPoint(241, 424), new FlxPoint(344, 381), new FlxPoint(388, 465), new FlxPoint(252, 465)];
		rightFootPolyArray[3] = [new FlxPoint(241, 424), new FlxPoint(344, 381), new FlxPoint(388, 465), new FlxPoint(252, 465)];
		rightFootPolyArray[4] = [new FlxPoint(206, 349), new FlxPoint(269, 368), new FlxPoint(246, 451), new FlxPoint(179, 443)];
		rightFootPolyArray[5] = [new FlxPoint(228, 393), new FlxPoint(296, 394), new FlxPoint(343, 465), new FlxPoint(207, 465)];
		rightFootPolyArray[6] = [new FlxPoint(191, 376), new FlxPoint(240, 370), new FlxPoint(257, 455), new FlxPoint(177, 461)];
		rightFootPolyArray[8] = [new FlxPoint(205, 354), new FlxPoint(271, 370), new FlxPoint(248, 454), new FlxPoint(180, 433)];
		rightFootPolyArray[9] = [new FlxPoint(239, 370), new FlxPoint(249, 449), new FlxPoint(186, 453), new FlxPoint(177, 380)];

		hatPolyArray = new Array<Array<FlxPoint>>();
		hatPolyArray[0] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[1] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[2] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[3] = [new FlxPoint(119, 127), new FlxPoint(149, 131), new FlxPoint(182, 150), new FlxPoint(218, 155), new FlxPoint(237, 151), new FlxPoint(263, 158), new FlxPoint(313, 38), new FlxPoint(93, 37)];
		hatPolyArray[4] = [new FlxPoint(119, 127), new FlxPoint(149, 131), new FlxPoint(182, 150), new FlxPoint(218, 155), new FlxPoint(237, 151), new FlxPoint(263, 158), new FlxPoint(313, 38), new FlxPoint(93, 37)];
		hatPolyArray[5] = [new FlxPoint(119, 127), new FlxPoint(149, 131), new FlxPoint(182, 150), new FlxPoint(218, 155), new FlxPoint(237, 151), new FlxPoint(263, 158), new FlxPoint(313, 38), new FlxPoint(93, 37)];
		hatPolyArray[6] = [new FlxPoint(99, 160), new FlxPoint(133, 171), new FlxPoint(172, 155), new FlxPoint(234, 107), new FlxPoint(247, 39), new FlxPoint(60, 45)];
		hatPolyArray[7] = [new FlxPoint(99, 160), new FlxPoint(133, 171), new FlxPoint(172, 155), new FlxPoint(234, 107), new FlxPoint(247, 39), new FlxPoint(60, 45)];
		hatPolyArray[8] = [new FlxPoint(99, 160), new FlxPoint(133, 171), new FlxPoint(172, 155), new FlxPoint(234, 107), new FlxPoint(247, 39), new FlxPoint(60, 45)];
		hatPolyArray[9] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[10] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[11] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[12] = [new FlxPoint(112, 153), new FlxPoint(173, 128), new FlxPoint(217, 138), new FlxPoint(258, 110), new FlxPoint(274, 45), new FlxPoint(69, 42), new FlxPoint(90, 143)];
		hatPolyArray[13] = [new FlxPoint(112, 153), new FlxPoint(173, 128), new FlxPoint(217, 138), new FlxPoint(258, 110), new FlxPoint(274, 45), new FlxPoint(69, 42), new FlxPoint(90, 143)];
		hatPolyArray[14] = [new FlxPoint(112, 153), new FlxPoint(173, 128), new FlxPoint(217, 138), new FlxPoint(258, 110), new FlxPoint(274, 45), new FlxPoint(69, 42), new FlxPoint(90, 143)];
		hatPolyArray[15] = [new FlxPoint(91, 133), new FlxPoint(129, 146), new FlxPoint(188, 134), new FlxPoint(236, 133), new FlxPoint(263, 120), new FlxPoint(271, 41), new FlxPoint(97, 44)];
		hatPolyArray[16] = [new FlxPoint(91, 133), new FlxPoint(129, 146), new FlxPoint(188, 134), new FlxPoint(236, 133), new FlxPoint(263, 120), new FlxPoint(271, 41), new FlxPoint(97, 44)];
		hatPolyArray[17] = [new FlxPoint(91, 133), new FlxPoint(129, 146), new FlxPoint(188, 134), new FlxPoint(236, 133), new FlxPoint(263, 120), new FlxPoint(271, 41), new FlxPoint(97, 44)];
		hatPolyArray[18] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[19] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[20] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[24] = [new FlxPoint(106, 125), new FlxPoint(134, 134), new FlxPoint(176, 135), new FlxPoint(224, 148), new FlxPoint(256, 138), new FlxPoint(275, 38), new FlxPoint(92, 46)];
		hatPolyArray[25] = [new FlxPoint(106, 125), new FlxPoint(134, 134), new FlxPoint(176, 135), new FlxPoint(224, 148), new FlxPoint(256, 138), new FlxPoint(275, 38), new FlxPoint(92, 46)];
		hatPolyArray[26] = [new FlxPoint(106, 125), new FlxPoint(134, 134), new FlxPoint(176, 135), new FlxPoint(224, 148), new FlxPoint(256, 138), new FlxPoint(275, 38), new FlxPoint(92, 46)];
		hatPolyArray[27] = [new FlxPoint(119, 127), new FlxPoint(149, 131), new FlxPoint(182, 150), new FlxPoint(218, 155), new FlxPoint(237, 151), new FlxPoint(263, 158), new FlxPoint(313, 38), new FlxPoint(93, 37)];
		hatPolyArray[28] = [new FlxPoint(119, 127), new FlxPoint(149, 131), new FlxPoint(182, 150), new FlxPoint(218, 155), new FlxPoint(237, 151), new FlxPoint(263, 158), new FlxPoint(313, 38), new FlxPoint(93, 37)];
		hatPolyArray[29] = [new FlxPoint(119, 127), new FlxPoint(149, 131), new FlxPoint(182, 150), new FlxPoint(218, 155), new FlxPoint(237, 151), new FlxPoint(263, 158), new FlxPoint(313, 38), new FlxPoint(93, 37)];
		hatPolyArray[30] = [new FlxPoint(112, 153), new FlxPoint(173, 128), new FlxPoint(217, 138), new FlxPoint(258, 110), new FlxPoint(274, 45), new FlxPoint(69, 42), new FlxPoint(90, 143)];
		hatPolyArray[31] = [new FlxPoint(112, 153), new FlxPoint(173, 128), new FlxPoint(217, 138), new FlxPoint(258, 110), new FlxPoint(274, 45), new FlxPoint(69, 42), new FlxPoint(90, 143)];
		hatPolyArray[32] = [new FlxPoint(112, 153), new FlxPoint(173, 128), new FlxPoint(217, 138), new FlxPoint(258, 110), new FlxPoint(274, 45), new FlxPoint(69, 42), new FlxPoint(90, 143)];
		hatPolyArray[33] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[34] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[35] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[36] = [new FlxPoint(91, 133), new FlxPoint(129, 146), new FlxPoint(188, 134), new FlxPoint(236, 133), new FlxPoint(263, 120), new FlxPoint(271, 41), new FlxPoint(97, 44)];
		hatPolyArray[37] = [new FlxPoint(91, 133), new FlxPoint(129, 146), new FlxPoint(188, 134), new FlxPoint(236, 133), new FlxPoint(263, 120), new FlxPoint(271, 41), new FlxPoint(97, 44)];
		hatPolyArray[38] = [new FlxPoint(91, 133), new FlxPoint(129, 146), new FlxPoint(188, 134), new FlxPoint(236, 133), new FlxPoint(263, 120), new FlxPoint(271, 41), new FlxPoint(97, 44)];
		hatPolyArray[39] = [new FlxPoint(99, 160), new FlxPoint(133, 171), new FlxPoint(172, 155), new FlxPoint(234, 107), new FlxPoint(247, 39), new FlxPoint(60, 45)];
		hatPolyArray[40] = [new FlxPoint(99, 160), new FlxPoint(133, 171), new FlxPoint(172, 155), new FlxPoint(234, 107), new FlxPoint(247, 39), new FlxPoint(60, 45)];
		hatPolyArray[41] = [new FlxPoint(99, 160), new FlxPoint(133, 171), new FlxPoint(172, 155), new FlxPoint(234, 107), new FlxPoint(247, 39), new FlxPoint(60, 45)];
		hatPolyArray[42] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[43] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[44] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[48] = [new FlxPoint(106, 125), new FlxPoint(134, 134), new FlxPoint(176, 135), new FlxPoint(224, 148), new FlxPoint(256, 138), new FlxPoint(275, 38), new FlxPoint(92, 46)];
		hatPolyArray[49] = [new FlxPoint(106, 125), new FlxPoint(134, 134), new FlxPoint(176, 135), new FlxPoint(224, 148), new FlxPoint(256, 138), new FlxPoint(275, 38), new FlxPoint(92, 46)];
		hatPolyArray[50] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[51] = [new FlxPoint(112, 153), new FlxPoint(173, 128), new FlxPoint(217, 138), new FlxPoint(258, 110), new FlxPoint(274, 45), new FlxPoint(69, 42), new FlxPoint(90, 143)];
		hatPolyArray[52] = [new FlxPoint(112, 153), new FlxPoint(173, 128), new FlxPoint(217, 138), new FlxPoint(258, 110), new FlxPoint(274, 45), new FlxPoint(69, 42), new FlxPoint(90, 143)];
		hatPolyArray[53] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[54] = [new FlxPoint(119, 127), new FlxPoint(149, 131), new FlxPoint(182, 150), new FlxPoint(218, 155), new FlxPoint(237, 151), new FlxPoint(263, 158), new FlxPoint(313, 38), new FlxPoint(93, 37)];
		hatPolyArray[55] = [new FlxPoint(119, 127), new FlxPoint(149, 131), new FlxPoint(182, 150), new FlxPoint(218, 155), new FlxPoint(237, 151), new FlxPoint(263, 158), new FlxPoint(313, 38), new FlxPoint(93, 37)];
		hatPolyArray[56] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[57] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[58] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[60] = [new FlxPoint(99, 160), new FlxPoint(133, 171), new FlxPoint(172, 155), new FlxPoint(234, 107), new FlxPoint(247, 39), new FlxPoint(60, 45)];
		hatPolyArray[61] = [new FlxPoint(99, 160), new FlxPoint(133, 171), new FlxPoint(172, 155), new FlxPoint(234, 107), new FlxPoint(247, 39), new FlxPoint(60, 45)];
		hatPolyArray[63] = [new FlxPoint(91, 133), new FlxPoint(129, 146), new FlxPoint(188, 134), new FlxPoint(236, 133), new FlxPoint(263, 120), new FlxPoint(271, 41), new FlxPoint(97, 44)];
		hatPolyArray[64] = [new FlxPoint(91, 133), new FlxPoint(129, 146), new FlxPoint(188, 134), new FlxPoint(236, 133), new FlxPoint(263, 120), new FlxPoint(271, 41), new FlxPoint(97, 44)];
		hatPolyArray[66] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];
		hatPolyArray[67] = [new FlxPoint(107, 157), new FlxPoint(139, 130), new FlxPoint(175, 128), new FlxPoint(220, 119), new FlxPoint(244, 132), new FlxPoint(301, 42), new FlxPoint(57, 41)];

		leftLegPolyArray = new Array<Array<FlxPoint>>();
		leftLegPolyArray[0] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[1] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[2] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[3] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[4] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[5] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[6] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[7] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[8] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[9] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[10] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[11] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[12] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[13] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[14] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[15] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[16] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[17] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[18] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];
		leftLegPolyArray[19] = [new FlxPoint(190, 460), new FlxPoint(184, 0), new FlxPoint(0, 0), new FlxPoint(0, 463)];

		leftArmPolyArray = new Array<Array<FlxPoint>>();
		leftArmPolyArray[0] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[1] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[2] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[3] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[4] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[5] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[6] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[7] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[8] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[9] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[10] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[11] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[12] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[13] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[14] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[15] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[16] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[17] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[18] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[19] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];
		leftArmPolyArray[20] = [new FlxPoint(0, 0), new FlxPoint(168, 0), new FlxPoint(181, 154), new FlxPoint(191, 464), new FlxPoint( 0, 464)];

		leftEarPolyArray = new Array<Array<FlxPoint>>();
		leftEarPolyArray[0] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[1] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[2] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[3] = [new FlxPoint(73, 206), new FlxPoint(126, 117), new FlxPoint(149, 119), new FlxPoint(151, 200), new FlxPoint(125, 230)];
		leftEarPolyArray[4] = [new FlxPoint(73, 206), new FlxPoint(126, 117), new FlxPoint(149, 119), new FlxPoint(151, 200), new FlxPoint(125, 230)];
		leftEarPolyArray[5] = [new FlxPoint(73, 206), new FlxPoint(126, 117), new FlxPoint(149, 119), new FlxPoint(151, 200), new FlxPoint(125, 230)];
		leftEarPolyArray[6] = [new FlxPoint(61, 152), new FlxPoint(109, 155), new FlxPoint(129, 194), new FlxPoint(150, 212), new FlxPoint(150, 254), new FlxPoint(75, 253)];
		leftEarPolyArray[7] = [new FlxPoint(61, 152), new FlxPoint(109, 155), new FlxPoint(129, 194), new FlxPoint(150, 212), new FlxPoint(150, 254), new FlxPoint(75, 253)];
		leftEarPolyArray[8] = [new FlxPoint(61, 152), new FlxPoint(109, 155), new FlxPoint(129, 194), new FlxPoint(150, 212), new FlxPoint(150, 254), new FlxPoint(75, 253)];
		leftEarPolyArray[9] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[10] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[11] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[12] = [new FlxPoint(66, 178), new FlxPoint(142, 128), new FlxPoint(156, 196), new FlxPoint(148, 234), new FlxPoint(71, 238)];
		leftEarPolyArray[13] = [new FlxPoint(66, 178), new FlxPoint(142, 128), new FlxPoint(156, 196), new FlxPoint(148, 234), new FlxPoint(71, 238)];
		leftEarPolyArray[14] = [new FlxPoint(66, 178), new FlxPoint(142, 128), new FlxPoint(156, 196), new FlxPoint(148, 234), new FlxPoint(71, 238)];
		leftEarPolyArray[15] = [new FlxPoint(114, 134), new FlxPoint(128, 137), new FlxPoint(160, 131), new FlxPoint(156, 174), new FlxPoint(126, 223), new FlxPoint(73, 195)];
		leftEarPolyArray[16] = [new FlxPoint(114, 134), new FlxPoint(128, 137), new FlxPoint(160, 131), new FlxPoint(156, 174), new FlxPoint(126, 223), new FlxPoint(73, 195)];
		leftEarPolyArray[17] = [new FlxPoint(114, 134), new FlxPoint(128, 137), new FlxPoint(160, 131), new FlxPoint(156, 174), new FlxPoint(126, 223), new FlxPoint(73, 195)];
		leftEarPolyArray[18] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[19] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[20] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[21] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[22] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[23] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[27] = [new FlxPoint(73, 206), new FlxPoint(126, 117), new FlxPoint(149, 119), new FlxPoint(151, 200), new FlxPoint(125, 230)];
		leftEarPolyArray[28] = [new FlxPoint(73, 206), new FlxPoint(126, 117), new FlxPoint(149, 119), new FlxPoint(151, 200), new FlxPoint(125, 230)];
		leftEarPolyArray[29] = [new FlxPoint(73, 206), new FlxPoint(126, 117), new FlxPoint(149, 119), new FlxPoint(151, 200), new FlxPoint(125, 230)];
		leftEarPolyArray[30] = [new FlxPoint(66, 178), new FlxPoint(142, 128), new FlxPoint(156, 196), new FlxPoint(148, 234), new FlxPoint(71, 238)];
		leftEarPolyArray[31] = [new FlxPoint(66, 178), new FlxPoint(142, 128), new FlxPoint(156, 196), new FlxPoint(148, 234), new FlxPoint(71, 238)];
		leftEarPolyArray[32] = [new FlxPoint(66, 178), new FlxPoint(142, 128), new FlxPoint(156, 196), new FlxPoint(148, 234), new FlxPoint(71, 238)];
		leftEarPolyArray[33] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[34] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[35] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[36] = [new FlxPoint(114, 134), new FlxPoint(128, 137), new FlxPoint(160, 131), new FlxPoint(156, 174), new FlxPoint(126, 223), new FlxPoint(73, 195)];
		leftEarPolyArray[37] = [new FlxPoint(114, 134), new FlxPoint(128, 137), new FlxPoint(160, 131), new FlxPoint(156, 174), new FlxPoint(126, 223), new FlxPoint(73, 195)];
		leftEarPolyArray[38] = [new FlxPoint(114, 134), new FlxPoint(128, 137), new FlxPoint(160, 131), new FlxPoint(156, 174), new FlxPoint(126, 223), new FlxPoint(73, 195)];
		leftEarPolyArray[39] = [new FlxPoint(61, 152), new FlxPoint(109, 155), new FlxPoint(129, 194), new FlxPoint(150, 212), new FlxPoint(150, 254), new FlxPoint(75, 253)];
		leftEarPolyArray[40] = [new FlxPoint(61, 152), new FlxPoint(109, 155), new FlxPoint(129, 194), new FlxPoint(150, 212), new FlxPoint(150, 254), new FlxPoint(75, 253)];
		leftEarPolyArray[41] = [new FlxPoint(61, 152), new FlxPoint(109, 155), new FlxPoint(129, 194), new FlxPoint(150, 212), new FlxPoint(150, 254), new FlxPoint(75, 253)];
		leftEarPolyArray[42] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[43] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[44] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[50] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[51] = [new FlxPoint(66, 178), new FlxPoint(142, 128), new FlxPoint(156, 196), new FlxPoint(148, 234), new FlxPoint(71, 238)];
		leftEarPolyArray[52] = [new FlxPoint(66, 178), new FlxPoint(142, 128), new FlxPoint(156, 196), new FlxPoint(148, 234), new FlxPoint(71, 238)];
		leftEarPolyArray[53] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[54] = [new FlxPoint(73, 206), new FlxPoint(126, 117), new FlxPoint(149, 119), new FlxPoint(151, 200), new FlxPoint(125, 230)];
		leftEarPolyArray[55] = [new FlxPoint(73, 206), new FlxPoint(126, 117), new FlxPoint(149, 119), new FlxPoint(151, 200), new FlxPoint(125, 230)];
		leftEarPolyArray[56] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[57] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[58] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[60] = [new FlxPoint(61, 152), new FlxPoint(109, 155), new FlxPoint(129, 194), new FlxPoint(150, 212), new FlxPoint(150, 254), new FlxPoint(75, 253)];
		leftEarPolyArray[61] = [new FlxPoint(61, 152), new FlxPoint(109, 155), new FlxPoint(129, 194), new FlxPoint(150, 212), new FlxPoint(150, 254), new FlxPoint(75, 253)];
		leftEarPolyArray[63] = [new FlxPoint(114, 134), new FlxPoint(128, 137), new FlxPoint(160, 131), new FlxPoint(156, 174), new FlxPoint(126, 223), new FlxPoint(73, 195)];
		leftEarPolyArray[64] = [new FlxPoint(114, 134), new FlxPoint(128, 137), new FlxPoint(160, 131), new FlxPoint(156, 174), new FlxPoint(126, 223), new FlxPoint(73, 195)];
		leftEarPolyArray[66] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];
		leftEarPolyArray[67] = [new FlxPoint(106, 158), new FlxPoint(127, 128), new FlxPoint(130, 137), new FlxPoint(138, 203), new FlxPoint(132, 227), new FlxPoint(97, 227)];

		rightEarPolyArray = new Array<Array<FlxPoint>>();
		rightEarPolyArray[0] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[1] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[2] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[3] = [new FlxPoint(214, 206), new FlxPoint(233, 185), new FlxPoint(253, 142), new FlxPoint(265, 150), new FlxPoint(264, 238), new FlxPoint(215, 212)];
		rightEarPolyArray[4] = [new FlxPoint(214, 206), new FlxPoint(233, 185), new FlxPoint(253, 142), new FlxPoint(265, 150), new FlxPoint(264, 238), new FlxPoint(215, 212)];
		rightEarPolyArray[5] = [new FlxPoint(214, 206), new FlxPoint(233, 185), new FlxPoint(253, 142), new FlxPoint(265, 150), new FlxPoint(264, 238), new FlxPoint(215, 212)];
		rightEarPolyArray[6] = [new FlxPoint(197, 126), new FlxPoint(225, 105), new FlxPoint(284, 229), new FlxPoint(206, 206), new FlxPoint(197, 177)];
		rightEarPolyArray[7] = [new FlxPoint(197, 126), new FlxPoint(225, 105), new FlxPoint(284, 229), new FlxPoint(206, 206), new FlxPoint(197, 177)];
		rightEarPolyArray[8] = [new FlxPoint(197, 126), new FlxPoint(225, 105), new FlxPoint(284, 229), new FlxPoint(206, 206), new FlxPoint(197, 177)];
		rightEarPolyArray[9] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[10] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[11] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[12] = [new FlxPoint(229, 197), new FlxPoint(239, 183), new FlxPoint(248, 152), new FlxPoint(271, 156), new FlxPoint(291, 240), new FlxPoint(233, 215)];
		rightEarPolyArray[13] = [new FlxPoint(229, 197), new FlxPoint(239, 183), new FlxPoint(248, 152), new FlxPoint(271, 156), new FlxPoint(291, 240), new FlxPoint(233, 215)];
		rightEarPolyArray[14] = [new FlxPoint(229, 197), new FlxPoint(239, 183), new FlxPoint(248, 152), new FlxPoint(271, 156), new FlxPoint(291, 240), new FlxPoint(233, 215)];
		rightEarPolyArray[18] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[19] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[20] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[21] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[22] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[23] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[24] = [new FlxPoint(203, 132), new FlxPoint(228, 140), new FlxPoint(250, 132), new FlxPoint(298, 202), new FlxPoint(280, 237), new FlxPoint(216, 192), new FlxPoint(204, 163)];
		rightEarPolyArray[25] = [new FlxPoint(203, 132), new FlxPoint(228, 140), new FlxPoint(250, 132), new FlxPoint(298, 202), new FlxPoint(280, 237), new FlxPoint(216, 192), new FlxPoint(204, 163)];
		rightEarPolyArray[26] = [new FlxPoint(203, 132), new FlxPoint(228, 140), new FlxPoint(250, 132), new FlxPoint(298, 202), new FlxPoint(280, 237), new FlxPoint(216, 192), new FlxPoint(204, 163)];
		rightEarPolyArray[27] = [new FlxPoint(214, 206), new FlxPoint(233, 185), new FlxPoint(253, 142), new FlxPoint(265, 150), new FlxPoint(264, 238), new FlxPoint(215, 212)];
		rightEarPolyArray[28] = [new FlxPoint(214, 206), new FlxPoint(233, 185), new FlxPoint(253, 142), new FlxPoint(265, 150), new FlxPoint(264, 238), new FlxPoint(215, 212)];
		rightEarPolyArray[29] = [new FlxPoint(214, 206), new FlxPoint(233, 185), new FlxPoint(253, 142), new FlxPoint(265, 150), new FlxPoint(264, 238), new FlxPoint(215, 212)];
		rightEarPolyArray[30] = [new FlxPoint(229, 197), new FlxPoint(239, 183), new FlxPoint(248, 152), new FlxPoint(271, 156), new FlxPoint(291, 240), new FlxPoint(233, 215)];
		rightEarPolyArray[31] = [new FlxPoint(229, 197), new FlxPoint(239, 183), new FlxPoint(248, 152), new FlxPoint(271, 156), new FlxPoint(291, 240), new FlxPoint(233, 215)];
		rightEarPolyArray[32] = [new FlxPoint(229, 197), new FlxPoint(239, 183), new FlxPoint(248, 152), new FlxPoint(271, 156), new FlxPoint(291, 240), new FlxPoint(233, 215)];
		rightEarPolyArray[33] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[34] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[35] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[39] = [new FlxPoint(197, 126), new FlxPoint(225, 105), new FlxPoint(284, 229), new FlxPoint(206, 206), new FlxPoint(197, 177)];
		rightEarPolyArray[40] = [new FlxPoint(197, 126), new FlxPoint(225, 105), new FlxPoint(284, 229), new FlxPoint(206, 206), new FlxPoint(197, 177)];
		rightEarPolyArray[41] = [new FlxPoint(197, 126), new FlxPoint(225, 105), new FlxPoint(284, 229), new FlxPoint(206, 206), new FlxPoint(197, 177)];
		rightEarPolyArray[42] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[43] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[44] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[48] = [new FlxPoint(203, 132), new FlxPoint(228, 140), new FlxPoint(250, 132), new FlxPoint(298, 202), new FlxPoint(280, 237), new FlxPoint(216, 192), new FlxPoint(204, 163)];
		rightEarPolyArray[49] = [new FlxPoint(203, 132), new FlxPoint(228, 140), new FlxPoint(250, 132), new FlxPoint(298, 202), new FlxPoint(280, 237), new FlxPoint(216, 192), new FlxPoint(204, 163)];
		rightEarPolyArray[50] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[51] = [new FlxPoint(229, 197), new FlxPoint(239, 183), new FlxPoint(248, 152), new FlxPoint(271, 156), new FlxPoint(291, 240), new FlxPoint(233, 215)];
		rightEarPolyArray[52] = [new FlxPoint(229, 197), new FlxPoint(239, 183), new FlxPoint(248, 152), new FlxPoint(271, 156), new FlxPoint(291, 240), new FlxPoint(233, 215)];
		rightEarPolyArray[53] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[54] = [new FlxPoint(214, 206), new FlxPoint(233, 185), new FlxPoint(253, 142), new FlxPoint(265, 150), new FlxPoint(264, 238), new FlxPoint(215, 212)];
		rightEarPolyArray[55] = [new FlxPoint(214, 206), new FlxPoint(233, 185), new FlxPoint(253, 142), new FlxPoint(265, 150), new FlxPoint(264, 238), new FlxPoint(215, 212)];
		rightEarPolyArray[56] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[57] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[58] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[60] = [new FlxPoint(197, 126), new FlxPoint(225, 105), new FlxPoint(284, 229), new FlxPoint(206, 206), new FlxPoint(197, 177)];
		rightEarPolyArray[61] = [new FlxPoint(197, 126), new FlxPoint(225, 105), new FlxPoint(284, 229), new FlxPoint(206, 206), new FlxPoint(197, 177)];
		rightEarPolyArray[66] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];
		rightEarPolyArray[67] = [new FlxPoint(226, 116), new FlxPoint(248, 127), new FlxPoint(273, 181), new FlxPoint(271, 224), new FlxPoint(231, 206)];

		leftHatPolyArray = new Array<Array<FlxPoint>>();
		leftHatPolyArray[0] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[1] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[2] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[3] = [new FlxPoint(196, 155), new FlxPoint(218, 89), new FlxPoint(225, 41), new FlxPoint(83, 43), new FlxPoint(84, 150)];
		leftHatPolyArray[4] = [new FlxPoint(196, 155), new FlxPoint(218, 89), new FlxPoint(225, 41), new FlxPoint(83, 43), new FlxPoint(84, 150)];
		leftHatPolyArray[5] = [new FlxPoint(196, 155), new FlxPoint(218, 89), new FlxPoint(225, 41), new FlxPoint(83, 43), new FlxPoint(84, 150)];
		leftHatPolyArray[6] = [new FlxPoint(112, 47), new FlxPoint(130, 91), new FlxPoint(148, 177), new FlxPoint(74, 177), new FlxPoint(61, 55)];
		leftHatPolyArray[7] = [new FlxPoint(112, 47), new FlxPoint(130, 91), new FlxPoint(148, 177), new FlxPoint(74, 177), new FlxPoint(61, 55)];
		leftHatPolyArray[8] = [new FlxPoint(112, 47), new FlxPoint(130, 91), new FlxPoint(148, 177), new FlxPoint(74, 177), new FlxPoint(61, 55)];
		leftHatPolyArray[9] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[10] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[11] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[12] = [new FlxPoint(145, 45), new FlxPoint(178, 64), new FlxPoint(220, 108), new FlxPoint(217, 153), new FlxPoint(84, 192), new FlxPoint(67, 48)];
		leftHatPolyArray[13] = [new FlxPoint(145, 45), new FlxPoint(178, 64), new FlxPoint(220, 108), new FlxPoint(217, 153), new FlxPoint(84, 192), new FlxPoint(67, 48)];
		leftHatPolyArray[14] = [new FlxPoint(145, 45), new FlxPoint(178, 64), new FlxPoint(220, 108), new FlxPoint(217, 153), new FlxPoint(84, 192), new FlxPoint(67, 48)];
		leftHatPolyArray[15] = [new FlxPoint(168, 43), new FlxPoint(181, 70), new FlxPoint(228, 95), new FlxPoint(241, 149), new FlxPoint(62, 158), new FlxPoint(62, 46)];
		leftHatPolyArray[16] = [new FlxPoint(168, 43), new FlxPoint(181, 70), new FlxPoint(228, 95), new FlxPoint(241, 149), new FlxPoint(62, 158), new FlxPoint(62, 46)];
		leftHatPolyArray[17] = [new FlxPoint(168, 43), new FlxPoint(181, 70), new FlxPoint(228, 95), new FlxPoint(241, 149), new FlxPoint(62, 158), new FlxPoint(62, 46)];
		leftHatPolyArray[18] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[19] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[20] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[24] = [new FlxPoint(190, 45), new FlxPoint(186, 69), new FlxPoint(137, 94), new FlxPoint(126, 153), new FlxPoint(78, 146), new FlxPoint(66, 51)];
		leftHatPolyArray[25] = [new FlxPoint(190, 45), new FlxPoint(186, 69), new FlxPoint(137, 94), new FlxPoint(126, 153), new FlxPoint(78, 146), new FlxPoint(66, 51)];
		leftHatPolyArray[26] = [new FlxPoint(190, 45), new FlxPoint(186, 69), new FlxPoint(137, 94), new FlxPoint(126, 153), new FlxPoint(78, 146), new FlxPoint(66, 51)];
		leftHatPolyArray[27] = [new FlxPoint(196, 155), new FlxPoint(218, 89), new FlxPoint(225, 41), new FlxPoint(83, 43), new FlxPoint(84, 150)];
		leftHatPolyArray[28] = [new FlxPoint(196, 155), new FlxPoint(218, 89), new FlxPoint(225, 41), new FlxPoint(83, 43), new FlxPoint(84, 150)];
		leftHatPolyArray[29] = [new FlxPoint(196, 155), new FlxPoint(218, 89), new FlxPoint(225, 41), new FlxPoint(83, 43), new FlxPoint(84, 150)];
		leftHatPolyArray[30] = [new FlxPoint(145, 45), new FlxPoint(178, 64), new FlxPoint(220, 108), new FlxPoint(217, 153), new FlxPoint(84, 192), new FlxPoint(67, 48)];
		leftHatPolyArray[31] = [new FlxPoint(145, 45), new FlxPoint(178, 64), new FlxPoint(220, 108), new FlxPoint(217, 153), new FlxPoint(84, 192), new FlxPoint(67, 48)];
		leftHatPolyArray[32] = [new FlxPoint(145, 45), new FlxPoint(178, 64), new FlxPoint(220, 108), new FlxPoint(217, 153), new FlxPoint(84, 192), new FlxPoint(67, 48)];
		leftHatPolyArray[33] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[34] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[35] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[36] = [new FlxPoint(168, 43), new FlxPoint(181, 70), new FlxPoint(228, 95), new FlxPoint(241, 149), new FlxPoint(62, 158), new FlxPoint(62, 46)];
		leftHatPolyArray[37] = [new FlxPoint(168, 43), new FlxPoint(181, 70), new FlxPoint(228, 95), new FlxPoint(241, 149), new FlxPoint(62, 158), new FlxPoint(62, 46)];
		leftHatPolyArray[38] = [new FlxPoint(168, 43), new FlxPoint(181, 70), new FlxPoint(228, 95), new FlxPoint(241, 149), new FlxPoint(62, 158), new FlxPoint(62, 46)];
		leftHatPolyArray[39] = [new FlxPoint(112, 47), new FlxPoint(130, 91), new FlxPoint(148, 177), new FlxPoint(74, 177), new FlxPoint(61, 55)];
		leftHatPolyArray[40] = [new FlxPoint(112, 47), new FlxPoint(130, 91), new FlxPoint(148, 177), new FlxPoint(74, 177), new FlxPoint(61, 55)];
		leftHatPolyArray[41] = [new FlxPoint(112, 47), new FlxPoint(130, 91), new FlxPoint(148, 177), new FlxPoint(74, 177), new FlxPoint(61, 55)];
		leftHatPolyArray[42] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[43] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[44] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[48] = [new FlxPoint(190, 45), new FlxPoint(186, 69), new FlxPoint(137, 94), new FlxPoint(126, 153), new FlxPoint(78, 146), new FlxPoint(66, 51)];
		leftHatPolyArray[49] = [new FlxPoint(190, 45), new FlxPoint(186, 69), new FlxPoint(137, 94), new FlxPoint(126, 153), new FlxPoint(78, 146), new FlxPoint(66, 51)];
		leftHatPolyArray[51] = [new FlxPoint(145, 45), new FlxPoint(178, 64), new FlxPoint(220, 108), new FlxPoint(217, 153), new FlxPoint(84, 192), new FlxPoint(67, 48)];
		leftHatPolyArray[52] = [new FlxPoint(145, 45), new FlxPoint(178, 64), new FlxPoint(220, 108), new FlxPoint(217, 153), new FlxPoint(84, 192), new FlxPoint(67, 48)];
		leftHatPolyArray[54] = [new FlxPoint(196, 155), new FlxPoint(218, 89), new FlxPoint(225, 41), new FlxPoint(83, 43), new FlxPoint(84, 150)];
		leftHatPolyArray[55] = [new FlxPoint(196, 155), new FlxPoint(218, 89), new FlxPoint(225, 41), new FlxPoint(83, 43), new FlxPoint(84, 150)];
		leftHatPolyArray[57] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[58] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[60] = [new FlxPoint(112, 47), new FlxPoint(130, 91), new FlxPoint(148, 177), new FlxPoint(74, 177), new FlxPoint(61, 55)];
		leftHatPolyArray[61] = [new FlxPoint(112, 47), new FlxPoint(130, 91), new FlxPoint(148, 177), new FlxPoint(74, 177), new FlxPoint(61, 55)];
		leftHatPolyArray[63] = [new FlxPoint(168, 43), new FlxPoint(181, 70), new FlxPoint(228, 95), new FlxPoint(241, 149), new FlxPoint(62, 158), new FlxPoint(62, 46)];
		leftHatPolyArray[64] = [new FlxPoint(168, 43), new FlxPoint(181, 70), new FlxPoint(228, 95), new FlxPoint(241, 149), new FlxPoint(62, 158), new FlxPoint(62, 46)];
		leftHatPolyArray[66] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];
		leftHatPolyArray[67] = [new FlxPoint(161, 45), new FlxPoint(177, 150), new FlxPoint(67, 196), new FlxPoint(68, 42)];

		vagPolyArray = new Array<Array<FlxPoint>>();
		vagPolyArray[0] = [new FlxPoint(204, 379), new FlxPoint(176, 380), new FlxPoint(174, 349), new FlxPoint(202, 348)];

		if (_male)
		{
			dickAngleArray[0] = [new FlxPoint(177, 375), new FlxPoint(87, 245), new FlxPoint(-87, 245)];
			dickAngleArray[1] = [new FlxPoint(155, 356), new FlxPoint(-216, 144), new FlxPoint(-260, 15)];
			dickAngleArray[2] = [new FlxPoint(148, 330), new FlxPoint(-240, -99), new FlxPoint(-138, -220)];
			dickAngleArray[3] = [new FlxPoint(152, 351), new FlxPoint(-251, 70), new FlxPoint(-258, -29)];
			dickAngleArray[4] = [new FlxPoint(154, 355), new FlxPoint(-220, 138), new FlxPoint(-258, 29)];
			dickAngleArray[5] = [new FlxPoint(156, 363), new FlxPoint(-204, 161), new FlxPoint(-251, 70)];
			dickAngleArray[8] = [new FlxPoint(154, 316), new FlxPoint(-14, -260), new FlxPoint(-122, -230)];
			dickAngleArray[9] = [new FlxPoint(149, 322), new FlxPoint(-99, -240), new FlxPoint(-190, -177)];
			dickAngleArray[10] = [new FlxPoint(149, 326), new FlxPoint(-214, -148), new FlxPoint(-110, -236)];
			dickAngleArray[11] = [new FlxPoint(150, 331), new FlxPoint(-233, -116), new FlxPoint(-151, -212)];
			dickAngleArray[12] = [new FlxPoint(144, 337), new FlxPoint(-253, -60), new FlxPoint(-208, -156)];
			dickAngleArray[13] = [new FlxPoint(145, 342), new FlxPoint( -260, -12), new FlxPoint( -233, -116)];

			dickVibeAngleArray[0] = [new FlxPoint(176, 374), new FlxPoint(109, 236), new FlxPoint(-153, 210)];
			dickVibeAngleArray[1] = [new FlxPoint(175, 373), new FlxPoint(197, 169), new FlxPoint(-230, 122)];
			dickVibeAngleArray[2] = [new FlxPoint(174, 374), new FlxPoint(97, 241), new FlxPoint(-260, -13)];
			dickVibeAngleArray[3] = [new FlxPoint(175, 373), new FlxPoint(224, 132), new FlxPoint(-251, 66)];
			dickVibeAngleArray[4] = [new FlxPoint(176, 374), new FlxPoint(252, 63), new FlxPoint(-126, 227)];
			dickVibeAngleArray[5] = [new FlxPoint(155, 356), new FlxPoint(-247, 82), new FlxPoint(-256, -45)];
			dickVibeAngleArray[6] = [new FlxPoint(155, 356), new FlxPoint(-175, 192), new FlxPoint(-204, -161)];
			dickVibeAngleArray[7] = [new FlxPoint(154, 356), new FlxPoint(-166, 200), new FlxPoint(-127, -227)];
			dickVibeAngleArray[8] = [new FlxPoint(157, 357), new FlxPoint(66, 251), new FlxPoint(-251, -66)];
			dickVibeAngleArray[9] = [new FlxPoint(154, 353), new FlxPoint(-111, -235), new FlxPoint(-126, 227)];
			dickVibeAngleArray[10] = [new FlxPoint(149, 332), new FlxPoint(-144, -216), new FlxPoint(-196, -170)];
			dickVibeAngleArray[11] = [new FlxPoint(149, 332), new FlxPoint(-25, -259), new FlxPoint(-260, 0)];
			dickVibeAngleArray[12] = [new FlxPoint(147, 331), new FlxPoint(-111, -235), new FlxPoint(-116, 233)];
			dickVibeAngleArray[13] = [new FlxPoint(150, 331), new FlxPoint(156, -208), new FlxPoint(-254, -56)];
			dickVibeAngleArray[14] = [new FlxPoint(149, 331), new FlxPoint(121, -230), new FlxPoint( -260, 0)];

			electricPolyArray = new Array<Array<FlxPoint>>();
			electricPolyArray[0] = [new FlxPoint(162, 340), new FlxPoint(160, 363), new FlxPoint(202, 368), new FlxPoint(204, 341)];
			electricPolyArray[1] = [new FlxPoint(162, 340), new FlxPoint(160, 363), new FlxPoint(202, 368), new FlxPoint(204, 341)];
			electricPolyArray[2] = [new FlxPoint(162, 340), new FlxPoint(160, 363), new FlxPoint(202, 368), new FlxPoint(204, 341)];
			electricPolyArray[3] = [new FlxPoint(162, 340), new FlxPoint(160, 363), new FlxPoint(202, 368), new FlxPoint(204, 341)];
			electricPolyArray[4] = [new FlxPoint(162, 340), new FlxPoint(160, 363), new FlxPoint(202, 368), new FlxPoint(204, 341)];
			electricPolyArray[5] = [new FlxPoint(158, 342), new FlxPoint(160, 357), new FlxPoint(192, 363), new FlxPoint(200, 342)];
			electricPolyArray[6] = [new FlxPoint(158, 342), new FlxPoint(160, 357), new FlxPoint(192, 363), new FlxPoint(200, 342)];
			electricPolyArray[7] = [new FlxPoint(158, 342), new FlxPoint(160, 357), new FlxPoint(192, 363), new FlxPoint(200, 342)];
			electricPolyArray[8] = [new FlxPoint(158, 342), new FlxPoint(160, 357), new FlxPoint(192, 363), new FlxPoint(200, 342)];
			electricPolyArray[9] = [new FlxPoint(158, 342), new FlxPoint(160, 357), new FlxPoint(192, 363), new FlxPoint(200, 342)];
			electricPolyArray[10] = [new FlxPoint(158, 333), new FlxPoint(152, 348), new FlxPoint(186, 354), new FlxPoint(192, 334)];
			electricPolyArray[11] = [new FlxPoint(158, 333), new FlxPoint(152, 348), new FlxPoint(186, 354), new FlxPoint(192, 334)];
			electricPolyArray[12] = [new FlxPoint(158, 333), new FlxPoint(152, 348), new FlxPoint(186, 354), new FlxPoint(192, 334)];
			electricPolyArray[13] = [new FlxPoint(158, 333), new FlxPoint(152, 348), new FlxPoint(186, 354), new FlxPoint(192, 334)];
			electricPolyArray[14] = [new FlxPoint(158, 333), new FlxPoint(152, 348), new FlxPoint(186, 354), new FlxPoint(192, 334)];
		}
		else {
			dickAngleArray[0] = [new FlxPoint(184, 364), new FlxPoint(19, 259), new FlxPoint(-102, 239)];
			dickAngleArray[1] = [new FlxPoint(184, 362), new FlxPoint(196, 171), new FlxPoint(-197, 169)];
			dickAngleArray[2] = [new FlxPoint(184, 362), new FlxPoint(213, 149), new FlxPoint(-196, 171)];
			dickAngleArray[3] = [new FlxPoint(184, 362), new FlxPoint(229, 122), new FlxPoint(-241, 97)];
			dickAngleArray[4] = [new FlxPoint(184, 362), new FlxPoint(210, 153), new FlxPoint(-194, 173)];
			dickAngleArray[5] = [new FlxPoint(184, 362), new FlxPoint(169, 197), new FlxPoint(-138, 220)];
			dickAngleArray[8] = [new FlxPoint(184, 362), new FlxPoint(184, 184), new FlxPoint(-205, 160)];
			dickAngleArray[9] = [new FlxPoint(184, 362), new FlxPoint(200, 166), new FlxPoint(-233, 116)];
			dickAngleArray[10] = [new FlxPoint(184, 362), new FlxPoint(220, 138), new FlxPoint(-241, 97)];
			dickAngleArray[11] = [new FlxPoint(184, 362), new FlxPoint(227, 126), new FlxPoint(-247, 82)];
			dickAngleArray[12] = [new FlxPoint(184, 362), new FlxPoint(238, 104), new FlxPoint( -252, 65)];

			dickVibeAngleArray[0] = [new FlxPoint(184, 363), new FlxPoint(206, 159), new FlxPoint(-198, 168)];
			dickVibeAngleArray[1] = [new FlxPoint(184, 362), new FlxPoint(192, 176), new FlxPoint(-191, 176)];
			dickVibeAngleArray[2] = [new FlxPoint(184, 360), new FlxPoint(200, 166), new FlxPoint(-256, 48)];
			dickVibeAngleArray[3] = [new FlxPoint(184, 359), new FlxPoint(162, 203), new FlxPoint(-243, 91)];
			dickVibeAngleArray[4] = [new FlxPoint(185, 359), new FlxPoint(245, 87), new FlxPoint(-151, 212)];
			dickVibeAngleArray[5] = [new FlxPoint(185, 361), new FlxPoint(260, 0), new FlxPoint( -141, 218)];

			electricPolyArray = new Array<Array<FlxPoint>>();
			electricPolyArray[0] = [new FlxPoint(178, 354), new FlxPoint(178, 374), new FlxPoint(200, 376), new FlxPoint(200, 356)];
			electricPolyArray[1] = [new FlxPoint(178, 354), new FlxPoint(178, 374), new FlxPoint(200, 376), new FlxPoint(200, 356)];
			electricPolyArray[2] = [new FlxPoint(178, 354), new FlxPoint(178, 374), new FlxPoint(200, 376), new FlxPoint(200, 356)];
			electricPolyArray[3] = [new FlxPoint(178, 354), new FlxPoint(178, 374), new FlxPoint(200, 376), new FlxPoint(200, 356)];
			electricPolyArray[4] = [new FlxPoint(178, 354), new FlxPoint(178, 374), new FlxPoint(200, 376), new FlxPoint(200, 356)];
			electricPolyArray[5] = [new FlxPoint(178, 354), new FlxPoint(178, 374), new FlxPoint(200, 376), new FlxPoint(200, 356)];
		}

		breathAngleArray[0] = [new FlxPoint(180, 222), new FlxPoint(8, 80)];
		breathAngleArray[1] = [new FlxPoint(180, 222), new FlxPoint(8, 80)];
		breathAngleArray[2] = [new FlxPoint(180, 222), new FlxPoint(8, 80)];
		breathAngleArray[3] = [new FlxPoint(178, 231), new FlxPoint(-15, 79)];
		breathAngleArray[4] = [new FlxPoint(178, 231), new FlxPoint(-15, 79)];
		breathAngleArray[5] = [new FlxPoint(178, 231), new FlxPoint(-15, 79)];
		breathAngleArray[6] = [new FlxPoint(161, 239), new FlxPoint(12, 79)];
		breathAngleArray[7] = [new FlxPoint(161, 239), new FlxPoint(12, 79)];
		breathAngleArray[8] = [new FlxPoint(161, 239), new FlxPoint(12, 79)];
		breathAngleArray[9] = [new FlxPoint(179, 217), new FlxPoint(3, 80)];
		breathAngleArray[10] = [new FlxPoint(179, 217), new FlxPoint(3, 80)];
		breathAngleArray[11] = [new FlxPoint(179, 217), new FlxPoint(3, 80)];
		breathAngleArray[12] = [new FlxPoint(237, 219), new FlxPoint(37, 71)];
		breathAngleArray[13] = [new FlxPoint(237, 219), new FlxPoint(37, 71)];
		breathAngleArray[14] = [new FlxPoint(237, 219), new FlxPoint(37, 71)];
		breathAngleArray[15] = [new FlxPoint(271, 199), new FlxPoint(57, 57)];
		breathAngleArray[16] = [new FlxPoint(271, 199), new FlxPoint(57, 57)];
		breathAngleArray[17] = [new FlxPoint(271, 199), new FlxPoint(57, 57)];
		breathAngleArray[18] = [new FlxPoint(187, 228), new FlxPoint(9, 80)];
		breathAngleArray[19] = [new FlxPoint(187, 228), new FlxPoint(9, 80)];
		breathAngleArray[20] = [new FlxPoint(187, 228), new FlxPoint(9, 80)];
		breathAngleArray[24] = [new FlxPoint(93, 196), new FlxPoint(-80, 5)];
		breathAngleArray[25] = [new FlxPoint(93, 196), new FlxPoint(-80, 5)];
		breathAngleArray[26] = [new FlxPoint(93, 196), new FlxPoint(-80, 5)];
		breathAngleArray[27] = [new FlxPoint(192, 228), new FlxPoint(4, 80)];
		breathAngleArray[28] = [new FlxPoint(192, 228), new FlxPoint(4, 80)];
		breathAngleArray[29] = [new FlxPoint(192, 228), new FlxPoint(4, 80)];
		breathAngleArray[30] = [new FlxPoint(224, 218), new FlxPoint(43, 68)];
		breathAngleArray[31] = [new FlxPoint(224, 218), new FlxPoint(43, 68)];
		breathAngleArray[32] = [new FlxPoint(224, 218), new FlxPoint(43, 68)];
		breathAngleArray[36] = [new FlxPoint(258, 189), new FlxPoint(79, 9)];
		breathAngleArray[37] = [new FlxPoint(258, 189), new FlxPoint(79, 9)];
		breathAngleArray[38] = [new FlxPoint(258, 189), new FlxPoint(79, 9)];
		breathAngleArray[39] = [new FlxPoint(157, 230), new FlxPoint(-18, 78)];
		breathAngleArray[40] = [new FlxPoint(157, 230), new FlxPoint(-18, 78)];
		breathAngleArray[41] = [new FlxPoint(157, 230), new FlxPoint(-18, 78)];
		breathAngleArray[42] = [new FlxPoint(182, 228), new FlxPoint(6, 80)];
		breathAngleArray[43] = [new FlxPoint(182, 228), new FlxPoint(6, 80)];
		breathAngleArray[44] = [new FlxPoint(182, 228), new FlxPoint(6, 80)];
		breathAngleArray[48] = [new FlxPoint(93, 191), new FlxPoint(-80, -2)];
		breathAngleArray[49] = [new FlxPoint(93, 191), new FlxPoint(-80, -2)];
		breathAngleArray[51] = [new FlxPoint(237, 218), new FlxPoint(68, 41)];
		breathAngleArray[52] = [new FlxPoint(237, 218), new FlxPoint(68, 41)];
		breathAngleArray[54] = [new FlxPoint(189, 237), new FlxPoint(8, 80)];
		breathAngleArray[55] = [new FlxPoint(189, 237), new FlxPoint(8, 80)];
		breathAngleArray[60] = [new FlxPoint(141, 224), new FlxPoint(-57, 57)];
		breathAngleArray[61] = [new FlxPoint(141, 224), new FlxPoint(-57, 57)];
		breathAngleArray[63] = [new FlxPoint(260, 193), new FlxPoint(80, 2)];
		breathAngleArray[64] = [new FlxPoint(260, 193), new FlxPoint(80, 2)];
		breathAngleArray[66] = [new FlxPoint(182, 225), new FlxPoint(3, 80)];
		breathAngleArray[67] = [new FlxPoint(182, 225), new FlxPoint(3, 80)];

		headSweatArray = new Array<Array<FlxPoint>>();
		headSweatArray[0] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[1] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[2] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[3] = [new FlxPoint(169, 137), new FlxPoint(228, 149), new FlxPoint(225, 199), new FlxPoint(155, 181)];
		headSweatArray[4] = [new FlxPoint(169, 137), new FlxPoint(228, 149), new FlxPoint(225, 199), new FlxPoint(155, 181)];
		headSweatArray[5] = [new FlxPoint(169, 137), new FlxPoint(228, 149), new FlxPoint(225, 199), new FlxPoint(155, 181)];
		headSweatArray[6] = [new FlxPoint(127, 166), new FlxPoint(171, 151), new FlxPoint(201, 188), new FlxPoint(137, 204), new FlxPoint(128, 195)];
		headSweatArray[7] = [new FlxPoint(127, 166), new FlxPoint(171, 151), new FlxPoint(201, 188), new FlxPoint(137, 204), new FlxPoint(128, 195)];
		headSweatArray[8] = [new FlxPoint(127, 166), new FlxPoint(171, 151), new FlxPoint(201, 188), new FlxPoint(137, 204), new FlxPoint(128, 195)];
		headSweatArray[9] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[10] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[11] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[12] = [new FlxPoint(178, 124), new FlxPoint(240, 123), new FlxPoint(249, 160), new FlxPoint(243, 177), new FlxPoint(183, 183), new FlxPoint(186, 155)];
		headSweatArray[13] = [new FlxPoint(178, 124), new FlxPoint(240, 123), new FlxPoint(249, 160), new FlxPoint(243, 177), new FlxPoint(183, 183), new FlxPoint(186, 155)];
		headSweatArray[14] = [new FlxPoint(178, 124), new FlxPoint(240, 123), new FlxPoint(249, 160), new FlxPoint(243, 177), new FlxPoint(183, 183), new FlxPoint(186, 155)];
		headSweatArray[15] = [new FlxPoint(201, 130), new FlxPoint(249, 125), new FlxPoint(258, 162), new FlxPoint(202, 175)];
		headSweatArray[16] = [new FlxPoint(201, 130), new FlxPoint(249, 125), new FlxPoint(258, 162), new FlxPoint(202, 175)];
		headSweatArray[17] = [new FlxPoint(201, 130), new FlxPoint(249, 125), new FlxPoint(258, 162), new FlxPoint(202, 175)];
		headSweatArray[18] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[19] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[20] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[21] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[22] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[23] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[24] = [new FlxPoint(111, 125), new FlxPoint(160, 128), new FlxPoint(156, 150), new FlxPoint(163, 173), new FlxPoint(103, 170), new FlxPoint(101, 148)];
		headSweatArray[25] = [new FlxPoint(111, 125), new FlxPoint(160, 128), new FlxPoint(156, 150), new FlxPoint(163, 173), new FlxPoint(103, 170), new FlxPoint(101, 148)];
		headSweatArray[26] = [new FlxPoint(111, 125), new FlxPoint(160, 128), new FlxPoint(156, 150), new FlxPoint(163, 173), new FlxPoint(103, 170), new FlxPoint(101, 148)];
		headSweatArray[27] = [new FlxPoint(169, 137), new FlxPoint(228, 149), new FlxPoint(225, 199), new FlxPoint(155, 181)];
		headSweatArray[28] = [new FlxPoint(169, 137), new FlxPoint(228, 149), new FlxPoint(225, 199), new FlxPoint(155, 181)];
		headSweatArray[29] = [new FlxPoint(169, 137), new FlxPoint(228, 149), new FlxPoint(225, 199), new FlxPoint(155, 181)];
		headSweatArray[30] = [new FlxPoint(178, 124), new FlxPoint(240, 123), new FlxPoint(249, 160), new FlxPoint(243, 177), new FlxPoint(183, 183), new FlxPoint(186, 155)];
		headSweatArray[31] = [new FlxPoint(178, 124), new FlxPoint(240, 123), new FlxPoint(249, 160), new FlxPoint(243, 177), new FlxPoint(183, 183), new FlxPoint(186, 155)];
		headSweatArray[32] = [new FlxPoint(178, 124), new FlxPoint(240, 123), new FlxPoint(249, 160), new FlxPoint(243, 177), new FlxPoint(183, 183), new FlxPoint(186, 155)];
		headSweatArray[33] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[34] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[35] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[36] = [new FlxPoint(201, 130), new FlxPoint(249, 125), new FlxPoint(258, 162), new FlxPoint(202, 175)];
		headSweatArray[37] = [new FlxPoint(201, 130), new FlxPoint(249, 125), new FlxPoint(258, 162), new FlxPoint(202, 175)];
		headSweatArray[38] = [new FlxPoint(201, 130), new FlxPoint(249, 125), new FlxPoint(258, 162), new FlxPoint(202, 175)];
		headSweatArray[39] = [new FlxPoint(127, 166), new FlxPoint(171, 151), new FlxPoint(201, 188), new FlxPoint(137, 204), new FlxPoint(128, 195)];
		headSweatArray[40] = [new FlxPoint(127, 166), new FlxPoint(171, 151), new FlxPoint(201, 188), new FlxPoint(137, 204), new FlxPoint(128, 195)];
		headSweatArray[41] = [new FlxPoint(127, 166), new FlxPoint(171, 151), new FlxPoint(201, 188), new FlxPoint(137, 204), new FlxPoint(128, 195)];
		headSweatArray[42] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[43] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[44] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[48] = [new FlxPoint(111, 125), new FlxPoint(160, 128), new FlxPoint(156, 150), new FlxPoint(163, 173), new FlxPoint(103, 170), new FlxPoint(101, 148)];
		headSweatArray[49] = [new FlxPoint(111, 125), new FlxPoint(160, 128), new FlxPoint(156, 150), new FlxPoint(163, 173), new FlxPoint(103, 170), new FlxPoint(101, 148)];
		headSweatArray[50] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[51] = [new FlxPoint(178, 124), new FlxPoint(240, 123), new FlxPoint(249, 160), new FlxPoint(243, 177), new FlxPoint(183, 183), new FlxPoint(186, 155)];
		headSweatArray[52] = [new FlxPoint(178, 124), new FlxPoint(240, 123), new FlxPoint(249, 160), new FlxPoint(243, 177), new FlxPoint(183, 183), new FlxPoint(186, 155)];
		headSweatArray[53] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[54] = [new FlxPoint(169, 137), new FlxPoint(228, 149), new FlxPoint(225, 199), new FlxPoint(155, 181)];
		headSweatArray[55] = [new FlxPoint(169, 137), new FlxPoint(228, 149), new FlxPoint(225, 199), new FlxPoint(155, 181)];
		headSweatArray[56] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[57] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[58] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[60] = [new FlxPoint(127, 166), new FlxPoint(171, 151), new FlxPoint(201, 188), new FlxPoint(137, 204), new FlxPoint(128, 195)];
		headSweatArray[61] = [new FlxPoint(127, 166), new FlxPoint(171, 151), new FlxPoint(201, 188), new FlxPoint(137, 204), new FlxPoint(128, 195)];
		headSweatArray[63] = [new FlxPoint(201, 130), new FlxPoint(249, 125), new FlxPoint(258, 162), new FlxPoint(202, 175)];
		headSweatArray[64] = [new FlxPoint(201, 130), new FlxPoint(249, 125), new FlxPoint(258, 162), new FlxPoint(202, 175)];
		headSweatArray[66] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];
		headSweatArray[67] = [new FlxPoint(149, 125), new FlxPoint(207, 119), new FlxPoint(217, 170), new FlxPoint(145, 180)];

		torsoSweatArray = new Array<Array<FlxPoint>>();
		torsoSweatArray[0] = [new FlxPoint(157, 222), new FlxPoint(219, 218), new FlxPoint(230, 288), new FlxPoint(205, 345), new FlxPoint(158, 340), new FlxPoint(148, 284)];

		encouragementWords = wordManager.newWords();
		encouragementWords.words.push([ { graphic:AssetPaths.smear_words_small__png, frame:0 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.smear_words_small__png, frame:1 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.smear_words_small__png, frame:2 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.smear_words_small__png, frame:3 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.smear_words_small__png, frame:4 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.smear_words_small__png, frame:5 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.smear_words_small__png, frame:6 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.smear_words_small__png, frame:7 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.smear_words_small__png, frame:8 } ]);

		pleasureWords = wordManager.newWords(8);
		pleasureWords.words.push([{graphic:AssetPaths.smear_words_medium__png, height:48, chunkSize:5, frame:0}]);
		pleasureWords.words.push([{graphic:AssetPaths.smear_words_medium__png, height:48, chunkSize:5, frame:1}]);
		pleasureWords.words.push([{graphic:AssetPaths.smear_words_medium__png, height:48, chunkSize:5, frame:2}]);
		pleasureWords.words.push([{graphic:AssetPaths.smear_words_medium__png, height:48, chunkSize:5, frame:3}]);
		pleasureWords.words.push([{graphic:AssetPaths.smear_words_medium__png, height:48, chunkSize:5, frame:4}]);
		pleasureWords.words.push([{graphic:AssetPaths.smear_words_medium__png, height:48, chunkSize:5, frame:5}]);
		pleasureWords.words.push([{graphic:AssetPaths.smear_words_medium__png, height:48, chunkSize:5, frame:6}]);
		pleasureWords.words.push([{graphic:AssetPaths.smear_words_medium__png, height:48, chunkSize:5, frame:7}]);
		pleasureWords.words.push([{graphic:AssetPaths.smear_words_medium__png, height:48, chunkSize:5, frame:8}]);

		almostWords = wordManager.newWords(30);
		almostWords.words.push([ // i... i think i might...
		{ graphic:AssetPaths.smear_words_medium__png, frame:9, height:48, chunkSize:5 },
		{ graphic:AssetPaths.smear_words_medium__png, frame:11, height:48, chunkSize:5, yOffset:26, delay:1.0 }
		]);
		almostWords.words.push([ // it... it feels like i'm...
		{ graphic:AssetPaths.smear_words_medium__png, frame:10, height:48, chunkSize:5 },
		{ graphic:AssetPaths.smear_words_medium__png, frame:12, height:48, chunkSize:5, yOffset:26, delay:0.8 }
		]);
		almostWords.words.push([ // ooh, i... i feel something...
		{ graphic:AssetPaths.smear_words_medium__png, frame:13, height:48, chunkSize:5 },
		{ graphic:AssetPaths.smear_words_medium__png, frame:15, height:48, chunkSize:5, yOffset:28, delay:1.0 },
		{ graphic:AssetPaths.smear_words_medium__png, frame:17, height:48, chunkSize:5, yOffset:52, delay:1.6 }
		]);
		almostWords.words.push([ // harf@@@ i... i think it's...
		{ graphic:AssetPaths.smear_words_medium__png, frame:14, height:48, chunkSize:5 },
		{ graphic:AssetPaths.smear_words_medium__png, frame:16, height:48, chunkSize:5, yOffset:26, delay:1.2 }
		]);

		boredWords = wordManager.newWords(6);
		boredWords.words.push([{ graphic:AssetPaths.smear_words_small__png, frame:9 }]);
		boredWords.words.push([{ graphic:AssetPaths.smear_words_small__png, frame:10 }]);
		boredWords.words.push([{ graphic:AssetPaths.smear_words_small__png, frame:11 }]);
		// why did you stop?
		boredWords.words.push([
		{ graphic:AssetPaths.smear_words_small__png, frame:12 },
		{ graphic:AssetPaths.smear_words_small__png, frame:14, yOffset:22, delay:0.5 }
		]);
		// am i doing it wrong?
		boredWords.words.push([
		{ graphic:AssetPaths.smear_words_small__png, frame:13 },
		{ graphic:AssetPaths.smear_words_small__png, frame:15, yOffset:26, delay:0.5 },
		{ graphic:AssetPaths.smear_words_small__png, frame:17, yOffset:46, delay:1.0 }
		]);

		if (computeBonusToyCapacity() == 0)
		{
			// oh! okay, i can give it a try...
			toyStartWords.words.push([
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:0},
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:2, yOffset:20, delay:0.6 },
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:4, yOffset:38, delay:1.2 },
			]);
			// a vibrator, hmmm?  ...hmmmmmm...
			toyStartWords.words.push([
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:1},
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:3, yOffset:20, delay:0.6 },
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:5, yOffset:40, delay:1.9 },
			]);
		}
		else {
			// oh, sure! let's shake things up~
			toyStartWords.words.push([
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:6},
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:8, yOffset:20, delay:1.3 },
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:10, yOffset:40, delay:2.1 },
			]);
			// oooh a vibrator!! that's a super nice one, too~
			toyStartWords.words.push([
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:7},
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:9, yOffset:20, delay:0.6 },
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:11, yOffset:40, delay:1.8 },
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:13, yOffset:60, delay:2.6 },
			]);
		}

		// i think you're supposed to press the buttons!
		toyInterruptWords.words.push([
		{ graphic:AssetPaths.smear_vibe_words_small__png, frame:12},
		{ graphic:AssetPaths.smear_vibe_words_small__png, frame:14, yOffset:20, delay:0.7},
		{ graphic:AssetPaths.smear_vibe_words_small__png, frame:16, yOffset:40, delay:1.2},
		{ graphic:AssetPaths.smear_vibe_words_small__png, frame:18, yOffset:59, delay:1.9},
		]);
		// ...does it need batteries?
		toyInterruptWords.words.push([
		{ graphic:AssetPaths.smear_vibe_words_small__png, frame:15},
		{ graphic:AssetPaths.smear_vibe_words_small__png, frame:17, yOffset:20, delay:0.8},
		]);

		toyStopWords = wordManager.newWords();
		if (computeBonusToyCapacity() == 0)
		{
			// mooore puppy rubs!! gwarf@
			toyStopWords.words.push([
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:19},
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:21, yOffset:24, delay:1.0},
			]);
			// hmm! ...what's next?
			toyStopWords.words.push([
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:20},
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:22, yOffset:24, delay:1.1},
			]);
		}
		else {
			// hwaarf~ that was so good...
			toyStopWords.words.push([
			{ graphic:AssetPaths.smear_vibe_words_small__png, chunkSize:5, frame:23},
			{ graphic:AssetPaths.smear_vibe_words_small__png, chunkSize:5, frame:25, yOffset:16, delay:0.9},
			]);
			// ...wow... we need to get one of those~
			toyStopWords.words.push([
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:24},
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:26, yOffset:20, delay:0.8},
			{ graphic:AssetPaths.smear_vibe_words_small__png, frame:28, yOffset:41, delay:1.6},
			]);
		}

		orgasmWords = wordManager.newWords();
		orgasmWords.words.push([ { graphic:AssetPaths.smear_words_large__png, frame:0, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.smear_words_large__png, frame:1, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.smear_words_large__png, frame:2, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.smear_words_large__png, frame:4, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ // -arf! -GRRrrarf
		{ graphic:AssetPaths.smear_words_large__png, frame:3, width:200, height:150, yOffset:-30, chunkSize:7 },
		{ graphic:AssetPaths.smear_words_large__png, frame:5, width:200, height:150, yOffset:-30, chunkSize:7, delay:0.3 }
		]);

		tongueWords	= wordManager.newWords();
		tongueWords.words.push([{ graphic:AssetPaths.smear_words_small__png, frame:16 }]);
		tongueWords.words.push([{ graphic:AssetPaths.smear_words_small__png, frame:18 }]);
		tongueWords.words.push([{ graphic:AssetPaths.smear_words_small__png, frame:19 }]);

		fasterHatWords = wordManager.newWords(20);
		fasterHatWords.words.push([{ graphic:AssetPaths.smear_words_small__png, frame:20 }]);
		fasterHatWords.words.push([{ graphic:AssetPaths.smear_words_small__png, frame:22 }]);
		// ohh i LOVE@ scritches~
		fasterHatWords.words.push([
		{ graphic:AssetPaths.smear_words_small__png, frame:21 },
		{ graphic:AssetPaths.smear_words_small__png, frame:23, yOffset:26, delay:0.7 }]);

		bellyRubWords = wordManager.newWords(30);
		// maybe a belly rub...?
		bellyRubWords.words.push([
		{ graphic:AssetPaths.smear_words_small__png, frame:24 },
		{ graphic:AssetPaths.smear_words_small__png, frame:26, yOffset:24, delay:0.7 }]);
		// maybe hmmm.... a belly rub...?
		bellyRubWords.words.push([
		{ graphic:AssetPaths.smear_words_small__png, frame:24 },
		{ graphic:AssetPaths.smear_words_small__png, frame:29, yOffset:20, delay:0.7 },
		{ graphic:AssetPaths.smear_words_small__png, frame:26, yOffset:48, delay:1.9 }]);
		// maybe oh, i dunno a belly rub...?
		bellyRubWords.words.push([
		{ graphic:AssetPaths.smear_words_small__png, frame:24 },
		{ graphic:AssetPaths.smear_words_small__png, frame:31, yOffset:22, delay:0.7 },
		{ graphic:AssetPaths.smear_words_small__png, frame:26, yOffset:50, delay:1.9 }]);

		earRubWords = wordManager.newWords(30);
		// how about my ears?
		earRubWords.words.push([
		{ graphic:AssetPaths.smear_words_small__png, frame:25 },
		{ graphic:AssetPaths.smear_words_small__png, frame:27, yOffset:24, delay:0.7 }]);
		// how about hmmm.... my ears?
		earRubWords.words.push([
		{ graphic:AssetPaths.smear_words_small__png, frame:25 },
		{ graphic:AssetPaths.smear_words_small__png, frame:29, yOffset:20, delay:0.7 },
		{ graphic:AssetPaths.smear_words_small__png, frame:27, yOffset:48, delay:1.9 }]);
		// how about oh, i dunno my ears?
		earRubWords.words.push([
		{ graphic:AssetPaths.smear_words_small__png, frame:25 },
		{ graphic:AssetPaths.smear_words_small__png, frame:31, yOffset:22, delay:0.7 },
		{ graphic:AssetPaths.smear_words_small__png, frame:27, yOffset:48, delay:1.9 }]);

		thighRubWords = wordManager.newWords(30);
		// ...my thighs can sometimes, oh, i dunno
		thighRubWords.words.push([
		{ graphic:AssetPaths.smear_words_small__png, frame:28 },
		{ graphic:AssetPaths.smear_words_small__png, frame:30, yOffset:24, delay:0.7 },
		{ graphic:AssetPaths.smear_words_small__png, frame:31, yOffset:44, delay:1.9 }]);
		// ...my thighs can sometimes, hmmm....
		thighRubWords.words.push([
		{ graphic:AssetPaths.smear_words_small__png, frame:28 },
		{ graphic:AssetPaths.smear_words_small__png, frame:30, yOffset:26, delay:0.7 },
		{ graphic:AssetPaths.smear_words_small__png, frame:29, yOffset:44, delay:1.9 }]);
	}

	override public function shouldOrgasm():Bool
	{
		var pct:Float = _heartBank.getDickPercent();
		if (PlayerData.pokemonLibido == 1 && specialRub == "hat")
		{
			pct = Math.pow(_heartBank._dickHeartReservoir / _heartBank._dickHeartReservoirCapacity, 0.5);
		}
		return pct <= _cumThreshold && _remainingOrgasms > 0;
	}

	override public function determineArousal():Int
	{
		var pct:Float = (_heartBank._dickHeartReservoir + _heartBank._foreplayHeartReservoir) / (_heartBank._dickHeartReservoirCapacity + _heartBank._foreplayHeartReservoirCapacity);
		var baseArousal:Int = 0;
		if (pct < 0.55 || _heartBank.getDickPercent() < _cumThreshold + 0.2)
		{
			baseArousal = _pokeWindow._vibe.vibeSfx.isVibratorOn() ? 4 : 4;
		}
		else if (pct < 0.67)
		{
			baseArousal = _pokeWindow._vibe.vibeSfx.isVibratorOn() ? 4 : 3;
		}
		else if (pct < 0.82)
		{
			baseArousal = _pokeWindow._vibe.vibeSfx.isVibratorOn() ? 3 : 2;
		}
		else if (_heartBank._foreplayHeartReservoir < _heartBank._foreplayHeartReservoirCapacity)
		{
			baseArousal = _pokeWindow._vibe.vibeSfx.isVibratorOn() ? 2 : 1;
		}
		else {
			baseArousal = _pokeWindow._vibe.vibeSfx.isVibratorOn() ? 1 : 0;
		}
		return Std.int(FlxMath.bound(baseArousal - dislikedRubCombo, 0, 5));
	}

	override public function checkSpecialRub(touchedPart:FlxSprite)
	{
		if (_fancyRub)
		{
			if (_rubHandAnim._flxSprite.animation.name == "rub-balls")
			{
				specialRub = "balls";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "jack-off")
			{
				specialRub = "jack-off";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-dick")
			{
				specialRub = "rub-dick";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "scritchhat-c" || _rubHandAnim._flxSprite.animation.name == "palmhat-c")
			{
				specialRub = "hat";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-left-foot0"
					 || _rubHandAnim._flxSprite.animation.name == "rub-left-foot1"
					 || _rubHandAnim._flxSprite.animation.name == "rub-left-foot2")
			{
				specialRub = "left-foot";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-right-foot0"
					 || _rubHandAnim._flxSprite.animation.name == "rub-right-foot1"
					 || _rubHandAnim._flxSprite.animation.name == "rub-right-foot2")
			{
				specialRub = "right-foot";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "pull-tongue")
			{
				specialRub = "tongue";
			}
		}
		else
		{
			if (touchedPart == _pokeWindow._arms0 || touchedPart == _pokeWindow._arms1 || touchedPart == _pokeWindow._arms2)
			{
				if (clickedPolygon(touchedPart, leftArmPolyArray))
				{
					specialRub = "left-arm";
				}
				else
				{
					specialRub = "right-arm";
				}
			}
			else if (touchedPart == _head)
			{
				if (clickedPolygon(touchedPart, leftEarPolyArray))
				{
					specialRub = "left-ear";
				}
				else if (clickedPolygon(touchedPart, rightEarPolyArray))
				{
					specialRub = "right-ear";
				}
				else
				{
					specialRub = "head";
				}
			}
			else if (touchedPart == _pokeWindow._torso0)
			{
				specialRub = "belly";
			}
			else if (touchedPart == _pokeWindow._torso1)
			{
				specialRub = "chest";
			}
			else if (touchedPart == _pokeWindow._neck)
			{
				specialRub = "neck";
			}
			else if (touchedPart == _pokeWindow._legs1)
			{
				if (clickedPolygon(touchedPart, leftLegPolyArray))
				{
					specialRub = "left-foreleg";
				}
				else
				{
					specialRub = "right-foreleg";
				}
			}
			else if (touchedPart == _pokeWindow._legs0)
			{
				if (clickedPolygon(touchedPart, leftLegPolyArray))
				{
					specialRub = "left-thigh";
				}
				else
				{
					specialRub = "right-thigh";
				}
			}
		}
	}

	override public function canChangeHead():Bool
	{
		return !fancyRubbing(_pokeWindow._tongue) && specialRub != "head" && specialRub != "left-ear" && specialRub != "right-ear";
	}

	public static function countUnique(a:Array<String>):Int
	{
		var uniqueCount:Int = 0;
		var map:Map<String, String> = new Map<String, String>();
		a.filter(function(s) { if (!map.exists(s)) { uniqueCount++; map[s] = s; } return true;} );
		return uniqueCount;
	}

	override public function back():Void
	{
		// if the foreplayHeartReservoir is empty (or half empty), empty the
		// dick heart reservoir too -- that way the toy meter won't stay full.
		_toyBank._dickHeartReservoir = Math.min(_toyBank._dickHeartReservoir, SexyState.roundDownToQuarter(_toyBank._defaultDickHeartReservoir * _toyBank.getForeplayPercent()));

		super.back();

		// if we hatgasmed, we empty Smeargle's reservoir bank
		if (hatgasm)
		{
			var amount:Int = Std.int(FlxMath.bound(PlayerData.smeaReservoirBank, 0, 210 - PlayerData.smeaReservoir));
			PlayerData.smeaReservoir += amount;
			PlayerData.smeaReservoirBank -= amount;
		}
	}

	override function penetrating():Bool
	{
		if (!_male && specialRub == "jack-off")
		{
			return true;
		}
		return false;
	}

	override public function computeChatComplaints(complaints:Array<Int>):Void
	{
		if (niceThings[1] && specialRubs.indexOf("belly") == -1)
		{
			complaints.push(0);
		}
		if (smeargleMood1 == 0 && !hatgasm)
		{
			complaints.push(1);
		}
		if (smeargleMood1 == 0 && (specialRubs.indexOf("rub-dick") != -1 || specialRubs.indexOf("jack-off") != -1))
		{
			complaints.push(2);
		}
		if (specialRubs.indexOf("tongue") != -1)
		{
			complaints.push(3);
		}
		if (dislikedHandsDown)
		{
			complaints.push(4);
		}
		if (dislikedHandsUp)
		{
			complaints.push(5);
		}
	}

	override function generateCumshots():Void
	{
		if (heartBankruptcy > 0)
		{
			// we had negative hearts earlier; we pay for that now
			_heartEmitCount -= heartBankruptcy;
			heartBankruptcy = 0;
		}
		var heartPenalty:Float = 1;
		if (!came)
		{
			setUncomfortable(false);
			var uniqueCount:Int = countUnique(specialRubs);
			heartPenalty = FlxMath.bound((uniqueCount + 1) / 8, 0, 1);
			if (specialRubs.indexOf("hat") > specialRubs.indexOf("jack-off") && !displayingToyWindow())
			{
				// came from rubbing hat
				hatgasm = true;
				if (smeargleMood1 == 1)
				{
					// was horny; why didn't you rub me
					heartPenalty *= 0.5;
				}
				else
				{
					// wasn't horny; no penalty
				}
			}
			else
			{
				dirtyDirtyOrgasm = true;
				// came from rubbing dick, or from vibrator
				if (niceThings[2] && smeargleMood1 == 1)
				{
					// was horny; no penalty
					niceThings[2] = false;
					doNiceThing(0.66667);
				}
				else
				{
					// wasn't horny; why did you rub me?
					heartPenalty *= 0.5;
				}
				if (smeargleMood1 == 1 && !niceThings[2] && (!niceThings[0] || !niceThings[1]))
				{
					// smeargle's horny, he came from rubbing his dick, and one of his other "nice things" were met
					canEjaculate = true;
				}
				if (addToyHeartsToOrgasm)
				{
					// smeargle's horny, we treated him right with the vibrator
					canEjaculate = true;
				}
			}
			_heartBank._dickHeartReservoir = SexyState.roundUpToQuarter(heartPenalty * _heartBank._dickHeartReservoir);
			_heartBank._foreplayHeartReservoir = SexyState.roundUpToQuarter(heartPenalty * _heartBank._foreplayHeartReservoir);
		}
		if (addToyHeartsToOrgasm && _remainingOrgasms == 1)
		{
			_heartBank._dickHeartReservoir += _toyBank._dickHeartReservoir;
			_heartBank._dickHeartReservoir += _toyBank._foreplayHeartReservoir;

			_toyBank._dickHeartReservoir = 0;
			_toyBank._foreplayHeartReservoir = 0;
		}

		super.generateCumshots();

		if (canEjaculate)
		{
			if (_pokeWindow._comfort != 3)
			{
				_pokeWindow._comfort = 3;
				_armsAndLegsArranger._armsAndLegsTimer = 0;
			}
		}
		else {
			orgasmWords.timer = 1000000;
			for (cumshot in _cumShots)
			{
				cumshot.rate = 0;
				cumshot.arousal = Math.round(cumshot.arousal * heartPenalty);
			}
		}

		if (_armsAndLegsArranger._armsAndLegsTimer >= 1.5)
		{
			// avoid odd scenarios like -- hands covering head with eyes open
			_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(0.5, 1.5);
		}
	}

	override function computePrecumAmount():Int
	{
		if (_pokeWindow._uncomfortable)
		{
			return 0;
		}
		var precumAmount:Int = 0;
		if (displayingToyWindow())
		{
			if (addToyHeartsToOrgasm)
			{
				// already succeeded in "deduction game"; precum aplenty
				if (FlxG.random.float(0, consecutiveVibeCount) >= 2.5)
				{
					precumAmount++;
				}
				if (FlxG.random.float(0, 4) < _heartEmitCount)
				{
					precumAmount++;
				}
				if (FlxG.random.float(0, 8) < _heartEmitCount)
				{
					precumAmount++;
				}
				if (Math.pow(FlxG.random.float(0, 1.0), 0.5) >= _heartBank.getDickPercent())
				{
					precumAmount++;
				}
			}
			else
			{
				// precum is a clue in the deduction game
				if (vibeGettingCloser)
				{
					precumAmount = 1;
				}
				else
				{
					precumAmount = 0;
				}
			}
			return precumAmount;
		}
		if (specialRub == "jack-off" && FlxG.random.float(0, 4) < _heartEmitCount)
		{
			precumAmount++;
		}
		if (specialRub == "jack-off" && FlxG.random.float(0, 8) < _heartEmitCount)
		{
			precumAmount++;
		}
		if (smeargleMood1 == 1 && FlxG.random.float(0, 16) < _heartEmitCount)
		{
			precumAmount++;
		}
		if (smeargleMood1 == 1 && Math.pow(FlxG.random.float(0, 1.0), 0.5) >= _heartBank.getDickPercent())
		{
			precumAmount++;
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
		if (!_male && specialRub == "jack-off")
		{
			_vagTightness *= 0.55;
			updateVagFingeringAnimation();
			if (_rubBodyAnim != null)
			{
				_rubBodyAnim.refreshSoon();
			}
			if (_rubHandAnim != null)
			{
				_rubHandAnim.refreshSoon();
			}
		}

		// calculate mouse click speed, to determine if they're doing stuff fast/slow
		var mean:Float = SexyState.average(mouseTiming.slice( -4, mouseTiming.length));
		mouseTiming.splice(0, mouseTiming.length - 4);

		// did they rub something we like?
		var likedRub:Bool = false;
		var dislikedRub:Bool = false;
		if (niceRubs[niceRubsIndex].indexOf(specialRub) != -1)
		{
			likedRub = true;
		}
		// if countdown was just reset, the other one is OK too
		if (niceRubsCountdown == niceRubsCountdowns[niceRubsCountdownsIndex] && niceRubs[(niceRubsIndex + 1) % niceRubs.length].indexOf(specialRub) != -1)
		{
			likedRub = true;
		}
		if (!likedRub && dislikedRubs.indexOf(specialRub) != -1)
		{
			dislikedRub = true;
		}

		if (likedRub)
		{
			if (specialRub == "hat" || specialRub == "rub-dick" || specialRub == "jack-off")
			{
				// don't force player to stop rubbing hat/dick
			}
			else
			{
				niceRubsCountdown--;
				if (niceRubsCountdown < 0)
				{
					if (niceRubsCountdowns[niceRubsCountdownsIndex] >= 6)
					{
						niceRubsCountdowns[niceRubsCountdownsIndex] += FlxG.random.int(0, -2);
					}
					else
					{
						niceRubsCountdowns[niceRubsCountdownsIndex] += FlxG.random.int(0, 1);
					}

					niceRubsCountdownsIndex = (niceRubsCountdownsIndex + 1) % niceRubsCountdowns.length;
					niceRubsCountdown = niceRubsCountdowns[niceRubsCountdownsIndex];
					niceRubsIndex = (niceRubsIndex + 1) % niceRubs.length;
					// if countdown just got reset, change arm pose
					if (_armsAndLegsArranger._armsAndLegsTimer >= 1.5)
					{
						_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(0.5, 1.5);
					}
				}
			}
		}

		if (smeargleMood1 == 1 && _heartBank._foreplayHeartReservoir <= 0)
		{
			// don't force player to rub upper body for zero reward
			niceRubsIndex = 1;
		}

		var lucky:Float = lucky(0.7, 1.43, 0.06);
		if (dislikedRub)
		{
			lucky *= dislikedPenalty;
			dislikedPenalty = FlxMath.bound(dislikedPenalty + 0.03, 0.001, 0.4);
		}
		var newRub:Bool = true;
		var specialRubsExceptLast:Array<String> = specialRubs.slice(0, specialRubs.length - 1);
		if (specialRubsExceptLast.indexOf(specialRub) != -1)
		{
			newRub = false;
		}
		if ((specialRub == "rub-dick" || specialRub == "jack-off") && (specialRubsExceptLast.indexOf("rub-dick") != -1 || specialRubsExceptLast.indexOf("jack-off") != -1))
		{
			newRub = false;
		}
		if (dislikedRub)
		{
			if (newRub)
			{
				uniqueDislikedRubCount++;
			}
			dislikedRubCombo++;
		}
		else {
			dislikedRubCombo = 0;
		}
		if (dislikedRub && specialRubs.length >= 3 && (smeargleMood2 == 4 || smeargleMood2 == 5))
		{
			if (!niceThings[0] && !niceThings[1])
			{
				// no reason to rub
			}
			else
			{
				var emittedWords:Bool = false;
				if (FlxG.random.bool() && specialRubs.indexOf("belly") == -1 && niceRubs[niceRubsIndex].indexOf("belly") != -1 && bellyRubWords.timer <= 0)
				{
					emitWords(bellyRubWords);
					emittedWords = true;
				}
				else if (specialRubs.indexOf("left-ear") == -1 && specialRubs.indexOf("right-ear") == -1 && niceRubs[niceRubsIndex].indexOf("left-ear") != -1 && bellyRubWords.timer <= 0)
				{
					emitWords(earRubWords);
					emittedWords = true;
				}
				else if (specialRubs.indexOf("left-thigh") == -1 && specialRubs.indexOf("right-thigh") == -1 && niceRubs[niceRubsIndex].indexOf("left-thigh") != -1 && thighRubWords.timer <= 0)
				{
					emitWords(thighRubWords);
					emittedWords = true;
				}
				if (emittedWords)
				{
					bellyRubWords.timer = bellyRubWords.frequency;
					earRubWords.timer = earRubWords.frequency;
					thighRubWords.timer = thighRubWords.frequency;
				}
			}
		}

		var foreplayAmount:Float = 0;
		var dickAmount:Float = 0;
		if (specialRub == "hat" || (smeargleMood1 == 1 && specialRub == "jack-off"))
		{
			foreplayAmount = SexyState.roundDownToQuarter(lucky * (_heartBank._foreplayHeartReservoir - _heartBank._foreplayHeartReservoirCapacity * 0.4));
			// calculate hat bonus
			var hatBonus:Float = 0.02;
			var tmp = 0.16;
			while (mean < tmp)
			{
				hatBonus += 0.02;
				tmp -= 0.015;
			}
			dickAmount = SexyState.roundUpToQuarter((lucky + hatBonus) * _heartBank._dickHeartReservoir);
			if (specialRub == "hat" && smeargleMood1 == 1)
			{
				dickAmount *= 0.5;
			}
			if (smeargleMood1 == 0)
			{
				// reset the head timer, since switching heads is what triggers a "petgasm"
				_newHeadTimer = Math.max(_newHeadTimer, FlxG.random.float(0.5, 1.5));
			}
		}
		else {
			foreplayAmount = SexyState.roundUpToQuarter(lucky * _heartBank._foreplayHeartReservoir);
			if (likedRub && newRub)
			{
				foreplayAmount += SexyState.roundUpToQuarter(lucky * 0.5 * _heartBank._foreplayHeartReservoirCapacity);
				uniqueLikedRubCount++;
				if ((smeargleMood1 == 0 && uniqueLikedRubCount == 6) || (smeargleMood1 == 1 && uniqueLikedRubCount == 4))
				{
					blushTimer += 0.1;
				}
				if (smeargleMood1 == 1)
				{
					_autoSweatRate += 0.04;
				}
				if (blushTimer > 0 && ((smeargleMood1 == 0 && uniqueLikedRubCount >= 6) || (smeargleMood1 == 1 && uniqueLikedRubCount >= 4)))
				{
					blushTimer = FlxMath.bound(blushTimer + 12, 0, 18);
				}
			}
			else if (dislikedRub)
			{
				if (blushTimer > 0)
				{
					blushTimer = 0;
				}
				if (smeargleMood1 == 1)
				{
					_autoSweatRate -= 0.04;
				}

				var unlucky:Float = super.lucky(0.7, 1.43, 0.06);
				_heartBank._foreplayHeartReservoir -= SexyState.roundUpToQuarter(unlucky * _heartBank._foreplayHeartReservoir);
				_heartBank._dickHeartReservoir -= SexyState.roundDownToQuarter(unlucky * (_heartBank._dickHeartReservoir - _heartBank._dickHeartReservoirCapacity * 0.4));
				if (specialRub == "rub-dick" || specialRub == "jack-off")
				{
					// calculate speed bonus
					var speedBonus:Float = 0.02;
					var tmp = 0.16;
					while (mean < tmp)
					{
						speedBonus += 0.02;
						tmp -= 0.02;
					}
					if (specialRub == "rub-dick")
					{
						// empty foreplay reservoir to get hard faster
						_heartBank._foreplayHeartReservoir -= SexyState.roundUpToQuarter(speedBonus * _heartBank._foreplayHeartReservoir);
					}
					if (specialRub == "jack-off")
					{
						// empty dick reservoir to cum faster
						_heartBank._dickHeartReservoir -= SexyState.roundUpToQuarter(speedBonus * _heartBank._dickHeartReservoir);
					}
				}
			}
			if (smeargleMood1 == 0 || specialRub == "jack-off")
			{
				dickAmount = SexyState.roundDownToQuarter(lucky * (_heartBank._dickHeartReservoir - _heartBank._dickHeartReservoirCapacity * 0.4));
			}
		}

		foreplayAmount = FlxMath.bound(foreplayAmount, 0, _heartBank._foreplayHeartReservoir);
		dickAmount = FlxMath.bound(dickAmount, 0, _heartBank._dickHeartReservoir);
		_heartBank._foreplayHeartReservoir -= foreplayAmount;
		_heartBank._dickHeartReservoir -= dickAmount;
		var amount:Float = foreplayAmount + dickAmount;
		_heartEmitCount += amount;

		if (specialRub == "rub-dick" || specialRub == "jack-off")
		{
			_bonerThreshold += 0.08;
		}
		else if (specialRub == "balls")
		{
			_bonerThreshold -= 0.05;
		}
		else if (specialRub == "left-foot" || specialRub == "right-foot")
		{
			_bonerThreshold -= 0.08;
		}
		else {
			_bonerThreshold -= 0.13;
		}
		if (smeargleMood1 == 1)
		{
			_bonerThreshold += 0.08;
		}
		_bonerThreshold = FlxMath.bound(_bonerThreshold, smeargleMood1 == 0 ? -0.2 : 0.35, 0.66);

		if (niceThings[0] && likedRub && newRub)
		{
			// niceThings[0]: rub a bunch of different things smeargle likes
			if ((smeargleMood1 == 0 && uniqueLikedRubCount >= 7) || (smeargleMood1 == 1 && uniqueLikedRubCount >= 5))
			{
				niceThings[0] = false;
				emitWords(pleasureWords);
				doNiceThing(0.66667);
			}
		}
		if (niceThings[1] && likedRub && specialRubs.length >= 3 && specialRubsInARow() == 3)
		{
			// niceThings[1]: rub something smeargle likes several times in a row
			if (specialRub == "hat" || specialRub == "rub-dick" || specialRub == "jack-off")
			{
				// too easy; these are things people will rub anyways
			}
			else
			{
				niceThings[1] = false;
				emitWords(pleasureWords);
				doNiceThing(0.66667);
			}
		}
		if (niceThings[2] && smeargleMood1 == 0)
		{
			if (specialRub == "hat" && niceThings[2])
			{
				if (mean >= 0.12)
				{
					if (smeargleMood2 == 3 || smeargleMood2 == 5)
					{
						// give hint?
						maybeEmitWords(fasterHatWords);
					}
				}
				else
				{
					niceThings[2] = false;
					emitWords(pleasureWords);
					doNiceThing(0.66667);
				}
			}
		}
		if (likedRub && specialRub == "hat" && mean < 0.12)
		{
			_pokeWindow._arousal = 5;
			if (_newHeadTimer > 0.1)
			{
				_newHeadTimer = FlxG.random.float(0, 0.1);
			}
			maybeEmitWords(pleasureWords);
		}
		if (meanThings[0] && uniqueDislikedRubCount >= 3)
		{
			meanThings[0] = false;
			doMeanThing();
			if (niceRubsIndex == 0 && niceRubs[1].indexOf(specialRub) != -1)
			{
				dislikedHandsDown = true;
			}
			else if (niceRubsIndex == 1 && niceRubs[0].indexOf(specialRub) != -1)
			{
				dislikedHandsUp = true;
			}
		}
		if (meanThings[1] && dislikedRubCombo >= 2 && specialRubsInARow() >= 2)
		{
			meanThings[1] = false;
			doMeanThing();
			if (niceRubsIndex == 0 && niceRubs[1].indexOf(specialRub) != -1)
			{
				dislikedHandsDown = true;
			}
			else if (niceRubsIndex == 1 && niceRubs[0].indexOf(specialRub) != -1)
			{
				dislikedHandsUp = true;
			}
		}

		if (almostWords.timer <= 0 && smeargleMood1 == 1 && specialRub == "jack-off" && _heartBank.getDickPercent() < 0.42 && !isEjaculating())
		{
			blushTimer = FlxMath.bound(blushTimer + 12, 0, 18);
			emitWords(almostWords);
		}

		if (specialRub == "tongue")
		{
			maybeEmitWords(tongueWords);
		}

		emitCasualEncouragementWords();
		if (_heartEmitCount > 0)
		{
			maybeScheduleBreath();
			maybePlayPokeSfx();
			maybeEmitPrecum();
		}
	}

	/**
	 * Smeargle doesn't use meter as easily. He'll still use 0 bonusCapacity even if his reservoir is as high as 59.
	 */
	override function computeBonusCapacity():Int
	{
		var reservoir:Int = PlayerData.smeaReservoir;
		var bonusCapacity:Int = 0;
		if (reservoir >= 210)
		{
			bonusCapacity = 210;
		}
		else if (reservoir >= 120)
		{
			bonusCapacity = 90;
		}
		else if (reservoir >= 60)
		{
			bonusCapacity = 30;
		}
		return bonusCapacity;
	}

	override function computeBonusToyCapacity():Int
	{
		var bonusToyCapacity:Int = super.computeBonusToyCapacity();

		// if smeargle's not horny, the toy shouldn't use up any bonus meter
		var bonusCapacity:Float = computeBonusCapacity();
		if (bonusCapacity == 0)
		{
			bonusToyCapacity = 0;
		}

		return bonusToyCapacity;
	}

	override public function createToyMeter(toyButton:FlxSprite, pctNerf:Float=1.0):ReservoirMeter
	{
		var reservoir:Int = Reflect.field(PlayerData, _pokeWindow._prefix + "ToyReservoir");

		// if smeargle's not horny, the toy should always been "green" or lower
		var bonusCapacity:Float = computeBonusCapacity();
		if (bonusCapacity == 0)
		{
			reservoir = Std.int(Math.min(reservoir, 59));
		}
		reservoir = Std.int(reservoir * pctNerf);

		var toyPct:Float = Math.pow(reservoir / 180, 1.2);
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

	override function doMeanThing(amount:Float = 1):Void
	{
		super.doMeanThing();
		if (_heartEmitCount < 0)
		{
			heartBankruptcy -= _heartEmitCount;
			_heartEmitCount = 0;
		}
	}

	override function videoWasDirty():Bool
	{
		return dirtyDirtyOrgasm;
	}

	private function updateVagFingeringAnimation():Void
	{
		var tightness0:Int = 1;

		if (_vagTightness > 2.5)
		{
			tightness0 = 2;
		}
		else if (_vagTightness > 1.2)
		{
			tightness0 = 3;
		}
		else if (_vagTightness > 0.6)
		{
			tightness0 = 4;
		}
		else {
			tightness0 = 5;
		}

		_pokeWindow._dick.animation.add("jack-off", [1, 8, 9, 10, 11, 12].slice(0, tightness0 + 1));
		_pokeWindow._interact.animation.add("jack-off", [15, 48, 49, 50, 51, 52].slice(0, tightness0 + 1));
	}

	function setInactiveDickAnimation():Void
	{
		if (_male)
		{
			if (_gameState >= 400)
			{
				if (_dick.animation.name != "finished")
				{
					_dick.animation.add("finished", [1, 1, 1, 1, 0], 1, false);
					_dick.animation.play("finished");
				}
			}
			else if (pastBonerThreshold())
			{
				if (_dick.animation.frameIndex != 2)
				{
					_dick.animation.add("default", [2]);
					_dick.animation.play("default");
				}
			}
			else if (_heartBank.getForeplayPercent() < _bonerThreshold + 0.19)
			{
				if (_dick.animation.frameIndex != 1)
				{
					_dick.animation.add("default", [1]);
					_dick.animation.play("default");
				}
			}
			else
			{
				if (_dick.animation.frameIndex != 0)
				{
					_dick.animation.add("default", [0]);
					_dick.animation.play("default");
				}
			}
		}
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		if (!_male)
		{
			// vagina starts out tight
			_dick.animation.add("jack-off", [1, 8]);
			_pokeWindow._interact.animation.add("jack-off", [15, 48]);
		}
	}

	override public function eventShowToyWindow(args:Array<Dynamic>)
	{
		super.eventShowToyWindow(args);

		_pokeWindow.setVibe(true);
		_armsAndLegsArranger.arrangeNow(); // move legs so they don't block cord
		if (!_male)
		{
			_pokeWindow._vibe.loadShadow(_shadowGloveBlackGroup, AssetPaths.smear_dick_vibe_shadow_f__png);
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
		if (_pokeWindow._uncomfortable)
		{
			setUncomfortable(false);
		}
	}

	override function cursorSmellPenaltyAmount():Int
	{
		return 70;
	}

	override public function destroy():Void
	{
		super.destroy();

		torsoSweatArray = null;
		headSweatArray = null;
		tonguePolyArray = null;
		leftFootPolyArray = null;
		rightFootPolyArray = null;
		hatPolyArray = null;
		leftHatPolyArray = null;
		leftArmPolyArray = null;
		leftEarPolyArray = null;
		rightEarPolyArray = null;
		leftLegPolyArray = null;
		vagPolyArray = null;
		electricPolyArray = null;
		tongueWords = null;
		fasterHatWords = null;
		bellyRubWords = null;
		earRubWords = null;
		thighRubWords = null;
		toyStopWords = null;
		niceRubs = null;
		dislikedRubs = null;
		niceRubsCountdowns = null;
		niceThings = null;
		meanThings = null;
		xlDildoButton = FlxDestroyUtil.destroy(xlDildoButton);
		_largeGreyBeadButton = FlxDestroyUtil.destroy(_largeGreyBeadButton);
		_elecvibeButton = FlxDestroyUtil.destroy(_elecvibeButton);
		_vibeButton = FlxDestroyUtil.destroy(_vibeButton);
		_toyInterface = FlxDestroyUtil.destroy(_toyInterface);
		perfectVibe = null;
		goodVibes = null;
		dickVibeAngleArray = null;
		unguessedVibeSettings = null;
		lastFewVibeSettings = null;
	}
}