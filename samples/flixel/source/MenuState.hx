package;

import flixel.FlxG;
import flixel.FlxState;
import impl.flixel.Assets;
import impl.flixel.HareFlixel;
import hare.Engine;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	var engine:Engine;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		HareFlixel.state = this;
		engine = new Engine({
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
		engine.update(elapsed);
		
		var justPressed = FlxG.keys.justPressed;
		var justReleased = FlxG.keys.justReleased;
		
		if (justReleased.LEFT)
			engine.release(KLeft);
		if (justReleased.RIGHT)
			engine.release(KRight);
		if (justReleased.UP)
			engine.release(KUp);
		if (justReleased.DOWN)
			engine.release(KDown);
		if (justReleased.ENTER || justReleased.SPACE)
			engine.release(KEnter);
		if (justReleased.ESCAPE)
			engine.release(KEsc);
			
		if (justPressed.LEFT)
			engine.press(KLeft);
		if (justPressed.RIGHT)
			engine.press(KRight);
		if (justPressed.UP)
			engine.press(KUp);
		if (justPressed.DOWN)
			engine.press(KDown);
		if (justPressed.ENTER || justPressed.SPACE)
			engine.press(KEnter);
		if (justPressed.ESCAPE)
			engine.press(KEsc);
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