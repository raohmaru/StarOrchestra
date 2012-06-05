package jp.raohmaru.game.starorchestra.ui.buttons
{
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.*;

import jp.raohmaru.game.starorchestra.controller.SoundMan;
import jp.raohmaru.game.starorchestra.core.libs.Filters;
import jp.raohmaru.game.starorchestra.enums.Sounds;
import jp.raohmaru.game.starorchestra.utils.StarUtil;
import jp.raohmaru.motion.Paprika;
import jp.raohmaru.motion.easing.Quad;

public final class GlowButton extends Sprite
{
	private var _label :TextField;
	public static const WIDTH :Number = 256.0;
	public static const HEIGHT :Number = 52.0;
	
	public function set label(value :String) :void
	{
		_label.text = value;
	}
	
	public function get label() :String
	{
		return _label.text;
	}
	
	
	public function GlowButton(label :String)
	{
		init(label);
	}
	
	private function init(label :String) :void
	{		
		_label = StarUtil.createTextField(label, 28, 0xFFFFFF, WIDTH, TextFieldAutoSize.CENTER);
		_label.x = -_label.textWidth/2;
		_label.y = -_label.height/2 - 3;
			
		addChild(_label);
		
		var border :Sprite = StarUtil.drawRoundRect(WIDTH, HEIGHT);		
		addChild(border);
		
		mouseChildren = false;
		addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
		addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
		addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
		
		alpha = 0;
		visible = false;
	}
	
	public function show(delay :Number=0.0) :void
	{
		scaleX = scaleY = .7;
		Paprika.add(this, .3, {autoAlpha:1, scale:1}, Quad.easeOut, delay);
	}
	
	public function hide(delay :Number=0.0) :void
	{
		Paprika.add(this, .3, {autoAlpha:0, scale:.7}, Quad.easeOut, delay);
	}
	
	private function mouseHandler(e :MouseEvent):void
	{		
		if(e.type == MouseEvent.MOUSE_DOWN)
		{
			Paprika.add(this, .1, {alpha:.4});
			SoundMan.self.play(Sounds.BUTTON_CLICK4);
		}
		else
		{
			if(alpha < 1)
				Paprika.add(this, .1, {alpha:1});
		}
	}
}
}