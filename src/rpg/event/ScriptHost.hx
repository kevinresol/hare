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
		engine.disableMovement();
		engine.impl.showText(function()
		{
			engine.enableMovement(); 
			engine.eventManager.resume();
		}, message);
	}
	
	public function teleportPlayer(mapId:String, x:Int, y:Int):Void
	{
		engine.disableMovement();
		
		var teleport = function()
		{
			engine.impl.teleportPlayer(function() 
			{ 
				engine.enableMovement(); 
				engine.interactionManager.playerPosition.set(x, y); 
				engine.eventManager.resume(); 
			}, x, y);
		};
		
		if(mapId != engine.currentMap.name)
		{
			var map = engine.mapManager.getMap(mapId);
			engine.mapManager.currentMap = map;
			engine.impl.switchMap(teleport, map);
		}
		else
			teleport();
	}
}