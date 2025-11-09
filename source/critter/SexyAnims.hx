package critter;
import critter.Critter;
import flixel.FlxG;
import flixel.math.FlxPoint;
import kludge.BetterFlxRandom;
import flixel.util.FlxDirectionFlags;

/**
 * The bugs in the game have different sexual animations they can do. Some of
 * these animations are complex and include things like a critter waggling his
 * rump alluringly; several critters racing into position, and taking turns
 * fucking him
 *
 * This class includes all of the logic for the sexy bug activities
 */
class SexyAnims
{
	/*
	 * When two bugs start having sex, they're linked -- picking up one bug
	 * will interrupt the other.
	 *
	 * This is important, otherwise you might absent-mindedly be solving a
	 * puzzle and you notice another bug having sex with the air.
	 */
	public static var critterLinks:Map<Critter, Array<Critter>> = new Map<Critter, Array<Critter>>();

	public function new()
	{

	}

	public static function addAnims(critter:Critter)
	{
		{
			var animName:String = "sexy-jackoff";
			if (critter.isMale())
			{
				critter._headSprite.animation.add(animName, [
													  48, 49, 49, 48, 48, 49,
													  48, 48, 49, 48, 48, 48,
													  48, 49, 49, 48, 48, 49,
													  49, 48, 49, 49, 49, 49,
													  48, 49, 49, 49, 48, 48,

													  49, 48, 48, 48, 48, 49,
													  48, 48, 49, 48, 49, 49,
													  49, 48, 48, 49, 49, 48,
													  51, 51, 51, 51, 50, 51,
													  51, 51, 51, 50, 50, 51,

													  51, 51, 51, 51, 50, 51,
													  51, 51, 51, 50, 50, 51,
													  51, 51, 49, 50, 48, 49,
													  48, 48, 49, 48, 49, 49,
													  49, 48, 48, 49, 49, 48,
												  ], Critter._FRAME_RATE, false);

				critter._bodySprite.animation.add(animName, [
													  32, 32, 32, 33, 33, 33,
													  32, 32, 32, 33, 33, 33,
													  32, 32, 32, 33, 33, 33,
													  32, 32, 32, 33, 33, 33,
													  32, 32, 33, 33, 32, 32,

													  33, 33, 32, 32, 33, 33,
													  32, 32, 33, 33, 32, 32,
													  33, 33, 32, 32, 33, 33,
													  32, 33, 32, 33, 32, 33,
													  32, 33, 32, 33, 32, 33,

													  32, 33, 32, 32, 33, 33,
													  32, 32, 32, 32, 32, 32,
													  32, 32, 32, 32, 32, 32,
													  32, 32, 32, 32, 32, 32,
													  32, 32, 32, 32, 32, 32,
												  ], Critter._FRAME_RATE, false);

				critter._frontBodySprite.animation.add(animName, [
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,

						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,

						34, 35, 36, 37, 2, 2,
						34, 35, 36, 37, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
													   ], Critter._FRAME_RATE, true);
			}
			else
			{
				critter._headSprite.animation.add(animName, [
													  48, 49, 49, 48, 48, 49,
													  48, 48, 49, 48, 48, 48,
													  48, 49, 49, 48, 48, 49,
													  49, 48, 49, 49, 49, 49,
													  48, 49, 49, 49, 48, 48,

													  49, 48, 48, 48, 48, 49,
													  48, 48, 49, 48, 49, 49,
													  49, 48, 48, 49, 49, 48,
													  51, 51, 51, 51, 50, 51,
													  51, 51, 51, 50, 50, 51,

													  51, 51, 51, 51, 50, 51,
													  51, 51, 51, 50, 50, 51,
													  51, 51, 49, 50, 48, 49,
													  48, 48, 49, 48, 49, 49,
													  49, 48, 48, 49, 49, 48,
												  ], Critter._FRAME_RATE, false);

				critter._bodySprite.animation.add(animName, [
													  32, 32, 32, 31, 31, 31,
													  32, 32, 32, 31, 31, 31,
													  32, 32, 32, 31, 31, 31,
													  32, 32, 32, 31, 31, 31,
													  32, 32, 31, 31, 32, 32,

													  31, 31, 32, 32, 31, 31,
													  32, 32, 31, 31, 32, 32,
													  31, 31, 32, 32, 31, 31,
													  32, 31, 32, 31, 32, 31,
													  32, 31, 32, 31, 32, 31,

													  32, 31, 32, 32, 31, 31,
													  32, 32, 32, 32, 32, 32,
													  32, 32, 32, 32, 32, 32,
													  33, 33, 33, 33, 33, 33,
													  33, 33, 33, 33, 33, 33,
												  ], Critter._FRAME_RATE, false);

				critter._frontBodySprite.animation.add(animName, [
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,

						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,

						30, 38, 39, 2, 2, 30,
						38, 39, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
													   ], Critter._FRAME_RATE, true);
			}
		}

		{
			var animName:String = "sexy-jackoff-short";
			if (critter.isMale())
			{
				critter._headSprite.animation.add(animName, [
													  48, 49, 49, 48, 51, 50,
													  51, 51, 51, 51, 50, 51,
													  51, 51, 51, 50, 50, 51,

													  51, 51, 51, 51, 50, 51,
													  51, 51, 49, 50, 48, 49,
													  49, 48, 48, 49, 49, 48,
												  ], Critter._FRAME_RATE, false);

				critter._bodySprite.animation.add(animName, [
													  33, 33, 32, 32, 33, 33,
													  32, 33, 32, 33, 32, 33,
													  32, 33, 32, 33, 32, 33,

													  32, 33, 32, 32, 33, 33,
													  32, 32, 32, 32, 32, 32,
													  32, 32, 32, 32, 32, 32,
												  ], Critter._FRAME_RATE, false);

				critter._frontBodySprite.animation.add(animName, [
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,

						34, 35, 36, 37, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
													   ], Critter._FRAME_RATE, true);
			}
			else
			{
				critter._headSprite.animation.add(animName, [
													  48, 49, 49, 48, 51, 50,
													  51, 51, 51, 51, 50, 51,
													  51, 51, 51, 50, 50, 51,

													  51, 51, 51, 51, 50, 51,
													  51, 51, 49, 50, 48, 49,
													  49, 48, 48, 49, 49, 48,
												  ], Critter._FRAME_RATE, false);

				critter._bodySprite.animation.add(animName, [
													  31, 31, 32, 32, 31, 31,
													  32, 31, 32, 31, 32, 31,
													  32, 31, 32, 31, 32, 31,

													  32, 31, 32, 32, 31, 31,
													  32, 32, 32, 32, 33, 33,
													  33, 33, 33, 33, 33, 33,
												  ], Critter._FRAME_RATE, false);

				critter._frontBodySprite.animation.add(animName, [
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,

						30, 38, 39, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
													   ], Critter._FRAME_RATE, true);
			}
		}

		{
			var animName:String = "sexy-jackoff-long";
			if (critter.isMale())
			{
				critter._headSprite.animation.add(animName, [
													  48, 48, 49, 49, 49, 49,
													  49, 48, 49, 49, 48, 49,
													  49, 49, 49, 48, 49, 48,
													  48, 49, 49, 48, 49, 48,
													  49, 48, 49, 49, 49, 48,
													  48, 48, 48, 51, 51, 51,
													  51, 50, 51, 51, 50, 51,
													  51, 51, 51, 48, 49, 49,
													  49, 49, 48, 49, 48, 48,

													  48, 48, 49, 48, 49, 49,
													  49, 48, 48, 48, 48, 48,
													  49, 48, 48, 49, 49, 49,
													  49, 49, 48, 49, 48, 48,
													  49, 48, 48, 50, 51, 50,
													  51, 50, 51, 51, 51, 50,
													  50, 50, 50, 51, 50, 50,
													  50, 50, 51, 49, 49, 49,
													  48, 49, 48, 49, 49, 49,

													  49, 49, 48, 48, 49, 49,
													  49, 49, 48, 48, 48, 48,
													  48, 49, 48, 49, 49, 49,
													  49, 48, 49, 50, 51, 50,
													  51, 50, 51, 51, 51, 50,
													  50, 50, 50, 51, 50, 50,
													  50, 50, 51, 50, 51, 51,
													  51, 50, 50, 50, 50, 50,

													  51, 51, 51, 50, 50, 51,
													  51, 51, 51, 51, 50, 51,
													  51, 51, 51, 50, 50, 51,
													  51, 51, 49, 50, 48, 49,
													  48, 48, 49, 48, 49, 49,
													  49, 48, 48, 49, 49, 48,
												  ], Critter._FRAME_RATE, false);

				critter._bodySprite.animation.add(animName, [
													  32, 32, 32, 33, 33, 33,
													  32, 32, 32, 33, 33, 33,
													  32, 32, 32, 33, 33, 33,
													  32, 32, 33, 33, 32, 32,
													  33, 33, 32, 32, 33, 33,
													  32, 32, 33, 33, 32, 32,
													  33, 32, 33, 32, 33, 32, // fast...
													  32, 32, 32, 32, 32, 32, // pause...
													  32, 32, 32, 32, 32, 32,

													  33, 33, 33, 32, 32, 32,
													  33, 33, 32, 32, 33, 33,
													  32, 32, 33, 33, 32, 32,
													  33, 33, 32, 32, 33, 33,
													  32, 32, 33, 33, 32, 32,
													  33, 32, 33, 32, 33, 32, // fast...
													  33, 32, 33, 32, 32, 32,
													  32, 32, 32, 32, 32, 32, // pause...
													  32, 32, 32, 32, 32, 32,

													  33, 33, 32, 32, 33, 33,
													  32, 32, 33, 33, 32, 32,
													  33, 33, 32, 32, 33, 33,
													  32, 32, 33, 33, 32, 32,
													  33, 32, 33, 32, 33, 32, // fast...
													  33, 32, 33, 32, 33, 32,
													  33, 32, 33, 32, 33, 32,
													  33, 32, 33, 32, 33, 32,

													  32, 33, 32, 32, 33, 33, // cum...
													  32, 32, 32, 32, 32, 32,
													  32, 32, 32, 32, 32, 32,
													  32, 32, 32, 32, 32, 32,
													  32, 32, 32, 32, 32, 32,
													  32, 32, 32, 32, 32, 32,
												  ], Critter._FRAME_RATE, false);

				critter._frontBodySprite.animation.add(animName, [
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,

						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,

						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,

						34, 35, 36, 37, 2, 34,
						35, 36, 37, 2, 34, 35,
						36, 37, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
													   ], Critter._FRAME_RATE, true);
			}
			else
			{
				critter._headSprite.animation.add(animName, [
													  48, 48, 49, 49, 49, 49,
													  49, 48, 49, 49, 48, 49,
													  49, 49, 49, 48, 49, 48,
													  48, 49, 49, 48, 49, 48,
													  49, 48, 49, 49, 49, 48,
													  48, 48, 48, 51, 51, 51,
													  51, 50, 51, 51, 50, 51,
													  51, 51, 51, 48, 49, 49,
													  49, 48, 48, 49, 49, 49,

													  48, 48, 49, 48, 49, 49,
													  49, 48, 48, 48, 48, 48,
													  49, 48, 48, 49, 49, 49,
													  49, 49, 48, 49, 48, 48,
													  49, 48, 48, 50, 51, 50,
													  51, 50, 51, 51, 51, 50,
													  50, 50, 50, 51, 50, 50,
													  50, 50, 51, 49, 49, 49,
													  48, 49, 48, 49, 49, 49,

													  49, 49, 48, 48, 49, 49,
													  49, 49, 48, 48, 48, 48,
													  48, 49, 48, 49, 49, 49,
													  49, 48, 49, 50, 51, 50,
													  51, 50, 51, 51, 51, 50,
													  50, 50, 50, 51, 50, 50,
													  50, 50, 51, 50, 51, 51,
													  51, 50, 50, 50, 50, 50,

													  51, 51, 51, 50, 50, 51,
													  51, 51, 51, 51, 50, 51,
													  51, 51, 51, 50, 50, 51,
													  51, 51, 49, 50, 48, 49,
													  48, 48, 49, 48, 49, 49,
													  49, 48, 48, 49, 49, 48,
												  ], Critter._FRAME_RATE, false);

				critter._bodySprite.animation.add(animName, [
													  32, 32, 32, 31, 31, 31,
													  32, 32, 32, 31, 31, 31,
													  32, 32, 32, 31, 31, 31,
													  32, 32, 31, 31, 32, 32,
													  31, 31, 32, 32, 31, 31,
													  32, 32, 31, 31, 32, 32,
													  31, 32, 31, 32, 31, 32, // fast...
													  32, 32, 32, 32, 32, 32, // pause...
													  32, 32, 32, 32, 32, 32,

													  31, 31, 31, 32, 32, 32,
													  31, 31, 32, 32, 31, 31,
													  32, 32, 31, 31, 32, 32,
													  31, 31, 32, 32, 31, 31,
													  32, 32, 31, 31, 32, 32,
													  31, 32, 31, 32, 31, 32, // fast...
													  31, 32, 31, 32, 32, 32,
													  32, 32, 32, 32, 32, 32, // pause...
													  32, 32, 32, 32, 32, 32,

													  31, 31, 32, 32, 31, 31,
													  32, 32, 31, 31, 32, 32,
													  31, 31, 32, 32, 31, 31,
													  32, 32, 31, 31, 32, 32,
													  31, 32, 31, 32, 31, 32, // fast...
													  31, 32, 31, 32, 31, 32,
													  31, 32, 31, 32, 31, 32,
													  31, 32, 31, 32, 31, 32,

													  32, 31, 32, 32, 31, 31, // cum...
													  32, 32, 32, 32, 32, 32,
													  32, 32, 32, 32, 32, 32,
													  33, 33, 33, 33, 33, 33,
													  33, 33, 33, 33, 33, 33,
													  33, 33, 33, 33, 33, 33,
												  ], Critter._FRAME_RATE, false);

				critter._frontBodySprite.animation.add(animName, [
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,

						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,

						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,

						30, 38, 39, 2, 30, 38,
						39, 2, 2, 30, 38, 39,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
													   ], Critter._FRAME_RATE, true);
			}
		}

		{
			var animName:String = "sexy-jackoff-dry";
			if (critter.isMale())
			{
				critter._headSprite.animation.add(animName, [
													  48, 49, 49, 48, 48, 49,
													  48, 48, 49, 48, 48, 48,
													  48, 49, 49, 48, 48, 49,
													  49, 48, 49, 49, 49, 49,
													  48, 49, 49, 49, 48, 48,

													  49, 48, 48, 48, 48, 49,
													  48, 48, 49, 48, 49, 49,
													  49, 48, 48, 49, 49, 48,
													  51, 51, 51, 51, 50, 51,
													  51, 51, 51, 50, 50, 51,

													  51, 51, 49, 50, 48, 49,
													  48, 48, 49, 48, 49, 49,
													  49, 48, 48, 49, 49, 48,
												  ], Critter._FRAME_RATE, false);

				critter._bodySprite.animation.add(animName, [
													  32, 32, 32, 33, 33, 33,
													  32, 32, 32, 33, 33, 33,
													  32, 32, 32, 33, 33, 33,
													  32, 32, 32, 33, 33, 33,
													  32, 32, 33, 33, 32, 32,

													  33, 33, 32, 32, 33, 33,
													  32, 32, 33, 33, 32, 32,
													  33, 33, 32, 32, 33, 33,
													  32, 33, 32, 33, 32, 33,
													  32, 33, 32, 33, 32, 33,

													  32, 32, 32, 32, 32, 32,
													  32, 32, 32, 32, 32, 32,
													  32, 32, 32, 32, 32, 32,
												  ], Critter._FRAME_RATE, false);

				critter._frontBodySprite.animation.add(animName, [
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,

						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,

						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
													   ], Critter._FRAME_RATE, true);
			}
			else
			{
				critter._headSprite.animation.add(animName, [
													  48, 49, 49, 48, 48, 49,
													  48, 48, 49, 48, 48, 48,
													  48, 49, 49, 48, 48, 49,
													  49, 48, 49, 49, 49, 49,
													  48, 49, 49, 49, 48, 48,

													  49, 48, 48, 48, 48, 49,
													  48, 48, 49, 48, 49, 49,
													  49, 48, 48, 49, 49, 48,
													  51, 51, 51, 51, 50, 51,
													  51, 51, 51, 50, 50, 51,

													  51, 51, 49, 50, 48, 49,
													  48, 48, 49, 48, 49, 49,
													  49, 48, 48, 49, 49, 48,
												  ], Critter._FRAME_RATE, false);

				critter._bodySprite.animation.add(animName, [
													  32, 32, 32, 31, 31, 31,
													  32, 32, 32, 31, 31, 31,
													  32, 32, 32, 31, 31, 31,
													  32, 32, 32, 31, 31, 31,
													  32, 32, 31, 31, 32, 32,

													  31, 31, 32, 32, 31, 31,
													  32, 32, 31, 31, 32, 32,
													  31, 31, 32, 32, 31, 31,
													  32, 31, 32, 31, 32, 31,
													  32, 31, 32, 31, 32, 31,

													  32, 32, 32, 32, 32, 32,
													  33, 33, 33, 33, 33, 33,
													  33, 33, 33, 33, 33, 33,
												  ], Critter._FRAME_RATE, false);

				critter._frontBodySprite.animation.add(animName, [
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,

						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,

						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
						2, 2, 2, 2, 2, 2,
													   ], Critter._FRAME_RATE, true);
			}
		}
	}

	public static function scheduleJizzStamp(critter:Critter)
	{
		var animName:String = critter._bodySprite.animation.name;
		if (animName == "sexy-jackoff")
		{
			if (critter.isMale())
			{
				critter._eventStack.addEvent({time:critter._eventStack._time + 10.4, callback:critter.eventJizzStamp, args:[ -28 * (critter._bodySprite.flipX ? -1 : 1), 6]});
			}
			else
			{
				critter._eventStack.addEvent({time:critter._eventStack._time + 10.1, callback:critter.eventJizzStamp, args:[ -6 * (critter._bodySprite.flipX ? -1 : 1), 4]});
			}
		}
		if (animName == "sexy-jackoff-short")
		{
			if (critter.isMale())
			{
				critter._eventStack.addEvent({time:critter._eventStack._time + 3.4, callback:critter.eventJizzStamp, args:[ -28 * (critter._bodySprite.flipX ? -1 : 1), 6]});
			}
			else
			{
				critter._eventStack.addEvent({time:critter._eventStack._time + 3.1, callback:critter.eventJizzStamp, args:[ -6 * (critter._bodySprite.flipX ? -1 : 1), 4]});
			}
		}
		if (animName == "sexy-jackoff-long")
		{
			if (critter.isMale())
			{
				critter._eventStack.addEvent({time:critter._eventStack._time + 26.4, callback:critter.eventJizzStamp, args:[ -28 * (critter._bodySprite.flipX ? -1 : 1), 6]});
			}
			else
			{
				critter._eventStack.addEvent({time:critter._eventStack._time + 26.1, callback:critter.eventJizzStamp, args:[ -6 * (critter._bodySprite.flipX ? -1 : 1), 4]});
			}
		}
	}

	public static function playGlobalAnim(puzzleState:LevelState, animName:String)
	{
		puzzleState._globalSexyTimer = LevelState.GLOBAL_SEXY_FREQUENCY * FlxG.random.float(0.9, 1.11);
		if (animName == "global-sexy-multi-blowjob")
		{
			var botCritter:Critter;
			var topCritters:Array<Critter>;
			var watchCritters:Array<Critter> = [];
			{
				var critters:Array<Critter> = puzzleState.findIdleCritters(FlxG.random.getObject([3, 4, 5, 6, 7, 8], [7, 6, 5, 4, 3, 2]));
				if (critters.length < 3)
				{
					// couldn't find three
					return;
				}
				botCritter = critters.splice(0, 1)[0];
				topCritters = critters;

				var i = topCritters.length - 1;
				while (i > 1)
				{
					if (FlxG.random.bool())
					{
						watchCritters.push(topCritters.splice(i, 1)[0]);
					}
					i--;
				}
			}

			immobilizeCritters([botCritter], animName);
			immobilizeCritters(topCritters, animName);
			immobilizeCritters(watchCritters, animName);

			var sexyMultiBlowJob = new SexyMultiBlowJob(topCritters, botCritter, watchCritters);
			sexyMultiBlowJob.go();
		}
		if (animName == "global-sexy-doggy-then-blowjob")
		{
			// a critter fucks another one doggy style, then asks for a blow job. its only smellz?
			var botCritter:Critter = null;
			var topCritter:Critter = null;
			{
				var farCritters:Array<Critter> = puzzleState.findIdleCritters(5); // find 5; pick 2 that are an appropriate distance for jumping
				if (farCritters.length < 2)
				{
					// couldn't find two
					return;
				}
				for (farCritter in farCritters)
				{
					if (farCritter.isMale())
					{
						topCritter = farCritter;
						break;
					}
				}
				if (topCritter == null)
				{
					// no males?
					return;
				}
				farCritters.remove(topCritter);
				var bestDist:Float = 9999;
				topCritter = farCritters[0];
				for (farCritter in farCritters)
				{
					var dist:Float = farCritter._bodySprite.getPosition().distanceTo(topCritter._bodySprite.getPosition());
					if (dist > SexyRimming.JUMP_DIST + 40 && dist < bestDist)
					{
						bestDist = dist;
						botCritter = farCritter;
					}
				}
				if (bestDist == 9999)
				{
					// couldn't find two which were a good distance
					return;
				}
			}
			immobilizeAndLinkCritters([topCritter, botCritter], animName);

			var _eventTime:Float = 0;
			{
				var critters:Array<Critter> = [topCritter, botCritter];
				immobilizeAndLinkCritters(critters, animName);

				var sexyDoggy:SexyDoggy = new SexyDoggy(topCritter, botCritter);
				var sexyRimming:SexyRimming = new SexyRimming(topCritter, botCritter);
				{
					botCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.botWaggle});
					botCritter._eventStack.addEvent({time:_eventTime += 0.8, callback:sexyRimming.botWait});
				}

				_eventTime = 0.4;
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyDoggy.runToJump});
				topCritter._eventStack.addEvent({time:_eventTime += sexyDoggy.getExpectedRunToJumpDuration(), callback:sexyDoggy.jumpIntoPositionAndStartDoggy});
				topCritter._eventStack.addEvent({time:_eventTime += sexyRimming.getExpectedJumpDuration() + 0.2, callback:sexyDoggy.topPenetrate, args:[0.2]});
				botCritter._eventStack.addEvent({time:_eventTime, callback:sexyDoggy.botEyesClosed});

				topCritter._eventStack.addEvent({time:_eventTime += 1.5, callback:sexyDoggy.topHump, args:[1, 2, false]});
				botCritter._eventStack.addEvent({time:_eventTime + 0.66, callback:sexyDoggy.botEyesOpen, args:[1.5]});
				var spankiness:Int = FlxG.random.int( -30, 30);
				topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, false, FlxG.random.bool(100 + spankiness)]});
				topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[4, 2, false, FlxG.random.bool(30 + spankiness)]});
				topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, false, FlxG.random.bool(45 + spankiness)]});
				var tenacity:Float = FlxG.random.float(0, 0.9);

				while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
				{
					// go again?
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[4, 2, false, FlxG.random.bool(60 + spankiness)]});
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, false, FlxG.random.bool(75 + spankiness)]});
				}
				topCritter._eventStack.addEvent({time:_eventTime += 2, callback:sexyDoggy.topHump, args:[5, 2, true]});
				botCritter._eventStack.addEvent({time:_eventTime + 1.66, callback:sexyDoggy.botOrgasm});
				topCritter._eventStack.addEvent({time:_eventTime += 4, callback:(FlxG.random.bool(80) ? sexyDoggy.topOrgasmPullOut : sexyDoggy.topOrgasm)});
				topCritter._eventStack.addEvent({time:_eventTime += 6.5, callback:sexyDoggy.topAlmostDone});
			}

			{
				var sexyBlowJob:SexyBlowJob = new SexyBlowJob(topCritter, botCritter);
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.refresh});
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topSitBack});
				botCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.botDoneForNowRunAway});
				topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(2, 5), callback:sexyBlowJob.topEyesOpen});
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topPoint});

				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0.5, 2.0), callback:sexyBlowJob.botNotice});

				var whichEnd:Int = 0;
				if (botCritter.isMale())
				{
					// definitely anal sex; more objectionable outcomes
					whichEnd = FlxG.random.getObject([0, 1, 2, 3, 4], [0.4, 0.1, 0.2, 0.2, 0.1]);
				}
				else
				{
					// maybe anal sex; fewer objectionable outcomes
					whichEnd = FlxG.random.getObject([0, 1, 2, 3, 4], [0.08, 0.02, 0.04, 0.18, 0.68]);
				}

				if (whichEnd == 0)
				{
					// run away
					botCritter._eventStack.addEvent({time:_eventTime, callback:eventUnlinkCritters, args:[[topCritter, botCritter]]});
					botCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.botDoneRunFarAway});
					topCritter._eventStack.addEvent({time:_eventTime += 1.0, callback:sexyBlowJob.topDone});
				}
				else if (whichEnd == 1)
				{
					// try, but recoil in disgust and vomit; and top runs away
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(1, 3), callback:sexyBlowJob.botRunIntoPositionAndBlow});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0.5, 3.0), callback:sexyBlowJob.botSitUp});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0.5, 5.0), callback:eventUnlinkCritters, args:[[topCritter, botCritter]]});
					topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.botDone});
					topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topDoneRunFarAway});
					botCritter._eventStack.addEvent({time:_eventTime, callback:botCritter.eventPlayAnim, args:["idle-vomit"]});
				}
				else if (whichEnd == 2)
				{
					// try, but recoil in disgust
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(1, 3), callback:sexyBlowJob.botRunIntoPositionAndBlow});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0.5, 3.0), callback:sexyBlowJob.botSitUp});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 5), callback:eventUnlinkCritters, args:[[topCritter, botCritter]]});
					botCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.botDoneRunAway});
					topCritter._eventStack.addEvent({time:_eventTime += 1.0, callback:sexyBlowJob.topDone});
				}
				else if (whichEnd == 3)
				{
					// recoil, but fight through it
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(1, 3), callback:sexyBlowJob.botRunIntoPositionAndBlow});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0.5, 3.0), callback:sexyBlowJob.botSitUp});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(4, 6), callback:sexyBlowJob.botBj});

					_eventTime += FlxG.random.float(4, 12);
					var tenacity:Float = FlxG.random.float(0, 0.9);
					while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
					{
						botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 9), callback:sexyBlowJob.botSitUp});
						topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topJerkSelf});
						botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(1.5, 2.5), callback:sexyBlowJob.botBj});
						topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topSitBack});
					}

					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(4, 8), callback:sexyBlowJob.topHandOnHead});
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 3.0), callback:sexyBlowJob.topEyesClosed});
					// squirt
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2.0), callback:sexyBlowJob.botSitUp});
					topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topOrgasm});

					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 5), callback:sexyBlowJob.topEyesHalfOpen});
					_eventTime += FlxG.random.float(0, 2);

					botCritter._eventStack.addEvent({time:_eventTime, callback:eventUnlinkCritters, args:[[topCritter, botCritter]]});
					botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.botDoneRunAway});
					topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.topDone});
					topCritter._eventStack.addEvent({time:_eventTime, callback:topCritter.eventPlayAnim, args:[FlxG.random.getObject(["idle-happy0", "idle-happy1", "idle-happy2"])]});
				}
				else if (whichEnd == 4)
				{
					// suck that dick like a champ
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(1, 3), callback:sexyBlowJob.botRunIntoPositionAndBlow});
					_eventTime += FlxG.random.float(4, 12);
					var tenacity:Float = FlxG.random.float(0, 0.9);
					while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
					{
						topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(2, 4), callback:sexyBlowJob.topHandOnHead});
						topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2), callback:sexyBlowJob.topEyesClosed});
						topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 8), callback:sexyBlowJob.topHandOffHead});
						topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topEyesHalfOpen});
					}

					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(4, 8), callback:sexyBlowJob.topHandOnHead});
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 3.0), callback:sexyBlowJob.topEyesClosed});
					// swallow it
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2.0), callback:sexyBlowJob.botSwallow});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 7), callback:sexyBlowJob.botSitUp});
					botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.botDoneRunAway});
					topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.topDone});
					topCritter._eventStack.addEvent({time:_eventTime, callback:topCritter.eventPlayAnim, args:[FlxG.random.getObject(["idle-happy0", "idle-happy1", "idle-happy2"])]});
				}
			}
		}
		if (animName == "global-sexy-blowjob-then-doggy")
		{
			// a critter gives another one a blow job, then gets fucked doggy style
			var topCritter:Critter;
			var botCritter:Critter;
			{
				var critters:Array<Critter> = puzzleState.findIdleCritters(2);
				if (critters.length < 2)
				{
					// couldn't find two
					return;
				}
				topCritter = critters[0];
				botCritter = critters[1];
			}
			immobilizeAndLinkCritters([topCritter, botCritter], animName);
			var _eventTime:Float = 0;
			{
				var sexyBlowJob:SexyBlowJob = new SexyBlowJob(topCritter, botCritter);
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topPoint});
				botCritter._eventStack.addEvent({time:_eventTime += 0.4, callback:sexyBlowJob.botRunIntoPositionAndBlow});
				_eventTime += sexyBlowJob.getExpectedBotRunDuration();

				_eventTime += FlxG.random.float(4, 12);

				var tenacity:Float = FlxG.random.float(0, 0.7);
				while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
				{
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(2, 4), callback:sexyBlowJob.topHandOnHead});
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2), callback:sexyBlowJob.topEyesClosed});
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 8), callback:sexyBlowJob.topHandOffHead});
					topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topEyesHalfOpen});
				}

				botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.topJerkSelf});
			}

			{
				var sexyDoggy:SexyDoggy = new SexyDoggy(topCritter, botCritter);
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyDoggy.refresh});
				topCritter._eventStack.addEvent({time:_eventTime += 0.1, callback:sexyDoggy.botLookBack});
				topCritter._eventStack.addEvent({time:_eventTime += 1.2, callback:sexyDoggy.runIntoPositionAndStartDoggy});
				topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyDoggy.topPenetrate, args:[1.5]});
				botCritter._eventStack.addEvent({time:_eventTime + 0.66, callback:sexyDoggy.botEyesClosed});
				topCritter._eventStack.addEvent({time:_eventTime += 2.5, callback:sexyDoggy.topHump, args:[1, 3, false]});
				botCritter._eventStack.addEvent({time:_eventTime + 0.66, callback:sexyDoggy.botEyesOpen, args:[1.5]});
				topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([3, 6]), callback:sexyDoggy.topHump, args:[1, 2, false]});
				topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 4, false]});
				var tenacity:Float = FlxG.random.float(0, 0.9);
				var spankiness:Int = FlxG.random.int( -60, 60);
				while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
				{
					// go again?
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, false]});
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[4, 2, false, FlxG.random.bool(30 + spankiness)]});
				}
				topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, true]});
				topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[4, 2, true, FlxG.random.bool(40 + spankiness)]});
				botCritter._eventStack.addEvent({time:_eventTime + 1.66, callback:sexyDoggy.botOrgasm});
				topCritter._eventStack.addEvent({time:_eventTime += 4, callback:(FlxG.random.bool(30) ? sexyDoggy.topOrgasmPullOut : sexyDoggy.topOrgasm)});
				topCritter._eventStack.addEvent({time:_eventTime += 6.5, callback:sexyDoggy.topAlmostDone});
				botCritter._eventStack.addEvent({time:_eventTime += 1.0, callback:sexyDoggy.botLookBack});
				topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:eventUnlinkCritters, args:[[topCritter, botCritter]]});
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyDoggy.topDone});
				botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyDoggy.botDone});
			}
		}
		if (animName == "global-sexy-mutual-masturbate-then-blowjob")
		{
			// two critters jerk off; then one blows the other
			var topCritter:Critter;
			var botCritter:Critter;
			{
				var critters:Array<Critter> = puzzleState.findIdleCritters(2);
				if (critters.length < 2)
				{
					// couldn't find two
					return;
				}
				topCritter = critters[0];
				botCritter = critters[1];
			}
			var _eventTime:Float = 0;
			immobilizeAndLinkCritters([topCritter, botCritter], animName);
			{
				// jerk off together...
				var sexyMutualMasturbate:SexyMutualMasturbate = new SexyMutualMasturbate([topCritter, botCritter]);
				_eventTime += sexyMutualMasturbate.go(false, false);
				_eventTime += 0.5;
			}

			{
				var sexyBlowJob:SexyBlowJob = new SexyBlowJob(topCritter, botCritter);
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.refresh});
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topJerkSelf});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0.4, 6), callback:sexyBlowJob.botRunIntoPositionAndJerk});
				_eventTime += 0.5;
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 9), callback:sexyBlowJob.botBj});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(4, 12), callback:sexyBlowJob.botJerkOff});

				var tenacity:Float = FlxG.random.float(0, 0.9);
				while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
				{
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 9), callback:sexyBlowJob.botBj});
					topCritter._eventStack.addEvent({time:_eventTime + FlxG.random.float(0.5, 2), callback:sexyBlowJob.topEyesClosed});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(4, 12), callback:sexyBlowJob.botJerkOff});
					topCritter._eventStack.addEvent({time:_eventTime + FlxG.random.float(0.5, 3), callback:sexyBlowJob.topEyesHalfOpen});
				}

				// cums
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topOrgasm});
				topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 5), callback:sexyBlowJob.topEyesHalfOpen});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2.0), callback:sexyBlowJob.botSitUp});

				// done
				botCritter._eventStack.addEvent({time:_eventTime, callback:eventUnlinkCritters, args:[[topCritter, botCritter]]});
				botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.botDone});
				topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.topDone});
			}
		}
		if (animName == "global-sexy-trade-blowjobs")
		{
			// a critter jerks off; another critter runs over and blows them, and the first critter returns the favor
			var botCritter:Critter;
			var topCritter:Critter;
			{
				var farCritters:Array<Critter> = puzzleState.findIdleCritters(5); // find 5; pick the closest 2
				if (farCritters.length < 2)
				{
					// couldn't find two
					return;
				}
				botCritter = farCritters.splice(0, 1)[0];
				var closestDist:Float = 1000;
				topCritter = farCritters[0];
				for (farCritter in farCritters)
				{
					var dist:Float = farCritter._bodySprite.getPosition().distanceTo(botCritter._bodySprite.getPosition());
					if (dist < closestDist)
					{
						closestDist = dist;
						topCritter = farCritter;
					}
				}
			}

			var _eventTime:Float = 0;
			{
				var sexyBlowJob:SexyBlowJob = new SexyBlowJob(topCritter, botCritter);
				immobilizeAndLinkCritters([topCritter, botCritter], animName);

				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topJerkSelf});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0.4, 6), callback:sexyBlowJob.botRunIntoPositionAndBlow});
				_eventTime += sexyBlowJob.getExpectedBotRunDuration();
				_eventTime += FlxG.random.float(4, 12);

				var tenacity:Float = FlxG.random.float(0, 0.9);

				while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
				{
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 9), callback:sexyBlowJob.botSitUp});
					topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topJerkSelf});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(1.5, 2.5), callback:sexyBlowJob.botBj});
					topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topSitBack});
				}

				topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(4, 11), callback:sexyBlowJob.topEyesClosed});
				// swallow it
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2), callback:sexyBlowJob.botSwallow});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 7), callback:sexyBlowJob.botSitUp});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2), callback:sexyBlowJob.topEyesOpen});
				botCritter._eventStack.addEvent({time:_eventTime, callback:eventUnlinkCritters, args:[[topCritter, botCritter]]});
				botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.botDoneForNowRunToSwap});
				topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.topDoneForNow});
			}

			{
				// swap critters...
				var tmpCritter:Critter = botCritter;
				botCritter = topCritter;
				topCritter = tmpCritter;
			}

			{
				var sexyBlowJob:SexyBlowJob = new SexyBlowJob(topCritter, botCritter);

				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topPoint});
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.refresh});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0.5, 2.0), callback:sexyBlowJob.botNotice});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(1, 3), callback:sexyBlowJob.botRunIntoPositionAndBlow});
				_eventTime += 0.5;

				_eventTime += FlxG.random.float(4, 12);

				var tenacity:Float = FlxG.random.float(0, 0.9);
				while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
				{
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 9), callback:sexyBlowJob.botJerkOff});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(1.5, 4.5), callback:sexyBlowJob.botBj});
				}

				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(2, 4), callback:sexyBlowJob.botJerkOff});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(2, 4), callback:sexyBlowJob.botSitUp});
				botCritter._eventStack.addEvent({time:_eventTime, callback:eventUnlinkCritters, args:[[topCritter, botCritter]]});
				botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.botDone});
				topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.topDone});
			}
		}
		if (animName == "global-sexy-blowjob-and-watersports")
		{
			// a critter runs over and gets their dick sucked, and maybe pisses in the other critter's mouth
			var botCritter:Critter;
			var topCritter:Critter;
			{
				var farCritters:Array<Critter> = puzzleState.findIdleCritters(5); // find 5; pick the closest 2
				if (farCritters.length < 2)
				{
					// couldn't find two
					return;
				}
				botCritter = farCritters.splice(0, 1)[0];
				var closestDist:Float = 1000;
				topCritter = farCritters[0];
				for (farCritter in farCritters)
				{
					var dist:Float = farCritter._bodySprite.getPosition().distanceTo(botCritter._bodySprite.getPosition());
					if (dist < closestDist)
					{
						closestDist = dist;
						topCritter = farCritter;
					}
				}
			}
			var sexyBlowJob:SexyBlowJob = new SexyBlowJob(topCritter, botCritter);
			immobilizeAndLinkCritters([topCritter, botCritter], animName);
			var _eventTime:Float = 0;
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topRunIntoPositionAndSitBack});
			botCritter._eventStack.addEvent({time:_eventTime += sexyBlowJob.getExpectedTopRunDuration() + FlxG.random.float(0, 0.7), callback:sexyBlowJob.botNotice});
			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(1, 3), callback:sexyBlowJob.startBj});

			var tenacity:Float = FlxG.random.float(0, 0.9);

			while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
			{
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 9), callback:sexyBlowJob.botSitUp});
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topJerkSelf});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(1.5, 4.5), callback:sexyBlowJob.botBj});
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topSitBack});
			}

			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(4, 11), callback:sexyBlowJob.topEyesClosed});
			// swallow it
			botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2), callback:sexyBlowJob.botSwallow});

			var wsChance:Int = 0;
			if (PlayerData.pokemonLibido >= 7)
			{
				wsChance = 70;
			}
			else if (PlayerData.pokemonLibido >= 6)
			{
				wsChance = 40;
			}
			else if (PlayerData.pokemonLibido >= 5)
			{
				wsChance = 20;
			}
			else if (PlayerData.pokemonLibido >= 4)
			{
				wsChance = 10;
			}

			if (FlxG.random.bool(wsChance))
			{
				if (FlxG.random.bool())
				{
					// variation #1; bottom critter leaves but comes back
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 7), callback:sexyBlowJob.botSitUp});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2), callback:sexyBlowJob.topEyesOpen});

					botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.botDoneForNowRunAway});
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(2, 5), callback:sexyBlowJob.topEyesHalfOpen});
					topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topPointEyesHalfOpen});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(1.0, 3.0), callback:sexyBlowJob.botNotice});
					botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.botReturnAndBj});
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 5), callback:sexyBlowJob.topEyesClosed});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 3), callback:sexyBlowJob.botSwallow});
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(10, 40), callback:sexyBlowJob.topEyesHalfOpen});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2), callback:sexyBlowJob.botSitUp});
				}
				else
				{
					// variation #2; top critter holds him in place to finish
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 9), callback:sexyBlowJob.topEyesOpen});
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 5), callback:sexyBlowJob.topEyesHalfOpen});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(1, 3), callback:sexyBlowJob.botBj});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(1, 3), callback:sexyBlowJob.topEyesClosed});
					botCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topHandOnHead});
					botCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.botSwallow});
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(10, 40), callback:sexyBlowJob.topEyesHalfOpen});
					topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topHandPatsHead});

					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 5), callback:sexyBlowJob.botSitUp});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2), callback:sexyBlowJob.topEyesOpen});
				}
			}
			else
			{
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 7), callback:sexyBlowJob.botSitUp});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2), callback:sexyBlowJob.topEyesOpen});
			}

			botCritter._eventStack.addEvent({time:_eventTime, callback:eventUnlinkCritters, args:[[topCritter, botCritter]]});
			botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.botDone});
			topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.topDone});
		}
		if (animName == "global-sexy-blowjob")
		{
			// a critter runs over and blows another critter
			var botCritter:Critter;
			var topCritter:Critter;
			{
				var farCritters:Array<Critter> = puzzleState.findIdleCritters(5); // find 5; pick the closest 2
				if (farCritters.length < 2)
				{
					// couldn't find two
					return;
				}
				botCritter = farCritters.splice(0, 1)[0];
				var closestDist:Float = 1000;
				topCritter = farCritters[0];
				for (farCritter in farCritters)
				{
					var dist:Float = farCritter._bodySprite.getPosition().distanceTo(botCritter._bodySprite.getPosition());
					if (dist < closestDist)
					{
						closestDist = dist;
						topCritter = farCritter;
					}
				}
			}
			var sexyBlowJob:SexyBlowJob = new SexyBlowJob(topCritter, botCritter);
			immobilizeAndLinkCritters([topCritter, botCritter], animName);
			var _eventTime:Float = 0;
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topPoint});
			botCritter._eventStack.addEvent({time:_eventTime += 0.4, callback:sexyBlowJob.botRunIntoPositionAndBlow});
			_eventTime += sexyBlowJob.getExpectedBotRunDuration();

			_eventTime += FlxG.random.float(4, 12);

			var pausesWithHandOnHead:Bool = false;
			var pausesWithJerkingOff:Bool = false;
			for (i in 0...2)
			{
				if (FlxG.random.bool())
				{
					pausesWithHandOnHead = true;
				}
				else
				{
					pausesWithJerkingOff = true;
				}
			}

			var tenacity:Float = FlxG.random.float(0, 0.9);
			while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
			{
				if (pausesWithHandOnHead && !pausesWithJerkingOff || (pausesWithHandOnHead && FlxG.random.bool()))
				{
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(2, 4), callback:sexyBlowJob.topHandOnHead});
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2), callback:sexyBlowJob.topEyesClosed});
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 8), callback:sexyBlowJob.topHandOffHead});
					topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topEyesHalfOpen});
				}
				else
				{
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 9), callback:sexyBlowJob.botJerkOff});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(1.5, 4.5), callback:sexyBlowJob.botBj});
				}
			}

			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(4, 8), callback:sexyBlowJob.topHandOnHead});
			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 3.0), callback:sexyBlowJob.topEyesClosed});
			if (FlxG.random.bool(40))
			{
				// swallow it
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2.0), callback:sexyBlowJob.botSwallow});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 7), callback:sexyBlowJob.botSitUp});
			}
			else if (FlxG.random.bool(50))
			{
				// squirt
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2.0), callback:sexyBlowJob.botSitUp});
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topOrgasm});
				topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 5), callback:sexyBlowJob.topEyesHalfOpen});
				_eventTime += FlxG.random.float(0, 2);
			}
			else
			{
				// squirt, but then swallow
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2.0), callback:sexyBlowJob.botSitUp});
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topOrgasm});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(1, 3), callback:sexyBlowJob.botSwallow});
				if (FlxG.random.bool())
				{
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([0, 1]), callback:sexyBlowJob.topHandOnHeadSwallow});
				}

				topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 5), callback:sexyBlowJob.topEyesHalfOpen});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2), callback:sexyBlowJob.botSitUp});
			}
			botCritter._eventStack.addEvent({time:_eventTime, callback:eventUnlinkCritters, args:[[topCritter, botCritter]]});
			botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.botDone});
			topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.topDone});
		}
		if (animName == "global-sexy-blowjob-and-jerk")
		{
			// a critter sucks someone off, then jerks them off until they cum
			var botCritter:Critter;
			var topCritter:Critter;
			{
				var farCritters:Array<Critter> = puzzleState.findIdleCritters(5); // find 5; pick the closest 2
				if (farCritters.length < 2)
				{
					// couldn't find two
					return;
				}
				botCritter = farCritters.splice(0, 1)[0];
				var closestDist:Float = 1000;
				topCritter = farCritters[0];
				for (farCritter in farCritters)
				{
					var dist:Float = farCritter._bodySprite.getPosition().distanceTo(botCritter._bodySprite.getPosition());
					if (dist < closestDist)
					{
						closestDist = dist;
						topCritter = farCritter;
					}
				}
			}
			var sexyBlowJob:SexyBlowJob = new SexyBlowJob(topCritter, botCritter);
			immobilizeAndLinkCritters([topCritter, botCritter], animName);
			var _eventTime:Float = 0;
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topJerkSelf});
			botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0.4, 6), callback:sexyBlowJob.botRunIntoPositionAndJerk});
			_eventTime += sexyBlowJob.getExpectedBotRunDuration();
			botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 9), callback:sexyBlowJob.botBj});
			botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(4, 12), callback:sexyBlowJob.botJerkOff});

			var tenacity:Float = FlxG.random.float(0, 0.9);
			while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
			{
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 9), callback:sexyBlowJob.botBj});
				topCritter._eventStack.addEvent({time:_eventTime + FlxG.random.float(0.5, 2), callback:sexyBlowJob.topEyesClosed});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(4, 12), callback:sexyBlowJob.botJerkOff});
				topCritter._eventStack.addEvent({time:_eventTime + FlxG.random.float(0.5, 3), callback:sexyBlowJob.topEyesHalfOpen});
			}

			// cums
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyBlowJob.topOrgasm});
			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(3, 5), callback:sexyBlowJob.topEyesHalfOpen});
			botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.float(0, 2.0), callback:sexyBlowJob.botSitUp});

			// done
			botCritter._eventStack.addEvent({time:_eventTime, callback:eventUnlinkCritters, args:[[topCritter, botCritter]]});
			botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.botDone});
			topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyBlowJob.topDone});
		}
		if (animName == "global-sexy-mutual-masturbate")
		{
			// 2-4 critters group up and masturbate
			var mainCritter:Critter;
			var otherCritters:Array<Critter> = [];
			{
				var critters:Array<Critter> = puzzleState.findIdleCritters(FlxG.random.getObject([2, 3, 4], [0.5, 0.3, 0.2]));
				if (critters.length < 2)
				{
					// couldn't find two
					return;
				}
				immobilizeCritters(critters, animName);
				var sexyMutualMasturbate:SexyMutualMasturbate = new SexyMutualMasturbate(critters);
				sexyMutualMasturbate.go();
			}
		}
		if (animName == "global-sexy-doggy")
		{
			// a critter nudges his snout under someone else's rump, and fucks them doggy-style
			var botCritter:Critter;
			var topCritter:Critter = null;
			{
				var farCritters:Array<Critter> = puzzleState.findIdleCritters(5); // find 5; pick the closest 2
				if (farCritters.length < 2)
				{
					// couldn't find two
					return;
				}
				for (farCritter in farCritters)
				{
					if (farCritter.isMale())
					{
						topCritter = farCritter;
						break;
					}
				}
				if (topCritter == null)
				{
					// no males?
					return;
				}
				farCritters.remove(topCritter);
				var closestDist:Float = 1000;
				botCritter = farCritters[0];
				for (farCritter in farCritters)
				{
					var dist:Float = farCritter._bodySprite.getPosition().distanceTo(topCritter._bodySprite.getPosition());
					if (dist < closestDist)
					{
						closestDist = dist;
						botCritter = farCritter;
					}
				}
			}

			var critters:Array<Critter> = [topCritter, botCritter];
			immobilizeAndLinkCritters(critters, animName);

			var sexyRimming:SexyRimming = new SexyRimming(topCritter, botCritter);
			var sexyDoggy:SexyDoggy = new SexyDoggy(topCritter, botCritter);
			var _eventTime:Float = 0;
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.runIntoPositionAndPokeSnout});
			botCritter._eventStack.addEvent({time:_eventTime += 1.2 + sexyRimming.getExpectedRunDuration(), callback:sexyRimming.botNotice});
			topCritter._eventStack.addEvent({time:_eventTime += 2.0, callback:sexyDoggy.startDoggy});
			topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyDoggy.topPenetrate, args:[1.5]});
			botCritter._eventStack.addEvent({time:_eventTime + 0.66, callback:sexyDoggy.botEyesClosed});
			topCritter._eventStack.addEvent({time:_eventTime += 2.5, callback:sexyDoggy.topHump, args:[1, 3, false]});
			botCritter._eventStack.addEvent({time:_eventTime + 0.66, callback:sexyDoggy.botEyesOpen, args:[1.5]});
			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([3, 6]), callback:sexyDoggy.topHump, args:[1, 2, false]});
			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 4, false]});
			var tenacity:Float = FlxG.random.float(0, 0.9);
			var spankiness:Int = FlxG.random.int( -60, 60);
			while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
			{
				// go again?
				topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, false]});
				topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[4, 2, false, FlxG.random.bool(30 + spankiness)]});
			}
			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, true]});
			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[4, 2, true, FlxG.random.bool(40 + spankiness)]});
			botCritter._eventStack.addEvent({time:_eventTime + 1.66, callback:sexyDoggy.botOrgasm});
			topCritter._eventStack.addEvent({time:_eventTime += 4, callback:(FlxG.random.bool(30) ? sexyDoggy.topOrgasmPullOut : sexyDoggy.topOrgasm)});
			topCritter._eventStack.addEvent({time:_eventTime += 6.5, callback:sexyDoggy.topAlmostDone});
			botCritter._eventStack.addEvent({time:_eventTime += 1.0, callback:sexyDoggy.botLookBack});
			topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:eventUnlinkCritters, args:[critters]});
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyDoggy.topDone});
			botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyDoggy.botDone});
		}
		if (animName == "global-sexy-doggy-blitz")
		{
			// a critter nudges his snout under someone else's rump, and fucks them doggy-style, but cums really quick
			var botCritter:Critter;
			var topCritter:Critter = null;
			{
				var farCritters:Array<Critter> = puzzleState.findIdleCritters(5); // find 5; pick the closest 2
				if (farCritters.length < 2)
				{
					// couldn't find two
					return;
				}
				for (farCritter in farCritters)
				{
					if (farCritter.isMale())
					{
						topCritter = farCritter;
						break;
					}
				}
				if (topCritter == null)
				{
					// no males?
					return;
				}
				farCritters.remove(topCritter);
				var closestDist:Float = 1000;
				botCritter = farCritters[0];
				for (farCritter in farCritters)
				{
					var dist:Float = farCritter._bodySprite.getPosition().distanceTo(topCritter._bodySprite.getPosition());
					if (dist < closestDist)
					{
						closestDist = dist;
						botCritter = farCritter;
					}
				}
			}

			var critters:Array<Critter> = [topCritter, botCritter];
			immobilizeAndLinkCritters(critters, animName);

			var sexyRimming:SexyRimming = new SexyRimming(topCritter, botCritter);
			var sexyDoggy:SexyDoggy = new SexyDoggy(topCritter, botCritter);
			var _eventTime:Float = 0;
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.runIntoPositionAndPokeSnout});
			botCritter._eventStack.addEvent({time:_eventTime += 1.2 + sexyRimming.getExpectedRunDuration(), callback:sexyRimming.botNotice});
			topCritter._eventStack.addEvent({time:_eventTime += 2.0, callback:sexyDoggy.startDoggy});
			topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyDoggy.topPenetrate, args:[1.5]});
			botCritter._eventStack.addEvent({time:_eventTime + 0.66, callback:sexyDoggy.botEyesClosed});
			topCritter._eventStack.addEvent({time:_eventTime += 2.5, callback:sexyDoggy.topHump, args:[1, 2, false]});
			botCritter._eventStack.addEvent({time:_eventTime + 0.66, callback:sexyDoggy.botEyesOpen, args:[1.5]});
			topCritter._eventStack.addEvent({time:_eventTime += 2, callback:sexyDoggy.topHump, args:[3, 2, false]});
			topCritter._eventStack.addEvent({time:_eventTime += 2, callback:sexyDoggy.topHump, args:[5, 2, true]});
			topCritter._eventStack.addEvent({time:_eventTime += 4, callback:(FlxG.random.bool(10) ? sexyDoggy.topOrgasmPullOut : sexyDoggy.topOrgasm)});
			botCritter._eventStack.addEvent({time:_eventTime + 1.0, callback:sexyDoggy.botLookBack});
			topCritter._eventStack.addEvent({time:_eventTime += 5.5, callback:sexyDoggy.topAlmostDone});
			topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:eventUnlinkCritters, args:[critters]});
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyDoggy.topDone});
			botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyDoggy.botDone});
		}
		if (animName == "global-sexy-doggy-spank")
		{
			// a critter waggles his rump immediately; another critter leaps into place, fucking him doggy style, and spanking him
			var botCritter:Critter = null;
			var topCritter:Critter = null;
			{
				var farCritters:Array<Critter> = puzzleState.findIdleCritters(5); // find 5; pick 2 that are an appropriate distance for jumping
				if (farCritters.length < 2)
				{
					// couldn't find two
					return;
				}
				for (farCritter in farCritters)
				{
					if (farCritter.isMale())
					{
						topCritter = farCritter;
						break;
					}
				}
				if (topCritter == null)
				{
					// no males?
					return;
				}
				farCritters.remove(topCritter);
				var bestDist:Float = 9999;
				topCritter = farCritters[0];
				for (farCritter in farCritters)
				{
					var dist:Float = farCritter._bodySprite.getPosition().distanceTo(topCritter._bodySprite.getPosition());
					if (dist > SexyRimming.JUMP_DIST + 40 && dist < bestDist)
					{
						bestDist = dist;
						botCritter = farCritter;
					}
				}
				if (bestDist == 9999)
				{
					// couldn't find two which were a good distance
					return;
				}
			}

			var critters:Array<Critter> = [topCritter, botCritter];
			immobilizeAndLinkCritters(critters, animName);

			var sexyRimming:SexyRimming = new SexyRimming(topCritter, botCritter);
			var sexyDoggy:SexyDoggy = new SexyDoggy(topCritter, botCritter);
			var _eventTime:Float = 0;
			{
				var _eventTime:Float = 0;
				botCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.botWaggle});
				botCritter._eventStack.addEvent({time:_eventTime += 0.8, callback:sexyRimming.botWait});
			}

			var _eventTime:Float = 0.4;
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyDoggy.runToJump});
			topCritter._eventStack.addEvent({time:_eventTime += sexyDoggy.getExpectedRunToJumpDuration(), callback:sexyDoggy.jumpIntoPositionAndStartDoggy});
			topCritter._eventStack.addEvent({time:_eventTime += sexyRimming.getExpectedJumpDuration() + 0.2, callback:sexyDoggy.topPenetrate, args:[0.2]});
			botCritter._eventStack.addEvent({time:_eventTime, callback:sexyDoggy.botEyesClosed});

			topCritter._eventStack.addEvent({time:_eventTime += 1.5, callback:sexyDoggy.topHump, args:[1, 2, false]});
			botCritter._eventStack.addEvent({time:_eventTime + 0.66, callback:sexyDoggy.botEyesOpen, args:[1.5]});
			var spankiness:Int = FlxG.random.int( -30, 30);
			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, false, FlxG.random.bool(100 + spankiness)]});
			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[4, 2, false, FlxG.random.bool(30 + spankiness)]});
			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, false, FlxG.random.bool(45 + spankiness)]});
			var tenacity:Float = FlxG.random.float(0, 0.9);
			while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
			{
				// go again?
				topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[4, 2, false, FlxG.random.bool(60 + spankiness)]});
				topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, false, FlxG.random.bool(75 + spankiness)]});
			}
			topCritter._eventStack.addEvent({time:_eventTime += 2, callback:sexyDoggy.topHump, args:[5, 2, true]});
			botCritter._eventStack.addEvent({time:_eventTime + 1.66, callback:sexyDoggy.botOrgasm});
			topCritter._eventStack.addEvent({time:_eventTime += 4, callback:(FlxG.random.bool(80) ? sexyDoggy.topOrgasmPullOut : sexyDoggy.topOrgasm)});
			topCritter._eventStack.addEvent({time:_eventTime += 6.5, callback:sexyDoggy.topAlmostDone});
			botCritter._eventStack.addEvent({time:_eventTime += 1.0, callback:sexyDoggy.botLookBack});
			topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:eventUnlinkCritters, args:[critters]});
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyDoggy.topDone});
			botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyDoggy.botDone});
		}
		if (animName == "global-sexy-doggy-gangbang")
		{
			// a critter waggles his rump alluringly; several critters race into position, and take turns fucking him
			var botCritter:Critter;
			var topCritters:Array<Critter> = [];
			var watchCritters:Array<Critter> = [];
			{
				var farCritters:Array<Critter> = puzzleState.findIdleCritters(7); // find 7; pick one bottom, and a lot of spectators
				if (farCritters.length < 3)
				{
					// couldn't find three
					return;
				}
				botCritter = farCritters.splice(0, 1)[0];
				for (farCritter in farCritters)
				{
					if (farCritter.isMale())
					{
						topCritters.push(farCritter);
					}
					else if (FlxG.random.bool(40))
					{
						// sometimes girls like to watch too
						watchCritters.push(farCritter);
					}
				}
				if (topCritters.length < 2)
				{
					// need at least two males for a gangbang
					return;
				}
				var closestDist:Float = 1000;
				var closestTopCritter = topCritters[0];
				for (topCritter in topCritters)
				{
					var dist:Float = topCritter._bodySprite.getPosition().distanceTo(botCritter._bodySprite.getPosition());
					if (dist < closestDist)
					{
						closestDist = dist;
						closestTopCritter = topCritter;
					}
				}
				topCritters.remove(closestTopCritter);
				topCritters.insert(0, closestTopCritter);
				var i = topCritters.length - 1;
				while (i > 1)
				{
					if (FlxG.random.bool())
					{
						watchCritters.push(topCritters.splice(i, 1)[0]);
					}
					i--;
				}
				FlxG.random.shuffle(watchCritters);

				// maximum five spectators
				topCritters.splice(2, topCritters.length - 5);
				watchCritters.splice(0, (topCritters.length + watchCritters.length) - 5);
			}

			immobilizeCritters([botCritter], animName);
			immobilizeCritters(topCritters, animName);
			immobilizeCritters(watchCritters, animName);

			var sexyGangBang:SexyGangBang = new SexyGangBang(topCritters, botCritter, watchCritters);
			sexyGangBang.go();
		}
		if (animName == "global-sexy-rimming-into-doggy")
		{
			// a critter nudges his snout under someone else's rump, and starts rimming them... then fucks them
			var botCritter:Critter;
			var topCritter:Critter;
			{
				var farCritters:Array<Critter> = puzzleState.findIdleCritters(5); // find 5; pick the closest 2
				if (farCritters.length < 2)
				{
					// couldn't find two
					return;
				}
				botCritter = farCritters.splice(0, 1)[0];
				var closestDist:Float = 1000;
				topCritter = farCritters[0];
				for (farCritter in farCritters)
				{
					var dist:Float = farCritter._bodySprite.getPosition().distanceTo(botCritter._bodySprite.getPosition());
					if (dist < closestDist)
					{
						closestDist = dist;
						topCritter = farCritter;
					}
				}
			}

			var critters:Array<Critter> = [topCritter, botCritter];
			immobilizeAndLinkCritters(critters, animName);

			var sexyRimming:SexyRimming = new SexyRimming(topCritter, botCritter);
			var sexyDoggy:SexyDoggy = new SexyDoggy(topCritter, botCritter);

			var _eventTime:Float = 0;
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.runIntoPositionAndPokeSnout});
			botCritter._eventStack.addEvent({time:_eventTime += 1.2 + sexyRimming.getExpectedRunDuration(), callback:sexyRimming.botNotice});
			topCritter._eventStack.addEvent({time:_eventTime += 1.5, callback:sexyRimming.startRim});
			botCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.botEyesOpen});
			topCritter._eventStack.addEvent({time:_eventTime += 10.0 + FlxG.random.float(0, 4.0), callback:sexyRimming.topEyesClosed});
			botCritter._eventStack.addEvent({time:_eventTime += 1.5 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
			{
				var tenacity:Float = FlxG.random.float(0, 0.9);
				while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
				{
					// go again?
					botCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesOpen});
					topCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesOpen});
					topCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesClosed});
					botCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
				}
			}

			topCritter._eventStack.addEvent({time:_eventTime += 2.5, callback:sexyDoggy.startDoggy, args:[true]});
			topCritter._eventStack.addEvent({time:_eventTime += 2.0, callback:sexyDoggy.topPenetrate, args:[1.5]});
			botCritter._eventStack.addEvent({time:_eventTime, callback:sexyDoggy.botEyesClosed});

			topCritter._eventStack.addEvent({time:_eventTime += 2.0, callback:sexyDoggy.topHump, args:[1, 2, false]});
			botCritter._eventStack.addEvent({time:_eventTime + 0.66, callback:sexyDoggy.botEyesOpen, args:[1.5]});
			var spankiness:Int = FlxG.random.int( -30, 30);
			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, false, FlxG.random.bool(100 + spankiness)]});
			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[4, 2, false, FlxG.random.bool(30 + spankiness)]});
			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, false, FlxG.random.bool(45 + spankiness)]});
			{
				var tenacity:Float = FlxG.random.float(0, 0.9);
				while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
				{
					// go again?
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[4, 2, false, FlxG.random.bool(60 + spankiness)]});
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, false, FlxG.random.bool(75 + spankiness)]});
				}
			}
			topCritter._eventStack.addEvent({time:_eventTime += 2, callback:sexyDoggy.topHump, args:[5, 2, true]});
			botCritter._eventStack.addEvent({time:_eventTime + 1.66, callback:sexyDoggy.botOrgasm});
			topCritter._eventStack.addEvent({time:_eventTime += 4, callback:(FlxG.random.bool(80) ? sexyDoggy.topOrgasmPullOut : sexyDoggy.topOrgasm)});
			topCritter._eventStack.addEvent({time:_eventTime += 6.5, callback:sexyDoggy.topAlmostDone});
			botCritter._eventStack.addEvent({time:_eventTime += 1.0, callback:sexyDoggy.botLookBack});
			topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:eventUnlinkCritters, args:[critters]});
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyDoggy.topDone});
			botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyDoggy.botDone});
		}
		if (animName == "global-sexy-rimming-take-turns-and-doggy")
		{
			// a critter rims someone else, who then returns the favor
			var botCritter:Critter;
			var topCritter:Critter;
			{
				var farCritters:Array<Critter> = puzzleState.findIdleCritters(5); // find 5; pick the closest 2
				if (farCritters.length < 2)
				{
					// couldn't find two
					return;
				}
				botCritter = farCritters.splice(0, 1)[0];
				var closestDist:Float = 1000;
				topCritter = farCritters[0];
				for (farCritter in farCritters)
				{
					var dist:Float = farCritter._bodySprite.getPosition().distanceTo(botCritter._bodySprite.getPosition());
					if (dist < closestDist)
					{
						closestDist = dist;
						topCritter = farCritter;
					}
				}
			}

			var critters:Array<Critter> = [topCritter, botCritter];
			immobilizeAndLinkCritters(critters, animName);

			var _eventTime:Float = 0;
			{
				var sexyRimming:SexyRimming = new SexyRimming(topCritter, botCritter);
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.runIntoPositionAndPokeSnout});
				botCritter._eventStack.addEvent({time:_eventTime += 1.2 + sexyRimming.getExpectedRunDuration(), callback:sexyRimming.botNotice});
				topCritter._eventStack.addEvent({time:_eventTime += 1.5, callback:sexyRimming.startRim});
				botCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.botEyesOpen});
				topCritter._eventStack.addEvent({time:_eventTime += 7.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesClosed});
				botCritter._eventStack.addEvent({time:_eventTime += 1.5 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
				var tenacity:Float = FlxG.random.float(0, 0.9);
				while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
				{
					// go again?
					botCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesOpen});
					topCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesOpen});
					topCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesClosed});
					botCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
				}
				botCritter._eventStack.addEvent({time:_eventTime += 2.5, callback:sexyRimming.botOrgasm});
				topCritter._eventStack.addEvent({time:_eventTime += 1.0, callback:sexyRimming.topStop});
				topCritter._eventStack.addEvent({time:_eventTime += 1.0, callback:sexyRimming.topDoneForNow});
				botCritter._eventStack.addEvent({time:_eventTime += 0.8, callback:sexyRimming.botDoneForNow});
			}
			{
				var sexyRimming:SexyRimming = new SexyRimming(botCritter, topCritter);
				var sexyDoggy:SexyDoggy = new SexyDoggy(botCritter, topCritter);
				botCritter._eventStack.addEvent({time:_eventTime += 0.6, callback:sexyRimming.refresh});
				topCritter._eventStack.addEvent({time:_eventTime += 0.6, callback:sexyRimming.botWaggle});
				botCritter._eventStack.addEvent({time:_eventTime += 0.8, callback:sexyRimming.runIntoPositionAndRim});
				botCritter._eventStack.addEvent({time:_eventTime += 0.4 + sexyRimming.getExpectedRunDuration(), callback:sexyRimming.topEyesClosed});
				botCritter._eventStack.addEvent({time:_eventTime += 3.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesOpen});
				botCritter._eventStack.addEvent({time:_eventTime += 5.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesClosed});
				topCritter._eventStack.addEvent({time:_eventTime += 0.5 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
				botCritter._eventStack.addEvent({time:_eventTime += 2.5, callback:sexyDoggy.startDoggy, args:[true]});
				botCritter._eventStack.addEvent({time:_eventTime += 2.0, callback:sexyDoggy.topPenetrate, args:[0.33]});
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyDoggy.botEyesClosed});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 4, false]});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[4, 4, false]});
				topCritter._eventStack.addEvent({time:_eventTime + 0.66, callback:sexyDoggy.botEyesOpen, args:[1.5]});
				var tenacity:Float = FlxG.random.float(0, 0.9);
				var spankiness:Int = FlxG.random.int( -60, 60);
				while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
				{
					// go again?
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[5, 4, false]});
					botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[7, 4, false, FlxG.random.bool(30 + spankiness)]});
				}
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[9, 4, true]});
				botCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[11, 4, true, FlxG.random.bool(40 + spankiness)]});
				topCritter._eventStack.addEvent({time:_eventTime + 1.66, callback:sexyDoggy.botOrgasm});
				botCritter._eventStack.addEvent({time:_eventTime += 4, callback:(FlxG.random.bool(30) ? sexyDoggy.topOrgasmPullOut : sexyDoggy.topOrgasm)});
				botCritter._eventStack.addEvent({time:_eventTime += 6.5, callback:sexyDoggy.topAlmostDone});
				topCritter._eventStack.addEvent({time:_eventTime += 1.0, callback:sexyDoggy.botLookBack});
				botCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:eventUnlinkCritters, args:[critters]});
				botCritter._eventStack.addEvent({time:_eventTime, callback:sexyDoggy.topDone});
				topCritter._eventStack.addEvent({time:_eventTime += 0.5, callback:sexyDoggy.botDone});
			}
		}
		if (animName == "global-sexy-doggy-then-rim")
		{
			// a critter waggles his rump immediately; another critter leaps into place, fucking him doggy style, and spanking him
			var botCritter:Critter = null;
			var topCritter:Critter = null;
			{
				var farCritters:Array<Critter> = puzzleState.findIdleCritters(5); // find 5; pick 2 that are an appropriate distance for jumping
				if (farCritters.length < 2)
				{
					// couldn't find two
					return;
				}
				for (farCritter in farCritters)
				{
					if (farCritter.isMale())
					{
						topCritter = farCritter;
						break;
					}
				}
				if (topCritter == null)
				{
					// no males?
					return;
				}
				farCritters.remove(topCritter);
				var bestDist:Float = 9999;
				botCritter = farCritters[0];
				for (farCritter in farCritters)
				{
					var dist:Float = farCritter._bodySprite.getPosition().distanceTo(topCritter._bodySprite.getPosition());
					if (dist > SexyRimming.JUMP_DIST + 40 && dist < bestDist)
					{
						bestDist = dist;
						botCritter = farCritter;
					}
				}
				if (bestDist == 9999)
				{
					// couldn't find two which were a good distance
					return;
				}
			}

			var critters:Array<Critter> = [topCritter, botCritter];
			immobilizeAndLinkCritters(critters, animName);

			var sexyRimming:SexyRimming = new SexyRimming(topCritter, botCritter);
			var sexyDoggy:SexyDoggy = new SexyDoggy(topCritter, botCritter);
			var _eventTime:Float = 0;
			{
				var _eventTime:Float = 0;
				botCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.botWaggle});
				botCritter._eventStack.addEvent({time:_eventTime += 0.8, callback:sexyRimming.botWait});
			}

			var _eventTime:Float = 0.4;
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyDoggy.runToJump});
			topCritter._eventStack.addEvent({time:_eventTime += sexyDoggy.getExpectedRunToJumpDuration(), callback:sexyDoggy.jumpIntoPositionAndStartDoggy});
			topCritter._eventStack.addEvent({time:_eventTime += sexyRimming.getExpectedJumpDuration() + 0.2, callback:sexyDoggy.topPenetrate, args:[0.2]});
			botCritter._eventStack.addEvent({time:_eventTime, callback:sexyDoggy.botEyesClosed});

			topCritter._eventStack.addEvent({time:_eventTime += 1.5, callback:sexyDoggy.topHump, args:[1, 2, false]});
			botCritter._eventStack.addEvent({time:_eventTime + 0.66, callback:sexyDoggy.botEyesOpen, args:[1.5]});
			var spankiness:Int = Math.round(Math.min(FlxG.random.int( -30, 30), FlxG.random.int( -30, 30)));
			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, false, FlxG.random.bool(100 + spankiness)]});
			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[4, 2, false, FlxG.random.bool(30 + spankiness)]});
			topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, false, FlxG.random.bool(45 + spankiness)]});
			{
				var tenacity:Float = FlxG.random.float(0, 0.9);
				while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
				{
					// go again?
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[4, 2, false, FlxG.random.bool(60 + spankiness)]});
					topCritter._eventStack.addEvent({time:_eventTime += FlxG.random.getObject([2, 4, 6]), callback:sexyDoggy.topHump, args:[3, 2, false, FlxG.random.bool(75 + spankiness)]});
				}
			}
			topCritter._eventStack.addEvent({time:_eventTime += 2, callback:sexyDoggy.topHump, args:[5, 2, true]});
			topCritter._eventStack.addEvent({time:_eventTime += 4, callback:sexyDoggy.topOrgasm});
			topCritter._eventStack.addEvent({time:_eventTime += 6.5, callback:sexyDoggy.topAlmostDone});
			botCritter._eventStack.addEvent({time:_eventTime += 1.0, callback:sexyDoggy.botLookBack});

			topCritter._eventStack.addEvent({time:_eventTime += 1.5, callback:sexyRimming.startRim, args:[true]});
			botCritter._eventStack.addEvent({time:_eventTime + 0.833, callback:sexyRimming.botEyesOpen});
			topCritter._eventStack.addEvent({time:_eventTime += 10.0 + FlxG.random.float(0, 4.0), callback:sexyRimming.topEyesClosed});
			botCritter._eventStack.addEvent({time:_eventTime += 1.5 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
			{
				var tenacity:Float = FlxG.random.float(0, 0.9);
				while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
				{
					// go again?
					botCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesOpen});
					topCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesOpen});
					topCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesClosed});
					botCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
				}
			}
			botCritter._eventStack.addEvent({time:_eventTime += 2.5, callback:sexyRimming.botOrgasm});
			topCritter._eventStack.addEvent({time:_eventTime += 2.0, callback:sexyRimming.topStop});
			topCritter._eventStack.addEvent({time:_eventTime += 2.0, callback:eventUnlinkCritters, args:[critters]});
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.topDone});
			botCritter._eventStack.addEvent({time:_eventTime += 0.8, callback:sexyRimming.botDone});
		}
		if (animName == "global-sexy-rimming")
		{
			// a critter nudges his snout under someone else's rump, and starts rimming them
			var botCritter:Critter;
			var topCritter:Critter;
			{
				var farCritters:Array<Critter> = puzzleState.findIdleCritters(5); // find 5; pick the closest 2
				if (farCritters.length < 2)
				{
					// couldn't find two
					return;
				}
				botCritter = farCritters.splice(0, 1)[0];
				var closestDist:Float = 1000;
				topCritter = farCritters[0];
				for (farCritter in farCritters)
				{
					var dist:Float = farCritter._bodySprite.getPosition().distanceTo(botCritter._bodySprite.getPosition());
					if (dist < closestDist)
					{
						closestDist = dist;
						topCritter = farCritter;
					}
				}
			}

			var critters:Array<Critter> = [topCritter, botCritter];
			immobilizeAndLinkCritters(critters, animName);

			var sexyRimming:SexyRimming = new SexyRimming(topCritter, botCritter);

			var _eventTime:Float = 0;
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.runIntoPositionAndPokeSnout});
			botCritter._eventStack.addEvent({time:_eventTime += 1.2 + sexyRimming.getExpectedRunDuration(), callback:sexyRimming.botNotice});
			topCritter._eventStack.addEvent({time:_eventTime += 1.5, callback:sexyRimming.startRim});
			botCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.botEyesOpen});
			topCritter._eventStack.addEvent({time:_eventTime += 10.0 + FlxG.random.float(0, 4.0), callback:sexyRimming.topEyesClosed});
			botCritter._eventStack.addEvent({time:_eventTime += 1.5 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
			var tenacity:Float = FlxG.random.float(0, 0.9);
			while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
			{
				// go again?
				botCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesOpen});
				topCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesOpen});
				topCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesClosed});
				botCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
			}
			botCritter._eventStack.addEvent({time:_eventTime += 2.5, callback:sexyRimming.botOrgasm});
			topCritter._eventStack.addEvent({time:_eventTime += 2.0, callback:sexyRimming.topStop});
			topCritter._eventStack.addEvent({time:_eventTime += 2.0, callback:eventUnlinkCritters, args:[critters]});
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.topDone});
			botCritter._eventStack.addEvent({time:_eventTime += 0.8, callback:sexyRimming.botDone});
		}
		if (animName == "global-sexy-rimming-take-turns")
		{
			// a critter rims someone else, who then returns the favor
			var botCritter:Critter;
			var topCritter:Critter;
			{
				var farCritters:Array<Critter> = puzzleState.findIdleCritters(5); // find 5; pick the closest 2
				if (farCritters.length < 2)
				{
					// couldn't find two
					return;
				}
				botCritter = farCritters.splice(0, 1)[0];
				var closestDist:Float = 1000;
				topCritter = farCritters[0];
				for (farCritter in farCritters)
				{
					var dist:Float = farCritter._bodySprite.getPosition().distanceTo(botCritter._bodySprite.getPosition());
					if (dist < closestDist)
					{
						closestDist = dist;
						topCritter = farCritter;
					}
				}
			}

			var critters:Array<Critter> = [topCritter, botCritter];
			immobilizeAndLinkCritters(critters, animName);

			var _eventTime:Float = 0;
			{
				var sexyRimming:SexyRimming = new SexyRimming(topCritter, botCritter);
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.runIntoPositionAndPokeSnout});
				botCritter._eventStack.addEvent({time:_eventTime += 1.2 + sexyRimming.getExpectedRunDuration(), callback:sexyRimming.botNotice});
				topCritter._eventStack.addEvent({time:_eventTime += 1.5, callback:sexyRimming.startRim});
				botCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.botEyesOpen});
				topCritter._eventStack.addEvent({time:_eventTime += 7.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesClosed});
				botCritter._eventStack.addEvent({time:_eventTime += 1.5 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
				var tenacity:Float = FlxG.random.float(0, 0.9);
				while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
				{
					// go again?
					botCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesOpen});
					topCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesOpen});
					topCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesClosed});
					botCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
				}
				botCritter._eventStack.addEvent({time:_eventTime += 2.5, callback:sexyRimming.botOrgasm});
				topCritter._eventStack.addEvent({time:_eventTime += 1.0, callback:sexyRimming.topStop});
				topCritter._eventStack.addEvent({time:_eventTime += 1.0, callback:sexyRimming.topDoneForNow});
				botCritter._eventStack.addEvent({time:_eventTime += 0.8, callback:sexyRimming.botDoneForNow});
			}
			{
				var sexyRimming:SexyRimming = new SexyRimming(botCritter, topCritter);
				botCritter._eventStack.addEvent({time:_eventTime += 0.6, callback:sexyRimming.refresh});
				topCritter._eventStack.addEvent({time:_eventTime += 0.6, callback:sexyRimming.botWaggle});
				botCritter._eventStack.addEvent({time:_eventTime += 0.8, callback:sexyRimming.runIntoPositionAndRim});
				botCritter._eventStack.addEvent({time:_eventTime += 0.4 + sexyRimming.getExpectedRunDuration(), callback:sexyRimming.topEyesClosed});
				botCritter._eventStack.addEvent({time:_eventTime += 3.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesOpen});
				botCritter._eventStack.addEvent({time:_eventTime += 5.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesClosed});
				topCritter._eventStack.addEvent({time:_eventTime += 0.5 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
				var tenacity:Float = FlxG.random.float(0, 0.7);
				while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
				{
					// go again?
					topCritter._eventStack.addEvent({time:_eventTime += 1.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesOpen});
					botCritter._eventStack.addEvent({time:_eventTime += 1.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesOpen});
					botCritter._eventStack.addEvent({time:_eventTime += 1.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesClosed});
					topCritter._eventStack.addEvent({time:_eventTime += 1.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
				}
				topCritter._eventStack.addEvent({time:_eventTime += 1.5, callback:sexyRimming.botOrgasm});
				botCritter._eventStack.addEvent({time:_eventTime += 0.6, callback:sexyRimming.topStop});
				botCritter._eventStack.addEvent({time:_eventTime += 0.6, callback:eventUnlinkCritters, args:[critters]});
				botCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.topDone});
				topCritter._eventStack.addEvent({time:_eventTime += 0.8, callback:sexyRimming.botDone});
			}
		}
		if (animName == "global-sexy-rimming-waggle")
		{
			// a critter waggles their rump alluringly, and another critter dives in to rim them
			var botCritter:Critter;
			var topCritter:Critter;
			{
				var farCritters:Array<Critter> = puzzleState.findIdleCritters(5); // find 5; pick 2 that are an appropriate distance for jumping
				if (farCritters.length < 2)
				{
					// couldn't find two
					return;
				}
				botCritter = farCritters.splice(0, 1)[0];
				var bestDist:Float = 9999;
				topCritter = farCritters[0];
				for (farCritter in farCritters)
				{
					var dist:Float = farCritter._bodySprite.getPosition().distanceTo(botCritter._bodySprite.getPosition());
					if (dist > SexyRimming.JUMP_DIST + 40 && dist < bestDist)
					{
						bestDist = dist;
						topCritter = farCritter;
					}
				}
				if (bestDist == 9999)
				{
					// couldn't find two which were a good distance
					return;
				}
			}

			var critters:Array<Critter> = [topCritter, botCritter];
			immobilizeAndLinkCritters(critters, animName);

			var sexyRimming:SexyRimming = new SexyRimming(topCritter, botCritter);

			{
				var _eventTime:Float = 0;
				topCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.botWaggle});
				topCritter._eventStack.addEvent({time:_eventTime += 0.8, callback:sexyRimming.botWait});
			}

			var _eventTime:Float = 0.4;
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.runToJump});
			topCritter._eventStack.addEvent({time:_eventTime += sexyRimming.getExpectedRunToJumpDuration(), callback:sexyRimming.jumpIntoPositionAndRim});
			topCritter._eventStack.addEvent({time:_eventTime += sexyRimming.getExpectedJumpDuration() + 0.4, callback:sexyRimming.topEyesClosed});
			topCritter._eventStack.addEvent({time:_eventTime += 6.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesOpen});
			topCritter._eventStack.addEvent({time:_eventTime += 5.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesClosed});
			botCritter._eventStack.addEvent({time:_eventTime += 0.5 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
			var tenacity:Float = FlxG.random.float(0, 0.9);
			while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
			{
				// go again?
				botCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesOpen});
				topCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesOpen});
				topCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesClosed});
				botCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
			}
			botCritter._eventStack.addEvent({time:_eventTime += 0.5 + FlxG.random.float(0, 2.0), callback:sexyRimming.botOrgasm});
			topCritter._eventStack.addEvent({time:_eventTime += 1.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topStop});
			topCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:eventUnlinkCritters, args:[critters]});
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.topDone});
			botCritter._eventStack.addEvent({time:_eventTime += 0.8, callback:sexyRimming.botDone});
		}
		if (animName == "global-sexy-rimming-race")
		{
			// a critter waggles their rump alluringly, and several critters race in to rim them
			var botCritter:Critter;
			var topCritter:Critter;
			var otherCritters:Array<Critter> = [];
			{
				var farCritters:Array<Critter> = puzzleState.findIdleCritters(7); // find 7; pick the closest one and a few others
				if (farCritters.length < 2)
				{
					// couldn't find two
					return;
				}
				botCritter = farCritters.splice(0, 1)[0];
				var bestDist:Float = 9999;
				topCritter = farCritters[0];
				for (farCritter in farCritters)
				{
					var dist:Float = farCritter._bodySprite.getPosition().distanceTo(botCritter._bodySprite.getPosition());
					if (dist > SexyRimming.JUMP_DIST + 100)
					{
						otherCritters.push(farCritter);
					}
					if (dist > SexyRimming.JUMP_DIST + 100 && dist < bestDist)
					{
						bestDist = dist;
						topCritter = farCritter;
					}
				}
				otherCritters.remove(topCritter);
				otherCritters.splice(0, otherCritters.length - 3);
				if (otherCritters.length == 0)
				{
					// couldn't find enough critters for a race
					return;
				}
			}

			var critters:Array<Critter> = [topCritter, botCritter];
			immobilizeAndLinkCritters(critters, animName);

			var sexyRimming:SexyRimming = new SexyRimming(topCritter, botCritter);

			{
				var _eventTime:Float = 0;
				botCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.botWaggle});
				botCritter._eventStack.addEvent({time:_eventTime += 0.8, callback:sexyRimming.botWait});
			}

			for (critter in otherCritters)
			{
				var facing:Int = critter._bodySprite.x > botCritter._bodySprite.x ? FlxDirectionFlags.LEFT : FlxDirectionFlags.RIGHT;
				var jumpTarget:FlxPoint = FlxPoint.get(botCritter._targetSprite.x + (facing == FlxDirectionFlags.LEFT ? 18 : -18), botCritter._targetSprite.y - 9);

				var dx:Float = critter._bodySprite.x - jumpTarget.x;
				var dy:Float = critter._bodySprite.y - jumpTarget.y;
				jumpTarget.put();
				if (dx == 0 && dy == 0)
				{
					// avoid divide by zero
					dx = 2;
					dy = 1;
				}
				var ex:Float = SexyRimming.JUMP_DIST * dx / Math.sqrt(dx * dx + dy * dy);
				var ey:Float = SexyRimming.JUMP_DIST * dy / Math.sqrt(dx * dx + dy * dy);
				var jumpSource:FlxPoint = FlxPoint.get(botCritter._targetSprite.x + ex, botCritter._targetSprite.y + ey);
				critter.runTo(jumpSource.x, jumpSource.y);
			}

			var _eventTime:Float = 0.4;
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.runToJump});
			topCritter._eventStack.addEvent({time:_eventTime += sexyRimming.getExpectedRunToJumpDuration(), callback:sexyRimming.jumpIntoPositionAndRim});
			topCritter._eventStack.addEvent({time:_eventTime += sexyRimming.getExpectedJumpDuration() + 0.4, callback:sexyRimming.topEyesClosed});
			topCritter._eventStack.addEvent({time:_eventTime += 7.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesOpen});
			topCritter._eventStack.addEvent({time:_eventTime += 6.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesClosed});
			botCritter._eventStack.addEvent({time:_eventTime += 0.5 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
			var tenacity:Float = FlxG.random.float(0, 0.9);
			while (FlxG.random.float(0, 1) < tenacity && _eventTime < 300)
			{
				// go again?
				botCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesOpen});
				topCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesOpen});
				topCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.topEyesClosed});
				botCritter._eventStack.addEvent({time:_eventTime += 2.0 + FlxG.random.float(0, 2.0), callback:sexyRimming.botEyesClosed});
			}
			botCritter._eventStack.addEvent({time:_eventTime += 1.5, callback:sexyRimming.botOrgasm});
			topCritter._eventStack.addEvent({time:_eventTime += 1.5 + FlxG.random.float(0, 2.0), callback:sexyRimming.topStop});
			topCritter._eventStack.addEvent({time:_eventTime += 0.5 + FlxG.random.float(0, 2.0), callback:eventUnlinkCritters, args:[critters]});
			topCritter._eventStack.addEvent({time:_eventTime, callback:sexyRimming.topDone});
			botCritter._eventStack.addEvent({time:_eventTime += 0.8, callback:sexyRimming.botDone});
		}
	}

	static private function immobilizeCritters(critters:Array<Critter>, animName:String):Void
	{
		for (critter in critters)
		{
			critter.setImmovable(true);
			critter._eventStack.reset();
			critter._lastSexyAnim = animName;
		}
	}

	static private function immobilizeAndLinkCritters(critters:Array<Critter>, animName:String):Void
	{
		immobilizeCritters(critters, animName);
		for (critter in critters)
		{
			critterLinks[critter] = critters;
		}
	}

	public static function isLinked(critter:Critter)
	{
		if (critterLinks[critter] != null)
		{
			return true;
		}
		for (otherCritter in critterLinks.keys())
		{
			if (critterLinks[otherCritter].indexOf(critter) != -1)
			{
				return true;
			}
		}
		return false;
	}

	public static function unlinkCritterAndMakeGroupIdle(critter:Critter)
	{
		// this critter was picked up; anybody depending on him should be made idle, and he shouldn't depend on anybody anymore

		if (critterLinks[critter] != null)
		{
			for (otherCritter in critterLinks[critter])
			{
				otherCritter.setIdle();
				otherCritter._eventStack.reset();
				otherCritter.setImmovable(false);
				// if they're running to do something -- stop them from running, and get rid of the "something"
				otherCritter._targetSprite.setPosition(otherCritter._soulSprite.x, otherCritter._soulSprite.y);
				otherCritter._runToCallback = null;
			}

			unlinkCritters(critterLinks[critter]);
		}
		unlinkCritters([critter]);
	}

	public static function unlinkCritters(args:Array<Critter>):Void
	{
		// iterate over args.copy() since it's possible it can be changed as we're unlinking stuff
		for (critter in args.copy())
		{
			var result:Bool = critterLinks.remove(critter);
			for (key in critterLinks.keys())
			{
				critterLinks[key].remove(critter);
			}
		}
	}

	public static function eventUnlinkCritters(args:Array<Dynamic>):Void
	{
		unlinkCritters(args[0]);
	}

	public static function stayImmobile(critter:Critter):Void
	{
		critter.playAnim("sexy-idle");
	}

	public static function initialize()
	{
		critterLinks = new Map<Critter, Array<Critter>>();
	}

	static public function traceCritterLinks()
	{
		for (critterLink in critterLinks.keys())
		{
			trace(critterLink + " -> " + critterLinks[critterLink]);
		}
	}
}