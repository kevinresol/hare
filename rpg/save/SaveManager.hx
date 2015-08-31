package rpg.save;
import haxe.Serializer;
import haxe.Unserializer;
import rpg.config.Config.ItemData;
import rpg.Engine;
import rpg.geom.Direction;
import rpg.geom.IntPoint;
import rpg.impl.Implementation;

using Lambda;
/**
 * ...
 * @author Kevin
 */
class SaveManager
{
	public var displayData(get, never):Array<SaveDisplayData>;
	
	private var engine:Engine;
	private var impl:Implementation;
	
	private var saves:Array<SaveData>;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
		this.impl = engine.impl;
		
		var s = impl.assets.getSaveData();
		
		if (s == "") 
			saves = [];
		else
			saves = Unserializer.run(s);
	}
	
	public function save(id:Int):Void
	{
		if (saves != null)
		{
			var data = new SaveData();
			data.date = Date.now();
			data.gameData = engine.eventManager.getGameData();
			data.mapId = engine.mapManager.currentMap.id;
			data.playerName = engine.mapManager.getMap(1).player.name;
			data.playerFacing = engine.interactionManager.player.facing;
			data.playerPosition = engine.interactionManager.player.position;
			data.items = engine.itemManager.itemData;
			saves[id] = data;
			engine.impl.assets.setSaveData(Serializer.run(saves));
		}
	}
	
	public function load(id:Int):Void
	{
		if (saves != null)
		{
			var data = saves[id];
			engine.eventManager.setGameData(data.gameData);
			engine.itemManager.init(data.items);
			var playerImage = engine.config.getCharacterImage(data.playerName);
			var image = engine.imageManager.getImage(ICharacter(playerImage.source), playerImage.index);
			engine.impl.game.createPlayer(image);
			engine.eventManager.scriptHost.teleportPlayer(data.mapId, data.playerPosition.x, data.playerPosition.y, { facing:Direction.toString(data.playerFacing) } );
		}
	}
	
	private  function get_displayData():Array<SaveDisplayData>
	{
		var result = [];
		for (save in saves) 
		{
			result.push({date:save.date});
		}
		return result;
	}
}

class SaveData
{
	public var date:Date;
	public var mapId:Int;
	public var playerName:String;
	public var playerPosition:IntPoint;
	public var playerFacing:Int;
	public var gameData:GameData;
	public var items:Array<ItemData>;
	
	public function new()
	{
		
	}
}

typedef GameData = 
{
	variables:Dynamic,
	eventVariables:Dynamic,
}

typedef SaveDisplayData = 
{
	date:Date,
}