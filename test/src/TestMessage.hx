package ;
import hare.event.ScriptHost;
import hare.impl.Message;
import hare.event.ScriptHost.InputNumberOptions;
import hare.event.ScriptHost.ShowChoicesChoice;
import hare.event.ScriptHost.ShowChoicesOptions;
import hare.event.ScriptHost.ShowTextOptions;
import hare.image.Image;

/**
 * ...
 * @author Kevin
 */
class TestMessage extends hare.impl.Message
{

	public function new() 
	{
		super();
	}
	
	override public function showText(callback:Void->Void, image:Image, message:String, options:ShowTextOptions):Void 
	{
		HareTest.lastCalledCommand.set(Macro.getCurrentFunction(), [/*image, */message, options]);
		callback();
	}
	
	override public function showChoices(callback:Int->Void, image:Image, prompt:String, choices:Array<ShowChoicesChoice>, options:ShowChoicesOptions):Void 
	{
		HareTest.lastCalledCommand.set(Macro.getCurrentFunction(), [prompt, choices, options]);
		callback(1);
	}

	override public function inputNumber(callback:Int->Void, image:Image, prompt:String, numDigit:Int, options:InputNumberOptions):Void
	{
		
	}
}