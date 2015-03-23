package rpg;
import impl.IImplementation;
import rpg.event.EventManager;
import rpg.input.InputManager;
import rpg.map.GameMap;
import rpg.map.MapManager;
import rpg.movement.InteractionManager;

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
	
	private var gameState:GameState;
	
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
		
		gameState = SMainMenu;
		impl.showMainMenu();
		
	}
	
	public function startGame():Void
	{
		gameState = SGame;
		impl.hideMainMenu();
		mapManager.currentMap = mapManager.getMap(1); // always start game at map 1
	}
	
	public function loadGame(id:Int):Void
	{
		//TODO: request file contents from asset manager
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
}
