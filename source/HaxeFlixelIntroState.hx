package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

using StringTools;


class HaxeFlixelIntroState extends MusicBeatState
{

		override public function create()
		{
				FlxG.sound.pause();
				FlxG.mouse.visible = false;
				new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					(new FlxVideo(Paths.video('HaxeFlixelIntro'))).finishCallback = function()
						{
							MusicBeatState.switchState(new TitleState());
							//TitleState.skippedIntro = true;		//like sonic.exe lol
							FlxG.sound.resume();
						}
				});
		}
}
