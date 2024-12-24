local class = require("oopsLua.class")

---@class Stack : Class
local Stack = class("Stack")

function Stack:ctor(initial_elements)
    self._elements = initial_elements or {}
    self._top = #self._elements
end

function Stack:IsEmpty()
    return self._top == 0
end

function Stack:Size()
    return self._top
end

function Stack:Push(element)
    self._top = self._top + 1
    self._elements[self._top] = element
end

function Stack:Pop()
    local top = self._top
    if top == 0 then
        return nil
    end
    local element = self._elements[top]
    self._elements[top] = nil
    self._top = top - 1
    return element
end

function Stack:Peek()
    return self._top > 0 and self._elements[self._top] or nil
end

function Stack:Clear()
    self:ctor()
end

return Stack