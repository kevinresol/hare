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
	
	public var objects:Array<GameMapObject>;
	
	public var player:Player;
	

	public function new(id, gridWidth, gridHeight, tileWidth, tileHeight) 
	{
		this.id = id;
		this.gridWidth = gridWidth;
		this.gridHeight = gridHeight;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		
		objects = [];
	}
	
	public function addPlayer(name, imageSource, x, y):Void
	{
		player = new Player(name, imageSource, x, y);
	}
	
	public function addEvent(id, x, y, layer, trigger, displayType):Void
	{
		objects.push(new GameMapObject(id, x, y, layer, OEvent(id, trigger), displayType));
	}
	
	public function addObject(id, x, y, layer, displayType):Void
	{
		objects.push(new GameMapObject(id, x, y, layer, OObject(id), displayType));
	}
	
	public function getEventTrigger(id):EventTrigger
	{
		for (o in objects)
		{
			switch (o.type) 
			{
				case OEvent(eid, trigger):
					if(eid == id)
						return trigger;
				default:
			}
		}
		return null;
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


class Player
{
	public var imageSource:String;
	public var name:String;
	public var x:Int;
	public var y:Int;
	
	public function new(name, imageSource, x, y)
	{
		this.name = name;
		this.imageSource = imageSource;
		this.x = x;
		this.y = y;
	}
}

class GameMapObject
{
	public var id:Int;
	public var x:Int;
	public var y:Int;
	public var layer:Float;
	public var type:GameMapObjectType;
	public var displayType:GameMapObjectDisplayType;
	
	public function new(id, x, y, layer, type, displayType)
	{
		this.id = id;
		this.x = x;
		this.y = y;
		this.layer = layer;
		this.type = type;
		this.displayType = displayType;
	}
	
	public function toString():String
	{
		return switch (type) 
		{
			case OObject(id): 'Object $id: ($x, $y)';
			case OEvent(id, trigger):'Event $id: ($x, $y, $trigger)';
			default: "";
		}
	}
}

enum GameMapObjectType
{
	OPlayer;
	OObject(id:Int);
	OEvent(id:Int, trigger:EventTrigger);
}

enum GameMapObjectDisplayType
{
	DTile(imageSource:String, tileId:Int);
	DActor(imageSource:String, index:Int);
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