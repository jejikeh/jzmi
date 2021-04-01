function soundInit()
    sources = {}
    playing_sources = {}
    tags = {
        sfx = {volume = 1},
        master = {volume = 1},
        music = {base_volume = 1, volume = 1, multiplier = 0,loop = true},
        game = {base_volume = 1, volume = 1, multiplier = 0}
    }

    songs = {
        'Relaxing',
        'RelaxingAmbient',
        --'RelaxingWithoutDrums',
        'ShopTime'
    }
    for _, song in ipairs(songs) do register(song,'stream',tags.music) end
end

function register(name,sound_type,tags)
    if not sources[name] then 
        sources[name] = {source = ripple.newSound(love.audio.newSource('resources/sounds/music/'..name.. '.wav',sound_type)),type = sound_type,tags = tags} 
        print("dd")
    end
end

function playSound(name)
    print(sources['ShopTime'].tags.volume)
    sources['RelaxingAmbient'].source:play{volume = sources['Relaxing'].tags.volume, loop =sources['Relaxing'].tags.loop }
end

function soundUpdate(dt)
    for _, source in ipairs(sources) do
        sources.ripple:update(dt)
    end
end

function soundShoot()
    playSound()
end

