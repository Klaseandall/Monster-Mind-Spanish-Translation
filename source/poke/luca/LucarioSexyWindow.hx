package poke.luca;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;
import poke.PokeWindow;
import poke.rhyd.BreathingSprite;

/**
 * Sprites and animations for Lucario during the sex scene
 *
 * Lucario's the only Pokemon with a different set of sprites during the sex
 * scene, versus the puzzles. Her natural sitting pose didn't lend itself well
 * to sex.
 */
class LucarioSexyWindow extends PokeWindow
{
	private var dickToFuzzFrames:Map<Int, Int> = [
				0 => 0,
				1 => 1,
				2 => 1,
				3 => 2,
				4 => 2,
				5 => 3,
				6 => 3,
				7 => 4,
				8 => 4,
				9 => 1,
				10 => 1,
				11 => 1,
				12 => 1,
				13 => 1,
			];

	public var hair:BouncySprite;
	public var torso1:BouncySprite;
	public var torso0:BouncySprite;
	public var armsDown:BreathingSprite;
	public var armsUp:BouncySprite;
	public var butt:BouncySprite;
	public var tail:BouncySprite;
	public var legs:BouncySprite;
	public var ass:BouncySprite;
	public var balls:BouncySprite;
	public var pubicFuzz:BouncySprite;
	public var neck:BouncySprite;
	public var feet:BouncySprite;

	public function new(X:Float=0, Y:Float=0, Width:Int=248, Height:Int = 349)
	{
		super(X, Y, Width, Height);
		LucarioResource.setHat(false);

		_prefix = "luca";
		_name = "Lucario";
		_victorySound = AssetPaths.luca__mp3;
		_dialogClass = LucarioDialog;

		add(new FlxSprite( -54, -54, AssetPaths.luca_bg__png));

		hair = new BouncySprite( -54, -54, 6, 7.4, 0.15, _age);
		hair.loadWindowGraphic(AssetPaths.lucasexy_hair__png);
		hair.animation.add("c", [0]);
		hair.animation.add("cm", [1]);
		hair.animation.add("s", [2]);
		hair.animation.add("sm", [3]);
		hair.animation.add("sw", [4]);
		hair.animation.add("swm", [5]);
		hair.animation.add("e", [6]);
		hair.animation.add("em", [7]);
		hair.animation.add("nw", [8]);
		hair.animation.add("nwm", [9]);
		addPart(hair);

		torso1 = new BouncySprite( -54, -54, 3, 7.4, 0.05, _age);
		torso1.loadWindowGraphic(AssetPaths.lucasexy_torso1__png);
		torso1.animation.add("default", [0]);
		torso1.animation.play("default");
		addPart(torso1);

		torso0 = new BouncySprite( -54, -54, 2, 7.4, 0.07, _age);
		torso0.loadWindowGraphic(AssetPaths.lucasexy_torso0__png);
		addPart(torso0);

		neck = new BouncySprite( -54, -54, 4, 7.4, 0.10, _age);
		neck.loadWindowGraphic(AssetPaths.lucasexy_neck__png);
		addPart(neck);

		armsDown = new BreathingSprite( -54, -54, 4, 7.4, 0.03, _age);
		armsDown.loadWindowGraphic(AssetPaths.lucasexy_armsdown__png);
		armsDown.animation.add("default", [0, 1, 2, 3, 4]);
		armsDown.animation.add("left", [6, 7, 8, 9, 10]);
		armsDown.animation.add("right", [12, 13, 14, 15, 16]);
		armsDown.animation.add("leftright", [18, 19, 20, 21, 22]);
		armsDown.animation.play("default");
		addPart(armsDown);

		armsUp = new BouncySprite( -54, -54, 4, 7.4, 0.03, _age);
		armsUp.loadWindowGraphic(AssetPaths.lucasexy_armsup__png);
		armsUp.animation.add("default", [0]);
		armsUp.animation.add("left-0", [1]);
		armsUp.animation.add("right-0", [2]);
		armsUp.animation.add("left-0m", [3]);
		armsUp.animation.add("right-0m", [4]);
		armsUp.animation.add("left-1", [5]);
		armsUp.animation.add("right-1", [6]);
		armsUp.animation.add("left-1m", [7]);
		armsUp.animation.add("right-1m", [8]);
		armsUp.animation.add("left-2", [9]);
		armsUp.animation.add("right-2", [10]);
		armsUp.animation.add("left-2m", [11]);
		armsUp.animation.add("right-2m", [12]);
		armsUp.animation.add("left-3", [13]);
		armsUp.animation.add("right-3", [14]);
		armsUp.animation.add("left-3m", [15]);
		armsUp.animation.add("right-3m", [16]);
		armsUp.animation.add("leftright-0", [18]);
		armsUp.animation.add("leftright-1", [19]);
		armsUp.animation.add("leftright-2", [20]);
		armsUp.animation.add("leftright-3", [21]);
		armsUp.animation.add("leftright-4", [22]);
		armsUp.animation.add("leftright-5", [23]);
		armsUp.animation.add("leftright-6", [24]);
		armsUp.animation.add("leftright-7", [25]);
		armsUp.animation.add("leftright-8", [26]);
		armsUp.animation.add("leftright-9", [27]);
		armsUp.animation.add("leftright-10", [28]);
		armsUp.animation.add("leftright-11", [29]);

		armsUp.animation.play("default");
		addPart(armsUp);

		butt = new BouncySprite( -54, -54, 0, 7.4, 0, _age);
		butt.loadWindowGraphic(AssetPaths.lucasexy_butt__png);
		addPart(butt);

		tail = new BouncySprite( -54, -54, 8, 7.4, 0.12, _age);
		tail.loadWindowGraphic(AssetPaths.lucasexy_tail__png);
		addPart(tail);

		legs = new BouncySprite( -54, -54, 0, 7.4, 0, _age);
		legs.loadWindowGraphic(AssetPaths.lucasexy_legs__png);
		legs.animation.add("default", [0]);
		legs.animation.add("1", [1]);
		legs.animation.add("2", [2]);
		legs.animation.add("3", [3]);
		legs.animation.add("4", [4]);
		legs.animation.add("raise-right-leg", [5]);
		legs.animation.add("raise-left-leg", [6]);
		legs.animation.play("default");
		addPart(legs);

		ass = new BouncySprite( -54, -54, 0, 7.4, 0, _age);
		ass.loadWindowGraphic(AssetPaths.lucasexy_ass__png);
		ass.animation.add("default", [0]);
		ass.animation.add("finger-ass", [1, 2, 3, 4, 5, 6, 7]);
		ass.animation.play("default");
		addPart(ass);

		balls = new BouncySprite( -54, -54, 2, 7.4, 0.15, _age);
		balls.loadWindowGraphic(AssetPaths.lucasexy_balls__png);

		pubicFuzz = new BouncySprite( -54, -54, 2, 7.4, 0.15, _age);
		pubicFuzz.loadWindowGraphic(AssetPaths.lucasexy_pubic_fuzz__png);

		_dick = new BouncySprite( -54, -54, 3, 7.4, 0.10, _age);
		_dick.loadWindowGraphic(LucarioResource.sexyDick);

		if (PlayerData.lucaMale)
		{
			balls.animation.add("default", [0]);
			balls.animation.add("rub-balls", [1, 2, 3, 4]);
			balls.animation.play("default");
			addPart(balls);

			_dick.animation.add("default", [0]);
			_dick.animation.add("boner0", [1]);
			_dick.animation.add("boner1", [2]);
			_dick.animation.add("boner2", [3]);
			_dick.animation.add("boner3", [4]);
			_dick.animation.add("rub-sheath0", [8, 9, 10, 11]);
			_dick.animation.add("rub-sheath1", [8, 7, 6, 5]);
			_dick.animation.add("rub-dick", [12, 13, 14, 15]);
			_dick.animation.add("jack-off", [21, 20, 19, 18, 17, 16]);
			_dick.animation.play("default");
			addPart(_dick);
		}
		else
		{
			addPart(pubicFuzz);
			_dick._bounceAmount = 1;
			_dick.animation.add("default", [0]);
			_dick.animation.add("jack-off", [0, 1, 2, 3, 4, 5, 6, 7, 8]);
			_dick.animation.add("rub-dick", [9, 10, 11, 12, 13]);
			addPart(_dick);
		}

		feet = new BouncySprite( -54, -54, 0, 7.4, 0, _age);
		feet.loadWindowGraphic(AssetPaths.lucasexy_feet__png);
		feet.animation.add("default", [0]);
		feet.animation.add("raise-right-leg", [1]);
		feet.animation.add("raise-left-leg", [2]);
		feet.animation.add("rub-right-foot", [3, 4, 5, 6, 7]);
		feet.animation.add("rub-left-foot", [8, 9, 10, 11, 12]);
		feet.animation.play("default");
		addPart(feet);

		_head = new BouncySprite( -54, -54, 5, 7.4, 0.09, _age);
		_head.loadGraphic(LucarioResource.sexyHead, true, 356, 266);
		_head.animation.add("default", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("0-c", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("0-swm", blinkyAnimation([3, 4], [5]), 3);
		_head.animation.add("0-nw", blinkyAnimation([6, 7], [8]), 3);
		_head.animation.add("1-sw", blinkyAnimation([12, 13], [14]), 3);
		_head.animation.add("1-cm", blinkyAnimation([15, 16], [17]), 3);
		_head.animation.add("1-sm", blinkyAnimation([18, 19], [20]), 3);
		_head.animation.add("2-nwm", blinkyAnimation([24, 25, 26]), 3);
		_head.animation.add("2-s", blinkyAnimation([27, 28, 29]), 3);
		_head.animation.add("2-em", blinkyAnimation([30, 31, 32]), 3);
		_head.animation.add("3-e", blinkyAnimation([36, 37], [38]), 3);
		_head.animation.add("3-sm", blinkyAnimation([39, 40], [41]), 3);
		_head.animation.add("3-swm", blinkyAnimation([42, 43], [44]), 3);
		_head.animation.add("4-s", blinkyAnimation([48, 49], [50]), 3);
		_head.animation.add("4-sw", blinkyAnimation([51, 52], [53]), 3);
		_head.animation.add("4-c", blinkyAnimation([54, 55], [56]), 3);
		_head.animation.add("5-nw", blinkyAnimation([60, 61, 62]), 3);
		_head.animation.add("5-em", blinkyAnimation([63, 64, 65]), 3);
		_head.animation.add("5-cm", blinkyAnimation([66, 67, 68]), 3);
		_head.animation.play("default");
		addPart(_head);

		_interact = new BouncySprite( -54, -54, _dick._bounceAmount, _dick._bounceDuration, _dick._bouncePhase, _age);
		if (_interactive)
		{
			reinitializeHandSprites();
			add(_interact);
		}
	}

	override public function setArousal(Arousal:Int)
	{
		super.setArousal(Arousal);
		if (_arousal == 0)
		{
			playNewAnim(_head, ["0-c", "0-swm", "0-nw"]);
		}
		else if (_arousal == 1)
		{
			playNewAnim(_head, ["1-sw", "1-cm", "1-sm"]);
		}
		else if (_arousal == 2)
		{
			playNewAnim(_head, ["2-nwm", "2-s", "2-em"]);
		}
		else if (_arousal == 3)
		{
			playNewAnim(_head, ["3-e", "3-sm", "3-swm"]);
		}
		else if (_arousal == 4)
		{
			playNewAnim(_head, ["4-s", "4-sw", "4-c"]);
		}
		else if (_arousal == 5)
		{
			playNewAnim(_head, ["5-nw", "5-em", "5-cm"]);
		}
		updateHair();
	}

	public function updateHair()
	{
		if (_head.animation.name == "default")
		{
			hair.animation.play("default");
		}
		else
		{
			var hairAnimName:String = _head.animation.name.substring(_head.animation.name.lastIndexOf("-") + 1);
			hair.animation.play(hairAnimName);
		}
	}

	override public function arrangeArmsAndLegs():Void
	{
		feet.animation.play("default");
		playNewAnim(legs, ["default", "1", "2", "3", "4"]);

		// lucario's arm position depends on his arousal
		if (_arousal == 0)
		{
			// unaroused; both arms down
			armsUp.animation.play("default");
		}
		else if (_arousal == 3 || _arousal == 4 || _arousal == 5)
		{
			// aroused; one, or maybe two arms up
			if (FlxG.random.bool())
			{
				// one arm up...
				playNewAnim(armsUp, [
					"left-0", "left-0m", "left-1", "left-1m", "left-2", "left-2m", "left-3", "left-3m",
					"right-0", "right-0m", "right-1", "right-1m", "right-2", "right-2m", "right-3", "right-3m",
				]);
			}
			else
			{
				// two arms up
				playNewAnim(armsUp, [
								"leftright-0", "leftright-1", "leftright-2", "leftright-3", "leftright-4", "leftright-5",
								"leftright-6", "leftright-7", "leftright-8", "leftright-9", "leftright-10", "leftright-11",
							]);
			}
		}
		else {
			// somewhat aroused; one arm might be up
			if (FlxG.random.bool())
			{
				// arms down
				armsUp.animation.play("default");
			}
			else {
				// one arm up
				playNewAnim(armsUp, [
					"left-0", "left-0m", "left-1", "left-1m", "left-2", "left-2m", "left-3", "left-3m",
					"right-0", "right-0m", "right-1", "right-1m", "right-2", "right-2m", "right-3", "right-3m",
				]);
			}
		}

		if (armsUp.animation.name == "default")
		{
			armsDown.animation.play("default");
		}
		else if (StringTools.startsWith(armsUp.animation.name, "left-"))
		{
			armsDown.animation.play("right");
		}
		else if (StringTools.startsWith(armsUp.animation.name, "right-"))
		{
			armsDown.animation.play("left");
		}
		else {
			armsDown.animation.play("leftright");
		}
		armsDown.update(0);
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		CursorUtils.initializeHandBouncySprite(_interact, AssetPaths.lucasexy_interact__png);
		if (PlayerData.lucaMale)
		{
			_interact.animation.add("rub-sheath0", [3, 4, 5, 6]);
			_interact.animation.add("rub-sheath1", [3, 2, 1, 0]);
			_interact.animation.add("rub-dick", [7, 8, 9, 10]);
			_interact.animation.add("jack-off", [16, 15, 14, 13, 12, 11]);
			_interact.animation.add("rub-balls", [17, 18, 19, 20]);
		}
		else
		{
			_interact.animation.add("jack-off", [42, 43, 44, 45, 46, 47, 48, 49, 50]);
			_interact.animation.add("rub-dick", [51, 52, 53, 54, 55]);
		}
		_interact.animation.add("finger-ass", [21, 22, 23, 24, 25, 26, 27]);
		_interact.animation.add("rub-right-foot", [28, 29, 30, 31, 32]);
		_interact.animation.add("rub-left-foot", [33, 34, 35, 36, 37]);
		_interact.animation.add("rub-spike", [38, 39, 40, 41]);
		_interact.visible = false;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (PlayerData.lucaMale)
		{
		}
		else {
			if (dickToFuzzFrames[_dick.animation.frameIndex] != null)
			{
				pubicFuzz.animation.frameIndex = dickToFuzzFrames[_dick.animation.frameIndex];
			}
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		dickToFuzzFrames = null;
		hair = FlxDestroyUtil.destroy(hair);
		torso1 = FlxDestroyUtil.destroy(torso1);
		torso0 = FlxDestroyUtil.destroy(torso0);
		armsDown = FlxDestroyUtil.destroy(armsDown);
		armsUp = FlxDestroyUtil.destroy(armsUp);
		butt = FlxDestroyUtil.destroy(butt);
		tail = FlxDestroyUtil.destroy(tail);
		legs = FlxDestroyUtil.destroy(legs);
		ass = FlxDestroyUtil.destroy(ass);
		balls = FlxDestroyUtil.destroy(balls);
		pubicFuzz = FlxDestroyUtil.destroy(pubicFuzz);
		neck = FlxDestroyUtil.destroy(neck);
		feet = FlxDestroyUtil.destroy(feet);
	}
}