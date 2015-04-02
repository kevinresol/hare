package impl.flixel ;
import flixel.util.FlxSave;
import haxe.Json;
import openfl.Assets;
import rpg.config.Config;

/**
 * ...
 * @author Kevin
 */
class AssetManager implements IAssetManager
{
	private var maps:Map<Int, String>;
	private var scripts:Map<Int, Map<Int, String>>;
	private var musics:Map<Int, String>;
	private var sounds:Map<Int, String>;
	private var systemSounds:Map<Int, String>;
	
	private var config:Config;

	public function new() 
	{
		maps = new Map();
		scripts = new Map();
		musics = new Map();
		sounds = new Map();
		systemSounds = new Map();
		
		for (asset in Assets.list())
		{
			if (asset.indexOf("assets/data/map/") >= 0)
			{
				var f = StringTools.replace(asset, "assets/data/map/", "");
				var id = Std.parseInt(f.split("-")[0]);
				maps[id] = f;
			}
			else if (asset.indexOf("assets/data/script/") >= 0)
			{
				var f = StringTools.replace(asset, "assets/data/script/", "");
				var s = f.split("-");
				var mapId = Std.parseInt(s[0]);
				var eventId = Std.parseInt(s[1]);
				if (!scripts.exists(mapId))
					scripts[mapId] = new Map();
				scripts[mapId][eventId] = f;
			}
			else if (asset.indexOf("assets/music/") >= 0)
			{
				var f = StringTools.replace(asset, "assets/music/", "");
				var id =  Std.parseInt(f.split("-")[0]);
				musics[id] = f;
			}
			else if (asset.indexOf("assets/sounds/gameplay/") >= 0)
			{
				var f = StringTools.replace(asset, "assets/sounds/gameplay/", "");
				var id =  Std.parseInt(f.split("-")[0]);
				sounds[id] = f;
			}
			else if (asset.indexOf("assets/sounds/system/") >= 0)
			{
				var f = StringTools.replace(asset, "assets/sounds/system/", "");
				var id =  Std.parseInt(f.split("-")[0]);
				systemSounds[id] = f;
			}
		}
	}
	
	public function getConfig():Config
	{
		if (config == null)
		{
			if(Assets.exists("assets/data/config.json"))
				config = Json.parse(Assets.getText("assets/data/config.json"));
			else
				config = { actors:[], items:[] };
		}
			
		return config;
	}
	
	public function getMapData(id:Int):String 
	{
		var filename = maps[id];
		return Assets.getText('assets/data/map/$filename');
	}
	
	public function getScript(mapId:Int, eventId:Int):String 
	{
		var filename = scripts[mapId][eventId];
		return Assets.getText('assets/data/script/$filename');
	}
	
	public function getMusic(musicId:Int):String
	{
		var filename = musics[musicId];
		return Assets.getPath('assets/music/$filename');
	}
	
	public function getSound(soundId:Int):String
	{
		var filename = sounds[soundId];
		return Assets.getPath('assets/sounds/gameplay/$filename');
	}
	
	public function getSystemSound(soundId:Int):String
	{
		var filename = systemSounds[soundId];
		return Assets.getPath('assets/sounds/system/$filename');
	}
	
	public function getSaveData(id:Int):String 
	{
		var save = new FlxSave();
		save.bind("save-" + StringTools.lpad(Std.string(id), "0", 4));
		var s:String = save.data.serialized == null ? "" : save.data.serialized;
		save.close();
		return s;
	}
	
	public function setSaveData(id:Int, data:String):Void 
	{
		var save = new FlxSave();
		save.bind("save-" + StringTools.lpad(Std.string(id), "0", 4));
		save.data.serialized = data;
		save.flush();
		save.close();
	}
}