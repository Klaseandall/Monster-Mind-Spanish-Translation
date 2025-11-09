package poke.sand;

import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;
import poke.sand.SandslashDialog;

/**
 * Sprites and animations for Sandslash
 */
class SandslashWindow extends PokeWindow
{
	public var _legs:BouncySprite;
	public var _underwear:BouncySprite;
	public var _ass:BouncySprite;
	public var _balls:BouncySprite;
	public var _arms2:BouncySprite;
	public var _arms1:BouncySprite;
	public var _mouth:BouncySprite;
	public var _bowtie:BouncySprite;
	public var _torso1:BouncySprite;
	public var _torso0:BouncySprite;
	public var _arms0:BouncySprite;

	public var _quillsHead:BouncySprite;
	public var _quills2:BouncySprite;
	public var _quills1:BouncySprite;
	public var _quills0:BouncySprite;

	public var _openness:Openness = Openness.Neutral;

	public function new(X:Float=0, Y:Float=0, Width:Int=248, Height:Int = 349)
	{
		super(X, Y, Width, Height);
		_prefix = "sand";
		_name = "Sandslash";
		_victorySound = AssetPaths.sand__mp3;
		_dialogClass = SandslashDialog;
		add(new FlxSprite( -54, -54, SandslashResource.bg));

		_quills0 = new BouncySprite( -54, -54 - 4, 4, 5, 0.05, _age);
		_quills0.loadWindowGraphic(AssetPaths.sand_quills0__png);
		addPart(_quills0);

		_quills1 = new BouncySprite( -54, -54 - 6, 6, 5, 0.10, _age);
		_quills1.loadWindowGraphic(AssetPaths.sand_quills1__png);
		addPart(_quills1);

		_quills2 = new BouncySprite( -54, -54 - 8, 8, 5, 0.15, _age);
		_quills2.loadWindowGraphic(AssetPaths.sand_quills2__png);
		addPart(_quills2);

		_arms0 = new BouncySprite( -54, -54 - 4, 4, 5, 0.15, _age);
		_arms0.loadWindowGraphic(AssetPaths.sand_arms0__png);
		_arms0.animation.add("default", [0]);
		_arms0.animation.add("cheer", [1]);
		_arms0.animation.add("closed0", [3]);
		_arms0.animation.add("closed1", [4]);
		_arms0.animation.add("closed2", [5]);
		_arms0.animation.add("neutral0", [6]);
		_arms0.animation.add("neutral1", [7]);
		_arms0.animation.add("neutral2", [8]);
		_arms0.animation.add("open0", [9]);
		_arms0.animation.add("open1", [10]);
		_arms0.animation.add("open2", [11]);
		_arms0.animation.add("aroused", [12]);
		_arms0.animation.play("default");
		addPart(_arms0);

		_quillsHead = new BouncySprite( -54, -54 - 10, 10, 5, 0.20, _age);
		_quillsHead.loadWindowGraphic(AssetPaths.sand_head0__png);
		_quillsHead.animation.add("c", [0]);
		_quillsHead.animation.add("cm", [1]);
		_quillsHead.animation.add("cheer", [2]);
		_quillsHead.animation.add("cheerm", [3]);
		_quillsHead.animation.add("n", [4]);
		_quillsHead.animation.add("nm", [5]);
		_quillsHead.animation.add("nn", [4]);
		_quillsHead.animation.add("nnm", [5]);
		_quillsHead.animation.add("cocked", [2]);
		_quillsHead.animation.add("cockedm", [3]);
		_quillsHead.animation.add("s", [0]);
		_quillsHead.animation.add("sm", [1]);
		addPart(_quillsHead);

		_torso0 = new BouncySprite( -54, -54, 0, 5, 0, _age);
		_torso0.loadWindowGraphic(AssetPaths.sand_torso0__png);
		_torso0.animation.add("default", [0]);
		addPart(_torso0);

		_torso1 = new BouncySprite( -54, -54 - 4, 4, 5, 0.10, _age);
		_torso1.loadWindowGraphic(AssetPaths.sand_torso1__png);
		_torso1.animation.add("default", [0]);
		_torso1.animation.add("rub-left-pec", [0]);
		_torso1.animation.add("rub-right-pec", [0]);
		addPart(_torso1);

		_arms1 = new BouncySprite( -54, -54 - 4, 4, 5, 0.15, _age);
		_arms1.loadWindowGraphic(AssetPaths.sand_arms1__png);
		_arms1.animation.add("cheer", [1]);
		_arms1.animation.add("closed0", [3]);
		_arms1.animation.add("closed1", [4]);
		_arms1.animation.add("closed2", [5]);
		_arms1.animation.add("neutral0", [6]);
		_arms1.animation.add("neutral1", [7]);
		_arms1.animation.add("neutral2", [8]);
		_arms1.animation.add("open0", [9]);
		_arms1.animation.add("open1", [10]);
		_arms1.animation.add("open2", [11]);
		_arms1.animation.add("aroused", [12]);
		addPart(_arms1);

		_bowtie = new BouncySprite( -54, -54 - 5, 5, 5, 0.15, _age);
		_bowtie.loadWindowGraphic(SandslashResource.bowtie);
		_bowtie.animation.add("default", [0]);
		_bowtie.animation.add("gag-out", [1]);
		_bowtie.animation.add("gag", [2]);
		addPart(_bowtie);

		_head = new BouncySprite( -54, -54 - 6, 6, 5, 0.20, _age);
		_head.loadGraphic(SandslashResource.head1, true, 356, 266);
		_head.animation.add("default", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("gag-out", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("gag", blinkyAnimation([6, 7], [8]), 3);
		_head.animation.add("cheer", blinkyAnimation([3, 4], [5]), 3);
		_head.animation.add("0-c", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("0-cockedm", blinkyAnimation([12, 13], [14]), 3);
		_head.animation.add("0-s", blinkyAnimation([15, 16], [17]), 3);
		_head.animation.add("1-sm", blinkyAnimation([24, 25], [26]), 3);
		_head.animation.add("1-cockedm", blinkyAnimation([27, 28], [29]), 3);
		_head.animation.add("1-n", blinkyAnimation([30, 31], [32]), 3);
		_head.animation.add("2-n", blinkyAnimation([36, 37], [38]), 3);
		_head.animation.add("2-cm", blinkyAnimation([39, 40], [41]), 3);
		_head.animation.add("2-nnm", blinkyAnimation([42, 43], [44]), 3);
		_head.animation.add("2-suck-cm", blinkyAnimation([45, 46], [47]), 3);
		_head.animation.add("3-c", blinkyAnimation([48, 49], [50]), 3);
		_head.animation.add("3-cockedm", blinkyAnimation([51, 52], [53]), 3);
		_head.animation.add("3-nm", blinkyAnimation([54, 55], [56]), 3);
		_head.animation.add("4-nn", blinkyAnimation([60, 61]), 3);
		_head.animation.add("4-cm", blinkyAnimation([63, 64]), 3);
		_head.animation.add("4-nm", blinkyAnimation([66, 67]), 3);
		_head.animation.add("4-suck-cm", blinkyAnimation([69, 70]), 3);
		_head.animation.add("5-cocked", blinkyAnimation([72, 73]), 3);
		_head.animation.add("5-s", blinkyAnimation([75, 76]), 3);
		_head.animation.add("5-nnm", blinkyAnimation([78, 79]), 3);
		_head.animation.play("0-c");
		addPart(_head);

		_mouth = new BouncySprite( -54, -54 - 6, 6, 5, 0.20, _age);
		if (_interactive)
		{
			_mouth.loadWindowGraphic(AssetPaths.sand_mouth__png);
			_mouth.animation.add("default", [0]);
			_mouth.animation.add("suck-fingers", [3, 2, 1]);
			_mouth.visible = false;
			addPart(_mouth);
		}

		_ass = new BouncySprite( -54, -54, 0, 5, 0, _age);
		_ass.loadWindowGraphic(AssetPaths.sand_ass__png);
		_ass.animation.add("default", [0]);
		_ass.animation.add("finger-ass0", [0, 1, 2, 3, 4, 5]);
		_ass.animation.add("finger-ass1", [6, 7, 8, 9, 10]);
		_ass.animation.add("aroused", [8, 8, 9, 10, 11, 11, 10, 9, 8, 8, 8, 9, 10, 11, 11, 10, 9, 8, 8, 8, 9, 10, 11, 11, 10, 9, 8, 9, 10, 11, 11, 10, 9, 8, 9, 10, 11, 11, 10, 9, 8, 9, 10, 11, 11, 10, 9, 10, 11, 11, 10, 11, 11, 10, 11, 0], 6, false);
		_ass.visible = false;
		addPart(_ass);

		_underwear = new BouncySprite( -54, -54, 0, 5, 0, _age);
		_underwear.loadWindowGraphic(SandslashResource.undies);
		_underwear.animation.add("default", [0]);
		_underwear.animation.add("plug", [1]);
		addPart(_underwear);

		_legs = new BouncySprite( -54, -54 - 2, 2, 5, 0.05, _age);
		_legs.loadWindowGraphic(AssetPaths.sand_legs__png);
		_legs.animation.add("default", [0]);
		_legs.animation.add("closed0", [3]);
		_legs.animation.add("closed1", [4]);
		_legs.animation.add("closed2", [5]);
		_legs.animation.add("neutral0", [6]);
		_legs.animation.add("neutral1", [7]);
		_legs.animation.add("neutral2", [8]);
		_legs.animation.add("open0", [9]);
		_legs.animation.add("open1", [10]);
		_legs.animation.add("open2", [11]);
		addPart(_legs);

		_balls = new BouncySprite( -54, -54, 2, 5, 0.05, _age);
		_balls.loadWindowGraphic(AssetPaths.sand_balls__png);
		_balls.animation.add("default", [0]);
		_balls.animation.add("rub-balls", [1, 2, 3]);
		_balls.visible = false;

		_dick = new BouncySprite( -54, -54, 2, 5, 0.05, _age);
		_dick.loadWindowGraphic(SandslashResource.dick);
		_dick.visible = false;
		_dick.animation.add("default", [0]);

		if (PlayerData.sandMale)
		{
			addPart(_balls);

			_dick.animation.add("boner1", [1, 1, 2, 2, 2, 3, 3, 3, 3, 2, 2, 2, 1, 1], 3);
			_dick.animation.add("boner2", [4, 4, 5, 5, 5, 6, 6, 6, 6, 5, 5, 5, 4, 4], 3);
			_dick.animation.add("rub-dick", [8, 9, 10, 11]);
			_dick.animation.add("jack-off", [12, 13, 14, 15, 7]);
			addPart(_dick);
		}
		else
		{
			_dick._bouncePhase += 0.05;
			_dick.animation.add("rub-dick", [1, 2, 3, 4, 5]);
			_dick.animation.add("jack-off", [6, 7, 8, 9, 10, 11]);
			_dick.animation.add("finger-ass0", [0, 0, 12, 12, 13]);
			_dick.animation.add("finger-ass1", [0, 12, 12, 13, 13, 13]);
			_dick.animation.add("aroused", [12, 12, 13, 13, 13, 13, 13, 13, 12, 12, 12, 13, 13, 13, 13, 13, 13, 12, 12, 12, 13, 13, 13, 13, 13, 13, 12, 13, 13, 13, 13, 13, 13, 12, 13, 13, 13, 13, 13, 13, 12, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 0], 6, false);
			addPart(_dick);
			_ass.synchronize(_dick);
			_ass._bouncePhase += 0.05;
		}

		_arms2 = new BouncySprite( -54, -54 - 4, 4, 5, 0.15, _age);
		_arms2.loadWindowGraphic(AssetPaths.sand_arms2__png);
		_arms2.animation.add("default", [0]);
		_arms2.animation.add("cheer", [1]);
		_arms2.animation.add("closed0", [0]);
		_arms2.animation.add("closed1", [0]);
		_arms2.animation.add("closed2", [0]);
		_arms2.animation.add("neutral0", [0]);
		_arms2.animation.add("neutral1", [0]);
		_arms2.animation.add("neutral2", [0]);
		_arms2.animation.add("open0", [0]);
		_arms2.animation.add("open1", [0]);
		_arms2.animation.add("open2", [11]);
		_arms2.animation.add("aroused", [3, 3, 4, 5, 6, 6, 5, 4, 3, 3, 3, 4, 5, 6, 6, 5, 4, 3, 3, 3, 4, 5, 6, 6, 5, 4, 3, 4, 5, 6, 6, 5, 4, 3, 4, 5, 6, 6, 5, 4, 3, 4, 5, 6, 6, 5, 4, 5, 6, 6, 5, 6, 6, 5, 6, 6], 6, false);
		addPart(_arms2);

		_interact = new BouncySprite( -54, -54, _dick._bounceAmount, _dick._bounceDuration, _dick._bouncePhase, _age);
		if (_interactive)
		{
			reinitializeHandSprites();
			add(_interact);
		}

		setNudity(PlayerData.level);
	}

	override public function setNudity(NudityLevel:Int)
	{
		super.setNudity(NudityLevel);
		if (NudityLevel == 0)
		{
			_bowtie.visible = true;
			_underwear.visible = true;
			_balls.visible = false;
			_dick.visible = false;
			_ass.visible = false;
		}
		if (NudityLevel == 1)
		{
			_bowtie.visible = true;
			_underwear.visible = false;
			_balls.visible = true;
			_dick.visible = true;
			_ass.visible = true;
		}
		if (NudityLevel >= 2)
		{
			_bowtie.visible = false;
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
			playNewAnim(_head, ["0-c", "0-cockedm", "0-s"]);
		}
		else if (_arousal == 1)
		{
			playNewAnim(_head, ["1-sm", "1-cockedm", "1-n"]);
		}
		else if (_arousal == 2)
		{
			playNewAnim(_head, ["2-n", "2-cm", "2-nnm"]);
		}
		else if (_arousal == 3)
		{
			playNewAnim(_head, ["3-c", "3-cockedm", "3-nm"]);
		}
		else if (_arousal == 4)
		{
			playNewAnim(_head, ["4-nn", "4-cm", "4-nm"]);
		}
		else if (_arousal == 5)
		{
			playNewAnim(_head, ["5-cocked", "5-s", "5-nnm"]);
		}
		updateQuills();
	}

	public function updateQuills()
	{
		var quillAnimName:String = _head.animation.name.substring(_head.animation.name.lastIndexOf("-") + 1);
		_quillsHead.animation.play(quillAnimName);
	}

	override public function arrangeArmsAndLegs():Void
	{
		var s:String = "neutral";
		if (_openness == Openness.Closed)
		{
			s = "closed";
		}
		else if (_openness == Openness.Open)
		{
			s = "open";
		}
		if (_interact.animation.name == "rub-left-pec" && s == "closed")
		{
			_arms0.animation.play("closed0");
		}
		else if (_interact.animation.name == "rub-right-pec" && s == "closed")
		{
			_arms0.animation.play("closed1");
		}
		else {
			playNewAnim(_arms0, [s + "0", s + "1", s + "2"]);
		}
		_arms1.animation.play(_arms0.animation.name);
		_arms2.animation.play(_arms0.animation.name);
		playNewAnim(_legs, [s + "0", s + "1", s + "2"]);
	}

	override public function cheerful():Void
	{
		super.cheerful();
		if (_head.animation.name != "gag")
		{
			_quillsHead.animation.play("cheer");
			_head.animation.play("cheer");
		}
		_arms0.animation.play("cheer");
		_arms1.animation.play("cheer");
		_arms2.animation.play("cheer");
	}

	public function isGagged():Bool
	{
		return _head.animation.name == "gag";
	}

	/**
	 * Trigger some sort of animation or behavior based on a dialog sequence
	 *
	 * @param	str the special dialog which might trigger an animation or behavior
	 */
	override public function doFun(str:String)
	{
		super.doFun(str);
		if (str == "gag")
		{
			_head.animation.play("gag");
			_bowtie.animation.play("gag");
		}
		if (str == "plug")
		{
			_balls.visible = true;
			_dick.visible = true;
			_ass.visible = true;
			_underwear.animation.play("plug");
		}
		if (str == "gag-out")
		{
			_head.animation.play("gag-out");
			_bowtie.animation.play("gag-out");
		}
		if (str == "normal")
		{
			setNudity(nudity);
			_head.animation.play("0-c");
			_bowtie.animation.play("default");
			_underwear.animation.play("default");
		}
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		CursorUtils.initializeHandBouncySprite(_interact, AssetPaths.sand_interact__png);
		if (PlayerData.sandMale)
		{
			_interact.animation.add("rub-dick", [0, 1, 2, 3]);
			_interact.animation.add("jack-off", [8, 9, 10, 11, 12]);
			_interact.animation.add("rub-balls", [4, 5, 6]);
		}
		else
		{
			_interact.animation.add("rub-dick", [40, 41, 42, 43, 44]);
			_interact.animation.add("jack-off", [22, 23, 30, 31, 46, 47]);
		}
		_interact.animation.add("finger-ass0", [16, 17, 18, 19, 20, 21]);
		_interact.animation.add("finger-ass1", [24, 25, 26, 27, 28]);
		_interact.animation.add("aroused", [26, 26, 27, 28, 29, 29, 28, 27, 26, 26, 26, 27, 28, 29, 29, 28, 27, 26, 26, 26, 27, 28, 29, 29, 28, 27, 26, 27, 28, 29, 29, 28, 27, 26, 27, 28, 29, 29, 28, 27, 26, 27, 28, 29, 29, 28, 27, 28, 29, 29, 28, 29, 29, 28, 29, 7], 6, false);
		_interact.animation.add("suck-fingers", [15, 14, 13]);
		_interact.animation.add("rub-left-pec", [32, 33, 34, 35]);
		_interact.animation.add("rub-right-pec", [36, 37, 38, 39]);
		_interact.visible = false;
	}

	override public function destroy():Void
	{
		super.destroy();

		_legs = FlxDestroyUtil.destroy(_legs);
		_underwear = FlxDestroyUtil.destroy(_underwear);
		_ass = FlxDestroyUtil.destroy(_ass);
		_balls = FlxDestroyUtil.destroy(_balls);
		_arms2 = FlxDestroyUtil.destroy(_arms2);
		_arms1 = FlxDestroyUtil.destroy(_arms1);
		_mouth = FlxDestroyUtil.destroy(_mouth);
		_bowtie = FlxDestroyUtil.destroy(_bowtie);
		_torso1 = FlxDestroyUtil.destroy(_torso1);
		_torso0 = FlxDestroyUtil.destroy(_torso0);
		_arms0 = FlxDestroyUtil.destroy(_arms0);

		_quillsHead = FlxDestroyUtil.destroy(_quillsHead);
		_quills2 = FlxDestroyUtil.destroy(_quills2);
		_quills1 = FlxDestroyUtil.destroy(_quills1);
		_quills0 = FlxDestroyUtil.destroy(_quills0);
	}
}

/**
 * Sandslash repositions his arms and legs to be vaguely "open" or "closed"
 */
enum Openness
{
	Closed; // closed; legs shut, arms across chest
	Neutral;
	Open; // open; legs open, arms spread out
}