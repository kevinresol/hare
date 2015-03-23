package ;
import impl.IAssetManager;

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
		return AssetMacro.getTestMapData();
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
	
	/* INTERFACE impl.IAssetManager */
	
	public function getSaveData(id:Int):String 
	{
		return "";
	}
	
	public function setSaveData(id:Int, data:String):Void 
	{
		
	}
	
}