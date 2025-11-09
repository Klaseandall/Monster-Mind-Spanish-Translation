package poke.grov;

import demo.SexyDebugState;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import kludge.FlxSoundKludge;
import openfl.Assets;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import poke.buiz.BuizelResource;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * Sprites and animations for Grovyle
 */
class GrovyleWindow extends PokeWindow
{
	// the headfin
	public var _hair:BouncySprite;

	public var _tail:BouncySprite;
	public var _torso:BouncySprite;
	public var _arms0:BouncySprite;
	public var _legs:BouncySprite;
	public var _feet:BouncySprite;
	public var _pantiesWaistband0:BouncySprite;
	public var _pantiesWaistband1:BouncySprite;
	public var _underwear:BouncySprite;
	public var _pants:BouncySprite;
	public var _arms1:BouncySprite;
	public var _ass:BouncySprite;
	public var _balls:BouncySprite;

	public var _vibe:Vibe;

	public var _selfTouchTarget:BouncySprite;

	public function new(X:Float=0, Y:Float=0, Width:Int=248, Height:Int = 349)
	{
		super(X, Y, Width, Height);
		_prefix = "grov";
		_name = "Grovyle";
		_victorySound = AssetPaths.grovyle__mp3;
		_dialogClass = GrovyleDialog;
		add(new FlxSprite( -54, -54, AssetPaths.grovyle_bg__png));

		_hair = new BouncySprite( -54, -54 - 3, 6, 5, 0.3, _age);
		_hair.loadWindowGraphic(AssetPaths.grovyle_head0__png);
		_hair.animation.add("c", [0]);
		_hair.animation.add("cheer", [1]);
		_hair.animation.add("n", [2]);
		_hair.animation.add("w", [3]);
		_hair.animation.add("cocked", [4]);
		_hair.animation.add("s", [5]);
		_hair.animation.add("nw", [6]);
		addPart(_hair);

		_tail = new BouncySprite( -54, -54, 0, 5, 0.1, _age);
		_tail.loadWindowGraphic(AssetPaths.grovyle_tail__png);
		addPart(_tail);

		_torso = new BouncySprite( -54, -54 - 2, 2, 5, 0.1, _age);
		_torso.loadWindowGraphic(AssetPaths.grovyle_torso__png);
		_torso.animation.add("default", [0]);
		_torso.animation.add("cheer", [1]);
		addPart(_torso);

		_arms0 = new BouncySprite( -54, -54 - 2, 2, 5, 0.15, _age);
		_arms0.loadWindowGraphic(AssetPaths.grovyle_arms0__png);
		_arms0.animation.add("default", [0]);
		_arms0.animation.add("cheer", [1]);
		_arms0.animation.add("0", [0]);
		_arms0.animation.add("1", [2]);
		_arms0.animation.add("2", [3]);
		_arms0.animation.add("3", [4]);
		_arms0.animation.add("4", [5]);
		addPart(_arms0);

		_pantiesWaistband0 = new BouncySprite( -54, -54, 0, 5, 0.1, _age);
		_pantiesWaistband0.loadWindowGraphic(AssetPaths.grovyle_panties_waistband0__png);
		if (!PlayerData.grovMale)
		{
			addPart(_pantiesWaistband0);
		}

		_legs = new BouncySprite( -54, -54, 0, 5, 0.1, _age);
		_legs.loadWindowGraphic(AssetPaths.grovyle_legs__png);
		_legs.animation.add("default", [0]);
		_legs.animation.add("0", [0]);
		_legs.animation.add("1", [1]);
		_legs.animation.add("2", [2]);
		_legs.animation.add("3", [3]);
		_legs.animation.add("4", [4]);
		_legs.animation.add("raise-left-leg", [5]);
		_legs.animation.add("raise-right-leg", [6]);
		addPart(_legs);

		_underwear = new BouncySprite( -54, -54, 0, 5, 0.1, _age);
		addPart(_underwear);

		_pantiesWaistband1 = new BouncySprite( -54, -54, 0, 5, 0.1, _age);
		_pantiesWaistband1.loadWindowGraphic(AssetPaths.grovyle_panties_waistband1__png);
		if (!PlayerData.grovMale)
		{
			addPart(_pantiesWaistband1);
		}

		_pants = new BouncySprite( -54, -54, 0, 5, 0.1, _age);
		addPart(_pants);

		_arms1 = new BouncySprite( -54, -54 - 2, 2, 5, 0.15, _age);
		_arms1.loadWindowGraphic(AssetPaths.grovyle_arms1__png);
		_arms1.animation.add("default", [0]);
		_arms1.animation.add("cheer", [1]);
		_arms1.animation.add("0", [0]);
		_arms1.animation.add("1", [2]);
		_arms1.animation.add("2", [3]);
		_arms1.animation.add("3", [4]);
		_arms1.animation.add("4", [5]);
		if (PlayerData.grovMale)
		{
			_arms1.animation.add("self-dick", [6, 7, 8, 7], 3);
			_arms1.animation.add("self-balls", [9, 10, 11, 10], 3);
		}
		else
		{
			_arms1.animation.add("self-dick", [16, 17, 18, 17], 3);
		}
		_arms1.animation.add("self-ass", [12, 13, 14, 13], 3);
		addPart(_arms1);

		_ass = new BouncySprite( -54, -54 - 4, 4, 5, 0.1, _age);
		_ass.loadWindowGraphic(AssetPaths.grovyle_ass__png);
		_ass.animation.add("default", [0]);
		_ass.animation.add("finger-ass", [0, 1, 2, 3, 4]);
		_ass.animation.add("self-ass", [0, 1, 2, 1], 3);
		addPart(_ass);

		_balls = new BouncySprite( -54, -54 - 4, 4, 5, 0.95, _age);
		_balls.loadWindowGraphic(AssetPaths.grovyle_balls__png);

		_dick = new BouncySprite( -54, -54 - 4, 4, 5, 0.95, _age);
		addPart(_dick);

		if (_interactive)
		{
			_vibe = new Vibe(_dick, -54, -54 - 4);
			addPart(_vibe.dickVibe);
			addVisualItem(_vibe.dickVibeBlur);
		}

		_head = new BouncySprite( -54, -54 - 3, 3, 5, 0.2, _age);
		addPart(_head);

		_feet = new BouncySprite( -54, -54, 0, 5, 0.1, _age);
		_feet.loadWindowGraphic(AssetPaths.grovyle_feet__png);
		_feet.animation.add("default", [0]);
		_feet.animation.add("raise-left-leg", [1]);
		_feet.animation.add("raise-right-leg", [2]);
		addPart(_feet);

		_interact = new BouncySprite( -54, -54, _dick._bounceAmount, _dick._bounceDuration, _dick._bouncePhase, _age);
		if (_interactive)
		{
			reinitializeHandSprites();
			add(_interact);

			addVisualItem(_vibe.vibeRemote);
			addVisualItem(_vibe.vibeInteract);
		}

		setNudity(PlayerData.level);
		refreshGender();
	}

	override public function refreshGender()
	{
		_underwear.loadWindowGraphic(GrovyleResource.underwear);
		if (!PlayerData.grovMale)
		{
			_underwear.synchronize(_torso);
		}

		_pants.loadWindowGraphic(GrovyleResource.pants);

		_dick.loadWindowGraphic(GrovyleResource.dick);
		_dick.animation.add("default", [0]);
		if (PlayerData.grovMale)
		{
			_balls.animation.add("default", [0]);
			_balls.animation.add("rub-balls", [1, 2, 3, 4]);
			_balls.animation.add("self-balls", [2, 3, 4, 3], 3);
			addPart(_balls);
			reposition(_balls, members.indexOf(_dick));

			_dick.animation.add("rub-dick", [1, 2, 3, 4]);
			_dick.animation.add("jack-off", [8, 9, 10, 11, 12]);
			_dick.animation.add("self-dick", [2, 3, 4, 3], 3);
		}
		else
		{
			removePart(_balls);
			_dick._bouncePhase = 0.15;
			_dick.animation.add("rub-dick", [1, 2, 3, 4, 5]);
			_dick.animation.add("jack-off", [8, 9, 10, 11, 12, 13]);
			_dick.animation.add("self-dick", [0, 1, 2, 1], 3);
			_dick.animation.add("finger-ass", [0, 6, 6, 7, 7]);
			_dick.animation.add("self-ass", [0, 6, 6, 0], 3);
		}

		_head.loadGraphic(GrovyleResource.head1, true, 356, 266);
		_head.animation.add("default", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("cheer", blinkyAnimation([3, 4]), 3);
		_head.animation.add("0-c", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("0-s", blinkyAnimation([5, 6], [7]), 3);
		_head.animation.add("0-nw", blinkyAnimation([8, 9], [10]), 3);
		_head.animation.add("1-w", blinkyAnimation([12, 13], [14]), 3);
		_head.animation.add("1-cocked", blinkyAnimation([15, 16], [17]), 3);
		_head.animation.add("1-s", blinkyAnimation([18, 19], [20]), 3);
		_head.animation.add("2-n", blinkyAnimation([24, 25]), 3);
		_head.animation.add("2-c", blinkyAnimation([26, 27]), 3);
		_head.animation.add("2-w", blinkyAnimation([28, 29]), 3);
		_head.animation.add("3-cocked", blinkyAnimation([36, 37], [38]), 3);
		_head.animation.add("3-c", blinkyAnimation([39, 40], [41]), 3);
		_head.animation.add("3-w", blinkyAnimation([42, 43], [44]), 3);
		_head.animation.add("4-s", blinkyAnimation([48, 49], [50]), 3);
		_head.animation.add("4-cocked", blinkyAnimation([51, 52], [53]), 3);
		_head.animation.add("4-n", blinkyAnimation([54, 55], [56]), 3);
		_head.animation.add("5-nw", blinkyAnimation([60, 61]), 3);
		_head.animation.add("5-w", blinkyAnimation([62, 63]), 3);
		_head.animation.add("5-c", blinkyAnimation([64, 65]), 3);
		_head.animation.play("0-c");

		if (_interactive)
		{
			_vibe.loadDickGraphic(GrovyleResource.dickVibe);
			if (PlayerData.grovMale)
			{
				_vibe.dickFrameToVibeFrameMap = [
													0 => [0, 1, 2, 3, 4],
													1 => [5, 6, 7, 8, 9],
													5 => [10, 11, 12, 13, 14],
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

	override public function cheerful()
	{
		super.cheerful();
		_hair.animation.play("cheer");
		_torso.animation.play("cheer");
		_head.animation.play("cheer");
		_arms0.animation.play("cheer");
		_arms1.animation.play("cheer");
	}

	override public function setNudity(NudityLevel:Int)
	{
		super.setNudity(NudityLevel);
		if (NudityLevel == 0)
		{
			_pants.visible = true;
			_pantiesWaistband0.visible = false;
			_pantiesWaistband1.visible = false;
			_underwear.visible = false;
			_balls.visible = false;
			_dick.visible = false;
			_ass.visible = false;
		}
		if (NudityLevel == 1)
		{
			_pants.visible = false;
			_pantiesWaistband0.visible = true;
			_pantiesWaistband1.visible = true;
			_underwear.visible = true;
			_balls.visible = false;
			_dick.visible = false;
			_ass.visible = false;
		}
		if (NudityLevel >= 2)
		{
			_pants.visible = false;
			_pantiesWaistband0.visible = false;
			_pantiesWaistband1.visible = false;
			_underwear.visible = false;
			_balls.visible = true;
			_dick.visible = true;
			_ass.visible = true;
		}
	}

	override public function setArousal(Arousal:Int)
	{
		super.setArousal(Arousal);
		if (_arousal == 0)
		{
			playNewAnim(_head, ["0-c", "0-s", "0-nw"]);
		}
		else if (_arousal == 1)
		{
			playNewAnim(_head, ["1-w", "1-cocked", "1-s"]);
		}
		else if (_arousal == 2)
		{
			playNewAnim(_head, ["2-n", "2-c", "2-w"]);
		}
		else if (_arousal == 3)
		{
			playNewAnim(_head, ["3-cocked", "3-c", "3-w"]);
		}
		else if (_arousal == 4)
		{
			playNewAnim(_head, ["4-s", "4-cocked", "4-n"]);
		}
		else if (_arousal == 5)
		{
			playNewAnim(_head, ["5-nw", "5-w", "5-c"]);
		}
		var hairAnimName:String = _head.animation.name.substring(_head.animation.name.indexOf("-") + 1);
		playNewAnim(_hair, [hairAnimName]);
	}

	override public function nudgeArousal(Arousal:Int)
	{
		super.nudgeArousal(Arousal);

		// 3 is a weird special purpose grovyle face. If someone explicitly says to nudge us to 3,
		// we should go straight to 3. If someone doesn't tell us to nudge to 3, we should skip 3.
		if (Arousal == 3 && _arousal != 3 || _arousal == 3 && Arousal != 3)
		{
			super.nudgeArousal(Arousal);
		}
	}

	public function startTouchingSelf(touchedPart:BouncySprite):Void
	{
		reposition(_arms1, members.indexOf(touchedPart) + 1);
		_arms1.synchronize(touchedPart);
		_arms0.animation.play("4");
		_arms1.animation.play("4");
		_selfTouchTarget = touchedPart;
	}

	public function stopTouchingSelf():Void
	{
		if (_selfTouchTarget != null)
		{
			reposition(_arms1, members.indexOf(_pants));
			_arms1.synchronize(_arms0);
			_arms0.animation.play("4");
			_arms1.animation.play("4");
			_selfTouchTarget.animation.play("default");
			_selfTouchTarget = null;
		}
	}

	override public function arrangeArmsAndLegs()
	{
		_feet.animation.play("default");
		if (_selfTouchTarget == null)
		{
			if (_arousal == 0)
			{
				playNewAnim(_arms0, ["0"]);
			}
			else
			{
				playNewAnim(_arms0, ["0", "1", "2", "3", "4"]);
			}
			_arms1.animation.play(_arms0.animation.name);
		}
		if (_arms0.animation.name == "2")
		{
			// hand on grovyle's right knee (our left)
			playNewAnim(_legs, ["0", "1"]);
		}
		else if (_arms0.animation.name == "0")
		{
			// hand on grovyle's left knee (our right)
			playNewAnim(_legs, ["0", "2"]);
		}
		else
		{
			playNewAnim(_legs, ["0", "1", "2", "3", "4"]);
		}
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		CursorUtils.initializeHandBouncySprite(_interact, AssetPaths.grovyle_interact__png);
		if (PlayerData.grovMale)
		{
			_interact.animation.add("rub-dick", [0, 1, 2, 3]);
			_interact.animation.add("jack-off", [8, 9, 10, 11, 12]);
			_interact.animation.add("rub-balls", [4, 5, 6, 7]);
		}
		else
		{
			_interact.animation.add("rub-dick", [32, 33, 34, 35, 36]);
			_interact.animation.add("jack-off", [40, 41, 42, 43, 44, 45]);
		}
		_interact.animation.add("finger-ass", [16, 17, 18, 19, 20]);
		_interact.animation.add("rub-left-foot", [26, 27, 28, 29, 30]);
		_interact.animation.add("rub-right-foot", [25, 24, 23, 22, 21]);
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

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (_interactive && !SexyDebugState.debug)
		{
			_vibe.update(elapsed);
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		_hair = FlxDestroyUtil.destroy(_hair);
		_tail = FlxDestroyUtil.destroy(_tail);
		_torso = FlxDestroyUtil.destroy(_torso);
		_arms0 = FlxDestroyUtil.destroy(_arms0);
		_legs = FlxDestroyUtil.destroy(_legs);
		_feet = FlxDestroyUtil.destroy(_feet);
		_pantiesWaistband0 = FlxDestroyUtil.destroy(_pantiesWaistband0);
		_pantiesWaistband1 = FlxDestroyUtil.destroy(_pantiesWaistband1);
		_underwear = FlxDestroyUtil.destroy(_underwear);
		_pants = FlxDestroyUtil.destroy(_pants);
		_arms1 = FlxDestroyUtil.destroy(_arms1);
		_ass = FlxDestroyUtil.destroy(_ass);
		_balls = FlxDestroyUtil.destroy(_balls);
		_vibe = FlxDestroyUtil.destroy(_vibe);
		_selfTouchTarget = FlxDestroyUtil.destroy(_selfTouchTarget);
	}
}