package rpg;
import rpg.event.EventManager;
import rpg.map.MapManager;

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
	
	public function new(impl:IImplementation, entryPointMapId:String) 
	{
		this.impl = impl;
		
		mapManager = new MapManager(this);
		eventManager = new EventManager(this);
		
		
		mapManager.loadMap(entryPointMapId);
		
	}
	
	public function update(elapsed:Float):Void
	{
		eventManager.update(elapsed);
	}
}