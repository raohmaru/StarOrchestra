package jp.raohmaru.game.starorchestra.model
{
public final class Message
{
	private var _title :String;
	private var _text :String;
	
	public function get title() :String
	{
		return _title;
	}
	
	public function set title(value :String) :void
	{
		_title = value;
	}
	
	public function get text() :String
	{
		return _text;
	}
	
	public function set text(value :String) :void
	{
		_text = value;
	}
	
	public function set data(value :XMLList) :void
	{
		_title	= (value.title.length() > 0) ? value.title.text() : null;
		_text	= (value.text.length() > 0) ? value.text.text() : null;
	}
	
	public function Message(title :String=null, text :String=null)
	{
		_title = title;
		_text = text;
	}
	
	public function clone() :Message
	{
		return new Message(_title, _text);
	}
	
	public function toString() :String
	{
		return "[Message title=\""+_title+"\" text=\""+_text+"\"]";
	}
}
}