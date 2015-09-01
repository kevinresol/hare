package hare;
import haxe.Json;
import haxe.Timer;
import minject.Injector;
import hare.config.Config;
import hare.event.EventManager;
import hare.event.ScriptHost;
import hare.image.ImageManager;
import hare.impl.Assets;
import hare.impl.Game;
import hare.impl.Message;
import hare.impl.Module;
import hare.impl.Movement;
import hare.impl.Music;
import hare.impl.Renderer;
import hare.impl.Screen;
import hare.impl.Sound;
import hare.impl.System;
import hare.input.InputManager;
import hare.item.ItemManager;
import hare.map.GameMap;
import hare.map.MapManager;
import hare.movement.InteractionManager;
import hare.save.SaveManager;
import hare.util.Tools;

/**
 * Revamp:
 * Input use single function (onkeydown)
 * @author Kevin
 */
@:allow(hare)
class Engine
{
	public var currentMap(get, never):GameMap;
	public var config(default, null):Config;
	
	
	var modules:Array<Module>;
	
	@inject 
	public var assets:Assets;
	@inject 
	public var game:Game;
	@inject 
	public var sound:Sound;
	@inject 
	public var system:System;
	@inject 
	public var music:Music;
	@inject 
	public var screen:Screen;
	@inject 
	public var message:Message;
	@inject 
	public var movement:Movement;
	@inject 
	public var renderer:Renderer;
	
	@inject 
	public var mapManager:MapManager;
	@inject 
	public var eventManager:EventManager;
	@inject 
	public var inputManager:InputManager;
	@inject 
	public var interactionManager:InteractionManager;
	@inject 
	public var saveManager:SaveManager;
	@inject 
	public var itemManager:ItemManager;
	@inject 
	public var imageManager:ImageManager;
	
	private var gameState(default, set):GameState;
	
	private var delayedCalls:Array<DelayedCall>;
	private var called:Array<DelayedCall>;
	
	public var injector(default, null):Injector;
	
	public function new(options:EngineOptions) 
	{
		Tools.engine = this;
		
		if (options == null)
		{
			options = {
				game:hare.impl.Game,
				music:hare.impl.Music,
				sound:hare.impl.Sound,
				assets:hare.impl.Assets,
				screen:hare.impl.Screen,
				system:hare.impl.System,
				message:hare.impl.Message,
				movement:hare.impl.Movement,
				renderer:hare.impl.Renderer,
			}
		}
		
		injector = new Injector();
		injector.map(Engine).toValue(this);
		
		injector.map(Injector).toValue(injector);
		
		injector.map(MapManager).asSingleton();
		injector.map(EventManager).asSingleton();
		injector.map(ScriptHost).asSingleton();
		injector.map(InputManager).asSingleton();
		injector.map(InteractionManager).asSingleton();
		injector.map(SaveManager).asSingleton();
		injector.map(ItemManager).asSingleton();
		injector.map(ImageManager).asSingleton();
		
		// map modules to singleton (e.g. both hare.impl.Assets and options.assets map to the same singleton)
		injector.map(hare.impl.Assets).toMapping(   	injector.mapRuntimeTypeOf(options.assets).toSingleton(options.assets)     );
		injector.map(hare.impl.Message).toMapping(	injector.mapRuntimeTypeOf(options.message).toSingleton(options.message)   );
		injector.map(hare.impl.Movement).toMapping(	injector.mapRuntimeTypeOf(options.movement).toSingleton(options.movement) );
		injector.map(hare.impl.Music).toMapping(		injector.mapRuntimeTypeOf(options.music).toSingleton(options.music)       );
		injector.map(hare.impl.Screen).toMapping(   	injector.mapRuntimeTypeOf(options.screen).toSingleton(options.screen)     );
		injector.map(hare.impl.Sound).toMapping(		injector.mapRuntimeTypeOf(options.sound).toSingleton(options.sound)       );
		injector.map(hare.impl.System).toMapping(	injector.mapRuntimeTypeOf(options.system).toSingleton(options.system)     );
		injector.map(hare.impl.Game).toMapping(		injector.mapRuntimeTypeOf(options.game).toSingleton(options.game)         );
		injector.map(hare.impl.Renderer).toMapping(	injector.mapRuntimeTypeOf(options.renderer).toSingleton(options.renderer) );
		
		
		injector.injectInto(this);
		
		modules = [
			game,
			music,
			sound,
			assets,
			screen,
			system,
			message,
			movement,
			renderer,
		];
		
		
		delayedCalls = [];
		called = [];
		
		#if !RPG_ENGINE_EDITOR
		loadConfig();
		gameState = SMainMenu;
		#end
		
		
		var mainMenuBackgroundImage = 
			if (config.mainMenu == null) 
				null
			else
				imageManager.getImage(IMainMenu(config.mainMenu.image), 0);
		renderer.init(mainMenuBackgroundImage);
	}
	
	/**
	 * Start new game
	 */
	public function startGame():Void
	{
		// init items
		itemManager.init(config.items);
		
		// reset game vars
		eventManager.reset();
		
		// set game state
		gameState = SGame;
		
		// always start game at map 1
		var map = mapManager.getMap(1); 
		
		// teleport player to place
		if (map.player != null)
		{
			var image = imageManager.getImage(ICharacter(map.player.image.source), map.player.image.index);
			renderer.createPlayer(image);
			eventManager.scriptHost.teleportPlayer(1, map.player.x, map.player.y, {facing:"down"});
			screen.fadeInScreen(200);
		}
		else
			log("Player (an object with type=player) must be placed in Map 1", LError);
	}
	
	public function loadConfig():Void
	{
		var data = try
		{
			Json.parse(assets.getConfig());
		}
		catch (e:Dynamic) 
		{
			log("Error in parsing config file:", LError);
			log(Std.string(e), LError);
			{ characters:[], items:[] };
		}
		
		config = new Config(data, this);
	}
	
	/**
	 * Load a game
	 * @param	id
	 */
	public function loadGame(id:Int):Void
	{
		saveManager.load(id, config);
		gameState = SGame;
	}
	
	public function saveGame(id:Int):Void
	{
		saveManager.save(id);
		gameState = SGame;
	}
	
	public function update(elapsed:Float):Void
	{
		eventManager.update(elapsed);
		
		for (mod in modules) mod.update(elapsed);
		
		var now = #if sys Sys.time() #else Timer.stamp() #end;
		for (c in delayedCalls)
		{
			if (now >= c.callAt)
			{
				c.callback();
				called.push(c);
			}
		}
		
		while (called.length > 0)
			delayedCalls.remove(called.pop());
	}
	
	public inline function press(key:InputKey):Void
	{
		inputManager.press(key);
	}
	
	public inline function release(key:InputKey):Void
	{
		inputManager.release(key);
	}
	
	public function log(message:String, level:LogLevel):Void
	{
		system.log(message, level);
	}
	
	private inline function delayedCall(callback:Void->Void, ms:Int):Void
	{
		delayedCalls.push(new DelayedCall(callback, #if sys Sys.time() #else Timer.stamp() #end + ms / 1000));
	}
	
	private inline function get_currentMap():GameMap
	{
		return mapManager.currentMap;
	}
	
	private function set_gameState(v:GameState):GameState
	{
		if (gameState == v) return v;
		
		var currentState = gameState;
		
		if (currentState != null)
		{
			switch (currentState) 
			{
				case SMainMenu:
					system.hideMainMenu();
					
				case SLoadScreen:
					system.hideLoadScreen();
					
				case SSaveScreen:
					system.hideSaveScreen();
				
				case SGameMenu:
					system.hideGameMenu();
					
				default:
			}
		}
		
		switch (v) 
		{
			case SMainMenu:
				music.saveBackgroundMusic();
				mapManager.currentMap = null;
				system.showMainMenu(startGame, function() gameState = SLoadScreen);
				
			case SLoadScreen:
				system.showLoadScreen(loadGame, function() gameState = currentState, saveManager.displayData);
				
			case SSaveScreen:
				system.showSaveScreen(saveGame, function() gameState = currentState, saveManager.displayData);
				
			case SGameMenu:
				system.showGameMenu(function(action)
				{
					switch (action) 
					{
						case AShowMainMenu:
							gameState = SMainMenu;
						case AShowSaveMenu:
							gameState = SSaveScreen;
						case AShowLoadMenu:
							gameState = SLoadScreen;
					}
				}, function() gameState = currentState);
				
			default:
				
		}
		
		// don't process input during state change
		Events.skip(interactionManager.movementKeyListener);
		
		return gameState = v;
	}
}

private class DelayedCall
{
	public var callback:Void->Void;
	public var callAt:Float;
	
	public function new(callback, callAt)
	{
		this.callback = callback;
		this.callAt = callAt;
	}
}

enum GameState
{
	SMainMenu;
	SGame;
	SGameMenu;
	SLoadScreen;
	SSaveScreen;
}

enum GameMenuAction
{
	AShowMainMenu;
	AShowSaveMenu;
	AShowLoadMenu;
}

enum LogLevel
{
	LError;
	LInfo;
	LWarn;
}


typedef EngineOptions = 
{
	game:Class<hare.impl.Game>,
	music:Class<hare.impl.Music>,
	sound:Class<hare.impl.Sound>,
	assets:Class<hare.impl.Assets>,
	screen:Class<hare.impl.Screen>,
	system:Class<hare.impl.System>,
	message:Class<hare.impl.Message>,
	movement:Class<hare.impl.Movement>,
	renderer:Class<hare.impl.Renderer>,
}