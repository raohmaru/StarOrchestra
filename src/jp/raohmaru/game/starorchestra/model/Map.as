package jp.raohmaru.game.starorchestra.model
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

public final class Map
{
	private var	_onwer :Level,
				_stars :Vector.<Point>,
				_rows :uint,
				_cols :uint,
				_title :String,
				_error :int,
				_board :Rectangle,
				_seq :Vector.<Note>,
				_seq_depot :Vector.<Note>,
				_time :int,
				_start_msg :Message,
				_end_msg :Message,
				_award :String,
				_bonus :int;
	
	public function get rows() :uint
	{
		return _rows;
	}
	
	public function get cols() :uint
	{
		return _cols;
	}
	
	public function get title() :String
	{
		return _title;
	}
	
	public function get error() :int
	{
		return _error;
	}
				
	public function get stars() :Vector.<Point> 
	{
		return _stars;
	}
	
	public function get sequence() :Vector.<Note> 
	{
		return _seq;
	}
	
	public function get time() :Number 
	{
		return _time;
	}
	
	public function get startMsg() :Message
	{
		return _start_msg;
	}
	
	public function get endMsg() :Message
	{
		return _end_msg;
	}
	
	public function get award() :String
	{
		return _award;
	}
	
	public function get bonus() :int
	{
		return _bonus;
	}
	
	
	
	public function Map(onwer :Level, data :XML)
	{
		_onwer = onwer;
		init();
		update(data);
	}
	
	private function init() :void
	{
		_stars = new Vector.<Point>;
		_board = new Rectangle();
		_seq = new Vector.<Note>;
		_seq_depot = new Vector.<Note>;
		_start_msg = new Message();
		_end_msg = new Message();
	}
	
	public function update(data :XML) :void
	{
		_rows = data.@rows;
		_cols = data.@cols;
		_title = data.@title;
		_error = (data.@error.length() > 0) ? data.@error*1000 : Options.ERROR_TIME_SUBSTRACT;
		_award = (data.award.length() > 0) ? data.award : null;
		_bonus = (data.@map_phis.length() > 0) ? data.@map_phis : 0;
		
		// Board build		
		if(_cols == 1)
		{
			_board.width = 0;
			_board.x = (Options.STAGE_WIDTH) / 2;
		}
		else if(data.@width.length() > 0)
		{
			_board.width = data.@width;
			_board.x = (Options.STAGE_WIDTH-_board.width) / 2;
		}
		else
		{
			_board.x = Options.BOARD.x;
			_board.width = Options.BOARD.width;
		}
		
		if(_rows == 1)
		{
			_board.height = 0;
			_board.y = (Options.STAGE_HEIGHT) / 2;
		}
		else if(data.@height.length() > 0)
		{
			_board.height = data.@height;
			_board.y = (Options.STAGE_HEIGHT-_board.height) / 2;
		}
		else
		{
			_board.y = Options.BOARD.y;
			_board.height = Options.BOARD.height;
		}
		
		// Array of points
		_stars.length = 0;
		
		var dx :int = _board.width/(_cols - 1),
			dy :int = _board.height/(_rows - 1),
			j :int;
		
		for(var i :int=0; i<_rows; i++)
		{
			for(j=0; j<_cols; j++)
			{
				_stars.push( new Point(dx * j + _board.x, dy * i + _board.y) );
			}
		}		
		
		// Sequence build
		_seq.length = 0;
		_time = _onwer.timePlus;
		
		var seq :XMLList = data.sequence.note,
			note :Note,
			tempo :int = (data.sequence.@tempo.length() > 0) ? data.sequence.@tempo*1000 : _onwer.tempo;
		for(i=0; i<seq.length(); i++)
		{
			if(i < _seq_depot.length)
			{
				note = _seq_depot[i];
				note.update(seq[i], tempo);
			}
			else
			{
				note = new Note(seq[i], tempo);
				_seq_depot.push( note );
			}
			
			_seq.push( note );
			_time += note.tempo;
		}
		
		if(data.sequence.@time.length() > 0)
			_time = data.sequence.@time * 1000;
		
		// Mensajes al iniciar y/o finalizar el mapa
		_start_msg.data = data.message_start;
		_end_msg.data	= data.message_end;
	}
}
}