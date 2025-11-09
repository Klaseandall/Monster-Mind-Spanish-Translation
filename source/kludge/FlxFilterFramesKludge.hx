package kludge;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFilterFrames;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.graphics.frames.FlxFramesCollection.FlxFrameCollectionType;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import openfl.filters.BitmapFilter;

/**
 * A workaround for a bug where applying a filter wipes out a sprite's offsets
 * 
 * http://forum.haxeflixel.com/topic/179/i-don-t-understand-the-change-from-flxspritefilter-to-flxfilterframes
 */
class FlxFilterFramesKludge extends FlxFilterFrames
{
	public var secretOffset:FlxPoint = new FlxPoint();

	private function new(sourceFrames:FlxFramesCollection, widthInc:Int = 0, heightInc:Int = 0, ?filters:Array<BitmapFilter>)
	{
		super(sourceFrames, widthInc, heightInc, filters);
	}

	public static function fromFrames(frames:FlxFramesCollection, widthInc:Int = 0, heightInc:Int = 0, ?filters:Array<BitmapFilter>):FlxFilterFramesKludge
	{
		return new FlxFilterFramesKludge(frames, widthInc, heightInc, filters);
	}

	override public function applyToSprite(spr:FlxSprite, saveAnimations:Bool = false, updateFrames:Bool = false):Void
	{
		super.applyToSprite(spr, saveAnimations, updateFrames);
		spr.offset.set(secretOffset.x, secretOffset.y);
	}
}