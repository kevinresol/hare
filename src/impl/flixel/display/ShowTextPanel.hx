package impl.flixel.display;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import rpg.event.ScriptHost.ShowChoicesChoice;
import rpg.event.ScriptHost.ShowChoicesOptions;
import rpg.event.ScriptHost.ShowTextOptions;
import rpg.Events;
import rpg.geom.Rectangle;
import rpg.input.InputManager.InputKey;

/**
 * TODO handle disabled and hidden choices
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
	
	private var numChoices:Int;
	private var selected(default, set):Int;
	
	public function new() 
	{
		super();
		
		border = new Slice9Sprite("assets/images/system.png", new Rectangle(64, 0, 64, 64), new Rectangle(64+16, 16, 32, 32));
		border.setGraphicSize(640, 150);
		
		selector = new Slice9Sprite("assets/images/system.png", new Rectangle(64, 64, 32, 32), new Rectangle(64 + 8, 64 + 8, 16, 16));
		selector.setPosition(95, 40);
		selector.setGraphicSize(500, 25);
		selector.visible = false;
		
		background = new FlxSprite();
		background.loadGraphic("assets/images/system.png", true, 64, 64);
		background.origin.set();
		background.alpha = 0.9;
		background.setGraphicSize(640, 150);
		
		text = new FlxText(100, 15, 500, "", 20);
		
		add(background);
		add(border);
		add(text);
		add(selector);
		
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
					if(completed)
						selected -= 1;
					
				case KDown:
					if(completed)
						selected += 1;
					
				case KEnter:
					if (!completed)
					{
						showAll();
					}
					else
					{
						visible = false;
						Events.disable(showChoicesListener);
						showChoicesCallback(selected + 1);
					}
					
				default:
					
			}
		});
		Events.disable(showChoicesListener);
		
		
	}
	
	public function showChoices(callback:Int->Void, prompt:String, choices:Array<ShowChoicesChoice>, options:ShowChoicesOptions):Void
	{
		visible = true;
		selector.visible = false;
		handleOptions(options);
		
		showChoicesCallback = callback;
		numChoices = choices.length;
		selected = 0;
		
		message = prompt;
		for (c in choices)
		{
			message += "\n" + c.text;
		}
		text.text = "";
		tween = FlxTween.num(0, message.length, message.length / 15, {onComplete:function(t) selector.visible = true}, function(v) text.text = message.substr(0, Std.int(v)));
		
		Events.enable(showChoicesListener);
	}
	
	public function showText(callback:Void->Void, characterId:String, message:String, options:ShowTextOptions):Void
	{
		visible = true;
		selector.visible = false;
		handleOptions(options);
		
		showTextCallback = callback;
		
		this.message = message = (characterId == "" ? message : characterId + ": " + message);
		text.text = "";
		tween = FlxTween.num(0, message.length, message.length / 15, null, function(v) text.text = message.substr(0, Std.int(v)));
		
		Events.enable(showTextListener);
	}
	
	private function showAll():Void
	{
		if (!completed)
		{
			if (tween.onComplete != null) 
				tween.onComplete(tween);
			tween.cancel();
		}
		text.text = message;
	}
	
	private function handleOptions(options:ShowTextOptions):Void
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
				border.visible = false;
			case "dimmed":
				background.alpha = 0.5;
				border.visible = false;
			default:
				background.alpha = 0.9;
				border.visible = true;
		}
	}
	
	private inline function get_completed():Bool 
	{
		return tween == null || !tween.active;
	}
	
	private function set_selected(v:Int):Int
	{
		if (v < 0) v = numChoices - 1;
		else if (v >= numChoices) v = 0;
		
		selector.y = y + 40 + 25 * v;
		
		return selected = v;
	}
}