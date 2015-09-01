package hare.map;

import haxe.xml.Fast;

/**
 * Copyright (c) 2013 by Samuel Batista
 * (original by Matt Tuttle based on Thomas Jahn's. Haxe port by Adrien Fischer)
 * This content is released under the MIT License.
 */
class TiledMap
{
	public var version:String; 
	public var orientation:String;
	
	public var width:Int;
	public var height:Int; 
	public var tileWidth:Int; 
	public var tileHeight:Int;
	
	public var fullWidth:Int;
	public var fullHeight:Int;
	
	public var properties:TiledPropertySet;
	
	public var tilesets:Array<TiledTileset>;
	public var layers:Array<TiledLayer>;
	public var objectGroups:Array<TiledObjectGroup>;
	
	public function new(Data:Xml)
	{
		properties = new TiledPropertySet();
		var source = new Fast(Data).node.map;
		
		// map header
		version = source.att.version;
		
		if (version == null) 
		{
			version = "unknown";
		}
		
		orientation = source.att.orientation;
		
		if (orientation == null) 
		{
			orientation = "orthogonal";
		}
		
		width = Std.parseInt(source.att.width);
		height = Std.parseInt(source.att.height);
		tileWidth = Std.parseInt(source.att.tilewidth);
		tileHeight = Std.parseInt(source.att.tileheight);
		
		// Calculate the entire size
		fullWidth = width * tileWidth;
		fullHeight = height * tileHeight;
		
		tilesets = [];
		layers = [];
		objectGroups = [];
		
		// read properties
		for (node in source.nodes.properties)
		{
			properties.extend(node);
		}
		
		// load tilesets
		for (node in source.nodes.tileset)
		{
			tilesets.push(new TiledTileset(node));
		}
		
		// load layer
		for (node in source.nodes.layer)
		{
			layers.push(new TiledLayer(node, this));
		}
		
		// load object group
		for (node in source.nodes.objectgroup)
		{
			objectGroups.push(new TiledObjectGroup(node, this));
		}
	}
	
	public function getTileSet(name:String):TiledTileset
	{
		for (tileset in tilesets)
			if (tileset.name == name) return tileset;
			
		return null;
	}
	
	public function getLayer(name:String):TiledLayer
	{
		for (layer in layers)
		{
			if (layer.name == name)
				return layer;
		}
		
		return null;
	}
	
	public function getLayerByProperty(name:String, value:String):TiledLayer
	{
		for (layer in layers)
		{
			if (layer.properties.get(name) == value)
				return layer;
		}
		
		return null;
	}
	
	public function getObjectGroup(name:String):TiledObjectGroup
	{
		var i = objectGroups.length;
		
		while (i > 0)
		{
			if (objectGroups[--i].name == name)
			{
				return objectGroups[i];
			}
		}
		
		return null;
	}
	
	// works only after TiledTileSet has been initialized with an image...
	public function getGidOwner(gid:Int):TiledTileset
	{
		for (set in tilesets)
		{
			if (set.hasGid(gid))
			{
				return set;
			}
		}
		
		return null;
	}
}