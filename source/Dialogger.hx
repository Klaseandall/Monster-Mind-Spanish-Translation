package;

import kludge.BetterFlxTypeText;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import poke.abra.AbraResource;
import poke.buiz.BuizelResource;
import flash.display.BlendMode;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.math.FlxMath;
import flixel.util.FlxSpriteUtil;
import poke.grim.GrimerResource;
import poke.grov.GrovyleResource;
import poke.hera.HeraResource;
import poke.luca.LucarioResource;
import poke.magn.MagnResource;
import poke.rhyd.RhydonResource;
import poke.sand.SandslashResource;
import poke.sexy.SexyState;

/**
 * Graphics and behavior for the onscreen dialog. This includes sprites and
 * logic for the Pokemon face, the dialog they're saying, the player's choices
 * and the skip button.
 *
 * This class only knows how to show a single dialog event and invoke
 * callbacks; it does not have any logic about going through an entire
 * sequential set of dialog.
 */
class Dialogger extends FlxGroup
{
	public static var SKIP:Int = -99;
	private static var MAX_CLICK_TIME:Float = 0.35;
	// a message has to be finished for a quarter second before you can skip it
	private static var MIN_ADVANCE_TIME:Float = 0.25;
	private static var PADDING:Int = 12;

	private var _replacedText:Map<String, String> = new Map<String, String>();

	private var _characterRect:RoundedRectangle;
	private var _character:FlxSprite;
	private var _gloveSprite:FlxSprite;
	public var _textRect:RoundedRectangle;
	private var _typeText:BetterFlxTypeText;
	public var _state:Dynamic;
	private var _selectedChoiceRect:FlxSprite;
	private var _promptGroup:FlxTypedGroup<FlxSprite>;
	private var _skipButton:FlxButton;

	// should be arrays
	var _promptTexts:Array<FlxText>;
	var _promptRectangles:Array<RoundedRectangle>;
	// user must click and hold to make a choice
	var _mouseHoldTime:Float = 0;
	// we ignore clicks if they're less than a tenth of a second apart
	var _clickEnableTimer:Float = 0;
	// we don't let the user advance text unless it's been a half second or so
	var _advanceEnableTimer:Float = -MIN_ADVANCE_TIME;
	var _prompts:Array<String> = new Array<String>();
	var _completeCallback:Dynamic;
	public var _handledClick:Bool = false;
	public var _clickEnabled:Bool = true;
	var _skipEnabled:Bool = true;
	public var _promptsYOffset:Int = 0;
	public var _promptsDontCoverClues:Bool = false;
	public var _promptsDontCover7PegClues:Bool = false;

	// when paused
	public var _canDismiss:Bool = true;
	public var _promptsTransparent:Bool = false;
	private var clickedPromptRectangle:RoundedRectangle;

	/**
	 * debug flag can be enabled to trace through state-based glitches, like
	 * if the dialogger is reacting to mouse clicks when it shouldn't, things
	 * like that
	 */
	private var debug:Bool = false;
	private var debugText:FlxText = null;

	public function new()
	{
		super();

		_characterRect = new RoundedRectangle();
		_characterRect.visible = false;
		_characterRect.relocate(3, FlxG.height - 78, 77, 75, 0xff000000, 0xeeffffff);
		add(_characterRect);

		_character = new FlxSprite(_characterRect.x + 2, _characterRect.y + 2);
		_character.visible = false;
		add(_character);

		_textRect = new RoundedRectangle();
		_textRect.visible = false;
		_textRect.relocate(82, FlxG.height - 78, FlxG.width - 85, 75, 0xff000000, 0xeeffffff);
		add(_textRect);

		_typeText = new BetterFlxTypeText(_textRect.x + 4, _textRect.y - 1, FlxG.width - 106 - 8, "", 20);
		_typeText.visible = false;
		_typeText.color = FlxColor.BLACK;
		_typeText.font = AssetPaths.hardpixel__otf;
		add(_typeText);

		_promptGroup = new FlxTypedGroup<FlxSprite>();
		add(_promptGroup);
		_promptTexts = [];
		_promptRectangles = [];

		_selectedChoiceRect = new FlxSprite();
		_selectedChoiceRect.visible = false;
		_selectedChoiceRect.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE, true);
		#if flash
		_selectedChoiceRect.blend = BlendMode.INVERT;
		add(_selectedChoiceRect);
		#else
		_promptGroup.add(_selectedChoiceRect);
		#end

		_skipButton = SexyState.newBackButton(skip, AssetPaths.skip_button__png);
		_skipButton.y -= 76;
		_skipButton.x += 2;
		_skipButton.visible = false;
		add(_skipButton);

		if (debug)
		{
			var debugSize:Int = 16;
			debugText = new FlxText(-10, FlxG.height - debugSize - 10, FlxG.width, "null", debugSize);
			debugText.color = FlxColor.GREEN;
			debugText.alignment = "right";
			add(debugText);
		}

		setReplacedText("<name>", PlayerData.name);
		setState(null, null);
	}

	private function setState(state:Dynamic, stateDesc:String)
	{
		_state = state;
		if (debug)
		{
			trace("state=" + stateDesc);
			debugText.text = (stateDesc == null ? "null" : stateDesc);
		}
	}

	public function skip():Void
	{
		if (_canDismiss)
		{
			_promptsDontCoverClues = false;
			_promptsDontCover7PegClues = false;

			_typeText.completeCallback = null;
			_typeText.skip();
			dismissDialog(SKIP);
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		_replacedText = null;
		_characterRect = FlxDestroyUtil.destroy(_characterRect);
		_character = FlxDestroyUtil.destroy(_character);
		_gloveSprite = FlxDestroyUtil.destroy(_gloveSprite);
		_textRect = FlxDestroyUtil.destroy(_textRect);
		_typeText = FlxDestroyUtil.destroy(_typeText);
		_state = null;
		_selectedChoiceRect = FlxDestroyUtil.destroy(_selectedChoiceRect);
		_promptGroup = FlxDestroyUtil.destroy(_promptGroup);
		_skipButton = FlxDestroyUtil.destroy(_skipButton);
		_promptTexts = FlxDestroyUtil.destroyArray(_promptTexts);
		_promptRectangles = FlxDestroyUtil.destroyArray(_promptRectangles);
		_prompts = null;
		_completeCallback = null;
		debugText = FlxDestroyUtil.destroy(debugText);
		clickedPromptRectangle = FlxDestroyUtil.destroy(clickedPromptRectangle);
	}

	override public function update(elapsed:Float):Void
	{
		if (_state == paused)
		{
			// don't update, don't increment timers, don't do anything
			return;
		}
		super.update(elapsed);
		_handledClick = false;
		_clickEnableTimer += elapsed;

		if (_state != null && !_skipButton.pressed)
		{
			_state(elapsed);
		}
		if (_skipButton.visible && FlxG.mouse.justPressed && _skipButton.pressed)
		{
			_handledClick = true;
		}
	}

	public function showingDialog(elapsed:Float):Void
	{
		if (FlxG.mouse.justPressed && _clickEnableTimer >= 0 && _clickEnabled)
		{
			_handledClick = true;
			_clickEnableTimer = -0.1;
			_typeText.skip();
		}
	}

	public function setSkipEnabled(enabled:Bool):Void
	{
		_skipEnabled = enabled;
	}

	public function skippedDialog(elapsed:Float):Void
	{
	}

	public function isPrompting():Bool
	{
		return _state == promptingDialog;
	}

	public function promptingDialog(elapsed:Float):Void
	{
		var oldChoiceIndex:Int = _promptRectangles.indexOf(clickedPromptRectangle);
		if (FlxG.mouse.justPressed && _clickEnableTimer >= 0 && _clickEnabled)
		{
			_handledClick = true;
			_clickEnableTimer = -0.1;
			_selectedChoiceRect.visible = true;
			clickedPromptRectangle = findClickedPromptRectangle();
		}
		var choiceIndex:Int = _promptRectangles.indexOf(clickedPromptRectangle);
		if (FlxG.mouse.pressed && _selectedChoiceRect.visible && clickedPromptRectangle != null)
		{
			_mouseHoldTime += elapsed;

			FlxSpriteUtil.fill(_selectedChoiceRect, FlxColor.TRANSPARENT);
			var maxWidth = clickedPromptRectangle.width - 4;
			var width = Math.min(maxWidth, maxWidth * _mouseHoldTime / MAX_CLICK_TIME);
			var selectedChoiceRectColor = FlxColor.BLACK;
			#if flash
			selectedChoiceRectColor = FlxColor.WHITE;
			#else
			// BlendMode.INVERT is not supported by non-flash targets, so we use grey text in front of a black
			// background, '_selectedChoiceRect'. We relocate the background sprite behind the selected text option.
			if (choiceIndex != oldChoiceIndex)
			{
				_promptGroup.remove(_selectedChoiceRect);
				_promptGroup.insert(_promptGroup.members.indexOf(clickedPromptRectangle) + 1, _selectedChoiceRect);
			}
			#end
			FlxSpriteUtil.drawRect(_selectedChoiceRect, Std.int(clickedPromptRectangle.x + 2), Std.int(clickedPromptRectangle.y + 2), Std.int(width), Std.int(clickedPromptRectangle.height - 4), selectedChoiceRectColor);

			if (_mouseHoldTime >= MAX_CLICK_TIME && _canDismiss)
			{
				dismissDialog(choiceIndex);
			}
		}
		else {
			_mouseHoldTime = 0;
			_selectedChoiceRect.visible = false;
		}

		#if !flash
		// BlendMode.INVERT is not supported by non-flash targets, so we use grey text in front of a black
		// background. We update the text color as the player clicks different options.
		if (clickedPromptRectangle != null)
		{
			if (choiceIndex < _promptTexts.length && _promptTexts[choiceIndex] != null)
			{
				_promptTexts[choiceIndex].color = _selectedChoiceRect.visible ? FlxColor.GRAY : FlxColor.BLACK;
			}
		}
		#end
	}

	/**
	 * Resets the dialogger's internal state, rendering all prompts and dialog
	 * invisible
	 */
	public function reset()
	{
		_mouseHoldTime = 0;
		_characterRect.visible = false;
		_character.visible = false;
		_textRect.visible = false;
		_typeText.visible = false;
		_selectedChoiceRect.visible = false;
		_skipButton.visible = false;
		_promptGroup.clear();
		_promptRectangles.splice(0, _promptRectangles.length);
		_promptTexts.splice(0, _promptTexts.length);
		if (_prompts != null)
		{
			_prompts.splice(0, _prompts.length);
		}
		setState(null, null);
	}

	public function dismissingDialog(elapsed:Float):Void
	{
		_advanceEnableTimer += elapsed;
		if (FlxG.mouse.justPressed && _clickEnableTimer >= 0 && _advanceEnableTimer >= 0 && _clickEnabled && _canDismiss)
		{
			_handledClick = true;
			dismissDialog(-1);
		}
	}

	private function findClickedPromptRectangle():RoundedRectangle
	{
		var closestRectangle:RoundedRectangle = null;
		var minDistance:Float = 10000;
		for (promptRectangle in _promptRectangles)
		{
			var distance:Float = distanceFromRectToMouse(new Rectangle(promptRectangle.x, promptRectangle.y, promptRectangle.width, promptRectangle.height));
			if (distance < minDistance)
			{
				minDistance = distance;
				closestRectangle = promptRectangle;
			}
		}
		return closestRectangle;
	}

	function dismissDialog(result:Int):Void
	{
		_clickEnableTimer = -0.1;
		_advanceEnableTimer = -MIN_ADVANCE_TIME;
		reset();
		if (_completeCallback != null)
		{
			_completeCallback(result);
		}
	}

	function setVisible(visible:Bool):Void
	{
		for (member in members)
		{
			if (member == null)
			{
				continue;
			}
			if (Std.isOfType(member, FlxSprite))
			{
				var memberSprite:FlxSprite = cast member;
				memberSprite.visible = visible;
			}
		}
		_selectedChoiceRect.visible = false;
		if (_skipButton.visible && !_skipEnabled)
		{
			_skipButton.visible = false;
		}
	}

	/**
	 * Distance from rectangle to mouse. Returns 0 for any point within the rectangle.
	 */
	public function distanceFromRectToMouse(rect:Rectangle):Float
	{
		var minDist:Int = 0x0fffffff;
		var point1:FlxPoint = FlxG.mouse.getWorldPosition();
		var point0:FlxPoint = new FlxPoint(0, 0);
		if (point1.y < rect.top)
		{
			point1.y += rect.top - point1.y;
		}
		else if (point1.y > rect.bottom)
		{
			point1.y += point1.y - rect.bottom;
		}
		if (point1.x < rect.left)
		{
			point1.x += rect.left - point1.x;
		}
		else if (point1.x > rect.right)
		{
			point1.x += point1.x - rect.right;
		}
		return point1.distanceTo(point0);
	}

	public function dialog(Text:String, CompleteCallback:Int->Void, Prompts:Array<String>=null)
	{
		_completeCallback = CompleteCallback;
		_prompts = Prompts;
		_characterRect.visible = true;
		_character.visible = true;
		_textRect.visible = true;
		_typeText.visible = true;
		if (_skipEnabled)
		{
			_skipButton.visible = true;
		}
		for (from in _replacedText.keys())
		{
			Text = StringTools.replace(Text, from, _replacedText[from]);
		}
		Text = StringTools.replace(Text, "&lt;", "<");
		Text = StringTools.replace(Text, "&gt;", ">");
		if (!PlayerData.profanity)
		{
			Text = MmStringTools.bowdlerize(Text, "fuck");
			Text = MmStringTools.bowdlerize(Text, "shit");
			Text = MmStringTools.bowdlerize(Text, "cunt");
		}
		if (Text.substring(0, 1) == "#")
		{
			if (Text.substring(1, 5) == "self")
			{
				// big...
				_character.visible = false;
				_characterRect.visible = false;
				_textRect.relocate(4, FlxG.height - 78, FlxG.width - 10, 75, 0xff000000, 0xeeffffff);
				_typeText.setPosition(_textRect.x + 4, _textRect.y - 1);
				_typeText.fieldWidth = FlxG.width - 8;
			}
			else
			{
				// normal size...
				_character.visible = true;
				_characterRect.visible = true;
				_textRect.relocate(82, FlxG.height - 78, FlxG.width - 85, 75, 0xff000000, 0xeeffffff);
				_typeText.setPosition(_textRect.x + 4, _textRect.y - 1);
				_typeText.fieldWidth = FlxG.width - 106 - 8;
			}
			if (Text.substring(1, 5) == "abra")
			{
				_character.loadGraphic(AbraResource.chat, true, 73, 71);
				_typeText.sounds = [FlxG.sound.load(AssetPaths.abra_talk__wav, 0.08)];
			}
			else if (Text.substring(1, 5) == "buiz")
			{
				_character.loadGraphic(BuizelResource.chat, true, 73, 71);
				_typeText.sounds = [FlxG.sound.load(AssetPaths.buizel_talk__wav, 0.08)];
			}
			else if (Text.substring(1, 5) == "grov")
			{
				_character.loadGraphic(GrovyleResource.chat, true, 73, 71);
				_typeText.sounds = [FlxG.sound.load(AssetPaths.grov_talk__wav, 0.12)];
			}
			else if (Text.substring(1, 5) == "hera")
			{
				_character.loadGraphic(HeraResource.chat, true, 73, 71);
				_typeText.sounds = [FlxG.sound.load(AssetPaths.hera_talk__wav, 0.08)];
			}
			else if (Text.substring(1, 5) == "sand")
			{
				_character.loadGraphic(SandslashResource.chat, true, 73, 71);
				_typeText.sounds = [FlxG.sound.load(AssetPaths.sand_talk__wav, 0.10)];
			}
			else if (Text.substring(1, 5) == "RHYD" || Text.substring(1, 5) == "rhyd")
			{
				_character.loadGraphic(RhydonResource.chat, true, 73, 71);
				_typeText.sounds = [FlxG.sound.load(AssetPaths.rhyd_talk__wav, 0.10)];
			}
			else if (Text.substring(1, 5) == "smea")
			{
				_character.loadGraphic(AssetPaths.smear_chat__png, true, 73, 71);
				_typeText.sounds = [FlxG.sound.load(AssetPaths.smea_talk__wav, 0.10)];
			}
			else if (Text.substring(1, 5) == "kecl")
			{
				_character.loadGraphic(AssetPaths.kecl_chat__png, true, 73, 71);
				_typeText.sounds = [FlxG.sound.load(AssetPaths.kecl_talk__wav, 0.10)];
			}
			else if (Text.substring(1, 5) == "magn")
			{
				_character.loadGraphic(MagnResource.chat, true, 73, 71);
				_typeText.sounds = [FlxG.sound.load(AssetPaths.magn_talk__wav, 0.10)];
			}
			else if (Text.substring(1, 5) == "luca")
			{
				_character.loadGraphic(LucarioResource.chat, true, 73, 71);
				_typeText.sounds = [FlxG.sound.load(AssetPaths.luca_talk__wav, 0.25)];
			}
			else if (Text.substring(1, 5) == "grim")
			{
				_character.loadGraphic(GrimerResource.chat, true, 73, 71);
				_typeText.sounds = [FlxG.sound.load(AssetPaths.grim_talk__wav, 0.10)];
			}
			else if (Text.substring(1, 5) == "char")
			{
				_character.loadGraphic(AssetPaths.char_chat__png, true, 73, 71);
				_typeText.sounds = [FlxG.sound.load(AssetPaths.grim_talk__wav, 0.10)];
			}
			else if (Text.substring(1, 5) == "misc")
			{
				// #misc#: random objects that might be displayed in chat
				_character.loadGraphic(AssetPaths.misc_chat__png, true, 73, 71);
			}
			else if (Text.substring(1, 5) == "glov")
			{
				if (_gloveSprite == null)
				{
					_gloveSprite = new FlxSprite();
					_gloveSprite.loadGraphic(AssetPaths.empty_chat__png, true, 73, 71, true);
					var gloveGraphic:FlxGraphic = FlxG.bitmap.add(AssetPaths.glove_chat__png, true);
					gloveGraphic.bitmap.threshold(gloveGraphic.bitmap, new Rectangle(0, 0, gloveGraphic.bitmap.width, gloveGraphic.bitmap.height), new Point(0, 0), '==', 0xffffffff, PlayerData.cursorFillColor);
					gloveGraphic.bitmap.threshold(gloveGraphic.bitmap, new Rectangle(0, 0, gloveGraphic.bitmap.width, gloveGraphic.bitmap.height), new Point(0, 0), '==', 0xff000000, PlayerData.cursorLineColor);
					_gloveSprite.pixels.draw(gloveGraphic.bitmap, null, new ColorTransform(1, 1, 1, PlayerData.cursorMaxAlpha, 0, 0, 0, 0));
				}
				_character.loadGraphicFromSprite(_gloveSprite);
				_typeText.sounds = [FlxG.sound.load(AssetPaths.abra_talk__wav, 0.08)];
			}
			else if (Text.substring(1, 5) == "self")
			{
				_typeText.sounds = [FlxG.sound.load(AssetPaths.abra_talk__wav, 0.08)];
			}
			else
			{
				// #zzzz#: empty box
				_character.loadGraphic(AssetPaths.empty_chat__png, true, 73, 71);
			}
			_character.animation.frameIndex = Std.parseInt(Text.substring(5, 7));

			if (Text.substring(1, 5) == "RHYD")
			{
				Text = Text.toUpperCase();
			}
			Text = Text.substring(8);
		}

		_typeText.resetText(Text);
		_typeText.finishSounds = true;
		_typeText.setTypingVariation(0.5);
		_typeText.start(0.020, true);
		_typeText.completeCallback = dialogDone;

		if (_state == paused)
		{
			setVisible(false);
		}
		else
		{
			setState(showingDialog, "showingDialog");
		}
	}

	public function dialogDone()
	{
		if (_prompts == null)
		{
			if (_state != skippedDialog)
			{
				setState(dismissingDialog, "dismissingDialog");
			}
		}
		else
		{
			var x = 0;
			for (prompt in _prompts)
			{
				for (from in _replacedText.keys())
				{
					prompt = StringTools.replace(prompt, from, _replacedText[from]);
				}
				if (!PlayerData.profanity)
				{
					prompt = MmStringTools.bowdlerize(prompt, "fuck");
					prompt = MmStringTools.bowdlerize(prompt, "shit");
					prompt = MmStringTools.bowdlerize(prompt, "cunt");
				}
				var promptText:FlxText = new FlxText(x, FlxG.height / 2 - 50, 0, prompt, 20);
				promptText.alignment = FlxTextAlign.CENTER;
				promptText.color = FlxColor.BLACK;
				promptText.font = AssetPaths.hardpixel__otf;
				promptText.y -= promptText.textField.height / 2;

				var promptRectangle:RoundedRectangle = new RoundedRectangle();
				promptRectangle.relocate(Std.int(promptText.x - 4 - PADDING), Std.int(promptText.y + 2 - PADDING), Std.int(promptText.textField.textWidth + 12 + PADDING * 2), Std.int(promptText.textField.textHeight + PADDING * 2), 0xff000000, 0xeeffffff);

				_promptGroup.add(promptRectangle);
				_promptRectangles.push(promptRectangle);
				_promptGroup.add(promptText);
				_promptTexts.push(promptText);

				x += Std.int(promptRectangle.width + 6);
			}
			x -= 14 + 2 * PADDING;
			if (_promptsDontCoverClues)
			{
				arrangeIntoTwoRows(x, 512);
			}
			else if (_promptsDontCover7PegClues || x > 736)
			{
				arrangeIntoTwoRows(x);
			}
			else
			{
				for (promptItem in _promptGroup)
				{
					promptItem.x += (FlxG.width - x) / 2;
					promptItem.y += _promptsYOffset;
				}
			}
			_promptsYOffset = 0;
			_promptsDontCoverClues = false;
			_promptsDontCover7PegClues = false;

			if (_state != skippedDialog)
			{
				setState(promptingDialog, "promptingDialog");
			}
		}
	}

	private function arrangeIntoTwoRows(x:Int, rightEdge:Int = 768)
	{
		// need two rows
		var topRowCount:Int = Std.int(_prompts.length / 2) * 2;
		var lastItemInRow0:FlxSprite = _promptGroup.members[topRowCount - 1];
		var firstItemInRow1:FlxSprite = _promptGroup.members[topRowCount + 1];
		var a:Int = Std.int(lastItemInRow0.x + lastItemInRow0.width);
		var b:Int = Std.int(firstItemInRow1.x);
		for (i in 0...topRowCount)
		{
			_promptGroup.members[i].x += (rightEdge - a) / 2;
			_promptGroup.members[i].y -= 65;
		}
		for (i in topRowCount..._promptGroup.members.length)
		{
			_promptGroup.members[i].x += (rightEdge - x - b) / 2;
			_promptGroup.members[i].y += 85;
		}
	}

	public function paused(elapsed:Float)
	{
	}

	/**
	 * Sometimes we might want to pause the dialog while things are happening
	 * -- like if bugs are jumping into their clue boxes or something is
	 * happening during a puzzle tutorial.
	 */
	public function pause()
	{
		setState(paused, "paused");
		setVisible(false);
		_clickEnabled = false;
	}

	public function unpause()
	{
		setVisible(true);
		_clickEnabled = true;
	}

	public function setReplacedText(From:String, To:String)
	{
		_replacedText[From] = To;
	}

	public function getReplacedText(From:String):String
	{
		return _replacedText[From];
	}
}