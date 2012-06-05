package jp.raohmaru.game.starorchestra.ui
{
import flash.display.Bitmap;
import flash.display.Sprite;

public final class BG extends Sprite
{
	[Embed(source="../assets/bg.jpg")]
	private const BITMAP :Class;
	
	
	public function BG()
	{
		init();
	}
	
	private function init() :void
	{
		var bmp :Bitmap = new BITMAP() as Bitmap;
		addChild(bmp);
	}
}
}