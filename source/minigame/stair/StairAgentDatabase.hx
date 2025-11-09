package minigame.stair;
import poke.abra.AbraDialog;
import poke.abra.AbraResource;
import poke.buiz.BuizelDialog;
import poke.buiz.BuizelResource;
import flixel.FlxG;
import poke.grim.GrimerDialog;
import poke.grim.GrimerResource;
import poke.grov.GrovyleDialog;
import poke.grov.GrovyleResource;
import poke.hera.HeraDialog;
import poke.hera.HeraResource;
import poke.kecl.KecleonDialog;
import poke.kecl.KecleonResource;
import poke.luca.LucarioDialog;
import poke.luca.LucarioResource;
import poke.magn.MagnDialog;
import poke.magn.MagnResource;
import poke.rhyd.RhydonDialog;
import poke.rhyd.RhydonResource;
import poke.sand.SandslashDialog;
import poke.sand.SandslashResource;
import poke.smea.SmeargleDialog;
import poke.smea.SmeargleResource;

/**
 * Stores the behavior for the different opponents in the stair climbing
 * minigame
 */
class StairAgentDatabase
{
	public static function getAgent():StairAgent
	{
		var agents:Array<StairAgent> = [];
		{
			// abra (51.35%)
			var agent:StairAgent = new StairAgent();
			agent.setDialogClass(AbraDialog);
			agent.oddsEvens = [0.25, 0.50, 0.25]; // 50%
			agent.bias1 = 3.0;
			agents.push(agent);

			agent.chatAsset = AbraResource.chat;
			agent.thinkyFaces = [4, 5];
			agent.badFaces = [8, 9, 10, 11, 12, 13];
		}
		{
			// buizel (39.95%, plus fuzz factor nerf)
			var agent:StairAgent = new StairAgent();
			agent.setDialogClass(BuizelDialog);
			agent.oddsEvens = [0.00, 0.85, 0.15]; // 85%
			agent.diminishedZeroZero = 0.4;
			agent.dumbness = 0.9;
			agent.bias0 = 5.0;
			agent.fuzzFactor = 5.0;
			agents.push(agent);

			agent.chatAsset = BuizelResource.chat;
			agent.goodFaces = [2];
			agent.badFaces = [10, 11, 13, 15];
		}
		{
			// heracross (43.84%, plus fuzz factor nerf)
			var agent:StairAgent = new StairAgent();
			agent.setDialogClass(HeraDialog);
			agent.oddsEvens = [0.05, 0.95, 0.00]; // 95%
			agent.diminishedZeroZero = 0.4;
			agent.dumbness = 0.4;
			agent.fuzzFactor = 1.0;
			agents.push(agent);

			agent.chatAsset = HeraResource.chat;
		}
		{
			// grovyle (49.91%)
			var agent:StairAgent = new StairAgent();
			agent.setDialogClass(GrovyleDialog);
			agent.oddsEvens = [0.30, 0.40, 0.30]; // 60%
			agent.dumbness = 0.4;
			agent.bias0 = 5.0;
			agents.push(agent);

			agent.chatAsset = GrovyleResource.chat;
			agent.goodFaces = [2];
		}
		{
			// sandslash (41.26%, plus fuzz factor nerf)
			var agent:StairAgent = new StairAgent();
			agent.setDialogClass(SandslashDialog);
			agent.oddsEvens = [0.60, 0.30, 0.10]; // 70%
			agent.dumbness = 0.8;
			agent.bias1 = 0.5;
			agent.fuzzFactor = 3.0;
			agents.push(agent);

			agent.chatAsset = SandslashResource.chat;
			agent.goodFaces = [3, 14, 15];
			agent.badFaces = [7, 9, 10, 11, 12, 13];
		}
		{
			// rhydon (50.00%)
			var agent:StairAgent = new StairAgent();
			agent.setDialogClass(RhydonDialog);
			agent.oddsEvens = [0.25, 0.65, 0.10]; // 65%
			agent.bias0 = 5.0;
			agents.push(agent);

			agent.chatAsset = RhydonResource.chat;
			agent.goodFaces = [2, 14];
		}
		{
			// smeargle (45.95%)
			var agent:StairAgent = new StairAgent();
			agent.setDialogClass(SmeargleDialog);
			agent.oddsEvens = [0.10, 0.10, 0.80]; // 90%
			agent.dumbness = 0.7;
			agent.bias1 = 5.0;
			agents.push(agent);

			agent.chatAsset = AssetPaths.smear_chat__png;
			agent.badFaces = [7, 10, 11, 13];
		}
		{
			// kecleon (??? should never play) (38.63%, plus fuzz factor nerf)
			var agent:StairAgent = new StairAgent();
			agent.setDialogClass(KecleonDialog);
			agent.oddsEvens = [0.10, 0.75, 0.15]; // 75%
			agent.dumbness = 1.0;
			agent.fuzzFactor = 7.0;
			agents.push(agent);

			agent.chatAsset = AssetPaths.kecl_chat__png;
			agent.badFaces = [7, 10, 11, 13];
		}
		{
			// magnezone (50.00%)
			var agent:StairAgent = new StairAgent();
			agent.setDialogClass(MagnDialog);
			agent.oddsEvens = [0.50, 0.50, 0.00];
			agents.push(agent);

			agent.chatAsset = MagnResource.chat;
			agent.thinkyFaces = [6, 14, 15];
			agent.goodFaces = [0, 1, 2, 3];
			agent.badFaces = [7, 10, 11];
		}
		{
			// grimer (47.83%)
			var agent:StairAgent = new StairAgent();
			agent.setDialogClass(GrimerDialog);
			agent.oddsEvens = [0.90, 0.00, 0.10]; // 100%
			agent.diminishedZeroZero = 0.6;
			agents.push(agent);

			agent.chatAsset = GrimerResource.chat;
		}
		{
			// lucario (47.39%)
			var agent:StairAgent = new StairAgent();
			agent.setDialogClass(LucarioDialog);
			agent.oddsEvens = [0.40, 0.20, 0.40]; // 80%
			agent.dumbness = 0.2;
			agent.bias1 = 3.0;
			agents.push(agent);

			agent.chatAsset = LucarioResource.chat;
			agent.thinkyFaces = [6, 7, 10];
		}

		if (PlayerData.profIndex < agents.length)
		{
			return agents[PlayerData.profIndex];
		}
		// active professor doesn't have minigame persona? ...just return someone as a placeholder
		return FlxG.random.getObject(agents);
	}

}