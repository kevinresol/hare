package ;
import haxe.Json;
import impl.IAssetManager;
import rpg.config.Config;

/**
 * ...
 * @author Kevin
 */
class TestAssetManager implements IAssetManager
{

	public function new() 
	{
		
	}
	
	/* INTERFACE impl.IAssetManager */
	
	public function getMapData(id:Int):String 
	{
		return Macro.getTestMapData();
	}
	
	public function getScript(mapId:Int, eventId:Int):String 
	{
		return "";
	}
	
	public function getMusic(musicId:Int):String
	{
		return "";
	}
	
	public function getSound(soundId:Int):String
	{
		return "";
	}
	public function getSystemSound(soundId:Int):String
	{
		return "";
	}
	
	/* INTERFACE impl.IAssetManager */
	
	public function getSaveData():String 
	{
		return "";
	}
	
	public function setSaveData(data:String):Void 
	{
		
	}
	
	public function getConfig():String 
	{
		var s = Macro.getTestConfig();
		return s;
	}
	
	public function getImageDimension(source:String):{width:Int, height:Int}
	{
		return {width:384, height:512};
	}
}