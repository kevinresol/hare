package impl.flixel ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import impl.IAssetManager;
import impl.IHost;
import impl.IImplementation;
import rpg.Engine;
import rpg.geom.Direction;
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
	
	private var playerTween:FlxTween;
	
	private var state:FlxState;
	private var layers:Array<FlxGroup>; //0:floor, 1:below, 2:character, 3:above
	
	
	private var player:FlxSprite;
	

	public function new(state:FlxState) 
	{
		assetManager = new AssetManager();
		host = new Host(state, this);
		
		this.state = state;
		
		layers = [for (i in 0...4) cast state.add(new FlxGroup())];
		
		
	}
	
	public function update(elapsed:Float):Void
	{
		engine.update(elapsed);
		
		var justPressed = FlxG.keys.justPressed;
		var justReleased = FlxG.keys.justReleased;
		
		if (justPressed.LEFT)
			engine.press(KLeft);
		if (justPressed.RIGHT)
			engine.press(KRight);
		if (justPressed.UP)
			engine.press(KUp);
		if (justPressed.DOWN)
			engine.press(KDown);
		if (justPressed.ENTER || justPressed.SPACE)
			engine.press(KEnter);
		
		if (justReleased.LEFT)
			engine.release(KLeft);
		if (justReleased.RIGHT)
			engine.release(KRight);
		if (justReleased.UP)
			engine.release(KUp);
		if (justReleased.DOWN)
			engine.release(KDown);
		if (justReleased.ENTER || justReleased.SPACE)
			engine.release(KEnter);
	}
	
	public function switchMap(map:GameMap):Void
	{
		layers[2].remove(player, true);
		
		for (layer in layers)
			layer.destroy();
			
		layers = [for (i in 0...4) cast state.add(new FlxGroup())];
			
		// draw floor layer
		for (imageSource in map.floor.data.keys())
		{
			var tilemap = new FlxTilemap();
			var tiles = map.floor.data[imageSource];
			tiles = tiles.map(function(i) return i - 1);
			tilemap.loadMapFromArray(tiles, map.gridWidth, map.gridHeight, imageSource, map.tileWidth, map.tileHeight, null, 0, 0);
			layers[0].add(tilemap);
		}
		
		for (imageSource in map.below.data.keys())
		{
			var tilemap = new FlxTilemap();
			var tiles = map.below.data[imageSource];
			tiles = tiles.map(function(i) return i - 1);
			tilemap.loadMapFromArray(tiles, map.gridWidth, map.gridHeight, imageSource, map.tileWidth, map.tileHeight, null, 0, 0);
			layers[1].add(tilemap);
		}
		
		for (imageSource in map.above.data.keys())
		{
			var tilemap = new FlxTilemap();
			var tiles = map.above.data[imageSource];
			tiles = tiles.map(function(i) return i - 1);
			tilemap.loadMapFromArray(tiles, map.gridWidth, map.gridHeight, imageSource, map.tileWidth, map.tileHeight, null, 0, 0);
			layers[3].add(tilemap);
		}
		
		for (event in map.events)
		{
			var sprite = new FlxSprite(event.x * map.tileWidth, event.y * map.tileHeight);
			sprite.loadGraphic(event.imageSource, true, 32, 32);
			sprite.animation.frameIndex = event.tileId - 1;
			layers[1].add(sprite);
		}
	}
	
	public function teleportPlayer(x:Int, y:Int):Void
	{
		var map = engine.currentMap;
		
		if (player == null)
		{
			player = new FlxSprite();
			player.loadGraphic("assets/images/harrison2.png", true, 32, 48);
			player.animation.add("walking-left", [3, 4, 5, 4], 8);
			player.animation.add("walking-right", [6, 7, 8, 7], 8);
			player.animation.add("walking-down", [0, 1, 2, 1], 8);
			player.animation.add("walking-up", [9, 10, 11, 10], 8);
			player.animation.add("left", [4], 0);
			player.animation.add("right", [7], 0);
			player.animation.add("down", [1], 0);
			player.animation.add("up", [10], 0);
			player.animation.play("down");
			
			FlxG.camera.follow(player, LOCKON);
			FlxG.camera.setScrollBoundsRect(0, 0, map.gridWidth * map.tileWidth, map.gridHeight * map.tileHeight);
		}
		
		layers[2].add(player);
		
		player.x = x * map.tileWidth;
		player.y = y * map.tileHeight - 16;
	}
	
	public function movePlayer(dx:Int, dy:Int):Void
	{
		var speed = 200;
		
		if (dx == 1) player.animation.play("walking-right");
		else if (dx == -1) player.animation.play("walking-left");
		else if (dy == 1) player.animation.play("walking-down");
		else if (dy == -1) player.animation.play("walking-up");
		
		//if (playerTween != null && playerTween.active)
		//	playerTween.cancel();
		
		playerTween = FlxTween.linearMotion(
			player, 
			player.x, 
			player.y, 
			player.x + dx * engine.currentMap.tileWidth, 
			player.y + dy * engine.currentMap.tileHeight, 
			speed, 
			false,
			{onComplete:movePlayer_onComplete} 
		);
		
	}
	
	public function changePlayerFacing(dir:Int):Void
	{
		switch (dir) 
		{
			case Direction.LEFT: player.animation.play("left");
			case Direction.RIGHT: player.animation.play("right");
			case Direction.TOP: player.animation.play("up");
			case Direction.BOTTOM: player.animation.play("down");
			default:
		}
	}
	
	private function movePlayer_onComplete(tween:FlxTween):Void
	{
		var map = engine.currentMap;
		var gridX = Math.round(player.x / map.tileWidth);
		var gridY = Math.round(player.y / map.tileHeight);
		
		// make sure it is at the exact position
		player.x = gridX * map.tileWidth;
		player.y = gridY * map.tileHeight -16;
		
		if (!engine.endMove(gridX, gridY))
		{
			player.animation.play(StringTools.replace(player.animation.name, "walking-", ""));
			playerTween = null;
		}
	}
	
}