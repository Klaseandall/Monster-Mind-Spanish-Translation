package minigame;
import flixel.util.FlxDestroyUtil;
import poke.abra.AbraDialog;
import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.ui.FlxButton;
import openfl.utils.Object;
import poke.sexy.SexyState;
import puzzle.PuzzleState;

/**
 * Parent class which includes logic common to all minigames -- skipping
 * minigames, showing the scoreboard, deciding where to go after the
 * minigame, stuff like that
 */
class MinigameState extends LevelState
{
	public var description:String;
	public var duration:Float = 3.0; // duration in minutes;
	public var avgReward:Int = 1000; // expected reward;
	private var finalScoreboard:FinalScoreboard;

	private var _helpButtonAlphaTimer:Float = 0; // help button needs to change for ~0.5s before it turns on
	private var denDestination:String = null;

	override public function create():Void
	{
		super.create();

		_helpButton.alpha = LevelState.BUTTON_OFF_ALPHA;
		var minigameIndex:Int = PlayerData.MINIGAME_CLASSES.indexOf(Type.getClass(this));
		PlayerData.denMinigame = minigameIndex;
	}

	override public function dialogTreeCallback(Msg:String):String
	{
		super.dialogTreeCallback(Msg);
		if (Msg == "%den-game%" || Msg == "%den-sex%" || Msg == "%den-quit%")
		{
			denDestination = Msg;
		}
		if (Msg == "%skip-minigame%")
		{
			denDestination = "%den-sex%";
		}
		return "";
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (DialogTree.isDialogging(_dialogTree) || _gameState >= 400)
		{
			if (_helpButton.alpha == 1.0)
			{
				_helpButton.alpha = LevelState.BUTTON_OFF_ALPHA;
			}
		}
		else {
			if (_helpButton.alpha == LevelState.BUTTON_OFF_ALPHA)
			{
				_helpButtonAlphaTimer += elapsed;
				if (_helpButtonAlphaTimer > 0.4)
				{
					_helpButton.alpha = 1.0;
				}
			}
			else {
				_helpButtonAlphaTimer = 0;
			}
		}
	}

	public function getMinigameOpponentDialogClass():Class<Dynamic>
	{
		return AbraDialog;
	}

	override public function clickHelp():Void
	{
		var dialogClass:Class<Dynamic> = getMinigameOpponentDialogClass();
		var tree:Array<Array<Object>> = LevelIntroDialog.generateMinigameHelp(dialogClass, this);
		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();
	}

	public function payMinigameReward(reward:Int)
	{
		PlayerData.cash += reward;
		var minigameIndex:Int = PlayerData.MINIGAME_CLASSES.indexOf(Type.getClass(this));
		PlayerData.minigameCount[minigameIndex]++;
		if (PlayerData.playerIsInDen)
		{
			// don't reduce minigameReward; player is only practicing
		}
		else
		{
			// reduce minigameReward variable; player will encounter a new minigame in about 30-40 minutes
			PlayerData.minigameReward -= Std.int((avgReward + reward) * 0.5);
			/**
			 * We compensate them for time they would have spent solving puzzles instead of doing minigames.
			 */
			PlayerData.minigameReward += Std.int(duration * 60);
		}
	}

	function eventPay(args:Array<Dynamic>)
	{
		payMinigameReward(finalScoreboard._totalReward);
	}

	public static function fromInt(minigameIndex:Int):MinigameState
	{
		return Type.createInstance(PlayerData.MINIGAME_CLASSES[minigameIndex], []);
	}

	public static function roundUpToFive(i:Float):Int
	{
		return Math.ceil(i * 0.2) * 5;
	}

	/**
	 * Calculates the reward for a certain aspect of a minigame, diminishing
	 * the reward if the player's in the den.
	 * 
	 * Rewards are reduced in the den -- instead of receiving $200 for winning
	 * a round in the scale game, the player might only win $40. This lets
	 * them practice without breaking the games'e economy.
	 * 
	 * @param	reward money the player would normally earn for a given
	 *       	minigame event
	 * @return	money the player should earn, diminished if the player is in the
	 *        	den
	 */
	public static function denNerf(reward:Int):Int
	{
		if (PlayerData.playerIsInDen)
		{
			// player is in den; minigame winnings are reduced
			return roundUpToFive(reward * PlayerData.DEN_MINIGAME_NERF);
		}
		return reward;
	}

	public function handleDenGameOver(tree:Array<Array<Object>>, playerVictory:Bool)
	{
		PlayerData.denGameCount++;
		var clazz:Dynamic = getMinigameOpponentDialogClass();
		var denDialogFunc:Dynamic = Reflect.field(clazz, "denDialog");
		var denDialog:DenDialog = denDialogFunc(null, playerVictory);
		PlayerData.denTotalReward += finalScoreboard._totalReward;
		_dialogger._promptsYOffset = 80; // move prompts down to where they don't cover the final score
		if (PlayerData.denTotalReward >= PlayerData.DEN_MAX_REWARD)
		{
			denDialog.getTooManyGames(tree);
		}
		else
		{
			denDialog.getReplayMinigame(tree);
		}
	}

	public function exitMinigameState()
	{
		var newState:FlxState;
		if (PlayerData.playerIsInDen)
		{
			if (denDestination == "%den-game%")
			{
				// rematch
				newState = MinigameState.fromInt(PlayerData.denMinigame);
			}
			else if (denDestination == "%den-sex%")
			{
				if (PlayerData.sfw)
				{
					// skip sexystate; sfw mode...
					transOut = MainMenuState.fadeOutSlow();
					newState = new ShopState(MainMenuState.fadeInFast());
				}
				else
				{
					// sex
					newState = SexyState.getSexyState();
				}
			}
			else
			{
				// shop
				newState = new ShopState();
			}
		}
		else
		{
			if (PlayerData.sfw)
			{
				// skip sexystate; sfw mode...
				LevelIntroDialog.rotateChat();
				LevelIntroDialog.increaseProfReservoirs();
				LevelIntroDialog.rotateProfessors([PlayerData.prevProfPrefix]);

				transOut = MainMenuState.fadeOutSlow();
				newState = new MainMenuState(MainMenuState.fadeInFast());
			}
			else
			{
				PlayerData.justFinishedMinigame = true;
				newState = PuzzleState.initializeSexyState();
			}
		}
		FlxG.switchState(newState);
	}

	public function handleGameAnnouncement(tree:Array<Array<Object>>)
	{
		var opponentClass:Class<Dynamic> = getMinigameOpponentDialogClass();
		if (PlayerData.playerIsInDen)
		{
			var denDialogFunc:Dynamic = Reflect.field(opponentClass, "denDialog");
			var denDialog:DenDialog = denDialogFunc();
			if (PlayerData.denGameCount == 0)
			{
				// first practice game in den
				denDialog.getGameGreeting(tree, description);
			}
			else
			{
				// second, third practice game in den
			}
		}
		else
		{
			// regular minigame
			var gameDialogFunc:Dynamic = Reflect.field(opponentClass, "gameDialog");
			var gameDialog:GameDialog = gameDialogFunc(Type.getClass(this));
			gameDialog.popGameAnnouncement(tree, description);
		}
	}

	public function showFinalScoreboard():Void
	{
		_hud.insert(_hud.members.indexOf(_dialogger), finalScoreboard);
		var eventTime:Float = _eventStack._time + 0.8;
		for (i in 0...finalScoreboard.getBonusGroupCount())
		{
			_eventStack.addEvent({time:eventTime, callback:finalScoreboard.eventTurnOnBonusGroup});
			eventTime += 0.8;
		}
		eventTime -= 0.3;
		_eventStack.addEvent({time:eventTime, callback:eventShowCashWindow});
		eventTime += 1.0;
		_eventStack.addEvent({time:eventTime, callback:eventPay});
		eventTime += 2.5;
		// keep the player here for a little while after payment is done
		_eventStack.addEvent({time:eventTime, callback:null});
	}

	override public function destroy():Void
	{
		super.destroy();

		description = null;
		finalScoreboard = FlxDestroyUtil.destroy(finalScoreboard);
		denDestination = null;
	}
}