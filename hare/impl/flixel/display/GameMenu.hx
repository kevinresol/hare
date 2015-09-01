package hare.impl.flixel.display;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import hare.input.InputManager;
import hare.Engine.GameMenuAction;
import hare.Events;
import hare.input.InputManager.InputKey;

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
	private var numChoices:Int;
	
	public function new() 
	{
		super();
		
		var background = new FlxSprite();
		background.loadGraphic("assets/images/system/system.png", true, 64, 64);
		background.origin.set();
		background.alpha = 0.8;
		background.setGraphicSize(FlxG.width, FlxG.height);
		
		selector = new Selector(5, 10, 168, 21);
		
		text = new Text(15, 30, 0, "Main Menu\nSave Game"#if debug + "\nConsole" #end , 15);
		numChoices = 2 #if debug + 1 #end;
		
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
						#if debug
						case 2: FlxG.debugger.visible = !FlxG.debugger.visible; cancelCallback();
						#end
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
		if (v < 0) v = numChoices -1;
		else if (v >= numChoices) v = 0;
		
		selector.y = y + 30 + 19 * v;
		
		return selected = v;
	}
}