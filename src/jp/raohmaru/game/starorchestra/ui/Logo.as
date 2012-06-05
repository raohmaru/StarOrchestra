package jp.raohmaru.game.starorchestra.ui
{
import flash.display.MovieClip;
import flash.events.Event;
import flash.filters.GlowFilter;

import jp.raohmaru.events.Callback;
import jp.raohmaru.game.starorchestra.core.*;
import jp.raohmaru.game.starorchestra.core.libs.*;
import jp.raohmaru.game.starorchestra.model.Options;
import jp.raohmaru.motion.Paprika;
import jp.raohmaru.motion.easing.Quad;

public final class Logo extends GameSprite
{
	private var _sym :MovieClip;
	
	public function Logo(core :GameCore)
	{
		super(core);
		init();
	}
	
	private function init() :void
	{
		var gfilter :GlowFilter = Filters.GLOW_FILTER.clone() as GlowFilter;
			gfilter.alpha = .5;
		
		_sym = new Symbols.LOGO() as MovieClip;
		_sym.x = Options.STAGE_WIDTH / 2;
		_sym.y = 265;
		_sym.filters = [gfilter];
		_sym.stop();
		
		_view.addChild(_sym);
	}
	
	public function add() :void
	{
		if(_view.parent == null)
			_core.canvas.addChild(_view);
	}
	
	public function remove() :void
	{
		if(_view.parent)
		{
			Paprika.add( _sym, .2, {alpha:0, scale:.4}, Quad.easeIn, 0, Callback.simple( _core.canvas.removeChild, _view ) );
		}
	}
	
	public function play() :void
	{
		_sym.gotoAndPlay(1);
		_sym.addEventListener(Event.ENTER_FRAME, oef);
	}
	
	public function minimize() :void
	{
		Paprika.add(_sym, .3, {y:117, scale:.6, alpha:1}, Quad.easeInOut);
	}
	
	public function maximize() :void
	{
		Paprika.add(_sym, .4, {y:265, scale:1}, Quad.easeInOut, .1);
	}
	
	protected function oef(e :Event):void
	{
		if(_sym.currentFrame == _sym.totalFrames)
		{
			_sym.stop();
			_sym.removeEventListener(Event.ENTER_FRAME, oef);
		}
	}
	
}
}