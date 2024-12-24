local class = require("oopsLua.class")

---@class Queue : Class
local Queue = class("Queue")

function Queue:ctor(initial_elements)
    self._elements = initial_elements or {}
    self._head = 1
    self._tail = #self._elements + 1
end

function Queue:IsEmpty()
    return self._tail == self._head
end

function Queue:Size()
    return self._tail - self._head
end

function Queue:Enqueue(element)
    self._elements[self._tail] = element
    self._tail = self._tail + 1
end

function Queue:Dequeue()
    if self._tail == self._head then
        return
    end
    local element = self._elements[self._head]
    self._head = self._head + 1
    return element
end

function Queue:First()
    return self._elements[self._head]
end

function Queue:Clear()
    self:ctor()
end

return Queue