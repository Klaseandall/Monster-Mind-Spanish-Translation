package poke.luca;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import poke.buiz.DildoUtils;
import poke.luca.LucarioSexyWindow;
import poke.sexy.SexyState;
import poke.sexy.WordManager.Qord;

/**
 * Sex sequence for Lucario
 * 
 * Lucario has a few areas she likes rubbed, but three which are especially
 * sensitive. These three areas change, but they include her feet, her tail,
 * her ass, her chest spike, her belly, her shoulders, and her thighs.
 * 
 * You can tell when you rub one of the correct areas for the first time,
 * because a lot more hearts will appear than normal, and she'll moan out a
 * phrase like "kyehhHHHhh~" or "...ohh! OOOOhhh..."
 * 
 * One of the sensitive areas is always either her feet, shoulders, or thighs.
 * Only one of the three, so once you find one of them is sensitive, you don't
 * need to try the others.
 * 
 * The second of the sensitive areas is always either her tail, or her chest
 * spike. Only one of the two, so once you find one of them is sensitive, you
 * don't need to try the other.
 * 
 * The third of the sensitive areas is always either her ass, or her belly. If
 * her tail is sensitive, her ass is also sensitive. If her chest spike is
 * sensitive, her belly is also sensitive.
 * 
 * If you rub all three of her sensitive areas consecutively, without rubbing
 * anything else, you'll make her very very happy.
 * 
 * Lucario also has a preferred pace for rubbing her vagina. This changes each
 * time, so try to speed up and slow down and keep track of how many hearts she
 * spits out. The tiny white hearts count as 1, the pink hearts count as 2, and
 * the big red hearts count as 4.
 * 
 * Lucario likes the blue and gummy dildos equally. She will tolerate the red
 * dildo, but it will never fit and it will never make her as happy as the
 * other choices. (Well OK, it'll fit if you buy five mystery boxes, and she'll
 * enjoy it if you purchase 11 mystery boxes. But, only a crazy person would do
 * that.)
 * 
 * There are four things you can do with the sex toy; rub her entrance, finger
 * her entrance, push the dildo in a little, and hammer her with it. She wants
 * you to do these four things in a specific order without messing up. This
 * order changes a little each time, but in general she wants you to warm her
 * up first. For example, she might want you to finger her a little, tease her
 * entrance with your fingers, hammer her with it and then tease her with the
 * tip of the dildo. It is not perfectly in order, but it is usually close.
 * 
 * You can tell if she likes what you are doing by studying her face; she will
 * close her eyes and whimper when she likes it. She will open her eyes and
 * stare at you if she wants you to do something else. Use this to figure out
 * the correct order.
 * 
 * She doesn't like if you penetrate her too rapidly, so pace yourself.
 * 
 * While using the toy, if you mess up your pacing or can't figure out what
 * Lucario wants, you can vigorously rub her clitoris. She likes this and this
 * will get her back in the mood so you can try again.
 */
class LucarioSexyState extends SexyState<LucarioSexyWindow>
{
	public static inline var XL_DILDO_TIGHTNESS_BARRIER:Float = 4.3; // limit for how far the giant dildo will go in (0 = no limit)

	private var vagTightness:Float = 5;
	private var assTightness:Float = 5;

	private var assPolyArray:Array<Array<FlxPoint>>;
	private var leftCalfPolyArray:Array<Array<FlxPoint>>;
	private var rightCalfPolyArray:Array<Array<FlxPoint>>;
	private var chestSpikePolyArray:Array<Array<FlxPoint>>;
	private var leftShoulderDownPolyArray:Array<Array<FlxPoint>>;
	private var leftShoulderUpPolyArray:Array<Array<FlxPoint>>;
	private var rightShoulderDownPolyArray:Array<Array<FlxPoint>>;
	private var rightShoulderUpPolyArray:Array<Array<FlxPoint>>;
	private var leftThighPolyArray:Array<Array<FlxPoint>>;
	private var rightThighPolyArray:Array<Array<FlxPoint>>;
	private var tailPolyArray:Array<Array<FlxPoint>>;
	private var vagPolyArray:Array<Array<FlxPoint>>;

	/*
	 * niceThings[0] = player consecutively rubs all of Lucario's sensitive parts
	 * niceThings[1] = lucario orgasms (this is free)
	 */
	private var niceThings:Array<Bool> = [
			true,
			true
										 ];

	private var lucarioMood0:Int = FlxG.random.int(0, 5); // which body parts does lucario want rubbed?
	private var lucarioMood1:Int = FlxG.random.int(0, 4); // how fast does lucario want you rubbing his genitals

	private var targetJackoffSpeed:Float = 0;
	private var jackoffPaceDeviance:Float = 1.0; // 1.0 = perfect; 0.5 = 2xtoo fast, 2.0 = 2xtoo slow

	private var specialSpotTimeTaken:Int = 0;
	private var lastFourUniqueSpecialRubs:Array<String> = [];
	private var specialSpots:Array<String>;
	private var untouchedSpecialSpots:Array<String>;
	private var specialSpotChain:Array<String>;
	private var badJackoffBank:Float = 0; // if they're too fast/too slow, penalties get emptied into this bank which is reimbursed later
	private var badRubBank:Float = 0; // if they're too fast/too slow, penalties get emptied into this bank which is reimbursed later
	private var niceSpecialSpotFace:Bool = false;

	private var toyWindow:LucarioDildoWindow;
	private var toyInterface:LucarioDildoInterface;
	private var badToyBank:Float = 0;
	// A black shadow which erases prevents male lucario's cumshots from appearing in front of their balls in a glitchy way
	private var toyShadowBalls:BouncySprite;

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
	private var toyOnTrack:Bool = false;
	private var toyPattern:Array<String>;
	private var remainingToyPattern:Array<String>;
	private var shortestToyPatternLength:Int = 9999;
	private var toyPrecumTimer:Float = 0;
	private var toyMessUpCount:Int = 0;
	private var bonusDildoOrgasmTimer:Int = -1;
	private var dildoUtils:DildoUtils;
	private var toyClitWords:Qord;
	private var toyXlWords:Qord;
	private var insufficientClitRubCount:Int = Std.int(FlxG.random.float(3, 8));

	override public function create():Void
	{
		prepare("luca");

		toyWindow = new LucarioDildoWindow(256, 0, 248, 426);
		toyInterface = new LucarioDildoInterface();
		toyGroup.add(toyWindow);
		toyGroup.add(toyInterface);

		dildoUtils = new DildoUtils(this, toyInterface, toyWindow.ass, toyWindow._dick, toyWindow.dildo, toyWindow._interact);
		dildoUtils.refreshDildoAnims = refreshDildoAnims;
		dildoUtils.dildoFrameToPct = [
			1 => 0.00,
			2 => 0.04,
			3 => 0.16,
			4 => 0.28,
			5 => 0.40,
			6 => 0.52,
			7 => 0.64,
			8 => 0.76,
			9 => 0.88,
			10 => 1.00,

			13 => 0.00,
			14 => 0.04,
			15 => 0.16,
			16 => 0.28,
			17 => 0.40,
			18 => 0.52,
			19 => 0.64,
			20 => 0.76,
			21 => 0.88,
			22 => 1.00,
		];

		super.create();

		sfxEncouragement = [AssetPaths.luca0__mp3, AssetPaths.luca1__mp3, AssetPaths.luca2__mp3, AssetPaths.luca3__mp3];
		sfxPleasure = [AssetPaths.luca4__mp3, AssetPaths.luca5__mp3, AssetPaths.luca6__mp3];
		sfxOrgasm = [AssetPaths.luca7__mp3, AssetPaths.luca8__mp3, AssetPaths.luca9__mp3];

		popularity = 1.0;
		cumTrait0 = 5;
		cumTrait1 = 2;
		cumTrait2 = 4;
		cumTrait3 = 8;
		cumTrait4 = 4;

		_bonerThreshold = 0.35;
		_cumThreshold = 0.53;
		_rubRewardFrequency = 3.6;

		specialSpots = [
			["left-foot", "right-foot", _male ? "balls" : "tail", "ass"],
			["left-foot", "right-foot", "spike", "belly"],
			["left-shoulder", "right-shoulder", _male ? "balls" : "tail", "ass"],
			["left-shoulder", "right-shoulder", "spike", "belly"],
			["left-thigh", "right-thigh", _male ? "balls" : "tail", "ass"],
			["left-thigh", "right-thigh", "spike", "belly"]
		][lucarioMood0];

		targetJackoffSpeed = [0.91, 1.04, 1.2, 1.38, 1.59][lucarioMood1];
		untouchedSpecialSpots = specialSpots.copy();
		specialSpotChain = specialSpots.copy();

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_BLUE_DILDO))
		{
			var blueDildoButton:FlxButton = newToyButton(blueDildoButtonEvent, AssetPaths.dildo_blue_button__png, _dialogTree);
			addToyButton(blueDildoButton);
		}

		if (ItemDatabase.playerHasUneatenItem(ItemDatabase.ITEM_GUMMY_DILDO))
		{
			var gummyDildoButton:FlxButton = newToyButton(gummyDildoButtonEvent, AssetPaths.dildo_gummy_button__png, _dialogTree);
			addToyButton(gummyDildoButton);
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_HUGE_DILDO))
		{
			var xlDildoButton:FlxButton = newToyButton(xlDildoButtonEvent, AssetPaths.dildo_xl_button__png, _dialogTree);
			if (isXlDildoFittingEasily())
			{
				addToyButton(xlDildoButton, 1.00);
			}
			else if (isXlDildoFitting())
			{
				addToyButton(xlDildoButton, 0.75);
			}
			else
			{
				addToyButton(xlDildoButton, 0.55);
			}
		}

		/*
		 * 1 is never in last position; 3 is never in first position; 4 is never in first two positions
		 */
		toyPattern = FlxG.random.getObject([
											   ["0", "1", "2", "3"],
											   ["0", "1", "3", "2"],
											   ["0", "2", "1", "3"],
											   ["0", "2", "3", "1"],
											   ["1", "0", "2", "3"],
											   ["1", "0", "3", "2"],
											   ["1", "2", "0", "3"],
										   ]);
		remainingToyPattern = toyPattern.copy();
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

	public function xlDildoButtonEvent():Void
	{
		toyWindow.setXlDildo();

		// reinitialize dildoUtils with XL dildo
		dildoUtils = FlxDestroyUtil.destroy(dildoUtils);
		dildoUtils = new DildoUtils(this, toyInterface, toyWindow.ass, toyWindow._dick, toyWindow.dildo, toyWindow._interact);
		dildoUtils.refreshDildoAnims = refreshDildoAnims;
		dildoUtils.reinitializeHandSprites();

		// assign XL dildo frame values
		dildoUtils.dildoFrameToPct = [
			1 => 0.00,
			2 => 0.02,
			3 => 0.04,
			4 => 0.06,
			9 => 0.10,
			10 => 0.20,
			11 => 0.30,
			12 => 0.40,
			13 => 0.55,
			14 => 0.70,
			15 => 0.85,
			16 => 1.00,

			17 => 0.09,
			18 => 0.18,
			19 => 0.30,
			20 => 0.42,
			21 => 0.54,
			22 => 0.76,
			23 => 0.88,
			24 => 1.00,

			5 => 0.00,
			6 => 0.02,
			7 => 0.04,
			8 => 0.06,
		];

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
		 * 40% of the toy hearts are available for doing random stuff. the
		 * other 60% are only available if you hit the right spot
		 */
		return 0.40;
	}

	override public function getToyWindow():PokeWindow
	{
		return toyWindow;
	}

	public function eventLowerDildoArm(args:Array<Dynamic>):Void
	{
		if (toyWindow.arms0.animation.name == "arm-grab")
		{
			toyWindow.arms0.animation.play("default");
		}
		if (toyWindow.arms1.animation.name == "arm-grab")
		{
			toyWindow.arms1.animation.play("default");
		}
		if (toyWindow._dick.animation.name == "arm-grab")
		{
			toyWindow._dick.animation.play("default");
		}
		if (toyWindow.ass.animation.name == "arm-grab")
		{
			toyWindow.ass.animation.play("default");
		}
		if (toyWindow.hands.animation.name == "arm-grab")
		{
			toyWindow.hands.animation.play("default");
		}
	}

	public static function isXlDildoFittingEasily():Bool
	{
		return ItemDatabase.getPurchasedMysteryBoxCount() >= 11;
	}

	public static function isXlDildoFitting():Bool
	{
		return ItemDatabase.getPurchasedMysteryBoxCount() >= 5;
	}

	override public function handleToyWindow(elapsed:Float):Void
	{
		super.handleToyWindow(elapsed);

		toyPrecumTimer -= elapsed;

		dildoUtils.update(elapsed);
		if (toyShadowBalls != null && toyWindow.balls != null)
		{
			syncShadowGlove(toyShadowBalls, toyWindow.balls);
		}

		handleToyReward(elapsed);

		if (FlxG.mouse.justPressed && toyInterface.animName != null)
		{
			if (toyInterface.ass)
			{
				if (toyInterface.animName == "dildo-ass0" || toyInterface.animName == "dildo-ass1")
				{
					if (toyWindow.isXlDildo() && !isXlDildoFitting())
					{
						// XL dildo doesn't fit
						toyInterface.setTightness(Math.max(toyInterface.assTightness * FlxG.random.float(0.99, 1.00), XL_DILDO_TIGHTNESS_BARRIER), toyInterface.vagTightness);
					}
					else if (toyWindow.isXlDildo() && !isXlDildoFittingEasily())
					{
						// XL dildo fits, but it's tight
						if (toyInterface.assTightness > 5.00)
						{
							toyInterface.setTightness(toyInterface.assTightness * FlxG.random.float(0.99, 1.00), toyInterface.vagTightness);
						}
						else
						{
							toyInterface.setTightness(toyInterface.assTightness * FlxG.random.float(0.90, 0.94), toyInterface.vagTightness);
						}
					}
					else
					{
						// XL dildo fits trivially
						toyInterface.setTightness(toyInterface.assTightness * FlxG.random.float(0.90, 0.94), toyInterface.vagTightness);
					}
				}
			}
			else
			{
				if (toyInterface.animName == "dildo-vag0" || toyInterface.animName == "dildo-vag1")
				{
					if (toyWindow.isXlDildo() && !isXlDildoFitting())
					{
						// XL dildo doesn't fit
						toyInterface.setTightness(toyInterface.assTightness, Math.max(toyInterface.vagTightness * FlxG.random.float(0.99, 1.00), XL_DILDO_TIGHTNESS_BARRIER));
					}
					else if (toyWindow.isXlDildo() && !isXlDildoFittingEasily())
					{
						// XL dildo fits, but it's tight
						if (toyInterface.vagTightness > 5.00)
						{
							toyInterface.setTightness(toyInterface.assTightness, toyInterface.vagTightness * FlxG.random.float(0.99, 1.00));
						}
						else
						{
							toyInterface.setTightness(toyInterface.assTightness, toyInterface.vagTightness * FlxG.random.float(0.90, 0.94));
						}
					}
					else
					{
						toyInterface.setTightness(toyInterface.assTightness, toyInterface.vagTightness * FlxG.random.float(0.90, 0.94));
					}
				}
			}
		}

		if (FlxG.mouse.justPressed && toyInterface.animName != null)
		{
			if (toyWindow.arms0.animation.name == "arm-grab")
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
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._dick, "rub-vag", [10, 11, 12, 13, 14, 15, 16], 2);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "rub-vag", [14, 15, 16, 17, 18, 19, 20], 2);
		}
		else if (toyInterface.animName == "finger-vag")
		{
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._dick, "finger-vag", [17, 18, 19, 20, 21], 2);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "finger-vag", [21, 22, 23, 24, 25], 2);
		}
		else if (toyInterface.animName == "dildo-vag0")
		{
			if (toyWindow.isXlDildo() && !isXlDildoFitting())
			{
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._dick, "dildo-vag0", [0, 1, 2, 3, 3], 2);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.dildo, "dildo-vag0", [1, 2, 3, 4, 4], 2);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-vag0", [49, 50, 51, 52, 52], 2);
			}
			else if (toyWindow.isXlDildo())
			{
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._dick, "dildo-vag0", [0, 3, 4, 4, 26, 26], 2);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.dildo, "dildo-vag0", [1, 9, 10, 11, 12, 13], 2);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-vag0", [49, 57, 58, 59, 60, 61], 2);
			}
			else
			{
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._dick, "dildo-vag0", [0, 1, 2, 3, 4, 5], 2);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.dildo, "dildo-vag0", [1, 2, 3, 4, 5, 6], 2);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-vag0", [1, 2, 3, 4, 5, 6], 2);
			}
		}
		else if (toyInterface.animName == "dildo-vag1")
		{
			if (toyWindow.isXlDildo() && !isXlDildoFitting())
			{
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._dick, "dildo-vag1", [0, 1, 2, 3, 3, 3], 3);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.dildo, "dildo-vag1", [1, 2, 3, 4, 4, 4], 3);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-vag1", [49, 50, 51, 52, 52, 52], 3);
			}
			else if (toyWindow.isXlDildo())
			{
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._dick, "dildo-vag1", [4, 26, 26, 27, 27, 27], 3);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.dildo, "dildo-vag1", [11, 12, 13, 14, 15, 16], 3);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-vag1", [59, 60, 61, 62, 63, 64], 3);
			}
			else
			{
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._dick, "dildo-vag1", [3, 4, 5, 6, 7, 8, 9], 3);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.dildo, "dildo-vag1", [4, 5, 6, 7, 8, 9, 10], 3);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-vag1", [7, 8, 9, 10, 11, 12, 13], 3);
			}
		}
		else if (toyInterface.animName == "rub-ass")
		{
			refreshed = dildoUtils.refreshDildoAnim(toyWindow.ass, "rub-ass", [1, 2, 3, 4], 2);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "rub-ass", [26, 27, 28, 29], 2);
		}
		else if (toyInterface.animName == "finger-ass")
		{
			refreshed = dildoUtils.refreshDildoAnim(toyWindow.ass, "finger-ass", [0, 5, 6, 7, 8, 9], 2);
			refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "finger-ass", [30, 31, 32, 33, 34, 35], 2);
		}
		else if (toyInterface.animName == "dildo-ass0")
		{
			if (toyWindow.isXlDildo() && !isXlDildoFitting())
			{
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.ass, "dildo-ass0", [0, 10, 11, 12, 12], 2);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.dildo, "dildo-ass0", [5, 6, 7, 8, 8], 2);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-ass0", [53, 54, 55, 56, 56], 2);
			}
			else if (toyWindow.isXlDildo())
			{
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.ass, "dildo-ass0", [0, 10, 13, 14, 15, 17], 2);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.dildo, "dildo-ass0", [5, 17, 18, 19, 20, 21], 2);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-ass0", [53, 65, 66, 67, 68, 69], 2);
			}
			else
			{
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.ass, "dildo-ass0", [0, 10, 11, 12, 13, 14], 2);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.dildo, "dildo-ass0", [13, 14, 15, 16, 17, 18], 2);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-ass0", [36, 37, 38, 39, 40, 41], 2);
			}
		}
		else if (toyInterface.animName == "dildo-ass1")
		{
			if (toyWindow.isXlDildo() && !isXlDildoFitting())
			{
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.ass, "dildo-ass1", [0, 10, 11, 12, 12, 12], 3);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.dildo, "dildo-ass1", [5, 6, 7, 8, 8, 8], 3);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-ass1", [53, 54, 55, 56, 56, 56], 3);
			}
			else if (toyWindow.isXlDildo())
			{
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.ass, "dildo-ass1", [14, 15, 17, 18, 18, 18], 3);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.dildo, "dildo-ass1", [19, 20, 21, 22, 23, 24], 3);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-ass1", [67, 68, 69, 70, 71, 72], 3);
			}
			else
			{
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.ass, "dildo-ass1", [12, 13, 14, 15, 16, 17, 18], 3);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow.dildo, "dildo-ass1", [16, 17, 18, 19, 20, 21, 22], 3);
				refreshed = dildoUtils.refreshDildoAnim(toyWindow._interact, "dildo-ass1", [42, 43, 44, 45, 46, 47, 48], 3);
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
			ambientDildoBankTimer += 1.9;
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
				if (amount > 0
						&& !toyInterface.ass
						&& _rubHandAnim._flxSprite.animation.name == "rub-vag"
						&& toyInterface.animPct < 0.5
						&& badToyBank > _toyBank._defaultForeplayHeartReservoir * 0.2)
				{
					// rubbing the right spot; need to rub it faster
					insufficientClitRubCount--;
					if (insufficientClitRubCount <= 0 && toyClitWords.timer <= 0)
					{
						insufficientClitRubCount = FlxG.random.int(3, 8);
						maybeEmitWords(toyClitWords);
					}
				}
				if (amount == 0)
				{
					// going too fast; bank isn't having a chance to fill up.
					if (!toyInterface.ass && _rubHandAnim._flxSprite.animation.name == "rub-vag")
					{
						// rubbing the vagina fast is OK, she likes it
						if (toyInterface.animPct < 0.5)
						{
							// rubbing the clit fast is super nice, and reimburses 85% of the badToyBank, which is good
							if (badToyBank > _toyBank._defaultForeplayHeartReservoir * 0.2)
							{
								maybeEmitWords(pleasureWords);
							}

							emitHearts(SexyState.roundUpToQuarter(badToyBank * 0.3));
							_toyBank._dickHeartReservoir += SexyState.roundDownToQuarter(badToyBank * 0.55);
							badToyBank = 0;
						}
						else
						{
							// rubbing the entire vagina fast is OK; no penalty but no reward
						}
					}
					else if (toyWindow.isXlDildo() && !isXlDildoFittingEasily() && StringTools.startsWith(_rubHandAnim._flxSprite.animation.name, "dildo-"))
					{
						// don't worry about a penalty; dildo is too big anyway
					}
					else
					{
						var penaltyAmount:Float = SexyState.roundUpToQuarter(lucky(0.01, 0.02) * _toyBank._dickHeartReservoir);
						if (_heartEmitCount > -penaltyAmount * 2)
						{
							_heartEmitCount -= penaltyAmount;
							badToyBank += penaltyAmount;
						}

						if (_toyBank._foreplayHeartReservoir > penaltyAmount)
						{
							_toyBank._foreplayHeartReservoir -= penaltyAmount;
							badToyBank += penaltyAmount;
						}
						else if (_heartBank._foreplayHeartReservoir > penaltyAmount && _heartBank.getForeplayPercent() >= 0.4)
						{
							_heartBank._foreplayHeartReservoir -= penaltyAmount;
							badToyBank += penaltyAmount;
						}
						else if (_heartBank._dickHeartReservoir > penaltyAmount)
						{
							_heartBank._dickHeartReservoir -= penaltyAmount;
							badToyBank += penaltyAmount;
						}
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

				if (toyWindow.isXlDildo() && !isXlDildoFittingEasily() && (toyStr == "2" || toyStr == "3"))
				{
					// huge dildo; can't really enjoy it
					toyStr += "xl";
				}
				else if (toyStr != null && remainingToyPattern.length > 0)
				{
					if (remainingToyPattern[0] == toyStr)
					{
						if (toyOnTrack == false)
						{
							toyOnTrack = true;
						}

						fillPleasurableDildoBank();

						var pleasurableDildoAmount:Float = SexyState.roundUpToQuarter(lucky(0.1, 0.2) * pleasurableDildoBank);
						amount += pleasurableDildoAmount;
						pleasurableDildoBank -= pleasurableDildoAmount;
						remainingToyPattern.splice(0, 1);
					}
					else if (toyStr == previousToyStr)
					{
						if (!toyOnTrack)
						{
							var penaltyAmount:Float = SexyState.roundUpToQuarter(lucky(0.01, 0.02) * _toyBank._dickHeartReservoir);
							_toyBank._dickHeartReservoir -= penaltyAmount;
							badToyBank += penaltyAmount;

							if (!toyInterface.ass && toyStr != "0")
							{
								// if the player messes up while penetrating the vagina, it can eventually cause an orgasm
								_heartBank._dickHeartReservoirCapacity += SexyState.roundUpToQuarter(lucky(0.00, 0.01) * _heartBank._defaultDickHeartReservoir);
							}
						}

						var pleasurableDildoAmount:Float = SexyState.roundUpToQuarter(lucky(0.1, 0.2) * pleasurableDildoBank);
						amount += pleasurableDildoAmount;
						pleasurableDildoBank -= pleasurableDildoAmount;
					}
					else
					{
						var penaltyAmount:Float = SexyState.roundUpToQuarter(lucky(0.15, 0.25) * _toyBank._dickHeartReservoir);
						_toyBank._dickHeartReservoir -= penaltyAmount;
						badToyBank += penaltyAmount;

						if (!toyInterface.ass && toyStr != "0")
						{
							// if the player messes up while penetrating the vagina, it can eventually cause an orgasm
							_heartBank._dickHeartReservoirCapacity += SexyState.roundUpToQuarter(lucky(0.00, 0.01) * _heartBank._defaultDickHeartReservoir);
						}

						if (toyOnTrack)
						{
							toyOnTrack = false;
						}
						remainingToyPattern = toyPattern.copy();
						// backtrack by 1
						remainingToyPattern.splice(0, Std.int(Math.max(0, remainingToyPattern.length - shortestToyPatternLength - 1)));
						toyMessUpCount++;
					}

					if (shortestToyPatternLength > remainingToyPattern.length)
					{
						shortestToyPatternLength = remainingToyPattern.length;

						_heartBank._foreplayHeartReservoirCapacity += SexyState.roundUpToQuarter(_heartBank._defaultForeplayHeartReservoir * 0.12);
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

						if (toyMessUpCount <= 3 && (!toyInterface.ass || computeBonusCapacity() >= 30))
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

				if (toyStr == "2xl" || toyStr == "3xl")
				{
					// delay refills, and avoid dispensing very many hearts
					ambientDildoBankTimer = Math.max(1.9, ambientDildoBankTimer + 0.6);
					if (isXlDildoFitting())
					{
						amount = Math.min(amount, FlxG.random.getObject([0.50, 0.75, 1.00, 1.25]));
					}
					else
					{
						amount = Math.min(amount, FlxG.random.getObject([0.25, 0.25, 0.50, 0.75]));
					}
					toyOnTrack = amount > 0;
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

	function fillAmbientDildoBank()
	{
		if (ambientDildoBank < ambientDildoBankCapacity)
		{
			var amount:Float = 1000;
			amount = Math.min(amount, _toyBank._foreplayHeartReservoir);
			amount = Math.min(amount, ambientDildoBankCapacity - ambientDildoBank);
			if (amount > 0)
			{
				_toyBank._foreplayHeartReservoir -= amount;
				ambientDildoBank += amount;
			}
		}
		if (ambientDildoBank < ambientDildoBankCapacity)
		{
			var amount:Float = 1000;
			if (toyInterface.ass)
			{
				if (addToyHeartsToOrgasm && toyMessUpCount <= 3)
				{
					// perfect run; okay, lucario can cum from rubbing ass
				}
				else
				{
					// foreplayHeartReservoir decays slowly when rubbing ass
					amount = SexyState.roundUpToQuarter(_heartBank._foreplayHeartReservoir * 0.05);
				}
			}
			else if (_heartBank.getForeplayPercent() < 0.4)
			{
				// foreplayHeartReservoir exhausted
				amount = 0;
			}
			amount = Math.min(amount, ambientDildoBankCapacity - ambientDildoBank);
			amount = Math.min(amount, _heartBank._foreplayHeartReservoir);
			if (amount > 0)
			{
				_heartBank._foreplayHeartReservoir -= amount;
				ambientDildoBank += amount;
			}
		}
		if (ambientDildoBank < ambientDildoBankCapacity)
		{
			var amount:Float = 1000;
			if (toyInterface.ass)
			{
				if (addToyHeartsToOrgasm && toyMessUpCount <= 3)
				{
					// perfect run; okay, lucario can cum from rubbing ass
				}
				else
				{
					// dickHeartReservoir doesn't deplete when rubbing ass
					amount = 0;
				}
			}
			if (toyWindow.isXlDildo() && !isXlDildoFitting())
			{
				// dickHeartReservoir doesn't deplete with xl dildo
				amount = 0;
			}
			amount = Math.min(amount, _heartBank._dickHeartReservoir);
			amount = Math.min(amount, ambientDildoBankCapacity - ambientDildoBank);
			if (amount > 0)
			{
				_heartBank._dickHeartReservoir -= amount;
				ambientDildoBank += amount;
			}
		}
	}

	function fillPleasurableDildoBank()
	{
		if (pleasurableDildoBank < pleasurableDildoBankCapacity)
		{
			var missingAmount:Float = pleasurableDildoBankCapacity - pleasurableDildoBank;
			if (_toyBank._foreplayHeartReservoir > 0)
			{
				var amount:Float = 1000;
				amount = Math.min(amount, _toyBank._foreplayHeartReservoir);
				amount = Math.min(amount, SexyState.roundDownToQuarter(missingAmount * 0.5));
				if (amount > 0)
				{
					_toyBank._foreplayHeartReservoir -= amount;
					pleasurableDildoBank += amount;
				}
			}
			if (_toyBank._dickHeartReservoir > 0)
			{
				var amount:Float = 1000;
				amount = Math.min(amount, _toyBank._dickHeartReservoir);
				amount = Math.min(amount, SexyState.roundUpToQuarter(missingAmount * 0.5));
				if (amount > 0)
				{
					_toyBank._dickHeartReservoir -= amount;
					pleasurableDildoBank += amount;
				}
			}
		}
		if (pleasurableDildoBank < pleasurableDildoBankCapacity)
		{
			var amount:Float = 1000;
			if (toyInterface.ass)
			{
				if (addToyHeartsToOrgasm && toyMessUpCount <= 3)
				{
					// perfect run; okay, lucario can cum from rubbing ass
				}
				else
				{
					// foreplayHeartReservoir decays slowly when rubbing ass
					amount = SexyState.roundUpToQuarter(_heartBank._foreplayHeartReservoir * 0.05);
				}
			}
			else if (_heartBank.getForeplayPercent() < 0.4)
			{
				// foreplayHeartReservoir exhausted
				amount = 0;
			}
			amount = Math.min(amount, _heartBank._foreplayHeartReservoir);
			amount = Math.min(amount, pleasurableDildoBankCapacity - pleasurableDildoBank);
			if (amount > 0)
			{
				_heartBank._foreplayHeartReservoir -= amount;
				pleasurableDildoBank += amount;
			}
		}
		if (pleasurableDildoBank < pleasurableDildoBankCapacity)
		{
			var amount:Float = 1000;
			if (toyInterface.ass)
			{
				if (addToyHeartsToOrgasm && toyMessUpCount <= 3)
				{
					// perfect run; okay, lucario can cum from rubbing ass
				}
				else
				{
					// dickHeartReservoir doesn't deplete when rubbing ass
					amount = 0;
				}
			}
			if (toyWindow.isXlDildo() && !isXlDildoFitting())
			{
				// dickHeartReservoir doesn't deplete with xl dildo
				amount = 0;
			}
			amount = Math.min(amount, _heartBank._dickHeartReservoir);
			amount = Math.min(amount, pleasurableDildoBankCapacity - pleasurableDildoBank);
			if (amount > 0)
			{
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
			maybeScheduleBreath();
			if (addToyHeartsToOrgasm && _autoSweatRate < 0.4)
			{
				_autoSweatRate += 0.07;
			}
		}
		maybeEmitToyWordsAndStuff();
	}

	override public function sexyStuff(elapsed:Float):Void
	{
		super.sexyStuff(elapsed);

		if (_gameState == 200 && _male && fancyRubbing(_dick) && _rubBodyAnim.nearMinFrame())
		{
			if (pastBonerThreshold())
			{
				// switch to boner-rubbing animation?
				if (_rubBodyAnim._flxSprite.animation.name == "rub-dick"
				|| _rubBodyAnim._flxSprite.animation.name == "rub-sheath0"
				|| _rubBodyAnim._flxSprite.animation.name == "rub-sheath1")
				{
					_rubBodyAnim.setAnimName("jack-off");
					_rubHandAnim.setAnimName("jack-off");
				}
			}
			else if (_heartBank.getForeplayPercent() < 0.70)
			{
				// switch to dick rubbing animation?
				if (_rubBodyAnim._flxSprite.animation.name == "rub-sheath0"
						|| _rubBodyAnim._flxSprite.animation.name == "rub-sheath1")
				{
					_rubBodyAnim.setAnimName("rub-dick");
					_rubHandAnim.setAnimName("rub-dick");
				}
			}
		}

		if (fancyRubbing(_pokeWindow.feet) && _armsAndLegsArranger._armsAndLegsTimer < 1.5)
		{
			_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(1.5, 3);
		}

		if (_male && fancyRubbing(_dick) && _gameState == 200)
		{
			if (_heartBank.getForeplayPercent() < 0.70 && (_rubBodyAnim._flxSprite.animation.name == "rub-sheath0" || _rubBodyAnim._flxSprite.animation.name == "rub-sheath1") && _rubBodyAnim.nearMinFrame())
			{
				_rubBodyAnim.setAnimName("rub-dick");
				_rubHandAnim.setAnimName("rub-dick");
			}
			if (pastBonerThreshold() && _rubBodyAnim._flxSprite.animation.name == "rub-dick" && _rubBodyAnim.nearMinFrame())
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

	override public function determineArousal():Int
	{
		var result:Int = 0;
		if (displayingToyWindow())
		{
			if (_heartBank.getDickPercent() < 0.66)
			{
				result = 4;
			}
			else if (_heartBank.getDickPercent() < 0.77)
			{
				result = 3;
				if (toyWindow._arousal < 3)
				{
					toyWindow._arousal = 3;
				}
			}
			else if (super.pastBonerThreshold())
			{
				result = 1;
			}
			else if (_heartBank._foreplayHeartReservoir < _heartBank._foreplayHeartReservoirCapacity)
			{
				result = 1;
			}
			else
			{
				result = 0;
			}
			if (toyOnTrack)
			{
				if (addToyHeartsToOrgasm)
				{
					// already found the secret
					if (toyWindow._arousal < 2)
					{
						toyWindow._arousal = 2;
						result = 2;
					}
					else
					{
						result = Std.int(FlxMath.bound(result + 1, 0, 4));
					}
				}
				else
				{
					// force immediate arousal
					toyWindow._arousal = 2;
					result = 2;
				}
			}
		}
		else {
			if (_heartBank.getDickPercent() < 0.66)
			{
				result = 4;
			}
			else if (_heartBank.getDickPercent() < 0.77)
			{
				result = 3;
			}
			else if (_heartBank.getDickPercent() < 0.88)
			{
				result = 2;
			}
			else if (super.pastBonerThreshold())
			{
				result = 1;
			}
			else if (_heartBank._foreplayHeartReservoir < _heartBank._foreplayHeartReservoirCapacity)
			{
				result = 1;
			}
			else {
				result = 0;
			}
			if (niceSpecialSpotFace && result < 2)
			{
				// force immediate arousal
				_pokeWindow._arousal = 2;
				result = 2;
			}
		}
		return result;
	}

	override public function checkSpecialRub(touchedPart:FlxSprite)
	{
		if (_fancyRub)
		{
			if (_rubHandAnim._flxSprite.animation.name == "finger-ass")
			{
				specialRub = "ass";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "jack-off")
			{
				specialRub = "jack-off";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-dick"
					 || _rubHandAnim._flxSprite.animation.name == "rub-sheath0"
					 || _rubHandAnim._flxSprite.animation.name == "rub-sheath1")
			{
				specialRub = "rub-dick";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-balls")
			{
				specialRub = "balls";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-left-foot")
			{
				specialRub = "left-foot";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-right-foot")
			{
				specialRub = "right-foot";
			}
			else if (_rubHandAnim._flxSprite.animation.name == "rub-spike")
			{
				specialRub = "spike";
			}
		}
		else
		{
			if (touchedPart == _pokeWindow.legs)
			{
				if (clickedPolygon(touchedPart, leftCalfPolyArray))
				{
					specialRub = "left-calf";
				}
				else if (clickedPolygon(touchedPart, rightCalfPolyArray))
				{
					specialRub = "right-calf";
				}
				else if (clickedPolygon(touchedPart, leftThighPolyArray))
				{
					specialRub = "left-thigh";
				}
				else if (clickedPolygon(touchedPart, rightThighPolyArray))
				{
					specialRub = "right-thigh";
				}
			}
			else if (touchedPart == _pokeWindow.feet)
			{
				// user clicked calf, but held it too long
				if (_pokeWindow.feet.animation.name == "raise-left-leg")
				{
					specialRub = "left-calf";
				}
				else
				{
					specialRub = "right-calf";
				}
			}
			else if (touchedPart == _pokeWindow.torso1 || touchedPart == _pokeWindow.neck)
			{
				specialRub = "chest";
			}
			else if (touchedPart == _pokeWindow.torso0)
			{
				specialRub = "belly";
			}
			else if (touchedPart == _pokeWindow._head || touchedPart == _pokeWindow.hair)
			{
				specialRub = "head";
			}
			else if (touchedPart == _pokeWindow.armsDown)
			{
				if (clickedPolygon(_pokeWindow.armsDown, leftShoulderDownPolyArray))
				{
					specialRub = "left-shoulder";
				}
				else if (clickedPolygon(_pokeWindow.armsDown, rightShoulderDownPolyArray))
				{
					specialRub = "right-shoulder";
				}
			}
			else if (touchedPart == _pokeWindow.armsUp)
			{
				if (clickedPolygon(_pokeWindow.armsUp, leftShoulderUpPolyArray))
				{
					specialRub = "left-shoulder";
				}
				else if (clickedPolygon(_pokeWindow.armsUp, rightShoulderUpPolyArray))
				{
					specialRub = "right-shoulder";
				}
			}
			else if (touchedPart == _pokeWindow.tail || touchedPart == _pokeWindow.butt && clickedPolygon(_pokeWindow.butt, tailPolyArray))
			{
				specialRub = "tail";
			}
		}
	}

	override public function touchPart(touchedPart:FlxSprite):Bool
	{
		if (FlxG.mouse.justPressed && (touchedPart == _dick
		|| (!_male
		&& (touchedPart == _pokeWindow.butt || touchedPart == _pokeWindow.pubicFuzz)
		&& clickedPolygon(_pokeWindow.butt, vagPolyArray)))
		   )
		{
			if (_male)
			{
				if (_dick.animation.name == "boner3")
				{
					// hard
					interactOn(_dick, "jack-off");
					return true;
				}
				else if (_dick.animation.name == "boner1" || _dick.animation.name == "boner2")
				{
					// semihard
					interactOn(_dick, "rub-dick");
					return true;
				}
				else
				{
					// flaccid
					interactOn(_dick, "rub-sheath0");
					_rubBodyAnim.addAnimName("rub-sheath1");
					_rubHandAnim.addAnimName("rub-sheath1");
					return true;
				}
			}
			else
			{
				if (pastBonerThreshold())
				{
					updateVaginaFingeringAnimation();
					interactOn(_dick, "jack-off");
					return true;
				}
				else
				{
					interactOn(_dick, "rub-dick");
					return true;
				}
			}
		}
		if (FlxG.mouse.justPressed && touchedPart == _pokeWindow.balls)
		{
			interactOn(_pokeWindow.balls, "rub-balls");
			return true;
		}
		if (FlxG.mouse.justPressed && (touchedPart == _pokeWindow.ass || touchedPart == _pokeWindow.butt && clickedPolygon(_pokeWindow.butt, assPolyArray)))
		{
			updateAssFingeringAnimation();
			interactOn(_pokeWindow.ass, "finger-ass");
			return true;
		}
		if (FlxG.mouse.justPressed && (touchedPart == _pokeWindow.feet))
		{
			if (_pokeWindow.feet.animation.name == "raise-left-leg")
			{
				interactOn(_pokeWindow.feet, "rub-left-foot");
				return true;
			}
			else
			{
				interactOn(_pokeWindow.feet, "rub-right-foot");
				return true;
			}
		}
		if (FlxG.mouse.justPressed && clickedPolygon(_pokeWindow.torso1, chestSpikePolyArray))
		{
			interactOn(_pokeWindow.torso1, "rub-spike", "default");
			_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.members.indexOf(_pokeWindow.neck) + 1);
			return true;
		}
		if (touchedPart == _pokeWindow.legs && _clickedDuration > 1.5)
		{
			if (clickedPolygon(touchedPart, rightCalfPolyArray))
			{
				// raise right leg
				_pokeWindow.legs.animation.play("raise-right-leg");
				_pokeWindow.feet.animation.play("raise-right-leg");
				_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(4, 6);
			}
			else if (clickedPolygon(touchedPart, leftCalfPolyArray))
			{
				// raise right leg
				_pokeWindow.legs.animation.play("raise-left-leg");
				_pokeWindow.feet.animation.play("raise-left-leg");
				_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(4, 6);
			}
		}
		if (touchedPart == _pokeWindow.feet && _clickedDuration > 1.5)
		{
			// user clicked calf, but held it too long
			_armsAndLegsArranger._armsAndLegsTimer = FlxG.random.float(4, 6);
		}
		return false;
	}

	function setInactiveDickAnimation():Void
	{
		if (PlayerData.lucaMale)
		{
			if (_gameState >= 400)
			{
				if (_dick.animation.name != "finished")
				{
					if (_dick.animation.name == "boner3")
					{
						_dick.animation.add("finished", [3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 1, 1, 1, 0], 3, false);
					}
					else if (_dick.animation.name == "boner2")
					{
						_dick.animation.add("finished", [2, 2, 2, 2, 2, 1, 1, 1, 0], 3, false);
					}
					else
					{
						_dick.animation.add("finished", [1, 1, 1, 0], 3, false);
					}
					_dick.animation.play("finished");
				}
			}
			else if (pastBonerThreshold())
			{
				if (_dick.animation.name != "boner3")
				{
					_dick.animation.play("boner3");
				}
			}
			else if (_heartBank.getForeplayPercent() < 0.55)
			{
				if (_dick.animation.name != "boner2")
				{
					_dick.animation.play("boner2");
				}
			}
			else if (_heartBank.getForeplayPercent() < 0.70)
			{
				if (_dick.animation.name != "boner1")
				{
					_dick.animation.play("boner1");
				}
			}
			else if (_heartBank.getForeplayPercent() < 0.85)
			{
				if (_dick.animation.name != "boner0")
				{
					_dick.animation.play("boner0");
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

	override public function untouchPart(touchedPart:FlxSprite):Void
	{
		super.untouchPart(touchedPart);
		if (touchedPart == _pokeWindow.feet)
		{
			_pokeWindow.feet.animation.play(_pokeWindow.legs.animation.name);
		}
	}

	override public function initializeHitBoxes():Void
	{
		super.initializeHitBoxes();

		if (displayingToyWindow())
		{
			if (_male)
			{
				dickAngleArray[0] = [new FlxPoint(172, 213), new FlxPoint(152, 211), new FlxPoint(-148, 214)];
				dickAngleArray[1] = [new FlxPoint(174, 237), new FlxPoint(60, 253), new FlxPoint(-44, 256)];
				dickAngleArray[2] = [new FlxPoint(172, 247), new FlxPoint(26, 259), new FlxPoint(-13, 260)];
				dickAngleArray[3] = [new FlxPoint(174, 264), new FlxPoint(25, 259), new FlxPoint(0, 260)];
				dickAngleArray[4] = [new FlxPoint(174, 281), new FlxPoint(25, 259), new FlxPoint(-12, 260)];
			}
			else
			{
				dickAngleArray[0] = [new FlxPoint(174, 194), new FlxPoint(140, 219), new FlxPoint(-136, 221)];
				dickAngleArray[1] = [new FlxPoint(174, 191), new FlxPoint(201, 165), new FlxPoint(-220, 139)];
				dickAngleArray[2] = [new FlxPoint(174, 191), new FlxPoint(226, 128), new FlxPoint(-224, 133)];
				dickAngleArray[3] = [new FlxPoint(174, 191), new FlxPoint(239, 102), new FlxPoint(-237, 107)];
				dickAngleArray[4] = [new FlxPoint(174, 191), new FlxPoint(249, 76), new FlxPoint(-246, 84)];
				dickAngleArray[5] = [new FlxPoint(174, 191), new FlxPoint(249, 76), new FlxPoint(-246, 84)];
				dickAngleArray[6] = [new FlxPoint(174, 191), new FlxPoint(249, 76), new FlxPoint(-246, 84)];
				dickAngleArray[7] = [new FlxPoint(174, 191), new FlxPoint(249, 76), new FlxPoint(-246, 84)];
				dickAngleArray[8] = [new FlxPoint(174, 191), new FlxPoint(250, 72), new FlxPoint(-251, 67)];
				dickAngleArray[9] = [new FlxPoint(174, 191), new FlxPoint(250, 72), new FlxPoint(-251, 67)];
				dickAngleArray[10] = [new FlxPoint(174, 199), new FlxPoint(243, 91), new FlxPoint(-249, 75)];
				dickAngleArray[11] = [new FlxPoint(174, 199), new FlxPoint(212, 151), new FlxPoint(-227, 127)];
				dickAngleArray[12] = [new FlxPoint(174, 199), new FlxPoint(169, 197), new FlxPoint(-177, 191)];
				dickAngleArray[13] = [new FlxPoint(174, 190), new FlxPoint(156, 208), new FlxPoint(-171, 196)];
				dickAngleArray[14] = [new FlxPoint(174, 190), new FlxPoint(165, 201), new FlxPoint(-156, 208)];
				dickAngleArray[15] = [new FlxPoint(174, 185), new FlxPoint(162, 203), new FlxPoint(-153, 210)];
				dickAngleArray[16] = [new FlxPoint(174, 180), new FlxPoint(169, 197), new FlxPoint(-158, 207)];
				dickAngleArray[17] = [new FlxPoint(174, 189), new FlxPoint(168, 198), new FlxPoint(-134, 223)];
				dickAngleArray[18] = [new FlxPoint(174, 191), new FlxPoint(159, 206), new FlxPoint(-148, 214)];
				dickAngleArray[19] = [new FlxPoint(174, 190), new FlxPoint(214, 147), new FlxPoint(-209, 154)];
				dickAngleArray[20] = [new FlxPoint(174, 191), new FlxPoint(230, 122), new FlxPoint(-190, 178)];
				dickAngleArray[21] = [new FlxPoint(174, 194), new FlxPoint(249, 76), new FlxPoint(-191, 177)];
				dickAngleArray[22] = [new FlxPoint(174, 193), new FlxPoint(176, 192), new FlxPoint(-141, 219)];
				dickAngleArray[23] = [new FlxPoint(174, 194), new FlxPoint(148, 214), new FlxPoint(-134, 223)];
				dickAngleArray[24] = [new FlxPoint(174, 197), new FlxPoint(148, 214), new FlxPoint( -161, 204)];
				dickAngleArray[25] = [new FlxPoint(174, 197), new FlxPoint(148, 214), new FlxPoint( -161, 204)];
				dickAngleArray[26] = [new FlxPoint(174, 191), new FlxPoint(250, 72), new FlxPoint(-251, 67)];
				dickAngleArray[27] = [new FlxPoint(174, 191), new FlxPoint(250, 72), new FlxPoint(-251, 67)];
			}

			breathAngleArray[0] = [new FlxPoint(171, 60), new FlxPoint(0, -80)];
			breathAngleArray[1] = [new FlxPoint(171, 60), new FlxPoint(0, -80)];
			breathAngleArray[2] = [new FlxPoint(171, 60), new FlxPoint(0, -80)];
			breathAngleArray[3] = [new FlxPoint(173, 58), new FlxPoint(5, -80)];
			breathAngleArray[4] = [new FlxPoint(173, 58), new FlxPoint(5, -80)];
			breathAngleArray[5] = [new FlxPoint(173, 58), new FlxPoint(5, -80)];
			breathAngleArray[6] = [new FlxPoint(171, 58), new FlxPoint(0, -80)];
			breathAngleArray[7] = [new FlxPoint(171, 58), new FlxPoint(0, -80)];
			breathAngleArray[8] = [new FlxPoint(171, 58), new FlxPoint(0, -80)];
			breathAngleArray[9] = [new FlxPoint(173, 52), new FlxPoint(0, -80)];
			breathAngleArray[10] = [new FlxPoint(173, 52), new FlxPoint(0, -80)];
			breathAngleArray[11] = [new FlxPoint(173, 52), new FlxPoint(0, -80)];
			breathAngleArray[12] = [new FlxPoint(171, 47), new FlxPoint(0, -80)];
			breathAngleArray[13] = [new FlxPoint(171, 47), new FlxPoint(0, -80)];
			breathAngleArray[14] = [new FlxPoint(171, 47), new FlxPoint(0, -80)];
			breathAngleArray[15] = [new FlxPoint(171, 25), new FlxPoint(4, -80)];
			breathAngleArray[16] = [new FlxPoint(171, 25), new FlxPoint(4, -80)];
			breathAngleArray[17] = [new FlxPoint(171, 25), new FlxPoint(4, -80)];

			var headSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			headSweatArray[0] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[1] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[2] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[3] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[4] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[5] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[6] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[7] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[8] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[9] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[10] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[11] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[12] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[13] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[14] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[15] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[16] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];
			headSweatArray[17] = [new FlxPoint(200, 146), new FlxPoint(149, 144), new FlxPoint(163, 107), new FlxPoint(190, 108)];

			var torsoSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			torsoSweatArray[0] = [new FlxPoint(209, 323), new FlxPoint(140, 323), new FlxPoint(133, 279), new FlxPoint(149, 207), new FlxPoint(141, 138), new FlxPoint(205, 136), new FlxPoint(200, 210), new FlxPoint(218, 270)];

			sweatAreas.splice(0, sweatAreas.length);
			sweatAreas.push({chance:4, sprite:toyWindow._head, sweatArrayArray:headSweatArray});
			sweatAreas.push({chance:6, sprite:toyWindow.torso1, sweatArrayArray:torsoSweatArray});
		}
		else {
			if (_male)
			{
				dickAngleArray[0] = [new FlxPoint(172, 344), new FlxPoint(191, -177), new FlxPoint(-211, -152)];
				dickAngleArray[1] = [new FlxPoint(173, 336), new FlxPoint(73, -249), new FlxPoint(-94, -242)];
				dickAngleArray[2] = [new FlxPoint(172, 323), new FlxPoint(32, -258), new FlxPoint(-45, -256)];
				dickAngleArray[3] = [new FlxPoint(174, 297), new FlxPoint(31, -258), new FlxPoint(-25, -259)];
				dickAngleArray[4] = [new FlxPoint(174, 273), new FlxPoint(24, -259), new FlxPoint(-14, -260)];
				dickAngleArray[5] = [new FlxPoint(165, 343), new FlxPoint(-147, -214), new FlxPoint(-247, -82)];
				dickAngleArray[6] = [new FlxPoint(166, 341), new FlxPoint(-82, -247), new FlxPoint(-208, -156)];
				dickAngleArray[7] = [new FlxPoint(170, 339), new FlxPoint(0, -260), new FlxPoint(-147, -215)];
				dickAngleArray[8] = [new FlxPoint(174, 339), new FlxPoint(86, -245), new FlxPoint(-49, -255)];
				dickAngleArray[9] = [new FlxPoint(179, 341), new FlxPoint(208, -156), new FlxPoint(116, -233)];
				dickAngleArray[10] = [new FlxPoint(182, 342), new FlxPoint(244, -90), new FlxPoint(141, -218)];
				dickAngleArray[11] = [new FlxPoint(183, 344), new FlxPoint(246, -85), new FlxPoint(161, -204)];
				dickAngleArray[12] = [new FlxPoint(174, 312), new FlxPoint(56, -254), new FlxPoint(-47, -256)];
				dickAngleArray[13] = [new FlxPoint(174, 309), new FlxPoint(41, -257), new FlxPoint(-43, -256)];
				dickAngleArray[14] = [new FlxPoint(173, 305), new FlxPoint(32, -258), new FlxPoint(-48, -256)];
				dickAngleArray[15] = [new FlxPoint(174, 303), new FlxPoint(41, -257), new FlxPoint(-32, -258)];
				dickAngleArray[16] = [new FlxPoint(173, 275), new FlxPoint(28, -258), new FlxPoint(-23, -259)];
				dickAngleArray[17] = [new FlxPoint(173, 275), new FlxPoint(29, -258), new FlxPoint(-29, -258)];
				dickAngleArray[18] = [new FlxPoint(173, 275), new FlxPoint(29, -258), new FlxPoint(-29, -258)];
				dickAngleArray[19] = [new FlxPoint(173, 275), new FlxPoint(29, -258), new FlxPoint(-29, -258)];
				dickAngleArray[20] = [new FlxPoint(173, 275), new FlxPoint(29, -258), new FlxPoint(-29, -258)];
				dickAngleArray[21] = [new FlxPoint(173, 275), new FlxPoint(29, -258), new FlxPoint( -29, -258)];
			}
			else {
				dickAngleArray[0] = [new FlxPoint(174, 387), new FlxPoint(135, 222), new FlxPoint(-140, 219)];
				dickAngleArray[1] = [new FlxPoint(174, 386), new FlxPoint(179, 189), new FlxPoint(-188, 179)];
				dickAngleArray[2] = [new FlxPoint(174, 383), new FlxPoint(202, 163), new FlxPoint(-220, 139)];
				dickAngleArray[3] = [new FlxPoint(174, 383), new FlxPoint(221, 137), new FlxPoint(-220, 138)];
				dickAngleArray[4] = [new FlxPoint(174, 383), new FlxPoint(228, 126), new FlxPoint(-228, 126)];
				dickAngleArray[5] = [new FlxPoint(174, 383), new FlxPoint(237, 108), new FlxPoint(-235, 112)];
				dickAngleArray[6] = [new FlxPoint(174, 383), new FlxPoint(236, 108), new FlxPoint(-237, 108)];
				dickAngleArray[7] = [new FlxPoint(174, 383), new FlxPoint(238, 105), new FlxPoint(-241, 98)];
				dickAngleArray[8] = [new FlxPoint(174, 383), new FlxPoint(240, 100), new FlxPoint(-242, 94)];
				dickAngleArray[9] = [new FlxPoint(174, 388), new FlxPoint(221, 136), new FlxPoint(-226, 128)];
				dickAngleArray[10] = [new FlxPoint(174, 388), new FlxPoint(201, 165), new FlxPoint(-214, 148)];
				dickAngleArray[11] = [new FlxPoint(174, 388), new FlxPoint(148, 213), new FlxPoint(-160, 205)];
				dickAngleArray[12] = [new FlxPoint(174, 388), new FlxPoint(106, 238), new FlxPoint(-120, 231)];
				dickAngleArray[13] = [new FlxPoint(174, 388), new FlxPoint(67, 251), new FlxPoint(-80, 247)];
			}

			breathAngleArray[0] = [new FlxPoint(176, 183), new FlxPoint(16, 78)];
			breathAngleArray[1] = [new FlxPoint(176, 183), new FlxPoint(16, 78)];
			breathAngleArray[2] = [new FlxPoint(176, 183), new FlxPoint(16, 78)];
			breathAngleArray[3] = [new FlxPoint(214, 196), new FlxPoint(63, 49)];
			breathAngleArray[4] = [new FlxPoint(214, 196), new FlxPoint(63, 49)];
			breathAngleArray[5] = [new FlxPoint(214, 196), new FlxPoint(63, 49)];
			breathAngleArray[6] = [new FlxPoint(122, 159), new FlxPoint(-75, -27)];
			breathAngleArray[7] = [new FlxPoint(122, 159), new FlxPoint(-75, -27)];
			breathAngleArray[8] = [new FlxPoint(122, 159), new FlxPoint(-75, -27)];
			breathAngleArray[12] = [new FlxPoint(144, 204), new FlxPoint(-54, 59)];
			breathAngleArray[13] = [new FlxPoint(144, 204), new FlxPoint(-54, 59)];
			breathAngleArray[14] = [new FlxPoint(144, 204), new FlxPoint(-54, 59)];
			breathAngleArray[15] = [new FlxPoint(182, 208), new FlxPoint(19, 78)];
			breathAngleArray[16] = [new FlxPoint(182, 208), new FlxPoint(19, 78)];
			breathAngleArray[17] = [new FlxPoint(182, 208), new FlxPoint(19, 78)];
			breathAngleArray[18] = [new FlxPoint(180, 242), new FlxPoint(3, 80)];
			breathAngleArray[19] = [new FlxPoint(180, 242), new FlxPoint(3, 80)];
			breathAngleArray[20] = [new FlxPoint(180, 242), new FlxPoint(3, 80)];
			breathAngleArray[24] = [new FlxPoint(232, 150), new FlxPoint(74, -32)];
			breathAngleArray[25] = [new FlxPoint(232, 150), new FlxPoint(74, -32)];
			breathAngleArray[26] = [new FlxPoint(232, 150), new FlxPoint(74, -32)];
			breathAngleArray[27] = [new FlxPoint(178, 242), new FlxPoint(0, 80)];
			breathAngleArray[28] = [new FlxPoint(178, 242), new FlxPoint(0, 80)];
			breathAngleArray[29] = [new FlxPoint(178, 242), new FlxPoint(0, 80)];
			breathAngleArray[30] = [new FlxPoint(104, 177), new FlxPoint(-80, 3)];
			breathAngleArray[31] = [new FlxPoint(104, 177), new FlxPoint(-80, 3)];
			breathAngleArray[32] = [new FlxPoint(104, 177), new FlxPoint(-80, 3)];
			breathAngleArray[36] = [new FlxPoint(252, 180), new FlxPoint(80, 7)];
			breathAngleArray[37] = [new FlxPoint(252, 180), new FlxPoint(80, 7)];
			breathAngleArray[38] = [new FlxPoint(252, 180), new FlxPoint(80, 7)];
			breathAngleArray[39] = [new FlxPoint(178, 236), new FlxPoint(0, 80)];
			breathAngleArray[40] = [new FlxPoint(178, 236), new FlxPoint(0, 80)];
			breathAngleArray[41] = [new FlxPoint(178, 236), new FlxPoint(0, 80)];
			breathAngleArray[42] = [new FlxPoint(216, 198), new FlxPoint(69, 40)];
			breathAngleArray[43] = [new FlxPoint(216, 198), new FlxPoint(69, 40)];
			breathAngleArray[44] = [new FlxPoint(216, 198), new FlxPoint(69, 40)];
			breathAngleArray[48] = [new FlxPoint(178, 235), new FlxPoint(0, 80)];
			breathAngleArray[49] = [new FlxPoint(178, 235), new FlxPoint(0, 80)];
			breathAngleArray[50] = [new FlxPoint(178, 235), new FlxPoint(0, 80)];
			breathAngleArray[51] = [new FlxPoint(136, 198), new FlxPoint(-64, 48)];
			breathAngleArray[52] = [new FlxPoint(136, 198), new FlxPoint(-64, 48)];
			breathAngleArray[53] = [new FlxPoint(136, 198), new FlxPoint(-64, 48)];
			breathAngleArray[54] = [new FlxPoint(188, 206), new FlxPoint(27, 75)];
			breathAngleArray[55] = [new FlxPoint(188, 206), new FlxPoint(27, 75)];
			breathAngleArray[56] = [new FlxPoint(188, 206), new FlxPoint(27, 75)];
			breathAngleArray[60] = [new FlxPoint(130, 174), new FlxPoint(-79, 10)];
			breathAngleArray[61] = [new FlxPoint(130, 174), new FlxPoint(-79, 10)];
			breathAngleArray[62] = [new FlxPoint(130, 174), new FlxPoint(-79, 10)];
			breathAngleArray[63] = [new FlxPoint(114, 178), new FlxPoint(-80, 0)];
			breathAngleArray[64] = [new FlxPoint(114, 178), new FlxPoint(-80, 0)];
			breathAngleArray[65] = [new FlxPoint(114, 178), new FlxPoint(-80, 0)];
			breathAngleArray[66] = [new FlxPoint(184, 225), new FlxPoint(21, 77)];
			breathAngleArray[67] = [new FlxPoint(184, 225), new FlxPoint(21, 77)];
			breathAngleArray[68] = [new FlxPoint(184, 225), new FlxPoint(21, 77)];

			var headSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			headSweatArray[0] = [new FlxPoint(189, 147), new FlxPoint(171, 144), new FlxPoint(169, 118), new FlxPoint(133, 116), new FlxPoint(167, 93), new FlxPoint(189, 94), new FlxPoint(224, 110), new FlxPoint(190, 118)];
			headSweatArray[1] = [new FlxPoint(189, 147), new FlxPoint(171, 144), new FlxPoint(169, 118), new FlxPoint(133, 116), new FlxPoint(167, 93), new FlxPoint(189, 94), new FlxPoint(224, 110), new FlxPoint(190, 118)];
			headSweatArray[2] = [new FlxPoint(189, 147), new FlxPoint(171, 144), new FlxPoint(169, 118), new FlxPoint(133, 116), new FlxPoint(167, 93), new FlxPoint(189, 94), new FlxPoint(224, 110), new FlxPoint(190, 118)];
			headSweatArray[3] = [new FlxPoint(213, 154), new FlxPoint(194, 153), new FlxPoint(193, 123), new FlxPoint(149, 110), new FlxPoint(190, 93), new FlxPoint(215, 99), new FlxPoint(242, 121), new FlxPoint(216, 124)];
			headSweatArray[4] = [new FlxPoint(213, 154), new FlxPoint(194, 153), new FlxPoint(193, 123), new FlxPoint(149, 110), new FlxPoint(190, 93), new FlxPoint(215, 99), new FlxPoint(242, 121), new FlxPoint(216, 124)];
			headSweatArray[5] = [new FlxPoint(213, 154), new FlxPoint(194, 153), new FlxPoint(193, 123), new FlxPoint(149, 110), new FlxPoint(190, 93), new FlxPoint(215, 99), new FlxPoint(242, 121), new FlxPoint(216, 124)];
			headSweatArray[6] = [new FlxPoint(171, 129), new FlxPoint(152, 129), new FlxPoint(154, 106), new FlxPoint(133, 102), new FlxPoint(169, 83), new FlxPoint(193, 84), new FlxPoint(230, 112), new FlxPoint(178, 104)];
			headSweatArray[7] = [new FlxPoint(171, 129), new FlxPoint(152, 129), new FlxPoint(154, 106), new FlxPoint(133, 102), new FlxPoint(169, 83), new FlxPoint(193, 84), new FlxPoint(230, 112), new FlxPoint(178, 104)];
			headSweatArray[8] = [new FlxPoint(171, 129), new FlxPoint(152, 129), new FlxPoint(154, 106), new FlxPoint(133, 102), new FlxPoint(169, 83), new FlxPoint(193, 84), new FlxPoint(230, 112), new FlxPoint(178, 104)];
			headSweatArray[12] = [new FlxPoint(173, 163), new FlxPoint(146, 165), new FlxPoint(149, 130), new FlxPoint(122, 123), new FlxPoint(147, 97), new FlxPoint(174, 93), new FlxPoint(215, 109), new FlxPoint(173, 128)];
			headSweatArray[13] = [new FlxPoint(173, 163), new FlxPoint(146, 165), new FlxPoint(149, 130), new FlxPoint(122, 123), new FlxPoint(147, 97), new FlxPoint(174, 93), new FlxPoint(215, 109), new FlxPoint(173, 128)];
			headSweatArray[14] = [new FlxPoint(173, 163), new FlxPoint(146, 165), new FlxPoint(149, 130), new FlxPoint(122, 123), new FlxPoint(147, 97), new FlxPoint(174, 93), new FlxPoint(215, 109), new FlxPoint(173, 128)];
			headSweatArray[15] = [new FlxPoint(191, 147), new FlxPoint(168, 144), new FlxPoint(171, 124), new FlxPoint(136, 113), new FlxPoint(168, 95), new FlxPoint(194, 93), new FlxPoint(227, 118), new FlxPoint(190, 123)];
			headSweatArray[16] = [new FlxPoint(191, 147), new FlxPoint(168, 144), new FlxPoint(171, 124), new FlxPoint(136, 113), new FlxPoint(168, 95), new FlxPoint(194, 93), new FlxPoint(227, 118), new FlxPoint(190, 123)];
			headSweatArray[17] = [new FlxPoint(191, 147), new FlxPoint(168, 144), new FlxPoint(171, 124), new FlxPoint(136, 113), new FlxPoint(168, 95), new FlxPoint(194, 93), new FlxPoint(227, 118), new FlxPoint(190, 123)];
			headSweatArray[18] = [new FlxPoint(196, 184), new FlxPoint(166, 187), new FlxPoint(164, 151), new FlxPoint(126, 134), new FlxPoint(165, 117), new FlxPoint(198, 119), new FlxPoint(233, 134), new FlxPoint(196, 152)];
			headSweatArray[19] = [new FlxPoint(196, 184), new FlxPoint(166, 187), new FlxPoint(164, 151), new FlxPoint(126, 134), new FlxPoint(165, 117), new FlxPoint(198, 119), new FlxPoint(233, 134), new FlxPoint(196, 152)];
			headSweatArray[20] = [new FlxPoint(196, 184), new FlxPoint(166, 187), new FlxPoint(164, 151), new FlxPoint(126, 134), new FlxPoint(165, 117), new FlxPoint(198, 119), new FlxPoint(233, 134), new FlxPoint(196, 152)];
			headSweatArray[24] = [new FlxPoint(213, 133), new FlxPoint(188, 137), new FlxPoint(182, 111), new FlxPoint(133, 112), new FlxPoint(170, 85), new FlxPoint(193, 85), new FlxPoint(230, 103), new FlxPoint(208, 109)];
			headSweatArray[25] = [new FlxPoint(213, 133), new FlxPoint(188, 137), new FlxPoint(182, 111), new FlxPoint(133, 112), new FlxPoint(170, 85), new FlxPoint(193, 85), new FlxPoint(230, 103), new FlxPoint(208, 109)];
			headSweatArray[26] = [new FlxPoint(213, 133), new FlxPoint(188, 137), new FlxPoint(182, 111), new FlxPoint(133, 112), new FlxPoint(170, 85), new FlxPoint(193, 85), new FlxPoint(230, 103), new FlxPoint(208, 109)];
			headSweatArray[27] = [new FlxPoint(196, 184), new FlxPoint(168, 181), new FlxPoint(166, 155), new FlxPoint(132, 135), new FlxPoint(165, 120), new FlxPoint(198, 118), new FlxPoint(236, 132), new FlxPoint(196, 155)];
			headSweatArray[28] = [new FlxPoint(196, 184), new FlxPoint(168, 181), new FlxPoint(166, 155), new FlxPoint(132, 135), new FlxPoint(165, 120), new FlxPoint(198, 118), new FlxPoint(236, 132), new FlxPoint(196, 155)];
			headSweatArray[29] = [new FlxPoint(196, 184), new FlxPoint(168, 181), new FlxPoint(166, 155), new FlxPoint(132, 135), new FlxPoint(165, 120), new FlxPoint(198, 118), new FlxPoint(236, 132), new FlxPoint(196, 155)];
			headSweatArray[30] = [new FlxPoint(151, 145), new FlxPoint(129, 142), new FlxPoint(131, 122), new FlxPoint(121, 112), new FlxPoint(143, 94), new FlxPoint(160, 98), new FlxPoint(218, 121), new FlxPoint(155, 124)];
			headSweatArray[31] = [new FlxPoint(151, 145), new FlxPoint(129, 142), new FlxPoint(131, 122), new FlxPoint(121, 112), new FlxPoint(143, 94), new FlxPoint(160, 98), new FlxPoint(218, 121), new FlxPoint(155, 124)];
			headSweatArray[32] = [new FlxPoint(151, 145), new FlxPoint(129, 142), new FlxPoint(131, 122), new FlxPoint(121, 112), new FlxPoint(143, 94), new FlxPoint(160, 98), new FlxPoint(218, 121), new FlxPoint(155, 124)];
			headSweatArray[36] = [new FlxPoint(233, 144), new FlxPoint(209, 149), new FlxPoint(206, 130), new FlxPoint(145, 126), new FlxPoint(198, 101), new FlxPoint(230, 102), new FlxPoint(239, 119), new FlxPoint(231, 129)];
			headSweatArray[37] = [new FlxPoint(233, 144), new FlxPoint(209, 149), new FlxPoint(206, 130), new FlxPoint(145, 126), new FlxPoint(198, 101), new FlxPoint(230, 102), new FlxPoint(239, 119), new FlxPoint(231, 129)];
			headSweatArray[38] = [new FlxPoint(233, 144), new FlxPoint(209, 149), new FlxPoint(206, 130), new FlxPoint(145, 126), new FlxPoint(198, 101), new FlxPoint(230, 102), new FlxPoint(239, 119), new FlxPoint(231, 129)];
			headSweatArray[39] = [new FlxPoint(194, 181), new FlxPoint(166, 183), new FlxPoint(166, 158), new FlxPoint(128, 136), new FlxPoint(167, 115), new FlxPoint(199, 114), new FlxPoint(232, 132), new FlxPoint(194, 157)];
			headSweatArray[40] = [new FlxPoint(194, 181), new FlxPoint(166, 183), new FlxPoint(166, 158), new FlxPoint(128, 136), new FlxPoint(167, 115), new FlxPoint(199, 114), new FlxPoint(232, 132), new FlxPoint(194, 157)];
			headSweatArray[41] = [new FlxPoint(194, 181), new FlxPoint(166, 183), new FlxPoint(166, 158), new FlxPoint(128, 136), new FlxPoint(167, 115), new FlxPoint(199, 114), new FlxPoint(232, 132), new FlxPoint(194, 157)];
			headSweatArray[42] = [new FlxPoint(218, 164), new FlxPoint(190, 164), new FlxPoint(188, 139), new FlxPoint(145, 118), new FlxPoint(190, 97), new FlxPoint(215, 99), new FlxPoint(240, 125), new FlxPoint(217, 138)];
			headSweatArray[43] = [new FlxPoint(218, 164), new FlxPoint(190, 164), new FlxPoint(188, 139), new FlxPoint(145, 118), new FlxPoint(190, 97), new FlxPoint(215, 99), new FlxPoint(240, 125), new FlxPoint(217, 138)];
			headSweatArray[44] = [new FlxPoint(218, 164), new FlxPoint(190, 164), new FlxPoint(188, 139), new FlxPoint(145, 118), new FlxPoint(190, 97), new FlxPoint(215, 99), new FlxPoint(240, 125), new FlxPoint(217, 138)];
			headSweatArray[48] = [new FlxPoint(196, 184), new FlxPoint(167, 184), new FlxPoint(167, 157), new FlxPoint(129, 140), new FlxPoint(164, 118), new FlxPoint(202, 120), new FlxPoint(240, 137), new FlxPoint(198, 159)];
			headSweatArray[49] = [new FlxPoint(196, 184), new FlxPoint(167, 184), new FlxPoint(167, 157), new FlxPoint(129, 140), new FlxPoint(164, 118), new FlxPoint(202, 120), new FlxPoint(240, 137), new FlxPoint(198, 159)];
			headSweatArray[50] = [new FlxPoint(196, 184), new FlxPoint(167, 184), new FlxPoint(167, 157), new FlxPoint(129, 140), new FlxPoint(164, 118), new FlxPoint(202, 120), new FlxPoint(240, 137), new FlxPoint(198, 159)];
			headSweatArray[51] = [new FlxPoint(172, 157), new FlxPoint(146, 162), new FlxPoint(146, 137), new FlxPoint(123, 127), new FlxPoint(146, 96), new FlxPoint(174, 92), new FlxPoint(218, 110), new FlxPoint(169, 134)];
			headSweatArray[52] = [new FlxPoint(172, 157), new FlxPoint(146, 162), new FlxPoint(146, 137), new FlxPoint(123, 127), new FlxPoint(146, 96), new FlxPoint(174, 92), new FlxPoint(218, 110), new FlxPoint(169, 134)];
			headSweatArray[53] = [new FlxPoint(172, 157), new FlxPoint(146, 162), new FlxPoint(146, 137), new FlxPoint(123, 127), new FlxPoint(146, 96), new FlxPoint(174, 92), new FlxPoint(218, 110), new FlxPoint(169, 134)];
			headSweatArray[54] = [new FlxPoint(190, 148), new FlxPoint(168, 151), new FlxPoint(169, 131), new FlxPoint(132, 114), new FlxPoint(171, 93), new FlxPoint(192, 93), new FlxPoint(223, 109), new FlxPoint(188, 129)];
			headSweatArray[55] = [new FlxPoint(190, 148), new FlxPoint(168, 151), new FlxPoint(169, 131), new FlxPoint(132, 114), new FlxPoint(171, 93), new FlxPoint(192, 93), new FlxPoint(223, 109), new FlxPoint(188, 129)];
			headSweatArray[56] = [new FlxPoint(190, 148), new FlxPoint(168, 151), new FlxPoint(169, 131), new FlxPoint(132, 114), new FlxPoint(171, 93), new FlxPoint(192, 93), new FlxPoint(223, 109), new FlxPoint(188, 129)];
			headSweatArray[60] = [new FlxPoint(168, 137), new FlxPoint(145, 136), new FlxPoint(147, 118), new FlxPoint(129, 109), new FlxPoint(168, 84), new FlxPoint(193, 87), new FlxPoint(229, 113), new FlxPoint(172, 119)];
			headSweatArray[61] = [new FlxPoint(168, 137), new FlxPoint(145, 136), new FlxPoint(147, 118), new FlxPoint(129, 109), new FlxPoint(168, 84), new FlxPoint(193, 87), new FlxPoint(229, 113), new FlxPoint(172, 119)];
			headSweatArray[62] = [new FlxPoint(168, 137), new FlxPoint(145, 136), new FlxPoint(147, 118), new FlxPoint(129, 109), new FlxPoint(168, 84), new FlxPoint(193, 87), new FlxPoint(229, 113), new FlxPoint(172, 119)];
			headSweatArray[63] = [new FlxPoint(150, 144), new FlxPoint(128, 141), new FlxPoint(128, 122), new FlxPoint(122, 112), new FlxPoint(144, 95), new FlxPoint(163, 92), new FlxPoint(218, 123), new FlxPoint(154, 124)];
			headSweatArray[64] = [new FlxPoint(150, 144), new FlxPoint(128, 141), new FlxPoint(128, 122), new FlxPoint(122, 112), new FlxPoint(144, 95), new FlxPoint(163, 92), new FlxPoint(218, 123), new FlxPoint(154, 124)];
			headSweatArray[65] = [new FlxPoint(150, 144), new FlxPoint(128, 141), new FlxPoint(128, 122), new FlxPoint(122, 112), new FlxPoint(144, 95), new FlxPoint(163, 92), new FlxPoint(218, 123), new FlxPoint(154, 124)];
			headSweatArray[66] = [new FlxPoint(191, 150), new FlxPoint(170, 150), new FlxPoint(168, 123), new FlxPoint(136, 108), new FlxPoint(170, 92), new FlxPoint(193, 93), new FlxPoint(228, 112), new FlxPoint(194, 124)];
			headSweatArray[67] = [new FlxPoint(191, 150), new FlxPoint(170, 150), new FlxPoint(168, 123), new FlxPoint(136, 108), new FlxPoint(170, 92), new FlxPoint(193, 93), new FlxPoint(228, 112), new FlxPoint(194, 124)];
			headSweatArray[68] = [new FlxPoint(191, 150), new FlxPoint(170, 150), new FlxPoint(168, 123), new FlxPoint(136, 108), new FlxPoint(170, 92), new FlxPoint(193, 93), new FlxPoint(228, 112), new FlxPoint(194, 124)];

			var torsoSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
			torsoSweatArray[0] = [new FlxPoint(204, 283), new FlxPoint(154, 282), new FlxPoint(142, 251), new FlxPoint(144, 208), new FlxPoint(132, 185), new FlxPoint(238, 186), new FlxPoint(221, 208), new FlxPoint(218, 253)];

			sweatAreas.splice(0, sweatAreas.length);
			sweatAreas.push({chance:4, sprite:_pokeWindow._head, sweatArrayArray:headSweatArray});
			sweatAreas.push({chance:6, sprite:_pokeWindow.torso1, sweatArrayArray:torsoSweatArray});
		}

		assPolyArray = new Array<Array<FlxPoint>>();
		assPolyArray[0] = [new FlxPoint(200, 425), new FlxPoint(160, 423), new FlxPoint(164, 385), new FlxPoint(198, 385)];

		leftCalfPolyArray = new Array<Array<FlxPoint>>();
		leftCalfPolyArray[0] = [new FlxPoint(92, 483), new FlxPoint(142, 331), new FlxPoint(110, 277), new FlxPoint(70, 301), new FlxPoint(16, 481)];
		leftCalfPolyArray[1] = [new FlxPoint(150, 483), new FlxPoint(134, 327), new FlxPoint(94, 283), new FlxPoint(50, 321), new FlxPoint(48, 481)];
		leftCalfPolyArray[2] = [new FlxPoint(124, 481), new FlxPoint(138, 323), new FlxPoint(102, 285), new FlxPoint(72, 293), new FlxPoint(52, 333), new FlxPoint(52, 483)];
		leftCalfPolyArray[3] = [new FlxPoint(82, 483), new FlxPoint(136, 345), new FlxPoint(110, 305), new FlxPoint(58, 333), new FlxPoint(10, 481)];
		leftCalfPolyArray[4] = [new FlxPoint(72, 485), new FlxPoint(124, 373), new FlxPoint(96, 331), new FlxPoint(48, 343), new FlxPoint(22, 485)];
		leftCalfPolyArray[5] = [new FlxPoint(92, 483), new FlxPoint(140, 329), new FlxPoint(108, 285), new FlxPoint(70, 305), new FlxPoint(22, 481)];
		leftCalfPolyArray[6] = [new FlxPoint(146, 397), new FlxPoint(128, 283), new FlxPoint(88, 251), new FlxPoint(44, 287), new FlxPoint(110, 415)];

		rightCalfPolyArray = new Array<Array<FlxPoint>>();
		rightCalfPolyArray[0] = [new FlxPoint(268, 483), new FlxPoint(214, 321), new FlxPoint(246, 277), new FlxPoint(284, 301), new FlxPoint(314, 379), new FlxPoint(314, 483)];
		rightCalfPolyArray[1] = [new FlxPoint(206, 485), new FlxPoint(226, 321), new FlxPoint(262, 285), new FlxPoint(304, 315), new FlxPoint(288, 481)];
		rightCalfPolyArray[2] = [new FlxPoint(238, 483), new FlxPoint(222, 323), new FlxPoint(256, 285), new FlxPoint(296, 301), new FlxPoint(312, 485)];
		rightCalfPolyArray[3] = [new FlxPoint(278, 483), new FlxPoint(224, 355), new FlxPoint(256, 307), new FlxPoint(292, 321), new FlxPoint(368, 483)];
		rightCalfPolyArray[4] = [new FlxPoint(288, 485), new FlxPoint(244, 379), new FlxPoint(258, 341), new FlxPoint(296, 337), new FlxPoint(370, 485)];
		rightCalfPolyArray[5] = [new FlxPoint(240, 421), new FlxPoint(210, 401), new FlxPoint(224, 289), new FlxPoint(258, 251), new FlxPoint(296, 275), new FlxPoint(302, 321)];
		rightCalfPolyArray[6] = [new FlxPoint(270, 481), new FlxPoint(216, 317), new FlxPoint(248, 275), new FlxPoint(282, 295), new FlxPoint(348, 483)];

		chestSpikePolyArray = new Array<Array<FlxPoint>>();
		chestSpikePolyArray[0] = [new FlxPoint(173, 252), new FlxPoint(163, 230), new FlxPoint(185, 217), new FlxPoint(199, 234), new FlxPoint(191, 253)];

		leftShoulderDownPolyArray = new Array<Array<FlxPoint>>();
		leftShoulderDownPolyArray[0] = [new FlxPoint(184, 262), new FlxPoint(130, 274), new FlxPoint(98, 182), new FlxPoint(184, 148)];
		leftShoulderDownPolyArray[1] = [new FlxPoint(184, 262), new FlxPoint(130, 274), new FlxPoint(98, 182), new FlxPoint(184, 148)];
		leftShoulderDownPolyArray[2] = [new FlxPoint(184, 262), new FlxPoint(130, 274), new FlxPoint(98, 182), new FlxPoint(184, 148)];
		leftShoulderDownPolyArray[3] = [new FlxPoint(184, 262), new FlxPoint(130, 274), new FlxPoint(98, 182), new FlxPoint(184, 148)];
		leftShoulderDownPolyArray[4] = [new FlxPoint(184, 262), new FlxPoint(130, 274), new FlxPoint(98, 182), new FlxPoint(184, 148)];
		leftShoulderDownPolyArray[6] = [new FlxPoint(184, 262), new FlxPoint(130, 274), new FlxPoint(98, 182), new FlxPoint(184, 148)];
		leftShoulderDownPolyArray[7] = [new FlxPoint(184, 262), new FlxPoint(130, 274), new FlxPoint(98, 182), new FlxPoint(184, 148)];
		leftShoulderDownPolyArray[8] = [new FlxPoint(184, 262), new FlxPoint(130, 274), new FlxPoint(98, 182), new FlxPoint(184, 148)];
		leftShoulderDownPolyArray[9] = [new FlxPoint(184, 262), new FlxPoint(130, 274), new FlxPoint(98, 182), new FlxPoint(184, 148)];
		leftShoulderDownPolyArray[10] = [new FlxPoint(184, 262), new FlxPoint(130, 274), new FlxPoint(98, 182), new FlxPoint(184, 148)];

		rightShoulderDownPolyArray = new Array<Array<FlxPoint>>();
		rightShoulderDownPolyArray[0] = [new FlxPoint(230, 289), new FlxPoint(184, 273), new FlxPoint(216, 147), new FlxPoint(270, 169)];
		rightShoulderDownPolyArray[1] = [new FlxPoint(230, 289), new FlxPoint(184, 273), new FlxPoint(216, 147), new FlxPoint(270, 169)];
		rightShoulderDownPolyArray[2] = [new FlxPoint(230, 289), new FlxPoint(184, 273), new FlxPoint(216, 147), new FlxPoint(270, 169)];
		rightShoulderDownPolyArray[3] = [new FlxPoint(230, 289), new FlxPoint(184, 273), new FlxPoint(216, 147), new FlxPoint(270, 169)];
		rightShoulderDownPolyArray[4] = [new FlxPoint(230, 289), new FlxPoint(184, 273), new FlxPoint(216, 147), new FlxPoint(270, 169)];
		rightShoulderDownPolyArray[12] = [new FlxPoint(230, 289), new FlxPoint(184, 273), new FlxPoint(216, 147), new FlxPoint(270, 169)];
		rightShoulderDownPolyArray[13] = [new FlxPoint(230, 289), new FlxPoint(184, 273), new FlxPoint(216, 147), new FlxPoint(270, 169)];
		rightShoulderDownPolyArray[14] = [new FlxPoint(230, 289), new FlxPoint(184, 273), new FlxPoint(216, 147), new FlxPoint(270, 169)];
		rightShoulderDownPolyArray[15] = [new FlxPoint(230, 289), new FlxPoint(184, 273), new FlxPoint(216, 147), new FlxPoint(270, 169)];
		rightShoulderDownPolyArray[16] = [new FlxPoint(230, 289), new FlxPoint(184, 273), new FlxPoint(216, 147), new FlxPoint(270, 169)];

		leftShoulderUpPolyArray = new Array<Array<FlxPoint>>();
		leftShoulderUpPolyArray[1] = [new FlxPoint(126, 272), new FlxPoint(98, 176), new FlxPoint(150, 164), new FlxPoint(182, 262)];
		leftShoulderUpPolyArray[3] = [new FlxPoint(126, 272), new FlxPoint(98, 176), new FlxPoint(150, 164), new FlxPoint(182, 262)];
		leftShoulderUpPolyArray[5] = [new FlxPoint(126, 272), new FlxPoint(98, 176), new FlxPoint(150, 164), new FlxPoint(182, 262)];
		leftShoulderUpPolyArray[7] = [new FlxPoint(126, 272), new FlxPoint(98, 176), new FlxPoint(150, 164), new FlxPoint(182, 262)];
		leftShoulderUpPolyArray[9] = [new FlxPoint(160, 202), new FlxPoint(146, 215), new FlxPoint(100, 222), new FlxPoint(90, 166), new FlxPoint(160, 161)];
		leftShoulderUpPolyArray[11] = [new FlxPoint(164, 243), new FlxPoint(96, 216), new FlxPoint(116, 168), new FlxPoint(178, 200)];
		leftShoulderUpPolyArray[13] = [new FlxPoint(164, 236), new FlxPoint(92, 207), new FlxPoint(122, 160), new FlxPoint(180, 199)];
		leftShoulderUpPolyArray[15] = [new FlxPoint(160, 242), new FlxPoint(132, 264), new FlxPoint(74, 183), new FlxPoint(140, 164), new FlxPoint(170, 212)];
		leftShoulderUpPolyArray[18] = [new FlxPoint(162, 238), new FlxPoint(94, 208), new FlxPoint(114, 155), new FlxPoint(184, 187)];
		leftShoulderUpPolyArray[19] = [new FlxPoint(162, 238), new FlxPoint(94, 208), new FlxPoint(114, 155), new FlxPoint(184, 187)];
		leftShoulderUpPolyArray[20] = [new FlxPoint(162, 238), new FlxPoint(94, 208), new FlxPoint(114, 155), new FlxPoint(184, 187)];
		leftShoulderUpPolyArray[21] = [new FlxPoint(164, 208), new FlxPoint(96, 227), new FlxPoint(88, 172), new FlxPoint(162, 162)];
		leftShoulderUpPolyArray[22] = [new FlxPoint(160, 251), new FlxPoint(86, 227), new FlxPoint(104, 164), new FlxPoint(182, 187)];
		leftShoulderUpPolyArray[23] = [new FlxPoint(162, 251), new FlxPoint(94, 218), new FlxPoint(118, 164), new FlxPoint(180, 183)];
		leftShoulderUpPolyArray[24] = [new FlxPoint(162, 251), new FlxPoint(94, 218), new FlxPoint(118, 164), new FlxPoint(180, 183)];
		leftShoulderUpPolyArray[25] = [new FlxPoint(162, 251), new FlxPoint(94, 218), new FlxPoint(118, 164), new FlxPoint(180, 183)];
		leftShoulderUpPolyArray[26] = [new FlxPoint(162, 203), new FlxPoint(100, 224), new FlxPoint(86, 174), new FlxPoint(148, 163)];
		leftShoulderUpPolyArray[27] = [new FlxPoint(162, 258), new FlxPoint(86, 225), new FlxPoint(108, 168), new FlxPoint(174, 190)];
		leftShoulderUpPolyArray[28] = [new FlxPoint(166, 208), new FlxPoint(96, 226), new FlxPoint(84, 179), new FlxPoint(156, 170)];
		leftShoulderUpPolyArray[29] = [new FlxPoint(162, 257), new FlxPoint(84, 230), new FlxPoint(102, 158), new FlxPoint(178, 166)];

		rightShoulderUpPolyArray = new Array<Array<FlxPoint>>();
		rightShoulderUpPolyArray[2] = [new FlxPoint(228, 282), new FlxPoint(184, 244), new FlxPoint(222, 151), new FlxPoint(268, 186)];
		rightShoulderUpPolyArray[4] = [new FlxPoint(228, 282), new FlxPoint(184, 244), new FlxPoint(222, 151), new FlxPoint(268, 186)];
		rightShoulderUpPolyArray[6] = [new FlxPoint(228, 282), new FlxPoint(184, 244), new FlxPoint(222, 151), new FlxPoint(268, 186)];
		rightShoulderUpPolyArray[8] = [new FlxPoint(228, 282), new FlxPoint(184, 244), new FlxPoint(222, 151), new FlxPoint(268, 186)];
		rightShoulderUpPolyArray[10] = [new FlxPoint(244, 245), new FlxPoint(198, 250), new FlxPoint(190, 170), new FlxPoint(280, 184)];
		rightShoulderUpPolyArray[12] = [new FlxPoint(234, 227), new FlxPoint(194, 227), new FlxPoint(222, 150), new FlxPoint(294, 166), new FlxPoint(270, 210)];
		rightShoulderUpPolyArray[14] = [new FlxPoint(192, 242), new FlxPoint(228, 268), new FlxPoint(280, 191), new FlxPoint(210, 163)];
		rightShoulderUpPolyArray[16] = [new FlxPoint(244, 233), new FlxPoint(198, 200), new FlxPoint(238, 130), new FlxPoint(290, 166), new FlxPoint(276, 217)];
		rightShoulderUpPolyArray[18] = [new FlxPoint(234, 238), new FlxPoint(198, 249), new FlxPoint(204, 168), new FlxPoint(270, 174), new FlxPoint(260, 227)];
		rightShoulderUpPolyArray[19] = [new FlxPoint(264, 235), new FlxPoint(200, 252), new FlxPoint(188, 177), new FlxPoint(296, 172)];
		rightShoulderUpPolyArray[20] = [new FlxPoint(268, 228), new FlxPoint(194, 205), new FlxPoint(220, 154), new FlxPoint(294, 167)];
		rightShoulderUpPolyArray[21] = [new FlxPoint(268, 224), new FlxPoint(198, 254), new FlxPoint(184, 168), new FlxPoint(270, 162)];
		rightShoulderUpPolyArray[22] = [new FlxPoint(268, 224), new FlxPoint(198, 254), new FlxPoint(184, 168), new FlxPoint(270, 162)];
		rightShoulderUpPolyArray[23] = [new FlxPoint(264, 212), new FlxPoint(196, 242), new FlxPoint(186, 161), new FlxPoint(276, 152)];
		rightShoulderUpPolyArray[24] = [new FlxPoint(264, 233), new FlxPoint(200, 256), new FlxPoint(194, 170), new FlxPoint(282, 163)];
		rightShoulderUpPolyArray[25] = [new FlxPoint(264, 225), new FlxPoint(192, 204), new FlxPoint(232, 139), new FlxPoint(296, 168)];
		rightShoulderUpPolyArray[26] = [new FlxPoint(264, 210), new FlxPoint(198, 237), new FlxPoint(190, 168), new FlxPoint(266, 156)];
		rightShoulderUpPolyArray[27] = [new FlxPoint(264, 210), new FlxPoint(198, 237), new FlxPoint(190, 168), new FlxPoint(266, 156)];
		rightShoulderUpPolyArray[28] = [new FlxPoint(264, 233), new FlxPoint(198, 256), new FlxPoint(194, 177), new FlxPoint(286, 172)];
		rightShoulderUpPolyArray[29] = [new FlxPoint(264, 226), new FlxPoint(198, 206), new FlxPoint(218, 159), new FlxPoint(290, 166)];

		leftThighPolyArray = new Array<Array<FlxPoint>>();
		leftThighPolyArray[0] = [new FlxPoint(178, 426), new FlxPoint(104, 414), new FlxPoint(116, 368), new FlxPoint(138, 340), new FlxPoint(136, 272), new FlxPoint(188, 270)];
		leftThighPolyArray[1] = [new FlxPoint(178, 422), new FlxPoint(132, 424), new FlxPoint(128, 364), new FlxPoint(140, 326), new FlxPoint(80, 264), new FlxPoint(186, 260)];
		leftThighPolyArray[2] = [new FlxPoint(178, 420), new FlxPoint(118, 424), new FlxPoint(128, 372), new FlxPoint(142, 324), new FlxPoint(98, 276), new FlxPoint(186, 278)];
		leftThighPolyArray[3] = [new FlxPoint(176, 432), new FlxPoint(100, 428), new FlxPoint(114, 390), new FlxPoint(136, 346), new FlxPoint(96, 278), new FlxPoint(184, 276)];
		leftThighPolyArray[4] = [new FlxPoint(174, 434), new FlxPoint(96, 440), new FlxPoint(122, 366), new FlxPoint(86, 284), new FlxPoint(184, 282)];
		leftThighPolyArray[5] = [new FlxPoint(178, 426), new FlxPoint(102, 422), new FlxPoint(116, 366), new FlxPoint(140, 328), new FlxPoint(114, 258), new FlxPoint(182, 256)];
		leftThighPolyArray[6] = [new FlxPoint(178, 436), new FlxPoint(142, 442), new FlxPoint(138, 336), new FlxPoint(118, 242), new FlxPoint(184, 252)];

		rightThighPolyArray = new Array<Array<FlxPoint>>();
		rightThighPolyArray[0] = [new FlxPoint(178, 448), new FlxPoint(262, 428), new FlxPoint(214, 318), new FlxPoint(238, 282), new FlxPoint(272, 256), new FlxPoint(180, 260)];
		rightThighPolyArray[1] = [new FlxPoint(176, 432), new FlxPoint(216, 432), new FlxPoint(232, 358), new FlxPoint(222, 324), new FlxPoint(278, 248), new FlxPoint(184, 252)];
		rightThighPolyArray[2] = [new FlxPoint(180, 424), new FlxPoint(236, 422), new FlxPoint(238, 368), new FlxPoint(222, 328), new FlxPoint(282, 246), new FlxPoint(184, 258)];
		rightThighPolyArray[3] = [new FlxPoint(176, 434), new FlxPoint(260, 432), new FlxPoint(224, 358), new FlxPoint(288, 260), new FlxPoint(184, 262)];
		rightThighPolyArray[4] = [new FlxPoint(180, 436), new FlxPoint(266, 436), new FlxPoint(246, 362), new FlxPoint(300, 288), new FlxPoint(186, 288)];
		rightThighPolyArray[5] = [new FlxPoint(180, 428), new FlxPoint(206, 428), new FlxPoint(226, 326), new FlxPoint(220, 300), new FlxPoint(272, 228), new FlxPoint(182, 238)];
		rightThighPolyArray[6] = [new FlxPoint(178, 442), new FlxPoint(262, 430), new FlxPoint(214, 320), new FlxPoint(268, 246), new FlxPoint(180, 258)];

		tailPolyArray = new Array<Array<FlxPoint>>();
		tailPolyArray[0] = [new FlxPoint(160, 419), new FlxPoint(178, 411), new FlxPoint(204, 421), new FlxPoint(228, 485), new FlxPoint(110, 485)];

		vagPolyArray = new Array<Array<FlxPoint>>();
		vagPolyArray[0] = [new FlxPoint(195, 401), new FlxPoint(163, 401), new FlxPoint(165, 365), new FlxPoint(195, 365)];

		encouragementWords = wordManager.newWords();
		encouragementWords.words.push([ { graphic:AssetPaths.lucasexy_words_small__png, frame:0} ]);
		encouragementWords.words.push([ { graphic:AssetPaths.lucasexy_words_small__png, frame:1} ]);
		encouragementWords.words.push([ { graphic:AssetPaths.lucasexy_words_small__png, frame:2} ]);
		encouragementWords.words.push([ { graphic:AssetPaths.lucasexy_words_small__png, frame:3} ]);
		encouragementWords.words.push([ { graphic:AssetPaths.lucasexy_words_small__png, frame:4} ]);
		encouragementWords.words.push([ { graphic:AssetPaths.lucasexy_words_small__png, frame:5} ]);
		encouragementWords.words.push([ { graphic:AssetPaths.lucasexy_words_small__png, frame:6} ]);
		encouragementWords.words.push([ { graphic:AssetPaths.lucasexy_words_small__png, frame:7} ]);
		encouragementWords.words.push([ { graphic:AssetPaths.lucasexy_words_small__png, frame:8} ]);

		pleasureWords = wordManager.newWords(8);
		pleasureWords.words.push([{ graphic:AssetPaths.lucasexy_words_medium__png, frame:0, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.lucasexy_words_medium__png, frame:1, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.lucasexy_words_medium__png, frame:2, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.lucasexy_words_medium__png, frame:3, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.lucasexy_words_medium__png, frame:4, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.lucasexy_words_medium__png, frame:5, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.lucasexy_words_medium__png, frame:6, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.lucasexy_words_medium__png, frame:8, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([{ graphic:AssetPaths.lucasexy_words_medium__png, frame:10, height:48, chunkSize:5 } ]);

		almostWords = wordManager.newWords(30);
		// ohhh, th-that's... i'm going to...
		almostWords.words.push([
		{ graphic:AssetPaths.lucasexy_words_medium__png, frame:7, height:48, chunkSize:5, delay:-0.2},
		{ graphic:AssetPaths.lucasexy_words_medium__png, frame:9, height:48, chunkSize:5, yOffset:22, delay:0.6 },
		{ graphic:AssetPaths.lucasexy_words_medium__png, frame:11, height:48, chunkSize:5, yOffset:42, delay:1.9 }
		]);
		// h-here it comes, i think i... i...
		almostWords.words.push([
		{ graphic:AssetPaths.lucasexy_words_medium__png, frame:12, height:48, chunkSize:5, delay:-0.1},
		{ graphic:AssetPaths.lucasexy_words_medium__png, frame:14, height:48, chunkSize:5, yOffset:22, delay:0.5 },
		{ graphic:AssetPaths.lucasexy_words_medium__png, frame:16, height:48, chunkSize:5, yOffset:42, delay:1.3 }
		]);
		// s-so good, i'm... i'm about t-to...
		almostWords.words.push([
		{ graphic:AssetPaths.lucasexy_words_medium__png, frame:13, height:48, chunkSize:5},
		{ graphic:AssetPaths.lucasexy_words_medium__png, frame:15, height:48, chunkSize:5, yOffset:26, delay:0.6 },
		{ graphic:AssetPaths.lucasexy_words_medium__png, frame:17, height:48, chunkSize:5, yOffset:44, delay:1.4 }
		]);

		orgasmWords = wordManager.newWords();
		orgasmWords.words.push([ { graphic:AssetPaths.lucasexy_words_large__png, frame:0, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.lucasexy_words_large__png, frame:1, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.lucasexy_words_large__png, frame:2, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.lucasexy_words_large__png, frame:4, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([
		{ graphic:AssetPaths.lucasexy_words_large__png, frame:3, width:200, height:150, yOffset:-30, chunkSize:5},
		{ graphic:AssetPaths.lucasexy_words_large__png, frame:5, width:200, height:150, yOffset:-30, chunkSize:5, delay:0.4 }
		]);

		boredWords = wordManager.newWords();
		boredWords.words.push([ { graphic:AssetPaths.lucasexy_words_small__png, frame:9} ]);
		boredWords.words.push([ { graphic:AssetPaths.lucasexy_words_small__png, frame:10} ]);
		boredWords.words.push([ { graphic:AssetPaths.lucasexy_words_small__png, frame:11} ]);
		// are... are you...?
		boredWords.words.push([
		{ graphic:AssetPaths.lucasexy_words_small__png, frame:12},
		{ graphic:AssetPaths.lucasexy_words_small__png, frame:14, yOffset:22, delay:0.5 }
		]);
		// kyeh, i have some other deliveries..
		boredWords.words.push([
		{ graphic:AssetPaths.lucasexy_words_small__png, frame:13},
		{ graphic:AssetPaths.lucasexy_words_small__png, frame:15, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.lucasexy_words_small__png, frame:17, yOffset:38, delay:1.6 }
		]);

		// ooooooh! now you're talking~
		toyStartWords.words.push([
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:0},
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:2, yOffset:20, delay:0.8 },
		]);
		// is that for meeeee? kyeheheheh~
		toyStartWords.words.push([
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:1},
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:3, yOffset:18, delay:0.6 },
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:5, yOffset:38, delay:1.7 },
		]);
		// kyahh, let me get a little more comfortable~
		toyStartWords.words.push([
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:4},
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:6, yOffset:20, delay:1.1 },
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:8, yOffset:38, delay:1.9 },
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:10, yOffset:58, delay:2.7 },
		]);

		// aww! ...is that iiiiit?
		toyInterruptWords.words.push([
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:7},
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:9, yOffset:18, delay:0.6 },
		]);
		// oh okay! we don't have to...
		toyInterruptWords.words.push([
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:11},
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:13, yOffset:18, delay:0.9 },
		]);
		// oh! ...maybe next time~
		toyInterruptWords.words.push([
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:12},
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:14, yOffset:4, delay:0.5 },
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:16, yOffset:20, delay:1.3 },
		]);

		toyClitWords = wordManager.newWords(90);
		// kyahhh that's it. ...maybe a little faster~
		toyClitWords.words.push([
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:15 },
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:17, yOffset:20, delay:0.9 },
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:19, yOffset:20, delay:1.4 },
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:21, yOffset:42, delay:2.0 },
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:23, yOffset:62, delay:2.4 },
		]);
		// ri-i-ight there- nngh! ...really hammer that thing~
		toyClitWords.words.push([
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:18 },
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:20, yOffset:20, delay:1.0 },
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:22, yOffset:20, delay:1.5 },
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:24, yOffset:44, delay:2.3 },
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:26, yOffset:64, delay:2.9 },
		]);
		//oough, s-s-so sensitive there~
		toyClitWords.words.push([
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:25 },
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:27, yOffset:22, delay:0.6 },
		{ graphic:AssetPaths.lucadildo_words_small0__png, frame:29, yOffset:40, delay:1.0 },
		]);

		toyXlWords = wordManager.newWords();
		// kyehhh, that thing's bigger than it looks...
		toyXlWords.words.push([
		{ graphic:AssetPaths.lucadildo_words_small1__png, frame:0 },
		{ graphic:AssetPaths.lucadildo_words_small1__png, frame:2, yOffset:24, delay:0.8 },
		{ graphic:AssetPaths.lucadildo_words_small1__png, frame:4, yOffset:42, delay:1.6 },
		]);
		// someday we'll get that thing in there. ...i'll go home and practice, okay?
		toyXlWords.words.push([
		{ graphic:AssetPaths.lucadildo_words_small1__png, frame:1},
		{ graphic:AssetPaths.lucadildo_words_small1__png, frame:3, yOffset:22, delay:0.9 },
		{ graphic:AssetPaths.lucadildo_words_small1__png, frame:5, yOffset:40, delay:1.8 },
		{ graphic:AssetPaths.lucadildo_words_small1__png, frame:7, yOffset:40, delay:2.3 },
		{ graphic:AssetPaths.lucadildo_words_small1__png, frame:9, yOffset:60, delay:3.1 },
		{ graphic:AssetPaths.lucadildo_words_small1__png, frame:11, yOffset:80, delay:3.9 },
		]);
		// wellllllll it was a fun idea anyway...
		toyXlWords.words.push([
		{ graphic:AssetPaths.lucadildo_words_small1__png, frame:6},
		{ graphic:AssetPaths.lucadildo_words_small1__png, frame:8, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.lucadildo_words_small1__png, frame:10, yOffset:40, delay:1.4 },
		]);
		// ooough... well, i tried
		toyXlWords.words.push([
		{ graphic:AssetPaths.lucadildo_words_small1__png, frame:12},
		{ graphic:AssetPaths.lucadildo_words_small1__png, frame:14, yOffset:22, delay:1.3 },
		]);
		// kyehh.... too biiiiiig...
		toyXlWords.words.push([
		{ graphic:AssetPaths.lucadildo_words_small1__png, frame:13},
		{ graphic:AssetPaths.lucadildo_words_small1__png, frame:15, yOffset:20, delay:1.3 },
		]);
	}

	override function penetrating():Bool
	{
		if (specialRub == "ass")
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

	override function generateCumshots():Void
	{
		if (niceThings[1])
		{
			/*
			 * Lucario enjoys having orgasms. Well... we all do, but Lucario
			 * enjoys it more.
			 */
			doNiceThing(0.66667);
			niceThings[1] = false;
		}

		// reimburse 100% of badRubBank; it's how they're supposed to learn
		_heartBank._dickHeartReservoir += badRubBank;
		badRubBank = 0;

		// reimburse 75% of badJackoffBank
		_heartBank._dickHeartReservoir += SexyState.roundDownToQuarter(badJackoffBank * 0.75);
		badJackoffBank = 0;

		// reimburse 35% of badToyBank
		_heartBank._dickHeartReservoir += SexyState.roundDownToQuarter(badToyBank * 0.35);
		badToyBank = 0;

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

		if (displayingToyWindow() && toyWindow.isXlDildo() && (toyInterface.assTightness < XL_DILDO_TIGHTNESS_BARRIER || toyInterface.vagTightness < XL_DILDO_TIGHTNESS_BARRIER))
		{
			// increase cum traits; finally got the big dildo in
			cumTrait0 = 5;
			cumTrait4 = 6;

			// also give them some of the toy reservoir
			_heartBank._dickHeartReservoir += SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * 0.4);
			_toyBank._dickHeartReservoir -= SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * 0.4);

			_heartBank._dickHeartReservoir += SexyState.roundUpToQuarter(_toyBank._foreplayHeartReservoir * 0.4);
			_toyBank._foreplayHeartReservoir -= SexyState.roundUpToQuarter(_toyBank._foreplayHeartReservoir * 0.4);
		}

		super.generateCumshots();
	}

	override function computePrecumAmount():Int
	{
		var precumAmount:Int = 0;
		if (displayingToyWindow())
		{
			if (FlxG.random.float(-2, 3) > shortestToyPatternLength)
			{
				precumAmount++;
			}

			var toyStr:String = rubHandAnimToToyStr[_prevHandAnim];
			if (_prevHandAnim == "rub-vag" && ambientDildoBank == 0)
			{
				precumAmount++;
			}
			else if (toyStr == "1" && FlxG.random.bool(20))
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
		}
		else {
			if (specialRub == "rub-dick" || specialRub == "jack-off")
			{
				// only precum if pace is on point

				if (jackoffPaceDeviance > 1.30)
				{
					// too slow
					precumAmount = 0;
				}
				else if (jackoffPaceDeviance > 1.14)
				{
					// a little too slow
					precumAmount = 1;
				}
				else if (jackoffPaceDeviance > 0.87)
				{
					// perfect
					precumAmount = 3;
					if (niceThings[0])
					{
						precumAmount += FlxG.random.bool(60) ? 1 : 0;
					}
					else
					{
						precumAmount -= FlxG.random.bool(20) ? 1 : 0;
					}
				}
				else if (jackoffPaceDeviance > 0.76)
				{
					// a little too slow
					precumAmount = 1;
				}
				else
				{
					// too slow
					precumAmount = 0;
				}
				if (_heartBank.getForeplayPercent() > 0.75)
				{
					precumAmount -= FlxG.random.bool(50) ? 1 : 0;
				}
			}
			else {
				if (niceSpecialSpotFace)
				{
					precumAmount += FlxG.random.bool(60) ? 1 : 0;
				}
				if (FlxG.random.float(1, 10) < _heartEmitCount)
				{
					precumAmount += FlxG.random.bool(60) ? 1 : 0;
				}
				if (FlxG.random.float(0, 1.0) >= _heartBank.getDickPercent())
				{
					precumAmount += FlxG.random.bool(60) ? 1 : 0;
					precumAmount += FlxG.random.bool(60) ? 1 : 0;
				}
			}
		}
		return precumAmount;
	}

	override function handleRubReward():Void
	{
		niceSpecialSpotFace = false;

		if (niceThings[0])
		{
			// count the last four unique special rubs;

			if (specialRubs[specialRubs.length - 1] != specialRubs[specialRubs.length - 2])
			{
				if (specialRub == "left-calf" || specialRub == "right-calf")
				{
					// ignore when user is rubbing calves; this is necessary for foot rubs
				}
				else if (lastFourUniqueSpecialRubs.indexOf(specialRub) != -1)
				{
					// duplicate rub; ignore
				}
				else if (specialRub == "")
				{
					/*
					 * most of lucario's body parts are defined, but this
					 * might be empty if they rub the calf too long, or
					 * something like that. we don't count this against the
					 * player since it would be clumsy
					 */
				}
				else
				{
					var newRub:String = specialRub;
					// push it...
					if ((StringTools.startsWith(specialRub, "left-") || StringTools.startsWith(specialRub, "right-")) && specialSpots.indexOf(specialRub) >= 0)
					{
						// rubbed the left/right of something they're supposed to rub...
						if (specialSpotChain.indexOf(specialRub) >= 0)
						{
							// rubbed the correct one
							newRub = "good-" + MmStringTools.substringAfter(specialRub, "-");

							if (lastFourUniqueSpecialRubs.indexOf(newRub) != -1)
							{
								// rubbing their other foot doesn't count against your time
								specialSpotTimeTaken--;
							}

							/*
							 * remove any old "good-xxx" rubs; that way the
							 * user isn't rewarded or punished for switching
							 * back and forth between the left and right
							 * shoulder, for example
							 */
							lastFourUniqueSpecialRubs = lastFourUniqueSpecialRubs.filter(function(s) {return s != newRub; });
						}
						else
						{
							// rubbed the incorrect one
							newRub = "bad-" + MmStringTools.substringAfter(specialRub, "-");
						}
					}
					if (newRub == "rub-dick" || newRub == "jack-off")
					{
						/*
						 * rubbing dick doesn't count towards time taken; savvy players might use this to establish a pace
						 */
					}
					else
					{
						specialSpotTimeTaken++;
					}
					lastFourUniqueSpecialRubs.push(newRub);
					lastFourUniqueSpecialRubs.splice(0, lastFourUniqueSpecialRubs.length - 4);
				}
			}

			if (specialSpotChain.indexOf(specialRub) > -1 && specialRubs[specialRubs.length - 1] != specialRubs[specialRubs.length - 2])
			{
				if (StringTools.startsWith(specialRub, "left-") || StringTools.startsWith(specialRub, "right-"))
				{
					specialSpotChain.remove("right-" + MmStringTools.substringAfter(specialRub, "-"));
					specialSpotChain.remove("left-" + MmStringTools.substringAfter(specialRub, "-"));

					if (StringTools.startsWith(specialRub, "left-"))
					{
						specialSpotChain.push("right-" + MmStringTools.substringAfter(specialRub, "-"));
					}
					else if (StringTools.startsWith(specialRub, "right-"))
					{
						specialSpotChain.push("left-" + MmStringTools.substringAfter(specialRub, "-"));
					}
				}

				var specialSpotChainCount:Int = 0;
				for (uniqueSpecialRub in lastFourUniqueSpecialRubs)
				{
					if (StringTools.startsWith(uniqueSpecialRub, "good-"))
					{
						specialSpotChainCount++;
					}
				}
				for (specialSpot in specialSpots)
				{
					if (lastFourUniqueSpecialRubs.indexOf(specialSpot) != -1)
					{
						specialSpotChainCount++;
					}
				}
				if (specialSpotChainCount >= 3)
				{
					niceThings[0] = false;
					doNiceThing(0.66667);

					// impose a mild penalty if it took them longer than necessary to find the 3 special spots
					if (specialSpotTimeTaken <= 6)
					{
						// perfect; 6 is always possible
					}
					else if (specialSpotTimeTaken <= 9)
					{
						_heartEmitCount -= SexyState.roundUpToQuarter(_heartBank._defaultForeplayHeartReservoir * 0.02);
					}
					else if (specialSpotTimeTaken <= 15)
					{
						_heartEmitCount -= SexyState.roundUpToQuarter(_heartBank._defaultForeplayHeartReservoir * 0.04);
					}
					else
					{
						_heartEmitCount -= SexyState.roundUpToQuarter(_heartBank._defaultForeplayHeartReservoir * 0.06);
					}

					emitWords(pleasureWords);
				}
			}
		}

		if (untouchedSpecialSpots.indexOf(specialRub) >= 0)
		{
			untouchedSpecialSpots.remove(specialRub);
			if (StringTools.startsWith(specialRub, "left-") || StringTools.startsWith(specialRub, "right-"))
			{
				untouchedSpecialSpots.remove("left-" + MmStringTools.substringAfter(specialRub, "-"));
				untouchedSpecialSpots.remove("right-" + MmStringTools.substringAfter(specialRub, "-"));
			}
			doNiceThing(0.22222);
			maybeEmitWords(pleasureWords);
		}

		if (specialRub == "ass")
		{
			assTightness *= FlxG.random.float(0.72, 0.82);
			updateAssFingeringAnimation();
			if (_rubBodyAnim != null)
			{
				_rubBodyAnim.refreshSoon();
			}
			if (_rubHandAnim != null)
			{
				_rubHandAnim.refreshSoon();
			}
		}

		if (specialRub == "jack-off" && !_male)
		{
			vagTightness *= FlxG.random.float(0.72, 0.82);
			updateVaginaFingeringAnimation();
			if (_rubBodyAnim != null)
			{
				_rubBodyAnim.refreshSoon();
			}
			if (_rubHandAnim != null)
			{
				_rubHandAnim.refreshSoon();
			}
		}

		var amount:Float = 0;
		if (specialRub == "jack-off")
		{
			var lucky:Float = 0;

			if (almostWords.timer > 0)
			{
				lucky = 0.12;
			}
			else
			{
				var speed:Float = (_rubHandAnim._prevMouseUpTime + _rubHandAnim._prevMouseDownTime);
				var penaltyAmount:Float = 0;
				jackoffPaceDeviance = speed / targetJackoffSpeed;
				if (jackoffPaceDeviance > 2.20)
				{
					// way too slow
					lucky = 0.01;
					penaltyAmount = SexyState.roundUpToQuarter(0.02 * _heartBank._dickHeartReservoir);
					_breathlessCount++;
				}
				else if (jackoffPaceDeviance > 1.69)
				{
					// too slow
					lucky = 0.03;
					penaltyAmount = SexyState.roundUpToQuarter(0.02 * _heartBank._dickHeartReservoir);
					_breathlessCount++;
				}
				else if (jackoffPaceDeviance > 1.30)
				{
					// a little too slow
					lucky = 0.08;
					targetJackoffSpeed = FlxMath.bound(targetJackoffSpeed * FlxG.random.float(0.90, 1.00), 0.45, 1.8);
					_breathlessCount++;
				}
				else if (jackoffPaceDeviance > 0.76)
				{
					// perfect
					lucky = 0.11;
					targetJackoffSpeed = FlxMath.bound(targetJackoffSpeed * FlxG.random.float(0.90, 1.00), 0.45, 1.8);
				}
				else if (jackoffPaceDeviance > 0.59)
				{
					// a little too fast
					lucky = 0.08;
					scheduleSweat(2);
					penaltyAmount = SexyState.roundUpToQuarter(0.03 * _heartBank._dickHeartReservoir);
				}
				else if (jackoffPaceDeviance > 0.46)
				{
					// too fast
					lucky = 0.05;
					scheduleSweat(3);
					penaltyAmount = SexyState.roundUpToQuarter(0.09 * _heartBank._dickHeartReservoir);
				}
				else if (jackoffPaceDeviance > 0.35)
				{
					// way too fast
					lucky = 0.02;
					scheduleSweat(4);
					_autoSweatRate += 0.03;
					penaltyAmount = SexyState.roundUpToQuarter(0.15 * _heartBank._dickHeartReservoir);
				}
				else
				{
					// way, way too fast
					lucky = 0.02;
					scheduleSweat(6);
					_autoSweatRate += 0.06;
					penaltyAmount = SexyState.roundUpToQuarter(0.21 * _heartBank._dickHeartReservoir);
				}

				_heartBank._dickHeartReservoir -= penaltyAmount;
				badJackoffBank += penaltyAmount;
			}

			amount = SexyState.roundUpToQuarter(lucky * _heartBank._dickHeartReservoir);
			_heartBank._dickHeartReservoir -= amount;
			_heartEmitCount += amount;
		}
		else if (specialRub == "rub-dick")
		{
			var lucky:Float = 0;

			if (almostWords.timer > 0)
			{
				lucky = 0.12;
			}
			else
			{
				var speed:Float = (_rubHandAnim._prevMouseUpTime + _rubHandAnim._prevMouseDownTime);
				var penaltyAmount:Float = 0;
				jackoffPaceDeviance = speed / targetJackoffSpeed;
				if (jackoffPaceDeviance > 2.20)
				{
					// way too slow
					lucky = 0.02;
					_breathlessCount++;
				}
				else if (jackoffPaceDeviance > 1.69)
				{
					// too slow
					lucky = 0.04;
					_breathlessCount++;
				}
				else if (jackoffPaceDeviance > 1.30)
				{
					// a little too slow
					lucky = 0.09;
					_breathlessCount++;
				}
				else if (jackoffPaceDeviance > 0.76)
				{
					// perfect
					lucky = 0.12;
				}
				else if (jackoffPaceDeviance > 0.59)
				{
					// a little too fast
					lucky = 0.09;
					penaltyAmount = SexyState.roundUpToQuarter(0.03 * _heartBank._foreplayHeartReservoir);
					scheduleSweat(2);
				}
				else if (jackoffPaceDeviance > 0.46)
				{
					// too fast
					lucky = 0.06;
					penaltyAmount = SexyState.roundUpToQuarter(0.09 * _heartBank._foreplayHeartReservoir);
					scheduleSweat(3);
				}
				else
				{
					// way too fast
					lucky = 0.03;
					penaltyAmount = SexyState.roundUpToQuarter(0.15 * _heartBank._foreplayHeartReservoir);
					scheduleSweat(4);
					_autoSweatRate += 0.03;
				}
				_heartBank._foreplayHeartReservoir -= penaltyAmount;
				badRubBank += penaltyAmount;
			}

			amount = SexyState.roundUpToQuarter(lucky * _heartBank._foreplayHeartReservoir);
			_heartBank._foreplayHeartReservoir -= amount;
			_heartEmitCount += amount;
		}
		else {
			var scalar:Float = 0.01;

			if (specialRub == "left-foot" || specialRub == "right-foot")
			{
				scalar = 0.10;
			}
			else if (specialRub == "belly")
			{
				scalar = 0.09;
			}
			else if (specialRub == "left-thigh" || specialRub == "right-thigh")
			{
				scalar = 0.08;
			}
			else if (specialRub == "spike")
			{
				scalar = 0.07;
			}
			else if (specialRub == "tail")
			{
				scalar = 0.06;
			}
			else if (specialRub == "head")
			{
				scalar = 0.05;
			}
			else if (specialRub == "ass")
			{
				scalar = 0.04;
			}
			else if (specialRub == "balls")
			{
				scalar = 0.03;
			}
			else if (specialRub == "left-shoulder" || specialRub == "right-shoulder")
			{
				scalar = 0.02;
			}
			else if (specialRub == "chest")
			{
				scalar = 0.01;
			}

			if (specialSpots.indexOf(specialRub) != -1)
			{
				if (lastFourUniqueSpecialRubs[lastFourUniqueSpecialRubs.length - 1] != null && StringTools.startsWith(lastFourUniqueSpecialRubs[lastFourUniqueSpecialRubs.length - 1], "bad-"))
				{
				}
				else
				{
					// it's something lucario reeeally likes
					scalar = 0.13;
					niceSpecialSpotFace = true;
					if (_newHeadTimer > 1.5 && _pokeWindow._arousal < 2)
					{
						_newHeadTimer = FlxG.random.float(0, 1.5);
					}
				}
			}

			amount = SexyState.roundUpToQuarter(lucky(0.8, 1.25, scalar) * _heartBank._foreplayHeartReservoir);
			_heartBank._foreplayHeartReservoir -= amount;
			_heartEmitCount += amount;

			if (specialRub == "ass")
			{
				scalar = 0.01;
				if (assTightness > 3)
				{
					scalar = 0.01;
				}
				else if (assTightness > 1.8)
				{
					scalar = 0.02;
				}
				else if (assTightness > 1.08)
				{
					scalar = 0.04;
				}
				else if (assTightness > 0.65)
				{
					scalar = 0.06;
				}
				else
				{
					scalar = 0.08;
				}
				var dickReservoirLimit:Float = 0.95;
				if (niceThings[0] == false)
				{
					if (specialSpotTimeTaken >= 14)
					{
						dickReservoirLimit = 0.85;
					}
					else if (specialSpotTimeTaken >= 10)
					{
						dickReservoirLimit = 0.75;
					}
					else if (specialSpotTimeTaken >= 8)
					{
						dickReservoirLimit = 0.65;
					}
					else if (specialSpotTimeTaken >= 6)
					{
						dickReservoirLimit = 0.55;
					}
					else if (specialSpotTimeTaken >= 4)
					{
						// have to be a little lucky... 6 is guaranteed, but 4 needs some luck
						dickReservoirLimit = 0.25;
					}
					else
					{
						dickReservoirLimit = 0.05;
					}
				}
				amount = SexyState.roundDownToQuarter(lucky(0.7, 1.43, scalar) * Math.max(_heartBank._dickHeartReservoir - _heartBank._dickHeartReservoirCapacity * dickReservoirLimit, 0));
				_heartBank._dickHeartReservoir -= amount;
				_heartEmitCount += amount;

				if (dickReservoirLimit < _cumThreshold && scalar >= 0.05)
				{
					niceSpecialSpotFace = true;
				}
			}
		}

		if (_remainingOrgasms > 0 && _heartBank.getDickPercent() < _cumThreshold + 0.08 && !isEjaculating())
		{
			maybeEmitWords(almostWords);
		}

		emitCasualEncouragementWords();
		if (_heartEmitCount > 0)
		{
			maybeScheduleBreath();
			maybePlayPokeSfx();
			maybeEmitPrecum();
		}
	}

	private function updateAssFingeringAnimation():Void
	{
		var tightness0:Int = 3;

		if (assTightness > 3.3)
		{
			tightness0 = 3;
		}
		else if (assTightness > 2.3)
		{
			tightness0 = 4;
		}
		else if (assTightness > 1.5)
		{
			tightness0 = 5;
		}
		else if (assTightness > 1.0)
		{
			tightness0 = 6;
		}
		else {
			tightness0 = 7;
		}

		_pokeWindow.ass.animation.getByName("finger-ass").frames = [1, 2, 3, 4, 5, 6, 7].slice(0, tightness0);
		_pokeWindow._interact.animation.getByName("finger-ass").frames = [21, 22, 23, 24, 25, 26, 27].slice(0, tightness0);
	}

	private function updateVaginaFingeringAnimation():Void
	{
		var tightness0:Int = 3;

		if (vagTightness > 3.33)
		{
			tightness0 = 6;
		}
		else if (vagTightness > 2.18)
		{
			tightness0 = 7;
		}
		else if (vagTightness > 1.44)
		{
			tightness0 = 8;
		}
		else {
			tightness0 = 9;
		}

		_pokeWindow._dick.animation.getByName("jack-off").frames = [0, 1, 2, 3, 4, 5, 6, 7, 8].slice(0, tightness0);
		_pokeWindow._interact.animation.getByName("jack-off").frames = [42, 43, 44, 45, 46, 47, 48, 49, 50].slice(0, tightness0);
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();

		dildoUtils.reinitializeHandSprites();
		if (toyShadowBalls == null) toyShadowBalls = new BouncySprite(0, 0, 0, 0, 0, 0);
		if (PlayerData.cursorType == "none")
		{
			toyShadowBalls.makeGraphic(1, 1, FlxColor.TRANSPARENT);
			toyShadowBalls.alpha = 0.75;
		}
		else
		{
			toyShadowBalls.loadGraphicFromSprite(toyWindow.balls);
			toyShadowBalls.alpha = 0.75;
		}
	}

	override public function eventShowToyWindow(args:Array<Dynamic>)
	{
		super.eventShowToyWindow(args);
		dildoUtils.showToyWindow();
		if (_male)
		{
			_shadowGloveBlackGroup.add(toyShadowBalls);
			_blobbyGroup.add(_shadowGloveBlackGroup);
		}

		if (toyWindow.isXlDildo() && !isXlDildoFittingEasily())
		{
			toyInterface.setTightness(5.5, 5.5);
		}
		else
		{
			toyInterface.setTightness(assTightness * 0.8, vagTightness * 0.6);
		}
		ambientDildoBankCapacity = SexyState.roundUpToQuarter(_toyBank._foreplayHeartReservoir * 0.08);
		pleasurableDildoBankCapacity = SexyState.roundUpToQuarter(_toyBank._foreplayHeartReservoir * 0.16);
		toyClitWords.timer = FlxG.random.float( -30, 90);
	}

	override public function eventHideToyWindow(args:Array<Dynamic>)
	{
		super.eventHideToyWindow(args);

		dildoUtils.hideToyWindow();
		if (_male)
		{
			if (toyShadowBalls != null)
			{
				_shadowGloveBlackGroup.remove(toyShadowBalls);
			}
			_blobbyGroup.remove(_shadowGloveBlackGroup);
		}

		if (toyWindow.isXlDildo() && !isXlDildoFittingEasily())
		{
			// maintain old tightness
		}
		else
		{
			assTightness = toyInterface.assTightness / 0.8;
			vagTightness = toyInterface.assTightness / 0.6;
		}

		if (toyWindow.isXlDildo() && !isXlDildoFitting())
		{
			if (toyInterruptWords.timer <= 0)
			{
				// didn't emit toy interrupt words; emit apologetic words
				maybeEmitWords(toyXlWords);
			}
		}
	}

	override function cursorSmellPenaltyAmount():Int
	{
		return 55;
	}

	override public function destroy():Void
	{
		super.destroy();

		assPolyArray = null;
		leftCalfPolyArray = null;
		rightCalfPolyArray = null;
		chestSpikePolyArray = null;
		leftShoulderDownPolyArray = null;
		leftShoulderUpPolyArray = null;
		rightShoulderDownPolyArray = null;
		rightShoulderUpPolyArray = null;
		leftThighPolyArray = null;
		rightThighPolyArray = null;
		tailPolyArray = null;
		vagPolyArray = null;

		lastFourUniqueSpecialRubs = null;
		specialSpots = null;
		untouchedSpecialSpots = null;
		specialSpotChain = null;

		toyWindow = FlxDestroyUtil.destroy(toyWindow);
		toyInterface = FlxDestroyUtil.destroy(toyInterface);
		toyShadowBalls = FlxDestroyUtil.destroy(toyShadowBalls);
		remainingToyPattern = null;
		dildoUtils = FlxDestroyUtil.destroy(dildoUtils);
		toyClitWords = null;
		toyXlWords = null;
	}
}