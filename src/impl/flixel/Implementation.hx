package impl.flixel ;
import flixel.FlxG;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import rpg.Engine;
import rpg.IAssetManager;
import rpg.IHost;
import rpg.IImplementation;
import rpg.map.GameMap;

/**
 * ...
 * @author Kevin
 */
class Implementation implements IImplementation
{
	public var engine:Engine;
	public var assetManager:IAssetManager;
	public var host:IHost;
	
	private var state:FlxState;

	public function new(state:FlxState) 
	{
		assetManager = new AssetManager();
		host = new Host();
		
		this.state = state;
	}
	
	public function update(elapsed:Float):Void
	{
		engine.update(elapsed);
		
		var justPressed = FlxG.keys.justPressed;
		var justReleased = FlxG.keys.justReleased;
		
		if (justPressed.LEFT)
			engine.setKeyState(KLeft, SDown);
		if (justPressed.RIGHT)
			engine.setKeyState(KRight, SDown);
		if (justPressed.UP)
			engine.setKeyState(KUp, SDown);
		if (justPressed.DOWN)
			engine.setKeyState(KDown, SDown);
		if (justPressed.ENTER || justPressed.SPACE)
			engine.setKeyState(KEnter, SDown);
		
		if (justReleased.LEFT)
			engine.setKeyState(KLeft, SUp);
		if (justReleased.RIGHT)
			engine.setKeyState(KRight, SUp);
		if (justReleased.UP)
			engine.setKeyState(KUp, SUp);
		if (justReleased.DOWN)
			engine.setKeyState(KDown, SUp);
		if (justReleased.ENTER || justReleased.SPACE)
			engine.setKeyState(KEnter, SUp);
			
		
	}
	
	public function displayMap(map:GameMap):Void
	{
		for (imageSource in map.floor.data.keys())
		{
			var tilemap = new FlxTilemap();
			var tiles = map.floor.data[imageSource];
			tiles = tiles.map(function(i) return i - 1);
			trace(imageSource, tiles.length, tiles);
			tilemap.loadMapFromArray(tiles, map.gridWidth, map.gridHeight, imageSource, map.tileWidth, map.tileHeight);
			state.add(tilemap);
		}
	}
}