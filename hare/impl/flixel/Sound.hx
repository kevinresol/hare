package hare.impl.flixel;
import flixel.FlxG;
import hare.impl.Sound;


/**
 * ...
 * @author Kevin
 */
class Sound extends hare.impl.Sound
{
	@inject
	public var assets:Assets;
	
	public function new() 
	{
		super();
	}
	
	
	override public function playSound(id:Int, volume:Float, pitch:Float):Void
	{
		var s = FlxG.sound.play(assets.getSound(id), volume);
		s.pitch = pitch;
	}
	
	override public function playSystemSound(id:Int, volume:Float):Void
	{
		FlxG.sound.play(assets.getSystemSound(id), volume);
	}
	
}