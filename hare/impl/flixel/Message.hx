package hare.impl.flixel;
import hare.event.ScriptHost;
import hare.impl.Message;
import hare.event.ScriptHost.InputNumberOptions;
import hare.event.ScriptHost.ShowChoicesChoice;
import hare.event.ScriptHost.ShowChoicesOptions;
import hare.event.ScriptHost.ShowTextOptions;
import hare.image.Image;
import hare.util.Tools;

/**
 * ...
 * @author Kevin
 */
class Message extends hare.impl.Message
{
	@inject
	public var renderer:Renderer;
	
	public function new() 
	{
		super();
	}
	
	override public function showText(callback:Void->Void, image:Image, message:String, options:ShowTextOptions):Void
	{
		Tools.checkCallback(callback);
		renderer.dialogPanel.showText(callback, image, message, options);
	}
	
	override public function showChoices(callback:Int->Void, image:Image, prompt:String, choices:Array<ShowChoicesChoice>, options:ShowChoicesOptions):Void
	{
		Tools.checkCallback(callback);
		renderer.dialogPanel.showChoices(callback, image, prompt, choices, options);
	}
	
	override public function inputNumber(callback:Int->Void, image:Image, prompt:String, numDigit:Int, options:InputNumberOptions):Void
	{
		Tools.checkCallback(callback);
		renderer.dialogPanel.inputNumber(callback, image, prompt, numDigit, options);
	}
}