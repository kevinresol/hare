package hare.impl.flixel.display.lighting;

import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Kevin
 */
class CircularLight extends FlxSprite
{
	/**
	 * Constructor
	 * @param	radius	radius of the circle
	 * @param	color	color of the mask
	 */
	public function new(radius:Float, colors:Array<UInt>, alphas:Array<Dynamic>, ratios:Array<Dynamic>) 
	{
		super();		
		
		drawCircle(radius, colors, alphas, ratios);		
	}
	
	public function drawCircle(radius:Float, colors:Array<UInt>, alphas:Array<Dynamic>, ratios:Array<Dynamic>) 
	{		
		var diameter = Std.int(radius * 2);
		makeGraphic(diameter, diameter, 0, true);
		
		var s = FlxSpriteUtil.flashGfxSprite;
		var g = FlxSpriteUtil.flashGfx;
		
		var m = new Matrix();
		g.clear();
		#if !html5
		m.createGradientBox(radius, radius, 0, -radius / 2, -radius / 2);		
		g.beginGradientFill(RADIAL, colors, alphas, ratios, m);
		#end
		
		g.drawCircle(0, 0, radius);		
		
		var rect = new Rectangle( -0, -0, s.height, s.width);
		pixels.draw(s, new Matrix(1, 0, 0, 1, s.width / 2, s.height / 2), null, null, rect);
		
	}
}