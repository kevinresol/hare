package rpg.event;
import rpg.Engine;

/**
 * ...
 * @author Kevin
 */
class ScriptHost
{
	private var engine:Engine;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
	}
	
	public function showText(message:String):Void
	{
		engine.interactionManager.disableMovement();
		engine.impl.showText(function()
		{
			engine.interactionManager.enableMovement(); 
			engine.eventManager.resume();
		}, message);
	}
	
	public function teleportPlayer(mapId:String, x:Int, y:Int, ?options:TeleportPlayerOptions):Void
	{
		if (options == null)
			options = {};
		
		engine.interactionManager.disableMovement();
		
		var map = engine.mapManager.getMap(mapId);
		engine.impl.teleportPlayer(function() 
		{ 
			engine.interactionManager.enableMovement(); 
			engine.mapManager.currentMap = map;
			engine.interactionManager.playerPosition.set(x, y);
			engine.eventManager.resume(); 
		}, map, x, y, options);
	}
}

typedef TeleportPlayerOptions =
{
	?facing:String,
}