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
	private var resume:Void->Void;
	private var resumeWithData:Dynamic->Void;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
		resume = function() engine.eventManager.resume();
		resumeWithData = function(data) engine.eventManager.resume(-1, data);
	}
	
	public function playBackgroundMusic(id:Int, volume:Float, pitch:Float):Void
	{
		engine.impl.playBackgroundMusic(id, volume, pitch);
	}
	
	public function showText(characterId:String, message:String, ?options:ShowTextOptions):Void
	{
		if (options == null)
			options = {};
		
		if (options.background == null)
			options.background = "normal";
			
		if (options.position == null)
			options.position = "bottom";
		
		engine.impl.showText(resume, characterId, message, options);
	}
	
	public function showChoices(prompt:String, choices:Array<ShowChoicesChoice>, ?options:ShowChoicesOptions)
	{
		if (options == null)
			options = {};
		
		if (options.background == null)
			options.background = "normal";
			
		if (options.position == null)
			options.position = "bottom";
		
		engine.impl.showChoices(resumeWithData, prompt, choices, options);
	}
	
	public function fadeOutScreen(ms:Int):Void
	{
		engine.impl.fadeOutScreen(ms);
	}
	
	public function fadeInScreen(ms:Int):Void
	{
		engine.impl.fadeInScreen(ms);
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
		engine.interactionManager.player.map = map;
		engine.interactionManager.player.position.set(x, y);
	}
	
	public function sleep(ms:Int):Void
	{
		engine.delayedCall(resume, ms);
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

typedef ShowChoicesOptions =
{>ShowTextOptions,
	
}

typedef TeleportPlayerOptions =
{
	?facing:String,
}