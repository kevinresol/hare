package;

import flixel.FlxG;
import flixel.FlxState;
import hare.impl.flixel.Assets;
import hare.impl.flixel.Game;
import hare.impl.flixel.HareFlixel;
import hare.Engine;
import hare.impl.flixel.Message;
import hare.impl.flixel.Movement;
import hare.impl.flixel.Music;
import hare.impl.flixel.Renderer;
import hare.impl.flixel.Screen;
import hare.impl.flixel.Sound;
import hare.impl.flixel.System;

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
			game:hare.impl.flixel.Game,
			music:hare.impl.flixel.Music,
			sound:hare.impl.flixel.Sound,
			assets:hare.impl.flixel.Assets,
			screen:hare.impl.flixel.Screen,
			system:hare.impl.flixel.System,
			message:hare.impl.flixel.Message,
			movement:hare.impl.flixel.Movement,
			renderer:hare.impl.flixel.Renderer,
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