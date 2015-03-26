package impl.flixel ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import impl.flixel.display.DialogPanel;
import impl.flixel.display.GameMenu;
import impl.flixel.display.MainMenu;
import impl.flixel.display.SaveLoadScreen;
import impl.IAssetManager;
import impl.IImplementation;
import rpg.Engine;
import rpg.event.ScriptHost.ShowChoicesChoice;
import rpg.event.ScriptHost.ShowChoicesOptions;
import rpg.event.ScriptHost.ShowTextOptions;
import rpg.event.ScriptHost.TeleportPlayerOptions;
import rpg.geom.Direction;
import rpg.map.GameMap;

/**
 * A HaxeFlixel implementation for rpg-engine
 * @author Kevin
 */
class Implementation implements IImplementation
{
	public var engine:Engine;
	public var assetManager:IAssetManager;
	
	private var playerTween:FlxTween;
	
	private var state:FlxState;
	private var gameLayer:FlxGroup;
	private var hudLayer:FlxGroup;
	private var layers:Array<FlxGroup>; //0:floor, 1:below, 2:character, 3:above
	
	private var mainMenu:MainMenu;
	private var gameMenu:GameMenu;
	private var saveLoadScreen:SaveLoadScreen;
	private var dialogPanel:DialogPanel;
	private var player:FlxSprite;
	

	public function new(state:FlxState) 
	{
		assetManager = new AssetManager();
		
		this.state = state;
		state.add(gameLayer = new FlxGroup());
		state.add(hudLayer = new FlxGroup());
		
		mainMenu = new MainMenu(this);
		gameMenu = new GameMenu();
		saveLoadScreen = new SaveLoadScreen();
		
		dialogPanel = new DialogPanel();
		hudLayer.add(dialogPanel);
		dialogPanel.visible = false;
		
		layers = [for (i in 0...5) cast gameLayer.add(new FlxGroup())];
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
		if (justPressed.ESCAPE)
			engine.press(KEsc);
		
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
	}
	
	public function showMainMenu(startGameCallback:Void->Void, loadGameCallback:Void->Void):Void
	{	
		hudLayer.add(mainMenu);
		mainMenu.show(startGameCallback, loadGameCallback);
	}
	
	public function hideMainMenu():Void
	{
		hudLayer.remove(mainMenu, true);
	}
	
	
	public function showSaveScreen(saveGameCallback:Int->Void, cancelCallback:Void->Void):Void
	{
		hudLayer.add(saveLoadScreen);
		saveLoadScreen.showSaveScreen(saveGameCallback, cancelCallback);
	}
	
	public function hideSaveScreen():Void
	{
		hudLayer.remove(saveLoadScreen, true);
	}
	
	public function showLoadScreen(loadGameCallback:Int->Void, cancelCallback:Void->Void):Void
	{
		hudLayer.add(saveLoadScreen);
		saveLoadScreen.showLoadScreen(loadGameCallback, cancelCallback);
	}
	
	public function hideLoadScreen():Void
	{
		hudLayer.remove(saveLoadScreen, true);
	}
	
	public function showGameMenu():Void
	{
		
	}
	
	public function hideGameMenu():Void
	{
		
	}
	
	
	public function movePlayer(callback:Void->Bool, dx:Int, dy:Int):Void
	{
		checkCallback(callback);
		
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
			{onComplete:function(t)
			{
				var map = engine.currentMap;
				// make sure it is at the exact position
				player.x = Math.round(player.x / map.tileWidth) * map.tileWidth;
				player.y = Math.round(player.y / map.tileHeight) * map.tileHeight -16;
				if (!callback())
				{
					player.animation.play(StringTools.replace(player.animation.name, "walking-", ""));
					playerTween = null;
				}
			}} 
		);
		
	}
	
	public function changePlayerFacing(dir:Int):Void
	{
		player.animation.play(Direction.toString(dir));
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
	
	public function log(message:String):Void 
	{
		FlxG.log.add(message);
		trace(message);
	}
	
	
	public function playSound(id:Int, volume:Float, pitch:Float):Void
	{
		//TODO: implement sound pitch support here
		FlxG.sound.play(assetManager.getSound(id), volume);
	}
	
	public function playBackgroundMusic(id:Int, volume:Float, pitch:Float):Void
	{
		//TODO: implement sound pitch support here
		FlxG.sound.playMusic(assetManager.getMusic(id), volume);
	}
	
	public function playSystemSound(id:Int, volume:Float):Void
	{
		FlxG.sound.play(assetManager.getSystemSound(id), volume);
	}
	
	public function saveBackgroundMusic():Void
	{
		FlxG.sound.pause();
	}
	
	public function restoreBackgroundMusic():Void
	{
		FlxG.sound.resume();
	}
	
	public function fadeOutBackgroundMusic(ms:Int):Void
	{
		FlxTween.num(1, 0, ms/1000, null, function(v) FlxG.sound.volume = v);
	}
	
	public function fadeInBackgroundMusic(ms:Int):Void
	{
		FlxTween.num(0, 1, ms/1000, null, function(v) FlxG.sound.volume = v);
	}
	
	
	public function teleportPlayer(map:GameMap, x:Int, y:Int, options:TeleportPlayerOptions):Void
	{
		// create player
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
		
		if (map != engine.currentMap)
			switchMap(map);
		
		layers[2].add(player);
		player.x = x * map.tileWidth;
		player.y = y * map.tileHeight - 16;
		
		if (options.facing != "unchanged")
			player.animation.play(options.facing);
	}
	
	public function fadeOutScreen(ms:Int):Void 
	{
		FlxG.camera.fade(0, ms / 1000, false, null, true);
	}
	
	public function fadeInScreen(ms:Int):Void 
	{
		FlxG.camera.fade(0, ms / 1000, true, null, true);
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
		layers[2].remove(player, true);
		
		for (layer in layers)
		{
			layer.destroy();
			
		}
			
		layers = [for (i in 0...4) cast gameLayer.add(new FlxGroup())];
			
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
		
		for (object in map.objects)
		{
			var sprite = new FlxSprite(object.x * map.tileWidth, object.y * map.tileHeight);
			sprite.loadGraphic(object.imageSource, true, 32, 32);
			sprite.animation.frameIndex = object.tileId - 1;
			layers[1].add(sprite);
		}
		
		layers[2].add(player);
	}
	
	private inline function checkCallback(callback:Dynamic):Void
	{
		#if debug
		if (callback == null) throw "callback cannot be null";
		#end
	}
}