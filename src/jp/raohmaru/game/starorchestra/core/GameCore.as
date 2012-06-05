package jp.raohmaru.game.starorchestra.core
{
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;

import jp.raohmaru.game.starorchestra.StarOrchestra;
import jp.raohmaru.game.starorchestra.controller.*;
import jp.raohmaru.game.starorchestra.enums.Layers;
import jp.raohmaru.game.starorchestra.enums.Sounds;
import jp.raohmaru.game.starorchestra.events.*;
import jp.raohmaru.game.starorchestra.model.*;
import jp.raohmaru.game.starorchestra.ui.layers.MessageLayer;
import jp.raohmaru.game.starorchestra.view.StarBoard;
import jp.raohmaru.motion.Paprika;

public final class GameCore
{
	public var	canvas :Sprite,
				event :EventMan,
				view :ViewMan,
				levels :LevelMan,
				director :Director,
				sound :SoundMan,
				layers :LayerMan,
				timer :TimeMan,
				users :UserMan;
	private var _state :uint,
				_repeat :Boolean;
	
	public function GameCore(canvas :Sprite)
	{
		this.canvas = canvas;
		init();
	}
	
	public function start() :void
	{
		levels.index = users.getUser().level;
		levels.currentLevel().index = users.getUser().map;
		nextMap();
	}
	
	public function stop() :void
	{
		view.clear();
		director.stop();
		timer.stop();
		layers.removeEventListener(LayerEvent.LAYER_CLOSE, layerHandler);
		layers.close();
		_repeat = false;
	}
	
	public function nextMap() :void
	{
		view.drawLevel();
		timer.reset();
		event.gameEvent(GameEvent.MAP_START);
		_state = 0;
		
		var map :Map = levels.currentLevel().currentMap(),
			played :Boolean = (levels.index < users.getUser().maxLevel || levels.currentLevel().index < users.getUser().maxMap);
		if(!played && !_repeat && map.startMsg.text)
			Paprika.wait( this, map.stars.length * StarBoard.DELAY + .2, 0, showMessage, [map.startMsg, MessageLayer.CONTINUE_BUTTON] );
		else
			layerHandler();
		
		_repeat = false;
	}
	
	
	
	private function init() :void
	{
		event		= new EventMan();
		levels		= new LevelMan(Options.CONFIG.levels.level);
		view		= new ViewMan(this);
		director	= new Director(this);
		sound		= new SoundMan(this);
		layers		= new LayerMan(this);
		timer		= new TimeMan(this);
		users		= new UserMan(this);
		
		event.addEventListener(GameEvent.MAP_COMPLETE, gameHandler);
		event.addEventListener(GameEvent.MAP_ERROR, gameHandler);
	}
	
	private function showMessage(message :Message, bots :uint, snd :String=null) :void
	{
		var msg :MessageLayer = layers.open(Layers.MESSAGE) as MessageLayer;
			msg.title = message.title;
			msg.message = message.text;
			msg.buttons = bots;
		
		layers.addEventListener(LayerEvent.LAYER_CLOSE, layerHandler);
		
		if(snd == null) snd = Sounds.LAYER_INFO;
		sound.play(snd);
	}
	
	private function gameHandler(e :GameEvent):void
	{
		view.stop();
		director.stop();
		timer.stop();
		
		var map :Map = levels.currentLevel().currentMap(),
			msg :Message = map.endMsg.clone(),
			time :Number = map.time,
			award :String = map.award,
			bonus :int = map.bonus,
			u :User = users.getUser(),
			played :Boolean = (u.gameComplete || levels.index < u.maxLevel || levels.currentLevel().index < u.maxMap),
			bots :uint = MessageLayer.EXIT_BUTTON,
			t :Number = .8,
			snd :String;
		
		_state = ( e.type == GameEvent.MAP_ERROR || levels.next() ) ? 1 : 2;
		
		if(e.type == GameEvent.MAP_ERROR)
		{
			msg.title = "oh oh...";
			msg.text = "You ran out of time.";
			bots |= MessageLayer.REPLAY_BUTTON;
			t = .2;
			snd = Sounds.LAYER_ERROR;
			_repeat = true;
		}
		else
		{
			// Mensaje final
			if(msg.title == null || played)
				msg.title = (_state == 2) ? "game complete!" : (levels.currentLevel().index == 0) ? "level complete!" : "song complete!";
			
			msg.text = (msg.text == null || played) ? "" : msg.text + "\n";
			
			var phis :int = Options.TIME_BONUS - timer.time*.025;
			if(phis < 0) phis = 0;
			
			if(time > 0)
				msg.text +=	"\nSong completed in " + (timer.time/1000).toFixed(2) + " s";
			if(!played)
			{
				msg.text += "\n<font color='#FFCC00'>Phis obtained:</font> <font size='24'>" + Options.MAP_PHIS + "</font>"; 
				if(bonus > 0)
					msg.text +=	"\n<font color='#FC9803'>Song bonus:</font> <font size='24'>" + bonus + "</font>";
				if(time > 0)
					msg.text +=	"\nTime bonus: <font size='24'>" + phis + "</font>";
			}
			
			if(_state != 2)
			{
				msg.text +=	"\n\n<font size='18'>Next: <font color='#32beff'>" + levels.currentLevel().currentMap().title + "</font></font>";
				bots |= MessageLayer.NEXT_BUTTON;
			}
			
			// Actualiza datos del usuario
			if(!played)
			{
				u.phis += Options.MAP_PHIS;
				if(time > 0)
					u.phis += phis;
				if(bonus > 0)
					u.phis += bonus;
			}
			if(_state != 2)
			{
				u.level = levels.index;
				u.map = levels.currentLevel().index;
			}
			else
			{
				u.gameComplete = true;
				snd = Sounds.END;
			}
			
			if(!played)
			{
				if(u.level > u.maxLevel)
				{
					u.maxLevel = u.level;
					u.maxMap= u.map;
				}
				else if(u.map > u.maxMap)
					u.maxMap= u.map;
			}
			
			if(!played && award != null && !u.hasAward(award))
				u.addAward(award);
		}
		
		Paprika.wait( this, t, 0, showMessage, [msg, bots, snd] );
		Paprika.wait( this, t+.3, 0, users.update );
	}
	
	private function layerHandler(e :LayerEvent = null):void
	{
		layers.removeEventListener(LayerEvent.LAYER_CLOSE, layerHandler);
		
		if(!e || _state == 0)
		{
			Paprika.wait(
				this,
				(e) ? .6 : levels.currentLevel().currentMap().stars.length * StarBoard.DELAY + .6,
				0,
				director.start );
		}
		else if(_state == 1)
			Paprika.wait( this, .4, 0, nextMap );
		
		else
			event.gameEvent(GameEvent.GAME_EXIT);
	}
}
}