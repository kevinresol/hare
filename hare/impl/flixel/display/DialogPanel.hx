package hare.impl.flixel.display;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import hare.event.ScriptHost;
import hare.input.InputManager;
import hare.event.ScriptHost.InputNumberOptions;
import hare.event.ScriptHost.ShowChoicesChoice;
import hare.event.ScriptHost.ShowChoicesOptions;
import hare.event.ScriptHost.ShowTextOptions;
import hare.Events;
import hare.image.Image;
import hare.input.InputManager.InputKey;

/**
 * TODO handle disabled and hidden choices
 * @author Kevin
 */
class DialogPanel extends FlxSpriteGroup
{
	private static inline var WIDTH:Int = 550;
	private static inline var HEIGHT:Int = 116;
	
	/**
	 * Text by default are shown letter by letter.
	 * This Bool indicates if the text has been completely shown
	 */
	public var completed(get, never):Bool;
	
	/**
	 * The border sprite
	 */
	private var border:Slice9Sprite;
	
	/**
	 * The selector sprite for choices
	 */
	private var selector:Slice9Sprite;
	private var background:Background;
	private var downArrow:FlxSprite;
	private var tween:FlxTween;
	private var text:Text;
	private var message:String;
	private var inputNumberPanel:InputNumberPanel;
	private var faceSprite:FlxSprite;
	
	private var showTextListener:Int;
	private var showChoicesListener:Int;
	private var inputNumberListener:Int;
	
	private var showTextCallback:Void->Void;
	private var showChoicesCallback:Int->Void;
	private var inputNumberCallback:Int->Void;
	
	private var numChoices:Int;
	private var selected(default, set):Int;
	
	public function new() 
	{
		super();
		
		border = new Border(0, 0, WIDTH, HEIGHT);
		
		
		selector = new Selector(115, 40, WIDTH - 140, 25);
		
		downArrow = new FlxSprite();
		downArrow.loadGraphic("assets/images/system/system.png", true, 16, 16);
		downArrow.animation.add("move", [38, 39, 46, 47], 5);
		downArrow.animation.play("move");
		downArrow.setPosition((WIDTH - downArrow.width) / 2, 120);
		
		background = new Background();
		
		text = new Text(0, 6, 1000, "", 20);
		
		faceSprite = new FlxSprite(10, 10);
		
		inputNumberPanel = new InputNumberPanel();
		inputNumberPanel.y = -30;
		
		add(background);
		add(border);
		add(text);
		add(faceSprite);
		add(selector);
		add(downArrow);
		add(inputNumberPanel);
		
		visible = false;
		scrollFactor.set();
		x = (FlxG.width - WIDTH) / 2;
		y = FlxG.height - HEIGHT;
		
		
		showTextListener = Events.on("key.justPressed", function(key:InputKey)
		{
			if (key == KEnter)
			{
				if (!completed)
				{
					// immediately show all text
					showAll();
				}
				else
				{
					// dismiss this text panel
					visible = false;
					Events.disable(showTextListener);
					showTextCallback();
				}
			}
		});
		// disable the listener for now, it will be enabled when showText
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
						// immediately show all text
						showAll();
					}
					else
					{
						// dismiss this text panel
						visible = false;
						Events.disable(showChoicesListener);
						showChoicesCallback(selected + 1);
					}
					
				default:
					
			}
		});
		// disable the listener for now, it will be enabled when showChoices
		Events.disable(showChoicesListener);
		
		
		inputNumberListener = Events.on("key.justPressed", function(key:InputKey)
		{
			switch (key) 
			{
				case KEnter:
					if (!completed)
					{
						// immediately show all text
						showAll();
					}
					else
					{
						// dismiss this text panel
						visible = false;
						Events.disable(inputNumberListener);
						inputNumberPanel.hide(); // disable its event listener
						inputNumberCallback(inputNumberPanel.number);
					}
					
				default:
					
			}
		});
		// disable the listener for now, it will be enabled when showChoices
		Events.disable(inputNumberListener);
	}
	
	public function showChoices(callback:Int->Void, image:Image, prompt:String, choices:Array<ShowChoicesChoice>, options:ShowChoicesOptions):Void
	{
		visible = true;
		selector.visible = false;
		inputNumberPanel.visible = false;
		handleOptions(options);
		
		showChoicesCallback = callback;
		numChoices = choices.length;
		selected = 0;
		
		handleFaceSprite(image);
		
		message = prompt;
		for (c in choices)
		{
			message += "\n  > " + c.text;
		}
		text.text = "";
		tween = FlxTween.num(0, message.length, message.length / 15, {onComplete:function(t) selector.visible = true}, function(v) text.text = message.substr(0, Std.int(v)));
		
		Events.enable(showChoicesListener);
	}
	
	public function showText(callback:Void->Void, image:Image, message:String, options:ShowTextOptions):Void
	{
		visible = true;
		selector.visible = false;
		inputNumberPanel.visible = false;
		handleOptions(options);
		
		showTextCallback = callback;
		
		handleFaceSprite(image);
		
		this.message = message;
		text.text = "";
		tween = FlxTween.num(0, message.length, message.length / 15, null, function(v) text.text = message.substr(0, Std.int(v)));
		
		Events.enable(showTextListener);
	}
	
	public function inputNumber(callback:Int->Void, image:Image, prompt:String, numDigit:Int, options:InputNumberOptions):Void
	{
		visible = true;
		selector.visible = false;
		inputNumberPanel.visible = false;
		handleOptions(options);
		
		inputNumberCallback = callback;
		handleFaceSprite(image);
		message = prompt;
		text.text = "";
		tween = FlxTween.num(0, message.length, message.length / 15, { onComplete: function(t) inputNumberPanel.show(numDigit) }, function(v) text.text = message.substr(0, Std.int(v)));
		
		Events.enable(inputNumberListener);
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
	
	private function handleFaceSprite(image:Image):Void
	{
		if (image != null)
		{
			faceSprite.loadGraphic(image.source, true, image.frameWidth, image.frameHeight);
			faceSprite.animation.frameIndex = image.index;
		}
		
		faceSprite.visible = image != null;
		text.x = image == null ? x + 10 : x + 120;
		selector.x = image == null ? x + 5 : x + 115;
	}
	
	private function handleOptions(options:ShowTextOptions):Void
	{
		y = switch (options.position) 
		{
			case PTop: 0;
			case PCenter: (480 - HEIGHT) / 2;
			case PBottom: 480 - HEIGHT;
		}
		
		switch (options.background) 
		{
			case BTransparent:
				background.bgColor.visible = false;
				background.hideStrips();
				border.visible = false;
			case BDimmed:
				background.bgColor.visible = true;
				background.hideStrips();
				background.setPosition(0, y);
				background.setGraphicSize(FlxG.width, HEIGHT);
				border.visible = false;
			case BNormal:
				background.bgColor.visible = true;
				background.showStrips();
				background.setPosition(x + 5, y + 5);
				background.setGraphicSize(WIDTH - 10, HEIGHT - 10);
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
		
		selector.y = y + 33 + 25 * v;
		
		return selected = v;
	}
}

private class Background extends FlxSpriteGroup
{
	public var bgColor:FlxSprite;
	private var strips:Array<FlxSprite>;
	private var stripsVisible:Bool;
	
	public function new()
	{
		super();
		
		bgColor = new FlxSprite();
		bgColor.loadGraphic("assets/images/system/system.png", true, 32, 32);
		bgColor.animation.frameIndex = 4;
		bgColor.origin.set();
		bgColor.alpha = 0.9;
		add(bgColor);
		
		strips = [];
	}
	
	public function showStrips():Void
	{
		stripsVisible = true;
		for (s in strips) s.visible = true;
	}
	
	public function hideStrips():Void
	{
		stripsVisible = false;
		for (s in strips) s.visible = false;
	}
	
	override public function setGraphicSize(width:Int = 0, height:Int = 0):Void 
	{
		bgColor.setGraphicSize(width, height);
		
		var numStrips = Std.int(height / 64) + 1;
		var remainingHeight = height % 64;
		
		for (i in 0...(numStrips > strips.length ? numStrips : strips.length))
		{
			if (i < numStrips)
			{
				if (strips[i] == null)
				{
					var s = new FlxSprite(0, i * 64);
					s.loadGraphic("assets/images/system/system.png", true, 64, 64); //TODO: now it overflows at the bottom, may need to define the frame explicitly using remainingHeight
					s.animation.frameIndex = 2;
					s.origin.set();
					add(s);
					strips[i] = s;
				}
				
				var s = strips[i];
				s.scale.x = width / s.frameWidth;
			}
			strips[i].visible = stripsVisible && i < numStrips;
		}
	}
}