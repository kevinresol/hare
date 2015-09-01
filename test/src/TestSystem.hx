package;
import hare.impl.System;
import hare.save.SaveManager;
import hare.Engine.GameMenuAction;
import hare.Engine.LogLevel;
import hare.save.SaveManager.SaveDisplayData;

/**
 * ...
 * @author Kevin
 */
class TestSystem extends hare.impl.System
{

	public function new() 
	{
		super();
	}
	
	override public function showMainMenu(startGameCallback:Void->Void, loadGameCallback:Void->Void):Void
	{
		
	}
	
	override public function hideMainMenu():Void
	{
		
	}
	
	override public function showGameMenu(callback:GameMenuAction->Void, cancelCallback:Void->Void):Void
	{
		
	}
	
	override public function hideGameMenu():Void
	{
		
	}
	
	override public function showSaveScreen(saveGameCallback:Int->Void, cancelCallback:Void->Void, data:Array<SaveDisplayData>):Void
	{
		
	}
	
	override public function hideSaveScreen():Void
	{
		
	}
	
	override public function showLoadScreen(loadGameCallback:Int->Void, cancelCallback:Void->Void, data:Array<SaveDisplayData>):Void
	{
		
	}
	
	override public function hideLoadScreen():Void
	{
		
	}
	
	override public function log(message:String, level:LogLevel):Void
	{
		trace(message);
	}
}