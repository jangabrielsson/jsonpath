local sortKeys = { "type", "device", "deviceID", "value", "oldValue", "val", "key", "arg", "event", "events", "msg",
    "res" }
local sortOrder = {}
for i, s in ipairs(sortKeys) do sortOrder[s] = "\n" .. string.char(i + 64) .. " " .. s end
local function keyCompare(a, b)
    local av, bv = sortOrder[a] or a, sortOrder[b] or b
    return av < bv
end

-- our own json encode, as we don't have 'pure' json structs, and sorts keys in order (i.e. "stable" output)
local function prettyJsonFlat(e0)
    local res, seen = {}, {}
    local function pretty(e)
        local t = type(e)
        if t == 'string' then
            res[#res + 1] = '"'
            res[#res + 1] = e
            res[#res + 1] = '"'
        elseif t == 'number' then
            res[#res + 1] = e
        elseif t == 'boolean' or t == 'function' or t == 'thread' or t == 'userdata' then
            res[#res + 1] = tostring(e)
        elseif t == 'table' then
            if next(e) == nil then
                res[#res + 1] = '{}'
            elseif seen[e] then
                res[#res + 1] = "..rec.."
            elseif e[1] or #e > 0 then
                seen[e] = true
                res[#res + 1] = "["
                pretty(e[1])
                for i = 2, #e do
                    res[#res + 1] = ","
                    pretty(e[i])
                end
                res[#res + 1] = "]"
            else
                seen[e] = true
                if e._var_ then
                    res[#res + 1] = format('"%s"', e._str)
                    return
                end
                local k = {}
                for key, _ in pairs(e) do k[#k + 1] = tostring(key) end
                table.sort(k, keyCompare)
                if #k == 0 then
                    res[#res + 1] = "[]"
                    return
                end
                res[#res + 1] = '{'; res[#res + 1] = '"'
                res[#res + 1] = k[1]; res[#res + 1] = '":'
                t = k[1]
                pretty(e[t])
                for i = 2, #k do
                    res[#res + 1] = ',"'
                    res[#res + 1] = k[i]; res[#res + 1] = '":'
                    t = k[i]
                    pretty(e[t])
                end
                res[#res + 1] = '}'
            end
        elseif e == nil then
            res[#res + 1] = 'null'
        else
            error("bad json expr:" .. tostring(e))
        end
    end
    pretty(e0)
    return table.concat(res)
end
json = { encode = prettyJsonFlat }
