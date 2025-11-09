package;
import flixel.FlxSprite;

/**
 * A shadow for an object, which mirrors that object's X and Y movements
 *
 * Also includes some specific kludges related to bug shadows
 */
class Shadow extends FlxSprite
{
	private var _parent:FlxSprite;
	private static var _critterAssetsKey:String = "assets/images/critter-bodies";
	// if the shadow's target is on a platform, groundZ will change and the shadow will be drawn differently
	public var groundZ:Float = 0;

	public function new()
	{
		super();
		loadGraphic(AssetPaths.shadow__png);
	}

	public function setParent(Parent:FlxSprite):Void
	{
		_parent = Parent;
	}

	public function hasParent(Parent:FlxSprite):Bool
	{
		return _parent == Parent;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (!_parent.exists)
		{
			kill();
			return;
		}
		if (_parent.graphic.assetsKey != null && _parent.graphic.assetsKey.substring(0, _critterAssetsKey.length) == _critterAssetsKey &&
		(_parent.animation.frameIndex == 1
		|| _parent.animation.frameIndex == 88
		|| _parent.animation.frameIndex == 89
		|| _parent.animation.frameIndex == 90
		|| _parent.animation.frameIndex == 91))
		{
			// shadows drop a little when critters are picked up
			setPosition(_parent.x + _parent.width / 2 - width / 2, _parent.y + _parent.height + 6 - groundZ);
		}
		else {
			setPosition(_parent.x + _parent.width / 2 - width / 2, _parent.y + _parent.height - 4 - groundZ);
		}
		visible = _parent.visible;
	}
}