package poke.grim;
import demo.SexyDebugState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import kludge.FlxSoundKludge;
import openfl.utils.Object;
import poke.sexy.SexyState;
import poke.sexy.WordManager.Qord;

/**
 * Sex sequence for Grimer
 * 
 * Many Pokemon are easy to tell what they like, because they emit hearts on a
 * certain rhythm. So if they emit a lot of hearts, it's good, and if they emit
 * fewer hearts. it's bad. Grimer complicates this because her hearts sort of
 * trickle out at a constant pace, so it's harder to tell if she likes something.
 * 
 * Grimer's anatomy is confusing. She has seven sub-dermal body parts you can
 * rub, and they are always shifting around, and they don't correspond with
 * human anatomy. But her body parts will fall into one of seven sections of
 * her body; the upper-left, left, lower-left, upper-right, right, lower-right,
 * and center. And they always serve the same purpose from game to game, so you
 * can remember which ones are good or bad based on the motion your hand makes:
 * 
 *  - Her vagina is always on the lower-left or lower-right part of her body.
 *  - Her mercaptanary polyp will always be on the left, or right section of
 *    her body -- opposite her vagina. this part of her body makes your hand do
 *    a squeezy motion like you're squeezing testicles. she doesn't like when
 *    you touch this.
 *  - Her other body parts are arranged in random locations, but you can
 *    distinguish them based on the motion your hand makes:
 *    - she has a mysterious second orifice where your hand does a motion as
 *      though pushing fingers into a cavity. she likes when you finger this.
 *    - she has a mysterious growth where your hand does a motion like
 *      squeezing a boob. she likes when you squeeze this.
 *    - she has a salivary lumpus, your hand will do a motion like squeezing
 *      testicles, just like when you grab her mercaptanary polyp. she likes
 *      when you squeeze this, but how can you tell you're grabbing the right
 *      one? ...Well, once you find her vagina, you will know the position of
 *      her mercaptanary polyp, as it's on the left or right side, opposite the
 *      vagina. This will be somewhere else.
 * 
 * So, those are the 3 places she likes to have rubbed. Only two of those will
 * ever be accessible, one of them is hidden somewhere you can not reach.
 * 
 *  - She has a thiolic artery, your hand will stroke it like stroking
 *    someone's leg. She doesn't particularly care if you rub this.
 *  - She has a jejunal bulb; you will rub your finger around it like stroking
 *    someone's nipple. She doesn't like this.
 * 
 * To really pleasure grimer, you have to do two things if she is female, and
 * three things if she is male. When you do these things, she'll emit a lot of
 * hearts and say something pleasured.
 * 
 *  - There's five parts of her body she likes when you rub, or is at least
 *    neutral towards. Her vagina, the three places mentioned earlier, and her
 *    thiolic artery (which she doesn't particularly like or hate.) One of
 *    these is inaccessible, so only four are accessible. You need to find and
 *    rub three of these four areas.
 *  - After rubbing her enough, she will be aroused, and fingering her vagina
 *    will give her pleasure and eventually make her orgasm. It's obvious when
 *    she's aroused as a male, as she'll have a boner. It's more subtle as a
 *    female, but your hand will have a different penetrating animation where
 *    it turns sideways and all of your fingers go in. After she's aroused and
 *    you've rubbed her vagina for a bit, she likes it if you mix it up by
 *    rubbing one of the three places she likes.
 *  - If she is male, you need to locate her penis before it pokes out of her
 *    goo, and rub it a little.
 * 
 * Additionally, she likes eating. So if you feed her one of the sex toys, in
 * addition to emitting some hearts right away, she'll have a more powerful
 * orgasm than usual. Feeding her happy meal toys works too, but the effect is
 * diminished by about 40%.
 * 
 * After playing with Grimer, other Pokemon will be able to sense it for about
 * 15 minutes. Sandslash likes the smell, Magnezone is indifferent, and Rhydon
 * only minds a little. But most of the other pokemon don't like it at all, and
 * will not be happy if they are stuck playing with you. You can avoid the
 * smell by wearing hazard gloves beforehand.
 */
class GrimerSexyState extends SexyState<GrimerWindow>
{
	private static var SUBMERGED_BRUSH_MIN_DIST:Float = 14; // how close does our hand need to be to "brush up against" something?
	private static var SUBMERGED_BRUSH_MAX_DIST:Float = 20; // how far does our hand need to be to leave the alert radius?
	private static var SUBMERGED_RUBS:Array<String> = [
				"rub-hidden-dick",
				"finger-cavity-good", // push in a few fingers; like inserting into something (good)
				"fondle-valve-good", // grab four fingers; like a boob (good)
				"squeeze-lumpus-good", // salivary lumpus; squeeze gently like testicles (good)

				"stroke-artery-ok", // run hand along something thick; like a leg (neutral)

				"rub-bulb-bad", // rub in a circle; like a nipple (bad)
				"squeeze-polyp-bad" // mercaptanary polyp; squeeze gently like testicles (bad)
			];
	private static var GOOP_MAP:Array<Map<Int, Int>> = [
				[8 => 0, 9 => 1, 10 => 2],
				[8 => 3, 9 => 4, 10 => 5],
				[8 => 6, 9 => 7, 10 => 8],
				[8 => 9, 9 => 10, 10 => 11],
				[8 => 12, 9 => 13, 10 => 14],
			];

	public var grimerMood0:Int = FlxG.random.int(0, 1); // is grimer's dick on the left or right side?
	public var grimerMood1:Int = FlxG.random.int(0, 2); // which of grimer's "good rubs" are available this time?

	private var shallowEnd:Array<Array<FlxPoint>> = []; // polygon for the part of grimer which the hand can get its fingertips in...
	private var deepEnd:Array<Array<FlxPoint>> = []; // polygon for the part of grimer which the hand gets submerged in...
	private var unsubmergePoint:FlxPoint = null;

	/**
	 * "doops" are the locations of Grimer's interesting things to rub.
	 * These are all underneath his slimy exterior and can only be rubbed when
	 * the hand is fully submerged.
	 */
	private var doops:Array<FlxPoint>;

	private var goopyHand:FlxSprite;
	private var handSubmergedPct:Float = 0;
	private var targetHandSubmergedPct:Float = 0;

	private var alertAlphaTween:FlxTween;
	private var alertShakeTimer:Float = 0;
	private var alertSprite:FlxSprite;
	private var playRubAlertSound:Bool = false;
	private var brushedDoopIndex:Int = -1;

	/*
	 * niceThings[0] = rub 3 out of a possible 4 nice spots
	 * niceThings[1] = after fingering grimer's pussy, go back and rub two nice spots
	 * niceThings[2] = (male only) find grimer's cock before he gets hard
	 */
	private var niceThings:Array<Bool> = [true, true, true];
	/*
	 * meanThings[0] = squeeze grimer's gross place
	 * meanThings[1] = rub grimer's uncomfortable thing
	 */
	private var meanThings:Array<Bool> = [true, true];

	private var distinctWeirdRubCount:Int = 0;
	private var rubbedHiddenDickInTime:Bool = false;
	private var dickWasVisible:Bool = false;
	private var remainingRubs:Array<String> = ["dick", "finger-cavity-good", "fondle-valve-good", "squeeze-lumpus-good", "stroke-artery-ok"];

	/*
	 * When the player does something Grimer likes, it's sometimes hard to
	 * tell. A lot of the reward gets absorbed into this weirdBonus and emitted
	 * later during orgasms or when rubbing Grimer's genitals
	 */
	private var weirdBonus:Float = 0;
	private var heartPenalty:Float = 1.0;

	/*
	 * When the player does something Grimer likes, it results in a
	 * hearts-over-time effect rather than them all coming out at once. Those
	 * hearts-over-time are stored in this field
	 */
	private var soonHeartEmitCount:Float = 0;
	private var slowHeartEmitFrequency:Float = 0.6;
	private var slowHeartEmitTimer:Float = 0;

	private var weirdRubWords:Qord;

	private var smallPurpleBeadsButton:FlxButton;
	private var gummyDildoButton:FlxButton;
	private var happyMealButton:FlxButton;

	override public function create():Void
	{
		prepare("grim");

		doops = [];

		var otherRects:Array<FlxRect> = [];

		var rectBuffer:Float = SUBMERGED_BRUSH_MIN_DIST;

		var nwRect:FlxRect = FlxRect.get( -60, -80, 60 - rectBuffer / 2, 30 - rectBuffer / 2);
		var neRect:FlxRect = FlxRect.get( 0 + rectBuffer / 2, -80, 60 - rectBuffer / 2, 30 - rectBuffer / 2);

		var wRect:FlxRect = FlxRect.get( -80, -50 + rectBuffer / 2, 50 - rectBuffer / 2, 40 - rectBuffer);
		var cRect:FlxRect = FlxRect.get( -30 + rectBuffer / 2, -50 + rectBuffer / 2, 60 - rectBuffer, 40 - rectBuffer);
		var eRect:FlxRect = FlxRect.get( 30 + rectBuffer / 2, -50 + rectBuffer / 2, 50 - rectBuffer / 2, 40 - rectBuffer);

		var swRect:FlxRect = FlxRect.get( -40, -10 + rectBuffer / 2, 40 - rectBuffer / 2, 50 - rectBuffer / 2);
		var seRect:FlxRect = FlxRect.get( 0 + rectBuffer / 2, -10 + rectBuffer / 2, 40 - rectBuffer / 2, 50 - rectBuffer / 2);

		otherRects.push(nwRect);
		otherRects.push(neRect);
		otherRects.push(wRect);
		otherRects.push(cRect);
		otherRects.push(eRect);
		otherRects.push(swRect);
		otherRects.push(seRect);

		if (grimerMood0 == 0)
		{
			// dick on left side
			doops[0] = randomPointInRect(swRect);
			otherRects.remove(swRect);
			// bad thing on right side
			doops[6] = randomPointInRect(eRect);
			otherRects.remove(eRect);
		}
		else {
			// dick on left side
			doops[0] = randomPointInRect(seRect);
			otherRects.remove(seRect);
			// bad thing on right side
			doops[6] = randomPointInRect(wRect);
			otherRects.remove(wRect);
		}

		FlxG.random.shuffle(otherRects);

		if (grimerMood1 != 0) doops[1] = randomPointInRect(otherRects.pop());
		if (grimerMood1 != 1) doops[2] = randomPointInRect(otherRects.pop());
		if (grimerMood1 != 2) doops[3] = randomPointInRect(otherRects.pop());
		doops[4] = randomPointInRect(otherRects.pop());
		doops[5] = randomPointInRect(otherRects.pop());

		super.create();

		if (!_male)
		{
			// female grimer doesn't have the idea of "rubbing the dick before it becomes visible"
			niceThings[2] = false;
		}

		weirdRubWords.timer = FlxG.random.float( -30, 180);

		sfxEncouragement = [AssetPaths.grim0__mp3, AssetPaths.grim1__mp3, AssetPaths.grim2__mp3, AssetPaths.grim3__mp3];
		sfxPleasure = [AssetPaths.grim4__mp3, AssetPaths.grim5__mp3, AssetPaths.grim6__mp3];
		sfxOrgasm = [AssetPaths.grim7__mp3, AssetPaths.grim8__mp3, AssetPaths.grim9__mp3];

		popularity = -0.4;
		cumTrait0 = 1;
		cumTrait1 = 3;
		cumTrait2 = 7;
		cumTrait3 = 9;
		cumTrait4 = 3;

		_characterSfxFrequency = 3.6;
		_headTimerFactor = 1.8;

		_blobbyGroup._blobColour = 0x9677b6;
		_blobbyGroup._blobOpacity = 0xff;
		_blobbyGroup._shineColour = 0xe5daed;
		_blobbyGroup._shineThreshold = 0x18;

		_pokeWindow._dick.x += doops[0].x;
		_pokeWindow._dick.y += doops[0].y;

		_frontSprites.add(goopyHand);

		alertSprite = new FlxSprite(0, 0);
		alertSprite.loadGraphic(AssetPaths.grab_alert__png, true, 30, 30);
		alertSprite.animation.add("default", AnimTools.blinkyAnimation([0, 1, 2, 3]), 3);
		alertSprite.animation.play("default");
		alertSprite.visible = false;
		_frontSprites.add(alertSprite);

		var whichItems:Int = FlxG.random.int(0, 2);

		if (ItemDatabase.playerHasUneatenItem(ItemDatabase.ITEM_GUMMY_DILDO))
		{
			gummyDildoButton = newToyButton(gummyDildoButtonEvent, AssetPaths.dildo_gummy_button__png, _dialogTree);
			addToyButton(gummyDildoButton, isHungry() ? 1.0 : 0.25);
		}
		if (ItemDatabase.playerHasUneatenItem(ItemDatabase.ITEM_SMALL_PURPLE_BEADS))
		{
			smallPurpleBeadsButton = newToyButton(smallPurpleBeadsEvent, AssetPaths.smallbeads_purple_button__png, _dialogTree);
			addToyButton(smallPurpleBeadsButton, isHungry() ? 1.0 : 0.25);
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_HAPPY_MEAL))
		{
			happyMealButton = newToyButton(happyMealEvent, AssetPaths.happy_meal_button__png, _dialogTree);
			addToyButton(happyMealButton, isHungry() ? 1.0 : 0.25);
		}
	}

	private function isHungry():Bool
	{
		return _toyBank._dickHeartReservoir > 0 && PlayerData.grimEatenItem == -1 && PlayerData.grimMoneyOwed == 0;
	}

	private function gummyDildoButtonEvent():Void
	{
		playButtonClickSound();
		var tree:Array<Array<Object>> = [];
		if (computeBonusToyCapacity() == 0 || !isHungry())
		{
			GrimerDialog.notHungry(tree);
			removeToyButton(gummyDildoButton);
		}
		else {
			GrimerDialog.eatGummyDildo(tree);
		}
		showEarlyDialog(tree);
	}

	private function smallPurpleBeadsEvent():Void
	{
		playButtonClickSound();
		var tree:Array<Array<Object>> = [];
		if (computeBonusToyCapacity() == 0 || !isHungry())
		{
			GrimerDialog.notHungry(tree);
			removeToyButton(smallPurpleBeadsButton);
		}
		else {
			GrimerDialog.eatSmallPurpleBeads(tree);
		}
		showEarlyDialog(tree);
	}

	private function happyMealEvent():Void
	{
		playButtonClickSound();
		var tree:Array<Array<Object>> = [];
		if (computeBonusToyCapacity() == 0 || !isHungry())
		{
			GrimerDialog.notHungry(tree);
			removeToyButton(happyMealButton);
		}
		else {
			GrimerDialog.eatHappyMeal(tree);
		}
		showEarlyDialog(tree);
	}

	override function dialogTreeCallback(Msg:String):String
	{
		super.dialogTreeCallback(Msg);
		if (Msg == "%eat-gummydildo%")
		{
			removeToyButton(gummyDildoButton);
			eatSomething();
			PlayerData.grimEatenItem = ItemDatabase.ITEM_GUMMY_DILDO;
			PlayerData.grimMoneyOwed = ItemDatabase.roundUpPrice(ItemDatabase._itemTypes[ItemDatabase.ITEM_GUMMY_DILDO].basePrice * FlxG.random.float(1.0, 2.0));
			PlayerData.grimChats.insert(0, FlxG.random.int(50, 99));
			ItemDatabase._warehouseItemIndexes.push(ItemDatabase.ITEM_GUMMY_DILDO);
		}
		if (Msg == "%eat-smallpurplebeads%")
		{
			removeToyButton(smallPurpleBeadsButton);
			eatSomething();
			PlayerData.grimEatenItem = ItemDatabase.ITEM_SMALL_PURPLE_BEADS;
			PlayerData.grimMoneyOwed = ItemDatabase.roundUpPrice(ItemDatabase._itemTypes[ItemDatabase.ITEM_SMALL_PURPLE_BEADS].basePrice * FlxG.random.float(1.0, 2.0));
			PlayerData.grimChats.insert(0, FlxG.random.int(50, 99));
			ItemDatabase._warehouseItemIndexes.push(ItemDatabase.ITEM_SMALL_PURPLE_BEADS);
		}
		if (Msg == "%eat-happymeal%")
		{
			removeToyButton(happyMealButton);
			eatSomething(0.6);
		}
		return null;
	}

	/**
	 * Feed grimer an item. This spits out a few hearts immediately, a few
	 * hearts later, and also gives you better chest rewards in the short term
	 *
	 * @param	reward percent reward to offer, [0.0, 1.0]
	 */
	private function eatSomething(?reward:Float = 1.0):Void
	{
		_toyBank._dickHeartReservoir = SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * reward);

		var amount0:Float = SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * 0.25);
		_toyBank._dickHeartReservoir -= amount0;
		var amount1:Float = SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * 0.33);
		_toyBank._dickHeartReservoir -= amount1;
		var amount2:Float = SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * 0.50);
		_toyBank._dickHeartReservoir -= amount2;
		var amount3:Float = SexyState.roundUpToQuarter(_toyBank._dickHeartReservoir * 1.00);
		_toyBank._dickHeartReservoir -= amount3;

		_heartBank._foreplayHeartReservoir += amount0;
		_heartBank._dickHeartReservoir += amount1;
		_heartEmitCount += amount2;
		// add more gems into the puzzle chests
		PlayerData.reimburseCritterBonus(Std.int(amount3));
	}

	private static function randomPointInRect(rect:FlxRect):FlxPoint
	{
		return FlxPoint.get(FlxG.random.float(rect.left, rect.right), FlxG.random.float(rect.top, rect.bottom));
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();

		_handSprite.animation.add("submerged", [8], 6, true);

		if (goopyHand == null)
		{
			goopyHand = new FlxSprite(0, 0);
		}
		goopyHand.loadGraphic(AssetPaths.grimer_goopy_fingers__png, true, 160, 160);
		goopyHand.setSize(3, 3);
		goopyHand.offset.set(69, 87);
		goopyHand.visible = false;
		if (PlayerData.cursorType == "none")
		{
			goopyHand.alpha = 0;
		}
	}

	override public function sexyStuff(elapsed:Float):Void
	{
		super.sexyStuff(elapsed);

		setInactiveDickAnimation();

		if (_male && fancyRubbing(_dick) && _dick.animation.name == "boner0" && _rubHandAnim._flxSprite.animation.name != "rub-dick" && _rubHandAnim.nearMinFrame())
		{
			_rubHandAnim.setAnimName("rub-dick");
		}

		if (_male && fancyRubbing(_dick) && _dick.animation.name == "boner1" && _rubHandAnim._flxSprite.animation.name != "jack-off" && _rubHandAnim.nearMinFrame())
		{
			_rubHandAnim.setAnimName("jack-off");
		}

		if (soonHeartEmitCount > 0)
		{
			slowHeartEmitTimer -= elapsed;
			if (slowHeartEmitTimer < 0)
			{
				slowHeartEmitTimer += FlxG.random.float(0, slowHeartEmitFrequency * 2);

				var amount:Float = SexyState.roundUpToQuarter(soonHeartEmitCount * 0.2);
				_heartEmitCount += amount;
				soonHeartEmitCount -= amount;

				if (encouragementWords.timer < _characterSfxTimer)
				{
					maybeEmitWords(encouragementWords);
				}
				maybePlayPokeSfx();

				if (!_male && pastBonerThreshold())
				{
					if (_remainingOrgasms > 0 && _autoSweatRate < 0.3)
					{
						_autoSweatRate += 0.01;
					}
				}
			}
		}
	}

	override public function touchPart(touchedPart:FlxSprite):Bool
	{
		if (FlxG.mouse.justPressed)
		{
			if (isHandFullySubmerged() && brushedDoopIndex == 0)
			{
				// they clicked our dick, while their hand was buried in the goop...
				var dickAnim:String = _dick.animation.name;
				var handAnim:String = SUBMERGED_RUBS[brushedDoopIndex];
				if (!_male && pastBonerThreshold())
				{
					handAnim = "jack-off";
				}
				interactOn(_dick, handAnim, dickAnim);
				// reposition fingers in front of everything
				_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.members.indexOf(_pokeWindow._arms) + 1);
				// rubbing dick; dick is a half sprite, so we move hand down
				_pokeWindow._interact.y -= 266;
				_rubBodyAnim.enabled = false;
				_pokeWindow.sync(_dick);
				return true;
			}
			if (isHandFullySubmerged() && brushedDoopIndex != -1)
			{
				// they clicked something buried in the goop... we "interact on" the head as a placeholder
				var headBackAnim:String = _pokeWindow._headBack.animation.name;
				interactOn(_pokeWindow._headBack, SUBMERGED_RUBS[brushedDoopIndex], headBackAnim);
				// reposition fingers in front of everything
				_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.members.indexOf(_pokeWindow._arms) + 1);
				// rubbing something other than the dick; reposition hand relative to body
				_pokeWindow._interact.x = _pokeWindow._torso.x + doops[brushedDoopIndex].x;
				_pokeWindow._interact.y = _pokeWindow._torso.y + doops[brushedDoopIndex].y;
				_rubBodyAnim.enabled = false;
				_pokeWindow.sync(_pokeWindow._headBack);
				return true;
			}

			if (_dick.visible && _dick.animation.frameIndex != 0)
			{
				// dick is visible; did they click in the approximate area?
				var touchedPart:FlxSprite = _pokeWindow._torso;
				var dist:Float = FlxG.mouse.getWorldPosition().distanceTo(FlxPoint.get((176 + doops[0].x) - touchedPart.offset.x + touchedPart.x, (342 + doops[0].y) - touchedPart.offset.y + touchedPart.y));
				if (dist < 20)
				{
					var dickAnim:String = _dick.animation.name;
					if (_gameState == 200 && pastBonerThreshold())
					{
						interactOn(_dick, "jack-off");
					}
					else
					{
						interactOn(_dick, "rub-dick");
					}
					// reposition fingers in front of everything
					_pokeWindow.reposition(_pokeWindow._interact, _pokeWindow.members.indexOf(_pokeWindow._arms) + 1);
					_pokeWindow._interact.y -= 266;
					_rubBodyAnim.enabled = false;
					_pokeWindow.playDickAnimation(dickAnim);
					return true;
				}
			}
		}
		return false;
	}

	private function getClosestDoopIndex(?maxDist:Float = 10000)
	{
		var closestDoopIndex:Int = -1;
		var closestDoopDist:Float = maxDist;
		for (i in 0...doops.length)
		{
			var dist:Float = getDoopDist(i);
			if (dist <= closestDoopDist)
			{
				closestDoopDist = dist;
				closestDoopIndex = i;
			}
		}
		return closestDoopIndex;
	}

	private function getDoopDist(doopIndex:Int):Float
	{
		if (doops[doopIndex] == null)
		{
			// nowhere nearby
			return 1000000;
		}
		var partPosition:FlxPoint = FlxPoint.get(
			(176 + doops[doopIndex].x) - _pokeWindow._torso.offset.x + _pokeWindow._torso.x,
			(342 + doops[doopIndex].y) - _pokeWindow._torso.offset.y + _pokeWindow._torso.y);
		var dist:Float = FlxG.mouse.getWorldPosition().distanceTo(partPosition);
		partPosition.put();
		return dist;
	}

	override function shouldInteractOff(targetSprite:FlxSprite)
	{
		/*
		 * none of our interactions have a visible effect; the usual "interact
		 * off" behavior is to snap the body part back to its default state,
		 * but that doesn't make sense for Grimer
		 */
		return false;
	}

	override function endSexyStuff():Void
	{
		super.endSexyStuff();

		// emit any leftover hearts
		_heartEmitCount += soonHeartEmitCount;
		soonHeartEmitCount = 0;
	}

	function setInactiveDickAnimation():Void
	{
		if (_male)
		{
			if (_gameState >= 400)
			{
				// don't mess with it anymore; it's event based after the game ends
			}
			else if (pastBonerThreshold())
			{
				if (_dick.animation.name != "boner1")
				{
					_pokeWindow.playDickAnimation("boner1");
					dickWasVisible = true;
				}
			}
			else if (_heartBank.getForeplayPercent() < 0.64)
			{
				if (_dick.animation.name != "boner0")
				{
					_pokeWindow.playDickAnimation("boner0");
					dickWasVisible = true;
				}
			}
			else
			{
				if (_dick.animation.name != "default")
				{
					_pokeWindow.playDickAnimation("default");
				}
			}
		}
		else {
			if (_dick.animation.frameIndex != 0)
			{
				_pokeWindow.playDickAnimation("default");
			}
		}
	}

	override function getTouchedPart():BouncySprite
	{
		if (SexyDebugState.debug)
		{
			// when we're in debug mode trying to pick polygons and stuff, just behave normally
		}
		else if (_pokeWindow._partAlpha == 0)
		{
			// pokemon left; can't interact
		}
		else {
			var pos:FlxPoint = _cSatellite.getPosition();
			if (clickedPolygon(_pokeWindow._torso, deepEnd, pos))
			{
				// clicked shallow area
				targetHandSubmergedPct = 1.00;
				return _pokeWindow._torso;
			}
			if (clickedPolygon(_pokeWindow._torso, shallowEnd, pos))
			{
				// clicked shallow area
				targetHandSubmergedPct = 0.30;
				return _pokeWindow._torso;
			}
			// didn't click inside torso; unsubmerge hand
			targetHandSubmergedPct = 0;
			handSubmergedPct = 0;
		}
		return super.getTouchedPart();
	}

	override function playMundaneRubAnim(touchedPart:FlxSprite):Void
	{
		if (handSubmergedPct > 0)
		{
			// if the hand is submerged, it always uses the same 3-frame animation
			_handSprite.animation.play("rub-center");

			if (isHandFullySubmerged())
			{
				// hand is fully submerged; check for submerged things more frequently
				_rubCheckTimer += SexyState.RUB_CHECK_FREQUENCY / 2;
			}
			return;
		}

		super.playMundaneRubAnim(touchedPart);
	}

	override function endMundaneRub():Void
	{
		if (getGoopIndex() > 0
		&& (unsubmergePoint == null || unsubmergePoint.distanceTo(FlxG.mouse.getWorldPosition()) <= 25))
		{
			_handSprite.animation.play("submerged");
			targetHandSubmergedPct = handSubmergedPct;
			_handSprite.setPosition(FlxG.mouse.x, FlxG.mouse.y);
		}
		else {
			super.endMundaneRub();
		}
	}

	override function updateHand(elapsed:Float):Void
	{
		if (FlxG.mouse.justReleased)
		{
			unsubmergePoint = FlxG.mouse.getWorldPosition();
			fadeAlert();
		}
		else if (FlxG.mouse.justPressed)
		{
			unsubmergePoint = null;
		}

		// hand moves slower as it's submerged
		handDragSpeed = 100 - FlxMath.bound(handSubmergedPct, 0, 1.0) * 50;

		super.updateHand(elapsed);

		if (_handSprite.animation.name == "default")
		{
			// unsubmerge hand
			targetHandSubmergedPct = 0;
			handSubmergedPct = 0;
			alertSprite.visible = false;
			brushedDoopIndex = -1;
		}

		if (handSubmergedPct == targetHandSubmergedPct)
		{
			// do nothing...
		}
		else if (handSubmergedPct < targetHandSubmergedPct)
		{
			handSubmergedPct = Math.min(handSubmergedPct + elapsed * 0.4, targetHandSubmergedPct);
		}
		else {
			handSubmergedPct = Math.max(handSubmergedPct - elapsed * 1.2, targetHandSubmergedPct);
		}

		if (handSubmergedPct > 0 && (_handSprite.animation.frameIndex == 8 || _handSprite.animation.frameIndex == 9 || _handSprite.animation.frameIndex == 10))
		{
			goopyHand.animation.frameIndex = GOOP_MAP[getGoopIndex()][_handSprite.animation.frameIndex];
			goopyHand.setPosition(_handSprite.x, _handSprite.y);
			goopyHand.visible = _handSprite.visible;
		}
		else {
			goopyHand.visible = false;
		}
	}

	override public function playRubSound():Void
	{
		if (playRubAlertSound)
		{
			rubSoundCount++;
			if (shouldRecordMouseTiming())
			{
				mouseTiming.push(_rubHandAnim.sfxLength);
			}
			FlxSoundKludge.play(FlxG.random.getObject([AssetPaths.rub0_slowa__mp3, AssetPaths.rub0_slowb__mp3, AssetPaths.rub0_slowc__mp3]), 0.10);
			_rubSfxTimer -= 0.3;
			playRubAlertSound = false;
		}
		else {
			super.playRubSound();
		}
	}

	private inline function isHandFullySubmerged()
	{
		return getGoopIndex() == 4;
	}

	override public function checkSpecialRub(touchedPart:FlxSprite):Void
	{
		if (_fancyRub)
		{
			specialRub = _rubHandAnim._flxSprite.animation.name;
		}

		// display an alert?
		var oldBrushedDoopIndex:Int = brushedDoopIndex;
		if (!_fancyRub)
		{
			if (!FlxG.mouse.justPressed && handSubmergedPct > 0.5)
			{
				if (getClosestDoopIndex(25) != -1)
				{
					_characterSfxTimer -= 2.2;
				}
			}
			if (!FlxG.mouse.justPressed && isHandFullySubmerged())
			{
				// did our hand brush up against anything?
				var closestDoopIndex = getClosestDoopIndex(SUBMERGED_BRUSH_MIN_DIST);
				if (closestDoopIndex != -1)
				{
					brushedDoopIndex = closestDoopIndex;
				}
				else
				{
					if (brushedDoopIndex != -1)
					{
						if (getDoopDist(brushedDoopIndex) > SUBMERGED_BRUSH_MAX_DIST)
						{
							brushedDoopIndex = -1;
						}
					}
				}
			}
		}
		if (oldBrushedDoopIndex != brushedDoopIndex)
		{
			if (brushedDoopIndex != -1)
			{
				if (oldBrushedDoopIndex == -1 && alertSprite.visible && alertSprite.alpha > 0)
				{
					// was already displaying alert; don't bother shaking it
				}
				else
				{
					FlxTween.tween(alertSprite.scale, {x:1.20, y:1.20}, 0.1, {ease:FlxEase.cubeInOut});
					FlxTween.tween(alertSprite.scale, {x:1.30, y:0.90}, 0.1, {ease:FlxEase.cubeInOut, startDelay:0.1});
					FlxTween.tween(alertSprite.scale, {x:1.00, y:1.00}, 0.1, {ease:FlxEase.cubeInOut, startDelay:0.2});
					playRubAlertSound = true;
				}

				// yes; make the alert visible
				alertSprite.visible = true;
				alertSprite.alpha = 1.0;
				alertSprite.x = doops[brushedDoopIndex].x + 176 + 5 - _pokeWindow._torso.offset.x + _pokeWindow._torso.x;
				alertSprite.y = doops[brushedDoopIndex].y + 342 - 35 - _pokeWindow._torso.offset.y + _pokeWindow._torso.y;

				FlxTweenUtil.cancel(alertAlphaTween);
			}
			else
			{
				fadeAlert();
			}
		}
	}

	public function fadeAlert():Void
	{
		alertAlphaTween = FlxTweenUtil.retween(alertAlphaTween, alertSprite, {alpha:0.0}, 0.6);
	}

	/**
	 * Returns an integer corresponding to how submerged the hand is in
	 * Grimer's goo
	 *
	 * 0 = not submerged
	 * 4 = fully submerged
	 *
	 * @return integer corresponding to how submerged the hand is
	 */
	private function getGoopIndex():Int
	{
		if (handSubmergedPct <= 0.2)
		{
			return 0;
		}
		else if (handSubmergedPct <= 0.4)
		{
			return 1;
		}
		else if (handSubmergedPct <= 0.6)
		{
			return 2;
		}
		else if (handSubmergedPct <= 0.8)
		{
			return 3;
		}
		else {
			return 4;
		}
	}

	override public function initializeHitBoxes():Void
	{
		var torsoSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
		torsoSweatArray[0] = [new FlxPoint(169, 352), new FlxPoint(60, 324), new FlxPoint(60, 240), new FlxPoint(91, 223), new FlxPoint(100, 205), new FlxPoint(180, 239), new FlxPoint(257, 208), new FlxPoint(278, 235), new FlxPoint(301, 246), new FlxPoint(303, 336)];
		torsoSweatArray[1] = [new FlxPoint(169, 352), new FlxPoint(60, 324), new FlxPoint(60, 240), new FlxPoint(91, 223), new FlxPoint(100, 205), new FlxPoint(180, 239), new FlxPoint(257, 208), new FlxPoint(278, 235), new FlxPoint(301, 246), new FlxPoint(303, 336)];
		torsoSweatArray[2] = [new FlxPoint(169, 352), new FlxPoint(60, 324), new FlxPoint(60, 240), new FlxPoint(91, 223), new FlxPoint(100, 205), new FlxPoint(180, 239), new FlxPoint(257, 208), new FlxPoint(278, 235), new FlxPoint(301, 246), new FlxPoint(303, 336)];
		torsoSweatArray[3] = [new FlxPoint(169, 352), new FlxPoint(60, 324), new FlxPoint(60, 240), new FlxPoint(91, 223), new FlxPoint(100, 205), new FlxPoint(180, 239), new FlxPoint(257, 208), new FlxPoint(278, 235), new FlxPoint(301, 246), new FlxPoint(303, 336)];
		torsoSweatArray[4] = [new FlxPoint(169, 352), new FlxPoint(60, 324), new FlxPoint(60, 240), new FlxPoint(91, 223), new FlxPoint(100, 205), new FlxPoint(180, 239), new FlxPoint(257, 208), new FlxPoint(278, 235), new FlxPoint(301, 246), new FlxPoint(303, 336)];

		var headSweatArray:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
		headSweatArray[0] = [new FlxPoint(239, 90), new FlxPoint(213, 107), new FlxPoint(156, 109), new FlxPoint(121, 89), new FlxPoint(147, 67), new FlxPoint(182, 61), new FlxPoint(218, 71)];
		headSweatArray[1] = [new FlxPoint(239, 90), new FlxPoint(213, 107), new FlxPoint(156, 109), new FlxPoint(121, 89), new FlxPoint(147, 67), new FlxPoint(182, 61), new FlxPoint(218, 71)];
		headSweatArray[2] = [new FlxPoint(239, 90), new FlxPoint(213, 107), new FlxPoint(156, 109), new FlxPoint(121, 89), new FlxPoint(147, 67), new FlxPoint(182, 61), new FlxPoint(218, 71)];
		headSweatArray[3] = [new FlxPoint(239, 90), new FlxPoint(213, 107), new FlxPoint(156, 109), new FlxPoint(121, 89), new FlxPoint(147, 67), new FlxPoint(182, 61), new FlxPoint(218, 71)];
		headSweatArray[4] = [new FlxPoint(239, 90), new FlxPoint(213, 107), new FlxPoint(156, 109), new FlxPoint(121, 89), new FlxPoint(147, 67), new FlxPoint(182, 61), new FlxPoint(218, 71)];
		headSweatArray[5] = [new FlxPoint(241, 95), new FlxPoint(205, 111), new FlxPoint(155, 106), new FlxPoint(125, 84), new FlxPoint(156, 66), new FlxPoint(185, 64), new FlxPoint(216, 72)];
		headSweatArray[6] = [new FlxPoint(241, 95), new FlxPoint(205, 111), new FlxPoint(155, 106), new FlxPoint(125, 84), new FlxPoint(156, 66), new FlxPoint(185, 64), new FlxPoint(216, 72)];
		headSweatArray[7] = [new FlxPoint(241, 95), new FlxPoint(205, 111), new FlxPoint(155, 106), new FlxPoint(125, 84), new FlxPoint(156, 66), new FlxPoint(185, 64), new FlxPoint(216, 72)];
		headSweatArray[8] = [new FlxPoint(241, 95), new FlxPoint(205, 111), new FlxPoint(155, 106), new FlxPoint(125, 84), new FlxPoint(156, 66), new FlxPoint(185, 64), new FlxPoint(216, 72)];
		headSweatArray[9] = [new FlxPoint(241, 95), new FlxPoint(205, 111), new FlxPoint(155, 106), new FlxPoint(125, 84), new FlxPoint(156, 66), new FlxPoint(185, 64), new FlxPoint(216, 72)];
		headSweatArray[10] = [new FlxPoint(228, 88), new FlxPoint(198, 110), new FlxPoint(150, 116), new FlxPoint(113, 104), new FlxPoint(134, 81), new FlxPoint(175, 63), new FlxPoint(210, 69)];
		headSweatArray[11] = [new FlxPoint(228, 88), new FlxPoint(198, 110), new FlxPoint(150, 116), new FlxPoint(113, 104), new FlxPoint(134, 81), new FlxPoint(175, 63), new FlxPoint(210, 69)];
		headSweatArray[12] = [new FlxPoint(228, 88), new FlxPoint(198, 110), new FlxPoint(150, 116), new FlxPoint(113, 104), new FlxPoint(134, 81), new FlxPoint(175, 63), new FlxPoint(210, 69)];
		headSweatArray[13] = [new FlxPoint(228, 88), new FlxPoint(198, 110), new FlxPoint(150, 116), new FlxPoint(113, 104), new FlxPoint(134, 81), new FlxPoint(175, 63), new FlxPoint(210, 69)];
		headSweatArray[14] = [new FlxPoint(228, 88), new FlxPoint(198, 110), new FlxPoint(150, 116), new FlxPoint(113, 104), new FlxPoint(134, 81), new FlxPoint(175, 63), new FlxPoint(210, 69)];
		headSweatArray[15] = [new FlxPoint(208, 109), new FlxPoint(153, 106), new FlxPoint(124, 93), new FlxPoint(148, 73), new FlxPoint(178, 68), new FlxPoint(214, 74), new FlxPoint(233, 93)];
		headSweatArray[16] = [new FlxPoint(208, 109), new FlxPoint(153, 106), new FlxPoint(124, 93), new FlxPoint(148, 73), new FlxPoint(178, 68), new FlxPoint(214, 74), new FlxPoint(233, 93)];
		headSweatArray[17] = [new FlxPoint(208, 109), new FlxPoint(153, 106), new FlxPoint(124, 93), new FlxPoint(148, 73), new FlxPoint(178, 68), new FlxPoint(214, 74), new FlxPoint(233, 93)];
		headSweatArray[18] = [new FlxPoint(208, 109), new FlxPoint(153, 106), new FlxPoint(124, 93), new FlxPoint(148, 73), new FlxPoint(178, 68), new FlxPoint(214, 74), new FlxPoint(233, 93)];
		headSweatArray[19] = [new FlxPoint(208, 109), new FlxPoint(153, 106), new FlxPoint(124, 93), new FlxPoint(148, 73), new FlxPoint(178, 68), new FlxPoint(214, 74), new FlxPoint(233, 93)];
		headSweatArray[20] = [new FlxPoint(210, 97), new FlxPoint(150, 103), new FlxPoint(116, 89), new FlxPoint(131, 68), new FlxPoint(172, 53), new FlxPoint(205, 58), new FlxPoint(233, 80)];
		headSweatArray[21] = [new FlxPoint(210, 97), new FlxPoint(150, 103), new FlxPoint(116, 89), new FlxPoint(131, 68), new FlxPoint(172, 53), new FlxPoint(205, 58), new FlxPoint(233, 80)];
		headSweatArray[22] = [new FlxPoint(210, 97), new FlxPoint(150, 103), new FlxPoint(116, 89), new FlxPoint(131, 68), new FlxPoint(172, 53), new FlxPoint(205, 58), new FlxPoint(233, 80)];
		headSweatArray[23] = [new FlxPoint(210, 97), new FlxPoint(150, 103), new FlxPoint(116, 89), new FlxPoint(131, 68), new FlxPoint(172, 53), new FlxPoint(205, 58), new FlxPoint(233, 80)];
		headSweatArray[24] = [new FlxPoint(210, 97), new FlxPoint(150, 103), new FlxPoint(116, 89), new FlxPoint(131, 68), new FlxPoint(172, 53), new FlxPoint(205, 58), new FlxPoint(233, 80)];

		sweatAreas.splice(0, sweatAreas.length);
		sweatAreas.push({chance:3, sprite:_pokeWindow._headBack, sweatArrayArray:headSweatArray});
		sweatAreas.push({chance:7, sprite:_pokeWindow._torso, sweatArrayArray:torsoSweatArray});

		if (_male)
		{
			if (doops[0].x < 0)
			{
				dickAngleArray[1] = [new FlxPoint(174, 69), new FlxPoint(-19, -259), new FlxPoint(-144, -216)];
				dickAngleArray[2] = [new FlxPoint(174, 69), new FlxPoint(-19, -259), new FlxPoint(-144, -216)];
				dickAngleArray[3] = [new FlxPoint(174, 69), new FlxPoint(-19, -259), new FlxPoint(-144, -216)];
				dickAngleArray[4] = [new FlxPoint(174, 69), new FlxPoint(-19, -259), new FlxPoint(-144, -216)];
				dickAngleArray[5] = [new FlxPoint(174, 69), new FlxPoint( -19, -259), new FlxPoint( -144, -216)];

				dickAngleArray[6] = [new FlxPoint(174, 69), new FlxPoint(0, -260), new FlxPoint(-69, -251)];
				dickAngleArray[7] = [new FlxPoint(174, 69), new FlxPoint(0, -260), new FlxPoint(-69, -251)];
				dickAngleArray[8] = [new FlxPoint(174, 69), new FlxPoint(0, -260), new FlxPoint(-69, -251)];
				dickAngleArray[9] = [new FlxPoint(174, 69), new FlxPoint(0, -260), new FlxPoint(-69, -251)];
				dickAngleArray[10] = [new FlxPoint(174, 69), new FlxPoint(0, -260), new FlxPoint( -69, -251)];
			}
			else
			{
				dickAngleArray[1] = [new FlxPoint(174, 69), new FlxPoint(0, -260), new FlxPoint(116, -233)];
				dickAngleArray[2] = [new FlxPoint(174, 69), new FlxPoint(0, -260), new FlxPoint(116, -233)];
				dickAngleArray[3] = [new FlxPoint(174, 69), new FlxPoint(0, -260), new FlxPoint(116, -233)];
				dickAngleArray[4] = [new FlxPoint(174, 69), new FlxPoint(0, -260), new FlxPoint(116, -233)];
				dickAngleArray[5] = [new FlxPoint(174, 69), new FlxPoint(0, -260), new FlxPoint(116, -233)];

				dickAngleArray[6] = [new FlxPoint(176, 69), new FlxPoint(-7, -260), new FlxPoint(67, -251)];
				dickAngleArray[7] = [new FlxPoint(176, 69), new FlxPoint(-7, -260), new FlxPoint(67, -251)];
				dickAngleArray[8] = [new FlxPoint(176, 69), new FlxPoint(-7, -260), new FlxPoint(67, -251)];
				dickAngleArray[9] = [new FlxPoint(176, 69), new FlxPoint(-7, -260), new FlxPoint(67, -251)];
				dickAngleArray[10] = [new FlxPoint(176, 69), new FlxPoint(-7, -260), new FlxPoint(67, -251)];
			}
		}
		else {
			// no visible emissions for female grimer
		}

		breathAngleArray[0] = [new FlxPoint(173, 185), new FlxPoint(-2, 80)];
		breathAngleArray[1] = [new FlxPoint(173, 185), new FlxPoint(-2, 80)];
		breathAngleArray[2] = [new FlxPoint(173, 185), new FlxPoint(-2, 80)];
		breathAngleArray[3] = [new FlxPoint(131, 185), new FlxPoint(-69, 40)];
		breathAngleArray[4] = [new FlxPoint(131, 185), new FlxPoint(-69, 40)];
		breathAngleArray[6] = [new FlxPoint(131, 185), new FlxPoint(-69, 40)];
		breathAngleArray[7] = [new FlxPoint(131, 185), new FlxPoint(-69, 40)];
		breathAngleArray[8] = [new FlxPoint(131, 185), new FlxPoint(-69, 40)];
		breathAngleArray[9] = [new FlxPoint(247, 159), new FlxPoint(80, 4)];
		breathAngleArray[10] = [new FlxPoint(247, 159), new FlxPoint(80, 4)];
		breathAngleArray[11] = [new FlxPoint(247, 159), new FlxPoint(80, 4)];
		breathAngleArray[12] = [new FlxPoint(151, 199), new FlxPoint(-46, 65)];
		breathAngleArray[13] = [new FlxPoint(151, 199), new FlxPoint(-46, 65)];
		breathAngleArray[14] = [new FlxPoint(151, 199), new FlxPoint(-46, 65)];
		breathAngleArray[15] = [new FlxPoint(161, 197), new FlxPoint(-18, 78)];
		breathAngleArray[16] = [new FlxPoint(161, 197), new FlxPoint(-18, 78)];
		breathAngleArray[17] = [new FlxPoint(161, 197), new FlxPoint(-18, 78)];
		breathAngleArray[18] = [new FlxPoint(223, 192), new FlxPoint(60, 52)];
		breathAngleArray[19] = [new FlxPoint(223, 192), new FlxPoint(60, 52)];
		breathAngleArray[20] = [new FlxPoint(223, 192), new FlxPoint(60, 52)];
		breathAngleArray[21] = [new FlxPoint(143, 188), new FlxPoint(-70, 38)];
		breathAngleArray[22] = [new FlxPoint(143, 188), new FlxPoint(-70, 38)];
		breathAngleArray[23] = [new FlxPoint(143, 188), new FlxPoint(-70, 38)];
		breathAngleArray[24] = [new FlxPoint(137, 182), new FlxPoint(-77, 23)];
		breathAngleArray[25] = [new FlxPoint(137, 182), new FlxPoint(-77, 23)];
		breathAngleArray[26] = [new FlxPoint(137, 182), new FlxPoint(-77, 23)];
		breathAngleArray[27] = [new FlxPoint(172, 193), new FlxPoint(0, 80)];
		breathAngleArray[28] = [new FlxPoint(172, 193), new FlxPoint(0, 80)];
		breathAngleArray[29] = [new FlxPoint(172, 193), new FlxPoint(0, 80)];
		breathAngleArray[30] = [new FlxPoint(176, 202), new FlxPoint(7, 80)];
		breathAngleArray[31] = [new FlxPoint(176, 202), new FlxPoint(7, 80)];
		breathAngleArray[32] = [new FlxPoint(176, 202), new FlxPoint(7, 80)];
		breathAngleArray[36] = [new FlxPoint(169, 196), new FlxPoint(-6, 80)];
		breathAngleArray[37] = [new FlxPoint(169, 196), new FlxPoint(-6, 80)];
		breathAngleArray[38] = [new FlxPoint(169, 196), new FlxPoint(-6, 80)];
		breathAngleArray[39] = [new FlxPoint(236, 162), new FlxPoint(78, -15)];
		breathAngleArray[40] = [new FlxPoint(236, 162), new FlxPoint(78, -15)];
		breathAngleArray[41] = [new FlxPoint(236, 162), new FlxPoint(78, -15)];
		breathAngleArray[42] = [new FlxPoint(171, 195), new FlxPoint(-7, 80)];
		breathAngleArray[43] = [new FlxPoint(171, 195), new FlxPoint(-7, 80)];
		breathAngleArray[44] = [new FlxPoint(171, 195), new FlxPoint(-7, 80)];
		breathAngleArray[48] = [new FlxPoint(231, 167), new FlxPoint(80, 8)];
		breathAngleArray[49] = [new FlxPoint(231, 167), new FlxPoint(80, 8)];
		breathAngleArray[50] = [new FlxPoint(231, 167), new FlxPoint(80, 8)];
		breathAngleArray[51] = [new FlxPoint(162, 188), new FlxPoint(-22, 77)];
		breathAngleArray[52] = [new FlxPoint(162, 188), new FlxPoint(-22, 77)];
		breathAngleArray[53] = [new FlxPoint(162, 188), new FlxPoint(-22, 77)];
		breathAngleArray[54] = [new FlxPoint(134, 189), new FlxPoint(-58, 55)];
		breathAngleArray[55] = [new FlxPoint(134, 189), new FlxPoint(-58, 55)];
		breathAngleArray[56] = [new FlxPoint(134, 189), new FlxPoint(-58, 55)];
		breathAngleArray[60] = [new FlxPoint(175, 202), new FlxPoint(8, 80)];
		breathAngleArray[61] = [new FlxPoint(175, 202), new FlxPoint(8, 80)];
		breathAngleArray[62] = [new FlxPoint(175, 202), new FlxPoint(8, 80)];
		breathAngleArray[63] = [new FlxPoint(170, 203), new FlxPoint(-3, 80)];
		breathAngleArray[64] = [new FlxPoint(170, 203), new FlxPoint(-3, 80)];
		breathAngleArray[65] = [new FlxPoint(170, 203), new FlxPoint(-3, 80)];
		breathAngleArray[66] = [new FlxPoint(132, 198), new FlxPoint(-65, 46)];
		breathAngleArray[67] = [new FlxPoint(132, 198), new FlxPoint(-65, 46)];
		breathAngleArray[68] = [new FlxPoint(132, 198), new FlxPoint(-65, 46)];

		shallowEnd[0] = [new FlxPoint(133, 433), new FlxPoint(61, 376), new FlxPoint(64, 272), new FlxPoint(110, 230), new FlxPoint(185, 203), new FlxPoint(241, 235), new FlxPoint(300, 274), new FlxPoint(298, 382), new FlxPoint(261, 429), new FlxPoint(182, 451)];
		shallowEnd[1] = [new FlxPoint(133, 433), new FlxPoint(61, 376), new FlxPoint(64, 272), new FlxPoint(110, 230), new FlxPoint(185, 203), new FlxPoint(241, 235), new FlxPoint(300, 274), new FlxPoint(298, 382), new FlxPoint(261, 429), new FlxPoint(182, 451)];
		shallowEnd[2] = [new FlxPoint(133, 433), new FlxPoint(61, 376), new FlxPoint(64, 272), new FlxPoint(110, 230), new FlxPoint(185, 203), new FlxPoint(241, 235), new FlxPoint(300, 274), new FlxPoint(298, 382), new FlxPoint(261, 429), new FlxPoint(182, 451)];
		shallowEnd[3] = [new FlxPoint(133, 433), new FlxPoint(61, 376), new FlxPoint(64, 272), new FlxPoint(110, 230), new FlxPoint(185, 203), new FlxPoint(241, 235), new FlxPoint(300, 274), new FlxPoint(298, 382), new FlxPoint(261, 429), new FlxPoint(182, 451)];
		shallowEnd[4] = [new FlxPoint(133, 433), new FlxPoint(61, 376), new FlxPoint(64, 272), new FlxPoint(110, 230), new FlxPoint(185, 203), new FlxPoint(241, 235), new FlxPoint(300, 274), new FlxPoint(298, 382), new FlxPoint(261, 429), new FlxPoint(182, 451)];

		deepEnd[0] = [new FlxPoint(84, 284), new FlxPoint(120, 247), new FlxPoint(178, 233), new FlxPoint(245, 253), new FlxPoint(278, 279), new FlxPoint(285, 356), new FlxPoint(244, 384), new FlxPoint(229, 415), new FlxPoint(181, 428), new FlxPoint(149, 421), new FlxPoint(135, 376), new FlxPoint(83, 359)];
		deepEnd[1] = [new FlxPoint(84, 284), new FlxPoint(120, 247), new FlxPoint(178, 233), new FlxPoint(245, 253), new FlxPoint(278, 279), new FlxPoint(285, 356), new FlxPoint(244, 384), new FlxPoint(229, 415), new FlxPoint(181, 428), new FlxPoint(149, 421), new FlxPoint(135, 376), new FlxPoint(83, 359)];
		deepEnd[2] = [new FlxPoint(84, 284), new FlxPoint(120, 247), new FlxPoint(178, 233), new FlxPoint(245, 253), new FlxPoint(278, 279), new FlxPoint(285, 356), new FlxPoint(244, 384), new FlxPoint(229, 415), new FlxPoint(181, 428), new FlxPoint(149, 421), new FlxPoint(135, 376), new FlxPoint(83, 359)];
		deepEnd[3] = [new FlxPoint(84, 284), new FlxPoint(120, 247), new FlxPoint(178, 233), new FlxPoint(245, 253), new FlxPoint(278, 279), new FlxPoint(285, 356), new FlxPoint(244, 384), new FlxPoint(229, 415), new FlxPoint(181, 428), new FlxPoint(149, 421), new FlxPoint(135, 376), new FlxPoint(83, 359)];
		deepEnd[4] = [new FlxPoint(84, 284), new FlxPoint(120, 247), new FlxPoint(178, 233), new FlxPoint(245, 253), new FlxPoint(278, 279), new FlxPoint(285, 356), new FlxPoint(244, 384), new FlxPoint(229, 415), new FlxPoint(181, 428), new FlxPoint(149, 421), new FlxPoint(135, 376), new FlxPoint(83, 359)];

		encouragementWords = wordManager.newWords();
		encouragementWords.words.push([ { graphic:AssetPaths.grimer_words_small__png, frame:0 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.grimer_words_small__png, frame:1 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.grimer_words_small__png, frame:2 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.grimer_words_small__png, frame:3 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.grimer_words_small__png, frame:4 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.grimer_words_small__png, frame:5 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.grimer_words_small__png, frame:6 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.grimer_words_small__png, frame:7 } ]);
		encouragementWords.words.push([ { graphic:AssetPaths.grimer_words_small__png, frame:8 } ]);

		weirdRubWords = wordManager.newWords(120);
		// err... if you knew what that was... you wouldn't rub it
		weirdRubWords.words.push([
		{ graphic:AssetPaths.grimer_words_small__png, frame:17},
		{ graphic:AssetPaths.grimer_words_small__png, frame:19, yOffset:0, delay:0.5},
		{ graphic:AssetPaths.grimer_words_small__png, frame:21, yOffset:20, delay:1.3},
		{ graphic:AssetPaths.grimer_words_small__png, frame:23, yOffset:40, delay:2.1},
		{ graphic:AssetPaths.grimer_words_small__png, frame:24, yOffset:40, delay:2.6},
		{ graphic:AssetPaths.grimer_words_small__png, frame:25, yOffset:62, delay:3.4},
		]);
		// that's err.... not what you think it is....
		weirdRubWords.words.push([
		{ graphic:AssetPaths.grimer_words_small__png, frame:26},
		{ graphic:AssetPaths.grimer_words_small__png, frame:28, yOffset:20, delay:0.8},
		{ graphic:AssetPaths.grimer_words_small__png, frame:30, yOffset:40, delay:1.6},
		]);
		// don't.... ...that's a little weird...
		weirdRubWords.words.push([
		{ graphic:AssetPaths.grimer_words_small__png, frame:27},
		{ graphic:AssetPaths.grimer_words_small__png, frame:29, yOffset:0, delay:0.5},
		{ graphic:AssetPaths.grimer_words_small__png, frame:31, yOffset:18, delay:1.5},
		]);

		almostWords = wordManager.newWords(30);
		// that's.... i think i'm.... ...glrrgle....
		almostWords.words.push([
		{ graphic:AssetPaths.grimer_words_medium__png, frame:9, height:48, chunkSize:5 },
		{ graphic:AssetPaths.grimer_words_medium__png, frame:11, height:48, chunkSize:5, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.grimer_words_medium__png, frame:13, height:48, chunkSize:5, yOffset:40, delay:1.8 }
		]);
		// that's.... i'm about to... ...blrrrpht~
		almostWords.words.push([
		{ graphic:AssetPaths.grimer_words_medium__png, frame:9, height:48, chunkSize:5 },
		{ graphic:AssetPaths.grimer_words_medium__png, frame:10, height:48, chunkSize:5, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.grimer_words_medium__png, frame:12, height:48, chunkSize:5, yOffset:40, delay:1.9 }
		]);
		// i think i'm.... blorrpphpht--
		almostWords.words.push([
		{ graphic:AssetPaths.grimer_words_medium__png, frame:11, height:48, chunkSize:5 },
		{ graphic:AssetPaths.grimer_words_medium__png, frame:15, height:48, chunkSize:5, yOffset:22, delay:1.4 },
		]);

		superBoredWordCount = 3;
		boredWords = wordManager.newWords(6);
		boredWords.words.push([ { graphic:AssetPaths.grimer_words_small__png, frame:9 } ]);
		boredWords.words.push([ { graphic:AssetPaths.grimer_words_small__png, frame:10 } ]);
		boredWords.words.push([ { graphic:AssetPaths.grimer_words_small__png, frame:11 } ]);
		// eggh... sorry about that
		boredWords.words.push([
		{ graphic:AssetPaths.grimer_words_small__png, frame:12 },
		{ graphic:AssetPaths.grimer_words_small__png, frame:14, yOffset:18, delay:0.8 }
		]);
		// sorry, it's.... ...that's fine
		boredWords.words.push([
		{ graphic:AssetPaths.grimer_words_small__png, frame:13 },
		{ graphic:AssetPaths.grimer_words_small__png, frame:15, yOffset:22, delay:1.3 }
		]);
		// yeah, sorry, we... we don't have to...
		boredWords.words.push([
		{ graphic:AssetPaths.grimer_words_small__png, frame:16 },
		{ graphic:AssetPaths.grimer_words_small__png, frame:18, yOffset:20, delay:0.8 },
		{ graphic:AssetPaths.grimer_words_small__png, frame:20, yOffset:20, delay:1.3 },
		{ graphic:AssetPaths.grimer_words_small__png, frame:22, yOffset:40, delay:1.9 },
		]);

		pleasureWords = wordManager.newWords();
		pleasureWords.words.push([ { graphic:AssetPaths.grimer_words_medium__png, frame:0, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.grimer_words_medium__png, frame:1, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.grimer_words_medium__png, frame:2, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.grimer_words_medium__png, frame:3, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.grimer_words_medium__png, frame:4, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.grimer_words_medium__png, frame:5, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.grimer_words_medium__png, frame:6, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.grimer_words_medium__png, frame:7, height:48, chunkSize:5 } ]);
		pleasureWords.words.push([ { graphic:AssetPaths.grimer_words_medium__png, frame:8, height:48, chunkSize:5 } ]);

		orgasmWords = wordManager.newWords();
		orgasmWords.words.push([ { graphic:AssetPaths.grimer_words_large__png, frame:0, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.grimer_words_large__png, frame:1, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.grimer_words_large__png, frame:2, width:200, height:150, yOffset:-30, chunkSize:5 } ]);
		orgasmWords.words.push([ { graphic:AssetPaths.grimer_words_large__png, frame:3, width:200, height:150, yOffset:-30, chunkSize:8 } ]); // phlort
		orgasmWords.words.push([ { graphic:AssetPaths.grimer_words_large__png, frame:4, width:200, height:150, yOffset: -30, chunkSize:5 } ]);
	}

	override function maybeEndSexyRubbing():Void
	{
		eventStack.addEvent({time:eventStack._time + 2.4, callback:eventPlayDickAnimation, args:["boner0"]});
		eventStack.addEvent({time:eventStack._time + 4.8, callback:eventPlayDickAnimation, args:["default"]});
	}

	function eventPlayDickAnimation(args:Array<Dynamic>)
	{
		var animName:String = args[0];
		_pokeWindow.playDickAnimation(animName);
	}

	override function generateCumshots():Void
	{
		if (_remainingOrgasms == 1)
		{
			_heartBank._dickHeartReservoir += weirdBonus;
			weirdBonus = 0;
		}
		if (!came)
		{
			_heartBank._dickHeartReservoir = SexyState.roundUpToQuarter(heartPenalty * _heartBank._dickHeartReservoir);
			_heartBank._foreplayHeartReservoir = SexyState.roundUpToQuarter(heartPenalty * _heartBank._foreplayHeartReservoir);
		}
		if (!_male)
		{
			// female grimer doesn't squirt jizz, so make her sweat so the player at least gets some feedback...
			_autoSweatRate = FlxMath.bound(_autoSweatRate + FlxG.random.float(0.2, 0.4), 0, 1.0);
			_sweatCount = 6;
		}

		super.generateCumshots();
	}

	override public function determineArousal():Int
	{
		var arousal:Int = 0;
		if (_heartBank.getDickPercent() < 0.64)
		{
			arousal = 4;
		}
		else if (_heartBank.getDickPercent() < 0.8)
		{
			arousal = 3;
		}
		else if (pastBonerThreshold())
		{
			arousal = 2;
		}
		else if (_heartBank.getForeplayPercent() < 0.8)
		{
			arousal = 1;
		}
		else {
			arousal = 0;
		}

		if (StringTools.endsWith(specialRub, "-good") || specialRub == "rub-hidden-dick")
		{
			arousal = Std.int(FlxMath.bound(arousal + 1, 0, 4));
		}
		else if (StringTools.endsWith(specialRub, "-bad") || StringTools.endsWith(specialRub, "-ok") && specialRubsInARow() >= 3)
		{
			arousal = Std.int(FlxMath.bound(arousal - 1, 0, 4));
		}
		return arousal;
	}

	/**
	 * Do a nice thing, but swallow some of the resulting hearts into the weirdBonus.
	 */
	function doWeirdNiceThing(swallowedPct:Float):Void
	{
		// run the usual "niceThing" logic...
		super.doNiceThing();

		// consume most of the heartEmitCount into the weirdBonus...
		var newBonusAmount:Float = SexyState.roundDownToQuarter(_heartEmitCount * swallowedPct);
		_heartEmitCount -= newBonusAmount;
		weirdBonus += newBonusAmount;
	}

	function doWeirdMeanThing(amount:Float = 1):Void
	{
		super.doMeanThing(amount);
		if (_heartEmitCount < 0)
		{
			soonHeartEmitCount += _heartEmitCount;
			_heartEmitCount = 0;
		}
	}

	override function handleRubReward():Void
	{
		{
			var closestDoopIndex:Int = -1;
			var closestDoopDist:Float = 100000;
			for (i in 0...doops.length)
			{
				var dist:Float = getDoopDist(i);
				if (dist <= closestDoopDist)
				{
					closestDoopDist = dist;
					closestDoopIndex = i;
				}
			}
		}

		if (niceThings[0])
		{
			var qRub;
			if (specialRub == "rub-hidden-dick" || specialRub == "rub-dick")
			{
				qRub = "dick";
			}
			else
			{
				qRub = specialRub;
			}
			if (remainingRubs.remove(qRub))
			{
				scheduleBreath();
			}
			if (remainingRubs.length == 2)
			{
				// rubbed 3 out of a possible 4 nice spots
				niceThings[0] = false;
				doWeirdNiceThing(0.65);
			}
		}
		if (niceThings[1])
		{
			if (specialRubs.indexOf("jack-off") != -1)
			{
				if (StringTools.endsWith(specialRub, "-good") && specialRubsInARow() >= 2)
				{
					niceThings[1] = false;
					doWeirdNiceThing(0.25);
					maybeEmitWords(pleasureWords);
				}
			}
		}
		if (niceThings[2] && _male)
		{
			if (specialRub == "rub-hidden-dick" && !dickWasVisible)
			{
				if (rubbedHiddenDickInTime == false)
				{
					rubbedHiddenDickInTime = true;
					maybeEmitWords(pleasureWords);
				}
			}
			if ((specialRub == "jack-off" || specialRub == "rub-dick") && rubbedHiddenDickInTime)
			{
				niceThings[2] = false;
				doWeirdNiceThing(0.45);
			}
		}
		if (meanThings[0])
		{
			if (specialRub == "squeeze-polyp-bad")
			{
				doWeirdMeanThing();
				meanThings[0] = false;
			}
		}
		if (meanThings[1])
		{
			if (specialRub == "rub-bulb-bad" && specialRubsInARow() >= 2)
			{
				doWeirdMeanThing();
				meanThings[1] = false;
			}
		}

		var amount:Float = 0;
		if (specialRub == "jack-off")
		{
			var lucky:Float = lucky(0.7, 1.43, 0.1);
			amount = SexyState.roundUpToQuarter(lucky * _heartBank._dickHeartReservoir);
			_heartBank._dickHeartReservoir -= amount;
			if (amount > 0)
			{
				amount = Math.max(0.25, SexyState.roundDownToQuarter(heartPenalty * amount));
			}
			soonHeartEmitCount += amount;

			if (weirdBonus > 0 && amount > 0)
			{
				var extraAmount:Float = SexyState.roundUpToQuarter(weirdBonus * super.lucky(0.7, 1.43, 0.13));
				weirdBonus -= extraAmount;
				soonHeartEmitCount += extraAmount;
			}

			if (almostWords.timer <= 0 && _remainingOrgasms > 0 && _heartBank.getDickPercent() < 0.51 && !isEjaculating())
			{
				maybeEmitWords(almostWords);
			}

			if (!_male && _remainingOrgasms > 0)
			{
				_autoSweatRate += 0.04;
			}
		}
		else {
			var scalar:Float = 0.07;
			if (specialRub == "")
			{
				// default scalar is OK...
			}
			else {
				if (specialRub == "rub-dick" || specialRub == "rub-hidden-dick")
				{
					scalar = 0.09;
					var transferAmount = SexyState.roundUpToQuarter(0.06 * _heartBank._foreplayHeartReservoir);
					_heartBank._foreplayHeartReservoir -= transferAmount;
					_heartBank._dickHeartReservoir += transferAmount;
					scalar = 0.07;
				}
				else {
					if (specialRubsInARow() == 1)
					{
						distinctWeirdRubCount++;
					}

					if (distinctWeirdRubCount == 1)
					{
						// first mystery rub... respond ambiguously
						scalar = 0.04;
					}
					else if (StringTools.endsWith(specialRub, "-good"))
					{
						scalar = 0.08;
						var transferAmount = SexyState.roundUpToQuarter(0.03 * _heartBank._foreplayHeartReservoir);
						_heartBank._foreplayHeartReservoir -= transferAmount;
						weirdBonus += transferAmount;
					}
					else if (StringTools.endsWith(specialRub, "-ok"))
					{
						if (specialRubsInARow() >= 4)
						{
							maybeEmitWords(weirdRubWords);
							heartPenalty *= 0.94;
						}
						var penaltyAmount = SexyState.roundUpToQuarter(0.03 * _heartBank._foreplayHeartReservoir);
						_heartBank._foreplayHeartReservoir -= penaltyAmount;
						scalar = 0.07;
					}
					else if (StringTools.endsWith(specialRub, "-bad"))
					{
						if (specialRubsInARow() >= 2)
						{
							maybeEmitWords(weirdRubWords);
							heartPenalty *= 0.88; // additional penalty compounded on the other penalty...
						}
						else
						{
							heartPenalty *= 0.94;
						}

						var penaltyAmount = SexyState.roundUpToQuarter(0.09 * _heartBank._foreplayHeartReservoir);
						_heartBank._foreplayHeartReservoir -= penaltyAmount;
						scalar = 0.04;
					}
				}
			}
			var lucky:Float = lucky(0.7, 1.43, scalar);
			if (pastBonerThreshold())
			{
				lucky *= 0.5;
			}
			amount = SexyState.roundUpToQuarter(lucky * _heartBank._foreplayHeartReservoir);
			_heartBank._foreplayHeartReservoir -= amount;
			soonHeartEmitCount += amount;

			if (weirdBonus > 0 && amount > 0)
			{
				var extraAmount:Float = SexyState.roundUpToQuarter(weirdBonus * super.lucky(0.7, 1.43, 0.13));
				weirdBonus -= extraAmount;
				soonHeartEmitCount += extraAmount;
			}

			if (soonHeartEmitCount > 0)
			{
				maybeScheduleBreath();
				maybeEmitPrecum();
			}
		}
	}

	override function computePrecumAmount():Int
	{
		var precumAmount:Int = 0;
		if (FlxG.random.float(1, 5) < weirdBonus)
		{
			precumAmount++;
		}
		if (FlxG.random.float(1, 8) < soonHeartEmitCount)
		{
			precumAmount++;
		}
		if (FlxG.random.float(1, 13) < soonHeartEmitCount + weirdBonus)
		{
			precumAmount++;
		}
		if (FlxG.random.float(1, 21) < soonHeartEmitCount + weirdBonus)
		{
			precumAmount++;
		}
		return precumAmount;
	}

	override public function back():Void
	{
		super.back();

		if (specialRubs.length >= 2)
		{
			// yuck! dirty
			PlayerData.grimTouched = true;

			if (PlayerData.cursorInsulated)
			{
				// glove is insulated; pokemon don't complain about the smell
			}
			else
			{
				PlayerData.cursorSmellTimeRemaining = 15 * 60;
			}
		}
		if (specialRubs.length >= 2)
		{
			if (!clickedAnyHiddenStuff())
			{
				/*
				 * Guarantee player gets the "you didn't click anything"
				 * complaint. This is a big one, and means they don't
				 * understand how Grimer works
				 */
				LevelIntroDialog.rotateSexyChat(this, [5, 5, 5, 5, 5]);
			}
		}
	}

	private function clickedAnyHiddenStuff():Bool
	{
		var result:Bool = false;
		for (i in 0...specialRubs.length)
		{
			if (specialRubs[i] == "")
			{
				// rubbing mud... doesn't count as interacting
			}
			else if (_male && specialRubs[i] == "rub-dick")
			{
				// rubbing a visible dick...
			}
			else if (_male && specialRubs[i] == "jack-off")
			{
				// rubbing a visible dick...
			}
			else
			{
				result = true;
			}
		}
		return result;
	}

	override public function computeChatComplaints(complaints:Array<Int>):Void
	{
		if (!clickedAnyHiddenStuff())
		{
			/*
			 * Guarantee player gets the "you didn't click anything"
			 * complaint. This is a big one, and means they don't
			 * understand how Grimer works
			 */
			complaints.push(5);
			complaints.push(5);
			complaints.push(5);
			complaints.push(5);
			complaints.push(5);
			return;
		}
		if (meanThings[0] == false)
		{
			complaints.push(0);
		}
		if (meanThings[1] == false)
		{
			complaints.push(1);
		}
		if (specialRubs.filter(function(s) { return s == "stroke-artery-ok"; } ).length >= 2)
		{
			complaints.push(2);
		}
		if (niceThings[0] == true)
		{
			complaints.push(3);
		}
		if (niceThings[1] == true)
		{
			complaints.push(4);
		}
	}

	override function penetrating():Bool
	{
		if (specialRub == "finger-cavity-good")
		{
			return true;
		}
		if (!_male && specialRub == "jack-off")
		{
			return true;
		}
		if (!_male && specialRub == "rub-dick-hidden")
		{
			return true;
		}
		return false;
	}

	override function cursorSmellPenaltyAmount():Int
	{
		return 0;
	}

	override public function destroy():Void
	{
		super.destroy();

		shallowEnd = null;
		deepEnd = null;
		unsubmergePoint = FlxDestroyUtil.put(unsubmergePoint);
		doops = FlxDestroyUtil.putArray(doops);
		goopyHand = FlxDestroyUtil.destroy(goopyHand);
		alertAlphaTween = FlxTweenUtil.destroy(alertAlphaTween);
		alertSprite = FlxDestroyUtil.destroy(alertSprite);
		niceThings = null;
		meanThings = null;
		remainingRubs = null;
		weirdRubWords = null;
		gummyDildoButton = FlxDestroyUtil.destroy(gummyDildoButton);
		smallPurpleBeadsButton = FlxDestroyUtil.destroy(smallPurpleBeadsButton);
		happyMealButton = FlxDestroyUtil.destroy(happyMealButton);
	}
}