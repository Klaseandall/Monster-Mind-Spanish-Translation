package puzzle;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * Graphics for the blue blobs which glow and move around the brain when
 * synching
 */
 class BrainBlobbyGroup extends FlxGroup implements CustomDrawnFlxGroup
{
	private var _zeroPoint:Point;

	public var _blobColour:Int = 0x40A4C0;
	public var _blobThreshold:Int = 0x10;
	public var _shineColour:Int = 0x7FE4FF;
	public var _shineThreshold:Int = 0x40;

	// the buffer which gets drawn to
	private var _sourceBuffer:FlxSprite;
	private var _targetBuffer:FlxSprite;
	private var _tempBuffer:FlxSprite;

	public var _blobOpacity:Int = 0xFF;
	private var _clipRect:Rectangle;
	private var _maskMatrix:Matrix;
	public var _shineOpacity:Int = 0xFF;

	private var _maskGraphic:FlxGraphic;

	public function new(x:Float, y:Float, maskGraphic:FlxGraphic)
	{
		super(0);
	
		_clipRect = new Rectangle(x, y, maskGraphic.width, maskGraphic.height);
		_maskGraphic = maskGraphic;
		_zeroPoint = new Point(0, 0);
		_maskMatrix = new Matrix();
		_maskMatrix.translate(_clipRect.x, _clipRect.y);

		#if flash
		// Flash supports software rendering. We create a source buffer as
		// large as the camera's viewport, and swap them
		_sourceBuffer = new FlxSprite(0, 0, new BitmapData(FlxG.camera.width, FlxG.camera.height, true, 0x00));
		#else
		// For non-flash targets, we create a small source buffer the same
		// size as the clipRect

		// _sourceBuffer = new FlxSprite(_clipRect.x, _clipRect.y, new BitmapData(Std.int(_clipRect.width), Std.int(_clipRect.height), true, 0x00));
		_sourceBuffer = new FlxSprite(0, 0, new BitmapData(FlxG.camera.width, FlxG.camera.height, true, 0x00));
		#end

		_targetBuffer = new FlxSprite(_clipRect.x, _clipRect.y, new BitmapData(Std.int(_clipRect.width), Std.int(_clipRect.height), true, 0x00));
		_tempBuffer = new FlxSprite(_clipRect.x, _clipRect.y, new BitmapData(Std.int(_clipRect.width), Std.int(_clipRect.height), true, 0x00));
		// _targetBuffer = new FlxSprite(_clipRect.x, _clipRect.y, new BitmapData(Std.int(_clipRect.width), Std.int(_clipRect.height), true, 0x00));
		// _tempBuffer = new FlxSprite(_clipRect.x, _clipRect.y, new BitmapData(Std.int(_clipRect.width), Std.int(_clipRect.height), true, 0x00));
	}

	private function _clearCameraBuffer():Void
	{
		FlxG.camera.fill(FlxColor.TRANSPARENT, false);
	}

	private function _clearSourceBuffer():Void
	{
		_sourceBuffer.graphic.bitmap.fillRect(_sourceBuffer.graphic.bitmap.rect, FlxColor.TRANSPARENT);
	}

	private function _swapCameraBuffer():Void
	{
		var tmpBuffer:BitmapData = FlxG.camera.buffer;
		FlxG.camera.buffer = _sourceBuffer.graphic.bitmap;
		_sourceBuffer.graphic.bitmap = tmpBuffer;
	}

	private function _postProcess():Void
	{
		_targetBuffer.graphic.bitmap.fillRect(_targetBuffer.graphic.bitmap.rect, 0xFF2084A0);
		
		#if flash
		_targetBuffer.graphic.bitmap.threshold(_sourceBuffer.graphic.bitmap, _clipRect, _zeroPoint, '>', _blobThreshold << 16, _blobOpacity << 24 | _blobColour, 0x00FF0000, false);
		_targetBuffer.graphic.bitmap.threshold(_sourceBuffer.graphic.bitmap, _clipRect, _zeroPoint, '>', _shineThreshold << 16, _blobOpacity << 24 | _shineColour, 0x00FF0000, false);
		#else
		_tempBuffer.graphic.bitmap.fillRect(_tempBuffer.graphic.bitmap.rect, FlxColor.BLACK);
		{
			var m:Matrix = new Matrix();
			m.translate(_sourceBuffer.x - _tempBuffer.x, _sourceBuffer.y - _tempBuffer.y);
			_tempBuffer.graphic.bitmap.draw(_sourceBuffer.graphic.bitmap, m);
		}
		_targetBuffer.graphic.bitmap.threshold(_tempBuffer.graphic.bitmap, _tempBuffer.graphic.bitmap.rect, _zeroPoint, '>', _blobThreshold << 16, _blobOpacity << 24 | _blobColour, 0x00FF0000, false);
		_targetBuffer.graphic.bitmap.threshold(_tempBuffer.graphic.bitmap, _tempBuffer.graphic.bitmap.rect, _zeroPoint, '>', _shineThreshold << 16, _blobOpacity << 24 | _shineColour, 0x00FF0000, false);
		#end

		_targetBuffer.graphic.bitmap.draw(_maskGraphic.bitmap);
		_targetBuffer.graphic.bitmap.threshold(_targetBuffer.graphic.bitmap, _targetBuffer.graphic.bitmap.rect, _zeroPoint, "==", 0xffff00ff, 0x00000000);
	}

	override public function draw():Void
	{
		var customDrawnBuffer:FlxSprite = customDrawToBuffer();
		#if flash
		FlxG.camera.buffer.copyPixels(customDrawnBuffer.graphic.bitmap, customDrawnBuffer.graphic.bitmap.rect, _clipRect.topLeft, null, null, true);
		#else
		customDrawnBuffer.draw();
		#end
	}

	public function customDrawToBuffer():FlxSprite
	{
		#if flash
		// Swap the camera to a different screen buffer
		_swapCameraBuffer();

		// then empty the camera buffer
		_clearCameraBuffer();

		// then render using the parent code
		super.draw();

		// then restore the camera buffer
		_swapCameraBuffer();
		#else
		_clearSourceBuffer();
		
		// render using the parent code
		PixelFilterUtils.drawToBuffer(_sourceBuffer, this);
		#end
		
		_postProcess();

		return _targetBuffer;
	}

	override public function destroy():Void
	{
		super.destroy();

		_zeroPoint = null;
		_sourceBuffer = FlxDestroyUtil.destroy(_sourceBuffer);
		_targetBuffer = FlxDestroyUtil.destroy(_targetBuffer);
		_tempBuffer = FlxDestroyUtil.destroy(_tempBuffer);
		_clipRect = null;
	}
}