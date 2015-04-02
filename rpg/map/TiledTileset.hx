package rpg.map;

import haxe.xml.Fast;
import rpg.geom.Rectangle;

/**
 * Copyright (c) 2013 by Samuel Batista
 * (original by Matt Tuttle based on Thomas Jahn's. Haxe port by Adrien Fischer)
 * This content is released under the MIT License.
 */
class TiledTileset
{
	public var firstGID:Int;
	public var name:String;
	public var tileWidth:Int;
	public var tileHeight:Int;
	public var spacing:Int;
	public var margin:Int;
	public var imageSource:String;
	
	// Available only after immage has been assigned:
	public var numTiles:Int;
	public var numRows:Int;
	public var numCols:Int;
	
	public var properties:TiledPropertySet;
	
	public var tileProps:Array<TiledPropertySet>;
	
	public function new(source:Fast)
	{
		numTiles = 0xFFFFFF;
		numRows = numCols = 1;
		
		firstGID = (source.has.firstgid) ? Std.parseInt(source.att.firstgid) : 1;
		
		// check for external source
		if (source.has.source)
		{
			
		}
		// internal
		else 
		{
			var node = source.node.image;
			imageSource = node.att.source;
			
			var imgWidth = Std.parseInt(node.att.width);
			var imgHeight = Std.parseInt(node.att.height);
			
			name = source.att.name;
			
			if (source.has.tilewidth) 
			{
				tileWidth = Std.parseInt(source.att.tilewidth);
			}
			if (source.has.tileheight) 
			{
				tileHeight = Std.parseInt(source.att.tileheight);
			}
			if (source.has.spacing) 
			{
				spacing = Std.parseInt(source.att.spacing);
			}
			if (source.has.margin) 
			{
				margin = Std.parseInt(source.att.margin);
			}
			
			// read properties
			properties = new TiledPropertySet();
			for (prop in source.nodes.properties) {
				properties.extend(prop);
			}
			
			// read tiles properties
			tileProps = new Array<TiledPropertySet>();
			
			for (node in source.nodes.tile)
			{
				if (!node.has.id)
				{
					continue;
				}
				
				var id = Std.parseInt(node.att.id);
				tileProps[id] = new TiledPropertySet();
				
				for (prop in node.nodes.properties)
				{
					tileProps[id].extend(prop);
				}
			}
			
			if (tileWidth > 0 && tileHeight > 0)
			{
				numRows = cast(imgWidth / tileWidth);
				numCols = cast(imgHeight / tileHeight);
				numTiles = numRows * numCols;
			}
		}
	}
	
	public inline function hasGid(gid:Int):Bool
	{
		return (gid >= firstGID) && gid < (firstGID + numTiles);
	}
	
	public inline function fromGid(gid:Int):Int
	{
		return gid - (firstGID - 1);
	}
	
	public inline function toGid(id:Int):Int
	{
		return firstGID + id;
	}

	public function getPropertiesByGid(gid:Int):TiledPropertySet
	{
		if (tileProps != null)
		{
			return tileProps[gid - firstGID];
		}
		
		return null;
	}
	
	public inline function getProperties(id:Int):TiledPropertySet
	{
		return tileProps[id];
	}
	
	public inline function getRect(ID:Int):Rectangle
	{
		// TODO: consider spacing & margin
		return new Rectangle((ID % numCols) * tileWidth, (ID / numCols) * tileHeight);
	}
}
