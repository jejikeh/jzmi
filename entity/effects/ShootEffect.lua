ShootEffect = GameObject:extend()

function ShootEffect:new(area,x,y,player,d,opts) -- сияние при выстреле
    ShootEffect.super.new(self,area,x,y,opts)
    self.player = player
    self.d = d
    self.trail = {}
    self.depth = 75
    self.w = 8
    self.timer:tween(0.5,self,{w=-4},'in-out-cubic',function() self.dead = true end) -- умирает за 05 секунд и уменьшается 
    --[[
        0.5 это время
        w = -8 это self.w и его конечно значение
        'in-out-cubic' это способ изменения значения self.w
        self.dead по истечени. 0.5 секунд обьект стирается из памти
    ]]--
end

function ShootEffect:draw()
    pushRotate(self.x,self.y,self.player.r + math.pi/4) -- поворот вокруг круга получается(потом можно убрать так как будет крутится сам игрок)
    love.graphics.setColor(1,0,1) -- цвет
    love.graphics.rectangle("line",self.x - self.w/2, self.y - self.w/2,self.w,self.w) -- сам квадратик
    love.graphics.pop()
end

function pushRotate(x,y,r) -- функция для вращения(просто удобнее)
    love.graphics.push()
    love.graphics.translate(x,y)
    love.graphics.rotate(r or 0)
    love.graphics.translate(-x,-y)
end

function pushRotateScale(x,y,r,sx,sy) -- тоже самое только еще и с маштабом
    love.graphics.push()
    love.graphics.translate(x,y)
    love.graphics.rotate(r or 0)
    love.graphics.scale(sx or 1,sy or sx or 1)
    love.graphics.translate(-x,-y)
end

function ShootEffect:update(dt)
    ShootEffect.super.update(self,dt)
    if self.player then 
        self.x = self.player.x + 1.1*self.player.w* math.cos( self.player.r ) -- тут находится координата радиуса круга по X
        self.y = self.player.y + 1.1*self.player.w * math.sin( self.player.r ) -- по Y
    end
end