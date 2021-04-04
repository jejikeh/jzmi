Player = GameObject:extend() -- протсто как тип обьекта

function Player:new(area,x,y,otps)
    Player.super.new(self,area,x,y,opts)

    input:bind("k",function() self:destroy() end)
    self.area = area
    self.x,self.y =x,y
    self.w,self.h = 8,8
    self.collider = self.area.world:newCircleCollider(self.x,self.y,self.w) -- создание колайдера
    self.collider:setCollisionClass("Player")
    self.trail = {}
    self.dir = -1
    self.trail.n = 0
    self.d = 1.2*self.w -- диаметр
    self.trail.collider = {}
    self.trail.x = {} -- массив так как для каждого колайдера будет своя координата
    self.trail.y = {}
    self.collider:setObject(self)
    self.shoot_speed = 1
    self.timer:every(self.shoot_speed,function() self:shoot(self.x,self.y) end)
    self.water_color = water_small_buble

    -- добавить коммиты



    --характеристика

    self.stats = {}
    self.stats.turn_speed = 1
    self.stats.base_speed = 100
    self.stats.speed_up = 1.5
    self.stats.speed_down = 0.5


    -- модели для головы
    self.model = {}
    self.model.name = "Kokora"
    self.model.polygons = {}

    if self.model.name == "Kokora" then
        self.stats.turn_speed = self.stats.turn_speed 
        self.stats.base_speed = self.stats.base_speed 
        self.stats.speed_up = self.stats.speed_up 
        self.stats.speed_down = self.stats.speed_down
        self.model.polygons[1] = {
            self.w/2, 0, -- 1
            self.w, -self.w/2, -- 2
            -self.w/2, -self.w, -- 3
            -self.w, 0, -- 4
            -self.w/2, self.w, -- 5
            self.w, self.w/2, -- 6
        }
    end
    self.trail.model = {}
    self.trail.model.name = {}
    self.trail.model.color = {}
    self.trail.model.polygons = {}

    for i=0,self.trail.n do -- количество елементов в хвосте
        self.trail.x[i] = x-- координаты
        self.trail.y[i] = y + i -- чтобы спавнились сверху а не в одной точкеs
        self.trail.model.name[i] = "usel"
        self.trail.model.color[i] = default_color
        if self.trail.model.name[i] == "usel" then
            self.stats.turn_speed = self.stats.turn_speed
            self.stats.base_speed = self.stats.base_speed
            self.stats.speed_up = self.stats.speed_up 
            self.stats.speed_down = self.stats.speed_down 
            print("dd")
    
            self.trail.model.polygons[1] = {
                -self.w/2,0,
                -self.w,-self.w/2,
                self.w/2,-self.w/1.2,
                self.w,0,
                self.w/2,self.w/1.2,
                -self.w,self.w/2
            }
        elseif self.trail.model.name[i] == "kia" then
            self.stats.turn_speed = self.stats.turn_speed
            self.stats.base_speed = self.stats.base_speed
            self.stats.speed_up = self.stats.speed_up 
            self.stats.speed_down = self.stats.speed_down 
            print("ff")
    
            self.trail.model.polygons[1] = {
                self.w,0,
                self.w,-self.w/2,
                self.w/2,-self.w/1.2,
                self.w,0,
                self.w/2,self.w/1.2,
                -self.w,self.w/2
            }
        end
        --print(self.trail.y[i])
        self.trail.collider[i] = self.area.world:newCircleCollider(self.trail.x[i],self.trail.y[i] + (self.w-i),self.w) --[[
            каждый отдельный обьект в массиве определяется как колайдер. Кргу должен иметь координаты X Y и радиус
            смезение по игроку для растояние между обьектами в хвосте. Координата + Радиус головы + радиус хвоста
        ]]--
        self.trail.collider[i]:setObject(self)
        self.trail.collider[i]:setCollisionClass("Trail")

    end
    

    self.r = -math.pi /2
    self.r_turn_speed = math.pi * self.stats.turn_speed
    self.v = 0
    self.rt = 0 -- Для хвосат поворрот


    self.max_hp = 100
    self.hp = self.max_hp

    self.max_ammo = 100
    self.ammo = self.max_ammo

    self.base_max_v = self.stats.base_speed
    self.max_v = self.base_max_v


    self.boost_speed_up = self.stats.speed_up
    self.boost_speed_down = self.stats.speed_down


    self.max_boost = 100
    self.boost = self.max_boost
    self.can_boost = true
    self.boost_timer = 0
    self.boost_cooldown = 2

    self.a = 100

    self.wouble = 1.25
    self.fill = "line"

    self.timer:every(0.1,function()
        self.area:addGameObject("WaterParticleEffect",self.x + random(-gw,gw),self.y + random(-gh,gh),{parent = self, r = random(2,4), d = random(0.15,0.25),color = background_color})
    end)
    self.timer:every(0.1,function()
        self.area:addGameObject("WaterParticleEffect",self.x + random(-50,50) +self.w * 6 * math.cos(self.r),self.y + random(-50,50)  + self.h* 6 * math.sin(self.r),{parent = self, r = random(2,4), d = random(0.15,0.25),color = self.water_color})
        for i=0,self.trail.n do
            self.area:addGameObject("WaterParticleEffect",self.trail.x[i] + random(-50,50) +self.w * math.cos(self.r),self.trail.y[i] + random(-50,50)  + self.h * math.sin(self.r),{parent = self, r = random(2,4), d = random(0.15,0.25),color = self.water_color})
        end
    end)
    self.timer:every(random(5,7),function() self:tick()end)

end

function Player:shoot(x,y,time)
    local d = 1.2*self.w
    soundShoot()
    self:addBioMaterial(-1)
    self.area:addGameObject('ShootEffect',x+ d*math.cos(self.r),y + d * math.sin(self.r),self,self.d) -- на линии огня эффект
    self.area:addGameObject('Projectile',x+ 1.5 * d * math.cos(self.r) ,y + 1.5 * d * math.sin(self.r),self.r)
    
end

function Player:addBioMaterial(amount)
    self.ammo = math.min(self.ammo + amount,self.max_ammo)
    print(self.ammo)
end

function Player:addTail(trail,w,area,x,y) -- добавление хвоста
    trail.n = trail.n + 1  -- один добавился
    for i=trail.n ,trail.n  do -- просто луп проходит один раз
        local c = math.random(0,1)
        if c == 0 then
            trail.model.color[i] = default_color
            trail.model.name[i] = "kia"
        else 
            trail.model.color[i] = default_color
            trail.model.name[i] = "usel"
        end
        trail.x[trail.n] = trail.x[trail.n - 1]-- весь новый хвост заимствует данные из предыдущего
        --[[
            здесь проверять существует ли предпоследний обьект не нужно
        ]]--
        trail.y[trail.n] = trail.y[trail.n - 1] --+ self.trail.n -- чтобы спавнились сверху а не в одной точке
        --print(self.trail.y[i])
        trail.collider[trail.n] = area.world:newCircleCollider(trail.x[trail.n],trail.y[trail.n] + (w + (w - trail.n)),w)
        trail.collider[trail.n]:setObject(self)
        trail.collider[trail.n]:setCollisionClass("Trail")

    end
end

function Player:update(dt)
    Player.super.update(self,dt)


    if not self.dead and self.collider:enter('Collectable') then
        soundPickUp()
        local collision_data = self.collider:getEnterCollisionData('Collectable')
        local object = collision_data.collider:getObject()
        if object:is(DnaPoint) then
            self.wouble = 6
            self.fill = "fill"
            object:die()
        end
        if object:is(bioMaterial) then
            self.wouble = 6
            self.fill = "fill"
            --flash(2,bio_material_color)
            object:die()
            self:addBioMaterial(1)
        end
    else 
        self.wouble = 1.25
        self.fill = "line"
    end

    self.boost = math.min(self.boost + 10*dt,self.max_boost)
    self.boost_timer = self.boost_timer + dt
    if self.boost_timer > self.boost_cooldown then self.can_boost = true end
    self.boosting = false
    self.stopped = false
    self.max_v = self.base_max_v
    if input:down('up') and self.boost > 1 and self.can_boost then 
        self.boosting = true
        self.stopped = false
        self.max_v = self.boost_speed_up*self.base_max_v 
        self.boost = self.boost - 50 * dt
        if self.boost <= 1 then
            self.boosting = false
            self.can_boost = false
            self.boost_timer = 0
        end
        
    end
    if input:down('down') and self.boost > 1 and self.can_boost  then 
        --self:shoot(self.x,self.y)
        self.boosting = false
        self.stopped = true
        self.max_v = self.boost_speed_down*self.base_max_v 
        self.boost = self.boost - 50 * dt
        if self.boost <= 1 then
            self.boosting = false
            self.can_boost = false
            self.boost_timer = 0
        end
    end
    if self.boosting then 
        self.water_color = water_boost_buble 
    elseif self.stopped then 
        self.water_color = water_small_buble 
    else 
        self.water_color = background_color
    end

    --if input:down("shoot") then self:shoot(self.x,self.y) end

    if input:down("left") then self.r = self.r - self.r_turn_speed * dt end

    if input:down("right") then self.r = self.r + self.r_turn_speed * dt end
    if input:pressed("add") then 
        Player:addTail(self.trail,self.w,self.area,self.x,self.y)
    end

    --local mx,my = love.mouse.getPosition()
    --self.r = getAngle(self.x,self.y,mx,my)

    self.v = math.min(self.v + self.a*dt, self.max_v) -- скорость лимит max_v
    if self.collider then 
        self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r)) 
        --camera.scale = 1
        --camera.scale = 0.5
    end
    if self.trail.collider then -- если есть хвост
        for i=0,self.trail.n do
            if i==0 then-- для 0 элемента
                self.tr = -getAngle(self.x,self.y,self.trail.x[i],self.trail.y[i]) - math.rad(90) -- сначала первый за головой поворачивается и на 90 градусов
                self.trail.collider[i]:setLinearVelocity(self.v*(self.x- self.trail.x[i])/25,self.v*(self.y- self.trail.y[i])/25) --[[
                    0 элемент крепляется и следует к голове поэтому для него отдельно прописываем координату головы
                ]]--
            else
                self.trr = -getAngle(self.trail.x[i-1],self.trail.y[i-1],self.trail.x[i],self.trail.y[i]) - math.rad(90) -- потом цепочкой головы поворачиваются на угол предыдущего и на 90 градусов
                self.trail.collider[i]:setLinearVelocity(self.v*(self.trail.x[i-1] - self.trail.x[i])/25-i,self.v*(self.trail.y[i-1] - self.trail.y[i])/25-i)--[[
                    каждый последний элемент движется за прердпоследним (i-1) - предпоследний (i) - последний
                    это два катета по оси X и Y. Мы находим растоняние по этим осям от точки до точки, а setLinearVelocity находит направление и значение гипотенузы
                ]]-- 
            end
        end
    end
end

function Player:draw()
    for i=0,self.trail.n do
        if i==0  then
            love.graphics.setColor(self.trail.model.color[i])
            pushRotate(self.trail.x[i],self.trail.y[i],self.tr)
            for _,polygon in ipairs(self.trail.model.polygons) do
                local points = fn.map(polygon,function(v,k)
                    if k % 2 == 1 then
                        return self.trail.x[i] + v + random(-self.wouble,self.wouble) 
                    else
                        return self.trail.y[i] + v + random(-self.wouble,self.wouble) 
                    end
                end)
                love.graphics.polygon(self.fill,points)
            end
            love.graphics.pop()
        else
            love.graphics.setColor(self.trail.model.color[i])
            pushRotate(self.trail.x[i],self.trail.y[i],self.trr)
            for _,polygon in ipairs(self.trail.model.polygons) do --[[ каждая линия в массиве pollygons обрабатываетсяб
                    если элемент в массиве под четным индексом, то это по x
                ]]
                local points = fn.map(polygon,function(v,k)
                    if k % 2 == 1 then
                        return self.trail.x[i] + v + random(-self.wouble,self.wouble) 
                    else
                        return self.trail.y[i] + v + random(-self.wouble,self.wouble) 
                    end
                end)
                love.graphics.polygon(self.fill,points)
            end
            love.graphics.pop()
        end
    end
    pushRotate(self.x,self.y,self.r)
    love.graphics.setColor(default_color)
    for _,polygon in ipairs(self.model.polygons) do
        local points = fn.map(polygon,function(v,k)
            if k % 2 == 1 then
                return self.x + v + random(-self.wouble,self.wouble) 
            else
                return self.y + v + random(-self.wouble,self.wouble) 
            end
        end)
        love.graphics.polygon(self.fill,points)
    end
    love.graphics.pop()
end

function Player:destroy()
    soundDeath()
    Player.super.destroy(self)
    slow(0.25, 0.5)
    flash(2,default_color)
    self.dead = true
    for i = 1,love.math.random(10,20) do
        self.area:addGameObject("ExplodeParticle",self.x,self.y,{color = hp_color,d = 0.5,s=random(1,5),v = random(180,380), s1 = 2, s2 = 0.5, s3 = 100})
    end
    for i = 1,self.trail.n do
            self.area:addGameObject("ExplodeParticle",self.trail.x[i],self.trail.y[i],{color = hp_color,d = 2,s=random(1,5),v = random(180,380), s1 = 2, s2 = 0.5, s3 = 100})
    end
end

function Player:tick()
    self.area:addGameObject('TickEffect',self.x,self.y,{parent = self})
    n = love.math.random(0,self.trail.n)
    self.area:addGameObject('TickEffect',self.trail.x[n],self.trail.y[n],{trail = self.trail, n = n})
end




--- Лапы нужно сделать