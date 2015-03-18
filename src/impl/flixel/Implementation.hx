package impl.flixel ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import rpg.Engine;
import rpg.geom.Direction;
import rpg.geom.IntPoint;
import rpg.geom.Point;
import impl.IAssetManager;
import impl.IHost;
import impl.IImplementation;
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
	public var playerMovementDirection:IntPoint;
	private var playerTween:FlxTween;
	
	private var state:FlxState;
	
	private var player:FlxSprite;
	

	public function new(state:FlxState) 
	{
		assetManager = new AssetManager();
		host = new Host(state);
		
		playerMovementDirection = new IntPoint();
		
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
	}
	
	private function set_currentMap(map:GameMap):GameMap
	{
		// draw floor layer
		for (imageSource in map.floor.data.keys())
		{
			var tilemap = new FlxTilemap();
			var tiles = map.floor.data[imageSource];
			tiles = tiles.map(function(i) return i - 1);
			tilemap.loadMapFromArray(tiles, map.gridWidth, map.gridHeight, imageSource, map.tileWidth, map.tileHeight, null, 0, 0);
			state.add(tilemap);
		}
		return currentMap = map;
	}
	
	public function teleportPlayer(x:Int, y:Int):Void
	{
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
			state.add(player);
			
			
			FlxG.camera.follow(player, LOCKON);
			FlxG.camera.setScrollBoundsRect(0, 0, currentMap.gridWidth * currentMap.tileWidth, currentMap.gridHeight * currentMap.tileHeight);
		}
		
		player.x = x * currentMap.tileWidth;
		player.y = y * currentMap.tileHeight - 16;
		engine.updatePlayerPosition(x, y);
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
			player.x + dx * currentMap.tileWidth, 
			player.y + dy * currentMap.tileHeight, 
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
		var gridX = Math.round(player.x / currentMap.tileWidth);
		var gridY = Math.round(player.y / currentMap.tileHeight);
		
		// make sure it is at the exact position
		player.x = gridX * currentMap.tileWidth;
		player.y = gridY * currentMap.tileHeight -16;
		
		engine.updatePlayerPosition(gridX, gridY);
		
		if (!engine.endMove())
		{
			player.animation.play(StringTools.replace(player.animation.name, "walking-", ""));
			playerTween = null;
		}
	}
	
}