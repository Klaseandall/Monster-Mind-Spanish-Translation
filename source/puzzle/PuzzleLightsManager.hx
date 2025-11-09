package puzzle;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * Lights manager for puzzles, providing methods for making spotlights which
 * cover different parts of the clues or answers.
 */
class PuzzleLightsManager extends LightsManager
{
	private var _puzzleState:PuzzleState;

	public function new(puzzleState:PuzzleState)
	{
		super();
		this._puzzleState = puzzleState;
	}

	public function growLeftClueLight(clueIndex:Int, pegIndex:Int, s:FlxRect)
	{
		var rect:FlxRect = FlxRect.get(s.x, s.y - 18, s.width, s.height + 20);
		_spotlights.growSpotlight("wholeclue" + clueIndex, rect);
		_spotlights.growSpotlight("leftclue" + clueIndex, rect);
		_spotlights.addSpotlight("clue" + clueIndex + "peg" + pegIndex);
		_spotlights.growSpotlight("clue" + clueIndex + "peg" + pegIndex, rect);
	}

	public function growRightClueLight(clueIndex:Int, s:FlxRect)
	{
		var rect:FlxRect = FlxRect.get(s.x, s.y - 16, s.width, s.height + 8);
		_spotlights.growSpotlight("wholeclue" + clueIndex, rect);
		_spotlights.growSpotlight("rightclue" + clueIndex, rect);
	}

	public function addClueLight(clueIndex:Int)
	{
		_spotlights.addSpotlight("wholeclue" + clueIndex);
		_spotlights.addSpotlight("leftclue" + clueIndex);
		_spotlights.addSpotlight("rightclue" + clueIndex);
	}

	public function removeClueLight(clueIndex:Int)
	{
		_spotlights.removeSpotlight("wholeclue" + clueIndex);
		_spotlights.removeSpotlight("leftclue" + clueIndex);
		_spotlights.removeSpotlight("rightclue" + clueIndex);
		for (pegIndex in 0..._puzzleState._puzzle._pegCount)
		{
			_spotlights.removeSpotlight("clue" + clueIndex + "peg" + pegIndex);
		}
	}
}