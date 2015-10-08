package hare.impl;

/**
 * ...
 * @author Kevin
 */
class Assets extends Module
{

	public function new() 
	{
		super();
	}
	
	public function getConfig():String
	{
		throw "";
	}
	
	public function getSaveData():String
	{
		throw "";
	}

	public function setSaveData(data:String):Void
	{
		
	}
	
	public function getMapData(id:Int):String
	{
		throw "";
	}
	
	public function getEventData(mapId:Int):String
	{
		throw "";
	}

	public function getScript(mapId:Int, eventId:Int, page:Int):String
	{
		throw "";
	}
	
	public function getImageDimension(source:String):{width:Int, height:Int}
	{
		throw "";
	}
}