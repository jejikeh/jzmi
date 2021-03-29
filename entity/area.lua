Area = Object:extend()

function Area:new(room)
    self.room = room
    self.game_objects = {}
end

function Area:addPhysicsWorld() -- просто физизка которую можно создать в любой комнате  
    self.world = wf.newWorld(0,0,true)
    self.world:setGravity(0, 512)
end

function Area:destroy()
    for i = #self.game_objects,1,-1 do
        local game_object = self.game_objects[i]
        game_object:destroy()
        table.remove(self.game_objects,i)
    end
    self.game_objects = {}

    if self.world then
        self.world:destroy()
        self.world = nil
    end
end

function Area:addGameObject(game_object_type,x,y,opts)
    local opts = opts or {} -- opts может быть один,или если больше одного до создается массив
    local game_object = _G[game_object_type](self,x or 0,y or 0,opts)
    table.insert( self.game_objects,game_object)
    return game_object
end
function Area:update(dt)
    if self.world then self.world:update(dt) end

    for i = #self.game_objects,1,-1 do --[[ каждый елемент в массиве обьектов с конца!!!!
        т.к в lua если удалять обьекты в массиве с начала то могут пропускаться обьекты
    ]]--
        local game_object = self.game_objects[i] -- отдельно присвоить переменной
        game_object:update(dt) -- обновляем отдельно кадждый элемнт в масиве
        if game_object.dead then 
            game_object:destroy()
            table.remove( self.game_objects,i) 
        end -- если 
    end

    --[[
    for i,game_objects in ipairs(self.game_objects) do 
        game_objects:update(dt) 
    end
    --[[
        for i,game_objects in ipairs
        i = min
        game_objects = max -- так как массив возращает число элементов в нем
        in ipairs тут уже каждый елемент не как номер а как обьект
        game_objects:update(dt) каждый обьект в массиве обновляется
    ]]--
end

function Area:draw()
    --if self.world then self.world:draw() end -- т.к это рисует коллайдер а не спрайт
    for i,game_object in ipairs(self.game_objects) do
        game_object:draw()
    end
end