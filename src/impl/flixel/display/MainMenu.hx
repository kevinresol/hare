package impl.flixel.display;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import openfl.system.System;
import rpg.Engine;
import rpg.Events;
import rpg.geom.Rectangle;
import rpg.input.InputManager.InputKey;

/**
 * ...
 * @author Kevin
 */
class MainMenu extends FlxSpriteGroup
{
	private var engine:Engine;
	
	private var border:Slice9Sprite;
	private var selector:Slice9Sprite;
	private var text:FlxText;
	
	private var selectorTween:FlxTween;
	
	private var listener:Int;
	private var selected(default, set):Int;

	public function new(engine:Engine) 
	{
		super();
		
		this.engine = engine;
		
		border = new Slice9Sprite("assets/images/system.png", new Rectangle(64, 0, 64, 64), new Rectangle(64+16, 16, 32, 32));
		border.setGraphicSize(180, 80);
		
		selector = new Slice9Sprite("assets/images/system.png", new Rectangle(64, 64, 32, 32), new Rectangle(64 + 8, 64 + 8, 16, 16));
		selector.setPosition(5, 10);
		selector.setGraphicSize(168, 21);
		
		text = new FlxText(0, 11, 170, "New Game\nLoad Game\nQuit Game", 15);
		text.alignment = CENTER;
		selected = 0;
		
		selectorTween = FlxTween.num(1, 0.5, 0.5, { type:FlxTween.PINGPONG }, function(v) selector.alpha = v);
		
		add(border);
		add(selector);
		add(text);
		
		listener = Events.on("key.justPressed", function(key:InputKey)
		{
			switch (key) 
			{
				case KUp:
					selected -= 1;
					
				case KDown:
					selected += 1;
					
				case KEnter:
					switch (selected) 
					{
						case 0: // New Game
							engine.startGame();
							Events.disable(listener);
							
						case 1: // Load Game
							// show save file selection screen
							
						case 2: // Quit Game
							System.exit();
							
						default:
					}
					
				default:
					
			}
		});
	}
	
	private function set_selected(v:Int):Int
	{
		if (v < 0) v = 2;
		else if (v >= 3) v = 0;
		
		selector.y = y + 10 + 19 * v;
		
		return selected = v;
	}
	
}