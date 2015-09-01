package impl.flixel.display;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import openfl.system.System;
import rpg.Events;
import rpg.image.Image;
import rpg.impl.Sound;
import rpg.input.InputManager.InputKey;

/**
 * ...
 * @author Kevin
 */
class MainMenu extends FlxSpriteGroup
{
	private var border:Slice9Sprite;
	private var background:FlxSprite;
	private var selector:Slice9Sprite;
	
	private var listener:Int;
	private var selected(default, set):Int;
	private var startGameCallback:Void->Void;
	private var loadGameCallback:Void->Void;
	
	@inject
	public var sound:Sound;

	public function new() 
	{
		super();
		
		border = new Border(0, 0, 180, 80);
		border.x = (FlxG.width - border.width) / 2;
		border.y = FlxG.height * 0.75;
		
		selector = new Selector(10, 10, 159, 20);
		selector.x = border.x + 10;
		
		background = new FlxSprite();
		background.makeGraphic(1, 1, 0);
		//add(background);
		
		var items = ["New Game", "Load Game", "Quit Game"];
		for (i in 0...items.length)
		{
			var item = items[i];
			var text = new Text(border.x, border.y + 9 + 19 * i, 170, item, 16);
			text.alignment = CENTER;
			add(text);
		}
		selected = 0;
		
		
		add(border);
		add(selector);
		
		visible = false;
		
		listener = Events.on("key.justPressed", function(key:InputKey)
		{
			switch (key) 
			{
				case KUp:
					sound.playSystemSound(1, 1);
					selected -= 1;
					
				case KDown:
					sound.playSystemSound(1, 1);
					selected += 1;
					
				case KEnter:
					visible = false;
					sound.playSystemSound(1, 1);
					
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
	
	public function setBackgroundImage(image:Image):Void
	{
		if (image != null)
			background.loadGraphic(image.source);
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
		
		selector.y = y + border.y + 11 + 19 * v;
		
		return selected = v;
	}
	
}