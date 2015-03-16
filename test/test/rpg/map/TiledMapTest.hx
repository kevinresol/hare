package rpg.map;

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
		map = new TiledMap(Xml.parse('<?xml version="1.0" encoding="UTF-8"?>
<map version="1.0" orientation="orthogonal" renderorder="right-down" width="20" height="20" tilewidth="16" tileheight="16" nextobjectid="13">
 <tileset firstgid="1" name="Office_A4_Walls" tilewidth="16" tileheight="16">
  <image source="Z:/Dropbox/Dropbox/Projects/RPG_Pandora/Art TempAssets/Office_A4_Walls.png" width="512" height="480"/>
 </tileset>
 <layer name="Tile Layer 1" width="20" height="20">
  <data encoding="base64" compression="zlib">eJztzkcRhFAUBdGHiAGMDGCEYIRghGCEYIRghLCkRdwNVX9xqredmlmOTNACJXp0gjZoUaMSdHB/7s/9ffpvxIRZ0AUrNuyCHjhx4Rb0wc8z8xEIGuKPCLGgCV7GKdJR</data>
 </layer>
 <objectgroup name="Object Layer 1">
  <object id="1" x="42" y="40" width="79" height="75"/>
  <object id="2" x="164" y="104"/>
  <object id="3" name="123" x="28" y="164" width="110" height="106"/>
  <object id="4" name="hi" x="190" y="89" width="150" height="105"/>
  <object id="5" gid="2" x="256" y="112"/>
  <object id="6" gid="2" x="256" y="64"/>
  <object id="7" gid="2" x="208" y="48"/>
  <object id="8" type="event" gid="2" x="176" y="48">
   <properties>
    <property name="trigger" value="autorun"/>
   </properties>
  </object>
  <object id="9" gid="38" x="144" y="80"/>
  <object id="10" gid="38" x="128" y="80"/>
  <object id="11" gid="5" x="128" y="48"/>
  <object id="12" gid="5" x="128" y="64"/>
 </objectgroup>
</map>'));
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
		Assert.isTrue(map.layers.length == 1);
		
		var layer = map.layers[0];
		Assert.isTrue(layer.tileArray[0] == 85);
		Assert.isTrue(layer.tileArray[1] == 87);
		Assert.isTrue(layer.tileArray[2] == 86);
		Assert.isTrue(layer.tileArray[3] == 87);
	}
	
	@Test
	public function testTileObject():Void
	{
		Assert.isTrue(map.objectGroups.length == 1);
		
		var objects = map.objectGroups[0];
		Assert.isTrue(objects.objects[0].x == 42);
		Assert.isTrue(objects.objects[0].y == 40);
		Assert.isTrue(objects.objects[0].width == 79);
		Assert.isTrue(objects.objects[0].height == 75);
	}
	
}