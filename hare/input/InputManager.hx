package hare.input;
import hare.Events;
import hare.Engine;

/**
 * ...
 * @author Kevin
 */
class InputManager
{
	// A set of booleans keeping the state of a key (true = down, false = up)
	public var up(default, null):Bool;
	public var down(default, null):Bool;
	public var left(default, null):Bool;
	public var right(default, null):Bool;
	public var enter(default, null):Bool;
	public var esc(default, null):Bool;
	
	@inject
	public  var engine:Engine;
	
	public function new() 
	{
	}
	
	/**
	 * Called by the implementation when a key is pressed
	 * @param	key
	 */
	public function press(key:InputKey):Void
	{
		switch (key) 
		{
			case KUp:
				if (!up) up = true; 
				else return;
				
			case KDown:
				if (!down) down = true; 
				else return;
				
			case KRight:
				if (!right) right= true; 
				else return;
				
			case KLeft:
				if (!left) left = true; 
				else return;
				
			case KEnter:
				if (!enter) enter = true; 
				else return;
				
			case KEsc:
				if (!esc) esc = true; 
				else return;
		}
		Events.dispatch("key.justPressed", key);
	}
	
	/**
	 * Called by the implementation when a key is released
	 * @param	key
	 */
	public function release(key:InputKey):Void
	{
		switch (key) 
		{
			case KUp:
				if (up) up = false; 
				else return;
				
			case KDown:
				if (down) down = false; 
				else return;
				
			case KRight:
				if (right) right= false; 
				else return;
				
			case KLeft:
				if (left) left = false; 
				else return;
				
			case KEnter:
				if (enter) enter = false; 
				else return;
				
			case KEsc:
				if (esc) esc = false; 
				else return;
		}
		Events.dispatch("key.justReleased", key);
	}
}

enum InputKey
{
	KUp;
	KDown;
	KRight;
	KLeft;
	KEnter;
	KEsc;
}