require "libraries.classic.classic"
obj = require "objects"
Timer = require "libraries.hump.timer"
Input = require "libraries.input.Input"
--obj = require "objects" -- 引入 objects.lua 文件
function love.load()
    input = Input()
    timer = Timer()

    input:bind("mouse1", "click")
    input:bind("mouse2", "rightclick")
    input:bind("q", "hurt")
    hpRect = obj.HpRect()
    playHpRect = obj.playHpRect({ x = 150, y = 20 }, { x = 0, y = 0 })
    print(hpRect)

    timer:after(2, function()
        print("2 seconds have passed", 400, 300)
    end)
    --print(hpRect.max);
end

function love.update(dt)
    timer:update(dt)
    if input:pressed("hurt") and hpRect.rectside.x > 0 then
        hpRect:hurt(10)
    end
    if input:pressed("click") then
        playHpRect:hurt(10)
    end
end

function love.draw()
    --hpRect:draw()
    playHpRect:draw(5,50)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("HP rectside.x=" .. playHpRect.rectside.x, 10, 10)
    love.graphics.print("current HP :" .. playHpRect.currenthp, 10, 30)
end

function love.mousepressed(x, y, button, isTouch, presses)

end
