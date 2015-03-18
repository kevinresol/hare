package rpg.map;

/**
 * ...
 * @author Kevin
 */
class GameMap
{
	public var name:String;
	
	public var gridWidth:Int;
	public var gridHeight:Int;
	
	public var tileWidth:Int;
	public var tileHeight:Int;
	
	public var passage:Array<Int>;
	public var floor:TileLayer;
	
	public var events:Array<Event>;
	
	public var player:Dynamic;
	

	public function new(name, gridWidth, gridHeight, tileWidth, tileHeight) 
	{
		this.name = name;
		this.gridWidth = gridWidth;
		this.gridHeight = gridHeight;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		
		events = [];
	}
	
	public function addEvent(id, imageSource, x, y, trigger):Void
	{
		events.push(new Event(id, imageSource, x, y, trigger));
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

class ObjectLayer
{
	public var imageSource:String;
	public var tileId:Int;
	
	public function new(imageSource, tileId)
	{
		this.imageSource = imageSource;
		this.tileId = tileId;
	}
}

class Event
{
	public var imageSource:String;
	public var id:Int;
	public var x:Int;
	public var y:Int;
	public var trigger:EventTrigger;
	
	public function new(id, imageSource, x, y, trigger)
	{
		this.id = id;
		this.imageSource = imageSource;
		this.x = x;
		this.y = y;
		this.trigger = trigger;
	}
	
	public function toString():String
	{
		return 'Event $id: ($x, $y)';
	}
}

enum EventTrigger
{
	EAction;
	EPlayerTouch;
	EEventTouch;
	EAutorun;
	EParallel;
}