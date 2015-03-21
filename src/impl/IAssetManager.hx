package impl ;

/**
 * @author Kevin
 */

interface IAssetManager 
{
	function getMapData(id:Int):String;
	function getScript(mapId:Int, eventId:Int):String;
	function getMusic(musicId:Int):String;
}