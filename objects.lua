
 objects = require "libraries.classic.classic"

-- 创建类
trackFade = objects:extend()--创建一个跟着鼠标的同心圆

function trackFade:new()

end

function trackFade:update(dt)
    trackFade.px=love.mouse.getX()
    trackFade.py=love.mouse.getY()
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
    love.graphics.circle("line", self.px, self.py, 70, 25,15)
end




