local class = require("oopsLua.class")

---@class Heap : Class
local Heap = class("Heap")

function Heap:ctor()
    self.size = 0
    self.elements = {}
end

local function GetParentIndex(index)
    local parent = index // 2
    if parent > 0 then
        return parent
    end
end

local function Swim(elements, index)
    if index <= 0 or index > #elements then
        return
    end
    local parent = GetParentIndex(index)
    while parent and elements[index] < elements[parent] do
        elements[index], elements[parent] = elements[parent], elements[index]
        index = parent
        parent = GetParentIndex(index)
    end
end


local function GetSmallerSonIndex(elements, index, size)
    local fst = index * 2
    if fst <= size then
        local snd = index * 2 + 1
        if snd <= size then
            return elements[fst] < elements[snd] and fst or snd
        else
            return fst
        end
    end
end

local function Sink(elements, index)
    local size = #elements
    if index <= 0 or index > size then
        return
    end
    local son = GetSmallerSonIndex(elements, index, size)
    while son do
        if elements[son] >= elements[index] then
            break
        end
        elements[son], elements[index] = elements[index], elements[son]
        index = son
        son = GetSmallerSonIndex(elements, index, size)
    end
end

function Heap:Push(element)
    local size = self.size + 1
    self.size = size
    self.elements[size] = element
    if size > 1 then
        Swim(self.elements, size)
    end
end

function Heap:Pop()
    local size = self.size
    self.elements[1] = self.elements[size]
    self.elements[size] = nil
    self.size = size - 1
    if self.size > 1 then
        Sink(self.elements, 1)
    end
end

function Heap:Size()
    return self.size
end

function Heap:Top()
    return self.elements[1]
end

return Heap
