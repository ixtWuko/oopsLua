-- oopsLua by ixtWuko
-- A simple OOP implement of Lua

local function Construct(cls, inst, ...)
    if cls.__base then
        Construct(cls.__base, inst, ...)
    end
    if cls.ctor then
        cls.ctor(inst, ...)
    end
end

local function New(cls)
    return function(...)
        local inst = {}
        setmetatable(inst, cls)
        Construct(cls, inst,...)
        return inst
    end
end

local function IsInstanceOf(inst, cls)
    local proto = getmetatable(inst)
    while proto do
        if proto == cls then
            return true
        end
        proto = proto.__base
    end
    return false
end

local function class(name, base)
    local cls = { __class = name, __base = base }
    if base then
        setmetatable(cls, base)
    end
    cls.__index = cls

    cls.new = New(cls)
    cls.is = IsInstanceOf
    return cls
end

return class
