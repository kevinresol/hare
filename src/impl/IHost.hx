package impl ;

/**
 * @author Kevin
 */

interface IHost 
{
	function showText(callback:Void->Void, message:String):Void;
	function log(message:String):Void;
}