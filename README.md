[![Travis Build](https://travis-ci.org/kevinresol/hare.svg?branch=develop)](https://travis-ci.org/kevinresol/hare)

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

Flash support pending due to https://github.com/HaxeFoundation/haxe/issues/4150
	
No support for HTML5 right now. I am not sure if there are any Lua vm on js. 
Please kindly let me know if there are any good candidates. 
However, I am not sure if it is a good idea to run a vm in a vm after all. (same for Flash in fact)

## Install

```
haxelib git hare http://github.com/kevinresol/hare
```

## Usage with HaxeFlixel

```
haxelib git hare http://github.com/kevinresol/hare
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
	
	hare.impl.flixel.HareFlixel.state = this;
	engine = new hare.Engine({
		game:hare.impl.flixel.Game,
		music:hare.impl.flixel.Music,
		sound:hare.impl.flixel.Sound,
		assets:hare.impl.flixel.Assets,
		screen:hare.impl.flixel.Screen,
		system:hare.impl.flixel.System,
		message:hare.impl.flixel.Message,
		movement:hare.impl.flixel.Movement,
		renderer:hare.impl.flixel.Renderer,
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
