package;

/**
 * ...
 * @author Kevin
 */
class TestSound extends rpg.impl.Sound
{

	public function new() 
	{
		super();
	}
	
	override public function playSound(id:Int, volume:Float, pitch:Float):Void
	{
		HareTest.lastCalledCommand.set(Macro.getCurrentFunction(), [id, volume, pitch]);
	}

	override public function playSystemSound(id:Int, volume:Float):Void
	{
		
	}
}