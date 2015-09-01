package hare.config;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Type.ClassField;

using Lambda;
using haxe.macro.ComplexTypeTools;
using haxe.macro.ExprTools;
using haxe.macro.TypeTools;

/**
 * ...
 * @author Kevin
 */
class ConfigMacro
{
	private static var warningCallback:Expr;
	private static var errorCallback:Expr;
	
	macro public static function build():Array<Field>
	{
		var fields = Context.getBuildFields();
		var pos = Context.currentPos();
		
		// get the type of ConfigData
		var complexType = switch (fields.find(function(f) return f.name == "data").kind) 
		{
			case FVar(t, e): t;
			default: null;
		}
		
		var type = complexType.toType();
		var dataFields = getFields(type);
		
		// for each field in ConfigData
		for (field in dataFields)
		{
			var fieldName = field.name;
			
			// push a read-only field in Config
			fields.push({
				name:fieldName, 
				access:[APublic], 
				kind:FProp("get", "never", field.type.toComplexType(), null),
				pos:pos
			});
			
			// push the corresponding getter in Config
			fields.push({
				name:'get_$fieldName', 
				access:[APrivate, AInline], 
				kind:FFun({args:[], ret:null, expr:macro return data.$fieldName}),
				pos:pos
			});
		}
		
		return fields;
	}
	
	macro public static function checkConfig(data:Expr, typePath:String, warningCallback:Expr, errorCallback:Expr):Expr
	{
		var configDataType = Context.getType(typePath);
		var fields = getFields(configDataType);
		
		ConfigMacro.warningCallback = warningCallback;
		ConfigMacro.errorCallback = errorCallback;
		
		return genCheckFieldsExpr(data, fields);
	}
	
	#if macro
	private static function genCheckFieldsExpr(expr:Expr, fields:Array<ClassField>, ?fromFieldName:String = ""):Expr
	{
		var exprs = [];
		for (field in fields)
		{
			var name = field.name;
			var type = field.type;
			
			// check if the field is optional
			var optional = isNullType(field.type);
			
			var isArray = switch (field.type) 
			{
				case TInst(t, param):
					if (t.get().name == "Array")
					{
						type = param[0];
						true;
					}
					else
						false;
				default:
					false;
			}
			
			// check if this field is an anon object (or Array of anon object)
			var nestedFields = getFields(type);
			var isAnonObj = nestedFields != null;
			
			// expr for checking if the field is missing
			var verboseName = fromFieldName + name;
			var optionalErrorMessage = "optional field: " + verboseName + " missing";
			var errorMessage = "non-optional field: " + verboseName + " missing";
			var missingCheck = optional ? macro $warningCallback($v{optionalErrorMessage}) : macro $errorCallback($v{errorMessage});
			
			if(isArray)
				verboseName += "[n]";
			verboseName += ".";
				
			// expr for checking the nested fields if current field is also an anon object
			var nestedFieldCheck =
				if (isAnonObj)
				{
					if (isArray)
						macro for($i{name} in cast($expr.$name, Array<Dynamic>)) ${genCheckFieldsExpr(macro $i{name}, nestedFields, verboseName)};
					else
						genCheckFieldsExpr(macro $expr.$name, nestedFields, verboseName);
				}
				else
					null;
			
			
			if (isAnonObj)
				exprs.push(macro if ($expr.$name == null) $missingCheck else $nestedFieldCheck);
			else
				exprs.push(macro if ($expr.$name == null) $missingCheck);
		}
		
		return macro $b{exprs};
	}
	
	/**
	 * Return the fields of an anonymous object. If `type` does not defines an anonymous object, return null.
	 * @param	type
	 * @return
	 */
	private static function getFields(type:Type):Array<ClassField>
	{
		return switch (type) 
		{
			case TType(t, param):
				// if a field is declared as optional, its type will be wrapped with Null (e.g. `?myField:Int` becomes `myField:Null<Int>`)
				// so we need to extract that wrapped type
				if (t.get().name == "Null") 
					getFields(param[0]);
				else
					getFields(t.get().type);
				
			case TAnonymous(a):
				a.get().fields;
				
			default:
				null;
		}
	}
	
	private static function isNullType(type:Type):Bool
	{
		return switch (type) 
		{
			case TType(t, _):
				t.get().name == "Null";
			default:
				false;
		}
	}
	#end
}
