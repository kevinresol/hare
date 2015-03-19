package impl ;
import rpg.map.GameMap;

/**
 * @author Kevin
 */

interface IHost 
{
	function showText(callback:Void->Void, message:String):Void;
	function log(message:String):Void;
	
	function teleportPlayer(callback:Void->Void, x:Int, y:Int):Void;
}