package rpg.event;
import haxe.Timer;
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
	
	public function showText(characterId:String, message:String, ?options:ShowTextOptions):Void
	{
		if (options == null)
			options = {};
		
		if (options.background == null)
			options.background = "normal";
			
		if (options.position == null)
			options.position = "bottom";
		
		engine.interactionManager.disableMovement();
		engine.impl.showText(function()
		{
			engine.interactionManager.enableMovement(); 
			engine.eventManager.resume();
		}, characterId, message, options);
	}
	
	public function showChoices(prompt:String, choices:Array<ShowChoicesChoice>)
	{
		engine.interactionManager.disableMovement();
		engine.impl.showChoices(function(selected) 
		{
			engine.interactionManager.enableMovement(); 
			engine.eventManager.resume(-1, selected);
		}, prompt, choices);
		
	}
	
	public function teleportPlayer(mapId:String, x:Int, y:Int, ?options:TeleportPlayerOptions):Void
	{
		if (options == null)
			options = { };
			
		if (options.facing == null)
			options.facing = "unchanged";
		
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
	
	public function sleep(ms:Int):Void
	{
		engine.interactionManager.disableMovement();
		Timer.delay(function()
		{
			engine.interactionManager.enableMovement(); 
			engine.eventManager.resume(); 
		}, ms);
	}
	
	public function log(message:String):Void
	{
		engine.impl.log(message);
	}
}

typedef ShowChoicesChoice =
{
	text:String,
	?disabled:Bool,
	?hidden:Bool,
}

typedef ShowTextOptions =
{
	?position:String,
	?background:String,
}

typedef TeleportPlayerOptions =
{
	?facing:String,
}