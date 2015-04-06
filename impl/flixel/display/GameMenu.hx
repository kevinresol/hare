package impl.flixel.display;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import rpg.Engine.GameMenuAction;
import rpg.Events;
import rpg.input.InputManager.InputKey;

/**
 * ...
 * @author Kevin
 */
class GameMenu extends FlxSpriteGroup
{
	private var listener:Int;
	
	private var selector:Slice9Sprite;
	private var title:Text;
	private var text:Text;
	
	private var selected(default, set):Int;
	
	private var callback:GameMenuAction->Void;
	private var cancelCallback:Void->Void;
	
	public function new() 
	{
		super();
		
		var background = new FlxSprite();
		background.loadGraphic("assets/images/system/system.png", true, 64, 64);
		background.origin.set();
		background.alpha = 0.8;
		background.setGraphicSize(FlxG.width, FlxG.height);
		
		selector = new Selector(5, 10, 168, 21);
		
		text = new Text(15, 30, 0, "Main Menu\nSave Game", 15);
		
		add(background);
		add(selector);
		add(title = new Text(0, 0, 0, "Game Menu", 20));
		add(text);
		
		visible = false;
		scrollFactor.set();
		
		listener = Events.on("key.justPressed", function(key:InputKey)
		{
			switch (key) 
			{
				case KUp:
					selected --;
				
				case KDown:
					selected ++;
					
				case KEnter:
					switch (selected) 
					{
						case 0: callback(AShowMainMenu);
						case 1: callback(AShowSaveMenu);
						default:
					}
					Events.disable(listener);
					
				case KEsc:
					cancelCallback();
					Events.disable(listener);
					
				default:
			}
		});
		Events.disable(listener);
	}
	
	public function show(callback:GameMenuAction->Void, cancelCallback:Void->Void):Void
	{
		visible = true;
		this.callback = callback;
		this.cancelCallback = cancelCallback;
		selected = 0;
		Events.enable(listener);
	}
	
	private function set_selected(v:Int):Int
	{
		if (v < 0) v = 1;
		else if (v >= 2) v = 0;
		
		selector.y = y + 30 + 19 * v;
		
		return selected = v;
	}
}