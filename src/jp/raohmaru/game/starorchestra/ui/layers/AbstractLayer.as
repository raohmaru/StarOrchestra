package jp.raohmaru.game.starorchestra.ui.layers
{
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

import jp.raohmaru.game.starorchestra.core.GameCore;
import jp.raohmaru.game.starorchestra.core.GameSprite;
import jp.raohmaru.game.starorchestra.core.libs.Symbols;
import jp.raohmaru.game.starorchestra.enums.Sounds;
import jp.raohmaru.game.starorchestra.model.Options;
import jp.raohmaru.game.starorchestra.ui.buttons.GlowButton;
import jp.raohmaru.game.starorchestra.utils.StarUtil;
import jp.raohmaru.motion.Paprika;
import jp.raohmaru.motion.easing.Quad;

public class AbstractLayer extends GameSprite
{
	protected var	_title :TextField,
					_bots :Vector.<GlowButton>,
					_close_bot :Sprite,
					_bg :Sprite,
					_content :Sprite,
					_id :uint;

	public function get id() :uint
	{
		return _id;
	}

	public function set title(value :String) :void
	{
		_title.text = value;
	}

	public function get opened() :Boolean
	{
		return _view.stage != null;
	}


	public function AbstractLayer(core:GameCore, id :uint)
	{
		super(core);
		_id = id;
		init();
	}

	public function show() :void
	{
		_view.scaleX = _view.scaleY = .9;
		Paprika.add(_view, .3, {alpha:1, scale:1}, Quad.easeOut).onComplete = function() :void
		{
			_view.mouseChildren = true;
		};
	}

	public function hide() :void
	{
		_view.mouseChildren = false;
		Paprika.add(_view, .2, {alpha:0, scale:.9}, Quad.easeIn);
	}

	public function fit() :void
	{
		var h :Number = _content.height,
			w :Number = _content.width;

		_content.y = -h/2;

		_bg.width = w+60;
		_bg.height = h+40;

		_close_bot.x = (w+60)/2;
		_close_bot.y = -(h+40)/2;
	}



	protected function init() :void
	{
		_view.x = Options.STAGE_WIDTH/2;
		_view.y = Options.STAGE_HEIGHT/2;
		_view.alpha = 0;

		_content = new Sprite();
		_view.addChild(_content);

		_title = StarUtil.createTextField("title", 28, 0x32beff, -1, "center");
		_title.x = -_title.width/2;
		_title.y = -10;
		_content.addChild(_title);

		_bots = new Vector.<GlowButton>;

		_close_bot = new Symbols.LAYER_CLOSE();
		_close_bot.addEventListener(MouseEvent.MOUSE_DOWN, closeBotHandler);
		_close_bot.addEventListener(MouseEvent.MOUSE_UP, closeBotHandler);
		_close_bot.addEventListener(MouseEvent.MOUSE_OUT, closeBotHandler);
		_view.addChildAt(_close_bot, 1);

		_bg = StarUtil.drawRoundRect(500, 400, 2.0, 0x32beff, 0, .9);
		_view.addChildAt(_bg, 0);
	}

	protected function addContent(obj :DisplayObject) :void
	{
		obj.y += _title.y + _title.height + 60;
		_content.addChild( obj );
	}

	protected function createButton(label :String, name :String, y :Number, callback :Function, x :Number=0) :GlowButton
	{
		var bot :GlowButton = StarUtil.createButton( label, name, x, y, callback);
			bot.alpha = 1;
			bot.visible = true;

		_bots.push(bot);
		return bot;
	}

	protected function closeBotHandler(e :MouseEvent):void
	{
		if(e.type == MouseEvent.MOUSE_DOWN)
		{
			_core.layers.close(_id);
			_core.sound.play(Sounds.BUTTON_CLICK5);
			Paprika.add(_close_bot, .1, {alpha:.4});
		}
		else
		{
			if(_close_bot.alpha < 1)
				Paprika.add(_close_bot, .1, {alpha:1});
		}
	}
}
}