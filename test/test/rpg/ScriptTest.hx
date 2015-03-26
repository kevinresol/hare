package rpg;
import massive.munit.Assert;

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
		engine = new Engine(impl);
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
	
}