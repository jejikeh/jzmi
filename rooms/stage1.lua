Stage1 = Object:extend()

function Stage1:new()
    self.area = Area(self) -- область в которой будут обьекты
    self.area:addPhysicsWorld() -- добавление физики

    self.main_canvas = love.graphics.newCanvas(gw, gh) -- слой с графикой 
    self.timer = Timer()
    self.player = self.area:addGameObject("Player",random(0,gw),random(0,gh)) -- теперь эта область имеет переменну игрока
    input:bind("k",function() self.player:destroy() end) -- умри 
end

function Stage1:destroy()
    self.area:destroy()
    self.area = nil
end

function Stage1:update(dt)

    local dx,dy = self.player.x - camera.x + gw/2 /camera.scale,self.player.y - camera.y  + gh/2/ camera.scale
    camera:move(dx/1*dt,dy/1*dt)
    self.area:update(dt)
    self.timer:update(dt)
end

function Stage1:draw()
    love.graphics.setCanvas(self.main_canvas) -- вся графика рендерится на этом слое
    love.graphics.clear()
        camera:attach(0,0,w,h)
        self.area:draw()
        --love.graphics.circle("line",gw/2,gh/2,50)
        camera:detach()
    love.graphics.setCanvas()

    love.graphics.setColor(225,225,225,225)
    love.graphics.setBlendMode('alpha','premultiplied')
    love.graphics.draw(self.main_canvas,0,0,0,sx,sy)
    love.graphics.setBlendMode('alpha')
end

--return Stage1