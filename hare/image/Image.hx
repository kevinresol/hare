package hare.image;
import hare.geom.Rectangle;

/**
 * ...
 * @author Kevin
 */
@:allow(hare.image)
class PackedImage
{
	public var source(default, null):String;
	public var numImages(get, never):Int;
	
	/**
	 * columns * rows = number of sub-images in this packed image
	 */
	public var columns(default, null):Int;
	
	/**
	 * columns * rows = number of sub-images in this packed image
	 */
	public var rows(default, null):Int;
	
	/**
	 * Width in pixels of the packed image.
	 */
	public var width(default, null):Int;
	
	/**
	 * Width in pixels of the packed image.
	 */
	public var height(default, null):Int;
	
	private var images:Array<Image>;

	public function new(source:String, width:Int, height:Int, isSpritesheet:Bool) 
	{
		this.source = source;
		this.width = width;
		this.height = height;
		
		// figure out how many individual images are packed
		var filename = source.substr(source.lastIndexOf("/") + 1);
		var reg = ~/^([0-9]+)[xX]([0-9]+)_/; 
        
        if(reg.match(filename)) // the image source starts with the dimension followed by underscore (e.g. "2x3_")
        {
            columns = Std.parseInt(reg.matched(1));
            rows = Std.parseInt(reg.matched(2));
        }
		else
			columns = rows = 1;
			
		images = [];
		for (c in 0...columns)
		{
			for (r in 0...rows)
			{
				images[r * columns + c] = new Image(this, isSpritesheet);
			}
		}
	}
	
	private inline function get_numImages():Int
	{
		return images.length;
	}
	
	
}

class Image
{
	public var index(get, never):Int;
	public var source(get, never):String;
	public var columns:Int;
	public var rows:Int;
	public var frameWidth(get, never):Int;
	public var frameHeight(get, never):Int;
	
	/**
	 * area of this image in the parent packed image
	 */
	public var areaInPixels(get, never):Rectangle;
	
	/**
	 * area of this image in the parent packed image
	 */
	public var areaInFrames(get, never):Rectangle;
	
	private var parent:PackedImage;
	
	public function new(parent:PackedImage, isSpritesheet:Bool)
	{
		this.parent = parent;
		
		if (isSpritesheet)
		{
			columns = 3;
			rows = 4;
		}
		else
			columns = rows = 1;
	}
	
	public function getGlobalFrameIndex(localX:Int, localY:Int):Int
	{
		var i = index;
		
		var globalX = (i % parent.columns) * columns + localX;
		var globalY = Std.int(i / parent.columns) * rows + localY;
		
		return globalY * columns * parent.columns + globalX;
	}
	
	private inline function get_source():String
	{
		return parent.source;
	}
	
	private inline function get_frameWidth():Int
	{
		return Std.int(parent.width / parent.columns / columns);
	}
	
	private inline function get_frameHeight():Int
	{
		return Std.int(parent.height / parent.rows / rows);
	}
	
	private inline function get_areaInPixels():Rectangle
	{
		var rect = areaInFrames;
		rect.x *= frameWidth;
		rect.y *= frameHeight;
		rect.width *= frameWidth;
		rect.height *= frameHeight;
		return rect;
	}
	private inline function get_areaInFrames():Rectangle
	{
		var i = index;
		return new Rectangle((i % parent.columns) * columns, Std.int(i / parent.columns) * rows, columns, rows);
	}
	
	private inline function get_index():Int
	{
		return parent.images.indexOf(this);
	}
}

enum ImageType
{
	IMainMenu(filename:String);
	ICharacter(filename:String);
	IFace(filename:String);
}