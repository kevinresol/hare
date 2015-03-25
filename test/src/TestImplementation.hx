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
	
	public function changePlayerFacing(dir:Int):Void 
	{
		
	}
	
	public function log(message:String):Void 
	{
		
	}
	
	public function movePlayer(callback:Void->Bool, dx:Int, dy:Int):Void 
	{
		callback();
	}
	
	public function showText(callback:Void->Void, characterId:String, message:String, options:ShowTextOptions):Void 
	{
		callback();
	}
	
	public function showChoices(callback:Int->Void, prompt:String, choices:Array<ShowChoicesChoice>, options:ShowChoicesOptions):Void 
	{
		callback(1);
	}
	
	/* INTERFACE impl.IImplementation */
	
	public function showMainMenu(startGameCallback:Void->Void, loadGameCallback:Void->Void):Void 
	{
		
	}
	
	public function hideMainMenu():Void 
	{
		
	}
	
	public function showSaveScreen(saveGameCallback:Int->Void, cancelCallback:Void->Void):Void 
	{
		
	}
	
	public function hideSaveScreen():Void 
	{
		
	}
	
	public function showLoadScreen(loadGameCallback:Int->Void, cancelCallback:Void->Void):Void 
	{
		
	}
	
	public function hideLoadScreen():Void 
	{
		
	}
	
	public function teleportPlayer(map:GameMap, x:Int, y:Int, options:TeleportPlayerOptions):Void 
	{
		
	}
	
	public function playSound(id:Int, volume:Float, pitch:Float):Void 
	{
		
	}
	
	public function playBackgroundMusic(id:Int, volume:Float, pitch:Float):Void 
	{
		
	}
	
	public function playSystemSound(id:Int, volume:Float):Void
	{
	
	}
	
	public function saveBackgroundMusic():Void 
	{
		
	}
	
	public function restoreBackgroundMusic():Void 
	{
		
	}
	
	public function fadeOutBackgroundMusic(ms:Int):Void 
	{
		
	}
	
	public  function fadeInBackgroundMusic(ms:Int):Void 
	{
	
	}
	
	public function fadeOutScreen(ms:Int):Void 
	{
		
	}
	
	public function fadeInScreen(ms:Int):Void 
	{
		
	}
	
	public function tintScreen(color:Int, ms:Int):Void 
	{
		
	}
	
	public function flashScreen(color:Int, strength:Int, ms:Int):Void 
	{
		
	}
	
	public function shakeScreen(power:Int, screen:Int, ms:Int):Void 
	{
		
	}
	
}