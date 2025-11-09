package credits;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import kludge.FlxSoundKludge;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * This is an FlxState which makes it look like the game has crashed, producing
 * some weird graphical artifacts, a fake stack trace, and a very annoying
 * noise
 *
 * It's used towards the end of the game if you make Abra really, really angry
 */
class FakeCrash extends FlxState
{
	private var bg:FlxSprite;
	private var screenshot:FlxSprite;
	private var stackTrace:FlxText;
	private var eventStack:EventStack;

	public function new(screenshot:FlxSprite = null)
	{
		super();
		this.screenshot = screenshot;
	}

	override public function destroy():Void
	{
		super.destroy();

		bg = FlxDestroyUtil.destroy(bg);
		screenshot = FlxDestroyUtil.destroy(screenshot);
		stackTrace = FlxDestroyUtil.destroy(stackTrace);
		eventStack = null;
	}

	override public function create():Void
	{
		super.create();

		Main.overrideFlxGDefaults();
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;

		if (screenshot == null)
		{
			screenshot = new FlxSprite(0, 0, AssetPaths.shop_bg__png);
		}

		bg = new FlxSprite(0, 0);
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE, true);
		bg.stamp(screenshot, 200, 0);
		bg.stamp(screenshot, 200 - FlxG.width, 0);
		bg.pixels.colorTransform(new Rectangle(0, 0, FlxG.width, FlxG.height), new ColorTransform(1, 0, 1));
		bg.dirty = true;
		add(bg);

		stackTrace = new FlxText(0, 0, 0,
		"TypeError: Error #1009: Cannot access a property or method oU+0066 a null object reU+0066erence.\n" +
		"  at puzzle::PuzzleState/create()[D:\\workspace\\MonsterMind\\source\\puzzle\\PuzzleState.hx:33]\n" +
		"  at U+0066lixel::U+0046lxGame/switchState()[C:\\HaxeToolkit\\haxe\\lib\\U+0066lixel\\4,3,0\\U+0066lixel\\U+0046lxGame.hx:627]\n" +
		"  at U+0066lixel::U+0046lxGame/create()[C:\\HaxeToolkit\\haxe\\lib\\U+0066lixel\\4,3,0\\U+0066lixel\\U+0046lxGame.hx:352]\n" +
		"  at U+0066lash.display::DisplayObjectContainer/addChild()\n" +
		"  at Main/setupGame()[D:\\workspace\\MonsterMind\\source\\Main.hx:99]\n" +
		"  at Main/init()[D:\\workspace\\MonsterMind\\source\\Main.hx:77]\n" +
		"  at U+0066lash.display::DisplayObjectContainer/addChild()\n" +
		"  at Main$/main()[D:\\workspace\\MonsterMind\\source\\Main.hx:53]\n" +
		"  at U+0046unction/http://adobe.com/AS3/2006/builtin::apply()\n" +
		"  at U+0046unction/<anonymous>()", 32);
		stackTrace.color = FlxColor.BLACK;
		add(stackTrace);

		add(new FlxSprite());
		add(new FlxSprite(200, 200));

		eventStack = new EventStack();
		eventStack.addEvent({time:eventStack._time + 25.0, callback:switchStateEvent});

		FlxSoundKludge.play(AssetPaths.abra_talk__wav, 0.08, true);
	}

	public function switchStateEvent(args:Array<Dynamic>):Void
	{
		FlxG.switchState(new MainMenuState());
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		eventStack.update(elapsed);
	}

	public static function newInstance():FakeCrash
	{
		var screenshot = Screenshot.get();

		return new FakeCrash(screenshot);
	}
}