package rpg.event;
import rpg.Engine;
import rpg.geom.Direction;
import rpg.movement.InteractionManager;

using Lambda;
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
	
	public function changeFacing(target:String, facing:String):Void
	{
		var t = switch (target) 
		{
			case "player": MPlayer;
			case "thisevent": MEvent(engine.eventManager.currentEvent);
			default: MPlayer;
		}
		
		engine.impl.changeObjectFacing(t, Direction.fromString(facing));
	}
	
	public function teleportPlayer(mapId:Int, x:Int, y:Int, ?options:TeleportPlayerOptions):Void
	{
		var map = engine.mapManager.getMap(mapId);
		engine.impl.teleportPlayer(map, x, y, options);
		engine.mapManager.currentMap = map;
		engine.interactionManager.player.map = map;
		engine.interactionManager.player.position.set(x, y);
		
		switch (options.facing) 
		{
			case FRetain: // do nothing
			default: engine.interactionManager.player.facing = Direction.fromString(options.facing);
		}
	}
	
	public function setMoveRoute(object:String, commands:Array<String>, force:Bool):Void
	{
		var type;
		var target;
		
		switch (object) 
		{
			case "player": 
				type = MPlayer;
				target = engine.interactionManager.player;
				
			case "thisevent":
				var id = engine.eventManager.currentEvent;
				type = MEvent(id);
				target = engine.interactionManager.objects.find(function(o) return Type.enumEq(type, o.type));
				
			case o if (o.indexOf("event") >= 0): 
				var id = Std.parseInt(o.split("event")[1]);
				type = MEvent(id);
				target = engine.interactionManager.objects.find(function(o) return Type.enumEq(type, o.type));
			
			default: 
				engine.log('unknown object for setMoveRoute: $object', LError);
				type = null;
				target = null;
		}
		
		var runNextCommand = null;
		runNextCommand = function()
		{
			if (commands.length > 0)
			{
				var commandText = commands.shift();
				var command = switch (commandText)
				{
					case "moveleft": CMove(-1, 0);
					case "moveright": CMove(1, 0);
					case "moveup": CMove(0, -1);
					case "movedown": CMove(0, 1);
					case "faceleft": CFace(Direction.LEFT);
					case "faceright": CFace(Direction.RIGHT);
					case "faceup": CFace(Direction.UP);
					case "facedown": CFace(Direction.DOWN);
					case "turnleft": CFace(Direction.turnLeft(target.facing));
					case "turnright": CFace(Direction.turnRight(target.facing));
					case "turnaround": CFace(Direction.turnAround(target.facing));
					case t if (t.indexOf("sleep") >= 0): CSleep(Std.parseInt(StringTools.replace(t, "sleep", "")));
						
					default: engine.log('unknown command for setMoveRoute: $commandText', LError); null;
				}
				
				switch(command)
				{
					case CMove(dx, dy):
						var dir = if (dx == 1) Direction.RIGHT else if (dx == -1) Direction.LEFT else if (dy == 1) Direction.DOWN else if (dy == -1) Direction.UP else 0;
						target.facing = dir;
						
						if (force || engine.interactionManager.checkPassage(type, dx, dy))
						{
							engine.impl.moveObject(function()
							{
								target.position.x += dx;
								target.position.y += dy;
								return runNextCommand();
							}, type, dx, dy, InteractionManager.MOVEMENT_SPEED);
							return true;
						}
						else
						{
							engine.impl.changeObjectFacing(type, dir);
							engine.delayedCall(runNextCommand, 1);
						}
						
					case CFace(dir):
						target.facing = dir;
						engine.impl.changeObjectFacing(type, dir);
						engine.delayedCall(runNextCommand, 1);
					
					case CSleep(ms):
						engine.delayedCall(runNextCommand, ms);
						
				}
				return false;
				
			}
			else
			{
				// no more commands to run, resume the lua script
				resume();
				return false;
			}
			
			return false;
		}
		
		runNextCommand();
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
		engine.delayedCall(resume , ms);
	}
	
	public function log(message:String):Void
	{
		engine.impl.log(message, LInfo);
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
	?facing:TeleportPlayerFacing,
}
@:enum
abstract TeleportPlayerFacing(String) from String to String
{
	var FUp = "up";
	var FDown = "down";
	var FRight = "right";
	var FLeft = "left";
	var FRetain = "retain";
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

enum SetMoveRouteCommand
{
	CMove(dx:Int, dy:Int);
	CFace(direction:Int);
	CSleep(ms:Int);
}
