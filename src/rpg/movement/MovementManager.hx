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
	public var playerPosition:IntPoint;
	public var playerFacing:Int;
	public var playerMoving(default, set):Bool = false;
	
	private function set_playerMoving(v)
	{
		playerMoving = v;
		trace(v);
		return v;
	}
	private var engine:Engine;
	
	private var movementEnabled:Bool = true;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
		
		playerPosition = new IntPoint();
		
		Events.on("key.justPressed", function(key:InputKey)
		{
			switch (key) 
			{
				case KLeft:
					attemptMove(-1, 0);
				case KRight:
					attemptMove(1, 0);
				case KUp:
					attemptMove(0, -1);
				case KDown:
					attemptMove(0, 1);
				default:
			}
		});
		
		/*Events.on("key.justReleased", function(key:InputKey)
		{
			
		});*/
	}
	
	public function enableMovement():Void
	{
		movementEnabled = true;
	}
	
	public function disableMovement():Void
	{
		movementEnabled = false;
	}
	
	public function updatePlayerPosition(x:Int, y:Int):Void
	{
		playerPosition.set(x, y);
	}
	
	public function startMove(dx:Int, dy:Int):Void
	{
		playerMoving = true;
		engine.impl.movePlayer(dx, dy);
	}
	
	/**
	 * Called when a move is ended
	 * @return true if continue moving
	 */
	public function endMove():Bool
	{
		playerMoving = false;
		
		if (engine.inputManager.right)
			return attemptMove(1, 0);
		if (engine.inputManager.left)
			return attemptMove(-1, 0);
		if (engine.inputManager.up)
			return attemptMove(0, -1);
		if (engine.inputManager.down)
			return attemptMove(0, 1);
		
		return false;
	}
	
	/**
	 * Attempt moving
	 * @param	dx
	 * @param	dy
	 * @return	true if success (will start moving)
	 */
	public function attemptMove(dx:Int, dy:Int):Bool
	{
		if (!movementEnabled || playerMoving) return false;
		
		for (event in engine.mapManager.currentMap.events)
		{
			if (event.x == playerPosition.x + dx && event.y == playerPosition.y + dy)
			{
				engine.eventManager.trigger(event.id);
			}
		}
		
		if (checkPassage(dx, dy))
		{
			startMove(dx, dy);
			return true;
		}
		
		return false;
	}
	
	public function update(elapsed:Float):Void
	{
		var dir = engine.impl.playerMovementDirection;
		
		if (movementEnabled)
		{
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