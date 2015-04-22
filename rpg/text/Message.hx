package rpg.text;

/**
 * ...
 * @author Kevin
 */
class Message
{
	public var lines:Array<Line>;
	
	private static var colorCodes:ReadOnlyArray<Int> = [0xFF0000, 0x00FF00, 0x0000FF]; //System Color Codes
	
	public function new(rawText:String):Void
	{
		lines = [];
		
		var splitedRawText = rawText.split("\n");
		
		// default attributes:
		var fontColor = colorCodes[0];
		var speed = SSpeed(5);
		var prevSpeed = null; // for instant display to get back to prev speed
		var bold = false;
		var italic = false;
		
		
		for (i in 0...splitedRawText.length)
		{
			var t = splitedRawText[i];
			var line = new Line();
			lines.push(line);
			
			var pos = 0; // pos of rawText
			var startIndex = pos; // pos of the text with commands removed
			
			while (pos < t.length)
			{
				// get the pos of next command
				var nextPos = t.indexOf("/", pos);
				
				// next command not found, set it to the end of line
				if (nextPos == -1)
					nextPos = t.length;
				
				// push new sections to current line
				if (pos != nextPos)
				{
					var sectionText = t.substring(pos, nextPos);
					var sectionLength = sectionText.length;
					var endIndex = startIndex + sectionLength - 1;
					
					line.text += sectionText;
					
					line.speed.push(speed, startIndex, endIndex);
					line.fontColor.push(fontColor, startIndex, endIndex);
					//TODO: line.fontSize.push(new Section(fontColor, startIndex, endIndex));
					//TODO: line.fontName.push(new Section(fontColor, startIndex, endIndex));
					line.bold.push(bold, startIndex, endIndex);
					line.italic.push(italic, startIndex, endIndex);
					//TODO: line.borderColor.push(new Section(fontColor, startIndex, endIndex));
					
					startIndex += sectionLength;
				}
				
				// reached the end of current line
				if(nextPos == t.length) break;
				
				// parse next command
				var parseParam = function():String // helper function for getting param for commands like "/C[1]"
				{
					pos = t.indexOf("]", nextPos);
					return t.substr(nextPos + 3, pos - nextPos - 3);
				}
				
				switch (t.charAt(nextPos + 1))
				{
					// "/S[n]"
					case "S":
						var param = parseParam();
						speed = SSpeed(Std.parseInt(param));
						pos++;
						
					// "/C[n]"
					case "C":
						var param = parseParam();
						fontColor = colorCodes[Std.parseInt(param)];
						pos++;
						
					// "/c[hex]"
					case "c":
						var param = parseParam();
						fontColor = Std.parseInt('0x$param');
						pos++;
						
					// "/>"
					case ">":
						prevSpeed = speed;
						speed = SInstantDisplay;
						pos = nextPos + 2;
						
					// "/<"
					case "<":
						if(speed == SInstantDisplay && prevSpeed != null) // if there is no "/>" before "/<", need to display some error?
							speed = prevSpeed;
						pos = nextPos + 2;
						
					case "f":
						switch (t.charAt(nextPos + 2)) 
						{
							
							// "/fb"
							case "b":
								bold = !bold;
								pos = nextPos + 3;
								
							// "/fi"
							case "i":
								italic = !italic;
								pos = nextPos + 3;
								
							default:
								// error
						}
						
					default:
						// error
						
				}
			}
		}
	}
}
 
class Line
{
	public var text:String = "";
	
	public var speed:Sections<SpeedAttribute>;
	public var fontColor:Sections<Int>;
	public var fontSize:Sections<Int>; //TODO
	public var fontName:Sections<String>; //TODO
	public var bold:Sections<Bool>; //TODO
	public var italic:Sections<Bool>; //TODO
	public var borderColor:Sections<Int>; //TODO
	
	public function new() 
	{
		speed       = [];
		fontColor   = [];
		fontSize    = [];
		fontName    = [];
		bold        = [];
		italic      = [];
		borderColor = [];
	}
	
	public function toString():String
	{
		return '\ntext:$text\nfontColor:$fontColor\nspeed:$speed\nbold:$bold\nitalic:$italic';
	}
	
	@:allow(rpg.text.Message)
	private function mergeSections():Void
	{
		
	}
}

@:forward(length)
abstract Sections<T>(Array<Section<T>>) from Array<Section<T>>
{
	// override the push function, merge the to-be-pushed section with the prev section if the attribute are the same
	public function push(attr:T, startIndex:Int, endIndex:Int)
	{
		if (this.length > 0)
		{
			var prevSection = this[this.length - 1];
			if (attributeEquals(prevSection.attribute, attr))
			{
				prevSection.endIndex = endIndex;
				return this.length;
			}
		}
		return this.push(new Section(attr, startIndex, endIndex));
	}
	
	@:arrayAccess
	public inline function get(i:Int) return this[i];
	
	// compare the attributes
	private function attributeEquals(attr1:T, attr2:T):Bool
	{
		if (Reflect.isEnumValue(attr1))
			return Type.enumEq(attr1, attr2);
		else
			return attr1 == attr2;
	}
}

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
	
	public function toString():String
	{
		return 'Section($attribute, $startIndex, $endIndex)';
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

abstract ReadOnlyArray<T>(Array<T>) from Array<T>
{
    public inline function new(arr) this = arr;
    @:arrayAccess public inline function get(index) return this[index];
}