package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import kludge.AssetKludge;
import kludge.FlxFilterFramesKludge;
import kludge.FlxSoundKludge;
import openfl.filters.DropShadowFilter;
import poke.Password;
import poke.sexy.SexyState;
import puzzle.RankTracker;

/**
 * The options screen where the player can change their save slot, toggle sound
 * effects, disable profanity and other settings.
 */
class OptionsMenuState extends FlxState
{
	private var _handSprite:FlxSprite;

	public static var DARK_BLUE:FlxColor = 0xFF00647F;
	public static var MEDIUM_BLUE:FlxColor = 0xFF3FA4BF;
	public static var LIGHT_BLUE:FlxColor = 0xFF7FE4FF;
	public static var WHITE_BLUE:FlxColor = 0xFFE8FFFF;

	private static var DARK_RED:FlxColor = 0xFF7F3232;
	private static var MEDIUM_RED:FlxColor = 0xFFBF7171;
	private static var LIGHT_RED:FlxColor = 0xFFFFB1B1;
	private static var WHITE_RED:FlxColor = 0xFFFFF3F3;
	private var _screenSprite:FlxSprite;
	private var _deleteButton:FlxButton;
	private var _backButton:FlxButton;
	private var _soundButton:FlxText;
	private var _detailButton:FlxText;
	private var _profanityButton:FlxText;
	private var _passwordButton:FlxText;
	private var _sfwButton:FlxText;

	private var _deleteOn:Bool = false;
	private var _deleteSlot:Int = -1;
	private var _bigWhiteX:FlxSprite;
	private var _bigRedX:FlxSprite;
	private var _explosionGroup:FlxTypedGroup<FlxParticle>;

	private var _initialTimePlayed:Float = 0;

	private var _mouseClickTime:Float = 100;
	private var _saveDatas:Array<Dynamic> = [];

	/**
	 * the "delete" button beeps when clicking and unclicking. but it unclicks when the user deletes, and we don't want it to beep then.
	 */
	private var _suppressBeep = false;
	private var _initialSaveSlot:Int = 0;

	private var rects:Array<FlxRect> = [
										   new FlxRect(67, 109, 200, 104),
										   new FlxRect(284, 109, 200, 104),
										   new FlxRect(501, 109, 200, 104)
									   ];

	override public function create():Void
	{
		Main.overrideFlxGDefaults();
		super.create();

		for (i in 0...3)
		{
			_saveDatas[i] = PlayerSave.getSaveData(i);
			if (_saveDatas[i].cash == null)
			{
				_saveDatas[i] = null;
			}
		}

		_initialSaveSlot = PlayerData.saveSlot;
		_initialTimePlayed = PlayerData.timePlayed;

		_screenSprite = new FlxSprite(0, 0);
		_screenSprite.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE, true);
		add(_screenSprite);
		paintScreenSprite();

		{
			var text:FlxText = new FlxText(50, 50, FlxG.width - 100, "FILE SELECT", 40);
			text.font = AssetPaths.hardpixel__otf;
			text.alignment = FlxTextAlign.CENTER;
			text.color = LIGHT_BLUE;
			add(text);
		}

		{
			_bigWhiteX = new FlxSprite();
			_bigWhiteX.makeGraphic(200, 104, FlxColor.TRANSPARENT, false, "big-white-x");
			FlxSpriteUtil.drawLine(_bigWhiteX, 10, 10, 190, 94, { thickness:7, color:WHITE_RED } );
			FlxSpriteUtil.drawLine(_bigWhiteX, 190, 10, 10, 94, { thickness:7, color:WHITE_RED } );
			_bigWhiteX.visible = false;
			add(_bigWhiteX);
		}

		{
			_bigRedX = new FlxSprite();
			_bigRedX.makeGraphic(200, 124, FlxColor.TRANSPARENT, false, "big-red-x");

			FlxSpriteUtil.beginDraw(0x80FFB1B1);
			octagon(1, 1, 199, 103, 2);
			FlxSpriteUtil.endDraw(_bigRedX);

			FlxSpriteUtil.drawLine(_bigRedX, 10, 10, 190, 94, { thickness:7, color:MEDIUM_RED } );
			FlxSpriteUtil.drawLine(_bigRedX, 190, 10, 10, 94, { thickness:7, color:MEDIUM_RED } );
			_bigRedX.visible = false;
			add(_bigRedX);
		}

		_backButton = SexyState.newBackButton(back, AssetPaths.back_button2__png);
		_backButton.x = FlxG.width / 2 - _backButton.width / 2;
		_backButton.y = FlxG.height - 50 - _backButton.height - 16;
		add(_backButton);

		_soundButton = new FlxText(67, 221, 210, "", 20);
		_soundButton.text = FlxG.sound.volume == 0 ? "SOUND: DISABLED" : "SOUND: ENABLED";
		_soundButton.font = AssetPaths.hardpixel__otf;
		_soundButton.color = LIGHT_BLUE;
		add(_soundButton);

		_profanityButton = new FlxText(284, 221, 210, "", 20);
		_profanityButton.text = PlayerData.profanity ? "PROFANITY: ENABLED" : "PROFANITY: DISABLED";
		_profanityButton.font = AssetPaths.hardpixel__otf;
		_profanityButton.color = LIGHT_BLUE;
		add(_profanityButton);

		_detailButton = new FlxText(67, 246, 210, "", 20);
		_detailButton.font = AssetPaths.hardpixel__otf;
		_detailButton.color = LIGHT_BLUE;
		add(_detailButton);
		updateDetailButtonText();

		_sfwButton = new FlxText(284, 246, 210, "", 20);
		_sfwButton.text = PlayerData.sfw ? "SFW MODE: SAFE" : "SFW MODE: PORN";
		_sfwButton.font = AssetPaths.hardpixel__otf;
		_sfwButton.color = LIGHT_BLUE;
		add(_sfwButton);

		_passwordButton = new FlxText(67, 301, 0, "", 20);
		_passwordButton.text = "<CLICK FOR PASSWORD>";
		_passwordButton.font = AssetPaths.hardpixel__otf;
		_passwordButton.color = LIGHT_BLUE;
		add(_passwordButton);

		_deleteButton = newDeleteButton(toggleDelete);
		_deleteButton.x = FlxG.width - 50 - _deleteButton.width - 14;
		_deleteButton.y = 213 + 14;
		add(_deleteButton);

		_explosionGroup = new FlxTypedGroup<FlxParticle>();
		add(_explosionGroup);

		var versionText:FlxText = new FlxText(0, 0, 100, Main.VERSION_STRING, 8);
		versionText.alignment = "left";
		versionText.alpha = 0.2;
		add(versionText);

		_handSprite = new FlxSprite(100, 100);
		CursorUtils.initializeHandSprite(_handSprite, AssetPaths.hands__png);
		_handSprite.setSize(3, 3);
		_handSprite.offset.set(69, 87);
		add(_handSprite);
	}

	function updateDetailButtonText()
	{
		if (PlayerData.detailLevel == PlayerData.DetailLevel.VeryLow)
		{
			_detailButton.text = "DETAIL: VERY LOW";
		}
		else if (PlayerData.detailLevel == PlayerData.DetailLevel.Low)
		{
			_detailButton.text = "DETAIL: LOW";
		}
		else
		{
			_detailButton.text = "DETAIL: MAX";
		}
	}

	function saveExists(i:Int)
	{
		return _saveDatas[i] != null;
	}

	function back()
	{
		var timeSpentOnScreen:Float = PlayerData.timePlayed - _initialTimePlayed;
		PlayerSave.setSaveSlot();
		if (!Math.isNaN(timeSpentOnScreen))
		{
			PlayerData.timePlayed += timeSpentOnScreen;
		}
		FlxG.switchState(new MainMenuState());
	};

	function toggleDelete(deleteOn:Bool)
	{
		_mouseClickTime = 0;
		_deleteOn = deleteOn;
		_deleteSlot = -1;
		if (!_suppressBeep)
		{
			FlxSoundKludge.play(_deleteOn ? AssetPaths.bleep_0066__mp3 : AssetPaths.beep_0065__mp3);
		}
		paintScreenSprite();
	}

	public static function newDeleteButton(Callback:Bool->Void, asset:FlxGraphicAsset=AssetPaths.delete_button__png):FlxButton
	{
		AssetKludge.buttonifyAsset(asset);

		var button:FlxButton = new FlxButton();
		button.loadGraphic(asset);
		button.allowSwiping = false;
		button.setPosition(FlxG.width - button.width - 6, FlxG.height - button.height - 6);
		var filter:DropShadowFilter = new DropShadowFilter(3, 90, 0, ShadowGroup.SHADOW_ALPHA, 0, 0);
		filter.distance = 3;
		var spriteFilter:FlxFilterFramesKludge = FlxFilterFramesKludge.fromFrames(button.frames, 0, 5, [filter]);
		spriteFilter.applyToSprite(button, false, true);

		button.onDown.callback = function()
		{
			if (filter.distance != 0)
			{
				filter.distance = 0;
				spriteFilter.secretOffset.y = -3;
			}
			else
			{
				filter.distance = 3;
				spriteFilter.secretOffset.y = 0;
			}
			spriteFilter.applyToSprite(button, false, true);
			if (Callback != null)
			{
				Callback(filter.distance == 0);
			}
		}

		button.onUp.callback = function()
		{
		}

		button.onOut.callback = function()
		{
		}

		return button;
	}

	function paintScreenSprite()
	{
		_screenSprite.stamp(new FlxSprite(0, 0, AssetPaths.title_screen_bg__png));
		FlxSpriteUtil.drawRect(_screenSprite, 0, 0, _screenSprite.width, _screenSprite.height, 0xAA003240);

		FlxSpriteUtil.beginDraw(MEDIUM_BLUE);
		octagon(50, 50, FlxG.width-50, FlxG.height-50, 2);
		FlxSpriteUtil.endDraw(_screenSprite);

		FlxSpriteUtil.flashGfx.clear();
		FlxSpriteUtil.setLineStyle({ thickness:9, color:DARK_BLUE });
		octagon(50, 50, FlxG.width-50, FlxG.height-50, 2);
		FlxSpriteUtil.updateSpriteGraphic(_screenSprite);

		FlxSpriteUtil.flashGfx.clear();
		FlxSpriteUtil.setLineStyle({ thickness:7, color:WHITE_BLUE });
		octagon(50, 50, FlxG.width-50, FlxG.height-50, 2);
		FlxSpriteUtil.updateSpriteGraphic(_screenSprite);

		var x:Int = 67;
		var y:Int = 109;

		for (i in 0...3)
		{
			var rect = rects[i];
			var canDeleteSlot = _deleteOn && saveExists(i);
			FlxSpriteUtil.beginDraw(canDeleteSlot ? MEDIUM_RED : MEDIUM_BLUE);
			octagon(rect.x, rect.y, rect.x + rect.width, rect.y + rect.height, 2);
			FlxSpriteUtil.endDraw(_screenSprite);

			if (i == PlayerData.saveSlot)
			{
				FlxSpriteUtil.beginDraw(canDeleteSlot ? 0x88FFB1B1 : 0x887FE4FF);
				octagon(rect.x, rect.y, rect.x + rect.width, rect.y + rect.height, 2);
				FlxSpriteUtil.endDraw(_screenSprite);

				FlxSpriteUtil.flashGfx.clear();
				FlxSpriteUtil.setLineStyle( { thickness:7, color:canDeleteSlot ? LIGHT_RED : LIGHT_BLUE } );
				octagon(rect.x, rect.y, rect.x + rect.width, rect.y + rect.height, 2);
				FlxSpriteUtil.updateSpriteGraphic(_screenSprite);

				FlxSpriteUtil.flashGfx.clear();
				FlxSpriteUtil.setLineStyle( { thickness:5, color:canDeleteSlot ? WHITE_RED : WHITE_BLUE } );
				octagon(rect.x, rect.y, rect.x + rect.width, rect.y + rect.height, 2);
				FlxSpriteUtil.updateSpriteGraphic(_screenSprite);
			}
			else
			{
				FlxSpriteUtil.flashGfx.clear();
				FlxSpriteUtil.setLineStyle( { thickness:3, color:canDeleteSlot ? LIGHT_RED : LIGHT_BLUE } );
				octagon(rect.x, rect.y, rect.x + rect.width, rect.y + rect.height, 2);
				FlxSpriteUtil.updateSpriteGraphic(_screenSprite);
			}

			if (!saveExists(i))
			{
				continue;
			}
			var saveData:Dynamic = _saveDatas[i];
			{
				var text:FlxText = new FlxText(rects[i].x + 5, rects[i].y, 0, saveData.name == null ? "???" : saveData.name.toUpperCase(), 20);
				if (text.textField.textWidth > rects[i].width + 28)
				{
					while (text.textField.textWidth > rects[i].width + 15)
					{
						text.text = text.text.substr(0, text.text.length - 1);
					}
					text.text += "...";
				}
				text.font = AssetPaths.hardpixel__otf;
				text.color = canDeleteSlot ? WHITE_RED : WHITE_BLUE;
				_screenSprite.stamp(text, Std.int(text.x), Std.int(text.y));
			}
			{
				var playerItemIndexes:Array<Int> = PlayerSave.def(saveData.playerItemIndexes, []);
				var abraStoryInt:Int = PlayerSave.def(saveData.abraStoryInt, 0);

				var progress:Float = playerItemIndexes.length;
				var availableProgress:Float = ItemDatabase._itemTypes.length;

				if (abraStoryInt >= 5)
				{
					progress += 5;
				}
				else if (abraStoryInt >= 3)
				{
					progress += 3;
				}
				else if (abraStoryInt >= 2)
				{
					progress += 2;
				}
				else if (abraStoryInt >= 1)
				{
					progress += 0.1;
				}
				availableProgress += 5;

				var percent:Float = FlxMath.bound(Math.round(1000 * progress / availableProgress) / 10, 0, 100);

				var text:FlxText = new FlxText(rects[i].x + 5, rects[i].y + 26, 190, percent + "%", 20);
				text.font = AssetPaths.hardpixel__otf;
				text.color = canDeleteSlot ? WHITE_RED : WHITE_BLUE;
				_screenSprite.stamp(text, Std.int(text.x), Std.int(text.y));
			}

			{
				var moneyString:String = "$" + CashWindow.formatCash(saveData.cash);
				var text:FlxText = new FlxText(rects[i].x + 5, rects[i].y + 26, 190, moneyString, 20);
				text.font = AssetPaths.hardpixel__otf;
				text.alignment = FlxTextAlign.RIGHT;
				text.color = canDeleteSlot ? WHITE_RED : WHITE_BLUE;
				_screenSprite.stamp(text, Std.int(text.x), Std.int(text.y));
			}

			{
				var timeString:String = "";
				var timePlayed:Float = Math.max(0, saveData.timePlayed);
				// seconds
				timeString = Std.string(Std.int(timePlayed % 60)) + timeString;
				if (timeString.length < 2)
				{
					timeString = "0" + timeString;
				}
				timePlayed /= 60;
				// minutes
				timeString = Std.string(Std.int(timePlayed % 60)) + ":" + timeString;
				if (timeString.length < 5)
				{
					timeString = "0" + timeString;
				}
				timePlayed /= 60;
				// hours
				timeString = Std.string(Std.int(timePlayed)) + ":" + timeString;
				if (timeString.length < 8)
				{
					timeString = "0" + timeString;
				}
				if (timePlayed >= 1000)
				{
					timeString = "999:59:59";
				}
				var text:FlxText = new FlxText(rects[i].x + 5, rects[i].y + 52, 190, timeString, 20);
				text.font = AssetPaths.hardpixel__otf;
				text.alignment = FlxTextAlign.LEFT;
				text.color = canDeleteSlot ? WHITE_RED : WHITE_BLUE;
				_screenSprite.stamp(text, Std.int(text.x), Std.int(text.y));
			}

			{
				var rankHistory:Array<Int> = saveData.rankHistory;
				var rank:Int = 0;
				if (rankHistory != null)
				{
					rank = RankTracker.computeAggregateRank(rankHistory);
				};
				var rankString:String = "RANK " + rank;
				var text:FlxText = new FlxText(rects[i].x + 5, rects[i].y + 52, 190, rankString, 20);
				text.font = AssetPaths.hardpixel__otf;
				text.alignment = FlxTextAlign.RIGHT;
				text.color = canDeleteSlot ? WHITE_RED : WHITE_BLUE;
				_screenSprite.stamp(text, Std.int(text.x), Std.int(text.y));
			}
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		PlayerData.updateTimePlayed();
		if (FlxG.mouse.justPressed)
		{
			PlayerData.updateCursorVisible();
		}
		_handSprite.setPosition(FlxG.mouse.x - _handSprite.width / 2, FlxG.mouse.y - _handSprite.height / 2);

		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(_soundButton))
		{
			// clicked sound button
			if (FlxG.sound.volume == 0)
			{
				FlxG.sound.volume = 1.0;
			}
			else
			{
				FlxG.sound.volume = 0;
			}
			_soundButton.text = FlxG.sound.volume == 0 ? "SOUND: DISABLED" : "SOUND: ENABLED";
		}

		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(_profanityButton))
		{
			// clicked profanity button
			PlayerData.profanity = !PlayerData.profanity;
			_profanityButton.text = PlayerData.profanity ? "PROFANITY: ENABLED" : "PROFANITY: DISABLED";
			FlxSoundKludge.play(AssetPaths.beep_0065__mp3);
		}

		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(_detailButton))
		{
			// clicked detail button
			if (PlayerData.detailLevel == PlayerData.DetailLevel.Max)
			{
				PlayerData.detailLevel = PlayerData.DetailLevel.Low;
			}
			else if (PlayerData.detailLevel == PlayerData.DetailLevel.Low)
			{
				PlayerData.detailLevel = PlayerData.DetailLevel.VeryLow;
			}
			else
			{
				PlayerData.detailLevel = PlayerData.DetailLevel.Max;
			}
			updateDetailButtonText();
			FlxSoundKludge.play(AssetPaths.beep_0065__mp3);
		}

		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(_sfwButton))
		{
			// clicked sfw button
			PlayerData.sfw = !PlayerData.sfw;
			_sfwButton.text = PlayerData.sfw ? "SFW MODE: SAFE" : "SFW MODE: PORN";
			FlxSoundKludge.play(AssetPaths.beep_0065__mp3);
		}

		if (FlxG.mouse.justPressed && _passwordButton.visible && FlxG.mouse.overlaps(_passwordButton))
		{
			if (StringTools.endsWith(_passwordButton.text, ">"))
			{
				var rawPassword:String = Password.extractFromPlayerData();
				var prettyPassword = rawPassword.substring(0, 6) + " " + rawPassword.substring(6, 12) + " " + rawPassword.substring(12, 18);
				_passwordButton.text = (PlayerData.name == null ? "???" : PlayerData.name.toUpperCase()) + ": " + prettyPassword;
				FlxSoundKludge.play(AssetPaths.beep_0065__mp3);
			}
			else
			{
				/*
				 * We force the user to click before showing their password,
				 * just in case they're streaming and they don't want people
				 * copying them
				 */
				_passwordButton.text = "<CLICK FOR PASSWORD>";
				FlxSoundKludge.play(AssetPaths.beep_0065__mp3);
			}
		}

		if (FlxG.mouse.justPressed && _mouseClickTime > 0)
		{
			var mouseRect:FlxRect = getMouseRect();
			if (_deleteOn)
			{
				if (mouseRect != null && saveExists(rects.indexOf(mouseRect)))
				{
					if (_deleteSlot != rects.indexOf(mouseRect))
					{
						// select item to delete
						_deleteSlot = rects.indexOf(mouseRect);
						FlxSoundKludge.play(AssetPaths.beep_0065__mp3);
					}
					else if (_mouseClickTime > 0.3)
					{
						// delete!
						PlayerSave.deleteSave(rects.indexOf(mouseRect));
						_saveDatas[rects.indexOf(mouseRect)] = null;
						_suppressBeep = true;
						_deleteButton.onDown.callback();
						_suppressBeep = false;
						FlxSoundKludge.play(AssetPaths.delete_0014__mp3);
						paintScreenSprite();

						// first row of particles
						emitParticles(mouseRect.x + 5, mouseRect.y + 5, 50, 15, 20);

						// second row of particles
						emitParticles(mouseRect.right - 95, mouseRect.y + 30, 85, 15, 20);
						emitParticles(mouseRect.x + 5, mouseRect.y + 30, 85, 15, 20);

						// third row of particles
						emitParticles(mouseRect.right - 95, mouseRect.y + 55, 85, 15, 20);
						emitParticles(mouseRect.x + 5, mouseRect.y + 55, 85, 15, 20);
					}
				}
				else
				{
					// unclick button
					_deleteButton.onDown.callback();
				}
			}
			else
			{
				if (mouseRect != null)
				{
					// select save slot
					PlayerData.saveSlot = rects.indexOf(mouseRect);
					_passwordButton.visible = (PlayerData.saveSlot == _initialSaveSlot);
					paintScreenSprite();
					FlxSoundKludge.play(AssetPaths.beep_0065__mp3);
				}
			}
		}

		_bigWhiteX.visible = false;
		_bigRedX.visible = false;

		if (_deleteOn && _deleteSlot < 0)
		{
			var mouseRect:FlxRect = getMouseRect();
			if (mouseRect != null && saveExists(rects.indexOf(mouseRect)))
			{
				_bigWhiteX.x = mouseRect.x;
				_bigWhiteX.y = mouseRect.y;
				_bigWhiteX.visible = true;
			}
		}

		if (_deleteSlot >= 0)
		{
			_bigRedX.visible = true;
			_bigRedX.x = rects[_deleteSlot].x;
			_bigRedX.y = rects[_deleteSlot].y;
		}

		if (FlxG.mouse.justPressed)
		{
			_mouseClickTime = 0;
		}
		else {
			_mouseClickTime += elapsed;
		}
	}

	function emitParticles(x:Float, y:Float, w:Float, h:Float, particleCount:Int)
	{
		var itemY = y;
		var increment = Math.max(1, h / particleCount);
		while (itemY < y + h)
		{
			var newItem:FlxParticle = _explosionGroup.recycle(FlxParticle);
			newItem.reset(FlxG.random.float(x, x + w), itemY);
			newItem.alphaRange.set(1, 0.5);
			newItem.lifespan = FlxG.random.float(0.25, 0.75);
			var size:Int = FlxG.random.int(4, 8);
			newItem.makeGraphic(size, size);
			newItem.velocity.x = FlxG.random.sign() * (2400 / size);
			newItem.exists = true;

			itemY += increment;
		}
	}

	function getMouseRect():FlxRect
	{
		for (rect in rects)
		{
			if (rect.containsPoint(FlxG.mouse.getPosition()))
			{
				return rect;
			}
		}
		return null;
	}

	public static function octagon(x0:Float, y0:Float, x1:Float, y1:Float, miter:Float):Void
	{
		FlxSpriteUtil.flashGfx.moveTo(x0 + miter, y0 - miter);
		FlxSpriteUtil.flashGfx.lineTo(x1 - miter, y0 - miter);
		FlxSpriteUtil.flashGfx.lineTo(x1 + miter, y0 + miter);
		FlxSpriteUtil.flashGfx.lineTo(x1 + miter, y1 - miter);
		FlxSpriteUtil.flashGfx.lineTo(x1 - miter, y1 + miter);
		FlxSpriteUtil.flashGfx.lineTo(x0 + miter, y1 + miter);
		FlxSpriteUtil.flashGfx.lineTo(x0 - miter, y1 - miter);
		FlxSpriteUtil.flashGfx.lineTo(x0 - miter, y0 + miter);
		FlxSpriteUtil.flashGfx.lineTo(x0 + miter, y0 - miter);
	}

	override public function destroy():Void
	{
		super.destroy();

		_screenSprite = FlxDestroyUtil.destroy(_screenSprite);
		_deleteButton = FlxDestroyUtil.destroy(_deleteButton);
		_backButton = FlxDestroyUtil.destroy(_backButton);
		_soundButton = FlxDestroyUtil.destroy(_soundButton);
		_passwordButton = FlxDestroyUtil.destroy(_passwordButton);
		_bigWhiteX = FlxDestroyUtil.destroy(_bigWhiteX);
		_bigRedX = FlxDestroyUtil.destroy(_bigRedX);
		_explosionGroup = FlxDestroyUtil.destroy(_explosionGroup);
		_saveDatas = null;
		rects = null;
	}
}