package;

import MmStringTools.*;
import openfl.display.IBitmapDrawable;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.text.TextLineMetrics;
import poke.sexy.SexyState;

/**
 * Graphics for the streaming tablet which appears during the sex scenes
 *
 * The tablet captures the window graphics periodically, distorts them and
 * shows them back, and also provides a fake streaming website with chat,
 * viewer count, and "likes"
 */
class Tablet extends FlxGroup
{
	private static var MAGN_EMOJIS:Array<Int> = [0, 1, 2, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 22, 23];
	private static var MALE_EMOJIS:Array<Int> = [0, 1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 17, 18, 19, 21, 22, 23];
	private static var FEMALE_EMOJIS:Array<Int> = [0, 1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 17, 18, 19, 20, 22, 23];

	/*
	 * When different pokemon are using toys, the camera defaults to the bottom
	 * of the screen (0.75). if this is unsuitable, this map lets you override
	 * it to the top (0.00) middle (0.50) or far bottom (1.00)
	 */
	private static var toyCamMap:Map<String, Float> = [
				"buiz" => 0.85,
				"hera" => 1.00,
				"luca" => 0.15,
				"grov" => 0.80,
				"sand" => 0.90,
				"magn" => 0.15,
			];

	/*
	 * Different people's names show up in the chat
	 */
	private static var CHAT_NAMES:Array<String> = [
				"Matsuku", "benguin", "Krokmou", "Patchhes", "kllza", "Dragonartw", "Yoshils", "PermHunter", "Phosaggro", "rossy105",
				"Pawn", "HolloNut", "AsterShock", "Fizz", "Kinikini", "Byclosser", "KamekSans", "soopersuus", "LaPatte", "Tiyahn005",
				"qualske98", "DartakkaNa", "totodice", "mianbao", "Tantroo", "spider111", "Chimaeraw", "Augmented", "uhhhhh", "Eraquis",
				"Notokottam", "RedChar", "Kiniesttt", "itachi0325", "Soran", "NeoArts", "Dreamous", "Nickelchad", "regls", "tommyzhong",
				"Toru", "EliValenti", "SkunkJam", "Talahut", "Darkmask", "Porphyrin", "Duez", "Guil", "nutty", "Linkgamer",
				"Alcubire", "argonvile", "JonNobo", "Asteyr", "wardawn", "yaatsuuu", "jubjun", "MStuarn", "BraeCor", "DarkM64",
				"Kiniest", "Fandramon", "ashplosh", "GipBandit", "Pepeluis", "Sashaviel", "bombly", "Wolfxz", "Kamezdov", "Komamura",
				"Furley", "karras", "JetSharky", "Vurnurs", "Ray517", "Seimei2", "ionadragon", "russia213", "Randall", "OR95",
				"Sharu", "Evan", "Deltads", "AyJay", "Dezo", "Ryin", "lanceness", "LeSkarmory", "Damaratus", "tygre",
				"N0gard", "Exons", "KeroKamina", "Darkmon", "Lolwut31", "Panshu", "Bolzan", "RyanZard90", "Darkgon", "Angstyteen",
				"Kilkakon",
			];

	/*
	 * Long vaguely englishy phrases. These are cut up and rearranged to make
	 * sentences in the chat window
	 */
	private static var LONG_PHRASES:Array<String> = [
				"Pema cit patute binap ohut edo vit nidisab. Ohimehu",
				"Moteyi otagerod teto pati ronabe. Egutes tatavil nitir",
				"Inu cakirab far; ratun pasenen cepisif cetol hena",
				"Mide ticer ca yeyon ceyap. Tulalil emahosi ge bawog",
				"Tu racey. Ociletel rigomiey for lale uteyopim adarir",
				"Ga etukig lugot corimit puyoles. Pol mecedis obato",
				"Aren neboro tanet? Cediduh se rin lop. Igehil nuci",
				"Heho fedexes oranes eranita irilol geta, ini sie sida",
				"Osadara opat ati otilic xecarut! Yo ehacih arieror",
				"Saca osorare ma runinod edi. Eri onatiyeg re ne ba;",
				"Neye irokatod tet fivec pi kifolan. Yierel senel gason",
				"Rinesa nonon yota. Iehikop oler sesiy tielap lie itadilif",
				"Netelit egamo ale ata togafa. Iewad risepa yatocuf",
				"Iperinu man irib yi rocieso esie asap saka hibiro.",
				"Locovu. Qories urecepon olin: Pip penoken yat sesener",
				"Hayas deniro pa. Nile yomahe nelahor rom ema eruh",
				"Acierecan ta: Tievucat arinin got cesacec ica minie",
				"Rihotub bote ceham niyicit lara ro? Gisane neniewi",
				"Kodeni leturi soteb dape ditagu le. Iyovimis cotib",
				"Na etu soxo ru sixor opuso; alene lihe obi adatiso",
				"Rugi nis? Sacihi isut netut orehiegi ekir cecosie re",
				"Pelec aba gew ime lu gare; ramipit hilovas gun di!",
				"Toraren egipiwi saced yameri. Asepubec yutaro toreg",
				"Le calusu xer; pideb keles bod etehehes renup! Ecu",
				"Ra rec otarim sebosie daseg, sef koni ebug ugaz awema",
				"Morasag eladonog pet cebap rob marata vet. Cose iratie",
				"Rap riluk necase lati erirod none. Rokatic yicar reni",
				"Emeratan lado te cien lines? Riti tomay lud tu besic",
				"Lir timerad? To raye nor wiesirax atadut lerilen rofeti.",
				"Rudi he fepatir bigi. Xec male siesimot gerar ro ladie",
				"Tix yot ditipet sihodo tet. Enase donuce ubo lasomeb",
				"Colatot rev olod ye ogop ye. Me ner so rieb tuse loloyet",
				"Tagite. Yer ieta la. Hi ci gocusi! Ogelete riem ecus",
				"Ociru. Nisopu tu si! Cecitie niciseg iromatas sopug",
				"Ro esen raleda ye igaceca pepa lah! Ro uronodo idiseta.",
				"Patel miwi ewodahie cet beme! Nosofib tesic onirem",
				"Lura. Bat ton leh irohih! Wi te tot derele hepo riereta",
				"Erodame gixeden sad voleha ma bilofep. Rimesiy tetac",
				"Naru tac zofih liy cademe gi. Boson serac ivocere",
				"Ieratili ronad be ler tona mekece! Niesi ciri notise",
				"Inanune ro napi du eteselo, sica olaw mi reha. Lotud",
				"Go. Natorol si yadu taf fit erocinib sot su tarerie",
				"Sa qipeye afar teqi; wake hi siropam bie kesi socit",
				"Paser ricemi sapacis dime iyinof ce locoseh cud. Hietide",
				"Sier nan. Ner tere uli buyu avone: Ani sahoriem cobo",
				"Cah se. Teneli icagejet tatan te saf cocupim se din",
				"Tatowu. Sebonup uhiva rabap higo oyetan. Elet epiperab",
				"Celiye ecap ienim niesoni epoto. Ieyi mahadim riper",
				"Oyamire yaganec mipas rub ca dapene raloye galo? Bohile",
				"Ici ratene henofi! Otudoka niramah cefac losen netoka",
				"Ponimix eyona dele tuletar dexo ejar bif posep perate",
				"Marow fahe inete mu. Neray laba ragev vet paronat de",
				"Oyela rat tepa. Tulen aranigiv tefa pupeso metere",
				"Laro sitar peceser babi lip rugay itemi pieser alu.",
				"Mi nina naha pat nobi. Ges se nere turo geleg, cahol",
				"Libib tet iebieqemet onori ne isobig gabicam. Iepawiet",
				"Isor safien ona. Tope ruh tatine rul ile losohac asasici",
				"Osotatal isunanar focos tinego otepitul conico qa",
				"Yime hije mige ne: Veg be dayuman uguy! Azawo ole",
				"Tare toruno. Tiquka gus asiwed iko vovuf cadiseb si.",
				"Ocelama eneb cipir ker. Ma davome getab va mesom eyiso",
				"Ce pe nele la heb ta semie, da sac nalesi natareg",
				"Gesu eru ri izatan xagator ne ilicaye tetix! Sidipob",
				"Cadi pefebit relon nelit edatafa ehasalit; cot socerov",
				"Esodir games tariw usibihic! Ade bol iemilot epuc",
				"Ba atagelas otebie. Redeti mirenep misomad lagitoh",
				"Sirem tozeku ahes ala gubuh col serutut lif ni ife,",
				"Le pid iti gere onod ese: Puh awo osiec sehi omiso",
				"Curale esicac. Minienad canod wun miep sinoci rul",
				"Pe fi ovar yiy. Neripa huca sin: Cesa no cete onaci",
				"Sisit sieniye pe; ata fen lie nabilet ogub eda sanusan.",
				"Hine gus cenier citibus teva nito sonet. Ri vitecit",
				"Kosedi alebeluk paro cacalac, mag nelapef omilerus",
				"Deneye teyis pa etaru ebay winehep peku! Camif sanesu",
				"Tow lebihas nale mesu. Ludepe rudahet ceseno fotak",
				"Kal lulut surel hu osa: Uhale alofiku galuni parijul",
				"Calog hinore hietagot nietuli tetiec hienohan. Nimap",
				"Roweben. Rosuwic anukieces aneso wapil sepo rute gur",
				"Ecat tu fel nol gitet esoyuger. Elinone api tolilan,",
				"Eran ruhag. Ce gegumay qodene utotima gosen rinomiev.",
				"Hanonet abo! Ierel ca va anegicie. Nilal gabe metefi",
				"Tetes kevat sicuy! Hi meroyas somihen ritira riseme",
				"Led sir unime. Cudis ipolad so; rotufi tesi got bidir",
				"Dey ufuraca monenic firih monit die titabo sas. Iba",
				"Rac cocabu lo se icimahoc turo oluya ladol tinu pe,",
				"Ietororas cofe luhacut si. Atoti ni niese ieti mod",
				"Aba irayo oba he ricob necup sidep yir sorieh. Yu seket",
				"Rarasu sehecer isosu ano. Irenu cieharuc werieca mapa.",
				"Neceye elilele cufete hoted hoho. Yeyo woxere cumeta",
				"Ibolasiy esegag ruyi raci. Dasici batim pamem nim love",
				"Tid. Ocet mirono meta tesud amiy? Qa kene ga nicari",
				"Waka lal esorap orin edenolic! Cinuna litanec niyiec",
				"Gudide. Cirot mimieren hito puze bicaga taxeseh ihut?",
				"Merep etanan tifef? Anotuve nenacil feg. Hiezi tovedov",
				"Lu arivune ranatab? Rahebox ibat ca lerere liec. Omopehoy",
				"Puro cekase ofefatan nef ratanot ielera asosil sonag.",
				"Ifucetis rovani imelos cala icefie rekise ladiehin.",
				"Fu. Qebuler cipemoc no. Yato sohec ramo hap les te",
				"Osog emet. Ohelase ge uso ocicef. Mot toteba siyi",
				"Latit tinemil nese ti. Decitie pine xeyaten amocili",
			];

	/*
	 * Short spammy phrases, like ascii art and "lol" and things which people
	 * type in chat.
	 */
	private static var SPAMMY_PHRASES:Array<String> = [
				"OGX", "OGC", "8====D", "8===D~~~", "8=======> ~~~~", "8======D~~~~~~", ":D~~~~~~", "@}~}~~~", "/X\\(‘-‘)/X\\", "/)^3^(\\",
				"><((((‘>", "(/.__.)/ \\(.__.\\)", "(/.__.)/", "\\(.__.\\)", "<(^^,)>", "(>'-')> <('-'<)", "^('-')^ v('-')v", "(^-^)", "<-|-‘_’-|->", "--{,_,\">",
				"@( * O * )@", "^O^", ":Q___", "???????", "ooooooooooooo", "E", "R", "7", "me", "<3",
				":3", "(<(<>(<>.(<>..<>).<>)<>)>)", "x3", "Hmmmm", ":D", ":P", "^^", "lol", "XD", "BARKBARKBARK",
				"Raaaaawr", "woof", "SQUAWK", "( o) ( o) - - - - - - (__(__)", "sorry", "Hi!", "WOTT OWO", "OwO", "AYYYY", "i try :3",
				"69?", "wok", "footjob, eh?", "aww.", "thta's cute", "aye", "',\" ,:-  '\"::::::::::::::.::-.-\" `-. ' ,-//", "I do!", "dude.", "Ah true",
				"fuck", "alright", "super", "good", "yus", "(>'-')> <('-'<) ^('-')^ v('-')v (>'-')> (^-^)", "yup", "AY IT ME", "g'day", "Allo ^^",
				"^^;", "^^", "thanks", "KY?", ":x", ":$$         seeee$$$Neeee           R$$$F$$$$F", ":3", "link?", "^^^^^^^^", "^^^^^^^6",
				"oops", "666", "Back", "^", ":D", "c-c-c-cumbobreaker", "x3", "__.....__        ,            .--/~         ~-._   /`", "cheeses? :D", "<w<",
				">w>", ">3<", ":>", "Yes :)", "shut up", "oh dear", "x3", ";-;", "^ yes", "omg",
				"zomg", "plz", "D A R K S O U L S", "yum yum", "/_\\_\\_\\       /_/_/_/_\\       /_\\_\\_\\_\\      /_/_/_/_/_\\", "...", "memes", ";w;", "yup ^^", "gay",
				"x3", ";.;", ";-;", "^.^", "niiiiice :3", "W T F", "wtf", "yeeeeeeeeeees", "awwww, geeze", "N I I I I I I I I I I I I I I I I I I I I I I C E",
			];

	private static var CHAT_COLORS:Array<Int> = [
				0xffed684a, // red
				0xffe89f16, // orange
				0xffffdf00, // yellow
				0xff9de721, // spring green
				0xff1cd562, // forest green
				0xff20e8b2, // aquamarine
				0xff3badde, // blue
				0xffc57ed9, // purple
				0xfffd92eb, // pink
				0xff876766, // brown
				0xffb99068, // tan brown
				0xff696780, // dark grey
				0xff858e9a, // light grey
			];

	private static var MAX_PREV_NAMES:Int = 8;
	// how many camera frames do we buffer, to create the illusion of stream delay?
	private static var CAMERA_DELAY:Int = 5;

	private var loadingSprite:FlxSprite;
	private var frameCycleCount:Int = 0;

	private var mx:Matrix = new Matrix();
	private var websiteBgGraphic:FlxSprite = new FlxSprite(0, 0, AssetPaths.website_bg__png);
	private var websiteGraphic:FlxSprite;
	// pokeCameras[0]=newest camera; pokeCameras[5]=oldest camera
	private var pokeCameras:Array<FlxSprite> = [];
	private var tabletScreen:FlxSprite;

	private var prevNameIndexes:Array<Int> = [];

	private var textPool:Array<FlxText> = [];
	private var textPoolIndex:Int = 0;

	private var texts:Array<FlxText> = [];
	private var emojiStamp:FlxSprite;
	private var badgeStamp:FlxSprite;
	private var textY:Float = 10;
	private var sexyState:SexyState<Dynamic>;

	private var visitorText:FlxText;
	private var randomVisitors:Int = 0;
	private var thumbText:FlxText;

	private var cameraPosition:FlxPoint = FlxPoint.get();
	private var camRefreshTimer:Float = 0.8;
	private var screenRefreshTimer:Float = 0;
	private var newTextTimer:Float = FlxG.random.float(5, 15);
	private var thumbTimer:Float = FlxG.random.float(4, 12);
	private var visitorTimer:Float = FlxG.random.float(3, 9);

	private var thumbCount:Int = 0;
	private var visitorCount:Int = 0;

	private var visualThumbCount:Int = 0;
	private var visualVisitorCount:Int = 0;

	public function new(sexyState:SexyState<Dynamic>)
	{
		super();

		this.sexyState = sexyState;
		var tabletFrame:FlxSprite = new FlxSprite(560, -5, AssetPaths.tablet_frame__png);
		var tabletShadow:FlxSprite = new FlxSprite(tabletFrame.x, tabletFrame.y, AssetPaths.tablet_shadow__png);
		tabletShadow.alpha = 0.25;

		websiteGraphic = new FlxSprite(0, 0);
		websiteGraphic.loadGraphic(AssetPaths.website_bg__png, false, 0, 0, true);

		loadingSprite = new FlxSprite();
		loadingSprite.loadGraphic(AssetPaths.tablet_loading__png, true, 42, 15);
		loadingSprite.animation.add("default", [0, 1, 2, 3, 4], 6, true);
		loadingSprite.animation.play("default");

		tabletScreen = new FlxSprite(560, -5);
		tabletScreen.makeGraphic(220, 160, FlxColor.TRANSPARENT, true);

		mx.identity();
		mx.rotate(Math.PI * 0.012);
		mx.scale(0.49, 0.46);
		mx.translate(32, 12);

		for (i in 0...CAMERA_DELAY + 1)
		{
			var pokeCamera:FlxSprite = new FlxSprite(13, 13);
			pokeCamera.makeGraphic(183, 181, FlxColor.TRANSPARENT, true);
			pokeCameras.push(pokeCamera);
		}

		thumbText = new FlxText(30, 205, 195, commaSeparatedNumber(thumbCount), 30);
		thumbText.color = 0xff6b6174;
		thumbText.font = AssetPaths.just_sayin__otf;

		visitorText = new FlxText(130, 205, 195, commaSeparatedNumber(visitorCount), 30);
		visitorText.color = 0xff6b6174;
		visitorText.bold = true;
		visitorText.font = AssetPaths.just_sayin__otf;

		add(tabletShadow);
		add(tabletScreen);
		add(tabletFrame);

		emojiStamp = new FlxSprite();
		emojiStamp.loadGraphic(AssetPaths.emojis__png, true, 11, 11);

		badgeStamp = new FlxSprite();
		badgeStamp.loadGraphic(AssetPaths.badges__png, true, 6, 7);

		while (prevNameIndexes.length < MAX_PREV_NAMES)
		{
			prevNameIndexes.push(FlxG.random.int(0, CHAT_NAMES.length - 1));
		}

		for (i in 0...50)
		{
			textPool.push(new FlxText(0, 0, 115));
		}
	}

	/**
	 * Converts a raw number of hearts into a thumbs-up count which scales exponentially
	 *
	 * @param	input how many hearts have been emitted during the sex scene
	 * @param	target a magic number whose purpose frightens and confuses me
	 * @return  a number vaguely corresponding to a thumbs-up count
	 */
	private function adjustForPopularity(input:Float, target:Float):Float
	{
		var result:Float = input;
		if (result >= target)
		{
			return result;
		}
		if (sexyState.popularity < 0)
		{
			// curve which builds slowly towards the target
			result = target * Math.pow(result / target, 1 - 2 * sexyState.popularity);
		}
		else if (sexyState.popularity > 0)
		{
			// fans join right away
			result += (target - result) * sexyState.popularity * 0.5;
		}
		return result;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		loadingSprite.update(elapsed);

		if (visible)
		{
			camRefreshTimer -= elapsed;
			if (camRefreshTimer <= 0)
			{
				camRefreshTimer = 0.8;

				if (DialogTree.isDialogging(sexyState._dialogTree))
				{
					// don't refresh camera; we're dialogging
				}
				else if (sexyState._activePokeWindow._canvas.alpha < 1.0)
				{
					// don't refresh camera; it looks goofy with partial opacity. (this can happen when mousing over during toy sequences)
				}
				else
				{
					var pokeCamera:FlxSprite = pokeCameras.pop();
					var prefix:String = PlayerData.PROF_PREFIXES[PlayerData.profIndex];
					if (sexyState.displayingToyWindow())
					{
						var yFactor:Float = 0.75;
						// toy window; lock the camera to the bottom
						cameraPosition.x = (sexyState._activePokeWindow._canvas.x) * 0.5 + (sexyState._activePokeWindow._canvas.x + sexyState._activePokeWindow._canvas.width - 183 - 3) * 0.5;
						if (toyCamMap[prefix] != null)
						{
							yFactor = toyCamMap[prefix];
						}
						cameraPosition.y = (sexyState._activePokeWindow._canvas.y) * (1 - yFactor) + (sexyState._activePokeWindow._canvas.y + sexyState._activePokeWindow._canvas.height - 181 - 3) * yFactor;
					}
					else if (FlxG.mouse.x < sexyState._activePokeWindow.x - 10 || FlxG.mouse.x > sexyState._activePokeWindow.x + sexyState._activePokeWindow.width + 10)
					{
						// mouse is somewhere weird; lock the camera to the middle
						cameraPosition.x = (sexyState._activePokeWindow._canvas.x) * 0.5 + (sexyState._activePokeWindow._canvas.x + sexyState._activePokeWindow._canvas.width - 183 - 3) * 0.5;
						cameraPosition.y = (sexyState._activePokeWindow._canvas.y) * 0.5 + (sexyState._activePokeWindow._canvas.y + sexyState._activePokeWindow._canvas.height - 181 - 3) * 0.5;
					}
					else
					{
						cameraPosition.x = FlxG.mouse.x - pokeCamera.width / 2;
						cameraPosition.y = FlxG.mouse.y - pokeCamera.height / 2;
					}

					cameraPosition.x = FlxMath.bound(cameraPosition.x, sexyState._activePokeWindow._canvas.x, sexyState._activePokeWindow._canvas.x + sexyState._activePokeWindow._canvas.width - 183 - 3);
					cameraPosition.y = FlxMath.bound(cameraPosition.y, sexyState._activePokeWindow._canvas.y, sexyState._activePokeWindow._canvas.y + sexyState._activePokeWindow._canvas.height - 181 - 3);

					// pixels.draw can draw from either an IBitmapDrawable or a BitmapData 
					// luckily, the pixels from a FlxSprite are a BitmapData
					// so we get a properly scaled screeny and then sample from it
					#if screenshot
					var drawSource:BitmapData = Screenshot.get().pixels;
					#else
					var drawSource:IBitmapDrawable = FlxG.stage;
					#end

					#if flash
					pokeCamera.pixels.copyPixels(FlxG.camera.buffer, new Rectangle(cameraPosition.x, cameraPosition.y, 183, 181), new Point());
					#else
					// This code is adapted from FlxScreenGrab.grab()
					// https://github.com/HaxeFlixel/flixel-addons/blob/95296191b4a583d3ce1e61383f4cde63dbda729c/flixel/addons/plugin/screengrab/FlxScreenGrab.hx
					//
					// Unfortunately it is slightly buggy, and draws parts of the screen with the wrong colors. This is possibly
					// due to shortcomings in OpenFL, see Flixel Addons issue #82; FlxScreenGrab doesn't match PrintScreen results
					// https://github.com/HaxeFlixel/flixel-addons/issues/82
					var bounds:Rectangle = new Rectangle(cameraPosition.x, cameraPosition.y, 183, 181);
					var m:Matrix = new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y);
					pokeCamera.pixels.draw(drawSource, m);
					#end
					pokeCamera.dirty = true;
					pokeCameras.insert(0, pokeCamera);
					frameCycleCount++;
				}
			}
		}

		thumbTimer -= elapsed;
		if (thumbTimer <= 0)
		{
			var rawT:Float = sexyState.totalHeartsEmitted + sexyState._heartEmitCount;
			rawT = adjustForPopularity(rawT, 600);
			thumbCount = Std.int(scaleNumber(rawT * 0.9) * 0.9);
			thumbCount = Std.int(FlxMath.bound(thumbCount, 0, 999999));

			var dir:Int = visualThumbCount > thumbCount ? -1 : 1;
			if (visualThumbCount != thumbCount)
			{
				var remainingThumbCount:Int = Math.ceil(Math.abs(visualThumbCount - thumbCount) * FlxG.random.float(0.2, 0.4));
				var timePerThumb:Float = 15 / Math.max(visualThumbCount + thumbCount, 6);
				if (thumbTimer <= 0.4)
				{
					var newThumbCount:Int = Math.ceil(Math.min((0.4 - thumbTimer) / timePerThumb, remainingThumbCount));
					visualThumbCount += newThumbCount * dir;
					thumbTimer += timePerThumb * newThumbCount;
				}

				thumbText.text = commaSeparatedNumber(Std.int(FlxMath.bound(visualThumbCount, 0, 9999)));
			}
			else
			{
				thumbTimer += 1.2;
			}

			thumbTimer = Math.max(thumbTimer, 0.4);
		}

		visitorTimer -= elapsed;
		if (visitorTimer <= 0)
		{
			var rawV:Float = 0.6 * (sexyState.totalHeartsEmitted + sexyState._heartEmitCount) + 0.4 * (sexyState._toyBank._dickHeartReservoir + sexyState._toyBank._foreplayHeartReservoir + sexyState._heartBank._dickHeartReservoir + sexyState._heartBank._foreplayHeartReservoir);
			rawV = adjustForPopularity(rawV, 600);
			if (sexyState._gameState >= 410)
			{
				rawV *= 0.05;
			}
			visitorCount = scaleNumber(rawV);
			visitorCount += randomVisitors;
			visitorCount = Std.int(FlxMath.bound(visitorCount, 0, 999999));

			for (i in 0...10)
			{
				if (FlxG.random.float() * (visualVisitorCount + 5) < 50)
				{
					break;
				}
				randomVisitors = Std.int(FlxMath.bound(randomVisitors + FlxG.random.int( -1, 1), 0, 20));
			}

			var dir:Int = visualVisitorCount > visitorCount ? -1 : 1;
			if (visualVisitorCount != visitorCount)
			{
				var remainingVisitorCount:Int = Math.ceil(Math.abs(visualVisitorCount - visitorCount) * FlxG.random.float(0.2, 0.4));
				var timePerVisitor:Float = 8 / Math.max(visualVisitorCount + visitorCount, 6);
				if (thumbTimer <= 0.4)
				{
					var newVisitorCount:Int = Math.ceil(Math.min((0.4 - thumbTimer) / timePerVisitor, remainingVisitorCount));
					visualVisitorCount += newVisitorCount * dir;
					visitorTimer += timePerVisitor * newVisitorCount;
				}

				visitorText.text = commaSeparatedNumber(Std.int(FlxMath.bound(visualVisitorCount, 0, 9999)));

				// as new visitors get added, we may need to reduce newTextTimer
				if (newTextTimer > 90 / visualVisitorCount)
				{
					newTextTimer = FlxG.random.float(30, 90) / Math.max(1, visualVisitorCount);
				}
			}
			else
			{
				visitorTimer += 1.2;
			}

			visitorTimer = Math.max(visitorTimer, 0.4);
		}

		if (visible)
		{
			newTextTimer -= elapsed;
			screenRefreshTimer -= elapsed;
			if (screenRefreshTimer <= 0)
			{
				screenRefreshTimer = 0.16;

				if (newTextTimer <= 0)
				{
					var newChatCount:Int = 0;
					do
					{
						newChatCount++;
						generateChatMessage();
						newTextTimer += FlxG.random.float(30, 90) / Math.max(1, visualVisitorCount);
					}
					while (newTextTimer <= 0 && newChatCount < 8);
					newTextTimer = Math.max(newTextTimer, 0);

					if (textY > 242)
					{
						for (text in texts)
						{
							text.y -= (textY - 242);
						}
						if (texts[0].y < -10)
						{
							var firstOnscreenTextIndex:Int = 1;
							while (texts[firstOnscreenTextIndex].y < -10)
							{
								firstOnscreenTextIndex++;
							}
							texts.splice(0, firstOnscreenTextIndex - 1);
						}
						textY = 242;
					}
				}

				websiteGraphic.stamp(websiteBgGraphic);

				for (text in texts)
				{
					websiteGraphic.stamp(text, Std.int(text.x), Std.int(text.y));
				}

				var pokeCamera:FlxSprite = pokeCameras[pokeCameras.length - 1];
				websiteGraphic.stamp(pokeCamera, Std.int(pokeCamera.x), Std.int(pokeCamera.y));
				FlxSpriteUtil.drawRect(websiteGraphic, 13, 13, 183, 181, 0x30404040);

				websiteGraphic.stamp(visitorText, Std.int(visitorText.x), Std.int(visitorText.y));
				websiteGraphic.stamp(thumbText, Std.int(thumbText.x), Std.int(thumbText.y));

				if (frameCycleCount <= CAMERA_DELAY)
				{
					websiteGraphic.stamp(loadingSprite, 13 + Std.int(183 * 0.5 - loadingSprite.width * 0.5), 13 + Std.int(181 * 0.5 - loadingSprite.height * 0.5));
				}

				tabletScreen.pixels.draw(websiteGraphic.pixels, mx);
				tabletScreen.dirty = true;
			}
		}
	}

	/**
	 * Scales a raw heart count ranging linearly from [0-960] into a more
	 * exciting number ranging from [0-1,000] or so
	 * @param	i raw heart count
	 * @return scaled number
	 */
	function scaleNumber(i:Float)
	{
		var out:Float = i * 0.3;
		if (i > 40) out += (i - 40) * 0.3;
		if (i > 80) out += (i - 80) * 0.7;
		if (i > 160) out += (i - 160) * 0.9;
		if (i > 240) out += (i - 240) * 1.2;
		if (i > 320) out += (i - 320) * 2.2;
		if (i > 400) out += (i - 400) * 4;
		if (i > 480) out += (i - 480) * 7;
		return Std.int(out);
	}

	private function generateChatMessage():Void
	{
		var nameIndex:Int = 0;
		if (visualVisitorCount == 0)
		{
			// no visitors; don't generate chat message
			return;
		}
		else if (FlxG.random.int(0, visualVisitorCount) > 20 || FlxG.random.bool(6))
		{
			// a new visitor says something
			nameIndex = FlxG.random.int(0, CHAT_NAMES.length - 1);
			if (FlxG.random.bool(30))
			{
				// and they're sticking around to chat
				prevNameIndexes.insert(0, nameIndex);
				prevNameIndexes.splice(MAX_PREV_NAMES, prevNameIndexes.length - MAX_PREV_NAMES);
			}
		}
		else {
			// a familiar visitor says something
			nameIndex = prevNameIndexes[FlxG.random.int(0, Std.int(Math.min((visualVisitorCount - 1) * 0.6, prevNameIndexes.length - 1)))];
		}

		var chatName:String = CHAT_NAMES[nameIndex];
		var badges:Int = 0;
		if (nameIndex <= 0.015 * CHAT_NAMES.length)
		{
			// both badges
			badges = 3;
			chatName = "__ " + chatName;
		}
		else if (nameIndex % 13 == 0)
		{
			// badge #1
			badges = 1;
			chatName = "_ " + chatName;
		}
		else if (nameIndex % 7 == 0)
		{
			// badge #2
			badges = 2;
			chatName = "_ " + chatName;
		}
		var tx0:FlxText = popTextPool();
		tx0.setPosition(210, textY);
		tx0.text = chatName + ": ";
		tx0.color = CHAT_COLORS[nameIndex % CHAT_COLORS.length];

		if (badges > 0)
		{
			tx0.draw();
			if (badges == 1)
			{
				badgeStamp.animation.frameIndex = 0;
				tx0.stamp(badgeStamp, 2, 3);
			}
			else if (badges == 2)
			{
				badgeStamp.animation.frameIndex = 1;
				tx0.stamp(badgeStamp, 2, 3);
			}
			else if (badges == 3)
			{
				badgeStamp.animation.frameIndex = 0;
				tx0.stamp(badgeStamp, 2, 3);
				badgeStamp.animation.frameIndex = 1;
				tx0.stamp(badgeStamp, 8, 3);
			}
		}
		texts.push(tx0);

		var tx1:FlxText = popTextPool();
		tx1.text = "";
		tx1.setPosition(210, textY);
		tx1.color = 0xc6c3c6;
		var spaceCount:Int = Math.ceil(tx0.textField.textWidth / 3);
		while (tx1.text.length < spaceCount)
		{
			tx1.text += " ";
		}

		var emojiCount:Int = 0;
		var varyEmoji:Bool = true;
		if (FlxG.random.bool(6))
		{
			// message with tons of the same emoji
			emojiCount = FlxG.random.int(3, 10);
			varyEmoji = false;
		}
		else if (FlxG.random.bool(6))
		{
			// message with one or two emoji
			emojiCount = FlxG.random.getObject([1, 2, 3], [9, 3, 1]);
		}
		else if (FlxG.random.bool(20))
		{
			// message with text and one or two emoji
			emojiCount = FlxG.random.getObject([1, 2, 3], [9, 3, 1]);
			tx1.text += generateRandomText(nameIndex);
		}
		else {
			// message with only text
			emojiCount = 0;
			tx1.text += generateRandomText(nameIndex);
		}

		if (emojiCount > 0)
		{
			// add emojis
			if (tx1.text.length == 0 || tx1.text.charAt(tx1.text.length - 1) != " ")
			{
				// emojis look better some padding
				tx1.text += " ";
			}
			tx1.draw();
			var lastLine:TextLineMetrics = tx1.textField.getLineMetrics(tx1.textField.numLines - 1);

			emojiCount = Std.int(Math.min(emojiCount, (115 - (lastLine.x + lastLine.width)) / 12));

			randomEmoji();
			for (i in 0...emojiCount)
			{
				tx1.stamp(emojiStamp, Std.int(lastLine.x + lastLine.width) + 12 * i, 10 * (tx1.textField.numLines - 1) + 1);
				if (varyEmoji)
				{
					randomEmoji();
				}
			}
		}
		texts.push(tx1);

		textY += tx1.textField.textHeight + 4;
	}

	function randomEmoji()
	{
		if (sexyState._activePokeWindow._prefix == "magn")
		{
			// magnezone emojis
			emojiStamp.animation.frameIndex = FlxG.random.getObject(MAGN_EMOJIS);
		}
		else if (sexyState._male)
		{
			// male emojis
			emojiStamp.animation.frameIndex = FlxG.random.getObject(MALE_EMOJIS);
		}
		else
		{
			// female emojis
			emojiStamp.animation.frameIndex = FlxG.random.getObject(FEMALE_EMOJIS);
		}
	}

	function popTextPool()
	{
		textPoolIndex = (textPoolIndex + 1) % textPool.length;
		return textPool[textPoolIndex];
	}

	function generateRandomText(nameIndex:Int):String
	{
		if (FlxG.random.bool(15))
		{
			// spammy phrase
			return FlxG.random.getObject(SPAMMY_PHRASES);
		}
		else {
			var longPhrase:String = FlxG.random.getObject(LONG_PHRASES);
			var len:Int = Std.int(Math.min(FlxG.random.int(3, longPhrase.length), FlxG.random.int(3, longPhrase.length)));
			var subPhrase:String = longPhrase.substring(0, len);
			if (FlxG.random.bool(20) || (nameIndex + 3) % 11 == 0)
			{
				subPhrase = subPhrase.toLowerCase();
			}
			else if (FlxG.random.bool(5))
			{
				subPhrase = subPhrase.toUpperCase();
			}
			return subPhrase;
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		loadingSprite = FlxDestroyUtil.destroy(loadingSprite);
		mx = null;
		websiteBgGraphic = FlxDestroyUtil.destroy(websiteBgGraphic);
		websiteGraphic = FlxDestroyUtil.destroy(websiteGraphic);
		pokeCameras = FlxDestroyUtil.destroyArray(pokeCameras);
		tabletScreen = FlxDestroyUtil.destroy(tabletScreen);
		prevNameIndexes = null;
		textPool = FlxDestroyUtil.destroyArray(textPool);
		texts = FlxDestroyUtil.destroyArray(texts);
		emojiStamp = FlxDestroyUtil.destroy(emojiStamp);
		badgeStamp = FlxDestroyUtil.destroy(badgeStamp);
		visitorText = FlxDestroyUtil.destroy(visitorText);
		thumbText = FlxDestroyUtil.destroy(thumbText);
		cameraPosition = FlxDestroyUtil.put(cameraPosition);
	}
}