DnaPoint = GameObject:extend()

function DnaPoint:new(area,x,y,opts)
    DnaPoint.super.new(self,area,x,y,opts)
    self.x,self.y = x,y
    self.radius = 8
    self.trail = {}
    self.all_colors = all_colors
    self.collider  = self.area.world:newCircleCollider(self.x,self.y,self.radius)
    self.collider:setCollisionClass("Collectable")
    self.collider:setObject(self)
    self.collider:setFixedRotation(false)
    self.color = dp_color
    self.background_color = default_color
    self.r = random(0,2*math.pi)
    self.v = 100
    self.collider:setLinearVelocity(self.v * math.cos(self.r),self.v * math.sin(self.r))
    self.collider:applyAngularImpulse(random(-50,50))

    self.timer:every(0.1 ,function()
    
        if love.math.random(1,4) <= 1 then
            --self.color = self.all_colors[love.math.random(1,#self.all_colors)]
            self.background_color = dp_color
        else
            self.background_color = nil
            self.color = dp_color
        end
    
    end)

end

function DnaPoint:die()
    self.dead = true
    self.area:addGameObject("InfoText",self.x,self.y,{text = "+1 DP",color = self.color})
    self.area:addGameObject("bioMaterialEffect",self.x,self.y,{color = self.color,w = self.radius,h = self.radius})
    for i = 1, love.math.random( 4,9 ) do
        self.area:addGameObject('ExplodeParticle',self.x,self.y,{s=1,color = self.color,s1 = 1,s2 = 0.1,s3 = 1})
    end
end

function DnaPoint:update(dt)
    DnaPoint.super.update(self,dt)
    self.collider:setLinearVelocity(self.v * math.cos(self.r),self.v * math.sin(self.r))
end

function DnaPoint:draw()
    love.graphics.setColor(self.color)
    pushRotate(self.x,self.y,self.collider:getAngle())
    draft:lozenge(self.x,self.y,self.radius-random(0,8),"line")
    --draft:lozenge(self.x,self.y,self.radius+random(0,1),"line")

    --draft:lozenge(self.x,self.y,self.radius-random(1,4),"line")
    draft:rhombus(self.x,self.y,self.radius + random(-5,5),self.radius + random(-2,2),'line')
    if self.background_color then
        love.graphics.setColor(self.background_color)
        draft:rhombus(self.x,self.y,self.radius,self.radius,"fill")
    end
    love.graphics.pop()
    love.graphics.setColor(default_color)
end