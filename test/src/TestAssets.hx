package ;
import hare.impl.Assets;
import haxe.Json;
import hare.config.Config;

/**
 * ...
 * @author Kevin
 */
class TestAssets extends hare.impl.Assets
{

	public function new() 
	{
		super();
	}
	
	/* INTERFACE impl.IAssetManager */
	
	override public function getMapData(id:Int):String 
	{
		return Macro.getTestMapData();
	}
	
	override public function getScript(mapId:Int, eventId:Int):String 
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
	
	override public function getSaveData():String 
	{
		return "";
	}
	
	override public function setSaveData(data:String):Void 
	{
		
	}
	
	override public function getConfig():String 
	{
		var s = Macro.getTestConfig();
		return s;
	}
	
	override public function getImageDimension(source:String):{width:Int, height:Int}
	{
		return {width:384, height:512};
	}
}