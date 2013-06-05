package jp.raohmaru.game.starorchestra.ui.screens
{
import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.text.TextField;

import jp.raohmaru.game.starorchestra.core.*;
import jp.raohmaru.game.starorchestra.enums.Sounds;
import jp.raohmaru.game.starorchestra.events.GameEvent;
import jp.raohmaru.game.starorchestra.model.Options;
import jp.raohmaru.game.starorchestra.model.User;
import jp.raohmaru.game.starorchestra.ui.buttons.GlowButton;
import jp.raohmaru.game.starorchestra.utils.StarUtil;
import jp.raohmaru.motion.Paprika;
import jp.raohmaru.motion.easing.Quad;

public final class LevelSelectScreen extends AbsctractScreen
{
	private var _level :int = -1,
				_map :int = -1,
				_levels :Vector.<Sprite>,
				_maps :Vector.<Sprite>,
				_map_cont :Sprite,
				_play_bot :GlowButton;
	
	public function LevelSelectScreen(core :GameCore)
	{
		super(core);
	}
	
	override public function addAndPlay() :void
	{
		if(_map_cont!= null && _map_cont.parent)
			_view.removeChild(_map_cont);
		
		super.addAndPlay();
		
		if(_level > -1)
		{
			highlight(_levels[_level], false);
			_level = -1;
		}
		
		if(_map > -1)
		{
			highlight(_maps[_map], false);
			_map = -1;
		}
		
		_play_bot.mouseEnabled = false;
		Paprika.remove(_play_bot);
		Paprika.add(_play_bot, .3, {autoAlpha:.4, scale:1}, Quad.easeOut, _view.getChildIndex(_play_bot)*.1);
		
		
		var mlv :uint = _core.users.getUser().maxLevel;
		for(var i :int=0; i<_levels.length; i++) 
		{
			_levels[i].mouseEnabled = (i <= mlv);
			_levels[i].alpha = (i <= mlv) ? 1 : .3;
		}
	}
	
	
	override protected function init() :void
	{
		super.init();
		
		var x :Number = Options.STAGE_WIDTH/2,
			y :Number = 540,
			w :Number = GlowButton.WIDTH/2;
		
		createButton("back", "back_bot", x-w-10, y, actions);
		_play_bot = createButton("play", "play_bot", x+w+10, y, actions);
		
		_levels = new Vector.<Sprite>;
		_maps = new Vector.<Sprite>;
		
		
		var lv_cont :Sprite = new Sprite();
			lv_cont.x = 279;
			lv_cont.y = 273;
			lv_cont.alpha = 0;
			lv_cont.visible = false;
			lv_cont.scaleX = lv_cont.scaleY = .7;
		_view.addChildAt(lv_cont, 0);
		
		lv_cont.addChild( StarUtil.drawRoundRect(508, 418) );
		
		var lvs :XMLList = Options.CONFIG.levels.level;
		for(var i :int=0; i<lvs.length(); i++)
			_levels.push( lv_cont.addChild( createSelectButton(i, "l", "Level ", lvs[i].@title, 508) ) );
	}
	
	private function createSelectButton(idx :int, name :String, label :String, title :String, w :Number) :Sprite
	{
		w -= 20;
		
		var sp :Sprite = new Sprite();
			sp.name = name + idx;
			sp.x = -w/2;
			sp.y = -197 + 40*idx;
			sp.mouseChildren = false;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, levelHandler);
		
		var tf :TextField = StarUtil.createTextField(label+(idx+1), 22, 0xFFFFFF, -1, "left", "left");
			tf.x = 10;
		sp.addChild(tf);
		
		tf = StarUtil.createTextField(title, 22, 0xFFCC00, -1, "left", "left");
		tf.x = 143;
		sp.addChild(tf);
		
		var sh :Sprite = StarUtil.drawRoundRect(w, 33);
			sh.x = sh.width/2;
			sh.y = sh.height/2;
			sh.alpha = 0;
			sp.addChildAt(sh, 0);
		
		return sp;
	}
	
	private function updateMapList() :void
	{
		if(_map_cont == null)
		{
			_map_cont = new Sprite();
			_map_cont.x = 782;
			_map_cont.y = 273;
			
			_map_cont.addChild( StarUtil.drawRoundRect(437, 418) );
		}
		
		Paprika.add(_map_cont, (_map_cont.parent ? .2 : 0), {rotationX:90}, Quad.easeIn, 0, function() :void
		{
			var xml :XMLList = Options.CONFIG.levels.level[_level].map,
				bot :Sprite,
				mlv :uint = _core.users.getUser().maxLevel,
				mmap :uint = _core.users.getUser().maxMap,
				enabled :Boolean,
				sepY :Number = 400/xml.length();
			for(var i :int=0; i<xml.length(); i++)
			{
				if(i >= _maps.length)
				{
					bot = createSelectButton(i, "m", "Song ", xml[i].@title, 437);
					_map_cont.addChild( bot );
					_maps.push( bot );
				}
				else
				{
					bot = _maps[i];
					TextField(bot.getChildAt(2)).text = xml[i].@title;
				}
				
				enabled = (_level < mlv || i <= mmap);				
				bot.mouseEnabled = (enabled);
				bot.alpha = (enabled) ? 1 : .3;
				bot.visible = true;
				bot.y = -197 + sepY*i;
			}
			
			for(i; i<_maps.length; i++)
				if(_maps[i].visible)
					_maps[i].visible = false;
			
			if(_level == mlv && _map > mmap || _map >= xml.length())
			{
				highlight(_maps[_map], false);
				_map = (_level == mlv && _map > mmap) ? mmap : xml.length()-1;
				highlight(_maps[_map]);
			}
			
			_map_cont.rotationX = -90;
			Paprika.add(_map_cont, .2, {rotationX:0}, Quad.easeOut);
		});
		
		if(!_map_cont.parent)
		{
			_map_cont.alpha = 1;
			_map_cont.visible = true;
			_map_cont.scaleX = _map_cont.scaleY = 1;
			_view.addChildAt(_map_cont, 0);
		}
	}
	
	private function highlight(item :Sprite, select :Boolean=true) :void
	{
		Paprika.add(item.getChildAt(0), .15, {alpha:(select ? 1 : 0)});
	}
	
	
	private function actions(e :MouseEvent) :void
	{
		if(e.target.name == "back_bot")
			dispatchEvent(new GameEvent(GameEvent.GO_HOME));
			
		else
		{
			var u :User = _core.users.getUser();
				u.level = _level;
				u.map = _map;
			dispatchEvent(new GameEvent(GameEvent.GAME_START));
		}
	}
	
	protected function levelHandler(e :MouseEvent):void
	{
		var name :String = e.target.name,
			sp :Sprite;
		
		if(name.charAt(0) == "l")
		{
			if(_level > -1)
				sp = _levels[_level];
			_level = int( name.substr(1) );
			updateMapList();
		}
		else
		{
			if(_map > -1)
				sp = _maps[_map];
			_map = int( name.substr(1) );
		}
		
		if(sp) highlight(sp, false);
		highlight(Sprite(e.target));
		
		if(_level > -1 && _map > -1)
		{
			Paprika.add(_play_bot, .2, {alpha:1});
			_play_bot.mouseEnabled = true;
		}
		
		_core.sound.play(Sounds.SLIDER_MOVE);
	}
}
}