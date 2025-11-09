package;

import haxe.Timer;
import MmStringTools.*;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import openfl.utils.Object;

/**
 * Class which handles logic for a single tree of dialog -- a single
 * conversation with a beginning, end and (optionally) a few choices along the
 * way.
 *
 * As input, this takes a 2-dimensional array of input. The 2-dimensional looks
 * something like this:
 *
 * tree[0] = ["#grov04#Say! What's your favorite part of these puzzles anyways?"];
 * tree[1] = ["%disable-skip%"];
 * tree[2] = [10, 20, 30, 40];
 * tree[10] = ["Our\nconversations"];
 * tree[11] = ["#grov00#Ah! Our conversations? Ours specifically? Why that's so flattering, thank you so much... And yet..."];
 * tree[12] = ["#grov10#It also places a tremendous burden on me to say something interesting! Ummm..."];
 * tree[13] = ["#grov03#Life is about the destination... not about the journey."];
 * tree[14] = [60];
 * tree[20] = ["Solving the\npuzzles"];
 * tree[21] = ["#grov02#Ah yes! There's nothing quite like working through a nice puzzle."];
 * tree[22] = ["#grov05#Of course, hitting the little button at the end doesn't mean much of anything! It's about figuring it out, those little leaps of logic along the way."];
 * tree[23] = ["#grov03#Just like how life is about the destination... not about the journey."];
 * tree[24] = [60];
 *
 * Each line in the input array can be one of the following things:
 *
 * 1. A line of dialog: "#grov04#Say! What's your favorite part...?"
 *
 *     This represents a line of dialog. Lines of dialog should always start
 *     with a six-character code which includes a prefix like "grov" and a
 *     facial expression like "04". The number 04 is an index into the chat
 *     asset, "grovyle-chat.png" in this case.
 *
 * 2. A decision point for several branches of dialog: [10, 20, 30, 40]
 *
 *     This represents several choices the player can decide between; the
 *     dialog can branch to index 10, 20, 30 or 40 in the dialog array. That
 *     index in the dialog array will be shown to the player literally, so it
 *     should always be a dialog branch.
 *
 * 3. A redirect: [60]
 *
 *     This represents a redirect to a new branch of dialog; in this case, line
 *     60. This can be used when multiple branches of dialog result in the same
 *     dialog, or could be used to deliberately repeat dialog.
 *
 * 4. A dialog branch: "Our\nconversations"
 *
 *     This represents a choice the player can make, which is typically
 *     followed by some dialog -- but could also be followed by a redirect, if
 *     multiple choices result in identical dialog with no side-effects
 *
 * 5. Null
 *
 *    Any indexes of the array which are null or unassigned will cause the
 *    dialog to terminate, even if there's additional dialog later in the
 *    array. So in other words you might have a flow of dialog which progresses
 *    from lines 10-15, but if line 13 is unassigned then the dialog will
 *    terminate after line 12.
 *
 * 6. A command: "%disable-skip%"
 *
 *    Lines starting with a percent sign represent internal commands which
 *    shouldn't be seen by the player. They might do things like turn light on
 *    and off, manipulate bugs during tutorials, or make the pokemon adopt
 *    different poses or run away.
 *
 *    DialogTree's invokers can receive notification of these commands via a
 *    callback mechanism.
 *
 * The DialogTree class will show the dialog starting at index[0], followed by
 * index[1], [2] and so on, until a null index is reached at which point the
 * dialog terminates.
 *
 * The player can choose to skip dialog, which will usually cause the dialog to
 * immediately terminate without consequence. However, sometimes skipping the
 * dialog will lead to consequences or possibly even additional dialog  -- for
 * example, there might be a dialog sequence where a Pokemon will give a player
 * $1,000 he's owed, in which case we don't want the player to be robbed
 * because they skipped the dialog. So when the player skips dialog we skip to
 * index[10,000] in the array. This will usually be null and end the dialog
 * sequence, but that's where you can put commands or behavior you want to
 * occur when the player hits the skip button.
 */
class DialogTree implements IFlxDestroyable
{
	var _tree:Array<Array<Object>> = new Array<Array<Object>>();
	var _dialogger:Dialogger;
	var _currentLine:Int = 0;
	var _dialogging:Bool = false;

	/**
	 * The dialogTreeCallback is invoked with any lines starting with a '%'.
	 * If the callback returns a non-null string, that string will be shown as
	 * dialog to the user
	 */
	var _dialogTreeCallback:String->String;

	/**
	 * Initializes a DialogTree with the specified dialog and callback
	 *
	 * @param	dialogger
	 * @param	Tree
	 * @param	DialogTreeCallback
	 */
	public function new(dialogger:Dialogger, Tree:Array<Array<Object>>, ?DialogTreeCallback:String->String)
	{
		this._dialogger = dialogger;
		this._tree = Tree;
		this._dialogTreeCallback = DialogTreeCallback;
	}

	public function destroy():Void
	{
		_tree = null;
	}

	/**
	 * Launches the dialog sequence
	 */
	public function go()
	{
		#if html5
		if (!_dialogging)
		{
			// on HTML5 the dialog panel shows the previously displayed dialog for a few frames, so
			// we don't show it right away
			_dialogger.visible = false;
			Timer.delay(() -> _dialogger.visible = true, 0);
		}
		#end

		_dialogger.reset(); // reset to avoid displaying two sets of dialog simultaneously
		_dialogging = true;
		while (_tree[_currentLine] != null && _tree[_currentLine].length == 1)
		{
			if (Std.isOfType(_tree[_currentLine][0], Int))
			{
				// redirect
				_currentLine = cast(_tree[_currentLine][0], Int);
			}
			else if (Std.isOfType(_tree[_currentLine][0], String) && Std.string(_tree[_currentLine][0]).substring(0, 1) == "%")
			{
				var lineStr:String = _tree[_currentLine][0];
				// command
				if (lineStr == "%enable-skip%")
				{
					_dialogger.setSkipEnabled(true);
				}
				else if (lineStr == "%disable-skip%")
				{
					_dialogger.setSkipEnabled(false);
				}
				else if (StringTools.startsWith(lineStr, "%prompts-y-offset"))
				{
					_dialogger._promptsYOffset = Std.parseInt(substringBetween(lineStr, "%prompts-y-offset", "%"));
				}
				else if (lineStr == "%prompts-dont-cover-clues%")
				{
					_dialogger._promptsDontCoverClues = true;
				}
				else if (lineStr == "%prompts-dont-cover-7peg-clues%")
				{
					_dialogger._promptsDontCover7PegClues = true;
				}
				else if (StringTools.startsWith(lineStr, "%jumpto-"))
				{
					var mark:String = substringBetween(lineStr, "%jumpto-", "%");
					jumpTo("%mark-" + mark + "%", -1);
				}
				else if (_dialogTreeCallback != null)
				{
					var result:String = _dialogTreeCallback(lineStr);
					if (result != null)
					{
						showDialog(result);
						return;
					}
				}
				_currentLine++;
			}
			else
			{
				// something normal
				break;
			}
		}
		if (_tree[_currentLine] == null)
		{
			_dialogging = false;
			if (_dialogTreeCallback != null)
			{
				_dialogTreeCallback("");
			}
			return;
		}
		showDialog(_tree[_currentLine][0]);
	}

	function showDialog(Text:String):Void
	{
		if (_tree[_currentLine + 1] != null && _tree[_currentLine + 1].length > 1)
		{
			// choice
			var choices = new Array<String>();
			for (choice in _tree[_currentLine + 1])
			{
				if (_tree[cast (choice, Int)] == null)
				{
					// error; dialog tree has a bad link in it

					// The explicit 'Std.string()' call is a workaround for Haxe issue #11235; generated .cpp files have conversion errors, "cannot convert from 'String' to 'Float'"
					// https://github.com/HaxeFoundation/haxe/issues/11235
					choices.push("(" + Std.string(choice)+")");
				}
				else
				{
					choices.push(_tree[cast (choice, Int)][0]);
				}
			}
			_dialogger.dialog(Text, callback, choices);
		}
		else
		{
			// message
			_dialogger.dialog(Text, callback, null);
		}
	}

	public function callback(choice:Int):Void
	{
		if (choice == Dialogger.SKIP)
		{
			_currentLine = 9999;
		}
		else if (choice >= 0)
		{
			_currentLine = cast (_tree[_currentLine + 1][choice], Int);
		}
		_currentLine++;
		go();
	}

	/**
	 * Replace some text on a given dialog line. This is especially useful when
	 * modifying a dialog array to account for genders or player decisions.
	 *
	 * @param	Tree dialog tree on which to perform the replacement
	 * @param	index dialog tree index on which to perform the replacement
	 * @param	sub old word/phrase to be replaced
	 * @param	by new word/phrase to act as a replacement
	 */
	public static function replace(Tree:Array<Array<Object>>, index:Int, sub:String, by:String)
	{
		if (Tree[index] != null && Std.isOfType(Tree[index][0], String))
		{
			Tree[index][0] = StringTools.replace(Tree[index][0], sub, by);
		}
	}

	public static function durationToString(durationInSeconds:Float)
	{
		var durationMap:Map<Int, String> = [
											   1 => "one second",
											   2 => "two seconds",
											   3 => "three seconds",
											   5 => "five seconds",
											   10 => "ten seconds",
											   20 => "twenty seconds",
											   30 => "thirty seconds",
											   1 * 60 => "one minute",
											   2 * 60 => "two minutes",
											   3 * 60 => "three minutes",
											   5 * 60 => "five minutes",
											   10 * 60 => "ten minutes",
											   15 * 60 => "fifteen minutes",
											   20 * 60 => "twenty minutes",
											   30 * 60 => "thirty minutes",
											   45 * 60 => "forty-five minutes"
										   ];
		var minDuration:Int = 60 * 60;
		var minDurationString:String = "one hour";
		for (key in durationMap.keys())
		{
			if (key >= durationInSeconds && key < minDuration)
			{
				minDuration = key;
				minDurationString = durationMap[key];
			}
		}
		return minDurationString;
	}

	/**
	 * Shifts a block of dialog around within an array. For example, lines
	 * 100-200 in a dialog array might represents a certain branch of dialog,
	 * but you need to move all of that dialog to lines 150-250. This method
	 * could be used to shift those lines later in the dialog array.
	 *
	 * @param	tree dialog array to manipulate
	 * @param	firstLine first line which needs to be moved
	 * @param	lastLine last line which needs to be moved
	 * @param	amount how far should the lines be moved (positive integer)
	 * @return the "tree" input parameter
	 */
	public static function shift(tree:Array<Array<Object>>, firstLine:Int, lastLine:Int, amount:Int):Array<Array<Object>>
	{
		var i:Int = lastLine;
		while (i >= firstLine)
		{
			// move item down...
			var item:Array<Object> = tree[i];
			tree[i + amount] = tree[i];
			tree[i] = null;
			i--;

			// update any references...
			if (item != null)
			{
				for (j in 0...item.length)
				{
					if (Std.isOfType(item[j], Int))
					{
						item[j] = cast(item[j], Int) + amount;
					}
				}
			}
		}
		return tree;
	}

	/**
	 * Prepends a dialog tree with another dialog tree. For example you might
	 * have one dialog tree where Buizel talks about how he's happy to see the
	 * player, and another dialog tree where Grovyle explains how ranked mode
	 * works. This method can be used to merge the two.
	 *
	 * This method also does its best to handle ugly scenarios such as if both
	 * trees have "skip" consequences.
	 *
	 * @param	beforeTree dialog array which should go before the other
	 * @param	tree dialog array which should go after the other
	 * @return merged dialog array
	 */
	public static function prepend(beforeTree:Array<Array<Object>>, tree:Array<Array<Object>>):Array<Array<Object>>
	{
		var newTree:Array<Array<Object>> = [];
		var j = 0;
		while (tree[j] != null && Std.isOfType(tree[j][0], String)
		&& cast(tree[j][0], String).substring(0, 1) == "%"
		&& cast(tree[j][0], String) != "%noop%")
		{
			// prepend "special stuff" that happens before chats -- such as putting on clothes, characters entering
			newTree.push(tree[j]);
			j++;
		}
		for (i in 0...Std.int(Math.min(9999, beforeTree.length)))
		{
			var item:Array<Object> = beforeTree[i];
			// prepend normal dialog
			if (item != null)
			{
				for (i in 0...item.length)
				{
					if (Std.isOfType(item[i], Int))
					{
						item[i] = cast(item[i], Int) + j;
					}
				}
				newTree[i + j] = beforeTree[i];
			}
		}

		for (i in 1...Std.int(Math.min(9999, beforeTree.length + 1)))
		{
			// add prepended dialog links. prepended dialog links to [1000], which is where appended dialog starts
			if (beforeTree[i] == null && beforeTree[i - 1] != null)
			{
				newTree[i + j] = [1000];
			}
		}

		for (i in 10000...beforeTree.length)
		{
			// add prepended "skip" stuff.
			if (beforeTree[i] != null)
			{
				newTree[i] = beforeTree[i];
			}
		}

		for (i in j...Std.int(Math.min(8999, tree.length)))
		{
			// add normal dialog
			var item:Array<Object> = tree[i];
			if (item != null)
			{
				for (i in 0...item.length)
				{
					if (Std.isOfType(item[i], Int))
					{
						item[i] = cast(item[i], Int) + (1000 - j);
					}
				}
				newTree[i + 1000 - j] = tree[i];
			}
		}

		var skipIndex:Int = 10000;
		while (newTree[skipIndex] != null)
		{
			skipIndex++;
		}
		for (i in 10000...tree.length)
		{
			// add normal "skip" stuff
			if (tree[i] != null)
			{
				newTree[skipIndex++] = tree[i];
			}
		}
		return newTree;
	}

	/**
	 * Locates a dialog line in a dialog array. This does an exact string
	 * match, the entire dialog line must match the entire input string.
	 *
	 * @param	Tree dialogTree to search
	 * @param	LineText line to search for
	 * @return
	 */
	public static function getIndex(Tree:Array<Array<Object>>, LineText:String):Int
	{
		for (i in 0...Tree.length)
		{
			if (Tree[i] != null && Tree[i][0] == LineText)
			{
				return i;
			}
		}
		return -1;
	}

	/**
	 * Jumps to a specific dialog line in a dialog array. This does an exact
	 * string match, the entire dialog line must match the entire input string.
	 *
	 * @param	LineText line text to jump to
	 * @param	offset after jumping, how many lines to adjust by. Can be a
	 *       	positive or negative integer
	 */
	public function jumpTo(LineText:String, ?offset:Int = 0):Void
	{
		var index:Int = getIndex(_tree, LineText);
		if (index == -1)
		{
			return;
		}
		_currentLine = index + offset;
	}

	/**
	 * Returns true if the tree is currently showing dialog to the player.
	 *
	 * @param	tree tree to inspect; can be null
	 * @return true if the tree is showing dialog to the player
	 */
	public static function isDialogging(tree:DialogTree):Bool
	{
		return tree != null && tree._dialogging;
	}

	/**
	 * Appends a line to the "skip" section of the active dialog; the series of
	 * lines starting at line 10,000
	 *
	 * @param	line line to append
	 */
	public function appendSkipToActiveDialog(line:String)
	{
		appendSkip(_tree, line);
	}

	/**
	 * Appends a line to the "skip" section of the specified dialog tree; the
	 * series of lines starting at line 10,000
	 *
	 * @param	tree tree to append to
	 * @param	line line to append
	 */
	public static function appendSkip(tree:Array<Array<Object>>, line:String)
	{
		var skipIndex:Int = 10000;
		while (tree[skipIndex] != null)
		{
			skipIndex++;
		}
		tree[skipIndex] = [line];
	}
}