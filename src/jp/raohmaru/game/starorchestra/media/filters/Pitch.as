package jp.raohmaru.game.starorchestra.media.filters
{
import flash.events.SampleDataEvent;
import flash.media.Sound;
import flash.utils.ByteArray;

/**
 * Original code by Andre Michelle (andre.michelle@gmail.com)
 */
public class Pitch implements IFilter
{
	private var _target: ByteArray;	
	private var _position: Number;
	private var _rate: Number;
	private var _blockSize: int;
	private var _scaledBlockSize: Number;
	
	public function get rate(): Number
	{
		return _rate;
	}	
	public function set rate( value: Number ): void
	{
		if( value < 0.0 )
			value = 0;
		
		_rate = value;
		_scaledBlockSize = _blockSize * _rate;
	}
	
	public function get blockSize(): int
	{
		return _blockSize;
	}	
	public function set blockSize( value: int ): void
	{		
		_blockSize = value;
		_scaledBlockSize = _blockSize * _rate;
	}
	
	
	
	public function Pitch( rate :Number=1.0, blockSize :int=2048 )
	{
		_target = new ByteArray();		
		_position = 0.0;
		_blockSize = blockSize;
		this.rate = rate;
	}
	
	public function apply( source :Sound, sample :ByteArray ): int
	{
		//-- REUSE INSTEAD OF RECREATION
		_target.position = 0;
				
		var positionInt: int = _position;
		var alpha: Number = _position - positionInt;
		
		var positionTargetNum: Number = alpha;
		var positionTargetInt: int = -1;
		
		//-- COMPUTE NUMBER OF SAMPLES NEED TO PROCESS BLOCK (+2 FOR INTERPOLATION)
		var need: int = int( _scaledBlockSize+1 ) + 2;
		
		//-- EXTRACT SAMPLES
		var read: int = source.extract( _target, need, positionInt );
		
		var n: int = (read == need) ? _blockSize : read / _rate;		
		var i :int = n;
		
		var l0: Number;
		var r0: Number;
		var l1: Number;
		var r1: Number;
		
		while(i > 0)
		{
			//-- AVOID READING EQUAL SAMPLES, IF RATE < 1.0
			if( int( positionTargetNum ) != positionTargetInt )
			{
				positionTargetInt = positionTargetNum;
				
				//-- SET TARGET READ POSITION
				_target.position = positionTargetInt << 3;
				
				//-- READ TWO STEREO SAMPLES FOR LINEAR INTERPOLATION
				l0 = _target.readFloat();
				r0 = _target.readFloat();
				
				l1 = _target.readFloat();
				r1 = _target.readFloat();
			}
			
			//-- WRITE INTERPOLATED AMPLITUDES INTO STREAM
			sample.writeFloat( l0 + alpha * ( l1 - l0 ) );
			sample.writeFloat( r0 + alpha * ( r1 - r0 ) );
			
			//-- INCREASE TARGET POSITION
			positionTargetNum += _rate;
			
			//-- INCREASE FRACTION AND CLAMP BETWEEN 0 AND 1
			alpha += _rate;
			while( alpha >= 1.0 ) --alpha;
			
			--i;
		}
		
		//-- FILL REST OF STREAM WITH ZEROs
		if( n < _blockSize )
		{
			while( n < _blockSize )
			{
				sample.writeFloat( 0.0 );
				sample.writeFloat( 0.0 );
				
				++n;
			}
		}
		
		//-- INCREASE SOUND POSITION
		_position += _scaledBlockSize;
		
		return read;
	}
	
	public function reset(position: Number=0.0) :void
	{
		_position = position;
	}
}
}