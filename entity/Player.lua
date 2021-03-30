Player = GameObject:extend() -- протсто как тип обьекта

function Player:new(area,x,y,otps)
    Player.super.new(self,area,x,y,opts)

    input:bind("k",function() self:destroy() end)
    self.area = area
    self.x,self.y =x,y
    self.w,self.h = 16,16
    self.collider = self.area.world:newCircleCollider(self.x,self.y,self.w) -- создание колайдера
    self.trail = {}
    self.dir = -1
    self.trail.n = 0
    self.d = 1.2*self.w -- диаметр
    self.trail.collider = {}
    self.trail.x = {} -- массив так как для каждого колайдера будет своя координата
    self.trail.y = {}
    for i=0,self.trail.n do -- количество елементов в хвосте
        self.trail.x[i] = x-- координаты
        self.trail.y[i] = y + i -- чтобы спавнились сверху а не в одной точке
        --print(self.trail.y[i])
        self.trail.collider[i] = self.area.world:newCircleCollider(self.trail.x[i],self.trail.y[i] + (self.w + (self.w -i)),self.w) --[[
            каждый отдельный обьект в массиве определяется как колайдер. Кргу должен иметь координаты X Y и радиус
            смезение по игроку для растояние между обьектами в хвосте. Координата + Радиус головы + радиус хвоста
        ]]--
        self.trail.collider[i]:setObject(self)
    end
    self.collider:setObject(self)
    self.timer:every(1,function() self:shoot(self.x,self.y,self.dir) end)
    self.water_color = water_small_buble
    self.timer:every(0.05,function()
        self.area:addGameObject("WaterParticleEffect",self.x + random(-50,50) +self.w * 6 * math.cos(self.r),self.y + random(-50,50)  + self.h* 6 * math.sin(self.r),{parent = self, r = random(2,4), d = random(0.15,0.25),color = self.water_color})
        for i=0,self.trail.n do
            self.area:addGameObject("WaterParticleEffect",self.trail.x[i] + random(-50,50) +self.w * math.cos(self.r),self.trail.y[i] + random(-50,50)  + self.h * math.sin(self.r),{parent = self, r = random(2,4), d = random(0.15,0.25),color = self.water_color})
        end
    end)
    self.timer:every(random(5,7),function() self:tick()end)
    -- матеша
    self.r = -math.pi /2
    self.rv = 1.66*math.pi
    self.v = 0
    self.base_max_v = 100
    self.max_v = self.base_max_v

    self.a = 100

end

function Player:shoot(x,y)
    local d = 1.2*self.w
    self.area:addGameObject('ShootEffect',x+ d*math.cos(self.r),y + d * math.sin(self.r),self,self.d) -- на линии огня эффект
    self.area:addGameObject('Projectile',x+ 1.5 * d * math.cos(self.r) ,y + 1.5 * d * math.sin(self.r),self.r)
    
end

function Player:addTail(trail,w,area,x,y) -- добавление хвоста
    trail.n = trail.n + 1  -- один добавился
    for i=trail.n-1 ,trail.n  do -- просто луп проходит один раз
        trail.x[trail.n] = trail.x[trail.n - 1]-- весь новый хвост заимствует данные из предыдущего
        --[[
            здесь проверять существует ли предпоследний обьект не нужно
        ]]--
        trail.y[trail.n] = trail.y[trail.n - 1] --+ self.trail.n -- чтобы спавнились сверху а не в одной точке
        --print(self.trail.y[i])
        trail.collider[trail.n] = area.world:newCircleCollider(trail.x[trail.n],trail.y[trail.n] + (w + (w - trail.n)),w)
        trail.collider[trail.n]:setObject(self)
    end
end

function Player:update(dt)
    Player.super.update(self,dt)

    self.boosting = false
    self.max_v = self.base_max_v
    if input:down('up') then 
        self.boosting = true
        self.max_v = 1.5*self.base_max_v 
    end
    if input:down('down') then 
        self:shoot(self.x,self.y,self.dir)
        self.boosting = false
        self.max_v = 0.5*self.base_max_v 
    end
    if self.boosting then 
        self.water_color = water_boost_buble 
    else 
        self.water_color = water_small_buble 
    end


    --if input:down("shoot") then self:shoot(self.x,self.y) end

    if input:down("left") then self.r = self.r - self.rv * dt end

    if input:down("right") then self.r = self.r + self.rv * dt end
    if input:pressed("add") then 
        Player:addTail(self.trail,self.w,self.area,self.x,self.y)
    end

    self.v = math.min(self.v + self.a*dt, self.max_v) -- скорость лимит max_v
    if self.collider then 
        self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r)) 
        camera.scale = 1 - self.trail.n/100
        --camera.scale = 0.5
    end
    
    if self.trail.collider then -- если есть хвост
        for i=0,self.trail.n do
            if i==0 then-- для 0 элемента
                self.trail.collider[i]:setLinearVelocity(self.v*(self.x- self.trail.x[i])/50,self.v*(self.y- self.trail.y[i])/50) --[[
                    0 элемент крепляется и следует к голове поэтому для него отдельно прописываем координату головы
                ]]--
            else
                self.trail.collider[i]:setLinearVelocity(self.v*(self.trail.x[i-1] - self.trail.x[i])/25-i,self.v*(self.trail.y[i-1] - self.trail.y[i])/25-i)--[[
                    каждый последний элемент движется за прердпоследним (i-1) - предпоследний (i) - последний
                    это два катета по оси X и Y. Мы находим растоняние по этим осям от точки до точки, а setLinearVelocity находит направление и значение гипотенузы
                ]]-- 
            end
        end
    end
end

function Player:draw()
    --camera:attach()
    love.graphics.circle("line",self.x,self.y,self.w) -- путин
    for i=0,self.trail.n do
        love.graphics.circle("line",self.trail.x[i],self.trail.y[i],self.w) -- рисуем сразу весь хвост с уменьшением в радиусе
        if i==0  then
            --self:shoot(self.trail.x[i],self.trail.y[i])
            love.graphics.line(self.trail.x[i],self.trail.y[i],self.x,self.y) -- опять также для первого элемента устанавливаем линии по голове
        else
            love.graphics.line(self.trail.x[i],self.trail.y[i],self.trail.x[i-1],self.trail.y[i-1]) --также как как и в обработке направления
        end
    end
    --camera:detach()
    --love.graphics.line(self.x,self.y,self.x + 2 * self.w*math.cos(self.r),self.y + 2*self.w*math.sin(self.r))
end

function Player:destroy()
    Player.super.destroy(self)
    slow(0.25, 0.5)
    flash(2)
    self.dead = true
    for i = 1,love.math.random(10,20) do
        self.area:addGameObject("ExplodeParticle",self.x,self.y,{color = hp_color,d = 0.5,s=random(1,5),v = random(180,380)})
    end
    for i = 1,self.trail.n do
            self.area:addGameObject("ExplodeParticle",self.trail.x[i],self.trail.y[i],{color = hp_color,d = 2,s=random(1,5),v = random(180,380)})
    end
end

function Player:tick()
    self.area:addGameObject('TickEffect',self.x,self.y,{parent = self})
    n = love.math.random(0,self.trail.n)
    self.area:addGameObject('TickEffect',self.trail.x[n],self.trail.y[n],{trail = self.trail, n = n})
end




--- Лапы нужно сделать