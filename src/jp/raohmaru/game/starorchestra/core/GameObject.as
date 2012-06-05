package jp.raohmaru.game.starorchestra.core
{
import flash.events.EventDispatcher;

public class GameObject extends EventDispatcher
{
	protected var _core :GameCore;
	
	public function GameObject(core :GameCore)
	{
		_core = core;
	}
}
}