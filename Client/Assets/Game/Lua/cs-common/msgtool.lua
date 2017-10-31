-- local cmsgpack = require "cmsgpack"
local protocal = require "cs-common.protocal"
local util = require "cs-common.utils"
local cjson = require "cjson"

local protoNameTbl = {};
for key, value in pairs(protocal) do
    protoNameTbl[value] = key
end

cjson.encode_sparse_array(true)

return {
	encode = function ( route, data, session )
		local ok , msg_str = pcall(cjson.encode, {
                r = route,
                d = data,
                s = session
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
			return tbl.r, tbl.d, tbl.s
		end
	end,

	getProtoName = function ( protoId )
		return protoNameTbl[protoId]
	end,

	format = function ( code, data, msg)
		msg = msg or ""
		return { code = code, data = data, msg = msg}
	end
}
