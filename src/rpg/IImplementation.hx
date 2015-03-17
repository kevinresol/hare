package rpg;

/**
 * @author Kevin
 */

interface IImplementation 
{
	var assetManager:IAssetManager;
	var host:IHost;
	
	function displayMap(imagePath:String, tileArray:Array<Int>, gridWidth:Int, gridHeight:Int, tileWidth:Int, tileHeight:Int):Void;
}