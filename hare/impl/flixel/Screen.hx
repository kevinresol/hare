package hare.impl.flixel;
import flixel.FlxCamera;
import hare.impl.Screen;


/**
 * ...
 * @author Kevin
 */
class Screen extends hare.impl.Screen
{
	@inject
	public var renderer:Renderer;
	
	public function new() 
	{
		super();
	}
	
	
	override public function fadeOutScreen(ms:Int):Void 
	{
		renderer.gameCamera.fade(0, ms / 1000, false, null, true);
	}
	
	override public function fadeInScreen(ms:Int):Void 
	{
		renderer.gameCamera.fade(0, ms / 1000, true, null, true);
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