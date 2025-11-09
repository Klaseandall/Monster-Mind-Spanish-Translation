package demo;
import flixel.FlxState;
import flixel.text.FlxText;

/**
 * A demo which shows passwords being scrambled and unscrambled.
 */
class BinaryStringTest extends FlxState
{
	var textY:Int = 0;

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();

		// hash/unhash
		{
			var b:BinaryString = BinaryString.fromAlphanumeric("3LL");
			var original:String = b.toAlphanumeric(3);
			b.hash("HG");
			var hashed:String = b.toAlphanumeric(3);
			b.hash("HG");
			var unhashed:String = b.toAlphanumeric(3);
			addText(original + " -> " + hashed + " -> " + unhashed);
		}

		// readInt
		{
			var b:BinaryString = new BinaryString();
			b.writeInt(6, 3);
			b.writeInt(14, 4);
			b.writeInt(25, 5);
			addText(b.readInt(3) + "=6 " + b.readInt(4) + "=14 " + b.readInt(5) + "=25");
		}

		// shuffle/unshuffle
		{
			addText(BinaryString.shuffle("ABCDEF") + "=ABECDF");
			addText(BinaryString.shuffle("ABCDEFG") + "=DFACGEB");
			addText(BinaryString.shuffle("ABCDEFGH") + "=HFADCGEB");
			addText(BinaryString.shuffle("ABCDEFGHI") + "=FDCHBIGEA");
			addText(BinaryString.shuffle("ABCDEFGHIJ") + "=AJDFHCIBEG");
			addText(BinaryString.unshuffle("ABECDF") + "=ABCDEF");
			addText(BinaryString.unshuffle("DFACGEB") + "=ABCDEFG");
			addText(BinaryString.unshuffle("HFADCGEB") + "=ABCDEFGH");
			addText(BinaryString.unshuffle("FDCHBIGEA") + "=ABCDEFGHI");
			addText(BinaryString.unshuffle("AJDFHCIBEG") + "=ABCDEFGHIJ");
		}

		// alphanumeric/binarystring
		{
			var b0:BinaryString = new BinaryString();
			b0.writeInt(6, 3);
			b0.writeInt(14, 4);
			b0.writeInt(25, 5);
			addText("toAlphanumeric: " + b0.toAlphanumeric(10));

			var alphanumeric:String = b0.toAlphanumeric(10);

			var b1:BinaryString = BinaryString.fromAlphanumeric(alphanumeric);
			addText(b1.readInt(3) + "=6 " + b1.readInt(4) + "=14 " + b1.readInt(5) + "=25");
		}
	}

	function addText(s:String):Void
	{
		add(new FlxText(0, textY, 0, s));
		textY += 12;
	}
}