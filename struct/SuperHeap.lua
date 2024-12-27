local class = require("oopsLua.class")
local Heap = require("LuaLib.structs.Heap")

---@class SuperHeap : Class
local SuperHeap = class("SuperHeap")

function SuperHeap:ctor()
    self.entire = Heap.new()
    self.remove = Heap.new()
end

function SuperHeap:Push(element)
    self.entire:Push(element)
end

function SuperHeap:Pop()
    while self.remove:Size() > 0 and self.remove:Top() == self.entire:Top() do
        self.remove:Pop()
        self.entire:Pop()
    end
    self.entire:Pop()
end

function SuperHeap:Remove(element)
    self.remove:Push(element)
end

function SuperHeap:Size()
    return self.entire:Size() - self.remove:Size()
end

function SuperHeap:Top()
    while self.remove:Size() > 0 and self.remove:Top() == self.entire:Top() do
        self.remove:Pop()
        self.entire:Pop()
    end
    self.entire:Top()
end

return SuperHeap
