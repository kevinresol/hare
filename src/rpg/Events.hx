package rpg;

/**
 * ...
 * @author Kevin
 */
class Events
{
	private static var listeners:Map<Int, Listener> = new Map();
	private static var counter:Int = 0;
	private static var dispatching:Bool = false;
	
	private static var pendingEnable:Array<Int> = [];
	
	private static var commands = [
		
	];
		
	private static var events = [
		"key.justPressed",
		"key.justReleased",
	];
	
	public static function on(name:String, listener:Dynamic->Void):Int
	{
		#if debug // check if the event name exists
			if (!valid(name)) throw 'Event "$name" does not exist';
		#end
		
		counter ++;
		listeners.set(counter, new Listener(name, listener));
		return counter;
	}
	
	public static function off(id:Int):Void
	{
		listeners[id].destroy();
		listeners.remove(id);
	}
	
	public static function disable(id:Int):Void
	{
		listeners[id].enabled = false;
		pendingEnable.remove(id);
	}
	
	public static function enable(id:Int):Void
	{
		if (dispatching)
			pendingEnable.push(id);
		else
			listeners[id].enabled = true;
	}
	
	public static function dispatch(name:String, ?data:Dynamic):Void
	{
		#if debug // check if the event name exists
			if (!valid(name)) throw 'Event "$name" does not exist';
		#end
		
		dispatching = true;
		for (listener in listeners)
		{
			if (listener != null && listener.enabled && listener.name == name)
				listener.listener(data);
		}
		dispatching = false;
		
		while (pendingEnable.length > 0)
			listeners[pendingEnable.pop()].enabled = true;
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
