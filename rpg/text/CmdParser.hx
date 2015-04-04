package rpg.text;

/**
 * ...
 * @author Christopher Chiu
 */
class CmdParser
{
	private var rawText:String;
	
    private static var colorCodes = [0xFF0000, 0x00FF00, 0x0000FF];
	
	public function new(rawText:String) 
	{
		this.rawText = rawText;
	}
	
	public function getTextColor():Int
	{
		
		var r = ~/\\C\[([0-9]+)\]/;
		if (r.match(rawText))
		{
            return colorCodes[Std.parseInt(r.matched(1))-1];
		}
            return 0;
	}
	
	public function getTextColorByHex():Int
	{
		var r = ~/\\c\[([a-fA-F0-9]+)\]/;
		if (r.match(rawText))
		{
			return Std.parseInt("0x"+r.matched(1));
		}
            return 0;
	}
	
	public function getTextSpeed():Int
	{
		var r = ~/\\S\[([0-9]+)\]/;
		if (r.match(rawText))
		{
			return Std.parseInt(r.matched(1));
		}
            return 0;
	}
	
	public function getText():String
	{
		var r = ~/\\[cCS]\[([a-fA-F0-9]+)\](.+)/;
		if (r.match(rawText))
		{
			return r.matched(2);
		}
			return "";
	}
	
}


