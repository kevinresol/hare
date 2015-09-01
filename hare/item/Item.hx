package hare.item;

/**
 * ...
 * @author Kevin
 */
class Item
{
	public var id:Int;
	public var name:String;
	public var quantity:Int;

	public function new(id, name, quantity) 
	{
		this.id = id;
		this.name = name;
		this.quantity = quantity;
	}
	
}