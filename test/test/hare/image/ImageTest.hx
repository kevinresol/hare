package hare.image;

import massive.munit.Assert;
import hare.image.Image;
/**
 * ...
 * @author Kevin
 */
class ImageTest
{

	public function new() 
	{
		
	}
	
	@Test
	public function testPackedSource():Void
	{
		var pack = new PackedImage("3x2_spritesheet.png", 384, 512, true);
		Assert.isTrue(pack.columns == 3);
		Assert.isTrue(pack.rows == 2);
		Assert.isTrue(pack.images.length == 3 * 2);
		
		var pack = new PackedImage("13x12_spritesheet.png", 384, 512, true);
		Assert.isTrue(pack.columns == 13);
		Assert.isTrue(pack.images.length == 13 * 12);
	}
	
	@Test
	public function testNonPackedSource():Void
	{
		var pack = new PackedImage("spritesheet.png", 384, 512, true);
		Assert.isTrue(pack.columns == 1);
		Assert.isTrue(pack.rows == 1);
	}
	
	@Test
	public function testSpritesheet():Void
	{
		var pack = new PackedImage("spritesheet.png", 384, 512, true);
		Assert.isTrue(pack.images[0].columns == 3);
		Assert.isTrue(pack.images[0].rows == 4);
	}
	
	@Test
	public function testNonSpritesheet():Void
	{
		var pack = new PackedImage("spritesheet.png", 384, 512, false);
		Assert.isTrue(pack.images[0].columns == 1);
		Assert.isTrue(pack.images[0].rows == 1);
	}
	
	@Test
	public function testGlobalIndexNonPacked():Void
	{
		var pack = new PackedImage("spritesheet.png", 384, 512, true);
		Assert.isTrue(pack.images[0].getGlobalFrameIndex(0, 0) == 0);
		Assert.isTrue(pack.images[0].getGlobalFrameIndex(0, 1) == 3);
		Assert.isTrue(pack.images[0].getGlobalFrameIndex(0, 2) == 6);
		Assert.isTrue(pack.images[0].getGlobalFrameIndex(0, 3) == 9);
		Assert.isTrue(pack.images[0].getGlobalFrameIndex(2, 3) == 11);
	}
	
	@Test
	public function testGlobalIndexPacked():Void
	{
		var pack = new PackedImage("3x2_spritesheet.png", 384, 512, true);
		Assert.isTrue(pack.images[0].getGlobalFrameIndex(0, 0) == 0);
		Assert.isTrue(pack.images[0].getGlobalFrameIndex(1, 0) == 1);
		Assert.isTrue(pack.images[0].getGlobalFrameIndex(0, 1) == 9);
		
		Assert.isTrue(pack.images[1].getGlobalFrameIndex(0, 0) == 3);
		Assert.isTrue(pack.images[1].getGlobalFrameIndex(1, 0) == 4);
		Assert.isTrue(pack.images[1].getGlobalFrameIndex(0, 1) == 12);
		
		Assert.isTrue(pack.images[4].getGlobalFrameIndex(0, 0) == 39);
		Assert.isTrue(pack.images[4].getGlobalFrameIndex(1, 0) == 40);
		Assert.isTrue(pack.images[4].getGlobalFrameIndex(0, 1) == 48);
		
		Assert.isTrue(pack.images[5].getGlobalFrameIndex(0, 0) == 42);
		Assert.isTrue(pack.images[5].getGlobalFrameIndex(1, 0) == 43);
		Assert.isTrue(pack.images[5].getGlobalFrameIndex(0, 1) == 51);
	}
	
	@Test function testFrameDimensionNonPacked():Void
	{
		var pack = new PackedImage("spritesheet.png", 32 * 3, 48 * 4, true);
		
		var image = pack.images[0];
		Assert.isTrue(image.frameWidth == 32);
		Assert.isTrue(image.frameHeight == 48);
	}
	
	@Test function testFrameDimensionPacked():Void
	{
		var pack = new PackedImage("4x2_spritesheet.png", 384, 512, true);
		
		for (i in 0...8)
		{
			var image = pack.images[i];
			Assert.isTrue(image.frameWidth == 32);
			Assert.isTrue(image.frameHeight == 64);
		}
	}
	
	
}