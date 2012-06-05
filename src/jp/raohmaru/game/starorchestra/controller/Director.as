package jp.raohmaru.game.starorchestra.controller
{
import flash.events.Event;
import flash.geom.Point;

import jp.raohmaru.game.starorchestra.core.*;
import jp.raohmaru.game.starorchestra.enums.Sounds;
import jp.raohmaru.game.starorchestra.events.*;
import jp.raohmaru.game.starorchestra.model.*;
import jp.raohmaru.motion.Paprika;

public final class Director extends GameObject
{
	private var _seq :Vector.<Note>,
				_points :Vector.<Point>,
				_sound :String,
				_idx :int,
				_last_e :String;	
	
	public function Director(core :GameCore)
	{
		super(core);
	}

	public function start() :void
	{
		var map :Map = _core.levels.currentLevel().currentMap();
		
		_idx = 0;
		_seq = map.sequence;
		_points = map.stars;
		_sound = _core.levels.currentLevel().sound;
		
		var	len :uint = _seq.length,
			i :int = -1,
			note :Note,
			d :Number = 0;
		
		if(!Options.CREATE_MODE)
		{
			while(++i < len)
			{
				note = _seq[i];
				if(i == 0)
				{
					_core.view.drawLayer.moveTo( note.id );
					dispatchAndSound(Sounds.DRAW_BEGIN_SUCCESS, note.id);
					d += note.tempo/1000;
				}
				else
				{
					if(note.follow)
						Paprika.wait(this, d, 0, _core.view.drawLayer.lineTo, [note.id, note.tempo/1000]);
					else
						Paprika.wait(this, d, 0, _core.view.drawLayer.moveTo, [note.id]);
					
					d += note.tempo/1000;
					Paprika.wait(this, d, 0, dispatchAndSound, [(i+1<len) ? Sounds.DRAW_SUCCESS : Sounds.DRAW_END_SUCCESS, note.id, note.id]);
				}				
			}
		}
		
		Paprika.wait(this, d+.2, 0, watch);
	}
	
	public function stop() :void
	{
		_seq = null;
		_points = null;
		_last_e = null;
		
		_core.event.removeEventListener(DrawEvent.DRAW_BEGIN, drawHandler);
		_core.event.removeEventListener(DrawEvent.DRAW_END, drawHandler);
		_core.event.removeEventListener(DrawEvent.DRAW_LINE, drawHandler);
		
		Paprika.remove(this);
	}
	
	
	
	private function watch() :void
	{
		_core.view.start();
		if(!Options.CREATE_MODE)
			Paprika.wait(this, _core.levels.currentLevel().currentMap().sequence.length*.05+.2, 0,
						 _core.timer.start);
		
		_core.event.addEventListener(DrawEvent.DRAW_BEGIN, drawHandler);
		_core.event.addEventListener(DrawEvent.DRAW_END, drawHandler);
		_core.event.addEventListener(DrawEvent.DRAW_LINE, drawHandler);
	}
	
	private function dispatchAndSound(type :String, id :int, level :int=-1) :void
	{
		_core.event.drawEvent(type, id);
		if(type == Sounds.DRAW_SUCCESS || type == Sounds.DRAW_END_SUCCESS)
			type = _sound;
		_core.sound.play(type, level);
	}
	
	private function drawHandler(e :DrawEvent):void
	{
		if(e.type == DrawEvent.DRAW_END)
		{
			if( !Options.CREATE_MODE &&
				( _last_e == null || _last_e == DrawEvent.DRAW_LINE) && _seq[_idx].follow && _idx > 0)
					_idx--;
		}
		else
		{
			var draw_begin :Boolean = (e.type == DrawEvent.DRAW_BEGIN);
			
			if( Options.CREATE_MODE || (e.id == _seq[_idx].id && (draw_begin || !draw_begin && _seq[_idx].follow)) )
			{
				if(!Options.CREATE_MODE)
					_idx++
				
				var complete :Boolean = (!draw_begin && _idx == _seq.length && !Options.CREATE_MODE);
					
				if(draw_begin && _idx == 1)
				{
					dispatchAndSound(Sounds.DRAW_BEGIN_SUCCESS, e.id);
				}
				else
				{
					dispatchAndSound( (complete) ? Sounds.DRAW_END_SUCCESS : Sounds.DRAW_SUCCESS, e.id, e.id);
				}
				
				if(complete)
					_core.event.gameEvent(GameEvent.MAP_COMPLETE);
				
				_last_e = null;
			}
			else if(!Options.CREATE_MODE)
			{
				dispatchAndSound(Sounds.DRAW_FAIL, e.id);
				_last_e = e.type;
			}
		}
	}
}
}