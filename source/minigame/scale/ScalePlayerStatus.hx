package minigame.scale;
import flixel.FlxG;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import kludge.FlxSoundKludge;
import minigame.MinigameState.denNerf;
import minigame.scale.ScaleAgent;

/**
 * Tracks the state of a round in the scale minigame -- whether the player's
 * finished, whether the computer players have finished, and how much time is
 * left in the round.
 */
class ScalePlayerStatus implements IFlxDestroyable
{
	public var _totalScores:Array<Int> = [];
	/**
	 * _agents[0] = human
	 * _agents[1] = leader -- the person you were solving puzzles with, unless he hands it off
	 * _agents[2...x] = other opponents
	 */
	public var _agents:Array<ScaleAgent>;
	public var _roundScores:Array<Int> = [];
	private var _remainingRewards:Array<Int>;
	public var _elapsedPuzzleTime:Float = 0;
	public var _doneCallback:Void->Void;
	public var _remainingPuzzleTime:Float = 1000000000;
	private var _roundRunning:Bool = false;
	private var _agentDatabase:ScaleAgentDatabase = new ScaleAgentDatabase();

	public function new()
	{
		_agents = _agentDatabase.getAgents();

		initializeRemainingRewards();

		for (i in 0..._agents.length)
		{
			_totalScores.push(0);
			_roundScores.push(0);
		}
	}

	function initializeRemainingRewards()
	{
		_remainingRewards = [denNerf(125), denNerf(200)];
	}

	public function update(elapsed:Float)
	{
		if (_roundRunning)
		{
			_remainingPuzzleTime -= elapsed;
			_elapsedPuzzleTime += elapsed;

			for (i in 1..._agents.length)
			{
				var agent:ScaleAgent = _agents[i];
				if (!agent.isDone() && agent._time <= _elapsedPuzzleTime)
				{
					if (agent._soundAsset != null)
					{
						FlxSoundKludge.play(agent._soundAsset, 0.25);
					}
					playerFinished(i);
				}
			}
		}
	}

	public function playerFinished(index:Int)
	{
		_agents[index]._finishedOrder = _agents.filter(function(s) return s.isDone()).length + 1;
		_roundScores[index] = _remainingRewards.length > 0 ? _remainingRewards.pop() : MinigameState.denNerf(50);
		_remainingPuzzleTime = Math.min(_remainingPuzzleTime, 30);
		if (_doneCallback != null)
		{
			_doneCallback();
		}
	}

	public function isRoundOver():Bool
	{
		var allAgentsDone:Bool = _agents.filter(function(s) return s.isDone()).length == _agents.length;
		if (!_roundRunning)
		{
			return false;
		}
		if (allAgentsDone)
		{
			return true;
		}
		if (_remainingPuzzleTime <= 0)
		{
			return true;
		}
		return false;
	}

	public function finishRound():Void
	{
		_roundRunning = false;
	}

	public function startRound(_puzzle:ScalePuzzle):Void
	{
		_elapsedPuzzleTime = 0;
		_remainingPuzzleTime = 1000000000;
		initializeRemainingRewards();
		_roundRunning = true;

		var shouldHaveMercy:Bool = false;
		for (i in 1..._agents.length)
		{
			if (_totalScores[i] >= _totalScores[0] + denNerf(400))
			{
				shouldHaveMercy = true;
			}
		}
		if (shouldHaveMercy)
		{
			for (i in 1..._agents.length)
			{
				_agents[i]._mercy += (_totalScores[i] - _totalScores[0]) / denNerf(100);
			}
		}
		else {
			for (i in 1..._agents.length)
			{
				_agents[i]._mercy = 0;
			}
		}

		for (agent in _agents)
		{
			agent._finishedOrder = ScaleAgent.UNFINISHED;
		}
		for (i in 1..._agents.length)
		{
			_agents[i].computeTime(_puzzle._totalPegCount, _puzzle._sum);
		}
	}

	public function isGameOver():Bool
	{
		for (i in 0..._agents.length)
		{
			if (_roundScores[i] + _totalScores[i] >= denNerf(ScaleGameState.TARGET_SCORE))
			{
				return true;
			}
		}
		return false;
	}

	public function isMismatched()
	{
		return _agentDatabase.isMismatched(_agents[1]);
	}

	public function destroy():Void
	{
		_totalScores = null;
		_agents = FlxDestroyUtil.destroyArray(_agents);
		_roundScores = null;
		_remainingRewards = null;
		_doneCallback = null;
		_agentDatabase = FlxDestroyUtil.destroy(_agentDatabase);
	}
}