package rpg.image;

/**
 * ...
 * @author Kevin
 */
class PackedImage
{
	public var source:String;
	
	/**
	 * columns * rows = number of sub-images in this packed image
	 */
	public var columns:Int;
	
	/**
	 * columns * rows = number of sub-images in this packed image
	 */
	public var rows:Int;
	
	/**
	 * Width in pixels of the packed image.
	 */
	public var width:Int;
	
	/**
	 * Width in pixels of the packed image.
	 */
	public var height:Int;
	
	public var images:Array<Image>;

	public function new(source:String, width:Int, height:Int, isSpritesheet:Bool) 
	{
		this.source = source;
		this.width = width;
		this.height = height;
		
		// figure out how many individual images are packed
		var reg = ~/^([0-9]+)[xX]([0-9]+)_/; 
        
        if(reg.match(source)) // the image source starts with the dimension followed by underscore (e.g. "2x3_")
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
	
	
}

class Image
{
	public var source(get, never):String;
	public var columns:Int;
	public var rows:Int;
	public var frameWidth(get, never):Int;
	public var frameHeight(get, never):Int;
	
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
		var index = parent.images.indexOf(this);
		
		var globalX = (index % parent.columns) * columns + localX;
		var globalY = Std.int(index / parent.columns) * rows + localY;
		
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
}