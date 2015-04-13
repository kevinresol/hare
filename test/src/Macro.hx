package ;
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr;
#if sys
import sys.io.File;
#end
/**
 * ...
 * @author Kevin
 */
class Macro
{
	macro public static function getTestMapData():Expr 
	{
		var file = Context.resolvePath("assets/map/0001-template.tmx");
		var s = File.getContent(file);
		return macro $v{s};
	}
	
	macro public static function getTestConfig():Expr
	{
		var file = Context.resolvePath("assets/config.json");
		var s = File.getContent(file);
		return macro $v{s};
	}
	
	macro public static function getCurrentFunction():Expr
	{
		return macro $i{Context.getLocalMethod()};
	}
}