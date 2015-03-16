package rpg.impl.flixel;
import openfl.Assets;

/**
 * ...
 * @author Kevin
 */
class AssetManager implements IAssetManager
{

	public function new() 
	{
		
	}
	
	/* INTERFACE rpg.IAssetManager */
	
	public function getMapData(id:String):String 
	{
		return Assets.getText('assets/data/map/$id.tmx');
	}
	
}