package rpg.event;
import rpg.Engine;
import rpg.geom.Direction;

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
	
	public function playSound(id:Int, volume:Float, pitch:Float):Void
	{
		engine.impl.playSound(id, volume, pitch);
	}
	
	public function playBackgroundMusic(id:Int, volume:Float, pitch:Float):Void
	{
		engine.impl.playBackgroundMusic(id, volume, pitch);
	}
	
	public function saveBackgroundMusic():Void
	{
		engine.impl.saveBackgroundMusic();
	}
	
	public function restoreBackgroundMusic():Void
	{
		engine.impl.restoreBackgroundMusic();
	}
	
	public function fadeOutBackgroundMusic(ms:Int):Void
	{
		engine.impl.fadeOutBackgroundMusic(ms);
	}
	
	public function fadeInBackgroundMusic(ms:Int):Void
	{
		engine.impl.fadeInBackgroundMusic(ms);
	}
	
	public function showText(characterId:String, message:String, ?options:ShowTextOptions):Void
	{
		if (options == null)
			options = {};
		
		if (options.background == null)
			options.background = BNormal;
			
		if (options.position == null)
			options.position = PBottom;
		
		engine.impl.showText(resume, characterId, message, options);
	}
	
	public function showChoices(prompt:String, choices:Array<ShowChoicesChoice>, ?options:ShowChoicesOptions)
	{
		if (options == null)
			options = {};
		
		if (options.background == null)
			options.background = BNormal;
			
		if (options.position == null)
			options.position = PBottom;
		
		engine.impl.showChoices(resumeWithData, prompt, choices, options);
	}
	
	public function inputNumber(prompt:String, numDigit:Int, ?options:InputNumberOptions):Void
	{
		if (options == null)
			options = {};
		
		if (options.background == null)
			options.background = BNormal;
			
		if (options.position == null)
			options.position = PBottom;
		
		engine.impl.inputNumber(resumeWithData, prompt, numDigit, options);
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
			options.facing = Direction.NONE;
		
		var map = engine.mapManager.getMap(mapId);
		engine.impl.teleportPlayer(map, x, y, options);
		engine.mapManager.currentMap = map;
		engine.interactionManager.player.map = map;
		engine.interactionManager.player.position.set(x, y);
		
		switch (options.facing) 
		{
			case Direction.DOWN | Direction.UP | Direction.LEFT | Direction.RIGHT:
				engine.interactionManager.player.facing = options.facing;
			default:
		}
	}
	
	public function setMoveRoute(object:String, route:Array<String>):Void
	{
		//object = OPlayer;
		
		var r = route.map(function(s) return switch (s)
		{
			case "left": {dx:-1, dy:0};
			case "right": {dx:1, dy:0};
			case "up": {dx:0, dy:-1};
			case "down": {dx:0, dy:1};
			default: throw 'unknown direction $s';
		});
		
		var player = engine.interactionManager.player;
		
		var move = null;
		move = function()
		{
			if (r.length > 0)
			{
				var next = r.shift();
				engine.impl.movePlayer(function()
				{
					player.position.x += next.dx;
					player.position.y += next.dy;
					return move();
				}, next.dx, next.dy);
				return true;
			}
			else
			{
				resume();
				return false;
			}
		}
		
		move();
	}
	
	public function changeItem(id:Int, quantity:Int):Void
	{
		engine.itemManager.changeItem(id, quantity);
	}
	
	public function getItem(id:Int):Int
	{
		return engine.itemManager.getItem(id);
	}
	
	public function sleep(ms:Int):Void
	{
		engine.delayedCall(resume, ms);
	}
	
	public function log(message:String):Void
	{
		engine.impl.log(message);
	}
	
	public function showSaveScreen():Void
	{
		engine.gameState = SSaveScreen;
	}
}

enum SetMoveRouteObject 
{
	OPlayer;
	OEvent(id:Int);
}

typedef ShowChoicesChoice =
{
	text:String,
	?disabled:Bool,
	?hidden:Bool,
}

typedef ShowTextOptions =
{
	?position:ShowTextPosition,
	?background:ShowTextBackground,
}

typedef ShowChoicesOptions =
{>ShowTextOptions,
	
}

typedef InputNumberOptions =
{>ShowTextOptions,
	
}

typedef TeleportPlayerOptions =
{
	?facing:Int,
}

@:enum
abstract ShowTextBackground(String)
{
	var BDimmed = "dimmed";
	var BTransparent = "transparent";
	var BNormal = "normal";
}

@:enum
abstract ShowTextPosition(String)
{
	var PTop = "top";
	var PCenter = "center";
	var PBottom = "bottom";
}