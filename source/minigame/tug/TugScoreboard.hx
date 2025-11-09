package minigame.tug;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import kludge.FlxSoundKludge;
import minigame.MinigameState.denNerf;
import minigame.tug.TugGameState;

/**
 * The scoreboard which displays during the tug-of-war minigame, showing the
 * player how they're measuring up against their opponent
 */
class TugScoreboard extends FlxGroup
{
	private var accumulationPerSecond:Float = 0;
	private var accumulatingTotalScores:Bool = false;
	private var accumulateSfx:FlxSound;
	private var accumulationTimer:Float = 0;

	public var finishedTimer:Float = -1;

	private var scoreboardBg:FlxSprite;
	private var comScores:Array<FlxText> = [];
	private var manScores:Array<FlxText> = [];

	public var comTotalScore:Int = 0;
	private var comVisualScore:Int = 0;
	public var manTotalScore:Int = 0;
	private var manVisualScore:Int = 0;
	private var tugGameState:TugGameState;

	public var comPortrait:FlxSprite;

	public function new(tugGameState:TugGameState)
	{
		super();
		this.tugGameState = tugGameState;

		accumulationPerSecond = denNerf(250);
		accumulateSfx = FlxG.sound.load(FlxSoundKludge.fixPath(AssetPaths.cash_accumulate_0065__mp3));

		scoreboardBg = new FlxSprite(0, 0);
		scoreboardBg.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(scoreboardBg);

		var tmpSprite:FlxSprite = new FlxSprite();
		tmpSprite.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		FlxSpriteUtil.beginDraw(OptionsMenuState.MEDIUM_BLUE);
		OptionsMenuState.octagon(268, 20, 500, 342, 2);
		FlxSpriteUtil.endDraw(tmpSprite);
		FlxSpriteUtil.drawLine(tmpSprite, 302, 150, 466, 150, {color:OptionsMenuState.LIGHT_BLUE, thickness:4});
		FlxSpriteUtil.drawLine(tmpSprite, 302, 220, 466, 220, {color:OptionsMenuState.LIGHT_BLUE, thickness:4});
		FlxSpriteUtil.drawLine(tmpSprite, 292, 290, 476, 290, {color:OptionsMenuState.LIGHT_BLUE, thickness:6});
		tmpSprite.alpha = 0.88;
		scoreboardBg.stamp(tmpSprite);

		FlxSpriteUtil.flashGfx.clear();
		FlxSpriteUtil.setLineStyle({ thickness:9, color:OptionsMenuState.DARK_BLUE });
		OptionsMenuState.octagon(268, 20, 500, 342, 2);
		FlxSpriteUtil.updateSpriteGraphic(scoreboardBg);

		FlxSpriteUtil.flashGfx.clear();
		FlxSpriteUtil.setLineStyle({ thickness:7, color:OptionsMenuState.WHITE_BLUE });
		OptionsMenuState.octagon(268, 20, 500, 342, 2);
		FlxSpriteUtil.updateSpriteGraphic(scoreboardBg);

		comPortrait = new FlxSprite(303, 30);
		comPortrait.loadGraphic(tugGameState.agent.chatAsset, true, 73, 71);
		comPortrait.scale.x = 0.55;
		comPortrait.scale.y = 0.55;
		comPortrait.updateHitbox();
		comPortrait.animation.frameIndex = 4;
		add(comPortrait);

		var comFrame:RoundedRectangle = new RoundedRectangle();
		var borderColor:FlxColor = ItemsMenuState.DARK_BLUE;
		var centerColor:FlxColor = FlxColor.TRANSPARENT;
		comFrame.relocate(Std.int(comPortrait.x - 1), Std.int(comPortrait.y - 1), Std.int(comPortrait.width + 2), Std.int(comPortrait.height + 2), borderColor, centerColor, 2);
		add(comFrame);

		var manPortrait:FlxSprite = new FlxSprite(425, 30);
		manPortrait.loadGraphic(AssetPaths.empty_chat__png, true, 73, 71, false, "20CSEUNSH0");
		manPortrait.stamp(tugGameState._handSprite, -50, -70);
		manPortrait.scale.x = 0.55;
		manPortrait.scale.y = 0.55;
		manPortrait.updateHitbox();
		add(manPortrait);

		var manFrame:RoundedRectangle = new RoundedRectangle();
		var borderColor:FlxColor = ItemsMenuState.DARK_BLUE;
		var centerColor:FlxColor = FlxColor.TRANSPARENT;
		manFrame.relocate(Std.int(manPortrait.x - 1), Std.int(manPortrait.y - 1), Std.int(manPortrait.width + 2), Std.int(manPortrait.height + 2), borderColor, centerColor, 2);
		add(manFrame);

		var scoreY:Int = 78;
		for (i in 0...7)
		{
			var comScore:FlxText = new FlxText(264, scoreY, 118, "", i == 6 ? 40 : 30);
			comScore.alignment = "center";
			comScore.font = AssetPaths.hardpixel__otf;
			comScore.color = ItemsMenuState.WHITE_BLUE;
			add(comScore);
			comScores.push(comScore);

			var manScore:FlxText = new FlxText(386, scoreY, 118, "", i == 6 ? 40 : 30);
			manScore.alignment = "center";
			manScore.font = AssetPaths.hardpixel__otf;
			manScore.color = ItemsMenuState.WHITE_BLUE;
			add(manScore);
			manScores.push(manScore);

			scoreY += (i % 2 == 0 ? 30 : 40);
		}

		comScores[6].text = "0";
		manScores[6].text = "0";
	}

	public function appendScores(scoreIndex:Int, comScoreString:String, manScoreString:String)
	{
		comScores[scoreIndex].text = comScoreString;
		manScores[scoreIndex].text = manScoreString;

		comTotalScore = 0;
		manTotalScore = 0;
		for (i in 0...6)
		{
			comTotalScore += Std.parseInt(comScores[i].text);
		}
		for (i in 0...6)
		{
			manTotalScore += Std.parseInt(manScores[i].text);
		}

		SoundStackingFix.play(AssetPaths.beep_0065__mp3);
	}

	public function accumulateScores()
	{
		accumulatingTotalScores = true;
		accumulateSfx.play();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (accumulatingTotalScores)
		{
			accumulationTimer += elapsed;
			var accumulationAmount:Float = accumulationPerSecond * accumulationTimer;
			accumulationTimer -= Std.int(accumulationAmount) / accumulationPerSecond;
			accumulationAmount = Std.int(accumulationAmount);

			if (accumulationAmount > 0)
			{
				comVisualScore = Std.int(Math.min(comVisualScore + accumulationAmount, comTotalScore));
				manVisualScore = Std.int(Math.min(manVisualScore + accumulationAmount, manTotalScore));
				comScores[6].text = MmStringTools.commaSeparatedNumber(comVisualScore);
				manScores[6].text = MmStringTools.commaSeparatedNumber(manVisualScore);
			}

			if (comVisualScore == comTotalScore && manVisualScore == manTotalScore)
			{
				accumulatingTotalScores = false;
				accumulateSfx.stop();
				tugGameState.setChatFace(FlxG.random.getObject(tugGameState.agent.neutralFaces));

				finishedTimer = 0;
			}
		}

		if (finishedTimer >= 0)
		{
			finishedTimer += elapsed;
		}
	}

	public function show()
	{
		finishedTimer = -1;
		exists = true;
		visible = true;
	}

	public function isFlawlessWin()
	{
		return Std.parseInt(manScores[1].text) > 0
			   && Std.parseInt(manScores[3].text) > 0
			   && Std.parseInt(manScores[5].text) > 0;
	}
}