package ;
import hare.impl.Screen;

/**
 * ...
 * @author Kevin
 */
class TestScreen extends hare.impl.Screen
{

	public function new() 
	{
		super();
	}
	
	 
	override public function fadeOutScreen(ms:Int):Void 
	{
		HareTest.lastCalledCommand.set(Macro.getCurrentFunction(), [ms]);
	}
	
	override public function fadeInScreen(ms:Int):Void 
	{
		HareTest.lastCalledCommand.set(Macro.getCurrentFunction(), [ms]);
	}
	
	override public function tintScreen(color:Int, ms:Int):Void 
	{
		
	}
	
	override public function flashScreen(color:Int, strength:Int, ms:Int):Void 
	{
		
	}
	
	override public function shakeScreen(power:Int, screen:Int, ms:Int):Void 
	{
		
	}

}