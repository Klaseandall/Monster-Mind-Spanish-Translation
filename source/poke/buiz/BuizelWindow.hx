package poke.buiz;
import flixel.util.FlxDestroyUtil;
import poke.buiz.BuizelDialog;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * Sprites and animations for Buizel
 */
class BuizelWindow extends PokeWindow
{
	public var _shorts0:BouncySprite;
	public var _shorts1:BouncySprite;
	public var _balls:BouncySprite;
	public var _shirt0:BouncySprite;
	public var _shirt1:BouncySprite;
	public var _arms1:BouncySprite;
	public var _arms0:BouncySprite;
	public var _blush:BouncySprite;
	public var _floof:BouncySprite;
	public var _legs:BouncySprite;
	public var _torso0:BouncySprite;
	public var _torso1:BouncySprite;
	public var _ass:BouncySprite;
	public var _neck:BouncySprite;

	public function new(X:Float=0, Y:Float=0, Width:Int=248, Height:Int = 349) 
	{
		super(X, Y, Width, Height);
		_prefix = "buiz";
		_name = "Buizel";
		_victorySound = AssetPaths.buizel__mp3;
		_dialogClass = BuizelDialog;
		add(new FlxSprite( -54, -54, AssetPaths.buizel_bg__png));
		
		_torso0 = new BouncySprite( -54, -54, 0, 7, 0.1, _age);
		_torso0.loadWindowGraphic(AssetPaths.buizel_torso0__png);
		addPart(_torso0);
		
		_torso1 = new BouncySprite( -54, -54 - 4, 4, 7, 0.1, _age);
		_torso1.loadWindowGraphic(AssetPaths.buizel_torso1__png);
		addPart(_torso1);
		
		_shorts0 = new BouncySprite( -54, -54, 2, 7, 0.16, _age);
		_shorts0.loadWindowGraphic(AssetPaths.buizel_shorts0__png);
		addPart(_shorts0);
		
		_legs = new BouncySprite( -54, -54, 0, 7, 0.1, _age);
		_legs.loadWindowGraphic(AssetPaths.buizel_legs__png);
		_legs.animation.add("0", [0]);
		_legs.animation.add("1", [1]);
		_legs.animation.add("2", [2]);
		_legs.animation.add("3", [3]);
		addPart(_legs);

		_shorts1 = new BouncySprite( -54, -54, 2, 7, 0.16, _age);
		_shorts1.loadWindowGraphic(AssetPaths.buizel_shorts1__png);
		addPart(_shorts1);
		
		_ass = new BouncySprite( -54, -54, 0, 7, 0.1, _age);
		_ass.loadWindowGraphic(AssetPaths.buizel_ass__png);
		_ass.animation.add("default", [0]);
		_ass.animation.add("finger-ass0", [0, 1, 2, 3, 4, 5]);
		_ass.animation.add("finger-ass1", [0, 6, 7, 8, 9, 10]);
		_ass.animation.play("default");
		addPart(_ass);
		
		_balls = new BouncySprite( -54, -54, 2, 7, 0.16, _age);
		_balls.loadWindowGraphic(AssetPaths.buizel_balls__png);
		
		_dick = new BouncySprite( -54, -54, 2, 7, 0.16, _age);
		_dick.loadWindowGraphic(BuizelResource.dick);
		_dick.animation.add("default", [0]);
		if (PlayerData.buizMale) {
			_balls.animation.add("default", [0, 0, 0, 1, 1, 2, 2, 2, 2, 2, 1, 1, 0, 0], 3);
			_balls.animation.add("rub-balls-left", [5, 4, 3]);
			_balls.animation.add("rub-balls-right", [9, 8, 7, 6]);
			_balls.animation.play("default");
			addPart(_balls);
			_dick.animation.add("boner1", [1, 1, 2, 2, 2, 1], 3);
			_dick.animation.add("boner2", [4, 3, 3, 3, 4, 4], 3);
			_dick.animation.add("rub-dick", [5, 6, 7]);
			_dick.animation.add("jack-off", [14, 13, 12, 11, 10, 9]);
			addPart(_dick);
		} else {
			_dick.animation.add("finger-ass0", [0, 0, 14]);
			_dick.animation.add("finger-ass1", [0, 0, 0, 14, 14, 15]);
			_dick.animation.add("rub-dick", [4, 5, 6, 7]);
			_dick.animation.add("rub-dick1", [4, 3, 2, 1]);
			_dick.animation.add("jack-off", [8, 9, 10, 11, 12, 13]);
			addPart(_dick);
			_dick.synchronize(_torso0);
		}
		
		_shirt0 = new BouncySprite( -54, -54 - 4, 4, 7, 0.2, _age);
		_shirt0.loadWindowGraphic(BuizelResource.shirt0);
		addPart(_shirt0);
		
		_arms0 = new BouncySprite( -54, -54 - 4, 4, 7, 0.2, _age);
		_arms0.loadWindowGraphic(AssetPaths.buizel_arms0__png);
		_arms0.animation.add("default", [0]);
		_arms0.animation.add("0", [0]);
		_arms0.animation.add("1", [2]);
		_arms0.animation.add("2", [3]);
		_arms0.animation.add("3", [6]);
		_arms0.animation.add("4", [7]);
		_arms0.animation.add("cheer", [1]);
		addPart(_arms0);
		
		_shirt1 = new BouncySprite( -54, -54 - 4, 4, 7, 0.2, _age);
		_shirt1.loadWindowGraphic(AssetPaths.buizel_shirt1__png);
		addPart(_shirt1);
		
		_neck = new BouncySprite( -54, -54 - 5, 5, 7, 0.3, _age);
		_neck.loadWindowGraphic(AssetPaths.buizel_neck__png);
		_neck.animation.add("default", [0]);
		_neck.animation.add("honk-neck", [1, 2, 3]);
		addPart(_neck);
		
		_head = new BouncySprite( -54, -54 - 6, 6, 7, 0.32, _age);
		_head.loadGraphic(BuizelResource.head, true, 356, 266);
		_head.animation.add("default", blinkyAnimation([3, 4], [5]), 3);
		_head.animation.add("cheer", blinkyAnimation([3, 4], [5]), 3);
		_head.animation.add("0-0", blinkyAnimation([0, 1], [2]), 3);
		_head.animation.add("0-1", blinkyAnimation([6, 7], [8]), 3);
		_head.animation.add("0-2", blinkyAnimation([9, 10], [11]), 3);
		_head.animation.add("1-0", blinkyAnimation([12, 13], [14]), 3);
		_head.animation.add("1-1", blinkyAnimation([15, 16], [17]), 3);
		_head.animation.add("1-2", blinkyAnimation([18, 19], [20]), 3);
		_head.animation.add("1-3", blinkyAnimation([21, 22], [23]), 3);
		_head.animation.add("2-0", blinkyAnimation([24, 25], [26]), 3);
		_head.animation.add("2-1", blinkyAnimation([27, 28], [29]), 3);
		_head.animation.add("2-2", blinkyAnimation([30, 31], [32]), 3);
		_head.animation.add("3-0", blinkyAnimation([36, 37], [38]), 3);
		_head.animation.add("3-1", blinkyAnimation([39, 40], [41]), 3);
		_head.animation.add("3-2", blinkyAnimation([42, 43], [44]), 3);
		_head.animation.add("4-0", blinkyAnimation([48, 49]), 3);
		_head.animation.add("4-1", blinkyAnimation([51, 52]), 3);
		_head.animation.add("4-2", blinkyAnimation([54, 55]), 3);
		_head.animation.add("5-0", blinkyAnimation([60, 61]), 3);
		_head.animation.add("5-1", blinkyAnimation([63, 64, 65]), 3);
		_head.animation.add("5-2", blinkyAnimation([66, 67]), 3);
		_head.animation.add("rub-floof", blinkyAnimation([69, 70], [71]), 3);
		_head.animation.play("0-0");
		addPart(_head);
		
		_blush = new BouncySprite( -54, -54 - 6, 6, 7, 0.32, _age);
		if (_interactive) {
			_blush.loadWindowGraphic(AssetPaths.buizel_blush__png);
			_blush.animation.add("default", [0]);
			_blush.animation.add("cheer", blinkyAnimation([27, 28, 29]), 3);
			_blush.animation.add("0-0", blinkyAnimation([27, 28, 29]), 3);
			_blush.animation.add("0-1", blinkyAnimation([15, 23, 31]), 3);
			_blush.animation.add("0-2", blinkyAnimation([1, 2, 3]), 3);
			_blush.animation.add("1-0", blinkyAnimation([14, 22, 30]), 3);
			_blush.animation.add("1-1", blinkyAnimation([27, 28, 29]), 3);
			_blush.animation.add("1-2", blinkyAnimation([1, 2, 3]), 3);
			_blush.animation.add("1-3", blinkyAnimation([16, 17, 18]), 3);
			_blush.animation.add("1-2", blinkyAnimation([19, 20, 21]), 3);
			_blush.animation.add("2-0", blinkyAnimation([24, 25, 26]), 3);
			_blush.animation.add("2-1", blinkyAnimation([16, 17, 18]), 3);
			_blush.animation.add("2-2", blinkyAnimation([8, 9, 10]), 3);
			_blush.animation.add("3-0", blinkyAnimation([27, 28, 29]), 3);
			_blush.animation.add("3-1", blinkyAnimation([11, 12, 13]), 3);
			_blush.animation.add("3-2", blinkyAnimation([4, 5, 6]), 3);
			_blush.animation.add("4-0", blinkyAnimation([27, 28, 29]), 3);
			_blush.animation.add("4-1", blinkyAnimation([19, 20, 21]), 3);
			_blush.animation.add("4-2", blinkyAnimation([1, 2, 3]), 3);
			_blush.animation.add("5-0", blinkyAnimation([15, 23, 31]), 3);
			_blush.animation.add("5-1", blinkyAnimation([16, 17, 18]), 3);
			_blush.animation.add("5-2", blinkyAnimation([8, 9, 10]), 3);
			_blush.animation.add("rub-floof", blinkyAnimation([16, 17, 18]), 3);
			_blush.visible = false;
			addVisualItem(_blush);
		}
		
		_floof = new BouncySprite( -54, -54 - 6, 6, 7, 0.32, _age);
		if (_interactive) {
			_floof.loadWindowGraphic(AssetPaths.buizel_floof__png);
			_floof.animation.add("default", [1]);
			_floof.animation.add("rub-floof", [1, 2, 3, 4]);
			_floof.animation.play("default");
			_floof.visible = false;
			addPart(_floof);
		}
		
		_arms1 = new BouncySprite( -54, -54 - 4, 4, 7, 0.2, _age);
		_arms1.loadWindowGraphic(AssetPaths.buizel_arms1__png);
		_arms1.animation.add("default", [0]);
		_arms1.animation.add("cheer", [1]);
		addPart(_arms1);
		
		_interact = new BouncySprite( -54, -54, _dick._bounceAmount, _dick._bounceDuration, _dick._bouncePhase, _age);
		if (_interactive) {
			reinitializeHandSprites();
			add(_interact);
		}
		
		setNudity(PlayerData.level);
	}
	
	override public function cheerful() {
		super.cheerful();
		_head.animation.play("cheer");
		_arms0.animation.play("cheer");
		_arms1.animation.play("cheer");
	}
	
	override public function setNudity(NudityLevel:Int) {
		super.setNudity(NudityLevel);
		if (NudityLevel == 0) {
			_shirt0.visible = true;
			_shirt1.visible = true;
			_shorts0.visible = true;
			_shorts1.visible = true;
			_balls.visible = false;
			_dick.visible = false;
			_ass.visible = false;
		}
		if (NudityLevel == 1) {
			_shirt0.visible = false;
			_shirt1.visible = false;
			_shorts0.visible = true;
			_shorts1.visible = true;
			_balls.visible = false;
			_dick.visible = false;
			_ass.visible = false;
		}
		if (NudityLevel >= 2) {
			_shirt0.visible = false;
			_shirt1.visible = false;
			_shorts0.visible = false;
			_shorts1.visible = false;
			_balls.visible = true;
			_dick.visible = true;
			_ass.visible = true;
		}
	}
	
	override public function arrangeArmsAndLegs() {
		if (_arousal == 0) {
			playNewAnim(_legs, ["0", "1"]);
			playNewAnim(_arms0, ["0"]);
		} else {
			playNewAnim(_legs, ["0", "0", "1", "1", "2", "3"]);
			playNewAnim(_arms0, ["0", "0", "1", "2", "3", "4"]);
		}
	}
	
	override public function setArousal(Arousal:Int) {
		super.setArousal(Arousal);
		if (_arousal == 0) {
			playNewAnim(_head, ["0-0", "0-1", "0-2"]);
		} else if (_arousal == 1) {
			playNewAnim(_head, ["1-0", "1-1", "1-2", "1-3"]);
		} else if (_arousal == 2) {
			playNewAnim(_head, ["2-0", "2-1", "2-2"]);
		} else if (_arousal == 3) {
			playNewAnim(_head, ["3-0", "3-1", "3-2"]);
		} else if (_arousal == 4) {
			playNewAnim(_head, ["4-0", "4-1", "4-2"]);
		} else if (_arousal == 5) {
			playNewAnim(_head, ["5-0", "5-1", "5-2"]);
		}
	}
	
	override public function playNewAnim(spr:FlxSprite, array:Array<String>) 
	{
		super.playNewAnim(spr, array);
		if (spr == _head) {
			if(_blush.animation.getByName(_head.animation.name) != null) {
				_blush.animation.play(_head.animation.name);
			} else {
				_blush.animation.play("default");
			}
		}
	}
	
	override public function reinitializeHandSprites() 
	{
		super.reinitializeHandSprites();
		CursorUtils.initializeHandBouncySprite(_interact, AssetPaths.buizel_interact__png);
		if (PlayerData.buizMale) {
			_interact.animation.add("rub-dick", [0, 1, 2]);
			_interact.animation.add("jack-off", [13, 12, 11, 10, 9, 8]);
			_interact.animation.add("rub-balls-left", [5, 4, 3]);
			_interact.animation.add("rub-balls-right", [19, 18, 17, 16]);
		} else {
			_interact.animation.add("rub-dick", [43, 44, 45, 46]);
			_interact.animation.add("rub-dick1", [43, 42, 41, 40]);
			_interact.animation.add("jack-off", [48, 49, 50, 51, 52, 53]);
		}
		_interact.animation.add("finger-ass0", [24, 25, 26, 27, 28, 29]);
		_interact.animation.add("finger-ass1", [32, 33, 34, 35, 36, 37]);
		_interact.animation.add("rub-floof", [20, 21, 22, 23]);
		_interact.animation.add("honk-neck", [6, 7, 15]);
		_interact.visible = false;
	}
	
	override public function destroy():Void {
		super.destroy();
		
		_shorts0 = FlxDestroyUtil.destroy(_shorts0);
		_shorts1 = FlxDestroyUtil.destroy(_shorts1);
		_balls = FlxDestroyUtil.destroy(_balls);
		_shirt0 = FlxDestroyUtil.destroy(_shirt0);
		_shirt1 = FlxDestroyUtil.destroy(_shirt1);
		_arms1 = FlxDestroyUtil.destroy(_arms1);
		_arms0 = FlxDestroyUtil.destroy(_arms0);
		_blush = FlxDestroyUtil.destroy(_blush);
		_floof = FlxDestroyUtil.destroy(_floof);
		_legs = FlxDestroyUtil.destroy(_legs);
		_torso0 = FlxDestroyUtil.destroy(_torso0);
		_torso1 = FlxDestroyUtil.destroy(_torso1);
		_ass = FlxDestroyUtil.destroy(_ass);
		_neck = FlxDestroyUtil.destroy(_neck);
	}
}