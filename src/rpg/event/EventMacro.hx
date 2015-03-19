package rpg.event;
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.io.File;

/**
 * ...
 * @author Kevin
 */
class EventMacro
{
	macro public static function getBridgeScript():Expr
	{
		var p = Context.resolvePath("../assets/script/bridge.lua");
		p = Path.normalize(p);
		var s = File.getContent(p);
		return macro $v{s};
	}
}