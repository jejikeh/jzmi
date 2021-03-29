Player = GameObject:extend() -- протсто как тип обьекта

function Player:new(area,x,y,otps)
    Player.super.new(self,area,x,y,opts)
    self.area = area
    self.x,self.y =x,y
    self.w,self.h = 16,16
    self.collider = self.area.world:newCircleCollider(self.x,self.y,self.w) -- создание колайдера
    self.trail = {}
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
    -- матеша
    self.r = -math.pi /2
    self.rv = 1.66*math.pi
    self.v = 0
    self.max_v = 100
    self.a = 100

end

function Player:shoot(x,y)
    local d = 1.2*self.w
    self.area:addGameObject('ShootEffect',x+ d*math.cos(self.r),y + d * math.sin(self.r),self,self.d) -- на линии огня эффект
    self.area:addGameObject('Projectile',x+ 1.5 * d * math.cos(self.r),y + 1.5 * d * math.sin(self.r),self.r)
    --self.area:addGameObject('Projectile',x+ 1.5 * d * math.cos(self.r),y + 1.5 * d * math.sin(self.r),self.r+0.5)
    --self.area:addGameObject('Projectile',x+ 1.5 * d * math.cos(self.r),y + 1.5 * d * math.sin(self.r),self.r-0.5)
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
    if input:down('shoot') then self:shoot(self.x,self.y) end
    if input:down('left') then self.r = self.r - self.rv * dt end
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

function Player:destoy()
    Player.super.destroy(self)
end




--- Лапы нужно сделать