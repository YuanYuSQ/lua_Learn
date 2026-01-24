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
    rooms = {}
    current_room = nil
    addRoom("room", "block_room")
    addRoom("room", "circle_room", { side = "circle" })
    addRoom("room", "square_room", { side = 4 })
    addRoom("room", "polygon_room", { side = 3 })
    input:bind("f1", "select CircleRoom")
    input:bind("f2", "select SquareRoom")
    input:bind("f3", "select PolygonRoom")
    current_room = rooms["block_room"]
    current_room:active()
    timer:after(1, function() print("One second has passed!") end)
       timer:every(5, printTime )


   
end

function addRoom(room_type, room_name, args)
    rooms[room_name] = _G[room_type](room_name, args)
    print("Added room: " .. room_name)
    print(rooms[room_name].name, rooms[room_name].type, rooms[room_name].side)
    return rooms[room_name] --返回room便于直接修改,不用再去rooms表里找
end

function gotoRoom(room_type, room_name, args)
    print("Switching to room: " .. room_name)

    if current_room and rooms[room_name] then
        print(room_name .. " is now active.")
        if current_room.deactive then
            current_room:deactive()
        end
        current_room = rooms[room_name]
        if current_room.active then
            current_room:active()
        end
    else
        current_room = addRoom(room_type, room_name, args)
        print("Created and switched to new room: " .. current_room.name)
    end
end

function printTime()
    print("Current Time: " .. os.time())
end

function love.update(dt)
    timer:update(dt)



    if input:pressed("select CircleRoom") then
        print("Switching to CircleRoom")
        gotoRoom("room", "circle_room")
    end
    if input:pressed("select SquareRoom") then
        gotoRoom("room", "square_room")
    end
    if input:pressed("select PolygonRoom") then
        gotoRoom(nil, "polygon_room")
    end
    if current_room then
        current_room:update(dt)
    end
end

function love.draw()
    
    if current_room then
        current_room:drawShape("fill", current_room.side)
    end
end
