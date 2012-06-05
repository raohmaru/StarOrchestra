package jp.raohmaru.game.starorchestra.events 
{
import flash.events.Event;

import jp.raohmaru.game.starorchestra.enums.Sounds;

public final class LayerEvent extends Event 
{
	public static const LAYER_OPEN	:String = "layerOpen";
	public static const LAYER_CLOSE	:String = "layerClose";
	
	
	private var _id :int;
	
	public function get id() :int
	{
		return _id;
	}
	
	
	public function LayerEvent(type :String, id :int)
	{
		_id = id;
		
		super(type, bubbles, cancelable);
	}
	
	override public function toString() :String 
	{
		return formatToString("LayerEvent", "type", "id", "bubbles", "cancelable");
	}

	override public function clone() :Event
	{
		return new LayerEvent(type, _id);
	}
}
}
