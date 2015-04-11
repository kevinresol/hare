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
			
			if(getTextColor(a.command) != -1){
				curColor = getTextColor(a.command);
				arrfontColor.push(new Section<Int>(curColor,curFromIndex,curToIndex));
			}
				
			if(getTextColorByHex(a.command) != -1){
				curColor = getTextColor(a.command);
				arrfontColor.push(new Section<Int>(curColor,curFromIndex,curToIndex));
			}
			
			//set default color value to 0, if color command not found.
			if (getTextColor(a.command) == -1 && getTextColorByHex(a.command) == -1)
			{
				arrfontColor.push(new Section<Int>(0,curFromIndex,curToIndex));
			}
				
			if(getTextSpeed(a.command) != -1){
				curSpeed = getTextSpeed(a.command);
				arrSpeed.push(new Section<SpeedAttribute>(SSpeed(curSpeed), curFromIndex, curToIndex));
			}
			
			if(getTextInstantDisplay(a.command) == true){
                arrSpeed.push(new Section<SpeedAttribute>(SInstantDisplay,curFromIndex,curToIndex));
            }
			
			//set default speed value to 5, if speed command not found.
			if (getTextSpeed(a.command) == -1 && getTextInstantDisplay(a.command) == false) {
				arrSpeed.push(new Section<SpeedAttribute>(SSpeed(5),curFromIndex,curToIndex));
			}
		}
		return new Line(fullMsg,arrSpeed,arrfontColor);
	}
	
	public function splitTokens():Array<Token>
	{
		var r = ~/(((\/[CcS]\[[a-fA-F0-9]+\]|(\/>))*)(([^\/>]+)+)(\/<)*)/;
		var temp = rawText;
		var arrayTokens = [];
		while(r.match(temp))
		{
			//trace("Command Part: " + r.matched(2));
			//trace("Message Part: " + r.matched(5));
			//trace("Full Token: " + r.matched(1));
			arrayTokens.push({command:r.matched(2),message:r.matched(5)});
			temp = temp.substr(r.matchedPos().len);
		}
		return arrayTokens;
	}
	
	private function getTextColor(mText:String):Int
	{
		var r = ~/\/C\[([0-9]+)\]/;
		if (r.match(mText))
		{
			return colorCodes[Std.parseInt(r.matched(1))-1];
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
	command:String,
	message:String,
}

abstract ReadOnlyArray<T>(Array<T>)
{
    public inline function new(arr) this = arr;
    @:arrayAccess public inline function get(index) return this[index];
}