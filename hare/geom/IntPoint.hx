package hare.geom;

/**
 * ...
 * @author Kevin
 */
class IntPoint
{
	public var x:Int;
	public var y:Int;
	
	public function new(x:Int = 0, y:Int = 0)
	{
		this.x = x;
		this.y = y;
	}
	
	public inline function set(x:Int = 0, y:Int = 0)
	{
		this.x = x;
		this.y = y;
	}
}