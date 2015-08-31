package;

import flixel.FlxState;
import impl.flixel.Assets;
import rpg.Engine;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		var engine = new Engine({
			game:impl.flixel.Game,
			music:impl.flixel.Music,
			sound:impl.flixel.Sound,
			assets:impl.flixel.Assets,
			screen:impl.flixel.Screen,
			system:impl.flixel.System,
			message:impl.flixel.Message,
			movement:impl.flixel.Movement,
			renderer:impl.flixel.Renderer,
		});
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
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