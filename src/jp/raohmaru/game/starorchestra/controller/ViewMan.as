package jp.raohmaru.game.starorchestra.controller
{
import flash.display.Sprite;

import jp.raohmaru.game.starorchestra.StarOrchestra;
import jp.raohmaru.game.starorchestra.core.GameCore;
import jp.raohmaru.game.starorchestra.core.GameObject;
import jp.raohmaru.game.starorchestra.model.Options;
import jp.raohmaru.game.starorchestra.view.*;
import jp.raohmaru.motion.Paprika;

public final class ViewMan extends GameObject
{
	private var _starboard :StarBoard,
				_draw_layer :DrawLayer,
				_debug_layer :DebugLayer;
	
	public function get drawLayer():DrawLayer 
	{
		return _draw_layer;
	}
	
	
	
	public function ViewMan(core :GameCore)
	{
		super(core);
		init();
	}
	
	private function init() :void
	{		
		_starboard = new StarBoard(_core);
		_core.canvas.addChild(_starboard.view);
		
		_draw_layer = new DrawLayer(_core);
		_core.canvas.addChild(_draw_layer.view);
		
		_debug_layer = new DebugLayer(_core);
		_core.canvas.addChild(_debug_layer.view);
	}
	
	public function drawLevel() :void
	{
		if(Options.CREATE_MODE)
			_debug_layer.start();
		
		_starboard.view.alpha = 1;
		_starboard.draw();
		
		_draw_layer.view.alpha = 1;
		_draw_layer.prepare();
	}
	
	public function start() :void
	{
		_starboard.start();
		_draw_layer.clearAndStart();
	}
	
	public function stop() :void
	{
		_starboard.stop();
		_draw_layer.stop();
		
		if(Options.CREATE_MODE)
			_debug_layer.stop();
	}
	
	public function clear() :void
	{
		stop();
		
		Paprika.add(_starboard.view, .2, {alpha:0}, null, 0, _starboard.clear);
		Paprika.add(_draw_layer.view, .2, {alpha:0}, null, 0, _draw_layer.clear);
	}
}
}