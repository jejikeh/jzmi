Object = require "libs/classic-master/classic" 
Input = require"libs/boipushy-master/Input"
Timer = require "libs/hump-temp-master/timer"
Camera = require "libs/hump-temp-master/camera"
ripple = require "libs/ripple-master/ripple"
fn = require "libs/Moses-master/moses"
wf = require("libs/windfield")
require("utils")
require("globals")
require("libs/SoundManager")

w, h = love.window.getDesktopDimensions()
--sx,sy = w/gw,h/gh


function resizeFullscreen()
    fullscreen = true
    love.window.setMode(w,h,{display = display,fullscreen = false,borderless = true})
    sx,sy = w/gw,h/gh
end

function changeToDisplay(n)
    display = n
    resize(getScaleBasedOnDisplay())
end

function getScaleBasedOnDisplay()
    local w, h = love.window.getDesktopDimensions(display)
    local sw, sh = math.floor(w/gw), math.floor(h/gh)
    if sw == sh then return math.min(sw, sh) - 1
    else return math.min(sw, sh) end
end

function resize(x,y,fs)
    local y = y or x
    fullscreen = fs
    love.window.setMode(gw *x, gh * y, {display = display, fullscreen = fs, borderless = fs})
    --love.window.setFullscreen(true,"desktop")
    sx, sy = x, y
end

function love.load()
    --resizeFullscreen()
    --getScaleBasedOnDisplay()
    resize(sx,sy)
    --love.window.setFullscreen(true,'desktop')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle("rough")
    -- библиотеки
    camera = Camera()
    input = Input() -- управление вводом и взводом :/
    timer = Timer() -- управление временем
    --playSound()
    soundInit()


    input:bind('fdown','3') -- нужно перебросить в отдельный файл
    input:bind('fright','2') 
    input:bind('fup','1') 
    input:bind('fleft','4')

    input:bind("z",function() gotoRoom("Stage","Stage") end) -- пусти
    input:bind("x",function() gotoRoom("Stage1","Stage1") end)
    --input:bind("s",function() randomMusicPlay() end) -- трясем


    input:bind('left', 'left')
    input:bind('right', 'right')
    input:bind('down', 'down')
    input:bind('up', 'up')
    input:bind("a","add")
    input:bind("space","shoot")

    input:bind('f1', function()
        print("Before collection: " .. collectgarbage("count")/1024)
        collectgarbage()
        print("After collection: " .. collectgarbage("count")/1024)
        print("Object count: ")
        local counts = type_count()
        for k, v in pairs(counts) do print(k, v) end
        print("-------------------------------------")
    end)
    --image = love.graphics.newImage("1.png")

    slow_amount = 1 -- замедление времени
    flash_frames = nil

    rooms = {} -- все комнаты:(
    current_room = nil -- текущая комната
    local room_files = {}
    recursiveEnumerate('rooms',room_files) -- собственно получение этих сущностей в ввиде массива
    requireFiles(room_files) 

    local object_files = {} -- все файлы сущностей
    recursiveEnumerate('entity',object_files) -- собственно получение этих сущностей в ввиде массива
    requireFiles(object_files) -- всех из списка в общагу сюда -- михаил
end

function requireFiles(files)
    for _,file in ipairs(files)do
        local file = file:sub(1,-5)
        --print(file)
        require(file)
    end
end

function recursiveEnumerate(folder,file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder ..'/'.. item
        if love.filesystem.getInfo(file,"file") then
            table.insert(file_list,file)
        elseif love.filesystem.getInfo(file,"directory") then
            recursiveEnumerate(file,file_list)
        end
    end
end

function love.update(dt)
    
    soundUpdate(dt)
    if current_room then current_room:update(dt * slow_amount)end -- если в дный мнт комната ее нужно обновитть
    if slow_amount >= 1 then
        slow_amount = 1
    end

    timer:update(dt * slow_amount) -- умножается на параметр замедления
    camera:update(dt * slow_amount)
    
    if input:pressed('1') then 
        --current_room = Stage("test","test",400,300,20)
    end
    if input:pressed('2') then 
        --current_room = Typa("test","test",200,300,20)
    end
    if input:pressed('3') then 
        print('3') 
    end
    if input:pressed('4') then 
        print('4') 
    end
end

function slow(amount, duration)
    slow_amount = amount
    timer:tween(duration, _G, {slow_amount = 1}, 'in-out-cubic')
end

function flash(frames)
    flash_frames = frames
end


function love.draw()
    if current_room then current_room:draw() end -- нужно отрисовать
    --circle:draw()
    --love.graphics.draw(image,0,0) 

    if flash_frames then
        flash_frames = flash_frames - 1
        if flash_frames == -1 then flash_frames = nil end
    end
    if flash_frames then
        love.graphics.setColor(background_color)
        love.graphics.rectangle("fill",0,0, gw*sx,gh*sy)
        love.graphics.setColor(1,1,1)
    end
end

function addRoom(room_type,room_name,...) -- создаем комнату
    current_room = _G[room_type](room_name,...) -- находим из глобальных переменных
    rooms[room_name] = current_room -- добавляем в массив
    return room
end

function gotoRoom(room_type,room_name,...) --смена сцены
    if current_room and current_room.destroy then 
        current_room:destroy() 
    end
    --current_room = _G[room_type](room_name,...)
    if current_room and rooms[room_name] then -- если комната загружена и есть еще что загружать
        current_room = _G[room_type](room_name,...)-- меняем
        if current_room.deactivate then current_room:deactivate() end -- что надо изменяем
        if current_room.activate then current_room:activate() end
    else
        curent_room = addRoom(room_type,room_name,...) -- если ничего нет придется создать
    end
end