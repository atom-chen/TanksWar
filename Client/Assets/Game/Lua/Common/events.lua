--[[
Auth:Chiuan
like Unity Brocast Event System in lua.
]]

local EventLib = require "Common/eventlib"

local Event = {}
local events = {}


function Event.AddListener(event,handler,obj)
	if not event or type(event) ~= "string" then
		error("event parameter in addlistener function has to be string, " .. type(event) .. " not right.")
	end
	if not handler or type(handler) ~= "function" then
		error("handler parameter in addlistener function has to be function, " .. type(handler) .. " not right")
	end

	-- if not obj then
	-- 	print("希望传入接收消息对象 避免覆盖注册或重复注册 event--"..event)
	-- end

	local eventList = events[event]
	
	local e = {}
	e.obj = obj

	if not eventList then
		--create the Event with name
		-- events[event] = EventLib:new(event)	--一条消息只能对应一个handle？？？？
		eventList = {}

		e.event = EventLib:new(event)
		eventList[#eventList+1] = e
	else
		for i=1, #eventList do
			if eventList[i].obj == obj then
				error("消息重复注册--id - "..event)
				return
			end
		end

		e.event = EventLib:new(event)
		eventList[#eventList+1] = e
	end
	events[event] = eventList
	-- util.Log("eventList -- "..#eventList)
	--conn this handler
	e.event:connect(handler)
end

--event列表里的所有对象都会发送
function Event.Brocast(event,...)
	local eventList = events[event]
	if not eventList then
		log("brocast " .. event .. " has no event.")
	else
		for i=1, #eventList do
			local e = eventList[i]
			if not e.obj then
				e.event:fire(...)
			else
				e.event:fire(e.obj, ...)
			end
		end
	end
end

function Event.RemoveListener(event,handler,obj)
	-- if not obj then
	-- 	print("希望传入接收消息对象 避免覆盖注册或重复注册 event--"..event)
	-- end

	local eventList = events[event]
	if not eventList then
		error("remove " .. event .. " has no event.")
	else
		for i=1, #eventList do
			local e = eventList[i]
			if not obj then 
				e.event:disconnect(handler)
				eventList[i] = nil
			else
				if e.obj == obj then
					e.event:disconnect(handler)
					eventList[i] = nil
				end
			end
		end
	end
end

return Event