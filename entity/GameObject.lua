GameObject = Object:extend()

function GameObject:new(area,x,y,opts) -- создание обьекта и добавление его в массив
    local opts = opts or {}
    if opts then for k,v in ipairs(opts) do self[k] = v end end
    self.area = area 
    self.x = x
    self.y = y
    self.id = UUID()
    self.dead = false
    self.timer = Timer()
end

function GameObject:update(dt)
    if self.timer then self.timer:update(dt)  end-- обновление всех
    if self.collider then self.x, self.y = self.collider:getPosition() end
end

function GameObject:draw()
end

function GameObject:destroy()
    self.dead = true
    self.timer:clear()
    if self.collider then self.collider:destroy() end
    self.collider = nil
end