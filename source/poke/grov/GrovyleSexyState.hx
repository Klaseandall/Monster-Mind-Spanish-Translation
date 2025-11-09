package poke.grov;
import flixel.FlxCamera;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import flixel.util.FlxAxes;
import flixel.util.FlxDestroyUtil;
import kludge.LateFadingFlxParticle;
import openfl.Assets;
import openfl.media.Sound;
import poke.abra.AbraSexyState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import kludge.BetterFlxRandom;
import openfl.utils.Object;
import poke.magn.MagnWindow;
import poke.sexy.FancyAnim;
import poke.sexy.HeartBank;
import poke.sexy.RandomPolygonPoint;
import poke.sexy.SexyState;
import poke.sexy.WordManager.Qord;
import poke.grov.VibeInterface.vibeString;

/**
 * Sex sequence for Grovyle
 * 
 * Grovyle likes to get warmed up first, so keep things above her waist until
 * she's ready. You'll know she's ready because her expression changes, and she
 * relaxes her eyelids.
 * 
 * As you rub grovyle's body, she'll eventually start touching herself. Rubbing
 * her thighs or feet especially gets her in the mood for this.
 * 
 * She'll either start fingering her pussy or her ass. If you help her out by
 * fingering the one she's not touching, it will make her very happy.
 * 
 * As you continue playing with her, at some point her expression will shift
 * from her usual relaxed/pleasured expression to a weird needy expression.
 * When this happens, she likes if you finger her ass or pussy... Whichever one
 * you didn't rub the first time.
 * 
 * When rubbing her feet, make sure to keep things even. If you rub one foot
 * too much more than the other foot, she gets a little cranky.
 * 
 * Grovyle enjoys the venonat vibrator. But, make sure to warm her up first;
 * it's susceptible to the same "below the equator" rule she uses for rubbing
 * her pussy.
 * 
 * Grovyle never likes the fastest two speed settings on the vibrator, so keep
 * it to the lower 3 settings.
 * 
 * There is a combination of mode and speed which she especially likes.
 * Although it changes over time, it will always be one of the following seven:
 *  1. Sustained (middle button), speed 1
 *  2. Sustained, speed 2
 *  3. Oscillating (left button), speed 1
 *  4. Oscillating, speed 2
 *  5. Oscillating, speed 3
 *  6. Pulse (right button), speed 2
 *  7. Pulse, speed 3
 * As you try different vibrator settings, you can tell based on the amount she
 * precums how much she's enjoying it. If you have the correct speed or mode,
 * she'll emit a lot of hearts and precum a lot. If the speed and mode are
 * incorrect, she'll only emit a few hearts and won't precum. Use this to
 * logically deduce her favorite setting.
 * 
 * If you keep the vibrator on her favorite setting briefly, she'll moan and
 * her orgasms will become more powerful. If you can find her preferred setting
 * in 3 or fewer guesses, she'll also have one or more additional orgasms.
 * There is no luck to this, and there is a logical method which can find it
 * every time. For example:
 *  1. First, try Oscillating, speed 3... (Grovyle does not react; neither the
 *     mode or speed is correct)
 *  2. Next, try Pulse, speed 2... (Grovyle precums and emits many hearts; the
 *     mode or speed is correct, but not both.)
 *  3. Lastly, try Sustained, speed 2... (This is Grovyle's correct setting; it
 *     is the only of the remaining 5 settings which has the same speed or mode
 *     as Pulse, speed 2 -- without having anything in common with Oscillating,
 *     Speed 3)
 */
class GrovyleSexyState extends SexyState<GrovyleWindow>
{
	private var _assTightness:Float = 5;
	private var _vagTightness:Float = 5;
	private var ballOpacityTween:FlxTween;
	private var _selfRubTimer:Float = 0;
	private var _selfRubLimit:Float = 0;
	private var rubbingIt:Bool = false;
	
	private var assPolyArray:Array<Array<FlxPoint>>;
	private var vagPolyArray:Array<Array<FlxPoint>>;
	private var tailAssPolyArray:Array<Array<FlxPoint>>;
	private var leftCalfPolyArray:Array<Array<FlxPoint>>;
	private var rightCalfPolyArray:Array<Array<FlxPoint>>;
	private var electricPolyArray:Array<Array<FlxPoint>>;
	
	private var torsoSweatArray:Array<Array<FlxPoint>>;
	private var headSweatArray:Array<Array<FlxPoint>>;
	
	private var selfTouchCount:Int = 0;
	private var selfTouchSoon:Int = 5;
	
	private var desiredRub:String;
	private var desiredRubs:Array<Array<String>> = [
		["dick", "ass", "balls"],
		["dick", "balls", "ass"],
		["balls", "dick", "ass"],
		["ass", "dick", "balls"]
	];

	/*
	 * niceThings[0] = when grovyle starts touching herself the first time, do something she likes
	 * niceThings[1] = when grovyle starts touching herself the second time, do something she likes
	 * niceThings[2] = (male only) when grovyle wants you to do something a third time, read her mind
	 */
	private var niceThings:Array<Bool> = [true, true, true];
	
	/*
	 * meanThings[0] = rub grovyle's feet/genitals before she's ready
	 * meanThings[1] = grab a body part grovyle's currently touching
	 */
	private var meanThings:Array<Bool> = [true, true];
	
	private var grovyleMood0:Int = FlxG.random.int(0, 3); // which parts does he want rubbed?
	private var grovyleMood1:Int = FlxG.random.int(1, 5); // how quickly will he tolerate you touching his privates
	private var grovyleMood2:Int = FlxG.random.int(0, 4); // how verbose are his hints?
	
	private var heartPenalty:Float = 1.0;
	
	private var impatientTimer:Float = 100;
	
	private var leftFootCount:Float = 1;
	private var rightFootCount:Float = 1;
	private var footPenaltyTimer:Float = 0;
	
	private var hurryUpWords:Qord;
	private var niceHurryWords:Qord;
	private var slowDownWords:Qord;
	private var hintWords:Qord;
	private var toyStopWords:Qord;
	
	private var stolen:Array<BouncySprite> = [];
	private var firstBadRub:FlxSprite;
	
	private var _beadButton:FlxButton;
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
	private var guessCount:Int = 0;
	
	private var perfectVibeChoices:Array<Array<Dynamic>> = [
		[VibeSfx.VibeMode.Sustained, 1],
		[VibeSfx.VibeMode.Sustained, 2],
		[VibeSfx.VibeMode.Pulse, 2],
		[VibeSfx.VibeMode.Pulse, 3],
		[VibeSfx.VibeMode.Sine, 1],
		[VibeSfx.VibeMode.Sine, 2],
		[VibeSfx.VibeMode.Sine, 3],
	];
	
	override public function create():Void
	{
		prepare("grov");
		
		// Shift Grovyle down so he's framed in the window better
		_pokeWindow.shiftVisualItems(40);

		super.create();
		
		_toyInterface = new VibeInterface(_pokeWindow._vibe);
		toyGroup.add(_toyInterface);
		
		if (!_male) {
			for (rubs in desiredRubs) {
				for (i in 0...rubs.length) {
					if (rubs[i] == "balls") {
						rubs[i] = "ass";
					}
				}
			}
			
			// doesn't touch self super soon
			selfTouchSoon = 7;
			
			// only asks two things of you; not 3
			niceThings[2] = false;
		}

		sfxEncouragement = [AssetPaths.grov0__mp3, AssetPaths.grov1__mp3, AssetPaths.grov2__mp3, AssetPaths.grov3__mp3];
		sfxPleasure = [AssetPaths.grov4__mp3, AssetPaths.grov5__mp3, AssetPaths.grov6__mp3];
		sfxOrgasm = [AssetPaths.grov7__mp3, AssetPaths.grov8__mp3, AssetPaths.grov9__mp3];
		
		popularity = 0.2;
		cumTrait0 = 4;
		cumTrait1 = 4;
		cumTrait2 = 9;
		cumTrait3 = 1;
		cumTrait4 = 5;
		_rubRewardFrequency = 3.4;
		
		_cumThreshold = 0.35;
		
		sweatAreas.push({chance:4, sprite:_head, sweatArrayArray:headSweatArray});
		sweatAreas.push({chance:6, sprite:_pokeWindow._torso, sweatArrayArray:torsoSweatArray});
		
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_SMALL_GREY_BEADS)) {
			_beadButton = newToyButton(beadButtonEvent, AssetPaths.smallbeads_grey_button__png, _dialogTree);
			addToyButton(_beadButton, 0.13);
		}
		
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_VIBRATOR)) {
			_vibeButton = newToyButton(vibeButtonEvent, AssetPaths.vibe_button__png, _dialogTree);
			addToyButton(_vibeButton);
		}
		
		if (ItemDatabase.getPurchasedMysteryBoxCount() >= 8) {
			_elecvibeButton = newToyButton(elecvibeButtonEvent, AssetPaths.elecvibe_button__png, _dialogTree);
			addToyButton(_elecvibeButton);
		}
		
		for (perfectVibeChoice in perfectVibeChoices) {
			unguessedVibeSettings[vibeString(perfectVibeChoice[0], perfectVibeChoice[1])] = true;
		}
	}
	
	public function beadButtonEvent():Void {
		playButtonClickSound();
		removeToyButton(_beadButton);
		var tree:Array<Array<Object>> = [];
		GrovyleDialog.snarkyBeads(tree);
		showEarlyDialog(tree);
	}
	
	public function vibeButtonEvent():Void {
		stopTouchingSelf();
		playButtonClickSound();
		toyButtonsEnabled = false;
		maybeEmitWords(toyStartWords);
		var time:Float = eventStack._time;
		eventStack.addEvent({time:time, callback:eventShowToyWindow});
		eventStack.addEvent({time:time += 1.7, callback:eventEnableToyButtons});
	}
	
	public function elecvibeButtonEvent():Void {
		_toyInterface.setElectric(true);
		_pokeWindow._vibe.setElectric(true);
		insert(members.indexOf(_breathGroup), _toyInterface.smallSparkEmitter);
		insert(members.indexOf(_breathGroup), _toyInterface.largeSparkEmitter);
		
		vibeButtonEvent();
	}
	
	override public function toyOffButtonEvent():Void {
		super.toyOffButtonEvent();
		if (!shouldEmitToyInterruptWords() && _remainingOrgasms > 0) {
			emitWords(toyStopWords);
		}
	}
	
	override public function shouldEmitToyInterruptWords():Bool {
		return _toyBank.getForeplayPercent() == 1.0 && _toyBank.getDickPercent() == 1.0;
	}
	
	override function toyForeplayFactor():Float {
		/*
		 * 30% of the toy hearts are available for doing random stuff. the
		 * other 70% are only available if you hit the right spot
		 */
		return 0.3;
	}
	
	override public function handleToyWindow(elapsed:Float):Void 
	{
		super.handleToyWindow(elapsed);
		
		vibeGettingCloser = false;
		
		if (_toyInterface.lightningButtonDuration > 0) {
			_toyInterface.doLightning(this, electricPolyArray);
		}
		
		if (_gameState != 200) {
			// no rewards after done orgasming
			return;
		}
		
		if (isEjaculating()) {
			// no rewards while ejaculating
			return;
		}
		
		if (_remainingOrgasms == 0) {
			// no rewards after ejaculating
			return;
		}
		
		if (_toyInterface.lightningButtonDuration > 0 ) {
			if (grovyleMood1 > 0 && meanThings[0] == true) {
				// oops, needed to warm Grovyle up first...
				firstBadRub = _pokeWindow._dick;
				meanThings[0] = false;
				doMeanThing();
				impatientTimer -= 16;
				heartPenalty *= 0.8;
				
				// grovyleMood1 will be decremented from 0 to -5, and then he will be OK again
				grovyleMood1 = 0;
			}			
			
			var amount:Float = 0;
			var precumAmount:Int = 0;
			var rewardAmount:Float = 0;
			var dickAmount:Float = 0;
			var penaltyAmount:Float = 0;
			
			// lightning button released...
			if (_toyInterface.lightningButtonDuration < 0.1) {
				rewardAmount = 0.00;
				dickAmount = 0.01;
				penaltyAmount = 0.00;
			} else if (_toyInterface.lightningButtonDuration < 0.3) {
				rewardAmount = 0.01;
				dickAmount = 0.01;
				penaltyAmount = 0.00;
			} else if (_toyInterface.lightningButtonDuration < 0.5) {
				rewardAmount = 0.01;
				dickAmount = 0.02;
				penaltyAmount = 0.00;
			} else if (_toyInterface.lightningButtonDuration < 0.8) {
				rewardAmount = 0.02;
				dickAmount = 0.02;
				penaltyAmount = 0.00;
			} else if (_toyInterface.lightningButtonDuration < 1.1) {
				rewardAmount = 0.02;
				dickAmount = 0.03;
				penaltyAmount = 0.00;
				precumAmount = 1;
			} else if (_toyInterface.lightningButtonDuration < 1.4) {
				rewardAmount = 0.03;
				dickAmount = 0.03;
				penaltyAmount = 0.00;
				precumAmount = 1;
			} else if (_toyInterface.lightningButtonDuration < 1.7) {
				rewardAmount = 0.00;
				dickAmount = 0.02;
				penaltyAmount = 0.02;
			} else {
				rewardAmount = 0.00;
				dickAmount = 0.01;
				penaltyAmount = 0.04;
			}
			
			amount += SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * rewardAmount);
			_toyBank._dickHeartReservoir -= SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * rewardAmount);
			
			if (pastBonerThreshold()) {
				amount += SexyState.roundUpToQuarter(_heartBank._dickHeartReservoir * dickAmount);
				_heartBank._dickHeartReservoir -= SexyState.roundUpToQuarter(_heartBank._dickHeartReservoir * dickAmount);
				
				_heartBank._dickHeartReservoir -= SexyState.roundUpToQuarter(_heartBank._dickHeartReservoir * penaltyAmount);
			} else {
				amount += SexyState.roundUpToQuarter(_heartBank._foreplayHeartReservoir * dickAmount);
				_heartBank._foreplayHeartReservoir -= SexyState.roundUpToQuarter(_heartBank._foreplayHeartReservoir * dickAmount);
				
				_heartBank._foreplayHeartReservoir -= SexyState.roundUpToQuarter(_heartBank._foreplayHeartReservoir * penaltyAmount);
			}
			
			if (precumAmount > 0) {
				precum(precumAmount);
			}
			
			_heartEmitCount += amount;
			
			if (_heartEmitCount <= 0) {
				// vibrator activity was eaten by penalty
			} else {
				_characterSfxTimer -= 2.8;
				maybePlayPokeSfx();
				maybeEmitWords(encouragementWords);
			}
		}
		
		if (!_pokeWindow._vibe.vibeSfx.isVibratorOn()) {
			lastFewVibeSettings.splice(0, lastFewVibeSettings.length);
			consecutiveVibeCount = 0;
			return;
		}
		
		// accumulate rewards in vibeReservoir...
		vibeRewardTimer += elapsed;
		_idlePunishmentTimer = 0; // pokemon doesn't get bored if the vibrator's on
		
		if (vibeRewardTimer >= vibeRewardFrequency) {
			// When the vibrator's on, we accumulate 1-3% hearts in the reservoir...
			vibeRewardTimer -= vibeRewardFrequency;
			
			var foreplayPct:Float = [0.010, 0.015, 0.020, 0.025, 0.03][_pokeWindow._vibe.vibeSfx.speed - 1];
			
			var amount:Float = SexyState.roundUpToQuarter(_toyBank._foreplayHeartReservoirCapacity * foreplayPct);
			if (!pastBonerThreshold() && _heartBank._foreplayHeartReservoirCapacity < 1000) {
				// bump up foreplay heart capacity, to give a boner faster
				_heartBank._foreplayHeartReservoirCapacity += 3 * amount;
			}
			if (amount > 0 && _toyBank._foreplayHeartReservoir > 0 ) {
				// first, try to get these hearts from the toy bank...
				var deductionAmount:Float = Math.min(amount, _toyBank._foreplayHeartReservoir);
				amount -= deductionAmount;
				_toyBank._foreplayHeartReservoir -= deductionAmount;
				vibeReservoir += deductionAmount;
			}
			if (amount > 0 && !pastBonerThreshold() && _heartBank._foreplayHeartReservoir > 0) {
				// if the toy bank's empty, get them from the foreplay heart reservoir...
				var deductionAmount:Float = Math.min(amount, _heartBank._foreplayHeartReservoir);
				amount -= deductionAmount;
				_heartBank._foreplayHeartReservoir -= deductionAmount;
				vibeReservoir += deductionAmount;
			}
			if (amount > 0 && pastBonerThreshold() && _heartBank._dickHeartReservoir > 0) {
				// if the toy bank's empty, get them from the dick heart reservoir...
				var deductionAmount:Float = Math.min(amount, _heartBank._dickHeartReservoir);
				amount -= deductionAmount;
				_heartBank._dickHeartReservoir -= deductionAmount;
				vibeReservoir += deductionAmount;
			}
		}
		
		if (vibeReservoir > 0 && _pokeWindow._vibe.vibeSfx.isVibrating()) {
			// convert vibeReservoir to hearts
			if (grovyleMood1 > 0 && meanThings[0] == true) {
				// oops, needed to warm Grovyle up first...
				firstBadRub = _pokeWindow._dick;
				meanThings[0] = false;
				doMeanThing();
				impatientTimer -= 16;
				heartPenalty *= 0.8;
				
				// grovyleMood1 will be decremented from 0 to -5, and then he will be OK again
				grovyleMood1 = 0;
			}
			
			// emit hearts from vibe reservoir
			_heartEmitCount += vibeReservoir;
			if (_heartEmitCount <= 0) {
				// vibrator activity was eaten by penalty
				grovyleMood1--;
				if (grovyleMood1 <= -5) {
					_heartEmitCount = Math.max(_heartEmitCount, 0);
				}
			} else {
				// normal vibrator activity
				matchVibeHearts();
				maybeAccelerateVibeReward();
				checkPerfectVibeSpot();
				
				maybeEmitPrecum();
				
				if (_remainingOrgasms > 0) {
					if (_heartBank.getDickPercent() < 0.6) {
						// warn them far ahead of time...
						maybeEmitWords(almostWords);
						impatientTimer = 10000;
					}
				}
				
				maybeEmitToyWordsAndStuff();
				
				if (shouldOrgasm()) {
					_newHeadTimer = 0; // make sure they orgasm before their reservoir is empty
					consecutiveVibeCount = 0; // reset consecutiveVibeCount in case they multiple orgasm; start fresh
				}
			}
			vibeReservoir = 0;
		}
	}
	
	/**
	 * If 5 hearts were in the vibe reservoir, we might also "match" 2.5
	 * hearts from the heartbank. This makes it so Grovyle will eventually cum
	 * from just using the vibrator.
	 */
	function matchVibeHearts() {
		var heartMatchPct:Float = 0;
		if (_toyBank.getForeplayPercent() <= 0 ) {
			heartMatchPct = 0.40;
		} else if (_toyBank.getForeplayPercent() <= 0.25) {
			heartMatchPct = 0.30;
		} else if (_toyBank.getForeplayPercent() <= 0.50) {
			heartMatchPct = 0.20;
		} else if (_toyBank.getForeplayPercent() <= 0.75) {
			heartMatchPct = 0.10;
		}
		if (heartMatchPct > 0) {
			if (!pastBonerThreshold()) {
				var deductionAmount:Float = Math.min(SexyState.roundUpToQuarter(vibeReservoir * heartMatchPct), _heartBank._foreplayHeartReservoir);
				_heartBank._foreplayHeartReservoir -= deductionAmount;
				_heartEmitCount += deductionAmount;
			} else {
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
	function maybeAccelerateVibeReward() {
		lastFewVibeSettings.push(vibeString(_pokeWindow._vibe.vibeSfx.mode, _pokeWindow._vibe.vibeSfx.speed));
		lastFewVibeSettings.splice(0, lastFewVibeSettings.length - 5);
		
		// reduce the timer lower than 1.8s, if the player is lingering on the current setting...
		if (lastFewVibeSettings.length >= 2 && lastFewVibeSettings[lastFewVibeSettings.length - 1] == lastFewVibeSettings[lastFewVibeSettings.length - 2]) {
			consecutiveVibeCount++;
		} else {
			consecutiveVibeCount = 0;
		}
		
		vibeRewardFrequency = FlxMath.bound(11 / (6 + 2 * consecutiveVibeCount), 0.3, 1.8);
	}

	/**
	 * Check whether the player is getting closer to the perfect vibe spot...
	 */
	function checkPerfectVibeSpot() {
		if (consecutiveVibeCount == 1 && perfectVibeChoices.length > 0) {
			guessCount++;
			
			// did they find the magic spot?
			perfectVibeChoices = perfectVibeChoices.filter(function(choice) {return choice[0] != _pokeWindow._vibe.vibeSfx.mode || choice[1] != _pokeWindow._vibe.vibeSfx.speed; });
			if (perfectVibeChoices.length == 0) {
				// yes; found the magic spot
				var rewardAmount:Float = SexyState.roundUpToQuarter(lucky(0.25, 0.35) * _toyBank._dickHeartReservoir);
				_toyBank._dickHeartReservoir -= rewardAmount;
				_heartEmitCount += rewardAmount;
				
				// dump remaining toy "reward hearts" into toy "automatic hearts"
				_toyBank._foreplayHeartReservoir += _toyBank._dickHeartReservoir;
				// increase capacity too, since vibrator throughput scales on capacity
				_toyBank._foreplayHeartReservoirCapacity += SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * 0.4);
				_toyBank._dickHeartReservoir = 0;
				
				if (guessCount <= 3) {
					// perfect deduction; immediate orgasm
					_remainingOrgasms++;
					generateCumshots();
					refreshArousalFromCumshots();
					_newHeadTimer = FlxG.random.float(2, 4) * _headTimerFactor;
				} else {
					maybeEmitWords(pleasureWords);
					maybePlayPokeSfx();
					precum(FlxMath.bound(30 / guessCount, 1, 10)); // silly amount of precum
				}
				
				addToyHeartsToOrgasm = true;
			} else {
				if (guessCount >= 3) {
					// reduce reward bank...
					_toyBank._dickHeartReservoir -= SexyState.roundUpToQuarter(lucky(0.25, 0.35) * _toyBank._dickHeartReservoir);
				}
				
				// no; give them a hint
				var possibleVibeChoice:Array<Dynamic> = FlxG.random.getObject(perfectVibeChoices);
				// do they have the mode or speed correct?
				if (possibleVibeChoice[0] == _pokeWindow._vibe.vibeSfx.mode || possibleVibeChoice[1]  == _pokeWindow._vibe.vibeSfx.speed) {
					perfectVibeChoices = perfectVibeChoices.filter(function(choice) {return choice[0] == _pokeWindow._vibe.vibeSfx.mode || choice[1] == _pokeWindow._vibe.vibeSfx.speed; });
					
					if (unguessedVibeSettings[vibeString(_pokeWindow._vibe.vibeSfx.mode, _pokeWindow._vibe.vibeSfx.speed)] == true) {
						unguessedVibeSettings[vibeString(_pokeWindow._vibe.vibeSfx.mode, _pokeWindow._vibe.vibeSfx.speed)] = false;
						vibeGettingCloser = true;
						var rewardAmount:Float = SexyState.roundUpToQuarter(lucky(0.07, 0.14) * _toyBank._dickHeartReservoir);
						_toyBank._dickHeartReservoir -= rewardAmount;
						_heartEmitCount += rewardAmount;
					}
				} else {
					perfectVibeChoices = perfectVibeChoices.filter(function(choice) {return choice[0] != _pokeWindow._vibe.vibeSfx.mode && choice[1] != _pokeWindow._vibe.vibeSfx.speed; });
				}
			}
		}		
	}
	
	override function foreplayFactor():Float {
		return _male ? 0.5 : 0.7;
	}

	override function shouldRecordMouseTiming():Bool 
	{
		return _dick.animation.name == "jack-off" || _dick.animation.name == "rub-dick";
	}

	override public function touchPart(touchedPart:FlxSprite):Bool
	{
		if (FlxG.mouse.justPressed && (touchedPart == _dick || !_male && touchedPart == _pokeWindow._torso && clickedPolygon(touchedPart, vagPolyArray)))
		{
			if (_selfRubTimer < 1 && _pokeWindow._selfTouchTarget == _dick) {
				// grovyle just grabbed his dick; don't interrupt
			} else {
				if (_pokeWindow._selfTouchTarget == _dick) {
					takeFromGrovyle();
				}
				if (_gameState == 200 && pastBonerThreshold() && (_male || _pokeWindow._selfTouchTarget != _pokeWindow._ass)) {
					interactOn(_dick, "jack-off");
				} else {
					interactOn(_dick, "rub-dick");
				}
				return true;
			}
		}
		if (FlxG.mouse.justPressed && touchedPart == _pokeWindow._balls)
		{
			if (_selfRubTimer < 1 && _pokeWindow._selfTouchTarget == _pokeWindow._balls) {
				// grovyle just grabbed his balls; don't interrupt
			} else {
				if (_pokeWindow._selfTouchTarget == _pokeWindow._balls) {
					takeFromGrovyle();
				}
				interactOn(_pokeWindow._balls, "rub-balls");
				_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.members.indexOf(_pokeWindow._balls) + 1);				
				return true;
			}
		}
		if (FlxG.mouse.justPressed && (touchedPart == _pokeWindow._ass
			|| touchedPart == _pokeWindow._torso && clickedPolygon(touchedPart, assPolyArray)
			|| touchedPart == _pokeWindow._tail && clickedPolygon(touchedPart, tailAssPolyArray))) {
			if (_selfRubTimer < 1 && _pokeWindow._selfTouchTarget == _pokeWindow._ass) {
				// grovyle just grabbed his ass; don't interrupt
			} else {
				if (_pokeWindow._selfTouchTarget == _pokeWindow._ass) {
					takeFromGrovyle();
				}
				updateAssFingeringAnimation();
				interactOn(_pokeWindow._ass, "finger-ass");
				if (!_male && _pokeWindow._selfTouchTarget != _pokeWindow._dick) {
					// vagina stretches when fingering ass
					_rubBodyAnim2 = new FancyAnim(_dick, "finger-ass");
					_rubBodyAnim2.setSpeed(0.65 * 2.5, 0.65 * 1.5);
				}
				_rubBodyAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
				_rubHandAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
				if (_male) {
					ballOpacityTween = FlxTweenUtil.retween(ballOpacityTween, _pokeWindow._balls, { alpha:0.65 }, 0.25);
				}
				return true;
			}
		}
		if (touchedPart == _pokeWindow._legs && _clickedDuration > 1.5) {
			if (clickedPolygon(touchedPart, leftCalfPolyArray)) {
				// raise left leg
				_pokeWindow._legs.animation.play("raise-left-leg");
				_pokeWindow._feet.animation.play("raise-left-leg");
				_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(4, 6);
			}
			if (clickedPolygon(touchedPart, rightCalfPolyArray)) {
				// raise right leg
				_pokeWindow._legs.animation.play("raise-right-leg");
				_pokeWindow._feet.animation.play("raise-right-leg");
				_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(4, 6);
			}
		}
		if (FlxG.mouse.justPressed && touchedPart == _pokeWindow._feet) {
			if (_pokeWindow._feet.animation.name == "raise-left-leg") {
				interactOn(_pokeWindow._feet, "rub-left-foot", "raise-left-leg");
			} else {
				interactOn(_pokeWindow._feet, "rub-right-foot", "raise-right-leg");
			}
			return true;
		}
		return false;
	}
	
	override public function sexyStuff(elapsed:Float):Void
	{
		super.sexyStuff(elapsed);
		
		if (pastBonerThreshold() && _gameState == 200) {
			if (_male && fancyRubbing(_dick) && _rubBodyAnim._flxSprite.animation.name == "rub-dick" && _rubBodyAnim.nearMinFrame()) {
				_rubBodyAnim.setAnimName("jack-off");
				_rubHandAnim.setAnimName("jack-off");
			}
		}
		
		if (fancyRubbing(_pokeWindow._feet) && _armsAndLegsArranger._armsAndLegsTimer < 1.5) {
			_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(1.5, 3);
		}
		
		if (!fancyRubAnimatesSprite(_dick)) {
			setInactiveDickAnimation();
		}
		
		_selfRubTimer += elapsed;
		
		if (_selfRubTimer >= _selfRubLimit && desiredRub != null) {
			desiredRub = null;
			if (_pokeWindow._selfTouchTarget != null) {
				stopTouchingSelf();
			}
		}
	}
	
	override public function determineArousal():Int {
		if (grovyleMood1 > 0) {
			// not warmed up yet
			return 0;
		}
		if ((selfTouchCount == 3 || (!_male && selfTouchCount == 2)) && desiredRub != null && !rubbingIt) {
			if (_selfRubTimer >= _selfRubLimit) {
				desiredRub = null;
			}
			return 3;
		}
		if (_heartBank.getDickPercent() < 0.77) {
			return 4;
		} else if (_heartBank.getDickPercent() < 0.9) {
			return _pokeWindow._vibe.vibeSfx.isVibratorOn() ? 4 : 2;
		} else if (pastBonerThreshold()) {
			return _pokeWindow._vibe.vibeSfx.isVibratorOn() ? 4 : 1;
		} else if (_heartBank.getForeplayPercent() < 0.77) {
			return _pokeWindow._vibe.vibeSfx.isVibratorOn() ? 2 : 2;
		} else if (_heartBank._foreplayHeartReservoir < _heartBank._foreplayHeartReservoirCapacity) {
			return _pokeWindow._vibe.vibeSfx.isVibratorOn() ? 2 : 1;
		} else {
			return _pokeWindow._vibe.vibeSfx.isVibratorOn() ? 1 : 0;
		}
	}
	
	override public function checkSpecialRub(touchedPart:FlxSprite) {
		if (_fancyRub) {
			if (_rubHandAnim._flxSprite.animation.name == "finger-ass") {
				specialRub = "ass";
			} else if (_rubHandAnim._flxSprite.animation.name == "jack-off") {
				specialRub = "jack-off";
			} else if (_rubHandAnim._flxSprite.animation.name == "rub-dick") {
				specialRub = "rub-dick";
			} else if (_rubHandAnim._flxSprite.animation.name == "rub-balls") {
				specialRub = "balls";
			} else if (_rubHandAnim._flxSprite.animation.name == "rub-left-foot") {
				specialRub = "left-foot";
			} else if (_rubHandAnim._flxSprite.animation.name == "rub-right-foot") {
				specialRub = "right-foot";
			}
		} else {
			if (touchedPart == _pokeWindow._legs) {
				if (clickedPolygon(touchedPart, leftCalfPolyArray) || clickedPolygon(touchedPart, rightCalfPolyArray)) {
					specialRub = "calf";
				} else {
					specialRub = "thigh";
				}
			}
		}
	}
	
	override public function untouchPart(touchedPart:FlxSprite):Void 
	{
		super.untouchPart(touchedPart);
		if (touchedPart == _pokeWindow._ass) {
			if (_male) {
				ballOpacityTween = FlxTweenUtil.retween(ballOpacityTween, _pokeWindow._balls, { alpha:1.0 }, 0.25);
			}
		} else if (touchedPart == _pokeWindow._feet) {
			_pokeWindow._feet.animation.play(_pokeWindow._legs.animation.name);
		} else if (touchedPart == _pokeWindow._dick) {
			if (!_male && _pokeWindow._selfTouchTarget == _pokeWindow._ass) {
				_dick.animation.play("self-ass");
				_dick.animation.curAnim.curFrame = _pokeWindow._ass.animation.curAnim.curFrame;
			}
		}
	}
	
	override function initializeHitBoxes():Void
	{
		assPolyArray = new Array<Array<FlxPoint>>();
		assPolyArray[0] = [new FlxPoint(149, 378), new FlxPoint(160, 359), new FlxPoint(198, 366), new FlxPoint(203, 391)];
		assPolyArray[1] = [new FlxPoint(149, 378), new FlxPoint(160, 359), new FlxPoint(198, 366), new FlxPoint(203, 391)];
		
		vagPolyArray = new Array<Array<FlxPoint>>();
		vagPolyArray[0] = [new FlxPoint(200, 367), new FlxPoint(163, 360), new FlxPoint(164, 321), new FlxPoint(212, 331)];
		vagPolyArray[1] = [new FlxPoint(200, 367), new FlxPoint(163, 360), new FlxPoint(164, 321), new FlxPoint(212, 331)];
		
		tailAssPolyArray = new Array<Array<FlxPoint>>();
		tailAssPolyArray[0] = [new FlxPoint(152, 353), new FlxPoint(150, 405), new FlxPoint(194, 408), new FlxPoint(204, 354)];
		
		leftCalfPolyArray = new Array<Array<FlxPoint>>();
		leftCalfPolyArray[0] = [new FlxPoint(33, 254), new FlxPoint(93, 256), new FlxPoint(99, 322), new FlxPoint(97, 442), new FlxPoint(33, 444)];
		leftCalfPolyArray[1] = [new FlxPoint(33, 254), new FlxPoint(93, 256), new FlxPoint(99, 322), new FlxPoint(97, 442), new FlxPoint(33, 444)];
		leftCalfPolyArray[2] = [new FlxPoint(7, 359), new FlxPoint(15, 325), new FlxPoint(90, 335), new FlxPoint(125, 376), new FlxPoint(155, 373), new FlxPoint(169, 391), new FlxPoint(168, 445), new FlxPoint(13, 443)];
		leftCalfPolyArray[3] = [new FlxPoint(7, 359), new FlxPoint(15, 325), new FlxPoint(90, 335), new FlxPoint(125, 376), new FlxPoint(155, 373), new FlxPoint(169, 391), new FlxPoint(168, 445), new FlxPoint(13, 443)];
		leftCalfPolyArray[4] = [new FlxPoint(42, 292), new FlxPoint(81, 289), new FlxPoint(95, 329), new FlxPoint(84, 443), new FlxPoint(30, 441)];
		leftCalfPolyArray[5] = [new FlxPoint(46, 308), new FlxPoint(48, 268), new FlxPoint(92, 254), new FlxPoint(113, 275), new FlxPoint(125, 314), new FlxPoint(110, 339), new FlxPoint(56, 325)];
		leftCalfPolyArray[6] = [new FlxPoint(33, 254), new FlxPoint(93, 256), new FlxPoint(99, 322), new FlxPoint(97, 442), new FlxPoint(33, 444)];
		
		rightCalfPolyArray = new Array<Array<FlxPoint>>();
		rightCalfPolyArray[0] = [new FlxPoint(238, 394), new FlxPoint(270, 386), new FlxPoint(276, 324), new FlxPoint(294, 273), new FlxPoint(340, 279), new FlxPoint(350, 441), new FlxPoint(244, 441)];
		rightCalfPolyArray[1] = [new FlxPoint(182, 387), new FlxPoint(205, 378), new FlxPoint(221, 383), new FlxPoint(256, 341), new FlxPoint(326, 312), new FlxPoint(325, 445), new FlxPoint(186, 441)];
		rightCalfPolyArray[2] = [new FlxPoint(238, 394), new FlxPoint(270, 386), new FlxPoint(276, 324), new FlxPoint(294, 273), new FlxPoint(340, 279), new FlxPoint(350, 441), new FlxPoint(244, 441)];
		rightCalfPolyArray[3] = [new FlxPoint(233, 444), new FlxPoint(230, 401), new FlxPoint(239, 381), new FlxPoint(327, 379), new FlxPoint(323, 442)];
		rightCalfPolyArray[4] = [new FlxPoint(182, 387), new FlxPoint(205, 378), new FlxPoint(221, 383), new FlxPoint(256, 341), new FlxPoint(326, 312), new FlxPoint(325, 445), new FlxPoint(186, 441)];
		rightCalfPolyArray[5] = [new FlxPoint(238, 394), new FlxPoint(270, 386), new FlxPoint(276, 324), new FlxPoint(294, 273), new FlxPoint(340, 279), new FlxPoint(350, 441), new FlxPoint(244, 441)];
		rightCalfPolyArray[6] = [new FlxPoint(262, 356), new FlxPoint(247, 325), new FlxPoint(280, 290), new FlxPoint(323, 291), new FlxPoint(333, 357), new FlxPoint(288, 359)];
		
		if (_male) {
			dickAngleArray[0] = [new FlxPoint(222, 343), new FlxPoint(246, 85), new FlxPoint(46, 256)];
			dickAngleArray[1] = [new FlxPoint(226, 299), new FlxPoint(217, -142), new FlxPoint(166, -200)];
			dickAngleArray[2] = [new FlxPoint(226, 301), new FlxPoint(231, -120), new FlxPoint(171, -196)];
			dickAngleArray[3] = [new FlxPoint(229, 309), new FlxPoint(252, -63), new FlxPoint(208, -156)];
			dickAngleArray[4] = [new FlxPoint(232, 313), new FlxPoint(254, -56), new FlxPoint(209, -155)];
			dickAngleArray[5] = [new FlxPoint(229, 272), new FlxPoint(142, -218), new FlxPoint(127, -227)];
			dickAngleArray[8] = [new FlxPoint(239, 280), new FlxPoint(198, -168), new FlxPoint(179, -189)];
			dickAngleArray[9] = [new FlxPoint(236, 275), new FlxPoint(174, -193), new FlxPoint(159, -206)];
			dickAngleArray[10] = [new FlxPoint(233, 271), new FlxPoint(150, -212), new FlxPoint(133, -224)];
			dickAngleArray[11] = [new FlxPoint(229, 268), new FlxPoint(141, -219), new FlxPoint(131, -224)];
			dickAngleArray[12] = [new FlxPoint(226, 266), new FlxPoint(139, -220), new FlxPoint(123, -229)];
			
			dickVibeAngleArray[0] = [new FlxPoint(221, 342), new FlxPoint(252, 66), new FlxPoint(20, 259)];
			dickVibeAngleArray[1] = [new FlxPoint(221, 342), new FlxPoint(252, 66), new FlxPoint(20, 259)];
			dickVibeAngleArray[2] = [new FlxPoint(219, 341), new FlxPoint(254, 58), new FlxPoint(16, 259)];
			dickVibeAngleArray[3] = [new FlxPoint(222, 341), new FlxPoint(257, 37), new FlxPoint(26, 259)];
			dickVibeAngleArray[4] = [new FlxPoint(221, 341), new FlxPoint(258, 34), new FlxPoint(25, 259)];
			dickVibeAngleArray[5] = [new FlxPoint(226, 297), new FlxPoint(170, -197), new FlxPoint(211, -152)];
			dickVibeAngleArray[6] = [new FlxPoint(227, 299), new FlxPoint(153, -210), new FlxPoint(242, -95)];
			dickVibeAngleArray[7] = [new FlxPoint(225, 298), new FlxPoint(158, -207), new FlxPoint(241, -98)];
			dickVibeAngleArray[8] = [new FlxPoint(227, 298), new FlxPoint(159, -206), new FlxPoint(245, -87)];
			dickVibeAngleArray[9] = [new FlxPoint(226, 296), new FlxPoint(153, -210), new FlxPoint(239, -102)];
			dickVibeAngleArray[10] = [new FlxPoint(229, 271), new FlxPoint(89, -244), new FlxPoint(148, -214)];
			dickVibeAngleArray[11] = [new FlxPoint(228, 271), new FlxPoint(75, -249), new FlxPoint(146, -215)];
			dickVibeAngleArray[12] = [new FlxPoint(226, 271), new FlxPoint(48, -256), new FlxPoint(131, -224)];
			dickVibeAngleArray[13] = [new FlxPoint(230, 272), new FlxPoint(85, -246), new FlxPoint(150, -213)];
			dickVibeAngleArray[14] = [new FlxPoint(229, 269), new FlxPoint(65, -252), new FlxPoint(141, -219)];
			
			electricPolyArray = new Array<Array<FlxPoint>>();
			electricPolyArray[0] = [new FlxPoint(190, 317), new FlxPoint(190, 333), new FlxPoint(226, 339), new FlxPoint(228, 317)];
			electricPolyArray[1] = [new FlxPoint(190, 317), new FlxPoint(190, 333), new FlxPoint(226, 339), new FlxPoint(228, 317)];
			electricPolyArray[2] = [new FlxPoint(190, 317), new FlxPoint(190, 333), new FlxPoint(226, 339), new FlxPoint(228, 317)];
			electricPolyArray[3] = [new FlxPoint(190, 317), new FlxPoint(190, 333), new FlxPoint(226, 339), new FlxPoint(228, 317)];
			electricPolyArray[4] = [new FlxPoint(190, 317), new FlxPoint(190, 333), new FlxPoint(226, 339), new FlxPoint(228, 317)];
			electricPolyArray[5] = [new FlxPoint(188, 307), new FlxPoint(188, 327), new FlxPoint(220, 335), new FlxPoint(224, 311)];
			electricPolyArray[6] = [new FlxPoint(188, 307), new FlxPoint(188, 327), new FlxPoint(220, 335), new FlxPoint(224, 311)];
			electricPolyArray[7] = [new FlxPoint(188, 307), new FlxPoint(188, 327), new FlxPoint(220, 335), new FlxPoint(224, 311)];
			electricPolyArray[8] = [new FlxPoint(188, 307), new FlxPoint(188, 327), new FlxPoint(220, 335), new FlxPoint(224, 311)];
			electricPolyArray[9] = [new FlxPoint(188, 307), new FlxPoint(188, 327), new FlxPoint(220, 335), new FlxPoint(224, 311)];
			electricPolyArray[10] = [new FlxPoint(196, 290), new FlxPoint(192, 315), new FlxPoint(222, 319), new FlxPoint(228, 293)];
			electricPolyArray[11] = [new FlxPoint(196, 290), new FlxPoint(192, 315), new FlxPoint(222, 319), new FlxPoint(228, 293)];
			electricPolyArray[12] = [new FlxPoint(196, 290), new FlxPoint(192, 315), new FlxPoint(222, 319), new FlxPoint(228, 293)];
			electricPolyArray[13] = [new FlxPoint(196, 290), new FlxPoint(192, 315), new FlxPoint(222, 319), new FlxPoint(228, 293)];
			electricPolyArray[14] = [new FlxPoint(196, 290), new FlxPoint(192, 315), new FlxPoint(222, 319), new FlxPoint(228, 293)];
		} else {
			dickAngleArray[0] = [new FlxPoint(179, 353), new FlxPoint(144, 216), new FlxPoint(-174, 193)];
			dickAngleArray[1] = [new FlxPoint(178, 350), new FlxPoint(156, 208), new FlxPoint(-194, 173)];
			dickAngleArray[2] = [new FlxPoint(179, 348), new FlxPoint(192, 176), new FlxPoint(-219, 141)];
			dickAngleArray[3] = [new FlxPoint(179, 348), new FlxPoint(202, 164), new FlxPoint(-222, 136)];
			dickAngleArray[4] = [new FlxPoint(179, 348), new FlxPoint(209, 154), new FlxPoint(-218, 142)];
			dickAngleArray[5] = [new FlxPoint(179, 348), new FlxPoint(231, 120), new FlxPoint(-236, 108)];
			dickAngleArray[6] = [new FlxPoint(181, 348), new FlxPoint(149, 213), new FlxPoint(-173, 194)];
			dickAngleArray[7] = [new FlxPoint(181, 348), new FlxPoint(149, 213), new FlxPoint(-173, 194)];
			dickAngleArray[8] = [new FlxPoint(180, 354), new FlxPoint(151, 212), new FlxPoint(-184, 184)];
			dickAngleArray[9] = [new FlxPoint(180, 354), new FlxPoint(190, 178), new FlxPoint(-190, 177)];
			dickAngleArray[10] = [new FlxPoint(180, 354), new FlxPoint(198, 168), new FlxPoint(-216, 144)];
			dickAngleArray[11] = [new FlxPoint(180, 354), new FlxPoint(225, 130), new FlxPoint(-229, 123)];
			dickAngleArray[12] = [new FlxPoint(180, 354), new FlxPoint(242, 94), new FlxPoint(-240, 100)];
			dickAngleArray[13] = [new FlxPoint(180, 354), new FlxPoint(248, 77), new FlxPoint( -249, 75)];
			
			dickVibeAngleArray[0] = [new FlxPoint(179, 356), new FlxPoint(238, 106), new FlxPoint(-244, 90)];
			dickVibeAngleArray[1] = [new FlxPoint(179, 356), new FlxPoint(238, 106), new FlxPoint(-244, 90)];
			dickVibeAngleArray[2] = [new FlxPoint(178, 355), new FlxPoint(162, 203), new FlxPoint(-260, -12)];
			dickVibeAngleArray[3] = [new FlxPoint(177, 355), new FlxPoint(191, 176), new FlxPoint(-249, 75)];
			dickVibeAngleArray[4] = [new FlxPoint(180, 355), new FlxPoint(240, 101), new FlxPoint(-190, 177)];
			dickVibeAngleArray[5] = [new FlxPoint(179, 355), new FlxPoint(255, -49), new FlxPoint( -125, 228)];
			
			electricPolyArray = new Array<Array<FlxPoint>>();
			electricPolyArray[0] = [new FlxPoint(174, 366), new FlxPoint(176, 337), new FlxPoint(196, 338), new FlxPoint(194, 366)];
			electricPolyArray[1] = [new FlxPoint(174, 366), new FlxPoint(176, 337), new FlxPoint(196, 338), new FlxPoint(194, 366)];
			electricPolyArray[2] = [new FlxPoint(174, 366), new FlxPoint(176, 337), new FlxPoint(196, 338), new FlxPoint(194, 366)];
			electricPolyArray[3] = [new FlxPoint(174, 366), new FlxPoint(176, 337), new FlxPoint(196, 338), new FlxPoint(194, 366)];
			electricPolyArray[4] = [new FlxPoint(174, 366), new FlxPoint(176, 337), new FlxPoint(196, 338), new FlxPoint(194, 366)];
			electricPolyArray[5] = [new FlxPoint(174, 366), new FlxPoint(176, 337), new FlxPoint(196, 338), new FlxPoint(194, 366)];
		}
		
		breathAngleArray[0] = [new FlxPoint(172, 195), new FlxPoint(-9, 80)];
		breathAngleArray[1] = [new FlxPoint(172, 195), new FlxPoint(-9, 80)];
		breathAngleArray[2] = [new FlxPoint(172, 195), new FlxPoint(-9, 80)];
		breathAngleArray[3] = [new FlxPoint(181, 189), new FlxPoint(10, 79)];
		breathAngleArray[4] = [new FlxPoint(181, 189), new FlxPoint(10, 79)];
		breathAngleArray[5] = [new FlxPoint(188, 221), new FlxPoint(13, 79)];
		breathAngleArray[6] = [new FlxPoint(188, 221), new FlxPoint(13, 79)];
		breathAngleArray[7] = [new FlxPoint(188, 221), new FlxPoint(13, 79)];
		breathAngleArray[12] = [new FlxPoint(103, 181), new FlxPoint(-72, 34)];
		breathAngleArray[13] = [new FlxPoint(103, 181), new FlxPoint(-72, 34)];
		breathAngleArray[14] = [new FlxPoint(103, 181), new FlxPoint(-72, 34)];
		breathAngleArray[15] = [new FlxPoint(175, 178), new FlxPoint(24, 76)];
		breathAngleArray[16] = [new FlxPoint(175, 178), new FlxPoint(24, 76)];
		breathAngleArray[17] = [new FlxPoint(175, 178), new FlxPoint(24, 76)];
		breathAngleArray[18] = [new FlxPoint(184, 221), new FlxPoint(12, 79)];
		breathAngleArray[19] = [new FlxPoint(184, 221), new FlxPoint(12, 79)];
		breathAngleArray[20] = [new FlxPoint(184, 221), new FlxPoint(12, 79)];
		breathAngleArray[36] = [new FlxPoint(177, 183), new FlxPoint(22, 77)];
		breathAngleArray[37] = [new FlxPoint(177, 183), new FlxPoint(22, 77)];
		breathAngleArray[38] = [new FlxPoint(177, 183), new FlxPoint(22, 77)];
		breathAngleArray[39] = [new FlxPoint(173, 190), new FlxPoint(-6, 80)];
		breathAngleArray[40] = [new FlxPoint(173, 190), new FlxPoint(-6, 80)];
		breathAngleArray[41] = [new FlxPoint(173, 190), new FlxPoint(-6, 80)];
		breathAngleArray[42] = [new FlxPoint(113, 192), new FlxPoint(-70, 39)];
		breathAngleArray[43] = [new FlxPoint(113, 192), new FlxPoint(-70, 39)];
		breathAngleArray[44] = [new FlxPoint(113, 192), new FlxPoint(-70, 39)];
		breathAngleArray[48] = [new FlxPoint(179, 222), new FlxPoint(9, 80)];
		breathAngleArray[49] = [new FlxPoint(179, 222), new FlxPoint(9, 80)];
		breathAngleArray[50] = [new FlxPoint(179, 222), new FlxPoint(9, 80)];
		breathAngleArray[51] = [new FlxPoint(179, 182), new FlxPoint(23, 77)];
		breathAngleArray[52] = [new FlxPoint(179, 182), new FlxPoint(23, 77)];
		breathAngleArray[53] = [new FlxPoint(179, 182), new FlxPoint(23, 77)];
		breathAngleArray[54] = [new FlxPoint(242, 124), new FlxPoint(76, -26)];
		breathAngleArray[55] = [new FlxPoint(242, 124), new FlxPoint(76, -26)];
		breathAngleArray[56] = [new FlxPoint(242, 124), new FlxPoint(76, -26)];
		breathAngleArray[60] = [new FlxPoint(102, 166), new FlxPoint(-79, 13)];
		breathAngleArray[61] = [new FlxPoint(102, 166), new FlxPoint(-79, 13)];
		breathAngleArray[62] = [new FlxPoint(106, 186), new FlxPoint(-72, 34)];
		breathAngleArray[63] = [new FlxPoint(106, 186), new FlxPoint(-72, 34)];
		breathAngleArray[64] = [new FlxPoint(172, 195), new FlxPoint(-9, 80)];
		breathAngleArray[65] = [new FlxPoint(172, 195), new FlxPoint(-9, 80)];
		
		torsoSweatArray = new Array<Array<FlxPoint>>();
		torsoSweatArray[0] = [new FlxPoint(189, 323), new FlxPoint(135, 293), new FlxPoint(142, 191), new FlxPoint(206, 192), new FlxPoint(227, 295)];
		torsoSweatArray[1] = [new FlxPoint(189, 323), new FlxPoint(135, 293), new FlxPoint(142, 191), new FlxPoint(206, 192), new FlxPoint(227, 295)];
		
		headSweatArray = new Array<Array<FlxPoint>>();
		headSweatArray[0] = [new FlxPoint(185, 146), new FlxPoint(168, 132), new FlxPoint(167, 96), new FlxPoint(140, 96), new FlxPoint(174, 68), new FlxPoint(224, 84), new FlxPoint(238, 118), new FlxPoint(217, 106), new FlxPoint(203, 140)];
		headSweatArray[1] = [new FlxPoint(185, 146), new FlxPoint(168, 132), new FlxPoint(167, 96), new FlxPoint(140, 96), new FlxPoint(174, 68), new FlxPoint(224, 84), new FlxPoint(238, 118), new FlxPoint(217, 106), new FlxPoint(203, 140)];
		headSweatArray[2] = [new FlxPoint(185, 146), new FlxPoint(168, 132), new FlxPoint(167, 96), new FlxPoint(140, 96), new FlxPoint(174, 68), new FlxPoint(224, 84), new FlxPoint(238, 118), new FlxPoint(217, 106), new FlxPoint(203, 140)];
		headSweatArray[3] = [new FlxPoint(182, 141), new FlxPoint(161, 133), new FlxPoint(155, 112), new FlxPoint(128, 110), new FlxPoint(128, 93), new FlxPoint(152, 74), new FlxPoint(195, 72), new FlxPoint(218, 88), new FlxPoint(221, 109), new FlxPoint(196, 112), new FlxPoint(194, 133)];
		headSweatArray[4] = [new FlxPoint(182, 141), new FlxPoint(161, 133), new FlxPoint(155, 112), new FlxPoint(128, 110), new FlxPoint(128, 93), new FlxPoint(152, 74), new FlxPoint(195, 72), new FlxPoint(218, 88), new FlxPoint(221, 109), new FlxPoint(196, 112), new FlxPoint(194, 133)];
		headSweatArray[5] = [new FlxPoint(202, 180), new FlxPoint(181, 161), new FlxPoint(184, 128), new FlxPoint(167, 116), new FlxPoint(155, 131), new FlxPoint(144, 125), new FlxPoint(158, 95), new FlxPoint(191, 91), new FlxPoint(222, 101), new FlxPoint(238, 129), new FlxPoint(219, 135), new FlxPoint(216, 164)];
		headSweatArray[6] = [new FlxPoint(202, 180), new FlxPoint(181, 161), new FlxPoint(184, 128), new FlxPoint(167, 116), new FlxPoint(155, 131), new FlxPoint(144, 125), new FlxPoint(158, 95), new FlxPoint(191, 91), new FlxPoint(222, 101), new FlxPoint(238, 129), new FlxPoint(219, 135), new FlxPoint(216, 164)];
		headSweatArray[7] = [new FlxPoint(202, 180), new FlxPoint(181, 161), new FlxPoint(184, 128), new FlxPoint(167, 116), new FlxPoint(155, 131), new FlxPoint(144, 125), new FlxPoint(158, 95), new FlxPoint(191, 91), new FlxPoint(222, 101), new FlxPoint(238, 129), new FlxPoint(219, 135), new FlxPoint(216, 164)];
		headSweatArray[8] = [new FlxPoint(215, 118), new FlxPoint(204, 119), new FlxPoint(198, 103), new FlxPoint(184, 101), new FlxPoint(163, 117), new FlxPoint(117, 115), new FlxPoint(121, 104), new FlxPoint(154, 72), new FlxPoint(200, 80), new FlxPoint(210, 95)];
		headSweatArray[9] = [new FlxPoint(215, 118), new FlxPoint(204, 119), new FlxPoint(198, 103), new FlxPoint(184, 101), new FlxPoint(163, 117), new FlxPoint(117, 115), new FlxPoint(121, 104), new FlxPoint(154, 72), new FlxPoint(200, 80), new FlxPoint(210, 95)];
		headSweatArray[10] = [new FlxPoint(215, 118), new FlxPoint(204, 119), new FlxPoint(198, 103), new FlxPoint(184, 101), new FlxPoint(163, 117), new FlxPoint(117, 115), new FlxPoint(121, 104), new FlxPoint(154, 72), new FlxPoint(200, 80), new FlxPoint(210, 95)];
		headSweatArray[12] = [new FlxPoint(213, 130), new FlxPoint(196, 129), new FlxPoint(191, 112), new FlxPoint(164, 110), new FlxPoint(157, 134), new FlxPoint(119, 138), new FlxPoint(119, 126), new FlxPoint(149, 81), new FlxPoint(192, 83), new FlxPoint(215, 108)];
		headSweatArray[13] = [new FlxPoint(213, 130), new FlxPoint(196, 129), new FlxPoint(191, 112), new FlxPoint(164, 110), new FlxPoint(157, 134), new FlxPoint(119, 138), new FlxPoint(119, 126), new FlxPoint(149, 81), new FlxPoint(192, 83), new FlxPoint(215, 108)];
		headSweatArray[14] = [new FlxPoint(213, 130), new FlxPoint(196, 129), new FlxPoint(191, 112), new FlxPoint(164, 110), new FlxPoint(157, 134), new FlxPoint(119, 138), new FlxPoint(119, 126), new FlxPoint(149, 81), new FlxPoint(192, 83), new FlxPoint(215, 108)];
		headSweatArray[15] = [new FlxPoint(185, 124), new FlxPoint(152, 131), new FlxPoint(141, 120), new FlxPoint(119, 129), new FlxPoint(124, 90), new FlxPoint(186, 73), new FlxPoint(208, 103), new FlxPoint(182, 108)];
		headSweatArray[16] = [new FlxPoint(185, 124), new FlxPoint(152, 131), new FlxPoint(141, 120), new FlxPoint(119, 129), new FlxPoint(124, 90), new FlxPoint(186, 73), new FlxPoint(208, 103), new FlxPoint(182, 108)];
		headSweatArray[17] = [new FlxPoint(185, 124), new FlxPoint(152, 131), new FlxPoint(141, 120), new FlxPoint(119, 129), new FlxPoint(124, 90), new FlxPoint(186, 73), new FlxPoint(208, 103), new FlxPoint(182, 108)];
		headSweatArray[18] = [new FlxPoint(202, 180), new FlxPoint(181, 161), new FlxPoint(184, 128), new FlxPoint(167, 116), new FlxPoint(155, 131), new FlxPoint(144, 125), new FlxPoint(158, 95), new FlxPoint(191, 91), new FlxPoint(222, 101), new FlxPoint(238, 129), new FlxPoint(219, 135), new FlxPoint(216, 164)];
		headSweatArray[19] = [new FlxPoint(202, 180), new FlxPoint(181, 161), new FlxPoint(184, 128), new FlxPoint(167, 116), new FlxPoint(155, 131), new FlxPoint(144, 125), new FlxPoint(158, 95), new FlxPoint(191, 91), new FlxPoint(222, 101), new FlxPoint(238, 129), new FlxPoint(219, 135), new FlxPoint(216, 164)];
		headSweatArray[20] = [new FlxPoint(202, 180), new FlxPoint(181, 161), new FlxPoint(184, 128), new FlxPoint(167, 116), new FlxPoint(155, 131), new FlxPoint(144, 125), new FlxPoint(158, 95), new FlxPoint(191, 91), new FlxPoint(222, 101), new FlxPoint(238, 129), new FlxPoint(219, 135), new FlxPoint(216, 164)];
		headSweatArray[24] = [new FlxPoint(222, 110), new FlxPoint(216, 97), new FlxPoint(176, 110), new FlxPoint(139, 104), new FlxPoint(172, 73), new FlxPoint(211, 81), new FlxPoint(231, 104)];
		headSweatArray[25] = [new FlxPoint(222, 110), new FlxPoint(216, 97), new FlxPoint(176, 110), new FlxPoint(139, 104), new FlxPoint(172, 73), new FlxPoint(211, 81), new FlxPoint(231, 104)];
		headSweatArray[26] = [new FlxPoint(202, 140), new FlxPoint(183, 144), new FlxPoint(167, 130), new FlxPoint(165, 115), new FlxPoint(137, 112), new FlxPoint(140, 94), new FlxPoint(178, 69), new FlxPoint(223, 86), new FlxPoint(239, 115), new FlxPoint(235, 131), new FlxPoint(208, 124)];
		headSweatArray[27] = [new FlxPoint(202, 140), new FlxPoint(183, 144), new FlxPoint(167, 130), new FlxPoint(165, 115), new FlxPoint(137, 112), new FlxPoint(140, 94), new FlxPoint(178, 69), new FlxPoint(223, 86), new FlxPoint(239, 115), new FlxPoint(235, 131), new FlxPoint(208, 124)];
		headSweatArray[28] = [new FlxPoint(213, 130), new FlxPoint(196, 129), new FlxPoint(191, 112), new FlxPoint(164, 110), new FlxPoint(157, 134), new FlxPoint(119, 138), new FlxPoint(119, 126), new FlxPoint(149, 81), new FlxPoint(192, 83), new FlxPoint(215, 108)];
		headSweatArray[29] = [new FlxPoint(213, 130), new FlxPoint(196, 129), new FlxPoint(191, 112), new FlxPoint(164, 110), new FlxPoint(157, 134), new FlxPoint(119, 138), new FlxPoint(119, 126), new FlxPoint(149, 81), new FlxPoint(192, 83), new FlxPoint(215, 108)];
		headSweatArray[36] = [new FlxPoint(185, 124), new FlxPoint(152, 131), new FlxPoint(140, 107), new FlxPoint(121, 116), new FlxPoint(126, 86), new FlxPoint(181, 69), new FlxPoint(203, 90), new FlxPoint(182, 96)];
		headSweatArray[37] = [new FlxPoint(185, 124), new FlxPoint(152, 131), new FlxPoint(140, 107), new FlxPoint(121, 116), new FlxPoint(126, 86), new FlxPoint(181, 69), new FlxPoint(203, 90), new FlxPoint(182, 96)];
		headSweatArray[38] = [new FlxPoint(185, 124), new FlxPoint(152, 131), new FlxPoint(140, 107), new FlxPoint(121, 116), new FlxPoint(126, 86), new FlxPoint(181, 69), new FlxPoint(203, 90), new FlxPoint(182, 96)];
		headSweatArray[39] = [new FlxPoint(185, 148), new FlxPoint(166, 132), new FlxPoint(167, 105), new FlxPoint(141, 99), new FlxPoint(175, 68), new FlxPoint(222, 85), new FlxPoint(240, 116), new FlxPoint(215, 112), new FlxPoint(203, 140)];
		headSweatArray[40] = [new FlxPoint(185, 148), new FlxPoint(166, 132), new FlxPoint(167, 105), new FlxPoint(141, 99), new FlxPoint(175, 68), new FlxPoint(222, 85), new FlxPoint(240, 116), new FlxPoint(215, 112), new FlxPoint(203, 140)];
		headSweatArray[41] = [new FlxPoint(185, 148), new FlxPoint(166, 132), new FlxPoint(167, 105), new FlxPoint(141, 99), new FlxPoint(175, 68), new FlxPoint(222, 85), new FlxPoint(240, 116), new FlxPoint(215, 112), new FlxPoint(203, 140)];
		headSweatArray[42] = [new FlxPoint(213, 130), new FlxPoint(196, 129), new FlxPoint(191, 112), new FlxPoint(164, 110), new FlxPoint(157, 134), new FlxPoint(119, 138), new FlxPoint(119, 126), new FlxPoint(149, 81), new FlxPoint(192, 83), new FlxPoint(215, 108)];
		headSweatArray[43] = [new FlxPoint(213, 130), new FlxPoint(196, 129), new FlxPoint(191, 112), new FlxPoint(164, 110), new FlxPoint(157, 134), new FlxPoint(119, 138), new FlxPoint(119, 126), new FlxPoint(149, 81), new FlxPoint(192, 83), new FlxPoint(215, 108)];
		headSweatArray[44] = [new FlxPoint(213, 130), new FlxPoint(196, 129), new FlxPoint(191, 112), new FlxPoint(164, 110), new FlxPoint(157, 134), new FlxPoint(119, 138), new FlxPoint(119, 126), new FlxPoint(149, 81), new FlxPoint(192, 83), new FlxPoint(215, 108)];
		headSweatArray[48] = [new FlxPoint(202, 180), new FlxPoint(181, 161), new FlxPoint(184, 128), new FlxPoint(167, 116), new FlxPoint(155, 131), new FlxPoint(144, 125), new FlxPoint(158, 95), new FlxPoint(191, 91), new FlxPoint(222, 101), new FlxPoint(238, 129), new FlxPoint(219, 135), new FlxPoint(216, 164)];
		headSweatArray[49] = [new FlxPoint(202, 180), new FlxPoint(181, 161), new FlxPoint(184, 128), new FlxPoint(167, 116), new FlxPoint(155, 131), new FlxPoint(144, 125), new FlxPoint(158, 95), new FlxPoint(191, 91), new FlxPoint(222, 101), new FlxPoint(238, 129), new FlxPoint(219, 135), new FlxPoint(216, 164)];
		headSweatArray[50] = [new FlxPoint(202, 180), new FlxPoint(181, 161), new FlxPoint(184, 128), new FlxPoint(167, 116), new FlxPoint(155, 131), new FlxPoint(144, 125), new FlxPoint(158, 95), new FlxPoint(191, 91), new FlxPoint(222, 101), new FlxPoint(238, 129), new FlxPoint(219, 135), new FlxPoint(216, 164)];
		headSweatArray[51] = [new FlxPoint(185, 124), new FlxPoint(152, 131), new FlxPoint(122, 126), new FlxPoint(125, 89), new FlxPoint(184, 73), new FlxPoint(206, 106)];
		headSweatArray[52] = [new FlxPoint(185, 124), new FlxPoint(152, 131), new FlxPoint(122, 126), new FlxPoint(125, 89), new FlxPoint(184, 73), new FlxPoint(206, 106)];
		headSweatArray[53] = [new FlxPoint(185, 124), new FlxPoint(152, 131), new FlxPoint(122, 126), new FlxPoint(125, 89), new FlxPoint(184, 73), new FlxPoint(206, 106)];
		headSweatArray[54] = [new FlxPoint(194, 109), new FlxPoint(172, 99), new FlxPoint(141, 104), new FlxPoint(171, 71), new FlxPoint(213, 78), new FlxPoint(230, 105), new FlxPoint(220, 110)];
		headSweatArray[55] = [new FlxPoint(194, 109), new FlxPoint(172, 99), new FlxPoint(141, 104), new FlxPoint(171, 71), new FlxPoint(213, 78), new FlxPoint(230, 105), new FlxPoint(220, 110)];
		headSweatArray[56] = [new FlxPoint(194, 109), new FlxPoint(172, 99), new FlxPoint(141, 104), new FlxPoint(171, 71), new FlxPoint(213, 78), new FlxPoint(230, 105), new FlxPoint(220, 110)];
		headSweatArray[60] = [new FlxPoint(215, 118), new FlxPoint(204, 119), new FlxPoint(198, 103), new FlxPoint(184, 101), new FlxPoint(163, 117), new FlxPoint(117, 115), new FlxPoint(121, 104), new FlxPoint(154, 72), new FlxPoint(200, 80), new FlxPoint(210, 95)];
		headSweatArray[61] = [new FlxPoint(215, 118), new FlxPoint(204, 119), new FlxPoint(198, 103), new FlxPoint(184, 101), new FlxPoint(163, 117), new FlxPoint(117, 115), new FlxPoint(121, 104), new FlxPoint(154, 72), new FlxPoint(200, 80), new FlxPoint(210, 95)];
		headSweatArray[62] = [new FlxPoint(213, 130), new FlxPoint(196, 129), new FlxPoint(191, 112), new FlxPoint(164, 110), new FlxPoint(157, 134), new FlxPoint(119, 138), new FlxPoint(119, 126), new FlxPoint(149, 81), new FlxPoint(192, 83), new FlxPoint(215, 108)];
		headSweatArray[63] = [new FlxPoint(213, 130), new FlxPoint(196, 129), new FlxPoint(191, 112), new FlxPoint(164, 110), new FlxPoint(157, 134), new FlxPoint(119, 138), new FlxPoint(119, 126), new FlxPoint(149, 81), new FlxPoint(192, 83), new FlxPoint(215, 108)];
		headSweatArray[64] = [new FlxPoint(187, 147), new FlxPoint(174, 137), new FlxPoint(160, 113), new FlxPoint(138, 110), new FlxPoint(139, 90), new FlxPoint(175, 68), new FlxPoint(222, 85), new FlxPoint(240, 120), new FlxPoint(235, 132), new FlxPoint(217, 126), new FlxPoint(205, 141)];
		headSweatArray[65] = [new FlxPoint(187, 147), new FlxPoint(174, 137), new FlxPoint(160, 113), new FlxPoint(138, 110), new FlxPoint(139, 90), new FlxPoint(175, 68), new FlxPoint(222, 85), new FlxPoint(240, 120), new FlxPoint(235, 132), new FlxPoint(217, 126), new FlxPoint(205, 141)];
		
		encouragementWords = wordManager.newWords();
		encouragementWords.words.push([ { graphic:GrovyleResource.wordsSmall, frame:0 } ]);
		encouragementWords.words.push([ { graphic:GrovyleResource.wordsSmall, frame:1 } ]);
		encouragementWords.words.push([ { graphic:GrovyleResource.wordsSmall, frame:2 } ]);
		encouragementWords.words.push([ { graphic:GrovyleResource.wordsSmall, frame:3 } ]);
		encouragementWords.words.push([ { graphic:GrovyleResource.wordsSmall, frame:4 } ]);
		encouragementWords.words.push([ { graphic:GrovyleResource.wordsSmall, frame:5 } ]);
		encouragementWords.words.push([ { graphic:GrovyleResource.wordsSmall, frame:6 } ]);
		encouragementWords.words.push([ { graphic:GrovyleResource.wordsSmall, frame:7 } ]);
		encouragementWords.words.push([ { graphic:GrovyleResource.wordsSmall, frame:8 } ]);
		
		boredWords = wordManager.newWords(6);
		boredWords.words.push([{ graphic:GrovyleResource.wordsSmall, frame:9 }]);
		boredWords.words.push([{ graphic:GrovyleResource.wordsSmall, frame:10 }]);
		boredWords.words.push([{ graphic:GrovyleResource.wordsSmall, frame:13 }]);
		// are you, err...?
		boredWords.words.push([
			{ graphic:GrovyleResource.wordsSmall, frame:11 },
			{ graphic:GrovyleResource.wordsSmall, frame:13, yOffset:18, delay:0.5 }
		]);
		// heh! are we... are we done?
		boredWords.words.push([
			{ graphic:GrovyleResource.wordsSmall, frame:12 },
			{ graphic:GrovyleResource.wordsSmall, frame:14, yOffset:18, delay:0.5 },
			{ graphic:GrovyleResource.wordsSmall, frame:16, yOffset:38, delay:1.0 }
		]);
		
		// mmm! someone's been studying their type effectiveness charts, haven't they~
		toyStartWords.words.push([
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:0, chunkSize:13},
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:2, chunkSize:13, yOffset:18, delay:0.8 },
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:4, chunkSize:13, yOffset:38, delay:1.6 },
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:6, chunkSize:13, yOffset:54, delay:2.4 },
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:8, chunkSize:13, yOffset:72, delay:3.2 },
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:10, chunkSize:13, yOffset:92, delay:4.0 },
		]);
		// ah very well! let's give this thing a try...
		toyStartWords.words.push([
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:1},
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:3, yOffset:20, delay:0.8 },
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:5, yOffset:36, delay:1.6 },
		]);
		// start slow if you would! ...i'm sensitive down there...
		toyStartWords.words.push([
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:7},
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:9, yOffset:20, delay:0.8 },
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:11, yOffset:38, delay:2.1 },
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:13, yOffset:54, delay:2.9 },
		]);
		
		toyStopWords = wordManager.newWords();
		// ahhhh... so what now...
		toyStopWords.words.push([
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:12, chunkSize:5, delay:-0.4},
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:14, chunkSize:5, yOffset:22, delay:0.8 },
		]);
		// oooough..... still tingly~
		toyStopWords.words.push([
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:15, chunkSize:5},
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:17, chunkSize:5, yOffset:18, delay:1.3 },
		]);
		// mmmmmyes~ more hands-on treatment...
		toyStopWords.words.push([
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:16, chunkSize:5},
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:18, yOffset:20, delay:2.3},
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:20, yOffset:36, delay:3.1},
		]);
		
		// oh? ...changed your mind?
		toyInterruptWords.words.push([
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:19},
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:21, yOffset:24, delay:0.8},
		]);
		// ah, hmm! perhaps another time~
		toyInterruptWords.words.push([
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:22},
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:24, yOffset:22, delay:1.3},
			{ graphic:AssetPaths.grovvibe_words_small__png, frame:26, yOffset:42, delay:1.9},
		]);
		
		pleasureWords = wordManager.newWords(8);
		pleasureWords.words.push([{ graphic:AssetPaths.grovyle_words_medium__png, frame:0, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.grovyle_words_medium__png, frame:1, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.grovyle_words_medium__png, frame:2, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.grovyle_words_medium__png, frame:3, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.grovyle_words_medium__png, frame:4, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.grovyle_words_medium__png, frame:5, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.grovyle_words_medium__png, frame:6, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.grovyle_words_medium__png, frame:7, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.grovyle_words_medium__png, frame:8, height:48, chunkSize:5 } ]);
		
		almostWords = wordManager.newWords(30);
		almostWords.words.push([ // ah, get... get ready for it-
			{ graphic:AssetPaths.grovyle_words_medium__png, frame:10, height:48, chunkSize:5 },
			{ graphic:AssetPaths.grovyle_words_medium__png, frame:12, height:48, chunkSize:5, yOffset:24, delay:1.0 }
		]);
		almostWords.words.push([ // just... a little more, i'm...
			{ graphic:AssetPaths.grovyle_words_medium__png, frame:13, height:48, chunkSize:4 },
			{ graphic:AssetPaths.grovyle_words_medium__png, frame:15, height:48, chunkSize:4, yOffset:20, delay:0.8 }
		]);
		almostWords.words.push([ // --here it's, i... i almooost...
			{ graphic:AssetPaths.grovyle_words_medium__png, frame:14, height:48, chunkSize:5 },
			{ graphic:AssetPaths.grovyle_words_medium__png, frame:16, height:48, chunkSize:5, yOffset:24, delay:1.2 }
		]);
		almostWords.words.push([ // goodness, i... i think i....
			{ graphic:AssetPaths.grovyle_words_medium__png, frame:9, height:48, chunkSize:5 },
			{ graphic:AssetPaths.grovyle_words_medium__png, frame:11, height:48, chunkSize:5, yOffset:24, delay:1.2 }
		]);
		
		orgasmWords = wordManager.newWords();
		orgasmWords.words.push([ { graphic:AssetPaths.grovyle_words_large__png, frame:0, width:200, height:150, yOffset:-30, chunkSize:5 } ]);	
		orgasmWords.words.push([ { graphic:AssetPaths.grovyle_words_large__png, frame:1, width:200, height:150, yOffset:-30, chunkSize:5 } ]);	
		orgasmWords.words.push([ { graphic:AssetPaths.grovyle_words_large__png, frame:2, width:200, height:150, yOffset:-30, chunkSize:5 } ]);	
		orgasmWords.words.push([ // ahHHHHhh- AAAaahHHHhh~
			{ graphic:AssetPaths.grovyle_words_large__png, frame:3, width:200, height:150, yOffset:-30, chunkSize:7 },
			{ graphic:AssetPaths.grovyle_words_large__png, frame:5, width:200, height:150, yOffset:-30, chunkSize:7, delay:0.8 }
		]);
		
		hurryUpWords = wordManager.newWords(10000000);
		hurryUpWords.words.push([ // come now, let's move things along...
			{ graphic:GrovyleResource.wordsSmall, frame:15 },
			{ graphic:GrovyleResource.wordsSmall, frame:17, yOffset:18, delay:0.8 },
			{ graphic:GrovyleResource.wordsSmall, frame:19, yOffset:32, delay:1.3 }
		]);
		hurryUpWords.words.push([ // let's speed things up a bit, shall we?
			{ graphic:GrovyleResource.wordsSmall, frame:18 },
			{ graphic:GrovyleResource.wordsSmall, frame:20, yOffset:18, delay:0.6 },
			{ graphic:GrovyleResource.wordsSmall, frame:22, yOffset:36, delay:1.2 }
		]);
		
		niceHurryWords = wordManager.newWords(10000000);
		niceHurryWords.words.push([ // ahh yes..... just like that, nngh~
			{ graphic:GrovyleResource.wordsSmall, frame:21 },
			{ graphic:GrovyleResource.wordsSmall, frame:23, yOffset:24, delay:0.6 },
			{ graphic:GrovyleResource.wordsSmall, frame:25, yOffset:36, delay:1.2 }
		]);
		niceHurryWords.words.push([ // ohhh now we're getting somewhere...
			{ graphic:GrovyleResource.wordsSmall, frame:27 },
			{ graphic:GrovyleResource.wordsSmall, frame:29, yOffset:18, delay:0.6 },
			{ graphic:GrovyleResource.wordsSmall, frame:31, yOffset:36, delay:1.2 }
		]);
		
		slowDownWords = wordManager.newWords(10000000);
		slowDownWords.words.push([ // what's... what's the hurry? ahh~
			{ graphic:GrovyleResource.wordsSmall, frame:24 },
			{ graphic:GrovyleResource.wordsSmall, frame:26, yOffset:18, delay:0.6 }
		]);
		slowDownWords.words.push([ // nnngg! n-no need to rush...
			{ graphic:GrovyleResource.wordsSmall, frame:28 },
			{ graphic:GrovyleResource.wordsSmall, frame:30, yOffset:20, delay:0.6 }
		]);
		
		hintWords = wordManager.newWords(10000000);
		if (grovyleMood2 == 0) {
			// strong hints
			if (_male) {
				if (desiredRubs[grovyleMood0][2] == "balls") {
					hintWords.words.push([ // m-my balls could... oogh...
						{ graphic:GrovyleResource.wordsSmall, frame:32 },
						{ graphic:GrovyleResource.wordsSmall, frame:34, yOffset:16, delay:0.7 }
					]);
				} else if (desiredRubs[grovyleMood0][2] == "ass") {
					hintWords.words.push([ // if you c-could... ah!... m-my ass...
						{ graphic:GrovyleResource.wordsSmall, frame:33 },
						{ graphic:GrovyleResource.wordsSmall, frame:35, yOffset:28, delay:0.8 }
					]);
				}
			} else {
				if (desiredRubs[grovyleMood0][1] == "dick") {
					hintWords.words.push([ // m-my pussy could... oogh...
						{ graphic:GrovyleResource.wordsSmall, frame:32 },
						{ graphic:GrovyleResource.wordsSmall, frame:34, yOffset:16, delay:0.7 }
					]);
				} else if (desiredRubs[grovyleMood0][1] == "ass") {
					hintWords.words.push([ // if you c-could... ah!... m-my ass...
						{ graphic:GrovyleResource.wordsSmall, frame:33 },
						{ graphic:GrovyleResource.wordsSmall, frame:35, yOffset:28, delay:0.8 }
					]);
				}
			}
		}
		if (grovyleMood2 == 1) {
			// weak hints
			hintWords.words.push([ // could you p-perhaps... ngh!
				{ graphic:GrovyleResource.wordsSmall, frame:36 },
				{ graphic:GrovyleResource.wordsSmall, frame:38, yOffset:18, delay:0.7 }
			]);
			hintWords.words.push([ // ~nnf! c-can you... nnnnf!!
				{ graphic:GrovyleResource.wordsSmall, frame:37 },
				{ graphic:GrovyleResource.wordsSmall, frame:39, yOffset:24, delay:0.7 }
			]);
		}
	}
	
	override function penetrating():Bool
	{
		if (specialRub == "ass") {
			return true;
		}
		if (!_male && specialRub == "jack-off") {
			return true;
		}
		if (!_male && specialRub == "rub-dick") {
			return true;
		}		
		return false;
	}
	
	override public function computeChatComplaints(complaints:Array<Int>):Void 
	{
		if (stolen.indexOf(_pokeWindow._dick) != -1) {
			complaints.push(0);
		}
		if (stolen.indexOf(_pokeWindow._balls) != -1) {
			complaints.push(1);
		}
		if (stolen.indexOf(_pokeWindow._ass) != -1) {
			complaints.push(2);
		}
		if (leftFootCount > rightFootCount * 2.5) {
			complaints.push(3);
		}
		if (rightFootCount > leftFootCount * 2.5) {
			complaints.push(4);
		}
		if (firstBadRub == _pokeWindow._dick) {
			complaints.push(5);
		}
		if (firstBadRub == _pokeWindow._balls) {
			complaints.push(6);
		}
		if (firstBadRub == _pokeWindow._ass) {
			complaints.push(7);
		}
		if (firstBadRub == _pokeWindow._feet) {
			complaints.push(8);
		}
	}
	
	override function generateCumshots():Void 
	{
		if ((desiredRub == "balls" || !_male && desiredRub == "ass") && niceThings[0] == false && niceThings[1] == false && niceThings[2] == false && rubbingIt) {
			cumTrait1 = 0;
			cumTrait3 = 5;
		}
		if (!came) {
			_heartBank._dickHeartReservoir = SexyState.roundUpToQuarter(heartPenalty * _heartBank._dickHeartReservoir);
			_heartBank._foreplayHeartReservoir = SexyState.roundUpToQuarter(heartPenalty * _heartBank._foreplayHeartReservoir);
		}
		if (addToyHeartsToOrgasm && _remainingOrgasms == 1) {
			_heartBank._dickHeartReservoir += _toyBank._dickHeartReservoir;
			_heartBank._dickHeartReservoir += _toyBank._foreplayHeartReservoir;
			
			_toyBank._dickHeartReservoir = 0;
			_toyBank._foreplayHeartReservoir = 0;
		}
		
		super.generateCumshots();
		
		// Grovyle's post-ejaculation faces need to go in a particular order
		for (cumshot in _cumShots) {
			var originalArousal = cumshot.arousal;
			if (originalArousal == 4) {
				cumshot.arousal = 2;
			} else if (originalArousal == 3 || originalArousal == 2) {
				cumshot.arousal = 4;
			}
		}
	}
	
	override function computePrecumAmount():Int
	{
		var precumAmount:Int = 0;
		if (displayingToyWindow()) {
			if (vibeGettingCloser) {
				precumAmount += 2;
			}
			if (FlxG.random.float(0, consecutiveVibeCount) >= 2.5) {
				precumAmount++;
			}
			if (FlxG.random.float(1, 16) < _heartEmitCount) {
				precumAmount++;
			}
			if (Math.pow(FlxG.random.float(0, 1.0), 1.5) >= _heartBank.getDickPercent()) {
				precumAmount++;
			}
			return precumAmount;
		}
		if (FlxG.random.float(1, 16) < _heartEmitCount) {
			precumAmount++;
		}
		if (FlxG.random.float(1, 48) < _heartEmitCount) {
			precumAmount++;
		}
		if (specialRub == "left-foot" && leftFootCount <= rightFootCount || specialRub == "right-foot" && rightFootCount <= leftFootCount) {
			precumAmount++;
		}
		if (Math.pow(FlxG.random.float(0, 1.0), 1.5) >= _heartBank.getDickPercent()) {
			precumAmount++;
		}
		return precumAmount;
	}
	
	override function getSpoogeSource():FlxSprite {
		return displayingToyWindow() ? _pokeWindow._vibe.dickVibe : _dick;
	}
	
	override function getSpoogeAngleArray():Array<Array<FlxPoint>> {
		return displayingToyWindow() ? dickVibeAngleArray : dickAngleArray;
	}
	
	override function handleRubReward():Void 
	{
		// punish the player if they skip to the genitals too quickly
		if (grovyleMood1 > 0) {
			if (specialRub == "rub-dick" || specialRub == "jack-off" || specialRub == "ass" || specialRub == "balls" || specialRub == "left-foot" || specialRub == "right-foot") {
				if (meanThings[0] == true) {
					firstBadRub = _rubBodyAnim._flxSprite;
					meanThings[0] = false;
					doMeanThing();
					impatientTimer -= 16;
					heartPenalty *= 0.8;
				}
			}
		}
		grovyleMood1--;
		if (grovyleMood1 == 0) {
			_newHeadTimer = Math.min(_newHeadTimer, _rubRewardFrequency * FlxG.random.float(0.2, 0.5));
		}
		
		// punish the player if they take too long
		if (impatientTimer <= 0) {
			if (hurryUpWords.timer <= 0) {
				// don't tell people "thanks for speeding up" right away. wait 5+ seconds
				niceHurryWords.timer = Math.max(niceHurryWords.timer, 4);
				almostWords.timer = Math.max(almostWords.timer, 1);
			}
			maybeEmitWords(hurryUpWords);
		}
		if (hurryUpWords.timer > 0) {
			heartPenalty *= 0.96;
		}
		impatientTimer -= 10;
		if (specialRub == "rub-dick" || specialRub == "jack-off" || specialRub == "ass" || specialRub == "balls") {
		} else {
			impatientTimer += 18;
		}
		
		// if the player jacks off too fast...
		var speedBoost:Float = 1.0;
		if (specialRub == "jack-off" || specialRub == "rub-dick") {
			var mean:Float = SexyState.average(mouseTiming.slice( -4, mouseTiming.length));
			mouseTiming.splice(0, mouseTiming.length - 4);
			var tmp = 0.16;
			while (mean < tmp) {
				heartPenalty *= 0.99;
				speedBoost += 0.6;
				impatientTimer += 3;
				tmp -= 0.02;
			}
		}
		if (speedBoost > 1.0 && hurryUpWords.timer > 0 && almostWords.timer <= 0) {
			if (niceHurryWords.timer <= 0) {
				almostWords.timer = Math.max(almostWords.timer, 1);
			}
			maybeEmitWords(niceHurryWords);
		}
		if (speedBoost > 2.0 && hurryUpWords.timer <= 0 && slowDownWords.timer <= 0 && almostWords.timer <= 0) {
			// what's the rush?
			maybeEmitWords(slowDownWords);
			impatientTimer += 100;
			heartPenalty *= 0.78;
		}
		
		// punish unbalanced feet
		if (specialRub == "left-foot") {
			leftFootCount++;
		}
		if (specialRub == "right-foot") {
			rightFootCount++;
		}
		if (leftFootCount > rightFootCount * 2.5 || rightFootCount > leftFootCount * 2.5) {
			// rubbing one foot a whole lot!!
			var recentFoot = Math.max(specialRubs.lastIndexOf("left-foot"), specialRubs.lastIndexOf("right-foot"));
			if (recentFoot > -1 && recentFoot < specialRubs.length - 6) {
				footPenaltyTimer -= _rubRewardFrequency;
				if (footPenaltyTimer <= 0) {
					footPenaltyTimer += 8;
					heartPenalty *= 0.96;
				}
			}
		}
		
		rubbingIt = false;
		if (desiredRub != null) {
			var nice:Bool = false;
			if (desiredRub == "dick" && (specialRub == "rub-dick" || specialRub == "jack-off")) {
				nice = true;
			} else if (desiredRub == "ass" && specialRub == "ass") {
				nice = true;
			} else if (desiredRub == "balls" && specialRub == "balls") {
				nice = true;
			} else {
				if (specialRub == "rub-dick" || (specialRub == "jack-off" && selfTouchCount != 3) || specialRub == "ass" || specialRub == "balls") {
					// not what he wanted
					impatientTimer -= 6;
					_selfRubLimit -= _rubRewardFrequency * FlxG.random.float(0.75, 1.25);
				}
			}
			rubbingIt = nice;
			if (rubbingIt) {
				scheduleSweat(FlxG.random.int(2, 4));
				if (FlxG.random.float(0, 1) > _autoSweatRate) {
					_autoSweatRate += 0.02;
				}
			}
			if (nice && selfTouchCount > 1 && specialRubsInARow() < 2) {
				// need to rub it twice in a row for the last couple
				nice = false;
				_selfRubLimit += _rubRewardFrequency * FlxG.random.float(0.5, 1.00);
			}
			if (nice && niceThings[selfTouchCount - 1] == true) {
				emitWords(pleasureWords);
				doNiceThing();
				_selfRubLimit += 1;
				niceThings[selfTouchCount - 1] = false;
			}
			if (nice) {
				if (selfTouchCount == 1) {
					impatientTimer += 4;
					_selfRubLimit += _rubRewardFrequency * FlxG.random.float(0, 0.30);
				} else if (selfTouchCount == 2) {
					impatientTimer += 8;
					_selfRubLimit += _rubRewardFrequency * FlxG.random.float(0, 0.60);
				} else {
					impatientTimer += 12;
					_selfRubLimit += _rubRewardFrequency * (FlxG.random.float(0.40, 0.80));
					if (!niceThings[0] && !niceThings[1] && !niceThings[2] && (_male || grovyleMood0 % 2 == 0)) {
						_selfRubLimit += _rubRewardFrequency * 0.4;
					}
				}
			}
			if (rubbingIt && (selfTouchCount == 3 || !_male && selfTouchCount == 2) && _pokeWindow._arousal == 3) {
				_newHeadTimer = FlxG.random.float(0, 0.5);
			}
			if (nice && (selfTouchCount == 3 || !_male && selfTouchCount == 2)) {
				selfTouchCount++;
				if (desiredRub == "dick") {
					// happy you rubbed his dick; so he fingers his ass
					selfFingerAss();
				} else if (desiredRub == "ass") {
					if (_male) {
						// happy you rubbed his ass; so he rubs his balls
						selfRubBalls();
					} else {
						// happy you rubbed her ass; so she fingers her vagina
						selfRubDick();
					}
				} else if (desiredRub == "balls") {
					// happy you rubbed his balls; so he rubs his dick
					selfRubDick();
				}
			}			
		}
		
		if (specialRub == "ass") {
			_assTightness *= FlxG.random.float(0.72, 0.82);
			updateAssFingeringAnimation();
			if (!_male && _rubBodyAnim2 != null) {
				_rubBodyAnim2.refreshSoon();
			}
			if (_rubBodyAnim != null) {
				_rubBodyAnim.refreshSoon();
			}
			if (_rubHandAnim != null) {
				_rubHandAnim.refreshSoon();
			}
		}
		
		if (!_male && (specialRub == "rub-dick" || specialRub == "jack-off")) {
			_vagTightness *= specialRub == "rub-dick" ? 0.7 : 0.55;
			updateVagFingeringAnimation();
			if (_rubBodyAnim != null) {
				_rubBodyAnim.refreshSoon();
			}
			if (_rubHandAnim != null) {
				_rubHandAnim.refreshSoon();
			}
		}
		
		if (selfTouchCount < 2) {
			if (specialRub == "") {
				// rubbing something innocuous
				selfTouchSoon--;
			}
			
			if (specialRub == "left-foot" || specialRub == "right-foot") {
				selfTouchSoon -= 10;
			}
			
			if (specialRub == "balls") {
				if (selfTouchSoon > 0) {
					selfTouchSoon = Std.int(Math.max(1, selfTouchSoon - 3));
				}
			}
			
			if (!_male && specialRub == "thigh") {
				selfTouchSoon -= 3;
			}
			
			if (specialRub == "ass") {
				if (selfTouchSoon > 0) {
					selfTouchSoon = Std.int(Math.max(1, selfTouchSoon - 1));
				}
			}
		}
		
		if (_male && selfTouchCount == 2) {
			if (specialRub == "jack-off") {
				selfTouchSoon--;
			}
		}
		
		if (selfTouchSoon > -1000 && selfTouchSoon <= 0 && grovyleMood1 <= 0) {
			selfTouchSoon = -1000;
			
			selfTouchCount++;
			desiredRub = desiredRubs[grovyleMood0][selfTouchCount - 1];
			_selfRubTimer = 0;
			_selfRubLimit = FlxG.random.float(9.2, 11.6);
			if ((_male && selfTouchCount == 3) || (!_male && selfTouchCount == 2)) {
				// maybe emit a hint word (not always)
				maybeEmitWords(hintWords);
				_newHeadTimer = Math.min(_newHeadTimer, FlxG.random.float(0.2, 0.5));
			} else if (desiredRub == "dick") {
				// wants you to rub his dick; so he fingers his ass
				selfFingerAss();
			} else if (desiredRub == "ass") {
				if (_male) {
					// wants you to rub his ass; so he rubs his balls
					selfRubBalls();
				} else {
					// wants you to rub his ass; so she fingers her vagina
					selfRubDick();
				}
			} else if (desiredRub == "balls") {
				// wants you to rub his balls; so he rubs his dick
				selfRubDick();
			}
		}		
		
		var amount:Float = 0;
		if ((desiredRub == "balls" || !_male) && niceThings[0] == false && niceThings[1] == false && niceThings[2] == false && rubbingIt) {
			var lucky:Float = lucky(0.7, 1.43, 0.05);
			lucky = Math.min(1.0, lucky * speedBoost);
			amount = SexyState.roundUpToQuarter(lucky * _heartBank._dickHeartReservoir);
			_heartBank._dickHeartReservoir -= amount;
			_heartBank._foreplayHeartReservoir += amount;
			if (_remainingOrgasms > 0 && _heartBank.getDickPercent() < 0.41 && !isEjaculating()) {
				maybeEmitWords(almostWords);
				impatientTimer = 10000;
			}
		}
		if (specialRub == "jack-off") {
			var lucky:Float = lucky(0.7, 1.43, 0.10);
			
			lucky = Math.min(1.0, lucky * speedBoost);
			amount = SexyState.roundUpToQuarter(lucky * _heartBank._dickHeartReservoir);
			_heartBank._dickHeartReservoir -= amount;
			amount = SexyState.roundUpToQuarter(heartPenalty * amount);
			if (_remainingOrgasms > 0 && _heartBank.getDickPercent() < 0.41 && !isEjaculating()) {
				maybeEmitWords(almostWords);
				impatientTimer = 10000;
			}
			_heartEmitCount += amount;
		} else {
			var lucky:Float = lucky(0.7, 1.43, 0.07);
			lucky = Math.min(1.0, lucky * speedBoost);
			if (specialRub == "left-foot" || specialRub == "right-foot") {
				lucky *= 2.4;
			} else if (specialRub == "balls") {
				lucky *= 1.7;
			} else if (specialRub == "ass") {
				if (_assTightness > 3.5) {
					lucky *= 0.4;
				} else if (_assTightness > 2.5) {
					lucky *= 0.8;
				} else if (_assTightness > 1.5) {
					lucky *= 1.3;
				} else if (_assTightness > 0.5) {
					lucky *= 1.9;
				} else {
					lucky *= 2.6;
				}
			}
			amount = SexyState.roundUpToQuarter(lucky * _heartBank._foreplayHeartReservoir);
			_heartBank._foreplayHeartReservoir -= amount;
			amount = SexyState.roundUpToQuarter(heartPenalty * amount);
			_heartEmitCount += amount;
		}
		
		emitCasualEncouragementWords();
		if (_heartEmitCount > 0) {
			maybeScheduleBreath();
			maybePlayPokeSfx();
			maybeEmitPrecum();
		}
	}
	
	/**
	 * The player's interrupted Grovyle by interacting with a body part she's
	 * currently touching. Rude!
	 */
	function takeFromGrovyle():Void 
	{
		stolen.push(_pokeWindow._selfTouchTarget);
		if (!isEjaculating() && meanThings[1] == true) {
			meanThings[1] = false;
			doMeanThing();
			impatientTimer -= 16;
		}
		desiredRub = null;
		stopTouchingSelf();
	}	
	
	private function updateAssFingeringAnimation():Void {
		var tightness0:Int = 3;
		
		if (_assTightness > 2.4) {
			tightness0 = 3;
		} else if (_assTightness > 1.1) {
			tightness0 = 4;
		} else {
			tightness0 = 5;
		}
		
		if (!_male) {
			_pokeWindow._dick.animation.add("finger-ass", [0, 6, 6, 7, 7].slice(0, tightness0));
		}
		_pokeWindow._ass.animation.add("finger-ass", [0, 1, 2, 3, 4].slice(0, tightness0));
		_pokeWindow._interact.animation.add("finger-ass", [16, 17, 18, 19, 20].slice(0, tightness0));
	}
	
	private function updateVagFingeringAnimation():Void 
	{
		var tightness0:Int = 3;
		
		if (_vagTightness > 2.4) {
			tightness0 = 3;
		} else if (_vagTightness > 1.1) {
			tightness0 = 4;
		} else {
			tightness0 = 5;
		}
		
		_pokeWindow._dick.animation.add("rub-dick", [1, 2, 3, 4, 5].slice(0, tightness0));
		_pokeWindow._interact.animation.add("rub-dick", [32, 33, 34, 35, 36].slice(0, tightness0));
		_pokeWindow._dick.animation.add("jack-off", [8, 9, 10, 11, 12, 13].slice(0, tightness0 + 1));
		_pokeWindow._interact.animation.add("jack-off", [40, 41, 42, 43, 44, 45].slice(0, tightness0 + 1));
	}
	
	function selfRub(target:BouncySprite) {
		if (fancyRubbing(target)) {
			interactOff();
		}
		_pokeWindow.stopTouchingSelf();
		if (_armsAndLegsArranger._armsAndLegsTimer < 1.5) {
			_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(1.5, 3);
		}		
		_pokeWindow.startTouchingSelf(target);
	}
	
	function selfFingerAss():Void 
	{
		if (_heartBank.getForeplayPercent() >= 1.0) {
			// not aroused; won't finger himself
			return;
		}
		selfRub(_pokeWindow._ass);
		_pokeWindow._arms1.animation.play("self-ass", true);
		_pokeWindow._ass.animation.play("self-ass", true);
		if (!_male) {
			if (fancyRubbing(_pokeWindow._dick)) {
				// can't start vagina-squishing animation; player is rubbing our vagina
				if (_dick.animation.name == "jack-off") {
					// player is really hammering vagina; these animations don't play together
					_rubBodyAnim.setAnimName("rub-dick");
					_rubHandAnim.setAnimName("rub-dick");
				}
			} else {
				_pokeWindow._dick.animation.play("self-ass", true);
			}
		}
		if (_assTightness > 3) {
			_assTightness = 3;
			updateAssFingeringAnimation();
		}
	}
	
	function selfRubBalls():Void 
	{
		if (_heartBank.getForeplayPercent() >= 1.0) {
			// not aroused; won't rub his own balls
			return;
		}
		selfRub(_pokeWindow._balls);
		_pokeWindow._arms1.animation.play("self-balls", true);
		_pokeWindow._balls.animation.play("self-balls", true);
	}
	
	function selfRubDick():Void 
	{
		if (_heartBank.getForeplayPercent() >= 1.0) {
			// not aroused; won't jerk himself off
			return;
		}
		selfRub(_pokeWindow._dick);
		_pokeWindow._arms1.animation.play("self-dick", true);
		_pokeWindow._dick.animation.play("self-dick", true);
		
		if (!_male && fancyRubbing(_pokeWindow._ass)) {
			// player is rubbing our ass, causing the vagina-squish animation -- terminate the animation
			_rubBodyAnim2 = null;
		}
		if (!_male && _vagTightness > 3) {
			_vagTightness = 3;
			updateVagFingeringAnimation();
		}
	}
	
	function stopTouchingSelf():Void 
	{
		if (!_male && _dick.animation.name == "rub-dick" && pastBonerThreshold() && _gameState == 200) {
			// we were gently fingering her vagina because the real animations don't play well together... switch back
			_rubBodyAnim.setAnimName("jack-off");
			_rubHandAnim.setAnimName("jack-off");
		}
		if (!_male && _pokeWindow._selfTouchTarget == _pokeWindow._ass && _dick.animation.name == "self-ass") {
			// we were fingering our own ass... cancel the "squish vagina" animation
			_dick.animation.play("default");
		}
		var squishVagina:Bool = false;
		if (!_male && _pokeWindow._selfTouchTarget == _dick && fancyRubbing(_pokeWindow._ass)) {
			// player is fingering our ass; we need to restore the "squish vagina" animation
			squishVagina = true;
		}
		_pokeWindow.stopTouchingSelf();
		// if grovyle starts rubbing himself when he's soft, but becomes hard, we need to reset the inactive dick animation to "hard"
		updateDefaultDickAnimation();
		if (squishVagina) {
			// stopped touching vagina; and player is rubbing our ass... need to restore the "squish vagina" animation
			_rubBodyAnim2 = new FancyAnim(_dick, "finger-ass");
			_rubBodyAnim2.synchronize(_rubBodyAnim);
		}
		if (_armsAndLegsArranger._armsAndLegsTimer < 1.5) {
			_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(1.5, 3);
		}
		if (selfTouchCount == 1) {
			selfTouchSoon = _male ? 9 : 13;
		} else if (_male && selfTouchCount == 2) {
			selfTouchSoon = 2;
		}
	}
	
	function updateDefaultDickAnimation():Void
	{
		if (_male && _dick.animation.name != "self-dick") {
			if (_gameState >= 400) {
			} else if (pastBonerThreshold()) {
				if (_dick.animation.frameIndex != 5) {
					_dick.animation.add("default", [5]);
				}
			} else if (_heartBank.getForeplayPercent() < 0.6) {
				if (_dick.animation.frameIndex != 1) {
					_dick.animation.add("default", [1]);
				}
			} else {
				if (_dick.animation.frameIndex != 0) {
					_dick.animation.add("default", [0]);
				}
			}
		}
	}
	
	function setInactiveDickAnimation():Void 
	{
		updateDefaultDickAnimation();
		if (_male && _dick.animation.name != "self-dick") {
			if (_gameState >= 400) {
				if (_dick.animation.name != "finished") {
					_dick.animation.add("finished", [1, 1, 1, 1, 0], 1, false);
					_dick.animation.play("finished");
				}
			} else if (pastBonerThreshold()) {
				if (_dick.animation.frameIndex != 5) {
					_dick.animation.play("default");
				}
			} else if (_heartBank.getForeplayPercent() < 0.6) {
				if (_dick.animation.frameIndex != 1) {
					_dick.animation.play("default");
				}
			} else {
				if (_dick.animation.frameIndex != 0) {
					_dick.animation.play("default");
				}
			}
		}
	}
	
	override public function reinitializeHandSprites() 
	{
		super.reinitializeHandSprites();
		
		_pokeWindow._ass.animation.add("finger-ass", [0, 1]);
		_pokeWindow._interact.animation.add("finger-ass", [16, 17]);
		
		if (!_male) {
			// vagina squishes when fingering ass
			_pokeWindow._dick.animation.add("finger-ass", [0, 6]);
			
			// vagina starts out tight
			_pokeWindow._dick.animation.add("rub-dick", [1, 2]);
			_pokeWindow._interact.animation.add("rub-dick", [32, 33]);
			_pokeWindow._dick.animation.add("jack-off", [8, 9]);
			_pokeWindow._interact.animation.add("jack-off", [40, 41]);
		}
	}
	
	override public function eventShowToyWindow(args:Array<Dynamic>) {
		super.eventShowToyWindow(args);
		
		_pokeWindow.setVibe(true);
		if (!_male) {
			_pokeWindow._vibe.loadShadow(_shadowGloveBlackGroup, AssetPaths.grovyle_dick_vibe_shadow_f__png);
		}
	}
	
	override public function eventHideToyWindow(args:Array<Dynamic>) {
		super.eventHideToyWindow(args);
		
		_pokeWindow.setVibe(false);
		if (!_male) {
			_pokeWindow._vibe.unloadShadow(_shadowGloveBlackGroup);
		}
	}
	
	override public function back():Void 
	{
		/* 
		 * if the foreplayHeartReservoir is empty (or half empty), empty the
		 * dick heart reservoir too -- that way the toy meter won't stay full.
		 */
		_toyBank._dickHeartReservoir = Math.min(_toyBank._dickHeartReservoir, SexyState.roundDownToQuarter(_toyBank._defaultDickHeartReservoir * _toyBank.getForeplayPercent()));
		
		super.back();
	}
	
	override function cursorSmellPenaltyAmount():Int {
		return 25;
	}
	
	override public function destroy():Void {
		super.destroy();
		
		ballOpacityTween = FlxTweenUtil.destroy(ballOpacityTween);
		assPolyArray = null;
		vagPolyArray = null;
		tailAssPolyArray = null;
		leftCalfPolyArray = null;
		rightCalfPolyArray = null;
		electricPolyArray = null;
		torsoSweatArray = null;
		headSweatArray = null;
		desiredRubs = null;
		niceThings = null;
		meanThings = null;
		hurryUpWords = null;
		niceHurryWords = null;
		slowDownWords = null;
		hintWords = null;
		toyStopWords = null;
		stolen = null;
		firstBadRub = FlxDestroyUtil.destroy(firstBadRub);
		_beadButton = FlxDestroyUtil.destroy(_beadButton);
		_elecvibeButton = FlxDestroyUtil.destroy(_elecvibeButton);
		_vibeButton = FlxDestroyUtil.destroy(_vibeButton);
		_toyInterface = FlxDestroyUtil.destroy(_toyInterface);
		goodVibes = null;
		dickVibeAngleArray = null;
		unguessedVibeSettings = null;
		lastFewVibeSettings = null;
		perfectVibeChoices = null;
	}
}