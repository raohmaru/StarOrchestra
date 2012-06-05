package jp.raohmaru.game.starorchestra.controller
{
import flash.display.Sprite;
import flash.utils.Dictionary;

import jp.raohmaru.game.starorchestra.core.GameCore;
import jp.raohmaru.game.starorchestra.core.GameObject;
import jp.raohmaru.game.starorchestra.enums.Layers;
import jp.raohmaru.game.starorchestra.events.LayerEvent;
import jp.raohmaru.game.starorchestra.model.Options;
import jp.raohmaru.game.starorchestra.ui.layers.*;
import jp.raohmaru.motion.Paprika;

public final class LayerMan extends GameObject
{
	private var _inited :Boolean,
				_layers :Dictionary,
				_blockers :Vector.<Sprite>;
	
	public function LayerMan(core :GameCore)
	{
		super(core);
	}
	
	public function open(id :uint) :AbstractLayer
	{
		if(!_inited) init();
		
		
		// Obtiene una capa bloqueadora libre
		if(_blockers.length > 0)
		{
			var blocker :Sprite = _blockers.pop();
		}
		else
		{
			blocker = drawBlocker();
		}
		blocker.alpha = 0;
		
		
		// Obtiene la ventana solicitada
		if(_layers[id])
		{
			var layer :AbstractLayer = _layers[id][0];
		}
		else
		{
			if(id == Layers.TOOLS)
				layer = new ToolsLayer(_core);
			
			else if(id == Layers.MESSAGE)
				layer = new MessageLayer(_core);
				
			else if(id == Layers.OPTIONS)
				layer = new OptionsLayer(_core);
			
			_layers[id] = [layer];
		}
		_layers[id][1] = blocker;
		
		
		
		_core.canvas.addChild(blocker);
		_core.canvas.addChild(layer.view);
		
		layer.show();
		Paprika.add(blocker, .2, {alpha:1});
		
		dispatchEvent( new LayerEvent(LayerEvent.LAYER_OPEN, id) );
		
		return layer;
	}
	
	public function close(id :int=-1) :void
	{
		if(id > -1)
		{
			AbstractLayer(_layers[id][0]).hide();
			Paprika.add(_layers[id][1], .2, {alpha:0}, null, 0, onRemove, [id]);
		}
		else
		{
			for each (var arr :Array in _layers)
			{
				if(arr.length > 1)
					close( AbstractLayer(arr[0]).id );
			}
		}
		
		dispatchEvent( new LayerEvent(LayerEvent.LAYER_CLOSE, id) );
	}
	
	private function init() :void
	{
		_inited = true;
		
		_layers = new Dictionary();
		_blockers = new Vector.<Sprite>;
	}
	
	private function drawBlocker() :Sprite
	{
		var shape :Sprite = new Sprite();
			shape.graphics.beginFill(0, 0.0);
			shape.graphics.drawRect(0.0, 0.0, Options.STAGE_WIDTH, Options.STAGE_HEIGHT);
			shape.graphics.endFill();
		
		return shape;
	}
	
	private function onRemove(id :uint) :void
	{
		_core.canvas.removeChild( AbstractLayer(_layers[id][0]).view );
		_blockers.push( _core.canvas.removeChild(_layers[id][1]) );
		_layers[id].length = 1;
	}
}
}