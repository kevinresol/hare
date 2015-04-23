package rpg.config;

import rpg.config.ConfigMacro;
import rpg.Engine;
using Lambda;
/**
 * @author Kevin
 */

class Config
{
	public var items(get, null):Array<ItemData>;
	public var characters(get, null):Array<CharacterData>;
	private var data:ConfigData;
	private var engine:Engine;
	
	public function new(data, engine)
	{
		this.data = data;
		this.engine = engine;
		
		ConfigMacro.checkConfig(data, "rpg.config.Config.ConfigData");
	}
	
	public function getCharacterImage(name:String):{source:String, index:Int}
	{
		var character = data.characters.find(function(o) return o.name == name);
		if (character == null)
			engine.log('Character $name not defined in config.json', LError);
		return character.image;
	}
	
	private inline function get_items():Array<ItemData>
	{
		return data.items;
	}
	
	private inline function get_characters():Array<CharacterData>
	{
		return data.characters;
	}
}

typedef ConfigData =
{
	characters:Array<CharacterData>,
	items:Array<ItemData>,
}

typedef CharacterData = 
{
	name:String,
	?image:ImageData,
}

typedef ImageData = 
{
	source:String, 
	?index:Int,
}

typedef ItemData =
{
	id:Int,
	name:String,
	?quantity:Int,
}