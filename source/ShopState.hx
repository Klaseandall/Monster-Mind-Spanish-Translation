package;

import MmStringTools.*;
import critter.Critter;
import critter.CritterBody;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import kludge.FlxSoundKludge;
import kludge.FlxSpriteKludge;
import minigame.MinigameState;
import openfl.Assets;
import openfl.utils.Object;
import poke.abra.AbraResource;
import poke.hera.HeraResource;
import poke.hera.HeraShopDialog;
import poke.kecl.KecleonDialog;
import poke.magn.MagnDialog;
import poke.magn.MagnResource;
import poke.rhyd.RhydonDialog;
import poke.sand.SandslashResource;
import poke.sexy.SexyState;
import poke.smea.SmeargleDialog;

/**
 * FlxState for the shop screen; the screen where Heracross (or sometimes
 * Kecleon) offers to sell the player items.
 */
class ShopState extends FlxTransitionableState
{
	private var _bgSprite:FlxSprite;
	private var _handSprite:FlxSprite;
	private var _itemSprites:FlxTypedGroup<FlxSprite>;

	private var _shadowGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	private var _shadowMap:Map<FlxSprite, FlxSprite> = new Map<FlxSprite, FlxSprite>();

	private var _itemSpriteToItemMap:Map<FlxSprite, ItemDatabase.ShopItem> = new Map<FlxSprite, ItemDatabase.ShopItem>();
	private var _critterToItemMap:Map<Critter, ItemDatabase.ShopItem> = new Map<Critter, ItemDatabase.ShopItem>();
	private var _cashWindow:CashWindow;
	private var _dialogTree:DialogTree;
	private var _dialogger:Dialogger;
	private var _clickedItemSprite:FlxSprite;
	private var _justPurchasedSprite:FlxSprite;
	private var _backButton:FlxButton;
	private var _denArrow:FlxSprite;

	private var _crackerSprite:FlxSprite;
	private var _crumbSprite:FlxSprite;
	private var _crackerClickCount:Int = 0;

	private var _abraSprites:Array<FlxSprite> = [];
	private var _sandSprites:Array<FlxSprite> = [];
	private var _keclSprites:Array<FlxSprite> = [];
	private var _heraSprites:Array<FlxSprite> = [];

	// for critters...
	private var _critters:Array<Critter> = [];
	private var _targetSprites:FlxTypedGroup<FlxSprite>;
	private var _midInvisSprites:FlxTypedGroup<FlxSprite>;
	private var _midSprites:FlxTypedGroup<FlxSprite>;
	private var _critterShadowGroup:ShadowGroup;

	private var _kecleonPoseTimer:Float = 0;

	public function new(?TransIn:TransitionData, ?TransOut:TransitionData)
	{
		super(TransIn, TransOut);
	}

	override public function create():Void
	{
		super.create();
		Main.overrideFlxGDefaults();
		PlayerData.profIndex = -1; // clear profIndex, to avoid hasMet() goofups
		Critter.initialize(Critter.LOAD_ALL); // load all critters, so player can view them in shop

		ItemDatabase.refillShop();
		ItemDatabase._newItems = false;

		_bgSprite = new FlxSprite(0, 0);
		_bgSprite.loadGraphic(AssetPaths.shop_bg__png, true, 768, 432, true);
		add(_bgSprite);

		_denArrow = new BouncySprite(191, 44, 6, 4, 0);
		_denArrow.loadGraphic(AssetPaths.shop_den_arrow__png, true, 60, 40);
		_denArrow.animation.add("default", AnimTools.blinkyAnimation([0, 1]), 3);
		_denArrow.animation.play("default");
		_denArrow.visible = false;
		add(_denArrow);

		if (isDenDoorOpen())
		{
			_bgSprite.animation.frameIndex = 1;
		}

		if (ItemDatabase._magnezoneStatus == ItemDatabase.MagnezoneStatus.Absent)
		{
			// magnezone is not in the shop
		}
		else {
			var mx = 510;
			var my = -30;

			var magnTail:BouncySprite = new BouncySprite(mx, my, 14, 8.8, 0);
			magnTail.loadGraphic(AssetPaths.shop_magn_tail__png);
			add(magnTail);

			var magnLeftScrew:BouncySprite = new BouncySprite(mx, my, 10, 8.8, 0.18);
			magnLeftScrew.loadGraphic(AssetPaths.shop_magn_left_screw__png);
			add(magnLeftScrew);

			var magnLeftHead:BouncySprite = new BouncySprite(mx, my, 12, 8.8, 0.16);
			magnLeftHead.loadGraphic(AssetPaths.shop_magn_left_head__png, true, 300, 300);
			magnLeftHead.animation.add("play0", AnimTools.slowBlinkyAnimation([0, 1], [2]), 3);
			magnLeftHead.animation.add("play1", AnimTools.slowBlinkyAnimation([4, 5], [6]), 3);
			magnLeftHead.animation.add("play2", AnimTools.slowBlinkyAnimation([8, 9], [6]), 3);
			magnLeftHead.animation.add("play3", AnimTools.slowBlinkyAnimation([10, 11], [6]), 3);
			add(magnLeftHead);

			var magnLeftHand:BouncySprite = new BouncySprite(mx, my, 14, 8.8, 0.08);
			magnLeftHand.loadGraphic(AssetPaths.shop_magn_left_hand__png);
			add(magnLeftHand);

			var magnBody:BouncySprite = new BouncySprite(mx, my, 12, 8.8, 0.16);
			magnBody.loadGraphic(AssetPaths.shop_magn_body__png, true, 300, 300);
			magnBody.animation.add("play0", AnimTools.slowBlinkyAnimation([0, 1], [2]), 3);
			magnBody.animation.add("play1", AnimTools.slowBlinkyAnimation([4, 5], [6]), 3);
			magnBody.animation.add("play2", AnimTools.slowBlinkyAnimation([8, 9], [6]), 3);
			magnBody.animation.add("play3", AnimTools.slowBlinkyAnimation([10, 11], [7]), 3);
			add(magnBody);

			var magnRightScrew:BouncySprite = new BouncySprite(mx, my, 10, 8.8, 0.18);
			magnRightScrew.loadGraphic(AssetPaths.shop_magn_right_screw__png);
			add(magnRightScrew);

			var magnRightHead:BouncySprite = new BouncySprite(mx, my, 12, 8.8, 0.16);
			magnRightHead.loadGraphic(AssetPaths.shop_magn_right_head__png, true, 300, 300);
			magnRightHead.animation.add("play0", AnimTools.slowBlinkyAnimation([0, 1], [2]), 3);
			magnRightHead.animation.add("play1", AnimTools.slowBlinkyAnimation([4, 5], [6]), 3);
			magnRightHead.animation.add("play2", AnimTools.slowBlinkyAnimation([8, 9], [6]), 3);
			magnRightHead.animation.add("play3", AnimTools.slowBlinkyAnimation([10, 11], [6]), 3);
			add(magnRightHead);

			var magnRightHand:BouncySprite = new BouncySprite(mx, my, 14, 8.8, 0.08);
			magnRightHand.loadGraphic(AssetPaths.shop_magn_right_hand__png);
			add(magnRightHand);

			var animName:String;
			switch (ItemDatabase._magnezoneStatus)
			{
				case ItemDatabase.MagnezoneStatus.Suspicious: animName = "play1";
				case ItemDatabase.MagnezoneStatus.Calm: animName = "play2";
				case ItemDatabase.MagnezoneStatus.Happy: animName = "play3"; MagnResource.chat = AssetPaths.magn_chat_hatless__png;
				default: animName = "play0";
			}
			magnLeftHead.animation.play(animName);
			magnBody.animation.play(animName);
			magnRightHead.animation.play(animName);
		}

		{
			var ax:Int = -90;
			var ay:Int = 0;

			var abraPants:BouncySprite = new BouncySprite(ax, ay, 0, 7.0, 0);
			abraPants.loadGraphic(AbraResource.shopPants);
			add(abraPants);
			_abraSprites.push(abraPants);

			var abraTorso:BouncySprite = new BouncySprite(ax, ay, 0, 7.0, 0);
			abraTorso.loadGraphic(AssetPaths.shop_abra_torso__png);
			add(abraTorso);
			_abraSprites.push(abraTorso);

			var abraHead:BouncySprite = new BouncySprite(ax, ay + 3, 3, 7.0, 0);
			abraHead.loadGraphic(AbraResource.shopHead, true, 300, 300);
			abraHead.animation.add("default", AnimTools.blinkyAnimation([0, 1]), 3);
			abraHead.animation.play("default");
			add(abraHead);
			_abraSprites.push(abraHead);
		}

		{
			var sx:Int = 48;
			var sy:Int = 21;

			var sandTail:BouncySprite = new BouncySprite(sx, sy, 6, 5.0, 0.9);
			sandTail.loadGraphic(AssetPaths.shop_sand_tail__png);
			add(sandTail);
			_sandSprites.push(sandTail);

			var sandBody:BouncySprite = new BouncySprite(sx, sy, 0, 5.0, 0);
			sandBody.loadGraphic(SandslashResource.shopBody);
			add(sandBody);
			_sandSprites.push(sandBody);

			var sandQuills:BouncySprite = new BouncySprite(sx, sy + 3, 3, 5.0, 0);
			sandQuills.loadGraphic(AssetPaths.shop_sand_quills__png);
			add(sandQuills);
			_sandSprites.push(sandQuills);

			var sandHead:BouncySprite = new BouncySprite(sx, sy + 3, 3, 5.0, 0.1);
			sandHead.loadGraphic(SandslashResource.shopHead, true, 300, 300);
			sandHead.animation.add("default", AnimTools.blinkyAnimation([0, 1], [2]), 3);
			sandHead.animation.play("default");
			add(sandHead);
			_sandSprites.push(sandHead);
		}

		var keclSprite0:BouncySprite = new BouncySprite(288, -10, 0, 6.5, 0);
		keclSprite0.loadGraphic(AssetPaths.shop_kecl0__png, true, 200, 300);
		keclSprite0.animation.add("slouch", [0]);
		keclSprite0.animation.add("unslouch", [1]);
		keclSprite0.animation.play("slouch");
		_keclSprites.push(keclSprite0);
		add(keclSprite0);

		var heraSprite0:BouncySprite = new BouncySprite(0, -2, 3, 4.5, 0);
		heraSprite0.loadGraphic(HeraResource.shop, true, 768, 432);
		heraSprite0.animation.add("play", AnimTools.blinkyAnimation([0, 1], [2]), 3);
		heraSprite0.animation.play("play");
		_heraSprites.push(heraSprite0);
		add(heraSprite0);

		add(new FlxSprite(0, 0, AssetPaths.shop_table__png));

		add(_shadowGroup);

		var _sandArm:FlxSprite = new FlxSprite(48, 21, AssetPaths.shop_sand_arm__png);
		_sandSprites.push(_sandArm);
		add(_sandArm);

		var heraSprite1:FlxSprite = new FlxSprite(0, 0, AssetPaths.shop_hera1__png);
		_heraSprites.push(heraSprite1);
		add(heraSprite1);

		var keclSprite1:FlxSprite = new BouncySprite(288, -10, 0, 6.5, 0);
		keclSprite1.loadGraphic(AssetPaths.shop_kecl1__png, true, 200, 300);
		keclSprite1.animation.add("slouch", [0]);
		keclSprite1.animation.add("unslouch", [1]);
		keclSprite1.animation.play("slouch");
		_keclSprites.push(keclSprite1);
		add(keclSprite1);

		var keclHeadSprite:FlxSprite = new BouncySprite(288, -10, 0, 6.5, 0);
		keclHeadSprite.loadGraphic(AssetPaths.shop_kecl_head__png, true, 200, 300);
		keclHeadSprite.animation.add("slouch", AnimTools.blinkyAnimation([0, 1], [2]), 3);
		keclHeadSprite.animation.add("unslouch", AnimTools.blinkyAnimation([3, 4], [5]), 3);
		keclHeadSprite.animation.play("slouch");
		_keclSprites.push(keclHeadSprite);
		add(keclHeadSprite);

		var keclSprite2:FlxSprite = new BouncySprite(288, -10, 0, 6.5, 0);
		keclSprite2.loadGraphic(AssetPaths.shop_kecl2__png, true, 200, 300);
		keclSprite2.animation.add("slouch", [0]);
		keclSprite2.animation.add("unslouch", [1]);
		keclSprite2.animation.play("slouch");
		_keclSprites.push(keclSprite2);
		add(keclSprite2);

		_itemSprites = new FlxTypedGroup<FlxSprite>();
		add(_itemSprites);

		_critterShadowGroup = new ShadowGroup();
		_targetSprites = new FlxTypedGroup<FlxSprite>();
		_midInvisSprites = new FlxTypedGroup<FlxSprite>();
		_midInvisSprites.visible = false;
		_midSprites = new FlxTypedGroup<FlxSprite>();

		add(_critterShadowGroup);
		add(_targetSprites);
		add(_midInvisSprites);
		add(_midSprites);

		var shopItems:Array<ItemDatabase.ShopItem> = ItemDatabase._shopItems.copy();
		shopItems.sort( function(a:ItemDatabase.ShopItem, b:ItemDatabase.ShopItem)
		{
			return a._orderIndex - b._orderIndex;
		});
		var i:Int = 0;
		for (item in shopItems)
		{
			var itemX:Float = 378.5 - 58.5 * shopItems.length + 117 * i + FlxG.random.int( -7, 7);
			var itemY:Float = 265 - 200 + FlxG.random.int( -3, 3);
			if (item._itemIndex == ItemDatabase.ITEM_FRUIT_BUGS ||
			item._itemIndex == ItemDatabase.ITEM_SPOOKY_BUGS ||
			item._itemIndex == ItemDatabase.ITEM_MARSHMALLOW_BUGS)
			{
				var critterOffsetsX:Array<Float> = FlxG.random.getObject([
					[22.1, 4.4, -18.5, -0.6, -12.9, 2.2],
					[8.1, 19.1, -21.6, -14.5, 6.8, 0],
					[24.8, -23.5, -2, 0.5, 3.7, -14],
					[24.9, -25.2, 13.3, 4.7, -3.6, -11.5],
					[ -20.5, 17, -2.6, 4.3, -0.9, -15.4],
					[ -16.3, 27, -11.5, 2.9, -5.4, -14.2],
					[21, -25, 13.5, 4.2, -4.1, -13.5],
					[ -23.6, 23.9, 3.8, -2.6, -3.1, 11.9],
					[23.3, -15.2, 7.8, -10.2, -2.9, 11.6],
					[ -21.3, 19.5, -10.3, -8.9, -5.6, 8.9],
				]);
				var critterOffsetsY:Array<Float> = critterOffsetsX.splice(3, 3);
				var critterColorIndexes:Array<Int> = [0, 1, 2];
				if (item._itemIndex == ItemDatabase.ITEM_FRUIT_BUGS)
				{
					critterColorIndexes = [6, 7, 8];
				}
				else if (item._itemIndex == ItemDatabase.ITEM_MARSHMALLOW_BUGS)
				{
					critterColorIndexes = [9, 10, 11];
				}
				else if (item._itemIndex == ItemDatabase.ITEM_SPOOKY_BUGS)
				{
					critterColorIndexes = [12, 13, 14];
				}

				for (critterIndex in 0...3)
				{
					var critter:Critter = new Critter(itemX + 49 + critterOffsetsX[critterIndex], itemY + 160 + critterOffsetsY[critterIndex], _bgSprite);
					critter.setColor(Critter.CRITTER_COLORS[critterColorIndexes[critterIndex]]);
					critter.setImmovable(true); // don't let them run around
					_critterToItemMap[critter] = item;
					addCritter(critter);
					_itemSpriteToItemMap[critter._bodySprite] = item;
				}
			}
			else
			{
				var spriteGraphic:String = item.getItemType().shopImage;

				var itemSprite:FlxSprite = addItemGraphic(spriteGraphic, itemX, itemY);

				_itemSpriteToItemMap.set(itemSprite, shopItems[i]);

				if (item._itemIndex == ItemDatabase.ITEM_VANISHING_GLOVES)
				{
					// alpha oscillates for vanishing gloves
					FlxTween.tween(itemSprite, {alpha:0.6}, 2, {type:FlxTweenType.PINGPONG, ease:FlxEase.sineInOut});
				}
			}
			i++;
		}
		i = 0;
		for (item in shopItems)
		{
			var priceTag:FlxSprite = new FlxSprite();
			priceTag.loadGraphic(AssetPaths.shop_pricetag__png, true, 100, 64);
			priceTag.x = 391.5 - 61.5 * shopItems.length + 123 * i + FlxG.random.int( -5, 5);
			priceTag.y = 272 - priceTag.height + FlxG.random.int( -3, 3);
			if (i == 0 && shopItems.length > 1)
			{
				priceTag.animation.frameIndex = 2;
			}
			else if (i == 4)
			{
				priceTag.animation.frameIndex = 4;
			}

			var sale:Bool = item._discount >= 5 || item._discount <= -5;
			add(priceTag);

			var priceText:FlxText = new FlxText(priceTag.x - 1, priceTag.y + priceTag.height - 30, priceTag.width, "", 20);
			priceText.text = Std.string(item.getPrice()) + "$";
			priceText.alignment = "center";
			priceText.color = 0x52492e;
			priceText.font = AssetPaths.hardpixel__otf;
			add(priceText);

			if (sale)
			{
				var saleText:FlxText = new FlxText(priceText.x, priceText.y - 24, priceTag.width, "SALE!", 20);
				saleText.alignment = "center";
				saleText.color = 0xeae8de;
				saleText.font = AssetPaths.hardpixel__otf;
				add(saleText);

				// sale sign
				priceTag.animation.frameIndex++;
				priceText.color = 0xeae8de;
			}
			i++;
		}

		if (ItemDatabase._kecleonPresent)
		{
			setHeracrossHere(false);
			setKecleonHere(true);
		}
		else {
			setHeracrossHere(true);
			setKecleonHere(false);
		}
		setAbraHere(false);
		setSandslashHere(false);

		_backButton = SexyState.newBackButton(back);
		add(_backButton);

		_cashWindow = new CashWindow(true);
		_cashWindow._autoHide = false;
		add(_cashWindow);

		_dialogger = new Dialogger();
		add(_dialogger);

		_handSprite = new FlxSprite(100, 100);
		CursorUtils.initializeHandSprite(_handSprite, AssetPaths.hands__png);
		_handSprite.setSize(3, 3);
		_handSprite.offset.set(69, 87);
		add(_handSprite);

		add(new CheatCodes(cheatCodeCallback));

		var tree:Array<Array<Object>> = new Array<Array<Object>>();
		if (ItemDatabase._kecleonPresent)
		{
			if (PlayerData.keclGift == 1)
			{
				KecleonDialog.receivedGift(tree);
				PlayerData.keclGift = 2;
			}
			else if (PlayerData.keclStoreChat % 2 == 0)
			{
				if (PlayerData.keclStoreChat == 10)
				{
					// kecleon intro dialog;
					KecleonDialog.firstTimeInShop(tree);
				}
				else
				{
					// regular kecleon dialog
					var chats:Array<Dynamic> = [
												   KecleonDialog.shopIntro0,
												   KecleonDialog.shopIntro1,
												   KecleonDialog.shopIntro2,
												   KecleonDialog.shopIntro3,
												   KecleonDialog.shopIntro4,
												   KecleonDialog.shopIntro5
											   ];
					var chat:Dynamic = chats[FlxG.random.int(0, chats.length - 1)];
					chat(tree);
				}

				PlayerData.keclStoreChat++;
			}
		}
		else {
			// heracross dialog...
			if (PlayerData.playerIsInDen)
			{
				// just returning from den! No dialog
			}
			else if (PlayerData.keclStoreChat >= 10 && PlayerData.keclStoreChat < 20)
			{
				HeraShopDialog.howWasKecleon(tree);
				PlayerData.keclStoreChat += 10;
			}
			else if (!PlayerData.startedTaping)
			{
				if (PlayerData.videoStatus != PlayerData.VideoStatus.Empty)
				{
					// first time
					HeraShopDialog.firstVideo(tree);
				}
			}
			else if (ItemDatabase.isMagnezonePresent() && !PlayerData.startedMagnezone)
			{
				MagnDialog.magnShopIntro(tree);
				PlayerData.startedMagnezone = true;
			}
			else if (ItemDatabase.isMagnezonePresent() && (PlayerData.magnButtPlug > 0 && PlayerData.magnButtPlug % 2 == 0))
			{
				// advance butt plug chat sequence
				if (PlayerData.magnButtPlug == 2)
				{
					MagnDialog.shopPlug0(tree);
				}
				else if (PlayerData.magnButtPlug == 4)
				{
					MagnDialog.shopPlug1(tree);
				}
				else if (PlayerData.magnButtPlug == 6)
				{
					MagnDialog.shopPlug2(tree);
				}
				PlayerData.magnButtPlug++;
			}
			else if (PlayerData.videoStatus != PlayerData.VideoStatus.Empty)
			{
				var chats:Array<Dynamic> = [HeraShopDialog.videoReward0, HeraShopDialog.videoReward1, HeraShopDialog.videoReward2, HeraShopDialog.videoReward3];
				var chat:Dynamic = chats[FlxG.random.int(0, chats.length - 1)];
				if (PlayerData.videoCount == PlayerData.pokeVideos.length)
				{
					// first time...
					chat = HeraShopDialog.firstVideoReward;
				}
				chat(tree);
			}
		}
		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();

		PlayerData.playerIsInDen = false;
	}

	function isDenDoorOpen():Bool
	{
		if (PlayerData.denProf == -1)
		{
			// haven't played with a pokemon today; den door is closed
			return false;
		}
		if (PlayerData.denProf == PlayerData.PROF_PREFIXES.indexOf("abra") && PlayerData.abraChats[0] == 6)
		{
			// just beat the game; den door is closed
			return false;
		}
		if (PlayerData.denProf == PlayerData.PROF_PREFIXES.indexOf("abra") && PlayerData.abraStoryInt == 4)
		{
			// abra's pissed off; den door is closed
			return false;
		}
		if (PlayerData.MINIGAME_CLASSES[PlayerData.denMinigame] == null)
		{
			/*
			 * den minigame is not specified; this shouldn't really happen, but
			 * the game could crash if we don't prevent this
			 */
			return false;
		}
		return true;
	}

	public function addCritter(critter:Critter, pushToCritterList:Bool = true)
	{
		_targetSprites.add(critter._targetSprite);
		_midInvisSprites.add(critter._soulSprite);
		_midSprites.add(critter._bodySprite);
		_midSprites.add(critter._headSprite);
		_midSprites.add(critter._frontBodySprite);
		_critterShadowGroup.makeShadow(critter._bodySprite);
		_critters.push(critter);
	}

	public function removeCritter(critter:Critter, pushToCritterList:Bool = true)
	{
		_targetSprites.remove(critter._targetSprite, true);
		_midInvisSprites.remove(critter._soulSprite, true);
		_midSprites.remove(critter._bodySprite, true);
		_midSprites.remove(critter._headSprite, true);
		_midSprites.remove(critter._frontBodySprite, true);
		_critters.remove(critter);
	}

	function addItemGraphic(spriteGraphic:String, itemX:Float, itemY:Float):FlxSprite
	{
		var newItemImage:FlxSprite = new FlxSprite(itemX, itemY);
		newItemImage.loadGraphic(spriteGraphic, true, 120, 200);
		_itemSprites.add(newItemImage);

		var shadowKey:String = StringTools.replace(spriteGraphic, ".png", "-shadow.png");
		if (Assets.exists(shadowKey))
		{
			var newShadowImage:FlxSprite = new FlxSprite(itemX, itemY);
			newShadowImage.loadGraphic(shadowKey, true, 120, 200);
			_shadowGroup.add(newShadowImage);
			_shadowMap[newShadowImage] = newItemImage;
		}

		return newItemImage;
	}

	override public function destroy():Void
	{
		super.destroy();
		_handSprite = FlxDestroyUtil.destroy(_handSprite);
		_itemSprites = FlxDestroyUtil.destroy(_itemSprites);
		_cashWindow = FlxDestroyUtil.destroy(_cashWindow);
		_dialogger = FlxDestroyUtil.destroy(_dialogger);
	}

	private function getClickedItem():FlxSprite
	{
		var satellite:FlxSprite = new FlxSprite(_handSprite.x, _handSprite.y);
		satellite.makeGraphic(Std.int(_handSprite.width), Std.int(_handSprite.height));
		var clickedItem:FlxSprite = null;
		for (item in _itemSprites.members)
		{
			if (item.alive && FlxG.pixelPerfectOverlap(satellite, item, 40))
			{
				return item;
			}
		}
		if (FlxG.mouse.y > 180)
		{
			for (item in _itemSprites.members)
			{
				if (item.alive && FlxSpriteKludge.overlap(satellite, item))
				{
					return item;
				}
			}
		}
		{
			var offsetPoint:FlxPoint = FlxPoint.get(FlxG.mouse.x, FlxG.mouse.y);
			offsetPoint.y += 10;
			var minDistance:Float = 40;
			var closestCritter:Critter = null;
			for (critter in _critters)
			{
				var distance:Float = critter._bodySprite.getMidpoint().distanceTo(offsetPoint);
				if (distance < minDistance)
				{
					minDistance = distance;
					closestCritter = critter;
				}
			}
			offsetPoint.put();
			if (closestCritter != null)
			{
				return closestCritter._bodySprite;
			}
		}
		return null;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		PlayerData.updateTimePlayed();
		if (FlxG.mouse.justPressed)
		{
			PlayerData.updateCursorVisible();
		}
		_handSprite.setPosition(FlxG.mouse.x, FlxG.mouse.y);

		if (DialogTree.isDialogging(_dialogTree))
		{
			_backButton.visible = false;
			_cashWindow.setShopText(true);
		}
		else {
			_backButton.visible = true;
			_cashWindow.setShopText(false);
		}

		if (!DialogTree.isDialogging(_dialogTree))
		{
			if (isDenDoorOpen())
			{
				// mouseover door...
				if (FlxG.mouse.getPosition().distanceTo(FlxPoint.weak(146, 38)) <= 115)
				{
					_bgSprite.animation.frameIndex = 2;
					_denArrow.visible = true;
				}
				else
				{
					_bgSprite.animation.frameIndex = 1;
					_denArrow.visible = false;
				}
			}
		}

		if (ItemDatabase._kecleonPresent)
		{
			if (DialogTree.isDialogging(_dialogTree) && _keclSprites[0].animation.name == "slouch")
			{
				_kecleonPoseTimer += elapsed;
				if (_kecleonPoseTimer > 0.5)
				{
					_kecleonPoseTimer = 0;
					for (keclSprite in _keclSprites)
					{
						keclSprite.animation.play("unslouch");
					}
				}
			}
			else if (!DialogTree.isDialogging(_dialogTree) && _keclSprites[0].animation.name == "unslouch")
			{
				_kecleonPoseTimer += elapsed;
				if (_kecleonPoseTimer > 1.5)
				{
					_kecleonPoseTimer = 0;
					for (keclSprite in _keclSprites)
					{
						keclSprite.animation.play("slouch");
					}
				}
			}
		}

		if (FlxG.mouse.justPressed && !DialogTree.isDialogging(_dialogTree) && !_dialogger._handledClick)
		{
			if (_bgSprite.animation.frameIndex == 2)
			{
				// clicked door?
				var profPrefix:String = PlayerData.PROF_PREFIXES[PlayerData.denProf];
				var profName:String = PlayerData.PROF_NAMES[PlayerData.denProf];
				var profMale:Bool = Reflect.field(PlayerData, profPrefix + "Male");

				var tree:Array<Array<Object>> = new Array<Array<Object>>();
				if (ItemDatabase.isKecleonPresent())
				{
					tree[0] = ["#kecl13#D'ehh, whaddaya you think you're doin'? You can't go back there. Employees only!"];
				}
				else if (PlayerData.cursorType == "none")
				{
					// you can't come in the den; you're injured!
					tree[0] = ["#hera10#<name>, what happened!?! ...You should probably see if Abra can fix you..."];
				}
				else
				{
					var minigameDesc:String = PlayerData.MINIGAME_DESCRIPTIONS[PlayerData.denMinigame];
					if (PlayerData.denVisitCount == 0)
					{
						// first visit is free...
						tree[0] = ["#hera04#Oh, " + profName + "'s hanging out in the den right now. And I think we've got " + minigameDesc + " set up back there if you want to practice."];
						tree[1] = ["#hera06#...Since it's just for practice, he can't give out too many gems for playing. But what do you think, do you want to go back there and play with " + profName + "?"];
						tree[2] = [10, 30];

						tree[10] = ["Yes"];
						tree[11] = ["%buyden%"];
						tree[12] = ["#hera02#Oooh! Have fun~"];
						tree[13] = ["%den%"];

						tree[30] = ["No"];

						if (PlayerData.denProf == 2)
						{
							// heracross
							tree[0] = ["#hera03#Oh, I think the den's empty right now! But we've got " + minigameDesc + " set up in there if you want to practice with meeeee~"];
							tree[1] = ["#hera06#...Since it's just for practice, I can't give out too many gems for playing. But what do you think, do you want to go back there and practice with me?"];
							tree[12] = ["#hera02#Weeeeeeeee! Plaaaytiiime with " + stretch(PlayerData.name) + "~"];
						}
						else if (!profMale)
						{
							DialogTree.replace(tree, 1, "practice, he", "practice, she");
						}
					}
					else if (PlayerData.denVisitCount == 1)
					{
						// second visit starts costing money, which we explain
						tree[0] = ["#hera11#Ack! Sorry, Abra said I have to start charging you to hang out with Pokemon in the den. I guess he's worried you'll stay holed up in there forever instead of solving puzzles..."];
						tree[1] = ["#hera06#...Although he didn't say how MUCH I had to charge so... loophoooole! Gweh-heheheh~"];
						tree[2] = ["#hera05#So yeah, don't worry, I'll make it super cheap for you! ...Just think of it as one of the benefits of our friendship."];
						tree[3] = ["#hera00#Mmm! A friendship with benefits. I could used to something like that, <name>~"];
						tree[4] = ["#hera04#...Anyway, " + profName + "'s hanging out in the den right now. And I think we've got " + minigameDesc + " set up back there."];
						tree[5] = ["#hera06#You can play with him but I'll have to charge you, oh... let's say " + moneyString(PlayerData.denCost) + ". Does that sound fair?"];
						if (FlxG.random.bool()) {
							tree[6] = [10, 20, 30];
						} else {
							tree[6] = [10, 30, 20];
						}
						if (PlayerData.cash < PlayerData.denCost)
						{
							// can't afford...
							tree[6][0] = 50;
						}

						tree[10] = ["Yes"];
						tree[11] = ["%buyden%"];
						tree[12] = ["#hera02#Oooh! Have fun~"];
						tree[13] = ["%den%"];

						tree[20] = [FlxG.random.getObject(["Oh, it's only\n" + profName+"...", moneyString(PlayerData.denCost) + " seems\nlike a lot...", "I can see\n" + (profMale ? "him" : "her") + " for free\nlater..."])];

						tree[30] = ["No"];

						tree[50] = ["Yes...?"];
						tree[51] = ["#hera08#Aww raspberries! Looks like you're a little short on money..."];

						if (PlayerData.denProf == 2)
						{
							// heracross
							tree[4] = ["#hera03#...Anyway, I think the den's empty right now! But we've got " + minigameDesc + " set up in there if you want to practice with meeeee~"];
							tree[5] = ["#hera06#I apparently have to charge you SOMETHING, but ohh... let's just make it " + moneyString(PlayerData.denCost) + ". What do you say?"];
							tree[12] = ["#hera02#Weeeeeeeee! Plaaaytiiime with " + stretch(PlayerData.name) + "~"];
							tree[20] = [FlxG.random.getObject(["Oh, I thought\nsomeone was\nin there...", moneyString(PlayerData.denCost) + " seems\nlike a lot...", "I'm really\njust here\nto shop..."])];
						}
						else if (!profMale)
						{
							DialogTree.replace(tree, 5, "with him", "with her");
						}
						if (!PlayerData.abraMale)
						{
							DialogTree.replace(tree, 0, "guess he's", "guess she's");
							DialogTree.replace(tree, 1, "Although he", "Although she");
						}
					}
					else
					{
						// third and subsequent visits continue costing money; no explanation necessary
						tree[0] = ["#hera04#Oh, " + profName + "'s hanging out in the den right now. And I think we've got " + minigameDesc + " set up back there."];
						tree[1] = ["#hera06#You can play with him but I'll have to charge you, oh... let's say " + moneyString(PlayerData.denCost) + ". Does that sound fair?"];
						if (FlxG.random.bool()) {
							tree[2] = [10, 20, 30];
						} else {
							tree[2] = [10, 30, 20];
						}
						if (PlayerData.cash < PlayerData.denCost)
						{
							// can't afford...
							tree[2][0] = 50;
						}

						tree[10] = ["Yes"];
						tree[11] = ["%buyden%"];
						tree[12] = ["#hera02#Oooh! Have fun~"];
						tree[13] = ["%den%"];

						tree[20] = [FlxG.random.getObject(["Oh, it's only\n" + profName+"...", moneyString(PlayerData.denCost) + " seems\nlike a lot...", "I can see\n" + (profMale ? "him" : "her") + " for free\nlater..."])];

						tree[30] = ["No"];

						tree[50] = ["Yes...?"];
						tree[51] = ["#hera08#Aww raspberries! Looks like you're a little short on money..."];

						if (PlayerData.denProf == 2)
						{
							// heracross
							tree[0] = ["#hera03#Oh, I think the den's empty right now! But we've got " + minigameDesc + " set up in there if you want to practice with meeeee~"];
							tree[1] = ["#hera06#Of course I'll have to charge you, oh... let's say " + moneyString(PlayerData.denCost) + ". What do you say?"];
							tree[12] = ["#hera02#Weeeeeeeee! Plaaaytiiime with " + stretch(PlayerData.name) + "~"];
							tree[20] = [FlxG.random.getObject(["Oh, I thought\nsomeone was\nin there...", moneyString(PlayerData.denCost) + " seems\nlike a lot...", "I'm really\njust here\nto shop..."])];
						}
						else if (!profMale)
						{
							DialogTree.replace(tree, 1, "with him", "with her");
						}
					}
				}
				_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
				_dialogTree.go();
			}
			else
			{
				// clicked item to purchase?
				_clickedItemSprite = getClickedItem();
				if (_clickedItemSprite != null && _clickedItemSprite == _crackerSprite)
				{
					var tree:Array<Array<Object>> = new Array<Array<Object>>();
					HeraShopDialog.justCrackers(tree, ++_crackerClickCount);
					_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
					_dialogTree.go();
				}
				if (_clickedItemSprite != null && _itemSpriteToItemMap.exists(_clickedItemSprite))
				{
					handleClickedItem();
				}
			}
		}

		for (shadowSprite in _shadowGroup)
		{
			if (_shadowMap.exists(shadowSprite))
			{
				var targetSprite:FlxSprite = _shadowMap.get(shadowSprite);
				shadowSprite.alive = targetSprite.alive;
				shadowSprite.exists = targetSprite.exists;
				shadowSprite.animation.frameIndex = targetSprite.animation.frameIndex;
				shadowSprite.visible = targetSprite.visible;
				shadowSprite.alpha = targetSprite.alpha;
			}
		}

		_midSprites.sort(LevelState.byYNulls);
	}

	private function handleClickedItem():Void
	{
		var clickedItem:ItemDatabase.ShopItem = _itemSpriteToItemMap.get(_clickedItemSprite);
		var itemName = clickedItem.getItemType().name;
		var itemPrice = clickedItem.getPrice();

		var tree:Array<Array<Object>>;

		if (ItemDatabase.isKecleonPresent())
		{
			if (Std.isOfType(clickedItem, ItemDatabase.TelephoneShopItem))
			{
				// kecleon telephone dialog
				tree = [];
				KecleonDialog.phoneCall(tree, cast(clickedItem));
			}
			else if (Std.isOfType(clickedItem, ItemDatabase.MysteryBoxShopItem))
			{
				// kecleon mystery box dialog
				tree = [];
				KecleonDialog.mysteryBox(tree, cast(clickedItem));
			}
			else
			{
				// brain-damaged kecleon dialog
				tree = BadItemDescriptions.describe(clickedItem);

				DialogTree.shift(tree, 100, 196, 2);
				DialogTree.shift(tree, 200, 297, 1);
				DialogTree.shift(tree, 500, 597, 1);

				if (tree[0] == null)
				{
					tree[0] = ["#kecl06#I ehhh, I don't know what that is. ...Looks like it costs " + itemPrice + "$. Did you want it? Or..."];
				}

				var purchaseChoices:Array<Object> = itemPrice <= PlayerData.cash ? [100, 200, 300] : [500, 200, 300];

				{
					var i:Int = 99;
					while (tree[i] == null)
					{
						i--;
					}
					tree[i + 1] = purchaseChoices;
				}

				tree[100] = ["Yes"];
				tree[101] = ["%buy%"];

				if (tree[102] == null)
				{
					tree[102] = ["#kecl03#Ayy! I made a sale~"];
				}

				tree[200] = ["No"];

				if (tree[300] == null)
				{
					tree[300] = ["You...\ndon't know??"];
					tree[301] = ["#kecl08#I dunno, it looks sorta like it might be some kinda... electronic... like, one of those things that listens to your voice?"];
					tree[302] = ["#kecl06#Or ehh... Maybe a vehicle, for a really tiny animal. You know, what that don't got no legs or somethin'."];
					tree[303] = ["#kecl05#Well whatever it is... it's " + moneyString(itemPrice) + "$. Is that okay? You want it for " + moneyString(itemPrice) + "$?"];
				}

				{
					var i:Int = 399;
					while (tree[i] == null)
					{
						i--;
					}
					tree[i + 1] = purchaseChoices;
				}

				tree[500] = ["Yes...?"];
				tree[501] = ["#kecl12#Ayy I ain't runnin' a charity here! ...Go get more money."];
			}
		}
		else {
			// regular heracross dialog
			tree = new Array<Array<Object>>();

			var dialog:Dynamic = clickedItem.getItemType().dialog;
			if (dialog != null)
			{
				dialog(tree, itemPrice);
				DialogTree.shift(tree, 100, 196, 2);
				DialogTree.shift(tree, 200, 297, 1);
				DialogTree.shift(tree, 500, 597, 1);
			}

			if (tree[0] == null)
			{
				tree[0] = ["#hera05#That's a " + itemName + "! Did you want to buy it for " + itemPrice + "$?"];
			}

			var purchaseChoices:Array<Object> = itemPrice <= PlayerData.cash ? [100, 200, 300] : [500, 200, 300];
			// 400 is a choice presented to the player when buying the item
			if (tree[400] != null)
			{
				purchaseChoices.push(400);
			}
			var afterPurchaseChoices:Array<Object> = purchaseChoices.copy();
			// 450 is a choice presented to the player after being told about the item
			if (tree[450] != null)
			{
				afterPurchaseChoices.push(450);
			}
			if (clickedItem.getItemType().index == ItemDatabase.ITEM_VIBRATOR && ItemDatabase.isMagnezonePresent())
			{
				// vibrator dialog doesn't let you repeat the incriminating thing heracross says
				afterPurchaseChoices.remove(300);
			}

			{
				var i:Int = 99;
				while (tree[i] == null)
				{
					i--;
				}
				tree[i + 1] = purchaseChoices;
			}

			tree[100] = ["Yes"];
			if (Std.isOfType(clickedItem, ItemDatabase.TelephoneShopItem))
			{
				// don't append %buy% dialog thing; telephone is weird
				tree[101] = ["%noop%"];
			}
			else {
				tree[101] = ["%buy%"];
			}

			if (tree[102] == null)
			{
				tree[102] = ["#hera02#Here you go!"];
			}

			tree[200] = ["No"];

			if (tree[300] == null)
			{
				tree[300] = [itemName + "?"];
				tree[301] = ["#hera03#" + itemName + " is really placeholdery!"];
				tree[302] = ["#hera04#You really can't do any placeholding without " + itemName + "."];
				tree[303] = ["#hera05#Did you want to buy " + itemName + " for " + itemPrice + "$?"];
			}

			{
				var i:Int = 399;
				while (tree[i] == null)
				{
					i--;
				}
				tree[i + 1] = afterPurchaseChoices;
			}

			if (tree[400] != null)
			{
				var i:Int = 449;
				while (tree[i] == null)
				{
					i--;
				}
				tree[i + 1] = afterPurchaseChoices;
			}

			if (tree[450] != null)
			{
				var i:Int = 499;
				while (tree[i] == null)
				{
					i--;
				}
				tree[i + 1] = afterPurchaseChoices;
			}

			tree[500] = ["Yes...?"];
			tree[501] = ["#hera09#...Oops! You can't quite afford it yet."];
		}

		_dialogTree = new DialogTree(_dialogger, tree, dialogTreeCallback);
		_dialogTree.go();
	}

	public function cheatCodeCallback(Code:String)
	{
		var threeCode:String = Code.substring(Code.length - 3, Code.length);
		var fourCode:String = Code.substring(Code.length - 4, Code.length);
		var fiveCode:String = Code.substring(Code.length - 5, Code.length);
		#if debug
		if (fiveCode == "CHEAT")
		{
			PlayerData.cheatsEnabled = !PlayerData.cheatsEnabled;
			if (PlayerData.cheatsEnabled)
			{
				FlxSoundKludge.play(AssetPaths.rank_up_00C4__mp3);
			}
			else
			{
				FlxSoundKludge.play(AssetPaths.rank_down_00C5__mp3);
			}
		}
		#end
		if (PlayerData.cheatsEnabled)
		{
			if (StringTools.startsWith(fiveCode, "BOX"))
			{
				if (ItemDatabase._mysteryBoxStatus <= 0)
				{
					// not doing mystery boxes yet...
				}
				else
				{
					var index:Null<Int> = Std.parseInt(fiveCode.substring(3, 5));
					if (index != null)
					{
						if (index == 0)
						{
							if (ItemDatabase._mysteryBoxStatus > 0)
							{
								ItemDatabase._mysteryBoxStatus = 0;
								populateShopFromCheat(0, 0);
								FlxG.switchState(new ShopState());
							}
						}
						else if (index >= 1)
						{
							ItemDatabase._shopItems.splice(0, ItemDatabase._shopItems.length);
							ItemDatabase._mysteryBoxStatus = index;
							ItemDatabase.refillItems(); // force refresh
							PlayerData.cash += ItemDatabase._shopItems[0].getPrice();
							FlxG.switchState(new ShopState());
						}
					}
				}
			}
			if (threeCode == "ZXC")
			{
				// cheat
				ItemDatabase._prevRefillTime = 0;
				ItemDatabase.refillShop();
				FlxG.switchState(new ShopState());
			}
			if (StringTools.startsWith(threeCode, "Z"))
			{
				var index:Null<Int> = Std.parseInt(threeCode.substring(1, 3));
				if (index != null)
				{
					populateShopFromCheat(index * 4, index * 4 + 3);

					FlxG.switchState(new ShopState());
				}
			}
			if (fourCode == "MAG0")
			{
				ItemDatabase._magnezoneStatus = ItemDatabase.MagnezoneStatus.Absent;
				FlxG.switchState(new ShopState());
			}
			if (fourCode == "MAG1")
			{
				ItemDatabase._magnezoneStatus = ItemDatabase.MagnezoneStatus.Angry;
				FlxG.switchState(new ShopState());
			}
			if (fourCode == "MAG2")
			{
				ItemDatabase._magnezoneStatus = ItemDatabase.MagnezoneStatus.Suspicious;
				FlxG.switchState(new ShopState());
			}
			if (fourCode == "MAG3")
			{
				ItemDatabase._magnezoneStatus = ItemDatabase.MagnezoneStatus.Calm;
				FlxG.switchState(new ShopState());
			}
			if (fourCode == "MAG4")
			{
				ItemDatabase._magnezoneStatus = ItemDatabase.MagnezoneStatus.Happy;
				FlxG.switchState(new ShopState());
			}
		}
	}

	function populateShopFromCheat(minItemIndex:Int, maxItemIndex:Int)
	{
		// remove existing items...
		while (ItemDatabase._shopItems.length > 0)
		{
			var shopItem:ItemDatabase.ShopItem = ItemDatabase._shopItems.pop();
			ItemDatabase._warehouseItemIndexes.push(shopItem._itemIndex);
		}

		// populate shop with four chosen items
		for (itemIndex in minItemIndex...maxItemIndex + 1)
		{
			// refund money as necessary
			if (ItemDatabase._playerItemIndexes.indexOf(itemIndex) >= 0)
			{
				PlayerData.cash += ItemDatabase._itemTypes[itemIndex].basePrice;
			}

			var playerHadItem:Bool = ItemDatabase._playerItemIndexes.remove(itemIndex);
			ItemDatabase._warehouseItemIndexes.remove(itemIndex);
			if (itemIndex < ItemDatabase._itemTypes.length && !ItemDatabase.isLocked(itemIndex))
			{
				ItemDatabase._shopItems.push(new ItemDatabase.ShopItem(itemIndex));
			}

			if (playerHadItem && (itemIndex == ItemDatabase.ITEM_MAGNETIC_DESK_TOY || itemIndex == ItemDatabase.ITEM_RETROPIE))
			{
				// refunded gift; fix luckyProfSchedules so characters don't show up as often
				PlayerDataNormalizer.normalizeLuckyProfSchedules();
			}
		}
	}

	public function dialogTreeCallback(line:String):String
	{
		if (line == "%buy%")
		{
			// yes, buy the item
			FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3, 0.7);

			_justPurchasedSprite = _clickedItemSprite;

			var item:ItemDatabase.ShopItem = _itemSpriteToItemMap.get(_clickedItemSprite);

			ItemDatabase._shopItems.remove(item);
			if (Std.isOfType(item, ItemDatabase.TelephoneShopItem))
			{
				// do nothing
			}
			else if (Std.isOfType(item, ItemDatabase.MysteryBoxShopItem))
			{
				ItemDatabase._mysteryBoxStatus++;
			}
			else if (item._itemIndex == PlayerData.grimEatenItem)
			{
				PlayerData.grimEatenItem = -1;
			}
			else
			{
				ItemDatabase._playerItemIndexes.push(item._itemIndex);
			}
			PlayerData.cash -= item.getPrice();

			if (Std.isOfType(_clickedItemSprite, CritterBody))
			{
				var crittersToRemove:Array<Critter> = [];
				for (critter in _critterToItemMap.keys())
				{
					if (_critterToItemMap[critter] == item)
					{
						crittersToRemove.push(critter);
					}
				}
				for (critterToRemove in crittersToRemove)
				{
					removeCritter(critterToRemove);
					_critterToItemMap.remove(critterToRemove);
					FlxDestroyUtil.destroy(critterToRemove);
				}
			}
			else
			{
				_clickedItemSprite.kill();
			}
		}
		if (line == "%buyden%")
		{
			if (PlayerData.denVisitCount == 0)
			{
				// first visit is free
			}
			else
			{
				FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3, 0.7);
				PlayerData.cash -= PlayerData.denCost;
			}
			_dialogTree.appendSkipToActiveDialog("%den%"); // ensure player goes to den, even if they click "skip"
		}
		if (line == "%den%")
		{
			PlayerData.profIndex = PlayerData.denProf;
			PlayerData.playerIsInDen = true;

			// after the player leaves the den (or shuts down flash) the den professor is no longer there.
			PlayerData.denProf = -1;
			PlayerData.denVisitCount++;
			var minigameState:MinigameState = MinigameState.fromInt(PlayerData.denMinigame);
			FlxG.switchState(minigameState);
		}
		if (line == "%enterabra%" || line == "%exitabra%")
		{
			setAbraHere(line == "%enterabra%");
		}
		if (line == "%entersand%" || line == "%exitsand%")
		{
			setSandslashHere(line == "%entersand%");
		}
		if (StringTools.startsWith(line, "%pokemon-libido-"))
		{
			PlayerData.pokemonLibido = Std.parseInt(substringBetween(line, "%pokemon-libido-", "%"));
			PlayerData.pokemonLibido = Std.int(FlxMath.bound(PlayerData.pokemonLibido, 1, 7));
		}
		if (StringTools.startsWith(line, "%pokemon-libboost-"))
		{
			var boostAmount:Int = Std.parseInt(substringBetween(line, "%pokemon-libboost-", "%"));
			for (profIndex in 0...PlayerData.professors.length)
			{
				var fieldName:String = PlayerData.PROF_PREFIXES[PlayerData.professors[profIndex]] + "Reservoir";
				var reservoir:Int = Reflect.field(PlayerData, fieldName);
				Reflect.setField(PlayerData, fieldName, Math.min(210, reservoir + boostAmount));
			}
		}
		if (StringTools.startsWith(line, "%peg-activity-"))
		{
			PlayerData.pegActivity = Std.parseInt(substringBetween(line, "%peg-activity-", "%"));
			PlayerData.pegActivity = Std.int(FlxMath.bound(PlayerData.pegActivity, 1, 7));
		}
		if (line == "%set-started-taping%")
		{
			PlayerData.startedTaping = true;
			PlayerData.videoStatus = PlayerData.VideoStatus.Empty;
		}
		if (line == "%pay-videos%")
		{
			if (PlayerData.videoStatus != PlayerData.VideoStatus.Empty)
			{
				FlxSoundKludge.play(AssetPaths.cash_get_0037__mp3, 0.7);
				PlayerData.payVideos();
			}
		}
		if (line == "%reset-sandphone%")
		{
			PlayerData.sandPhone = 0;
		}
		if (StringTools.startsWith(line, "%crackers"))
		{
			if (_crackerSprite == null)
			{
				_crackerSprite = addItemGraphic(AssetPaths.just_crackers_shop__png, _justPurchasedSprite.x, _justPurchasedSprite.y);
			}
			_crackerSprite.animation.frameIndex = Std.parseInt(substringBetween(line, "%crackers", "%"));
		}
		if (StringTools.startsWith(line, "%call-"))
		{
			var prefix:String = substringBetween(line, "%call-", "%");
			if (prefix == "sand")
			{
				PlayerData.sandPhone = 5;
				PlayerData.sandSexyBeforeChat = 5;
				PlayerData.appendChatHistory("hera.callSandslash");
			}
			else
			{
				PlayerData.luckyProfSchedules.splice(PlayerData.luckyProfSchedules.lastIndexOf(PlayerData.PROF_PREFIXES.indexOf(prefix)), 1);
				PlayerData.luckyProfSchedules.insert(1, PlayerData.PROF_PREFIXES.indexOf(prefix));
			}
		}
		if (StringTools.startsWith(line, "%gift-"))
		{
			var prefix:String = substringBetween(line, "%gift-", "%");
			if (prefix == "magn")
			{
				PlayerData.magnGift = 1;
				PlayerData.luckyProfSchedules.insert(1, PlayerData.PROF_PREFIXES.indexOf("magn"));
				PlayerDataNormalizer.normalizeLuckyProfSchedules();
				if (PlayerData.magnChats[0] < MagnDialog.fixedChats.length)
				{
					PlayerData.magnChats.insert(0, FlxG.random.int(MagnDialog.fixedChats.length, 99));
				}
			}
			else if (prefix == "kecl")
			{
				PlayerData.keclGift = 1;
				PlayerData.luckyProfSchedules.insert(1, PlayerData.PROF_PREFIXES.indexOf("hera"));
				PlayerDataNormalizer.normalizeLuckyProfSchedules();
				if (PlayerData.smeaChats[0] < SmeargleDialog.fixedChats.length)
				{
					PlayerData.smeaChats.insert(0, FlxG.random.int(SmeargleDialog.fixedChats.length, 99));
				}
			}
			else if (prefix == "grim")
			{
				PlayerData.luckyProfSchedules.insert(1, PlayerData.PROF_PREFIXES.indexOf("grim"));
				PlayerDataNormalizer.normalizeLuckyProfSchedules();
			}
			else if (prefix == "luca")
			{
				PlayerData.rhydGift = 1;
				PlayerDataNormalizer.normalizeLuckyProfSchedules();
				if (PlayerData.rhydChats[0] < RhydonDialog.fixedChats.length)
				{
					PlayerData.rhydChats.insert(0, FlxG.random.int(RhydonDialog.fixedChats.length, 99));
				}
			}
		}
		if (StringTools.startsWith(line, "%crumbs"))
		{
			if (_crumbSprite == null)
			{
				_crumbSprite = addItemGraphic(AssetPaths.just_crumbs_shop__png, _justPurchasedSprite.x, _justPurchasedSprite.y);
			}
			_crumbSprite.animation.frameIndex = Std.parseInt(substringBetween(line, "%crumbs", "%"));
		}
		if (StringTools.startsWith(line, "%gold-key-"))
		{
			var valueStr:String = substringBetween(line, "%gold-key-", "%");
			if (valueStr == "default")
			{
				if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_DIAMOND_PUZZLE_KEY))
				{
					PlayerData.promptSilverKey = PlayerData.promptDiamondKey;
					PlayerData.promptGoldKey = PlayerData.promptDiamondKey;
				}
				else
				{
					PlayerData.promptSilverKey = PlayerData.Prompt.Ask;
					PlayerData.promptGoldKey = PlayerData.Prompt.Ask;
				}
			}
			else
			{
				PlayerData.promptSilverKey = Type.createEnum(PlayerData.Prompt, valueStr);
				PlayerData.promptGoldKey = Type.createEnum(PlayerData.Prompt, valueStr);
				if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_DIAMOND_PUZZLE_KEY))
				{
					if (PlayerData.promptGoldKey == PlayerData.Prompt.AlwaysNo)
					{
						// bump diamond down to "no"
						PlayerData.promptDiamondKey = PlayerData.Prompt.AlwaysNo;
					}
					else if (PlayerData.promptGoldKey == PlayerData.Prompt.Ask)
					{
						// bump diamond down to "ask"
						if (PlayerData.promptDiamondKey == PlayerData.Prompt.AlwaysYes) PlayerData.promptDiamondKey = PlayerData.Prompt.Ask;
					}
					else if (PlayerData.promptGoldKey == PlayerData.Prompt.AlwaysYes)
					{
						// leave diamond alone
					}
				}
			}
		}
		if (StringTools.startsWith(line, "%diamond-key-"))
		{
			var valueStr:String = substringBetween(line, "%diamond-key-", "%");
			if (valueStr == "default")
			{
				if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_GOLD_PUZZLE_KEY))
				{
					PlayerData.promptDiamondKey = PlayerData.promptGoldKey;
				}
				else
				{
					PlayerData.promptDiamondKey = PlayerData.Prompt.Ask;
				}
			}
			else
			{
				PlayerData.promptDiamondKey = Type.createEnum(PlayerData.Prompt, valueStr);
				if (ItemDatabase.playerHasItem(ItemDatabase.ITEM_GOLD_PUZZLE_KEY))
				{
					if (PlayerData.promptDiamondKey == PlayerData.Prompt.AlwaysNo)
					{
						// leave gold/silver alone
					}
					else if (PlayerData.promptDiamondKey == PlayerData.Prompt.Ask)
					{
						// bump gold/silver up to "ask"
						if (PlayerData.promptGoldKey == PlayerData.Prompt.AlwaysNo) PlayerData.promptGoldKey = PlayerData.Prompt.Ask;
						if (PlayerData.promptSilverKey == PlayerData.Prompt.AlwaysNo) PlayerData.promptSilverKey = PlayerData.Prompt.Ask;
					}
					else if (PlayerData.promptDiamondKey == PlayerData.Prompt.AlwaysYes)
					{
						// bump gold/silver up to "always yes"
						PlayerData.promptGoldKey = PlayerData.Prompt.AlwaysYes;
						PlayerData.promptSilverKey = PlayerData.Prompt.AlwaysYes;
					}
				}
			}
		}
		if (line == "")
		{
			_cashWindow.setShopText(false);
			// done; remove abra and sandslash, they should never stick around
			setAbraHere(false);
			setSandslashHere(false);
		}
		return null;
	}

	function setAbraHere(here:Bool)
	{
		for (sprite in _abraSprites)
		{
			sprite.exists = here;
		}
	}

	function setSandslashHere(here:Bool)
	{
		for (sprite in _sandSprites)
		{
			sprite.exists = here;
		}
	}

	function setKecleonHere(here:Bool)
	{
		for (sprite in _keclSprites)
		{
			sprite.exists = here;
		}
	}

	function setHeracrossHere(here:Bool)
	{
		for (sprite in _heraSprites)
		{
			sprite.exists = here;
		}
	}

	function back()
	{
		if (!DialogTree.isDialogging(_dialogTree))
		{
			FlxG.switchState(new MainMenuState());
		}
	}
}