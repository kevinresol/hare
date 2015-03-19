package rpg.input;
import rpg.Engine;

/**
 * ...
 * @author Kevin
 */
class InputManager
{
	public var up(default, null):Bool;
	public var down(default, null):Bool;
	public var left(default, null):Bool;
	public var right(default, null):Bool;
	public var enter(default, null):Bool;
	
	private var engine:Engine;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
	}
	
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
		}
		Events.dispatch("key.justPressed", key);
	}
	
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
}