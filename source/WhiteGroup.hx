package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import openfl.display.BitmapData;
import openfl.geom.ColorTransform;

/**
 * An FlxGroup extension which renders all of its children, but masks them to
 * be white. Useful for glowy/blinky effects
 */
class WhiteGroup extends FlxGroup implements CustomDrawnFlxGroup
{
	// Buffer which this group is rendered to, prior to rendering it to the camera
	private var _groupBuffer:FlxSprite;
	
	public var _whiteness:Float = 1.0;

    public function new()
    {
		super();
		_groupBuffer = new FlxSprite(0, 0, new BitmapData(FlxG.camera.width, FlxG.camera.height, true, 0x00));
    }
	
	override public function draw():Void {
		customDrawToBuffer().draw();
	}

	public function customDrawToBuffer():FlxSprite
	{
		FlxSpriteUtil.fill(_groupBuffer, FlxColor.TRANSPARENT);
		
		#if flash
		PixelFilterUtils.swapCameraBuffer(_groupBuffer);
		super.draw();
		PixelFilterUtils.swapCameraBuffer(_groupBuffer);
		#else
		PixelFilterUtils.drawToBuffer(_groupBuffer, this);
		#end
		
		_groupBuffer.graphic.bitmap.colorTransform(_groupBuffer.graphic.bitmap.rect, new ColorTransform(1 - _whiteness, 1 - _whiteness, 1 - _whiteness, 1, 255 * _whiteness, 255 * _whiteness, 255 * _whiteness));
		_groupBuffer.dirty = true;
		
		return _groupBuffer;
     }
	 
	 public function addTeleparticles(minX:Float, minY:Float, maxX:Float, maxY:Float, particleCount:Int):Void {
		var itemY = minY;
		var increment = Math.max(1, (maxY - minY) / particleCount);
		while (itemY < maxY) {
			var newItem:FlxParticle = new FlxParticle();
			newItem.alphaRange.set(1, 0.5);
			newItem.lifespan = FlxG.random.float(0.25, 0.75);
			var size:Int = FlxG.random.int(4, 8);
			newItem.makeGraphic(size, size);
			newItem.x = FlxG.random.float(minX, maxX);
			newItem.y = itemY;
			newItem.velocity.x = FlxG.random.sign() * (2400 / size);
			newItem.exists = true;
			add(newItem);
			
			itemY += increment;
		}
	 }
	 
	 override public function destroy():Void {
		 super.destroy();
		 
		 _groupBuffer = FlxDestroyUtil.destroy(_groupBuffer);
	 }
}