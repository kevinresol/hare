package hare.impl;
import hare.event.ScriptHost;
import hare.event.ScriptHost.InputNumberOptions;
import hare.event.ScriptHost.ShowChoicesChoice;
import hare.event.ScriptHost.ShowChoicesOptions;
import hare.event.ScriptHost.ShowTextOptions;
import hare.image.Image;

/**
 * ...
 * @author Kevin
 */
class Message extends Module
{

	public function new() 
	{
		super();
	}
	
	/**
	 * Show a piece of text
	 * @param	callback	should be called by the implementation when the text is dismissed by player
	 * @param	image
	 * @param	message
	 * @param	options
	 */
	public function showText(callback:Void->Void, image:Image, message:String, options:ShowTextOptions):Void
	{
		
	}

	
	/**
	 * Prompt the user to select from a list of choices
	 * @param	callback 	should be called by the implementation when a choice is made by the player, passing the selected index as paramenter (1-based)
	 * @param	prompt
	 * @param	choices
	 * @param	options
	 */
	public function showChoices(callback:Int->Void, image:Image, prompt:String, choices:Array<ShowChoicesChoice>, options:ShowChoicesOptions):Void
	{
		
	}

	public function inputNumber(callback:Int->Void, image:Image, prompt:String, numDigit:Int, options:InputNumberOptions):Void
	{
		
	}
}