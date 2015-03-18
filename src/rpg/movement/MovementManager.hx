package rpg.movement;
import rpg.Engine;
import rpg.geom.Point;
import rpg.input.InputManager.InputKey;

/**
 * ...
 * @author Kevin
 */
class MovementManager
{
	private var engine:Engine;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
		
		Events.on("key.justPressed", function(key:InputKey)
		{
			
		});
		
		/*Events.on("key.justReleased", function(key:InputKey)
		{
			
		});*/
	}
	
	public function update(elapsed:Float):Void
	{
		
			if (engine.inputManager.right)
				engine.impl.playerMovementDirection.set(1, 0);
			else if (engine.inputManager.left)
				engine.impl.playerMovementDirection.set(-1, 0);
			else if (engine.inputManager.up)
				engine.impl.playerMovementDirection.set(0, -1);
			else if (engine.inputManager.down)
				engine.impl.playerMovementDirection.set(0, 1);
			else
				engine.impl.playerMovementDirection.set(0, 0);
	}
}