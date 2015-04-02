package rpg.map;

import haxe.xml.Fast;

/**
 * Copyright (c) 2013 by Samuel Batista
 * (original by Matt Tuttle based on Thomas Jahn's. Haxe port by Adrien Fischer)
 * This content is released under the MIT License.
 */
class TiledObjectGroup
{
	public var map:TiledMap;
	public var name:String;
	public var color:Int;
	public var opacity:Float;
	public var visible:Bool;
	public var properties:TiledPropertySet;
	public var objects:Array<TiledObject>;
	
	public function new(source:Fast, parent:TiledMap)
	{
		properties = new TiledPropertySet();
		objects = new Array<TiledObject>();
		
		map = parent;
		name = source.att.name;
		visible = (source.has.visible && source.att.visible == "1") ? true : false;
		opacity = (source.has.opacity) ? Std.parseFloat(source.att.opacity) : 0;
		if (source.has.color)
		{
			var hex = source.att.color;
			hex = "0x" + hex.substring(1, hex.length); // replace # with 0x
			color = Std.parseInt(hex);
		}
		else
			color = 0;
		
		// load properties
		var node:Fast;
		
		for (node in source.nodes.properties)
		{
			properties.extend(node);
		}
		
		// load objects
		for (node in source
		.nodes.object)
		{
			objects.push(new TiledObject(node, this));
		}
	}
}
