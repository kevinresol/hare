package rpg.event;
import rpg.Engine;

/**
 * ...
 * @author Kevin
 */
class ScriptHost
{
	private var engine:Engine;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
	}
	
	public function showText(message) 
	{
		engine.disableMovement();
		engine.impl.host.showText(function(){engine.enableMovement(); engine.eventManager.resume();}, message);
	}
}