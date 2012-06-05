package jp.raohmaru.game.starorchestra.events 
{
import flash.events.Event;

public final class TimeEvent extends Event 
{
	public static const TIMER :String = "timer";	
	
	private var _timeLeft :int;
	
	public function get timeLeft() :int
	{
		return _timeLeft;
	}
	
	public function set timeLeft(value :int) :void
	{
		_timeLeft = value;
	}
	
	
	public function TimeEvent(type :String, timeLeft :int)
	{
		_timeLeft = timeLeft;
		
		super(type, bubbles, cancelable);
	}
	
	override public function toString() :String 
	{
		return formatToString("TimeEvent", "type", "timeLeft", "bubbles", "cancelable");
	}

	override public function clone() :Event
	{
		return new TimeEvent(type, _timeLeft);
	}
}
}
