package hare.impl.flixel.display;
import hare.input.InputManager;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import hare.Events;
import hare.input.InputManager.InputKey;

using Lambda;
/**
 * ...
 * @author Kevin
 */
class InputNumberPanel extends FlxSpriteGroup
{
	public var number(get, never):Int;
	private var listener:Int;
	
	private var texts:Array<Text>;
	private var selector:Slice9Sprite;
	private var selected(default, set):Int;
	private var numDigit:Int;

	public function new() 
	{
		super();
		
		texts = [];
		
		
		selector = new Selector(0, 0, 20, 26);
		
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
					
				default:
					
			}
		});
		Events.disable(listener);
	}
	
	public function show(numDigit)
	{
		visible = true;
		
		this.numDigit = numDigit;
		selected = 0;
		
		while (texts.length < numDigit)
		{
			var t = new Text(texts.length * 20, 0, 0, "0", 20);
			texts.push(t);
			add(t);
		}
		
		for (i in 0...texts.length)
		{
			texts[i].visible = i < numDigit;
			texts[i].text = "0";
		}
		
		x = (FlxG.width - numDigit * 20) / 2;
		Events.enable(listener);
	}
	
	public function hide():Void
	{
		Events.disable(listener);
		visible = false;
	}
	
	private function set_selected(v:Int):Int
	{
		if (v < 0) v = numDigit - 1;
		else if (v >= numDigit) v = 0;
		
		selector.x = x - 2 + 20 * v;
		
		return selected = v;
	}
	
	private function get_number():Int
	{
		var result = 0;
		for (i in 0...numDigit)
		{
			var n = Std.parseInt(texts[i].text);
			result += Std.int(Math.pow(10, numDigit - i - 1) * n);
		}
		return result;
	}
}