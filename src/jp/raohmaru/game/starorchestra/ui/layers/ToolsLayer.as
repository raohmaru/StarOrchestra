package jp.raohmaru.game.starorchestra.ui.layers
{
import flash.events.MouseEvent;

import jp.raohmaru.game.starorchestra.core.GameCore;
import jp.raohmaru.game.starorchestra.enums.Layers;
import jp.raohmaru.game.starorchestra.events.GameEvent;
import jp.raohmaru.game.starorchestra.ui.buttons.GlowButton;
import jp.raohmaru.game.starorchestra.utils.StarUtil;

public final class ToolsLayer extends AbstractLayer
{
	public function ToolsLayer(core :GameCore)
	{
		super(core, Layers.TOOLS);
	}
	
	override protected function init() :void
	{
		super.init();
		
		title = "tools";
		
		addContent( createButton( "continue",	"continue_bot",	0,						actions ) );
		addContent( createButton( "options",	"options_bot",	GlowButton.HEIGHT,		actions ) );	
		addContent( createButton( "exit",		"exit_bot",		GlowButton.HEIGHT*2+33,	actions ) );
		
		fit();
	}
	
	private function actions(e :MouseEvent) :void
	{
		if(e.target.name == "continue_bot")
			_core.layers.close(_id);
			
		else if(e.target.name == "options_bot")
			_core.layers.open(Layers.OPTIONS);
			
		else if(e.target.name == "exit_bot")
			_core.event.gameEvent(GameEvent.GAME_EXIT);
	}
}
}