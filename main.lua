require "libraries.classic.classic"
require "objects"
--obj = require "objects" -- 引入 objects.lua 文件

function love.load() --初始化函数
    testInstance = test()  -- 创建类的实例
    testInstanceExtend  =testExtend()
end

function love.update(dt)  --更新函数
     
end

function love.draw()   --绘制函数
    testInstance:draw()
    testInstanceExtend:draw()
end