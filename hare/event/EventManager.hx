package hare.event;
import hare.event.Event;
import hare.Events;
import hare.map.GameMap;
import hare.save.SaveManager;
import haxe.Json;
import lua.Lua;
import hare.Engine;
import hare.geom.Direction;
import hare.impl.Assets;
import hare.save.SaveManager.GameData;

using Lambda;
/**
 * ...
 * @author Kevin
 */
class EventManager
{
	public var currentEvent:Int = -1;
	
	@inject
	public var scriptHost:ScriptHost;
	
	private var lua:Lua;
	private var erasedEvents:Array<Int>;
	private var pendingTrigger:Array<Int>;
	private var events:Map<String, Event>;
	
	@inject
	public var assets:Assets;
	
	@inject
	public var engine:Engine;
	
	@inject
	public function new(scriptHost:ScriptHost) 
	{
		events = new Map();
		pendingTrigger = [];
		
		lua = new Lua();
		lua.loadLibs(["base", "coroutine"]);
		lua.setVars( {
			// for events...
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
			host_inputNumber: scriptHost.inputNumber,
			
			host_changeFacing: scriptHost.changeFacing,
			host_teleportPlayer: scriptHost.teleportPlayer,
			host_setMoveRoute: scriptHost.setMoveRoute,
			
			host_changeItem: scriptHost.changeItem,
			host_getItem: scriptHost.getItem,
			
			host_sleep: scriptHost.sleep,
			host_log: scriptHost.log,
			host_showSaveScreen: scriptHost.showSaveScreen,
			host_eraseEvent: eraseEvent,
			
			// for retrieving game info in Lua...
			getPlayerPosition: function() { var p = engine.interactionManager.player; return { x:p.position.x, y:p.position.y, facing:Direction.toString(p.facing) }},
			
		});
		
		var bridgeScript = EventMacro.getBridgeScript();
		var result = execute(bridgeScript);
		
		#if debug
		trace("bridge script result: " + result);
		#end
		
		Events.on("map.switched", function(map) if(map != null) erasedEvents = []);
	}
	
	public function reset():Void
	{
		lua.setVars({
			game: {
				variables: {},
				eventVariables: {}
			}
		});
	}
	
	public function update(elapsed:Float):Void
	{
		if (currentEvent == -1 && engine.gameState == SGame) // no other events running
		{
			for (object in engine.mapManager.currentMap.objects)
			{
				if (object.event != null && object.event.currentPage.trigger == EAutorun)
				{
					startEvent(object.id);
					break; // break the for loop
				}
			}
		}
		
		// quick and dirty: update pages every frame 
		// (should update only when something happens such as game var changed)
		updatePages();
	}
	
	public function updatePages():Void
	{
		if (engine.currentMap == null) return;
		var currentMapId = engine.currentMap.id;
		for (event in events)
		{
			if(event.mapId == currentMapId) for (page in event.pages)
			{
				if (page.conditions == null || execute("return " + page.conditions) == true)
				{
					event.currentPage = page;
					break;
				}
			}
		}
	}
	
	public function getEvent(eventId:Int, ?mapId:Int):Event
	{
		if (mapId == null) mapId = engine.currentMap.id;
		var gid = '$mapId-$eventId';
		if (!events.exists(gid))
		{
			var mapEventData:Array<EventData> = Json.parse(assets.getEventData(mapId));
			if (mapEventData == null) throw 'EventData for mapID=$mapId not defined';
			
			var eventData:EventData = mapEventData.find(function(e) return e.id == eventId);
			if (eventData == null) throw 'EventData for mapID=$mapId, eventID=$eventId not defined';
			
			var pageData:Array<EventPageData> = eventData.pages;
			
			for (i in 0...pageData.length)
			{
				var data = pageData[i];
				if (data.script == null)
					data.script = assets.getScript(mapId, eventId, i);
				else
				{
					var s = data.script.split(",").map(function(s) return Std.parseInt(s));
					data.script = assets.getScript(s[0], s[1], s[2]); 
				}
			}
			events[gid] = new Event(mapId, eventId, pageData);
		}
		
		return events[gid];
	}
	
	/**
	 * Trigger a event (i.e. start running a piece of Lua script)
	 * @param	id
	 */
	public function startEvent(id:Int):Void
	{
		// erased
		if (erasedEvents.indexOf(id) != -1)
			return;
			
		// an event already running...
		if (currentEvent != -1)
		{
			pendingTrigger.push(id);
			return;
		}
		
		currentEvent = id;
		engine.interactionManager.disableMovement();
		
		// prepare current-event functions
		var init = 'game.eventVariables[$id] = game.eventVariables[$id] or {}';
		var getEventVar = 'local getEventVar = function(name) return game.eventVariables[$id][name] end';
		var setEventVar = 'local setEventVar = function(name, value) game.eventVariables[$id][name] = value end';
		var eraseEvent = 'local eraseEvent = function() host_eraseEvent($id) end';
		
		// get event script
		var body = getEvent(id).currentPage.script;
		
		// execute script
		var script = 'co$id = coroutine.create(function() $init $getEventVar $setEventVar $eraseEvent $body end)';
		execute(script);
		resume(id);
	}
	
	public function endEvent():Void
	{
		currentEvent = -1;
		engine.interactionManager.enableMovement();
		
		if (pendingTrigger.length > 0)
			startEvent(pendingTrigger.shift());
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
		Events.dispatch("event.erased", id);
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
			
		engine.log("unsupported data", LError);
		return '';
	}
}

typedef ResumeData = OneOfThree<String, Int, Float>;

private abstract OneOfTwo<T1, T2>(Dynamic) from T1 from T2 to T1 to T2 { }
private abstract OneOfThree<T1, T2, T3>(Dynamic) from T1 from T2 from T3 to T1 to T2 to T3 {}
private abstract OneOfFour<T1, T2, T3, T4>(Dynamic) from T1 from T2 from T3 from T4 to T1 to T2 to T3 to T4 { }
private abstract OneOfFive<T1, T2, T3, T4, T5>(Dynamic) from T1 from T2 from T3 from T4 from T5 to T1 to T2 to T3 to T4 to T5 { }