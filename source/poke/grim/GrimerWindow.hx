package poke.grim;
import demo.SexyDebugState;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxDestroyUtil;

/**
 * Sprites and animations for Grimer
 */
class GrimerWindow extends PokeWindow
{
	private static var CHARMELEON_CAMERA_Y:Int = -120;

	public var _torso:BouncySprite;
	public var _arms:BouncySprite;
	public var _charmeleon:BouncySprite;
	// grimer's _head variable is his face. _headBack is the non-face bits of his head
	public var _headBack:BouncySprite;
	private var _cheerTimer:Float = -1;
	private var _oldArmAnimationName:String = null;

	private var _cameraTween:FlxTween;

	public function new(X:Float=0, Y:Float=0, Width:Int=248, Height:Int = 349)
	{
		super(X, Y, Width, Height);
		_bgColor = 0xff859e6b; // green
		_prefix = "grim";
		_name = "Grimer";
		_victorySound = AssetPaths.grim__mp3;
		_dialogClass = GrimerDialog;
		add(new FlxSprite( -54, -54, AssetPaths.grimer_bg__png));

		_torso = new BouncySprite( -54, -54, 0, 8.5, 0, _age);
		_torso.loadWindowGraphic(AssetPaths.grimer_torso__png);
		_torso.animation.add("default", [0, 1, 2, 3, 4], 2);
		_torso.animation.play("default");
		addPart(_torso);

		_dick = new BouncySprite( -54, -54 + 266, 2, 8.5, 0, _age);
		_dick.loadGraphic(AssetPaths.grimer_dick__png, true, 356, 266);
		_dick.animation.add("default", [0]);
		_dick.animation.add("boner0", [1, 2, 3, 4, 5], 2);
		_dick.animation.add("boner1", [6, 7, 8, 9, 10], 2);
		_dick.animation.add("rub-dick", [1], 2); // placeholder; animation is never seen
		_dick.animation.add("jack-off", [6], 2); // placeholder; animation is never seen
		_dick.animation.play("default");
		addPart(_dick);

		_headBack = new BouncySprite( -54, -54 + 40, 4, 8.5, 0, _age);
		_headBack.loadGraphic(AssetPaths.grimer_head__png, true, 356, 266);
		_headBack.animation.add("default", [0, 1, 2, 3, 4], 2);
		_headBack.animation.add("c", [0, 1, 2, 3, 4], 2);
		_headBack.animation.add("cocked", [5, 6, 7, 8, 9], 2);
		_headBack.animation.add("w", [10, 11, 12, 13, 14], 2);
		_headBack.animation.add("s", [15, 16, 17, 18, 19], 2);
		_headBack.animation.add("ne", [20, 21, 22, 23, 24], 2);
		_headBack.animation.play("default");
		addPart(_headBack);

		_head = new BouncySprite( -54, -54 + 40, 4, 8.5, 0, _age);
		_head.loadGraphic(GrimerResource.face, true, 356, 266);
		_head.animation.add("default", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("cheer0", blinkyAnimation([3, 4]), 3);
		_head.animation.add("cheer1", blinkyAnimation([6, 7], [8]), 3);
		_head.animation.add("0-c", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("0-ne", blinkyAnimation([9, 10], [11]), 3);
		_head.animation.add("0-w", blinkyAnimation([21, 22], [23]), 3);
		_head.animation.add("1-cocked", blinkyAnimation([12, 13], [14]), 3);
		_head.animation.add("1-c", blinkyAnimation([15, 16], [17]), 3);
		_head.animation.add("1-ne", blinkyAnimation([18, 19], [20]), 3);
		_head.animation.add("2-w", blinkyAnimation([24, 25], [26]), 3);
		_head.animation.add("2-cocked", blinkyAnimation([27, 28], [29]), 3);
		_head.animation.add("2-s", blinkyAnimation([30, 31], [32]), 3);
		_head.animation.add("3-s", blinkyAnimation([36, 37], [38]), 3);
		_head.animation.add("3-ne", blinkyAnimation([39, 40], [41]), 3);
		_head.animation.add("3-c", blinkyAnimation([42, 43], [44]), 3);
		_head.animation.add("4-ne", blinkyAnimation([48, 49, 50]), 3);
		_head.animation.add("4-cocked", blinkyAnimation([51, 52, 53]), 3);
		_head.animation.add("4-w", blinkyAnimation([54, 55, 56]), 3);
		_head.animation.add("5-c", blinkyAnimation([60, 61, 62]), 3);
		_head.animation.add("5-s", blinkyAnimation([63, 64, 65]), 3);
		_head.animation.add("5-w", blinkyAnimation([66, 67, 68]), 3);
		_head.animation.play("default");
		if (SexyDebugState.debug)
		{
			addPart(_head); // we'll let the player interact with grimer's face for picking polygons in debug mode
		}
		else
		{
			addVisualItem(_head); // player can't usually interact with Grimer's face
		}

		_arms = new BouncySprite( -54, -54, 2, 8.5, 0, _age);
		_arms.loadWindowGraphic(AssetPaths.grimer_arms__png);
		_arms.animation.add("default", [0, 1, 2, 3, 4], 2);
		_arms.animation.add("cheer0", [5, 6, 7, 11, 12, 12, 13, 13, 14, 14,
									   10, 10, 11, 11, 12, 12, 13, 13, 14, 14,
									   10, 10, 11, 11, 12, 12, 13, 13, 14, 14,
									   10, 10, 11, 11, 12, 12, 13, 13, 14, 14,
									   10, 10, 11, 11, 12, 12, 13, 13, 14, 14], 4, false);
		_arms.animation.add("cheer1", [15, 16, 17, 18, 19], 2);
		_arms.animation.add("charmeleon", [20, 21, 22, 23, 24], 2);
		_arms.animation.add("charmelesexy", [25, 26, 27, 28, 29], 2);
		_arms.animation.add("0", [0, 1, 2, 3, 4], 2);
		_arms.animation.add("1", [30, 31, 32, 33, 34], 2);
		_arms.animation.add("2", [35, 36, 37, 38, 39], 2);
		_arms.animation.add("3", [40, 41, 42, 43, 44], 2);
		_arms.animation.add("4", [45, 46, 47, 48, 49], 2);
		_arms.animation.add("5", [50, 51, 52, 53, 54], 2);
		_arms.animation.add("6", [55, 56, 57, 58, 59], 2);
		_arms.animation.play("default");
		addVisualItem(_arms); // player can't interact with Grimer's arms

		_charmeleon = new BouncySprite( -54, -154, 2, 8.5, 0, _age);
		_charmeleon.loadGraphic(AssetPaths.charmeleon_cutout__png, true, 356, 266);
		_charmeleon.animation.add("default", [0]);
		_charmeleon.animation.add("charmeleon", [1]);
		_charmeleon.animation.add("charmelesexy", [2]);
		addVisualItem(_charmeleon);

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
			playNewAnim(_head, ["0-c", "0-ne", "0-w"]);
		}
		else if (_arousal == 1)
		{
			playNewAnim(_head, ["1-cocked", "1-c", "1-ne"]);
		}
		else if (_arousal == 2)
		{
			playNewAnim(_head, ["2-w", "2-cocked", "2-s"]);
		}
		else if (_arousal == 3)
		{
			playNewAnim(_head, ["3-s", "3-ne", "3-c"]);
		}
		else if (_arousal == 4)
		{
			playNewAnim(_head, ["4-ne", "4-cocked", "4-w"]);
		}
		else if (_arousal == 5)
		{
			playNewAnim(_head, ["5-c", "5-s", "5-w"]);
		}
		updateHeadBack();
	}

	/**
	 * Grimer's face and head are two different sprites. If she makes a certain
	 * expression, we need to update the other sprite too.
	 */
	public function updateHeadBack()
	{
		var headBackAnimName:String = _head.animation.name.substring(_head.animation.name.lastIndexOf("-") + 1);
		_headBack.animation.play(headBackAnimName);
		sync(_headBack);
	}

	override public function arrangeArmsAndLegs()
	{
		playNewAnim(_arms, ["0", "1", "2", "3", "4", "5", "6"]);
		sync(_arms);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (_cheerTimer > 0)
		{
			_cheerTimer -= elapsed;
			if (_cheerTimer <= 1.2 && _arms.animation.name != "cheer1")
			{
				_arms.animation.play("cheer1");
				_charmeleon.animation.play("default");
			}
			if (_cheerTimer <= 0.6 && _head.animation.name != "cheer1")
			{
				_head.animation.play("cheer1");
			}
		}

		var cameraTargetY:Float = 0;
		if (_charmeleon.animation.frameIndex != 0)
		{
			cameraTargetY = CHARMELEON_CAMERA_Y;
		}
		if (cameraTargetY != cameraPosition.y && (_cameraTween == null || !_cameraTween.active))
		{
			var tweenDuration:Float = 0.3;
			for (member in members)
			{
				FlxTween.tween(member, {y: member.y + (cameraPosition.y - cameraTargetY)}, tweenDuration, {ease:FlxEase.circOut});
			}
			_cameraTween = FlxTween.tween(cameraPosition, {y: cameraTargetY}, tweenDuration, {ease:FlxEase.circOut});
		}

		sync(_headBack);
		sync(_arms);
		sync(_dick);
	}

	public function playDickAnimation(animName:String):Void
	{
		_dick.animation.play(animName);
		sync(_dick);
	}

	public function sync(sprite:FlxSprite):Void
	{
		if (sprite.animation.curAnim == null)
		{
			return;
		}
		if (SexyDebugState.debug)
		{
			// don't sync when we're in debug mode trying to capture data for animation frames...
			return;
		}
		if (sprite.animation.curAnim.numFrames == 5 && sprite.animation.curAnim.looped && sprite.animation.curAnim.curFrame != _torso.animation.curAnim.curFrame)
		{
			sprite.animation.curAnim.curFrame = _torso.animation.curAnim.curFrame;
		}
	}

	/**
	 * Trigger some sort of animation or behavior based on a dialog sequence
	 * 
	 * @param	str the special dialog which might trigger an animation or behavior
	 */
	override public function doFun(str:String)
	{
		super.doFun(str);
		if (str == "charmeleon")
		{
			_arms.animation.play("charmeleon");
			_charmeleon.animation.play("charmeleon");
		}
		if (str == "charmeleon-instant")
		{
			_arms.animation.play("charmeleon");
			_charmeleon.animation.play("charmeleon");

			var cameraTargetY:Float = CHARMELEON_CAMERA_Y;
			for (member in members)
			{
				member.y = member.y + (cameraPosition.y - cameraTargetY);
			}
			cameraPosition.y = cameraTargetY;
		}
		if (str == "charmelesexy")
		{
			_arms.animation.play("charmelesexy");
			_charmeleon.animation.play("charmelesexy");
		}
		if (str == "charmeleoff")
		{
			_arms.animation.play("default");
			_charmeleon.animation.play("default");
		}
	}

	override public function cheerful():Void
	{
		super.cheerful();

		if (_charmeleon.animation.frameIndex != 0)
		{
			// holding up the charmeleon cutout... don't move our arms
			return;
		}

		_head.animation.play("cheer0");
		_arms.animation.play("cheer0");
		_charmeleon.animation.play("default");
		_torso.animation.play("default", true);

		_cheerTimer = 3;
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		CursorUtils.initializeHandBouncySprite(_interact, AssetPaths.grimer_interact__png);
		if (PlayerData.grimMale)
		{
			_interact.animation.add("rub-hidden-dick", [4, 3, 2, 1, 0]);
			_interact.animation.add("rub-dick", [6, 5, 4, 3, 2]);
			_interact.animation.add("jack-off", [10, 9, 8, 7, 6, 5]);
		}
		else
		{
			_interact.animation.add("rub-hidden-dick", [32, 33, 34, 35, 36]);
			_interact.animation.add("rub-dick", [32, 33, 34, 35, 36]);
			_interact.animation.add("jack-off", [40, 41, 42, 43, 44, 45]);
		}
		_interact.animation.add("rub-bulb-bad", [14, 13, 12, 11]);
		_interact.animation.add("finger-cavity-good", [16, 17, 18, 19, 20]);
		_interact.animation.add("fondle-valve-good", [24, 25, 26, 27, 28]);
		_interact.animation.add("stroke-artery-ok", [15, 21, 22, 23]);
		_interact.animation.add("squeeze-lumpus-good", [29, 30, 31]);
		_interact.animation.add("squeeze-polyp-bad", [29, 30, 31]);
		_interact.visible = false;
	}

	override public function destroy():Void
	{
		super.destroy();

		_torso = FlxDestroyUtil.destroy(_torso);
		_arms = FlxDestroyUtil.destroy(_arms);
		_charmeleon = FlxDestroyUtil.destroy(_charmeleon);
		_headBack = FlxDestroyUtil.destroy(_headBack);
		_oldArmAnimationName = null;
		_cameraTween = FlxTweenUtil.destroy(_cameraTween);
	}
}