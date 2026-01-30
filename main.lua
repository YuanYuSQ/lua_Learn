class = require "libraries.classic.classic"
Timer = require "libraries.hump.timer"
Input = require "libraries.input.Input"
--obj = require "objects" -- 引入 objects.lua 文件
function love.load()
    love.math.setRandomSeed(os.time()) -- 设置随机种子
    --自动加载 objects 文件夹下的所有类


    love.window.setMode(800, 600) -- 可替换为你想要的窗口尺寸

    local object_files = {}
    object_files = recursiveEnumerate("objects", object_files)
    requireFiles(object_files)
    wx = love.graphics.getWidth()
    wy = love.graphics.getHeight()

    GameObject = _G["GameObject"] --确保全局可访问GameObject类
    input = Input()
    timer = Timer()
    area = Area.Area
    room = Room.room
    rooms = {}
    current_room = nil
    addRoom("CircleFadeRoom", "CircleFade")
    addRoom("CircleRandom", "CircleRandom")
    addRoom('RectangleFade', "RectangleFade")

    input:bind("f1", "select CircleRandom")
    input:bind("f2", "select CircleFade")
    input:bind("f3", 'select RectangleFade')
    current_room = rooms["CircleFade"]
    current_room:active()
end

function random(min, max)
    if not max then -- if max is nil then it means only one value was passed in
        return love.math.random() * min
    else
        if min > max then min, max = max, min end
        return love.math.random() * (max - min) + min
    end
end

function love.update(dt)
    timer:update(dt)

    if input:pressed("select CircleRandom") then
        print("Switching to CircleRandom")
        gotoRoom("CircleRandom", "CircleRandom")
    end

    if input:pressed("select CircleFade") then
        gotoRoom("CircleFade", "CircleFade")
    end
    if input:pressed("select RectangleFade") then
        gotoRoom("RectangleFade", "RectangleFade")
    end

    if current_room then
        current_room:update(dt)
    end
end

function love.draw()
    if current_room then
        current_room:draw()
    end
end

function recursiveEnumerate(folder, file_list) -- 递归枚举文件夹中的所有文件
    -- 容错：确保 file_list 是有效表（避免传入 nil 导致报错）
    file_list = file_list or {}
    -- 容错：确保 folder 路径合法（首尾无多余斜杠）
    folder = folder:gsub("/+$", "")

    -- 获取文件夹下的所有项（文件/子文件夹）
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file_path = folder .. '/' .. item

        -- 核心修改：用 getInfo 获取文件/目录信息（替代过时函数）
        local file_info = love.filesystem.getInfo(file_path)
        if not file_info then
            -- 跳过不存在/无权限的项（增强健壮性）
            goto continue
        end

        if file_info.type == "file" then
            -- 是文件：加入列表
            table.insert(file_list, file_path)
        elseif file_info.type == "directory" then
            -- 是目录：递归枚举
            recursiveEnumerate(file_path, file_list)
        end

        ::continue:: -- Lua 标签，用于跳过无效项
    end

    return file_list -- 返回结果（方便调用时直接获取）
end

function requireFiles(files) --批量require文件
    for _, file in ipairs(files) do
        local className = file:match("([^/]+)%.lua$")
        local file = file:sub(1, -5)
        local res = require(file)
        if type(res) == "table" then
            -- Export all keys from the module into the global namespace
            for k, v in pairs(res) do _G[k] = v end
            -- Also keep the module table available under its filename
            _G[className] = res
        else
            _G[className] = res
        end
    end
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
