package hare.movement;
import hare.Events;
import hare.input.InputManager;
import hare.Engine;
import hare.geom.Direction;
import hare.geom.IntPoint;
import hare.impl.Movement;
import hare.input.InputManager.InputKey;
import hare.map.GameMap;
import hare.movement.InteractionManager.MovableObjectType;

using Lambda;
/**
 * ...
 * @author Kevin
 */
class InteractionManager
{
	public static inline var MOVEMENT_SPEED:Float = 10; // tiles per second
	public var player:MovableObject;
	public var movementKeyListener(default, null):Int;
	public var movementEnabled:Bool = true;
	public var objects:Array<MovableObject>; //TODO: rename Player class
	
	@inject
	public var engine:Engine;
	
	@inject
	public var movement:Movement;
	
	@inject
	public function new(engine:Engine) 
	{
		player = new MovableObject(MPlayer);
		
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
									
								for (object in objects)
								{
									switch(object.type)
									{
										case MEvent(id):
											var trigger = engine.mapManager.currentMap.getEventTrigger(id);
											switch (trigger) 
											{
												case EAction | EBump:
													if (object.position.x == player.position.x + dx && object.position.y == player.position.y + dy)
													{
														movement.changeObjectFacing(MEvent(id), Direction.turnAround(player.facing));
														engine.eventManager.startEvent(id);
													}
														
												case EOverlapAction:
													if (object.position.x == player.position.x && object.position.y == player.position.y)
														engine.eventManager.startEvent(id);
														
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
		
		Events.on("map.switched", function(map:GameMap)
		{
			if (map == null) return;
			
			objects = [];
			for (mo in map.objects)
			{
				if(mo.event != null)
				{
					var o = new MovableObject(MEvent(mo.id));
					o.position.set(mo.x, mo.y);
					objects.push(o);
				}
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
		movement.moveObject(endMove.bind(player.position.x + dx, player.position.y + dy), MPlayer, dx, dy, MOVEMENT_SPEED);
	}
	
	/**
	 * Called by the implementation when a move is ended
	 * @return true if continue moving
	 */
	public function endMove(x:Int, y:Int):Bool
	{
		player.position.set(x, y);
		player.moving = false;
		
		for (object in objects)
		{
			switch (object.type) 
			{
				case MEvent(id):
					var trigger = engine.mapManager.currentMap.getEventTrigger(id);
					switch (trigger)
					{
						case EOverlap:
							if (object.position.x == player.position.x && object.position.y == player.position.y)
								engine.eventManager.startEvent(id);
							
						case ENearby:
							if (isNeighbour(object.position.x, object.position.y, player.position.x, player.position.y))
								engine.eventManager.startEvent(id);
								
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
		if (dx != 0 && dy != 0) engine.log("Diagonal movement is not supported", LError);
		
		if (player.moving || !movementEnabled) return false;
		
		var dir = if (dx == 1) Direction.RIGHT else if (dx == -1) Direction.LEFT else if (dy == 1) Direction.DOWN else if (dy == -1) Direction.UP else 0;
		player.facing = dir;
		
		for (object in objects)
		{
			switch (object.type) 
			{
				case MEvent(id):
					var trigger = engine.mapManager.currentMap.getEventTrigger(id);
					if (trigger == EBump && object.position.x == player.position.x + dx && object.position.y == player.position.y + dy)
						engine.eventManager.startEvent(id);
					
				default:
			}
		}
		
		if (checkPassage(MPlayer, dx, dy))
		{
			startMove(dx, dy);
			return true;
		}
		else // can't move because the attempted direction is impassable, just change the facing
		{
			movement.changeObjectFacing(MPlayer, dir);
		}
		
		return false;
	}
	
	public function checkPassage(type:MovableObjectType, dx:Int, dy:Int):Bool
	{
		if (dx != 0 && dy != 0) engine.log("Diagonal movement is not supported", LError);
		
		var object = getMovableObject(type);
		
		var map = engine.mapManager.currentMap;
		var x = object.position.x + dx;
		var y = object.position.y + dy;
		var index = y * map.gridWidth + x;
		var passage = map.passage[index];
		var dir = 0;
		
		if (dx == 1) dir = Direction.LEFT; // moving right => check if destination allow moving from left
		else if (dx == -1) dir = Direction.RIGHT; 
		else if (dy == 1) dir = Direction.UP; 
		else if (dy == -1) dir = Direction.DOWN;
		
		var mapPassage = (passage & dir == 0);
		
		if (!mapPassage) return false;
		
		for (object in objects)
		{
			if (object.position.x == x && object.position.y == y)
			{
				switch (object.type) 
				{
					case MEvent(id):
						var trigger = engine.mapManager.currentMap.getEventTrigger(id);
						switch (trigger) 
						{
							case EAction: return false;
							default: 
						}
					default:
				}
			}
		}
		return true;
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
	
	private inline function getMovableObject(type:MovableObjectType):MovableObject
	{
		return switch (type) 
		{
			case MPlayer: player;
			case MEvent(id): objects.find(function(o) return Type.enumEq(type, o.type));
		}
	}
}

class MovableObject
{
	public var type:MovableObjectType;
	public var map:GameMap;
	public var position:IntPoint;
	public var facing:Int;
	public var moving:Bool = false;
	
	public function new(type)
	{
		this.type = type;
		position = new IntPoint();
	}
}

enum MovableObjectType
{
	MPlayer;
	MEvent(id:Int);
}