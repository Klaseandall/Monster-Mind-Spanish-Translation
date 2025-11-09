package;
import flixel.FlxState;
import flixel.math.FlxMath;

/**
 * A string like "00101011010101011010101", with several utility functions
 */
class BinaryString
{
	private static var CHECKSUM_INTS:Array<Int> = [
				608356525, 403119806, 600082856, 501903605, 395995676,
				639983625, 520697153, 373011710, 481025613, 609081731,
				423005485, 362660979, 736545212, 334902753, 172235946,
				995274085, 518629176, 285694472, 421177161, 558665377,
				324282222, 360158599, 878917102, 868418206, 481304371,
				975617486, 284706427, 927526243, 861246474, 241390708,
				689060809, 976999545, 989781527, 323910607, 635771485,
				627673660, 112575133, 599103942, 422611191, 833680556,
				246423091, 877687856, 440233940, 674718290, 769786302,
				251938542, 558968770, 695034124, 588955750, 641879279,
				772658258, 736177599, 680518529, 514691103, 897768422,
				142764968, 745785222, 940625572, 745145654, 621274084,
				576319507, 202006004, 956856885, 225397510, 908993516,
				827097658, 824553838, 698243440, 287555233, 695171056,
				611240526, 877537650, 816292354, 830244639, 966764077,
				166510545, 544190140, 337634650, 438485562, 786330704,
				164532512, 551752949, 258288608, 118631355, 581662189,
				780678019, 183604061, 833274178, 256709138, 377882729,
				782366535, 739375209, 337783228, 848717587, 478815886,
				903176896, 466108725, 639641238, 486777548, 986302837,
			];

	private static var ALPHA_CODES:String =
		"3" + // 00000
		"H" + // 00001
		"G" + // 00010
		"F" + // 00011
		"R" + // 00100
		"6" + // 00101
		"8" + // 00110
		"I" + // 00111
		"Q" + // 01000
		"W" + // 01001
		"J" + // 01010
		"5" + // 01011
		"X" + // 01100
		"T" + // 01101
		"K" + // 01110
		"Z" + // 01111
		"A" + // 10000
		"Y" + // 10001
		"7" + // 10010
		"O" + // 10011
		"9" + // 10100
		"4" + // 10101
		"P" + // 10110
		"D" + // 10111
		"U" + // 11000
		"C" + // 11001
		"E" + // 11010
		"S" + // 11011
		"M" + // 11100
		"N" + // 11101
		"B" + // 11110
		"L";  // 11111
	public var s:String = "";

	public function new()
	{
	}

	/**
	 * Accept an alphanumeric string like "ABC" and convert it to a binary string like "01001"
	 */
	public static function fromAlphanumeric(alphaString:String):BinaryString
	{
		var s:String = "";
		for (i in 0...alphaString.length)
		{
			var alphaIndex:Int = Std.int(FlxMath.bound(ALPHA_CODES.indexOf(alphaString.charAt(i)), 0, 31));
			s += intToBinaryString(alphaIndex, 5);
		}
		var binaryString:BinaryString = new BinaryString();
		binaryString.s = unshuffle(s);
		return binaryString;
	}

	public function writeInt(intToWrite:Int, binaryDigits:Int):Void
	{
		s += intToBinaryString(intToWrite, binaryDigits);
	}

	public function computeChecksum(digitsToRead:Int, digitsInChecksum:Int):Int
	{
		var checksum:Float = CHECKSUM_INTS[0];
		for (i in 0...digitsToRead)
		{
			if (s.charAt(i) == "0")
			{
				checksum += CHECKSUM_INTS[i % CHECKSUM_INTS.length];
			}
			else
			{
				checksum += CHECKSUM_INTS[(i + 17) % CHECKSUM_INTS.length];
			}
		}
		return Std.int(Math.abs(checksum % Math.pow(2, digitsInChecksum)));
	}

	public function readInt(binaryDigits:Int):Int
	{
		if (s.length < binaryDigits)
		{
			throw "Cannot read " + binaryDigits + " digits from string <" + s + ">";
		}
		var binarySubstring:String = s.substring(0, binaryDigits);
		s = s.substring(binaryDigits, s.length);
		return binaryStringToInt(binarySubstring);
	}

	public function ignore(binaryDigits:Int)
	{
		s = s.substr(binaryDigits);
	}

	private static function binaryStringToInt(s:String):Int
	{
		var result:Int = 0;
		while (s.length > 0)
		{
			result *= 2;
			if (s.charAt(0) == "1")
			{
				result += 1;
			}
			s = s.substring(1);
		}
		return result;
	}

	/**
	 * Accept an int like "15" and convert it to a 5-digit binary string like "00111"
	 */
	private static function intToBinaryString(num:Int, binaryLength:Int):String
	{
		var numToWrite = Std.int(FlxMath.bound(num, 0, Math.pow(2, binaryLength) - 1));
		var result:String = "";
		for (i in 0...binaryLength)
		{
			result = (numToWrite % 2 == 1 ? "1" : "0") + result;
			numToWrite = Std.int(numToWrite / 2);
		}
		return result;
	}

	/**
	 * Accept a string like "Abc def" and hash the current binary string with it.
	 */
	public function hash(string:String):Void
	{
		// first, compute the hash string to use for input...
		var hashString:String = string.toUpperCase();
		// "0" and "O" become identical hash values, in case people confuse them
		hashString = StringTools.replace(hashString, "0", "A");
		hashString = StringTools.replace(hashString, "O", "A");
		// "1" and "I" become identical hash values, in case people confuse them
		hashString = StringTools.replace(hashString, "1", "B");
		hashString = StringTools.replace(hashString, "I", "B");
		// " " and "." don't get included in the hash; they're too subtle and might get overlooked
		hashString = StringTools.replace(hashString, " ", "");
		hashString = StringTools.replace(hashString, ".", "");
		var hashBinaryString:BinaryString = fromAlphanumeric(hashString);

		// avoid empty hash, and avoid hashes from appearing letter-for-letter in the resulting string
		hashBinaryString.s = "10" + hashBinaryString.s;

		// apply the hash string to our "s" value
		var s2:String = "";
		for (i in 0...s.length)
		{
			if (hashBinaryString.s.charAt(i % hashBinaryString.s.length) == "1")
			{
				// invert value; 0 becomes 1, 1 becomes 0
				s2 += s.charAt(i) == "0" ? "1" : "0";
			}
			else
			{
				// preserve value; 0 stays as 0, 1 stays as 1
				s2 += s.charAt(i);
			}
		}
		s = s2;
	}

	public function toString():String
	{
		return "BinaryString<" + s + ">";
	}

	public function toAlphanumeric(stringLength:Int):String
	{
		var result:String = "";
		var sTmp:String = s;
		while (sTmp.length < stringLength * 5)
		{
			sTmp = sTmp + "0";
		}
		sTmp = shuffle(sTmp);

		for (i in 0...stringLength)
		{
			var binaryChar:String = sTmp.substring(0, 5);
			sTmp = sTmp.substring(5);
			binaryChar = binaryChar + "00000".substring(0, 5 - binaryChar.length);
			var binaryCharIndex:Int = binaryStringToInt(binaryChar);
			result += ALPHA_CODES.charAt(binaryCharIndex);
		}
		return result;
	}

	public static function shuffle(inStr:String):String
	{
		var str:String = inStr;
		str = oneShuffle(str, 2);
		str = oneShuffle(str, 3);
		str = oneShuffle(str, 5);
		return str;
	}

	private static function oneShuffle(inStr:String, parts:Int)
	{
		var strs:Array<String> = [];
		for (i in 0...parts)
		{
			strs[i] = "";
		}
		for (i in 0...inStr.length)
		{
			var j:Int = i % parts;
			if (j % 2 == 0)
			{
				strs[j] = inStr.charAt(i) + strs[j];
			}
			else
			{
				strs[j] = strs[j] + inStr.charAt(i);
			}
		}
		var result:String = "";
		for (str in strs)
		{
			result += str;
		}
		return result;
	}

	public static function unshuffle(inStr:String):String
	{
		var str:String = inStr;
		str = oneUnshuffle(str, 5);
		str = oneUnshuffle(str, 3);
		str = oneUnshuffle(str, 2);
		return str;
	}

	private static function oneUnshuffle(inStr:String, parts:Int)
	{
		// divide string into n fragments...
		var strs:Array<String> = [];
		var l:Int = 0;
		var r:Int = 0;
		var leftover:Int = inStr.length % parts;
		for (i in 0...parts)
		{
			r += Std.int(inStr.length / parts);
			if (leftover > 0)
			{
				r++;
				leftover--;
			}
			strs[i] = inStr.substring(l, r);
			l = r;
		}

		// unjumble the n fragments into a different string
		var result:String = "";
		for (i in 0...inStr.length)
		{
			var j:Int = i % parts;
			if (j % 2 == 0)
			{
				result += strs[j].charAt(strs[j].length - Std.int(i / parts) - 1);
			}
			else
			{
				result += strs[j].charAt(Std.int(i / parts));
			}
		}
		return result;
	}

	public function pad(desiredBitCount:Int)
	{
		if (s.length > desiredBitCount)
		{
			throw "BinaryString length exceeds pad: " + s.length + " > " + desiredBitCount;
		}
		while (s.length < desiredBitCount)
		{
			s += "0";
		}
	}
}