package impl.flixel.display.lighting;
import flixel.effects.postprocess.PostProcess;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.display.OpenGLView;
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
	
	public var ambientColor(default, set):FlxColor;
	
	private var lightFramebuffer:GLFramebuffer;
	private var lightTexture:GLTexture;
	private var lightRenderbuffer:GLRenderbuffer;
	
	
	private var lightTextureUniform:Int;
	
	private var camera:FlxCamera;
	private var group:FlxGroup;
	private var helperPoint:FlxPoint;
	
	public function new(fragmentShader:String, state:FlxState)
	{
		super(fragmentShader);
		
		// setup framebuffer
		lightFramebuffer = GL.createFramebuffer();
		GL.bindFramebuffer(GL.FRAMEBUFFER, lightFramebuffer);
		createLightTexture(screenWidth, screenHeight);
		createLightRenderbuffer(screenWidth, screenHeight);
		
		// cleanup
		GL.bindTexture(GL.TEXTURE_2D, null);
		GL.bindRenderbuffer(GL.RENDERBUFFER, null);
		GL.bindFramebuffer(GL.FRAMEBUFFER, null);
		
		before = new Before(lightFramebuffer);
		after = new After(this);
		
		camera = new FlxCamera();
		group = new FlxGroup();
		FlxG.cameras.add(camera);
		state.add(group);
		
		FlxG.stage.addChildAt(before, 0);
		FlxG.stage.addChildAt(camera.flashSprite, 1);
		FlxG.stage.addChildAt(after, 2);
		
		lightTextureUniform = shader.uniform("uImage1");
		
		ambientColor = 0xFF4E5469;
		
		addLight(0, 0);
		addLight(0, 200);
		addLight(0, 400);
		addLight(200, -100);
		addLight(200, 100);
		addLight(200, 300);
		addLight(200, 500);
		addLight(400, 0);
		addLight(400, 200);
		addLight(400, 400);
	}
	
	public function addLight(x:Float, y:Float):Void
	{
		var light = new FlxSprite(x, y, "assets/images/light/light.png");
		light.camera = camera;
		group.add(light);
		flicker(light);
	}
	
	private function flicker(light:FlxSprite):Void
	{
		FlxTween.num(0, 1, Math.random()/4, { onComplete:function(t) flicker(light) }, function(v) light.alpha = (v > 0.1 ? 1 : 0.2));
	}
	
	private function createLightTexture(width:Int, height:Int):Void
	{
		// setup texture
		lightTexture = GL.createTexture();
		GL.bindTexture(GL.TEXTURE_2D, lightTexture);
		GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGB, width, height,  0,  GL.RGB, GL.UNSIGNED_BYTE, null);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER , GL.LINEAR);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
		GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, lightTexture, 0);
		
	}
	
	private function createLightRenderbuffer(width:Int, height:Int):Void
	{
		// setup renderbuffer
		lightRenderbuffer = GL.createRenderbuffer();
		GL.bindRenderbuffer(GL.RENDERBUFFER, lightRenderbuffer);
		GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, width, height);
		GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, lightRenderbuffer);
	}
	
	override public function rebuild() 
	{
		super.rebuild();
		
		GL.bindFramebuffer(GL.FRAMEBUFFER, lightFramebuffer);

		if (lightTexture != null) GL.deleteTexture(lightTexture);
		if (lightRenderbuffer != null) GL.deleteRenderbuffer(lightRenderbuffer);

		createLightTexture(screenWidth, screenHeight);
		createLightRenderbuffer(screenWidth, screenHeight);
		
		GL.bindFramebuffer(GL.FRAMEBUFFER, null);
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
	
	private function set_ambientColor(v:FlxColor):FlxColor
	{
		before.clearR = v.redFloat;
		before.clearG = v.greenFloat;
		before.clearB = v.blueFloat;
		before.clearA = v.alphaFloat;
		return ambientColor = v;
	}
}

class Before extends OpenGLView
{
	private var framebuffer:GLFramebuffer;
	public var clearR:Float;
	public var clearG:Float;
	public var clearB:Float;
	public var clearA:Float;
	
	public function new(framebuffer:GLFramebuffer) 
	{
		super();
		this.framebuffer = framebuffer;
	}
	
	override public function render(rect:Rectangle)
	{
        GL.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);
		GL.clearColor(clearR, clearG, clearB, clearA);
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