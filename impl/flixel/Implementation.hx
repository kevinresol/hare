package impl.flixel ;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.ui.FlxVirtualPad;
import impl.flixel.display.DialogPanel;
import impl.flixel.display.GameMenu;
import impl.flixel.display.MainMenu;
import impl.flixel.display.SaveLoadScreen;
import impl.IImplementation;
import rpg.Engine;
import rpg.event.ScriptHost.InputNumberOptions;
import rpg.event.ScriptHost.ShowChoicesChoice;
import rpg.event.ScriptHost.ShowChoicesOptions;
import rpg.event.ScriptHost.ShowTextOptions;
import rpg.event.ScriptHost.TeleportPlayerOptions;
import rpg.Events;
import rpg.geom.Direction;
import rpg.map.GameMap;
import rpg.movement.InteractionManager.MovableObjectType;
import rpg.save.SaveManager.SaveDisplayData;

/**
 * A HaxeFlixel implementation for rpg-engine
 * @author Kevin
 */
class Implementation implements IImplementation
{
	public var engine:Engine;
	public var assetManager:AssetManager;
	
	private var state:FlxState;
	private var gameLayer:FlxGroup;
	private var hudLayer:FlxGroup;
	private var layers:Array<FlxGroup>; //0:floor, 1:below, 2:character, 3:above
	private var objects:Map<Int, Object>;
	
	private var mainMenu:MainMenu;
	private var gameMenu:GameMenu;
	private var saveLoadScreen:SaveLoadScreen;
	private var dialogPanel:DialogPanel;
	private var player:FlxSprite;
	
	private var gameCamera:FlxCamera;
	private var hudCamera:FlxCamera;
	
	#if mobile
	private var virtualPad:FlxVirtualPad;
	#end

	public function new(state:FlxState) 
	{
		assetManager = new AssetManager();
		
		
		this.state = state;
		state.bgColor = 0;
		state.add(gameLayer = new FlxGroup());
		state.add(hudLayer = new FlxGroup());
		
		#if mobile
		virtualPad = new FlxVirtualPad(FULL, A_B);
		
		virtualPad.scale.set(2, 2);
		virtualPad.buttonUp.updateHitbox();
		virtualPad.buttonLeft.updateHitbox();
		virtualPad.buttonRight.updateHitbox();
		virtualPad.buttonDown.updateHitbox();
		virtualPad.buttonA.updateHitbox();
		virtualPad.buttonB.updateHitbox();
		
		var size = virtualPad.buttonUp.width;
		virtualPad.buttonUp.setPosition(size * 0.9, FlxG.height - size * 3 * 0.9);
		virtualPad.buttonLeft.setPosition(0, FlxG.height - size * 2 * 0.9);
		virtualPad.buttonRight.setPosition(size * 2 * 0.9, FlxG.height - size * 2 * 0.9);
		virtualPad.buttonDown.setPosition(size * 0.9, FlxG.height - size * 0.9);
		virtualPad.buttonA.setPosition(FlxG.width - size, FlxG.height - size);
		virtualPad.buttonB.setPosition(0, 0);
		
		virtualPad.alpha = 0.3;
		hudLayer.add(virtualPad);
		#end
		
		mainMenu = new MainMenu(this);
		gameMenu = new GameMenu();
		saveLoadScreen = new SaveLoadScreen();
		dialogPanel = new DialogPanel();
		
		hudLayer.add(dialogPanel);
		hudLayer.add(mainMenu);
		hudLayer.add(gameMenu);
		hudLayer.add(saveLoadScreen);
		
		
		
		gameCamera = FlxG.camera;
		FlxG.cameras.add(hudCamera = new FlxCamera());
		FlxCamera.defaultCameras = [gameCamera];
		setCamera(hudLayer, hudCamera);
		
		layers = [];
		objects = new Map();
		
		Events.on("event.erased", function(id:Int)
		{
			var o = objects[id];
			o.layer.remove(o.sprite, true);
		});
	}
	
	public function update(elapsed:Float):Void
	{
		engine.update(elapsed);
		
		var justPressed = FlxG.keys.justPressed;
		var justReleased = FlxG.keys.justReleased;
		
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
		if (justReleased.ESCAPE)
			engine.release(KEsc);
			
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
		if (justPressed.ESCAPE)
			engine.press(KEsc);
			
		
		#if mobile
		if (virtualPad.buttonLeft.justReleased)
			engine.release(KLeft);
		if (virtualPad.buttonRight.justReleased)
			engine.release(KRight);
		if (virtualPad.buttonUp.justReleased)
			engine.release(KUp);
		if (virtualPad.buttonDown.justReleased)
			engine.release(KDown);
		if (virtualPad.buttonA.justReleased)
			engine.release(KEnter);
		if (virtualPad.buttonB.justReleased)
			engine.release(KEsc);
			
		if (virtualPad.buttonLeft.justPressed)
			engine.press(KLeft);
		if (virtualPad.buttonRight.justPressed)
			engine.press(KRight);
		if (virtualPad.buttonUp.justPressed)
			engine.press(KUp);
		if (virtualPad.buttonDown.justPressed)
			engine.press(KDown);
		if (virtualPad.buttonA.justPressed)
			engine.press(KEnter);
		if (virtualPad.buttonB.justPressed)
			engine.press(KEsc);
		#end
	}
	
	public function showMainMenu(startGameCallback:Void->Void, loadGameCallback:Void->Void):Void
	{
		if(layers[2] != null)
			layers[2].remove(player, true);
		
		while(layers.length > 0)
			layers.pop().destroy();
		
		gameLayer.clear();
		
		mainMenu.show(startGameCallback, loadGameCallback);
		gameCamera.visible = false;
	}
	
	public function hideMainMenu():Void
	{
		mainMenu.visible = false;
		gameCamera.visible = true;
	}
	
	public function showGameMenu(callback:GameMenuAction->Void, cancelCallback:Void->Void):Void
	{
		gameMenu.show(callback, cancelCallback);
	}
	
	public function hideGameMenu():Void
	{
		gameMenu.visible = false;
	}
	
	public function showSaveScreen(saveGameCallback:Int->Void, cancelCallback:Void->Void, data:Array<SaveDisplayData>):Void
	{
		saveLoadScreen.showSaveScreen(saveGameCallback, cancelCallback, data);
	}
	
	public function hideSaveScreen():Void
	{
		saveLoadScreen.visible = false;
	}
	
	public function showLoadScreen(loadGameCallback:Int->Void, cancelCallback:Void->Void, data:Array<SaveDisplayData>):Void
	{
		saveLoadScreen.showLoadScreen(loadGameCallback, cancelCallback, data);
	}
	
	public function hideLoadScreen():Void
	{
		saveLoadScreen.visible = false;
	}
	
	public function moveObject(callback:Void->Bool, type:MovableObjectType, dx:Int, dy:Int, speed:Float):Void
	{
		checkCallback(callback);
		
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
				sprite.y = Math.round(sprite.y / map.tileHeight) * map.tileHeight - (type == MPlayer ? 16 : 0);
				if (!callback())
				{
					sprite.animation.play(StringTools.replace(player.animation.name, "walking-", ""));
				}
			}} 
		);
		
	}
	
	public function changeObjectFacing(type:MovableObjectType, dir:Int):Void
	{
		var sprite = switch (type) 
		{
			case MPlayer: player;
			case MEvent(id): objects[id].sprite;
		}
		sprite.animation.play(Direction.toString(dir));
	}
	
	public function showText(callback:Void->Void, characterId:String, message:String, options:ShowTextOptions):Void
	{
		checkCallback(callback);
		dialogPanel.showText(callback, characterId, message, options);
		
	}
	
	public function showChoices(callback:Int->Void, prompt:String, choices:Array<ShowChoicesChoice>, options:ShowChoicesOptions):Void
	{
		checkCallback(callback);
		dialogPanel.showChoices(callback, prompt, choices, options);
	}
	
	public function inputNumber(callback:Int->Void, prompt:String, numDigit:Int, options:InputNumberOptions):Void
	{
		checkCallback(callback);
		dialogPanel.inputNumber(callback, prompt, numDigit, options);
	}
	
	public function log(message:String):Void 
	{
		FlxG.log.add(message);
		trace(message);
	}
	
	
	@:access(flixel.system.FlxSound)
	public function playSound(id:Int, volume:Float, pitch:Float):Void
	{
		var s = FlxG.sound.play(assetManager.getSound(id), volume);
		s._channel.pitch = pitch;
	}
	
	@:access(flixel.system.FlxSound)
	public function playBackgroundMusic(id:Int, volume:Float, pitch:Float):Void
	{
		FlxG.sound.playMusic(assetManager.getMusic(id), volume);
		FlxG.sound.music._channel.pitch = pitch;
	}
	
	public function playSystemSound(id:Int, volume:Float):Void
	{
		FlxG.sound.play(assetManager.getSystemSound(id), volume);
	}
	
	public function saveBackgroundMusic():Void
	{
		FlxG.sound.music.pause();
	}
	
	public function restoreBackgroundMusic():Void
	{
		FlxG.sound.music.resume();
	}
	
	public function fadeOutBackgroundMusic(ms:Int):Void
	{
		FlxG.sound.music.fadeOut(ms/1000,0);
	}
	
	public function fadeInBackgroundMusic(ms:Int):Void
	{
		FlxG.sound.music.fadeIn(ms/1000,0);
	}
	
	public function createPlayer(name:String, image:String):Void
	{
		player = new FlxSprite();
		player.loadGraphic('assets/images/actor/$image', true, 32, 48);
		player.animation.add("walking-left", [3, 4, 5, 4], 8);
		player.animation.add("walking-right", [6, 7, 8, 7], 8);
		player.animation.add("walking-down", [0, 1, 2, 1], 8);
		player.animation.add("walking-up", [9, 10, 11, 10], 8);
		player.animation.add("left", [4], 0);
		player.animation.add("right", [7], 0);
		player.animation.add("down", [1], 0);
		player.animation.add("up", [10], 0);
		player.animation.play("down");
	}
	
	public function teleportPlayer(map:GameMap, x:Int, y:Int, options:TeleportPlayerOptions):Void
	{
		if (map != engine.currentMap)
		{
			switchMap(map);
			
			var mapWidth = map.gridWidth * map.tileWidth;
			var mapHeight = map.gridHeight * map.tileHeight;
			var x = FlxG.width > mapWidth ? (mapWidth - FlxG.width) / 2 : 0;
			var y = FlxG.height > mapHeight ? (mapHeight - FlxG.height) / 2 : 0;
			var w = Math.max(FlxG.width, mapWidth);
			var h = Math.max(FlxG.height, mapHeight);
			
			FlxG.camera.follow(player, LOCKON);
			FlxG.camera.setScrollBoundsRect(x, y, w, h);
		}
		
		player.x = x * map.tileWidth;
		player.y = y * map.tileHeight - 16;
		
		switch (options.facing) 
		{
			case FRetain: // do nothing
			default: player.animation.play(options.facing);
		}
	}
	
	public function fadeOutScreen(ms:Int):Void 
	{
		gameCamera.fade(0, ms / 1000, false, null, true);
	}
	
	public function fadeInScreen(ms:Int):Void 
	{
		gameCamera.fade(0, ms / 1000, true, null, true);
	}
	
	public function tintScreen(color:Int, ms:Int):Void 
	{
		
	}
	
	public function flashScreen(color:Int, strength:Int, ms:Int):Void 
	{
		
	}
	
	public function shakeScreen(power:Int, screen:Int, ms:Int):Void 
	{
		
	}
	
	private function switchMap(map:GameMap):Void
	{
		if(layers[2] != null)
			layers[2].remove(player, true);
		
		while(layers.length > 0)
			layers.pop().destroy();
		
		gameLayer.clear();
		
		for (i in 0...4)
		{
			var layer = new FlxGroup();
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
			var sprite = new FlxSprite(object.x * map.tileWidth, object.y * map.tileHeight);
			switch (object.displayType) 
			{
				case DTile(imageSource, tileId):
					sprite.loadGraphic(imageSource, true, 32, 32);
					sprite.animation.frameIndex = tileId - 1;
					
				case DActor(imageSource, index):
					sprite.loadGraphic('assets/images/actor/$imageSource', true, 32, 48);
					sprite.animation.add("walking-left", [3, 4, 5, 4], 8);
					sprite.animation.add("walking-right", [6, 7, 8, 7], 8);
					sprite.animation.add("walking-down", [0, 1, 2, 1], 8);
					sprite.animation.add("walking-up", [9, 10, 11, 10], 8);
					sprite.animation.add("left", [4], 0);
					sprite.animation.add("right", [7], 0);
					sprite.animation.add("down", [1], 0);
					sprite.animation.add("up", [10], 0);
					sprite.animation.play("down");
					sprite.y -= 16;
			}
			var index = Std.int(object.layer);
			if (index < 0) index = 0;
			if (index >= 3) index = 3;
			layers[index].add(sprite); //TODO figure out the layer to add to
			objects[object.id] = new Object(sprite, layers[index]);
		}
		
	}
	
	private inline function checkCallback(callback:Dynamic):Void
	{
		#if debug
		if (callback == null) throw "callback cannot be null";
		#end
	}
	
	private function setCamera(object:FlxBasic, camera:FlxCamera):Void
	{
		if (Std.is(object, FlxGroup))
		{
			var g:FlxGroup = cast object;
			for (m in g.members) setCamera(m, camera);
		}
		else if (Std.is(object, FlxSpriteGroup))
		{
			var g:FlxSpriteGroup = cast object;
			for (m in g.members) setCamera(m, camera);
		}
		object.camera = camera;
	}
}

private class Object
{
	public var layer:FlxGroup;
	public var sprite:FlxSprite;
	
	public function new(sprite, layer)
	{
		this.sprite = sprite;
		this.layer = layer;
	}
}