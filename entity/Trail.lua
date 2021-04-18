Trail = GameObject:extend()

function Trail:new(area,x,y,player,opts)
    Trail.super.new(self,area,x,y,opts)
    self.x,self.y = x,y
    self.player = player
    self.h = self.player.h
    self.color = self.player.color or default_color
    self.trail = {}
    self.v = 100
    self.collider = self.area.world:newCircleCollider(self.x,self.y,self.h)
    self.collider:setCollisionClass("Trail")
    self.collider:setObject(self)
    self.collider:setFixedRotation(false)
    --self.collider:setLinearVelocity(self.v * math.cos(self.player.r),self.v * math.sin(self.player.r))
end

function Trail:update(dt)
    Trail.super.update(self,dt)
    self.collider:setLinearVelocity(self.v * (self.player.x - self.x)/25,self.v * (self.player.y - self.y)/25)
end

function Trail:draw()
    love.graphics.setColor(self.color)
    pushRotate(self.x,self.y,-getAngle(self.player.x,self.player.y,self.x,self.y    ) - math.rad(90) )
    love.graphics.rectangle("line",self.x,self.y,self.h,self.h)
    love.graphics.pop()
    love.graphics.setColor(default_color)
end