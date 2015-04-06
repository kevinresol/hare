package rpg.config;

using Lambda;
/**
 * @author Kevin
 */

class Config
{
	public var items(get, null):Array<ItemData>;
	private var data:ConfigData;
	
	public function new(data)
	{
		this.data = data;
	}
	
	public function getImageSourceOfActor(name:String):String
	{
		var actor = data.actors.find(function(o) return o.name == name);
		return actor == null ? "" : actor.image.source;
	}
	
	private inline function get_items():Array<ItemData>
	{
		return data.items;
	}
}

typedef ConfigData =
{
	actors:Array<ActorData>,
	items:Array<ItemData>,
}

typedef ActorData = 
{
	name:String,
	image:{source:String, index:Int},
}

typedef ItemData =
{
	id:Int,
	name:String,
	?quantity:Int,
}