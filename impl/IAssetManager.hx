package impl ;
import rpg.config.Config;

/**
 * @author Kevin
 */

interface IAssetManager 
{
	function getConfig():String;
	
	function getSaveData(id:Int):String;
	function setSaveData(id:Int, data:String):Void;
	function getNumberOfSaves():Int;
	
	function getMapData(id:Int):String;
	function getScript(mapId:Int, eventId:Int):String;
}
