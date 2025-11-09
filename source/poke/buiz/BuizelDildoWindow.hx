package poke.buiz;

import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;
import poke.PokeWindow;

/**
 * Graphics for Buizel during the dildo sequence
 */
class BuizelDildoWindow extends PokeWindow
{
	public var _arms:BouncySprite;
	private var _tube:BouncySprite;
	public var _torso:BouncySprite;
	public var _ass:BouncySprite;
	public var _legs:BouncySprite;
	private var _tail0:BouncySprite;
	private var _tail1:BouncySprite;
	private var _feet:BouncySprite;
	private var _balls:BouncySprite;
	public var _dildo:BouncySprite;

	public function new(X:Float = 0, Y:Float = 0, Width:Int = 248, Height:Int = 349)
	{
		super(X, Y, Width, Height);
		add(new FlxSprite( -54, -54, AssetPaths.buizel_bg__png));

		_arms = new BouncySprite( -54, -54, 1, 7, 0.00, _age);
		_arms.loadWindowGraphic(AssetPaths.buizdildo_arms__png);
		_arms.animation.add("default", [0]);
		_arms.animation.add("arm-grab", [1]);
		_arms.animation.play("arm-grab");
		addPart(_arms);

		_tube = new BouncySprite( -54, -54, 2, 7, 0.07, _age);
		_tube.loadWindowGraphic(AssetPaths.buizdildo_tube__png);
		addPart(_tube);

		_torso = new BouncySprite( -54, -54, 4, 7, 0.14, _age);
		_torso.loadWindowGraphic(AssetPaths.buizdildo_torso__png);
		addPart(_torso);

		_legs = new BouncySprite( -54, -54, 5, 7, 0.22, _age);
		_legs.loadWindowGraphic(AssetPaths.buizdildo_legs__png);
		_legs.animation.add("default", [0]);
		_legs.animation.add("arm-grab", [1]);
		_legs.animation.play("arm-grab");
		addPart(_legs);

		_tail0 = new BouncySprite( -54, -54, 7, 7, 0.24, _age);
		_tail0.loadWindowGraphic(AssetPaths.buizdildo_tail0__png);
		_tail0.animation.add("default", [0]);
		_tail0.animation.add("tail-up-0", [0]);
		_tail0.animation.add("tail-up-1", [1]);
		_tail0.animation.add("tail-up-2", [2]);
		_tail0.animation.add("tail-down-0", [3]);
		_tail0.animation.add("tail-down-1", [4]);
		_tail0.animation.add("tail-down-2", [5]);
		_tail0.animation.play("default");
		addPart(_tail0);

		_tail1 = new BouncySprite( -54, -54, 7, 7, 0.26, _age);
		_tail1.loadWindowGraphic(AssetPaths.buizdildo_tail1__png);
		_tail1.animation.add("default", [0]);
		_tail1.animation.add("tail-up-0", [0]);
		_tail1.animation.add("tail-up-1", [1]);
		_tail1.animation.add("tail-up-2", [2]);
		_tail1.animation.add("tail-down-0", [3]);
		_tail1.animation.add("tail-down-1", [4]);
		_tail1.animation.add("tail-down-2", [5]);
		_tail1.animation.play("default");
		addPart(_tail1);

		_feet = new BouncySprite( -54, -54, 0, 7, 0, _age);
		_feet.loadWindowGraphic(AssetPaths.buizdildo_feet__png);
		addPart(_feet);

		_ass = new BouncySprite( -54, -54, 4, 7, 0.18, _age);
		_ass.loadWindowGraphic(AssetPaths.buizdildo_ass__png);
		_ass.animation.add("default", [0]);
		_ass.animation.add("rub-ass", [4, 3, 2, 1]);
		_ass.animation.add("finger-ass", [6, 7, 8, 9]);
		_ass.animation.add("dildo-ass0", [12, 13, 14, 15, 16, 17]);
		_ass.animation.add("dildo-ass1", [15, 16, 17, 18, 19, 20, 21]);
		_ass.animation.play("default");
		addPart(_ass);

		_dick = new BouncySprite( -54, -54, 4, 7, 0.14, _age);
		_dick.loadWindowGraphic(BuizelResource.dildoDick);
		if (PlayerData.buizMale)
		{
			_dick.animation.add("default", [0]);
			_dick.animation.add("boner1", [1]);
			_dick.animation.add("boner2", [2]);
			_dick.animation.play("default");
			addPart(_dick);
		}
		else
		{
			_dick.animation.add("default", [0]);
			_dick.animation.add("rub-vag", [18, 19, 20, 21]);
			_dick.animation.add("finger-vag", [1, 2, 3, 4]);
			_dick.animation.add("dildo-vag0", [6, 7, 8, 9, 10, 11]);
			_dick.animation.add("dildo-vag1", [9, 10, 11, 12, 13, 14, 15]);
			_dick.animation.play("default");
			addPart(_dick);
		}

		_balls = new BouncySprite( -54, -54, 4, 7, 0.16, _age);
		_balls.loadWindowGraphic(AssetPaths.buizdildo_balls__png);
		if (PlayerData.buizMale)
		{
			_balls.animation.add("default", [0, 0, 0, 1, 1, 2, 2, 2, 2, 2, 1, 1, 0, 0], 3);
			_balls.animation.play("default");
			addPart(_balls);
		}

		_dildo = new BouncySprite( -54, -54, 4, 7, 0.14, _age);
		_dildo.loadWindowGraphic(AssetPaths.buizdildo_dildo__png);
		_dildo.animation.add("default", [0]);
		_dildo.animation.add("dildo-vag0", [1, 2, 3, 4, 5, 6]);
		_dildo.animation.add("dildo-vag1", [4, 5, 6, 7, 8, 9, 10]);
		_dildo.animation.add("dildo-ass0", [12, 13, 14, 15, 16, 17]);
		_dildo.animation.add("dildo-ass1", [15, 16, 17, 18, 19, 20, 21]);
		_dildo.animation.play("default");
		addPart(_dildo);

		_interact = new BouncySprite( -54, -54, 4, 7, 0.14, _age);
		reinitializeHandSprites();
		_interact.animation.play("default");
		addVisualItem(_interact);
	}

	public function setGummyDildo():Void
	{
		_dildo.loadWindowGraphic(AssetPaths.buizdildo_dildo_gummy__png);
		_dildo.animation.add("default", [0]);
		_dildo.animation.add("dildo-vag0", [1, 2, 3, 4, 5, 6]);
		_dildo.animation.add("dildo-vag1", [4, 5, 6, 7, 8, 9, 10]);
		_dildo.animation.add("dildo-ass0", [12, 13, 14, 15, 16, 17]);
		_dildo.animation.add("dildo-ass1", [15, 16, 17, 18, 19, 20, 21]);
		_dildo.animation.play("default");
	}

	override public function destroy():Void
	{
		super.destroy();

		_arms = FlxDestroyUtil.destroy(_arms);
		_tube = FlxDestroyUtil.destroy(_tube);
		_torso = FlxDestroyUtil.destroy(_torso);
		_ass = FlxDestroyUtil.destroy(_ass);
		_legs = FlxDestroyUtil.destroy(_legs);
		_tail0 = FlxDestroyUtil.destroy(_tail0);
		_tail1 = FlxDestroyUtil.destroy(_tail1);
		_feet = FlxDestroyUtil.destroy(_feet);
		_balls = FlxDestroyUtil.destroy(_balls);
		_dildo = FlxDestroyUtil.destroy(_dildo);
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		CursorUtils.initializeHandBouncySprite(_interact, AssetPaths.buizdildo_interact__png);
		_interact.alpha = PlayerData.cursorMaxAlpha;
		_interact.animation.add("default", [0]);
		_interact.animation.add("rub-vag", [4, 3, 2, 1]);
		_interact.animation.add("finger-vag", [6, 7, 8, 9]);
		_interact.animation.add("dildo-vag0", [12, 13, 14, 15, 16, 17]);
		_interact.animation.add("dildo-vag1", [18, 19, 20, 21, 22, 23, 24]);
		_interact.animation.add("rub-ass", [29, 28, 27, 26]);
		_interact.animation.add("finger-ass", [30, 31, 32, 33]);
		_interact.animation.add("dildo-ass0", [35, 36, 37, 38, 39, 40]);
		_interact.animation.add("dildo-ass1", [41, 42, 43, 44, 45, 46, 47]);
	}

	public function updateTails(up:Bool)
	{
		if (up)
		{
			playNewAnim(_tail0, ["tail-up-0", "tail-up-1", "tail-up-2"]);
			playNewAnim(_tail1, ["tail-up-0", "tail-up-1", "tail-up-2"]);
		}
		else
		{
			playNewAnim(_tail0, ["tail-down-0", "tail-down-1", "tail-down-2"]);
			playNewAnim(_tail1, ["tail-down-0", "tail-down-1", "tail-down-2"]);
		}
	}
}