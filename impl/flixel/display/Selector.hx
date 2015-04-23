package impl.flixel.display;

import flixel.tweens.FlxTween;
import rpg.geom.Rectangle;

/**
 * ...
 * @author Kevin
 */
class Selector extends Slice9Sprite
{
	private var tween:FlxTween;
	
	public function new(x:Float = 0, y:Float = 0, width:Int = 64, height:Int = 64) 
	{
		super("assets/images/system/system.png", new Rectangle(64, 64, 32, 32), new Rectangle(64 + 8, 64 + 8, 16, 16));
		setPosition(x, y);
		setGraphicSize(width, height);		
		tween = FlxTween.num(1, 0.4, 0.7, { type:FlxTween.PINGPONG }, function(v) alpha = v);

		visible = false;
	}
	
	override function set_visible(v:Bool):Bool 
	{
		tween.active = v;
		return super.set_visible(v);
	}
	
}