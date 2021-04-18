Player = GameObject:extend() -- протсто как тип обьекта

function Player:new(area,x,y,otps)
    Player.super.new(self,area,x,y,opts)

    input:bind("k",function() self:destroy() end)
    self.area = area
    self.x,self.y =x,y
    self.w,self.h = 8,8
    self.collider = self.area.world:newCircleCollider(self.x,self.y,self.w) -- создание колайдера
    self.collider:setCollisionClass("Player")
    self.dir = -1
    self.trail = {}
    self.trail.x = {}
    self.trail.y = {}
    self.d = 1.2*self.w -- диа
    self.collider:setObject(self)
    self.shoot_speed = 1
    self.timer:every(self.shoot_speed,function() self:shoot(self.x,self.y) end)
    self.water_color = water_small_buble

    -- добавить коммиты



    --характеристика


    -- модели для головы
    self.model = {}
    self.model.name = "Kokora"
    self.model.polygons = {}

    if self.model.name == "Kokora" then
        self.model.polygons[1] = {
            self.w/2, 0, -- 1
            self.w, -self.w/2, -- 2
            -self.w/2, -self.w, -- 3
            -self.w, 0, -- 4
            -self.w/2, self.w, -- 5
            self.w, self.w/2, -- 6
        }
    end
    

    self.r = -math.pi /2
    self.r_turn_speed = math.pi * stats.turn_speed
    self.v = 0
    self.rt = 0 -- Для хвосат поворрот


    self.max_hp = 100
    self.hp = self.max_hp

    self.max_ammo = 100
    self.ammo = self.max_ammo

    self.base_max_v = stats.base_speed
    self.max_v = self.base_max_v


    self.boost_speed_up = stats.speed_up
    self.boost_speed_down = stats.speed_down


    self.max_boost = stats.base_speed
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
    --print(self.ammo)
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
        self.area:addGameObject("Trail",self.x,self.y,self) 
    end

    --local mx,my = love.mouse.getPosition()
    --self.r = getAngle(self.x,self.y,mx,my)

    self.v = math.min(self.v + self.a*dt, self.max_v) -- скорость лимит max_v
    if self.collider then 
        self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r)) 
        --camera.scale = 1
        --camera.scale = 0.5
    end
end

function Player:draw()
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
end

function Player:tick()
    self.area:addGameObject('TickEffect',self.x,self.y,{parent = self})
end




--- Лапы нужно сделать