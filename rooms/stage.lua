Stage = Object:extend()

function Stage:new()

    self.area = Area(self) -- область в которой будут обьекты
    self.area:addPhysicsWorld() -- добавление физики
    self.area.world:addCollisionClass("Player")
    self.area.world:addCollisionClass("Projectile",{ignores = {'Projectile'}})
    self.area.world:addCollisionClass("Collectable",{ignores = {'Projectile'}})
    self.area.world:addCollisionClass("Trail",{ignores = {"Projectile"}})



    self.timer = Timer()
    self.main_canvas = love.graphics.newCanvas(gw, gh) -- слой с графикой 
    self.player = self.area:addGameObject("Player",gw/2,gh/2) -- теперь эта область имеет переменну игрока
    --self.trail = self.area:addGameObject("Trail",self.player.x,self.player.y,self.player)
    input:bind("p",function() 
        self.area:addGameObject("DnaPoint",random(camera.x - gw,camera.x),random(camera.y- gh,camera.y),self.player) 
        
        self.area:addGameObject("bioMaterial",random(camera.x - gw,camera.x),random(camera.y- gh,camera.y),self.player) 
    end) -- умри 
    randomMusicPlay()
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
    --love.graphics.print(self.player.trail.n)
    love.graphics.print("fps: "..tostring(love.timer.getFPS( )), 0, 0)
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