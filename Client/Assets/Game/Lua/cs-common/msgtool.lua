-- local cmsgpack = require "cmsgpack"
local protocal = require "cs-common.protocal"
local util = require "cs-common.utils"
local cjson = require "cjson"

local protoNameTbl = {};

for key, value in pairs(protocal) do  
    protoNameTbl[value] = key  
end 

return {
	encode = function ( route, data )
		local ok , msg_str = pcall(cjson.encode, {
                route = route,
                data = data
            })
		if not ok then
			print("invalid data to encode")
			return ""
		else
			return msg_str
		end
	end,


	decode = function ( buffer )
		local ok , tbl = pcall(cjson.decode, buffer)
		if not ok then
			print("invalid buffer to decode")
			return 0, nil
		else
			return tbl.route, tbl.data
		end
	end,

	getProtoName = function ( protoId )
		return protoNameTbl[protoId]
	end
}
