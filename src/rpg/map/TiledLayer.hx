package rpg.map;


import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.xml.Fast;
import haxe.zip.Uncompress;

/**
 * Copyright (c) 2013 by Samuel Batista
 * (original by Matt Tuttle based on Thomas Jahn's. Haxe port by Adrien Fischer)
 * This content is released under the MIT License.
 */
class TiledLayer
{
	public var map:TiledMap;
	public var name:String;
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	public var opacity:Float;
	public var visible:Bool;
	public var properties:TiledPropertySet;

	public var tiles:Array<TiledTile>;

	public var tileArray(get, null):Array<Int>;

	private var _xmlData:Fast;

	public function new(Source:Fast, Parent:TiledMap)
	{
		properties = new TiledPropertySet();
		map = Parent;
		name = Source.att.name;
		x = (Source.has.x) ? Std.parseInt(Source.att.x) : 0;
		y = (Source.has.y) ? Std.parseInt(Source.att.y) : 0;
		width = Std.parseInt(Source.att.width);
		height = Std.parseInt(Source.att.height);
		visible = (Source.has.visible && Source.att.visible == "0") ? false : true;
		opacity = (Source.has.opacity) ? Std.parseFloat(Source.att.opacity) : 1.0;
		tiles = [];

		// load properties
		var node:Fast;

		for (node in Source.nodes.properties)
		{
			properties.extend(node);
		}

		// load tile GIDs
		_xmlData = Source.node.data;

		if (_xmlData == null)
		{
			throw "Error loading TiledLayer level data";
		}
		
	}

	public inline function getEncoding():String
	{
		return _xmlData.att.encoding;
	}

	private function getByteArrayData():Bytes
	{
		if (getEncoding() == "base64")
		{
			var chunk = _xmlData.innerData;
			var compressed = false;
			
			var bytes = Base64.decode(StringTools.trim(chunk));
			
			if (_xmlData.has.compression)
			{
				switch(_xmlData.att.compression)
				{
					case "zlib":
						compressed = true;
					default:
						throw "TiledLayer - data compression type not supported!";
				}
			}

			if (compressed)
				bytes = Uncompress.run(bytes);
				
			return bytes;
		}
		else
		{
			throw "Must use base64 encoding in order to get tileArray data.";
		}
		
		return null;
		
	}

	

	private function resolveTile(GlobalTileID:Int):Int
	{
		var tile:TiledTile = new TiledTile(GlobalTileID);

		var tilesetID:Int = tile.tilesetID;
		for (tileset in map.tilesets)
		{
			if (tileset.hasGid(tilesetID))
			{
				tiles.push(tile);
				// return tileset.fromGid(tilesetID);
				return tilesetID;
			}
		}
		tiles.push(null);
		return 0;
	}

	/**
	 * Function that tries to resolve the tiles gid in the csv data.
	 * TODO: It fails because I can't find a function to parse an unsigned int from a string :(
	 * @param	csvData		The csv string to resolve
	 * @return	The csv string resolved
	 */
	private function resolveCsvTiles(csvData:String):String
	{
		var buffer:StringBuf = new StringBuf();
		var rows:Array<String> = csvData.split("\n");
		var values:Array<String>;
		for(row in rows) {
			values = row.split(",");
			var i:Int;
			for (v in values) {
				if (v == "") {
					continue;
				}
				i = Std.parseInt(v);
				buffer.add(resolveTile(i) + ",");
			}
			buffer.add("\n");
		}

		var result:String = buffer.toString();
		buffer = null;
		return result;
	}

	public var csvData(get, null):String;

	private function get_csvData():String
	{
		if (csvData == null)
		{
			if (_xmlData.att.encoding == "csv")
			{
				csvData = StringTools.ltrim(_xmlData.innerData);
			}
			else
			{
				throw "Must use CSV encoding in order to get CSV data.";
			}
		}
		return csvData;
	}

	private function get_tileArray():Array<Int>
	{
		if (tileArray == null)
		{
			var mapData = getByteArrayData();

			if (mapData == null)
			{
				throw "Must use Base64 encoding (with or without zlip compression) in order to get 1D Array.";
			}

			tileArray = [];
			
			var position = 0;
			while (position < mapData.length)
			{
				tileArray.push(resolveTile(mapData.getInt32(position) - 1)); // tmx use 1-based indices
				position += 4; // 32 bit == 4 bytes
			}
		}
		
		return tileArray;
	}
}
