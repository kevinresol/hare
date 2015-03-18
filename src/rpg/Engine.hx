package rpg;
import impl.IImplementation;
import rpg.event.EventManager;
import rpg.input.InputManager;
import rpg.map.MapManager;
import rpg.movement.MovementManager;

/**
 * ...
 * @author Kevin
 */
@:allow(rpg)
class Engine
{
	private var impl:IImplementation;
	private var mapManager:MapManager;
	private var eventManager:EventManager;
	private var inputManager:InputManager;
	private var movementManager:MovementManager;
	
	public function new(impl:IImplementation, entryPointMapId:String) 
	{
		this.impl = impl;
		impl.engine = this;
		
		mapManager = new MapManager(this);
		eventManager = new EventManager(this);
		inputManager = new InputManager(this);
		movementManager = new MovementManager(this);
		
		mapManager.loadMap(entryPointMapId);
		impl.addPlayer(5, 5);
		
	}
	
	public function update(elapsed:Float):Void
	{
		eventManager.update(elapsed);
		movementManager.update(elapsed);
	}
	
	public inline function press(key:InputKey):Void
	{
		inputManager.press(key);
	}
	
	public inline function release(key:InputKey):Void
	{
		inputManager.release(key);
	}
}

