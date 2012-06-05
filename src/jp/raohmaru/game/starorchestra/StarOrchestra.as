package jp.raohmaru.game.starorchestra
{
import flash.display.*;
import flash.events.Event;

import jp.raohmaru.game.starorchestra.controller.*;
import jp.raohmaru.game.starorchestra.core.GameCore;
import jp.raohmaru.game.starorchestra.events.GameEvent;
import jp.raohmaru.game.starorchestra.model.*;
import jp.raohmaru.game.starorchestra.ui.*;
import jp.raohmaru.game.starorchestra.ui.buttons.ToolsButton;
import jp.raohmaru.game.starorchestra.ui.screens.*;
import jp.raohmaru.motion.Paprika;

public class StarOrchestra
{
	private var	_owner :Sprite,
				_canvas :Sprite,
				_core :GameCore,
				_bg :BG,
				_logo :Logo,
				_header :Header,
				_tools :ToolsButton,
				_start_scr :AbsctractScreen,
				_home_scr :AbsctractScreen,
				_level_scr :AbsctractScreen;
				
	public function get view() :Sprite
	{
		return _canvas;
	}
	
	
	
	public function StarOrchestra(owner :Sprite, config :XML)
	{
		_owner = owner;
		
		init(config);
	}
	
	private function init(config :XML) :void
	{
		Options.setup(config, _owner.stage);
		
		_canvas = new Sprite();
		
		_bg =  new BG();
		_canvas.addChild(_bg);
		
		_core = new GameCore(_canvas);
		_core.event.addEventListener(GameEvent.GAME_EXIT, gameHandler);
		
		_logo = new Logo(_core);
		_header = new Header(_core);
		_tools = new ToolsButton(_core);
		
		_start_scr = new StartScreen(_core);
		_start_scr.addEventListener(GameEvent.GO_HOME, goHome);
		
		_home_scr = new HomeScreen(_core);
		_home_scr.addEventListener(GameEvent.LOGOUT, goStart);
		_home_scr.addEventListener(GameEvent.GAME_START, gameHandler);
		_home_scr.addEventListener(GameEvent.LEVEL_SELECT, goLevelSelect);
		
		_level_scr = new LevelSelectScreen(_core);
		_level_scr.addEventListener(GameEvent.GO_HOME, goHome);
		_level_scr.addEventListener(GameEvent.GAME_START, gameHandler);
		
		start();
	}
	
	private function start() :void
	{
		_logo.add();
		_logo.play();
		
		Paprika.wait(this, .8, 0, _start_scr.addAndPlay);
	}
	
	private function goStart(e :GameEvent=null) :void
	{
		_core.users.destroy();
		
		_home_scr.remove();
		_header.remove();
		
		_start_scr.addAndPlay();
		
		_logo.maximize();
	}
	
	private function goHome(e :GameEvent=null) :void
	{
		_core.users.createUser("guest");
		
		_start_scr.remove();
		_level_scr.remove();
		_tools.remove();
		
		_home_scr.addAndPlay();
		HomeScreen(_home_scr).changePlayBotLabel( (_core.users.getUser().level == 0 && _core.users.getUser().map == 0) );
		
		_logo.add();
		_logo.minimize();
		
		_header.add();
	}
	
	private function goLevelSelect(e :GameEvent) :void
	{
		_home_scr.remove();
		_logo.remove();
		
		_level_scr.addAndPlay();
	}
	
	private function gameHandler(e :GameEvent):void
	{
		if(e.type == GameEvent.GAME_START)
		{
			_home_scr.remove();
			_level_scr.remove();
			_logo.remove();
			_header.showStats();
			_tools.add();
			
			Paprika.wait(this, .5, 0, _core.start);
		}
		
		else if(e.type == GameEvent.GAME_EXIT)
		{
			_core.stop();
			HomeScreen(_home_scr).changePlayBotLabel();
			Paprika.wait(this, .2, 0, goHome);
		}
	}
}
}