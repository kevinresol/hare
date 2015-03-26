package ;
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.io.File;

/**
 * ...
 * @author Kevin
 */
class Macro
{
	macro public static function getAssetPath():Expr
	{
		var p = Context.resolvePath("assets/");
		return macro $v{Path.normalize(p)};
	}
	
	macro public static function getTestMapData():Expr 
	{
		var p = Context.resolvePath("../assets/map/0001-template.tmx");
		p = Path.normalize(p);
		var s = File.getContent(p);
		return macro $v{s};
	}
	
	macro public static function getCurrentFunction():Expr
	{
		return macro $i{Context.getLocalMethod()};
	}
}