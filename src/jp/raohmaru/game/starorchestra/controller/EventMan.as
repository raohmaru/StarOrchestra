package jp.raohmaru.game.starorchestra.controller
{
import flash.events.EventDispatcher;
import flash.geom.Point;

import jp.raohmaru.game.starorchestra.events.*;

public final class EventMan extends EventDispatcher
{	
	public function EventMan()
	{
	}
	
	public function drawEvent(type :String, id :int) :void
	{
		dispatchEvent( new DrawEvent(type, id) );
	}
	
	public function gameEvent(type :String) :void
	{
		dispatchEvent( new GameEvent(type) );
	}
	
	public function timeEvent(e :TimeEvent) :void
	{
		dispatchEvent( e );
	}
	
	public function userEvent(type :String) :void
	{
		dispatchEvent( new UserEvent(type) );
	}
}
}