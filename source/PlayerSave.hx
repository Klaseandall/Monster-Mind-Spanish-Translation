package;

import flixel.FlxG;
import flixel.util.FlxSave;
import openfl.utils.Object;

/**
 * Permanently stores all data for a save slot, including data like
 * conversations the player's had and how much money they have
 */
class PlayerSave
{
	public static var SAVE_FILENAME:String = "MonsterMindSaveSlot";
	public static var SAVE_PATH:String = "/";

	public static function nukeData():Void
	{
		var save:FlxSave = new FlxSave();
		save.bind(SAVE_FILENAME, SAVE_PATH);
		save.erase();
		for (i in 0...3)
		{
			deleteSave(i);
		}
		PlayerData.saveSlot = -1;
	}

	public static function deleteSave(slotIndex:Int):Void
	{
		var save:FlxSave = new FlxSave();
		save.bind(SAVE_FILENAME + slotIndex, SAVE_PATH);
		save.erase();
	}

	/**
	 * If the save data hasn't yet been initialized, this quickloads.
	 *
	 * If no save data is yet available, it also initializes the first quicksave slot.
	 *
	 * Otherwise, it quicksaves.
	 */
	public static function flush():Void
	{
		if (PlayerData.saveSlot != -1)
		{
			// quicksave
			quickSave();
			return;
		}

		var saveSlotSave:FlxSave = new FlxSave();
		saveSlotSave.bind(SAVE_FILENAME, SAVE_PATH);
		if (saveSlotSave.data.slot == null)
		{
			// initialize save slot #0
			saveSlotSave.data.slot = 0;
			saveSlotSave.data.volume = 1.0;
			saveSlotSave.flush();
		}

		// load from save slot
		PlayerData.saveSlot = def(saveSlotSave.data.slot, 0);
		FlxG.sound.volume = def(saveSlotSave.data.volume, 1.0);
		PlayerData.profanity = def(saveSlotSave.data.profanity, true);
		PlayerData.detailLevel = defEnum(PlayerData.DetailLevel, saveSlotSave.data.detailLevel, PlayerData.DetailLevel.Max);
		PlayerData.sfw = def(saveSlotSave.data.sfw, false);

		quickLoad();
	}

	public static function clearTransientData():Void
	{
		PlayerData.denProf = -1;
		PlayerData.finalTrial = false;
	}

	public static function setSaveSlot(slot:Int = -1):Void
	{
		if (slot != -1)
		{
			PlayerData.saveSlot = slot;
		}
		var saveSlotSave:FlxSave = new FlxSave();
		saveSlotSave.bind(SAVE_FILENAME, SAVE_PATH);

		if (saveSlotSave.data.slot != PlayerData.saveSlot)
		{
			// changing save slots; clear transient data
			clearTransientData();
		}

		saveSlotSave.data.slot = PlayerData.saveSlot;
		saveSlotSave.data.volume = FlxG.sound.volume;
		saveSlotSave.data.profanity = PlayerData.profanity;
		saveSlotSave.data.detailLevel = PlayerData.detailLevel;
		saveSlotSave.data.sfw = PlayerData.sfw;
		saveSlotSave.flush();
		quickLoad();
	}

	public static function getSave(slot:Int = -1):FlxSave
	{
		var save:FlxSave = new FlxSave();
		save.bind(SAVE_FILENAME + (slot == -1 ? PlayerData.saveSlot : slot), SAVE_PATH);
		return save;
	}

	public static function getSaveData(slot:Int = -1):Dynamic
	{
		return getSave(slot).data;
	}

	static private function quickSave()
	{
		var save:FlxSave = getSave();
		var saveData:Dynamic = save.data;

		saveData.cash = PlayerData.cash;
		saveData.timePlayed = PlayerData.timePlayed;
		saveData.critterBonus = PlayerData.critterBonus;
		saveData.pokeVideos = PlayerData.pokeVideos;
		saveData.videoCount = PlayerData.videoCount;
		saveData.videoStatus = PlayerData.videoStatus;
		saveData.startedTaping = PlayerData.startedTaping;
		saveData.startedMagnezone = PlayerData.startedMagnezone;
		saveData.magnButtPlug = PlayerData.magnButtPlug;
		saveData.sandPhone = PlayerData.sandPhone;
		saveData.keclStoreChat = PlayerData.keclStoreChat;

		saveData.reservoirReward = PlayerData.reservoirReward;
		saveData.minigameReward = PlayerData.minigameReward;
		saveData.luckyProfReward = PlayerData.luckyProfReward;
		saveData.minigameQueue = PlayerData.minigameQueue;
		saveData.scaleGamePuzzleDifficulty = PlayerData.scaleGamePuzzleDifficulty;
		saveData.scaleGameOpponentDifficulty = PlayerData.scaleGameOpponentDifficulty;

		saveData.denMinigame = PlayerData.denMinigame;
		saveData.denVisitCount = PlayerData.denVisitCount;

		saveData.gender = PlayerData.gender;
		saveData.sexualPreference = PlayerData.sexualPreference;
		saveData.sexualPreferenceLabel = PlayerData.sexualPreferenceLabel;
		saveData.preliminaryName = PlayerData.preliminaryName;
		saveData.name = PlayerData.name;

		saveData.cursorType = PlayerData.cursorType;
		saveData.cursorFillColor = PlayerData.cursorFillColor;
		saveData.cursorLineColor = PlayerData.cursorLineColor;
		saveData.cursorMaxAlpha = PlayerData.cursorMaxAlpha;
		saveData.cursorMinAlpha = PlayerData.cursorMinAlpha;
		saveData.cursorInsulated = PlayerData.cursorInsulated;
		saveData.cursorSmellTimeRemaining = PlayerData.cursorSmellTimeRemaining;

		saveData.chatHistory = PlayerData.chatHistory;

		saveData.abraSexyRecords = PlayerData.abraSexyRecords;
		saveData.abra7PegChats = PlayerData.abra7PegChats;
		saveData.abraChats = PlayerData.abraChats;
		saveData.abraSexyBeforeChat = PlayerData.abraSexyBeforeChat;
		saveData.abra7PegSexyBeforeChat = PlayerData.abra7PegSexyBeforeChat;
		saveData.abraSexyAfterChat = PlayerData.abraSexyAfterChat;
		saveData.abraMale = PlayerData.abraMale;
		saveData.abraReservoir = PlayerData.abraReservoir;
		saveData.abraToyReservoir = PlayerData.abraToyReservoir;
		saveData.abraBeadCapacity = PlayerData.abraBeadCapacity;
		saveData.abraStoryInt = PlayerData.abraStoryInt;

		saveData.buizSexyRecords = PlayerData.buizSexyRecords;
		saveData.buizChats = PlayerData.buizChats;
		saveData.buizSexyBeforeChat = PlayerData.buizSexyBeforeChat;
		saveData.buizSexyAfterChat = PlayerData.buizSexyAfterChat;
		saveData.buizMale = PlayerData.buizMale;
		saveData.buizReservoir = PlayerData.buizReservoir;
		saveData.buizToyReservoir = PlayerData.buizToyReservoir;

		saveData.grovSexyRecords = PlayerData.grovSexyRecords;
		saveData.grovChats = PlayerData.grovChats;
		saveData.grovSexyBeforeChat = PlayerData.grovSexyBeforeChat;
		saveData.grovSexyAfterChat = PlayerData.grovSexyAfterChat;
		saveData.grovMale = PlayerData.grovMale;
		saveData.grovReservoir = PlayerData.grovReservoir;
		saveData.grovToyReservoir = PlayerData.grovToyReservoir;

		saveData.sandSexyRecords = PlayerData.sandSexyRecords;
		saveData.sandChats = PlayerData.sandChats;
		saveData.sandSexyBeforeChat = PlayerData.sandSexyBeforeChat;
		saveData.sandSexyAfterChat = PlayerData.sandSexyAfterChat;
		saveData.sandMale = PlayerData.sandMale;
		saveData.sandReservoir = PlayerData.sandReservoir;
		saveData.sandToyReservoir = PlayerData.sandToyReservoir;

		saveData.rhydSexyRecords = PlayerData.rhydSexyRecords;
		saveData.rhydChats = PlayerData.rhydChats;
		saveData.rhydSexyBeforeChat = PlayerData.rhydSexyBeforeChat;
		saveData.rhydSexyAfterChat = PlayerData.rhydSexyAfterChat;
		saveData.rhydMale = PlayerData.rhydMale;
		saveData.rhydReservoir = PlayerData.rhydReservoir;
		saveData.rhydToyReservoir = PlayerData.rhydToyReservoir;
		saveData.rhydGift = PlayerData.rhydGift;

		saveData.smeaSexyRecords = PlayerData.smeaSexyRecords;
		saveData.smeaChats = PlayerData.smeaChats;
		saveData.smeaSexyBeforeChat = PlayerData.smeaSexyBeforeChat;
		saveData.smeaSexyAfterChat = PlayerData.smeaSexyAfterChat;
		saveData.smeaMale = PlayerData.smeaMale;
		saveData.smeaReservoir = PlayerData.smeaReservoir;
		saveData.smeaToyReservoir = PlayerData.smeaToyReservoir;
		saveData.smeaReservoirBank = PlayerData.smeaReservoirBank;
		saveData.smeaToyReservoirBank = PlayerData.smeaToyReservoirBank;

		saveData.keclMale = PlayerData.keclMale;
		saveData.keclGift = PlayerData.keclGift;

		saveData.magnSexyRecords = PlayerData.magnSexyRecords;
		saveData.magnChats = PlayerData.magnChats;
		saveData.magnSexyBeforeChat = PlayerData.magnSexyBeforeChat;
		saveData.magnSexyAfterChat = PlayerData.magnSexyAfterChat;
		saveData.magnMale = PlayerData.magnMale;
		saveData.magnReservoir = PlayerData.magnReservoir;
		saveData.magnToyReservoir = PlayerData.magnToyReservoir;
		saveData.magnGift = PlayerData.magnGift;

		saveData.grimSexyRecords = PlayerData.grimSexyRecords;
		saveData.grimChats = PlayerData.grimChats;
		saveData.grimSexyBeforeChat = PlayerData.grimSexyBeforeChat;
		saveData.grimSexyAfterChat = PlayerData.grimSexyAfterChat;
		saveData.grimMale = PlayerData.grimMale;
		saveData.grimReservoir = PlayerData.grimReservoir;
		saveData.grimToyReservoir = PlayerData.grimToyReservoir;
		saveData.grimTouched = PlayerData.grimTouched;
		saveData.grimEatenItem = PlayerData.grimEatenItem;
		saveData.grimMoneyOwed = PlayerData.grimMoneyOwed;

		saveData.heraSexyRecords = PlayerData.heraSexyRecords;
		saveData.heraChats = PlayerData.heraChats;
		saveData.heraSexyBeforeChat = PlayerData.heraSexyBeforeChat;
		saveData.heraSexyAfterChat = PlayerData.heraSexyAfterChat;
		saveData.heraMale = PlayerData.heraMale;
		saveData.heraReservoir = PlayerData.heraReservoir;
		saveData.heraToyReservoir = PlayerData.heraToyReservoir;

		saveData.lucaSexyRecords = PlayerData.lucaSexyRecords;
		saveData.lucaChats = PlayerData.lucaChats;
		saveData.lucaSexyBeforeChat = PlayerData.lucaSexyBeforeChat;
		saveData.lucaSexyAfterChat = PlayerData.lucaSexyAfterChat;
		saveData.lucaMale = PlayerData.lucaMale;
		saveData.lucaReservoir = PlayerData.lucaReservoir;
		saveData.lucaToyReservoir = PlayerData.lucaToyReservoir;

		saveData.professors = PlayerData.professors;
		saveData.prevProfPrefix = PlayerData.prevProfPrefix;
		saveData.rankHistory = PlayerData.rankHistory;
		saveData.rankHistoryLog = PlayerData.rankHistoryLog;
		saveData.puzzleCount = PlayerData.puzzleCount;
		saveData.minigameCount = PlayerData.minigameCount;
		saveData.luckyProfSchedules = PlayerData.luckyProfSchedules;

		saveData.rankChance = PlayerData.rankChance;
		saveData.rankDefend = PlayerData.rankDefend;

		saveData.pokemonLibido = PlayerData.pokemonLibido;
		saveData.pegActivity = PlayerData.pegActivity;
		saveData.promptSilverKey = PlayerData.promptSilverKey;
		saveData.promptGoldKey = PlayerData.promptGoldKey;
		saveData.promptDiamondKey = PlayerData.promptDiamondKey;
		saveData.disabledPegColors = PlayerData.disabledPegColors;

		saveData.newItems = ItemDatabase._newItems;
		saveData.solvedPuzzle = ItemDatabase._solvedPuzzle;
		saveData.prefRefillTime = ItemDatabase._prevRefillTime;
		
		saveData.warehouseItemIndexes = ItemDatabase._warehouseItemIndexes;
		saveData.shopItems = ItemDatabase._shopItems;
		saveData.playerItemIndexes = ItemDatabase._playerItemIndexes;
		saveData.mysteryBoxStatus = ItemDatabase._mysteryBoxStatus;
		saveData.magnezoneStatus = ItemDatabase._magnezoneStatus;
		saveData.kecleonPresent = ItemDatabase._kecleonPresent;
		save.flush();
	}

	/**
	 * Provides a default value for a null object.
	 * 
	 * @param	o an object, maybe null
	 * @param	defaultValue default value to return if the input is null.
	 * @return	the input object if it's non-null, otherwise the defaultvalue
	 */
	public static function def(o:Dynamic, defaultValue:Dynamic):Dynamic
	{
		return o != null ? o : defaultValue;
	}

	/**
	 * Provides a default value for an enum object.
	 * 
	 * @param	e enumerated type class
	 * @param	o an object, maybe null
	 * @param	defaultValue default value to return if the input is null
	 * @return	an enum representation of the input object if it's not null,
	 *        	otherwise the defaultValue
	 */
	private static function defEnum<T>(e:Enum<T>, o:Dynamic, defaultValue:Dynamic):T
	{
		var result:T;
		#if flash
		if (o == null || o.tag == null)
		{
			result = defaultValue;
		} else {
			result = Type.createEnum(e, o.tag);
		}
		#else
		result = o != null ? o : defaultValue;
		#end
		return result;
	}

	private static function quickLoad()
	{
		var saveData:Dynamic = getSaveData();

		PlayerData.cash = def(saveData.cash, 500);
		PlayerData.timePlayed = def(saveData.timePlayed, 0);
		PlayerData.critterBonus = def(saveData.critterBonus, [5, 5, 10, 10, 20, 50]);
		PlayerData.pokeVideos = def(saveData.pokeVideos, []);
		PlayerData.videoCount = def(saveData.videoCount, 0);
		PlayerData.videoStatus = defEnum(PlayerData.VideoStatus, saveData.videoStatus, PlayerData.VideoStatus.Empty);
		PlayerData.startedTaping = def(saveData.startedTaping, false);
		PlayerData.startedMagnezone = def(saveData.startedMagnezone, false);
		PlayerData.magnButtPlug = def(saveData.magnButtPlug, 0);
		PlayerData.sandPhone = def(saveData.sandPhone, 0);
		PlayerData.keclStoreChat = def(saveData.keclStoreChat, 0);

		PlayerData.reservoirReward = def(saveData.reservoirReward, 100);
		PlayerData.minigameReward = def(saveData.minigameReward, 200);
		PlayerData.luckyProfReward = def(saveData.luckyProfReward, 2);
		PlayerData.minigameQueue = def(saveData.minigameQueue, []);
		PlayerData.scaleGamePuzzleDifficulty = def(saveData.scaleGamePuzzleDifficulty, 0.35);
		PlayerData.scaleGameOpponentDifficulty = def(saveData.scaleGameOpponentDifficulty, 0.35);

		PlayerData.denMinigame = def(saveData.denMinigame, -1);
		PlayerData.denVisitCount = def(saveData.denVisitCount, 0);

		PlayerData.gender = defEnum(PlayerData.Gender, saveData.gender, PlayerData.Gender.Boy);
		PlayerData.sexualPreference = defEnum(PlayerData.SexualPreference, saveData.sexualPreference, PlayerData.SexualPreference.Boys);
		PlayerData.sexualPreferenceLabel = defEnum(PlayerData.SexualPreferenceLabel, saveData.sexualPreferenceLabel, PlayerData.SexualPreferenceLabel.Gay);
		PlayerData.preliminaryName = def(saveData.preliminaryName, null);
		PlayerData.name = def(saveData.name, null);

		PlayerData.cursorType = def(saveData.cursorType, "default");
		PlayerData.cursorFillColor = def(saveData.cursorFillColor, 0xffe7e8e1); // internal color
		PlayerData.cursorLineColor = def(saveData.cursorLineColor, 0xffb3ada2); // external color
		PlayerData.cursorMaxAlpha = def(saveData.cursorMaxAlpha, 1.0);
		PlayerData.cursorMinAlpha = def(saveData.cursorMinAlpha, 1.0);
		PlayerData.cursorInsulated = def(saveData.cursorInsulated, false);
		PlayerData.cursorSmellTimeRemaining = def(saveData.cursorSmellTimeRemaining, 0);

		PlayerData.chatHistory = def(saveData.chatHistory, []);

		PlayerData.abraSexyRecords = def(saveData.abraSexyRecords, [99999, 99999]);
		PlayerData.abraChats = def(saveData.abraChats, [0, 67]);
		PlayerData.abra7PegChats = def(saveData.abra7PegChats, [65, 45, 13]);
		PlayerData.abraSexyBeforeChat = def(saveData.abraSexyBeforeChat, 99);
		PlayerData.abra7PegSexyBeforeChat = def(saveData.abra7PegSexyBeforeChat, 99);
		PlayerData.abraSexyAfterChat = def(saveData.abraSexyAfterChat, 99);
		PlayerData.abraMale = def(saveData.abraMale, PlayerData.abraDefaultMale);
		PlayerData.abraReservoir = def(saveData.abraReservoir, 71);
		PlayerData.abraToyReservoir = def(saveData.abraToyReservoir, -1);
		PlayerData.abraBeadCapacity = def(saveData.abraBeadCapacity, 42);
		PlayerData.abraStoryInt = def(saveData.abraStoryInt, 0);

		PlayerData.buizSexyRecords = def(saveData.buizSexyRecords, [99999, 99999]);
		PlayerData.buizChats = def(saveData.buizChats, [0, 54]);
		PlayerData.buizSexyBeforeChat = def(saveData.buizSexyBeforeChat, 99);
		PlayerData.buizSexyAfterChat = def(saveData.buizSexyAfterChat, 99);
		PlayerData.buizMale = def(saveData.buizMale, PlayerData.buizDefaultMale);
		PlayerData.buizReservoir = def(saveData.buizReservoir, 39);
		PlayerData.buizToyReservoir = def(saveData.buizToyReservoir, -1);

		PlayerData.grovSexyRecords = def(saveData.grovSexyRecords, [99999, 99999]);
		PlayerData.grovChats = def(saveData.grovChats, [53, 0]); // don't lead with chat 0; it's a little overbearing
		PlayerData.grovSexyBeforeChat = def(saveData.grovSexyBeforeChat, 99);
		PlayerData.grovSexyAfterChat = def(saveData.grovSexyAfterChat, 99);
		PlayerData.grovMale = def(saveData.grovMale, PlayerData.grovDefaultMale);
		PlayerData.grovReservoir = def(saveData.grovReservoir, 67);
		PlayerData.grovToyReservoir = def(saveData.grovToyReservoir, -1);

		PlayerData.sandSexyRecords = def(saveData.sandSexyRecords, [99999, 99999]);
		PlayerData.sandChats = def(saveData.sandChats, [0, 93]);
		PlayerData.sandSexyBeforeChat = def(saveData.sandSexyBeforeChat, 99);
		PlayerData.sandSexyAfterChat = def(saveData.sandSexyAfterChat, 99);
		PlayerData.sandMale = def(saveData.sandMale, PlayerData.sandDefaultMale);
		PlayerData.sandReservoir = def(saveData.sandReservoir, 73);
		PlayerData.sandToyReservoir = def(saveData.sandToyReservoir, -1);

		PlayerData.rhydSexyRecords = def(saveData.rhydSexyRecords, [99999, 99999]);
		PlayerData.rhydChats = def(saveData.rhydChats, [0, 65]);
		PlayerData.rhydSexyBeforeChat = def(saveData.rhydSexyBeforeChat, 99);
		PlayerData.rhydSexyAfterChat = def(saveData.rhydSexyAfterChat, 99);
		PlayerData.rhydMale = def(saveData.rhydMale, PlayerData.rhydDefaultMale);
		PlayerData.rhydReservoir = def(saveData.rhydReservoir, 53);
		PlayerData.rhydToyReservoir = def(saveData.rhydToyReservoir, -1);
		PlayerData.rhydGift = def(saveData.rhydGift, 0);

		PlayerData.smeaSexyRecords = def(saveData.smeaSexyRecords, [99999, 99999]);
		PlayerData.smeaChats = def(saveData.smeaChats, [0, 59]);
		PlayerData.smeaSexyBeforeChat = def(saveData.smeaSexyBeforeChat, 99);
		PlayerData.smeaSexyAfterChat = def(saveData.smeaSexyAfterChat, 99);
		PlayerData.smeaMale = def(saveData.smeaMale, PlayerData.smeaDefaultMale);
		PlayerData.smeaReservoir = def(saveData.smeaReservoir, 25);
		PlayerData.smeaToyReservoir = def(saveData.smeaToyReservoir, -1);
		PlayerData.smeaReservoirBank = def(saveData.smeaReservoirBank, 0);
		PlayerData.smeaToyReservoirBank = def(saveData.smeaToyReservoirBank, 0);

		PlayerData.keclMale = def(saveData.keclMale, PlayerData.keclDefaultMale);
		PlayerData.keclGift = def(saveData.keclGift, 0);

		PlayerData.magnSexyRecords = def(saveData.magnSexyRecords, [99999, 99999]);
		PlayerData.magnChats = def(saveData.magnChats, [0, 20]);
		PlayerData.magnSexyBeforeChat = def(saveData.magnSexyBeforeChat, 99);
		PlayerData.magnSexyAfterChat = def(saveData.magnSexyAfterChat, 99);
		PlayerData.magnMale = def(saveData.magnMale, PlayerData.magnDefaultMale);
		PlayerData.magnReservoir = def(saveData.magnReservoir, 64);
		PlayerData.magnToyReservoir = def(saveData.magnToyReservoir, -1);
		PlayerData.magnGift = def(saveData.magnGift, 0);

		PlayerData.grimSexyRecords = def(saveData.grimSexyRecords, [99999, 99999]);
		PlayerData.grimChats = def(saveData.grimChats, [0, 20]);
		PlayerData.grimSexyBeforeChat = def(saveData.grimSexyBeforeChat, 99);
		PlayerData.grimSexyAfterChat = def(saveData.grimSexyAfterChat, 99);
		PlayerData.grimMale = def(saveData.grimMale, PlayerData.grimDefaultMale);
		PlayerData.grimReservoir = def(saveData.grimReservoir, 41);
		PlayerData.grimToyReservoir = def(saveData.grimToyReservoir, -1);
		PlayerData.grimTouched = def(saveData.grimTouched, false);
		PlayerData.grimEatenItem = def(saveData.grimEatenItem, -1);
		PlayerData.grimMoneyOwed = def(saveData.grimMoneyOwed, 0);

		PlayerData.heraSexyRecords = def(saveData.heraSexyRecords, [99999, 99999]);
		PlayerData.heraChats = def(saveData.heraChats, [0, 66]);
		PlayerData.heraSexyBeforeChat = def(saveData.heraSexyBeforeChat, 99);
		PlayerData.heraSexyAfterChat = def(saveData.heraSexyAfterChat, 99);
		PlayerData.heraMale = def(saveData.heraMale, PlayerData.heraDefaultMale);
		PlayerData.heraReservoir = def(saveData.heraReservoir, 210); // heracross is really pent up his first time
		PlayerData.heraToyReservoir = def(saveData.heraToyReservoir, -1);

		PlayerData.lucaSexyRecords = def(saveData.lucaSexyRecords, [99999, 99999]);
		PlayerData.lucaChats = def(saveData.lucaChats, [0, 35]);
		PlayerData.lucaSexyBeforeChat = def(saveData.lucaSexyBeforeChat, 99);
		PlayerData.lucaSexyAfterChat = def(saveData.lucaSexyAfterChat, 99);
		PlayerData.lucaMale = def(saveData.lucaMale, PlayerData.lucaDefaultMale);
		PlayerData.lucaReservoir = def(saveData.lucaReservoir, 47);
		PlayerData.lucaToyReservoir = def(saveData.lucaToyReservoir, -1);

		PlayerData.professors = def(saveData.professors, [3, 1, 6, 0]);
		PlayerData.prevProfPrefix = def(saveData.prevProfPrefix, "");
		PlayerData.rankHistory = def(saveData.rankHistory, [0, 0, 0, 0, 0, 0, 0, 65]);
		PlayerData.rankHistoryLog = def(saveData.rankHistoryLog, []);
		PlayerData.puzzleCount = def(saveData.puzzleCount, [0, 0, 0, 0, 0]);
		PlayerData.minigameCount = def(saveData.minigameCount, [0, 0, 0, 0, 0]);
		PlayerData.luckyProfSchedules = def(saveData.luckyProfSchedules, []);

		while (PlayerData.puzzleCount.length < 5)
		{
			// people with an older version of the game will have a puzzleCount with only four
			// zeroes, since the "impossible" difficulty was added later
			PlayerData.puzzleCount.push(0);
		}

		PlayerData.rankChance = def(saveData.rankChance, false);
		PlayerData.rankDefend = def(saveData.rankDefend, false);

		PlayerData.pokemonLibido = def(saveData.pokemonLibido, 4);
		PlayerData.pegActivity = def(saveData.pegActivity, 4);
		PlayerData.promptSilverKey = defEnum(PlayerData.Prompt, saveData.promptSilverKey, PlayerData.Prompt.AlwaysNo);
		PlayerData.promptGoldKey = defEnum(PlayerData.Prompt, saveData.promptGoldKey, PlayerData.Prompt.AlwaysNo);
		PlayerData.promptDiamondKey = defEnum(PlayerData.Prompt, saveData.promptDiamondKey, PlayerData.Prompt.AlwaysNo);
		PlayerData.disabledPegColors = def(saveData.disabledPegColors, []);

		ItemDatabase._newItems = def(saveData.newItems, false);
		ItemDatabase._solvedPuzzle = def(saveData.solvedPuzzle, false);
		ItemDatabase._prevRefillTime = def(saveData.prefRefillTime, null);
		ItemDatabase._warehouseItemIndexes = saveData.warehouseItemIndexes != null ? saveData.warehouseItemIndexes : ItemDatabase.getAllItemIndexes();
		ItemDatabase._mysteryBoxStatus = def(saveData.mysteryBoxStatus, 0);
		ItemDatabase._playerItemIndexes = def(saveData.playerItemIndexes, []);
		ItemDatabase._magnezoneStatus = defEnum(ItemDatabase.MagnezoneStatus, saveData.magnezoneStatus, ItemDatabase.MagnezoneStatus.Absent);
		ItemDatabase._kecleonPresent = def(saveData.kecleonPresent, false);
		ItemDatabase._shopItems = [];

		// Haxe saves shop items as generic objects, so we have to manually convert them back
		var oShopItems:Array<Dynamic> = def(saveData.shopItems, []);
		for (oShopItem in oShopItems)
		{
			if (oShopItem._itemIndex == null)
			{
				// itemIndex could be null if they have old/corrupt item data. don't add those items
			}
			else if (oShopItem._itemIndex <= -100000)
			{
				// it's a phone call...
				ItemDatabase._shopItems.push(new ItemDatabase.TelephoneShopItem());
			}
			else if (oShopItem._itemIndex < 0)
			{
				// it's a mystery box...
				ItemDatabase._shopItems.push(new ItemDatabase.MysteryBoxShopItem());
			}
			else
			{
				var shopItem:ItemDatabase.ShopItem = new ItemDatabase.ShopItem(oShopItem._itemIndex, oShopItem._discount);
				shopItem._expensive = oShopItem._expensive;
				shopItem._orderIndex = oShopItem._orderIndex;
				ItemDatabase._shopItems.push(shopItem);
			}
		}

		PlayerDataNormalizer.normalizeItems();
		PlayerDataNormalizer.normalizeLuckyProfSchedules();
		PlayerDataNormalizer.normalizeToyReservoirs();
	}

}