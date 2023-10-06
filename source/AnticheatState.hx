package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.text.FlxText;
import flixel.input.keyboard.FlxKey;
import flixel.input.mouse.FlxMouse;
import flixel.ui.FlxButton;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
//import Controls;


class AnticheatState extends FlxState
{
	var colorTween:FlxTween;
	

	function click():Void
	{
		FlxG.sound.play(Paths.sound('cancelMenu'));
		FlxG.switchState(new FreeplayState());
	}
	
	override public function create()
	{	

		FlxG.mouse.visible = true;
		FlxG.sound.playMusic(Paths.music('AC'), 0);

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scale.set(1,1);
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var bg2:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('bg_'));
		//bg2.scale.set(1,1);
		bg2.screenCenter();
		bg2.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg2);

		var txt:FlxText = new FlxText( 0, 0,'Chart Editor is not allow >:(\nBut you can turn on botplay');
		txt.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);

		var button:FlxButton = new FlxButton(10, 0, '' , click);
		button.loadGraphic(Paths.image('Exit'));
		//button.screenCenter();
		add(button);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}