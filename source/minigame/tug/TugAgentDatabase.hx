package minigame.tug;

import flixel.FlxG;
import minigame.tug.TugAgent.Trait.*;
import minigame.tug.TugAgent.Speed.*;
import poke.abra.AbraDialog;
import poke.abra.AbraResource;
import poke.buiz.BuizelDialog;
import poke.buiz.BuizelResource;
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
 * Stores the behavior for the different opponents in the tug-of-war minigame
 * 
 * All of the opponents (including Abra) are very flawed. After creating a
 * perfect AI, I scaled Abra down to being like 90% perfect, and 50% perfect.
 * I couldn't even come close to beating him until I scaled him way down to
 * like 30% perfect -- so he's pretty bad at everything, and also slow with his
 * hands and sometimes just sits around for 5 seconds doing nothing.
 * 
 * I think this is just a very, very hard game for humans to play.
 */
class TugAgentDatabase
{
	public static function getTutorialAgent():TugAgent
	{
		// smeargle
		var agent:TugAgent = new TugAgent(Fastest, Good);
		agent.handFrames = [12, 13];

		agent.setDialogClass(SmeargleDialog);
		agent.chatAsset = AssetPaths.smear_chat__png;
		agent.goodFaces = [4]; // computer won; just look neutral.
		agent.badFaces = [2]; // computer lost; good job player! you finished the tutorial
		return agent;
	}

	public static function getAgent():TugAgent
	{
		var agents:Array<TugAgent> = [];
		{
			// abra
			var agent:TugAgent = new TugAgent(Slow, Awful);
			agent.handFrames = [0, 1];
			agent.setBreaks([2, 3, 5], [1.5, 2]);
			agent.setMathDeviance(Great);
			agent.setMemoryDeviance(Great);
			agent.setObservationDeviance(Great);

			agent.setPlanDelay(Great);
			agent.setMenPerRowDelay(Perfect);
			agents.push(agent);

			agent.setDialogClass(AbraDialog);
			agent.chatAsset = AbraResource.chat;
			agent.thinkyFaces = [4, 5];
			agent.badFaces = [8, 9, 10, 11, 12, 13];
		}
		{
			// buizel
			var agent:TugAgent = new TugAgent(Fastest, Perfect);
			agent.setBreaks([3, 5, 8], [0.8, 1.8]);
			agent.handFrames = [2, 3];
			agent.setMathDeviance(Bad);
			agent.setMemoryDeviance(Bad);
			agent.setObservationDeviance(Awful);
			agent.highestRowBias = -0.20;

			agent.setPlanDelay(Awful);
			agent.setMenPerRowDelay(Perfect);
			agents.push(agent);

			agent.setDialogClass(BuizelDialog);
			agent.chatAsset = BuizelResource.chat;
			agent.goodFaces = [2];
			agent.badFaces = [10, 11, 13, 15];
		}
		{
			// heracross
			var agent:TugAgent = new TugAgent(Slow, Perfect);
			agent.setBreaks([1, 2], [0.6, 2.2]);
			agent.handFrames = [4, 5];
			agent.setMathDeviance(Good);
			agent.setMemoryDeviance(Awful);
			agent.setObservationDeviance(Bad);

			agent.setPlanDelay(Great);
			agent.setMenPerRowDelay(Bad);
			agents.push(agent);
			agent.highestRowBias = -0.40;

			agent.setDialogClass(HeraDialog);
			agent.chatAsset = HeraResource.chat;
		}
		{
			// grovyle
			var agent:TugAgent = new TugAgent(Relaxed, Good);
			agent.setBreaks([2, 6], [1.2, 2.2, 3.2]);
			agent.handFrames = [6, 7];
			agent.setMathDeviance(Awful);
			agent.setMemoryDeviance(Bad);
			agent.setObservationDeviance(Awful);

			agent.setPlanDelay(Bad);
			agent.setMenPerRowDelay(Bad);
			agents.push(agent);

			agent.setDialogClass(GrovyleDialog);
			agent.chatAsset = GrovyleResource.chat;
			agent.goodFaces = [2];
		}
		{
			// sandslash
			var agent:TugAgent = new TugAgent(Fast, Awful);
			agent.setBreaks([3, 5], [0.7, 1.2, 4.4]);
			agent.handFrames = [8, 9];
			agent.setMathDeviance(Awful);
			agent.setMemoryDeviance(Bad);
			agent.setObservationDeviance(Great);

			agent.setPlanDelay(Perfect);
			agent.setMenPerRowDelay(Good);
			agents.push(agent);

			agent.setDialogClass(SandslashDialog);
			agent.chatAsset = SandslashResource.chat;
			agent.goodFaces = [3, 14, 15];
			agent.badFaces = [7, 9, 10, 11, 12, 13];
		}
		{
			// rhydon
			var agent:TugAgent = new TugAgent(Slowest, Bad);
			agent.setBreaks([2, 3], [0.8, 1.8]);
			agent.handFrames = [10, 11];
			agent.setMathDeviance(Awful);
			agent.setMemoryDeviance(Awful);
			agent.setObservationDeviance(Bad);

			agent.setPlanDelay(Bad);
			agent.setMenPerRowDelay(Awful);
			agents.push(agent);
			agent.highestRowBias = 0.8;

			agent.setDialogClass(RhydonDialog);
			agent.chatAsset = RhydonResource.chat;
			agent.goodFaces = [2, 14];
		}
		{
			// smeargle
			var agent:TugAgent = new TugAgent(Fastest, Good);
			agent.setBreaks([2, 7, 9], [1.6, 2.4]);
			agent.handFrames = [12, 13];
			agent.setMemoryDeviance(Bad);
			agent.setMathDeviance(Awful);
			agent.setObservationDeviance(Perfect);

			agent.setPlanDelay(Great);
			agent.setMenPerRowDelay(Great);
			agents.push(agent);

			agent.setDialogClass(SmeargleDialog);
			agent.chatAsset = AssetPaths.smear_chat__png;
			agent.badFaces = [7, 10, 11, 13];
		}
		{
			// kecleon
			var agent:TugAgent = new TugAgent(Fast, Good);
			agent.setBreaks([1, 5, 7], [2.6, 3.6]);
			agent.handFrames = [14, 15];
			agent.setMathDeviance(Bad);
			agent.setMemoryDeviance(Awful);
			agent.setObservationDeviance(Awful);
			agent.highestRowBias = 0.4;

			agent.setPlanDelay(Awful);
			agent.setMenPerRowDelay(Good);
			agents.push(agent);

			agent.setDialogClass(KecleonDialog);
			agent.chatAsset = AssetPaths.kecl_chat__png;
			agent.badFaces = [7, 10, 11, 13];
		}
		{
			// magnezone
			var agent:TugAgent = new TugAgent(Slowest, Bad);
			agent.setBreaks([1, 1, 1], [0, 0, 0]);
			agent.handFrames = [16, 17];
			agent.setMathDeviance(Perfect);
			agent.setMemoryDeviance(Great);
			agent.setObservationDeviance(Perfect);

			agent.setPlanDelay(Perfect);
			agent.setMenPerRowDelay(Great);
			agents.push(agent);

			agent.setDialogClass(MagnDialog);
			agent.chatAsset = MagnResource.chat;
			agent.thinkyFaces = [6, 14, 15];
			agent.goodFaces = [0, 1, 2, 3];
			agent.badFaces = [7, 10, 11];
		}
		{
			// grimer
			var agent:TugAgent = new TugAgent(Relaxed, Great);
			agent.setBreaks([2, 3, 5], [2.2, 3.2, 5.2]);
			agent.handFrames = [18, 19];
			agent.setMathDeviance(Awful);
			agent.setMemoryDeviance(Awful);
			agent.setObservationDeviance(Bad);

			agent.setPlanDelay(Good);
			agent.setMenPerRowDelay(Bad);
			agents.push(agent);

			agent.setDialogClass(GrimerDialog);
			agent.chatAsset = GrimerResource.chat;
		}
		{
			// lucario
			var agent:TugAgent = new TugAgent(Relaxed, Great);
			agent.setBreaks([2, 3, 4], [2.9, 3.9, 5.9]);
			agent.handFrames = [20, 21];
			agent.setMathDeviance(Bad);
			agent.setMemoryDeviance(Great);
			agent.setObservationDeviance(Awful);

			agent.setPlanDelay(Good);
			agent.setMenPerRowDelay(Great);
			agents.push(agent);

			agent.setDialogClass(LucarioDialog);
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