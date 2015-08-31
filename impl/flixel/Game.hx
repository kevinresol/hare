package impl.flixel;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import impl.flixel.display.GameMenu;
import impl.flixel.display.MainMenu;
import impl.flixel.Implementation.Object;
import rpg.image.Image;
import rpg.map.GameMap;

/**
 * ...
 * @author Kevin
 */
class Game extends rpg.impl.Game
{
	var layers:Array<FlxTypedGroup<FlxObject>>;
	var player:FlxSprite;
	var objects:Map<Int, Object>;
	
	var gameLayer:FlxGroup;
	
	public function new(impl,layers,player,gameLayer,objects) 
	{
		super(impl);
		this.layers = layers;
		this.gameLayer = gameLayer;
		
		this.player = player;
		this.objects = objects;
	}
	
	
	
	override public function switchMap(map:GameMap):Void
	{
		if(layers[2] != null)
			layers[2].remove(player, true);
		
		while(layers.length > 0)
			layers.pop().destroy();
		
		gameLayer.clear();
		
		for (i in 0...4)
		{
			var layer = new FlxTypedGroup();
			gameLayer.add(layer);
			layers.push(layer);
		}
			
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
		
		layers[2].add(player);
		
		var sortedObjects = map.objects.concat([]);
		sortedObjects.sort(function(o1, o2) return if(o1.layer == o2.layer) 0 else if(o1.layer > o2.layer) 1 else -1);
		
		for (object in sortedObjects)
		{
			if (object.visible)
			{
				var sprite = new FlxSprite(object.x * map.tileWidth, object.y * map.tileHeight);
				switch (object.displayType) 
				{
					case DTile(imageSource, tileId):
						sprite.loadGraphic(imageSource, true, 32, 32);
						sprite.animation.frameIndex = tileId - 1;
						
					case DCharacter(image):
						loadCharacterImage(sprite, image);
						
				}
				var index = Std.int(object.layer);
				if (index < 0) index = 0;
				if (index >= 3) index = 3;
				layers[index].add(sprite);
				objects[object.id] = new Object(sprite, layers[index]);
			}
		}
	}
	
	override public function createPlayer(image:Image):Void
	{
		player = new FlxSprite();
		
		loadCharacterImage(player, image);
	}
	
	private function loadCharacterImage(sprite:FlxSprite, image:Image):Void
	{
		
		sprite.loadGraphic(image.source, true, image.frameWidth, image.frameHeight);
		sprite.offset.set(0, image.frameHeight - 32 + 4);
		
		var i = image.getGlobalFrameIndex(0, 0);
		sprite.animation.add("walking-down", [i + 0, i + 1, i + 2, i + 1], 8);
		sprite.animation.add("down", [i + 1], 0);
		
		i = image.getGlobalFrameIndex(0, 1);
		sprite.animation.add("walking-left", [i + 0, i + 1, i + 2, i + 1], 8);
		sprite.animation.add("left", [i + 1], 0);
		
		i = image.getGlobalFrameIndex(0, 2);
		sprite.animation.add("walking-right", [i + 0, i + 1, i + 2, i + 1], 8);
		sprite.animation.add("right", [i + 1], 0);
		
		i = image.getGlobalFrameIndex(0, 3);
		sprite.animation.add("walking-up", [i + 0, i + 1, i + 2, i + 1], 8);
		sprite.animation.add("up", [i + 1], 0);
		
		sprite.animation.play("down");
	}
}