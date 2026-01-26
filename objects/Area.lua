class = require "libraries.classic.classic"

--区域,在room下划分更小的区域,每个区域有自己的gameobject列表
Area = class:extend()

function Area:new(room)
    self.isactive =false
    self.room = room
    self.game_objects = {}
    self.timer=Timer:new()
 self.timer:every(4,function ()
    for _, i in ipairs(self.game_objects)do
        print (i.dead) 
        print("dead")
end
    
 end)

    
end

function Area:update(dt)
    --循环采用倒序方式，从列表末尾向开头遍历。这是因为如果在正向遍历 Lua 表时删除元素会导致某些元素被跳过
    if self.active ==true then
        self.timer:update(dt)
    end
        for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:update(dt)
        if game_object.dead then table.remove(self.game_objects, i)end
    end
end

function Area:draw()
    for _, game_object in ipairs(self.game_objects) do game_object:draw() end
end

function Area:active()
    self.isactive=true
end
function Area:deactive()
     self.isactive=false
end
function Area:addGameObject(game_object_type, x, y, opts)
    local opts = opts or {}
    local game_object = _G[game_object_type](self, x or 0, y or 0, opts)
    table.insert(self.game_objects, game_object)
    return game_object
end

return {Area =Area}