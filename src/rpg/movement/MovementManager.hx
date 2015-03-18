package rpg.movement;
import rpg.Engine;
import rpg.geom.Direction;
import rpg.geom.IntPoint;
import rpg.input.InputManager.InputKey;

/**
 * ...
 * @author Kevin
 */
class MovementManager
{
	private var engine:Engine;
	public var playerPosition:IntPoint;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
		
		playerPosition = new IntPoint();
		
		Events.on("key.justPressed", function(key:InputKey)
		{
			
		});
		
		/*Events.on("key.justReleased", function(key:InputKey)
		{
			
		});*/
	}
	
	public function updatePlayerPosition(x:Int, y:Int):Void
	{
		playerPosition.set(x, y);
		
		var dir = engine.impl.playerMovementDirection;
		
		if (!checkPassage(dir.x, dir.y))
			dir.set(0, 0);
		
		for (event in engine.mapManager.currentMap.events)
		{
			if (event.x == x && event.y == y)
			{
				trace("trigger" + event.id);
			}
		}
	}
	
	public function update(elapsed:Float):Void
	{
		var dir = engine.impl.playerMovementDirection;
		
		if (engine.inputManager.right && checkPassage(1, 0))
			dir.set(1, 0);
		else if (engine.inputManager.left && checkPassage(-1, 0))
			dir.set(-1, 0);
		else if (engine.inputManager.up && checkPassage(0, -1))
			dir.set(0, -1);
		else if (engine.inputManager.down && checkPassage(0, 1))
			dir.set(0, 1);
		else
			dir.set(0, 0);
	}
	
	private function checkPassage(dx:Int, dy:Int):Bool
	{
		if (dx != 0 && dy != 0) throw "Diagonal movement is not supported";
		
		var map = engine.mapManager.currentMap;
		var x = playerPosition.x + dx;
		var y = playerPosition.y + dy;
		var index = y * map.gridWidth + x;
		var passage = map.passage[index];
		var dir = 0;
		
		if (dx == 1) dir = Direction.LEFT; // moving right => check if destination allow moving from left
		else if (dx == -1) dir = Direction.RIGHT; 
		else if (dy == 1) dir = Direction.TOP; 
		else if (dy == -1) dir = Direction.BOTTOM;
		
		return (passage & dir == 0);
	}
}