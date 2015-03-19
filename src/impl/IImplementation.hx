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

	function movePlayer(dx:Int, dy:Int):Void;
	function changePlayerFacing(dir:Int):Void;
	
	function showText(callback:Void->Void, message:String):Void;
	function switchMap(callback:Void->Void, map:GameMap):Void;
	function teleportPlayer(callback:Void->Void, x:Int, y:Int):Void;
}