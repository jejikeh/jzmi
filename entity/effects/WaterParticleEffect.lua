-- добавть коммиты

WaterParticleEffect = GameObject:extend()

function WaterParticleEffect:new(area,x,y,opts)
    WaterParticleEffect.super.new(self,area,x,y,opts)
    self.trail = {}
    self.r = 0
    self.color = opts.color
    self.t= opts.parent.r
    self.v = 60
    self.timer:tween(0.5,self,{r=2},"in-out-cubic",function() 
        self.timer:tween(0.5,self,{r=0},"in-out-cubic",function() self.dead = true end)
    end)

    --self.collider = self.area.world:newCircleCollider(self.x,self.y,self.r)
    --self.collider:setObject(self)
    --self.collider:setLinearVelocity(self.v * math.cos(self.t),self.v * math.sin(self.t))
end

function WaterParticleEffect:update(dt)
    WaterParticleEffect.super.update(self,dt)
    --self.collider:setLinearVelocity(self.v * -1 * math.cos(self.t),self.v* -1  * math.sin(self.t))
end

function WaterParticleEffect:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("line",self.x,self.y,self.r)
    love.graphics.setColor(1,1,1)
end