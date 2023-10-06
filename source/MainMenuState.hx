package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;

using StringTools;

class MainMenuState extends MusicBeatState
{
	

	var guy1:FlxSprite;
	var guy2:FlxSprite;

	public static var psychEngineVersion:String = '1.1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'storymode',
		'freeplay',
		'shop',
		'news',
		'update',
		'options',
		//#if MODS_ALLOWED 'mods', #end
		//#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		'quit'
		//#if !switch 'donate', #end
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var menuItem:FlxSprite;
	

	override function create()
	{
		
		FlxG.mouse.visible = true;

		#if MODS_ALLOWED
		//Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		
		

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('MainBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.scale.set(1,1);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var spaceBack:FlxSprite;

		spaceBack = new FlxSprite(300,35).loadGraphic(Paths.image('menuBG'));
		spaceBack.antialiasing = ClientPrefs.globalAntialiasing;
		spaceBack.scale.set(0.6,0.6);
		spaceBack.color = FlxColor.BLACK;
		add(spaceBack);

		var space:FlxSprite;

		space = new FlxSprite(300,35).loadGraphic(Paths.image('menuBG'));
		space.antialiasing = ClientPrefs.globalAntialiasing;
		space.scale.set(0.6,0.6);
		add(space);
		//space.screenCenter();

		FlxTween.tween(space,{alpha:0.5},1.5,
		{
			type:       PINGPONG
		});

		guy1 = new FlxSprite(1120);
		guy1.loadRotatedGraphic(Paths.image('mainmenu/Purple'));
		guy1.screenCenter(Y);
		//add(guy1);

		guy1.angle = 0;

		FlxTween.angle(guy1, -360, 1, 
		{ 
			type: FlxTween.LOOPING,	
			//ease: FlxEase.IN
		});

		var mainOut = new FlxSprite(465,100).loadGraphic(Paths.image('MainOut'));
		mainOut.antialiasing = ClientPrefs.globalAntialiasing;
		mainOut.scale.set(0.9,0.75);
		add(mainOut);

		var mainBack = new FlxSprite(40,170).loadGraphic(Paths.image('MainBack'));
		mainBack.antialiasing = ClientPrefs.globalAntialiasing;
		mainBack.scale.set(1.12,1.1);
		add(mainBack);

		//var mainLogo = new FlxSprite(-80, -10).loadGraphic(Paths.image('MainAmongus'));
		var mainLogo = new FlxSprite(330, 70).loadGraphic(Paths.image('logo'));
		mainLogo.antialiasing = ClientPrefs.globalAntialiasing;
		//mainLogo.scale.set(0.6, 0.6);
		mainLogo.scale.set(0.47, 0.47);
		add(mainLogo);

		var mainBlackBar = new FlxSprite(40,50).loadGraphic(Paths.image('MainBlackBar'));
		mainBlackBar.screenCenter(X);
		mainBlackBar.antialiasing = ClientPrefs.globalAntialiasing;
		add(mainBlackBar);

		var mainIcon = new FlxSprite(40,48).loadGraphic(Paths.image('MainIcon'));
		mainIcon.antialiasing = ClientPrefs.globalAntialiasing;
		add(mainIcon);

		var mainLight = new FlxSprite(50,5).loadGraphic(Paths.image('MainLight'));
		mainLight.antialiasing = ClientPrefs.globalAntialiasing;
		add(mainLight);

		var title:FlxText = new FlxText(160,65,'SUSSY FUNKIN SHINE MOGUS');
		title.setFormat(Paths.font("Dum-Regular.ttf"),40, FlxColor.WHITE, LEFT);
		add(title);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		//add(camFollow);
		//add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('mainspace'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xffffffff;
		//add(magenta);



		
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		

		


		var scale:Float = 1;

		addMenuItem(0, 70, 70 + 108);
		addMenuItem(1, 70, 70 + 90 + 108);
		addMenuItem(2, 70, 70 + 180 + 108);
		addMenuItem(3, 70, 250 + 90 + 108);
		addMenuItem(4, 70, 250 + 150 + 108);
		addMenuItem(5, 70, 250 + 130 + 80 + 108);
		addMenuItem(6, 70, 250 + 180 + 90 + 108);
		addMenuItem(7, 250, 250 + 180 + 90 + 108);

		//Here are click buttons

		//var button1:FlxButton = new FlxButton(70,178,'',function()
		//{
			//optionShit[curSelected] == 'storymode';
		//});
		//button1.loadGraphic(Paths.image('FlxUiButton/ButtonNormal'));
		//button1.animation.addByPrefix('idle', "storymode basic", 24);
		//button1.animation.play('idle');
		//button1.alpha = 0;
		//add(button1);

		//var button2:FlxButton = new FlxButton(70,178 + 90,'',function()
		//{
			//optionShit[curSelected] == 'freeplay';
		//});
		//button2.loadGraphic(Paths.image('FlxUiButton/ButtonNormal'));
		//button2.alpha = 0;
		//add(button2);

		//var button3:FlxButton = new FlxButton(70,178 + 180,'', function()
		//{
			//optionShit[curSelected] == 'shop';
		//});
		//button3.loadGraphic(Paths.image('FlxUiButton/ButtonNormal'));
		//button3.alpha = 0;
		//add(button3);

		//var button4:FlxButton = new FlxButton(70,250 + 90 + 108,'', function()
		//{
			//curSelected = 4;
		//});
		//button4.loadGraphic(Paths.image('FlxUiButton/ButtonGreen'));
		//button4.alpha =0;
		//add(button4);
		
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		/*for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 0;
			var menuItem:FlxSprite = new FlxSprite(70, (i * 90)  + offset + 70);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('amongus/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}*/

		//FlxG.camera.follow(camFollowPos, null, 1);

		var shine1 = new FlxSprite(190, 177).loadGraphic(Paths.image('ButtonShine'));
		shine1.antialiasing = ClientPrefs.globalAntialiasing;
		shine1.scale.set(0.95, 0.95);
		shine1.alpha = 0.6;
		add(shine1);

		var mainRunningGuy = new FlxSprite(60, 155).loadGraphic(Paths.image('MainRunningGuypng'));
		mainRunningGuy.antialiasing = ClientPrefs.globalAntialiasing;
		mainRunningGuy.scale.set(0.8, 0.8);
		add(mainRunningGuy);

		var playTxt = new FlxText(mainRunningGuy.x + 170,mainRunningGuy.y + 20, FlxG.width - 800, "STORYMODE", 32);
		playTxt.setFormat(Paths.font("AMGUS.ttf"), 60, 0x004227, LEFT);
		playTxt.scrollFactor.set();
		add(playTxt);

		var shine2 = new FlxSprite(shine1.x, shine1.y + 90).loadGraphic(Paths.image('ButtonShine'));
		shine2.antialiasing = ClientPrefs.globalAntialiasing;
		shine2.scale.set(0.95, 0.95);
		shine2.alpha = 0.6;
		add(shine2);

		var mainFreeplay = new FlxSprite(80 + 10, mainRunningGuy.y + 100).loadGraphic(Paths.image('MainFreeplay'));
		mainFreeplay.antialiasing = ClientPrefs.globalAntialiasing;
		//mainFreeplay.scale.set(0.9, 0.9);
		add(mainFreeplay);

		var play2Txt = new FlxText(mainRunningGuy.x + 220,mainRunningGuy.y + 20 + 90, FlxG.width - 800, "FREEPLAY", 32);
		play2Txt.setFormat(Paths.font("AMGUS.ttf"), 60, 0x004227, LEFT);
		play2Txt.scrollFactor.set();
		add(play2Txt);

		var shine3 = new FlxSprite(shine2.x, shine2.y + 90).loadGraphic(Paths.image('ButtonShine'));
		shine3.antialiasing = ClientPrefs.globalAntialiasing;
		shine3.scale.set(0.95, 0.95);
		shine3.alpha = 0.6;
		add(shine3);

		var mainShop = new FlxSprite(80, mainFreeplay.y + 80).loadGraphic(Paths.image('MainShop'));
		mainShop.antialiasing = ClientPrefs.globalAntialiasing;
		mainShop.scale.set(0.8, 0.8);
		add(mainShop);

		var play3Txt = new FlxText(mainRunningGuy.x + 270,mainRunningGuy.y + 20 + 90 + 90, FlxG.width - 800, "SHOP", 32);
		play3Txt.setFormat(Paths.font("AMGUS.ttf"), 60, 0x004227, LEFT);
		play3Txt.scrollFactor.set();
		add(play3Txt);

		var mainReport = new FlxSprite(80, mainShop.y + 80).loadGraphic(Paths.image('MainReport'));
		mainReport.antialiasing = ClientPrefs.globalAntialiasing;
		mainReport.scale.set(0.6, 0.6);
		add(mainReport);

		var playreportTxt = new FlxText(-60 ,mainRunningGuy.y + 200 + 90, FlxG.width - 800, "REPORT", 32);
		playreportTxt.setFormat(Paths.font("AMGUS.ttf"), 40, 0xd7fff4, RIGHT);
		playreportTxt.scrollFactor.set();
		add(playreportTxt);

		var mainInfo = new FlxSprite(80, mainReport.y + 60).loadGraphic(Paths.image('MainOwn'));
		mainInfo.antialiasing = ClientPrefs.globalAntialiasing;
		mainInfo.scale.set(0.6, 0.6);
		add(mainInfo);

		var infoTxt = new FlxText(-60 ,mainRunningGuy.y + 200 + 90 + 60, FlxG.width - 800, "My Account", 32);
		infoTxt.setFormat(Paths.font("AMGUS.ttf"), 40, 0xd7fff4, RIGHT);
		infoTxt.scrollFactor.set();
		add(infoTxt);

		var mainOptions = new FlxSprite(80, mainReport.y + 120).loadGraphic(Paths.image('MainOptions'));
		mainOptions.antialiasing = ClientPrefs.globalAntialiasing;
		mainOptions.scale.set(0.6, 0.6);
		add(mainOptions);

		var settingsTxt = new FlxText(-60 ,mainRunningGuy.y + 200 + 90 + 120, FlxG.width - 800, "OPTIONS", 32);
		settingsTxt.setFormat(Paths.font("AMGUS.ttf"), 40, 0xd7fff4, RIGHT);
		settingsTxt.scrollFactor.set();
		add(settingsTxt);

		var creditsTxt = new FlxText(mainRunningGuy.x + 100,615, FlxG.width - 800, "credits", 32);
		creditsTxt.setFormat(Paths.font("AMGUS.ttf"), 40, FlxColor.WHITE, LEFT);
		creditsTxt.scrollFactor.set();
		add(creditsTxt);

		var quitTxt = new FlxText(mainRunningGuy.x + 50 + 210,615, FlxG.width - 800, "Curscene", 32);
		quitTxt.setFormat(Paths.font("AMGUS.ttf"), 40, FlxColor.WHITE, LEFT);
		quitTxt.scrollFactor.set();
		add(quitTxt);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Sussy funkin Shine mogus v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	//mouse things
	var canClick:Bool = true;
	var canusingMouse:Bool = true;
	var usingMouse:Bool = false;
	var usingkey:Bool = true;

	override function update(elapsed:Float)
	{

		//sprite.angle++;
		//guy1.angle++;

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin && canusingMouse)
			{
				menuItems.forEach(function(spr:FlxSprite)
					{
						if(usingMouse)
	
							{
								if(!FlxG.mouse.overlaps(spr))
								{
									changeItem();
								spr.updateHitbox();
								canusingMouse = false;
								usingkey = true;
								}
							}
	
							if (FlxG.mouse.overlaps(spr))
								{
									if(canClick)
									{
										curSelected = spr.ID;
										canusingMouse = true;
										usingMouse = true;
										usingkey = false;
									}
	
									if(FlxG.mouse.pressed && canClick)
										{
											selectedSomethin = true;
											FlxG.sound.play(Paths.sound('confirmMenu'));
	
											if (curSelected != spr.ID)
												{
													//flx by zffgug
												}
												else
												{
														new FlxTimer().start(1, function(tmr:FlxTimer)
												{
											switch (optionShit[curSelected]) 
											{
												case 'storymode':
													MusicBeatState.switchState(new StoryMenuState());
												case 'freeplay':
													MusicBeatState.switchState(new FreeplayState());
												case 'shop':										
													MusicBeatState.switchState(new ShopState());
												case 'quit':
													MusicBeatState.switchState(new CutsceneState());
												case 'update':
													MusicBeatState.switchState(new AccountState());
												case 'credits':
													MusicBeatState.switchState(new CreditsState());
												case 'options':
													LoadingState.loadAndSwitchState(new options.OptionsState());
											}

											if (optionShit[curSelected] == 'news')
											{
												CoolUtil.browserLoad('https://gamejolt.com/@Axolotl-mouka');
												selectedSomethin = false;
											}

											});
										}
									}
									}
								});
							}

		if (!selectedSomethin && usingkey)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

	/*		if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}*/

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'news')
				{
					CoolUtil.browserLoad('https://gamejolt.com/@Axolotl-mouka');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{

						if (curSelected != spr.ID)
						{
							/*FlxTween.tween(spr, {alpha: 1}, 1, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});*/
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 1, true, true, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'storymode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									case 'shop':										
										MusicBeatState.switchState(new ShopState());
									case 'quit':
										MusicBeatState.switchState(new CutsceneState());
									case 'update':
										MusicBeatState.switchState(new AccountState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
		//		selectedSomethin = true;
		//		MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
			{
				if (FlxG.mouse.overlaps(spr))
					{
							canusingMouse = true;
							usingkey = false;
							changeItem();
					}
				//spr.screenCenter(X);
			});
	}

	function addMenuItem(id:Int, x:Float, y:Float) {
		menuItem = new FlxSprite(x, y);
		menuItem.frames = Paths.getSparrowAtlas('amongus/' + optionShit[id]);
		menuItem.animation.addByPrefix('idle', optionShit[id] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[id] + " white", 24);
		menuItem.animation.play('idle');
		//menuItem.scale.x = 0.6;
		//menuItem.scale.y = 0.6;
		menuItem.ID = id;
		menuItems.add(menuItem);
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		menuItem.updateHitbox();
	}

	function clickbutton()//click button
	{
		//
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
