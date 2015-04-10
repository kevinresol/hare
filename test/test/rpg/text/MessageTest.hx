package rpg.text;

import massive.munit.Assert;
import rpg.text.Message;

/**
 * ...
 * @author Kevin
 */
class MessageTest
{

	public function new() 
	{
		
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
		
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
	public function testSpeed():Void
	{
		var message = new Message("/S[1]This is /S[2]some texts.");
		Assert.isTrue(message.lines.length == 1);
		
		var line = message.lines[0];
		Assert.isTrue(line.text == "This is some texts.");
		Assert.isTrue(line.speed.length == 2);
		
		var section = line.speed[0];
		Assert.isTrue(Type.enumEq(section.attribute, SSpeed(1)));
		Assert.isTrue(section.startIndex == 0);
		Assert.isTrue(section.endIndex == 7);
		
		section = line.speed[1];
		Assert.isTrue(Type.enumEq(section.attribute, SSpeed(2)));
		Assert.isTrue(section.startIndex == 8);
		Assert.isTrue(section.length == 11);
	}
	
	@Test
	public function testInstantDisplay():Void
	{
		var message = new Message("This is />some/< texts.");
		Assert.isTrue(message.lines.length == 1);
		
		var line = message.lines[0];
		Assert.isTrue(line.text == "This is some texts.");		
		Assert.isTrue(line.speed.length == 3);
		
		var section = line.speed[0];
		Assert.isTrue(Type.enumEq(section.attribute, SSpeed(5))); // default speed is 5
		Assert.isTrue(section.startIndex == 0);
		Assert.isTrue(section.length == 8);
		
		section = line.speed[1];
		Assert.isTrue(Type.enumEq(section.attribute,SInstantDisplay));
		Assert.isTrue(section.startIndex == 8);
		Assert.isTrue(section.length == 4);
		
		section = line.speed[2];
		Assert.isTrue(Type.enumEq(section.attribute, SSpeed(5)));
		Assert.isTrue(section.startIndex == 12);
		Assert.isTrue(section.endIndex == 6);
	}
	
	@Test
	public function testLine():Void
	{
		var message = new Message("/S[1]This is /S[2]some \ntexts.");
		Assert.isTrue(message.lines.length == 2);
		
		var line = message.lines[0];
		Assert.isTrue(line.text == "This is some ");
		Assert.isTrue(line.speed.length == 2);
		
		line = message.lines[1];
		Assert.isTrue(line.text == "texts.");
		Assert.isTrue(line.speed.length == 1);
	}
	
}