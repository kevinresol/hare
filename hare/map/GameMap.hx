package hare.map;
import hare.event.Event;
import hare.geom.IntPoint;
import hare.image.Image;

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
	
	public function addPlayer(name, image, x, y):Void
	{
		player = new Player(name, image, x, y);
	}
	
	public function addEvent(id, x, y, layer, event, displayType, visible):Void
	{
		objects.push(new GameMapObject(id, x, y, layer, event, displayType, visible));
	}
	
	public function addObject(id, x, y, layer, displayType, visible):Void
	{
		objects.push(new GameMapObject(id, x, y, layer, null, displayType, visible));
	}
	
	public function getEventTrigger(id, ?page):EventTrigger
	{
		for (o in objects)
		{
			if (o.id == id && o.event != null) 
			{
				return if(page == null) o.event.currentPage.trigger
				else o.event.pages[page].trigger;
			}
		}
		return null;
	}
	
	public function getScript(id, ?page):String
	{
		for (o in objects)
		{
			if (o.id == id && o.event != null) 
			{
				return if(page == null) o.event.currentPage.script
				else o.event.pages[page].script;
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
	public var image:{source:String, index:Int};
	public var name:String;
	public var x:Int;
	public var y:Int;
	
	public function new(name, image, x, y)
	{
		this.name = name;
		this.image = image;
		this.x = x;
		this.y = y;
	}
}

class GameMapObject
{
	public var visible:Bool;
	public var id:Int;
	public var x:Int;
	public var y:Int;
	public var layer:Float;
	public var event:Event;
	public var displayType:GameMapObjectDisplayType;
	
	public function new(id, x, y, layer, event, displayType, visible)
	{
		this.id = id;
		this.x = x;
		this.y = y;
		this.layer = layer;
		this.event = event;
		this.displayType = displayType;
		this.visible = visible;
	}
	
	public function toString():String
	{
		return event == null ? 'Object $id: ($x, $y)' : 'Event $id: ($x, $y)';
	}
}

enum GameMapObjectDisplayType
{
	DTile(imageSource:String, tileId:Int);
	DCharacter(image:Image);
}
