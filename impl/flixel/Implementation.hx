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
	private var gameLayer:FlxGroup;
	private var hudLayer:FlxGroup;
	private var layers:Array<FlxTypedGroup<FlxObject>>; //0:floor, 1:below, 2:character, 3:above
	//private var objects:Map<Int, Object>;
	
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

	public function new() 
	{
		super();
	}
	
	@post
	public function postInject()
	{
		
		
	}
	
	
	
	override public function update(elapsed:Float):Void
	{
		
	}
	
	
	
	
	
	
}
