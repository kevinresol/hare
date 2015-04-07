package impl.flixel.display;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import impl.flixel.Implementation;
import openfl.system.System;
import rpg.Events;
import rpg.input.InputManager.InputKey;

/**
 * ...
 * @author Kevin
 */
class MainMenu extends FlxSpriteGroup
{
	private var border:Slice9Sprite;
	private var selector:Slice9Sprite;
	
	private var selectorTween:FlxTween;
	
	private var listener:Int;
	private var selected(default, set):Int;
	private var startGameCallback:Void->Void;
	private var loadGameCallback:Void->Void;

	public function new(impl:Implementation) 
	{
		super();
		
		border = new Border(0, 0, 180, 80);
		selector = new Selector(10, 10, 159, 20);
		
		var items = ["New Game", "Load Game", "Quit Game"];
		for (i in 0...items.length)
		{
			var item = items[i];
			var text = new Text(0, 9 + 19 * i, 170, item, 16);
			text.alignment = CENTER;
			add(text);
		}
		selected = 0;
		
		selectorTween = FlxTween.num(1, 0.5, 0.5, { type:FlxTween.PINGPONG }, function(v) selector.alpha = v);
		
		add(border);
		add(selector);
		
		visible = false;
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
					visible = false;
					impl.playSystemSound(1, 1);
					
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
		visible = true;
		this.startGameCallback = startGameCallback;
		this.loadGameCallback = loadGameCallback;
		selected = 0;
		Events.enable(listener);
	}
	
	private function set_selected(v:Int):Int
	{
		if (v < 0) v = 2;
		else if (v >= 3) v = 0;
		
		selector.y = y + 11 + 19 * v;
		
		return selected = v;
	}
	
}