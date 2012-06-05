package jp.raohmaru.game.starorchestra.ui.screens
{
import flash.display.DisplayObject;
import flash.events.MouseEvent;

import jp.raohmaru.events.Callback;
import jp.raohmaru.game.starorchestra.core.GameCore;
import jp.raohmaru.game.starorchestra.core.GameSprite;
import jp.raohmaru.game.starorchestra.ui.buttons.GlowButton;
import jp.raohmaru.game.starorchestra.utils.StarUtil;
import jp.raohmaru.motion.Paprika;
import jp.raohmaru.motion.easing.Quad;

public class AbsctractScreen extends GameSprite
{
	protected var _inited :Boolean;
	
	public function AbsctractScreen(core:GameCore)
	{
		super(core);
	}
	
	protected function init() :void
	{
		_inited = true;
	}
	
	public function addAndPlay() :void
	{
		if(!_inited) init();
		
		_core.canvas.addChild(_view);
		_view.mouseChildren = true;
		
		var ch :DisplayObject;
		for(var i :int=0; i<_view.numChildren; i++)
		{
			ch = _view.getChildAt(i);
			if(ch is GlowButton)
				GlowButton(ch).show(i*.1);
			else
				Paprika.add(ch, .3, {autoAlpha:1, scale:1}, Quad.easeOut, i*.1);
		}
	}
	
	public function remove() :void
	{
		if(_view.parent)
		{
			_view.mouseChildren = false;
			
			var ch :DisplayObject;
			for(var i :int=0; i<_view.numChildren; i++)
			{
				ch = _view.getChildAt(i);
				if(ch is GlowButton)
					GlowButton(ch).hide(i*.05);
				else
					Paprika.add(ch, .3, {autoAlpha:0, scale:.7}, Quad.easeOut, i*.05);
			}
			
			Paprika.wait( this, i*.05, 0, Callback.simple( _core.canvas.removeChild, _view ) );
		}
	}
	
	protected function createButton(label :String, name :String, x :Number, y :Number, callback :Function) :GlowButton
	{
		return _view.addChild( StarUtil.createButton(label, name, x, y, callback) ) as GlowButton;
	}
}
}