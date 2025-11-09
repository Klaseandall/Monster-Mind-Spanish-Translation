package;

import MmStringTools.*;
import flixel.FlxG;
import poke.hera.HeraShopDialog;
import openfl.utils.Object;

/**
 * BadItemDescriptions provides all of Kecleon's weird descriptions when he
 * runs the store.
 */
class BadItemDescriptions
{
	private static var itemQualities:Map<Int, ItemQuality> = new Map<Int, ItemQuality>();

	private static var descriptionCache:Map<ItemDatabase.ShopItem, Array<Array<Object>>>;
	private static var intros:ConversationList;
	private static var descriptions:ConversationList;
	private static var successfulPurchases:ConversationList;

	public static function initialize(?force:Bool = false)
	{
		if (!force && descriptionCache != null)
		{
			// already initialized
			return;
		}

		descriptionCache = new Map<ItemDatabase.ShopItem, Array<Array<Object>>>();
		intros = new ConversationList();
		descriptions = new ConversationList();
		successfulPurchases = new ConversationList();

		var crumbly:Adjective = new Adjective("a|crumbly", "a|crumblier", "crumbliest", "crumbliness");
		crumbly.addNoun("a|piece of chalk", "some|pieces of chalk");
		crumbly.addNoun("a|sand castle", "a couple of|sand castles");
		crumbly.addNoun("drywall", "a bunch of|things of drywall");

		var flat:Adjective = new Adjective("a|flat", "a|flatter", "flattest", "flatness");
		flat.addNoun("a|rug", "some|rugs");
		flat.addNoun("a|waffle", "a stack of|waffles");
		flat.addNoun("a|frisbee", "a bunch of|frisbees");
		flat.addNoun("a|tortilla", "a couple|tortillas");

		var tasty:Adjective = new Adjective("a|delicious", "a|more delicious", "most delicious", "deliciousness");
		tasty.addNoun("tarts","a bunch of|tarts");
		tasty.addNoun("a|thick steak","a couple of|thick steaks");
		tasty.addNoun("teriyaki sauce", "some things of|teriyaki sauce");

		var circular:Adjective = new Adjective("a|disc-shaped", "a|more disc-shaped", "most disc-shaped", "disc-shapedness");
		circular.addNoun("a|DVD","a bunch of|DVDs");
		circular.addNoun("a|mug","some|mugs");
		circular.addNoun("a|clock", "a couple|clocks");
		circular.addNoun("a|manhole cover", "a couple of|manhole covers");

		var sciencey:Adjective = new Adjective("a|sciencey", "a|sciencier", "scienciest", "scienciness");
		sciencey.addNoun("a|graduated cylinder", "some|graduated cylinders");
		sciencey.addNoun("a|bunsen burner", "a couple of|bunsen burners");
		sciencey.addNoun("uranium", "some things of|uranium");
		sciencey.addNoun("protective goggles", "some|protective goggles");

		var drab:Adjective = new Adjective("a|drab", "a|more drab", "most drab", "drabness");
		drab.addNoun("a|rock", "a couple|rocks");
		drab.addNoun("smog", "some|smog clouds");
		drab.addNoun("loafers", "some pairs of|loafers");

		var geek:Adjective = new Adjective("a|geeky", "a|geekier", "geekiest", "geekiness");
		geek.addNoun("some|magic cards", "a big binder of|magic cards");
		geek.addNoun("a|20-sided die", "a handful of|20-sided dice");
		geek.addNoun("a|board game", "a bunch of|board games");
		geek.addNoun("a|wall-mounted bat'leth", "a gallery of|wall-mounted bat'leths");

		var rectangle:Adjective = new Adjective("a|rectangle", "a|more rectangle shaped", "most rectangle shaped", "rectangleness");
		rectangle.addNoun("an|index card", "a couple|index cards");
		rectangle.addNoun("a|shoebox", "a bunch of|shoeboxes");
		rectangle.addNoun("a|smartphone", "some|smartphones");
		rectangle.addNoun("a|refrigerator", "a few|refrigerators");

		var caustic:Adjective = new Adjective("a|caustic", "a|more caustic", "most caustic", "causticness");
		caustic.addNoun("battery acid", "a bunch of|battery acid");
		caustic.addNoun("chlorine", "some things of|chlorine");
		caustic.addNoun("drain cleaner", "some cartons of|drain cleaner");

		var cylindrical:Adjective = new Adjective("a|cylindrical", "a|more cylindrical", "most cylindrical", "cylinderness");
		cylindrical.addNoun("a|garbage can", "a couple of|garbage cans");
		cylindrical.addNoun("a|handheld telescope", "a bunch of|handheld telescopes");
		cylindrical.addNoun("a|prosthetic leg", "some|prosthetic legs");
		cylindrical.addNoun("a|tampon", "a whole slew of|tampons");

		var medical:Adjective = new Adjective("a|medical", "a|more medical", "most medical", "medicalness");
		medical.addNoun("an|EKG machine", "a bunch of|EKG machines");
		medical.addNoun("a|vaccine", "a couple of|vaccines");
		medical.addNoun("a|scalpel", "a few|scalpels");
		medical.addNoun("a|tongue depressor", "a few|tongue depressors");
		medical.addNoun("an|ambulance", "a fleet of|ambulances");

		var cosmetic:Adjective = new Adjective("a|cosmetic", "a|more cosmetic", "most cosmetic", "cosmeticness");
		cosmetic.addNoun("a|cuticle pusher", "a bunch of|cuticle pushers");
		cosmetic.addNoun("a|brush case", "a couple of|brush cases");
		cosmetic.addNoun("a|waxing kit", "a bunch of|waxing kits");
		cosmetic.addNoun("lipstick", "some things of|lipstick");

		var cleaning:Adjective = new Adjective("a|cleaning", "a|more cleaning", "most cleaning", "cleaningness");
		cleaning.addNoun("a|mop", "a closet full of|mops");
		cleaning.addNoun("a|feather duster", "some|feather dusters");
		cleaning.addNoun("a|roomba", "a bunch of|roombas");
		cleaning.addNoun("a|housekeeper", "a couple|housekeepers");

		var relaxing:Adjective = new Adjective("a|relaxing", "a|more relaxing", "most relaxing", "relaxingness");
		relaxing.addNoun("a|beer", "a couple of|beers");
		relaxing.addNoun("a|croquet set", "some|croquet sets");
		relaxing.addNoun("a|recliner", "a few|recliners");
		relaxing.addNoun("bath salts", "some|bath salts");

		var pungent:Adjective = new Adjective("a|pungent", "a|more pungent", "most pungent", "pungentness");
		pungent.addNoun("an|air freshener", "a couple of|air fresheners");
		pungent.addNoun("garlic", "some cloves of|garlic");
		pungent.addNoun("axe body spray", "some things of|axe body spray");
		pungent.addNoun("a|durian", "a bunch of|durians");

		var pointy:Adjective = new Adjective("a|pointy", "a|pointier", "pointiest", "pointiness");
		pointy.addNoun("a|cactus", "a couple of|cacti");
		pointy.addNoun("a|thumbtack", "a handful of|thumbtacks");
		pointy.addNoun("a|letter opener", "a bunch of|letter openers");
		pointy.addNoun("a|shark tooth necklace", "a couple|shark tooth necklaces");

		var romantic:Adjective = new Adjective("a|romantic", "a|more romantic", "most romantic", "romanticness");
		romantic.addNoun("a|long-stemmed rose", "a bouquet of|long-stemmed roses");
		romantic.addNoun("a|box of chocolates", "a couple|boxes of chocolates");
		romantic.addNoun("lingerie", "some nice pieces of|lingerie");
		romantic.addNoun("massage oil", "some things of|massage oil");

		var shiny:Adjective = new Adjective("a|shiny", "a|shinier", "shiniest", "shininess");
		shiny.addNoun("a|bauble", "a collection of|baubles");
		shiny.addNoun("a|geode", "a whole bunch of|geodes");
		shiny.addNoun("a|space shuttle", "a couple|space shuttles");
		shiny.addNoun("silverware", "some things of|silverware");

		var pocket:Adjective = new Adjective("a|pocket", "a|more pocket-sized", "most pocket-sized", "pocketness");
		pocket.addNoun("a|deck of cards", "a couple|decks of cards");
		pocket.addNoun("coins", "a bunch of|collectable coins");
		pocket.addNoun("chewing gum", "a couple|packs of chewing gum");
		pocket.addNoun("a|condom", "a few|condoms");

		var jingly:Adjective = new Adjective("a|jingly", "a|jinglier", "jingliest", "jingliness");
		jingly.addNoun("sleigh bells", "a bunch of different|sleigh bells");
		jingly.addNoun("wind chimes", "a bunch of|wind chimes");
		jingly.addNoun("a|tambourine", "some|tambourines");
		jingly.addNoun("manacles", "a few sets of|manacles");

		var puzzle:Adjective = new Adjective("a|puzzley", "a|puzzlier", "puzzliest", "puzzleness");
		puzzle.addNoun("a|jigsaw puzzle", "a bunch of|jigsaw puzzles");
		puzzle.addNoun("a|mystery novel", "a couple|mystery novels");
		puzzle.addNoun("a|book of sudoku", "a few|sudoku books");
		puzzle.addNoun("a|finger trap", "a couple of|finger traps");

		var masculine:Adjective = new Adjective("a|masculine", "a|more masculine", "most masculine", "masculinity");
		masculine.addNoun("a|leather jacket", "a couple|leather jackets");
		masculine.addNoun("a|motorcycle", "a bunch of|motorcycles");
		masculine.addNoun("a|handgun", "a few|handguns");
		masculine.addNoun("moustache wax", "some things of|moustache wax");

		var feminine:Adjective = new Adjective("a|feminine", "a|more feminine", "most feminine", "femininity");
		feminine.addNoun("a|purse", "a couple of|purses");
		feminine.addNoun("a|bath pouf", "a bunch of|bath poufs");
		feminine.addNoun("a|brassiere", "a couple|brassieres");
		feminine.addNoun("a|corset", "a bunch of|corsets");

		var computer:Adjective = new Adjective("a|computery", "a|more computery", "most computery", "computeriness");
		computer.addNoun("a|laptop", "a couple of|laptops");
		computer.addNoun("a|thumb drive", "a bunch of them|thumb drives");
		computer.addNoun("a|VR headset", "a whole bunch of|VR headsets");
		computer.addNoun("a|graphics card", "a collection of|graphics cards");

		var penis:Adjective = new Adjective("a|penisy", "a|more penisy", "most penisy", "penisiness");
		penis.addNoun("an|actual penis", "a couple of|actual penises");
		penis.addNoun("a|picture of a penis", "a bunch of|penis pictures");
		penis.addNoun("a|description of a penis", "a few|penis descriptions");
		penis.addNoun("an|audio recording of a penis", "a bunch of|penis sounds");

		var vagina:Adjective = new Adjective("a|vagina-ey", "a|more vagina-ey", "most vagina-ey", "vaginaness");
		vagina.addNoun("an|actual vagina", "a couple of|actual vaginas");
		vagina.addNoun("a|picture of a vagina", "a bunch of|vagina pictures");
		vagina.addNoun("a|description of a vagina", "a few|vagina descriptions");
		vagina.addNoun("an|audio recording of a vagina", "a bunch of|vagina sounds");

		var ambient:Adjective = new Adjective("an|ambient", "a|more ambient", "most ambient", "ambience");
		ambient.addNoun("elevator music", "a lot of|elevator music");
		ambient.addNoun("a|lava lamp", "a couple of|lava lamps");
		ambient.addNoun("a|fog machine", "some|fog machines");
		ambient.addNoun("a|fireplace", "a few|fireplaces");

		var colorful:Adjective = new Adjective("a|colorful", "a|more colorful", "most colorful", "colorfulness");
		colorful.addNoun("rainbow stickers", "some|rainbow stickers");
		colorful.addNoun("a|pride flag", "a couple of|pride flags");
		colorful.addNoun("a|tacky sweater", "a few|tacky sweaters");
		colorful.addNoun("highlighters", "a pack of|highlighters");

		var spherical:Adjective = new Adjective("a|round", "a|rounder", "roundest", "roundness");
		spherical.addNoun("the|moon", "a bunch of|moons");
		spherical.addNoun("a|cantelouple", "a couple|canteloupes");
		spherical.addNoun("a|bocce ball", "a lot of|bocce balls");
		spherical.addNoun("an|eyeball", "a few|eyeballs");

		var inTheButt:Adjective = new Adjective("an|in-the-butt", "a|more in-the-butt", "in-the-buttest", "in-the-buttness");
		inTheButt.addNoun("fecal bacteria", "a colony of|fecal bacteria");
		inTheButt.addNoun("little poops", "a buttful of|little poops");
		inTheButt.addNoun("pinworms", "an infestation of|pinworms");
		inTheButt.addNoun("a|tiny race car", "a bunch of|tiny race cars");
		inTheButt.addNoun("a|suppository", "a handful of|suppositories");

		var erotic:Adjective = new Adjective("an|erotic", "a|more erotic", "most erotic", "eroticness");
		erotic.addNoun("an|aphrodesiac", "a couple of|aphrodesiacs");
		erotic.addNoun("crotchless undies", "some|crotchless undies");
		erotic.addNoun("a|leather harness", "a bunch of them|leather harnesses");
		erotic.addNoun("a|porno mag", "some|porno mags");

		var potentiallyFatal:Adjective = new Adjective("a|potentially fatal", "a|more fatal", "most fatal", "fatalness");
		potentiallyFatal.addNoun("a|pack of cigarettes", "a couple|packs of cigarettes");
		potentiallyFatal.addNoun("intravenous drugs", "a cocktail of|intravenous drugs");
		potentiallyFatal.addNoun("a|snowboard", "a couple of|snowboards");
		potentiallyFatal.addNoun("a|wingsuit", "a bunch of|wingsuits");

		var crawly:Adjective = new Adjective("a|crawly", "a|crawlier", "crawliest", "crawliness");
		crawly.addNoun("a|cockroach", "an infestation of|cockroaches");
		crawly.addNoun("a|caterpillar", "a bunch of|caterpillars");
		crawly.addNoun("a|millipede", "a whole bunch of|millipedes");
		crawly.addNoun("ants", "a whole colony of|ants");

		var distracting:Adjective = new Adjective("a|distracting", "a|more distracting", "most distracting", "distractingess");
		distracting.addNoun("a|television", "a couple|TVs");
		distracting.addNoun("a|loud noise", "a series of|loud noises");
		distracting.addNoun("peripheral movement", "some|peripheral movements");
		distracting.addNoun("a|puppet show", "a couple of|puppet shows");

		var spooky:Adjective = new Adjective("a|spooky", "a|spookier", "spookiest", "spookiness");
		spooky.addNoun("a|mask", "a couple of|masks");
		spooky.addNoun("a|ouija board", "a few|ouija boards");
		spooky.addNoun("a|corpse", "a bunch of|corpses");
		spooky.addNoun("an|abandoned mausoleum", "some|abandoned mausoleums");

		var game:Adjective = new Adjective("a|game-related", "a|gamier", "gamiest", "game-ness");
		game.addNoun("a|nintendo thing", "a couple of those|nintendo things");
		game.addNoun("a|hacky sack", "a bunch of|hacky sacks");
		game.addNoun("a|pack of playing cards", "a couple|packs of playing cards");
		game.addNoun("a|Rubik's cube", "a stack of|Rubik's cubes");

		var hand:Adjective = new Adjective("a|hand-related", "a|more hand-related", "most hand-related", "hand-ness");
		hand.addNoun("a|wedding ring", "a couple|wedding rings");
		hand.addNoun("a|wristwatch", "a bunch of|wristwatches");
		hand.addNoun("a|cuticle pusher", "a drawer full of|cuticle pushers");
		hand.addNoun("a|grip strengthener", "a couple of them|grip strengtheners");

		var seeThrough:Adjective = new Adjective("a|see-through", "a|more see-through", "most see-through", "see-throughness");
		seeThrough.addNoun("a|stained-glass window", "a bunch of them|stained glass windows");
		seeThrough.addNoun("a|crystal ball", "a couple of|crystal balls");
		seeThrough.addNoun("a|wet t-shirt", "a smorgasbord of|wet t-shirts");
		seeThrough.addNoun("a|dreamcatcher", "a bunch of|dreamcatchers");

		var precautionary:Adjective = new Adjective("a|precautionary", "a|more precautionary", "most precautionary", "precautionary-ness");
		precautionary.addNoun("a|appendectomy", "a few|appendectomies");
		precautionary.addNoun("a|wet floor sign", "a bunch of them|wet floor signs");
		precautionary.addNoun("a|baby monitor", "a couple|baby monitors");
		precautionary.addNoun("a|plunger", "some|plungers");
		precautionary.addNoun("a|flashlight", "a couple extra|flashlights");

		var soft:Adjective = new Adjective("a|soft", "a|softer", "softest", "softness");
		soft.addNoun("a|down comforter", "a couple of|down comforters");
		soft.addNoun("a|dakimakura", "a whole bunch of|dakimakuras");
		soft.addNoun("a|baby goose", "a couple|baby geese");
		soft.addNoun("a|beanbag chair", "a few|beanbag chairs");

		var squid:Adjective = new Adjective("a|squid-looking", "a|more squid-looking", "squid-lookingest", "squid-lookingness");
		squid.addNoun("a|plate of spaghetti", "a few|plates of spaghetti");
		squid.addNoun("a|cat o' nine tails", "a couple of those|cat o' nine tails");
		squid.addNoun("a|dreadlocks wig", "a bunch of them|dreadlocks wigs");
		squid.addNoun("a|mop", "a whole bunch of|mops");
		squid.addNoun("a|grass skirt", "a couple of|grass skirts");

		var buzzy:Adjective = new Adjective("a|buzzy", "a|buzzier", "buzziest", "buzziness");
		buzzy.addNoun("a|handheld buzzer", "a couple|handheld buzzers");
		buzzy.addNoun("an|angry hornet", "a cloud of|angry hornets");
		buzzy.addNoun("a|kazoo", "a bunch of|kazoos");
		buzzy.addNoun("an|electric razor", "a few|electric razors");
		buzzy.addNoun("a|chainsaw", "a bunch of them|chainsaws");

		var cute:Adjective = new Adjective("a|cute", "a|cuter", "cutest", "cuteness");
		cute.addNoun("a|puppy", "a litter of|puppies");
		cute.addNoun("a|tamagotchi", "a couple|tamagotchis");
		cute.addNoun("a|baby cupcake", "some|baby cupcakes");
		cute.addNoun("marshmallow peeps", "a whole bunch of|marshmallow peeps");
		cute.addNoun("a|teddy bear", "a few|teddy bears");

		var nostalgic:Adjective = new Adjective("a|nostalgic", "a|more nostalgic", "most nostalgic", "nostalgicness");
		nostalgic.addNoun("a|VHS tape", "a bunch of|VHS tapes");
		nostalgic.addNoun("a|game boy", "a few|game boys");
		nostalgic.addNoun("a|walkman", "a couple of|walkmen");
		nostalgic.addNoun("a|rotary phone", "a bunch of them|rotary phones");
		nostalgic.addNoun("a|beanie baby", "a whole bunch of|beanie babies");

		var fun:Adjective = new Adjective("a|fun", "a|more fun", "most fun", "funness");
		fun.addNoun("a|walkie talkie", "a couple of|walkie talkies");
		fun.addNoun("a|pogo stick", "a few|pogo sticks");
		fun.addNoun("fireworks", "a bunch of|fireworks");
		fun.addNoun("a|squirt gun", "some|squirt guns");
		fun.addNoun("wax lips", "some candy|wax lips");

		var foody:Adjective = new Adjective("a|foody", "a|foodier", "foodiest", "foodiness");
		foody.addNoun("cornmeal", "a big ol' tub of|cornmeal");
		foody.addNoun("a|strawberry", "a thing of|strawberries");
		foody.addNoun("pots and pans", "a bunch of|pots and pans");
		foody.addNoun("mashed potatoes", "some|mashed potatoes");
		foody.addNoun("a|refrigerator", "a few|refrigerators");
		foody.addNoun("an|extra value meal", "a couple|extra value meals");

		var papery:Adjective = new Adjective("a|papery", "a|more papery", "most papery", "paperiness");
		papery.addNoun("a|manila folder", "a couple of|manila folders");
		papery.addNoun("a|lottery ticket", "a bunch of|lottery tickets");
		papery.addNoun("a|book", "a few|books");
		papery.addNoun("a|movie poster", "a couple|movie posters");

		setAdjectives(ItemDatabase.ITEM_COOKIES, true, [crumbly, flat, tasty, circular, foody]);
		setAdjectives(ItemDatabase.ITEM_CALCULATOR, false, [sciencey, geek, rectangle, pocket, computer]);
		setAdjectives(ItemDatabase.ITEM_HYDROGEN_PEROXIDE, false, [sciencey, caustic, cylindrical, medical, precautionary]);
		setAdjectives(ItemDatabase.ITEM_ACETONE, false, [caustic, cylindrical, cosmetic, cleaning, pungent]);
		setAdjectives(ItemDatabase.ITEM_INCENSE, false, [relaxing, pungent, pointy, romantic, ambient]);
		setAdjectives(ItemDatabase.ITEM_GOLD_PUZZLE_KEY, true, [shiny, pocket, jingly, puzzle]);
		setAdjectives(ItemDatabase.ITEM_DIAMOND_PUZZLE_KEY, false, [shiny, pocket, jingly, puzzle]);
		setAdjectives(ItemDatabase.ITEM_MARS_SOFTWARE, false, [rectangle, masculine, computer, penis]);
		setAdjectives(ItemDatabase.ITEM_VENUS_SOFTWARE, false, [rectangle, feminine, computer, vagina]);
		setAdjectives(ItemDatabase.ITEM_MAGNETIC_DESK_TOY, false, [relaxing, shiny, fun, ambient]);
		setAdjectives(ItemDatabase.ITEM_SMALL_GREY_BEADS, true, [drab, spherical, inTheButt, erotic]);
		setAdjectives(ItemDatabase.ITEM_SMALL_PURPLE_BEADS, true, [colorful, spherical, inTheButt, erotic]);
		setAdjectives(ItemDatabase.ITEM_LARGE_GLASS_BEADS, true, [potentiallyFatal, spherical, inTheButt, erotic]);
		setAdjectives(ItemDatabase.ITEM_LARGE_GREY_BEADS, true, [potentiallyFatal, spherical, inTheButt, erotic, drab]);
		setAdjectives(ItemDatabase.ITEM_FRUIT_BUGS, true, [colorful, cute, crawly, puzzle, distracting]);
		setAdjectives(ItemDatabase.ITEM_MARSHMALLOW_BUGS, true, [colorful, cute, crawly, puzzle, distracting, foody]);
		setAdjectives(ItemDatabase.ITEM_SPOOKY_BUGS, true, [spooky, cute, crawly, puzzle, distracting]);
		setAdjectives(ItemDatabase.ITEM_RETROPIE, false, [relaxing, computer, rectangle, geek, game]);
		setAdjectives(ItemDatabase.ITEM_ASSORTED_GLOVES, true, [colorful, hand, soft, squid]);
		setAdjectives(ItemDatabase.ITEM_INSULATED_GLOVES, true, [colorful, hand, precautionary, squid]);
		setAdjectives(ItemDatabase.ITEM_GHOST_GLOVES, true, [spooky, hand, seeThrough, soft]);
		setAdjectives(ItemDatabase.ITEM_VANISHING_GLOVES, true, [spooky, hand, seeThrough, soft]);
		setAdjectives(ItemDatabase.ITEM_STREAMING_PACKAGE, false, [rectangle, flat, computer, distracting]);
		setAdjectives(ItemDatabase.ITEM_VIBRATOR, false, [erotic, cute, buzzy, inTheButt, feminine]);
		setAdjectives(ItemDatabase.ITEM_BLUE_DILDO, false, [penis, inTheButt, cylindrical, pointy, erotic]);
		setAdjectives(ItemDatabase.ITEM_GUMMY_DILDO, false, [penis, inTheButt, pointy, soft, erotic, foody]);
		setAdjectives(ItemDatabase.ITEM_HUGE_DILDO, false, [penis, inTheButt, cylindrical, potentiallyFatal, erotic]);
		setAdjectives(ItemDatabase.ITEM_HAPPY_MEAL, true, [pocket, colorful, nostalgic, fun]);
		setAdjectives(ItemDatabase.ITEM_PIZZA_COUPONS, true, [rectangle, flat, foody, papery]);

		itemQualities[ItemDatabase.ITEM_MAGNETIC_DESK_TOY].successfulPurchase = [
					"%gift-magn%",
					"#kecl06#Really!? ...You want this thing!? This thing doesn't exactly scream out \"<name>\" to me, if you catch my drift.",
					"#kecl05#Waaaaait, what with all these magnets is this... like... supposed to be a present for Magnezone or somethin'? Ooooookay, okay, I get what you're goin' for.",
					"#kecl03#Tell ya what, I'll leave it out for " + (PlayerData.magnMale ? "him" : "her") + " with one of them little ehhhhhh... gift tag things on it. I think that'll get your message across~",
				];

		itemQualities[ItemDatabase.ITEM_RETROPIE].successfulPurchase = [
					"%gift-kecl%",
					"#kecl00#Oof I'm so jealous right now! I'd kill for one of these... things, whatever it is.",
					"#kecl05#I dunno what it is about it, it just looks... expensive. ...And neat. (shake) What's it got, it's got a little chip in there? (shake) (shake)",
					"#kecl06#... ...Anyway, Heracross had some special instructions for this... thing, so I'll ask " + (PlayerData.heraMale ? "him" : "her") + " about it later.",
				];

		itemQualities[ItemDatabase.ITEM_HAPPY_MEAL].successfulPurchase = [
					"%gift-grim%",
					"#kecl05#Ayy cool, enjoy your new ehh... Enjoy your garbage!! ... ... ...ya freakin' weirdo...",
				];

		itemQualities[ItemDatabase.ITEM_PIZZA_COUPONS].successfulPurchase = [
					"%gift-luca%",
					"#kecl06#Oh ehhhh, yeah okay! I mean, that's an... ...interesting choice.",
					"#kecl04#What is it, like, you just like lookin' at pictures of food or somethin'? ...I mean, what's a " + (PlayerData.gender == PlayerData.Gender.Girl ? "girl" : "guy") + " like you gonna actually do with these things?",
					"#kecl02#...Actually, you know who LOVES lookin' at pictures of food is that one " + (PlayerData.rhydMale?"guy":"girl") + " Rhydon! ...I think I'll leave this over with " + (PlayerData.rhydMale?"his":"her") + " stuff."
				];

		intros.single([
						  "#kecl06#Oooh, I dunno if I'm supposed to sell this, it's just this... <adjs> thing that was sittin' around.",
						  "#kecl05#But I can maybe let you have it for... <price>? That sound good?"
					  ]);
		intros.plural([
						  "#kecl06#Oooh, I dunno if I'm supposed to sell these, they're just these... <adjs> things that were sittin' around.",
						  "#kecl05#But I can maybe let you have 'em for... <price>? That sound good?"
					  ]);

		intros.single(["#kecl04#That's <a adjs> thing! It's really good if you need somethin' that's ehh, <adj0>. Did you want it for <price>?"]);
		intros.plural(["#kecl04#Those are some <adjs> things! They're really good if you need some things that are ehh, <adj0>. Did you want 'em for <price>?"]);

		intros.single(["#kecl04#Oh that! That's a, uhhh... <adjs> thing. Didja wanna buy it for <price>?"]);
		intros.plural(["#kecl04#Oh those! Those are uhhh... <adjs> things. Didja wanna buy 'em for <price>?"]);

		intros.single(["#kecl06#Oh you're lookin' at that? Yeah that's a ehhh... <adjs> thing. Did you want it for <price>?"]);
		intros.plural(["#kecl06#Oh you're lookin' at those? Yeah those are ehhh... <adjs> things. Did you want 'em for <price>?"]);

		intros.single(["#kecl03#Oh that's like... <a adjs> thing. It's really <adj0>! ...Did you wanna buy it for <price>?"]);
		intros.plural(["#kecl03#Oh those are like... <adjs> things. They're really <adj0>! ...Did you wanna buy em for <price>?"]);

		intros.single(["#kecl05#Oh that? Yeah that's the most ehh, <adjs> thing a " + (PlayerData.gender == PlayerData.Gender.Girl ? "girl" : "guy") +" could ever want right there! ...How's <price> sound? You want it?"]);
		intros.plural(["#kecl05#Oh that? Yeah that's all the ehh, <adjs> things a " + (PlayerData.gender == PlayerData.Gender.Girl ? "girl" : "guy") +" could ever want right there! ...How's <price> sound? You want 'em?"]);

		intros.single(["#kecl05#Yeah, that's one of them... <adjs> things! We're runnin' a special today where it's only <price>. Did you want it?"]);
		intros.plural(["#kecl05#Yeah, those are some of them... <adjs> things! We're runnin' a special today where they're only <price>. Did you want 'em?"]);

		intros.single(["#kecl04#You got a keen eye! That's <a adjs> thing, and it can be yours for the low, low price of <price>. You wanna take it?"]);
		intros.plural(["#kecl04#You got a keen eye! Those are some <adjs> things, and they can be yours for the low, low price of <price>. You wanna take 'em?"]);

		intros.single(["#kecl04#Yeah, so that's <a adjs> thing! I was gonna charge 20,000,000$ for it, but for you? Let's make it <price>. Waddaya say?"]);
		intros.plural(["#kecl04#Yeah, so those are <adjs> things! I was gonna charge 20,000,000$ for 'em, but for you? Let's make it <price>. Waddaya say?"]);

		intros.single(["#kecl02#Yeah, we finally got <a adjs> thing in stock! Did you wanna nab it for <price> today? It might be gone tomorrow!"]);
		intros.plural(["#kecl02#Yeah, we finally got these <adjs> things in stock! Did you wanna nab 'em for <price> today? They might be gone tomorrow!"]);

		intros.shuffle();

		descriptions.single([
								"#kecl05#Oh yeah! When people are shopping for somethin' <adj0>, they're usually thinking like... <a noun00>, or maybe <a noun01>.",
								"#kecl02#But I can tell, you? You know <adj0>. You're a connoisseur of <adj0>.",
								"#kecl03#If you want the most <adj0> you can get, you don't want <a noun01>, you want this <adjs> thing!",
								"#kecl05#Besides, would you describe <a noun01> as <adj2>? Like, no way! I mean, well...",
								"#kecl06#Well maybe some of those high-end <nouns01>. But you'd pay through the nose for that kind of quality!",
								"#kecl04#This thing I'm sellin' is way more of a bargain when you're lookin' for something's both <adj0> and <adj2>. Won't you buy it for <price>?",
							]);
		descriptions.plural([
								"#kecl05#Oh yeah! When people are shopping for somethin' <adj0>, they're usually thinking like... <a noun00>, or maybe <a noun01>.",
								"#kecl02#But I can tell, you? You know <adj0>. You're a connoisseur of <adj0>.",
								"#kecl03#If you want the most <adj0> you can get, you don't want <a noun01>, you want these <adjs> things!",
								"#kecl05#Besides, would you describe <a noun01> as <adj2>? Like, no way! I mean, well...",
								"#kecl06#Well maybe some of those high-end <nouns01>. But you'd pay through the nose for that kind of quality!",
								"#kecl04#These things I'm sellin' are way more of a bargain when you're lookin' for something's both <adj0> and <adj2>. Won't you buy 'em for <price>?",
							]);

		descriptions.single([
								"#kecl03#Oh yeah! Trust me, this is the <adjest0> thing money can buy.",
								"#kecl06#Other people might recommend, y'know, <a noun00> or <a noun01>. But this thing is so much <adjer1> than <a noun01>!",
								"#kecl05#I mean, if you stack this thing and <a noun01> up side by side, and you think about which one is <adjer1>, and <adjer0>...",
								"#kecl13#...It's like, it's just no contest! This <adjs> thing wins by a landslide. Get of here with that <nouns01> nonsense.",
								"#kecl06#I'd prove it to you, but I don't think Heracross has any <nouns01> in stock. ...So won't you buy this <adj0> thing for <price>?",
							]);
		descriptions.plural([
								"#kecl03#Oh yeah! Trust me, these are the <adjest0> things money can buy.",
								"#kecl06#Other people might recommend, y'know, <some nouns00> or <some nouns01>. But these things are so much <adjer1> than <some nouns01>!",
								"#kecl05#I mean, if you stack these things and <some nouns01> up side by side, and you think about which one is <adjer1>, and <adjer0>...",
								"#kecl13#...It's like, it's just no contest! These <adjs> things win by a landslide. Get of here with that <nouns01> nonsense.",
								"#kecl06#I'd prove it to you, but I don't think Heracross has any <nouns01> in stock. ...So won't you buy these <adj0> things for <price>?",
							]);

		descriptions.single([
								"#kecl03#<Adj0>? Oh, well if you're really serious about your <adj0> things, c'mon, who are you fooling!",
								"#kecl02#You really can't do any better than this here <adjs> thing, when it comes to <adj0>.",
								"#kecl08#I mean sure, you wanna go the cheap route, you could go with somethin else <adj0>... like eh, <some nouns00> or <a noun01>...",
								"#kecl06#...But when you get right down to it... you want <adj0> and <adj2>? ...AND <adj1>? I mean, <a noun01> ain't gonna cut it.",
								"#kecl05#<Adj0> sure, <adj2> maybe... but <adj1>? I don't know about you but I ain't never heard of no <adj1> <noun01>.",
								"#kecl03#So c'mon, who are you kidding? You need this <adjs> thing! It's only <price>... You wanna buy it, right?",
							]);
		descriptions.plural([
								"#kecl03#<Adj0>? Oh, well if you're really serious about your <adj0> things, c'mon, who are you fooling!",
								"#kecl02#You really can't do any better than these here <adjs> things, when it comes to <adj0>.",
								"#kecl08#I mean sure, you wanna go the cheap route, you could go with somethin else <adj0>... like eh, <some nouns00> or <a noun01>...",
								"#kecl06#...But when you get right down to it... you want <adj0> and <adj2>? ...AND <adj1>? I mean, <a noun01> ain't gonna cut it.",
								"#kecl05#<Adj0> sure, <adj2> maybe... but <adj1>? I don't know about you but I ain't never heard of no <adj1> <noun01>.",
								"#kecl03#So c'mon, who are you kidding? You need these <adjs> things! They're only <price>... You wanna buy 'em, right?",
							]);

		descriptions.single([
								"#kecl12#Okay, so lemme talk straight with you for a minute about <adj0>. 'Cause c'mon, you can go anywhere and get somethin' <adj0>.",
								"#kecl06#You go across the street, they're gonna try to hook you up with <a noun00>. They got <nouns00> up the yin-yang!",
								"#kecl05#And a lotta customers, y'know, maybe they'd be happy with that. But YOU my friend, you're somethin' else! I can tell.",
								"#kecl06#You're not down for your run-of-the-mill <noun00>, you want... some kinda <adj1> <noun00>, or <a adj2> <noun00>. Or maybe,",
								"#kecl02#Just MAYBE... you don't want <a noun00> at all! ...What you really want is, you want this here <adjs> thing.",
								"#kecl00#Isn't that right? I mean it's only <price>! And it's so <adj0>, I mean just look at it...",
							]);
		descriptions.plural([
								"#kecl12#Okay, so lemme talk straight with you for a minute about <adj0>. 'Cause c'mon, you can go anywhere and get somethin' <adj0>.",
								"#kecl06#You go across the street, they're gonna try to hook you up with <some nouns00>. They got <nouns00> up the yin-yang!",
								"#kecl05#And a lotta customers, y'know, maybe they'd be happy with those. But YOU my friend, you're somethin' else! I can tell.",
								"#kecl06#You're not down for your run-of-the-mill <nouns00>, you want... some kinda <adj1> <nouns00>, or a bunch of <adj2> <nouns00>. Or maybe,",
								"#kecl02#Just MAYBE... you don't want <some nouns00> at all! ...What you really want is, you want these here <adjs> things.",
								"#kecl00#Isn't that right? I mean they're only <price>! And they're so <adj0>, I mean just look at 'em..."
							]);

		descriptions.single([
								"#kecl06#So lemme tell you about this thing. 'Cause if you want <adj0>, you know, you got your <nouns00>. Those are fine.",
								"#kecl04#And if you want <adj2>, you can get <some nouns20>. I'm a big fan of <nouns20> myself, don't get me wrong!",
								"#kecl06#But <nouns20> ain't gonna cut it when you're looking for somethin' <adj0>! So if you want something that's <adj0> AND <adj2>...",
								"#kecl03#I mean, bam! That's where this <adjs> thing comes in.",
								"#kecl05#It's got all your bases covered in a way that <nouns00> and <nouns20> just can't match.",
								"#kecl04#It's got your <adj0>, it's got your <adj2>, I mean heck it's even got your <adj1> so you can just throw any <nouns10> you got right in the garbage.",
								"#kecl02#You don't need <some nouns10> sittin' around once you got your <adjs> thing right here! So waddaya say? Only <price>!",
							]);
		descriptions.plural([
								"#kecl06#So lemme tell you about these things. 'Cause if you want <adj0>, you know, you got your <nouns00>. Those are fine.",
								"#kecl04#And if you want <adj2>, you can get <some nouns20>. I'm a big fan of <nouns20> myself, don't get me wrong!",
								"#kecl06#But <nouns20> ain't gonna cut it when you're looking for somethin' <adj0>! So if you want something that's <adj0> AND <adj2>...",
								"#kecl03#I mean, bam! That's where these <adjs> things come in.",
								"#kecl05#They got all your bases covered in a way that <nouns00> and <nouns20> just can't match.",
								"#kecl04#They got your <adj0>, they got your <adj2>, I mean heck they even got your <adj1> so you can just throw any <nouns10> you got right in the garbage.",
								"#kecl02#You don't need <some nouns10> sittin' around once you got your <adjs> things right here! So waddaya say? Only <price>!",
							]);

		descriptions.single([
								"#kecl05#So if you've tried <a noun00> before, and you've thought maybe that was a little TOO <adj0>...",
								"#kecl04#Y'know, maybe this <adjs> thing is more your speed. It's still got some <adjness0> to it-",
								"#kecl06#-but that <adjness0> is tempered with, eh, a little <adjness1>. A little <adjness2>.",
								"#kecl05#Now, not as <adj0>! Not as <adj0> mind you. But sometimes you don't need all that <adjness0>, if you know what I'm sayin.",
								"#kecl10#Sometimes <a noun00> or <a noun01> can be a little too <adj0>! Even for me.",
								"#kecl04#So whaddaya say, can I interest you in this <adjs> thing for <price>?"
							]);
		descriptions.plural([
								"#kecl05#So if you've tried <nouns00> before, and you've thought maybe those were a little TOO <adj0>...",
								"#kecl04#Y'know, maybe these <adjs> things are more your speed. They've still got some <adjness0> to 'em-",
								"#kecl06#-but that <adjness0> is tempered with, eh, a little <adjness1>. A little <adjness2>.",
								"#kecl05#Now, not as <adj0>! Not as <adj0> mind you. But sometimes you don't need all that <adjness0>, if you know what I'm sayin.",
								"#kecl10#Sometimes <some nouns00> or <some nouns01> can be a little too <adj0>! Even for me.",
								"#kecl04#So whaddaya say, can I interest you in these <adjs> things for <price>?"
							]);

		descriptions.single([
								"#kecl04#So you know, you've got your <nouns10>, you've got your <nouns00>, and you know. You think you've seen it all...",
								"#kecl06#But hold up a second, 'cause what's this thing here? It's somethin' you've never seen in your life!",
								"#kecl03#Why it's your brand new... <adj0>... <adj1> <adj2> thing! Wow!",
								"#kecl05#I mean it's like all the <adjness1> of <a noun10>... and the <adjness0> of <a noun00>... put together!",
								"#kecl07#It's like... some crazy <nouns10> that are also <adj0>? And whoa! Did I mention it's <adj2>? Get outta here!",
								"#kecl04#I mean c'mon! You'd be crazy not to buy this <adjs> thing for <price>. Waddaya say?",
							]);
		descriptions.plural([
								"#kecl04#So you know, you've got your <nouns10>, you've got your <nouns00>, and you know. You think you've seen it all...",
								"#kecl06#But hold up a second, 'cause what are these things here? They're somethin' you've never seen in your life!",
								"#kecl03#Why they're your brand new... <adj0>... <adj1> <adj2> things! Wow!",
								"#kecl05#I mean they got all the <adjness1> of <nouns10>... and the <adjness0> of <nouns00>... put together!",
								"#kecl07#They're like... some crazy <nouns10> that are also <adj0>? And whoa! Did I mention it's <adj2>? Get outta here!",
								"#kecl04#I mean c'mon! You'd be crazy not to buy these <adjs> things for <price>. Waddaya say?",
							]);

		descriptions.single([
								"#kecl06#You have no idea, people have really been cleaning this store out of anything remotely <adj0> lately. Just look around! You see anything <adj0> here?",
								"#kecl10#We used to have all sorts of, you know, <nouns00> and <nouns01> around here. But not anymore!",
								"#kecl07#People were linin' up outside, we sold out of <nouns02> in like five minutes. It's crazy how popular this <adj0> stuff is.",
								"#kecl04#That said, we JUST got this item in today, it's brand new. I don't know how long it's gonna stay on the shelves at this price!",
								"#kecl05#Waddaya say, you want it? All the <adjness0> of <a noun02> for a mere <price>? It's a bargain at twice that!"
							]);
		descriptions.plural([
								"#kecl06#You have no idea, people have really been cleaning this store out of anything remotely <adj0> lately. Just look around! You see anything <adj0> here?",
								"#kecl10#We used to have all sorts of, you know, <nouns00> and <nouns01> around here. But not anymore!",
								"#kecl07#People were linin' up outside, we sold out of <nouns02> in like five minutes. It's crazy how popular this <adj0> stuff is.",
								"#kecl04#That said, we JUST got these items in today, they're brand new. I don't know how long they're gonna stay on the shelves at this price!",
								"#kecl05#Waddaya say, you want 'em? All the <adjness0> of <some nouns02> for a mere <price>? They're a bargain at twice that!"
							]);

		descriptions.single([
								"#kecl06#So you might be wonderin' to yourself, how can somethin' be <adj0>... and <adj1>... and also <adj2>?",
								"#kecl04#Like <adj1> and <adj2>, sure. Maybe you've seen <some nouns20> that were sorta <adj1>.",
								"#kecl05#Y'know, like maybe not ALL the way <adj1>, but at least kinda <adj1> by <noun20> standards.",
								"#kecl10#As for <adj0> and <adj2>? Sure, we all remember that one <adj0> <noun21> incident from way back.",
								"#kecl02#But <adj0>, <adj1> AND <adj2>? I mean, that's a trifecta that's very hard to obtain.",
								"#kecl03#However... this <adjs> thing can be yours for the low price of <price>! ...How can you say no?"
							]);
		descriptions.plural([
								"#kecl06#So you might be wonderin' to yourself, how can somethin' be <adj0>... and <adj1>... and also <adj2>?",
								"#kecl04#Like <adj1> and <adj2>, sure. Maybe you've seen <some nouns20> that were sorta <adj1>.",
								"#kecl05#Y'know, like maybe not ALL the way <adj1>, but at least kinda <adj1> by <noun20> standards.",
								"#kecl10#As for <adj0> and <adj2>? Sure, we all remember that one <adj0> <noun21> incident from way back.",
								"#kecl02#But <adj0>, <adj1> AND <adj2>? I mean, that's a trifecta that's very hard to obtain.",
								"#kecl03#However... these <adjs> things can be yours for the low price of <price>! ...How can you say no?"
							]);

		descriptions.single([
								"#kecl03#So I can tell you're a big fan of <nouns00>. I mean, who isn't, right?",
								"#kecl05#But if you're willing to sacrifice a little <adjness0>, this <adjs> thing has a lot to offer.",
								"#kecl08#Now I gotta tell you up front, it's not quite as <adj0> as <a noun00>.",
								"#kecl06#I mean, it's hard to get more <adj0> than <a noun00>. But if you're lookin' for <adj1> or <adj2>,",
								"#kecl02#Well this thing is <adj1> and <adj2> in a way that <nouns00> can't compare.",
								"#kecl06#Scientists have been tryin' to perfect the <adj2> <noun00> for years now, y'know-",
								"#kecl04#-and I don't think we're seein' a major breakthrough anytime soon.",
								"#kecl05#So waddaya say? It's no <noun00> but it's still pretty <adj0>! Did you want it for <price>?",
							]);
		descriptions.plural([
								"#kecl03#So I can tell you're a big fan of <nouns00>. I mean, who isn't, right?",
								"#kecl05#But if you're willing to sacrifice a little <adjness0>, these <adjs> things have a lot to offer.",
								"#kecl08#Now I gotta tell you up front, they're not quite as <adj0> as <a noun00>.",
								"#kecl06#I mean, it's hard to get more <adj0> than <a noun00>. But if you're lookin' for <adj1> or <adj2>,",
								"#kecl02#Well these things are <adj1> and <adj2> in a way that <nouns00> can't compare.",
								"#kecl06#Scientists have been tryin' to perfect the <adj2> <noun00> for years now, y'know-",
								"#kecl04#-and I don't think we're seein' a major breakthrough anytime soon.",
								"#kecl05#So waddaya say? They're no <nouns00> but they're still pretty <adj0>! Did you want 'em for <price>?",
							]);

		descriptions.shuffle();

		successfulPurchases.single(["#kecl03#Ayy, sweet! Enjoy your new uhh... thing!"]);
		successfulPurchases.plural(["#kecl03#Ayy, sweet! Enjoy your new uhh... things!"]);

		successfulPurchases.single(["#kecl03#Ayyyy look at me! I made a sale~"]);
		successfulPurchases.plural(["#kecl03#Ayyyy look at me! I made a sale~"]);

		successfulPurchases.single(["#kecl02#Ayy nice! Enjoy your new ehh... purchase! Yeah! Whatever the heck that thing is..."]);
		successfulPurchases.plural(["#kecl02#Ayy nice! Enjoy your new ehh... purchase! Yeah! Whatever the heck those things are..."]);

		successfulPurchases.single(["#kecl02#Whoa, another happy customer! I'm pretty good at this~"]);
		successfulPurchases.plural(["#kecl02#Whoa, another happy customer! I'm pretty good at this~"]);

		successfulPurchases.single(["#kecl03#Here you go! Enjoy your uhhh... yeah! Your thing!"]);
		successfulPurchases.plural(["#kecl03#Here you go! Enjoy your uhhh... yeah! Your things!"]);

		successfulPurchases.single([
									   "#kecl03#Whoa nice! So uhh, just gotta warn you there are no refunds on this particular thing.",
									   "#kecl06#You know uhh, if this thing ends up bein' too <adj1> for you or somethin', that's on you. Buyer beware."
								   ]);
		successfulPurchases.plural([
									   "#kecl03#Whoa nice! So uhh, just gotta warn you there are no refunds on these particular things.",
									   "#kecl06#You know uhh, if these things end up bein' too <adj1> for you or somethin', that's on you. Buyer beware."
								   ]);

		successfulPurchases.single(["#kecl03#Whoa, awesome! I just know you're gonna love your new <adjs> thing. Take care!"]);
		successfulPurchases.plural(["#kecl03#Whoa, awesome! I just know you're gonna love your new <adjs> things. Take care!"]);

		successfulPurchases.single(["#kecl02#There you go! Enjoy your new... thing!"]);
		successfulPurchases.plural(["#kecl02#There you go! Enjoy your new... things!"]);

		successfulPurchases.single(["#kecl03#Holy smokes I actually sold one. ...I knew Heracross picked the right lizard for the job!"]);
		successfulPurchases.plural(["#kecl03#Holy smokes I actually sold one. ...I knew Heracross picked the right lizard for the job!"]);

		successfulPurchases.single(["#kecl02#Ay thanks a lot buddy! You're doin' me a real favor here~"]);
		successfulPurchases.plural(["#kecl02#Ay thanks a lot buddy! You're doin' me a real favor here~"]);

		successfulPurchases.shuffle();
	}

	static private function setAdjectives(itemIndex:Int, plural:Bool, adjectives:Array<Adjective>)
	{
		itemQualities[itemIndex] = new ItemQuality(plural, adjectives.copy());
		FlxG.random.shuffle(itemQualities[itemIndex].adjectives);
	}

	public static function describe(item:ItemDatabase.ShopItem):Array<Array<Object>>
	{
		if (descriptionCache.get(item) == null)
		{
			var tree:Array<Array<Object>> = [];
			descriptionCache[item] = tree;

			var itemIndex:Int = item.getItemType().index;
			var itemPrice:Int = item.getPrice();

			if (itemQualities[itemIndex] == null)
			{
				// no description...
			}
			else
			{
				var intro:Array<String> = intros.getOne(itemQualities[itemIndex].plural);
				for (i in 0...intro.length)
				{
					tree[0 + i] = [intro[i]];
				}

				var successfulPurchase:Array<String>;
				if (itemQualities[itemIndex].successfulPurchase == null)
				{
					successfulPurchase = successfulPurchases.getOne(itemQualities[itemIndex].plural);
				}
				else
				{
					successfulPurchase = itemQualities[itemIndex].successfulPurchase;
				}
				for (i in 0...successfulPurchase.length)
				{
					tree[100 + i] = [successfulPurchase[i]];
				}

				tree[300] = ["...<Adj0>?"];

				var description:Array<String> = descriptions.getOne(itemQualities[itemIndex].plural);
				for (i in 0...description.length)
				{
					tree[301 + i] = [description[i]];
				}

				var adjs:Array<Adjective> = itemQualities[itemIndex].adjectives;
				for (i in 0...tree.length)
				{
					if (tree[i] == null)
					{
						continue;
					}
					DialogTree.replace(tree, i, "<price>", moneyString(itemPrice));
					DialogTree.replace(tree, i, "<adjs>", afterPipe(adjs[0].big) + " " + afterPipe(adjs[1].big) + " " + afterPipe(adjs[2].big));
					DialogTree.replace(tree, i, "<Adjs>", capitalize(afterPipe(adjs[0].big) + " " + afterPipe(adjs[1].big) + " " + afterPipe(adjs[2].big)));
					DialogTree.replace(tree, i, "<a adjs>", bothPipe(adjs[0].big) + " " + afterPipe(adjs[1].big) + " " + afterPipe(adjs[2].big));
					DialogTree.replace(tree, i, "<A adjs>", capitalize(bothPipe(adjs[0].big) + " " + afterPipe(adjs[1].big) + " " + afterPipe(adjs[2].big)));
					for (adjIndex in 0...3)
					{
						DialogTree.replace(tree, i, "<adjness" + adjIndex + ">", afterPipe(adjs[adjIndex].bigness));
						DialogTree.replace(tree, i, "<Adjness" + adjIndex + ">", capitalize(afterPipe(adjs[adjIndex].bigness)));
						DialogTree.replace(tree, i, "<adj" + adjIndex + ">", afterPipe(adjs[adjIndex].big));
						DialogTree.replace(tree, i, "<Adj" + adjIndex + ">", capitalize(afterPipe(adjs[adjIndex].big)));
						DialogTree.replace(tree, i, "<a adj" + adjIndex + ">", bothPipe(adjs[adjIndex].big));
						DialogTree.replace(tree, i, "<A adj" + adjIndex + ">", capitalize(bothPipe(adjs[adjIndex].big)));
						DialogTree.replace(tree, i, "<adjer" + adjIndex + ">", afterPipe(adjs[adjIndex].bigger));
						DialogTree.replace(tree, i, "<Adjer" + adjIndex + ">", capitalize(afterPipe(adjs[adjIndex].bigger)));
						DialogTree.replace(tree, i, "<a adjer" + adjIndex + ">", bothPipe(adjs[adjIndex].bigger));
						DialogTree.replace(tree, i, "<A adjer" + adjIndex + ">", capitalize(bothPipe(adjs[adjIndex].bigger)));
						DialogTree.replace(tree, i, "<adjest" + adjIndex + ">", afterPipe(adjs[adjIndex].biggest));
						DialogTree.replace(tree, i, "<Adjest" + adjIndex + ">", capitalize(afterPipe(adjs[adjIndex].biggest)));
						for (nounIndex in 0...3)
						{
							DialogTree.replace(tree, i, "<noun" + adjIndex + "" + nounIndex + ">", afterPipe(adjs[adjIndex].nouns[nounIndex].thing));
							DialogTree.replace(tree, i, "<Noun" + adjIndex + "" + nounIndex + ">", capitalize(afterPipe(adjs[adjIndex].nouns[nounIndex].thing)));
							DialogTree.replace(tree, i, "<a noun" + adjIndex + "" + nounIndex + ">", bothPipe(adjs[adjIndex].nouns[nounIndex].thing));
							DialogTree.replace(tree, i, "<A noun" + adjIndex + "" + nounIndex + ">", capitalize(bothPipe(adjs[adjIndex].nouns[nounIndex].thing)));
							DialogTree.replace(tree, i, "<nouns" + adjIndex + "" + nounIndex + ">", afterPipe(adjs[adjIndex].nouns[nounIndex].things));
							DialogTree.replace(tree, i, "<Nouns" + adjIndex + "" + nounIndex + ">", capitalize(afterPipe(adjs[adjIndex].nouns[nounIndex].things)));
							DialogTree.replace(tree, i, "<some nouns" + adjIndex + "" + nounIndex + ">", bothPipe(adjs[adjIndex].nouns[nounIndex].things));
							DialogTree.replace(tree, i, "<Some nouns" + adjIndex + "" + nounIndex + ">", capitalize(bothPipe(adjs[adjIndex].nouns[nounIndex].things)));
						}
					}
				}
			}
		}

		// return a copy; the recipient might mess with the dialog tree
		return descriptionCache[item].copy();
	}
}

/**
 * The Adjective class provides a model for an adjective's forms; "crumbly",
 * "crumblier", "crumbliest", "crumbliness"
 */
class Adjective
{
	public var big:String;
	public var bigger:String;
	public var biggest:String;
	public var bigness:String;
	public var nouns:Array<Noun> = [];

	public function new(big:String, bigger:String, biggest:String, bigness:String)
	{
		this.biggest = biggest;
		this.bigger = bigger;
		this.big = big;
		this.bigness = bigness;
	}

	public function addNoun(thing:String, things:String)
	{
		nouns.insert(FlxG.random.int(0, nouns.length), new Noun(thing, things));
	}
}

/**
 * The Noun class provides a model for a noun's forms; "a rug", "some rugs"
 */
class Noun
{
	public var thing:String;
	public var things:String;

	public function new(thing:String, things:String)
	{
		this.thing = thing;
		this.things = things;
	}
}

/**
 * The ItemQuality class provides a model for some quality of an item.
 *
 * For example, a flat object might be compared to other flat objects like
 * rugs, waffles and tortillas. All of those descriptors are stored in a
 * flat ItemQuality instance.
 */
class ItemQuality
{
	public var adjectives:Array<Adjective>;
	public var plural:Bool = false;
	public var successfulPurchase:Array<String> = [];

	public function new(plural:Bool, adjectives:Array<Adjective>)
	{
		this.plural = plural;
		this.adjectives = adjectives;
	}
}

/**
 * A list of possible conversations about the store's current stock.
 */
class ConversationList
{
	public var conversations:Array<Array<Array<String>>> = [];

	public function new()
	{
	}

	public function single(desc:Array<String>)
	{
		conversations.push([]);
		conversations[conversations.length - 1][0] = desc;
		conversations[conversations.length - 1][1] = desc;
	}

	public function plural(desc:Array<String>)
	{
		conversations[conversations.length - 1][1] = desc;
	}

	public function shuffle()
	{
		FlxG.random.shuffle(conversations);
	}

	public function getOne(plural:Bool):Array<String>
	{
		var next:Array<Array<String>> = conversations.splice(0, 1)[0];
		conversations.push(next);
		return next[plural ? 1 : 0];
	}
}