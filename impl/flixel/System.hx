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
import impl.flixel.Implementation.Object;
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
	var layers:Array<FlxTypedGroup<FlxObject>>;
	var mainMenu:MainMenu;
	var gameMenu:GameMenu;
	var saveLoadScreen:SaveLoadScreen;
	var gameCamera:FlxCamera;
	var player:FlxSprite;
	var objects:Map<Int, Object>;
	
	var gameLayer:FlxGroup;
	
	public function new(impl,layers,mainMenu,gameMenu,saveLoadScreen,gameCamera,player,gameLayer,objects) 
	{
		super(impl);
		this.layers = layers;
		this.gameLayer = gameLayer;
		
		this.mainMenu = mainMenu;
		this.gameMenu = gameMenu;
		this.saveLoadScreen = saveLoadScreen;
		this.gameCamera = gameCamera;
		
		this.player = player;
		this.objects = objects;
	}
	
	override public function showMainMenu(startGameCallback:Void->Void, loadGameCallback:Void->Void):Void
	{
		if(layers[2] != null)
			layers[2].remove(player, true);
		
		while(layers.length > 0)
			layers.pop().destroy();
		
		gameLayer.clear();
		
		mainMenu.show(startGameCallback, loadGameCallback);
		gameCamera.visible = false;
	}
	
	override public function hideMainMenu():Void
	{
		mainMenu.visible = false;
		gameCamera.visible = true;
	}
	
	override public function showGameMenu(callback:GameMenuAction->Void, cancelCallback:Void->Void):Void
	{
		gameMenu.show(callback, cancelCallback);
	}
	
	override public function hideGameMenu():Void
	{
		gameMenu.visible = false;
	}
	
	override public function showSaveScreen(saveGameCallback:Int->Void, cancelCallback:Void->Void, data:Array<SaveDisplayData>):Void
	{
		saveLoadScreen.showSaveScreen(saveGameCallback, cancelCallback, data);
	}
	
	override public function hideSaveScreen():Void
	{
		saveLoadScreen.visible = false;
	}
	
	override public function showLoadScreen(loadGameCallback:Int->Void, cancelCallback:Void->Void, data:Array<SaveDisplayData>):Void
	{
		saveLoadScreen.showLoadScreen(loadGameCallback, cancelCallback, data);
	}
	
	override public function hideLoadScreen():Void
	{
		saveLoadScreen.visible = false;
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