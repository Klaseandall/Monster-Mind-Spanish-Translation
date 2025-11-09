import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import openfl.geom.Matrix;
import openfl.geom.Point;
import flash.geom.Rectangle;

/*
    Screenshots are used in several places, so I've separated the screenshot
    helper function into its own class which returns a properly formatted screeny
*/ 
class Screenshot {
    public static function get() : FlxSprite
        {
            var screenshot = new FlxSprite();
            screenshot.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE, true);
            
            #if flash
            screenshot.pixels.copyPixels(FlxG.camera.buffer, new Rectangle(0, 0, FlxG.width, FlxG.height), new Point());
            #else
            // This code is adapted from FlxScreenGrab.grab()
            // https://github.com/HaxeFlixel/flixel-addons/blob/95296191b4a583d3ce1e61383f4cde63dbda729c/flixel/addons/plugin/screengrab/FlxScreenGrab.hx
            //
            // Unfortunately it is slightly buggy, and draws parts of the screen with the wrong colors. This is possibly
            // due to shortcomings in OpenFL, see Flixel Addons issue #82; FlxScreenGrab doesn't match PrintScreen results
            // https://github.com/HaxeFlixel/flixel-addons/issues/82
            var sw = FlxG.stage.stageWidth;
            var sh = FlxG.stage.stageHeight;
            var bounds:Rectangle = new Rectangle(0, 0, sw, sh);
            var m:Matrix = new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y);

            // on some platforms the "stage" is the entire available resolution of the game window
            // so screenshots will be bigger/smaller than game resolution
            // this math corrects these problems
            #if screenshot
            var sr:Float=(sw/sh);
            var gr:Float=(Main.gameWidth/Main.gameHeight);
            var zr:Float=Math.min((sw/Main.gameWidth),(sh/Main.gameHeight));
            var gameSize = 0.0;
            var problemOffset = 0.0;
            var tx = 0.0;
            var ty = 0.0;
            if (sr >= gr) {
                // fix width overlap
                gameSize = Main.gameWidth * zr;
                problemOffset = FlxG.stage.stageWidth;
                tx = 1.0;
            } else {
                // fix height overlap
                gameSize = Main.gameHeight * zr;
                problemOffset = FlxG.stage.stageHeight;
                ty = 1.0;
            }
            problemOffset -= gameSize;
            problemOffset /= 2;
            tx *= problemOffset;
            ty *= problemOffset;
            m.translate(-tx,-ty);
            m.scale(1.0/zr,1.0/zr);
            #end

            screenshot.pixels.draw(FlxG.stage, m);
            #end

            return screenshot;
        }
    }