# Hare

**Ha**xe **R**PG **E**ngine

A RPG engine for Haxe including the following core components while the visuals and user input are abstracted away:

- 2D Map
- Events (Scripted with Lua)
- Items
- Screen effects



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
var engine:hare.Engine;

override public function create():Void
{
	super.create();
	
	impl.flixel.HareFlixel.state = this;
	engine = new hareEngine({
		game:impl.flixel.Game,
		music:impl.flixel.Music,
		sound:impl.flixel.Sound,
		assets:impl.flixel.Assets,
		screen:impl.flixel.Screen,
		system:impl.flixel.System,
		message:impl.flixel.Message,
		movement:impl.flixel.Movement,
		renderer:impl.flixel.Renderer,
	});
}

override public function update(elapsed:Float):Void 
{
	super.update(elapsed);
	engine.update(elapsed);
}
```

## Implement on other game frameworks

Override the classes in the `hare.impl` package

## Game contents

For game contents like maps/script/images/sounds, please refer to wiki