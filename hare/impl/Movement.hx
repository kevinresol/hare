package hare.impl;
import hare.event.ScriptHost;
import hare.movement.InteractionManager;
import hare.event.ScriptHost.TeleportPlayerOptions;
import hare.map.GameMap;
import hare.movement.InteractionManager.MovableObjectType;

/**
 * ...
 * @author Kevin
 */
class Movement extends Module
{

	public function new() 
	{
		super();
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