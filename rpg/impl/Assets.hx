package rpg.impl;

/**
 * ...
 * @author Kevin
 */
class Assets extends Module
{

	public function new(impl) 
	{
		super(impl);
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

	public function getScript(mapId:Int, eventId:Int):String
	{
		throw "";
	}
	
	public function getImageDimension(source:String):{width:Int, height:Int}
	{
		throw "";
	}
}