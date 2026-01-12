
local objects = require "libraries.classic.classic"

-- 创建类
local test = objects:extend()

test.name = "test"  

function test:new()
end

function test:update(dt)
    self.super.update(self, dt)
end

function test:draw()
    love.graphics.circle("fill", 400, 300, 50)
end



--testInstance = test()  -- 创建类的实例

local testExtend = test:extend()

testExtend.name = "testExtend"

function testExtend:new()
end

function testExtend:update(dt)
    self.super.update(self, dt)
end

function testExtend:draw()
    love.graphics.circle("line", 400, 300, 70)
end

-- 导出类以供外部使用
return {
    test = test,
    testExtend = testExtend,
}