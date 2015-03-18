package impl.flixel ;
import openfl.Assets;
import rpg.IAssetManager;

/**
 * ...
 * @author Kevin
 */
class AssetManager implements IAssetManager
{

	public function new() 
	{
		
	}
	
	public function getMapData(id:String):String 
	{
		return Assets.getText('assets/data/map/$id.tmx');
	}
	
	public function getScript(id:Int):String 
	{
		var file = "event-" + StringTools.lpad(Std.string(id), "0", 4) + ".lua";
		return Assets.getText('assets/data/script/$file');
	}
	
}