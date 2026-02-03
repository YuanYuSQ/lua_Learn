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
    self.mode = mode or "fill"
    self.side = side or self.side
    self.x = x or 100
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
    self.t = Timer:new()
end

function CircleFadeRoom:update(dt)
    self.area:update(dt)
    self.t:update(dt)
end

function CircleFadeRoom:draw()
    self.area:draw()
end

function CircleFadeRoom:active()
    self:draw()
    self.area:active()
    print("Stage active")
    fade_every=self.t:every(0.005, function()
        self.area:addGameObject('CircleFade', { x = random(0, 800), y = random(0, 600) })
        self.area:addGameObject('CircleFade', { x = random(0, 800), y = random(0, 600) })
        self.area:addGameObject('CircleFade', { x = random(0, 800), y = random(0, 600) })
        self.area:addGameObject('CircleFade', { x = random(0, 800), y = random(0, 600) })
    end, 250)
    self.t:after(1, function()
        self.area:addGameObject("CircleFade",{x=wx / 2, y=wy / 2,  side = wx } )
    end)

    self.t:after(3, function()
        self.t:every(0.005,function ()
            self.area:addGameObject('CircleFade', { x = random(0, 800), y = random(0, 600) })
        self.area:addGameObject('CircleFade', { x = random(0, 800), y = random(0, 600) })
        self.area:addGameObject('CircleFade', { x = random(0, 800), y = random(0, 600) })
        self.area:addGameObject('CircleFade', { x = random(0, 800), y = random(0, 600) })
    end, 250)
        end)
     

    
end

function CircleFadeRoom:deactive()
   
    self.area:deactive()
    self.t:cancel(fade_every) 
    self.area.game_objects = {}
end

--随机矩形生成,按'd'删除单个矩形,循环生成10个
RectangleFade = class:extend()

function RectangleFade:new()
    input:bind("d", "del Rect")
    self.area = Area(self)
    self.t = Timer:new()
end

function RectangleFade:update(dt)
    self.area:update(dt)
    self.t:update(dt)

    while #self.area.game_objects == 0 do
        for i = 0, 9 do self.area:addGameObject("Rectangle") end
    end
    if input:pressed('del Rect') then
        table.remove(self.area.game_objects, love.math.random(1, #self.area.game_objects))
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
--在屏幕随机位置创建 10 个该类的实例，每个实例具有随机半径，且每个实例创建间隔 0.25 秒。
--在所有实例创建完成后（即 2.5 秒后），开始每隔[0.5, 1]秒（0.5 到 1 之间的随机数）删除一个随机实例。
--当所有实例都被删除后，重复整个创建 10 个实例并最终删除的过程。该过程应无限循环。
CircleRandom = class:extend()



function CircleRandom:new()
    wx = love.graphics.getWidth()
    wy = love.graphics.getHeight()
    self.t = Timer()
    self.area = Area(self)

    local function Loop()
        for i = 1, 10, 1 do
            self.t:after(0.25 * i, function()
                self.area:addGameObject("Circle_random_object", { wx = random(wx), wy = random(wy) })
            end)
        end
        self.t:after(2.5, function()
            Loop_every = self.t:every(random(0.5, 1), function()
                table.remove(self.area.game_objects, random(1, #self.area.game_objects))
                if #self.area.game_objects == 0 then
                    self.t:cancel(Loop_every)
                    Loop()
                end
            end)
        end)
    end

    Loop()



    function CircleRandom:update(dt)
        self.t:update(dt)
        self.area:update(dt)
    end
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

return { room = room, CircleFadeRoom = CircleFadeRoom, RectangleFade = RectangleFade, CircleRandom = CircleRandom }
