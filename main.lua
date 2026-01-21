require "libraries.classic.classic"
class = require "objects"
Timer = require "libraries.hump.timer"
Input = require "libraries.input.Input"
game = require "game"
--obj = require "objects" -- 引入 objects.lua 文件
function love.load()
    input = Input()
    timer = Timer()
    room = game.room

    CircleRoom = room("CircleRoom", "circular","circle")
    SquareRoom = room("SquareRoom", "square",4)
    PolygonRoom = room("PolygonRoom", "polygon")
    input:bind("f1", "select CircleRoom")
    input:bind("f2", "select SquareRoom")
    input:bind("f3", "select PolygonRoom")
   
    rooms={}
    current_room = nil


end

function love.update(dt)
  if input:pressed("select CircleRoom") then
        current_room = CircleRoom
    elseif input:pressed("select SquareRoom") then
        current_room = SquareRoom
    elseif input:pressed("select PolygonRoom") then
        current_room = PolygonRoom
    end
end

function love.draw()
    if current_room then
        current_room:drawShape("fill", current_room.side)
    end
   

end

