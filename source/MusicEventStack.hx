package;
import flixel.FlxG;

/**
 * This class provides a way to add events which trigger at key points in a
 * song.
 *
 * This is useful for syncing up slideshows and graphics during the credits
 * sequence.
 */
class MusicEventStack extends EventStack
{

	public function new()
	{
		super();
	}

	override public function reset():Void
	{
		super.reset();
		_time = FlxG.sound.music == null ? -1 : FlxG.sound.music.time / 1000;
	}

	override public function update(elapsed:Float):Void
	{
		if (!_alive)
		{
			return;
		}
		_time = FlxG.sound.music == null ? -1 : FlxG.sound.music.time / 1000;
		while (_eventIndex < _events.length && _events[_eventIndex].time <= _time)
		{
			if (_events[_eventIndex].callback != null)
			{
				_events[_eventIndex].callback(_events[_eventIndex].args);
			}
			_eventIndex++;
		}
		if (_eventIndex >= _events.length)
		{
			_alive = false;
		}
	}
}