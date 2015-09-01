package hare.impl;
import hare.save.SaveManager;
import hare.Engine.GameMenuAction;
import hare.Engine.LogLevel;
import hare.save.SaveManager.SaveDisplayData;

/**
 * ...
 * @author Kevin
 */
class System extends Module
{

	public function new() 
	{
		super();
	}
	
	public function showMainMenu(startGameCallback:Void->Void, loadGameCallback:Void->Void):Void
	{
		
	}
	
	public function hideMainMenu():Void
	{
		
	}
	
	public function showGameMenu(callback:GameMenuAction->Void, cancelCallback:Void->Void):Void
	{
		
	}
	
	public function hideGameMenu():Void
	{
		
	}
	
	public function showSaveScreen(saveGameCallback:Int->Void, cancelCallback:Void->Void, data:Array<SaveDisplayData>):Void
	{
		
	}
	
	public function hideSaveScreen():Void
	{
		
	}
	
	public function showLoadScreen(loadGameCallback:Int->Void, cancelCallback:Void->Void, data:Array<SaveDisplayData>):Void
	{
		
	}
	
	public function hideLoadScreen():Void
	{
		
	}
	
	public function log(message:String, level:LogLevel):Void
	{
		
	}
}