package impl ;
import rpg.Engine;
import rpg.geom.Point;
import rpg.map.GameMap;

/**
 * @author Kevin
 */

interface IImplementation 
{
	var engine:Engine;
	var assetManager:IAssetManager;
	var host:IHost;

	var currentMap(default, set):GameMap;
	var playerMovementDirection:Point;
	
	function addPlayer(x:Int, y:Int):Void;
}