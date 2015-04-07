package impl.flixel.display.lighting;
import flixel.effects.postprocess.PostProcess;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;
import haxe.Timer;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.OpenGLView;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.gl.GLFramebuffer;
import rpg.Events;
import rpg.input.InputManager.InputKey;

/**
 * ...
 * @author Kevin
 */
class LightingSystem extends PostProcess
{
	private var lightFramebuffer;
	private var lightTexture;
	private var lightRenderbuffer;
	
	public function new(fragmentShader:String)
	{
		super(fragmentShader);
		
		lightFramebuffer = GL.createFramebuffer();
		GL.bindFramebuffer(GL.FRAMEBUFFER, lightFramebuffer);
		
		lightTexture = GL.createTexture();
		GL.bindTexture(GL.TEXTURE_2D, lightTexture);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR_MIPMAP_NEAREST);
		GL.generateMipmap(GL.TEXTURE_2D);
		GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, lightFramebuffer.width, lightFramebuffer.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, null)
		
		lightRenderbuffer = GL.createRenderbuffer();
		GL.bindRenderbuffer(GL.RENDERBUFFER, lightRenderbuffer);
		GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, FlxG.stage.stageWidth, FlxG.stage.stageHeight);
		
		GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, lightTexture, 0);
		GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, lightRenderbuffer);
		
		GL.bindTexture(GL.TEXTURE_2D, null);
		GL.bindRenderbuffer(GL.RENDERBUFFER, null);
		GL.bindFramebuffer(GL.FRAMEBUFFER, null);

		
	}
	
	override public function update(elapsed:Float) 
	{
		super.update(elapsed);
		
		GL.bindFramebuffer(GL.FRAMEBUFFER, lightFramebuffer);
		
		
		
		GL.bindFramebuffer(GL.FRAMEBUFFER, null);
	}
	
	override public function render(rect:Rectangle) 
	{
		GL.bindFramebuffer(GL.FRAMEBUFFER, renderTo);
		GL.viewport(0, 0, screenWidth, screenHeight);
		
		shader.bind();

		GL.enableVertexAttribArray(vertexSlot);
		GL.enableVertexAttribArray(texCoordSlot);

		GL.activeTexture(GL.TEXTURE0);
		GL.bindTexture(GL.TEXTURE_2D, texture);
		GL.enable(GL.TEXTURE_2D);

		GL.bindBuffer(GL.ARRAY_BUFFER, buffer);
		GL.vertexAttribPointer(vertexSlot, 2, GL.FLOAT, false, 16, 0);
		GL.vertexAttribPointer(texCoordSlot, 2, GL.FLOAT, false, 16, 8);

		GL.uniform1i(imageUniform, 0);
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