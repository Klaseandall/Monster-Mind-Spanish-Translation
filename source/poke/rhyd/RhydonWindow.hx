package poke.rhyd;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import openfl.display.BlendMode;
import openfl.geom.Point;
import poke.sand.SandslashDialog;

/**
 * Sprites and animations for Rhydon
 */
class RhydonWindow extends PokeWindow
{
	private static var TORSO_OFFSET_MAP:Map<String, Int> = ["default" => 0, "cheer" => 13, "height0" => 13, "height1" => 7, "height2" => 0];
	private static var BOUNCE_DURATION:Float = 9;
	private static var MIN_Y = -35;
	private static var CORNER_SIZE = 46;

	public var _tail:BouncySprite;
	public var _torso0:BouncySprite;
	public var _torso1:BouncySprite;
	public var _torso2:BouncySprite;
	public var _torso3:BouncySprite;
	public var _torso4:BouncySprite;
	public var _balls:BouncySprite;
	public var _pants:BouncySprite;
	public var _arms0:BouncySprite;
	public var _arms1:BouncySprite;
	public var _neck:BouncySprite;
	public var _shirt0:BouncySprite;
	public var _shirt:BouncySprite;
	public var _cheer:BouncySprite;

	private var _cameraTween:FlxTween;
	private var _cheerTimer:Float = -1;
	private var _torsoTimer:Float = 0;
	private var _torsoHeight:Int = -1;
	private var cameraQueueCount:Int = 0;

	/**
	 * We move the camera vertically with an FlxTween, but if this FlxTween is
	 * active while the window is resized it results in some incorrect
	 * scrolling behavior. So, we delay resizing the window until FlxTweens are
	 * completed
	 */
	private var resizeQueue:Array<Int> = null;

	public function new(X:Float=0, Y:Float=0, Width:Int=248, Height:Int = 349)
	{
		super(X, Y, Width, Height);
		_prefix = "rhyd";
		_name = "Rhydon";
		_victorySound = AssetPaths.rhyd__mp3;
		_dialogClass = RhydonDialog;

		_cameraButtons.push({x:234, y:3, image:AssetPaths.camera_button__png, callback:() -> toggleCamera()});

		add(new FlxSprite( -54, MIN_Y, AssetPaths.rhydon_bg__png));

		_tail = new BouncySprite( -54, MIN_Y, 0, BOUNCE_DURATION, 0.08, _age);
		loadTallGraphic(_tail, AssetPaths.rhydon_tail__png);
		addPart(_tail);

		_torso0 = new BouncySprite( -54, MIN_Y, 0, BOUNCE_DURATION, 0, _age);
		loadTallGraphic(_torso0, RhydonResource.torso0);
		_torso0.animation.add("default", [0]);
		_torso0.animation.add("height0", [1]);
		_torso0.animation.add("height1", [2]);
		_torso0.animation.add("height2", [0]);
		_torso0.animation.add("cheer", [1]);
		addPart(_torso0);

		_torso1 = new BouncySprite( -54, MIN_Y - 2, 2, BOUNCE_DURATION, 0.07, _age);
		loadTallGraphic(_torso1, AssetPaths.rhydon_torso1__png);
		addPart(_torso1);

		_torso2 = new BouncySprite( -54, MIN_Y - 4, 4, BOUNCE_DURATION, 0.13, _age);
		loadTallGraphic(_torso2, AssetPaths.rhydon_torso2__png);
		addPart(_torso2);

		_arms0 = new BouncySprite( -54, MIN_Y - 6, 6, BOUNCE_DURATION, 0.15, _age);
		loadTallGraphic(_arms0, AssetPaths.rhydon_arms0__png);
		_arms0.animation.add("default", [0]);
		_arms0.animation.add("cheer", [1]);
		addPart(_arms0);

		_torso3 = new BouncySprite( -54, MIN_Y - 4, 4, BOUNCE_DURATION, 0.13, _age);
		loadTallGraphic(_torso3, AssetPaths.rhydon_torso3__png);
		addPart(_torso3);

		_balls = new BouncySprite( -54, MIN_Y - 2, 2, BOUNCE_DURATION, 0.05, _age);
		loadTallGraphic(_balls, AssetPaths.rhydon_balls__png);
		_balls.animation.add("default", [0]);
		_balls.animation.add("rub-balls", [1, 2, 3, 4]);

		_dick = new BouncySprite( -54, MIN_Y - 3, 3, BOUNCE_DURATION, 0.10, _age);
		loadTallGraphic(_dick, RhydonResource.dick);

		if (PlayerData.rhydMale)
		{
			addPart(_balls);
			_dick.animation.add("default", [0]);
			_dick.animation.add("rub-foreskin", [8, 9, 10, 11, 12, 13]);
			_dick.animation.add("rub-foreskin1", [8, 7, 6, 5, 4, 3]);
			_dick.animation.add("rub-dick", [14, 15, 16, 17]);
			_dick.animation.add("jack-foreskin", [18, 19, 20, 21, 22]);
			_dick.animation.add("jack-off", [23, 24, 25, 26, 27]);
			addPart(_dick);
		}
		else
		{
			_dick.animation.add("default", [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 0, 0, 0, 0], 3);
			_dick.animation.add("rub-foreskin", [3, 4, 5, 6, 7]);
			_dick.animation.add("rub-dick", [13, 14, 15, 16, 17, 18]);
			_dick.animation.add("jack-foreskin", [8, 9, 10, 11, 12]);
			_dick.animation.add("jack-off", [19, 20, 21, 22, 23, 24, 25, 26, 27]);
			_dick.animation.play("default");
			addPart(_dick);
			_dick.synchronize(_torso0);
		}

		_neck = new BouncySprite( -54, MIN_Y - 8, 8, BOUNCE_DURATION, 0.25, _age);
		loadTallGraphic(_neck, AssetPaths.rhydon_neck__png);
		addPart(_neck);

		_torso4 = new BouncySprite( -54, MIN_Y - 6, 6, BOUNCE_DURATION, 0.20, _age);
		loadTallGraphic(_torso4, AssetPaths.rhydon_torso4__png);
		addPart(_torso4);

		_pants = new BouncySprite( -54, MIN_Y - 6, 6, BOUNCE_DURATION, 0.20, _age);
		loadTallGraphic(_pants, RhydonResource.pants);
		addPart(_pants);
		if (!PlayerData.rhydMale)
		{
			_pants.synchronize(_torso1);
		}

		_shirt0 = new BouncySprite( -54, MIN_Y - 6, 6, BOUNCE_DURATION, 0.15, _age);
		loadTallGraphic(_shirt0, AssetPaths.rhydon_shirt0_f__png);
		_shirt0.animation.add("default", [0]);
		_shirt0.animation.add("cheer", [1]);
		if (!PlayerData.rhydMale)
		{
			addPart(_shirt0);
		}

		_arms1 = new BouncySprite( -54, MIN_Y - 6, 6, BOUNCE_DURATION, 0.15, _age);
		loadTallGraphic(_arms1, AssetPaths.rhydon_arms1__png);
		_arms1.animation.add("default", [0]);
		_arms1.animation.add("cheer", [1]);
		_arms1.animation.add("0", [0]);
		_arms1.animation.add("1", [2]);
		_arms1.animation.add("2", [3]);
		_arms1.animation.add("3", [4]);
		addPart(_arms1);

		_head = new BouncySprite( -54, MIN_Y - 8, 8, BOUNCE_DURATION, 0.25, _age);
		_head.loadGraphic(RhydonResource.head, true, 356, 330);
		_head.animation.add("default", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("0-0", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("0-1", blinkyAnimation([9, 10], [11]), 3);
		_head.animation.add("0-2", blinkyAnimation([12, 13], [14]), 3);
		_head.animation.add("cheer0", blinkyAnimation([3, 4]), 3);
		_head.animation.add("cheer1", blinkyAnimation([6, 7], [8]), 3);
		_head.animation.add("1-0", blinkyAnimation([18, 19], [20]), 3);
		_head.animation.add("1-1", blinkyAnimation([21, 22], [23]), 3);
		_head.animation.add("1-2", blinkyAnimation([24, 25], [26]), 3);
		_head.animation.add("2-0", blinkyAnimation([27, 28], [29]), 3);
		_head.animation.add("2-1", blinkyAnimation([30, 31], [32]), 3);
		_head.animation.add("2-2", blinkyAnimation([33, 34], [35]), 3);
		_head.animation.add("3-0", blinkyAnimation([36, 37]), 3);
		_head.animation.add("3-1", blinkyAnimation([39, 40]), 3);
		_head.animation.add("3-2", blinkyAnimation([42, 43]), 3);
		_head.animation.add("4-0", blinkyAnimation([45, 46], [47]), 3);
		_head.animation.add("4-1", blinkyAnimation([48, 49], [50]), 3);
		_head.animation.add("4-2", blinkyAnimation([51, 52], [53]), 3);
		_head.animation.add("5-0", blinkyAnimation([54, 55]), 3);
		_head.animation.add("5-1", blinkyAnimation([57, 58]), 3);
		_head.animation.add("5-2", blinkyAnimation([60, 61]), 3);
		_head.animation.play("0-0");
		addPart(_head);

		_shirt = new BouncySprite( -54, MIN_Y - 6, 6, BOUNCE_DURATION, 0.15, _age);
		loadTallGraphic(_shirt, RhydonResource.shirt);
		_shirt.animation.add("default", [0]);
		_shirt.animation.add("cheer", [1]);
		addPart(_shirt);
		if (!PlayerData.rhydMale)
		{
			reposition(_shirt, members.indexOf(_head));
		}

		_cheer = new BouncySprite( -54, MIN_Y, 0, BOUNCE_DURATION, 0, _age);
		loadTallGraphic(_cheer, AssetPaths.rhydon_cheer__png);
		_cheer.animation.add("default", [0]);
		_cheer.animation.add("cheer", [1, 2, 1, 2, 0], 3, false);
		addPart(_cheer);

		_interact = new BouncySprite( -54, -54, _dick._bounceAmount, _dick._bounceDuration, _dick._bouncePhase, _age);
		if (_interactive)
		{
			reinitializeHandSprites();
			add(_interact);
		}

		setNudity(PlayerData.level);
		syncCamera();
	}

	public function syncCamera():Void
	{
		if (cameraPosition.y <= 0 != PlayerData.rhydonCameraUp)
		{
			toggleCamera(0);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		_torsoTimer += elapsed;
		if (_torsoTimer >= 0 && _torsoHeight >= 0)
		{
			adjustTorso0("height" + _torsoHeight);
			_torsoTimer = -6;
			_torsoHeight = -1;
		}

		if (cameraQueueCount > 0 && (_cameraTween == null || !_cameraTween.active))
		{
			cameraQueueCount--;
			toggleCamera();
		}

		if (resizeQueue != null && (_cameraTween == null || !_cameraTween.active))
		{
			resize(resizeQueue[0], resizeQueue[1]);
			resizeQueue = null;
		}

		if (_cheerTimer > 0)
		{
			_cheerTimer -= elapsed;
			if (_cheerTimer <= 0.8 && _head.animation.name != "cheer1")
			{
				_head.animation.play("cheer1");
			}
			if (_cheerTimer <= 0)
			{
				_arms0.animation.play("default");
				_arms1.animation.play("default");
				_shirt.animation.play("default");
				_shirt0.animation.play("default");
			}
		}
	}

	override public function cheerful():Void
	{
		super.cheerful();

		_shirt.animation.play("cheer");
		_shirt0.animation.play("cheer");
		_head.animation.play("cheer0");
		_cheer.animation.play("cheer");
		_arms0.animation.play("cheer");
		_arms1.animation.play("cheer");
		adjustTorso0("cheer");
		_torso0.animation.play("cheer");
		_cheerTimer = 3;
	}

	override public function arrangeArmsAndLegs()
	{
		playNewAnim(_arms1, ["0", "1", "2", "3"]);
		_arms0.animation.play("default");
		if (_torsoTimer >= 0)
		{
			adjustTorso0(FlxG.random.getObject(["height0", "height1", "height2"]));
		}
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

	/**
	 * Rhydon sometimes stands up straight or squats slightly. This method
	 * adjusts his stance
	 *
	 * @param	height 0, 1, or 2 based on Rhydon's desired stance
	 * @param	delay number of seconds until Rhydon repositions
	 */
	public function forceTorsoSoon(height:Int, delay:Float):Void
	{
		_torsoTimer = -delay;
		_torsoHeight = height;
	}

	private function adjustTorso0(newAnim:String)
	{
		var oldAnim:String = _torso0.animation.name;
		_torso0.animation.play(newAnim);

		var oldOffset = TORSO_OFFSET_MAP[oldAnim] == null ? 0 : TORSO_OFFSET_MAP[oldAnim];
		var newOffset = TORSO_OFFSET_MAP[newAnim] == null ? 0 : TORSO_OFFSET_MAP[newAnim];

		for (part in _parts)
		{
			part.y += newOffset - oldOffset;
		}
		_interact.y += newOffset - oldOffset;
	}

	/**
	 * Trigger some sort of animation or behavior based on a dialog sequence
	 *
	 * @param	str the special dialog which might trigger an animation or behavior
	 */
	override public function doFun(str:String)
	{
		super.doFun(str);
		if (_cameraTween != null && _cameraTween.active)
		{
			cameraQueueCount++;
		}
		else
		{
			if (str == "camera-instant")
			{
				toggleCamera(0);
			}
			if (str == "camera-fast")
			{
				toggleCamera(0.3);
			}
			if (str == "camera-med")
			{
				toggleCamera(0.8);
			}
			if (str == "camera-slow")
			{
				toggleCamera(2.0);
			}
		}
	}

	function loadTallGraphic(Sprite:BouncySprite, SimpleGraphic:FlxGraphicAsset)
	{
		Sprite.loadGraphic(SimpleGraphic, true, 356, 660);
	}

	override public function setNudity(NudityLevel:Int)
	{
		super.setNudity(NudityLevel);
		if (NudityLevel == 0)
		{
			_dick.visible = false;
			_balls.visible = false;
			_pants.visible = true;
			_shirt.visible = true;
			_shirt0.visible = true;
		}
		else if (NudityLevel == 1)
		{
			_dick.visible = false;
			_balls.visible = false;
			_pants.visible = true;
			_shirt.visible = false;
			_shirt0.visible = false;
		}
		else if (NudityLevel >= 2)
		{
			_dick.visible = true;
			_balls.visible = true;
			_pants.visible = false;
			_shirt.visible = false;
			_shirt0.visible = false;
		}
	}

	override public function resize(Width:Int = 248, Height:Int = 350)
	{
		if (_cameraTween != null && _cameraTween.active)
		{
			// can't resize while moving camera; resize later
			resizeQueue = [Width, Height];
		}
		else
		{
			var oldHeight = _canvas.height;
			super.resize(Width, Height);
			if (cameraPosition.y > 0)
			{
				for (member in members)
				{
					member.y += Height - oldHeight;
				}
				cameraPosition.y -= Height - oldHeight;
			}
		}
	}

	public function toggleCamera(tweenDuration:Float = 0.3):Void
	{
		if (_cameraTween == null || !_cameraTween.active)
		{
			var scrollAmount:Float = _canvas.height - 590;
			if (cameraPosition.y > 0)
			{
				// move camera up
				scrollAmount *= -1;
				PlayerData.rhydonCameraUp = true;
			}
			else
			{
				// move camera down
				PlayerData.rhydonCameraUp = false;
			}
			if (tweenDuration > 0)
			{
				for (member in members)
				{
					FlxTween.tween(member, {y: member.y + scrollAmount}, tweenDuration, {ease:FlxEase.circOut});
				}
				_cameraTween = FlxTween.tween(cameraPosition, {y: cameraPosition.y - scrollAmount}, tweenDuration, {ease:FlxEase.circOut});
			}
			else
			{
				for (member in members)
				{
					member.y += scrollAmount;
				}
				cameraPosition.y -= scrollAmount;
			}
		}
	}

	override public function draw():Void
	{
		FlxSpriteUtil.fill(_canvas, FlxColor.WHITE);
		for (member in members)
		{
			if (member != null && member.visible)
			{
				_canvas.stamp(member, Std.int(member.x - member.offset.x - x), Std.int(member.y - member.offset.y - y));
			}
		}
		{
			// erase corner
			var poly:Array<FlxPoint> = [];
			poly.push(FlxPoint.get(_canvas.width - CORNER_SIZE, 0));
			poly.push(FlxPoint.get(_canvas.width, CORNER_SIZE));
			poly.push(FlxPoint.get(_canvas.width, 0));
			poly.push(FlxPoint.get(_canvas.width - CORNER_SIZE, 0));
			FlxSpriteUtil.drawPolygon(_canvas, poly, 0xFF80684E, null, {blendMode:BlendMode.ERASE});
			FlxDestroyUtil.putArray(poly);
		}

		#if !flash
		// BlendMode.ERASE is not supported by non-flash targets, so we manually erase the pixels
		// with a threshold() call
		_canvas.pixels.threshold(_canvas.pixels, _canvas.pixels.rect, new Point(0, 0), "==", 0xFF80684E);
		#end

		{
			// draw pentagon around character frame
			var poly:Array<FlxPoint> = [];
			poly.push(FlxPoint.get(1, 1));
			poly.push(FlxPoint.get(_canvas.width - CORNER_SIZE + 1, 1));
			poly.push(FlxPoint.get(_canvas.width - 1, CORNER_SIZE - 1));
			poly.push(FlxPoint.get(_canvas.width - 1, _canvas.height - 1));
			poly.push(FlxPoint.get(1, _canvas.height - 1));
			poly.push(FlxPoint.get(1, 1));
			FlxSpriteUtil.drawPolygon(_canvas, poly, FlxColor.TRANSPARENT, { thickness: 2 });
			FlxDestroyUtil.putArray(poly);

			// corner looks skimpy when drawing "pixel style" so fatten it up
			FlxSpriteUtil.drawLine(_canvas, _canvas.width - CORNER_SIZE, 0, _canvas.width, CORNER_SIZE, {thickness:3, color:FlxColor.BLACK});
		}

		_canvas.pixels.setPixel32(0, 0, 0x00000000);
		_canvas.pixels.setPixel32(0, Std.int(_canvas.height-1), 0x00000000);
		_canvas.pixels.setPixel32(Std.int(_canvas.width-1), Std.int(_canvas.height-1), 0x00000000);
		_canvas.draw();
	}

	override public function reinitializeHandSprites()
	{
		super.reinitializeHandSprites();
		CursorUtils.initializeTallHandBouncySprite(_interact, RhydonResource.interact);
		if (PlayerData.rhydMale)
		{
			_interact.animation.add("rub-foreskin", [5, 6, 7, 8, 9, 10]);
			_interact.animation.add("rub-foreskin1", [5, 4, 3, 2, 1, 0]);
			_interact.animation.add("rub-dick", [11, 12, 13, 14]);
			_interact.animation.add("jack-foreskin", [15, 16, 17, 18, 19]);
			_interact.animation.add("jack-off", [20, 21, 22, 23, 24]);
			_interact.animation.add("rub-balls", [25, 26, 27, 28]);
		}
		else
		{
			_interact.animation.add("rub-foreskin", [0, 1, 2, 3, 4]);
			_interact.animation.add("rub-dick", [10, 11, 12, 13, 14, 15]);
			_interact.animation.add("jack-foreskin", [5, 6, 7, 8, 9]);
			_interact.animation.add("jack-off", [16, 17, 18, 19, 20, 21, 22, 23, 24]);
		}
		_interact.visible = false;
	}

	override public function destroy():Void
	{
		super.destroy();

		_tail = FlxDestroyUtil.destroy(_tail);
		_torso0 = FlxDestroyUtil.destroy(_torso0);
		_torso1 = FlxDestroyUtil.destroy(_torso1);
		_torso2 = FlxDestroyUtil.destroy(_torso2);
		_torso3 = FlxDestroyUtil.destroy(_torso3);
		_torso4 = FlxDestroyUtil.destroy(_torso4);
		_balls = FlxDestroyUtil.destroy(_balls);
		_pants = FlxDestroyUtil.destroy(_pants);
		_arms0 = FlxDestroyUtil.destroy(_arms0);
		_arms1 = FlxDestroyUtil.destroy(_arms1);
		_neck = FlxDestroyUtil.destroy(_neck);
		_shirt0 = FlxDestroyUtil.destroy(_shirt0);
		_shirt = FlxDestroyUtil.destroy(_shirt);
		_cheer = FlxDestroyUtil.destroy(_cheer);
		_cameraTween = FlxTweenUtil.destroy(_cameraTween);
	}
}