package rpg;
import rpg.event.EventManager;
import rpg.input.InputManager;
import rpg.map.MapManager;

/**
 * ...
 * @author Kevin
 */
@:allow(rpg.map)
@:allow(rpg.event)
class Engine
{
	private var impl:IImplementation;
	private var mapManager:MapManager;
	private var eventManager:EventManager;
	private var inputManager:InputManager;
	
	public function new(impl:IImplementation, entryPointMapId:String) 
	{
		this.impl = impl;
		impl.engine = this;
		
		mapManager = new MapManager(this);
		eventManager = new EventManager(this);
		inputManager = new InputManager(this);
		
		mapManager.loadMap(entryPointMapId);
		
	}
	
	public function update(elapsed:Float):Void
	{
		eventManager.update(elapsed);
	}
	
	public inline function setKeyState(key:InputKey, state:InputState):Void
	{
		inputManager.setKeyState(key, state);
	}
	
	private function dispatch(id:String):Void
	{
		
	}
}