-- SettingCfg.lua
-- Author : Dzq
-- Date : 2017-05-20
-- Last modification : 2017-07-16
-- Desc: 设置配置
local _M = { }

_M.cfg = {
	{ id = 1, content = "b_", desc = "男生"},
	{ id = 2, content = "g_", desc = "女生"},
	{ id = 3, content = "b_", desc = "男生"},
	{ id = 4, content = "g_", desc = "女生"},
	{ id = 5, content = "b_", desc = "男生"},
}

function _M.GetCfg( id )
	log("GetCfg --- "..id)
end