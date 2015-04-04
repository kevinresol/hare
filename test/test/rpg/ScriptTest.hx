package rpg;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

/**
 * ...
 * @author Kevin
 */
@:access(rpg)
class ScriptTest
{
	private var impl:TestImplementation;
	private var engine:Engine;
	
	public function new() 
	{
		
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
		impl = new TestImplementation();
		engine = new Engine(impl, impl.assetManager);
		engine.startGame();
	}
	
	@Before
	public function before():Void
	{
		impl.lastCalledCommand.clear();
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
		engine.eventManager.execute('message.showText("test1", "default options")');
		Assert.isTrue(impl.lastCalledCommand.is(impl.showText, ["test1", "default options", {background:"normal", position:"bottom"}]));
		
		engine.eventManager.execute('message.showText("test2","provided options", {background="dimmed", position="top"})');
		Assert.isTrue(impl.lastCalledCommand.is(impl.showText, ["test2", "provided options", {background:"dimmed", position:"top"}]));
		
		engine.eventManager.execute('message.showChoices("select",{{text="c1"},{text="c2"}})');
		Assert.isTrue(impl.lastCalledCommand.is(impl.showChoices, ["select", [{text:"c1", disabled:false, hidden:false}, {text:"c2", disabled:false, hidden:false}], {background:"normal", position:"bottom"}]));
		
		engine.eventManager.execute('message.showChoices("select",{{text="c1", disabled=true},{text="c2", hidden=true}}, {background="dimmed", position="center"})');
		Assert.isTrue(impl.lastCalledCommand.is(impl.showChoices, ["select", [{text:"c1", disabled:true, hidden:false}, {text:"c2", disabled:false, hidden:true}], {background:"dimmed", position:"center"}]));
		
	}
	
	@Test
	public function testSound():Void
	{
		engine.eventManager.execute('sound.play(1,2,3)');
		Assert.isTrue(impl.lastCalledCommand.is(impl.playSound, [1, 2, 3]));
	}
	
	@Test
	public function testMusic():Void
	{
		engine.eventManager.execute('music.play(1,2,3)');
		Assert.isTrue(impl.lastCalledCommand.is(impl.playBackgroundMusic, [1, 2, 3]));
		
		engine.eventManager.execute('music.pause()');
		Assert.isTrue(impl.lastCalledCommand.is(impl.saveBackgroundMusic, []));
		
		engine.eventManager.execute('music.resume()');
		Assert.isTrue(impl.lastCalledCommand.is(impl.restoreBackgroundMusic, []));
		
		engine.eventManager.execute('music.fadeOut(25, {wait=false})');
		Assert.isTrue(impl.lastCalledCommand.is(impl.fadeOutBackgroundMusic, [25]));
		
		engine.eventManager.execute('music.fadeIn(20, {wait=false})');
		Assert.isTrue(impl.lastCalledCommand.is(impl.fadeInBackgroundMusic, [20]));
	}
	
	@Test
	public function testScreen():Void
	{
		engine.eventManager.execute('screen.fadeIn(21)');
		Assert.isTrue(impl.lastCalledCommand.is(impl.fadeInScreen, [21]));
		
		engine.eventManager.execute('screen.fadeOut(27)');
		Assert.isTrue(impl.lastCalledCommand.is(impl.fadeOutScreen, [27]));
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
		Assert.isTrue(impl.lastCalledCommand.is(impl.teleportPlayer, [engine.mapManager.getMap(1), 3, 5, {facing:"right", fading:"none"}]));
		
		runScript('movement.teleportPlayer(1, 3, 5, {fading="none"})');
		Assert.isTrue(impl.lastCalledCommand.is(impl.teleportPlayer, [engine.mapManager.getMap(1), 3, 5, {facing:"retain", fading:"none"}]));
	}
	
	@AsyncTest
	public function testTeleportPlayerAsync(factory:AsyncFactory):Void
	{
		runScript('movement.teleportPlayer(1, 3, 5)');
		Assert.isTrue(impl.lastCalledCommand.is(impl.fadeOutScreen, [200]));
		
		var handler1 = factory.createHandler(this, function()
		{
			engine.update(0);
			Assert.isTrue(impl.lastCalledCommand.is(impl.teleportPlayer, [engine.mapManager.getMap(1), 3, 5, { facing:"retain", fading:"normal" } ]));
		}, 300);
		Timer.delay(handler1, 250);
		
		var handler2 = factory.createHandler(this, function()
		{
			engine.update(0);
			Assert.isTrue(impl.lastCalledCommand.is(impl.fadeInScreen, [200]));
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