package impl ;
import rpg.Engine;
import rpg.map.GameMap;

/**
 * @author Kevin
 */

interface IImplementation 
{
	var engine:Engine;
	var assetManager:IAssetManager;
	
	/* ====== Sync Functions ====== */
	function changePlayerFacing(dir:Int):Void;
	function log(message:String):Void;
	
	
	/* ====== Async Functions ====== */
	/**
	 * 
	 * @param	callback return true if continue moving (useful for determining the animation)
	 * @param	dx
	 * @param	dy
	 */
	function movePlayer(callback:Void->Bool, dx:Int, dy:Int):Void;
	function showText(callback:Void->Void, message:String):Void;
	function teleportPlayer(callback:Void->Void, map:GameMap, x:Int, y:Int):Void;
}