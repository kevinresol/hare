package rpg.map;
import rpg.Engine;
import rpg.geom.Direction;
import rpg.map.GameMap.EventTrigger;
import rpg.map.GameMap.GameMapObjectDisplayType;
import rpg.map.GameMap.TileLayer;

using Lambda;
/**
 * ...
 * @author Kevin
 */
class MapManager
{
	public var currentMap(default, set):GameMap;
	
	private var engine:Engine;
	private var maps:Map<Int, GameMap>;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
		maps = new Map();
	}
	
	public function getMap(id:Int):GameMap
	{
		if (maps[id] == null)
		{
			var mapData = engine.assetManager.getMapData(id);
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
				imageSource = StringTools.replace(imageSource, "../..", "assets");
				var x = Std.int(o.x / tiledMap.tileWidth);
				var y = Std.int(o.y / tiledMap.tileHeight) - 1;
				
				var layer = 2.0;
				if (o.custom.contains("layer"))
					layer = Std.parseFloat(o.custom.layer);
					
				// note: "[object]" is the default value if the name is not specified in Tiled
				var displayType:GameMapObjectDisplayType =  o.name == "[object]" ? DTile(imageSource, tileset.fromGid(o.gid)) : DActor(engine.config.getImageSourceOfActor(o.name), 1);
				
				switch (o.type)
				{
					case "event":
						var trigger:EventTrigger = switch (o.custom.trigger) 
						{
							case "action": EAction;
							case "bump": EBump;
							case "overlap": EOverlap;
							case "nearby": ENearby;
							case "autorun": EAutorun;
							case "parallel": EParallel;
							default: EAction;
						}
						
						map.addEvent(o.id, x, y, layer, trigger, displayType);
					
					case "player":
						var imageSource = engine.config.getImageSourceOfActor(o.name);
						// TODO: image.index;
						map.addPlayer(o.name, imageSource, x, y);
					
					default:
						map.addObject(o.id, x, y, layer, displayType);
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
				imageSource = StringTools.replace(imageSource, "../..", "assets"); // TODO remove hardcode path?
				
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