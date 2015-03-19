package rpg.event;
import rpg.Engine;

/**
 * ...
 * @author Kevin
 */
class EventManager
{
	public var currentEvent:Int;
	public var executing(default, null):Bool;
	public var scriptHost:ScriptHost;
	
	private var engine:Engine;
	private var lua:Lua;
	private var registeredIds:Array<Int>;
	private var pendingResumes:Array<{id:Int, data:Dynamic}>;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
		registeredIds = [];
		pendingResumes = [];
		
		scriptHost = new ScriptHost(engine);
		
		lua = new Lua();
		lua.loadLibs(["base", "coroutine"]);
		lua.setVars({
			host_showText: scriptHost.showText,
			host_showChoices: scriptHost.showChoices,
			host_teleportPlayer: scriptHost.teleportPlayer,
			
			host_sleep: scriptHost.sleep,
			host_log: scriptHost.log,
		});
		
		var bridgeScript = EventMacro.getBridgeScript();
		execute(bridgeScript);
	}
	
	public function update(elapsed:Float):Void
	{
		for (id in registeredIds)
		{
			var script = 'co$id()';
			execute(script);
		}
	}
	
	public function trigger(id:Int):Void
	{
		currentEvent = id;
		var body = engine.impl.assetManager.getScript(id);
		var script = 'co$id = coroutine.create(function() $body end)';
		execute(script);
		resume(id);
	}
	
	public function resume(id:Int = -1, ?data:Dynamic):Void
	{
		if (id == -1)
			id = currentEvent;
			
		if (executing)
			pendingResumes.push({id:id, data:data});
		else
		{
			var params = dataToString(data);
			execute('coroutine.resume(co$id $params)');
		}
	}
	
	public function register(id:Int):Void
	{
		registeredIds.push(id);
		var body = engine.impl.assetManager.getScript(id);
		var script = 'co$id = coroutine.wrap(function() $body end) return true';
		execute(script);
	}
	
	public function unregister(id:Int):Void
	{
		registeredIds.remove(id);
		var script = 'co$id = nil return true';
		execute(script);
	}
	
	private inline function execute(script:String):Dynamic
	{
		executing = true;
		var r = lua.execute(script);
		executing = false;
		
		while(pendingResumes.length > 0)
		{
			var pr = pendingResumes.shift();
			var id = pr.id;
			var params = dataToString(pr.data);
			executing = true;
			lua.execute('coroutine.resume(co$id $params)');
			executing = false;
		}
			
		return r;
	}
	
	private function dataToString(data:Dynamic):String
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