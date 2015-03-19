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
	var host:IHost;

	function switchMap(map:GameMap):Void;
	function teleportPlayer(x:Int, y:Int):Void;
	function movePlayer(dx:Int, dy:Int):Void;
	function changePlayerFacing(dir:Int):Void;
}