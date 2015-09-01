package hare.impl.flixel;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import hare.event.ScriptHost;
import hare.impl.Movement;
import hare.movement.InteractionManager;
import hare.Engine;
import hare.event.ScriptHost.TeleportPlayerOptions;
import hare.geom.Direction;
import hare.impl.System;
import hare.map.GameMap;
import hare.movement.InteractionManager.MovableObjectType;
import hare.util.Tools;


/**
 * ...
 * @author Kevin
 */
class Movement extends hare.impl.Movement
{
	@inject
	public var system:System;
	@inject
	public var renderer:Renderer;
	
	@inject
	public var engine:Engine;

	public function new() 
	{
		super();
	}
	
	override public function moveObject(callback:Void->Bool, type:MovableObjectType, dx:Int, dy:Int, speed:Float):Void
	{
		Tools.checkCallback(callback);
		
		var sprite = switch (type) 
		{
			case MPlayer: renderer.player;
			case MEvent(id): renderer.objects[id].sprite;
		}
		
		var speed = engine.currentMap.tileWidth * speed;
		
		if (dx == 1) sprite.animation.play("walking-right");
		else if (dx == -1) sprite.animation.play("walking-left");
		else if (dy == 1) sprite.animation.play("walking-down");
		else if (dy == -1) sprite.animation.play("walking-up");
				
		FlxTween.linearMotion(
			sprite, 
			sprite.x, 
			sprite.y, 
			sprite.x + dx * engine.currentMap.tileWidth, 
			sprite.y + dy * engine.currentMap.tileHeight, 
			speed, 
			false,
			{onComplete:function(t)
			{
				var map = engine.currentMap;
				// make sure it is at the exact position
				sprite.x = Math.round(sprite.x / map.tileWidth) * map.tileWidth;
				sprite.y = Math.round(sprite.y / map.tileHeight) * map.tileHeight;
				if (!callback())
				{
					sprite.animation.play(StringTools.replace(renderer.player.animation.name, "walking-", ""));
				}
			}} 
		);
		
	}
	
	override public function changeObjectFacing(type:MovableObjectType, dir:Int):Void
	{
		var sprite = switch (type) 
		{
			case MPlayer: renderer.player;
			case MEvent(id): renderer.objects[id] == null ? return : renderer.objects[id].sprite;
		}
		sprite.animation.play(Direction.toString(dir));
	}
	
	override public function teleportPlayer(map:GameMap, x:Int, y:Int, options:TeleportPlayerOptions):Void
	{
		if (map != engine.currentMap)
		{
			renderer.switchMap(map);
			
			var mapWidth = map.gridWidth * map.tileWidth;
			var mapHeight = map.gridHeight * map.tileHeight;
			var x = FlxG.width > mapWidth ? (mapWidth - FlxG.width) / 2 : 0;
			var y = FlxG.height > mapHeight ? (mapHeight - FlxG.height) / 2 : 0;
			var w = Math.max(FlxG.width, mapWidth);
			var h = Math.max(FlxG.height, mapHeight);
			
			for (camera in FlxG.cameras.list)
			{
				if (camera != renderer.hudCamera)
				{
					camera.follow(renderer.player, LOCKON);
					camera.setScrollBoundsRect(x, y, w, h);
				}
			}
		}
		
		renderer.player.x = x * map.tileWidth;
		renderer.player.y = y * map.tileHeight;
		
		switch (options.facing) 
		{
			case FRetain: // do nothing
			default: renderer.player.animation.play(options.facing);
		}
	}
}