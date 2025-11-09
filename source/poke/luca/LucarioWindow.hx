package poke.luca;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import openfl.display.BlendMode;
import openfl.geom.Point;

/**
 * Sprites and animations for Lucario during the puzzles
 */
class LucarioWindow extends PokeWindow
{
	private static var CORNER_SIZE = 46;

	private var eventStack:EventStack = new EventStack();

	private var feet:BouncySprite;
	private var tail:BouncySprite;
	private var legs:BouncySprite;
	private var crotch:BouncySprite;
	private var balls:BouncySprite;
	private var pubicScruff:BouncySprite;
	private var hair:BouncySprite;
	private var torso0:BouncySprite;
	private var pants:BouncySprite;
	private var torso1:BouncySprite;
	private var arms:BouncySprite;
	private var neck:BouncySprite;

	private var _cameraTween:FlxTween;

	private var scrollTimer:Float = 0;
	private var autoScrollCount:Int = 0;

	public function new(X:Float=0, Y:Float=0, Width:Int=248, Height:Int = 349)
	{
		super(X, Y, Width, Height);
		_prefix = "luca";
		_name = "Lucario";
		_victorySound = AssetPaths.luca__mp3;
		_dialogClass = LucarioDialog;

		_cameraButtons.push({x:234, y:3, image:AssetPaths.camera_button__png, callback:() -> toggleCamera()});

		add(new FlxSprite( -54, -54, AssetPaths.luca_bg__png));

		feet = new BouncySprite( -54, -54, 7, 7.4, 0.15, _age);
		feet.loadWindowGraphic(AssetPaths.luca_feet__png);
		addPart(feet);

		tail = new BouncySprite( -54, -54, 7, 7.4, 0.15, _age);
		tail.loadWindowGraphic(AssetPaths.luca_tail__png);
		addPart(tail);

		legs = new BouncySprite( -54, -54, 0, 7.4, 0, _age);
		legs.loadWindowGraphic(AssetPaths.luca_legs__png);
		addPart(legs);

		crotch = new BouncySprite( -54, -54, 0, 7.4, 0, _age);
		crotch.loadWindowGraphic(AssetPaths.luca_crotch__png);
		addPart(crotch);

		balls = new BouncySprite( -54, -54, 2, 7.4, 0.15, _age);
		balls.loadWindowGraphic(AssetPaths.luca_balls__png);

		pubicScruff = new BouncySprite( -54, -54, 2, 7.4, 0.15, _age);
		pubicScruff.loadWindowGraphic(AssetPaths.luca_pubic_scruff__png);

		_dick = new BouncySprite( -54, -54, 3, 7.4, 0.10, _age);
		_dick.loadWindowGraphic(LucarioResource.dick);

		if (PlayerData.lucaMale)
		{
			addPart(balls);
			addPart(_dick);
		}
		else
		{
			addPart(_dick);
			addPart(pubicScruff);
			_dick.synchronize(crotch);
		}

		hair = new BouncySprite( -54, -54, 7, 7.4, 0.15, _age);
		hair.loadWindowGraphic(AssetPaths.luca_hair__png);
		hair.animation.add("default", [0]);
		hair.animation.add("hat-default", [1]);
		hair.animation.add("cheer", [2]);
		hair.animation.add("hat-cheer", [3]);
		hair.animation.play("default");
		addPart(hair);

		torso0 = new BouncySprite( -54, -54, 0, 7.4, 0, _age);
		torso0.loadWindowGraphic(AssetPaths.luca_torso0__png);
		addPart(torso0);

		pants = new BouncySprite( -54, -54, 0, 7.4, 0, _age);
		pants.loadWindowGraphic(LucarioResource.pants);
		addVisualItem(pants);

		torso1 = new BouncySprite( -54, -54, 3, 7.4, 0.05, _age);
		torso1.loadWindowGraphic(AssetPaths.luca_torso1__png);
		torso1.animation.add("default", [0]);
		torso1.animation.add("shirt-default", [1]);
		torso1.animation.play("default");
		addPart(torso1);

		arms = new BouncySprite( -54, -54, 2, 7.4, 0.15, _age);
		arms.loadWindowGraphic(AssetPaths.luca_arms__png);
		arms.animation.add("default", [0]);
		arms.animation.add("shirt-default", [1]);
		arms.animation.add("cheer", [2]);
		arms.animation.add("shirt-cheer", [3]);
		arms.animation.play("default");
		addPart(arms);

		neck = new BouncySprite( -54, -54, 4, 7.4, 0.10, _age);
		neck.loadWindowGraphic(AssetPaths.luca_neck__png);
		neck.animation.add("default", [0]);
		neck.animation.add("shirt-default", [1]);
		neck.animation.play("default");
		addPart(neck);

		_head = new BouncySprite( -54, -54, 5, 7.4, 0.09, _age);
		_head.loadGraphic(LucarioResource.head, true, 356, 266);
		_head.animation.add("default", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("smirk", blinkyAnimation([3, 4], [5]), 3);
		_head.animation.add("hat-default", blinkyAnimation([12, 13], [14]), 3);
		_head.animation.add("hat-smirk", blinkyAnimation([15, 16], [17]), 3);
		_head.animation.add("cheer", blinkyAnimation([6, 7], [8]), 3);
		_head.animation.add("hat-cheer", blinkyAnimation([18, 19], [20]), 3);
		_head.animation.play("default");
		addPart(_head);

		setNudity(PlayerData.level);
	}

	override public function cheerful():Void
	{
		super.cheerful();

		if (StringTools.startsWith(_head.animation.name, "hat-"))
		{
			_head.animation.play("hat-cheer");
			hair.animation.play("hat-cheer");
		}
		else {
			_head.animation.play("cheer");
			hair.animation.play("cheer");
		}
		if (StringTools.startsWith(arms.animation.name, "shirt-"))
		{
			arms.animation.play("shirt-cheer");
		}
		else {
			arms.animation.play("cheer");
		}
	}

	override public function setNudity(NudityLevel:Int)
	{
		if (NudityLevel == 0)
		{
			setHat(true);

			pants.visible = true;
			torso1.animation.play("shirt-default");
			arms.animation.play("shirt-default");
			neck.animation.play("shirt-default");
			_dick.visible = false;
			balls.visible = false;
			pubicScruff.visible = false;
		}
		else if (NudityLevel == 1)
		{
			setHat(false);

			pants.visible = true;
			torso1.animation.play("default");
			arms.animation.play("default");
			neck.animation.play("default");
			_dick.visible = false;
			balls.visible = false;
			pubicScruff.visible = false;
		}
		else
		{
			setHat(false);

			pants.visible = false;
			torso1.animation.play("default");
			arms.animation.play("default");
			neck.animation.play("default");
			_dick.visible = true;
			balls.visible = true;
			pubicScruff.visible = true;
		}
	}

	private function setHat(hat:Bool):Void
	{
		LucarioResource.setHat(hat);
		if (hat)
		{
			_head.animation.play("hat-default");
			hair.animation.play("hat-default");
		}
		else {
			_head.animation.play("default");
			hair.animation.play("default");
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		eventStack.update(elapsed);
	}

	/**
	 * Trigger some sort of animation or behavior based on a dialog sequence
	 *
	 * @param	str the special dialog which might trigger an animation or behavior
	 */
	override public function doFun(str:String)
	{
		super.doFun(str);

		if (str == "nohat")
		{
			setHat(false);
		}
		else if (str == "hat")
		{
			setHat(true);
		}
	}

	override public function resize(Width:Int = 248, Height:Int = 350)
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

	public function eventAutoScrollUp(args:Array<Dynamic>):Void
	{
		if (cameraPosition.y > 0)
		{
			/*
			 * After scrolling the camera to look at their junk, Lucario will
			 * scroll it back up for you and smirk at you
			 */
			autoScrollCount++;
			toggleCamera();

			if (StringTools.startsWith(_head.animation.name, "hat-"))
			{
				_head.animation.play("hat-smirk");
			}
			else
			{
				_head.animation.play("smirk");
			}
			eventStack.addEvent({time:eventStack._time + 2.5, callback:eventDefaultFace});
		}
	}

	public function eventDefaultFace(args:Array<Dynamic>):Void
	{
		if (StringTools.startsWith(_head.animation.name, "hat-"))
		{
			_head.animation.play("hat-default");
		}
		else {
			_head.animation.play("default");
		}
	}

	public function toggleCamera(tweenDuration:Float = 0.3):Void
	{
		if (_cameraTween == null || !_cameraTween.active)
		{
			var scrollAmount:Float = _canvas.height - 440;
			if (cameraPosition.y > 0)
			{
				// move camera up
				scrollAmount *= -1;
				eventStack.removeEvent(eventAutoScrollUp);
			}
			else
			{
				// move camera down
				eventStack.removeEvent(eventAutoScrollUp);
				var scrollDelay:Float = 6 * Math.pow(4, FlxMath.bound(autoScrollCount, 0, 10));
				eventStack.addEvent({time:eventStack._time + scrollDelay, callback:eventAutoScrollUp});
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

	override public function destroy():Void
	{
		super.destroy();

		eventStack = null;
		feet = FlxDestroyUtil.destroy(feet);
		tail = FlxDestroyUtil.destroy(tail);
		legs = FlxDestroyUtil.destroy(legs);
		crotch = FlxDestroyUtil.destroy(crotch);
		balls = FlxDestroyUtil.destroy(balls);
		pubicScruff = FlxDestroyUtil.destroy(pubicScruff);
		hair = FlxDestroyUtil.destroy(hair);
		torso0 = FlxDestroyUtil.destroy(torso0);
		pants = FlxDestroyUtil.destroy(pants);
		torso1 = FlxDestroyUtil.destroy(torso1);
		arms = FlxDestroyUtil.destroy(arms);
		neck = FlxDestroyUtil.destroy(neck);

		_cameraTween = FlxTweenUtil.destroy(_cameraTween);
	}
}