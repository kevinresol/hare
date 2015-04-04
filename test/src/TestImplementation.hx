package ;
import impl.IImplementation;
import rpg.Engine;
import rpg.event.ScriptHost.InputNumberOptions;
import rpg.event.ScriptHost.ShowChoicesChoice;
import rpg.event.ScriptHost.ShowChoicesOptions;
import rpg.event.ScriptHost.ShowTextOptions;
import rpg.event.ScriptHost.TeleportPlayerOptions;
import rpg.map.GameMap;
import rpg.movement.InteractionManager.MovableObjectType;

/**
 * ...
 * @author Kevin
 */
class TestImplementation implements IImplementation
{
	
	public var engine:Engine;
	public var assetManager:TestAssetManager;
	
	public var lastCalledCommand:Command;

	public function new() 
	{
		assetManager = new TestAssetManager();
		lastCalledCommand = new Command();
	}
	
	public function changeObjectFacing(type:MovableObjectType, dir:Int):Void
	{
		
	}
	
	public function log(message:String):Void 
	{
		
	}
	
	public function moveObject(callback:Void->Bool, type:MovableObjectType, dx:Int, dy:Int, speed:Float):Void
	{
		callback();
	}
	
	public function showText(callback:Void->Void, characterId:String, message:String, options:ShowTextOptions):Void 
	{
		lastCalledCommand.set(Macro.getCurrentFunction(), [characterId, message, options]);
		callback();
	}
	
	public function showChoices(callback:Int->Void, prompt:String, choices:Array<ShowChoicesChoice>, options:ShowChoicesOptions):Void 
	{
		lastCalledCommand.set(Macro.getCurrentFunction(), [prompt, choices, options]);
		callback(1);
	}
	
	public function showMainMenu(startGameCallback:Void->Void, loadGameCallback:Void->Void):Void 
	{
		
	}
	
	public function hideMainMenu():Void 
	{
		
	}
	
	public function showSaveScreen(saveGameCallback:Int->Void, cancelCallback:Void->Void):Void 
	{
		
	}
	
	public function hideSaveScreen():Void 
	{
		
	}
	
	public function showLoadScreen(loadGameCallback:Int->Void, cancelCallback:Void->Void):Void 
	{
		
	}
	
	public function hideLoadScreen():Void 
	{
		
	}
	
	public function teleportPlayer(map:GameMap, x:Int, y:Int, options:TeleportPlayerOptions):Void 
	{
		lastCalledCommand.set(teleportPlayer, [map, x, y, options]);
	}
	
	public function playSound(id:Int, volume:Float, pitch:Float):Void 
	{
		lastCalledCommand.set(Macro.getCurrentFunction(), [id, volume, pitch]);
	}
	
	public function playBackgroundMusic(id:Int, volume:Float, pitch:Float):Void 
	{
		lastCalledCommand.set(Macro.getCurrentFunction(), [id, volume, pitch]);
	}
	
	public function playSystemSound(id:Int, volume:Float):Void
	{
	
	}
	
	public function saveBackgroundMusic():Void 
	{
		lastCalledCommand.set(Macro.getCurrentFunction(), []);
	}
	
	public function restoreBackgroundMusic():Void 
	{
		lastCalledCommand.set(Macro.getCurrentFunction(), []);
	}
	
	public function fadeOutBackgroundMusic(ms:Int):Void 
	{
		lastCalledCommand.set(Macro.getCurrentFunction(), [ms]);
	}
	
	public  function fadeInBackgroundMusic(ms:Int):Void 
	{
		lastCalledCommand.set(Macro.getCurrentFunction(), [ms]);
	}
	
	public function fadeOutScreen(ms:Int):Void 
	{
		lastCalledCommand.set(Macro.getCurrentFunction(), [ms]);
	}
	
	public function fadeInScreen(ms:Int):Void 
	{
		lastCalledCommand.set(Macro.getCurrentFunction(), [ms]);
	}
	
	public function tintScreen(color:Int, ms:Int):Void 
	{
		
	}
	
	public function flashScreen(color:Int, strength:Int, ms:Int):Void 
	{
		
	}
	
	public function shakeScreen(power:Int, screen:Int, ms:Int):Void 
	{
		
	}
	
	public function showGameMenu(cancelCallback:Void->Void):Void 
	{
		
	}
	
	public function hideGameMenu():Void 
	{
		
	}
	
	public function inputNumber(callback:Int->Void, prompt:String, numDigit:Int, options:InputNumberOptions):Void 
	{
		
	}
	
	public function createPlayer(name:String, image:String):Void
	{
		
	}
	
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
			if (!Reflect.isObject(b)) 
			{
				trace('b is not object');
				return false;
			}
			for (field in Reflect.fields(a))
			{
				if (!Reflect.hasField(b, field)) 
				{
					trace('b does not have field:$field');
					return false;
				}
				if (!compare(Reflect.field(a, field), Reflect.field(b, field))) 
				{
					trace('field:$field value different');
					return false;
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