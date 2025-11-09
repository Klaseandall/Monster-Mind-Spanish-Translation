package poke;

import PlayerData.Gender;
import PlayerData.SexualPreference;
import flixel.FlxG;
import flixel.math.FlxMath;
import poke.abra.AbraDialog;
import puzzle.RankTracker;

/**
 * The Password class includes the logic for converting a player's save file
 * into an alphanumeric password, and applying an alphanumeric password to the
 * save file
 *
 * It does this by converting the player's progress into a set of 90 bits,
 * scrambling/masking those bits a few times, splitting those bits into 5-bit
 * fragments, and then converting those each to one of 32 alphanumeric digits
 */
class Password
{
	private static var PASSWORD_ITEM_COUNT:Int = 30;
	private static var PASSWORD_LENGTH:Int = 18;
	private static var CHECKSUM_BITS:Int = 9;
	private static var PASSWORD_CASH:Array<Int> = [0, 100, 200, 300, 400, 500, 700, 900, 1100, 1300, 1500, 1600, 1900, 2100, 2400, 2700, 3100, 3500, 3900, 4400, 5000, 5700, 6400, 7300, 8200, 9300, 11000, 12000, 14000, 15000, 17000, 20000, 22000, 25000, 28000, 32000, 36000, 41000, 47000, 53000, 60000, 68000, 77000, 87000, 98000, 110000, 130000, 140000, 160000, 180000, 210000, 230000, 260000, 300000, 340000, 380000, 440000, 490000, 560000, 630000, 710000, 810000, 920000, 1040000];
	private static var PASSWORD_TIME_PLAYED:Array<Int> = [0, 110, 220, 430, 610, 820, 1030, 1240, 1550, 1860, 2070, 2380, 2740, 3150, 3620, 4160, 4790, 5510, 6330, 7280, 8370, 9630, 11080, 12740, 14650, 16840, 19370, 22280, 25620, 29460, 33880, 38960, 44800, 51530, 59250, 68140, 78360, 90120, 103640, 119180, 137060, 157620, 181260, 208450, 239720, 275670, 317020, 364580, 419260, 482150, 554480, 637650, 733300, 843290, 969780, 1115250, 1282540, 1474920, 1696160, 1950580, 2243170, 2579650, 2966590, 3600000];
	public var originalPasswordString:String;

	private var valid:Bool = true;
	private var mysteryBoxStatus:Int = 0;
	private var parsedPasswordString:String;
	private var hasItem:Array<Bool> = [];
	private var abraChatState:Int = 0;
	private var buizChatState:Int = 0;
	private var heraChatState:Int = 0;
	private var grovChatState:Int = 0;
	private var sandChatState:Int = 0;
	private var rhydChatState:Int = 0;
	private var smeaChatState:Int = 0;
	private var magnChatState:Int = 0;
	private var grimChatState:Int = 0;
	private var lucaChatState:Int = 0;
	private var cash:Int = 0;
	private var abraStoryInt:Int = 0;
	private var finalTrialCount:Int = 0;
	private var playerRank:Int = 0;
	private var timePlayed:Int = 0;
	private var fivePegUnlocked:Bool = false;
	private var sevenPegUnlocked:Bool = false;

	public function new(name:String, passwordString:String)
	{
		this.originalPasswordString = passwordString;
		this.parsedPasswordString = StringTools.replace(passwordString, " ", "");
		if (parsedPasswordString.length < 18)
		{
			valid = false;
			return;
		}

		var b:BinaryString = BinaryString.fromAlphanumeric(parsedPasswordString);
		b.hash(name);
		var calculatedChecksum:Int = b.computeChecksum(PASSWORD_LENGTH * 5 - CHECKSUM_BITS, CHECKSUM_BITS);

		if (b.readInt(1) == 1)
		{
			// player has purchased all items
			mysteryBoxStatus = b.readInt(12);
			PlayerData.abraBeadCapacity = b.readInt(8);
			valid = (valid && b.readInt(10) == 326);
			for (i in 0...ItemDatabase.getItemCount())
			{
				hasItem[i] = true;
			}
		}
		else
		{
			// player has only purchased some items
			for (i in 0...PASSWORD_ITEM_COUNT)
			{
				hasItem[i] = b.readInt(1) == 1;
			}
		}

		abraChatState = b.readInt(2);
		buizChatState = b.readInt(3);
		heraChatState = b.readInt(2);
		grovChatState = b.readInt(2);
		sandChatState = b.readInt(3);

		rhydChatState = b.readInt(2);
		smeaChatState = b.readInt(2);
		magnChatState = b.readInt(2);
		grimChatState = b.readInt(2);
		lucaChatState = b.readInt(2);

		var cashIndex:Int = b.readInt(6);
		cash = PASSWORD_CASH[cashIndex];

		abraStoryInt = b.readInt(3);
		finalTrialCount = b.readInt(3);
		playerRank = b.readInt(7);

		if (playerRank > 65)
		{
			valid = false;
		}

		timePlayed = PASSWORD_TIME_PLAYED[b.readInt(6)];

		fivePegUnlocked = b.readInt(1) == 1;
		sevenPegUnlocked = b.readInt(1) == 1;

		if (b.s.length > CHECKSUM_BITS)
		{
			b.ignore(b.s.length - CHECKSUM_BITS);
		}

		var parsedChecksum:Int = b.readInt(CHECKSUM_BITS);
		valid = valid && (parsedChecksum == calculatedChecksum);
	}

	public function isValid():Bool
	{
		return valid;
	}

	private function applyChatState(prefix:String, chatState:Int)
	{
		for (chatIndex in 0...chatState)
		{
			PlayerData.chatHistory.push(prefix + ".fixedChats." + chatIndex);
		}
		if (chatState == 0)
		{
			Reflect.setField(PlayerData, prefix + "Chats", [0]);
		}
		else
		{
			// maybe append a "randomChat" so everyone doesn't start with a fixed chat
			Reflect.setField(PlayerData, prefix + "Chats", FlxG.random.bool() ? [] : [FlxG.random.int(50, 99)]);
		}
		var playerChats:Array<Int> = Reflect.field(PlayerData, prefix + "Chats");
		while (playerChats.length < PlayerData.CHATLENGTH)
		{
			LevelIntroDialog.appendToChatHistory(prefix);
		}
	}

	private function setFinalTrialCount(count:Int):Void
	{
		PlayerData.removeFromChatHistory("abra.fixedChats." + AbraDialog.FINAL_CHAT_INDEX);
		for (i in 0...count * 3)
		{
			PlayerData.quickAppendChatHistory("abra.fixedChats." + AbraDialog.FINAL_CHAT_INDEX, false);
		}
	}

	private function setRank(playerRank:Int):Void
	{
		if (playerRank < 4)
		{
			PlayerData.rankHistory = [65, playerRank, playerRank, 0, playerRank, playerRank, playerRank, 0];
		}
		else if (playerRank > 61)
		{
			PlayerData.rankHistory = [65, playerRank, playerRank, 0, playerRank, playerRank, playerRank, 0];
		}
		else {
			PlayerData.rankHistory = [65, playerRank + 2, playerRank - 2, 0, playerRank + 4, playerRank, playerRank - 4, 0];
		}
	}

	private static function getChatState(prefix:String)
	{
		if (!PlayerData.hasMet(prefix))
		{
			return 0;
		}
		/*
		 * Don't bother checking for fixedChats.0. fixedChats.0 should always
		 * be the introductory chat which plays upon meeting a character, so
		 * checking for it is redundant.
		 *
		 * Except for Abra, but Abra's introductory chat isn't anything special
		 */
		var chatState:Int = 1;
		for (i in 0...7)
		{
			if (PlayerData.recentChatCount(prefix + ".fixedChats." + chatState) == 0)
			{
				return chatState;
			}
			chatState++;
		}
		return 7;
	}

	public static function extractFromPlayerData():String
	{
		var b:BinaryString = new BinaryString();

		if (ItemDatabase.getItemCount() > PASSWORD_ITEM_COUNT)
		{
			throw "Too many items in database: " + ItemDatabase.getItemCount() + " > " + PASSWORD_ITEM_COUNT;
		}

		var cashIndex:Int = 0;
		for (i in 1...PASSWORD_CASH.length)
		{
			if (PlayerData.cash >= PASSWORD_CASH[i] - 50)
			{
				cashIndex = i;
			}
		}

		var playerHasEveryItem:Bool = true;
		for (i in 0...ItemDatabase.getItemCount())
		{
			if (!ItemDatabase.playerHasItem(i))
			{
				playerHasEveryItem = false;
				break;
			}
		}

		if (playerHasEveryItem)
		{
			// [0] = has player purchased every item in the game?
			b.writeInt(1, 1);

			// [1-12] = which mystery box is currently on display?
			b.writeInt(ItemDatabase._mysteryBoxStatus, 12);

			// [13-20] = how many beads can abra hold?
			b.writeInt(PlayerData.abraBeadCapacity, 8);
			// [21-30] = 326 (checksum)
			b.writeInt(326, 10);
		}
		else {
			// [0] = has player purchased every item in the game?
			b.writeInt(0, 1);

			// [1-30] = item indexes
			for (i in 0...PASSWORD_ITEM_COUNT)
			{
				b.writeInt(ItemDatabase.playerHasItem(i) ? 1 : 0, 1);
			}
		}

		// [31-54] = has player met characters?
		b.writeInt(getChatState("abra"), 2);
		b.writeInt(getChatState("buiz"), 3);
		b.writeInt(getChatState("hera"), 2);
		b.writeInt(getChatState("grov"), 2);
		b.writeInt(getChatState("sand"), 3);

		b.writeInt(getChatState("rhyd"), 2);
		b.writeInt(getChatState("smea"), 2);
		b.writeInt(getChatState("magn"), 2);
		b.writeInt(getChatState("grim"), 2);
		b.writeInt(getChatState("luca"), 2);
		// 55-60 = how much money does the player have?
		b.writeInt(cashIndex, 6);
		// 61-63 = what state is abra in?
		b.writeInt(PlayerData.abraStoryInt, 3);
		// 64-66 = final trial count
		b.writeInt(AbraDialog.getFinalTrialCount(), 3);
		// 67-73 = player rank
		b.writeInt(RankTracker.computeAggregateRank(), 7);
		// 74-79 = time played
		var timePlayedIndex:Int = 0;
		for (i in 1...PASSWORD_TIME_PLAYED.length)
		{
			if (PlayerData.timePlayed >= PASSWORD_TIME_PLAYED[i] - 30)
			{
				timePlayedIndex = i;
			}
		}
		b.writeInt(timePlayedIndex, 6);
		// 80 = unlocked 5-peg puzzles?
		b.writeInt(PlayerData.fivePegUnlocked() ? 1 : 0, 1);
		// 81 = unlocked 7-peg puzzles?
		b.writeInt(PlayerData.sevenPegUnlocked() ? 1 : 0, 1);

		// 82-90 = checksum
		b.pad(PASSWORD_LENGTH * 5 - CHECKSUM_BITS);
		var checksum:Int = b.computeChecksum(PASSWORD_LENGTH * 5 - CHECKSUM_BITS, CHECKSUM_BITS);
		b.writeInt(checksum, CHECKSUM_BITS);

		b.hash(PlayerData.name == null ? "" : PlayerData.name);

		return b.toAlphanumeric(PASSWORD_LENGTH);
	}

	public function applyToPlayerData()
	{
		// flush all saved data except gender and sexual preference...
		var gender:Gender = PlayerData.gender;
		var sexualPreference:SexualPreference = PlayerData.sexualPreference;

		PlayerSave.deleteSave(PlayerData.saveSlot);
		PlayerSave.flush();

		PlayerData.gender = gender;
		PlayerData.setSexualPreference(sexualPreference);

		// apply data from the password
		ItemDatabase._mysteryBoxStatus = mysteryBoxStatus;
		ItemDatabase._playerItemIndexes.splice(0, ItemDatabase._playerItemIndexes.length);
		for (itemIndex in 0...ItemDatabase.getItemCount())
		{
			if (hasItem[itemIndex])
			{
				ItemDatabase._playerItemIndexes.push(itemIndex);
				ItemDatabase._warehouseItemIndexes.remove(itemIndex);
				ItemDatabase._shopItems = ItemDatabase._shopItems.filter(function(shopItem) return shopItem._itemIndex == itemIndex);
			}
		}
		ItemDatabase.refillItems();
		PlayerDataNormalizer.normalizeItems();

		applyChatState("abra", abraChatState);
		applyChatState("buiz", buizChatState);
		applyChatState("hera", heraChatState);
		applyChatState("grov", grovChatState);
		applyChatState("sand", sandChatState);
		applyChatState("rhyd", rhydChatState);
		applyChatState("smea", smeaChatState);
		applyChatState("magn", magnChatState);
		applyChatState("grim", grimChatState);
		applyChatState("luca", lucaChatState);

		PlayerData.cash = cash;

		PlayerData.abraStoryInt = abraStoryInt;
		setFinalTrialCount(finalTrialCount);
		if (abraStoryInt == 3 || abraStoryInt == 4)
		{
			if (finalTrialCount == 0)
			{
				/*
				 * if a player has triggered the "let's have a talk" but hasn't
				 * started the final trial, we need to set up the dialog sequence
				 */
				PlayerData.abraChats = [2, 3, 4, 5];
			}
			else
			{
				/**
				 * if a player has started the final trial, keep them on the final trial
				 */
				PlayerData.abraChats = [5];
			}
		}
		setRank(playerRank);
		PlayerData.timePlayed = timePlayed;

		// if they've been playing longer than 10 minutes, we set startedTaping=true
		PlayerData.startedTaping = PlayerData.timePlayed > 10 * 60;
		PlayerData.videoCount = Math.floor(PlayerData.timePlayed / (10 * 60));

		// if they've been playing longer than 45 minutes, or have met Magnezone, we set startedMagnezone=true
		PlayerData.startedMagnezone = PlayerData.timePlayed > 45 * 60 || PlayerData.hasMet("magn");

		PlayerData.minigameCount = [0, 0, 0];
		if (PlayerData.timePlayed > 2 * 60 * 60)
		{
			// if they've been playing longer than 2 hours, we assume they know the minigames
			PlayerData.minigameCount[0] = Std.int(FlxMath.bound(FlxG.random.float(0.8, 1.25) * (PlayerData.timePlayed / (2 * 60 * 60)), 1, 9999));
			PlayerData.minigameCount[1] = Std.int(FlxMath.bound(FlxG.random.float(0.8, 1.25) * (PlayerData.timePlayed / (2 * 60 * 60)), 1, 9999));
			PlayerData.minigameCount[2] = Std.int(FlxMath.bound(FlxG.random.float(0.8, 1.25) * (PlayerData.timePlayed / (2 * 60 * 60)), 1, 9999));
		}

		// if they've been playing longer than 2 hours, we assume they've met kecleon
		PlayerData.keclStoreChat = PlayerData.timePlayed > 2 * 60 * 60 ? 25 : 0;

		var puzzleCount:Array<Int> = [0, 0, 0, 0, 0];
		var distrib:Array<Float>;
		if (playerRank < 15)
		{
			// novice players spend their time on easy puzzles
			distrib = [0.30, 0.30, 0.25, 0.15, 0.00];
		}
		else if (playerRank < 30)
		{
			distrib = [0.25, 0.25, 0.30, 0.15, 0.05];
		}
		else if (playerRank < 45)
		{
			distrib = [0.10, 0.25, 0.30, 0.25, 0.10];
		}
		else
		{
			// smarter players spend their time on hard puzzles
			distrib = [0.10, 0.20, 0.25, 0.30, 0.15];
		}
		puzzleCount[0] = Math.ceil(90 * (PlayerData.timePlayed / 60 / 60) * distrib[0]);
		puzzleCount[1] = Math.ceil(45 * (PlayerData.timePlayed / 60 / 60) * distrib[1]);
		puzzleCount[2] = Math.floor(20 * (PlayerData.timePlayed / 60 / 60) * distrib[2]);
		puzzleCount[3] = Math.floor(12 * (PlayerData.timePlayed / 60 / 60) * distrib[3]);
		puzzleCount[4] = Math.round(3 * (PlayerData.timePlayed / 60 / 60) * distrib[4]);

		// they must have solved 3 novice puzzles, or they couldn't receive a password...
		puzzleCount[0] = Std.int(Math.max(3, puzzleCount[0]));
		if (fivePegUnlocked)
		{
			puzzleCount[2] = Std.int(Math.max(3, puzzleCount[2]));
		}
		else
		{
			puzzleCount[0] += puzzleCount[3];
			puzzleCount[3] = 0;
		}
		if (sevenPegUnlocked)
		{
			puzzleCount[3] = Std.int(Math.max(3, puzzleCount[3]));
			puzzleCount[4] = Std.int(Math.max(1, puzzleCount[4]));
		}
		else
		{
			puzzleCount[0] += puzzleCount[4];
			puzzleCount[4] = 0;
		}
		PlayerData.puzzleCount = puzzleCount;

		if (playerRank >= 1)
		{
			PlayerData.rankChance = true;
		}
		if (playerRank >= 10)
		{
			PlayerData.rankDefend = true;
		}

		// if they've talked with Magnezone a lot, then we assume they've encountered the butt plug joke
		PlayerData.magnButtPlug = magnChatState >= 2 ? 7 : 0;
		PlayerData.grovSexyBeforeChat = 9;

		// if they've met grimer, we assume they've touched him too
		PlayerData.grimTouched = PlayerData.hasMet("grim");

		// after 1 hour, we assume they've been to the den. after 2 hours, we assume they've been to the den a few times
		PlayerData.denVisitCount = Math.floor(PlayerData.timePlayed / 60 / 60);

		// save the resulting data
		PlayerSave.flush();
	}
}