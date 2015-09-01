package impl.flixel;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxSort;
import impl.flixel.display.DialogPanel;
import impl.flixel.display.GameMenu;
import impl.flixel.display.lighting.LightingSystem;
import impl.flixel.display.MainMenu;
import impl.flixel.display.SaveLoadScreen;
import rpg.Engine;
import rpg.Events;
import rpg.image.Image;
import rpg.map.GameMap;

/**
 * ...
 * @author Kevin
 */
class Renderer extends rpg.impl.Renderer
{
	public var state:FlxState;
	
	public var gameLayer:FlxGroup;
	public var hudLayer:FlxGroup;
	public var layers:Array<FlxTypedGroup<FlxObject>>; //0:floor, 1:below, 2:character, 3:above
	public var objects:Map<Int, Object>;
	public var mainMenu:MainMenu;
	public var gameMenu:GameMenu;
	public var saveLoadScreen:SaveLoadScreen;
	public var dialogPanel:DialogPanel;
	public var player:FlxSprite;
	public var gameCamera:FlxCamera;
	public var hudCamera:FlxCamera;
	
	@inject
	public function new(engine:Engine) 
	{
		super();
		state = HareFlixel.state;
		//FlxG.switchState(state);
	}
	
	@post
	public function postInject()
	{
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
		
		injector.injectInto(mainMenu);
		injector.injectInto(gameMenu);
		injector.injectInto(saveLoadScreen);
		injector.injectInto(dialogPanel);
		
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
	
	override public function switchMap(map:GameMap):Void
	{
		if(layers[2] != null)
			layers[2].remove(player, true);
		
		while(layers.length > 0)
			layers.pop().destroy();
		
		gameLayer.clear();
		
		for (i in 0...4)
		{
			var layer = new FlxTypedGroup();
			gameLayer.add(layer);
			layers.push(layer);
		}
			
		// draw floor layer
		for (imageSource in map.floor.data.keys())
		{
			var tilemap = new FlxTilemap();
			var tiles = map.floor.data[imageSource];
			tiles = tiles.map(function(i) return i - 1);
			tilemap.loadMapFromArray(tiles, map.gridWidth, map.gridHeight, imageSource, map.tileWidth, map.tileHeight, null, 0, 0);
			layers[0].add(tilemap);
		}
		
		for (imageSource in map.below.data.keys())
		{
			var tilemap = new FlxTilemap();
			var tiles = map.below.data[imageSource];
			tiles = tiles.map(function(i) return i - 1);
			tilemap.loadMapFromArray(tiles, map.gridWidth, map.gridHeight, imageSource, map.tileWidth, map.tileHeight, null, 0, 0);
			layers[1].add(tilemap);
		}
		
		for (imageSource in map.above.data.keys())
		{
			var tilemap = new FlxTilemap();
			var tiles = map.above.data[imageSource];
			tiles = tiles.map(function(i) return i - 1);
			tilemap.loadMapFromArray(tiles, map.gridWidth, map.gridHeight, imageSource, map.tileWidth, map.tileHeight, null, 0, 0);
			layers[3].add(tilemap);
		}
		
		layers[2].add(player);
		
		var sortedObjects = map.objects.concat([]);
		sortedObjects.sort(function(o1, o2) return if(o1.layer == o2.layer) 0 else if(o1.layer > o2.layer) 1 else -1);
		
		for (object in sortedObjects)
		{
			if (object.visible)
			{
				var sprite = new FlxSprite(object.x * map.tileWidth, object.y * map.tileHeight);
				switch (object.displayType) 
				{
					case DTile(imageSource, tileId):
						sprite.loadGraphic(imageSource, true, 32, 32);
						sprite.animation.frameIndex = tileId - 1;
						
					case DCharacter(image):
						loadCharacterImage(sprite, image);
						
				}
				var index = Std.int(object.layer);
				if (index < 0) index = 0;
				if (index >= 3) index = 3;
				layers[index].add(sprite);
				objects[object.id] = new Object(sprite, layers[index]);
			}
		}
	}
	
	override public function createPlayer(image:Image):Void
	{
		player = new FlxSprite();
		
		loadCharacterImage(player, image);
	}
	
	private function loadCharacterImage(sprite:FlxSprite, image:Image):Void
	{
		
		sprite.loadGraphic(image.source, true, image.frameWidth, image.frameHeight);
		sprite.offset.set(0, image.frameHeight - 32 + 4);
		
		var i = image.getGlobalFrameIndex(0, 0);
		sprite.animation.add("walking-down", [i + 0, i + 1, i + 2, i + 1], 8);
		sprite.animation.add("down", [i + 1], 0);
		
		i = image.getGlobalFrameIndex(0, 1);
		sprite.animation.add("walking-left", [i + 0, i + 1, i + 2, i + 1], 8);
		sprite.animation.add("left", [i + 1], 0);
		
		i = image.getGlobalFrameIndex(0, 2);
		sprite.animation.add("walking-right", [i + 0, i + 1, i + 2, i + 1], 8);
		sprite.animation.add("right", [i + 1], 0);
		
		i = image.getGlobalFrameIndex(0, 3);
		sprite.animation.add("walking-up", [i + 0, i + 1, i + 2, i + 1], 8);
		sprite.animation.add("up", [i + 1], 0);
		
		sprite.animation.play("down");
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