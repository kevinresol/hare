package impl.flixel.display;

import rpg.geom.Rectangle;

/**
 * ...
 * @author Kevin
 */
class Selector extends Slice9Sprite
{

	public function new(x:Float = 0, y:Float = 0, width:Int = 64, height:Int = 64) 
	{
		super("assets/images/system/system.png", new Rectangle(64, 64, 32, 32), new Rectangle(64 + 8, 64 + 8, 16, 16));
		setPosition(x, y);
		setGraphicSize(width, height);
		visible = false;
	}
	
}