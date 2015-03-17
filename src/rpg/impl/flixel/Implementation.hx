package rpg.impl.flixel;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import rpg.IHost;

/**
 * ...
 * @author Kevin
 */
class Implementation implements IImplementation
{
	public var assetManager:IAssetManager;
	public var host:IHost;
	
	private var state:FlxState;

	public function new(state:FlxState) 
	{
		assetManager = new AssetManager();
		host = new Host();
		
		this.state = state;
	}
	
	public function displayMap(imagePath:String, tileArray:Array<Int>, gridWidth:Int, gridHeight:Int, tileWidth:Int, tileHeight:Int):Void
	{
		var tilemap = new FlxTilemap();
		tilemap.loadMapFromArray(tileArray, gridWidth, gridHeight, imagePath, tileWidth, tileHeight);
		state.add(tilemap);
	}
}