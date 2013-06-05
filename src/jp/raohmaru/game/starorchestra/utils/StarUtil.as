package jp.raohmaru.game.starorchestra.utils
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.*;
import flash.utils.Dictionary;

import jp.raohmaru.game.starorchestra.core.libs.Filters;
import jp.raohmaru.game.starorchestra.core.libs.FontLib;
import jp.raohmaru.game.starorchestra.ui.buttons.GlowButton;

public final class StarUtil
{
	public static var TFMT :TextFormat = new TextFormat("Neuropol");


	public static function createButton(label :String, name :String, x :Number, y :Number, callback :Function) :GlowButton
	{
		var bot :GlowButton = new GlowButton(label);
			bot.name = name;
			bot.x = x;
			bot.y = y;
			bot.addEventListener(MouseEvent.MOUSE_UP, callback);

		return bot;
	}

	public static function createTextField(text :String=" ", size :Number=28, color :uint=0xFFFFFF, width :Number=-1, autoSize :String="none", align :String="center") :TextField
	{
		FontLib.NEUROPOL;

		TFMT.size = size;
		TFMT.color = color;
		TFMT.align = align;

		var tf :TextField = new TextField();
			tf.embedFonts = true;
			tf.selectable = false;
			tf.defaultTextFormat = TFMT;
			if(width > -1)
				tf.width = width;
			tf.autoSize = autoSize;
			tf.htmlText = text;
			if(width == -1)
				tf.width = tf.textWidth;
			tf.height = tf.textHeight;
			//tf.border = true;
			//tf.borderColor = 0xFFCC00;

		return tf;
	}

	public static function drawRoundRect(width: Number, height :Number, thickness:Number=2.0, lineColor:uint=0xFFFFFF, fillColor :uint=0, fillAlpha :Number=0.0, radius :Number=20.0) :Sprite
	{
		var id :String = arguments.join("-"),
			cont :Sprite = new Sprite();

		// Relleno
		var shape :Shape = new Shape();
			shape.graphics.beginFill(fillColor, fillAlpha);
			shape.graphics.drawRoundRect(-width/2, -height/2, width, height, radius*2);
			shape.graphics.endFill();
		cont.addChild(shape);

		// Borde efecto glow
		shape = new Shape();
		shape.graphics.lineStyle(thickness+6, lineColor, 0.3, false, "none");
		shape.graphics.drawRoundRect(-width/2, -height/2, width, height, radius*2);
		cont.addChild(shape);

		// Borde
		shape = new Shape();
		shape.graphics.lineStyle(thickness, lineColor, 1, false, "none");
		shape.graphics.drawRoundRect(-width/2, -height/2, width, height, radius*2);
		cont.addChild(shape);

		return cont;
	}
}
}