InfoText = GameObject:extend()

function InfoText:new(area,x,y,opts)
    InfoText.super.new(self,area,x,y,opts)
    self.x,self.y = x,y
    self.color = opts.color or default_color
    self.background_colors = {}
    self.foreground_colors = {}
    self.text = opts.text
    self.font = fonts.monogramSize16
    self.w, self.h = self.font:getWidth(self.text), self.font:getHeight()
    self.characters = {}
    for i = 1, #self.text do table.insert(self.characters,self.text:utf8sub(i,i)) end
    self.all_colors = all_colors
    self.visible = true
    self.timer:after(0.3,function()
        self.timer:every(0.01,function()
            local random_characters = '0123456789!@#$%¨&*()-=+[]^~/;?><.,|abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYXZ'
            for i,character in ipairs(self.characters) do
                if love.math.random(1,3) <= 1 then
                    local r = love.math.random(1, #self.characters)
                    self.characters[i] = random_characters:utf8sub(r,r)
                    self.background_colors[i] = self.all_colors[love.math.random(1,#self.all_colors)]
                else
                    self.characters[i] = character
                    self.background_colors[i] = nil
                end

                if love.math.random(1,10) <= 2 then
                    self.foreground_colors[i] = self.all_colors[love.math.random(1,#self.all_colors)]
                else
                    self.background_colors[i] = nil
                end
            end
        end)
        self.timer:every(0.1,function() self.visible = not self.visible end,10)
        self.timer:after(0.1,function() self.visible = true end)
    end)
    self.timer:after(1,function() self.dead = true end)
end

function InfoText:update(dt)
    InfoText.super.update(self,dt)
end

function InfoText:draw()
    if not self.visible then return end
    love.graphics.setFont(self.font)
    for i = 1, #self.characters do
        local width = 0
        if i > 1 then
            for j = 1, i-1 do 
                width = width + self.font:getWidth(self.characters[j])
            end
        end

        if self.background_colors[i] then
            love.graphics.setColor(self.background_colors[i])
            love.graphics.rectangle('fill',self.x+width,self.y - self.font:getHeight()/2,self.font:getWidth(self.characters[i]),self.font:getHeight())
        end
        love.graphics.setColor(self.foreground_colors[i] or self.color or default_color)
        love.graphics.print(self.characters[i],self.x + width + random(-0.5,0.5),self.y + random(-0.5,0.5),random(-0.1,0.1),random(1,1.1),random(1,1.1),0,self.font:getHeight()/2)
    end
    love.graphics.setColor(default_color)
end