package impl.flixel.display;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import rpg.Events;
import rpg.geom.Rectangle;
import rpg.input.InputManager.InputKey;

/**
 * ...
 * @author Kevin
 */
class SaveLoadScreen extends FlxSpriteGroup
{
	private var listener:Int;
	
	private var selector:Slice9Sprite;
	private var title:FlxText;
	private var sections:Array<Section>;
	
	private var numSaves:Int;
	private var selected(default, set):Int;
	
	private var callback:Int->Void;
	private var cancelCallback:Void->Void;
	
	private var mode:SaveLoadScreenMode;
	private var page(default, set):Int;
	
	public function new() 
	{
		super();
		
		var background = new FlxSprite();
		background.loadGraphic("assets/images/system/system.png", true, 64, 64);
		background.origin.set();
		background.alpha = 0.95;
		background.setGraphicSize(FlxG.width, FlxG.height);
		
		selector = new Slice9Sprite("assets/images/system/system.png", new Rectangle(64, 64, 32, 32), new Rectangle(64 + 8, 64 + 8, 16, 16));
		selector.setPosition(15, 10);
		selector.setGraphicSize(100, 21);
		
		add(background);
		
		sections = [];
		for (i in 0...3)
		{
			var s = new Section(0,150*i+30);
			sections.push(s);
			add(s);
		}
		
		add(selector);
		add(title = new FlxText(0, 0, 0, "", 20));
		
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
					callback(selected);
					Events.disable(listener);
					
				case KEsc:
					cancelCallback();
					Events.disable(listener);
					
				default:
			}
		});
		Events.disable(listener);
	}
	
	public function showSaveScreen(numSaves:Int, callback:Int->Void, cancelCallback:Void->Void):Void
	{
		title.text = "Save Game";
		mode = MSave;
		show(numSaves + 1, callback, cancelCallback);
	}
	
	public function showLoadScreen(numSaves:Int, callback:Int->Void, cancelCallback:Void->Void):Void
	{
		title.text = "Load Game";
		mode = MLoad;
		show(numSaves, callback, cancelCallback);
	}
	
	public function show(numSaves:Int, callback:Int->Void, cancelCallback:Void->Void):Void
	{
		visible = true;
		
		this.numSaves = numSaves;
		this.callback = callback;
		this.cancelCallback = cancelCallback;
		selected = 0;
		Events.enable(listener);
	}
	
	private function set_selected(v:Int):Int
	{
		if (v < 0) v = numSaves - 1;
		else if (v >= numSaves) v = 0;
		
		page = Std.int(v / 3);
		
		selector.y = y + 42 + 150 * (v % 3);
		
		return selected = v;
	}
	
	private function set_page(v:Int):Int
	{
		if (page == v) return v;
		var index = v * 3;
		
		for (i in 0...3)
		{
			sections[i].set(index + i + 1);
			sections[i].visible = (index + i < numSaves);
		}
		
		return page = v;
	}
}

private class Section extends FlxSpriteGroup
{
	private var border:Slice9Sprite;
	private var text:FlxText;
	
	public function new(x, y)
	{
		super(x,y);
		
		border = new Slice9Sprite("assets/images/system/system.png", new Rectangle(64, 0, 64, 64), new Rectangle(64+16, 16, 32, 32));
		border.setGraphicSize(640, 150);
		
		text = new FlxText(20, 10, 0, "", 18);
		
		add(border);
		add(text);
	}
	
	public function set(id:Int):Void
	{
		text.text = 'Save: $id';
	}
}

enum SaveLoadScreenMode
{
	MSave;
	MLoad;
}