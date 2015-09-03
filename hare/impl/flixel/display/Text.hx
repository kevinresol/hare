package hare.impl.flixel.display;

import flixel.text.FlxText;
import openfl.Assets;

/**
 * ...
 * @author Kevin
 */
class Text extends FlxText
{

	public function new(X:Float=0, Y:Float=0, FieldWidth:Float=0, ?Text:String, Size:Int=8, EmbeddedFont:Bool=true) 
	{
		super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
		
		font = Assets.getFont("assets/fonts/VL-PGothic-Regular.ttf").fontName;
		setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xff222222);
	}
}