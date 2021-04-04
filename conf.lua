gw = 480
gh = 270
sx = 2
sy = 2

function love.conf(t)
    t.identity = nil
    t.console = true

    t.window.title = "Gay"
    t.window.icon = nil
    t.window.height = gh
    t.window.width = gw
    t.window.borderless = false
    t.window.resizable = false
    t.window.minwidth = 1
    t.window.minheight = 1  
    t.window.fullscreen = true
    t.window.fullscreentype = "desktop" 
    t.window.vsync = true
    t.window.fsaa = 0
    t.window.display = 1
    t.window.highdpi = true
    t.window.srgb = false
    t.window.x = nil
    t.window.y = nil

    t.modules.audio = true 
    t.modules.event = true           
    t.modules.graphics = true       
    t.modules.image = true          
    t.modules.joystick = true
    t.modules.keyboard = true      
    t.modules.math = true          
    t.modules.mouse = true          
    t.modules.physics = true
    t.modules.sound = true 
    t.modules.system = true      
    t.modules.timer = true             
    t.modules.window = true            
    t.modules.thread = true  
end