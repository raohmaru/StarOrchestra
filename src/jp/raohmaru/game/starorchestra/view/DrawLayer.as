package jp.raohmaru.game.starorchestra.view
{
import flash.display.*;
import flash.events.Event;
import flash.geom.Point;

import jp.raohmaru.game.starorchestra.controller.*;
import jp.raohmaru.game.starorchestra.core.GameCore;
import jp.raohmaru.game.starorchestra.core.GameSprite;
import jp.raohmaru.game.starorchestra.core.libs.Filters;
import jp.raohmaru.game.starorchestra.events.DrawEvent;
import jp.raohmaru.game.starorchestra.model.Options;
import jp.raohmaru.motion.Paprika;
import jp.raohmaru.motion.easing.Quad;

public final class DrawLayer extends GameSprite
{
	private var _origin :Point,
				_shape :Shape,
				_last_shape :Shape,
				_gr :Graphics,
				_points :Vector.<Point>,
				_color :uint;
	
	
	public function DrawLayer(core :GameCore)
	{
		super(core);
		init();
	}
	
	private function init() :void
	{
		_view.mouseChildren = false;
		_view.mouseEnabled = false;
	}
	
	private function addShape(point :Point) :void
	{
		if(_view.parent)
		{
			_origin = point;
			_shape = new Shape();
			_shape.x = point.x;
			_shape.y = point.y;
			_shape.filters = [Filters.GLOW_FILTER];
			_gr = _shape.graphics;
			_view.addChild(_shape);
		}
	}
	
	private function setLineStyle() :void
	{
		_gr.lineStyle(Options.BEAM_SIZE, _color);
	}
	
	private function removeShape(shape :Shape, fail :Boolean=false, time :Number=.3, delay :Number=0.0) :void
	{
		if(shape)
		{
			if(fail)
				Paprika.add(shape, 0, {color:0xFF0000});
			Paprika.add(shape, time, {scale:.4, alpha:0}, Quad.easeIn, delay, removeChildShape, [shape]);
		}
	}
	
	private function removeChildShape(shape :Shape) :void
	{
		if(shape.parent)
			_view.removeChild(shape);
	}
	
	
	
	public function prepare() :void
	{
		var len :int = _view.numChildren;
		for(var i :int=0; i<len; i++)
			removeShape( Shape(_view.getChildAt(i)), false, .2 );
		_points = _core.levels.currentLevel().currentMap().stars;
		
		_color = _core.levels.currentLevel().color;
	}
	
	public function moveTo(id :uint) :void
	{
		if(_points != null)
			_origin = _points[id];
	}
	
	public function lineTo(id :uint, time :Number) :void
	{
		addShape( _origin );
		setLineStyle();
		
		var p :Point = _points[id];
		_gr.lineTo(p.x-_origin.x, p.y-_origin.y);
		_shape.scaleX = _shape.scaleY = 0;
		Paprika.add(_shape, time, {scale:1});
		
		_origin = p;
	}
	
	public function clearAndStart() :void
	{
		var len :int = _view.numChildren;
		for(var i :int=0; i<len; i++)
			removeShape( Shape(_view.getChildAt(i)), false, .2, .05*(len-i) );
		
		_core.event.addEventListener(DrawEvent.DRAW_BEGIN, startHandler);
		_core.event.addEventListener(DrawEvent.DRAW_END, endHandler);
		_core.event.addEventListener(DrawEvent.DRAW_FAIL, failHandler);
	}
	
	public function stop() :void
	{
		_core.event.removeEventListener(DrawEvent.DRAW_BEGIN, startHandler);
		_core.event.removeEventListener(DrawEvent.DRAW_END, endHandler);
		_core.event.removeEventListener(DrawEvent.DRAW_FAIL, failHandler);
		
		endHandler(null);
		_points = null;
	}
	
	public function clear() :void
	{
		while(_view.numChildren > 0)
			_view.removeChildAt(0);
	}
	
	
	
	private function startHandler(e :DrawEvent):void
	{	
		addShape(_points[e.id]);
		_last_shape = null;
		
		if(!_view.hasEventListener(Event.ENTER_FRAME))
			_view.addEventListener(Event.ENTER_FRAME, oef);
	}
	
	private function endHandler(e :DrawEvent=null):void
	{
		removeShape(_shape);
		
		_origin = null;
		_shape = null;
		_gr = null;
		_last_shape = null;
		
		_view.removeEventListener(Event.ENTER_FRAME, oef);
	}
	
	private function failHandler(e :DrawEvent=null):void
	{
		removeShape(_last_shape, true);
		
		endHandler();
	}
	
	private function oef(e :Event):void
	{
		_gr.clear();
		setLineStyle();
		
		var i :int = _points.length,
			p :Point, px :int, py :int;
		
		i = _points.length;	
		while(--i > -1)
		{
			p = _points[i];
			
			if(p.equals(_origin)) continue;
			
			px = p.x - _view.mouseX;
			py = p.y - _view.mouseY;
			if(px*px + py*py < Options.SNAP_DTE)
			{
				_gr.lineTo(p.x-_origin.x, p.y-_origin.y);
				_last_shape = _shape;
				addShape(p);
				_core.event.drawEvent(DrawEvent.DRAW_LINE, i);
				return;
			}
		}
		
		_gr.lineTo(_shape.mouseX, _shape.mouseY);
	}
}
}