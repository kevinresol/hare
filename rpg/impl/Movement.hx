package rpg.impl;
import rpg.event.ScriptHost.TeleportPlayerOptions;
import rpg.map.GameMap;
import rpg.movement.InteractionManager.MovableObjectType;

/**
 * ...
 * @author Kevin
 */
class Movement extends Module
{

	public function new(impl) 
	{
		super(impl);
	}
	
	
	public function changeObjectFacing(type:MovableObjectType, dir:Int):Void
	{
		
	}

	public function teleportPlayer(map:GameMap, x:Int, y:Int, options:TeleportPlayerOptions):Void
	{
		
	}
	/**
	 * Move an object
	 * @param	callback 	should be called by the implementation when the move is finished, will return true if the player continue moving (useful for determining the animation)
	 * @param	type		
	 * @param	dx
	 * @param	dy
	 * @param	speed 		in tiles/sec
	 */
	public function moveObject(callback:Void->Bool, type:MovableObjectType, dx:Int, dy:Int, speed:Float):Void
	{
		
	}
}