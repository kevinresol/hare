package impl.flixel;
import impl.flixel.display.DialogPanel;
import rpg.event.ScriptHost.InputNumberOptions;
import rpg.event.ScriptHost.ShowChoicesChoice;
import rpg.event.ScriptHost.ShowChoicesOptions;
import rpg.event.ScriptHost.ShowTextOptions;
import rpg.image.Image;
import rpg.util.Tools;

/**
 * ...
 * @author Kevin
 */
class Message extends rpg.impl.Message
{
	var dialogPanel:DialogPanel;
	
	public function new(impl, dialogPanel:DialogPanel) 
	{
		super(impl);
		this.dialogPanel = dialogPanel;
	}
	
	override public function showText(callback:Void->Void, image:Image, message:String, options:ShowTextOptions):Void
	{
		Tools.checkCallback(callback);
		dialogPanel.showText(callback, image, message, options);
	}
	
	override public function showChoices(callback:Int->Void, image:Image, prompt:String, choices:Array<ShowChoicesChoice>, options:ShowChoicesOptions):Void
	{
		Tools.checkCallback(callback);
		dialogPanel.showChoices(callback, image, prompt, choices, options);
	}
	
	override public function inputNumber(callback:Int->Void, image:Image, prompt:String, numDigit:Int, options:InputNumberOptions):Void
	{
		Tools.checkCallback(callback);
		dialogPanel.inputNumber(callback, image, prompt, numDigit, options);
	}
}