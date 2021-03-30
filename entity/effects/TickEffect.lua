TickEffect = GameObject:extend()

function TickEffect:new(area,x,y,opts)
    TickEffect.super.new(self,area,x,y,opts)
    self.trail = {}
    self.y_offset = 0
    self.n = opts.n
    self.w,self.h = 32,14
    self.parent = opts.parent or nil
    self.trails = opts.trail or nil
    self.timer:tween(0.13,self,{h=0,y_offset = 42},'in-out-cubic',function() self.dead = true end)
end

function TickEffect:update(dt)
    TickEffect.super.update(self,dt)
    if self.parent then self.x,self.y = self.parent.x- self.parent.w/2,self.parent.y + 10 - self.y_offset - self.parent.w/2 end
    if self.trails then self.x,self.y = self.trails.x[self.n] - self.w/2,self.trails.y[self.n] + 10 - self.y_offset - self.w/2 end
end

function TickEffect:draw()
    love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end