package poke.hera;
import demo.SexyDebugState;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;
import poke.grov.Vibe;

/**
 * Sprites and animations for Heracross, when they're solving puzzles/having
 * sex (not in the shop)
 */
class HeraWindow extends PokeWindow
{
	public var _torso0:BouncySprite;
	public var _torso1:BouncySprite;
	public var _arms0:BouncySprite;
	public var _arms1:BouncySprite;
	public var _balls:BouncySprite;
	public var _panties:BouncySprite;
	public var _legs:BouncySprite;
	public var _blush:BouncySprite;

	public var _armsUpTimer:Float = 0;

	public var _vibe:Vibe;

	public function new(X:Float=0, Y:Float=0, Width:Int=248, Height:Int = 349)
	{
		super(X, Y, Width, Height);
		_prefix = "hera";
		_name = "Heracross";
		_victorySound = AssetPaths.hera__mp3;
		_dialogClass = HeraDialog;
		add(new FlxSprite( -54, -54, AssetPaths.hera_bg__png));

		_head = new BouncySprite( -54, -54 - 4, 4, 8.4, 0, _age);
		_head.loadGraphic(HeraResource.head, true, 356, 266);
		_head.animation.add("default", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("cheer", blinkyAnimation([3, 4]), 3);
		_head.animation.add("0-0", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("0-1", blinkyAnimation([6, 7], [8]), 3);
		_head.animation.add("0-2", blinkyAnimation([9, 10], [11]), 3);
		_head.animation.add("1-0", blinkyAnimation([12, 13], [14]), 3);
		_head.animation.add("1-1", blinkyAnimation([15, 16], [17]), 3);
		_head.animation.add("1-2", blinkyAnimation([18, 19], [20]), 3);
		_head.animation.add("2-0", blinkyAnimation([24, 25], [26]), 3);
		_head.animation.add("2-1", blinkyAnimation([27, 28], [29]), 3);
		_head.animation.add("2-2", blinkyAnimation([30, 31], [32]), 3);
		_head.animation.add("3-0", blinkyAnimation([36, 37]), 3);
		_head.animation.add("3-1", blinkyAnimation([39, 40]), 3);
		_head.animation.add("3-2", blinkyAnimation([42, 43]), 3);
		_head.animation.add("4-0", blinkyAnimation([48, 49, 50]), 3);
		_head.animation.add("4-1", blinkyAnimation([51, 52, 53]), 3);
		_head.animation.add("4-2", blinkyAnimation([54, 55, 56]), 3);
		_head.animation.add("5-0", blinkyAnimation([60, 61]), 3);
		_head.animation.add("5-1", blinkyAnimation([63, 64]), 3);
		_head.animation.add("5-2", blinkyAnimation([66, 67]), 3);
		_head.animation.add("rub-left-antenna", blinkyAnimation([54, 55, 56]), 3);
		_head.animation.add("rub-right-antenna", blinkyAnimation([54, 55, 56]), 3);
		_head.animation.add("rub-horn", blinkyAnimation([45, 46], [47]), 3);
		_head.animation.add("rub-horn2", blinkyAnimation([57, 58], [59]), 3);
		_head.animation.add("right-eye-swirl", blinkyAnimation([21, 22, 23]), 3);
		_head.animation.add("left-eye-swirl", blinkyAnimation([33, 34, 35]), 3);
		_head.animation.play("default");
		addPart(_head);

		_blush = new BouncySprite( -54, -54 - 4, 4, 8.4, 0, _age);
		if (_interactive)
		{
			_blush.loadGraphic(AssetPaths.hera_blush__png, true, 356, 266);
			_blush.animation.add("default", blinkyAnimation([0, 1, 2]), 3);
			_blush.animation.add("cheer", blinkyAnimation([30, 31, 32]), 3);
			_blush.animation.add("0-0", blinkyAnimation([0, 1, 2]), 3);
			_blush.animation.add("0-1", blinkyAnimation([30, 31, 32]), 3);
			_blush.animation.add("0-2", blinkyAnimation([15, 16, 17]), 3);
			_blush.animation.add("1-0", blinkyAnimation([12, 13, 14]), 3);
			_blush.animation.add("1-1", blinkyAnimation([3, 4, 5]), 3);
			_blush.animation.add("1-2", blinkyAnimation([24, 25, 26]), 3);
			_blush.animation.add("2-0", blinkyAnimation([18, 19, 20]), 3);
			_blush.animation.add("2-1", blinkyAnimation([33, 34, 35], [29]), 3);
			_blush.animation.add("2-2", blinkyAnimation([6, 7, 8]), 3);
			_blush.animation.add("3-0", blinkyAnimation([24, 25, 26]), 3);
			_blush.animation.add("3-1", blinkyAnimation([21, 22, 23]), 3);
			_blush.animation.add("3-2", blinkyAnimation([0, 1, 2]), 3);
			_blush.animation.add("4-0", blinkyAnimation([30, 31, 32]), 3);
			_blush.animation.add("4-1", blinkyAnimation([9, 10, 11]), 3);
			_blush.animation.add("4-2", blinkyAnimation([27, 28, 29]), 3);
			_blush.animation.add("5-0", blinkyAnimation([6, 7, 8]), 3);
			_blush.animation.add("5-1", blinkyAnimation([18, 19, 20]), 3);
			_blush.animation.add("5-2", blinkyAnimation([12, 13, 14]), 3);
			_blush.animation.add("rub-left-antenna", blinkyAnimation([27, 28, 29]), 3);
			_blush.animation.add("rub-right-antenna", blinkyAnimation([27, 28, 29]), 3);
			_blush.animation.add("rub-horn", blinkyAnimation([15, 16, 17]), 3);
			_blush.animation.add("rub-horn2", blinkyAnimation([15, 16, 17]), 3);
			_blush.animation.add("right-eye-swirl", blinkyAnimation([27, 28, 29]), 3);
			_blush.animation.add("left-eye-swirl", blinkyAnimation([27, 28, 29]), 3);
			_blush.visible = false;
			addVisualItem(_blush);
		}

		_torso1 = new BouncySprite( -54, -54 - 3, 3, 8.4, 0.08, _age);
		_torso1.loadWindowGraphic(AssetPaths.hera_torso1__png);
		addPart(_torso1);

		_torso0 = new BouncySprite( -54, -54 - 2, 2, 8.4, 0.16, _age);
		_torso0.loadWindowGraphic(HeraResource.torso0);
		addPart(_torso0);

		_balls = new BouncySprite( -54, -54 - 1, 1, 8.4, 0.20, _age);
		_balls.loadWindowGraphic(AssetPaths.hera_balls__png);

		_dick = new BouncySprite( -54, -54 - 2, 2, 8.4, 0.24, _age);
		_dick.loadWindowGraphic(HeraResource.dick);

		_panties = new BouncySprite( -54, -54 - 2, 2, 8.4, 0.16, _age);
		_panties.loadWindowGraphic(AssetPaths.hera_panties__png);

		if (PlayerData.heraMale)
		{
			// add dick/balls later
		}
		else
		{
			_dick.animation.add("default", [0]);
			_dick.animation.add("rub-dick", [1, 2, 3, 4]);
			_dick.animation.add("jack-off", [5, 6, 7, 8, 9]);
			addPart(_dick);
			_dick.synchronize(_torso0);

			if (_interactive)
			{
				_vibe = new Vibe(_dick, -54, -54 - 2);
				addPart(_vibe.dickVibe);
				addVisualItem(_vibe.dickVibeBlur);
			}

			addPart(_panties);
		}

		_legs = new BouncySprite( -54, -54, 0, 8.4, 0.24, _age);
		_legs.loadWindowGraphic(HeraResource.legs);
		_legs.animation.add("default", [0]);
		_legs.animation.add("boxers", [1]);
		_legs.animation.add("pants", [2]);
		_legs.animation.add("fix-boxers", [3]);
		_legs.animation.add("0", [0]);
		_legs.animation.add("1", [4]);
		_legs.animation.add("2", [5]);
		_legs.animation.add("3", [6]);
		_legs.animation.add("4", [7]);
		_legs.animation.add("5", [8]);
		_legs.animation.add("6", [9]);
		_legs.animation.add("7", [10]);
		addPart(_legs);

		_arms1 = new BouncySprite( -54, -54 - 3, 3, 8.4, 0.12, _age);
		_arms1.loadWindowGraphic(AssetPaths.hera_arms1__png);
		_arms1.animation.add("default", [0]);
		_arms1.animation.add("cheer", [1]);
		_arms1.animation.add("0", [0]);
		_arms1.animation.add("1", [2]);
		_arms1.animation.add("2", [3]);
		_arms1.animation.add("3", [4]);
		_arms1.animation.add("face-0", [5]);
		_arms1.animation.add("face-1", [6]);
		addPart(_arms1);

		_arms0 = new BouncySprite( -54, -54 - 2, 2, 8.4, 0.04, _age);
		_arms0.loadWindowGraphic(AssetPaths.hera_arms0__png);
		_arms0.animation.add("default", [0]);
		_arms0.animation.add("cheer", [1]);
		_arms0.animation.add("0", [0]);
		_arms0.animation.add("1", [2]);
		_arms0.animation.add("2", [3]);
		_arms0.animation.add("3", [4]);
		_arms0.animation.add("face-0", [5]);
		_arms0.animation.add("face-1", [6]);
		addPart(_arms0);

		if (PlayerData.heraMale)
		{
			_balls.animation.add("default", [0]);
			_balls.animation.add("rub-balls", [1, 2, 3, 4]);
			addPart(_balls);
			_dick.animation.add("default", [0]);
			_dick.animation.add("boner1", [2]);
			_dick.animation.add("boner2", [3]);
			_dick.animation.add("boxers", [1]);
			_dick.animation.add("rub-dick", [4, 5, 6, 7, 8]);
			_dick.animation.add("jack-off", [15, 14, 13, 12, 11, 10, 9]);
			addPart(_dick);

			if (_interactive)
			{
				_vibe = new Vibe(_dick, -54, -54 - 2);
				addPart(_vibe.dickVibe);
				addVisualItem(_vibe.dickVibeBlur);
			}
		}
		else
		{
			// added vagina/panties earlier
		}

		_interact = new BouncySprite( -54, -54, _dick._bounceAmount, _dick._bounceDuration, _dick._bouncePhase, _age);
		if (_interactive)
		{
			reinitializeHandSprites();
			add(_interact);

			// adjust remote location; heracross's crotch is a little lower than most characters
			_vibe.vibeRemote.x -= 22;
			_vibe.vibeRemote.y += 48;

			_vibe.vibeInteract.x -= 22;
			_vibe.vibeInteract.y += 48;

			addVisualItem(_vibe.vibeRemote);
			addVisualItem(_vibe.vibeInteract);
		}

		if (_interactive)
		{
			_vibe.loadDickGraphic(HeraResource.dickVibe);
			if (PlayerData.heraMale)
			{
				_vibe.dickFrameToVibeFrameMap = [
													0 => [0, 1, 2, 3, 4],
													2 => [5, 6, 7, 8, 9],
													3 => [10, 11, 12, 13, 14],
												];
			}
			else
			{
				_vibe.dickFrameToVibeFrameMap = [
													0 => [0, 1, 2, 3, 4, 5],
												];
			}
		}

		setNudity(PlayerData.level);
		refreshGender();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (_armsUpTimer > 0)
		{
			_armsUpTimer -= elapsed;
		}

		if (_interactive && !SexyDebugState.debug)
		{
			_vibe.update(elapsed);
		}
	}

	override public function setNudity(NudityLevel:Int)
	{
		super.setNudity(NudityLevel);
		if (NudityLevel == 0)
		{
			_legs.animation.play("pants");
			_balls.visible = false;
			_dick.visible = false;
			_panties.visible = false;
		}
		if (NudityLevel == 1)
		{
			_balls.visible = false;
			if (PlayerData.heraMale)
			{
				_legs.animation.play("boxers");
				_dick.animation.play("boxers");
			}
			else
			{
				_legs.animation.play("default");
			}
			_dick.visible = true;
			_panties.visible = true;
		}
		if (NudityLevel >= 2)
		{
			_legs.animation.play("default");
			_balls.visible = true;
			_dick.animation.play("default");
			_dick.visible = true;
			_panties.visible = false;
		}
		if (PlayerData.heraMale)
		{
			if (NudityLevel < 2)
			{
				// move the dick/balls behind the boxer shorts/pants
				reposition(_balls, members.indexOf(_legs));
				reposition(_dick, members.indexOf(_balls) + 1);
			}
			else
			{
				// move the dick/balls in front of the arms
				reposition(_balls, members.indexOf(_arms0) + 1);
				reposition(_dick, members.indexOf(_balls) + 1);
			}
		}
	}

	override public function cheerful():Void
	{
		super.cheerful();
		_arms0.animation.play("cheer");
		_arms1.animation.play("cheer");
		_head.animation.play("cheer");
	}

	/**
	 * Trigger some sort of animation or behavior based on a dialog sequence
	 * 
	 * @param	str the special dialog which might trigger an animation or behavior
	 */
	override public function doFun(str:String)
	{
		super.doFun(str);
		if (str == "fixboxers")
		{
			_legs.animation.play("fix-boxers");
		}
	}

	override public function arrangeArmsAndLegs()
	{
		if (_armsUpTimer > 0)
		{
			playNewAnim(_arms0, ["face-0", "face-1"]);
		}
		else
		{
			playNewAnim(_arms0, ["0", "1", "2", "3"]);
		}
		_arms1.animation.play(_arms0.animation.name);
		playNewAnim(_legs, ["0", "1", "2", "3", "4", "5", "6", "7"]);
	}

	override public function setArousal(Arousal:Int)
	{
		super.setArousal(Arousal);
		if (_arousal == 0)
		{
			playNewAnim(_head, ["0-0", "0-1", "0-2"]);
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
			playNewAnim(_head, ["4-0", "4-1", "4-2"]);
		}
		else if (_arousal == 5)
		{
			playNewAnim(_head, ["5-0", "5-1", "5-2"]);
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

	public function updateBlush():Void
	{
		if (_blush.animation.getByName(_head.animation.name) != null)
		{
			_blush.animation.play(_head.animation.name);
		}
		else {
			_blush.animation.play("default");
		}
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		CursorUtils.initializeHandBouncySprite(_interact, AssetPaths.hera_interact__png);
		if (PlayerData.heraMale)
		{
			_interact.animation.add("rub-dick", [0, 1, 2, 3, 4]);
			_interact.animation.add("jack-off", [11, 10, 9, 8, 7, 6, 5]);
			_interact.animation.add("rub-balls", [12, 13, 14, 15]);
		}
		else
		{
			_interact.animation.add("rub-dick", [32, 33, 34, 35]);
			_interact.animation.add("jack-off", [40, 41, 42, 43, 44]);
		}
		_interact.animation.add("rub-left-antenna", [16, 17, 18, 19]);
		_interact.animation.add("rub-right-antenna", [20, 21, 22, 23]);
		_interact.animation.add("rub-horn", [24, 25, 26, 27, 28, 29, 30]);
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

		_torso0 = FlxDestroyUtil.destroy(_torso0);
		_torso1 = FlxDestroyUtil.destroy(_torso1);
		_arms0 = FlxDestroyUtil.destroy(_arms0);
		_arms1 = FlxDestroyUtil.destroy(_arms1);
		_balls = FlxDestroyUtil.destroy(_balls);
		_panties = FlxDestroyUtil.destroy(_panties);
		_legs = FlxDestroyUtil.destroy(_legs);
		_blush = FlxDestroyUtil.destroy(_blush);
		_vibe = FlxDestroyUtil.destroy(_vibe);
	}
}