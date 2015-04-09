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
	
	public function getActorImage(name:String):{source:String, index:Int}
	{
		var actor = data.actors.find(function(o) return o.name == name);
		if (actor == null)
			throw "Actor $name not defined in config.json";
		return actor.image;
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