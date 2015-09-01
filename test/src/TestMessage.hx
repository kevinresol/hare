package ;
import rpg.event.ScriptHost.InputNumberOptions;
import rpg.event.ScriptHost.ShowChoicesChoice;
import rpg.event.ScriptHost.ShowChoicesOptions;
import rpg.event.ScriptHost.ShowTextOptions;
import rpg.image.Image;

/**
 * ...
 * @author Kevin
 */
class TestMessage extends rpg.impl.Message
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