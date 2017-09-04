-- PlayerMgr.lua
-- Author : Dzq
-- Date : 2017-08-29
-- Last modification : 2017-08-29
-- Desc: Player管理类

module(..., package.seeall)

local playerList = {};	--控制器列表--
local modName = ""
local player = false	--自己--

function CoInit(mdName)
	modName = mdName
	require ('Modules/'..modName.."/Player")
	require ('Modules/'..modName.."/PlayerOther")
	-- log("PlayerMgr.Init----->>>");
end

function AddMainPlayer( id, info )
	player = Player.New()
	player:Init(info)
	AddPlayer(player)
	return player
end

function AddOtherPlayer( id, info )
	local p = OtherPlayer.New()
	p:Init(info)
	AddPlayer(p)
	return p
end


--添加panel--
function AddPlayer(id, p)
	if p == nil then
		logError("p 为空")
		return
	end
	
	if playerList[id] ~= nil then
		logError("PlayerMgr中重复添加 "..id)
		p = nil
		return
	end

	playerList[id] = p;
	return p
end

--获取player--
function Get(id)
	return playerList[id];
end


--更新
function Update()
	for id, player in pairs(playerList) do
		-- if id ~= nil and player:IsOnLine() == true then
			player:Update()
		-- end
	end
end

--移除panel--
function RemovePlayer(id)
	if playerList[id] ~= nil then
		playerList[id]:UnLoad()
	end
	playerList[id] = nil;
end

--卸载模块--
function UnLoad(modName)
	for _, player in pairs(playerList) do
		player:UnLoad()
	end
end
