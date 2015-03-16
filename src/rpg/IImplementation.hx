package rpg;

/**
 * @author Kevin
 */

interface IImplementation 
{
	var assetManager:IAssetManager;
	
	function displayMap(imagePath:String, tileArray:Array<Int>, gridWidth:Int, gridHeight:Int, tileWidth:Int, tileHeight:Int):Void;
}