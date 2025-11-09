package;
import flixel.FlxG;

/**
 * A collection of string utility functions for MonsterMind
 */
class MmStringTools
{
	private static var CENSORED_WORDS:Array<String> = ["@*&%", "@!*#", "#!*&", "#*@%", "!#@*", "!@#&", "%&!@", "%#!*", "&%!#", "&!%@", "*&%@", "*%&#"];

	public static function substringBetween(Str:String, Open:String, Close:String):String
	{
		if (Str == null || Open == null || Close == null)
		{
			return null;
		}
		var start:Int = Str.indexOf(Open);
		if (start != -1)
		{
			var end:Int = Str.indexOf(Close, start + Open.length);
			if (end != -1)
			{
				return Str.substring(start + Open.length, end);
			}
		}
		return null;
	}

	public static function substringBefore(Str:String, Separator:String):String
	{
		if (Str == null || Str == "" || Separator == null)
		{
			return Str;
		}
		if (Separator == "")
		{
			return "";
		}
		var pos:Int = Str.indexOf(Separator);
		if (pos == -1)
		{
			return Str;
		}
		return Str.substring(0, pos);
	}

	public static function substringAfter(Str:String, Separator:String):String
	{
		if (Str == null || Str == "")
		{
			return Str;
		}
		if (Separator == null)
		{
			return "";
		}
		var pos:Int = Str.indexOf(Separator);
		if (pos == -1)
		{
			return "";
		}
		return Str.substring(pos + Separator.length);
	}

	/**
	 * Capitalize the first character of the string
	 */
	public static function capitalize(str:String):String
	{
		var strLen:Int = 0;
		if (str == null || (strLen = str.length) == 0)
		{
			return str;
		}
		var firstChar:String = str.substr(0, 1);
		var newChar:String = firstChar.toUpperCase();
		if (firstChar == newChar)
		{
			// already capitalized
			return str;
		}
		return newChar + str.substr(1, str.length - 1);
	}

	public static function isUpperCaseLetter(s:String):Bool
	{
		return s >= "A" && s <= "Z";
	}

	public static function isLetter(s:String):Bool
	{
		return s >= "A" && s <= "Z" || s >= "a" && s <= "z";
	}

	public static function isConsonant(text:String, ?y:Bool=false):Bool
	{
		return (y?"BCDFGHJKLMNPQRSTVWXYZ":"BCDFGHJKLMNPQRSTVWXZ").indexOf(text.toUpperCase()) != -1;
	}

	public static function isVowel(text:String, ?y:Bool=true):Bool
	{
		return (y?"AEIOUY":"AEIOU").indexOf(text.toUpperCase()) != -1;
	}

	/**
	 * Capitalize the first character of every word.
	 */
	public static function capitalizeWords(text:String):String
	{
		text = text.toUpperCase();
		var buf:StringBuf = new StringBuf();
		buf.add(text.charAt(0));
		for (i in 1...text.length)
		{
			if (isUpperCaseLetter(text.charAt(i)) && isUpperCaseLetter(text.charAt(i - 1)))
			{
				buf.add(text.charAt(i).toLowerCase());
			}
			else
			{
				buf.add(text.charAt(i));
			}
		}
		return buf.toString();
	}

	public static function beforePipe(Str:String):String
	{
		if (Str.indexOf("|") == -1)
		{
			return Str;
		}
		return substringBefore(Str, "|");
	}

	public static function afterPipe(Str:String):String
	{
		if (Str.indexOf("|") == -1)
		{
			return Str;
		}
		return substringAfter(Str, "|");
	}

	public static function bothPipe(Str:String):String
	{
		return StringTools.replace(Str, "|", " ");
	}

	public static function stretch(name:String):String
	{
		if (name == null)
		{
			return null;
		}
		var repeatArray:Array<Int> = [];
		var repeatCount:Int = 0;
		for (i in 0...name.length)
		{
			if (isVowel(name.charAt(i)))
			{
				repeatCount += 4;
				repeatArray[i] = 4;
			}
			if (repeatCount >= 8)
			{
				break;
			}
		}
		if (repeatCount <= 8)
		{
			// no vowels? weird name...
			if (name.length >= 5)
			{
				if (repeatCount <= 8 && repeatArray[name.length - 2] == 0 && isLetter(name.charAt(name.length - 2))) { repeatArray[name.length - 2] = 4; repeatCount += 4; }
				if (repeatCount <= 8 && repeatArray[name.length - 4] == 0 && isLetter(name.charAt(name.length - 4))) { repeatArray[name.length - 4] = 4; repeatCount += 4; }
			}
			else if (name.length >= 3)
			{
				if (repeatCount <= 8 && repeatArray[name.length - 1] == 0 && isLetter(name.charAt(name.length - 1))) { repeatArray[name.length - 1] = 4; repeatCount += 1; }
				if (repeatCount <= 8 && repeatArray[name.length - 2] == 0 && isLetter(name.charAt(name.length - 2))) { repeatArray[name.length - 2] = 4; repeatCount += 2; }
			}
			else if (name.length >= 1)
			{
				if (repeatCount <= 8 && repeatArray[name.length - 1] == 0 && isLetter(name.charAt(name.length - 1))) { repeatArray[name.length - 1] = 4; repeatCount += 1; }
			}
		}
		var stretched:String = "";
		for (i in 0...name.length)
		{
			if (repeatArray[i] != 0)
			{
				for (j in 0...repeatArray[i])
				{
					if (stretched.length > 0 && isLetter(stretched.charAt(stretched.length-1)))
					{
						stretched += name.charAt(i).toLowerCase();
					}
					else
					{
						stretched += name.charAt(i);
					}
				}
			}
			else
			{
				stretched += name.charAt(i);
			}
		}
		return stretched;
	}

	public static function englishNumber(i:Int):String
	{
		if (i < 0 || i > 20)
		{
			return commaSeparatedNumber(i);
		}
		return ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
		"ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen", "twenty"][i];
	}

	public static function moneyString(price:Int):String
	{
		return commaSeparatedNumber(price) + "$";
	}

	public static function commaSeparatedNumber(i:Int):String
	{
		if (i < 0)
		{
			return "-" + commaSeparatedNumber(Std.int(Math.abs(i)));
		}
		var result = Std.string(i);
		if (result.length > 6)
		{
			result = result.substring(0, result.length - 6) + "," + result.substring(result.length - 6);
		}
		if (result.length > 3)
		{
			result = result.substring(0, result.length - 3) + "," + result.substring(result.length - 3);
		}
		return result;
	}

	static public function bowdlerize(s:String, profanity:String):String
	{
		var result:String = s;
		var i:Int = 0;
		do {
			i = result.toLowerCase().indexOf(profanity.toLowerCase());
			if (i > -1)
			{
				result = result.substr(0, i) + FlxG.random.getObject(CENSORED_WORDS) + result.substr(i + 4);
			}
		}
		while (i > -1);
		return result;
	}
}