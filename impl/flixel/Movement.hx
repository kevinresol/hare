package impl.flixel;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import impl.flixel.Renderer.Object;
import rpg.Engine;
import rpg.event.ScriptHost.TeleportPlayerOptions;
import rpg.geom.Direction;
import rpg.impl.System;
import rpg.map.GameMap;
import rpg.movement.InteractionManager.MovableObjectType;
import rpg.util.Tools;


/**
 * ...
 * @author Kevin
 */
class Movement extends rpg.impl.Movement
{
	@inject
	public var system:System;
	
	@inject
	public var engine:Engine;
	
	var player:FlxSprite;
	var objects:Map<Int, Object>;
	var hudCamera:FlxCamera;

	public function new(impl,player,objects,hudCamera) 
	{
		super();
		this.player = player;
		this.objects = objects;
		this.hudCamera = hudCamera;
	}
	
	override public function moveObject(callback:Void->Bool, type:MovableObjectType, dx:Int, dy:Int, speed:Float):Void
	{
		Tools.checkCallback(callback);
		
		var sprite = switch (type) 
		{
			case MPlayer: player;
			case MEvent(id): objects[id].sprite;
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
					sprite.animation.play(StringTools.replace(player.animation.name, "walking-", ""));
				}
			}} 
		);
		
	}
	
	override public function changeObjectFacing(type:MovableObjectType, dir:Int):Void
	{
		var sprite = switch (type) 
		{
			case MPlayer: player;
			case MEvent(id): objects[id] == null ? return : objects[id].sprite;
		}
		sprite.animation.play(Direction.toString(dir));
	}
	
	override public function teleportPlayer(map:GameMap, x:Int, y:Int, options:TeleportPlayerOptions):Void
	{
		if (map != engine.currentMap)
		{
			system.switchMap(map);
			
			var mapWidth = map.gridWidth * map.tileWidth;
			var mapHeight = map.gridHeight * map.tileHeight;
			var x = FlxG.width > mapWidth ? (mapWidth - FlxG.width) / 2 : 0;
			var y = FlxG.height > mapHeight ? (mapHeight - FlxG.height) / 2 : 0;
			var w = Math.max(FlxG.width, mapWidth);
			var h = Math.max(FlxG.height, mapHeight);
			
			for (camera in FlxG.cameras.list)
			{
				if (camera != hudCamera)
				{
					camera.follow(player, LOCKON);
					camera.setScrollBoundsRect(x, y, w, h);
				}
			}
		}
		
		player.x = x * map.tileWidth;
		player.y = y * map.tileHeight;
		
		switch (options.facing) 
		{
			case FRetain: // do nothing
			default: player.animation.play(options.facing);
		}
	}
}