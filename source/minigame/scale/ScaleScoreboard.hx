package minigame.scale;

import MmStringTools.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import kludge.FlxSoundKludge;
import minigame.MinigameState.denNerf;
import minigame.scale.ScaleAgent;
import minigame.scale.ScaleGameState;

/**
 * The scoreboard which displays during the scale scoreboard, to show the
 * player how they're measuring up against each of their opponents
 */
class ScaleScoreboard extends FlxGroup
{
	private var _accumulationPerSecond:Float = 0;

	private var _scoreboardBg:FlxSprite;
	private var _scaleGameState:ScaleGameState;
	private var _scoreTexts:Array<FlxText> = [];
	private var _showingRoundScores:Bool = false;
	private var _accumulatingTotalScores:Bool = false;
	private var _accumulationTimer:Float = 0;
	private var _accumulateSfx:FlxSound;
	private var _victoryParticles:FlxEmitter;

	public function new(scaleGameState:ScaleGameState)
	{
		super();
		this._scaleGameState = scaleGameState;
		this._accumulationPerSecond = denNerf(125);

		_scoreboardBg = new FlxSprite(0, 0);
		_scoreboardBg.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(_scoreboardBg);

		_accumulateSfx = FlxG.sound.load(FlxSoundKludge.fixPath(AssetPaths.cash_accumulate_0065__mp3));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		updateAgentSpritePositions();

		if (_accumulatingTotalScores)
		{
			_accumulationTimer += elapsed;
			var accumulationAmount:Float = _accumulationPerSecond * _accumulationTimer;
			_accumulationTimer -= Std.int(accumulationAmount) / _accumulationPerSecond;
			accumulationAmount = Std.int(accumulationAmount);
			for (i in 0..._scoreTexts.length)
			{
				var accumulationAmount:Int = Std.int(Math.min(accumulationAmount, _scaleGameState._scalePlayerStatus._roundScores[i]));
				_scaleGameState._scalePlayerStatus._totalScores[i] += accumulationAmount;
				_scaleGameState._scalePlayerStatus._roundScores[i] -= accumulationAmount;
			}
			var accumulating:Bool = false;
			for (i in 0..._scoreTexts.length)
			{
				if (_scaleGameState._scalePlayerStatus._roundScores[i] > 0)
				{
					accumulating = true;
				}
			}
			if (!accumulating)
			{
				_accumulatingTotalScores = false;
				_accumulateSfx.stop();
			}
		}
	}

	public function init()
	{
		var bottom:Float = 33 + 42 * (_scaleGameState._agentSprites.length);

		var tmpSprite:FlxSprite = new FlxSprite();
		tmpSprite.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);

		FlxSpriteUtil.beginDraw(OptionsMenuState.MEDIUM_BLUE);
		OptionsMenuState.octagon(192, 20, 576, bottom, 2);
		FlxSpriteUtil.endDraw(tmpSprite);

		var rectSprite:FlxSprite = new FlxSprite();
		rectSprite.makeGraphic(149, Std.int(bottom - 30), OptionsMenuState.LIGHT_BLUE, true);
		rectSprite.alpha = 0.5;
		var diagonalX:Int = Std.int( -rectSprite.height);
		do
		{
			FlxSpriteUtil.drawLine(rectSprite, -rectSprite.height + diagonalX - 10, -10, diagonalX + 10, rectSprite.height + 10, { thickness:7, color:OptionsMenuState.MEDIUM_BLUE });
			diagonalX += 18;
		}
		while (diagonalX < rectSprite.width + rectSprite.height);
		tmpSprite.stamp(rectSprite, 422, 25);
		tmpSprite.alpha = 0.77;
		_scoreboardBg.stamp(tmpSprite, 0, 0);

		FlxSpriteUtil.flashGfx.clear();
		FlxSpriteUtil.setLineStyle({ thickness:9, color:OptionsMenuState.DARK_BLUE });
		OptionsMenuState.octagon(192, 20, 576, bottom, 2);
		FlxSpriteUtil.updateSpriteGraphic(_scoreboardBg);

		FlxSpriteUtil.flashGfx.clear();
		FlxSpriteUtil.setLineStyle({ thickness:7, color:OptionsMenuState.WHITE_BLUE });
		OptionsMenuState.octagon(192, 20, 576, bottom, 2);
		FlxSpriteUtil.updateSpriteGraphic(_scoreboardBg);

		for (i in 0..._scaleGameState._agentSprites.length)
		{
			var scoreText:FlxText = new FlxText(0, 0, 100, "0", 30);
			_scoreTexts.push(scoreText);
			scoreText.font = AssetPaths.hardpixel__otf;
			scoreText.color = OptionsMenuState.LIGHT_BLUE;
			scoreText.setBorderStyle(OUTLINE, OptionsMenuState.MEDIUM_BLUE, 2);
			add(scoreText);
		}
	}

	public function eventShowRoundScores(args:Dynamic)
	{
		_showingRoundScores = true;
		_accumulatingTotalScores = false;
	}

	public function eventShowTotalScores(args:Dynamic)
	{
		_showingRoundScores = false;
		_accumulatingTotalScores = false;
		for (agent in _scaleGameState._scalePlayerStatus._agents)
		{
			// remove "1st/2nd" frames when accumulating scores
			agent._finishedOrder = ScaleAgent.UNFINISHED;
		}
	}

	public function eventAccumulateTotalScores(args:Dynamic)
	{
		_showingRoundScores = false;
		_accumulatingTotalScores = true;
		_accumulationTimer = 0;
		_accumulateSfx.play();
	}

	function updateAgentSpritePositions()
	{
		for (i in 0..._scaleGameState._agentSprites.length)
		{
			_scaleGameState._agentSprites[i].x = 192 + 8 + Math.min(245, 225 * _scaleGameState._scalePlayerStatus._totalScores[i] / denNerf(ScaleGameState.TARGET_SCORE));
			_scaleGameState._agentSprites[i].y = 20 + 8 + 42 * i;
			if (_showingRoundScores)
			{
				_scoreTexts[i].text = "+" + _scaleGameState._scalePlayerStatus._roundScores[i];
			}
			else
			{
				_scoreTexts[i].text = commaSeparatedNumber(_scaleGameState._scalePlayerStatus._totalScores[i]);
			}
			_scoreTexts[i].x = _scaleGameState._agentSprites[i].x + _scaleGameState._agentSprites[i].width + 8;
			_scoreTexts[i].y = _scaleGameState._agentSprites[i].y - 2;
		}
		if (_victoryParticles == null)
		{
			for (i in 0..._scaleGameState._agentSprites.length)
			{
				if (_scaleGameState._scalePlayerStatus._totalScores[i] >= denNerf(ScaleGameState.TARGET_SCORE))
				{
					// victory
					if (_scaleGameState._scalePlayerStatus._agents[i]._soundAsset != null)
					{
						SoundStackingFix.play(_scaleGameState._scalePlayerStatus._agents[i]._soundAsset, 0.25);
					}
					if (_victoryParticles == null)
					{
						SoundStackingFix.play(AssetPaths.finish_scalegame_00b9__mp3);
						_victoryParticles = new FlxEmitter(0, 0, 32);
						add(_victoryParticles);
						_victoryParticles.angularVelocity.set(0);
						_victoryParticles.launchMode = FlxEmitterMode.CIRCLE;
						_victoryParticles.speed.set(60, 120, 0, 0);
						_victoryParticles.acceleration.set(0);
						_victoryParticles.alpha.set(0.88, 0.88, 0, 0);
						_victoryParticles.lifespan.set(0.6);

						for (i in 0..._victoryParticles.maxSize)
						{
							var particle:FlxParticle = new MinRadiusParticle(18);
							particle.makeGraphic(3, 3, 0xFFFFFFFF);
							particle.exists = false;
							_victoryParticles.add(particle);
						}
					}
					_victoryParticles.x = _scaleGameState._agentSprites[i].x + _scaleGameState._agentSprites[i].width / 2;
					_victoryParticles.y = _scaleGameState._agentSprites[i].y + _scaleGameState._agentSprites[i].height / 2;

					_victoryParticles.start(true, 0, 1);
					for (j in 0...8)
					{
						_victoryParticles.emitParticle();
					}
				}
			}
		}
		if (_showingRoundScores)
		{
			for (i in 1..._scaleGameState._scalePlayerStatus._agents.length)
			{
				if (_scaleGameState._scalePlayerStatus._agents[i]._finishedOrder == 1)
				{
					_scaleGameState._agentSprites[i].animation.frameIndex = 2;
				}
				else if (_scaleGameState._scalePlayerStatus._agents[i]._finishedOrder < ScaleAgent.UNFINISHED)
				{
					_scaleGameState._agentSprites[i].animation.frameIndex = 4;
				}
				else
				{
					_scaleGameState._agentSprites[i].animation.frameIndex = 8;
				}
			}
		}
		else
		{
			var lowScore:Int = 1000;
			var hiScore:Int = 0;
			for (i in 0..._scaleGameState._scalePlayerStatus._agents.length)
			{
				lowScore = Std.int(Math.min(lowScore, _scaleGameState._scalePlayerStatus._totalScores[i]));
				hiScore = Std.int(Math.max(hiScore, _scaleGameState._scalePlayerStatus._totalScores[i]));
			}
			for (i in 1..._scaleGameState._scalePlayerStatus._agents.length)
			{
				if (_scaleGameState._scalePlayerStatus._totalScores[i] == hiScore)
				{
					_scaleGameState._agentSprites[i].animation.frameIndex = 2;
				}
				else if (_scaleGameState._scalePlayerStatus._totalScores[i] != lowScore)
				{
					_scaleGameState._agentSprites[i].animation.frameIndex = 4;
				}
				else
				{
					_scaleGameState._agentSprites[i].animation.frameIndex = 8;
				}
			}
		}
	}
}