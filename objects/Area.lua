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


--接收一个 x 、 y 位置坐标，一个 radius 以及包含目标类名称的字符串列表。
--然后返回以 x, y 位置为中心、半径为 radius 的圆形区域内属于这些类的所有对象。
-- objects = area:queryCircleArea(100, 100, 50, {'Enemy', 'Projectile'})  
function Area:queryCircleArea(x,y,radius)
    local out={}
    self:getGameObjects(function (e)
       if  getDistance(e,x,y)<radius then
        return true
       end
    end)
end


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

function getDistance(...)
    local args = {...}  -- 接收可变参数，转为局部参数表（避免污染全局）
    local x1, y1, x2, y2  -- 最终要提取的两个点的坐标

    -- 辅助校验函数：判断一个对象是否包含有效的 x、y 坐标（数字类型）
    local function isValidPointObj(obj)
        return type(obj) == "table" 
            and type(obj.x) == "number" 
            and type(obj.y) == "number"
    end

    -- 分支1：参数形式 → x1, y1, x2, y2（4个数值参数）
    if #args == 4 then
        local a, b, c, d = args[1], args[2], args[3], args[4]
        -- 校验四个参数是否都是数字
        if type(a) == "number" and type(b) == "number" and type(c) == "number" and type(d) == "number" then
            x1, y1, x2, y2 = a, b, c, d
        else
            return nil, "错误：4个参数必须全为数字（对应 x1,y1,x2,y2）"
        end

    -- 分支2：参数形式 → obj1, obj2（2个带x/y的对象）
    elseif #args == 2 then
        local obj1, obj2 = args[1], args[2]
        -- 校验两个对象是否都包含有效 x、y 坐标
        if isValidPointObj(obj1) and isValidPointObj(obj2) then
            x1, y1 = obj1.x, obj1.y
            x2, y2 = obj2.x, obj2.y
        else
            return nil, "错误：2个参数必须都是带 x、y 数字属性的对象"
        end

    -- 分支3：参数形式 → obj, x, y（1个对象 + 2个数值）
    elseif #args == 3 then
        local obj, a, b = args[1], args[2], args[3]
        -- 校验对象有效，且后两个参数是数字
        if isValidPointObj(obj) and type(a) == "number" and type(b) == "number" then
            x1, y1 = obj.x, obj.y
            x2, y2 = a, b
        else
            return nil, "错误：3个参数必须是「带x/y的对象 + 两个数字」（对应 obj,x,y）"
        end

    -- 无效参数个数
    else
        return nil, "错误：不支持的参数个数，仅支持 2/3/4 个参数"
    end

    -- 核心：计算欧几里得距离
    local dx = x2 - x1  -- x 轴差值
    local dy = y2 - y1  -- y 轴差值
    local distance = math.sqrt(dx * dx + dy * dy)  -- 平方和开根号

    return distance  -- 返回计算结果
end

return {Area =Area}