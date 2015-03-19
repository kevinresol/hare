# RPG Engine

A RPG engine for Haxe including the following core components while the visuals and user input are abstracted away:

- 2D Map
- Events (Scripted with Lua)
- Items

A default implementation for HaxeFlixel is provided. 
But it could be easily implemented on other game frameworks.

## Targets

Currently only supports neko and cpp due to the Lua dependency.

## Install

```
haxelib git rpg-engine http://gitlab.vicehope.com/kevin/rpg-engine
```

## Usage with HaxeFlixel

```
haxelib git rpg-engine http://gitlab.vicehope.com/kevin/rpg-engine
haxelib git flixel https://github.com/HaxeFlixel/flixel.git
haxelib git lua https://github.com/kevinresol/hx-lua
lime rebuild lua windows
```

In any `FlxState`:

```haxe
private var impl:impl.flixel.Implementation;

override public function create():Void
{
	super.create();
	
	impl = new impl.flixel.Implementation(this);
	new rpg.Engine(impl, "entry_point_map_id");
}

override public function update(elapsed:Float):Void 
{
	super.update(elapsed);
	impl.update(elapsed);
}
```


## Implement on other game frameworks

Implement the follow interfaces:
- `IAssetManager`
- `IImplementation`