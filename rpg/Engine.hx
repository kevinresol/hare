package rpg;
import haxe.Json;
import haxe.Timer;
import hscript.Interp;
import hscript.Parser;
import impl.IAssetManager;
import impl.IImplementation;
import rpg.config.Config;
import rpg.event.EventManager;
import rpg.image.ImageManager;
import rpg.input.InputManager;
import rpg.item.ItemManager;
import rpg.map.GameMap;
import rpg.map.MapManager;
import rpg.movement.InteractionManager;
import rpg.save.SaveManager;

/**
 * ...
 * @author Kevin
 */
@:allow(rpg)
class Engine
{
	public var currentMap(get, never):GameMap;
	public var config(default, null):Config;
	
	private var impl:IImplementation;
	private var assetManager:IAssetManager;
	
	private var mapManager:MapManager;
	private var eventManager:EventManager;
	private var inputManager:InputManager;
	private var interactionManager:InteractionManager;
	private var saveManager:SaveManager;
	private var itemManager:ItemManager;
	private var imageManager:ImageManager;
	
	private var gameState(default, set):GameState;
	
	private var delayedCalls:Array<DelayedCall>;
	private var called:Array<DelayedCall>;
	
	public function new(impl:IImplementation, assetManager:IAssetManager) 
	{
		this.impl = impl;
		this.assetManager = assetManager;
		
		impl.engine = this;
		
		delayedCalls = [];
		called = [];
		
		mapManager = new MapManager(this);
		eventManager = new EventManager(this);
		inputManager = new InputManager(this);
		interactionManager = new InteractionManager(this);
		saveManager = new SaveManager(this);
		itemManager = new ItemManager(this);
		imageManager = new ImageManager(this);
		
		#if !RPG_ENGINE_EDITOR
		loadConfig();
		gameState = SMainMenu;
		#end
		
		
		var mainMenuBackgroundImage = 
			if (config.mainMenu == null) 
				null
			else
				imageManager.getImage(IMainMenu(config.mainMenu.image), 0);
		impl.init(mainMenuBackgroundImage);
	}
	
	/**
	 * Start new game
	 */
	public function startGame():Void
	{
		// init items
		itemManager.init(config.items);
		
		gameState = SGame;
		
		// always start game at map 1
		var map = mapManager.getMap(1); 
		
		// teleport player to place
		if (map.player != null)
		{
			var image = imageManager.getImage(ICharacter(map.player.image.source), map.player.image.index);
			impl.createPlayer(image);
			eventManager.scriptHost.teleportPlayer(1, map.player.x, map.player.y, {facing:"down"});
			impl.fadeInScreen(200);
		}
		else
			log("Player (an object with type=player) must be placed in Map 1", LError);
	}
	
	public function loadConfig():Void
	{
		var data = try
		{
			Json.parse(assetManager.getConfig());
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
		saveManager.load(id);
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
		impl.log(message, level);
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
					impl.hideMainMenu();
					
				case SLoadScreen:
					impl.hideLoadScreen();
					
				case SSaveScreen:
					impl.hideSaveScreen();
				
				case SGameMenu:
					impl.hideGameMenu();
					
				default:
			}
		}
		
		switch (v) 
		{
			case SMainMenu:
				impl.saveBackgroundMusic();
				mapManager.currentMap = null;
				impl.showMainMenu(startGame, function() gameState = SLoadScreen);
				
			case SLoadScreen:
				impl.showLoadScreen(loadGame, function() gameState = currentState, saveManager.displayData);
				
			case SSaveScreen:
				impl.showSaveScreen(saveGame, function() gameState = currentState, saveManager.displayData);
				
			case SGameMenu:
				impl.showGameMenu(function(action)
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
