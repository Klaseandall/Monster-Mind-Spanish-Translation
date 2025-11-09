package poke.sand;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import kludge.FlxSoundKludge;
import openfl.utils.Object;
import poke.buiz.DildoUtils;
import poke.sand.SandslashWindow;
import poke.sexy.FancyAnim;
import poke.sexy.SexyState;
import poke.sexy.WordManager.Qord;

/**
 * Sex sequence for Sandslash
 * 
 * Sandslash always starts with his arms spread wide; this means he wants you
 * to touch his dick.
 * 
 * After rubbing his dick for awhile, Sandslash will close his arms, which
 * means he wants you to touch something else. You want to alternate touching
 * his dick and not touching his dick so that you keep him aroused without
 * being too monotonous.
 * 
 * Fingering his ass is also arousing, and can keep his arms closed -- but not
 * as much as rubbing his dick.
 * 
 * Playing with his balls is also good for a "break", and can open his arms --
 * but not as much as rubbing somewhere else.
 * 
 * Sandslash likes when you rub both of his pectoral muscles (left and right)
 * and his dick. He wants you to do that at least once.
 * 
 * At some point early on, Sandslash will suddenly huff out a breath, make an
 * inquisitive Sandslash sound, and possibly say something like "hey get those
 * fingers up here." If you put your fingers in his mouth, it will make him
 * happy.
 * 
 * After he sucks your fingers once, there's something specific he wants to
 * taste: either his feet, his balls, his armpit, or his ass. This is different
 * each time. But after rubbing one of these areas, he'll once again huff out a
 * breath, make an inquisitive Sandslash sound, and possibly say something like
 * "hey give me a taste of that." If you put your fingers in the mouth when it
 * has the appropriate taste, it'll make him happy again. You only really get
 * one chance at this, so pay attention to his signals!
 * 
 * If you finger Sandslash's ass, your glove gradually gets deeper and deeper.
 * If it gets too deep, he might get carried away and your glove will be lost
 * inside him. After something like this happens, it will take an hour or two
 * before he'll make the same mistake again.
 * 
 * Sandslash will happily have sex again and again in Heracross's backroom. He
 * still has a limit, but it is much much higher than any other Pokemon.
 * 
 * For the sex toy, Sandslash has a proper depth and pace they like, but this
 * changes each time based on what they were up to the night before -- so you
 * have to deduce it.
 * 
 * The easiest way to find the appropriate pace is to finger them with a slow
 * pace, and gradually accelerate until you notice more hearts come out. If you
 * accelerate too much, fewer hearts will come out. This will give you an idea
 * of how fast you should go. You can similarly deduce the pace by just
 * speeding up and slowing down with the dildo, but this will wear their
 * patience.
 * 
 * The easiest way to find the appropriate depth is to gradually increase your
 * depth until you see them lower their leg. They open their legs when they
 * want you to get deeper, but close their legs when they're getting
 * uncomfortable.
 * 
 * If you find the correct depth and pace, they'll sweat more, and eventually
 * have a powerful orgasm. This can result in multiple orgasms for male
 * Sandslash.
 */
class SandslashSexyState extends SexyState<SandslashWindow>
{
	// areas that you can click
	private var mouthPolyArray:Array<Array<FlxPoint>>;
	private var assPolyArray:Array<Array<FlxPoint>>;
	private var leftPecPolyArray:Array<Array<FlxPoint>>;
	private var rightPecPolyArray:Array<Array<FlxPoint>>;
	private var leftFootPolyArray:Array<Array<FlxPoint>>;
	private var rightFootPolyArray:Array<Array<FlxPoint>>;
	private var vagPolyArray:Array<Array<FlxPoint>>;

	private var rubDickWords:Qord;
	private var tasteWords:Qord;
	private var dildoTooFastWords:Qord;
	private var dildoDeeperWords:Qord;
	private var dildoNiceWords:Qord;
	private var phoneNiceWords:Qord;
	private var phoneStartWords:Qord;
	private var phoneInterruptWords:Qord;

	private var _assTightness:Float = 4.5;

	/*
	 * "kelv" sort of works like the balance meter in a Tony Hawk game, you
	 * want to keep it centered. These variables are responsible for jittering
	 * the kelv value randomly up and down, and the player should try to keep
	 * it in the middle where Sandslash is content
	 */
	private var kelv:Int = 0;
	private var kelvDelta:Int = 0;
	private var kelvGoal:Int = FlxG.random.int(20, 40);
	private var kelvSway:Int = FlxG.random.getObject([ -5, -3, -1, 1, 3, 5]);
	private var kelvMiss:Array<Int> = [];
	private var cumulativeKelvMiss:Int = 0;

	private var heartPenalty:Float = 1.0;

	/*
	 * niceThings[0] = rub both of Sandslash's pecs, and his dick
	 * niceThings[1] = let Sandslash suck your fingers after rubbing his sweaty body
	 * niceThings[2] = (male only) let Sandslash suck your fingers a second time after rubbing a special place
	 */
	private var niceThings:Array<Bool> = [true, true, true];

	/*
	 * meanThings[0] = jack off Sandslash TOO much (yes, it's possible)
	 * meanThings[1] = don't jack off Sandslash enough (how dare you!)
	 */
	private var meanThings:Array<Bool> = [true, true];

	// sandslash's mood today
	private var sandMood0 = FlxG.random.int(0, 4);
	private var sandMood1 = FlxG.random.int(0, 4);
	private var smellyRub = FlxG.random.getObject(["foot", "rub-balls", "-pec", "ass"]);
	private var tasteTimer0:Int = -1;
	private var tasteTimer1:Int = -1;

	private var curArousedFrameIndex:Int = -1;
	private var curArousedFrameIndexDir:Int = 0;
	private var emergency:Bool = false;
	private var canLoseHand:Bool = true;
	private var permaBoner:Bool = false;
	private var phoneButton:FlxButton;
	private var insertedPhone:Bool = false; // did sandslash put a phone in their butt/vagina?

	private var smallDildoButton:FlxButton;
	private var toyWindow:SandslashDildoWindow;
	private var toyInterface:SandslashDildoInterface;
	private var dildoUtils:DildoUtils;
	public var cameFromHandjob:Bool = false; // should the "input port" line refer to your input port, or his?

	private var toyPrecumTimer:Float = 0;
	private var addToyHeartsToOrgasm:Bool = false;
	private var ambientDildoBank:Float = 0;
	private var defaultAmbientDildoBankCapacity:Float = 0;
	private var ambientDildoBankCapacity:Float = 0;
	private var ambientDildoBankTimer:Float = 0;
	private var targetDildoDuration:Float = 0;
	private var targetDildoDepth:Float = 0;
	private var goodDepth:Bool = false;
	private var badDepth:Bool = false;
	private var goodDildoCounter:Int = 0;
	private var maxGoodDildoCounter:Int = 0;
	private var bonusDildoOrgasmTimer:Int = -1;
	private var ambientDildoBankFillCount:Int = 0;
	private var dildoDepthWrongness:Float = 0;
	private var dildoDurationWrongness:Float = 0;
	private var dildoTooShallowCombo:Int = 0;
	private var dildoTooFastCombo:Int = 0;
	private var dildoNiceDepthCombo:Int = 0;
	private var dildoNiceSpeedCombo:Int = 0;
	private var dildoPoseTimer:Float = 0;

	override public function create():Void
	{
		prepare("sand");

		toyWindow = new SandslashDildoWindow(256, 0, 248, 426);
		toyInterface = new SandslashDildoInterface();
		toyGroup.add(toyWindow);
		toyGroup.add(toyInterface);

		dildoUtils = new DildoUtils(this, toyInterface, toyWindow.ass, toyWindow._dick, toyWindow.dildo, toyWindow._interact);
		dildoUtils.refreshDildoAnims = refreshDildoAnims;
		dildoUtils.dildoFrameToPct = [
			1 => 0.12,
			2 => 0.17,
			3 => 0.23,
			4 => 0.28,
			5 => 0.34,
			6 => 0.45,
			7 => 0.56,
			8 => 0.67,
			9 => 0.78,
			10 => 0.89,
			11 => 1.00,

			12 => 0.12,
			13 => 0.17,
			14 => 0.23,
			15 => 0.28,
			16 => 0.34,
			17 => 0.45,
			18 => 0.56,
			19 => 0.67,
			20 => 0.78,
			21 => 0.89,
			22 => 1.00,
		];

		super.create();

		_pokeWindow._openness = SandslashWindow.Openness.Open;
		_pokeWindow.arrangeArmsAndLegs();

		_bonerThreshold = 0.7;

		if (!_male)
		{
			// no "finger sucking after rubbing smelly place" for girls
			niceThings[2] = false;
		}

		sfxEncouragement = [AssetPaths.sand0__mp3, AssetPaths.sand1__mp3, AssetPaths.sand2__mp3, AssetPaths.sand3__mp3];
		sfxPleasure = [AssetPaths.sand4__mp3, AssetPaths.sand5__mp3, AssetPaths.sand6__mp3];
		sfxOrgasm = [AssetPaths.sand7__mp3, AssetPaths.sand8__mp3, AssetPaths.sand9__mp3];

		popularity = 0.1;
		cumTrait0 = 8;
		cumTrait1 = 4;
		cumTrait2 = 2;
		cumTrait3 = 4;
		cumTrait4 = 5;

		_rubRewardFrequency = 2.5;
		_minRubForReward = 2;

		targetDildoDuration = FlxG.random.float(0.5, 2.0);
		targetDildoDepth = FlxG.random.float(0.45, 0.90);

		if (PlayerData.recentChatTime("sand.sexyVeryBad") <= 20)
		{
			// He very recently made this mistake; he won't make it again right away
			canLoseHand = false;
		}
		else if (PlayerData.playerIsInDen)
		{
			// Losing your hand in the den would open up a can of worms; let's just say you can't.
			canLoseHand = false;
		}
		else if (PlayerData.pokemonLibido == 1)
		{
			canLoseHand = false;
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_BLUE_DILDO))
		{
			smallDildoButton = newToyButton(smallDildoButtonEvent, AssetPaths.dildo_blue_button__png, _dialogTree);
			addToyButton(smallDildoButton, 0.31);
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_HUGE_DILDO))
		{
			var xlDildoButton:FlxButton = newToyButton(xlDildoButtonEvent, AssetPaths.dildo_xl_button__png, _dialogTree);
			addToyButton(xlDildoButton);
		}
	}

	public function xlDildoButtonEvent():Void
	{
		playButtonClickSound();
		toyButtonsEnabled = false;
		maybeEmitWords(toyStartWords);
		var time:Float = eventStack._time;
		eventStack.addEvent({time:time += 0.8, callback:eventTakeBreak, args:[2.5]});
		eventStack.addEvent({time:time += 0.5, callback:eventShowToyWindow});
		eventStack.addEvent({time:time += 2.2, callback:eventEnableToyButtons});
	}

	public function phoneButtonEvent():Void
	{
		playButtonClickSound();
		removeToyButton(phoneButton);

		toyButtonsEnabled = false;
		toyWindow.setPhoneEnabled();

		// phone has special start/stop words...
		toyStartWords = phoneStartWords;
		toyInterruptWords = phoneInterruptWords;
		dildoNiceWords = phoneNiceWords;

		maybeEmitWords(toyStartWords);
		var time:Float = eventStack._time;
		eventStack.addEvent({time:time += 0.8, callback:eventTakeBreak, args:[2.5]});
		eventStack.addEvent({time:time += 0.5, callback:eventShowToyWindow});
		eventStack.addEvent({time:time += 2.2, callback:eventEnableToyButtons});
	}

	public function smallDildoButtonEvent():Void
	{
		playButtonClickSound();
		removeToyButton(smallDildoButton);
		var tree:Array<Array<Object>> = [];
		SandslashDialog.snarkySmallDildo(tree);
		showEarlyDialog(tree);
	}

	override public function shouldEmitToyInterruptWords():Bool
	{
		return _toyBank.getForeplayPercent() > 0.7 && _toyBank.getDickPercent() > 0.7;
	}

	override function toyForeplayFactor():Float
	{
		/*
		 * 15% of the toy hearts are available for doing random stuff. the
		 * other 85% are only available if you hit the right spot
		 */
		return 0.15;
	}

	override public function getToyWindow():PokeWindow
	{
		return toyWindow;
	}

	override public function handleToyWindow(elapsed:Float):Void
	{
		super.handleToyWindow(elapsed);

		toyPrecumTimer -= elapsed;
		dildoPoseTimer -= elapsed;

		dildoUtils.update(elapsed);

		handleToyReward(elapsed);

		if (FlxG.mouse.justPressed && toyInterface.animName != null)
		{
			if (toyInterface.ass)
			{
				if (toyInterface.animName == "dildo-ass")
				{
					toyInterface.setTightness(toyInterface.assTightness * FlxG.random.float(0.90, 0.94), toyInterface.vagTightness);
				}
			}
			else
			{
				if (toyInterface.animName == "dildo-vag")
				{
					toyInterface.setTightness(toyInterface.assTightness, toyInterface.vagTightness * FlxG.random.float(0.90, 0.94));
				}
			}
		}
	}

	public function refreshDildoAnims():Bool
	{
		var refreshed:Bool = false;
		if (toyInterface.animName == "rub-vag")
		{
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._dick, "rub-vag", [5, 4, 3, 2, 1], 2);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "rub-vag", [5, 4, 3, 2, 1], 2);
		}
		else if (toyInterface.animName == "finger-vag")
		{
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._dick, "finger-vag", [6, 7, 8, 9, 10], 2);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "finger-vag", [6, 7, 8, 9, 10], 2);
		}
		else if (toyInterface.animName == "dildo-vag")
		{
			if (toyWindow.isPhoneEnabled())
			{
				insertedPhone = true;
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._dick, "dildo-vag", [12, 13, 14, 15, 23, 15, 23, 15, 23, 14], 2, 6);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.dildo, "dildo-vag", [13, 14, 15, 16, 17, 18, 19, 20, 21, 22], 2, 6);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-vag", [11, 12, 13, 14, 15, 16, 17, 18, 19, 20], 2, 6);
			}
			else
			{
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._dick, "dildo-vag", [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22], 2, 6);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.dildo, "dildo-vag", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 2, 6);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-vag", [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21], 2, 6);
			}
		}
		else if (toyInterface.animName == "rub-ass")
		{
			refreshed = dildoUtils.refreshDildoAnim(toyWindow.ass, "rub-ass", [6, 7, 8, 9], 2);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "rub-ass", [24, 25, 26, 27], 2);
		}
		else if (toyInterface.animName == "finger-ass")
		{
			refreshed = dildoUtils.refreshDildoAnim(toyWindow.ass, "finger-ass", [0, 10, 11, 12, 13], 2);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "finger-ass", [28, 29, 30, 22, 23], 2);
		}
		else if (toyInterface.animName == "dildo-ass")
		{
			if (toyWindow.isPhoneEnabled())
			{
				insertedPhone = true;
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.ass, "dildo-ass", [14, 15, 16, 16, 17, 17, 18, 18, 17, 16], 2, 6);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.dildo, "dildo-ass", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 2, 6);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-ass", [32, 33, 34, 35, 36, 37, 38, 39, 40, 41], 2, 6);
			}
			else
			{
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.ass, "dildo-ass", [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24], 2, 6);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.dildo, "dildo-ass", [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22], 2, 6);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-ass", [32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42], 2, 6);
			}
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

			if (goodDepth && ambientDildoBankCapacity < defaultAmbientDildoBankCapacity * 3.00)
			{
				ambientDildoBankCapacity = FlxMath.bound(ambientDildoBankCapacity * 1.333, defaultAmbientDildoBankCapacity * 0.5, defaultAmbientDildoBankCapacity * 3.00);
				goodDepth = false;
			}
			if (badDepth && ambientDildoBankCapacity > defaultAmbientDildoBankCapacity * 0.50)
			{
				ambientDildoBankCapacity = FlxMath.bound(ambientDildoBankCapacity * 0.75, defaultAmbientDildoBankCapacity * 0.5, defaultAmbientDildoBankCapacity * 3.00);
				badDepth = false;
			}

			fillAmbientDildoBank();
		}

		if (_rubHandAnim != null && _rubHandAnim.sfxLength > 0)
		{
			if (_rubHandAnim.mouseDownSfx)
			{
				var amount:Float = SexyState.roundUpToQuarter(lucky(0.3, 0.7) * ambientDildoBank);
				ambientDildoBank -= amount;

				/*
				 * howGood=0: wrong;
				 * howGood=1: good depth or good pace;
				 * howGood=2: good depth AND good pace
				 */
				var howGood:Int = 0;

				var uncomfortable:Bool = false;

				dildoDurationWrongness = 0;
				if (_rubHandAnim._prevMouseUpTime == FancyAnim.DEFAULT_MOUSE_TIME && _rubHandAnim._prevMouseDownTime == FancyAnim.DEFAULT_MOUSE_TIME)
				{
					// first click; doesn't establish a pattern
					dildoTooFastCombo = 0;
					dildoNiceSpeedCombo = 0;
				}
				else
				{
					var howCloseLow:Float = (_rubHandAnim._prevMouseUpTime + _rubHandAnim._prevMouseDownTime - 0.06) / targetDildoDuration;
					var howCloseHi:Float = (_rubHandAnim._prevMouseUpTime + _rubHandAnim._prevMouseDownTime + 0.06) / targetDildoDuration;
					dildoDurationWrongness = (_rubHandAnim._prevMouseUpTime + _rubHandAnim._prevMouseDownTime) / targetDildoDuration - 1.0;

					if (howCloseHi < 0.83)
					{
						dildoTooFastCombo++;
						if (dildoTooFastCombo >= 3)
						{
							maybeEmitWords(dildoTooFastWords);
						}
					}
					else
					{
						dildoTooFastCombo = 0;
					}

					if (howCloseHi < 0.75)
					{
						uncomfortable = true;
						dildoNiceSpeedCombo = 0;
					}
					else if (howCloseHi < 0.83)
					{
						dildoNiceSpeedCombo = 0;
					}
					else if (howCloseLow > 1.33)
					{
						if (_rubHandAnim._flxSprite.animation.name == "dildo-vag" || _rubHandAnim._flxSprite.animation.name == "dildo-ass")
						{
							uncomfortable = true;
						}
						dildoNiceSpeedCombo = 0;
					}
					else if (howCloseLow > 1.2)
					{
						dildoNiceSpeedCombo = 0;
					}
					else
					{
						var pleasureAmount:Float = SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * 0.015);
						drainToyDickHeartReservoir(pleasureAmount);
						amount += pleasureAmount;
						howGood++;
						dildoNiceSpeedCombo++;
					}
				}

				dildoDepthWrongness = 0;
				if (_rubHandAnim._flxSprite.animation.name == "dildo-vag" || _rubHandAnim._flxSprite.animation.name == "dildo-ass")
				{
					dildoDepthWrongness = toyInterface.animPct - targetDildoDepth;

					if (toyInterface.animPct < targetDildoDepth - 0.06)
					{
						dildoTooShallowCombo++;
						if (dildoTooShallowCombo >= 3)
						{
							if (toyInterface.animPct <= toyInterface.getMaxAnimPct() - 0.1)
							{
								// pushing as deep as we can; sandslash shouldn't chastize us
							}
							else
							{
								maybeEmitWords(dildoDeeperWords);
							}
						}
					}
					else
					{
						dildoTooShallowCombo = 0;
					}

					if (toyInterface.animPct > targetDildoDepth + 0.12)
					{
						uncomfortable = true;
						maybeSetDildoPose("lo");
						dildoNiceDepthCombo = 0;
					}
					else if (toyInterface.animPct > targetDildoDepth + 0.06)
					{
						badDepth = true;
						maybeSetDildoPose("lo");
						dildoNiceDepthCombo = 0;
					}
					else if (toyInterface.animPct < targetDildoDepth - 0.06)
					{
						maybeSetDildoPose("hi");
						dildoNiceDepthCombo = 0;
					}
					else
					{
						var pleasureAmount:Float = SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * 0.015);
						drainToyDickHeartReservoir(pleasureAmount);
						amount += pleasureAmount;

						howGood++;
						maybeSetDildoPose("default");
						dildoNiceDepthCombo++;
					}
				}
				else
				{
					dildoNiceDepthCombo = 0;
					maybeSetDildoPose("default");
				}

				if (uncomfortable)
				{
					if (goodDildoCounter >= 4)
					{
						// meh, don't worry about it
					}
					else if (toyWindow.isPhoneEnabled() && FlxG.random.bool(75))
					{
						// when using the phone, we're not penalized very often
					}
					else
					{
						drainToyDickHeartReservoir(SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * 0.05));
						amount = SexyState.roundUpToQuarter(amount * 0.33);
					}
				}

				if (howGood == 2)
				{
					goodDildoCounter++;

					if (goodDildoCounter == 1)
					{
						// found the spot; sweat as a clue
						scheduleSweat(FlxG.random.int(3, 5));
					}

					if (goodDildoCounter >= 2)
					{
						maybeEmitWords(dildoNiceWords);

						if (!_male && _rubHandAnim._flxSprite.animation.name == "dildo-vag")
						{
							// plugging sandslash's vagina; she should ejaculate soon
							_heartBank._dickHeartReservoirCapacity += SexyState.roundUpToQuarter(_heartBank._defaultDickHeartReservoir * 0.02);
						}
					}

					if (goodDildoCounter >= 4 && maxGoodDildoCounter < 4)
					{
						if (ambientDildoBankFillCount <= 25)
						{
							bonusDildoOrgasmTimer = Std.int(FlxG.random.float(15, 25) / targetDildoDuration);
						}
						else
						{
							var penalty:Float = 0;
							var i:Int = 30;
							while (i < ambientDildoBankFillCount)
							{
								i += 3;
								_toyBank._dickHeartReservoir -= SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * 0.04);
							}
						}

						maybeEmitWords(pleasureWords);
						maybePlayPokeSfx();
						precum(FlxMath.bound(32 / FlxMath.bound(ambientDildoBankFillCount * 0.5 - 12, 1, 60), 1, 10)); // silly amount of precum
						addToyHeartsToOrgasm = true;
					}
				}
				else
				{
					goodDildoCounter = 0;
				}

				maxGoodDildoCounter = Std.int(Math.max(maxGoodDildoCounter, goodDildoCounter));

				if (bonusDildoOrgasmTimer > 0)
				{
					bonusDildoOrgasmTimer--;
					if (bonusDildoOrgasmTimer <= 6)
					{
						maybeEmitWords(almostWords);
					}
					if (bonusDildoOrgasmTimer - FlxG.random.int(0, 2) <= 0)
					{
						bonusDildoOrgasmTimer = -1;
						_remainingOrgasms++;
						if (!_male)
						{
							_remainingOrgasms++;
						}
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
	}

	private function maybeSetDildoPose(animName:String)
	{
		if (toyWindow.handL.animation.name == animName)
		{
			return;
		}
		if (dildoPoseTimer > 0)
		{
			return;
		}
		dildoPoseTimer = FlxG.random.float(3, 6);
		toyWindow.handL.animation.play(animName);
		toyWindow.legL.animation.play(animName);
		toyWindow.footL.animation.play(animName);
	}

	/**
	 * Drain the toy dick heart reservoir; Never drain it below 20% though, so
	 * that there's something left to reward the player with.
	 *
	 * Instead of draining the dick heart reservoir below 20%, we drain other
	 * reservoirs.
	 *
	 * @param	drainAmount The amount to decrease the various reservoirs
	 */
	private function drainToyDickHeartReservoir(drainAmount:Float)
	{
		var remainingDrainAmount:Float = drainAmount;
		if (remainingDrainAmount > 0)
		{
			if (_toyBank.getDickPercent() >= 0.2)
			{
				var amount:Float = _toyBank._dickHeartReservoir;
				amount = Math.min(amount, remainingDrainAmount);
				_toyBank._dickHeartReservoir -= amount;
				remainingDrainAmount -= amount;
			}
		}
		if (remainingDrainAmount > 0)
		{
			if (_heartBank.getForeplayPercent() >= 0.4)
			{
				var amount:Float = _heartBank._foreplayHeartReservoir;
				amount = Math.min(amount, remainingDrainAmount);
				_heartBank._foreplayHeartReservoir -= amount;
				remainingDrainAmount -= amount;
			}
		}
		if (remainingDrainAmount > 0)
		{
			if (_heartBank._dickHeartReservoir > 0)
			{
				var amount:Float = _heartBank._dickHeartReservoir;
				amount = Math.min(amount, remainingDrainAmount);
				_heartBank._dickHeartReservoir -= amount;
				remainingDrainAmount -= amount;
			}
		}
	}

	private function eventEmitHearts(args:Array<Dynamic>)
	{
		var heartsToEmit:Float = args[0];
		_heartEmitCount += heartsToEmit;

		if (_heartBank.getDickPercent() < 0.51)
		{
			maybeEmitWords(almostWords);
		}

		if (toyPrecumTimer < 0)
		{
			toyPrecumTimer = _rubRewardFrequency;
			maybeEmitPrecum();
			maybeScheduleBreath();
		}
		maybeEmitToyWordsAndStuff();
	}

	function fillAmbientDildoBank()
	{
		if (ambientDildoBank < ambientDildoBankCapacity)
		{
			ambientDildoBankFillCount++;
		}
		if (ambientDildoBank < ambientDildoBankCapacity)
		{
			if (_toyBank._foreplayHeartReservoir > 0)
			{
				var amount:Float = _toyBank._foreplayHeartReservoir;
				amount = Math.min(amount, ambientDildoBankCapacity - ambientDildoBank);
				_toyBank._foreplayHeartReservoir -= amount;
				ambientDildoBank += amount;

				if (_male)
				{
					// increase foreplay heart reservoir, so that males get erect
					_heartBank._foreplayHeartReservoirCapacity += amount;
				}
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

	override public function sexyStuff(elapsed:Float):Void
	{
		super.sexyStuff(elapsed);

		if (_pokeWindow._ass.animation.name == "aroused")
		{
			if (_armsAndLegsArranger._armsAndLegsTimer < 8 && _armsAndLegsArranger._armsAndLegsTimer + elapsed >= 8)
			{
				emitArousedHearts(0.15);
			}
			if (_armsAndLegsArranger._armsAndLegsTimer < 6 && _armsAndLegsArranger._armsAndLegsTimer + elapsed >= 6)
			{
				emitArousedHearts(0.20);
			}
			if (_armsAndLegsArranger._armsAndLegsTimer < 4 && _armsAndLegsArranger._armsAndLegsTimer + elapsed >= 4)
			{
				emitArousedHearts(0.25);
			}
			if (_armsAndLegsArranger._armsAndLegsTimer < 2 && _armsAndLegsArranger._armsAndLegsTimer + elapsed >= 2)
			{
				emitArousedHearts(0.30);
				if (_gameState == 200 && !isEjaculating())
				{
					if (_heartBank.getDickPercent() > _cumThreshold)
					{
						// still not ready to orgasm; emit hearts until we can orgasm
						for (i in 0...50)
						{
							var amount:Float = SexyState.roundUpToQuarter(0.1 * _heartBank._dickHeartReservoir);
							if (amount <= 0)
							{
								break;
							}
							_heartBank._dickHeartReservoir -= amount;
							_heartEmitCount += amount;
							if (_heartBank.getDickPercent() <= _cumThreshold)
							{
								break;
							}
						}
					}
					_newHeadTimer = Math.min(_newHeadTimer, 1.0);
				}
			}
			if (_pokeWindow._ass.animation.frameIndex != curArousedFrameIndex)
			{
				// new frame...
				var newArousedFrameIndexDir:Int = _pokeWindow._ass.animation.frameIndex - curArousedFrameIndex;
				curArousedFrameIndex = _pokeWindow._ass.animation.frameIndex;
				if (curArousedFrameIndexDir != newArousedFrameIndexDir)
				{
					curArousedFrameIndexDir = newArousedFrameIndexDir;
					if (curArousedFrameIndexDir == 1 || curArousedFrameIndexDir == -1)
					{
						FlxSoundKludge.play(FlxG.random.getObject([AssetPaths.rub0_mediuma__mp3, AssetPaths.rub0_mediumb__mp3, AssetPaths.rub0_mediumc__mp3]), 0.10);
					}
				}
			}
			if (_pokeWindow._arms0.animation.name != "aroused")
			{
				_pokeWindow._ass.animation.play("default");
				obliterateCursor();
			}
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
			setInactiveDickState();
		}

		if (_gameState == 200 && _autoSweatRate < kelv * 0.008)
		{
			_autoSweatRate += elapsed * 0.008 / 3;
		}
	}

	override function updateHand(elapsed:Float):Void
	{
		if (_pokeWindow._ass.animation.name == "aroused" || emergency)
		{
			// don't update the hand; they're stuck
			return;
		}
		super.updateHand(elapsed);
	}

	override function boredStuff():Void
	{
		super.boredStuff();
		kelvGoal = Std.int(Math.max(20, kelvGoal - 5));
		updateKelvWith( -5);
	}

	override public function determineArousal():Int
	{
		if (displayingToyWindow())
		{
			var arousal:Int = 0;
			if (maxGoodDildoCounter >= 4 || _heartBank.getDickPercent() < 0.77)
			{
				arousal = 3;
			}
			else if (_heartBank.getDickPercent() < 0.9)
			{
				arousal = 2;
			}
			else if (_heartBank.getForeplayPercent() < 0.9)
			{
				arousal = 1;
			}
			else
			{
				arousal = 0;
			}
			if (dildoNiceDepthCombo >= 2 || dildoNiceSpeedCombo >= 2)
			{
				arousal = Std.int(FlxMath.bound(arousal + 1, 0, 4));
			}
			return arousal;
		}
		else {
			if (_pokeWindow._ass.animation.name == "aroused")
			{
				// super horny
				return 4;
			}
			else if (kelv == 0)
			{
				return 0;
			}
			else if (kelv - kelvGoal <= -31)
			{
				return 0;
			}
			else if (kelv - kelvGoal <= -21)
			{
				return 1;
			}
			else if (kelv - kelvGoal <= -11)
			{
				return 2;
			}
			else if (kelv - kelvGoal <= 10)
			{
				return kelv < 50 ? 3 : 4;
			}
			else if (kelv - kelvGoal <= 20)
			{
				return 2;
			}
			else {
				return 1;
			}
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
			else if (_rubHandAnim._flxSprite.animation.name == "jack-off")
			{
				specialRub = "jack-off";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-dick")
			{
				specialRub = "rub-dick";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "suck-fingers")
			{
				specialRub = "suck-fingers";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-left-pec")
			{
				specialRub = "rub-left-pec";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-right-pec")
			{
				specialRub = "rub-right-pec";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-balls")
			{
				specialRub = "rub-balls";
			}
		}
		else
		{
			if (touchedPart == _pokeWindow._legs && (clickedPolygon(touchedPart, leftFootPolyArray) || clickedPolygon(touchedPart, rightFootPolyArray)))
			{
				specialRub = "foot";
			}
		}
	}

	override public function canChangeHead():Bool
	{
		return !fancyRubbing(_pokeWindow._mouth);
	}

	override function foreplayFactor():Float
	{
		return 0.6;
	}

	override public function touchPart(touchedPart:FlxSprite):Bool
	{
		if (FlxG.mouse.justPressed && touchedPart == _dick || (!_male && (touchedPart == _pokeWindow._torso0 || touchedPart == _pokeWindow._torso1) && clickedPolygon(touchedPart, vagPolyArray)))
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
		if (FlxG.mouse.justPressed && touchedPart == _pokeWindow._balls)
		{
			interactOn(_pokeWindow._balls, "rub-balls");
			_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.members.indexOf(_dick) + 1);
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
			_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.members.indexOf(_pokeWindow._legs) + 1);
			_rubBodyAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
			_rubHandAnim.setSpeed(0.65 * 2.5, 0.65 * 1.5);
			return true;
		}
		if (FlxG.mouse.justPressed && touchedPart == _head)
		{
			if (clickedPolygon(touchedPart, mouthPolyArray))
			{
				if (fingerSuckCount() >= 2 || !_male && niceThings[1] == false)
				{
					// sucked fingers too many times
					_newHeadTimer = 0;
				}
				else
				{
					interactOn(_pokeWindow._mouth, "suck-fingers");
					_pokeWindow._mouth.visible = true;
					_head.animation.play("2-suck-cm");
					_pokeWindow.updateQuills();
					return true;
				}
			}
		}
		if (FlxG.mouse.justPressed && touchedPart == _pokeWindow._torso1)
		{
			if (clickedPolygon(touchedPart, leftPecPolyArray))
			{
				interactOn(_pokeWindow._torso1, "rub-left-pec");
				if (_pokeWindow._arms0.animation.name == "closed1" || _pokeWindow._arms0.animation.name == "closed2")
				{
					_armsAndLegsArranger.arrangeNow();
				}
				_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.members.indexOf(_pokeWindow._arms1) + 1);
				return true;
			}
			if (clickedPolygon(touchedPart, rightPecPolyArray))
			{
				interactOn(_pokeWindow._torso1, "rub-right-pec");
				if (_pokeWindow._arms0.animation.name == "closed0" || _pokeWindow._arms0.animation.name == "closed2" || _pokeWindow._arms0.animation.name == "default")
				{
					_armsAndLegsArranger.arrangeNow();
				}
				_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.members.indexOf(_pokeWindow._arms1) + 1);
				return true;
			}
		}
		return false;
	}

	override public function untouchPart(touchedPart:FlxSprite):Void
	{
		super.untouchPart(touchedPart);
		if (touchedPart == _pokeWindow._mouth)
		{
			_pokeWindow._mouth.visible = false;
			if (_head.animation.name == "4-suck-cm")
			{
				_head.animation.play("4-cm");
			}
			else
			{
				_head.animation.play("2-cm");
			}
			_newHeadTimer = FlxG.random.float(0.1, 0.5);
		}
	}

	override function initializeHitBoxes():Void
	{
		if (displayingToyWindow())
		{
			if (_male)
			{
				dickAngleArray[0] = [new FlxPoint(190, 383), new FlxPoint(89, 244), new FlxPoint(-125, 228)];
				dickAngleArray[1] = [new FlxPoint(230, 383), new FlxPoint(213, 149), new FlxPoint(100, 240)];
				dickAngleArray[2] = [new FlxPoint(232, 381), new FlxPoint(219, 140), new FlxPoint(116, 233)];
				dickAngleArray[3] = [new FlxPoint(234, 379), new FlxPoint(219, 140), new FlxPoint(131, 225)];
				dickAngleArray[4] = [new FlxPoint(266, 333), new FlxPoint(236, -110), new FlxPoint(219, -141)];
				dickAngleArray[5] = [new FlxPoint(264, 329), new FlxPoint(229, -122), new FlxPoint(204, -161)];
				dickAngleArray[6] = [new FlxPoint(264, 325), new FlxPoint(214, -148), new FlxPoint(184, -184)];
			}
			else
			{
				dickAngleArray[0] = [new FlxPoint(141, 359), new FlxPoint(-66, 252), new FlxPoint(-241, 98)];
				dickAngleArray[1] = [new FlxPoint(146, 357), new FlxPoint(-75, 249), new FlxPoint(-257, 41)];
				dickAngleArray[2] = [new FlxPoint(143, 359), new FlxPoint(-116, 233), new FlxPoint(-259, 23)];
				dickAngleArray[3] = [new FlxPoint(143, 359), new FlxPoint(-76, 249), new FlxPoint(-248, -79)];
				dickAngleArray[4] = [new FlxPoint(143, 359), new FlxPoint(-33, 258), new FlxPoint(-243, -93)];
				dickAngleArray[5] = [new FlxPoint(143, 359), new FlxPoint(-7, 260), new FlxPoint(-221, -137)];
				dickAngleArray[6] = [new FlxPoint(143, 359), new FlxPoint(-102, 239), new FlxPoint(-259, -26)];
				dickAngleArray[7] = [new FlxPoint(143, 359), new FlxPoint(-61, 253), new FlxPoint(-258, -35)];
				dickAngleArray[8] = [new FlxPoint(143, 359), new FlxPoint(-9, 260), new FlxPoint(-256, -47)];
				dickAngleArray[9] = [new FlxPoint(143, 359), new FlxPoint(16, 260), new FlxPoint(-242, -94)];
				dickAngleArray[10] = [new FlxPoint(143, 359), new FlxPoint(34, 258), new FlxPoint(-246, -84)];
				dickAngleArray[12] = [new FlxPoint(141, 357), new FlxPoint(-35, 258), new FlxPoint(-237, -107)];
				dickAngleArray[13] = [new FlxPoint(141, 357), new FlxPoint(9, 260), new FlxPoint(-248, -77)];
				dickAngleArray[14] = [new FlxPoint(141, 357), new FlxPoint(54, 254), new FlxPoint(-246, -84)];
				dickAngleArray[15] = [new FlxPoint(141, 357), new FlxPoint(84, 246), new FlxPoint(-249, -74)];
				dickAngleArray[16] = [new FlxPoint(141, 357), new FlxPoint(102, 239), new FlxPoint(-243, -93)];
				dickAngleArray[17] = [new FlxPoint(141, 357), new FlxPoint(106, 237), new FlxPoint(-243, -93)];
				dickAngleArray[18] = [new FlxPoint(141, 357), new FlxPoint(115, 233), new FlxPoint(-241, -97)];
				dickAngleArray[19] = [new FlxPoint(141, 357), new FlxPoint(118, 232), new FlxPoint(-239, -102)];
				dickAngleArray[20] = [new FlxPoint(141, 357), new FlxPoint(121, 230), new FlxPoint(-246, -83)];
				dickAngleArray[21] = [new FlxPoint(141, 357), new FlxPoint(128, 226), new FlxPoint(-247, -80)];
				dickAngleArray[22] = [new FlxPoint(141, 357), new FlxPoint(132, 224), new FlxPoint(-247, -82)];
				dickAngleArray[24] = [new FlxPoint(142, 359), new FlxPoint(-112, 235), new FlxPoint(-260, 10)];
				dickAngleArray[25] = [new FlxPoint(146, 356), new FlxPoint(-111, 235), new FlxPoint(-260, 0)];
				dickAngleArray[26] = [new FlxPoint(151, 354), new FlxPoint(-99, 240), new FlxPoint(-255, -49)];
				dickAngleArray[27] = [new FlxPoint(155, 353), new FlxPoint( -78, 248), new FlxPoint( -257, 37)];
			}

			var torsoSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			torsoSweatArray[0] = [new FlxPoint(164, 300), new FlxPoint(174, 258), new FlxPoint(166, 232), new FlxPoint(186, 184), new FlxPoint(212, 222), new FlxPoint(234, 232), new FlxPoint(226, 280), new FlxPoint(226, 328), new FlxPoint(216, 350)];
			torsoSweatArray[1] = [new FlxPoint(164, 300), new FlxPoint(174, 258), new FlxPoint(166, 232), new FlxPoint(186, 184), new FlxPoint(212, 222), new FlxPoint(234, 232), new FlxPoint(226, 280), new FlxPoint(226, 328), new FlxPoint(216, 350)];
			torsoSweatArray[2] = [new FlxPoint(164, 300), new FlxPoint(174, 258), new FlxPoint(166, 232), new FlxPoint(186, 184), new FlxPoint(212, 222), new FlxPoint(234, 232), new FlxPoint(226, 280), new FlxPoint(226, 328), new FlxPoint(216, 350)];
			torsoSweatArray[3] = [new FlxPoint(164, 300), new FlxPoint(174, 258), new FlxPoint(166, 232), new FlxPoint(186, 184), new FlxPoint(212, 222), new FlxPoint(234, 232), new FlxPoint(226, 280), new FlxPoint(226, 328), new FlxPoint(216, 350)];

			var headSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			headSweatArray[0] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[1] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[2] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[3] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[4] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[5] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[6] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[7] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[8] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[9] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[10] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[11] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[12] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[13] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[14] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[15] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[16] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];
			headSweatArray[17] = [new FlxPoint(236, 184), new FlxPoint(246, 156), new FlxPoint(220, 115), new FlxPoint(268, 110), new FlxPoint(308, 120), new FlxPoint(310, 193), new FlxPoint(274, 179), new FlxPoint(252, 195)];

			sweatAreas.splice(0, sweatAreas.length);
			sweatAreas.push({chance:5, sprite:toyWindow._head, sweatArrayArray:headSweatArray});
			sweatAreas.push({chance:5, sprite:toyWindow.torso, sweatArrayArray:torsoSweatArray});
		}
		else {
			vagPolyArray = new Array<Array<FlxPoint>>();
			vagPolyArray[0] = [new FlxPoint(199, 367), new FlxPoint(167, 365), new FlxPoint(160, 318), new FlxPoint(205, 321)];

			mouthPolyArray = new Array<Array<FlxPoint>>();
			mouthPolyArray[0] = [new FlxPoint(155, 197), new FlxPoint(168, 166), new FlxPoint(205, 165), new FlxPoint(218, 202), new FlxPoint(184, 210)];
			mouthPolyArray[1] = [new FlxPoint(155, 197), new FlxPoint(168, 166), new FlxPoint(205, 165), new FlxPoint(218, 202), new FlxPoint(184, 210)];
			mouthPolyArray[2] = [new FlxPoint(155, 197), new FlxPoint(168, 166), new FlxPoint(205, 165), new FlxPoint(218, 202), new FlxPoint(184, 210)];
			mouthPolyArray[3] = [new FlxPoint(174, 162), new FlxPoint(208, 163), new FlxPoint(225, 198), new FlxPoint(189, 220), new FlxPoint(151, 197)];
			mouthPolyArray[4] = [new FlxPoint(174, 162), new FlxPoint(208, 163), new FlxPoint(225, 198), new FlxPoint(189, 220), new FlxPoint(151, 197)];
			mouthPolyArray[5] = [new FlxPoint(174, 162), new FlxPoint(208, 163), new FlxPoint(225, 198), new FlxPoint(189, 220), new FlxPoint(151, 197)];
			mouthPolyArray[6] = [new FlxPoint(171, 163), new FlxPoint(200, 159), new FlxPoint(229, 196), new FlxPoint(193, 212), new FlxPoint(153, 200)];
			mouthPolyArray[7] = [new FlxPoint(171, 163), new FlxPoint(200, 159), new FlxPoint(229, 196), new FlxPoint(193, 212), new FlxPoint(153, 200)];
			mouthPolyArray[8] = [new FlxPoint(171, 163), new FlxPoint(200, 159), new FlxPoint(229, 196), new FlxPoint(193, 212), new FlxPoint(153, 200)];
			mouthPolyArray[12] = [new FlxPoint(163, 160), new FlxPoint(194, 170), new FlxPoint(197, 211), new FlxPoint(160, 211), new FlxPoint(132, 189)];
			mouthPolyArray[13] = [new FlxPoint(163, 160), new FlxPoint(194, 170), new FlxPoint(197, 211), new FlxPoint(160, 211), new FlxPoint(132, 189)];
			mouthPolyArray[14] = [new FlxPoint(163, 160), new FlxPoint(194, 170), new FlxPoint(197, 211), new FlxPoint(160, 211), new FlxPoint(132, 189)];
			mouthPolyArray[15] = [new FlxPoint(201, 179), new FlxPoint(233, 178), new FlxPoint(240, 203), new FlxPoint(209, 226), new FlxPoint(176, 211)];
			mouthPolyArray[16] = [new FlxPoint(201, 179), new FlxPoint(233, 178), new FlxPoint(240, 203), new FlxPoint(209, 226), new FlxPoint(176, 211)];
			mouthPolyArray[17] = [new FlxPoint(201, 179), new FlxPoint(233, 178), new FlxPoint(240, 203), new FlxPoint(209, 226), new FlxPoint(176, 211)];
			mouthPolyArray[24] = [new FlxPoint(133, 181), new FlxPoint(162, 178), new FlxPoint(191, 213), new FlxPoint(153, 227), new FlxPoint(117, 206)];
			mouthPolyArray[25] = [new FlxPoint(133, 181), new FlxPoint(162, 178), new FlxPoint(191, 213), new FlxPoint(153, 227), new FlxPoint(117, 206)];
			mouthPolyArray[26] = [new FlxPoint(133, 181), new FlxPoint(162, 178), new FlxPoint(191, 213), new FlxPoint(153, 227), new FlxPoint(117, 206)];
			mouthPolyArray[27] = [new FlxPoint(160, 160), new FlxPoint(193, 171), new FlxPoint(196, 213), new FlxPoint(156, 216), new FlxPoint(133, 191)];
			mouthPolyArray[28] = [new FlxPoint(160, 160), new FlxPoint(193, 171), new FlxPoint(196, 213), new FlxPoint(156, 216), new FlxPoint(133, 191)];
			mouthPolyArray[29] = [new FlxPoint(160, 160), new FlxPoint(193, 171), new FlxPoint(196, 213), new FlxPoint(156, 216), new FlxPoint(133, 191)];
			mouthPolyArray[30] = [new FlxPoint(130, 133), new FlxPoint(162, 136), new FlxPoint(166, 192), new FlxPoint(124, 191), new FlxPoint(105, 159)];
			mouthPolyArray[31] = [new FlxPoint(130, 133), new FlxPoint(162, 136), new FlxPoint(166, 192), new FlxPoint(124, 191), new FlxPoint(105, 159)];
			mouthPolyArray[32] = [new FlxPoint(130, 133), new FlxPoint(162, 136), new FlxPoint(166, 192), new FlxPoint(124, 191), new FlxPoint(105, 159)];
			mouthPolyArray[36] = [new FlxPoint(131, 131), new FlxPoint(162, 135), new FlxPoint(169, 198), new FlxPoint(125, 196), new FlxPoint(106, 159)];
			mouthPolyArray[37] = [new FlxPoint(131, 131), new FlxPoint(162, 135), new FlxPoint(169, 198), new FlxPoint(125, 196), new FlxPoint(106, 159)];
			mouthPolyArray[38] = [new FlxPoint(131, 131), new FlxPoint(162, 135), new FlxPoint(169, 198), new FlxPoint(125, 196), new FlxPoint(106, 159)];
			mouthPolyArray[39] = [new FlxPoint(164, 160), new FlxPoint(196, 160), new FlxPoint(213, 199), new FlxPoint(176, 212), new FlxPoint(133, 190)];
			mouthPolyArray[40] = [new FlxPoint(164, 160), new FlxPoint(196, 160), new FlxPoint(213, 199), new FlxPoint(176, 212), new FlxPoint(133, 190)];
			mouthPolyArray[41] = [new FlxPoint(164, 160), new FlxPoint(196, 160), new FlxPoint(213, 199), new FlxPoint(176, 212), new FlxPoint(133, 190)];
			mouthPolyArray[42] = [new FlxPoint(184, 109), new FlxPoint(215, 110), new FlxPoint(237, 127), new FlxPoint(226, 166), new FlxPoint(186, 167), new FlxPoint(165, 128)];
			mouthPolyArray[43] = [new FlxPoint(184, 109), new FlxPoint(215, 110), new FlxPoint(237, 127), new FlxPoint(226, 166), new FlxPoint(186, 167), new FlxPoint(165, 128)];
			mouthPolyArray[44] = [new FlxPoint(184, 109), new FlxPoint(215, 110), new FlxPoint(237, 127), new FlxPoint(226, 166), new FlxPoint(186, 167), new FlxPoint(165, 128)];
			mouthPolyArray[45] = [new FlxPoint(164, 160), new FlxPoint(194, 162), new FlxPoint(207, 202), new FlxPoint(171, 216), new FlxPoint(138, 192)];
			mouthPolyArray[46] = [new FlxPoint(164, 160), new FlxPoint(194, 162), new FlxPoint(207, 202), new FlxPoint(171, 216), new FlxPoint(138, 192)];
			mouthPolyArray[47] = [new FlxPoint(164, 160), new FlxPoint(194, 162), new FlxPoint(207, 202), new FlxPoint(171, 216), new FlxPoint(138, 192)];
			mouthPolyArray[48] = [new FlxPoint(168, 161), new FlxPoint(200, 157), new FlxPoint(221, 190), new FlxPoint(188, 213), new FlxPoint(149, 194)];
			mouthPolyArray[49] = [new FlxPoint(168, 161), new FlxPoint(200, 157), new FlxPoint(221, 190), new FlxPoint(188, 213), new FlxPoint(149, 194)];
			mouthPolyArray[50] = [new FlxPoint(168, 161), new FlxPoint(200, 157), new FlxPoint(221, 190), new FlxPoint(188, 213), new FlxPoint(149, 194)];
			mouthPolyArray[51] = [new FlxPoint(160, 158), new FlxPoint(195, 171), new FlxPoint(207, 208), new FlxPoint(156, 222), new FlxPoint(129, 179)];
			mouthPolyArray[52] = [new FlxPoint(160, 158), new FlxPoint(195, 171), new FlxPoint(207, 208), new FlxPoint(156, 222), new FlxPoint(129, 179)];
			mouthPolyArray[53] = [new FlxPoint(160, 158), new FlxPoint(195, 171), new FlxPoint(207, 208), new FlxPoint(156, 222), new FlxPoint(129, 179)];
			mouthPolyArray[54] = [new FlxPoint(207, 144), new FlxPoint(249, 136), new FlxPoint(265, 153), new FlxPoint(238, 205), new FlxPoint(190, 176)];
			mouthPolyArray[55] = [new FlxPoint(207, 144), new FlxPoint(249, 136), new FlxPoint(265, 153), new FlxPoint(238, 205), new FlxPoint(190, 176)];
			mouthPolyArray[56] = [new FlxPoint(207, 144), new FlxPoint(249, 136), new FlxPoint(265, 153), new FlxPoint(238, 205), new FlxPoint(190, 176)];
			mouthPolyArray[60] = [new FlxPoint(152, 115), new FlxPoint(196, 114), new FlxPoint(223, 142), new FlxPoint(204, 156), new FlxPoint(141, 160), new FlxPoint(129, 138)];
			mouthPolyArray[61] = [new FlxPoint(152, 115), new FlxPoint(196, 114), new FlxPoint(223, 142), new FlxPoint(204, 156), new FlxPoint(141, 160), new FlxPoint(129, 138)];
			mouthPolyArray[63] = [new FlxPoint(164, 161), new FlxPoint(195, 165), new FlxPoint(220, 194), new FlxPoint(172, 219), new FlxPoint(136, 188)];
			mouthPolyArray[64] = [new FlxPoint(164, 161), new FlxPoint(195, 165), new FlxPoint(220, 194), new FlxPoint(172, 219), new FlxPoint(136, 188)];
			mouthPolyArray[66] = [new FlxPoint(208, 144), new FlxPoint(250, 134), new FlxPoint(285, 168), new FlxPoint(234, 205), new FlxPoint(172, 198)];
			mouthPolyArray[67] = [new FlxPoint(208, 144), new FlxPoint(250, 134), new FlxPoint(285, 168), new FlxPoint(234, 205), new FlxPoint(172, 198)];
			mouthPolyArray[69] = [new FlxPoint(165, 167), new FlxPoint(197, 169), new FlxPoint(219, 205), new FlxPoint(170, 217), new FlxPoint(138, 192)];
			mouthPolyArray[70] = [new FlxPoint(165, 167), new FlxPoint(197, 169), new FlxPoint(219, 205), new FlxPoint(170, 217), new FlxPoint(138, 192)];
			mouthPolyArray[72] = [new FlxPoint(152, 175), new FlxPoint(222, 151), new FlxPoint(251, 189), new FlxPoint(212, 219), new FlxPoint(149, 208)];
			mouthPolyArray[73] = [new FlxPoint(152, 175), new FlxPoint(222, 151), new FlxPoint(251, 189), new FlxPoint(212, 219), new FlxPoint(149, 208)];
			mouthPolyArray[75] = [new FlxPoint(182, 182), new FlxPoint(247, 183), new FlxPoint(239, 236), new FlxPoint(197, 239), new FlxPoint(160, 214)];
			mouthPolyArray[76] = [new FlxPoint(182, 182), new FlxPoint(247, 183), new FlxPoint(239, 236), new FlxPoint(197, 239), new FlxPoint(160, 214)];
			mouthPolyArray[78] = [new FlxPoint(167, 115), new FlxPoint(235, 117), new FlxPoint(254, 139), new FlxPoint(239, 165), new FlxPoint(183, 168), new FlxPoint(152, 135)];
			mouthPolyArray[79] = [new FlxPoint(167, 115), new FlxPoint(235, 117), new FlxPoint(254, 139), new FlxPoint(239, 165), new FlxPoint(183, 168), new FlxPoint(152, 135)];

			assPolyArray = new Array<Array<FlxPoint>>();
			assPolyArray[0] = [new FlxPoint(172, 395), new FlxPoint(156, 374), new FlxPoint(171, 351), new FlxPoint(205, 353), new FlxPoint(220, 381), new FlxPoint(205, 399)];

			leftPecPolyArray = new Array<Array<FlxPoint>>();
			leftPecPolyArray[0] = [new FlxPoint(188, 220), new FlxPoint(126, 213), new FlxPoint(96, 278), new FlxPoint(185, 278)];

			rightPecPolyArray = new Array<Array<FlxPoint>>();
			rightPecPolyArray[0] = [new FlxPoint(186, 275), new FlxPoint(189, 222), new FlxPoint(251, 222), new FlxPoint(280, 276)];

			leftFootPolyArray = new Array<Array<FlxPoint>>();
			leftFootPolyArray[0] = [new FlxPoint(-56, 488), new FlxPoint(50, 403), new FlxPoint(107, 384), new FlxPoint(138, 406), new FlxPoint(142, 487)];
			leftFootPolyArray[3] = [new FlxPoint(-56, 488), new FlxPoint(54, 409), new FlxPoint(104, 403), new FlxPoint(148, 413), new FlxPoint(146, 487)];
			leftFootPolyArray[4] = [new FlxPoint(-56, 488), new FlxPoint(76, 420), new FlxPoint(157, 396), new FlxPoint(160, 417), new FlxPoint(159, 487)];
			leftFootPolyArray[5] = [new FlxPoint(-56, 488), new FlxPoint(60, 407), new FlxPoint(143, 401), new FlxPoint(140, 486)];
			leftFootPolyArray[6] = [new FlxPoint(-56, 488), new FlxPoint(55, 401), new FlxPoint(98, 385), new FlxPoint(139, 401), new FlxPoint(142, 487)];
			leftFootPolyArray[7] = [new FlxPoint(-56, 488), new FlxPoint(52, 390), new FlxPoint(100, 378), new FlxPoint(142, 390), new FlxPoint(141, 486)];
			leftFootPolyArray[8] = [new FlxPoint(-56, 488), new FlxPoint(52, 390), new FlxPoint(100, 378), new FlxPoint(142, 390), new FlxPoint(143, 487)];
			leftFootPolyArray[9] = [new FlxPoint(-56, 488), new FlxPoint(55, 382), new FlxPoint(87, 409), new FlxPoint(79, 448)];
			leftFootPolyArray[10] = [new FlxPoint(-56, 488), new FlxPoint(53, 413), new FlxPoint(85, 434), new FlxPoint(82, 486)];

			rightFootPolyArray = new Array<Array<FlxPoint>>();
			rightFootPolyArray[0] = [new FlxPoint(358, 486), new FlxPoint(307, 383), new FlxPoint(254, 378), new FlxPoint(229, 398), new FlxPoint(226, 486)];
			rightFootPolyArray[3] = [new FlxPoint(358, 486), new FlxPoint(302, 395), new FlxPoint(269, 391), new FlxPoint(226, 396), new FlxPoint(228, 484)];
			rightFootPolyArray[4] = [new FlxPoint(358, 486), new FlxPoint(300, 405), new FlxPoint(224, 394), new FlxPoint(219, 484)];
			rightFootPolyArray[5] = [new FlxPoint(358, 486), new FlxPoint(289, 421), new FlxPoint(218, 389), new FlxPoint(191, 417), new FlxPoint(204, 485)];
			rightFootPolyArray[6] = [new FlxPoint(358, 486), new FlxPoint(307, 381), new FlxPoint(248, 380), new FlxPoint(227, 396), new FlxPoint(225, 488)];
			rightFootPolyArray[7] = [new FlxPoint(358, 486), new FlxPoint(307, 381), new FlxPoint(256, 379), new FlxPoint(224, 390), new FlxPoint(216, 485)];
			rightFootPolyArray[8] = [new FlxPoint(358, 486), new FlxPoint(307, 392), new FlxPoint(253, 383), new FlxPoint(219, 399), new FlxPoint(217, 486)];
			rightFootPolyArray[11] = [new FlxPoint(358, 486), new FlxPoint(310, 382), new FlxPoint(289, 408), new FlxPoint(290, 436), new FlxPoint(291, 487)];

			if (_male)
			{
				dickAngleArray[0] = [new FlxPoint(156, 336), new FlxPoint(142, 218), new FlxPoint(-166, 200)];
				dickAngleArray[1] = [new FlxPoint(122, 294), new FlxPoint(-243, 91), new FlxPoint(-243, -91)];
				dickAngleArray[2] = [new FlxPoint(126, 298), new FlxPoint(-208, 156), new FlxPoint(-255, -51)];
				dickAngleArray[3] = [new FlxPoint(126, 300), new FlxPoint(-236, 110), new FlxPoint(-247, -82)];
				dickAngleArray[4] = [new FlxPoint(147, 241), new FlxPoint(0, -260), new FlxPoint(-78, -248)];
				dickAngleArray[5] = [new FlxPoint(143, 243), new FlxPoint(0, -260), new FlxPoint(-79, -248)];
				dickAngleArray[6] = [new FlxPoint(138, 248), new FlxPoint(-32, -258), new FlxPoint(-132, -224)];
				dickAngleArray[7] = [new FlxPoint(136, 251), new FlxPoint(-39, -257), new FlxPoint(-141, -218)];
				dickAngleArray[8] = [new FlxPoint(123, 278), new FlxPoint(-123, -229), new FlxPoint(-190, 177)];
				dickAngleArray[9] = [new FlxPoint(121, 286), new FlxPoint(-178, 190), new FlxPoint(-162, -203)];
				dickAngleArray[10] = [new FlxPoint(120, 292), new FlxPoint(-256, -45), new FlxPoint(-106, -238)];
				dickAngleArray[11] = [new FlxPoint(120, 293), new FlxPoint(-253, -60), new FlxPoint(-224, -132)];
				dickAngleArray[12] = [new FlxPoint(153, 241), new FlxPoint(233, -116), new FlxPoint(-37, -257)];
				dickAngleArray[13] = [new FlxPoint(147, 242), new FlxPoint(227, -127), new FlxPoint(-141, -219)];
				dickAngleArray[14] = [new FlxPoint(142, 243), new FlxPoint(0, -260), new FlxPoint(-87, -245)];
				dickAngleArray[15] = [new FlxPoint(138, 248), new FlxPoint( -14, -260), new FlxPoint( -104, -238)];
			}
			else {
				dickAngleArray[0] = [new FlxPoint(178, 347), new FlxPoint(125, 228), new FlxPoint(-128, 226)];
				dickAngleArray[1] = [new FlxPoint(178, 344), new FlxPoint(142, 218), new FlxPoint(-149, 213)];
				dickAngleArray[2] = [new FlxPoint(178, 344), new FlxPoint(158, 207), new FlxPoint(-170, 197)];
				dickAngleArray[3] = [new FlxPoint(178, 344), new FlxPoint(192, 175), new FlxPoint(-196, 171)];
				dickAngleArray[4] = [new FlxPoint(178, 344), new FlxPoint(202, 164), new FlxPoint(-212, 150)];
				dickAngleArray[5] = [new FlxPoint(178, 344), new FlxPoint(79, 248), new FlxPoint(-237, 106)];
				dickAngleArray[6] = [new FlxPoint(178, 344), new FlxPoint(165, 201), new FlxPoint(-174, 193)];
				dickAngleArray[7] = [new FlxPoint(178, 344), new FlxPoint(212, 150), new FlxPoint(-220, 139)];
				dickAngleArray[8] = [new FlxPoint(178, 344), new FlxPoint(224, 133), new FlxPoint(-228, 125)];
				dickAngleArray[9] = [new FlxPoint(178, 344), new FlxPoint(225, 131), new FlxPoint(-229, 124)];
				dickAngleArray[10] = [new FlxPoint(178, 344), new FlxPoint(235, 112), new FlxPoint(-243, 91)];
				dickAngleArray[11] = [new FlxPoint(178, 344), new FlxPoint(247, 81), new FlxPoint(-247, 82)];
				dickAngleArray[12] = [new FlxPoint(178, 347), new FlxPoint(150, 212), new FlxPoint(-127, 227)];
				dickAngleArray[13] = [new FlxPoint(178, 347), new FlxPoint(150, 212), new FlxPoint(-127, 227)];
			}

			breathAngleArray[0] = [new FlxPoint(183, 193), new FlxPoint(3, 80)];
			breathAngleArray[1] = [new FlxPoint(183, 193), new FlxPoint(3, 80)];
			breathAngleArray[2] = [new FlxPoint(183, 193), new FlxPoint(3, 80)];
			breathAngleArray[3] = [new FlxPoint(188, 197), new FlxPoint(10, 79)];
			breathAngleArray[4] = [new FlxPoint(188, 197), new FlxPoint(10, 79)];
			breathAngleArray[5] = [new FlxPoint(188, 197), new FlxPoint(10, 79)];
			breathAngleArray[12] = [new FlxPoint(160, 197), new FlxPoint(-25, 76)];
			breathAngleArray[13] = [new FlxPoint(160, 197), new FlxPoint(-25, 76)];
			breathAngleArray[14] = [new FlxPoint(160, 197), new FlxPoint(-25, 76)];
			breathAngleArray[15] = [new FlxPoint(219, 207), new FlxPoint(63, 49)];
			breathAngleArray[16] = [new FlxPoint(219, 207), new FlxPoint(63, 49)];
			breathAngleArray[17] = [new FlxPoint(219, 207), new FlxPoint(63, 49)];
			breathAngleArray[24] = [new FlxPoint(139, 218), new FlxPoint(-48, 64)];
			breathAngleArray[25] = [new FlxPoint(139, 218), new FlxPoint(-48, 64)];
			breathAngleArray[26] = [new FlxPoint(139, 218), new FlxPoint(-48, 64)];
			breathAngleArray[27] = [new FlxPoint(158, 209), new FlxPoint(-25, 76)];
			breathAngleArray[28] = [new FlxPoint(158, 209), new FlxPoint(-25, 76)];
			breathAngleArray[29] = [new FlxPoint(158, 209), new FlxPoint(-25, 76)];
			breathAngleArray[30] = [new FlxPoint(105, 155), new FlxPoint(-78, -19)];
			breathAngleArray[31] = [new FlxPoint(105, 155), new FlxPoint(-78, -19)];
			breathAngleArray[32] = [new FlxPoint(105, 155), new FlxPoint(-78, -19)];
			breathAngleArray[36] = [new FlxPoint(105, 155), new FlxPoint(-78, -19)];
			breathAngleArray[37] = [new FlxPoint(105, 155), new FlxPoint(-78, -19)];
			breathAngleArray[38] = [new FlxPoint(105, 155), new FlxPoint(-78, -19)];
			breathAngleArray[39] = [new FlxPoint(173, 203), new FlxPoint(0, 80)];
			breathAngleArray[40] = [new FlxPoint(173, 203), new FlxPoint(0, 80)];
			breathAngleArray[41] = [new FlxPoint(173, 203), new FlxPoint(0, 80)];
			breathAngleArray[42] = [new FlxPoint(244, 105), new FlxPoint(66, -46)];
			breathAngleArray[42] = [new FlxPoint(222, 116), new FlxPoint(63, -50)];
			breathAngleArray[43] = [new FlxPoint(222, 116), new FlxPoint(63, -50)];
			breathAngleArray[44] = [new FlxPoint(222, 116), new FlxPoint(63, -50)];
			breathAngleArray[48] = [new FlxPoint(187, 206), new FlxPoint(12, 79)];
			breathAngleArray[49] = [new FlxPoint(187, 206), new FlxPoint(12, 79)];
			breathAngleArray[50] = [new FlxPoint(187, 206), new FlxPoint(12, 79)];
			breathAngleArray[51] = [new FlxPoint(157, 202), new FlxPoint(-26, 76)];
			breathAngleArray[52] = [new FlxPoint(157, 202), new FlxPoint(-26, 76)];
			breathAngleArray[53] = [new FlxPoint(157, 202), new FlxPoint(-26, 76)];
			breathAngleArray[54] = [new FlxPoint(258, 151), new FlxPoint(74, -31)];
			breathAngleArray[55] = [new FlxPoint(258, 151), new FlxPoint(74, -31)];
			breathAngleArray[56] = [new FlxPoint(258, 151), new FlxPoint(74, -31)];
			breathAngleArray[60] = [new FlxPoint(132, 111), new FlxPoint(-54, -59)]; // gritted teeth
			breathAngleArray[61] = [new FlxPoint(132, 111), new FlxPoint(-54, -59)]; // gritted teeth
			breathAngleArray[63] = [new FlxPoint(164, 210), new FlxPoint(-19, 78)]; // gritted teeth
			breathAngleArray[64] = [new FlxPoint(164, 210), new FlxPoint(-19, 78)]; // gritted teeth
			breathAngleArray[66] = [new FlxPoint(260, 152), new FlxPoint(76, -24)]; // gritted teeth
			breathAngleArray[67] = [new FlxPoint(260, 152), new FlxPoint(76, -24)]; // gritted teeth
			breathAngleArray[72] = [new FlxPoint(206, 206), new FlxPoint(48, 64)];
			breathAngleArray[73] = [new FlxPoint(206, 206), new FlxPoint(48, 64)];
			breathAngleArray[75] = [new FlxPoint(231, 220), new FlxPoint(65, 46)];
			breathAngleArray[76] = [new FlxPoint(231, 220), new FlxPoint(65, 46)];
			breathAngleArray[78] = [new FlxPoint(217, 125), new FlxPoint(47, -65)];
			breathAngleArray[79] = [new FlxPoint(217, 125), new FlxPoint(47, -65)];

			var torsoSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			torsoSweatArray[0] = [new FlxPoint(153, 210), new FlxPoint(135, 226), new FlxPoint(135, 250), new FlxPoint(106, 310), new FlxPoint(173, 290), new FlxPoint(258, 301), new FlxPoint(241, 239), new FlxPoint(231, 216), new FlxPoint(215, 203)];

			var headSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			headSweatArray[0] = [new FlxPoint(118, 131), new FlxPoint(145, 90), new FlxPoint(202, 87), new FlxPoint(242, 118), new FlxPoint(193, 128), new FlxPoint(197, 153), new FlxPoint(170, 155), new FlxPoint(164, 130)];
			headSweatArray[1] = [new FlxPoint(118, 131), new FlxPoint(145, 90), new FlxPoint(202, 87), new FlxPoint(242, 118), new FlxPoint(193, 128), new FlxPoint(197, 153), new FlxPoint(170, 155), new FlxPoint(164, 130)];
			headSweatArray[2] = [new FlxPoint(118, 131), new FlxPoint(145, 90), new FlxPoint(202, 87), new FlxPoint(242, 118), new FlxPoint(193, 128), new FlxPoint(197, 153), new FlxPoint(170, 155), new FlxPoint(164, 130)];
			headSweatArray[3] = [new FlxPoint(133, 129), new FlxPoint(170, 91), new FlxPoint(231, 95), new FlxPoint(244, 130), new FlxPoint(211, 135), new FlxPoint(205, 157), new FlxPoint(175, 161), new FlxPoint(173, 138)];
			headSweatArray[4] = [new FlxPoint(133, 129), new FlxPoint(170, 91), new FlxPoint(231, 95), new FlxPoint(244, 130), new FlxPoint(211, 135), new FlxPoint(205, 157), new FlxPoint(175, 161), new FlxPoint(173, 138)];
			headSweatArray[5] = [new FlxPoint(133, 129), new FlxPoint(170, 91), new FlxPoint(231, 95), new FlxPoint(244, 130), new FlxPoint(211, 135), new FlxPoint(205, 157), new FlxPoint(175, 161), new FlxPoint(173, 138)];
			headSweatArray[6] = [new FlxPoint(123, 129), new FlxPoint(145, 93), new FlxPoint(203, 86), new FlxPoint(237, 117), new FlxPoint(197, 127), new FlxPoint(193, 154), new FlxPoint(172, 153), new FlxPoint(165, 128)];
			headSweatArray[7] = [new FlxPoint(123, 129), new FlxPoint(145, 93), new FlxPoint(203, 86), new FlxPoint(237, 117), new FlxPoint(197, 127), new FlxPoint(193, 154), new FlxPoint(172, 153), new FlxPoint(165, 128)];
			headSweatArray[8] = [new FlxPoint(123, 129), new FlxPoint(145, 93), new FlxPoint(203, 86), new FlxPoint(237, 117), new FlxPoint(197, 127), new FlxPoint(193, 154), new FlxPoint(172, 153), new FlxPoint(165, 128)];
			headSweatArray[12] = [new FlxPoint(135, 115), new FlxPoint(161, 90), new FlxPoint(234, 111), new FlxPoint(244, 154), new FlxPoint(208, 147), new FlxPoint(195, 170), new FlxPoint(159, 161), new FlxPoint(163, 134)];
			headSweatArray[13] = [new FlxPoint(135, 115), new FlxPoint(161, 90), new FlxPoint(234, 111), new FlxPoint(244, 154), new FlxPoint(208, 147), new FlxPoint(195, 170), new FlxPoint(159, 161), new FlxPoint(163, 134)];
			headSweatArray[14] = [new FlxPoint(135, 115), new FlxPoint(161, 90), new FlxPoint(234, 111), new FlxPoint(244, 154), new FlxPoint(208, 147), new FlxPoint(195, 170), new FlxPoint(159, 161), new FlxPoint(163, 134)];
			headSweatArray[15] = [new FlxPoint(150, 143), new FlxPoint(145, 99), new FlxPoint(228, 104), new FlxPoint(247, 145), new FlxPoint(234, 145), new FlxPoint(229, 174), new FlxPoint(202, 177), new FlxPoint(199, 144)];
			headSweatArray[16] = [new FlxPoint(150, 143), new FlxPoint(145, 99), new FlxPoint(228, 104), new FlxPoint(247, 145), new FlxPoint(234, 145), new FlxPoint(229, 174), new FlxPoint(202, 177), new FlxPoint(199, 144)];
			headSweatArray[17] = [new FlxPoint(150, 143), new FlxPoint(145, 99), new FlxPoint(228, 104), new FlxPoint(247, 145), new FlxPoint(234, 145), new FlxPoint(229, 174), new FlxPoint(202, 177), new FlxPoint(199, 144)];
			headSweatArray[24] = [new FlxPoint(118, 143), new FlxPoint(139, 104), new FlxPoint(205, 101), new FlxPoint(216, 138), new FlxPoint(169, 147), new FlxPoint(163, 174), new FlxPoint(134, 176), new FlxPoint(133, 147)];
			headSweatArray[25] = [new FlxPoint(118, 143), new FlxPoint(139, 104), new FlxPoint(205, 101), new FlxPoint(216, 138), new FlxPoint(169, 147), new FlxPoint(163, 174), new FlxPoint(134, 176), new FlxPoint(133, 147)];
			headSweatArray[26] = [new FlxPoint(118, 143), new FlxPoint(139, 104), new FlxPoint(205, 101), new FlxPoint(216, 138), new FlxPoint(169, 147), new FlxPoint(163, 174), new FlxPoint(134, 176), new FlxPoint(133, 147)];
			headSweatArray[27] = [new FlxPoint(140, 117), new FlxPoint(179, 89), new FlxPoint(232, 114), new FlxPoint(242, 150), new FlxPoint(207, 141), new FlxPoint(193, 164), new FlxPoint(165, 152), new FlxPoint(166, 128)];
			headSweatArray[28] = [new FlxPoint(140, 117), new FlxPoint(179, 89), new FlxPoint(232, 114), new FlxPoint(242, 150), new FlxPoint(207, 141), new FlxPoint(193, 164), new FlxPoint(165, 152), new FlxPoint(166, 128)];
			headSweatArray[29] = [new FlxPoint(140, 117), new FlxPoint(179, 89), new FlxPoint(232, 114), new FlxPoint(242, 150), new FlxPoint(207, 141), new FlxPoint(193, 164), new FlxPoint(165, 152), new FlxPoint(166, 128)];
			headSweatArray[30] = [new FlxPoint(128, 103), new FlxPoint(166, 84), new FlxPoint(211, 94), new FlxPoint(212, 120), new FlxPoint(178, 117), new FlxPoint(164, 135), new FlxPoint(131, 128), new FlxPoint(134, 113)];
			headSweatArray[31] = [new FlxPoint(128, 103), new FlxPoint(166, 84), new FlxPoint(211, 94), new FlxPoint(212, 120), new FlxPoint(178, 117), new FlxPoint(164, 135), new FlxPoint(131, 128), new FlxPoint(134, 113)];
			headSweatArray[32] = [new FlxPoint(128, 103), new FlxPoint(166, 84), new FlxPoint(211, 94), new FlxPoint(212, 120), new FlxPoint(178, 117), new FlxPoint(164, 135), new FlxPoint(131, 128), new FlxPoint(134, 113)];
			headSweatArray[36] = [new FlxPoint(128, 103), new FlxPoint(166, 84), new FlxPoint(211, 94), new FlxPoint(212, 120), new FlxPoint(178, 117), new FlxPoint(164, 135), new FlxPoint(131, 128), new FlxPoint(134, 113)];
			headSweatArray[37] = [new FlxPoint(128, 103), new FlxPoint(166, 84), new FlxPoint(211, 94), new FlxPoint(212, 120), new FlxPoint(178, 117), new FlxPoint(164, 135), new FlxPoint(131, 128), new FlxPoint(134, 113)];
			headSweatArray[38] = [new FlxPoint(128, 103), new FlxPoint(166, 84), new FlxPoint(211, 94), new FlxPoint(212, 120), new FlxPoint(178, 117), new FlxPoint(164, 135), new FlxPoint(131, 128), new FlxPoint(134, 113)];
			headSweatArray[39] = [new FlxPoint(132, 116), new FlxPoint(165, 90), new FlxPoint(222, 96), new FlxPoint(247, 137), new FlxPoint(198, 129), new FlxPoint(191, 156), new FlxPoint(171, 156), new FlxPoint(171, 129)];
			headSweatArray[40] = [new FlxPoint(132, 116), new FlxPoint(165, 90), new FlxPoint(222, 96), new FlxPoint(247, 137), new FlxPoint(198, 129), new FlxPoint(191, 156), new FlxPoint(171, 156), new FlxPoint(171, 129)];
			headSweatArray[41] = [new FlxPoint(132, 116), new FlxPoint(165, 90), new FlxPoint(222, 96), new FlxPoint(247, 137), new FlxPoint(198, 129), new FlxPoint(191, 156), new FlxPoint(171, 156), new FlxPoint(171, 129)];
			headSweatArray[42] = [new FlxPoint(142, 92), new FlxPoint(185, 77), new FlxPoint(238, 99)];
			headSweatArray[43] = [new FlxPoint(142, 92), new FlxPoint(185, 77), new FlxPoint(238, 99)];
			headSweatArray[44] = [new FlxPoint(142, 92), new FlxPoint(185, 77), new FlxPoint(238, 99)];
			headSweatArray[45] = [new FlxPoint(125, 117), new FlxPoint(159, 87), new FlxPoint(218, 94), new FlxPoint(244, 134), new FlxPoint(199, 130), new FlxPoint(196, 154), new FlxPoint(167, 153), new FlxPoint(170, 130)];
			headSweatArray[46] = [new FlxPoint(125, 117), new FlxPoint(159, 87), new FlxPoint(218, 94), new FlxPoint(244, 134), new FlxPoint(199, 130), new FlxPoint(196, 154), new FlxPoint(167, 153), new FlxPoint(170, 130)];
			headSweatArray[47] = [new FlxPoint(125, 117), new FlxPoint(159, 87), new FlxPoint(218, 94), new FlxPoint(244, 134), new FlxPoint(199, 130), new FlxPoint(196, 154), new FlxPoint(167, 153), new FlxPoint(170, 130)];
			headSweatArray[48] = [new FlxPoint(127, 129), new FlxPoint(148, 95), new FlxPoint(197, 87), new FlxPoint(242, 119), new FlxPoint(194, 130), new FlxPoint(199, 155), new FlxPoint(168, 159), new FlxPoint(165, 130)];
			headSweatArray[49] = [new FlxPoint(127, 129), new FlxPoint(148, 95), new FlxPoint(197, 87), new FlxPoint(242, 119), new FlxPoint(194, 130), new FlxPoint(199, 155), new FlxPoint(168, 159), new FlxPoint(165, 130)];
			headSweatArray[50] = [new FlxPoint(127, 129), new FlxPoint(148, 95), new FlxPoint(197, 87), new FlxPoint(242, 119), new FlxPoint(194, 130), new FlxPoint(199, 155), new FlxPoint(168, 159), new FlxPoint(165, 130)];
			headSweatArray[51] = [new FlxPoint(137, 116), new FlxPoint(177, 91), new FlxPoint(220, 105), new FlxPoint(243, 154), new FlxPoint(204, 143), new FlxPoint(192, 166), new FlxPoint(165, 155), new FlxPoint(168, 134)];
			headSweatArray[52] = [new FlxPoint(137, 116), new FlxPoint(177, 91), new FlxPoint(220, 105), new FlxPoint(243, 154), new FlxPoint(204, 143), new FlxPoint(192, 166), new FlxPoint(165, 155), new FlxPoint(168, 134)];
			headSweatArray[53] = [new FlxPoint(137, 116), new FlxPoint(177, 91), new FlxPoint(220, 105), new FlxPoint(243, 154), new FlxPoint(204, 143), new FlxPoint(192, 166), new FlxPoint(165, 155), new FlxPoint(168, 134)];
			headSweatArray[54] = [new FlxPoint(140, 129), new FlxPoint(166, 89), new FlxPoint(203, 82), new FlxPoint(244, 111)];
			headSweatArray[55] = [new FlxPoint(140, 129), new FlxPoint(166, 89), new FlxPoint(203, 82), new FlxPoint(244, 111)];
			headSweatArray[56] = [new FlxPoint(140, 129), new FlxPoint(166, 89), new FlxPoint(203, 82), new FlxPoint(244, 111)];
			headSweatArray[60] = [new FlxPoint(139, 99), new FlxPoint(160, 85), new FlxPoint(221, 88), new FlxPoint(245, 119), new FlxPoint(180, 98)];
			headSweatArray[61] = [new FlxPoint(139, 99), new FlxPoint(160, 85), new FlxPoint(221, 88), new FlxPoint(245, 119), new FlxPoint(180, 98)];
			headSweatArray[63] = [new FlxPoint(116, 121), new FlxPoint(163, 84), new FlxPoint(220, 94), new FlxPoint(249, 144), new FlxPoint(181, 145)];
			headSweatArray[64] = [new FlxPoint(116, 121), new FlxPoint(163, 84), new FlxPoint(220, 94), new FlxPoint(249, 144), new FlxPoint(181, 145)];
			headSweatArray[66] = [new FlxPoint(141, 134), new FlxPoint(162, 90), new FlxPoint(204, 84), new FlxPoint(246, 113), new FlxPoint(223, 128)];
			headSweatArray[67] = [new FlxPoint(141, 134), new FlxPoint(162, 90), new FlxPoint(204, 84), new FlxPoint(246, 113), new FlxPoint(223, 128)];
			headSweatArray[69] = [new FlxPoint(124, 120), new FlxPoint(154, 88), new FlxPoint(227, 101), new FlxPoint(246, 141), new FlxPoint(178, 149)];
			headSweatArray[70] = [new FlxPoint(124, 120), new FlxPoint(154, 88), new FlxPoint(227, 101), new FlxPoint(246, 141), new FlxPoint(178, 149)];
			headSweatArray[72] = [new FlxPoint(127, 139), new FlxPoint(139, 106), new FlxPoint(203, 88), new FlxPoint(232, 116), new FlxPoint(182, 157)];
			headSweatArray[73] = [new FlxPoint(127, 139), new FlxPoint(139, 106), new FlxPoint(203, 88), new FlxPoint(232, 116), new FlxPoint(182, 157)];
			headSweatArray[75] = [new FlxPoint(144, 127), new FlxPoint(178, 101), new FlxPoint(236, 112), new FlxPoint(247, 144), new FlxPoint(217, 166)];
			headSweatArray[76] = [new FlxPoint(144, 127), new FlxPoint(178, 101), new FlxPoint(236, 112), new FlxPoint(247, 144), new FlxPoint(217, 166)];
			headSweatArray[78] = [new FlxPoint(133, 106), new FlxPoint(153, 82), new FlxPoint(221, 86), new FlxPoint(237, 100), new FlxPoint(197, 98)];
			headSweatArray[79] = [new FlxPoint(133, 106), new FlxPoint(153, 82), new FlxPoint(221, 86), new FlxPoint(237, 100), new FlxPoint(197, 98)];

			sweatAreas.splice(0, sweatAreas.length);
			sweatAreas.push({chance:5, sprite:_head, sweatArrayArray:headSweatArray});
			sweatAreas.push({chance:5, sprite:_pokeWindow._torso1, sweatArrayArray:torsoSweatArray});
		}

		encouragementWords = wordManager.newWords();
		encouragementWords.words.push([ { graphic:SandslashResource.wordsSmall, frame:21} ]); // mmmm...
		encouragementWords.words.push([ { graphic:SandslashResource.wordsSmall, frame:4 } ]); // mmm...
		encouragementWords.words.push([ { graphic:SandslashResource.wordsSmall, frame:5 } ]); // mmmngh-
		encouragementWords.words.push([ { graphic:SandslashResource.wordsSmall, frame:8 } ]); // ffff-
		encouragementWords.words.push([ { graphic:SandslashResource.wordsSmall, frame:0 } ]);
		encouragementWords.words.push([ { graphic:SandslashResource.wordsSmall, frame:1 } ]);
		encouragementWords.words.push([ { graphic:SandslashResource.wordsSmall, frame:2 } ]);
		encouragementWords.words.push([ { graphic:SandslashResource.wordsSmall, frame:3 } ]);
		encouragementWords.words.push([ { graphic:SandslashResource.wordsSmall, frame:6 } ]);
		encouragementWords.words.push([ { graphic:SandslashResource.wordsSmall, frame:7 } ]);

		orgasmWords = wordManager.newWords();
		orgasmWords.words.push([ { graphic:AssetPaths.sand_words_large__png, frame:0, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.sand_words_large__png, frame:2, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.sand_words_large__png, frame:4, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.sand_words_large__png, frame:5, width:200, height:150, yOffset: -30, chunkSize:5 } ]);
		orgasmWords.words.push([ // --MMMmmmM-- MMMnghllrtxz
		{ graphic:AssetPaths.sand_words_large__png, frame:1, width:200, height:150, yOffset:-30, chunkSize:14 },
		{ graphic:AssetPaths.sand_words_large__png, frame:3, width:200, height:150, yOffset:-30, chunkSize:7, delay:0.6 }
		]);

		// daaaamn just look at that thing! ...this is gonna be fun~
		toyStartWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:0},
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:2, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:4, yOffset:40, delay:1.6 },
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:6, yOffset:40, delay:2.1 },
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:8, yOffset:60, delay:2.9 },
		]);
		// awwww yeah, now we're talkin'
		toyStartWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:1},
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:3, yOffset:20, delay:1.2 },
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:5, yOffset:40, delay:1.7 },
		]);
		// holy shit that thing's huge
		toyStartWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:7},
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:9, yOffset:20, delay:0.7 },
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:11, yOffset:40, delay:1.4 },
		]);

		// awww, c'mon... ya didn't even let me play with it
		toyInterruptWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:10},
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:12, yOffset:26, delay:1.5 },
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:14, yOffset:46, delay:2.3 },
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:16, yOffset:66, delay:2.9 },
		]);
		// what, puttin' it away already?
		toyInterruptWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:13},
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:15, yOffset:20, delay:1.0 },
		]);
		// hey no! ...giant dildooo!! come baaaack
		toyInterruptWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:17},
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:19, yOffset:20, delay:1.5 },
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:21, yOffset:40, delay:3.3 },
		]);

		phoneStartWords = wordManager.newWords();
		// another phone call? ...you better take this one
		phoneStartWords.words.push([
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:0},
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:2, yOffset:20, delay:0.9 },
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:4, yOffset:20, delay:1.7 },
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:6, yOffset:42, delay:2.5 },
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:8, yOffset:60, delay:3.1 },
		]);
		// what am i, like... your booty call now?
		phoneStartWords.words.push([
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:1},
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:3, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:5, yOffset:20, delay:1.6 },
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:7, yOffset:40, delay:2.4 },
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:9, yOffset:58, delay:2.9 },
		]);
		// naww not the mouth end, use the other side!
		phoneStartWords.words.push([
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:10},
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:12, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:14, yOffset:40, delay:1.6 },
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:16, yOffset:40, delay:2.2 },
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:18, yOffset:62, delay:3.0 },
		]);
		// aww this one's got a cord!! see, that's like way safer
		phoneStartWords.words.push([
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:11},
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:13, yOffset:22, delay:0.7 },
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:15, yOffset:44, delay:1.5 },
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:17, yOffset:62, delay:2.2 },
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:19, yOffset:84, delay:2.9 },
		]);
		// the fuck are we doing? ...seriously?
		phoneStartWords.words.push([
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:20},
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:22, yOffset:24, delay:1.0 },
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:24, yOffset:46, delay:2.5 },
		]);

		phoneInterruptWords = wordManager.newWords();
		phoneInterruptWords.words.push([
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:26},
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:28, yOffset:22, delay:0.7 },
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:30, yOffset:42, delay:1.4 },
		]);
		phoneInterruptWords.words.push([
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:21},
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:23, yOffset:24, delay:0.7 },
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:25, yOffset:46, delay:1.4 },
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:27, yOffset:68, delay:1.9 },
		]);
		phoneInterruptWords.words.push([
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:29},
		{ graphic:AssetPaths.sandphone_words_small0__png, frame:31, yOffset:0, delay:1.0 },
		]);

		pleasureWords = wordManager.newWords();
		pleasureWords.words.push([ { graphic:AssetPaths.sand_words_medium__png, frame:5, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.sand_words_medium__png, frame:6, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.sand_words_medium__png, frame:0, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.sand_words_medium__png, frame:1, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.sand_words_medium__png, frame:2, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.sand_words_medium__png, frame:3, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.sand_words_medium__png, frame:4, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.sand_words_medium__png, frame:7, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.sand_words_medium__png, frame:8, height:48, chunkSize:5 } ]);

		dildoTooFastWords = wordManager.newWords(45);
		// hey ease off a bit - this thing's bigger than it looks
		dildoTooFastWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:18},
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:20, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:22, yOffset:16, delay:1.3 },
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:24, yOffset:34, delay:2.1 },
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:26, yOffset:58, delay:2.9 },
		]);
		// ngh, can you slow it down a little
		dildoTooFastWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:23},
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:25, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:27, yOffset:40, delay:1.6 },
		]);
		// kkkh -- too fast, c'mon
		dildoTooFastWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:29},
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:31, yOffset:18, delay:0.8 },
		]);
		// c'mon, that's way too fast
		dildoTooFastWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:28},
		{ graphic:AssetPaths.sanddildo_words_small0__png, frame:30, yOffset:20, delay:0.8 },
		]);

		dildoDeeperWords = wordManager.newWords(90);
		// nggh, get in there, don't be afraid
		dildoDeeperWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:22},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:24, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:26, yOffset:40, delay:1.4 },
		]);
		// c'mon, i can take it
		dildoDeeperWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:28},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:30, yOffset:20, delay:0.6 },
		]);
		// yeahhh, get fuckin' IN there~
		dildoDeeperWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:29},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:31, yOffset:24, delay:0.9 },
		]);

		dildoNiceWords = wordManager.newWords(120);
		// where did you GET this thing! fuck
		dildoNiceWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:0},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:2, yOffset:20, delay:1.0 },
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:4, yOffset:40, delay:2.3 },
		]);
		// ooooogh feel those little ribs poppin' in
		dildoNiceWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:6},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:8, yOffset:18, delay:0.8 },
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:10, yOffset:40, delay:1.6 },
		]);
		// aggghhh~ i LOVE this thing
		dildoNiceWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:12},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:14, yOffset:20, delay:0.8 },
		]);
		// i gotta get me one of these
		dildoNiceWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:16},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:18, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:20, yOffset:40, delay:1.4 },
		]);
		// geez 'slike.... the fuckin' fillet mignon of dildos
		dildoNiceWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:1},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:3, yOffset:20, delay:1.3 },
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:5, yOffset:40, delay:2.1 },
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:7, yOffset:60, delay:2.7 },
		]);
		// ahh s-s-such a tight fit...
		dildoNiceWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:9},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:11, yOffset:20, delay:0.8 },
		]);
		// f-fuckin'... best dildo ever...
		dildoNiceWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:13},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:15, yOffset:20, delay:0.8 },
		]);
		// any chance i can buy this thing off you?
		dildoNiceWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:17},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:19, yOffset:24, delay:0.8 },
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:21, yOffset:48, delay:1.6 },
		]);
		// yeah right there... RIGHT there.... hah~
		dildoNiceWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:23},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:25, yOffset:22, delay:0.8 },
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:27, yOffset:42, delay:1.7 },
		]);

		phoneNiceWords = wordManager.newWords(120);
		// aggghhh~ i LOVE this thing
		phoneNiceWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:12},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:14, yOffset:20, delay:0.8 },
		]);
		// i gotta get me one of these
		phoneNiceWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:16},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:18, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:20, yOffset:40, delay:1.4 },
		]);
		// ahh s-s-such a tight fit...
		phoneNiceWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:9},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:11, yOffset:20, delay:0.8 },
		]);
		// f-fuckin'... best dildo ever...
		phoneNiceWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:13},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:15, yOffset:20, delay:0.8 },
		]);
		// yeah right there... RIGHT there.... hah~
		phoneNiceWords.words.push([
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:23},
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:25, yOffset:22, delay:0.8 },
		{ graphic:AssetPaths.sanddildo_words_small1__png, frame:27, yOffset:42, delay:1.7 },
		]);

		almostWords = wordManager.newWords(30);
		// mmmMMmm, get ready...
		almostWords.words.push([
		{ graphic:AssetPaths.sand_words_medium__png, frame:9, height:48, chunkSize:5 },
		{ graphic:AssetPaths.sand_words_medium__png, frame:11, height:48, chunkSize:5, yOffset:20, delay:1.2 }
		]);
		// Fffffff--- here it c-comes
		almostWords.words.push([
		{ graphic:AssetPaths.sand_words_medium__png, frame:10, height:48, chunkSize:5 },
		{ graphic:AssetPaths.sand_words_medium__png, frame:12, height:48, chunkSize:5, yOffset:20, delay:1.4 }
		]);
		// ahh!! s-so close... hahh... hah...
		almostWords.words.push([
		{ graphic:AssetPaths.sand_words_medium__png, frame:13, height:48, chunkSize:5 },
		{ graphic:AssetPaths.sand_words_medium__png, frame:15, height:48, chunkSize:5, yOffset:23, delay:0.7 },
		{ graphic:AssetPaths.sand_words_medium__png, frame:17, height:48, chunkSize:5, yOffset:40, delay:1.8 }
		]);

		rubDickWords = wordManager.newWords(35);
		if (_male)
		{
			// tsk my dick's gettin' cold over here
			rubDickWords.words.push([
			{ graphic:SandslashResource.wordsSmall, frame:9 },
			{ graphic:SandslashResource.wordsSmall, frame:11, yOffset:17, delay:0.8 },
			{ graphic:SandslashResource.wordsSmall, frame:13, yOffset:32, delay:1.6 }
			]);
		}
		else {
			// tsk my pussy's gettin' hungry over here
			rubDickWords.words.push([
			{ graphic:SandslashResource.wordsSmall, frame:9 },
			{ graphic:SandslashResource.wordsSmall, frame:11, yOffset:19, delay:0.8 },
			{ graphic:SandslashResource.wordsSmall, frame:13, yOffset:36, delay:1.6 }
			]);
		}
		// time for the main event, c'mon
		rubDickWords.words.push([
		{ graphic:SandslashResource.wordsSmall, frame:10},
		{ graphic:SandslashResource.wordsSmall, frame:12, yOffset:19, delay:0.8 },
		{ graphic:SandslashResource.wordsSmall, frame:14, yOffset:34, delay:1.4 }
		]);
		// ay i think my dick wants a turn
		rubDickWords.words.push([
		{ graphic:SandslashResource.wordsSmall, frame:15},
		{ graphic:SandslashResource.wordsSmall, frame:17, yOffset:18, delay:0.6 },
		{ graphic:SandslashResource.wordsSmall, frame:19, yOffset:34, delay:1.2 }
		]);

		boredWords = wordManager.newWords();
		boredWords.words.push([ { graphic:SandslashResource.wordsSmall, frame:16 } ]);
		boredWords.words.push([ { graphic:SandslashResource.wordsSmall, frame:18 } ]);
		boredWords.words.push([ { graphic:SandslashResource.wordsSmall, frame:20 } ]);
		// tsk~ we takin' a break?
		boredWords.words.push([ { graphic:SandslashResource.wordsSmall, frame:22},
		{ graphic:SandslashResource.wordsSmall, frame:24, yOffset:18, delay:0.6 }
							  ]);

		tasteWords = wordManager.newWords(10);
		// mmmm... lemme taste those c'mon
		tasteWords.words.push([
		{ graphic:SandslashResource.wordsSmall, frame:21},
		{ graphic:SandslashResource.wordsSmall, frame:23, yOffset:16, delay:0.7 },
		{ graphic:SandslashResource.wordsSmall, frame:25, yOffset:34, delay:1.4 }
		]);
		// ay get those nasty fingers up here~
		tasteWords.words.push([
		{ graphic:SandslashResource.wordsSmall, frame:26},
		{ graphic:SandslashResource.wordsSmall, frame:28, yOffset:22, delay:0.7 },
		{ graphic:SandslashResource.wordsSmall, frame:30, yOffset:42, delay:1.4 }
		]);
		// ayyy gimme a lick of those
		tasteWords.words.push([
		{ graphic:SandslashResource.wordsSmall, frame:27},
		{ graphic:SandslashResource.wordsSmall, frame:29, yOffset:20, delay:0.7 },
		{ graphic:SandslashResource.wordsSmall, frame:31, yOffset:34, delay:1.4 }
		]);
	}

	override function penetrating():Bool
	{
		if (specialRub == "ass0" || specialRub == "ass1")
		{
			return true;
		}
		if (specialRub == "suck-fingers")
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

	override public function computeChatComplaints(complaints:Array<Int>):Void
	{
		if (meanThings[1] == false && kelvMiss.length >= 4 && kelvMiss[3] >= 20)
		{
			complaints.push(0);
		}
		if (meanThings[1] == false)
		{
			complaints.push(1);
		}
		if (meanThings[0] == false)
		{
			complaints.push(2);
		}
		if (fingerSuckCount() == 0)
		{
			complaints.push(3);
		}
		if (niceThings[0] == true)
		{
			complaints.push(4);
		}
	}

	override function generateCumshots():Void
	{
		if (!came)
		{
			_heartBank._dickHeartReservoir = SexyState.roundUpToQuarter(heartPenalty * _heartBank._dickHeartReservoir);
			_heartBank._foreplayHeartReservoir = SexyState.roundUpToQuarter(heartPenalty * _heartBank._foreplayHeartReservoir);
		}
		if (addToyHeartsToOrgasm && _remainingOrgasms == 1)
		{
			_heartBank._dickHeartReservoir += _toyBank._dickHeartReservoir;
			_heartBank._dickHeartReservoir += _toyBank._foreplayHeartReservoir;
			_heartBank._dickHeartReservoir += ambientDildoBank;

			_toyBank._dickHeartReservoir = 0;
			_toyBank._foreplayHeartReservoir = 0;
			ambientDildoBank = 0;
		}
		if (_remainingOrgasms == 1 && specialRub == "rub-dick" || specialRub == "jack-off")
		{
			cameFromHandjob = true;
		}

		super.generateCumshots();

		for (cumshot in _cumShots)
		{
			if (cumshot.arousal == 1)
			{
				cumshot.arousal = 2;
			}
		}
	}

	override function computePrecumAmount():Int
	{
		if (displayingToyWindow())
		{
			var precumAmount:Int = 0;
			if (FlxG.random.float(0, 2) / (1 + goodDildoCounter) < 0.1)
			{
				precumAmount++;
			}
			if (FlxG.random.float(0, 2) / (1 + dildoNiceDepthCombo) < 0.1)
			{
				precumAmount++;
			}
			if (FlxG.random.float(0, 2) / (1 + dildoNiceSpeedCombo) < 0.1)
			{
				precumAmount++;
			}
			if (FlxG.random.float(0, 1.0) >= _heartBank.getDickPercent())
			{
				precumAmount++;
			}
			return precumAmount;
		}
		else {
			var precumAmount:Int = 0;
			if (FlxG.random.float(-10, 40) < (kelv - kelvGoal))
			{
				precumAmount++;
			}
			if (FlxG.random.float(-10, 60) < (kelv - kelvGoal))
			{
				precumAmount++;
			}
			if (FlxG.random.float(1, 20) < _heartEmitCount + (specialRub == "ass0" ? 30 : 0) + (specialRub == "ass1" ? 50 : 0))
			{
				precumAmount++;
			}
			if (FlxG.random.float(0, 1.0) >= _heartBank.getDickPercent())
			{
				precumAmount++;
			}
			return precumAmount;
		}
	}

	private function fingerSuckCount():Int
	{
		var count = 0;
		for (i in 0...specialRubs.length)
		{
			if (specialRubs[i] == "suck-fingers")
			{
				if (i > 0 && specialRubs[i - 1] == "suck-fingers")
				{
					// just one long suck; don't count it twice
					continue;
				}
				count++;
			}
		}
		return count;
	}

	override function handleRubReward():Void
	{
		var fingerSuckCount:Int = fingerSuckCount();
		// rubbed pecs + dick?
		if (niceThings[0] && (specialRub == "jack-off" || specialRub == "rub-dick"))
		{
			if (specialRubs.indexOf("rub-left-pec") >= 0 && specialRubs.indexOf("rub-right-pec") >= 0)
			{
				niceThings[0] = false;
				doNiceThing();
				maybeEmitWords(pleasureWords);
			}
		}
		// ask player to suck fingers after sweaty?
		if ((fingerSuckCount == 0 || !_male && fingerSuckCount < 2) && niceThings[1] && tasteTimer0 < 0 && kelv > 50)
		{
			if (specialRub != "suck-fingers")
			{
				scheduleBreath();
				tasteTimer0 = 30;
				FlxSoundKludge.play(AssetPaths.sandq__mp3, 0.4);
				_characterSfxTimer = _characterSfxFrequency;
				if (sandMood1 == 0)
				{
					maybeEmitWords(tasteWords);
				}
			}
		}
		// suck fingers after sweaty?
		if (niceThings[1] && tasteTimer0 >= 0 && specialRub == "suck-fingers")
		{
			tasteTimer0 = -1;
			niceThings[1] = false;
			doNiceThing();
			_head.animation.play("4-suck-cm");
			if (sandMood0 == 0)
			{
				maybeEmitWords(pleasureWords, 0, 6);
			}
		}
		// ask player to suck fingers after touching something gross?
		if (fingerSuckCount == 1 && niceThings[2] && tasteTimer1 < 0 && specialRub.indexOf(smellyRub) >= 0)
		{
			scheduleBreath();
			tasteTimer1 = 4;
			FlxSoundKludge.play(AssetPaths.sandq__mp3, 0.4);
			_characterSfxTimer = _characterSfxFrequency;
			if (sandMood1 == 1)
			{
				maybeEmitWords(tasteWords);
			}
		}
		// suck fingers after touching something gross?
		if (niceThings[2] && tasteTimer1 >= 0 && specialRub == "suck-fingers")
		{
			tasteTimer1 = -1;
			niceThings[2] = false;
			doNiceThing();
			_head.animation.play("4-suck-cm");
			if (sandMood1 == 1)
			{
				maybeEmitWords(pleasureWords, 0, 6);
			}
		}
		tasteTimer0--;
		tasteTimer1--;

		if (specialRub == "ass0" || specialRub == "ass1")
		{
			if (specialRub == "ass0" && _assTightness > 2.5 || specialRub == "ass1")
			{
				setAssTightness(_assTightness * FlxG.random.float(0.77, 0.87));

				if (_rubBodyAnim2 != null)
				{
					_rubBodyAnim2.refreshSoon();
				}
				if (_rubBodyAnim != null)
				{
					_rubBodyAnim.refreshSoon();
				}
				if (_rubHandAnim != null)
				{
					_rubHandAnim.refreshSoon();
				}
			}

			if (_assTightness < 0.3 && canLoseHand)
			{
				// start hand-losing animation
				interactOff();
				_pokeWindow._arousal = 4;
				_newHeadTimer = 0.5;

				if (!PlayerData.sandMale)
				{
					_dick.animation.play("aroused");
				}
				_pokeWindow._ass.animation.play("aroused");
				_pokeWindow._interact.animation.play("aroused");
				_pokeWindow._interact.visible = true;
				_shadowGlove.visible = true;
				_handSprite.visible = false;
				_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.members.indexOf(_pokeWindow._legs) + 1);

				_pokeWindow._arms0.animation.play("aroused");
				_pokeWindow._arms1.animation.play("aroused");
				_pokeWindow._arms2.animation.play("aroused");
				_armsAndLegsArranger._armsAndLegsTimer = 10;
				emergency = true;
			}
		}

		updateKelv();

		if (kelvMiss.length > 3)
		{
			// transfer some hearts from foreplay -> dick
			var lucky:Float = lucky(0.7, 1.43, 0.015);
			var xferAmount:Float = SexyState.roundUpToQuarter(lucky * _heartBank._foreplayHeartReservoir);
			var missAmount:Int = missAmount();
			if (missAmount < 10 )
			{
				// doing good; transfer full amount
				_heartBank._foreplayHeartReservoir -= xferAmount;
				_heartBank._dickHeartReservoir += xferAmount;
			}
			else if (missAmount < 20)
			{
				// doing just OK; transfer half and lose half
				_heartBank._foreplayHeartReservoir -= xferAmount;
				_heartBank._dickHeartReservoir += SexyState.roundUpToQuarter(0.5 * xferAmount);
			}
			else
			{
				// doing bad; lose all...
				_heartBank._foreplayHeartReservoir -= xferAmount;
			}
		}

		var amount:Float = 0;
		var factor:Float = 0.08;
		if (kelvMiss.length > 3)
		{
			if (kelv >= kelvGoal + 10)
			{
				factor = 0.12;
			}
			else if (kelv <= kelvGoal - 10)
			{
				factor = 0.05;
			}
		}
		if (specialRub == "jack-off")
		{
			var lucky:Float = lucky(0.7, 1.43, factor * 1.3);
			amount = SexyState.roundUpToQuarter(lucky * _heartBank._dickHeartReservoir);
			_heartBank._dickHeartReservoir -= amount;
			if (missAmount() >= 30 && kelv - kelvGoal >= 30)
			{
				amount *= 0.2;
				if (meanThings[0] == true)
				{
					meanThings[0] = false;
				}
			}
			amount = SexyState.roundUpToQuarter(amount * heartPenalty);
			_heartEmitCount += amount;

			if (_remainingOrgasms > 0 && _heartBank.getDickPercent() < 0.51 && !isEjaculating())
			{
				maybeEmitWords(almostWords);
			}
		}
		else {
			var lucky:Float = lucky(0.7, 1.43, factor * 0.4);
			amount = SexyState.roundUpToQuarter(lucky * _heartBank._foreplayHeartReservoir);
			_heartBank._foreplayHeartReservoir -= amount;
			if (missAmount() >= 30 && kelv - kelvGoal <= -30)
			{
				amount *= 0.4;
				if (meanThings[1] == true)
				{
					meanThings[1] = false;
				}
				if (kelvMiss.length > 3 + sandMood0 + sandMood1)
				{
					maybeEmitWords(rubDickWords);
				}
			}
			amount = SexyState.roundUpToQuarter(amount * heartPenalty);
			_heartEmitCount += amount;
		}

		if (specialRub == "suck-fingers")
		{
			if (_heartEmitCount > 0)
			{
				if (encouragementWords.timer < _characterSfxTimer)
				{
					// his mouth is full. the leftmost words are all muffled words, "mmm", "mff", etc...
					maybeEmitWords(encouragementWords, 0, 6);
				}
			}
		}
		else {
			emitCasualEncouragementWords();
		}
		if (_heartEmitCount > 0)
		{
			maybeScheduleBreath();
			maybePlayPokeSfx();
			maybeEmitPrecum();
		}
	}

	function setAssTightness(float:Float)
	{
		this._assTightness = float;

		var tightness0:Int = 3;
		var tightness1:Int = 2;

		if (_assTightness > 3.5)
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
		else if (_assTightness > 1.75)
		{
			tightness0 = 6;
			tightness1 = 3;
		}
		else if (_assTightness > 1.0)
		{
			tightness0 = 6;
			tightness1 = 4;
		}
		else
		{
			tightness0 = 6;
			tightness1 = 5;
		}

		_pokeWindow._dick.animation.add("finger-ass0", [0, 0, 12, 12, 13].slice(0, tightness0));
		_pokeWindow._dick.animation.add("finger-ass1", [0, 12, 12, 13, 13, 13].slice(0, tightness1));
		_pokeWindow._ass.animation.add("finger-ass0", [0, 1, 2, 3, 4, 5].slice(0, tightness0));
		_pokeWindow._ass.animation.add("finger-ass1", [6, 7, 8, 9, 10].slice(0, tightness1));
		_pokeWindow._interact.animation.add("finger-ass0", [16, 17, 18, 19, 20, 21].slice(0, tightness0));
		_pokeWindow._interact.animation.add("finger-ass1", [24, 25, 26, 27, 28].slice(0, tightness1));
	}

	function updateKelv():Void
	{
		var newKelvDelta:Int = 0;
		if (specialRub == "rub-dick" || specialRub == "jack-off")
		{
			newKelvDelta = 5;
		}
		else if (specialRub == "ass0" || specialRub == "ass1")
		{
			newKelvDelta = 2;
		}
		else if (specialRub == "suck-fingers")
		{
			newKelvDelta = 0;
		}
		else if (specialRub == "rub-balls")
		{
			newKelvDelta = -2;
		}
		else {
			newKelvDelta = -5;
		}
		updateKelvWith(newKelvDelta);
	}

	override function emitBreath():Void
	{
		if (tasteTimer0 >= 0 || tasteTimer1 >= 0)
		{
			// emit breath as a clue; he's ready to suck fingers
			super.emitBreath();
		}
		else if (fingerSuckCount() >= 2 || !_male && niceThings[1] == false)
		{
			// emit breath; he's done sucking fingers forever
			super.emitBreath();
		}
	}

	function updateKelvWith(newKelvDelta:Int):Void
	{
		if (newKelvDelta == 0)
		{
			kelvDelta = 0;
		}
		else if (newKelvDelta < 0)
		{
			if (kelvDelta >= 0)
			{
				kelvDelta = 0;
			}
			kelvDelta = Std.int(Math.max( -15, kelvDelta + newKelvDelta));
		}
		else if (newKelvDelta > 0)
		{
			if (kelvDelta <= 0)
			{
				kelvDelta = 0;
			}
			kelvDelta = Std.int(Math.min( 15, kelvDelta + newKelvDelta));
		}
		kelvSway += FlxG.random.getObject([ -2, 0, 2]);
		kelvSway = Std.int(Math.max( -5, Math.min(5, kelvSway)));
		var delta:Int = kelvDelta + kelvSway;
		if (kelvDelta > 0)
		{
			delta = Std.int(Math.max(1, delta));
		}
		else if (kelvDelta < 0)
		{
			delta = Std.int(Math.min( -1, delta));
		}
		kelv += delta;
		kelv = Std.int(FlxMath.bound(kelv, 0, 100));

		if (kelv - kelvGoal < -8)
		{
			if (_pokeWindow._openness != SandslashWindow.Openness.Open)
			{
				_pokeWindow._openness = SandslashWindow.Openness.Open;
				_armsAndLegsArranger._armsAndLegsTimer = Math.min(_armsAndLegsArranger._armsAndLegsTimer, FlxG.random.float(1, 4));
			}
		}
		else if (kelv - kelvGoal <= 8)
		{
			if (_pokeWindow._openness != SandslashWindow.Openness.Neutral)
			{
				_pokeWindow._openness = SandslashWindow.Openness.Neutral;
				_armsAndLegsArranger._armsAndLegsTimer = Math.min(_armsAndLegsArranger._armsAndLegsTimer, FlxG.random.float(1, 4));
			}
		}
		else {
			if (_pokeWindow._openness != SandslashWindow.Openness.Closed)
			{
				_pokeWindow._openness = SandslashWindow.Openness.Closed;
				_armsAndLegsArranger._armsAndLegsTimer = Math.min(_armsAndLegsArranger._armsAndLegsTimer, FlxG.random.float(1, 4));
			}
		}

		if (almostWords.timer <= 0)
		{
			if (kelv < kelvGoal)
			{
				kelvMiss.push(Std.int(Math.max(0, Math.abs(kelv - kelvGoal) - 5)));
			}
			else
			{
				kelvMiss.push(Std.int(Math.max(0, Math.abs(kelv - kelvGoal) - 5)));
			}
			if (kelvMiss.length > 3)
			{
				cumulativeKelvMiss += missAmount();
				if (cumulativeKelvMiss >= 300)
				{
					heartPenalty = 0.40;
				}
				else if (cumulativeKelvMiss >= 240)
				{
					heartPenalty = 0.54;
				}
				else if (cumulativeKelvMiss >= 180)
				{
					heartPenalty = 0.69;
				}
				else if (cumulativeKelvMiss >= 120)
				{
					heartPenalty = 0.83;
				}
				else if (cumulativeKelvMiss >= 60)
				{
					heartPenalty = 0.94;
				}
			}
		}

		kelvGoal += FlxG.random.int(2, 4);
		kelvGoal = Std.int(Math.min(92, kelvGoal));
	}

	function missAmount():Int
	{
		return Std.int(Math.min(kelvMiss[kelvMiss.length - 1], kelvMiss[kelvMiss.length - 2]));
	}

	function emitArousedHearts(lucky:Float):Void
	{
		if (_gameState == 200 && !isEjaculating())
		{
			var amount:Float = SexyState.roundUpToQuarter(lucky * _heartBank._dickHeartReservoir);
			if (amount > 0)
			{
				_heartBank._dickHeartReservoir -= amount;
				_heartEmitCount += amount;
				maybeEmitWords(pleasureWords);
				maybeScheduleBreath();
				maybePlayPokeSfx();
				maybeEmitPrecum();
			}
		}
	}

	function setInactiveDickState():Void
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
			else if (_heartBank.getForeplayPercent() < 0.85 || permaBoner)
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
			if (_pokeWindow._ass.animation.name == "aroused")
			{
				// let animation play out
			}
			else if (_dick.animation.frameIndex != 0)
			{
				_dick.animation.play("default");
			}
		}
	}

	override function dialogTreeCallback(Msg:String):String
	{
		if (Msg == "%permaboner%")
		{
			if (PlayerData.pokemonLibido == 1)
			{
				// no boner when libido's zeroed out
			}
			else
			{
				permaBoner = true;
			}
			setInactiveDickState();
		}
		if (Msg == "%add-phone-button%" && phoneButton == null)
		{
			phoneButton = newToyButton(phoneButtonEvent, AssetPaths.phone_button__png, _dialogTree);
			addToyButton(phoneButton);
		}
		return super.dialogTreeCallback(Msg);
	}

	override public function generateSexyAfterDialog<T:PokeWindow>()
	{
		if (emergency)
		{
			var tree:Array<Array<Object>> = new Array<Array<Object>>();
			SandslashDialog.sexyVeryBad(tree, this);
			PlayerData.appendChatHistory("sand.sexyVeryBad");
			return tree;
		}
		return super.generateSexyAfterDialog();
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		_pokeWindow._ass.animation.add("finger-ass0", [0, 1, 2, 3]);
		_pokeWindow._ass.animation.add("finger-ass1", [6, 7]);
		_dick.animation.add("finger-ass", [0, 0]);
		_pokeWindow._interact.animation.add("finger-ass0", [16, 17, 18, 19]);
		_pokeWindow._interact.animation.add("finger-ass1", [24, 25]);
		_dick.animation.add("finger-ass", [0, 0]);

		dildoUtils.reinitializeHandSprites();
	}

	override public function eventShowToyWindow(args:Array<Dynamic>)
	{
		super.eventShowToyWindow(args);

		if (toyWindow.isPhoneEnabled())
		{
			toyInterface.setPhone();
			dildoUtils.dildoFrameToPct = [
											 1 => 0.00,
											 2 => 0.08,
											 3 => 0.16,
											 4 => 0.24,
											 5 => 0.36,
											 6 => 0.48,
											 7 => 0.60,
											 8 => 0.72,
											 9 => 0.86,
											 10 => 1.00,

											 13 => 0.00,
											 14 => 0.08,
											 15 => 0.16,
											 16 => 0.24,
											 17 => 0.36,
											 18 => 0.48,
											 19 => 0.60,
											 20 => 0.72,
											 21 => 0.86,
											 22 => 1.00
										 ];
			toyInterface.setTightness((3 + _assTightness) / 2, 0.5);
		}
		else
		{
			toyInterface.setTightness((5 + _assTightness) / 2, 2.5);
		}

		dildoUtils.showToyWindow();

		defaultAmbientDildoBankCapacity = SexyState.roundUpToQuarter(_toyBank._foreplayHeartReservoir * 0.10);
		ambientDildoBankCapacity = defaultAmbientDildoBankCapacity;

		dildoTooFastWords.timer = FlxG.random.float( -30, 60);
		dildoDeeperWords.timer = FlxG.random.float( -30, 90);
		dildoNiceWords.timer = FlxG.random.float( -30, 120);
	}

	override public function eventHideToyWindow(args:Array<Dynamic>)
	{
		super.eventHideToyWindow(args);
		dildoUtils.hideToyWindow();

		/*
		 * "hospital" sequence starts at 0.3; so make sure the ass tightness is
		 * tight enough that it doesn't automatically trigger
		 */
		setAssTightness(FlxMath.bound(toyInterface.assTightness * 2 - 5, 0.8, 5.0));
	}

	override function cursorSmellPenaltyAmount():Int
	{
		// he actually likes it?
		return -55;
	}

	override public function back():Void
	{
		// if the foreplayHeartReservoir is empty (or half empty), empty the
		// dick heart reservoir too -- that way the toy meter won't stay full.
		_toyBank._dickHeartReservoir = Math.min(_toyBank._dickHeartReservoir, SexyState.roundDownToQuarter(_toyBank._defaultDickHeartReservoir * _toyBank.getForeplayPercent()));
		// refund any toy hearts left in the bank
		_toyBank._foreplayHeartReservoir += ambientDildoBank;

		super.back();
	}

	override public function destroy():Void
	{
		super.destroy();

		mouthPolyArray = null;
		assPolyArray = null;
		leftPecPolyArray = null;
		rightPecPolyArray = null;
		leftFootPolyArray = null;
		rightFootPolyArray = null;
		vagPolyArray = null;
		rubDickWords = null;
		tasteWords = null;
		kelvMiss = null;
		niceThings = null;
		meanThings = null;

		smallDildoButton = FlxDestroyUtil.destroy(smallDildoButton);
		toyWindow = FlxDestroyUtil.destroy(toyWindow);
		toyInterface = FlxDestroyUtil.destroy(toyInterface);
		dildoUtils = FlxDestroyUtil.destroy(dildoUtils);
	}

	override public function rotateSexyChat(?badThings:Array<Int>):Void
	{
		super.rotateSexyChat(badThings);

		if (insertedPhone)
		{
			PlayerData.sandPhone = 10;
		}
		else {
			PlayerData.sandPhone = 0;
		}
	}
}