package jp.raohmaru.game.starorchestra.utils
{
import flash.utils.Dictionary;

public class Cache
{
	private static var _dict :Dictionary = new Dictionary();
	
	public function init() :void
	{
		_dict = new Dictionary();
	}
	
	public static function retrieve(id :String) :*
	{
		return _dict[id];
	}
	
	public static function drop(id :String, obj :*) :void
	{
		_dict[id] = obj;
	}
}
}