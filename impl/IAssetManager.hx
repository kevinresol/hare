package impl ;
import rpg.config.Config;

/**
 * @author Kevin
 */

interface IAssetManager 
{
	function getConfig():String;
	
	function getSaveData():String;
	function setSaveData(data:String):Void;
	
	function getMapData(id:Int):String;
	function getScript(mapId:Int, eventId:Int):String;
	
	function getImageDimension(source:String):{width:Int, height:Int};
}
