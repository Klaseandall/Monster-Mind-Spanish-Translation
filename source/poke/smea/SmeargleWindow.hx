package poke.smea;

import demo.SexyDebugState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;
import poke.grov.Vibe;

/**
 * Sprites and animations for Smeargle
 */
class SmeargleWindow extends PokeWindow
{
	private static var BOUNCE_DURATION:Float = 6.0;

	public var _tail:BouncySprite;
	public var _torso0:BouncySprite;
	public var _torso1:BouncySprite;
	public var _legs0:BouncySprite;
	public var _underwear:BouncySprite;
	public var _balls:BouncySprite;
	public var _legs1:BouncySprite;
	public var _armsBehind:BouncySprite;
	public var _arms0:BouncySprite;
	public var _arms1:BouncySprite;
	public var _arms2:BouncySprite;
	public var _neck:BouncySprite;
	public var _tongue:BouncySprite;
	public var _blush:BouncySprite;
	public var _legs2:BouncySprite;
	public var _hat:BouncySprite;

	public var _vibe:Vibe;

	private var _cheerTimer:Float = -1;
	public var _comfort:Int = 0;
	public var _uncomfortable:Bool = false; // player is doing something we don't like

	public function new(X:Float=0, Y:Float=0, Width:Int=248, Height:Int = 349)
	{
		super(X, Y, Width, Height);
		_prefix = "smea";
		_name = "Smeargle";
		_victorySound = AssetPaths.smea__mp3;
		_dialogClass = SmeargleDialog;
		add(new FlxSprite( -54, -54, AssetPaths.smear_bg__png));

		_tail = new BouncySprite( -54, -54 - 3, 3, 4.7, 0.06, _age);
		_tail.loadWindowGraphic(AssetPaths.smear_tail__png);
		addPart(_tail);

		if (PlayerData.smeaMale)
		{
			_torso0 = new BouncySprite( -54, -54 - 2, 2, BOUNCE_DURATION, 0.04, _age);
		}
		else
		{
			_torso0 = new BouncySprite( -54, -54, 0, BOUNCE_DURATION, 0.04, _age);
		}
		_torso0.loadWindowGraphic(AssetPaths.smear_torso0__png);
		_torso0.animation.add("default", [0]);
		_torso0.animation.add("sweater", [1]);
		addPart(_torso0);

		_torso1 = new BouncySprite( -54, -54 - 4, 4, BOUNCE_DURATION, 0.08, _age);
		_torso1.loadWindowGraphic(AssetPaths.smear_torso1__png);
		_torso1.animation.add("default", [0]);
		_torso1.animation.add("sweater", [1]);
		addPart(_torso1);

		_armsBehind = new BouncySprite( -54, -54, 0, BOUNCE_DURATION, 0, _age);
		_armsBehind.loadWindowGraphic(AssetPaths.smear_arms_behind__png);
		_armsBehind.animation.add("3-2", [15]);
		_armsBehind.animation.add("3-1", [14]);
		_armsBehind.animation.add("3-0", [13]);
		_armsBehind.animation.add("2-2", [12]);
		_armsBehind.animation.add("2-1", [11]);
		_armsBehind.animation.add("2-0", [10]);
		_armsBehind.animation.add("1-2", [9]);
		_armsBehind.animation.add("1-1", [8]);
		_armsBehind.animation.add("1-0", [7]);
		_armsBehind.animation.add("0-2", [6]);
		_armsBehind.animation.add("0-1", [5]);
		_armsBehind.animation.add("0-0", [4]);
		_armsBehind.animation.add("default", [0]);
		_armsBehind.animation.add("sweater", [1]);
		_armsBehind.animation.add("cheer", [2]);
		_armsBehind.animation.add("sweater-cheer", [3]);
		_armsBehind.animation.add("uncomfortable", [0]);
		addPart(_armsBehind);

		_legs0 = new BouncySprite( -54, -54, 0, BOUNCE_DURATION, 0, _age);
		_legs0.loadWindowGraphic(AssetPaths.smear_legs0__png);
		_legs0.animation.add("default", [0]);
		_legs0.animation.add("0", [0]);
		_legs0.animation.add("1", [1]);
		_legs0.animation.add("2", [2]);
		_legs0.animation.add("3", [3]);
		_legs0.animation.add("4", [4]);
		_legs0.animation.add("5", [5]);
		_legs0.animation.add("6", [6]);
		_legs0.animation.add("4-0", [8]);
		_legs0.animation.add("4-1", [9]);
		_legs0.animation.add("4-2", [10]);
		_legs0.animation.add("4-3", [11]);
		addPart(_legs0);

		_underwear = new BouncySprite( -54, -54, 0, BOUNCE_DURATION, 0, _age);
		_underwear.loadWindowGraphic(SmeargleResource.undies);
		addPart(_underwear);

		_balls = new BouncySprite( -54, -54, 0, BOUNCE_DURATION, 0, _age);
		_balls.loadWindowGraphic(AssetPaths.smear_balls__png);
		_balls.animation.add("default", [0]);
		_balls.animation.add("rub-balls", [1, 2, 3, 4, 5]);

		_dick = new BouncySprite( -54, -54 - 2, 2, BOUNCE_DURATION, 0.03, _age);
		_dick.loadWindowGraphic(SmeargleResource.dick);

		if (PlayerData.smeaMale)
		{
			addPart(_balls);

			_dick.animation.add("default", [0]);
			_dick.animation.add("rub-dick", [3, 4, 5]);
			_dick.animation.add("jack-off", [8, 9, 10, 11, 12, 13]);
			addPart(_dick);
		}
		else
		{
			_dick.animation.add("default", [0]);
			_dick.animation.add("rub-dick", [1, 2, 3, 4, 5]);
			_dick.animation.add("jack-off", [1, 8, 9, 10, 11, 12]);
			addPart(_dick);
			_dick.synchronize(_torso0);
		}

		if (_interactive)
		{
			_vibe = new Vibe(_dick, -54, -54 - 2);
			addPart(_vibe.dickVibe);
			addVisualItem(_vibe.dickVibeBlur);
		}

		_legs1 = new BouncySprite( -54, -54, 0, BOUNCE_DURATION, 0, _age);
		_legs1.loadWindowGraphic(AssetPaths.smear_legs1__png);
		_legs1.animation.add("default", [0]);
		_legs1.animation.add("0", [0]);
		_legs1.animation.add("1", [1]);
		_legs1.animation.add("2", [2]);
		_legs1.animation.add("3", [3]);
		_legs1.animation.add("4", [4]);
		_legs1.animation.add("5", [5]);
		_legs1.animation.add("6", [6]);
		_legs1.animation.add("4-0", [8]);
		_legs1.animation.add("4-1", [9]);
		_legs1.animation.add("4-2", [10]);
		_legs1.animation.add("4-3", [11]);
		addPart(_legs1);

		_arms0 = new BouncySprite( -54, -54 - 1, 1, BOUNCE_DURATION, 0.05, _age);
		_arms0.loadWindowGraphic(AssetPaths.smear_arms0__png);
		_arms0.animation.add("3-2", [15]);
		_arms0.animation.add("3-1", [14]);
		_arms0.animation.add("3-0", [13]);
		_arms0.animation.add("2-2", [12]);
		_arms0.animation.add("2-1", [11]);
		_arms0.animation.add("2-0", [10]);
		_arms0.animation.add("1-2", [9]);
		_arms0.animation.add("1-1", [8]);
		_arms0.animation.add("1-0", [7]);
		_arms0.animation.add("0-2", [6]);
		_arms0.animation.add("0-1", [5]);
		_arms0.animation.add("0-0", [4]);
		_arms0.animation.add("default", [0]);
		_arms0.animation.add("sweater", [1]);
		_arms0.animation.add("cheer", [2]);
		_arms0.animation.add("sweater-cheer", [3]);
		_arms0.animation.add("uncomfortable", [16]);
		addPart(_arms0);

		_arms1 = new BouncySprite( -54, -54 - 2, 2, BOUNCE_DURATION, 0.07, _age);
		_arms1.loadWindowGraphic(AssetPaths.smear_arms1__png);
		_arms1.animation.add("3-2", [15]);
		_arms1.animation.add("3-1", [14]);
		_arms1.animation.add("3-0", [13]);
		_arms1.animation.add("2-2", [12]);
		_arms1.animation.add("2-1", [11]);
		_arms1.animation.add("2-0", [10]);
		_arms1.animation.add("1-2", [9]);
		_arms1.animation.add("1-1", [8]);
		_arms1.animation.add("1-0", [7]);
		_arms1.animation.add("0-2", [6]);
		_arms1.animation.add("0-1", [5]);
		_arms1.animation.add("0-0", [4]);
		_arms1.animation.add("default", [0]);
		_arms1.animation.add("sweater", [1]);
		_arms1.animation.add("cheer", [2]);
		_arms1.animation.add("sweater-cheer", [3]);
		_arms1.animation.add("uncomfortable", [16]);
		addPart(_arms1);

		_neck = new BouncySprite( -54, -54 - 4, 4, BOUNCE_DURATION, 0.10, _age);
		_neck.loadWindowGraphic(AssetPaths.smear_neck__png);
		addPart(_neck);

		_tongue = new BouncySprite( -54, -54 - 6, 6, BOUNCE_DURATION, 0.19, _age);
		if (_interactive)
		{
			_tongue.loadGraphic(AssetPaths.smear_tongue__png, true, 356, 266);
			_tongue.animation.add("default", [0], 3);
			_tongue.animation.add("pull-tongue", [1, 2, 3]);
			_tongue.visible = false;
			addPart(_tongue);
		}

		_head = new BouncySprite( -54, -54 - 4, 4, BOUNCE_DURATION, 0.16, _age);
		_head.loadGraphic(AssetPaths.smear_head__png, true, 356, 266);
		_head.animation.add("default", slowBlinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("cheer0", slowBlinkyAnimation([48, 49]), 3);
		_head.animation.add("cheer1", slowBlinkyAnimation([24, 25], [26]), 3);
		_head.animation.add("0-s", slowBlinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("0-se", slowBlinkyAnimation([3, 4], [5]), 3);
		_head.animation.add("0-sw", slowBlinkyAnimation([6, 7], [8]), 3);
		_head.animation.add("tongue-s", slowBlinkyAnimation([9, 10], [11]), 3);

		_head.animation.add("1-e", slowBlinkyAnimation([12, 13], [14]), 3);
		_head.animation.add("1-ee", slowBlinkyAnimation([15, 16], [17]), 3);
		_head.animation.add("1-c", slowBlinkyAnimation([18, 19], [20]), 3);
		_head.animation.add("rubhat1-c", slowBlinkyAnimation([21, 22], [23]), 3);

		_head.animation.add("2-w", slowBlinkyAnimation([24, 25], [26]), 3);
		_head.animation.add("2-se", slowBlinkyAnimation([27, 28], [29]), 3);
		_head.animation.add("2-e", slowBlinkyAnimation([30, 31], [32]), 3);
		_head.animation.add("2-c", slowBlinkyAnimation([33, 34], [35]), 3);

		_head.animation.add("3-ee", slowBlinkyAnimation([36, 37], [38]), 3);
		_head.animation.add("3-sw", slowBlinkyAnimation([39, 40], [41]), 3);
		_head.animation.add("3-c", slowBlinkyAnimation([42, 43], [44]), 3);
		_head.animation.add("rubhat2-c", slowBlinkyAnimation([45, 46], [47]), 3);

		_head.animation.add("4-w", slowBlinkyAnimation([48, 49]), 3);
		_head.animation.add("4-e", slowBlinkyAnimation([51, 52]), 3);
		_head.animation.add("4-se", slowBlinkyAnimation([54, 55]), 3);
		_head.animation.add("4-c", slowBlinkyAnimation([57, 58]), 3);

		_head.animation.add("5-sw", slowBlinkyAnimation([60, 61]), 3);
		_head.animation.add("5-ee", slowBlinkyAnimation([63, 64]), 3);
		_head.animation.add("5-c", slowBlinkyAnimation([66, 67]), 3);
		_head.animation.add("rubhat4-c", slowBlinkyAnimation([69, 70]), 3);
		_head.animation.add("uncomfortable-s", slowBlinkyAnimation([50, 53], [56]), 3);
		_head.animation.play("0-s");
		addPart(_head);

		_hat = new BouncySprite( -54, -54 - 4, 4, BOUNCE_DURATION, 0.16, _age);
		_hat.loadGraphic(AssetPaths.smear_hat__png, true, 356, 266);
		_hat.animation.add("default", [0], 3);
		_hat.animation.add("scritchhat-c", [4, 5, 6, 7]);
		_hat.animation.add("palmhat-c", [8, 9, 10, 11]);
		_hat.visible = false;
		addPart(_hat);

		_blush = new BouncySprite( -54, -54 - 4, 4, BOUNCE_DURATION, 0.16, _age);
		if (_interactive)
		{
			_blush.loadGraphic(AssetPaths.smear_blush__png, true, 356, 266);
			_blush.animation.add("default", blinkyAnimation([0, 1, 2]), 3);
			_blush.animation.add("c", blinkyAnimation([0, 1, 2]), 3);
			_blush.animation.add("se", blinkyAnimation([3, 4, 5]), 3);
			_blush.animation.add("sw", blinkyAnimation([6, 7, 8]), 3);
			_blush.animation.add("e", blinkyAnimation([9, 10, 11]), 3);
			_blush.animation.add("ee", blinkyAnimation([12, 13, 14]), 3);
			_blush.animation.add("w", blinkyAnimation([15, 16, 17]), 3);
			_blush.visible = false;
			addVisualItem(_blush);
		}

		_arms2 = new BouncySprite( -54, -54 - 4, 5, BOUNCE_DURATION, 0.09, _age);
		_arms2.loadWindowGraphic(AssetPaths.smear_arms2__png);
		_arms2.animation.add("3-2", [15]);
		_arms2.animation.add("3-1", [14]);
		_arms2.animation.add("3-0", [13]);
		_arms2.animation.add("2-2", [12]);
		_arms2.animation.add("2-1", [11]);
		_arms2.animation.add("2-0", [10]);
		_arms2.animation.add("1-2", [9]);
		_arms2.animation.add("1-1", [8]);
		_arms2.animation.add("1-0", [7]);
		_arms2.animation.add("0-2", [6]);
		_arms2.animation.add("0-1", [5]);
		_arms2.animation.add("0-0", [4]);
		_arms2.animation.add("default", [0]);
		_arms2.animation.add("sweater", [1]);
		_arms2.animation.add("cheer", [2]);
		_arms2.animation.add("sweater-cheer", [3]);
		_arms2.animation.add("uncomfortable", [0]);
		addPart(_arms2);

		_legs2 = new BouncySprite( -54, -54 - 4, 4, BOUNCE_DURATION, -0.09, _age);
		_legs2.loadWindowGraphic(AssetPaths.smear_legs2__png);
		_legs2.animation.add("default", [0]);
		_legs2.animation.add("0", [0]);
		_legs2.animation.add("1", [0]);
		_legs2.animation.add("2", [0]);
		_legs2.animation.add("3", [0]);
		_legs2.animation.add("4", [0]);
		_legs2.animation.add("5", [0]);
		_legs2.animation.add("6", [0]);
		_legs2.animation.add("4-0", [1]);
		_legs2.animation.add("4-1", [1]);
		_legs2.animation.add("4-2", [2]);
		_legs2.animation.add("4-3", [2]);
		_legs2.animation.add("rub-left-foot0", [1, 3, 4]);
		_legs2.animation.add("rub-left-foot1", [1, 5, 6]);
		_legs2.animation.add("rub-left-foot2", [1, 7, 8]);
		_legs2.animation.add("rub-right-foot0", [9, 10, 11]);
		_legs2.animation.add("rub-right-foot1", [9, 12, 13]);
		_legs2.animation.add("rub-right-foot2", [9, 14, 15]);
		addPart(_legs2);

		_interact = new BouncySprite( -54, -54, _dick._bounceAmount, _dick._bounceDuration, _dick._bouncePhase, _age);
		if (_interactive)
		{
			reinitializeHandSprites();
			add(_interact);

			addVisualItem(_vibe.vibeRemote);
			addVisualItem(_vibe.vibeInteract);
		}

		setNudity(PlayerData.level);

		if (_interactive)
		{
			_vibe.loadDickGraphic(SmeargleResource.dickVibe);
			if (PlayerData.smeaMale)
			{
				_vibe.dickFrameToVibeFrameMap = [
													0 => [0, 1, 2, 3, 4],
													1 => [5, 6, 7, 8, 9],
													2 => [10, 11, 12, 13, 14],
												];
			}
			else
			{
				_vibe.dickFrameToVibeFrameMap = [
													0 => [0, 1, 2, 3, 4, 5],
												];
			}
		}
	}

	override public function setNudity(NudityLevel:Int)
	{
		super.setNudity(NudityLevel);
		var sweaterAnim:String = "default";
		if (NudityLevel == 0)
		{
			_underwear.visible = true;
			sweaterAnim = "sweater";
			_balls.visible = false;
			_dick.visible = false;
		}
		if (NudityLevel == 1)
		{
			_underwear.visible = true;
			sweaterAnim = "default";
			_balls.visible = false;
			_dick.visible = false;
		}
		if (NudityLevel >= 2)
		{
			_underwear.visible = false;
			sweaterAnim = "default";
			_balls.visible = true;
			_dick.visible = true;
		}

		_arms0.animation.play(sweaterAnim);
		_arms1.animation.play(sweaterAnim);
		_torso0.animation.play(sweaterAnim);
		_torso1.animation.play(sweaterAnim);

		if (sweaterAnim == "sweater")
		{
			reposition(_torso1, members.indexOf(_legs1));
			reposition(_torso0, members.indexOf(_legs1));
		}
		else
		{
			reposition(_torso1, members.indexOf(_armsBehind));
			reposition(_torso0, members.indexOf(_armsBehind));
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (_cheerTimer > 0)
		{
			_cheerTimer -= elapsed;
			if (_cheerTimer <= 0.8 && _head.animation.name != "cheer1")
			{
				_head.animation.play("cheer1");
			}
		}

		if (_interactive && !SexyDebugState.debug)
		{
			_vibe.update(elapsed);
		}
	}

	override public function cheerful():Void
	{
		super.cheerful();

		_head.animation.play("cheer0");
		_arms0.animation.play(_arms0.animation.name == "sweater" ? "sweater-cheer" : "cheer");
		_armsBehind.animation.play(_arms0.animation.name);
		_arms1.animation.play(_arms0.animation.name);
		_arms2.animation.play(_arms0.animation.name);
		_cheerTimer = 3;
	}

	override public function arrangeArmsAndLegs():Void
	{
		var rubbingFeet:Bool = _interact.visible
		&& (_interact.animation.name == "rub-left-foot0"
		|| _interact.animation.name == "rub-left-foot1"
		|| _interact.animation.name == "rub-left-foot2"
		|| _interact.animation.name == "rub-right-foot0"
		|| _interact.animation.name == "rub-right-foot1"
		|| _interact.animation.name == "rub-right-foot2");
		var leftFootUp:Bool = _legs0.animation.name == "4-0" || _legs0.animation.name == "4-1";
		var rightFootUp:Bool = _legs0.animation.name == "4-2" || _legs0.animation.name == "4-3";
		if (rubbingFeet)
		{
			// can arrange legs; but, keep the same foot up
			if (leftFootUp)
			{
				_legs0.animation.play(FlxG.random.getObject(["4-0", "4-1"]));
			}
			else if (rightFootUp)
			{
				_legs0.animation.play(FlxG.random.getObject(["4-2", "4-3"]));
			}
		}
		else if (_vibe.dickVibe.visible)
		{
			// arrange legs so they don't block the cord
			playNewAnim(_legs0, ["1", "4", "5", "6"]);
		}
		else {
			// arrange legs normally
			playNewAnim(_legs0, ["0", "1", "2", "3", "4", "5", "6"]);
		}

		if (_uncomfortable)
		{
			playNewAnim(_arms0, ["uncomfortable"]);
		}
		else if (_comfort <= 0)
		{
			playNewAnim(_arms0, ["0-0", "0-1", "0-2"]);
		}
		else if (_comfort == 1)
		{
			playNewAnim(_arms0, ["1-0", "1-1", "1-2"]);
		}
		else if (_comfort == 2)
		{
			playNewAnim(_arms0, ["2-0", "2-1", "2-2"]);
		}
		else {
			playNewAnim(_arms0, ["3-0", "3-1", "3-2"]);
		}

		if (leftFootUp || rightFootUp)
		{
			avoidWonkyArmLegCombo();
		}

		syncArmsAndLegs();
	}

	public function syncArmsAndLegs():Void
	{
		if (_legs0.animation.name != null)
		{
			_legs1.animation.play(_legs0.animation.name);
			_legs2.animation.play(_legs0.animation.name);
		}
		if (_arms0.animation.name != null)
		{
			_armsBehind.animation.play(_arms0.animation.name);
			_arms1.animation.play(_arms0.animation.name);
			_arms2.animation.play(_arms0.animation.name);
		}
	}

	override public function setArousal(Arousal:Int)
	{
		super.setArousal(Arousal);
		if (_interact.visible
				&& (_interact.animation.name == "scritchhat-c"
					|| _interact.animation.name == "palmhat-c"))
		{
			if (_arousal >= 4)
			{
				_head.animation.play("rubhat4-c");
			}
			else if (_arousal >= 2)
			{
				_head.animation.play("rubhat2-c");
			}
			else
			{
				_head.animation.play("rubhat1-c");
			}
			return;
		}
		if (_uncomfortable)
		{
			playNewAnim(_head, ["uncomfortable-s"]);
		}
		else if (_arousal == 0)
		{
			playNewAnim(_head, ["0-s", "0-se", "0-sw"]);
		}
		else if (_arousal == 1)
		{
			playNewAnim(_head, ["1-e", "1-ee", "1-c"]);
		}
		else if (_arousal == 2)
		{
			playNewAnim(_head, ["2-w", "2-se", "2-e"]);
		}
		else if (_arousal == 3)
		{
			playNewAnim(_head, ["3-ee", "3-sw", "3-c"]);
		}
		else if (_arousal == 4)
		{
			playNewAnim(_head, ["4-w", "4-e", "4-se"]);
		}
		else if (_arousal == 5)
		{
			playNewAnim(_head, ["5-sw", "5-ee", "5-c"]);
		}
	}

	override public function playNewAnim(spr:FlxSprite, array:Array<String>)
	{
		super.playNewAnim(spr, array);
		if (spr == _head)
		{
			updateBlush();
		}
	}

	public function updateBlush()
	{
		var blushAnimName:String = _head.animation.name.substring(_head.animation.name.indexOf("-") + 1);
		if (_blush.animation.getByName(blushAnimName) != null)
		{
			_blush.animation.play(blushAnimName);
		}
		else
		{
			_blush.animation.play("default");
		}
	}

	/**
	 * Smeargle's arms and hand sometimes go behind his legs, or he'll sit
	 * cross-legged with his hands in front of his balls, things like that.
	 * But some of these combinations look weird or produce clipping errors.
	 *
	 * This method repositions Smeargle's limbs if they're in one of those
	 * combinations that looks bad.
	 */
	public function avoidWonkyArmLegCombo():Void
	{
		var leftFootUp:Bool = _legs0.animation.name == "4-0" || _legs0.animation.name == "4-1";
		var rightFootUp:Bool = _legs0.animation.name == "4-2" || _legs0.animation.name == "4-3";
		if (leftFootUp)
		{
			if (_arms0.animation.name == "2-0")
			{
				playNewAnim(_arms0, ["2-1", "2-2"]);
			}
			else if (_arms0.animation.name == "1-0")
			{
				playNewAnim(_arms0, ["1-1", "1-2"]);
			}
			else if (_arms0.animation.name == "uncomfortable")
			{
				playNewAnim(_arms0, ["0-0", "0-1", "0-2"]);
			}
		}
		else if (rightFootUp)
		{
			if (_arms0.animation.name == "2-2")
			{
				playNewAnim(_arms0, ["2-0", "2-1"]);
			}
			else if (_arms0.animation.name == "1-0" || _arms0.animation.name == "1-1")
			{
				playNewAnim(_arms0, ["1-2"]);
			}
			else if (_arms0.animation.name == "0-2" || _arms0.animation.name == "default" || _arms0.animation.name == "uncomfortable")
			{
				playNewAnim(_arms0, ["0-0", "0-1"]);
			}
		}
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		CursorUtils.initializeHandBouncySprite(_interact, AssetPaths.smear_interact__png);
		if (PlayerData.smeaMale)
		{
			_interact.animation.add("rub-dick", [0, 1, 2]);
			_interact.animation.add("jack-off", [8, 9, 10, 11, 12, 13]);
		}
		else
		{
			_interact.animation.add("rub-dick", [15, 23, 31, 39, 47]);
			_interact.animation.add("jack-off", [15, 48, 49, 50, 51, 52]);
		}
		_interact.animation.add("rub-balls", [3, 4, 5, 6, 7]);
		_interact.animation.add("pull-tongue", [16, 17, 18]);
		_interact.animation.add("rub-left-foot0", [24, 25, 26]);
		_interact.animation.add("rub-left-foot1", [24, 27, 28]);
		_interact.animation.add("rub-left-foot2", [24, 29, 30]);
		_interact.animation.add("rub-right-foot0", [32, 33, 34]);
		_interact.animation.add("rub-right-foot1", [32, 35, 36]);
		_interact.animation.add("rub-right-foot2", [32, 37, 38]);
		_interact.animation.add("scritchhat-c", [19, 20, 21, 22]);
		_interact.animation.add("palmhat-c", [40, 41, 42, 43]);
		_interact.visible = false;

		_vibe.reinitializeHandSprites();
	}

	public function setVibe(vibeVisible:Bool)
	{
		_vibe.setVisible(vibeVisible);
		_dick.visible = !vibeVisible;
		if (!vibeVisible)
		{
			_vibe.vibeSfx.setMode(VibeSfx.VibeMode.Off);
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		_tail = FlxDestroyUtil.destroy(_tail);
		_torso0 = FlxDestroyUtil.destroy(_torso0);
		_torso1 = FlxDestroyUtil.destroy(_torso1);
		_legs0 = FlxDestroyUtil.destroy(_legs0);
		_underwear = FlxDestroyUtil.destroy(_underwear);
		_balls = FlxDestroyUtil.destroy(_balls);
		_legs1 = FlxDestroyUtil.destroy(_legs1);
		_armsBehind = FlxDestroyUtil.destroy(_armsBehind);
		_arms0 = FlxDestroyUtil.destroy(_arms0);
		_arms1 = FlxDestroyUtil.destroy(_arms1);
		_arms2 = FlxDestroyUtil.destroy(_arms2);
		_neck = FlxDestroyUtil.destroy(_neck);
		_tongue = FlxDestroyUtil.destroy(_tongue);
		_blush = FlxDestroyUtil.destroy(_blush);
		_legs2 = FlxDestroyUtil.destroy(_legs2);
		_hat = FlxDestroyUtil.destroy(_hat);
		_vibe = FlxDestroyUtil.destroy(_vibe);
	}
}