package jp.raohmaru.game.starorchestra.events 
{
import flash.events.Event;

public final class GameEvent extends Event 
{
	public static const GAME_START :String = "gameStart";
	public static const GAME_END :String = "gameEnd";
	public static const GAME_EXIT :String = "gameExit";
	public static const MAP_START :String = "mapStart";
	public static const MAP_COMPLETE :String = "mapComplete";
	public static const MAP_ERROR :String = "mapError";
	public static const GO_HOME :String = "goToHome";
	public static const LEVEL_SELECT :String = "levelSelect";
	
	public function GameEvent(type :String)
	{		
		super(type, bubbles, cancelable);
	}
	
	override public function toString() :String 
	{
		return formatToString("GameEvent", "type", "bubbles", "cancelable");
	}
	
	override public function clone() :Event
	{
		return new GameEvent(type);
	}
}
}