package impl.flixel;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSort;
import impl.flixel.display.DialogPanel;
import impl.flixel.display.GameMenu;
import impl.flixel.display.lighting.LightingSystem;
import impl.flixel.display.MainMenu;
import impl.flixel.display.SaveLoadScreen;
import rpg.Engine;
import rpg.Events;
import rpg.image.Image;

/**
 * ...
 * @author Kevin
 */
class Renderer extends rpg.impl.Renderer
{
	var state:FlxState;
	
	var gameLayer:FlxGroup;
	var hudLayer:FlxGroup;
	var layers:Array<FlxTypedGroup<FlxObject>>; //0:floor, 1:below, 2:character, 3:above
	var objects:Map<Int, Object>;
	
	
	var mainMenu:MainMenu;
	var gameMenu:GameMenu;
	var saveLoadScreen:SaveLoadScreen;
	var dialogPanel:DialogPanel;
	var player:FlxSprite;
	
	var gameCamera:FlxCamera;
	var hudCamera:FlxCamera;
	
	@inject
	public function new(engine:Engine) 
	{
		super();
		state = new RpgState(engine);
		
		state.bgColor = 0;
		state.add(gameLayer = new FlxGroup());
		state.add(hudLayer = new FlxGroup());
		
		#if mobile
		virtualPad = new FlxVirtualPad(FULL, A_B);
		
		virtualPad.scale.set(2, 2);
		virtualPad.buttonUp.updateHitbox();
		virtualPad.buttonLeft.updateHitbox();
		virtualPad.buttonRight.updateHitbox();
		virtualPad.buttonDown.updateHitbox();
		virtualPad.buttonA.updateHitbox();
		virtualPad.buttonB.updateHitbox();
		
		var size = virtualPad.buttonUp.width;
		virtualPad.buttonUp.setPosition(size * 0.9, FlxG.height - size * 3 * 0.9);
		virtualPad.buttonLeft.setPosition(0, FlxG.height - size * 2 * 0.9);
		virtualPad.buttonRight.setPosition(size * 2 * 0.9, FlxG.height - size * 2 * 0.9);
		virtualPad.buttonDown.setPosition(size * 0.9, FlxG.height - size * 0.9);
		virtualPad.buttonA.setPosition(FlxG.width - size, FlxG.height - size);
		virtualPad.buttonB.setPosition(0, 0);
		
		virtualPad.alpha = 0.3;
		hudLayer.add(virtualPad);
		#end
		
		mainMenu = new MainMenu();
		gameMenu = new GameMenu();
		saveLoadScreen = new SaveLoadScreen();
		dialogPanel = new DialogPanel();
		
		hudLayer.add(dialogPanel);
		hudLayer.add(mainMenu);
		hudLayer.add(gameMenu);
		hudLayer.add(saveLoadScreen);
		
		
		
		gameCamera = FlxG.camera;
		FlxG.cameras.add(hudCamera = new FlxCamera());
		FlxCamera.defaultCameras = [gameCamera];
		setCamera(hudLayer, hudCamera);
		
		
		
		var lighting = new LightingSystem(state);
		FlxG.addPostProcess(lighting);
		FlxG.addChildBelowMouse(hudCamera.flashSprite, 1);
		
		#if debug
		FlxG.console.registerFunction("rl", function() { FlxG.removePostProcess(lighting); lighting.disable();} );
		FlxG.console.registerFunction("al", function() { FlxG.addPostProcess(lighting); lighting.enable(); } );
		#end
		
		layers = [];
		objects = new Map();
		
		Events.on("event.erased", function(id:Int)
		{
			var o = objects[id];
			if(o != null)
				o.layer.remove(o.sprite, true);
		});
	}
	
	override public function init(mainMenuBackgroundImage:Image):Void
	{
		mainMenu.setBackgroundImage(mainMenuBackgroundImage);
		
		#if mobile
		virtualPad.buttonLeft.onUp.callback = engine.release.bind(KLeft);
		virtualPad.buttonRight.onUp.callback = engine.release.bind(KRight);
		virtualPad.buttonUp.onUp.callback = engine.release.bind(KUp);
		virtualPad.buttonDown.onUp.callback = engine.release.bind(KDown);
		virtualPad.buttonA.onUp.callback = engine.release.bind(KEnter);
		virtualPad.buttonB.onUp.callback = engine.release.bind(KEsc);
		
		virtualPad.buttonLeft.onOut.callback = engine.release.bind(KLeft);
		virtualPad.buttonRight.onOut.callback = engine.release.bind(KRight);
		virtualPad.buttonUp.onOut.callback = engine.release.bind(KUp);
		virtualPad.buttonDown.onOut.callback = engine.release.bind(KDown);
		virtualPad.buttonA.onOut.callback = engine.release.bind(KEnter);
		virtualPad.buttonB.onOut.callback = engine.release.bind(KEsc);
		
		virtualPad.buttonLeft.onDown.callback = engine.press.bind(KLeft);
		virtualPad.buttonRight.onDown.callback = engine.press.bind(KRight);
		virtualPad.buttonUp.onDown.callback = engine.press.bind(KUp);
		virtualPad.buttonDown.onDown.callback = engine.press.bind(KDown);
		virtualPad.buttonA.onDown.callback = engine.press.bind(KEnter);
		virtualPad.buttonB.onDown.callback = engine.press.bind(KEsc);
		#end
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (layers[2] != null)
		{
			layers[2].sort(FlxSort.byY);
		}
	}
	private function setCamera(object:FlxBasic, camera:FlxCamera):Void
	{
		if (Std.is(object, FlxGroup))
		{
			var g:FlxGroup = cast object;
			for (m in g.members) setCamera(m, camera);
		}
		else if (Std.is(object, FlxSpriteGroup))
		{
			var g:FlxSpriteGroup = cast object;
			for (m in g.members) setCamera(m, camera);
		}
		object.camera = camera;
	}
	
}

class RpgState extends FlxState
{
	var engine:Engine;
	
	public function new(engine)
	{
		super();
		this.engine = engine;
	}
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		engine.update(elapsed);
		
		var justPressed = FlxG.keys.justPressed;
		var justReleased = FlxG.keys.justReleased;
		
		if (justReleased.LEFT)
			engine.release(KLeft);
		if (justReleased.RIGHT)
			engine.release(KRight);
		if (justReleased.UP)
			engine.release(KUp);
		if (justReleased.DOWN)
			engine.release(KDown);
		if (justReleased.ENTER || justReleased.SPACE)
			engine.release(KEnter);
		if (justReleased.ESCAPE)
			engine.release(KEsc);
			
		if (justPressed.LEFT)
			engine.press(KLeft);
		if (justPressed.RIGHT)
			engine.press(KRight);
		if (justPressed.UP)
			engine.press(KUp);
		if (justPressed.DOWN)
			engine.press(KDown);
		if (justPressed.ENTER || justPressed.SPACE)
			engine.press(KEnter);
		if (justPressed.ESCAPE)
			engine.press(KEsc);
			
		
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

}

class Object
{
	public var layer:FlxTypedGroup<FlxObject>;
	public var sprite:FlxSprite;
	
	public function new(sprite, layer)
	{
		this.sprite = sprite;
		this.layer = layer;
	}
}