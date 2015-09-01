package;
import rpg.Engine.GameMenuAction;
import rpg.Engine.LogLevel;
import rpg.save.SaveManager.SaveDisplayData;

/**
 * ...
 * @author Kevin
 */
class TestSystem extends rpg.impl.System
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