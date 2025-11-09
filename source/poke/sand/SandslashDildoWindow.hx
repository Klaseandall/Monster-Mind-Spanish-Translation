package poke.sand;

import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;
import poke.rhyd.BreathingSprite;

/**
 * Graphics for Sandslash during the dildo sequence
 */
class SandslashDildoWindow extends PokeWindow
{
	/**
	 * As female Sandslash's pussy is penetrated with the dildo, the ass
	 * deforms slightly. This is a mapping from pussy frames to deformed ass
	 * frames
	 */
	private var dickToAssFrames:Map<Int, Int> = [
				12 => 0,
				13 => 0,
				14 => 1,
				15 => 2,
				16 => 2,
				17 => 3,
				18 => 3,
				19 => 3,
				20 => 4,
				21 => 4,
				22 => 4,
				23 => 2,
			];

	/**
	 * As female Sandslash's ass is penetrated with the dildo, her pussy
	 * deforms slightly. This is a mapping from ass frames to deformed pussy
	 * frames
	 */
	private var assToDickFrames:Map<Int, Int> = [
				14 => 0,
				15 => 0,
				16 => 24,
				17 => 24,
				18 => 25,
				19 => 25,
				20 => 26,
				21 => 26,
				22 => 27,
				23 => 27,
				24 => 27,
			];

	/**
	 * As male Sandslash's ass is penetrated with the dildo, his balls adjust
	 * slightly. This is a mapping from ass frames to adjusted balls frames
	 */
	private var assToBallsFrames:Map<Int, Int> = [
				14 => 0,
				15 => 0,
				16 => 1,
				17 => 1,
				18 => 2,
				19 => 2,
				20 => 3,
				21 => 3,
				22 => 3,
				23 => 4,
				24 => 4,
			];

	private var quillsHead:BouncySprite;
	private var quillsTorso:BouncySprite;
	private var legR1:BouncySprite;
	private var armR:BouncySprite;
	public var torso:BouncySprite;
	public var ass:BouncySprite;
	public var balls:BouncySprite;
	private var legR0:BouncySprite;
	private var footR:BouncySprite;
	private var armL:BouncySprite;
	public var legL:BouncySprite;
	public var handL:BouncySprite;
	public var footL:BouncySprite;
	public var dildo:BouncySprite;
	private var phoneEnabled:Bool = false;

	public function new(X:Float = 0, Y:Float = 0, Width:Int = 248, Height:Int = 349)
	{
		super(X, Y, Width, Height);

		add(new FlxSprite( -54, -54, SandslashResource.bg));

		quillsHead = new BouncySprite( -54, -54 - 10, 10, 5, 0.24, _age);
		quillsHead.loadWindowGraphic(AssetPaths.sanddildo_head0__png);
		addPart(quillsHead);

		quillsTorso = new BouncySprite( -54, -54 - 5, 5, 5, 0.20, _age);
		quillsTorso.loadWindowGraphic(AssetPaths.sanddildo_quills__png);
		addPart(quillsTorso);

		armR = new BouncySprite( -54, -54 - 2, 2, 5, 0.04, _age);
		armR.loadWindowGraphic(AssetPaths.sanddildo_armr__png);
		addPart(armR);

		legR1 = new BouncySprite( -54, -54 - 0, 0, 5, 0.00, _age);
		legR1.loadWindowGraphic(AssetPaths.sanddildo_legr1__png);
		addPart(legR1);

		torso = new BreathingSprite( -54, -54 - 4, 4, 5, 0.14, _age);
		torso.loadWindowGraphic(AssetPaths.sanddildo_torso__png);
		torso.animation.add("default", [0, 1, 2, 3]);
		torso.animation.play("default");
		addPart(torso);

		legR0 = new BouncySprite( -54, -54 - 0, 0, 5, 0.00, _age);
		legR0.loadWindowGraphic(AssetPaths.sanddildo_legr0__png);
		addPart(legR0);

		footR = new BouncySprite( -54, -54 - 0, 0, 5, 0.00, _age);
		footR.loadWindowGraphic(AssetPaths.sanddildo_footr__png);
		addPart(footR);

		_head = new BouncySprite( -54, -54 - 5, 5, 5, 0.20, _age);
		_head.loadGraphic(SandslashResource.dildoHead1, true, 356, 266);
		_head.animation.add("default", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("0", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("1", blinkyAnimation([3, 4], [5]), 3);
		_head.animation.add("2", blinkyAnimation([6, 7], [8]), 3);
		_head.animation.add("3", blinkyAnimation([9, 10], [11]), 3);
		_head.animation.add("4", blinkyAnimation([12, 13, 14]), 3);
		_head.animation.add("5", blinkyAnimation([15, 16, 17]), 3);
		_head.animation.play("default");
		addPart(_head);

		armL = new BouncySprite( -54, -54 - 4, 4, 5, 0.16, _age);
		armL.loadWindowGraphic(AssetPaths.sanddildo_arml__png);
		addPart(armL);

		legL = new BouncySprite( -54, -54 - 0, 0, 5, 0.00, _age);
		legL.loadWindowGraphic(AssetPaths.sanddildo_legl__png);
		legL.animation.add("default", [1]);
		legL.animation.add("lo", [0]);
		legL.animation.add("hi", [2]);
		legL.animation.play("default");
		addPart(legL);

		handL = new BouncySprite( -54, -54 - 2, 2, 5, 0.08, _age);
		handL.loadWindowGraphic(AssetPaths.sanddildo_handl__png);
		handL.animation.add("default", [1]);
		handL.animation.add("lo", [0]);
		handL.animation.add("hi", [2]);
		handL.animation.play("default");
		addPart(handL);

		footL = new BouncySprite( -54, -54 - 4, 4, 5, 0.12, _age);
		footL.loadWindowGraphic(AssetPaths.sanddildo_footl__png);
		footL.animation.add("default", [1]);
		footL.animation.add("lo", [0]);
		footL.animation.add("hi", [2]);
		footL.animation.play("default");
		addPart(footL);

		ass = new BouncySprite( -54, -54 - 0, 0, 5, 0.00, _age);
		ass.loadWindowGraphic(AssetPaths.sanddildo_ass__png);
		ass.animation.add("default", [0]);
		ass.animation.add("rub-ass", [6, 7, 8, 9]);
		ass.animation.add("finger-ass", [0, 10, 11, 12, 13]);
		ass.animation.add("dildo-ass", [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]);
		ass.animation.play("default");
		addPart(ass);

		balls = new BouncySprite( -54, -54, 2, 5, 0.05, _age);
		balls.loadWindowGraphic(AssetPaths.sanddildo_balls__png);
		balls.animation.add("default", [0]);
		balls.animation.play("default");

		_dick = new BouncySprite( -54, -54 - 0, 0, 5, 0.00, _age);
		_dick.loadWindowGraphic(SandslashResource.dildoDick);
		_dick.animation.add("default", [0]);

		if (PlayerData.sandMale)
		{
			addPart(balls);

			_dick.animation.add("boner1", [1, 1, 2, 2, 2, 3, 3, 3, 3, 2, 2, 2, 1, 1], 3);
			_dick.animation.add("boner2", [4, 4, 5, 5, 5, 6, 6, 6, 6, 5, 5, 5, 4, 4], 3);
			_dick.animation.play("default");
			addPart(_dick);
		}
		else
		{
			_dick.animation.add("rub-vag", [5, 4, 3, 2, 1]);
			_dick.animation.add("finger-vag", [6, 7, 8, 9, 10]);
			_dick.animation.add("dildo-vag", [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]);
			_dick.animation.play("default");
			addPart(_dick);
		}

		dildo = new BouncySprite( -54, -54, 4, 7, 0.14, _age);
		dildo.loadWindowGraphic(AssetPaths.sanddildo_dildo__png);
		dildo.animation.add("default", [0]);
		dildo.animation.add("dildo-vag", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
		dildo.animation.add("dildo-ass", [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]);
		dildo.animation.play("default");
		addPart(dildo);

		_interact = new BouncySprite( -54, -54, 4, 7, 0.14, _age);
		reinitializeHandSprites();
		_interact.animation.play("default");
		addVisualItem(_interact);
	}

	public function isPhoneEnabled():Bool
	{
		return phoneEnabled;
	}

	public function setPhoneEnabled()
	{
		this.phoneEnabled = true;

		assToBallsFrames = [
							   14 => 0,
							   15 => 0,
							   16 => 0,
							   17 => 1,
							   18 => 1,
							   19 => 2,
							   20 => 2,
							   21 => 3,
							   22 => 3,
							   23 => 3,
							   24 => 4,
						   ];

		reinitializeHandSprites();

		dildo.loadWindowGraphic(AssetPaths.sandphone_phone__png);
		dildo.animation.add("default", [0]);
		dildo.animation.add("dildo-vag", [13, 14, 15, 16, 17, 18, 19, 20, 21, 22]);
		dildo.animation.add("dildo-ass", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
		dildo.animation.play("default");

		ass.animation.add("dildo-ass", [14, 15, 16, 16, 17, 17, 18, 18, 17, 16]);
		ass.animation.play("default");

		if (PlayerData.sandMale)
		{
			// dildo needs to go behind the balls for male sandslash
			reposition(dildo, members.indexOf(balls));
		}
		else
		{
			_dick.animation.add("dildo-vag", [12, 13, 14, 15, 23, 15, 23, 15, 23, 14]);
		}
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

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (PlayerData.sandMale)
		{
			if (assToBallsFrames[ass.animation.frameIndex] != null)
			{
				balls.animation.frameIndex = assToBallsFrames[ass.animation.frameIndex];
			}
		}
		else {
			if (dickToAssFrames[_dick.animation.frameIndex] != null)
			{
				ass.animation.frameIndex = dickToAssFrames[_dick.animation.frameIndex];
			}
			if (assToDickFrames[ass.animation.frameIndex] != null)
			{
				_dick.animation.frameIndex = assToDickFrames[ass.animation.frameIndex];
			}
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		dickToAssFrames = null;
		assToDickFrames = null;
		assToBallsFrames = null;

		quillsHead = FlxDestroyUtil.destroy(quillsHead);
		quillsTorso = FlxDestroyUtil.destroy(quillsTorso);
		legR1 = FlxDestroyUtil.destroy(legR1);
		armR = FlxDestroyUtil.destroy(armR);
		torso = FlxDestroyUtil.destroy(torso);
		balls = FlxDestroyUtil.destroy(balls);
		ass = FlxDestroyUtil.destroy(ass);
		legR0 = FlxDestroyUtil.destroy(legR0);
		footR = FlxDestroyUtil.destroy(footR);
		armL = FlxDestroyUtil.destroy(armL);
		legL = FlxDestroyUtil.destroy(legL);
		handL = FlxDestroyUtil.destroy(handL);
		footL = FlxDestroyUtil.destroy(footL);
		dildo = FlxDestroyUtil.destroy(dildo);
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		CursorUtils.initializeHandBouncySprite(_interact, phoneEnabled ? AssetPaths.sandphone_interact__png : AssetPaths.sanddildo_interact__png);
		_interact.alpha = PlayerData.cursorMaxAlpha;
		_interact.animation.add("default", [0]);
		_interact.animation.add("rub-vag", [5, 4, 3, 2, 1]);
		_interact.animation.add("finger-vag", [6, 7, 8, 9, 10]);
		_interact.animation.add("rub-ass", [24, 25, 26, 27]);
		_interact.animation.add("finger-ass", [28, 29, 30, 22, 23]);
		if (phoneEnabled)
		{
			_interact.animation.add("dildo-vag", [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]);
			_interact.animation.add("dildo-ass", [32, 33, 34, 35, 36, 37, 38, 39, 40, 41]);
		}
		else
		{
			_interact.animation.add("dildo-vag", [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]);
			_interact.animation.add("dildo-ass", [32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42]);
		}
	}
}