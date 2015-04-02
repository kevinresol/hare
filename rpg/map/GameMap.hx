package rpg.map;
import rpg.geom.IntPoint;

/**
 * ...
 * @author Kevin
 */
class GameMap
{
	public var id:Int;
	
	public var gridWidth:Int;
	public var gridHeight:Int;
	
	public var tileWidth:Int;
	public var tileHeight:Int;
	
	public var passage:Array<Int>;
	public var floor:TileLayer;
	public var above:TileLayer;
	public var below:TileLayer;
	
	public var objects:Array<Object>;
	
	public var player:IntPoint;
	

	public function new(id, gridWidth, gridHeight, tileWidth, tileHeight) 
	{
		this.id = id;
		this.gridWidth = gridWidth;
		this.gridHeight = gridHeight;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		
		objects = [];
	}
	
	public function addPlayer(x, y):Void
	{
		player = new IntPoint(x, y);
	}
	
	public function addEvent(id, imageSource, tileId, x, y, layer, trigger):Void
	{
		objects.push(new Object(id, imageSource, tileId, x, y, layer, OEvent(trigger)));
	}
	
	public function addObject(id, imageSource, tileId, x, y, layer):Void
	{
		objects.push(new Object(id, imageSource, tileId, x, y, layer, OObject));
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
	
	public var id:Int;
	public var x:Int;
	public var y:Int;
	public var layer:Float;
	public var type:ObjectType;
	
	public function new(id, imageSource, tileId, x, y, layer, type)
	{
		this.id = id;
		this.imageSource = imageSource;
		this.tileId = tileId;
		this.x = x;
		this.y = y;
		this.layer = layer;
		this.type = type;
	}
	
	public function toString():String
	{
		return switch (type) 
		{
			case OObject: 'Object $id: ($x, $y)';
			case OEvent(trigger):'Event $id: ($x, $y, $trigger)';
		}
	}
}

enum ObjectType
{
	OObject;
	OEvent(trigger:EventTrigger);
}

enum EventTrigger
{
	EAction;
	EBump;
	EOverlap;
	ENearby;
	EAutorun;
	EParallel;
}