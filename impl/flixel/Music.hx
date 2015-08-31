package impl.flixel;
import flixel.FlxG;

/**
 * ...
 * @author Kevin
 */
class Music extends rpg.impl.Music
{
	var assets:Assets;
	
	public function new(impl,assets:Assets) 
	{
		super();
		this.assets = assets;
	}
	
	override public function playBackgroundMusic(id:Int, volume:Float, pitch:Float):Void
	{
		FlxG.sound.playMusic(assets.getMusic(id), volume);
		FlxG.sound.music.pitch = pitch;
	}
	
	
	override public function saveBackgroundMusic():Void
	{
		if(FlxG.sound.music != null)
			FlxG.sound.music.pause();
	}
	
	override public function restoreBackgroundMusic():Void
	{
		FlxG.sound.music.resume();
	}
	
	override public function fadeOutBackgroundMusic(ms:Int):Void
	{
		FlxG.sound.music.fadeOut(ms/1000,0);
	}
	
	override public function fadeInBackgroundMusic(ms:Int):Void
	{
		FlxG.sound.music.fadeIn(ms/1000,0);
	}
}