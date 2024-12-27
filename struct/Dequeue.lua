local class = require("oopsLua.class")

---@class Dequeue : Class
local Dequeue = class('Dequeue')

function Dequeue:ctor(initial_elements)
    self._elements = initial_elements or {}
    self._head = 1
    self._tail = #self._elements + 1
end

function Dequeue:IsEmpty()
    return self._tail == self._head
end

function Dequeue:Size()
    return self._tail - self._head
end

function Dequeue:PutLeft(element)
    self._head = self._head - 1
    self._elements[self._head] = element
end

function Dequeue:PutRight(element)
    self._elements[self._tail] = element
    self._tail = self._tail + 1
end

function Dequeue:PopLeft()
    if self._tail == self._head then
        return nil
    end
    local ret = self._elements[self._head]
    self._elements[self._head] = nil
    self._head = self._head + 1
    return ret
end

function Dequeue:PopRight()
    if self._tail == self._head then
        return nil
    end
    self._tail = self._tail - 1
    local ret = self._elements[self._tail]
    self._elements[self._tail] = nil
    return ret
end

function Dequeue:Clear()
    self:ctor()
end

return Dequeue
