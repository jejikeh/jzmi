function soundInit()
    sources = {}
    playing_sound = {}
    tags = {
        sfx = {volume = 0.4},
        master = {volume = 1},
        music = {base_volume = 1, volume = 1, multiplier = 0,loop = true,music = true},
        game = {base_volume = 1, volume = 1, multiplier = 0}
    }

    register('game_shoot_1','static',{'master','sfx','game'},false)
    register('game_shoot_2','static',{'master','sfx','game'},false)
    register('game_shoot_3','static',{'master','sfx','game'},false)
    register('menu_click','static',{'master','sfx','game'},false)
    register('game_hurt_1','static',{'master','sfx','game'},false)
    register('game_hurt_2','static',{'master','sfx','game'},false)


    songs = {
        'Relaxing',
        'RelaxingAmbient',
        --'RelaxingWithoutDrums',
        'ShopTime'
    }
    for _, song in ipairs(songs) do register(song,'stream',{'master','music'},true) end
end

function register(name,sound_type,tags,music)
    if not sources[name] and music then 
        sources[name] = {source = ripple.newSound(love.audio.newSource('resources/sounds/music/'..name.. '.wav',sound_type)),type = sound_type,tags = tags} 
    end
    if not sources[name] and not music then 
        sources[name] = {source = ripple.newSound(love.audio.newSource('resources/sounds/'..name.. '.ogg',sound_type)),type = sound_type,tags = tags} 
    end
end

function addSound(name)
    if not playing_sound[name] then
        table.insert( playing_sound,sources[name] )
        --soundUpdate(dt)
        --playing_sound[name] = sources[name].source:play{volume = tags.master.volume*tags.sfx.volume, loop = tags.loop, pitch =  dt}
    end
end
function soundUpdate(dt)
    for _, sound in ipairs(playing_sound) do
        sound.source:stop()
        local n = 0
        n = n + 1
        sound.source:play{volume = tags.master.volume*tags.sfx.volume, loop = tags.loop}
        table.remove( playing_sound,n)
    end
end

function soundStop()
    for key in pairs(sources) do
        sources[key].source:stop()
    end
end

function soundShoot()
    addSound('menu_click')
end

function soundExplosion()
    addSound('game_hurt_2')
end

function soundDeath()
    addSound("game_hurt_1")
end

function randomMusicPlay()
    local n_songs = 0

    for _ in ipairs(playing_sound) do
        local n = 0
        n = n + 1
        table.remove( playing_sound,n)
    end

    for _ in ipairs(songs) do
        n_songs = n_songs + 1
    end
    sources[songs[love.math.random(1,n_songs)]].source:play{volume = tags.master.volume*tags.music.volume, loop = tags.music.loop}
end

