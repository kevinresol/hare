package rpg.event;
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
/**
 * ...
 * @author Kevin
 */
class EventMacro
{
	macro public static function getBridgeScript():Expr
	{
		var s = new StringBuf();
		var p = Context.resolvePath("assets/engine/script/");
		p = Path.normalize(p);
		
		for (f in FileSystem.readDirectory(p))
		{
			s.add(" ");
			s.add(File.getContent(p + "/" + f));
		}
		
		s.add(" return true");
		
		return macro $v{s.toString()};
	}
}