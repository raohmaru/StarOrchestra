package jp.raohmaru.game.starorchestra.model
{
public final class Note
{
	private var _id :int,
				_tempo :int,
				_follow :Boolean = true;
	
	public function get id() :int
	{
		return _id;
	}
	
	public function get tempo() :int
	{
		return _tempo;
	}
	
	public function get follow() :Boolean
	{
		return _follow;
	}
	
	
	
	public function Note(data :XML, tempo:int)
	{
		update(data, tempo);
	}
	
	public function update(data :XML, tempo:int) :void
	{
		_id = data.@id;
		_tempo = (data.@tempo.length() > 0) ? data.@tempo*1000 : tempo;
		_follow = (data.@follow == "false") ? false : true;
	}
	
	public function toString() :String
	{
		return "[Note id="+_id+" tempo="+_tempo+" follow="+_follow+"]";
	}
}
}