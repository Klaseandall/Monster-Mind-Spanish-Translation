package;
import critter.Critter;
import critter.Critter.CritterColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSort;
import puzzle.PuzzleState;
import puzzle.RankTracker;

/**
 * The splash screen which is displayed when the player first launches the game.
 *
 * It has a few giant bugs, and a hand and a "Monster Mind" sign.
 */
class SplashScreenState extends FlxTransitionableState
{
	private var shadowGroup:ShadowGroup;
	private var fgGroup:FlxTypedGroup<FlxSprite>;
	private var colorCount:Int = 0;

	private var critterCountMap:Map<Int, Int> = [
				0 => 2,
				1 => 3,
				2 => 2,
				3 => 3,
				4 => 2,
				5 => 3,
				6 => 2,
				7 => 3,
				8 => 2,
				9 => 3,
				10 => 4,
				11 => 3,
				12 => 4,
				13 => 3,
				14 => 4,
				15 => 5,
				16 => 4,
				17 => 5,
				18 => 4,
				19 => 5,
				20 => 5,
				21 => 5,
				22 => 6,
				23 => 5,
				24 => 6,
				25 => 7,
				26 => 6,
				27 => 7,
				28 => 8,
				29 => 7,
				30 => 8,
				31 => 9,
				32 => 9,
				33 => 10,
				34 => 10,
				35 => 11,
				36 => 11,
				37 => 12,
				38 => 12,
				39 => 13,
				40 => 13,
				41 => 14,
				42 => 14,
				43 => 15,
				44 => 15,
				45 => 16,
				46 => 17,
				47 => 18,
				48 => 19,
				49 => 20,
				50 => 21,
				51 => 22,
				52 => 23,
				53 => 24,
				54 => 25,
				55 => 26,
				56 => 27,
				57 => 28,
				58 => 29,
				59 => 30,
				60 => 30,
				61 => 30,
				62 => 30,
				63 => 30,
				64 => 30,
				65 => 30,
			];

	public function new()
	{
		super(new TransitionData(TransitionType.NONE), MainMenuState.fadeInFast());
	}

	override public function create():Void
	{
		Main.overrideFlxGDefaults();
		super.create();

		var shaderColor:FlxColor;
		var shaderAlpha:Float = 0;
		var wealth:Int = MainMenuState.getTotalWealth();

		var bgShader:FlxSprite = new FlxSprite();
		/*
		 * The background color changes as the player earns more money
		 */
		if (wealth >= 80000)
		{
			shaderColor = 0xfff6d481;
			shaderAlpha = (wealth - 80000) / (400000 - 80000);
			bgColor = 0xff438cb4;
		}
		else if (wealth >= 40000)
		{
			shaderColor = 0xff438cb4;
			shaderAlpha = (wealth - 40000) / (80000 - 40000);
			bgColor = 0xff6e5384;
		}
		else {
			shaderColor = 0xff6e5384;
			shaderAlpha = (wealth - 0) / (40000 - 0);
			bgColor = 0xff516951;
		}
		bgShader.alpha = FlxMath.bound(shaderAlpha, 0.0, 1.0);
		bgShader.makeGraphic(FlxG.width, FlxG.height, shaderColor);
		add(bgShader);

		var bgSwoosh:FlxSprite = new FlxSprite();
		bgSwoosh.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		{
			var swooshStamp:FlxSprite = new FlxSprite();
			swooshStamp.loadGraphic(AssetPaths.splash_bg_swoosh__png, true, FlxG.width, FlxG.height);
			for (i in 0...3)
			{
				if (FlxG.random.bool())
				{
					swooshStamp.animation.frameIndex = FlxG.random.int(0, swooshStamp.animation.numFrames - 1);
					swooshStamp.flipX = FlxG.random.bool();
					bgSwoosh.stamp(swooshStamp);
				}
			}
		}
		bgSwoosh.alpha = 0.25;
		add(bgSwoosh);

		Critter.initialize();
		Critter.shuffleCritterColors();

		colorCount = FlxG.random.getObject([3, 4, 4, 5, 5, 6]);

		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;

		shadowGroup = new ShadowGroup();
		add(shadowGroup);
		fgGroup = new FlxTypedGroup<FlxSprite>();
		add(fgGroup);

		addSign(169, 260);

		/*
		 * The number of bugs increases as the player increases their rank
		 */
		var critterCount:Int = 2;
		var rank:Int = RankTracker.computeAggregateRank();
		if (critterCountMap[rank] != null)
		{
			critterCount = critterCountMap[RankTracker.computeAggregateRank()];
		}
		else if (rank > 60)
		{
			critterCount = 30;
		}

		var critterPositions:Array<FlxPoint> = [
				new FlxPoint(0.0, 0.0), new FlxPoint(1.0, 0.0), new FlxPoint(4.5, 0.0),
				new FlxPoint(0.5, 1.0), new FlxPoint(3.8, 1.1),
				new FlxPoint(0.0, 2.0), new FlxPoint(1.0, 2.0),
				new FlxPoint(0.5, 3.0), new FlxPoint(4.0, 2.3), new FlxPoint(5.0, 3.0),
				new FlxPoint(0.0, 4.0), new FlxPoint(1.0, 4.0), new FlxPoint(2.0, 4.0), new FlxPoint(3.0, 4.0), new FlxPoint(4.0, 4.0), new FlxPoint(5.0, 4.0),
				new FlxPoint(0.5, 5.0), new FlxPoint(1.6, 5.0), new FlxPoint(2.7, 5.0),
				new FlxPoint(0.0, 6.0), new FlxPoint(1.0, 6.0), new FlxPoint(2.0, 6.0), new FlxPoint(3.0, 6.0), new FlxPoint(4.0, 6.0),
				new FlxPoint(0.5, 7.0), new FlxPoint(1.5, 7.0), new FlxPoint(2.5, 7.0), new FlxPoint(3.5, 7.0), new FlxPoint(4.5, 7.0), new FlxPoint(5.5, 7.0),
											   ];

		if (critterCount < 10)
		{
			// avoid outermost critter positions
			critterPositions = [
								   new FlxPoint(0.5, 1.0),
								   new FlxPoint(1.0, 2.0),
								   new FlxPoint(0.5, 3.0),
								   new FlxPoint(1.0, 4.0), new FlxPoint(2.0, 4.0), new FlxPoint(3.0, 4.0), new FlxPoint(4.0, 4.0),
								   new FlxPoint(0.5, 5.0), new FlxPoint(1.6, 5.0), new FlxPoint(2.7, 5.0),
								   new FlxPoint(1.0, 6.0), new FlxPoint(2.0, 6.0), new FlxPoint(3.0, 6.0), new FlxPoint(4.0, 6.0),
							   ];
		}

		FlxG.random.shuffle(critterPositions);

		critterPositions.splice(0, critterPositions.length - critterCount);

		for (critterPosition in critterPositions)
		{
			addCritter(critterPosition.x * 150
					   + FlxG.random.int( -15, 15)
					   - 75
					   , critterPosition.y * 60
					   + FlxG.random.int( -15, 15)
					   + 60
					  );
		}
		if (PlayerData.cursorType == "none")
		{
			// don't add hand; hand is missing
		}
		else {
			addHand(FlxG.random.int(530, 550), 375);
		}
		addBox(FlxG.random.int(567, 587), 164);

		fgGroup.sort(FlxSort.byY);
	}

	function addBox(x:Float, y:Float)
	{
		var box:FlxSprite = new FlxSprite(x, y, AssetPaths.splash_box__png);
		box.offset.set(0, 183);
		fgGroup.add(box);

		var boxShadow:FlxSprite = new FlxSprite(x, y, AssetPaths.splash_box_shadow__png);
		boxShadow.offset.set(0, 183);
		boxShadow.alpha = 0.5;
		shadowGroup._extraShadows.push(boxShadow);
	}

	function addHand(x:Float, y:Float)
	{
		var hand:FlxSprite = new FlxSprite(x, y);
		CursorUtils.initializeCustomHandBouncySprite(hand, AssetPaths.splash_hand__png, 250, 250);
		hand.offset.set(0, 167);
		fgGroup.add(hand);

		var handGuts:FlxSprite = new FlxSprite(x, y + 1, AssetPaths.splash_hand_electronics__png);
		handGuts.offset.set(0, 167 + 1);
		fgGroup.add(handGuts);

		var handLight:FlxSprite = new FlxSprite(x, y + 2, AssetPaths.splash_hand_light__png);
		handLight.alpha = 0;
		handLight.offset.set(0, 167 + 2);
		fgGroup.add(handLight);
		FlxTween.tween(handLight, {alpha:1}, 2.6, {ease:FlxEase.expoInOut, type:FlxTweenType.PINGPONG});

		var handShadow:FlxSprite = new FlxSprite(x, y, AssetPaths.splash_hand_shadow__png);
		handShadow.offset.set(0, 167);
		handShadow.alpha = hand.alpha;
		shadowGroup._extraShadows.push(handShadow);
	}

	function addCritter(x:Float, y:Float)
	{
		var critterBody:FlxSprite = new FlxSprite(x, y);
		var colorIndex:Int = FlxG.random.int(0, colorCount - 1);
		colorIndex = Std.int(FlxMath.bound(colorIndex, 0, Critter.CRITTER_COLORS.length - 1));
		var critterColor:CritterColor = Critter.CRITTER_COLORS[colorIndex];
		Critter.loadPaletteShiftedGraphic(critterBody, critterColor, AssetPaths.splash_critter_body__png, true, 150, 200);
		critterBody.offset.set(0, 125);
		critterBody.animation.frameIndex = FlxG.random.int(0, critterBody.animation.numFrames);
		critterBody.flipX = FlxG.random.bool();
		fgGroup.add(critterBody);

		var critterHead:FlxSprite = new FlxSprite(x, y + 1);
		Critter.loadPaletteShiftedGraphic(critterHead, critterColor, AssetPaths.splash_critter_head__png, true, 150, 200);
		critterHead.offset.set(0, 125 + 1);
		critterHead.flipX = critterBody.flipX;

		var idleAnim:Array<Int> = [];
		AnimTools.push(idleAnim, FlxG.random.int(7, 10), [0, 1, 2, 3, 4]);
		AnimTools.push(idleAnim, FlxG.random.int(3, 4), [7, 8, 9]);
		AnimTools.push(idleAnim, FlxG.random.int(7, 10), [0, 1, 2, 3, 4]);
		AnimTools.push(idleAnim, FlxG.random.int(3, 4), [7, 8, 9]);
		AnimTools.push(idleAnim, FlxG.random.int(7, 10), [0, 1, 2, 3, 4]);
		AnimTools.push(idleAnim, FlxG.random.int(3, 4), [7, 8, 9]);
		AnimTools.push(idleAnim, FlxG.random.int(7, 10), [0, 1, 2, 3, 4]);
		AnimTools.push(idleAnim, FlxG.random.int(3, 4), [7, 8, 9]);
		AnimTools.push(idleAnim, FlxG.random.int(7, 10), [0, 1, 2, 3, 4]);
		AnimTools.push(idleAnim, FlxG.random.int(3, 4), [7, 8, 9]);
		AnimTools.push(idleAnim, FlxG.random.int(7, 10), [0, 1, 2, 3, 4]);
		AnimTools.push(idleAnim, FlxG.random.int(3, 4), [7, 8, 9]);

		var blinkFrame:Int = FlxG.random.int(0, 15);
		while (blinkFrame < idleAnim.length)
		{
			if (idleAnim[blinkFrame] >= 0 && idleAnim[blinkFrame] <= 4)
			{
				idleAnim[blinkFrame] = FlxG.random.getObject([5, 6]);
			}
			else if (idleAnim[blinkFrame] >= 7 && idleAnim[blinkFrame] <= 9)
			{
				idleAnim[blinkFrame] = FlxG.random.getObject([10, 11]);
			}
			blinkFrame += FlxG.random.int(6, 15);
		}

		// slide it over a bit
		AnimTools.shift(idleAnim);

		critterHead.animation.add("default", idleAnim, Critter._FRAME_RATE);
		critterHead.animation.play("default");
		fgGroup.add(critterHead);

		var critterShadow:FlxSprite = new FlxSprite(x, y);
		critterShadow.loadGraphic(AssetPaths.splash_critter_shadow__png, true, 150, 200);
		critterShadow.offset.set(0, 125);
		critterShadow.flipX = critterBody.flipX;
		critterShadow.animation.add("default", idleAnim, Critter._FRAME_RATE);
		critterShadow.animation.play("default");
		shadowGroup._extraShadows.push(critterShadow);
	}

	function addSign(x:Float, y:Float)
	{
		var sign:FlxSprite = new FlxSprite(x, y, AssetPaths.splash_sign__png);
		sign.offset.set(0, 260);
		fgGroup.add(sign);

		var signShadow:FlxSprite = new FlxSprite(x, y, AssetPaths.splash_sign_shadow__png);
		signShadow.offset.set(0, 260);
		shadowGroup._extraShadows.push(signShadow);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.ESCAPE || FlxG.mouse.justPressed)
		{
			SoundStackingFix.play(AssetPaths.click1_00cb__mp3, 0.6);
			if (PlayerData.name == null)
			{
				if (PlayerData.puzzleCount[0] <= 2)
				{
					PlayerData.level = PlayerData.puzzleCount[0];
				}
				PlayerData.profIndex = PlayerData.PROF_NAMES.indexOf("Grovyle");
				PlayerData.difficulty = PlayerData.Difficulty.Easy;
				FlxG.switchState(new PuzzleState(MainMenuState.fadeInFast()));
				return;
			}
			else
			{
				FlxG.switchState(new MainMenuState(MainMenuState.fadeInFast()));
			}
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		shadowGroup = FlxDestroyUtil.destroy(shadowGroup);
		fgGroup = FlxDestroyUtil.destroy(fgGroup);
		critterCountMap = null;
	}
}