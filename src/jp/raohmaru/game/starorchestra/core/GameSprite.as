package jp.raohmaru.game.starorchestra.core
{
import flash.display.Sprite;

public class GameSprite extends GameObject
{
	protected var _view :Sprite;
	
	public function get view() :Sprite
	{
		return _view;
	}
	
	public function GameSprite(core:GameCore)
	{
		super(core);
		_view = new Sprite;
	}
}
}