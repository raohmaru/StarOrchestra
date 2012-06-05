package jp.raohmaru.game.starorchestra.model
{
public final class User
{
	private var _data :XMLList,
				_alias :String,
				_phis :uint,
				_level :uint,
				_map :uint,
				_max_level :uint,
				_max_map :uint,
				_awards :XMLList,
				_game_complete :Boolean;
				
	public function get alias() :String
	{
		return _alias;
	}
	public function set alias(value :String) :void
	{
		_alias = value;
		_data.alias = value;
	}
	
	public function get phis() :uint
	{
		return _phis;
	}
	public function set phis(value :uint) :void
	{
		_phis = value;
		_data.phis = value;
	}
	
	public function get level() :uint
	{
		return _level;
	}
	public function set level(value :uint) :void
	{
		_level = value;
		_data.current = value + "," + _map;
	}
	
	public function get map() :uint
	{
		return _map;
	}
	public function set map(value :uint) :void
	{
		_map = value;
		_data.current = _level + "," + value;
	}
	
	public function get maxLevel() :uint
	{
		return _max_level;
	}
	public function set maxLevel(value :uint) :void
	{
		_max_level = value;
		_data.max = value + "," + _max_map;
	}
	
	public function get maxMap() :uint
	{
		return _max_map;
	}
	public function set maxMap(value :uint) :void
	{
		_max_map = value;
		_data.max = _max_level + "," + value;
	}
	
	public function get awards() :XMLList
	{
		return _awards.copy();
	}
	
	public function get gameComplete() :Boolean
	{
		return _game_complete;
	}
	public function set gameComplete(value :Boolean) :void
	{
		_game_complete = value;
		_data.gameComplete = _game_complete;
	}
	
	
	
	public function User(xml :XMLList)
	{
		_data = xml;
		init();
	}
	
	public function destroy() :void
	{
		_data = null;
		_awards = null;
	}
	
	public function hasAward(type :String) :Boolean
	{
		return (_awards.child(type).length() > 0);
	}
	
	public function addAward(type :String) :void
	{
		_awards.appendChild(<{type} />);
	}
	
	public function toString() : String
	{
		return _data.toXMLString();
	}
	
	private function init() :void
	{
		_alias	= _data.alias;
		_phis	= _data.phis;
		_awards = _data.awards;
		_game_complete = (_data.gameComplete.text() == "true");
		
		var arr :Array = _data.current.text().toString().split(",");
		_level	= arr[0];
		_map	= arr[1];
		
		arr = _data.max.text().toString().split(",");
		_max_level	= arr[0];
		_max_map	= arr[1];
	}
}
}