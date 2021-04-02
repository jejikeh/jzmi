Stage = Object:extend()

function Stage:new()

    self.area = Area(self) -- область в которой будут обьекты
    self.area:addPhysicsWorld() -- добавление физики
    self.timer = Timer()
    self.main_canvas = love.graphics.newCanvas(gw, gh) -- слой с графикой 
    self.player = self.area:addGameObject("Player",gw/2,gh/2) -- теперь эта область имеет переменну игрока
    --input:bind("k",function() self.player:destroy() end) -- умри 
    --randomMusicPlay()
end

function Stage:destroy()
    soundStop()
    self.area:destroy()
    self.area = nil
end

function Stage:update(dt)


    self.area:update(dt)
    self.timer:update(dt)
    local dx,dy = self.player.x - camera.x + gw/2 /camera.scale,self.player.y - camera.y  + gh/2/ camera.scale
    camera:move(dx/0.5*dt,dy/0.5*dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.main_canvas) -- вся графика рендерится на этом слое
    love.graphics.clear()
    love.graphics.print(self.player.trail.n)
        camera:attach(0,0,w,h)
        self.area:draw()
        --love.graphics.circle("line",gw/2,gh/2,50)
        camera:detach()
    love.graphics.setCanvas()

    love.graphics.setColor(1,1,1,1)
    love.graphics.setBlendMode('alpha','premultiplied')
    love.graphics.draw(self.main_canvas,0,0,0,sy,sx)
    love.graphics.setBlendMode('alpha')
end

--return Stage