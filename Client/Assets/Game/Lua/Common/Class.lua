-- Class.lua
-- Author : Dzq
-- Date : 2017-05-18
-- Last modification : 2017-05-18
-- Desc: class类

local _class = {}
 
function Class(Super)
	local class_type = {}
	class_type.Ctor = false
	class_type.Super = Super
	class_type.New = function(...) 
			local obj = {}
			do
				local create
				create = function(c,...)
					if c.Super then
						create(c.Super,...)
					end
					if c.Ctor then
						c.Ctor(obj,...)
					end
				end
 
				create(class_type,...)
			end
			setmetatable(obj,{ __index=_class[class_type] })
			return obj
		end
	local vtbl = {}
	_class[class_type] = vtbl
 
	setmetatable(class_type,{__newindex =
		function(t,k,v)
			vtbl[k] = v
		end
	})
 
	if Super then
		setmetatable(vtbl,{__index =
			function(t,k)
				local ret = _class[Super][k]
				vtbl[k] = ret
				return ret
			end
		})
	end
 
	return class_type
end