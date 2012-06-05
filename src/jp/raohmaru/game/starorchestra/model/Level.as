package jp.raohmaru.game.starorchestra.model
{
	import jp.raohmaru.game.starorchestra.core.libs.Symbols;

public final class Level
{
	private var	_data :XML,
				_len :uint,
				_map :Map,
				_idx :uint,
				_title :String,
				_tempo :int,
				_time_plus :int,
				_star :String,
				_sound :String,
				_color :uint;
				
	public function get index() :uint
	{
		return _idx;
	}	
	public function set index(value :uint) :void
	{
		_idx = (value < _len) ? value : _len-1;
		_map.update(_data.map[_idx]);
	}
	
	public function get numMaps() :uint
	{
		return _len;
	}
	
	public function get title() :String
	{
		return _title;
	}
	
	public function get tempo() :int
	{
		return _tempo;
	}
	
	public function get timePlus() :int
	{
		return _time_plus;
	}
	
	public function get star() :String
	{
		return _star;
	}
	
	public function get sound() :String
	{
		return _sound;
	}
	
	public function get color() :uint
	{
		return _color;
	}
	
	
	public function Level(data :XML)
	{		
		//update(data);
	}
	
	public function update(data :XML) :void
	{
		_data = data;
		_len = _data.map.length();
		_idx = 0;
		_title = _data.@title;
		_tempo = (_data.@tempo.length() > 0) ? _data.@tempo*1000 : Options.NOTE_TEMPO;
		_time_plus = (_data.@time_plus.length() > 0) ? _data.@time_plus*1000 : Options.TIME_PLUS;
		_star = (_data.@star.length() > 0) ? _data.@star : "STAR0";
		_sound = (_data.@sound.length() > 0) ? _data.@sound : "Star0";
		_color = (_data.@color.length() > 0) ? _data.@color : 0xFFCC00;
		
		if(_map == null)
			_map = new Map(this, _data.map[_idx]);
		else
			_map.update(_data.map[_idx]);
	}
	
	public function currentMap() :Map
	{
		return _map;
	}
	
	public function nextMap() :Boolean
	{
		_idx++;
		if(_idx < _len)
			_map.update(_data.map[_idx]);
		
		return (_idx < _len);
	}
}
}