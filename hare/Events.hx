package hare;

/**
 * ...
 * @author Kevin
 */
class Events
{
	private static var listeners:Map<Int, Listener> = new Map();
	private static var counter:Int = 0;
	private static var dispatching:Int = 0;
	
	private static var pendingEnable:Array<Int> = [];
	private static var skipList:Array<Listener> = [];
	
	private static var commands = [
		
	];
		
	private static var events = [
		"key.justPressed",
		"key.justReleased",
		
		"map.switched",
		
		"event.erased",
	];
	
	/**
	 * Register a event listener
	 * @param	name
	 * @param	listener
	 * @return	the id of the listener
	 */
	public static function on(name:String, listener:Dynamic->Void):Int
	{
		#if debug // check if the event name exists
			if (!valid(name)) throw 'Event "$name" does not exist';
		#end
		
		counter ++;
		listeners.set(counter, new Listener(name, listener));
		return counter;
	}
	
	/**
	 * Remove a event listener
	 * @param	id
	 */
	public static function off(id:Int):Void
	{
		listeners[id].destroy();
		listeners.remove(id);
	}
	
	/**
	 * Temporarily disable a event listener
	 * @param	id
	 */
	public static function disable(id:Int):Void
	{
		listeners[id].enabled = false;
		pendingEnable.remove(id);
	}
	
	/**
	 * Re-enable a disabled event listener
	 * @param	id
	 */
	public static function enable(id:Int):Void
	{
		if (dispatching > 0)
			pendingEnable.push(id);
		else
			listeners[id].enabled = true;
	}
	
	/**
	 * Skip the listener in current dispatch only
	 * @param	id
	 */
	public static function skip(id:Int):Void
	{
		if (dispatching > 0)
			skipList.push(listeners[id]);
	}
	
	/**
	 * Fire a event
	 * @param	name
	 * @param	data
	 */
	public static function dispatch(name:String, ?data:Dynamic):Void
	{
		#if debug // check if the event name exists
			if (!valid(name)) throw 'Event "$name" does not exist';
		#end
		
		dispatching++;
		for (listener in listeners)
		{
			if (listener != null && listener.enabled && listener.name == name && skipList.indexOf(listener) == -1)
				listener.listener(data);
		}
		dispatching--;
		
		while (pendingEnable.length > 0)
			listeners[pendingEnable.pop()].enabled = true;
			
		while (skipList.length > 0)
			skipList.pop();
	}
	
	private static function valid(name:String):Bool
	{
		for (n in commands)
		{
			if (name == n)
				return true;
		}
		
		for (n in events)
		{
			if (name == n)
				return true;
		}		
		return false;
	}
	
}

private class Listener
{
	public var name:String;
	public var listener:Dynamic->Void;
	public var enabled:Bool;
	
	public function new(name, listener)
	{
		this.name = name;
		this.listener = listener;
		enabled = true;
	}
	
	public function destroy():Void
	{
		listener = null;
	}
}
