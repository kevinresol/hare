package rpg;
import impl.IImplementation;
import rpg.event.EventManager;
import rpg.input.InputManager;
import rpg.map.GameMap;
import rpg.map.MapManager;
import rpg.movement.InteractionManager;

/**
 * ...
 * @author Kevin
 */
@:allow(rpg)
class Engine
{
	public var currentMap(get, never):GameMap;
	
	private var impl:IImplementation;
	private var mapManager:MapManager;
	private var eventManager:EventManager;
	private var inputManager:InputManager;
	private var interactionManager:InteractionManager;
	
	public function new(impl:IImplementation, entryPointMapId:String) 
	{
		this.impl = impl;
		impl.engine = this;
		
		mapManager = new MapManager(this);
		eventManager = new EventManager(this);
		inputManager = new InputManager(this);
		interactionManager = new InteractionManager(this);
		
		mapManager.loadMap(entryPointMapId);
		
		impl.teleportPlayer(5, 5);
		interactionManager.playerPosition.set(5, 5);
	}
	
	public function update(elapsed:Float):Void
	{
		eventManager.update(elapsed);
	}
	
	public inline function endMove(x:Int, y:Int):Bool
	{
		return interactionManager.endMove(x, y);
	}
	
	private inline function enableMovement():Void
	{
		interactionManager.enableMovement();
	}
	
	private inline function disableMovement():Void
	{
		interactionManager.disableMovement();
	}
	
	public inline function press(key:InputKey):Void
	{
		inputManager.press(key);
	}
	
	public inline function release(key:InputKey):Void
	{
		inputManager.release(key);
	}
	
	private inline function get_currentMap():GameMap
	{
		return mapManager.currentMap;
	}
}

