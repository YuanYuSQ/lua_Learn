class = require "libraries.classic.classic"
Utils = require "objects.Utils"
GameObject = class:extend()

function GameObject:new(area, x, y, opts)

    if type(opts) == "table" then for k, v in pairs(opts) do self[k] = v end end

    self.area = area
    self.x, self.y = x, y
    self.id = uuid()
    self.dead = false
    self.timer = Timer()
end

function GameObject:update(dt)
    if self.timer then self.timer:update(dt) end
end

function GameObject:draw()

end

CircleFade = GameObject:extend()
function CircleFade:new(area, x, y, opts)
    wx = love.graphics.getWidth()
    wy = love.graphics.getHeight()
    self.side = 0
    self.timer = Timer:new()

    CircleFade.super.new(self, area, x, y, opts)
    self:deadLoop()

    
end

--圆形生成参数
function CircleFade:deadLoop()
    if self.side == 0 then
        timer:tween(random(1, 2.5), self, { side = random(20, 35) }, 'in-out-quad', function()
        timer:after(0.45, function() 
            timer:tween(2, self, { side = 0 }, 'in-out-quad', function()
               timer:after(0.1, function() self.dead = true end)
            end)
       end)
    end)
else
    self.side = 0
    timer:tween(5, self, { side = wx*1.2 }, 'in-out-quad', function()
        timer:tween(0.9,self,{side = 0},'in-out-quad',function ()
            timer:after(0.1, function() self.dead = true end)
        end)
             
    end)

    
end
end

function CircleFade:update(dt)
    CircleFade.super.update(self, dt)
    self.timer:update(dt)
end

function CircleFade:draw()
    love.graphics.circle("fill", self.x, self.y, self.side)
end

-- 居中绘制矩形的通用函数
-- mode: 绘制模式（"fill" 填充 / "line" 描边）
-- cx, cy: 中心点坐标
-- w, h: 宽高
-- angle: 可选，旋转角度（弧度），默认0
function drawCenteredRect(mode, cx, cy, w, h, angle)
    angle = angle or 0              -- 默认不旋转
    love.graphics.push()
    love.graphics.translate(cx, cy) -- 移到中心点
    love.graphics.rotate(angle)     -- 可选旋转
    love.graphics.rectangle(mode, -w / 2, -h / 2, w, h)
    love.graphics.pop()
end

return { GameObject = GameObject, CircleFade = CircleFade }
