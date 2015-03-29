package impl.flixel.display;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import rpg.Events;
import rpg.geom.Rectangle;
import rpg.input.InputManager.InputKey;

using Lambda;
/**
 * ...
 * @author Kevin
 */
class InputNumberPanel extends FlxSpriteGroup
{
	private var callback:Int->Void;
	private var listener:Int;
	
	private var texts:Array<FlxText>;
	private var selector:Slice9Sprite;
	private var selected(default, set):Int;
	private var numDigit:Int;

	public function new() 
	{
		super();
		
		texts = [];
		
		selector = new Slice9Sprite("assets/images/system.png", new Rectangle(64, 64, 32, 32), new Rectangle(64 + 8, 64 + 8, 16, 16));
		selector.setPosition(0, 0);
		selector.setGraphicSize(20, 26);
		
		add(selector);
		
		scrollFactor.set();
		
		listener = Events.on("key.justPressed", function(key:InputKey)
		{
			switch (key) 
			{
				case KLeft:
					selected --;
					
				case KRight:
					selected ++;
					
				case KUp:
					var n = Std.parseInt(texts[selected].text);
					texts[selected].text = Std.string(++n % 10);
					
				case KDown:
					var n = Std.parseInt(texts[selected].text);
					texts[selected].text = Std.string(n == 0 ? 9 : --n);
					
				case KEnter:
					var result = 0;
					for (i in 0...numDigit)
					{
						var n = Std.parseInt(texts[i].text);
						result += Std.int(Math.pow(10, numDigit - i - 1) * n);
					}
					visible = false;
					Events.disable(listener);
					callback(result);
					
				default:
					
			}
		});
		Events.disable(listener);
	}
	
	public function show(callback, prompt, numDigit)
	{
		visible = true;
		
		this.numDigit = numDigit;
		this.callback = callback;
		selected = 0;
		
		while (texts.length < numDigit)
		{
			var t = new FlxText(texts.length * 20, 0, 0, "0", 20);
			texts.push(t);
			add(t);
		}
		
		for (i in 0...texts.length)
		{
			texts[i].visible = i < numDigit;
			texts[i].text = "0";
		}
		
		Events.enable(listener);
	}
	
	private function set_selected(v:Int):Int
	{
		if (v < 0) v = numDigit - 1;
		else if (v >= numDigit) v = 0;
		
		selector.x = x - 2 + 20 * v;
		
		return selected = v;
	}
}