package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import kludge.FlxSoundKludge;

/**
 * The little HUD window in the bottom-left corner which shows how much money
 * the player has
 */
class CashWindow extends FlxTypedGroup<FlxSprite>
{
	private var _cashWindow:FlxSprite;
	private var _cashWindowText:FlxText;
	private var _cashSymbol:FlxSprite;
	public var _currentAmount:Float = 0;
	private var _cashSound:FlxSound;
	public var _autoHide:Bool = true;
	private var _hideTimer:Float = 0;

	private var _cashYTween:FlxTween;
	private var _cashXTween:FlxTween;

	private var _shopText:Bool = false;

	public function new(Showing:Bool=false)
	{
		super();

		_currentAmount = PlayerData.cash;

		_cashWindow = new FlxSprite(2, 2, AssetPaths.cash_hud__png);
		_cashWindow.x = Showing ? 2 : -_cashWindow.width;
		_cashWindow.y = FlxG.height - 2 - _cashWindow.height;
		add(_cashWindow);

		_cashWindowText = new FlxText(_cashWindow.x - 6, _cashWindow.y + _cashWindow.height / 2 - 14, _cashWindow.width - 8, "", 20);
		_cashWindowText.alignment = "center";
		_cashWindowText.color = FlxColor.BLACK;
		_cashWindowText.font = AssetPaths.hardpixel__otf;
		add(_cashWindowText);

		_cashSymbol = new FlxSprite(0, _cashWindowText.y);
		_cashSymbol.loadGraphic(AssetPaths.cash_symbol__png, true, 30, 30);
		_cashSymbol.animation.add("play", [2, 3, 0, 1, 3, 1, 3, 0, 3, 2, 0, 3, 2, 1, 3, 1, 2, 0, 1, 0, 2, 0, 3, 2, 0, 3, 1, 0, 3, 0, 3, 2, 3, 0, 2, 0, 3, 0, 2, 0, 2, 1, 2, 1, 3, 0, 2, 3, 1, 3, 2, 0, 1, 3, 2, 3, 2, 1, 3, 1, 3, 0, 3, 1], 3);
		_cashSymbol.animation.play("play");
		add(_cashSymbol);

		populateCashWindow();
	}

	override public function update(elapsed:Float):Void
	{
		if (_currentAmount == PlayerData.cash)
		{
			_hideTimer -= elapsed;
			if (_autoHide && _hideTimer < 0 && _hideTimer + elapsed >= 0 && _cashWindow.x == 2)
			{
				_cashXTween = FlxTweenUtil.retween(_cashXTween, _cashWindow, { x: -_cashWindow.width }, 0.13);
			}
			if (_cashSound != null)
			{
				_cashSound.stop();
				_cashSound = null;
				FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3, 0.7);
			}
		}
		else if (Math.round(_currentAmount) == PlayerData.cash)
		{
			_currentAmount = PlayerData.cash;
		}
		else {
			_hideTimer = 1.0;
			var diff:Float = 8 * elapsed * (PlayerData.cash - _currentAmount);
			diff = diff > 0 ? FlxMath.bound(diff, 1, 23) : FlxMath.bound(diff, -23, -1);
			if (diff > 0)
			{
				if (_cashSound == null)
				{
					_cashSound = FlxG.sound.load(FlxSoundKludge.fixPath(AssetPaths.cash_accumulate_0065__mp3));
					_cashSound.play();
				}
			}
			_currentAmount += diff;
			populateCashWindow();
		}
		super.update(elapsed);

		_cashWindowText.x = _cashWindow.x - 6;
		_cashWindowText.y = _cashWindow.y + _cashWindow.height / 2 - 14;
		_cashSymbol.x = _cashWindowText.x + 50 + _cashWindowText.textField.textWidth / 2;
		_cashSymbol.y = _cashWindowText.y;
	}

	function populateCashWindow()
	{
		_cashWindowText.text = formatCash(_currentAmount);
	}

	public static function formatCash(cash:Float):String
	{
		var result:String = Std.string(Math.round(FlxMath.bound(cash, 0, 999995)));
		if (result.length > 3)
		{
			result = result.substring(0, result.length - 3) + "," + result.substring(result.length - 3 );
		}
		return result;
	}

	override public function destroy():Void
	{
		super.destroy();

		_cashWindow = FlxDestroyUtil.destroy(_cashWindow);
		_cashWindowText = FlxDestroyUtil.destroy(_cashWindowText);
		_cashSymbol = FlxDestroyUtil.destroy(_cashSymbol);
		_cashSound = FlxDestroyUtil.destroy(_cashSound);
		_cashYTween = FlxTweenUtil.destroy(_cashYTween);
		_cashXTween = FlxTweenUtil.destroy(_cashXTween);
	}

	/**
	 * The cash window is almost always in the very bottom-left corner of the
	 * screen -- but when Heracross is talking to us in the shop, we slide the
	 * window up so it doesn't overlap the dialog.
	 *
	 * @param	shopText true if the CashWindow should be slid up a few pixels
	 */
	public function setShopText(shopText:Bool)
	{
		if (this._shopText == shopText)
		{
			return;
		}
		_cashYTween = FlxTweenUtil.retween(_cashYTween, _cashWindow, { y : shopText ? FlxG.height - 79 - _cashWindow.height : FlxG.height - 2 - _cashWindow.height }, 0.13);
		this._shopText = shopText;
	}

	public function show()
	{
		_cashXTween = FlxTweenUtil.retween(_cashXTween, _cashWindow, { x: 2 }, 0.13);
	}
}