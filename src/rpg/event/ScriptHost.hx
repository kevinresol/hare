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
	
	public function showChoices(prompt:String, choices:Array<ShowChoicesChoice>, ?options:ShowChoicesOptions)
	{
		if (options == null)
			options = {};
		
		if (options.background == null)
			options.background = "normal";
			
		if (options.position == null)
			options.position = "bottom";
			
		engine.interactionManager.disableMovement();
		engine.impl.showChoices(function(selected) 
		{
			engine.interactionManager.enableMovement(); 
			engine.eventManager.resume(-1, selected);
		}, prompt, choices, options);
	}
	
	public function fadeOutScreen(ms:Int):Void
	{
		engine.impl.fadeOutScreen(ms);
		engine.eventManager.resume();
	}
	
	public function fadeInScreen(ms:Int):Void
	{
		engine.impl.fadeInScreen(ms);
		engine.eventManager.resume();
	}
	
	public function teleportPlayer(mapId:Int, x:Int, y:Int, ?options:TeleportPlayerOptions):Void
	{
		if (options == null)
			options = {};
			
		if (options.facing == null)
			options.facing = "unchanged";
		
		var map = engine.mapManager.getMap(mapId);
		engine.impl.teleportPlayer(map, x, y, options);
		engine.mapManager.currentMap = map;
		engine.interactionManager.playerPosition.set(x, y);
		engine.eventManager.resume();
	}
	
	public function sleep(ms:Int):Void
	{
		engine.interactionManager.disableMovement();
		engine.delayedCall(function()
		{
			engine.interactionManager.enableMovement(); 
			engine.eventManager.resume(); 
		}, ms);
	}
	
	public function log(message:String):Void
	{
		engine.impl.log(message);
		engine.eventManager.resume();
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

typedef ShowChoicesOptions =
{>ShowTextOptions,
	
}

typedef TeleportPlayerOptions =
{
	?facing:String,
}