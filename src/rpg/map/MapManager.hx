package rpg.map;
import rpg.Engine;

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
		var map = new TiledMap(Xml.parse(mapData));
		var layer = map.layers[0];
		var tileset = map.getTileSet("Office_A4_Walls");
		
		// Display the map
		impl.displayMap("assets/images/Office_A4_Walls.png", layer.tileArray, layer.width, layer.height, tileset.tileWidth, tileset.tileHeight);
		
		// TODO: Display objects
		
		// TODO: Load and run scripts
		var objectLayer = map.objectGroups[0];
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
	
}