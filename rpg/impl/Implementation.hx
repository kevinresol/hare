package rpg.impl;
import minject.Injector;
import rpg.image.Image;

/**
 * ...
 * @author Kevin
 */
class Implementation
{
	@inject
	public var engine:Engine;
	
	public var injector(get, never):Injector;
	
	public function new()
	{
		
	}
	
	public function init(mainMenuBackgroundImage:Image):Void
	{
		
	}
	
	public function update(elapsed:Float):Void
	{
		
	}
	
	private inline function get_injector():Injector return engine.injector;
}
