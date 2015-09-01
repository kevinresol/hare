package hare.impl.flixel ;
import flixel.util.FlxSave;
import openfl.Assets in OpenflAssets;
using Lambda;
/**
 * ...
 * @author Kevin
 */
class Assets extends hare.impl.Assets
{
	private var maps:Map<Int, String>;
	private var scripts:Map<Int, Map<Int, String>>;
	private var musics:Map<Int, String>;
	private var sounds:Map<Int, String>;
	private var systemSounds:Map<Int, String>;

	public function new() 
	{
		super();
		
		maps = new Map();
		scripts = new Map();
		musics = new Map();
		sounds = new Map();
		systemSounds = new Map();
		
		for (asset in OpenflAssets.list())
		{
			if (asset.indexOf("assets/map/") >= 0 &&  ~/[0-9]{4}-.*(\.tmx)/.match(asset))
			{
				var f = asset.split("assets/map/")[1];
				var id = Std.parseInt(f.split("-")[0]);
				maps[id] = f;
			}
			else if (asset.indexOf("assets/script/") >= 0 && ~/[0-9]{4}-[0-9]{4}-.*(\.lua)/.match(asset))
			{
				var f = asset.split("assets/script/")[1];
				var s = f.split("-");
				var mapId = Std.parseInt(s[0]);
				var eventId = Std.parseInt(s[1]);
				if (!scripts.exists(mapId))
					scripts[mapId] = new Map();
				scripts[mapId][eventId] = f;
			}
			else if (asset.indexOf("assets/music/") >= 0 && ~/[0-9]{4}-.*(\.ogg)/.match(asset))
			{
				var f = asset.split("assets/music/")[1];
				var id =  Std.parseInt(f.split("-")[0]);
				musics[id] = f;
			}
			else if (asset.indexOf("assets/sounds/gameplay/") >= 0 && ~/[0-9]{4}-.*(\.ogg)/.match(asset))
			{
				var f = asset.split("assets/sounds/gameplay/")[1];
				var id =  Std.parseInt(f.split("-")[0]);
				sounds[id] = f;
			}
			else if (asset.indexOf("assets/sounds/system/") >= 0 && ~/[0-9]{4}-.*(\.ogg)/.match(asset))
			{
				var f = asset.split("assets/sounds/system/")[1];
				var id =  Std.parseInt(f.split("-")[0]);
				systemSounds[id] = f;
			}
		}
	}
	
	override public function getConfig():String
	{
		var config = OpenflAssets.list().find(function(s) return s.indexOf("assets/config") != -1);
		return OpenflAssets.getText(config);
	}
	
	override public function getMapData(id:Int):String 
	{
		var filename = maps[id];
		return OpenflAssets.getText('assets/map/$filename');
	}
	
	override public function getScript(mapId:Int, eventId:Int):String 
	{
		var filename = scripts[mapId][eventId];
		return OpenflAssets.getText('assets/script/$filename');
	}
	
	public function getMusic(musicId:Int):String
	{
		var filename = musics[musicId];
		return OpenflAssets.getPath('assets/music/$filename');
	}
	
	public function getSound(soundId:Int):String
	{
		var filename = sounds[soundId];
		return OpenflAssets.getPath('assets/sounds/gameplay/$filename');
	}
	
	public function getSystemSound(soundId:Int):String
	{
		var filename = systemSounds[soundId];
		return OpenflAssets.getPath('assets/sounds/system/$filename');
	}
	
	override public function getSaveData():String 
	{
		var save = new FlxSave();
		save.bind("save");
		
		var s = save.data.serialized;
		if (s == null) s = "";
		save.close();
		return s;
	}
	
	override public function setSaveData(data:String):Void 
	{
		var save = new FlxSave();
		save.bind("save");
		save.data.serialized = data;
		save.flush();
		save.close();
	}
	
	override public function getImageDimension(source:String):{width:Int, height:Int}
	{
		if (OpenflAssets.exists(source))
		{
			var b = OpenflAssets.getBitmapData(source);
			return {width:b.width, height:b.height};
		}
		else
			return null;
	}
}