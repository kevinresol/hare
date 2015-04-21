package rpg.text;
import rpg.text.Message.Line;
import rpg.text.Message.Sections;
import rpg.text.Message.Section;
import rpg.text.Message.SpeedAttribute;
/**
 * ...
 * @author Christopher Chiu
 */

class CommandParser
{
	private var rawText:String;
	private static var colorCodes = new ReadOnlyArray([0xFF0000, 0x00FF00, 0x0000FF]); //System Color Codes
	
	public function new(rawText:String) 
	{
		this.rawText = rawText;
	}
	
	public function parseMessage():Line
	{
		var arrSpeed = [];
		var arrfontColor = [];
		var curFromIndex = 0;
		var curToIndex = -1;
		var curSpeed = 5;
		var curColor = 0x000000;
		var fullMsg = "";
		
		var arrTokens = splitTokens();
		
		for(a in arrTokens)
		{
			curFromIndex = curToIndex + 1;
			curToIndex = curToIndex + a.message.length;
			fullMsg = fullMsg + a.message;
			for ( c in a.command) {
				switch (c.substr(0,2)) 
				{
					case "/S":
						curSpeed = Std.parseInt(c.substring(3, c.length - 1));
						arrSpeed.push(new Section<SpeedAttribute>(SSpeed(curSpeed), curFromIndex, curToIndex));
					case "/c":
						curColor = Std.parseInt("0x" + c.substring(3, c.length - 1));
						arrfontColor.push(new Section<Int>(curColor,curFromIndex,curToIndex));
					case "/C":
						curColor = Std.parseInt(c.substring(3, c.length - 1));
						arrfontColor.push(new Section<Int>(colorCodes[curColor],curFromIndex,curToIndex));
					case "/>":
						arrSpeed.push(new Section<SpeedAttribute>(SInstantDisplay,curFromIndex,curToIndex));
					default:	
				}
				

			}
			
			if (arrSpeed.length == 0) {
				arrSpeed.push(new Section<SpeedAttribute>(SSpeed(curSpeed), curFromIndex, curToIndex));
			}else if (arrSpeed[arrSpeed.length - 1].attribute != SInstantDisplay) {
				arrSpeed[arrSpeed.length - 1].endIndex = curToIndex;
			}else {
				arrSpeed.push(new Section<SpeedAttribute>(SSpeed(5), curToIndex + 1, a.message.length - 1 ));
			}
			
			if (arrfontColor.length == 0) {
				arrfontColor.push(new Section<Int>(0, curFromIndex, curToIndex));
			}else {
				arrfontColor[arrfontColor.length - 1].endIndex = curToIndex;
			}
			
		}
		return new Line(fullMsg,arrSpeed,arrfontColor);
	}
	
	public function splitTokens():Array<Token>
	{
		var r = ~/(((\/[\w+]\[[a-fA-F0-9]+\]|(\/>))*)(([^\/>]+)+)(\/<)*)/;
		var c = ~/\/ /;
		var temp = rawText;
		var arrayTokens = [];
		while(r.match(temp))
		{
			//trace("Command Part: " + r.matched(2));
			//trace("Message Part: " + r.matched(5));
			//trace("Full Token: " + r.matched(1));
			
			//trace(c.split(r.matched(2)));
			arrayTokens.push( { command:c.split(r.matched(2)), message:r.matched(5) } );
			temp = temp.substr(r.matchedPos().len);
		}
		
		return arrayTokens;
	}
	
	private function getTextColor(mText:String):Int
	{
		var r = ~/\/C\[([0-9]+)\]/;
		if (r.match(mText))
		{
			return colorCodes[Std.parseInt(r.matched(1))];
		}
			return -1;
	}
	
	private function getTextColorByHex(mText:String):Int
	{
		var r = ~/\/c\[([a-fA-F0-9]+)\]/;
		if (r.match(mText))
		{
			return Std.parseInt("0x"+r.matched(1));
		}
			return -1;
	}
	
	private function getTextSpeed(mText:String):Int
	{
		var r = ~/\/S\[([0-9]+)\]/;
		if (r.match(mText))
		{
			return Std.parseInt(r.matched(1));
		}
			return -1;
	}
	
	private function getTextInstantDisplay(mText:String):Bool
	{
		var r = ~/\/>/;
		if (r.match(mText))
		{
			return true;
		}
			return false;
	}
}

typedef Token =
{
	command:Array<String>,
	message:String,
}

abstract ReadOnlyArray<T>(Array<T>)
{
    public inline function new(arr) this = arr;
    @:arrayAccess public inline function get(index) return this[index];
}