package impl.flixel;
import flixel.FlxCamera;


/**
 * ...
 * @author Kevin
 */
class Screen extends rpg.impl.Screen
{
	var gameCamera:FlxCamera;
	public function new(impl,gameCamera) 
	{
		super(impl);
		this.gameCamera = gameCamera;
	}
	
	
	override public function fadeOutScreen(ms:Int):Void 
	{
		gameCamera.fade(0, ms / 1000, false, null, true);
	}
	
	override public function fadeInScreen(ms:Int):Void 
	{
		gameCamera.fade(0, ms / 1000, true, null, true);
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