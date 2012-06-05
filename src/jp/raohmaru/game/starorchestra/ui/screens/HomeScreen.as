package jp.raohmaru.game.starorchestra.ui.screens
{
import flash.events.MouseEvent;

import jp.raohmaru.game.starorchestra.core.*;
import jp.raohmaru.game.starorchestra.enums.Awards;
import jp.raohmaru.game.starorchestra.enums.Layers;
import jp.raohmaru.game.starorchestra.events.GameEvent;
import jp.raohmaru.game.starorchestra.model.Options;
import jp.raohmaru.game.starorchestra.model.User;
import jp.raohmaru.game.starorchestra.ui.buttons.GlowButton;
import jp.raohmaru.motion.Paprika;
import jp.raohmaru.motion.easing.Quad;

public final class HomeScreen extends AbsctractScreen
{
	private var _play_bot :GlowButton,
				_select_bot :GlowButton,
				_free_bot :GlowButton;
	
	public function HomeScreen(core :GameCore)
	{
		super(core);
	}
	
	public function changePlayBotLabel(reset :Boolean=false) :void
	{
		_play_bot.label = (reset) ? "play" : "continue";
	}
	
	override public function addAndPlay() :void
	{
		super.addAndPlay();
		
		var u :User = _core.users.getUser();
		checkButton(_select_bot, u.hasAward(Awards.SELECT_LEVEL));
		checkButton(_free_bot, u.hasAward(Awards.FREE_MODE));
	}
	
	override protected function init() :void
	{
		super.init();
		
		var x :Number = Options.STAGE_WIDTH/2,
			y :Number = 256,
			h :Number = GlowButton.HEIGHT;
		
		_play_bot =		createButton("play",			"play_bot",		x, y,			actions);
		_free_bot =		createButton("free mode",		"free_bot",		x, y+h,			actions);
		_select_bot =	createButton("select level",	"select_bot",	x, y+h*2,		actions);
						createButton("options",			"options_bot",	x, y+h*3,		actions);
		//createButton("awards",			"awards_bot",	x, y+h*4,		actions);
						createButton("logout",			"logout_bot",	x, y+h*4+33,	actions);
	}
	
	private function checkButton(bot :GlowButton, enabled :Boolean) :void
	{
		bot.mouseEnabled = enabled;
		Paprika.remove(bot);
		Paprika.add(bot, .3, {autoAlpha:(enabled ? 1 : .4), scale:1}, Quad.easeOut, _view.getChildIndex(bot)*.1);
	}
	
	private function actions(e :MouseEvent) :void
	{
		Options.CREATE_MODE = false;
		
		if(e.target.name == "play_bot")
			dispatchEvent(new GameEvent(GameEvent.GAME_START));
			
		else if(e.target.name == "free_bot")
		{
			Options.CREATE_MODE = true;
			dispatchEvent(new GameEvent(GameEvent.GAME_START));
		}
		
		else if(e.target.name == "select_bot")
			dispatchEvent(new GameEvent(GameEvent.LEVEL_SELECT));
		
		else if(e.target.name == "options_bot")
			_core.layers.open(Layers.OPTIONS);
			
		else if(e.target.name == "awards_bot")
			trace("Awards");
			
		else
			dispatchEvent(new GameEvent(GameEvent.LOGOUT));
	}
}
}