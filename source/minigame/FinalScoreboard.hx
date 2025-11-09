package minigame;

import MmStringTools.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;

/**
 * Parent class which handles scoreboard logic which is common to all of the
 * minigames
 */
class FinalScoreboard extends FlxGroup
{
	private var _scoreboardBg:FlxSprite;

	private var _bonusGroups:Array<FlxGroup> = [];
	private var _bonusGroupIndex:Int = 0;

	private var _bonusY:Int = 25;
	public var _totalReward:Int = 0;

	public function new()
	{
		super();
		_scoreboardBg = new FlxSprite(0, 0);
		_scoreboardBg.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(_scoreboardBg);

		addBonuses();

		var totalGroup:FlxGroup = new FlxGroup();
		_bonusGroups.push(totalGroup);

		var bottomY:Float = Math.max(175, _bonusY);
		var bottom:Float = bottomY + 35;

		totalGroup.add(leftText(bottomY, "Total:"));
		totalGroup.add(rightText(bottomY, commaSeparatedNumber(_totalReward) + "$"));

		FlxSpriteUtil.beginDraw(OptionsMenuState.MEDIUM_BLUE & 0xCCFFFFFF);
		OptionsMenuState.octagon(192, 20, 576, bottom, 2);
		FlxSpriteUtil.endDraw(_scoreboardBg);

		FlxSpriteUtil.flashGfx.clear();
		FlxSpriteUtil.setLineStyle({ thickness:9, color:OptionsMenuState.DARK_BLUE });
		OptionsMenuState.octagon(192, 20, 576, bottom, 2);
		FlxSpriteUtil.updateSpriteGraphic(_scoreboardBg);

		FlxSpriteUtil.flashGfx.clear();
		FlxSpriteUtil.setLineStyle({ thickness:7, color:OptionsMenuState.WHITE_BLUE });
		OptionsMenuState.octagon(192, 20, 576, bottom, 2);
		FlxSpriteUtil.updateSpriteGraphic(_scoreboardBg);
	}

	public function addBonuses()
	{
	}

	public function addBonus(bonusDesc:String, amount:Int)
	{
		var bonusGroup:FlxGroup = new FlxGroup();
		_bonusGroups.push(bonusGroup);
		bonusGroup.add(leftText(_bonusY, bonusDesc + ":"));
		bonusGroup.add(rightText(_bonusY, commaSeparatedNumber(amount) + "$"));

		_bonusY += 50;
		_totalReward += amount;
	}

	public function addScore(scoreDesc:String, amount:Int)
	{
		var leftGroup:FlxGroup = new FlxGroup();
		_bonusGroups.push(leftGroup);
		leftGroup.add(leftText(_bonusY, "Score:"));

		var rightGroup:FlxGroup = new FlxGroup();
		_bonusGroups.push(rightGroup);
		rightGroup.add(rightText(_bonusY, commaSeparatedNumber(amount) + "$"));

		_bonusY += 50;
		_totalReward += amount;
	}

	public function getBonusGroupCount():Int
	{
		return _bonusGroups.length;
	}

	public function eventTurnOnBonusGroup(args:Dynamic):Void
	{
		SoundStackingFix.play(AssetPaths.beep_0065__mp3);
		add(_bonusGroups[_bonusGroupIndex++]);
	}

	private function leftText(Y:Float, ?Text:String):FlxText
	{
		var flxText:FlxText = new FlxText(197, Y - 6, 274, Text, 30);
		flxText.font = AssetPaths.hardpixel__otf;
		flxText.color = ItemsMenuState.WHITE_BLUE;
		return flxText;
	}

	private function rightText(Y:Float, ?Text:String):FlxText
	{
		var flxText:FlxText = new FlxText(466, Y - 6, 110, Text, 30);
		flxText.alignment = FlxTextAlign.RIGHT;
		flxText.font = AssetPaths.hardpixel__otf;
		flxText.color = ItemsMenuState.WHITE_BLUE;
		return flxText;
	}

	override public function destroy():Void
	{
		super.destroy();

		_scoreboardBg = FlxDestroyUtil.destroy(_scoreboardBg);
		_bonusGroups = FlxDestroyUtil.destroyArray(_bonusGroups);
	}
}