local class = require("oopsLua.class")

---@class DoubleBuffer : Class
local DoubleBuffer = class("DoubleBuffer")

function DoubleBuffer:ctor()
    self.frontBuffer = {}
    self.backBuffer = {}
end

function DoubleBuffer:GetFrontBuffer()
    return self.frontBuffer
end

function DoubleBuffer:GetBackBuffer()
    return self.backBuffer
end

function DoubleBuffer:Swap()
    self.frontBuffer, self.backBuffer = self.backBuffer, self.frontBuffer
end

return
