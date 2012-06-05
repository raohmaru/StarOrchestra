package jp.raohmaru.game.starorchestra.events 
{
import flash.events.Event;

public final class UserEvent extends Event 
{
	public static const UPDATE :String = "uptdate";
	
	public function UserEvent(type :String)
	{		
		super(type, bubbles, cancelable);
	}
	
	override public function toString() :String 
	{
		return formatToString("UserEvent", "type", "bubbles", "cancelable");
	}
	
	override public function clone() :Event
	{
		return new UserEvent(type);
	}
}
}