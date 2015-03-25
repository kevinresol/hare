package impl ;

/**
 * @author Kevin
 */

interface IAssetManager 
{
	function getSaveData(id:Int):String;
	function setSaveData(id:Int, data:String):Void;
	
	function getMapData(id:Int):String;
	function getScript(mapId:Int, eventId:Int):String;
	function getMusic(musicId:Int):String;
	function getSound(soundId:Int):String;
	function getSystemSound(soundId:Int):String;
}