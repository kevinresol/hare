package impl ;

/**
 * @author Kevin
 */

interface IAssetManager 
{
	function getConfig():String;
	
	function getSaveData(id:Int):String;
	function setSaveData(id:Int, data:String):Void;
	
	function getMapData(id:Int):String;
	function getScript(mapId:Int, eventId:Int):String;
}