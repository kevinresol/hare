package rpg.impl;
import rpg.Engine;

/**
 * ...
 * @author Kevin
 */
class Module
{
	var impl:Implementation;
	var engine(get, never):Engine;
	
	public function new(impl) 
	{
		this.impl = impl;
	}
	
	private inline function get_engine():Engine return impl.engine;
}