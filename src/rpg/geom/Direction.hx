package rpg.geom;

/**
 * ...
 * @author Kevin
 */
class Direction
{
	public static inline var NONE:Int = 0;
	public static inline var TOP:Int = 1;
	public static inline var BOTTOM:Int = 2;
	public static inline var LEFT:Int = 4;
	public static inline var RIGHT:Int = 8;
	public static inline var ALL:Int = TOP | BOTTOM | LEFT | RIGHT;
}