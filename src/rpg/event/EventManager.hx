package rpg.event;
import rpg.Engine;
import rpg.save.SaveManager.GameData;

/**
 * ...
 * @author Kevin
 */
class EventManager
{
	public var currentEvent:Int = -1;
	public var scriptHost:ScriptHost;
	
	private var engine:Engine;
	private var lua:Lua;
	private var pendingResumes:Array<{id:Int, data:Dynamic}>;
	private var erasedEvents:Array<Int>;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
		pendingResumes = [];
		
		scriptHost = new ScriptHost(engine);
		
		lua = new Lua();
		lua.loadLibs(["base", "coroutine"]);
		lua.setVars( {
			game: {
				variables: {},
				eventVariables: {}
			},
			
			host_eraseEvent: eraseEvent,
			
			host_playSound: scriptHost.playSound,
			host_playBackgroundMusic: scriptHost.playBackgroundMusic,
			host_saveBackgroundMusic: scriptHost.saveBackgroundMusic,
			host_restoreBackgroundMusic: scriptHost.restoreBackgroundMusic,
			host_fadeOutBackgroundMusic: scriptHost.fadeOutBackgroundMusic,
			host_fadeInBackgroundMusic: scriptHost.fadeInBackgroundMusic,
			
			host_fadeOutScreen: scriptHost.fadeOutScreen,
			host_fadeInScreen: scriptHost.fadeInScreen,
			
			host_showText: scriptHost.showText,
			host_showChoices: scriptHost.showChoices,
			host_teleportPlayer: scriptHost.teleportPlayer,
			
			host_sleep: scriptHost.sleep,
			host_log: scriptHost.log,
			host_showSaveScreen: scriptHost.showSaveScreen,
		});
		
		var bridgeScript = EventMacro.getBridgeScript();
		var result = execute(bridgeScript);
		
		#if debug
		trace("bridge script result: " + result);
		#end
		
		Events.on("map.switched", function(_) erasedEvents = []);
	}
	
	public function update(elapsed:Float):Void
	{
		if (currentEvent == -1 && engine.gameState == SGame) // no other events running
		{
			for (event in engine.mapManager.currentMap.events)
			{
				switch (event.trigger) 
				{
					case EAutorun:
						if(erasedEvents.indexOf(event.id) == -1) // not in erased list
							trigger(event.id);
						break;
						
					default:
						
				}
			}
		}
	}
	
	/**
	 * Trigger a event (i.e. start running a piece of Lua script)
	 * @param	id
	 */
	public function trigger(id:Int):Void
	{
		currentEvent = id;
		engine.interactionManager.disableMovement();
		
		// prepare current-event functions
		var init = 'game.eventVariables[$id] = game.eventVariables[$id] or {}';
		var getEventVar = 'local getEventVar = function(name) return game.eventVariables[$id][name] end';
		var setEventVar = 'local setEventVar = function(name, value) game.eventVariables[$id][name] = value end';
		var eraseEvent = 'local eraseEvent = function() host_eraseEvent($id) end';
		
		// get event script
		var body = engine.impl.assetManager.getScript(engine.currentMap.id, id);
		
		// execute script
		var script = 'co$id = coroutine.create(function() $init $getEventVar $setEventVar $eraseEvent $body end)';
		execute(script);
		resume(id);
	}
	
	public function endEvent():Void
	{
		currentEvent = -1;
		engine.interactionManager.enableMovement();
	}
	
	/**
	 * Resume a Lua script (which was halted by coroutine.yield())
	 * @param	id
	 * @param	data
	 */
	public function resume(id:Int = -1, ?data:ResumeData):Void
	{
		if (id == -1)
			id = currentEvent;
		
		var params = dataToString(data);
		
		execute('coroutine.resume(co$id $params)');
		
		if (execute('return coroutine.status(co$id)') == "dead")
			endEvent();
		
	}
	
	public function eraseEvent(id:Int):Void
	{
		erasedEvents.push(id);
	}
	
	public function getGameData():GameData
	{
		return execute('return game');
	}
	
	public function setGameData(data:GameData):Void
	{
		lua.setVars({game:data});
	}
	
	private inline function execute(script:String):Dynamic
	{
		return lua.execute(script);
	}
	
	/**
	 * Helper function for converting data into Lua script strings
	 * @param	data
	 * @return
	 */
	private function dataToString(data:ResumeData):String
	{
		if (data == null)
			return '';
		if (Std.is(data, String))
			return ', "$data"';
		if (Std.is(data, Int) || Std.is(data, Float))
			return ', $data';
			
		throw "unsupported data";
	}
}

typedef ResumeData = OneOfThree<String, Int, Float>;

private abstract OneOfTwo<T1, T2>(Dynamic) from T1 from T2 to T1 to T2 { }
private abstract OneOfThree<T1, T2, T3>(Dynamic) from T1 from T2 from T3 to T1 to T2 to T3 {}
private abstract OneOfFour<T1, T2, T3, T4>(Dynamic) from T1 from T2 from T3 from T4 to T1 to T2 to T3 to T4 { }
private abstract OneOfFive<T1, T2, T3, T4, T5>(Dynamic) from T1 from T2 from T3 from T4 from T5 to T1 to T2 to T3 to T4 to T5 { }
