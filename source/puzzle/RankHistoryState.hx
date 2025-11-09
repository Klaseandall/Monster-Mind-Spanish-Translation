package puzzle;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import kludge.FlxSoundKludge;

/**
 * An FlxState which shows a player's recent rank calculations and rank changes
 *
 * During development, my testers occasionally complained about their rank
 * randomly changing. But those random rank changes mysteriously stopped
 * happening, once I created a way to monitor them.
 */
class RankHistoryState extends FlxState
{

	public function new()
	{
		super();
		PlayerSave.flush();
		if (PlayerData.rankHistoryLog.length == 0)
		{
			add(new FlxText(0, 0, 0, "-empty-"));
		}
		else
		{
			var x:Int = 0;
			var y:Int = 0;
			for (i in 0...PlayerData.rankHistoryLog.length)
			{
				add(new FlxText(x, y, 0, (i + 1) + ". " + PlayerData.rankHistoryLog[i]));
				y += 10;
				if (y > FlxG.height - 10)
				{
					y = 0;
					x += 240;
				}
			}
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.firstJustPressed() != -1 || FlxG.mouse.justPressed)
		{
			FlxSoundKludge.play(AssetPaths.beep_0065__mp3);
			FlxG.switchState(new MainMenuState());
		}
	}
}