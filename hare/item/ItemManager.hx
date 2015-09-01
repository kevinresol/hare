package hare.item;
import hare.config.Config.ItemData;
import hare.Engine;

using Lambda;
/**
 * ...
 * @author Kevin
 */
class ItemManager
{
	public var itemData(get, never):Array<ItemData>;
	
	
	@inject
	public  var engine:Engine;
	private var items:Map<Int, Item>;

	public function new() 
	{
	}
	
	public function init(data:Array<ItemData>):Void
	{
		items = new Map();
		for (d in data)
		{
			var quantity = d.quantity == null ? 0 : d.quantity;
			items[d.id] = new Item(d.id, d.name, quantity);
		}
	}
	
	public function changeItem(id:Int, quantity:Int):Void
	{
		var item = items[id];
		if (item == null) engine.log("no such item of id:$id", LError);
		item.quantity += quantity;
	}
	
	public function getItem(id:Int):Int
	{
		var item = items[id];
		if (item == null) engine.log("no such item of id:$id", LError);
		return item.quantity;
		
	}
	
	private function get_itemData():Array<ItemData>
	{
		var result = [];
		for (item in items)
		{
			result.push({id:item.id, name:item.name, quantity:item.quantity});
		}
		return result;
	}
	
}

