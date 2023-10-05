function onCreate()
    
    --[[Code made by Drawoon_ 
    if you use it give credits]]
    addHaxeLibrary('Song')
    addHaxeLibrary('SwagSong','Song')
    addHaxeLibrary('Section')
    addHaxeLibrary('SwagSection','Section')
    addHaxeLibrary('Note')
    addHaxeLibrary('Std')
    addHaxeLibrary('Math')
    addHaxeLibrary('FlxMath','flixel.math')
    --debugPrint(songPath)
    local Song=songPath
    
    runHaxeCode([[
        var SecondSong:SwagSong;
        SecondSong= Song.loadFromJson(']]..Song..[[-other', ']]..Song..[[');
        var Notedata:Array<SwagSection>=SecondSong.notes;
        for (Section in Notedata)
		{
			for (songNotes in Section.sectionNotes)
			{
              var Strum:Float =songNotes[0];
              var NoteData:Int = Std.int(songNotes[1] % 4);
              var MustHitSection= Section.mustHitSection;
              if (songNotes[1] > 3)
              {
                MustHitSection = !Section.mustHitSection;
              }
              var LastNote:Note;
              if (game.unspawnNotes.length > 0) LastNote = game.unspawnNotes[Std.int(game.unspawnNotes.length - 1)];
              else LastNote = null;
              var NewNote:Note = new Note(Strum, NoteData, LastNote);
              NewNote.mustPress = MustHitSection;
              NewNote.sustainLength = songNotes[2];
              NewNote.gfNote = false;
              NewNote.noteType = songNotes[3];
              NewNote.noteType = 'SecondJson';
              NewNote.scrollFactor.set();
              var Length:Float = NewNote.sustainLength;
              Length=Length / Conductor.stepCrochet;
              game.unspawnNotes.push(NewNote);
              var floor:Int = Math.floor(Length);
                if(floor > 0) {
                    for (susNote in 0...floor+1)
                    {
                        LastNote = game.unspawnNotes[Std.int(game.unspawnNotes.length - 1)];
                        var NewSustan:Note = new Note(Strum + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(]]..getProperty('songSpeed')..[[, 2)), NoteData, LastNote, true);
                        NewSustan.mustPress = MustHitSection;
                        NewSustan.gfNote = false;
                        NewSustan.noteType = NewNote.noteType;
                        NewSustan.noteType = 'SecondJson';
                        NewSustan.scrollFactor.set();
                        NewNote.tail.push(NewSustan);
                        NewSustan.parent = NewNote;
                        game.unspawnNotes.push(NewSustan);
                        if (NewSustan.mustPress) NewSustan.x += FlxG.width / 2;
                        else if(ClientPrefs.middleScroll) 
                        {
                            NewSustan.x += 310;
                            if(NoteData > 1) NewSustan.x += FlxG.width / 2 + 25;
                        }
                    }
                }
                if (NewNote.mustPress) NewNote.x += FlxG.width / 2;
                else if(ClientPrefs.middleScroll)
				{
					NewNote.x += 310;
					if(Notedata > 1) NewNote.x += FlxG.width / 2 + 25;
				}
            }
        }
        //game.addTextToDebug(SecondSong.song,]]..getColorFromHex('FF0000')..[[);
    ]])

    sing={'singLEFT', 'singDOWN', 'singUP', 'singRIGHT'}
    NewsCharacter={}
    CreateCharacter('ZR','DAD',126-110, 100,'Opponent2')
    CreateCharacter('sus-yf',"DAD",400, -140,'Player2')
    
    Player2='Player2'
    Opponent2='Opponent2'
end
function onCreatePost()
    setObjectOrder('Opponent2',getObjectOrder('dadGroup')-1)
    setObjectOrder('Player2',getObjectOrder('boyfriendGroup')-1)
    for i=0,getProperty('unspawnNotes.length')-1 do
        if getPropertyFromGroup('unspawnNotes',i,'noteType')=='SecondJson' then
            setPropertyFromGroup('unspawnNotes', i, 'multAlpha', 0.3)
            setPropertyFromGroup('unspawnNotes', i, 'colorSwap.hue', 0)
            setPropertyFromGroup('unspawnNotes', i, 'colorSwap.saturation', -50)
            setPropertyFromGroup('unspawnNotes', i, 'colorSwap.brightness', 0)
            if getPropertyFromGroup('unspawnNotes',i,'isSustainNote') and not stringEndsWith(getPropertyFromGroup('unspawnNotes',i,'animation.curAnim.name'),'end')  then
                setPropertyFromGroup('unspawnNotes',i,'scale.y',getProperty('songSpeed')*1.7)
                updateHitboxFromGroup('unspawnNotes',i)
            end
            if  getPropertyFromGroup('unspawnNotes',i,'mustPress') then
                setPropertyFromGroup('unspawnNotes', i, 'blockHit', true)
            else
                setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true)
            end
        end
    end
    
end
function GetFromNote(id,var)
    return getPropertyFromGroup('notes',id,var)
end
function onUpdate(elapsed)
    local ActualNoteId=nil
    for i=getProperty('notes.length')-1,0,-1 do
        if GetFromNote(i,'noteType')=='SecondJson' then
            ActualNoteId=i
            break
        end
    end
    if ActualNoteId~=nil then
    if not GetFromNote(ActualNoteId,'mustPress') and GetFromNote(ActualNoteId,'wasGoodHit') then
        HitbyOpponent(ActualNoteId)
    end
    if GetFromNote(ActualNoteId,'mustPress') and GetFromNote(ActualNoteId,'canBeHit') then
        if GetFromNote(ActualNoteId,'isSustainNote') then
            HitbyPlayer(ActualNoteId)
        elseif GetFromNote(ActualNoteId,'strumTime')<=getSongPosition() or GetFromNote(ActualNoteId,'isSustainNote') then
            HitbyPlayer(ActualNoteId)
        end
    end
    end
    for i=1,#NewsCharacter do
        UpdateTag= NewsCharacter[i]["Name"]
    if getProperty(UpdateTag..'.holdTimer') > stepCrochet * (0.0011 / playbackRate) * getProperty(UpdateTag..'.singDuration') and  stringStartsWith(getProperty(UpdateTag..'.animation.curAnim.name'),'sing') and not stringEndsWith(getProperty(UpdateTag..'.animation.curAnim.name'),'miss') then
        runHaxeCode([[
            getVar(']]..UpdateTag..[[').dance(); 
        ]])
    end
    end

end
function HitbyPlayer(id)
    if GetFromNote(id,'noAnimation') then
        callScript('data/GhostAnim','GhostAnim',{Player2,sing[GetFromNote(id,'noteData')+1]})
    else
        runHaxeCode([[
            getVar(']]..Player2..[[').playAnim(']]..sing[GetFromNote(id,'noteData')+1]..[[',true);
            getVar(']]..Player2..[[').holdTimer=0;
        ]])
    end

    removeFromGroup('notes',id,false)
end
function HitbyOpponent(id)
    if GetFromNote(id,'noAnimation') then
        callScript('data/GhostAnim','GhostAnim',{Opponent2,sing[GetFromNote(id,'noteData')+1]})
    else
        runHaxeCode([[
            getVar(']]..Opponent2..[[').playAnim(']]..sing[GetFromNote(id,'noteData')+1]..[[',true);
            getVar(']]..Opponent2..[[').holdTimer=0;
        ]])
    end

    removeFromGroup('notes',id,false)
end

function onBeatHit()
    for i=1,#NewsCharacter do
        BeatTag= NewsCharacter[i]["Name"]
    if curBeat% getProperty(BeatTag..'.danceEveryNumBeats')==0 and getProperty(BeatTag..'.animation.curAnim')~=nil and not stringStartsWith(getProperty(BeatTag..'.animation.curAnim.name'),'sing') and not getProperty(BeatTag..'.stunned') then
    runHaxeCode([[
            getVar(']]..BeatTag..[[').dance(); 
    ]])
    end
    end
end
function onEvent(eventName, value1, value2)
    if eventName=='Play Animation' then
        if CharacterExist(value2) then
        runHaxeCode([[
            getVar(']]..value2..[[').playAnim(']]..value1..[[',true);
            getVar(']]..value2..[[').specialAnim=true;
        ]])
        end
    end
end

function CreateCharacter(CharName,tYpe,PosX,PosY,Tag)
    if CharacterExist(Tag) then
        RemoveCharacter(Tag)
    end
    if tYpe =='DAD' then
        runHaxeCode([[
            var Dad2:Character;
            Dad2 = new Character(]]..PosX..[[,]]..PosY..[[,']]..CharName..[[');
            game.add(Dad2);
            Dad2.dance();
            setVar(']]..Tag..[[',Dad2);
        ]])
    else 
        runHaxeCode([[
            var BF2:Boyfriend;
            BF2 = new Boyfriend(]]..PosX..[[,]]..PosY..[[,']]..CharName..[[');
            game.add(BF2);
            BF2.dance();
            setVar(']]..Tag..[[',BF2);
        ]])
    end
    --ChangeSingChar(Tag,tYpe)
    table.insert(NewsCharacter,{Type=tYpe,Name=Tag})


end
function RemoveCharacter(Tag)
    runHaxeCode([[
        getVar(']]..Tag..[[').kill();
        removeVar(']]..Tag..[[');
    ]])
    for i=1,#NewsCharacter do
        if NewsCharacter[i]["Name"]==Tag then
            table.remove(NewsCharacter, i)
        end
    end
end
function FindArrayPos(Tag)
    for i=1,#NewsCharacter do
        if NewsCharacter[i]["Name"]==Tag then
            return i
        end
    end
end
function CharacterExist(tag)
    for i=1,#NewsCharacter do
        if NewsCharacter[i]["Name"]==tag then
            return true 
        end
        if i==#NewsCharacter then
            return false
        end
    end
end

