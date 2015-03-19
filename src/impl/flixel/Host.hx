package impl.flixel ;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import haxe.Timer;
import impl.flixel.display.ShowTextPanel;
import impl.IHost;
import rpg.Events;
import rpg.input.InputManager.InputKey;
import rpg.map.GameMap;

/**
 * ...
 * @author Kevin
 */
class Host implements IHost
{
	private var state:FlxState;
	private var showTextPanel:ShowTextPanel;
	private var impl:Implementation;
	
	public function new(state:FlxState, impl:Implementation) 
	{
		this.state = state;
		this.impl = impl;
		
		showTextPanel = new ShowTextPanel();
	}
	
	public function showText(callback:Void->Void, message:String):Void 
	{
		showTextPanel.showText(message);
		state.add(showTextPanel);
		
		var id = 0;
		id = Events.on("key.justPressed", function(key:InputKey)
		{
			if (key == KEnter)
			{
				if (!showTextPanel.completed)
				{
					showTextPanel.showAll();
				}
				else
				{
					state.remove(showTextPanel);
					callback();
					Events.off(id);
				}
			}
			
		});
	}
	
	public function log(message:String):Void 
	{
		FlxG.log.add(message);
		trace(message);
	}
	
	
	public function teleportPlayer(callback:Void->Void, x:Int, y:Int):Void
	{
		impl.teleportPlayer(x, y);
		callback();
	}
	
}