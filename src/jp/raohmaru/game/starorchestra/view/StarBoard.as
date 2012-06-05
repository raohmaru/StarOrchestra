package jp.raohmaru.game.starorchestra.view
{
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;

import jp.raohmaru.game.starorchestra.controller.LevelMan;
import jp.raohmaru.game.starorchestra.core.GameCore;
import jp.raohmaru.game.starorchestra.core.GameSprite;
import jp.raohmaru.game.starorchestra.events.DrawEvent;
import jp.raohmaru.game.starorchestra.model.Level;

public final class StarBoard extends GameSprite
{
	private var _stars :Vector.<Star>;
	public static const DELAY :Number = .05;
	
	public function StarBoard(core :GameCore)
	{
		super(core);
		init();
	}
	
	private function init() :void
	{
		_stars = new Vector.<Star>;
		stop();
	}
	
	public function draw() :void
	{
		var star :Star,
			sym :String = _core.levels.currentLevel().star,
			color :uint = _core.levels.currentLevel().color,
			arr :Vector.<Point> = _core.levels.currentLevel().currentMap().stars,
			len :uint = arr.length;
		
		for(var i:int=0; i<len; i++)
		{
			if(i < _stars.length)
			{
				star = _stars[i];
				star.update( i, arr[i], sym, color );
			}
			else
			{
				star = new Star( _core, i, arr[i], sym, color );
				_view.addChild(star.view);
				_stars.push(star);
			}
			
			star.show(i*DELAY);
		}
		
		if(len < _stars.length)
		{
			for(i=len; i<_stars.length; i++) 
			{
				Star(_stars[i]).hide();
			}
		}
		
		_core.event.addEventListener(DrawEvent.DRAW_BEGIN_SUCCESS, drawHandler);
		_core.event.addEventListener(DrawEvent.DRAW_SUCCESS, drawHandler);
		_core.event.addEventListener(DrawEvent.DRAW_END_SUCCESS, drawHandler);
		_core.event.addEventListener(DrawEvent.DRAW_FAIL, drawHandler);
	}
	
	public function start() :void
	{
		_view.mouseChildren = true;
		
		for(var i :int=0; i<_stars.length; i++)
			Star(_stars[i]).reset();
	}
	
	public function stop() :void
	{
		_view.mouseChildren = false;
	}
	
	public function clear() :void
	{
		for(var i:int=0; i<_stars.length; i++) 
			Star(_stars[i]).view.visible = false;
	}
	
	protected function drawHandler(e :DrawEvent):void
	{
		var star :Star = Star(_stars[e.id]);
		
		if(e.type == DrawEvent.DRAW_FAIL)
		{
			star.fail();
		}
		else
		{
			star.highlight( e.type );
		}
	}	
}
}