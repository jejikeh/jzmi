Projectile = GameObject:extend()

function Projectile:new(area,x,y,r,s,v,opts)
    Projectile.super.new(self,area,x,y,opts)
    self.s = 4
    self.v = 50
    self.trail = {}
    self.r = r 
    --self.color = {random(0,1),random(0,1),random(0,1)}
    self.color = {0,1,0}
    self.timer:tween(0.5,self,{s=0},'in-out-cubic',function() self.dead = true end)

    self.collider = self.area.world:newCircleCollider(self.x,self.y,self.s)
    self.collider:setObject(self)
    self.collider:setLinearVelocity(self.v * math.cos(self.r),self.v * math.sin(self.r))
end

function Projectile:update(dt)
    Projectile.super.update(self,dt)
    self.collider:setLinearVelocity(self.v * math.cos(self.r),self.v * math.sin(self.r))

    if self.x < camera.x - gw / camera.scale then self:die() end
    if self.x > camera.x then self:die() end
    if self.y < camera.y - gh / camera.scale then self:die() end
    if self.y > camera.y  then self:die() end
end

function Projectile:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle('line',self.x,self.y,self.s)
end

function Projectile:die()
    self.dead = true
    self.area:addGameObject('ProjectileDeathEffect',self.x,self.y,2*self.s)
end