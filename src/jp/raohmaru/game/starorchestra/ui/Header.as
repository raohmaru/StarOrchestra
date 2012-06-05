package jp.raohmaru.game.starorchestra.ui
{
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.ColorTransform;
import flash.text.TextField;

import jp.raohmaru.events.Callback;
import jp.raohmaru.game.starorchestra.core.*;
import jp.raohmaru.game.starorchestra.core.libs.Symbols;
import jp.raohmaru.game.starorchestra.events.*;
import jp.raohmaru.game.starorchestra.model.*;
import jp.raohmaru.game.starorchestra.utils.StarUtil;
import jp.raohmaru.motion.Paprika;
import jp.raohmaru.motion.easing.Quad;

public final class Header extends GameSprite
{
	private var _stats :Sprite,
				_inited :Boolean,
				
				_username :TextField,
				_time_s1 :TextField,
				_time_s2 :TextField,
				_time_sep :TextField,
				_time_ms1 :TextField,
				_time_ms2 :TextField,
				_level :TextField,
				_level_num :TextField,
				_map :TextField,
				_map_sep :TextField,
				_map_num :TextField,
				_points :TextField;
				
	private const	TF_Y :Number = -3.0,
					CTFM :ColorTransform = new ColorTransform(0, 0, 0, 1, 255);
	
	public function Header(core:GameCore)
	{
		super(core);
	}
	
	public function add() :void
	{
		if(!_inited) init();
		
		if(_view.parent == null)
		{
			_core.canvas.addChild(_view);
			Paprika.add(_view, .2, {y:0}, Quad.easeOut);
			userHandler();
		}
		
		hideStats();
	}
	
	public function remove() :void
	{
		if(_view.parent)
		{
			Paprika.add(_view, .2, {y:-30}, Quad.easeIn, 0, Callback.simple( _core.canvas.removeChild, _view ));
		}
	}
	
	public function showStats() :void
	{
		if(!Options.CREATE_MODE)
			Paprika.add(_stats, .4, {scaleX:1}, Quad.easeOut);
	}
	
	public function hideStats() :void
	{
		if(_stats.scaleX > 0)
			Paprika.add(_stats, .3, {scaleX:0}, Quad.easeIn);
	}
	
	
	
	private function init() :void
	{
		_inited = true;
		
		_view.y = -30;
		
		_stats = new Sprite();
		_stats.x = Options.STAGE_WIDTH/2;
		_stats.scaleX = 0;
		_view.addChild(_stats);
		
		initBorders();
		initTextFields();
		initSymbols();
		
		_core.event.addEventListener(GameEvent.MAP_START,	gameHandler);
		_core.event.addEventListener(DrawEvent.DRAW_FAIL,	gameHandler);
		_core.event.addEventListener(TimeEvent.TIMER,		timeHandler);
		_core.event.addEventListener(UserEvent.UPDATE,		userHandler);
	}
	
	private function initBorders() :void
	{
		// El más grande
		var border :Sprite = StarUtil.drawRoundRect(996, 60, 2, 0xFFFFFF, 0, 1);
			border.y -= 4;
		_stats.addChild(border);
		
		// El mediano
		border = StarUtil.drawRoundRect(680, 60, 2, 0xFFFFFF, 0, 1);
		border.y -= 2;
		_stats.addChild(border);
		
		// El de primer plano
		border = StarUtil.drawRoundRect(376, 60, 2, 0xFFFFFF, 0, 1);
		border.x = Options.STAGE_WIDTH/2;
		_view.addChild(border);
	}
	
	private function initTextFields() :void
	{
		var crTF :Function = StarUtil.createTextField;
		
		// Tiempo restante
		_time_s1 = setTextField( crTF("0", 20, 0xFFCC00, -1, "right"), -447 );
		_time_s2 = setTextField( crTF("0", 20, 0xFFCC00, -1, "right"), -427 );
		_time_sep = setTextField( crTF(":", 26, 0xFFCC00), -407 );
		_time_sep.y -= 6;
		_time_ms1 = setTextField( crTF("0", 20, 0xFFCC00, -1, "right"), -400 );
		_time_ms2 = setTextField( crTF("0", 20, 0xFFCC00, -1, "right"), -380 );
		
		// Nivel
		_level = setTextField( crTF("level", 20, 0xFFCC00, -1, "left"), -308 );		
		_level_num = setTextField( crTF("0", 20, 0xFFCC00, -1, "left"), -239 );
		
		// Mapa/Número de mapas
		_map = setTextField( crTF("0", 20, 0xFFCC00, 50, "none", "right"), 208 );		
		_map_sep = setTextField( crTF("/", 20, 0xFFCC00), 256 );		
		_map_num = setTextField( crTF("0", 20, 0xFFCC00, 50, "none", "left"), 270 );
		
		// Puntos (phis)
		_points = setTextField( crTF("0", 20, 0xFFCC00, 140, "none", "right"), 350 );
		
		// Nombre del usuario
		_username = setTextField( crTF("guest", 20, 0xFFFFFF, 364), Options.STAGE_WIDTH/2 - 182, _view );
	}
	
	private function initSymbols() :void
	{
		// Symbolos de tiempo restante y los puntos (phis)
		var sym :Sprite = new Symbols.WATCH();		
			sym.x = -476;
			sym.y = 12;
		_stats.addChild(sym);
		
		// Symbolos de puntos (phis)
		sym = new Symbols.POINTS();		
		sym.x = 356;
		sym.y = 13;
		_stats.addChild(sym);
	}
	
	private function setTextField(tf :TextField, x :Number, parent :Sprite=null) :TextField
	{
		tf.x = x;
		tf.y = TF_Y;
		if(parent == null) parent = _stats;
		parent.addChild(tf);
		
		return tf;
	}
	
	private function updateTextValue(tf :TextField, value :Object) :void
	{
		var s :String = String(value);
		
		if( tf.text != s || tf.alpha < 1)
		{
			Paprika.add(tf, .2, {y:TF_Y+10, alpha:0}, Quad.easeIn, 0, function() :void
			{
				tf.text = s;
				tf.y = TF_Y-10;
				Paprika.add(tf, .2, {y:TF_Y, alpha:1}, Quad.easeOut);
			});
		}
	}	
	
	private function setTime(time :int, reset :Boolean=false) :void
	{
		var	arr :Array = String(time/1000).split(".");
		
		var s :String = arr[0];
		if(s > "99") s = "99";
		else if(s.length == 1)
			s = "0" + s;
		
		var ms :String = "00";
		if(arr[1])
			ms = arr[1];
		ms = ms.substr(0, 2);
		if(ms.length == 1)
			ms += "0";
		
		if(reset)
		{
			updateTextValue(_time_s1, s.charAt(0));
			updateTextValue(_time_s2, s.charAt(1));
			updateTextValue(_time_ms1, ms.charAt(0));
			updateTextValue(_time_ms2, ms.charAt(1));
		}
		else
		{
			_time_s1.text = s.charAt(0);
			_time_s2.text = s.charAt(1);
			_time_ms1.text = ms.charAt(0);
			_time_ms2.text = ms.charAt(1);
		}
	}
	
	
	private function gameHandler(e :Event) :void
	{
		var arr :Array = [_time_s1, _time_s2, _time_sep, _time_ms1, _time_ms2];
		
		if(e.type == GameEvent.MAP_START)
		{
			var level :Level = _core.levels.currentLevel();
			
			if(_core.timer.duration > 0)
			{
				setTime(level.currentMap().time, true);
				Paprika.add(_time_sep, .2, {alpha:1});
			}
			else
			{
				for(var i :int=0; i<arr.length; i++) 
					Paprika.add(arr[i], .2, {alpha:0});
			}
			
			updateTextValue(_level_num, _core.levels.index+1);
			updateTextValue(_map, level.index+1);
			updateTextValue(_map_num, level.numMaps);
		}
		else if(_core.levels.currentLevel().currentMap().error > 0)
		{				
			var tf :TextField;
			
			for(i=0; i<arr.length; i++) 
			{
				tf = arr[i];
				tf.transform.colorTransform = CTFM;
				Paprika.add(tf, .2, {color:null});
			}
		}
	}
	
	private function timeHandler(e :TimeEvent) :void
	{
		setTime(e.timeLeft);
	}
	
	private function userHandler(e :UserEvent=null) :void
	{
		updateTextValue(_points, _core.users.getUser().phis);
	}
}
}