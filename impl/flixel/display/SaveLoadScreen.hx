package impl.flixel.display;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import rpg.Events;
import rpg.input.InputManager.InputKey;

/**
 * ...
 * @author Kevin
 */
class SaveLoadScreen extends FlxSpriteGroup
{
	public static inline var NUM_SAVES_PER_PAGE:Int = 4;
	
	private var listener:Int;
	
	private var selector:Slice9Sprite;
	private var title:Text;
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
		background.alpha = 0.8;
		background.setGraphicSize(FlxG.width, FlxG.height);
		
		selector = new Selector(15, 10, 100, 21);
		
		add(background);
		
		sections = [];
		for (i in 0...NUM_SAVES_PER_PAGE)
		{
			var h = Std.int(450 / NUM_SAVES_PER_PAGE);
			var s = new Section(0, h * i + 30, FlxG.width, h);
			sections.push(s);
			add(s);
		}
		
		add(selector);
		add(title = new Text(0, 0, 0, "", 24));
		
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
		
		page = Std.int(v / NUM_SAVES_PER_PAGE);
		
		selector.y = y + 42 + Std.int(450 / NUM_SAVES_PER_PAGE) * (v % NUM_SAVES_PER_PAGE);
		
		return selected = v;
	}
	
	private function set_page(v:Int):Int
	{
		var index = v * NUM_SAVES_PER_PAGE;
		
		for (i in 0...NUM_SAVES_PER_PAGE)
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
	private var text:Text;
	
	public function new(x, y, w, h)
	{
		super(x,y);
		
		border = new Border(0, 0, w, h);
		text = new Text(20, 10, 0, "", 16);
		
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