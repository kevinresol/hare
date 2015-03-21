package impl ;
import rpg.Engine;
import rpg.event.ScriptHost.ShowChoicesChoice;
import rpg.event.ScriptHost.ShowChoicesOptions;
import rpg.event.ScriptHost.ShowTextOptions;
import rpg.event.ScriptHost.TeleportPlayerOptions;
import rpg.map.GameMap;

/**
 * @author Kevin
 */

interface IImplementation 
{
	var engine:Engine;
	var assetManager:IAssetManager;
	
	/* ====== Sync Functions ====== */
	function changePlayerFacing(dir:Int):Void;
	function log(message:String):Void;
	function playSound(id:Int, volume:Float, pitch:Float):Void;
	
	function playBackgroundMusic(id:Int, volume:Float, pitch:Float):Void;
	function saveBackgroundMusic():Void;
	function restoreBackgroundMusic():Void;
	function fadeOutBackgroundMusic(ms:Int):Void;
	
	function fadeOutScreen(ms:Int):Void;
	function fadeInScreen(ms:Int):Void;
	function tintScreen(color:Int, ms:Int):Void;
	function flashScreen(color:Int, strength:Int, ms:Int):Void;
	function shakeScreen(power:Int, screen:Int, ms:Int):Void;
	
	/* ====== Async Functions ====== */
	
	/**
	 * Move the player
	 * @param	callback 	should be called by the implementation when the move is finished, will return true if the player continue moving (useful for determining the animation)
	 * @param	dx
	 * @param	dy
	 */
	function movePlayer(callback:Void->Bool, dx:Int, dy:Int):Void;
	
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
	
	/**
	 * Teleport the player to a certain location
	 * @param	callback	should be called by the implementation when the teleport is finished
	 * @param	map
	 * @param	x
	 * @param	y
	 * @param	options
	 */
	function teleportPlayer(callback:Void->Void, map:GameMap, x:Int, y:Int, options:TeleportPlayerOptions):Void;
}