package minigame.scale;
import minigame.MinigameState.denNerf;
import minigame.scale.ScaleGameState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import puzzle.Puzzle;

/**
 * The scoreboard which displays at the very end of the scale minigame, showing
 * the player how many points they earned
 */
class ScaleFinalScoreboard extends FinalScoreboard
{
	private var scaleGameState:ScaleGameState;

	public function new(scaleGameState:ScaleGameState)
	{
		this.scaleGameState = scaleGameState;
		super();
	}

	override public function addBonuses():Void
	{
		addScore("Score", scaleGameState._scalePlayerStatus._totalScores[0]);

		var victoryMargin:Int = 10000;
		var bestAgentName:String = "Abra";

		for (i in 1...scaleGameState._agentSprites.length)
		{
			var difference:Int = Std.int(Math.min(victoryMargin, scaleGameState._scalePlayerStatus._totalScores[0] - scaleGameState._scalePlayerStatus._totalScores[i]));
			if (difference < victoryMargin)
			{
				victoryMargin = difference;
				bestAgentName = scaleGameState._scalePlayerStatus._agents[i]._name;
			}
		}

		if (victoryMargin >= 0)
		{
			addBonus("Victory bonus", denNerf(400));
		}

		if (victoryMargin >= denNerf(350))
		{
			addBonus("Flawless bonus", denNerf(600));
		}

		if (_totalReward > 0 && _totalReward < denNerf(400))
		{
			// player didn't do very well; give them some compensation in the form of a silly bonus
			var pityAmount:Int = Puzzle.getSmallestRewardGreaterThan((denNerf(400) - _totalReward) * FlxG.random.float(0.18, 0.54));

			var randomBonuses:Array<String> = ["Style bonus", "Happening bonus", "Slow and steady bonus", bestAgentName + " cheated bonus", "Good sport bonus", "Pineapple bonus", "Banana bonus", "Math is hard bonus"];
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