package hare.impl.flixel.display;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import hare.geom.Rectangle;

/**
 * ...
 * @author Kevin
 */
class Slice9Sprite extends FlxSpriteGroup
{
	private var sprites:Array<FlxSprite>;
	
	public function new(graphic:FlxGraphicAsset, bound:Rectangle, slice9:Rectangle, ?skip:Array<Int>) 
	{
		super();
		sprites = [];
		
		var bx = bound.x;
		var by = bound.y;
		var bw = bound.width;
		var bh = bound.height;
		var sx = slice9.x;
		var sy = slice9.y;
		var sw = slice9.width;
		var sh = slice9.height;
		
		var rects = [
			/* 0 */ new Rectangle(bx, by, sx - bx, sy - by),
			/* 1 */ new Rectangle(sx, by, sw, sy - by),
			/* 2 */ new Rectangle(sx + sw, by, bw - (sx - bx) - sw, sy - by),
			/* 3 */ new Rectangle(bx, sy, sx - bx, sh),
			/* 4 */ new Rectangle(sx, sy, sw, sh),
			/* 5 */ new Rectangle(sx + sw, sy, bw - (sx - bx) - sw, sh),
			/* 6 */ new Rectangle(bx, sy + sh, sx - bx, bh - sh - (sx - bx)),
			/* 7 */ new Rectangle(sx, sy + sh, sw, bh - sh - (sx - bx)),
			/* 8 */ new Rectangle(sx + sw, sy + sh, bw - (sx - bx) - sw, bh - sh - (sx - bx)),
		];
		
		var rect = new FlxRect();
		for (i in 0...9)
		{
			var s = new FlxSprite();
			s.loadGraphic(graphic);
			
			var frames = new FlxFramesCollection(s.graphic);
			rect.x = rects[i].x;
			rect.y = rects[i].y;
			rect.width = rects[i].width;
			rect.height = rects[i].height;
			frames.addSpriteSheetFrame(rect);
			s.frames = frames;

			s.x = rect.x - bx;
			s.y = rect.y - by;
			s.origin.set();
			sprites.push(s);
			if (skip == null || skip.indexOf(i) == -1)
				add(s);
		}
	}
	
	override public function setGraphicSize(width:Int = 0, height:Int = 0):Void 
	{
		if (sprites != null)
		{
			var sx = (width - sprites[0].frameWidth - sprites[2].frameWidth) / sprites[1].frameWidth;
			
			sprites[1].scale.x = sprites[4].scale.x = sprites[7].scale.x = sx;
			sprites[2].x = sprites[5].x = sprites[8].x = x + width - sprites[2].frameWidth;
			
			var sy = (height - sprites[0].frameHeight - sprites[6].frameHeight) / sprites[3].frameHeight;
		
			sprites[3].scale.y = sprites[4].scale.y = sprites[5].scale.y = sy;
			sprites[6].y = sprites[7].y = sprites[8].y = y + height - sprites[6].frameHeight;
		}
	}
	
}