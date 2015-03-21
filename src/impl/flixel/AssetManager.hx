package impl.flixel ;
import openfl.Assets;
import impl.IAssetManager;
import sys.FileSystem;

/**
 * ...
 * @author Kevin
 */
class AssetManager implements IAssetManager
{
	private var maps:Map<Int, String>;
	private var scripts:Map<Int, Map<Int, String>>;

	public function new() 
	{
		maps = new Map();
		scripts = new Map();
		
		for (f in FileSystem.readDirectory("assets/data/map"))
		{
			var id = Std.parseInt(f.split("-")[0]);
			maps[id] = f;
			scripts[id] = new Map();
		}
		
		for (f in FileSystem.readDirectory("assets/data/script"))
		{
			var s = f.split("-");
			var mapId = Std.parseInt(s[0]);
			var eventId = Std.parseInt(s[1]);
			scripts[mapId][eventId] = f;
		}
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
	
}