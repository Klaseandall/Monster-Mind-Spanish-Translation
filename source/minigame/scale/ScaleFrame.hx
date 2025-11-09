package minigame.scale;
import minigame.scale.ScaleAgent;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import openfl.display.BitmapData;

/**
 * A Pokemon portrait which appears on the side during the scale minigame
 */
class ScaleFrame extends RoundedRectangle
{
	private var _target:FlxSprite;
	private var _targetRect:FlxRect = FlxRect.get(0, 0, 0, 0);
	private var _tmpRect:FlxRect;
	private var _agent:ScaleAgent;
	private var _done:Bool = false;

	public function new(target:FlxSprite, agent:ScaleAgent)
	{
		super();
		this._target = target;
		this._agent = agent;
		// needs to be unique because of the 1st/2nd/3rd stuff
		this._unique = true;
		maybeRefreshRect();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (!_target.exists)
		{
			kill();
			return;
		}
		maybeRefreshRect();
		visible = _target.visible;
	}

	/**
	 * Redraws the frame's picture if necessary (if the Pokemon recently solved
	 * the puzzle)
	 */
	function maybeRefreshRect()
	{
		_tmpRect = _target.getHitbox(_tmpRect);
		if (!_tmpRect.equals(_targetRect) || _done != _agent.isDone())
		{
			var borderColor:FlxColor = _agent.isDone() ? 0xFF00FF18 : ItemsMenuState.DARK_BLUE;
			var centerColor:FlxColor = _agent.isDone() ? 0x443FA4BF : FlxColor.TRANSPARENT;
			relocate(Std.int(_tmpRect.x - 1), Std.int(_tmpRect.y - 1), Std.int(_tmpRect.width + 2), Std.int(_tmpRect.height + 2), borderColor, centerColor, 2);
			_targetRect.copyFrom(_tmpRect);
			_done = _agent.isDone();

			if (_agent._finishedOrder < ScaleAgent.UNFINISHED)
			{
				var first:FlxSprite = new FlxSprite(0, 0);
				first.loadGraphic(AssetPaths.scale_1st__png, true, 73, 71);
				first.animation.frameIndex = Std.int(Math.min(2, _agent._finishedOrder - 1));
				first.scale.copyFrom(_target.scale);
				first.updateHitbox();
				stamp(first, -Std.int(first.offset.x), -Std.int(first.offset.y));
			}
		}
	}
}