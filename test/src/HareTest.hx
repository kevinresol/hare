package ;
import hare.Engine;

/**
 * ...
 * @author Kevin
 */
class HareTest
{
	public var engine:Engine;
	public static var lastCalledCommand:Command = new Command();
}

class Command
{
	public var list:Array<{func:Dynamic, args:Array<Dynamic>}>;
	
	public function new()
	{
		list = [];
	}
	
	public function set(func:Dynamic, args:Array<Dynamic>)
	{
		list.push({func:func, args:args});
	}
	
	public function clear():Void
	{
		while (list.length > 0) list.pop();
	}
	
	public function is(func:Dynamic, args:Array<Dynamic>)
	{
		var c = list.shift();
		
		
		if (!compare(c.func, func)) 
		{
			trace("not same func");
			return false;
		}
		
		if (!compare(c.args, args)) 
		{
			trace("not same args");
			return false;
		}
		
		return true;
	}
	
	/**
	 * Compare two values recursively
	 * @param	a
	 * @param	b
	 * @return
	 */
	private function compare(a:Dynamic, b:Dynamic):Bool
	{
		if (Std.is(a, String))
		{
			if (a != b)
			{
				trace('a:$a b:$b are different values');
				return false;
			}
			return true;
		}
		if (Std.is(a, Array))
		{
			if (!Std.is(b, Array)) 
			{
				trace('b is not array');
				return false;
			}
			if (a.length != b.length) 
			{
				trace('array length different');
				return false;
			}
			for (i in 0...a.length)
			{
				if (!compare(a[i], b[i])) 
				{
					trace('array value different at index:$i');
					return false;
				}
			}
			return true;
		}
		else if (Reflect.isFunction(a))
		{
			if (!Reflect.isFunction(b)) 
			{
				trace('b is not function');
				return false;
			}
			if (!Reflect.compareMethods(a, b))
			{
				trace('a b are not the same function');
				return false;
			}
			return true;
		}
		else if (Reflect.isObject(a))
		{
			
			if (Type.getClass(a) != null)
			{
				if (Type.getClass(a) != Type.getClass(b))
				{
					trace('a b are not same class');
					return false;
				}
				for (f in Type.getInstanceFields(Type.getClass(a)))
				{
					if (!compare(Reflect.getProperty(a, f), Reflect.getProperty(b, f)))
					{
						trace('class fields $f not the same');
						return false;
					}
				}
			}
			else
			{
				if (!Reflect.isObject(b)) 
				{
					trace('b is not object');
					return false;
				}
				
				for (field in Reflect.fields(a))
				{
					if (!Reflect.hasField(b, field)) 
					{
						trace('a is $a, but b is $b which does not have field:$field');
						return false;
					}
					if (!compare(Reflect.field(a, field), Reflect.field(b, field))) 
					{
						trace('field:$field value different');
						return false;
					}
				}
			}
			return true;
		}
		else 
		{
			if (a != b)
			{
				trace('a:$a b:$b are different values');
				return false;
			}
			return true;
		}
	}
}