package ;
import hare.impl.Music;

/**
 * ...
 * @author Kevin
 */
class TestMusic extends hare.impl.Music
{

	public function new() 
	{
		super();
	}
	
	override public function playBackgroundMusic(id:Int, volume:Float, pitch:Float):Void
	{
		HareTest.lastCalledCommand.set(Macro.getCurrentFunction(), [id, volume, pitch]);
	}
	override public function saveBackgroundMusic():Void 
	{
		HareTest.lastCalledCommand.set(Macro.getCurrentFunction(), []);
	}
	
	override public function restoreBackgroundMusic():Void 
	{
		HareTest.lastCalledCommand.set(Macro.getCurrentFunction(), []);
	}
	
	override public function fadeOutBackgroundMusic(ms:Int):Void 
	{
		HareTest.lastCalledCommand.set(Macro.getCurrentFunction(), [ms]);
	}
	
	override public function fadeInBackgroundMusic(ms:Int):Void 
	{
		HareTest.lastCalledCommand.set(Macro.getCurrentFunction(), [ms]);
	}

}