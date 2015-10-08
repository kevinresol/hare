package hare.map;
import hare.Engine;
import hare.event.Event.EventTrigger;
import hare.Events;
import hare.geom.Direction;
import hare.impl.Assets;
import hare.map.GameMap.GameMapObjectDisplayType;
import hare.map.GameMap.TileLayer;

using Lambda;
/**
 * ...
 * @author Kevin
 */
class MapManager
{
	public var currentMap(default, set):GameMap;
	
	@inject
	public  var engine:Engine;
	
	private var maps:Map<Int, GameMap>;
	
	@inject 
	public var assets:Assets;
	
	public function new() 
	{
		maps = new Map();
	}
	
	public function getMap(id:Int):GameMap
	{
		if (maps[id] == null)
		{
			var mapData = assets.getMapData(id);
			var tiledMap = new TiledMap(Xml.parse(mapData));
			
			var map = new GameMap(id, tiledMap.width, tiledMap.height, tiledMap.tileWidth, tiledMap.tileHeight);
			map.floor = createTileLayer(tiledMap.getLayer("Walls and Floor"));
			map.above = createTileLayer(tiledMap.getLayer("Above"));
			map.below = createTileLayer(tiledMap.getLayer("Below"));
			map.passage = createPassageMap(tiledMap.getLayer("Passage"));
			
			for (o in tiledMap.getObjectGroup("Objects").objects)
			{
				var tileset = tiledMap.getGidOwner(o.gid);
				var imageSource = tileset.imageSource;
				imageSource = StringTools.replace(imageSource, "..", "assets");
				var x = Std.int(o.x / tiledMap.tileWidth);
				var y = Std.int(o.y / tiledMap.tileHeight) - 1;
				
				var layer = 2.0;
				if (o.custom.contains("layer"))
					layer = Std.parseFloat(o.custom.layer);
					
				// note: "[object]" is the default value if the name is not specified in Tiled
				var displayType:GameMapObjectDisplayType =  if (o.name == "[object]") 
					DTile(imageSource, tileset.fromGid(o.gid)) 
				else 
				{ 
					var i = engine.config.getCharacterImage(o.name);
					DCharacter(engine.imageManager.getImage(ICharacter(i.source), i.index)); 
				}
				
				var visible = (!o.custom.contains("visible") || o.custom.visible != "false");
				
				switch (o.type)
				{
					case "event":
						map.addEvent(o.id, x, y, layer, engine.eventManager.getEvent(o.id, id), displayType, visible);
					
					case "player":
						map.addPlayer(o.name, engine.config.getCharacterImage(o.name), x, y);
					
					default:
						map.addObject(o.id, x, y, layer, displayType, visible);
				}
			}
			maps[id] = map;
		}
		return maps[id];
	}
	
	private function createPassageMap(layer:TiledLayer):Array<Int>
	{
		var result = [];
		for (tile in layer.tiles)
		{
			if (tile == null)
				result.push(Direction.NONE);
			else
			{
				var tilesetId = layer.map.getGidOwner(tile.tileID).fromGid(tile.tileID);
				var passage = switch (tilesetId) 
				{
					case 1: Direction.UP | Direction.LEFT;
					case 2: Direction.UP | Direction.RIGHT;
					case 3: Direction.LEFT | Direction.DOWN;
					case 4: Direction.RIGHT | Direction.DOWN;
					case 5: Direction.LEFT | Direction.RIGHT;
					case 6: Direction.UP | Direction.DOWN;
					case 7: Direction.ALL;
					case 8: Direction.NONE;
					case 9: Direction.UP;
					case 10: Direction.LEFT;
					case 11: Direction.DOWN;
					case 12: Direction.RIGHT;
					case 13: ~Direction.DOWN;
					case 14: ~Direction.UP;
					case 15: ~Direction.RIGHT;
					case 16: ~Direction.LEFT;
					default: 0;
				}
				result.push(passage);
			}
		}
		return result;
	}
	
	private function createTileLayer(layer:TiledLayer):TileLayer
	{
		var result = new TileLayer();
		
		var tilesets = [];
		for (i in 0...layer.tiles.length)
		{
			var tile = layer.tiles[i];
			if (tile != null)
			{
				var tileset = layer.map.getGidOwner(tile.tileID);
				var imageSource = tileset.imageSource;
				imageSource = StringTools.replace(imageSource, "..", "assets"); // TODO remove hardcode path?
				
				if (!result.data.exists(imageSource))
					result.data.set(imageSource, [for(j in 0...layer.tiles.length) 0]);
				
				var tiles = result.data[imageSource];
				tiles[i] = tileset.fromGid(tile.tileID);
			}
		}
		
		return result;
	}
	
	private function set_currentMap(v:GameMap):GameMap
	{
		if (currentMap == v) return v;
		currentMap = v;
		Events.dispatch("map.switched", v);
		return v;
		
	}
}