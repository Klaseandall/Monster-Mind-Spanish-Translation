package poke.kecl;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;

/**
 * Sprites and animations for Kecleon, when they appear during Smeargle's
 * puzzles.
 *
 * (And also for the super-secret Kecleon sex scene which you can only see if
 * you are a $10 Patreon sponsor)
 */
class KecleonWindow extends PokeWindow
{
	private static var BOUNCE_DURATION:Float = 6.5;

	public var _tail:BouncySprite;
	public var _arms0:BouncySprite;
	public var _torso0:BouncySprite;
	public var _torso1:BouncySprite;
	public var _arms1:BouncySprite;
	public var _underwear:BouncySprite;

	public function new(X:Float=0, Y:Float=0, Width:Int=248, Height:Int = 349)
	{
		super(X, Y, Width, Height);
		_prefix = "kecl";
		_name = "Kecleon";
		_victorySound = AssetPaths.sand__mp3;
		add(new FlxSprite( -54, -54, AssetPaths.kecleon_bg__png));

		var cushion0:BouncySprite = new BouncySprite( -54, -54, 0, BOUNCE_DURATION, 0);
		cushion0.loadGraphic(AssetPaths.kecleon_cushion0__png);
		add(cushion0);

		var cushion1:BouncySprite = new BouncySprite( -54, -54, 1, BOUNCE_DURATION, 0);
		cushion1.loadGraphic(AssetPaths.kecleon_cushion1__png);
		add(cushion1);

		_tail = new BouncySprite( -54, -54, 1, BOUNCE_DURATION, 0.05);
		_tail.loadGraphic(AssetPaths.kecleon_tail__png);
		addPart(_tail);

		_arms0 = new BouncySprite( -54, -54, 3, BOUNCE_DURATION, 0.15);
		_arms0.loadGraphic(AssetPaths.kecleon_arms0__png);
		addPart(_arms0);

		_torso0 = new BouncySprite( -54, -54, 1, BOUNCE_DURATION, 0.05);
		_torso0.loadGraphic(AssetPaths.kecleon_torso0__png);
		addPart(_torso0);

		_torso1 = new BouncySprite( -54, -54, 2, BOUNCE_DURATION, 0.10);
		_torso1.loadGraphic(AssetPaths.kecleon_torso1__png);
		addPart(_torso1);

		_arms1 = new BouncySprite( -54, -54, 3, BOUNCE_DURATION, 0.15);
		_arms1.loadGraphic(AssetPaths.kecleon_arms1__png);
		addPart(_arms1);

		_head = new BouncySprite( -54, -54, 4, BOUNCE_DURATION, 0.20);
		_head.loadGraphic(AssetPaths.kecleon_head__png, true, 356, 266);
		_head.animation.add("default", slowBlinkyAnimation([0, 1], [2]), 3);
		_head.animation.play("default");
		addPart(_head);

		_underwear = new BouncySprite( -54, -54, 1, BOUNCE_DURATION, 0.05);
		_underwear.loadGraphic(KecleonResource.undies);
		addPart(_underwear);
	}

	override public function destroy():Void
	{
		super.destroy();

		_tail = FlxDestroyUtil.destroy(_tail);
		_arms0 = FlxDestroyUtil.destroy(_arms0);
		_torso0 = FlxDestroyUtil.destroy(_torso0);
		_torso1 = FlxDestroyUtil.destroy(_torso1);
		_arms1 = FlxDestroyUtil.destroy(_arms1);
		_underwear = FlxDestroyUtil.destroy(_underwear);
	}
}