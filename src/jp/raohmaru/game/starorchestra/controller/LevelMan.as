package jp.raohmaru.game.starorchestra.controller
{
import jp.raohmaru.game.starorchestra.model.Level;

public final class LevelMan
{
	private var _data :XMLList,
				_len :uint,
				_idx :uint,
				_level :Level;
				
	public function get index() :uint
	{
		return _idx;
	}
	
	public function set index(value :uint) :void
	{
		_idx = (value < _len) ? value : _len-1;
		_level.update(_data[_idx]);
	}
	
	
	public function LevelMan(data :XMLList)
	{
		_data = data;
		_len = _data.length();
		_level = new Level(_data[_idx]);
	}
	
	public function currentLevel() :Level
	{		
		return _level;
	}
	
	public function next() :Boolean
	{
		if( _level.nextMap() == false )
		{
			_idx++;
			if(_idx < _len)
				_level.update(_data[_idx]);
			
			return (_idx < _len);
		}
		
		return true;
	}
}
}