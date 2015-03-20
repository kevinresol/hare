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
	
	public function getMapData(id:String):String 
	{
		return AssetMacro.getTestMapData();
	}
	
	public function getScript(id:Int):String 
	{
		return "";
	}
	
}