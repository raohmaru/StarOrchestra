package jp.raohmaru.game.starorchestra.controller
{
import flash.events.Event;
import flash.utils.getTimer;

import jp.raohmaru.game.starorchestra.core.GameCore;
import jp.raohmaru.game.starorchestra.core.GameObject;
import jp.raohmaru.game.starorchestra.events.*;

public final class TimeMan extends GameObject
{
	private var _dur :int,
				_time :int,
				_start :int,
				_e :TimeEvent;
				
	public function get duration() :int
	{
		return _dur;
	}
				
	public function get time() :int
	{
		return _dur - _time;
	}
	
	public function get timeLeft() :int
	{
		return _time;
	}
				
				
	public function TimeMan(core:GameCore)
	{
		super(core);
		
		init();
	}
	
	private function init() :void
	{
		_e = new TimeEvent(TimeEvent.TIMER, 0);
		_core.event.addEventListener(DrawEvent.DRAW_FAIL, error);
	}
	
	public function start() :void
	{
		if(_dur > 0)
		{
			_start = getTimer();
			if(!_core.canvas.hasEventListener(Event.ENTER_FRAME))
				_core.canvas.addEventListener(Event.ENTER_FRAME, oef);
		}
	}
	
	public function stop() :void
	{
		_core.canvas.removeEventListener(Event.ENTER_FRAME, oef);
	}
	
	public function reset() :void
	{
		_dur = _core.levels.currentLevel().currentMap().time;
	}
	
	private function error(e :DrawEvent) :void
	{
		_dur -= _core.levels.currentLevel().currentMap().error;
	}
	
	private function oef(e :Event):void
	{
		_time = _dur - (getTimer() - _start);
		if(_time < 0)
		{
			_time = 0;
			_core.event.gameEvent(GameEvent.MAP_ERROR);
			
		}
		_e.timeLeft = _time;
		_core.event.timeEvent(_e);
	}
}
}