package impl.flixel.display.lighting;
import flixel.effects.postprocess.PostProcess;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import openfl.display.OpenGLView;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.gl.GLFramebuffer;
import openfl.gl.GLRenderbuffer;
import openfl.gl.GLTexture;

/**
 * ...
 * @author Kevin
 */
class LightingSystem extends PostProcess
{
	public var before:Before;
	public var after:After;
	
	private var lightFramebuffer:GLFramebuffer;
	private var lightTexture:GLTexture;
	private var lightRenderbuffer:GLRenderbuffer;
	private var tilesheet:Tilesheet;
	private var tiledata:Array<Float>;
	public var sprite:Sprite;
	
	
	private var lightTextureUniform:Int;
	
	private var lights:Array<FlxObject>;
	private var helperPoint:FlxPoint;
	
	public function new(fragmentShader:String)
	{
		super(fragmentShader);
		
		// setup framebuffer
		lightFramebuffer = GL.createFramebuffer();
		GL.bindFramebuffer(GL.FRAMEBUFFER, lightFramebuffer);
		
		// setup texture
		lightTexture = GL.createTexture();
		GL.bindTexture(GL.TEXTURE_2D, lightTexture);
		GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGB,  FlxG.stage.stageWidth, FlxG.stage.stageHeight,  0,  GL.RGB, GL.UNSIGNED_BYTE, null);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER , GL.LINEAR);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
		GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, lightTexture, 0);
		
		// setup renderbuffer
		lightRenderbuffer = GL.createRenderbuffer();
		GL.bindRenderbuffer(GL.RENDERBUFFER, lightRenderbuffer);
		GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, FlxG.stage.stageWidth, FlxG.stage.stageHeight);
		GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, lightRenderbuffer);
		
		// cleanup
		GL.bindTexture(GL.TEXTURE_2D, null);
		GL.bindRenderbuffer(GL.RENDERBUFFER, null);
		GL.bindFramebuffer(GL.FRAMEBUFFER, null);

		// create the helpersprite for rendering the light map
		var r = 250;
		var c = new CircularLight(r, [0xffffff, 0xffffff, 0xffffff], [1, 0.5, 0], [0, 180,255]);
		tilesheet = new Tilesheet(c.pixels);
		tilesheet.addTileRect(new Rectangle(0, 0, r * 2, r * 2));
		tiledata = [];
		
		sprite = new Sprite();
		before = new Before(lightFramebuffer);
		after = new After(this);
		
		FlxG.stage.addChildAt(before, 0);
		FlxG.stage.addChildAt(sprite, 1);
		FlxG.stage.addChildAt(after, 2);
		
		lightTextureUniform = shader.uniform("uImage1");
		
		lights = [];
		helperPoint = FlxPoint.get();
		
		FlxG.signals.postUpdate.add(function()
		{
			for (i in 0...lights.length)
			{
				var light = lights[i];
				light.getScreenPosition(helperPoint);
				
				var offset = i * 3;
				tiledata[offset + 0] = helperPoint.x;
				tiledata[offset + 1] = helperPoint.y;
				tiledata[offset + 2] = 0;
			}
			sprite.graphics.clear();
			tilesheet.drawTiles(sprite.graphics, tiledata, false, 0, lights.length * 3);
		});
		
		//addLight(0, 0);
		//addLight(0, 200);
		//addLight(0, 400);
		//addLight(200, 0);
		addLight(200, 200);
		//addLight(200, 400);
		//addLight(400, 0);
		//addLight(400, 200);
		//addLight(400, 400);
	}
	
	public function addLight(x:Float, y:Float):Void
	{
		lights.push(new FlxObject(x, y));
	}
	
	
	override public function render(rect:Rectangle) 
	{
		
		// run the multiply shader
		GL.bindFramebuffer(GL.FRAMEBUFFER, renderTo);
		GL.viewport(0, 0, screenWidth, screenHeight);
		
		shader.bind();

		GL.enableVertexAttribArray(vertexSlot);
		GL.enableVertexAttribArray(texCoordSlot);

		GL.activeTexture(GL.TEXTURE0);
		GL.bindTexture(GL.TEXTURE_2D, texture);
		GL.enable(GL.TEXTURE_2D);
		
		GL.activeTexture(GL.TEXTURE1);
		GL.bindTexture(GL.TEXTURE_2D, lightTexture);
		GL.enable(GL.TEXTURE_2D);


		GL.bindBuffer(GL.ARRAY_BUFFER, buffer);
		GL.vertexAttribPointer(vertexSlot, 2, GL.FLOAT, false, 16, 0);
		GL.vertexAttribPointer(texCoordSlot, 2, GL.FLOAT, false, 16, 8);

		GL.uniform1i(imageUniform, 0);
		GL.uniform1i(lightTextureUniform, 1);
		GL.uniform1f(timeUniform, time);
		GL.uniform2f(resolutionUniform, screenWidth, screenHeight);

		for (u in uniforms)
		{
			GL.uniform1f(u.id, u.value);
		}

		GL.drawArrays(GL.TRIANGLES, 0, 6);

		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		GL.disable(GL.TEXTURE_2D);
		GL.bindTexture(GL.TEXTURE_2D, null);
		
		GL.activeTexture(GL.TEXTURE0);
		GL.disable(GL.TEXTURE_2D);
		GL.bindTexture(GL.TEXTURE_2D, null);

		GL.disableVertexAttribArray(vertexSlot);
		GL.disableVertexAttribArray(texCoordSlot);

		GL.useProgram(null);
		
		GL.bindFramebuffer(GL.FRAMEBUFFER, null);
		
		// check gl error
		if (GL.getError() == GL.INVALID_FRAMEBUFFER_OPERATION)
		{
			trace("INVALID_FRAMEBUFFER_OPERATION!!");
		}
	}
	
}

class Before extends OpenGLView
{
	private var framebuffer:GLFramebuffer;
	
	public function new(framebuffer:GLFramebuffer) 
	{
		super();
		this.framebuffer = framebuffer;
	}
	
	override public function render(rect:Rectangle)
	{
        GL.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);
		GL.clearColor(0.5, 0.5, 0.9, 1);
        GL.clear (GL.DEPTH_BUFFER_BIT | GL.COLOR_BUFFER_BIT);
	}
}

class After extends OpenGLView
{
	private var postProcess:PostProcess;
	
	public function new(postProcess:PostProcess) 
	{
		super();
		this.postProcess = postProcess;
	}
	
	@:access(flixel.effects.postprocess.PostProcess)
	override public function render(rect:Rectangle)
	{
        GL.bindFramebuffer(GL.FRAMEBUFFER, postProcess.framebuffer);
	}
}