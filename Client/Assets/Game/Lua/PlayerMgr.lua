-- PlayerMgr.lua
-- Author : Dzq
-- Date : 2017-08-29
-- Last modification : 2017-08-29
-- Desc: Player管理类

module(..., package.seeall)

local playerList = {};	--控制器列表--
local modName = ""
local mySelf = false	--自己--

function CoInit(mdName)
	modName = mdName


	

end

function AddMainPlayer(id, info)
	mySelf = Player.New()
	mySelf:Init(info)
	AddPlayer(id, mySelf)
	return mySelf
end

function AddOtherPlayer(id, info)
	local p = PlayerOther.New()
	p:Init(info)
	AddPlayer(id, p)
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

	playerList[id] = p
	return p
end

--获取player--
function Get(id)
	return playerList[id]
end

function GetAll()
	return playerList
end

function IsMyself(o)
	local p = GetMyself()
	if type(o) == "number" then
		return o == p:GetID()
	else
		return o == p
	end
end

--获取自己--
function GetMyself()
	return mySelf
end

function GetMyselfID()
	return mySelf:GetID()
end

function GetName(userId)
	local p
	if not userId then
		p = player
	else
		p = Get(userId)
	end
	if p ~= nil then
		return p:GetName()
	end
	logError('未找到玩家--'..tostring(userId))
	return
end

function GetGold(userId)
	local p
	if not userId then
		p = player
	else
		p = Get(userId)
	end
	if p ~= nil then
		return p:GetGold()
	end
	logError('未找到玩家--'..tostring(userId))
	return
end

function GetDiamond(userId)
	local p
	if not userId then
		p = player
	else
		p = Get(userId)
	end
	if p ~= nil then
		return p:GetDiam()
	end
	logError('未找到玩家--'..tostring(userId))
	return
end

----获取玩家属性值
function GetAttr(attr, userId)
	local p
	if not userId then
		p = player
	else
		p = Get(userId)
	end
	if p ~= nil then
		return p:Get(attr)
	end
	logError('未找到玩家--'..tostring(userId))
	return
end

--更新
function Update()
	for id, player in pairs(playerList) do
		-- if id ~= nil and player:IsOnLine() == true then
			player:Update()
		-- end
	end
end

--移除player--
function RemovePlayer(o)
	local id = false
	if type(o) == "number" then
		id = o
	else
		id = o:GetID()
	end

	if not id then
		util.LogError("没有找到要删除玩家："..tostring(o))
		return
	end

	if playerList[id] ~= nil then
		playerList[id]:UnLoad()
	end
	playerList[id] = nil;
end

--卸载模块--
function UnLoad(modName)
	local my = GetMyself()
	for _, player in pairs(playerList) do
		if player ~= my then
			player:UnLoad()
			RemovePlayer(player:GetID())
			player = nil
		end
	end
end
