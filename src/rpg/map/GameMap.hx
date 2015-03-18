package rpg.map;

/**
 * ...
 * @author Kevin
 */
class GameMap
{
	public var gridWidth:Int;
	public var gridHeight:Int;
	
	public var tileWidth:Int;
	public var tileHeight:Int;
	
	public var passage:TileLayer;
	public var floor:TileLayer;
	
	public var player:Dynamic;
	
	public var objects:Array<Array<Object>>;

	public function new(gridWidth, gridHeight, tileWidth, tileHeight) 
	{
		this.gridWidth = gridWidth;
		this.gridHeight = gridHeight;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
	}
	
}

class TileLayer
{
	public var data:Map<String, Array<Int>>;
	
	public function new()
	{
		data = new Map();
	}
}

class Object
{
	public var imageSource:String;
	public var tileId:Int;
	
	public function new(imageSource, tileId)
	{
		this.imageSource = imageSource;
		this.tileId = tileId;
	}
}