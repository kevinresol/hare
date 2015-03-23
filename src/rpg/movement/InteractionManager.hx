package rpg.movement;
import rpg.Engine;
import rpg.geom.Direction;
import rpg.geom.IntPoint;
import rpg.input.InputManager.InputKey;
import rpg.map.GameMap;

/**
 * ...
 * @author Kevin
 */
class InteractionManager
{
	public var player:Player;
	public var movementKeyListener(default, null):Int;
	
	private var engine:Engine;
	
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
		
		player = new Player();
		
		movementKeyListener = Events.on("key.justPressed", function(key:InputKey)
		{
			switch(engine.gameState)
			{
				case SGame:
					if (player.map == engine.mapManager.currentMap) //check inputs only if the player is in current map
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
								var dx = if (player.facing == Direction.LEFT) -1 else if (player.facing == Direction.RIGHT) 1 else 0;
								var dy = if (player.facing == Direction.UP) -1 else if (player.facing == Direction.DOWN) 1 else 0;
									
								for (event in engine.mapManager.currentMap.events)
								{
									if (event.trigger == EAction && event.x == player.position.x + dx && event.y == player.position.y + dy)
									{
										engine.eventManager.trigger(event.id);
									}
								}
							case KEsc:
								engine.gameState = SSaveScreen;
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
		player.moving = true;
		engine.impl.movePlayer(endMove.bind(player.position.x + dx, player.position.y + dy), dx, dy);
	}
	
	/**
	 * Called by the implementation when a move is ended
	 * @return true if continue moving
	 */
	public function endMove(x:Int, y:Int):Bool
	{
		player.position.set(x, y);
		player.moving = false;
		
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
		
		if (player.moving) return false;
		
		var dir = if (dx == 1) Direction.RIGHT else if (dx == -1) Direction.LEFT else if (dy == 1) Direction.DOWN else if (dy == -1) Direction.UP else 0;
		player.facing = dir;
		
		for (event in engine.mapManager.currentMap.events)
		{
			if (event.trigger == EPlayerTouch && event.x == player.position.x + dx && event.y == player.position.y + dy)
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
		var x = player.position.x + dx;
		var y = player.position.y + dy;
		var index = y * map.gridWidth + x;
		var passage = map.passage[index];
		var dir = 0;
		
		if (dx == 1) dir = Direction.LEFT; // moving right => check if destination allow moving from left
		else if (dx == -1) dir = Direction.RIGHT; 
		else if (dy == 1) dir = Direction.UP; 
		else if (dy == -1) dir = Direction.DOWN;
		
		return (passage & dir == 0);
	}
}

class Player
{
	public var map:GameMap;
	public var position:IntPoint;
	public var facing:Int;
	public var moving:Bool = false;
	
	public function new()
	{
		position = new IntPoint();
	}
}