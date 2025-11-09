package minigame.scale;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import poke.abra.AbraDialog;
import poke.abra.AbraResource;
import minigame.scale.ScaleAgent;
import poke.buiz.BuizelDialog;
import poke.buiz.BuizelResource;
import flixel.FlxG;
import flixel.math.FlxMath;
import poke.grim.GrimerDialog;
import poke.grim.GrimerResource;
import poke.grov.GrovyleDialog;
import poke.grov.GrovyleResource;
import poke.hera.HeraDialog;
import poke.hera.HeraResource;
import poke.kecl.KecleonDialog;
import poke.luca.LucarioDialog;
import poke.luca.LucarioResource;
import poke.magn.MagnDialog;
import poke.magn.MagnResource;
import poke.rhyd.RhydonDialog;
import poke.rhyd.RhydonResource;
import poke.sand.SandslashDialog;
import poke.sand.SandslashResource;
import poke.smea.SmeargleDialog;

/**
 * Stores the behavior for the different opponents in the scale minigame.
 * 
 * I simulated about 60 agents and chose a variety of behaviors to represent
 * as Pokemon. The lines prefixed with numbers and asterisks correspond to
 * certain Pokemon; for example "bonnie" is "Grovyle".
 * 
 * 01**patrick: reflexes=6 cleverness=8 reliability=9 physical=8: 10.49
 * dennis: reflexes=6 cleverness=9 reliability=8 physical=8: 10.52
 * anette: reflexes=5 cleverness=8 reliability=9 physical=6: 10.94
 * angela: reflexes=7 cleverness=8 reliability=7 physical=6: 11.09
 * kaya: reflexes=9 cleverness=9 reliability=6 physical=4: 11.28
 * 02**sam: reflexes=9 cleverness=7 reliability=8 physical=4: 11.61
 * ariana: reflexes=4 cleverness=7 reliability=8 physical=6: 11.64
 * michael: reflexes=4 cleverness=9 reliability=7 physical=4: 11.97
 * pierce: reflexes=5 cleverness=8 reliability=5 physical=7: 12.11
 * matthew: reflexes=7 cleverness=6 reliability=6 physical=7: 12.11
 * alan: reflexes=6 cleverness=5 reliability=8 physical=6: 12.24
 * william: reflexes=5 cleverness=5 reliability=8 physical=9: 12.27
 * natalie: reflexes=9 cleverness=6 reliability=5 physical=4: 13.19
 * harold: reflexes=4 cleverness=5 reliability=6 physical=6: 13.67
 * bruce: reflexes=3 cleverness=9 reliability=8 physical=3: 13.76
 * eriq: reflexes=9 cleverness=3 reliability=9 physical=8: 13.78
 * 03**stephen: reflexes=2 cleverness=9 reliability=5 physical=9: 14.02
 * glenn: reflexes=5 cleverness=4 reliability=7 physical=5: 14.14
 * boyd: reflexes=4 cleverness=7 reliability=3 physical=9: 14.43
 * jeff: reflexes=6 cleverness=3 reliability=9 physical=5: 14.62
 * jessica: reflexes=3 cleverness=5 reliability=8 physical=4: 14.88
 * mackenzie: reflexes=8 cleverness=3 reliability=8 physical=8: 14.99
 * morena: reflexes=6 cleverness=8 reliability=5 physical=2: 15.01
 * joseph: reflexes=6 cleverness=9 reliability=5 physical=2: 15.10
 * anne: reflexes=2 cleverness=6 reliability=6 physical=7: 15.13
 * orlando: reflexes=5 cleverness=5 reliability=4 physical=7: 15.23
 * ryan: reflexes=2 cleverness=7 reliability=4 physical=8: 15.72
 * 04**andie: reflexes=3 cleverness=7 reliability=3 physical=3: 16.83
 * ed: reflexes=8 cleverness=2 reliability=8 physical=3: 17.93
 * rachel: reflexes=1 cleverness=6 reliability=4 physical=9: 18.70
 * matt: reflexes=4 cleverness=4 reliability=7 physical=1: 19.09
 * keanu: reflexes=1 cleverness=5 reliability=6 physical=9: 19.32
 * gina: reflexes=1 cleverness=4 reliability=8 physical=9: 19.79
 * geoffrey: reflexes=7 cleverness=2 reliability=5 physical=6: 20.44
 * sarah: reflexes=4 cleverness=1 reliability=8 physical=6: 20.69
 * 05**brenton: reflexes=1 cleverness=8 reliability=7 physical=2: 20.90
 * johnny: reflexes=6 cleverness=2 reliability=6 physical=3: 21.22
 * joe: reflexes=3 cleverness=1 reliability=9 physical=5: 21.47
 * jack: reflexes=5 cleverness=1 reliability=7 physical=5: 21.49
 * eliza: reflexes=1 cleverness=4 reliability=9 physical=3: 21.57
 * tia: reflexes=4 cleverness=5 reliability=2 physical=9: 22.92
 * hugh: reflexes=1 cleverness=4 reliability=5 physical=3: 23.12
 * reginald: reflexes=3 cleverness=8 reliability=2 physical=9: 24.03
 * 06**arnold: reflexes=6 cleverness=2 reliability=8 physical=0: 24.67
 * tom: reflexes=8 cleverness=5 reliability=0 physical=6: 25.00
 * 07**richard: reflexes=9 cleverness=0 reliability=9 physical=2: 26.60
 * alexander: reflexes=7 cleverness=4 reliability=1 physical=3: 26.96
 * brianna: reflexes=8 cleverness=2 reliability=2 physical=8: 27.98
 * 08**aura: reflexes=2 cleverness=1 reliability=5 physical=4: 28.72
 * javier: reflexes=4 cleverness=1 reliability=4 physical=3: 29.75
 * 09**bill: reflexes=4 cleverness=3 reliability=1 physical=8: 35.76
 * sandra: reflexes=9 cleverness=0 reliability=2 physical=8: 37.45
 * rick: reflexes=8 cleverness=2 reliability=0 physical=1: 38.29
 * 10**jamie: reflexes=8 cleverness=1 reliability=1 physical=2: 38.74
 * 11**bonnie: reflexes=1 cleverness=3 reliability=1 physical=8: 92.75
 */
class ScaleAgentDatabase implements IFlxDestroyable
{
	var _allAgents:Array<ScaleAgent> = [];
	var _nameToAgentMap:Map<String, ScaleAgent> = new Map<String, ScaleAgent>();

	public function new()
	{
		/*
		 * These agents are approximately sorted in order of difficulty,
		 * although they each have subtle strengths and weaknesses
		 */
		{
			// grovyle is always available
			var agent:ScaleAgent = new ScaleAgent(1, 3, 1, 8);
			agent._soundAsset = AssetPaths.grovyle__mp3;
			agent._chatAsset = GrovyleResource.chat;
			agent._name = "Grovyle";
			agent._gender = PlayerData.grovMale ? PlayerData.Gender.Boy : PlayerData.Gender.Girl;
			agent.setDialogClass(GrovyleDialog);
			addAgent(agent);
		}
		if (PlayerData.hasMet("sand"))
		{
			var agent:ScaleAgent = new ScaleAgent(8, 1, 1, 2);
			agent._soundAsset = AssetPaths.sand__mp3;
			agent._chatAsset = SandslashResource.chat;
			agent._name = "Sandslash";
			agent._gender = PlayerData.sandMale ? PlayerData.Gender.Boy : PlayerData.Gender.Girl;
			agent.setDialogClass(SandslashDialog);
			addAgent(agent);
		}
		if (PlayerData.hasMet("rhyd"))
		{
			var agent:ScaleAgent = new ScaleAgent(4, 3, 1, 8);
			agent._soundAsset = AssetPaths.rhyd__mp3;
			agent._chatAsset = RhydonResource.chat;
			agent._name = "Rhydon";
			agent._gender = PlayerData.rhydMale ? PlayerData.Gender.Boy : PlayerData.Gender.Girl;
			agent.setDialogClass(RhydonDialog);
			addAgent(agent);
		}
		{
			// always add buizel; he teaches the rules anyways
			var agent:ScaleAgent = new ScaleAgent(2, 1, 5, 4);
			agent._soundAsset = AssetPaths.buizel__mp3;
			agent._chatAsset = BuizelResource.chat;
			agent._name = "Buizel";
			agent._gender = PlayerData.buizMale ? PlayerData.Gender.Boy : PlayerData.Gender.Girl;
			agent.setDialogClass(BuizelDialog);
			addAgent(agent);
		}
		if (PlayerData.hasMet("grim"))
		{
			var agent:ScaleAgent = new ScaleAgent(9, 0, 9, 2);
			agent._soundAsset = AssetPaths.grim__mp3;
			agent._chatAsset = GrimerResource.chat;
			agent._name = "Grimer";
			agent._gender = PlayerData.grimMale ? PlayerData.Gender.Boy : PlayerData.Gender.Girl;
			agent.setDialogClass(GrimerDialog);
			addAgent(agent);
		}
		if (PlayerData.hasMet("luca"))
		{
			var agent:ScaleAgent = new ScaleAgent(6, 2, 8, 0);
			agent._soundAsset = AssetPaths.luca__mp3;
			agent._chatAsset = LucarioResource.chat;
			agent._name = "Lucario";
			agent._gender = PlayerData.lucaMale ? PlayerData.Gender.Boy : PlayerData.Gender.Girl;
			agent.setDialogClass(LucarioDialog);
			addAgent(agent);
		}
		if (PlayerData.hasMet("kecl"))
		{
			var agent:ScaleAgent = new ScaleAgent(1, 8, 7, 2);
			agent._soundAsset = AssetPaths.kecleon__mp3;
			agent._chatAsset = AssetPaths.kecl_chat__png;
			agent._name = "Kecleon";
			agent._gender = PlayerData.keclMale ? PlayerData.Gender.Boy : PlayerData.Gender.Girl;
			agent.setDialogClass(KecleonDialog);
			addAgent(agent);
		}
		{
			// heracross is always available
			var agent:ScaleAgent = new ScaleAgent(2, 9, 5, 9);
			agent._soundAsset = AssetPaths.hera__mp3;
			agent._chatAsset = HeraResource.chat;
			agent._name = "Heracross";
			agent._gender = PlayerData.heraMale ? PlayerData.Gender.Boy : PlayerData.Gender.Girl;
			agent.setDialogClass(HeraDialog);
			addAgent(agent);
		}
		if (PlayerData.hasMet("smea"))
		{
			var agent:ScaleAgent = new ScaleAgent(9, 7, 8, 4);
			agent._soundAsset = AssetPaths.smea__mp3;
			agent._chatAsset = AssetPaths.smear_chat__png;
			agent._name = "Smeargle";
			agent._gender = PlayerData.smeaMale ? PlayerData.Gender.Boy : PlayerData.Gender.Girl;
			agent.setDialogClass(SmeargleDialog);
			addAgent(agent);
		}
		if (PlayerData.hasMet("magn"))
		{
			var agent:ScaleAgent = new ScaleAgent(6, 8, 9, 8);
			agent._soundAsset = AssetPaths.magn__mp3;
			agent._chatAsset = MagnResource.chat;
			agent._name = "Magnezone";
			agent._gender = PlayerData.magnMale ? PlayerData.Gender.Boy : PlayerData.Gender.Girl;
			agent.setDialogClass(MagnDialog);
			addAgent(agent);
		}
		{
			// abra is always available
			var agent:ScaleAgent = new ScaleAgent(9, 9, 9, 5);
			agent._soundAsset = AssetPaths.abra__mp3;
			agent._chatAsset = AbraResource.chat;
			agent._name = "Abra";
			agent._gender = PlayerData.abraMale ? PlayerData.Gender.Boy : PlayerData.Gender.Girl;
			agent.setDialogClass(AbraDialog);
			addAgent(agent);
		}
	}

	/**
	 * Decide the list of opponents.
	 *
	 * The opponents include the player's puzzle partner, and an opponent who's
	 * at the player's skill level. It also includes a third opponent who is
	 * usually weaker than the player, but occasionally stronger.
	 * 
	 * This is so that even bad players might *occasionally* get to play
	 * against a really strong opponent. It's not very much fun to lose, but
	 * it's at least nice to play against the stronger pokemon once in a while
	 *
	 * @return opponents the player will play against
	 */
	public function getAgents():Array<ScaleAgent>
	{
		var _agents:Array<ScaleAgent> = [];
		{
			// Player is agent #0...
			var agent:ScaleAgent = new ScaleAgent();
			agent._time = 1000000000;
			agent._chatAsset = AssetPaths.empty_chat__png;
			agent._name = PlayerData.name;
			agent._gender = PlayerData.gender;
			_agents.push(agent);
		}

		var _tempAgents:Array<ScaleAgent> = _allAgents.copy();
		// Current opponent is agent #1...
		if (_nameToAgentMap[PlayerData.PROF_NAMES[PlayerData.profIndex]] == null)
		{
			// active professor doesn't have minigame persona? ...just add someone as a placeholder
			_agents.push(_tempAgents[0]);
		}
		else {
			_agents.push(_nameToAgentMap[PlayerData.PROF_NAMES[PlayerData.profIndex]]);
		}
		_tempAgents.remove(_agents[_agents.length - 1]);

		if (PlayerData.playerIsInDen)
		{
			// player's in the den; no other opponents
			return _agents;
		}

		var fair:Bool = FlxG.random.float() > 0.1;
		var matchIndex:Int = Std.int(FlxMath.bound(PlayerData.scaleGameOpponentDifficulty * _tempAgents.length, 0, _tempAgents.length - 1));
		if (PlayerData.minigameCount[0] == 0)
		{
			// Always stick Buizel in someone's first scale game, so he can teach the rules
			for (i in 0..._tempAgents.length)
			{
				if (_tempAgents[i]._name == "Buizel")
				{
					matchIndex = i;
					break;
				}
			}
			fair = true;
		}
		// Properly matched agent is agent #2...
		_agents.push(_tempAgents.splice(matchIndex, 1)[0]);
		_tempAgents.remove(_agents[_agents.length - 1]);

		// Determine eligible agents based on difficulty...
		if (fair)
		{
			// 90% chance of fair match; remove hard professors
			_tempAgents = _tempAgents.slice(0, Std.int(Math.max(1, matchIndex)));
		}
		else {
			// 10% chance of unfair match; remove easy professors
			_tempAgents = _tempAgents.slice(Std.int(Math.min(matchIndex, _tempAgents.length - 1)), _tempAgents.length);
		}

		// Agent #3 is random, but usually worse than agent #2
		_agents.push(FlxG.random.getObject(_tempAgents));
		if (PlayerData.minigameCount[0] == 0 && _allAgents.indexOf(_agents[3]) > _allAgents.indexOf(_agents[2]))
		{
			// agent #3 is too hard for an intro game
			_agents.splice(3, 1);
		}

		return _agents;
	}

	function addAgent(agent:ScaleAgent):Void
	{
		_allAgents.push(agent);
		_nameToAgentMap[agent._name] = agent;
	}

	/**
	 * Calculates whether or not the computer opponent is too challenging. If
	 * this is the case, the computer player will offer to not play.
	 * 
	 * @param	agent computer opponent to check
	 * @return true if the computer opponent is too challenging
	 */
	public function isMismatched(agent:ScaleAgent):Bool
	{
		var matchIndex:Int = Std.int(PlayerData.scaleGameOpponentDifficulty * _allAgents.length);
		var agentIndex:Int = _allAgents.indexOf(agent);

		if (PlayerData.minigameCount[0] == 0)
		{
			var buizelIndex:Int = 0;
			for (i in 0..._allAgents.length)
			{
				if (_allAgents[i]._name == "Buizel")
				{
					buizelIndex = i;
					break;
				}
			}
			// for someone's first game -- don't match them with anyone harder than buizel
			return agentIndex > buizelIndex;
		}

		// if the player's ideal opponent is #5... then #5 and #6 are OK, but #7 is not
		return agentIndex > matchIndex + 1;
	}

	public function destroy():Void
	{
		_allAgents = FlxDestroyUtil.destroyArray(_allAgents);
		_nameToAgentMap = null;
	}
}