package jp.raohmaru.game.starorchestra.view
{
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

import jp.raohmaru.game.starorchestra.controller.EventMan;
import jp.raohmaru.game.starorchestra.core.*;
import jp.raohmaru.game.starorchestra.core.libs.*;
import jp.raohmaru.game.starorchestra.events.DrawEvent;
import jp.raohmaru.motion.Paprika;
import jp.raohmaru.motion.PaprikaSpice;
import jp.raohmaru.motion.easing.Quad;
import jp.raohmaru.utils.MathUtil;

public final class Star extends GameSprite
{
	private var _id :int,
				_sym :Sprite,
				_sym_ref :String,
				_color :uint,
				_highlighted :Boolean,
				_dx :Number = -1,
				_dy :Number = -1;
	
	public function Star(core :GameCore, id :int, point :Point, symbol :String, color :uint)
	{
		super(core);
		init();
		update(id, point, symbol, color);
	}
	
	private function init() :void
	{		
		_view.alpha = 0;
		_view.visible = false;
		_view.scaleX = _view.scaleY = .5;
		_view.filters = [Filters.GLOW_FILTER];
		_view.mouseChildren = false;
		_view.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
	}
	
	public function update(id :int, point :Point, symbol :String, color :uint) :void
	{
		_id = id;
		_color = color;
		
		if(_dx == -1)
		{
			_view.x = point.x;
			_view.y = point.y;
		}
		
		_dx = point.x;
		_dy = point.y;
		
		if(symbol != _sym_ref)
		{
			_sym_ref = symbol;
			if(_sym != null)
				Paprika.add(_sym, .1, {scale:0}, Quad.easeIn, 0, changeSymbol);
			else
				changeSymbol();
		}
		
		reset();		
	}
	
	public function show(delay :Number=0.0) :void
	{
		_view.rotation = 0;
		
		var params :Object = { rotation:360, autoAlpha:1 },
			ease :Function = Quad.easeOut,
			t :Number = .4;
		if(_view.visible)
		{
			params.x = _dx;
			params.y = _dy;
			ease = Quad.easeInOut;
		}
		else
		{
			_view.x = _dx;
			_view.y = _dy;
			params.scale = 1;
		}
		
		Paprika.add(_view, t, params, Quad.easeOut, delay);
	}
	
	public function hide() :void
	{		
		Paprika.add(_view, .3, {autoAlpha:0, scale:.5});
	}
	
	public function highlight(type :String) :void
	{
		_highlighted = true;
		
		Paprika.add(_view, .2, {color:_color});
		
		if(type == DrawEvent.DRAW_BEGIN_SUCCESS)
			Paprika.add(_view, .6, {rotation:360}, Quad.easeOut);
		
		else if(type == DrawEvent.DRAW_END_SUCCESS)
		{
			Paprika.add(_view, .4, {rotation:-360, scale:1.5}, Quad.easeOut);
			Paprika.add(_view, .4, {scale:1}, Quad.easeInOut, .4);
		}		
		else
		{
			var PI :Number = Math.PI,
				cos :Function = Math.cos;
			var spice :PaprikaSpice = Paprika.add(_view, 1, {}, Quad.easeOut);
				spice.onUpdate = function() :void
				{
					_view.scaleX = cos( (2-spice.progress*2) * PI );
				}
		}
	}
	
	public function fail() :void
	{
		Paprika.add(_view, .2, {color:0xFF0000});
		Paprika.add(_view, .2, {color:(_highlighted ? _color : null)}, null, .4);
		
		_view.scaleX = 0;
		_view.rotation = 72.0 * MathUtil.randomInt(2,4) * MathUtil.randomSign();
		Paprika.add(_view, .6, {rotation:0, scaleX:1.0}, Quad.easeOut);
	}
	
	public function reset() :void
	{
		_view.rotation = 0;
		Paprika.add(_view, .3, {color:null});
		_highlighted = false;
	}
	
	
	private function changeSymbol() :void
	{
		var exist_sym :Boolean = (_sym != null);
		
		if(exist_sym)
			_view.removeChild(_sym);
		_sym = new Symbols[_sym_ref]() as Sprite;
		_view.addChild(_sym);
		
		if(exist_sym)
		{
			_sym.scaleX = 0;		
			Paprika.add(_sym, .1, {scale:1}, Quad.easeOut);
		}
	}
	
	private function mouseHandler(e :MouseEvent):void
	{
		if(e.type == MouseEvent.MOUSE_DOWN)
		{
			_core.event.drawEvent(DrawEvent.DRAW_BEGIN, _id);
			_view.stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
		}
		else
		{
			_core.event.drawEvent(DrawEvent.DRAW_END, _id);
			_view.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
		}
	}
}
}