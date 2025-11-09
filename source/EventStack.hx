package;
import flixel.FlxG;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * This class provides a way to schedule events to happen in the future.
 * 
 * It also guarantees events happen in the same order they were scheduled, even
 * if there's some kind of a performance hiccup where they all occur in the
 * same frame.
 */
class EventStack
{
	public var _events:Array<Event> = [];
	private var _eventIndex:Int = 0;
	public var _time:Float = 0;
	public var _alive:Bool = false;
	
	public function new() {
	}

	/**
	 * Remove all events
	 */
	public function reset():Void {
		_events.splice(0, _events.length);
		_time = 0;
		_eventIndex = 0;
		_alive = false;
	}
	
	public function addEvent(event:Event):Void {
		if (event.time < _time) {
			// scheduling events in the past is problematic
			event.time = _time;
		}
		var i:Int = _events.length;
		while (i > 0 && _events[i - 1].time > event.time) {
			i--;
		}
		_events.insert(i, event);
		if (!_alive) {
			_alive = true;
			_eventIndex = i;
		}
	}
	
	public function update(elapsed:Float):Void {
		if (!_alive) {
			return;
		}
		_time += elapsed;
		while (_eventIndex < _events.length && _events[_eventIndex].time <= _time) {
			if (_events[_eventIndex].callback != null) {
				_events[_eventIndex].callback(_events[_eventIndex].args);
			}
			// firing an event can remove an event; make sure it's still necessary to increment
			if (_events[_eventIndex] != null && _events[_eventIndex].time <= _time) {
				_eventIndex++;
			}
		}
		if (_eventIndex >= _events.length) {
			_alive = false;
		}
	}
	
	public static function eventPlaySound(params:Array<Dynamic>):Void {
		var volume:Float = 1.0;
		if (params.length >= 2) {
			volume = params[1];
		}
		SoundStackingFix.play(params[0], volume);
	}
	
	public function isEventScheduled(callback:Dynamic->Void):Bool {
		for (i in _eventIndex..._events.length) {
			if (_events[i].callback == callback) {
				return true;
			}
		}
		return false;
	}
	
	public function removeEvent(callback:Dynamic->Void):Bool {
		var i:Int = _events.length - 1;
		while (i >= 0) {
			if (_events[i].callback == callback) {
				_events.splice(i, 1);
				if (_eventIndex > i) {
					_eventIndex--;
				}
			}
			i--;
		}
		return false;
	}
}

typedef Event = {
	time:Float,
	callback:Dynamic->Void,
	?args:Array<Dynamic>
}