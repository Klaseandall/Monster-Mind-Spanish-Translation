package;
import flixel.FlxG;
import flixel.math.FlxMath;
import poke.hera.HeraShopDialog;
import kludge.BetterFlxRandom;

/**
 * ItemDatabase keeps track of which items are purchased, unpurchased, and
 * available in the shop.
 */
class ItemDatabase
{
	private static var MIN_REFILL_TIME:Float = 1000 * 60 * 6; // 6 minutes

	/*
	 * List of prices Heracross will sell items for
	 */
	public static var PRICES:Array<Int> = [50, 55, 60, 65, 70, 75, 80, 85, 90,
										   100, 110, 115, 120, 130, 140, 150, 160, 170, 180, 190, 200, 220, 240, 260, 275, 300, 320, 340, 360, 380,
										   400, 425, 450, 475, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2200,
										   2400, 2600, 2750, 3000, 3200, 3400, 3600, 3800, 4000, 4250, 4500, 4750, 5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500, 9000, 9500, 10000,
										   11000, 12000, 13000, 14000, 15000, 16000, 17000, 18000, 19000, 20000, 22000, 24000, 26000, 27500, 30000, 32000, 34000, 36000, 38000, 40000,
										   42500, 45000, 47500, 50000, 55000, 60000, 65000, 70000, 75000, 80000, 85000, 90000, 95000, 99999];

	public static var ITEM_COOKIES:Int = 0;
	public static var ITEM_CALCULATOR:Int = 0;
	public static var ITEM_HYDROGEN_PEROXIDE:Int = 0;
	public static var ITEM_ACETONE:Int = 0;
	public static var ITEM_INCENSE:Int = 0;
	public static var ITEM_GOLD_PUZZLE_KEY:Int = 0;
	public static var ITEM_DIAMOND_PUZZLE_KEY:Int = 0;
	public static var ITEM_MARS_SOFTWARE:Int = 0;
	public static var ITEM_VENUS_SOFTWARE:Int = 0;
	public static var ITEM_MAGNETIC_DESK_TOY:Int = 0;
	public static var ITEM_SMALL_GREY_BEADS:Int = 0;
	public static var ITEM_SMALL_PURPLE_BEADS:Int = 0;
	public static var ITEM_LARGE_GLASS_BEADS:Int = 0;
	public static var ITEM_LARGE_GREY_BEADS:Int = 0;
	public static var ITEM_FRUIT_BUGS:Int = 0;
	public static var ITEM_MARSHMALLOW_BUGS:Int = 0;
	public static var ITEM_SPOOKY_BUGS:Int = 0;
	public static var ITEM_RETROPIE:Int = 0;
	public static var ITEM_ASSORTED_GLOVES:Int = 0;
	public static var ITEM_INSULATED_GLOVES:Int = 0;
	public static var ITEM_GHOST_GLOVES:Int = 0;
	public static var ITEM_VANISHING_GLOVES:Int = 0;
	public static var ITEM_STREAMING_PACKAGE:Int = 0;
	public static var ITEM_VIBRATOR:Int = 0;
	public static var ITEM_BLUE_DILDO:Int = 0;
	public static var ITEM_GUMMY_DILDO:Int = 0;
	public static var ITEM_HUGE_DILDO:Int = 0;
	public static var ITEM_HAPPY_MEAL:Int = 0;
	public static var ITEM_PIZZA_COUPONS:Int = 0;

	/**
	 * Has the player solved a set of puzzles since we last restocked?
	 */
	public static var _solvedPuzzle:Bool = false;

	/**
	 * When's the last time we last restocked?
	 */
	public static var _prevRefillTime:Float = 0;

	public static var _itemTypes:Array<ItemType> =
	{
		var _tmpItems = [];

		_tmpItems.push( { name:"Cornstarch Cookies", basePrice:900, shopImage:AssetPaths.cookies_shop__png, dialog:HeraShopDialog.cornstarchCookies, index:ITEM_COOKIES=_tmpItems.length } );
		_tmpItems.push( { name:"Graphing Calculator", basePrice:2200, shopImage:AssetPaths.calculator_shop__png, dialog:HeraShopDialog.calculator, index:ITEM_CALCULATOR=_tmpItems.length } );
		_tmpItems.push( { name:"Hydrogen Peroxide", basePrice:750, shopImage:AssetPaths.hydrogen_peroxide_shop__png, dialog:HeraShopDialog.hydrogenPeroxide, index:ITEM_HYDROGEN_PEROXIDE=_tmpItems.length } );
		_tmpItems.push( { name:"Acetone", basePrice:750, shopImage:AssetPaths.acetone_shop__png, dialog:HeraShopDialog.acetone, index:ITEM_ACETONE=_tmpItems.length } );
		_tmpItems.push( { name:"Romantic Incense", basePrice:3400, shopImage:AssetPaths.incense_shop__png, dialog:HeraShopDialog.romanticIncense, index:ITEM_INCENSE=_tmpItems.length } );
		_tmpItems.push( { name:"Puzzle Keys", basePrice:1400, shopImage:AssetPaths.gold_puzzle_key_shop__png, dialog:HeraShopDialog.goldPuzzleKey, index:ITEM_GOLD_PUZZLE_KEY=_tmpItems.length } );
		_tmpItems.push( { name:"Diamond Puzzle Key", basePrice:4000, shopImage:AssetPaths.diamond_puzzle_key_shop__png, dialog:HeraShopDialog.diamondPuzzleKey, index:ITEM_DIAMOND_PUZZLE_KEY=_tmpItems.length } );
		_tmpItems.push( { name:"Mars Software", basePrice:1100, shopImage:AssetPaths.boy_software_shop__png, dialog:HeraShopDialog.marsSoftware, index:ITEM_MARS_SOFTWARE=_tmpItems.length } );
		_tmpItems.push( { name:"Venus Software", basePrice:1100, shopImage:AssetPaths.girl_software_shop__png, dialog:HeraShopDialog.venusSoftware, index:ITEM_VENUS_SOFTWARE=_tmpItems.length } );
		_tmpItems.push( { name:"Magnetic Desk Toy", basePrice:1600, shopImage:AssetPaths.magnetic_desk_toy_shop__png, dialog:HeraShopDialog.magneticDeskToy, index:ITEM_MAGNETIC_DESK_TOY=_tmpItems.length } );

		_tmpItems.push( { name:"Grey Anal Beads", basePrice:1400, shopImage:AssetPaths.small_grey_beads_shop__png, dialog:HeraShopDialog.smallGreyBeads, index:ITEM_SMALL_GREY_BEADS=_tmpItems.length } ); // "intro" abra anal beads
		_tmpItems.push( { name:"Purple Anal Beads", basePrice:3000, shopImage:AssetPaths.small_purple_beads_shop__png, dialog:HeraShopDialog.smallPurpleBeads, index:ITEM_SMALL_PURPLE_BEADS=_tmpItems.length } ); // "expert" abra anal beads
		_tmpItems.push( { name:"Huge Glass Anal Beads", basePrice:2400, shopImage:AssetPaths.xl_glass_beads_shop__png, dialog:HeraShopDialog.largeGlassBeads, index:ITEM_LARGE_GLASS_BEADS=_tmpItems.length } ); // "intro" rhydon anal beads
		_tmpItems.push( { name:"Huge Grey Anal Beads", basePrice:4250, shopImage:AssetPaths.xl_grey_beads_shop__png, dialog:HeraShopDialog.largeGreyBeads, index:ITEM_LARGE_GREY_BEADS=_tmpItems.length } ); // "expert" rhydon anal beads

		_tmpItems.push( { name:"Fruit Bugs", basePrice:300, shopImage:AssetPaths.placeholder_shop__png, dialog:HeraShopDialog.fruitBugs, index:ITEM_FRUIT_BUGS = _tmpItems.length } );
		_tmpItems.push( { name:"Marshmallow Bugs", basePrice:700, shopImage:AssetPaths.placeholder_shop__png, dialog:HeraShopDialog.marshmallowBugs, index:ITEM_MARSHMALLOW_BUGS = _tmpItems.length } );
		_tmpItems.push( { name:"Spooky Bugs", basePrice:2200, shopImage:AssetPaths.placeholder_shop__png, dialog:HeraShopDialog.spookyBugs, index:ITEM_SPOOKY_BUGS = _tmpItems.length } );
		_tmpItems.push( { name:"RetroPie", basePrice:6500, shopImage:AssetPaths.retropie_shop__png, dialog:HeraShopDialog.retroPie, index:ITEM_RETROPIE = _tmpItems.length } );

		_tmpItems.push( { name:"Assorted Gloves", basePrice:240, shopImage:AssetPaths.assorted_gloves_shop__png, dialog:HeraShopDialog.assortedGloves, index:ITEM_ASSORTED_GLOVES = _tmpItems.length } );
		_tmpItems.push( { name:"Insulated Gloves", basePrice:150, shopImage:AssetPaths.insulated_gloves_shop__png, dialog:HeraShopDialog.insulatedGloves, index:ITEM_INSULATED_GLOVES = _tmpItems.length } );
		_tmpItems.push( { name:"Ghost Gloves", basePrice:500, shopImage:AssetPaths.ghost_gloves_shop__png, dialog:HeraShopDialog.ghostGloves, index:ITEM_GHOST_GLOVES = _tmpItems.length } );
		_tmpItems.push( { name:"Vanishing Gloves", basePrice:750, shopImage:AssetPaths.vanishing_gloves_shop__png, dialog:HeraShopDialog.vanishingGloves, index:ITEM_VANISHING_GLOVES = _tmpItems.length } );

		_tmpItems.push( { name:"Streaming Package", basePrice:8500, shopImage:AssetPaths.streaming_package_shop__png, dialog:HeraShopDialog.streamingPackage, index:ITEM_STREAMING_PACKAGE = _tmpItems.length } );
		_tmpItems.push( { name:"Vibrator", basePrice:3800, shopImage:AssetPaths.vibe_shop__png, dialog:HeraShopDialog.vibrator, index:ITEM_VIBRATOR = _tmpItems.length } );

		_tmpItems.push( { name:"Blue Dildo", basePrice:1200, shopImage:AssetPaths.blue_dildo_shop__png, dialog:HeraShopDialog.blueDildo, index:ITEM_BLUE_DILDO = _tmpItems.length } );
		_tmpItems.push( { name:"Gummy Dildo", basePrice:1900, shopImage:AssetPaths.gummy_dildo_shop__png, dialog:HeraShopDialog.gummyDildo, index:ITEM_GUMMY_DILDO = _tmpItems.length } );
		_tmpItems.push( { name:"Huge Dildo", basePrice:6000, shopImage:AssetPaths.xl_dildo_shop__png, dialog:HeraShopDialog.hugeDildo, index:ITEM_HUGE_DILDO = _tmpItems.length } );
		_tmpItems.push( { name:"Happy Meal Toys", basePrice:140, shopImage:AssetPaths.happymeal_shop__png, dialog:HeraShopDialog.happyMeal, index:ITEM_HAPPY_MEAL = _tmpItems.length } );

		_tmpItems.push( { name:"Pizza Coupons", basePrice:1200, shopImage:AssetPaths.pizza_coupons_shop__png, dialog:HeraShopDialog.pizzaCoupons, index:ITEM_PIZZA_COUPONS= _tmpItems.length } );

		_tmpItems;
	};

	public static var _warehouseItemIndexes:Array<Int>;
	public static var _shopItems:Array<ShopItem>;
	public static var _newItems:Bool = true;
	public static var _playerItemIndexes:Array<Int> = [];
	public static var _mysteryBoxStatus:Int = 0;
	public static var _magnezoneStatus:MagnezoneStatus = MagnezoneStatus.Absent;
	public static var _kecleonPresent:Bool = false;

	/**
	 * 2 boxes: telephone shows up
	 * 5 boxes: lucario can fit the huge dildo, but doesn't enjoy it very much
	 * 8 boxes: electric vibe item available
	 * 11 boxes: lucario can enjoy huge dildo
	 * 11 boxes: can call sandslash on phone
	 *
	 * @return The number of mystery boxes which have been purchased
	 */
	public static function getPurchasedMysteryBoxCount():Int
	{
		return Std.int(Math.max(0, _mysteryBoxStatus - 1));
	}

	public static function isLocked(index:Int):Bool
	{
		var unlockedItems:Map<Int, Bool> = new Map<Int, Bool>();
		unlockedItems[ITEM_MAGNETIC_DESK_TOY] = PlayerData.hasMet("magn");
		unlockedItems[ITEM_RETROPIE] = PlayerData.hasMet("hera");
		unlockedItems[ITEM_HAPPY_MEAL] = PlayerData.recentChatCount("grim.randomChats.0.4") > 0;
		unlockedItems[ITEM_PIZZA_COUPONS] = PlayerData.hasMet("luca") && PlayerData.hasMet("rhyd");
		return unlockedItems[index] == false;
	}

	public static function getAllItemIndexes():Array<Int>
	{
		var _tmpItemIndexes = [];
		for (i in 0..._itemTypes.length)
		{
			_tmpItemIndexes.push(i);
		}
		FlxG.random.shuffle(_tmpItemIndexes);
		return _tmpItemIndexes;
	}

	public static function refillShop():Void
	{
		var shouldRefillItems:Bool = false;
		var shouldRotateStaff:Bool = false;

		if (_prevRefillTime == 0)
		{
			// first time; fill the shop with its initial stock
			shouldRefillItems = true;
			shouldRotateStaff = true;
		}
		else {
			var timeSinceLastRestock:Float = MmTools.time() - _prevRefillTime;
			if (timeSinceLastRestock < 0)
			{
				/*
				 * prefRefillTime is in the future; reset it. This avoids a
				 * scenario where a player might cheat their clock into the
				 * future, and then never see any new items again
				 */
				_prevRefillTime = MmTools.time();
			}
			shouldRotateStaff = _solvedPuzzle;
			shouldRefillItems = _solvedPuzzle && timeSinceLastRestock >= MIN_REFILL_TIME;
			_solvedPuzzle = false;
		}

		if (shouldRotateStaff)
		{
			rotateStaff();
		}

		if (shouldRefillItems)
		{
			refillItems();
		}
	}

	public static function rotateStaff():Void
	{
		// is kecleon present?
		if (PlayerData.professors.indexOf(PlayerData.PROF_PREFIXES.indexOf("hera")) != -1)
		{
			// kecleon runs the store if heracross is out
			_kecleonPresent = true;
		}
		else if (!PlayerData.hasMet("smea"))
		{
			// kecleon doesn't show up until player interacts with smeargle
			_kecleonPresent = false;
		}
		else if (ItemDatabase._playerItemIndexes.length == 0)
		{
			// kecleon doesn't show up until player visits the store
			_kecleonPresent = false;
		}
		else if (FlxG.random.bool(8))
		{
			// kecleon shows up if you're really lucky
			_kecleonPresent = true;
		}
		else {
			_kecleonPresent = false;
		}
		if (_kecleonPresent)
		{
			BadItemDescriptions.initialize(true);
			LevelIntroDialog.rotateProfessors([PlayerData.prevProfPrefix, "smea"], false);

			if (PlayerData.keclStoreChat == 0)
			{
				PlayerData.keclStoreChat = 10;
			}
			else if (PlayerData.keclStoreChat % 2 == 1)
			{
				PlayerData.keclStoreChat += 1;
				if (PlayerData.keclStoreChat % 10 >= 5)
				{
					// don't let it get too big
					PlayerData.keclStoreChat -= 2;
				}
			}
		}

		// is magnezone present?
		if (_kecleonPresent)
		{
			// magnezone doesn't harass kecleon
			_magnezoneStatus = MagnezoneStatus.Absent;
		}
		else if (PlayerData.keclStoreChat >= 10 && PlayerData.keclStoreChat < 20)
		{
			// heracross needs to give his "how was kecleon?" speech. magnezone is absent
			_magnezoneStatus = MagnezoneStatus.Absent;
		}
		else if (FlxG.random.bool(65))
		{
			// magnezone is usually absent
			_magnezoneStatus = MagnezoneStatus.Absent;
		}
		else if (PlayerData.luckyProfSchedules[0] == PlayerData.PROF_PREFIXES.indexOf("magn"))
		{
			// magnezone is the current lucky professor; he's not in the shop
			_magnezoneStatus = MagnezoneStatus.Absent;
		}
		else if (!PlayerData.startedTaping)
		{
			// haven't started taping yet; one thing at a time
			_magnezoneStatus = MagnezoneStatus.Absent;
		}
		else if (PlayerData.denProf == PlayerData.PROF_PREFIXES.indexOf("magn"))
		{
			// magnezone's in the den; not in the shop
			_magnezoneStatus = MagnezoneStatus.Absent;
		}
		else {
			var magnMood:Float = 0;
			magnMood += PlayerData.chatHistory.filter(function(s) { return s != null && StringTools.startsWith(s, "magn"); } ).length * 10; // ~50 each time you play with magnezone
			magnMood += _playerItemIndexes.length * 8; // 0-200 or so
			magnMood += PlayerData.magnButtPlug * 5; // 0-70 or so
			magnMood += playerHasItem(ITEM_MAGNETIC_DESK_TOY) ? 50 : 0;
			magnMood *= FlxG.random.float(0.6, 1.0);
			if (magnMood < 30)
			{
				_magnezoneStatus = MagnezoneStatus.Angry;
			}
			else if (magnMood < 150)
			{
				_magnezoneStatus = MagnezoneStatus.Suspicious;
			}
			else if (magnMood < 350)
			{
				_magnezoneStatus = MagnezoneStatus.Calm;
			}
			else {
				_magnezoneStatus = MagnezoneStatus.Happy;
			}
			if (PlayerData.magnButtPlug % 2 == 1 && PlayerData.magnButtPlug <= 5)
			{
				PlayerData.magnButtPlug++;
				if (_magnezoneStatus == MagnezoneStatus.Angry || _magnezoneStatus == MagnezoneStatus.Suspicious)
				{
					_magnezoneStatus = MagnezoneStatus.Calm;
				}
			}
		}
	}

	public static function refillItems():Void
	{
		// if items have been unlocked, we unlock them
		PlayerDataNormalizer.normalizeItems();

		_prevRefillTime = MmTools.time();
		var prunedInventory:Bool = false;
		var i:Int = 0;
		while (i < _shopItems.length)
		{
			if (_shopItems[i]._discount >= 5 || _shopItems[i]._discount <= -5)
			{
				_warehouseItemIndexes.push(_shopItems[i]._itemIndex);
				_shopItems.remove(_shopItems[i]);
				prunedInventory = true;
			}
			else
			{
				i++;
			}
		}
		if (_shopItems.length < 5 && _warehouseItemIndexes.length > 0 && !prunedInventory)
		{
			_newItems = true;
			addShopItem();
		}
		while (_shopItems.length < 3 && _warehouseItemIndexes.length > 0)
		{
			_newItems = true;
			addShopItem();
		}

		var playerHasAllItems:Bool = true;
		for (itemType in _itemTypes)
		{
			if (!playerHasItem(itemType.index))
			{
				playerHasAllItems = false;
			}
		}
		if (playerHasAllItems)
		{
			// player has purchased every item. ...mystery box time!
			if (_mysteryBoxStatus <= 0)
			{
				_mysteryBoxStatus = 1;
			}
			var mysteryBoxInShop:Bool = false;
			for (shopItem in _shopItems)
			{
				if (Std.isOfType(shopItem, MysteryBoxShopItem))
				{
					mysteryBoxInShop = true;
				}
			}
			if (!mysteryBoxInShop)
			{
				_shopItems.insert(0, new ItemDatabase.MysteryBoxShopItem());
				_newItems = true;
			}
		}
		if (playerHasAllItems && ItemDatabase.getPurchasedMysteryBoxCount() >= 2)
		{
			// player has purchased every item, and two mystery boxes... telephone time!
			var telephoneInShop:Bool = false;
			for (shopItem in _shopItems)
			{
				if (Std.isOfType(shopItem, TelephoneShopItem))
				{
					telephoneInShop = true;
				}
			}
			if (!telephoneInShop)
			{
				_shopItems.insert(0, new ItemDatabase.TelephoneShopItem());
				_newItems = true;
			}
		}

		var clearance:Bool = _shopItems.length == 5;
		var discountArray:Array<ShopItem> = _shopItems.copy();
		if (clearance)
		{
			var cheapItem:ShopItem = BetterFlxRandom.getObject(discountArray, discountArray.length - 2, discountArray.length - 1);
			discountArray.remove(cheapItem);
			var expensiveItem:ShopItem = discountArray[discountArray.length - 1];
			discountArray.remove(expensiveItem);
			FlxG.random.shuffle(discountArray);
			discountArray.insert(0, cheapItem);
			discountArray.push(expensiveItem);
		}
		else {
			FlxG.random.shuffle(discountArray);
		}
		for (i in 0...discountArray.length)
		{
			discountArray[i]._discount = Std.int(FlxMath.bound(FlxG.random.int( i - 2, i + 2), -4, 4));
		}
		if (clearance)
		{
			discountArray[0]._discount = FlxG.random.int( -9, -5);
			discountArray[4]._discount = FlxG.random.int( 5, 7);
		}
	}

	/**
	 * Add a new shop item. We will usually look at the next 3 items in the
	 * warehouse and pick the cheapest one. But, we will have one expensive
	 * item in the shop too, which we find by just grabbing the next random
	 * item from the warehouse regardless of price.
	 */
	public static function addShopItem():Void
	{
		var anyExpensive:Bool = false;
		for (shopItem in _shopItems)
		{
			anyExpensive = shopItem._expensive || anyExpensive;
		}
		var itemBrowseCount:Int = Std.int(Math.min(_warehouseItemIndexes.length, anyExpensive ? 3 : 1));
		var cheapItemIndex:Null<Int> = null;
		for (i in 0...itemBrowseCount)
		{
			var expensiveItemIndex:Null<Int> = _warehouseItemIndexes[0];
			_warehouseItemIndexes.remove(expensiveItemIndex);
			if (cheapItemIndex == null || _itemTypes[cheapItemIndex].basePrice > _itemTypes[expensiveItemIndex].basePrice)
			{
				var tempItemIndex:Null<Int> = cheapItemIndex;
				cheapItemIndex = expensiveItemIndex;
				expensiveItemIndex = tempItemIndex;
			}
			if (expensiveItemIndex != null)
			{
				_warehouseItemIndexes.push(expensiveItemIndex);
			}
		}
		if (cheapItemIndex != null)
		{
			var shopItem:ShopItem = new ShopItem(cheapItemIndex);
			shopItem._expensive = !anyExpensive;
			_shopItems.insert(0, shopItem);
		}
	}


	public static function playerHasItem(item:Int)
	{
		return _playerItemIndexes.indexOf(item) != -1;
	}

	public static function playerHasUneatenItem(item:Int)
	{
		return _playerItemIndexes.indexOf(item) != -1 && item != PlayerData.grimEatenItem;
	}

	public static function isMagnezonePresent()
	{
		return _magnezoneStatus != MagnezoneStatus.Absent;
	}

	public static function isKecleonPresent()
	{
		return _kecleonPresent;
	}

	public static function getItemCount():Int
	{
		return ItemDatabase._itemTypes.length;
	}

	public static function roundUpPrice(price:Float, ?discount:Int=0)
	{
		var priceIndex:Int = 0;
		while (ItemDatabase.PRICES[priceIndex] < price)
		{
			priceIndex++;
		}
		priceIndex = Std.int(FlxMath.bound(discount + priceIndex, 0, ItemDatabase.PRICES.length - 1));
		return ItemDatabase.PRICES[priceIndex];
	}
}

/**
 * An item in the warehouse -- Heracross hasn't put this item on sale yet. It
 * has a theoretical price which might be adjusted.
 */
typedef ItemType =
{
	name:String,
	basePrice:Int,
	shopImage:Dynamic,
	dialog:Dynamic,
	index:Int
}

/**
 * An item in the shop -- Heracross has put this iutem on sale, and it has a
 * price which fluctuates.
 */
class ShopItem
{
	public var _orderIndex:Int = FlxG.random.int(0, 10000);
	public var _itemIndex:Int = 0;

	// A discount which fluctuates from [-4, 4]. Lower numbers are better
	public var _discount:Int = 0;

	/*
	 * We usually select our stock by taking one of the cheaper items from the
	 * warehouse, except for one token expensive item. Is this item our token
	 * expensive item?
	 */
	public var _expensive:Bool = false;

	public function new(ItemIndex:Int, Discount:Int=0)
	{
		this._itemIndex = ItemIndex;
		this._discount = Discount;
		this._expensive = false;
	}

	public function getPrice():Int
	{
		return ItemDatabase.roundUpPrice(getItemType().basePrice, _discount);
	}

	public function getItemType():ItemType
	{
		return ItemDatabase._itemTypes[_itemIndex];
	}

	public function toString():String
	{
		return "ShopItem " + _itemIndex;
	}
}

/**
 * A mystery box item in the shop. These come in about 9 differently shaped
 * boxes, and contain the rarest most valuable items in the game.
 */
class MysteryBoxShopItem extends ShopItem
{
	static var MYSTERY_BOX_PRICES:Array<Int> = [15000, 5500, 27500, 17000, 5000, 55000, 19000, 14000, 9500, 65000, 30000, 7000, 75000, 10000, 6000, 85000, 90000, 34000, 9000, 7500, 40000, 13000, 36000, 99999, 12000, 8000, 20000, 11000, 45000, 60000, 47500, 80000, 50000, 8500, 18000, 26000, 22000, 70000, 6500, 16000, 38000, 42500, 24000, 95000, 32000];
	static var MYSTERY_BOX_IMAGES:Array<String> = [
				AssetPaths.mystery_box01__png,
				AssetPaths.mystery_box02__png,
				AssetPaths.mystery_box05__png,
				AssetPaths.mystery_box07__png,
				AssetPaths.mystery_box04__png,
				AssetPaths.mystery_box08__png,
				AssetPaths.mystery_box00__png,
				AssetPaths.mystery_box03__png,
				AssetPaths.mystery_box06__png,
				AssetPaths.mystery_box03__png,
				AssetPaths.mystery_box05__png,
				AssetPaths.mystery_box02__png,
				AssetPaths.mystery_box01__png,
				AssetPaths.mystery_box07__png,
				AssetPaths.mystery_box00__png,
				AssetPaths.mystery_box08__png,
				AssetPaths.mystery_box06__png,
				AssetPaths.mystery_box04__png,
				AssetPaths.mystery_box09__png, // wow! fancy box
				AssetPaths.mystery_box06__png,
				AssetPaths.mystery_box04__png,
				AssetPaths.mystery_box01__png,
				AssetPaths.mystery_box00__png,
				AssetPaths.mystery_box02__png,
				AssetPaths.mystery_box07__png,
				AssetPaths.mystery_box08__png,
				AssetPaths.mystery_box05__png,
				AssetPaths.mystery_box03__png,
				AssetPaths.mystery_box07__png,
				AssetPaths.mystery_box00__png,
				AssetPaths.mystery_box03__png,
				AssetPaths.mystery_box04__png,
				AssetPaths.mystery_box01__png,
				AssetPaths.mystery_box05__png,
				AssetPaths.mystery_box06__png,
				AssetPaths.mystery_box02__png,
				AssetPaths.mystery_box08__png,
				AssetPaths.mystery_box10__png // wow! another fancy box
			];

	public function new()
	{
		// item index is -1, -2, -3...
		super(-ItemDatabase._mysteryBoxStatus, 0);
	}

	override public function getPrice():Int
	{
		return MYSTERY_BOX_PRICES[getMysteryBoxIndex() % MYSTERY_BOX_PRICES.length];
	}

	override public function getItemType():ItemType
	{
		return {
			name:"Mystery Box",
			basePrice:getPrice(),
			shopImage:MYSTERY_BOX_IMAGES[getMysteryBoxIndex() % MYSTERY_BOX_IMAGES.length],
			dialog:HeraShopDialog.mysteryBox,
			index:_itemIndex
		};
	}

	/*
	 * Converts our item index of -1, -2, -3... to 0, 1, 2...
	 */
	private function getMysteryBoxIndex()
	{
		if (_itemIndex >= 0)
		{
			return 0;
		}
		return -1 - _itemIndex;
	}
}

/**
 * The telephone item allows the plaeyr to invite a Pokemon of their choice.
 */
class TelephoneShopItem extends ShopItem
{
	static var TELEPHONE_PRICES:Array<Int> = [
				3000, 3200, 3400, 3600, 3800, 4000, 4250, 4500, 4750,
				// 2x middle of the road prices; these prices are the most common
				5000, 5500, 6000, 6500, 7000, 7500, 8000,
				5000, 5500, 6000, 6500, 7000, 7500, 8000,

				8500, 9000, 9500, 10000, 11000, 12000, 13000, 14000, 15000, 16000, 17000, 18000, 19000, 20000];

	public function new()
	{
		super(-100000, 0);
	}

	override public function getPrice():Int
	{
		return TELEPHONE_PRICES[Std.int(Math.abs(
			PlayerData.abraSexyBeforeChat +
			PlayerData.buizSexyBeforeChat +
			PlayerData.rhydSexyBeforeChat +
			PlayerData.sandSexyBeforeChat +
			PlayerData.smeaSexyBeforeChat +
			PlayerData.grovSexyBeforeChat +
			PlayerData.lucaSexyBeforeChat +
			PlayerData.heraSexyBeforeChat +
			PlayerData.magnSexyBeforeChat +
			PlayerData.grimSexyBeforeChat
		) % TELEPHONE_PRICES.length)];
	}

	override public function getItemType():ItemType
	{
		return {
			name:"Phone call",
			basePrice:getPrice(),
			shopImage:AssetPaths.telephone_shop__png,
			dialog:HeraShopDialog.phoneCall,
			index:_itemIndex
		};
	}
}

enum MagnezoneStatus
{
	Absent;
	Angry;
	Suspicious;
	Calm;
	Happy;
}