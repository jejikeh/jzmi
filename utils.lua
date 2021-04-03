function UUID()
    local fn = function(x)
        local r = love.math.random(16) - 1
        r = (x == "x") and (r+1) or (r%4) + 9
        return ("0123456789abcdef"):sub(r,r)
    end
    return(("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]",fn))
end

function getAngle(x1,y1,x2,y2) 
    return math.atan2(x2-x1,y2-y1) -- угол между двумя точками просто тангенс ( катет на катет)
end

function random(min,max)
    local min, max = min or 0, max or 1
    return (min > max and (love.math.random()*(min - max) + max)) or (love.math.random()*(max - min) + min)
end

function pushRotate(x,y,r) -- функция для вращения(просто удобнее)
    love.graphics.push()
    love.graphics.translate(x,y)
    love.graphics.rotate(r or 0)
    love.graphics.translate(-x,-y)
end

function pushRotateScale(x,y,r,sx,sy) -- тоже самое только еще и с маштабом
    love.graphics.push()
    love.graphics.translate(x,y)
    love.graphics.rotate(r or 0)
    love.graphics.scale(sx or 1,sy or sx or 1)
    love.graphics.translate(-x,-y)
end

function count_all(f)
    local seen = {}
    local count_table
    count_table = function(t)
        if seen[t] then return end
            f(t)
	    seen[t] = true
	    for k,v in pairs(t) do
	        if type(v) == "table" then
		    count_table(v)
	        elseif type(v) == "userdata" then
		    f(v)
	        end
	end
    end
    count_table(_G)
end

function type_count()
    local counts = {}
    local enumerate = function (o)
        local t = type_name(o)
        counts[t] = (counts[t] or 0) + 1
    end
    count_all(enumerate)
    return counts
end

global_type_table = nil
function type_name(o)
    if global_type_table == nil then
        global_type_table = {}
            for k,v in pairs(_G) do
	        global_type_table[v] = k
	    end
	global_type_table[0] = "table"
    end
    return global_type_table[getmetatable(o) or 0] or "Unknown"
end