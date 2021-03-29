Projectile = GameObject:extend()

function Projectile:new(area,x,y,r,s,v,opts)
    Projectile.super.new(self,area,x,y,opts)
    self.s = 4
    self.v = 50
    self.trail = {}
    self.r = r 
    self.timer:tween(0.5,self,{s=0},'in-out-cubic',function() self.dead = true end)

    self.collider = self.area.world:newCircleCollider(self.x,self.y,self.s)
    self.collider:setObject(self)
    self.collider:setLinearVelocity(self.v * math.cos(self.r),self.v * math.sin(self.r))
end

function Projectile:update(dt)
    Projectile.super.update(self,dt)
    self.collider:setLinearVelocity(self.v * math.cos(self.r),self.v * math.sin(self.r))
end

function Projectile:draw()
    love.graphics.setColor(0,1,0)
    love.graphics.circle('line',self.x,self.y,self.s)
end