package jp.raohmaru.game.starorchestra.media
{
import flash.events.*;
import flash.media.Sound;
import flash.media.SoundTransform;

import jp.raohmaru.game.starorchestra.media.filters.IFilter;

public class SoundFX extends EventDispatcher
{
	private var	_source :Sound,
				_sound :Sound,
				_filter :IFilter;
				
	public function set source(value :Sound) :void
	{
		_source = value;
	}
	
	public function get filter() :IFilter
	{
		return _filter;
	}
	
	
	
	public function SoundFX(source :Sound, filter :IFilter)
	{
		_source = source;
		_filter = filter;		
		_sound = new Sound();
	}
	
	public function play(startTime :Number=0.0, loops:int=0, sndTransform :SoundTransform=null) :void
	{
		//_filter.reset( (startTime*_source.bytesTotal)/_source.length );
		_filter.reset( 0 );
		_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, sampleData);
		_sound.play(startTime, loops, sndTransform);
	}
	
	private function sampleData(e: SampleDataEvent): void
	{
		var r :int = _filter.apply(_source, e.data);
		if(r == 0)
		{
			_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, sampleData);
			//sound = null;
			_source = null;
			//_filter = null;
			dispatchEvent(new Event(Event.SOUND_COMPLETE));
		}
	}
}
}