package impl.flixel.display;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import rpg.Engine;
import rpg.Events;
import rpg.geom.Rectangle;
import rpg.input.InputManager.InputKey;

/**
 * ...
 * @author Kevin
 */
class SaveLoadScreen extends FlxSpriteGroup
{
	private var engine:Engine;
	private var listener:Int;
	
	private var selector:Slice9Sprite;
	private var title:FlxText;
	
	private var selected(default, set):Int;
	
	private var callback:Int->Void;
	private var cancelCallback:Void->Void;
	
	public function new(engine:Engine) 
	{
		super();
		this.engine = engine;
		
		var background = new FlxSprite();
		background.loadGraphic("assets/images/system.png", true, 64, 64);
		background.origin.set();
		background.alpha = 0.95;
		background.setGraphicSize(FlxG.width, FlxG.height);
		
		selector = new Slice9Sprite("assets/images/system.png", new Rectangle(64, 64, 32, 32), new Rectangle(64 + 8, 64 + 8, 16, 16));
		selector.setPosition(5, 10);
		selector.setGraphicSize(168, 21);
		
		add(background);
		add(selector);
		add(title = new FlxText(0, 0, 100, ""));
		
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
					callback(selected + 1);
					Events.disable(listener);
					
				case KEsc:
					cancelCallback();
					Events.disable(listener);
					
				default:
			}
		});
		Events.disable(listener);
	}
	
	public function showSaveScreen(callback:Int->Void, cancelCallback:Void->Void):Void
	{
		title.text = "Save Game";
		
		this.callback = callback;
		this.cancelCallback = cancelCallback;
		selected = 0;
		Events.enable(listener);
	}
	
	public function showLoadScreen(callback:Int->Void, cancelCallback:Void->Void):Void
	{
		title.text = "Load Game";
		
		this.callback = callback;
		this.cancelCallback = cancelCallback;
		selected = 0;
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