package hare;
import hare.impl.Assets;
import hare.impl.Game;
import hare.impl.Movement;
import hare.impl.Music;
import hare.impl.Renderer;
import hare.impl.Screen;
import hare.impl.Sound;
import hare.impl.System;
import hare.impl.Message;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

/**
 * ...
 * @author Kevin
 */
@:access(hare)
class ScriptTest
{
	private var engine:Engine;
	
	@inject 
	public var assets:Assets;
	@inject 
	public var game:Game;
	@inject 
	public var sound:Sound;
	@inject 
	public var system:System;
	@inject 
	public var music:Music;
	@inject 
	public var screen:Screen;
	@inject 
	public var message:Message;
	@inject 
	public var movement:Movement;
	@inject 
	public var renderer:Renderer;
	
	public function new() 
	{
		
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
		engine = new Engine({
			game:TestGame,
			music:TestMusic,
			sound:TestSound,
			assets:TestAssets,
			screen:TestScreen,
			system:TestSystem,
			message:TestMessage,
			movement:TestMovement,
			renderer:TestRenderer,
		});
		engine.injector.injectInto(this);
		engine.startGame();
	}
	
	@Before
	public function before():Void
	{
		HareTest.lastCalledCommand.clear();
	}
	
	@Test
	public function testGameVar():Void
	{
		Assert.isTrue(engine.eventManager.execute('return getGameVar("testGlobalVar")') == null);
		Assert.isTrue(engine.eventManager.execute('setGameVar("testGlobalVar", 12.3) return getGameVar("testGlobalVar")') == 12.3);
	}
	
	@Test
	public function testMessage():Void
	{
		engine.eventManager.execute('message.showText("face1", "default options")');
		Assert.isTrue(HareTest.lastCalledCommand.is(message.showText, ["default options", {background:"normal", position:"bottom"}]));
		
		engine.eventManager.execute('message.showText("face2","provided options", {background="dimmed", position="top"})');
		Assert.isTrue(HareTest.lastCalledCommand.is(message.showText, ["provided options", {background:"dimmed", position:"top"}]));
		
		engine.eventManager.execute('message.showChoices("face1","select",{{text="c1"},{text="c2"}})');
		Assert.isTrue(HareTest.lastCalledCommand.is(message.showChoices, ["select", [{text:"c1", disabled:false, hidden:false}, {text:"c2", disabled:false, hidden:false}], {background:"normal", position:"bottom"}]));
		
		engine.eventManager.execute('message.showChoices("face2","select",{{text="c1", disabled=true},{text="c2", hidden=true}}, {background="dimmed", position="center"})');
		Assert.isTrue(HareTest.lastCalledCommand.is(message.showChoices, ["select", [{text:"c1", disabled:true, hidden:false}, {text:"c2", disabled:false, hidden:true}], {background:"dimmed", position:"center"}]));
		
	}
	
	@Test
	public function testSound():Void
	{
		engine.eventManager.execute('sound.play(1,2,3)');
		Assert.isTrue(HareTest.lastCalledCommand.is(sound.playSound, [1, 2, 3]));
	}
	
	@Test
	public function testMusic():Void
	{
		engine.eventManager.execute('music.play(1,2,3)');
		Assert.isTrue(HareTest.lastCalledCommand.is(music.playBackgroundMusic, [1, 2, 3]));
		
		engine.eventManager.execute('music.pause()');
		Assert.isTrue(HareTest.lastCalledCommand.is(music.saveBackgroundMusic, []));
		
		engine.eventManager.execute('music.resume()');
		Assert.isTrue(HareTest.lastCalledCommand.is(music.restoreBackgroundMusic, []));
		
		engine.eventManager.execute('music.fadeOut(25, {wait=false})');
		Assert.isTrue(HareTest.lastCalledCommand.is(music.fadeOutBackgroundMusic, [25]));
		
		engine.eventManager.execute('music.fadeIn(20, {wait=false})');
		Assert.isTrue(HareTest.lastCalledCommand.is(music.fadeInBackgroundMusic, [20]));
	}
	
	@Test
	public function testScreen():Void
	{
		engine.eventManager.execute('screen.fadeIn(21)');
		Assert.isTrue(HareTest.lastCalledCommand.is(screen.fadeInScreen, [21]));
		
		engine.eventManager.execute('screen.fadeOut(27)');
		Assert.isTrue(HareTest.lastCalledCommand.is(screen.fadeOutScreen, [27]));
	}
	
	@Test
	public function testItem():Void
	{
		var r = engine.eventManager.execute('return item.get(1)');
		Assert.isTrue(r == 0);
		
		r = engine.eventManager.execute('item.change(1,1) return item.get(1)');
		Assert.isTrue(r == 1);
		
		r = engine.eventManager.execute('return item.get(2)');
		Assert.isTrue(r == 0);
		
		r = engine.eventManager.execute('item.change(2,2) return item.get(2)');
		Assert.isTrue(r == 2);
	}
	
	@Test
	public function testTeleportPlayer():Void
	{
		runScript('movement.teleportPlayer(1, 3, 5, {facing="right", fading="none"})');
		Assert.isTrue(HareTest.lastCalledCommand.is(movement.teleportPlayer, [engine.mapManager.getMap(1), 3, 5, {facing:"right", fading:"none"}]));
		
		runScript('movement.teleportPlayer(1, 3, 5, {fading="none"})');
		Assert.isTrue(HareTest.lastCalledCommand.is(movement.teleportPlayer, [engine.mapManager.getMap(1), 3, 5, {facing:"retain", fading:"none"}]));
	}
	
	@AsyncTest
	public function testTeleportPlayerAsync(factory:AsyncFactory):Void
	{
		runScript('movement.teleportPlayer(1, 3, 5)');
		Assert.isTrue(HareTest.lastCalledCommand.is(screen.fadeOutScreen, [200]));
		
		var handler1 = factory.createHandler(this, function()
		{
			engine.update(0);
			Assert.isTrue(HareTest.lastCalledCommand.is(movement.teleportPlayer, [engine.mapManager.getMap(1), 3, 5, { facing:"retain", fading:"normal" } ]));
		}, 300);
		Timer.delay(handler1, 250);
		
		var handler2 = factory.createHandler(this, function()
		{
			engine.update(0);
			Assert.isTrue(HareTest.lastCalledCommand.is(screen.fadeInScreen, [200]));
		}, 300);
		Timer.delay(handler2, 500);
	}
	
	private function runScript(script:String):Void
	{
		engine.eventManager.currentEvent = 1;
		engine.eventManager.execute('co1 = coroutine.create(function() $script end)');
		engine.eventManager.execute('coroutine.resume(co1)');
		
	}
}