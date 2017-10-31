local cards = require "cs-common.mahjong.cards"
local bit = require "cs-common.bit"

local M = {}

function M.str_2_table(str)
    local func_str = "return "..str
    local func = load(func_str)
    return func()
end


local function serialize(obj)
    local lua = ""
    local t = type(obj)
    if t == "number" then
        lua = lua .. obj
    elseif t == "boolean" then
        lua = lua .. tostring(obj)
    elseif t == "string" then
        lua = lua .. string.format("%q", obj)
    elseif t == "table" then
        lua = lua .. "{"
        for k, v in pairs(obj) do
            lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ","
        end
        local metatable = getmetatable(obj)
        if metatable ~= nil and type(metatable.__index) == "table" then
            for k, v in pairs(metatable.__index) do
                lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ","
            end
        end
        lua = lua .. "}"
    elseif t == "nil" then
        return "nil"
    elseif t == "userdata" then
        return "userdata"
    elseif t == "function" then
        return "function"
    elseif t == "thread" then
        return "thread"
    else
        error("can not serialize a " .. t .. " type.")
    end
    return lua
end

M.table_2_str = serialize

function M.print(o)
    print(serialize(o))
end

function M.print_array(o)
    local str = "{"
    for k,v in ipairs(o) do
        str = str .. serialize(v) .. ","
    end
    str = str .. "}"
    print(str)
end

function M.dump_table_2_file(tbl, name)
    local str = M.table_2_str(tbl)

    str = "return "..str
    local file = io.open(name, "w");
    file:write(str)
    file:close()
end

function M.copy_array(t)
    local tmp = {}
    for _,v in ipairs(t) do
        table.insert(tmp, v)
    end

    return tmp
end

function M.get_card_name(id)
    if type(id) ~= "number" then
        return
    end

    local typeIdx = bit.andOp(id, 0xF0)
    local numIdx = bit.andOp(id, 0x0F)

    if typeIdx >= 0x40 then
        return cards.cardNameDefine[id]
    end

    return M.NumName[numIdx]..cards.cardNameDefine[typeIdx]
end

M.NumName = {
    [0] = "零",
    [1] = "一",
    [2] = "二",
    [3] = "三",
    [4] = "四",
    [5] = "五",
    [6] = "六",
    [7] = "七",
    [8] = "八",
    [9] = "九",
    [10] = "十",
}

return M
