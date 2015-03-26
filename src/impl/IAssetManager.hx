package impl ;
import rpg.config.Config;

/**
 * @author Kevin
 */

interface IAssetManager 
{
	function getConfig():Config;
	
	function getSaveData(id:Int):String;
	function setSaveData(id:Int, data:String):Void;
	
	function getMapData(id:Int):String;
	function getScript(mapId:Int, eventId:Int):String;
}
