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


function Area:getGameObjects(checkfunction)  --传入检查函数,返回符合标准的游戏对象集合
local out ={}
    for index, value in ipairs(game_objects) do
        if checkfunction(value) then
            table.insert(out,value)
        end
    end
    return out
end

-- 在 and 运算中，只要有两个变量为真，返回的结果总是第二个变量。
--这在许多情况下很有用，比如上一个练习中的代码行 if e.hp and e.hp >= 50 then 就是在检查 e.hp 是否存在
--如果存在则进一步判断该值是否大于 50。如果 e.hp 不存在，结果就是 nil 
--后续检查甚至不会执行（如果执行会导致错误，因为无法对 nil >= 50 进行判断）

--当 or 操作中的两个变量都为真时，总是会返回第一个变量。
--这在许多情况下很有用，比如当我们进行类似 opts = opts or {} 这样的操作时。如果传入的 opts 是 nil ，那么 or 将返回空表。
--但如果 opts 值已定义，那么它就会直接返回 opts 本身

--用法getGameObject(function)
--[[health_objects= Area:getGameObjects( function (e)  if  e.hp and e.hp >50  then
    return true
end
    
end  )
]]


function Area:addGameObject(game_object_type, x, y, opts)
    local opts = opts or {}
    -- Resolve constructor: it might be a global or a key inside a module table
    local ctor = _G[game_object_type]
    if not ctor then
        for k, v in pairs(_G) do
            if type(v) == "table" and v[game_object_type] then
                ctor = v[game_object_type]
                break
            end
        end
    end
    if not ctor then
        local keys = {}
        for k,_ in pairs(_G) do table.insert(keys, k) end
        error("Unknown game object type: " .. tostring(game_object_type) .. ". Available globals: " .. table.concat(keys, ", "))
    end
    local game_object = ctor(self, x or 0, y or 0, opts)
    table.insert(self.game_objects, game_object)
    return game_object
end


return {Area =Area}