package rpg.config;

import rpg.config.ConfigMacro;
import rpg.Engine;
using Lambda;
/**
 * @author Kevin
 */

@:build(rpg.config.ConfigMacro.build())
class Config
{
	private var data:ConfigData;
	private var engine:Engine;
	
	public function new(data, engine)
	{
		this.data = data;
		this.engine = engine;
		
		// macro-generated checkings of the config file
		#if debug
		var warningCallback = engine.log.bind(_, LInfo);
		var errorCallback = engine.log.bind(_, LError);
		ConfigMacro.checkConfig(data, "rpg.config.Config.ConfigData", warningCallback, errorCallback);
		#end
	}
	
	public function getCharacterImage(name:String):{source:String, index:Int}
	{
		var character = data.characters.find(function(o) return o.name == name);
		if (character == null)
			engine.log('Character $name not defined in config.json', LError);
		return character.image;
	}
}

typedef ConfigData =
{
	?mainMenu:MainMenuData,
	characters:Array<CharacterData>,
	items:Array<ItemData>,
}

typedef MainMenuData = 
{
	?music:String,
	?image:String,
}

typedef CharacterData = 
{
	name:String,
	?image:ImageData,
}

typedef ImageData = 
{
	source:String, 
	index:Int,
}

typedef ItemData =
{
	id:Int,
	name:String,
	?quantity:Int,
}