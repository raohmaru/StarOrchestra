package jp.raohmaru.game.starorchestra.controller
{
import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundTransform;
import flash.utils.Dictionary;

import jp.raohmaru.game.starorchestra.core.GameCore;
import jp.raohmaru.game.starorchestra.core.GameObject;
import jp.raohmaru.game.starorchestra.core.libs.SoundLib;
import jp.raohmaru.game.starorchestra.media.SoundFX;
import jp.raohmaru.game.starorchestra.media.filters.Pitch;
import jp.raohmaru.game.starorchestra.model.Map;

public final class SoundMan extends GameObject
{
	private const OFFSET :Number = 26.0;
	private var _dict :Dictionary,
				_effects :Vector.<SoundFX>,
				_stfm :SoundTransform;
	public static var self :SoundMan;
	
	public function get volume() :Number
	{
		return _stfm.volume;
	}
	
	public function set volume(value :Number) :void
	{
		_stfm.volume = value;
	}
	
	
	public function SoundMan(core :GameCore)
	{
		super(core);
		
		_dict = new Dictionary();
		_effects = new Vector.<SoundFX>;
		_stfm = new SoundTransform();
		
		self = this;		
	}
	
	public function play(sound :String, id :int=-1) :void
	{
		if(_stfm.volume == 0) return;
		
		if(_dict[sound] != null)
		{
			var snd :Sound = snd = _dict[sound];
		}
		else
		{
			var ClassRef :Class = SoundLib[sound];
			snd = new ClassRef() as Sound;
			_dict[sound] = snd;
		}
		
		if(id > -1)
		{
			var len :uint = _core.levels.currentLevel().currentMap().stars.length - 1,
				rate :Number = .5 + id / len;
			
			if(_effects.length > 0)
			{
				var sndfx :SoundFX = _effects.pop();
					sndfx.source = snd;
				Pitch(sndfx.filter).rate = rate;
			}
			else
			{
				sndfx = new SoundFX(snd, new Pitch(rate));
			}
			
			sndfx.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			sndfx.play(OFFSET, 0, _stfm);
		}
		else
		{
			snd.play(OFFSET, 0, _stfm);
		}	
	}
	
	private function soundCompleteHandler(e :Event) :void
	{
		e.target.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		_effects.push(e.target);
	}
}
}