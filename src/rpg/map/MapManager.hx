package rpg.map;
import rpg.Engine;
import rpg.geom.Direction;
import rpg.map.GameMap.TileLayer;

/**
 * ...
 * @author Kevin
 */
class MapManager
{
	public var currentMap:GameMap;
	
	private var engine:Engine;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
	}
	
	public function loadMap(id:String):Void
	{
		var impl = engine.impl;
		var mapData = impl.assetManager.getMapData(id);
		var tiledMap = new TiledMap(Xml.parse(mapData));
		
		var map = new GameMap(id, tiledMap.width, tiledMap.height, tiledMap.tileWidth, tiledMap.tileHeight);
		var tiledLayer = tiledMap.getLayer("Walls and Floor");
		map.floor = createTileLayer(tiledLayer);
		
		map.passage = createPassageMap(tiledMap.getLayer("Passage"));
		
		for (o in tiledMap.getObjectGroup("Below").objects)
		{
			if (o.type == "event")
			{
				map.addEvent(o.id, "", Std.int(o.x / tiledMap.tileWidth), Std.int(o.y / tiledMap.tileHeight) -1 );
			}
		}
		
		// Display the map
		currentMap = map;
		impl.currentMap = map;
		
		// TODO: Display objects
		
		// TODO: Load and run scripts
		var objectLayer = tiledMap.objectGroups[0];
		for (o in objectLayer.objects)
		{
			switch(o.type)
			{
				case "event":
					//engine.eventManager.register(o.id);
				default:
			}
		}
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
					case 1: Direction.TOP | Direction.LEFT;
					case 2: Direction.TOP | Direction.RIGHT;
					case 3: Direction.LEFT | Direction.BOTTOM;
					case 4: Direction.RIGHT | Direction.BOTTOM;
					case 5: Direction.LEFT | Direction.RIGHT;
					case 6: Direction.TOP | Direction.BOTTOM;
					case 7: Direction.ALL;
					case 8: Direction.NONE;
					case 9: Direction.TOP;
					case 10: Direction.LEFT;
					case 11: Direction.BOTTOM;
					case 12: Direction.RIGHT;
					case 13: ~Direction.BOTTOM;
					case 14: ~Direction.TOP;
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
}