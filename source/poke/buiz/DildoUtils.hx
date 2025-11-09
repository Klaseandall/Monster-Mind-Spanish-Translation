package poke.buiz;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import poke.sexy.FancyAnim;
import poke.sexy.SexyState;

/**
 * A collection of random functionality which dildo-using Pokemon had in common
 */
class DildoUtils implements IFlxDestroyable
{
	private var sexyState:SexyState<Dynamic>;
	private var toyInterface:DildoInterface;
	public var assSprite:BouncySprite;
	public var dickSprite:BouncySprite;
	public var dildoSprite:BouncySprite;
	public var interact:BouncySprite;
	public var refreshDildoAnims:Void->Bool;
	public var dildoFrameToPct:Map<Int, Float> = new Map<Int, Float>();
	public var toyShadowGlove:BouncySprite;
	public var toyShadowDildo:BouncySprite;

	public function new(sexyState:SexyState<Dynamic>, toyInterface:DildoInterface, assSprite:BouncySprite, dickSprite:BouncySprite, dildoSprite:BouncySprite, interact:BouncySprite) {
		this.sexyState = sexyState;
		this.toyInterface = toyInterface;
		this.assSprite = assSprite;
		this.dickSprite = dickSprite;
		this.dildoSprite = dildoSprite;
		this.interact = interact;
	}
	
	public function dildoInteractOn():Void {
		var spr:BouncySprite = toyInterface.ass ? assSprite : dickSprite;
		var animName:String = toyInterface.animName;
		
		sexyState._rubHandAnim = new FancyAnim(interact, animName);
		interact.synchronize(spr);
		sexyState._rubBodyAnim = new FancyAnim(spr, animName);
		if (dildoSprite.animation.getByName(animName) != null) {
			sexyState._rubBodyAnim2 = new FancyAnim(dildoSprite, animName);
			dildoSprite.synchronize(spr);
		}
	}
	
	public function dildoInteractOff():Void {
		if (sexyState._rubHandAnim != null) {
			sexyState._rubHandAnim._flxSprite.animation.play("default");
			sexyState._rubHandAnim = null;
		}
		if (sexyState._rubBodyAnim != null) {
			sexyState._rubBodyAnim._flxSprite.animation.play("default");
			sexyState._rubBodyAnim = null;
		}
		if (sexyState._rubBodyAnim2 != null) {
			sexyState._rubBodyAnim2._flxSprite.animation.play("default");
			sexyState._rubBodyAnim2 = null;
		}
	}
	
	public function refreshDildoAnim(sprite:FlxSprite, animName:String, frames:Array<Int>, minFrames:Int, maxFrames:Int = 999):Bool {
		var oldFrameCount:Int = interact.animation.getByName(animName).numFrames;
		var frameCount:Int = minFrames;
		for (i in 1...frames.length - minFrames + 1) {
			if (toyInterface.animPct >= i / (2 + frames.length - minFrames)) {
				frameCount++;
			}
		}
		if (oldFrameCount != frameCount) {
			sprite.animation.add(animName, frames.slice(Std.int(Math.max(0, frameCount - maxFrames)), frameCount));
			return true;
		}
		return false;
	}
	
	public function refreshFancyAnims():Void {
		if (sexyState._rubHandAnim != null) sexyState._rubHandAnim.refresh();
		if (sexyState._rubBodyAnim != null) sexyState._rubBodyAnim.refresh();
		if (sexyState._rubBodyAnim2 != null) sexyState._rubBodyAnim2.refresh();
	}
	
	public function update(elapsed:Float) {
		sexyState.updateHead(elapsed);
		
		if (sexyState._rubHandAnim != null) {
			sexyState._rubHandAnim.update(elapsed);
		}
		if (sexyState._rubBodyAnim != null) {
			sexyState._rubBodyAnim.update(elapsed);
		}
		if (sexyState._rubBodyAnim2 != null) {
			sexyState._rubBodyAnim2.update(elapsed);
		}
		
		if (dildoSprite != null && dildoFrameToPct[dildoSprite.animation.frameIndex] != null) {
			toyInterface.setDildoInPct(dildoFrameToPct[dildoSprite.animation.frameIndex]);
		}
		
		if (refreshDildoAnims != null) {
			var refreshed:Bool = refreshDildoAnims();
			
			if (refreshed) {
				refreshFancyAnims();
			}
		}
		
		if (toyInterface.animName == null && sexyState._rubHandAnim != null) {
			dildoInteractOff();
		}
		
		if (FlxG.mouse.justPressed && toyInterface.animName != null) {
			if (sexyState._rubHandAnim != null && sexyState._rubHandAnim._flxSprite.animation.name == toyInterface.animName) {
				// already performing the appropriate animation
			} else if (sexyState._rubHandAnim != null && sexyState._rubHandAnim._flxSprite.animation.name != toyInterface.animName) {
				// already performing a different animation
				var oldMouseDownTime:Float = sexyState._rubHandAnim._prevMouseDownTime;
				var oldMouseUpTime:Float = sexyState._rubHandAnim._prevMouseUpTime;
				dildoInteractOff();
				dildoInteractOn();
				if (sexyState._rubHandAnim != null) sexyState._rubHandAnim.setSpeed(oldMouseDownTime, oldMouseUpTime);
				if (sexyState._rubBodyAnim != null) sexyState._rubBodyAnim.setSpeed(oldMouseDownTime, oldMouseUpTime);
				if (sexyState._rubBodyAnim2 != null) sexyState._rubBodyAnim2.setSpeed(oldMouseDownTime, oldMouseUpTime);
			} else {
				dildoInteractOn();
			}
		}
		
		if (toyShadowGlove != null && interact != null) {
			sexyState.syncShadowGlove(toyShadowGlove, interact);
		}
		if (toyShadowDildo != null && dildoSprite != null) {
			sexyState.syncShadowGlove(toyShadowDildo, dildoSprite);
		}
		
		if (sexyState._rubHandAnim != null && sexyState._rubHandAnim.sfxLength > 0) {
			sexyState._idlePunishmentTimer = 0;
			sexyState.playRubSound();
		}
	}
	
	public function reinitializeHandSprites() {
		if (toyShadowGlove == null) toyShadowGlove = new BouncySprite(0, 0, 0, 0, 0, 0);
		if (toyShadowDildo == null) toyShadowDildo = new BouncySprite(0, 0, 0, 0, 0, 0);
		if (PlayerData.cursorType == "none") {
			toyShadowGlove.makeGraphic(1, 1, FlxColor.TRANSPARENT);
			toyShadowGlove.alpha = 0.75;
			
			toyShadowDildo.makeGraphic(1, 1, FlxColor.TRANSPARENT);
			toyShadowDildo.alpha = 0.75;
		} else {
			toyShadowGlove.loadGraphicFromSprite(interact);
			toyShadowGlove.alpha = 0.75;
			
			toyShadowDildo.loadGraphicFromSprite(dildoSprite);
			toyShadowDildo.alpha = 0.75;
		}
	}
	
	public function destroy():Void {
		refreshDildoAnims = null;
		dildoFrameToPct = null;
		toyShadowGlove = FlxDestroyUtil.destroy(toyShadowGlove);
		toyShadowDildo = FlxDestroyUtil.destroy(toyShadowDildo);
	}
	
	public function showToyWindow() {
		if (!sexyState._male) {
			if (toyShadowGlove != null) {
				sexyState._shadowGloveBlackGroup.add(toyShadowGlove);
			}
			if (toyShadowDildo != null) {
				sexyState._shadowGloveBlackGroup.add(toyShadowDildo);
			}
		}
	}
	
	public function hideToyWindow() {
		if (!sexyState._male) {
			if (toyShadowGlove != null) {
				sexyState._shadowGloveBlackGroup.remove(toyShadowGlove);
			}
			if (toyShadowDildo != null) {
				sexyState._shadowGloveBlackGroup.remove(toyShadowDildo);
			}
		}
	}
}