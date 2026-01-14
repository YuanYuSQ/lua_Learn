require "libraries.classic.classic"
require "objects"
Timer =require "libraries.hump.timer"
--obj = require "objects" -- 引入 objects.lua 文件
function love.load()
    timer = Timer()
    hpRect={max=100,min=0,current,hpcolor={255/255,89/255,89/255},bkcolor={226/255,37/255,50/255},bkrectside={x=200,y=35},rectside={x=200,y=35},pos={x=100,y=100},speed=8,faderectside={x=200,y=35}} 
    hpRect.current=hpRect.max
    timer:after(2,function() 
    print("2 seconds have passed", 400, 300)
    end)
    print(hpRect.max);
    
end

function love.update(dt)
    timer:update(dt)
    
end

function love.draw()
 love.graphics.setColor(hpRect.bkcolor)
 love.graphics.rectangle("fill",love.graphics.getWidth()/2-hpRect.pos.x,love.graphics.getHeight()/2-hpRect.bkrectside.y/2,hpRect.bkrectside.x,hpRect.bkrectside.y) --HP背景
 love.graphics.setColor(hpRect.hpcolor)
 love.graphics.rectangle("fill",love.graphics.getWidth()/2-hpRect.pos.x,love.graphics.getHeight()/2-hpRect.rectside.y/2,hpRect.rectside.x,hpRect.rectside.y)  --血量
 love.graphics.setColor(1,1,1)
 love.graphics.print("HP rectside.x="..hpRect.rectside.x, 10, 10)
 love.graphics.print("current HP :"..hpRect.current, 10, 30)
end

function love.mousepressed(x , y , button , isTouch , presses)  
    if button== 1 and hpRect.rectside.x > 0 then
            hpRect.current=hpRect.current -10
            hpRect.current=math.max(hpRect.current,hpRect.min)
            hpRect.faderectside.x= (hpRect.current/hpRect.max)*200
            timer:tween(0.3,hpRect,{rectside={x=hpRect.faderectside.x}},'in-linear',function ()
                    timer:tween(0.3,hpRect,{bkrectside = {x=hpRect.rectside.x}}, 'in-quad')
                
            end)
        end
    
end
