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
	public var movementEnabled:Bool = true;
	
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
								attemptMove( -1, 0);
								
							case KRight:
								attemptMove(1, 0);
								
							case KUp:
								attemptMove(0, -1);
								
							case KDown:
								attemptMove(0, 1);
								
							case KEnter:
								var dx = if (player.facing == Direction.LEFT) -1 else if (player.facing == Direction.RIGHT) 1 else 0;
								var dy = if (player.facing == Direction.UP) -1 else if (player.facing == Direction.DOWN) 1 else 0;
									
								for (object in engine.mapManager.currentMap.objects)
								{
									switch(object.type)
									{
										case OEvent(trigger):
											switch (trigger) 
											{
												case EAction | EBump:
													if (object.x == player.position.x + dx && object.y == player.position.y + dy)
														engine.eventManager.startEvent(object.id);
												default:
											}
											
										default:
									}
									
								}
								
							case KEsc:
								engine.gameState = SGameMenu;
						}
					}
					
				default:
			}
		});
	}
	
	public function enableMovement():Void
	{
		movementEnabled = true;
		Events.enable(movementKeyListener);
		
		// immediately attempt move if keys are down
		if (engine.inputManager.right)
			attemptMove(1, 0);
		if (engine.inputManager.left)
			attemptMove(-1, 0);
		if (engine.inputManager.up)
			attemptMove(0, -1);
		if (engine.inputManager.down)
			attemptMove(0, 1);
	}
	
	public function disableMovement():Void
	{
		movementEnabled = false;
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
		
		for (object in engine.currentMap.objects)
		{
			switch (object.type) 
			{
				case OEvent(trigger):
					switch (trigger)
					{
						case EOverlap:
							if (object.x == player.position.x && object.y == player.position.y)
								engine.eventManager.startEvent(object.id);
							
						case ENearby:
							if (isNeighbour(object.x, object.y, player.position.x, player.position.y))
								engine.eventManager.startEvent(object.id);
								
						default:
					}
					
				default:
			}
		}
		
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
		
		if (player.moving || !movementEnabled) return false;
		
		var dir = if (dx == 1) Direction.RIGHT else if (dx == -1) Direction.LEFT else if (dy == 1) Direction.DOWN else if (dy == -1) Direction.UP else 0;
		player.facing = dir;
		
		for (object in engine.mapManager.currentMap.objects)
		{
			switch (object.type) 
			{
				case OEvent(trigger):
					if (trigger == EBump && object.x == player.position.x + dx && object.y == player.position.y + dy)
						engine.eventManager.startEvent(object.id);
					
				default:
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
	
	public function checkPassage(dx:Int, dy:Int):Bool
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
	
	private function isNeighbour(x1:Int, y1:Int, x2:Int, y2:Int):Bool
	{
		if (y1 == y2)
		{
			return x1 == x2 + 1 || x1 == x2 - 1;
		}
		if (x1 == x2)
		{
			return y1 == y2 + 1 || y1 == y2 - 1;
		}
		return false;
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