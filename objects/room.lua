class = require "libraries.classic.classic"
Area = require "objects.Area".Area
local room = class:extend()
room.name = nil
room.type = nil
room.side = nil
room.areas = nil

-- args 是可变参数列表
function room:new(name, args)
    self.name = name or "default_room"


    if args then -- 可变参数赋值
        for index, value in pairs(args) do
            self[index] = value
        end
    end
end

function room:update(dt)

end

function room:draw()
 room:drawShape()
end

--- 激活房间
function room:active()
    print("Room " .. self.name .. " is now active.")
    self.active = true
end

--- 取消激活
function room:deactive()
    print("Room " .. self.name .. " is now deactive.")
    self.active = false
end

--测试用 绘制形状
function room:drawShape(mode, side, x, y)
    self.mode=mode or "fill"
    self.side = side or self.side
    self.x =x or 100
    self.y = y or 100

    if not self.side then
        return
    end
    love.graphics.setColor(1, 1, 1)
    if type(side) == "string" then
        side = side
    else
        side = tonumber(side)
        side = math.max(side, 3)
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

    if type(side) ~= "string" and side < 3 then
        return
    else
        if side == 3 then
            -- 等腰三角形，宽高可调整
            local w, h = 100, 100
            local x1, y1 = cx, cy - h / 2
            local x2, y2 = cx - w / 2, cy + h / 2
            local x3, y3 = cx + w / 2, cy + h / 2
            love.graphics.polygon(mode or "line", x1, y1, x2, y2, x3, y3)
        elseif side == 4 then
            local w, h = 50, 50
            love.graphics.rectangle(self.mode or "line", cx - w / 2, cy - h / 2, w, h)
        end
    end
    if side == "circle" then
        local r = 50
        love.graphics.circle(self.mode or "line", cx, cy, r)
    end
end

CircleFadeRoom = class:extend()

function CircleFadeRoom:new()
    self.area = Area(self)
    self.timer = Timer()
end

function CircleFadeRoom:update(dt)
    self.area:update(dt)
    self.timer:update(dt)
end

function CircleFadeRoom:draw()
    self.area:draw()
end

function CircleFadeRoom:active()
    self:draw()
    self.area:active()
    print("Stage active")
    self.timer:every(0.005, function()
        self.area:addGameObject('CircleFade', random(0, 800), random(0, 600))
        self.area:addGameObject('CircleFade', random(0, 800), random(0, 600))
        self.area:addGameObject('CircleFade', random(0, 800), random(0, 600))
        self.area:addGameObject('CircleFade', random(0, 800), random(0, 600))
    end, 1000)



    self.timer:after(0.7, function()
        self.area:addGameObject("CircleFade", wx / 2, wy / 2, { side = wx })
    end)
end

function CircleFadeRoom:deactive()
    self.area:deactive()
    self.area.game_objects = {}
end



--随机矩形生成,按'd'删除单个矩形,循环生成10个
RectangleFade = class:extend()

function RectangleFade:new()
    input:bind("d", "del Rect")
    self.area = Area(self)
    self.timer = Timer()
end

function RectangleFade:update(dt)
    self.area:update(dt)
    self.timer:update(dt)

    while #self.area.game_objects == 0 do
        for i = 0, 9 do self.area:addGameObject("Rectangle") end
    end
    if input:pressed('del Rect') then
        table.remove(self.area.game_objects, love.math.random(1, #self.are.game_objects))
    end
end

function RectangleFade:draw()
    self.area:draw()
end

function RectangleFade:active()
    self.area:active()
end

function RectangleFade:deactive()
    self.area:deactive()
end




--随机循环圆形生成
CircleRandom = class:extend()

function CircleRandom:new()
       wx = love.graphics.getWidth()
    wy = love.graphics.getHeight()
    self.timer = Timer()
    self.area = Area(self)
end
function CircleRandom:update(dt)
    timer:update(dt)
    self.area:update(dt)
    self.area:addGameObject('CircleFade',random(wx),random(wy))
end

function CircleRandom:draw()
    self.area:draw()
end

function CircleRandom:active()
    self.area:active()
end

function CircleRandom:deactive()
    self.area:deactive()
end


function random(min, max)
    if min == nil then return nil end
    if max == nil then -- if max is nil then it means only one value was passed in
        return love.math.random() * min
    else
        if min > max then min, max = max, min end
        return love.math.random() * (max - min) + min
    end
end

return { room = room, CircleFadeRoom = CircleFadeRoom, RectangleFade = RectangleFade }
