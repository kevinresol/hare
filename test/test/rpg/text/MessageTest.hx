package rpg.text;

import massive.munit.Assert;
import rpg.text.Message;
import rpg.text.CommandParser;

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
	@:access(rpg.text.CommandParser)
	public function testColor():Void
	{
		var message = new Message("/C[1]This is /C[2]some texts.");
		Assert.isTrue(message.lines.length == 1);
		
		var line = message.lines[0];
		Assert.isTrue(line.text == "This is some texts.");
		Assert.isTrue(line.fontColor.length == 2);
		
		var section = line.fontColor[0];
		Assert.isTrue(section.attribute == CommandParser.colorCodes[1]);
		Assert.isTrue(section.startIndex == 0);
		Assert.isTrue(section.endIndex == 7);
		
		section = line.fontColor[1];
		Assert.isTrue(section.attribute == CommandParser.colorCodes[2]);
		Assert.isTrue(section.startIndex == 8);
		Assert.isTrue(section.length == 11);
	}
	
	@Test
	public function testColorHex():Void
	{
		var message = new Message("/c[abcedf]This is /c[123456]some texts.");
		Assert.isTrue(message.lines.length == 1);
		
		var line = message.lines[0];
		Assert.isTrue(line.text == "This is some texts.");
		Assert.isTrue(line.fontColor.length == 2);
		
		var section = line.fontColor[0];
		Assert.isTrue(section.attribute == 0xabcdef);
		Assert.isTrue(section.startIndex == 0);
		Assert.isTrue(section.endIndex == 7);
		
		section = line.fontColor[1];
		Assert.isTrue(section.attribute == 0x123456);
		Assert.isTrue(section.startIndex == 8);
		Assert.isTrue(section.length == 11);
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
		
		var section = line.speed[1];
		Assert.isTrue(Type.enumEq(section.attribute, SInstantDisplay));
		Assert.isTrue(section.startIndex == 8);
		Assert.isTrue(section.length == 4);
		
		section = line.speed[2];
		Assert.isTrue(Type.enumEq(section.attribute, SSpeed(5)));
		Assert.isTrue(section.startIndex == 12);
		Assert.isTrue(section.length == 7);
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
	
	
	
	@Test
	@:access(rpg.text.CommandParser)
	public function testMixedCommands():Void
	{
		var message = new Message("/C[1]This /S[1]is /C[2]some texts.");
		Assert.isTrue(message.lines.length == 1);
		
		var line = message.lines[0];
		Assert.isTrue(line.text == "This is some texts.");
		Assert.isTrue(line.fontColor.length == 2);
		Assert.isTrue(line.speed.length == 2);
		
		var section = line.fontColor[0];
		Assert.isTrue(section.attribute == CommandParser.colorCodes[1]);
		Assert.isTrue(section.startIndex == 0);
		Assert.isTrue(section.endIndex == 7);
		
		section = line.fontColor[1];
		Assert.isTrue(section.attribute == CommandParser.colorCodes[2]);
		Assert.isTrue(section.startIndex == 8);
		Assert.isTrue(section.length == 11);
		
		var section = line.speed[0];
		Assert.isTrue(Type.enumEq(section.attribute, SSpeed(5)));
		Assert.isTrue(section.startIndex == 0);
		Assert.isTrue(section.endIndex == 4);
		
		section = line.speed[1];
		Assert.isTrue(Type.enumEq(section.attribute, SSpeed(1)));
		Assert.isTrue(section.startIndex == 5);
		Assert.isTrue(section.length == 14);
	}
	
}