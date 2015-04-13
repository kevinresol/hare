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
	
	public function getPackedImage(imageType:ImageType):PackedImage
	{
		var source = switch (imageType) 
		{
			case ICharacter(filename): 'assets/images/character/$filename';
		}
		
		if (!packedImages.exists(source))
		{
			var dimension = engine.assetManager.getImageDimension(source);
			var packedImage = new PackedImage(source, dimension.width, dimension.height, true); //TODO: check if it is spritesheet or not
			packedImages[source] = packedImage;
		}
		return packedImages[source];
	}
	
	public function getImage(imageType:ImageType, index:Int):Image
	{
		var packedImage = getPackedImage(imageType);
		
		if (index >= packedImage.images.length) 
			engine.log('index $index does not exist for the image ${packedImage.source}', LError);
		return packedImage.images[index];
	}
}