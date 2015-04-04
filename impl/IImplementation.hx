package impl ;
import rpg.Engine;
import rpg.event.ScriptHost.InputNumberOptions;
import rpg.event.ScriptHost.ShowChoicesChoice;
import rpg.event.ScriptHost.ShowChoicesOptions;
import rpg.event.ScriptHost.ShowTextOptions;
import rpg.event.ScriptHost.TeleportPlayerOptions;
import rpg.map.GameMap;
import rpg.movement.InteractionManager.MovableObjectType;

/**
 * @author Kevin
 */

interface IImplementation 
{
	var engine:Engine;
	
	/* ===== System Functions ===== */
	function showMainMenu(startGameCallback:Void->Void, loadGameCallback:Void->Void):Void;
	function hideMainMenu():Void;
	function showGameMenu(cancelCallback:Void->Void):Void;
	function hideGameMenu():Void;
	function showSaveScreen(saveGameCallback:Int->Void, cancelCallback:Void->Void):Void;
	function hideSaveScreen():Void;
	function showLoadScreen(loadGameCallback:Int->Void, cancelCallback:Void->Void):Void;
	function hideLoadScreen():Void;
	
	/* ====== Sync Functions ====== */
	function log(message:String):Void;
	
	function createPlayer(name:String, image:String):Void;
	function changeObjectFacing(type:MovableObjectType, dir:Int):Void;
	function teleportPlayer(map:GameMap, x:Int, y:Int, options:TeleportPlayerOptions):Void;
	
	function playSound(id:Int, volume:Float, pitch:Float):Void;
	
	function playBackgroundMusic(id:Int, volume:Float, pitch:Float):Void;
	function playSystemSound(id:Int, volume:Float):Void;
	function saveBackgroundMusic():Void;
	function restoreBackgroundMusic():Void;
	function fadeOutBackgroundMusic(ms:Int):Void;
	function fadeInBackgroundMusic(ms:Int):Void;
	
	function fadeOutScreen(ms:Int):Void;
	function fadeInScreen(ms:Int):Void;
	function tintScreen(color:Int, ms:Int):Void;
	function flashScreen(color:Int, strength:Int, ms:Int):Void;
	function shakeScreen(power:Int, screen:Int, ms:Int):Void;
	
	/* ====== Async Functions ====== */
	
	/**
	 * Move an object
	 * @param	callback 	should be called by the implementation when the move is finished, will return true if the player continue moving (useful for determining the animation)
	 * @param	type		
	 * @param	dx
	 * @param	dy
	 * @param	speed 		in tiles/sec
	 */
	function moveObject(callback:Void->Bool, type:MovableObjectType, dx:Int, dy:Int, speed:Float):Void;
	
	/**
	 * Show a piece of text
	 * @param	callback	should be called by the implementation when the text is dismissed by player
	 * @param	characterId
	 * @param	message
	 * @param	options
	 */
	function showText(callback:Void->Void, characterId:String, message:String, options:ShowTextOptions):Void;
	
	/**
	 * Prompt the user to select from a list of choices
	 * @param	callback 	should be called by the implementation when a choice is made by the player, passing the selected index as paramenter (1-based)
	 * @param	prompt
	 * @param	choices
	 * @param	options
	 */
	function showChoices(callback:Int->Void, prompt:String, choices:Array<ShowChoicesChoice>, options:ShowChoicesOptions):Void;
	function inputNumber(callback:Int->Void, prompt:String, numDigit:Int, options:InputNumberOptions):Void;
}