package critter;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.util.FlxDirectionFlags;
import kludge.BetterFlxRandom;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import poke.sexy.RandomPolygonPoint;
import puzzle.Puzzle;

/**
 * Graphics and logic for the little bugs which the player interacts with
 * during puzzles.
 *
 * Since "Bug" means something else in the context of computer programs, these
 * are often referred to as "critters" in code
 */
class Critter implements IFlxDestroyable
{
	// which critters to load
	public static var LOAD_DEFAULT:Int = 0;
	public static var LOAD_ALL:Int = 1;
	public static var LOAD_BASIC_ONLY:Int = 2;

	// unambiguous color names; they correspond to different palettes for the critters
	public static var FJ_RED_DK:String = "red/dark red";
	public static var FJ_BLUE_LT:String = "blue/light blue";
	public static var FJ_YEL:String = "yellow";
	public static var FJ_GREN_DK:String = "green/dark green";
	public static var FJ_PRPL:String = "purple";
	public static var FJ_BRWN:String = "brown";
	public static var FJ_RED_LT:String = "red/light red";
	public static var FJ_ORNG:String = "orange";
	public static var FJ_GREN_LT:String = "green/light green";
	public static var FJ_PINK:String = "pink";
	public static var FJ_CYAN:String = "cyan";
	public static var FJ_WHIT:String = "white";
	public static var FJ_BLAK:String = "black";
	public static var FJ_GREY:String = "grey";
	public static var FJ_BLUE_DK:String = "blue/dark blue";

	// critter color keycodes; they correspond to pixel colors in the source image, we use them for threshold color replacements
	private static var CCL_SKIN:Int = 0xfff57d86;
	private static var CCL_SKIN_SHADOW:Int = 0xffd57075;
	private static var CCL_SKIN_LINE:Int = 0xffb36264;
	private static var CCL_BELLY:Int = 0xff7b3f43;
	private static var CCL_BELLY_SHADOW:Int = 0xff6b383b;
	private static var CCL_BELLY_LINE:Int = 0xff5a3132;
	private static var CCL_EYES:Int = 0xfffabec3;
	private static var CCL_EYES_LINE:Int = 0xffffe7e9;
	private static var CCL_EYES_SHINE:Int = 0xffffffff;

	private static var STATIC_ID:Int = 0;
	public var myId:Int = STATIC_ID++;

	public static var _FRAME_RATE = 6;
	public static var CRITTER_GENDERS:Array<Float> = [];
	public static var CRITTER_COLORS:Array<CritterColor> = [];
	public static var IDLE_ENABLED:Bool = true;

	public var _targetSprite:FlxSprite;
	public var _soulSprite:FlxSprite;
	public var _bodySprite:CritterBody;
	public var _headSprite:CritterHead;
	public var _frontBodySprite:FlxSprite;
	public var _critterColor:CritterColor;
	public var outCold:Bool = false;
	public var _runToCallback:Critter->Void;
	// Z coordinate; if creature is jumping or carried
	public var z:Float = 0;
	// Z coordinate of the surface the critter is standing on; usually zero, but sometimes they are on a platform
	public var groundZ:Float = 0;
	public var targetGroundZ:Float = 0;
	private var _backdrop:FlxSprite;

	public var _tween0:VarTween = null;
	public var _tween1:VarTween = null;
	public var _tween2:VarTween = null;

	public var _eventStack:EventStack = new EventStack();
	public var _frontBodySpriteOffset:Float = 4;
	public var _bodySpriteOffset:Float = 39;
	// for auditing purposes; if a critter ends up in a crazy state, we can use this to figure out what happened
	public var _lastSexyAnim:String = null;
	public var shadow:Shadow;
	public var idleMove:Bool = true;
	// this critter doesn't move unless someone tells it to
	public var permanentlyImmovable:Bool = false;
	/*
	 * tracks whether this critter was immovable before the sexy animation
	 * started; when the sexy animation ends, we want to restore them to their
	 * previous state
	 */
	public var wasImmovableBeforeSexyAnim:Bool = false;
	public var jumpType:Int = 0;
	public var canDie:Bool = true;

	/**
	 * Initializes a new bug.
	 *
	 * Bugs sometimes barf or cum on the background, so this takes the
	 * background sprite as a parameter so the bugs can do their thing. ...So
	 * don't pass in any sprites which you can't trivially put in the laundry
	 * afterwards. If you need to, cover your sprite with a towel sprite first.
	 *
	 * @param	X bug's x position
	 * @param	Y bug's y position
	 * @param	Backdrop background sprite for the bug to make messes on
	 */
	public function new(X:Float, Y:Float, Backdrop:FlxSprite)
	{
		this._backdrop = Backdrop;

		_targetSprite = new FlxSprite(X, Y);
		_targetSprite.makeGraphic(38, 14, 0x88FFFF00);
		_targetSprite.visible = false;
		_targetSprite.offset.set(3, 4);

		_soulSprite = new FlxSprite(X, Y);
		_soulSprite.makeGraphic(38, 14, 0x44FF00FF);
		_soulSprite.visible = false;
		_soulSprite.offset.set(3, 4);

		_bodySprite = new CritterBody(this);
		_bodySprite.setPosition(X, Y);

		_headSprite = new CritterHead(this);

		_frontBodySprite = new FlxSprite();
		_frontBodySprite.setFacingFlip(FlxDirectionFlags.LEFT, false, false);
		_frontBodySprite.setFacingFlip(FlxDirectionFlags.RIGHT, true, false);
		_frontBodySprite.facing = _bodySprite.facing;
		_frontBodySprite.visible = false;

		_headSprite.addBlinkableFrame(0, 3);
		_headSprite.addBlinkableFrame(1, 3);
		_headSprite.addBlinkableFrame(2, 3);
		_headSprite.addBlinkableFrame(48, 50);
		_headSprite.addBlinkableFrame(49, 51);
		_headSprite.addBlinkableFrame(52, 50);
		_headSprite.addBlinkableFrame(53, 51);
		_headSprite.addBlinkableFrame(54, 62);
		_headSprite.addBlinkableFrame(55, 63);
		_headSprite.addBlinkableFrame(58, 66);
		_headSprite.addBlinkableFrame(59, 67);
		_headSprite.addBlinkableFrame(60, 68);
		_headSprite.addBlinkableFrame(61, 69);
		_headSprite.addBlinkableFrame(72, 86);
		_headSprite.addBlinkableFrame(73, 87);
		_headSprite.addBlinkableFrame(80, 84);
		_headSprite.addBlinkableFrame(81, 85);
		_headSprite.addBlinkableFrame(82, 84);
		_headSprite.addBlinkableFrame(83, 85);
		_headSprite.addBlinkableFrame(98, 100);
		_headSprite.addBlinkableFrame(99, 100);
		_headSprite.addBlinkableFrame(101, 103);
		_headSprite.addBlinkableFrame(102, 103);

		// set random default color, for use in minigames that don't care about color
		setColor(CRITTER_COLORS[FlxG.random.int(0, CRITTER_COLORS.length - 1)]);
	}

	public static function loadPaletteShiftedGraphic(sprite:FlxSprite, critterColor:CritterColor, graphicAsset:FlxGraphicAsset, animated:Bool = false, width:Int = 0, height:Int = 0)
	{
		var graphicKey:String = graphicAsset + "-" + critterColor.englishBackup;
		if (FlxG.bitmap.get(graphicKey) == null)
		{
			var graphic:FlxGraphic = FlxG.bitmap.add(graphicAsset, true, graphicKey);
			for (key in critterColor.tint.keys())
			{
				graphic.bitmap.threshold(graphic.bitmap, new Rectangle(0, 0, graphic.bitmap.width, graphic.bitmap.height), new Point(0, 0), '==', key, critterColor.tint[key]);
			}
		}
		sprite.loadGraphic(graphicKey, animated, width, height);
	}

	public function setColor(critterColor:CritterColor)
	{
		this._critterColor = critterColor;

		loadPaletteShiftedGraphic(_bodySprite, critterColor, AssetPaths.critter_bodies_0__png, true, 64, 64);
		loadPaletteShiftedGraphic(_frontBodySprite, critterColor, AssetPaths.critter_bodies_0__png, true, 64, 64);
		loadPaletteShiftedGraphic(_headSprite, critterColor, AssetPaths.critter_heads_0__png, true, 64, 64);

		_bodySprite.setSize(36, 10);
		_bodySprite.offset.set(14, _bodySpriteOffset);

		_frontBodySprite.setSize(36, 10);
		_frontBodySprite.offset.set(14, _bodySpriteOffset + _frontBodySpriteOffset + z);

		_headSprite.setSize(36, 10);
		_headSprite.offset.set(14, _bodySpriteOffset + 2);

		loadCritterAnimations();

		_headSprite.animation.play("idle");
		_bodySprite.animation.play("idle");
		_bodySprite.movingPrefix = "run";
		_frontBodySprite.animation.play("idle");
	}

	private function loadCritterAnimations():Void
	{
		{
			var idleAnim:Array<Int> = [];
			AnimTools.push(idleAnim, FlxG.random.int(7, 10), [0, 1, 2]);
			AnimTools.push(idleAnim, FlxG.random.int(3, 4), [4, 5]);
			AnimTools.push(idleAnim, FlxG.random.int(7, 10), [0, 1, 2]);
			AnimTools.push(idleAnim, FlxG.random.int(3, 4), [4, 5]);
			AnimTools.push(idleAnim, FlxG.random.int(7, 10), [0, 1, 2]);
			AnimTools.push(idleAnim, FlxG.random.int(3, 4), [4, 5]);

			_headSprite.animation.add("idle", idleAnim, _FRAME_RATE);
			// This is two frames, so that critterBody logic can tell when it animates
			_bodySprite.animation.add("idle", [0, 0], _FRAME_RATE);
			_frontBodySprite.animation.add("idle", [2, 2], _FRAME_RATE);

			_headSprite.animation.add("sexy-idle", idleAnim, _FRAME_RATE);
			_bodySprite.animation.add("sexy-idle", [0, 0], _FRAME_RATE);
			_frontBodySprite.animation.add("sexy-idle", [2, 2], _FRAME_RATE);
		}

		_headSprite.animation.add("grab", [6]);
		_bodySprite.animation.add("grab", [1]);

		// drag critter west fast
		_bodySprite.animation.add("grab-w2", [90, 90, 91, 1, 89, 1], _FRAME_RATE, false);
		_bodySprite.animation.add("grab-w1", [91, 91, 1], _FRAME_RATE, false);

		// drag critter east fast
		_bodySprite.animation.add("grab-e2", [88, 88, 89, 1, 91, 1], _FRAME_RATE, false);
		_bodySprite.animation.add("grab-e1", [89, 89, 1], _FRAME_RATE, false);

		_headSprite.animation.add("tumble-sw", [36, 37, 38, 39], _FRAME_RATE);
		_bodySprite.animation.add("tumble-sw", [76, 77, 78, 79], _FRAME_RATE);

		_headSprite.animation.add("tumble-nw", [36, 37, 38, 39], _FRAME_RATE);
		_bodySprite.animation.add("tumble-nw", [76, 77, 78, 79], _FRAME_RATE);

		_headSprite.animation.add("tumble-n", [36, 37, 38, 39], _FRAME_RATE);
		_bodySprite.animation.add("tumble-n", [76, 77, 78, 79], _FRAME_RATE);

		_headSprite.animation.add("bad-landing-sw", AnimTools.blinkyAnimation([74, 75]), _FRAME_RATE);
		_bodySprite.animation.add("bad-landing-sw", [80, 80, 80, 80, 82, 84], _FRAME_RATE, false);

		_headSprite.animation.add("run-sw", [16]);
		_bodySprite.animation.add("run-sw", [8, 9, 10], _FRAME_RATE);

		_headSprite.animation.add("jump-sw", [16]);
		_bodySprite.animation.add("jump-sw", [9, 10], 0);

		_headSprite.animation.add("run-nw", [20]);
		_bodySprite.animation.add("run-nw", [12, 13, 14], _FRAME_RATE);

		_headSprite.animation.add("jump-nw", [20]);
		_bodySprite.animation.add("jump-nw", [13, 14], 0);

		_headSprite.animation.add("run-n", [24]);
		_bodySprite.animation.add("run-n", [16, 17, 18], _FRAME_RATE);

		_headSprite.animation.add("jump-n", [24]);
		_bodySprite.animation.add("jump-n", [17, 18], 0);

		_headSprite.animation.add("run-s", [0]);
		_bodySprite.animation.add("run-s", [20, 21, 22], _FRAME_RATE);

		_headSprite.animation.add("jump-s", [0]);
		_bodySprite.animation.add("jump-s", [21, 22], 0);

		_headSprite.animation.add("idle-itch0", [13, 13, 14, 15, 14, 15, 14, 15, 0], _FRAME_RATE, false);
		_bodySprite.animation.add("idle-itch0", [0, 4, 5, 4, 5, 4, 5, 4, 0], _FRAME_RATE, false);
		_frontBodySprite.animation.add("idle-itch0", [2, 2, 6, 2, 6, 2, 6, 2], _FRAME_RATE, false);

		_headSprite.animation.add("idle-itch1", [13, 13, 14, 15, 14, 15, 14, 15, 14, 15, 14, 15, 14, 15, 0], _FRAME_RATE, false);
		_bodySprite.animation.add("idle-itch1", [0, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 0], _FRAME_RATE, false);
		_frontBodySprite.animation.add("idle-itch1", [2, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2], _FRAME_RATE, false);

		_headSprite.animation.add("idle-shake", [3, 3, 27, 28, 29, 30, 25, 26, 27, 28, 29, 30, 25, 26, 27, 28, 29, 30, 25, 26, 27, 28, 29, 3, 3, 3, 3], 12, false);
		_bodySprite.animation.add("idle-shake", [0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 0], 12, false);

		_headSprite.animation.add("idle-wobble", [17, 17, 0, 18, 18, 1, 17, 17, 2, 18, 18], _FRAME_RATE, false);
		_bodySprite.animation.add("idle-wobble", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], _FRAME_RATE, false);

		_headSprite.animation.add("idle-yawn0", [21, 22, 23, 22, 23, 22, 23, 22, 21, 0, 3, 0], _FRAME_RATE, false);
		_bodySprite.animation.add("idle-yawn0", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], _FRAME_RATE, false);

		_headSprite.animation.add("idle-yawn1", [21, 22, 23, 22, 23, 22, 23, 22, 23, 22, 23, 21, 0, 3, 3, 0, 3, 0], _FRAME_RATE, false);
		_bodySprite.animation.add("idle-yawn1", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], _FRAME_RATE, false);

		_headSprite.animation.add("idle-outcold0", [32], _FRAME_RATE);
		_bodySprite.animation.add("idle-outcold0", [0], _FRAME_RATE);

		{
			// randomly apply one of three "out cold" animations
			var outColdFrames:Array<Int> = FlxG.random.getObject([[104, 105, 7], [112, 113, 15], [120, 121, 23]]);
			var outColdHeadAnim:Array<Int> = [];
			AnimTools.push(outColdHeadAnim, FlxG.random.int(27, 33), [outColdFrames[0]]);
			AnimTools.push(outColdHeadAnim, FlxG.random.int(10, 15), [outColdFrames[1]]);
			AnimTools.shift(outColdHeadAnim);
			_headSprite.animation.add("idle-outcold1", outColdHeadAnim, _FRAME_RATE);
			_bodySprite.animation.add("idle-outcold1", [outColdFrames[2]], _FRAME_RATE);
		}

		_headSprite.animation.add("outcold-cube", [12], _FRAME_RATE);

		_headSprite.animation.add("idle-vomit", [45, 46, 45, 46, 45, 47, 46, 45, 47, 46, 47, 45, 34, 35, 33, 2], _FRAME_RATE, false);
		_bodySprite.animation.add("idle-vomit", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], _FRAME_RATE, false);

		_headSprite.animation.add("look-up", [77, 78, 79, 78, 79, 78, 79, 78, 77], _FRAME_RATE, false);
		_bodySprite.animation.add("look-up", [0, 0, 0, 0, 0, 0, 0, 0, 0], _FRAME_RATE, false);

		_headSprite.animation.add("tug-vgood", AnimTools.blinkyAnimation([107, 108]), _FRAME_RATE);
		_bodySprite.animation.add("tug-vgood", AnimTools.blinkyAnimation([85, 86, 87]), _FRAME_RATE);

		_headSprite.animation.add("tug-good", AnimTools.blinkyAnimation([98, 99]), _FRAME_RATE);
		_bodySprite.animation.add("tug-good", AnimTools.blinkyAnimation([85, 86, 87]), _FRAME_RATE);

		_headSprite.animation.add("tug-bad", AnimTools.blinkyAnimation([101, 102]), _FRAME_RATE);
		_bodySprite.animation.add("tug-bad", AnimTools.blinkyAnimation([93, 94, 95]), _FRAME_RATE);

		_headSprite.animation.add("tug-vbad", AnimTools.blinkyAnimation([109, 110, 111]), 12);
		_bodySprite.animation.add("tug-vbad", AnimTools.blinkyAnimation([101, 102, 103]), 12);

		// bob head around
		_headSprite.animation.add("idle-happy0", [92, 93, 92, 94, 92, 93,
		92, 91, 90, 90, 88, 91,
		91, 91, 90], _FRAME_RATE, false);
		_bodySprite.animation.add("idle-happy0", [0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0,
		0, 0, 0], _FRAME_RATE, false);
		_headSprite.animation.add("idle-veryhappy0", [92, 93, 92, 94, 92, 93,
		92, 94, 92, 93, 92, 94,
		92, 91, 90, 90, 88, 91,
		91, 91, 90], _FRAME_RATE, false);
		_bodySprite.animation.add("idle-veryhappy0", [0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0,
		0, 0, 0], _FRAME_RATE, false);

		// quick bows
		_headSprite.animation.add("idle-happy1", [95, 95, 91, 95, 90, 91,
		91, 88, 89, 88, 88, 90,
		91, 90, 89], _FRAME_RATE, false);
		_bodySprite.animation.add("idle-happy1", [0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0,
		0, 0, 0], _FRAME_RATE, false);
		_headSprite.animation.add("idle-veryhappy1", [95, 95, 91, 95, 90, 91,
		95, 88, 95, 95, 88, 90,
		91, 88, 89, 88, 88, 90,
		91, 90, 89], _FRAME_RATE, false);
		_bodySprite.animation.add("idle-veryhappy1", [0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0,
		0, 0, 0], _FRAME_RATE, false);

		// ear wiggle
		_headSprite.animation.add("idle-happy2", [96, 97, 96, 97, 96, 89,
		90, 91, 88, 88, 89, 88,
		90, 91, 88], _FRAME_RATE, false);
		_bodySprite.animation.add("idle-happy2", [0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0,
		0, 0, 0], _FRAME_RATE, false);
		_headSprite.animation.add("idle-veryhappy2", [92, 93, 92, 96, 97, 96,
		97, 96, 97, 96, 97, 96,
		97, 89, 88, 88, 89, 88,
		90, 91, 88], _FRAME_RATE, false);
		_bodySprite.animation.add("idle-veryhappy2", [0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0,
		0, 0, 0], _FRAME_RATE, false);

		SexyAnims.addAnims(this);

		{
			var jitteryHeadAnim:Array<Int> = [];
			AnimTools.push(jitteryHeadAnim, FlxG.random.int(7, 10), [40, 41, 42]);
			AnimTools.push(jitteryHeadAnim, FlxG.random.int(3, 4), [43, 44]);
			AnimTools.push(jitteryHeadAnim, FlxG.random.int(7, 10), [40, 41, 42]);
			AnimTools.push(jitteryHeadAnim, FlxG.random.int(3, 4), [43, 44]);
			var jitteryBodyAnim:Array<Int> = [];
			AnimTools.push(jitteryBodyAnim, jitteryHeadAnim.length, [0]);
			_headSprite.animation.add("idle-jittery0", jitteryHeadAnim, _FRAME_RATE, false);
			_bodySprite.animation.add("idle-jittery0", jitteryBodyAnim, _FRAME_RATE, false);
		}

		{
			var jitteryHeadAnim:Array<Int> = [];
			AnimTools.push(jitteryHeadAnim, FlxG.random.int(7, 10), [40, 41, 42]);
			AnimTools.push(jitteryHeadAnim, FlxG.random.int(3, 4), [43, 44]);
			AnimTools.push(jitteryHeadAnim, FlxG.random.int(7, 10), [40, 41, 42]);
			AnimTools.push(jitteryHeadAnim, FlxG.random.int(3, 4), [43, 44]);
			AnimTools.push(jitteryHeadAnim, FlxG.random.int(7, 10), [40, 41, 42]);
			AnimTools.push(jitteryHeadAnim, FlxG.random.int(3, 4), [43, 44]);
			AnimTools.push(jitteryHeadAnim, FlxG.random.int(7, 10), [40, 41, 42]);
			AnimTools.push(jitteryHeadAnim, FlxG.random.int(3, 4), [43, 44]);
			AnimTools.push(jitteryHeadAnim, FlxG.random.int(7, 10), [40, 41, 42]);
			AnimTools.push(jitteryHeadAnim, FlxG.random.int(3, 4), [43, 44]);
			AnimTools.push(jitteryHeadAnim, FlxG.random.int(7, 10), [40, 41, 42]);
			AnimTools.push(jitteryHeadAnim, FlxG.random.int(3, 4), [43, 44]);
			var jitteryBodyAnim:Array<Int> = [];
			AnimTools.push(jitteryBodyAnim, jitteryHeadAnim.length, [0]);
			_headSprite.animation.add("idle-jittery1", jitteryHeadAnim, _FRAME_RATE, false);
			_bodySprite.animation.add("idle-jittery1", jitteryBodyAnim, _FRAME_RATE, false);
		}

		{
			var sleepAnim:Array<Int> = [];
			AnimTools.push(sleepAnim, FlxG.random.int(8, 10), [32, 33]);
			AnimTools.push(sleepAnim, FlxG.random.int(8, 10), [34, 35]);
			_headSprite.animation.add("idle-sleep", sleepAnim, _FRAME_RATE, true);
			_bodySprite.animation.add("idle-sleep", [0], _FRAME_RATE, true);
			_frontBodySprite.animation.add("idle-sleep", [24, 25, 26, 27, 28], _FRAME_RATE, true);
		}

		{
			var napHeadAnim:Array<Int> = [];
			AnimTools.push(napHeadAnim, FlxG.random.int(4, 5), [32, 33]);
			AnimTools.push(napHeadAnim, FlxG.random.int(8, 10), [34, 35]);
			AnimTools.push(napHeadAnim, FlxG.random.int(8, 10), [32, 33]);
			AnimTools.push(napHeadAnim, FlxG.random.int(8, 10), [34, 35]);
			AnimTools.push(napHeadAnim, FlxG.random.int(4, 5), [32, 33]);
			napHeadAnim.push(0);
			napHeadAnim.push(1);
			napHeadAnim.push(3);
			napHeadAnim.push(2);
			napHeadAnim.push(0);
			napHeadAnim.push(3);

			var napBodyAnim:Array<Int> = [];
			AnimTools.push(napBodyAnim, napHeadAnim.length, [0]);
			_headSprite.animation.add("idle-nap", napHeadAnim, _FRAME_RATE, false);
			_bodySprite.animation.add("idle-nap", napBodyAnim, _FRAME_RATE, false);
		}

		{
			var cubeAnim:Array<Int> = [];
			AnimTools.push(cubeAnim, FlxG.random.int(15, 21), [8, 9, 10]);
			_headSprite.animation.add("cube", cubeAnim, _FRAME_RATE);
			_headSprite.addBlinkableFrame(8, 11);
			_headSprite.addBlinkableFrame(9, 11);
			_headSprite.addBlinkableFrame(10, 11);
			_bodySprite.animation.add("cube", [2]);
		}
	}

	public function eventRunDirRadians(args:Array<Dynamic>)
	{
		var dx:Float = 100 * Math.cos(args[0]);
		var dy:Float = 100 * Math.sin(args[0]);
		runTo(_soulSprite.x + dx, _soulSprite.y + dy);
	}

	public function eventRunTo(args:Array<Dynamic>)
	{
		runTo(args[0], args[1]);
	}

	public function eventStop(args:Array<Dynamic>)
	{
		stop();
	}

	public function isStopped()
	{
		return _targetSprite.x == _soulSprite.x && _targetSprite.y == _soulSprite.y && _runToCallback == null;
	}

	public function eventPlayAnim(args:Array<Dynamic>)
	{
		var animName:String = args[0];
		var idle:Bool = args[1] == null ? false : args[1];
		playAnim(animName, idle);
	}

	public function playAnim(animName:String, idle:Bool = false)
	{
		if (idle)
		{
			_bodySprite._idleTimer = CritterBody.IDLE_FREQUENCY * FlxG.random.float(0.9, 1.11);
		}

		if (StringTools.startsWith(animName, "complex-"))
		{
			if (_targetSprite.immovable)
			{
				// if we're in a box or something, don't run off
			}
			else
			{
				IdleAnims.playComplex(this, animName);
			}
			return;
		}

		if (animName == "idle-outcold0" && !canDie)
		{
			return;
		}

		_bodySprite.animation.play(animName, true);
		_headSprite.animation.play(animName, true);
		if (animName == "idle-vomit")
		{
			var vomitStamp:FlxSprite = new FlxSprite(0, 0);
			vomitStamp.setFacingFlip(FlxDirectionFlags.LEFT, false, false);
			vomitStamp.setFacingFlip(FlxDirectionFlags.RIGHT, true, false);
			vomitStamp.facing = FlxG.random.getObject([FlxDirectionFlags.LEFT, FlxDirectionFlags.RIGHT]);
			vomitStamp.loadGraphic(AssetPaths.critter_vomit__png, true, 64, 64);
			vomitStamp.animation.frameIndex = FlxG.random.int(0, 2);
			_backdrop.stamp(vomitStamp, Std.int(_bodySprite.x - _bodySprite.offset.x + FlxG.random.int(-4, 4)), Std.int(_bodySprite.y - _bodySprite.offset.y + FlxG.random.int(-2, 2)));
		}
		if (animName.substr(0, 5) == "sexy-")
		{
			wasImmovableBeforeSexyAnim = _targetSprite.immovable;
			setImmovable(true);
			SexyAnims.scheduleJizzStamp(this);
		}
		if (animName == "idle-outcold0")
		{
			outCold = true;
		}
		if (_frontBodySprite.animation.getByName(animName) != null)
		{
			_headSprite.facing = _bodySprite.facing;
			_frontBodySprite.facing = _bodySprite.facing;
			if (animName == "idle-sleep")
			{
				// don't flip it
				_frontBodySprite.facing = FlxDirectionFlags.LEFT;
			}
			_frontBodySprite.visible = true;
			_frontBodySprite.animation.play(animName, true);
		}
		else
		{
			_frontBodySprite.visible = false;
		}
	}

	public function eventJizzStamp(args:Array<Dynamic>):Void
	{
		var jizzX:Float = args[0];
		var jizzY:Float = args[1];
		jizzStamp(jizzX, jizzY);
	}

	public function jizzStamp(x:Float, y:Float)
	{
		var jizzStamp:FlxSprite = new FlxSprite(0, 0);
		jizzStamp.setFacingFlip(FlxDirectionFlags.LEFT, false, false);
		jizzStamp.setFacingFlip(FlxDirectionFlags.RIGHT, true, false);
		jizzStamp.facing = FlxG.random.getObject([FlxDirectionFlags.LEFT, FlxDirectionFlags.RIGHT]);
		jizzStamp.loadGraphic(AssetPaths.critter_jizz__png, true, 64, 64);
		jizzStamp.animation.frameIndex = FlxG.random.int(0, 5);
		_backdrop.stamp(jizzStamp, Std.int(_bodySprite.x - _bodySprite.offset.x + x + FlxG.random.int(-2, 2)), Std.int(_bodySprite.y - _bodySprite.offset.y + FlxG.random.int(-1, 1) + y));
	}

	/**
	 * Don't worry, we're not actually destroying the bugs. We're just making
	 * our computer forget about them for a little while so it can think about
	 * other things. I'm sure the bugs are off happily running around on some
	 * digital farm somewhere.
	 */
	public function destroy():Void
	{
		_targetSprite = FlxDestroyUtil.destroy(_targetSprite);
		_soulSprite = FlxDestroyUtil.destroy(_soulSprite);
		_bodySprite = FlxDestroyUtil.destroy(_bodySprite);
		_headSprite = FlxDestroyUtil.destroy(_headSprite);
		_frontBodySprite = FlxDestroyUtil.destroy(_frontBodySprite);
		_critterColor = null;
		_runToCallback = null;
		_tween0 = FlxTweenUtil.destroy(_tween0);
		_tween1 = FlxTweenUtil.destroy(_tween1);
		_tween2 = FlxTweenUtil.destroy(_tween2);
		_eventStack = null;
		_lastSexyAnim = null;
	}

	public function ungrab():Void
	{
		_bodySprite.facing = FlxG.random.getObject([FlxDirectionFlags.LEFT, FlxDirectionFlags.RIGHT]);
		if (outCold)
		{
			if (_bodySprite.animation.curAnim.name == "idle-outcold0")
			{
				// dropped in a box; don't lay down in boxes. it looks silly
			}
			else
			{
				_bodySprite.animation.play("idle-outcold1");
				_headSprite.animation.play("idle-outcold1");
			}
			setImmovable(true);
		}
		else {
			_eventStack.reset();
			_bodySprite.moving = false;
			_bodySprite.animation.play("idle");
			_headSprite.animation.play("idle");
			_bodySprite.movingPrefix = "run";
			_bodySprite._walkSpeed = CritterBody.DEFAULT_WALK_SPEED;
			_bodySprite._jumpSpeed = CritterBody.DEFAULT_JUMP_SPEED;
		}
		_frontBodySprite.animation.play("idle");
	}

	public function setIdle():Void
	{
		_bodySprite.animation.play("idle");
		_headSprite.animation.play("idle");
		_bodySprite.movingPrefix = "run";
		resetFrontBodySprite();
	}

	public function eventRecoverFromBadLanding(args:Array<Dynamic>):Void
	{
		if (_bodySprite.animation.name == "bad-landing-sw")
		{
			setIdle();
		}
	}

	public function grab():Void
	{
		_eventStack.reset();
		_runToCallback = null;
		setGrounded();
		_bodySprite.moving = false;
		_bodySprite.animation.play("grab");
		_headSprite.animation.play("grab");
		resetFrontBodySprite();
		setImmovable(false);
	}

	public function setImmovable(Immovable:Bool)
	{
		if (permanentlyImmovable && Immovable == false)
		{
			return;
		}
		_targetSprite.immovable = Immovable;
	}

	/**
	 * Sets the bug into "cube mode", like when he's squished inside a clue box
	 */
	public function cube()
	{
		if (outCold)
		{
			_headSprite.animation.play("outcold-cube");
		}
		else
		{
			_headSprite.animation.play("cube");
		}
		_bodySprite.animation.play("cube");
		resetFrontBodySprite();
		setImmovable(true);

		// performance optimization: kill cubed critters
		setAlive(false);
	}

	/**
	 * Takes the bug out of "cube mode", freeing him from a clue box
	 */
	public function uncube()
	{
		// performance optimization: revive cubed critters
		setAlive(true);

		if (outCold)
		{
			_bodySprite.animation.play("idle-outcold1");
			_headSprite.animation.play("idle-outcold1");
		}
		else
		{
			_bodySprite.animation.play("idle");
			_headSprite.animation.play("idle");
			_bodySprite.movingPrefix = "run";
		}
		resetFrontBodySprite();
	}

	public function setPosition(X:Float, Y:Float)
	{
		_targetSprite.setPosition(X, Y);
		_soulSprite.setPosition(X, Y);
		_bodySprite.setPosition(X, Y);
		_headSprite.moveHead();
		_frontBodySprite.setPosition(X, Y);
	}

	/**
	 * Adjust a critter's position and target by dx/dy.
	 */
	public function movePosition(dx:Float, dy:Float)
	{
		_targetSprite.x += dx;
		_targetSprite.y += dy;
		_soulSprite.x += dx;
		_soulSprite.y += dy;
		_bodySprite.x += dx;
		_bodySprite.y += dy;
		_frontBodySprite.x += dx;
		_frontBodySprite.y += dy;
		_headSprite.moveHead();
	}

	/**
	 * Reset a critter to being alive and in their default state
	 */
	public function reset()
	{
		outCold = false;
		setImmovable(false);
		setIdle();
		_eventStack.reset();
		_bodySprite.moving = false;
		setPosition(_soulSprite.x, _soulSprite.y);
	}

	/**
	 * Inserts a waypoint which the critter will run to before their current destination
	 */
	public function insertWaypoint(x:Float, y:Float)
	{
		runTo(x, y, new RunToWaypoint(_targetSprite.x, _targetSprite.y, _runToCallback).reachedWaypoint);
	}

	public function runTo(targetX:Float, targetY:Float, ?RunToCallback:Critter->Void)
	{
		if (outCold)
		{
			// don't run; out cold
			return;
		}
		setGrounded();
		// should we assign a moving animation?
		if (outCold)
		{
			// no; critter is out cold
		}
		else if (_bodySprite.animation != null && _bodySprite.animation.name.substr(0, 4) == "run-")
		{
			// no; critter is already running
		}
		else
		{
			_bodySprite.assignMovingAnim(_soulSprite.x, _soulSprite.y, targetX, targetY, "run");
		}
		_targetSprite.setPosition(targetX, targetY);
		_bodySprite.moving = true;
		setImmovable(true);
		_runToCallback = RunToCallback;

		if (_soulSprite.getPosition().distanceTo(_targetSprite.getPosition()) <= 4)
		{
			// special case; told to run somewhere where we already are...
			_bodySprite.moving = false;
			setPosition(targetX, targetY);
			reachedDestination();
		}
	}

	public function dropTo(X:Float, Y:Float, Z:Float, ?RunToCallback:Critter->Void)
	{
		z = Z;
		_targetSprite.setPosition(X, Y);
		_bodySprite.moving = true;
		var dist:Float = _bodySprite.getPosition().distanceTo(_targetSprite.getPosition());
		var delay:Float = Math.sqrt(z) / 13 + 0.05;
		_tween1 = FlxTween.tween(this, { z : 1 }, delay / 2, { ease:FlxEase.quadIn });
		_runToCallback = RunToCallback;
		if (outCold)
		{
			playAnim("idle-outcold1", false);
		}
		else
		{
			_bodySprite.assignMovingAnim(_bodySprite.x, _bodySprite.y, X, Y, "jump");
		}
	}

	public function jumpTo(targetX:Float, targetY:Float, targetZ:Float, ?RunToCallback:Critter->Void)
	{
		if (outCold)
		{
			// don't jump; out cold
			return;
		}
		if (z == groundZ)
		{
			// enable mid-air flag
			z = groundZ + 1;
		}
		_targetSprite.setPosition(targetX, targetY);
		_bodySprite.moving = true;
		if (_soulSprite.getPosition().distanceTo(_targetSprite.getPosition()) > 4)
		{
			setImmovable(true);
		}
		var dist:Float = _bodySprite.getPosition().distanceTo(_targetSprite.getPosition());

		var delay:Float = dist / _bodySprite._jumpSpeed;
		var height:Float = dist * dist / (_bodySprite._jumpSpeed * _bodySprite._jumpSpeed / 169);
		_tween0 = FlxTween.tween(this, { z : z / 2 + targetZ / 2 + height}, delay / 2, { ease:FlxEase.quadOut });
		_tween1 = FlxTween.tween(this, { z : targetZ + 1 }, delay / 2, { startDelay:delay / 2, ease:FlxEase.quadIn });
		if (z != targetZ)
		{
			_tween2 = FlxTween.tween(this, {groundZ : targetZ}, delay);
			targetGroundZ = targetZ;
		}
		_runToCallback = RunToCallback;
		_bodySprite.assignMovingAnim(_bodySprite.x, _bodySprite.y, targetX, targetY, "jump");
	}

	public function updateMovingPrefix(prefix:String)
	{
		_bodySprite.assignMovingAnim(_bodySprite.x, _bodySprite.y, _targetSprite.x, _targetSprite.y, prefix);
	}

	public function isCubed():Bool
	{
		return _headSprite.animation.curAnim.name == "cube" || _headSprite.animation.curAnim.name == "outcold-cube";
	}

	public function reachedDestination()
	{
		_bodySprite.setPosition(_targetSprite.x, _targetSprite.y);
		_headSprite.setPosition(_targetSprite.x, _targetSprite.y + 2);
		setImmovable(false);
		var wasMidAir:Bool = isMidAir();
		if (wasMidAir)
		{
			_bodySprite._jumpSpeed = CritterBody.DEFAULT_JUMP_SPEED;
		}
		setGrounded();
		if (!outCold)
		{
			if (_bodySprite.movingPrefix == "tumble")
			{
				_bodySprite.animation.play("bad-landing-sw");
				_headSprite.animation.play("bad-landing-sw");
				_eventStack.addEvent({time:_eventStack._time + 1.5, callback:eventRecoverFromBadLanding});
			}
			else
			{
				_bodySprite.animation.play("idle");
				_headSprite.animation.play("idle");
				_bodySprite.movingPrefix = "run";
			}
		}
		if (_runToCallback != null)
		{
			var tmpCallback:Critter->Void = _runToCallback;
			_runToCallback = null;
			tmpCallback(this);
		}
		if (wasMidAir)
		{
			if (_bodySprite.animation.name == "bad-landing-sw")
			{
				SoundStackingFix.play(AssetPaths.splat_00c6__mp3);
			}
			else
			{
				SoundStackingFix.play(AssetPaths.drop__mp3);
			}
		}
	}

	function setGrounded()
	{
		if (_tween0 != null)
		{
			_tween0.active = false;
		}
		if (_tween1 != null)
		{
			_tween1.active = false;
		}
		if (_tween2 != null)
		{
			_tween2.active = false;
		}
		groundZ = targetGroundZ;
		z = targetGroundZ;
	}

	public function setAlive(alive:Bool):Void
	{
		_bodySprite.alive = alive;
		_headSprite.alive = alive;
		_targetSprite.alive = alive;
		_soulSprite.alive = alive;
	}

	public function isMale():Bool
	{
		return CRITTER_GENDERS[myId % CRITTER_GENDERS.length] < _critterColor.malePercent;
	}

	public static function initialize(?whichCritters:Int = 0)
	{
		// reset static id; some code depends on static ids starting at 0
		STATIC_ID = 0;

		CritterBody.IDLE_FREQUENCY = [0, 500, 290, 170, 100, 60, 35, 20][PlayerData.pegActivity];
		CritterBody.IDLE_FREQUENCY = Math.min(CritterBody.IDLE_FREQUENCY, 500);
		CritterBody.IDLE_FREQUENCY = Math.max(CritterBody.IDLE_FREQUENCY, 20);
		LevelState.GLOBAL_IDLE_FREQUENCY = [0, 300, 200, 100, 60, 40, 30, 20][PlayerData.pegActivity];
		LevelState.GLOBAL_SEXY_FREQUENCY = [0, 1213, 813, 513, 313, 213, 113, 13][PlayerData.pegActivity];
		CritterBody.DEFAULT_WALK_SPEED = [0, 105, 115, 125, 135, 150, 165, 185][PlayerData.pegActivity];

		CRITTER_GENDERS = [];
		for (i in 0...22)
		{
			CRITTER_GENDERS.push((i + 0.5) / 22);
		}
		FlxG.random.shuffle(CRITTER_GENDERS);

		CRITTER_COLORS = [];
		CRITTER_COLORS.push({tint:[
								 CCL_SKIN => 0xffb23823,
								 CCL_SKIN_SHADOW => 0xff9e301e,
								 CCL_SKIN_LINE => 0xff8d2b1d,
								 CCL_BELLY => 0xffc9442a,
								 CCL_BELLY_SHADOW => 0xffad3726,
								 CCL_BELLY_LINE => 0xff963027,
								 CCL_EYES => 0xff282828,
								 CCL_EYES_LINE => 0xff525050,
								 CCL_EYES_SHINE => 0xffdedede,
							 ], english:"red", englishBackup:FJ_RED_DK, malePercent:0.6
							});
		CRITTER_COLORS.push({tint:[
								 CCL_SKIN => 0xffeeda4d,
								 CCL_SKIN_SHADOW => 0xffe8c640,
								 CCL_SKIN_LINE => 0xffd2b137,
								 CCL_BELLY => 0xfff7f0cc,
								 CCL_BELLY_SHADOW => 0xfff1e398,
								 CCL_BELLY_LINE => 0xffe3cd6d,
								 CCL_EYES => 0xffc0992f,
								 CCL_EYES_LINE => 0xffa27325,
								 CCL_EYES_SHINE => 0xfff1e398,
							 ], english:"yellow", englishBackup:FJ_YEL, malePercent:0.5
							});
		CRITTER_COLORS.push({tint:[
								 CCL_SKIN => 0xff41a740,
								 CCL_SKIN_SHADOW => 0xff30942b,
								 CCL_SKIN_LINE => 0xff22851d,
								 CCL_BELLY => 0xff4fa94e,
								 CCL_BELLY_SHADOW => 0xff3d9737,
								 CCL_BELLY_LINE => 0xff2d8827,
								 CCL_EYES => 0xffc09a2f,
								 CCL_EYES_LINE => 0xffa27325,
								 CCL_EYES_SHINE => 0xfff1e398,
							 ], english:"green", englishBackup:FJ_GREN_DK, malePercent:0.5
							});
		CRITTER_COLORS.push({tint:[
								 CCL_SKIN => 0xffb47922,
								 CCL_SKIN_SHADOW => 0xff9f6621,
								 CCL_SKIN_LINE => 0xff925621,
								 CCL_BELLY => 0xffd0ec5c,
								 CCL_BELLY_SHADOW => 0xffa8d359,
								 CCL_BELLY_LINE => 0xff93a944,
								 CCL_EYES => 0xff7d4c21,
								 CCL_EYES_LINE => 0xff603e21,
								 CCL_EYES_SHINE => 0xffe5cd7d,
							 ], english:"brown", englishBackup:FJ_BRWN, malePercent:0.5
							});
		CRITTER_COLORS.push({tint:[
								 CCL_SKIN => 0xff6f83db,
								 CCL_SKIN_SHADOW => 0xff6175c7,
								 CCL_SKIN_LINE => 0xff5164b0,
								 CCL_BELLY => 0xff92d8e5,
								 CCL_BELLY_SHADOW => 0xff9acada,
								 CCL_BELLY_LINE => 0xff72accf,
								 CCL_EYES => 0xff374265,
								 CCL_EYES_LINE => 0xff495788,
								 CCL_EYES_SHINE => 0xffeaf2f4,
							 ], english:"blue", englishBackup:FJ_BLUE_LT, malePercent:0.5
							});
		CRITTER_COLORS.push({tint:[
								 CCL_SKIN => 0xffa854cb,
								 CCL_SKIN_SHADOW => 0xff974ab8,
								 CCL_SKIN_LINE => 0xff8641a5,
								 CCL_BELLY => 0xffbb73dd,
								 CCL_BELLY_SHADOW => 0xffa15cc9,
								 CCL_BELLY_LINE => 0xff8e4bba,
								 CCL_EYES => 0xff4fa94e,
								 CCL_EYES_LINE => 0xff438b35,
								 CCL_EYES_SHINE => 0xffdbe28e,
							 ], english:"purple", englishBackup:FJ_PRPL, malePercent:0.4
							});

		if (whichCritters == LOAD_ALL || whichCritters == LOAD_DEFAULT && ItemDatabase.playerHasItem(ItemDatabase.ITEM_FRUIT_BUGS))
		{
			CRITTER_COLORS.push({tint:[
									 CCL_SKIN => 0xfff57e7d,
									 CCL_SKIN_SHADOW => 0xffed6568,
									 CCL_SKIN_LINE => 0xffd85650,
									 CCL_BELLY => 0xfff57e7d,
									 CCL_BELLY_SHADOW => 0xffed6568,
									 CCL_BELLY_LINE => 0xffd85650,
									 CCL_EYES => 0xff7ac252,
									 CCL_EYES_LINE => 0xffb8db92,
									 CCL_EYES_SHINE => 0xffe9f4dc,
								 ], english:"red", englishBackup:FJ_RED_LT, malePercent:0.5
								});
			CRITTER_COLORS.push({tint:[
									 CCL_SKIN => 0xfff9bb4a,
									 CCL_SKIN_SHADOW => 0xfff9984b,
									 CCL_SKIN_LINE => 0xffeb8844,
									 CCL_BELLY => 0xfffff4b2,
									 CCL_BELLY_SHADOW => 0xfffdd28b,
									 CCL_BELLY_LINE => 0xffefae69,
									 CCL_EYES => 0xfff9a74c,
									 CCL_EYES_LINE => 0xfffee799,
									 CCL_EYES_SHINE => 0xfffff6df,
								 ], english:"orange", englishBackup:FJ_ORNG, malePercent:0.5
								});
			CRITTER_COLORS.push({tint:[
									 CCL_SKIN => 0xff8fea40,
									 CCL_SKIN_SHADOW => 0xff75d531,
									 CCL_SKIN_LINE => 0xff72c72f,
									 CCL_BELLY => 0xffe8fa95,
									 CCL_BELLY_SHADOW => 0xffc4ee7a,
									 CCL_BELLY_LINE => 0xff9ed84c,
									 CCL_EYES => 0xfff5d561,
									 CCL_EYES_LINE => 0xfff8ea9a,
									 CCL_EYES_SHINE => 0xfffcf3cd,
								 ], english:"green", englishBackup:FJ_GREN_LT, malePercent:0.5
								});
		}

		if (whichCritters == LOAD_ALL || whichCritters == LOAD_DEFAULT && ItemDatabase.playerHasItem(ItemDatabase.ITEM_MARSHMALLOW_BUGS))
		{
			CRITTER_COLORS.push({tint:[
									 CCL_SKIN => 0xfffeceef,
									 CCL_SKIN_SHADOW => 0xfffbb9e2,
									 CCL_SKIN_LINE => 0xfff5a8d5,
									 CCL_BELLY => 0xffffeffc,
									 CCL_BELLY_SHADOW => 0xfffcd2ed,
									 CCL_BELLY_LINE => 0xfff3badb,
									 CCL_EYES => 0xffffddf4,
									 CCL_EYES_LINE => 0xfffff4fc,
									 CCL_EYES_SHINE => 0xffffffff,
								 ], english:"pink", englishBackup:FJ_PINK, malePercent:0.1
								});
			CRITTER_COLORS.push({tint:[
									 CCL_SKIN => 0xffb1edee,
									 CCL_SKIN_SHADOW => 0xff9be5ec,
									 CCL_SKIN_LINE => 0xff8cdee8,
									 CCL_BELLY => 0xffdff2f0,
									 CCL_BELLY_SHADOW => 0xffbcedf0,
									 CCL_BELLY_LINE => 0xffa2e3eb,
									 CCL_EYES => 0xffc1f1f2,
									 CCL_EYES_LINE => 0xffe0f8f9,
									 CCL_EYES_SHINE => 0xffffffff,
								 ], english:"cyan", englishBackup:FJ_CYAN, malePercent:0.2
								});
			CRITTER_COLORS.push({tint:[
									 CCL_SKIN => 0xfff9f7d9,
									 CCL_SKIN_SHADOW => 0xfff6ebbf,
									 CCL_SKIN_LINE => 0xffefe0ae,
									 CCL_BELLY => 0xfff9f7d9,
									 CCL_BELLY_SHADOW => 0xfff6ebbf,
									 CCL_BELLY_LINE => 0xffefe0ae,
									 CCL_EYES => 0xff91e6ff,
									 CCL_EYES_LINE => 0xffc2f1ff,
									 CCL_EYES_SHINE => 0xffffffff,
								 ], english:"white", englishBackup:FJ_WHIT, malePercent:0.3
								});
		}

		if (whichCritters == LOAD_ALL || whichCritters == LOAD_DEFAULT && ItemDatabase.playerHasItem(ItemDatabase.ITEM_SPOOKY_BUGS))
		{
			CRITTER_COLORS.push({tint:[
									 CCL_SKIN => 0xff1a1a1e,
									 CCL_SKIN_SHADOW => 0xff050507,
									 CCL_SKIN_LINE => 0xff3c3c3d,
									 CCL_BELLY => 0xff1a1a1e,
									 CCL_BELLY_SHADOW => 0xff050507,
									 CCL_BELLY_LINE => 0xff3c3c3d,
									 CCL_EYES => 0xffb8260b,
									 CCL_EYES_LINE => 0xff880606,
									 CCL_EYES_SHINE => 0xfff45e40,
								 ], english:"black", englishBackup:FJ_BLAK, malePercent:0.9
								});
			CRITTER_COLORS.push({tint:[
									 CCL_SKIN => 0xff7a8289,
									 CCL_SKIN_SHADOW => 0xff6b7279,
									 CCL_SKIN_LINE => 0xff5c6169,
									 CCL_BELLY => 0xff7a8289,
									 CCL_BELLY_SHADOW => 0xff6b7279,
									 CCL_BELLY_LINE => 0xff5c6169,
									 CCL_EYES => 0xfff5f0d1,
									 CCL_EYES_LINE => 0xffcdcab7,
									 CCL_EYES_SHINE => 0xffffffff,
								 ], english:"grey", englishBackup:FJ_GREY, malePercent:0.8
								});
			CRITTER_COLORS.push({tint:[
									 CCL_SKIN => 0xff0b45a6,
									 CCL_SKIN_SHADOW => 0xff053691,
									 CCL_SKIN_LINE => 0xff04277c,
									 CCL_BELLY => 0xff0b45a6,
									 CCL_BELLY_SHADOW => 0xff053691,
									 CCL_BELLY_LINE => 0xff04277c,
									 CCL_EYES => 0xfffad541,
									 CCL_EYES_LINE => 0xfffdf7a9,
									 CCL_EYES_SHINE => 0xffffffff,
								 ], english:"blue", englishBackup:FJ_BLUE_DK, malePercent:0.7
								});
		}
	}

	/**
	 * Each puzzle or minigame uses a subset of the available colors. This
	 * function randomizes the colors we use.
	 *
	 * @param	seed optional seed when consistent colors are needed
	 */
	public static function shuffleCritterColors(?seed:Null<Int>)
	{
		if (seed == null)
		{
			/*
			 * These color arrangements are aesthetically pleasing, and include
			 * things like blues and greys together, or primary colors. We try
			 * to avoid giving the player combinations of colors which are
			 * really ugly or frustratingly similar
			 *
			 * FJ_RED_DK, FJ_YEL, FJ_GREN_DK, FJ_BRWN, LIGHT_BLUE, FJ_PRPL,
			 * FJ_RED_LT, FJ_ORNG, FJ_GREN_LT,
			 * FJ_PINK, FJ_CYAN, FJ_WHIT,
			 * FJ_BLAK, FJ_GREY, FJ_BLUE_DK,
			 */
			var COLOR_ARRANGEMENTS:Array<Array<String>> = [
						// marshmallow arrangements
						[FJ_RED_DK, FJ_BLUE_LT, FJ_PRPL, FJ_PINK, FJ_CYAN, FJ_WHIT,],
						[FJ_YEL, FJ_GREN_DK, FJ_BLUE_LT, FJ_PRPL, FJ_CYAN, FJ_WHIT,],
						[FJ_RED_DK, FJ_YEL, FJ_GREN_DK, FJ_BRWN, FJ_PINK, FJ_CYAN,],
						// spooky arrangements
						[FJ_RED_DK, FJ_GREN_DK, FJ_BRWN, FJ_PRPL, FJ_BLAK, FJ_BLUE_DK,],
						[FJ_RED_DK, FJ_GREN_DK, FJ_BLUE_LT, FJ_PRPL, FJ_GREY, FJ_BLUE_DK,],
						[FJ_RED_DK, FJ_YEL, FJ_GREN_DK, FJ_BRWN, FJ_BLAK, FJ_GREY,],
						// fruity arrangements
						[FJ_YEL, FJ_BRWN, FJ_PRPL, FJ_RED_LT, FJ_ORNG, FJ_GREN_LT,],
						[FJ_YEL, FJ_GREN_DK, FJ_BLUE_LT, FJ_PRPL, FJ_RED_LT, FJ_ORNG,],
						[FJ_RED_DK, FJ_GREN_DK, FJ_BRWN, FJ_PRPL, FJ_ORNG, FJ_GREN_LT, ],
						// spectrums with two different bug packs...
						[FJ_YEL, FJ_RED_LT, FJ_ORNG, FJ_GREN_LT,FJ_PINK, FJ_CYAN, ],
						[FJ_YEL, FJ_GREN_DK, FJ_BRWN, FJ_ORNG, FJ_BLAK, FJ_BLUE_DK,],
						[FJ_RED_DK, FJ_YEL, FJ_BRWN, FJ_ORNG, FJ_BLAK, FJ_GREY,],
						[FJ_YEL, FJ_GREN_DK, FJ_BLUE_LT, FJ_GREN_LT, FJ_CYAN, FJ_WHIT,],
						[FJ_RED_DK, FJ_CYAN, FJ_WHIT, FJ_BLAK, FJ_GREY, FJ_BLUE_DK,],
						[FJ_PRPL, FJ_PINK, FJ_CYAN, FJ_WHIT, FJ_BLAK, FJ_BLUE_DK, ],
						// arrangements with three different bug packs...
						[FJ_RED_DK, FJ_YEL, FJ_BRWN, FJ_ORNG, FJ_GREN_LT,FJ_CYAN, ],
						[FJ_GREN_DK, FJ_PRPL,FJ_RED_LT, FJ_PINK, FJ_BLAK, FJ_BLUE_DK,],
						[FJ_BRWN, FJ_ORNG, FJ_CYAN, FJ_WHIT, FJ_BLAK, FJ_BLUE_DK,],
						[FJ_RED_DK, FJ_BLUE_LT, FJ_PRPL, FJ_PINK, FJ_CYAN, FJ_BLUE_DK,],
						[FJ_PRPL, FJ_ORNG, FJ_GREN_LT, FJ_CYAN, FJ_BLAK, FJ_GREY,],
						[FJ_GREN_DK, FJ_PRPL, FJ_RED_LT, FJ_CYAN, FJ_WHIT, FJ_BLUE_DK,],
						[FJ_YEL, FJ_BRWN, FJ_ORNG, FJ_WHIT, FJ_BLAK, FJ_GREY,],
						[FJ_YEL, FJ_GREN_DK, FJ_BLUE_LT, FJ_RED_LT, FJ_PINK, FJ_GREY,],
						[FJ_RED_DK, FJ_GREN_DK, FJ_RED_LT, FJ_GREN_LT, FJ_PINK, FJ_GREY,],
					];
			var colorArrangements:Array<Array<String>> = COLOR_ARRANGEMENTS.copy();
			{
				var i = colorArrangements.length - 1;
				while (i >= 0)
				{
					for (englishBackup in colorArrangements[i])
					{
						if (getColorFromBackupString(englishBackup) == null || PlayerData.disabledPegColors.indexOf(englishBackup) != -1)
						{
							// we're missing a color for this arrangement
							colorArrangements.remove(colorArrangements[i]);
							break;
						}
					}
					i--;
				}
			}
			BetterFlxRandom.shuffle(CRITTER_COLORS);

			// move disabled colors to end of the queue
			var i:Int = CRITTER_COLORS.length - 1;
			while (i >= 0)
			{
				var color:CritterColor = CRITTER_COLORS[i];
				if (PlayerData.disabledPegColors.indexOf(color.englishBackup) != -1)
				{
					// color is disabled... move it to the end of CRITTER_COLORS
					CRITTER_COLORS.remove(color);
					CRITTER_COLORS.push(color);
				}
				i--;
			}

			// # of arrangements increases from 0 => 3 => 8 => 22, as player purchases bug packs
			var arrangementChance:Float = FlxMath.bound(8 * colorArrangements.length, 0, 80);
			if (colorArrangements.length >= 1 && FlxG.random.bool(arrangementChance))
			{
				// pick a color arrangement
				var selectedArrangement:Array<String> = FlxG.random.getObject(colorArrangements).copy();
				BetterFlxRandom.shuffle(selectedArrangement);
				for (englishBackup in selectedArrangement)
				{
					var color:CritterColor = getColorFromBackupString(englishBackup);
					CRITTER_COLORS.remove(color);
					CRITTER_COLORS.insert(0, color);
				}
			}
		}
		else
		{
			Puzzle.PUZZLE_RANDOM = new FlxRandom(seed);
			Puzzle.shuffle(CRITTER_COLORS);
			Puzzle.PUZZLE_RANDOM = FlxG.random;
		}
	}

	/**
	 * Used during tutorials for commands such as %holopad-state-blue-0100%
	 */
	public static function getColorIndexFromString(fromStr:String):Int
	{
		for (i in 0...Critter.CRITTER_COLORS.length)
		{
			if (Critter.CRITTER_COLORS[i].english == fromStr)
			{
				return i;
			}
		}
		return -1;
	}

	static private function getColorFromBackupString(fromStr:String):CritterColor
	{
		for (critterColor in CRITTER_COLORS)
		{
			if (critterColor.englishBackup == fromStr)
			{
				return critterColor;
			}
		}
		return null;
	}

	public function neverIdle()
	{
		this._bodySprite._idleTimer = 9999999999;
	}

	public function getColorIndex():Int
	{
		return CRITTER_COLORS.indexOf(_critterColor);
	}

	public function isIdle()
	{
		if (_bodySprite.animation.name != "idle")
		{
			return false;
		}
		if (_targetSprite.immovable)
		{
			return false;
		}
		if (_eventStack._alive)
		{
			/*
			 * This critter has events scheduled. Don't report this critter as
			 * idle, or we might schedule conflicting events
			 */
			return false;
		}
		return true;
	}

	public function setFrontBodySpriteOffset(offset:Float)
	{
		_frontBodySpriteOffset = offset;
		_frontBodySprite.offset.set(14, _bodySpriteOffset + _frontBodySpriteOffset + z);
	}

	public function setBodySpriteOffset(offset:Float)
	{
		_bodySpriteOffset = offset;
		_bodySprite.offset.set(14, _bodySpriteOffset + z);
		_headSprite.offset.set(14, _bodySpriteOffset + z + 2);
		_frontBodySprite.offset.set(14, _bodySpriteOffset + _frontBodySpriteOffset + z);
	}

	public function resetFrontBodySprite()
	{
		if (_frontBodySprite.animation.name != "idle")
		{
			_frontBodySprite.animation.play("idle");
			_frontBodySprite.visible = false;
		}
		if (_frontBodySpriteOffset != 4)
		{
			setFrontBodySpriteOffset(4);
		}
		if (_bodySpriteOffset != 39)
		{
			setBodySpriteOffset(39);
		}
	}

	public function isMidAir():Bool
	{
		return z != groundZ;
	}

	public function stop()
	{
		_targetSprite.x = _soulSprite.x;
		_targetSprite.y = _soulSprite.y;
		_bodySprite._walkSpeed = CritterBody.DEFAULT_WALK_SPEED;
		_bodySprite._jumpSpeed = CritterBody.DEFAULT_JUMP_SPEED;
	}

	public function toString()
	{
		return "Critter #" + myId + " (" + _critterColor.english + ")";
	}
}

typedef CritterColor =
{
	tint:Map<FlxColor, FlxColor>,
	malePercent:Float,
	english:String,
	englishBackup:String // if the english name is ambiguous, this specifies an alternate name
}

class RunToWaypoint
{
	var x:Float = 0;
	var y:Float = 0;
	var callback:Critter->Void;

	public function new(x:Float, y:Float, callback:Critter->Void)
	{
		this.x = x;
		this.y = y;
		this.callback = callback;
	}

	public function reachedWaypoint(critter:Critter)
	{
		critter.runTo(x, y, callback);
	}
}