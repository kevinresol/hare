package rpg;

/**
 * @author Kevin
 */

interface IAssetManager 
{
	function getMapData(id:String):String;
	function getScript(id:Int):String;
}