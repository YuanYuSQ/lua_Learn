class = require "libraries.classic.classic"

testClass = class:extend()
function testClass:printAllStr(...)
    args = {...}
    local str=''
    for _, value in ipairs(args) do
        str = str .. value
    end
print(str)
end

function testClass:printAll(...)
    args = {...}
    for _, arg in ipairs(args) do
        print(arg)
    end

end