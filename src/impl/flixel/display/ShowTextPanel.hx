package impl.flixel.display;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import rpg.event.ScriptHost.ShowChoicesChoice;
import rpg.event.ScriptHost.ShowTextOptions;
import rpg.Events;
import rpg.geom.Rectangle;
import rpg.input.InputManager.InputKey;

/**
 * ...
 * @author Kevin
 */
class ShowTextPanel extends FlxSpriteGroup
{
	public var completed(get, never):Bool;
	
	private var border:Slice9Sprite;
	private var selector:Slice9Sprite;
	private var background:FlxSprite;
	private var tween:FlxTween;
	private var text:FlxText;
	private var message:String;
	
	private var showTextListener:Int;
	private var showChoicesListener:Int;
	
	private var showTextCallback:Void->Void;
	private var showChoicesCallback:Int->Void;
	
	public function new() 
	{
		super();
		
		border = new Slice9Sprite("assets/images/system.png", new Rectangle(64, 0, 64, 64), new Rectangle(64+16, 16, 32, 32));
		border.setGraphicSize(640, 150);
		
		selector = new Slice9Sprite("assets/images/system.png", new Rectangle(64, 64, 32, 32), new Rectangle(64 + 8, 64 + 8, 16, 16));
		selector.setPosition(100, 40);
		selector.setGraphicSize(500, 30);
		
		background = new FlxSprite();
		background.loadGraphic("assets/images/system.png", true, 64, 64);
		background.origin.set();
		background.alpha = 0.9;
		background.setGraphicSize(640, 150);
		
		text = new FlxText(100, 15, 500, "", 20);
		
		add(background);
		add(border);
		add(text);
		
		scrollFactor.set();
		y = 480 - 150;
		
		
		showTextListener = Events.on("key.justPressed", function(key:InputKey)
		{
			if (key == KEnter)
			{
				if (!completed)
				{
					showAll();
				}
				else
				{
					visible = false;
					Events.disable(showTextListener);
					showTextCallback();
				}
			}
		});
		Events.disable(showTextListener);
		
		
		showChoicesListener = Events.on("key.justPressed", function(key:InputKey)
		{
			switch (key) 
			{
				case KUp:
					
				case KDown:
					
				case KEnter:
					if (!completed)
					{
						showAll();
					}
					else
					{
						visible = false;
						Events.disable(showChoicesListener);
						showChoicesCallback(1);
					}
					
				default:
					
			}
		});
		Events.disable(showChoicesListener);
		
		
	}
	
	public function showChoices(prompt:String, choices:Array<ShowChoicesChoice>):Void
	{
		message = prompt;
		for (c in choices)
		{
			message += "\n" + c.text;
		}
		visible = true;
		text.text = "";
		tween = FlxTween.num(0, message.length, message.length / 15, null, function(v) text.text = message.substr(0, Std.int(v)));
	}
	
	public function showText(callback:Void->Void, characterId:String, message:String, options:ShowTextOptions):Void
	{
		y = switch (options.position) 
		{
			case "top": 0;
			case "center": (480 - 150) / 2;
			default: 480 - 150;
		}
		
		switch (options.background) 
		{
			case "transparent":
				background.alpha = 0;
				border.alpha = 0;
			case "dimmed":
				background.alpha = 0.5;
				border.alpha = 0;
			default:
				background.alpha = 0.9;
				border.alpha = 1;
		}
		trace("show text");
		visible = true;
		showTextCallback = callback;
		this.message = message = (characterId == "" ? message : characterId + ": " + message);
		text.text = "";
		tween = FlxTween.num(0, message.length, message.length / 15, null, function(v) text.text = message.substr(0, Std.int(v)));
		Events.enable(showTextListener);
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