package;

import flixel.FlxState;
import impl.flixel.Implementation;
import rpg.Engine;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	private var impl:Implementation;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		impl = new Implementation(this);
		var engine = new Engine(impl, impl.assetManager);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		impl.update(elapsed);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

}