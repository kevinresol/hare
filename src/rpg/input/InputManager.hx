package rpg.input;
import rpg.Engine;

/**
 * ...
 * @author Kevin
 */
class InputManager
{
	private var engine:Engine;
	
	private var states:Map<InputKey, InputState>;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
		states = new Map();
		
		for (key in Type.allEnums(InputKey))
			states.set(key, SUp);
	}
	
	public function setKeyState(key:InputKey, state:InputState):Void
	{
		var currentState = states.get(key);
		
		if(currentState != state)
		{
			states.set(key, state);
		}
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

enum InputState
{
	SDown;
	SUp;
}