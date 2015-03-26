package rpg.map;

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
	
	public var events:Array<Event>;
	public var objects:Array<Object>;
	
	public var player:Dynamic;
	

	public function new(id, gridWidth, gridHeight, tileWidth, tileHeight) 
	{
		this.id = id;
		this.gridWidth = gridWidth;
		this.gridHeight = gridHeight;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		
		events = [];
		objects = [];
	}
	
	public function addEvent(id, imageSource, tileId, x, y, trigger):Void
	{
		events.push(new Event(id, imageSource, tileId, x, y, trigger));
	}
	
	public function addObject(id, imageSource, tileId, x, y):Void
	{
		objects.push(new Object(id, imageSource, tileId, x, y));
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
	
	public function new(id, imageSource, tileId, x, y)
	{
		this.id = id;
		this.imageSource = imageSource;
		this.tileId = tileId;
		this.x = x;
		this.y = y;
	}
	
	public function toString():String
	{
		return 'Object $id: ($x, $y)';
	}
}

class Event extends Object
{
	public var trigger:EventTrigger;
	
	public function new(id, imageSource, tileId, x, y, trigger)
	{
		super(id, imageSource, tileId, x, y);
		this.trigger = trigger;
	}
	
	override public function toString():String
	{
		return 'Event $id: ($x, $y, $trigger)';
	}
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