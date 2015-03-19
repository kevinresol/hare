package rpg.event;
import rpg.Engine;

/**
 * ...
 * @author Kevin
 */
class EventManager
{
	public var currentEvent:Int;
	
	private var engine:Engine;
	private var lua:Lua;
	private var registeredIds:Array<Int>;
	private var scriptHost:ScriptHost;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
		registeredIds = [];
		
		scriptHost = new ScriptHost(engine);
		
		lua = new Lua();
		lua.loadLibs(["base", "coroutine"]);
		lua.setVars({
			host_showText: scriptHost.showText,
			host_teleportPlayer: scriptHost.teleportPlayer
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
	
	public function resume(id:Int = -1):Void
	{
		if (id == -1)
			id = currentEvent;
		execute('coroutine.resume(co$id)');
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
		return lua.execute(script);
	}
}