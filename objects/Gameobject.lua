class = require "libraries.classic.classic"
Utils = require "objects.Utils"
GameObject = class:extend()

function GameObject:new(opts)
    if type(opts) == "table" then for k, v in pairs(opts) do self[k] = v end end
    self.id = uuid()
    self.dead = false
    self.t = Timer()
end

function GameObject:update(dt)
    if self.t then self.t:update(dt) end
end

function GameObject:draw()

end

CircleFade = GameObject:extend()
function CircleFade:new(opts)
    self.t = Timer()
    self.side=0
    CircleFade.super.new(self,opts)
     
    self:deadLoop()
end

--圆形生成参数
function CircleFade:deadLoop()
    
    if self.side == 0 then
        self.t:tween(random(1, 1.75), self, { side = random(20, 40) }, 'in-out-quad', function()
        self.t:after(0.45, function() 
            self.t:tween(2, self, { side = 0 }, 'in-out-quad', function()
               self.t:after(0.1, function() self.dead = true end)
            end)
       end)
    end)
else

    self.side = 0
    self.t:tween(3.8, self, { side = wx*1.2 }, 'in-out-quad', function()
       self.t:tween(0.9,self,{side = 0},'in-out-quad',function ()
            self.t:after(0.1, function() self.dead = true end)
        end)
             
    end)

    
end
end

function CircleFade:update(dt)
    CircleFade.super.update(self, dt)
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



Rectangle = GameObject:extend()

function Rectangle :new(opts)
    Rectangle.super.new(self    ,opts)
    self.sidex= random(self.sidex) or random(100)
    self.sidey=random(self.sidey) or random(100)
    self.x=random(wx)
    self.y=random(wy)
end 

function Rectangle:update()
    
end

function Rectangle:draw()
    love.graphics.rectangle("fill",self.x,self.y,self.sidex,self.sidey)
end



function random(min, max)
    if not max then -- if max is nil then it means only one value was passed in
        return love.math.random()*min
    else
        if min > max then min, max = max, min end
        return love.math.random()*(max - min) + min
    end
end





--用于在创建位置绘制一个具有特定半径的圆。
--在屏幕随机位置创建 10 个该类的实例，每个实例具有随机半径，且每个实例创建间隔 0.25 秒。
--在所有实例创建完成后（即 2.5 秒后），开始每隔[0.5, 1]秒（0.5 到 1 之间的随机数）删除一个随机实例。
--当所有实例都被删除后，重复整个创建 10 个实例并最终删除的过程。该过程应无限循环。
Circle_random_object= GameObject:extend()

function  Circle_random_object :new(opts)
    Circle_random_object.super.new(self,opts)
    self.r=self.r or random(100)
end

function Circle_random_object:update(dt)
    self.t:update(dt)
end

function Circle_random_object:draw()
    love.graphics.circle("fill", self.x,self.y,self.r)
end

return { GameObject = GameObject, CircleFade = CircleFade ,Rectangle=Rectangle , Circle_random_object =Circle_random_object}
