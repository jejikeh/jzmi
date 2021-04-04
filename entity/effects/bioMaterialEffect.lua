bioMaterialEffect = GameObject:extend()

function bioMaterialEffect:new(area,x,y,opts)
    bioMaterial.super.new(self,x,y,opts)
    self.x,self.y = x,y
    self.trail = {}
    self.color = default_color
    self.w,self.h = opts.w,opts.h
    self.timer:after(0.1,function() 
        self.color = opts.color
        self.timer:tween(0.2,self,{w=self.w * 1.5},"in-out-cubic",function() return end)
        self.timer:tween(0.25,self,{h=self.h * 1.5},"in-out-cubic",function() return end)
        self.timer:after(0.3, function()
            self.dead = true
        end)
    end)
end

function bioMaterialEffect:update(dt)
    bioMaterialEffect.super.update(self,dt)
end

function bioMaterialEffect:draw()
    love.graphics.setColor(self.color)
    draft:rhombus(self.x,self.y,self.w+ random(-10,10),self.h+ random(-10,10),"fill")
    love.graphics.setColor(default_color)
end

function bioMaterialEffect:destroy()
    bioMaterialEffect.super.destroy(self)
end