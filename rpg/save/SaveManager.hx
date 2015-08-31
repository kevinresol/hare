package rpg.save;
import haxe.Serializer;
import haxe.Unserializer;
import rpg.config.Config;
import rpg.config.Config.ItemData;
import rpg.Engine;
import rpg.event.EventManager;
import rpg.geom.Direction;
import rpg.geom.IntPoint;
import rpg.image.ImageManager;
import rpg.impl.Assets;
import rpg.impl.Game;
import rpg.impl.Implementation;
import rpg.item.ItemManager;
import rpg.map.MapManager;
import rpg.movement.InteractionManager;

using Lambda;
/**
 * ...
 * @author Kevin
 */
class SaveManager
{
	public var displayData(get, never):Array<SaveDisplayData>;
	
	@inject
	public var game:Game;
	
	@inject 
	public var assets:Assets;
	
	@inject
	public var eventManager:EventManager;
	@inject
	public var mapManager:MapManager;
	@inject
	public var interactionManager:InteractionManager;
	@inject
	public var itemManager:ItemManager;
	@inject
	public var imageManager:ImageManager;
	
	private var saves:Array<SaveData>;
	
	public function new() 
	{
		
	}
	
	@post
	public function init()
	{
		var s = assets.getSaveData();
		
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
			data.gameData = eventManager.getGameData();
			data.mapId = mapManager.currentMap.id;
			data.playerName = mapManager.getMap(1).player.name;
			data.playerFacing = interactionManager.player.facing;
			data.playerPosition = interactionManager.player.position;
			data.items = itemManager.itemData;
			saves[id] = data;
			assets.setSaveData(Serializer.run(saves));
		}
	}
	
	public function load(id:Int, config:Config):Void
	{
		if (saves != null)
		{
			var data = saves[id];
			eventManager.setGameData(data.gameData);
			itemManager.init(data.items);
			var playerImage = config.getCharacterImage(data.playerName);
			var image = imageManager.getImage(ICharacter(playerImage.source), playerImage.index);
			game.createPlayer(image);
			eventManager.scriptHost.teleportPlayer(data.mapId, data.playerPosition.x, data.playerPosition.y, { facing:Direction.toString(data.playerFacing) } );
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