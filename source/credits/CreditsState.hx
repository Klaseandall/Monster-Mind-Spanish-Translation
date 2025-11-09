package credits;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import kludge.FlxSoundKludge;
import kludge.LateFadingFlxParticle;
import poke.abra.AbraDialog;

/**
 * The FlxState which shows the credits and the ending sequence, with abra
 * waking up and all of the different Pokemon scenes
 */
class CreditsState extends FlxTransitionableState
{
	private static var IMAGE_CRAWL_X_VELOCITY:Float = -34;
	private static var IMAGE_CRAWL_SPACING:Float = 138;

	private var musicEventStack:MusicEventStack = new MusicEventStack();
	private var eventStack:EventStack = new EventStack();

	private var credits:Array<Array<String>> = [];

	private var topTextY:Float = 0;
	private var botTextY:Float = 0;
	private var textY:Float = 0;
	private var firstVisibleTextIndex:Int = 0;
	private var texts:FlxTypedGroup<FlxText>;

	private var mainCreditsImage:FlxSprite;
	private var zappedAbraImage:FlxSprite;
	private var sadGrimerImage:FlxSprite;
	private var happyGrimerImage:FlxSprite;
	private var smeargleImage:FlxSprite;
	private var bgImageOld:FlxSprite;
	private var bgImage:FlxSprite;

	private var creditsImageFinal:FlxSprite;
	private var thanksImageFinal:FlxSprite;
	private var otherCreditsMinIndex:Int = 0;
	private var otherCreditsMaxIndex:Int = 0;
	private var otherCreditsImages:FlxTypedGroup<FlxSprite>;

	private var bgImageAssets:Array<FlxGraphicAsset> = [
				AssetPaths.credits_rhyd_bg__png,
				AssetPaths.credits_buiz_bg__png,
				AssetPaths.credits_grim_bg__png,
				AssetPaths.credits_sand_bg__png,
				AssetPaths.credits_hera_bg__png,
				AssetPaths.credits_grov_bg__png,
				AssetPaths.credits_magn_bg__png,
				AssetPaths.credits_smea_bg__png,
				AssetPaths.credits_kecl_bg__png,
				AssetPaths.credits_luca_bg__png,
			];

	private var otherCreditsImageAssets:Array<FlxGraphicAsset> = [
				AssetPaths.credits09__png,

				// rhydon
				AssetPaths.credits_rhyd0__png,
				AssetPaths.credits_rhyd1__png,
				AssetPaths.credits_rhyd2__png,

				// buizel
				AssetPaths.credits_buiz0__png,
				AssetPaths.credits_buiz1__png,

				// grimer
				AssetPaths.credits_grim0__png,
				AssetPaths.credits_grim1__png,

				// sandslash
				AssetPaths.credits_sand0__png,
				AssetPaths.credits_sand1__png,

				// heracross
				AssetPaths.credits_hera0__png,
				AssetPaths.credits_hera1__png,

				// grovyle
				AssetPaths.credits_grov0__png,
				AssetPaths.credits_grov1__png,

				// magnezone
				AssetPaths.credits_magn0__png,
				AssetPaths.credits_magn1__png,

				// smeargle
				AssetPaths.credits_smea0__png,
				AssetPaths.credits_smea1__png,

				// kecleon
				AssetPaths.credits_kecl0__png,
				AssetPaths.credits_kecl1__png,

				// lucario
				AssetPaths.credits_luca0__png,
				AssetPaths.credits_luca1__png
			];

	private var wisp:FlxEmitter;
	private var wispLine:WispLine;
	private var wispLayer:FlxSprite;
	private var smallSparkEmitter:FlxTypedEmitter<LateFadingFlxParticle>;

	private var maskCreditsBot:FlxSprite;
	private var maskCreditsTop:FlxSprite;
	private var scheduledFadeOut:Bool = false;
	public var backToMainMenu:Bool = false;

	public function new(?TransIn:TransitionData, ?TransOut:TransitionData)
	{
		super(TransIn, TransOut);
	}

	override public function create():Void
	{
		Main.overrideFlxGDefaults();
		super.create();

		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;

		// If music is playing it would mess up our eventing. ...Stop any music, just in case
		FlxG.sound.music = FlxDestroyUtil.destroy(FlxG.sound.music);

		topTextY = FlxG.height - 175;
		botTextY = FlxG.height - 175;
		textY = topTextY;

		credits.push(["monster mind"]);
		credits.push([]);
		credits.push(["a game by"]);
		credits.push(["argon vile"]);
		credits.push([]);
		credits.push([]);
		credits.push([]);
		credits.push([]);
		credits.push(["#words do not exist to express my feelings toward the monster mind players and the monster"
				+ " mind community. thank you all so much. making this game was a ton of work and i'm grateful that"
				+ " you enjoyed it enough to play it and finish it. i'm sorry to everyone whose assets i stole to"
				+ " make it. i promise i won't sell it or make money off it or anything. i'm just happy i got to make"
				+ " a cool game."]);
		credits.push([]);
		credits.push([]);
		credits.push([]);
		credits.push(["sorry:"]);
		credits.push([]);
		credits.push(["character design", "shamelessly stolen from nintendo and the pokemon company"]);
		credits.push(["", "#(sorry. i think your pokemon games are fun)"]);
		credits.push([]);
		credits.push(["puzzle design", "shamelessly stolen from hasbro and some guy named mordecai meirowitz"]);
		credits.push(["", "#(sorry. your mastermind game is fun too)"]);
		credits.push([]);
		credits.push(["fonts", "shamelessly stolen from some guy named jovanny lemonad"]);
		credits.push(["", "#(sorry)"]);
		credits.push(["", " "]);
		credits.push(["", "and also some girl named \"misti's fonts\""]);
		credits.push(["", "#(also sorry)"]);
		credits.push([]);
		credits.push(["sound", "shamelessly stolen from pokemon emerald"]);
		credits.push(["", "#(sorry nintendo)"]);
		credits.push([]);
		credits.push(["music", "shamelessly stolen from hyper potions"]);
		credits.push(["", "#(sorry)"]);
		credits.push(["", " "]);
		credits.push(["", "and also stolen from gameboyluke because he paid hyper potions to make this song for him"]);
		credits.push(["", "#(he what? oh okay wait a minute, wow)"]);
		credits.push(["", " "]);
		credits.push(["", "#(...i am seriously the biggest asshole. i'm so sorry, it's just a really pretty song)"]);
		credits.push([]);
		credits.push(["code contributors:"]);
		credits.push([]);
		credits.push(["the frog"]);
		credits.push(["kavukamari"]);
		credits.push([]);
		credits.push(["testers:"]);
		credits.push([]);
		credits.push(["!blake", "!dreamous"]);
		credits.push(["!mattspew", "!nogard"]);
		credits.push(["!nullbunny", "!spike"]);
		credits.push(["!sprout", "!tygre"]);
		credits.push(["...and everyone else"]);
		credits.push([]);
		credits.push([]);
		credits.push([]);
		credits.push([]);
		credits.push([]);
		credits.push(["#sometimes the universe can feel like a lonely place. " +
		"but technology's a wonderful thing. " +
		"regardless of where we live, what language we speak, or whether we're real or imaginary... " +
		"we're all connected to thousands of potential friends through the magic of the internet. " +
		"so don't be afraid to reach out. " +
		"because you never know who will reach back."]);

		texts = new FlxTypedGroup<FlxText>();
		add(texts);
		for (i in 0...credits.length)
		{
			if (credits[i].length == 0)
			{
				textY += 20;
			}
			else if (credits[i].length == 1)
			{
				var text:FlxText = makeText(400, credits[i][0]);
				text.alignment = "center";
				texts.add(text);

				textY += text.textField.textHeight;
			}
			else if (credits[i].length == 2)
			{
				var leftText:FlxText;
				var rightText:FlxText;
				if (StringTools.startsWith(credits[i][0], "!"))
				{
					leftText = makeText(190, credits[i][0].substr(1, credits[i][0].length - 1));
					leftText.alignment = "center";

					rightText = makeText(190, credits[i][1].substr(1, credits[i][1].length - 1));
					rightText.x += 200;
					rightText.alignment = "center";
				}
				else
				{
					leftText = makeText(120, credits[i][0]);
					leftText.alignment = "left";

					rightText = makeText(270, credits[i][1]);
					rightText.x += 130;
					rightText.alignment = "right";
				}
				texts.add(leftText);
				texts.add(rightText);
				textY += Math.max(leftText.textField.textHeight, rightText.textField.textHeight);
			}
		}

		var finalTrialCount:Int = AbraDialog.getFinalTrialCount();

		var sick:Bool = finalTrialCount >= 3 || finalTrialCount == 0;
		var verySick:Bool = finalTrialCount >= 4 || finalTrialCount == 0;

		maskCreditsTop = new FlxSprite(0, -4);
		maskCreditsTop.loadGraphic(AssetPaths.credits_blocker__png);
		add(maskCreditsTop);

		maskCreditsBot = new FlxSprite();
		maskCreditsBot.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(maskCreditsBot);

		bgImageOld = new FlxSprite();
		bgImageOld.visible = false;
		add(bgImageOld);

		bgImage = new FlxSprite();
		bgImage.visible = false;
		add(bgImage);

		mainCreditsImage = new FlxSprite(0, 19);
		mainCreditsImage.loadGraphic(AssetPaths.credits00__png);
		mainCreditsImage.x = FlxG.width / 2 - mainCreditsImage.width / 2;
		mainCreditsImage.alpha = 0;
		add(mainCreditsImage);

		zappedAbraImage = new FlxSprite(0, 19);
		zappedAbraImage.loadGraphic(AssetPaths.credits02__png);
		zappedAbraImage.x = FlxG.width / 2 - mainCreditsImage.width / 2;
		zappedAbraImage.alpha = 0;
		add(zappedAbraImage);

		creditsImageFinal = new FlxSprite(0, 0);
		creditsImageFinal.loadGraphic(AssetPaths.credits_final__png);
		creditsImageFinal.alpha = 0;
		add(creditsImageFinal);

		thanksImageFinal = new FlxSprite(0, 0);
		thanksImageFinal.loadGraphic(AssetPaths.credits_thanks__png);
		thanksImageFinal.alpha = 0;
		add(thanksImageFinal);

		otherCreditsImages = new FlxTypedGroup<FlxSprite>();
		add(otherCreditsImages);

		happyGrimerImage = new FlxSprite();
		happyGrimerImage.loadGraphic(AssetPaths.credits_grim1b__png);
		happyGrimerImage.alpha = 0;
		add(happyGrimerImage);

		if (verySick)
		{
			otherCreditsImageAssets[0] = AssetPaths.credits09_abraless__png;
		}
		else if (sick)
		{
			otherCreditsImageAssets[0] = AssetPaths.credits08c_abraless__png;
		}
		else {
			otherCreditsImageAssets[0] = AssetPaths.credits08c_abraless__png;
		}

		if (PlayerData.sfw)
		{
			otherCreditsImageAssets = [];
		}

		for (otherCreditsImageAsset in otherCreditsImageAssets)
		{
			var imageIndex:Int = otherCreditsImages.length;
			var otherCreditsImage:FlxSprite = new FlxSprite(0, 10);
			otherCreditsImage.loadGraphic(otherCreditsImageAsset);
			otherCreditsImage.x = FlxG.width / 2 - otherCreditsImage.width / 2 - 130;
			otherCreditsImage.x += IMAGE_CRAWL_SPACING * imageIndex;
			if (imageIndex % 2 == 1)
			{
				otherCreditsImage.y += otherCreditsImage.height + 10;
			}
			otherCreditsImage.x += FlxG.random.int( -3, 3);
			otherCreditsImage.y += FlxG.random.int( -4, 4);
			otherCreditsImage.visible = false;
			otherCreditsImages.add(otherCreditsImage);

			if (otherCreditsImageAsset == AssetPaths.credits_smea1__png)
			{
				smeargleImage = otherCreditsImage;
			}
			if (otherCreditsImageAsset == AssetPaths.credits_grim1__png)
			{
				sadGrimerImage = otherCreditsImage;
			}
		}

		wispLine = new WispLine();
		wispLine.age = 10000;

		wispLayer = new FlxSprite();
		wispLayer.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(wispLayer);

		wisp = new FlxEmitter(0, 0, 30);
		add(wisp);
		wisp.launchMode = FlxEmitterMode.CIRCLE;
		wisp.acceleration.set(0);
		wisp.alpha.set(1.0, 1.0, 0, 0);
		wisp.lifespan.set(1.2);
		wisp.scale.set(5);
		wisp.speed.set(40, 80, 0, 0);

		for (i in 0...wisp.maxSize)
		{
			var particle:FlxParticle = new FadeBlueParticle();
			particle.exists = false;
			wisp.add(particle);
		}

		smallSparkEmitter = new FlxTypedEmitter<LateFadingFlxParticle>(0, 0, 12);
		add(smallSparkEmitter);
		smallSparkEmitter.launchMode = FlxEmitterMode.SQUARE;
		smallSparkEmitter.angularVelocity.set(0);
		smallSparkEmitter.velocity.set(200, 200);
		smallSparkEmitter.lifespan.set(0.3);
		for (i in 0...smallSparkEmitter.maxSize)
		{
			var particle:LateFadingFlxParticle = new LateFadingFlxParticle();
			particle.makeGraphic(3, 3, FlxColor.WHITE);
			particle.offset.x = 1.5;
			particle.offset.y = 1.5;
			particle.exists = false;
			smallSparkEmitter.add(particle);
		}

		if (!PlayerData.sfw)
		{
			eventStack.addEvent({time:1.4, callback:eventFadeInImage, args:[AssetPaths.credits00__png]});
			musicEventStack.addEvent({time:12.8 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits01__png]});
			if (PlayerData.abraStoryInt == 5)
			{
				musicEventStack.addEvent({time:16.2, callback:eventZapAbra});
			}
			musicEventStack.addEvent({time:19.2 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits03__png]});
			musicEventStack.addEvent({time:25.6 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits04__png]});
			if (verySick)
			{
				musicEventStack.addEvent({time:35.6 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits05__png]});
				musicEventStack.addEvent({time:46.6 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits06__png]});
				musicEventStack.addEvent({time:51.2 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits07__png]});
				musicEventStack.addEvent({time:61.2 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits08__png]});
				musicEventStack.addEvent({time:79.1 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits09__png]});
			}
			else if (sick)
			{
				musicEventStack.addEvent({time:35.6 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits05__png]});
				musicEventStack.addEvent({time:46.6 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits06__png]});
				musicEventStack.addEvent({time:51.2 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits07b__png]});
				musicEventStack.addEvent({time:61.2 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits07c__png]});
				musicEventStack.addEvent({time:79.1 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits08c__png]});
			}
			else
			{
				musicEventStack.addEvent({time:35.6 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits05__png]});
				musicEventStack.addEvent({time:45.6 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits06c__png]});
				musicEventStack.addEvent({time:55.6 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits07c__png]});
				musicEventStack.addEvent({time:79.1 - 0.6, callback:eventCycleImage, args:[AssetPaths.credits08c__png]});
			}
			musicEventStack.addEvent({time:83.5, callback:eventFadeOutImage, args:[1.2]});
		}

		eventStack.addEvent({time:2.8, callback:eventFadeInCredits});
		eventStack.addEvent({time:5.0, callback:eventStartMusic});

		musicEventStack.addEvent({time:0, callback:eventMoveCredits});
		musicEventStack.addEvent({time:87.8, callback:eventFadeOutCredits, args:[1.2]});
		musicEventStack.addEvent({time:89.6 - 0.2, callback:eventFadeInImageCrawl, args:[0.4]});

		if (!PlayerData.sfw)
		{
			musicEventStack.addEvent({time:113.65, callback:eventSetImageVelocity, args:[IMAGE_CRAWL_X_VELOCITY * 0.25]});
			musicEventStack.addEvent({time:113.65, callback:eventFadeNonGrimerImage, args:[0.3]});
			musicEventStack.addEvent({time:113.65, callback:eventBgAlpha, args:[0, 0.3]});

			musicEventStack.addEvent({time:115.22 - 0.2, callback:grimerGrillVisitors, args:[0.4]});
			musicEventStack.addEvent({time:115.22 - 0.2, callback:eventUnfadeNonGrimerImage, args:[0.4]});
			musicEventStack.addEvent({time:115.22 - 0.2, callback:eventBgAlpha, args:[1.0, 0.4]});
			musicEventStack.addEvent({time:115.22, callback:eventSetImageVelocity, args:[IMAGE_CRAWL_X_VELOCITY]});
		}

		musicEventStack.addEvent({time:90.91, callback:eventChangeBg, args:[bgImageAssets[0]]});
		musicEventStack.addEvent({time:99.03, callback:eventChangeBg, args:[bgImageAssets[1]]});
		musicEventStack.addEvent({time:107.25, callback:eventChangeBg, args:[bgImageAssets[2]]});
		musicEventStack.addEvent({time:116.59, callback:eventChangeBg, args:[bgImageAssets[3]]});
		musicEventStack.addEvent({time:124.74, callback:eventChangeBg, args:[bgImageAssets[4]]});
		musicEventStack.addEvent({time:132.85, callback:eventChangeBg, args:[bgImageAssets[5]]});
		musicEventStack.addEvent({time:140.90, callback:eventChangeBg, args:[bgImageAssets[6]]});
		musicEventStack.addEvent({time:149.05, callback:eventChangeBg, args:[bgImageAssets[7]]});

		if (!PlayerData.sfw)
		{
			musicEventStack.addEvent({time:153.22, callback:smeargleButtSqueeze});
		}

		musicEventStack.addEvent({time:157.04, callback:eventChangeBg, args:[bgImageAssets[8]]});
		musicEventStack.addEvent({time:165.29, callback:eventChangeBg, args:[bgImageAssets[9]]});
		musicEventStack.addEvent({time:173.45, callback:eventBgAlpha, args:[0, 0.7]});

		if (!PlayerData.sfw)
		{
			musicEventStack.addEvent({time:180.6 - 0.4, callback:eventCycleImage, args:[AssetPaths.credits96__png]});
			musicEventStack.addEvent({time:188.6 - 0.4, callback:eventCycleImage, args:[AssetPaths.credits97__png]});
			musicEventStack.addEvent({time:196.6 - 0.4, callback:eventCycleImage, args:[AssetPaths.credits98__png]});
			musicEventStack.addEvent({time:204.4 - 0.6, callback:eventFadeOutImage, args:[0.4]});
			musicEventStack.addEvent({time:204.4 - 0.2, callback:eventFadeInFinalImage});
		}
	}

	/**
	 * We fade out all the images to bring the player's attention to the Grimer
	 * image, when the music gets a little sad and pauses
	 */
	function eventFadeNonGrimerImage(args:Array<Dynamic>)
	{
		var fadeDuration:Float = args[0];
		var index:Int = otherCreditsImages.members.indexOf(sadGrimerImage);
		FlxTween.tween(otherCreditsImages.members[index - 2], {alpha: 0.2}, fadeDuration);
		FlxTween.tween(otherCreditsImages.members[index - 1], {alpha: 0.2}, fadeDuration);
		FlxTween.tween(otherCreditsImages.members[index + 1], {alpha: 0.2}, fadeDuration);
		FlxTween.tween(otherCreditsImages.members[index + 2], {alpha: 0.2}, fadeDuration);
	}

	function eventUnfadeNonGrimerImage(args:Array<Dynamic>)
	{
		var fadeDuration:Float = args[0];
		var index:Int = otherCreditsImages.members.indexOf(sadGrimerImage);
		FlxTween.tween(otherCreditsImages.members[index - 2], {alpha: 1.0}, fadeDuration);
		FlxTween.tween(otherCreditsImages.members[index - 1], {alpha: 1.0}, fadeDuration);
		FlxTween.tween(otherCreditsImages.members[index + 1], {alpha: 1.0}, fadeDuration);
		FlxTween.tween(otherCreditsImages.members[index + 2], {alpha: 1.0}, fadeDuration);
	}

	function eventSetImageVelocity(args:Array<Dynamic>)
	{
		var velocity:Float = args[0];
		for (image in otherCreditsImages)
		{
			if (image != null)
			{
				image.velocity.x = velocity;
			}
		}
		happyGrimerImage.velocity.x = velocity;
	}

	function grimerGrillVisitors(args:Array<Dynamic>)
	{
		var fadeDuration:Float = args[0];
		happyGrimerImage.setPosition(sadGrimerImage.x, sadGrimerImage.y);
		happyGrimerImage.velocity.set(sadGrimerImage.velocity.x, sadGrimerImage.velocity.y);
		FlxTween.tween(happyGrimerImage, {alpha:1.0}, fadeDuration);
	}

	function smeargleButtSqueeze(args:Array<Dynamic>)
	{
		smeargleImage.loadGraphic(AssetPaths.credits_smea1b__png);
		emitSmallSpark(smeargleImage.x + 133, smeargleImage.y + 133);
	}

	function emitSmallSpark(x:Float, y:Float):Void
	{
		smallSparkEmitter.setPosition(x, y);
		smallSparkEmitter.start(true, 0, 1);
		for (i in 0...8)
		{
			var particle:LateFadingFlxParticle = smallSparkEmitter.emitParticle();
			particle.enableLateFade(2);
			if (i % 8 < 4)
			{
				particle.velocity.x *= 0.5;
				particle.velocity.y *= 0.5;
			}
			if (i % 4 < 2)
			{
				particle.velocity.x *= -1;
			}
			if (i % 2 < 1)
			{
				particle.velocity.y *= -1;
			}
		}
		smallSparkEmitter.emitting = false;
	}

	private function eventFadeInImageCrawl(args:Array<Dynamic>)
	{
		var fadeDuration:Float = args[0];

		if (!PlayerData.sfw)
		{
			remove(mainCreditsImage);
			var imageIndex:Int = otherCreditsImages.length;
			mainCreditsImage.y = 10;
			mainCreditsImage.x = FlxG.width / 2 - mainCreditsImage.width / 2 - 130;
			mainCreditsImage.x += IMAGE_CRAWL_SPACING * imageIndex;
			if (imageIndex % 2 == 1)
			{
				mainCreditsImage.y += mainCreditsImage.height + 10;
			}
			mainCreditsImage.x += FlxG.random.int( -3, 3);
			mainCreditsImage.y += FlxG.random.int( -4, 4);
			mainCreditsImage.visible = false;
			mainCreditsImage.loadGraphic(AssetPaths.credits95__png);
			otherCreditsImages.add(mainCreditsImage);
		}

		for (image in otherCreditsImages)
		{
			if (image != null)
			{
				image.alpha = 0;
				image.visible = true;
				image.velocity.x = IMAGE_CRAWL_X_VELOCITY;
			}
		}

		fadeInOtherCreditsImages(fadeDuration);
	}

	private function eventFadeOutImage(args:Array<Dynamic>)
	{
		var fadeDuration:Float = args[0];
		FlxTween.tween(mainCreditsImage, {alpha:0.0}, fadeDuration);
	}

	private function eventCycleImage(args:Array<Dynamic>)
	{
		var graphicAsset:FlxGraphicAsset = args[0];
		eventFadeOutImage([0.4]);
		eventStack.addEvent({time:eventStack._time + 0.4, callback:eventFadeInImage, args:[graphicAsset]});
	}

	private function eventZapAbra(args:Array<Dynamic>)
	{
		zappedAbraImage.alpha = 1.0;
		FlxTween.tween(zappedAbraImage, {alpha:0.0}, 2.4);
		wisp.start(false);
		for (i in 0...24)
		{
			wisp.x = FlxG.random.float(zappedAbraImage.x + zappedAbraImage.width * 0.25, zappedAbraImage.x + zappedAbraImage.width * 0.75);
			wisp.y = FlxG.random.float(zappedAbraImage.y + zappedAbraImage.height * 0.5, zappedAbraImage.y + zappedAbraImage.height * 0.9);
			wisp.emitParticle();
		}
		wisp.emitting = false;

		wispLine.set(0, -100, 10, zappedAbraImage.x + zappedAbraImage.width * 0.35, zappedAbraImage.y + zappedAbraImage.height * 0.75, 4);
		wispLine.age = 0;
	}

	private function eventFadeInImage(args:Array<Dynamic>)
	{
		var graphicAsset:FlxGraphicAsset = args[0];
		mainCreditsImage.loadGraphic(graphicAsset);
		mainCreditsImage.alpha = 0;
		FlxTween.tween(mainCreditsImage, {alpha:1.0}, 0.4);
	}

	private function eventFadeInFinalImage(args:Array<Dynamic>)
	{
		creditsImageFinal.alpha = 0;
		FlxTween.tween(creditsImageFinal, {alpha:1.0}, 0.4);
		eventStack.addEvent({time:eventStack._time + 2.0, callback:eventFadeInThanksImage, args:[0.2]});
	}

	private function eventFadeInThanksImage(args:Array<Dynamic>)
	{
		var graphicAsset:FlxGraphicAsset = AssetPaths.credits_thanks__png;

		thanksImageFinal.alpha = 0;
		FlxTween.tween(thanksImageFinal, {alpha:1.0}, 0.2);
	}

	private function eventFadeInCredits(args:Array<Dynamic>)
	{
		FlxTween.tween(maskCreditsBot, {alpha:0.0}, 0.4);
	}

	private function eventFadeOutCredits(args:Array<Dynamic>)
	{
		var fadeTime:Float = args[0];
		FlxTween.tween(maskCreditsBot, {alpha:1.0}, fadeTime);
	}

	private function eventMoveCredits(args:Array<Dynamic>)
	{
		setTextVelocity(-24.5);
	}

	private function eventStartMusic(args:Array<Dynamic>)
	{
		FlxG.sound.playMusic(FlxSoundKludge.fixPath(AssetPaths.hyper_potions_littleroot_town__mp3), 0.28, false);
	}

	private function setTextVelocity(velocity:Float)
	{
		for (textObject in texts.members)
		{
			if (textObject != null)
			{
				textObject.velocity.y = velocity;
			}
		}
	}

	private function makeText(fieldWidth:Float, text:String):FlxText
	{
		var textObject:FlxText = new FlxText(FlxG.width * 0.5 - 200, textY, fieldWidth);
		textObject.moves = true;
		textObject.setFormat(AssetPaths.hardpixel__otf, 20);

		if (text != null && StringTools.startsWith(text, "#"))
		{
			textObject.text = text.substring(1);
			textObject.color = ItemsMenuState.MEDIUM_BLUE;
		}
		else {
			textObject.text = text;
		}

		return textObject;
	}

	private function fadeOutOtherCreditsImages(fadeDuration:Float)
	{
		while (otherCreditsMinIndex < otherCreditsImages.length
				&& otherCreditsImages.members[otherCreditsMinIndex].x < -50)
		{
			FlxTween.tween(otherCreditsImages.members[otherCreditsMinIndex], {alpha:0.0}, fadeDuration);
			otherCreditsMinIndex++;
		}
	}

	private function fadeInOtherCreditsImages(fadeDuration:Float)
	{
		while (otherCreditsMaxIndex < otherCreditsImages.length
				&& otherCreditsImages.members[otherCreditsMaxIndex].visible
				&& otherCreditsImages.members[otherCreditsMaxIndex].x < FlxG.width - 80)
		{
			otherCreditsImages.members[otherCreditsMaxIndex].alpha = 0;
			FlxTween.tween(otherCreditsImages.members[otherCreditsMaxIndex], {alpha:1.0}, fadeDuration);
			otherCreditsMaxIndex++;
		}
	}

	public function eventChangeBg(args:Array<Dynamic>)
	{
		var graphic:FlxGraphicAsset = args[0];
		if (bgImage.visible)
		{
			bgImageOld.loadGraphicFromSprite(bgImage);
			bgImageOld.visible = true;
		}
		bgImage.loadGraphic(graphic);
		bgImage.visible = true;
		bgImage.alpha = 0;
		FlxTween.tween(bgImage, {alpha:1.0}, 0.7);
	}

	public function eventBgAlpha(args:Array<Dynamic>)
	{
		var alpha:Float = args[0];
		var duration:Float = args[1];
		FlxTween.tween(bgImage, {alpha:alpha}, duration);
		bgImageOld.visible = false;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		eventStack.update(elapsed);
		musicEventStack.update(elapsed);

		fadeOutOtherCreditsImages(3.6);
		fadeInOtherCreditsImages(3.6);

		if (mainCreditsImage.x < FlxG.width / 2 - mainCreditsImage.width / 2 && mainCreditsImage.velocity.x < 0)
		{
			// stop other credits scroll
			for (otherCreditsImage in otherCreditsImages.members)
			{
				otherCreditsImage.velocity.x = 0;
				if (otherCreditsImage != mainCreditsImage && otherCreditsImage.alpha > 0.5)
				{
					FlxTween.tween(otherCreditsImage, {alpha:0.0}, 3.6);
				}
			}
			mainCreditsImage.x = FlxG.width / 2 - mainCreditsImage.width / 2;
		}

		if (!scheduledFadeOut)
		{
			if (texts.members[texts.members.length - 1].y + texts.members[texts.members.length - 1].height <= FlxG.height)
			{
				setTextVelocity(0);
				scheduledFadeOut = true;
			}
		}

		if (wispLine.age < 5)
		{
			wispLayer.visible = true;
			FlxSpriteUtil.fill(wispLayer, FlxColor.TRANSPARENT);
			wispLine.update(elapsed);
			wispLine.draw(wispLayer);
		}
		else {
			wispLayer.visible = false;
		}

		if (FlxG.keys.justPressed.ESCAPE && backToMainMenu)
		{
			transOut = MainMenuState.fadeOutSlow();
			FlxG.switchState(new MainMenuState(MainMenuState.fadeInFast()));
		}

		if (FlxG.mouse.justPressed)
		{
			if (!eventStack._alive && !musicEventStack._alive)
			{
				if (PlayerData.abraStoryInt == 6)
				{
					// didn't swap
					transOut = MainMenuState.fadeOutSlow();
					FlxG.switchState(new MainMenuState(MainMenuState.fadeInFast()));
				}
				else if (backToMainMenu)
				{
					// replaying credits
					transOut = MainMenuState.fadeOutSlow();
					FlxG.switchState(new MainMenuState(MainMenuState.fadeInFast()));
				}
				else
				{
					transOut = MainMenuState.fadeOutSlow();
					FlxG.switchState(new GloveWakeUpState(MainMenuState.fadeInFast()));
				}
			}
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		/*
		 * Destroy any music objects, so music doesn't continue playing after
		 * we switch states. ...We could just stop the music object, but
		 * having a non-playing music object can cause some unexpected behavior
		 * too, as our eventing is based on the number of seconds that have
		 * played in a song.
		 */
		FlxG.sound.music = FlxDestroyUtil.destroy(FlxG.sound.music);

		musicEventStack = null;
		eventStack = null;
		credits = null;
		texts = FlxDestroyUtil.destroy(texts);
		mainCreditsImage = FlxDestroyUtil.destroy(mainCreditsImage);
		zappedAbraImage = FlxDestroyUtil.destroy(zappedAbraImage);
		sadGrimerImage = FlxDestroyUtil.destroy(sadGrimerImage);
		happyGrimerImage = FlxDestroyUtil.destroy(happyGrimerImage);
		smeargleImage = FlxDestroyUtil.destroy(smeargleImage);
		bgImage = FlxDestroyUtil.destroy(bgImage);

		creditsImageFinal = FlxDestroyUtil.destroy(creditsImageFinal);
		thanksImageFinal = FlxDestroyUtil.destroy(thanksImageFinal);
		otherCreditsImages = FlxDestroyUtil.destroy(otherCreditsImages);
		bgImageAssets = null;
		otherCreditsImageAssets = null;
		wisp = FlxDestroyUtil.destroy(wisp);
		wispLine = FlxDestroyUtil.destroy(wispLine);
		wispLayer = FlxDestroyUtil.destroy(wispLayer);
		smallSparkEmitter = FlxDestroyUtil.destroy(smallSparkEmitter);
		maskCreditsBot = FlxDestroyUtil.destroy(maskCreditsBot);
		maskCreditsTop = FlxDestroyUtil.destroy(maskCreditsTop);
	}
}