package rpg.event;
import rpg.Engine;

/**
 * ...
 * @author Kevin
 */
class EventManager
{
	private var engine:Engine;
	private var lua:Lua;
	private var registeredIds:Array<Int>;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
		registeredIds = [];
		
		lua = new Lua();
		lua.loadLibs(["base", "coroutine"]);
		lua.setVars({host_showText:engine.impl.host.showText});
		
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
	
	private inline function execute(script:String):Void
	{
		var r = lua.execute(script);
		//trace(r);
	}
}