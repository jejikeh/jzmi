Trail = GameObject:extend()

function Trail:new(area,x,y,player,opts)
    Trail.super.new(self,area,x,y,opts)
    self.x,self.y = x,y
    self.player = player
    self.h = opts.h or 8
    self.color = opts.color or default_color
    self.model = opts.model or "shell"
    self.collider = self.area.world:newCircleCollider(self.x,self.y,self.h)
    self.collider:setCollisionClass("Trail")
    self.collider:setObject(self)
    --self.collider:setFixedRotation(false)
    self.v = 100
    self.collider:setLinearVelocity(self.v * math.cos(self.player.r),self.v * math.sin(self.player.r))
    self.collider:applyAngularImpulse(random(-50,50))
    
end

function Trail.update(dt)
    Trail.super.update(self,dt)
    local target = current_room.player
    if target then 
        self.v = target.base_max_v
        local projectile_heading = Vector(self.collider:getLinearVelocity()):normalized()
        local angle = math.atan2(target.y - self.y,target.x - self.x)
        local to_target_heading = Vector(math.cos(angle),math.sin(angle)):normalized()
        local final_heading = (projectile_heading + 0.1 * to_target_heading):normalized()
        self.collider:setLinearVelocity(self.v * final_heading.x,self.v * final_heading.y)
    else
        self.collider:setLinearVelocity(self.v * math.cos(self.r),self.v * math.sin(self.r))
    end
end

function Trail.draw()
    love.graphics.setColor(self.color)
    pushRotate(self.x,self.y,self.collider:getAngle())
    love.graphics.circle("line",self.x,self.y,self.h)
    love.graphics.pop()
    love.graphics.setColor(default_color)
end