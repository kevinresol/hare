package hare.text;

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
    
    private function splitTokens():Array<String>
    {
        var r = ~/(((\/[CcS]\[[a-fA-F0-9]+\])*)(([\w\s!@?](\\n)*)+))/;
        var temp = rawText;
        var arrayTokens = new Array<String> ();
        while(r.match(temp))
        {
			//trace("Command Part: " + r.matched(2));
            //trace("Message Part: " + r.matched(4));
            //trace("Full Token: " + r.matched(1));
            arrayTokens.push(r.matched(1));
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
            return 0;
	}
	
	private function getTextColorByHex(mText:String):Int
	{
		var r = ~/\/c\[([a-fA-F0-9]+)\]/;
		if (r.match(mText))
		{
			return Std.parseInt("0x"+r.matched(1));
		}
            return 0;
	}
	
	private function getTextSpeed(mText:String):Int
	{
		var r = ~/\/S\[([0-9]+)\]/;
		if (r.match(mText))
		{
			return Std.parseInt(r.matched(1));
		}
            return 0;
	}
	
	private function getText(mText):String
	{
		var r = ~/(\/[cCS]\[([a-fA-F0-9]+)\])*(.+)/;
		if (r.match(mText))
		{
			return r.matched(3);
		}
			return "";
	}
	
	public function parseMessage():Array<MessageData>
	{
        var arrayTokens = new Array<String> ();
        var mMessageData = new Array<MessageData> ();
        arrayTokens=splitTokens();

        
        for(i in 0...arrayTokens.length)
        {
            var mMessage = "";
            var mColor = 0;
            var mSpeed = 0;
            //trace(arrayTokens[i]);
            if (getTextColor(arrayTokens[i]) != 0) {
        		mColor = getTextColor(arrayTokens[i]);
            	//trace(mColor);
        	}else{
                mColor = getTextColorByHex(arrayTokens[i]);
                //trace(mColor);
            }
            mSpeed = getTextSpeed(arrayTokens[i]);
            //trace(mSpeed);
            mMessage  = getText(arrayTokens[i]);
        	//trace(mMessage);
            mMessageData.push({textString:mMessage,color:mColor,speed:mSpeed});
        }
        
        return mMessageData;
	}
	
}

typedef MessageData =
{
	textString:String,
	color:Int,
	speed:Int,
}

abstract ReadOnlyArray<T>(Array<T>)
{
    public inline function new(arr) this = arr;
    @:arrayAccess public inline function get(index) return this[index];
}


