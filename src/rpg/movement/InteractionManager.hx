package rpg.movement;
import rpg.Engine;
import rpg.geom.Direction;
import rpg.geom.IntPoint;
import rpg.input.InputManager.InputKey;

/**
 * ...
 * @author Kevin
 */
class InteractionManager
{
	public var playerPosition:IntPoint;
	public var playerFacing:Int;
	public var playerMoving:Bool = false;
	
	private var engine:Engine;
	
	private var movementKeyListener:Int;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
		
		playerPosition = new IntPoint();
		
		movementKeyListener = Events.on("key.justPressed", function(key:InputKey)
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
				case KEnter:
					var dx = if (playerFacing == Direction.LEFT) -1 else if (playerFacing == Direction.RIGHT) 1 else 0;
					var dy = if (playerFacing == Direction.TOP) -1 else if (playerFacing == Direction.BOTTOM) 1 else 0;
						
					for (event in engine.mapManager.currentMap.events)
					{
						if (event.trigger == EAction && event.x == playerPosition.x + dx && event.y == playerPosition.y + dy)
						{
							engine.eventManager.trigger(event.id);
						}
					}
				default:
			}
		});
		
		/*Events.on("key.justReleased", function(key:InputKey)
		{
			
		});*/
	}
	
	public function enableMovement():Void
	{
		Events.enable(movementKeyListener);
	}
	
	public function disableMovement():Void
	{
		Events.disable(movementKeyListener);
	}
	
	/**
	 * Tell the implementation to start a move
	 * @param	dx
	 * @param	dy
	 */
	public function startMove(dx:Int, dy:Int):Void
	{
		playerMoving = true;
		engine.impl.movePlayer(endMove.bind(playerPosition.x + dx, playerPosition.y + dy), dx, dy);
	}
	
	/**
	 * Called by the implementation when a move is ended
	 * @return true if continue moving
	 */
	public function endMove(x:Int, y:Int):Bool
	{
		playerPosition.set(x, y);
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
	 * Attempt a move (check if the destination is passable)
	 * The passage map is defined in the "Passage" layer of the .tmx map files
	 * @param	dx
	 * @param	dy
	 * @return	true if success (will start moving)
	 */
	public function attemptMove(dx:Int, dy:Int):Bool
	{
		if (dx != 0 && dy != 0) throw "Diagonal movement is not supported";
		
		if (playerMoving) return false;
		
		var dir = if (dx == 1) Direction.RIGHT else if (dx == -1) Direction.LEFT else if (dy == 1) Direction.BOTTOM else if (dy == -1) Direction.TOP else 0;
		playerFacing = dir;
		
		for (event in engine.mapManager.currentMap.events)
		{
			if (event.trigger == EPlayerTouch && event.x == playerPosition.x + dx && event.y == playerPosition.y + dy)
			{
				engine.eventManager.trigger(event.id);
			}
		}
		
		if (checkPassage(dx, dy))
		{
			startMove(dx, dy);
			return true;
		}
		else // can't move because the attempted direction is impassable, just change the facing
		{
			engine.impl.changePlayerFacing(dir);
		}
		
		return false;
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