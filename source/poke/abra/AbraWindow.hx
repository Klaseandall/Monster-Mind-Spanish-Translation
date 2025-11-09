package poke.abra;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;
import kludge.FlxSoundKludge;
import poke.abra.AbraDialog;

/**
 * Sprites and animations for Abra
 */
class AbraWindow extends PokeWindow
{
	private var _drinkTimer:Float = -1;
	public var _drunkAmount:Int = 0;
	public var _passedOut:Bool = false;

	public var _torso:BouncySprite;
	public var _legs:BouncySprite;
	public var _arms:BouncySprite;
	public var _ass:BouncySprite;

	public var _balls:BouncySprite;

	public var _feet:BouncySprite;
	public var _pants:BouncySprite;
	public var _undies:BouncySprite;
	public var _alcohol:BouncySprite;

	public function new(X:Float=0, Y:Float=0, Width:Int=248, Height:Int = 349)
	{
		super(X, Y, Width, Height);
		_prefix = "abra";
		_name = "Abra";
		add(new FlxSprite( -54, -54, AssetPaths.abra_bg__png));
		_victorySound = AssetPaths.abra__mp3;
		if (PlayerData.abraStoryInt == 4)
		{
			// moody
			_victorySound = FlxG.random.getObject([AssetPaths.abra0__mp3, AssetPaths.abra1__mp3, AssetPaths.abra2__mp3]);
		}
		_dialogClass = AbraDialog;

		_torso = new BouncySprite( -54, -54, 7, 7, 0.1, _age);
		_torso.loadWindowGraphic(AssetPaths.abra_torso__png);
		_torso.animation.add("default", [0]);
		_torso.animation.add("passed-out", [4, 4, 4, 5, 5, 6, 6, 7, 7, 7, 6, 6, 5, 5], 2);
		_torso.animation.play("default");
		addPart(_torso);

		_legs = new BouncySprite( -54, -54, 10, 7, 0.2, _age);
		_legs.loadWindowGraphic(AssetPaths.abra_legs__png);
		_legs.animation.add("default", [0]);
		_legs.animation.add("0", [0]);
		_legs.animation.add("1", [1]);
		_legs.animation.add("2", [2]);
		_legs.animation.add("raise-left-leg", [4]);
		_legs.animation.add("raise-right-leg", [5]);
		_legs.animation.add("passed-out", [3]);
		addPart(_legs);

		_ass = new BouncySprite( -54, -54, 7, 7, 0.1, _age);
		_ass.loadWindowGraphic(AssetPaths.abra_ass__png);
		_ass.animation.add("default", [7]);
		_ass.animation.add("finger-ass", [1, 2, 3, 4, 5, 6]);
		_ass.animation.play("default");
		addPart(_ass);

		_balls = new BouncySprite( -54, -54, 10, 7, 0.23, _age);
		_balls.loadWindowGraphic(AssetPaths.abra_balls__png);
		_balls.animation.add("default", [0]);
		_balls.animation.add("rub-balls", [4, 5, 6, 7]);

		_dick = new BouncySprite( -54, -54, 10, 7, 0.23, _age);
		_dick.loadWindowGraphic(AbraResource.dick);
		_dick.animation.add("default", [0]);

		if (PlayerData.abraMale)
		{
			addPart(_balls);
			_dick.animation.add("rub-dick", [6, 5, 4]);
			_dick.animation.add("jack-off", [12, 11, 10, 9, 8]);
			addPart(_dick);
		}
		else
		{
			_dick.animation.add("rub-dick", [8, 9, 10, 11, 12]);
			_dick.animation.add("jack-off", [16, 17, 18, 19, 20, 21]);
			_dick.animation.add("finger-ass", [1, 2, 3, 4, 5, 6]);
			addPart(_dick);
			_dick.synchronize(_torso);
		}

		_undies = new BouncySprite( -54, -54, 7, 7, PlayerData.abraMale ? 0.2 : 0.1, _age);
		_undies.loadWindowGraphic(AbraResource.undies);
		addPart(_undies);

		if (!PlayerData.abraMale)
		{
			// female abra's underwear goes behind the legs
			reposition(_undies, members.indexOf(_legs));
		}

		_pants = new BouncySprite( -54, -54, 10, 7, 0.2, _age);
		_pants.loadWindowGraphic(AbraResource.pants);
		addPart(_pants);

		_arms = new BouncySprite( -54, -54, 7, 7, 0.13, _age);
		_arms.loadWindowGraphic(AssetPaths.abra_arms__png);
		_arms.animation.add("default", [0]);
		_arms.animation.add("crossed", [0]);
		_arms.animation.add("cheer", [1]);
		_arms.animation.add("0", [2]);
		_arms.animation.add("1", [4]);
		_arms.animation.add("2", [5]);
		_arms.animation.add("3", [6]);
		_arms.animation.add("present-ipa", [8]);
		_arms.animation.add("drink-ipa", [9]);
		_arms.animation.add("hold-ipa", [10]);
		_arms.animation.add("present-sake", [11]);
		_arms.animation.add("drink-sake", [7]);
		_arms.animation.add("hold-sake", [3]);
		_arms.animation.add("present-soju", [11]);
		_arms.animation.add("drink-soju", [7]);
		_arms.animation.add("hold-soju", [3]);
		_arms.animation.add("present-rum", [12]);
		_arms.animation.add("drink-rum", [7]);
		_arms.animation.add("hold-rum", [3]);
		_arms.animation.add("present-absinthe", [12]);
		_arms.animation.add("drink-absinthe", [7]);
		_arms.animation.add("hold-absinthe", [3]);
		addPart(_arms);

		_head = new BouncySprite( -54, -54, 4, 7, 0);
		_head.loadGraphic(AbraResource.head, true, 356, 266);
		_head.animation.add("default", blinkyAnimation([0, 3]), 3);
		_head.animation.add("cheer", blinkyAnimation([1, 4]), 3);
		_head.animation.add("suck-fingers", [37, 38, 39]);
		_head.animation.add("0-0", blinkyAnimation([0, 3]), 3);
		_head.animation.add("0-1", blinkyAnimation([2, 5]), 3);
		_head.animation.add("1-0", blinkyAnimation([8, 9]), 3);
		_head.animation.add("drink", blinkyAnimation([6, 7]), 3);
		_head.animation.add("drunk0", blinkyAnimation([0, 3]), 3);
		_head.animation.add("drunk1", blinkyAnimation([14, 15]), 3);
		_head.animation.add("drunk2", blinkyAnimation([22, 23]), 3);
		_head.animation.add("drunk3", blinkyAnimation([30, 31]), 3);
		_head.animation.add("drunk4", blinkyAnimation([46, 47]), 3);
		_head.animation.add("1-1", blinkyAnimation([10, 11]), 3);
		_head.animation.add("1-2", blinkyAnimation([12, 13]), 3);
		_head.animation.add("2-0", blinkyAnimation([16, 17]), 3);
		_head.animation.add("2-1", blinkyAnimation([18, 19]), 3);
		_head.animation.add("2-2", blinkyAnimation([20, 21]), 3);
		_head.animation.add("3-0", blinkyAnimation([24, 25]), 3);
		_head.animation.add("3-1", blinkyAnimation([26, 27]), 3);
		_head.animation.add("3-2", blinkyAnimation([28, 29]), 3);
		_head.animation.add("4-0", blinkyAnimation([32, 33]), 3);
		_head.animation.add("4-1", blinkyAnimation([34, 35]), 3);
		_head.animation.add("5-0", blinkyAnimation([40, 41]), 3);
		_head.animation.add("5-1", blinkyAnimation([42, 43]), 3);
		_head.animation.add("passed-out", [36], 3);
		_head.animation.play("0-0");
		addPart(_head);

		_alcohol = new BouncySprite( -54, -54, 7, 7, 0.13, _age);
		_alcohol.loadWindowGraphic(AssetPaths.abra_alcohol__png);
		_alcohol.synchronize(_arms);
		_alcohol.animation.add("default", [0], 3);
		_alcohol.animation.add("present-ipa", [1], 3);
		_alcohol.animation.add("hold-ipa", [2], 3);
		_alcohol.animation.add("drink-ipa", [3], 3);
		_alcohol.animation.add("present-sake", [4], 3);
		_alcohol.animation.add("hold-sake", [5], 3);
		_alcohol.animation.add("drink-sake", [6], 3);
		_alcohol.animation.add("present-soju", [7], 3);
		_alcohol.animation.add("hold-soju", [8], 3);
		_alcohol.animation.add("drink-soju", [9], 3);
		_alcohol.animation.add("present-rum", [10], 3);
		_alcohol.animation.add("hold-rum", [11], 3);
		_alcohol.animation.add("drink-rum", [12], 3);
		_alcohol.animation.add("present-absinthe", [13], 3);
		_alcohol.animation.add("hold-absinthe", [14], 3);
		_alcohol.animation.add("drink-absinthe", [15], 3);
		_alcohol.animation.play("default");
		addVisualItem(_alcohol);

		_feet = new BouncySprite( -54, -54, 10, 7, 0.33, _age);
		_feet.loadWindowGraphic(AssetPaths.abra_feet__png);
		_feet.animation.add("default", [0]);
		_feet.animation.add("raise-left-leg", [1]);
		_feet.animation.add("raise-right-leg", [2]);
		addPart(_feet);

		_interact = new BouncySprite( -54, -54, _dick._bounceAmount, _dick._bounceDuration, _dick._bouncePhase, _age);

		if (_interactive)
		{
			reinitializeHandSprites();
			add(_interact);
		}

		setNudity(PlayerData.level);
	}

	/**
	 * Trigger some sort of animation or behavior based on a dialog sequence
	 * 
	 * @param	str the special dialog which might trigger an animation or behavior
	 */
	override public function doFun(str:String)
	{
		super.doFun(str);
		if (_passedOut)
		{
			// don't drink or anything if we're passed out; shouldn't happen anyways, but...
			return;
		}
		if (StringTools.startsWith(str, "present-"))
		{
			// presenting alcohol
			if (str == "present-rum" || str == "present-absinthe")
			{
				// don't smile for rum or absinthe
			}
			else if (PlayerData.abraStoryInt == 4)
			{
				// don't smile if we're upset
			}
			else
			{
				_head.animation.play("cheer");
			}
			_arms.animation.play(str);
			_alcohol.animation.play(str);
			_drinkTimer = -1;
		}
		if (StringTools.startsWith(str, "hold-"))
		{
			if (_arms.animation.name == str || _arms.animation.name == "drink-" + MmStringTools.substringAfter(str, "hold-"))
			{
				/*
				 * we're already holding/drinking the appropriate alcohol;
				 * don't interrupt the animation
				 */
			}
			else
			{
				// holding/drinking alcohol
				playDrunkHeadAnim();
				_arms.animation.play(str);
				_alcohol.animation.play(str);

				if (PlayerData.level == 2)
				{
					// don't drink on the last level; fall asleep
				}
				else
				{
					_drinkTimer = 11;
				}
			}
		}
		if (StringTools.startsWith(str, "drunk"))
		{
			var drunkAmountStr:String = str.substring(5, 6);
			_drunkAmount = Std.parseInt(drunkAmountStr);
			playDrunkHeadAnim();
		}
	}

	override public function setNudity(NudityLevel:Int)
	{
		super.setNudity(NudityLevel);
		if (NudityLevel == 0)
		{
			_pants.visible = true;
			_undies.visible = false;
			_ass.visible = false;
			_balls.visible = false;
			_dick.visible = false;
			_feet.visible = false;
		}
		if (NudityLevel == 1)
		{
			_pants.visible = false;
			_undies.visible = true;
			_ass.visible = false;
			_balls.visible = false;
			_dick.visible = false;
			_feet.visible = false;
		}
		if (NudityLevel >= 2)
		{
			_pants.visible = false;
			_undies.visible = false;
			_ass.visible = true;
			_balls.visible = true;
			_dick.visible = true;
			_feet.visible = true;
		}
	}

	override public function cheerful():Void
	{
		if (PlayerData.finalTrial && PlayerData.level == 2)
		{
			setPassedOut();
		}
		if (_passedOut || _drunkAmount >= 4)
		{
			// too drunk to notice
			return;
		}
		super.cheerful();
		if (PlayerData.abraStoryInt == 4)
		{
			// moody
		}
		else if (_alcohol.animation.name == "default")
		{
			_arms.animation.play("cheer");
			_head.animation.play("cheer");
		}
		else {
			playHoldAnim();
			_head.animation.play("cheer");
			_drinkTimer = -1;
		}
	}

	override public function arrangeArmsAndLegs()
	{
		_feet.animation.play("default");
		playNewAnim(_legs, ["0", "1", "2"]);
		if (_arousal == 0)
		{
			playNewAnim(_arms, ["crossed", "0", "1"]);
		}
		else
		{
			playNewAnim(_arms, ["0", "1", "2", "3"]);
		}
	}

	override public function setArousal(Arousal:Int)
	{
		super.setArousal(Arousal);
		if (_arousal == 0)
		{
			playNewAnim(_head, ["0-0", "0-1"]);
		}
		else if (_arousal == 1)
		{
			playNewAnim(_head, ["1-0", "1-1", "1-2"]);
		}
		else if (_arousal == 2)
		{
			playNewAnim(_head, ["2-0", "2-1", "2-2"]);
		}
		else if (_arousal == 3)
		{
			playNewAnim(_head, ["3-0", "3-1", "3-2"]);
		}
		else if (_arousal == 4)
		{
			playNewAnim(_head, ["4-0", "4-1"]);
		}
		else if (_arousal == 5)
		{
			playNewAnim(_head, ["5-0", "5-1"]);
		}
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		CursorUtils.initializeHandBouncySprite(_interact, AssetPaths.abra_interact__png);
		if (PlayerData.abraMale)
		{
			_interact.animation.add("rub-dick", [2, 1, 0]);
			_interact.animation.add("jack-off", [12, 11, 10, 9, 8]);
			_interact.animation.add("rub-balls", [4, 5, 6, 7]);
		}
		else
		{
			_interact.animation.add("rub-dick", [32, 33, 34, 35, 36]);
			_interact.animation.add("jack-off", [40, 41, 42, 43, 44, 45]);
		}
		_interact.animation.add("suck-fingers", [13, 14, 15]);
		_interact.animation.add("finger-ass", [16, 17, 18, 19, 20, 21]);
		_interact.animation.add("rub-left-foot", [24, 25, 26, 27]);
		_interact.animation.add("rub-right-foot", [28, 29, 30, 31]);
		_interact.visible = false;
	}

	override public function destroy():Void
	{
		super.destroy();

		_torso = FlxDestroyUtil.destroy(_torso);
		_legs = FlxDestroyUtil.destroy(_legs);
		_arms = FlxDestroyUtil.destroy(_arms);
		_ass = FlxDestroyUtil.destroy(_ass);
		_balls = FlxDestroyUtil.destroy(_balls);
		_feet = FlxDestroyUtil.destroy(_feet);
		_pants = FlxDestroyUtil.destroy(_pants);
		_undies = FlxDestroyUtil.destroy(_undies);
		_alcohol = FlxDestroyUtil.destroy(_alcohol);
	}

	public function setPassedOut():Void
	{
		if (_passedOut)
		{
			return;
		}

		FlxSoundKludge.play(AssetPaths.passed_out_00e1__mp3);

		_passedOut = true;
		_drinkTimer = -1;

		_head.y = -54 + 266;
		_head.animation.play("passed-out");
		_torso.animation.play("passed-out");
		_torso._bounceAmount = 2;
		_legs.animation.play("passed-out");
		_legs._bounceAmount = 2;

		_dick.visible = false;
		_arms.visible = false;
		_ass.visible = false;
		_balls.visible = false;
		_feet.visible = false;
		_pants.visible = false;
		_undies.visible = false;
		_alcohol.visible = false;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (_drinkTimer > 0)
		{
			_drinkTimer -= elapsed;
			if (_drinkTimer <= 0)
			{
				if (StringTools.startsWith(_alcohol.animation.name, "hold-"))
				{
					playDrinkAnim();
				}
				else if (StringTools.startsWith(_alcohol.animation.name, "drink-"))
				{
					playHoldAnim();
				}
			}
		}
	}

	private function playDrinkAnim():Void
	{
		var drinkAnim = "drink-" + MmStringTools.substringAfter(_alcohol.animation.name, "-");
		_arms.animation.play(drinkAnim);
		_alcohol.animation.play(drinkAnim);
		_head.animation.play("drink");
		_drinkTimer = 2.5;
	}

	private function playHoldAnim():Void
	{
		var holdAnim = "hold-" + MmStringTools.substringAfter(_alcohol.animation.name, "-");
		_arms.animation.play(holdAnim);
		_alcohol.animation.play(holdAnim);
		playDrunkHeadAnim();
		_drinkTimer = 22;
	}

	private function playDrunkHeadAnim():Void
	{
		_head.animation.play("drunk" + _drunkAmount);
	}
}