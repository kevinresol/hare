package rpg.config;

/**
 * @author Kevin
 */

typedef Config =
{
	actor:Array<ActorData>,
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