package
{
import flash.display.Sprite;
import flash.display.StageQuality;
import flash.utils.ByteArray;

import jp.raohmaru.game.starorchestra.StarOrchestra;

// The following metadata specifies the size and properties of the canvas that
// this application should occupy on the BlackBerry PlayBook screen.
[SWF(width="1024", height="600", backgroundColor="#011527", frameRate="30")]

public class Main extends Sprite
{
	private var _game :StarOrchestra;

	[Embed(source="game-config.xml", mimeType="application/octet-stream")]
	private var XMLData :Class;

	public function Main()
	{
		init();
	}

	private function init() :void
	{
		//stage.quality = StageQuality.MEDIUM;

		var byteArray :ByteArray = new XMLData() as ByteArray;
		var xml :XML = new XML(byteArray.readUTFBytes(byteArray.length));

		_game = new StarOrchestra(this, xml);
		addChild(_game.view);
	}
}
}