package rpg;
import haxe.Json;
import haxe.Timer;
import impl.IAssetManager;
import impl.IImplementation;
import rpg.event.EventManager;
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
	
	private var impl:IImplementation;
	private var assetManager:IAssetManager;
	
	private var mapManager:MapManager;
	private var eventManager:EventManager;
	private var inputManager:InputManager;
	private var interactionManager:InteractionManager;
	private var saveManager:SaveManager;
	private var itemManager:ItemManager;
	
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
		
		gameState = SMainMenu;
	}
	
	/**
	 * Start new game
	 */
	public function startGame():Void
	{
		// init items
		var config = assetManager.getConfig(); 
		itemManager.init(config.items);
		
		gameState = SGame;
		
		// always start game at map 1
		var map = mapManager.getMap(1); 
		
		// teleport player to place
		if (map.player != null)
		{
			impl.createPlayer(map.player.name, map.player.imageSource);
			eventManager.scriptHost.teleportPlayer(1, map.player.x, map.player.y, {facing:"down"});
		}
		else
			throw "Player (an object with type=player) must be placed in Map 1";
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
				impl.showMainMenu(startGame, function() gameState = SLoadScreen);
				
			case SLoadScreen:
				impl.showLoadScreen(loadGame, function() gameState = currentState);
				
			case SSaveScreen:
				impl.showSaveScreen(saveGame, function() gameState = currentState);
				
			case SGameMenu:
				impl.showGameMenu(function() gameState = currentState);
				
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

