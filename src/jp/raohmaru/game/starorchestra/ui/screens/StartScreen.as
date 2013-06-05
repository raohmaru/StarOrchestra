package jp.raohmaru.game.starorchestra.ui.screens
{
import flash.desktop.NativeApplication;
import flash.events.MouseEvent;
import flash.text.TextField;

import jp.raohmaru.game.starorchestra.controller.SoundMan;
import jp.raohmaru.game.starorchestra.core.GameCore;
import jp.raohmaru.game.starorchestra.core.GameSprite;
import jp.raohmaru.game.starorchestra.enums.Sounds;
import jp.raohmaru.game.starorchestra.events.GameEvent;
import jp.raohmaru.game.starorchestra.model.Options;
import jp.raohmaru.game.starorchestra.ui.buttons.GlowButton;
import jp.raohmaru.game.starorchestra.utils.StarUtil;
import jp.raohmaru.motion.Paprika;

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

		var tf :TextField = StarUtil.createTextField("Tap screen to start");
			tf.x = Options.STAGE_WIDTH/2 - tf.width/2;
			tf.y = Options.STAGE_HEIGHT - 100;
			tf.alpha = 0;
		_view.addChild(tf);
		Paprika.add(tf, .3, {alpha:.8}, null, 1);

		_core.canvas.addEventListener(MouseEvent.MOUSE_UP, onTapScreen);
	}

	private function onTapScreen(e :MouseEvent) :void
	{
		SoundMan.self.play(Sounds.BUTTON_CLICK4);
		_core.canvas.removeEventListener(MouseEvent.MOUSE_UP, onTapScreen);
		dispatchEvent(new GameEvent(GameEvent.GO_HOME));
	}
}
}