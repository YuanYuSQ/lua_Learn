class = require "libraries.classic.classic"

-- 创建类
trackFade = class:extend() --创建一个跟着鼠标的同心圆

function trackFade:new()

end

function trackFade:update(dt)
    trackFade.px = love.mouse.getX()
    trackFade.py = love.mouse.getY()
end

function trackFade:new()
    self.px = love.mouse.getX()
    self.py = love.mouse.getY()
    self.followSpeed = 8
end

function trackFade:update(dt)
    local mx = love.mouse.getX()
    local my = love.mouse.getY()
    local s = self.followSpeed or 8
    self.px = self.px + (mx - self.px) * s * dt
    self.py = self.py + (my - self.py) * s * dt
end

function trackFade:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.px, self.py, 50)
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("line", self.px, self.py, 70, 25, 15)
end

--血量条类  由两个矩形组成  一个是背景矩形  一个是血量矩形
local HpRect = class:extend()

function HpRect:new(rectsidemax, maxhp, minhp, pos, hpcolor, bkcolor, speed)
    self.maxhp = maxhp or 100
    self.minhp = minhp or 0
    self.currenthp = self.maxhp
    self.rectsidemax = rectsidemax or { x = 200, y = 35 } --初始血量矩形大小,便于计算血量比例
    --后续改用color类来表示颜色
    self.hpcolor = hpcolor or { 255 / 255, 89 / 255, 89 / 255 }
    self.bkcolor = bkcolor or { 226 / 255, 37 / 255, 50 / 255 }
    self.bkrectside = self.rectsidemax --背景矩形大小
    self.rectside = rectsidemax or { x = 200, y = 35 }
    self.pos = pos or { x = 100, y = 100 }
    self.speed = speed or 3                                          --血量动画速度
    self.faderectside = { x = self.rectside.x, y = self.rectside.y } --缓冲血量
end

--扣血实现,在main.lua中调用,例如：hpRect:hurt(10) 表示扣10点血
function HpRect:hurt(damage)
    if self.currenthp > self.minhp and self.rectside.x > 0 then
        self.currenthp = math.max(self.currenthp - damage, self.minhp)
        self.faderectside.x = (self.currenthp / self.maxhp) * self.rectsidemax.x
        -- 确保目标宽度不为负数
        self.faderectside.x = math.max(self.faderectside.x, 0)

        if self.faderectside.x > 0 then
            timer:tween(0.1 * self.speed, self, { rectside = { x = self.faderectside.x } }, 'in-linear', function()
                -- tween 完成后再次强制非负，防止多次快速调用产生负值
                self.rectside.x = math.max((self.rectside.x or 0), 0)
                timer:tween(0.1 * self.speed, self, { bkrectside = { x = self.rectside.x } }, 'in-quad', function()
                    self.bkrectside.x = math.max((self.bkrectside.x or 0), 0)
                end)
            end)
        else
            self.rectside.x = 0
            self.bkrectside.x = 0
        end
    end
end

function HpRect:draw(x, y)
    if x == nil and y == nil then
        love.graphics.setColor(self.bkcolor)
        love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - self.pos.x,
            love.graphics.getHeight() / 2 - self.bkrectside.y / 2, self.bkrectside.x, self.bkrectside.y)                                                                   --HP背景
        love.graphics.setColor(self.hpcolor)
        love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - self.pos.x,
            love.graphics.getHeight() / 2 - self.rectside.y / 2, self.rectside.x, self.rectside.y)                                                                         --血量
    else
        love.graphics.setColor(self.bkcolor)
        love.graphics.rectangle("fill", x, y, self.bkrectside.x, self.bkrectside.y) --HP背景
        love.graphics.setColor(self.hpcolor)
        love.graphics.rectangle("fill", x, y, self.rectside.x, self.rectside.y)     --血量
    end
end

local playHpRect = HpRect:extend()
function playHpRect:new(rectsidemax, pos)
    self.rectsidemax = rectsidemax or { x = 100, y = 15 }
    self.pos = pos or { x = 100, y = 100 }
    playHpRect.super.new(self, rectsidemax, 100, 0, pos, nil, nil, 5)
end
function playHpRect:draw(x, y)  
    playHpRect.super.draw(self, x, y)
end
return {
    playHpRect = playHpRect,
    HpRect = HpRect,
    trackFade = trackFade
}
