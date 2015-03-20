package rpg;

import massive.munit.Assert;
import massive.munit.util.Timer;
import rpg.Engine;

class EngineTest 
{
	private var engine:Engine;
	
	public function new() 
	{
		
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
		var impl = new TestImplementation();
		engine = new Engine(impl, "template");
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
		engine.eventManager.scriptHost.teleportPlayer("template", 12, 13);
		Assert.isTrue(engine.interactionManager.playerPosition.x == 12);
		Assert.isTrue(engine.interactionManager.playerPosition.y == 13);
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