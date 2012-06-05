package jp.raohmaru.game.starorchestra.media.filters
{
import flash.media.Sound;
import flash.utils.ByteArray;

public interface IFilter
{
	function apply(source :Sound, sample :ByteArray) :int;
	function reset(position: Number=0.0) :void;
}
}