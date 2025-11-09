package;

import critter.Critter;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import kludge.BetterFlxRandom;
import kludge.FlxSoundKludge;
import openfl.Assets;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import poke.sexy.SexyState;

/**
 * There is a screen the player can access to view their items, and to change
 * which items are active or how they behave. This class is the FlxState which
 * encompasses the logic for that screen.
 */
class ItemsMenuState extends FlxState
{
	public static var DARK_BLUE:FlxColor = 0xFF00647F;
	public static var MEDIUM_BLUE:FlxColor = 0xFF3FA4BF;
	public static var LIGHT_BLUE:FlxColor = 0xFF7FE4FF;
	public static var WHITE_BLUE:FlxColor = 0xFFE8FFFF;

	public var _handSprite:FlxSprite;
	private var _menuItems:FlxGroup;
	public var _itemGraphics:FlxGroup;
	public var handOpacityTween0:FlxTween;
	public var handOpacityTween1:FlxTween;

	public var _bgSprite:FlxSprite;
	private var _menuSprite:FlxSprite;
	private var _backButton:FlxButton;

	public var shadowGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

	/*
	 * Most items have a visual component. This is a list of the visual
	 * components for each item, encompassing things like what sprite they
	 * should use if they have the item, where the sprite should go, and
	 * whether the sprite should change if they change their settings.
	 */
	private var visualItems:Array<VisualItem> = new Array<VisualItem>();

	private var shadowMap:Map<FlxSprite, FlxSprite> = new Map<FlxSprite, FlxSprite>();

	// for critters...
	var _targetSprites:FlxTypedGroup<FlxSprite>;
	var _midInvisSprites:FlxTypedGroup<FlxSprite>;
	var _midSprites:FlxTypedGroup<FlxSprite>;
	var _critterShadowGroup:ShadowGroup;

	/**
	 * 768 x 432
	 * [384,10 -- 758,384]
	 */
	override public function create():Void
	{
		Main.overrideFlxGDefaults();
		Critter.initialize(Critter.LOAD_ALL); // load all critters, so player can view them
		super.create();

		_bgSprite = new FlxSprite(0, 0, AssetPaths.items_bg__png);
		add(_bgSprite);

		_backButton = SexyState.newBackButton(back, AssetPaths.back_button2__png);
		add(_backButton);

		add(shadowGroup);

		_itemGraphics = new FlxGroup();
		add(_itemGraphics);

		_critterShadowGroup = new ShadowGroup();
		_targetSprites = new FlxTypedGroup<FlxSprite>();
		_midInvisSprites = new FlxTypedGroup<FlxSprite>();
		_midInvisSprites.visible = false;
		_midSprites = new FlxTypedGroup<FlxSprite>();

		add(_critterShadowGroup);
		add(_targetSprites);
		add(_midInvisSprites);
		add(_midSprites);

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_ASSORTED_GLOVES)
		|| ItemDatabase.playerHasItem(ItemDatabase.ITEM_INSULATED_GLOVES)
		|| ItemDatabase.playerHasItem(ItemDatabase.ITEM_GHOST_GLOVES)
		|| ItemDatabase.playerHasItem(ItemDatabase.ITEM_VANISHING_GLOVES))
		{
			visualItems.push(new ViGloveColors(this));
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_FRUIT_BUGS)
		|| ItemDatabase.playerHasItem(ItemDatabase.ITEM_MARSHMALLOW_BUGS)
		|| ItemDatabase.playerHasItem(ItemDatabase.ITEM_SPOOKY_BUGS))
		{
			visualItems.push(new ViCritterColors(this));
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_GOLD_PUZZLE_KEY) || ItemDatabase.playerHasItem(ItemDatabase.ITEM_DIAMOND_PUZZLE_KEY))
		{
			visualItems.push(new ViPuzzleKeys(this));
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_VIBRATOR))
		{
			visualItems.push(new ViSimple(this, AssetPaths.vibe_shop_items__png, 166, 21));
		}
		if (ItemDatabase.getPurchasedMysteryBoxCount() >= 8)
		{
			visualItems.push(new ViSimple(this, AssetPaths.elecvibe_items__png, 200, 29));
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_HAPPY_MEAL))
		{
			visualItems.push(new ViSimple(this, AssetPaths.happymeal_items__png, 250, -31));
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_SMALL_GREY_BEADS))
		{
			visualItems.push(new ViSimple(this, AssetPaths.small_grey_beads_items__png, 97, -32));
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_LARGE_GREY_BEADS))
		{
			visualItems.push(new ViSimple(this, AssetPaths.xl_grey_beads_items__png, -12, -30));
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_LARGE_GLASS_BEADS))
		{
			visualItems.push(new ViSimple(this, AssetPaths.xl_glass_beads_items__png, 9, 33));
		}
		if (ItemDatabase.playerHasUneatenItem(ItemDatabase.ITEM_SMALL_PURPLE_BEADS))
		{
			visualItems.push(new ViSimple(this, AssetPaths.small_purple_beads_items__png, -21, 74));
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_HUGE_DILDO))
		{
			visualItems.push(new ViSimple(this, AssetPaths.xl_dildo_items__png, 244, 32));
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_BLUE_DILDO))
		{
			visualItems.push(new ViSimple(this, AssetPaths.blue_dildo_items__png, 271, 76));
		}
		if (ItemDatabase.playerHasUneatenItem(ItemDatabase.ITEM_GUMMY_DILDO))
		{
			visualItems.push(new ViSimple(this, AssetPaths.gummy_dildo_items__png, 245, 95));
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_CALCULATOR))
		{
			visualItems.push(new ViSimple(this, AssetPaths.calculator_items__png, 262, 132));
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_STREAMING_PACKAGE))
		{
			visualItems.push(new ViSimple(this, AssetPaths.streaming_package_items__png, 235, 215));
		}
		if (ItemDatabase._playerItemIndexes.length == ItemDatabase._itemTypes.length && PlayerData.isAbraNice())
		{
			visualItems.push(new ViSimple(this, AssetPaths.trophy_items__png, 126, 98, 160, 200));
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_COOKIES) || ItemDatabase.playerHasItem(ItemDatabase.ITEM_INCENSE))
		{
			visualItems.push(new ViPokemonLibido(this));
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_ACETONE) || ItemDatabase.playerHasItem(ItemDatabase.ITEM_HYDROGEN_PEROXIDE))
		{
			visualItems.push(new ViPegEnergy(this));
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_MARS_SOFTWARE) || ItemDatabase.playerHasItem(ItemDatabase.ITEM_VENUS_SOFTWARE))
		{
			visualItems.push(new ViGenderSoftware(this));
		}

		_menuItems = new FlxGroup();
		_menuSprite = new FlxSprite(0, 0);
		_menuSprite.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		paintMenuSprite();
		_menuItems.add(_menuSprite);

		var y:Int = 18;
		for (visualItem in visualItems)
		{
			y = visualItem.addMenu(y);
			visualItem.addGraphics();
		}

		add(_menuItems);

		_handSprite = new FlxSprite(100, 100);
		CursorUtils.initializeHandSprite(_handSprite, AssetPaths.hands__png);
		_handSprite.setSize(3, 3);
		_handSprite.offset.set(69, 87);
		add(_handSprite);
	}

	function back()
	{
		FlxG.switchState(new MainMenuState());
	};

	function paintMenuSprite()
	{
		FlxSpriteUtil.beginDraw(MEDIUM_BLUE & 0xCCFFFFFF);
		OptionsMenuState.octagon(FlxG.width / 2, 10, FlxG.width-10, FlxG.height-48, 2);
		FlxSpriteUtil.endDraw(_menuSprite);

		FlxSpriteUtil.flashGfx.clear();
		FlxSpriteUtil.setLineStyle({ thickness:9, color:DARK_BLUE });
		OptionsMenuState.octagon(FlxG.width / 2, 10, FlxG.width-10, FlxG.height-48, 2);
		FlxSpriteUtil.updateSpriteGraphic(_menuSprite);

		FlxSpriteUtil.flashGfx.clear();
		FlxSpriteUtil.setLineStyle({ thickness:7, color:WHITE_BLUE });
		OptionsMenuState.octagon(FlxG.width / 2, 10, FlxG.width-10, FlxG.height-48, 2);
		FlxSpriteUtil.updateSpriteGraphic(_menuSprite);
	}

	public function addCritter(critter:Critter, pushToCritterList:Bool = true)
	{
		if (_targetSprites.members.indexOf(critter._targetSprite) != -1)
		{
			// shouldn't add; already exists
			return;
		}
		_targetSprites.add(critter._targetSprite);
		_midInvisSprites.add(critter._soulSprite);
		_midSprites.add(critter._bodySprite);
		_midSprites.add(critter._headSprite);
		_midSprites.add(critter._frontBodySprite);
		_critterShadowGroup.makeShadow(critter._bodySprite);
	}

	public function removeCritter(critter:Critter, pushToCritterList:Bool = true)
	{
		if (_targetSprites.members.indexOf(critter._targetSprite) == -1)
		{
			// can't remove; doesn't exist
			return;
		}
		_targetSprites.remove(critter._targetSprite, true);
		_midInvisSprites.remove(critter._soulSprite, true);
		_midSprites.remove(critter._bodySprite, true);
		_midSprites.remove(critter._headSprite, true);
		_midSprites.remove(critter._frontBodySprite, true);
		_critterShadowGroup.killShadow(critter._bodySprite);
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

		if (FlxG.mouse.justPressed)
		{
			for (visualItem in visualItems)
			{
				visualItem.mousePressed();
			}
		}

		for (shadowSprite in shadowGroup)
		{
			if (shadowMap.exists(shadowSprite))
			{
				var targetSprite:FlxSprite = shadowMap.get(shadowSprite);
				shadowSprite.alive = targetSprite.alive;
				shadowSprite.exists = targetSprite.exists;
				shadowSprite.animation.frameIndex = targetSprite.animation.frameIndex;
				shadowSprite.visible = targetSprite.visible;
				shadowSprite.alpha = targetSprite.alpha;
			}
		}

		_midSprites.sort(LevelState.byYNulls);
	}

	public function addMenuText(X:Float, Y:Float, ?Text:String):FlxText
	{
		var flxText:FlxText = new FlxText(X, Y - 6, 0, Text, 20);
		flxText.font = AssetPaths.hardpixel__otf;
		flxText.color = ItemsMenuState.WHITE_BLUE;
		_menuItems.add(flxText);
		return flxText;
	}

	public function addMenuGraphic(SpriteGraphic:String, x:Float, y:Float, w:Int=160, h:Int=160):FlxSprite
	{
		var newItemImage:FlxSprite = new FlxSprite(x, y);
		newItemImage.loadGraphic(SpriteGraphic, true, w, h);
		addMenuItem(newItemImage);
		return newItemImage;
	}

	public function addMenuItem(basic:FlxBasic)
	{
		_menuItems.add(basic);
	}

	public function addGraphic(SpriteGraphic:String, x:Float, y:Float, w:Int=160, h:Int=160):FlxSprite
	{
		var newItemImage:FlxSprite = new FlxSprite(x, y);
		newItemImage.loadGraphic(SpriteGraphic, true, w, h);
		_itemGraphics.add(newItemImage);

		var shadowKey:String = StringTools.replace(SpriteGraphic, ".png", "-shadow.png");
		if (Assets.exists(shadowKey))
		{
			var newShadowImage:FlxSprite = new FlxSprite(x, y);
			newShadowImage.loadGraphic(shadowKey, true, w, h);
			shadowGroup.add(newShadowImage);
			shadowMap[newShadowImage] = newItemImage;
		}

		return newItemImage;
	}

	override public function destroy():Void
	{
		super.destroy();

		_handSprite = FlxDestroyUtil.destroy(_handSprite);
		_menuItems = FlxDestroyUtil.destroy(_menuItems);
		_itemGraphics = FlxDestroyUtil.destroy(_itemGraphics);
		handOpacityTween0 = FlxTweenUtil.destroy(handOpacityTween0);
		handOpacityTween1 = FlxTweenUtil.destroy(handOpacityTween1);
		_bgSprite = FlxDestroyUtil.destroy(_bgSprite);
		_menuSprite = FlxDestroyUtil.destroy(_menuSprite);
		_backButton = FlxDestroyUtil.destroy(_backButton);
		shadowGroup = FlxDestroyUtil.destroy(shadowGroup);
		visualItems = null;
		shadowMap = null;
		_targetSprites = FlxDestroyUtil.destroy(_targetSprites);
		_midInvisSprites = FlxDestroyUtil.destroy(_midInvisSprites);
		_midSprites = FlxDestroyUtil.destroy(_midSprites);
		_critterShadowGroup = FlxDestroyUtil.destroy(_critterShadowGroup);
	}
}

/**
 * The menu on the right half of the items screen includes many spinners for
 * adjusting values up and down. This class encompasses the logic for those
 * spinners and their buttons.
 */
private class Spinner
{
	public var _leftArrow:FlxText;
	public var _itemText:FlxText;
	public var _rightArrow:FlxText;
	public var _options:Array<String>;
	public var _optionIndex:Int = 0;
	public var _state:ItemsMenuState;
	public var _onChange:Dynamic;
	public var _justPressed:Bool = false;

	/**
	 * Initializes a new spinner
	 *
	 * @param	State itemsMenuState this spinner is embedded in
	 * @param	Options options to spin between (e.g ["SMALL", "MEDIUM", "LARGE"])
	 * @param	Option currently selected ooption
	 * @param	OnChange callback to invoke when the spinner's value changes
	 */
	public function new(State:ItemsMenuState, Options:Array<String>, Option:String, OnChange:Dynamic)
	{
		this._state = State;
		this._options = Options;
		this._optionIndex = Options.indexOf(Option);
		this._onChange = OnChange;
	}

	/**
	 * Centers the spinner. Its left side should have already been defined by
	 * the create() method
	 *
	 * @param	Right the right edge of the bounding box
	 */
	public function center(Right:Float)
	{
		var currRight:Float = _rightArrow.x + _rightArrow.width;
		var offset:Float = (Right - currRight) / 2;
		for (text in [_leftArrow, _itemText, _rightArrow])
		{
			text.x += offset;
		}
	}

	/**
	 * Adds the spinner's visual elements to the itemsMenuState
	 */
	public function create(X:Float, Y:Float)
	{
		_leftArrow = _state.addMenuText(X, Y, "<");

		var maxWidth:Int = 0;
		_itemText = _state.addMenuText(_leftArrow.x + _leftArrow.width + 2, Y);
		for (itemOption in _options)
		{
			_itemText.text = itemOption;
			maxWidth = Std.int(Math.max(maxWidth, _itemText.width));
		}
		_itemText.fieldWidth = maxWidth + 1;
		_itemText.alignment = "center";
		_itemText.text = _options[_optionIndex] == null ? "???" : _options[_optionIndex];

		_rightArrow = _state.addMenuText(_itemText.x + _itemText.fieldWidth + 2, Y, ">");
	}

	public function mousePressed()
	{
		_justPressed = false;
		if (_leftArrow.getMidpoint().distanceTo(FlxG.mouse.getPosition()) < 20)
		{
			FlxSoundKludge.play(AssetPaths.beep_0065__mp3);
			if (_optionIndex == -1)
			{
				_optionIndex = _options.length - 1;
			}
			else if (_optionIndex > 0)
			{
				_optionIndex--;
			}
			_itemText.text = _options[_optionIndex];
			_justPressed = true;
			_onChange();
		}
		if (_rightArrow.getMidpoint().distanceTo(FlxG.mouse.getPosition()) < 20)
		{
			FlxSoundKludge.play(AssetPaths.beep_0065__mp3);
			if (_optionIndex == -1)
			{
				_optionIndex = 0;
			}
			else if (_optionIndex < _options.length - 1)
			{
				_optionIndex++;
			}
			_itemText.text = _options[_optionIndex];
			_justPressed = true;
			_onChange();
		}
	}

	public function setText(text:String)
	{
		_itemText.text = text;
		_optionIndex = _options.indexOf(text);
	}
}

/**
 * Most items have different graphics and behavior on the items menu, such as
 * an object which appears on the table, a menu item defining their behavior.
 * This class can be subclassed for items to define their behavior
 */
private class VisualItem
{
	public var _state:ItemsMenuState;

	public function new(State:ItemsMenuState)
	{
		this._state = State;
	}

	public function addGraphics()
	{
	}

	public function addMenu(y:Int):Int
	{
		return y;
	}

	public function mousePressed():Void
	{
	}
}

/**
 * VisualItem encompassing all of the libido items (cookies and incense)
 */
private class ViPokemonLibido extends VisualItem
{
	private static var valueToDescMap:Map<Int,String> = [1 => "ZERO", 2 => "VERY LOW", 3 => "LOW", 4 => "NORMAL", 5 => "HIGH", 6 => "VERY HIGH", 7 => "MAXIMUM"];
	private static var descToValueMap:Map<String,Int> = ["ZERO" => 1, "VERY LOW" => 2, "LOW" => 3, "NORMAL" => 4, "HIGH" => 5, "VERY HIGH" => 6, "MAXIMUM" => 7];

	private var itemOptions:Array<String>;
	private var itemImageCookies:FlxSprite;
	private var itemImageIncense:FlxSprite;
	private var spinner:Spinner;
	private var smokeCount:Int = 0;

	private var smokeGroup:FlxGroup;

	override public function addMenu(y:Int):Int
	{
		var text:FlxText = _state.addMenuText(FlxG.width / 2 + 4, y, "Pokemon Libido:");
		var itemOptions:Array<String> = ["NORMAL"];
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_INCENSE)) itemOptions = itemOptions.concat(["HIGH", "VERY HIGH", "MAXIMUM"]);
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_COOKIES)) itemOptions = ["ZERO", "VERY LOW", "LOW"].concat(itemOptions);
		spinner = new Spinner(_state, itemOptions, valueToDescMap[PlayerData.pokemonLibido], onChange);
		spinner.create(text.x + text.width + 5, y);
		return y + 40;
	}

	override public function addGraphics()
	{
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_INCENSE))
		{
			itemImageIncense = _state.addGraphic(AssetPaths.incense_items__png, 79, 145);
			smokeGroup = new FlxGroup();
			_state.add(smokeGroup);
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_COOKIES)) itemImageCookies = _state.addGraphic(AssetPaths.cookies_items__png, 3, 151);
		updateGraphics();
	}

	override public function mousePressed()
	{
		spinner.mousePressed();
	}

	function onChange():Void
	{
		PlayerData.pokemonLibido = descToValueMap[spinner._itemText.text];
		updateGraphics();
	}

	function updateGraphics():Void
	{
		if (itemImageCookies != null) itemImageCookies.animation.frameIndex = ["ZERO" => 3, "VERY LOW" => 2, "LOW" => 1, "NORMAL" => 0][spinner._itemText.text];
		if (itemImageIncense != null)
		{
			smokeGroup.kill();
			smokeGroup.clear();
			smokeGroup.revive();
			itemImageIncense.animation.frameIndex = ["MAXIMUM" => 3, "VERY HIGH" => 2, "HIGH" => 1, "NORMAL" => 0][spinner._itemText.text];
			if (itemImageIncense.animation.frameIndex == 1)
			{
				addSmoke( -1, -28);
			}
			else if (itemImageIncense.animation.frameIndex == 2)
			{
				addSmoke( -34, -23);
				addSmoke( 41, -23);
			}
			else if (itemImageIncense.animation.frameIndex == 3)
			{
				addSmoke( -1, -28);
				addSmoke( -34, -23);
				addSmoke( 41, -23);

				addSmoke( -25, -27);
				addSmoke( 43, -19);
			}
		}
	}

	function addSmoke(x:Int, y:Int)
	{
		smokeCount++;
		var smokeSprite:FlxSprite = new FlxSprite(itemImageIncense.x + x, itemImageIncense.y + y);
		smokeSprite.loadGraphic(AssetPaths.incense_items_smoke__png, true, 160, 160);
		smokeSprite.animation.add("default", [(0 + smokeCount) % 3, (1 + smokeCount) % 3, (2 + smokeCount) % 3], 2);
		smokeSprite.animation.play("default");
		smokeGroup.add(smokeSprite);
	}
}

/**
 * VisualItem encompassing all of the peg energy items (acetone, hydrogen peroxide)
 */
private class ViPegEnergy extends VisualItem
{
	private static var valueToDescMap:Map<Int,String> = [1 => "LOWEST", 2 => "LOWER", 3 => "LOW", 4 => "NORMAL", 5 => "HIGH", 6 => "HIGHER", 7 => "HIGHEST"];
	private static var descToValueMap:Map<String,Int> = ["LOWEST" => 1, "LOWER" => 2, "LOW" => 3, "NORMAL" => 4, "HIGH" => 5, "HIGHER" => 6, "HIGHEST" => 7];

	private var spinner:Spinner;
	private var itemImagePeroxide:FlxSprite;
	private var itemImageAcetone:FlxSprite;

	override public function addMenu(y:Int):Int
	{
		var text:FlxText = _state.addMenuText(FlxG.width / 2 + 4, y, "Peg Energy:");
		var itemOptions:Array<String> = ["NORMAL"];
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_ACETONE)) itemOptions = itemOptions.concat(["HIGH", "HIGHER", "HIGHEST"]);
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_HYDROGEN_PEROXIDE)) itemOptions = ["LOWEST", "LOWER", "LOW"].concat(itemOptions);
		spinner = new Spinner(_state, itemOptions, valueToDescMap[PlayerData.pegActivity], onChange);
		spinner.create(text.x + text.width + 5, y);
		return y + 40;
	}

	override public function addGraphics()
	{
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_ACETONE)) itemImageAcetone = _state.addGraphic(AssetPaths.acetone_items__png, 144, 184);
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_HYDROGEN_PEROXIDE)) itemImagePeroxide = _state.addGraphic(AssetPaths.hydrogen_peroxide_items__png, 198, 235);
		updateGraphics();
	}

	override public function mousePressed():Void
	{
		spinner.mousePressed();
	}

	function onChange()
	{
		PlayerData.pegActivity = descToValueMap[spinner._itemText.text];
		updateGraphics();
	}

	function updateGraphics():Void
	{
		if (itemImagePeroxide != null) itemImagePeroxide.animation.frameIndex = StringTools.startsWith(spinner._itemText.text, "LOW") ? 1 : 0;
		if (itemImageAcetone != null) itemImageAcetone.animation.frameIndex = StringTools.startsWith(spinner._itemText.text, "HIGH") ? 1 : 0;
	}
}

/**
 * Visual item encompassing all of the puzzle key items (silver, gold, diamond
 * keys)
 */
private class ViPuzzleKeys extends VisualItem
{
	private static var valueToDescMap:Map<PlayerData.Prompt,String> = [PlayerData.Prompt.AlwaysNo => "NO", PlayerData.Prompt.Ask => "ASK", PlayerData.Prompt.AlwaysYes => "YES"];
	private static var descToValueMap:Map<String,PlayerData.Prompt> = ["NO" => PlayerData.Prompt.AlwaysNo, "ASK" => PlayerData.Prompt.Ask, "YES" => PlayerData.Prompt.AlwaysYes];
	private static var spinnerOptions:Array<String> = ["NO", "ASK", "YES"];

	private var silverSpinner:Spinner;
	private var goldSpinner:Spinner;
	private var diamondSpinner:Spinner;

	private var itemSilverKey:FlxSprite;
	private var itemGoldKey:FlxSprite;
	private var itemDiamondKey:FlxSprite;

	override public function addMenu(y:Int):Int
	{
		var columnWidth:Float = (FlxG.width / 2 - 10) / 3;
		var columnX:Float = FlxG.width / 2 + 4;

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_GOLD_PUZZLE_KEY))
		{
			var silverText:FlxText = _state.addMenuText(columnX, y, "Silver");
			columnX += columnWidth;
			silverText.fieldWidth = columnWidth;
			silverText.alignment = "center";

			silverSpinner = new Spinner(_state, spinnerOptions, valueToDescMap[PlayerData.promptSilverKey], onChange);
			silverSpinner.create(silverText.x, y + 20);
			silverSpinner.center(silverText.x + silverText.width);

			var goldText:FlxText = _state.addMenuText(columnX, y, "Gold");
			columnX += columnWidth;
			goldText.fieldWidth = columnWidth;
			goldText.alignment = "center";

			goldSpinner = new Spinner(_state, spinnerOptions, valueToDescMap[PlayerData.promptGoldKey], onChange);
			goldSpinner.create(goldText.x, y + 20);
			goldSpinner.center(goldText.x + goldText.width);
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_DIAMOND_PUZZLE_KEY))
		{
			var diamondText:FlxText = _state.addMenuText(columnX, y, "Diamond");
			columnX += columnWidth;
			diamondText.fieldWidth = columnWidth;
			diamondText.alignment = "center";

			diamondSpinner = new Spinner(_state, spinnerOptions, valueToDescMap[PlayerData.promptDiamondKey], onChange);
			diamondSpinner.create(diamondText.x, y + 20);
			diamondSpinner.center(diamondText.x + diamondText.width);
		}

		return y + 60;
	}

	override public function addGraphics()
	{
		var baseX:Float = 242;
		var baseY:Float = 228;
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_GOLD_PUZZLE_KEY))
		{
			itemSilverKey = _state.addGraphic(AssetPaths.silver_key_items__png, baseX - 36, baseY + 12, 54, 40);
			itemGoldKey = _state.addGraphic(AssetPaths.gold_key_items__png, baseX - 18, baseY + 12, 54, 40);
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_DIAMOND_PUZZLE_KEY))
		{
			itemDiamondKey = _state.addGraphic(AssetPaths.diamond_key_items__png, baseX + 10, baseY + 10, 54, 40);
		}
		updateGraphics();
	}

	override public function mousePressed():Void
	{
		for (spinner in [silverSpinner, goldSpinner, diamondSpinner])
		{
			if (spinner != null) spinner.mousePressed();
		}
		lock (silverSpinner, goldSpinner, 1);
		lock (silverSpinner, diamondSpinner, 1);
		lock (goldSpinner, silverSpinner, -1);
		lock (goldSpinner, diamondSpinner, 1);
		lock (diamondSpinner, silverSpinner, -1);
		lock (diamondSpinner, goldSpinner, -1);
		onChange();
	}

	function lock (rigid:Spinner, loose:Spinner, desiredDir:Int)
	{
		if (rigid == null || loose == null)
		{
			return;
		}
		if (!rigid._justPressed)
		{
			return;
		}
		var actualDir:Int = spinnerOptions.indexOf(rigid._itemText.text) - spinnerOptions.indexOf(loose._itemText.text);
		if (actualDir > 0 && desiredDir > 0)
		{
			return;
		}
		if (actualDir < 0 && desiredDir < 0)
		{
			return;
		}
		loose.setText(rigid._itemText.text);
	}

	function onChange()
	{
		if (silverSpinner != null) PlayerData.promptSilverKey = descToValueMap[silverSpinner._itemText.text];
		if (goldSpinner != null) PlayerData.promptGoldKey = descToValueMap[goldSpinner._itemText.text];
		if (diamondSpinner != null) PlayerData.promptDiamondKey = descToValueMap[diamondSpinner._itemText.text];
		updateGraphics();
	}

	function updateGraphics():Void
	{
		if (itemSilverKey != null) itemSilverKey.visible = PlayerData.promptSilverKey != PlayerData.Prompt.AlwaysNo;
		if (itemGoldKey != null) itemGoldKey.visible = PlayerData.promptGoldKey != PlayerData.Prompt.AlwaysNo;
		if (itemDiamondKey != null) itemDiamondKey.visible = PlayerData.promptDiamondKey != PlayerData.Prompt.AlwaysNo;
	}
}

/**
 * VisualItem which can be used for any item which just needs to display a
 * static 160x160 image; no menu, no interactivity
 */
private class ViSimple extends VisualItem
{
	private var spriteGraphic:String;
	private var x:Int = 0;
	private var y:Int = 0;
	private var w:Int = 0;
	private var h:Int = 0;

	public function new(state:ItemsMenuState, SpriteGraphic:String, x:Int, y:Int, w:Int=160, h:Int=160)
	{
		super(state);
		this.spriteGraphic = SpriteGraphic;
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}

	override public function addGraphics()
	{
		_state.addGraphic(spriteGraphic, x, y, w, h);
	}
}

private class ViGenderSoftware extends VisualItem
{
	private var abraGraphic:FlxSprite;
	private var buizelGraphic:FlxSprite;
	private var grovyleGraphic:FlxSprite;
	private var sandslashGraphic:FlxSprite;
	private var rhydonGraphic:FlxSprite;
	private var smeargleGraphic:FlxSprite;
	private var kecleonGraphic:FlxSprite;
	private var heracrossGraphic:FlxSprite;
	private var magnezoneGraphic:FlxSprite;
	private var grimerGraphic:FlxSprite;
	private var lucarioGraphic:FlxSprite;
	private var iconConfigs:Array<Array<String>> = [
				["abraGraphic", "abra", AssetPaths.abra_gender_icons__png],
				["buizelGraphic", "buiz", AssetPaths.buizel_gender_icons__png],
				["grovyleGraphic", "grov", AssetPaths.grovyle_gender_icons__png],
				["sandslashGraphic", "sand", AssetPaths.sand_gender_icons__png],
				["rhydonGraphic", "rhyd", AssetPaths.rhydon_gender_icons__png],
				["smeargleGraphic", "smea", AssetPaths.smear_gender_icons__png],
				["kecleonGraphic", "kecl", AssetPaths.kecleon_gender_icons__png],
				["heracrossGraphic", "hera", AssetPaths.hera_gender_icons__png],
				["magnezoneGraphic", "magn", AssetPaths.magn_gender_icons__png],
				["grimerGraphic", "grim", AssetPaths.grimer_gender_icons__png],
				["lucarioGraphic", "luca", AssetPaths.luca_gender_icons__png],
			];

	override public function addGraphics()
	{
		var itemGenderSoftware:FlxSprite = _state.addGraphic(AssetPaths.gender_software_items__png, 315, 295, 90, 94);
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_MARS_SOFTWARE) && ItemDatabase.playerHasItem(ItemDatabase.ITEM_VENUS_SOFTWARE))
		{
			itemGenderSoftware.animation.frameIndex = 2;
		}
		else if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_MARS_SOFTWARE))
		{
			itemGenderSoftware.animation.frameIndex = 1;
		}
	}

	override public function addMenu(y:Int):Int
	{
		var initialY:Int = y;
		var x:Int = Std.int(FlxG.width / 2 + 216);
		var secondRow:Bool = false;
		var iconCount:Int = 0;
		for (iconConfig in iconConfigs)
		{
			if (PlayerData.isDefaultMale(iconConfig[1]))
			{
				if (!ItemDatabase.playerHasItem(ItemDatabase.ITEM_VENUS_SOFTWARE))
				{
					// venus software is needed to modify males
					continue;
				}
			}
			else
			{
				if (!ItemDatabase.playerHasItem(ItemDatabase.ITEM_MARS_SOFTWARE))
				{
					// mars software is needed to modify females
					continue;
				}
			}
			if (x > 720 && secondRow == false)
			{
				y += 30;
				x -= 45;
				secondRow = true;
			}
			Reflect.setField(this, iconConfig[0], _state.addMenuGraphic(iconConfig[2], x, y, 30, 30));
			updateIconGraphic(Reflect.field(this, iconConfig[0]), iconConfig[1] + "Male");
			x = secondRow ? (x - 30) : (x + 30);
			iconCount++;
		}
		if (iconCount == 0)
		{
			return y;
		}
		var genderText:FlxText = _state.addMenuText(FlxG.width / 2 + 4, initialY + 5, "Pokemon Gender:");
		return y + 40;
	}

	override public function mousePressed()
	{
		for (iconConfig in iconConfigs)
		{
			if (handleIconClick(Reflect.field(this, iconConfig[0]), iconConfig[1] + "Male"))
			{
				// only one icon is clicked
				break;
			}
		}
	}

	private function handleIconClick(graphic:FlxSprite, maleField:String):Bool
	{
		if (graphic != null && graphic.getHitbox().containsPoint(FlxG.mouse.getPosition()))
		{
			Reflect.setField(PlayerData, maleField, !Reflect.field(PlayerData, maleField));
			updateIconGraphic(graphic, maleField);
			return true;
		}
		return false;
	}

	private function updateIconGraphic(graphic:FlxSprite, maleField:String)
	{
		if (graphic != null) { graphic.animation.frameIndex = Reflect.field(PlayerData, maleField) ? 1 : 0; }
	}
}

/**
 * VisualItem encompassing all of the critter color items (fruit bugs, marshmallow
 * bugs, spooky bugs)
 */
private class ViCritterColors extends VisualItem
{
	var critterColors:Array<CritterColor>;
	var critters:Array<Critter> = [];
	var critterFrames:Array<FlxSprite> = [];

	public function new(state:ItemsMenuState)
	{
		super(state);

		critterColors = [];
		critterColors = critterColors.concat(Critter.CRITTER_COLORS.slice(0, 6));
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_FRUIT_BUGS))
		{
			critterColors = critterColors.concat(Critter.CRITTER_COLORS.slice(6, 9));
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_MARSHMALLOW_BUGS))
		{
			critterColors = critterColors.concat(Critter.CRITTER_COLORS.slice(9, 12));
		}
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_SPOOKY_BUGS))
		{
			critterColors = critterColors.concat(Critter.CRITTER_COLORS.slice(12, 15));
		}
	}

	override public function addGraphics()
	{
		var critterXOffset:Float = 38 + 8;
		var critterYOffset:Float = 16 + 9;

		var critterCoords:Array<FlxPoint> = [
												FlxPoint.get(critterXOffset * 1.0, critterYOffset * 2),
												FlxPoint.get(critterXOffset * 1.5, critterYOffset * 1),
												FlxPoint.get(critterXOffset * 2.0, critterYOffset * 2),
												FlxPoint.get(critterXOffset * 2.5, critterYOffset * 3),
												FlxPoint.get(critterXOffset * 1.5, critterYOffset * 3),
												FlxPoint.get(critterXOffset * 0.5, critterYOffset * 3),
												FlxPoint.get(critterXOffset * 0.0, critterYOffset * 2),
												FlxPoint.get(critterXOffset * 0.5, critterYOffset * 1),
												FlxPoint.get(critterXOffset * 0.0, critterYOffset * 0),

												FlxPoint.get(critterXOffset * 4.5, critterYOffset * 3),
												FlxPoint.get(critterXOffset * 3.5, critterYOffset * 3),
												FlxPoint.get(critterXOffset * 3.0, critterYOffset * 2),
												FlxPoint.get(critterXOffset * 2.5, critterYOffset * 1),
												FlxPoint.get(critterXOffset * 3.5, critterYOffset * 1),
												FlxPoint.get(critterXOffset * 4.0, critterYOffset * 2),
											];

		for (i in 0...critterColors.length)
		{
			var critterColor:CritterColor = critterColors[i];
			var critter:Critter = new Critter(critterCoords[i].x + FlxG.random.float(-8, 8) + 15, critterCoords[i].y + FlxG.random.float(-8, 8) + 290, _state._bgSprite);
			critter.setColor(critterColor);
			critter.setImmovable(true); // don't let them run around
			critters.push(critter);
			updateIconGraphic(i);
		}
		FlxDestroyUtil.putArray(critterCoords);
	}

	override public function addMenu(y:Int):Int
	{
		var x:Int = Std.int(FlxG.width / 2 + 4);
		_state.addMenuText(FlxG.width / 2 + 4, y + 5, "Bug Colors:");

		var locations:Array<FlxPoint> = [];
		if (critterColors.length <= 9)
		{
			locations.push(new FlxPoint(1.5, 0.0));
			locations.push(new FlxPoint(2.5, 0.0));
			locations.push(new FlxPoint(3.5, 0.0));
			locations.push(new FlxPoint(4.5, 0.0));
			locations.push(new FlxPoint(5.5, 0.0));
			locations.push(new FlxPoint(6.0, 1.0));

			locations.push(new FlxPoint(6.5, 0.0));
			locations.push(new FlxPoint(7.0, 1.0));
			locations.push(new FlxPoint(7.5, 0.0));
		}
		else if (critterColors.length <= 12)
		{
			locations.push(new FlxPoint(1.5, 0.0));
			locations.push(new FlxPoint(2.5, 0.0));
			locations.push(new FlxPoint(3.0, 1.0));
			locations.push(new FlxPoint(3.5, 0.0));
			locations.push(new FlxPoint(4.0, 1.0));
			locations.push(new FlxPoint(4.5, 0.0));

			locations.push(new FlxPoint(5.0, 1.0));
			locations.push(new FlxPoint(5.5, 0.0));
			locations.push(new FlxPoint(6.0, 1.0));

			locations.push(new FlxPoint(6.5, 0.0));
			locations.push(new FlxPoint(7.0, 1.0));
			locations.push(new FlxPoint(7.5, 0.0));
		}
		else {
			locations.push(new FlxPoint(0.0, 1.0));
			locations.push(new FlxPoint(1.0, 1.0));
			locations.push(new FlxPoint(1.5, 0.0));
			locations.push(new FlxPoint(2.0, 1.0));
			locations.push(new FlxPoint(2.5, 0.0));
			locations.push(new FlxPoint(3.0, 1.0));

			locations.push(new FlxPoint(3.5, 0.0));
			locations.push(new FlxPoint(4.0, 1.0));
			locations.push(new FlxPoint(4.5, 0.0));

			locations.push(new FlxPoint(5.0, 1.0));
			locations.push(new FlxPoint(5.5, 0.0));
			locations.push(new FlxPoint(6.0, 1.0));

			locations.push(new FlxPoint(6.5, 0.0));
			locations.push(new FlxPoint(7.0, 1.0));
			locations.push(new FlxPoint(7.5, 0.0));
		}

		for (i in 0...critterColors.length)
		{
			var newItemImage:FlxSprite = new FlxSprite(x + 107 + locations[i].x * 30, y + locations[i].y * 30);
			Critter.loadPaletteShiftedGraphic(newItemImage, critterColors[i], AssetPaths.critter_item_icon__png, true, 30, 30);
			_state.addMenuItem(newItemImage);
			critterFrames.push(_state.addMenuGraphic(AssetPaths.critter_item_frame__png, newItemImage.x, newItemImage.y, 30, 30));
		}

		y += 30;

		return y + 40;
	}

	override public function mousePressed()
	{
		for (i in 0...critterFrames.length)
		{
			if (handleIconClick(i))
			{
				// only one icon is clicked
				break;
			}
		}
	}

	public function handleIconClick(i:Int):Bool
	{
		if (critterFrames[i].getHitbox().containsPoint(FlxG.mouse.getPosition()))
		{
			if (PlayerData.disabledPegColors.indexOf(critterColors[i].englishBackup) == -1)
			{
				PlayerData.disabledPegColors.push(critterColors[i].englishBackup);
			}
			else
			{
				PlayerData.disabledPegColors.remove(critterColors[i].englishBackup);
			}
			updateIconGraphic(i);
			return true;
		}
		return false;
	}

	public function updateIconGraphic(i:Int)
	{
		if (PlayerData.disabledPegColors.indexOf(critterColors[i].englishBackup) == -1)
		{
			// it's enabled...
			_state.addCritter(critters[i]);
			critterFrames[i].animation.frameIndex = 0;
		}
		else
		{
			// it's disabled...
			_state.removeCritter(critters[i]);
			critterFrames[i].animation.frameIndex = 1;
		}
	}
}

/**
 * VisualItem encompassing all of the glove items (assorted gloves, insulated
 * gloves, ghost gloves, vanishing gloves)
 */
private class ViGloveColors extends VisualItem
{
	var categorizedGloveColors:Array<Array<GloveColor>> = [[], [], []];
	var categorizedGloveSprites:Array<Array<FlxSprite>> = [[], [], []];
	var categorizedGloveFrames:Array<Array<FlxSprite>> = [[], [], []];
	var categorySprites:Array<FlxSprite> = [];
	var categoryFrames:Array<FlxSprite> = [];
	var selectedCategoryIndex:Int = 0;
	var gloveColors:Array<GloveColor>;

	var tableGloveSprites:Array<FlxSprite> = [];
	var tableGloveShadows:Array<FlxSprite> = [];

	public function new(state:ItemsMenuState)
	{
		super(state);

		gloveColors = [];
		gloveColors.push({fillColor:0xffe7e8e1, lineColor:0xffb3ada2, minAlpha:1.0, maxAlpha:1.0, insulated:false}); // white

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_ASSORTED_GLOVES))
		{
			gloveColors.push({fillColor:0xffebe79c, lineColor:0xffbca66a, minAlpha:1.0, maxAlpha:1.0, insulated:false}); // cream
			gloveColors.push({fillColor:0xff6d5039, lineColor:0xff4a3124, minAlpha:1.0, maxAlpha:1.0, insulated:false}); // brown
			gloveColors.push({fillColor:0xffa59b8f, lineColor:0xff5c544c, minAlpha:1.0, maxAlpha:1.0, insulated:false}); // grey
			gloveColors.push({fillColor:0xff6edce0, lineColor:0xff59c1c9, minAlpha:1.0, maxAlpha:1.0, insulated:false}); // cyan
			gloveColors.push({fillColor:0xff6cc14e, lineColor:0xff498a2f, minAlpha:1.0, maxAlpha:1.0, insulated:false}); // green
			gloveColors.push({fillColor:0xff6d72c7, lineColor:0xff474881, minAlpha:1.0, maxAlpha:1.0, insulated:false}); // blue
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_INSULATED_GLOVES))
		{
			gloveColors.push({fillColor:0xffefe659, lineColor:0xffc1a144, minAlpha:1.0, maxAlpha:1.0, insulated:true}); // yellow
			gloveColors.push({fillColor:0xffefbc59, lineColor:0xffd89140, minAlpha:1.0, maxAlpha:1.0, insulated:true}); // orange
			gloveColors.push({fillColor:0xff131312, lineColor:0xff4c4945, minAlpha:1.0, maxAlpha:1.0, insulated:true}); // black
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_GHOST_GLOVES))
		{
			gloveColors.push({fillColor:0xfff2ebdd, lineColor:0xffdcd7dd, minAlpha:0.70, maxAlpha:0.70, insulated:false}); // white
			gloveColors.push({fillColor:0xff5c5c5c, lineColor:0xff363433, minAlpha:0.75, maxAlpha:0.75, insulated:false}); // grey
			gloveColors.push({fillColor:0xff502e6a, lineColor:0xff7b448a, minAlpha:0.85, maxAlpha:0.85, insulated:false}); // dark purple
			gloveColors.push({fillColor:0xff964980, lineColor:0xff6f2f5b, minAlpha:0.75, maxAlpha:0.75, insulated:false}); // light purple
			gloveColors.push({fillColor:0xff131312, lineColor:0xff131312, minAlpha:0.65, maxAlpha:0.65, insulated:false}); // solid black
			gloveColors.push({fillColor:0xcc131312, lineColor:0xff131312, minAlpha:0.75, maxAlpha:0.75, insulated:false}); // hollow black
			gloveColors.push({fillColor:0xcc75ffe1, lineColor:0xffb8ffeb, minAlpha:0.70, maxAlpha:0.70, insulated:false}); // ice
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_VANISHING_GLOVES))
		{
			gloveColors.push({fillColor:0xffe7e8e1, lineColor:0xffb3ada2, minAlpha:0.60, maxAlpha:1.00, insulated:false}); // white
			gloveColors.push({fillColor:0xff502e6a, lineColor:0xff7b448a, minAlpha:0.50, maxAlpha:0.85, insulated:false}); // dark purple
			gloveColors.push({fillColor:0xffa59b8f, lineColor:0xff5c544c, minAlpha:0.40, maxAlpha:1.00, insulated:false}); // grey
			gloveColors.push({fillColor:0xff964980, lineColor:0xff6f2f5b, minAlpha:0.40, maxAlpha:0.75, insulated:false}); // light purple
			gloveColors.push({fillColor:0xff131312, lineColor:0xff4c4945, minAlpha:0.25, maxAlpha:1.00, insulated:false}); // black
		}

		BetterFlxRandom.shuffle(gloveColors);

		for (gloveColor in gloveColors)
		{
			var categoryIndex;
			if (gloveColor.minAlpha == 1.0 && gloveColor.maxAlpha == 1.0)
			{
				// opaque
				categoryIndex = 0;
			}
			else if (gloveColor.minAlpha != gloveColor.maxAlpha)
			{
				// disappearing
				categoryIndex = 1;
			}
			else
			{
				// translucent
				categoryIndex = 2;
			}
			categorizedGloveColors[categoryIndex].push(gloveColor);
			if (isCurrentGloveColor(gloveColor))
			{
				selectedCategoryIndex = categoryIndex;
			}
		}
	}

	override public function addGraphics()
	{
		for (i in 0...gloveColors.length)
		{
			var gloveSprite:FlxSprite = new FlxSprite();
			var gloveIndex:Int = 0;
			if (i <= 10)
			{
				gloveSprite.setPosition(99, 119);
				gloveIndex = i;
			}
			else if (i <= 21)
			{
				gloveSprite.setPosition(106, 137);
				gloveIndex = 21 - i;
			}
			else
			{
				// shouldn't reach here...
				gloveSprite.setPosition(113, 155);
				gloveIndex = i % 11;
			}
			gloveSprite.makeGraphic(200, 100, FlxColor.TRANSPARENT, true);

			var gloveStamp:FlxSprite = new FlxSprite(0, 0);
			gloveStamp.loadGraphic(AssetPaths.gloves_items__png, true, 200, 100, true);
			gloveStamp.animation.frameIndex = gloveIndex;
			gloveStamp.pixels.threshold(gloveStamp.pixels, new Rectangle(0, 0, gloveStamp.pixels.width, gloveStamp.pixels.height), new Point(0, 0), '==', 0xffffffff, gloveColors[i].fillColor);
			gloveStamp.pixels.threshold(gloveStamp.pixels, new Rectangle(0, 0, gloveStamp.pixels.width, gloveStamp.pixels.height), new Point(0, 0), '==', 0xff000000, gloveColors[i].lineColor);
			gloveStamp.alpha = gloveColors[i].maxAlpha;
			gloveSprite.stamp(gloveStamp);
			tableGloveSprites.push(gloveSprite);

			_state._itemGraphics.add(gloveSprite);

			var shadowSprite:FlxSprite = new FlxSprite(gloveSprite.x, gloveSprite.y);
			shadowSprite.loadGraphic(AssetPaths.gloves_items_shadow__png, true, 200, 100);
			shadowSprite.animation.frameIndex = gloveIndex;
			tableGloveShadows.push(shadowSprite);
			_state.shadowGroup.add(shadowSprite);
		}

		updateGraphics();
	}

	override public function addMenu(y:Int):Int
	{
		var x:Int = Std.int(FlxG.width / 2 + 4);
		_state.addMenuText(FlxG.width / 2 + 4, y + 5, "Gloves:");

		var categoryLocs:Array<FlxPoint> = [];
		categoryLocs.push(new FlxPoint(0.0, 1.0));
		categoryLocs.push(new FlxPoint(1.0, 1.0));
		categoryLocs.push(new FlxPoint(2.0, 1.0));
		for (c in 0...3)
		{
			if (categorizedGloveColors[c].length == 0)
			{
				// no gloves in category; don't add button
				continue;
			}
			var categorySprite:FlxSprite = new FlxSprite(x + 3 + categoryLocs[categoryFrames.length].x * 30, y + categoryLocs[categoryFrames.length].y * 30);
			categorySprite.loadGraphic(AssetPaths.glove_category_icon__png, true, 30, 30, true);
			categorySprite.animation.frameIndex = c;
			_state.addMenuItem(categorySprite);
			categorySprites.push(categorySprite);
			categoryFrames.push(_state.addMenuGraphic(AssetPaths.critter_item_frame__png, categorySprite.x, categorySprite.y, 30, 30));
		}

		if (categorySprites.length == 1)
		{
			// only one category; don't display category buttons
			categorySprites[0].visible = false;
			categoryFrames[0].visible = false;
		}

		var gloveLocs:Array<FlxPoint> = [];
		gloveLocs.push(new FlxPoint(3.5, 0.0));
		gloveLocs.push(new FlxPoint(4.0, 1.0));
		gloveLocs.push(new FlxPoint(4.5, 0.0));
		gloveLocs.push(new FlxPoint(5.0, 1.0));
		gloveLocs.push(new FlxPoint(5.5, 0.0));
		gloveLocs.push(new FlxPoint(6.0, 1.0));
		gloveLocs.push(new FlxPoint(6.5, 0.0));
		gloveLocs.push(new FlxPoint(7.0, 1.0));
		gloveLocs.push(new FlxPoint(7.5, 0.0));
		gloveLocs.push(new FlxPoint(8.0, 1.0));
		gloveLocs.push(new FlxPoint(8.5, 0.0));
		gloveLocs.push(new FlxPoint(9.0, 1.0));
		gloveLocs.push(new FlxPoint(9.5, 0.0));
		gloveLocs.push(new FlxPoint(10.0, 1.0));

		for (c in 0...3)
		{
			for (i in 0...categorizedGloveColors[c].length)
			{
				var gloveSprite:FlxSprite = new FlxSprite(x + 3 + gloveLocs[i].x * 30, y + gloveLocs[i].y * 30);
				gloveSprite.makeGraphic(30, 30, FlxColor.TRANSPARENT, true);

				var gloveStamp:FlxSprite = new FlxSprite();
				if (categorizedGloveColors[c][i].maxAlpha != categorizedGloveColors[c][i].minAlpha)
				{
					// split glove graphic into left/right halves
					gloveStamp.loadGraphic(AssetPaths.glove_item_icon__png, true, 15, 30, true);
				}
				else
				{
					gloveStamp.loadGraphic(AssetPaths.glove_item_icon__png, false, 30, 30, true);
				}
				gloveStamp.pixels.threshold(gloveStamp.pixels, new Rectangle(0, 0, gloveStamp.pixels.width, gloveStamp.pixels.height), new Point(0, 0), '==', 0xffffffff, categorizedGloveColors[c][i].fillColor);
				gloveStamp.pixels.threshold(gloveStamp.pixels, new Rectangle(0, 0, gloveStamp.pixels.width, gloveStamp.pixels.height), new Point(0, 0), '==', 0xff000000, categorizedGloveColors[c][i].lineColor);
				if (categorizedGloveColors[c][i].maxAlpha != categorizedGloveColors[c][i].minAlpha)
				{
					gloveStamp.alpha = categorizedGloveColors[c][i].maxAlpha;
					gloveStamp.animation.frameIndex = 0;
					gloveSprite.stamp(gloveStamp, 0, 0);
					gloveStamp.alpha = categorizedGloveColors[c][i].minAlpha;
					gloveStamp.animation.frameIndex = 1;
					gloveSprite.stamp(gloveStamp, 15, 0);
				}
				else
				{
					gloveStamp.alpha = categorizedGloveColors[c][i].maxAlpha;
					gloveSprite.stamp(gloveStamp, 0, 0);
				}

				if (categorizedGloveColors[c][i].insulated)
				{
					var c:FlxColor = FlxColor.fromInt(categorizedGloveColors[c][i].fillColor);
					var isDark:Bool = c.redFloat + c.greenFloat + c.blueFloat < 1.5;
					var lightningSpr:FlxSprite = new FlxSprite();
					lightningSpr.loadGraphic(AssetPaths.insulation_overlay__png, true, 30, 30);
					if (isDark)
					{
						lightningSpr.animation.frameIndex = 1;
					}
					gloveSprite.stamp(lightningSpr);
				}

				_state.addMenuItem(gloveSprite);
				categorizedGloveSprites[c].push(gloveSprite);
				categorizedGloveFrames[c].push(_state.addMenuGraphic(AssetPaths.critter_item_frame__png, gloveSprite.x, gloveSprite.y, 30, 30));
			}
		}

		y += 30;

		return y + 40;
	}

	override public function mousePressed()
	{
		var handledClick:Bool = false;
		for (i in 0...categoryFrames.length)
		{
			if (handleCategoryClick(i))
			{
				handledClick = true;
				break;
			}
		}
		for (i in 0...categorizedGloveFrames[selectedCategoryIndex].length)
		{
			if (handleIconClick(i))
			{
				handledClick = true;
				break;
			}
		}
		if (handledClick)
		{
			updateGraphics();
		}
	}

	public function handleCategoryClick(i:Int):Bool
	{
		if (categoryFrames[i].visible
		&& categoryFrames[i].getHitbox().containsPoint(FlxG.mouse.getPosition()))
		{
			selectedCategoryIndex = categorySprites[i].animation.frameIndex;
			return true;
		}
		return false;
	}

	public function handleIconClick(i:Int):Bool
	{
		if (categorizedGloveFrames[selectedCategoryIndex][i].visible
		&& categorizedGloveFrames[selectedCategoryIndex][i].getHitbox().containsPoint(FlxG.mouse.getPosition()))
		{
			PlayerData.cursorFillColor = categorizedGloveColors[selectedCategoryIndex][i].fillColor;
			PlayerData.cursorLineColor = categorizedGloveColors[selectedCategoryIndex][i].lineColor;
			PlayerData.cursorMinAlpha = categorizedGloveColors[selectedCategoryIndex][i].minAlpha;
			PlayerData.cursorMaxAlpha = categorizedGloveColors[selectedCategoryIndex][i].maxAlpha;
			PlayerData.cursorInsulated = categorizedGloveColors[selectedCategoryIndex][i].insulated;

			CursorUtils.initializeHandSprite(_state._handSprite, AssetPaths.hands__png);
			_state._handSprite.setSize(3, 3);
			_state._handSprite.offset.set(69, 87);

			_state.handOpacityTween0 = FlxTweenUtil.retween(_state.handOpacityTween0, _state._handSprite, {alpha:PlayerData.cursorMinAlpha}, 0.5, {ease:FlxEase.circOut, startDelay:0.5});
			_state.handOpacityTween1 = FlxTweenUtil.retween(_state.handOpacityTween1, _state._handSprite, {alpha:PlayerData.cursorMaxAlpha}, 0.5, {ease:FlxEase.circOut, startDelay:2.0});

			return true;
		}
		return false;
	}

	public function updateGraphics()
	{
		for (c in 0...categoryFrames.length)
		{
			var categoryIndex:Int = categorySprites[c].animation.frameIndex;
			categoryFrames[c].animation.frameIndex = (selectedCategoryIndex == categoryIndex) ? 0 : 1;
		}

		for (c in 0...categorySprites.length)
		{
			var categoryIndex:Int = categorySprites[c].animation.frameIndex;
			for (i in 0...categorizedGloveColors[categoryIndex].length)
			{
				categorizedGloveSprites[categoryIndex][i].visible = (selectedCategoryIndex == categoryIndex);
				categorizedGloveFrames[categoryIndex][i].visible = (selectedCategoryIndex == categoryIndex);
			}
		}

		for (i in 0...categorizedGloveColors[selectedCategoryIndex].length)
		{
			if (isCurrentGloveColor(categorizedGloveColors[selectedCategoryIndex][i]))
			{
				// it's enabled...
				categorizedGloveFrames[selectedCategoryIndex][i].animation.frameIndex = 0;
			}
			else
			{
				// it's disabled...
				categorizedGloveFrames[selectedCategoryIndex][i].animation.frameIndex = 1;
			}
		}

		for (i in 0...gloveColors.length)
		{
			tableGloveSprites[i].visible = !isCurrentGloveColor(gloveColors[i]);
			tableGloveShadows[i].visible = tableGloveSprites[i].visible;
		}
	}

	private function isCurrentGloveColor(gloveColor:GloveColor)
	{
		return PlayerData.cursorFillColor == gloveColor.fillColor
			   && PlayerData.cursorLineColor == gloveColor.lineColor
			   && PlayerData.cursorMinAlpha == gloveColor.minAlpha
			   && PlayerData.cursorMaxAlpha == gloveColor.maxAlpha
			   && PlayerData.cursorInsulated == gloveColor.insulated;
	}
}

typedef GloveColor =
{
	lineColor:Int,
	fillColor:Int,
	minAlpha:Float,
	maxAlpha:Float,
	insulated:Bool
}