package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.input.FlxInput.FlxInputState;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import openfl.display.BitmapData;
import openfl.display.BlendMode;

/**
 * Graphics for a keyboard. Three keyboard layouts are available based on
 * whether the player is entering their name, password, or IP address
 */
class TextEntryGroup extends FlxGroup
{
	private inline static var REPEAT_DELAY:Float = 0.5;
	private inline static var REPEAT_FREQUENCY:Float = 0.1;
	private static var BACKSPACE_BUTTON_DATA:ButtonData = {x:0, y:0, c:"<"};
	private static var SPACE_BUTTON_DATA:ButtonData = {x:0, y:0, c:" "};
	private static var OK_BUTTON_DATA:ButtonData = {x:0, y:0, c:">"};
	private static var CHAR_TO_KEY:Map<String,FlxKey> = [
				"0" => FlxKey.ZERO,
				"1" => FlxKey.ONE,
				"2" => FlxKey.TWO,
				"3" => FlxKey.THREE,
				"4" => FlxKey.FOUR,
				"5" => FlxKey.FIVE,
				"6" => FlxKey.SIX,
				"7" => FlxKey.SEVEN,
				"8" => FlxKey.EIGHT,
				"9" => FlxKey.NINE,
			];

	private var buttonDatas:Array<ButtonData> = [];
	private var mousePosition:FlxPoint;

	private var clickedButtonRect:FlxSprite;
	private var clickedButtonTween:FlxTween;

	private var spaceBarRect:RoundedRectangle;
	private var clickedSpaceBarRect:FlxSprite;

	private var eraseRect:RoundedRectangle;
	private var clickedEraseRect:FlxSprite;

	private var okRect:RoundedRectangle;
	private var clickedOkRect:FlxSprite;

	private var typedText:FlxText;
	private var textCursor:FlxSprite;

	private var mouseDownTime:Float = 0;
	private var keyDown:FlxKey = 0;
	private var keyDownTime:Float = 0;
	private var repeatTimer:Float = 0;

	private var clickedButtonData:ButtonData = null;
	private var firstUpdate:Bool = true;
	private var textEntryCallback:String->Void;
	private var textMaxLength:Int = 10000;
	private var textCursorMaxX:Int = 593;
	private var config:KeyConfig;

	public function new(?TextEntryCallback:String->Void, config:KeyConfig)
	{
		super();

		this.config = config;
		this.textEntryCallback = TextEntryCallback;

		if (config == KeyConfig.Name)
		{
			var firstRow:Array<String> = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"];
			for (i in 0...firstRow.length)
			{
				buttonDatas.push({x:59 + 66 * i, y:119, c:firstRow[i]});
			}

			var secondRow:Array<String> = ["A", "S", "D", "F", "G", "H", "J", "K", "L"];
			for (i in 0...secondRow.length)
			{
				buttonDatas.push({x:81 + 66 * i, y:185, c:secondRow[i]});
			}

			var thirdRow:Array<String> = ["Z", "X", "C", "V", "B", "N", "M", "."];
			for (i in 0...thirdRow.length)
			{
				buttonDatas.push({x:103 + 66 * i, y:251, c:thirdRow[i]});
			}
		}
		else if (config == KeyConfig.Ip)
		{
			var firstRow:Array<String> = ["0", "1", "2", "3"];
			for (i in 0...firstRow.length)
			{
				buttonDatas.push({x:257 + 66 * i, y:119, c:firstRow[i]});
			}

			var secondRow:Array<String> = ["4", "5", "6", "7"];
			for (i in 0...secondRow.length)
			{
				buttonDatas.push({x:279 + 66 * i, y:185, c:secondRow[i]});
			}

			var thirdRow:Array<String> = ["8", "9", "."];
			for (i in 0...thirdRow.length)
			{
				buttonDatas.push({x:301 + 66 * i, y:251, c:thirdRow[i]});
			}
		}
		else if (config == KeyConfig.Password)
		{
			var firstRow:Array<String> = [null, null, "3", "4", "5", "6", "7", "8", "9", null];
			for (i in 0...firstRow.length)
			{
				buttonDatas.push({x:37 + 66 * i, y:119, c:firstRow[i]});
			}

			var secondRow:Array<String> = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"];
			for (i in 0...secondRow.length)
			{
				buttonDatas.push({x:59 + 66 * i, y:185, c:secondRow[i]});
			}

			var thirdRow:Array<String> = ["A", "S", "D", "F", "G", "H", "J", "K", "L"];
			for (i in 0...thirdRow.length)
			{
				buttonDatas.push({x:81 + 66 * i, y:251, c:thirdRow[i]});
			}

			var fourthRow:Array<String> = ["Z", "X", "C", null, "B", "N", "M", null];
			for (i in 0...fourthRow.length)
			{
				buttonDatas.push({x:103 + 66 * i, y:317, c:fourthRow[i]});
			}
		}

		for (buttonData in buttonDatas)
		{
			if (buttonData.c == null)
			{
				// missing key; password removes 0, 1, O, I keys from keyboard
				continue;
			}

			var button:RoundedRectangle = new RoundedRectangle();
			button.relocate(buttonData.x, buttonData.y, 56, 56, 0xff000000, 0xffffffff, 4);
			add(button);

			var text:FlxText = new FlxText(buttonData.x, buttonData.y, 56, buttonData.c, 40);
			text.alignment = FlxTextAlign.CENTER;
			text.color = FlxColor.BLACK;
			text.font = AssetPaths.hardpixel__otf;
			add(text);
		}

		spaceBarRect = new RoundedRectangle();
		if (config == KeyConfig.Name)
		{
			spaceBarRect.relocate(213, 317, 330, 56, 0xff000000, 0xffffffff, 4);
			add(spaceBarRect);
		}

		var typedTextRect:RoundedRectangle = new RoundedRectangle();
		if (config == KeyConfig.Name || config == KeyConfig.Ip)
		{
			typedTextRect.relocate(147, 57, 474, 48, OptionsMenuState.LIGHT_BLUE, OptionsMenuState.MEDIUM_BLUE, 4);
		}
		else if (config == KeyConfig.Password)
		{
			typedTextRect.relocate(27, 57, 714, 48, OptionsMenuState.LIGHT_BLUE, OptionsMenuState.MEDIUM_BLUE, 4);
			textCursorMaxX = 10000;
		}
		add(typedTextRect);

		typedText = new FlxText(typedTextRect.x + 4, typedTextRect.y - 4, typedTextRect.width, "", 40);
		typedText.color = OptionsMenuState.LIGHT_BLUE;
		typedText.font = AssetPaths.hardpixel__otf;
		add(typedText);

		textCursor = new FlxSprite(typedTextRect.x + 8, typedTextRect.y + 10);
		textCursor.loadGraphic(new BitmapData(40, 28, true, 0x00000000), true, 20, 28, true);
		FlxSpriteUtil.drawRect(textCursor, 0, 0, 20, 28, OptionsMenuState.LIGHT_BLUE);
		textCursor.animation.add("default", [0, 1], 2);
		textCursor.animation.play("default");
		add(textCursor);

		eraseRect = new RoundedRectangle();
		if (config == KeyConfig.Name || config == KeyConfig.Ip)
		{
			eraseRect.relocate(631, 53, 78, 56, 0xff000000, 0xffffffff, 4);
		}
		else if (config == KeyConfig.Password)
		{
			eraseRect.relocate(631, 119, 78, 56, 0xff000000, 0xffffffff, 4);
		}
		add(eraseRect);

		var eraseKey:FlxSprite = new FlxSprite(eraseRect.x + 4, eraseRect.y + 4, AssetPaths.erase_key__png);
		add(eraseKey);

		okRect = new RoundedRectangle();
		if (config == KeyConfig.Name)
		{
			okRect.relocate(587, 317, 122, 56, 0xff000000, 0xffffffff, 4);
		}
		else if (config == KeyConfig.Ip)
		{
			okRect.relocate(499, 251, 122, 56, 0xff000000, 0xffffffff, 4);
		}
		else if (config == KeyConfig.Password)
		{
			okRect.relocate(565, 317, 122, 56, 0xff000000, 0xffffffff, 4);
		}
		add(okRect);

		var okText:FlxText = new FlxText(okRect.x, okRect.y, okRect.width, "Ok", 40);
		okText.alignment = FlxTextAlign.CENTER;
		okText.color = FlxColor.BLACK;
		okText.font = AssetPaths.hardpixel__otf;
		add(okText);

		clickedOkRect = new FlxSprite(okRect.x + 4, okRect.y + 4);
		clickedOkRect.makeGraphic(Std.int(okRect.width - 8), Std.int(okRect.height - 8));
		clickedOkRect.blend = BlendMode.DIFFERENCE;
		clickedOkRect.alpha = 0;
		add(clickedOkRect);

		clickedButtonRect = new FlxSprite();
		clickedButtonRect.makeGraphic(48, 48);
		clickedButtonRect.blend = BlendMode.DIFFERENCE;
		clickedButtonRect.alpha = 0;
		add(clickedButtonRect);

		clickedSpaceBarRect = new FlxSprite(spaceBarRect.x + 4, spaceBarRect.y + 4);
		if (isSpaceBarEnabled())
		{
			clickedSpaceBarRect.makeGraphic(Std.int(spaceBarRect.width - 8), Std.int(spaceBarRect.height - 8));
			clickedSpaceBarRect.blend = BlendMode.DIFFERENCE;
			clickedSpaceBarRect.alpha = 0;
			add(clickedSpaceBarRect);
		}

		clickedEraseRect = new FlxSprite(eraseRect.x + 4, eraseRect.y + 4);
		clickedEraseRect.makeGraphic(Std.int(eraseRect.width - 8), Std.int(eraseRect.height - 8));
		clickedEraseRect.blend = BlendMode.DIFFERENCE;
		clickedEraseRect.alpha = 0;
		add(clickedEraseRect);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (firstUpdate)
		{
			// ignore mouse events for first update -- if we're displayed in response to a click, we'll be double-handling a click
			firstUpdate = false;
			return;
		}

		if (FlxG.mouse.pressed)
		{
			mouseDownTime += elapsed;
		}
		else {
			mouseDownTime = 0;
		}

		if (keyDown != 0 && FlxG.keys.checkStatus(keyDown, FlxInputState.PRESSED))
		{
			keyDownTime += elapsed;
		}
		else {
			keyDownTime = 0;
		}

		if (mouseDownTime == 0 && keyDownTime == 0)
		{
			repeatTimer = 0;
		}

		if ((FlxG.mouse.pressed && mouseDownTime > REPEAT_DELAY) || (keyDown != 0 && FlxG.keys.checkStatus(keyDown, FlxInputState.PRESSED) && keyDownTime > REPEAT_DELAY))
		{
			repeatTimer += elapsed;
			if (repeatTimer > REPEAT_FREQUENCY)
			{
				repeatTimer -= REPEAT_FREQUENCY;
				handleJustPressedButton();
			}
		}

		if (FlxG.mouse.justPressed)
		{
			clickedButtonData = null;
			mouseDownTime = 0;
			mousePosition = FlxG.mouse.getPosition(mousePosition);
			if (isSpaceBarEnabled() && mousePosition.inCoords(spaceBarRect.x, spaceBarRect.y, spaceBarRect.width, spaceBarRect.height))
			{
				clickedButtonData = SPACE_BUTTON_DATA;
			}
			else if (mousePosition.inCoords(eraseRect.x, eraseRect.y, eraseRect.width, eraseRect.height))
			{
				clickedButtonData = BACKSPACE_BUTTON_DATA;
			}
			else if (mousePosition.inCoords(okRect.x, okRect.y, okRect.width, okRect.height))
			{
				clickedButtonData = OK_BUTTON_DATA;
			}
			else
			{
				for (buttonData in buttonDatas)
				{
					if (buttonData.c == null)
					{
						// can't click null buttons
						continue;
					}
					if (mousePosition.inCoords(buttonData.x, buttonData.y, 56, 56))
					{
						clickedButtonData = buttonData;
						break;
					}
					if (buttonData.c == "." && FlxG.keys.justPressed.PERIOD)
					{
						clickedButtonData = buttonData;
						break;
					}
				}
			}
			handleJustPressedButton();
		}
		var justPressed:Int = FlxG.keys.firstJustPressed();
		if (justPressed != -1)
		{
			clickedButtonData = null;
			keyDownTime = 0;
			if (isSpaceBarEnabled() && FlxG.keys.justPressed.SPACE)
			{
				clickedButtonData = SPACE_BUTTON_DATA;
				keyDown = FlxKey.SPACE;
			}
			else if (FlxG.keys.justPressed.BACKSPACE)
			{
				clickedButtonData = BACKSPACE_BUTTON_DATA;
				keyDown = FlxKey.BACKSPACE;
			}
			else if (FlxG.keys.justPressed.ENTER)
			{
				clickedButtonData = OK_BUTTON_DATA;
				keyDown = FlxKey.ENTER;
			}
			else
			{
				var justPressedChar:String = String.fromCharCode(justPressed).toUpperCase();
				for (buttonData in buttonDatas)
				{
					if (buttonData.c == justPressedChar)
					{
						clickedButtonData = buttonData;
						if (CHAR_TO_KEY[justPressedChar] != null)
						{
							keyDown = CHAR_TO_KEY[justPressedChar];
						}
						else
						{
							keyDown = FlxKey.fromString(justPressedChar);
						}
						break;
					}
					if (buttonData.c == "." && FlxG.keys.justPressed.PERIOD)
					{
						clickedButtonData = buttonData;
						keyDown = FlxKey.PERIOD;
						break;
					}
				}
			}
			handleJustPressedButton();
		}
		textCursor.x = typedText.x + (typedText.text == "" ? 0 : typedText.textField.textWidth) + 4;
		while (textCursor.x > textCursorMaxX || typedText.text.length > textMaxLength)
		{
			typedText.text = typedText.text.substr(0, Std.int(Math.max(0, typedText.text.length - 1)));
			textCursor.x = typedText.x + (typedText.text == "" ? 0 : typedText.textField.textWidth) + 4;
		}
	}

	private function isSpaceBarEnabled():Bool
	{
		return spaceBarRect.width > 8;
	}

	public static inline function squareOut(t:Float):Float
	{
		return 0;
	}

	public function setMaxLength(textMaxLength:Int)
	{
		this.textMaxLength = textMaxLength;
	}

	function handleJustPressedButton():Void
	{
		if (clickedButtonData != null)
		{
			clickedButtonRect.alpha = 0;
			clickedSpaceBarRect.alpha = 0;
			clickedEraseRect.alpha = 0;
			clickedOkRect.alpha = 0;
			if (clickedButtonData == SPACE_BUTTON_DATA && spaceBarRect != null)
			{
				clickedSpaceBarRect.alpha = 1;
				clickedButtonTween = FlxTweenUtil.retween(clickedButtonTween, clickedSpaceBarRect, {alpha:0}, 0.1, {ease:squareOut});
			}
			else if (clickedButtonData == BACKSPACE_BUTTON_DATA)
			{
				clickedEraseRect.alpha = 1;
				clickedButtonTween = FlxTweenUtil.retween(clickedButtonTween, clickedEraseRect, {alpha:0}, 0.1, {ease:squareOut});
			}
			else if (clickedButtonData == OK_BUTTON_DATA)
			{
				clickedOkRect.alpha = 1;
				clickedButtonTween = FlxTweenUtil.retween(clickedButtonTween, clickedOkRect, {alpha:0}, 0.1, {ease:squareOut});
			}
			else
			{
				clickedButtonRect.x = clickedButtonData.x + 4;
				clickedButtonRect.y = clickedButtonData.y + 4;
				clickedButtonRect.alpha = 1;
				clickedButtonTween = FlxTweenUtil.retween(clickedButtonTween, clickedButtonRect, {alpha:0}, 0.1, {ease:squareOut});
			}
			typePressedButton();
		}
	}

	function typePressedButton():Void
	{
		if (clickedButtonData != null)
		{
			if (clickedButtonData == BACKSPACE_BUTTON_DATA)
			{
				typedText.text = typedText.text.substr(0, Std.int(Math.max(0, typedText.text.length - 1)));
				if (config == KeyConfig.Password)
				{
					if (typedText.text.length == 6 || typedText.text.length == 13)
					{
						typedText.text = typedText.text.substr(0, Std.int(Math.max(0, typedText.text.length - 1)));
					}
				}
			}
			else if (clickedButtonData == OK_BUTTON_DATA)
			{
				typedText.text = StringTools.trim(typedText.text);
				while (typedText.text.indexOf("  ") != -1)
				{
					typedText.text = StringTools.replace(typedText.text, "  ", " ");
				}
				if (textEntryCallback != null)
				{
					textEntryCallback(typedText.text);
				}
			}
			else
			{
				typedText.text += clickedButtonData.c;
				if (config == KeyConfig.Password)
				{
					if (typedText.text.length == 6 || typedText.text.length == 13)
					{
						typedText.text += " ";
					}
				}
			}
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		buttonDatas = null;
		mousePosition = FlxDestroyUtil.put(mousePosition);
		clickedButtonRect = FlxDestroyUtil.destroy(clickedButtonRect);
		clickedButtonTween = FlxTweenUtil.destroy(clickedButtonTween);
		spaceBarRect = FlxDestroyUtil.destroy(spaceBarRect);
		clickedSpaceBarRect = FlxDestroyUtil.destroy(clickedSpaceBarRect);
		eraseRect = FlxDestroyUtil.destroy(eraseRect);
		clickedEraseRect = FlxDestroyUtil.destroy(clickedEraseRect);
		okRect = FlxDestroyUtil.destroy(okRect);
		clickedOkRect = FlxDestroyUtil.destroy(clickedOkRect);
		typedText = FlxDestroyUtil.destroy(typedText);
		textCursor = FlxDestroyUtil.destroy(textCursor);
		clickedButtonData = null;
		textEntryCallback = null;
		config = null;
	}
}

typedef ButtonData =
{
	x:Int,
	y:Int,
	c:String
}

enum KeyConfig
{
	Name;
	Ip;
	Password;
}