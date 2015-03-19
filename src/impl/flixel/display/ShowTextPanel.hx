package impl.flixel.display;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import rpg.geom.Rectangle;

/**
 * ...
 * @author Kevin
 */
class ShowTextPanel extends FlxSpriteGroup
{
	public var completed(get, never):Bool;
	
	
	private var tween:FlxTween;
	private var text:FlxText;
	private var message:String;
	
	
	public function new() 
	{
		super();
		
		var frame = new Slice9Sprite("assets/images/system.png", new Rectangle(64, 0, 64, 64), new Rectangle(64+16, 16, 32, 32));
		frame.setGraphicSize(640, 150);
		
		var bg = new FlxSprite(5, 5);
		bg.loadGraphic("assets/images/system.png", true, 64, 64);
		bg.origin.set();
		bg.alpha = 0.9;
		bg.setGraphicSize(630, 140);
		
		text = new FlxText(100, 15, 500, "", 20);
		
		add(bg);
		add(frame);
		add(text);
		
		scrollFactor.set();
		y = 480 - 150;
	}
	
	public function showText(message:String):Void
	{
		this.message = message;
		text.text = "";
		tween = FlxTween.num(0, message.length, message.length / 15, null, function(v) text.text = message.substr(0, Std.int(v)));
	}
	
	public function showAll():Void
	{
		if (!completed)
			tween.cancel();
		text.text = message;
	}
	
	private inline function get_completed():Bool 
	{
		return tween == null || !tween.active;
	}
}