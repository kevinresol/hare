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
	
}