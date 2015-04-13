package rpg.image;
import rpg.Engine;
import rpg.image.Image;
import rpg.image.Image.PackedImage;

/**
 * ...
 * @author Kevin
 */
class ImageManager
{
	private var engine:Engine;
	
	private var packedImages:Map<String, PackedImage>;
	
	public function new(engine:Engine) 
	{
		this.engine = engine;
		
		packedImages = new Map(); 
	}
	
	public function getPackedImage(source:String):PackedImage
	{
		if (!packedImages.exists(source))
		{
			var dimension = engine.assetManager.getImageDimension(source);
			var packedImage = new PackedImage(source, dimension.width, dimension.height, true); //TODO: check if it is spritesheet or not
			packedImages[source] = packedImage;
		}
		return packedImages[source];
	}
	
	public function getImage(source:String, index:Int):Image
	{
		var packedImage = getPackedImage(source);
		
		if (index >= packedImage.images.length) 
			engine.log('index $index does not exist for the image $source', LError);
		return packedImage.images[index];
	}
	
}