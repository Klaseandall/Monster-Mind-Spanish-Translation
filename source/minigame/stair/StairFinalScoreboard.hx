package minigame.stair;

import minigame.FinalScoreboard;
import minigame.MinigameState.denNerf;
import flixel.FlxG;
import puzzle.Puzzle;

/**
 * The scoreboard which displays at the end of the stair climbing minigame, to
 * show the player how much money they earned
 */
class StairFinalScoreboard extends FinalScoreboard
{
	var stairGameState:StairGameState;

	public function new(stairGameState:StairGameState)
	{
		this.stairGameState = stairGameState;
		super();
	}

	override public function addBonuses()
	{
		if (stairGameState.stairStatus0.deliveredChestCount == 0)
		{
			addScore("Score", 0);
		}
		else if (stairGameState.stairStatus0.deliveredChestCount == 1)
		{
			addScore("Score", denNerf(250));
		}
		else
		{
			addScore("Score", denNerf(750));
		}

		if (stairGameState.stairStatus0.deliveredChestCount == 2)
		{
			addBonus("Victory bonus", denNerf(400));
		}

		if (stairGameState.stairStatus1.deliveredChestCount == 0 && stairGameState.stairStatus1.captureBonus == 0)
		{
			addBonus("Flawless bonus", denNerf(600));
		}

		if (stairGameState.stairStatus0.captureBonus > 0)
		{
			addBonus("Capture bonus", stairGameState.stairStatus0.captureBonus);
		}

		if (_totalReward < denNerf(400))
		{
			// player didn't do very well; give them some compensation in the form of a silly bonus
			var pityAmount:Int = Puzzle.getSmallestRewardGreaterThan((denNerf(400) - _totalReward) * FlxG.random.float(0.18, 0.54));

			var randomBonuses:Array<String> = ["WIFOM bonus", "Stair stamina bonus", "Second place bonus", "Mind reader bonus", "Bad beat bonus", "Pacifist bonus", "Dirty socks bonus", "Fresh breath bonus"];
			if (PlayerData.sexualPreferenceLabel == PlayerData.SexualPreferenceLabel.Gay)
			{
				randomBonuses.push("Homosexual bonus");
				randomBonuses.push("Zero vagina bonus");
			}
			else if (PlayerData.sexualPreferenceLabel == PlayerData.SexualPreferenceLabel.Lesbian)
			{
				randomBonuses.push("Lesbian bonus");
				randomBonuses.push("Zero penis bonus");
			}
			else if (PlayerData.sexualPreferenceLabel == PlayerData.SexualPreferenceLabel.Straight)
			{
				randomBonuses.push("Heterosexual bonus");
				randomBonuses.push("Hooray for boobies bonus");
			}
			else if (PlayerData.sexualPreferenceLabel == PlayerData.SexualPreferenceLabel.Bisexual)
			{
				randomBonuses.push("Bisexual bonus");
				randomBonuses.push("Hooray for boobies bonus");
			}

			if (PlayerData.gender == PlayerData.Gender.Boy)
			{
				randomBonuses.push("Penis bonus");
				randomBonuses.push("Bold erection bonus");
			}
			else if (PlayerData.gender == PlayerData.Gender.Girl)
			{
				randomBonuses.push("Vagina bonus");
				randomBonuses.push("Menstruation bonus");
			}

			addBonus(FlxG.random.getObject(randomBonuses), pityAmount);
		}
	}
}