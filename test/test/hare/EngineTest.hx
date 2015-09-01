package hare;

import massive.munit.Assert;
import massive.munit.util.Timer;
import hare.Engine;

class EngineTest 
{
	private var engine:Engine;
	
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
	}
	
	@AfterClass
	public function afterClass():Void
	{
	}
	
	@Before
	public function setup():Void
	{
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	@Test
	public function testTeleportPlayer():Void
	{
		engine.eventManager.scriptHost.teleportPlayer(1, 12, 13, {facing:"right"});
		Assert.isTrue(engine.interactionManager.player.map.id == 1);
		Assert.isTrue(engine.interactionManager.player.position.x == 12);
		Assert.isTrue(engine.interactionManager.player.position.y == 13);
	}
	
	/*@AsyncTest
	public function testAsyncExample(factory:AsyncFactory):Void
	{
		var handler:Dynamic = factory.createHandler(this, onTestAsyncExampleComplete, 300);
		timer = Timer.delay(handler, 200);
	}
	
	private function onTestAsyncExampleComplete():Void
	{
		Assert.isFalse(false);
	}*/
	
	
	/**
	* test that only runs when compiled with the -D testDebug flag
	*/
	@TestDebug
	public function testExampleThatOnlyRunsWithDebugFlag():Void
	{
		Assert.isTrue(true);
	}

}