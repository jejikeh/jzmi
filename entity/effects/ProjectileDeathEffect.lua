ProjectileDeathEffect = GameObject:extend() -- смэрт частиц

function ProjectileDeathEffect:new(area,x,y,w,opts)
    ProjectileDeathEffect.super.new(self,area,x,y,opts)
    self.w = w
    self.trail = {} -- баг 
    self.firts = true -- значала впышка цветом белым
    self.timer:after(0.15,function()
        self.first = false
        self.second = true
        self.timer:after(0.15,function() -- потом цвета смерти
            self.second = false
            camera:shake(1,0.1,25)
            self.dead = true
        end)
    end)
end

function ProjectileDeathEffect:draw()
    if self.first then love.graphics.setColor(default_color) -- меняется цвет в зависимости от стадии
    elseif self.second then love.graphics.setColor(hp_color) end
    love.graphics.rectangle('fill',self.x - self.w/2,self.y - self.w/2,self.w,self.w) -- рисуется на месте стоклновения с экраном
end