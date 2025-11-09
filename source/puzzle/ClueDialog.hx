package puzzle;

import MmStringTools.*;
import flixel.FlxG;
import openfl.utils.Object;

/**
 * Pokemon have about 3 things they say when you give the incorrect answer to a
 * puzzle, things like "Oh, something's wrong with the third clue" and "That
 * clue has 3 hearts, but only 2 bugs in the correct position."
 * 
 * This class acts as a model for all of the phrases a particular Pokemon says
 * when you mess up the answer to a puzzle.
 */
class ClueDialog
{
	private var tree:Array<Array<Object>>;
	public var clueString:String;
	public var clueSymbol:String;
	public var bugType:String;
	public var expectedBugType:String;
	public var expectedCount:Int = 0;
	public var actualBugType:String;
	public var actualCount:Int = 0;
	public var greetings:Array<String>;
	private var _lightsOnIndex:Int = 31;
	
	public function new(tree:Array<Array<Object>>, puzzleState:PuzzleState) 
	{
		this.tree = tree;
		computeMistakeInfo(puzzleState);
		tree[1] = [10, 20, 30];
		tree[10] = [FlxG.random.getObject(["Oops", "Crap", "Ugh"])];
		tree[11] = ["%lights-on%"];
		tree[20] = [FlxG.random.getObject(["Yeah", "I see", "Right"])];
		tree[21] = ["%lights-on%"];
		tree[30] = [FlxG.random.getObject(["What?", "Huh?", "Ehh?", "I don't\nget it"])];
		tree[31] = ["%lights-on%"];
		tree[10000] = ["%lights-on%"];
	}
	
	public function setOops0(s:String) {
		tree[10] = [s];
	}
	
	public function setOops1(s:String) {
		tree[20] = [s];
	}
	
	public function setHelp(s:String) {
		tree[30] = [s];
	}
	
	private function computeMistakeInfo(puzzleState:PuzzleState) 
	{
		var mistake:PuzzleState.Mistake = puzzleState.computeMistake();
		
		clueString = ["first clue", "second clue", "third clue", "fourth clue", "fifth clue", "sixth clue", "seventh clue", "eighth clue"][mistake.clueIndex];
		if (Std.int(mistake.expectedMarkers / 10) != Std.int(mistake.actualMarkers / 10)) {
			expectedCount = Std.int(mistake.expectedMarkers / 10);
			actualCount = Std.int(mistake.actualMarkers / 10);
			clueSymbol = englishNumber(expectedCount) + " " + "hearts";
			bugType = "bugs in the correct position";
		} else {
			expectedCount = mistake.expectedMarkers % 10;
			actualCount = mistake.actualMarkers % 10;
			clueSymbol = englishNumber(expectedCount) + " " + (puzzleState._puzzle._easy ? "hearts" : "dots");
			bugType = puzzleState._puzzle._easy ? "bugs correct" : "bugs in the wrong position";
		}
		expectedBugType = englishNumber(expectedCount) + " " + bugType;
		actualBugType = englishNumber(actualCount) + " " + bugType;
		
		expectedBugType = StringTools.replace(expectedBugType, "one bugs", "one bug");
		actualBugType = StringTools.replace(actualBugType, "one bugs", "one bug");
		
		clueSymbol = StringTools.replace(clueSymbol, "one hearts", "one heart");
		clueSymbol = StringTools.replace(clueSymbol, "one hearts", "one heart");
		clueSymbol = StringTools.replace(clueSymbol, "one dots", "one dot");		
	}
	
	private function filter(?startIndex:Int, ?endIndex:Int) {
		if (endIndex == null) {
			if (startIndex != null) {
				endIndex = startIndex;
			} else {
				endIndex = tree.length - 1;
			}
		}
		if (startIndex == null) {
			startIndex = 0;
		}
		for (i in startIndex...endIndex + 1) {
			DialogTree.replace(tree, i, "<first clue>", clueString);
			DialogTree.replace(tree, i, "<First clue>", clueString.charAt(0).toUpperCase() + clueString.substring(1));
			DialogTree.replace(tree, i, "<bugs in the correct position>", bugType);
			DialogTree.replace(tree, i, "<e hearts>", clueSymbol);
			DialogTree.replace(tree, i, "<e bugs in the correct position>", expectedBugType);
			DialogTree.replace(tree, i, "<a bugs in the correct position>", actualBugType);
			DialogTree.replace(tree, i, "<e>", englishNumber(expectedCount));
			DialogTree.replace(tree, i, "<a>", englishNumber(actualCount));
		}
	}
	
	public function setGreetings(greetings:Array<String>) 
	{
		tree[0] = [cast FlxG.random.getObject(greetings)];
		filter(0);
	}
	
	public function pushExplanation(string:String) 
	{
		tree[_lightsOnIndex] = [string];
		filter(_lightsOnIndex);
		_lightsOnIndex++;
		tree[_lightsOnIndex] = ["%lights-on%"];
	}
	
	public function fixExplanation(sub:String, by:String) 
	{
		DialogTree.replace(tree, _lightsOnIndex - 1, sub, by);
	}
	
	public function setQuestions(array:Array<String>) 
	{
		tree[30] = [cast FlxG.random.getObject(array)];
	}
}