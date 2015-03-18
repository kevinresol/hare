package rpg.map;
import rpg.Engine;
import rpg.map.GameMap.TileLayer;
import rpg.map.TiledTileset;

/**
 * ...
 * @author Kevin
 */
class MapManager
{
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
		
		var map = new GameMap(tiledMap.width, tiledMap.height, tiledMap.tileWidth, tiledMap.tileHeight);
		var tiledLayer = tiledMap.layers.filter(function(l) return l.properties.get("type") == "floor")[0];
		
		map.floor = createTileLayer(tiledLayer);
		
		// Display the map
		impl.displayMap(map);
		
		// TODO: Display objects
		
		// TODO: Load and run scripts
		var objectLayer = tiledMap.objectGroups[0];
		for (o in objectLayer.objects)
		{
			switch(o.type)
			{
				case "event":
					engine.eventManager.register(o.id);
				default:
			}
		}
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