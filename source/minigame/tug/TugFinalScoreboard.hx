package minigame.tug;

import minigame.FinalScoreboard;
import minigame.MinigameState.denNerf;

/**
 * The scoreboard which displays at the end of the tug-of-war minigame, showing
 * the player how much money they earned
 */
class TugFinalScoreboard extends FinalScoreboard
{
	private var tugGameState:TugGameState;

	public function new(tugGameState:TugGameState)
	{
		this.tugGameState = tugGameState;
		super();
	}

	override public function addBonuses():Void
	{
		addScore("Score", tugGameState.tugScoreboard.manTotalScore);

		var victoryMargin:Int = tugGameState.tugScoreboard.manTotalScore - tugGameState.tugScoreboard.comTotalScore;

		if (victoryMargin >= 0)
		{
			addBonus("Victory bonus", denNerf(400));
		}

		if (tugGameState.tugScoreboard.isFlawlessWin())
		{
			addBonus("Flawless bonus", denNerf(600));
		}

		/*
		 * Most minigames award bonuses if the player finishes with a low
		 * score, but the tug-of-war game does not. The losing player is
		 * guaranteed to get some points anyways.
		 */
	}
}