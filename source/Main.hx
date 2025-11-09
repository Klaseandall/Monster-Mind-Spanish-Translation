package;

import flixel.system.scaleModes.BaseScaleMode;
import poke.magn.MagnSexyState;
import poke.abra.AbraSexyState;
import lime.tools.SplashScreen;
import credits.CreditsState;
import demo.SexyDebugState;
import demo.TeaserTextState;
import demo.TextEntryDemo;
import flash.Lib;
import flash.display.Sprite;
import flash.events.Event;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import openfl.display.StageQuality;
import poke.abra.AbraResource;
import poke.buiz.BuizelResource;
import poke.buiz.BuizelSexyState;
import poke.grim.GrimerResource;
import poke.grov.GrovyleResource;
import poke.grov.GrovyleSexyState;
import poke.hera.HeraResource;
import poke.hera.HeraSexyState;
import poke.kecl.KecleonResource;
import poke.luca.LucarioResource;
import poke.luca.LucarioSexyState;
import poke.magn.MagnResource;
import poke.rhyd.RhydonResource;
import poke.sand.SandslashResource;
import poke.sand.SandslashSexyState;
import poke.smea.SmeargleResource;
import poke.smea.SmeargleSexyState;
import puzzle.PuzzleState;

/**
 * The main class which is invoked to start the rest of the game. Includes
 * logic for one-time setup such as initializing sprites and configuring
 * the HaxeFlixel framework.
 */
class Main extends Sprite
{
	public static var VERSION_STRING:String = "1.10.7-UNSTABLE";
	public static var gameWidth:Int = 768; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	public static var gameHeight:Int = 432; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).	

	var initialState:Class<FlxState> = SplashScreenState; // The FlxState the game starts with.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	public static function main():Void
	{
		#if redirectTraces
		FlxG.log.redirectTraces = true;
		#end
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		// Pixelly look is good for the game, but makes the debugger look bad
		#if !FLX_DEBUG
		FlxG.stage.quality = StageQuality.LOW;
		#end

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		var ratioX:Float = stageWidth / gameWidth;
		var ratioY:Float = stageHeight / gameHeight;
		var zoom:Float = Math.min(ratioX, ratioY);
		
		// android lock resolution
		#if android
		addChild(new FlxGame(gameWidth, gameHeight, initialState, framerate, framerate, skipSplash, startFullscreen));
		#else
		gameWidth = Math.ceil(stageWidth / zoom);
		gameHeight = Math.ceil(stageHeight / zoom);

		addChild(new FlxGame(gameWidth, gameHeight, initialState, framerate, framerate, skipSplash, startFullscreen));
		#end
	}

	/**
	 * These need to be called after FlxG.reset(), or they get overwritten
	 */
	public static function overrideFlxGDefaults():Void
	{
		FlxG.fixedTimestep = false;
		FlxG.autoPause = false;
		FlxG.sound.muteKeys = null;

		PlayerSave.flush();

		AbraResource.initialize();
		HeraResource.initialize();
		BuizelResource.initialize();
		GrovyleResource.initialize();
		SandslashResource.initialize();
		RhydonResource.initialize();
		SmeargleResource.initialize();
		KecleonResource.initialize();
		MagnResource.initialize();
		GrimerResource.initialize();
		LucarioResource.initialize();

		FlxTransitionableState.defaultTransIn = new TransitionData(TransitionType.NONE);
		FlxTransitionableState.defaultTransOut = new TransitionData(TransitionType.NONE);

		if (PlayerData.clickTime == 0)
		{
			PlayerData.clickTime = MmTools.time();
		}

		CursorUtils.initializeSystemCursor();
	}
}
