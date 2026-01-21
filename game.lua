class = require "libraries.classic.classic"

local room = class:extend() 
room.name = nil
room.type = nil
room.side=nil

function room:new(name, type, side)
    self.name = name or "default_room"
    self.type = type or "normal"
    self.side=side or 3
end

function room:update(dt)
    
end

function room:drawShape(mode,side, x, y)
    self.side=side or self.side
    love.graphics.setColor(1, 1, 1)
    if type(side)=="string" then
        side=side
    else
        side=tonumber(side)
         side=math.max(side,3)
    end
    -- 计算绘制中心：若未提供 x,y，则使用屏幕中心
    local cx = x
    local cy = y
    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()
    if not cx or not cy then
        cx = sw / 2
        cy = sh / 2
    end

    if type(side)~="string" and side<3 then
        return
    else
        if side==3 then
            -- 等腰三角形，宽高可调整
            local w, h = 100, 100
            local x1, y1 = cx, cy - h/2
            local x2, y2 = cx - w/2, cy + h/2
            local x3, y3 = cx + w/2, cy + h/2
            love.graphics.polygon(mode or "line", x1, y1, x2, y2, x3, y3)
        elseif side==4 then
            local w, h = 50, 50
            love.graphics.rectangle(mode or "line", cx - w/2, cy - h/2, w, h)
        end
    end
    if side=="circle" then
        local r = 50
        love.graphics.circle(mode or "line", cx, cy, r)
    end
end
local Text= class:extend()


return{room=room, Text=Text}

