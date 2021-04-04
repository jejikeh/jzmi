bioMaterial = GameObject:extend()

function bioMaterial:new(area,x,y,player,opts)
    bioMaterial.super.new(self,area,x,y,player,opts)
    self.player = player
    self.x,self.y = x,y
    self.w,self.h = 8,8
    self.polligons = {}

    self.trail = {}
    self.collider = self.area.world:newRectangleCollider(self.x,self.y,self.w,self.h)
    self.collider:setCollisionClass("Collectable")
    self.collider:setObject(self)
    self.collider:setFixedRotation(false)
    self.r = random(0,2*math.pi)
    self.color = bio_material_color
    self.timer:every(0.1,function()
        self.color = default_color
        self.timer:after(0.1,function() 
            self.color = bio_material_color
        end)
    end)
    self.v = 100
    self.collider:setLinearVelocity(self.v * math.cos(self.player.r),self.v * math.sin(self.player.r))
    self.collider:applyAngularImpulse(random(-50,50))
end

function bioMaterial:update(dt)
    bioMaterial.super.update(self,dt)
    local target = current_room.player
    if target then
        self.v = target.base_max_v * 1.3
        local projectile_heading = Vector(self.collider:getLinearVelocity()):normalized()
        local angle = math.atan2(target.y - self.y,target.x - self.x)
        local to_target_heading = Vector(math.cos(angle),math.sin(angle)):normalized()
        local final_heading = (projectile_heading + 0.1 * to_target_heading):normalized()
        self.collider:setLinearVelocity(self.v * final_heading.x,self.v * final_heading.y)
    else self.collider:setLinearVelocity(self.v * math.cos(self.r),self.v * math.sin(self.r)) end
end

function bioMaterial:die()
    self.dead = true
    self.area:addGameObject("InfoText",self.x,self.y,{text = "+1 BM",color = self.color})
    self.area:addGameObject("bioMaterialEffect",self.x,self.y,{color = bio_material_color,w = self.w,h = self.h})
    for i = 1, love.math.random( 4,9 ) do
        self.area:addGameObject('ExplodeParticle',self.x,self.y,{s=1,color = bio_material_color,s1 = 1,s2 = 0.1,s3 = 1})
    end
end

function bioMaterial:draw()
    love.graphics.setColor(self.color)
    pushRotate(self.x,self.y,self.collider:getAngle())
    draft:rhombus(self.x,self.y,self.w+ random(-2,2),self.h + random(-2,2),'fill')
    love.graphics.pop()
    love.graphics.setColor(default_color)
end