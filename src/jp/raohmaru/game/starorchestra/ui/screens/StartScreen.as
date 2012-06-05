package jp.raohmaru.game.starorchestra.ui.screens
{
import flash.desktop.NativeApplication;
import flash.events.MouseEvent;

import jp.raohmaru.game.starorchestra.core.GameCore;
import jp.raohmaru.game.starorchestra.core.GameSprite;
import jp.raohmaru.game.starorchestra.events.GameEvent;
import jp.raohmaru.game.starorchestra.model.Options;
import jp.raohmaru.game.starorchestra.ui.buttons.GlowButton;

public final class StartScreen extends AbsctractScreen
{
	public function StartScreen(core :GameCore)
	{
		super(core);
	}
	
	override protected function init() :void
	{
		super.init();
		
		var x :Number = Options.STAGE_WIDTH/2,
			y :Number = 520,
			w :Number = GlowButton.WIDTH/2;
		
		createButton("start",	"start_bot",	x-w-10, y,	actions);
		createButton("quit",	"quit_bot",		x+w+10, y,	actions);
	}
	
	private function actions(e :MouseEvent) :void
	{
		if(e.target.name == "start_bot")
			dispatchEvent(new GameEvent(GameEvent.GO_HOME));
		
		else
			NativeApplication.nativeApplication.exit();
	}
}
}