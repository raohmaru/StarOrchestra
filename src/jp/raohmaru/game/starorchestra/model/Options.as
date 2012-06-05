package jp.raohmaru.game.starorchestra.model
{
import flash.display.Stage;
import flash.geom.Rectangle;

public final class Options
{
	public static var	CONFIG :XML,
						BOARD :Rectangle,
						SNAP_DTE :int,
						STAGE_WIDTH :int,
						STAGE_HEIGHT :int,
						NOTE_TEMPO :int,
						TIME_PLUS :int,
						ERROR_TIME_SUBSTRACT :int,
						MAP_PHIS :int,
						TIME_BONUS :int,
						BEAM_SIZE :Number = 6,
						CREATE_MODE :Boolean,
						DEBUG :Boolean = false;
						
	public static function setup(config :XML, stage :Stage) :void
	{
		CONFIG = config;
		
		BOARD = new Rectangle((stage.stageWidth-config.width)/2, (stage.stageHeight-config.height)/2, config.width, config.height);
		SNAP_DTE = config.snap_dte*config.snap_dte;
		STAGE_WIDTH = stage.stageWidth;
		STAGE_HEIGHT = stage.stageHeight;
		
		NOTE_TEMPO = config.note_tempo * 1000;
		TIME_PLUS = config.error_time_substract * 1000;
		ERROR_TIME_SUBSTRACT = config.error_time_substract * 1000;
		
		MAP_PHIS = config.map_phis;
		TIME_BONUS = config.time_bonus;
	}
}
}