package rpg.text;
import rpg.text.Message.Sections;

/**
 * ...
 * @author Kevin
 */
class Message
{
	public var lines:Array<Line>;
	
	public function new(rawText:String):Void
	{
		lines = [];
		var rawLines = rawText.split("\n");
		for(line in rawLines)
		{
			lines.push(new CommandParser(line).parseMessage());
		}
		//trace(lines.length);

		// TODO: parse rawText and fill the "lines" array
		// (start a new line whenever there is a "\n")
	}
}
 
class Line
{
	public var text:String;
	
	public var speed:Sections<SpeedAttribute>;
	
	public var fontColor:Sections<Int>;
	public var fontSize:Sections<Int>; //TODO
	public var fontName:Sections<String>; //TODO
	public var bold:Sections<Bool>; //TODO
	public var italic:Sections<Bool>; //TODO
	public var borderColor:Sections<Int>; //TODO
	
	public function new(text:String,speed:Sections<SpeedAttribute>,fontColor:Sections<Int>) 
	{
		this.text = text;
        //trace("Full Text: "+text);
        //trace("No. of speed: "+speed.length);
	}
}

typedef Sections<T> = Array<Section<T>>;
class Section<T>
{
	public var attribute:T;
	public var startIndex:Int;
	public var endIndex:Int;
	public var length(get, never):Int;
	
	public function new(attribute, startIndex, endIndex)
	{
		this.attribute = attribute;
		this.startIndex = startIndex;
		this.endIndex = endIndex;
	}
	
	private inline function get_length():Int
	{
		return endIndex - startIndex + 1;
	}
}

enum SpeedAttribute
{
	SSpeed(speed:Int);	
	SInstantDisplay;
}