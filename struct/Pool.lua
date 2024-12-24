local class = require("oopsLua.class")

---@class Pool : Class
local Pool = class('Pool')

function Pool:ctor(object, capacity)
    self._pool = {}
    self.object = object
    self.capacity = capacity
end

function Pool:Take(...)
    local len = #self._pool
    if len > 0 then
        local object = self._pool[len]
        self._pool[len] = nil
        object:reset(...)
        return object
    end
    return self.object.new(...)
end

function Pool:Free(object)
    if not object:is(self.object) then
        return
    end
    local len = #self._pool
    if len < self.capacity then
        self._pool[len + 1] = object
    end
end

return Pool