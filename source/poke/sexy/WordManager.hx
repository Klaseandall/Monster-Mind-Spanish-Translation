package poke.sexy;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import kludge.BetterFlxRandom;
import poke.sexy.WordManager.Word;
import poke.sexy.WordManager.Qord;

/**
 * WordManager is responsible for displaying the word sprites which show up
 * during the sex scenes. The words appear as though they're being typed out on
 * a typewriter, then they sit in the air for a few seconds and fade away.
 */
class WordManager extends FlxTypedGroup<WordParticle> {
	private var qords:Array<Qord> = [];
	private var _previousWords:Array<Array<Word>> = [];
	public var _handSprite:FlxSprite;
	
	public function new() {
		super();
	}
	
	public function newWords(?Frequency=4.0):Qord {
		qords.push({words : [], frequency : Frequency, timer : 0});
		return qords[qords.length - 1];
	}
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
		for (qord in qords) {
			qord.timer -= elapsed;
		}
	}
	
	public function consecutiveWords(qord:Qord):Bool
	{
		return _previousWords.length > 0 && qord.words.indexOf(_previousWords[_previousWords.length - 1]) != -1;
	}
	
	public function wordsInARow(qord:Qord):Int
	{
		var inARow:Int = 0;
		var i:Int = _previousWords.length - 1;
		while (i >= 0 && qord.words.indexOf(_previousWords[i]) != -1) {
			inARow++;
			i--;
		}
		return inARow;
	}
	
	/**
	 * @param	left  Number of leftmost words to omit
	 * @param	right Number of rightmost words to omit
	 */
	public function emitWords(qord:Qord, ?left:Int=0, ?right:Int=0):Array<WordParticle> 
	{
		qord.timer = qord.frequency;
		
		if (qord.words.length == 0) {
			return [];
		}
		
		var words:Array<Word> = BetterFlxRandom.getObject(qord.words, null, left, qord.words.length - right - 1);
		_previousWords.push(words);
		_previousWords.splice(0, _previousWords.length - 100);
		
		var leftX:Int = 256 + FlxG.random.int(0, 20);
		var rightX:Int = 504 - ((words[0].width == null) ? 128 : words[0].width) - FlxG.random.int(0, 20);
		var wordX:Int = 0;
		if (words[0].width >= 256) {
			// no such thing as "left" or "right"; just drop it in the middle
			wordX = Std.int(384 - words[0].width / 2 + FlxG.random.int( -40, 40));
		} else if (_handSprite != null && _handSprite.x < 256 + 80) {
			wordX = rightX;
		} else if (_handSprite != null && _handSprite.x > 504 - 80) {
			wordX = leftX;
		} else {
			wordX = FlxG.random.getObject([leftX, rightX]);
		}
		
		// long sentences stay on the screen for awhile
		var lastWord:Word = words[words.length - 1];
		var startFade:Float = ((lastWord.width == null) ? 128 : lastWord.width) * (1 + ((lastWord.delay == null) ? 0 : lastWord.delay)) * 0.06 / ((lastWord.chunkSize == null) ? 10 : lastWord.chunkSize);
		
		var wordY:Int = Std.int(FlxG.random.float(125, 175));
		var wordIndex:Int = 0;
		var wordBottom:Int = 0;
		for (word in members) {
			if (word.alive) {
				wordBottom = Std.int(Math.max(wordBottom, word.y + word.height));
			}
		}
		var wordParticles:Array<WordParticle> = [];
		for (word in words) {
			word.width = word.width == null ? 128 : word.width;
			word.height = word.height == null ? 32 : word.height;
			word.chunkSize = word.chunkSize == null ? 10 : word.chunkSize;
			word.yOffset = word.yOffset == null ? 0 : word.yOffset;
			var wordsParticle:WordParticle = recycle(WordParticle);
			wordsParticle.reset(wordX, wordY + word.yOffset);
			wordsParticle.alpha = 1;
			wordsParticle.loadWordGraphic(word.graphic, word.width, word.height, word.frame, word.chunkSize);
			if (word.delay != null) {
				wordsParticle.delay(word.delay);
			}
			wordsParticle.velocity.y = -15;
			wordsParticle.lifespan = 2.1 + startFade;
			wordsParticle.enableLateFade(2.1 + startFade);
			
			if (wordIndex++ == 0 && FlxG.overlap(wordsParticle, this)) {
				wordY = wordBottom;
				wordsParticle.y = wordY + word.yOffset;
			}
			wordParticles.push(wordsParticle);
		}
		return wordParticles;
	}
	
	/**
	 * Stop emitting a specific phrase
	 * 
	 * @param	wordParticles wordparticles which should be interrupted
	 */
	public function interruptWords(wordParticles:Array<WordParticle>) {
		for (wordParticle in wordParticles) {
			wordParticle.interruptWord();
		}
	}
}

/**
 * A Qord is the definition of a set of related graphical phrases -- such as
 * all the different things a Pokemon might say when you pat their head.
 */
typedef Qord = {
	words:Array<Array<Word>>,
	frequency:Float,
	timer:Float
}

/**
 * A Word defines properties for a dialog sprite.
 * 
 * A phrase like "am i doing it wrong?" might actually have three Word
 * instances -- one for each row in the phrase.
 * 
 * To generate an FlxSprite for just the middle part, "doing it", we would need
 * to know which region of which PNG has that part in it, how long we should
 * wait before displaying it, how fast it should display, and things like that.
 * All that metadata is stored in a Word instance.
 */
typedef Word = {
	graphic:Dynamic,
	?width:Int,
	?height:Int,
	frame:Int,
	?chunkSize:Int,
	?yOffset:Int,
	?delay:Float,
}