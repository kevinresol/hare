package impl.flixel ;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import haxe.Timer;
import impl.IHost;
import rpg.Events;
import rpg.input.InputManager.InputKey;

/**
 * ...
 * @author Kevin
 */
class Host implements IHost
{
	private var state:FlxState;
	
	public function new(state:FlxState) 
	{
		this.state = state;
	}
	
	public function showText(callback:Void->Void, message:String):Void 
	{
		var text = new FlxText(0, 100, 200, message);
		state.add(text);
		
		var id = 0;
		id = Events.on("key.justPressed", function(key:InputKey)
		{
			if (key == KEnter)
			{
				state.remove(text);
				callback();
				Events.off(id);
			}
			
		});
	}
	
	public function log(message:String):Void 
	{
		FlxG.log.add(message);
		trace(message);
	}
	
}