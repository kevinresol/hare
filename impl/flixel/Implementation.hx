package impl.flixel ;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxSort;
import impl.flixel.display.DialogPanel;
import impl.flixel.display.GameMenu;
import impl.flixel.display.lighting.LightingSystem;
import impl.flixel.display.MainMenu;
import impl.flixel.display.SaveLoadScreen;
import rpg.Engine;
import rpg.Events;
import rpg.geom.Direction;
import rpg.image.Image;
import rpg.map.GameMap;
import rpg.movement.InteractionManager.MovableObjectType;
import rpg.util.Tools;

/**
 * A HaxeFlixel implementation for rpg-engine
 * @author Kevin
 */
class Implementation extends rpg.impl.Implementation
{
	private var state:FlxState;
	private var gameLayer:FlxGroup;
	private var hudLayer:FlxGroup;
	private var layers:Array<FlxTypedGroup<FlxObject>>; //0:floor, 1:below, 2:character, 3:above
	private var objects:Map<Int, Object>;
	
	private var mainMenu:MainMenu;
	private var gameMenu:GameMenu;
	private var saveLoadScreen:SaveLoadScreen;
	private var dialogPanel:DialogPanel;
	private var player:FlxSprite;
	
	private var gameCamera:FlxCamera;
	private var hudCamera:FlxCamera;
	
	#if mobile
	private var virtualPad:FlxVirtualPad;
	#end

	public function new(state:FlxState) 
	{
		super();
		
		
		this.state = state;
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
		
		mainMenu = new MainMenu(this);
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
		
		
		
		assets = new impl.flixel.Assets(this);
		message = new impl.flixel.Message(this,dialogPanel);
		movement = new impl.flixel.Movement(this,player,objects,hudCamera);
		music = new impl.flixel.Music(this,cast assets);
		screen = new impl.flixel.Screen(this,gameCamera);
		sound = new impl.flixel.Sound(this,cast assets);
		system = new impl.flixel.System(this, layers, mainMenu, gameMenu, saveLoadScreen, gameCamera, player, gameLayer, objects);
		game = new impl.flixel.Game(this,layers,player,gameLayer,objects);
		
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