package rpg;
import impl.IImplementation;
import rpg.event.EventManager;
import rpg.input.InputManager;
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
	private var mapManager:MapManager;
	private var eventManager:EventManager;
	private var inputManager:InputManager;
	private var interactionManager:InteractionManager;
	private var saveManager:SaveManager;
	
	private var gameState(default, set):GameState;
	
	private var delayedCalls:Array<DelayedCall>;
	private var called:Array<DelayedCall>;
	
	public function new(impl:IImplementation) 
	{
		this.impl = impl;
		impl.engine = this;
		delayedCalls = [];
		called = [];
		
		mapManager = new MapManager(this);
		eventManager = new EventManager(this);
		inputManager = new InputManager(this);
		interactionManager = new InteractionManager(this);
		saveManager = new SaveManager(this);
		
		gameState = SMainMenu;
	}
	
	/**
	 * Start new game
	 */
	public function startGame():Void
	{
		gameState = SGame;
		mapManager.currentMap = mapManager.getMap(1); // always start game at map 1
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
		
		var now = Sys.time();
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
		delayedCalls.push(new DelayedCall(callback, Sys.time() + ms / 1000));
	}
	
	private inline function get_currentMap():GameMap
	{
		return mapManager.currentMap;
	}
	
	private function set_gameState(v:GameState):GameState
	{
		if (gameState == v) return v;
		
		var currentState = gameState;
		
		#if neko if(currentState != null) #end
		switch (currentState) 
		{
			case SMainMenu:
				impl.hideMainMenu();
				
			case SLoadScreen:
				impl.hideLoadScreen();
				
			case SSaveScreen:
				impl.hideSaveScreen();
				
			default:
				
		}
		
		switch (v) 
		{
			case SMainMenu:
				impl.showMainMenu(startGame, function() gameState = SLoadScreen);
				
			case SLoadScreen:
				impl.showLoadScreen(loadGame, function() gameState = currentState);
				
			case SSaveScreen:
				impl.showSaveScreen(saveGame, function() gameState = currentState);
				
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
