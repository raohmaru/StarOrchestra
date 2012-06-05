package jp.raohmaru.game.starorchestra.ui.layers
{
import flash.events.MouseEvent;
import flash.text.TextField;

import jp.raohmaru.game.starorchestra.core.GameCore;
import jp.raohmaru.game.starorchestra.enums.Awards;
import jp.raohmaru.game.starorchestra.enums.Layers;
import jp.raohmaru.game.starorchestra.enums.Sounds;
import jp.raohmaru.game.starorchestra.events.GameEvent;
import jp.raohmaru.game.starorchestra.model.Options;
import jp.raohmaru.game.starorchestra.ui.buttons.GlowButton;
import jp.raohmaru.game.starorchestra.utils.StarUtil;

import qnx.ui.events.SliderEvent;
import qnx.ui.slider.Slider;

public final class OptionsLayer extends AbstractLayer
{
	private var	_vol :Number = 1,
				_vol_tf :TextField,
				_vol_slider :Slider,
				_size :Number = 6,
				_size_label :TextField,
				_size_tf :TextField,
				_size_slider :Slider;
	
	public function OptionsLayer(core :GameCore)
	{
		super(core, Layers.OPTIONS);
	}
	
	override public function show() :void
	{
		super.show();
		
		var hasBeamSize :Boolean = _core.users.getUser().hasAward(Awards.BEAM_SIZE);
		_size_tf.alpha =
		_size_label.alpha =
		_size_slider.alpha = (hasBeamSize) ? 1 : .3;
		_size_slider.enabled = hasBeamSize;
		
		_vol_tf.text = int(_core.sound.volume*100).toString();
		_vol_slider.value = _core.sound.volume;
		
		_size_tf.text = Options.BEAM_SIZE.toString();
		_size_slider.value = Options.BEAM_SIZE;
	}
	
	override protected function init() :void
	{
		super.init();
		
		title = "options";
		
		// Volumen
		var tf :TextField = StarUtil.createTextField("Sound volume:", 24);
			tf.x = -150;
			tf.y = -30;
		addContent( tf );
		
		_vol_tf = StarUtil.createTextField(int(_vol*100).toString(), 24, 0xFFCC00, -1, "left", "left");
		_vol_tf.x = tf.x + tf.width + 10;
		_vol_tf.y = -30;
		addContent( _vol_tf );
		
		_vol_slider = addSlider(0, _vol, _vol);
		_vol_slider.setPosition(-150, 10);
		addContent( _vol_slider );
		
		// Tamaño línea
		_size_label = StarUtil.createTextField("Beam size:", 24);
		_size_label.x = -150;
		_size_label.y = 40;
		addContent( _size_label );
		
		_size_tf = StarUtil.createTextField(_size.toString(), 24, 0xFFCC00, -1, "left", "left");
		_size_tf.x = _size_label.x + _size_label.width + 10;
		_size_tf.y = 40;
		addContent( _size_tf );
		
		_size_slider = addSlider(1, 10, _size);
		_size_slider.setPosition(-150, 80);
		addContent( _size_slider );
		
		
		
		addContent( createButton( "save",	"save_bot",		200,	actions,	-GlowButton.WIDTH/2-10 ) );	
		addContent( createButton( "cancel",	"cancel_bot",	200,	actions,	GlowButton.WIDTH/2+10 ) );
		
		fit();
	}
	
	private function addSlider(min :Number=0, max :Number=0, value :Number=NaN) :Slider
	{
		var slider :Slider =  new Slider();
			slider.minimum = min;
			slider.maximum = max;
			slider.value = (!isNaN(value)) ? value : min;
			slider.width = 300;
			slider.addEventListener( SliderEvent.MOVE, sliderHandler );
			slider.addEventListener( SliderEvent.END, sliderHandler );
			
		return slider;
	}
	
	private function actions(e :MouseEvent) :void
	{
		if(e.target.name == "save_bot")
		{
			_core.sound.volume = _vol;
			Options.BEAM_SIZE = _size;
		}
		
		_core.layers.close(_id);
	}
	
	private function sliderHandler(e :SliderEvent):void
	{
		var newlevel :Number = e.target.value;
		
		if(e.target == _vol_slider)
		{
			_vol_tf.text = int(newlevel*100).toString();		
			
			if(e.type == SliderEvent.END && newlevel != _vol)
			{
				_vol = newlevel;
				_core.sound.play(Sounds.SLIDER_MOVE);			
			}
		}
		else
		{
			newlevel = int(newlevel*10)/10;
			_size_tf.text = newlevel.toString();		
			
			if(e.type == SliderEvent.END && newlevel != _size)
			{
				_size = newlevel;
				_core.sound.play(Sounds.SLIDER_MOVE);			
			}
		}
	}
	
}
}