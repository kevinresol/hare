package impl.flixel.display;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import impl.flixel.Implementation;
import openfl.system.System;
import rpg.Events;
import rpg.geom.Rectangle;
import rpg.input.InputManager.InputKey;

/**
 * ...
 * @author Kevin
 */
class MainMenu extends FlxSpriteGroup
{
	private var border:Slice9Sprite;
	private var selector:Slice9Sprite;
	private var text:FlxText;
	
	private var selectorTween:FlxTween;
	
	private var listener:Int;
	private var selected(default, set):Int;
	private var startGameCallback:Void->Void;
	private var loadGameCallback:Void->Void;

	public function new(impl:Implementation) 
	{
		super();
		
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
		
		x = (FlxG.width - width) / 2;
		y = FlxG.height * 0.75;
		
		listener = Events.on("key.justPressed", function(key:InputKey)
		{
			switch (key) 
			{
				case KUp:
					impl.playSystemSound(1, 1);
					selected -= 1;
					
				case KDown:
					impl.playSystemSound(1, 1);
					selected += 1;
					
				case KEnter:
					switch (selected) 
					{
						case 0: // New Game
							Events.disable(listener);
							startGameCallback();
							
						case 1: // Load Game
							Events.disable(listener);
							loadGameCallback();
							
						case 2: // Quit Game
							System.exit(0);
							
						default:
					}
					
				default:
					
			}
		});
		Events.disable(listener);
	}
	
	public function show(startGameCallback:Void->Void, loadGameCallback:Void->Void):Void
	{
		this.startGameCallback = startGameCallback;
		this.loadGameCallback = loadGameCallback;
		Events.enable(listener);
	}
	
	private function set_selected(v:Int):Int
	{
		if (v < 0) v = 2;
		else if (v >= 3) v = 0;
		
		selector.y = y + 10 + 19 * v;
		
		return selected = v;
	}
	
}