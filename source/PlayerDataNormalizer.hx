package;

import flixel.FlxG;

/**
 * Makes adjustments to fix a player's save data.
 *
 * There are certain rules about how often Pokemon show up, which items are for
 * sale in Heracross's shop, and how horny different Pokemon are. Some of those
 * rules might get broken briefly if a player purchases a sex toy or an item
 * which makes a Pokemon show up more often. It could also happen if their save
 * data gets messed up because of a glitch in the program, or because they
 * hacked their save file.
 *
 * This class fixes the player's save data so the rules apply again.
 */
class PlayerDataNormalizer
{
	/**
	 * If the player hasn't purchased any toys for a particular Pokemon, that
	 * Pokemon's toy reservoir should be -1. Otherwise, it should be >= 0.
	 */
	public static function normalizeToyReservoirs()
	{
		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_SMALL_GREY_BEADS)
				|| ItemDatabase.playerHasItem(ItemDatabase.ITEM_SMALL_PURPLE_BEADS))
		{
			if (PlayerData.abraToyReservoir == -1)
			{
				PlayerData.abraToyReservoir = 178; // [61-179]
			}
		}
		else
		{
			PlayerData.abraToyReservoir = -1;
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_BLUE_DILDO)
				|| ItemDatabase.playerHasItem(ItemDatabase.ITEM_GUMMY_DILDO))
		{
			if (PlayerData.buizToyReservoir == -1)
			{
				PlayerData.buizToyReservoir = 156; // [61, 179]
			}
		}
		else
		{
			PlayerData.buizToyReservoir = -1;
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_VIBRATOR))
		{
			if (PlayerData.heraToyReservoir == -1)
			{
				PlayerData.heraToyReservoir = 153; // [61, 179]
			}
		}
		else
		{
			PlayerData.heraToyReservoir = -1;
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_VIBRATOR))
		{
			if (PlayerData.grovToyReservoir == -1)
			{
				PlayerData.grovToyReservoir = 143; // [61-179]
			}
		}
		else
		{
			PlayerData.grovToyReservoir = -1;
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_HUGE_DILDO))
		{
			if (PlayerData.sandToyReservoir == -1)
			{
				PlayerData.sandToyReservoir = 159; // [61-179]
			}
		}
		else
		{
			PlayerData.sandToyReservoir = -1;
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_LARGE_GLASS_BEADS)
				|| ItemDatabase.playerHasItem(ItemDatabase.ITEM_LARGE_GREY_BEADS))
		{
			if (PlayerData.rhydToyReservoir == -1)
			{
				PlayerData.rhydToyReservoir = 149; // [61-179]
			}
		}
		else
		{
			PlayerData.rhydToyReservoir = -1;
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_VIBRATOR))
		{
			if (PlayerData.smeaToyReservoir == -1)
			{
				PlayerData.smeaToyReservoir = 52; // [0-60]
			}
		}
		else
		{
			PlayerData.smeaToyReservoir = -1;
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_SMALL_PURPLE_BEADS))
		{
			if (PlayerData.magnToyReservoir == -1)
			{
				PlayerData.magnToyReservoir = 131; // [61-179]
			}
		}
		else
		{
			PlayerData.magnToyReservoir = -1;
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_BLUE_DILDO)
				|| ItemDatabase.playerHasItem(ItemDatabase.ITEM_GUMMY_DILDO))
		{
			if (PlayerData.grimToyReservoir == -1)
			{
				PlayerData.grimToyReservoir = 115; // [61-179]
			}
		}
		else
		{
			PlayerData.grimToyReservoir = -1;
		}

		if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_BLUE_DILDO)
				|| ItemDatabase.playerHasItem(ItemDatabase.ITEM_GUMMY_DILDO)
				|| ItemDatabase.playerHasItem(ItemDatabase.ITEM_HUGE_DILDO))
		{
			PlayerData.lucaToyReservoir = 155; // [61-179]
		}
		else
		{
			PlayerData.lucaToyReservoir = -1;
		}
	}

	/**
	 * Should have 10 * luckyProfCount total entries in the array
	 *
	 * Should have 1 entry for each prof (or 3 if phone number is unlocked)
	 */
	public static function normalizeLuckyProfSchedules()
	{
		if (PlayerData.luckyProfSchedules.length == 0)
		{
			PlayerData.luckyProfSchedules.push( -1);
		}
		var actualCounts:Map<Int, Int> = new Map<Int, Int>();
		for (luckyProf in PlayerData.luckyProfSchedules)
		{
			if (!actualCounts.exists(luckyProf))
			{
				actualCounts[luckyProf] = 0;
			}
			actualCounts[luckyProf] = actualCounts[luckyProf] + 1;
		}

		/**
		 * while there's a lot of -1s in the array, -1s always get dropped at the end, while
		 * "jackpots" get inserted somewhere in the back half.
		 *
		 * default: x x x x x x x x x x 8 (every 38 minutes, you see a lucky professor)
		 * items: x x 8 x x x 8 x x x 8 x x (every 13 minutes, you see a lucky professor)
		 */
		var expectedCounts:Map<Int, Int> = new Map<Int, Int>();
		expectedCounts[-1] = 0;

		expectedCounts[PlayerData.PROF_PREFIXES.indexOf("magn")] = ItemDatabase.playerHasItem(ItemDatabase.ITEM_MAGNETIC_DESK_TOY) ? 3 : 1;
		expectedCounts[-1] += 10;

		expectedCounts[PlayerData.PROF_PREFIXES.indexOf("hera")] = ItemDatabase.playerHasItem(ItemDatabase.ITEM_RETROPIE) ? 3 : 1;
		expectedCounts[-1] += 10;

		expectedCounts[PlayerData.PROF_PREFIXES.indexOf("grim")] = ItemDatabase.playerHasItem(ItemDatabase.ITEM_HAPPY_MEAL) ? 3 : 1;
		expectedCounts[-1] += 10;

		expectedCounts[PlayerData.PROF_PREFIXES.indexOf("luca")] = ItemDatabase.playerHasItem(ItemDatabase.ITEM_PIZZA_COUPONS) ? 3 : 1;
		expectedCounts[-1] += 10;

		for (key in expectedCounts.keys())
		{
			var expectedCount:Int = expectedCounts.exists(key) ? expectedCounts[key] : 0;
			var actualCount:Int = actualCounts.exists(key) ? actualCounts[key] : 0;

			while (actualCount < expectedCount)
			{
				var index:Int = FlxG.random.int(1, PlayerData.luckyProfSchedules.length);
				PlayerData.luckyProfSchedules.insert(index, key);
				actualCount++;
			}
			while (actualCount > expectedCount)
			{
				var startIndex:Int = FlxG.random.int(1, PlayerData.luckyProfSchedules.length);
				var index:Int = PlayerData.luckyProfSchedules.indexOf(key, startIndex);
				if (index == -1)
				{
					index = PlayerData.luckyProfSchedules.indexOf(key);
				}
				if (index == -1)
				{
					// item not found, or maybe it's in index 0; don't worry about it this time
				}
				else
				{
					PlayerData.luckyProfSchedules.splice(index, 1);
					actualCount--;
				}
			}
		}
	}

	/**
	 * All items should be present in warehouse, inventory, or shop. Items
	 * should always have an index within the bounds of "itemTypes" array.
	 *
	 * This will get broken as new items unlock, and need to be added to the
	 * warehouse.
	 *
	 * This could also get broken if someone loaded a new version of the game
	 * with different items, or if their save was corrupted somehow.
	 */
	public static function normalizeItems()
	{
		// initialize kecleon dialog
		BadItemDescriptions.initialize();

		var startString:String = "warehouse=" + ItemDatabase._warehouseItemIndexes + " player=" + ItemDatabase._playerItemIndexes + " shop=" + ItemDatabase._shopItems;
		// remove duplicate item indexes from player inventory
		{
			var newPlayerItemIndexes = [];
			for (playerItemIndex in ItemDatabase._playerItemIndexes)
			{
				if (newPlayerItemIndexes.indexOf(playerItemIndex) == -1)
				{
					newPlayerItemIndexes.push(playerItemIndex);
				}
			}
			ItemDatabase._playerItemIndexes = newPlayerItemIndexes;
		}
		// remove bogus item indexes
		ItemDatabase._warehouseItemIndexes = ItemDatabase._warehouseItemIndexes.filter(function(i) return i >= 0 && i < ItemDatabase._itemTypes.length && !ItemDatabase.isLocked(i));
		ItemDatabase._playerItemIndexes = ItemDatabase._playerItemIndexes.filter(function(i) return i >= 0 && i < ItemDatabase._itemTypes.length);
		ItemDatabase._shopItems = ItemDatabase._shopItems.filter(function(shopItem) return shopItem._itemIndex < 0 || shopItem._itemIndex < ItemDatabase._itemTypes.length && !ItemDatabase.isLocked(shopItem._itemIndex));

		// add missing item indexes
		var missingItemIndexes:Array<Int> = ItemDatabase.getAllItemIndexes();
		// locked items aren't "missing"... they're not a mistake we need to fix
		missingItemIndexes = missingItemIndexes.filter(function(s) {return ItemDatabase.isLocked(s) != true; });
		for (i in ItemDatabase._playerItemIndexes)
		{
			if (PlayerData.grimEatenItem == i)
			{
				// if grimer ate an item, it counts as missing and should appear in the warehouse
			}
			else
			{
				missingItemIndexes.remove(i);
			}
		}
		for (i in ItemDatabase._warehouseItemIndexes) missingItemIndexes.remove(i);
		for (shopItem in ItemDatabase._shopItems) missingItemIndexes.remove(shopItem._itemIndex);
		for (missingItemIndex in missingItemIndexes)
		{
			ItemDatabase._warehouseItemIndexes.insert(FlxG.random.int(0, ItemDatabase._warehouseItemIndexes.length), missingItemIndex);
		}
		var endString:String = "warehouse=" + ItemDatabase._warehouseItemIndexes + " player=" + ItemDatabase._playerItemIndexes + " shop=" + ItemDatabase._shopItems;
		if (endString != startString)
		{
			trace("item database normalized:");
			trace(startString);
			trace(" -->");
			trace(endString);
		}
	}
}