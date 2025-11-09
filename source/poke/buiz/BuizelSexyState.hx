package poke.buiz;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import poke.buiz.BuizelWindow;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxDestroyUtil;
import kludge.LateFadingFlxParticle;
import openfl.utils.Object;
import poke.sexy.BlobbyGroup;
import poke.sexy.FancyAnim;
import poke.sexy.SexyState;
import poke.sexy.WordManager;
import poke.sexy.WordManager.Qord;
import poke.sexy.WordParticle;

/**
 * Sex sequence for Buizel
 * 
 * Buizel has a slight hair trigger, so if you start rubbing her pussy too
 * early, she'll get set off. It's better to warm her up first.
 * 
 * Buizel has six parts of her body she likes rubbed: her ass, both of her
 * thighs, her chest, head, and her little floof on top of her head. Of these
 * six, four of these areas will be especially sensitive at any given time.
 * After rubbing about 3 of her sensitive areas, she'll start blushing. If you
 * continue rubbing that third sensitive part, she'll really like you and
 * she'll moan out something pleasurable like "bwooohHHHH~".
 * 
 * After rubbing those three sensitive parts, she likes if you rub her pussy
 * a little, penetrating it with a few fingers. You might need to loosen her
 * up first.
 * 
 * After fingering her for a bit, she'll be ready for more attention to her
 * body. If you focus on her fourth sensitive part, she'll eventually start
 * blushing. This can be tedious to narrow down, but her ass is always
 * sensitive. So, it's good to save that one for last so you're not left
 * searching her body for which part eventually makes her blush.
 * 
 * If you ever start fingering her pussy without finding her special spots
 * first, she'll cum much faster but it won't be a very strong orgasm.
 * 
 * Buizel also dislikes having her tube rubbed, so don't touch it. It's cute,
 * but don't do it!
 * 
 * Buizel likes the blue and gummy dildos. She enjoys both vaginal and anal
 * sex.
 * 
 * There are four things you can do with the toy window -- tease her entrance
 * with your fingers, finger her, tease her entrance with a dildo, and cram it
 * all the way in. Buizel likes it when you do these four things in that exact
 * order -- but, at some point, she will need you to pause and go back a step.
 * 
 * To tell when she wants you to go back a step, you should watch her tails,
 * which will droop. When her tails droop, you should go back to the previous
 * thing you were doing. So for example, you might tease her entrance, and
 * start fingering her -- but her tails droop, so then you need to go back and
 * tease her entrance again a little before fingering her.
 * 
 * Buizel doesn't like if you go too fast with the dildo, so watch your pace.
 * 
 * After cramming the dildo in all the way, she might cum pretty quickly -- but
 * she should be capable of having multiple orgasms, so you can either keep
 * going with the dildo or swap back to the glove.
 */
class BuizelSexyState extends SexyState<BuizelWindow>
{
	private var ballOpacityTween:FlxTween;
	private var dickOpacityTween:FlxTween;

	private var neckWords:Qord;
	private var notReadyWords:Qord;

	// areas that animate when you click them
	private var rightBallPolyArray:Array<Array<FlxPoint>>;
	private var assPolyArray:Array<Array<FlxPoint>>;
	private var floofPolyArray:Array<Array<FlxPoint>>;
	private var leftThighPolyArray:Array<Array<FlxPoint>>;
	private var rightThighPolyArray:Array<Array<FlxPoint>>;
	private var vagPolyArray:Array<Array<FlxPoint>>;

	private var _assTightness:Float = 5;

	private var sensitivityArray:Array<Float> = [];
	private var sensitivity:Int = 5;
	private var specialSpots:Array<String> = ["ass1", "left-thigh", "right-thigh", "left-ball", "right-ball", "chest", "head", "floof"];
	private var specialSpotCount:Int = 0;

	/*
	 * meanThings[0] = rubbing buizel's tube
	 * meanThings[1] = focused on buizel's genitals, and not her special spot
	 */
	private var meanThings:Array<Bool> = [true, true];
	private var readyForJackOff:Bool = false;
	private var blushTimer:Float = 0;

	private var toyWindow:BuizelDildoWindow;
	private var toyInterface:BuizelDildoInterface;

	private var newTailsTimer:Float = 7.5;
	private var pleasurableDildoBank:Float = 0;
	private var pleasurableDildoBankCapacity:Float = 0;
	private var ambientDildoBank:Float = 0;
	private var ambientDildoBankCapacity:Float = 0;
	private var ambientDildoBankTimer:Float = 0;
	private var prevToyHandAnim:String = "";
	private var rubHandAnimToToyStr:Map<String, String> = [
				"rub-vag" => "0",
				"finger-vag" => "1",
				"dildo-vag0" => "2",
				"dildo-vag1" => "3",
				"rub-ass" => "0",
				"finger-ass" => "1",
				"dildo-ass0" => "2",
				"dildo-ass1" => "3"
			];
	private var addToyHeartsToOrgasm:Bool = false;
	private var previousToyStr:String;
	private var toyOnTrack:Bool = true;
	private var toyPattern:Array<String>;
	private var remainingToyPattern:Array<String>;
	private var shortestToyPatternLength:Int = 9999;
	private var toyPrecumTimer:Float = 0;
	private var toyMessUpCount:Int = 0;
	private var bonusDildoOrgasmTimer:Int = -1;
	private var dildoUtils:DildoUtils;
	private var xlDildoButton:FlxButton;

	override public function create():Void
	{
		prepare("buiz");

		// Shift Buizel down so he's framed in the window better
		_pokeWindow.shiftVisualItems(40);

		toyWindow = new BuizelDildoWindow(256, 0, 248, 426);
		toyInterface = new BuizelDildoInterface();
		toyGroup.add(toyWindow);
		toyGroup.add(toyInterface);
		dildoUtils = new DildoUtils(this, toyInterface, toyWindow._ass, toyWindow._dick, toyWindow._dildo, toyWindow._interact);
		dildoUtils.refreshDildoAnims = refreshDildoAnims;
		dildoUtils.dildoFrameToPct = [
			1 => 0.00,
			2 => 0.11,
			3 => 0.22,
			4 => 0.33,
			5 => 0.44,
			6 => 0.55,
			7 => 0.66,
			8 => 0.77,
			9 => 0.88,
			10 => 1.00,

			12 => 0.00,
			13 => 0.11,
			14 => 0.22,
			15 => 0.33,
			16 => 0.44,
			17 => 0.55,
			18 => 0.66,
			19 => 0.77,
			20 => 0.88,
			21 => 1.00,
		];

		super.create();

		if (!_male)
		{
			specialSpots.remove("left-ball");
			specialSpots.remove("right-ball");
			specialSpotCount += 2;
		}
		specialSpots.splice(FlxG.random.int(1, specialSpots.length - 1), 1);
		specialSpots.splice(FlxG.random.int(1, specialSpots.length - 1), 1);

		_cumThreshold = 0.5;
		_bonerThreshold = 0.6;

		decreaseSensitivity();

		sfxEncouragement = [AssetPaths.buiz0__mp3, AssetPaths.buiz1__mp3, AssetPaths.buiz2__mp3, AssetPaths.buiz3__mp3];
		sfxPleasure = [AssetPaths.buiz4__mp3, AssetPaths.buiz5__mp3, AssetPaths.buiz6__mp3];
		sfxOrgasm = [AssetPaths.buiz7__mp3, AssetPaths.buiz8__mp3, AssetPaths.buiz9__mp3];

		popularity = 0.4;
		cumTrait0 = 2;
		cumTrait1 = 9;
		cumTrait2 = 5;
		cumTrait3 = 6;
		cumTrait4 = 1;
		_rubRewardFrequency = 2.6;

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_BLUE_DILDO))
		{
			var _blueDildoButton:FlxButton = newToyButton(blueDildoButtonEvent, AssetPaths.dildo_blue_button__png, _dialogTree);
			addToyButton(_blueDildoButton);
		}

		if (ItemDatabase.playerHasUneatenItem(ItemDatabase.ITEM_GUMMY_DILDO))
		{
			var _gummyDildoButton:FlxButton = newToyButton(gummyDildoButtonEvent, AssetPaths.dildo_gummy_button__png, _dialogTree);
			addToyButton(_gummyDildoButton);
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_HUGE_DILDO))
		{
			xlDildoButton = newToyButton(xlDildoButtonEvent, AssetPaths.dildo_xl_button__png, _dialogTree);
			addToyButton(xlDildoButton, 0.31);
		}

		toyPattern = FlxG.random.getObject([
			["0", "1-bad", "0", "1", "2", "3"],
			["0", "1", "2-bad", "1", "2", "3"],
			["0", "1", "2", "3-bad", "2", "3"]
		]);
		remainingToyPattern = toyPattern.copy();
	}

	public function xlDildoButtonEvent():Void
	{
		playButtonClickSound();
		removeToyButton(xlDildoButton);
		var tree:Array<Array<Object>> = [];
		BuizelDialog.snarkyHugeDildo(tree);
		showEarlyDialog(tree);
	}

	public function blueDildoButtonEvent():Void
	{
		playButtonClickSound();
		toyButtonsEnabled = false;
		maybeEmitWords(toyStartWords);
		var time:Float = eventStack._time;
		eventStack.addEvent({time:time += 0.8, callback:eventTakeBreak, args:[2.5]});
		eventStack.addEvent({time:time += 0.5, callback:eventShowToyWindow});
		eventStack.addEvent({time:time += 2.2, callback:eventEnableToyButtons});
	}

	public function gummyDildoButtonEvent():Void
	{
		toyWindow.setGummyDildo();

		playButtonClickSound();
		toyButtonsEnabled = false;
		maybeEmitWords(toyStartWords);
		var time:Float = eventStack._time;
		eventStack.addEvent({time:time += 0.8, callback:eventTakeBreak, args:[2.5]});
		eventStack.addEvent({time:time += 0.5, callback:eventShowToyWindow});
		eventStack.addEvent({time:time += 2.2, callback:eventEnableToyButtons});
	}

	override public function shouldEmitToyInterruptWords():Bool
	{
		return _toyBank.getForeplayPercent() > 0.7 && _toyBank.getDickPercent() > 0.7;
	}

	override function toyForeplayFactor():Float
	{
		/*
		 * 30% of the toy hearts are available for doing random stuff. the
		 * other 70% are only available if you hit the right spot
		 */
		return 0.3;
	}

	override public function getToyWindow():PokeWindow
	{
		return toyWindow;
	}

	public function eventLowerDildoArm(args:Array<Dynamic>):Void
	{
		toyWindow._arms.animation.play("default");
		toyWindow._legs.animation.play("default");
	}

	override public function handleToyWindow(elapsed:Float):Void
	{
		super.handleToyWindow(elapsed);

		toyPrecumTimer -= elapsed;

		newTailsTimer -= elapsed;
		if (newTailsTimer < 0)
		{
			toyWindow.updateTails(toyOnTrack);
			newTailsTimer = FlxG.random.float(6, 9);
		}

		dildoUtils.update(elapsed);

		handleToyReward(elapsed);

		if (FlxG.mouse.justPressed && toyInterface.animName != null)
		{
			if (toyInterface.ass)
			{
				if (toyInterface.animName == "rub-ass")
				{
					// rubbing doesn't loosen ass
				}
				else
				{
					_assTightness *= FlxG.random.float(0.90, 0.94);
					toyInterface.setTightness(_assTightness, 0);
				}
			}
		}

		if (FlxG.mouse.justPressed && toyInterface.animName != null)
		{
			if (toyWindow._arms.animation.name == "arm-grab")
			{
				if (eventStack.isEventScheduled(eventLowerDildoArm))
				{
					// already scheduled; don't schedule again
				}
				else
				{
					eventStack.addEvent({time:eventStack._time + 1.8, callback:eventLowerDildoArm});
				}
			}
		}
	}

	public function refreshDildoAnims():Bool
	{
		var refreshed:Bool = false;
		if (toyInterface.animName == "rub-vag")
		{
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._dick, "rub-vag", [18, 19, 20, 21], 2);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "rub-vag", [4, 3, 2, 1], 2);
		}
		else if (toyInterface.animName == "finger-vag")
		{
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._dick, "finger-vag", [1, 2, 3, 4], 2);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "finger-vag", [6, 7, 8, 9], 2);
		}
		else if (toyInterface.animName == "dildo-vag0")
		{
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._dick, "dildo-vag0", [6, 7, 8, 9, 10, 11], 2);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._dildo, "dildo-vag0", [1, 2, 3, 4, 5, 6], 2);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-vag0", [12, 13, 14, 15, 16, 17], 2);
		}
		else if (toyInterface.animName == "dildo-vag1")
		{
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._dick, "dildo-vag1", [9, 10, 11, 12, 13, 14, 15], 3);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._dildo, "dildo-vag1", [4, 5, 6, 7, 8, 9, 10], 3);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-vag1", [18, 19, 20, 21, 22, 23, 24], 3);
		}
		else if (toyInterface.animName == "rub-ass")
		{
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._ass, "rub-ass", [4, 3, 2, 1], 2);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "rub-ass", [29, 28, 27, 26], 2);
		}
		else if (toyInterface.animName == "finger-ass")
		{
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._ass, "finger-ass", [6, 7, 8, 9], 2);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "finger-ass", [30, 31, 32, 33], 2);
		}
		else if (toyInterface.animName == "dildo-ass0")
		{
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._ass, "dildo-ass0", [12, 13, 14, 15, 16, 17], 2);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._dildo, "dildo-ass0", [12, 13, 14, 15, 16, 17], 2);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-ass0", [35, 36, 37, 38, 39, 40], 2);
		}
		else if (toyInterface.animName == "dildo-ass0")
		{
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._ass, "dildo-ass1", [15, 16, 17, 18, 19, 20, 21], 3);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._dildo, "dildo-ass1", [15, 16, 17, 18, 19, 20, 21], 3);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-ass1", [41, 42, 43, 44, 45, 46, 47], 3);
		}
		return refreshed;
	}

	function handleToyReward(elapsed:Float):Void
	{
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

		ambientDildoBankTimer -= elapsed;
		if (ambientDildoBankTimer <= 0)
		{
			ambientDildoBankTimer += 1.4;
			fillAmbientDildoBank();
		}

		if (_rubHandAnim != null)
		{
			if (prevToyHandAnim != null &&
			(prevToyHandAnim.indexOf("-ass") != -1 && _rubHandAnim._flxSprite.animation.name.indexOf("-vag") != -1
			|| prevToyHandAnim.indexOf("-vag") != -1 && _rubHandAnim._flxSprite.animation.name.indexOf("-ass") != -1))
			{
				// swapping between ass and vagina; they have to start the pattern over
				if (remainingToyPattern.length > 0)
				{
					remainingToyPattern = toyPattern.copy();
				}
			}
		}

		if (_rubHandAnim != null && _rubHandAnim.sfxLength > 0)
		{
			if (_rubHandAnim.mouseDownSfx)
			{
				var amount:Float = SexyState.roundUpToQuarter(lucky(0.3, 0.7) * ambientDildoBank);
				if (amount == 0)
				{
					// going too fast; bank isn't having a chance to fill up.
					var penaltyAmount:Float = SexyState.roundUpToQuarter(lucky(0.01, 0.02) * _toyBank._dickHeartReservoir);
					if (_heartEmitCount > -penaltyAmount * 2)
					{
						_heartEmitCount -= penaltyAmount;
					}

					if (_toyBank._foreplayHeartReservoir > penaltyAmount)
					{
						_toyBank._foreplayHeartReservoir -= penaltyAmount;
					}
					else if (_heartBank._foreplayHeartReservoir > penaltyAmount && _heartBank.getForeplayPercent() >= 0.4)
					{
						_heartBank._foreplayHeartReservoir -= penaltyAmount;
					}
					else if (_heartBank._dickHeartReservoir > penaltyAmount)
					{
						_heartBank._dickHeartReservoir -= penaltyAmount;
					}
				}
				ambientDildoBank -= amount;

				var toyStr:String;
				if (_rubHandAnim == null)
				{
					toyStr = null;
				}
				else
				{
					toyStr = rubHandAnimToToyStr[_rubHandAnim._flxSprite.animation.name];
				}
				if (toyStr != null && remainingToyPattern.length > 0)
				{
					if (StringTools.startsWith(remainingToyPattern[0], toyStr))
					{
						toyOnTrack = true;
						if (remainingToyPattern[0] == (toyStr + "-bad"))
						{
							_heartEmitCount -= pleasurableDildoBank;
							_toyBank._foreplayHeartReservoir += pleasurableDildoBank;
							pleasurableDildoBank = 0;

							newTailsTimer = FlxG.random.float(11, 14);
							eventStack.addEvent({time:eventStack._time + FlxG.random.float(1.8, 7.5), callback:eventUpdateTails, args:[false]});
						}
						else
						{
							fillPleasurableDildoBank();

							var pleasurableDildoAmount:Float = SexyState.roundUpToQuarter(lucky(0.1, 0.2) * pleasurableDildoBank);
							amount += pleasurableDildoAmount;
							pleasurableDildoBank -= pleasurableDildoAmount;
						}
						remainingToyPattern.splice(0, 1);
					}
					else if (toyStr == previousToyStr)
					{
						if (!toyOnTrack)
						{
							_toyBank._dickHeartReservoir -= SexyState.roundUpToQuarter(lucky(0.01, 0.02) * _toyBank._dickHeartReservoir);

							if (!_male && _rubHandAnim._flxSprite.animation.name.indexOf("-vag") != -1)
							{
								// if the player messes up rubbing the vagina, it can trigger a premature orgasm
								_heartBank._dickHeartReservoirCapacity += SexyState.roundUpToQuarter(lucky(0.02, 0.04) * _heartBank._defaultDickHeartReservoir);
							}
						}

						var pleasurableDildoAmount:Float = SexyState.roundUpToQuarter(lucky(0.1, 0.2) * pleasurableDildoBank);
						amount += pleasurableDildoAmount;
						pleasurableDildoBank -= pleasurableDildoAmount;
					}
					else
					{
						_toyBank._dickHeartReservoir -= SexyState.roundUpToQuarter(lucky(0.15, 0.25) * _toyBank._dickHeartReservoir);
						if (!_male && _rubHandAnim._flxSprite.animation.name.indexOf("-vag") != -1)
						{
							// if the player messes up rubbing the vagina, it can trigger a premature orgasm
							if (toyStr == "0" || toyStr == "1")
							{
								_heartBank._dickHeartReservoirCapacity += SexyState.roundUpToQuarter(lucky(0.10, 0.20) * _heartBank._defaultDickHeartReservoir);
							}
							else
							{
								_heartBank._dickHeartReservoirCapacity += SexyState.roundUpToQuarter(lucky(0.25, 0.35) * _heartBank._defaultDickHeartReservoir);
							}
						}

						toyOnTrack = false;
						// messed up; start toy pattern over
						remainingToyPattern = toyPattern.copy();
						toyMessUpCount++;
					}

					if (shortestToyPatternLength > remainingToyPattern.length)
					{
						shortestToyPatternLength = remainingToyPattern.length;

						_heartBank._foreplayHeartReservoirCapacity += SexyState.roundUpToQuarter(_heartBank._defaultForeplayHeartReservoir * 0.15);

						if (shortestToyPatternLength == 3)
						{
							maybeEmitWords(pleasureWords);
						}
					}

					if (remainingToyPattern.length == 0)
					{
						// emit a bunch of hearts...
						var rewardAmount:Float = SexyState.roundUpToQuarter(lucky(0.25, 0.35) * _toyBank._dickHeartReservoir);
						_toyBank._dickHeartReservoir -= rewardAmount;
						amount += rewardAmount;

						// dump remaining toy "reward hearts" into toy "automatic hearts"
						_toyBank._foreplayHeartReservoir += _toyBank._dickHeartReservoir;
						_toyBank._dickHeartReservoir = 0;

						if (toyMessUpCount == 0)
						{
							// perfect deduction; bonus orgasm soon
							bonusDildoOrgasmTimer = FlxG.random.int(10, 20);
						}
						maybeEmitWords(pleasureWords);
						maybePlayPokeSfx();
						precum(FlxMath.bound(30 / (3 + toyMessUpCount * 2), 1, 10)); // silly amount of precum

						addToyHeartsToOrgasm = true;
					}
				}
				previousToyStr = toyStr;

				if (bonusDildoOrgasmTimer > 0)
				{
					bonusDildoOrgasmTimer--;
					if (bonusDildoOrgasmTimer == 8)
					{
						maybeEmitWords(almostWords);
					}
					if (bonusDildoOrgasmTimer - FlxG.random.int(0, 2) <= 0)
					{
						bonusDildoOrgasmTimer = -1;
						_remainingOrgasms++;
						generateCumshots();
						refreshArousalFromCumshots();
						_newHeadTimer = FlxG.random.float(2, 4) * _headTimerFactor;
					}
				}

				eventStack.addEvent({time:eventStack._time + _rubHandAnim._prevMouseDownTime * 0.55, callback:eventEmitHearts, args:[amount]});
			}

			if (_rubHandAnim.mouseDownSfx && !_isOrgasming && shouldOrgasm())
			{
				_newHeadTimer = 0; // trigger orgasm immediately
			}
		}

		if (_rubHandAnim != null)
		{
			prevToyHandAnim = _rubHandAnim._flxSprite.animation.name;
		}
	}

	function eventUpdateTails(args:Array<Dynamic>)
	{
		toyWindow.updateTails(args[0]);
	}

	function fillAmbientDildoBank()
	{
		if (ambientDildoBank < ambientDildoBankCapacity)
		{
			if (_toyBank._foreplayHeartReservoir > 0)
			{
				var amount:Float = _toyBank._foreplayHeartReservoir;
				amount = Math.min(amount, ambientDildoBankCapacity - ambientDildoBank);
				_toyBank._foreplayHeartReservoir -= amount;
				ambientDildoBank += amount;
			}
		}
		if (ambientDildoBank < ambientDildoBankCapacity)
		{
			if (_heartBank.getForeplayPercent() >= 0.4)
			{
				var amount:Float = _heartBank._foreplayHeartReservoir;
				amount = Math.min(amount, ambientDildoBankCapacity - ambientDildoBank);
				_heartBank._foreplayHeartReservoir -= amount;
				ambientDildoBank += amount;
			}
		}
		if (ambientDildoBank < ambientDildoBankCapacity)
		{
			if (_heartBank._dickHeartReservoir > 0)
			{
				var amount:Float = _heartBank._dickHeartReservoir;
				amount = Math.min(amount, ambientDildoBankCapacity - ambientDildoBank);
				_heartBank._dickHeartReservoir -= amount;
				ambientDildoBank += amount;
			}
		}
	}

	function fillPleasurableDildoBank()
	{
		var missingAmount:Float = pleasurableDildoBankCapacity - pleasurableDildoBank;

		if (pleasurableDildoBank < pleasurableDildoBankCapacity)
		{
			if (_toyBank._foreplayHeartReservoir > 0)
			{
				var amount:Float = _toyBank._foreplayHeartReservoir;
				amount = Math.min(amount, SexyState.roundDownToQuarter(missingAmount * 0.5));
				_toyBank._foreplayHeartReservoir -= amount;
				pleasurableDildoBank += amount;
			}
			if (_toyBank._dickHeartReservoir > 0)
			{
				var amount:Float = _toyBank._dickHeartReservoir;
				amount = Math.min(amount, SexyState.roundUpToQuarter(missingAmount * 0.5));
				_toyBank._dickHeartReservoir -= amount;
				pleasurableDildoBank += amount;
			}
		}
		if (pleasurableDildoBank < pleasurableDildoBankCapacity)
		{
			if (_heartBank.getForeplayPercent() >= 0.4)
			{
				var amount:Float = _heartBank._foreplayHeartReservoir;
				amount = Math.min(amount, pleasurableDildoBankCapacity - pleasurableDildoBank);
				_heartBank._foreplayHeartReservoir -= amount;
				pleasurableDildoBank += amount;
			}
		}
		if (pleasurableDildoBank < pleasurableDildoBankCapacity)
		{
			if (_heartBank._dickHeartReservoir > 0)
			{
				var amount:Float = _heartBank._dickHeartReservoir;
				amount = Math.min(amount, pleasurableDildoBankCapacity - pleasurableDildoBank);
				_heartBank._dickHeartReservoir -= amount;
				pleasurableDildoBank += amount;
			}
		}
	}

	private function eventEmitHearts(args:Array<Dynamic>)
	{
		var heartsToEmit:Float = args[0];
		_heartEmitCount += heartsToEmit;

		if (_heartBank.getDickPercent() < 0.6)
		{
			maybeEmitWords(almostWords);
		}

		if (toyPrecumTimer < 0)
		{
			toyPrecumTimer = _rubRewardFrequency;
			maybeEmitPrecum();
		}
		maybeEmitToyWordsAndStuff();
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
			if (_male && fancyRubbing(_dick) && _rubBodyAnim._flxSprite.animation.name == "rub-dick" && _rubBodyAnim.nearMinFrame())
			{
				_rubBodyAnim.setAnimName("jack-off");
				_rubHandAnim.setAnimName("jack-off");
			}
		}

		if (!fancyRubAnimatesSprite(_dick))
		{
			setInactiveDickAnimation();
		}
	}

	override function generateCumshots()
	{
		if (specialRub == "ass1" && specialSpotCount == 7)
		{
			cumTrait1 = 4;
			cumTrait4 = 6;
		}
		if (addToyHeartsToOrgasm && _remainingOrgasms == 1)
		{
			_heartBank._dickHeartReservoir += _toyBank._dickHeartReservoir;
			_heartBank._dickHeartReservoir += _toyBank._foreplayHeartReservoir;
			_heartBank._dickHeartReservoir += ambientDildoBank;
			_heartBank._dickHeartReservoir += pleasurableDildoBank;

			_toyBank._dickHeartReservoir = 0;
			_toyBank._foreplayHeartReservoir = 0;
			ambientDildoBank = 0;
			pleasurableDildoBank = 0;
		}
		super.generateCumshots();
	}

	override public function determineArousal():Int
	{
		if (specialRub == "jack-off" || specialRub == "ass1" && specialSpotCount == 7)
		{
			if (_heartBank.getDickPercent() < 0.8)
			{
				return 4;
			}
			else
			{
				return 3;
			}
		}

		if (_heartBank.getForeplayPercent() < 0.9)
		{
			if (readyForJackOff)
			{
				return 2;
			}
			return 1;
		}
		else {
			return 0;
		}
	}

	override public function checkSpecialRub(touchedPart:FlxSprite)
	{
		if (_fancyRub)
		{
			if (_rubHandAnim._flxSprite.animation.name == "finger-ass0")
			{
				specialRub = "ass0";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "finger-ass1")
			{
				specialRub = "ass1";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-balls-left")
			{
				specialRub = "left-ball";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-balls-right")
			{
				specialRub = "right-ball";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-floof")
			{
				specialRub = "floof";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "honk-neck")
			{
				specialRub = "neck";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "jack-off")
			{
				specialRub = "jack-off";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-dick")
			{
				specialRub = "rub-dick";
			}
		}
		else
		{
			if (touchedPart == _pokeWindow._torso1)
			{
				specialRub = "chest";
			}
			else if (touchedPart == _pokeWindow._legs && clickedPolygon(touchedPart, leftThighPolyArray))
			{
				specialRub = "left-thigh";
			}
			else if (touchedPart == _pokeWindow._legs && clickedPolygon(touchedPart, rightThighPolyArray))
			{
				specialRub = "right-thigh";
			}
			else if (touchedPart == _head)
			{
				specialRub = "head";
			}
		}
	}

	override public function canChangeHead():Bool
	{
		return !fancyRubbing(_pokeWindow._floof);
	}

	override public function untouchPart(touchedPart:FlxSprite):Void
	{
		super.untouchPart(touchedPart);
		if (touchedPart == _pokeWindow._ass && _male)
		{
			ballOpacityTween = FlxTweenUtil.retween(ballOpacityTween, _pokeWindow._balls, { alpha:1.0 }, 0.25);
			dickOpacityTween = FlxTweenUtil.retween(dickOpacityTween, _dick, { alpha:1.0 }, 0.25);
		}
		if (touchedPart == _pokeWindow._floof)
		{
			_pokeWindow._floof.visible = false;
			_pokeWindow.playNewAnim(_head, ["1-3"]);
			_newHeadTimer = FlxG.random.float(1, 2);
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
				if (!_male)
				{
					_rubBodyAnim.addAnimName("rub-dick1");
					_rubHandAnim.addAnimName("rub-dick1");
				}
			}
			if (_male)
			{
				_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.length - 1);
			}
			else
			{
				_rubBodyAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
				_rubHandAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
			}
			return true;
		}
		if (FlxG.mouse.justPressed && touchedPart == _pokeWindow._balls)
		{
			if (clickedPolygon(touchedPart, rightBallPolyArray))
			{
				interactOn(_pokeWindow._balls, "rub-balls-right");
				_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.members.indexOf(_dick) + 1);
			}
			else
			{
				interactOn(_pokeWindow._balls, "rub-balls-left");
			}
			return true;
		}
		if (FlxG.mouse.justPressed && (touchedPart == _pokeWindow._ass || touchedPart == _pokeWindow._torso0 && clickedPolygon(touchedPart, assPolyArray)))
		{
			var assAnim:String = _assTightness > 2.5 ? "finger-ass0" : "finger-ass1";
			interactOn(_pokeWindow._ass, assAnim);
			if (!_male)
			{
				// vagina stretches when fingering ass
				_rubBodyAnim2 = new FancyAnim(_dick, assAnim);
				_rubBodyAnim2.setSpeed(0.65 * 2.5, 0.65 * 1.5);
			}
			_rubBodyAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
			_rubHandAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
			if (_male)
			{
				ballOpacityTween = FlxTweenUtil.retween(ballOpacityTween, _pokeWindow._balls, { alpha:0.65 }, 0.25);
			}
			if (_male && _dick.animation.name == "default")
			{
				dickOpacityTween = FlxTweenUtil.retween(dickOpacityTween, _dick, { alpha:0.65 }, 0.25);
			}
			return true;
		}
		if (FlxG.mouse.justPressed && touchedPart == _head)
		{
			if (clickedPolygon(touchedPart, floofPolyArray))
			{
				interactOn(_pokeWindow._floof, "rub-floof");
				_pokeWindow.playNewAnim(_head, ["rub-floof"]);
				_pokeWindow._floof.visible = true;
				_newHeadTimer = 0;
				return true;
			}
		}
		if (FlxG.mouse.justPressed && touchedPart == _pokeWindow._neck)
		{
			interactOn(_pokeWindow._neck, "honk-neck");
			return true;
		}
		return false;
	}

	override function initializeHitBoxes():Void
	{
		if (displayingToyWindow())
		{
			if (_male)
			{
				dickAngleArray[0] = [new FlxPoint(182, 423), new FlxPoint(129, 226), new FlxPoint(-122, 229)];
				dickAngleArray[1] = [new FlxPoint(182, 428), new FlxPoint(63, 252), new FlxPoint(-61, 253)];
				dickAngleArray[2] = [new FlxPoint(184, 439), new FlxPoint(36, 257), new FlxPoint(-9, 260)];
			}
			else
			{
				dickAngleArray[0] = [new FlxPoint(182, 359), new FlxPoint(132, 224), new FlxPoint(-126, 227)];
				dickAngleArray[1] = [new FlxPoint(182, 358), new FlxPoint(156, 208), new FlxPoint(-121, 230)];
				dickAngleArray[2] = [new FlxPoint(182, 358), new FlxPoint(206, 159), new FlxPoint(-212, 150)];
				dickAngleArray[3] = [new FlxPoint(182, 358), new FlxPoint(218, 142), new FlxPoint(-233, 116)];
				dickAngleArray[4] = [new FlxPoint(182, 358), new FlxPoint(224, 132), new FlxPoint(-227, 126)];
				dickAngleArray[6] = [new FlxPoint(182, 357), new FlxPoint(165, 201), new FlxPoint(-173, 194)];
				dickAngleArray[7] = [new FlxPoint(182, 357), new FlxPoint(214, 148), new FlxPoint(-214, 148)];
				dickAngleArray[8] = [new FlxPoint(182, 357), new FlxPoint(221, 137), new FlxPoint(-225, 131)];
				dickAngleArray[9] = [new FlxPoint(182, 357), new FlxPoint(228, 125), new FlxPoint(-214, 148)];
				dickAngleArray[10] = [new FlxPoint(182, 357), new FlxPoint(231, 120), new FlxPoint(-228, 124)];
				dickAngleArray[11] = [new FlxPoint(182, 357), new FlxPoint(236, 109), new FlxPoint(-239, 102)];
				dickAngleArray[12] = [new FlxPoint(182, 357), new FlxPoint(244, 89), new FlxPoint(-246, 83)];
				dickAngleArray[13] = [new FlxPoint(182, 357), new FlxPoint(250, 71), new FlxPoint(-251, 68)];
				dickAngleArray[14] = [new FlxPoint(182, 357), new FlxPoint(248, 77), new FlxPoint(-247, 80)];
				dickAngleArray[15] = [new FlxPoint(182, 357), new FlxPoint(247, 82), new FlxPoint(-242, 96)];
				dickAngleArray[18] = [new FlxPoint(182, 358), new FlxPoint(134, 223), new FlxPoint(-125, 228)];
				dickAngleArray[19] = [new FlxPoint(182, 360), new FlxPoint(162, 203), new FlxPoint(-156, 208)];
				dickAngleArray[20] = [new FlxPoint(182, 359), new FlxPoint(151, 212), new FlxPoint(-151, 212)];
				dickAngleArray[21] = [new FlxPoint(182, 358), new FlxPoint(151, 212), new FlxPoint( -151, 212)];
			}

			var torsoSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			torsoSweatArray[0] = [new FlxPoint(126, 417), new FlxPoint(156, 390), new FlxPoint(166, 321), new FlxPoint(182, 295), new FlxPoint(206, 311), new FlxPoint(216, 391), new FlxPoint(242, 419), new FlxPoint(208, 429), new FlxPoint(156, 430)];

			sweatAreas.splice(0, sweatAreas.length);
			sweatAreas.push({chance:5, sprite:toyWindow._torso, sweatArrayArray:torsoSweatArray});
			sweatAreas.push({chance:5, sprite:null, sweatArrayArray:null}); // most of buizel's sweat in this pose just isn't visible
		}
		else {
			rightBallPolyArray = new Array<Array<FlxPoint>>();
			rightBallPolyArray[0] = [new FlxPoint(178, 324), new FlxPoint(174, 425), new FlxPoint(241, 423), new FlxPoint(238, 329)];
			rightBallPolyArray[1] = [new FlxPoint(178, 324), new FlxPoint(174, 425), new FlxPoint(241, 423), new FlxPoint(238, 329)];
			rightBallPolyArray[2] = [new FlxPoint(178, 324), new FlxPoint(174, 425), new FlxPoint(241, 423), new FlxPoint(238, 329)];
			rightBallPolyArray[3] = [new FlxPoint(178, 324), new FlxPoint(174, 425), new FlxPoint(241, 423), new FlxPoint(238, 329)];
			rightBallPolyArray[4] = [new FlxPoint(178, 324), new FlxPoint(174, 425), new FlxPoint(241, 423), new FlxPoint(238, 329)];
			rightBallPolyArray[5] = [new FlxPoint(178, 324), new FlxPoint(174, 425), new FlxPoint(241, 423), new FlxPoint(238, 329)];
			rightBallPolyArray[6] = [new FlxPoint(178, 324), new FlxPoint(174, 425), new FlxPoint(241, 423), new FlxPoint(238, 329)];
			rightBallPolyArray[7] = [new FlxPoint(178, 324), new FlxPoint(174, 425), new FlxPoint(241, 423), new FlxPoint(238, 329)];
			rightBallPolyArray[8] = [new FlxPoint(178, 324), new FlxPoint(174, 425), new FlxPoint(241, 423), new FlxPoint(238, 329)];
			rightBallPolyArray[9] = [new FlxPoint(178, 324), new FlxPoint(174, 425), new FlxPoint(241, 423), new FlxPoint(238, 329)];

			assPolyArray = new Array<Array<FlxPoint>>();
			assPolyArray[0] = [new FlxPoint(221, 514), new FlxPoint(120, 514), new FlxPoint(144, 379), new FlxPoint(210, 379)];

			floofPolyArray = new Array<Array<FlxPoint>>();
			floofPolyArray[0] = [new FlxPoint(159, 97), new FlxPoint(210, 96), new FlxPoint(210, 21), new FlxPoint(161, 23)];
			floofPolyArray[1] = [new FlxPoint(159, 97), new FlxPoint(210, 96), new FlxPoint(210, 21), new FlxPoint(161, 23)];
			floofPolyArray[2] = [new FlxPoint(159, 97), new FlxPoint(210, 96), new FlxPoint(210, 21), new FlxPoint(161, 23)];
			floofPolyArray[3] = [new FlxPoint(154, 98), new FlxPoint(139, 24), new FlxPoint(209, 23), new FlxPoint(201, 87)];
			floofPolyArray[4] = [new FlxPoint(154, 98), new FlxPoint(139, 24), new FlxPoint(209, 23), new FlxPoint(201, 87)];
			floofPolyArray[5] = [new FlxPoint(154, 98), new FlxPoint(139, 24), new FlxPoint(209, 23), new FlxPoint(201, 87)];
			floofPolyArray[6] = [new FlxPoint(166, 73), new FlxPoint(199, 21), new FlxPoint(253, 39), new FlxPoint(223, 88)];
			floofPolyArray[7] = [new FlxPoint(166, 73), new FlxPoint(199, 21), new FlxPoint(253, 39), new FlxPoint(223, 88)];
			floofPolyArray[8] = [new FlxPoint(166, 73), new FlxPoint(199, 21), new FlxPoint(253, 39), new FlxPoint(223, 88)];
			floofPolyArray[9] = [new FlxPoint(163, 83), new FlxPoint(188, 33), new FlxPoint(248, 57), new FlxPoint(223, 98)];
			floofPolyArray[10] = [new FlxPoint(163, 83), new FlxPoint(188, 33), new FlxPoint(248, 57), new FlxPoint(223, 98)];
			floofPolyArray[11] = [new FlxPoint(163, 83), new FlxPoint(188, 33), new FlxPoint(248, 57), new FlxPoint(223, 98)];
			floofPolyArray[12] = [new FlxPoint(136, 88), new FlxPoint(118, 28), new FlxPoint(178, 20), new FlxPoint(190, 70)];
			floofPolyArray[13] = [new FlxPoint(136, 88), new FlxPoint(118, 28), new FlxPoint(178, 20), new FlxPoint(190, 70)];
			floofPolyArray[14] = [new FlxPoint(136, 88), new FlxPoint(118, 28), new FlxPoint(178, 20), new FlxPoint(190, 70)];
			floofPolyArray[15] = [new FlxPoint(153, 82), new FlxPoint(145, 22), new FlxPoint(218, 23), new FlxPoint(204, 79)];
			floofPolyArray[16] = [new FlxPoint(153, 82), new FlxPoint(145, 22), new FlxPoint(218, 23), new FlxPoint(204, 79)];
			floofPolyArray[17] = [new FlxPoint(153, 82), new FlxPoint(145, 22), new FlxPoint(218, 23), new FlxPoint(204, 79)];
			floofPolyArray[18] = [new FlxPoint(124, 131), new FlxPoint(63, 104), new FlxPoint(95, 32), new FlxPoint(194, 72)];
			floofPolyArray[19] = [new FlxPoint(124, 131), new FlxPoint(63, 104), new FlxPoint(95, 32), new FlxPoint(194, 72)];
			floofPolyArray[20] = [new FlxPoint(124, 131), new FlxPoint(63, 104), new FlxPoint(95, 32), new FlxPoint(194, 72)];
			floofPolyArray[21] = [new FlxPoint(162, 125), new FlxPoint(153, 53), new FlxPoint(215, 54), new FlxPoint(198, 128)];
			floofPolyArray[22] = [new FlxPoint(162, 125), new FlxPoint(153, 53), new FlxPoint(215, 54), new FlxPoint(198, 128)];
			floofPolyArray[23] = [new FlxPoint(162, 125), new FlxPoint(153, 53), new FlxPoint(215, 54), new FlxPoint(198, 128)];
			floofPolyArray[24] = [new FlxPoint(172, 70), new FlxPoint(288, 35), new FlxPoint(288, 128), new FlxPoint(240, 131)];
			floofPolyArray[25] = [new FlxPoint(172, 70), new FlxPoint(288, 35), new FlxPoint(288, 128), new FlxPoint(240, 131)];
			floofPolyArray[26] = [new FlxPoint(172, 70), new FlxPoint(288, 35), new FlxPoint(288, 128), new FlxPoint(240, 131)];
			floofPolyArray[27] = [new FlxPoint(165, 124), new FlxPoint(151, 37), new FlxPoint(228, 33), new FlxPoint(203, 123)];
			floofPolyArray[28] = [new FlxPoint(165, 124), new FlxPoint(151, 37), new FlxPoint(228, 33), new FlxPoint(203, 123)];
			floofPolyArray[29] = [new FlxPoint(165, 124), new FlxPoint(151, 37), new FlxPoint(228, 33), new FlxPoint(203, 123)];
			floofPolyArray[30] = [new FlxPoint(174, 75), new FlxPoint(298, 52), new FlxPoint(291, 147), new FlxPoint(243, 143), new FlxPoint(212, 96)];
			floofPolyArray[31] = [new FlxPoint(174, 75), new FlxPoint(298, 52), new FlxPoint(291, 147), new FlxPoint(243, 143), new FlxPoint(212, 96)];
			floofPolyArray[32] = [new FlxPoint(174, 75), new FlxPoint(298, 52), new FlxPoint(291, 147), new FlxPoint(243, 143), new FlxPoint(212, 96)];
			floofPolyArray[36] = [new FlxPoint(162, 80), new FlxPoint(151, 20), new FlxPoint(231, 23), new FlxPoint(209, 82)];
			floofPolyArray[37] = [new FlxPoint(162, 80), new FlxPoint(151, 20), new FlxPoint(231, 23), new FlxPoint(209, 82)];
			floofPolyArray[38] = [new FlxPoint(162, 80), new FlxPoint(151, 20), new FlxPoint(231, 23), new FlxPoint(209, 82)];
			floofPolyArray[39] = [new FlxPoint(204, 75), new FlxPoint(87, 31), new FlxPoint(82, 157), new FlxPoint(129, 140), new FlxPoint(157, 94)];
			floofPolyArray[40] = [new FlxPoint(204, 75), new FlxPoint(87, 31), new FlxPoint(82, 157), new FlxPoint(129, 140), new FlxPoint(157, 94)];
			floofPolyArray[41] = [new FlxPoint(204, 75), new FlxPoint(87, 31), new FlxPoint(82, 157), new FlxPoint(129, 140), new FlxPoint(157, 94)];
			floofPolyArray[42] = [new FlxPoint(138, 95), new FlxPoint(104, 47), new FlxPoint(213, 27), new FlxPoint(211, 82)];
			floofPolyArray[43] = [new FlxPoint(138, 95), new FlxPoint(104, 47), new FlxPoint(213, 27), new FlxPoint(211, 82)];
			floofPolyArray[44] = [new FlxPoint(138, 95), new FlxPoint(104, 47), new FlxPoint(213, 27), new FlxPoint(211, 82)];
			floofPolyArray[48] = [new FlxPoint(152, 82), new FlxPoint(135, 19), new FlxPoint(232, 23), new FlxPoint(204, 80)];
			floofPolyArray[49] = [new FlxPoint(152, 82), new FlxPoint(135, 19), new FlxPoint(232, 23), new FlxPoint(204, 80)];
			floofPolyArray[51] = [new FlxPoint(124, 130), new FlxPoint(74, 137), new FlxPoint(102, 27), new FlxPoint(199, 77), new FlxPoint(154, 92)];
			floofPolyArray[52] = [new FlxPoint(124, 130), new FlxPoint(74, 137), new FlxPoint(102, 27), new FlxPoint(199, 77), new FlxPoint(154, 92)];
			floofPolyArray[54] = [new FlxPoint(162, 79), new FlxPoint(164, 27), new FlxPoint(283, 37), new FlxPoint(225, 94)];
			floofPolyArray[55] = [new FlxPoint(162, 79), new FlxPoint(164, 27), new FlxPoint(283, 37), new FlxPoint(225, 94)];
			floofPolyArray[60] = [new FlxPoint(171, 68), new FlxPoint(183, 21), new FlxPoint(281, 27), new FlxPoint(225, 86)];
			floofPolyArray[61] = [new FlxPoint(171, 68), new FlxPoint(183, 21), new FlxPoint(281, 27), new FlxPoint(225, 86)];
			floofPolyArray[63] = [new FlxPoint(162, 124), new FlxPoint(147, 42), new FlxPoint(225, 44), new FlxPoint(199, 125)];
			floofPolyArray[64] = [new FlxPoint(162, 124), new FlxPoint(147, 42), new FlxPoint(225, 44), new FlxPoint(199, 125)];
			floofPolyArray[65] = [new FlxPoint(162, 124), new FlxPoint(147, 42), new FlxPoint(225, 44), new FlxPoint(199, 125)];
			floofPolyArray[66] = [new FlxPoint(176, 73), new FlxPoint(298, 51), new FlxPoint(288, 164), new FlxPoint(244, 139), new FlxPoint(214, 94)];
			floofPolyArray[67] = [new FlxPoint(176, 73), new FlxPoint(298, 51), new FlxPoint(288, 164), new FlxPoint(244, 139), new FlxPoint(214, 94)];
			floofPolyArray[69] = [new FlxPoint(167, 121), new FlxPoint(147, 37), new FlxPoint(226, 37), new FlxPoint(202, 121)];
			floofPolyArray[70] = [new FlxPoint(167, 121), new FlxPoint(147, 37), new FlxPoint(226, 37), new FlxPoint(202, 121)];
			floofPolyArray[71] = [new FlxPoint(167, 121), new FlxPoint(147, 37), new FlxPoint(226, 37), new FlxPoint(202, 121)];

			leftThighPolyArray = new Array<Array<FlxPoint>>();
			leftThighPolyArray[0] = [new FlxPoint(70, 330), new FlxPoint(91, 279), new FlxPoint(174, 275), new FlxPoint(176, 414), new FlxPoint(133, 408)];
			leftThighPolyArray[1] = [new FlxPoint(135, 406), new FlxPoint(66, 351), new FlxPoint(78, 294), new FlxPoint(178, 280), new FlxPoint(175, 405)];
			leftThighPolyArray[2] = [new FlxPoint(125, 410), new FlxPoint(69, 292), new FlxPoint(109, 268), new FlxPoint(183, 265), new FlxPoint(176, 410)];
			leftThighPolyArray[3] = [new FlxPoint(148, 413), new FlxPoint(72, 349), new FlxPoint(102, 289), new FlxPoint(179, 286), new FlxPoint(175, 412)];

			rightThighPolyArray = new Array<Array<FlxPoint>>();
			rightThighPolyArray[0] = [new FlxPoint(175, 405), new FlxPoint(177, 288), new FlxPoint(261, 296), new FlxPoint(287, 331), new FlxPoint(229, 418)];
			rightThighPolyArray[1] = [new FlxPoint(177, 401), new FlxPoint(182, 285), new FlxPoint(281, 304), new FlxPoint(289, 361), new FlxPoint(223, 410)];
			rightThighPolyArray[2] = [new FlxPoint(177, 398), new FlxPoint(184, 284), new FlxPoint(278, 295), new FlxPoint(295, 354), new FlxPoint(215, 415)];
			rightThighPolyArray[3] = [new FlxPoint(181, 397), new FlxPoint(190, 271), new FlxPoint(288, 283), new FlxPoint(234, 417)];

			vagPolyArray = new Array<Array<FlxPoint>>();
			vagPolyArray[0] = [new FlxPoint(204, 382), new FlxPoint(150, 382), new FlxPoint(146, 342), new FlxPoint(212, 343)];

			if (_male)
			{
				// cock squirt angle
				dickAngleArray[0] = [new FlxPoint(167, 392), new FlxPoint(76, 249), new FlxPoint(-124, 229)];
				dickAngleArray[1] = [new FlxPoint(148, 352), new FlxPoint(-260, 0), new FlxPoint(-176, -192)];
				dickAngleArray[2] = [new FlxPoint(148, 352), new FlxPoint(-260, 0), new FlxPoint(-176, -192)];
				dickAngleArray[3] = [new FlxPoint(168, 319), new FlxPoint(57, -254), new FlxPoint(-57, -254)];
				dickAngleArray[4] = [new FlxPoint(168, 319), new FlxPoint(57, -254), new FlxPoint(-57, -254)];
				dickAngleArray[5] = [new FlxPoint(144, 351), new FlxPoint(-260, 0), new FlxPoint(-223, -134)];
				dickAngleArray[6] = [new FlxPoint(146, 352), new FlxPoint(-260, 13), new FlxPoint(-223, -134)];
				dickAngleArray[7] = [new FlxPoint(148, 353), new FlxPoint(-260, 12), new FlxPoint(-216, -144)];
				dickAngleArray[9] = [new FlxPoint(173, 322), new FlxPoint(41, -257), new FlxPoint(-28, -258)];
				dickAngleArray[10] = [new FlxPoint(173, 321), new FlxPoint(61, -253), new FlxPoint(-53, -255)];
				dickAngleArray[11] = [new FlxPoint(172, 314), new FlxPoint(70, -250), new FlxPoint(-73, -250)];
				dickAngleArray[12] = [new FlxPoint(171, 310), new FlxPoint(70, -251), new FlxPoint(-106, -238)];
				dickAngleArray[13] = [new FlxPoint(171, 304), new FlxPoint(116, -233), new FlxPoint(-148, -214)];
				dickAngleArray[14] = [new FlxPoint(174, 290), new FlxPoint(184, -184), new FlxPoint(-126, -227)];
			}
			else {
				// vagina squirt angle
				dickAngleArray[0] = [new FlxPoint(172, 367), new FlxPoint(128, 226), new FlxPoint(-108, 236)];
				dickAngleArray[1] = [new FlxPoint(170, 365), new FlxPoint(88, 245), new FlxPoint(-162, 203)];
				dickAngleArray[2] = [new FlxPoint(170, 359), new FlxPoint(43, 256), new FlxPoint(-179, 189)];
				dickAngleArray[3] = [new FlxPoint(171, 361), new FlxPoint(89, 244), new FlxPoint(-172, 195)];
				dickAngleArray[4] = [new FlxPoint(173, 364), new FlxPoint(120, 231), new FlxPoint(-104, 238)];
				dickAngleArray[5] = [new FlxPoint(174, 362), new FlxPoint(178, 189), new FlxPoint(-55, 254)];
				dickAngleArray[6] = [new FlxPoint(174, 362), new FlxPoint(244, 90), new FlxPoint(35, 258)];
				dickAngleArray[7] = [new FlxPoint(175, 365), new FlxPoint(166, 200), new FlxPoint(-76, 249)];
				dickAngleArray[8] = [new FlxPoint(172, 365), new FlxPoint(93, 243), new FlxPoint(-98, 241)];
				dickAngleArray[9] = [new FlxPoint(172, 360), new FlxPoint(171, 196), new FlxPoint(-165, 201)];
				dickAngleArray[10] = [new FlxPoint(172, 360), new FlxPoint(213, 148), new FlxPoint(-215, 146)];
				dickAngleArray[11] = [new FlxPoint(172, 360), new FlxPoint(233, 116), new FlxPoint(-229, 122)];
				dickAngleArray[12] = [new FlxPoint(172, 360), new FlxPoint(239, 102), new FlxPoint(-241, 97)];
				dickAngleArray[13] = [new FlxPoint(172, 360), new FlxPoint(250, 71), new FlxPoint( -245, 86)];
				dickAngleArray[14] = [new FlxPoint(172, 366), new FlxPoint(106, 238), new FlxPoint(-130, 225)];
				dickAngleArray[15] = [new FlxPoint(172, 364), new FlxPoint(138, 220), new FlxPoint(-82, 247)];
			}

			breathAngleArray[3] = [new FlxPoint(165, 183), new FlxPoint(-41, 69)];
			breathAngleArray[4] = [new FlxPoint(165, 183), new FlxPoint(-41, 69)];
			breathAngleArray[5] = [new FlxPoint(165, 183), new FlxPoint(-41, 69)];
			breathAngleArray[6] = [new FlxPoint(166, 176), new FlxPoint(-17, 78)];
			breathAngleArray[7] = [new FlxPoint(166, 176), new FlxPoint(-17, 78)];
			breathAngleArray[8] = [new FlxPoint(166, 176), new FlxPoint(-17, 78)];
			breathAngleArray[15] = [new FlxPoint(177, 180), new FlxPoint(0, 80)];
			breathAngleArray[16] = [new FlxPoint(177, 180), new FlxPoint(0, 80)];
			breathAngleArray[17] = [new FlxPoint(177, 180), new FlxPoint(0, 80)];
			breathAngleArray[18] = [new FlxPoint(242, 153), new FlxPoint(80, -9)];
			breathAngleArray[19] = [new FlxPoint(242, 153), new FlxPoint(80, -9)];
			breathAngleArray[20] = [new FlxPoint(242, 153), new FlxPoint(80, -9)];
			breathAngleArray[21] = [new FlxPoint(179, 221), new FlxPoint(-5, 80)];
			breathAngleArray[22] = [new FlxPoint(179, 221), new FlxPoint(-5, 80)];
			breathAngleArray[23] = [new FlxPoint(179, 221), new FlxPoint(-5, 80)];
			breathAngleArray[24] = [new FlxPoint(115, 155), new FlxPoint(-80, -6)];
			breathAngleArray[25] = [new FlxPoint(115, 155), new FlxPoint(-80, -6)];
			breathAngleArray[26] = [new FlxPoint(115, 155), new FlxPoint(-80, -6)];
			breathAngleArray[27] = [new FlxPoint(177, 222), new FlxPoint(-1, 80)];
			breathAngleArray[28] = [new FlxPoint(177, 222), new FlxPoint(-1, 80)];
			breathAngleArray[29] = [new FlxPoint(177, 222), new FlxPoint(-1, 80)];
			breathAngleArray[30] = [new FlxPoint(123, 159), new FlxPoint(-79, -9)];
			breathAngleArray[31] = [new FlxPoint(123, 159), new FlxPoint(-79, -9)];
			breathAngleArray[32] = [new FlxPoint(123, 159), new FlxPoint(-79, -9)];
			breathAngleArray[36] = [new FlxPoint(166, 180), new FlxPoint(-46, 66)];
			breathAngleArray[37] = [new FlxPoint(166, 180), new FlxPoint(-46, 66)];
			breathAngleArray[38] = [new FlxPoint(166, 180), new FlxPoint(-46, 66)];
			breathAngleArray[39] = [new FlxPoint(245, 142), new FlxPoint(69, -41)];
			breathAngleArray[40] = [new FlxPoint(245, 142), new FlxPoint(69, -41)];
			breathAngleArray[41] = [new FlxPoint(245, 142), new FlxPoint(69, -41)];
			breathAngleArray[42] = [new FlxPoint(209, 178), new FlxPoint(72, 36)];
			breathAngleArray[43] = [new FlxPoint(209, 178), new FlxPoint(72, 36)];
			breathAngleArray[44] = [new FlxPoint(209, 178), new FlxPoint(72, 36)];
			breathAngleArray[54] = [new FlxPoint(133, 176), new FlxPoint(-80, 6)];
			breathAngleArray[55] = [new FlxPoint(133, 176), new FlxPoint(-80, 6)];
			breathAngleArray[60] = [new FlxPoint(165, 194), new FlxPoint(-24, 76)];
			breathAngleArray[61] = [new FlxPoint(165, 194), new FlxPoint(-24, 76)];
			breathAngleArray[63] = [new FlxPoint(181, 225), new FlxPoint(4, 80)];
			breathAngleArray[64] = [new FlxPoint(181, 225), new FlxPoint(4, 80)];
			breathAngleArray[65] = [new FlxPoint(181, 225), new FlxPoint(4, 80)];
			breathAngleArray[66] = [new FlxPoint(122, 156), new FlxPoint(-79, -12)];
			breathAngleArray[67] = [new FlxPoint(122, 156), new FlxPoint(-79, -12)];
			breathAngleArray[69] = [new FlxPoint(176, 223), new FlxPoint(8, 80)];
			breathAngleArray[69] = [new FlxPoint(176, 223), new FlxPoint(8, 80)];
			breathAngleArray[70] = [new FlxPoint(176, 223), new FlxPoint(8, 80)];
			breathAngleArray[71] = [new FlxPoint(176, 223), new FlxPoint(8, 80)];

			var torsoSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			torsoSweatArray[0] = [new FlxPoint(150, 340), new FlxPoint(137, 251), new FlxPoint(131, 211), new FlxPoint(179, 233), new FlxPoint(232, 210), new FlxPoint(206, 339)];

			var headSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			headSweatArray[0] = [new FlxPoint(166, 103), new FlxPoint(143, 95), new FlxPoint(183, 73), new FlxPoint(222, 95), new FlxPoint(201, 104), new FlxPoint(197, 144), new FlxPoint(165, 143)];
			headSweatArray[1] = [new FlxPoint(166, 103), new FlxPoint(143, 95), new FlxPoint(183, 73), new FlxPoint(222, 95), new FlxPoint(201, 104), new FlxPoint(197, 144), new FlxPoint(165, 143)];
			headSweatArray[2] = [new FlxPoint(166, 103), new FlxPoint(143, 95), new FlxPoint(183, 73), new FlxPoint(222, 95), new FlxPoint(201, 104), new FlxPoint(197, 144), new FlxPoint(165, 143)];
			headSweatArray[3] = [new FlxPoint(150, 122), new FlxPoint(132, 119), new FlxPoint(159, 86), new FlxPoint(213, 87), new FlxPoint(181, 111), new FlxPoint(185, 145), new FlxPoint(159, 150)];
			headSweatArray[4] = [new FlxPoint(150, 122), new FlxPoint(132, 119), new FlxPoint(159, 86), new FlxPoint(213, 87), new FlxPoint(181, 111), new FlxPoint(185, 145), new FlxPoint(159, 150)];
			headSweatArray[5] = [new FlxPoint(150, 122), new FlxPoint(132, 119), new FlxPoint(159, 86), new FlxPoint(213, 87), new FlxPoint(181, 111), new FlxPoint(185, 145), new FlxPoint(159, 150)];
			headSweatArray[6] = [new FlxPoint(155, 82), new FlxPoint(196, 71), new FlxPoint(233, 106), new FlxPoint(204, 101), new FlxPoint(193, 146), new FlxPoint(169, 138), new FlxPoint(180, 95)];
			headSweatArray[7] = [new FlxPoint(155, 82), new FlxPoint(196, 71), new FlxPoint(233, 106), new FlxPoint(204, 101), new FlxPoint(193, 146), new FlxPoint(169, 138), new FlxPoint(180, 95)];
			headSweatArray[8] = [new FlxPoint(155, 82), new FlxPoint(196, 71), new FlxPoint(233, 106), new FlxPoint(204, 101), new FlxPoint(193, 146), new FlxPoint(169, 138), new FlxPoint(180, 95)];
			headSweatArray[9] = [new FlxPoint(154, 142), new FlxPoint(157, 111), new FlxPoint(143, 103), new FlxPoint(179, 74), new FlxPoint(229, 106), new FlxPoint(231, 126), new FlxPoint(176, 113), new FlxPoint(168, 148)];
			headSweatArray[10] = [new FlxPoint(154, 142), new FlxPoint(157, 111), new FlxPoint(143, 103), new FlxPoint(179, 74), new FlxPoint(229, 106), new FlxPoint(231, 126), new FlxPoint(176, 113), new FlxPoint(168, 148)];
			headSweatArray[11] = [new FlxPoint(154, 142), new FlxPoint(157, 111), new FlxPoint(143, 103), new FlxPoint(179, 74), new FlxPoint(229, 106), new FlxPoint(231, 126), new FlxPoint(176, 113), new FlxPoint(168, 148)];
			headSweatArray[12] = [new FlxPoint(128, 110), new FlxPoint(147, 75), new FlxPoint(190, 68), new FlxPoint(219, 92), new FlxPoint(185, 97), new FlxPoint(192, 134), new FlxPoint(170, 140), new FlxPoint(157, 102)];
			headSweatArray[13] = [new FlxPoint(128, 110), new FlxPoint(147, 75), new FlxPoint(190, 68), new FlxPoint(219, 92), new FlxPoint(185, 97), new FlxPoint(192, 134), new FlxPoint(170, 140), new FlxPoint(157, 102)];
			headSweatArray[14] = [new FlxPoint(128, 110), new FlxPoint(147, 75), new FlxPoint(190, 68), new FlxPoint(219, 92), new FlxPoint(185, 97), new FlxPoint(192, 134), new FlxPoint(170, 140), new FlxPoint(157, 102)];
			headSweatArray[15] = [new FlxPoint(167, 110), new FlxPoint(131, 115), new FlxPoint(162, 79), new FlxPoint(198, 77), new FlxPoint(230, 109), new FlxPoint(200, 111), new FlxPoint(198, 145), new FlxPoint(172, 146)];
			headSweatArray[16] = [new FlxPoint(167, 110), new FlxPoint(131, 115), new FlxPoint(162, 79), new FlxPoint(198, 77), new FlxPoint(230, 109), new FlxPoint(200, 111), new FlxPoint(198, 145), new FlxPoint(172, 146)];
			headSweatArray[17] = [new FlxPoint(167, 110), new FlxPoint(131, 115), new FlxPoint(162, 79), new FlxPoint(198, 77), new FlxPoint(230, 109), new FlxPoint(200, 111), new FlxPoint(198, 145), new FlxPoint(172, 146)];
			headSweatArray[18] = [new FlxPoint(164, 158), new FlxPoint(125, 135), new FlxPoint(158, 76), new FlxPoint(197, 79), new FlxPoint(213, 95), new FlxPoint(169, 106)];
			headSweatArray[19] = [new FlxPoint(164, 158), new FlxPoint(125, 135), new FlxPoint(158, 76), new FlxPoint(197, 79), new FlxPoint(213, 95), new FlxPoint(169, 106)];
			headSweatArray[20] = [new FlxPoint(164, 158), new FlxPoint(125, 135), new FlxPoint(158, 76), new FlxPoint(197, 79), new FlxPoint(213, 95), new FlxPoint(169, 106)];
			headSweatArray[21] = [new FlxPoint(132, 133), new FlxPoint(156, 94), new FlxPoint(218, 99), new FlxPoint(232, 131), new FlxPoint(199, 146), new FlxPoint(200, 185), new FlxPoint(171, 187), new FlxPoint(172, 145)];
			headSweatArray[22] = [new FlxPoint(132, 133), new FlxPoint(156, 94), new FlxPoint(218, 99), new FlxPoint(232, 131), new FlxPoint(199, 146), new FlxPoint(200, 185), new FlxPoint(171, 187), new FlxPoint(172, 145)];
			headSweatArray[23] = [new FlxPoint(132, 133), new FlxPoint(156, 94), new FlxPoint(218, 99), new FlxPoint(232, 131), new FlxPoint(199, 146), new FlxPoint(200, 185), new FlxPoint(171, 187), new FlxPoint(172, 145)];
			headSweatArray[24] = [new FlxPoint(143, 101), new FlxPoint(190, 70), new FlxPoint(222, 92), new FlxPoint(239, 138), new FlxPoint(199, 145), new FlxPoint(195, 115)];
			headSweatArray[25] = [new FlxPoint(143, 101), new FlxPoint(190, 70), new FlxPoint(222, 92), new FlxPoint(239, 138), new FlxPoint(199, 145), new FlxPoint(195, 115)];
			headSweatArray[26] = [new FlxPoint(143, 101), new FlxPoint(190, 70), new FlxPoint(222, 92), new FlxPoint(239, 138), new FlxPoint(199, 145), new FlxPoint(195, 115)];
			headSweatArray[27] = [new FlxPoint(131, 131), new FlxPoint(151, 98), new FlxPoint(218, 99), new FlxPoint(234, 141), new FlxPoint(196, 160), new FlxPoint(195, 189), new FlxPoint(167, 186), new FlxPoint(167, 140)];
			headSweatArray[28] = [new FlxPoint(131, 131), new FlxPoint(151, 98), new FlxPoint(218, 99), new FlxPoint(234, 141), new FlxPoint(196, 160), new FlxPoint(195, 189), new FlxPoint(167, 186), new FlxPoint(167, 140)];
			headSweatArray[29] = [new FlxPoint(131, 131), new FlxPoint(151, 98), new FlxPoint(218, 99), new FlxPoint(234, 141), new FlxPoint(196, 160), new FlxPoint(195, 189), new FlxPoint(167, 186), new FlxPoint(167, 140)];
			headSweatArray[30] = [new FlxPoint(150, 101), new FlxPoint(181, 74), new FlxPoint(224, 84), new FlxPoint(240, 145), new FlxPoint(211, 150), new FlxPoint(210, 123), new FlxPoint(173, 107), new FlxPoint(154, 117), new FlxPoint(141, 109)];
			headSweatArray[31] = [new FlxPoint(150, 101), new FlxPoint(181, 74), new FlxPoint(224, 84), new FlxPoint(240, 145), new FlxPoint(211, 150), new FlxPoint(210, 123), new FlxPoint(173, 107), new FlxPoint(154, 117), new FlxPoint(141, 109)];
			headSweatArray[32] = [new FlxPoint(150, 101), new FlxPoint(181, 74), new FlxPoint(224, 84), new FlxPoint(240, 145), new FlxPoint(211, 150), new FlxPoint(210, 123), new FlxPoint(173, 107), new FlxPoint(154, 117), new FlxPoint(141, 109)];
			headSweatArray[36] = [new FlxPoint(136, 104), new FlxPoint(166, 73), new FlxPoint(200, 76), new FlxPoint(230, 106), new FlxPoint(198, 106), new FlxPoint(193, 147), new FlxPoint(167, 147), new FlxPoint(168, 102)];
			headSweatArray[37] = [new FlxPoint(136, 104), new FlxPoint(166, 73), new FlxPoint(200, 76), new FlxPoint(230, 106), new FlxPoint(198, 106), new FlxPoint(193, 147), new FlxPoint(167, 147), new FlxPoint(168, 102)];
			headSweatArray[38] = [new FlxPoint(136, 104), new FlxPoint(166, 73), new FlxPoint(200, 76), new FlxPoint(230, 106), new FlxPoint(198, 106), new FlxPoint(193, 147), new FlxPoint(167, 147), new FlxPoint(168, 102)];
			headSweatArray[39] = [new FlxPoint(159, 148), new FlxPoint(131, 136), new FlxPoint(154, 87), new FlxPoint(197, 79), new FlxPoint(236, 112), new FlxPoint(217, 123), new FlxPoint(191, 97), new FlxPoint(161, 114)];
			headSweatArray[40] = [new FlxPoint(159, 148), new FlxPoint(131, 136), new FlxPoint(154, 87), new FlxPoint(197, 79), new FlxPoint(236, 112), new FlxPoint(217, 123), new FlxPoint(191, 97), new FlxPoint(161, 114)];
			headSweatArray[41] = [new FlxPoint(159, 148), new FlxPoint(131, 136), new FlxPoint(154, 87), new FlxPoint(197, 79), new FlxPoint(236, 112), new FlxPoint(217, 123), new FlxPoint(191, 97), new FlxPoint(161, 114)];
			headSweatArray[42] = [new FlxPoint(194, 112), new FlxPoint(161, 109), new FlxPoint(150, 132), new FlxPoint(130, 124), new FlxPoint(172, 77), new FlxPoint(221, 90), new FlxPoint(232, 126), new FlxPoint(200, 142)];
			headSweatArray[43] = [new FlxPoint(194, 112), new FlxPoint(161, 109), new FlxPoint(150, 132), new FlxPoint(130, 124), new FlxPoint(172, 77), new FlxPoint(221, 90), new FlxPoint(232, 126), new FlxPoint(200, 142)];
			headSweatArray[44] = [new FlxPoint(194, 112), new FlxPoint(161, 109), new FlxPoint(150, 132), new FlxPoint(130, 124), new FlxPoint(172, 77), new FlxPoint(221, 90), new FlxPoint(232, 126), new FlxPoint(200, 142)];
			headSweatArray[48] = [new FlxPoint(170, 140), new FlxPoint(127, 126), new FlxPoint(145, 88), new FlxPoint(202, 77), new FlxPoint(228, 99), new FlxPoint(235, 126), new FlxPoint(197, 141)];
			headSweatArray[49] = [new FlxPoint(170, 140), new FlxPoint(127, 126), new FlxPoint(145, 88), new FlxPoint(202, 77), new FlxPoint(228, 99), new FlxPoint(235, 126), new FlxPoint(197, 141)];
			headSweatArray[51] = [new FlxPoint(161, 152), new FlxPoint(124, 137), new FlxPoint(151, 81), new FlxPoint(194, 77), new FlxPoint(228, 106), new FlxPoint(213, 117), new FlxPoint(194, 108), new FlxPoint(165, 122)];
			headSweatArray[52] = [new FlxPoint(161, 152), new FlxPoint(124, 137), new FlxPoint(151, 81), new FlxPoint(194, 77), new FlxPoint(228, 106), new FlxPoint(213, 117), new FlxPoint(194, 108), new FlxPoint(165, 122)];
			headSweatArray[54] = [new FlxPoint(152, 132), new FlxPoint(134, 127), new FlxPoint(148, 88), new FlxPoint(189, 77), new FlxPoint(232, 107), new FlxPoint(235, 136), new FlxPoint(192, 134), new FlxPoint(177, 142)];
			headSweatArray[55] = [new FlxPoint(152, 132), new FlxPoint(134, 127), new FlxPoint(148, 88), new FlxPoint(189, 77), new FlxPoint(232, 107), new FlxPoint(235, 136), new FlxPoint(192, 134), new FlxPoint(177, 142)];
			headSweatArray[60] = [new FlxPoint(171, 125), new FlxPoint(138, 108), new FlxPoint(175, 73), new FlxPoint(222, 86), new FlxPoint(234, 125), new FlxPoint(201, 131)];
			headSweatArray[61] = [new FlxPoint(171, 125), new FlxPoint(138, 108), new FlxPoint(175, 73), new FlxPoint(222, 86), new FlxPoint(234, 125), new FlxPoint(201, 131)];
			headSweatArray[63] = [new FlxPoint(169, 169), new FlxPoint(128, 143), new FlxPoint(148, 99), new FlxPoint(223, 105), new FlxPoint(235, 143), new FlxPoint(201, 172), new FlxPoint(197, 191), new FlxPoint(168, 191)];
			headSweatArray[64] = [new FlxPoint(169, 169), new FlxPoint(128, 143), new FlxPoint(148, 99), new FlxPoint(223, 105), new FlxPoint(235, 143), new FlxPoint(201, 172), new FlxPoint(197, 191), new FlxPoint(168, 191)];
			headSweatArray[65] = [new FlxPoint(169, 169), new FlxPoint(128, 143), new FlxPoint(148, 99), new FlxPoint(223, 105), new FlxPoint(235, 143), new FlxPoint(201, 172), new FlxPoint(197, 191), new FlxPoint(168, 191)];
			headSweatArray[66] = [new FlxPoint(169, 80), new FlxPoint(220, 86), new FlxPoint(242, 142), new FlxPoint(215, 148), new FlxPoint(202, 121), new FlxPoint(177, 113), new FlxPoint(157, 128), new FlxPoint(138, 113)];
			headSweatArray[67] = [new FlxPoint(169, 80), new FlxPoint(220, 86), new FlxPoint(242, 142), new FlxPoint(215, 148), new FlxPoint(202, 121), new FlxPoint(177, 113), new FlxPoint(157, 128), new FlxPoint(138, 113)];
			headSweatArray[69] = [new FlxPoint(170, 150), new FlxPoint(132, 129), new FlxPoint(155, 91), new FlxPoint(217, 97), new FlxPoint(231, 137), new FlxPoint(199, 148), new FlxPoint(197, 183), new FlxPoint(163, 185)];
			headSweatArray[70] = [new FlxPoint(170, 150), new FlxPoint(132, 129), new FlxPoint(155, 91), new FlxPoint(217, 97), new FlxPoint(231, 137), new FlxPoint(199, 148), new FlxPoint(197, 183), new FlxPoint(163, 185)];
			headSweatArray[71] = [new FlxPoint(170, 150), new FlxPoint(132, 129), new FlxPoint(155, 91), new FlxPoint(217, 97), new FlxPoint(231, 137), new FlxPoint(199, 148), new FlxPoint(197, 183), new FlxPoint(163, 185)];

			sweatAreas.splice(0, sweatAreas.length);
			sweatAreas.push({chance:6, sprite:_head, sweatArrayArray:headSweatArray});
			sweatAreas.push({chance:4, sprite:_pokeWindow._torso1, sweatArrayArray:torsoSweatArray});
		}

		encouragementWords = wordManager.newWords();
		encouragementWords.words.push([ { graphic:AssetPaths.buizel_words_small__png, frame:0 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.buizel_words_small__png, frame:1 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.buizel_words_small__png, frame:2 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.buizel_words_small__png, frame:3 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.buizel_words_small__png, frame:4 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.buizel_words_small__png, frame:5 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.buizel_words_small__png, frame:6 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.buizel_words_small__png, frame:7 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.buizel_words_small__png, frame:8 } ]);

		boredWords = wordManager.newWords(3);
		boredWords.words.push([{ graphic:AssetPaths.buizel_words_small__png, frame:9 }]);
		boredWords.words.push([{ graphic:AssetPaths.buizel_words_small__png, frame:10 }]);
		boredWords.words.push([{ graphic:AssetPaths.buizel_words_small__png, frame:11 }]);
		boredWords.words.push([ // don't you want to...?
		{ graphic:AssetPaths.buizel_words_small__png, frame:12 },
		{ graphic:AssetPaths.buizel_words_small__png, frame:14, yOffset:18, delay:0.5 }
		]);
		boredWords.words.push([ // what are you, makin' me wait?
		{ graphic:AssetPaths.buizel_words_small__png, frame:13 },
		{ graphic:AssetPaths.buizel_words_small__png, frame:15, yOffset:18, delay:0.5 },
		{ graphic:AssetPaths.buizel_words_small__png, frame:17, yOffset:32, delay:1.0 }
		]);

		neckWords = wordManager.newWords();
		neckWords.words.push([ // um... don't rub that
		{ graphic:AssetPaths.buizel_words_small__png, frame:16 },
		{ graphic:AssetPaths.buizel_words_small__png, frame:18, yOffset:16, delay:0.5 },
		{ graphic:AssetPaths.buizel_words_small__png, frame:20, yOffset:32, delay:1.0 }
		]);
		neckWords.words.push([ // why. just, why.
		{ graphic:AssetPaths.buizel_words_small__png, frame:19 },
		{ graphic:AssetPaths.buizel_words_small__png, frame:21, yOffset:18, delay:1.0 }
		]);

		notReadyWords = wordManager.newWords();
		notReadyWords.words.push([{ graphic:AssetPaths.buizel_words_small__png, frame:22 }]);
		notReadyWords.words.push([{ graphic:AssetPaths.buizel_words_small__png, frame:23 }]);
		notReadyWords.words.push([{ graphic:AssetPaths.buizel_words_small__png, frame:24 }]);
		notReadyWords.words.push([{ graphic:AssetPaths.buizel_words_small__png, frame:25 }]);

		pleasureWords = wordManager.newWords();
		pleasureWords.words.push([{ graphic:AssetPaths.buizel_words_medium__png, frame:0, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.buizel_words_medium__png, frame:1, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.buizel_words_medium__png, frame:2, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.buizel_words_medium__png, frame:3, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.buizel_words_medium__png, frame:4, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.buizel_words_medium__png, frame:5, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.buizel_words_medium__png, frame:6, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.buizel_words_medium__png, frame:7, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.buizel_words_medium__png, frame:8, height:48, chunkSize:5 } ]);

		almostWords = wordManager.newWords(15);
		almostWords.words.push([ // -i think i'm going to--
		{ graphic:AssetPaths.buizel_words_medium__png, frame:9, height:48, chunkSize:8 },
		{ graphic:AssetPaths.buizel_words_medium__png, frame:11, height:48, chunkSize:8, yOffset:20, delay:0.75 }
		]);
		almostWords.words.push([ // s-sorry, i think i--
		{ graphic:AssetPaths.buizel_words_medium__png, frame:10, height:48, chunkSize:8 },
		{ graphic:AssetPaths.buizel_words_medium__png, frame:12, height:48, chunkSize:8, yOffset:20, delay:0.75 }
		]);
		almostWords.words.push([ // ohh man, i'm about to--
		{ graphic:AssetPaths.buizel_words_medium__png, frame:13, height:48, chunkSize:8 },
		{ graphic:AssetPaths.buizel_words_medium__png, frame:15, height:48, chunkSize:8, yOffset:20, delay:0.75 }
		]);
		almostWords.words.push([ // i can't-- i'm gonna...!
		{ graphic:AssetPaths.buizel_words_medium__png, frame:14, height:48, chunkSize:8 },
		{ graphic:AssetPaths.buizel_words_medium__png, frame:16, height:48, chunkSize:8, yOffset:20, delay:0.75 }
		]);

		orgasmWords = wordManager.newWords();
		orgasmWords.words.push([ { graphic:AssetPaths.buizel_words_large__png, frame:0, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.buizel_words_large__png, frame:1, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.buizel_words_large__png, frame:2, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.buizel_words_large__png, frame:3, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.buizel_words_large__png, frame:4, width:200, height:150, yOffset: -30, chunkSize:5 } ]);

		// you brought a dildo this time, huh? ....yeah! let's do this
		toyStartWords.words.push([
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:0},
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:2, yOffset:16, delay:0.7 },
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:4, yOffset:36, delay:1.5 },
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:6, yOffset:56, delay:3.0 },
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:8, yOffset:76, delay:3.6 },
		]);
		// careful where you point that thing! ...bwark!!
		toyStartWords.words.push([
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:1},
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:3, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:5, yOffset:40, delay:1.6 },
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:7, yOffset:64, delay:2.9 },
		]);
		// aww yeah!! let me find you a better angle~
		toyStartWords.words.push([
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:9},
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:11, yOffset:22, delay:1.3 },
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:13, yOffset:42, delay:2.1 },
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:15, yOffset:62, delay:2.9 },
		]);

		// bweh? ...adios, mister dildo
		toyInterruptWords.words.push([
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:10},
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:12, yOffset:0, delay:0.5 },
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:14, yOffset:22, delay:1.4 }
		]);
		// ...changed your mind?
		toyInterruptWords.words.push([
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:16},
		{ graphic:AssetPaths.buizdildo_words_small__png, frame:18, yOffset:22, delay:0.8 },
		]);
	}

	override function penetrating():Bool
	{
		if (specialRub == "ass0")
		{
			return true;
		}
		if (specialRub == "ass1")
		{
			return true;
		}
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

	function decreaseSensitivity():Void
	{
		if (sensitivity > 1)
		{
			sensitivityArray.splice(0, sensitivityArray.length);
			while (sensitivityArray.length < 20)
			{
				sensitivityArray.push((sensitivityArray.length + 1) * sensitivity * FlxG.random.float(0.008, .0125));
			}
			_autoSweatRate /= 2;
			sensitivity--;
		}
	}

	override public function computeChatComplaints(complaints:Array<Int>):Void
	{
		if (_male && sensitivity >= 4 || !_male && sensitivity >= 5)
		{
			complaints.push(0);
		}
		if (_male && sensitivity >= 3 || !_male && sensitivity >= 4)
		{
			complaints.push(1);
		}
		if (meanThings[0] == false)
		{
			complaints.push(2);
		}
		if (meanThings[1] == false)
		{
			complaints.push(3);
		}
	}

	override function computePrecumAmount():Int
	{
		var precumAmount:Int = 0;
		if (displayingToyWindow())
		{
			if (FlxG.random.float(-2, 4) > shortestToyPatternLength)
			{
				precumAmount++;
			}

			var toyStr:String = rubHandAnimToToyStr[_prevHandAnim];
			if (toyStr == "1" && FlxG.random.bool(20))
			{
				precumAmount++;
			}
			else if (toyStr == "2" && FlxG.random.bool(20))
			{
				precumAmount++;
			}
			else if (toyStr == "3" && FlxG.random.bool(20))
			{
				precumAmount++;
			}

			if (toyOnTrack && FlxG.random.bool(50))
			{
				precumAmount++;
			}
			else if (!toyOnTrack && FlxG.random.bool(50))
			{
				precumAmount--;
			}

			if (FlxG.random.float(1, 4) < _heartEmitCount)
			{
				precumAmount++;
			}

			return precumAmount;
		}
		if (FlxG.random.float(0.05, 0.75) < _autoSweatRate)
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
		if (FlxG.random.float(1, 12) < specialSpotCount)
		{
			precumAmount++;
		}
		return precumAmount;
	}

	override function handleRubReward():Void
	{
		if (specialRub != "jack-off" && specialRubs[specialRubs.length - 2] == "jack-off")
		{
			// stopped jacking off
			decreaseSensitivity();
		}
		if (specialRub == "jack-off" && specialRubs[specialRubs.length - 2] != "jack-off")
		{
			if (!readyForJackOff)
			{
				_autoSweatRate += 0.33;
				scheduleSweat(FlxG.random.int(2, 4));
			}
			if (!readyForJackOff && meanThings[1] == true)
			{
				// started jacking off a second time without finding a "special spot"
				maybeEmitWords(notReadyWords);
				meanThings[1] = false;
				doMeanThing();
				_autoSweatRate += 0.16;
			}
			readyForJackOff = false;
		}
		if (specialRub == "ass0" || specialRub == "ass1")
		{
			if (specialRub == "ass0" && _assTightness > 2.5 || specialRub == "ass1")
			{
				setAssTightness(_assTightness * FlxG.random.float(0.72, 0.82));
				if (_rubBodyAnim != null)
				{
					_rubBodyAnim.refreshSoon();
				}
				if (_rubHandAnim != null)
				{
					_rubHandAnim.refreshSoon();
				}
			}
		}

		var specialSpot:Int = specialSpots.indexOf(specialRub);
		if (specialSpot != -1 && !readyForJackOff)
		{
			scheduleBreath();
			var consecutive:Int = specialRubsInARow();
			if (specialSpotCount == 2 && _male)
			{
				blushTimer = FlxG.random.float(3, 4);
				if (consecutive >= FlxG.random.int(1, 2))
				{
					emitWords(pleasureWords);
					doNiceThing();
					readyForJackOff = true;
					specialSpots[specialSpot] = null;
					specialSpotCount++;
				}
			}
			else if (specialSpotCount == 4)
			{
				blushTimer = FlxG.random.float(4, 5);
				if (consecutive >= 2)
				{
					emitWords(pleasureWords);
					doNiceThing();
					readyForJackOff = true;
					specialSpots[specialSpot] = null;
					specialSpotCount++;
				}
			}
			else if (specialSpotCount == 5)
			{
				if (consecutive >= 2)
				{
					blushTimer = FlxG.random.float(5, 6);
				}
				if (consecutive >= 3)
				{
					emitWords(pleasureWords);
					doNiceThing();
					readyForJackOff = true;
					specialSpots[specialSpot] = null;
					specialSpotCount++;
					if (specialRub == "ass1")
					{
						specialSpotCount++;
					}
				}
			}
			else
			{
				specialSpots[specialSpot] = null;
				specialSpotCount++;
			}
		}
		// rubbing neck twice consecutively
		if (meanThings[0] == true)
		{
			var lastTwo:Array<String> = specialRubs.slice(-2);
			if (lastTwo.length == 2 && lastTwo[0] == "neck" && lastTwo[1] == "neck")
			{
				emitWords(neckWords);
				meanThings[0] = false;
				doMeanThing();
			}
		}

		if (penetrating())
		{
			_rubRewardTimer -= 1;
		}
		_heartEmitTimer = 0;

		var amount:Float = 0;
		if (specialRub == "jack-off" || _male && specialRub == "ass1" && specialSpotCount == 7)
		{
			var lucky:Float = lucky(0.7, 1.43, sensitivityArray[0]);
			if (sensitivityArray.length > 2)
			{
				sensitivityArray.splice(0, 1);
			}
			else
			{
				sensitivityArray[0] = sensitivityArray[1];
			}
			_autoSweatRate += lucky;
			amount = SexyState.roundUpToQuarter(lucky * _heartBank._dickHeartReservoir);
			_heartBank._dickHeartReservoir -= amount;
			_heartEmitCount += amount;

			var predictedReservoir0:Float = _heartBank._dickHeartReservoir - SexyState.roundUpToQuarter(sensitivityArray[0] * _heartBank._dickHeartReservoir);
			var predictedReservoir1:Float = predictedReservoir0 - SexyState.roundUpToQuarter(sensitivityArray[1] * _heartBank._dickHeartReservoir);
			if (predictedReservoir1 / _heartBank._dickHeartReservoirCapacity <= _cumThreshold && almostWords.timer <= 0)
			{
				blushTimer = FlxG.random.float(3, 4);
			}
			if (_remainingOrgasms > 0 && predictedReservoir0 / _heartBank._dickHeartReservoirCapacity <= _cumThreshold)
			{
				if (specialSpotCount > 3 && almostWords.timer <= 0)
				{
					blushTimer = FlxG.random.float(12, 15);
				}
				maybeEmitWords(almostWords);
			}
			maybeScheduleBreath();
		}
		else {
			var lucky:Float = lucky(0.7, 1.43, 0.15);
			if (specialRub == "ass0")
			{
				lucky = 0.01;
			}
			if (specialRub == "ass1")
			{
				lucky *= 2;
			}
			if (specialRub == "neck")
			{
				lucky = 0.01;
			}
			if (pastBonerThreshold())
			{
				lucky *= 0.5;
			}
			amount = SexyState.roundUpToQuarter(lucky * _heartBank._foreplayHeartReservoir);
			_heartBank._foreplayHeartReservoir -= amount;
			_heartEmitCount += amount;
		}

		if (specialRub != "neck")
		{
			emitCasualEncouragementWords();
		}
		if (_heartEmitCount > 0)
		{
			maybePlayPokeSfx();
			maybeEmitPrecum();
		}
	}

	function setAssTightness(assTightness:Float)
	{
		this._assTightness = assTightness;

		var tightness0:Int = 3;
		var tightness1:Int = 2;

		if (_assTightness > 4)
		{
			tightness0 = 3;
			tightness1 = 2;
		}
		else if (_assTightness > 3.5)
		{
			tightness0 = 4;
			tightness1 = 2;
		}
		else if (_assTightness > 3.0)
		{
			tightness0 = 5;
			tightness1 = 2;
		}
		else if (_assTightness > 2.5)
		{
			tightness0 = 6;
			tightness1 = 2;
		}
		else if (_assTightness > 2.0)
		{
			tightness0 = 6;
			tightness1 = 3;
		}
		else if (_assTightness > 1.5)
		{
			tightness0 = 6;
			tightness1 = 4;
		}
		else if (_assTightness > 1.0)
		{
			tightness0 = 6;
			tightness1 = 5;
		}
		else
		{
			tightness0 = 6;
			tightness1 = 6;
		}

		_pokeWindow._ass.animation.add("finger-ass0", [0, 1, 2, 3, 4, 5].slice(0, tightness0));
		_pokeWindow._ass.animation.add("finger-ass1", [0, 6, 7, 8, 9, 10].slice(0, tightness1));
		_pokeWindow._interact.animation.add("finger-ass0", [24, 25, 26, 27, 28, 29].slice(0, tightness0));
		_pokeWindow._interact.animation.add("finger-ass1", [32, 33, 34, 35, 36, 37].slice(0, tightness1));
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
				if (_dick.animation.name != "boner2")
				{
					_dick.animation.play("boner2");
				}
			}
			else if (_heartBank.getForeplayPercent() < 0.8)
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

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		_pokeWindow._ass.animation.add("finger-ass0", [0, 1, 2]);
		_pokeWindow._ass.animation.add("finger-ass1", [0, 6]);
		_pokeWindow._interact.animation.add("finger-ass0", [24, 25, 26]);
		_pokeWindow._interact.animation.add("finger-ass1", [32, 33]);

		dildoUtils.reinitializeHandSprites();
	}

	override public function eventShowToyWindow(args:Array<Dynamic>)
	{
		super.eventShowToyWindow(args);
		dildoUtils.showToyWindow();

		toyInterface.setTightness(_assTightness, 0);
		ambientDildoBankCapacity = SexyState.roundUpToQuarter(_toyBank._foreplayHeartReservoir * 0.05);
		pleasurableDildoBankCapacity = SexyState.roundUpToQuarter(_toyBank._foreplayHeartReservoir * 0.10);
	}

	override public function eventHideToyWindow(args:Array<Dynamic>)
	{
		super.eventHideToyWindow(args);
		dildoUtils.hideToyWindow();

		setAssTightness(toyInterface.assTightness);
	}

	override public function back():Void
	{
		// if the foreplayHeartReservoir is empty (or half empty), empty the
		// dick heart reservoir too -- that way the toy meter won't stay full.
		_toyBank._dickHeartReservoir = Math.min(_toyBank._dickHeartReservoir, SexyState.roundDownToQuarter(_toyBank._defaultDickHeartReservoir * _toyBank.getForeplayPercent()));
		// refund any toy hearts left in the bank
		_toyBank._foreplayHeartReservoir += ambientDildoBank;
		_toyBank._foreplayHeartReservoir += pleasurableDildoBank;

		super.back();
	}

	override function cursorSmellPenaltyAmount():Int
	{
		return 45;
	}

	override public function destroy():Void
	{
		super.destroy();

		ballOpacityTween = FlxTweenUtil.destroy(ballOpacityTween);
		dickOpacityTween = FlxTweenUtil.destroy(dickOpacityTween);
		neckWords = null;
		notReadyWords = null;
		rightBallPolyArray = null;
		assPolyArray = null;
		floofPolyArray = null;
		leftThighPolyArray = null;
		rightThighPolyArray = null;
		vagPolyArray = null;
		sensitivityArray = null;
		specialSpots = null;
		meanThings = null;

		toyWindow = FlxDestroyUtil.destroy(toyWindow);
		toyInterface = FlxDestroyUtil.destroy(toyInterface);
		rubHandAnimToToyStr = null;
		toyPattern = null;
		remainingToyPattern = null;
		dildoUtils = FlxDestroyUtil.destroy(dildoUtils);
		xlDildoButton = FlxDestroyUtil.destroy(xlDildoButton);
	}
}