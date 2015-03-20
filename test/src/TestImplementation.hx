package ;
import impl.IAssetManager;
import impl.IImplementation;
import rpg.Engine;
import rpg.event.ScriptHost.ShowChoicesChoice;
import rpg.event.ScriptHost.ShowChoicesOptions;
import rpg.event.ScriptHost.ShowTextOptions;
import rpg.event.ScriptHost.TeleportPlayerOptions;
import rpg.map.GameMap;

/**
 * ...
 * @author Kevin
 */
class TestImplementation implements IImplementation
{
	
	public var engine:Engine;
	public var assetManager:IAssetManager;

	public function new() 
	{
		assetManager = new TestAssetManager();
	}
	
	/* INTERFACE impl.IImplementation */
	
	public function changePlayerFacing(dir:Int):Void 
	{
		
	}
	
	public function log(message:String):Void 
	{
		
	}
	
	public function movePlayer(callback:Void->Bool, dx:Int, dy:Int):Void 
	{
		
	}
	
	public function showText(callback:Void->Void, characterId:String, message:String, options:ShowTextOptions):Void 
	{
		
	}
	
	public function showChoices(callback:Int->Void, prompt:String, choices:Array<ShowChoicesChoice>, options:ShowChoicesOptions):Void 
	{
		
	}
	
	public function teleportPlayer(callback:Void->Void, map:GameMap, x:Int, y:Int, options:TeleportPlayerOptions):Void 
	{
		
	}
	
}