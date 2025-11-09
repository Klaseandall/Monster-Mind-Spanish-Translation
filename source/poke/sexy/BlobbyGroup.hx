package poke.sexy;

import openfl.geom.ColorTransform;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * Uses a threshold filter to create a blobby effect. Used for rendering
 * sexual fluids and sweat.
 */
class BlobbyGroup extends FlxGroup implements CustomDrawnFlxGroup
{
	private var _zeroPoint:Point;

	public var _blobColour:Int = 0;
	public var _blobThreshold:Int = 0;
	public var _shineColour:Int = 0xFFFFFF;
	public var _shineThreshold:Int = 0;

	// the buffer which gets initially rendered to to
	private var _sourceBuffer:FlxSprite;
	private var _targetBuffer:FlxSprite;
	private var _tempBuffer:FlxSprite;


	public var _blobOpacity:Int = 0;
	private var _clipRect:Rectangle;
	private var _highlightMatrix:Matrix;
	public var _shineOpacity:Int = 0xFF;

	public function new(MaxSize:Int=0, BlobColour:Int = 0xFFFFFF, BlobThreshold:Int = 0x20, BlobOpacity:Int = 0xFF)
	{
		super(MaxSize);

		_blobColour = BlobColour;
		_blobThreshold = BlobThreshold;
		_shineThreshold = BlobThreshold;
		_blobOpacity = BlobOpacity;

		_clipRect = new Rectangle(256 + 5, 0 + 5, 248 - 4, 424 - 2);
		_zeroPoint = new Point(0, 0);
		_highlightMatrix = new Matrix();
		_highlightMatrix.translate(2, 4);

		#if flash
		// Flash supports software rendering. We create a source buffer as
		// large as the camera's viewport, and swap them
		_sourceBuffer = new FlxSprite(0, 0, new BitmapData(FlxG.camera.width, FlxG.camera.height, true, 0x00));
		#else
		// For non-flash targets, we create a small source buffer the same
		// size as the clipRect
		_sourceBuffer = new FlxSprite(_clipRect.x, _clipRect.y, new BitmapData(Std.int(_clipRect.width), Std.int(_clipRect.height), true, 0x00));
		#end

		_targetBuffer = new FlxSprite(_clipRect.x, _clipRect.y, new BitmapData(Std.int(_clipRect.width), Std.int(_clipRect.height), true, 0x00));
		_tempBuffer = new FlxSprite(_clipRect.x, _clipRect.y, new BitmapData(Std.int(_clipRect.width), Std.int(_clipRect.height), true, 0x00));
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

	function _fixThresholdBlackAlpha(spr:FlxSprite, _blobColour:Int):Void {
		// threshold() function is broken in non-flash platforms, and draws translucent bright colors as black.
		// We manually recolor them using a ColorTransform.
		var redOffset:Int = (_blobColour & 0x00FF0000) >> 16;
		var greenOffset:Int = (_blobColour & 0x0000FF00) >> 8;
		var blueOffset:Int = (_blobColour & 0x000000FF) >> 0;
		var fixColorTransform: ColorTransform = new ColorTransform(0, 0, 0, 1, redOffset, greenOffset, blueOffset);
		
		spr.graphic.bitmap.colorTransform(spr.graphic.bitmap.rect, fixColorTransform);
	}

	private function _postProcess():Void
	{
		_targetBuffer.graphic.bitmap.fillRect(_targetBuffer.graphic.bitmap.rect, FlxColor.TRANSPARENT);
		
		#if flash
		_targetBuffer.graphic.bitmap.threshold(_sourceBuffer.graphic.bitmap, _clipRect, _zeroPoint, '>', _blobThreshold << 16, _blobOpacity << 24 | _blobColour, 0x00FF0000, false);
		#else
		_tempBuffer.graphic.bitmap.fillRect(_tempBuffer.graphic.bitmap.rect, FlxColor.BLACK);
		{
			var m:Matrix = new Matrix();
			m.translate(_sourceBuffer.x - _tempBuffer.x, _sourceBuffer.y - _tempBuffer.y);
			_tempBuffer.graphic.bitmap.draw(_sourceBuffer.graphic.bitmap, m);
		}
		_targetBuffer.graphic.bitmap.threshold(_tempBuffer.graphic.bitmap, _tempBuffer.graphic.bitmap.rect, _zeroPoint, '>', _blobThreshold << 16, _blobOpacity << 24 | _blobColour, 0x00FF0000, false);
		_fixThresholdBlackAlpha(_targetBuffer,_blobColour);
		#end

		#if flash
		// Flash premultiplies the alpha, and supports the 'subtract'
		// BlendMode. We render highlights by rendering the blob shapes, and
		// erasing the unhighlighted sections with the 'Subtract' blend mode.
		
		_tempBuffer.graphic.bitmap.copyPixels(_sourceBuffer.graphic.bitmap, _clipRect, _zeroPoint);
		{
			var m:Matrix = new Matrix();
			m.copyFrom(_highlightMatrix);
			m.translate(_sourceBuffer.x - _tempBuffer.x, _sourceBuffer.y - _tempBuffer.y);
			_tempBuffer.graphic.bitmap.draw(_sourceBuffer.graphic.bitmap, m, null, BlendMode.SUBTRACT);
		}
		_targetBuffer.graphic.bitmap.threshold(_tempBuffer.graphic.bitmap, _tempBuffer.graphic.bitmap.rect, _zeroPoint, '>', _shineThreshold << 16, _shineOpacity << 24 | _shineColour, 0x00FF0000, false);
		#else
		// Non-flash targets do not premultiply the alpha, and do not support
		// the 'subtract' BlendMode. We render highlights by rendering the
		// blob shapes against a black background, drawing over the
		// unhighlighted sections with black.
		
		_tempBuffer.graphic.bitmap.fillRect(_tempBuffer.graphic.bitmap.rect, FlxColor.BLACK);
		{
			var m:Matrix = new Matrix();
			m.translate(_sourceBuffer.x - _tempBuffer.x, _sourceBuffer.y - _tempBuffer.y);
			_tempBuffer.graphic.bitmap.draw(_sourceBuffer.graphic.bitmap, m, new ColorTransform(1, 1, 1, 0.75));
		}
		{
			var m:Matrix = new Matrix();
			m.copyFrom(_highlightMatrix);
			m.translate(_sourceBuffer.x - _tempBuffer.x, _sourceBuffer.y - _tempBuffer.y);
			_tempBuffer.graphic.bitmap.draw(_sourceBuffer.graphic.bitmap, m, new ColorTransform(0, 0, 0, 2));
		}
		_targetBuffer.graphic.bitmap.threshold(_tempBuffer.graphic.bitmap, _tempBuffer.graphic.bitmap.rect, _zeroPoint, '>', _shineThreshold << 16, _shineOpacity << 24 | _shineColour, 0x00FF0000, false);
		_fixThresholdBlackAlpha(_targetBuffer, _shineColour);
		#end
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
		_highlightMatrix = null;
	}
}