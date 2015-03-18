package impl.flixel ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import rpg.Engine;
import rpg.geom.Point;
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
	
	public var currentMap(default, set):GameMap;
	public var playerMovementDirection:Point;
	private var playerTween:FlxTween;
	
	private var state:FlxState;
	
	private var player:FlxSprite;
	

	public function new(state:FlxState) 
	{
		assetManager = new AssetManager();
		host = new Host();
		
		playerMovementDirection = new Point();
		
		this.state = state;
		
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
			
		if (playerTween == null)
		{
			movePlayer();
		}
	}
	
	private function set_currentMap(map:GameMap):GameMap
	{
		// draw floor layer
		for (imageSource in map.floor.data.keys())
		{
			var tilemap = new FlxTilemap();
			var tiles = map.floor.data[imageSource];
			tiles = tiles.map(function(i) return i - 1);
			tilemap.loadMapFromArray(tiles, map.gridWidth, map.gridHeight, imageSource, map.tileWidth, map.tileHeight);
			state.add(tilemap);
		}
		return currentMap = map;
	}
	
	public function addPlayer(x:Int, y:Int):Void
	{
		player = new FlxSprite();
		player.loadGraphic("assets/images/harrison2.png", true, 32, 48);
		player.animation.add("walking-left", [3, 4, 5], 8);
		player.animation.add("walking-right", [6, 7, 8], 8);
		player.animation.add("walking-down", [0, 1, 2], 8);
		player.animation.add("walking-up", [9, 10, 11], 8);
		player.animation.add("left", [4], 0);
		player.animation.add("right", [7], 0);
		player.animation.add("down", [1], 0);
		player.animation.add("up", [10], 0);
		player.animation.play("down");
		player.x = x * currentMap.tileWidth;
		player.y = y * currentMap.tileHeight - 16;
		state.add(player);
		
		FlxG.camera.follow(player, LOCKON);
		FlxG.camera.setScrollBoundsRect(0, 0, currentMap.gridWidth * currentMap.tileWidth, currentMap.gridHeight * currentMap.tileHeight);
	}
	
	
	private function movePlayer(speed:Float = 200):Void
	{
		var dx = playerMovementDirection.x;
		var dy = playerMovementDirection.y;
		
		if (dx == 1) player.animation.play("walking-right");
		else if (dx == -1) player.animation.play("walking-left");
		else if (dy == 1) player.animation.play("walking-down");
		else if (dy == -1) player.animation.play("walking-up");
		else 
		{
			player.animation.play(StringTools.replace(player.animation.name, "walking-", ""));
			playerTween = null;
			return;
		}
		
		playerTween = FlxTween.linearMotion(
			player, 
			player.x, 
			player.y, 
			player.x + dx * currentMap.tileWidth, 
			player.y + dy * currentMap.tileHeight, 
			speed, 
			false,
			{onComplete:function(t) movePlayer()} 
		);
	}
	
}