package rpg.text;
import rpg.text.Message.Line;
import rpg.text.Message.Sections;
import rpg.text.Message.Section;
/**
 * ...
 * @author Christopher Chiu
 */

class CmdParser
{
	private var rawText:String;
    private static var colorCodes = new ReadOnlyArray([0xFF0000, 0x00FF00, 0x0000FF]); //System Color Codes
    
	public function new(rawText:String) 
	{
		this.rawText = rawText;
	}
    
	public function parseMsg():Line
	{
		var arrSpeed = new Array<Section<SpeedAttribute>>();
		var arrfontColor = new Array<Section<Int>>();
		
		var curFromIndex = 0;
		var curToIndex = -1;
		var curSpeed = 5;
		var curColor = 0x000000;
		var fullMsg = "";
	   
		
		var arrTokens = splitTokens();
		
		for(a in arrTokens)
		{
			var speed:Section<SpeedAttribute>;
			var fontColor:Section<Int>;
			var cmdLength = a.command.length;
			var msgLength = a.message.length;
			
			curFromIndex = curToIndex + 1;
			curToIndex = curToIndex + msgLength;
			fullMsg = fullMsg + a.message;
			
			if(getTextColor(a.command) != null){
				curColor = getTextColor(a.command);
				fontColor = new Section<Int>(curColor,curFromIndex,curToIndex);
				arrfontColor.push(fontColor);
			}
				
			
			if(getTextColorByHex(a.command) != null){
				curColor = getTextColor(a.command);
				fontColor = new Section<Int>(curColor,curFromIndex,curToIndex);
				arrfontColor.push(fontColor);
			}
				
		
			if(getTextSpeed(a.command) != null){
				curSpeed = getTextSpeed(a.command);
				speed = new Section<SpeedAttribute>(SSpeed(curSpeed),curFromIndex,curToIndex);
				arrSpeed.push(speed);
			}
			

			//switch(speed.attribute){
			//    case SSpeed(speed): trace("Speed: " + speed);
			//	default:
			//}
		}

		return new Line(fullMsg,arrSpeed,arrfontColor);
		
	}
    
	public function splitTokens() : Array<Token>
	{
		var r = ~/(((\/[CcS]\[[a-fA-F0-9]+\])*)(([\w\s\.,!@?](\\n)*)+))/;
		var temp = rawText;
		var arrayTokens = new Array<Token> ();
		while(r.match(temp))
		{
			//trace("Command Part: " + r.matched(2));
			//trace("Message Part: " + r.matched(4));
			//trace("Full Token: " + r.matched(1));
			arrayTokens.push({command:r.matched(2),message:r.matched(4)});
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
			return null;
	}
	
	private function getTextColorByHex(mText:String):Int
	{
		var r = ~/\/c\[([a-fA-F0-9]+)\]/;
		if (r.match(mText))
		{
			return Std.parseInt("0x"+r.matched(1));
		}
			return null;
	}
	
	private function getTextSpeed(mText:String):Int
	{
		var r = ~/\/S\[([0-9]+)\]/;
		if (r.match(mText))
		{
			return Std.parseInt(r.matched(1));
		}
			return null;
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


