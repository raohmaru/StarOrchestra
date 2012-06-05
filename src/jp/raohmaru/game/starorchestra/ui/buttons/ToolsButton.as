package jp.raohmaru.game.starorchestra.ui.buttons
{
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import jp.raohmaru.events.Callback;
import jp.raohmaru.game.starorchestra.controller.SoundMan;
import jp.raohmaru.game.starorchestra.core.*;
import jp.raohmaru.game.starorchestra.core.libs.Symbols;
import jp.raohmaru.game.starorchestra.enums.Layers;
import jp.raohmaru.game.starorchestra.enums.Sounds;
import jp.raohmaru.game.starorchestra.model.Options;
import jp.raohmaru.game.starorchestra.utils.StarUtil;
import jp.raohmaru.motion.Paprika;
import jp.raohmaru.motion.easing.Quad;

public final class ToolsButton extends GameSprite
{
	private var _stats :Sprite,
				_inited :Boolean;
	
	public function ToolsButton(core:GameCore)
	{
		super(core);
	}
	
	public function add() :void
	{
		if(!_inited) init();
		
		if(_view.parent == null)
		{
			_core.canvas.addChild(_view);
			Paprika.add(_view, .2, {x:0, y:0}, Quad.easeOut, .3);
		}
	}
	
	public function remove() :void
	{
		if(_view.parent)
		{
			Paprika.add(_view, .2, {x:40, y:40}, Quad.easeIn, 0, Callback.simple( _core.canvas.removeChild, _view ));
		}
	}
	
	
	
	private function init() :void
	{
		_inited = true;
		
		_view.x = 40;
		_view.y = 40;
		
		var border :Sprite = StarUtil.drawRoundRect(80, 80, 2, 0xFFFFFF);
			border.x = Options.STAGE_WIDTH;
			border.y = Options.STAGE_HEIGHT;
		_view.addChild(border);
		
		// Symbolos de tiempo restante y los puntos (phis)
		var sym :Sprite = new Symbols.TOOLS();		
			sym.x = Options.STAGE_WIDTH - 18;
			sym.y = Options.STAGE_HEIGHT - 19;
			_view.addChild(sym);
		
		_view.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
		_view.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
		_view.addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
	}
	
	private function mouseHandler(e :MouseEvent):void
	{		
		if(e.type == MouseEvent.MOUSE_DOWN)
		{
			_core.layers.open(Layers.TOOLS);
			Paprika.add(_view, .1, {alpha:.4});
			SoundMan.self.play(Sounds.BUTTON_CLICK5);
		}
		else
		{			
			if(_view.alpha < 1)
				Paprika.add(_view, .1, {alpha:1});
		}
	}	
}
}