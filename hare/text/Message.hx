package hare.text;

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
		
		
		// TODO: parse rawText and fill the "lines" array
		// (start a new line whenever there is a "\n")
	}
}
 
class Line
{
	public var text:String;
	
	public var speed:Sections<SpeedAttribute>;
	
	public var fontColor:Sections<Int>;
	public var fontSize:Sections<Int>;
	public var fontName:Sections<String>;
	public var bold:Sections<Bool>;
	public var italic:Sections<Bool>;
	public var borderColor:Sections<Int>;
	
	public function new() 
	{
		
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
		return endIndex - startIndex;
	}
}

enum SpeedAttribute
{
	SSpeed(speed:Int);	
	SInstantDisplay;
}