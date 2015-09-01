package hare.map;

import hare.map.TiledMap;
import massive.munit.Assert;
/**
 * ...
 * @author Kevin
 */
class TiledMapTest
{
	private var map:TiledMap;

	public function new() 
	{
		
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
		map = new TiledMap(Xml.parse(Macro.getTestMapData()));
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
	public function testTileLayer():Void
	{
		Assert.isTrue(map.layers.length == 4);
		Assert.isTrue(map.getLayer("Passage") != null);
		Assert.isTrue(map.getLayer("Above") != null);
		Assert.isTrue(map.getLayer("Below") != null);
		Assert.isTrue(map.getLayer("Walls and Floor") != null);
		
		
		var layer = map.layers[0];
		/*Assert.isTrue(layer.tileArray[0] == 85);
		Assert.isTrue(layer.tileArray[1] == 87);
		Assert.isTrue(layer.tileArray[2] == 86);
		Assert.isTrue(layer.tileArray[3] == 87);*/
	}
	
	@Test
	public function testTileObject():Void
	{
		Assert.isTrue(map.objectGroups.length == 1);
		Assert.isTrue(map.getObjectGroup("Objects") != null);
		
		var objects = map.objectGroups[0];
		/*Assert.isTrue(objects.objects[0].x == 42);
		Assert.isTrue(objects.objects[0].y == 40);
		Assert.isTrue(objects.objects[0].width == 79);
		Assert.isTrue(objects.objects[0].height == 75);*/
	}
	
}