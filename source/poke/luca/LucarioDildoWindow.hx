package poke.luca;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;
import poke.PokeWindow;

/**
 * Graphics for Lucario during the dildo sequence
 */
class LucarioDildoWindow extends PokeWindow
{
	/**
	 * As female Lucario's pussy is penetrated with the dildo, her pubic fuzz
	 * shifts slightly. This is a mapping from pussy frames to shifted pubic
	 * fuzz frames
	 */
	private var dickToFuzzFrames:Map<Int, Int> = [
				0 => 0,
				1 => 1,
				2 => 2,
				3 => 2,
				4 => 3,
				5 => 3,
				6 => 3,
				7 => 4,
				8 => 4,
				9 => 4,
				10 => 1,
				11 => 1,
				12 => 1,
				13 => 1,
				14 => 1,
				15 => 1,
				16 => 1,
				17 => 1,
				18 => 2,
				19 => 2,
				20 => 3,
				21 => 3,
				22 => 0,
				23 => 0,
				24 => 0,
				25 => 0,
				26 => 4,
				27 => 4,
				28 => 4,
				29 => 4,
			];

	/**
	 * As female Lucario's pussy is penetrated with the dildo, her pussy
	 * deforms slightly. This is a mapping from ass frames to deformed pussy
	 * frames
	 */
	private var assToDickFrames:Map<Int, Int> = [
				1 => 0,
				2 => 0,
				3 => 0,
				4 => 0,
				5 => 0,
				6 => 0,
				7 => 22,
				8 => 22,
				9 => 22,
				10 => 22,
				11 => 23,
				12 => 23,
				13 => 24,
				14 => 24,
				15 => 24,
				16 => 24,
				17 => 24,
				18 => 24,
			];

	/**
	 * As male Lucario's ass is penetrated with the dildo, his balls adjust
	 * slightly. This is a mapping from ass frames to adjusted balls frames
	 */
	private var assToBallsFrames:Map<Int, Int> = [
				1 => 0,
				2 => 0,
				3 => 0,
				4 => 0,
				5 => 0,
				6 => 1,
				7 => 1,
				8 => 1,
				9 => 2,
				10 => 1,
				11 => 2,
				12 => 2,
				13 => 3,
				14 => 3,
				15 => 4,
				16 => 4,
				17 => 4,
				18 => 4,
			];

	private var xlDildo:Bool = false;

	public var arms0:BouncySprite;
	public var arms1:BouncySprite;
	public var tail:BouncySprite;
	public var torso0:BouncySprite;
	public var torso1:BouncySprite;
	public var hair:BouncySprite;
	public var thighs:BouncySprite;
	public var calves:BouncySprite;
	public var feet:BouncySprite;
	public var hands:BouncySprite;
	public var ass:BouncySprite;
	public var dildo:BouncySprite;
	public var pubicFuzz:BouncySprite;
	public var balls:BouncySprite;

	public function new(X:Float = 0, Y:Float = 0, Width:Int = 248, Height:Int = 349)
	{
		super(X, Y, Width, Height);

		add(new FlxSprite( -54, -54, AssetPaths.luca_bg__png));

		arms0 = new BouncySprite( -54, -54, 2, 7.4, 0.03, _age);
		arms0.loadWindowGraphic(AssetPaths.lucadildo_arms0__png);
		arms0.animation.add("default", [0]);
		arms0.animation.add("arm-grab", [1]);
		arms0.animation.play("arm-grab");
		addPart(arms0);

		tail = new BouncySprite( -54, -54, 7, 7.4, 0.15, _age);
		tail.loadWindowGraphic(AssetPaths.lucadildo_tail__png);
		addPart(tail);

		torso0 = new BouncySprite( -54, -54, 5, 7.4, 0.12, _age);
		torso0.loadWindowGraphic(AssetPaths.lucadildo_torso0__png);
		addPart(torso0);

		torso1 = new BouncySprite( -54, -54, 3, 7.4, 0.06, _age);
		torso1.loadWindowGraphic(AssetPaths.lucadildo_torso1__png);
		addPart(torso1);

		arms1 = new BouncySprite( -54, -54, 2, 7.4, 0.03, _age);
		arms1.loadWindowGraphic(AssetPaths.lucadildo_arms1__png);
		arms1.animation.add("default", [0]);
		arms1.animation.add("arm-grab", [1]);
		arms1.animation.play("arm-grab");
		addPart(arms1);

		hair = new BouncySprite( -54, -54, 1, 7.4, 0.03, _age);
		hair.loadWindowGraphic(AssetPaths.lucadildo_hair__png);
		addPart(hair);

		_head = new BouncySprite( -54, -54 + 266, 1, 7.4, 0, _age);
		_head.loadGraphic(LucarioResource.dildoHead, true, 356, 266);
		_head.animation.add("default", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("0", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("1", blinkyAnimation([3, 4], [5]), 3);
		_head.animation.add("2", blinkyAnimation([6, 7, 8]), 3);
		_head.animation.add("3", blinkyAnimation([9, 10], [11]), 3);
		_head.animation.add("4", blinkyAnimation([12, 13], [14]), 3);
		_head.animation.add("5", blinkyAnimation([15, 16, 17]), 3);
		_head.animation.play("default");
		addPart(_head);

		thighs = new BouncySprite( -54, -54, 5, 7.4, 0.12, _age);
		thighs.loadWindowGraphic(AssetPaths.lucadildo_thighs__png);
		addPart(thighs);

		calves = new BouncySprite( -54, -54, 3, 7.4, 0.06, _age);
		calves.loadWindowGraphic(AssetPaths.lucadildo_calves__png);
		addPart(calves);

		feet = new BouncySprite( -54, -54, 0, 7.4, 0, _age);
		feet.loadWindowGraphic(AssetPaths.lucadildo_feet__png);
		addPart(feet);

		hands = new BouncySprite( -54, -54, 5, 7.4, 0.12, _age);
		hands.loadWindowGraphic(AssetPaths.lucadildo_hands__png);
		hands.animation.add("default", [0]);
		hands.animation.add("arm-grab", [1]);
		hands.animation.play("arm-grab");
		addPart(hands);

		_dick = new BouncySprite( -54, -54, 4, 7.4, 0.10, _age);
		_dick.loadWindowGraphic(LucarioResource.dildoDick);
		_dick.animation.add("default", [0]);

		balls = new BouncySprite( -54, -54, 5, 7.4, 0.11, _age);
		balls.loadWindowGraphic(AssetPaths.lucadildo_balls__png);

		pubicFuzz = new BouncySprite( -54, -54, 3, 7.4, 0.09, _age);
		pubicFuzz.loadWindowGraphic(AssetPaths.lucadildo_pubicfuzz__png);

		if (PlayerData.lucaMale)
		{
			_dick.animation.add("boner0", [1]);
			_dick.animation.add("boner1", [2]);
			_dick.animation.add("boner2", [3]);
			_dick.animation.add("boner3", [4]);
			addPart(_dick);
			addPart(balls);
		}
		else
		{
			_dick.animation.add("dildo-vag0", [0, 1, 2, 3, 4, 5]);
			_dick.animation.add("dildo-vag1", [3, 4, 5, 6, 7, 8, 9]);
			_dick.animation.add("rub-vag", [10, 11, 12, 13, 14, 15, 16]);
			_dick.animation.add("finger-vag", [17, 18, 19, 20, 21]);
			_dick.animation.add("arm-grab", [25]);
			_dick.animation.play("arm-grab");
			addPart(_dick);
			addPart(pubicFuzz);
		}

		ass = new BouncySprite( -54, -54, 5, 7.4, 0.11, _age);
		ass.loadWindowGraphic(AssetPaths.lucadildo_ass__png);
		ass.animation.add("default", [0]);
		ass.animation.add("rub-ass", [1, 2, 3, 4]);
		ass.animation.add("finger-ass", [0, 5, 6, 7, 8, 9]);
		ass.animation.add("dildo-ass0", [0, 10, 11, 12, 13, 14]);
		ass.animation.add("dildo-ass1", [12, 13, 14, 15, 16, 17, 18]);
		ass.animation.add("arm-grab", [19]);
		ass.animation.play("arm-grab");
		addPart(ass);

		dildo = new BouncySprite( -54, -54, 4, 7, 0.14, _age);
		dildo.loadWindowGraphic(AssetPaths.lucadildo_dildo__png);
		dildo.animation.add("default", [0]);
		dildo.animation.add("dildo-vag0", [1, 2, 3, 4, 5, 6]);
		dildo.animation.add("dildo-vag1", [4, 5, 6, 7, 8, 9, 10]);
		dildo.animation.add("dildo-ass0", [13, 14, 15, 16, 17, 18]);
		dildo.animation.add("dildo-ass1", [16, 17, 18, 19, 20, 21, 22]);
		dildo.animation.play("default");
		addPart(dildo);

		_interact = new BouncySprite( -54, -54, 4, 7, 0.14, _age);
		reinitializeHandSprites();
		_interact.animation.play("default");
		addVisualItem(_interact);
	}

	override public function setArousal(Arousal:Int)
	{
		super.setArousal(Arousal);
		if (_arousal == 0)
		{
			playNewAnim(_head, ["0"]);
		}
		else if (_arousal == 1)
		{
			playNewAnim(_head, ["1"]);
		}
		else if (_arousal == 2)
		{
			playNewAnim(_head, ["2"]);
		}
		else if (_arousal == 3)
		{
			playNewAnim(_head, ["3"]);
		}
		else if (_arousal == 4)
		{
			playNewAnim(_head, ["4"]);
		}
		else if (_arousal == 5)
		{
			playNewAnim(_head, ["5"]);
		}
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();

		CursorUtils.initializeHandBouncySprite(_interact, AssetPaths.lucadildo_interact__png);
		_interact.alpha = PlayerData.cursorMaxAlpha;
		_interact.animation.add("default", [0]);
		_interact.animation.add("rub-vag", [14, 15, 16, 17, 18, 19, 20]);
		_interact.animation.add("finger-vag", [21, 22, 23, 24, 25]);
		_interact.animation.add("dildo-vag0", [1, 2, 3, 4, 5, 6]);
		_interact.animation.add("dildo-vag1", [7, 8, 9, 10, 11, 12, 13]);
		_interact.animation.add("rub-ass", [26, 27, 28, 29]);
		_interact.animation.add("finger-ass", [30, 31, 32, 33, 34, 35]);
		_interact.animation.add("dildo-ass0", [36, 37, 38, 39, 40, 41]);
		_interact.animation.add("dildo-ass1", [42, 43, 44, 45, 46, 47, 48]);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (PlayerData.lucaMale)
		{
			if (assToBallsFrames[ass.animation.frameIndex] != null)
			{
				balls.animation.frameIndex = assToDickFrames[ass.animation.frameIndex];
			}
		}
		else {
			if (assToDickFrames[ass.animation.frameIndex] != null)
			{
				_dick.animation.frameIndex = assToDickFrames[ass.animation.frameIndex];
			}
			if (dickToFuzzFrames[_dick.animation.frameIndex] != null)
			{
				pubicFuzz.animation.frameIndex = dickToFuzzFrames[_dick.animation.frameIndex];
			}
		}
	}

	public function setGummyDildo()
	{
		dildo.loadWindowGraphic(AssetPaths.lucadildo_dildo_gummy__png);
		dildo.animation.add("default", [0]);
		dildo.animation.add("dildo-vag0", [1, 2, 3, 4, 5, 6]);
		dildo.animation.add("dildo-vag1", [4, 5, 6, 7, 8, 9, 10]);
		dildo.animation.add("dildo-ass0", [13, 14, 15, 16, 17, 18]);
		dildo.animation.add("dildo-ass1", [16, 17, 18, 19, 20, 21, 22]);
		dildo.animation.play("default");
	}

	public function setXlDildo()
	{
		this.xlDildo = true;

		dildo.loadWindowGraphic(AssetPaths.lucadildo_dildo_xl__png);
		dildo.animation.add("default", [0]);
		dildo.animation.add("dildo-vag0", [1, 2, 3, 4, 4]);
		dildo.animation.add("dildo-vag1", [1, 2, 3, 4, 4, 4]);
		dildo.animation.add("dildo-ass0", [5, 6, 7, 8, 8]);
		dildo.animation.add("dildo-ass1", [5, 6, 7, 8, 8, 8]);
		dildo.animation.play("default");

		_interact.animation.add("dildo-vag0", [49, 50, 51, 52, 52]);
		_interact.animation.add("dildo-vag1", [49, 50, 51, 52, 52, 52]);

		_dick.animation.add("dildo-vag0", [0, 1, 2, 3, 3]);
		_dick.animation.add("dildo-vag1", [0, 1, 2, 3, 3, 3]);

		_interact.animation.add("dildo-ass0", [53, 54, 55, 56, 56]);
		_interact.animation.add("dildo-ass1", [53, 54, 55, 56, 56, 56]);

		ass.animation.add("dildo-ass0", [0, 10, 11, 12, 12]);
		ass.animation.add("dildo-ass1", [0, 10, 11, 12, 12, 12]);
	}

	public function isXlDildo()
	{
		return xlDildo;
	}

	override public function destroy():Void
	{
		super.destroy();

		arms0 = FlxDestroyUtil.destroy(arms0);
		arms1 = FlxDestroyUtil.destroy(arms1);
		tail = FlxDestroyUtil.destroy(tail);
		torso0 = FlxDestroyUtil.destroy(torso0);
		torso1 = FlxDestroyUtil.destroy(torso1);
		hair = FlxDestroyUtil.destroy(hair);
		thighs = FlxDestroyUtil.destroy(thighs);
		calves = FlxDestroyUtil.destroy(calves);
		feet = FlxDestroyUtil.destroy(feet);
		hands = FlxDestroyUtil.destroy(hands);
		ass = FlxDestroyUtil.destroy(ass);
		dildo = FlxDestroyUtil.destroy(dildo);
		pubicFuzz = FlxDestroyUtil.destroy(pubicFuzz);
		balls = FlxDestroyUtil.destroy(balls);
	}
}