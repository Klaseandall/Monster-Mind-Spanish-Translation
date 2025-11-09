package credits;

import MmStringTools.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import poke.abra.AbraDialog;

/**
 * After swapping, there is a scene where Abra contacts you when she is now a
 * glove, and you talk about how things are going. This is the FlxState which
 * encompasses that scene.
 */
class GloveWakeUpState extends FlxTransitionableState
{
	private var _dialogTree:DialogTree;
	public var _dialogger:Dialogger;
	private var _pokeWindow:GloveWindow;
	private var _eventStack:EventStack = new EventStack();
	private var _deadGlove:FlxSprite;
	private var _words:FlxSprite;

	public function new(?TransIn:TransitionData, ?TransOut:TransitionData)
	{
		super(TransIn, TransOut);
	}

	override public function create():Void
	{
		Main.overrideFlxGDefaults();
		super.create();
		bgColor = 0xFF365B83;

		var bg:FlxSprite = new FlxSprite(0, 0, AssetPaths.glovechat_bg__png);
		add(bg);

		_deadGlove = new FlxSprite(0, 0, AssetPaths.glovechat_deadglove__png);
		_deadGlove.pixels.threshold(_deadGlove.pixels, new Rectangle(0, 0, _deadGlove.pixels.width, _deadGlove.pixels.height), new Point(0, 0), '==', 0xffffffff, PlayerData.cursorFillColor);
		_deadGlove.pixels.threshold(_deadGlove.pixels, new Rectangle(0, 0, _deadGlove.pixels.width, _deadGlove.pixels.height), new Point(0, 0), '==', 0xff000000, PlayerData.cursorLineColor);
		_deadGlove.alpha = PlayerData.cursorMaxAlpha;
		add(_deadGlove);

		_words = new FlxSprite(0, 0, AssetPaths.glovechat_words__png);
		_words.alpha = 0;
		add(_words);

		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;

		_pokeWindow = new GloveWindow();
		_pokeWindow.visible = false;
		add(_pokeWindow);

		_dialogger = new Dialogger();
		add(_dialogger);

		_eventStack.addEvent({time:_eventStack._time + 0.8, callback:eventWordsAlpha, args:[1.0]});
		_eventStack.addEvent({time:_eventStack._time + 3.8, callback:eventWordsAlpha, args:[0.0]});
		_eventStack.addEvent({time:_eventStack._time + 4.0, callback:eventLaunchDialog});
	}

	override public function destroy():Void
	{
		super.destroy();

		_dialogTree = FlxDestroyUtil.destroy(_dialogTree);
		_dialogger = FlxDestroyUtil.destroy(_dialogger);
		_pokeWindow = FlxDestroyUtil.destroy(_pokeWindow);
		_eventStack = null;
		_deadGlove = FlxDestroyUtil.destroy(_deadGlove);
		_words = FlxDestroyUtil.destroy(_words);
	}

	public function eventWordsAlpha(args:Array<Dynamic>):Void
	{
		var newAlpha:Float = args[0];
		FlxTween.tween(_words, {alpha: newAlpha}, 0.4);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		_eventStack.update(elapsed);
	}

	public function dialogTreeCallback(Msg:String):String
	{
		if (StringTools.startsWith(Msg, "%fun-"))
		{
			/*
			 * Dialog strings like %fun-nude2% have an effect on a
			 * PokemonWindow instance. PokemonWindow subclasses can override
			 * the doFun method to define special behavior, such as taking off
			 * a Pokemon's hat, having them give a thumbs up or make a silly
			 * face.
			 */
			var funStr:String = substringBetween(Msg, "%fun-", "%");
			if (funStr != null)
			{
				_pokeWindow.doFun(funStr);
			}
		}
		if (Msg == "%fun-alpha1%")
		{
			_deadGlove.visible = false;
		}
		if (Msg == "")
		{
			_pokeWindow.visible = false;
			_eventStack.addEvent({time:_eventStack._time + 1.4, callback:eventExit});
		}
		return null;
	}

	public function eventLaunchDialog(args:Array<Dynamic>)
	{
		_pokeWindow.visible = true;
		_dialogTree = new DialogTree(_dialogger, AbraDialog.gloveWakeUp(), dialogTreeCallback);
		_dialogTree.go();
	}

	public function eventExit(args:Array<Dynamic>)
	{
		transOut = MainMenuState.fadeOutSlow();
		FlxG.switchState(new MainMenuState(MainMenuState.fadeInFast()));
	}
}