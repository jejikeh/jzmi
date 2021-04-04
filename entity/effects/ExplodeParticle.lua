ExplodeParticle = GameObject:extend()

function ExplodeParticle:new(area,x,y,opts) -- частицы взрыва
    ExplodeParticle.super.new(self,area,x,y,opts)
    self.trail = {} -- баг
    camera:shake(opts.s1,opts.s2,opts.s3)
    self.color = opts.color or default_color -- либо дэфолд либо задается так (...,{color = {x,x,x})
    self.r = random(0,2*math.pi)
    self.s = opts.s or random(2,3)
    self.v = opts.v or random(75,150)
    self.line_width = 2

    self.collider = self.area.world:newCircleCollider(self.x,self.y,self.s) -- колайдер
    self.collider:setObject(self)
    self.timer:tween(opts.d or random(0.3,0.5),self,{s = 0,v = 0,line_width = 5},'in-out-cubic',function() self.dead = true end)
end

function ExplodeParticle:update(dt)
    ExplodeParticle.super.update(self,dt)
    self.collider:setLinearVelocity(self.v * math.cos(self.r),self.v * math.sin(self.r))
end

function ExplodeParticle:draw()
    pushRotate(self.x,self.y,self.r)
    love.graphics.setLineWidth(self.line_width)
    love.graphics.setColor(self.color)
    love.graphics.line(self.x - self.s,self.y,self.x + self.s,self.y)
    love.graphics.setColor(1,1,1)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
end