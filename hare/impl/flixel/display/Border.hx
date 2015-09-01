package hare.impl.flixel.display;

import flixel.system.FlxAssets.FlxGraphicAsset;
import hare.geom.Rectangle;

/**
 * ...
 * @author Kevin
 */
class Border extends Slice9Sprite
{

	public function new(x:Float = 0, y:Float = 0, width:Int = 64, height:Int = 64)
	{
		super("assets/images/system/system.png", new Rectangle(64, 0, 64, 64), new Rectangle(64+16, 16, 32, 32), [4]);
		setPosition(x, y);
		setGraphicSize(width, height);
	}
	
}