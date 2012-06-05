package jp.raohmaru.game.starorchestra.events 
{
import flash.events.Event;

import jp.raohmaru.game.starorchestra.enums.Sounds;

public final class DrawEvent extends Event 
{
	public static const DRAW_BEGIN			:String = Sounds.DRAW_BEGIN;
	public static const DRAW_END			:String = Sounds.DRAW_END;
	public static const DRAW_LINE			:String = Sounds.DRAW_LINE;
	public static const DRAW_BEGIN_SUCCESS	:String = Sounds.DRAW_BEGIN_SUCCESS;
	public static const DRAW_SUCCESS		:String = Sounds.DRAW_SUCCESS;
	public static const DRAW_END_SUCCESS	:String = Sounds.DRAW_END_SUCCESS;
	public static const DRAW_FAIL			:String = Sounds.DRAW_FAIL;
	
	
	private var _id :int;
	
	public function get id() :int
	{
		return _id;
	}
	
	
	public function DrawEvent(type :String, id :int)
	{
		_id = id;
		
		super(type, bubbles, cancelable);
	}
	
	override public function toString() :String 
	{
		return formatToString("DrawEvent", "type", "id", "bubbles", "cancelable");
	}

	override public function clone() :Event
	{
		return new DrawEvent(type, _id);
	}
}
}
