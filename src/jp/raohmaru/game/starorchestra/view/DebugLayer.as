package jp.raohmaru.game.starorchestra.view
{
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.*;
import flash.filesystem.*;
import flash.text.*;
import flash.ui.Keyboard;

import jp.raohmaru.game.starorchestra.core.*;
import jp.raohmaru.game.starorchestra.core.libs.Symbols;
import jp.raohmaru.game.starorchestra.enums.Sounds;
import jp.raohmaru.game.starorchestra.events.DrawEvent;
import jp.raohmaru.game.starorchestra.model.Map;
import jp.raohmaru.game.starorchestra.model.Options;
import jp.raohmaru.game.starorchestra.utils.StarUtil;
import jp.raohmaru.motion.Paprika;
import jp.raohmaru.motion.easing.Quad;

import qnx.ui.buttons.CheckBox;
import qnx.ui.buttons.LabelButton;
import qnx.ui.events.SliderEvent;
import qnx.ui.skins.SkinStates;
import qnx.ui.slider.Slider;

public class DebugLayer extends GameSprite
{
	private var _cont :Sprite,
				_name :TextField,
				_cols :TextField,
				_rows :TextField,
				_width :TextField,
				_height :TextField,
				_tempo :TextField,
				
				_cols_sld :Slider,
				_rows_sld :Slider,
				_width_sld :Slider,
				_height_sld :Slider,
				_error :CheckBox,
				_time :CheckBox,
				
				_note_id :int = -1,
				_last_e :String,
				_map :Map,
				_map_data :XML,
				_inited :Boolean,
				_y :Number = 0,
				_cont_x :Number;
	private const	DEFAULT_MAP :XML = <map cols="2" rows="2" width="300" height="300" title="">
										<sequence />
									</map>;
	
	
	public function DebugLayer(core:GameCore)
	{
		super(core);
	}
	
	public function start() :void
	{
		if(!_inited)
			init();
		
		if(!_view.visible)
		{
			_map_data = DEFAULT_MAP.copy();
			_map = _core.levels.currentLevel().currentMap();
			_map.update(_map_data);
			Paprika.add(_view, .3, {autoAlpha:1});
			
			_cols.text = DEFAULT_MAP.@cols;
			_rows.text = DEFAULT_MAP.@rows;
			_width.text = DEFAULT_MAP.@width;
			_height.text = DEFAULT_MAP.@height;
			
			_cols_sld.value = DEFAULT_MAP.@cols;
			_rows_sld.value = DEFAULT_MAP.@rows;
			_width_sld.value = DEFAULT_MAP.@width;
			_height_sld.value = DEFAULT_MAP.@height;
			
			_cont.x = _cont_x;
			
			_core.event.addEventListener(DrawEvent.DRAW_BEGIN, drawHandler);
			_core.event.addEventListener(DrawEvent.DRAW_LINE, drawHandler);
			_core.event.addEventListener(DrawEvent.DRAW_END, drawHandler);
		}
	}
	
	public function stop() :void
	{
		if(_view.visible)
		{
			_map = null;
			Paprika.add(_view, .2, {autoAlpha:0});
			
			_core.event.removeEventListener(DrawEvent.DRAW_BEGIN, drawHandler);
			_core.event.removeEventListener(DrawEvent.DRAW_LINE, drawHandler);
			_core.event.removeEventListener(DrawEvent.DRAW_END, drawHandler);
			_core.canvas.stage.removeEventListener(MouseEvent.MOUSE_DOWN, openHandler);
		}
	}
	
	
	
	private function init() :void
	{
		_inited = true;
		
		_view.alpha = 0;
		_view.visible = false;
		
		_cont = new Sprite();
		_view.addChild(_cont);
		
		
		var crTF :Function = StarUtil.createTextField;
		
		// Sliders
		addTF( crTF("cols", 16, 0xFFCC00) );
		_cols = addTF( crTF(DEFAULT_MAP.@cols, 16, 0xFFFFFF, -1, "left"), 50 );
		_cols_sld = addSlider("cols", 0, 30, 1, 6, DEFAULT_MAP.@cols);
		
		addTF( crTF("rows", 16, 0xFFCC00), 0, 30 );
		_rows = addTF( crTF(DEFAULT_MAP.@rows, 16, 0xFFFFFF, -1, "left"), 60 );
		_rows_sld = addSlider("rows", 0, 30, 1, 5, DEFAULT_MAP.@rows);
		
		addTF( crTF("width", 16, 0xFFCC00), 0, 30 );
		_width = addTF( crTF(DEFAULT_MAP.@width, 16, 0xFFFFFF, 60, "none", "left"), 70, 0, "_width_", true, true );
		_width_sld = addSlider("width", 0, 30, DEFAULT_MAP.@width, Options.BOARD.width);
		
		addTF( crTF("height", 16, 0xFFCC00), 0, 30 );
		_height = addTF( crTF(DEFAULT_MAP.@height, 16, 0xFFFFFF, 60, "none", "left"), 80, 0, "_height_", true, true );
		_height_sld = addSlider("height", 0, 30, DEFAULT_MAP.@height, Options.BOARD.height);		
		
		if(Options.DEBUG)
		{
			// Campo nombre del mapa
			_name = addTF( crTF("[map name]", 16, 0xFFFFFF, 200, "none", "left"), 0, 30, "map_name", true );
			_name.border = true;
			_name.borderColor = 0xFFCC00;
			
			// Checkbox contabilizar errores
			_error = addCheckbox("error penalty", 0, 30, true);
			
			// Tiempo
			_time = addCheckbox("time", 0, 30, true);
			
			// Note tempo
			var tempo :Number = Options.NOTE_TEMPO/1000;
			addTF( crTF("note tempo", 16, 0xFFCC00), 0, 30 );
			_tempo = addTF( crTF(tempo.toString(), 16, 0xFFFFFF, -1, "left"), 140 );
			addSlider("tempo", 0, 30, .1, 1, tempo);
		}
		
		// Botones
		addButton("reset_bot", "reset", 0, 40);
		if(Options.DEBUG)
			addButton("save_bot", "save", 90);
		
		// Recuadro del fondo		
		var sp :Sprite = StarUtil.drawRoundRect(300, _cont.height+20, 2.0, 0xFFCC00, 0, .5);
			sp.x = sp.width/2 - 40;
			sp.y = sp.height/2 - 15;
			sp.mouseChildren = false;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, openHandler);
		_cont.addChildAt(sp, 0);
		
		// Símbolo de agarre
		sp = new Symbols.LAYER_GRIP() as Sprite;
		sp.x = -19;
		sp.y = _cont.height/2 - 15;
		sp.mouseEnabled = sp.mouseChildren = false;
		_cont.addChildAt(sp, 1);
		
		// Posición del contenedor
		_cont_x = 
		_cont.x = Options.STAGE_WIDTH + 3;
		_cont.y = Options.STAGE_HEIGHT/2 - _cont.height/2 + 15;
	}
	
	private function addTF(tf :TextField, x :Number=0, padY: Number=0, name :String=null, input :Boolean=false, handler :Boolean=false) :TextField
	{
		if(name)
			tf.name = name;
		setPos(tf, x, padY);
		tf.width += 5;
		tf.height += 5;
		
		if(Options.DEBUG)
		{
			if(input)
			{
				tf.type = TextFieldType.INPUT;
				tf.selectable = true;
				tf.restrict = "!#$%()*+,-./0123456789:;=?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]_ abcdefghijklmnopqrstuvwxyz{|}¡€ª·º¿ÀÁÄÇÈÉËÌÍÏÑÒÓÖÙÚÜàáäçèéëìíïñòóöùúü";
			}			
			if(handler)
			{
				tf.addEventListener(FocusEvent.FOCUS_OUT, textHandler);
				tf.addEventListener(KeyboardEvent.KEY_UP, textHandler);
			}
		}
		
		_cont.addChild(tf);
		
		return tf;
	}
	
	private function addSlider(name :String, x :Number=0, padY: Number=0, min :Number=0, max :Number=0, value :Number=NaN) :Slider
	{
		var slider :Slider =  new Slider();
			slider.name = name;
			setPos(slider, x, padY);
			slider.minimum = min;
			slider.maximum = max;
			slider.value = (!isNaN(value)) ? value : min;
			slider.width = 200;
			slider.addEventListener( SliderEvent.MOVE, sliderHandler );
			slider.addEventListener( SliderEvent.END, sliderHandler );
			
		_cont.addChild( slider );
		return slider;
	}
	
	private function addButton(name :String, label :String, x :Number=0, padY: Number=0) :void
	{
		var tfmt_up :TextFormat = new TextFormat("Neuropol", 14, 0x000000),
			tfmt_down :TextFormat = new TextFormat("Neuropol", 14, 0xFFFFFF);
		
		var button :LabelButton = new LabelButton();
			button.name = name;
			button.embedFonts = true;
			button.label = label;
			setPos(button, x, padY);
			button.setSize(80, 30);
			button.setTextFormatForState(tfmt_up, SkinStates.UP);	
			button.setTextFormatForState(tfmt_down, SkinStates.DOWN);
			button.addEventListener(MouseEvent.MOUSE_DOWN, botHandler);
			
		_cont.addChild(button);
	}
	
	private function addCheckbox(label :String, x :Number=0, padY: Number=0, selected :Boolean=false) :CheckBox
	{
		var tfmt_chk :TextFormat = new TextFormat("Neuropol", 14, 0xFFFFFF);
		
		var chbx :CheckBox = new CheckBox();
			setPos(chbx, x, padY);
			chbx.width = 140;
			chbx.embedFonts = true;
			chbx.label = label;
			chbx.setTextFormatForState(tfmt_chk, SkinStates.UP);
			chbx.setTextFormatForState(tfmt_chk, SkinStates.SELECTED);
			chbx.selected = selected;
			chbx.labelPadding = 5;
		
		_cont.addChild(chbx);
		return chbx;
	}
	
	private function setPos(obj :DisplayObject, x :Number, y :Number) :void
	{
		obj.x = x;
		obj.y = _y + y;
		_y = obj.y; // + obj.height;
	}
	
	private function reset() :void
	{
		_note_id = -1;
		_map_data.sequence = <sequence />;
		
		if(Options.DEBUG)
		{
			if(Number(_tempo.text) != Options.NOTE_TEMPO/1000)
				_map_data.sequence.@tempo = _tempo.text;
		}
		
		_core.view.drawLevel();
	}
	
	
	
	private function sliderHandler( e :SliderEvent ) :void
	{
		var name :String = e.target.name,
			newlevel :Number,
			changed :Boolean;
		
		if(name != "tempo")
		{
			newlevel = Math.round( e.target.value );
				
			if(newlevel != _map_data.attribute(name) && e.type == SliderEvent.END)
			{
				var att :XMLList = _map_data.attribute(name);
					att[0] = newlevel;
				changed = true;
			}
			
			if( ((name == "width" || name == "height") && changed) ||
				((name == "cols" || name == "rows") && this["_"+name].text != newlevel.toString()) )
			{
				_core.sound.play(Sounds.SLIDER_MOVE);
			}
			
			this["_"+name].text = newlevel.toString();
			
			if(changed)
			{
				_map.update(_map_data);
				reset();
			}
		}
		else
		{
			newlevel = Number(e.target.value.toFixed(1));
			
			if(e.type == SliderEvent.MOVE)
				_tempo.text = newlevel.toString();
			else
			{
				changed = (newlevel*1000 != Options.NOTE_TEMPO);
				if(changed)
					_map_data.sequence.@tempo = newlevel;
				else
					delete _map_data.sequence.@tempo;
			}
		}
	}
	
	private function drawHandler(e :DrawEvent):void
	{
		if(e.type == DrawEvent.DRAW_END)
		{
			if(_last_e == DrawEvent.DRAW_BEGIN)
				delete _map_data.sequence.note[_map_data.sequence.note.length()-1];
		}
		else if(e.id != _note_id)
		{
			var note :XML = new XML( '<note id="' + e.id + '" />' );
			
			if(e.type == DrawEvent.DRAW_BEGIN && _note_id != -1)
				note.@follow = "false";
			
			_map_data.sequence.appendChild( note );
			_note_id = e.id;
			_last_e = e.type;
		}
	}	
	
	private function botHandler(e :MouseEvent):void
	{
		if(e.target.name == "save_bot")
		{
			_map_data.@title = _name.text;
			
			if(_error.selected)
				delete _map_data.@error;
			else
				_map_data.@error = "0";
			
			if(_time.selected)
				delete _map_data.sequence.@time;
			else
				_map_data.sequence.@time = "0";			
			
			
			var file :File = new File("D:/Mis documentos/Learning/Mobile/Blackberry Playbook/Star Orchestra/src/maps.xml");
			var fileStream :FileStream = new FileStream();
				fileStream.open(file, FileMode.APPEND);
			fileStream.writeUTFBytes("\n"+_map_data.toXMLString());
			fileStream.close();	
		}
		else
		{
			reset();
		}
		
		_core.sound.play(Sounds.BUTTON_CLICK4);
	}	
	
	private function textHandler(e :Event):void
	{
		if(e.type == FocusEvent.FOCUS_OUT || KeyboardEvent(e).keyCode == Keyboard.ENTER)
		{
			var tf :TextField = e.target as TextField,
				slider :Slider = this[tf.name+"sld"],
				newlevel :int = int(e.target.text);
			
			if(newlevel != slider.value)
			{
				if(newlevel < slider.minimum)
					newlevel = slider.minimum;
				
				else if(newlevel > slider.maximum)
					newlevel = slider.maximum;
				
				tf.text = newlevel.toString();
				slider.value = newlevel;			
				slider.dispatchEvent(new SliderEvent(SliderEvent.END, newlevel));
			}
		}
	}	
	
	protected function openHandler(e :MouseEvent):void
	{
		var isStage :Boolean = (e.currentTarget == _core.canvas.stage);
		
		if(_cont.mouseX < 0 && !isStage || !_cont.hitTestPoint(_view.mouseX,_view.mouseY) && isStage)
		{			
			var open :Boolean = (_cont.x >= _cont_x);
			
			var x :Number = _cont_x - (open ? 220 : 0);
			Paprika.add(_cont, .3, {x:x}, Quad.easeInOut);
			
			if(open)
				_core.canvas.stage.addEventListener(MouseEvent.MOUSE_DOWN, openHandler);
			else
				_core.canvas.stage.removeEventListener(MouseEvent.MOUSE_DOWN, openHandler);
			
			e.stopImmediatePropagation();
		}
	}	
}
}