package jp.raohmaru.game.starorchestra.ui.layers
{
import flash.events.MouseEvent;
import flash.text.TextField;

import jp.raohmaru.game.starorchestra.core.GameCore;
import jp.raohmaru.game.starorchestra.enums.Layers;
import jp.raohmaru.game.starorchestra.events.GameEvent;
import jp.raohmaru.game.starorchestra.ui.buttons.GlowButton;
import jp.raohmaru.game.starorchestra.utils.StarUtil;

public class MessageLayer extends AbstractLayer
{
	protected var	_msg :TextField;
	public static const CLOSE_BUTTON :uint = 1,
						CONTINUE_BUTTON :uint = 2,
						NEXT_BUTTON :uint = 4,
						REPLAY_BUTTON :uint = 8,
						EXIT_BUTTON :uint = 16;
						
				
	public function set message(value :String) :void
	{
		_msg.htmlText = value;
		_msg.height = _msg.textHeight + 5;
	}
	
	public function set buttons(flags :uint) :void
	{
		var arr :Array = [];
		
		if((flags & CLOSE_BUTTON)		> 0) arr.push( ["close",		"close_bot"] );
		if((flags & CONTINUE_BUTTON)	> 0) arr.push( ["continue",		"continue_bot"] );
		if((flags & NEXT_BUTTON)		> 0) arr.push( ["next song",	"next_bot"] );
		if((flags & REPLAY_BUTTON)		> 0) arr.push( ["replay",		"replay_bot"] );
		if((flags & EXIT_BUTTON)		> 0) arr.push( ["exit",			"exit_bot"] );
		
		var bot :GlowButton,
			len :int = Math.max(arr.length, _bots.length),
			y :Number = _msg.y + _msg.height + 50;
		for(var i :int=0; i<len; i++) 
		{
			if(i < arr.length)
			{
				if(i < _bots.length)
				{
					bot = _bots[i];
					bot.label = arr[i][0];
					bot.name = arr[i][1];
				}
				else
				{
					bot = createButton( arr[i][0], arr[i][1], 0, actions );
				}
				
				_content.addChild(bot);
				bot.y = y + GlowButton.HEIGHT*i;
				if(i == arr.length-1)
					bot.y += 33;
			}
			else if(i < _bots.length && _bots[i].parent)
				_content.removeChild( _bots[i] );
		}
		fit();
	}
	
	
	public function MessageLayer(core :GameCore)
	{
		super(core, Layers.MESSAGE);
	}
	
	override protected function init() :void
	{
		super.init();
		
		title = "message";
		
		_msg = StarUtil.createTextField(" ", 20, 0xFFFFFF, 400);
		_msg.x = -200;
		_msg.y = -40;
		_msg.multiline = true;
		_msg.wordWrap = true;
		addContent( _msg );
		
		addContent( createButton( "close", "close_bot", 0, actions ) );
	}
	
	protected function actions(e :MouseEvent) :void
	{
		if(e.target.name == "exit_bot")
			_core.event.gameEvent(GameEvent.GAME_EXIT);
		else
			_core.layers.close(_id);
	}
}
}