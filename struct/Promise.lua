---@class Promise : Class
local Promise = class("Promise")

local STATE = {
    PENDING = 1,
    FULFILLED = 2,
    REJECTED = 3
}

---@alias Resolve fun(result:any)
---@alias Reject fun(reason:string)
---@alias Executor fun(resolve:Resolve, reject:Reject)
---@alias OnFulfilled fun(result:any):Promise|any
---@alias OnRejected fun(reason:string):Promise|any

local function Pass(value)
    return value
end

local function IsPromise(object)
    return getmetatable(object) == Promise
end

local function ResolveImpl(promise, result)
    if promise.state == STATE.PENDING then
        promise.state = STATE.FULFILLED
        promise.result = result
        for _, fulfilledCallback in ipairs(promise.fulfilledCallbacks) do
            fulfilledCallback(result)
        end
    end
end

local function RejectImpl(promise, reason)
    if (promise.state == STATE.PENDING) then
        promise.state = STATE.REJECTED
        promise.reason = reason
        for _, rejectedCallback in ipairs(promise.rejectedCallbacks) do
            rejectedCallback(reason)
        end
    end
end

local function DeliverResolveImpl(input, resolve, reject, onFulfilled)
    local result = onFulfilled(input)
    if IsPromise(result) then
        if result.state == STATE.PENDING then
            result:Then(resolve, reject)
        else
            resolve(result.result)
        end
    else
        resolve(result)
    end
end

local function DeliverRejectImpl(input, resolve, reject, onRejected)
    local reason = onRejected(input)
    if IsPromise(reason) then
        if reason.state == STATE.PENDING then
            reason:Then(resolve, reject)
        else
            reject(reason.reason)
        end
    else
        reject(reason)
    end
end

---@param before Promise
local function ThenExecutor(before, resolve, reject, onFulfilled, onRejected)
    local deliverResolve = function(result)
        DeliverResolveImpl(result, resolve, reject, onFulfilled)
    end
    local deliverReject = function(reason)
        DeliverRejectImpl(reason, reject, reject, onRejected)
    end

    if before.state == STATE.FULFILLED then
        deliverResolve(before.result)
    elseif before.state == STATE.REJECTED then
        deliverReject(before.reason)
    elseif before.state == STATE.PENDING then
        table.insert(before.fulfilledCallbacks, deliverResolve)
        table.insert(before.rejectedCallbacks, deliverReject)
    end
end


---@param executor Executor
---@return Promise
function Promise:ctor(executor)
    self.state = STATE.PENDING
    self.result = nil
    self.reason = nil
    self.fulfilledCallbacks = {}
    self.rejectedCallbacks = {}

    executor(function(result) ResolveImpl(self, result) end,
        function(reason) RejectImpl(self, reason) end)
end

---@param onFulfilled OnFulfilled
---@param onRejected OnRejected
function Promise:Then(onFulfilled, onRejected)
    onFulfilled = onFulfilled or Pass
    onRejected = onRejected or Pass

    local promise
    promise = Promise.new(function(resolve, reject)
        ThenExecutor(self, resolve, reject, onFulfilled, onRejected)
    end)
    return promise
end

function Promise:Catch(callback)
    return self:Then(nil, callback)
end

function Promise:Finally(callback)
    return self:Then(callback, callback)
end

function Promise:Resolve(value)
    return Promise.new(function(resolve, reject)
        resolve(value)
    end)
end

function Promise:Reject(reason)
    return Promise.new(function(resolve, reject)
        reject(reason)
    end)
end

function Promise:All(promises)
    local count = #promises
    local results = {}
    local promise = Promise.new(function(resolve, reject)
        for i, p in ipairs(promises) do
            p:Then(function(result)
                results[i] = result
                count = count - 1
                if count == 0 then
                    resolve(results)
                end
            end, reject)
        end
    end)
    return promise
end

function Promise:Race(promises)
    local promise = Promise.new(function(resolve, reject)
        for i, p in ipairs(promises) do
            p:Then(resolve, reject)
        end
    end)
    return promise
end

return Promise
