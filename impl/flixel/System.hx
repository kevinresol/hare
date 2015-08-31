package impl.flixel;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import impl.flixel.display.GameMenu;
import impl.flixel.display.MainMenu;
import impl.flixel.display.SaveLoadScreen;
import impl.flixel.Renderer.Object;
import rpg.Engine;
import rpg.image.Image;
import rpg.map.GameMap;
import rpg.save.SaveManager.SaveDisplayData;


/**
 * ...
 * @author Kevin
 */
class System extends rpg.impl.System
{
	@inject
	public var renderer:Renderer;
	
	public function new() 
	{
		super();
	}
	
	override public function showMainMenu(startGameCallback:Void->Void, loadGameCallback:Void->Void):Void
	{
		if(renderer.layers[2] != null)
			renderer.layers[2].remove(renderer.player, true);
		
		while(renderer.layers.length > 0)
			renderer.layers.pop().destroy();
		
		renderer.gameLayer.clear();
		
		renderer.mainMenu.show(startGameCallback, loadGameCallback);
		renderer.gameCamera.visible = false;
	}
	
	override public function hideMainMenu():Void
	{
		renderer.mainMenu.visible = false;
		renderer.gameCamera.visible = true;
	}
	
	override public function showGameMenu(callback:GameMenuAction->Void, cancelCallback:Void->Void):Void
	{
		renderer.gameMenu.show(callback, cancelCallback);
	}
	
	override public function hideGameMenu():Void
	{
		renderer.gameMenu.visible = false;
	}
	
	override public function showSaveScreen(saveGameCallback:Int->Void, cancelCallback:Void->Void, data:Array<SaveDisplayData>):Void
	{
		renderer.saveLoadScreen.showSaveScreen(saveGameCallback, cancelCallback, data);
	}
	
	override public function hideSaveScreen():Void
	{
		renderer.saveLoadScreen.visible = false;
	}
	
	override public function showLoadScreen(loadGameCallback:Int->Void, cancelCallback:Void->Void, data:Array<SaveDisplayData>):Void
	{
		renderer.saveLoadScreen.showLoadScreen(loadGameCallback, cancelCallback, data);
	}
	
	override public function hideLoadScreen():Void
	{
		renderer.saveLoadScreen.visible = false;
	}
	
	override public function log(message:String, level:LogLevel):Void 
	{
		switch (level) 
		{
			case LInfo: FlxG.log.add(message);
			case LWarn: FlxG.log.warn(message);
			case LError: FlxG.log.error(message);
		}
		trace(message);
	}
}