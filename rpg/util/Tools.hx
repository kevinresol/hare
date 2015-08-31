package rpg.util;

import rpg.Engine;

/**
 * ...
 * @author Kevin
 */
class Tools
{
	public static var engine:Engine;
	
	public static inline function checkCallback(callback:Dynamic):Void
	{
		#if debug
		if (callback == null) engine.log("callback cannot be null", LError);
		#end
	}
	
}