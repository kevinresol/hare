package impl.flixel ;
import flixel.util.FlxSave;
import openfl.Assets;
using Lambda;
/**
 * ...
 * @author Kevin
 */
class AssetManager implements IAssetManager
{
	public static var instance:AssetManager;
	
	private var maps:Map<Int, String>;
	private var scripts:Map<Int, Map<Int, String>>;
	private var musics:Map<Int, String>;
	private var sounds:Map<Int, String>;
	private var systemSounds:Map<Int, String>;

	public function new() 
	{
		instance = this;
		
		maps = new Map();
		scripts = new Map();
		musics = new Map();
		sounds = new Map();
		systemSounds = new Map();
		
		for (asset in Assets.list())
		{
			if (asset.indexOf("assets/map/") >= 0)
			{
				var f = asset.split("assets/map/")[1];
				var id = Std.parseInt(f.split("-")[0]);
				maps[id] = f;
			}
			else if (asset.indexOf("assets/script/") >= 0)
			{
				var f = asset.split("assets/script/")[1];
				var s = f.split("-");
				var mapId = Std.parseInt(s[0]);
				var eventId = Std.parseInt(s[1]);
				if (!scripts.exists(mapId))
					scripts[mapId] = new Map();
				scripts[mapId][eventId] = f;
			}
			else if (asset.indexOf("assets/music/") >= 0)
			{
				var f = asset.split("assets/music/")[1];
				var id =  Std.parseInt(f.split("-")[0]);
				musics[id] = f;
			}
			else if (asset.indexOf("assets/sounds/gameplay/") >= 0)
			{
				var f = asset.split("assets/sounds/gameplay/")[1];
				var id =  Std.parseInt(f.split("-")[0]);
				sounds[id] = f;
			}
			else if (asset.indexOf("assets/sounds/system/") >= 0)
			{
				var f = asset.split("assets/sounds/system/")[1];
				var id =  Std.parseInt(f.split("-")[0]);
				systemSounds[id] = f;
			}
		}
	}
	
	public function getConfig():String
	{
		var config = Assets.list().find(function(s) return s.indexOf("assets/config") != -1);
		return Assets.getText(config);
	}
	
	public function getMapData(id:Int):String 
	{
		var filename = maps[id];
		return Assets.getText('assets/map/$filename');
	}
	
	public function getScript(mapId:Int, eventId:Int):String 
	{
		var filename = scripts[mapId][eventId];
		return Assets.getText('assets/script/$filename');
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
	
	public function getSaveData():String 
	{
		var save = new FlxSave();
		save.bind("save");
		var s = save.data.serialized;
		if (s == null) s = "";
		save.close();
		return s;
	}
	
	public function setSaveData(data:String):Void 
	{
		var save = new FlxSave();
		save.bind("save");
		save.data.serialized = data;
		save.flush();
		save.close();
	}
	
	public function getImageDimension(source:String):{width:Int, height:Int}
	{
		if (Assets.exists(source))
		{
			var b = Assets.getBitmapData(source);
			return {width:b.width, height:b.height};
		}
		else
			return null;
	}
}