package rpg.config;
#if macro
import haxe.macro.Expr;
#else
import rpg.Engine;
using Lambda;
/**
 * @author Kevin
 */

class Config
{
	public var items(get, null):Array<ItemData>;
	private var data:ConfigData;
	private var engine:Engine;
	
	public function new(data, engine)
	{
		this.data = data;
		this.engine = engine;
		
		// data check
		for (actor in data.actors)
		{
			ConfigMacro.checkField("actor", "name");
			ConfigMacro.checkField("actor", "image");
			var image = actor.image;
			ConfigMacro.checkField("image", "source");
			
			if (actor.image.index == null)
				actor.image.index = 0;
		}
		
		for (item in data.items)
		{
			ConfigMacro.checkField("item", "id");
			ConfigMacro.checkField("item", "name");
		}
	}
	
	public function getActorImage(name:String):{source:String, index:Int}
	{
		var actor = data.actors.find(function(o) return o.name == name);
		if (actor == null)
			engine.log("Actor $name not defined in config.json", LError);
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
	image:{source:String, ?index:Int},
}

typedef ItemData =
{
	id:Int,
	name:String,
	?quantity:Int,
}

#end
private class ConfigMacro
{
	macro public static function checkField(object:String, field:String):Expr
	{
	return macro if ($i { object } .$field == null) engine.log('field "$field" missing in $object: ' + $i { object }, LError);
	}
}