package rpg;
import rpg.map.MapManager;

/**
 * ...
 * @author Kevin
 */
class Engine
{
	@:allow(rpg)
	private var impl:IImplementation;
	
	private var mapManager:MapManager;
	
	public function new(impl:IImplementation, entryPointMapId:String) 
	{
		this.impl = impl;
		
		mapManager = new MapManager(this);
		mapManager.loadMap(entryPointMapId);
	}
	
}